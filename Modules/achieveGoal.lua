---ģ����
local Module = ModuleBase:createModule('achieveGoal')

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self))
  self:regCallback('TechOptionEvent', Func.bind(self.OnTechOptionEventCallBack, self))
  self:regCallback('BattleOverEvent', Func.bind(self.OnBattleOverCallBack, self))
end

function Module:handleTalkEvent(charIndex,msg,color,range,size)
	if (msg=="/achieve") then
		local flag_magician = tonumber( Field.Get( charIndex, 'achieve_flag_magician')) or 0;
		local flag_ares = tonumber( Field.Get( charIndex, 'achieve_flag_ares')) or 0;
		local flag_elf = tonumber( Field.Get( charIndex, 'achieve_flag_elf')) or 0;
		local flag_night = tonumber( Field.Get( charIndex, 'achieve_flag_night')) or 0;
		local flag_asura = tonumber( Field.Get( charIndex, 'achieve_flag_asura')) or 0;
		NLG.SystemMessage(charIndex, "���z��"..flag_magician.."/3000����.���¡�"..flag_ares.."/3000����");
		NLG.SystemMessage(charIndex, "���`��"..flag_elf.."/3000����.��Ӱ��"..flag_night.."/3000����");
		NLG.SystemMessage(charIndex, "���_��"..flag_asura"/3000����");
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
            local Round = Battle.GetTurn(battleIndex);
            local symf_round= Char.GetTempData(charIndex, 'ħ���غ�') or 0;
            if (Round==0 or (Round - symf_round)>=1) then
                  local jobs = Char.GetData(charIndex, CONST.����_ְ��ID);
                  if ( jobs==15 or jobs==45 or jobs==75 or jobs==115 or jobs==145) then
                      local flag_magician = tonumber( Field.Get( charIndex, 'achieve_flag_magician')) or 0;
                      local flag_ares = tonumber( Field.Get( charIndex, 'achieve_flag_ares')) or 0;
                      local flag_elf = tonumber( Field.Get( charIndex, 'achieve_flag_elf')) or 0;
                      local flag_night = tonumber( Field.Get( charIndex, 'achieve_flag_night')) or 0;
                      local flag_asura = tonumber( Field.Get( charIndex, 'achieve_flag_asura')) or 0;
                      if (techID == 26709)  then    --����10
                         Char.SetTempData(charIndex, 'ħ���غ�', Round);
                         NLG.UpChar(charIndex);
                         if ( Round>0) then
                            Field.Set(charIndex, 'achieve_flag_magician', tonumber( flag_magician+1));
                         end
                      elseif (techID == 200509)  then    --׷��10
                         Char.SetTempData(charIndex, 'ħ���غ�', Round);
                         NLG.UpChar(charIndex);
                         if ( Round>0) then
                            Field.Set(charIndex, 'achieve_flag_ares', tonumber( flag_ares+1));
                         end
                      elseif (techID == 9509)  then    --����10
                         Char.SetTempData(charIndex, 'ħ���غ�', Round);
                         NLG.UpChar(charIndex);
                         if ( Round>0) then
                            Field.Set(charIndex, 'achieve_flag_elf', tonumber( flag_elf+1));
                         end
                      elseif (techID == 26609)  then    --���10
                         Char.SetTempData(charIndex, 'ħ���غ�', Round);
                         NLG.UpChar(charIndex);
                         if ( Round>0) then
                            Field.Set(charIndex, 'achieve_flag_night', tonumber( flag_night+1));
                         end
                      elseif (techID == 409)  then    --����10
                         Char.SetTempData(charIndex, 'ħ���غ�', Round);
                         NLG.UpChar(charIndex);
                         if ( Round>0) then
                            Field.Set(charIndex, 'achieve_flag_asura', tonumber( flag_asura+1));
                         end
                      end
                  end
            end
      end
      return val
end

function Module:OnBattleOverCallBack(battleIndex)
       for i=0, 9 do
            local charIndex = Battle.GetPlayIndex(battleIndex, i)
            if charIndex>=0 and Char.IsPlayer(charIndex) then
                --�ɾ��ۻ�
                local flag_magician = tonumber( Field.Get( charIndex, 'achieve_flag_magician')) or 0;
                local flag_ares = tonumber( Field.Get( charIndex, 'achieve_flag_ares')) or 0;
                local flag_elf = tonumber( Field.Get( charIndex, 'achieve_flag_elf')) or 0;
                local flag_night = tonumber( Field.Get( charIndex, 'achieve_flag_night')) or 0;
                local flag_asura = tonumber( Field.Get( charIndex, 'achieve_flag_asura')) or 0;
                --�ɾ͵ȼ�
                local flag_magician_level = tonumber( Field.Get( charIndex, 'achieve_flag_magician_level')) or 0;
                local flag_ares_level = tonumber( Field.Get( charIndex, 'achieve_flag_ares_level')) or 0;
                local flag_elf_level = tonumber( Field.Get( charIndex, 'achieve_flag_elf_level')) or 0;
                local flag_night_level = tonumber( Field.Get( charIndex, 'achieve_flag_night_level')) or 0;
                local flag_asura_level = tonumber( Field.Get( charIndex, 'achieve_flag_asura_level')) or 0;
                if (flag_magician>=3000 and flag_magician_level==0)  then
                    Field.Set(charIndex, 'achieve_flag_magician_level', 1);
                    NLG.SystemMessage(charIndex,"[ϵ�y]����I�ɾͣ���������������4�c��");
                    Char.SetData(charIndex, CONST.CHAR_������, Char.GetData(charIndex, CONST.CHAR_������) + 4);
                    NLG.UpChar(charIndex);
                elseif (flag_ares>=3000 and flag_ares_level==0)  then
                    Field.Set(charIndex, 'achieve_flag_ares_level', 1);
                    NLG.SystemMessage(charIndex,"[ϵ�y]����I�ɾͣ���������������4�c��");
                    Char.SetData(charIndex, CONST.CHAR_������, Char.GetData(charIndex, CONST.CHAR_������) + 4);
                    NLG.UpChar(charIndex);
                elseif (flag_elf>=3000 and flag_elf_level==0)  then
                    Field.Set(charIndex, 'achieve_flag_elf_level', 1);
                    NLG.SystemMessage(charIndex,"[ϵ�y]����I�ɾͣ���������������4�c��");
                    Char.SetData(charIndex, CONST.CHAR_������, Char.GetData(charIndex, CONST.CHAR_������) + 4);
                    NLG.UpChar(charIndex);
                elseif (flag_night>=3000 and flag_night_level==0)  then
                    Field.Set(charIndex, 'achieve_flag_night_level', 1);
                    NLG.SystemMessage(charIndex,"[ϵ�y]����I�ɾͣ���������������4�c��");
                    Char.SetData(charIndex, CONST.CHAR_������, Char.GetData(charIndex, CONST.CHAR_������) + 4);
                    NLG.UpChar(charIndex);
                elseif (flag_asura>=3000 and flag_asura_level==0)  then
                    Field.Set(charIndex, 'achieve_flag_asura_level', 1);
                    NLG.SystemMessage(charIndex,"[ϵ�y]����I�ɾͣ���������������4�c��");
                    Char.SetData(charIndex, CONST.CHAR_������, Char.GetData(charIndex, CONST.CHAR_������) + 4);
                    NLG.UpChar(charIndex);
                end
            end
       end
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;