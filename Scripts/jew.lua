require('libs.Utils')
require('libs.VectorOp')
require('libs.HotkeyConfig2')
require('libs.DrawManager3D')
require('libs.TickCounter2')
require('libs.SideMessage')

ScriptConfig = ConfigGUI:New(script.name)
script:RegisterEvent(EVENT_KEY, ScriptConfig.Key, ScriptConfig)
script:RegisterEvent(EVENT_TICK, ScriptConfig.Refresh, ScriptConfig)
ScriptConfig:SetName("AIOGUI")
ScriptConfig:SetExtention(-.3)
ScriptConfig:SetVisible(false)

ScriptConfig:AddParam("slowDown","Performance",SGC_TYPE_NUMCYCLE,false,5,nil,1,15,1)
ScriptConfig:AddParam("roshBox","Roshan Monitor",SGC_TYPE_TOGGLE,false,true,nil)
ScriptConfig:AddParam("roshTime","Roshan Time to Chat",SGC_TYPE_TOGGLE,false,true,nil)
ScriptConfig:AddParam("roshRe","Roshan Respawn Message",SGC_TYPE_TOGGLE,false,true,nil)
ScriptConfig:AddParam("runeBox","Rune Monitor",SGC_TYPE_TOGGLE,false,true,nil)
ScriptConfig:AddParam("cours","Enemy Couriers",SGC_TYPE_TOGGLE,false,true,nil)
ScriptConfig:AddParam("glMon","Enemy Glyph Monitor",SGC_TYPE_TOGGLE,false,true,nil)
ScriptConfig:AddParam("items","Enemy Items Purchased",SGC_TYPE_TOGGLE,false,true,nil)
ScriptConfig:AddParam("allyTow","Ally Tower Range",SGC_TYPE_TOGGLE,false,true,nil)
ScriptConfig:AddParam("enemyTow","Enemy Tower Range",SGC_TYPE_TOGGLE,false,false,nil)
ScriptConfig:AddParam("manaBar","Mana Bars",SGC_TYPE_TOGGLE,false,true,nil)
ScriptConfig:AddParam("hpMon","HP Monitor",SGC_TYPE_TOGGLE,false,true,nil)


defaultFont = drawMgr:CreateFont("defaultFont","Arial",14,500)

--Minimap Constants
MapLeft = -8000
MapTop = 7350
MapRight = 7500
MapBottom = -7200
MapWidth = math.abs(MapLeft - MapRight)
MapHeight = math.abs(MapBottom - MapTop)
--Settings Table for 15 resolution
ResTable = 
{
	-- Settings for 4:3
	{800,600,{
		rosh       = {x = 640, y = 3},
		rune       = {x = 730, y = 3},
		minimap    = {px = 4, py = 5, h = 146, w = 151},
		ssMonitor  = {x = 172, y = 488, h = 19, w =84, size = 12},
		bars       = {manaOffset = Vector2D(-1,-10), size = Vector2D(58,4)},
		scoreboard = {gap = 0.09375, width = 0.04625, height = 0.0383333}
		}
	},
	{1024,768,{
		rosh       = {x = 820, y = -1},
		rune       = {x = 820 , y = 13},
		minimap    = {px = 5, py = 7, h = 186, w = 193},
		ssMonitor  = {x = 222, y = 625, h = 25, w = 104, size = 12},
		bars       = {manaOffset = Vector2D(-1,-12), size = Vector2D(74,6)},
		scoreboard = {gap = 0.09375, width = 0.04625, height = 0.0383333}
		}
	}, 
	{1152,864,{
		rosh       = {x = 930, y = 0},
		rune       = {x = 930 , y = 16},
		minimap    = {px = 6, py = 7, h = 211, w = 217},
		ssMonitor  = {x = 249, y = 703, h = 27, w = 115, size = 13},
		bars       = {healthFont = drawMgr:CreateFont("healthFont","Arial",12,500), manaOffset = Vector2D(-1,-14), hpOffset = Vector2D(-1,-19), size = Vector2D(82,6)},
		scoreboard = {gap = 0.09375, width = 0.04625, height = 0.0383333}
		}
	},
	{1280,960,{
		rosh       = {x = 1030, y = 1},
		rune       = {x = 1030 , y = 19},
		minimap    = {px = 6, py = 9, h = 233, w = 241},
		ssMonitor  = {x = 277, y = 782, h = 30, w = 130, size = 14},
		bars       = {healthFont = drawMgr:CreateFont("healthFont","Arial",12,500), manaOffset = Vector2D(-1,-16), hpOffset = Vector2D(-1,-22), size = Vector2D(92,6)},
		scoreboard = {gap = 0.09375, width = 0.04625, height = 0.0383333}
		}
	},
	{1280,1024,{
		rosh       = {x = 1030, y = 3},
		rune       = {x = 1030 , y = 21},
		minimap    = {px = 6, py = 9, h = 233, w = 241},
		ssMonitor  = {x = 277, y = 845, h = 30, w = 130, size = 14},
		bars       = {healthFont = drawMgr:CreateFont("healthFont","Arial",12,500), manaOffset = Vector2D(-1,-18), hpOffset = Vector2D(-1,-24), size = Vector2D(98,6)},
		scoreboard = {gap = 0.09375, width = 0.04625, height = 0.0383333}
		}
	},
	{1600,1200,{
		rosh       = {x = 1395, y = 6},
		rune       = {x = 1395 , y = 24},
		minimap    = {px = 8, py = 14, h = 288, w = 304},
		ssMonitor  = {x = 346, y = 978, h = 37, w = 156, size = 15},
		bars       = {manaFont = drawMgr:CreateFont("manaFont","Arial",10,500), healthFont = drawMgr:CreateFont("healthFont","Arial",12,500), manaOffset = Vector2D(-1,-20), hpOffset = Vector2D(-1,-28), size = Vector2D(114,8)},
		scoreboard = {gap = 0.09375, width = 0.04625, height = 0.0383333}
		}
	},
	-- Settings for 16:9
	{1280,720,{
		rosh       = {x = 150, y = 4},
		rune       = {x = 241 , y = 4},
		minimap    = {px = 8, py = 8, h = 174, w = 181},
		ssMonitor  = {x = 200, y = 605, h = 21, w = 90, size = 12},
		bars       = {healthFont = drawMgr:CreateFont("healthFont","Arial",12,500), manaOffset = Vector2D(-1,-12), hpOffset = Vector2D(-1,-17), size = Vector2D(70,6)},
		scoreboard = {gap = 0.070833, width = 0.034375, height = 0.03981}
		}
	},
	{1360,768,{
		rosh       = {x = 167, y = 6},
		rune       = {x = 258 , y = 6},
		minimap    = {px = 8, py = 8, h = 186, w = 193},
		ssMonitor  = {x = 213, y = 645, h = 23, w = 95, size = 13},
		bars       = {healthFont = drawMgr:CreateFont("healthFont","Arial",12,500), manaOffset = Vector2D(-1,-12), hpOffset = Vector2D(-1,-17), size = Vector2D(74,6)},
		scoreboard = {gap = 0.070833, width = 0.034375, height = 0.03981}
		}
	},
	{1366,768,{
		rosh       = {x = 167, y = 6},
		rune       = {x = 258 , y = 6},
		minimap    = {px = 8, py = 8, h = 186, w = 193},
		ssMonitor  = {x = 213, y = 645, h = 23, w = 95, size = 13},
		bars       = {healthFont = drawMgr:CreateFont("healthFont","Arial",12,500), manaOffset = Vector2D(-1,-12), hpOffset = Vector2D(-1,-17), size = Vector2D(74,6)},
		scoreboard = {gap = 0.070833, width = 0.034375, height = 0.03981}
		}
	},
	{1600,900,{
		rosh       = {x = 202, y = 9},
		rune       = {x = 293 , y = 9},
		minimap    = {px = 9, py = 9, h = 217, w = 227},
		ssMonitor  = {x = 250, y = 756, h = 27, w = 100, size = 14},
		bars       = {healthFont = drawMgr:CreateFont("healthFont","Arial",12,500), manaOffset = Vector2D(-1,-15), hpOffset = Vector2D(-1,-21), size = Vector2D(86,6)},
		scoreboard = {gap = 0.070833, width = 0.034375, height = 0.03981}
		}
	},
	{1920,1080,{
		rosh       = {x = 212, y = 3},
		rune       = {x = 212 , y = 21},
		minimap    = {px = 11, py = 11, h = 261, w = 272},
		ssMonitor  = {x = 300, y = 907, h = 32, w = 100, size = 14},
		bars       = {manaFont = drawMgr:CreateFont("manaFont","Arial",10,500), healthFont = drawMgr:CreateFont("healthFont","Arial",12,500), manaOffset = Vector2D(-1,-19), hpOffset = Vector2D(-1,-27), size = Vector2D(104,8)},
		scoreboard = {gap = 0.070833, width = 0.034375, height = 0.03981}
		}
	},
	-- Settings for 16:10
	{1280,768,{
		rosh       = {x = 146, y = 6},
		rune       = {x = 236 , y = 6},
		minimap    = {px = 8, py = 8, h = 186, w = 193},
		ssMonitor  = {x = 283, y = 620, h = 25, w = 103, size = 13},
		bars       = {manaOffset = Vector2D(-1,-12), size = Vector2D(74,6)},
		scoreboard = {gap = 0.0784722, width = 0.038194, height = 0.0388}
		}
	},
	{1280,800,{
		rosh       = {x = 1020, y = 6},
		rune       = {x = 1110 , y = 6},
		minimap    = {px = 8, py = 10, h = 192, w = 203},
		ssMonitor  = {x = 283, y = 652, h = 25, w = 103, size = 13},
		bars       = {healthFont = drawMgr:CreateFont("defaultFont","Arial",12,500), manaOffset = Vector2D(-1,-13), hpOffset = Vector2D(-1,-18), size = Vector2D(78,6)},
		scoreboard = {gap = 0.0784722, width = 0.038194, height = 0.0388}
		}
	},
	{1440,900,{
		rosh       = {x = 172, y = 9},
		rune       = {x = 262 , y = 9},
		minimap    = {px = 9, py = 9, h = 217, w = 227},
		ssMonitor  = {x = 318, y = 734, h = 28, w = 115, size = 14},
		bars       = {healthFont = drawMgr:CreateFont("defaultFont","Arial",12,500), manaOffset = Vector2D(-1,-15), hpOffset = Vector2D(-1,-21), size = Vector2D(86,6)},
		scoreboard = {gap = 0.0784722, width = 0.038194, height = 0.0388}
		}
	},
	{1680,1050,{
		rosh       = {x = 212, y = 3},
		rune       = {x = 212 , y = 21},
		minimap    = {px = 10, py = 11, h = 252, w = 267},
		ssMonitor  = {x = 277, y = 857, h = 32, w = 95, size = 14},
		bars       = {healthFont = drawMgr:CreateFont("defaultFont","Arial",12,500), manaOffset = Vector2D(-1,-18), hpOffset = Vector2D(-1,-25), size = Vector2D(102,6)},
		scoreboard = {gap = 0.0784722, width = 0.038194, height = 0.0388}
		}
	},
	{1920,1200,{
		rosh       = {x = 242, y = 6},
		rune       = {x = 242 , y = 24},
		minimap    = {px = 12, py = 14, h = 288, w = 304},
		ssMonitor  = {x = 320, y = 977, h = 32, w = 100, size = 14},
		bars       = {manaFont = drawMgr:CreateFont("manaFont","Arial",10,500), healthFont = drawMgr:CreateFont("healthFont","Arial",12,500), manaOffset = Vector2D(-1,-20), hpOffset = Vector2D(-1,-28), size = Vector2D(114,8)},
		scoreboard = {gap = 0.0784722, width = 0.038194, height = 0.0388}
		}
	},
}

slowDown = 0

function Tick()
	local playing = PlayingGame()
	ScriptConfig:SetVisible(playing)
	slowDown = 1 + slowDown%ScriptConfig.slowDown
	if slowDown == 1 then
		TickCounter.Start()
		CreepMasterTick(playing)

		EffectTick(playing)

		RuneTick(playing)

		RoshanTick(playing)

		MissingTick(playing)

		HpTick(playing)

		ManaBarTick(playing)

		CollectData(playing)

		AdvancedTick(playing)

		ScoreBoardTick(playing)

		GlyphTick(playing)

		ItemTick(playing)

		RoshanRespawnTick(playing)
		TickCounter.CalculateAvg()
		if IsKeyDown(45) then
			TickCounter.Print()
		end
	end
end

--== ROSHAN RESPAWN ==--

roshAlive = nil

function RoshanRespawnTick(playing)
	if playing and ScriptConfig.roshRe then
		local alive = #entityList:GetEntities({classId=CDOTA_Unit_Roshan}) == 1
		if roshAlive == false and alive == true then
			RoshRespawnMessage()
		end
		roshAlive = alive	
	else
		roshAlive = nil
	end
end

roshFont = drawMgr:CreateFont("roshFont","Arial",20,500)

function RoshRespawnMessage()
	local test = sideMessage:CreateMessage(200,45)
	test:AddElement(drawMgr:CreateRect(006,0,75,42,0xFFFFFFFF,drawMgr:GetTextureId("NyanUI/heroes_horizontal/roshan")))
	test:AddElement(drawMgr:CreateText(95,0,0xFFFFFFFF,"Roshan Is",roshFont))
	test:AddElement(drawMgr:CreateText(95,20,0xFFFFFFFF,"Respawned",roshFont))
end


--== ENEMY GLYPH MONITOR ==--

glyphFont = drawMgr:CreateFont("glyphFont","Arial",14,1600)

function GlyphTick(playing)
	if playing and ScriptConfig.glMon then
		local pos = Vector2D(screenSize.x - screenSize.y*0.02222,screenSize.y*0.9759)
		local glyphText = GetGlyphTime()
		local glyphSize = glyphFont:GetTextSize(glyphText)
		if not enemyGlyph then
			enemyGlyph = drawMgr:CreateText(pos.x - glyphSize.x/2,pos.y - glyphSize.y/2,0xFFFFFF80,glyphText,glyphFont)
		else
			enemyGlyph.x = pos.x - glyphSize.x/2
			enemyGlyph.text = glyphText
		end		
	elseif enemyGlyph then
		enemyGlyph.visible = false
        enemyGlyph = nil
	end
end

function GetGlyphTime()
	local team = 5 - entityList:GetMyHero().team
	local cd = client:GetGlyphCooldown(team)
	if cd > 0 then
		return tostring(cd)
	else
		return "Ready"
	end
end





--== MANABARS ==--

manaBar = {}

function ManaBarTick(playing)
	if playing and ScriptConfig.manaBar then
		if not manaBar.init then
			manaBar.init = true
		end
		local enemies = entityList:GetEntities(function (ent) return ent.hero and ent.team ~= entityList:GetMyHero().team and not ent:IsIllusion() and ent.visible and ent.alive and not ent:IsUnitState(LuaEntityNPC.STATE_NO_HEALTHBAR) end)
		for i,v in ipairs(enemies) do
			if not manaBar[v.handle] then
				CreateManabar(v)
			end
		end
		for k,v in pairs(manaBar) do
			if type(k) == "number" then
				local entity = entityList:GetEntity(k)
				if entity then
					if entity.visible and entity.alive and not entity:IsUnitState(LuaEntityNPC.STATE_NO_HEALTHBAR) then
						UpdateManaBar(entity)
					else
						DestroyManaBar(k)
					end
				else
					DestroyManaBar(k)
				end
			end
		end
	elseif manaBar.init then
		for k,v in pairs(manaBar) do
            if k ~= "init" then
            	for key,value in pairs(v) do
	            	value:Destroy()
            	end
            end
        end
        manaBar = {}
	end
end

function CreateManabar(hero)
	local barPect = hero.mana / hero.maxMana
	manaBar[hero.handle] = {}
	manaBar[hero.handle].back = drawMgr3D:CreateRect(hero,Vector(0,0,hero.healthbarOffset),location.bars.manaOffset,location.bars.size,mb.emptyManaColor)
	manaBar[hero.handle].mana = drawMgr3D:CreateRect(hero,Vector(0,0,hero.healthbarOffset),Vector2D(location.bars.manaOffset.x-location.bars.size.x/2+location.bars.size.x*barPect/2,location.bars.manaOffset.y),Vector2D(location.bars.size.x*barPect,location.bars.size.y),mb.manaColor)
	manaBar[hero.handle].border = drawMgr3D:CreateRect(hero,Vector(0,0,hero.healthbarOffset),location.bars.manaOffset,location.bars.size,0x000000FF,true)
	if location.bars.manaFont then
		manaBar[hero.handle].text = drawMgr3D:CreateText(hero,Vector(0,0,hero.healthbarOffset),Vector2D(location.bars.manaOffset.x,location.bars.manaOffset.y + 1),0xFFFFFFFF,math.floor(hero.mana).." / "..math.floor(hero.maxMana),location.bars.manaFont)
	end
end

function UpdateManaBar(hero)
	local barPect = hero.mana / hero.maxMana
	manaBar[hero.handle].mana:Align2D(Vector2D(location.bars.manaOffset.x-location.bars.size.x/2+location.bars.size.x*barPect/2,location.bars.manaOffset.y))
	manaBar[hero.handle].mana:SetSize(Vector2D(location.bars.size.x*barPect,location.bars.size.y))
	if manaBar[hero.handle].text then
		manaBar[hero.handle].text:SetText(math.floor(hero.mana).." / "..math.floor(hero.maxMana))
	end
	
end

function DestroyManaBar(handle)
	manaBar[handle].back:Destroy()
	manaBar[handle].mana:Destroy()
	manaBar[handle].border:Destroy()
	if manaBar[handle].text then
		manaBar[handle].text:Destroy()
	end
	manaBar[handle] = nil
end

--== HP MONITOR ==--

hpMon = {}

function HpTick(playing)
	if playing and ScriptConfig.hpMon and location.bars.healthFont then
		if not hpMon.init then
			hpMon.init = true
		end
		local enemies = entityList:GetEntities(function (ent) return ent.hero and ent.team ~= entityList:GetMyHero().team and not ent:IsIllusion() and ent.visible and ent.alive and not ent:IsUnitState(LuaEntityNPC.STATE_NO_HEALTHBAR) end)
		for i,v in ipairs(enemies) do
			if not hpMon[v.handle] then
				CreateHpVisuals(v)
			end
		end
		for k,v in pairs(hpMon) do
			if type(k) == "number" then
				local entity = entityList:GetEntity(k)
				if entity then
					if entity.visible and entity.alive and not entity:IsUnitState(LuaEntityNPC.STATE_NO_HEALTHBAR) then
						UpdateHpVisuals(entity)
					else
						DesroyHpVisuals(k)
					end
				else
					DesroyHpVisuals(k)
				end
			end
		end
	elseif hpMon.init then
		for k,v in pairs(hpMon) do
            if k ~= "init" then
            	v:Destroy()
            end
        end
        hpMon = {}
	end
end

function CreateHpVisuals(hero)
	if location.bars.healthFont then
		hpMon[hero.handle] = drawMgr3D:CreateText(hero,Vector(0,0,hero.healthbarOffset),location.bars.hpOffset,0xFFFFFFFF,math.floor(hero.health).." / "..math.floor(hero.maxHealth),location.bars.healthFont)
	end
end

function UpdateHpVisuals(hero)
	hpMon[hero.handle]:SetText(math.floor(hero.health).." / "..math.floor(hero.maxHealth))
end

function DesroyHpVisuals(handle)
	hpMon[handle]:Destroy()
	hpMon[handle] = nil
end


--== ROSHAN MONITOR ==--

roshObjs = {}

function RoshanTick(playing)
	if playing and ScriptConfig.roshBox then
		if not roshObjs.init then
			roshObjs.init = true
	        roshObjs.inside = drawMgr:CreateRect(location.rosh.x,location.rosh.y,95,18,0x000000FF)
	        roshObjs.inBorder = drawMgr:CreateRect(location.rosh.x-1,location.rosh.y-1,97,20,0x000000A0,true)
	        roshObjs.outBorder = drawMgr:CreateRect(location.rosh.x-2,location.rosh.y-2,99,22,0x00000050,true)
	        roshObjs.bmp = drawMgr:CreateRect(location.rosh.x,location.rosh.y,16,16,0x000000FF,drawMgr:GetTextureId("NyanUI/miniheroes/roshan"))
	        roshObjs.text = drawMgr:CreateText(location.rosh.x+20,location.rosh.y+3,0xFFFFFFFF,"Roshan: Alive",defaultFont)
		else
		    if roshObjs.deathTick and RoshAlive() then
		            roshObjs.deathTick = nil	
		    end
		    if roshObjs.deathTick then
		        local bigRes = 660 - tickDelta
		        local smlRes = 480 - tickDelta
		        local minutes = math.floor(tickDelta/60)
		        local seconds = tickDelta%60
		        if smlRes <= 0 then
		            roshObjs.text.text = (string.format("Roshan: %02d:%02d",10-minutes,59-seconds))
		        else
		            roshObjs.text.text = (string.format("%02d:%02d - %02d:%02d",math.floor(smlRes/60),smlRes%60,math.floor(bigRes/60),bigRes%60))
		        end
		    elseif roshObjs.text.text ~= "Roshan: Alive" then
		        roshObjs.text.text = ("Roshan: Alive")
		    end
		end
	elseif roshObjs.init then
        for k,v in pairs(roshObjs) do
            if k ~= "init" then
                v.visible = false
            end
        end
        roshObjs = {}
	end
end

function RoshAlive()
    local entities = entityList:GetEntities({classId=CDOTA_Unit_Roshan})
    tickDelta = client.gameTime-roshObjs.deathTick
    if #entities > 0 and tickDelta > 60 then
            local rosh = entities[1]
            if rosh and rosh.alive then
                    return true
            end
    end
    return false
end


function RoshEvent( event )
    if event.name == "dota_roshan_kill" then
        roshObjs.deathTick = client.gameTime
        if ScriptConfig.roshTime then
        	client:ExecuteCmd("chatwheel_say 53")
        	client:ExecuteCmd("chatwheel_say 57")
        end
    end
end

script:RegisterEvent(EVENT_DOTA,RoshEvent)



--== ENEMY COURIER ON MINIMAP ==--

cours = {}

function CourierTick()
    if ScriptConfig.cours and PlayingGame() then
        cours.init = true
        local enemyCours = entityList:GetEntities(function (ent) return ent.courier and ent.team == entityList:GetMyHero():GetEnemyTeam() end)
        for i,v in ipairs(enemyCours) do
            if v.visible and v.alive then
                local courMinimap = MapToMinimap(v)
                local flying = v:GetProperty("CDOTA_Unit_Courier","m_bFlyingCourier")
                if flying then
                    if not cours[v.handle] or not cours[v.handle].flying then
                        cours[v.handle] = {}
                        cours[v.handle].icon = drawMgr:CreateRect(courMinimap.x-10,courMinimap.y-6,24,12,0x000000FF,drawMgr:GetTextureId("NyanUI/other/courier_flying"))
                        cours[v.handle].vec = courMinimap
                        cours[v.handle].flying = flying
                    elseif GetDistance2D(courMinimap,cours[v.handle].vec) > 0 then
                        cours[v.handle].icon.x,cours[v.handle].icon.y = courMinimap.x-10,courMinimap.y-6
                    end
                else
                    if not cours[v.handle] or not cours[v.handle].flying then
                        cours[v.handle] = {}
                        cours[v.handle].icon = drawMgr:CreateRect(courMinimap.x-6,courMinimap.y-6,12,12,0x000000FF,drawMgr:GetTextureId("NyanUI/other/courier"))
                        cours[v.handle].vec = courMinimap
                        cours[v.handle].flying = flying
                    elseif GetDistance2D(courMinimap,cours[v.handle].vec) > 0 then
                        cours[v.handle].icon.x,cours[v.handle].icon.y = courMinimap.x-6,courMinimap.y-6
                    end
                end
            elseif cours[v.handle] then
                cours[v.handle].icon.visible = false
                cours[v.handle] = nil
            end
        end
    elseif cours.init then
        for k,v in pairs(cours) do
            if k ~= "init" then
                v.visible = false
            end
        end
        cours = {}
    end
end

script:RegisterEvent(EVENT_FRAME,CourierTick)



--== SETTING UP CONSTANTS ==--

do
	screenSize = client.screenSize
	if screenSize.x == 0 and screenSize.y == 0 then
		print("AiO GUI Helper cannot detect your screen resolutions.\nPlease switch to the Borderless Window mode.")
		script:Unload()
	end
	for i,v in ipairs(ResTable) do
		if v[1] == screenSize.x and v[2] == screenSize.y then
			location = v[3]
			break
		elseif i == #ResTable then
			print(screenSize.x.."x"..screenSize.y.." resolution is unsupported by AiO GUI Helper.")
			script:Unload()
		end
	end
	mmFont = drawMgr:CreateFont("mmFont","Arial",location.ssMonitor.size,500)
end

mb = {}
mb.manaColor = 0x5279FFFF
mb.emptyManaColor = 0x001863FF

MinimapMapScaleX = location.minimap.w / MapWidth
MinimapMapScaleY = location.minimap.h / MapHeight

script:RegisterEvent(EVENT_TICK,Tick)
