--==============================================================================
-- 寵物同名吸收培養 - 客戶端 UI 模組
--==============================================================================
local CultivationModule = ModuleBase:extend('PetCultivationUI')
local WIN_ID = 90010
local material_list_WIN_ID = 90011
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

local PROGRESS_BG_IMG = "luaUI/modules/cg图档集/吸收培养/签到进度条.png"
local PROGRESS_FILL_IMG = "luaUI/modules/cg图档集/吸收培养/已完成进度条.png"

--------------------------------------------------------------------------------
-- 1. 生命週期與初始化
--------------------------------------------------------------------------------
function CultivationModule:onLoad()
    print("[PetCultivation] 吸收培養UI模組載入成功")
    WinMgr.PlaySe(73,320)
    self:cliSendMsg('load PetCultivationUI.lua 成功',4)

    self.wnd = nil
    self.progressBg = nil
    self.progressFill = nil
    self.grade_tbl = {
        Art1_N = 0, Art2_N = 0, Art3_N = 0, Art4_N = 0, Art5_N = 0,
        Art1_F = 0, Art2_F = 0, Art3_F = 0, Art4_F = 0, Art5_F = 0,
    }

    -- 接收來自客戶端按鈕的呼叫)
    self:onPacketRecv("SyncCultivationData", function(header, params)
        if params then
            -- 請求服務端傳送數據
            self:sendPacket("RequestPetCultivationData",tonumber(params[1]))
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
            self.grade_tbl = self.grade_tbl
            if not self.wnd then
                self:CreateWin()
                self:UpdateUI()
            else
                self:UpdateUI()
            end
        end
    end)

    self.material_list_wnd = nil
    self.material_List = {}
    -- 接收後端回傳的遊戲數據，建構與更新前端UI介面
    self:onPacketRecv("ResponseMaterialPetData", function(header, params)
        if params then
            local str = params[1] or ""
            local arr = self:split(str, "|")
            local group = 1;
            for i = 1,5 do
                local mat = self:split(arr[i], ",")
                self.material_List[group] = mat[1];
                self.material_List[group+1] = mat[2];
                group = group+2;
            end
            self.material_List = self.material_List
            self:material_list_CreateWin()
        end
    end)
end

function CultivationModule:onUnload()
    if self.wnd then
        self.wnd:Close()
        self:releaseWindow(self.wnd)
        self.wnd = nil
    end
end

--------------------------------------------------------------------------------
-- 2. UI 建立與控制
--------------------------------------------------------------------------------
-- 主寵物資訊(第二層)
function CultivationModule:ToggleWnd()
    WinMgr.PlaySe(57, CONST.Screen.Width / 2)
    if self.wnd and self.wnd.valid then
        self.wnd:Close()
        self:releaseWindow(self.wnd)
        self.wnd = nil
    else
        self:CreateWin()
    end
end
function CultivationModule:CreateWin_Update()
	local pet_Status = self:findWindow(15)	--寵物栏15
	if pet_Status == nil then
		if self.wnd and self.wnd.valid then
			self.wnd:Close()
			self:releaseWindow(self.wnd)
			self.wnd = nil
		end
	end
end
function CultivationModule:CreateWin()
    if self.wnd then return end

    local winW, winH = 200, 246
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
            self:ToggleWnd()
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
        onLeave = function() self.selectlistBtn:Set({image = BTN_STATE , visible=true}) self.selectlistStr:Set({color = 16})end
    })
    self.selectlistStr = window:AddText({ x = 110, y = 185, width = 64, height = 20, font = 13, color = 16, text = "選擇材料"})

    -- 培養經驗進度條
    self.progress_str = window:AddText({ x = 15, y = 185, width = 150, height = 24, font = 13, color = 113, text = "目前培養進度"})
    self.progressBg = window:AddPngImage({ x = 15, y = 205, width = 150, height = 8, image = PROGRESS_BG_IMG, hitable = false})
    self.progressFill = window:AddPngImage({ x = 15, y = 205, width = 0, height = 8, image = PROGRESS_FILL_IMG, hitable = false})
    -- 能否繼續吸收培養
    if self.maxed == "1" then
        self.maxed_str = window:AddText({ x = 71, y = 215, width = 150, height = 24, font = 13, color = 50, text = "五項能力檔次已達上限"})
    else
        self.cultivationCount_str = window:AddText({ x = 71, y = 215, width = 150, height = 24, font = 13, color = 49, text = "已吸收次數: "..self.cultivationCount})
    end
end

-- 材料選擇框(第三層)
function CultivationModule:Toggle_list_Wnd()
    WinMgr.PlaySe(57, CONST.Screen.Width / 2)
    if self.material_list_wnd and self.material_list_wnd.valid then
        self.material_list_wnd:Close()
        self:releaseWindow(self.material_list_wnd)
        self.material_list_wnd = nil
    else
        self:material_list_CreateWin()
    end
end
function CultivationModule:material_list_CreateWin_Update()
	local pet_Status = self:findWindow(15)	--寵物栏15
	if pet_Status == nil then
		if self.material_list_wnd and self.material_list_wnd.valid then
			self.material_list_wnd:Close()
			self:releaseWindow(self.material_list_wnd)
			self.material_list_wnd = nil
		end
	end
end
function CultivationModule:material_list_CreateWin()
    if self.material_list_wnd then return end

    local winW, winH = 200, 246
    local status, window = self:newWindow({
        id = material_list_WIN_ID,
        x = 200 + (CONST.Screen.Width - winW) / 2,
        y = (CONST.Screen.Height - winH) / 2,
        width = winW,
        height = winH,
        layer = 4,
        dragMove = 1,
        update = function() self:material_list_CreateWin_Update() end,
    })

    if not window then return end
    self.material_list_wnd = self:ownWindow(window)

    --- 視窗外框
    window:AddPngImage({ x = 0, y = 0, width = winW, height = winH, image = BG_frameIMG, hitable = false })
    -- 關閉按鈕
    window:AddPngImage({
        x = 159, y = 8, width = 12, height = 12,
        image = CLOSE_BTN, imageHover = CLOSE_HOVER, imagePress = CLOSE_PRESS,
        hitable = true,
        onClick = function()
            self:Toggle_list_Wnd()
            return true
        end
    })

    -- 頂部文字資訊
    window:AddText({ x = 45, y = 10, width = 20, height = 20, font = 4, color = 75, text = "勾選被吸收寵" })
    -- 確定吸收培養按鈕
    self.cultivationBtn = window:AddPngImage({
        x = 105, y = 182, width = 64, height = 20,
        image = BTN_STATE, hitable = true,
        onClick = function() self.cultivationBtn:Set({image = BTN_PRESS , visible=true}) WinMgr.PlaySe(51,CONST.Screen.Width/2) self:OnCultivationBtnClick() end,
        onHover = function() self.cultivationBtn:Set({image = BTN_STATE , visible=true}) self.cultivationStr:Set({color = 0}) end,
        onLeave = function() self.cultivationBtn:Set({image = BTN_STATE , visible=true}) self.cultivationStr:Set({color = 16})end
    })
    self.cultivationStr = window:AddText({ x = 110, y = 185, width = 64, height = 20, font = 13, color = 16, text = "確定吸收"})

end
--------------------------------------------------------------------------------
-- 3. 介面刷新
--------------------------------------------------------------------------------
function CultivationModule:UpdateUI()
    if not self.wnd then return end

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
    local fillWidth = 8 * currentExp / expNeed
    if fillWidth < 0 then fillWidth = 0 elseif fillWidth > 0 then fillWidth = 150 end
    if self.progressFill and self.progressFill.Set then
        self.progressFill:Set({ width = fillWidth })
    end
end

-- 點擊按鈕吸收名單
function CultivationModule:OpenMaterialPetWindow(mainPetSlot)
    WinMgr.SendPacket("GetMaterialPet", mainPetSlot)
end

function CultivationModule:OnCultivationBtnClick()

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