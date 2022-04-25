local UniShop = ModuleBase:createModule('uniShop')
local UniMenus = {
  { "[����辵���̯��]��" },
  { "[��ɾ�������̯��]��" },
  { "[����ȡ�����]��" },
  { "[���ϼܼ��۵��ߡ�]��" },
  { "[����ؼ��۵��ߡ�]��" },
  --[[{ "[���޸ĵ������ơ�]��" },]]
}

local Number = 0
local tbl_playerunishop = {}
UniShop_Map= {
  {0,1000,232,109},
  {0,1000,232,111},
  {0,1000,232,113},
  {0,1000,232,115},
  {0,1000,230,109},
  {0,1000,230,111},
  {0,1000,230,113},
  {0,1000,230,115},
  {0,1000,228,109},
  {0,1000,228,111},
  {0,1000,228,113},
  {0,1000,228,115},
  {0,1000,226,109},
  {0,1000,226,111},
  {0,1000,226,113},
  {0,1000,226,115},
}

---�����������޸�
UniList = {}
for sss = 1,100 do
UniList[sss] = {}
UniList[sss][1] = {
{ name = '�����ϼ����ӡ��', image = 26569, price = 0, desc = '��Ʒ��δ�ϼ�x������', count = 1, maxCount = 1, itemid = -1, gold = 0 },
{ name = '�����ϼ����ӡ��', image = 26569, price = 0, desc = '��Ʒ��δ�ϼ�x������', count = 1, maxCount = 1, itemid = -1, gold = 0 },
{ name = '�����ϼ����ӡ��', image = 26569, price = 0, desc = '��Ʒ��δ�ϼ�x������', count = 1, maxCount = 1, itemid = -1, gold = 0 },
{ name = '�����ϼ����ӡ��', image = 26569, price = 0, desc = '��Ʒ��δ�ϼ�x������', count = 1, maxCount = 1, itemid = -1, gold = 0 },
{ name = '�����ϼ����ӡ��', image = 26569, price = 0, desc = '��Ʒ��δ�ϼ�x������', count = 1, maxCount = 1, itemid = -1, gold = 0 },
}
end

itemTypeList ={}
itemTypeList[22] = {'ˮ��'}
itemTypeList[23] = {'����'}
itemTypeList[25] = {'�ز�'}
itemTypeList[26] = {'����'}
itemTypeList[29] = {'��ʯ'}
itemTypeList[30] = {'ľ��'}
itemTypeList[31] = {'����'}
itemTypeList[32] = {'����'}
itemTypeList[33] = {'����'}
itemTypeList[34] = {'�߲�'}
itemTypeList[35] = {'����ʳ��'}
itemTypeList[36] = {'���'}
itemTypeList[37] = {'ҩ��'}
itemTypeList[38] = {'��ʯ'}
itemTypeList[39] = {'B�����'}
itemTypeList[41] = {'������Ƭ'}
itemTypeList[43] = {'ҩ'}
itemTypeList[44] = {'�鱾'}
itemTypeList[45] = {'��ͼ'}
itemTypeList[47] = {'��ȯ'}
itemTypeList[53] = {'����'}
--- ����ģ�鹳��
function UniShop:onLoad()
  self:logInfo('load')
  local uninpc = self:NPC_createNormal('�����̯���', 231051, { map = 1000, x = 223, y = 109, direction = 4, mapType = 0 })
  self:NPC_regWindowTalkedEvent(uninpc, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.����_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --print(seqno)
    --print(select)
    --print(data)
    print(cdk)
    print(tbl_playerunishop[cdk])
    if seqno == 1 then  ----��辵���̯&ִ��
     if data == 1 then
      if (tbl_playerunishop[cdk]==nil) then
            tbl_playerunishop[cdk] = {}
            table.insert(tbl_playerunishop[cdk],cdk);
            local playerSkin = Char.GetData(player,CONST.CHAR_����);
            local playerName = Char.GetData(player,CONST.CHAR_����);
            --local playerName_New = playerName .. "����̯";
            if (Number==0) then
              Number = 1;
            end
           if (Number>=17 and Number<=32 ) then
              local UniShop_X = UniShop_Map[Number-16][3] - 1 ;
              local UniShop_Y = UniShop_Map[Number-16][4] + 1;
              local shopnpc = self:NPC_createNormal( playerName, playerSkin, { map = 1000, x = UniShop_X, y = UniShop_Y, direction = 6, mapType = 0 })
              self:NPC_regTalkedEvent(shopnpc, Func.bind(self.onSellerTalked, self))
              self:NPC_regWindowTalkedEvent(shopnpc, Func.bind(self.onSellerSelected, self));
              table.insert(tbl_playerunishop[cdk],shopnpc);
              table.insert(tbl_playerunishop[cdk],UniList[Number][1]);
              table.insert(tbl_playerunishop[cdk],Number);
              --tbl_playerunishop[cdk][2] = shopnpc
              --tbl_playerunishop[cdk][3] = UniList[Number][1]
              --tbl_playerunishop[cdk][4] = Number
              Number = Number + 1;
              NLG.SystemMessage(player,"[ϵ�y]������R��[����");
            end
            if (Number<=16) then
              local UniShop_X = UniShop_Map[Number][3];
              local UniShop_Y = UniShop_Map[Number][4];
              local shopnpc = self:NPC_createNormal( playerName, playerSkin, { map = 1000, x = UniShop_X, y = UniShop_Y, direction = 6, mapType = 0 })
              self:NPC_regTalkedEvent(shopnpc, Func.bind(self.onSellerTalked, self))
              self:NPC_regWindowTalkedEvent(shopnpc, Func.bind(self.onSellerSelected, self));
              table.insert(tbl_playerunishop[cdk],shopnpc);
              table.insert(tbl_playerunishop[cdk],UniList[Number][1]);
              table.insert(tbl_playerunishop[cdk],Number);
              --tbl_playerunishop[cdk][2] = shopnpc
              --tbl_playerunishop[cdk][3] = UniList[Number][1]
              --tbl_playerunishop[cdk][4] = Number
              Number = Number + 1;
              NLG.SystemMessage(player,"[ϵ�y]������R��[����");
            end
      end
     end
     if data == 2 then  ----ɾ�������̯&ִ��
       if (tbl_playerunishop[cdk]==nil) then
         NLG.SystemMessage(player,"[ϵ�y]��]���R��[����");
         return;
       end
       if (cdk == tbl_playerunishop[cdk][1]) then
       ----��ȡ������ (ͬ����3)
            local ProfitGold =0;
            local Number = tonumber(tbl_playerunishop[cdk][4])
            for i = 1, 5 do
                local Profit = UniList[Number][1][i].gold;
                print(Profit)
                ProfitGold = ProfitGold + Profit;
            end
            if (ProfitGold >0) then
                Char.AddGold(player, ProfitGold );
                for  i = 1, 5 do
                   UniList[Number][1][i].gold = 0;
                end
                --NLG.SystemMessage(player,"[ϵ�y]���Iȡ�۳����н��X��");
            else
                --NLG.SystemMessage(player,"[ϵ�y]�]�п����Iȡ�Ľ��X��");
            end
       ----��ؼ��۵��� (ͬ����5)
            for k = 1, 5 do
                local Number = tonumber(tbl_playerunishop[cdk][4])
                local itemid = UniList[Number][1][k].itemid;
                local maxCount = UniList[Number][1][k].maxCount;
                if (itemid ~=-1) then
                    Char.GiveItem(player,itemid,maxCount);
                end
                local maxCount = 0;
                if (maxCount ==0) then
                     UniList[Number][1][k].name = '�����ϼ����ӡ��';
                     UniList[Number][1][k].image = 26569;
                     UniList[Number][1][k].price = 0;
                     UniList[Number][1][k].desc = '��Ʒ��δ�ϼ�x������';
                     UniList[Number][1][k].count = 1;
                     UniList[Number][1][k].maxCount = 1;
                     UniList[Number][1][k].itemid = -1;
                     UniList[Number][1][k].gold = 0;
                     NLG.UpChar(tbl_playerunishop[cdk][2]);
                     NLG.UpChar(tbl_playerunishop[cdk][3]);
                end
            end
       end
       for i,v in ipairs(tbl_playerunishop[cdk]) do
          if ( cdk==v )then
            NL.DelNpc(tbl_playerunishop[cdk][2]);
            table.remove(tbl_playerunishop[cdk],i);
            tbl_playerunishop[cdk] = nil;
            NLG.SystemMessage(player,"[ϵ�y]�фh���R��[����");
          end
       end
     end
     if data == 3 then  ----��ȡ������&ִ��
       if (tbl_playerunishop[cdk]==nil) then
         NLG.SystemMessage(player,"[ϵ�y]��]���R��[����");
         return;
       end
       if (cdk == tbl_playerunishop[cdk][1]) then
       ----��ȡ������
             local ProfitGold =0;
             local Number = tonumber(tbl_playerunishop[cdk][4])
             for i = 1, 5 do
                local Profit = UniList[Number][1][i].gold;
                print(Profit)
                ProfitGold = ProfitGold + Profit;
             end
             if (ProfitGold >0) then
                Char.AddGold(player, ProfitGold );
                for  i = 1, 5 do
                   UniList[Number][1][i].gold = 0;
                end
                NLG.SystemMessage(player,"[ϵ�y]���Iȡ�۳����н��X��");
             else
                NLG.SystemMessage(player,"[ϵ�y]�]�п����Iȡ�Ľ��X��");
             end
       end
     end
     if data == 4 then  ----�ϼܼ��۵���
       if (tbl_playerunishop[cdk]==nil) then
         NLG.SystemMessage(player,"[ϵ�y]Ո������R��[����");
         return;
       end
       if (cdk == tbl_playerunishop[cdk][1]) then
         local msg_4 = "3\\n@c�뽫Ҫ�ϼܵĵ���\\n"
                             .. "������Ʒ��ǰ���\\n\\n";
         for i = 8, 12 do
               local item = Char.GetItemIndex(player,i);
               if (item==-2) then
                  msg_4 = msg_4 .. "��\\n"
               else
                  msg_4 = msg_4 .. ""..Item.GetData(item,CONST.����_����).."\\n"
               end
         end
         NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, CONST.BUTTON_�ر�, 4, msg_4);
       end
     end
     if data == 5 then  ----��ؼ��۵���
       if (tbl_playerunishop[cdk]==nil) then
         NLG.SystemMessage(player,"[ϵ�y]��]���R��[����");
         return;
       end
       if (cdk == tbl_playerunishop[cdk][1]) then
       ----��ȡ������ (ͬ����3)
            local ProfitGold =0;
            local Number = tonumber(tbl_playerunishop[cdk][4])
            for i = 1, 5 do
                local Profit = UniList[Number][1][i].gold;
                print(Profit)
                ProfitGold = ProfitGold + Profit;
            end
            if (ProfitGold >0) then
                Char.AddGold(player, ProfitGold );
                for  i = 1, 5 do
                   UniList[Number][1][i].gold = 0;
                end
                --NLG.SystemMessage(player,"[ϵ�y]���Iȡ�۳����н��X��");
            else
                --NLG.SystemMessage(player,"[ϵ�y]�]�п����Iȡ�Ľ��X��");
            end
       ----��ؼ��۵���ִ��
            for k = 1, 5 do
                local Number = tonumber(tbl_playerunishop[cdk][4])
                local itemid = UniList[Number][1][k].itemid;
                local maxCount = UniList[Number][1][k].maxCount;
                if (itemid ~=-1) then
                    Char.GiveItem(player,itemid,maxCount);
                end
                local maxCount = 0;
                if (maxCount ==0) then
                     UniList[Number][1][k].name = '�����ϼ����ӡ��';
                     UniList[Number][1][k].image = 26569;
                     UniList[Number][1][k].price = 0;
                     UniList[Number][1][k].desc = '��Ʒ��δ�ϼ�x������';
                     UniList[Number][1][k].count = 1;
                     UniList[Number][1][k].maxCount = 1;
                     UniList[Number][1][k].itemid = -1;
                     UniList[Number][1][k].gold = 0;
                     NLG.UpChar(tbl_playerunishop[cdk][2]);
                     NLG.UpChar(tbl_playerunishop[cdk][3]);
                end
            end
       end
     end
     if data == 6 then  ----�޸ĵ�������
       if (tbl_playerunishop[cdk]==nil) then
         NLG.SystemMessage(player,"[ϵ�y]Ո������R��[����");
         return;
       end
       if (cdk == tbl_playerunishop[cdk][1]) then
         local msg = "\\n@c��ӭʹ�þ����̯����\\n"
                             .. "\\n�������µĵ�������\\n";
         NLG.ShowWindowTalked(player, npc, CONST.����_�����, CONST.BUTTON_ȷ���ر�, 6, msg);
       end
     end
    end


    if seqno == 4 then  ----�ϼܼ��۵���ִ��1
     key = data
     if data == key then
         local item = Char.GetItemIndex(player,key+7)
         local durable = Item.GetData(item,CONST.����_�;�)
         local deal = Item.GetData(item,CONST.����_����)
         if (item==-2) then
            return;
         end
         if ( durable>=1 or deal==0 ) then
            NLG.SystemMessage(player,"[ϵ�y]�˵��߽�ֹ�ϼܣ�");
            return;
         end
         local name = Item.GetData(item,CONST.����_����)
         local msg = "\\n@c��ӭʹ���ϼܼ��۵��߷���\\n"
                             .. "\\n�����롸".. name .."���ĵ���\\n";
         NLG.ShowWindowTalked(player, npc, CONST.����_�����, CONST.BUTTON_ȷ���ر�, 41, msg);
     end
    end

    if seqno == 41 then  ----�ϼܼ��۵���ִ��2
     if select == 1 then
       print(itemid)
       local Number = tonumber(tbl_playerunishop[cdk][4])
       local itemid = UniList[Number][1][key].itemid;
       if ( itemid == -1 ) then
         local price = tonumber(_data);
         local item = Char.GetItemIndex(player,key+7)
         local name = Item.GetData(item,CONST.����_����)
         local image = Item.GetData(item,CONST.����_ͼ)
         local itemid = Item.GetData(item,CONST.����_ID)
         local maxCount = Char.ItemNum(player,itemid)
         local itemlevel = Item.GetData(item,CONST.����_�ȼ�)
         local itemtype = Item.GetData(item,CONST.����_����)
         local itemtypename = itemTypeList[itemtype][1];
         local desc = "�ȼ� ".. itemlevel .. "\\n���� " .. itemtypename .. "\\n";
         local count = 1;
         local gold = 0;
         UniList[Number][1][key].name = name;
         UniList[Number][1][key].image = image;
         UniList[Number][1][key].price = price;
         UniList[Number][1][key].desc = desc;
         UniList[Number][1][key].count = count;
         UniList[Number][1][key].maxCount = maxCount;
         UniList[Number][1][key].itemid = itemid;
         UniList[Number][1][key].gold = gold;
         NLG.UpChar(tbl_playerunishop[cdk][2]);
         NLG.UpChar(tbl_playerunishop[cdk][3]);
         Char.DelItem(player,itemid,maxCount);
         NLG.SystemMessage(player,"[ϵ�y]���ϼܼ��۵���Ʒ��");
       else
         NLG.SystemMessage(player,"[ϵ�y]�˸��������ϼ���Ʒ��");
         return;
       end
     end
    end

    --[[
    if seqno == 6 then  ----�޸ĵ�������ִ��
     if select == 1 then
       local shopname = _data;
       --print(_data)
       Char.SetData(tbl_playerunishop[cdk][2], CONST.CHAR_����, shopname);
       NLG.UpChar(tbl_playerunishop[cdk][2]);
     else
       return 0;
     end
    end
    ]]

  end)

  self:NPC_regTalkedEvent(uninpc, function(npc, player)  ----�����̯���ֹ���UniMenus{}
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "1\\n@c��ӭʹ�þ����̯����\\n";
      for i = 1, 5 do
        msg = msg .. UniMenus[i][1] .. "\\n"
      end
      NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, CONST.BUTTON_�ر�, 1, msg);
    end
    return
  end)

end


function UniShop:onSellerTalked(npc, player)  ----��������̯λ
  if (NLG.CanTalk(npc, player) == true) then
    local npcname = Char.GetData(npc,CONST.CHAR_����);
    local cdk = SQL.Run("select CdKey from tbl_character where Name='"..npcname.."'")["0_0"]
    local Number = tonumber(tbl_playerunishop[cdk][4])
    local npcSkin = Char.GetData(npc,CONST.CHAR_����);
    NLG.ShowWindowTalked(player, npc, CONST.����_�̵���, CONST.BUTTON_��, 0,
      self:NPC_buildBuyWindowData(npcSkin, '�����̯', '������Ʒ', '��Ǯ����', '��������', UniList[Number][1]))
  end
end

function UniShop:onSellerSelected(npc, player, seqNo, select, data)
  --print(select)
  --print(data)
  if select == 2 then
     return
  end
  local name = Char.GetData(npc,CONST.CHAR_����);
  local cdk_shop = SQL.Run("select CdKey from tbl_character where Name='"..name.."'")["0_0"]
  local Number = tonumber(tbl_playerunishop[cdk_shop][4])
  local items = string.split(data, '|');
  local gold = Char.GetData(player, CONST.CHAR_���)
  local totalGold = 0;
  local UniList = UniList[Number][1]
  for i = 1, #items / 2 do
    local c = UniList[items[(i - 1) * 2 + 1] + 1]
    if c then
      count = (tonumber(items[(i - 1) * 2 + 2]) or 0);
      if c.maxCount > 0 then
        maxCount = c.maxCount - count;
      else
        maxCount = c.maxCount;
        NLG.SystemMessage(player,"[ϵ�y]����Ʒ�����꣡");
        return;
      end
      if c.itemid > 1 then
        itemid = c.itemid;
      else
        itemid = -1;
      end
      totalGold = totalGold + c.price * count;
    end
  end
  if itemid == -1 then  ----�ų�͸����ťȡ�õ���
     return;
  end
  if maxCount < 0 then
    NLG.SystemMessage(player,"[ϵ�y]����������棡");
    return;
  end
  if gold < totalGold then
    NLG.SystemMessage(player, '��Ҳ���');
    return
  end
  Char.AddGold(player, -totalGold);
  NLG.UpChar(player);
  Char.GiveItem(player,itemid,count)

  ------------�ش�ʣ������������۳�ȡ�ý�Ǯ------------
  if totalGold > 0 then
      for i = 1, #items / 2 do
        local c = UniList[items[(i - 1) * 2 + 1] + 1]
        if c then
           if c.maxCount > maxCount then
              c.maxCount = maxCount;
           else
              c.maxCount = c.maxCount;
           end
           c.gold = c.gold + totalGold;
           UniList[Number][1] = UniList
        end
      end
      NLG.UpChar(tbl_playerunishop[cdk_shop][2]);
      NLG.UpChar(tbl_playerunishop[cdk_shop][3]);
  end

end

--- ж��ģ�鹳��
function UniShop:onUnload()
  self:logInfo('unload')
end

return UniShop;
