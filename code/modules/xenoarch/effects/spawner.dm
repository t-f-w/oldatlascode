datum/xeno_effect/spawner //spawner effect.
	name = "Spawner"
	id = "spawner"
	desc = "This effect seems to spawn unknown animals."
	var/cooldown = 0
	var/spawner_type = null // must be either an object path or a list
	var/deliveryamt = 1 // amount of type to deliver per interaction/process
	var/random_amt = 0
	var/always_random = 0
	var/mobtype = "all"
	var/uses = -1 //-1 is infinite, 0 is no uses left.

datum/xeno_effect/spawner/New(var/atom/newsrc, var/r_amt, var/spawnamt, var/togglerandom, var/forcetype, var/forceuses)
	..()
	deliveryamt = rand(1, 5)
	always_random = rand(0, 1)
	mobtype = pick("all", "hostile", "friendly")
	uses = max(rand(-1, 5), rand(-1, 5)) //There's a low chance for uses to be infinite.
	if(r_amt) random_amt = r_amt
	if(spawnamt > 1) deliveryamt = spawnamt
	if(togglerandom >= 0) always_random = togglerandom
	if(forcetype) mobtype = forcetype
	if(forceuses != null) uses = forceuses

	var/blocked = list(
		/mob/living/simple_animal,
		/mob/living/simple_animal/construct,
		/mob/living/simple_animal/construct/armored, //Player mob
		/mob/living/simple_animal/construct/wraith, //Player mob
		/mob/living/simple_animal/construct/builder, //Player mob
		/mob/living/simple_animal/construct/harvester, //Player mob
		/mob/living/simple_animal/ascendant_shadowling, //Player mob
		/mob/living/simple_animal/shade,
		// /mob/living/simple_animal/space_worm, //Not enabled
		/mob/living/simple_animal/drone, //Player mob
		/mob/living/simple_animal/drone/syndrone, //Player mob
		/mob/living/simple_animal/revenant, //Player mob
		/mob/living/simple_animal/hostile,
		/mob/living/simple_animal/hostile/pirate,
		/mob/living/simple_animal/hostile/pirate/ranged,
		/mob/living/simple_animal/hostile/russian,
		/mob/living/simple_animal/hostile/russian/ranged,
		/mob/living/simple_animal/hostile/syndicate,
		/mob/living/simple_animal/hostile/syndicate/melee,
		/mob/living/simple_animal/hostile/syndicate/melee/space,
		/mob/living/simple_animal/hostile/syndicate/ranged,
		/mob/living/simple_animal/hostile/syndicate/ranged/space,
		/mob/living/simple_animal/hostile/alien/queen/large,
		/mob/living/simple_animal/hostile/retaliate,
		/mob/living/simple_animal/hostile/asteroid,
		//LET THE ASTEROID MONSTERS FEED
		// /mob/living/simple_animal/hostile/asteroid/basilisk,
		// /mob/living/simple_animal/hostile/asteroid/goldgrub,
		// /mob/living/simple_animal/hostile/asteroid/goliath,
		// /mob/living/simple_animal/hostile/asteroid/hivelord,
		/mob/living/simple_animal/hostile/asteroid/hivelordbrood,
		/mob/living/simple_animal/hostile/carp/holocarp,
		/mob/living/simple_animal/hostile/mining_drone
		)//exclusion list for things you don't want the reaction to create.


	var/list/critters = list()
	switch(mobtype)
		if("hostile")
			critters = typesof(/mob/living/simple_animal/hostile) - blocked // list of possible hostile mobs
		if("friendly")
			critters = (typesof(/mob/living/simple_animal) - typesof(/mob/living/simple_animal/hostile)) - blocked // list of possible friendly mobs
		else
			critters = typesof(/mob/living/simple_animal) - blocked // list of possible mobs period

	spawner_type = always_random ? critters : pick(critters)

datum/xeno_effect/spawner/proc/Spawn() //Shamelessly ripped from spawner grenades
	if(uses == 0)
		return
	if(random_amt) deliveryamt = rand(1, 5)
	if(spawner_type && deliveryamt)
		var/turf/T = get_turf(source)
		playsound(T, 'sound/effects/phasein.ogg', min(deliveryamt * 20, 100), 1)
		for(var/i=1, i<=deliveryamt, i++)
			var/newspawn = spawner_type
			if(islist(spawner_type)) newspawn = pick(spawner_type)
			var/atom/movable/x = new newspawn
			if(istype(x)) //Safety check
				x.loc = T
				if(prob(50))
					for(var/j = 1, j <= rand(1, 3), j++)
						step(x, pick(NORTH,SOUTH,EAST,WEST))
		if(uses > 0)
			uses--

datum/xeno_effect/spawner/bumped_react(atom/AM as mob|obj)
	. = ..()
	if(uses == 0) //No uses left, rip
		return
	if(.) //Parent returned 1
		if (cooldown < world.time)
			cooldown = world.time + (deliveryamt * 10)
			Spawn()
			

datum/xeno_effect/spawner/attackhand_react(mob/user as mob)
	. = ..()
	if(uses == 0) //No uses left, rip
		return
	if(.) //Parent returned 1
		if (cooldown < world.time)
			cooldown = world.time + (deliveryamt * 10)
			Spawn()
			

datum/xeno_effect/spawner/attackself_react(mob/user as mob)
	. = ..()
	if(uses == 0) //No uses left, rip
		return
	if(.) //Parent returned 1
		if (cooldown < world.time)
			cooldown = world.time + (deliveryamt * 10)
			Spawn()
			

datum/xeno_effect/spawner/attack_react(obj/item/W, mob/user, params)
	. = ..()
	if(uses == 0) //No uses left, rip
		return
	if(.) //Parent returned 1
		if (cooldown < world.time)
			cooldown = world.time + (deliveryamt * 10)
			Spawn()
			

datum/xeno_effect/spawner/examine_react(mob/user as mob)
	. = ..()
	if(uses == 0) //No uses left, rip
		return
	if(. && isliving(user)) //So ghosts cannot activate it
		user << "<span class='danger'>[source] reacted as soon as you started staring at it!</span>"
		if (cooldown < world.time)
			cooldown = world.time + (deliveryamt * 10)
			Spawn()
			
datum/xeno_effect/spawner/crossed_react(atom/movable/AM)
	. = ..()
	if(uses == 0) //No uses left, rip
		return
	if(.)
		if(istype(AM, /mob) && !isliving(AM)) return //Safety check to prevent ghosts from interacting with it
		if (cooldown < world.time)
			cooldown = world.time + (deliveryamt * 10)
			Spawn()
			
datum/xeno_effect/spawner/move_react(atom/newloc, direct)
	. = ..()
	if(uses == 0) //No uses left, rip
		return
	if(.) //Parent returned 1
		if (cooldown < world.time)
			cooldown = world.time + (deliveryamt * 10)
			Spawn()
			
datum/xeno_effect/spawner/destroy_react()
	. = ..()
	if(uses == 0) //No uses left, rip
		return
	if(.) //Parent returned 1
		if(source) //Just in case. Source should still exist when this proc is called.
			Spawn()

datum/xeno_effect/spawner/pull_react(mob/user as mob)
	. = ..()
	if(uses == 0) //No uses left, rip
		return
	if(.) //Parent returned 1
		if (cooldown < world.time)
			cooldown = world.time + (deliveryamt * 10)
			Spawn()		

datum/xeno_effect/spawner/process()
	. = ..()
	if(uses == 0) //No uses left, rip
		return
	if(.) //Parent returned 1
		Spawn()

/obj/artifact/spawner //Testing it
	name = "weird test object"
	desc = "Spooky."
	icon_state = "o-basic"
	effects = list("spawner")
	effectflags = list("spawner" = EFFECT_ALL & ~EFFECT_PROCESS)
	has_process = 0

/obj/item/artifact/spawner
	name = "weird test trinket"
	desc = "Spooky."
	icon_state = "i-basic"
	effects = list("spawner")
	effectflags = list("spawner" = EFFECT_ALL & ~EFFECT_PROCESS)
	has_process = 0