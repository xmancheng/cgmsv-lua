local Module = ModuleBase:createModule('StrengthShop');

local itemFields={
CONST.道具_类型,
CONST.道具_堆叠数,
CONST.道具_等级,
CONST.道具_耐久,
CONST.道具_最大耐久,
CONST.道具_攻击,
CONST.道具_防御,
CONST.道具_敏捷,
CONST.道具_精神,
CONST.道具_回复,
CONST.道具_必杀,
CONST.道具_反击,
CONST.道具_命中,
CONST.道具_闪躲,
CONST.道具_生命,
CONST.道具_魔力,
CONST.道具_毒抗,
CONST.道具_睡抗,
CONST.道具_石抗,
CONST.道具_醉抗,
CONST.道具_乱抗,
CONST.道具_忘抗,
CONST.道具_魔抗,
CONST.道具_魔攻,
}

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
    local data = tonumber(_data)
    print(seqno,select,data)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    if seqno == 1 then
     if data == 1 then
        SQL.querySQL([[ALTER TABLE lua_hook_character ADD ReelBag mediumtext COLLATE gbk_bin NULL;]])
        local cdk = Char.GetData(player,CONST.对象_CDK);
        local sqldata = SQL.Run("select ReelBag from lua_hook_character where CdKey='"..cdk.."'")["0_0"]
        local itemData = {};
        if (type(sqldata)=="string") then
               itemData = JSON.decode(sqldata);
               itemMenu = itemData;
        else
               itemMenu={};
        end
        -- 回调 data = 0:物品序号(基于本次交易)|N:购买数量|物品2序号|物品2数量...
        -- 数据结构 NPC图档|窗口标题|NPC对话|钱不够对话|拿不下或数量不够对话|物品N名称|物品N图档|物品N价格|物品N介绍|物品N类型|可否购买, 0不可, 1可|
        local windowStr = '231050|卷軸倉庫|準備取出卷軸…\n這些是你曾經存入的\n各式各樣的卷軸哦|\n你錢不夠|\n你拿不下了|';
        for itemSlot=1, 20 do
            local ItemIndex = Char.GetItemIndex(player,itemSlot);
            if (ItemIndex>0) then
                 local ItemName = Item.GetData(ItemIndex, CONST.道具_名字);
                 local ItemImage = Item.GetData(ItemIndex, CONST.道具_图);
                 local ItemType = Item.GetData(ItemIndex, CONST.道具_类型);
                 local ItemID = Item.GetData(ItemIndex,CONST.道具_ID);
                 local itemInfo = self:extractItemData(ItemIndex);
                 windowStr = windowStr..''..ItemName..'|'..ItemImage..'|0|$5物品'..itemSlot..'介绍|'..ItemType..'|1|';
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



    if seqno == 12 then
       if (select == CONST.按钮_关闭) then
                 return;
       end
       local itemSlot=data+7;
       local ItemIndex = Char.GetItemIndex(player,itemSlot);
       if (ItemIndex>0) then
           local name = Item.GetData(ItemIndex, CONST.道具_名字);
           local itemid = Item.GetData(ItemIndex,CONST.道具_ID);
           local count = Item.GetData(ItemIndex,CONST.道具_堆叠数);
           if (itemid>=73801 and itemid<=73958) then
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
                   elseif (itemData[k][2]~=itemid) then
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
              NLG.UpChar(player);
           else
              NLG.SystemMessage(player, "[系統]如果不是魔法卷軸將無法存入！");
           end
       end
    end

  end)

end

function Module:extractItemData(ItemIndex)
  local item = {
    attr={},
  };
  for _, v in pairs(itemFields) do
    item.attr[tostring(v)] = Item.GetData(ItemIndex, v);
  end
  return item;
end

function Module:onUnload()
    self:logInfo('unload')
end

return Module;
