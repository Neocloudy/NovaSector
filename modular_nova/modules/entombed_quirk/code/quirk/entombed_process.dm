//! This file is where Entombed processing stuff is implemented

/// How much damage should we be taking when the suit's been disabled a while?
#define ENTOMBED_TICK_DAMAGE 1.5

/datum/quirk/equipping/entombed/process(seconds_per_tick)
	if(isnull(modsuit) || life_support_failed)
		while_life_support_failing(seconds_per_tick)

	if(modsuit)
		if(!modsuit.active)
			while_inactive()
		else
			while_active()

/// Called while the suit is inactive and life support is failing,
/// damages the wearer and adds non-stacking jitter
/datum/quirk/equipping/entombed/proc/while_life_support_failing(seconds_per_tick)
	var/mob/living/carbon/human/human_holder = quirk_holder
	if(HAS_TRAIT(human_holder, TRAIT_STASIS))
		return
	human_holder.adjust_tox_loss(ENTOMBED_TICK_DAMAGE * seconds_per_tick, updating_health = TRUE, forced = TRUE)
	human_holder.set_jitter_if_lower(10 SECONDS)

/// Called while the suit is inactive, if the life support timer doesn't
/// exist, sets it up and warns the wearer about their current situation
/datum/quirk/equipping/entombed/proc/while_inactive()
	if(life_support_timer)
		return
	var/mob/living/carbon/human/human_holder = quirk_holder
	life_support_timer = addtimer(CALLBACK(src, PROC_REF(life_support_failure), human_holder), life_support_failure_threshold, TIMER_STOPPABLE | TIMER_DELETE_ME)
	to_chat(human_holder, span_danger("Your physiology begins to erratically seize and twitch, bereft of your MODsuit's vital support. <b>Turn it back on as soon as you can!</b>"))
	human_holder.balloon_alert(human_holder, "suit life support warning!")
	human_holder.set_jitter_if_lower(life_support_failure_threshold)

/// Called while the suit is active, if the life support timer exists,
/// deletes it and tells the wearer that they're going to be okay
/datum/quirk/equipping/entombed/proc/while_active()
	if(!life_support_timer)
		return
	var/mob/living/carbon/human/human_holder = quirk_holder
	deltimer(life_support_timer)
	life_support_timer = null
	life_support_failed = FALSE
	to_chat(human_holder, span_notice("Relief floods your frame as your suit begins sustaining your life once more."))
	human_holder.balloon_alert(human_holder, "suit life support restored!")
	human_holder.adjust_jitter(-(life_support_failure_threshold / 2)) // clear half of it, wow, that was unpleasant

/// Actually starts the damage from a life support failure, and warns the wearer
/datum/quirk/equipping/entombed/proc/life_support_failure()
	var/mob/living/carbon/human/human_holder = quirk_holder
	human_holder.visible_message(span_danger("[human_holder] suddenly staggers, a dire pallor overtaking [human_holder.p_their()] features as a feeble 'breep' emanates from their suit..."), span_userdanger("Terror descends as your suit's life support system breeps feebly, and then goes horrifyingly silent."))
	human_holder.balloon_alert(human_holder, "suit life support failing!")
	playsound(human_holder, 'sound/effects/alert.ogg', 25, TRUE, SILENCED_SOUND_EXTRARANGE) // OH GOD THE STRESS NOISE
	life_support_failed = TRUE

#undef ENTOMBED_TICK_DAMAGE
