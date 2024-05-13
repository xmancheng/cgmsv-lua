---模块类
local Module = ModuleBase:createModule('achieveMagician')

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self))
  self:regCallback('TechOptionEvent', Func.bind(self.OnTechOptionEventCallBack, self))
  self:regCallback('BattleOverEvent', Func.bind(self.OnBattleOverCallBack, self))
end

function Module:handleTalkEvent(charIndex,msg,color,range,size)
	if (msg=="/magician") then
		local flag_earth = math.floor(tonumber( Field.Get( charIndex, 'magician_flag_earth'))) or 0;
		local flag_water = math.floor(tonumber( Field.Get( charIndex, 'magician_flag_water'))) or 0;
		local flag_fire = math.floor(tonumber( Field.Get( charIndex, 'magician_flag_fire'))) or 0;
		local flag_wind = math.floor(tonumber( Field.Get( charIndex, 'magician_flag_wind'))) or 0;
		NLG.SystemMessage(charIndex, "超強隕石魔法【"..flag_earth.."】次.超強冰凍魔法【"..flag_water.."】次");
		NLG.SystemMessage(charIndex, "超強火焰魔法【"..flag_fire.."】次.超強風刃魔法【"..flag_wind.."】次");
		return 0;
	end
	return 1;
end

function Module:OnTechOptionEventCallBack(charIndex, option, techID, val)
      --self:logDebug('OnTechOptionEventCallBack', charIndex, option, techID, val)
      if Char.IsPlayer(charIndex) then
            local battleIndex = Char.GetBattleIndex(charIndex)
            local leader1 = Battle.GetPlayer(battleIndex,0)
            local leader2 = Battle.GetPlayer(battleIndex,5)
            local leader = leader1
            if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
                  leader = leader2
            end
            local WeaponIndex = Char.GetWeapon(charIndex);
            local Round = Battle.GetTurn(battleIndex);
            local symf_round= Char.GetTempData(charIndex, '魔法回合') or 0;
            if (WeaponIndex>0) then
                  local wandId = Item.GetData(WeaponIndex, CONST.道具_ID);
                  if ( Round==0 or (Round - symf_round)>=1) then
                      local flag_earth = tonumber( Field.Get( charIndex, 'magician_flag_earth')) or 0;
                      local flag_water = tonumber( Field.Get( charIndex, 'magician_flag_water')) or 0;
                      local flag_fire = tonumber( Field.Get( charIndex, 'magician_flag_fire')) or 0;
                      local flag_wind = tonumber( Field.Get( charIndex, 'magician_flag_wind')) or 0;
                      if (techID == 2709 and wandId == 79013)  then    --装备[壹之型]鬼哭使用超陨Lv10
                         Char.SetTempData(charIndex, '魔法回合', Round);
                         NLG.UpChar(charIndex);
                         if ( Round==0) then
                            Field.Set(charIndex, 'magician_flag_earth', tonumber( flag_earth+(1/20)));
                         else
                            Field.Set(charIndex, 'magician_flag_earth', tonumber( flag_earth+1));
                         end
                      elseif (techID == 2809 and wandId == 79013)  then
                            Char.SetTempData(charIndex, '魔法回合', Round);
                            NLG.UpChar(charIndex);
                         if ( Round==0) then
                            Field.Set(charIndex, 'magician_flag_water', tonumber( flag_water+(1/20)));
                         else
                            Field.Set(charIndex, 'magician_flag_water', tonumber( flag_water+1));
                         end
                      elseif (techID == 2909 and wandId == 79013)  then
                            Char.SetTempData(charIndex, '魔法回合', Round);
                            NLG.UpChar(charIndex);
                         if ( Round==0) then
                            Field.Set(charIndex, 'magician_flag_fire', tonumber( flag_fire+(1/20)));
                         else
                            Field.Set(charIndex, 'magician_flag_fire', tonumber( flag_fire+1));
                         end
                      elseif (techID == 3009 and wandId == 79013)  then
                            Char.SetTempData(charIndex, '魔法回合', Round);
                            NLG.UpChar(charIndex);
                         if ( Round==0) then
                            Field.Set(charIndex, 'magician_flag_wind', tonumber( flag_wind+(1/20)));
                         else
                            Field.Set(charIndex, 'magician_flag_wind', tonumber( flag_wind+1));
                         end
                      end
                  end
            end
      end
      return val
end

function Module:OnBattleOverCallBack(battleIndex)
       for i=0, 9 do
            local player = Battle.GetPlayIndex(battleIndex, i)
            if player>=0 and Char.IsPlayer(player) then
                local WeaponIndex,targetSlot = Char.GetWeapon(player);
                if (WeaponIndex>0) then
                  local wandId = Item.GetData(WeaponIndex, CONST.道具_ID);
                  if (wandId == 79013)  then
                      local flag_earth = math.floor(tonumber( Field.Get( player, 'magician_flag_earth'))) or 0;
                      local flag_water = math.floor(tonumber( Field.Get( player, 'magician_flag_water'))) or 0;
                      local flag_fire = math.floor(tonumber( Field.Get( player, 'magician_flag_fire'))) or 0;
                      local flag_wind = math.floor(tonumber( Field.Get( player, 'magician_flag_wind'))) or 0;
                      if (Char.ItemSlot(player)<20) then
                          if (flag_earth>=3000 and flag_water>=3000 and flag_fire>=3000 and flag_wind>=3000)  then
                              Field.Set(player, 'magician_flag_earth', 0);
                              Field.Set(player, 'magician_flag_water', 0);
                              Field.Set(player, 'magician_flag_fire', 0);
                              Field.Set(player, 'magician_flag_wind', 0);
                              NLG.SystemMessage(player,"[系統]你的武器發出閃耀的星光，外型產生變化！");
                              Char.DelItemBySlot(player, targetSlot);
                              local itemID={79213,79214};
                              local rate = NLG.Rand(1,2);
                              Char.GiveItem(player, itemID[rate], 1);
                          end
                      else
                      end
                  end
                end
            end
       end
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;