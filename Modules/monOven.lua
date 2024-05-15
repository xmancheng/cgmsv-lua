---ģ����
local Module = ModuleBase:createModule('monOven')

local reelList = {
  {14801,2,73801},{16900,90,73801},
}

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('ItemString', Func.bind(self.roastTools, self),"LUA_useOven");
  self.bakerNPC = self:NPC_createNormal('ħ���˿�����', 14682, { x = 38, y = 33, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.bakerNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local winMsg = "2\\nՈ�x��Ҫ����Mȥ���t�Ĳ��(������ʧ)��\\n�������ЙC��ȡ��ϡ�е�ħ�����S\\n";
        for wasteSlot = 23,27 do
            WasteIndex = Char.GetItemIndex(player,wasteSlot);
            if (WasteIndex>0) then
                 WasteID = Item.GetData(WasteIndex,CONST.����_ID);
                 WasteLv = Item.GetData(WasteIndex,CONST.����_�ȼ�);
                 --WasteType = Item.GetData(WasteIndex,CONST.����_����);
                 WasteName = Item.GetData(WasteIndex, CONST.����_����);
                 local checkWaste = GrillingMaterials(player,wasteSlot);
                 if (checkWaste==1) then
                                  winMsg = winMsg .. "��".. wasteSlot-7 .."��:��" .. WasteName .. "��[��ӣ�]\\n"
                 elseif (checkWaste==0) then
                                  winMsg = winMsg .. "��".. wasteSlot-7 .."��:��" .. WasteName .. "��[��ӣ�]\\n"
                 end
            else
                 winMsg = winMsg .. "��".. wasteSlot-7 .."��:  �o��Ʒ" .. "\\n"
            end
        end
        NLG.ShowWindowTalked(player, self.bakerNPC, CONST.����_ѡ���, CONST.BUTTON_�ر�, 1, winMsg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.bakerNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --�տ�����
    local OvenIndex =Char.HaveItemID(player, ItemID);
    local OvenSlot = Char.FindItemId(player, ItemID);
    local OvenDur = Item.GetData(OvenIndex, CONST.����_�;�) or 0;
    local OvenDurMax = 10000;
    if select > 0 then
      --ȷ�ϲ���ִ��
      if (seqno == 12 and select == CONST.BUTTON_��) then
                 return;
      elseif (seqno == 12 and select == CONST.BUTTON_��)  then
                 --Char.DelItem(player, WasteID, 1);
                 Char.DelItemBySlot(player, wasteSlot);
                 Item.SetData(OvenIndex,CONST.����_�;�, OvenDur+WasteLv);
                 Item.SetData(OvenIndex,CONST.����_����;�, OvenDurMax);
                 Item.UpItem(OvenIndex, OvenSlot);
                 NLG.UpChar(player);
      else
                 return;
      end
    else
      local wasteSlot=data+22;
      local WasteIndex = Char.GetItemIndex(player,wasteSlot);
      --ѡ����
      if (seqno == 1 and select == CONST.��ť_�ر�) then
                 return;
      elseif (seqno == 1 and WasteIndex<0) then
                 NLG.SystemMessage(player, "[ϵ�y]��Ʒ�ڟo��Ʒ��");
                 return;
      end
      if (seqno == 1 and data>0) then
          local checkWaste,whatWaste = GrillingMaterials(player,wasteSlot);
          if (checkWaste==0) then
                 NLG.SystemMessage(player, "[ϵ�y]�o������M���t�Ĳ��");
                 return;
          end
          if (WasteIndex ~=nil) then
                local msg = "���˟����ÿ��t��\\n"
                                           .."�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
                                           .."���������N���Ĳ���\\n"
                                           .."\\n���������Q:".. WasteName .."����Lv:"..WasteLv.."\\n"
                                           .."\\n��������������������������\\n"
                                           .."\\n�Ƿ�_������������Mȥ���t�أ�\\n";
                 NLG.ShowWindowTalked(player, self.bakerNPC, CONST.����_��Ϣ��, CONST.BUTTON_�Ƿ�, 12, msg);
          end
      else
                 return;
      end
    end
  end)


end


function Module:roastTools(charIndex,targetIndex,itemSlot)
    ItemID = Item.GetData(Char.GetItemIndex(charIndex,itemSlot),0);
    OvenSlot =itemSlot;
    local OvenIndex = Char.GetItemIndex(charIndex,itemSlot);
        local winMsg = "2\\nՈ�x��Ҫ����Mȥ���t�Ĳ��(������ʧ)��\\n�������ЙC��ȡ��ϡ�е�ħ�����S\\n";
        for wasteSlot = 23,27 do
            WasteIndex = Char.GetItemIndex(charIndex,wasteSlot);
            if (WasteIndex>0) then
                 WasteID = Item.GetData(WasteIndex,CONST.����_ID);
                 WasteLv = Item.GetData(WasteIndex,CONST.����_�ȼ�);
                 WasteType = Item.GetData(WasteIndex,CONST.����_����);
                 WasteName = Item.GetData(WasteIndex, CONST.����_����);
                 local checkWaste = GrillingMaterials(charIndex,wasteSlot);
                 if (checkWaste==1) then
                                  winMsg = winMsg .. "��".. wasteSlot-7 .."��:��" .. WasteName .. "��[��ӣ�]\\n"
                 elseif (checkWaste==0) then
                                  winMsg = winMsg .. "��".. wasteSlot-7 .."��:��" .. WasteName .. "��[��ӣ�]\\n"
                 end
            else
                 winMsg = winMsg .. "��".. wasteSlot-7 .."��:  �o��Ʒ" .. "\\n"
            end
        end
        NLG.ShowWindowTalked(charIndex, self.bakerNPC, CONST.����_ѡ���, CONST.BUTTON_�ر�, 1, winMsg);
    return 1;
end

function GrillingMaterials(player,wasteSlot)
          local WasteIndex = Char.GetItemIndex(player,wasteSlot);
          local WasteID = Item.GetData(WasteIndex,CONST.����_ID);
          local checkWaste=0;
          local whatWaste=-1;
          table.forEach(reelList, function(e)
              for k=1,#reelList do
                  if (e[k][1]==WasteID) then
                     checkWaste=1;
                     whatWaste=e;
                     return checkWaste,whatWaste;
                  else
                     checkWaste=0;
                  end
              end
          end)
          return checkWaste,whatWaste;
end
--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
