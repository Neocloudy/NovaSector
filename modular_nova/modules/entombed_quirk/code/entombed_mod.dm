//! This file contains the definitions for the entombed MOD control unit,
//! its special behavior, its MOD theme, and a component for handling MOD
//! pieces that leave their unit (either deleting them or sending them back)

/obj/item/mod/control/pre_equipped/entombed
	theme = /datum/mod_theme/entombed
	applied_cell = /obj/item/stock_parts/power_store/cell/high

/obj/item/mod/control/pre_equipped/entombed/Initialize(mapload, new_theme, new_skin, new_core)
	. = ..()
	// apply the entombed mod piece component to all applicable clothing pieces, so that they always return to the unit or self-delete if they can't
	for(var/obj/item/part as anything in get_parts())
		part.AddComponent(/datum/component/entombed_mod_piece, host_suit = src)

	ADD_TRAIT(src, TRAIT_NODROP, QUIRK_TRAIT)

/obj/item/mod/control/pre_equipped/entombed/dropped(mob/user)
	. = ..()
	// in the event that someone gets gibbed or destroyed in some other way, their suit can be retrieved without admin intervention
	REMOVE_TRAIT(src, TRAIT_NODROP, QUIRK_TRAIT)

/obj/item/mod/control/pre_equipped/entombed/canStrip(mob/who)
	return TRUE // you can always try, and it'll hit doStrip below

/obj/item/mod/control/pre_equipped/entombed/doStrip(mob/who)
	// attempt to handle custom stripping behavior if the MOD has a storage module
	var/obj/item/mod/module/storage/inventory = locate() in src.modules
	if(!isnull(inventory))
		src.atom_storage.remove_all()
		to_chat(who, span_notice("You empty out all the items from the MODsuit's storage module."))
		who.balloon_alert(who, "emptied out MOD storage items")
		return TRUE

	to_chat(who, span_warning("The suit seems permanently fused to their frame, you can't remove it!"))
	who.balloon_alert(who, "can't strip a fused MODsuit!")
	return ..()

/obj/item/mod/control/pre_equipped/entombed/retract(mob/user, obj/item/part, instant)
	if(!ishuman(user))
		return ..() // no special behavior if you're not a carbon human (?????)
	var/mob/living/carbon/human/human_user = user
	var/datum/quirk/equipping/entombed/tomb_quirk = human_user.get_quirk(/datum/quirk/equipping/entombed)
	if(!tomb_quirk?.deploy_locked)
		return ..() // not actually deploy locked, so no special behavior
	if(!istype(part, /obj/item/clothing))
		return ..() // not actually a modsuit piece, it might be a module
	if(istype(part, /obj/item/clothing/head/mod))
		return ..() // this can be retracted when deploy locked
	human_user.balloon_alert(human_user, "part is fused to you, can't retract!")
	playsound(src, 'sound/machines/scanner/scanbuzz.ogg', 25, TRUE, SILENCED_SOUND_EXTRARANGE)

/obj/item/mod/control/pre_equipped/entombed/quick_deploy(mob/user)
	if(!ishuman(user))
		return ..()
	var/mob/living/carbon/human/human_user = user
	var/datum/quirk/equipping/entombed/tomb_quirk = human_user.get_quirk(/datum/quirk/equipping/entombed)
	if(!tomb_quirk?.deploy_locked)
		return ..()
	human_user.balloon_alert(human_user, "you can only retract your helmet, and only manually!")
	playsound(src, 'sound/machines/scanner/scanbuzz.ogg', 25, TRUE, SILENCED_SOUND_EXTRARANGE)

/datum/mod_theme/entombed
	name = "fused"
	desc = "Circumstances have rendered this protective suit into someone's second skin. Literally."
	extended_desc = "Some great aspect of someone's past has permanently bound them to this device, for better or worse."

	default_skin = "standard"
	armor_type = /datum/armor/mod_entombed
	resistance_flags = FIRE_PROOF | ACID_PROOF // It is better to die for the Emperor than live for yourself.
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT
	siemens_coefficient = 0
	complexity_max = DEFAULT_MAX_COMPLEXITY - 5
	charge_drain = DEFAULT_CHARGE_DRAIN / 2
	slowdown_deployed = 0.95
	inbuilt_modules = list(
		/obj/item/mod/module/joint_torsion/entombed,
		/obj/item/mod/module/storage/large_capacity,
	)
	allowed_suit_storage = list(
		/obj/item/tank/internals,
		/obj/item/flashlight,
	)

/datum/armor/mod_entombed
	melee = ARMOR_LEVEL_WEAK
	bullet = ARMOR_LEVEL_WEAK
	laser = ARMOR_LEVEL_WEAK
	energy = ARMOR_LEVEL_WEAK
	bomb = ARMOR_LEVEL_WEAK
	bio = ARMOR_LEVEL_WEAK
	fire = ARMOR_LEVEL_WEAK
	acid = ARMOR_LEVEL_WEAK
	wound = WOUND_ARMOR_WEAK

/// This component handles returning errant MOD parts back to their control unit
/// in the event of shenanigans. These pieces should never be outside of the unit,
/// or their wearer.
/datum/component/entombed_mod_piece
	/// Ref to the host MODsuit
	var/datum/weakref/host

/datum/component/entombed_mod_piece/Initialize(obj/item/mod/control/host_suit)
	. = ..()
	if(istype(host_suit))
		host = WEAKREF(host_suit)
	else
		return COMPONENT_INCOMPATIBLE

	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(piece_dropped))

/// When a piece is dropped, try to send it back to the
/// host control unit, or delete the piece if it can't be found
/datum/component/entombed_mod_piece/proc/piece_dropped(datum/source)
	SIGNAL_HANDLER
	var/obj/item/mod/control/host_suit = host.resolve()
	if(!host_suit)
		// No host suit, so this should just not exist
		host = null
		if(!QDELETED(parent))
			qdel(parent)
		return

	var/obj/item/clothing/piece = parent
	if(!isnull(piece))
		piece.doMove(host_suit)
