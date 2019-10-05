pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
function _init()
	player = {x=0,y=0,f=false,sprite = 1,animcooldown = 0,speed = 1,cooldown = 0}
	saws = {}
	spawnsaw(60,60,50,50,20,20,30,8)
end
function ease(framedur,frame,start,target)
	return(start + (((target - start) / framedur) * frame))
end

function spawnsaw(x,y,x1,y1,x2,y2,sp,size)
	s={}
	s.pos = 0
	s.i = 0
	s.x = x
	s.y = y
	s.ox = x
	s.oy = y
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
function _update()
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
	--end update player
	foreach(saws,updatesaw)
	--collision (this gonna suck)
	foreach(saws,collide)
end
function _draw()
	cls(0)
	spr(player.sprite,player.x,player.y,1,1,player.f)
	spr(5,120,120)
	foreach(saws,drawsaw)

end
__gfx__
00000000000000000000000007070700080808000007770000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000007777777088888880070070000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000077777770887777800700070000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000070007070700070707700777087007887000070000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000070007770700077777700770887007807777770000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700007777770077777707777777087777880000070000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000007777000077770077777770888888800000070000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000007007000700007000707070008080800707070700000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
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
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000007000707000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000007000777000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000777777000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000777700000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000007000070000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000707070000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000077777770000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000007777777000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000077700770000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000007700777000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000077777770000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000007777777000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000007070700000000000000000000000000000000000000000000000000000000000000
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
000100000162001620016200162001620016200162001620016200162001620016200162001620016200162001620016200162001620016200162001620016200162001620016200162001620016200162001620
000100002e15031150331503315032150301502a15000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
