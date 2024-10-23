/obj/vehicle/multitile/fieldgun
	name = "\improper M10 LongHaul Field Gun"
	desc = "What is bascially a two wheeled cart that can carry insanely large weapons"
	icon = 'icons/obj/vehicles/fieldgun.dmi'
	var/seat = null //we are gonna have to make the seat and the gun the same object
	var/obj/vehicle/multitile/fieldgun/vehicle = null
	icon_state = "fg_base"

	pixel_x = -48
	pixel_y = -48

	bound_width = 32
	bound_height = 32


	health = 800

	can_buckle = TRUE //and here we go,
	seat = VEHICLE_GUNNER

	interior_map = null //fully open vehicle, so no need for any slots or maps

	passengers_slots = 0
	xenos_slots = 0

	breach = list(0,1)

	entrances = null


	movement_sound = 'sound/vehicles/tank_driving.ogg'
	honk_sound = 'sound/vehicles/honk_2_truck.ogg'

	required_skill = SKILL_VEHICLE_LARGE
	vehicle_flags = VEHICLE_CLASS_MEDIUM

	move_max_momentum = 1

	vehicle_light_range = 1

	hardpoints_allowed = list(
		/obj/item/hardpoint/primary/lightcannon,
		/obj/item/hardpoint/support/supp,
		/obj/item/hardpoint/armor/shield,
		/obj/item/hardpoint/locomotion/fieldgun_tires,
		/obj/item/hardpoint/optics/optic,
		/obj/item/hardpoint/trail/dualtrail,
	)


	seats = list(
		VEHICLE_GUNNER = null,
		VEHICLE_DRIVER = null,
	)

	active_hp = list(
		VEHICLE_GUNNER = null,
		VEHICLE_DRIVER = null,
	)

	dmg_multipliers = list(
		"all" = 1, //Everything is exposed, so any kind of damage is probably gonna break something
		"acid" = 1.5,
		"slash" = 2,
		"bullet" = 1,
		"explosive" = 1,
		"blunt" = 0.6,
		"abstract" = 1
	)

	explosive_resistance = 100

/obj/vehicle/multitile/fieldgun/Initialize()
	. = ..()
	vehicle = src //the seat is the gun and the gun is the seat is the gun and the gun is the seat.

/obj/vehicle/multitile/fieldgun/do_buckle(mob/living/target, mob/user)
	. = ..()
	if(!skillcheck(target, SKILL_VEHICLE, vehicle.required_skill))
		if(target == user)
			to_chat(user, SPAN_WARNING("You have no idea how to use this!"))
		return FALSE

	return ..()

/obj/vehicle/multitile/fieldgun/afterbuckle(mob/M)
	..()
	handle_afterbuckle(M)

/obj/vehicle/multitile/fieldgun/proc/handle_afterbuckle(mob/M)

	if(!vehicle)
		return

	if(QDELETED(buckled_mob))
		M.unset_interaction()
		vehicle.set_seated_mob(seat, null)
		if(M.client)
			M.client.pixel_x = 0
			M.client.pixel_y = 0
	else
		if(M.stat != CONSCIOUS)
			unbuckle()
			return
		vehicle.set_seated_mob(seat, M)


/obj/vehicle/multitile/fieldgun/unbuckle(mob/M)
	. = ..()
	seats[VEHICLE_GUNNER] = null

/obj/vehicle/multitile/fieldgun/set_seated_mob(seat, mob/living/M)
	. = ..()
	if(!.)
		return

/obj/vehicle/multitile/fieldgun/add_seated_verbs(mob/living/M, seat)
	if(!M.client)
		return
	add_verb(M.client, list(
		/obj/vehicle/multitile/proc/get_status_info,
		/obj/vehicle/multitile/proc/open_controls_guide,
		/obj/vehicle/multitile/proc/name_vehicle,
		/obj/vehicle/multitile/proc/activate_horn,
		/obj/vehicle/multitile/proc/switch_hardpoint,
		/obj/vehicle/multitile/proc/cycle_hardpoint,
	))

/obj/vehicle/multitile/fieldgun/remove_seated_verbs(mob/living/M, seat)
	if(!M.client)
		return
	remove_verb(M.client, list(
		/obj/vehicle/multitile/proc/get_status_info,
		/obj/vehicle/multitile/proc/open_controls_guide,
		/obj/vehicle/multitile/proc/name_vehicle,
		/obj/vehicle/multitile/proc/activate_horn,
		/obj/vehicle/multitile/proc/switch_hardpoint,
		/obj/vehicle/multitile/proc/cycle_hardpoint,
	))
	SStgui.close_uis(M, src)

/obj/vehicle/multitile/fieldgun/attackby(obj/item/O, mob/user)
	if(!istype(O, /obj/item/ammo_magazine/hardpoint))
		return ..()

	if(!skillcheck(user, SKILL_VEHICLE, SKILL_VEHICLE_LARGE))
		to_chat(user, SPAN_NOTICE("You have no idea how to operate this thing!"))
		return

	// Check if any of the hardpoints accept the magazine
	var/obj/item/hardpoint/reloading_hardpoint = null
	for(var/obj/item/hardpoint/H in vehicle.get_hardpoints_with_ammo())
		if(QDELETED(H) || QDELETED(H.ammo))
			continue

		if(istype(O, H.ammo.type))
			reloading_hardpoint = H
			break

	if(isnull(reloading_hardpoint))
		return ..()

	// Reload the hardpoint
	reloading_hardpoint.try_add_clip(O, user)

// Hardpoint reloading
/obj/vehicle/multitile/fieldgun/attack_hand(mob/living/carbon/human/user)

	if(!user || !istype(user))
		return

	handle_reload(user)

/obj/vehicle/multitile/fieldgun/proc/reload_ammo()
	set name = "Reload Ammo"
	set category = "Object"
	set src in range(1)

	var/mob/living/carbon/human/H = usr
	if(!H || !istype(H))
		return

	handle_reload(H)

/obj/vehicle/multitile/fieldgun/proc/handle_reload(mob/living/carbon/human/user)

	//something went bad, try to reconnect to vehicle if user is currently buckled in and connected to vehicle
	if(!vehicle)
		if(isVehicle(user.interactee))
			vehicle = user.interactee
		if(!istype(vehicle))
			to_chat(user, SPAN_WARNING("Critical Error! Ahelp this! Code: T_VMIS"))
			return

	var/list/hps = vehicle.get_hardpoints_with_ammo()

	if(!skillcheck(user, SKILL_VEHICLE, SKILL_VEHICLE_LARGE))
		to_chat(user, SPAN_NOTICE("You have no idea how to operate this thing!"))
		return

	if(!LAZYLEN(hps))
		to_chat(user, SPAN_WARNING("None of the hardpoints can be reloaded!"))
		return

	var/chosen_hp = tgui_input_list(usr, "Select a hardpoint", "Hardpoint Menu", (hps + "Cancel"))
	if(chosen_hp == "Cancel")
		return

	var/obj/item/hardpoint/HP = chosen_hp

	// If someone removed the hardpoint while their dialogue was open or something
	if(QDELETED(HP))
		to_chat(user, SPAN_WARNING("Error! Module not found!"))
		return

	if(!LAZYLEN(HP.backup_clips))
		to_chat(user, SPAN_WARNING("\The [HP] has no remaining backup magazines!"))
		return

	var/obj/item/ammo_magazine/M = LAZYACCESS(HP.backup_clips, 1)
	if(!M)
		to_chat(user, SPAN_DANGER("Something went wrong! Ahelp this! Code: T_BMIS"))
		return

	to_chat(user, SPAN_NOTICE("You begin reloading \the [HP]."))

	if(!do_after(user, 10, INTERRUPT_ALL, BUSY_ICON_FRIENDLY))
		to_chat(user, SPAN_WARNING("Something interrupted you while reloading \the [HP]."))
		return

	HP.ammo.forceMove(get_turf(src))
	HP.ammo.update_icon()
	HP.ammo = M
	LAZYREMOVE(HP.backup_clips, M)

	playsound(loc, 'sound/machines/hydraulics_3.ogg', 50)
	to_chat(user, SPAN_NOTICE("You reload \the [HP]. Ammo: <b>[SPAN_HELPFUL(HP.ammo.current_rounds)]/[SPAN_HELPFUL(HP.ammo.max_rounds)]</b> | Mags: <b>[SPAN_HELPFUL(LAZYLEN(HP.backup_clips))]/[SPAN_HELPFUL(HP.max_clips)]</b>"))
