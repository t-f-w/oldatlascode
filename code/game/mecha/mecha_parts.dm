/////////////////////////
////// Mecha Parts //////
/////////////////////////

/obj/item/mecha_parts
	name = "mecha part"
	icon = 'icons/mecha/mech_construct.dmi'
	icon_state = "blank"
	w_class = 6
	flags = CONDUCT
	origin_tech = "programming=2;materials=2"

/obj/item/mecha_parts/chassis
	name="Mecha Chassis"
	icon_state = "backbone"
	var/datum/construction/construct

/obj/item/mecha_parts/chassis/attackby(obj/item/W as obj, mob/user as mob)
	if(!construct || !construct.action(W, user))
		..()
	return

/obj/item/mecha_parts/chassis/attack_hand()
	return

/////////// Ripley

/obj/item/mecha_parts/chassis/ripley
	name = "\improper Ripley chassis"

/obj/item/mecha_parts/chassis/ripley/New()
	..()
	construct = new /datum/construction/mecha/ripley_chassis(src)

/obj/item/mecha_parts/part/ripley_torso
	name = "\improper Ripley torso"
	desc = "A torso part of Ripley APLU. Contains power unit, processing core and life support systems."
	icon_state = "ripley_harness"
	origin_tech = "programming=2;materials=2;biotech=2;engineering=2"

/obj/item/mecha_parts/part/ripley_left_arm
	name = "\improper Ripley left arm"
	desc = "A Ripley APLU left arm. Data and power sockets are compatible with most exosuit tools."
	icon_state = "ripley_l_arm"
	origin_tech = "programming=2;materials=2;engineering=2"

/obj/item/mecha_parts/part/ripley_right_arm
	name = "\improper Ripley right arm"
	desc = "A Ripley APLU right arm. Data and power sockets are compatible with most exosuit tools."
	icon_state = "ripley_r_arm"
	origin_tech = "programming=2;materials=2;engineering=2"

/obj/item/mecha_parts/part/ripley_left_leg
	name = "\improper Ripley left leg"
	desc = "A Ripley APLU left leg. Contains somewhat complex servodrives and balance maintaining systems."
	icon_state = "ripley_l_leg"
	origin_tech = "programming=2;materials=2;engineering=2"

/obj/item/mecha_parts/part/ripley_right_leg
	name = "\improper Ripley right leg"
	desc = "A Ripley APLU right leg. Contains somewhat complex servodrives and balance maintaining systems."
	icon_state = "ripley_r_leg"
	origin_tech = "programming=2;materials=2;engineering=2"

///////// Gygax

/obj/item/mecha_parts/chassis/gygax
	name = "\improper Gygax chassis"

/obj/item/mecha_parts/chassis/gygax/New()
	..()
	construct = new /datum/construction/mecha/gygax_chassis(src)

/obj/item/mecha_parts/part/gygax_torso
	name = "\improper Gygax torso"
	desc = "A torso part of Gygax. Contains power unit, processing core and life support systems."
	icon_state = "gygax_harness"
	origin_tech = "programming=2;materials=2;biotech=3;engineering=3"

/obj/item/mecha_parts/part/gygax_head
	name = "\improper Gygax head"
	desc = "A Gygax head. Houses advanced surveilance and targeting sensors."
	icon_state = "gygax_head"
	origin_tech = "programming=2;materials=2;magnets=3;engineering=3"

/obj/item/mecha_parts/part/gygax_left_arm
	name = "\improper Gygax left arm"
	desc = "A Gygax left arm. Data and power sockets are compatible with most exosuit tools and weapons."
	icon_state = "gygax_l_arm"
	origin_tech = "programming=2;materials=2;engineering=3"

/obj/item/mecha_parts/part/gygax_right_arm
	name = "\improper Gygax right arm"
	desc = "A Gygax right arm. Data and power sockets are compatible with most exosuit tools and weapons."
	icon_state = "gygax_r_arm"
	origin_tech = "programming=2;materials=2;engineering=3"

/obj/item/mecha_parts/part/gygax_left_leg
	name = "\improper Gygax left leg"
	desc = "A Gygax left leg. Constructed with advanced servomechanisms and actuators to enable faster speed."
	icon_state = "gygax_l_leg"
	origin_tech = "programming=2;materials=2;engineering=3"

/obj/item/mecha_parts/part/gygax_right_leg
	name = "\improper Gygax right leg"
	desc = "A Gygax right leg. Constructed with advanced servomechanisms and actuators to enable faster speed."
	icon_state = "gygax_r_leg"
	origin_tech = "programming=2;materials=2;engineering=3"

/obj/item/mecha_parts/part/gygax_armor
	gender = PLURAL
	name = "\improper Gygax armor plates"
	desc = "A set of armor plates designed for the Gygax. Designed to effectively deflect damage with a lightweight construction."
	icon_state = "gygax_armor"
	origin_tech = "materials=6;combat=4;engineering=5"


//////////// Durand

/obj/item/mecha_parts/chassis/durand
	name = "\improper Durand chassis"

/obj/item/mecha_parts/chassis/durand/New()
	..()
	construct = new /datum/construction/mecha/durand_chassis(src)

/obj/item/mecha_parts/part/durand_torso
	name = "\improper Durand torso"
	desc = "A torso part of Durand. Contains power unit, processing core and life support systems within a robust protective frame."
	icon_state = "durand_harness"
	origin_tech = "programming=2;materials=3;biotech=3;engineering=3"

/obj/item/mecha_parts/part/durand_head
	name = "\improper Durand head"
	desc = "A Durand head. Houses advanced surveilance and targeting sensors."
	icon_state = "durand_head"
	origin_tech = "programming=2;materials=3;magnets=3;engineering=3"

/obj/item/mecha_parts/part/durand_left_arm
	name = "\improper Durand left arm"
	desc = "A Durand left arm. Data and power sockets are compatible with most exosuit tools and weapons. Packs a really mean punch as well."
	icon_state = "durand_l_arm"
	origin_tech = "programming=2;materials=3;engineering=3"

/obj/item/mecha_parts/part/durand_right_arm
	name = "\improper Durand right arm"
	desc = "A Durand right arm. Data and power sockets are compatible with most exosuit tools and weapons. Packs a really mean punch as well."
	icon_state = "durand_r_arm"
	origin_tech = "programming=2;materials=3;engineering=3"

/obj/item/mecha_parts/part/durand_left_leg
	name = "\improper Durand left leg"
	desc = "A Durand left leg. Built particlarly sturdy to support the Durand's heavy weight and defensive needs."
	icon_state = "durand_l_leg"
	origin_tech = "programming=2;materials=3;engineering=3"

/obj/item/mecha_parts/part/durand_right_leg
	name = "\improper Durand right leg"
	desc = "A Durand right leg. Built particlarly sturdy to support the Durand's heavy weight and defensive needs."
	icon_state = "durand_r_leg"
	origin_tech = "programming=2;materials=3;engineering=3"

/obj/item/mecha_parts/part/durand_armor
	gender = PLURAL
	name = "\improper Durand armor plates"
	desc = "A set of armor plates for the Durand. Built heavy to resist an incredible amount of brute force."
	icon_state = "durand_armor"
	origin_tech = "materials=5;combat=4;engineering=5"

////////// Firefighter

/obj/item/mecha_parts/chassis/firefighter
	name = "Firefighter chassis"

/obj/item/mecha_parts/chassis/firefighter/New()
	..()
	construct = new /datum/construction/mecha/firefighter_chassis(src)
/*
/obj/item/mecha_parts/part/firefighter_torso
	name="Ripley-on-Fire Torso"
	icon_state = "ripley_harness"

/obj/item/mecha_parts/part/firefighter_left_arm
	name="Ripley-on-Fire Left Arm"
	icon_state = "ripley_l_arm"

/obj/item/mecha_parts/part/firefighter_right_arm
	name="Ripley-on-Fire Right Arm"
	icon_state = "ripley_r_arm"

/obj/item/mecha_parts/part/firefighter_left_leg
	name="Ripley-on-Fire Left Leg"
	icon_state = "ripley_l_leg"

/obj/item/mecha_parts/part/firefighter_right_leg
	name="Ripley-on-Fire Right Leg"
	icon_state = "ripley_r_leg"
*/

////////// HONK

/obj/item/mecha_parts/chassis/honker
	name = "\improper H.O.N.K chassis"

/obj/item/mecha_parts/chassis/honker/New()
	..()
	construct = new /datum/construction/mecha/honker_chassis(src)

/obj/item/mecha_parts/part/honker_torso
	name = "\improper H.O.N.K torso"
	desc = "A torso part of H.O.N.K. Contains chuckle unit, bananium core and honk support systems."
	icon_state = "honker_harness"

/obj/item/mecha_parts/part/honker_head
	name = "\improper H.O.N.K head"
	desc = "A H.O.N.K head. Appears to lack a face plate."
	icon_state = "honker_head"

/obj/item/mecha_parts/part/honker_left_arm
	name = "\improper H.O.N.K left arm"
	desc = "A H.O.N.K left arm. With unique sockets that accept odd weaponry designed by clown scientists."
	icon_state = "honker_l_arm"

/obj/item/mecha_parts/part/honker_right_arm
	name = "\improper H.O.N.K right arm"
	desc = "A H.O.N.K right arm. With unique sockets that accept odd weaponry designed by clown scientists."
	icon_state = "honker_r_arm"

/obj/item/mecha_parts/part/honker_left_leg
	name = "\improper H.O.N.K left leg"
	desc = "A H.O.N.K left leg. The foot appears just large enough to fully accomodate a clown shoe."
	icon_state = "honker_l_leg"

/obj/item/mecha_parts/part/honker_right_leg
	name = "\improper H.O.N.K right leg"
	desc = "A H.O.N.K right leg. The foot appears just large enough to fully accomodate a clown shoe."
	icon_state = "honker_r_leg"


////////// Phazon

/obj/item/mecha_parts/chassis/phazon
	name = "\improper Phazon chassis"
	origin_tech = "materials=6"

/obj/item/mecha_parts/chassis/phazon/New()
	..()
	construct = new /datum/construction/mecha/phazon_chassis(src)

/obj/item/mecha_parts/part/phazon_torso
	name="\improper Phazon torso"
	desc="A Phazon torso part. The socket for the bluespace core that powers the exosuit's unique phase drives is located in the middle."
	icon_state = "phazon_harness"
	origin_tech = "programming=5;materials=6;bluespace=5;powerstorage=5"

/obj/item/mecha_parts/part/phazon_head
	name="\improper Phazon head"
	desc="A Phazon head. Its sensors are carefully calibrated to provide vision and data even when the exosuit is phasing."
	icon_state = "phazon_head"
	origin_tech = "programming=4;materials=5;magnets=5"

/obj/item/mecha_parts/part/phazon_left_arm
	name="\improper Phazon left arm"
	desc="A Phazon left arm. Several microtool arrays are located under the armor plating, which can be adjusted to the situation at hand."
	icon_state = "phazon_l_arm"
	origin_tech = "materials=5;bluespace=2;magnets=2"

/obj/item/mecha_parts/part/phazon_right_arm
	name="\improper Phazon right arm"
	desc="A Phazon right arm. Several microtool arrays are located under the armor plating, which can be adjusted to the situation at hand."
	icon_state = "phazon_r_arm"
	origin_tech = "materials=5;bluespace=2;magnets=2"

/obj/item/mecha_parts/part/phazon_left_leg
	name="\improper Phazon left leg"
	desc="A Phazon left leg. It contains the unique phase drives that allow the exosuit to phase through solid matter when engaged."
	icon_state = "phazon_l_leg"
	origin_tech = "materials=5;bluespace=3;magnets=3"

/obj/item/mecha_parts/part/phazon_right_leg
	name="\improper Phazon right leg"
	desc="A Phazon right leg. It contains the unique phase drives that allow the exosuit to phase through solid matter when engaged."
	icon_state = "phazon_r_leg"
	origin_tech = "materials=5;bluespace=3;magnets=3"

/obj/item/mecha_parts/part/phazon_armor
	name="Phazon armor"
	desc="Phazon armor plates. They are layered with plasma to protect the pilot from the stress of phasing and have unusual properties."
	icon_state = "phazon_armor"
	origin_tech = "materials=6;bluespace=5;magnets=5"
///////// Odysseus


/obj/item/mecha_parts/chassis/odysseus
	name = "\improper Odysseus chassis"

/obj/item/mecha_parts/chassis/odysseus/New()
	..()
	construct = new /datum/construction/mecha/odysseus_chassis(src)

/obj/item/mecha_parts/part/odysseus_head
	name = "\improper Odysseus head"
	desc = "An Odysseus head. Contains an integrated medical HUD scanner."
	icon_state = "odysseus_head"
	origin_tech = "programming=3;materials=2"

/obj/item/mecha_parts/part/odysseus_torso
	name = "\improper Odysseus torso"
	desc="A torso part of Odysseus. Contains power unit, processing core and life support systems along with an attachment port for a mounted sleeper."
	icon_state = "odysseus_torso"
	origin_tech = "programming=2;materials=2;biotech=2;engineering=2"

/obj/item/mecha_parts/part/odysseus_left_arm
	name = "\improper Odysseus left arm"
	desc = "An Odysseus left arm. Data and power sockets are compatible with specialized medical equipment."
	icon_state = "odysseus_l_arm"
	origin_tech = "programming=2;materials=2;engineering=2"

/obj/item/mecha_parts/part/odysseus_right_arm
	name = "\improper Odysseus right arm"
	desc = "An Odysseus right arm. Data and power sockets are compatible with specialized medical equipment."
	icon_state = "odysseus_r_arm"
	origin_tech = "programming=2;materials=2;engineering=2"

/obj/item/mecha_parts/part/odysseus_left_leg
	name = "\improper Odysseus left leg"
	desc = "An Odysseus left leg. Contains complex servodrives and balance maintaining systems to maintain stability for critical patients."
	icon_state = "odysseus_l_leg"
	origin_tech = "programming=2;materials=2;engineering=2"

/obj/item/mecha_parts/part/odysseus_right_leg
	name = "\improper Odysseus right leg"
	desc = "A Odysseus right leg. Contains complex servodrives and balance maintaining systems to maintain stability for critical patients."
	icon_state = "odysseus_r_leg"
	origin_tech = "programming=2;materials=2;engineering=2"

/*/obj/item/mecha_parts/part/odysseus_armor
	name="Odysseus Carapace"
	icon_state = "odysseus_armor"
	origin_tech = "materials=3;engineering=3"
	construction_time = 200
	construction_cost = list("metal"=15000)*/


///////// Circuitboards

/obj/item/weapon/circuitboard/mecha
	name = "exosuit circuit board"
	icon = 'icons/obj/module.dmi'
	icon_state = "std_mod"
	item_state = "electronic"
	board_type = "other"
	flags = CONDUCT
	force = 5.0
	w_class = 2.0
	throwforce = 0
	throw_speed = 3
	throw_range = 7

/obj/item/weapon/circuitboard/mecha/ripley
	origin_tech = "programming=3"

/obj/item/weapon/circuitboard/mecha/ripley/peripherals
	name = "circuit board (Ripley Peripherals Control module)"
	icon_state = "mcontroller"

/obj/item/weapon/circuitboard/mecha/ripley/main
	name = "circuit board (Ripley Central Control module)"
	icon_state = "mainboard"

/obj/item/weapon/circuitboard/mecha/gygax
	origin_tech = "programming=4"

/obj/item/weapon/circuitboard/mecha/gygax/peripherals
	name = "circuit board (Gygax Peripherals Control module)"
	icon_state = "mcontroller"

/obj/item/weapon/circuitboard/mecha/gygax/targeting
	name = "circuit board (Gygax Weapon Control and Targeting module)"
	icon_state = "mcontroller"
	origin_tech = "programming=4;combat=4"

/obj/item/weapon/circuitboard/mecha/gygax/main
	name = "circuit board (Gygax Central Control module)"
	icon_state = "mainboard"

/obj/item/weapon/circuitboard/mecha/durand
	origin_tech = "programming=4"

/obj/item/weapon/circuitboard/mecha/durand/peripherals
	name = "circuit board (Durand Peripherals Control module)"
	icon_state = "mcontroller"

/obj/item/weapon/circuitboard/mecha/durand/targeting
	name = "circuit board (Durand Weapon Control and Targeting module)"
	icon_state = "mcontroller"
	origin_tech = "programming=4;combat=4"

/obj/item/weapon/circuitboard/mecha/durand/main
	name = "circuit board (Durand Central Control module)"
	icon_state = "mainboard"

/obj/item/weapon/circuitboard/mecha/honker
	origin_tech = "programming=4"

/obj/item/weapon/circuitboard/mecha/honker/peripherals
	name = "circuit board (H.O.N.K Peripherals Control module)"
	icon_state = "mcontroller"

/obj/item/weapon/circuitboard/mecha/honker/targeting
	name = "circuit board (H.O.N.K Weapon Control and Targeting module)"
	icon_state = "mcontroller"

/obj/item/weapon/circuitboard/mecha/honker/main
	name = "circuit board (H.O.N.K Central Control module)"
	icon_state = "mainboard"

/obj/item/weapon/circuitboard/mecha/odysseus
	origin_tech = "programming=3"

/obj/item/weapon/circuitboard/mecha/odysseus/peripherals
	name = "circuit board (Odysseus Peripherals Control module)"
	icon_state = "mcontroller"

/obj/item/weapon/circuitboard/mecha/odysseus/main
	name = "circuit board (Odysseus Central Control module)"
	icon_state = "mainboard"

/obj/item/weapon/circuitboard/mecha/phazon
	origin_tech = "programming=5"

/obj/item/weapon/circuitboard/mecha/phazon/peripherals
	name = "circuit board (Phazon Peripherals Control module)"
	icon_state = "mcontroller"

/obj/item/weapon/circuitboard/mecha/phazon/targeting
	name = "circuit board (Phazon Weapon Control and Targeting module)"
	icon_state = "mcontroller"

/obj/item/weapon/circuitboard/mecha/phazon/main
	name = "circuit board (Phazon Central Control module)"

/obj/item/weapon/circuitboard/mecha/pod
		name = "Circuit board (Space Pod Mainboard)"
		icon_state = "mainboard"