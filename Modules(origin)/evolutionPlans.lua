---ģ����
local Module = ModuleBase:createModule(evolutionPlans)

--�����������
local evolution_plan_name = {};
local evolution_plan_offering = {};
local evolution_plan_item = {};
local evolution_plan_gold = {};
local evolution_plan_pet = {};
local evolution_plan_requirement = {};
local evolution_plan_tech = {};
--
evolution_plan_name[1] = "���M���������";
evolution_plan_offering[1] = 406198;
evolution_plan_item[1] = 74095;
evolution_plan_gold[1] = 5000;
evolution_plan_pet[1] = 406199;
evolution_plan_requirement[1] = {{CONST.����_�ȼ�,50}, {CONST.����_������,5}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[1] = 310007;

evolution_plan_name[2] = "���M����������";
evolution_plan_offering[2] = 406199;
evolution_plan_item[2] = 74096;
evolution_plan_gold[2] = 15000;
evolution_plan_pet[2] = 406200;
evolution_plan_requirement[2] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[2] = 310008;

evolution_plan_name[3] = "���M��������������X";
evolution_plan_offering[3] = 406200;
evolution_plan_item[3] = 74097;
evolution_plan_gold[3] = 50000;
evolution_plan_pet[3] = 406201;
evolution_plan_requirement[3] = {{CONST.����_�ȼ�,100}, {CONST.����_������,20}, {CONST.����_�˺���,500}, {CONST.����_ɱ����,200}};
evolution_plan_tech[3] = 310005;

evolution_plan_name[4] = "���M��������������Y";
evolution_plan_offering[4] = 406200;
evolution_plan_item[4] = 74097;
evolution_plan_gold[4] = 50000;
evolution_plan_pet[4] = 406202;
evolution_plan_requirement[4] = {{CONST.����_�ȼ�,100}, {CONST.����_������,10}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[4] = 310008;

evolution_plan_name[5] = "���M�������ܲ�";
evolution_plan_offering[5] = 406203;
evolution_plan_item[5] = 74095;
evolution_plan_gold[5] = 5000;
evolution_plan_pet[5] = 406204;
evolution_plan_requirement[5] = {{CONST.����_�ȼ�,50}, {CONST.����_������,5}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[5] = 310107;

evolution_plan_name[6] = "���M�������ܻ�";
evolution_plan_offering[6] = 406204;
evolution_plan_item[6] = 74096;
evolution_plan_gold[6] = 15000;
evolution_plan_pet[6] = 406205;
evolution_plan_requirement[6] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[6] = 310108;

evolution_plan_name[7] = "���M�����������ܻ�";
evolution_plan_offering[7] = 406205;
evolution_plan_item[7] = 74097;
evolution_plan_gold[7] = 50000;
evolution_plan_pet[7] = 406206;
evolution_plan_requirement[7] = {{CONST.����_�ȼ�,100}, {CONST.����_������,10}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[7] = 310105;

evolution_plan_name[8] = "���M����������";
evolution_plan_offering[8] = 406207;
evolution_plan_item[8] = 74095;
evolution_plan_gold[8] = 5000;
evolution_plan_pet[8] = 406208;
evolution_plan_requirement[8] = {{CONST.����_�ȼ�,50}, {CONST.����_������,5}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[8] = 310101;

evolution_plan_name[9] = "���M����ˮ����";
evolution_plan_offering[9] = 406208;
evolution_plan_item[9] = 74096;
evolution_plan_gold[9] = 15000;
evolution_plan_pet[9] = 406209;
evolution_plan_requirement[9] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[9] = 310102;

evolution_plan_name[10] = "���M��������ˮ����";
evolution_plan_offering[10] = 406209;
evolution_plan_item[10] = 74097;
evolution_plan_gold[10] = 50000;
evolution_plan_pet[10] = 406210;
evolution_plan_requirement[10] = {{CONST.����_�ȼ�,100}, {CONST.����_������,10}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[10] = 310105;

evolution_plan_name[11] = "���˻���Ƥ��";
evolution_plan_offering[11] = 406212;
evolution_plan_item[11] = 74094;
evolution_plan_gold[11] = 5000;
evolution_plan_pet[11] = 406211;
evolution_plan_requirement[11] = {{CONST.����_�ȼ�,30}, {CONST.����_������,50}, {CONST.����_�˺���,10}, {CONST.����_ɱ����,10}};
evolution_plan_tech[11] = 310109;

evolution_plan_name[12] = "���M��������";
evolution_plan_offering[12] = 406212;
evolution_plan_item[12] = 74096;
evolution_plan_gold[12] = 15000;
evolution_plan_pet[12] = 406213;
evolution_plan_requirement[12] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[12] = 310010;

evolution_plan_name[13] = "���M�����M������";
evolution_plan_offering[13] = 406213;
evolution_plan_item[13] = 74097;
evolution_plan_gold[13] = 50000;
evolution_plan_pet[13] = 406214;
evolution_plan_requirement[13] = {{CONST.����_�ȼ�,100}, {CONST.����_������,10}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[13] = 310011;

evolution_plan_name[14] = "���M�����ȱ��B";
evolution_plan_offering[14] = 406226;
evolution_plan_item[14] = 74094;
evolution_plan_gold[14] = 5000;
evolution_plan_pet[14] = 406227;
evolution_plan_requirement[14] = {{CONST.����_�ȼ�,50}, {CONST.����_������,5}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[14] = 310107;

evolution_plan_name[15] = "���M������������B";
evolution_plan_offering[15] = 406227;
evolution_plan_item[15] = 74097;
evolution_plan_gold[15] = 50000;
evolution_plan_pet[15] = 406228;
evolution_plan_requirement[15] = {{CONST.����_�ȼ�,100}, {CONST.����_������,10}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[15] = 310108;

evolution_plan_name[16] = "���˻���������";
evolution_plan_offering[16] = 406230;
evolution_plan_item[16] = 74094;
evolution_plan_gold[16] = 5000;
evolution_plan_pet[16] = 406229;
evolution_plan_requirement[16] = {{CONST.����_�ȼ�,30}, {CONST.����_������,50}, {CONST.����_�˺���,10}, {CONST.����_ɱ����,10}};
evolution_plan_tech[16] = 310100;

evolution_plan_name[17] = "���M�����ֿɶ�";
evolution_plan_offering[17] = 406230;
evolution_plan_item[17] = 74096;
evolution_plan_gold[17] = 15000;
evolution_plan_pet[17] = 406231;
evolution_plan_requirement[17] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[17] = 310004;

evolution_plan_name[18] = "���M����������";
evolution_plan_offering[18] = 406274;
evolution_plan_item[18] = 74095;
evolution_plan_gold[18] = 5000;
evolution_plan_pet[18] = 406275;
evolution_plan_requirement[18] = {{CONST.����_�ȼ�,50}, {CONST.����_������,5}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[18] = 310110;

evolution_plan_name[19] = "���M����������";
evolution_plan_offering[19] = 406274;
evolution_plan_item[19] = 74096;
evolution_plan_gold[19] = 15000;
evolution_plan_pet[19] = 406276;
evolution_plan_requirement[19] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[19] = 310111;

evolution_plan_name[20] = "���M����荽�Ϭ�F";
evolution_plan_offering[20] = 406278;
evolution_plan_item[20] = 74095;
evolution_plan_gold[20] = 5000;
evolution_plan_pet[20] = 406279;
evolution_plan_requirement[20] = {{CONST.����_�ȼ�,50}, {CONST.����_������,5}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[20] = 310104;

evolution_plan_name[21] = "���M�������׿�Ϭ";
evolution_plan_offering[21] = 406279;
evolution_plan_item[21] = 74096;
evolution_plan_gold[21] = 15000;
evolution_plan_pet[21] = 406280;
evolution_plan_requirement[21] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[21] = 310105;

evolution_plan_name[22] = "���M������ɽ��";
evolution_plan_offering[22] = 406290;
evolution_plan_item[22] = 74095;
evolution_plan_gold[22] = 10000;
evolution_plan_pet[22] = 406291;
evolution_plan_requirement[22] = {{CONST.����_�ȼ�,60}, {CONST.����_������,10}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,200}};
evolution_plan_tech[22] = 310104;

evolution_plan_name[23] = "���M��������";
evolution_plan_offering[23] = 406332;
evolution_plan_item[23] = 74095;
evolution_plan_gold[23] = 5000;
evolution_plan_pet[23] = 406333;
evolution_plan_requirement[23] = {{CONST.����_�ȼ�,50}, {CONST.����_������,5}, {CONST.����_�˺���,200}, {CONST.����_ɱ����,100}};
evolution_plan_tech[23] = 310001;

evolution_plan_name[24] = "���M��������";
evolution_plan_offering[24] = 406333;
evolution_plan_item[24] = 74096;
evolution_plan_gold[24] = 15000;
evolution_plan_pet[24] = 406334;
evolution_plan_requirement[24] = {{CONST.����_�ȼ�,70}, {CONST.����_������,5}, {CONST.����_�˺���,250}, {CONST.����_ɱ����,200}};
evolution_plan_tech[24] = 310002;

-------------------------------------------------
local function calcWarp()
  local page = math.modf(#evolution_plan_name / 8) + 1
  local remainder = math.fmod(#evolution_plan_name, 8)
  return page, remainder
end

--Զ�̰�ťUI����
function Module:evolutionPlansInfo(npc, player)
          local winButton = CONST.BUTTON_�ر�;
          local msg = "1\\n�����������������������M���A�[��\\n"
          for i = 1,8 do
             msg = msg .. "�������Ŀ "..i.."��".. evolution_plan_name[i] .. "\\n"
             if (i>=8) then
                 winButton = CONST.BUTTON_��ȡ��;
             end
          end
          NLG.ShowWindowTalked(player, self.evolutionerNPC, CONST.����_ѡ���, winButton, 1, msg);
end

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load');
  self.evolutionerNPC = self:NPC_createNormal('�����M������', 14682, { x = 38, y = 32, mapType = 0, map = 777, direction = 6 });
  self:NPC_regWindowTalkedEvent(self.evolutionerNPC, function(npc, player, _seqno, _select, _data)
    local column = tonumber(_data)
    local page = tonumber(_seqno)
    local warpPage = page;
    local winMsg = "1\\n�����������������������M���A�[��\\n"
    local winButton = CONST.BUTTON_�ر�;
    local totalPage, remainder = calcWarp()
    --��ҳ16 ��ҳ32 �ر�/ȡ��2
    if _select > 0 then
      if _select == CONST.��ť_ȷ�� then
          if (page>=1001) then
              local seqno = page - 1000;
              local msg = "�����������������������M���A�[��\\n"
              local msg = msg .. evolutionOfferingInfo(seqno)
              NLG.ShowWindowTalked(player, self.evolutionerNPC, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 2000+seqno, msg);
              return
          else
              return
          end
      elseif _select == CONST.��ť_�ر� then
          if (page>=1001) then
              local winButton = CONST.BUTTON_�ر�;
              local msg = "1\\n�����������������������M���A�[��\\n"
              for i = 1,8 do
                 msg = msg .. "�������Ŀ "..i.."��".. evolution_plan_name[i] .. "\\n"
                 if (i>=8) then
                     winButton = CONST.BUTTON_��ȡ��;
                 end
              end
              NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, winButton, 1, msg);
              return
          else
              return
          end
      elseif _select == CONST.��ť_�� then
          if (page>=2001) then
              local seqno = page - 2000;
              local petSlot = Char.HavePet(player, evolution_plan_offering[seqno])
              evolutionMutation(seqno,player,petSlot)
              return
          else
              return
          end
      elseif _select == CONST.��ť_�� then
          if (page>=2001) then
              local count = page - 2000;
              local msg = "�����������������������M���A�[��\\n"
              local msg = msg .. convertGoalInfo(count);
              NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.��ť_ȷ���ر�, 1000+count, msg);
              return
          else
              return
          end
      end
      if _select == CONST.BUTTON_��һҳ then
        warpPage = warpPage + 1
        if (warpPage == totalPage) or ((warpPage == (totalPage - 1) and remainder == 0)) then
          winButton = CONST.BUTTON_��ȡ��
        else
          winButton = CONST.BUTTON_����ȡ��
        end
      elseif _select == CONST.BUTTON_��һҳ then
        warpPage = warpPage - 1
        if warpPage == 1 then
          winButton = CONST.BUTTON_��ȡ��
        else
          winButton = CONST.BUTTON_����ȡ��
        end
      elseif _select == 2 then
        warpPage = 1
        return
      end
      local count = 8 * (warpPage - 1)
      if warpPage == totalPage then
        for i = 1 + count, remainder + count do
            winMsg = winMsg .. "�������Ŀ "..i.."��".. evolution_plan_name[i] .. "\\n"
        end
      else
        for i = 1 + count, 8 + count do
            winMsg = winMsg .. "�������Ŀ "..i.."��".. evolution_plan_name[i] .. "\\n"
        end
      end
      NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, winButton, warpPage, winMsg);
    else
      local count = 8 * (warpPage - 1) + column
      --print(count)
      local msg = "�����������������������M���A�[��\\n"
      local msg = msg .. convertGoalInfo(count);
      NLG.ShowWindowTalked(player, self.evolutionerNPC, CONST.����_��Ϣ��, CONST.��ť_ȷ���ر�, 1000+count, msg);
    end
  end)
  self:NPC_regTalkedEvent(self.evolutionerNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local winButton = CONST.BUTTON_�ر�;
      local msg = "1\\n�����������������������M���A�[��\\n"
      for i = 1,8 do
         msg = msg .. "�������Ŀ "..i.."��".. evolution_plan_name[i] .. "\\n"
         if (i>=8) then
             winButton = CONST.BUTTON_��ȡ��;
         end
      end
      NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, winButton, 1, msg);
    end
    return
  end)
end

---------------------------------------------------------------------------------------------------------------
--Ŀ����Ϣ
function convertGoalInfo(count)
      local EnemyDataIndex_Goal = Data.EnemyGetDataIndex(evolution_plan_pet[count]);
      local enemyBaseId_Goal = Data.EnemyGetData(EnemyDataIndex_Goal, CONST.Enemy_Base���);
      local EnemyBaseDataIndex_Goal = Data.EnemyBaseGetDataIndex(enemyBaseId_Goal);
      local Goal_name = Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_����);
      local Goal_DataPos_3 = Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_����);
      local Goal_DataPos_3 = Tribe(Goal_DataPos_3);
      local Goal_DataPos_4 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_����);
      local Goal_DataPos_5 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_����);
      local Goal_DataPos_6 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_ǿ��);
      local Goal_DataPos_7 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_�ٶ�);
      local Goal_DataPos_8 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, 8);
      local Goal_DataPos_12 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_����);
      local Goal_DataPos_13 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_��ɱ);
      local Goal_DataPos_14 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_������);
      local Goal_DataPos_15 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_ˮ����);
      local Goal_DataPos_16 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_������);
      local Goal_DataPos_17 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_������);
      local Goal_DataPos_18 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_����);
      local Goal_DataPos_19 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_����);
      local Goal_DataPos_20 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_��˯);
      local Goal_DataPos_21 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_������);
      local Goal_DataPos_22 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_��ʯ��);
      local Goal_DataPos_23 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_������);
      local Goal_DataPos_26 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_����);
      local Goal_DataPos_27 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_����);
      local Goal_DataPos_28 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_������);
      local Goal_DataPos_29 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_����);
      local imageText = "@g,"..Goal_DataPos_29..",2,8,6,0@"
      local Goal_DataPos_35 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_��������1);
      local Goal_DataPos_36 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_��������2);
      local Goal_DataPos_37 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_��������3);
      local Goal_DataPos_38 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_��������4);
      local Goal_DataPos_39 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_��������5);
      local Goal_DataPos_40 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_��������6);
      local Goal_DataPos_41 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_��������7);
      local Goal_DataPos_42 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_��������8);
      local Goal_DataPos_43 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_��������9);
      local Goal_DataPos_44 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_��������10);
      local TechIndex = Tech.GetTechIndex(evolution_plan_tech[count]);
      local TechName = Tech.GetData(TechIndex, CONST.TECH_NAME);
      local msg = imageText .. "����$4".. Goal_name .. "\\n"
                         .. "��������������" .. "$1�w�� ".. Goal_DataPos_4+2 .."��" .. "$8�ؚ� ".. Goal_DataPos_13 .."��" .. "$8���� ".. Goal_DataPos_27 .."\\n"
                         .. "��������������" .. "$1���� ".. Goal_DataPos_5+2 .."��" .. "$8���� ".. Goal_DataPos_12 .."��" .. "$8�W�� ".. Goal_DataPos_26 .."\\n"
                         .. "��������������" .. "$1���� ".. Goal_DataPos_6+2 .."��" .. "$2���� ".. Goal_DataPos_18 .."��" .. "$2���� ".. Goal_DataPos_19 .."\\n"
                         .. "��������������" .. "$1�ٶ� ".. Goal_DataPos_7+2 .."��" .. "$2��˯ ".. Goal_DataPos_20 .."��" .. "$2���� ".. Goal_DataPos_21 .."\\n"
                         .. "��������������" .. "$1ħ�� ".. Goal_DataPos_8+2 .."��" .. "$2��ʯ ".. Goal_DataPos_22 .."��" .. "$2���� ".. Goal_DataPos_23 .."\\n"
                         .. "��������������" .. "$5�� ".. Goal_DataPos_14/10 .."��" .."$5ˮ ".. Goal_DataPos_15/10 .."��" .."$5�� ".. Goal_DataPos_16/10 .."��" .."$5�L ".. Goal_DataPos_17/10 .."\\n"
                         .. "��������������" .. "$9�N�� ".. Goal_DataPos_3 .."��" .. "$9���� ".. TechName .."\\n"
      return msg;
end

--��Ʒ��Ϣ
function evolutionOfferingInfo(seqno)
              local msg = "";
              local EnemyDataIndex_1 = Data.EnemyGetDataIndex(evolution_plan_offering[seqno]);
              local enemyBaseId_1 = Data.EnemyGetData(EnemyDataIndex_1, CONST.Enemy_Base���);
              local EnemyBaseDataIndex_1 = Data.EnemyBaseGetDataIndex(enemyBaseId_1);
              --local offering_name_1 = Data.EnemyBaseGetData(EnemyBaseDataIndex_1, CONST.EnemyBase_����);
              local offering_image_1 = Data.EnemyBaseGetData(EnemyBaseDataIndex_1, CONST.EnemyBase_����);
              local EnemyDataIndex_3 = Data.EnemyGetDataIndex(evolution_plan_pet[seqno]);
              local enemyBaseId_3 = Data.EnemyGetData(EnemyDataIndex_3, CONST.Enemy_Base���);
              local EnemyBaseDataIndex_3 = Data.EnemyBaseGetDataIndex(enemyBaseId_3);
              --local offering_name_3 = Data.EnemyBaseGetData(EnemyBaseDataIndex_3, CONST.EnemyBase_����);
              local offering_image_3 = Data.EnemyBaseGetData(EnemyBaseDataIndex_3, CONST.EnemyBase_����);
              --local offering_image_ix = 3 + 7*(i-1);
              local imageText_1 = "@g,"..offering_image_1..",5,6,4,0@"
              local imageText_2 = "@g,246691,10,4,4,0@"
              local imageText_3 = "@g,"..offering_image_3..",15,6,4,0@"
              local msg = msg .. imageText_1 .. "  " .. imageText_2 .. "  " .. imageText_3

              local Gold = evolution_plan_gold[seqno];
              local ItemsetIndex = Data.ItemsetGetIndex(evolution_plan_item[seqno]);
              local Item_name= Data.ItemsetGetData( ItemsetIndex, CONST.ITEMSET_TRUENAME);

              local level = evolution_plan_requirement[seqno][1][2];
              local dead_num = evolution_plan_requirement[seqno][2][2];
              local hit_num = evolution_plan_requirement[seqno][3][2];
              local kill_num = evolution_plan_requirement[seqno][4][2];

              local msg = msg .. "\\n\\n\\n\\n\\n\\n��$5����: ".. Item_name .. "1��" .. "����$5ħ��: " .. Gold .. " G\\n"
                                              .. "��$4��l��:\\n"
                                              .. "��$4�ȼ�".. level .. "�� ����" .. dead_num .. "�� ����" .. hit_num .. "�� ����" .. kill_num .. "��"
      return msg;
end

--����ִ��
function evolutionMutation(seqno,player,petSlot)
              if (Char.ItemNum(player, evolution_plan_item[seqno])==0) then
                  NLG.SystemMessage(player,"[ϵ�y]ȱ���M����ʯ�^��");
                  return
              end
              if (Char.GetData(player, CONST.����_���)<evolution_plan_gold[seqno]) then
                  NLG.SystemMessage(player,"[ϵ�y]�M��������Ų��㡣");
                  return
              end
              local petIndex = Char.GetPet(player,petSlot);
              if (petIndex>=0) then
                local PetID = Char.GetData(petIndex, CONST.PET_PetID);
                local level_num = Char.GetData(petIndex, evolution_plan_requirement[seqno][1][1]);
                Level = level_num;
                local dead_num = Char.GetData(petIndex, evolution_plan_requirement[seqno][2][1]);
                local hit_num = Char.GetData(petIndex, evolution_plan_requirement[seqno][3][1]);
                local kill_num = Char.GetData(petIndex, evolution_plan_requirement[seqno][4][1]);
                if (PetID~=evolution_plan_offering[seqno]) then
                      NLG.SystemMessage(player,"[ϵ�y]ȱ���M�����茙�");
                      return
                end
                if ( level_num < evolution_plan_requirement[seqno][1][2] ) then
                      NLG.SystemMessage(player,"[ϵ�y]�ȼ�δ�_�M���˜ʡ�");
                      return
                end
                if ( dead_num < evolution_plan_requirement[seqno][2][2] ) then
                      NLG.SystemMessage(player,"[ϵ�y]����������"..dead_num.."δ�_�M���˜ʡ�");
                      return
                end
                if ( hit_num < evolution_plan_requirement[seqno][3][2] ) then
                      NLG.SystemMessage(player,"[ϵ�y]���������"..hit_num.."δ�_�M���˜ʡ�");
                      return
                end
                if ( kill_num < evolution_plan_requirement[seqno][4][2] ) then
                      NLG.SystemMessage(player,"[ϵ�y]�������"..kill_num.."δ�_�M���˜ʡ�");
                      return
                end
              else
                      NLG.SystemMessage(player,"[ϵ�y]ȱ���M�����茙�");
                      return
              end
              Char.DelItem(player, evolution_plan_item[seqno], 1);
              Char.AddGold(player, -evolution_plan_gold[seqno]);

              --���μ�¼
              local a6, a1, a2, a3, a4, a5 = Char.GetPetRank(player,petSlot);
              -- ���＼�ܼ�¼
              local skillTable={}
              for i=0,9 do
                local tech_id = Pet.GetSkill(petIndex, i)
                if (tech_id<0) then
                  table.insert(skillTable,nil)
                else
                  table.insert(skillTable,tech_id)
                end
              end

              Char.DelSlotPet(player, petSlot);
              Char.GivePet(player,evolution_plan_pet[seqno],0);

              --�����������ԭ����ͬ
              local evolution_petIndex = Char.GetPet(player,petSlot);
              Pet.SetArtRank(evolution_petIndex, CONST.PET_���,  Pet.FullArtRank(evolution_petIndex, CONST.PET_���) - a1 );
              Pet.SetArtRank(evolution_petIndex, CONST.PET_����,  Pet.FullArtRank(evolution_petIndex, CONST.PET_����) - a2 );
              Pet.SetArtRank(evolution_petIndex, CONST.PET_ǿ��,  Pet.FullArtRank(evolution_petIndex, CONST.PET_ǿ��) - a3 );
              Pet.SetArtRank(evolution_petIndex, CONST.PET_����,  Pet.FullArtRank(evolution_petIndex, CONST.PET_����) - a4 );
              Pet.SetArtRank(evolution_petIndex, CONST.PET_ħ��,  Pet.FullArtRank(evolution_petIndex, CONST.PET_ħ��) - a5 );
              Pet.ReBirth(player, evolution_petIndex);
              Pet.UpPet(player, evolution_petIndex);

              local arr_rank1_new = Pet.GetArtRank(evolution_petIndex,CONST.PET_���);
              local arr_rank2_new = Pet.GetArtRank(evolution_petIndex,CONST.PET_����);
              local arr_rank3_new = Pet.GetArtRank(evolution_petIndex,CONST.PET_ǿ��);
              local arr_rank4_new = Pet.GetArtRank(evolution_petIndex,CONST.PET_����);
              local arr_rank5_new = Pet.GetArtRank(evolution_petIndex,CONST.PET_ħ��);

              if(Level~=1) then
                Char.SetData(evolution_petIndex,CONST.����_������,Level-1);
                Char.SetData(evolution_petIndex,CONST.����_�ȼ�,Level);
                Char.SetData(evolution_petIndex,CONST.����_����, (Char.GetData(evolution_petIndex,CONST.����_����) + (arr_rank1_new * (1/24) * (Level - 1)*100)) );
                Char.SetData(evolution_petIndex,CONST.����_����, (Char.GetData(evolution_petIndex,CONST.����_����) + (arr_rank2_new * (1/24) * (Level - 1)*100)) );
                Char.SetData(evolution_petIndex,CONST.����_ǿ��, (Char.GetData(evolution_petIndex,CONST.����_ǿ��) + (arr_rank3_new * (1/24) * (Level - 1)*100)) );
                Char.SetData(evolution_petIndex,CONST.����_�ٶ�, (Char.GetData(evolution_petIndex,CONST.����_�ٶ�) + (arr_rank4_new * (1/24) * (Level - 1)*100)) );
                Char.SetData(evolution_petIndex,CONST.����_ħ��, (Char.GetData(evolution_petIndex,CONST.����_ħ��) + (arr_rank5_new * (1/24) * (Level - 1)*100)) );
                Pet.UpPet(player,evolution_petIndex);
              end
              -- ���＼��
              for i=0,9 do
                local tech_id = skillTable[i+1];
                Pet.DelSkill(evolution_petIndex,i);
                if (tech_id~=nil) then
                  Pet.AddSkill(evolution_petIndex,tech_id,i);
                end
              end
              Pet.AddSkill(evolution_petIndex,tech_idevolution_plan_tech[seqno]);
              Pet.UpPet(player,evolution_petIndex);
end

--���μ���
Char.GetPetRank = function(playerIndex,slot)
  local petIndex = Char.GetPet(playerIndex, slot);
  if petIndex >= 0 then
    local arr_rank1 = Pet.GetArtRank(petIndex,CONST.PET_���);
    local arr_rank2 = Pet.GetArtRank(petIndex,CONST.PET_����);
    local arr_rank3 = Pet.GetArtRank(petIndex,CONST.PET_ǿ��);
    local arr_rank4 = Pet.GetArtRank(petIndex,CONST.PET_����);
    local arr_rank5 = Pet.GetArtRank(petIndex,CONST.PET_ħ��);
    local arr_rank11 = Pet.FullArtRank(petIndex, CONST.PET_���);
    local arr_rank21 = Pet.FullArtRank(petIndex, CONST.PET_����);
    local arr_rank31 = Pet.FullArtRank(petIndex, CONST.PET_ǿ��);
    local arr_rank41 = Pet.FullArtRank(petIndex, CONST.PET_����);
    local arr_rank51 = Pet.FullArtRank(petIndex, CONST.PET_ħ��);
    local a1 = math.abs(arr_rank11 - arr_rank1);
    local a2 = math.abs(arr_rank21 - arr_rank2);
    local a3 = math.abs(arr_rank31 - arr_rank3);
    local a4 = math.abs(arr_rank41 - arr_rank4);
    local a5 = math.abs(arr_rank51 - arr_rank5);
    local a6 = a1 + a2+ a3+ a4+ a5;
    return a6, a1, a2, a3, a4, a5;
  end
  return -1;
end

--�����ַ���ת��
function Tribe(Tribe)
  if Tribe==0 then
    return "����ϵ"
  elseif Tribe == 1 then
    return "����ϵ"
  elseif Tribe == 2 then
    return "����ϵ"
  elseif Tribe == 3 then
    return "�w��ϵ"
  elseif Tribe == 4 then
    return "���xϵ"
  elseif Tribe == 5 then
    return "ֲ��ϵ"
  elseif Tribe == 6 then
    return "Ұ�Fϵ"
  elseif Tribe == 7 then
    return "����ϵ"
  elseif Tribe == 8 then
    return "����ϵ"
  elseif Tribe == 9 then
    return "аħϵ"
  elseif Tribe == 10 then
    return "����ϵ"
  elseif Tribe == 11 then
    return "���`ϵ"
  end
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
