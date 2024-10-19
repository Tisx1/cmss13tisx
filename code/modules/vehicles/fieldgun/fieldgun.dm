/obj/vehicle/multitile/fieldgun
	name = "\improper M10 LongHaul Field Gun"
	desc = "What is bascially a two wheeled cart that can carry insanely large weapons"

	icon = 'icons/obj/vehicles/fieldgun.dmi'
	icon_state = "fg_base"
	pixel_x = -48
	pixel_y = -48

	health = 800

	movement_sound = 'sound/vehicles/tank_driving.ogg'

	required_skill = SKILL_VEHICLE_LARGE
	vehicle_flags = VEHICLE_CLASS_MEDIUM

	move_max_momentum = 1

	vehicle_light_range = 5

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

