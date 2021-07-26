//This file containts physical artifact objects and code for procs calling the effects.

////////////////////
//OBJECT ARTIFACTS//
////////////////////

/obj/artifact //Framework for randomized artifacts
	name = "ancient object"
	desc = "This is supposed to be randomized!"
	icon = 'icons/obj/xenoarch.dmi'
	icon_state = "o-basic"
	density = 1
	anchored = 0
	var/list/effects = list() //All the effects that this object has. Effects have multiple reaction types, but you will have to assign specific flags when adding to this list. Check defines.dm
	var/list/effectflags = list() //Usage: list("electrify" = EFFECT_BUMPED_REACT, "id" = flag, ..)
	var/has_process = 0 //Does this have ticker?

/obj/artifact/New(var/loc, var/list/newFX, var/list/newflags)
	..()
	if(newFX) effects = newFX
	if(newflags) effectflags = newflags
	if(has_process)
		processing_objects.Add(src)

	if(!xenoeffect_list)
		//Xenoarchaeology effects - Initialises all /datum/xeno_effect into a list indexed by xeno_effect id
		var/paths = typesof(/datum/xeno_effect) - /datum/xeno_effect
		xenoeffect_list = list()
		for(var/path in paths)
			var/datum/xeno_effect/D = new path()
			xenoeffect_list[D.id] = D

	var/list/temp = list() //Create a temp list to replace effects list with
	for(var/effectID in effects)
		if(istype(effectID, /datum/xeno_effect)) //The list already contains effect datums! ABORT
			temp = effects
			break
		var/datum/xeno_effect/D = xenoeffect_list[effectID]
		if(!D) continue

		var/datum/xeno_effect/R = new D.type(src)
		if(effectflags[effectID] != 0) //Defined flag!
			R.flags = effectflags[effectID] //Set the flags for effect
		temp += R

	if(temp != effects)
		effects = temp //Make effects list usable by code now
	effectflags.Cut()

	//This is all the available flags:
	//EFFECT_BUMPED_REACT|EFFECT_ATTACKHAND_REACT|EFFECT_ATTACKSELF_REACT|EFFECT_ATTACK_REACT|EFFECT_EXAMINE_REACT|EFFECT_CROSSED_REACT|EFFECT_MOVE_REACT|EFFECT_DESTROY_REACT|EFFECT_PROCESS
	//Set those flags in effectflags, e.g. effects = list("electrify" = EFFECT_BUMPED_REACT)
	//Warning: effects must also contain the same ID's.

/obj/artifact/Destroy()
	if(has_process)
		processing_objects.Remove(src)
	for(var/datum/xeno_effect/effect in effects)
		effect.destroy_react()
	..()

/obj/artifact/Bumped(atom/AM as mob|obj)
	..()
	for(var/datum/xeno_effect/effect in effects)
		effect.bumped_react(AM)

/obj/artifact/attack_hand(mob/user as mob)
	for(var/datum/xeno_effect/effect in effects)
		effect.attackhand_react(user)

/obj/artifact/attack_animal(mob/user as mob)
	attack_hand(user)

/obj/artifact/attack_paw(mob/user as mob)
	attack_hand(user)

// /obj/artifact/attack_self(mob/user as mob) //No such thing for non-item artifacts
// 	for(var/datum/xeno_effect/effect in effects)
// 		effect.attackself_react(user)

/obj/artifact/attackby(obj/item/W, mob/user, params)
	..()
	for(var/datum/xeno_effect/effect in effects)
		effect.attack_react(W, user, params)

/obj/artifact/examine(mob/user as mob)
	..()
	for(var/datum/xeno_effect/effect in effects)
		effect.examine_react(user)

/obj/artifact/Crossed(atom/movable/AM)
	..()
	for(var/datum/xeno_effect/effect in effects)
		effect.crossed_react(AM)

/obj/artifact/Move(atom/newloc, direct)
	. = ..()
	if(.)
		for(var/datum/xeno_effect/effect in effects)
			effect.move_react(newloc, direct)

/obj/artifact/process()
	for(var/datum/xeno_effect/effect in effects)
		effect.process()

/obj/artifact/started_pulling(mob/user as mob)
	for(var/datum/xeno_effect/effect in effects)
		effect.pull_react()

//////////////////
//ITEM ARTIFACTS//
//////////////////

/obj/item/artifact //Framework for randomized item artifacts
	name = "artifact"
	desc = "This is supposed to be randomized!"
	icon = 'icons/obj/xenoarch.dmi'
	icon_state = "i-basic"
	var/list/effects = list() //All the effects that this object has. Effects have multiple reaction types, but you will have to assign specific flags when adding to this list. Check defines.dm
	var/list/effectflags = list() //Usage: list("electrify" = EFFECT_BUMPED_REACT, "id" = flag, ..)
	var/has_process = 0 //Does this have ticker?

/obj/item/artifact/New(var/loc, var/list/newFX, var/list/newflags)
	..()
	if(newFX) effects = newFX
	if(newflags) effectflags = newflags
	if(has_process)
		processing_objects.Add(src)

	if(!xenoeffect_list)
		//Xenoarchaeology effects - Initialises all /datum/xeno_effect into a list indexed by xeno_effect id
		var/paths = typesof(/datum/xeno_effect) - /datum/xeno_effect
		xenoeffect_list = list()
		for(var/path in paths)
			var/datum/xeno_effect/D = new path()
			xenoeffect_list[D.id] = D

	var/list/temp = list() //Create a temp list to replace effects list with
	for(var/effectID in effects)
		if(istype(effectID, /datum/xeno_effect)) //The list already contains effect datums! ABORT
			temp = effects
			break
		var/datum/xeno_effect/D = xenoeffect_list[effectID]
		if(!D) continue

		var/datum/xeno_effect/R = new D.type(src)
		if(effectflags[effectID] != 0) //Defined flag!
			R.flags = effectflags[effectID] //Set the flags for effect
		temp += R

	if(temp != effects)
		effects = temp //Make effects list usable by code now
	effectflags.Cut()

	//This is all the available flags:
	//EFFECT_BUMPED_REACT|EFFECT_ATTACKHAND_REACT|EFFECT_ATTACKSELF_REACT|EFFECT_ATTACK_REACT|EFFECT_EXAMINE_REACT|EFFECT_CROSSED_REACT|EFFECT_MOVE_REACT|EFFECT_DESTROY_REACT|EFFECT_PROCESS
	//Set those flags in effectflags, e.g. effects = list("electrify" = EFFECT_BUMPED_REACT)
	//Warning: effects must also contain the same ID's.

/obj/item/artifact/Destroy()
	if(has_process)
		processing_objects.Remove(src)
	for(var/datum/xeno_effect/effect in effects)
		effect.destroy_react()
	..()

/obj/item/artifact/Bumped(atom/AM as mob|obj)
	..()
	for(var/datum/xeno_effect/effect in effects)
		effect.bumped_react(AM)

/obj/item/artifact/attack_hand(mob/user as mob)
	..()
	for(var/datum/xeno_effect/effect in effects)
		effect.attackhand_react(user)

/obj/item/artifact/attack_animal(mob/user as mob)
	attack_hand(user)

/obj/item/artifact/attack_paw(mob/user as mob)
	attack_hand(user)

/obj/item/artifact/attack_self(mob/user as mob)
	for(var/datum/xeno_effect/effect in effects)
		effect.attackself_react(user)

/obj/item/artifact/attackby(obj/item/W, mob/user, params)
	..()
	for(var/datum/xeno_effect/effect in effects)
		effect.attack_react(W, user, params)

/obj/item/artifact/examine(mob/user as mob)
	..()
	for(var/datum/xeno_effect/effect in effects)
		effect.examine_react(user)

/obj/item/artifact/Crossed(atom/movable/AM)
	..()
	for(var/datum/xeno_effect/effect in effects)
		effect.crossed_react(AM)

/obj/item/artifact/Move(atom/newloc, direct)
	. = ..()
	if(.)
		for(var/datum/xeno_effect/effect in effects)
			effect.move_react(newloc, direct)

/obj/item/artifact/process()
	for(var/datum/xeno_effect/effect in effects)
		effect.process()

/obj/item/artifact/started_pulling(mob/user as mob)
	for(var/datum/xeno_effect/effect in effects)
		effect.pull_react()