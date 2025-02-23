---ģ����
local Module = ModuleBase:createModule(convertPlans)

--�����������
local convert_plan_name = {};
local convert_plan_offering = {};
local convert_plan_item = {};
local convert_plan_gold = {};
local convert_plan_pet = {};
--
convert_plan_name[1] = "��150D�����_��";
convert_plan_offering[1] = {700103,700109,700118};
convert_plan_item[1] = {70268};
convert_plan_gold[1] =5000;
convert_plan_pet[1] = {700201,700201,700201,700201,700201,700201,700201,700201,700201,700201};

convert_plan_name[2] = "��150D��������";
convert_plan_offering[2] = {700101,700107,700113};
convert_plan_item[2] = {70268};
convert_plan_gold[2] =5000;
convert_plan_pet[2] = {700202,700202,700202,700202,700202,700202,700202,700202,700202,700202};

convert_plan_name[3] = "��150D��С��ȸ";
convert_plan_offering[3] = {700102,700108,700117};
convert_plan_item[3] = {70268};
convert_plan_gold[3] =5000;
convert_plan_pet[3] = {700203,700203,700203,700203,700203,700203,700203,700203,700203,700203};

convert_plan_name[4] = "��150D�����R����";
convert_plan_offering[4] = {700121,700119,700120};
convert_plan_item[4] = {70268};
convert_plan_gold[4] =10000;
convert_plan_pet[4] = {700121,700121,700204,700204,700204,700204,700204,700204,700204,700204};

convert_plan_name[5] = "��150D�������n";
convert_plan_offering[5] = {700104,700105,700106};
convert_plan_item[5] = {70268};
convert_plan_gold[5] =10000;
convert_plan_pet[5] = {700104,700104,700205,700205,700205,700205,700205,700205,700205,700205};

convert_plan_name[6] = "��150D��¶������";
convert_plan_offering[6] = {700210,700126,700133};
convert_plan_item[6] = {70268};
convert_plan_gold[6] =15000;
convert_plan_pet[6] = {700210,700210,700210,700210,700206,700206,700206,700206,700206,700206};

convert_plan_name[7] = "��150D���������ךW";
convert_plan_offering[7] = {700210,700125,700131};
convert_plan_item[7] = {70268};
convert_plan_gold[7] =15000;
convert_plan_pet[7] = {700210,700210,700210,700210,700207,700207,700207,700207,700207,700207};

convert_plan_name[8] = "��160D���ο���Ɲ��";
convert_plan_offering[8] = {700209,700206,700207};
convert_plan_item[8] = {70268};
convert_plan_gold[8] =15000;
convert_plan_pet[8] = {700209,700209,700209,700208,700208,700208,700208,700208,700208,700208};

convert_plan_name[9] = "��150D���w�W��";
convert_plan_offering[9] = {700132,700112,700118};
convert_plan_item[9] = {70268};
convert_plan_gold[9] =15000;
convert_plan_pet[9] = {700132,700132,700132,700132,700213,700213,700213,700213,700213,700213};

convert_plan_name[10] = "��150D��������";
convert_plan_offering[10] = {700127,700119,700117};
convert_plan_item[10] = {70268};
convert_plan_gold[10] =15000;
convert_plan_pet[10] = {700127,700127,700127,700127,700214,700214,700214,700214,700214,700214};

convert_plan_name[11] = "��150D���ҿ���";
convert_plan_offering[11] = {700124,700111,700116};
convert_plan_item[11] = {70268};
convert_plan_gold[11] =15000;
convert_plan_pet[11] = {700124,700124,700124,700124,700215,700215,700215,700215,700215,700215};

convert_plan_name[12] = "��150D���P�_˹";
convert_plan_offering[12] = {700123,700110,700107};
convert_plan_item[12] = {70268};
convert_plan_gold[12] =15000;
convert_plan_pet[12] = {700123,700123,700123,700123,700216,700216,700216,700216,700216,700216};

convert_plan_name[13] = "��150D���������_˹";
convert_plan_offering[13] = {700123,700110,700107};
convert_plan_item[13] = {70268};
convert_plan_gold[13] =15000;
convert_plan_pet[13] = {700123,700123,700123,700123,700217,700217,700217,700217,700217,700217};

convert_plan_name[14] = "��150D�����ӹ�";
convert_plan_offering[14] = {700125,700112,700113};
convert_plan_item[14] = {70268};
convert_plan_gold[14] =15000;
convert_plan_pet[14] = {700125,700125,700125,700125,700218,700218,700218,700218,700218,700218};

convert_plan_name[15] = "��150D�����񠖵�";
convert_plan_offering[15] = {700120,700119,700121};
convert_plan_item[15] = {70268};
convert_plan_gold[15] =25000;
convert_plan_pet[15] = {700120,700120,700120,700120,700120,700120,700120,700219,700219,700219};

convert_plan_name[16] = "��150D������";
convert_plan_offering[16] = {700102,700101,700103};
convert_plan_item[16] = {70268};
convert_plan_gold[16] =25000;
convert_plan_pet[16] = {700102,700102,700102,700102,700102,700102,700102,700220,700220,700220};
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
          for i = 1,8 do
             msg = msg .. "�������Ŀ "..i.."��".. convert_plan_name[i] .. "\\n"
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
                                  .. "������$1��Ҫ�������в��ϲ����M�Ю�׃����\\n$5"
              local msg = msg .. convertOfferingInfo(seqno)
              NLG.ShowWindowTalked(player, self.converterNPC, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 2000+seqno, msg);
              return
          else
              return
          end
      elseif _select == CONST.��ť_�ر� then
          if (page>=1001) then
              local winButton = CONST.BUTTON_�ر�;
              local msg = "1\\n���������������������ﮐ׃���졿\\n"
              for i = 1,8 do
                 msg = msg .. "�������Ŀ "..i.."��".. convert_plan_name[i] .. "\\n"
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
              convertMutation(seqno,player)
              return
          else
              return
          end
      elseif _select == CONST.��ť_�� then
          if (page>=2001) then
              local count = page - 2000;
              local msg = "���������������������ﮐ׃���졿\\n"
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
            winMsg = winMsg .. "�������Ŀ "..i.."��".. convert_plan_name[i] .. "\\n"
        end
      else
        for i = 1 + count, 8 + count do
            winMsg = winMsg .. "�������Ŀ "..i.."��".. convert_plan_name[i] .. "\\n"
        end
      end
      NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, winButton, warpPage, winMsg);
    else
      local count = 8 * (warpPage - 1) + column
      --print(count)
      local msg = "���������������������ﮐ׃���졿\\n"
      local msg = msg .. convertGoalInfo(count);
      NLG.ShowWindowTalked(player, self.converterNPC, CONST.����_��Ϣ��, CONST.��ť_ȷ���ر�, 1000+count, msg);
    end
  end)
  self:NPC_regTalkedEvent(self.converterNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local winButton = CONST.BUTTON_�ر�;
      local msg = "1\\n���������������������ﮐ׃���졿\\n"
      for i = 1,8 do
         msg = msg .. "�������Ŀ "..i.."��".. convert_plan_name[i] .. "\\n"
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
      local msg = imageText .. "����$4".. Goal_name .. "\\n"
                         .. "��������������" .. "$1�w�� ".. Goal_DataPos_4+2 .."��" .. "$8�ؚ� ".. Goal_DataPos_13 .."��" .. "$8���� ".. Goal_DataPos_27 .."\\n"
                         .. "��������������" .. "$1���� ".. Goal_DataPos_5+2 .."��" .. "$8���� ".. Goal_DataPos_12 .."��" .. "$8�W�� ".. Goal_DataPos_26 .."\\n"
                         .. "��������������" .. "$1���� ".. Goal_DataPos_6+2 .."��" .. "$2���� ".. Goal_DataPos_18 .."��" .. "$2���� ".. Goal_DataPos_19 .."\\n"
                         .. "��������������" .. "$1�ٶ� ".. Goal_DataPos_7+2 .."��" .. "$2��˯ ".. Goal_DataPos_20 .."��" .. "$2���� ".. Goal_DataPos_21 .."\\n"
                         .. "��������������" .. "$1ħ�� ".. Goal_DataPos_8+2 .."��" .. "$2��ʯ ".. Goal_DataPos_22 .."��" .. "$2���� ".. Goal_DataPos_23 .."\\n"
                         .. "��������������" .. "$5�� ".. Goal_DataPos_14/10 .."��" .."$5ˮ ".. Goal_DataPos_15/10 .."��" .."$5�� ".. Goal_DataPos_16/10 .."��" .."$5�L ".. Goal_DataPos_17/10 .."\\n"
                         .. "��������������" .. "$9�N�� ".. Goal_DataPos_3 .."��" .. "$9���ܸ� ".. Goal_DataPos_28 .."\\n"
      return msg;
end

--��Ʒ��Ϣ
function convertOfferingInfo(seqno)
              local msg = "";
              for i = 1,#convert_plan_offering[seqno] do
                  local EnemyDataIndex_i = Data.EnemyGetDataIndex(convert_plan_offering[seqno][i]);
                  local enemyBaseId_i = Data.EnemyGetData(EnemyDataIndex_i, CONST.Enemy_Base���);
                  local EnemyBaseDataIndex_i = Data.EnemyBaseGetDataIndex(enemyBaseId_i);
                  local offering_name_i = Data.EnemyBaseGetData(EnemyBaseDataIndex_i, CONST.EnemyBase_����);
                  local offering_image_i = Data.EnemyBaseGetData(EnemyBaseDataIndex_i, CONST.EnemyBase_����);
                  local offering_image_ix = 3 + 7*(i-1);
                  local imageText_i = "@g,"..offering_image_i..","..offering_image_ix..",6,4,0@"
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
                  --msg = msg .. spaceMsg .. offering_name_i .. "Lv1" .. spaceMsg .. imageText_i
                  msg = msg .. spaceMsg .. offering_name_i .. "  " .. spaceMsg .. imageText_i
              end
              local Gold = convert_plan_gold[seqno];
              local ItemsetIndex = Data.ItemsetGetIndex(convert_plan_item[seqno][1]);
              local Item_name= Data.ItemsetGetData( ItemsetIndex, CONST.ITEMSET_TRUENAME);
              local probRate = prob(seqno,convert_plan_pet[seqno][10]);
              local msg = msg .. "\\n\\n\\n\\n\\n��$5����: ".. Item_name .. "1��" .. "����$5ħ��: " .. Gold .. " G\\n"
                                              .. "��$4�ɹ��C��: ".. probRate .. "%" .. "����$9ע��: ���h�H���²��ό�"
      return msg;
end

--������ִ��
function convertMutation(seqno,player)
              if (Char.ItemNum(player, convert_plan_item[seqno][1])==0) then
                  NLG.SystemMessage(player,"[ϵ�y]ȱ�ٸ�����OӋ�D��");
                  return
              end
              if (Char.GetData(player, CONST.����_���)<convert_plan_gold[seqno]) then
                  NLG.SystemMessage(player,"[ϵ�y]����������Ų��㡣");
                  return
              end
              for i = 1,#convert_plan_offering[seqno] do
                  local petSlot = Char.HavePet(player, convert_plan_offering[seqno][i]);
                  if (petSlot>=0) then
                      local petIndex = Char.GetPet(player,petSlot);
                      --if (Char.GetData(petIndex,CONST.����_�ȼ�)>=2) then
                      --    NLG.SystemMessage(player,"[ϵ�y]�������茙���Lv1��");
                      --    return
                      --end
                  else
                      NLG.SystemMessage(player,"[ϵ�y]ȱ�ٸ������茙�");
                      return
                  end
              end
              Char.DelItem(player, convert_plan_item[seqno][1], 1);
              Char.AddGold(player, -convert_plan_gold[seqno]);
              local randCatch= NLG.Rand(1, #convert_plan_pet[seqno] );
              for i = 1,#convert_plan_offering[seqno] do
                  --Char.DelPet(player, convert_plan_offering[seqno][i], 1, 1);
                  Char.DelPet(player, convert_plan_offering[seqno][i], 1, 2);
              end
              Char.GivePet(player,convert_plan_pet[seqno][randCatch],0);
end

--Ŀ��ɹ��ʼ���
function prob(count,id)
  for i=1,10 do
      if (convert_plan_pet[count][i]==id) then
          local prob = ( (11-i)/10 )*100;
          return prob;
      end
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
