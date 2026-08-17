-- ============================================================================
-- CustomXB：可讀性重構＋反編譯語意校正版
-- 說明：
--   1. 以「程式碼正確.lua」作為原始語意基準。
--   2. 保留原有函式流程、協議代號、資料格式、數值與遊戲邏輯。
--   3. 修正可讀性重構過程中確認的參數／作用域錯置。
--   4. 中文註解僅用於說明功能，不作為程式邏輯來源。
-- ============================================================================

local Module = ModuleBase:createModule("equipForge")
local itemDataFields = {}

for index0_0 = 0, 75 do
	table.insert(itemDataFields, index0_0)
end

for index0_1 = 0, 13 do
	table.insert(itemDataFields, index0_1 + 2000)
end

local maxEnhanceLevel = 10
local enhanceSuccessRates = {
	90,
	90,
	90,
	80,
	70,
	60,
	50,
	40,
	30,
	20
}
local enhanceCosts = {
	1000,
	1000,
	2000,
	4000,
	8000,
	16000,
	32000,
	64000,
	128000,
	256000
}
local enhanceAttributeBonus = {
	1,
	2,
	3,
	6,
	7,
	8,
	14,
	20,
	30,
	50
}
local jobWeaponSkills = {}
local jobNames = {}
local itemRequiredLevels = {}
local equipmentTypeNames = {
	[0] = "劍",
	"斧",
	"槍",
	"杖",
	"弓",
	"小刀",
	"回力鏢",
	"盾",
	"盔",
	"帽",
	"鎧",
	"衣",
	"袍",
	"靴",
	"鞋"
}

-- 將 Tab 分隔的資料列切割成欄位陣列。
function splitTabLine(line)
	local data = {}

	for index in (line .. "\t"):gmatch("(.-)\t") do
		table.insert(data, index)
	end

	return data
end

-- 依序搜尋伺服器資料目錄並開啟指定資料檔。
function openDataFile(filename)
	for index, index2 in ipairs({
		"data/",
		"./data/",
		"lua/data/",
		"data/gmsv/"
	}) do
		local value = io.open(index2 .. filename, "r")

		if value then
			return value
		end
	end

	return nil
end

local gemItemIdStart = 13600
local gemItemIdEnd = 13669
local gemAttributeNames = {
	"最大耐久",
	"攻擊力",
	"防禦力",
	"敏捷",
	"精神",
	"回復",
	"必殺",
	"反擊",
	"命中",
	"閃躲",
	"生命值",
	"魔力值"
}
local gemMaterialEffects = {}

-- 讀取 itemmaterial.txt，建立寶石材料效果資料表。
function loadGemMaterialData()
	local value = openDataFile("itemmaterial.txt")

	if not value then
		return
	end

	local result = value:read("*a")

	value:close()

	local value2 = 0

	for index in string.gmatch(result, "[^\r\n]+") do
		index = index:gsub("^%s+", ""):gsub("%s+$", "")

		if index ~= "" and index:sub(1, 1) ~= "#" then
			local value3 = splitTabLine(index)
			local numericValue = tonumber(value3[2])

			if numericValue and value3[3] then
				local data = {}

				for index2 = 1, 12 do
					local numericValue2 = tonumber(value3[3 + (index2 - 1) * 3]) or 0
					local numericValue3 = tonumber(value3[4 + (index2 - 1) * 3]) or 0

					table.insert(data, {
						flag = numericValue2,
						val = numericValue3
					})
				end

				gemMaterialEffects[numericValue] = data
				value2 = value2 + 1
			end
		end
	end
end

-- 判斷道具 ID 是否屬於有效寶石 ID 範圍。
function isGemItemId(itemId)
	itemId = tonumber(itemId) or 0

	return itemId >= gemItemIdStart and itemId <= gemItemIdEnd
end

-- 從道具資料取得目前鑲嵌的寶石 ID。
function getItemGemId(itemIndex)
	local itemType = tonumber(Item.GetData(itemIndex, CONST.道具_类型)) or -1
	local result = itemType >= 0 and itemType <= 6 and CONST.道具_宝石武 or CONST.道具_宝石防

	return tonumber(Item.GetData(itemIndex, result)) or 0
end

-- 將寶石 ID 解碼成材料類型與效果序號。
function decodeGemId(gemItemId)
	gemItemId = tonumber(gemItemId) or 0

	if not isGemItemId(gemItemId) then
		return 0, 0
	end

	local value = gemItemId - gemItemIdStart

	return math.floor(value / 10) + 1, value % 10 + 1
end

-- 從 JSON 道具資料中讀取寶石位置。
function decodeGemItemJson(itemJson)
	if not itemJson then
		return 0, 0
	end

	local value, localValue7_1 = pcall(JSON.decode, itemJson)

	if not value or type(localValue7_1) ~= "table" then
		return 0, 0
	end

	local itemType = tonumber(localValue7_1[tostring(CONST.道具_类型)]) or -1
	local result = itemType >= 0 and itemType <= 6 and CONST.道具_宝石武 or CONST.道具_宝石防

	return decodeGemId(tonumber(localValue7_1[tostring(result)]) or 0)
end

-- 取得指定道具的寶石材料類型與序號。
function getItemGemPosition(itemIndex)
	if not itemIndex or itemIndex < 0 then
		return 0, 0
	end

	return decodeGemId(getItemGemId(itemIndex))
end

local weaponGemEffectBaseIds = {
	[0] = 0,
	10,
	20,
	30,
	40,
	50,
	60
}
local armorGemEffectBaseIds = {
	[0] = 400,
	410,
	420,
	430,
	440,
	450,
	460
}

-- 依武器/防具類型換算 itemmaterial 對應索引。
function getGemMaterialId(gemItemId, isWeapon)
	local calculatedValue = math.floor((gemItemId - gemItemIdStart) / 10)
	local value = (gemItemId - gemItemIdStart) % 10 + 1
	local value2 = ((isWeapon and weaponGemEffectBaseIds or armorGemEffectBaseIds)[calculatedValue] or 0) + (value - 1)

	if not gemMaterialEffects[value2] then
		value2 = ((isWeapon and armorGemEffectBaseIds or weaponGemEffectBaseIds)[calculatedValue] or 0) + (value - 1)
	end

	return value2
end

-- 將寶石材料效果整理成可顯示的文字。
function formatGemEffects(materialId, isWeapon)
	local value = gemMaterialEffects[materialId]

	if not value then
		return ""
	end

	local value2 = {
		1,
		2,
		3,
		4,
		5,
		6,
		7,
		8,
		9,
		10,
		11,
		12
	}

	if not isWeapon then
		value2 = {
			1,
			3,
			2,
			4,
			5,
			6,
			8,
			7,
			10,
			9,
			11,
			12
		}
	end

	local data = {}

	for index = 1, 12 do
		local result = value[value2[index]]

		if result and result.val ~= 0 then
			local value3 = gemAttributeNames[index] or ""

			if result.flag == 1 then
				table.insert(data, string.format("%+d%s", result.val, value3))
			else
				table.insert(data, string.format("%+d%%%s", result.val, value3))
			end
		end
	end

	return table.concat(data, "、")
end

-- 取得寶石效果列表，供 UI 或協議傳送。
function getGemEffectList(gemItemId, isWeapon)
	if not isGemItemId(gemItemId) then
		return {}
	end

	local value = getGemMaterialId(gemItemId, isWeapon)
	local value2 = gemMaterialEffects[value]

	if not value2 then
		return {}
	end

	local value3 = {
		1,
		2,
		3,
		4,
		5,
		6,
		7,
		8,
		9,
		10,
		11,
		12
	}

	if not isWeapon then
		value3 = {
			1,
			3,
			2,
			4,
			5,
			6,
			8,
			7,
			10,
			9,
			11,
			12
		}
	end

	local data = {}

	for index = 1, 12 do
		local result = value2[value3[index]]

		if result and result.val ~= 0 then
			local value4 = gemAttributeNames[index] or ""

			if result.flag == 1 then
				table.insert(data, string.format("%+d%s", result.val, value4))
			else
				table.insert(data, string.format("%+d%%%s", result.val, value4))
			end
		end
	end

	return data
end

-- 把寶石效果套用到道具資料。
function applyGemEffects(itemData, materialId, isWeapon, resetDurability)
	local value = gemMaterialEffects[materialId]

	if not value then
		return false
	end

	local value2

	if isWeapon then
		value2 = {
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
			CONST.道具_魔力
		}
	else
		value2 = {
			CONST.道具_最大耐久,
			CONST.道具_防御,
			CONST.道具_攻击,
			CONST.道具_敏捷,
			CONST.道具_精神,
			CONST.道具_回复,
			CONST.道具_反击,
			CONST.道具_必杀,
			CONST.道具_闪躲,
			CONST.道具_命中,
			CONST.道具_生命,
			CONST.道具_魔力
		}
	end

	for index = 1, 12 do
		local result = value[index]
		local result2 = value2[index]

		if result and result2 and result.val ~= 0 then
			local numericValue = tonumber(itemData[tostring(result2)]) or 0

			if result.flag == 1 then
				itemData[tostring(result2)] = numericValue + result.val
			else
				itemData[tostring(result2)] = math.floor(numericValue * (1 + result.val / 100))
			end
		end
	end

	if resetDurability and value[1] and value[1].val ~= 0 and CONST.道具_耐久 then
		itemData[tostring(CONST.道具_耐久)] = itemData[tostring(CONST.道具_最大耐久)]
	end

	return true
end

-- 讀取職業熟練度、職業名稱與道具需求等資料。
function loadJobAndItemSetData()
	local value = openDataFile("jobs.txt")

	if value then
		local value2 = 0

		for index in value:lines() do
			local value3 = splitTabLine(index)

			if #value3 >= 27 then
				local numericValue = tonumber(value3[3])

				if numericValue then
					local data = {}

					for index2 = 0, 14 do
						data[index2] = tonumber(value3[12 + index2]) or 0
					end

					jobWeaponSkills[numericValue] = data
					jobNames[numericValue] = value3[1]
					value2 = value2 + 1
				end
			end
		end

		value:close()
	end

	local value4 = openDataFile("itemset.txt")

	if value4 then
		local value5 = 0

		for index3 in value4:lines() do
			local value6 = splitTabLine(index3)

			if #value6 >= 24 then
				local numericValue2 = tonumber(value6[12])

				if numericValue2 then
					local numericValue3 = tonumber(value6[24])

					if numericValue3 then
						itemRequiredLevels[numericValue2] = numericValue3
						value5 = value5 + 1
					end
				end
			end
		end

		value4:close()
	end
end

local suitItemInfo = {}

-- 讀取套裝資料並建立道具 ID 對應資訊。
function loadSuitSetData()
	suitItemInfo = {}

	local value = openDataFile("suitset.txt")

	if value then
		local value2 = 0

		for index in value:lines() do
			if index ~= "" then
				local value3 = splitTabLine(index)

				if #value3 >= 9 and tonumber(value3[1]) then
					local result = value3[2]
					local numericValue = tonumber(value3[8]) or 1

					for index2 in (value3[9] or ""):gmatch("%d+") do
						suitItemInfo[tonumber(index2)] = {
							name = result,
							num = numericValue
						}
						value2 = value2 + 1
					end
				end
			end
		end

		value:close()
	end
end

-- 統計角色裝備欄中指定套裝的已裝備件數。
function countEquippedSuitItems(playerIndex, suitName)
	if not suitName then
		return 0
	end

	local value = 0

	for index = 0, 7 do
		local itemIndex = Char.GetItemIndex(playerIndex, index)

		if itemIndex and itemIndex >= 0 then
			local itemId = tonumber(Item.GetData(itemIndex, CONST.道具_ID)) or 0
			local value2 = suitItemInfo[itemId]

			if value2 and value2.name == suitName then
				value = value + 1
			end
		end
	end

	return value
end

local equipmentItemTypes = {}

for index0_2 = 0, 22 do
	equipmentItemTypes[index0_2] = true
end

-- 取得實體道具的套裝效果與鑲嵌寶石資訊。
function getItemSetAndGemInfo(playerIndex, itemIndex)
	if not itemIndex or itemIndex < 0 then
		return "", ""
	end

	local itemType = tonumber(Item.GetData(itemIndex, CONST.道具_类型)) or 0

	if not equipmentItemTypes[itemType] then
		return "", ""
	end

	local itemId = tonumber(Item.GetData(itemIndex, CONST.道具_ID)) or 0
	local value = suitItemInfo[itemId]
	local value2 = ""

	if value then
		local value3 = countEquippedSuitItems(playerIndex, value.name)

		if value3 < 1 then
			value3 = 1
		end

		value2 = "套裝效果:" .. value.name .. " (" .. tostring(value3) .. "/" .. tostring(value.num) .. ")"
	else
		value2 = "套裝效果:無"
	end

	local numericValue = tonumber(Item.GetData(itemIndex, CONST.道具_宝石武)) or 0

	if numericValue <= 0 then
		numericValue = tonumber(Item.GetData(itemIndex, CONST.道具_宝石防)) or 0
	end

	local value4 = "鑲嵌寶石:" .. (numericValue > 0 and (Item.GetNameFromNumber(numericValue) or "寶石ID:" .. tostring(numericValue)) or "無")

	return value2, value4
end

-- 取得 JSON 道具資料的套裝效果與鑲嵌寶石資訊。
function getItemDataSetAndGemInfo(playerIndex, itemData)
	if type(itemData) ~= "table" then
		return "", ""
	end

	local itemType = tonumber(itemData[tostring(CONST.道具_类型)]) or 0

	if not equipmentItemTypes[itemType] then
		return "", ""
	end

	local itemId = tonumber(itemData[tostring(CONST.道具_ID)]) or 0
	local value = suitItemInfo[itemId]
	local value2 = ""

	if value then
		local value3 = countEquippedSuitItems(playerIndex, value.name)

		if value3 < 1 then
			value3 = 1
		end

		value2 = "套裝效果:" .. value.name .. " (" .. tostring(value3) .. "/" .. tostring(value.num) .. ")"
	else
		value2 = "套裝效果:無"
	end

	local numericValue = tonumber(itemData[tostring(CONST.道具_宝石武)]) or 0

	if numericValue <= 0 then
		numericValue = tonumber(itemData[tostring(CONST.道具_宝石防)]) or 0
	end

	local value4 = "鑲嵌寶石:" .. (numericValue > 0 and (Item.GetNameFromNumber(numericValue) or "寶石ID:" .. tostring(numericValue)) or "無")

	return value2, value4
end

-- 檢查裝備的等級與職業熟練限制，回傳錯誤訊息。
function getEquipRestrictionMessage(playerIndex, itemIndex)
	local value, localValue18_1 = pcall(function()
		if not itemIndex or itemIndex < 0 then
			return nil
		end

		local itemType = tonumber(Item.GetData(itemIndex, CONST.道具_类型))

		if not itemType or itemType < 0 or itemType > 14 then
			return nil
		end

		local itemId = tonumber(Item.GetData(itemIndex, CONST.道具_ID))

		if not itemId then
			return nil
		end

		local value = itemRequiredLevels[itemId]

		if not value or value < 1 then
			return nil
		end

		if value > (tonumber(Char.GetData(playerIndex, CONST.对象_等级)) or 0) then
			return "無法裝備：需要人物等級 " .. value .. " 以上"
		end

		local jobId = tonumber(Char.GetData(playerIndex, CONST.对象_职业))

		if not jobId then
			return nil
		end

		local value2 = jobWeaponSkills[jobId]

		if not value2 then
			return nil
		end

		local result = value2[itemType]

		if result < value then
			return "無法裝備：需要" .. value .. "級" .. (equipmentTypeNames[itemType] or "") .. "熟練，當前職業熟練僅" .. tostring(result)
		end

		return nil
	end)

	if not value then
		return nil
	end

	return localValue18_1
end

local enhanceTrackedAttributes = {
	CONST.道具_攻击,
	CONST.道具_防御,
	CONST.道具_敏捷,
	CONST.道具_精神,
	CONST.道具_回复,
	CONST.道具_生命,
	CONST.道具_魔力,
	CONST.道具_耐力,
	CONST.道具_灵巧,
	CONST.道具_智力,
	CONST.道具_必杀,
	CONST.道具_反击,
	CONST.道具_命中,
	CONST.道具_闪躲,
	CONST.道具_毒抗,
	CONST.道具_睡抗,
	CONST.道具_石抗,
	CONST.道具_醉抗,
	CONST.道具_乱抗,
	CONST.道具_忘抗,
	CONST.道具_魔抗,
	CONST.道具_魔攻
}

-- 四捨五入數值，兼容正負數。
function roundNumber(value)
	value = tonumber(value) or 0

	if value >= 0 then
		return math.floor(value + 0.5)
	end

	return math.ceil(value - 0.5)
end

-- 移除裝備名稱尾端的強化等級標記。
function stripEnhanceSuffix(itemName)
	if type(itemName) ~= "string" or itemName == "" then
		return itemName
	end

	local value = tostring(itemName)
	local text = string.gsub(value, "%s*%+%d+$", "")

	return (string.gsub(text, "%s*＋%d+$", ""))
end

-- 讀取裝備強化 JSON 資料。
function getEnhanceData(itemIndex)
	local enhanceData = Item.GetExtData(itemIndex, "starEnhance")

	if not enhanceData or enhanceData == "" then
		return {
			baseName = "",
			level = 0,
			baseAttrs = {}
		}
	end

	local value, localValue22_2 = pcall(JSON.decode, enhanceData)

	if not value or type(localValue22_2) ~= "table" then
		return {
			baseName = "",
			level = 0,
			baseAttrs = {}
		}
	end

	return localValue22_2
end

-- 將裝備強化資料寫回道具 ExtData。
function saveEnhanceData(itemIndex, enhanceData)
	local encodedData = JSON.encode(enhanceData)

	return Item.SetExtData(itemIndex, "starEnhance", encodedData)
end

-- 初始化缺少的強化資料與基礎屬性。
function ensureEnhanceData(itemIndex, saveData)
	if saveData == nil then
		saveData = true
	end

	local value = getEnhanceData(itemIndex)
	local flag = false

	if not value.starEnhance then
		value.starEnhance = {}
		flag = true
	end

	if not value.starEnhance.baseName or value.starEnhance.baseName == "" then
		value.starEnhance.baseName = stripEnhanceSuffix(Item.GetData(itemIndex, CONST.道具_名字))
		flag = true
	end

	if not value.starEnhance.baseAttrs then
		value.starEnhance.baseAttrs = {}
		flag = true
	end

	for index, index2 in ipairs(enhanceTrackedAttributes) do
		local value2 = tostring(index2)

		if value.starEnhance.baseAttrs[value2] == nil then
			value.starEnhance.baseAttrs[value2] = tonumber(Item.GetData(itemIndex, index2)) or 0
			flag = true
		end
	end

	if type(value.starEnhance.level) ~= "number" then
		value.starEnhance.level = 0
		flag = true
	end

	if saveData and flag then
		saveEnhanceData(itemIndex, value)
	end

	return value
end

-- 向玩家發送系統提示訊息。
function sendSystemMessage(playerIndex, message)
	NLG.SystemMessage(playerIndex, message)
end

-- 封裝並發送自訂 XBCENTER 協議封包。
function sendXBProtocol(playerIndex, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13)
	local numericValue = tostring(tonumber(arg1) or 0)
	local numericValue2 = tostring(tonumber(arg2) or 0)
	local numericValue3 = tostring(tonumber(arg3) or 0)
	local numericValue4 = tostring(tonumber(playerIndex) or -1)
	local value = tostring(arg4 or "")
	local value2 = tostring(arg5 or "")
	local value3 = tostring(arg6 or "")
	local value4 = tostring(arg7 or "")
	local value5 = tostring(arg8 or "")

	local value6 = tostring(arg9 or "")
	local value7 = tostring(arg10 or 0)
	local value8 = tostring(arg11 or 0)
	local value9 = tostring(arg12 or "")
	local value10 = tostring(arg13 or "")

	Protocol.Send(playerIndex, "XBCENTER", numericValue, numericValue2, numericValue3, numericValue4, value, value2, value3, value4, value5, value6, value7, value8, value9, value10)
end

-- 將實體裝備屬性整理成 UI 顯示格式。
function formatItemInfo(itemIndex)
	if itemIndex < 0 then
		return "暫無裝備"
	end

	local itemName = Item.GetData(itemIndex, CONST.道具_名字) or "未知裝備"
	local value = {
		{
			name = "攻擊",
			id = CONST.道具_攻击
		},
		{
			name = "防禦",
			id = CONST.道具_防御
		},
		{
			name = "敏捷",
			id = CONST.道具_敏捷
		},
		{
			name = "精神",
			id = CONST.道具_精神
		},
		{
			name = "回復",
			id = CONST.道具_回复
		},
		{
			name = "生命",
			id = CONST.道具_生命
		},
		{
			name = "魔力",
			id = CONST.道具_魔力
		},
		{
			name = "耐力",
			id = CONST.道具_耐力
		},
		{
			name = "靈巧",
			id = CONST.道具_灵巧
		},
		{
			name = "智力",
			id = CONST.道具_智力
		},
		{
			name = "必殺",
			id = CONST.道具_必杀
		},
		{
			name = "反擊",
			id = CONST.道具_反击
		},
		{
			name = "命中",
			id = CONST.道具_命中
		},
		{
			name = "閃躲",
			id = CONST.道具_闪躲
		},
		{
			name = "毒抗",
			id = CONST.道具_毒抗
		},
		{
			name = "睡抗",
			id = CONST.道具_睡抗
		},
		{
			name = "石抗",
			id = CONST.道具_石抗
		},
		{
			name = "醉抗",
			id = CONST.道具_醉抗
		},
		{
			name = "亂抗",
			id = CONST.道具_乱抗
		},
		{
			name = "忘抗",
			id = CONST.道具_忘抗
		},
		{
			name = "魔抗",
			id = CONST.道具_魔抗
		},
		{
			name = "魔攻",
			id = CONST.道具_魔攻
		}
	}
	local data = {}

	for index, index2 in ipairs(value) do
		local value2 = Item.GetData(itemIndex, index2.id) or 0

		if value2 > 0 then
			table.insert(data, index2.name .. ":" .. value2)
		end
	end

	local result = itemName

	for index3 = 1, #data, 3 do
		local data2 = {}

		if data[index3] then
			table.insert(data2, data[index3])
		end

		if data[index3 + 1] then
			table.insert(data2, data[index3 + 1])
		end

		if data[index3 + 2] then
			table.insert(data2, data[index3 + 2])
		end

		result = result .. "|" .. table.concat(data2, " ")
	end

	return result
end

-- 將序列化道具資料整理成 UI 顯示格式。
function formatItemDataInfo(itemData)
	if type(itemData) ~= "table" then
		return "未知物品"
	end

	local value = tostring(itemData.item_name or "未知物品")
	local value2 = {
		{
			name = "攻擊",
			id = CONST.道具_攻击
		},
		{
			name = "防禦",
			id = CONST.道具_防御
		},
		{
			name = "敏捷",
			id = CONST.道具_敏捷
		},
		{
			name = "精神",
			id = CONST.道具_精神
		},
		{
			name = "回復",
			id = CONST.道具_回复
		},
		{
			name = "生命",
			id = CONST.道具_生命
		},
		{
			name = "魔力",
			id = CONST.道具_魔力
		},
		{
			name = "耐力",
			id = CONST.道具_耐力
		},
		{
			name = "靈巧",
			id = CONST.道具_灵巧
		},
		{
			name = "智力",
			id = CONST.道具_智力
		},
		{
			name = "必殺",
			id = CONST.道具_必杀
		},
		{
			name = "反擊",
			id = CONST.道具_反击
		},
		{
			name = "命中",
			id = CONST.道具_命中
		},
		{
			name = "閃躲",
			id = CONST.道具_闪躲
		},
		{
			name = "毒抗",
			id = CONST.道具_毒抗
		},
		{
			name = "睡抗",
			id = CONST.道具_睡抗
		},
		{
			name = "石抗",
			id = CONST.道具_石抗
		},
		{
			name = "醉抗",
			id = CONST.道具_醉抗
		},
		{
			name = "亂抗",
			id = CONST.道具_乱抗
		},
		{
			name = "忘抗",
			id = CONST.道具_忘抗
		},
		{
			name = "魔抗",
			id = CONST.道具_魔抗
		},
		{
			name = "魔攻",
			id = CONST.道具_魔攻
		}
	}
	local data = {}

	for index, index2 in ipairs(value2) do
		local numericValue = tonumber(itemData[tostring(index2.id)]) or 0

		if numericValue > 0 then
			table.insert(data, index2.name .. ":" .. numericValue)
		end
	end

	local result = value

	for index3 = 1, #data, 3 do
		local data2 = {}

		if data[index3] then
			table.insert(data2, data[index3])
		end

		if data[index3 + 1] then
			table.insert(data2, data[index3 + 1])
		end

		if data[index3 + 2] then
			table.insert(data2, data[index3 + 2])
		end

		result = result .. "|" .. table.concat(data2, " ")
	end

	return result
end

local itemTypeNames = {
	[0] = "劍",
	"斧",
	"槍",
	"杖",
	"弓",
	"小刀",
	"回力鏢",
	"盾",
	"盔",
	"帽",
	"鎧",
	"衣",
	"袍",
	"靴",
	"鞋",
	"手環",
	"樂器",
	"項鏈",
	"戒指",
	"頭帶",
	"耳環",
	"護身符",
	"水晶",
	"料理",
	"家具",
	"果皮",
	"不明",
	"寶箱",
	"鑰匙",
	"礦石",
	"木材",
	"布卷",
	"肉類",
	"海鮮",
	"蔬菜",
	"其他食材",
	"香草",
	"藥草",
	"寶石",
	"B類材料",
	"封印卡",
	"圖鑒卡",
	"料理",
	"藥水",
	"書",
	"未知",
	"特殊物品",
	"彩票",
	"特殊物品",
	nil,
	nil,
	"炸彈",
	nil,
	nil,
	nil,
	"頭飾",
	"寵物水晶",
	"寵物飾品",
	"寵物裝甲",
	"寵物服飾",
	"寵物項圈",
	"寵物護符"
}

-- 取得實體道具耐久度文字。
function formatItemDurability(itemIndex)
	if itemIndex < 0 then
		return ""
	end

	local durability = tonumber(Item.GetData(itemIndex, CONST.道具_耐久)) or 0
	local maxDurability = tonumber(Item.GetData(itemIndex, CONST.道具_最大耐久)) or 0

	if maxDurability <= 0 then
		return ""
	end

	return "耐久:" .. durability .. "/" .. maxDurability
end

-- 取得實體道具類型文字。
function formatItemType(itemIndex)
	if itemIndex < 0 then
		return ""
	end

	local itemType = tonumber(Item.GetData(itemIndex, CONST.道具_类型)) or 0

	return "種類:" .. (itemTypeNames[itemType] or tostring(itemType))
end

-- 取得 JSON 道具耐久度文字。
function formatItemDataDurability(itemData)
	if type(itemData) ~= "table" then
		return ""
	end

	local durability = tonumber(itemData[tostring(CONST.道具_耐久)]) or 0
	local maxDurability = tonumber(itemData[tostring(CONST.道具_最大耐久)]) or 0

	if maxDurability <= 0 then
		return ""
	end

	return "耐久:" .. durability .. "/" .. maxDurability
end

-- 取得 JSON 道具類型文字。
function formatItemDataType(itemData)
	if type(itemData) ~= "table" then
		return ""
	end

	local itemType = tonumber(itemData[tostring(CONST.道具_类型)]) or 0

	return "種類:" .. (itemTypeNames[itemType] or tostring(itemType))
end

-- 取得道具顯示名稱。
function getItemDisplayName(itemIndex)
	if itemIndex < 0 then
		return 0
	end

	local value = getEnhanceData(itemIndex)

	if value and value.starEnhance and type(value.starEnhance.level) == "number" then
		return math.max(0, math.min(10, value.starEnhance.level))
	end

	return 0
end

-- 從 JSON 道具資料取得顯示名稱。
function getItemDisplayNameFromData(itemData)
	if itemData < 0 then
		return 0
	end

	return math.max(0, tonumber(Item.GetData(itemData, CONST.道具_等级)) or 0)
end

-- 取得道具圖像資訊。
function getItemImage(itemIndex)
	if type(itemIndex) ~= "table" then
		return 0
	end

	return math.max(0, tonumber(itemIndex[tostring(CONST.道具_等级)]) or 0)
end

-- 換算角色背包欄位與實際 slot。
function getInventorySlot(playerIndex, slot)
	return slot
end

local takeStoredBagItem
local serializeBagItem
local bagPageSize = 20
local bagPageCount = 4
local bagTotalSlots = bagPageSize * bagPageCount

-- 取得目前背包頁碼並限制在有效範圍。
function getBagPage(playerIndex)
	local page = tonumber(Char.GetExtData(playerIndex, "xbbag_page")) or 0

	if page < 0 then
		page = 0
	elseif page > bagPageCount then
		page = bagPageCount
	end

	return page
end

-- 將背包物品資料分段寫入角色 ExtData。
function saveBagItem(playerIndex, slot, itemJson, image, count, level)
	if itemJson then
		local data = {}

		for index = 1, #itemJson, 2000 do
			table.insert(data, string.sub(itemJson, index, index + 1999))
		end

		for index2, index3 in ipairs(data) do
			Char.SetExtData(playerIndex, "xbbag_" .. slot .. "_" .. index2, index3)
		end

		local value, localValue38_2 = decodeGemItemJson(itemJson)

		Char.SetExtData(playerIndex, "xbbag_" .. slot .. "_count", #data)
		Char.SetExtData(playerIndex, "xbbag_" .. slot .. "_img", image)
		Char.SetExtData(playerIndex, "xbbag_" .. slot .. "_cnt", count)
		Char.SetExtData(playerIndex, "xbbag_" .. slot .. "_lv", level)
		Char.SetExtData(playerIndex, "xbbag_" .. slot .. "_gemt", value)
		Char.SetExtData(playerIndex, "xbbag_" .. slot .. "_gems", localValue38_2)
	else
		for index4 = 1, 10 do
			Char.SetExtData(playerIndex, "xbbag_" .. slot .. "_" .. index4, nil)
		end

		Char.SetExtData(playerIndex, "xbbag_" .. slot .. "_count", nil)
		Char.SetExtData(playerIndex, "xbbag_" .. slot .. "_img", nil)
		Char.SetExtData(playerIndex, "xbbag_" .. slot .. "_cnt", nil)
		Char.SetExtData(playerIndex, "xbbag_" .. slot .. "_lv", nil)
		Char.SetExtData(playerIndex, "xbbag_" .. slot .. "_gemt", nil)
		Char.SetExtData(playerIndex, "xbbag_" .. slot .. "_gems", nil)
	end
end

-- 從角色 ExtData 讀取背包物品資料。
function loadBagItem(playerIndex, slot)
	local itemCount = tonumber(Char.GetExtData(playerIndex, "xbbag_" .. slot .. "_count")) or 0

	if itemCount <= 0 then
		return nil
	end

	local data = {}

	for index = 1, itemCount do
		local value = Char.GetExtData(playerIndex, "xbbag_" .. slot .. "_" .. index)

		if not value then
			return nil
		end

		table.insert(data, value)
	end

	return table.concat(data)
end

-- 解析背包物品 JSON 並回傳物品資訊。
function getBagItemData(playerIndex, slot)
	return tonumber(Char.GetExtData(playerIndex, "xbbag_" .. slot .. "_img")) or 0, tonumber(Char.GetExtData(playerIndex, "xbbag_" .. slot .. "_cnt")) or 0, tonumber(Char.GetExtData(playerIndex, "xbbag_" .. slot .. "_lv")) or 0, tonumber(Char.GetExtData(playerIndex, "xbbag_" .. slot .. "_gemt")) or 0, tonumber(Char.GetExtData(playerIndex, "xbbag_" .. slot .. "_gems")) or 0
end

local refreshBagUI

-- 整理並傳送玩家背包列表給客戶端。
function sendBagList(playerIndex)
	local value = getBagPage(playerIndex)
	local data = {}

	for index = 1, 20 do
		local value2 = 0
		local value3 = 0
		local value4 = 0
		local value5 = 0
		local value6 = 0

		if value <= 0 then
			local itemIndex = Char.GetItemIndex(playerIndex, 7 + index)

			if itemIndex and itemIndex >= 0 then
				value2 = tonumber(Item.GetData(itemIndex, 1) or 0) or 0
				value3 = tonumber(Item.GetData(itemIndex, CONST.道具_堆叠数) or 0) or 0

				if value3 < 0 then
					value3 = 0
				end

				value4 = getItemDisplayName(itemIndex)

				local value7 = getItemGemId(itemIndex)

				value5, value6 = decodeGemId(value7)
			end
		else
			local value8 = (value - 1) * bagPageSize + (index - 1)

			value2, value3, value4, value5, value6 = getBagItemData(playerIndex, value8)
		end

		table.insert(data, tostring(value2) .. ":" .. tostring(value3) .. ":" .. tostring(value4) .. ":" .. tostring(value5) .. ":" .. tostring(value6))
	end

	Protocol.Send(playerIndex, "CUSTOMBAG", table.concat(data, ","))
	refreshBagUI(playerIndex)
end

function refreshBagUI(playerIndex)
	local data = {}
	local flag = false

	for index = 8, 27 do
		local itemIndex = Char.GetItemIndex(playerIndex, getInventorySlot(playerIndex, index))

		if itemIndex and itemIndex >= 0 then
			flag = true

			break
		end
	end

	table.insert(data, flag and "1" or "0")

	for index2 = 1, bagPageCount do
		local flag2 = false
		local value = (index2 - 1) * bagPageSize

		for index3 = value, value + bagPageSize - 1 do
			if (tonumber(Char.GetExtData(playerIndex, "xbbag_" .. index3 .. "_count")) or 0) > 0 then
				flag2 = true

				break
			end
		end

		table.insert(data, flag2 and "1" or "0")
	end

	Protocol.Send(playerIndex, "RIGHTBAG", table.concat(data, ","))
end

local equipmentSlots = {
	5,
	0,
	6,
	2,
	3,
	1,
	4,
	7
}

-- 整理並傳送角色裝備欄資訊。
function sendEquipmentList(playerIndex)
	local data = {}

	for index = 1, 8 do
		local itemIndex = Char.GetItemIndex(playerIndex, equipmentSlots[index])

		if itemIndex and itemIndex >= 0 then
			local numericValue = tonumber(Item.GetData(itemIndex, 1) or 0) or 0
			local value = getItemDisplayName(itemIndex)
			local value2 = getItemGemId(itemIndex)
			local value3 = 0
			local value4 = 0

			if isGemItemId(value2) then
				value3 = math.floor((value2 - gemItemIdStart) / 10) + 1
				value4 = (value2 - gemItemIdStart) % 10 + 1
			end

			table.insert(data, tostring(numericValue) .. ":" .. tostring(value) .. ":" .. tostring(value3) .. ":" .. tostring(value4))
		else
			table.insert(data, "0:0:0:0")
		end
	end

	local characterImage = tonumber(Char.GetData(playerIndex, CONST.对象_形象)) or 0

	Protocol.Send(playerIndex, "CUSTOMEQUIP", tostring(characterImage), table.concat(data, ","))
end

-- 尋找道具應該放入的裝備欄位。
function findEquipmentSlot(playerIndex, itemIndex)
	local itemType = Item.GetData(itemIndex, CONST.道具_类型)

	if Item.Types.isWeapon(itemType) then
		return CONST.EQUIP_右手
	end

	if itemType == CONST.ITEM_TYPE_盾 then
		return CONST.EQUIP_左手
	end

	if itemType == CONST.ITEM_TYPE_盔 or itemType == CONST.ITEM_TYPE_帽 then
		return CONST.EQUIP_头
	end

	if itemType == CONST.ITEM_TYPE_铠 or itemType == CONST.ITEM_TYPE_衣 or itemType == CONST.ITEM_TYPE_袍 then
		return CONST.EQUIP_身
	end

	if itemType == CONST.ITEM_TYPE_鞋 or itemType == CONST.ITEM_TYPE_靴 then
		return CONST.EQUIP_腿
	end

	if Item.Types.isAccessory(itemType) or itemType == CONST.道具类型_头饰 then
		if Char.GetItemIndex(playerIndex, CONST.EQUIP_首饰1) < 0 then
			return CONST.EQUIP_首饰1
		end

		if Char.GetItemIndex(playerIndex, CONST.EQUIP_首饰2) < 0 then
			return CONST.EQUIP_首饰2
		end

		return CONST.EQUIP_首饰1
	end

	if Item.Types.isCrystal(itemType) then
		return CONST.EQUIP_水晶
	end

	return -1
end

-- 判斷道具類型是否可以放入指定裝備欄。
function canEquipInSlot(itemType, slot)
	if slot == 1 or slot == 3 then
		return Item.Types.isAccessory(itemType) or itemType == CONST.道具类型_头饰
	end

	if slot == 2 then
		return itemType == CONST.ITEM_TYPE_盔 or itemType == CONST.ITEM_TYPE_帽
	end

	if slot == 4 or slot == 5 then
		return Item.Types.isWeapon(itemType) or itemType == CONST.ITEM_TYPE_盾
	end

	if slot == 6 then
		return itemType == CONST.ITEM_TYPE_铠 or itemType == CONST.ITEM_TYPE_衣 or itemType == CONST.ITEM_TYPE_袍
	end

	if slot == 7 then
		return itemType == CONST.ITEM_TYPE_鞋 or itemType == CONST.ITEM_TYPE_靴
	end

	if slot == 8 then
		return Item.Types.isCrystal(itemType)
	end

	return false
end

-- 執行裝備動作並處理職業/等級限制。
function equipItem(playerIndex, bagSlot, targetEquipSlot, mode)
	bagSlot = tonumber(bagSlot) or -1
	targetEquipSlot = tonumber(targetEquipSlot) or -1
	mode = tonumber(mode) or 1

	local value = -1

	if mode > 1 then
		value = bagSlot

		local value2 = takeStoredBagItem(playerIndex, bagSlot)

		if not value2 then
			return
		end

		bagSlot = value2
	end

	if bagSlot < 8 or bagSlot > 27 then
		sendSystemMessage(playerIndex, "裝備失敗：背包槽位無效")

		return
	end

	local value3 = getInventorySlot(playerIndex, bagSlot)
	local itemIndex = Char.GetItemIndex(playerIndex, value3)

	if not itemIndex or itemIndex < 0 then
		sendSystemMessage(playerIndex, "該格子沒有物品")

		return
	end

	local value4 = getEquipRestrictionMessage(playerIndex, itemIndex)

	if value4 then
		sendSystemMessage(playerIndex, value4)

		return
	end

	local itemType = Item.GetData(itemIndex, CONST.道具_类型)
	local value5

	if targetEquipSlot >= 1 and targetEquipSlot <= 8 then
		if not canEquipInSlot(itemType, targetEquipSlot) then
			sendSystemMessage(playerIndex, "該物品不能放入此裝備格")

			return
		end

		value5 = equipmentSlots[targetEquipSlot]
	else
		value5 = findEquipmentSlot(playerIndex, itemIndex)
	end

	if not value5 or value5 < 0 or value5 > 7 then
		sendSystemMessage(playerIndex, "該物品無法裝備")

		return
	end

	local targetItemIndex = Char.GetItemIndex(playerIndex, value5)

	if targetItemIndex and targetItemIndex >= 0 then
		Char.SetItemIndex(playerIndex, value3, targetItemIndex)
		Char.SetItemIndex(playerIndex, value5, itemIndex)
		Item.UpItem(playerIndex, value3)
		Item.UpItem(playerIndex, value5)
	else
		if not Char.MoveItem(playerIndex, value3, value5, -1) then
			sendSystemMessage(playerIndex, "無法裝備該物品（職業/等級限制）")
			sendBagList(playerIndex)
			sendEquipmentList(playerIndex)

			return
		end

		Item.UpItem(playerIndex, value3)
		Item.UpItem(playerIndex, value5)
	end

	NLG.UpChar(playerIndex)
	Char.UpCharStatus(playerIndex)

	if value >= 0 then
		local value6 = targetItemIndex

		if value6 < 1 or value6 > 8 then
			for index, index2 in pairs(equipmentSlots) do
				if index2 == value5 then
					value6 = index

					break
				end
			end
		end

		if value6 >= 1 and value6 <= 8 then
			Char.SetExtData(playerIndex, "ui_eqv_" .. value6, tostring(value))
		end
	end

	sendBagList(playerIndex)
	sendEquipmentList(playerIndex)
	sendSystemMessage(playerIndex, "已裝備")
end

-- 執行卸下裝備並放回背包。
function unequipItem(playerIndex, equipSlot, targetBagSlot, mode)
	equipSlot = tonumber(equipSlot) or -1

	if equipSlot < 1 or equipSlot > 8 then
		sendSystemMessage(playerIndex, "卸下失敗：裝備格無效")

		return
	end

	local value = equipmentSlots[equipSlot]
	local itemIndex = Char.GetItemIndex(playerIndex, value)

	if not itemIndex or itemIndex < 0 then
		sendSystemMessage(playerIndex, "該裝備格沒有物品")

		return
	end

	local numericValue = tonumber(Char.GetExtData(playerIndex, "ui_eqv_" .. equipSlot)) or -1

	mode = tonumber(mode) or 1

	if mode > 1 then
		local numericValue2 = tonumber(targetBagSlot) or -1

		if numericValue2 < 0 or numericValue2 >= bagTotalSlots then
			sendSystemMessage(playerIndex, "卸下失敗：格子無效")

			return
		end

		if (tonumber(Char.GetExtData(playerIndex, "xbbag_" .. numericValue2 .. "_count")) or 0) > 0 then
			sendSystemMessage(playerIndex, "背包第" .. tostring(mode) .. "頁該格已有物品")

			return
		end

		local value2 = serializeBagItem(itemIndex)

		if not value2 then
			sendSystemMessage(playerIndex, "卸下失敗：物品數據異常")

			return
		end

		local numericValue3 = tonumber(Item.GetData(itemIndex, 1) or 0) or 0
		local numericValue4 = tonumber(Item.GetData(itemIndex, CONST.道具_堆叠数) or 0) or 0

		if numericValue4 < 0 then
			numericValue4 = 0
		end

		local value3 = getItemDisplayName(itemIndex)

		saveBagItem(playerIndex, numericValue2, value2, numericValue3, numericValue4, value3)
		Char.SetExtData(playerIndex, "ui_eqv_" .. equipSlot, nil)
		Char.SetItemIndex(playerIndex, value, -1)
		Item.UpItem(playerIndex, value)
		NLG.UpChar(playerIndex)
		sendBagList(playerIndex)
		sendEquipmentList(playerIndex)
		sendSystemMessage(playerIndex, "已卸下並放入背包第" .. tostring(mode) .. "頁")

		return
	end

	if numericValue >= 0 and numericValue < bagTotalSlots and (tonumber(Char.GetExtData(playerIndex, "xbbag_" .. numericValue .. "_count")) or 0) <= 0 then
		local value4 = serializeBagItem(itemIndex)

		if value4 then
			local numericValue5 = tonumber(Item.GetData(itemIndex, 1) or 0) or 0
			local numericValue6 = tonumber(Item.GetData(itemIndex, CONST.道具_堆叠数) or 0) or 0

			if numericValue6 < 0 then
				numericValue6 = 0
			end

			local value5 = getItemDisplayName(itemIndex)

			saveBagItem(playerIndex, numericValue, value4, numericValue5, numericValue6, value5)
			Char.SetExtData(playerIndex, "ui_eqv_" .. equipSlot, nil)
			Char.SetItemIndex(playerIndex, value, -1)
			Item.UpItem(playerIndex, value)
			NLG.UpChar(playerIndex)
			sendBagList(playerIndex)
			sendEquipmentList(playerIndex)
			sendSystemMessage(playerIndex, "已卸下並放回原背包位置")

			return
		end
	end

	local value6 = -1
	local numericValue7 = tonumber(targetBagSlot) or -1

	if numericValue7 >= 8 and numericValue7 <= 27 then
		local value7 = getInventorySlot(playerIndex, numericValue7)
		local targetBagItemSlot = Char.GetItemIndex(playerIndex, value7)

		if not targetBagItemSlot or targetBagItemSlot < 0 then
			value6 = value7
		end
	end

	if value6 < 0 then
		for index = 8, 27 do
			local itemIndex3 = Char.GetItemIndex(playerIndex, getInventorySlot(playerIndex, index))

			if not itemIndex3 or itemIndex3 < 0 then
				value6 = getInventorySlot(playerIndex, index)

				break
			end
		end
	end

	if value6 < 0 then
		sendSystemMessage(playerIndex, "背包已滿")

		return
	end

	local itemIndex4 = Char.GetItemIndex(playerIndex, value6)

	if itemIndex4 and itemIndex4 >= 0 then
		Char.SetItemIndex(playerIndex, value, itemIndex4)
		Char.SetItemIndex(playerIndex, value6, itemIndex)
		Item.UpItem(playerIndex, value)
		Item.UpItem(playerIndex, value6)
	else
		if not Char.MoveItem(playerIndex, value, value6, -1) then
			sendSystemMessage(playerIndex, "無法卸下裝備")
			sendBagList(playerIndex)
			sendEquipmentList(playerIndex)

			return
		end

		Item.UpItem(playerIndex, value)
		Item.UpItem(playerIndex, value6)
	end

	NLG.UpChar(playerIndex)
	Char.UpCharStatus(playerIndex)

	if numericValue >= 0 then
		Char.SetExtData(playerIndex, "ui_eqv_" .. equipSlot, nil)
	end

	sendBagList(playerIndex)
	sendEquipmentList(playerIndex)
	sendSystemMessage(playerIndex, "已卸下裝備")
end

-- 修理角色所有可修理裝備。
function repairAllEquipment(playerIndex)
	local value = 0

	for index = 1, 8 do
		local value2 = equipmentSlots[index]
		local itemIndex = Char.GetItemIndex(playerIndex, value2)

		if itemIndex and itemIndex >= 0 then
			local itemType = tonumber(Item.GetData(itemIndex, CONST.道具_类型)) or -1

			if (itemType >= 0 and itemType <= 22) or itemType <= 55 then
				local durability = tonumber(Item.GetData(itemIndex, CONST.道具_耐久)) or 0
				local maxDurability = tonumber(Item.GetData(itemIndex, CONST.道具_最大耐久)) or 0

				if maxDurability > 0 then
					local value3 = roundNumber((maxDurability + durability) / 2)

					if value3 < 1 then
						value3 = 1
					end

					Item.SetData(itemIndex, CONST.道具_最大耐久, value3)
					Item.SetData(itemIndex, CONST.道具_耐久, value3)
					Item.UpItem(playerIndex, value2)

					value = value + 1
				end
			end
		end
	end

	if value > 0 then
		NLG.UpChar(playerIndex)
		Char.UpCharStatus(playerIndex)
	end

	sendEquipmentList(playerIndex)
	sendSystemMessage(playerIndex, "修理完成，共修理 " .. tostring(value) .. " 件裝備")
end

-- 交換兩個裝備欄位的裝備。
function swapEquipment(playerIndex, slot1, secondSlot)
	slot1 = tonumber(slot1) or -1
	secondSlot = tonumber(secondSlot) or -1

	if slot1 < 1 or slot1 > 8 or secondSlot < 1 or secondSlot > 8 then
		sendSystemMessage(playerIndex, "交換失敗：裝備格無效")

		return
	end

	if slot1 == secondSlot then
		return
	end

	local value = equipmentSlots[slot1]
	local value2 = equipmentSlots[secondSlot]
	local itemIndex = Char.GetItemIndex(playerIndex, value)
	local secondItemIndex = Char.GetItemIndex(playerIndex, value2)

	if not itemIndex or itemIndex < 0 then
		sendSystemMessage(playerIndex, "該裝備格沒有物品")

		return
	end

	local value3 = getEquipRestrictionMessage(playerIndex, itemIndex)

	if value3 then
		sendSystemMessage(playerIndex, value3)

		return
	end

	if secondItemIndex and secondItemIndex >= 0 then
		local value4 = getEquipRestrictionMessage(playerIndex, secondItemIndex)

		if value4 then
			sendSystemMessage(playerIndex, value4)

			return
		end
	end

	if not canEquipInSlot(Item.GetData(itemIndex, CONST.道具_类型), secondItemIndex) then
		sendSystemMessage(playerIndex, "該物品不能放入此裝備格")

		return
	end

	if secondItemIndex and secondItemIndex >= 0 and not canEquipInSlot(Item.GetData(secondItemIndex, CONST.道具_类型), slot1) then
		sendSystemMessage(playerIndex, "該物品不能放入此裝備格")

		return
	end

	local numericValue = tonumber(Char.GetExtData(playerIndex, "ui_eqv_" .. slot1)) or -1
	local numericValue2 = tonumber(Char.GetExtData(playerIndex, "ui_eqv_" .. secondItemIndex)) or -1

	Char.SetItemIndex(playerIndex, value, secondItemIndex)
	Char.SetItemIndex(playerIndex, value2, itemIndex)
	Item.UpItem(playerIndex, value)
	Item.UpItem(playerIndex, value2)
	NLG.UpChar(playerIndex)
	Char.UpCharStatus(playerIndex)

	if numericValue >= 0 then
		Char.SetExtData(playerIndex, "ui_eqv_" .. secondItemIndex, tostring(numericValue))
	else
		Char.SetExtData(playerIndex, "ui_eqv_" .. secondItemIndex, nil)
	end

	if numericValue2 >= 0 then
		Char.SetExtData(playerIndex, "ui_eqv_" .. slot1, tostring(numericValue2))
	else
		Char.SetExtData(playerIndex, "ui_eqv_" .. slot1, nil)
	end

	sendEquipmentList(playerIndex)
end

-- 重新整理裝備欄與角色狀態。
function refreshEquipment(playerIndex, slot)
	slot = tonumber(slot) or -1

	if slot < 1 or slot > 8 then
		return
	end

	local value = equipmentSlots[slot]
	local itemIndex = Char.GetItemIndex(playerIndex, value)

	if not itemIndex or itemIndex < 0 then
		sendXBProtocol(playerIndex, 3, 0, 0, "", "", "", "", "", "", 0, 0)
		Protocol.Send(playerIndex, "EQUIPINFO", tostring(slot), "0", "0", "", "", "", "", "")

		return
	end

	local numericValue = tonumber(Item.GetData(itemIndex, 1) or 0) or 0
	local value2 = getItemDisplayNameFromData(itemIndex)
	local value3, localValue50_5 = getItemSetAndGemInfo(playerIndex, itemIndex)
	sendPotentialCacheXBCENTERFromItemIndex(playerIndex, itemIndex, "equip", tostring(slot))

	Protocol.Send(playerIndex, "EQUIPINFO", tostring(slot), tostring(numericValue), tostring(value2), formatItemInfo(itemIndex), formatItemDurability(itemIndex), formatItemType(itemIndex), value3, localValue50_5)
end

-- 查詢指定裝備欄位的詳細資訊。
function queryEquipmentInfo(playerIndex, slot)
	slot = tonumber(slot) or -1

	if slot < 1 or slot > 20 then
		return
	end

	local value = getBagPage(playerIndex)

	if value > 0 then
		local value2 = (value - 1) * bagPageSize + (slot - 1)
		local value3, localValue51_3, localValue51_4 = getBagItemData(playerIndex, value2)
		local value4 = loadBagItem(playerIndex, value2)

		if not value4 then
			sendXBProtocol(playerIndex, 3, 0, 0, "", "", "", "", "", "", 0, 0)
			Protocol.Send(playerIndex, "BAGINFO", tostring(slot), "0", "0", "", "", "", "", "")

			return
		end

		local value5, localValue51_7 = pcall(JSON.decode, value4)
		local result = value5 and formatItemDataInfo(localValue51_7) or ""
		local value6, localValue51_10 = getItemDataSetAndGemInfo(playerIndex, localValue51_7)
		sendPotentialCacheXBCENTER(playerIndex, value5 and localValue51_7 or nil)

		Protocol.Send(playerIndex, "BAGINFO", tostring(slot), tostring(value3), tostring(localValue51_4), result, value5 and formatItemDataDurability(localValue51_7) or "", value5 and formatItemDataType(localValue51_7) or "", value6, localValue51_10)

		return
	end

	local value7 = 7 + slot
	local itemIndex = Char.GetItemIndex(playerIndex, value7)

	if not itemIndex or itemIndex < 0 then
		sendXBProtocol(playerIndex, 3, 0, 0, "", "", "", "", "", "", 0, 0)
		Protocol.Send(playerIndex, "BAGINFO", tostring(slot), "0", "0", "", "", "", "", "")

		return
	end

	local numericValue = tonumber(Item.GetData(itemIndex, 1) or 0) or 0
	local value8 = getItemDisplayNameFromData(itemIndex)
	local value9, localValue51_16 = getItemSetAndGemInfo(playerIndex, itemIndex)
	sendPotentialCacheXBCENTERFromItemIndex(playerIndex, itemIndex)

	Protocol.Send(playerIndex, "BAGINFO", tostring(slot), tostring(numericValue), tostring(value8), formatItemInfo(itemIndex), formatItemDurability(itemIndex), formatItemType(itemIndex), value9, localValue51_16)
end

-- 重新整理道具資訊 UI。
function refreshItemInfo(playerIndex)
	local numericValue = tonumber(Char.GetData(playerIndex, CONST.对象_金币)) or 0

	Protocol.Send(playerIndex, "MONEY", tostring(numericValue))
end

-- 整理玩家背包順序。
function sortBag(playerIndex)
	if NLG.SortItem(playerIndex) == 1 then
		sendSystemMessage(playerIndex, "背包整理完成")
	end

	sendBagList(playerIndex)
end

-- 查詢指定背包頁的內容。
function queryBagPage(playerIndex)
	if playerIndex < 0 then
		return 0
	end

	local value = getEnhanceData(playerIndex)

	if value and value.starEnhance and type(value.starEnhance.level) == "number" then
		return (math.max(0, math.min(10, value.starEnhance.level)))
	end

	return 0
end

-- 開關強化成功率加成。
function toggleEnhanceSuccessBoost(playerIndex)
	local numericValue = (tonumber(Char.GetExtData(playerIndex, "ui_store_protect")) or 0) == 0 and 1 or 0

	Char.SetExtData(playerIndex, "ui_store_protect", numericValue)

	if numericValue == 1 then
		sendSystemMessage(playerIndex, "已開啟+成功率：強化費用增加100%，成功率提升10%")
	else
		sendSystemMessage(playerIndex, "已關閉加成功率")
	end

	sendXBProtocol(playerIndex, 2, 0, numericValue, "")
end

-- 查詢目前強化成功率加成狀態。
function queryEnhanceSuccessBoost(playerIndex)
	local numericValue = tonumber(Char.GetExtData(playerIndex, "ui_store_protect")) or 0

	sendXBProtocol(playerIndex, 2, 0, numericValue, "")

	if numericValue == 1 then
		sendSystemMessage(playerIndex, "當前+成功率：已開啟")
	else
		sendSystemMessage(playerIndex, "當前+成功率：已關閉")
	end
end

-- 將背包裝備放入強化槽。
function putEnhanceItem(playerIndex, slot, page)
	page = tonumber(page) or 1

	if page > 1 then
		local value = takeStoredBagItem(playerIndex, slot)

		if not value then
			return
		end

		slot = value
	end

	if type(slot) ~= "number" then
		sendSystemMessage(playerIndex, "放入失敗：slot參數無效")

		return
	end

	slot = getInventorySlot(playerIndex, slot)

	if (tonumber(Char.GetExtData(playerIndex, "ui_store_hasItem")) or 0) == 1 then
		sendSystemMessage(playerIndex, "強化槽已有物品，請先取回")

		return
	end

	local itemIndex = Char.GetItemIndex(playerIndex, slot)

	if not itemIndex or itemIndex < 0 then
		sendSystemMessage(playerIndex, "背包第一格沒有物品")

		return
	end

	local itemType = tonumber(Item.GetData(itemIndex, CONST.道具_类型)) or -1

	if itemType < 0 or itemType > 22 then
		sendSystemMessage(playerIndex, "只有裝備類道具才能放入強化槽")

		return
	end

	local value2 = Item.GetData(itemIndex, 0)
	local value3 = Item.GetData(itemIndex, 1)
	local value4 = Item.GetData(itemIndex, 2)
	local value5 = queryBagPage(itemIndex)
	local value6 = formatItemInfo(itemIndex)
	local data = {}

	for index, index2 in pairs(itemDataFields) do
		data[tostring(index2)] = Item.GetData(itemIndex, index2)
	end

	data.item_name = Item.GetData(itemIndex, CONST.道具_名字)

	ensureEnhanceData(itemIndex, true)

	local value7 = getEnhanceData(itemIndex)

	if value7 then
		local flag = false

		for index3, index4 in pairs(value7) do
			flag = true

			break
		end

		if flag then
			data._itemExt = value7
		end
	end

	-- 強化槽也攜帶潛能與統一基礎屬性快照。
	local potentialExt = Item.GetExtData(itemIndex, "potentialData")
	if potentialExt and tostring(potentialExt) ~= "" then
		local potentialOK, potentialValue = pcall(JSON.decode, tostring(potentialExt))
		if potentialOK and type(potentialValue) == "table" then data.potential = potentialValue end
	end
	local statBase = ensureStatBaseAttrsForItem(itemIndex)
	if statBase then data._statBaseAttrs = statBase end

	local value8
	local value9, localValue57_13 = pcall(JSON.encode, data)

	if value9 then
		value8 = localValue57_13
	else
		sendSystemMessage(playerIndex, "[系統] 警告：道具數據序列化失敗")
	end

	Char.SetExtData(playerIndex, "ui_store_itemIndex", itemIndex)
	Char.SetExtData(playerIndex, "ui_store_fromSlot", slot)
	Char.SetExtData(playerIndex, "ui_store_hasItem", 1)
	Char.SetExtData(playerIndex, "ui_store_itemData0", tostring(value2))
	Char.SetExtData(playerIndex, "ui_store_itemData1", tostring(value3))
	Char.SetExtData(playerIndex, "ui_store_itemData2", tostring(value4))
	Char.SetExtData(playerIndex, "ui_store_cache_img", tonumber(value3))
	Char.SetExtData(playerIndex, "ui_store_cache_lv", value5)

	if value8 then
		local value10 = 2000
		local data2 = {}

		for index5 = 1, #value8, value10 do
			table.insert(data2, string.sub(value8, index5, index5 + value10 - 1))
		end

		for index6, index7 in ipairs(data2) do
			Char.SetExtData(playerIndex, "ui_store_itemFullData_" .. index6, index7)
		end

		Char.SetExtData(playerIndex, "ui_store_itemFullData_count", #data2)
	end

	Char.SetItemIndex(playerIndex, slot, -1)
	Item.UpItem(playerIndex, -1)

	local value11, localValue57_17 = getItemDataSetAndGemInfo(playerIndex, data)

	local potentialText, potentialMainQuality, potentialAddQuality = getPotentialHoverCacheData(data)
	sendXBProtocol(playerIndex, 1, tonumber(value3) or 0, value5, value6, formatItemDataDurability(data), formatItemDataType(data), value11, localValue57_17, potentialText, potentialMainQuality, potentialAddQuality)
	sendBagList(playerIndex)
	sendSystemMessage(playerIndex, "已把裝備放入強化槽")
end

-- 從強化槽取回裝備。
function takeEnhanceItem(playerIndex, slot, targetPage)
	if (tonumber(Char.GetExtData(playerIndex, "ui_store_hasItem")) or 0) ~= 1 then
		sendSystemMessage(playerIndex, "強化槽內沒有物品")
		sendXBProtocol(playerIndex, 0, 0, 0, "")

		return
	end

	Char.SetExtData(playerIndex, "ui_store_hasItem", 0)
	Char.SetExtData(playerIndex, "ui_store_itemIndex", nil)

	local value
	local itemCount = tonumber(Char.GetExtData(playerIndex, "ui_store_itemFullData_count")) or 0

	if itemCount > 0 then
		local data = {}

		for index = 1, itemCount do
			local value2 = Char.GetExtData(playerIndex, "ui_store_itemFullData_" .. index)

			if value2 then
				table.insert(data, value2)
			end
		end

		if #data == itemCount then
			value = table.concat(data)
		end
	end

	if not value then
		sendSystemMessage(playerIndex, "強化槽道具數據不完整，無法取回！裝備仍保留在強化槽，請重新登錄後再試。")
		Char.SetExtData(playerIndex, "ui_store_hasItem", 1)

		return
	end

	local value3
	local value4, localValue58_6 = pcall(JSON.decode, value)

	if value4 then
		value3 = localValue58_6
	end

	if not value3 or type(value3) ~= "table" then
		sendSystemMessage(playerIndex, "強化槽道具數據解析失敗，無法取回！裝備仍保留在強化槽，請重新登錄後再試。")
		Char.SetExtData(playerIndex, "ui_store_hasItem", 1)

		return
	end

	targetPage = tonumber(targetPage) or 1

	if targetPage > 1 then
		local numericValue = tonumber(slot) or -1

		if numericValue < 0 or numericValue >= bagTotalSlots then
			sendSystemMessage(playerIndex, "取回失敗：格子無效")

			return
		end

		if (tonumber(Char.GetExtData(playerIndex, "xbbag_" .. numericValue .. "_count")) or 0) > 0 then
			sendSystemMessage(playerIndex, "背包第" .. tostring(targetPage) .. "頁該格已有物品")

			return
		end

		local itemImage = tonumber(Char.GetExtData(playerIndex, "ui_store_cache_img")) or 0
		local itemLevel = tonumber(Char.GetExtData(playerIndex, "ui_store_cache_lv")) or 0
		local numericValue2 = tonumber(value3[tostring(CONST.道具_堆叠数)]) or 0

		if numericValue2 < 0 then
			numericValue2 = 0
		end

		saveBagItem(playerIndex, numericValue, value, itemImage, numericValue2, itemLevel)
		Char.SetExtData(playerIndex, "ui_store_hasItem", 0)
		Char.SetExtData(playerIndex, "ui_store_fromSlot", nil)
		Char.SetExtData(playerIndex, "ui_store_itemData0", nil)
		Char.SetExtData(playerIndex, "ui_store_itemData1", nil)
		Char.SetExtData(playerIndex, "ui_store_itemData2", nil)
		Char.SetExtData(playerIndex, "ui_store_cache_img", nil)
		Char.SetExtData(playerIndex, "ui_store_cache_lv", nil)
		Char.SetExtData(playerIndex, "ui_store_itemFullData_count", nil)

		for index2 = 1, 20 do
			Char.SetExtData(playerIndex, "ui_store_itemFullData_" .. index2, nil)
		end

		sendXBProtocol(playerIndex, 0, 0, 0, "")
		sendBagList(playerIndex)
		sendSystemMessage(playerIndex, "已取回並放入背包第" .. tostring(targetPage) .. "頁")

		return
	end

	local value5 = -1
	local numericValue3 = tonumber(Char.GetExtData(playerIndex, "ui_store_fromSlot")) or -1
	local numericValue4 = tonumber(slot) or -1

	if numericValue4 >= 8 and numericValue4 <= 27 then
		local value6 = getInventorySlot(playerIndex, numericValue4)
		local itemIndex = Char.GetItemIndex(playerIndex, value6)

		if not itemIndex or itemIndex < 0 then
			value5 = value6
		end
	end

	if value5 < 0 then
		local value7 = getInventorySlot(playerIndex, numericValue3)
		local targetPageValue = Char.GetItemIndex(playerIndex, value7)

		if not targetPageValue or targetPageValue < 0 then
			value5 = value7
		end
	end

	if value5 < 0 then
		for index3 = 27, 8, -1 do
			local itemIndex3 = Char.GetItemIndex(playerIndex, getInventorySlot(playerIndex, index3))

			if not itemIndex3 or itemIndex3 < 0 then
				value5 = getInventorySlot(playerIndex, index3)

				break
			end
		end
	end

	if value5 < 0 then
		sendSystemMessage(playerIndex, "背包滿了！")
		Char.SetExtData(playerIndex, "ui_store_hasItem", 1)

		return
	end

	local newItemIndex = Item.MakeItem(0)

	if newItemIndex < 0 then
		sendSystemMessage(playerIndex, "創建道具失敗！")
		Char.SetExtData(playerIndex, "ui_store_hasItem", 1)

		return
	end

	if value3._itemExt then
		-- block empty
	end

	for index4, index5 in pairs(itemDataFields) do
		local value8 = tostring(index5)

		if type(value3[value8]) ~= "nil" then
			Item.SetData(newItemIndex, index5, value3[value8])
		end
	end

	if value3.item_name then
		Item.SetData(newItemIndex, CONST.道具_名字, value3.item_name)
	end

	if value3._itemExt and type(value3._itemExt) == "table" then
		local flag = false

		for index6, index7 in pairs(value3._itemExt) do
			flag = true

			break
		end

		if flag then
			saveEnhanceData(newItemIndex, value3._itemExt)
		else
			ensureEnhanceData(newItemIndex, true)
		end
	else
		ensureEnhanceData(newItemIndex, true)
	end

	-- 強化格取回時，除了強化資料，也必須恢復潛能與基礎屬性快照。
	-- 舊版此處只還原 _itemExt，導致「有潛能的裝備 → 強化格 → 取回」後潛能效果消失。
	if value3.potential and type(value3.potential) == "table" then
		local potentialOK, potentialEncoded = pcall(JSON.encode, value3.potential)
		if potentialOK and potentialEncoded then
			Item.SetExtData(newItemIndex, "potentialData", potentialEncoded)
		end
	end

	if value3._statBaseAttrs and type(value3._statBaseAttrs) == "table" then
		saveStatBaseExtData(newItemIndex, value3._statBaseAttrs)
	end

	Char.SetItemIndex(playerIndex, value5, newItemIndex)

	local itemLevel2 = tonumber(Char.GetExtData(playerIndex, "ui_store_cache_lv")) or 0
	local value9 = 0
	local value10 = 1001
	local value11 = 1002
	local value12 = 1003

	if value3._itemExt and value3._itemExt.starEnhance and value3._itemExt.starEnhance.level and value3._itemExt.starEnhance.level > 0 then
		local result = value3._itemExt.starEnhance
		local result2 = result.baseName or value3.item_name or ""
		local result3 = result.level or itemLevel2

		if result2 ~= "" then
			local text = result3 > 0 and string.format("+%d", result3) or ""

			Item.SetData(newItemIndex, CONST.道具_名字, result2 .. text)

			if result.baseAttrs and result3 > 0 then
				local value13 = enhanceAttributeBonus[result3] or 0

				for index8, index9 in ipairs(enhanceTrackedAttributes) do
					local value14 = tostring(index9)
					local numericValue5 = tonumber(result.baseAttrs[value14]) or 0

					if numericValue5 ~= 0 then
						local value15 = roundNumber(numericValue5 * (100 + value13) / 100)

						Item.SetData(newItemIndex, index9, value15)
					end
				end
			end
		end

		Item.SetExtData(newItemIndex, "EnhLevel", result3)

		local result4 = value9

		if result3 >= 10 then
			result4 = value12
		elseif result3 >= 7 then
			result4 = value11
		elseif result3 >= 4 then
			result4 = value10
		end

		Item.SetData(newItemIndex, CONST.道具_背景图标, result4)
	else
		Item.SetExtData(newItemIndex, "EnhLevel", 0)
		Item.SetData(newItemIndex, CONST.道具_背景图标, 0)
	end

	-- 最終取回前統一依「基礎 → 潛能 → 寶石 → 強化」重建，避免強化格取回後只恢復強化而遺失潛能影響。
	rebuildItemStats(playerIndex, newItemIndex, value5)

	Item.UpItem(playerIndex, value5)
	NLG.UpChar(playerIndex)

	if value3.item_name then
		Item.SetData(newItemIndex, CONST.道具_名字, value3.item_name)
		Item.UpItem(playerIndex, value5)
	end

	Char.SetExtData(playerIndex, "ui_store_fromSlot", nil)
	Char.SetExtData(playerIndex, "ui_store_itemData0", nil)
	Char.SetExtData(playerIndex, "ui_store_itemData1", nil)
	Char.SetExtData(playerIndex, "ui_store_itemData2", nil)
	Char.SetExtData(playerIndex, "ui_store_cache_img", nil)
	Char.SetExtData(playerIndex, "ui_store_cache_lv", nil)
	Char.SetExtData(playerIndex, "ui_store_itemFullData_count", nil)

	for index10 = 1, 20 do
		Char.SetExtData(playerIndex, "ui_store_itemFullData_" .. index10, nil)
	end

	sendXBProtocol(playerIndex, 0, 0, 0, "")

	local itemId = Item.GetData(newItemIndex, CONST.道具_ID)
	local itemName = Item.GetData(newItemIndex, CONST.道具_名字)
	local value16 = queryBagPage(newItemIndex)

	sendSystemMessage(playerIndex, "取回成功！")
	sendBagList(playerIndex)
end

-- 查詢強化槽中的裝備。
function queryEnhanceSlot(playerIndex)
	local numericValue = tonumber(Char.GetExtData(playerIndex, "ui_store_hasItem")) or 0
	local itemImage = tonumber(Char.GetExtData(playerIndex, "ui_store_cache_img")) or 0
	local itemLevel = tonumber(Char.GetExtData(playerIndex, "ui_store_cache_lv")) or 0

	if numericValue == 1 then
		local value = "強化槽中有裝備"
		local value2
		local itemCount = tonumber(Char.GetExtData(playerIndex, "ui_store_itemFullData_count")) or 0

		if itemCount > 0 then
			local data = {}

			for index = 1, itemCount do
				local value3 = Char.GetExtData(playerIndex, "ui_store_itemFullData_" .. index)

				if value3 then
					table.insert(data, value3)
				end
			end

			if #data == itemCount then
				value2 = table.concat(data)
			end
		end

		if value2 then
			local value4
			local value5, localValue59_10 = pcall(JSON.decode, value2)

			if value5 then
				value4 = localValue59_10
			end

			if value4 and type(value4) == "table" then
				local itemName = value4.item_name or value4[tostring(CONST.道具_名字)] or "未知装备"

				if value4._itemExt and value4._itemExt.starEnhance then
					local result = value4._itemExt.starEnhance
					local result2 = result.baseName or itemName
					local result3 = result.level or itemLevel

					itemName = result2 .. (result3 > 0 and "+" .. result3 or "")

					local value6 = {
						{
							name = "攻擊",
							id = CONST.道具_攻击
						},
						{
							name = "防禦",
							id = CONST.道具_防御
						},
						{
							name = "敏捷",
							id = CONST.道具_敏捷
						},
						{
							name = "精神",
							id = CONST.道具_精神
						},
						{
							name = "回復",
							id = CONST.道具_回复
						},
						{
							name = "生命",
							id = CONST.道具_生命
						},
						{
							name = "魔力",
							id = CONST.道具_魔力
						},
						{
							name = "耐力",
							id = CONST.道具_耐力
						},
						{
							name = "靈巧",
							id = CONST.道具_灵巧
						},
						{
							name = "智力",
							id = CONST.道具_智力
						},
						{
							name = "必殺",
							id = CONST.道具_必杀
						},
						{
							name = "反擊",
							id = CONST.道具_反击
						},
						{
							name = "命中",
							id = CONST.道具_命中
						},
						{
							name = "閃躲",
							id = CONST.道具_闪躲
						},
						{
							name = "毒抗",
							id = CONST.道具_毒抗
						},
						{
							name = "睡抗",
							id = CONST.道具_睡抗
						},
						{
							name = "石抗",
							id = CONST.道具_石抗
						},
						{
							name = "醉抗",
							id = CONST.道具_醉抗
						},
						{
							name = "亂抗",
							id = CONST.道具_乱抗
						},
						{
							name = "忘抗",
							id = CONST.道具_忘抗
						},
						{
							name = "魔抗",
							id = CONST.道具_魔抗
						},
						{
							name = "魔攻",
							id = CONST.道具_魔攻
						}
					}
					local data2 = {}

					if result.baseAttrs then
						local value7 = enhanceAttributeBonus[result3] or 0

						for index2, index3 in ipairs(value6) do
							local value8 = tostring(index3.id)
							local numericValue2 = tonumber(result.baseAttrs[value8]) or 0

							if numericValue2 > 0 then
								local result4 = result3 > 0 and roundNumber(numericValue2 * (100 + value7) / 100) or numericValue2

								table.insert(data2, index3.name .. ":" .. result4)
							end
						end
					end

					value = itemName

					for index4 = 1, #data2, 3 do
						local data3 = {}

						if data2[index4] then
							table.insert(data3, data2[index4])
						end

						if data2[index4 + 1] then
							table.insert(data3, data2[index4 + 1])
						end

						if data2[index4 + 2] then
							table.insert(data3, data2[index4 + 2])
						end

						value = value .. "|" .. table.concat(data3, " ")
					end
				else
					value = itemName .. "|强化等级:" .. itemLevel
				end
			else
				sendSystemMessage(playerIndex, "[系統] 檢測到強化槽道具數據異常，請取回後重新放入。")
			end
		else
			sendSystemMessage(playerIndex, "[系統] 檢測到強化槽道具數據不完整，顯示可能異常，請取回後重新放入。")
		end

		local value9, localValue59_23 = getItemDataSetAndGemInfo(playerIndex, itemData)

		local potentialText, potentialMainQuality, potentialAddQuality = getPotentialHoverCacheData(itemData)
		sendXBProtocol(playerIndex, 1, itemImage, itemLevel, value, formatItemDataDurability(itemData), formatItemDataType(itemData), value9, localValue59_23, potentialText, potentialMainQuality, potentialAddQuality)
		sendSystemMessage(playerIndex, "[系統] 檢測到強化槽中有裝備，已自動恢復顯示。")
	else
		sendXBProtocol(playerIndex, 0, 0, 0, "")
	end

	local numericValue3 = tonumber(Char.GetExtData(playerIndex, "ui_store_protect")) or 0

	sendXBProtocol(playerIndex, 2, 0, numericValue3, "")
end

-- 移動背包物品。
function moveBagItem(playerIndex, fromSlot, targetSlot)
	fromSlot = tonumber(fromSlot) or -1
	targetSlot = tonumber(targetSlot) or -1

	if fromSlot < 8 or fromSlot > 27 or targetSlot < 8 or targetSlot > 27 then
		sendSystemMessage(playerIndex, "移動失敗：槽位無效")

		return
	end

	if fromSlot == targetSlot then
		return
	end

	local value = getInventorySlot(playerIndex, fromSlot)
	local value2 = getInventorySlot(playerIndex, targetSlot)
	local itemIndex = Char.GetItemIndex(playerIndex, value)
	local targetItemIndex = Char.GetItemIndex(playerIndex, value2)

	if not itemIndex or itemIndex < 0 then
		sendSystemMessage(playerIndex, "該格子沒有物品")

		return
	end

	Char.SetItemIndex(playerIndex, value, targetItemIndex)
	Char.SetItemIndex(playerIndex, value2, itemIndex)
	Item.UpItem(playerIndex, value)
	Item.UpItem(playerIndex, value2)
	NLG.UpChar(playerIndex)
	sendBagList(playerIndex)
end

-- 丟棄背包物品並建立地面物品。
function dropBagItem(playerIndex, slot)
	slot = tonumber(slot) or -1

	if slot < 8 or slot > 27 then
		sendSystemMessage(playerIndex, "丟棄失敗：槽位無效")

		return
	end

	local value = getInventorySlot(playerIndex, slot)
	local itemIndex = Char.GetItemIndex(playerIndex, value)

	if not itemIndex or itemIndex < 0 then
		sendSystemMessage(playerIndex, "該格子沒有物品")

		return
	end

	local itemName = Item.GetData(itemIndex, CONST.道具_名字) or "物品"
	local itemId = Item.GetData(itemIndex, CONST.道具_ID) or 0
	local newItemIndex = Item.MakeItem(itemId)

	if newItemIndex < 0 then
		sendSystemMessage(playerIndex, "丟棄失敗：無法創建地面物品")

		return
	end

	for index, index2 in pairs(itemDataFields) do
		Item.SetData(newItemIndex, index2, Item.GetData(itemIndex, index2))
	end

	local enhanceData = Item.GetExtData(itemIndex, "starEnhance")

	if enhanceData and enhanceData ~= "" then
		Item.SetExtData(newItemIndex, "starEnhance", enhanceData)
	end

	local value2 = Char.GetData(playerIndex, CONST.对象_地图) or 0
	local value3 = Char.GetData(playerIndex, CONST.对象_地图层) or 0
	local value4 = Char.GetData(playerIndex, CONST.对象_X) or 0
	local value5 = Char.GetData(playerIndex, CONST.对象_Y) or 0
	local value6 = Obj.AddItem(value2, value3, value4, value5, newItemIndex)
	local flag = false

	if value6 and value6 >= 0 then
		local value7, localValue61_13 = pcall(Obj.GetType, value6)

		flag = value7 and localValue61_13 == 3
	end

	if not flag then
		pcall(Item.UnlinkItem, newItemIndex)
		sendSystemMessage(playerIndex, "丟棄失敗：該位置無法放置物品")

		return
	end

	Char.DelItemBySlot(playerIndex, value)
	Item.UpItem(playerIndex, value)
	NLG.UpChar(playerIndex)
	sendBagList(playerIndex)
	sendSystemMessage(playerIndex, "已丟棄：" .. tostring(itemName))
end

local bankTotalSlots = 200
local bankPageSize = 40
local bankPageCount = 4

function serializeBagItem(itemIndex)
	local data = {}

	for index, index2 in pairs(itemDataFields) do
		data[tostring(index2)] = Item.GetData(itemIndex, index2)
	end

	data.item_name = Item.GetData(itemIndex, CONST.道具_名字)

	ensureEnhanceData(itemIndex, true)

	local value = getEnhanceData(itemIndex)

	if value then
		local flag = false

		for index3, index4 in pairs(value) do
			flag = true

			break
		end

		if flag then
			data._itemExt = value
		end
	end


	local potentialExt = Item.GetExtData(itemIndex, "potentialData")
	if potentialExt and tostring(potentialExt) ~= "" then
		local potentialOK, potentialValue = pcall(JSON.decode, tostring(potentialExt))
		if potentialOK and type(potentialValue) == "table" then data.potential = potentialValue end
	end
	local statBase = ensureStatBaseAttrsForItem(itemIndex)
	if statBase then data._statBaseAttrs = statBase end

	local value2, localValue62_4 = pcall(JSON.encode, data)

	if not value2 then
		return nil
	end

	return localValue62_4
end

-- 將物品資料寫入銀行欄位。
function saveBankItem(playerIndex, slot, itemJson, image, count, level)
	if itemJson then
		local data = {}

		for index = 1, #itemJson, 2000 do
			table.insert(data, string.sub(itemJson, index, index + 1999))
		end

		for index2, index3 in ipairs(data) do
			Char.SetExtData(playerIndex, "xbbank_" .. slot .. "_" .. index2, index3)
		end

		Char.SetExtData(playerIndex, "xbbank_" .. slot .. "_count", #data)
		Char.SetExtData(playerIndex, "xbbank_" .. slot .. "_img", image)
		Char.SetExtData(playerIndex, "xbbank_" .. slot .. "_cnt", count)
		Char.SetExtData(playerIndex, "xbbank_" .. slot .. "_lv", level)

		local value, localValue63_2 = decodeGemItemJson(itemJson)

		Char.SetExtData(playerIndex, "xbbank_" .. slot .. "_gemt", value)
		Char.SetExtData(playerIndex, "xbbank_" .. slot .. "_gems", localValue63_2)
	else
		for index4 = 1, 10 do
			Char.SetExtData(playerIndex, "xbbank_" .. slot .. "_" .. index4, nil)
		end

		Char.SetExtData(playerIndex, "xbbank_" .. slot .. "_count", nil)
		Char.SetExtData(playerIndex, "xbbank_" .. slot .. "_img", nil)
		Char.SetExtData(playerIndex, "xbbank_" .. slot .. "_cnt", nil)
		Char.SetExtData(playerIndex, "xbbank_" .. slot .. "_lv", nil)
		Char.SetExtData(playerIndex, "xbbank_" .. slot .. "_gemt", nil)
		Char.SetExtData(playerIndex, "xbbank_" .. slot .. "_gems", nil)
	end
end

-- 讀取銀行欄位物品資料。
function loadBankItem(playerIndex, slot)
	local itemCount = tonumber(Char.GetExtData(playerIndex, "xbbank_" .. slot .. "_count")) or 0

	if itemCount <= 0 then
		return nil
	end

	local data = {}

	for index = 1, itemCount do
		local value = Char.GetExtData(playerIndex, "xbbank_" .. slot .. "_" .. index)

		if not value then
			return nil
		end

		table.insert(data, value)
	end

	return table.concat(data)
end

-- 解析銀行物品資料。
function getBankItemData(playerIndex)
	local value = 0

	for index = 0, bankTotalSlots - 1 do
		if (tonumber(Char.GetExtData(playerIndex, "xbbank_" .. index .. "_count")) or 0) <= 0 then
			value = value + 1
		end
	end

	return value
end

-- 取得銀行目前頁碼。
function getBankPage(playerIndex)
	local page = tonumber(Char.GetExtData(playerIndex, "xbbank_page")) or 0

	if page < 0 then
		page = 0
	elseif page > bankPageCount then
		page = bankPageCount
	end

	return page
end

-- 整理並傳送銀行列表。
function sendBankList(playerIndex)
	local value = getBankPage(playerIndex)
	local data = {}

	for index = 1, bankPageSize do
		local result = value * bankPageSize + (index - 1)
		local itemImage = tonumber(Char.GetExtData(playerIndex, "xbbank_" .. result .. "_img")) or 0
		local numericValue = tonumber(Char.GetExtData(playerIndex, "xbbank_" .. result .. "_cnt")) or 0
		local itemLevel = tonumber(Char.GetExtData(playerIndex, "xbbank_" .. result .. "_lv")) or 0
		local numericValue2 = tonumber(Char.GetExtData(playerIndex, "xbbank_" .. result .. "_gemt")) or 0
		local numericValue3 = tonumber(Char.GetExtData(playerIndex, "xbbank_" .. result .. "_gems")) or 0

		if numericValue2 == 0 and numericValue3 == 0 and itemImage > 0 and decodeGemItemJson then
			local value2 = loadBankItem(playerIndex, result)

			if value2 then
				numericValue2, numericValue3 = decodeGemItemJson(value2)
			end
		end

		table.insert(data, tostring(itemImage) .. ":" .. tostring(numericValue) .. ":" .. tostring(itemLevel) .. ":" .. tostring(numericValue2) .. ":" .. tostring(numericValue3))
	end

	local value3 = table.concat(data, ",")

	Protocol.Send(playerIndex, "CUSTOMBANK", value3)
end

-- 將背包物品存入銀行。
function depositToBank(playerIndex, slot, page, mode)
	mode = tonumber(mode) or 0

	if mode == 1 then
		slot = tonumber(slot) or -1

		if slot < 0 or slot >= bagTotalSlots then
			sendSystemMessage(playerIndex, "存入銀行失敗：格子無效")

			return
		end

		local value = loadBagItem(playerIndex, slot)

		if not value then
			sendSystemMessage(playerIndex, "該格子沒有物品")

			return
		end

		local value2, localValue68_2 = pcall(JSON.decode, value)
		local result = value2 and localValue68_2 or nil

		if not result or type(result) ~= "table" then
			sendSystemMessage(playerIndex, "背包物品數據損壞，請反饋管理員")

			return
		end

		local value3 = tostring(result.item_name or "物品")
		local value4 = -1

		if page ~= nil then
			local numericValue = tonumber(page) or getBankPage(playerIndex)

			if numericValue < 0 then
				numericValue = 0
			elseif numericValue > bankPageCount then
				numericValue = bankPageCount
			end

			local result2 = numericValue * bankPageSize

			for index = result2, result2 + bankPageSize - 1 do
				if (tonumber(Char.GetExtData(playerIndex, "xbbank_" .. index .. "_count")) or 0) <= 0 then
					value4 = index

					break
				end
			end

			if value4 < 0 then
				sendSystemMessage(playerIndex, "銀行第" .. tostring(numericValue + 1) .. "頁已滿，無法存入：" .. tostring(value3))
				sendBagList(playerIndex)

				return
			end
		else
			for index2 = 0, bankTotalSlots - 1 do
				if (tonumber(Char.GetExtData(playerIndex, "xbbank_" .. index2 .. "_count")) or 0) <= 0 then
					value4 = index2

					break
				end
			end

			if value4 < 0 then
				sendSystemMessage(playerIndex, "銀行已滿，無法存入：" .. tostring(value3))
				sendBagList(playerIndex)

				return
			end
		end

		local value5, localValue68_9, localValue68_10 = getBagItemData(playerIndex, slot)

		saveBankItem(playerIndex, value4, value, value5, localValue68_9, localValue68_10)
		saveBagItem(playerIndex, slot, nil, 0, 0, 0)
		sendBagList(playerIndex)
		sendBankList(playerIndex)
		sendSystemMessage(playerIndex, "已將 " .. tostring(value3) .. " 存入銀行（剩余 " .. tostring(getBankItemData(playerIndex)) .. " 個空位）")

		return
	end

	slot = tonumber(slot) or -1

	if slot < 8 or slot > 27 then
		sendSystemMessage(playerIndex, "存入銀行失敗：槽位無效")

		return
	end

	local value6 = getInventorySlot(playerIndex, slot)
	local itemIndex = Char.GetItemIndex(playerIndex, value6)

	if not itemIndex or itemIndex < 0 then
		sendSystemMessage(playerIndex, "該格子沒有物品")

		return
	end

	local itemName = Item.GetData(itemIndex, CONST.道具_名字) or "物品"
	local value7 = -1

	if page ~= nil then
		local numericValue2 = tonumber(page) or getBankPage(playerIndex)

		if numericValue2 < 0 then
			numericValue2 = 0
		elseif numericValue2 > bankPageCount then
			numericValue2 = bankPageCount
		end

		local result3 = numericValue2 * bankPageSize

		for index3 = result3, result3 + bankPageSize - 1 do
			if (tonumber(Char.GetExtData(playerIndex, "xbbank_" .. index3 .. "_count")) or 0) <= 0 then
				value7 = index3

				break
			end
		end

		if value7 < 0 then
			sendSystemMessage(playerIndex, "銀行第" .. tostring(numericValue2 + 1) .. "頁已滿，無法存入：" .. tostring(itemName))
			sendBagList(playerIndex)

			return
		end
	else
		for index4 = 0, bankTotalSlots - 1 do
			if (tonumber(Char.GetExtData(playerIndex, "xbbank_" .. index4 .. "_count")) or 0) <= 0 then
				value7 = index4

				break
			end
		end

		if value7 < 0 then
			sendSystemMessage(playerIndex, "銀行已滿，無法存入：" .. tostring(itemName))
			sendBagList(playerIndex)

			return
		end
	end

	local value8 = serializeBagItem(itemIndex)

	if not value8 then
		sendSystemMessage(playerIndex, "存入銀行失敗：物品數據異常")

		return
	end

	local numericValue3 = tonumber(Item.GetData(itemIndex, 1) or 0) or 0
	local numericValue4 = tonumber(Item.GetData(itemIndex, CONST.道具_堆叠数) or 0) or 0

	if numericValue4 < 0 then
		numericValue4 = 0
	end

	local value9 = getItemDisplayName(itemIndex)

	saveBankItem(playerIndex, value7, value8, numericValue3, numericValue4, value9)
	Char.DelItemBySlot(playerIndex, value6)
	Item.UpItem(playerIndex, value6)
	NLG.UpChar(playerIndex)
	sendBagList(playerIndex)
	sendBankList(playerIndex)
	sendSystemMessage(playerIndex, "已將 " .. tostring(itemName) .. " 存入銀行（剩余 " .. tostring(getBankItemData(playerIndex)) .. " 個空位）")
end

-- 查詢銀行指定頁內容。
function queryBankPage(playerIndex, page)
	page = tonumber(page) or 0

	if page < 0 then
		page = 0
	elseif page > bankPageCount then
		page = bankPageCount
	end

	Char.SetExtData(playerIndex, "xbbank_page", page)
	sendBankList(playerIndex)
end

-- 整理銀行物品。
function sortBank(playerIndex, page)
	page = tonumber(page) or 0

	if page < 0 then
		page = 0
	elseif page > bankPageCount then
		page = bankPageCount
	end

	Char.SetExtData(playerIndex, "xbbank_page", page)

	local data = {}

	for index = 0, bankTotalSlots - 1 do
		local value = loadBankItem(playerIndex, index)

		if value then
			local value2 = 0
			local value3 = ""
			local value4, localValue70_5 = pcall(JSON.decode, value)

			if value4 and type(localValue70_5) == "table" then
				value2 = tonumber(localValue70_5["0"]) or 0
				value3 = tostring(localValue70_5.item_name or "")
			end

			data[#data + 1] = {
				slot = index,
				jsonStr = value,
				img = tonumber(Char.GetExtData(playerIndex, "xbbank_" .. index .. "_img")) or 0,
				cnt = tonumber(Char.GetExtData(playerIndex, "xbbank_" .. index .. "_cnt")) or 0,
				lv = tonumber(Char.GetExtData(playerIndex, "xbbank_" .. index .. "_lv")) or 0,
				id = value2,
				name = value3
			}
		end
	end

	table.sort(data, function(playerIndex, page)
		if playerIndex.id ~= page.id then
			return playerIndex.id < page.id
		end

		if playerIndex.name ~= page.name then
			return playerIndex.name < page.name
		end

		return playerIndex.slot < page.slot
	end)

	for index2 = 0, bankTotalSlots - 1 do
		saveBankItem(playerIndex, index2, nil, 0, 0, 0)
	end

	for index3, index4 in ipairs(data) do
		saveBankItem(playerIndex, index3 - 1, index4.jsonStr, index4.img, index4.cnt, index4.lv)
	end

	sendBagList(playerIndex)
	sendBankList(playerIndex)
	sendSystemMessage(playerIndex, "銀行已整理：" .. #data .. " 件物品")
end

-- 從銀行取回物品。
function withdrawFromBank(playerIndex, slot, targetPage)
	slot = tonumber(slot) or -1

	if slot < 0 or slot >= bankTotalSlots then
		sendSystemMessage(playerIndex, "取回失敗：銀行格無效")

		return
	end

	local value = loadBankItem(playerIndex, slot)

	if not value then
		sendSystemMessage(playerIndex, "該銀行格沒有物品")

		return
	end

	local value2, localValue72_2 = pcall(JSON.decode, value)
	local result = value2 and localValue72_2 or nil

	if not result or type(result) ~= "table" then
		sendSystemMessage(playerIndex, "銀行物品數據損壞，請反饋管理員")

		return
	end

	local value3 = -1
	local numericValue = tonumber(targetPage) or -1

	if numericValue >= 8 and numericValue <= 27 then
		value3 = getInventorySlot(playerIndex, numericValue)
	else
		for index = 27, 8, -1 do
			local itemIndex = Char.GetItemIndex(playerIndex, getInventorySlot(playerIndex, index))

			if not itemIndex or itemIndex < 0 then
				value3 = getInventorySlot(playerIndex, index)

				break
			end
		end
	end

	if value3 < 0 then
		sendSystemMessage(playerIndex, "背包已滿，無法取回")

		return
	end

	local newItemIndex = Item.MakeItem(tonumber(result["0"]) or 0)

	if newItemIndex < 0 then
		sendSystemMessage(playerIndex, "取回失敗：無法創建物品")

		return
	end

	for index2, index3 in pairs(itemDataFields) do
		local value4 = tostring(index3)

		if result[value4] ~= nil then
			Item.SetData(newItemIndex, index3, result[value4])
		end
	end

	if result.item_name then
		Item.SetData(newItemIndex, CONST.道具_名字, result.item_name)
	end

	if result._itemExt and type(result._itemExt) == "table" then
		local flag = false

		for index4, index5 in pairs(result._itemExt) do
			flag = true

			break
		end

		if flag then
			saveEnhanceData(newItemIndex, result._itemExt)
		else
			ensureEnhanceData(newItemIndex, true)
		end
	else
		ensureEnhanceData(newItemIndex, true)
	end

	-- 銀行取回必須恢復潛能 ExtData 與基礎屬性快照，再重新建構 潛能→寶石→強化。
	if result.potential and type(result.potential) == "table" then
		local potentialOK, potentialEncoded = pcall(JSON.encode, result.potential)
		if potentialOK and potentialEncoded then
			Item.SetExtData(newItemIndex, "potentialData", potentialEncoded)
		end
	end
	if result._statBaseAttrs and type(result._statBaseAttrs) == "table" then
		saveStatBaseExtData(newItemIndex, result._statBaseAttrs)
	end
	rebuildItemStats(playerIndex, newItemIndex, value3)

	local targetPageValue = Char.GetItemIndex(playerIndex, value3)

	if targetPageValue and targetPageValue >= 0 then
		local value5 = serializeBagItem(targetPageValue)

		if not value5 then
			sendSystemMessage(playerIndex, "取回失敗：目標格物品序列化失敗")

			return
		end

		local numericValue2 = tonumber(Item.GetData(targetPageValue, 1) or 0) or 0
		local numericValue3 = tonumber(Item.GetData(targetPageValue, CONST.道具_堆叠数) or 0) or 0

		if numericValue3 < 0 then
			numericValue3 = 0
		end

		local value6 = getItemDisplayName(targetPageValue)

		saveBankItem(playerIndex, slot, value5, numericValue2, numericValue3, value6)
	else
		saveBankItem(playerIndex, slot, nil, 0, 0, 0)
	end

	Char.SetItemIndex(playerIndex, value3, newItemIndex)
	Item.UpItem(playerIndex, value3)
	NLG.UpChar(playerIndex)
	sendBagList(playerIndex)
	sendBankList(playerIndex)
	sendSystemMessage(playerIndex, "已取回：" .. tostring(result.item_name or "物品"))
end

-- 查詢單一銀行物品。
function queryBankItem(playerIndex, slot)
	return tonumber(Char.GetExtData(playerIndex, "xbbank_" .. slot .. "_img")) or 0, tonumber(Char.GetExtData(playerIndex, "xbbank_" .. slot .. "_cnt")) or 0, tonumber(Char.GetExtData(playerIndex, "xbbank_" .. slot .. "_lv")) or 0
end

-- 移動銀行物品。
function moveBankItem(playerIndex, fromSlot, toSlot)
	fromSlot = tonumber(fromSlot) or -1
	toSlot = tonumber(toSlot) or -1

	if fromSlot < 0 or fromSlot >= bankTotalSlots or toSlot < 0 or toSlot >= bankTotalSlots then
		sendSystemMessage(playerIndex, "移動失敗：銀行格無效")

		return
	end

	if fromSlot == toSlot then
		return
	end

	local value = loadBankItem(playerIndex, fromSlot)

	if not value then
		sendSystemMessage(playerIndex, "該銀行格沒有物品")

		return
	end

	local value2 = loadBankItem(playerIndex, toSlot)
	local value3, localValue74_3, localValue74_4 = queryBankItem(playerIndex, fromSlot)
	local value4, localValue74_6, localValue74_7 = queryBankItem(playerIndex, toSlot)

	saveBankItem(playerIndex, fromSlot, value2, value4, localValue74_6, localValue74_7)
	saveBankItem(playerIndex, toSlot, value, value3, localValue74_3, localValue74_4)
	sendBankList(playerIndex)
end

-- 將背包物品移動到銀行。
function moveBagItemToBank(playerIndex, bagSlot, bankSlot)
	bagSlot = tonumber(bagSlot) or -1

	if bagSlot < 0 or bagSlot >= bankTotalSlots then
		sendSystemMessage(playerIndex, "移動失敗：銀行格無效")

		return
	end

	local value = loadBankItem(playerIndex, bagSlot)

	if not value then
		sendSystemMessage(playerIndex, "該銀行格沒有物品")

		return
	end

	bankSlot = tonumber(bankSlot) or 0

	if bankSlot < 0 then
		bankSlot = 0
	elseif bankSlot > bankPageCount then
		bankSlot = bankPageCount
	end

	local value2 = bankSlot * bankPageSize
	local value3 = -1

	for index = value2, value2 + bankPageSize - 1 do
		if (tonumber(Char.GetExtData(playerIndex, "xbbank_" .. index .. "_count")) or 0) <= 0 then
			value3 = index

			break
		end
	end

	if value3 < 0 then
		sendSystemMessage(playerIndex, "銀行第" .. tostring(bankSlot + 1) .. "頁已滿")

		return
	end

	local value4, localValue75_4, localValue75_5 = queryBankItem(playerIndex, bagSlot)

	saveBankItem(playerIndex, value3, value, value4, localValue75_4, localValue75_5)
	saveBankItem(playerIndex, bagSlot, nil, 0, 0, 0)
	sendBankList(playerIndex)
end

-- 將銀行物品移動到指定背包位置。
function moveBankItemToBag(playerIndex, bankSlot)
	bankSlot = tonumber(bankSlot) or -1

	if bankSlot < 1 or bankSlot > bankPageSize then
		return
	end

	local value = getBankPage(playerIndex) * bankPageSize + (bankSlot - 1)
	local value2, localValue76_2, localValue76_3 = queryBankItem(playerIndex, value)
	local value3 = loadBankItem(playerIndex, value)

	if not value3 then
		sendXBProtocol(playerIndex, 3, 0, 0, "", "", "", "", "", "", 0, 0)
		Protocol.Send(playerIndex, "BANKINFO", tostring(bankSlot), "0", "0", "", "", "", "", "")

		return
	end

	local value4, localValue76_6 = pcall(JSON.decode, value3)
	local result = value4 and formatItemDataInfo(localValue76_6) or ""
	local value5, localValue76_9 = getItemDataSetAndGemInfo(playerIndex, localValue76_6)
	sendPotentialCacheXBCENTER(playerIndex, value4 and localValue76_6 or nil)

	Protocol.Send(playerIndex, "BANKINFO", tostring(bankSlot), tostring(value2), tostring(value4 and getItemImage(localValue76_6) or 0), result, value4 and formatItemDataDurability(localValue76_6) or "", value4 and formatItemDataType(localValue76_6) or "", value5, localValue76_9)
end

-- 存放指定背包欄位物品。
function depositBagItem(playerIndex, slot, page)
	slot = tonumber(slot) or -1

	if slot < 8 or slot > 27 then
		sendSystemMessage(playerIndex, "存放失敗：槽位無效")

		return
	end

	page = tonumber(page) or 1

	if page < 1 then
		page = 1
	elseif page > bagPageCount then
		page = bagPageCount
	end

	local value = getInventorySlot(playerIndex, slot)
	local itemIndex = Char.GetItemIndex(playerIndex, value)

	if not itemIndex or itemIndex < 0 then
		sendSystemMessage(playerIndex, "該格子沒有物品")

		return
	end

	local value2 = (page - 1) * bagPageSize
	local value3 = -1

	for index = value2, value2 + bagPageSize - 1 do
		if (tonumber(Char.GetExtData(playerIndex, "xbbag_" .. index .. "_count")) or 0) <= 0 then
			value3 = index

			break
		end
	end

	if value3 < 0 then
		sendSystemMessage(playerIndex, "背包第" .. tostring(page + 1) .. "頁已滿")
		sendBagList(playerIndex)

		return
	end

	local itemName = Item.GetData(itemIndex, CONST.道具_名字) or "物品"
	local value4 = serializeBagItem(itemIndex)

	if not value4 then
		sendSystemMessage(playerIndex, "存放失敗：物品數據異常")

		return
	end

	local numericValue = tonumber(Item.GetData(itemIndex, 1) or 0) or 0
	local numericValue2 = tonumber(Item.GetData(itemIndex, CONST.道具_堆叠数) or 0) or 0

	if numericValue2 < 0 then
		numericValue2 = 0
	end

	local value5 = getItemDisplayName(itemIndex)

	saveBagItem(playerIndex, value3, value4, numericValue, numericValue2, value5)
	Char.DelItemBySlot(playerIndex, value)
	Item.UpItem(playerIndex, value)
	NLG.UpChar(playerIndex)
	sendBagList(playerIndex)
	sendSystemMessage(playerIndex, "已將 " .. tostring(itemName) .. " 存入背包第" .. tostring(page + 1) .. "頁")
end

-- ============================================================================
-- 裝備屬性三層重建：基礎 → 潛能 → 寶石 → 強化
-- ============================================================================
function getStatBaseExtData(itemIndex)
    if not itemIndex or itemIndex < 0 then return nil end
    local raw = Item.GetExtData(itemIndex, "statBaseAttrs")
    if not raw or tostring(raw) == "" then return nil end
    local ok, data = pcall(JSON.decode, tostring(raw))
    return ok and type(data) == "table" and data or nil
end

function saveStatBaseExtData(itemIndex, baseAttrs)
    if not itemIndex or itemIndex < 0 or type(baseAttrs) ~= "table" then return false end
    local ok, encoded = pcall(JSON.encode, baseAttrs)
    if not ok or not encoded then return false end
    Item.SetExtData(itemIndex, "statBaseAttrs", encoded)
    return true
end

function copyStatBaseAttrs(source)
    local result = {}
    if type(source) ~= "table" then return result end
    for _, attrId in ipairs(enhanceTrackedAttributes) do
        local key = tostring(attrId)
        if source[key] ~= nil then result[key] = tonumber(source[key]) or 0 end
    end
    local key = tostring(CONST.道具_最大耐久)
    if source[key] ~= nil then result[key] = tonumber(source[key]) or 0 end
    return result
end

function ensureStatBaseAttrsFromItemData(itemData)
    if type(itemData) ~= "table" then return nil end
    local existing = copyStatBaseAttrs(itemData._statBaseAttrs)
    local complete = true
    for _, attrId in ipairs(enhanceTrackedAttributes) do
        if existing[tostring(attrId)] == nil then complete = false break end
    end
    if existing[tostring(CONST.道具_最大耐久)] == nil then complete = false end
    if complete then itemData._statBaseAttrs = existing return existing end

    local itemType = tonumber(itemData[tostring(CONST.道具_类型)]) or 0
    local isWeapon = itemType >= 0 and itemType <= 6
    local gemId = tonumber(itemData[tostring(isWeapon and CONST.道具_宝石武 or CONST.道具_宝石防)]) or 0
    if not isGemItemId(gemId) then gemId = tonumber(itemData[tostring(isWeapon and CONST.道具_宝石防 or CONST.道具_宝石武)]) or 0 end
    if isGemItemId(gemId) then
        existing = deriveLegacyStatBaseAttrsFromItemData(itemData) or existing
    elseif itemData._itemExt and itemData._itemExt.starEnhance and type(itemData._itemExt.starEnhance.baseAttrs) == "table" then
        existing = copyStatBaseAttrs(itemData._itemExt.starEnhance.baseAttrs)
    end
    if existing[tostring(CONST.道具_最大耐久)] == nil then existing[tostring(CONST.道具_最大耐久)] = tonumber(itemData[tostring(CONST.道具_最大耐久)]) or 0 end
    for _, attrId in ipairs(enhanceTrackedAttributes) do
        local key = tostring(attrId)
        if existing[key] == nil then existing[key] = tonumber(itemData[key]) or 0 end
    end
    itemData._statBaseAttrs = existing
    return existing
end

function deriveLegacyStatBaseAttrsFromItem(itemIndex)
    if not itemIndex or itemIndex < 0 then return nil end
    local base = {}
    for _, attrId in ipairs(enhanceTrackedAttributes) do
        base[tostring(attrId)] = tonumber(Item.GetData(itemIndex, attrId)) or 0
    end
    base[tostring(CONST.道具_最大耐久)] = tonumber(Item.GetData(itemIndex, CONST.道具_最大耐久)) or 0

    local enhanceData = getEnhanceData(itemIndex)
    local enhanceLevel = enhanceData and enhanceData.starEnhance and tonumber(enhanceData.starEnhance.level) or 0
    local enhanceBonus = enhanceAttributeBonus[enhanceLevel] or 0
    if enhanceBonus ~= 0 then
        for _, attrId in ipairs(enhanceTrackedAttributes) do
            local key = tostring(attrId)
            base[key] = roundNumber((tonumber(base[key]) or 0) * 100 / (100 + enhanceBonus))
        end
    end

    local itemType = tonumber(Item.GetData(itemIndex, CONST.道具_类型)) or 0
    local isWeapon = itemType >= 0 and itemType <= 6
    local gemId = getItemGemId(itemIndex)
    if isGemItemId(gemId) then
        local materialId = getGemMaterialId(gemId, isWeapon)
        local effects = gemMaterialEffects[materialId]
        local order = isWeapon and {1,2,3,4,5,6,7,8,9,10,11,12} or {1,3,2,4,5,6,8,7,10,9,11,12}
        local attrIds = isWeapon and {CONST.道具_最大耐久,CONST.道具_攻击,CONST.道具_防御,CONST.道具_敏捷,CONST.道具_精神,CONST.道具_回复,CONST.道具_必杀,CONST.道具_反击,CONST.道具_命中,CONST.道具_闪躲,CONST.道具_生命,CONST.道具_魔力} or {CONST.道具_最大耐久,CONST.道具_防御,CONST.道具_攻击,CONST.道具_敏捷,CONST.道具_精神,CONST.道具_回复,CONST.道具_反击,CONST.道具_必杀,CONST.道具_闪躲,CONST.道具_命中,CONST.道具_生命,CONST.道具_魔力}
        if effects then
            for index = 1, 12 do
                local effect = effects[order[index]]
                local attrId = attrIds[index]
                if effect and attrId and effect.val ~= 0 then
                    local key = tostring(attrId)
                    local current = tonumber(base[key]) or 0
                    if effect.flag == 1 then
                        base[key] = current - effect.val
                    else
                        base[key] = roundNumber(current / (1 + effect.val / 100))
                    end
                end
            end
        end
    end

    return base
end

function deriveLegacyStatBaseAttrsFromItemData(itemData)
    if type(itemData) ~= "table" then return nil end
    local base = {}
    for _, attrId in ipairs(enhanceTrackedAttributes) do
        base[tostring(attrId)] = tonumber(itemData[tostring(attrId)]) or 0
    end
    base[tostring(CONST.道具_最大耐久)] = tonumber(itemData[tostring(CONST.道具_最大耐久)]) or 0

    local enhanceLevel = 0
    if itemData._itemExt and itemData._itemExt.starEnhance then enhanceLevel = tonumber(itemData._itemExt.starEnhance.level) or 0 end
    local enhanceBonus = enhanceAttributeBonus[enhanceLevel] or 0
    if enhanceBonus ~= 0 then
        for _, attrId in ipairs(enhanceTrackedAttributes) do
            local key = tostring(attrId)
            base[key] = roundNumber((tonumber(base[key]) or 0) * 100 / (100 + enhanceBonus))
        end
    end

    local itemType = tonumber(itemData[tostring(CONST.道具_类型)]) or 0
    local isWeapon = itemType >= 0 and itemType <= 6
    local gemId = tonumber(itemData[tostring(isWeapon and CONST.道具_宝石武 or CONST.道具_宝石防)]) or 0
    if not isGemItemId(gemId) then
        gemId = tonumber(itemData[tostring(isWeapon and CONST.道具_宝石防 or CONST.道具_宝石武)]) or 0
    end
    if isGemItemId(gemId) then
        local materialId = getGemMaterialId(gemId, isWeapon)
        local effects = gemMaterialEffects[materialId]
        local order = isWeapon and {1,2,3,4,5,6,7,8,9,10,11,12} or {1,3,2,4,5,6,8,7,10,9,11,12}
        local attrIds = isWeapon and {CONST.道具_最大耐久,CONST.道具_攻击,CONST.道具_防御,CONST.道具_敏捷,CONST.道具_精神,CONST.道具_回复,CONST.道具_必杀,CONST.道具_反击,CONST.道具_命中,CONST.道具_闪躲,CONST.道具_生命,CONST.道具_魔力} or {CONST.道具_最大耐久,CONST.道具_防御,CONST.道具_攻击,CONST.道具_敏捷,CONST.道具_精神,CONST.道具_回复,CONST.道具_反击,CONST.道具_必杀,CONST.道具_闪躲,CONST.道具_命中,CONST.道具_生命,CONST.道具_魔力}
        if effects then
            for index = 1, 12 do
                local effect = effects[order[index]]
                local attrId = attrIds[index]
                if effect and attrId and effect.val ~= 0 then
                    local key = tostring(attrId)
                    local current = tonumber(base[key]) or 0
                    if effect.flag == 1 then base[key] = current - effect.val
                    else base[key] = roundNumber(current / (1 + effect.val / 100)) end
                end
            end
        end
    end
    return base
end

function ensureStatBaseAttrsForItem(itemIndex)
    local existing = getStatBaseExtData(itemIndex)
    if existing then return existing end

    local itemData = {}
    for _, attrId in ipairs(enhanceTrackedAttributes) do itemData[tostring(attrId)] = tonumber(Item.GetData(itemIndex, attrId)) or 0 end
    itemData[tostring(CONST.道具_最大耐久)] = tonumber(Item.GetData(itemIndex, CONST.道具_最大耐久)) or 0
    itemData[tostring(CONST.道具_类型)] = tonumber(Item.GetData(itemIndex, CONST.道具_类型)) or 0
    itemData[tostring(CONST.道具_宝石武)] = tonumber(Item.GetData(itemIndex, CONST.道具_宝石武)) or 0
    itemData[tostring(CONST.道具_宝石防)] = tonumber(Item.GetData(itemIndex, CONST.道具_宝石防)) or 0

    local enhanceData = getEnhanceData(itemIndex)
    if enhanceData then itemData._itemExt = enhanceData end
    local base = ensureStatBaseAttrsFromItemData(itemData)
    saveStatBaseExtData(itemIndex, base)
    return base
end

local potentialAttributeMap = {
    ["攻擊"] = CONST.道具_攻击, ["攻击"] = CONST.道具_攻击,
    ["防禦"] = CONST.道具_防御, ["防御"] = CONST.道具_防御,
    ["敏捷"] = CONST.道具_敏捷, ["精神"] = CONST.道具_精神,
    ["回復"] = CONST.道具_回复, ["回复"] = CONST.道具_回复,
    ["生命"] = CONST.道具_生命, ["生命值"] = CONST.道具_生命,
    ["魔力"] = CONST.道具_魔力, ["魔力值"] = CONST.道具_魔力,
    ["耐力"] = CONST.道具_耐力, ["靈巧"] = CONST.道具_灵巧, ["灵巧"] = CONST.道具_灵巧,
    ["智力"] = CONST.道具_智力, ["必殺"] = CONST.道具_必杀, ["必杀"] = CONST.道具_必杀,
    ["反擊"] = CONST.道具_反击, ["反击"] = CONST.道具_反击, ["命中"] = CONST.道具_命中,
    ["閃躲"] = CONST.道具_闪躲, ["闪躲"] = CONST.道具_闪躲,
    ["毒抗"] = CONST.道具_毒抗, ["睡抗"] = CONST.道具_睡抗, ["石抗"] = CONST.道具_石抗,
    ["醉抗"] = CONST.道具_醉抗, ["亂抗"] = CONST.道具_乱抗, ["乱抗"] = CONST.道具_乱抗,
    ["忘抗"] = CONST.道具_忘抗, ["魔抗"] = CONST.道具_魔抗, ["魔攻"] = CONST.道具_魔攻,
}

function applyPotentialEffectList(itemData, effects)
    if type(effects) ~= "table" then return end
    for _, effectText in ipairs(effects) do
        local attrName, sign, amountText, percent = string.match(tostring(effectText or ""), "^%s*(.-)%s*([+-])%s*(%d+)%s*(%%?)%s*$")
        local attrId = potentialAttributeMap[attrName or ""]
        local amount = tonumber(amountText) or 0
        if attrId and amount > 0 then
            if sign == "-" then amount = -amount end
            local key = tostring(attrId)
            local current = tonumber(itemData[key]) or 0
            if percent == "%" then
                itemData[key] = roundNumber(current * (1 + amount / 100))
            else
                itemData[key] = current + amount
            end
        end
    end
end

function rebuildItemDataStats(itemData)
    if type(itemData) ~= "table" then return false end
    local base = ensureStatBaseAttrsFromItemData(itemData)
    if not base then return false end
    for _, attrId in ipairs(enhanceTrackedAttributes) do
        local key = tostring(attrId)
        itemData[key] = tonumber(base[key]) or 0
    end
    itemData[tostring(CONST.道具_最大耐久)] = tonumber(base[tostring(CONST.道具_最大耐久)]) or 0

    local p = potentialEnsureData(itemData)
    if p and p.mainOpened then applyPotentialEffectList(itemData, p.mainEffects) end
    if p and p.addOpened then applyPotentialEffectList(itemData, p.addEffects) end

    local itemType = tonumber(itemData[tostring(CONST.道具_类型)]) or 0
    local isWeapon = itemType >= 0 and itemType <= 6
    local gemKey = isWeapon and CONST.道具_宝石武 or CONST.道具_宝石防
    local gemId = tonumber(itemData[tostring(gemKey)]) or 0
    if not isGemItemId(gemId) then
        local otherKey = isWeapon and CONST.道具_宝石防 or CONST.道具_宝石武
        gemId = tonumber(itemData[tostring(otherKey)]) or 0
    end
    if isGemItemId(gemId) then
        local materialId = getGemMaterialId(gemId, isWeapon)
        applyGemEffects(itemData, materialId, isWeapon, false)
    end

    local enhanceLevel = 0
    if itemData._itemExt and itemData._itemExt.starEnhance then
        enhanceLevel = math.max(0, math.min(maxEnhanceLevel, tonumber(itemData._itemExt.starEnhance.level) or 0))
    end
    local enhanceBonus = enhanceAttributeBonus[enhanceLevel] or 0
    if enhanceBonus ~= 0 then
        for _, attrId in ipairs(enhanceTrackedAttributes) do
            local key = tostring(attrId)
            itemData[key] = roundNumber((tonumber(itemData[key]) or 0) * (100 + enhanceBonus) / 100)
        end
    end

    local maxDurability = tonumber(itemData[tostring(CONST.道具_最大耐久)]) or 0
    local durability = tonumber(itemData[tostring(CONST.道具_耐久)]) or 0
    if maxDurability > 0 and durability > maxDurability then itemData[tostring(CONST.道具_耐久)] = maxDurability end

    local baseName = itemData.item_name or ""
    if itemData._itemExt and itemData._itemExt.starEnhance and itemData._itemExt.starEnhance.baseName then baseName = itemData._itemExt.starEnhance.baseName end
    if baseName ~= "" then
        itemData.item_name = baseName .. (enhanceLevel > 0 and string.format("+%d", enhanceLevel) or "")
        itemData[tostring(CONST.道具_名字)] = itemData.item_name
    end
    return true
end

function rebuildItemStats(playerIndex, itemIndex, slot)
    if not itemIndex or itemIndex < 0 then return false end
    local data = {}
    for _, attrId in pairs(itemDataFields) do data[tostring(attrId)] = Item.GetData(itemIndex, attrId) end
    data.item_name = Item.GetData(itemIndex, CONST.道具_名字)
    ensureEnhanceData(itemIndex, true)
    local enhanceData = getEnhanceData(itemIndex)
    if enhanceData then data._itemExt = enhanceData end
    local potentialExt = Item.GetExtData(itemIndex, "potentialData")
    if potentialExt and tostring(potentialExt) ~= "" then
        local ok, p = pcall(JSON.decode, tostring(potentialExt))
        if ok and type(p) == "table" then data.potential = p end
    end
    local statBase = ensureStatBaseAttrsForItem(itemIndex)
    if statBase then data._statBaseAttrs = statBase end
    if not rebuildItemDataStats(data) then return false end
    for _, attrId in ipairs(enhanceTrackedAttributes) do Item.SetData(itemIndex, attrId, tonumber(data[tostring(attrId)]) or 0) end
    Item.SetData(itemIndex, CONST.道具_最大耐久, tonumber(data[tostring(CONST.道具_最大耐久)]) or 0)
    if data[tostring(CONST.道具_耐久)] ~= nil then Item.SetData(itemIndex, CONST.道具_耐久, tonumber(data[tostring(CONST.道具_耐久)]) or 0) end
    if data.item_name then Item.SetData(itemIndex, CONST.道具_名字, data.item_name) end
    if data._statBaseAttrs then saveStatBaseExtData(itemIndex, data._statBaseAttrs) end
    if data.potential then
        local ok, encoded = pcall(JSON.encode, data.potential)
        if ok and encoded then Item.SetExtData(itemIndex, "potentialData", encoded) end
    end
    if slot ~= nil then Item.UpItem(playerIndex, tonumber(slot) or 0) end
    NLG.UpChar(playerIndex)
    return true
end

-- 依序列化資料建立實體道具。
function createItemFromData(playerIndex, itemData, targetSlot)
	local newItemIndex = Item.MakeItem(tonumber(itemData["0"]) or 0)

	if newItemIndex < 0 then
		newItemIndex = Item.MakeItem(0)
	end

	if newItemIndex < 0 then
		return -1
	end

	for index, index2 in pairs(itemDataFields) do
		local value = tostring(index2)

		if itemData[value] ~= nil then
			Item.SetData(newItemIndex, index2, itemData[value])
		end
	end

	if itemData.item_name then
		Item.SetData(newItemIndex, CONST.道具_名字, itemData.item_name)
	end

	if itemData._itemExt and type(itemData._itemExt) == "table" then
		local flag = false

		for index3, index4 in pairs(itemData._itemExt) do
			flag = true

			break
		end

		if flag then
			saveEnhanceData(newItemIndex, itemData._itemExt)
		else
			ensureEnhanceData(newItemIndex, true)
		end
	else
		ensureEnhanceData(newItemIndex, true)
	end

	-- 取回/重建物品時同步恢復潛能 ExtData。
	if itemData.potential and type(itemData.potential) == "table" then
		local potentialOK, potentialEncoded = pcall(JSON.encode, itemData.potential)
		if potentialOK and potentialEncoded then
			Item.SetExtData(newItemIndex, "potentialData", potentialEncoded)
		end
	end
	if itemData._statBaseAttrs and type(itemData._statBaseAttrs) == "table" then
		saveStatBaseExtData(newItemIndex, itemData._statBaseAttrs)
	end

	Char.SetItemIndex(playerIndex, targetSlot, newItemIndex)
	Item.UpItem(playerIndex, targetSlot)
	-- 重建完整屬性：基礎 → 潛能 → 寶石 → 強化。
	rebuildItemStats(playerIndex, newItemIndex, targetSlot)
	NLG.UpChar(playerIndex)

	return newItemIndex
end

function takeStoredBagItem(playerIndex, slot)
	slot = tonumber(slot) or -1

	if slot < 0 or slot >= bagTotalSlots then
		sendSystemMessage(playerIndex, "取出失敗：格子無效")

		return nil
	end

	local value = loadBagItem(playerIndex, slot)

	if not value then
		sendSystemMessage(playerIndex, "該格子沒有物品")

		return nil
	end

	local value2, localValue79_2 = pcall(JSON.decode, value)
	local result = value2 and localValue79_2 or nil

	if not result or type(result) ~= "table" then
		sendSystemMessage(playerIndex, "背包物品數據損壞，請反饋管理員")

		return nil
	end

	local value3 = -1

	for index = 27, 8, -1 do
		local itemIndex = Char.GetItemIndex(playerIndex, getInventorySlot(playerIndex, index))

		if not itemIndex or itemIndex < 0 then
			value3 = getInventorySlot(playerIndex, index)

			break
		end
	end

	if value3 < 0 then
		sendSystemMessage(playerIndex, "背包已滿，無法取出")

		return nil
	end

	if createItemFromData(playerIndex, result, value3) < 0 then
		sendSystemMessage(playerIndex, "取出失敗：無法創建物品")

		return nil
	end

	saveBagItem(playerIndex, slot, nil, 0, 0, 0)

	return value3
end

-- 從暫存欄位取回物品。
function withdrawBagItem(playerIndex, slot)
	slot = tonumber(slot) or -1

	if slot < 0 or slot >= bagTotalSlots then
		sendSystemMessage(playerIndex, "取回失敗：格子無效")

		return
	end

	local value = loadBagItem(playerIndex, slot)

	if not value then
		sendSystemMessage(playerIndex, "該格子沒有物品")

		return
	end

	local value2, localValue80_2 = pcall(JSON.decode, value)
	local result = value2 and localValue80_2 or nil

	if not result or type(result) ~= "table" then
		sendSystemMessage(playerIndex, "背包物品數據損壞，請反饋管理員")

		return
	end

	local value3 = -1

	for index = 27, 8, -1 do
		local itemIndex = Char.GetItemIndex(playerIndex, getInventorySlot(playerIndex, index))

		if not itemIndex or itemIndex < 0 then
			value3 = getInventorySlot(playerIndex, index)

			break
		end
	end

	if value3 < 0 then
		sendSystemMessage(playerIndex, "背包已滿，無法取回")

		return
	end

	if createItemFromData(playerIndex, result, value3) < 0 then
		sendSystemMessage(playerIndex, "取回失敗：無法創建物品")

		return
	end

	saveBagItem(playerIndex, slot, nil, 0, 0, 0)
	sendBagList(playerIndex)
	sendSystemMessage(playerIndex, "已取回：" .. tostring(result.item_name or "物品"))
end

-- 整理背包中的物品。
function sortBagItems(playerIndex)
	local data = {}

	for index = 8, 27 do
		local value = getInventorySlot(playerIndex, index)
		local itemIndex = Char.GetItemIndex(playerIndex, value)

		if itemIndex and itemIndex >= 0 then
			local value2 = serializeBagItem(itemIndex)

			if value2 then
				local numericValue = tonumber(Item.GetData(itemIndex, 0) or 0) or 0
				local itemName = tostring(Item.GetData(itemIndex, CONST.道具_名字) or "")
				local numericValue2 = tonumber(Item.GetData(itemIndex, 1) or 0) or 0
				local numericValue3 = tonumber(Item.GetData(itemIndex, CONST.道具_堆叠数) or 0) or 0

				if numericValue3 < 0 then
					numericValue3 = 0
				end

				local itemType = tonumber(Item.GetData(itemIndex, CONST.道具_类型)) or 999

				data[#data + 1] = {
					kind = "real",
					slot = index,
					id = numericValue,
					name = itemName,
					type = itemType,
					jsonStr = value2,
					img = numericValue2,
					cnt = numericValue3,
					lv = getItemDisplayName(itemIndex)
				}
			end
		end
	end

	for index2 = 0, bagTotalSlots - 1 do
		local value3 = loadBagItem(playerIndex, index2)

		if value3 then
			local value4 = 0
			local value5 = ""
			local value6 = 999
			local value7, localValue81_14 = pcall(JSON.decode, value3)

			if value7 and type(localValue81_14) == "table" then
				value4 = tonumber(localValue81_14["0"]) or 0
				value5 = tostring(localValue81_14.item_name or "")
				value6 = tonumber(localValue81_14[tostring(CONST.道具_类型)]) or 999
			end

			local value8, localValue81_16, localValue81_17 = getBagItemData(playerIndex, index2)

			data[#data + 1] = {
				kind = "vbag",
				slot = index2,
				id = value4,
				name = value5,
				type = value6,
				jsonStr = value3,
				img = value8,
				cnt = localValue81_16,
				lv = localValue81_17
			}
		end
	end

	table.sort(data, function(playerIndex, slot)
		if playerIndex.type ~= slot.type then
			return playerIndex.type < slot.type
		end

		if playerIndex.id ~= slot.id then
			return playerIndex.id < slot.id
		end

		return playerIndex.slot < slot.slot
	end)

	for index3 = 8, 27 do
		local value9 = getInventorySlot(playerIndex, index3)

		if Char.GetItemIndex(playerIndex, value9) then
			Char.DelItemBySlot(playerIndex, value9)
			Item.UpItem(playerIndex, value9)
		end
	end

	for index4 = 0, bagTotalSlots - 1 do
		saveBagItem(playerIndex, index4, nil, 0, 0, 0)
	end

	local value10 = 8
	local value11 = 0
	local value12 = 0

	for index5, index6 in ipairs(data) do
		if value10 <= 27 then
			local value13, localValue81_23 = pcall(JSON.decode, index6.jsonStr)

			if value13 and type(localValue81_23) == "table" and createItemFromData(playerIndex, localValue81_23, getInventorySlot(playerIndex, value10)) >= 0 then
				value10 = value10 + 1
			elseif value11 < bagTotalSlots then
				saveBagItem(playerIndex, value11, index6.jsonStr, index6.img, index6.cnt, index6.lv)

				value11 = value11 + 1
			else
				value12 = value12 + 1
			end
		elseif value11 < bagTotalSlots then
			saveBagItem(playerIndex, value11, index6.jsonStr, index6.img, index6.cnt, index6.lv)

			value11 = value11 + 1
		else
			value12 = value12 + 1
		end
	end

	NLG.UpChar(playerIndex)
	sendBagList(playerIndex)
	sendSystemMessage(playerIndex, "背包整理完成：" .. tostring(#data) .. " 件物品")
end

-- 在背包內移動物品。
function moveBagSlot(playerIndex, fromSlot, toSlot)
	fromSlot = tonumber(fromSlot) or -1
	toSlot = tonumber(toSlot) or -1

	if fromSlot < 0 or fromSlot >= bagTotalSlots or toSlot < 0 or toSlot >= bagTotalSlots then
		sendSystemMessage(playerIndex, "移動失敗：格子無效")

		return
	end

	if fromSlot == toSlot then
		return
	end

	local value = loadBagItem(playerIndex, fromSlot)

	if not value then
		sendSystemMessage(playerIndex, "該格子沒有物品")

		return
	end

	local value2 = loadBagItem(playerIndex, toSlot)
	local value3, localValue83_3, localValue83_4 = getBagItemData(playerIndex, fromSlot)
	local value4, localValue83_6, localValue83_7 = getBagItemData(playerIndex, toSlot)

	saveBagItem(playerIndex, fromSlot, value2, value4, localValue83_6, localValue83_7)
	saveBagItem(playerIndex, toSlot, value, value3, localValue83_3, localValue83_4)
	sendBagList(playerIndex)
end

-- 跨背包頁移動物品。
function moveBagPageSlot(playerIndex, fromSlot, targetSlot, fromPage)
	local value = bagPageCount + 1

	fromSlot = tonumber(fromSlot) or 1

	if fromSlot < 1 then
		fromSlot = 1
	elseif value < fromSlot then
		fromSlot = value
	end

	fromPage = tonumber(fromPage) or 1

	if fromPage < 1 then
		fromPage = 1
	elseif value < fromPage then
		fromPage = value
	end

	if fromSlot == fromPage then
		sendSystemMessage(playerIndex, "該物品已在背包第" .. tostring(fromPage) .. "頁")

		return
	end

	targetSlot = tonumber(targetSlot) or -1

	if fromSlot <= 1 then
		if targetSlot < 8 or targetSlot > 27 then
			sendSystemMessage(playerIndex, "移動失敗：槽位無效")

			return
		end

		local value2 = getInventorySlot(playerIndex, targetSlot)
		local itemIndex = Char.GetItemIndex(playerIndex, value2)

		if not itemIndex or itemIndex < 0 then
			sendSystemMessage(playerIndex, "該格子沒有物品")

			return
		end

		local value3 = (fromPage - 2) * bagPageSize
		local value4 = -1

		for index = value3, value3 + bagPageSize - 1 do
			if (tonumber(Char.GetExtData(playerIndex, "xbbag_" .. index .. "_count")) or 0) <= 0 then
				value4 = index

				break
			end
		end

		if value4 < 0 then
			sendSystemMessage(playerIndex, "背包第" .. tostring(fromPage) .. "頁已滿")
			sendBagList(playerIndex)

			return
		end

		local itemName = Item.GetData(itemIndex, CONST.道具_名字) or "物品"
		local value5 = serializeBagItem(itemIndex)

		if not value5 then
			sendSystemMessage(playerIndex, "移動失敗：物品數據異常")

			return
		end

		local numericValue = tonumber(Item.GetData(itemIndex, 1) or 0) or 0
		local numericValue2 = tonumber(Item.GetData(itemIndex, CONST.道具_堆叠数) or 0) or 0

		if numericValue2 < 0 then
			numericValue2 = 0
		end

		local value6 = getItemDisplayName(itemIndex)

		saveBagItem(playerIndex, value4, value5, numericValue, numericValue2, value6)
		Char.DelItemBySlot(playerIndex, value2)
		Item.UpItem(playerIndex, value2)
		NLG.UpChar(playerIndex)
		sendBagList(playerIndex)
		sendSystemMessage(playerIndex, "已將 " .. tostring(itemName) .. " 移到背包第" .. tostring(fromPage) .. "頁")

		return
	end

	if targetSlot < 0 or targetSlot >= bagTotalSlots then
		sendSystemMessage(playerIndex, "移動失敗：格子無效")

		return
	end

	local value7 = loadBagItem(playerIndex, targetSlot)

	if not value7 then
		sendSystemMessage(playerIndex, "該格子沒有物品")

		return
	end

	if fromPage <= 1 then
		local value8 = -1

		for index2 = 27, 8, -1 do
			local targetItemIndex = Char.GetItemIndex(playerIndex, getInventorySlot(playerIndex, index2))

			if not targetItemIndex or targetItemIndex < 0 then
				value8 = getInventorySlot(playerIndex, index2)

				break
			end
		end

		if value8 < 0 then
			sendSystemMessage(playerIndex, "背包已滿，無法移動")

			return
		end

		local value9, localValue84_14 = pcall(JSON.decode, value7)

		if not value9 or type(localValue84_14) ~= "table" then
			sendSystemMessage(playerIndex, "背包物品數據損壞，請反饋管理員")

			return
		end

		if createItemFromData(playerIndex, localValue84_14, value8) < 0 then
			sendSystemMessage(playerIndex, "移動失敗：無法創建物品")

			return
		end

		saveBagItem(playerIndex, targetSlot, nil, 0, 0, 0)
		sendBagList(playerIndex)
		sendSystemMessage(playerIndex, "已將 " .. tostring(localValue84_14.item_name or "物品") .. " 移到背包第1頁")

		return
	end

	local value10 = (fromPage - 2) * bagPageSize
	local value11 = -1

	for index3 = value10, value10 + bagPageSize - 1 do
		if (tonumber(Char.GetExtData(playerIndex, "xbbag_" .. index3 .. "_count")) or 0) <= 0 then
			value11 = index3

			break
		end
	end

	if value11 < 0 then
		sendSystemMessage(playerIndex, "背包第" .. tostring(fromPage) .. "頁已滿")
		sendBagList(playerIndex)

		return
	end

	local value12, localValue84_18, localValue84_19 = getBagItemData(playerIndex, targetItemIndex)

	saveBagItem(playerIndex, targetSlot, nil, 0, 0, 0)
	saveBagItem(playerIndex, value11, value7, value12, localValue84_18, localValue84_19)
	sendBagList(playerIndex)

	local value13, localValue84_21 = pcall(JSON.decode, value7)

	sendSystemMessage(playerIndex, "已將 " .. tostring(value13 and localValue84_21.item_name or "物品") .. " 移到背包第" .. tostring(fromPage) .. "頁")
end

-- 在銀行內移動物品。
function moveBankSlot(playerIndex, fromSlot, toSlot)
	fromSlot = tonumber(fromSlot) or -1
	toSlot = tonumber(toSlot) or -1

	if fromSlot < 0 or fromSlot >= bankTotalSlots then
		sendSystemMessage(playerIndex, "存放失敗：銀行格無效")

		return
	end

	if toSlot < 0 or toSlot >= bagTotalSlots then
		sendSystemMessage(playerIndex, "存放失敗：背包格無效")

		return
	end

	local value = loadBankItem(playerIndex, fromSlot)

	if not value then
		sendSystemMessage(playerIndex, "該銀行格沒有物品")

		return
	end

	local value2, localValue85_2, localValue85_3 = queryBankItem(playerIndex, fromSlot)
	local value3 = loadBagItem(playerIndex, toSlot)
	local value4, localValue85_6, localValue85_7 = getBagItemData(playerIndex, toSlot)

	saveBankItem(playerIndex, fromSlot, value3, value4, localValue85_6, localValue85_7)
	saveBagItem(playerIndex, toSlot, value, value2, localValue85_2, localValue85_3)

	local value5, localValue85_9 = pcall(JSON.decode, value)
	local result = value5 and localValue85_9 and localValue85_9.item_name or "物品"

	sendBankList(playerIndex)
	sendBagList(playerIndex)
	sendSystemMessage(playerIndex, "已將 " .. tostring(result) .. " 存入背包第" .. tostring(math.floor(toSlot / bagPageSize) + 2) .. "頁")
end

-- 跨銀行頁移動物品。
function moveBankPageSlot(playerIndex, fromSlot, toSlot, fromPage)
	fromPage = tonumber(fromPage) or 0
	toSlot = tonumber(toSlot) or -1

	if toSlot < 0 or toSlot >= bankTotalSlots then
		sendSystemMessage(playerIndex, "存放失敗：銀行格無效")

		return
	end

	if fromPage == 1 then
		fromSlot = tonumber(fromSlot) or -1

		if fromSlot < 0 or fromSlot >= bagTotalSlots then
			sendSystemMessage(playerIndex, "存放失敗：背包格無效")

			return
		end

		local value = loadBagItem(playerIndex, fromSlot)

		if not value then
			sendSystemMessage(playerIndex, "該格子沒有物品")

			return
		end

		local value2, localValue86_2, localValue86_3 = getBagItemData(playerIndex, fromSlot)
		local value3 = loadBankItem(playerIndex, toSlot)
		local value4, localValue86_6, localValue86_7 = queryBankItem(playerIndex, toSlot)

		saveBagItem(playerIndex, fromSlot, value3, value4, localValue86_6, localValue86_7)
		saveBankItem(playerIndex, toSlot, value, value2, localValue86_2, localValue86_3)

		local value5, localValue86_9 = pcall(JSON.decode, value)
		local result = value5 and localValue86_9 and localValue86_9.item_name or "物品"

		sendBankList(playerIndex)
		sendBagList(playerIndex)
		sendSystemMessage(playerIndex, "已將 " .. tostring(result) .. " 存入銀行")

		return
	end

	fromSlot = tonumber(fromSlot) or -1

	if fromSlot < 8 or fromSlot > 27 then
		sendSystemMessage(playerIndex, "存放失敗：背包格無效")

		return
	end

	local value6 = getInventorySlot(playerIndex, fromSlot)
	local itemIndex = Char.GetItemIndex(playerIndex, value6)

	if not itemIndex or itemIndex < 0 then
		sendSystemMessage(playerIndex, "該格子沒有物品")

		return
	end

	local itemName = Item.GetData(itemIndex, CONST.道具_名字) or "物品"
	local value7 = serializeBagItem(itemIndex)

	if not value7 then
		sendSystemMessage(playerIndex, "存放失敗：物品數據異常")

		return
	end

	local numericValue = tonumber(Item.GetData(itemIndex, 1) or 0) or 0
	local numericValue2 = tonumber(Item.GetData(itemIndex, CONST.道具_堆叠数) or 0) or 0

	if numericValue2 < 0 then
		numericValue2 = 0
	end

	local value8 = getItemDisplayName(itemIndex)
	local value9 = loadBankItem(playerIndex, toSlot)

	if value9 then
		local value10, localValue86_20 = pcall(JSON.decode, value9)

		if not value10 or type(localValue86_20) ~= "table" then
			sendSystemMessage(playerIndex, "存放失敗：目標格數據異常")

			return
		end

		Char.DelItemBySlot(playerIndex, value6)
		Item.UpItem(playerIndex, value6)

		if createItemFromData(playerIndex, localValue86_20, value6) < 0 then
			saveBankItem(playerIndex, toSlot, value7, numericValue, numericValue2, value8)
			NLG.UpChar(playerIndex)
			sendBankList(playerIndex)
			sendBagList(playerIndex)
			sendSystemMessage(playerIndex, "已將 " .. tostring(itemName) .. " 存入銀行")

			return
		end
	else
		Char.DelItemBySlot(playerIndex, value6)
		Item.UpItem(playerIndex, value6)
	end

	saveBankItem(playerIndex, toSlot, value7, numericValue, numericValue2, value8)
	NLG.UpChar(playerIndex)
	sendBankList(playerIndex)
	sendBagList(playerIndex)
	sendSystemMessage(playerIndex, "已將 " .. tostring(itemName) .. " 存入銀行")
end

-- 刪除背包指定物品。
function deleteBagItem(playerIndex, slot, itemIndex2)
	itemIndex2 = tonumber(itemIndex2) or 0

	if itemIndex2 == 1 then
		slot = tonumber(slot) or -1

		if slot < 0 or slot >= bagTotalSlots then
			sendSystemMessage(playerIndex, "刪除失敗：槽位無效")

			return
		end

		local value = loadBagItem(playerIndex, slot)

		if not value then
			sendSystemMessage(playerIndex, "該格子沒有物品")

			return
		end

		local value2, localValue87_2 = pcall(JSON.decode, value)
		local result = value2 and localValue87_2 and localValue87_2.item_name or "物品"

		saveBagItem(playerIndex, slot, nil, 0, 0, 0)
		sendBagList(playerIndex)
		sendSystemMessage(playerIndex, "已刪除：" .. tostring(result))

		return
	end

	if itemIndex2 == 2 then
		slot = tonumber(slot) or -1

		if slot < 0 or slot >= bankTotalSlots then
			sendSystemMessage(playerIndex, "刪除失敗：槽位無效")

			return
		end

		local value3 = loadBankItem(playerIndex, slot)

		if not value3 then
			sendSystemMessage(playerIndex, "該格子沒有物品")

			return
		end

		local value4, localValue87_6 = pcall(JSON.decode, value3)
		local result2 = value4 and localValue87_6 and localValue87_6.item_name or "物品"

		saveBankItem(playerIndex, slot, nil, 0, 0, 0)
		sendBankList(playerIndex)
		sendSystemMessage(playerIndex, "已刪除：" .. tostring(result2))

		return
	end

	slot = tonumber(slot) or -1

	if slot < 8 or slot > 27 then
		sendSystemMessage(playerIndex, "刪除失敗：槽位無效")

		return
	end

	local value5 = getInventorySlot(playerIndex, slot)
	local itemIndex = Char.GetItemIndex(playerIndex, value5)

	if not itemIndex or itemIndex < 0 then
		sendSystemMessage(playerIndex, "該格子沒有物品")

		return
	end

	local itemName = Item.GetData(itemIndex, CONST.道具_名字) or "物品"

	Char.DelItemBySlot(playerIndex, value5)
	Item.UpItem(playerIndex, value5)
	NLG.UpChar(playerIndex)
	sendBagList(playerIndex)
	sendSystemMessage(playerIndex, "已刪除：" .. tostring(itemName))
end

-- 開啟/刷新強化介面。
function openEnhanceUI(playerIndex)
	queryEnhanceSlot(playerIndex)
	sendBagList(playerIndex)
	sendEquipmentList(playerIndex)
	sendBankList(playerIndex)
end

-- 查詢強化結果。
function queryEnhanceResult(playerIndex, slot)
	slot = tonumber(slot) or 0

	if slot < 0 then
		slot = 0
	elseif slot > bagPageCount then
		slot = bagPageCount
	end

	Char.SetExtData(playerIndex, "xbbag_page", slot)
	sendBagList(playerIndex)
	Protocol.Send(playerIndex, "BAGPAGE", tostring(slot + 1), tostring(bagPageCount + 1))
end

-- 查詢強化費用。
function queryEnhanceCost(playerIndex, slot)
	slot = tonumber(slot)

	if slot == nil then
		slot = getBagPage(playerIndex)
	end

	if slot < 0 then
		slot = 0
	elseif slot > bagPageCount then
		slot = bagPageCount
	end

	Char.SetExtData(playerIndex, "xbbag_page", slot)
	sendBagList(playerIndex)
	Protocol.Send(playerIndex, "BAGPAGE", tostring(slot + 1), tostring(bagPageCount + 1))
end

-- 依強化等級重新計算裝備屬性。
function applyEnhancementStats(playerIndex, slot, itemIndex, enhanceLevel)
	local value = ensureEnhanceData(itemIndex, false)
	value.starEnhance.level = math.max(0, math.min(maxEnhanceLevel, tonumber(enhanceLevel) or 0))
	saveEnhanceData(itemIndex, value)
	rebuildItemStats(playerIndex, itemIndex, slot)
	Item.SetExtData(itemIndex, "EnhLevel", enhanceLevel)
	if slot ~= nil then Item.UpItem(playerIndex, slot) end
	NLG.UpChar(playerIndex)
end

-- 設定裝備強化等級並刷新物品。
function setEnhanceLevel(playerIndex, slot, itemIndex, enhanceLevel)
	local value = ensureEnhanceData(itemIndex, false)

	value.starEnhance.level = math.max(0, math.min(maxEnhanceLevel, enhanceLevel))

	saveEnhanceData(itemIndex, value)
	applyEnhancementStats(playerIndex, slot, itemIndex, value.starEnhance.level)
	Item.SetExtData(itemIndex, "EnhLevel", enhanceLevel)
	Item.UpItem(playerIndex, slot)
end

local enhanceItemTypeMin = 0
local enhanceItemTypeMax = 22

-- 判斷道具類型是否屬於可強化範圍。
function isEnhanceableItemType(itemIndex)
	local itemType = Item.GetData(itemIndex, CONST.道具_类型)
	local itemName = Item.GetData(itemIndex, CONST.道具_名字)

	return itemType >= enhanceItemTypeMin and itemType <= enhanceItemTypeMax
end

-- 在強化達到 +4/+7/+10 時發送全服公告。
function broadcastEnhanceMilestone(enhanceLevel, playerName, itemName)
	if enhanceLevel == 4 then
		NLG.SystemMessage(-1, string.format("玩家%s运氣不錯，將裝備%s強化+4，恭喜恭喜！", playerName, itemName))
	elseif enhanceLevel == 7 then
		NLG.SystemMessage(-1, string.format("玩家%s运氣非凡，竟然將裝備%s強化+7，莫非神器即將出世？", playerName, itemName))
	elseif enhanceLevel == 10 then
		NLG.SystemMessage(-1, string.format("★神器出世★ 玩家%s竟然將裝備%s強化+10，塑造出絕世神器！", playerName, itemName))
	end
end

-- 執行完整裝備強化流程。
function enhanceEquipment(playerIndex)
	local numericValue = tonumber(Char.GetExtData(playerIndex, "ui_store_hasItem")) or 0
	local numericValue2 = tonumber(Char.GetExtData(playerIndex, "ui_store_itemIndex")) or -1
	local numericValue3 = tonumber(Char.GetExtData(playerIndex, "ui_store_fromSlot")) or -1
	local numericValue4 = tonumber(Char.GetExtData(playerIndex, "ui_store_protect")) or 0

	if numericValue ~= 1 then
		sendSystemMessage(playerIndex, "[系統] 請將要強化的武器/裝備放入強化槽。")

		return
	end

	local result = numericValue2
	local flag = false

	if result >= 0 then
		local itemId = Item.GetData(result, CONST.道具_ID)

		if not itemId or itemId == 0 then
			flag = true
		end
	else
		flag = true
	end

	local value

	if flag then
		local itemCount = tonumber(Char.GetExtData(playerIndex, "ui_store_itemFullData_count")) or 0

		if itemCount > 0 then
			local data = {}

			for index = 1, itemCount do
				local value2 = Char.GetExtData(playerIndex, "ui_store_itemFullData_" .. index)

				if value2 then
					table.insert(data, value2)
				end
			end

			if #data == itemCount then
				value = table.concat(data)
			end
		end

		if not value then
			sendSystemMessage(playerIndex, "[系統] 強化槽道具數據損壞，請取回後重新放入。")

			return
		end

		local value3
		local value4, localValue95_13 = pcall(JSON.decode, value)

		if value4 then
			value3 = localValue95_13
		end

		if not value3 or type(value3) ~= "table" then
			sendSystemMessage(playerIndex, "[系統] 強化槽道具數據損壞，請取回後重新放入。")

			return
		end

		result = Item.MakeItem(0)

		if result < 0 then
			sendSystemMessage(playerIndex, "[系統] 創建臨時道具失敗。")

			return
		end

		for index2, index3 in pairs(itemDataFields) do
			local value5 = tostring(index3)

			if type(value3[value5]) ~= "nil" then
				Item.SetData(result, index3, value3[value5])
			end
		end

		if value3.item_name then
			Item.SetData(result, CONST.道具_名字, value3.item_name)
		end

		if value3._itemExt and type(value3._itemExt) == "table" then
			saveEnhanceData(result, value3._itemExt)
		end
	end

	local itemType = Item.GetData(result, CONST.道具_类型)

	if not isEnhanceableItemType(result) then
		sendSystemMessage(playerIndex, "[系統] 只能強化武器或防具裝備。")

		if flag and result >= 0 then
			Item.UnlinkItem(result)
		end

		return
	end

	local value6 = ensureEnhanceData(result, false)
	local result2 = value6.starEnhance.level or 0

	if result2 >= maxEnhanceLevel then
		sendSystemMessage(playerIndex, "[系統] 已強化到最高等級+10。")

		if flag and result >= 0 then
			Item.UnlinkItem(result)
		end

		return
	end

	local value7 = enhanceCosts[result2 + 1] or enhanceCosts[#enhanceCosts]
	local calculatedValue = numericValue4 == 1 and math.floor(value7 * 2) or value7
	local numericValue5 = tonumber(Char.GetData(playerIndex, CONST.对象_金币)) or 0

	if numericValue5 < calculatedValue then
		sendSystemMessage(playerIndex, string.format("[系統] 強化需要魔幣:%d (當前擁有:%d)，金額不足。", calculatedValue, numericValue5))

		if flag and result >= 0 then
			Item.UnlinkItem(result)
		end

		return
	end

	Char.AddGold(playerIndex, -calculatedValue)

	local value8 = enhanceSuccessRates[result2 + 1] or 0
	local calculatedValue2 = numericValue4 == 1 and math.min(100, value8 + 10) or value8
	local calculatedValue3 = math.random(1, 100)
	local value9

	if calculatedValue3 <= calculatedValue2 then
		local result3 = result2 + 1

		setEnhanceLevel(playerIndex, numericValue3, result, result3)

		local itemName = value6.starEnhance.baseName or Item.GetData(result, CONST.道具_名字)
		local playerName = Char.GetData(playerIndex, CONST.对象_名字)
		local value10 = enhanceAttributeBonus[result3] or 0

		sendSystemMessage(playerIndex, string.format("[系統] 強化成功：+%d（屬性+%d%%）。", result3, value10))
		broadcastEnhanceMilestone(result3, playerName, itemName)
	else
		local calculatedValue4 = math.max(0, result2 - 1)

		setEnhanceLevel(playerIndex, numericValue3, result, calculatedValue4)
		sendSystemMessage(playerIndex, string.format("[系統] 強化失敗：+%d → +%d。", result2, calculatedValue4))
	end

	local value11 = queryBagPage(result)
	local numericValue6 = tonumber(Char.GetExtData(playerIndex, "ui_store_itemData1")) or 0
	local value12 = formatItemInfo(result)

	Char.SetExtData(playerIndex, "ui_store_cache_lv", value11)

	local data2 = {}

	for index4, index5 in pairs(itemDataFields) do
		data2[tostring(index5)] = Item.GetData(result, index5)
	end

	data2.item_name = Item.GetData(result, CONST.道具_名字)

	local value13 = getEnhanceData(result)

	if value13 then
		data2._itemExt = value13
	end

	local potentialExt = Item.GetExtData(result, "potentialData")
	if potentialExt and tostring(potentialExt) ~= "" then
		local potentialOK, potentialValue = pcall(JSON.decode, tostring(potentialExt))
		if potentialOK and type(potentialValue) == "table" then data2.potential = potentialValue end
	end
	local statBase = ensureStatBaseAttrsForItem(result)
	if statBase then data2._statBaseAttrs = statBase end

	local encodedData = JSON.encode(data2)
	local value14 = 2000
	local data3 = {}

	for index6 = 1, #encodedData, value14 do
		table.insert(data3, string.sub(encodedData, index6, index6 + value14 - 1))
	end

	for index7, index8 in ipairs(data3) do
		Char.SetExtData(playerIndex, "ui_store_itemFullData_" .. index7, index8)
	end

	Char.SetExtData(playerIndex, "ui_store_itemFullData_count", #data3)

	if flag and result >= 0 then
		Item.UnlinkItem(result)
	end

	local value15, localValue95_39 = getItemDataSetAndGemInfo(playerIndex, data2)

	local potentialText, potentialMainQuality, potentialAddQuality = getPotentialHoverCacheData(data2)
	sendXBProtocol(playerIndex, 1, numericValue6, value11, value12, formatItemDataDurability(data2), formatItemDataType(data2), value15, localValue95_39, potentialText, potentialMainQuality, potentialAddQuality)
end

-- 取得隊伍中的其他成員。
function getPartyMembers(playerIndex)
	local data = {}

	if (tonumber(Char.PartyNum(playerIndex)) or 0) > 0 then
		for index = 0, 4 do
			local value = Char.GetPartyMember(playerIndex, index)

			if value and value >= 0 and value ~= playerIndex then
				table.insert(data, value)
			end
		end
	end

	return data
end

-- 依職業 ID 取得職業名稱。
function getJobName(playerIndex)
	local jobId = tonumber(Char.GetData(playerIndex, CONST.对象_职业)) or 0

	return jobNames[jobId] or ""
end

-- 整理隊伍成員資料並回傳客戶端。
function queryPartyInfo(playerIndex)
	local value = getJobName(playerIndex)
	local playerLevel = tonumber(Char.GetData(playerIndex, CONST.对象_等级)) or 0
	local value2 = Char.GetPartyMember(playerIndex, 0)
	local result = value2 == playerIndex
	local data = {}

	for index, index2 in ipairs(getPartyMembers(playerIndex)) do
		local characterImage = tonumber(Char.GetData(index2, CONST.对象_形象)) or 0
		local hp = tonumber(Char.GetData(index2, CONST.对象_血)) or 0
		local maxHp = tonumber(Char.GetData(index2, CONST.对象_最大血)) or 0
		local mp = tonumber(Char.GetData(index2, CONST.对象_魔)) or 0
		local maxMp = tonumber(Char.GetData(index2, CONST.对象_最大魔)) or 0
		local playerName = tostring(Char.GetData(index2, CONST.对象_名字) or "")
		local text = string.gsub(playerName, "[,:]", "_")
		local value3 = getJobName(index2)
		local text2 = string.gsub(value3, "[,:]", "_")
		local playerLevel2 = tonumber(Char.GetData(index2, CONST.对象_等级)) or 0
		local value4 = index2 == value2 and "1" or "0"

		table.insert(data, table.concat({
			tostring(characterImage),
			tostring(hp),
			tostring(maxHp),
			tostring(mp),
			tostring(maxMp),
			text,
			text2,
			tostring(playerLevel2),
			value4
		}, ":"))
	end

	Protocol.Send(playerIndex, "XBPARTY", value, tostring(playerLevel), result and "1" or "0", table.concat(data, ","))
end

-- 由隊長踢除指定隊員。
function kickPartyMember(playerIndex, targetPlayerIndex)
	local numericValue = tonumber(targetPlayerIndex) or 0

	if numericValue < 1 or numericValue > 4 then
		return
	end

	if (tonumber(Char.PartyNum(playerIndex)) or 0) <= 0 then
		return
	end

	if Char.GetPartyMember(playerIndex, 0) ~= playerIndex then
		sendSystemMessage(playerIndex, "只有隊長才能踢出隊員")

		return
	end

	local value = getPartyMembers(playerIndex)[numericValue]

	if not value then
		return
	end

	local playerName = tostring(Char.GetData(value, CONST.对象_名字) or "队员")

	Char.LeaveParty(value)
	sendSystemMessage(value, "你已被隊長踢出隊伍")
	sendSystemMessage(playerIndex, "已踢出隊員：" .. playerName)
	queryPartyInfo(playerIndex)
end

-- 整理玩家寵物列表。
function queryPetList(playerIndex, page)
	local numericValue = tonumber(page) or 0

	if numericValue < 0 or numericValue > 4 then
		return
	end

	local value = playerIndex

	if numericValue > 0 then
		value = getPartyMembers(playerIndex)[numericValue]
	end

	if not value then
		Protocol.Send(playerIndex, "XBPCATT", tostring(numericValue), "")

		return
	end

	local data = {}

	for index = 0, 4 do
		local value2 = Char.GetPet(value, index)

		if value2 and value2 >= 0 then
			local characterImage = tonumber(Char.GetData(value2, CONST.对象_形象)) or 0
			local playerName = tostring(Char.GetData(value2, CONST.对象_名字) or "")
			local text = string.gsub(playerName, "[,:]", "_")
			local playerLevel = tonumber(Char.GetData(value2, CONST.对象_等级)) or 0
			local hp = tonumber(Char.GetData(value2, CONST.对象_血)) or 0
			local maxHp = tonumber(Char.GetData(value2, CONST.对象_最大血)) or 0
			local mp = tonumber(Char.GetData(value2, CONST.对象_魔)) or 0
			local maxMp = tonumber(Char.GetData(value2, CONST.对象_最大魔)) or 0

			table.insert(data, table.concat({
				tostring(characterImage),
				text,
				tostring(playerLevel),
				tostring(hp),
				tostring(maxHp),
				tostring(mp),
				tostring(maxMp)
			}, ":"))
		else
			table.insert(data, "0")
		end
	end

	Protocol.Send(playerIndex, "XBPCATT", tostring(numericValue), table.concat(data, ","))
end

-- 消耗指定欄位的一個物品。
function consumeItem(playerIndex, slot)
	slot = tonumber(slot) or -1

	if slot < 8 or slot > 27 then
		return false
	end

	local value = getInventorySlot(playerIndex, slot)
	local itemIndex = Char.GetItemIndex(playerIndex, value)

	if not itemIndex or itemIndex < 0 then
		return false
	end

	local numericValue = tonumber(Item.GetData(itemIndex, CONST.道具_堆叠数) or 0) or 0

	if numericValue > 1 then
		Item.SetData(itemIndex, CONST.道具_堆叠数, numericValue - 1)
	else
		Char.DelItemBySlot(playerIndex, value)
	end

	Item.UpItem(playerIndex, value)

	return true
end

-- 清除指定暫存道具資料。
function removeStoredItem(playerIndex, slot)
	slot = tonumber(slot) or -1

	if slot < 0 or slot >= bankTotalSlots then
		return false
	end

	local value = loadBankItem(playerIndex, slot)

	if not value then
		return false
	end

	local value2, localValue102_2 = pcall(JSON.decode, value)
	local result = value2 and localValue102_2 or nil

	if not result or type(result) ~= "table" then
		return false
	end

	local numericValue = (tonumber(result[tostring(CONST.道具_堆叠数)]) or 0) - 1

	if numericValue > 0 then
		result[tostring(CONST.道具_堆叠数)] = numericValue

		local encodedData = JSON.encode(result)
		local itemImage = tonumber(Char.GetExtData(playerIndex, "xbbank_" .. slot .. "_img")) or 0
		local itemLevel = tonumber(Char.GetExtData(playerIndex, "xbbank_" .. slot .. "_lv")) or 0

		saveBankItem(playerIndex, slot, encodedData, itemImage, numericValue, itemLevel)
	else
		saveBankItem(playerIndex, slot, nil, 0, 0, 0)
	end

	return true
end

-- 讓指定隊伍目標恢復生命或魔力。
function feedTarget(playerIndex, targetIndex, itemSlot, itemType, amount, mode)
	local numericValue = tonumber(targetIndex) or 0

	if numericValue < 0 or numericValue > 4 then
		return
	end

	local numericValue2 = tonumber(itemSlot) or 0
	local numericValue3 = tonumber(itemType) or -1
	local numericValue4 = tonumber(amount) or 1
	local numericValue5 = tonumber(mode) or -1

	if numericValue5 < -1 or numericValue5 > 4 then
		return
	end

	local value = playerIndex

	if numericValue > 0 then
		value = getPartyMembers(playerIndex)[numericValue]

		if not value then
			sendSystemMessage(playerIndex, "進補失敗：目標不在隊伍中")

			return
		end
	end

	local result = numericValue2 == 1
	local value2 = -1
	local value3 = -1
	local value4 = "道具"
	local flag = false

	if result then
		local value5 = loadBankItem(playerIndex, numericValue3)

		if value5 then
			local value6, localValue103_13 = pcall(JSON.decode, value5)

			if value6 and type(localValue103_13) == "table" then
				value3 = tonumber(localValue103_13[tostring(CONST.道具_类型)]) or -1
				value4 = tostring(localValue103_13.item_name or "道具")
				flag = true
			end
		end
	else
		local result2 = numericValue3

		if numericValue4 > 1 then
			local value7 = takeStoredBagItem(playerIndex, numericValue3)

			if not value7 then
				return
			end

			result2 = value7
		end

		value2 = result2

		local value8 = getInventorySlot(playerIndex, result2)
		local itemIndex = Char.GetItemIndex(playerIndex, value8)

		if itemIndex and itemIndex >= 0 then
			value3 = tonumber(Item.GetData(itemIndex, CONST.道具_类型)) or -1
			value4 = tostring(Item.GetData(itemIndex, CONST.道具_名字) or "道具")
			flag = true
		end
	end

	if not flag then
		sendSystemMessage(playerIndex, "進補失敗：未找到料理或血藥（物品可能已用完）")

		return
	end

	if value3 ~= 23 and value3 ~= 42 and value3 ~= 43 then
		sendSystemMessage(playerIndex, "進補失敗：該物品不是料理或血藥")

		return
	end

	local result3 = value
	local flag2 = false

	if numericValue5 >= 0 then
		local value9 = Char.GetPet(value, numericValue5)

		if not value9 or value9 < 0 then
			sendSystemMessage(playerIndex, "進補失敗：該寵物不存在")

			return
		end

		result3 = value9
		flag2 = true
	end

	local value10 = "魔力"

	if value3 == 23 or value3 == 42 then
		local mp = tonumber(Char.GetData(result3, CONST.对象_魔)) or 0
		local maxMp = tonumber(Char.GetData(result3, CONST.对象_最大魔)) or 0

		if maxMp <= mp then
			sendSystemMessage(playerIndex, "進補失敗：目標魔力已滿，無需進食")

			return
		end

		Char.SetData(result3, CONST.对象_魔, maxMp)
	else
		local hp = tonumber(Char.GetData(result3, CONST.对象_血)) or 0
		local maxHp = tonumber(Char.GetData(result3, CONST.对象_最大血)) or 0

		if maxHp <= hp then
			sendSystemMessage(playerIndex, "進補失敗：目標體力已滿，無需進食")

			return
		end

		Char.SetData(result3, CONST.对象_血, maxHp)

		value10 = "體力"
	end

	if result then
		removeStoredItem(playerIndex, numericValue3)
		sendBankList(playerIndex)
	else
		consumeItem(playerIndex, value2)
		sendBagList(playerIndex)
	end

	NLG.UpChar(value)

	if flag2 then
		queryPetList(playerIndex, numericValue)
	else
		queryPartyInfo(playerIndex)
	end

	local playerName = tostring(Char.GetData(result3, CONST.对象_名字) or flag2 and "寵物" or "目標")

	sendSystemMessage(playerIndex, "已用 " .. tostring(value4) .. " 為 " .. playerName .. " 補滿" .. value10)
end

local equipStorageKey = "xq_equip"
local gemStorageKey = "xq_gem"
local resultStorageKey = "xq_result"

-- 清空一組合成/暫存物品的 ExtData。
function clearStorage(playerIndex, storageKey)
	Char.SetExtData(playerIndex, storageKey .. "_has", 0)
	Char.SetExtData(playerIndex, storageKey .. "_img", nil)
	Char.SetExtData(playerIndex, storageKey .. "_lv", nil)
	Char.SetExtData(playerIndex, storageKey .. "_slot", nil)
	Char.SetExtData(playerIndex, storageKey .. "_count", nil)

	for index = 1, 20 do
		Char.SetExtData(playerIndex, storageKey .. "_" .. index, nil)
	end
end

-- 判斷指定暫存槽是否有物品。
function hasStoredItem(playerIndex, storageKey)
	return (tonumber(Char.GetExtData(playerIndex, storageKey .. "_has")) or 0) == 1
end

-- 取得暫存物品的存在、圖像與等級資訊。
function getStorageMeta(playerIndex, storageKey)
	return tonumber(Char.GetExtData(playerIndex, storageKey .. "_has")) or 0, tonumber(Char.GetExtData(playerIndex, storageKey .. "_img")) or 0, tonumber(Char.GetExtData(playerIndex, storageKey .. "_lv")) or 0
end

-- 讀取暫存物品的 JSON 分段資料。
function getStorageJsonChunks(playerIndex, storageKey)
	local itemCount = tonumber(Char.GetExtData(playerIndex, storageKey .. "_count")) or 0

	if itemCount <= 0 then
		return nil
	end

	local data = {}

	for index = 1, itemCount do
		local value = Char.GetExtData(playerIndex, storageKey .. "_" .. index)

		if not value then
			return nil
		end

		table.insert(data, value)
	end

	return table.concat(data)
end

-- 合併分段資料並解碼成 Lua table。
function getStorageData(playerIndex, storageKey)
	local value = getStorageJsonChunks(playerIndex, storageKey)

	if not value then
		return nil
	end

	local value2, localValue108_2 = pcall(JSON.decode, value)

	if not value2 or type(localValue108_2) ~= "table" then
		return nil
	end

	return localValue108_2
end

-- 將實體裝備序列化成可保存的物品資料。
function serializeItemForStorage(playerIndex, storageKey, itemIndex, mode)
	local data = {}

	for index, index2 in pairs(itemDataFields) do
		data[tostring(index2)] = Item.GetData(itemIndex, index2)
	end

	data.item_name = Item.GetData(itemIndex, CONST.道具_名字)

	ensureEnhanceData(itemIndex, true)

	local value = getEnhanceData(itemIndex)

	if value then
		local flag = false

		for index3, index4 in pairs(value) do
			flag = true

			break
		end

		if flag then
			data._itemExt = value
		end
	end

	-- 潛能資料不是普通 Item.GetData 欄位，必須從 Item ExtData 一併序列化。
	-- 否則已開潛能裝備取回背包後，再放回潛能格會遺失開啟狀態、品質與三條效果。
	local potentialExt = Item.GetExtData(itemIndex, "potentialData")
	if potentialExt and tostring(potentialExt) ~= "" then
		local potentialOK, potentialValue = pcall(JSON.decode, tostring(potentialExt))
		if potentialOK and type(potentialValue) == "table" then
			data.potential = potentialValue
		end
	end



	local statBase = ensureStatBaseAttrsForItem(itemIndex)
	if statBase then data._statBaseAttrs = statBase end

	local value2, localValue109_4 = pcall(JSON.encode, data)

	if not value2 or not localValue109_4 then
		sendSystemMessage(playerIndex, "[系統] 道具數據序列化失敗")

		return false
	end

	clearStorage(playerIndex, storageKey)
	Char.SetExtData(playerIndex, storageKey .. "_has", 1)
	Char.SetExtData(playerIndex, storageKey .. "_img", tonumber(Item.GetData(itemIndex, 1)) or 0)
	Char.SetExtData(playerIndex, storageKey .. "_lv", queryBagPage(itemIndex))

	if mode then
		Char.SetExtData(playerIndex, storageKey .. "_slot", mode)
	end

	local data2 = {}

	for index5 = 1, #localValue109_4, 2000 do
		table.insert(data2, string.sub(localValue109_4, index5, index5 + 1999))
	end

	Char.SetExtData(playerIndex, storageKey .. "_count", #data2)

	for index6, index7 in ipairs(data2) do
		Char.SetExtData(playerIndex, storageKey .. "_" .. index6, index7)
	end

	return true
end

-- 整理暫存物品的名稱、耐久、類型、套裝與寶石資訊。
function formatStoredItemInfo(playerIndex, itemData)
	if not itemData or type(itemData) ~= "table" then
		return "", "", "", "", ""
	end

	local value = formatItemDataInfo(itemData)
	local value2 = formatItemDataDurability(itemData)
	local value3 = formatItemDataType(itemData)
	local value4, localValue110_4 = getItemDataSetAndGemInfo(playerIndex, itemData)

	return value, value2, value3, value4 or "", localValue110_4 or ""
end

-- 整理並傳送鑲嵌/合成介面資料。
function sendSynthesisUI(playerIndex)
	local value, localValue111_1, localValue111_2 = getStorageMeta(playerIndex, equipStorageKey)
	local value2, localValue111_4, localValue111_5 = getStorageMeta(playerIndex, gemStorageKey)
	local value3, localValue111_7, localValue111_8 = getStorageMeta(playerIndex, resultStorageKey)
	local value4 = getStorageData(playerIndex, equipStorageKey)
	local value5 = getStorageData(playerIndex, gemStorageKey)
	local value6 = getStorageData(playerIndex, resultStorageKey)
	local value7 = ""
	local value8 = ""
	local value9 = ""
	local value10 = ""
	local value11 = ""

	if value4 then
		value7, value8, value9, value10, value11 = formatStoredItemInfo(playerIndex, value4)
	end

	local value12 = ""

	if value5 then
		value12 = formatItemDataInfo(value5)
	end

	local value13 = ""
	local value14 = ""
	local value15 = ""
	local value16 = ""
	local value17 = ""

	if value6 then
		value13, value14, value15, value16, value17 = formatStoredItemInfo(playerIndex, value6)
	end

	local value18 = 0

	if value6 and tonumber(value6[tostring(CONST.道具_宝石武)]) then
		value18 = tonumber(value6[tostring(CONST.道具_宝石武)]) or 0
	end

	if value18 == 0 and value6 and tonumber(value6[tostring(CONST.道具_宝石防)]) then
		value18 = tonumber(value6[tostring(CONST.道具_宝石防)]) or 0
	end

	local value19 = 0

	if value4 then
		local numericValue = tonumber(value4[tostring(CONST.道具_宝石武)]) or 0
		local numericValue2 = tonumber(value4[tostring(CONST.道具_宝石防)]) or 0

		value19 = numericValue ~= 0 and numericValue or numericValue2
	end

	local value20 = 0

	if value5 then
		value20 = tonumber(value5["0"]) or 0
	end

	local function formatGemEffectSummary(itemId, isWeapon)
		local value = getGemEffectList(itemId, isWeapon)

		if #value == 0 then
			return ""
		end

		return table.concat(value, "|")
	end

	local value21 = formatGemEffectSummary(value20, true)
	local value22 = ""

	if value18 > 0 then
		local itemType = value6 and tonumber(value6[tostring(CONST.道具_类型)]) or -1

		value22 = formatGemEffectSummary(value18, itemType >= 0 and itemType <= 6)
	end

	Protocol.Send(playerIndex, "XQSTATE", tostring(value), tostring(localValue111_1), tostring(localValue111_2), tostring(value7), tostring(value8), tostring(value9), tostring(value10), tostring(value11), tostring(value2), tostring(localValue111_4), tostring(localValue111_5), tostring(value12), tostring(value3), tostring(localValue111_7), tostring(localValue111_8), tostring(value13), tostring(value14), tostring(value15), tostring(value16), tostring(value17), tostring(value18), tostring(value19), tostring(value20), tostring(value21), tostring(value22))
end

-- 將背包裝備或寶石放入鑲嵌暫存槽。
function putSynthesisItem(playerIndex, slot, page, storageKey, storageType, storageName)
	page = tonumber(page) or 1

	if page > 1 then
		local value = takeStoredBagItem(playerIndex, slot)

		if not value then
			return
		end

		slot = value
	end

	slot = getInventorySlot(playerIndex, tonumber(slot) or -1)

	if hasStoredItem(playerIndex, storageKey) then
		sendSystemMessage(playerIndex, storageName .. "已有物品，請先取回")

		return
	end

	local itemIndex = Char.GetItemIndex(playerIndex, slot)

	if not itemIndex or itemIndex < 0 then
		sendSystemMessage(playerIndex, "該背包格沒有物品")

		return
	end

	if storageType == "equip" or storageType == "result" then
		local itemType = tonumber(Item.GetData(itemIndex, CONST.道具_类型)) or -1

		if itemType < 0 or itemType > 22 then
			sendSystemMessage(playerIndex, "只有裝備類道具（武器/防具/飾品等）才能放入" .. storageName)

			return
		end

		if storageType == "equip" then
			local numericValue = tonumber(Item.GetData(itemIndex, CONST.道具_宝石武)) or 0
			local numericValue2 = tonumber(Item.GetData(itemIndex, CONST.道具_宝石防)) or 0

			if numericValue ~= 0 or numericValue2 ~= 0 then
				sendSystemMessage(playerIndex, "該裝備已鑲嵌過寶石，不能再鑲嵌")

				return
			end
		end
	elseif storageType == "gem" then
		local itemId = tonumber(Item.GetData(itemIndex, CONST.道具_ID)) or 0

		if not isGemItemId(itemId) then
			sendSystemMessage(playerIndex, "只有1-10級寶石才能放入鑲嵌寶石格")

			return
		end
	end

	if not serializeItemForStorage(playerIndex, storageKey, itemIndex, slot) then
		return
	end

	Char.SetItemIndex(playerIndex, slot, -1)
	Item.UpItem(playerIndex, -1)
	sendSynthesisUI(playerIndex)
	sendBagList(playerIndex)
	sendSystemMessage(playerIndex, "已把物品放入" .. storageName)
end

-- 從鑲嵌暫存槽取回物品。
function takeSynthesisItem(playerIndex, slot, targetPage, storageKey, storageName)
	if not hasStoredItem(playerIndex, storageKey) then
		sendSystemMessage(playerIndex, storageName .. "沒有物品")

		return
	end

	local value = getStorageData(playerIndex, storageKey)

	if not value then
		sendSystemMessage(playerIndex, storageName .. "道具數據異常，請重新登錄後再試")

		return
	end

	local value2 = getStorageJsonChunks(playerIndex, storageKey)

	if not value2 then
		sendSystemMessage(playerIndex, storageName .. "道具數據不完整，請重新登錄後再試")

		return
	end

	targetPage = tonumber(targetPage) or 1

	if targetPage > 1 then
		local numericValue = tonumber(slot) or -1

		if numericValue < 0 or numericValue >= bagTotalSlots then
			sendSystemMessage(playerIndex, "取回失敗：格子無效")

			return
		end

		if (tonumber(Char.GetExtData(playerIndex, "xbbag_" .. numericValue .. "_count")) or 0) > 0 then
			sendSystemMessage(playerIndex, "背包第" .. tostring(targetPage) .. "頁該格已有物品")

			return
		end

		local value3, localValue114_4, localValue114_5 = getStorageMeta(playerIndex, storageKey)
		local numericValue2 = tonumber(value[tostring(CONST.道具_堆叠数)]) or 0

		if numericValue2 < 0 then
			numericValue2 = 0
		end

		saveBagItem(playerIndex, numericValue, value2, localValue114_4, numericValue2, localValue114_5)
		clearStorage(playerIndex, storageKey)
		sendSynthesisUI(playerIndex)
		sendBagList(playerIndex)
		sendSystemMessage(playerIndex, "已取回並放入背包第" .. tostring(targetPage) .. "頁")

		return
	end

	local numericValue3 = tonumber(slot) or -1
	local value4 = -1

	if numericValue3 >= 8 and numericValue3 <= 27 then
		local value5 = getInventorySlot(playerIndex, numericValue3)
		local itemIndex = Char.GetItemIndex(playerIndex, value5)

		if not itemIndex or itemIndex < 0 then
			value4 = value5
		end
	end

	if value4 < 0 then
		for index = 27, 8, -1 do
			local targetPageValue = Char.GetItemIndex(playerIndex, getInventorySlot(playerIndex, index))

			if not targetPageValue or targetPageValue < 0 then
				value4 = getInventorySlot(playerIndex, index)

				break
			end
		end
	end

	if value4 < 0 then
		sendSystemMessage(playerIndex, "背包已滿，無法取回")

		return
	end

	if createItemFromData(playerIndex, value, value4) < 0 then
		sendSystemMessage(playerIndex, "取回失敗：無法創建物品")

		return
	end

	clearStorage(playerIndex, storageKey)
	sendSynthesisUI(playerIndex)
	sendBagList(playerIndex)
	sendSystemMessage(playerIndex, "取回成功：" .. tostring(value.item_name or "物品"))
end

-- 執行寶石鑲嵌合成並建立結果。
function synthesizeGemIntoEquipment(playerIndex)
	if not hasStoredItem(playerIndex, equipStorageKey) or not hasStoredItem(playerIndex, gemStorageKey) then
		sendSystemMessage(playerIndex, "請先在裝備格放入裝備、寶石格放入寶石")

		return
	end

	if hasStoredItem(playerIndex, resultStorageKey) then
		sendSystemMessage(playerIndex, "合成結果格已有物品，請先取回")

		return
	end

	local value = getStorageData(playerIndex, equipStorageKey)
	local value2 = getStorageData(playerIndex, gemStorageKey)

	if not value or not value2 then
		sendSystemMessage(playerIndex, "道具數據異常，請取回後重新放入")

		return
	end

	local numericValue = tonumber(value2["0"]) or 0

	if not isGemItemId(numericValue) then
		sendSystemMessage(playerIndex, "寶石格內不是有效寶石")

		return
	end

	local data = {}

	for index, index2 in pairs(value) do
		data[index] = index2
	end

	local itemType = tonumber(data[tostring(CONST.道具_类型)]) or -1
	local result = itemType >= 0 and itemType <= 6
	local calculatedValue = math.floor((numericValue - gemItemIdStart) / 10)
	local value3 = (numericValue - gemItemIdStart) % 10 + 1
	local value4 = {
		[0] = 0,
		10,
		20,
		30,
		40,
		50,
		60
	}
	local value5 = {
		[0] = 400,
		410,
		420,
		430,
		440,
		450,
		460
	}
	local value6

	if result then
		value6 = (value4[calculatedValue] or 0) + (value3 - 1)

		if not gemMaterialEffects[value6] then
			value6 = (value5[calculatedValue] or 0) + (value3 - 1)
		end
	else
		value6 = (value5[calculatedValue] or 0) + (value3 - 1)

		if not gemMaterialEffects[value6] then
			value6 = (value4[calculatedValue] or 0) + (value3 - 1)
		end
	end

	if not gemMaterialEffects[value6] then
		sendSystemMessage(playerIndex, "寶石效果數據缺失（材料ID=" .. tostring(value6) .. "），請取回裝備與寶石")

		return
	end

	-- 建立乾淨基礎快照後，再寫入寶石 ID，由統一重建流程計算最終屬性。
	ensureStatBaseAttrsFromItemData(data)
	local result2 = result and CONST.道具_宝石武 or CONST.道具_宝石防
	data[tostring(result2)] = numericValue

	if not rebuildItemDataStats(data) then
		sendSystemMessage(playerIndex, "寶石/潛能/強化屬性重建失敗，請取回裝備重新操作")
		return
	end

	-- 延續原本規則：若寶石增加最大耐久，鑲嵌完成後耐久回滿。
	if gemMaterialEffects[value6] and gemMaterialEffects[value6][1] and gemMaterialEffects[value6][1].val ~= 0 then
		data[tostring(CONST.道具_耐久)] = data[tostring(CONST.道具_最大耐久)]
	end

	local value7, localValue115_13 = pcall(JSON.encode, data)

	if not value7 or not localValue115_13 then
		sendSystemMessage(playerIndex, "[系統] 合成結果數據序列化失敗")

		return
	end

	local value8, localValue115_15, localValue115_16 = getStorageMeta(playerIndex, equipStorageKey)

	clearStorage(playerIndex, resultStorageKey)
	Char.SetExtData(playerIndex, resultStorageKey .. "_has", 1)
	Char.SetExtData(playerIndex, resultStorageKey .. "_img", localValue115_15)
	Char.SetExtData(playerIndex, resultStorageKey .. "_lv", localValue115_16)

	local data2 = {}

	for index3 = 1, #localValue115_13, 2000 do
		table.insert(data2, string.sub(localValue115_13, index3, index3 + 1999))
	end

	Char.SetExtData(playerIndex, resultStorageKey .. "_count", #data2)

	for index4, index5 in ipairs(data2) do
		Char.SetExtData(playerIndex, resultStorageKey .. "_" .. index4, index5)
	end

	clearStorage(playerIndex, equipStorageKey)
	clearStorage(playerIndex, gemStorageKey)
	sendSynthesisUI(playerIndex)
	sendBagList(playerIndex)

	local value9 = tostring(value2.item_name or "寶石")
	local value10 = tostring(value.item_name or "裝備")

	sendSystemMessage(playerIndex, "鑲嵌合成成功！已將 " .. value10 .. " 鑲嵌 " .. value9)
end

-- 重新整理鑲嵌合成 UI。
function refreshSynthesisUI(playerIndex)
	sendSynthesisUI(playerIndex)
end

-- 處理客戶端 XBCenter 指令並分派到對應功能。


-- ============================================================================
-- 潛能系統 CUSTOMXB 260~268
-- 260 查詢狀態
-- 261 放入潛能裝備
-- 262 放入潛能開啟/洗潛道具
-- 263 開啟主要潛能
-- 264 重洗主要潛能
-- 265 開啟附加潛能
-- 266 重洗附加潛能
-- 267 取回潛能裝備
-- 268 取回潛能開啟/洗潛道具
--
-- 注意：以下四組道具 ID 必須依你的遊戲資料表填入。
-- 本區只負責「封包、狀態保存、品質/效果隨機、金幣扣除與道具消耗」。
-- 實際戰鬥屬性套用可在 applyPotentialStats() 接入。
-- ============================================================================
local potentialEquipStorageKey = "xpot_equip"
local potentialToolStorageKey = "xpot_tool"

local potentialConfig = {
    -- ===== 請填入實際道具 ID =====
    mainOpenItemIds = {75045},      -- 開啟主要潛能道具
    mainCubeItemIds = {75046},      -- 主要潛能方塊
    addOpenItemIds = {75047},       -- 開啟附加潛能道具
    addCubeItemIds = {75048},       -- 附加潛能方塊

    -- 開啟潛能的金幣費用
    mainOpenGold = 10000,
    addOpenGold = 20000,
    mainCubeGold = 2000,
    addCubeGold = 2000,

    -- 洗潛時品質向上跳階機率（百分比）
    qualityUpChance = {
        [1] = 5,   -- 特殊 -> 稀有
        [2] = 3,   -- 稀有 -> 罕見
        [3] = 1,   -- 罕見 -> 傳說
        [4] = 0,
    },
}

local potentialQualityNames = {
    [1] = "特殊",
    [2] = "稀有",
    [3] = "罕見",
    [4] = "傳說",
}

-- 每個品質三條效果的候選池。
-- 目前先保存/回傳文字；真正角色/裝備屬性套用放在 applyPotentialStats()。
-- 使用既有 XBCENTER 傳送潛能 Tooltip 快取。
-- 文字與品質同時快取，前端所有裝備 Tooltip 共用這份資料。
function getPotentialHoverCacheData(itemData)
	if type(itemData) ~= "table" then
		return "", 0, 0
	end

	local p = itemData.potential
	if type(p) ~= "table" then
		return "", 0, 0
	end

	local mainQuality = p.mainOpened and (tonumber(p.mainQuality) or 0) or 0
	local addQuality = p.addOpened and (tonumber(p.addQuality) or 0) or 0
	if mainQuality <= 0 and addQuality <= 0 then
		return "", 0, 0
	end

	local mainName = potentialQualityNames[mainQuality] or "-"
	local addName = potentialQualityNames[addQuality] or "-"
	local text = "主潛/附潛品質：" .. mainName .. "  " .. addName
	return text, mainQuality, addQuality
end

function getPotentialHoverCacheFromItemIndex(itemIndex)
	if not itemIndex or itemIndex < 0 then
		return "", 0, 0
	end

	local raw = Item.GetExtData(itemIndex, "potentialData")
	if not raw or raw == "" then
		return "", 0, 0
	end

	local ok, data = pcall(JSON.decode, raw)
	if not ok or type(data) ~= "table" then
		return "", 0, 0
	end

	return getPotentialHoverCacheData({ potential = data })
end

function sendPotentialCacheXBCENTER(playerIndex, itemData, sourceType, sourceIndex)
	local text, mainQuality, addQuality = getPotentialHoverCacheData(itemData)
	sendXBProtocol(playerIndex, 3, 0, 0, "", "", "", "", "", text, mainQuality, addQuality, sourceType or "", sourceIndex or "")
end

function sendPotentialCacheXBCENTERFromItemIndex(playerIndex, itemIndex, sourceType, sourceIndex)
	local raw = Item.GetExtData(itemIndex, "potentialData")
	if not raw or raw == "" then
		sendXBProtocol(playerIndex, 3, 0, 0, "", "", "", "", "", "", 0, 0, sourceType or "", sourceIndex or "")
		return
	end

	local ok, data = pcall(JSON.decode, raw)
	if ok and type(data) == "table" then
		sendPotentialCacheXBCENTER(playerIndex, { potential = data }, sourceType, sourceIndex)
	else
		sendXBProtocol(playerIndex, 3, 0, 0, "", "", "", "", "", "", 0, 0, sourceType or "", sourceIndex or "")
	end
end

local potentialEffectTierWeights = {
    [1] = 60, -- 低
    [2] = 30, -- 中
    [3] = 10, -- 高
}

-- 潛能效果池：四種品質、六種素質；每條潛能獨立抽取，因此同一素質可以重複出現。
-- 第2層為同一素質的低／中／高數值，出現權重為 60% / 30% / 10%。
local potentialEffectPool = {
    [1] = { -- 特殊
        { name = "攻擊", values = { [1] = 2,  [2] = 3,   [3] = 5   } },
        { name = "防禦", values = { [1] = 2,  [2] = 3,   [3] = 5   } },
        { name = "敏捷", values = { [1] = 1,  [2] = 2,   [3] = 3   } },
        { name = "精神", values = { [1] = 1,  [2] = 2,   [3] = 3   } },
        { name = "生命", values = { [1] = 20, [2] = 30,  [3] = 50  } },
        { name = "魔力", values = { [1] = 10, [2] = 20,  [3] = 30  } },
    },
    [2] = { -- 稀有
        { name = "攻擊", values = { [1] = 5,  [2] = 8,   [3] = 12  } },
        { name = "防禦", values = { [1] = 5,  [2] = 8,   [3] = 12  } },
        { name = "敏捷", values = { [1] = 3,  [2] = 5,   [3] = 7   } },
        { name = "精神", values = { [1] = 3,  [2] = 5,   [3] = 7   } },
        { name = "生命", values = { [1] = 50, [2] = 80,  [3] = 120 } },
        { name = "魔力", values = { [1] = 30, [2] = 50,  [3] = 80  } },
    },
    [3] = { -- 罕見
        { name = "攻擊", values = { [1] = 10, [2] = 15,  [3] = 22  } },
        { name = "防禦", values = { [1] = 10, [2] = 15,  [3] = 22  } },
        { name = "敏捷", values = { [1] = 7,  [2] = 10,  [3] = 14  } },
        { name = "精神", values = { [1] = 7,  [2] = 10,  [3] = 14  } },
        { name = "生命", values = { [1] = 100,[2] = 160, [3] = 240 } },
        { name = "魔力", values = { [1] = 70, [2] = 100, [3] = 150 } },
    },
    [4] = { -- 傳說
        { name = "攻擊", values = { [1] = 18, [2] = 25,  [3] = 35  } },
        { name = "防禦", values = { [1] = 18, [2] = 25,  [3] = 35  } },
        { name = "敏捷", values = { [1] = 12, [2] = 18,  [3] = 25  } },
        { name = "精神", values = { [1] = 12, [2] = 18,  [3] = 25  } },
        { name = "生命", values = { [1] = 200,[2] = 300, [3] = 450 } },
        { name = "魔力", values = { [1] = 140,[2] = 200, [3] = 300 } },
    },
}

function potentialHasItemId(list, itemId)
    itemId = tonumber(itemId) or 0
    for _, value in ipairs(list or {}) do
        if tonumber(value) == itemId then
            return true
        end
    end
    return false
end

function potentialGetStoredData(playerIndex, storageKey)
    return getStorageData(playerIndex, storageKey)
end

function potentialSaveStoredData(playerIndex, storageKey, data)
    local ok, encoded = pcall(JSON.encode, data)
    if not ok or not encoded then
        return false
    end

    Char.SetExtData(playerIndex, storageKey .. "_has", 1)
    local chunks = {}
    for index = 1, #encoded, 2000 do
        table.insert(chunks, string.sub(encoded, index, index + 1999))
    end
    Char.SetExtData(playerIndex, storageKey .. "_count", #chunks)
    for index, chunk in ipairs(chunks) do
        Char.SetExtData(playerIndex, storageKey .. "_" .. index, chunk)
    end
    return true
end

function potentialGetItemId(itemData)
    if not itemData then return 0 end
    return tonumber(itemData[tostring(CONST.道具_ID)]) or 0
end

function potentialGetItemCount(itemData)
    if not itemData then return 0 end
    local value = tonumber(itemData[tostring(CONST.道具_堆叠数)]) or 1
    return math.max(1, value)
end

function potentialSetItemCount(itemData, count)
    if itemData then
        itemData[tostring(CONST.道具_堆叠数)] = math.max(0, tonumber(count) or 0)
    end
end

function potentialEnsureData(itemData)
    if not itemData then return nil end
    if type(itemData.potential) ~= "table" then
        itemData.potential = {
            mainOpened = false,
            mainQuality = 0,
            mainEffects = {},
            addOpened = false,
            addQuality = 0,
            addEffects = {},
        }
    end
    local p = itemData.potential
    p.mainOpened = p.mainOpened == true
    p.addOpened = p.addOpened == true
    p.mainQuality = tonumber(p.mainQuality) or 0
    p.addQuality = tonumber(p.addQuality) or 0
    p.mainEffects = type(p.mainEffects) == "table" and p.mainEffects or {}
    p.addEffects = type(p.addEffects) == "table" and p.addEffects or {}
    return p
end

function potentialRollTier()
    local roll = math.random(1, 100)
    local cumulative = 0
    for tier = 1, 3 do
        cumulative = cumulative + (tonumber(potentialEffectTierWeights[tier]) or 0)
        if roll <= cumulative then
            return tier
        end
    end
    return 1
end

function potentialRandomEffects(quality)
    quality = math.max(1, math.min(4, tonumber(quality) or 1))
    local pool = potentialEffectPool[quality] or potentialEffectPool[1]
    local result = {}
    -- local used = {}

    -- while #result < 3 and #result < #pool do
        -- local index = math.random(1, #pool)
        -- if not used[index] then
            -- used[index] = true
            -- table.insert(result, pool[index])
        -- end
    -- end
    -- 三條獨立抽取：允許同一素質重複出現。
    for _ = 1, 3 do
        local effect = pool[math.random(1, #pool)]
        local tier = potentialRollTier()
        local amount = effect.values[tier] or effect.values[1] or 0
        table.insert(result, tostring(effect.name) .. "+" .. tostring(amount))
    end
    return result
end

function potentialRollQuality(currentQuality)
    currentQuality = math.max(1, math.min(4, tonumber(currentQuality) or 1))
    if currentQuality >= 4 then return 4 end
    local chance = tonumber(potentialConfig.qualityUpChance[currentQuality]) or 0
    if math.random(1, 100) <= chance then
        return currentQuality + 1
    end
    return currentQuality
end

-- 套用潛能後重建完整裝備屬性：基礎 → 潛能 → 寶石 → 強化。
function applyPotentialStats(playerIndex, itemData, slot)
    if type(itemData) == "table" then
        return rebuildItemDataStats(itemData)
    end
    if type(itemData) == "number" then
        return rebuildItemStats(playerIndex, itemData, slot)
    end
    return false
end

function potentialSendState(playerIndex, message)
    local equip = potentialGetStoredData(playerIndex, potentialEquipStorageKey)
    local tool = potentialGetStoredData(playerIndex, potentialToolStorageKey)
    local p = potentialEnsureData(equip)

    local equipHas = equip and 1 or 0
    local equipImg = equip and (tonumber(equip["1"]) or 0) or 0
    local equipLv = equip and (tonumber(equip[tostring(CONST.道具_堆叠数)]) or 0) or 0

    local toolHas = tool and 1 or 0
    local toolImg = tool and (tonumber(tool["1"]) or 0) or 0
    local toolCount = potentialGetItemCount(tool)
    local toolId = potentialGetItemId(tool)
    local toolKind = tool and potentialGetToolKind(toolId) or nil
    -- params[13] 回傳用途代碼：1主開、2附開、3主洗、4附洗。
    local toolType = 0
    if toolKind == "main_open" then toolType = 1
    elseif toolKind == "add_open" then toolType = 2
    elseif toolKind == "main_cube" then toolType = 3
    elseif toolKind == "add_cube" then toolType = 4
    end
    local goldCost = 0

    if p and tool then
		if toolKind == "main_open" then 
			if not p.mainOpened then goldCost = potentialConfig.mainOpenGold end
		elseif toolKind == "add_open" then 
			if not p.addOpened then goldCost = potentialConfig.addOpenGold end
		elseif toolKind == "main_cube" then goldCost = potentialConfig.mainCubeGold
		elseif toolKind == "add_cube" then goldCost = potentialConfig.addCubeGold
		end
    end

    Protocol.Send(playerIndex, "POTSTATE",
        tostring(equipHas), tostring(equipImg), tostring(equipLv),
        p and (p.mainOpened and "1" or "0") or "0",
        p and tostring(p.mainQuality or 0) or "0",
        p and (p.addOpened and "1" or "0") or "0",
        p and tostring(p.addQuality or 0) or "0",
        p and table.concat(p.mainEffects or {}, "|") or "",
        p and table.concat(p.addEffects or {}, "|") or "",
        tostring(toolHas), tostring(toolImg), tostring(toolCount), tostring(toolType), tostring(goldCost)
    )

    if message and message ~= "" then
		sendSystemMessage(playerIndex, tostring(message))
        -- Protocol.Send(playerIndex, "POTMSG", tostring(message))
    end
end

function potentialSerializeDataToStorage(playerIndex, storageKey, itemData, mode)
    if not itemData or type(itemData) ~= "table" then
        return false
    end

    local ok, encoded = pcall(JSON.encode, itemData)
    if not ok or not encoded then
        potentialSendState(playerIndex, "潛能物品資料序列化失敗")
        return false
    end

    clearStorage(playerIndex, storageKey)
    Char.SetExtData(playerIndex, storageKey .. "_has", 1)
    Char.SetExtData(playerIndex, storageKey .. "_img", tonumber(itemData["1"]) or 0)
    Char.SetExtData(playerIndex, storageKey .. "_lv", tonumber(itemData[tostring(CONST.道具_耐久)]) or 0)
    if mode ~= nil then
        Char.SetExtData(playerIndex, storageKey .. "_slot", mode)
    end

    local chunks = {}
    for index = 1, #encoded, 2000 do
        table.insert(chunks, string.sub(encoded, index, index + 1999))
    end
    Char.SetExtData(playerIndex, storageKey .. "_count", #chunks)
    for index, chunk in ipairs(chunks) do
        Char.SetExtData(playerIndex, storageKey .. "_" .. index, chunk)
    end
    return true
end

function potentialGetItemTypeFromData(itemData)
    if not itemData then return -1 end
    return tonumber(itemData[tostring(CONST.道具_类型)]) or -1
end

function potentialPutItem(playerIndex, slot, page, storageKey, isEquip)
    page = tonumber(page) or 1
    slot = tonumber(slot) or -1

    if hasStoredItem(playerIndex, storageKey) then
        potentialSendState(playerIndex, "該潛能格已有物品，請先取回")
        return
    end

    -- 前端傳的是「背包槽位 + 頁碼」，不是 ItemIndex。
    -- 第1頁使用角色實體背包槽位；第2頁以上使用 xbbag_ 的自訂背包槽位。
    if page > 1 then
        if slot < 0 or slot >= bagTotalSlots then
            potentialSendState(playerIndex, "潛能裝備格：背包槽位超出範圍")
            return
        end

        local raw = loadBagItem(playerIndex, slot)
        if not raw then
            potentialSendState(playerIndex, "潛能裝備格：指定背包位置沒有物品")
            return
        end

        local ok, itemData = pcall(JSON.decode, raw)
        if not ok or type(itemData) ~= "table" then
            potentialSendState(playerIndex, "潛能裝備格：背包物品資料無效")
            return
        end

        local itemType = potentialGetItemTypeFromData(itemData)
        if isEquip and (itemType < 0 or itemType > 22) then
            potentialSendState(playerIndex, "只有裝備類道具才能放入潛能裝備格")
            return
        end

        ensureStatBaseAttrsFromItemData(itemData)

        if not isEquip then
            local itemId = potentialGetItemId(itemData)
            local allowed = potentialHasItemId(potentialConfig.mainOpenItemIds, itemId)
                or potentialHasItemId(potentialConfig.mainCubeItemIds, itemId)
                or potentialHasItemId(potentialConfig.addOpenItemIds, itemId)
                or potentialHasItemId(potentialConfig.addCubeItemIds, itemId)
            if not allowed then
                potentialSendState(playerIndex, "該道具不是潛能系統指定道具")
                return
            end
        end

        if not potentialSerializeDataToStorage(playerIndex, storageKey, itemData, slot) then
            return
        end

        -- 從自訂背包移除；之後由 sendBagList 更新前端。
        saveBagItem(playerIndex, slot, nil)
        sendBagList(playerIndex)
        potentialSendState(playerIndex, isEquip and "裝備已放入潛能裝備格" or "潛能道具已放入道具格")
        return
    end

    -- 第1頁：slot 直接就是角色背包槽位。
    local realSlot = getInventorySlot(playerIndex, slot)
    local itemIndex = Char.GetItemIndex(playerIndex, realSlot)
    if not itemIndex or itemIndex < 0 then
        potentialSendState(playerIndex, "指定背包位置沒有物品")
        return
    end

    if isEquip then
        local itemType = tonumber(Item.GetData(itemIndex, CONST.道具_类型)) or -1
        if itemType < 0 or itemType > 22 then
            potentialSendState(playerIndex, "只有裝備類道具才能放入潛能裝備格")
            return
        end
    else
        local itemId = tonumber(Item.GetData(itemIndex, CONST.道具_ID)) or 0
        local allowed = potentialHasItemId(potentialConfig.mainOpenItemIds, itemId)
            or potentialHasItemId(potentialConfig.mainCubeItemIds, itemId)
            or potentialHasItemId(potentialConfig.addOpenItemIds, itemId)
            or potentialHasItemId(potentialConfig.addCubeItemIds, itemId)
        if not allowed then
            potentialSendState(playerIndex, "該道具不是潛能系統指定道具")
            return
        end
    end

    ensureStatBaseAttrsForItem(itemIndex)
    if not serializeItemForStorage(playerIndex, storageKey, itemIndex, realSlot) then
        return
    end

    local stored = getStorageData(playerIndex, storageKey)
    if isEquip then
        potentialEnsureData(stored)
        potentialSaveStoredData(playerIndex, storageKey, stored)
    end

    Char.SetItemIndex(playerIndex, realSlot, -1)
    Item.UpItem(playerIndex, realSlot)
    sendBagList(playerIndex)
    potentialSendState(playerIndex, isEquip and "裝備已放入潛能裝備格" or "潛能道具已放入道具格")
end

function potentialTakeItem(playerIndex, slot, targetPage, storageKey, isEquip)
    if not hasStoredItem(playerIndex, storageKey) then
        potentialSendState(playerIndex, "該潛能格目前沒有物品")
        return
    end

    local data = getStorageData(playerIndex, storageKey)
    local raw = getStorageJsonChunks(playerIndex, storageKey)
    if not data or not raw then
        potentialSendState(playerIndex, "潛能資料讀取失敗")
        return
    end

    targetPage = tonumber(targetPage) or 1
    local targetSlot = -1
    if targetPage > 1 then
        local bagSlot = tonumber(slot) or -1
        if bagSlot < 0 or bagSlot >= bagTotalSlots then
            potentialSendState(playerIndex, "取回位置無效")
            return
        end
        if (tonumber(Char.GetExtData(playerIndex, "xbbag_" .. bagSlot .. "_count")) or 0) > 0 then
            potentialSendState(playerIndex, "指定背包位置已有物品")
            return
        end
        local image = tonumber(data["1"]) or 0
        local count = potentialGetItemCount(data)
        local level = tonumber(data[tostring(CONST.道具_等級)]) or 0
        saveBagItem(playerIndex, bagSlot, raw, image, count, level)
        clearStorage(playerIndex, storageKey)
        sendBagList(playerIndex)
        potentialSendState(playerIndex, "已取回至指定背包位置")
        return
    end

    -- 客戶端若指定目標槽位，優先使用該空槽；否則自動尋找第1頁空格。
    local requestedSlot = tonumber(slot) or -1
    if requestedSlot >= 0 then
        local mappedSlot = getInventorySlot(playerIndex, requestedSlot)
        local requestedItemIndex = Char.GetItemIndex(playerIndex, mappedSlot)
        if not requestedItemIndex or requestedItemIndex < 0 then
            targetSlot = mappedSlot
        end
    end

    if targetSlot < 0 then
        for index = 27, 8, -1 do
            local s = getInventorySlot(playerIndex, index)
            local itemIndex = Char.GetItemIndex(playerIndex, s)
            if not itemIndex or itemIndex < 0 then
                targetSlot = s
                break
            end
        end
    end

    if targetSlot < 0 then
        potentialSendState(playerIndex, "背包已滿，無法取回")
        return
    end

    local newItemIndex = createItemFromData(playerIndex, data, targetSlot)
    if newItemIndex < 0 then
        potentialSendState(playerIndex, "建立取回物品失敗")
        return
    end

    if isEquip then
        local p = potentialEnsureData(data)
        if p then
            Item.SetExtData(newItemIndex, "potentialData", JSON.encode(p))
            applyPotentialStats(playerIndex, newItemIndex)
        end
    end

    clearStorage(playerIndex, storageKey)
    sendBagList(playerIndex)
    potentialSendState(playerIndex, "已取回潛能物品")
end

function potentialConsumeTool(playerIndex)
    local tool = potentialGetStoredData(playerIndex, potentialToolStorageKey)
    if not tool then return false end
    local count = potentialGetItemCount(tool)
    count = count - 1
    if count <= 0 then
        clearStorage(playerIndex, potentialToolStorageKey)
    else
        potentialSetItemCount(tool, count)
        potentialSaveStoredData(playerIndex, potentialToolStorageKey, tool)
    end
    return true
end

function potentialGetToolKind(toolId)
    if potentialHasItemId(potentialConfig.mainOpenItemIds, toolId) then return "main_open" end
    if potentialHasItemId(potentialConfig.mainCubeItemIds, toolId) then return "main_cube" end
    if potentialHasItemId(potentialConfig.addOpenItemIds, toolId) then return "add_open" end
    if potentialHasItemId(potentialConfig.addCubeItemIds, toolId) then return "add_cube" end
    return nil
end

function potentialOperate(playerIndex, action)
    local equip = potentialGetStoredData(playerIndex, potentialEquipStorageKey)
    local tool = potentialGetStoredData(playerIndex, potentialToolStorageKey)
    if not equip then
        potentialSendState(playerIndex, "請先放入潛能裝備")
        return
    end
    if not tool then
        potentialSendState(playerIndex, "請先放入對應潛能道具")
        return
    end

    local p = potentialEnsureData(equip)
    local toolId = potentialGetItemId(tool)
    local kind = potentialGetToolKind(toolId)
    local gold = tonumber(Char.GetData(playerIndex, CONST.对象_金币)) or 0

    if action == 263 then
        if p.mainOpened then
            potentialSendState(playerIndex, "主要潛能已開啟，請使用主要潛能方塊洗潛")
            return
        end
        if kind ~= "main_open" then
            potentialSendState(playerIndex, "目前道具不是主要潛能開啟道具")
            return
        end
        if gold < potentialConfig.mainOpenGold then
            potentialSendState(playerIndex, "金幣不足，無法開啟主要潛能")
            return
        end
        Char.AddGold(playerIndex, -potentialConfig.mainOpenGold)
        p.mainOpened = true
        p.mainQuality = 1
        p.mainEffects = potentialRandomEffects(p.mainQuality)
        ensureStatBaseAttrsFromItemData(equip)
        applyPotentialStats(playerIndex, equip)
        potentialConsumeTool(playerIndex)
        potentialSaveStoredData(playerIndex, potentialEquipStorageKey, equip)
        potentialSendState(playerIndex, "主要潛能開啟成功：" .. potentialQualityNames[p.mainQuality])
        refreshItemInfo(playerIndex)
        return
    end

    if action == 264 then
        if not p.mainOpened then
            potentialSendState(playerIndex, "請先開啟主要潛能")
            return
        end
        if kind ~= "main_cube" then
            potentialSendState(playerIndex, "目前道具不是主要潛能方塊")
            return
        end
        if gold < potentialConfig.mainCubeGold then
            potentialSendState(playerIndex, "金幣不足，無法重洗主要潛能（需要 " .. tostring(potentialConfig.mainCubeGold) .. " 金幣）")
            return
        end
        Char.AddGold(playerIndex, -potentialConfig.mainCubeGold)
        p.mainQuality = potentialRollQuality(p.mainQuality)
        p.mainEffects = potentialRandomEffects(p.mainQuality)
        ensureStatBaseAttrsFromItemData(equip)
        applyPotentialStats(playerIndex, equip)
        potentialConsumeTool(playerIndex)
        potentialSaveStoredData(playerIndex, potentialEquipStorageKey, equip)
        potentialSendState(playerIndex, "主要潛能重洗完成：" .. potentialQualityNames[p.mainQuality])
        refreshItemInfo(playerIndex)
        return
    end

    if action == 265 then
        if not p.mainOpened then
            potentialSendState(playerIndex, "請先開啟主要潛能，才能開啟附加潛能")
            return
        end
        if p.addOpened then
            potentialSendState(playerIndex, "附加潛能已開啟，請使用附加潛能方塊洗潛")
            return
        end
        if kind ~= "add_open" then
            potentialSendState(playerIndex, "目前道具不是附加潛能開啟道具")
            return
        end
        if gold < potentialConfig.addOpenGold then
            potentialSendState(playerIndex, "金幣不足，無法開啟附加潛能")
            return
        end
        Char.AddGold(playerIndex, -potentialConfig.addOpenGold)
        p.addOpened = true
        p.addQuality = 1
        p.addEffects = potentialRandomEffects(p.addQuality)
        ensureStatBaseAttrsFromItemData(equip)
        applyPotentialStats(playerIndex, equip)
        potentialConsumeTool(playerIndex)
        potentialSaveStoredData(playerIndex, potentialEquipStorageKey, equip)
        potentialSendState(playerIndex, "附加潛能開啟成功：" .. potentialQualityNames[p.addQuality])
        refreshItemInfo(playerIndex)
        return
    end

    if action == 266 then
        if not p.addOpened then
            potentialSendState(playerIndex, "請先開啟附加潛能")
            return
        end
        if kind ~= "add_cube" then
            potentialSendState(playerIndex, "目前道具不是附加潛能方塊")
            return
        end
        if gold < potentialConfig.addCubeGold then
            potentialSendState(playerIndex, "金幣不足，無法重洗附加潛能（需要 " .. tostring(potentialConfig.addCubeGold) .. " 金幣）")
            return
        end
        Char.AddGold(playerIndex, -potentialConfig.addCubeGold)
        p.addQuality = potentialRollQuality(p.addQuality)
        p.addEffects = potentialRandomEffects(p.addQuality)
        ensureStatBaseAttrsFromItemData(equip)
        applyPotentialStats(playerIndex, equip)
        potentialConsumeTool(playerIndex)
        potentialSaveStoredData(playerIndex, potentialEquipStorageKey, equip)
        potentialSendState(playerIndex, "附加潛能重洗完成：" .. potentialQualityNames[p.addQuality])
        refreshItemInfo(playerIndex)
        return
    end
end

-- 取得潛能裝備格的完整懸停 Tooltip 資料。
-- 269：只讀 xpot_equip，不改變任何潛能/裝備狀態。
function sendPotentialHoverInfo(playerIndex)
    local itemData = potentialGetStoredData(playerIndex, potentialEquipStorageKey)
    if not itemData then
        Protocol.Send(playerIndex, "POTINFO", "0")
        return
    end
    local itemType = tonumber(itemData[tostring(CONST.道具_类型)]) or -1
    if itemType < 0 or itemType > 22 then
        Protocol.Send(playerIndex, "POTINFO", "0")
        return
    end
    local image = tonumber(itemData["1"]) or 0
    local p = potentialEnsureData(itemData)
    sendPotentialCacheXBCENTER(playerIndex, itemData)
    local enhanceLevel = 0
    if type(itemData._itemExt) == "table" and type(itemData._itemExt.starEnhance) == "table" then
        enhanceLevel = tonumber(itemData._itemExt.starEnhance.level) or 0
    end
    local text, durab, itemTypeText, setText, gemText = formatStoredItemInfo(playerIndex, itemData)
    Protocol.Send(playerIndex, "POTINFO", tostring(image), tostring(enhanceLevel), tostring(text or ""), tostring(durab or ""), tostring(itemTypeText or ""), tostring(setText or ""), tostring(gemText or ""), tostring(p.mainOpened and (tonumber(p.mainQuality) or 0) or 0), tostring(p.addOpened and (tonumber(p.addQuality) or 0) or 0))
end

function queryPotentialState(playerIndex)
    potentialSendState(playerIndex)
end

function handleXBProtocol(fd, head, data)
	local player = Protocol.GetCharIndexFromFd(fd)

	if not player or player < 0 then
		return 1
	end

	local numericValue = tonumber(data[1]) or -1
	local numericValue2 = tonumber(data[2]) or -1

	if numericValue == 0 then
		sortBag(player)

		return 1
	end

	if numericValue == 201 then
		putEnhanceItem(player, numericValue2, tonumber(data[3]) or 1)

		return 1
	end

	if numericValue == 202 then
		takeEnhanceItem(player, numericValue2, tonumber(data[3]) or 1)

		return 1
	end

	if numericValue == 203 then
		openEnhanceUI(player)

		return 1
	end

	if numericValue == 204 then
		enhanceEquipment(player)

		return 1
	end

	if numericValue == 205 then
		toggleEnhanceSuccessBoost(player)

		return 1
	end

	if numericValue == 206 then
		queryEnhanceSuccessBoost(player)

		return 1
	end

	if numericValue == 207 then
		moveBagItem(player, numericValue2, tonumber(data[3]) or -1)

		return 1
	end

	if numericValue == 208 then
		equipItem(player, numericValue2, tonumber(data[3]) or -1, tonumber(data[4]) or 1)

		return 1
	end

	if numericValue == 209 then
		unequipItem(player, numericValue2, tonumber(data[3]) or -1, tonumber(data[4]) or 1)

		return 1
	end

	if numericValue == 210 then
		sendBagList(player)
		sendEquipmentList(player)

		return 1
	end

	if numericValue == 211 then
		swapEquipment(player, numericValue2, tonumber(data[3]) or -1)

		return 1
	end

	if numericValue == 212 then
		refreshEquipment(player, numericValue2)

		return 1
	end

	if numericValue == 213 then
		queryEquipmentInfo(player, numericValue2)

		return 1
	end

	if numericValue == 214 then
		refreshItemInfo(player)

		return 1
	end

	if numericValue == 215 then
		dropBagItem(player, numericValue2)

		return 1
	end

	if numericValue == 216 then
		queryEnhanceResult(player, numericValue2)

		return 1
	end

	if numericValue == 217 then
		queryEnhanceCost(player, numericValue2)

		return 1
	end

	if numericValue == 218 then
		depositToBank(player, numericValue2, tonumber(data[3]), tonumber(data[4]))

		return 1
	end

	if numericValue == 219 then
		deleteBagItem(player, numericValue2, tonumber(data[3]) or 0)

		return 1
	end

	if numericValue == 220 then
		queryBankPage(player, numericValue2)

		return 1
	end

	if numericValue == 221 then
		withdrawFromBank(player, numericValue2, tonumber(data[3]))

		return 1
	end

	if numericValue == 222 then
		sortBank(player, numericValue2)

		return 1
	end

	if numericValue == 223 then
		moveBankItem(player, numericValue2, tonumber(data[3]) or -1)

		return 1
	end

	if numericValue == 224 then
		moveBagItemToBank(player, numericValue2, tonumber(data[3]) or -1)

		return 1
	end

	if numericValue == 225 then
		depositBagItem(player, numericValue2, tonumber(data[3]) or -1)

		return 1
	end

	if numericValue == 226 then
		withdrawBagItem(player, numericValue2)

		return 1
	end

	if numericValue == 227 then
		moveBagSlot(player, numericValue2, tonumber(data[3]) or -1)

		return 1
	end

	if numericValue == 228 then
		moveBankSlot(player, numericValue2, tonumber(data[3]) or -1)

		return 1
	end

	if numericValue == 229 then
		moveBankItemToBag(player, numericValue2)

		return 1
	end

	if numericValue == 230 then
		moveBankPageSlot(player, numericValue2, tonumber(data[3]) or -1, tonumber(data[4]) or 0)

		return 1
	end

	if numericValue == 231 then
		sortBagItems(player)

		return 1
	end

	if numericValue == 232 then
		moveBagPageSlot(player, numericValue2, tonumber(data[3]) or -1, tonumber(data[4]) or 1)

		return 1
	end

	if numericValue == 240 then
		repairAllEquipment(player)

		return 1
	end

	if numericValue == 241 then
		queryPartyInfo(player)

		return 1
	end

	if numericValue == 242 then
		kickPartyMember(player, numericValue2)

		return 1
	end

	if numericValue == 243 then
		queryPetList(player, numericValue2)

		return 1
	end

	if numericValue == 245 then
		feedTarget(player, numericValue2, tonumber(data[3]) or 0, tonumber(data[4]) or -1, tonumber(data[5]) or 1, tonumber(data[6]) or -1)

		return 1
	end

	if numericValue == 250 then
		putSynthesisItem(player, numericValue2, tonumber(data[3]) or 1, equipStorageKey, "equip", "鑲嵌裝備格")

		return 1
	end

	if numericValue == 251 then
		putSynthesisItem(player, numericValue2, tonumber(data[3]) or 1, gemStorageKey, "gem", "鑲嵌寶石格")

		return 1
	end

	if numericValue == 252 then
		takeSynthesisItem(player, numericValue2, tonumber(data[3]) or 1, equipStorageKey, "鑲嵌裝備格")

		return 1
	end

	if numericValue == 253 then
		takeSynthesisItem(player, numericValue2, tonumber(data[3]) or 1, gemStorageKey, "鑲嵌寶石格")

		return 1
	end

	if numericValue == 254 then
		takeSynthesisItem(player, numericValue2, tonumber(data[3]) or 1, resultStorageKey, "合成結果格")

		return 1
	end

	if numericValue == 255 then
		synthesizeGemIntoEquipment(player)

		return 1
	end

	if numericValue == 256 then
		refreshSynthesisUI(player)

		return 1
	end

	if numericValue == 257 then
		putSynthesisItem(player, numericValue2, tonumber(data[3]) or 1, resultStorageKey, "result", "合成結果格")

		return 1
	end

	-- 258：使用既有 XBCENTER 回傳鑲嵌/合成裝備格的潛能 Tooltip 快取。
	-- arg2 = 1 鑲嵌裝備格，2 合成結果格。
	if numericValue == 258 then
		local cacheType = numericValue2
		if cacheType == 1 then
			sendPotentialCacheXBCENTER(player, getStorageData(player, equipStorageKey), "inlay_equip", "装备格")
		elseif cacheType == 2 then
			sendPotentialCacheXBCENTER(player, getStorageData(player, resultStorageKey), "inlay_result", "合成格")
		else
			sendXBProtocol(player, 3, 0, 0, "", "", "", "", "", "", 0, 0, "", "")
		end
		return 1
	end

	-- 260：查詢潛能狀態。
	if numericValue == 260 then
		queryPotentialState(player)
		return 1
	end

	if numericValue == 261 then
		potentialPutItem(player, numericValue2, tonumber(data[3]) or 1, potentialEquipStorageKey, true)
		return 1
	end

	if numericValue == 262 then
		potentialPutItem(player, numericValue2, tonumber(data[3]) or 1, potentialToolStorageKey, false)
		return 1
	end

	if numericValue == 263 or numericValue == 264 or numericValue == 265 or numericValue == 266 then
		potentialOperate(player, numericValue)
		return 1
	end

	-- 267：取回潜能装备。
	-- 参数：可选目标背包槽位 + 目标页码；不传时自动放回第1页可用背包格。
	if numericValue == 267 then
		potentialTakeItem(player, numericValue2, tonumber(data[3]) or 1, potentialEquipStorageKey, true)
		return 1
	end

	-- 268：取回潜能道具。
	-- 参数：可选目标背包槽位 + 目标页码；不传时自动放回第1页可用背包格。
	if numericValue == 268 then
		potentialTakeItem(player, numericValue2, tonumber(data[3]) or 1, potentialToolStorageKey, false)
		return 1
	end
	-- 269：潛能裝備格懸停詳細資料。
	if numericValue == 269 then
		sendPotentialHoverInfo(player)
		return 1
	end

	sendSystemMessage(player, "未定義的 CUSTOMXB 參數：" .. tostring(numericValue))

	return 1
end

_G.handleXBProtocol = handleXBProtocol

function Module.onLoginEvent(fd, protocol)
	queryEnhanceSlot(protocol)
	refreshSynthesisUI(protocol)
	queryPotentialState(protocol)
	sendBagList(protocol)
	sendEquipmentList(protocol)
	sendBankList(protocol)
end

function Module.onLoad(fd)
	Protocol.OnRecv(nil, "handleXBProtocol", "CUSTOMXB")
	math.randomseed(os.time())
	loadJobAndItemSetData()
	loadSuitSetData()
	loadGemMaterialData()
	fd:regCallback("LoginEvent", function(fd)
		queryEnhanceSlot(fd)
		refreshSynthesisUI(fd)
		sendBagList(fd)
		sendEquipmentList(fd)
		sendBankList(fd)
	end)
end

function Module.onUnload(fd)
	return
end

return Module
