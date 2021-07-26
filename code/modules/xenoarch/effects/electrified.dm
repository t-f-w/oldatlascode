datum/xeno_effect/electrified //Electrified effect.
	name = "Electrified"
	id = "electrified"
	desc = "This makes the object create sparks and zap anyone touching it without insulated gear."
	var/electrifiedforce = 7
	var/cooldown = 0

datum/xeno_effect/electrified/bumped_react(atom/AM as mob|obj)
	. = ..()
	if(.) //Parent returned 1
		if (cooldown < world.time)
			cooldown = world.time + 10 //1 second
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(5, 1, source)
			s.start() //sparks always.
			if(istype(AM, /mob/living))
				var/mob/living/L = AM
				L.electrocute_act(min(rand(20,60),rand(20,60)), source)

datum/xeno_effect/electrified/attackhand_react(mob/user as mob)
	. = ..()
	if(.) //Parent returned 1
		if (cooldown < world.time)
			cooldown = world.time + 10 //1 second
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(5, 1, source)
			s.start() //sparks always.
			if(istype(user, /mob/living))
				var/mob/living/L = user
				L.electrocute_act(min(rand(20,60),rand(20,60)), source)

datum/xeno_effect/electrified/attackself_react(mob/user as mob)
	. = ..()
	if(.) //Parent returned 1
		if (cooldown < world.time)
			cooldown = world.time + 10 //1 second
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(5, 1, source)
			s.start() //sparks always.
			if(istype(user, /mob/living))
				var/mob/living/L = user
				L.electrocute_act(min(rand(20,60),rand(20,60)), source)

datum/xeno_effect/electrified/attack_react(obj/item/W, mob/user, params)
	. = ..()
	if(.) //Parent returned 1
		if (cooldown < world.time)
			cooldown = world.time + 10 //1 second
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(5, 1, source)
			s.start() //sparks always.
			if(istype(user, /mob/living))
				var/mob/living/L = user
				L.electrocute_act(min(rand(20,60),rand(20,60)), source, W.siemens_coefficient)

datum/xeno_effect/electrified/examine_react(mob/user as mob)
	. = ..()
	if(. && isliving(user)) //So ghosts cannot activate it
		if (cooldown < world.time)
			user << "<span class='danger'>[source] reacted as soon as you started staring at it!</span>"
			cooldown = world.time + 10 //1 second
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(5, 1, source)
			s.start() //sparks always.
			// if(istype(user, /mob/living) && in_range(source, user)) //Let's check for range as well so there's no long-range electrifying.
			// 	var/mob/living/L = user
			// 	L.electrocute_act(min(rand(20,60),rand(20,60)), source)

datum/xeno_effect/electrified/crossed_react(atom/movable/AM)
	. = ..()
	if(.)
		if(istype(AM, /mob) && !isliving(AM)) return //Safety check to prevent ghosts from interacting with it
		if (cooldown < world.time)
			cooldown = world.time + 10 //1 second
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(5, 1, source)
			s.start() //sparks always.
			if(istype(AM, /mob/living))
				var/mob/living/L = AM
				L.electrocute_act(min(rand(20,60),rand(20,60)), source)

datum/xeno_effect/electrified/move_react(atom/newloc, direct)
	. = ..()
	if(.) //Parent returned 1
		if (cooldown < world.time)
			cooldown = world.time + 10 //1 second
			var/datum/effect/effect/system/spark_spread/s = new
			s.set_up(5, 1, source)
			s.start()

datum/xeno_effect/electrified/destroy_react()
	. = ..()
	if(.) //Parent returned 1
		if(source) //Just in case. Source should still exist when this proc is called.
			var/datum/effect/effect/system/spark_spread/s = new
			s.set_up(5, 1, source)
			s.start()

datum/xeno_effect/electrified/pull_react(mob/user as mob)
	. = ..()
	if(.) //Parent returned 1
		if (cooldown < world.time)
			cooldown = world.time + 10 //1 second
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(5, 1, source)
			s.start() //sparks always.
			if(istype(user, /mob/living))
				var/mob/living/L = user
				L.electrocute_act(min(rand(20,60),rand(20,60)), source)

datum/xeno_effect/electrified/process()
	. = ..()
	if(.) //Parent returned 1
		var/datum/effect/effect/system/spark_spread/s = new
		s.set_up(5, 1, source)
		s.start()

/obj/artifact/electrified //Testing it
	name = "weird test object"
	desc = "Spooky."
	icon_state = "o-basic"
	effects = list("electrified")
	effectflags = list("electrified" = EFFECT_ALL & ~EFFECT_PROCESS)
	has_process = 0

/obj/item/artifact/electrified
	name = "weird test trinket"
	desc = "Spooky."
	icon_state = "i-basic"
	effects = list("electrified")
	effectflags = list("electrified" = EFFECT_ALL & ~EFFECT_PROCESS)
	has_process = 0