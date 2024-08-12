// Override of Blood Deficiency quirk for robotic/synthetic species.
// Does not appear in TGUI or the character preferences window.
/datum/quirk/blooddeficiency/synth
	name = "Coolant Leak"
	desc = "Your shell has multiple coolant leaks, preventing coolant reserves from regulating at 100%."
	medical_record_text = "Patient requires regular treatment for hydraulic fluid loss."
	icon = FA_ICON_GLASS_WATER_DROPLET
	mail_goodies = list(/obj/item/reagent_containers/blood/synth_coolant)
	hidden_quirk = TRUE

// If blooddeficiency is added to a synth, this detours to the blooddeficiency/synth quirk.
/datum/quirk/blooddeficiency/add_to_holder(mob/living/new_holder, quirk_transfer, client/client_source)
	if(!issynthetic(new_holder) || type != /datum/quirk/blooddeficiency)
		// Defer to TG blooddeficiency if the character isn't robotic.
		return ..()

	var/datum/quirk/blooddeficiency/synth/bd_synth = new
	qdel(src)
	return bd_synth.add_to_holder(new_holder, quirk_transfer)
