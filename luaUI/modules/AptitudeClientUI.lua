--==============================================================================
-- 勇者適性天賦系統 - 客戶端 UI 模組 (Chakra Aptitude Tree Client UI)
--==============================================================================
local AptitudeModule = ModuleBase:extend('AptitudeClientUI')
local WIN_ID = 90008
local COMMAND = "aptitude"

-- ====================== 圖片路徑定義 ======================
local BG_frameIMG        = "luaUI/modules/cg图档集/特殊介面/介面视窗.png"
local BG_colorIMG        = "luaUI/modules/cg图档集/特殊介面/黑底.png"
local BG_themeIMG        = "luaUI/modules/cg图档集/勇者适性/Chakra.png"
local TOOLTIP_BG    = "luaUI/modules/cg图档集/勇者适性/能力信息.png"
local CLOSE_BTN     = "luaUI/modules/cg图档集/特殊介面/关1.png"
local CLOSE_HOVER   = "luaUI/modules/cg图档集/特殊介面/关2.png"
local CLOSE_PRESS   = "luaUI/modules/cg图档集/特殊介面/关3.png"

local CON_TAINER   = "luaUI/modules/cg图档集/勇者适性/container.png"
local BTN_STATE   = "luaUI/modules/cg图档集/特殊介面/btn_state.png"
local BTN_PRESS   = "luaUI/modules/cg图档集/特殊介面/btn_press.png"

--------------------------------------------------------------------------------
-- 1. 數據配置與常數定義
--------------------------------------------------------------------------------
-- 天賦基本定義 (1~8 id 對應 8 個天賦)
local AdventureAptitude = {
    HP_REGEN   = { id = 1, key = "HP_REGEN",   name = "快速恢復", desc = "戰鬥中自動回復生命", maxLevel = 10, chakra = "《海底輪 Root Chakra》" },
    MP_REGEN   = { id = 2, key = "MP_REGEN",   name = "禪心法源", desc = "戰鬥中自動回復魔力", maxLevel = 10, chakra = "《本我輪 Sacral Chakra》" },
    CRIT_RATE  = { id = 3, key = "CRIT_RATE",  name = "致命洞悉", desc = "提升暴擊發生機率", maxLevel = 10, chakra = "《心輪 Heart Chakra》" },
    CRIT_DMG   = { id = 4, key = "CRIT_DMG",   name = "致命狂擊", desc = "提升暴擊傷害倍率", maxLevel = 10, chakra = "《太陽輪 Solar Plexus》" },
    DOUBLE_HIT = { id = 5, key = "DOUBLE_HIT",  name = "追擊節奏", desc = "提升二連擊觸發機率", maxLevel = 10, chakra = "《頂輪 Crown Chakra》" },
    STATUS     = { id = 6, key = "STATUS",      name = "厄詭滲透", desc = "有機率附加異常狀態", maxLevel = 10, chakra = "《喉輪 Throat Chakra》" },
    LOOT       = { id = 7, key = "LOOT",        name = "掠奪妙手", desc = "提升掉落與偷竊機率", maxLevel = 10, chakra = "《眉心輪 Third Eye》" },
    EXECUTE    = { id = 8, key = "EXECUTE",     name = "終結預感", desc = "有機率直接終結敵人", maxLevel = 10, chakra = "《靈魂星輪 Soul Star》" },
}
-- 每級升級所需點數 (Lv0->1 需 4 點 ... Lv9->10 需 100 點)
local AdventureAptitudeCost = {
    [1] = 4, [2] = 6, [3] = 8, [4] = 12, [5] = 18,
    [6] = 26, [7] = 38, [8] = 54, [9] = 76, [10] = 100,
}
-- 四大成長曲線數值表 (1~10級)
local AptitudeCurves = {
    STABLE = { [1]=0.15, [2]=0.25, [3]=0.35, [4]=0.45, [5]=0.55, [6]=0.65, [7]=0.75, [8]=0.85, [9]=0.93, [10]=1.00 },
    COMBAT = { [1]=0.08, [2]=0.15, [3]=0.23, [4]=0.32, [5]=0.42, [6]=0.55, [7]=0.70, [8]=0.85, [9]=0.95, [10]=1.00 },
    RISK   = { [1]=0.03, [2]=0.07, [3]=0.12, [4]=0.18, [5]=0.25, [6]=0.38, [7]=0.55, [8]=0.72, [9]=0.88, [10]=1.00 },
    EXTREME= { [1]=0.00, [2]=0.01, [3]=0.03, [4]=0.06, [5]=0.10, [6]=0.18, [7]=0.30, [8]=0.50, [9]=0.75, [10]=0.95 },
}
-- 天賦對應曲線 mapping
local AptitudeCurveMap = {
    HP_REGEN    = "STABLE",
    MP_REGEN    = "STABLE",
    CRIT_RATE   = "COMBAT",
    CRIT_DMG    = "COMBAT",
    DOUBLE_HIT  = "COMBAT",
    STATUS      = "RISK",
    LOOT        = "RISK",
    EXECUTE     = "EXTREME",
}

--------------------------------------------------------------------------------
-- 2. 脈輪佈局與圖示 ID 定義
--------------------------------------------------------------------------------
local IconSize = { w = 96, h = 96 }

local ChakraNodes = {
    HP_REGEN   = { key = "HP_REGEN",   x = 220, y = 190, iconNormal = "luaUI/modules/cg图档集/勇者适性/2001.png", iconActive = "luaUI/modules/cg图档集/勇者适性/2011.png" },
    MP_REGEN   = { key = "MP_REGEN",   x = 330, y = 190, iconNormal = "luaUI/modules/cg图档集/勇者适性/2002.png", iconActive = "luaUI/modules/cg图档集/勇者适性/2012.png" },
    CRIT_RATE  = { key = "CRIT_RATE",  x = 150, y = 275, iconNormal = "luaUI/modules/cg图档集/勇者适性/2003.png", iconActive = "luaUI/modules/cg图档集/勇者适性/2013.png" },
    CRIT_DMG   = { key = "CRIT_DMG",   x = 150, y = 105, iconNormal = "luaUI/modules/cg图档集/勇者适性/2004.png", iconActive = "luaUI/modules/cg图档集/勇者适性/2014.png" },
    DOUBLE_HIT = { key = "DOUBLE_HIT",  x = 80, y = 190, iconNormal = "luaUI/modules/cg图档集/勇者适性/2005.png", iconActive = "luaUI/modules/cg图档集/勇者适性/2015.png" },
    STATUS     = { key = "STATUS",      x = 400, y = 275, iconNormal = "luaUI/modules/cg图档集/勇者适性/2006.png", iconActive = "luaUI/modules/cg图档集/勇者适性/2016.png" },
    LOOT       = { key = "LOOT",        x = 400, y = 105,  iconNormal = "luaUI/modules/cg图档集/勇者适性/2007.png", iconActive = "luaUI/modules/cg图档集/勇者适性/2017.png" },
    EXECUTE    = { key = "EXECUTE",     x = 470, y = 190,  iconNormal = "luaUI/modules/cg图档集/勇者适性/2008.png", iconActive = "luaUI/modules/cg图档集/勇者适性/2018.png" },
}

--------------------------------------------------------------------------------
-- 3. 生命週期與初始化
--------------------------------------------------------------------------------
function AptitudeModule:onLoad()
    print("[Aptitude] 脈輪天賦UI模組載入成功")
    WinMgr.PlaySe(73,320)
    self:cliSendMsg('load AptitudeClientUI.lua 成功',4)

    self.wnd = nil
    self.tooltipWnd = nil
    self.heroLv = 1
    self.aptTable = {
        HP_REGEN = 0, MP_REGEN = 0, CRIT_RATE = 0, CRIT_DMG = 0,
        DOUBLE_HIT = 0, STATUS = 0, LOOT = 0, EXECUTE = 0
    }
    self.nodeWidgets = {}

    -- 接收來自客戶端按鈕的呼叫)
    self:onPacketRecv("SyncAptitudeData", function(header, params)
        if params then
            -- 請求服務端傳送數據
            self:sendPacket("RequestAptitudeData")
        end
    end)
    -- 接收後端回傳的遊戲數據，建構與更新前端UI介面
    self:onPacketRecv("ResponseAptitudeData", function(header, params)
        if params then
            local str = params[1] or ""
            local arr = self:split(str, "|")
            self.heroLv  = tonumber(arr[1]) or self.heroLv

            local apt = self:split(arr[2], ",")
	        self.aptTable["HP_REGEN"] = apt[1];
            self.aptTable["MP_REGEN"] = apt[2];
	        self.aptTable["CRIT_RATE"] = apt[3];
	        self.aptTable["CRIT_DMG"] = apt[4];
            self.aptTable["DOUBLE_HIT"] = apt[5];
	        self.aptTable["STATUS"] = apt[6];
	        self.aptTable["LOOT"] = apt[7];
	        self.aptTable["EXECUTE"] = apt[8];
            self.aptTable = self.aptTable
            if not self.wnd then
                self:CreateWin()
                self:UpdateUI()
            else
                self:UpdateUI()
            end
        end
    end)
end

function AptitudeModule:onUnload()
    if self.wnd then
        self.wnd:Close()
        self:releaseWindow(self.wnd)
        self.wnd = nil
    end
end

--------------------------------------------------------------------------------
-- 4. 核心計算邏輯
--------------------------------------------------------------------------------
-- 計算某天賦在指定等級下的實際效果百分比 (%)
function AptitudeModule:GetEffectRate(key, level)
    if level <= 0 then return 0 end
    local curveKey = AptitudeCurveMap[key]
    local curve = AptitudeCurves[curveKey]
    if not curve then return 0 end
    
    local rawRate = curve[level] or 0
    if key == "STATUS" then
        return math.floor(rawRate * 100 * 0.3)
    else
        return math.floor(rawRate * 100)
    end
end
-- 計算升至指定等級所需的總點數
function AptitudeModule:GetTotalCost(level)
    local total = 0
    for lv = 1, level do
        total = total + (AdventureAptitudeCost[lv] or 0)
    end
    return total
end
-- 計算玩家已使用的天賦點數
function AptitudeModule:GetUsedPoints()
    local used = 0
    for key, level in pairs(self.aptTable) do
        used = used + self:GetTotalCost(level)
    end
    return used
end
-- 計算玩家剩餘的適性點數 (heroLv * 4 - used)
function AptitudeModule:GetRemainPoints()
    local totalPoints = self.heroLv * 4
    local usedPoints = self:GetUsedPoints()
    return math.max(0, totalPoints - usedPoints)
end

--------------------------------------------------------------------------------
-- 5. UI 建立與控制
--------------------------------------------------------------------------------
function AptitudeModule:ToggleAptitude()
    WinMgr.PlaySe(56, CONST.Screen.Width / 2)
    if self.wnd and self.wnd.valid then
        self.wnd:Close()
        self:releaseWindow(self.wnd)
        self.wnd = nil
        self.tooltipWnd = nil
    else
        self:CreateWin()
    end
end

function AptitudeModule:CreateWin_Update()
	local player_Status = self:findWindow(7)	--玩家狀態栏7
	if player_Status == nil then
		if self.wnd and self.wnd.valid then
			self.wnd:Close()
			self:releaseWindow(self.wnd)
			self.wnd = nil
		end
	end
end

function AptitudeModule:CreateWin()
    if self.wnd then return end

    local winW, winH = 573, 385
    local status, window = self:newWindow({
        id = WIN_ID,
        x = (CONST.Screen.Width - winW) / 2,
        y = (CONST.Screen.Height - winH) / 2,
        width = winW,
        height = winH,
        layer = 4,
        dragMove = 1,
        update = function() self:CreateWin_Update() end,
    })

    if not window then return end
    self.wnd = self:ownWindow(window)

    -- 主介面背景
    --- 視窗底色
    window:AddPngImage({ x = 6, y = 12, width = winW-30, height = winH-20, image = BG_colorIMG, hitable = false })
    --- 視窗主題底圖
    window:AddPngImage({ x = 6, y = 12, width = winW-30, height = winH-20, image = BG_themeIMG, hitable = false })
    --- 視窗外框
    window:AddPngImage({ x = 0, y = 0, width = winW, height = winH, image = BG_frameIMG, hitable = false })
    -- 關閉按鈕
    window:AddPngImage({
        x = 532, y = 8, width = 12, height = 12,
        image = CLOSE_BTN, imageHover = CLOSE_HOVER, imagePress = CLOSE_PRESS,
        hitable = true,
        onClick = function()
            self:ToggleAptitude()
            return true
        end
    })

    -- 頂部文字資訊
    window:AddText({ x = 230, y = 10, width = 20, height = 20, font = 4, color = 75, text = "勇者適性天賦" })	--color:16灰白色33深紫色69朱紅色72深棕色
    window:AddPngImage({ x = 118, y = 32, width = 125, height = 22, image = CON_TAINER, hitable = false })
    window:AddPngImage({ x = 316, y = 32, width = 125, height = 22, image = CON_TAINER, hitable = false })
    local heroLv = self.heroLv or "--"
    local remainPts = self:GetRemainPoints() or "--"
    self.lblHeroLv = window:AddText({ x = 120, y = 35, width = 150, height = 24, font = 0, color = 50, text = "勇者等級: "..heroLv })
    self.lblRemainPts = window:AddText({ x = 320, y = 35, width = 150, height = 24, font = 0, color = 31, text = "剩餘點數: "..remainPts })

    -- 重置點數按鈕
    self.resetBtn = window:AddPngImage({
        x = 235, y = 330, width = 80, height = 25,
        image = BTN_STATE, hitable = true,
        onClick = function() self.resetBtn:Set({image = BTN_PRESS , visible=true}) WinMgr.PlaySe(51,CONST.Screen.Width/2) self:OnResetBtnClick() end,
        onHover = function() self.resetBtn:Set({image = BTN_STATE , visible=true}) self.resetStr:Set({color = 0}) end,
        onLeave = function() self.resetBtn:Set({image = BTN_STATE , visible=true}) self.resetStr:Set({color = 16})end
    })
    self.resetStr = window:AddText({ x = 240, y = 335, width = 40, height = 25, font = 0, color = 16, text = "重新分配"})

    -- 建立 8 大脈輪天賦圖示與等級標籤
    self.nodeWidgets = {}
    for key, node in pairs(ChakraNodes) do
        local btnX = node.x - IconSize.w / 2
        local btnY = node.y - IconSize.h / 2

        -- 脈輪天賦圖示按鈕
        local btn = window:AddPngImage({
            x = btnX, y = btnY, width = IconSize.w, height = IconSize.h,
            image = node.iconNormal, hitable = true,
            onClick = function() WinMgr.PlaySe(51,CONST.Screen.Width/2) self:OnNodeClick(key) end,
            onHover = function() self:ShowTooltip(key, btnX, btnY) end,
            onLeave = function() self:HideTooltip() end
        })

        -- 等級標籤 (Lv.X)
        local level = tonumber(self.aptTable[key]) or 0
        local badge = window:AddText({
            x = btnX + 30, y = btnY + 60, width = 24, height = 16,
            font = 0, color = 16, text = "Lv."..level
        })

        self.nodeWidgets[key] = { button = btn, badge = badge }
    end

    -- Tooltip 懸停視窗 (使用 能力信息.png)
    self.tooltipWnd = window:AddPngImage({
        x = 0, y = 0, width = 269, height = 127,
        image = TOOLTIP_BG, visible = false, hitable = false
    })

    self.tipTitle = window:AddText({ x = 10, y = 8, width = 190, height = 20, font = 4, color = 4, text = "", visible = true })
    self.tipChakra = window:AddText({ x = 10, y = 26, width = 190, height = 16, font = 4, color = 41, text = "", visible = true })
    self.tipCurEffect = window:AddText({ x = 10, y = 46, width = 190, height = 18, font = 4, color = 0, text = "", visible = true })
    self.tipNextEffect = window:AddText({ x = 10, y = 64, width = 190, height = 18, font = 4, color = 5, text = "", visible = true })
    self.tipCost = window:AddText({ x = 10, y = 84, width = 190, height = 18, font = 4, color = 5, text = "", visible = true })
end

--------------------------------------------------------------------------------
-- 6. 介面刷新與 Tooltip 控制
--------------------------------------------------------------------------------
function AptitudeModule:UpdateUI()
    if not self.wnd then return end

    local remainPts = self:GetRemainPoints()
    self.lblHeroLv:Set({text = "勇者等級: " .. self.heroLv})
    self.lblRemainPts:Set({text = "剩餘點數: " .. remainPts})

    for key, widgetGroup in pairs(self.nodeWidgets) do
        local level = tonumber(self.aptTable[key]) or 0
        local node = ChakraNodes[key]

        widgetGroup.badge:Set({text = "Lv."..level})
        if level > 0 then
            if level >= 10 then
              widgetGroup.badge:Set({color = 4})	--滿級10黃字
            else
              widgetGroup.badge:Set({color = 0})	--1級白字
            end
            widgetGroup.button:Set({image = node.iconActive , visible=true})
        else
            widgetGroup.button:Set({image = node.iconNormal , visible=true})
        end
    end
end

function AptitudeModule:ShowTooltip(key, btnX, btnY)
    if not self.tooltipWnd then return end
    local info = AdventureAptitude[key]
    if not info then return end

    local level = tonumber(self.aptTable[key]) or 0
    local curRate = self:GetEffectRate(key, level)
    local remainPts = self:GetRemainPoints()

    self.tipTitle:Set({text = info.name .. "〔Lv." .. level .. "/" .. info.maxLevel .. "〕"})
    self.tipChakra:Set({text = info.chakra})
    self.tipCurEffect:Set({text = "當前: " .. info.desc .. " (" .. curRate .. "%)"})

    if level >= info.maxLevel then
        self.tipNextEffect:Set({text = "上限: 已達最高等級", color = 84})
        self.tipCost:Set({text = "所需點數: --"})
    else
        local nextLevel = level + 1
        local nextRate = self:GetEffectRate(key, nextLevel)
        local cost = AdventureAptitudeCost[nextLevel] or 0

        self.tipNextEffect:Set({text = "下級: " .. info.desc .. " (" .. nextRate .. "%)", color = 5})
        if remainPts >= cost then
            self.tipCost:Set({text = "升級消耗: " .. cost .. " 點 (可升級)", color = 85})
        else
            self.tipCost:Set({text = "升級消耗: " .. cost .. " 點 (點數不足)", color = 89})
        end
    end

    -- 設定位置與顯示
    local tipX = btnX + IconSize.w + 10
    local tipY = btnY - 10
    if tipX + 210 > 550 then tipX = btnX - 273 end

    self.tooltipWnd:Set({x = tipX, y = tipY, visible = true})
    self.tipTitle:Set({ x = tipX+14, y = tipY+12, visible = true })
    self.tipChakra:Set({ x = tipX+14, y = tipY+30, visible = true })
    self.tipCurEffect:Set({ x = tipX+14, y = tipY+55, visible = true })
    self.tipNextEffect:Set({ x = tipX+14, y = tipY+73, visible = true })
    self.tipCost:Set({ x = tipX+14, y = tipY+100, visible = true })
end

function AptitudeModule:HideTooltip()
    if not self.tooltipWnd then return end
    self.tooltipWnd:Set({visible = false})
    self.tipTitle:Set({visible = false})
    self.tipChakra:Set({visible = false})
    self.tipCurEffect:Set({visible = false})
    self.tipNextEffect:Set({visible = false})
    self.tipCost:Set({visible = false})
end

function AptitudeModule:OnNodeClick(key)
    local aptInfo = AdventureAptitude[key]
    if aptInfo then
        -- 直接向服務端送出升級請求，判斷與點數扣除完全交給服務端
        WinMgr.SendPacket("UpdateAptitudeData", key)
    end
end

function AptitudeModule:OnResetBtnClick()
    WinMgr.SendPacket("ResetAptitudeData", "reset")
end

function AptitudeModule:split(str, sep)
    local result = {}
    if not str then return result end
    for value in string.gmatch(str, "[^"..sep.."]+") do
        table.insert(result, value)
    end
    return result
end

return AptitudeModule