/// Handles any post-decoration installations for specific quirks
/datum/quirk/equipping/entombed/proc/check_quirk_interactions()
	if(!modsuit)
		return
	var/mob/living/carbon/human/human_holder = quirk_holder
	for(var/quirk_path, decorator in quirk_interactions)
		if(!human_holder.has_quirk(quirk_path))
			continue
		handle_interactions(decorator, human_holder, modsuit)

/datum/quirk/equipping/entombed/proc/interaction_paraplegic(mob/living/carbon/human/human_holder, obj/item/mod/control/modsuit)
	var/obj/item/mod/module/anomaly_locked/antigrav/entombed/ambulator = new
	modsuit.install(ambulator, human_holder)
	interaction_notice("Your MODsuit has \a [ambulator], allowing you to stand and move at full speed in a zero-gravity state. This movement doesn't charge the suit.")
