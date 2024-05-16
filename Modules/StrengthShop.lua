local Module = ModuleBase:createModule('StrengthShop');

function Module:onLoad()
  self:logInfo('load')
  local StrengthShopNPC = self:NPC_createNormal('魔法卷軸倉庫', 231050, { x = 235, y = 114, mapType = 0, map = 1000, direction = 0 });
  self:NPC_regTalkedEvent(StrengthShopNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        -- 回调 data = 1:买, 2:卖
        -- 数据结构 NPC图档|窗口标题|NPC对话|买卖类型 0:无按钮, 1:买, 2:卖, 3:买卖|
        local windowStr = '231050|卷軸倉庫|魔法卷軸存取功能\n暫時將卷軸存入倉庫|3|'
        NLG.ShowWindowTalked(player, StrengthShopNPC, CONST.窗口_买卖框, CONST.按钮_关闭, 1, windowStr);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(StrengthShopNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    print(seqno,select,data)
    if seqno == 1 then
     if data == 1 then
        -- 回调 data = 0:物品序号(基于本次交易)|N:购买数量|物品2序号|物品2数量...
        -- 数据结构 NPC图档|窗口标题|NPC对话|钱不够对话|拿不下或数量不够对话|物品N名称|物品N图档|物品N价格|物品N介绍|物品N类型|可否购买, 0不可, 1可|
        local windowStr = '231050|卷軸倉庫|準備取出卷軸…\n這些是你曾經存入的\n各式各樣的卷軸哦|\n你錢不夠|\n你拿不下了|';
        for i=1, 20 do
                windowStr = windowStr..'物品'..i..'名称|'..27131+i..'|0|$5物品'..i..'介绍|29|1|';
        end
        NLG.ShowWindowTalked(player, StrengthShopNPC, CONST.窗口_买框, CONST.按钮_关闭, 11, windowStr);
     elseif data == 2 then
        -- 回调 data = 0:物品序号(基于本次交易)|N:购买数量|物品2序号|物品2数量...
        -- 数据结构 NPC图档|窗口标题|NPC对话|物品N名称|物品N已有数量|物品N图档|物品N单价|物品id,建议为itemIndex|未知1|未知2|物品N介绍|可否售卖, 0不可, 1可|物品N每组数量|
        local windowStr = '231050|卷軸倉庫|準備存入卷軸…\n這些是你有的東西哦|';
        for i=1, 20 do
                windowStr = windowStr..'物品'..i..'名称|500|27132|0|'..10086+i..'|1|2|$5物品'..i..'介绍|1|3|';
        end
        NLG.ShowWindowTalked(player, StrengthShopNPC, CONST.窗口_卖框, CONST.按钮_关闭, 12, windowStr);
     end
    end



  end)

end


function Module:onUnload()
    self:logInfo('unload')
end

return Module;