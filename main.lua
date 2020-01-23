
function love.load()
  
  -- port stuff
  if pcall(potiontest) then
    lovepotion = true
  else
    lovepotion = false
  end
  love.graphics.setDefaultFilter("nearest", "nearest")
  
  inittime = love.timer.getTime()
  if not lovepotion then
    push = require "push"
    windowWidth, windowHeight = 512, 512
    gameWidth, gameHeight = 128,128
    push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {
      fullscreen = false,
      resizable = true,
      pixelperfect = true
    })
    push:setBorderColor{255,255,255}
  end
  pfont = love.graphics.newFont("PICO-8.ttf",5)
  love.graphics.setFont(pfont)
  staticdelt = true
  sprtbl = {}
  for i=1,15 do
    table.insert(sprtbl,love.graphics.newImage("spr/"..tostring(i)..".png"))
  end
  -- game stuff
	player = {x=0,y=0,ox = 0, oy = 0, i = 0,f=false,sprite = 1,animcooldown = 0,speed = 1,cooldown = 0, reset = false,binvuln=0}
	boss = {x=60,y=60,f=false,hp=10,sprite=14,walki=0,phase=0,ai = 10}
	saws = {}

	level = 0
	levelsetup(0)
	state = "ld"
	titlei = 0
	projectile = {x=120,y=120,i=0,ox=120,oy=120,active = false,visible = true}
	starttime = 0
	bossfinishtime = 0
	startboss = false
	deaths = 0
	bsaws = {}
end
function potiontest()
  love.graphics.setScreen('top')
end
--p8 replication functions
function del(t,v)
  t.delete_at(li.index(v))
end

function picopr(text,x,y,color)
  love.graphics.print(text,x,y)
end
function time()
  return love.timer.getTime() - inittime
end
function spr(s,x,y,w,h,f)
  --picopr(s,x,y)
  if f then
    love.graphics.draw(sprtbl[s],x+8,y,0,-1)
  else
    love.graphics.draw(sprtbl[s],x,y)
  end
end
function sspr(sx, sy, sw, sh, dx, dy, dw, dh, fx)
  --TODO oh no
  picopr("x",dx,dy)
end
function music()
  --TODO i have depression
end
function foreach()
  --TODO this one is gonna suck
end
function cls()
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill",0,0,128,128)
	love.graphics.setColor(1, 1, 1)
end
function btnp()
  --TODO oh no time to visit discord
end
function btn()
  --TODO same here
end
function sin(i)
  return 0 - math.sin(i*math.pi)
end
--debug
function love.keypressed(key)
  if key == "d" and not lovepotion then
    print(state)
    print(level)
  end
end
-- game functions
function ease(framedur,frame,start,target)
	return(start + (((target - start) / framedur) * frame))
end
function spawnbsaw(x,y,xs,ys,life)
	bs={}
	bs.x = x
	bs.y = y
	bs.xs = xs
	bs.ys = ys
	bs.f = false
	bs.d = 2
	bs.life = life
	table.insert(bsaws,bs)
end


function levelsetup(level)
	-- here all the levels are stored
	if level == 0 then
		music(14)
	elseif level == 1 then
		music(0)
		spawnsaw(60,60,60,60,30,8) --saw 1
	elseif level == 2 then
		modsaw(1,60,0,60,120,30)
	elseif level == 3 then
		spawnsaw(0,60,120,60,30,8) --saw 2
		modsaw(1,60,0,60,120,30)
	elseif level == 4 then
		modsaw(1,16,0,120,104,10)
		modsaw(2,104,120,0,16,10)
		spawnsaw(120,0,0,120,15,8)	--saw 3
	elseif level == 5 then
		delsaw(1)
		delsaw(2)
		delsaw(3)
		spawnsaw(48,0,48,96,20,32) --saw 4
	elseif level == 6 then
		modsaw(4,48,48,48,48,20)
		spawnsaw(60,0,60,60,8,8) --saw 5
		spawnsaw(0,60,60,60,8,8) --saw 6
		spawnsaw(60,120,60,60,8,8) --saw 7
		spawnsaw(120,60,60,60,8,8) --saw 8
	elseif level == 7 then
		delsaw(4)
		modsaw(5,8,0,8,120,30)
		modsaw(6,24,0,24,120,25)
		modsaw(7,40,0,40,120,20)
		modsaw(8,56,0,56,120,15)
		spawnsaw(72,0,72,120,10,8) -- saw 9
		spawnsaw(88,0,88,120,15,8) --saw 10
		spawnsaw(104,0,104,120,20,8) --saw 11
		spawnsaw(120,0,120,120,25,8) --saw 12
	elseif level == 8 then
		delsaw(5)
		delsaw(6)
		delsaw(7)
		delsaw(8)
		delsaw(9)
		delsaw(10)
		delsaw(11)
		spawnsaw(8,0,8,52,15,16) -- saw 13
		spawnsaw(8,112,8,68,15,16) -- saw 14
		spawnsaw(24,0,24,52,15,16) -- saw 15
		spawnsaw(24,112,24,68,15,16) -- saw 16
		spawnsaw(40,52,40,0,15,16) -- saw 17
		spawnsaw(40,68,40,112,15,16) -- saw 18	
		spawnsaw(56,52,56,0,15,16) -- saw 19
		spawnsaw(56,68,56,112,15,16) -- saw 20			
		spawnsaw(72,0,72,52,15,16) -- saw 21
		spawnsaw(72,112,72,68,15,16) -- saw 22
		spawnsaw(88,0,88,52,15,16) -- saw 23
		spawnsaw(88,112,88,68,15,16) -- saw 24
		spawnsaw(104,52,104,0,15,16) -- saw 25
		spawnsaw(104,68,104,112,15,16) -- saw 26	
		modsaw(12,120,0,120,120,20)
	elseif level == 9 then
		delsaw(12)
		delsaw(13)
		delsaw(14)
		delsaw(15)
		delsaw(16)
		delsaw(17)
		delsaw(18)
		delsaw(19)
		delsaw(20)
		delsaw(21)
		delsaw(22)
		delsaw(23)
		delsaw(24)
		delsaw(25)
		delsaw(26)
		music(14)
	end
end
function delsaw(n)
	s=saws[n]
	s.x1 = s.x
	s.y1 = 0 - s.size
	s.x2 = s.x
	s.y2 = s.y1
end
function modsaw(n,x1,y1,x2,y2,sp)
	s=saws[n]

	s.ox = s.x
	s.oy = s.y
	s.pos = 3
	s.x1 = x1
	s.y1 = y1
	s.x2 = x2
	s.y2 = y2
	s.sp = sp
	s.i = 0

	
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
	
	table.insert(saws,s)
end
function updatesaw(s)
	s.i = s.i + delt
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
	elseif s.pos == 3 then
		if s.i > 15 then
			s.i = 0
			s.ox = s.x1
			s.oy = s.y1
			s.pos = 2
		else
			s.x = ease(15,s.i,s.ox,s.x1)
			s.y = ease(15,s.i,s.oy,s.y1)
		end
	end
end
function drawsaw(s)
	s.d = s.d - delt
	if s.d < 0 then
		s.d = 2 
		if s.f then
			s.f = false
		else
			s.f = true
		end
	end
	sspr(24 + s.b,0,8,8,s.x,s.y,s.size,s.size,s.f)
end
function drawbsaw(bs)
	bs.d = bs.d - delt
	if bs.d < 0 then
		bs.d = 2
			if bs.f then
				bs.f = false
			else
				bs.f = true
			end
		end
	spr(8,bs.x,bs.y,1,1,bs.f)
end
function updatebsaw(bs)
	bs.x = bs.x + bs.xs * delt
	bs.y = bs.y + bs.ys * delt
	bs.life = bs.life - delt
	if bs.life < 0 then
		del(bsaws,bs)
	end
end
function bcollide(bs)
	if player.reset == false and player.binvuln < 0 then
		if player.x >= (bs.x - 6) and player.x <= (bs.x + 8 - 2) then
			if player.y >= (bs.y - 5) and player.y <= (bs.y + 8  - 5) then
				if player.speed <=1 then
					sfx(2)
				else
					deaths =  deaths + 1
					player.reset = true
					player.i = 0
					player.binvuln = 30
					player.ox = player.x
					player.oy = player.y
					sfx(0)
				end
			end
		end
	end
end
function bosscollide()
	if player.reset == false and player.binvuln < 0 and not boss.phase == 5 then
		if player.x >= (boss.x - 5) and player.x <= (boss.x + 7 - 2) then
			if player.y >= (boss.y - 3) and player.y <= (boss.y + 5) then
				if player.speed <=1 then
					sfx(2)
				else
					deaths = deaths + 1
					player.reset = true
					player.i = 0
					player.binvuln = 30
					player.ox = player.x
					player.oy = player.y
					sfx(0)
				end
			end
		end
	end
end
function collide(s)
	if player.reset == false then
		if player.x >= (s.x - 6) and player.x <= (s.x + s.size - 2) then
			if player.y >= (s.y - 5) and player.y <= (s.y + s.size  - 5) then
				if player.speed <=1 then
					sfx(2)
				else
					s.b = 8
					deaths = deaths + 1
					player.reset = true
					player.i = 0
					player.ox = player.x
					player.oy = player.y
					sfx(0)
				end
			end
		end
	end
end
function love.update(dt)
  if staticdelt then
    delt = 0.5
  else
    delt = dt * 30
  end
	if state == "game" and player.reset == false then
		if player.sprite == 6 then
			player.sprite = 1
		end
		-- update player
		lastx = player.x
		lasty = player.y
		player.cooldown = player.cooldown - delt
		player.animcooldown = player.animcooldown - delt
		if player.speed > 1 then
      player.speed = player.speed - delt
		end
    if player.speed < 1 then
      player.speed = 1
    end
		if btn(5) and player.cooldown <=0 then
			player.speed = 6
			player.cooldown = 10
			
		end
		if btn(0) then
			player.x = player.x - player.speed * delt
			player.f = true
		elseif btn(1) then
			player.x = player.x + player.speed * delt
			player.f = false
		end
		if btn(2) then
			player.y = player.y - player.speed * delt
		elseif btn(3) then
			player.y = player.y + player.speed *delt
		end
		if not player.x == lastx or not player.y == lasty then
			if player.animcooldown < 0 or player.speed >= 1 then
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
		elseif player.x > 120 then
			player.x = 120
		end
		--debug
	--	if btnp(4) then
	--		player.x = 120
	--		player.y = 120
	--	end
		if player.x > 113 and player.y > 115 and player.reset == false and not level == 9 then
			player.reset = true
			level = level + 1
			levelsetup(level)
			player.i = 0
			player.ox = player.x
			player.oy = player.y
		end
		
	end
	player.i = player.i + dt
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
	--start boss
	if level == 9 and player.reset == false then
		saws = {}
		player.binvuln = player.binvuln - delt
		startboss = true
	end	
	if startboss and boss.phase == 0 then
		boss.sprite = 14
		if player.x>30 and player.y>30 then
			boss.phase = 1
			sfx(16)
			music(15)
			boss.i = 4
		end
	end
	if startboss and boss.phase == 1 then
		boss.sprite = 7
		boss.i = boss.i + delt
		boss.ai = boss.ai - delt
		if boss.x > player.x then
			boss.f = true
		else
			boss.f = false
		end
		if boss.i > 3 then
			boss.i = 0
			if boss.x > player.x then
				boss.x = boss.x - 1
			end
			if boss.x < player.x then
				boss.x = boss.x + 1
			end
			if boss.y > player.y then
				boss.y = boss.y - 1
			end
			if boss.y < player.y then
				boss.y = boss.y + 1
			end
		end
		if boss.ai < 0 then
			boss.ai = 10
			spawnbsaw(player.x,-8,0,4,140)
		end
	elseif boss.phase == 2 then
		boss.sprite = 7
		boss.i = boss.i + delt
		boss.ai = boss.ai - delt
		if boss.x > player.x then
			boss.f = true
		else
			boss.f = false
		end
		if boss.i > 3 then
			boss.i = 0
			if boss.x > player.x then
				boss.x = boss.x - 1
			end
			if boss.x < player.x then
				boss.x = boss.x + 1
			end
			if boss.y > player.y then
				boss.y = boss.y - 1
			end
			if boss.y < player.y then
				boss.y = boss.y + 1
			end
		end
		if boss.ai < 0 then
			boss.ai = 15
			spawnbsaw(player.x-128,player.y-128,3,3,240)
			spawnbsaw(player.x+128,player.y-128,-3,3,240)
		end
	elseif boss.phase == 3 then
		boss.sprite = 7
		boss.i = boss.i + delt
		boss.ai = boss.ai - delt
		if boss.x > player.x then
			boss.f = true
		else
			boss.f = false
		end
		if boss.i > 2 then
			boss.i = 0
			if boss.x > player.x then
				boss.x = boss.x - 1
			end
			if boss.x < player.x then
				boss.x = boss.x + 1
			end
			if boss.y > player.y then
				boss.y = boss.y - 1
			end
			if boss.y < player.y then
				boss.y = boss.y + 1
			end
		end
		if boss.ai < 0 then
			boss.ai = 15
			spawnbsaw(player.x-128,player.y-128,3,3,240)
			spawnbsaw(player.x+128,player.y-128,-3,3,240)
			spawnbsaw(player.x,player.y+128,0,-4,140)
		end
	elseif boss.phase == 4 then
		boss.sprite = 7
		boss.i = boss.i + delt
		boss.ai = boss.ai - delt
		if boss.x > player.x then
			boss.f = true
		else
			boss.f = false
		end
		if boss.i > 2 then
			boss.i = 0
			if boss.x > player.x then
				boss.x = boss.x - 1
			end
			if boss.x < player.x then
				boss.x = boss.x + 1
			end
			if boss.y > player.y then
				boss.y = boss.y - 1
			end
			if boss.y < player.y then
				boss.y = boss.y + 1
			end
		end
		if boss.ai < 0 then
			boss.ai = 15
			spawnbsaw(player.x-128,player.y-128,3,3,240)
			spawnbsaw(player.x+128,player.y-128,-3,3,240)
			spawnbsaw(player.x-128,player.y+128,3,-3,240)
			spawnbsaw(player.x+128,player.y+128,-3,-3,240)
		end
	end
	bosscollide()
	foreach(bsaws,updatebsaw)
	foreach(bsaws,bcollide)
	if player.x > 113 and player.y > 115 and player.reset == false and level == 9 and not boss.phase == 5 then
		if boss.hp > 1 then 
			player.reset = true
			player.i = 0
			player.ox = player.x
			player.oy = player.y
			player.binvuln = 15
		else
			player.binvuln = 100
			player.x = player.x - 8
			player.y = player.y - 8
		end
		projectile.i = 0
		projectile.ox = 120
		projectile.oy = 120
		projectile.active = true
 end
	projectile.i = projectile.i + delt
	if projectile.active then
		if projectile.i > 15 then
			sfx(16,3)
			projectile.i = 0
			projectile.ox = projectile.x
			projectile.oy = projectile.y
			projectile.active = false
			boss.hp = boss.hp - 1
		else
			projectile.x = ease(15,projectile.i,projectile.ox,boss.x)
			projectile.y = ease(15,projectile.i,projectile.oy,boss.y)
		end
	elseif not projectile.x == 120 and not projectile.y == 120 then
		if projectile.i > 10 then
			projectile.i = 0
			projectile.x = 120
			projectile.y = 120
			projectile.ox = 120
			projectile.oy = 120
		else
			projectile.x = ease(10,projectile.i,projectile.ox,120)
			projectile.y = ease(10,projectile.i,projectile.oy,120)
		end
	end
	if boss.hp == 8 and boss.phase == 1 then
		boss.phase = 2
		sfx(22,3)
	elseif boss.hp == 5 and boss.phase == 2 then
		boss.phase = 3
		sfx(23,3)
	elseif boss.hp == 2 and boss.phase == 3 then
		boss.phase = 4
		sfx(24,3)
	elseif boss.hp == 0 and boss.phase == 4 then
		bossfinishtime = time()
		if boss.y < 42 then
			boss.y = 42
		end
		if boss.y > 110 then
			boss.y = 110
		end
		boss.phase = 5
		boss.sprite = 13
		projectile.visible = false
		showtime = true
		music(22)
		
	end
	--end boss
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
function love.draw()
  if not lovepotion then
    push:apply("start")
  end
	cls(0)

	
	if level < 9  then 
		spr(5,120,120)
	end
	if level == 9 then
		spr(boss.sprite,boss.x,boss.y,1,1,boss.f)
		foreach(bsaws,drawbsaw)
		if projectile.visible then
		 spr(10,projectile.x,projectile.y)
		end
	end	
	spr(player.sprite,player.x,player.y,1,1,player.f)
	foreach(saws,drawsaw)
	if state == "title" then
		titlei = titlei + 0.01
		sspr(0,8,113,16,8,52-sin(titlei)*2.25,113,20+sin(titlei)*4.5)
		picopr("a game by dps2004",32,80,8)
		picopr("press (b) to start",31,88,8)
	end
	if state == "ld" then
		spr(15,0,52,16,2)
	end
	if level == 0 and state == "game" and player.y < 60 then
		picopr("press LDUR to move",0,96,8)
		picopr("press (b) to dash",0,104,8)
		picopr("you are invincible while dashing",0,112,8)
		picopr("touch the flag to win      -->",0,120,8)
	end
	if level == 1 and state == "game" and player.y < 70 then
		picopr("touching saws will kill you",0,80,8)
		-- no shit sherlock
	end
	if showtime then
		if time() - bossfinishtime > 3 then
			ftime = bossfinishtime - starttime
			picopr("time: "..ftime.." seconds",0,0,8)
		end
		if time() - bossfinishtime > 5 then
			if deaths == 0 then
				blurb = ". purrfect!"
			else
				blurb = "."
			end
			picopr("# of deaths: "..deaths..blurb,0,16,8)
		end
		if time() - bossfinishtime > 9  then
			picopr("thank you for playing.",0,32,8)
			picopr("game made by dps2004",0,120,8)
		end
	end
  if not lovepotion then
    push:apply("end")
  end
end