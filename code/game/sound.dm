proc/build_random_echo() //BYOND sucks at documenting this feature so somebody will have to figure it out through trial and error.
    var/list/echo[18]
    echo[1] = 1000//rand(-10000, 1000)  //direct
    echo[2] = 0//rand(-10000, 0)      //direct hf
    echo[3] = rand(-10000, 1000)      //room
    echo[4] = rand(-10000, 0)      //room hf -- this has some audible effect on the audio when negative
    echo[5] = rand(-10000, 0)      //obstruction -- this has some audible effect on the audio when negative
    echo[6] = rand(0, 100) * 0.01    //obstruction lf ratio
    echo[7] = rand(-10000, 0)      //occlusion -- this has some audible effect on the audio when negative
    echo[8] = rand(0, 100) * 0.01    //occlusion lf ratio
    echo[9] = rand(0, 100) * 0.1    //occlusion room ratio
    echo[10] = rand(0, 100) * 0.1    //occlusion direct ratio
    echo[11] = rand(-10000, 0)      //exclusion -- this has some audible effect on the audio when negative
    echo[12] = rand(0, 100) * 0.01    //exclusion lf ratio
    echo[13] = rand(-10000, 0)      //outside volume hf
    echo[14] = rand(0, 100) * 0.1    //doppler factor
    echo[15] = rand(0, 100) * 0.1    //rolloff factor
    echo[16] = rand(0, 100) * 0.1    //room roll off factor
    echo[17] = rand(0, 100) * 0.1    //air absorption factor
    echo[18] = 1 | 2 | 4 //flags

    return echo

/proc/playsound(var/atom/source, soundin, vol as num, vary, extrarange as num, falloff, surround = 1, var/list/echo, is_2d = 0)

	soundin = get_sfx(soundin) // same sound for everyone

	if(isarea(source))
		ERROR("[source] is an area and is trying to make the sound: [soundin]")
		return

	var/frequency = get_rand_frequency() // Same frequency for everybody
	var/turf/turf_source = get_turf(source)

 	// Looping through the player list has the added bonus of working for mobs inside containers
	for (var/P in player_list)
		var/mob/M = P
		if(!M || !M.client)
			continue
		if(get_dist(M, turf_source) <= SOUND_MAX_DISTANCE + extrarange)
			var/turf/T = get_turf(M)
			if(T && T.z == turf_source.z)
				M.playsound_local(turf_source, soundin, vol, vary, frequency, falloff, surround, echo, is_2d)


/atom/proc/playsound_local(var/turf/turf_source, soundin, vol as num, vary, frequency, falloff, surround = 1, var/list/echo, is_2d = 0)
	soundin = get_sfx(soundin)

	var/sound/S = sound(soundin)
	S.wait = 0 //No queue
	S.channel = 0 //Any channel
	S.volume = vol

	if (vary)
		if(frequency)
			S.frequency = frequency
		else
			S.frequency = get_rand_frequency()

	if(isturf(turf_source))
		var/turf/T = get_turf(src)
		var/area/A = get_area(T)
		if(A)
			if(!istype(echo, /list) && !is_2d && istype(A.echo, /list))
				echo = A.echo
		//Atmosphere affects sound
		var/pressure_factor = 1
		var/datum/gas_mixture/hearer_env = T.return_air()
		var/datum/gas_mixture/source_env = turf_source.return_air()

		if(hearer_env && source_env)
			var/pressure = min(hearer_env.return_pressure(), source_env.return_pressure())
			if(pressure < ONE_ATMOSPHERE)
				pressure_factor = max((pressure - SOUND_MINIMUM_PRESSURE)/(ONE_ATMOSPHERE - SOUND_MINIMUM_PRESSURE), 0)
		else //space
			pressure_factor = 0

		var/distance = get_dist(T, turf_source)
		if(distance <= 1)
			pressure_factor = max(pressure_factor, 0.15) //touching the source of the sound

		S.volume *= pressure_factor
		//End Atmosphere affecting sound

		if(S.volume <= 0)
			return //No sound

		// 3D sounds, the technology is here!
		if (surround)
			var/dx = (turf_source.x - T.x) // Hearing from the right/left
			S.x = round(max(-SURROUND_CAP, min(SURROUND_CAP, dx)), 1)

			var/dz = (turf_source.y - T.y) // Hearing from infront/behind
			S.z = round(max(-SURROUND_CAP, min(SURROUND_CAP, dz)), 1)

		//This is playing with the player's brain: when the sound plays in front AND above the player, their brain will react accordingly. Since our prespective is top down it helps the emulsions.
		S.y = round(S.z / 2) //This effect is extremely subtle, but it does seem to work pretty well.
		S.falloff = (falloff ? falloff : FALLOFF_SOUNDS)
		S.environment = 2 //"Room" environment - Can be any environment but I find room environment to be the least reverby. Environment is required for proper echo.
		if(istype(echo, /list)) //Echo MUST be a 18 parameter list or this shit won't work.
			S.echo = echo

		if(Debug2)
			world << "\blue Coords: [S.x] [S.y] [S.z] Falloff: [S.falloff] Volume: [S.volume]"

	src << S

/mob/playsound_local(var/turf/turf_source, soundin, vol as num, vary, frequency, falloff, surround = 1, environment = -1, is_2d = 0)
	if(!client || ear_deaf > 0)
		return
	..()

/client/proc/playtitlemusic()
	if(!ticker || !ticker.login_music)	return
	if(prefs.toggles & SOUND_LOBBY)
		var/sound/S = sound(ticker.login_music, repeat = 0, wait = 0, volume = 85, channel = 1)
		// S.environment = 2 //Room environment - essentialy no reverb
		src << S // MAD JAMS

/proc/get_rand_frequency()
	return rand(32000, 55000) //Frequency stuff only works with 45kbps oggs.

/proc/get_sfx(soundin)
	if(istext(soundin))
		switch(soundin)
			if ("shatter") soundin = pick('sound/effects/Glassbr1.ogg','sound/effects/Glassbr2.ogg','sound/effects/Glassbr3.ogg')
			if ("explosion") soundin = pick('sound/effects/Explosion1.ogg','sound/effects/Explosion2.ogg')
			if ("sparks") soundin = pick('sound/effects/sparks1.ogg','sound/effects/sparks2.ogg','sound/effects/sparks3.ogg','sound/effects/sparks4.ogg')
			if ("rustle") soundin = pick('sound/effects/rustle1.ogg','sound/effects/rustle2.ogg','sound/effects/rustle3.ogg','sound/effects/rustle4.ogg','sound/effects/rustle5.ogg')
			if ("bodyfall") soundin = pick('sound/effects/bodyfall1.ogg','sound/effects/bodyfall2.ogg','sound/effects/bodyfall3.ogg','sound/effects/bodyfall4.ogg')
			if ("punch") soundin = pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg')
			if ("clownstep") soundin = pick('sound/effects/clownstep1.ogg','sound/effects/clownstep2.ogg')
			if ("swing_hit") soundin = pick('sound/weapons/genhit1.ogg', 'sound/weapons/genhit2.ogg', 'sound/weapons/genhit3.ogg')
			if ("hiss") soundin = pick('sound/voice/hiss1.ogg','sound/voice/hiss2.ogg','sound/voice/hiss3.ogg','sound/voice/hiss4.ogg')
			if ("pageturn") soundin = pick('sound/effects/pageturn1.ogg', 'sound/effects/pageturn2.ogg','sound/effects/pageturn3.ogg')
			if ("gunshot") soundin = pick('sound/weapons/Gunshot.ogg', 'sound/weapons/Gunshot2.ogg','sound/weapons/Gunshot3.ogg','sound/weapons/Gunshot4.ogg')
			if ("ricochet") soundin = pick(	'sound/weapons/effects/ric1.ogg', 'sound/weapons/effects/ric2.ogg','sound/weapons/effects/ric3.ogg',\
											'sound/weapons/effects/ric4.ogg','sound/weapons/effects/ric5.ogg')
			if ("boxgloves") soundin = pick('sound/weapons/boxing1.ogg','sound/weapons/boxing2.ogg','sound/weapons/boxing3.ogg','sound/weapons/boxing4.ogg')
			//Footstep materials
			if ("tile") soundin = pick(	'sound/effects/footsteps/walk_tile_01.ogg','sound/effects/footsteps/walk_tile_02.ogg','sound/effects/footsteps/walk_tile_03.ogg',\
										'sound/effects/footsteps/walk_tile_04.ogg','sound/effects/footsteps/walk_tile_05.ogg')

			if ("metal") soundin = pick('sound/effects/footsteps/walk_solidmetal_01.ogg','sound/effects/footsteps/walk_solidmetal_02.ogg','sound/effects/footsteps/walk_solidmetal_03.ogg',\
										'sound/effects/footsteps/walk_solidmetal_04.ogg','sound/effects/footsteps/walk_solidmetal_05.ogg')

			if ("wood") soundin = pick(	'sound/effects/footsteps/walk_wood_01.ogg','sound/effects/footsteps/walk_wood_02.ogg','sound/effects/footsteps/walk_wood_03.ogg',\
										'sound/effects/footsteps/walk_wood_04.ogg','sound/effects/footsteps/walk_wood_05.ogg')

			if ("concrete") soundin = pick(	'sound/effects/footsteps/walk_concrete_01.ogg','sound/effects/footsteps/walk_concrete_02.ogg','sound/effects/footsteps/walk_concrete_03.ogg',\
											'sound/effects/footsteps/walk_concrete_04.ogg','sound/effects/footsteps/walk_concrete_05.ogg','sound/effects/footsteps/walk_concrete_06.ogg')
			if ("trayhit")	soundin = pick('sound/items/trayhit1.ogg','sound/items/trayhit2.ogg')
	return soundin
