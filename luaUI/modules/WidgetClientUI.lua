--==============================================================================
-- 各式掛件UI整合 - 客戶端 UI 模組 (Client UI)
--==============================================================================
local Module = ModuleBase:extend('WidgetClientUI')

-- ====================== 圖片路徑定義 ======================
local BG_frameIMG        = "luaUI/modules/cg图档集/特殊介面/小介面视窗.png"
local BG_colorIMG        = "luaUI/modules/cg图档集/特殊介面/黑底.png"

local CLOSE_BTN     = "luaUI/modules/cg图档集/特殊介面/关1.png"
local CLOSE_HOVER   = "luaUI/modules/cg图档集/特殊介面/关2.png"
local CLOSE_PRESS   = "luaUI/modules/cg图档集/特殊介面/关3.png"

local BTN_STATE   = "luaUI/modules/cg图档集/特殊介面/btn_state.png"
local BTN_PRESS   = "luaUI/modules/cg图档集/特殊介面/btn_press.png"

local BG_sframeIMG = "luaUI/modules/cg图档集/特殊介面/msg_bg.png"	--採集狀態框

local frontWindowCaptureId = -1		--缓存，不要动
local player_Status_NativeId = 7		--玩家狀態7.物品栏14.小地图33

local pInfo_WIN_ID = 10101		--採集等級、勇者等級
local gathering_WIN_ID = 10102	--採集狀態

function Module:onLoad()
    print("[Widget] 各式掛件UI整合模組載入成功")
    WinMgr.PlaySe(73,320)
    self:cliSendMsg('load WidgetClientUI.lua 成功',4)
    self:onWindowFocusChanged(function(frontId,backId) self:WindowFocusChanged(frontId,backId) end)
	self:onSceneStateChanged(function(viewType,viewState) self:ViewChangeEvent(viewType,viewState) end)

    ----- 玩家擴展資訊
    self.pInfo_wnd = nil
    -- 接收後端回傳的遊戲數據，建構與更新前端UI介面
    self:onPacketRecv("ResponsePlayerInfoData", function(header, params)
        if params then
            local str = params[1] or ""
            local arr = self:split(str, "|")
            self.heroLv  = tonumber(arr[1]) or 1;
            self.heroExp  = tonumber(arr[2]) or 0;
            self.heroExp2  = tonumber(arr[3]) or 0;
            self.exploreLv  = tonumber(arr[4]) or 1;
            self.exploreExp  = tonumber(arr[5]) or 0;
            self.exploreExp2  = tonumber(arr[6]) or 0;
            self:pInfo_UpdateUI_Sring()
        end
    end)

    ----- 採集狀態資訊
    self.gathering_wnd = nil
    -- 接收後端回傳的遊戲數據，建構與更新前端UI介面
    self:onPacketRecv("IsGathering", function(header, params)
        if params then
            local packetNumber = params[1] or "0";
            local str = "採集結束"
            if packetNumber == "1" then
              str = "伐木中..."
            elseif packetNumber == "2" then
              str = "狩獵中..."
            elseif packetNumber == "3" then
              str = "挖掘中..."
            end
            print(packetNumber,str)
            if self.gathering_wnd and self.gathering_wnd.valid then
              if str == "採集結束" then
                self.gathering_wnd:Close()
                self:releaseWindow(self.gathering_wnd)
                self.gathering_wnd = nil
              else
                self.gathering_str = str;
                self:gathering_UpdateUI_Sring()
              end
            else
              self.gathering_str = str;
              self:gathering_CreateWin()
            end
        end
    end)
end

function Module:onUnload()
    if self.pInfo_wnd then
        self.pInfo_wnd:Close()
        self:releaseWindow(self.pInfo_wnd)
        self.pInfo_wnd = nil
    end
    if self.gathering_wnd then
        self.gathering_wnd:Close()
        self:releaseWindow(self.gathering_wnd)
        self.gathering_wnd = nil
    end
end

--------------------------------------------------------------------------------
-- UI 建立與控制
--------------------------------------------------------------------------------
function Module:ToggleWidget()
    WinMgr.PlaySe(56, CONST.Screen.Width / 2)
    if self.pInfo_wnd and self.pInfo_wnd.valid then
        self.pInfo_wnd:Close()
        self:releaseWindow(self.pInfo_wnd)
        self.pInfo_wnd = nil
    else
        --請求服務端傳送數據
        self:sendPacket("RequestPlayerInfoData")
        self:pInfo_CreateWin()
    end
end

function Module:ViewChangeEvent(viewType,viewState)
	-- self:cliSendMsg('场景类型 = '..viewType..' | 场景状态 = '..viewState)
	-- print('场景类型 = '..viewType..' | 场景状态 = '..viewState)
	if viewType == 9 then
		if self.pInfo_wnd and self.pInfo_wnd.valid then
			self.pInfo_wnd:Close()
			self:releaseWindow(self.pInfo_wnd)
			self.pInfo_wnd = nil
		end
	end
	-- if viewState == 104 then
		-- self:pInfo_CreateWin()
	-- end
end

function Module:WindowFocusChanged(frontId,backId)
	-- print('前台id = '..frontId..' | 后台id = '..backId)
	--print('---------------------------------------')
	frontWindowCaptureId = tonumber(frontId)
	backWindowCaptureId = tonumber(backId)

	if frontWindowCaptureId == player_Status_NativeId then
		local player_Status = self:findWindow(player_Status_NativeId)
		pInfo_Win_x = player_Status.x
		pInfo_Win_y = player_Status.y
        --請求服務端傳送數據
        self:sendPacket("RequestPlayerInfoData")
		self:pInfo_CreateWin()
	elseif frontWindowCaptureId == 80003 then
		if self.pInfo_wnd and self.pInfo_wnd.valid then
			self.pInfo_wnd:Close()
			self:releaseWindow(self.pInfo_wnd)
			self.pInfo_wnd = nil
		end
	end
end

function Module:pInfo_CreateWin_Update()
	local player_Status = self:findWindow(player_Status_NativeId)
	local pInfo_Win = self:findWindow(pInfo_WIN_ID)

	if player_Status == nil then
		if self.pInfo_wnd and self.pInfo_wnd.valid then
			self.pInfo_wnd:Close()
			self:releaseWindow(self.pInfo_wnd)
			self.pInfo_wnd = nil
		end
	else
		pInfo_Win_x = player_Status.x
		pInfo_Win_y = player_Status.y
		if self.pInfo_wnd and self.pInfo_wnd.valid then
			--請求服務端傳送數據
			self:sendPacket("RequestPlayerInfoData")
			self:pInfo_CreateWin()
			self.pInfo_wnd:Set({ x = pInfo_Win_x+350, y = pInfo_Win_y+40})
		end
	end

end

function Module:pInfo_CreateWin()
    if self.pInfo_wnd then return end

    local winW, winH = 249, 167
    local status, window = self:newWindow({
        id = pInfo_WIN_ID,
        x = pInfo_Win_x + 350,
        y = pInfo_Win_y + 40,
        -- x = (CONST.Screen.Width - winW) / 2,
        -- y = (CONST.Screen.Height - winH) / 2,
        width = winW,
        height = winH,
        layer = 4,
        dragMove = 0,
        update = function() self:pInfo_CreateWin_Update() end,
    })

    if not window then return end
    self.pInfo_wnd = self:ownWindow(window)

    -- 主介面背景
    --- 視窗底色
    -- window:AddPngImage({ x = 3, y = 12, width = winW-15, height = winH-15, image = BG_colorIMG, hitable = false })
    --- 視窗主題底圖
    -- window:AddPngImage({ x = 6, y = 12, width = winW-30, height = winH-20, image = BG_themeIMG, hitable = false })
    --- 視窗外框
    window:AddPngImage({ x = 0, y = 0, width = winW, height = winH, image = BG_frameIMG, hitable = false })
    -- 關閉按鈕
    -- window:AddPngImage({
        -- x = 230, y = 3, width = 6, height = 6,
        -- image = CLOSE_BTN, imageHover = CLOSE_HOVER, imagePress = CLOSE_PRESS,
        -- hitable = true,
        -- onClick = function() self:ToggleWidget() return true end
    -- })

    -- 頂部文字資訊
    -- window:AddText({ x = 230, y = 10, width = 20, height = 20, font = 4, color = 75, text = "特殊等級" })	--color:16灰白色33深紫色69朱紅色72深棕色

    -- 玩家擴展資訊文本
    local heroLv = self.heroLv or "1"
    local heroExp = self.heroExp or "0"
    local heroExp2 = self.heroExp or "_"
    local exploreLv = self.exploreLv or "1"
    local exploreExp = self.exploreExp or "0"
    local exploreExp2 = self.exploreExp2 or "_"
    --- 滿級顯示"--"
    if heroExp2==0 then heroExp="_" heroExp2="_" end
    if exploreExp2==0 then exploreExp="_" exploreExp2="_" end
    self.lblHeroLv = window:AddText({ x = 10, y = 20, width = 150, height = 24, font = 13, color = 96, text = "勇者等級: "..heroLv })
    self.lblHeroExp = window:AddText({ x = 10, y = 40, width = 150, height = 24, font = 13, color = 0, text = "經驗值: "..heroExp })
    self.lblHeroExp2 = window:AddText({ x = 10, y = 60, width = 150, height = 24, font = 13, color = 0, text = "下一級: "..heroExp2 })
    self.lblExploreLv = window:AddText({ x = 10, y = 90, width = 150, height = 24, font = 13, color = 96, text = "探索等級: "..exploreLv })
    self.lblExploreExp = window:AddText({ x = 10, y = 110, width = 150, height = 24, font = 13, color = 0, text = "經驗值: "..exploreExp })
    self.lblExploreExp2 = window:AddText({ x = 10, y = 130, width = 150, height = 24, font = 13, color = 0, text = "下一級: "..exploreExp2 })

    -- 勇者等級-天賦按鈕
    self.aptitudeBtn = window:AddPngImage({
        x = 160, y = 20, width = 64, height = 20,
        image = BTN_STATE, hitable = true,
        onClick = function() self.aptitudeBtn:Set({image = BTN_PRESS , visible=true}) WinMgr.PlaySe(51,CONST.Screen.Width/2) self:OnAptitudeBtnClick() end,
        onHover = function() self.aptitudeBtn:Set({image = BTN_STATE , visible=true}) self.aptitudeStr:Set({color = 0}) end,
        onLeave = function() self.aptitudeBtn:Set({image = BTN_STATE , visible=true}) self.aptitudeStr:Set({color = 16})end
    })
    self.aptitudeStr = window:AddText({ x = 165, y = 23, width = 64, height = 20, font = 13, color = 16, text = "打開天賦"})

    -- 探索地圖-指引按鈕
    self.gatheringBtn = window:AddPngImage({
        x = 160, y = 90, width = 64, height = 20,
        image = BTN_STATE, hitable = true,
        onClick = function() self.gatheringBtn:Set({image = BTN_PRESS , visible=true}) WinMgr.PlaySe(51,CONST.Screen.Width/2) self:OnGatheringBtnClick() end,
        onHover = function() self.gatheringBtn:Set({image = BTN_STATE , visible=true}) self.gatheringStr:Set({color = 0}) end,
        onLeave = function() self.gatheringBtn:Set({image = BTN_STATE , visible=true}) self.gatheringStr:Set({color = 16})end
    })
    self.gatheringStr = window:AddText({ x = 165, y = 93, width = 64, height = 20, font = 13, color = 16, text = "採集掃描"})
end

function Module:gathering_CreateWin()
    if self.gathering_wnd then return end

    local winW, winH = 162, 80
    local status, window = self:newWindow({
        id = gathering_WIN_ID,
        x = (CONST.Screen.Width - winW) / 2,
        y = (CONST.Screen.Height - winH) / 2,
        width = winW,
        height = winH,
        layer = 4,
        dragMove = 1,
    })

    if not window then return end
    self.gathering_wnd = self:ownWindow(window)

    --- 視窗
    window:AddPngImage({ x = 0, y = 0, width = winW, height = winH, image = BG_sframeIMG, hitable = false })

    local gathering_str = self.gathering_str
    self.statusStr = window:AddText({ x = 50, y = 30, width = 20, height = 20, font = 3, color = 0, text = gathering_str })
end
--------------------------------------------------------------------------------
-- 介面文本刷新
--------------------------------------------------------------------------------
-- 玩家擴展資訊文本
function Module:pInfo_UpdateUI_Sring()
    if not self.pInfo_wnd then return end

    local heroLv = self.heroLv or "1"
    local heroExp = self.heroExp or "0"
    local heroExp2 = self.heroExp or "_"
    local exploreLv = self.exploreLv or "1"
    local exploreExp = self.exploreExp or "0"
    local exploreExp2 = self.exploreExp2 or "_"
    --- 滿級顯示"--"
    if heroExp2==0 then heroExp="_" heroExp2="_" end
    if exploreExp2==0 then exploreExp="_" exploreExp2="_" end
    self.lblHeroLv:Set({text = "勇者等級: "..heroLv })
    self.lblHeroExp:Set({text = "經驗值: "..heroExp })
    self.lblHeroExp2:Set({text = "下一級: "..heroExp2 })
    self.lblExploreLv:Set({text = "探索等級: "..exploreLv })
    self.lblExploreExp:Set({text = "經驗值: "..exploreExp })
    self.lblExploreExp2:Set({text = "下一級: "..exploreExp2 })
end

function Module:gathering_UpdateUI_Sring()
    local gathering_str = self.gathering_str
    self.statusStr:Set({text = gathering_str })
end
--------------------------------------------------------------------------------
-- 傳送封包至後端
--------------------------------------------------------------------------------
function Module:OnAptitudeBtnClick()
	WinMgr.SendPacket("uiMenu", 1)
end

function Module:OnGatheringBtnClick()
	WinMgr.SendPacket("uiMenu", 2)
end

------
function Module:split(str, sep)
    local result = {}
    if not str then return result end
    for value in string.gmatch(str, "[^"..sep.."]+") do
        table.insert(result, value)
    end
    return result
end

return Module