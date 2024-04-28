local UniShop = ModuleBase:createModule('uniShop')
local UniMenus = {
  { "[　租借鏡像擺攤　]　" },
  { "[　刪除鏡像擺攤　]　" },
  { "[　領取餘額款項　]　" },
  { "[　上架寄售道具　]　" },
  { "[　領回寄售道具　]　" },
  --[[{ "[　修改店鋪名稱　]　" },]]

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

---基本设置勿修改
UniList = {}
for sss = 1,100 do
UniList[sss] = {}
UniList[sss][1] = {
{ name = '道具上架許可印章', image = 26569, price = 0, desc = '物品尚未上架x請勿購買', count = 1, maxCount = 1, itemid = -1, gold = 0 },
{ name = '道具上架許可印章', image = 26569, price = 0, desc = '物品尚未上架x請勿購買', count = 1, maxCount = 1, itemid = -1, gold = 0 },
{ name = '道具上架許可印章', image = 26569, price = 0, desc = '物品尚未上架x請勿購買', count = 1, maxCount = 1, itemid = -1, gold = 0 },
{ name = '道具上架許可印章', image = 26569, price = 0, desc = '物品尚未上架x請勿購買', count = 1, maxCount = 1, itemid = -1, gold = 0 },
{ name = '道具上架許可印章', image = 26569, price = 0, desc = '物品尚未上架x請勿購買', count = 1, maxCount = 1, itemid = -1, gold = 0 },
}
end

itemTypeList ={}
itemTypeList[22] = {'水晶'}
itemTypeList[23] = {'料理'}
itemTypeList[25] = {'素材'}
itemTypeList[26] = {'不明'}
itemTypeList[29] = {'礦石'}
itemTypeList[30] = {'木材'}
itemTypeList[31] = {'布卷'}
itemTypeList[32] = {'肉類'}
itemTypeList[33] = {'海鮮'}
itemTypeList[34] = {'蔬菜'}
itemTypeList[35] = {'其他食材'}
itemTypeList[36] = {'香草'}
itemTypeList[37] = {'藥草'}
itemTypeList[38] = {'寶石'}
itemTypeList[39] = {'B類材料'}
itemTypeList[41] = {'其他卡片'}
itemTypeList[43] = {'藥'}
itemTypeList[44] = {'書本'}
itemTypeList[45] = {'地圖'}
itemTypeList[47] = {'彩券'}
itemTypeList[53] = {'點心'}
--- 加载模块钩子
function UniShop:onLoad()
  self:logInfo('load')
  local uninpc = self:NPC_createNormal('鏡像擺攤租借', 231051, { map = 1000, x = 223, y = 109, direction = 4, mapType = 0 })
  self:NPC_regWindowTalkedEvent(uninpc, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --print(seqno)
    --print(select)
    --print(data)
    print(cdk)
    print(tbl_playerunishop[cdk])
    if seqno == 1 then  ----租借镜像摆摊&执行
     if data == 1 then
      if (tbl_playerunishop[cdk]==nil) then
            tbl_playerunishop[cdk] = {}
            table.insert(tbl_playerunishop[cdk],cdk);
            local playerSkin = Char.GetData(player,CONST.CHAR_形象);
            local playerName = Char.GetData(player,CONST.CHAR_名字);
            --local playerName_New = playerName .. "－摆摊";
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
              NLG.SystemMessage(player,"[系統]已租借鏡像擺攤！");
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
              NLG.SystemMessage(player,"[系統]已租借鏡像擺攤！");
            end
      end
     end
     if data == 2 then  ----删除镜像摆摊&执行
       if (tbl_playerunishop[cdk]==nil) then
         NLG.SystemMessage(player,"[系統]你沒有鏡像擺攤！");
         return;
       end
       if (cdk == tbl_playerunishop[cdk][1]) then
       ----领取余额款项 (同功能3)
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
                --NLG.SystemMessage(player,"[系統]已領取售出所有金錢！");
            else
                --NLG.SystemMessage(player,"[系統]沒有可以領取的金錢！");
            end
       ----领回寄售道具 (同功能5)
            for k = 1, 5 do
                local Number = tonumber(tbl_playerunishop[cdk][4])
                local itemid = UniList[Number][1][k].itemid;
                local maxCount = UniList[Number][1][k].maxCount;
                if (itemid ~=-1) then
                    Char.GiveItem(player,itemid,maxCount);
                end
                local maxCount = 0;
                if (maxCount ==0) then
                     UniList[Number][1][k].name = '道具上架許可印章';
                     UniList[Number][1][k].image = 26569;
                     UniList[Number][1][k].price = 0;
                     UniList[Number][1][k].desc = '物品尚未上架x請勿購買';
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
            NLG.SystemMessage(player,"[系統]已刪除鏡像擺攤！");
          end
       end
     end
     if data == 3 then  ----领取余额款项&执行
       if (tbl_playerunishop[cdk]==nil) then
         NLG.SystemMessage(player,"[系統]你沒有鏡像擺攤！");
         return;
       end
       if (cdk == tbl_playerunishop[cdk][1]) then
       ----领取余额款项
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
                NLG.SystemMessage(player,"[系統]已領取售出所有金錢！");
             else
                NLG.SystemMessage(player,"[系統]沒有可以領取的金錢！");
             end
       end
     end
     if data == 4 then  ----上架寄售道具
       if (tbl_playerunishop[cdk]==nil) then
         NLG.SystemMessage(player,"[系統]請先租借鏡像擺攤！");
         return;
       end
       if (cdk == tbl_playerunishop[cdk][1]) then
         local msg_4 = "3\\n@c請將要上架的道具\\n"
                             .. "放在物品欄前五格\\n\\n";
         for i = 8, 12 do
               local item = Char.GetItemIndex(player,i);
               if (item==-2) then
                  msg_4 = msg_4 .. "空\\n"
               else
                  msg_4 = msg_4 .. ""..Item.GetData(item,CONST.道具_名字).."\\n"
               end
         end
         NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.BUTTON_关闭, 4, msg_4);
       end
     end
     if data == 5 then  ----领回寄售道具
       if (tbl_playerunishop[cdk]==nil) then
         NLG.SystemMessage(player,"[系統]你沒有鏡像擺攤！");
         return;
       end
       if (cdk == tbl_playerunishop[cdk][1]) then
       ----领取余额款项 (同功能3)
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
                --NLG.SystemMessage(player,"[系統]已領取售出所有金錢！");
            else
                --NLG.SystemMessage(player,"[系統]沒有可以領取的金錢！");
            end
       ----领回寄售道具执行
            for k = 1, 5 do
                local Number = tonumber(tbl_playerunishop[cdk][4])
                local itemid = UniList[Number][1][k].itemid;
                local maxCount = UniList[Number][1][k].maxCount;
                if (itemid ~=-1) then
                    Char.GiveItem(player,itemid,maxCount);
                end
                local maxCount = 0;
                if (maxCount ==0) then
                     UniList[Number][1][k].name = '道具上架許可印章';
                     UniList[Number][1][k].image = 26569;
                     UniList[Number][1][k].price = 0;
                     UniList[Number][1][k].desc = '物品尚未上架x請勿購買';
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
     if data == 6 then  ----修改店铺名称
       if (tbl_playerunishop[cdk]==nil) then
         NLG.SystemMessage(player,"[系統]請先租借鏡像擺攤！");
         return;
       end
       if (cdk == tbl_playerunishop[cdk][1]) then
         local msg = "\\n@c歡迎使用鏡像擺攤服務\\n"
                             .. "\\n請輸入新的店鋪名稱\\n";
         NLG.ShowWindowTalked(player, npc, CONST.窗口_输入框, CONST.BUTTON_确定关闭, 6, msg);
       end
     end
    end


    if seqno == 4 then  ----上架寄售道具执行1
     key = data
     if data == key then
         local item = Char.GetItemIndex(player,key+7)
         local durable = Item.GetData(item,CONST.道具_耐久)
         local deal = Item.GetData(item,CONST.道具_宠邮)
         if (item==-2) then
            return;
         end
         if ( durable>=1 or deal==0 ) then
            NLG.SystemMessage(player,"[系統]此道具禁止上架！");
            return;
         end
         local name = Item.GetData(item,CONST.道具_名字)
         local msg = "\\n@c歡迎使用上架寄售道具服務\\n"
                             .. "\\n請輸入「".. name .."」的單價\\n";
         NLG.ShowWindowTalked(player, npc, CONST.窗口_输入框, CONST.BUTTON_确定关闭, 41, msg);
     end
    end

    if seqno == 41 then  ----上架寄售道具执行2
     if select == 1 then
       print(itemid)
       local Number = tonumber(tbl_playerunishop[cdk][4])
       local itemid = UniList[Number][1][key].itemid;
       if ( itemid == -1 ) then
         local price = tonumber(_data);
         local item = Char.GetItemIndex(player,key+7)
         local name = Item.GetData(item,CONST.道具_名字)
         local image = Item.GetData(item,CONST.道具_图)
         local itemid = Item.GetData(item,CONST.道具_ID)
         local maxCount = Char.ItemNum(player,itemid)
         local itemlevel = Item.GetData(item,CONST.道具_等级)
         local itemtype = Item.GetData(item,CONST.道具_类型)
         local itemtypename = itemTypeList[itemtype][1];
         local desc = "等級 ".. itemlevel .. "\\n種類 " .. itemtypename .. "\\n";
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
         NLG.SystemMessage(player,"[系統]已上架寄售的物品！");
       else
         NLG.SystemMessage(player,"[系統]此格子已有上架物品！");
         return;
       end
     end
    end

    --[[
    if seqno == 6 then  ----修改店铺名称执行
     if select == 1 then
       local shopname = _data;
       --print(_data)
       Char.SetData(tbl_playerunishop[cdk][2], CONST.CHAR_名字, shopname);
       NLG.UpChar(tbl_playerunishop[cdk][2]);
     else
       return 0;
     end
    end
    ]]

  end)

  self:NPC_regTalkedEvent(uninpc, function(npc, player)  ----镜像摆摊六种功能UniMenus{}
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "1\\n@c歡迎使用鏡像擺攤服務\\n";
      for i = 1, 5 do
        msg = msg .. UniMenus[i][1] .. "\\n"
      end
      NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.BUTTON_关闭, 1, msg);
    end
    return
  end)

end


function UniShop:onSellerTalked(npc, player)  ----设立镜像摊位
  if (NLG.CanTalk(npc, player) == true) then
    local npcname = Char.GetData(npc,CONST.CHAR_名字);
    local cdk = SQL.Run("select CdKey from tbl_character where Name='"..npcname.."'")["0_0"]
    local Number = tonumber(tbl_playerunishop[cdk][4])
    local npcSkin = Char.GetData(npc,CONST.CHAR_形象);
    NLG.ShowWindowTalked(player, npc, CONST.窗口_商店买, CONST.BUTTON_是, 0,
      self:NPC_buildBuyWindowData(npcSkin, '鏡像擺攤', '販賣商品', '金錢不足', '背包已滿', UniList[Number][1]))
  end
end

function UniShop:onSellerSelected(npc, player, seqNo, select, data)
  --print(select)
  --print(data)
  if select == 2 then
     return
  end
  local name = Char.GetData(npc,CONST.CHAR_名字);
  local cdk_shop = SQL.Run("select CdKey from tbl_character where Name='"..name.."'")["0_0"]
  local Number = tonumber(tbl_playerunishop[cdk_shop][4])
  local items = string.split(data, '|');
  local gold = Char.GetData(player, CONST.CHAR_金币)
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
        NLG.SystemMessage(player,"[系統]此物品已售完！");
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
  if itemid == -1 then  ----排除透过按钮取得道具
     return;
  end
  if maxCount < 0 then
    NLG.SystemMessage(player,"[系統]數量超過庫存！");
    return;
  end
  if gold < totalGold then
    NLG.SystemMessage(player, '金幣不足');
    return
  end
  Char.AddGold(player, -totalGold);
  NLG.UpChar(player);
  Char.GiveItem(player,itemid,count)

  ------------回传剩余道具数量、售出取得金钱------------
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

--- 卸载模块钩子
function UniShop:onUnload()
  self:logInfo('unload')
end

return UniShop;
