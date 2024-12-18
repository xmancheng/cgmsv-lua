---ģ����
local Module = ModuleBase:createModule(pokeSlot)

local slot_roll_1 = {149000,149003,149012,149015,149038,149039,149054};
local slot_roll_2 = {149000,149003,149012,149015,149038,149039,149054};
local slot_roll_3 = {149000,149003,149012,149015,149038,149039,149054};
local slot_Lotto_list_triple = {66668,10};
local slot_Lotto_list_dual = {66668,4};

-------------------------------------------------
--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load');
  self.slotMachineNPC = self:NPC_createNormal('�������ԙC', 12950, { x = 225, y = 93, mapType = 0, map = 1000, direction = 0 });
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
              local seqno = page - 1000;
              local msg = "@c�������������ԙC��\\n"
                       .. "������$1-------����ʮ�����ԵĽY�����¡�-------\\n$5"
              local msg = msg .. slotEventInfo(seqno)


              NLG.ShowWindowTalked(player, self.slotMachineNPC, CONST.����_��Ϣ��, CONST.��ť_�ر�, 2000+seqno, msg);
              return
          else
              return
          end
      elseif _select == CONST.��ť_�ر� then
      end
      if _select == CONST.BUTTON_��һҳ then
        if (page==1003) then
          local seqno = page - 1000;
          local msg = "@c�������������ԙC��\\n"
          local msg = msg .. slotEventInfo(seqno);
          NLG.ShowWindowTalked(player, self.slotMachineNPC, CONST.����_��Ϣ��, CONST.��ť_��һҳ, 1000+seqno+1, msg);
        elseif (page==1004) then
          local seqno = page - 1000;
          local msg = "@c�������������ԙC��\\n"
                   .. "������$1-------���������ԵĽY�����¡�-------\\n$5"
          local msg = msg .. slotEventInfo(seqno);

          NLG.ShowWindowTalked(player, self.slotMachineNPC, CONST.����_��Ϣ��, CONST.��ť_�ر�, 2000+seqno, msg);
        end
      elseif _select == 2 then
        return
      end

    else
      --local count = 8 * (warpPage - 1) + column
      --print(count)
      if (column==1) then
          local msg = "@c�������������ԙC��\\n"
          local msg = msg .. slotMachineInfo(column);
          NLG.ShowWindowTalked(player, self.slotMachineNPC, CONST.����_��Ϣ��, CONST.��ť_ȷ���ر�, 1000+column, msg);
      elseif (column==3) then
          local msg = "@c�������������ԙC��\\n"
          local msg = msg .. slotMachineInfo(column);
          NLG.ShowWindowTalked(player, self.slotMachineNPC, CONST.����_��Ϣ��, CONST.��ť_��һҳ, 1000+column, msg);
      end
    end
  end)
  self:NPC_regTalkedEvent(self.slotMachineNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local winButton = CONST.BUTTON_�ر�;
      local msg = "4\\n@c�������������ԙC��\\n"
               .. "����֧��ħ���M�������[���䌦4���š�ͬ��10����\\n\\n\\n"
               .. "����������[�����ԙC10��100�fħ��\\n\\n"
               .. "������δ��[�����ԙC01��010�fħ��\\n"

      NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, winButton, 1, msg);
    end
    return
  end)
end

---------------------------------------------------------------------------------------------------------------
--��Ϣ
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

function slotEventInfo(seqno)
    for k=1,seqno do
        --��һ܉
        local xa = NLG.Rand(1,3);
        for i=1,#slot_roll_1-1-xa do
            a = NLG.Rand(1,i+1+xa);
            temp=slot_roll_1[a];
            slot_roll_1[a]=slot_roll_1[i];
            slot_roll_1[i]=temp;
        end
        local slot_roll_Lotto_1 = {}
        slot_roll_Lotto_1[1]=slot_roll_1[1];
        --�ڶ�܉
        local xb = NLG.Rand(1,3);
        for i=1,#slot_roll_2-1-xb do
            b = NLG.Rand(1,i+1+xb);
            temp=slot_roll_2[b];
            slot_roll_2[b]=slot_roll_2[i];
            slot_roll_2[i]=temp;
        end
        local slot_roll_Lotto_2 = {}
        slot_roll_Lotto_2[1]=slot_roll_2[1];
        --����܉
        local xc = NLG.Rand(1,3);
        for i=1,#slot_roll_3-1-xc do
            c = NLG.Rand(1,i+1+xc);
            temp=slot_roll_3[c];
            slot_roll_3[c]=slot_roll_3[i];
            slot_roll_3[i]=temp;
        end
        local slot_roll_Lotto_3 = {}
        slot_roll_Lotto_3[1]=slot_roll_3[1];
    end

      --����Y���@ʾ
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

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
