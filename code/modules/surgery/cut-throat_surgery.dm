//INCLUDES: Synthetic skin item, surgery.

/obj/item/synthetic_skin
	name = "synthetic skin"
	desc = "Currently this can only be used in throat surgery."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "synthetic_skin"

/obj/item/damp_paper
	name = "damp paper"
	desc = "Paper that's damp with ethanol. Can be used as a substitute for synthetic skin, although not as effective."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "damp_paper"

/datum/surgery/cutthroat_surgery
	name = "cut-throat surgery"
	steps = list(/datum/surgery_step/clamp_bleeders, /datum/surgery_step/retract_skin, /datum/surgery_step/position_vessels, /datum/surgery_step/close, /datum/surgery_step/apply_synthetic_skin)
	species = list(/mob/living/carbon/human)
	location = "head"

/datum/surgery_step/position_vessels
	implements = list(/obj/item/weapon/retractor = 100, /obj/item/weapon/screwdriver = 45, /obj/item/weapon/wirecutters = 35)
	time = 48

/datum/surgery_step/position_vessels/preop(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("<span class='notice'>[user] begins to position [target]'s vessels.</span>")

/datum/surgery_step/position_vessels/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("<span class='notice'>[user] successfully positions [target]'s vessels!</span>") //Should fix bloodloss
	var/obj/item/organ/limb/head/H = target.get_organ(target_zone)
	if(H)
		H.bloodloss = 0 //No more bleeding! Woo!
	return 1

/datum/surgery_step/apply_synthetic_skin
	implements = list(/obj/item/synthetic_skin = 100, /obj/item/damp_paper = 70)
	time = 32

/datum/surgery_step/apply_synthetic_skin/preop(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message("<span class='notice'>[user] begins to apply [tool] on [target]'s throat.</span>")

/datum/surgery_step/apply_synthetic_skin/success(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(istype(tool, /obj/item/damp_paper)) //Not the most ideal substitute
		target.apply_damage(rand(5,7), BURN, target_zone)
		user << "<span class='danger'>\The [tool] has visibly burned [target]'s skin!</span>"
	user.visible_message("<span class='notice'>[user] applies [tool] onto [target]'s throat!</span>")
	user.drop_item()
	qdel(tool)
	var/obj/item/organ/limb/head/H = target.get_organ(target_zone)
	if(H)
		H.has_slit_throat = 0 //Fix dat slit throat
	return 1