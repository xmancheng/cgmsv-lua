---ģ����
local Module = ModuleBase:createModule('petRush')

--local eventGoal = 600018;
local goalLevel_min = 30;
local goalLevel_max = 40;
local eventLuckyNum = 3;
local eventGoal_check= {500000,500001,500002,500003,500004,500005,500006,500007,500008,
                        500010,500011,500012,500014,500015,500016,500017,500018,
                        500020,500021,500022,500023,500024,500025,500026,500029,
                        500031,500033,500036,500037,500040,500042,500043,500044,500046,
                        500048,500049,500052,500053,
};

--local eventTechID = {}
--eventTechID[1] = {9630,9631,9632,9633,9634,9635,9636,9637,9638,9639}	--A�Ȫ�
--eventTechID[2] = {9640,9641,9642,9643,9644,9645,9646,9647,9648,9649}	--B�Ȫ�
--eventTechID[3] = {9610,9619,9620,9621,9622,9623,9624,9625,9626,9627,9628,9629}	--C�Ȫ�
--eventTechID[4] = {9611,9612,9613,9614,9615,9616,9617,9618,404,200504}	--D�Ȫ�
------------------------------------------------------------------------------------------------
--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self.bountyNPC = self:NPC_createNormal('���ɉ����p��', 11797, { x = 245, y = 83, mapType = 0, map = 1000, direction = 0 });
  self:NPC_regTalkedEvent(self.bountyNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
          local EnemyDataIndex = Data.EnemyGetDataIndex(eventGoal);		--enemyId
          local enemyBaseId = Data.EnemyGetData(EnemyDataIndex, CONST.Enemy_Base���);
          local EnemyBaseDataIndex = Data.EnemyBaseGetDataIndex(enemyBaseId);	--enemyBaseId
          local eventGoalName = Data.EnemyBaseGetData(EnemyBaseDataIndex, CONST.EnemyBase_����);
          local msg = "�������������������ɉ����ȃ�����ӡ�\\n"
                              .. "�����ڕr�g��2024/11/30 - 2025/12/31\\n"
                              .. "������Ŀ�ˣ����ׁ���ꑌ��ɉ�\\n"
                              .. "�����Ƶȼ���"..goalLevel_min.."-"..goalLevel_max.."\\n"
                              .. "�������淨��������ħ�������������R������\\n"
                              .. "���������ֵ��β�����ώׂ��� "..eventLuckyNum.." �أ�\\n"
                              .. "����4 ����A��.���C�{��e�֡�250��\\n"
                              .. "����3 ����B��.���C�{��e�֡�150��\\n"
                              .. "����2 ����C��.���C�{��e�֡�50��\\n"
                              .. "����1 ����D��.ħ��s�䡾1��\\n";
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
              --local newSlot = Char.GetEmptyItemSlot(player);
              if (count==4) then
                 --local rand = NLG.Rand(1,#eventTechID[1]);
                 --local techId = eventTechID[1][rand];
                 --local techIndex = Tech.GetTechIndex(techId);
                 --local techName = Tech.GetData(techIndex, CONST.TECH_NAME);
                 Char.GiveItem(player, 68999, 250);
                 --local MacIndex = Char.GetItemIndex(player,newSlot);
                 --Item.SetData(MacIndex, CONST.����_����, "[".. techName .."]��ʽ�W���C");
                 --Item.SetData(MacIndex, CONST.����_�Ӳ�һ, techId);
                 --Item.UpItem(player, newSlot);
                 --NLG.UpChar(player);
                 NLG.Say(player, -1, "[ϵ�y]��ϲ��� "..Char.GetData(player,CONST.����_����).." �������pA�Ȫ���", CONST.��ɫ_��ɫ, CONST.����_��);
              elseif (count==3) then
                 --local rand = NLG.Rand(1,#eventTechID[2]);
                 --local techId = eventTechID[2][rand];
                 --local techIndex = Tech.GetTechIndex(techId);
                 --local techName = Tech.GetData(techIndex, CONST.TECH_NAME);
                 Char.GiveItem(player, 68999, 150);
                 --local MacIndex = Char.GetItemIndex(player,newSlot);
                 --Item.SetData(MacIndex, CONST.����_����, "[".. techName .."]��ʽ�W���C");
                 --Item.SetData(MacIndex, CONST.����_�Ӳ�һ, techId);
                 --Item.UpItem(player, newSlot);
                 --NLG.UpChar(player);
                 NLG.Say(player, -1, "[ϵ�y]��ϲ��� "..Char.GetData(player,CONST.����_����).." �������pB�Ȫ���", CONST.��ɫ_��ɫ, CONST.����_��);
              elseif (count==2) then
                 --local rand = NLG.Rand(1,#eventTechID[3]);
                 --local techId = eventTechID[3][rand];
                 --local techIndex = Tech.GetTechIndex(techId);
                 --local techName = Tech.GetData(techIndex, CONST.TECH_NAME);
                 Char.GiveItem(player, 68999, 50);
                 --local MacIndex = Char.GetItemIndex(player,newSlot);
                 --Item.SetData(MacIndex, CONST.����_����, "[".. techName .."]��ʽ�W���C");
                 --Item.SetData(MacIndex, CONST.����_�Ӳ�һ, techId);
                 --Item.UpItem(player, newSlot);
                 --NLG.UpChar(player);
                 NLG.Say(player, -1, "[ϵ�y]��ϲ��� "..Char.GetData(player,CONST.����_����).." �������pC�Ȫ���", CONST.��ɫ_��ɫ, CONST.����_��);
              elseif (count==1) then
                 --local rand = NLG.Rand(1,#eventTechID[4]);
                 --local techId = eventTechID[4][rand];
                 --local techIndex = Tech.GetTechIndex(techId);
                 --local techName = Tech.GetData(techIndex, CONST.TECH_NAME);
                 Char.GiveItem(player, 70200, 1);
                 --local MacIndex = Char.GetItemIndex(player,newSlot);
                 --Item.SetData(MacIndex, CONST.����_����, "[".. techName .."]��ʽ�W���C");
                 --Item.SetData(MacIndex, CONST.����_�Ӳ�һ, techId);
                 --Item.UpItem(player, newSlot);
                 --NLG.UpChar(player);
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
              --if (PetId~=eventGoal) then
              if (CheckInTable(GetitEnable_check,PetId)==false) then
                 NLG.SystemMessage(player, "[ϵ�y]�x��Č��ﲻ�Ǒ��pĿ�ˣ�");
                 return;
              end
              if (Char.GetData(petIndex,CONST.����_������)~=0) then
                 NLG.SystemMessage(player, "[ϵ�y]�x��Č��������c��δ�c�ꮅ��");
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

function Char.GetEmptyItemSlot(charIndex)
  if not Char.IsValidCharIndex(charIndex) then
    return -1;
  end
  if Char.GetData(charIndex, CONST.CHAR_����) ~= CONST.��������_�� then
    return -1;
  end
  for i = 8, 27 do
    if Char.GetItemIndex(charIndex, i) == -2 then
      return i;
    end
  end
  return -2;
end

function CheckInTable(_idTab, _idVar) ---ѭ������
	for k,v in pairs(_idTab) do
		if v==_idVar then
			return true
		end
	end
	return false
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
