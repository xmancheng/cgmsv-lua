---ģ����
local Module = ModuleBase:createModule('mysteryShop')

local itemData = {
    {"Lv1���S����",900611,10,10},
    {"Lv2���S����",900612,10,30},
    {"Lv3���S����",900613,5,100},
    {"Lv6���S����",900616,3,400},
    {"Lv7���S����",900617,1,500},
    {"��Ŀ���ܵľ��S",73810,2,200},
    {"Ѫ��֮�еľ��S",73911,2,200},
    {"���L֮�еľ��S",73914,2,200},
    {"؈�ܵľ��S",73811,1,250},
    {"�𾫵ľ��S",73898,2,200},
    {"�L���ľ��S",73899,2,200},
    {"ˮ���ľ��S",73900,2,200},
    {"�ؾ��ľ��S",73901,2,200},
    {"��������ľ��S",73933,2,200},
    {"���L�����ľ��S",73936,2,200},
    {"����صľ��S",73841,1,250},
    {"�S��侫�ľ��S",73877,1,250},
    {"�����ľ��S",73937,1,250},
    {"ˮ�{��ľ��S",73816,2,200},
    {"�������ľ��S",73867,2,200},
    {"��Ŀ���ľ��S",73868,2,200},
    {"�������ľ��S",73869,2,200},
    {"���۾��˵ľ��S",73947,2,200},
    {"������˹����ľ��S",73949,2,200},
    {"�����ľ��S",73817,1,250},
}

local itemFields={
{CONST.����_����,CONST.ITEMSET_MODIFYATTACK,"����"},
{CONST.����_����,CONST.ITEMSET_MODIFYDEFENCE,"���R"},
{CONST.����_����,CONST.ITEMSET_MODIFYAGILITY,"����"},
{CONST.����_����,CONST.ITEMSET_MODIFYMAGIC,"����"},
{CONST.����_�ظ�,CONST.ITEMSET_MODIFYRECOVERY,"�؏�"},
{CONST.����_��ɱ,CONST.ITEMSET_MODIFYCRITICAL,"�ؚ�"},
{CONST.����_����,CONST.ITEMSET_MODIFYCOUNTER,"����"},
{CONST.����_����,CONST.ITEMSET_MODIFYHITRATE,"����"},
{CONST.����_����,CONST.ITEMSET_MODIFYAVOID,"�W��"},
{CONST.����_����,CONST.ITEMSET_MODIFYHP,"����"},
{CONST.����_ħ��,CONST.ITEMSET_MODIFYFORCEPOINT,"ħ��"},
{CONST.����_����,CONST.ITEMSET_POISON,"����"},
{CONST.����_˯��,CONST.ITEMSET_SLEEP,"��˯"},
{CONST.����_ʯ��,CONST.ITEMSET_STONE,"��ʯ"},
{CONST.����_��,CONST.ITEMSET_DRUNK,"����"},
{CONST.����_�ҿ�,CONST.ITEMSET_CONFUSION,"���y"},
{CONST.����_����,CONST.ITEMSET_AMNESIA,"����"},
{CONST.����_�ȼ�,CONST.ITEMSET_LEVEL,"�ȼ�"},
{CONST.����_�;�,CONST.ITEMSET_REMAIN,"�;�"},
{CONST.����_����;�,CONST.ITEMSET_MAXREMAIN,"����;�"},
{CONST.����_����,CONST.ITEMSET_TYPE,"������Ƭ"},
{CONST.����_�Ӳ�һ,CONST.ITEMSET_SPECIALEFFECTVALUE,"SPECIALEFFECTVALUE"},
{CONST.����_�ѵ���,CONST.ITEMSET_COST,"����"},
}
--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self.mysteryNPC = self:NPC_createNormal('�����̵�', 98972, { x = 103, y = 199, mapType = 0, map = 25006, direction = 0 });
  self:NPC_regTalkedEvent(self.mysteryNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        -- �ص� data = 1:��, 2:��
        -- ���ݽṹ NPCͼ��|���ڱ���|NPC�Ի�|�������� 0:�ް�ť, 1:��, 2:��, 3:����|
        local windowStr = '98972|�����̵�|�S�C��Ʒ����������\n��Ʒ�����r���|1|'
        NLG.ShowWindowTalked(player, self.mysteryNPC, CONST.����_������, CONST.BUTTON_�ر�, 1, windowStr);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.mysteryNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    --local data = tonumber(_data)
    local cdk = Char.GetData(player,CONST.����_CDK);
    if seqno == 1 then
     local data = tonumber(_data)
     if data == 1 then
        local xr = NLG.Rand(1,3);
        for i=1,#itemData-1-xr do
                r = NLG.Rand(1,i+1+xr);
                temp=itemData[r];
                itemData[r]=itemData[i];
                itemData[i]=temp;
        end
        itemList={};
        itemList = itemData;
        -- �ص� data = 0:��Ʒ���(���ڱ��ν���)|N:��������|��Ʒ2���|��Ʒ2����...
        -- ���ݽṹ NPCͼ��|���ڱ���|NPC�Ի�|Ǯ�����Ի�|�ò��»����������Ի�|��ƷN����|��ƷNͼ��|��ƷN�۸�|��ƷN����|��ƷN����|�ɷ���, 0����, 1��|
        local windowStr = '98972|�����̵�|�ޕr�������s�o��ُ\n��ʽ���ӵľ��SŶ\n\n��ÿ��ֻȡ��ͬ�ġ�|\n���X����|\n���ò�����|';
        for im=1,5 do
            local ItemsetIndex = Data.ItemsetGetIndex(itemList[im][2]);
            if (ItemsetIndex>0) then
                 --local ItemName = Item.GetData(ItemIndex, CONST.����_����);
                 local ItemName = Data.ItemsetGetData(ItemsetIndex, CONST.ITEMSET_TRUENAME);
                 --local ItemImage = Item.GetData(ItemIndex, CONST.����_ͼ);
                 local ItemImage = Data.ItemsetGetData(ItemsetIndex, CONST.ITEMSET_BASEIMAGENUMBER);
                 local ItemInfo = self:extractItemData(ItemsetIndex);
                 local ItemMsg = "$1";
                 for k,v in pairs(itemFields) do
                     if ItemInfo.attr[tostring(v[1])] ~=nil  then
                         local param = v[3];
                         --print(param)
                         if param=="�;�" then
                             ItemMsg = ItemMsg .. "\\n$4"..param .." 0100"
                         elseif param=="����;�" then
                             ItemMsg = ItemMsg .. "/0100"
                         elseif param=="�ȼ�" then
                             ItemMsg = ItemMsg .. " $4�ȼ� $4".. ItemInfo.attr[tostring(v[1])] ..""
                         elseif param=="������Ƭ" then
                             ItemMsg = ItemMsg .. " $0�N� ������Ƭ"
                         elseif param=="SPECIALEFFECTVALUE" then
                             partMsg = WhichPart(ItemInfo.attr[tostring(v[1])]);
                             ItemMsg = ItemMsg .. "\\n".. partMsg[1] ..""
                         elseif param=="����" then
                             ItemMsg = ItemMsg .. "\\n\\n�}��ʣ�N����: ".. tonumber(itemList[im][3]) ..""
                         else
                             if (ItemInfo.attr[tostring(v[1])]~=0) then
                                 ItemMsg = ItemMsg .. param .."+".. ItemInfo.attr[tostring(v[1])] .." "
                             end
                         end
                     end
                 end
                 windowStr = windowStr..''..ItemName..'|'..ItemImage..'|0|'..ItemMsg..'|41|1|';
                 local price = tonumber(itemList[im][4]);
                 local maxCount = tonumber(itemList[im][3]);
                 local itemid = tonumber(itemList[im][2]);
                 itemList[im] = {name='..ItemName..', image='..ItemImage..', price=price, desc='..ItemMsg..', count=1, maxCount=maxCount, itemid=itemid};
            end
        end
        NLG.ShowWindowTalked(player, self.mysteryNPC, CONST.����_���, CONST.BUTTON_�ر�, 11, windowStr);
    end
    if seqno == 11 then
       local data = tostring(_data)
       if (select == CONST.��ť_�ر�) then
                 return;
       end
       local items = string.split(data, '|');
       local itemList = itemList;
       for key = 1, #items / 2 do
         local c = itemList[items[(key - 1) * 2 + 1] + 1]
         if c then
           count = (tonumber(items[(key - 1) * 2 + 2]) or 0);
           if c.maxCount > 0 then
             maxCount = c.maxCount - count;
             totalGold = c.price * count;
             keyNum = items[(key - 1) * 2 + 1] + 1;
           else
             maxCount = c.maxCount;
             NLG.SystemMessage(player,"[ϵ�y]����Ʒ�}���џo��؛��");
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
         if maxCount < 0 then
           NLG.SystemMessage(player,"[ϵ�y]�������^��棡");
           return;
         end
         if Char.ItemNum(player, 68000) < totalGold then
           NLG.SystemMessage(player,"[ϵ�y]ħ�����ſ���������o��ُ�I��");
           return;
         end
         if (Char.ItemSlot(player)<20) then
                itemList[keyNum][3] = itemList[keyNum][3] - count;
                Char.GiveItem(player,itemList[keyNum][2],count);
                for NewItemSlot = 8,27 do
                    local NewItemIndex = Char.GetItemIndex(player, NewItemSlot);
                    if (NewItemIndex > 0) then
                      if (Item.GetData(NewItemIndex, CONST.����_�Ѽ���)==0) then
                        Item.SetData(NewItemIndex, CONST.����_�Ѽ���, 1);
                        Item.UpItem(player, NewItemSlot);
                        NLG.UpChar(player);
                      end
                    end
                end
         else
                NLG.Say(player, -1, "ע����ȡ�������^��Ʒ�ڣ�", CONST.��ɫ_��ɫ, CONST.����_��);
                return;
         end
         if (itemList[keyNum][3]==0) then
                table.remove(itemList,keyNum);
                itemList = itemList;
         end
         if (#itemList==0) then
                itemList={};
                NLG.UpChar(player);
                return;
         else
                itemList = itemList;
                NLG.UpChar(player);
                return;
         end
       end
    end
  end)

end


function Module:extractItemData(ItemsetIndex)
  local item = {
    attr={},
  };
  for _, v in pairs(itemFields) do
    --item.attr[tostring(v[1])] = Item.GetData(ItemIndex, v[1]);
    item.attr[tostring(v[1])] = Data.ItemsetGetData(ItemsetIndex, v[2]);
  end
  return item;
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
