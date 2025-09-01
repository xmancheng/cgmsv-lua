---ģ����
local Module = ModuleBase:createModule(sewingPlans)

--��������
local player_skillAffixes_list = {500,501,502,503};		--skill�~�Y��̖�б�
local skillAffixes_info = {}
skillAffixes_info[500] = "�غϽY���r5%�O�޻�";
skillAffixes_info[501] = "Ѫ��20%���¹�������10%";
skillAffixes_info[502] = "Ѫ��35-65%���R����10%";
skillAffixes_info[503] = "Ѫ��85%�����ٶ�����10%";

--�����������
local sewing_plan_name = {};		--����ʾ��������
local sewing_plan_offering = {};	--�������Ĳ�������{���߱��,����}
local sewing_plan_item = {};		--�������ͼ(����5)
local sewing_plan_gold = {};		--������
local sewing_plan_thing = {};		--10���Ʒ�������(�����ɹ���)
local sewing_plan_grade = {};		--Ʒ��(���������Ŀ0~3)
--
sewing_plan_name[1] = "������ˮ������ڤ�V��";
sewing_plan_offering[1] = {{66167,20},{66176,20},{66192,20}};
sewing_plan_item[1] = {70250};
sewing_plan_gold[1] =5000;
sewing_plan_thing[1] = {69040,69040,69040,69040,69040,69040,69040,69040,69040,69040};
sewing_plan_grade[1] =3;

sewing_plan_name[2] = "������ˮ�����ן�ྦྷ";
sewing_plan_offering[2] = {{66169,20},{66177,20},{66194,20}};
sewing_plan_item[2] = {70251};
sewing_plan_gold[2] =5000;
sewing_plan_thing[2] = {69041,69041,69041,69041,69041,69041,69041,69041,69041,69041};
sewing_plan_grade[2] =3;

sewing_plan_name[3] = "������ˮ���������`��";
sewing_plan_offering[3] = {{66171,20},{66178,20},{66196,20}};
sewing_plan_item[3] = {70252};
sewing_plan_gold[3] =5000;
sewing_plan_thing[3] = {69042,69042,69042,69042,69042,69042,69042,69042,69042,69042};
sewing_plan_grade[3] =3;

sewing_plan_name[4] = "������ˮ������G����";
sewing_plan_offering[4] = {{66173,20},{66179,20},{66198,20}};
sewing_plan_item[4] = {70253};
sewing_plan_gold[4] =5000;
sewing_plan_thing[4] = {69043,69043,69043,69043,69043,69043,69043,69043,69043,69043};
sewing_plan_grade[4] =3;

sewing_plan_name[5] = "������ˮ�����׻;���";
sewing_plan_offering[5] = {{66175,20},{66180,20},{66200,20}};
sewing_plan_item[5] = {70254};
sewing_plan_gold[5] =5000;
sewing_plan_thing[5] = {69044,69044,69044,69044,69044,69044,69044,69044,69044,69044};
sewing_plan_grade[5] =3;

sewing_plan_name[6] = "������ˮ�����}ҫ�xʯ";
sewing_plan_offering[6] = {{66194,20},{66196,20},{66200,20}};
sewing_plan_item[6] = {70255};
sewing_plan_gold[6] =5000;
sewing_plan_thing[6] = {69045,69045,69045,69045,69045,69045,69045,69045,69045,69045};
sewing_plan_grade[6] =3;

sewing_plan_name[7] = "������ˮ����̓��ħ��";
sewing_plan_offering[7] = {{70251,5},{70252,5},{70253,5}};
sewing_plan_item[7] = {70256};
sewing_plan_gold[7] =5000;
sewing_plan_thing[7] = {69046,69046,69046,69046,69046,69046,69046,69046,69046,69046};
sewing_plan_grade[7] =3;
-----------------------------------------------------
local function calcWarp()
  local page = math.modf(#sewing_plan_name / 8) + 1
  local remainder = math.fmod(#sewing_plan_name, 8)
  return page, remainder
end

--Զ�̰�ťUI����
function Module:sewingPlansInfo(npc, player)
          local winButton = CONST.BUTTON_�ر�;
          local msg = "1\\n����������������������ˮ���u����\\n"
          for i = 1,7 do
             msg = msg .. "�������Ŀ "..i.."��".. sewing_plan_name[i] .. "\\n"
             if (i>=8) then
                 winButton = CONST.BUTTON_��ȡ��;
             end
          end
          NLG.ShowWindowTalked(player, self.sewingerNPC, CONST.����_ѡ���, winButton, 1, msg);
end

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load');
  --self:regCallback('ItemExpansionEvent', Func.bind(self.itemExpansionCallback, self))
  self.sewingerNPC = self:NPC_createNormal('����ˮ���u��', 99220, { x = 92, y = 110, mapType = 0, map = 80010, direction = 0 });
  self:NPC_regWindowTalkedEvent(self.sewingerNPC, function(npc, player, _seqno, _select, _data)
    local column = tonumber(_data)
    local page = tonumber(_seqno)
    local warpPage = page;
    local winMsg = "1\\n����������������������ˮ���u����\\n"
    local winButton = CONST.BUTTON_�ر�;
    local totalPage, remainder = calcWarp()
    --��ҳ16 ��ҳ32 �ر�/ȡ��2
    if _select > 0 then
      if _select == CONST.��ť_ȷ�� then
          if (page>=1001) then
              local seqno = page - 1000;
              local msg = "����������������������ˮ���u����\\n"
                                  .. "������$1��Ҫ�������в��ϲ����M�нM���u��\\n$5"
              local msg = msg .. sewingOfferingInfo(seqno)
              NLG.ShowWindowTalked(player, self.sewingerNPC, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 2000+seqno, msg);
              return
          else
              return
          end
      elseif _select == CONST.��ť_�ر� then
          if (page>=1001) then
              local winButton = CONST.BUTTON_�ر�;
              local msg = "1\\n����������������������ˮ���u����\\n"
              for i = 1,7 do
                 msg = msg .. "�������Ŀ "..i.."��".. sewing_plan_name[i] .. "\\n"
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
              sewingMutation(seqno,player)
              return
          else
              return
          end
      elseif _select == CONST.��ť_�� then
          if (page>=2001) then
              local count = page - 2000;
              local msg = "����������������������ˮ���u����\\n"
              local msg = msg .. sewingGoalInfo(count);
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
            winMsg = winMsg .. "�������Ŀ "..i.."��".. sewing_plan_name[i] .. "\\n"
        end
      else
        for i = 1 + count, 8 + count do
            winMsg = winMsg .. "�������Ŀ "..i.."��".. sewing_plan_name[i] .. "\\n"
        end
      end
      NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, winButton, warpPage, winMsg);
    else
      local count = 8 * (warpPage - 1) + column
      --print(count)
      local msg = "����������������������ˮ���u����\\n"
      local msg = msg .. sewingGoalInfo(count);
      NLG.ShowWindowTalked(player, self.sewingerNPC, CONST.����_��Ϣ��, CONST.��ť_ȷ���ر�, 1000+count, msg);
    end
  end)
  self:NPC_regTalkedEvent(self.sewingerNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local winButton = CONST.BUTTON_�ر�;
      local msg = "1\\n����������������������ˮ���u����\\n"
      for i = 1,7 do
         msg = msg .. "�������Ŀ "..i.."��".. sewing_plan_name[i] .. "\\n"
         if (i>=8) then
             winButton = CONST.BUTTON_��ȡ��;
         end
      end
      NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, winButton, 1, msg);
    end
    return
  end)
end

--����˵����Ͻӿ�
function Module:itemExpansionCallback(itemIndex, type, msg, charIndex, slot)
  if (Item.GetData(itemIndex, CONST.����_�Ӳζ�)==41 and type==2) then
    --local boom_Skill = tostring(Item.GetData(itemIndex, CONST.����_USEFUNC));
    local info="";
    local boom_Skill_x = string.split(Item.GetData(itemIndex, CONST.����_USEFUNC),",");
    for i=1,#boom_Skill_x do
      local skillId = tonumber(boom_Skill_x[i]);
      if (skillId>0) then
        if (i<#boom_Skill_x) then
          info = info .. skillAffixes_info[skillId] .."\n";
        else
          info = info .. skillAffixes_info[skillId];
        end
      else
      end
    end
      
    local info = info .."\n".. msg;
    return info
  end
end

---------------------------------------------------------------------------------------------------------------
--Ŀ����Ϣ
function sewingGoalInfo(count)
      local ItemsetIndex_Goal = Data.ItemsetGetIndex(sewing_plan_thing[count][10]);
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
                         .. "��������������" .. "$1���� ".. Goal_DataPos_6 .."-50��" .. "$8�ؚ� ".. Goal_DataPos_11 .."��" .. "$8���� ".. Goal_DataPos_12 .."\\n"
                         .. "��������������" .. "$1���R ".. Goal_DataPos_7 .."-50��" .. "$8���� ".. Goal_DataPos_13 .."��" .. "$8�W�� ".. Goal_DataPos_14 .."\\n"
                         .. "��������������" .. "$1���� ".. Goal_DataPos_8 .."-50��" .. "$2���� ".. Goal_DataPos_20 .."��" .. "$2���� ".. Goal_DataPos_23 .."\\n"
                         .. "��������������" .. "$1���� ".. Goal_DataPos_9 .."-50��" .. "$2��˯ ".. Goal_DataPos_21 .."��" .. "$2���� ".. Goal_DataPos_24 .."\\n"
                         .. "��������������" .. "$1�֏� ".. Goal_DataPos_10 .."-50��" .. "$2��ʯ ".. Goal_DataPos_22 .."��" .. "$2���� ".. Goal_DataPos_25 .."\\n"
                         .. "��������������" .. "$4���� 300-400��ħ�� 300-400 \\n"
                         .. "��������������" .. "$9��� ".. Goal_DataPos_3 .."��" .. "$9�ȼ� ".. Goal_DataPos_5 .."��" .. "$9�;� ".. Goal_DataPos_4 .."\\n"
      return msg;
end

--��Ʒ��Ϣ
function sewingOfferingInfo(seqno)
              local msg = "";
              for i = 1,#sewing_plan_offering[seqno] do
                  local ItemsetIndex_i = Data.ItemsetGetIndex(sewing_plan_offering[seqno][i][1]);
                  local ItemNum_i = Data.ItemsetGetIndex(sewing_plan_offering[seqno][i][2]);
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
              local Gold = sewing_plan_gold[seqno];
              local ItemsetIndex = Data.ItemsetGetIndex(sewing_plan_item[seqno][1]);
              local Item_name= Data.ItemsetGetData( ItemsetIndex, CONST.ITEMSET_TRUENAME);
              local probRate = prob(seqno,sewing_plan_thing[seqno][10]);
              local msg = msg .. "\\n\\n\\n\\n��$5����ԭ��: ".. Item_name .. "5��" .. "����$5ħ��: " .. Gold .. " G\\n"
                                              .. "��$4�ɹ��C��: ".. probRate .. "%" .. "����"
      return msg;
end

--�u��ִ��
function sewingMutation(seqno,player)
              if (Char.ItemNum(player, sewing_plan_item[seqno][1])<5) then
                  NLG.SystemMessage(player,"[ϵ�y]ȱ���u���ĺ���ԭ�ϡ�");
                  return
              end
              if (Char.GetData(player, CONST.����_���)<sewing_plan_gold[seqno]) then
                  NLG.SystemMessage(player,"[ϵ�y]�u��������Ų��㡣");
                  return
              end
              for i = 1,#sewing_plan_offering[seqno] do
                  local itemIndex = Char.HaveItem(player, sewing_plan_offering[seqno][i][1]);
                  if (itemIndex>=0) then
                      local itemNum = Char.ItemNum(player,sewing_plan_offering[seqno][i][1]);
                      if (itemNum < sewing_plan_offering[seqno][i][2]) then
                          NLG.SystemMessage(player,"[ϵ�y]�u��������ϔ������㡣");
                          return
                      end
                  else
                      NLG.SystemMessage(player,"[ϵ�y]ȱ���u��������ϡ�");
                      return
                  end
              end
              Char.DelItem(player, sewing_plan_item[seqno][1], 5);
              Char.AddGold(player, -sewing_plan_gold[seqno]);
              local randCatch= NLG.Rand(1, #sewing_plan_thing[seqno] );
              for i = 1,#sewing_plan_offering[seqno] do
                  Char.DelItem(player, sewing_plan_offering[seqno][i][1], sewing_plan_offering[seqno][i][2]);
              end

              local newSlot = Char.GetEmptyItemSlot(player);				--�Դ��ӿ�
              Char.GiveItem(player,sewing_plan_thing[seqno][randCatch],1);
              --[[
              --��������
              local WeaponIndex = Char.GetItemIndex(player,newSlot);
              Item.SetData(WeaponIndex, CONST.����_�Ӳζ�, 41);
              local skillId="";
              local grade = sewing_plan_grade[seqno];
              if (grade>0) then
                for i=1,grade do
                  local rand = NLG.Rand(1,#player_skillAffixes_list);
                  if i<grade then
                    skillId = skillId .. player_skillAffixes_list[rand]..",";
                  else
                    skillId = skillId .. player_skillAffixes_list[rand];
                  end
                end
                Item.SetData(WeaponIndex, CONST.����_USEFUNC, skillId);
                Item.UpItem(player, newSlot);
                NLG.UpChar(player);
              else
              end]]
end

--Ŀ��ɹ��ʼ���
function prob(count,id)
  for i=1,10 do
      if (sewing_plan_thing[count][i]==id) then
          local prob = ( (11-i)/10 )*100;
          return prob;
      end
  end
  return -1;
end

--�յ��߸�(���������µ���λ��)
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
    return "�o���"
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
