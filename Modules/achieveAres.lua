---模块类
local Module = ModuleBase:createModule('achieveAres')

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self))
  self:regCallback('TechOptionEvent', Func.bind(self.OnTechOptionEventCallBack, self))
  self:regCallback('BattleOverEvent', Func.bind(self.OnBattleOverCallBack, self))
end

function Module:handleTalkEvent(charIndex,msg,color,range,size)
	if (msg=="/ares") then
		local flag_S = tonumber( Field.Get( charIndex, 'ares_flag_S')) or 0;
		local flag_A = tonumber( Field.Get( charIndex, 'ares_flag_A')) or 0;
		local flag_L = tonumber( Field.Get( charIndex, 'ares_flag_L')) or 0;
		NLG.SystemMessage(charIndex, "裝備[壹之型]天羽羽斬，使用50次連擊Lv10走向勇者戰神之路！");
		NLG.SystemMessage(charIndex, "連擊 破碎【"..flag_S.."/50】次");
		NLG.SystemMessage(charIndex, "裝備[壹之型]夜，使用50次乾坤Lv10走向勇者戰神之路！");
		NLG.SystemMessage(charIndex, "乾坤一擲點睛【"..flag_A.."/50】次");
		NLG.SystemMessage(charIndex, "裝備[壹之型]叢雲切，使用50次諸刃Lv10走向勇者戰神之路！");
		NLG.SystemMessage(charIndex, "諸刃突擊【"..flag_L.."/50】次");
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
	local flag_S = tonumber( Field.Get( charIndex, 'ares_flag_S')) or 0;
	local flag_A = tonumber( Field.Get( charIndex, 'ares_flag_A')) or 0;
	local flag_L = tonumber( Field.Get( charIndex, 'ares_flag_L')) or 0;
                      if (techID == 9 and wandId == 79010)  then 
                         Char.SetTempData(charIndex, '魔法回合', Round);
                         NLG.UpChar(charIndex);
                         if ( Round>0) then
                            Field.Set(charIndex, 'ares_flag_S', tonumber( flag_S+1*Round));
                         end
                      elseif (techID == 309 and wandId == 79011)  then
                            Char.SetTempData(charIndex, '魔法回合', Round);
                            NLG.UpChar(charIndex);
                         if ( Round>0) then
                            Field.Set(charIndex, 'ares_flag_A', tonumber( flag_A+1*Round));
                         end
                      elseif (techID == 109 and wandId == 79012)  then
                            Char.SetTempData(charIndex, '魔法回合', Round);
                            NLG.UpChar(charIndex);
                         if ( Round>0) then
                            Field.Set(charIndex, 'ares_flag_L', tonumber( flag_L+1*Round));
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
                  if (wandId == 79010)  then
                      local flag_S = tonumber( Field.Get( player, 'ares_flag_S')) or 0;
                      local flag_A = tonumber( Field.Get( player, 'ares_flag_A')) or 0;
                      local flag_L = tonumber( Field.Get( player, 'ares_flag_L')) or 0;
                      if (Char.ItemSlot(player)<20) then
                          if (flag_S>=50 and flag_A>=50 and flag_L>=50)  then
                              Field.Set(player, 'ares_flag_S', 0);
                              Field.Set(player, 'ares_flag_A', 0);
                              Field.Set(player, 'ares_flag_L', 0);
                              NLG.SystemMessage(player,"[系統]你的武器發出閃耀的星光，外型產生變化！");
                              Char.DelItemBySlot(player, targetSlot);
                              Char.GiveItem(player, 79255, 1);
                          end
                      end
                  elseif (wandId == 79011)  then
                      local flag_S = tonumber( Field.Get( player, 'ares_flag_S')) or 0;
                      local flag_A = tonumber( Field.Get( player, 'ares_flag_A')) or 0;
                      local flag_L = tonumber( Field.Get( player, 'ares_flag_L')) or 0;
                      if (Char.ItemSlot(player)<20) then
                          if (flag_S>=50 and flag_A>=50 and flag_L>=50)  then
                              Field.Set(player, 'ares_flag_S', 0);
                              Field.Set(player, 'ares_flag_A', 0);
                              Field.Set(player, 'ares_flag_L', 0);
                              NLG.SystemMessage(player,"[系統]你的武器發出閃耀的星光，外型產生變化！");
                              Char.DelItemBySlot(player, targetSlot);
                              Char.GiveItem(player, 79256, 1);
                          end
                      end
                  elseif (wandId == 79012)  then
                      local flag_S = tonumber( Field.Get( player, 'ares_flag_S')) or 0;
                      local flag_A = tonumber( Field.Get( player, 'ares_flag_A')) or 0;
                      local flag_L = tonumber( Field.Get( player, 'ares_flag_L')) or 0;
                      if (Char.ItemSlot(player)<20) then
                          if (flag_S>=50 and flag_A>=50 and flag_L>=50)  then
                              Field.Set(player, 'ares_flag_S', 0);
                              Field.Set(player, 'ares_flag_A', 0);
                              Field.Set(player, 'ares_flag_L', 0);
                              NLG.SystemMessage(player,"[系統]你的武器發出閃耀的星光，外型產生變化！");
                              Char.DelItemBySlot(player, targetSlot);
                              Char.GiveItem(player, 79257, 1);
                          end
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