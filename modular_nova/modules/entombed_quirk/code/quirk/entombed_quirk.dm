//! This file holds the base Entombed quirk definition and some entry points
//! for decoration, quirk/species compatibility, etc

/datum/quirk/equipping/entombed
	name = "Entombed"
	desc = "You are permanently fused to (or otherwise reliant on) a single MOD unit that can never be removed from your person. If it runs out of charge or is turned off, you'll start to die!"
	gain_text = span_warning("Your exosuit is both prison and home.")
	lose_text = span_notice("At last, you're finally free from that horrible exosuit.")
	medical_record_text = "Patient is physiologically reliant on a MOD unit for homeostasis. Do not attempt removal."
	value = 0
	icon = FA_ICON_ARROW_CIRCLE_DOWN
	forced_items = list(/obj/item/mod/control/pre_equipped/entombed = list(ITEM_SLOT_BACK))
	quirk_flags = QUIRK_HUMAN_ONLY | QUIRK_PROCESSES
	/// Reference to the MODsuit, for convenience
	var/obj/item/mod/control/pre_equipped/entombed/modsuit
	/// If the user has chosen to deploy lock
	var/deploy_locked = FALSE

	// Process vars
	/// How long before the wearer starts taking damage when the suit's not active
	var/life_support_failure_threshold = 1.5 MINUTES
	/// Timer ID for the timeframe tracker
	var/life_support_timer
	/// If the wearer has started taking damage for the suit being inactive for too long
	var/life_support_failed = FALSE

	// Decoration vars
	/// Static list of of player friendly hardlight color names -> internal colors
	var/static/list/hardlight_display_names = list(
		"Standard Blue" = HARDLIGHT_STANDARD_BLUE,
		"Alert Amber" = HARDLIGHT_ALERT_AMBER,
		"Contractor Red" = HARDLIGHT_CONTRACTOR_RED,
		"Extrashield Green" = HARDLIGHT_EXTRASHIELD_GREEN,
		"Evil Green" = HARDLIGHT_EVIL_GREEN,
		"Royal Purple" = HARDLIGHT_ROYAL_PURPLE,
		"Hazard Orange" = HARDLIGHT_HAZARD_ORANGE,
		"Cosmic Blue" = HARDLIGHT_COSMIC_BLUE,
	)
	/// For restricting certain skin + hardlight color combinations
	var/static/list/locked_combinations = list(
		//"Safeguard" = "Alert Amber",
		//"Advanced" = "Hazard Orange",
		//"Rescue" = "Standard Blue",
		//"Research" = "Royal Purple",
	)
	/// For restricting certain skins to specific roles
	var/static/list/role_exceptions = list(
		//"Safeguard" = JOB_HEAD_OF_SECURITY,
		//"Advanced" = JOB_CHIEF_ENGINEER,
		//"Rescue" = JOB_CHIEF_MEDICAL_OFFICER,
		//"Research" = JOB_RESEARCH_DIRECTOR,
	)

/datum/quirk/equipping/entombed/post_add()
	. = ..()
	install_racial_features()
	install_quirk_interaction_features()
	modsuit.quick_activation()

/datum/quirk/equipping/entombed/add_unique(client/client_source)
	. = ..()
	var/mob/living/carbon/human/human_holder = quirk_holder
	if(istype(human_holder.back, /obj/item/mod/control/pre_equipped/entombed))
		modsuit = human_holder.back // link this up to the quirk for easy access

	if(isnull(modsuit))
		stack_trace("Entombed quirk couldn't create a fused MODsuit on [quirk_holder] and was force-removed.")
		qdel(src)
		return

	decorate(human_holder, client_source)

/datum/quirk/equipping/entombed/remove()
	var/mob/living/carbon/human/human_holder = quirk_holder
	if(deploy_locked && HAS_TRAIT_FROM(human_holder, TRAIT_NODISMEMBER, QUIRK_TRAIT))
		REMOVE_TRAIT(human_holder, TRAIT_NODISMEMBER, QUIRK_TRAIT)
	QDEL_NULL(modsuit)

/datum/quirk_constant_data/entombed
	associated_typepath = /datum/quirk/equipping/entombed
	customization_options = list(
		/datum/preference/choiced/entombed_skin,
		/datum/preference/choiced/entombed_hardlight_theme,
		/datum/preference/text/entombed_mod_desc,
		/datum/preference/text/entombed_mod_name,
		/datum/preference/text/entombed_mod_prefix,
		/datum/preference/toggle/entombed_deploy_lock,
	)
