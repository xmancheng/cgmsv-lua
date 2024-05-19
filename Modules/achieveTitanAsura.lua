---模块类
local Module = ModuleBase:createModule('achieveTitanAsura')

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self))
  self:regCallback('TechOptionEvent', Func.bind(self.OnTechOptionEventCallBack, self))
  self:regCallback('BattleOverEvent', Func.bind(self.OnBattleOverCallBack, self))
end

function Module:handleTalkEvent(charIndex,msg,color,range,size)
	if (msg=="/asura") then
		local flag_asura = tonumber( Field.Get( charIndex, 'titan_flag_asura')) or 0;
		local flag_rakshasa = tonumber( Field.Get( charIndex, 'titan_flag_rakshasa')) or 0;
		NLG.SystemMessage(charIndex, "裝備[最終型]閻魔，使用阿修羅霸凰拳、羅剎破凰擊，每項技能100次走向鐵拳之路！");
		NLG.SystemMessage(charIndex, "阿修羅霸凰拳【"..flag_asura.."/100】次.羅剎破凰擊【"..flag_rakshasa.."/100】次");
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
            --local WeaponIndex = Char.GetWeapon(charIndex);
            local ShieldIndex = Char.GetShield(charIndex);
            local Round = Battle.GetTurn(battleIndex);
            local symf_round= Char.GetTempData(charIndex, '魔法回合') or 0;
            if (ShieldIndex>0) then
                  local wandId = Item.GetData(ShieldIndex, CONST.道具_ID);
                  if ( Round==0 or (Round - symf_round)>=1) then
                      local flag_asura = tonumber( Field.Get( charIndex, 'titan_flag_asura')) or 0;
                      local flag_rakshasa = tonumber( Field.Get( charIndex, 'titan_flag_rakshasa')) or 0;
                      if (techID == 529 and wandId == 79057)  then
                         Char.SetTempData(charIndex, '魔法回合', Round);
                         NLG.UpChar(charIndex);
                         if ( Round>0) then
                            Field.Set(charIndex, 'titan_flag_asura', tonumber( flag_asura+1*Round));
                         end
                      elseif (techID == 629 and wandId == 79057)  then
                            Char.SetTempData(charIndex, '魔法回合', Round);
                            NLG.UpChar(charIndex);
                         if ( Round>0) then
                            Field.Set(charIndex, 'titan_flag_rakshasa', tonumber( flag_rakshasa+1*Round));
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
                --local WeaponIndex,targetSlot = Char.GetWeapon(player);
                local ShieldIndex,targetSlot = Char.GetShield(player);
                if (ShieldIndex>0) then
                  local wandId = Item.GetData(ShieldIndex, CONST.道具_ID);
                  if (wandId == 79057)  then
                      local flag_asura = tonumber( Field.Get( player, 'titan_flag_asura')) or 0;
                      local flag_rakshasa = tonumber( Field.Get( player, 'titan_flag_rakshasa')) or 0;
                      if (Char.ItemSlot(player)<20) then
                          if (flag_asura>=100 and flag_rakshasa>=100)  then
                              Field.Set(player, 'titan_flag_asura', 0);
                              Field.Set(player, 'titan_flag_rakshasa', 0);
                              NLG.SystemMessage(player,"[系統]你的武器發出閃耀的星光，外型產生變化！");
                              Char.DelItemBySlot(player, targetSlot);
                              Char.GiveItem(player, 79254, 1);
                          end
                      end
                  end
                end
            end
       end
end

Char.GetShield = function(charIndex)
  local ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_左手);
  if ItemIndex >= 0 and Item.GetData(ItemIndex, CONST.道具_类型)==CONST.ITEM_TYPE_盾 then
    return ItemIndex,CONST.EQUIP_左手;
  end
  ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_右手)
  if ItemIndex >= 0 and Item.GetData(ItemIndex, CONST.道具_类型)==CONST.ITEM_TYPE_盾 then
    return ItemIndex,CONST.EQUIP_右手;
  end
  return -1,-1;
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;