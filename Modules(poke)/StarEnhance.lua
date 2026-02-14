---模块类
local Module = ModuleBase:createModule('StarEnhance')

-- [[ 配置信息 ]]
local MAX_LEVEL = 10;
local TARGET_BAG_SLOT = 8;		-- 物品欄第一格（通常索引為 8）

local SUCCESS_RATES = { 90, 90, 90, 80, 70, 60, 50, 40, 30, 20, };
local COST_GOLD = { 1000, 1000, 2000, 4000, 8000, 16000, 32000, 64000, 128000, 256000, };
local BONUS_PCT = { [1]=10, [2]=20, [3]=30, [4]=60, [5]=70, [6]=80, [7]=140, [8]=200, [9]=300, [10]=500, };

-- 影響屬性清單
local AFFECT_ATTRS = {
    CONST.道具_攻击, CONST.道具_防御, CONST.道具_敏捷, CONST.道具_精神, CONST.道具_回复,
    CONST.道具_生命, CONST.道具_魔力, CONST.道具_耐力, CONST.道具_灵巧, CONST.道具_智力,
    CONST.道具_必杀, CONST.道具_反击, CONST.道具_命中, CONST.道具_闪躲,
    CONST.道具_毒抗, CONST.道具_睡抗, CONST.道具_石抗, CONST.道具_醉抗, CONST.道具_乱抗, CONST.道具_忘抗,
    CONST.道具_魔抗, CONST.道具_魔攻
}

-------------------------------------
--- 加载模块钩子
function Module:onLoad()
    self:logInfo('load')
    -- 創建 NPC (忽克連)
    self.enhanceNPC = self:NPC_createNormal('忽克連', 14513, { x = 225, y = 83, mapType = 0, map = 1000, direction = 4 })
    Char.SetData(self.enhanceNPC,CONST.对象_ENEMY_PetFlg+2,0)--可穿透体
    -- 註冊對話事件
    self:NPC_regTalkedEvent(self.enhanceNPC, function(npc, player)
        if NLG.CanTalk(npc, player) then
            self:openConfirmWindow(npc, player)
        end
    end)
    -- 註冊窗口事件
    self:NPC_regWindowTalkedEvent(self.enhanceNPC, function(npc, player, seqno, select, data)
        if seqno == 1 and select == CONST.按钮_确定 then
            doEnhance(player)
            -- 強化完後自動重新打開窗口，方便連續強化
            self:openConfirmWindow(npc, player)
        end
    end)

end

-- [[ NPC 交互界面 ]]
function Module:openConfirmWindow(npc, player)
    local itemIndex = Char.GetItemIndex(player, TARGET_BAG_SLOT)
    
    -- 合法性檢查
    if itemIndex < 0 then
        NLG.SystemMessage(player, "[系統] 請將要強化的武器/裝備放在物品欄第一格（左上角）。")
        return
    end
    local itemType = Item.GetData(itemIndex, CONST.道具_类型)
    if not (Item.Types.isWeapon(itemType) or Item.Types.isArmour(itemType)) then
        NLG.SystemMessage(player, "[系統] 物品欄第一格必須是武器或防具裝備。")
        return
    end

    local data = ensureBaseData(itemIndex, player)
    local lv = data.starEnhance.level
    if lv >= MAX_LEVEL then
        NLG.SystemMessage(player, "[系統] 該裝備已達最高強化等級。")
        return
    end

    local cost = COST_GOLD[lv + 1]
    local rate = SUCCESS_RATES[lv + 1]
    
    local msg = "  【 裝備強化系統 】\n"
             .. "--------------------------\n"
             .. "目標裝備：" .. data.starEnhance.baseName .. "\n"
             .. "當前狀態：" .. buildStarString(lv) .. " (+" .. lv .. ")\n"
             .. "強化目標：" .. buildStarString(lv+1) .. " (+" .. (lv+1) .. ")\n"
             .. "屬性加成：" .. (BONUS_PCT[lv+1] or 0) .. "%\n"
             .. "成功機率：" .. rate .. "%\n"
             .. "消耗魔幣：" .. cost .. "\n\n"
             .. "提示：強化失敗會掉 1 級，是否繼續？"

    NLG.ShowWindowTalked(player, npc, 0, CONST.按钮_确定关闭, 1, msg)
end

-------------------------------------
-- [[ 工具函數 ]]
-- 四捨五入
function roundHalfUp(x)
    return x >= 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)
end

-- 建立星星標記字符串
function buildStarString(level)
    level = math.max(0, math.min(MAX_LEVEL, level or 0))
    return string.rep('★', level) .. string.rep('☆', MAX_LEVEL - level)
end

-- 清除名稱後綴 (防重複疊加)
function stripEnhanceSuffix(name)
    if not name then return "" end
    return name:gsub('%s*%+%d+$', ''):gsub('%s*＋%d+$', '')
end

-- [[ 數據持久化處理 (ExtData) ]]
-- 讀取裝備強化數據
function getStarData(itemIndex)
    local data = { starEnhance = { baseName = "", baseAttrs = {}, level = 0 } }
    local rawStr = Item.GetExtData(itemIndex, '装备强化')
    
    if type(rawStr) == "string" and rawStr ~= "" then
        local parts = string.split(rawStr, "|")
        data.starEnhance.baseName = parts[1]
        
        local attrVals = string.split(parts[2], ",")
        for i, attrId in ipairs(AFFECT_ATTRS) do
            data.starEnhance.baseAttrs[tostring(attrId)] = tonumber(attrVals[i]) or 0
        end
        data.starEnhance.level = tonumber(parts[3]) or 0
    end
    return data
end

-- 寫入裝備強化數據
function setStarData(itemIndex, data)
    local attrList = {}
    for _, attrId in ipairs(AFFECT_ATTRS) do
        table.insert(attrList, data.starEnhance.baseAttrs[tostring(attrId)] or 0)
    end
    local attrStr = table.concat(attrList, ",")
    local finalStr = string.format("%s|%s|%d", data.starEnhance.baseName, attrStr, data.starEnhance.level)
    Item.SetExtData(itemIndex, '装备强化', finalStr)
end

-- 初始化/檢查基礎數據
function ensureBaseData(itemIndex, player)
    local data = getStarData(itemIndex)
    local dirty = false

    if data.starEnhance.baseName == "" then
        data.starEnhance.baseName = stripEnhanceSuffix(Item.GetData(itemIndex, CONST.道具_名字))
        dirty = true
    end

    for _, attrId in ipairs(AFFECT_ATTRS) do
        local key = tostring(attrId)
        if not data.starEnhance.baseAttrs[key] then
            data.starEnhance.baseAttrs[key] = tonumber(Item.GetData(itemIndex, attrId)) or 0
            dirty = true
        end
    end

    if dirty then
        setStarData(itemIndex, data)
        Item.UpItem(player, TARGET_BAG_SLOT)
    end
    return data
end

-- [[ 核心邏輯 ]]
-- 套用屬性與名稱
function applyEnhanceEffect(player, itemIndex, level)
    local data = getStarData(itemIndex)
    local bonus = BONUS_PCT[level] or 0
    
    -- 更新名稱
    local newName = data.starEnhance.baseName .. (level > 0 and ("+" .. level) or "")
    Item.SetData(itemIndex, CONST.道具_名字, newName)

    -- 更新屬性
    for _, attrId in ipairs(AFFECT_ATTRS) do
        local base = data.starEnhance.baseAttrs[tostring(attrId)] or 0
        if base ~= 0 then
            local newVal = roundHalfUp(base * (100 + bonus) / 100)
            Item.SetData(itemIndex, attrId, newVal)
        end
    end

    Item.UpItem(player, TARGET_BAG_SLOT)
    NLG.UpChar(player)
end

-- 執行強化動作
function doEnhance(player)
    local itemIndex = Char.GetItemIndex(player, TARGET_BAG_SLOT)
    if itemIndex < 0 then return end

    local data = ensureBaseData(itemIndex, player)
    local curLevel = data.starEnhance.level
    if curLevel >= MAX_LEVEL then return end

    local cost = COST_GOLD[curLevel + 1]
    if Char.GetData(player, CONST.对象_金币) < cost then
        NLG.SystemMessage(player, "[系統] 金幣不足強化需要魔幣: " .. cost .."。")
        return
    end

    -- 扣費
    Char.AddGold(player, -cost)

    -- 隨機判定
    local rate = SUCCESS_RATES[curLevel + 1]
    if math.random(1, 100) <= rate then
        local nextLevel = curLevel + 1
        data.starEnhance.level = nextLevel
        setStarData(itemIndex, data)
        applyEnhanceEffect(player, itemIndex, nextLevel)
        
        NLG.SystemMessage(player, string.format("[系統] 強化成功！目前等級 +%d", nextLevel))
        
        -- 全服公告
        if nextLevel == 4 or nextLevel == 7 or nextLevel == 10 then
            local msg = string.format("【強化】玩家 %s 成功將 %s 強化至 +%d！", Char.GetData(player, CONST.对象_名字), data.starEnhance.baseName, nextLevel)
            NLG.SystemMessage(-1, msg)
        end
    else
        local failLevel = math.max(0, curLevel - 1)
        data.starEnhance.level = failLevel
        setStarData(itemIndex, data)
        applyEnhanceEffect(player, itemIndex, failLevel)
        NLG.SystemMessage(player, string.format("[系統] 強化失敗，等級降至 +%d", failLevel))
    end
end


--- 卸载模块钩子
function Module:onUnload()
    self:logInfo('unload')
end

return Module