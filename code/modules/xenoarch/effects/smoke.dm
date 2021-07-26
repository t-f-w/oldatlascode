datum/xeno_effect/smoke //smoke effect.
	name = "smoke"
	id = "smoke"
	desc = "This effect makes the object create smoke."
	var/cooldown = 0
	var/datum/effect/effect/system/S
	var/smoke_type
	var/uses = -1

datum/xeno_effect/smoke/New(var/atom/newsrc, var/forceuses, var/forcesmoketype)
	..()
	if(forceuses != null) uses = forceuses
	smoke_type = pick(/obj/effect/effect/system/harmless_smoke_spread, /obj/effect/effect/system/bad_smoke_spread, /datum/effect/effect/system/sleep_smoke_spread)
	if(forcesmoketype) smoke_type = forcesmoketype
	S = new smoke_type
	if(istype(S))
		S.attach(source)

datum/xeno_effect/smoke/proc/Spawn()
	if(uses == 0)
		return

	playsound(src.loc, 'sound/effects/smoke.ogg', 50, 1, -7)
	smoke.set_up(10, 0, source.loc)
	smoke.start()
	if(uses > 0)
		uses--

datum/xeno_effect/smoke/bumped_react(atom/AM as mob|obj)
	. = ..()
	if(uses == 0) //No uses left, rip
		return
	if(.) //Parent returned 1
		if (cooldown < world.time)
			cooldown = world.time + 20
			Spawn()
			

datum/xeno_effect/smoke/attackhand_react(mob/user as mob)
	. = ..()
	if(uses == 0) //No uses left, rip
		return
	if(.) //Parent returned 1
		if (cooldown < world.time)
			cooldown = world.time + 20
			Spawn()
			

datum/xeno_effect/smoke/attackself_react(mob/user as mob)
	. = ..()
	if(uses == 0) //No uses left, rip
		return
	if(.) //Parent returned 1
		if (cooldown < world.time)
			cooldown = world.time + 20
			Spawn()
			

datum/xeno_effect/smoke/attack_react(obj/item/W, mob/user, params)
	. = ..()
	if(uses == 0) //No uses left, rip
		return
	if(.) //Parent returned 1
		if (cooldown < world.time)
			cooldown = world.time + 20
			Spawn()
			

datum/xeno_effect/smoke/examine_react(mob/user as mob)
	. = ..()
	if(uses == 0) //No uses left, rip
		return
	if(. && isliving(user)) //So ghosts cannot activate it
		if (cooldown < world.time)
			user << "<span class='danger'>[source] reacted as soon as you started staring at it!</span>"
			cooldown = world.time + 20
			Spawn()
			
datum/xeno_effect/smoke/crossed_react(atom/movable/AM)
	. = ..()
	if(uses == 0) //No uses left, rip
		return
	if(.)
		if(istype(AM, /mob) && !isliving(AM)) return //Safety check to prevent ghosts from interacting with it
		if (cooldown < world.time)
			cooldown = world.time + 20
			Spawn()
			
datum/xeno_effect/smoke/move_react(atom/newloc, direct)
	. = ..()
	if(uses == 0) //No uses left, rip
		return
	if(.) //Parent returned 1
		if (cooldown < world.time)
			cooldown = world.time + 20
			Spawn()
			
datum/xeno_effect/smoke/destroy_react()
	. = ..()
	if(uses == 0) //No uses left, rip
		return
	if(.) //Parent returned 1
		if(source) //Just in case. Source should still exist when this proc is called.
			Spawn()
			
datum/xeno_effect/smoke/pull_react(mob/user as mob)
	. = ..()
	if(uses == 0) //No uses left, rip
		return
	if(.) //Parent returned 1
		if (cooldown < world.time)
			cooldown = world.time + 20
			Spawn()

datum/xeno_effect/smoke/process()
	. = ..()
	if(uses == 0) //No uses left, rip
		return
	if(.) //Parent returned 1
		Spawn()

/obj/artifact/smoke //Testing it
	name = "weird test object"
	desc = "Spooky."
	icon_state = "o-basic"
	effects = list("smoke")
	effectflags = list("smoke" = EFFECT_ALL & ~EFFECT_PROCESS)
	has_process = 0

/obj/item/artifact/smoke
	name = "weird test trinket"
	desc = "Spooky."
	icon_state = "i-basic"
	effects = list("smoke")
	effectflags = list("smoke" = EFFECT_ALL & ~EFFECT_PROCESS)
	has_process = 0