---ģ����
local Module = ModuleBase:createModule(forgingPlans)

--������������
local forging_plan_name = {};
local forging_plan_offering = {};
local forging_plan_item = {};
local forging_plan_gold = {};
local forging_plan_thing = {};
--
forging_plan_name[1] = "�����ߡ��}���^��";
forging_plan_offering[1] = {{235,1},{51021,1},{18450,10}};
forging_plan_item[1] = {70261};
forging_plan_gold[1] =250000;
forging_plan_thing[1] = {51000,51000,51000,51000,51000,51000,51000,51000,51000,51000};

forging_plan_name[2] = "�����ߡ��}���z��";
forging_plan_offering[2] = {{235,1},{51021,1},{18450,10}};
forging_plan_item[2] = {70261};
forging_plan_gold[2] =250000;
forging_plan_thing[2] = {51001,51001,51001,51001,51001,51001,51001,51001,51001,51001};

forging_plan_name[3] = "�����ߡ��}���Lѥ";
forging_plan_offering[3] = {{235,1},{51021,1},{18450,10}};
forging_plan_item[3] = {70263};
forging_plan_gold[3] =250000;
forging_plan_thing[3] = {51002,51002,51002,51002,51002,51002,51002,51002,51002,51002};

forging_plan_name[4] = "���������}����";
forging_plan_offering[4] = {{235,1},{51021,1},{18450,10}};
forging_plan_item[4] = {70264};
forging_plan_gold[4] =250000;
forging_plan_thing[4] = {51003,51003,51003,51003,51003,51003,51003,51003,51003,51003};

forging_plan_name[5] = "�����ߡ��}�䷨ñ";
forging_plan_offering[5] = {{235,1},{51021,1},{18450,10}};
forging_plan_item[5] = {70263};
forging_plan_gold[5] =250000;
forging_plan_thing[5] = {51004,51004,51004,51004,51004,51004,51004,51004,51004,51004};

forging_plan_name[6] = "�����ߡ��}�䷨��";
forging_plan_offering[6] = {{235,1},{51021,1},{18450,10}};
forging_plan_item[6] = {70259};
forging_plan_gold[6] =250000;
forging_plan_thing[6] = {51005,51005,51005,51005,51005,51005,51005,51005,51005,51005};

forging_plan_name[7] = "�����ߡ��}�䷨Ь";
forging_plan_offering[7] = {{235,1},{51021,1},{18450,10}};
forging_plan_item[7] = {70262};
forging_plan_gold[7] =250000;
forging_plan_thing[7] = {51006,51006,51006,51006,51006,51006,51006,51006,51006,51006};

forging_plan_name[8] = "���������}�䷨��";
forging_plan_offering[8] = {{235,1},{51021,1},{18450,10}};
forging_plan_item[8] = {70265};
forging_plan_gold[8] =250000;
forging_plan_thing[8] = {51007,51007,51007,51007,51007,51007,51007,51007,51007,51007};

forging_plan_name[9] = " �����ߡ����L֮ñ";
forging_plan_offering[9] = {{235,1},{51021,1},{18450,10}};
forging_plan_item[9] = {70257};
forging_plan_gold[9] =250000;
forging_plan_thing[9] = {51008,51008,51008,51008,51008,51008,51008,51008,51008,51008};
-------------------------------------------------
local function calcWarp()
  local page = math.modf(#forging_plan_name / 8) + 1
  local remainder = math.fmod(#forging_plan_name, 8)
  return page, remainder
end

--Զ�̰�ťUI����
function Module:forgingPlansInfo(npc, player)
          local winButton = CONST.BUTTON_�ر�;
          local msg = "1\\n����������������������្��졿\\n"
          for i = 1,8 do
             msg = msg .. "�������Ŀ "..i.."��".. forging_plan_name[i] .. "\\n"
             if (i>=8) then
                 winButton = CONST.BUTTON_��ȡ��;
             end
          end
          NLG.ShowWindowTalked(player, self.forgingerNPC, CONST.����_ѡ���, winButton, 1, msg);
end

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load');
  self.forgingerNPC = self:NPC_createNormal('����្���', 231137, { x = 235, y = 83, mapType = 0, map = 1000, direction = 0 });
  self:NPC_regWindowTalkedEvent(self.forgingerNPC, function(npc, player, _seqno, _select, _data)
    local column = tonumber(_data)
    local page = tonumber(_seqno)
    local warpPage = page;
    local winMsg = "1\\n����������������������្��졿\\n"
    local winButton = CONST.BUTTON_�ر�;
    local totalPage, remainder = calcWarp()
    --��ҳ16 ��ҳ32 �ر�/ȡ��2
    if _select > 0 then
      if _select == CONST.��ť_ȷ�� then
          if (page>=1001) then
              local seqno = page - 1000;
              local msg = "����������������������្��졿\\n"
                                  .. "������$1��Ҫ�������в��ϲ����M���្���\\n$5"
              local msg = msg .. forgingOfferingInfo(seqno)
              NLG.ShowWindowTalked(player, self.forgingerNPC, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 2000+seqno, msg);
              return
          else
              return
          end
      elseif _select == CONST.��ť_�ر� then
          if (page>=1001) then
              local winButton = CONST.BUTTON_�ر�;
              local msg = "1\\n����������������������្��졿\\n"
              for i = 1,8 do
                 msg = msg .. "�������Ŀ "..i.."��".. forging_plan_name[i] .. "\\n"
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
              forgingMutation(seqno,player)
              return
          else
              return
          end
      elseif _select == CONST.��ť_�� then
          if (page>=2001) then
              local count = page - 2000;
              local msg = "����������������������្��졿\\n"
              local msg = msg .. forgingGoalInfo(count);
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
            winMsg = winMsg .. "�������Ŀ "..i.."��".. forging_plan_name[i] .. "\\n"
        end
      else
        for i = 1 + count, 8 + count do
            winMsg = winMsg .. "�������Ŀ "..i.."��".. forging_plan_name[i] .. "\\n"
        end
      end
      NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, winButton, warpPage, winMsg);
    else
      local count = 8 * (warpPage - 1) + column
      --print(count)
      local msg = "����������������������្��졿\\n"
      local msg = msg .. forgingGoalInfo(count);
      NLG.ShowWindowTalked(player, self.forgingerNPC, CONST.����_��Ϣ��, CONST.��ť_ȷ���ر�, 1000+count, msg);
    end
  end)
  self:NPC_regTalkedEvent(self.forgingerNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local winButton = CONST.BUTTON_�ر�;
      local msg = "1\\n����������������������្��졿\\n"
      for i = 1,8 do
         msg = msg .. "�������Ŀ "..i.."��".. forging_plan_name[i] .. "\\n"
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
function forgingGoalInfo(count)
      local ItemsetIndex_Goal = Data.ItemsetGetIndex(forging_plan_thing[count][10]);
      local Goal_name = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_TRUENAME);
      local Goal_DataPos_2 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_BASEIMAGENUMBER);
      local imageText = "@g,"..Goal_DataPos_2..",3,4,0,0@"

      local Goal_DataPos_3 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_TYPE);
      local Goal_DataPos_3 = Type(Goal_DataPos_3);
      local Goal_DataPos_4 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_MAXDURABILITY);
      local Goal_DataPos_5 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_LEVEL);
      local Goal_DataPos_6 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_MODIFYATTACK);
      local Goal_DataPos_7 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_MODIFYDEFENCE);
      local Goal_DataPos_8 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_MODIFYAGILITY);
      local Goal_DataPos_9 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_MODIFYMAGIC);
      local Goal_DataPos_10 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_MODIFYRECOVERY);

      local Goal_DataPos_11 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_MODIFYCRITICAL);
      local Goal_DataPos_12 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_MODIFYCOUNTER);
      local Goal_DataPos_13 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_MODIFYHITRATE);
      local Goal_DataPos_14 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_MODIFYAVOID);

      local Goal_DataPos_15 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_MODIFYHP);
      local Goal_DataPos_16 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_MODIFYFORCEPOINT);
      local Goal_DataPos_17 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_MODIFYLUCK);
      local Goal_DataPos_18 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_MODIFYCHARISMA);
      local Goal_DataPos_19 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_MODIFYCHARM);
      local Goal_DataPos_20 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_POISON);
      local Goal_DataPos_21 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_SLEEP);
      local Goal_DataPos_22 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_STONE);
      local Goal_DataPos_23 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_DRUNK);
      local Goal_DataPos_24 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_CONFUSION);
      local Goal_DataPos_25 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_AMNESIA);

      local msg = imageText .. "����$4".. Goal_name .. "\\n"
                         .. "��������������" .. "$1���� ".. Goal_DataPos_6 .."��" .. "$8�ؚ� ".. Goal_DataPos_11 .."��" .. "$8���� ".. Goal_DataPos_12 .."\\n"
                         .. "��������������" .. "$1���R ".. Goal_DataPos_7 .."��" .. "$8���� ".. Goal_DataPos_13 .."��" .. "$8�W�� ".. Goal_DataPos_14 .."\\n"
                         .. "��������������" .. "$1���� ".. Goal_DataPos_8 .."��" .. "$2���� ".. Goal_DataPos_20 .."��" .. "$2���� ".. Goal_DataPos_23 .."\\n"
                         .. "��������������" .. "$1���� ".. Goal_DataPos_9 .."��" .. "$2��˯ ".. Goal_DataPos_21 .."��" .. "$2���� ".. Goal_DataPos_24 .."\\n"
                         .. "��������������" .. "$1�֏� ".. Goal_DataPos_10 .."��" .. "$2��ʯ ".. Goal_DataPos_22 .."��" .. "$2���� ".. Goal_DataPos_25 .."\\n"
                         .. "��������������" .. " \\n"
                         .. "��������������" .. "$9��� ".. Goal_DataPos_3 .."��" .. "$9�ȼ� ".. Goal_DataPos_5 .."��" .. "$9�;� ".. Goal_DataPos_4 .."\\n"
      return msg;
end

--��Ʒ��Ϣ
function forgingOfferingInfo(seqno)
              local msg = "";
              for i = 1,#forging_plan_offering[seqno] do
                  local ItemsetIndex_i = Data.ItemsetGetIndex(forging_plan_offering[seqno][i][1]);
                  local ItemNum_i = Data.ItemsetGetIndex(forging_plan_offering[seqno][i][2]);
                  local offering_name_i = Data.ItemsetGetData(ItemsetIndex_i, CONST.ITEMSET_TRUENAME);
                  local offering_image_i = Data.ItemsetGetData(ItemsetIndex_i, CONST.ITEMSET_BASEIMAGENUMBER);
                  local offering_image_ix = 3 + 7*(i-1);
                  local imageText_i = "@g,"..offering_image_i..","..offering_image_ix..",4,0,0@"
                  local len = #offering_name_i;
                  if len <= 12 then
                      spacelen = 12 - len;
                      spaceMsg = "";
                      for i = 1, math.modf(spacelen/2) do
                          spaceMsg = spaceMsg .." ";
                      end
                  else
                      spaceMsg = "";
                  end
                  msg = msg .. spaceMsg .. offering_name_i ..ItemNum_i.."��" .. spaceMsg .. imageText_i
              end
              local Gold = forging_plan_gold[seqno];
              local ItemsetIndex = Data.ItemsetGetIndex(forging_plan_item[seqno][1]);
              local Item_name= Data.ItemsetGetData( ItemsetIndex, CONST.ITEMSET_TRUENAME);
              local probRate = prob(seqno,forging_plan_thing[seqno][10]);
              local msg = msg .. "\\n\\n\\n\\n��$5�OӋ�D: ".. Item_name .. "1��" .. "����$5ħ��: " .. Gold .. " G\\n"
                                              .. "��$4�ɹ��C��: ".. probRate .. "%" .. "����"
      return msg;
end

--��������ִ��
function forgingMutation(seqno,player)
              if (Char.ItemNum(player, forging_plan_item[seqno][1])==0) then
                  NLG.SystemMessage(player,"[ϵ�y]ȱ�������OӋ�D��");
                  return
              end
              if (Char.GetData(player, CONST.����_���)<forging_plan_gold[seqno]) then
                  NLG.SystemMessage(player,"[ϵ�y]����������Ų��㡣");
                  return
              end
              for i = 1,#forging_plan_offering[seqno] do
                  local itemIndex = Char.HaveItem(player, forging_plan_offering[seqno][i][1]);
                  if (itemIndex>=0) then
                      local itemNum = Char.ItemNum(player,forging_plan_offering[seqno][i][1]);
                      if (itemNum < forging_plan_offering[seqno][i][2]) then
                          NLG.SystemMessage(player,"[ϵ�y]���������ϔ������㡣");
                          return
                      end
                  else
                      NLG.SystemMessage(player,"[ϵ�y]ȱ�����������ϡ�");
                      return
                  end
              end
              Char.DelItem(player, forging_plan_item[seqno][1], 1);
              Char.AddGold(player, -forging_plan_gold[seqno]);
              local randCatch= NLG.Rand(1, #forging_plan_thing[seqno] );
              for i = 1,#forging_plan_offering[seqno] do
                  Char.DelItem(player, forging_plan_offering[seqno][i][1], forging_plan_offering[seqno][i][2]);
              end
              Char.GiveItem(player,forging_plan_thing[seqno][randCatch],1);
end

--Ŀ��ɹ��ʼ���
function prob(count,id)
  for i=1,10 do
      if (forging_plan_thing[count][i]==id) then
          local prob = ( (11-i)/10 )*100;
          return prob;
      end
  end
  return -1;
end

--�����ַ���ת��
function Type(Type)
  if Type==0 then
    return "��"
  elseif Type == 1 then
    return "��"
  elseif Type == 2 then
    return "��"
  elseif Type == 3 then
    return "��"
  elseif Type == 4 then
    return "��"
  elseif Type == 5 then
    return "С��"
  elseif Type == 6 then
    return "ޒ���S"
  elseif Type == 7 then
    return "��"
  elseif Type == 8 then
    return "�^��"
  elseif Type == 9 then
    return "ñ��"
  elseif Type == 10 then
    return "�z��"
  elseif Type == 11 then
    return "�·�"
  elseif Type == 12 then
    return "�L��"
  elseif Type == 13 then
    return "ѥ��"
  elseif Type == 14 then
    return "Ь��"
  elseif Type == 15 then
    return "�֭h"
  elseif Type == 16 then
    return "����"
  elseif Type == 17 then
    return "��"
  elseif Type == 18 then
    return "��ָ"
  elseif Type == 19 then
    return "�^��"
  elseif Type == 20 then
    return "���h"
  elseif Type == 21 then
    return "�o����"
  elseif Type == 22 then
    return "ˮ��"
  elseif Type == 55 then
    return "�^�"
  elseif Type == 56 then
    return "����ˮ��"
  elseif Type == 57 then
    return "�����Ʒ"
  elseif Type == 58 then
    return "�����b��"
  elseif Type == 59 then
    return "������"
  elseif Type == 60 then
    return "�����iȦ"
  elseif Type == 61 then
    return "�����o��"
  elseif Type == 65 then
    return "����"
  elseif Type == 66 then
    return "ħ��"
  elseif Type == 67 then
    return "����"
  elseif Type == 68 then
    return "����"
  elseif Type == 69 then
    return "�Lħ"
  elseif Type == 70 then
    return "ȭ��"
  else
    return "����"
  end
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;