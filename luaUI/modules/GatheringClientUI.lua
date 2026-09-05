--==============================================================================
-- 探索指引 - 客戶端 UI 模組
--==============================================================================
local GatheringModule = ModuleBase:extend('GatheringClientUI')
local WIN_ID = 90009
local COMMAND = "gathering"

-- ====================== 圖片路徑定義 ======================
local BG_frameIMG        = "luaUI/modules/cg图档集/特殊介面/介面视窗.png"
local BG_colorIMG        = "luaUI/modules/cg图档集/特殊介面/黑底.png"
local BG_themeIMG        = "luaUI/modules/cg图档集/特殊介面/Collection.png"

local CLOSE_BTN     = "luaUI/modules/cg图档集/特殊介面/关1.png"
local CLOSE_HOVER   = "luaUI/modules/cg图档集/特殊介面/关2.png"
local CLOSE_PRESS   = "luaUI/modules/cg图档集/特殊介面/关3.png"

local BTN_STATE   = "luaUI/modules/cg图档集/特殊介面/btn_state.png"
local BTN_PRESS   = "luaUI/modules/cg图档集/特殊介面/btn_press.png"

local Axe_IMG     = "luaUI/modules/cg图档集/特殊介面/27926.png"
local Bow_IMG     = "luaUI/modules/cg图档集/特殊介面/27937.png"
local Hawk_IMG    = "luaUI/modules/cg图档集/特殊介面/27930.png"
--------------------------------------------------------------------------------
-- 1. 生命週期與初始化
--------------------------------------------------------------------------------
function GatheringModule:onLoad()
    print("[Gathering] 探索指引UI模組載入成功")
    WinMgr.PlaySe(73,320)
    self:cliSendMsg('load GatheringClientUI.lua 成功',4)

    self.wnd = nil
    self.strGroup = {}
    self.gather_tbl = {}

    -- 接收來自客戶端按鈕的呼叫)
    self:onPacketRecv("SyncGatheringData", function(header, params)
        if params then
            -- 請求服務端傳送數據
            self:sendPacket("RequestGatheringData")
        end
    end)
    -- 接收後端回傳的遊戲數據，建構與更新前端UI介面
    self:onPacketRecv("ResponseGatheringData", function(header, params)
        if params then
            local str = params[1] or ""
            local arr = self:split(str, "|")
            local group = 1;
            for i = 1, 3 do
              local gather = self:split(arr[i], ",")
              self.gather_tbl[group] = gather[1];
              self.gather_tbl[group+1] = gather[2];
              self.gather_tbl[group+2] = gather[3];
              group = group+3;
            end
            self.gather_tbl = self.gather_tbl
            if not self.wnd then
                self:CreateWin()
                self:UpdateUI()
            else
                self:UpdateUI()
            end
        end
    end)
end

function GatheringModule:onUnload()
    if self.wnd then
        self.wnd:Close()
        self:releaseWindow(self.wnd)
        self.wnd = nil
    end
end

--------------------------------------------------------------------------------
-- 2. UI 建立與控制
--------------------------------------------------------------------------------
function GatheringModule:ToggleGathering()
    WinMgr.PlaySe(56, CONST.Screen.Width / 2)
    if self.wnd and self.wnd.valid then
        self.wnd:Close()
        self:releaseWindow(self.wnd)
        self.wnd = nil
    else
        self:CreateWin()
    end
end

function GatheringModule:CreateWin_Update()
	local player_Status = self:findWindow(7)	--玩家狀態栏7
	if player_Status == nil then
		if self.wnd and self.wnd.valid then
			self.wnd:Close()
			self:releaseWindow(self.wnd)
			self.wnd = nil
		end
	end
end

function GatheringModule:CreateWin()
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
    window:AddPngImage({ x = 8, y = 26, width = winW-33, height = winH-35, image = BG_themeIMG, hitable = false })
    --- 視窗外框
    window:AddPngImage({ x = 0, y = 0, width = winW, height = winH, image = BG_frameIMG, hitable = false })
    -- 關閉按鈕
    window:AddPngImage({
        x = 532, y = 8, width = 12, height = 12,
        image = CLOSE_BTN, imageHover = CLOSE_HOVER, imagePress = CLOSE_PRESS,
        hitable = true,
        onClick = function()
            self:ToggleGathering()
            return true
        end
    })

    -- 頂部文字資訊
    window:AddText({ x = 230, y = 10, width = 20, height = 20, font = 4, color = 75, text = "探索物品指引" })	--color:16灰白色33深紫色69朱紅色72深棕色

    self.strGroup = {}
    -- 採集物指引
    self.lblAxeIMG = window:AddPngImage({ x = 50, y = 50, width = 48, height = 40, image = Axe_IMG, imageHover = Axe_IMG, imagePress = Axe_IMG, hitable = true,
        onClick = function() self.lblAxeIMG:Set({x = 50, y = 50, width = 48, height = 40 , visible=true}) WinMgr.PlaySe(51,CONST.Screen.Width/2) self:OnlblAxeIMGClick() end,
        onHover = function() self.lblAxeIMG:Set({x = 48, y = 48, width = 52, height = 44 , visible=true}) end,
        onLeave = function() self.lblAxeIMG:Set({x = 50, y = 50, width = 48, height = 40 , visible=true}) end
    })
    self.lblAxe = window:AddText({ x = 120, y = 60, width = 150, height = 24, font = 0, color = 102, text = "伐木之斧"})
    for key = 1,3 do
        local str = window:AddText({
            x = self.lblAxe.x + (key-1)*120, y = self.lblAxe.y + 40, width = 24, height = 16,
            font = 0, color = 16, text = self.gather_tbl[key]
        })
        self.strGroup[key] = str;
    end
    self.lblBowIMG = window:AddPngImage({ x = 50, y = 150, width = 48, height = 40, image = Bow_IMG, imageHover = Bow_IMG, imagePress = Bow_IMG, hitable = true,
        onClick = function() self.lblBowIMG:Set({x = 50, y = 150, width = 48, height = 40 , visible=true}) WinMgr.PlaySe(51,CONST.Screen.Width/2) self:OnlblBowIMGClick() end,
        onHover = function() self.lblBowIMG:Set({x = 48, y = 148, width = 52, height = 44 , visible=true}) end,
        onLeave = function() self.lblBowIMG:Set({x = 50, y = 150, width = 48, height = 40 , visible=true}) end
    })
    self.lblBow = window:AddText({ x = 120, y = 160, width = 150, height = 24, font = 0, color = 110, text = "狩獵之弓"})
    for key = 4,6 do
        local str = window:AddText({
            x = self.lblBow.x + (key-4)*120, y = self.lblBow.y + 40, width = 24, height = 16,
            font = 0, color = 16, text = self.gather_tbl[key]
        })
        self.strGroup[key] = str;
    end
    self.lblHawkIMG = window:AddPngImage({ x = 50, y = 250, width = 48, height = 40, image = Hawk_IMG, imageHover = Hawk_IMG, imagePress = Hawk_IMG, hitable = true,
        onClick = function() self.lblHawkIMG:Set({x = 50, y = 250, width = 48, height = 40 , visible=true}) WinMgr.PlaySe(51,CONST.Screen.Width/2) self:OnlblHawkIMGClick() end,
        onHover = function() self.lblHawkIMG:Set({x = 48, y = 248, width = 52, height = 44 , visible=true}) end,
        onLeave = function() self.lblHawkIMG:Set({x = 50, y = 250, width = 48, height = 40 , visible=true}) end
    })
    self.lblHawk = window:AddText({ x = 120, y = 260, width = 150, height = 24, font = 0, color = 116, text = "挖掘之槁"})
    for key = 7,9 do
        local str = window:AddText({
            x = self.lblHawk.x + (key-7)*120, y = self.lblHawk.y + 40, width = 24, height = 16,
            font = 0, color = 16, text = self.gather_tbl[key]
        })
        self.strGroup[key] = str;
    end
end

--------------------------------------------------------------------------------
-- 3. 介面刷新
--------------------------------------------------------------------------------
function GatheringModule:UpdateUI()
    if not self.wnd then return end
    -- 採集物指引
    self.lblAxe:Set({text = "伐木之斧"})
    for key = 1,3 do
        local Fcolor=16;
        if self.gather_tbl[key]~="無物品" then Fcolor=0 end
        self.strGroup[key]:Set({color = Fcolor, text = self.gather_tbl[key]})
    end
    self.lblBow:Set({text = "狩獵之弓"})
    for key = 4,6 do
        local Fcolor=16;
        if self.gather_tbl[key]~="無物品" then Fcolor=0 end
        self.strGroup[key]:Set({color = Fcolor, text = self.gather_tbl[key]})
    end
    self.lblHawk:Set({text = "挖掘之槁"})
    for key = 7,9 do
        local Fcolor=16;
        if self.gather_tbl[key]~="無物品" then Fcolor=0 end
        self.strGroup[key]:Set({color = Fcolor, text = self.gather_tbl[key]})
    end
end

-- 點擊圖示開始採集
function GatheringModule:OnlblAxeIMGClick()
    WinMgr.SendPacket("StartGathering", "Log")
end
function GatheringModule:OnlblBowIMGClick()
    WinMgr.SendPacket("StartGathering", "Hunter")
end
function GatheringModule:OnlblHawkIMGClick()
    WinMgr.SendPacket("StartGathering", "Miner")
end

function GatheringModule:split(str, sep)
    local result = {}
    if not str then return result end
    for value in string.gmatch(str, "[^"..sep.."]+") do
        table.insert(result, value)
    end
    return result
end

return GatheringModule