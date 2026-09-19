--==============================================================================
-- 寵物同名吸收培養 - 客戶端 UI 模組
--==============================================================================
local CultivationModule = ModuleBase:extend('PetCultivationUI')
local B_WIN_ID = 90010
local C_WIN_ID = 90011
local C_material_List_WIN_ID = 90012
local B_material_List_WIN_ID = 90013
local COMMAND = "PetCultivation"

-- ====================== 圖片路徑定義 ======================
local BG_frameIMG        = "luaUI/modules/cg图档集/吸收培养/弹出小窗.png"
-- local BG_colorIMG        = "luaUI/modules/cg图档集/特殊介面/黑底.png"
-- local BG_themeIMG        = "luaUI/modules/cg图档集/吸收培养/Collection.png"

local CLOSE_BTN     = "luaUI/modules/cg图档集/特殊介面/关1.png"
local CLOSE_HOVER   = "luaUI/modules/cg图档集/特殊介面/关2.png"
local CLOSE_PRESS   = "luaUI/modules/cg图档集/特殊介面/关3.png"

local BTN_STATE   = "luaUI/modules/cg图档集/特殊介面/btn_state.png"
local BTN_PRESS   = "luaUI/modules/cg图档集/特殊介面/btn_press.png"

local PROGRESS_BG_IMG = "luaUI/modules/cg图档集/吸收培养/进度条.png"
local PROGRESS_FILL_IMG = "luaUI/modules/cg图档集/吸收培养/已完成进度条.png"

local SERIES_ROW_NORMAL_IMAGE = "luaUI/modules/cg图档集/吸收培养/series_row_normal.png"
local SERIES_ROW_HOVER_IMAGE = "luaUI/modules/cg图档集/吸收培养/series_row_hover.png"
local SERIES_ROW_SELECTED_IMAGE = "luaUI/modules/cg图档集/吸收培养/series_row_selected.png"
local CHECKBOX_uncheckedIMG = "luaUI/modules/cg图档集/吸收培养/checkbox_unchecked.png"
local CHECKBOX_checkedIMG = "luaUI/modules/cg图档集/吸收培养/checkbox_checked.png"
local TRANSPARENT_IMAGE = "luaUI/modules/cg图档集/吸收培养/透明.png"
-- ============================================================
local BREAKTHROUGH_CRYSTALS = {
    { index = 1, id = 18310, name = "地的水晶碎片" },
    { index = 2, id = 18311, name = "水的水晶碎片" },
    { index = 3, id = 18312, name = "火的水晶碎片" },
    { index = 4, id = 18313, name = "風的水晶碎片" },
}
local BREAKTHROUGH_RECIPES = {
    -- 4選2
    ["1,2"] = {1,2}, -- 地 + 水 → 體力 + 力量
    ["1,3"] = {1,3}, -- 地 + 火 → 體力 + 強度
    ["1,4"] = {1,4}, -- 地 + 風 → 體力 + 速度
    ["2,3"] = {1,5}, -- 水 + 火 → 體力 + 魔法
    ["2,4"] = {3,5}, -- 水 + 風 → 強度 + 魔法
    ["3,4"] = {2,4}, -- 火 + 風 → 力量 + 速度
    -- 4選3
    ["1,2,3"] = {1,2,3}, -- 地 + 水 + 火 → 體力 + 力量 + 強度
    ["1,2,4"] = {1,2,4}, -- 地 + 水 + 風 → 體力 + 力量 + 速度
    ["1,3,4"] = {1,2,5}, -- 地 + 火 + 風 → 體力 + 力量 + 魔法
    ["2,3,4"] = {3,4,5}, -- 水 + 火 + 風 → 強度 + 速度 + 魔法
}
local BREAKTHROUGH_STAT_NAMES = {
    [1] = "體力",
    [2] = "力量",
    [3] = "強度",
    [4] = "速度",
    [5] = "魔法",
}
-- 總檔次 → 每種水晶需求量
local BREAKTHROUGH_CRYSTAL_COST = {
    { min = 110, max = 120, cost = 5 },
    { min = 120, max = 125, cost = 10 },
    { min = 126, max = 130, cost = 15 },
    { min = 131, max = 135, cost = 20 },
    { min = 136, max = 139, cost = 30 },
    { min = 140, max = 144, cost = 60 },
    { min = 145, max = 149, cost = 100 },
    { min = 150, max = 154, cost = 160 },
    { min = 155, max = 159, cost = 240 },
    { min = 160, max = 164, cost = 350 },
    { min = 165, max = 169, cost = 500 },
}
-- 寵物培養分頁
local PAGE_FIRST = 1	-- 1 = 第一頁：檔次補足
local PAGE_SECOND = 2	-- 2 = 第二頁：檔次突破
--------------------------------------------------------------------------------
-- 1. 生命週期與初始化
--------------------------------------------------------------------------------
function CultivationModule:onLoad()
    print("[PetCultivation] 吸收培養UI模組載入成功")
    WinMgr.PlaySe(73,320)
    self:cliSendMsg('load PetCultivationUI.lua 成功',4)

    self.C_wnd = nil
    self.B_wnd = nil
    -- 當前所在培養分頁
    self.currentWnd = PAGE_FIRST
    -- 目前操作中的寵物 Slot
    self.petSlot = nil

    -- 第二層進度條
    self.progressBg = nil
    self.progressFill = nil
    self.grade_tbl = {
        Art1_N = 0, Art2_N = 0, Art3_N = 0, Art4_N = 0, Art5_N = 0,
        Art1_F = 0, Art2_F = 0, Art3_F = 0, Art4_F = 0, Art5_F = 0,
    }

    -- 接收來自客戶端按鈕的呼叫)
    self:onPacketRecv("SyncCultivationData", function(header, params)
        if params then
            local str = params[1] or ""
            local arr = self:split(str, "|")
            local windowType = tonumber(arr[1]) or PAGE_FIRST
            local petSlot = tonumber(arr[2])
            if not petSlot then
                return
            end

            self.currentWnd = windowType-- 記錄目前分頁
            self.petSlot = petSlot-- 記錄目前寵物
            -- 向後端要求目前寵物資料
            self:CloseAllWindows()
            self:sendPacket("RequestPetCultivationData", tostring(windowType) .. "|" .. tostring(petSlot))
        end
    end)
    -- 接收後端回傳的遊戲數據，建構與更新前端UI介面
    self:onPacketRecv("ResponsePetCultivationData", function(header, params)
        if params then
            local str = params[1] or ""
            local arr = self:split(str, "|")
            self.petSlot = arr[1];
            self.PetName = arr[2];
            self.cultivationExp = arr[3];
            self.expNeed = arr[4];
            self.cultivationCount = arr[5];
            self.maxed = arr[6];

            local grade = self:split(arr[7], ",")
            self.grade_tbl["Art1_N"] = grade[1];
            self.grade_tbl["Art2_N"] = grade[3];
            self.grade_tbl["Art3_N"] = grade[5];
            self.grade_tbl["Art4_N"] = grade[7];
            self.grade_tbl["Art5_N"] = grade[9];
            self.grade_tbl["Art1_F"] = grade[2];
            self.grade_tbl["Art2_F"] = grade[4];
            self.grade_tbl["Art3_F"] = grade[6];
            self.grade_tbl["Art4_F"] = grade[8];
            self.grade_tbl["Art5_F"] = grade[10];

            -- 後端回傳目前分頁
            self.currentWnd = tonumber(arr[8]) or PAGE_FIRST
            self.grade_tbl = self.grade_tbl
            if self.currentWnd == PAGE_FIRST then
                if not self.C_wnd then
                    self:CreateWin1()
                    self:UpdateUI1()
                else
                    self:UpdateUI1()
                end
                if self.C_material_wnd then
                    if self.maxed == "1" then
                        self:Toggle_Clist_Wnd()
                    else
                        self:C_material_List_UpdateUI()
                    end
                end
            elseif self.currentWnd == PAGE_SECOND then
                if not self.B_wnd then
                    self:CreateWin2()
                    self:UpdateUI2()
                else
                    self:UpdateUI2()
                end
            end
        end
    end)
    -- 第三層材料選擇
    self.C_material_wnd = nil
    self.C_material_List = {}
    -- 接收後端回傳的遊戲數據，建構與更新前端UI介面
    self:onPacketRecv("ResponseMaterialPetData", function(header, params)
        if params then
            local str = params[1] or ""
            local arr = self:split(str, "|")
            local group = 1;
            for i = 1,5 do
                local mat = self:split(arr[i], ",")
                self.C_material_List[group] = mat[1];
                self.C_material_List[group+1] = mat[2];
                group =group+2;
            end
            self.C_material_List = self.C_material_List
            if not self.C_material_wnd and self.maxed == "0" then
                self:C_material_List_CreateWin()
                self:C_material_List_UpdateUI()
            else
                self:C_material_List_UpdateUI()
            end
        end
    end)

    -- 第三層碎片選擇
    self.B_material_wnd = nil
    self.break_tbl = {
        Art1_B = 0, Art2_B = 0, Art3_B = 0, Art4_B = 0, Art5_B = 0,
    }
    self.breakthroughCrystalChecks = {}
    self.breakthroughCrystalSelected = {}
	self.breakthroughCrystalHoverIndex = nil
    self.breakthroughCrystalSelectedCount = 0
    self.breakthroughCrystalCost = 0
    self.breakthroughCrystalRecipe = nil
end

function CultivationModule:onUnload()
    if self.C_wnd then
        self.C_wnd:Close()
        self:releaseWindow(self.C_wnd)
        self.C_wnd = nil
    end
    if self.C_material_wnd then
        self.C_material_wnd:Close()
        self:releaseWindow(self.C_material_wnd)
        self.C_material_wnd = nil
        self.seriesChecks = {}
        self.seriesDraft = {}
        self.seriesHoverIndex = nil
    end
    if self.B_wnd then
        self.B_wnd:Close()
        self:releaseWindow(self.B_wnd)
        self.B_wnd = nil
    end
    if self.B_material_wnd then
        self.B_material_wnd:Close()
        self:releaseWindow(self.B_material_wnd)
        self.B_material_wnd = nil
		self.breakthroughCrystalChecks = {}
		self.breakthroughCrystalSelected = {}
		self.breakthroughCrystalHoverIndex = nil
		self.breakthroughCrystalSelectedCount = 0
		self.breakthroughCrystalCost = 0
		self.breakthroughCrystalRecipe = nil
    end
end
--------------------------------------------------------------------------------
-- 2. UI 建立與控制
--------------------------------------------------------------------------------
-- 主寵物資訊(第二層)
function CultivationModule:CloseAllWindows()
    -- 關閉材料寵物窗口
    if self.C_material_wnd then
        if self.C_material_wnd.valid then
            self.C_material_wnd:Close()
            self:releaseWindow(self.C_material_wnd)
            self.C_material_wnd = nil
        end
    end
    -- 關閉水晶碎片窗口
    if self.B_material_wnd then
        if self.B_material_wnd.valid then
            self.B_material_wnd:Close()
            self:releaseWindow(self.B_material_wnd)
            self.B_material_wnd = nil
        end
    end
    -- 關閉培養窗口
    if self.C_wnd then
        if self.C_wnd.valid then
            self.C_wnd:Close()
            self:releaseWindow(self.C_wnd)
            self.C_wnd = nil
        end
    end
    -- 關閉突破窗口
    if self.B_wnd then
        if self.B_wnd.valid then
            self.B_wnd:Close()
            self:releaseWindow(self.B_wnd)
            self.B_wnd = nil
        end
    end
    -- 清除材料選擇狀態
    self.seriesChecks = {}
    self.seriesDraft = {}
    self.seriesHoverIndex = nil
    self.seriesSelectedCount = 0
    -- 清除碎片選擇狀態
	self.breakthroughCrystalChecks = {}
	self.breakthroughCrystalSelected = {}
	self.breakthroughCrystalHoverIndex = nil
	self.breakthroughCrystalSelectedCount = 0
	self.breakthroughCrystalCost = 0
	self.breakthroughCrystalRecipe = nil
end
-- 主寵物資訊(第二層-1)
function CultivationModule:ToggleWnd1()
    WinMgr.PlaySe(57, CONST.Screen.Width / 2)
    if self.C_wnd and self.C_wnd.valid then
        self.C_wnd:Close()
        self:releaseWindow(self.C_wnd)
        self.C_wnd = nil
    else
        self:CreateWin1()
    end
end
function CultivationModule:CreateWin1_Update()
	local pet_Status = self:findWindow(15)	--寵物栏15
	if pet_Status == nil then
		if self.C_wnd and self.C_wnd.valid then
			self.C_wnd:Close()
			self:releaseWindow(self.C_wnd)
			self.C_wnd = nil
		end
	end
end
function CultivationModule:CreateWin1()
    if self.C_wnd then return end

    local winW, winH = 200, 246
    local status, window = self:newWindow({
        id = C_WIN_ID,
        x = (CONST.Screen.Width - winW) / 2,
        y = (CONST.Screen.Height - winH) / 2,
        width = winW,
        height = winH,
        layer = 4,
        dragMove = 1,
        update = function() self:CreateWin1_Update() end,
    })

    if not window then return end
    self.C_wnd = self:ownWindow(window)

    -- 主介面背景
    --- 視窗底色
    -- window:AddPngImage({ x = 6, y = 12, width = winW-30, height = winH-20, image = BG_colorIMG, hitable = false })
    --- 視窗主題底圖
    -- window:AddPngImage({ x = 8, y = 26, width = winW-33, height = winH-35, image = BG_themeIMG, hitable = false })
    --- 視窗外框
    window:AddPngImage({ x = 0, y = 0, width = winW, height = winH, image = BG_frameIMG, hitable = false })
    -- 關閉按鈕
    window:AddPngImage({
        x = 159, y = 8, width = 12, height = 12,
        image = CLOSE_BTN, imageHover = CLOSE_HOVER, imagePress = CLOSE_PRESS,
        hitable = true,
        onClick = function()
            self:ToggleWnd1()
            return true
        end
    })

    -- 頂部文字資訊
    window:AddText({ x = 45, y = 10, width = 20, height = 20, font = 4, color = 75, text = "主寵物的訊息" })	--color:16灰白色33深紫色69朱紅色72深棕色
    self.petSlot_str = window:AddText({ x = 15, y = 35, width = 150, height = 24, font = 13, color = 119, text = "寵物欄  第 "..self.petSlot.." 格的"})
    self.PetName_str = window:AddText({ x = 15, y = 55, width = 150, height = 24, font = 13, color = 4, text = "〈"..self.PetName.."〉"})
    -- 目前檔次分布
    self.Art1_str = window:AddText({ x = 15, y = 80, width = 150, height = 24, font = 13, color = 48, text = "體力: "..self.grade_tbl["Art1_N"].." / "..self.grade_tbl["Art1_F"]})
    self.Art2_str = window:AddText({ x = 15, y = 100, width = 150, height = 24, font = 13, color = 48, text = "力量: "..self.grade_tbl["Art2_N"].." / "..self.grade_tbl["Art2_F"]})
    self.Art3_str = window:AddText({ x = 15, y = 120, width = 150, height = 24, font = 13, color = 48, text = "強度: "..self.grade_tbl["Art3_N"].." / "..self.grade_tbl["Art3_F"]})
    self.Art4_str = window:AddText({ x = 15, y = 140, width = 150, height = 24, font = 13, color = 48, text = "速度: "..self.grade_tbl["Art4_N"].." / "..self.grade_tbl["Art4_F"]})
    self.Art5_str = window:AddText({ x = 15, y = 160, width = 150, height = 24, font = 13, color = 48, text = "魔法: "..self.grade_tbl["Art5_N"].." / "..self.grade_tbl["Art5_F"]})

    -- 選擇材料按鈕
    self.selectlistBtn = window:AddPngImage({
        x = 105, y = 182, width = 64, height = 20,
        image = BTN_STATE, hitable = true,
        onClick = function() self.selectlistBtn:Set({image = BTN_PRESS , visible=true}) WinMgr.PlaySe(51,CONST.Screen.Width/2) self:OpenMaterialPetWindow(self.petSlot) end,
        onHover = function() self.selectlistBtn:Set({image = BTN_STATE , visible=true}) self.selectlistStr:Set({color = 0}) end,
        onLeave = function() self.selectlistBtn:Set({image = BTN_STATE , visible=true}) self.selectlistStr:Set({color = 128})end
    })
    self.selectlistStr = window:AddText({ x = 110, y = 185, width = 64, height = 20, font = 13, color = 128, text = "選擇材料"})

    -- 培養經驗進度條
    self.progress_str = window:AddText({ x = 15, y = 185, width = 150, height = 24, font = 13, color = 113, text = "目前培養進度"})
    self.progressBg = window:AddPngImage({ x = 15, y = 205, width = 150, height = 8, image = PROGRESS_BG_IMG, hitable = false})
    self.progressFill = window:AddPngImage({ x = 15, y = 205, width = 0, height = 8, image = PROGRESS_FILL_IMG, hitable = false})
    -- 能否繼續吸收培養
    if self.maxed == "1" then
        self.maxed_str = window:AddText({ x = 47, y = 215, width = 150, height = 24, font = 13, color = 50, text = "五項能力滿檔"})
    else
        self.maxed_str = window:AddText({ x = 71, y = 215, width = 150, height = 24, font = 13, color = 49, text = "已補檔次數: "..self.cultivationCount})
    end
end
-- 材料選擇框(第三層-1)
function CultivationModule:Toggle_Clist_Wnd()
    WinMgr.PlaySe(57, CONST.Screen.Width / 2)
    if self.C_material_wnd and self.C_material_wnd.valid then
        self.C_material_wnd:Close()
        self:releaseWindow(self.C_material_wnd)
    end
    self.C_material_wnd = nil
    -- 清除材料寵選擇狀態
    self.seriesChecks = {}
    self.seriesDraft = {}
    self.seriesHoverIndex = nil
    self.seriesSelectedCount = 0
end
function CultivationModule:C_material_List_CreateWin_Update()
	local pet_Status = self:findWindow(15)	--寵物栏15
	if pet_Status == nil then
		if self.C_material_wnd and self.C_material_wnd.valid then
			self.C_material_wnd:Close()
			self:releaseWindow(self.C_material_wnd)
			self.C_material_wnd = nil
		end
	end
end
function CultivationModule:C_material_List_CreateWin()
    if self.C_material_wnd then return end

    local winW, winH = 200, 246
    local status, window = self:newWindow({
        id = C_material_List_WIN_ID,
        x = 200 + (CONST.Screen.Width - winW) / 2,
        y = (CONST.Screen.Height - winH) / 2,
        width = winW,
        height = winH,
        layer = 4,
        dragMove = 1,
        update = function() self:C_material_List_CreateWin_Update() end,
    })

    if not window then return end
    self.C_material_wnd = self:ownWindow(window)

    --- 視窗外框
    window:AddPngImage({ x = 0, y = 0, width = winW, height = winH, image = BG_frameIMG, hitable = false })
    -- 關閉按鈕
    window:AddPngImage({
        x = 159, y = 8, width = 12, height = 12,
        image = CLOSE_BTN, imageHover = CLOSE_HOVER, imagePress = CLOSE_PRESS,
        hitable = true,
        onClick = function()
            self:Toggle_Clist_Wnd()
            return true
        end
    })

    -- 頂部文字資訊
    window:AddText({ x = 45, y = 10, width = 20, height = 20, font = 4, color = 75, text = "勾選被吸收寵" })
    window:AddText({ x = 15, y = 35, width = 150, height = 24, font = 13, color = 0, text = "培養經驗充滿時"})
    window:AddText({ x = 15, y = 55, width = 150, height = 24, font = 13, color = 0, text = "主寵物隨機掉檔+1"})
    -- 勾選材料
    self.seriesChecks = {}
    self.seriesDraft = {}
    self.seriesHoverIndex = nil
    self.seriesSelectedCount = 0

	local SERIES_ROW_X = 15
	local SERIES_ROW_Y = 77
	local SERIES_ROW_WIDTH = 155
	local SERIES_ROW_HEIGHT = 20

	local SERIES_CHECKBOX_X = SERIES_ROW_X + 5
	local SERIES_CHECKBOX_Y = 2

	local SERIES_NAME_X = SERIES_ROW_X + 21
	local SERIES_NAME_WIDTH = 72

	local SERIES_LEVEL_X = SERIES_ROW_X + 107
	local SERIES_LEVEL_WIDTH = 45

	for i = 1, 5 do
		local index = i
		local rowY = SERIES_ROW_Y + SERIES_ROW_HEIGHT * (index - 1)
		local nameIndex = index * 2 - 1;
		local petName = self.C_material_List[nameIndex] or ""
		local petLevel = self.C_material_List[nameIndex + 1] or "_"
		--------------------------------------------------
		-- 是否可以選擇
		--------------------------------------------------
		local selectable = true
		if petName == "主寵物" or petLevel == "_" then
			selectable = false
		end
		--------------------------------------------------
		-- Row 底圖
		--------------------------------------------------
		local row = window:AddPngImage({
			x = SERIES_ROW_X, y = rowY, width = SERIES_ROW_WIDTH, height = SERIES_ROW_HEIGHT,
			image = SERIES_ROW_NORMAL_IMAGE, color = -1, visible = true, hitable = false})
		--------------------------------------------------
		-- Checkbox 未勾選
		--------------------------------------------------
		local checkBox = window:AddPngImage({
			x = SERIES_CHECKBOX_X, y = rowY + SERIES_CHECKBOX_Y, width = 17, height = 16,
			image = CHECKBOX_uncheckedIMG, color = -1, visible = selectable, hitable = false})
		--------------------------------------------------
		-- Checkbox 已勾選
		--------------------------------------------------
		local checkMark = window:AddPngImage({
			x = SERIES_CHECKBOX_X, y = rowY + SERIES_CHECKBOX_Y, width = 17, height = 16,
			image = CHECKBOX_checkedIMG, color = -1, visible = false, hitable = false})
		--------------------------------------------------
		-- 整列透明點擊區
		--------------------------------------------------
		local hit = window:AddPngImage({
			x = SERIES_ROW_X, y = rowY, width = SERIES_ROW_WIDTH, height = SERIES_ROW_HEIGHT,
			image = TRANSPARENT_IMAGE, color = -1, visible = selectable, hitable = true,
			onClick = function()
				WinMgr.PlaySe(52,CONST.Screen.Width/2)
				self:toggleSeriesCheck(index) return true end,
			onHover = function() 
				self.seriesHoverIndex = index self:refreshSeriesChecks() return true end,
			onLeave = function() 
				if self.seriesHoverIndex == index then self.seriesHoverIndex = nil end
				self:refreshSeriesChecks()
				return true end})
		--------------------------------------------------
		-- 寵物名稱
		--------------------------------------------------
		local textColor = 48;
		if petName == "主寵物" then
			textColor = 4;
		elseif petLevel == "_" then
			textColor = 16;
		end

		local name_Str = window:AddText({
			x = SERIES_NAME_X, y = rowY + 3, width = SERIES_NAME_WIDTH, height = 20,
			text = petName, font = 13, color = textColor, hitable = false})
		--------------------------------------------------
		-- 等級
		--------------------------------------------------
		local level_Str = window:AddText({
			x = SERIES_LEVEL_X, y = rowY + 3, width = SERIES_LEVEL_WIDTH, height = 20,
			text = "Lv "..tostring(petLevel), font = 13, color = textColor, hitable = false})
		--------------------------------------------------
		-- 保存控制項
		--------------------------------------------------
		self.seriesChecks[index] = {row = row, box = checkBox, mark = checkMark, hit = hit, name = name_Str, level = level_Str}
	end

	-- local ROW_X = 15
	-- local ROW_Y = 65
	-- local ROW_H = 20

	-- local CHECK_X = ROW_X + 6
	-- local CHECK_Y_OFFSET = 2

	-- local TEXT_X = ROW_X + 30
	-- local NAME_WIDTH = 70

	-- local LEVEL_X = ROW_X + 105
	-- local LEVEL_WIDTH = 45

	-- for i = 1, 5 do
		-- local index = i
		-- local y = ROW_Y + ROW_H * (i - 1)
		-- local nameIndex = index * 2 - 1
		-- local petName = self.C_material_List[nameIndex] or ""
		-- local selectable = true
		-- if petName == "主寵物" or petName == "不符合" or petName == "空" then
			-- selectable = false
		-- end
		-- -- Checkbox 底圖
		-- local checkBox = window:AddPngImage({x = CHECK_X, y = y + CHECK_Y_OFFSET, width = 17, height = 16,
			-- image = CHECKBOX_uncheckedIMG, color = -1, visible = selectable, hitable = false})
		-- -- Checkbox 勾勾
		-- local checkMark = window:AddPngImage({x = CHECK_X, y = y + CHECK_Y_OFFSET,width = 17, height = 16,
			-- image = CHECKBOX_checkedIMG, color = -1, visible = false,	hitable = false})
		-- -- 整列點擊區
		-- local hit = window:AddPngImage({x = ROW_X, y = y, width = 155, height = ROW_H,
			-- image = TRANSPARENT_IMAGE, color = -1, visible = selectable, hitable = true,
			-- onClick = function() self:toggleSeriesCheck(index) return true end,
			-- onHover = function() self.seriesHoverIndex = index return true end,
			-- onLeave = function() if self.seriesHoverIndex == index then self.seriesHoverIndex = nil	end return true end})

		-- -- 寵物名稱
		-- local textColor = 48;
		-- if petName == "主寵物" then
			-- textColor = 4;
		-- elseif petName == "不符合" or petName == "空" then
			-- textColor = 16;
		-- end
		-- local name_Str = window:AddText({x = TEXT_X, y = y + 3,	width = NAME_WIDTH, height = 20,
			-- text = petName,	font = 13, color = textColor, hitable = false})
		-- -- 等級
		-- local level_Str = window:AddText({x = LEVEL_X, y = y + 3, width = LEVEL_WIDTH, height = 20,
			-- text = "Lv "..tostring(self.C_material_List[nameIndex + 1] or "_"), font = 13, color = textColor, hitable = false})
		-- self.seriesChecks[index] = {box = checkBox,	mark = checkMark,hit = hit, name = name_Str, level = level_Str}
	-- end
	-- self:refreshSeriesChecks()

    -- 培養經驗
    self.exp_str = window:AddText({ x = 15, y = 185, width = 150, height = 24, font = 13, color = 113, text = "培養經驗+0"})
    -- 確定吸收培養按鈕
    self.cultivationBtn = window:AddPngImage({
        x = 60, y = 202, width = 64, height = 20,
        image = BTN_STATE, hitable = true,
        onClick = function() self.cultivationBtn:Set({image = BTN_PRESS , visible=true}) WinMgr.PlaySe(53,CONST.Screen.Width/2) self:OnCultivationBtnClick() return true end,
        onHover = function() self.cultivationBtn:Set({image = BTN_STATE , visible=true}) self.cultivationStr:Set({color = 0}) end,
        onLeave = function() self.cultivationBtn:Set({image = BTN_STATE , visible=true}) self.cultivationStr:Set({color = 128})end
    })
    self.cultivationStr = window:AddText({ x = 65, y = 205, width = 64, height = 20, font = 13, color = 128, text = "確定吸收"})

end
------------------------------------------------------
-- 主寵物資訊(第二層-2)
function CultivationModule:ToggleWnd2()
    WinMgr.PlaySe(57, CONST.Screen.Width / 2)
    if self.B_wnd and self.B_wnd.valid then
        self.B_wnd:Close()
        self:releaseWindow(self.B_wnd)
        self.B_wnd = nil
    else
        self:CreateWin2()
    end
end
function CultivationModule:CreateWin2_Update()
	local pet_Status = self:findWindow(15)	--寵物栏15
	if pet_Status == nil then
		if self.B_wnd and self.B_wnd.valid then
			self.B_wnd:Close()
			self:releaseWindow(self.B_wnd)
			self.B_wnd = nil
		end
	end
end
function CultivationModule:CreateWin2()
    if self.B_wnd then return end

    local winW, winH = 200, 246
    local status, window = self:newWindow({
        id = B_WIN_ID,
        x = (CONST.Screen.Width - winW) / 2,
        y = (CONST.Screen.Height - winH) / 2,
        width = winW,
        height = winH,
        layer = 4,
        dragMove = 1,
        update = function() self:CreateWin2_Update() end,
    })

    if not window then return end
    self.B_wnd = self:ownWindow(window)

    -- 主介面背景
    --- 視窗底色
    -- window:AddPngImage({ x = 6, y = 12, width = winW-30, height = winH-20, image = BG_colorIMG, hitable = false })
    --- 視窗主題底圖
    -- window:AddPngImage({ x = 8, y = 26, width = winW-33, height = winH-35, image = BG_themeIMG, hitable = false })
    --- 視窗外框
    window:AddPngImage({ x = 0, y = 0, width = winW, height = winH, image = BG_frameIMG, hitable = false })
    -- 關閉按鈕
    window:AddPngImage({
        x = 159, y = 8, width = 12, height = 12,
        image = CLOSE_BTN, imageHover = CLOSE_HOVER, imagePress = CLOSE_PRESS,
        hitable = true,
        onClick = function()
            self:ToggleWnd2()
            return true
        end
    })

    -- 頂部文字資訊
    window:AddText({ x = 45, y = 10, width = 20, height = 20, font = 4, color = 75, text = "主寵物的訊息" })	--color:16灰白色33深紫色69朱紅色72深棕色
    self.petSlot_str = window:AddText({ x = 15, y = 35, width = 150, height = 24, font = 13, color = 119, text = "寵物欄  第 "..self.petSlot.." 格的"})
    self.PetName_str = window:AddText({ x = 15, y = 55, width = 150, height = 24, font = 13, color = 4, text = "〈"..self.PetName.."〉"})
    -- 目前檔次分布
    self.Art1_str = window:AddText({ x = 15, y = 80, width = 150, height = 24, font = 13, color = 0, text = "體力: "..self.grade_tbl["Art1_F"]})
    self.Art2_str = window:AddText({ x = 15, y = 100, width = 150, height = 24, font = 13, color = 0, text = "力量: "..self.grade_tbl["Art2_F"]})
    self.Art3_str = window:AddText({ x = 15, y = 120, width = 150, height = 24, font = 13, color = 0, text = "強度: "..self.grade_tbl["Art3_F"]})
    self.Art4_str = window:AddText({ x = 15, y = 140, width = 150, height = 24, font = 13, color = 0, text = "速度: "..self.grade_tbl["Art4_F"]})
    self.Art5_str = window:AddText({ x = 15, y = 160, width = 150, height = 24, font = 13, color = 0, text = "魔法: "..self.grade_tbl["Art5_F"]})

    self.Art1P_str = window:AddText({ x = 70, y = 80, width = 150, height = 24, font = 13, color = 48, text = " ＋ "..self.grade_tbl["Art1_N"]-self.grade_tbl["Art1_F"]})
    self.Art2P_str = window:AddText({ x = 70, y = 100, width = 150, height = 24, font = 13, color = 48, text = " ＋ "..self.grade_tbl["Art2_N"]-self.grade_tbl["Art2_F"]})
    self.Art3P_str = window:AddText({ x = 70, y = 120, width = 150, height = 24, font = 13, color = 48, text = " ＋ "..self.grade_tbl["Art3_N"]-self.grade_tbl["Art3_F"]})
    self.Art4P_str = window:AddText({ x = 70, y = 140, width = 150, height = 24, font = 13, color = 48, text = " ＋ "..self.grade_tbl["Art4_N"]-self.grade_tbl["Art4_F"]})
    self.Art5P_str = window:AddText({ x = 70, y = 160, width = 150, height = 24, font = 13, color = 48, text = " ＋ "..self.grade_tbl["Art5_N"]-self.grade_tbl["Art5_F"]})

    self.break_tbl = {
        Art1_B = 0, Art2_B = 0, Art3_B = 0, Art4_B = 0, Art5_B = 0,
    }
    self.Art1B_str = window:AddText({ x = 125, y = 80, width = 150, height = 24, font = 13, color = 5, text = " ＋ "..self.break_tbl["Art1_B"]})
    self.Art2B_str = window:AddText({ x = 125, y = 100, width = 150, height = 24, font = 13, color = 5, text = " ＋ "..self.break_tbl["Art2_B"]})
    self.Art3B_str = window:AddText({ x = 125, y = 120, width = 150, height = 24, font = 13, color = 5, text = " ＋ "..self.break_tbl["Art3_B"]})
    self.Art4B_str = window:AddText({ x = 125, y = 140, width = 150, height = 24, font = 13, color = 5, text = " ＋ "..self.break_tbl["Art4_B"]})
    self.Art5B_str = window:AddText({ x = 125, y = 160, width = 150, height = 24, font = 13, color = 5, text = " ＋ "..self.break_tbl["Art5_B"]})

    -- 選擇碎片按鈕
    self.selectlistBtn = window:AddPngImage({
        x = 105, y = 182, width = 64, height = 20,
        image = BTN_STATE, hitable = true,
        onClick = function() self.selectlistBtn:Set({image = BTN_PRESS , visible=true}) WinMgr.PlaySe(51,CONST.Screen.Width/2) self:OpenMaterialItemWindow(self.petSlot) end,
        onHover = function() self.selectlistBtn:Set({image = BTN_STATE , visible=true}) self.selectlistStr:Set({color = 0}) end,
        onLeave = function() self.selectlistBtn:Set({image = BTN_STATE , visible=true}) self.selectlistStr:Set({color = 128})end
    })
    self.selectlistStr = window:AddText({ x = 110, y = 185, width = 64, height = 20, font = 13, color = 128, text = "選擇碎片"})

    -- 檔次進度
    self.BPstate_N = self.grade_tbl["Art1_N"]+self.grade_tbl["Art2_N"]+self.grade_tbl["Art3_N"]+self.grade_tbl["Art4_N"]+self.grade_tbl["Art5_N"]
    self.BPstate_F = self.grade_tbl["Art1_F"]+self.grade_tbl["Art2_F"]+self.grade_tbl["Art3_F"]+self.grade_tbl["Art4_F"]+self.grade_tbl["Art5_F"]
    self.BPstate_str = window:AddText({ x = 15, y = 185, width = 150, height = 24, font = 13, color = 113, text = "檔次 "..self.BPstate_N.."/"..self.BPstate_F})

    -- 碎片提示
    local totalRank = self:GetBreakthroughTotalRank()
    local cost = self:GetBreakthroughCrystalCost(totalRank) or 0
    self.shards_str = window:AddText({ x = 33, y = 210, width = 150, height = 24, font = 13, color = 47, text = "每種所需碎片數"..tostring(cost)})
end
-- 碎片選擇框(第三層-2)
function CultivationModule:Toggle_Blist_Wnd()
    WinMgr.PlaySe(57, CONST.Screen.Width / 2)
    if self.B_material_wnd and self.B_material_wnd.valid then
        self.B_material_wnd:Close()
        self:releaseWindow(self.B_material_wnd)
    end
    self.B_material_wnd = nil
    -- 清除碎片選擇狀態
	self.breakthroughCrystalChecks = {}
	self.breakthroughCrystalSelected = {}
	self.breakthroughCrystalHoverIndex = nil
	self.breakthroughCrystalSelectedCount = 0
	self.breakthroughCrystalCost = 0
	self.breakthroughCrystalRecipe = nil
end
function CultivationModule:B_material_List_CreateWin_Update()
	local pet_Status = self:findWindow(15)	--寵物栏15
	if pet_Status == nil then
		if self.B_material_wnd and self.B_material_wnd.valid then
			self.B_material_wnd:Close()
			self:releaseWindow(self.B_material_wnd)
			self.B_material_wnd = nil
		end
	end
end
function CultivationModule:B_material_List_CreateWin()
    if self.B_material_wnd then return end

    local winW, winH = 200, 246
    local status, window = self:newWindow({
        id = B_material_List_WIN_ID,
        x = 200 + (CONST.Screen.Width - winW) / 2,
        y = (CONST.Screen.Height - winH) / 2,
        width = winW,
        height = winH,
        layer = 4,
        dragMove = 1,
        update = function() self:B_material_List_CreateWin_Update() end,
    })

    if not window then return end
    self.B_material_wnd = self:ownWindow(window)

    --- 視窗外框
    window:AddPngImage({ x = 0, y = 0, width = winW, height = winH, image = BG_frameIMG, hitable = false })
    -- 關閉按鈕
    window:AddPngImage({
        x = 159, y = 8, width = 12, height = 12,
        image = CLOSE_BTN, imageHover = CLOSE_HOVER, imagePress = CLOSE_PRESS,
        hitable = true,
        onClick = function()
            self:Toggle_Blist_Wnd()
            return true
        end
    })

    -- 頂部文字資訊
    window:AddText({ x = 45, y = 10, width = 20, height = 20, font = 4, color = 75, text = "勾選碎片組合" })
    self.breakthroughPreviewTitle = window:AddText({ x = 15, y = 35, width = 150, height = 24, font = 13, color = 0, text = "請選擇2～3種水晶"})
    self.breakthroughPreviewStr = window:AddText({ x = 15, y = 55, width = 170, height = 20, font = 13, color = 113, text = "至少選擇2種水晶"})

    -- 勾選材料
	self.breakthroughCrystalChecks = {}
	self.breakthroughCrystalSelected = {}
	self.breakthroughCrystalHoverIndex = nil
	self.breakthroughCrystalSelectedCount = 0
	self.breakthroughCrystalCost = 0
	self.breakthroughCrystalRecipe = nil

    local ROW_X = 15
    local ROW_Y = 77
    local ROW_WIDTH = 155
    local ROW_HEIGHT = 20

    for i = 1, 4 do
        local index = i
        local crystal = BREAKTHROUGH_CRYSTALS[index]
        local rowY = ROW_Y + ROW_HEIGHT * (index - 1)
        -- 背景
        local row = window:AddPngImage({x = ROW_X, y = rowY, width = ROW_WIDTH, height = ROW_HEIGHT,
            image = SERIES_ROW_NORMAL_IMAGE, visible = true, hitable = false})
        -- 未勾選
        local check = window:AddPngImage({x = ROW_X + 5, y = rowY + 2, width = 17, height = 16,
            image = CHECKBOX_uncheckedIMG, visible = true, hitable = false})
        -- 已勾選
        local checkMark  = window:AddPngImage({x = ROW_X + 5, y = rowY + 2, width = 17, height = 16,
            image = CHECKBOX_checkedIMG, visible = false, hitable = false})
        -- 點擊區
        local hit = window:AddPngImage({x = ROW_X, y = rowY, width = ROW_WIDTH, height = ROW_HEIGHT,
            image = TRANSPARENT_IMAGE, visible = true, hitable = true,
            onClick = function()
				WinMgr.PlaySe(52, CONST.Screen.Width / 2)
				self:ToggleBreakthroughCrystal(index) return true end,
            onHover = function()
				self.breakthroughCrystalHoverIndex = index self:RefreshBreakthroughCrystalUI() return true end,
            onLeave = function()
				if self.breakthroughCrystalHoverIndex == index then self.breakthroughCrystalHoverIndex = nil end
				self:RefreshBreakthroughCrystalUI() return true end})
        -- 碎片名稱
        local name = window:AddText({x = ROW_X + 27, y = rowY + 3, width = 72, height = ROW_HEIGHT,
            font = 13, color = 48, text = crystal.name, hitable = false})
        self.breakthroughCrystalChecks[index] = {row = row, box = check, mark = checkMark , name = name, hit = hit,}
    end
    -- -- 培養經驗
    -- self.exp_str = window:AddText({ x = 15, y = 185, width = 150, height = 24, font = 13, color = 113, text = "培養經驗+0"})
    -- 確定突破按鈕
    self.breakthroughBtn = window:AddPngImage({
        x = 60, y = 202, width = 64, height = 20,
        image = BTN_STATE, hitable = true,
        onClick = function() self.breakthroughBtn:Set({image = BTN_PRESS , visible=true}) WinMgr.PlaySe(53,CONST.Screen.Width/2) self:OnBreakthroughBtnClick() return true end,
        onHover = function() self.breakthroughBtn:Set({image = BTN_STATE , visible=true}) self.breakthroughStr:Set({color = 0}) end,
        onLeave = function() self.breakthroughBtn:Set({image = BTN_STATE , visible=true}) self.breakthroughStr:Set({color = 128})end
    })
    self.breakthroughStr = window:AddText({ x = 65, y = 205, width = 64, height = 20, font = 13, color = 128, text = "確定突破"})

end

--------------------------------------------------------------------------------
-- 3. 介面刷新
--------------------------------------------------------------------------------
-- 主寵物資訊刷新(第二層-1)
function CultivationModule:UpdateUI1()
    if not self.C_wnd then return end

    self.petSlot_str:Set({ color = 119, text = "寵物欄  第 "..self.petSlot.." 格的"})
    self.PetName_str:Set({ color = 4, text = "〈"..self.PetName.."〉"})

    if (self.grade_tbl["Art1_N"]==self.grade_tbl["Art1_F"]) then
      self.Art1_str:Set({ color = 48, text = "體力: "..self.grade_tbl["Art1_N"].." / "..self.grade_tbl["Art1_F"]})
    else
      self.Art1_str:Set({ color = 112, text = "體力: "..self.grade_tbl["Art1_N"].." / "..self.grade_tbl["Art1_F"]})
    end
    if (self.grade_tbl["Art2_N"]==self.grade_tbl["Art2_F"]) then
      self.Art2_str:Set({ color = 48, text = "力量: "..self.grade_tbl["Art2_N"].." / "..self.grade_tbl["Art2_F"]})
    else
      self.Art2_str:Set({ color = 112, text = "力量: "..self.grade_tbl["Art2_N"].." / "..self.grade_tbl["Art2_F"]})
    end
    if (self.grade_tbl["Art3_N"]==self.grade_tbl["Art3_F"]) then
      self.Art3_str:Set({ color = 48, text = "強度: "..self.grade_tbl["Art3_N"].." / "..self.grade_tbl["Art3_F"]})
    else
      self.Art3_str:Set({ color = 112, text = "強度: "..self.grade_tbl["Art3_N"].." / "..self.grade_tbl["Art3_F"]})
    end
    if (self.grade_tbl["Art4_N"]==self.grade_tbl["Art4_F"]) then
      self.Art4_str:Set({ color = 48, text = "速度: "..self.grade_tbl["Art4_N"].." / "..self.grade_tbl["Art4_F"]})
    else
      self.Art4_str:Set({ color = 112, text = "速度: "..self.grade_tbl["Art4_N"].." / "..self.grade_tbl["Art4_F"]})
    end
    if (self.grade_tbl["Art5_N"]==self.grade_tbl["Art5_F"]) then
      self.Art5_str:Set({ color = 48, text = "魔法: "..self.grade_tbl["Art5_N"].." / "..self.grade_tbl["Art5_F"]})
    else
      self.Art5_str:Set({ color = 112, text = "魔法: "..self.grade_tbl["Art5_N"].." / "..self.grade_tbl["Art5_F"]})
    end

    local expNeed = self.expNeed
    local currentExp = self.cultivationExp or 0
    if currentExp > expNeed then currentExp = expNeed end
    local fillWidth = 150 * currentExp / expNeed
    if fillWidth < 0 then fillWidth = 0 elseif fillWidth > 150 then fillWidth = 150 end
    if self.progressFill and self.progressFill.Set then
        self.progressFill:Set({ width = fillWidth })
    end

    if self.maxed == "1" then
        self.selectlistBtn:Set({visible=false})
        self.selectlistStr:Set({visible=false})
        self.maxed_str:Set({ x = 47, color = 50, text = "五項能力滿檔"})
    else
        self.selectlistBtn:Set({visible=true})
        self.selectlistStr:Set({visible=true})
        self.maxed_str:Set({x = 71, color = 49, text = "已補檔次數: "..self.cultivationCount})
    end

    if self.C_material_wnd then
        WinMgr.SendPacket("GetMaterialPet", self.petSlot)
    end
end
-- 材料選擇框刷新(第三層-1)
function CultivationModule:C_material_List_UpdateUI()
    if not self.C_material_wnd then return end

    local group = 1;
    for i = 1,5 do
        local petName = self.C_material_List[group] or ""
        local petLevel = self.C_material_List[group + 1] or "_"
        local textcolor = 48;
        if petName == "主寵物" then
            textcolor = 4;
        elseif petLevel == "_" then
            textcolor = 16;
        end
        if self.seriesChecks[i] then
            self.seriesChecks[i].name:Set({text = petName,color = textcolor})
            self.seriesChecks[i].level:Set({text = "Lv "..petLevel,color = textcolor})
        end
        group = group + 2;
    end
    self:refreshSeriesChecks()
end
-- 更新材料寵勾選狀態
function CultivationModule:toggleSeriesCheck(index)
    local nameIndex = index * 2 - 1;
    local petName = self.C_material_List[nameIndex]
    --------------------------------------------------
    -- 主寵 / 空槽 / 不可用欄位禁止選擇
    --------------------------------------------------
    if not petName or petName == "" or petName == "主寵物" or petName == "不符合" or petName == "空" then
        return true
    end
    --------------------------------------------------
    -- 切換選取狀態
    --------------------------------------------------
    if self.seriesDraft[index] == true then	-- 以寵物 Slot 作為唯一 Key
        self.seriesDraft[index] = nil
    else
        self.seriesDraft[index] = true
    end
    self:refreshSeriesChecks()
    return true
end
-- 更新材料寵勾選狀態UI
function CultivationModule:refreshSeriesChecks()
    local selectedCount = 0;
    local totalExp = 0
    for i = 1, 5 do
        local controls = self.seriesChecks and self.seriesChecks[i]
        if controls then
            local nameIndex = i * 2 - 1;
            local levelIndex = i * 2;
            local petName = self.C_material_List[nameIndex] or "";
            local petLevel = self.C_material_List[levelIndex] or "_";
            local selectable = true
            --------------------------------------------------
            -- 判斷是否可以選擇
            --------------------------------------------------
            if petLevel == "_" then	-- 空槽
                selectable = false
            elseif petName == "主寵物" then	-- 主寵
                selectable = false
            end
            --------------------------------------------------
            -- 取得選取狀態
            --------------------------------------------------
            local selected = false
            if selectable and self.seriesDraft[i] == true then
                selected = true
                selectedCount = selectedCount + 1;
				local level = tonumber(petLevel) or 0;
				totalExp = totalExp + self:GetMaterialPetCultivationExp(level)	-- 每隻被選取材料寵分別計算
            else
                self.seriesDraft[i] = nil	-- 清掉舊的選取狀態
            end
            -- Row 底圖
            if controls.row and controls.row.valid then
                local rowImage = SERIES_ROW_NORMAL_IMAGE
                if selected then
                    rowImage = SERIES_ROW_SELECTED_IMAGE
                elseif self.seriesHoverIndex == i then
                    rowImage = SERIES_ROW_HOVER_IMAGE
                end
                controls.row:Set({image = rowImage, visible = true})
            end
            -- Checkbox
            if controls.box and controls.box.valid then
                controls.box:Set({visible = selectable})
            end
            --  Checkbox 勾勾
            if controls.mark and controls.mark.valid then
                controls.mark:Set({visible = selected})
            end
            -- 點擊區
            if controls.hit and controls.hit.valid then
                controls.hit:Set({visible = selectable})
            end
            -- 文字顏色
            local textColor = 48;
            if petName == "主寵物" then
                textColor = 4;
            elseif petLevel == "_" then
                textColor = 16;
            end
            -- 寵物名稱
            if controls.name and controls.name.valid then
                controls.name:Set({text = petName,color = textColor})
            end
            -- 等級
            if controls.level and controls.level.valid then
                controls.level:Set({text = "Lv "..tostring(petLevel),color = textColor})
            end
        end
    end
	self.seriesSelectedCount = totalExp;
    self.exp_str:Set({text = "培養經驗+"..self.seriesSelectedCount})
end
-------------------------------------------------------------------
-------------------------------------------------------------------
-- 主寵物資訊刷新(第二層-2)
function CultivationModule:UpdateUI2()
    self.petSlot_str:Set({ color = 119, text = "寵物欄  第 "..self.petSlot.." 格的"})
    self.PetName_str:Set({ color = 4, text = "〈"..self.PetName.."〉"})

    if (self.grade_tbl["Art1_N"]>=self.grade_tbl["Art1_F"]) then
      self.Art1P_str:Set({ color = 48, text = " ＋ "..self.grade_tbl["Art1_N"]-self.grade_tbl["Art1_F"]})
    else
      self.Art1P_str:Set({ color = 112, text = " － "..self.grade_tbl["Art1_F"]-self.grade_tbl["Art1_N"]})
    end
    if (self.grade_tbl["Art2_N"]>=self.grade_tbl["Art2_F"]) then
      self.Art2P_str:Set({ color = 48, text = " ＋ "..self.grade_tbl["Art2_N"]-self.grade_tbl["Art2_F"]})
    else
      self.Art2P_str:Set({ color = 112, text = " － "..self.grade_tbl["Art2_F"]-self.grade_tbl["Art2_N"]})
    end
    if (self.grade_tbl["Art3_N"]>=self.grade_tbl["Art3_F"]) then
      self.Art3P_str:Set({ color = 48, text = " ＋ "..self.grade_tbl["Art3_N"]-self.grade_tbl["Art3_F"]})
    else
      self.Art3P_str:Set({ color = 112, text = " － "..self.grade_tbl["Art3_F"]-self.grade_tbl["Art3_N"]})
    end
    if (self.grade_tbl["Art4_N"]>=self.grade_tbl["Art4_F"]) then
      self.Art4P_str:Set({ color = 48, text = " ＋ "..self.grade_tbl["Art4_N"]-self.grade_tbl["Art4_F"]})
    else
      self.Art4P_str:Set({ color = 112, text = " － "..self.grade_tbl["Art4_F"]-self.grade_tbl["Art4_N"]})
    end
    if (self.grade_tbl["Art5_N"]>=self.grade_tbl["Art5_F"]) then
      self.Art5P_str:Set({ color = 48, text = " ＋ "..self.grade_tbl["Art5_N"]-self.grade_tbl["Art5_F"]})
    else
      self.Art5P_str:Set({ color = 112, text = " － "..self.grade_tbl["Art5_F"]-self.grade_tbl["Art5_N"]})
    end

    self.Art1B_str:Set({ color = 5, text = " ＋ "..self.break_tbl["Art1_B"]})
    self.Art2B_str:Set({ color = 5, text = " ＋ "..self.break_tbl["Art2_B"]})
    self.Art3B_str:Set({ color = 5, text = " ＋ "..self.break_tbl["Art3_B"]})
    self.Art4B_str:Set({ color = 5, text = " ＋ "..self.break_tbl["Art4_B"]})
    self.Art5B_str:Set({ color = 5, text = " ＋ "..self.break_tbl["Art5_B"]})

    -- 檔次進度
    self.BPstate_N = self.grade_tbl["Art1_N"]+self.grade_tbl["Art2_N"]+self.grade_tbl["Art3_N"]+self.grade_tbl["Art4_N"]+self.grade_tbl["Art5_N"]
    self.BPstate_F = self.grade_tbl["Art1_F"]+self.grade_tbl["Art2_F"]+self.grade_tbl["Art3_F"]+self.grade_tbl["Art4_F"]+self.grade_tbl["Art5_F"]
    self.BPstate_str:Set({ color = 113, text = "檔次 "..self.BPstate_N.."/"..self.BPstate_F})

    local totalRank = self:GetBreakthroughTotalRank()
    local cost = self:GetBreakthroughCrystalCost(totalRank) or 0
    -- 寵物必須五圍全滿
    if not self:IsBreakthroughFull() then
        self.selectlistBtn:Set({visible=false})
        self.selectlistStr:Set({visible=false})
        self.shards_str:Set({visible=true, color = 6, text = "五項能力滿檔開啟"})
    else
        self.selectlistBtn:Set({visible=true})
        self.selectlistStr:Set({visible=true})
        self.shards_str:Set({visible=true, color = 47, text = "每種所需碎片數"..tostring(cost)})
    end
end
-- 更新碎片勾選狀態
function CultivationModule:ToggleBreakthroughCrystal(index)
    if index < 1 or index > 4 then
        return true
    end
    local selected = self.breakthroughCrystalSelected[index] == true
    -- ==========================================
    -- 已選 → 取消
    -- ==========================================
    if selected then
        self.breakthroughCrystalSelected[index] = nil
    -- ==========================================
    -- 未選 → 嘗試加入
    -- ==========================================
    else
        -- 最多只能3種
        if self.breakthroughCrystalSelectedCount >= 3 then
            return true
        end
        self.breakthroughCrystalSelected[index] = true
    end
    self:RefreshBreakthroughCrystalUI()
    return true
end
-- 更新碎片勾選狀態UI
function CultivationModule:RefreshBreakthroughCrystalUI()
    local selected = {}
    for i = 1, 4 do
        if self.breakthroughCrystalSelected[i] == true then
            table.insert(selected, i)
        end
    end
    local selectedCount = #selected
    self.breakthroughCrystalSelectedCount = selectedCount
    -- ==========================================
    -- 更新水晶勾選狀態
    -- ==========================================
    for i = 1, 4 do
        local controls = self.breakthroughCrystalChecks[i]
        if controls then
            local isSelected = self.breakthroughCrystalSelected[i] == true
            if controls.mark and controls.mark.valid then
                controls.mark:Set({visible = isSelected})
            end
            if controls.box and controls.box.valid then
                controls.box:Set({visible = not isSelected})
            end
            -- Row 底圖
            if controls.row and controls.row.valid then
                local rowImage = SERIES_ROW_NORMAL_IMAGE
                if isSelected then
                    rowImage = SERIES_ROW_SELECTED_IMAGE
                elseif self.breakthroughCrystalHoverIndex == i then
                    rowImage = SERIES_ROW_HOVER_IMAGE
                end
                controls.row:Set({image = rowImage,visible = true})
            end
        end
    end
    -- ==========================================
    -- 少於2種
    -- ==========================================
    if selectedCount < 2 then
        self.breakthroughCrystalRecipe = nil
        self.breakthroughPreviewTitle:Set({color = 0,text = "請選擇2～3種水晶"})
        self.breakthroughPreviewStr:Set({color = 113,text = "至少選擇2種水晶"})
        self.breakthroughBtn:Set({image = BTN_STATE,visible = true})
        self.breakthroughStr:Set({color = 128})
        self.break_tbl = {
            Art1_B = 0, Art2_B = 0, Art3_B = 0, Art4_B = 0, Art5_B = 0,
        }
        if self.B_wnd then
            self:UpdateUI2()
        end
        return
    end
    -- ==========================================
    -- 組合 Key
    -- ==========================================
    local key = table.concat(selected, ",")
    local recipe = BREAKTHROUGH_RECIPES[key]
    if not recipe then
        self.breakthroughCrystalRecipe = nil
        self.breakthroughPreviewTitle:Set({color = 0,text = "請選擇2～3種水晶"})
        self.breakthroughPreviewStr:Set({color = 16,text = "非法組合請重新選擇"})
        return
    end
    self.breakthroughCrystalRecipe = recipe
    -- ==========================================
    -- 組合名稱
    -- ==========================================
    -- local crystalNames = {}
    -- for i = 1, #selected do
        -- local crystalIndex = selected[i]
        -- table.insert(crystalNames,BREAKTHROUGH_CRYSTALS[crystalIndex].name)
    -- end
    -- ==========================================
    -- 能力名稱
    -- ==========================================
    -- local statNames = {}
    self.break_tbl = {
        Art1_B = 0, Art2_B = 0, Art3_B = 0, Art4_B = 0, Art5_B = 0,
    }
    for i = 1, #recipe do
        local statIndex = recipe[i]
        self.break_tbl["Art" .. statIndex .. "_B"] = 1;
        -- table.insert(statNames,BREAKTHROUGH_STAT_NAMES[statIndex] .. " +1")
    end
    if self.B_wnd then
        self:UpdateUI2()
    end
    -- ==========================================
    -- 顯示預覽
    -- ==========================================
    -- local crystalText = table.concat(crystalNames, " + ")
    -- local statText = table.concat(statNames, "、")
    -- self.breakthroughPreviewTitle:Set({color = 48,text = "預覽：" .. crystalText})
    -- self.breakthroughPreviewStr:Set({color = 48,text = "→ " .. statText})
    -- ==========================================
    -- 更新每種水晶的需求數量
    -- ==========================================
    -- local cost = self.breakthroughCrystalCost
    -- for i = 1, 4 do
        -- local controls = self.breakthroughCrystalChecks[i]
        -- if controls and controls.id and controls.id.valid then
            -- local crystal = BREAKTHROUGH_CRYSTALS[i]
            -- if self.breakthroughCrystalSelected[i] == true then
                -- controls.id:Set({color = 48,text = tostring(crystal.id).."   " .. tostring(cost)})
            -- else
                -- controls.id:Set({color = 113,text = tostring(crystal.id)})
            -- end
        -- end
    -- end
end

--------------------------------------------------------------------------------
-- 4. 回調功能函數
--------------------------------------------------------------------------------
-- 點擊按鈕要求吸收名單
function CultivationModule:OpenMaterialPetWindow(mainPetSlot)
    WinMgr.SendPacket("GetMaterialPet", mainPetSlot)
end
-- 點擊按鈕確認吸收
function CultivationModule:OnCultivationBtnClick()
    -- 1. 主寵 Slot
    local mainSlot = tonumber(self.petSlot)
    if not mainSlot then
        return
    end
    -- 2. 收集已勾選材料
    local materialSlots = {}
    for slot = 1, 5 do
        if self.seriesDraft[slot] == true then
            table.insert(materialSlots, tostring(slot))
        end
    end
    -- 3. 至少選擇一隻材料
    if #materialSlots <= 0 then
        print("[PetCultivation] 尚未選擇材料寵物")
        return
    end
    local materialString = table.concat(materialSlots, ",")
    local packetData = tostring(mainSlot) .. "|" .. materialString
    WinMgr.SendPacket("ExecutePetCultivation", packetData)
    self:Toggle_Clist_Wnd()
end
-- 加總所有材料的培養經驗
function CultivationModule:GetMaterialPetCultivationExp(petLevel)
    petLevel = tonumber(petLevel) or 0
    if petLevel <= 0 then
        return 0
    end
    if petLevel >= 100 then
        return 0
    end
    local decreaseStep = math.floor((petLevel - 1) / 5)
    local exp = 100 - decreaseStep * 5
    if exp < 0 then
        exp = 0
    end
    return exp
end
-------------------------------------------------------------------
-------------------------------------------------------------------
function CultivationModule:OpenMaterialItemWindow(mainPetSlot)
    -- WinMgr.SendPacket("GetMaterialItem", mainPetSlot)
    self:B_material_List_CreateWin()
end
-- 點擊按鈕確認突破
function CultivationModule:OnBreakthroughBtnClick()
    local selected = {}
    for i = 1, 4 do
        if self.breakthroughCrystalSelected[i] == true then
            table.insert(selected, BREAKTHROUGH_CRYSTALS[i].id)
        end
    end
    -- 必須2～3種
    if #selected < 2 or #selected > 3 then
        return
    end
    local keyParts = {}
    for i = 1, 4 do
        if self.breakthroughCrystalSelected[i] == true then
            table.insert(keyParts, i)
        end
    end
    local recipeKey = table.concat(keyParts, ",")
    -- 必須是合法配方
    if not BREAKTHROUGH_RECIPES[recipeKey] then
        return
    end
    -- 寵物必須五圍全滿
    if not self:IsBreakthroughFull() then
        return
    end
    local totalRank = self:GetBreakthroughTotalRank()	-- 總檔次
    if totalRank >= 170 then
        return
    end
    local cost = self:GetBreakthroughCrystalCost(totalRank)	-- 每種水晶需求
    if not cost then
        return
    end
    local crystalString = table.concat(selected, ",")
    local packetData = tostring(self.petSlot) .. "|" .. crystalString

    WinMgr.SendPacket("ExecutePetBreakthrough",packetData)
    -- 先關閉第三層
    self:CloseBreakthroughMaterialWin()
end
-- 總檔次 → 水晶需求
function CultivationModule:GetBreakthroughCrystalCost(totalRank)
    totalRank = tonumber(totalRank) or 0
    for i = 1, #BREAKTHROUGH_CRYSTAL_COST do
        local data = BREAKTHROUGH_CRYSTAL_COST[i]
        if totalRank >= data.min and totalRank <= data.max then
            return data.cost
        end
    end
    return nil
end
-- 五圍全部滿檔判斷
function CultivationModule:IsBreakthroughFull()
    for i = 1, 5 do
        local current = tonumber(self.grade_tbl["Art" .. i .. "_N"]) or 0
        local full = tonumber(self.grade_tbl["Art" .. i .. "_F"]) or 0
        if current ~= full then
            return false
        end
    end
    return true
end
-- 總檔次計算
function CultivationModule:GetBreakthroughTotalRank()
    local total = 0
    for i = 1, 5 do
        total = total + (tonumber(self.grade_tbl["Art" .. i .. "_N"]) or 0)
    end
    return total
end
-- 碎片合法組合 Key
function CultivationModule:GetBreakthroughRecipeKey()
    local selected = {}
    for i = 1, 4 do
        if self.breakthroughCrystalSelected[i] == true then
            table.insert(selected, i)
        end
    end
    if #selected < 2 or #selected > 3 then
        return nil
    end
    return table.concat(selected, ",")
end

function CultivationModule:split(str, sep)
    local result = {}
    if not str then return result end
    for value in string.gmatch(str, "[^"..sep.."]+") do
        table.insert(result, value)
    end
    return result
end

return CultivationModule