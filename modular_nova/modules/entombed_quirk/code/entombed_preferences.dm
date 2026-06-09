//! This file contains the definitions for entombed preferences

/datum/preference/choiced/entombed_skin
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "entombed_skin"
	savefile_identifier = PREFERENCE_CHARACTER
	can_randomize = FALSE

/datum/preference/choiced/entombed_skin/init_possible_values()
	return list(
		"Standard",
		"Civilian",
		"Advanced",
		"Atmospheric",
		"Corpsman",
		"Cosmohonk",
		"Engineering",
		"Infiltrator",
		"Interdyne",
		"Loader",
		"Medical",
		"Mining",
		"Prototype",
		"Security",
		"Colonist",
		"Tarkon",
		"Asteroid",
		"Research",
		"Rescue",
		"Safeguard",
		"Voskhod",
	)

/datum/preference/choiced/entombed_hardlight_theme
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "entombed_hardlight_theme"
	savefile_identifier = PREFERENCE_CHARACTER
	can_randomize = FALSE

/datum/preference/choiced/entombed_hardlight_theme/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/choiced/entombed_hardlight_theme/is_accessible(datum/preferences/preferences)
	if (!..())
		return FALSE

	return /datum/quirk/equipping/entombed::name in preferences.all_quirks

/datum/preference/choiced/entombed_hardlight_theme/init_possible_values()
	return list(
		"Standard Blue",
		"Alert Amber",
		"Contractor Red",
		"Extrashield Green",
		"Evil Green",
		"Royal Purple",
		"Hazard Orange",
		"Cosmic Blue",
	)

/datum/preference/choiced/entombed_skin/create_default_value()
	return "Civilian"

/datum/preference/choiced/entombed_skin/is_accessible(datum/preferences/preferences)
	if (!..())
		return FALSE

	return /datum/quirk/equipping/entombed::name in preferences.all_quirks

/datum/preference/choiced/entombed_skin/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/text/entombed_mod_name
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "entombed_mod_name"
	savefile_identifier = PREFERENCE_CHARACTER
	can_randomize = FALSE
	maximum_value_length = 64

/datum/preference/text/entombed_mod_name/is_accessible(datum/preferences/preferences)
	if (!..())
		return FALSE

	return /datum/quirk/equipping/entombed::name in preferences.all_quirks

/datum/preference/text/entombed_mod_name/serialize(input)
	return htmlrendertext(input)

/datum/preference/text/entombed_mod_name/deserialize(input, datum/preferences/preferences)
	var/sanitized_input = htmlrendertext(input)
	if(!isnull(sanitized_input))
		return sanitized_input
	else
		return ""

/datum/preference/text/entombed_mod_name/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/text/entombed_mod_desc
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "entombed_mod_desc"
	savefile_identifier = PREFERENCE_CHARACTER
	can_randomize = FALSE

/datum/preference/text/entombed_mod_desc/is_accessible(datum/preferences/preferences)
	if (!..())
		return FALSE

	return /datum/quirk/equipping/entombed::name in preferences.all_quirks

/datum/preference/text/entombed_mod_desc/serialize(input)
	return htmlrendertext(input)

/datum/preference/text/entombed_mod_desc/deserialize(input, datum/preferences/preferences)
	var/sanitized_input = htmlrendertext(input)
	if(!isnull(sanitized_input))
		return sanitized_input
	else
		return ""

/datum/preference/text/entombed_mod_desc/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/text/entombed_mod_prefix
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "entombed_mod_prefix"
	savefile_identifier = PREFERENCE_CHARACTER
	can_randomize = FALSE
	maximum_value_length = 16

/datum/preference/text/entombed_mod_prefix/is_accessible(datum/preferences/preferences)
	if (!..())
		return FALSE

	return /datum/quirk/equipping/entombed::name in preferences.all_quirks

/datum/preference/text/entombed_mod_prefix/serialize(input)
	return htmlrendertext(input)

/datum/preference/text/entombed_mod_prefix/deserialize(input, datum/preferences/preferences)
	return htmlrendertext(input)

/datum/preference/text/entombed_mod_prefix/create_default_value()
	return "Fused"

/datum/preference/text/entombed_mod_prefix/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/toggle/entombed_deploy_lock
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "entombed_deploy_lock"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/toggle/entombed_deploy_lock/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	return /datum/quirk/equipping/entombed::name in preferences.all_quirks

/datum/preference/toggle/entombed_deploy_lock/apply_to_human(mob/living/carbon/human/target, value)
	return
