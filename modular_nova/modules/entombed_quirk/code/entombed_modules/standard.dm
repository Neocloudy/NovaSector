/// An efficient joint torsion module so that moving around at least delays running out of charge
/obj/item/mod/module/joint_torsion/entombed
	name = "internal joint torsion adaptation"
	desc = "Your adaptation to life in this MODsuit shell allows you to ambulate in such a way that your movements \
			recharge the suit's internal batteries slightly, but only while under the effect of gravity."
	removable = FALSE
	complexity = 0
	power_per_step = DEFAULT_CHARGE_DRAIN * 0.6

/// An efficient plasma stabilizer given to plasmaman wearers
/obj/item/mod/module/plasma_stabilizer/entombed
	name = "colony-stabilized interior seal"
	desc = "Your colony has fully integrated the internal segments of your suit's plate into your skeleton, \
			forming a hermetic seal between you and the outside world from which none of your atmosphere can escape. \
			This is enough to allow your head to view the world with your helmet retracted."
	complexity = 0
	idle_power_cost = 0
	removable = FALSE

/// An efficient, coreless anti-gravity module given to paraplegic wearers
/obj/item/mod/module/anomaly_locked/antigrav/entombed
	name = "assistive anti-gravity ambulator"
	desc = "An obligatory addition from the Nanotrasen science division as part of the Space Disabilities Act, \
			this augmentation allows your suit to project a limited anti-gravity field to aid in your ambulation \
			around the station for both general use and emergencies. It is powered by a tiny sliver of a gravitational \
			anomaly core, inextricably linked to the power systems that keep you alive. Not tested against EMP exposure."
	complexity = 0
	allow_flags = MODULE_ALLOW_INACTIVE // the suit is never off, so this just allows this to be used w/o being parts-deployed for cosmetic reasons
	removable = FALSE
	active_power_cost = 0 // torsion does not generate power in antigrav, so this is effectively -0.4 * DEFAULT_CHARGE_DRAIN
	prebuilt = TRUE
	core_removable = FALSE
