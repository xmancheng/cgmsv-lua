---ģ����
local Module = ModuleBase:createModule('achieveShadow')

--- ����ģ�鹳��
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
		NLG.SystemMessage(charIndex, "�b��[��K��]��ʮ��ʹ��200�ο��o�y��Lv10��С������ƻ�֮·��");
		NLG.SystemMessage(charIndex, "�L�ݣ����L�С�"..flag_kunai.."/200����");
		NLG.SystemMessage(charIndex, "�b��[��K��]ľ�ݣ�ʹ��200���̵��y��Lv10��ޒ���S�������֮·��");
		NLG.SystemMessage(charIndex, "ˮ�ݣ�ˮ�Дء�"..flag_ninja.."/200����");
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
                      local flag_kunai = tonumber( Field.Get( charIndex, 'night_flag_kunai')) or 0;
                      local flag_ninja = tonumber( Field.Get( charIndex, 'night_flag_ninja')) or 0;
                      if (techID == 25719 and wandId == 79055)  then
                         Char.SetTempData(charIndex, 'ħ���غ�', Round);
                         NLG.UpChar(charIndex);
                         if ( Round>0) then
                            Field.Set(charIndex, 'night_flag_kunai', tonumber( flag_kunai+1*Round));
                         end
                      elseif (techID == 119 and wandId == 79056)  then
                            Char.SetTempData(charIndex, 'ħ���غ�', Round);
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
                  local wandId = Item.GetData(WeaponIndex, CONST.����_ID);
                  if (wandId == 79055)  then
                      local flag_kunai = tonumber( Field.Get( player, 'night_flag_kunai')) or 0;
                      if (Char.ItemSlot(player)<20) then
                          if (flag_kunai>=200)  then
                              Field.Set(player, 'night_flag_kunai', 0);
                              NLG.SystemMessage(player,"[ϵ�y]��������l���Wҫ���ǹ⣬���ͮa��׃����");
                              Char.DelItemBySlot(player, targetSlot);
                              Char.GiveItem(player, 79252, 1);
                          end
                      end
                  elseif (wandId == 79056)  then
                      local flag_ninja = tonumber( Field.Get( player, 'night_flag_ninja')) or 0;
                      if (Char.ItemSlot(player)<20) then
                          if (flag_ninja>=200)  then
                              Field.Set(player, 'night_flag_ninja', 0);
                              NLG.SystemMessage(player,"[ϵ�y]��������l���Wҫ���ǹ⣬���ͮa��׃����");
                              Char.DelItemBySlot(player, targetSlot);
                              Char.GiveItem(player, 79253, 1);
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