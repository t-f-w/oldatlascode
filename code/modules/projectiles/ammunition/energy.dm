/obj/item/ammo_casing/energy
	name = "energy weapon lens"
	desc = "The part of the gun that makes the laser go pew"
	caliber = "energy"
	projectile_type = /obj/item/projectile/energy
	var/e_cost = 100 //The amount of energy a cell needs to expend to create this shot.
	var/select_name = "energy"
	var/mod_name = null
	fire_sound = 'sound/weapons/Laser.ogg'

/obj/item/ammo_casing/energy/laser
	projectile_type = /obj/item/projectile/beam
	select_name = "kill"

/obj/item/ammo_casing/energy/lasergun
	projectile_type = /obj/item/projectile/beam
	e_cost = 62.5
	select_name = "beam"

/obj/item/ammo_casing/energy/laser/practice
	projectile_type = /obj/item/projectile/practice
	select_name = "practice"

/obj/item/ammo_casing/energy/laser/scatter
	projectile_type = /obj/item/projectile/beam/scatter
	pellets = 6
	variance = 25
	select_name = "spread"

/obj/item/ammo_casing/energy/laser/heavy
	projectile_type = /obj/item/projectile/beam/heavylaser
	select_name = "high-power beam"
	fire_sound = 'sound/weapons/lasercannonfire.ogg'

/obj/item/ammo_casing/energy/laser/pulse
	projectile_type = /obj/item/projectile/beam/pulse
	e_cost = 200
	select_name = "DESTROY"
	fire_sound = 'sound/weapons/pulse.ogg'

/obj/item/ammo_casing/energy/laser/bluetag
	projectile_type = /obj/item/projectile/lasertag/bluetag
	select_name = "bluetag"

/obj/item/ammo_casing/energy/laser/redtag
	projectile_type = /obj/item/projectile/lasertag/redtag
	select_name = "redtag"

/obj/item/ammo_casing/energy/bolt
	projectile_type = /obj/item/projectile/energy/bolt
	select_name = "bolt"
	fire_sound = 'sound/weapons/Genhit.ogg'
	sound_extrarange = -14 //Silence it

/obj/item/ammo_casing/energy/bolt/large
	projectile_type = /obj/item/projectile/energy/bolt/large
	select_name = "heavy bolt"
	sound_extrarange = 0

/obj/item/ammo_casing/energy/xray
	projectile_type = /obj/item/projectile/beam/xray
	e_cost = 50
	fire_sound = 'sound/weapons/laser3.ogg'

/obj/item/ammo_casing/energy/electrode
	projectile_type = /obj/item/projectile/energy/electrode
	select_name = "stun"
	fire_sound = 'sound/weapons/taser.ogg'

/obj/item/ammo_casing/energy/electrode/gun
	fire_sound = 'sound/weapons/gunshot.ogg'

/obj/item/ammo_casing/energy/ion
	projectile_type = /obj/item/projectile/ion
	select_name = "ion"
	fire_sound = 'sound/weapons/IonRifle.ogg'

/obj/item/ammo_casing/energy/declone
	projectile_type = /obj/item/projectile/energy/declone
	select_name = "declone"
	fire_sound = 'sound/weapons/pulse3.ogg'

/obj/item/ammo_casing/energy/mindflayer
	projectile_type = /obj/item/projectile/beam/mindflayer
	select_name = "MINDFUCK"
	fire_sound = 'sound/weapons/Laser.ogg'

/obj/item/ammo_casing/energy/flora
	fire_sound = 'sound/effects/stealthoff.ogg'

/obj/item/ammo_casing/energy/flora/yield
	projectile_type = /obj/item/projectile/energy/florayield
	select_name = "increase yield"
	mod_name = "yield"

/obj/item/ammo_casing/energy/flora/mut
	projectile_type = /obj/item/projectile/energy/floramut
	select_name = "induce mutations"
	mod_name = "mut"

/obj/item/ammo_casing/energy/temp
	projectile_type = /obj/item/projectile/temp
	select_name = "freeze"
	e_cost = 250
	fire_sound = 'sound/weapons/pulse3.ogg'

/obj/item/ammo_casing/energy/temp/hot
	projectile_type = /obj/item/projectile/temp/hot
	select_name = "bake"

/obj/item/ammo_casing/energy/meteor
	projectile_type = /obj/item/projectile/meteor
	select_name = "goddamn meteor"

/obj/item/ammo_casing/energy/kinetic
	projectile_type = /obj/item/projectile/kinetic
	select_name = "kinetic"
	e_cost = 500
	fire_sound = 'sound/weapons/Kenetic_accel.ogg'

/obj/item/ammo_casing/energy/disabler
	projectile_type = /obj/item/projectile/beam/disabler
	select_name  = "disable"
	e_cost = 50
	fire_sound = "sound/weapons/taser2.ogg"

/obj/item/ammo_casing/energy/wormhole
	projectile_type = /obj/item/projectile/beam/wormhole
	e_cost = 0
	fire_sound = "sound/weapons/pulse3.ogg"
	var/obj/item/weapon/gun/energy/wormhole_projector/gun = null
	select_name = "blue"

/obj/item/ammo_casing/energy/wormhole/orange
	projectile_type = /obj/item/projectile/beam/wormhole/orange
	select_name = "orange"

