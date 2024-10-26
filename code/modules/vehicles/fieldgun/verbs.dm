/obj/vehicle/multitile/fieldgun/proc/deploy_trail(mob/toggler)
	set name = "Deploy Anchoring Trail"
	set desc = "Anchors the anchoring trail for firing"
	set category = "Vehicle"

	var/mob/user = toggler || usr
	if(!user || !istype(user))
		return

	var/obj/vehicle/multitile/fieldgun/vehicle = user.interactee
	if(!istype(vehicle))
		return

	var/seat
	for(var/vehicle_seat in vehicle.seats)
		if(vehicle.seats[vehicle_seat] == user)
			seat = vehicle_seat
			break

	if(!seat)
		return

	var/obj/item/hardpoint/trail/T = locate() in vehicle.hardpoints
	if(!T)
		to_chat(user, SPAN_WARNING("[vehicle] has no trail mounted"))
		return

	if(T.deploying)
		return

	if(T.health <= 0)
		to_chat(user, SPAN_WARNING ("[T] is broken!"))
		return

	if(T.anchorpoints == T.total_anchorpoints)
		to_chat(user, SPAN_WARNING ("[vehicle] doesn't have more anchoring points!"))
		return
	else
		to_chat(user, SPAN_WARNING ("TEST"))
		T.deploying = TRUE
		T.deploy_trail(toggler)
		vehicle.trail_deployed = TRUE
		T.deploying = FALSE
		to_chat(user, SPAN_WARNING ("TEST done"))
		return


/obj/vehicle/multitile/fieldgun/proc/undeploy_trail(mob/toggler)
	set name = "Undeploy anchoring trail"
	set desc = "Undeploys Anchoring trail for moving"
	set category = "Vehicle"

	var/mob/user = toggler || usr
	if(!user || !istype(user))
		return

	var/obj/vehicle/multitile/fieldgun/vehicle = user.interactee
	if(!istype(vehicle))
		return

	var/seat
	for(var/vehicle_seat in vehicle.seats)
		if(vehicle.seats[vehicle_seat] == user)
			seat = vehicle_seat
			break

	if(!seat)
		return

	var/obj/item/hardpoint/trail/T = locate() in vehicle.hardpoints
	if(!T)
		to_chat(user, SPAN_WARNING("[vehicle] has no trail mounted"))
		return

	if(T.deploying)
		return

	if(T.health <= 0)
		to_chat(user, SPAN_WARNING ("[T] is broken!"))
		return

	if(T.anchorpoints == 0)
		to_chat(user, SPAN_WARNING("[vehicle] has no more anchor points to remove!"))
	else
		to_chat(user, SPAN_WARNING ("TEST"))
		T.deploying = TRUE
		T.undeploy_trail(toggler)
		if(T.anchorpoints == 0)
			vehicle.trail_deployed = FALSE
		T.deploying = FALSE
		to_chat(user, SPAN_WARNING ("TEST done"))
		return



/*/obj/vehicle/multitile/fieldgun/proc/finish_trail_deploy(mob/user)
	var/obj/item/hardpoint/trail/T = locate() in hardpoints
	if(!T)
		T.deploying = FALSE
		return
	if(user)
		playsound(user, 'sound/machines/hydraulics_2.ogg', 80, TRUE)
	trail_deployed = !trail_deployed
	T.deploying = FALSE */
