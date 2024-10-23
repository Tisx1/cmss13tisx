/obj/item/hardpoint/primary/lightcannon
	name = "\improper Light Cannon"
	desc = "Light cannon"
	icon = 'icons/obj/vehicles/hardpoints/fieldgun.dmi'

	icon_state = "ltb_cannon"
	disp_icon = "fieldgun"
	disp_icon_state = "lightcannon"

	health = 500
	firing_arc = 70

	ammo = new /obj/item/ammo_magazine/hardpoint/lightcannon
	max_clips = 1

	origins = list(0, 0)

	muzzle_flash_pos = list(
		"1" = list(0, 59),
		"2" = list(0, -74),
		"4" = list(89, -4),
		"8" = list(-89, -4)
	)

	scatter = 2
	fire_delay = 3.0 SECONDS
