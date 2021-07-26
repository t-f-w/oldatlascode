//Silly bikehorn test.

datum/xeno_effect/honk //Makes a bikehorn sound.
	name = "Honk"
	id = "honk"
	desc = "Honk!"
	var/cooldown = 0 //For movement sound

datum/xeno_effect/honk/bumped_react(atom/AM as mob|obj)
	. = ..()
	if(.) //Parent returned 1
		playsound(source.loc, 'sound/items/bikehorn.ogg', 30, 1)

datum/xeno_effect/honk/attackhand_react(mob/user as mob)
	. = ..()
	if(.) //Parent returned 1
		playsound(source.loc, 'sound/items/bikehorn.ogg', 30, 1)

datum/xeno_effect/honk/attackself_react(mob/user as mob)
	. = ..()
	if(.) //Parent returned 1
		playsound(source.loc, 'sound/items/bikehorn.ogg', 30, 1)

datum/xeno_effect/honk/attack_react(obj/item/W, mob/user, params)
	. = ..()
	if(.) //Parent returned 1
		playsound(source.loc, 'sound/items/bikehorn.ogg', 30, 1)

datum/xeno_effect/honk/examine_react(mob/user as mob)
	. = ..()
	if(. && isliving(user)) //So ghosts cannot activate it
		playsound(source.loc, 'sound/items/bikehorn.ogg', 30, 1)

datum/xeno_effect/honk/crossed_react(atom/movable/AM)
	. = ..()
	if(.)
		if(istype(AM, /mob) && !isliving(AM)) return //Safety check to prevent ghosts from interacting with it
		playsound(source.loc, 'sound/items/bikehorn.ogg', 30, 1)

datum/xeno_effect/honk/move_react(atom/newloc, direct)
	. = ..()
	if(.) //Parent returned 1
		if (cooldown < world.time)
			cooldown = world.time + 5 //0.5 seconds
			playsound(source.loc, 'sound/items/bikehorn.ogg', 30, 1)

datum/xeno_effect/honk/destroy_react()
	. = ..()
	if(.) //Parent returned 1
		if(source) //Just in case. Source should still exist when this proc is called.
			playsound(source.loc, 'sound/misc/sadtrombone.ogg', 50, 0)

datum/xeno_effect/honk/process()
	. = ..()
	if(.) //Parent returned 1
		playsound(source.loc, 'sound/items/bikehorn.ogg', 30, 1)


/obj/artifact/test //Testing the effects system
	name = "weird clown object"
	desc = "Honk!"
	icon_state = "o-basic"
	effects = list("honk")
	effectflags = list("honk" = EFFECT_ALL & ~EFFECT_PROCESS)
	has_process = 1

/obj/item/artifact/test
	name = "weird clown trinket"
	desc = "Honk!"
	icon_state = "i-basic"
	effects = list("honk")
	effectflags = list("honk" = EFFECT_ALL & ~EFFECT_PROCESS)
	has_process = 1