local modname = core.get_current_modname() or "??"
local modstorage = core.get_mod_storage()
local time_zero = 1
local frame_delay = 0

local info_msg = "Type the number of seconds you want to record! You will have 2 seconds before records starts! Recording can generate many data (up to ten-twelve images per second) so be careful and lower the resolution.\n --- azekill_DIABLO\nPS: Ask me if you know how to do a scrollable multiline label! Thank you!"

local rec_mt = function(timer, fps)
	if tonumber(timer) and tonumber(fps) and fps ~= "" and fps > "0" and timer > "0" then
		local framerate = 1/fps
		minetest.after(2, function()
			time_zero=0-timer
			minetest.register_globalstep(function(dtime)
				if time_zero >= 0 then
					return nil
				else
					time_zero=time_zero+dtime
					frame_delay=frame_delay+dtime
					if frame_delay > framerate then
						minetest.take_screenshot()
						frame_delay=0
					end
				end
			end)
		end)
	else minetest.display_chat_message("Framerate or the Timing in seconds is invalid!")
	end
end

local rec_form = function()
	minetest.show_formspec("record", 
		"size[5,4]" ..
		"bgcolor[#080808BB;false]" ..
		"image[-0.35,-0.4;1.2,1.2;camera_btn.png]" ..
		"button_exit[4.2,-0.15;1,0.7;close;×]" ..
		"label[0.6,0;Minetest Recording GUI:]" ..
		"vertlabel[-0.2,0.4;PARAMETERS]" ..
		"textarea[0.4,1;5.065,1.5;rec_info;What to do?;".. info_msg .."]" ..
		"field[0.4,3.1;2.4,1;rec_timer;Timing in seconds:;5]" ..
		"field[3.08,3.1;2.4,1;rec_fps;Framerate:;10]" ..
		"button_exit[0.1,3.5;2.43,1;rec_btn;Start]" ..
		"button[2.8,3.5;2.41,1;stop_btn;Stop]"
	)
end

--button pressing
core.register_on_formspec_input(function(formname, fields)
	if formname == "record" then  
		if fields.rec_btn then
			rec_mt(fields.rec_timer, fields.rec_fps)
		end
		if fields.stop_btn then
			time_zero = 1
		end
	end
end)
	
minetest.register_chatcommand("rec", {
	func = function()
		rec_form()
	end,
})
