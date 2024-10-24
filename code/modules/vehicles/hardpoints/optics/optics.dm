/obj/item/hardpoint/optics
	name = "optics hardpoint"
	desc = "used to better see things"
	icon = 'icons/obj/vehicles/hardpoints/fieldgun.dmi'

	slot = HDPT_OPTICS
	hdpt_layer = HDPT_LAYER_SUPPORT

	health = 250

	activatable = TRUE

	var/is_active = 0
	var/view_buff = 0
	var/view_tile_offset = 0



	damage_multiplier = 0.075

/obj/item/hardpoint/optics/handle_fire(atom/target, mob/living/user, params)
	if(!user.client)
		return

	if(is_active)
		user.client.change_view(8, owner)
		user.client.pixel_x = 0
		user.client.pixel_y = 0
		is_active = FALSE
		return

	var/atom/holder = owner
	for(var/obj/item/hardpoint/holder/tank_turret/T in owner.hardpoints)
		holder = T
		break

	user.client.change_view(view_buff, owner)
	is_active = TRUE

	switch(holder.dir)
		if(NORTH)
			user.client.pixel_x = 0
			user.client.pixel_y = view_tile_offset * 32
		if(SOUTH)
			user.client.pixel_x = 0
			user.client.pixel_y = -1 * view_tile_offset * 32
		if(EAST)
			user.client.pixel_x = view_tile_offset * 32
			user.client.pixel_y = 0
		if(WEST)
			user.client.pixel_x = -1 * view_tile_offset * 32
			user.client.pixel_y = 0

/obj/item/hardpoint/optics/deactivate()
	if(!is_active)
		return

	var/obj/vehicle/multitile/C = owner
	for(var/seat in C.seats)
		if(!ismob(C.seats[seat]))
			continue
		var/mob/user = C.seats[seat]
		if(!user.client) continue
		user.client.change_view(GLOB.world_view_size, owner)
		user.client.pixel_x = 0
		user.client.pixel_y = 0
	is_active = FALSE

/obj/item/hardpoint/optics/try_fire(atom/target, mob/living/user, params)
	if(health <= 0)
		to_chat(usr, SPAN_WARNING("\The [src] is broken!"))
		return NONE

	return handle_fire(target, user, params)
