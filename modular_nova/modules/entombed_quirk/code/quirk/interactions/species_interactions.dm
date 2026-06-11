/// Handles any post-decoration installations for specific species
/datum/quirk/equipping/entombed/proc/check_species_interactions()
	if(!modsuit)
		return
	var/mob/living/carbon/human/human_holder = quirk_holder
	for(var/species_path, decorator in species_interactions)
		if(!is_species(human_holder, species_path))
			continue
		handle_interactions(decorator, human_holder, modsuit)

/datum/quirk/equipping/entombed/proc/interaction_ethereal(mob/living/carbon/human/human_holder, obj/item/mod/control/modsuit)
	var/obj/item/mod/core/ethereal/eth_core = new
	eth_core.install(modsuit)
	interaction_notice("Your MODsuit has \a [eth_core], allowing your physiology to feed charge into your MODsuit.")

/datum/quirk/equipping/entombed/proc/interaction_plasmaman(mob/living/carbon/human/human_holder, obj/item/mod/control/modsuit)
	var/obj/item/mod/module/plasma_stabilizer/entombed/stabilizer = new
	modsuit.install(stabilizer)
	interaction_notice("Your MODsuit has \a [stabilizer], allowing you to take off only your helmet and not burn up.")
