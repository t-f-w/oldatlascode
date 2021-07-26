/datum/chemical_reaction/ointment //Heals burn damage on touch. Useful for patches.
	name = "Ointment"
	id = "ointment"
	result = "ointment"
	required_reagents = list("kelotane" = 1, "carbon" = 1, "hydrogen" = 1)
	result_amount = 1

/datum/chemical_reaction/brutanol //Heals brute damage on touch. Useful for patches.
	name = "Brutanol"
	id = "brutanol"
	result = "brutanol"
	required_reagents = list("bicaridine" = 1, "carbon" = 1, "nitrogen" = 1)
	result_amount = 1

/datum/reagent/pure_rainbow
	name = "Pure Rainbow"
	id = "pure_rainbow"
	description = "A solution of rainbows."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	var/list/potential_colors = list("#FF0000","#FF7F00","#FFFF00","#00FF00","#0000FF","#4B0082","#8B00FF")

/datum/chemical_reaction/pure_rainbow
	name = "pure_rainbow"
	id = "pure_rainbow"
	result = "pure_rainbow"
	required_reagents = list("redcrayonpowder" = 1, "orangecrayonpowder" = 1, "yellowcrayonpowder" = 1, "greencrayonpowder" = 1, "bluecrayonpowder" = 1, "purplecrayonpowder" = 1)
	result_amount = 6

/datum/reagent/luminol
	name = "Luminol"
	id = "luminol"
	description = "A solution useful for scientific investigations."
	reagent_state = LIQUID
	color = "#00FFFF" // rgb(0,255,255)

/datum/chemical_reaction/luminol //Heals brute damage on touch. Useful for patches.
	name = "Luminol"
	id = "luminol"
	result = "luminol"
	required_reagents = list("chlorine" = 1, "iron" = 1, "water" = 1)
	result_amount = 2

datum/reagent/luminol/reaction_turf(var/turf/T, var/volume)
	for(var/obj/effect/overlay/Blood/O in T.contents)
		O.invisibility = INVISIBILITY_BLOOD
		spawn(600) //1 minute before it fades out again
			if(O)
				O.invisibility = INVISIBILITY_MAXIMUM
	..()

datum/reagent/pure_rainbow/reaction_mob(var/mob/living/M, var/volume)
	if(M && isliving(M))
		M.color = pick(potential_colors)
	..()
	return
datum/reagent/pure_rainbow/reaction_obj(var/obj/O, var/volume)
	if(O)
		O.color = pick(potential_colors)
	..()
	return
datum/reagent/pure_rainbow/reaction_turf(var/turf/T, var/volume)
	if(T)
		T.color = pick(potential_colors)
	..()
	return

/datum/chemical_reaction/tirizene //Causes staminaloss
	name = "Tirizene"
	id = "tirizene"
	result = "tirizene"
	required_reagents = list("ethanol" = 1, "tea" = 1, "chlorine" = 1) //We need more instances of food&drinks reagents used to mix chems
	result_amount = 2

/datum/chemical_reaction/syntheskin //Synthetic skin woo
	name = "syntheskin"
	id = "syntheskin"
	result = null
	required_reagents = list("blood" = 1, "kelotane" = 1, "carbon" = 1)
	result_amount = 1
	mob_react = 1

/datum/chemical_reaction/syntiskin/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/location = get_turf(holder.my_atom)
	new /obj/item/synthetic_skin(location)
	return