
/////////
//FLAGS//

/////////
//These are the flags which tell what certain effects are allowed to do.

#define EFFECT_BUMPED_REACT			1 //React when someone/something bumps into it
#define EFFECT_ATTACKHAND_REACT		2 //React when someone attacks it with a hand. Item artifacts will react when picked up, etc.
#define EFFECT_ATTACKSELF_REACT		4 //React to activate_held_object. Only supported by item artifacts.
#define EFFECT_ATTACK_REACT			8 //React to being attacked with a weapon/etc.
#define EFFECT_EXAMINE_REACT		16 //React to examine. Make sure to check whether or not the mob examining it is living first.
#define EFFECT_CROSSED_REACT		32 //React to mob passing through the same tile as artifact.
#define EFFECT_MOVE_REACT			64 //React to movement. Applies to self, e.g. when an artifact is pulled around.
#define EFFECT_DESTROY_REACT		128 //React to destruction of self.
#define EFFECT_PULL_REACT			256 //React to user trying to pull the object.
#define EFFECT_PROCESS				512 //Do action every tick. Artifact itself has to have has_process set to 1 first.
// #define EFFECT_X_REACT			1024
// #define EFFECT_X_REACT			2048
// #define EFFECT_X_REACT			4096

//This is all the flags combined into one constant expression.
var/const/EFFECT_ALL =	(
						EFFECT_BUMPED_REACT|EFFECT_ATTACKHAND_REACT|EFFECT_ATTACKSELF_REACT|EFFECT_ATTACK_REACT|\
						EFFECT_EXAMINE_REACT|EFFECT_CROSSED_REACT|EFFECT_MOVE_REACT|EFFECT_DESTROY_REACT|\
						EFFECT_PULL_REACT|EFFECT_PROCESS
						)

//////////
//DATUMS//
//////////

//This is the datum-based effects system.
//For new effects, check if parent has succeeded before doing anything.

datum/xeno_effect
	var/name = "effect" //effect name displayed for a possible research system.
	var/id = "" //Xenoarch datums work similar to chemicals. Set this to a unique ID
	var/desc = "Does stuff." //Description for a possible research system.
	var/atom/source = null //This effect's source object.
	var/flags = 0 //Reaction flags here.

datum/xeno_effect/New(var/atom/newsrc)
	source = newsrc

datum/xeno_effect/proc/bumped_react(atom/AM as mob|obj) //When bumped into
	if(!(flags & EFFECT_BUMPED_REACT)) //No appropriate flag, return 0.
		return 0
	return 1

datum/xeno_effect/proc/attackhand_react(mob/user as mob) //When activated with empty hand
	if(!(flags & EFFECT_ATTACKHAND_REACT)) //No appropriate flag, return 0.
		return 0
	return 1

datum/xeno_effect/proc/attackself_react(mob/user as mob) //Items only - when activated in hand.
	if(!(flags & EFFECT_ATTACKSELF_REACT)) //No appropriate flag, return 0.
		return 0
	return 1

datum/xeno_effect/proc/attack_react(obj/item/W, mob/user, params) //When attacked with something
	if(!(flags & EFFECT_ATTACK_REACT)) //No appropriate flag, return 0.
		return 0
	return 1

datum/xeno_effect/proc/examine_react(mob/user as mob) //When examined by someone. WARNING: Ghosts can also cause a reaction unless you specifically check if user is living!
	if(!(flags & EFFECT_EXAMINE_REACT)) //No appropriate flag, return 0.
		return 0
	return 1

datum/xeno_effect/proc/crossed_react(atom/movable/AM)
	if(!(flags & EFFECT_CROSSED_REACT)) //No appropriate flag, return 0.
		return 0
	return 1

datum/xeno_effect/proc/move_react(atom/newloc, direct) //What happens when this object is moved?
	if(!(flags & EFFECT_MOVE_REACT)) //No appropriate flag, return 0.
		return 0
	return 1

datum/xeno_effect/proc/destroy_react() //What happens when this object is destroyed?
	if(!(flags & EFFECT_DESTROY_REACT)) //No appropriate flag, return 0.
		return 0
	return 1

datum/xeno_effect/proc/pull_react(mob/user as mob)
	if(!(flags & EFFECT_PULL_REACT)) //No appropriate flag, return 0.
		return 0
	return 1

datum/xeno_effect/proc/process()
	if(!(flags & EFFECT_PROCESS)) //No appropriate flag, return 0.
		return 0
	return 1