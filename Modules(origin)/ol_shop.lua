local Module = ModuleBase:createModule('ol_shop')
local itemList = {
  { name = 'ĸ��֮��', image = 27075, price = 100000, desc = '����󋌋�ʯ����ٛ�c���殐֮��', count = 1, maxCount = 1,  itemid = 16447 },
  { name = '������ҩ', image = 26206, price = 50000, desc = '�����·��������c����ʹ������׃', count = 1, maxCount = 1,  itemid = 45745 },
  { name = '���ֱ�־', image = 252025, price = 500, desc = '���턂���@������]��õ��^�,���ֵ��C��', count = 1, maxCount = 1,  itemid = 607728 },
  { name = '��ղ�����ȫñ', image = 27933, price = 5000, desc = '�����Á�֓��܂�һ�ٴΣ�ʷ����İ�ȫñ', count = 1, maxCount = 1,  itemid = 45987 },
  { name = '�����ػ���', image = 99194, price = 50000, desc = '�b���Ͼ͕��������ߵı��o�������p���u��ħ��', count = 1, maxCount = 1,  itemid = 34638 },
  { name = 'ˮ������', image = 26364, price = 500, desc = '�����H����+10', count = 1, maxCount = 20,  itemid = 280 },
}

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  shopNPC = self:NPC_createNormal('�����̵�', 101024, { map = 1000, x = 220, y = 88, direction = 4, mapType = 0 })
  self:NPC_regTalkedEvent(shopNPC, Func.bind(self.onSellerTalked, self))
  self:NPC_regWindowTalkedEvent(shopNPC, Func.bind(self.onSellerSelected, self));
  self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self));
end

function Module:handleTalkEvent(charIndex,msg,color,range,size)
	if (msg=="/shop") then
      self:onSellerTalked(shopNPC, charIndex);
	  return 0;
	end
	return 1;
end

function Module:onSellerTalked(npc, player)
  if (NLG.CanTalk(npc, player) == true) then
      NLG.ShowWindowTalked(player, npc, CONST.����_�̵���, CONST.BUTTON_��, 0,
         self:NPC_buildBuyWindowData(101024, '�����̵�', 'ѡ����Ҫ����Ʒ', '��Ǯ����', '��������', itemList))
  elseif (NLG.CanTalk(npc, player) == false and npc==shopNPC) then
      NLG.ShowWindowTalked(player, npc, CONST.����_�̵���, CONST.BUTTON_��, 0,
         self:NPC_buildBuyWindowData(101024, '�����̵�', 'ѡ����Ҫ����Ʒ', '��Ǯ����', '��������', itemList))
  end
  return
end

function Module:onSellerSelected(npc, player, seqNo, select, data)
    local items = string.split(data, '|');
    --local itemList = itemList;
    for key = 1, #items / 2 do
      local c = itemList[items[(key - 1) * 2 + 1] + 1]
      if c then
        count = (tonumber(items[(key - 1) * 2 + 2]) or 0);
        if c.maxCount > 0 then
             maxCount = c.maxCount - count;
             totalGold = c.price * count;
             --keyNum = items[(key - 1) * 2 + 1] + 1;
        else
             maxCount = c.maxCount;
             NLG.SystemMessage(player,"[ϵͳ]����Ʒ�ֿ����޴����");
             return;
        end
        if c.itemid > 1 then
             itemid = c.itemid;
        else
             itemid = -1;
        end
      end
      if itemid == -1 then  ----�ų�͸����ťȡ�õ���
            return;
      end
      --[[if maxCount < 0 then
           NLG.SystemMessage(player,"[ϵͳ]����������棡");
           return;
      end]]
      if Char.GetData(player,CONST.����_���) < totalGold then
           NLG.SystemMessage(player,"[ϵͳ]ħ�Ҳ����޷�����");
           return;
      end
      if ( Char.GetData(player,CONST.����_������) - 8 - Char.ItemSlot(player) >= math.ceil(count/c.maxCount) ) then
          --itemList[keyNum][3] = itemList[keyNum][3] - count;
          Char.GiveItem(player,itemid,count);
          Char.AddGold(player, -totalGold)
          --[[for NewItemSlot = 8,27 do
              local NewItemIndex = Char.GetItemIndex(player, NewItemSlot);
              if (NewItemIndex > 0) then
                if (Item.GetData(NewItemIndex, CONST.����_�Ѽ���)==0) then
                  Item.SetData(NewItemIndex, CONST.����_�Ѽ���, 1);
                  Item.UpItem(player, NewItemSlot);
                  NLG.UpChar(player);
                end
              end
          end]]
      else
          NLG.Say(player, -1, "����������Ʒ����", CONST.��ɫ_��ɫ, CONST.����_��);
          return;
      end
   end
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
