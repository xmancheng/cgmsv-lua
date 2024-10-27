---ģ����
local Module = ModuleBase:createModule(convertPlans)

--�����������
local convert_plan_name = {};
local convert_plan_offering = {};
local convert_plan_item = {};
local convert_plan_gold = {};
local convert_plan_pet = {};
--
convert_plan_name[1] = "��Ӱ����ϵ��001";
convert_plan_offering[1] = {5,831,101};
convert_plan_item[1] = {79064};
convert_plan_gold[1] =15000;
convert_plan_pet[1] = {5,5,5,5,5,5,5,500057,500057,606093};

convert_plan_name[2] = "������ϵ��001";
convert_plan_offering[2] = {503,801,104};
convert_plan_item[2] = {79065};
convert_plan_gold[2] =15000;
convert_plan_pet[2] = {503,503,503,503,503,503,503,500063,500063,606092};
-------------------------------------------------
local function calcWarp()
  local page = math.modf(#convert_plan_name / 8) + 1
  local remainder = math.fmod(#convert_plan_name, 8)
  return page, remainder
end

--Զ�̰�ťUI����
function Module:convertPlansInfo(npc, player)
          local winButton = CONST.BUTTON_�ر�;
          local msg = "1\\n���������������������ﮐ׃���졿\\n"
          for i = 1,#convert_plan_name do
             msg = msg .. "�����Ŀ: "..i.."��".. convert_plan_name[i] .. "\\n"
             if (i>=8) then
                 winButton = CONST.BUTTON_��ȡ��;
             end
          end
          NLG.ShowWindowTalked(player, self.converterNPC, CONST.����_ѡ���, winButton, 1, msg);
end

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load');
  self.converterNPC = self:NPC_createNormal('���ﮐ׃����', 14682, { x = 38, y = 31, mapType = 0, map = 777, direction = 6 });
  self:NPC_regWindowTalkedEvent(self.converterNPC, function(npc, player, _seqno, _select, _data)
    local column = tonumber(_data)
    local page = tonumber(_seqno)
    local warpPage = page;
    local winMsg = "1\\n���������������������ﮐ׃���졿\\n"
    local winButton = CONST.BUTTON_�ر�;
    local totalPage, remainder = calcWarp()
    --��ҳ16 ��ҳ32 �ر�/ȡ��2
    if _select > 0 then
      if _select == CONST.��ť_ȷ�� then
          if (page>=1001) then
              local seqno = page - 1000;
              local msg = "���������������������ﮐ׃���졿\\n"
                                  .. "������$1��Ҫ�������в��ϲ����M�Ю�׃����\\n"
              for i = 1,#convert_plan_offering[seqno] do
                  EnemyDataIndex_i = Data.EnemyGetDataIndex(convert_plan_offering[seqno][i]);
                  enemyBaseId_i = Data.EnemyGetData(EnemyDataIndex_i, CONST.Enemy_Base���);
                  EnemyBaseDataIndex_i = Data.EnemyBaseGetDataIndex(enemyBaseId_i);
                  offering_name_i = Data.EnemyBaseGetData(EnemyBaseDataIndex_i, CONST.EnemyBase_����);
                  offering_image_i = Data.EnemyBaseGetData(EnemyBaseDataIndex_i, CONST.EnemyBase_����);
                  offering_image_ix = 3 + 7*(i-1);
                  imageText_i = "@g,"..offering_image_i..","..offering_image_ix..",5,4,0@"
                  msg = msg .. "��".. offering_name_i .. " Lv1��" .. imageText_i
              end
              local Gold = convert_plan_gold[seqno];
              local ItemsetIndex = Data.ItemsetGetIndex(convert_plan_item[seqno][1]);
              local Item_name= Data.ItemsetGetData( ItemsetIndex, CONST.ITEMSET_TRUENAME);
              local probRate = prob(seqno,convert_plan_pet[seqno][10]);
              local msg = msg .. "\\n\\n\\n\\n\\n��$5���� ".. Item_name .. "1��" .. "����$5ħ�� " .. Gold .. " G\\n"
                                              .. "��$4�ɹ��C�� ".. probRate .. "%" .. "������$9ʧ������Ʒ ��һ�λ֮����"
              NLG.ShowWindowTalked(player, self.converterNPC, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 2000+seqno, msg);
              return
          else
              return
          end
      elseif _select == CONST.��ť_�� then
          if (page>=2001) then
              return
          else
              return
          end
      elseif _select == CONST.��ť_�� then
        return
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
            winMsg = winMsg .. "�����Ŀ: "..i.."��".. convert_plan_name[i] .. "\\n"
        end
      else
        for i = 1 + count, 8 + count do
            winMsg = winMsg .. "�����Ŀ: "..i.."��".. convert_plan_name[i] .. "\\n"
        end
      end
      NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, winButton, warpPage, winMsg);
    else
      local count = 8 * (warpPage - 1) + column
      print(count)
      local msg = "���������������������ﮐ׃���졿\\n"
      local msg = msg .. convertGoalInfo(count);
      NLG.ShowWindowTalked(player, self.converterNPC, CONST.����_��Ϣ��, CONST.��ť_ȷ���ر�, 1000+count, msg);
    end
  end)
  self:NPC_regTalkedEvent(self.converterNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local winButton = CONST.BUTTON_�ر�;
      local msg = "1\\n���������������������ﮐ׃���졿\\n"
      for i = 1,#convert_plan_name do
         msg = msg .. "�����Ŀ: "..i.."��".. convert_plan_name[i] .. "\\n"
         if (i>=8) then
             winButton = CONST.BUTTON_��ȡ��;
         end
      end
      NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, winButton, 1, msg);
    end
    return
  end)
end

function convertGoalInfo(count)
      local EnemyDataIndex_Goal = Data.EnemyGetDataIndex(convert_plan_pet[count][10]);
      local enemyBaseId_Goal = Data.EnemyGetData(EnemyDataIndex_Goal, CONST.Enemy_Base���);
      local EnemyBaseDataIndex_Goal = Data.EnemyBaseGetDataIndex(enemyBaseId_Goal);
      local Goal_name = Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_����);
      local Goal_DataPos_3 = Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_����);
      local Goal_DataPos_3 = Tribe(Goal_DataPos_3);
      local Goal_DataPos_4 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_����);
      local Goal_DataPos_5 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_����);
      local Goal_DataPos_6 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_ǿ��);
      local Goal_DataPos_7 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_�ٶ�);
      local Goal_DataPos_8 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_ħ��);
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
      local imageText = "@g,"..Goal_DataPos_29..",3,10,6,0@"
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
      local msg = imageText .. "����".. Goal_name .. "\\n"
                         .. "��������������" .. "$1�w�� ".. Goal_DataPos_4+2 .."��" .. "$8�ؚ� ".. Goal_DataPos_13 .."��" .. "$8���� ".. Goal_DataPos_27 .."\\n"
                         .. "��������������" .. "$1���� ".. Goal_DataPos_5+2 .."��" .. "$8���� ".. Goal_DataPos_12 .."��" .. "$8�W�� ".. Goal_DataPos_26 .."\\n"
                         .. "��������������" .. "$1���� ".. Goal_DataPos_6+2 .."��" .. "$2���� ".. Goal_DataPos_18 .."��" .. "$2���� ".. Goal_DataPos_19 .."\\n"
                         .. "��������������" .. "$1�ٶ� ".. Goal_DataPos_7+2 .."��" .. "$2��˯ ".. Goal_DataPos_20 .."��" .. "$2���� ".. Goal_DataPos_21 .."\\n"
                         .. "��������������" .. "$1ħ�� ".. Goal_DataPos_8+2 .."��" .. "$2��ʯ ".. Goal_DataPos_22 .."��" .. "$2���� ".. Goal_DataPos_23 .."\\n"
                         .. "��������������" .. "$5�� ".. Goal_DataPos_14 .."��" .."$5ˮ ".. Goal_DataPos_15 .."��" .."$5�� ".. Goal_DataPos_16 .."��" .."$5�L ".. Goal_DataPos_17 .."\\n"
                         .. "��������������" .. "$9�N�� ".. Goal_DataPos_3 .."��" .. "$9���ܸ� ".. Goal_DataPos_28 .."\\n"
      return msg;
end
function prob(count,id)
  for i=1,10 do
      if (convert_plan_pet[count][i]==id) then
          local prob = ( (11-i)/10 )*100;
          return prob;
      end
  end
  return -1;
end
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
