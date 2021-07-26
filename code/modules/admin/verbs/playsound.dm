// #define SOUND_CHANNEL_ADMIN 777
var/list/sounds_cache = list()
var/sound/admin_sound

/client/proc/play_sound(S as sound)
	set category = "Fun"
	set name = "Play Global Sound"
	if(!check_rights(R_SOUNDS))	return

	admin_sound = sound(S, repeat = 0, wait = 1, channel = 7)
	admin_sound.priority = 250
	admin_sound.status = SOUND_UPDATE|SOUND_STREAM

	sounds_cache += S

	log_admin("[key_name(src)] played sound [S]")
	message_admins("[key_name_admin(src)] played sound [S]")

	if(events.holiday == "April Fool's Day")
		admin_sound.frequency = pick(0.5, 0.7, 0.8, 0.85, 0.9, 0.95, 1.1, 1.2, 1.4, 1.6, 2.0, 2.5)
		src << "You feel the Honkmother messing with your song..."

	for(var/mob/M in player_list)
		if(M.client.prefs.toggles & SOUND_MIDI)
			M << admin_sound

	admin_sound.frequency = 1 //Remove this line when the AFD stuff above is gone
	admin_sound.wait = 0
	feedback_add_details("admin_verb","PGS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/proc/play_local_sound(S as sound)
	set category = "Fun"
	set name = "Play Local Sound"
	if(!check_rights(R_SOUNDS))	return

	log_admin("[key_name(src)] played a local sound [S]")
	message_admins("[key_name_admin(src)] played a local sound [S]")
	playsound(get_turf(src.mob), S, 50, 0, 0)
	feedback_add_details("admin_verb","PLS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/play_advanced_sound(S as sound)
	set category = "Debug"
	set name = "Play Advanced Sound"
	if(!check_rights(R_SOUNDS))	return
	var/vol = input("Input volume","Volume:", null) as num|null
	if(vol < 0)	return
	var/range = input("Input extra range","Extra range:", null) as num|null
	if(range < 0)	return
	var/falloff = input("Input falloff","Falloff:", null) as num|null
	if(falloff < 0) return

	var/choice = input(src, "Do you want to set echo manually or randomise it?", "Echo") in list("Manual", "Random")
	var/list/Echo = list()
	if(choice == "Manual")
		for(var/i = 1 to 18)
			var/check = input("Input var [i] for echo", "Echo var [i]:", null) as num|null
			Echo += check
	else
		Echo = build_random_echo()

	log_admin("[key_name(src)] played an advanced sound [S]")
	message_admins("[key_name_admin(src)] played an advanced sound [S]")
	playsound(get_turf(src.mob), S, vol, 0, range, falloff, echo = Echo)
	feedback_add_details("admin_verb","PLA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/echo_test()
	set category = "Debug"
	set name = "Local Echo Test"
	if(!check_rights(R_SOUNDS))	return

	var/list/Echo = list()
	Echo = build_random_echo()
	var/text
	for(var/i = 1 to 18)
		if(i == 1)
			text = "[i]: [Echo[i]]"
		else
			text = "[text], [i]: [Echo[i]]"
	log_admin("[key_name(src)] played an echo test sound with params: [text]")
	message_admins("[key_name_admin(src)] played an echo test sound with params: [text]")
	playsound(get_turf(src.mob), 'sound/effects/bang.ogg', 50, 0, 0, echo = Echo)
	feedback_add_details("admin_verb","PLA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/play_server_sound()
	set category = "Fun"
	set name = "Play Server Sound"
	if(!check_rights(R_SOUNDS))	return

	var/list/sounds = file2list("sound/serversound_list.txt");
	sounds += sounds_cache //It looks really dumb being below the cancel button
	sounds += "--CANCEL--"

	var/melody = input("Select a sound from the server to play", "Server sound list", "--CANCEL--") in sounds

	if(melody == "--CANCEL--")	return

	play_sound(melody)
	feedback_add_details("admin_verb","PSS") //If you are copy-pasting this, ensure the 2nd paramter is unique to the new proc!


/client/proc/stop_sounds()
	set category = "Debug"
	set name = "Stop Sounds"
	if(!src.holder) return

	log_admin("[key_name(src)] stopped all currently playing sounds.")
	message_admins("[key_name_admin(src)] stopped all currently playing sounds.")
	for(var/mob/M in player_list)
		if(M.client)
			M << sound(null)
	feedback_add_details("admin_verb","SS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

// #undef SOUND_CHANNEL_ADMIN