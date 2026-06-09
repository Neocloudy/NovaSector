/// Handles any post-decoration installations for specific jobs
/datum/quirk/equipping/entombed/proc/check_job_interactions()
	if(!modsuit)
		return
	var/mob/living/carbon/human/human_holder = quirk_holder
	for(var/job_path, decorator in job_interactions)
		if(!istype(human_holder.mind?.assigned_role, job_path))
			continue
		handle_interactions(decorator, human_holder, modsuit)
