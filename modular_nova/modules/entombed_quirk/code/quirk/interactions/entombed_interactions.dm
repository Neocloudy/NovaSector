/datum/quirk/equipping/entombed/proc/handle_interactions(decorator, mob/living/carbon/human/human_holder, obj/item/mod/control/modsuit)
	for(var/delegation in decorator)
		call(src, delegation)(human_holder, modsuit)

/datum/quirk/equipping/entombed/proc/interaction_notice(message)
	to_chat(quirk_holder, span_boldnotice("[message]"))
