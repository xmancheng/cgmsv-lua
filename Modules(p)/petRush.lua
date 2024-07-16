---ģ����
local Module = ModuleBase:createModule('petRush')

local eventGoal = 600018;
local goalLevel_min = 50;
local goalLevel_max = 70;
local eventLuckyNum = 6;
local eventItemID = {}
eventItemID[1] = {75020,75021,75022,75023}	--A�Ȫ�
eventItemID[2] = {75020,75021,75022,75023}	--B�Ȫ�
eventItemID[3] = {75020,75021,75022,75023}	--C�Ȫ�
eventItemID[4] = {75020,75021,75022,75023}	--D�Ȫ�
------------------------------------------------------------------------------------------------
--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self.bountyNPC = self:NPC_createNormal('���ɉ����p��', 11797, { x = 245, y = 79, mapType = 0, map = 1000, direction = 0 });
  self:NPC_regTalkedEvent(self.bountyNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
          local EnemyDataIndex = Data.EnemyGetDataIndex(eventGoal);		--enemyId
          local enemyBaseId = Data.EnemyGetData(EnemyDataIndex, CONST.Enemy_Base���);
          local EnemyBaseDataIndex = Data.EnemyBaseGetDataIndex(enemyBaseId);	--enemyBaseId
          local eventGoalName = Data.EnemyBaseGetData(EnemyBaseDataIndex, CONST.EnemyBase_����);
          local msg = "�������������������ɉ����ȃ�����ӡ�\\n"
                              .. "�����ڕr�g��2024/07/15 - 2024/08/31\\n"
                              .. "������Ŀ�ˣ�".. eventGoalName .."\\n"
                              .. "�����Ƶȼ���"..goalLevel_min.."-"..goalLevel_max.."\\n\\n"
                              .. "�������淨��������ħ�������������R������\\n"
                              .. "���������ֵ��β�����ώׂ��� "..eventLuckyNum.." �أ�\\n"
                              .. "����4 ����A�����b�O������ʽ�C��\\n"
                              .. "����3 ����B��������������ʽ�C��\\n"
                              .. "����2 ����C�����Ը�����ʽ�C��\\n"
                              .. "����1 ����D�����弉������ʽ�C��\\n";
          NLG.ShowWindowTalked(player, self.bountyNPC, CONST.����_��Ϣ��, CONST.��ť_ȷ���ر�, 1, msg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.bountyNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --print(data)
    if select > 0 then
      if (seqno == 1 and select == CONST.��ť_�ر�) then
                 return;
      elseif (seqno == 1 and select == CONST.��ť_ȷ��)  then
                 local msg = "3|\\n����Č���Ԕ���YӍ��\\n"
                                  .. "���x��Ҫ�������b������Q���p���e�����\\n\\n";
                 for i=0,4 do
                       local pet = Char.GetPet(player,i);
                       if(pet<0)then
                             msg = msg .. "��\\n";
                       else
                             local count = Calcuquant(pet);
                             msg = msg .. ""..Char.GetData(pet,CONST.CHAR_����).."�������ϵ�β���� ".. count .." ��\\n";
                       end
                 end
                 NLG.ShowWindowTalked(player, self.bountyNPC, CONST.����_ѡ���, CONST.BUTTON_�ر�, 11, msg);
      elseif (seqno == 12 and select == CONST.��ť_��)  then
                 return;
      elseif (seqno == 12 and select == CONST.��ť_��) then
          petSlot = petSlot;
          local petIndex = Char.GetPet(player,petSlot);
          local count = Calcuquant(petIndex);
          if (count==0) then
                 NLG.SystemMessage(player, "[ϵ�y]��Ӗ���������f��������һ�ӣ�");
                 return;
          end
          if (petIndex>=0) then
              local count = Calcuquant(petIndex);
              Char.DelSlotPet(player, petSlot);
              if (count==4) then
                 local rand = NLG.Rand(1,#eventItemID[1]);
                 Char.GiveItem(player, eventItemID[1][rand], 1);
                 NLG.Say(player, -1, "[ϵ�y]��ϲ��� "..Char.GetData(player,CONST.����_����).." �������pA�Ȫ���", CONST.��ɫ_��ɫ, CONST.����_��);
              elseif (count==3) then
                 local rand = NLG.Rand(1,#eventItemID[2]);
                 Char.GiveItem(player, eventItemID[2][rand], 1);
                 NLG.Say(player, -1, "[ϵ�y]��ϲ��� "..Char.GetData(player,CONST.����_����).." �������pB�Ȫ���", CONST.��ɫ_��ɫ, CONST.����_��);
              elseif (count==2) then
                 local rand = NLG.Rand(1,#eventItemID[3]);
                 Char.GiveItem(player, eventItemID[3][rand], 1);
                 NLG.Say(player, -1, "[ϵ�y]��ϲ��� "..Char.GetData(player,CONST.����_����).." �������pC�Ȫ���", CONST.��ɫ_��ɫ, CONST.����_��);
              elseif (count==1) then
                 local rand = NLG.Rand(1,#eventItemID[4]);
                 Char.GiveItem(player, eventItemID[4][rand], 1);
                 NLG.Say(player, -1, "[ϵ�y]��ϲ��� "..Char.GetData(player,CONST.����_����).." �������pD�Ȫ���", CONST.��ɫ_��ɫ, CONST.����_��);
              end
          end
      end

    else
      if (seqno == 11 and select == CONST.��ť_�ر�) then
                 return;
      elseif (seqno == 11 and data >= 1) then
          petSlot = data-1;
          local petIndex = Char.GetPet(player,petSlot);
          if (petIndex>=0) then
              local PetId = Char.GetData(petIndex,CONST.PET_PetID);
              local count = Calcuquant(petIndex);
              local goalLevel = Char.GetData(petIndex, CONST.CHAR_�ȼ�);
              if (PetId~=eventGoal) then
                 NLG.SystemMessage(player, "[ϵ�y]�x��Č��ﲻ�Ǒ��pĿ�ˣ�");
                 return;
              end
              if (goalLevel<goalLevel_min) then
                 NLG.SystemMessage(player, "[ϵ�y]����ȼ�δ�_"..goalLevel_min.."��");
                 return;
              elseif (goalLevel>goalLevel_max) then
                 NLG.SystemMessage(player, "[ϵ�y]����ȼ����^"..goalLevel_max.."��");
                 return;
              end
              if (Char.ItemSlot(player)>18) then
                 NLG.SystemMessage(player, "[ϵ�y]Ո���ɸ���Ʒ�ڿ�λ��");
                 return;
              end
              local msg = "\\n@c�����ɉ����ȃ�����ӡ�\\n"
                                  .. "��\\n"
                                  .. "��\\n"
                                  .. "�Ƿ�_��Ҫ�����@�b���\\n"
                                  .. "��\\n"
                                  .. "�����ֵ��β������: ".. count .." ��\\n";
              NLG.ShowWindowTalked(player, self.bountyNPC, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 12, msg);
          else
              return;
          end
      else
                 return;
      end
    end
  end)


end

function Calcuquant(pet)
         local count = 0;
         local maxLp = math.fmod(Char.GetData(pet, CONST.CHAR_���Ѫ)/1, 10);
         local maxFp = math.fmod(Char.GetData(pet, CONST.CHAR_���ħ)/1, 10);
         local Attack = math.fmod(Char.GetData(pet,CONST.CHAR_������)/1, 10);
         local Defense = math.fmod(Char.GetData(pet,CONST.CHAR_������)/1, 10);
         local Agile = math.fmod(Char.GetData(pet,CONST.CHAR_����)/1, 10);
         if (maxLp==eventLuckyNum) then
             count = count+1;
         end
         if (maxFp==eventLuckyNum) then
             count = count+1;
         end
         if (Attack==eventLuckyNum) then
             count = count+1;
         end
         if (Defense==eventLuckyNum) then
             count = count+1;
         end
         if (Agile==eventLuckyNum) then
             count = count+1;
         end
    return count;
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
