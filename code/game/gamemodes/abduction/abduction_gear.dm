#define VEST_STEALTH 1
#define VEST_COMBAT 2
#define GIZMO_SCAN 1
#define GIZMO_MARK 2

//AGENT VEST
/obj/item/clothing/suit/armor/abductor/vest
	name = "Agent Vest"
	desc = "Vest outfitted with alien stealth technology."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "vest_stealth"
	item_state = "armor"
	blood_overlay_type = "armor"
	armor = list(melee = 15, bullet = 15, laser = 15, energy = 15, bomb = 15, bio = 15, rad = 15)
	action_button_name = "Activate"
	action_button_is_hands_free = 1
	var/mode = VEST_STEALTH
	var/stealth_active = 0
	var/combat_cooldown = 10
	var/datum/icon_snapshot/disguise
	var/stealth_armor = list(melee = 15, bullet = 15, laser = 15, energy = 15, bomb = 15, bio = 15, rad = 15)
	var/combat_armor = list(melee = 50, bullet = 50, laser = 50, energy = 50, bomb = 50, bio = 50, rad = 50)

	var/obj/machinery/camera/portable/vest_cam = null


///obj/item/clothing/suit/armor/abductor/vest/New()
	..()
//	vest_cam = new /obj/machinery/camera/portable(src)
//	vest_cam.c_tag = "Agent Vest Cam"
//	vest_cam.network = list("Abductor")

/obj/item/clothing/suit/armor/abductor/vest/proc/flip_mode()
	switch(mode)
		if(VEST_STEALTH)
			mode = VEST_COMBAT
			DeactivateStealth()
			armor = combat_armor
			icon_state = "vest_combat"
			if(istype(loc, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = loc
				H.update_inv_wear_suit()
			return
		if(VEST_COMBAT)// TO STEALTH
			mode = VEST_STEALTH
			armor = stealth_armor
			icon_state = "vest_stealth"
			if(istype(loc, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = loc
				H.update_inv_wear_suit()
			return



/obj/item/clothing/suit/armor/abductor/vest/proc/SetDisguise(var/datum/icon_snapshot/entry)
	disguise = entry

/obj/item/clothing/suit/armor/abductor/vest/proc/ActivateStealth()
	if(disguise == null)
		return
	stealth_active = 1
	if(istype(src.loc, /mob/living/carbon/human))
		var/mob/living/carbon/human/M = src.loc
		spawn(0)
			anim(M.loc,M,'icons/mob/mob.dmi',,"cloak",,M.dir)

		M.name_override = disguise.name
		M.icon = disguise.icon
		M.icon_state = disguise.icon_state
		M.overlays = disguise.overlays
		M.update_inv_r_hand()
		M.update_inv_l_hand()
	return

/obj/item/clothing/suit/armor/abductor/vest/proc/DeactivateStealth()
	if(!stealth_active)
		return
	stealth_active = 0
	if(istype(src.loc, /mob/living/carbon/human))
		var/mob/living/carbon/human/M = src.loc
		spawn(0)
			anim(M.loc,M,'icons/mob/mob.dmi',,"uncloak",,M.dir)
		M.name_override = null
		M.overlays.Cut()
		M.regenerate_icons()
	return

/obj/item/clothing/suit/armor/abductor/vest/IsShield()
	DeactivateStealth()
	return 0
/obj/item/clothing/suit/armor/abductor/vest/IsReflect()
	DeactivateStealth()
	return 0

/obj/item/clothing/suit/armor/abductor/vest/ui_action_click()
	switch(mode)
		if(VEST_COMBAT)
			Adrenaline()
		if(VEST_STEALTH)
			if(stealth_active)
				DeactivateStealth()
			else
				ActivateStealth()

/obj/item/clothing/suit/armor/abductor/vest/proc/Adrenaline()
	if(istype(src.loc, /mob/living/carbon/human))
		if(combat_cooldown != initial(combat_cooldown))
			src.loc << "<span class='warning'>Combat injection is still recharging.</span>"
		var/mob/living/carbon/human/M = src.loc
		M.stat = 0
		M.SetParalysis(0)
		M.SetStunned(0)
		M.SetWeakened(0)
		M.lying = 0
		M.update_canmove()
		M.adjustStaminaLoss(-75)
		combat_cooldown = 0
		processing_objects |= src

/obj/item/clothing/suit/armor/abductor/vest/process()
	combat_cooldown++
	if(combat_cooldown==initial(combat_cooldown))
		processing_objects.Remove(src)

/obj/item/device/abductor/proc/IsAbductor(var/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.dna.species.id != "abductor")
			return 0
		return 1
	return 0

/obj/item/device/abductor/proc/AbductorCheck(var/user)
	if(IsAbductor(user))
		return 1
	user << "<span class='notice'>You can't figure how this works.</span>"
	return 0

/obj/item/device/abductor/proc/ScientistCheck(var/user)
	var/mob/living/carbon/human/H = user
	var/datum/species/abductor/S = H.dna.species
	return S.scientist

/obj/item/device/abductor/gizmo
	name = "Science Tool"
	desc = "Alien science is 90% dissections 10% probings."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "gizmo_scan"
	item_state = "silencer"
	var/mode = GIZMO_SCAN
	var/mob/living/marked = null
	var/obj/machinery/abductor/console/console

/obj/item/device/abductor/gizmo/attack_self(mob/user)
	if(!AbductorCheck(user))
		return
	if(!ScientistCheck(user))
		user << "<span class='notice'>You're not trained to use this</span>"
		return
	if(mode == GIZMO_SCAN)
		mode = GIZMO_MARK
		icon_state = "gizmo_mark"
	else
		mode = GIZMO_SCAN
		icon_state = "gizmo_scan"
	user << "<span class='notice'>You switch the device to [mode==GIZMO_SCAN? "SCAN": "MARK"] MODE</span>"

/obj/item/device/abductor/gizmo/attack(mob/living/M, mob/user)
	if(!AbductorCheck(user))
		return
	if(!ScientistCheck(user))
		user << "<span class='notice'>You're not trained to use this</span>"
		return
	switch(mode)
		if(GIZMO_SCAN)
			scan(M, user)
		if(GIZMO_MARK)
			mark(M, user)


/obj/item/device/abductor/gizmo/afterattack(var/atom/target, var/mob/living/user, flag, params)
	if(flag)
		return
	if(!AbductorCheck(user))
		return
	if(!ScientistCheck(user))
		user << "<span class='notice'>You're not trained to use this</span>"
		return
	switch(mode)
		if(GIZMO_SCAN)
			scan(target, user)
		if(GIZMO_MARK)
			mark(target, user)

/obj/item/device/abductor/gizmo/proc/scan(var/atom/target, var/mob/living/user)
	if(istype(target,/mob/living/carbon/human))
		if(console!=null)
			console.AddSnapshot(target)
			user << "<span class='notice'>You scan and add the being to the database</span>"

/obj/item/device/abductor/gizmo/proc/mark(var/atom/target, var/mob/living/user)
	if(marked == target)
		user << "<span class='notice'>This specimen is already marked.</span>"
		return
	if(istype(target,/mob/living/carbon/human))
		if(IsAbductor(target))
			marked = target
			user << "<span class='notice'>You mark the target for future retrieval.</span>"
		else
			prepare(target,user)

/obj/item/device/abductor/gizmo/proc/prepare(var/atom/target, var/mob/living/user)
	if(get_dist(target,user)>1)
		user << "<span class='warning'>You need to be next to the specimen to prepare it for transport.</span>"
		return
	user << "<span class='notice'>You start preparing the specimen for transport </span>"
	if(do_after(user, 100))
		marked = target
		user << "<span class='notice'>You finish preparing the specimen for transport </span>"


/obj/item/device/abductor/silencer
	name = "Abductor Silencer"
	desc = "Device used to break communication equipment"
	icon = 'icons/obj/abductor.dmi'
	icon_state = "silencer"
	item_state = "gizmo"

/obj/item/device/abductor/silencer/attack(mob/living/M, mob/user)
	if(!AbductorCheck(user))
		return
	radio_off(M, user)

/obj/item/device/abductor/silencer/afterattack(var/atom/target, var/mob/living/user, flag, params)
	if(flag)
		return
	if(!AbductorCheck(user))
		return
	radio_off(target, user)

/obj/item/device/abductor/silencer/proc/radio_off(var/atom/target, var/mob/living/user)
	if( !(user in (viewers(7,target))) )
		return

	var/turf/targloc = get_turf(target)

	var/mob/living/carbon/human/M
	for(M in view(2,targloc))
		user << "<span class='notice'>You silence [M.name] radio devices.</span>"
		radio_off_mob(M)

/obj/item/device/abductor/silencer/proc/radio_off_mob(var/mob/living/carbon/human/M)
	var/list/all_items = M.GetAllContents()

	for(var/obj/I in all_items)
		if(istype(I,/obj/item/device/radio/))
			var/obj/item/device/radio/r = I
			r.listening = 0
			if(!istype(I,/obj/item/device/radio/headset))
				r.broadcasting = 0 //goddamned headset hacks


/obj/item/weapon/implant/abductor
	name = "Emergency Beam"
	desc = "Gets you back on the ship."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "implant"
	activated = 1
	var/obj/machinery/abductor/pad/home
	var/cooldown = 30

/obj/item/weapon/implant/abductor/activate()
	if(cooldown == initial(cooldown))
		home.Retrieve(imp_in,1)
		cooldown = 0
		processing_objects |= src
	else
		imp_in << "<span class='warning'>The emergency beam is still recharging!</span>"
	return

/obj/item/weapon/implant/abductor/process()
	if(cooldown < initial(cooldown))
		cooldown++
		if(cooldown == initial(cooldown))
			processing_objects.Remove(src)




/obj/item/weapon/gun/energy/decloner/alien
	ammo_type = list(/obj/item/ammo_casing/energy/declone)
	icon_state = "alienpistol"
	item_state = "alienpistol"

/obj/item/weapon/gun/energy/decloner/alien/update_icon() // No charge levels
	return

/obj/item/weapon/paper/abductor
	name = "Dissection Guide"
	info = {"<b>Dissection for Dummies</b><br>
<br>
 1.Acquire fresh specimen.<br>
 2.Put the specimen on operating table<br>
 3.Apply surgical drapes preparing for dissection<br>
 4.Apply scalpel to specimen torso<br>
 5.Stop the bleeders and retract skin<br>
 6.Cut out organs you find with a scalpel<br>
 7.Use your hands to remove the remaining organs<br>
 8.Insert replacement gland (Retrieve one from gland storage)<br>
 9.Consider dressing the specimen back to not disturb the habitat <br>
 10.Put the specimen in the experiment machinery<br>
 11.Choose one of the machine options and follow displayed instructions<br>
<br>
Congratulations! You are now trained for xenobiology research!"}

#define BATON_STUN 0
#define BATON_SLEEP 1
#define BATON_CUFF 2
#define BATON_MODES 3

/obj/item/weapon/abductor_baton
	name = "Advanced Baton"
	var/mode = BATON_STUN
	icon = 'icons/obj/abductor.dmi'
	icon_state = "wonderprod"
	item_state = "wonderprod"
	slot_flags = SLOT_BELT
	force = 7
	w_class = 3
	action_button_name = "Toggle Mode"

/obj/item/weapon/abductor_baton/proc/toggle(mob/living/user=usr)
	mode = (mode+1)%BATON_MODES
	var/txt
	switch(mode)
		if(BATON_STUN)
			txt = "stun"
		if(BATON_SLEEP)
			txt = "sleep inducment"
		if(BATON_CUFF)
			txt = "restraining"

	usr << "<span class='notice'>You switch the baton to [txt] mode</span>"
	update_icon()

/obj/item/weapon/abductor_baton/update_icon()
	switch(mode)
		if(BATON_STUN)
			icon_state = "wonderprod"
		if(BATON_SLEEP)
			icon_state = "wonderprod"
		if(BATON_CUFF)
			icon_state = "wonderprod"

/obj/item/weapon/abductor_baton/proc/IsAbductor(var/mob/living/user)
	if(!ishuman(user))
		return 0
	var/mob/living/carbon/human/H = user
	if(!H.dna)
		return 0
	if(H.dna.species.id != "abductor")
		return 0
	return 1

/obj/item/weapon/abductor_baton/attack(mob/target as mob, mob/living/user as mob)
	if(!IsAbductor(user))
		return

	if(isrobot(target))
		..()
		return

	if(!isliving(target))
		return

	if(user.a_intent == "help")
		target.visible_message("<span class='danger'>[user] probes [target] with [src]!</span>", \
							"<span class='userdanger'>[user] probed [target]!</span>")
		return

	var/mob/living/L = target

	user.do_attack_animation(L)
	switch(mode)
		if(BATON_STUN)
			StunAttack(L,user)
		if(BATON_SLEEP)
			SleepAttack(L,user)
		if(BATON_CUFF)
			CuffAttack(L,user)

/obj/item/weapon/abductor_baton/attack_self(mob/living/user)
	toggle(user)

/obj/item/weapon/abductor_baton/proc/StunAttack(mob/living/L,mob/living/user)
	user.lastattacked = L
	L.lastattacker = user

	L.Stun(7)
	L.Weaken(7)
	L.apply_effect(STUTTER, 7)

	L.visible_message("<span class='danger'>[user] has stunned [L] with [src]!</span>", \
							"<span class='userdanger'>[user] has stunned you with [src]!</span>")
	playsound(loc, 'sound/weapons/Egloves.ogg', 50, 1, -7)

	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		H.forcesay(hit_appends)

	add_logs(user, L, "stunned")
	return

/obj/item/weapon/abductor_baton/proc/SleepAttack(mob/living/L,mob/living/user)
	if(L.stunned)
		L.SetSleeping(60)
	L.visible_message("<span class='danger'>[user] has induced sleep in [L] with [src]!</span>", \
							"<span class='userdanger'>You suddenly feel very drowsy!</span>")
	playsound(loc, 'sound/weapons/Egloves.ogg', 50, 1, -7)

	add_logs(user, L, "put to sleep")
	return

/obj/item/weapon/abductor_baton/proc/CuffAttack(mob/living/L,mob/living/user)
	if(!iscarbon(L))
		return
	var/mob/living/carbon/C = L
	if(!C.handcuffed)
		playsound(loc, 'sound/weapons/cablecuff.ogg', 30, 1, -14)
		C.visible_message("<span class='danger'>[user] is trying to put energy cuffs on [C]!</span>", \
								"<span class='userdanger'>[user] is trying to put energy cuffs on [C]!</span>")
		if(do_mob(user, C, 30))
			if(!C.handcuffed)
				C.handcuffed = new /obj/item/weapon/handcuffs/energy/used(C)
				C.update_inv_handcuffed(0)
				user << "<span class='notice'>You handcuff [C].</span>"
				add_logs(user, C, "handcuffed")
		else
			user << "<span class='warning'>You fail to handcuff [C].</span>"
	return

/obj/item/weapon/handcuffs/energy
	name = "energy cuffs"
	desc = "Energy field restraining the hands."
	icon_state = "cuff_white" // Needs sprite
	breakouttime = 450
	trashtype = /obj/item/weapon/handcuffs/energy/used

/obj/item/weapon/handcuffs/energy/used
	desc = "Energy Discharge"

/obj/item/weapon/handcuffs/energy/used/dropped(mob/user)
	user.visible_message("<span class='danger'>[user] cuffs break in a discharge of energy!</span>", \
							"<span class='userdanger'>[user] cuffs break in a discharge of energy!</span>")
	var/datum/effect/effect/system/spark_spread/S = new
	S.set_up(4,0,user.loc)
	S.start()
	qdel(src)

/obj/item/weapon/abductor_baton/examine(mob/user)
	..()
	switch(mode)
		if(BATON_STUN)
			user <<"<span class='warning'>The baton is in stun mode.</span>"
		if(BATON_SLEEP)
			user <<"<span class='warning'>The baton is in sleep induction mode.</span>"
		if(BATON_CUFF)
			user <<"<span class='warning'>The baton is in restrain mode.</span>"


obj/item/weapon/scalpel/alien
	name = "alien scalpel"
	icon = 'icons/obj/abductor.dmi'

obj/item/weapon/hemostat/alien
	name = "alien hemostat"
	icon = 'icons/obj/abductor.dmi'

obj/item/weapon/retractor/alien
	name = "alien retractor"
	icon = 'icons/obj/abductor.dmi'

/obj/item/clothing/head/helmet/abductor
	name = "Agent Headgear"
	desc = "Abducting with style. Spiky style."
	icon_state = "alienhelmet"
	item_state = "alienhelmet"
	blockTracking = 1

// Operating Table / Beds / Lockers
/obj/structure/optable/abductor
	icon = 'icons/obj/abductor.dmi'
	icon_state = "bed"
	can_buckle = 1
	buckle_lying = 1
/obj/structure/stool/bed/abductor
	name = "resting contraption"
	desc = "This looks similar to contraptions from earth. Could aliens be stealing our technology?"
	icon = 'icons/obj/abductor.dmi'
	icon_state = "bed"
/obj/structure/table/abductor
	name = "alien table"
	desc = "Advanced flat surface technology at work!"
	icon_state = "alientable"

/obj/structure/closet/abductor
	name = "alien locker"
	desc = "Contains secrets of the universe"
	icon_state = "abductor"