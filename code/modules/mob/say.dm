//Speech verbs.
/mob/verb/say_verb(message as text|null)
	set name = "Say"
	set category = "IC"
	set hidden = 1 //Because BYOND's input windows are shit and you can't use winget() from them.
	// winset(usr, "say_window", "focus=0")
	winshow(usr, "say_window", 0)
	spawn(1) //Reset text after a short delay so user doesn't see it cleared
		winset(usr, "say_window.say_input", "text=[null]")
	if(say_disabled)	//This is here to try to identify lag problems
		usr << "<span class='danger'>Speech is currently admin-disabled.</span>"
		return
	usr.say(message)

/mob/verb/say_sendtext(input as text|null) //This exists so the confirmation button works properly.
	set name = "say_sendtext"
	set hidden = 1
	if(!input)
		input = winget(usr, "say_window.say_input", "text")
	say_verb(input)

/mob/verb/whisper(message as text)
	set name = "Whisper"
	set category = "IC"
	return

/mob/verb/me_verb(message as text)
	set name = "Me"
	set category = "IC"

	if(say_disabled)	//This is here to try to identify lag problems
		usr << "<span class='danger'>Speech is currently admin-disabled.</span>"
		return

	message = trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN))

	usr.emote("me",1,message)

/mob/proc/say_dead(var/message)
	var/name = src.real_name
	var/alt_name = ""

	if(say_disabled)	//This is here to try to identify lag problems
		usr << "<span class='danger'>Speech is currently admin-disabled.</span>"
		return

	if(mind && mind.name)
		name = "[mind.name]"
	else
		name = real_name
	if(name != real_name)
		alt_name = " (died as [real_name])"
	if(message == "*fart" || message == "*scream")
		src << "<span class='danger'>Please don't do emotes in the chat. ([message])</span>"
		return

	message = src.say_quote(message)

	var/rendered = "<span class='game deadsay'><span class='prefix'>DEAD:</span> <span class='name'>[name]</span>[alt_name] <span class='message'>[message]</span></span>"

	for(var/mob/M in player_list)
		if(istype(M, /mob/new_player))
			continue
		if(M.client && M.client.holder && (M.client.prefs.toggles & CHAT_DEAD)) //admins can toggle deadchat on and off. This is a proc in admin.dm and is only give to Administrators and above
			M << rendered	//Admins can hear deadchat, if they choose to, no matter if they're blind/deaf or not.
		else if(M.stat == DEAD)
			//M.show_message(rendered, 2) //Takes into account blindness and such. //preserved so you can look at it and cry at the stupidity of oldcoders. whoever coded this should be punched into the sun
			M << rendered

/mob/proc/emote(var/act)
	return

/mob/proc/hivecheck()
	return 0

/mob/proc/lingcheck()
	return 0
