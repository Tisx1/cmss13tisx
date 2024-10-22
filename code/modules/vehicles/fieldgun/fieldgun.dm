/obj/vehicle/multitile/fieldgun
	name = "\improper M10 LongHaul Field Gun"
	desc = "What is bascially a two wheeled cart that can carry insanely large weapons"
	icon = 'icons/obj/vehicles/fieldgun.dmi'
	var/seat = null
	var/obj/vehicle/multitile/fieldgun/vehicle = null
	icon_state = "fg_base"

	pixel_x = -48
	pixel_y = -48

	bound_width = 32
	bound_height = 32


	health = 800

	can_buckle = TRUE //lord help me
	seat = VEHICLE_GUNNER

	interior_map = null

	passengers_slots = 0
	xenos_slots = 0

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
	vehicle = src

/obj/vehicle/multitile/fieldgun/crew_mousedown(datum/source, atom/object, turf/location, control, params)
	var/list/modifiers = params2list(params)
	if(modifiers[SHIFT_CLICK] || modifiers[MIDDLE_CLICK] || modifiers[RIGHT_CLICK]) //don't step on examine, point, etc
		return

	switch(get_mob_seat(source))
		if(VEHICLE_DRIVER)
			if(modifiers[LEFT_CLICK] && modifiers[CTRL_CLICK])
				activate_horn()

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
