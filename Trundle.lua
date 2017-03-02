local ver = "0.01"


if FileExist(COMMON_PATH.."MixLib.lua") then
 require('MixLib')
else
 PrintChat("MixLib not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end


if GetObjectName(GetMyHero()) ~= "Trundle" then return end


require("DamageLib")

function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat('<font color = "#00FFFF">New version found! ' .. data)
        PrintChat('<font color = "#00FFFF">Downloading update, please wait...')
        DownloadFileAsync('https://raw.githubusercontent.com/allwillburn/Trundle/master/Trundle.lua', SCRIPT_PATH .. 'Trundle.lua', function() PrintChat('<font color = "#00FFFF">Update Complete, please 2x F6!') return end)
    else
        PrintChat('<font color = "#00FFFF">No updates found!')
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/allwillburn/Trundle/master/Trundle.version", AutoUpdate)


GetLevelPoints = function(unit) return GetLevel(unit) - (GetCastLevel(unit,0)+GetCastLevel(unit,1)+GetCastLevel(unit,2)+GetCastLevel(unit,3)) end
local SetDCP, SkinChanger = 0

local TrundleMenu = Menu("Trundle", "Trundle")

TrundleMenu:SubMenu("Combo", "Combo")

TrundleMenu.Combo:Boolean("Q", "Use Q in combo", true)
TrundleMenu.Combo:Boolean("W", "Use W in combo", true)
TrundleMenu.Combo:Boolean("E", "Use E in combo", true)
TrundleMenu.Combo:Boolean("R", "Use R in combo", true)
TrundleMenu.Combo:Slider("RX", "X Enemies to Cast R",3,1,5,1)
TrundleMenu.Combo:Boolean("Cutlass", "Use Cutlass", true)
TrundleMenu.Combo:Boolean("Tiamat", "Use Tiamat", true)
TrundleMenu.Combo:Boolean("BOTRK", "Use BOTRK", true)
TrundleMenu.Combo:Boolean("RHydra", "Use RHydra", true)
TrundleMenu.Combo:Boolean("YGB", "Use GhostBlade", true)
TrundleMenu.Combo:Boolean("Gunblade", "Use Gunblade", true)
TrundleMenu.Combo:Boolean("Randuins", "Use Randuins", true)


TrundleMenu:SubMenu("AutoMode", "AutoMode")
TrundleMenu.AutoMode:Boolean("Level", "Auto level spells", false)
TrundleMenu.AutoMode:Boolean("Ghost", "Auto Ghost", false)
TrundleMenu.AutoMode:Boolean("Q", "Auto Q", false)
TrundleMenu.AutoMode:Boolean("W", "Auto W", false)
TrundleMenu.AutoMode:Boolean("E", "Auto E", false)
TrundleMenu.AutoMode:Boolean("R", "Auto R", false)

TrundleMenu:SubMenu("LaneClear", "LaneClear")
TrundleMenu.LaneClear:Boolean("Q", "Use Q", true)
TrundleMenu.LaneClear:Boolean("W", "Use W", true)
TrundleMenu.LaneClear:Boolean("E", "Use E", true)
TrundleMenu.LaneClear:Boolean("RHydra", "Use RHydra", true)
TrundleMenu.LaneClear:Boolean("Tiamat", "Use Tiamat", true)

TrundleMenu:SubMenu("Harass", "Harass")
TrundleMenu.Harass:Boolean("Q", "Use Q", true)
TrundleMenu.Harass:Boolean("W", "Use W", true)

TrundleMenu:SubMenu("KillSteal", "KillSteal")
TrundleMenu.KillSteal:Boolean("Q", "KS w Q", true)
TrundleMenu.KillSteal:Boolean("E", "KS w E", true)

TrundleMenu:SubMenu("AutoIgnite", "AutoIgnite")
TrundleMenu.AutoIgnite:Boolean("Ignite", "Ignite if killable", true)

TrundleMenu:SubMenu("Drawings", "Drawings")
TrundleMenu.Drawings:Boolean("DE", "Draw E Range", true)

TrundleMenu:SubMenu("SkinChanger", "SkinChanger")
TrundleMenu.SkinChanger:Boolean("Skin", "UseSkinChanger", true)
TrundleMenu.SkinChanger:Slider("SelectedSkin", "Select A Skin:", 1, 0, 4, 1, function(SetDCP) HeroSkinChanger(myHero, SetDCP)  end, true)

OnTick(function (myHero)
	local target = GetCurrentTarget()
        local YGB = GetItemSlot(myHero, 3142)
	local RHydra = GetItemSlot(myHero, 3074)
	local Tiamat = GetItemSlot(myHero, 3077)
        local Gunblade = GetItemSlot(myHero, 3146)
        local BOTRK = GetItemSlot(myHero, 3153)
        local Cutlass = GetItemSlot(myHero, 3144)
        local Randuins = GetItemSlot(myHero, 3143)

	--AUTO LEVEL UP
	if TrundleMenu.AutoMode.Level:Value() then

			spellorder = {_E, _W, _Q, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
			if GetLevelPoints(myHero) > 0 then
				LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
			end
	end
        
        --Harass
          if Mix:Mode() == "Harass" then
            if TrundleMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, 700) then
				if target ~= nil then 
                                      CastSpell(_Q)
                                end
            end

            if TrundleMenu.Harass.W:Value() and Ready(_W) and ValidTarget(target, 900) then
				CastTargetSpell(target, _W)
            end     
          end

	--COMBO
	  if Mix:Mode() == "Combo" then
            if TrundleMenu.Combo.YGB:Value() and YGB > 0 and Ready(YGB) and ValidTarget(target, 700) then
			CastSpell(YGB)
            end

            if TrundleMenu.Combo.Randuins:Value() and Randuins > 0 and Ready(Randuins) and ValidTarget(target, 500) then
			CastSpell(Randuins)
            end

            if TrundleMenu.Combo.BOTRK:Value() and BOTRK > 0 and Ready(BOTRK) and ValidTarget(target, 550) then
			 CastTargetSpell(target, BOTRK)
            end

            if TrundleMenu.Combo.Cutlass:Value() and Cutlass > 0 and Ready(Cutlass) and ValidTarget(target, 700) then
			 CastTargetSpell(target, Cutlass)
            end

            if TrundleMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 700) then
			 CastTargetSpell(target, _E)
	    end

            if TrundleMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 700) then
		     if target ~= nil then 
                         CastSpell(_Q)
                     end
            end

            if TrundleMenu.Combo.Tiamat:Value() and Tiamat > 0 and Ready(Tiamat) and ValidTarget(target, 350) then
			CastSpell(Tiamat)
            end

            if TrundleMenu.Combo.Gunblade:Value() and Gunblade > 0 and Ready(Gunblade) and ValidTarget(target, 700) then
			CastTargetSpell(target, Gunblade)
            end

            if TrundleMenu.Combo.RHydra:Value() and RHydra > 0 and Ready(RHydra) and ValidTarget(target, 400) then
			CastSpell(RHydra)
            end

	    if TrundleMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 900) then
			CastTargetSpell(target, _W)
	    end
	    
	    
            if TrundleMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 700) and (EnemiesAround(myHeroPos(), 700) >= TrundleMenu.Combo.RX:Value()) then
			CastTargetSpell(target, _R)
            end

          end

         --AUTO IGNITE
	for _, enemy in pairs(GetEnemyHeroes()) do
		
		if GetCastName(myHero, SUMMONER_1) == 'SummonerDot' then
			 Ignite = SUMMONER_1
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end

		elseif GetCastName(myHero, SUMMONER_2) == 'SummonerDot' then
			 Ignite = SUMMONER_2
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end
		end

	end

        for _, enemy in pairs(GetEnemyHeroes()) do
                
                if IsReady(_Q) and ValidTarget(enemy, 700) and TrundleMenu.KillSteal.Q:Value() and GetHP(enemy) < getdmg("Q",enemy) then
		         if target ~= nil then 
                                      CastSpell(_Q)
		         end
                end 

                if IsReady(_E) and ValidTarget(enemy, 187) and TrundleMenu.KillSteal.E:Value() and GetHP(enemy) < getdmg("E",enemy) then
		                      CastTargetSpell(target, _E)
                end
      end

      if Mix:Mode() == "LaneClear" then
      	  for _,closeminion in pairs(minionManager.objects) do
	        if TrundleMenu.LaneClear.Q:Value() and Ready(_Q) and ValidTarget(closeminion, 700) then
	        	CastTargetSpell(closeminion, _Q)
                end

                if TrundleMenu.LaneClear.W:Value() and Ready(_W) and ValidTarget(closeminion, 900) then
	        	CastTargetSpell(target, _W)
	        end

                if TrundleMenu.LaneClear.E:Value() and Ready(_E) and ValidTarget(closeminion, 187) then
	        	CastTargetSpell(target, _E)
	        end

                if TrundleMenu.LaneClear.Tiamat:Value() and ValidTarget(closeminion, 350) then
			CastSpell(Tiamat)
		end
	
		if TrundleMenu.LaneClear.RHydra:Value() and ValidTarget(closeminion, 400) then
                        CastTargetSpell(closeminion, RHydra)
      	        end
          end
      end
        --AutoMode
        if TrundleMenu.AutoMode.Q:Value() then        
          if Ready(_Q) and ValidTarget(target, 700) then
		      CastSpell(_Q)
          end
        end 
        if TrundleMenu.AutoMode.W:Value() then        
          if Ready(_W) and ValidTarget(target, 900) then
	  	      CastTargetSpell(target, _W)
          end
        end
        if TrundleMenu.AutoMode.E:Value() then        
	  if Ready(_E) and ValidTarget(target, 125) then
		      CastSpell(_E)
	  end
        end
        if TrundleMenu.AutoMode.R:Value() then        
	  if Ready(_R) and ValidTarget(target, 700) then
		      CastTargetSpell(target, _R)
	  end
        end
                
	--AUTO GHOST
	if TrundleMenu.AutoMode.Ghost:Value() then
		if GetCastName(myHero, SUMMONER_1) == "SummonerHaste" and Ready(SUMMONER_1) then
			CastSpell(SUMMONER_1)
		elseif GetCastName(myHero, SUMMONER_2) == "SummonerHaste" and Ready(SUMMONER_2) then
			CastSpell(Summoner_2)
		end
	end
end)

OnDraw(function (myHero)
        
         if TrundleMenu.Drawings.DE:Value() then
		DrawCircle(GetOrigin(myHero), 1000, 0, 200, GoS.Red)
	end

end)


OnProcessSpell(function(unit, spell)
	local target = GetCurrentTarget()        
       
        if unit.isMe and spell.name:lower():find("Trundlechomp") then 
		Mix:ResetAA()	
	end        

        if unit.isMe and spell.name:lower():find("itemtiamatcleave") then
		Mix:ResetAA()
	end	
               
        if unit.isMe and spell.name:lower():find("itemravenoushydracrescent") then
		Mix:ResetAA()
	end

end) 


local function SkinChanger()
	if TrundleMenu.SkinChanger.UseSkinChanger:Value() then
		if SetDCP >= 0  and SetDCP ~= GlobalSkin then
			HeroSkinChanger(myHero, SetDCP)
			GlobalSkin = SetDCP
		end
        end
end


print('<font color = "#01DF01"><b>Trundle</b> <font color = "#01DF01">by <font color = "#01DF01"><b>Allwillburn</b> <font color = "#01DF01">Loaded!')





