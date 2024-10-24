/obj/item/hardpoint/trail
	name = "trail hardpoint"
	desc = "Trail module, used to tow, or anchor a field gun"
	icon = 'icons/obj/vehicles/hardpoints/fieldgun.dmi'

	slot = HDPT_TRAIL
	hdpt_layer = HDPT_LAYER_WHEELS

	activatable = TRUE

	/// How many anchoring points we have total both active or unactive
	var/total_anchorpoints = 1
	/// How much time it takes in seconds for ONE anchoring point to fully anchor
	var/anchoring_time = 10 SECONDS
	/// How much time it takes in seconds for ONE anchoring point to fully unanchor
	var/unanchoring_time = 10 SECONDS

	damage_multiplier = 0.075
