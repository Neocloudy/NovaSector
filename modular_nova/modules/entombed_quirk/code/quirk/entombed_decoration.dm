/// Sets up the MOD's appearance according to the client's preferences
/datum/quirk/equipping/entombed/proc/decorate_modsuit(mob/living/carbon/human/human_holder, client/client_source)
	var/datum/mod_theme/new_theme = new /datum/mod_theme/entombed()
	modsuit.theme = new_theme

	var/lock_deploy = client_source?.prefs.read_preference(/datum/preference/toggle/entombed_deploy_lock)
	if(!isnull(lock_deploy))
		deploy_locked = lock_deploy

	// set no dismember trait for deploy-locked dudes, i'm sorry, there's basically no better way to do this.
	// it's a pretty ample buff but i dunno what else to do...
	if(deploy_locked)
		ADD_TRAIT(human_holder, TRAIT_NODISMEMBER, QUIRK_TRAIT)

	// set all of our customization stuff from prefs, if we have it
	var/modsuit_skin = client_source?.prefs.read_preference(/datum/preference/choiced/entombed_skin)
	var/modsuit_hardlight = client_source?.prefs.read_preference(/datum/preference/choiced/entombed_hardlight_theme)

	if(!istext(modsuit_skin))
		modsuit_skin = "Standard"

	if(modsuit_hardlight == NONE)
		modsuit_hardlight = "standard_blue"
	else
		modsuit_hardlight = hardlight_display_names[modsuit_hardlight] || "standard_blue"

	modsuit.skin = LOWER_TEXT(modsuit_skin)

	// Check if the player has the appropriate role to bypass the restriction
	var/should_apply_lock = TRUE
	if(role_exceptions[capitalize(modsuit_skin)])
		if(human_holder && human_holder.mind && human_holder.mind.assigned_role)
			// Check if the role matches the exception for this skin
			if(human_holder.mind.assigned_role.title == role_exceptions[capitalize(modsuit_skin)])
				should_apply_lock = FALSE

	// If the skin itself is role-locked and the user lacks the role, fall back the skin
	if(should_apply_lock && locked_combinations[capitalize(modsuit_skin)])
		to_chat(human_holder, span_warning("The [modsuit_skin] MODsuit skin is restricted to a specific role. Defaulting to the civilian skin."))
		modsuit_skin = "civilian"
		modsuit.skin = modsuit_skin

	// Apply restriction only if there's no role exception
	var/lock_color_name = locked_combinations[capitalize(modsuit_skin)]
	var/lock_color_value = hardlight_display_names[lock_color_name]

	if(should_apply_lock && lock_color_value && (modsuit_hardlight == lock_color_value))
		var/list/allowed_hardlights = list()
		for (var/display_name, skin_name in hardlight_display_names)
			if(display_name != lock_color_name)
				allowed_hardlights += skin_name

		if(length(allowed_hardlights))
			modsuit_hardlight = pick(allowed_hardlights)
			to_chat(human_holder, span_warning("The combination of [modsuit_skin] skin and [lock_color_name] color is not available for your role. Color has been changed to a random available one."))
		else
			modsuit_hardlight = "standard_blue"
			to_chat(human_holder, span_warning("The combination of [modsuit_skin] skin and [lock_color_name] color is not available for your role. Default color has been set."))

	if(!modsuit_hardlight)
		modsuit_hardlight = "standard_blue"

	modsuit.theme.hardlight_theme = modsuit_hardlight

	switch(LOWER_TEXT(modsuit.skin))
		if("colonist", "tarkon", "voskhod")
			modsuit.icon = 'modular_nova/master_files/icons/obj/clothing/modsuit/mod_clothing.dmi'
			modsuit.worn_icon = 'modular_nova/master_files/icons/mob/clothing/modsuit/mod_clothing.dmi'

	var/modsuit_name = client_source?.prefs.read_preference(/datum/preference/text/entombed_mod_name)
	if(modsuit_name)
		modsuit.name = modsuit_name

	var/modsuit_desc = client_source?.prefs.read_preference(/datum/preference/text/entombed_mod_desc)
	if(modsuit_desc)
		modsuit.desc = modsuit_desc

	var/modsuit_skin_prefix = client_source?.prefs.read_preference(/datum/preference/text/entombed_mod_prefix)
	if(modsuit_skin_prefix)
		modsuit.theme.name = LOWER_TEXT(modsuit_skin_prefix)

	// ensure we're applying our config theme changes, just in case
	for(var/obj/item/part as anything in modsuit.get_parts())
		part.name = "[modsuit.theme.name] [initial(part.name)]"
		part.desc = "[initial(part.desc)] [modsuit.theme.desc]"
		switch(LOWER_TEXT(modsuit.skin))
			if("colonist", "tarkon", "voskhod")
				part.icon = 'modular_nova/master_files/icons/obj/clothing/modsuit/mod_clothing.dmi'
				part.worn_icon = 'modular_nova/master_files/icons/mob/clothing/modsuit/mod_clothing.dmi'

	//transfer as many items across from our dropped backslot as we can. do this last incase something breaks
	if(force_dropped_items)
		var/obj/item/old_bag = locate() in force_dropped_items
		if(old_bag.atom_storage)
			old_bag.atom_storage.dump_content_at(modsuit, user = human_holder)
