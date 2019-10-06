pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
function _init()
	player = {x=0,y=0,ox = 0, oy = 0, i = 0,f=false,sprite = 1,animcooldown = 0,speed = 1,cooldown = 0, reset = false}
	saws = {}
	level = 0
	levelsetup(0)
	state = "ld"
	titlei = 0
	starttime = 0
end
function ease(framedur,frame,start,target)
	return(start + (((target - start) / framedur) * frame))
end
function levelsetup(level)
	-- here all the levels are stored
	if level == 0 then
		music(14)
	elseif level == 1 then
		music(0)
		spawnsaw(60,60,60,60,30,8)`
	end
end
function modsaw(n,x1,y1,x2,y2,sp,delete)
	s=saws[n]
	if delete then
		s.x1 = s.x
		s.y1 = 0 - s.size
		s.x2 = s.x
		s.y2 = s.y1
		s.pos = 0
	else
		s.x1 = x1
		s.y1 = y1
		s.x2 = x2
		s.y2 = y2
		s.sp = sp
	end
end
function spawnsaw(x1,y1,x2,y2,sp,size)
	s={}
	s.pos = 0
	s.i = 0
	s.x = x1
	s.y = 0 - size
	s.del = false
	s.ox = x1
	s.oy = s.y
	s.x1 = x1
	s.y1 = y1
	s.x2 = x2
	s.y2 = y2
	s.sp = sp
	s.size = size
	s.b = 0
	s.d = 0
	s.f = false
	
	add(saws,s)
end
function updatesaw(s)
	s.i += 1
	--pain went here
	if s.pos == 0 then
	
		if s.i > 15 then
			s.i = 0
			s.ox = s.x1
			s.oy = s.y1
			s.pos = 2
		else
			s.x = ease(15,s.i,s.ox,s.x1)
			s.y = ease(15,s.i,s.oy,s.y1)
		end
	elseif s.pos == 2 then
		if s.i > s.sp then
			s.i = 0
			s.ox = s.x2
			s.oy = s.y2
			s.pos = 1
		else
			s.x = ease(s.sp,s.i,s.ox,s.x2)
			s.y = ease(s.sp,s.i,s.oy,s.y2)
		end
	elseif s.pos == 1 then
		if s.i > s.sp then
			s.i = 0
			s.ox = s.x1
			s.oy = s.y1
			s.pos = 2
		else
			s.x = ease(s.sp,s.i,s.ox,s.x1)
			s.y = ease(s.sp,s.i,s.oy,s.y1)
		end
	end
end
function drawsaw(s)
	s.d -= 1
	if s.d < 0 then
		s.d = 2 
		if s.f then
			s.f = false
		else
			s.f = true
		end
	end
	spr(3 + s.b,s.x,s.y,1,1,s.f)
end
function collide(s)
	if player.reset == false then
		if player.x >= (s.x - 6) and player.x <= (s.x + 6) then
			if player.y >= (s.y - 5) and player.y <= (s.y + 3) then
				if player.speed !=1 then
					sfx(2)
				else
					s.b = 1
					player.x = 0
					player.y = 0
					sfx(0)
				end
			end
		end
	end
end
function _update()
	if state == "game" and player.reset == false then
		if player.sprite == 6 then
			player.sprite = 1
		end
		-- update player
		lastx = player.x
		lasty = player.y
		player.cooldown -= 1
		player.animcooldown -= 1
		if player.speed > 1 then
		player.speed -= 1
		end
		if btn(5) and player.cooldown <=0 then
			player.speed = 6
			player.cooldown = 10
			
		end
		if btn(0) then
			player.x -= player.speed
			player.f = true
		elseif btn(1) then
			player.x += player.speed
			player.f = false
		end
		if btn(2) then
			player.y -= player.speed
		elseif btn(3) then
			player.y += player.speed
		end
		if player.x != lastx or player.y != lasty then
			if player.animcooldown < 0 or player.speed != 1 then
				if player.sprite == 1 then
					player.sprite = 2
				else
					player.sprite = 1
				end
				player.animcooldown = 5
			end
		end
		if player.y < -3 then
			player.y = -3
		elseif player.y > 120 then
			player.y = 120
		end
		if player.x < 0 then
			player.x = 0
		elseif player.x > 120then
			player.x = 120
		end
		
		if player.x > 113 and player.y > 115 and player.reset == false then
			player.reset = true
			level += 1
			levelsetup(level)
			player.i = 0
			player.ox = player.x
			player.oy = player.y
		end
		
	end
	player.i += 1
	if player.reset then
		player.sprite = 6
		if player.i > 15 then
			player.i = 0
			player.ox = 0
			player.oy = -3
			player.reset = false
		else
			player.x = ease(15,player.i,player.ox,0)
			player.y = ease(15,player.i,player.oy,-3)
		end
	end
		--end update player
	foreach(saws,updatesaw)
	--collision (this gonna suck)
	foreach(saws,collide)

	--misc
	if state == "ld" and time() > 3 then
		state = "ldtitle"
	elseif state == "ldtitle" and time() > 5 then
		state = "title"
	end
	if state == "title" and btnp(5) then
		state = "game"
		player.cooldown = 20
		starttime = time()
	end
end
function _draw()
	cls(0)

	spr(player.sprite,player.x,player.y,1,1,player.f)
	spr(5,120,120)
	foreach(saws,drawsaw)
	if state == "title" then
		titlei += 0.01
		sspr(0,8,113,16,8,52-sin(titlei)*2.25,113,20+sin(titlei)*4.5)
		print("a game by dps2004",32,80,8)
		print("press ❎ to start",32,88,8)
	end
	if state == "ld" then
		spr(48,0,52,16,2)
	end
	if level == 0 and state == "game" and player.y < 60 then
		print("press ⬅️⬆️⬇️➡️ to move",0,96,8)
		print("press ❎ to dash",0,104,8)
		print("you are invincible while dashing",0,112,8)
		print("touch the flag to win      -->",0,120,8)
	end
end
__gfx__
00000000000000000000000007070700080808000007770000888800000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000007777777088888880070070008000080000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000077777770887777800700070087000707000000000000000000000000000000000000000000000000000000000000000000000000
00077000070007070700070707700777087007887000070087000777000000000000000000000000000000000000000000000000000000000000000000000000
00077000070007770700077777700770887007807777770080777777000000000000000000000000000000000000000000000000000000000000000000000000
00700700007777770077777707777777087777880000070080777708000000000000000000000000000000000000000000000000000000000000000000000000
00000000007777000077770077777770888888800000070008700780000000000000000000000000000000000000000000000000000000000000000000000000
00000000007007000700007000707070008080800707070700888800000000000000000000000000000000000000000000000000000000000000000000000000
08888000000000000000000000000000000000000000000888000000000000000000000000000000000000000000000000000000000000000000000000000000
87777800000880000000000088800000000000000000008777800000000000000000000000000000000000000000000000000000000000000000000000000000
87777780008778000000000877788800000000000000087777780000000000088000000000000000000000000000000000000000000000000000000000000000
87787788008778000000000877777780888888888800877787780000008800877800008880000000000000777000000007700077777777700000000000000000
87787777808778000000000088777788777777777780877808800000087780877780087778000000000077777000000077700077777777770000000000000000
87788777808778000000880008777808777777777780877800000000877780087780087778088000000077700000000777700000000770777000000000000000
87788877808778000008778008778000888888877800877788000000877778087778877778877800000777000000000777700000007770077000000000000000
87777777808777800008778087778000000008777800087777800000877778008778877778777800000770000000000777770000007700000000000000000000
87777778800877800008778877780000000087778000008777780008777777808778877778778000000777000000007770770000007700000000000000000000
87788777788877800008778777800000000087780000000887778008778877808778777777778000000077000000007700770000007700000000000000000000
87788877777877780087778778000000000877780000000008778008778877808778778777780000000077000000007777777000007700000000000000000000
87788888777887780087788778000000000877800000000088778087777777788777778877780000000077700000077777777000077700000000000000000000
87788887778087778877788777888888800877888888008877778087777777780877780877800000000007777000077000077000077000000000000000000000
87777777780008777777800877777777780877777777887777780877788887780877780088000000000000777700077000077000077000000000000000000000
08777777800008777778000087777777780877777777887778800877800087780877800000000000000000007700077000077000077000000000000000000000
00888888000000888880000008888888800088888888008880000088000008800088000000000000000000000000000000000000000000000000000000000000
88888000000000000000000000000000008888800000000000000000000000000000000000000099999999990000000000000000000000000000000000000000
88888000000000000000000000000000008888800000000000000000000000000000000000000099999999999000000000000000000000000000000000000000
88888000000088888800888880000088888888808888880088888800000888800008888000000099999999999900000099990000000000000000000999900000
88888000000088888800888880008888888888808888880088888800088888888888888880000099999999999900009999999900000009999900099999999000
88888000000088888800888880088888888888808888880088888800888888888888888888000099999999999990099999999990000099999900999999999900
88888000000088888800888880088888888888808888880088888800888888888888888888800099999999999990999999999999000999999909999999999990
88888000000088888800888880888888888888808888880088888800888888888888888888800099999009999990999999999999009999999909999999999990
88888000000088888800888880888888088888808888880088888808888888888888888888800099999009999990999999999999099999999909999999999999
88888000000088888800888880888880008888808888880088888808888880888888088888800099999009999990999990099999099999990099999900999999
88888888888088888808888880888888088888808888880088888808888880888888088888800099999999999990999990099999099999990099999900999999
88888888888088888888888880888888888888800888888888888808888880888888088888800099999999999990999999999999099999990009999999900000
88888888888008888888888880888888888888000888888888888008888880888888088888800099999999999900999999999999099999990009999999990000
88888888888008888888888800088888888888000888888888888008888880888888088888800099999999999900099999999999099999990000999999999000
08888888888000888888888800008888888880000088888888880008888880888888088888800099999999999000009999999999099999990000099999999900
00888888888000088888888000000888888800000008888888800008888880888888088888800099999999900000000999999999099999990000009999999990
00000000000000000888000000000008880000000000088880000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000707000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07000777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00777777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000088880000000000000000000000000000000000000000008880000000000000000000000000000000000000000000000000000000000000000000000
00000000877778000008800000000000888000000000000000000087778000000000000000000000000000000000000000000000000000000000000000000000
00000000877777800087780000000008777888000000000000000877777800000000000880000000000000000000000000000000000000000000000000000000
00000000877877880087780000000008777777808888888888008777877800000088008778000088800000000000007770000000077000777777777000000000
00000000877877778087780000000000887777887777777777808778088000000877808777800877780000000000777770000000777000777777777700000000
00000000877887778087780000008800087778087777777777808778000000008777800877800877780880000000777000000007777000000007707770000000
00000000877888778087780000087780087780008888888778008777880000008777780877788777788778000007770000000007777000000077700770000000
00000000877777778087778000087780877780000000087778000877778000008777780087788777787778000007700000000007777700000077000000000000
00000000877887777888778000087787778000000000877800000008877780087788778087787777777780000000770000000077007700000077000000000000
00000000877888777778777800877787780000000008777800000000087780087788778087787787777800000000770000000077777770000077000000000000
00000000877888887778877800877887780000000008778000000000887780877777777887777788777800000000777000000777777770000777000000000000
00000000877888877780877788777887778888888008778888880088777780877777777808777808778000000000077770000770000770000770000000000000
00000000877777777800087777778008777777777808777777778877777808777888877808777800880000000000007777000770000770000770000000000000
00000000087777778000087777780000877777777808777777778877788008778000877808778000000000000000000077000770000770000770000000000000
00000000008888880000008888800000088888888000888888880088800000880000088000880000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000888000000880888088808880000088808080000088008880088088808880888080800000000000000000000000000000
00000000000000000000000000000000808000008000808088808000000080808080000080808080800000808080808080800000000000000000000000000000
00000000000000000000000000000000888000008000888080808800000088008880000080808880888088808080808088800000000000000000000000000000
00000000000000000000000000000000808000008080808080808000000080800080000080808000008080008080808000800000000000000000000000000000
00000000000000000000000000000000808000008880808080808880000088808880000088808000880088808880888000800000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000888088808880088008800000088888000000888008800000088088808880888088800000000000000000000000000000
00000000000000000000000000000000808080808000800080000000880808800000080080800000800008008080808008000000000000000000000000000000
00000000000000000000000000000000888088008800888088800000888088800000080080800000888008008880880008000000000000000000000000000000
00000000000000000000000000000000800080808000008000800000880808800000080080800000008008008080808008000000000000000000000000000000
00000000000000000000000000000000800080808880880088000000088888000000080088000000880008008080808008000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000077700
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000700700
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007000700
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070000700
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000077777700
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000700
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000700
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007070707

__sfx__
000100002445021450184501e4501c4501a4501745015450124500f4500c4500c45012450104500a4500545001450004500040000400004000040000400004000040000400004000040000400004000040000400
000500000162001620016200162001620016200162001620016200162001620016200162001620016200162001620016200162001620016200162001620016200162001620016200162001620016200162001620
000100002e15031150331503315032150301502a15000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010a00000c575005000e575005000f575005000e575005000c575005000e575005000f575005000e575005000c5700e5700f5700e5700c5700e5700f5700e5700c570005000e570005000f570005000e57000500
010a00000f575005001157500500135750050011575005000f575005001157500500135750050011575005000f5701157013570115700f5701157013570115700f57000500115700050013570005001157000500
010a00001357500500145750050016575005001457500500135750050014575005001657500500145750050013570145701657014570135701457016570145701357000500145700050016570005001457000500
010a000016570135001457014500135701350011570145000f570165000e570145000c570135000e570165000f570135001157016500135701350011570145000f570165000e570145000c570000000b57000000
010a00000c635000050c6350000524635000050c635000050c635000050c6350000524635000050c635000050c635000050c6350000524635000050c6350000524635000050c6350000024635000000c63500000
010a00000022000220002200022000220002200022000220002200022000220002200022000220002200022000220002200022000220002200022000220002200022000220002200022000220002200022000220
010a00000722007220072200722007220072200722007220072200722007220072200722007220072200722007220072200722007220072200722007220072200722007220072200722007220072200722007220
010a00000322003220032200322003220032200322003220032200322003220032200322003220032200322003220032200322003220032200322003220032200322003220032200322003220032200322003220
010a00000222002220022200222002220022200222002220022200222002220022200222002220022200222007220072200722007220072200722007220072200722007220072200722007220072200722007220
010a0000246350c0050c63524005246350c0050c6350c005246350c005246350c0052463524005246350c005246350c0050c63524005246350c0050c635240052463524005246352400024635240002463500000
010a00000c2300020000220002000c2300e200002200e2000c230002000e230002000f2300e2000e2300e2000c2300020000220002000c2300e200002200e2000c230002000e230002000f230002000e23000000
010a00000f2300020003220002000f2300e200032200e2000f230002001123000200132300e200112300e2000f2300020003220002000f2300e200032200e2000f23000200112300020013230002001123000000
010a00001323000200072200c2001323002200072200e20013230002001423000200162300e200142300e2001323000200072200c2001323002200072200e2001323000200142300020016230002001423000000
__music__
00 43074344
00 44074344
01 03074344
00 04074344
00 05074344
00 06074344
00 03070844
00 04070944
00 05070a44
00 06070b44
00 030c0d44
00 040c0e44
00 050c0f44
02 060c4644
03 01424344

