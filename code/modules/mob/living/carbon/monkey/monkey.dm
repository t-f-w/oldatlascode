/mob/living/carbon/monkey
	name = "monkey"
	voice_name = "monkey"
	say_message = "chimpers"
	icon = 'icons/mob/monkey.dmi'
	icon_state = "monkey1"
	gender = NEUTER
	pass_flags = PASSTABLE
	languages = MONKEY
	update_icon = 0		///no need to call regenerate_icon
	ventcrawler = 1

/mob/living/carbon/monkey/New()
	create_reagents(1000)
	verbs += /mob/living/proc/mob_sleep
	verbs += /mob/living/proc/lay_down

	internal_organs += new /obj/item/organ/appendix
	internal_organs += new /obj/item/organ/heart
	internal_organs += new /obj/item/organ/brain
	internal_organs += new /obj/item/organ/butt

	if(name == "monkey")
		name = text("monkey ([rand(1, 1000)])")
	real_name = name
	gender = pick(MALE, FEMALE)

	..()

/mob/living/carbon/monkey/prepare_data_huds()
	//Prepare our med HUD...
	..()
	//...and display it.
	for(var/datum/atom_hud/data/medical/hud in huds)
		hud.add_to_hud(src)

/mob/living/carbon/monkey/movement_delay()
	var/tally = 0
	if(reagents)
		if(reagents.has_reagent("hyperzine")) return -1

		if(reagents.has_reagent("nuka_cola")) return -1

	var/health_deficiency = (100 - health)
	if(health_deficiency >= 45) tally += (health_deficiency / 25)

	if (bodytemperature < 283.222)
		tally += (283.222 - bodytemperature) / 10 * 1.75
	return tally+config.monkey_delay

/mob/living/carbon/monkey/attack_paw(mob/living/M as mob)
	if(..()) //successful monkey bite.
		var/damage = rand(1, 5)
		if (stat != DEAD)
			adjustBruteLoss(damage)
			updatehealth()
	return

/mob/living/carbon/monkey/attack_larva(mob/living/carbon/alien/larva/L as mob)
	if(..()) //successful larva bite.
		var/damage = rand(1, 3)
		if(stat != DEAD)
			L.amount_grown = min(L.amount_grown + damage, L.max_grown)
			adjustBruteLoss(damage)
			updatehealth()

/mob/living/carbon/monkey/attack_hand(mob/living/carbon/human/M as mob)
	if(..())	//To allow surgery to return properly.
		return

	switch(M.a_intent)
		if("help")
			help_shake_act(M)
		if("grab")
			grabbedby(M)
		if("harm")
			M.do_attack_animation(src)
			if (prob(75))
				visible_message("<span class='danger'>[M] has punched [name]!</span>", \
						"<span class='userdanger'>[M] has punched [name]!</span>")

				playsound(loc, "punch", 25, 1, -7)
				var/damage = rand(5, 10)
				if (prob(40))
					damage = rand(10, 15)
					if ( (paralysis < 5)  && (health > 0) )
						Paralyse(rand(10, 15))
						spawn( 0 )
							visible_message("<span class='danger'>[M] has knocked out [name]!</span>", \
									"<span class='userdanger'>[M] has knocked out [name]!</span>")
							return
				adjustBruteLoss(damage)
				add_logs(M, src, "attacked", admin=0)
				updatehealth()
			else
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -12)
				visible_message("<span class='danger'>[M] has attempted to punch [name]!</span>", \
						"<span class='userdanger'>[M] has attempted to punch [name]!</span>")

		if("disarm")
			if (!( paralysis ))
				M.do_attack_animation(src)
				if (prob(25))
					Paralyse(2)
					playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -7)
					add_logs(M, src, "pushed", admin=0)
					visible_message("<span class='danger'>[M] has pushed down [src]!</span>", \
							"<span class='userdanger'>[M] has pushed down [src]!</span>")
				else
					if(drop_item())
						playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -7)
						visible_message("<span class='danger'>[M] has disarmed [src]!</span>", \
								"<span class='userdanger'>[M] has disarmed [src]!</span>")
	return

/mob/living/carbon/monkey/attack_alien(mob/living/carbon/alien/humanoid/M as mob)
	if(..()) //if harm or disarm intent.
		if (M.a_intent == "harm")
			if ((prob(95) && health > 0))
				playsound(loc, 'sound/weapons/slice.ogg', 25, 1, -7)
				var/damage = rand(15, 30)
				if (damage >= 25)
					damage = rand(20, 40)
					if (paralysis < 15)
						Paralyse(rand(10, 15))
					visible_message("<span class='danger'>[M] has wounded [name]!</span>", \
							"<span class='userdanger'>[M] has wounded [name]!</span>")
				else
					visible_message("<span class='danger'>[M] has slashed [name]!</span>", \
							"<span class='userdanger'>[M] has slashed [name]!</span>")
				add_logs(M, src, "attacked", admin=0)
				if (stat != DEAD)
					adjustBruteLoss(damage)
					updatehealth()
			else
				playsound(loc, 'sound/weapons/slashmiss.ogg', 25, 1, -12)
				visible_message("<span class='danger'>[M] has attempted to lunge at [name]!</span>", \
						"<span class='userdanger'>[M] has attempted to lunge at [name]!</span>")

		if (M.a_intent == "disarm")
			playsound(loc, 'sound/weapons/pierce.ogg', 25, 1, -7)
			var/damage = 5
			if(prob(95))
				Weaken(10)
				visible_message("<span class='danger'>[M] has tackled down [name]!</span>", \
						"<span class='userdanger'>[M] has tackled down [name]!</span>")
			else
				if(drop_item())
					visible_message("<span class='danger'>[M] has disarmed [name]!</span>", \
							"<span class='userdanger'>[M] has disarmed [name]!</span>")
			add_logs(M, src, "disarmed", admin=0)
			adjustBruteLoss(damage)
			updatehealth()
	return

/mob/living/carbon/monkey/attack_animal(mob/living/simple_animal/M as mob)
	if(..())
		var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
		adjustBruteLoss(damage)
		updatehealth()


/mob/living/carbon/monkey/attack_slime(mob/living/carbon/slime/M as mob)
	..()
	var/damage = rand(1, 3)

	if(M.is_adult)
		damage = rand(20, 40)
	else
		damage = rand(5, 35)
	adjustBruteLoss(damage)
	updatehealth()

	return

/mob/living/carbon/monkey/Stat()
	..()
	statpanel("Status")
	stat(null, "Intent: [a_intent]")
	stat(null, "Move Mode: [m_intent]")
	if(client && mind)
		if (client.statpanel == "Status")
			if(mind.changeling)
				stat("Chemical Storage", "[mind.changeling.chem_charges]/[mind.changeling.chem_storage]")
				stat("Absorbed DNA", mind.changeling.absorbedcount)
	return


/mob/living/carbon/monkey/verb/removeinternal()
	set name = "Remove Internals"
	set category = "IC"
	internal = null
	return

/mob/living/carbon/monkey/var/co2overloadtime = null
/mob/living/carbon/monkey/var/temperature_resistance = T0C+75

/mob/living/carbon/monkey/ex_act(severity, target)
	..()
	switch(severity)
		if(1.0)
			gib()
			return
		if(2.0)
			adjustBruteLoss(60)
			adjustFireLoss(60)
		if(3.0)
			adjustBruteLoss(30)
			if (prob(50))
				Paralyse(10)
	return

/mob/living/carbon/monkey/blob_act()
	if (stat != 2)
		show_message("<span class='userdanger'>The blob attacks you!</span>")
		adjustFireLoss(60)
		health = 100 - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss()
	if (prob(50))
		Paralyse(10)
	if (stat == DEAD && client)
		gib()
		return
	if (stat == DEAD && !client)
		gibs(loc, viruses)
		qdel(src)
		return


/mob/living/carbon/monkey/IsAdvancedToolUser()//Unless its monkey mode monkeys cant use advanced tools
	return 0

/mob/living/carbon/monkey/canBeHandcuffed()
	return 1

/mob/living/carbon/monkey/assess_threat(var/obj/machinery/bot/secbot/judgebot, var/lasercolor)
	if(judgebot.emagged == 2)
		return 10 //Everyone is a criminal!
	var/threatcount = 0

	//Securitrons can't identify monkeys
	if(!lasercolor && judgebot.idcheck )
		threatcount += 4

	//Lasertag bullshit
	if(lasercolor)
		if(lasercolor == "b")//Lasertag turrets target the opposing team, how great is that? -Sieve
			if((istype(r_hand,/obj/item/weapon/gun/energy/laser/redtag)) || (istype(l_hand,/obj/item/weapon/gun/energy/laser/redtag)))
				threatcount += 4

		if(lasercolor == "r")
			if((istype(r_hand,/obj/item/weapon/gun/energy/laser/bluetag)) || (istype(l_hand,/obj/item/weapon/gun/energy/laser/bluetag)))
				threatcount += 4

		return threatcount

	//Check for weapons
	if(judgebot.weaponscheck)
		if(judgebot.check_for_weapons(l_hand))
			threatcount += 4
		if(judgebot.check_for_weapons(r_hand))
			threatcount += 4

	//Loyalty implants imply trustworthyness
	if(isloyal(src))
		threatcount -= 1

	return threatcount

/mob/living/carbon/monkey/SpeciesCanConsume()
	return 1 // Monkeys can eat, drink, and be forced to do so


/mob/living/carbon/monkey/acid_act(var/acidpwr, var/toxpwr, var/acid_volume)
	if(wear_mask)
		if(!wear_mask.unacidable)
			wear_mask.acid_act(acidpwr)
			update_inv_wear_mask()
		else
			src << "<span class='warning'>Your mask protects you from the acid.</span>"
		return

	if(!unacidable)
		take_organ_damage(min(6*toxpwr, acid_volume * toxpwr))
