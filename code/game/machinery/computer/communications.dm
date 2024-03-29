//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

var/const/CALL_SHUTTLE_REASON_LENGTH = 12

// The communications computer
/obj/machinery/computer/communications
	name = "communications console"
	desc = "This can be used for various important functions. Still under developement."
	icon_state = "comm"
	req_access = list(access_heads)
	circuit = /obj/item/weapon/circuitboard/communications
	var/authenticated = 0
	var/auth_id = "Unknown" //Who is currently logged in?
	var/list/messagetitle = list()
	var/list/messagetext = list()
	var/currmsg = 0
	var/aicurrmsg = 0
	var/state = STATE_DEFAULT
	var/aistate = STATE_DEFAULT
	var/message_cooldown = 0
	var/ai_message_cooldown = 0
	var/centcom_message_cooldown = 0
	var/tmp_alertlevel = 0
	var/const/STATE_DEFAULT = 1
	var/const/STATE_CALLSHUTTLE = 2
	var/const/STATE_CANCELSHUTTLE = 3
	var/const/STATE_MESSAGELIST = 4
	var/const/STATE_VIEWMESSAGE = 5
	var/const/STATE_DELMESSAGE = 6
	var/const/STATE_STATUSDISPLAY = 7
	var/const/STATE_ALERT_LEVEL = 8
	var/const/STATE_CONFIRM_LEVEL = 9
	var/const/STATE_TOGGLE_EMERGENCY = 10
	
	l_color = "#FFFFFF"

	var/status_display_freq = "1435"
	var/stat_msg1
	var/stat_msg2


/obj/machinery/computer/communications/New()
	shuttle_caller_list += src
	..()

/obj/machinery/computer/communications/process()
	if(..())
		if(state != STATE_STATUSDISPLAY)
			src.updateDialog()


/obj/machinery/computer/communications/Topic(href, href_list)
	if(..())
		return
	if (src.z > 1)
		usr << "<span class='userdanger'>Unable to establish a connection</span>: \black You're too far away from the station!"
		return
	usr.set_machine(src)

	if(!href_list["operation"])
		return
	var/obj/item/weapon/circuitboard/communications/CM = circuit
	switch(href_list["operation"])
		// main interface
		if("main")
			src.state = STATE_DEFAULT
		if("login")
			var/mob/M = usr
			var/obj/item/weapon/card/id/I = M.get_active_hand()
			if (istype(I, /obj/item/device/pda))
				var/obj/item/device/pda/pda = I
				I = pda.id
			if (I && istype(I))
				if(src.check_access(I))
					authenticated = 1
					auth_id = "[I.registered_name] ([I.assignment])"
					if((20 in I.access))
						authenticated = 2
				if(src.emagged)
					authenticated = 2
					auth_id = "Unknown"
		if("logout")
			authenticated = 0

		if("swipeidseclevel")
			var/mob/M = usr
			var/obj/item/weapon/card/id/I = M.get_active_hand()
			if (istype(I, /obj/item/device/pda))
				var/obj/item/device/pda/pda = I
				I = pda.id
			if (I && istype(I))
				if(access_captain in I.access)
					var/old_level = security_level
					if(!tmp_alertlevel) tmp_alertlevel = SEC_LEVEL_GREEN
					if(tmp_alertlevel < SEC_LEVEL_GREEN) tmp_alertlevel = SEC_LEVEL_GREEN
					if(tmp_alertlevel > SEC_LEVEL_BLUE) tmp_alertlevel = SEC_LEVEL_BLUE //Cannot engage delta with this
					set_security_level(tmp_alertlevel)
					if(security_level != old_level)
						//Only notify the admins if an actual change happened
						log_game("[key_name(usr)] has changed the security level to [get_security_level()].")
						message_admins("[key_name_admin(usr)] has changed the security level to [get_security_level()].")
						switch(security_level)
							if(SEC_LEVEL_GREEN)
								feedback_inc("alert_comms_green",1)
							if(SEC_LEVEL_BLUE)
								feedback_inc("alert_comms_blue",1)
					tmp_alertlevel = 0
				else:
					usr << "You are not authorized to do this."
					tmp_alertlevel = 0
				state = STATE_DEFAULT
			else
				usr << "You need to swipe your ID."

		if("announce")
			if(src.authenticated==2 && !message_cooldown)
				make_announcement(usr)

		if("callshuttle")
			src.state = STATE_DEFAULT
			if(src.authenticated)
				src.state = STATE_CALLSHUTTLE
		if("callshuttle2")
			if(src.authenticated)
				call_shuttle_proc(usr, href_list["call"])
				if(emergency_shuttle.online)
					post_status("shuttle")
			src.state = STATE_DEFAULT
		if("cancelshuttle")
			src.state = STATE_DEFAULT
			if(src.authenticated)
				src.state = STATE_CANCELSHUTTLE
		if("cancelshuttle2")
			if(src.authenticated)
				cancel_call_proc(usr)
			src.state = STATE_DEFAULT
		if("messagelist")
			src.currmsg = 0
			src.state = STATE_MESSAGELIST
		if("viewmessage")
			src.state = STATE_VIEWMESSAGE
			if (!src.currmsg)
				if(href_list["message-num"])
					src.currmsg = text2num(href_list["message-num"])
				else
					src.state = STATE_MESSAGELIST
		if("delmessage")
			src.state = (src.currmsg) ? STATE_DELMESSAGE : STATE_MESSAGELIST
		if("delmessage2")
			if(src.authenticated)
				if(src.currmsg)
					var/title = src.messagetitle[src.currmsg]
					var/text  = src.messagetext[src.currmsg]
					src.messagetitle.Remove(title)
					src.messagetext.Remove(text)
					if(src.currmsg == src.aicurrmsg)
						src.aicurrmsg = 0
					src.currmsg = 0
				src.state = STATE_MESSAGELIST
			else
				src.state = STATE_VIEWMESSAGE
		if("status")
			src.state = STATE_STATUSDISPLAY

		if("securitylevel")
			src.tmp_alertlevel = text2num( href_list["newalertlevel"] )
			if(!tmp_alertlevel) tmp_alertlevel = 0
			state = STATE_CONFIRM_LEVEL
		if("changeseclevel")
			state = STATE_ALERT_LEVEL

		if("emergencyaccess")
			state = STATE_TOGGLE_EMERGENCY
		if("enableemergency")
			make_maint_all_access()
			log_game("[key_name(usr)] enabled emergency maintenance access.")
			message_admins("[key_name_admin(usr)] enabled emergency maintenance access.")
			src.state = STATE_DEFAULT
		if("disableemergency")
			revoke_maint_all_access()
			log_game("[key_name(usr)] disabled emergency maintenance access.")
			message_admins("[key_name_admin(usr)] disabled emergency maintenance access.")
			src.state = STATE_DEFAULT

		// Status display stuff
		if("setstat")
			switch(href_list["statdisp"])
				if("message")
					post_status("message", stat_msg1, stat_msg2)
				if("alert")
					post_status("alert", href_list["alert"])
				else
					post_status(href_list["statdisp"])

		if("setmsg1")
			stat_msg1 = reject_bad_text(input("Line 1", "Enter Message Text", stat_msg1) as text|null, 40)
			src.updateDialog()
		if("setmsg2")
			stat_msg2 = reject_bad_text(input("Line 2", "Enter Message Text", stat_msg2) as text|null, 40)
			src.updateDialog()

		// OMG CENTCOM LETTERHEAD
		if("MessageCentcomm")
			if(src.authenticated==2)
				if(CM.cooldown)
					usr << "Arrays recycling.  Please stand by."
					return
				var/input = stripped_input(usr, "Please choose a message to transmit to Centcom via quantum entanglement.  Please be aware that this process is very expensive, and abuse will lead to... termination.  Transmission does not guarantee a response.", "To abort, send an empty message.", "")
				if(!input || !(usr in view(1,src)))
					return
				Centcomm_announce(input, usr)
				usr << "Message transmitted."
				log_say("[key_name(usr)] has made a Centcom announcement: [input]")
				CM.cooldown = 55


		// OMG SYNDICATE ...LETTERHEAD
		if("MessageSyndicate")
			if((src.authenticated==2) && (src.emagged))
				if(CM.cooldown)
					usr << "Arrays recycling.  Please stand by."
					return
				var/input = stripped_input(usr, "Please choose a message to transmit to \[ABNORMAL ROUTING COORDINATES\] via quantum entanglement.  Please be aware that this process is very expensive, and abuse will lead to... termination. Transmission does not guarantee a response.", "To abort, send an empty message.", "")
				if(!input || !(usr in view(1,src)))
					return
				Syndicate_announce(input, usr)
				usr << "Message transmitted."
				log_say("[key_name(usr)] has made a Syndicate announcement: [input]")
				CM.cooldown = 55 //about one minute

		if("RestoreBackup")
			usr << "Backup routing data restored!"
			src.emagged = 0
			src.updateDialog()



		// AI interface
		if("ai-main")
			src.aicurrmsg = 0
			src.aistate = STATE_DEFAULT
		if("ai-callshuttle")
			src.aistate = STATE_CALLSHUTTLE
		if("ai-callshuttle2")
			call_shuttle_proc(usr, href_list["call"])
			src.aistate = STATE_DEFAULT
		if("ai-messagelist")
			src.aicurrmsg = 0
			src.aistate = STATE_MESSAGELIST
		if("ai-viewmessage")
			src.aistate = STATE_VIEWMESSAGE
			if (!src.aicurrmsg)
				if(href_list["message-num"])
					src.aicurrmsg = text2num(href_list["message-num"])
				else
					src.aistate = STATE_MESSAGELIST
		if("ai-delmessage")
			src.aistate = (src.aicurrmsg) ? STATE_DELMESSAGE : STATE_MESSAGELIST
		if("ai-delmessage2")
			if(src.aicurrmsg)
				var/title = src.messagetitle[src.aicurrmsg]
				var/text  = src.messagetext[src.aicurrmsg]
				src.messagetitle.Remove(title)
				src.messagetext.Remove(text)
				if(src.currmsg == src.aicurrmsg)
					src.currmsg = 0
				src.aicurrmsg = 0
			src.aistate = STATE_MESSAGELIST
		if("ai-status")
			src.aistate = STATE_STATUSDISPLAY
		if("ai-announce")
			if(!ai_message_cooldown)
				make_announcement(usr, 1)
		if("ai-securitylevel")
			src.tmp_alertlevel = text2num( href_list["newalertlevel"] )
			if(!tmp_alertlevel) tmp_alertlevel = 0
			var/old_level = security_level
			if(!tmp_alertlevel) tmp_alertlevel = SEC_LEVEL_GREEN
			if(tmp_alertlevel < SEC_LEVEL_GREEN) tmp_alertlevel = SEC_LEVEL_GREEN
			if(tmp_alertlevel > SEC_LEVEL_BLUE) tmp_alertlevel = SEC_LEVEL_BLUE //Cannot engage delta with this
			set_security_level(tmp_alertlevel)
			if(security_level != old_level)
				//Only notify the admins if an actual change happened
				log_game("[key_name(usr)] has changed the security level to [get_security_level()].")
				message_admins("[key_name_admin(usr)] has changed the security level to [get_security_level()].")
				switch(security_level)
					if(SEC_LEVEL_GREEN)
						feedback_inc("alert_comms_green",1)
					if(SEC_LEVEL_BLUE)
						feedback_inc("alert_comms_blue",1)
			tmp_alertlevel = 0
			src.aistate = STATE_DEFAULT
		if("ai-changeseclevel")
			src.aistate = STATE_ALERT_LEVEL

		if("ai-emergencyaccess")
			src.aistate = STATE_TOGGLE_EMERGENCY
		if("ai-enableemergency")
			make_maint_all_access()
			log_game("[key_name(usr)] enabled emergency maintenance access.")
			message_admins("[key_name_admin(usr)] enabled emergency maintenance access.")
			src.aistate = STATE_DEFAULT
		if("ai-disableemergency")
			revoke_maint_all_access()
			log_game("[key_name(usr)] disabled emergency maintenance access.")
			message_admins("[key_name_admin(usr)] disabled emergency maintenance access.")
			src.aistate = STATE_DEFAULT

	src.updateUsrDialog()

/obj/machinery/computer/communications/attackby(var/obj/I as obj, var/mob/user as mob)
	if(istype(I, /obj/item/weapon/card/id))
		attack_hand(user)
	else
		..()
	return

/obj/machinery/computer/communications/emag_act(mob/user as mob)
	if(!emagged)
		src.emagged = 1
		if(authenticated == 1)
			authenticated = 2
		user << "You scramble the communication routing circuits!"

/obj/machinery/computer/communications/attack_hand(var/mob/user as mob)
	if(..())
		return
	if (src.z > 6)
		user << "<span class='userdanger'>Unable to establish a connection</span>: \black You're too far away from the station!"
		return

	user.set_machine(src)
	var/dat = ""
	if (emergency_shuttle.online && emergency_shuttle.location==0)
		var/timeleft = emergency_shuttle.timeleft()
		dat += "<B>Emergency shuttle</B>\n<BR>\nETA: [timeleft / 60 % 60]:[add_zero(num2text(timeleft % 60), 2)]"


	var/datum/browser/popup = new(user, "communications", "Communications Console", 400, 500)
	popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))

	if (istype(user, /mob/living/silicon))
		var/dat2 = src.interact_ai(user) // give the AI a different interact proc to limit its access
		if(dat2)
			dat +=  dat2
			//user << browse(dat, "window=communications;size=400x500")
			//onclose(user, "communications")

			popup.set_content(dat)
			popup.open()
		return

	switch(src.state)
		if(STATE_DEFAULT)
			if (src.authenticated)
				if(emergency_shuttle.recall_count > 1)
					if(emergency_shuttle.last_call_loc)
						dat += "<BR>Most recent shuttle call/recall traced to: <b>[format_text(emergency_shuttle.last_call_loc.name)]</b>"
					else
						dat += "<BR>Unable to trace most recent shuttle call/recall signal."
				dat += "<BR>Logged in as: [auth_id]"
				dat += "<BR>"
				dat += "<BR>\[ <A HREF='?src=\ref[src];operation=logout'>Log Out</A> \]<BR>"
				dat += "<BR><B>General Functions</B>"
				dat += "<BR>\[ <A HREF='?src=\ref[src];operation=messagelist'>Message List</A> \]"
				if(emergency_shuttle.location==0)
					if (emergency_shuttle.online)
						dat += "<BR>\[ <A HREF='?src=\ref[src];operation=cancelshuttle'>Cancel Shuttle Call</A> \]"
					else
						dat += "<BR>\[ <A HREF='?src=\ref[src];operation=callshuttle'>Call Emergency Shuttle</A> \]"

				dat += "<BR>\[ <A HREF='?src=\ref[src];operation=status'>Set Status Display</A> \]"
				if (src.authenticated==2)
					dat += "<BR><BR><B>Captain Functions</B>"
					dat += "<BR>\[ <A HREF='?src=\ref[src];operation=announce'>Make a Captain's Announcement</A> \]"
					dat += "<BR>\[ <A HREF='?src=\ref[src];operation=changeseclevel'>Change Alert Level</A> \]"
					dat += "<BR>\[ <A HREF='?src=\ref[src];operation=emergencyaccess'>Emergency Maintenance Access</A> \]"
					if(src.emagged == 0)
						dat += "<BR>\[ <A HREF='?src=\ref[src];operation=MessageCentcomm'>Send Message to Centcom</A> \]"
					else
						dat += "<BR>\[ <A HREF='?src=\ref[src];operation=MessageSyndicate'>Send Message to \[UNKNOWN\]</A> \]"
						dat += "<BR>\[ <A HREF='?src=\ref[src];operation=RestoreBackup'>Restore Backup Routing Data</A> \]"
			else
				dat += "<BR>\[ <A HREF='?src=\ref[src];operation=login'>Log In</A> \]"
		if(STATE_CALLSHUTTLE)
			dat += get_call_shuttle_form()
		if(STATE_CANCELSHUTTLE)
			dat += get_cancel_shuttle_form()
		if(STATE_MESSAGELIST)
			dat += "Messages:"
			for(var/i = 1; i<=src.messagetitle.len; i++)
				dat += "<BR><A HREF='?src=\ref[src];operation=viewmessage;message-num=[i]'>[src.messagetitle[i]]</A>"
		if(STATE_VIEWMESSAGE)
			if (src.currmsg)
				dat += "<B>[src.messagetitle[src.currmsg]]</B><BR><BR>[src.messagetext[src.currmsg]]"
				if (src.authenticated)
					dat += "<BR><BR>\[ <A HREF='?src=\ref[src];operation=delmessage'>Delete \]"
			else
				src.state = STATE_MESSAGELIST
				src.attack_hand(user)
				return
		if(STATE_DELMESSAGE)
			if (src.currmsg)
				dat += "Are you sure you want to delete this message? \[ <A HREF='?src=\ref[src];operation=delmessage2'>OK</A> | <A HREF='?src=\ref[src];operation=viewmessage'>Cancel</A> \]"
			else
				src.state = STATE_MESSAGELIST
				src.attack_hand(user)
				return
		if(STATE_STATUSDISPLAY)
			dat += "Set Status Displays<BR>"
			dat += "\[ <A HREF='?src=\ref[src];operation=setstat;statdisp=blank'>Clear</A> \]<BR>"
			dat += "\[ <A HREF='?src=\ref[src];operation=setstat;statdisp=shuttle'>Shuttle ETA</A> \]<BR>"
			dat += "\[ <A HREF='?src=\ref[src];operation=setstat;statdisp=message'>Message</A> \]"
			dat += "<ul><li> Line 1: <A HREF='?src=\ref[src];operation=setmsg1'>[ stat_msg1 ? stat_msg1 : "(none)"]</A>"
			dat += "<li> Line 2: <A HREF='?src=\ref[src];operation=setmsg2'>[ stat_msg2 ? stat_msg2 : "(none)"]</A></ul><br>"
			dat += "\[ Alert: <A HREF='?src=\ref[src];operation=setstat;statdisp=alert;alert=default'>None</A> |"
			dat += " <A HREF='?src=\ref[src];operation=setstat;statdisp=alert;alert=redalert'>Red Alert</A> |"
			dat += " <A HREF='?src=\ref[src];operation=setstat;statdisp=alert;alert=lockdown'>Lockdown</A> |"
			dat += " <A HREF='?src=\ref[src];operation=setstat;statdisp=alert;alert=biohazard'>Biohazard</A> \]<BR><HR>"
		if(STATE_ALERT_LEVEL)
			dat += "Current alert level: [get_security_level()]<BR>"
			if(security_level == SEC_LEVEL_DELTA)
				dat += "<font color='red'><b>The self-destruct mechanism is active. Find a way to deactivate the mechanism to lower the alert level or evacuate.</b></font>"
			else
				dat += "<A HREF='?src=\ref[src];operation=securitylevel;newalertlevel=[SEC_LEVEL_BLUE]'>Blue</A><BR>"
				dat += "<A HREF='?src=\ref[src];operation=securitylevel;newalertlevel=[SEC_LEVEL_GREEN]'>Green</A>"
		if(STATE_CONFIRM_LEVEL)
			dat += "Current alert level: [get_security_level()]<BR>"
			dat += "Confirm the change to: [num2seclevel(tmp_alertlevel)]<BR>"
			dat += "<A HREF='?src=\ref[src];operation=swipeidseclevel'>Swipe ID</A> to confirm change.<BR>"
		if(STATE_TOGGLE_EMERGENCY)
			if(emergency_access == 1)
				dat += "<b>Emergency Maintenance Access is currently <font color='red'>ENABLED</font></b>"
				dat += "<BR>Restore maintenance access restrictions? <BR>\[ <A HREF='?src=\ref[src];operation=disableemergency'>OK</A> | <A HREF='?src=\ref[src];operation=viewmessage'>Cancel</A> \]"
			else
				dat += "<b>Emergency Maintenance Access is currently <font color='green'>DISABLED</font></b>"
				dat += "<BR>Lift access restrictions on maintenance and external airlocks? <BR>\[ <A HREF='?src=\ref[src];operation=enableemergency'>OK</A> | <A HREF='?src=\ref[src];operation=viewmessage'>Cancel</A> \]"

	dat += "<BR><BR>\[ [(src.state != STATE_DEFAULT) ? "<A HREF='?src=\ref[src];operation=main'>Main Menu</A> | " : ""]<A HREF='?src=\ref[user];mach_close=communications'>Close</A> \]"
	//user << browse(dat, "window=communications;size=400x500")
	//onclose(user, "communications")
	popup.set_content(dat)
	popup.open()

/obj/machinery/computer/communications/proc/get_javascript_header(var/form_id)
	var/dat = {"<script type="text/javascript">
						function getLength(){
							var reasonField = document.getElementById('reasonfield');
							if(reasonField.value.length >= [CALL_SHUTTLE_REASON_LENGTH]){
								reasonField.style.backgroundColor = "#DDFFDD";
							}
							else {
								reasonField.style.backgroundColor = "#FFDDDD";
							}
						}
						function submit() {
							document.getElementById('[form_id]').submit();
						}
					</script>"}
	return dat

/obj/machinery/computer/communications/proc/get_call_shuttle_form(var/ai_interface = 0)
	var/form_id = "callshuttle"
	var/dat = get_javascript_header(form_id)
	dat += "<form name='callshuttle' id='[form_id]' action='?src=\ref[src]' method='get' style='display: inline'>"
	dat += "<input type='hidden' name='src' value='\ref[src]'>"
	dat += "<input type='hidden' name='operation' value='[ai_interface ? "ai-callshuttle2" : "callshuttle2"]'>"
	dat += "<b>Nature of emergency:</b><BR> <input type='text' id='reasonfield' name='call' style='width:250px; background-color:#FFDDDD; onkeydown='getLength() onkeyup='getLength()' onkeypress='getLength()'>"
	dat += "<BR>Are you sure you want to call the shuttle? \[ <a href='#' onclick='submit()'>Call</a> \]"
	return dat

/obj/machinery/computer/communications/proc/get_cancel_shuttle_form()
	var/form_id = "cancelshuttle"
	var/dat = get_javascript_header(form_id)
	dat += "<form name='cancelshuttle' id='[form_id]' action='?src=\ref[src]' method='get' style='display: inline'>"
	dat += "<input type='hidden' name='src' value='\ref[src]'>"
	dat += "<input type='hidden' name='operation' value='cancelshuttle2'>"

	dat += "<BR>Are you sure you want to cancel the shuttle? \[ <a href='#' onclick='submit()'>Cancel</a> \]"
	return dat

/obj/machinery/computer/communications/proc/interact_ai(var/mob/living/silicon/ai/user as mob)
	var/dat = ""
	switch(src.aistate)
		if(STATE_DEFAULT)
			if(emergency_shuttle.recall_count > 1)
				if(emergency_shuttle.last_call_loc)
					dat += "<BR>Latest emergency signal trace attempt successful.<BR>Last signal origin: <b>[format_text(emergency_shuttle.last_call_loc.name)]</b>.<BR>"
				else
					dat += "<BR>Latest emergency signal trace attempt failed.<BR>"
			if(authenticated)
				dat += "Current login: [auth_id]"
			else
				dat += "Current login: None"
			dat += "<BR><BR><B>General Functions</B>"
			dat += "<BR>\[ <A HREF='?src=\ref[src];operation=ai-messagelist'>Message List</A> \]"
			if(emergency_shuttle.location==0 && !emergency_shuttle.online)
				dat += "<BR>\[ <A HREF='?src=\ref[src];operation=ai-callshuttle'>Call Emergency Shuttle</A> \]"
			dat += "<BR>\[ <A HREF='?src=\ref[src];operation=ai-status'>Set Status Display</A> \]"
			dat += "<BR><BR><B>Special Functions</B>"
			dat += "<BR>\[ <A HREF='?src=\ref[src];operation=ai-announce'>Make an Announcement</A> \]"
			dat += "<BR>\[ <A HREF='?src=\ref[src];operation=ai-changeseclevel'>Change Alert Level</A> \]"
			dat += "<BR>\[ <A HREF='?src=\ref[src];operation=ai-emergencyaccess'>Emergency Maintenance Access</A> \]"
		if(STATE_CALLSHUTTLE)
			dat += get_call_shuttle_form(1)
		if(STATE_MESSAGELIST)
			dat += "Messages:"
			for(var/i = 1; i<=src.messagetitle.len; i++)
				dat += "<BR><A HREF='?src=\ref[src];operation=ai-viewmessage;message-num=[i]'>[src.messagetitle[i]]</A>"
		if(STATE_VIEWMESSAGE)
			if (src.aicurrmsg)
				dat += "<B>[src.messagetitle[src.aicurrmsg]]</B><BR><BR>[src.messagetext[src.aicurrmsg]]"
				dat += "<BR><BR>\[ <A HREF='?src=\ref[src];operation=ai-delmessage'>Delete</A> \]"
			else
				src.aistate = STATE_MESSAGELIST
				src.attack_hand(user)
				return null
		if(STATE_DELMESSAGE)
			if(src.aicurrmsg)
				dat += "Are you sure you want to delete this message? \[ <A HREF='?src=\ref[src];operation=ai-delmessage2'>OK</A> | <A HREF='?src=\ref[src];operation=ai-viewmessage'>Cancel</A> \]"
			else
				src.aistate = STATE_MESSAGELIST
				src.attack_hand(user)
				return

		if(STATE_STATUSDISPLAY)
			dat += "Set Status Displays<BR>"
			dat += "\[ <A HREF='?src=\ref[src];operation=setstat;statdisp=blank'>Clear</A> \]<BR>"
			dat += "\[ <A HREF='?src=\ref[src];operation=setstat;statdisp=shuttle'>Shuttle ETA</A> \]<BR>"
			dat += "\[ <A HREF='?src=\ref[src];operation=setstat;statdisp=message'>Message</A> \]"
			dat += "<ul><li> Line 1: <A HREF='?src=\ref[src];operation=setmsg1'>[ stat_msg1 ? stat_msg1 : "(none)"]</A>"
			dat += "<li> Line 2: <A HREF='?src=\ref[src];operation=setmsg2'>[ stat_msg2 ? stat_msg2 : "(none)"]</A></ul><br>"
			dat += "\[ Alert: <A HREF='?src=\ref[src];operation=setstat;statdisp=alert;alert=default'>None</A> |"
			dat += " <A HREF='?src=\ref[src];operation=setstat;statdisp=alert;alert=redalert'>Red Alert</A> |"
			dat += " <A HREF='?src=\ref[src];operation=setstat;statdisp=alert;alert=lockdown'>Lockdown</A> |"
			dat += " <A HREF='?src=\ref[src];operation=setstat;statdisp=alert;alert=biohazard'>Biohazard</A> \]<BR><HR>"

		if(STATE_ALERT_LEVEL)
			dat += "Current alert level: [get_security_level()]<BR>"
			if(security_level == SEC_LEVEL_DELTA)
				dat += "<font color='red'><b>The self-destruct mechanism is active. Find a way to deactivate the mechanism to lower the alert level or evacuate.</b></font>"
			else
				dat += "<A HREF='?src=\ref[src];operation=ai-securitylevel;newalertlevel=[SEC_LEVEL_BLUE]'>Blue</A><BR>"
				dat += "<A HREF='?src=\ref[src];operation=ai-securitylevel;newalertlevel=[SEC_LEVEL_GREEN]'>Green</A>"

		if(STATE_TOGGLE_EMERGENCY)
			if(emergency_access == 1)
				dat += "<b>Emergency Maintenance Access is currently <font color='red'>ENABLED</font></b>"
				dat += "<BR>Restore maintenance access restrictions? <BR>\[ <A HREF='?src=\ref[src];operation=ai-disableemergency'>OK</A> | <A HREF='?src=\ref[src];operation=ai-viewmessage'>Cancel</A> \]"
			else
				dat += "<b>Emergency Maintenance Access is currently <font color='green'>DISABLED</font></b>"
				dat += "<BR>Lift access restrictions on maintenance and external airlocks? <BR>\[ <A HREF='?src=\ref[src];operation=ai-enableemergency'>OK</A> | <A HREF='?src=\ref[src];operation=ai-viewmessage'>Cancel</A> \]"

	dat += "<BR><BR>\[ [(src.aistate != STATE_DEFAULT) ? "<A HREF='?src=\ref[src];operation=ai-main'>Main Menu</A> | " : ""]<A HREF='?src=\ref[user];mach_close=communications'>Close</A> \]"
	return dat

/obj/machinery/computer/communications/proc/make_announcement(var/mob/living/user, var/is_silicon)
	if(!user.canUseTopic(src))
		return
	if(is_silicon)
		ai_message_cooldown = 1
		spawn(600) //One minute cooldown
			ai_message_cooldown = 0
	else
		message_cooldown = 1
		spawn(600) //One minute cooldown
			message_cooldown = 0

	var/input = stripped_input(user, "Please choose a message to announce to the station crew.", "What?")

	if(!input)
		return

	if(is_silicon)
		minor_announce(input)
	else
		priority_announce(input, null, 'sound/misc/announce.ogg', "Captain")

	log_say("[key_name(user)] has made a priority announcement: [input]")
	message_admins("[key_name_admin(user)] has made a priority announcement.")

/proc/call_shuttle_proc(var/mob/user, var/call_reason)
	if ((!( ticker ) || emergency_shuttle.location))
		return
	if(world.time - round_start_time < config.shuttle_refuel_delay)
		user << "The emergency shuttle is refueling. Please wait another [abs(round(((world.time - round_start_time) - config.shuttle_refuel_delay)/600))] minutes before trying again."
		return

	if(emergency_shuttle.direction == -1)
		user << "The emergency shuttle may not be called while returning to Centcom."
		return

	if(emergency_shuttle.online)
		user << "The emergency shuttle is already on its way."
		return

	call_reason = strip_html_properly(trim(call_reason))

	if(length(call_reason) < CALL_SHUTTLE_REASON_LENGTH)
		user << "You must provide a reason."
		return

	var/area/signal_origin = get_area(user)
	var/emergency_reason = "\nNature of emergency:\n\n[call_reason]"
	if (seclevel2num(get_security_level()) == SEC_LEVEL_RED) // There is a serious threat we gotta move no time to give them five minutes.
		emergency_shuttle.incall(0.6, signal_origin, emergency_reason, 1)
	else
		emergency_shuttle.incall(1, signal_origin, emergency_reason, 0)

	log_game("[key_name(user)] has called the shuttle.")
	message_admins("[key_name_admin(user)] has called the shuttle.")

	return


/proc/cancel_call_proc(var/mob/user)
	if ((!( ticker ) || emergency_shuttle.location || emergency_shuttle.direction == 0))
		return
	if(ticker.mode.name == "meteor")
		return

	if ((seclevel2num(get_security_level()) == SEC_LEVEL_RED))
		if (emergency_shuttle.timeleft() < SHUTTLEARRIVETIME / 4)
			return
	else if (emergency_shuttle.timeleft() < SHUTTLEARRIVETIME / 2)
		return


	if(emergency_shuttle.direction != -1 && emergency_shuttle.online) //check that shuttle isn't already heading to centcom
		var/area/signal_origin = get_area(user)
		emergency_shuttle.recall(signal_origin)
		log_game("[key_name(user)] has recalled the shuttle.")
		message_admins("[key_name_admin(user)] has recalled the shuttle.")
		return 1
	return

/obj/machinery/computer/communications/proc/post_status(var/command, var/data1, var/data2)

	var/datum/radio_frequency/frequency = radio_controller.return_frequency(1435)

	if(!frequency) return

	var/datum/signal/status_signal = new
	status_signal.source = src
	status_signal.transmission_method = 1
	status_signal.data["command"] = command

	switch(command)
		if("message")
			status_signal.data["msg1"] = data1
			status_signal.data["msg2"] = data2
		if("alert")
			status_signal.data["picture_state"] = data1

	frequency.post_signal(src, status_signal)


/obj/machinery/computer/communications/Destroy()
	shuttle_caller_list -= src
	emergency_shuttle.autoshuttlecall()
	..()

