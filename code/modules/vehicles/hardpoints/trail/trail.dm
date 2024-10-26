/obj/item/hardpoint/trail
	name = "trail hardpoint"
	desc = "Trail module, used to tow, or anchor a field gun"
	icon = 'icons/obj/vehicles/hardpoints/fieldgun.dmi'

	slot = HDPT_TRAIL
	hdpt_layer = HDPT_LAYER_WHEELS

	var/deploying = FALSE
	damage_multiplier = 0.075

/obj/item/hardpoint/trail/proc/deploy_trail(mob/user)
	for(var/obj/item/hardpoint/primary/P in owner.hardpoints)
		if(anchorpoints < total_anchorpoints)
			to_chat(user, SPAN_WARNING ("You begin anchoring down one of the anchoring points!"))
			do_after(user, anchoring_time, INTERRUPT_ALL, BUSY_ICON_GENERIC)
			P.anchorpoints ++
			anchorpoints ++
			to_chat(user, SPAN_WARNING ("You anchor down one of the anchoring points! [anchorpoints] out of [total_anchorpoints]!"))
			return
		break


/obj/item/hardpoint/trail/proc/undeploy_trail(mob/user)
	for(var/obj/item/hardpoint/primary/P in owner.hardpoints)
		if(anchorpoints  > 0)
			to_chat(user, SPAN_WARNING ("You begin removing down one of the anchoring points!"))
			do_after(user, unanchoring_time, INTERRUPT_ALL, BUSY_ICON_GENERIC)
			P.anchorpoints --
			anchorpoints --
			to_chat(user, SPAN_WARNING ("You remove one of the anchoring points! [anchorpoints] out of [total_anchorpoints]!"))
			return
		break


