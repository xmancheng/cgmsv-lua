---模块类
local Module = ModuleBase:createModule('mysteryShop')

local GMcdk="123456";
local itemData = {
    {"Lv1卷軸書冊",900611,10,10},
    {"Lv2卷軸書冊",900612,10,30},
    {"Lv3卷軸書冊",900613,5,100},
    {"Lv6卷軸書冊",900616,3,400},
    {"Lv7卷軸書冊",900617,1,500},
    {"赤目黑熊的卷軸",73810,2,200},
    {"血腥之刃的卷軸",73911,2,200},
    {"烈風之刃的卷軸",73914,2,200},
    {"貓熊的卷軸",73811,1,250},
    {"火精的卷軸",73898,2,200},
    {"風精的卷軸",73899,2,200},
    {"水精的卷軸",73900,2,200},
    {"地精的卷軸",73901,2,200},
    {"大地翼龍的卷軸",73933,2,200},
    {"烈風翼龍的卷軸",73936,2,200},
    {"丘比特的卷軸",73841,1,250},
    {"黃金樹精的卷軸",73877,1,250},
    {"翼龍的卷軸",73937,1,250},
    {"水藍鼠的卷軸",73816,2,200},
    {"殺人螳螂的卷軸",73867,2,200},
    {"赤目螳螂的卷軸",73868,2,200},
    {"死灰螳螂的卷軸",73869,2,200},
    {"單眼巨人的卷軸",73947,2,200},
    {"亞特拉斯巨神的卷軸",73949,2,200},
    {"鼠王的卷軸",73817,1,250},
    {"幻影的卷軸",73907,2,200},
    {"旋律影子的卷軸",73908,2,200},
    {"闇影的卷軸",73909,2,200},
    {"陰影的卷軸",73910,2,200},
    {"惡魔蝙蝠的卷軸",73850,1,250},
    {"天使蝙蝠的卷軸",73851,1,250},
    {"石像怪的卷軸",73842,2,200},
    {"墮天使的卷軸",73844,2,200},
    {"丸子炸彈的卷軸",73906,2,200},
    {"純白嚇人箱的卷軸",73920,1,250},
}

local itemFields={
{CONST.道具_攻击,CONST.ITEMSET_MODIFYATTACK,"攻擊"},
{CONST.道具_防御,CONST.ITEMSET_MODIFYDEFENCE,"防禦"},
{CONST.道具_敏捷,CONST.ITEMSET_MODIFYAGILITY,"敏捷"},
{CONST.道具_精神,CONST.ITEMSET_MODIFYMAGIC,"精神"},
{CONST.道具_回复,CONST.ITEMSET_MODIFYRECOVERY,"回復"},
{CONST.道具_必杀,CONST.ITEMSET_MODIFYCRITICAL,"必殺"},
{CONST.道具_反击,CONST.ITEMSET_MODIFYCOUNTER,"反擊"},
{CONST.道具_命中,CONST.ITEMSET_MODIFYHITRATE,"命中"},
{CONST.道具_闪躲,CONST.ITEMSET_MODIFYAVOID,"閃躲"},
{CONST.道具_生命,CONST.ITEMSET_MODIFYHP,"生命"},
{CONST.道具_魔力,CONST.ITEMSET_MODIFYFORCEPOINT,"魔力"},
{CONST.道具_毒抗,CONST.ITEMSET_POISON,"抗毒"},
{CONST.道具_睡抗,CONST.ITEMSET_SLEEP,"抗睡"},
{CONST.道具_石抗,CONST.ITEMSET_STONE,"抗石"},
{CONST.道具_醉抗,CONST.ITEMSET_DRUNK,"抗罪"},
{CONST.道具_乱抗,CONST.ITEMSET_CONFUSION,"抗亂"},
{CONST.道具_忘抗,CONST.ITEMSET_AMNESIA,"抗忘"},
{CONST.道具_魔抗,CONST.ITEMSET_RSS,"抗魔"},
{CONST.道具_魔攻,CONST.ITEMSET_ADM,"魔攻"},
{CONST.道具_等级,CONST.ITEMSET_LEVEL,"等級"},
{CONST.道具_耐久,CONST.ITEMSET_REMAIN,"耐久"},
{CONST.道具_最大耐久,CONST.ITEMSET_MAXREMAIN,"最大耐久"},
{CONST.道具_类型,CONST.ITEMSET_TYPE,"其他卡片"},
{CONST.道具_子参一,CONST.ITEMSET_SPECIALEFFECTVALUE,"SPECIALEFFECTVALUE"},
{CONST.道具_堆叠数,CONST.ITEMSET_COST,"數量"},
}
function WhichPart(Para1)
    local WhichPart={}
    if Para1==0 then            --头
        WhichPart={"               $5賦予頭部"};
    elseif Para1==1 then    --身
        WhichPart={"               $5賦予身體"};
    elseif Para1==3 then    --右
        WhichPart={"               $5賦予副武"};
    elseif Para1==4 then    --足
        WhichPart={"               $5賦予足部"};
    elseif Para1==5 then    --饰
        WhichPart={"               $5賦予飾品"};
    else
        WhichPart={" "};
    end
    return WhichPart;
end
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self))
  self:regCallback('LoopEvent', Func.bind(self.MysteryShop_LoopEvent,self))
  mysteryNPC = self:NPC_createNormal('神秘商店', 98972, { x = 35, y = 39, mapType = 0, map = 777, direction = 0 });
  self:NPC_regTalkedEvent(mysteryNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        -- 回调 data = 1:买, 2:卖
        -- 数据结构 NPC图档|窗口标题|NPC对话|买卖类型 0:无按钮, 1:买, 2:卖, 3:买卖|
        local windowStr = '98972|神秘商店|隨機商品的旅行商人\n商品限量價格不斐|1|'
        NLG.ShowWindowTalked(player, mysteryNPC, CONST.窗口_买卖框, CONST.BUTTON_关闭, 1, windowStr);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(mysteryNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    --local data = tonumber(_data)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    local gmIndex = NLG.FindUser(GMcdk);
    if seqno == 1 then
     local data = tonumber(_data)
     if data == 1 then
        local sqldata = tostring(SQL.Run("select val from hook_charaext where cdKey='"..GMcdk.."' and sKey='mystery_shop'")["0_0"])
        itemList = {};
        if (type(sqldata)=="string" and sqldata~='') then
               itemList = JSON.decode(sqldata);
        else
               itemList = {};
        end
        itemMenu={};
        -- 回调 data = 0:物品序号(基于本次交易)|N:购买数量|物品2序号|物品2数量...
        -- 数据结构 NPC图档|窗口标题|NPC对话|钱不够对话|拿不下或数量不够对话|物品N名称|物品N图档|物品N价格|物品N介绍|物品N类型|可否购买, 0不可, 1可|
        local windowStr = '98972|神秘商店|限時、限量趕緊搶購\n各式各樣的卷軸哦\n\n※每次只取相同的…|\n你錢不夠|\n你拿不下了|';
        for im=1,#itemList do
            local ItemsetIndex = Data.ItemsetGetIndex(itemList[im][2]);
            local price = tonumber(itemList[im][4]);
            if (ItemsetIndex>0) then
                 --local ItemName = Item.GetData(ItemIndex, CONST.道具_名字);
                 local ItemName = Data.ItemsetGetData(ItemsetIndex, CONST.ITEMSET_TRUENAME);
                 --local ItemImage = Item.GetData(ItemIndex, CONST.道具_图);
                 local ItemImage = Data.ItemsetGetData(ItemsetIndex, CONST.ITEMSET_BASEIMAGENUMBER);
                 local ItemType = Data.ItemsetGetData(ItemsetIndex, CONST.ITEMSET_TYPE);
                 local ItemInfo = self:extractItemData(ItemsetIndex);
                 local ItemMsg = "$1";
                 for k,v in pairs(itemFields) do
                     if ItemInfo.attr[tostring(v[1])] ~=nil  then
                         local param = v[3];
                         --print(param)
                         if param=="耐久" then
                             ItemMsg = ItemMsg .. "\\n$4"..param .." 0100"
                         elseif param=="最大耐久" then
                             ItemMsg = ItemMsg .. "/0100"
                         elseif param=="等級" then
                             ItemMsg = ItemMsg .. " $4等級 $4".. ItemInfo.attr[tostring(v[1])] ..""
                         elseif param=="其他卡片" then
                             ItemMsg = ItemMsg .. " $0種類 其他卡片"
                         elseif param=="SPECIALEFFECTVALUE" then
                             partMsg = WhichPart(ItemInfo.attr[tostring(v[1])]);
                             ItemMsg = ItemMsg .. "\\n".. partMsg[1] ..""
                         elseif param=="數量" then
                             ItemMsg = ItemMsg .. "\\n\\n倉庫剩餘數量: ".. tonumber(itemList[im][3]) ..""
                         else
                             if (ItemInfo.attr[tostring(v[1])]~=0) then
                                 ItemMsg = ItemMsg .. param .."+".. ItemInfo.attr[tostring(v[1])] .." "
                             end
                         end
                     end
                 end
                 windowStr = windowStr..''..ItemName..'|'..ItemImage..'|'..price..'|'..ItemMsg..'|'..ItemType..'|1|';
                 local maxCount = tonumber(itemList[im][3]);
                 local itemid = tonumber(itemList[im][2]);
                 itemMenu[im] = {name='..ItemName..', image='..ItemImage..', price=price, desc='..ItemMsg..', count=1, maxCount=maxCount, itemid=itemid};
            end
        end
        NLG.ShowWindowTalked(player, mysteryNPC, CONST.窗口_买框, CONST.BUTTON_关闭, 11, windowStr);
     end
    end
    if seqno == 11 then
       local data = tostring(_data)
       if (select == CONST.按钮_关闭) then
                 return;
       end
       local items = string.split(data, '|');
       local itemMenu = itemMenu;
       for key = 1, #items / 2 do
         local c = itemMenu[items[(key - 1) * 2 + 1] + 1]
         if c then
           count = (tonumber(items[(key - 1) * 2 + 2]) or 0);
           if c.maxCount > 0 then
             maxCount = c.maxCount - count;
             totalGold = c.price * count;
             keyNum = items[(key - 1) * 2 + 1] + 1;
           else
             maxCount = c.maxCount;
             NLG.SystemMessage(player,"[系統]此物品倉庫已無存貨！");
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
         if maxCount < 0 then
           NLG.SystemMessage(player,"[系統]數量超過庫存！");
           return;
         end
         if Char.ItemNum(player, 68000) < totalGold then
           NLG.SystemMessage(player,"[系統]魔力金幣卡數量不足無法購買！");
           return;
         end
         if (Char.ItemSlot(player)<20) then
                itemList[keyNum][3] = itemList[keyNum][3] - count;
                Char.GiveItem(player,itemList[keyNum][2],count);
                Char.DelItem(player, 68000, totalGold);
                for NewItemSlot = 8,27 do
                    local NewItemIndex = Char.GetItemIndex(player, NewItemSlot);
                    if (NewItemIndex > 0) then
                      if (Item.GetData(NewItemIndex, CONST.道具_已鉴定)==0) then
                        Item.SetData(NewItemIndex, CONST.道具_已鉴定, 1);
                        Item.UpItem(player, NewItemSlot);
                        NLG.UpChar(player);
                      end
                    end
                end
         else
                NLG.Say(player, -1, "注意提取數量超過物品欄！", CONST.颜色_黄色, CONST.字体_中);
                return;
         end
         if (itemList[keyNum][3]==0) then
                table.remove(itemList,keyNum);
                itemList = itemList;
         end
         if (#itemList==0) then
                itemList={};
                local newdata = JSON.encode(itemList);
                SQL.querySQL("update hook_charaext set val= '"..newdata.."' where cdKey='"..GMcdk.."' and sKey='mystery_shop'")
                NLG.UpChar(gmIndex);
                return;
         else
                local newdata = JSON.encode(itemList);
                SQL.querySQL("update hook_charaext set val= '"..newdata.."' where cdKey='"..GMcdk.."' and sKey='mystery_shop'")
                NLG.UpChar(gmIndex);
                return;
         end
       end
    end
  end)

end

--指令启动循环
function Module:handleTalkEvent(charIndex,msg,color,range,size)
	if (msg=="[nr msshop start]") then
		local cdk = Char.GetData(charIndex,CONST.对象_CDK);
		if (cdk == GMcdk) then
			--抽取出5个商品
			local r1=NLG.Rand(1,#itemData);
			local r2=NLG.Rand(1,#itemData);
			local r3=NLG.Rand(1,#itemData);
			local r4=NLG.Rand(1,#itemData);
			local r5=NLG.Rand(1,#itemData);
			itemList={};
			itemList[1]=itemData[r1];
			itemList[2]=itemData[r2];
			itemList[3]=itemData[r3];
			itemList[4]=itemData[r4];
			itemList[5]=itemData[r5];
 			--存进GM的个人库
			Char.SetExtData(charIndex, 'mystery_shop', JSON.encode(itemList));
			local newdata = JSON.encode(itemList);
			SQL.querySQL("update hook_charaext set val= '"..newdata.."' where cdKey='"..GMcdk.."' and sKey='mystery_shop'")
			Char.SetLoopEvent('./lua/Modules/mysteryShop.lua','MysteryShop_LoopEvent',mysteryNPC,1000);
			NLG.SystemMessage(charIndex, "[系統]神秘商店開始。");
			NLG.UpChar(charIndex);
			return 0;
		end
	end
	return 1;
end
--转移神秘商店
function MysteryShop_LoopEvent(mysteryNPC)
	if (os.date("%X",os.time())=="00:45:01") or (os.date("%X",os.time())=="00:00:01") or (os.date("%X",os.time())=="12:15:01") or (os.date("%X",os.time())=="13:15:01") or (os.date("%X",os.time())=="17:15:01") or (os.date("%X",os.time())=="18:15:01") or (os.date("%X",os.time())=="20:15:01") or (os.date("%X",os.time())=="21:15:01") or (os.date("%X",os.time())=="22:15:01") then
		Char.SetData(mysteryNPC,CONST.对象_X, 35);
		Char.SetData(mysteryNPC,CONST.对象_Y, 15);
		Char.SetData(mysteryNPC,CONST.对象_地图, 25012);
		NLG.UpChar(mysteryNPC);
		--每轮重置抽取出5个商品
		local r1=NLG.Rand(1,#itemData);
		local r2=NLG.Rand(1,#itemData);
		local r3=NLG.Rand(1,#itemData);
		local r4=NLG.Rand(1,#itemData);
		local r5=NLG.Rand(1,#itemData);
		itemList={};
		itemList[1]=itemData[r1];
		itemList[2]=itemData[r2];
		itemList[3]=itemData[r3];
		itemList[4]=itemData[r4];
		itemList[5]=itemData[r5];
 		--存进GM的个人库
		local newdata = JSON.encode(itemList);
		SQL.querySQL("update hook_charaext set val= '"..newdata.."' where cdKey='"..GMcdk.."' and sKey='mystery_shop'")
	elseif (os.date("%X",os.time())=="23:59:00") or (os.date("%X",os.time())=="07:45:01") or (os.date("%X",os.time())=="13:45:01") or (os.date("%X",os.time())=="18:45:01") or (os.date("%X",os.time())=="21:45:01")  then
		Char.SetData(mysteryNPC,CONST.对象_X, 35);
		Char.SetData(mysteryNPC,CONST.对象_Y, 39);
		Char.SetData(mysteryNPC,CONST.对象_地图, 777);
		NLG.UpChar(mysteryNPC);
	end
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

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
