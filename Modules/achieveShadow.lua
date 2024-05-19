---模块类
local Module = ModuleBase:createModule('achieveShadow')

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self))
  self:regCallback('TechOptionEvent', Func.bind(self.OnTechOptionEventCallBack, self))
  self:regCallback('BattleOverEvent', Func.bind(self.OnBattleOverCallBack, self))
end

function Module:handleTalkEvent(charIndex,msg,color,range,size)
	if (msg=="/night") then
		local flag_kunai = tonumber( Field.Get( charIndex, 'night_flag_kunai')) or 0;
		local flag_ninja = tonumber( Field.Get( charIndex, 'night_flag_ninja')) or 0;
		NLG.SystemMessage(charIndex, "裝備[最終型]櫻十，使用200次苦無亂舞Lv10，小刀走向狡猾之路！");
		NLG.SystemMessage(charIndex, "風遁．旋風刃【"..flag_kunai.."/200】次");
		NLG.SystemMessage(charIndex, "裝備[最終型]木枯，使用200次忍刀亂舞Lv10，迴力鏢走向奸智之路！");
		NLG.SystemMessage(charIndex, "水遁．水刃斬【"..flag_ninja.."/200】次");
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
                      local flag_kunai = tonumber( Field.Get( charIndex, 'night_flag_kunai')) or 0;
                      local flag_ninja = tonumber( Field.Get( charIndex, 'night_flag_ninja')) or 0;
                      if (techID == 25719 and wandId == 79055)  then
                         Char.SetTempData(charIndex, '魔法回合', Round);
                         NLG.UpChar(charIndex);
                         if ( Round>0) then
                            Field.Set(charIndex, 'night_flag_kunai', tonumber( flag_kunai+1*Round));
                         end
                      elseif (techID == 119 and wandId == 79056)  then
                            Char.SetTempData(charIndex, '魔法回合', Round);
                            NLG.UpChar(charIndex);
                         if ( Round>0) then
                            Field.Set(charIndex, 'night_flag_ninja', tonumber( flag_ninja+1*Round));
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
                  if (wandId == 79055)  then
                      local flag_kunai = tonumber( Field.Get( player, 'night_flag_kunai')) or 0;
                      if (Char.ItemSlot(player)<20) then
                          if (flag_kunai>=200)  then
                              Field.Set(player, 'night_flag_kunai', 0);
                              NLG.SystemMessage(player,"[系統]你的武器發出閃耀的星光，外型產生變化！");
                              Char.DelItemBySlot(player, targetSlot);
                              Char.GiveItem(player, 79252, 1);
                          end
                      end
                  elseif (wandId == 79056)  then
                      local flag_ninja = tonumber( Field.Get( player, 'night_flag_ninja')) or 0;
                      if (Char.ItemSlot(player)<20) then
                          if (flag_ninja>=200)  then
                              Field.Set(player, 'night_flag_ninja', 0);
                              NLG.SystemMessage(player,"[系統]你的武器發出閃耀的星光，外型產生變化！");
                              Char.DelItemBySlot(player, targetSlot);
                              Char.GiveItem(player, 79253, 1);
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