
/obj/machinery/gibber
	name = "gibber"
	desc = "The name isn't descriptive enough?"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "grinder"
	density = 1
	anchored = 1
	layer = 3.1 //so the stuffing animation isn't weird as shit
	var/operating = 0 //Is it on?
	var/dirty = 0 // Does it need cleaning?
	var/gibtime = 40 // Time from starting until meat appears
	// var/mob/living/occupant // Mob who has been put inside -- defined prior
	var/lastbloodcolor = null
	var/locked = 0 //Used to prevent mobs from breaking the feedin anim
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 500

//auto-gibs anything that bumps into it
/obj/machinery/gibber/autogibber
	var/turf/input_plate

/obj/machinery/gibber/autogibber/New()
	..()
	spawn(5)
		for(var/i in cardinal)
			var/obj/machinery/mineral/input/input_obj = locate( /obj/machinery/mineral/input, get_step(src.loc, i) )
			if(input_obj)
				if(isturf(input_obj.loc))
					input_plate = input_obj.loc
					qdel(input_obj)
					break

		if(!input_plate)
			diary << "a [src] didn't find an input plate."
			return

/obj/machinery/gibber/autogibber/Bumped(var/atom/A)
	if(!input_plate) return

	if(ismob(A))
		var/mob/M = A

		if(M.loc == input_plate)
			M.loc = src
			M.gib()


/obj/machinery/gibber/New()
	..()
	src.overlays += image('icons/obj/kitchen.dmi', "grjam")

/obj/machinery/gibber/update_icon()
	overlays.Cut()
	if (dirty)
		var/image/I = image('icons/obj/kitchen.dmi', "grbloody")
		I.color = lastbloodcolor
		src.overlays += I
	if(stat & (NOPOWER|BROKEN))
		return
	if (!occupant)
		src.overlays += image('icons/obj/kitchen.dmi', "grjam")
	else if (operating)
		src.overlays += image('icons/obj/kitchen.dmi', "gruse")
	else
		src.overlays += image('icons/obj/kitchen.dmi', "gridle")

/obj/machinery/gibber/clean_blood()
	..()
	dirty = 0
	update_icon()

/obj/machinery/gibber/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/gibber/container_resist()
	src.go_out()
	return

/obj/machinery/gibber/attack_hand(mob/user as mob)
	if(stat & (NOPOWER|BROKEN))
		return
	if(operating)
		user << "<span class='danger'>It's locked and running</span>"
		return
	if(locked)
		user << "<span class='danger'>Wait for [occupant.name] to finish being loaded!</span>"
		return
	else
		src.startgibbing(user)

/obj/machinery/gibber/attackby(obj/item/weapon/grab/G as obj, mob/user as mob, params)
	if(src.occupant)
		user << "<span class='danger'>The gibber is full, empty it first!</span>"
		return
	if (!( istype(G, /obj/item/weapon/grab)) || !(istype(G.affecting, /mob/living/carbon/human)))
		user << "<span class='danger'>This item is not suitable for the gibber!</span>"
		return
	if(G.affecting.abiotic(1))
		user << "<span class='danger'>Subject may not have abiotic items on.</span>"
		return

	user.visible_message("<span class='danger'>[user] starts to put [G.affecting] into the gibber!</span>")
	src.add_fingerprint(user)
	if(do_after(user, 30) && G && G.affecting && !occupant)
		user.visible_message("<span class='danger'>[user] stuffs [G.affecting] into the gibber!</span>")
		var/mob/M = G.affecting
		if(M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src
		var/turf/prevloc = M.loc
		M.loc = src
		src.occupant = M
		del(G)
		update_icon()
		StuffAnim(prevloc)

/obj/machinery/gibber/verb/eject()
	set category = "Object"
	set name = "empty gibber"
	set src in oview(1)

	if(usr.stat || !usr.canmove || usr.restrained())
		return
	src.go_out()
	add_fingerprint(usr)
	return

/obj/machinery/gibber/proc/go_out()
	if (!src.occupant)
		return
	if (locked)
		return
	for(var/obj/O in src)
		O.loc = src.loc
	if (src.occupant.client)
		src.occupant.client.eye = src.occupant.client.mob
		src.occupant.client.perspective = MOB_PERSPECTIVE
	src.occupant.loc = src.loc
	src.occupant = null
	update_icon()
	return

/obj/machinery/gibber/proc/StuffAnim(var/turf/prevloc)
	if(!src.occupant)
		return

	src.locked = 1
	var/turf/newloc = src.loc
	if(prevloc) newloc = prevloc

	if(!isturf(newloc)) return
	var/obj/effect/overlay/feedee = new(newloc)
	feedee.name = src.occupant.name
	feedee.icon = getFlatIcon(src.occupant, 2)

	var/matrix/span1 = matrix(feedee.transform)
	span1.Turn(60)
	var/matrix/span2 = matrix(feedee.transform)
	span2.Turn(120)
	var/matrix/span3 = matrix(feedee.transform)
	span3.Turn(180)
	animate(feedee, transform = span1, pixel_y = 15, time=2)
	animate(transform = span2, pixel_y = 25, time = 1) //If we instantly turn the guy 180 degrees he'll just pop out and in of existance all weird-like
	animate(transform = span3, time = 2, easing = ELASTIC_EASING)
	sleep(2)
	if(!feedee)
		locked = 0
		return
	feedee.loc = src.loc
	sleep(3)
	if(!feedee)
		locked = 0
		return
	feedee.layer = src.layer - 0.1
	animate(feedee, pixel_y = -5, time=20)
	sleep(5)
	if(!feedee)
		locked = 0
		return
	feedee.icon += icon('icons/obj/kitchen.dmi', "cuticon") //Cut off some of dat head
	sleep(15)
	if(feedee)
		qdel(feedee)
	locked = 0

/obj/machinery/gibber/proc/startgibbing(mob/user as mob)
	if(src.operating)
		return
	if(!src.occupant)
		visible_message("\red You hear a loud metallic grinding sound.")
		return
	use_power(1000)
	visible_message("\red You hear a loud squelchy grinding sound.")
	src.operating = 1
	update_icon()
	var/sourcename = src.occupant.real_name
	var/sourcejob = src.occupant.job
	var/sourcenutriment = src.occupant.nutrition / 15
	var/sourcetotalreagents = src.occupant.reagents.total_volume
	var/totalslabs = 3
	var/meattype = /obj/item/weapon/reagent_containers/food/snacks/meat //Vartype allows for non-meat meats if your species are a special kind of special snowflake.
	lastbloodcolor = "#A10808" //Default red blood
	if(iscarbon(src.occupant))
		var/mob/living/carbon/C = src.occupant
		meattype = C.dna.species.meat
		lastbloodcolor = C.dna.species.blood_color
	var/obj/item/allmeat[totalslabs]
	for (var/i=1 to totalslabs)
		var/obj/item/newmeat
		if(meattype)
			newmeat = new meattype
		if(newmeat)
			newmeat.name = sourcename + newmeat.name
			var/obj/item/weapon/reagent_containers/food/snacks/meat/human/humeat = newmeat
			if(istype(humeat))
				humeat.subjectname = sourcename
				humeat.subjectjob = sourcejob
			if(newmeat.reagents)
				newmeat.reagents.add_reagent("nutriment", sourcenutriment / totalslabs) // Thehehe. Fat guys go first
				src.occupant.reagents.trans_to(newmeat, round (sourcetotalreagents / totalslabs, 1)) // Transfer all the reagents from the victim to the meat
			allmeat[i] = newmeat
		else
			break

	src.occupant.attack_log += "\[[time_stamp()]\] Was gibbed by <b>[user]/[user.ckey]</b>" //One shall not simply gib a mob unnoticed!
	user.attack_log += "\[[time_stamp()]\] Gibbed <b>[src.occupant]/[src.occupant.ckey]</b>"
	if(src.occupant.ckey)
		message_admins("[user.name] ([user.ckey]) gibbed [src.occupant] ([src.occupant.ckey]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

	if(!iscarbon(user))
		src.occupant.LAssailant = null
	else
		src.occupant.LAssailant = user

	var/obj/effect/overlay/gibeffect = new
	gibeffect.layer = src.layer
	gibeffect.icon = src.icon
	gibeffect.icon_state = "grinding"
	gibeffect.color = lastbloodcolor
	gibeffect.loc = src.loc

	src.occupant.emote("scream")
	playsound(src.loc, 'sound/weapons/chainsawAttack2.ogg', 60, 1)
	var/Dna
	var/Viruses
	if(iscarbon(src.occupant))
		var/mob/living/carbon/C = src.occupant
		Viruses = C.viruses
		Dna = C.dna

	src.occupant.death(1)
	src.occupant.ghostize()
	del(src.occupant)
	spawn(src.gibtime)
		playsound(src.loc, 'sound/effects/splat.ogg', 50, 1)
		flick("finished", gibeffect)
		spawn(8)
			qdel(gibeffect)
		operating = 0
		dirty = 1
		for(var/i=1 to totalslabs)
			var/obj/item/meatslab = allmeat[i]
			var/turf/Tx = locate(src.x - i, src.y, src.z)
			if(meatslab)
				meatslab.loc = src.loc
				meatslab.throw_at(Tx,i,3,src)
		if(Dna)
			hgibs(src.loc, Viruses, Dna, WEST, list(1 = 1, 2 = 4, 3 = 3, 4 = 2), 1)
		update_icon()