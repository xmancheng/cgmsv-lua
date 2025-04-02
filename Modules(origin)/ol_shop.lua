local Module = ModuleBase:createModule('ol_shop')
local itemList = {
  { name = '母爱之卵', image = 27075, price = 100000, desc = '大地鼠媽媽石像所贈與的奇異之蛋', count = 1, maxCount = 1,  itemid = 16447 },
  { name = '再生剧药', image = 26206, price = 50000, desc = '能重新分配人物點數，使能力改變', count = 1, maxCount = 1,  itemid = 45745 },
  { name = '新手标志', image = 252025, price = 500, desc = '代表剛來這個世界沒多久的頭飾,新手的證明', count = 1, maxCount = 1,  itemid = 607728 },
  { name = '金刚不坏安全帽', image = 27933, price = 5000, desc = '可以用來抵擋受傷一百次，史上最強的安全帽', count = 1, maxCount = 1,  itemid = 45987 },
  { name = '王者守护神', image = 99194, price = 50000, desc = '裝備上就會擁有王者的保護，可以輕鬆的襲擊魔族', count = 1, maxCount = 1,  itemid = 34638 },
  { name = '水龙料理', image = 26364, price = 500, desc = '宠物親近度+10', count = 1, maxCount = 20,  itemid = 280 },
}

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  shopNPC = self:NPC_createNormal('在线商店', 101024, { map = 1000, x = 220, y = 88, direction = 4, mapType = 0 })
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
      NLG.ShowWindowTalked(player, npc, CONST.窗口_商店买, CONST.BUTTON_是, 0,
         self:NPC_buildBuyWindowData(101024, '在线商店', '选择你要的商品', '金钱不足', '背包已满', itemList))
  elseif (NLG.CanTalk(npc, player) == false and npc==shopNPC) then
      NLG.ShowWindowTalked(player, npc, CONST.窗口_商店买, CONST.BUTTON_是, 0,
         self:NPC_buildBuyWindowData(101024, '在线商店', '选择你要的商品', '金钱不足', '背包已满', itemList))
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
             NLG.SystemMessage(player,"[系统]此物品仓库已无存货！");
             return;
        end
        if c.itemid > 1 then
             itemid = c.itemid;
        else
             itemid = -1;
        end
      end
      if itemid == -1 then  ----排除透过按钮取得道具
            return;
      end
      --[[if maxCount < 0 then
           NLG.SystemMessage(player,"[系统]数量超过库存！");
           return;
      end]]
      if Char.GetData(player,CONST.对象_金币) < totalGold then
           NLG.SystemMessage(player,"[系统]魔币不足无法购买！");
           return;
      end
      if ( Char.GetData(player,CONST.对象_道具栏) - 8 - Char.ItemSlot(player) >= math.ceil(count/c.maxCount) ) then
          --itemList[keyNum][3] = itemList[keyNum][3] - count;
          Char.GiveItem(player,itemid,count);
          Char.AddGold(player, -totalGold)
          --[[for NewItemSlot = 8,27 do
              local NewItemIndex = Char.GetItemIndex(player, NewItemSlot);
              if (NewItemIndex > 0) then
                if (Item.GetData(NewItemIndex, CONST.道具_已鉴定)==0) then
                  Item.SetData(NewItemIndex, CONST.道具_已鉴定, 1);
                  Item.UpItem(player, NewItemSlot);
                  NLG.UpChar(player);
                end
              end
          end]]
      else
          NLG.Say(player, -1, "数量超过物品栏！", CONST.颜色_黄色, CONST.字体_中);
          return;
      end
   end
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
