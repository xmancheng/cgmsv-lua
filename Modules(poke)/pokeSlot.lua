---ģ����
local Module = ModuleBase:createModule(pokeSlot)

local slot_roll_1 = {101800,101800,101800,101020,101020,101021,101022,101023,101024,101025};	--��һ������
local slot_roll_2 = {101800,101800,101800,101020,101020,101021,101022,101023,101024,101025};	--�ڶ�������
local slot_roll_3 = {101800,101800,101800,101020,101020,101021,101022,101023,101024,101025};	--����������
local slot_Lotto_list_triple = {};		--ͬ������
slot_Lotto_list_triple[101800] = {40844,7};
slot_Lotto_list_triple[101020] = {40844,8};
slot_Lotto_list_triple[101021] = {40844,8};
slot_Lotto_list_triple[101022] = {40844,9};
slot_Lotto_list_triple[101023] = {40844,9};
slot_Lotto_list_triple[101024] = {40844,9};
slot_Lotto_list_triple[101025] = {40844,10};

local slot_Lotto_list_dual = {};		--�ɶԽ���
slot_Lotto_list_dual[101800] = {40844,1};
slot_Lotto_list_dual[101020] = {40844,2};
slot_Lotto_list_dual[101021] = {40844,2};
slot_Lotto_list_dual[101022] = {40844,3};
slot_Lotto_list_dual[101023] = {40844,3};
slot_Lotto_list_dual[101024] = {40844,3};
slot_Lotto_list_dual[101025] = {40844,5};

-------------------------------------------------
--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load');
  self.slotMachineNPC = self:NPC_createNormal('ħ�����ԙC', 400377, { x = 225, y = 93, mapType = 0, map = 1000, direction = 0 });
  self:NPC_regWindowTalkedEvent(self.slotMachineNPC, function(npc, player, _seqno, _select, _data)
    local column = tonumber(_data)
    local page = tonumber(_seqno)
    local warpPage = page;
    local winButton = CONST.BUTTON_�ر�;

    --print(_seqno,_select,_data)
    --��ҳ16 ��ҳ32 �ر�/ȡ��2
    if _select > 0 then
      if _select == CONST.��ť_ȷ�� then
          if (page==1001) then
              Char.AddGold(player, -500000);
              local seqno = page - 1000;
              local msg = "@c������ħ�����ԙC��\\n"
                       .. "������$1-------����������ԵĽY�����¡�-------\\n$5"
              local msg = msg .. slotEventInfo(player,seqno,5)
              local msg = msg .. "\\n\\n\\n\\n\\n\\n����$4�󪄄��ѽ��l�š�"
              NLG.ShowWindowTalked(player, self.slotMachineNPC, CONST.����_��Ϣ��, CONST.��ť_�ر�, 2000+seqno, msg);
              return
          elseif (page==1003) then
              local seqno = page - 1000;
              local msg = "@c������ħ�����ԙC��\\n"
              local msg = msg .. slotEventInfo(player,seqno,1);
              local msg = msg .. "\\n\\n\\n\\n\\n\\n\\n�����������^�̷���K�Y����"
              NLG.ShowWindowTalked(player, self.slotMachineNPC, CONST.����_��Ϣ��, CONST.��ť_��һҳ, 1000+seqno+1, msg);
          else
              return
          end
      elseif _select == CONST.��ť_�ر� then
      end
      if _select == CONST.BUTTON_��һҳ then
        if (page==1004) then
          local seqno = page - 1000;
          local msg = "@c������ħ�����ԙC��\\n"
          local msg = msg .. slotEventInfo(player,seqno,1);
          local msg = msg .. "\\n\\n\\n\\n\\n\\n\\n�����������^�̷���K�Y����"
          NLG.ShowWindowTalked(player, self.slotMachineNPC, CONST.����_��Ϣ��, CONST.��ť_��һҳ, 1000+seqno+1, msg);
        elseif (page==1005) then
          local seqno = page - 1000;
          local msg = "@c������ħ�����ԙC��\\n"
          local msg = msg .. slotEventInfo(player,seqno,1);
          local msg = msg .. "\\n\\n\\n\\n\\n\\n\\n�����������^�̷���K�Y����"
          NLG.ShowWindowTalked(player, self.slotMachineNPC, CONST.����_��Ϣ��, CONST.��ť_��һҳ, 1000+seqno+1, msg);
        elseif (page==1006) then
          Char.AddGold(player, -100000);
          local seqno = page - 1000;
          local msg = "@c������ħ�����ԙC��\\n"
                   .. "������$1-------���������ԵĽY�����¡�-------\\n$5"
          local msg = msg .. slotEventInfo(player,seqno,1);
          local msg = msg .. "\\n\\n\\n\\n\\n\\n����$4�󪄄��ѽ��l�š�"
          NLG.ShowWindowTalked(player, self.slotMachineNPC, CONST.����_��Ϣ��, CONST.��ť_�ر�, 2000+seqno, msg);
        end
      elseif _select == 2 then
        return
      end

    else
      --local count = 8 * (warpPage - 1) + column
      --print(count)
      if (column==1) then
          if (Char.GetData(player, CONST.����_���)<500000) then
            NLG.SystemMessage(player,"[ϵ�y]����������Ų���50�f��");
            return
          end
          local msg = "@c������ħ�����ԙC��\\n"
          local msg = msg .. slotMachineInfo(column);
          local msg = msg .. "\\n\\n\\n\\n\\n\\n\\n���������Ԝʂ��_ʼ.�c���_����"
          NLG.ShowWindowTalked(player, self.slotMachineNPC, CONST.����_��Ϣ��, CONST.��ť_ȷ���ر�, 1000+column, msg);
      elseif (column==3) then
          if (Char.GetData(player, CONST.����_���)<100000) then
            NLG.SystemMessage(player,"[ϵ�y]����������Ų���10�f��");
            return
          end
          local msg = "@c������ħ�����ԙC��\\n"
          local msg = msg .. slotMachineInfo(column);
          local msg = msg .. "\\n\\n\\n\\n\\n\\n\\n���������Ԝʂ��_ʼ.�c���_����"
          NLG.ShowWindowTalked(player, self.slotMachineNPC, CONST.����_��Ϣ��, CONST.��ť_ȷ���ر�, 1000+column, msg);
      end
    end
  end)
  self:NPC_regTalkedEvent(self.slotMachineNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local winButton = CONST.BUTTON_�ر�;
      local msg = "4\\n@c������ħ�����ԙC��\\n"
               .. "����֧��ħ���M�������[��\\n"
               .. "�����Ɍ�1-5��ͬ��7-10ˮ�{�����\\n\\n"
               .. "����������[�����ԙC5��  50�fħ��\\n\\n"
               .. "������δ��[�����ԙC1��  10�fħ��\\n"

      NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, winButton, 1, msg);
    end
    return
  end)
end

---------------------------------------------------------------------------------------------------------------
--��ʼҳ��
function slotMachineInfo(column)
      local msg = "";
      local slot_roll_image_1 = slot_roll_1[1];
      local slot_roll_image_2 = slot_roll_2[1];
      local slot_roll_image_3 = slot_roll_3[1];
      local imageText_1 = "@g,"..slot_roll_image_1..",3,6,4,0@"
      local imageText_2 = "@g,"..slot_roll_image_2..",10,6,4,0@"
      local imageText_3 = "@g,"..slot_roll_image_3..",17,6,4,0@"
      msg = msg .. "  " .. imageText_1 .. "  " .. imageText_2 .. "  " .. imageText_3
      return msg;
end
--����ִ�к�ҳ��
function slotEventInfo(player,seqno,count)
      local goalSet = NLG.Rand(1,#slot_roll_1);		--��ê��
      for k=1,count do
        --��һ��
        local xa = NLG.Rand(1,3);
        for i=1,#slot_roll_1-1-xa do
            a = NLG.Rand(1,i+1+xa);
            temp=slot_roll_1[a];
            slot_roll_1[a]=slot_roll_1[i];
            slot_roll_1[i]=temp;
        end
        --�ڶ���
        local xb = NLG.Rand(1,3);
        for i=1,#slot_roll_2-1-xb do
            b = NLG.Rand(1,i+1+xb);
            temp=slot_roll_2[b];
            slot_roll_2[b]=slot_roll_2[i];
            slot_roll_2[i]=temp;
        end
        --������
        local xc = NLG.Rand(1,3);
        for i=1,#slot_roll_3-1-xc do
            c = NLG.Rand(1,i+1+xc);
            temp=slot_roll_3[c];
            slot_roll_3[c]=slot_roll_3[i];
            slot_roll_3[i]=temp;
        end

        local ImageId,eventCheck = slotMachineCheck(slot_roll_1[goalSet],slot_roll_2[goalSet],slot_roll_3[goalSet])

        if (seqno==1 or seqno==6) then
          if (ImageId>0 and eventCheck==3) then			--ͬ��
            Char.GiveItem(player, slot_Lotto_list_triple[ImageId][1], slot_Lotto_list_triple[ImageId][2]);
          elseif (ImageId>0 and eventCheck==2) then		--�ɶ�
            Char.GiveItem(player, slot_Lotto_list_dual[ImageId][1], slot_Lotto_list_dual[ImageId][2]);
          end
        end
        NLG.SortItem(player);
      end

      --�����ʾ
      local msg = "";
      local slot_roll_image_1 = slot_roll_1[goalSet];
      local slot_roll_image_2 = slot_roll_2[goalSet];
      local slot_roll_image_3 = slot_roll_3[goalSet];
      local imageText_1 = "@g,"..slot_roll_image_1..",3,6,4,0@"
      local imageText_2 = "@g,"..slot_roll_image_2..",10,6,4,0@"
      local imageText_3 = "@g,"..slot_roll_image_3..",17,6,4,0@"
      msg = msg .. "  " .. imageText_1 .. "  " .. imageText_2 .. "  " .. imageText_3
      return msg;
end
--�����ж�
function slotMachineCheck(roll_a,roll_b,roll_c)
     local ImageId = 0;
     local eventCheck = 0;
     if roll_a==roll_b and roll_a==roll_c and roll_b==roll_c then
       local ImageId = roll_a;
       local eventCheck = 3;
       return ImageId,eventCheck;
     elseif roll_a~=roll_b and roll_a~=roll_c and roll_b~=roll_c then
       local ImageId = 0;
       local eventCheck = 0;
       return ImageId,eventCheck;
     else
       local eventCheck = 2;
       if roll_a==roll_b and roll_a~=roll_c then
         ImageId = roll_a;
       elseif roll_a==roll_c and roll_a~=roll_b then
         ImageId = roll_a;
       elseif roll_b==roll_c and roll_b~=roll_a then
         ImageId = roll_b;
       end
       return ImageId,eventCheck;
     end

     return ImageId,eventCheck;
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
