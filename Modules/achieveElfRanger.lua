---ģ����
local Module = ModuleBase:createModule('achieveElfRanger')

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self))
  self:regCallback('TechOptionEvent', Func.bind(self.OnTechOptionEventCallBack, self))
  self:regCallback('BattleOverEvent', Func.bind(self.OnBattleOverCallBack, self))
end

function Module:handleTalkEvent(charIndex,msg,color,range,size)
	if (msg=="/elf") then
		local flag_clean = tonumber( Field.Get( charIndex, 'elf_flag_clean')) or 0;
		local flag_recover = tonumber( Field.Get( charIndex, 'elf_flag_recover')) or 0;
		NLG.SystemMessage(charIndex, "�b��[��K��]���꣬ʹ��50�Ν��Qħ��Lv10����������`֮·��");
		NLG.SystemMessage(charIndex, "���}֮�⡾"..flag_clean.."/50����");
		NLG.SystemMessage(charIndex, "�b��[��K��]���꣬ʹ��50�λ֏�ħ��Lv10����ڰ����`֮·��");
		NLG.SystemMessage(charIndex, "�����g��"..flag_recover.."/50����");
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
            local WeaponIndex = Char.GetWeapon(charIndex);
            local Round = Battle.GetTurn(battleIndex);
            local symf_round= Char.GetTempData(charIndex, 'ħ���غ�') or 0;
            if (WeaponIndex>0) then
                  local wandId = Item.GetData(WeaponIndex, CONST.����_ID);
                  if ( Round==0 or (Round - symf_round)>=1) then
	local flag_clean = tonumber( Field.Get( charIndex, 'elf_flag_clean')) or 0;
	local flag_recover = tonumber( Field.Get( charIndex, 'elf_flag_recover')) or 0;
                      if (techID == 6709 and wandId == 79054)  then    --װ��[������]����ʹ�ýྻLv10
                         Char.SetTempData(charIndex, 'ħ���غ�', Round);
                         NLG.UpChar(charIndex);
                         if ( Round>0) then
                            Field.Set(charIndex, 'elf_flag_clean', tonumber( flag_clean+1*Round));
                         end
                      elseif (techID == 6409 and wandId == 79054)  then    --װ��[������]����ʹ�õ���Lv10
                            Char.SetTempData(charIndex, 'ħ���غ�', Round);
                            NLG.UpChar(charIndex);
                         if ( Round>0) then
                            Field.Set(charIndex, 'elf_flag_recover', tonumber( flag_recover+1*Round));
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
                  local wandId = Item.GetData(WeaponIndex, CONST.����_ID);
                  if (wandId == 79054)  then
                      local flag_clean = tonumber( Field.Get( player, 'elf_flag_clean')) or 0;
                      local flag_recover = tonumber( Field.Get( player, 'elf_flag_recover')) or 0;
                      if (Char.ItemSlot(player)<20) then
                          if (flag_clean>=50 and flag_recover<50)  then
                              Field.Set(player, 'elf_flag_clean', 0);
                              Field.Set(player, 'elf_flag_recover', 0);
                              NLG.SystemMessage(player,"[ϵ�y]��������l���Wҫ���ǹ⣬���ͮa��׃����");
                              Char.DelItemBySlot(player, targetSlot);
                              Char.GiveItem(player, 79250, 1);
                          elseif (flag_recover>=50 and flag_clean<50)  then
                              Field.Set(player, 'elf_flag_clean', 0);
                              Field.Set(player, 'elf_flag_recover', 0);
                              NLG.SystemMessage(player,"[ϵ�y]��������l���Wҫ���ǹ⣬���ͮa��׃����");
                              Char.DelItemBySlot(player, targetSlot);
                              Char.GiveItem(player, 79251, 1);
                          end
                      end
                  end
                end
            end
       end
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;