---ģ����
local Module = ModuleBase:createModule('achieveTitanAsura')

--- ����ģ�鹳��
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
		NLG.SystemMessage(charIndex, "�b��[��K��]�ħ��ʹ�ð����_�Ի�ȭ���_�x�ƻ˓���ÿ헼���100�������Fȭ֮·��");
		NLG.SystemMessage(charIndex, "�����_�Ի�ȭ��"..flag_asura.."/100����.�_�x�ƻ˓���"..flag_rakshasa.."/100����");
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
            if Char.GetData(leader2, CONST.CHAR_����) == CONST.��������_�� then
                  leader = leader2
            end
            --local WeaponIndex = Char.GetWeapon(charIndex);
            local ShieldIndex = Char.GetShield(charIndex);
            local Round = Battle.GetTurn(battleIndex);
            local symf_round= Char.GetTempData(charIndex, 'ħ���غ�') or 0;
            if (ShieldIndex>0) then
                  local wandId = Item.GetData(ShieldIndex, CONST.����_ID);
                  if ( Round==0 or (Round - symf_round)>=1) then
                      local flag_asura = tonumber( Field.Get( charIndex, 'titan_flag_asura')) or 0;
                      local flag_rakshasa = tonumber( Field.Get( charIndex, 'titan_flag_rakshasa')) or 0;
                      if (techID == 529 and wandId == 79057)  then
                         Char.SetTempData(charIndex, 'ħ���غ�', Round);
                         NLG.UpChar(charIndex);
                         if ( Round>0) then
                            Field.Set(charIndex, 'titan_flag_asura', tonumber( flag_asura+1*Round));
                         end
                      elseif (techID == 629 and wandId == 79057)  then
                            Char.SetTempData(charIndex, 'ħ���غ�', Round);
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
                  local wandId = Item.GetData(ShieldIndex, CONST.����_ID);
                  if (wandId == 79057)  then
                      local flag_asura = tonumber( Field.Get( player, 'titan_flag_asura')) or 0;
                      local flag_rakshasa = tonumber( Field.Get( player, 'titan_flag_rakshasa')) or 0;
                      if (Char.ItemSlot(player)<20) then
                          if (flag_asura>=100 and flag_rakshasa>=100)  then
                              Field.Set(player, 'titan_flag_asura', 0);
                              Field.Set(player, 'titan_flag_rakshasa', 0);
                              NLG.SystemMessage(player,"[ϵ�y]��������l���Wҫ���ǹ⣬���ͮa��׃����");
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
  local ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_����);
  if ItemIndex >= 0 and Item.GetData(ItemIndex, CONST.����_����)==CONST.ITEM_TYPE_�� then
    return ItemIndex,CONST.EQUIP_����;
  end
  ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_����)
  if ItemIndex >= 0 and Item.GetData(ItemIndex, CONST.����_����)==CONST.ITEM_TYPE_�� then
    return ItemIndex,CONST.EQUIP_����;
  end
  return -1,-1;
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;