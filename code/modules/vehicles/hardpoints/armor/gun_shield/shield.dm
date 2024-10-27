/obj/item/hardpoint/armor/shield
	name = "Gun Shield"
	desc = "a forward facing shield"
	icon ='icons/obj/vehicles/hardpoints/fieldgun.dmi'

	icon_state = "concussive_armor"
	disp_icon = "fieldgun"
	disp_icon_state = "shield"
	var/shield_size = 92 // how big will our shield be, this changes the bound_x on the affected vehicle

/obj/item/hardpoint/armor/shield/on_install(obj/vehicle/multitile/vehicle)
	if(!vehicle)
		return
	vehicle.bound_width = shield_size

/obj/item/hardpoint/armor/shield/on_uninstall(obj/vehicle/multitile/vehicle)
	deactivate()

/obj/item/hardpoint/armor/shield/deactivate()
	owner.bound_x = initial(owner.bound_x)


