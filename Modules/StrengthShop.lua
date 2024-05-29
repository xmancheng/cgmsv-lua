local Module = ModuleBase:createModule('StrengthShop');

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
    end
    return WhichPart;
end

function Module:onLoad()
  self:logInfo('load')
  local StrengthShopNPC = self:NPC_createNormal('魔法卷軸倉庫', 231050, { x = 235, y = 114, mapType = 0, map = 1000, direction = 0 });
  self:NPC_regTalkedEvent(StrengthShopNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        -- 回调 data = 1:买, 2:卖
        -- 数据结构 NPC图档|窗口标题|NPC对话|买卖类型 0:无按钮, 1:买, 2:卖, 3:买卖|
        local windowStr = '231050|卷軸倉庫|魔法卷軸存取功能\n暫時將卷軸存入倉庫|3|'
        NLG.ShowWindowTalked(player, StrengthShopNPC, CONST.窗口_买卖框, CONST.BUTTON_关闭, 1, windowStr);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(StrengthShopNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    --local data = tonumber(_data)
    --print(seqno,select,data)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    if seqno == 1 then
     local data = tonumber(_data)
     if data == 1 then
        SQL.querySQL([[ALTER TABLE lua_hook_character ADD ReelBag mediumtext COLLATE gbk_bin NULL;]])
        local cdk = Char.GetData(player,CONST.对象_CDK);
        local sqldata = SQL.Run("select ReelBag from lua_hook_character where CdKey='"..cdk.."'")["0_0"]
        local itemData = {};
        if (type(sqldata)=="string") then
               itemData = JSON.decode(sqldata);
        else
               itemData={};
        end
        itemList={};
        -- 回调 data = 0:物品序号(基于本次交易)|N:购买数量|物品2序号|物品2数量...
        -- 数据结构 NPC图档|窗口标题|NPC对话|钱不够对话|拿不下或数量不够对话|物品N名称|物品N图档|物品N价格|物品N介绍|物品N类型|可否购买, 0不可, 1可|
        local windowStr = '231050|卷軸倉庫|這些是你曾經存入的\n各式各樣的卷軸哦\n\n※每次只取相同的…|\n你錢不夠|\n你拿不下了|';
        for im=1,#itemData do
            local ItemsetIndex = Data.ItemsetGetIndex(itemData[im][2]);
            if (ItemsetIndex>0) then
                 --local ItemName = Item.GetData(ItemIndex, CONST.道具_名字);
                 local ItemName = Data.ItemsetGetData(ItemsetIndex, CONST.ITEMSET_TRUENAME);
                 --local ItemImage = Item.GetData(ItemIndex, CONST.道具_图);
                 local ItemImage = Data.ItemsetGetData(ItemsetIndex, CONST.ITEMSET_BASEIMAGENUMBER);
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
                             ItemMsg = ItemMsg .. "\\n\\n倉庫剩餘數量: ".. tonumber(itemData[im][3]) ..""
                         else
                             if (ItemInfo.attr[tostring(v[1])]~=0) then
                                 ItemMsg = ItemMsg .. param .."+".. ItemInfo.attr[tostring(v[1])] .." "
                             end
                         end
                     end
                 end
                 windowStr = windowStr..''..ItemName..'|'..ItemImage..'|0|'..ItemMsg..'|41|1|';
                 local maxCount = tonumber(itemData[im][3]);
                 local itemid = tonumber(itemData[im][2]);
                 itemList[im] = {name='..ItemName..', image='..ItemImage..', price=0, desc='..ItemMsg..', count=1, maxCount=maxCount, itemid=itemid};
            end
        end
        NLG.ShowWindowTalked(player, StrengthShopNPC, CONST.窗口_买框, CONST.BUTTON_关闭, 11, windowStr);
     elseif data == 2 then
         local winMsg = "3\\n【卷軸倉庫】\\n"
                             .. "請將要存入的卷軸放在物品欄前五格\\n"
                             .. "═════════════════════\\n";
         for itemSlot = 8, 12 do
               local ItemIndex = Char.GetItemIndex(player,itemSlot);
               if (ItemIndex>0) then
                  local ItemName = Item.GetData(ItemIndex, CONST.道具_名字);
                  winMsg = winMsg .. "第".. itemSlot-7 .."格:〈".. ItemName .."〉\\n"
               else
                  winMsg = winMsg .. "第".. itemSlot-7 .."格:  無物品" .. "\\n"
               end
         end
         NLG.ShowWindowTalked(player, StrengthShopNPC, CONST.窗口_选择框, CONST.BUTTON_关闭, 12, winMsg);
     end
    end
    if seqno == 11 then
       local data = tostring(_data)
       if (select == CONST.按钮_关闭) then
                 return;
       end
       local cdk = Char.GetData(player,CONST.对象_CDK);
       local sqldata = SQL.Run("select ReelBag from lua_hook_character where CdKey='"..cdk.."'")["0_0"]
       local itemData = {};
       if (type(sqldata)=="string") then
              itemData = JSON.decode(sqldata);
       else
              itemData={};
       end
       local items = string.split(data, '|');
       local itemList = itemList;
       for key = 1, #items / 2 do
         local c = itemList[items[(key - 1) * 2 + 1] + 1]
         if c then
           count = (tonumber(items[(key - 1) * 2 + 2]) or 0);
           if c.maxCount > 0 then
             maxCount = c.maxCount - count;
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
         if (Char.ItemSlot(player)<20) then
                itemData[keyNum][3] = itemData[keyNum][3] - count;
                Char.GiveItem(player,itemData[keyNum][2],count);
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
         if (itemData[keyNum][3]==0) then
                table.remove(itemData,keyNum);
                itemData = itemData;
         end
         if (#itemData==0) then
                itemData={};
                SQL.Run("update lua_hook_character set ReelBag= NULL where CdKey='"..cdk.."'")
                NLG.UpChar(player);
                return;
         elseif (#itemData>=15) then
                local xr = NLG.Rand(1,3);
                for i=1,#itemData-1-xr do
                        r = NLG.Rand(1,i+1+xr);
                        temp=itemData[r];
                        itemData[r]=itemData[i];
                        itemData[i]=temp;
                end
                local sqldata = itemData;
                local newdata = JSON.encode(sqldata);
                SQL.Run("update lua_hook_character set ReelBag= '"..newdata.."' where CdKey='"..cdk.."'")
                NLG.UpChar(player);
                return;
         else
                local sqldata = itemData;
                local newdata = JSON.encode(sqldata);
                SQL.Run("update lua_hook_character set ReelBag= '"..newdata.."' where CdKey='"..cdk.."'")
                NLG.UpChar(player);
                return;
         end
       end


    end
    if seqno == 12 then
       local data = tonumber(_data)
       if (select == CONST.按钮_关闭) then
                 return;
       end
       local itemSlot=data+7;
       local ItemIndex = Char.GetItemIndex(player,itemSlot);
       if (ItemIndex>0) then
           local name = Item.GetData(ItemIndex, CONST.道具_名字);
           local itemid = Item.GetData(ItemIndex,CONST.道具_ID);
           local count = Item.GetData(ItemIndex,CONST.道具_堆叠数);
           local itemdur = Item.GetData(ItemIndex,CONST.道具_耐久);
           local itemlv = Item.GetData(ItemIndex,CONST.道具_等级);
           if (itemid>=73801 and itemid<=73958 and itemdur<100) then
              NLG.SystemMessage(player, "[系統]非全新的魔法卷軸無法存入！");
              return;
           elseif (itemid>=73801 and itemid<=73958 and itemlv>=7) then
              NLG.SystemMessage(player, "[系統]等級7以上的魔法卷軸無法存入！");
              return;
           elseif (itemid>=73801 and itemid<=73958) then
              local cdk = Char.GetData(player,CONST.对象_CDK);
              local sqldata = SQL.Run("select ReelBag from lua_hook_character where CdKey='"..cdk.."'")["0_0"]
              local itemData = {};
              if (type(sqldata)=="string" and sqldata~='') then
                   itemData = JSON.decode(sqldata);
              else
                   itemData = {};
              end
              --更新数据
              local boxCheck = 0;
              for k, v in pairs(itemData) do
                   if (itemData[k]~=nil and itemData[k][2]==itemid)  then
                         itemData[k][3] = itemData[k][3] + count;
                   elseif (itemData[k][1]~=itemid) then
                         boxCheck = boxCheck+1;
                   end
              end
              local boxlen = tonumber(#itemData);
              if ( boxCheck==boxlen )  then
                         local boxEX=boxlen+1;
                         itemData[boxEX] = {}
                         table.insert(itemData[boxEX], name);
                         table.insert(itemData[boxEX], itemid);
                         table.insert(itemData[boxEX], count);
              end
              --排序数据
              function my_comp(a, b)
                            return a[2] < b[2]
              end
              table.sort(itemData, my_comp);
              --上传数据
              local sqldata = itemData;
              local newdata = JSON.encode(sqldata);
              SQL.Run("update lua_hook_character set ReelBag= '"..newdata.."' where CdKey='"..cdk.."'")
              Char.DelItemBySlot(player, itemSlot);
              NLG.UpChar(player);
           else
              NLG.SystemMessage(player, "[系統]只有魔法卷軸可以存入！");
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

function Module:onUnload()
    self:logInfo('unload')
end

return Module;
