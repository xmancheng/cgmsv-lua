local module = ModuleBase:createModule('heroesAI')
local _ = require "lua/Modules/underscore"
local JSON = require "lua/Modules/json"
--local heroesFn = getModule("heroesFn")
local sgModule = getModule("setterGetter")
local skillInfo = dofile("lua/Modules/autoBattleParams.lua")
local function getHp(charIndex)
	return Char.GetData(charIndex, CONST.对象_血)
end
local function getMaxHp(charIndex)
	return Char.GetData(charIndex, CONST.对象_最大血)
end
local function getMp(charIndex)
	return Char.GetData(charIndex, CONST.对象_魔)
end
local function getMaxMp(charIndex)
	return Char.GetData(charIndex, CONST.对象_最大魔)
end

function getEntryPositionBySlot(battleIndex, slot)
	local cIndex = Battle.GetPlayer(battleIndex, slot);
	if cIndex >=0 then
		local pos = Battle.GetPos(battleIndex, cIndex);
		return pos;
	else
		print('获取charIndex失败: ', cIndex);
		return -5;
	end
end

local function oppositeSide(side)
	if side == 0 then
		return 1
	else
		return 0
	end
end

-- NOTE 循环己方 获得己方的所有单位Index
local function getAttackerSide(charIndex, side, battleIndex)
	local slotTable = {}
	for slot = side * 10 + 0, side * 10 + 9 do
		--  print("slot",slot)
		local charIndex = Battle.GetPlayer(battleIndex, slot)
		--  print("charIndex",charIndex)
		if (charIndex >= 0) then
			table.insert(slotTable, charIndex)
		end
	end
	return slotTable
end



-- NOTE 循环对方 获得对方的所有单位Index
local function getDeffenderSide(charIndex, attSide, battleIndex)
	local side = oppositeSide(attSide)
	local slotTable = {}
	for slot = side * 10 + 0, side * 10 + 9 do
		--  print("slot",slot)
		local charIndex = Battle.GetPlayer(battleIndex, slot)
		--  print("charIndex",charIndex)
		if (charIndex >= 0) then
			table.insert(slotTable, charIndex)
		end
	end
	return slotTable
end
-- NOTE 是否 中了某个状态
--   return :true false
local function hasGotStatus(charIndex, side, battleIndex, statusKey)
	return function(charIndex, side, battleIndex)
		local chars = getAttackerSide(charIndex, side, battleIndex)
		return _.any(chars, function(charIndex)
			return Char.GetData(charIndex, statusKey) == 1
		end)
	end
end

-- NOTE 中了异常的人数
--   return: num
local function gotAnyStatusNum(charIndex, side, battleIndex)
	local chars = getAttackerSide(charIndex, side, battleIndex)
	local statusChars = _.select(chars, function(charIndex)
		return Char.GetData(charIndex, CONST.对象_ModPoison) > 1 or
			Char.GetData(charIndex, CONST.对象_ModSleep) > 1 or
			Char.GetData(charIndex, CONST.对象_ModStone) > 1 or
			Char.GetData(charIndex, CONST.对象_ModDrunk) > 1 or
			Char.GetData(charIndex, CONST.对象_ModConfusion) > 1 or
			Char.GetData(charIndex, CONST.对象_ModAmnesia) > 1
	end)

	return #statusChars;
end



-- NOTE 判断 人数
--   return :true false
local function livesNumEq(charIndex, side, battleIndex, num)
	return function(charIndex, side, battleIndex)
		local chars = getAttackerSide(charIndex, side, battleIndex)
		local liveChars = _.select(chars, function(charIndex)
			return Char.GetData(charIndex, CONST.对象_战死) == 0
		end)
		return #liveChars == num
	end
end
-- NOTE 获得己方存活人数
--  return  num
local function livesNum(charIndex, side, battleIndex)
	local chars = getAttackerSide(charIndex, side, battleIndex)
	local liveChars = _.select(chars, function(charIndex)
		return Char.GetData(charIndex, CONST.对象_战死) == 0
	end)
	return #liveChars
end

-- NOTE 获得己方战死人物数量
local function deadPlayerNum(charIndex, side, battleIndex)
	local chars = getAttackerSide(charIndex, side, battleIndex)
	local liveChars = _.select(chars, function(charIndex)
		return Char.GetData(charIndex, CONST.对象_战死) == 1 and Char.GetData(charIndex, CONST.对象_类型) == CONST.对象类型_人
	end)
	return #liveChars
end

-- NOTE 获得己方战死人数
local function deadNum(charIndex, side, battleIndex)
	local chars = getAttackerSide(charIndex, side, battleIndex)
	local liveChars = _.select(chars, function(charIndex)
		return Char.GetData(charIndex, CONST.对象_战死) == 1
	end)
	return #liveChars
end


-- NOTE 获得对方人数
--  return  num
local function livesDefNum(charIndex, side, battleIndex)
	local chars = getDeffenderSide(charIndex, side, battleIndex)
	local liveChars = _.select(chars, function(charIndex)
		return Char.GetData(charIndex, CONST.对象_战死) == 0
	end)
	return #liveChars
end


-- NOTE 获得 平均等级
--  return num
local function averageLevel(charIndexTable)
	local totalLevel = _.reduce(charIndexTable, 0, function(count, charIndex)
		local level = Char.GetData(charIndex, CONST.对象_等级)
		return count + level
	end)
	return totalLevel / #charIndexTable
end

-- NOTE 己方 hp < x 的超过  y人
local function partyLowerHPNum(charIndex, side, battleIndex, hpRatio, num)
	local chars = getAttackerSide(charIndex, side, battleIndex)
	local count = 0;
	for i = 1, #chars do
		local cIndex = chars[i]
		if getHp(cIndex) / getMaxHp(cIndex) < hpRatio then
			count = count + 1
		end
		if count > num then
			return true
		end
	end
	return false
end


-- SECTION 条件
module.conditions = {
	-- NOTE 自身 无条件释放
	['0'] = {
		comment = "無上述條件",
		fn = function(charIndex) return true end
	},
	-- NOTE 自身hp =100%
	['4'] = {
		comment = "自身hp=100%",
		fn = function(charIndex) return getHp(charIndex) == getMaxHp(charIndex) end
	},
	-- NOTE 自身hp > 75%
	['5'] = {
		comment = "自身hp>75%",
		fn = function(charIndex) return getHp(charIndex) / getMaxHp(charIndex) > 0.75 end
	},
	-- NOTE 自身hp > 50%
	['6'] = {
		comment = "自身hp>50%",
		fn = function(charIndex) return getHp(charIndex) / getMaxHp(charIndex) > 0.5 end
	},
	-- NOTE 自身hp < 50%
	['7'] = {
		comment = "自身hp<50%",
		fn = function(charIndex) return getHp(charIndex) / getMaxHp(charIndex) < 0.5 end
	},
	-- NOTE 自身hp < 25%
	['8'] = {
		comment = "自身hp<30%",
		fn = function(charIndex) return getHp(charIndex) / getMaxHp(charIndex) < 0.3 end
	},
	-- NOTE 自身 mp>=0.5
	['9'] = {
		comment = "自身mp>=50%",
		fn = function(charIndex) return getMp(charIndex) / getMaxMp(charIndex) >= 0.5 end
	},
	-- NOTE 自身mp<50%
	['10'] = {
		comment = "自身mp<50%",
		fn = function(charIndex) return getMp(charIndex) / getMaxMp(charIndex) < 0.5 end
	},

	-- NOTE 己方阵营中有中毒单位
	["13"] = {
		comment = "己方有中毒單位",
		fn = hasGotStatus(CONST.对象_ModPoison)
	},
	-- NOTE 己方阵营中有混乱单位
	["14"] = {
		comment = "己方有混亂單位",
		fn = hasGotStatus(CONST.对象_ModConfusion)
	},
	-- NOTE 己方阵营中有石化单位
	["15"] = {
		comment = "己方有石化單位",
		fn = hasGotStatus(CONST.对象_ModStone)
	},
	-- NOTE 己方阵营中有睡眠单位
	["16"] = {
		comment = "己方有睡眠單位",
		fn = hasGotStatus(CONST.对象_ModSleep)
	},
	-- NOTE 己方阵营中有酒醉单位
	["17"] = {
		comment = "己方有酒醉單位",
		fn = hasGotStatus(CONST.对象_ModDrunk)
	},
	-- NOTE 己方阵营中有遗忘单位
	["18"] = {
		comment = "己方有遺忘單位",
		fn = hasGotStatus(CONST.对象_ModAmnesia)
	},
	-- NOTE 己方阵营中存活数量0
	["19"] = {
		comment = "己方存活為0",
		fn = livesNumEq(charIndex, side, battleIndex, 0)
	},
	-- NOTE 己方阵营中存活数量1
	["20"] = {
		comment = "己方存活為1",
		fn = livesNumEq(charIndex, side, battleIndex, 1)
	},
	-- NOTE 己方阵营中存活数量2
	["21"] = {
		comment = "己方存活為1",
		fn = livesNumEq(charIndex, side, battleIndex, 2)
	},
	-- NOTE 己方阵营中存活数量 ==10
	["22"] = {
		comment = "己方存活為10",
		fn = livesNumEq(charIndex, side, battleIndex, 10)
	},
	-- NOTE 己方阵营中存活数量>=8
	["23"] = {
		comment = "己方存活>=8",
		fn = function(charIndex, side, battleIndex) return livesNum(charIndex, side, battleIndex) >= 8 end
	},
	-- NOTE 己方阵营中存活数量>=5
	["24"] = {
		comment = "己方存活>=5",
		fn = function(charIndex, side, battleIndex) return livesNum(charIndex, side, battleIndex) >= 5 end
	},
	-- NOTE 己方阵营中存活数量<5
	["25"] = {
		comment = "己方存活<5",
		fn = function(charIndex, side, battleIndex) return livesNum(charIndex, side, battleIndex) < 5 end
	},
	-- NOTE 己方阵营中存活数量<4
	["26"] = {
		comment = "己方存活<4",
		fn = function(charIndex, side, battleIndex) return livesNum(charIndex, side, battleIndex) < 4 end
	},
	-- NOTE 己方阵营中存活数量<=1
	["27"] = {
		comment = "己方存活<=1",
		fn = function(charIndex, side, battleIndex) return livesNum(charIndex, side, battleIndex) <= 1 end
	},
	-- NOTE 己方平均等级 < 敌方
	["29"] = {
		comment = "己方平均等級<敵方",
		fn = function(charIndex, side, battleIndex)
			return averageLevel(getAttackerSide(charIndex, side, battleIndex)) <
				averageLevel(getDeffenderSide(charIndex, side, battleIndex))
		end
	},
	-- NOTE 己方平均等级 >= 敌方
	["30"] = {
		comment = "己方平均等級>=敵方",
		fn = function(charIndex, side, battleIndex)
			return averageLevel(getAttackerSide(charIndex, side, battleIndex)) >=
				averageLevel(getDeffenderSide(charIndex, side, battleIndex))
		end
	},
	-- NOTE 对方某一单位hp ==100%
	["31"] = {
		comment = "對方某單位hp=100%",
		fn = function(charIndex, side, battleIndex)
			local defChars = getDeffenderSide(charIndex, side, battleIndex)
			return _.any(defChars, function(charIndex)
				return Char.GetData(charIndex, CONST.对象_血) / Char.GetData(charIndex, CONST.对象_最大血) == 1
			end)
		end
	},
	-- NOTE 对方 某一单位hp >75%
	["32"] = {
		comment = "對方某單位>75%",
		fn = function(charIndex, side, battleIndex)
			local defChars = getDeffenderSide(charIndex, side, battleIndex)
			return _.any(defChars, function(charIndex)
				return Char.GetData(charIndex, CONST.对象_血) / Char.GetData(charIndex, CONST.对象_最大血) > 0.75
			end)
		end
	},
	-- NOTE 对方 某一单位hp >50%
	["33"] = {
		comment = "對方某單位hp>50%",
		fn = function(charIndex, side, battleIndex)
			local defChars = getDeffenderSide(charIndex, side, battleIndex)
			return _.any(defChars, function(charIndex)
				return Char.GetData(charIndex, CONST.对象_血) / Char.GetData(charIndex, CONST.对象_最大血) > 0.5
			end)
		end
	},
	-- NOTE 对方 某一单位hp <50%
	["34"] = {
		comment = "對方某單位hp<50%",
		fn = function(charIndex, side, battleIndex)
			local defChars = getDeffenderSide(charIndex, side, battleIndex)

			return _.any(defChars, function(charIndex)
				return Char.GetData(charIndex, CONST.对象_血) / Char.GetData(charIndex, CONST.对象_最大血) < 0.5
			end)
		end
	},
	-- NOTE 对方 某一单位hp <25%
	["35"] = {
		comment = "對方某單位hp<25%",
		fn = function(charIndex, side, battleIndex)
			local defChars = getDeffenderSide(charIndex, side, battleIndex)
			return _.any(defChars, function(charIndex)
				return Char.GetData(charIndex, CONST.对象_血) / Char.GetData(charIndex, CONST.对象_最大血) < 0.25
			end)
		end
	},
	-- NOTE 对方某一单位mp>50且<75%
	["36"] = {
		comment = "對方某一單位mp>50且<75%",
		fn = function(charIndex, side, battleIndex)
			local defChars = getDeffenderSide(charIndex, side, battleIndex)
			return _.any(defChars, function(charIndex)
				local mp = Char.GetData(charIndex, CONST.对象_魔)
				local mpRatio = Char.GetData(charIndex, CONST.对象_魔) / Char.GetData(charIndex, CONST.对象_最大魔)
				local name = Char.GetData(charIndex, CONST.对象_名字)
				if mp >= 50 and mpRatio <= 0.75 then
					-- print(name ..' >> ' .. mp .. ' : ' .. mpRatio)
				end
				return mp >= 50 and mpRatio <= 0.75
			end)
		end
	},
	-- NOTE 第一回合
	['54'] = {
		comment = "第一回合",
		fn = function(charIndex, side, battleIndex) return Battle.GetTurn(battleIndex) == 0 end
	},
	-- NOTE 奇数回合
	['55'] = {
		comment = "奇數回合",
		fn = function(charIndex, side, battleIndex) return math.fmod(Battle.GetTurn(battleIndex) + 1, 2) == 1 end
	},
	-- NOTE 偶数回合
	['56'] = {
		comment = "偶數回合",
		fn = function(charIndex, side, battleIndex) return math.fmod(Battle.GetTurn(battleIndex) + 1, 2) == 0 end
	},
	-- NOTE 间隔2回合
	['57'] = {
		comment = "間隔了2回合",
		fn = function(charIndex, side, battleIndex) return math.fmod(Battle.GetTurn(battleIndex), 2) == 0 end
	},
	-- NOTE 间隔3回合
	['58'] = {
		comment = "間隔了3回合",
		fn = function(charIndex, side, battleIndex) return math.fmod(Battle.GetTurn(battleIndex), 3) == 0 end
	},
	-- NOTE 间隔4回合
	['59'] = {
		comment = "間隔了4回合",
		fn = function(charIndex, side, battleIndex) return math.fmod(Battle.GetTurn(battleIndex), 4) == 0 end
	},
	-- NOTE 间隔5回合
	['60'] = {
		comment = "間隔了5回合",
		fn = function(charIndex, side, battleIndex) return math.fmod(Battle.GetTurn(battleIndex), 5) == 0 end
	},
	-- NOTE 间隔6回合
	['61'] = {
		comment = "間隔了6回合",
		fn = function(charIndex, side, battleIndex) return math.fmod(Battle.GetTurn(battleIndex), 6) == 0 end
	},
	-- NOTE 间隔7回合
	['62'] = {
		comment = "間隔了7回合",
		fn = function(charIndex, side, battleIndex) return math.fmod(Battle.GetTurn(battleIndex), 7) == 0 end
	},
	-- NOTE 间隔8回合
	['63'] = {
		comment = "間隔了8回合",
		fn = function(charIndex, side, battleIndex) return math.fmod(Battle.GetTurn(battleIndex), 8) == 0 end
	},
	-- NOTE 间隔9回合
	['64'] = {
		comment = "間隔了9回合",
		fn = function(charIndex, side, battleIndex) return math.fmod(Battle.GetTurn(battleIndex), 9) == 0 end
	},
	-- NOTE 间隔10回合
	['65'] = {
		comment = "間隔了10回合",
		fn = function(charIndex, side, battleIndex) return math.fmod(Battle.GetTurn(battleIndex), 10) == 0 end
	},
	-- NOTE 间隔11回合
	['66'] = {
		comment = "間隔了11回合",
		fn = function(charIndex, side, battleIndex) return math.fmod(Battle.GetTurn(battleIndex), 11) == 0 end
	},
	-- NOTE 间隔12回合
	['67'] = {
		comment = "間隔了12回合",
		fn = function(charIndex, side, battleIndex) return math.fmod(Battle.GetTurn(battleIndex), 12) == 0 end
	},
	-- NOTE 对方只有一个存活
	["82"] = {
		comment = "對方只有一個存活",
		fn = function(charIndex, side, battleIndex) return livesDefNum(charIndex, side, battleIndex) == 1 end
	},
	-- NOTE 对方存活 >1
	["83"] = {
		comment = "對方存活數>1",
		fn = function(charIndex, side, battleIndex) return livesDefNum(charIndex, side, battleIndex) >= 1 end
	},
	-- NOTE 对方存活 >2
	["84"] = {
		comment = "對方存活數>2",
		fn = function(charIndex, side, battleIndex) return livesDefNum(charIndex, side, battleIndex) > 2 end
	},
	-- NOTE 对方存活 >3
	["85"] = {
		comment = "對方存活數>3",
		fn = function(charIndex, side, battleIndex) return livesDefNum(charIndex, side, battleIndex) > 3 end
	},
	-- NOTE 对方存活 >5
	["86"] = {
		comment = "對方存活數>5",
		fn = function(charIndex, side, battleIndex) return livesDefNum(charIndex, side, battleIndex) > 5 end
	},
	-- NOTE 对方存活 >6
	["87"] = {
		comment = "對方存活數>6",
		fn = function(charIndex, side, battleIndex) return livesDefNum(charIndex, side, battleIndex) > 6 end
	},

	-- NOTE 第一回合
	["89"] = {
		comment = "是第一回合",
		fn = function(charIndex, side, battleIndex) return Battle.GetTurn(battleIndex) == 0 end
	},


	-- --  己方 mp<0.25
	-- ['90']= function(charIndex) return getMp(charIndex)/getMaxMp(charIndex)<0.25 end,
	-- --  己方 mp<0.15
	-- ['91']= function(charIndex) return getMp(charIndex)/getMaxMp(charIndex)<0.15 end,
	-- --  己方 mp<0.05
	-- ['92']= function(charIndex) return getMp(charIndex)/getMaxMp(charIndex)<0.05 end,
	-- NOTE 己方HP<50%超过5人
	["93"] = {
		comment = "己方HP<50%超過5人",
		fn = function(charIndex, side, battleIndex) return partyLowerHPNum(charIndex, side, battleIndex, 0.5, 5) end
	},
	-- NOTE 己方HP<50%超过4人
	["94"] = {
		comment = "己方HP<50%超過4人",
		fn = function(charIndex, side, battleIndex) return partyLowerHPNum(charIndex, side, battleIndex, 0.5, 4) end
	},
	-- NOTE 己方HP<75%超过5人
	["95"] = {
		comment = "己方HP<75%超過5人",
		fn = function(charIndex, side, battleIndex) return partyLowerHPNum(charIndex, side, battleIndex, 0.75, 5) end
	},
	-- NOTE 己方HP<75%超过4人
	["96"] = {
		comment = "己方HP<75%超過4人",
		fn = function(charIndex, side, battleIndex) return partyLowerHPNum(charIndex, side, battleIndex, 0.75, 4) end
	},
	-- NOTE 己方有人物战死
	["97"] = {
		comment = "己方有人物戰死",
		fn = function(charIndex, side, battleIndex) return deadPlayerNum(charIndex, side, battleIndex) >= 1 end
	},
	["98"] = {
		comment = "己方有單位戰死",
		fn = function(charIndex, side, battleIndex) return deadNum(charIndex, side, battleIndex) >= 1 end
	},
	-- NOTE 对方存活 <=8
	["99"] = {
		comment = "對方存活數<=8",
		fn = function(charIndex, side, battleIndex) return livesDefNum(charIndex, side, battleIndex) <= 8 end
	},
	-- NOTE 对方存活 <=5
	["100"] = {
		comment = "對方存活數<=5",
		fn = function(charIndex, side, battleIndex) return livesDefNum(charIndex, side, battleIndex) <= 5 end
	},
	-- NOTE 对方存活 <=4
	["101"] = {
		comment = "對方存活數<=4",
		fn = function(charIndex, side, battleIndex) return livesDefNum(charIndex, side, battleIndex) <= 4 end
	},
	-- NOTE 对方存活 <=3
	["102"] = {
		comment = "對方存活數<=3",
		fn = function(charIndex, side, battleIndex) return livesDefNum(charIndex, side, battleIndex) <= 3 end
	},
	-- NOTE 对方存活 <=2
	["103"] = {
		comment = "對方存活數<=2",
		fn = function(charIndex, side, battleIndex) return livesDefNum(charIndex, side, battleIndex) <= 2 end
	},
	-- NOTE 对方存活 <=1
	["104"] = {
		comment = "對方存活數<=1",
		fn = function(charIndex, side, battleIndex) return livesDefNum(charIndex, side, battleIndex) <= 1 end
	},
	--NOTE 己方HP<30%超过0人
	["105"] = {
		comment = "己方HP<30%>=1人",
		fn = function(charIndex, side, battleIndex) return partyLowerHPNum(charIndex, side, battleIndex, 0.3, 0) end
	},
	--NOTE 己方HP<40%超过0人
	["106"] = {
		comment = "己方HP<40%>=1人",
		fn = function(charIndex, side, battleIndex) return partyLowerHPNum(charIndex, side, battleIndex, 0.4, 0) end
	},
	--NOTE 己方HP<40%超过3人
	["107"] = {
		comment = "己方HP<40%>=2人",
		fn = function(charIndex, side, battleIndex) return partyLowerHPNum(charIndex, side, battleIndex, 0.4, 2) end
	},
	--NOTE 己方HP<50%超过1人
	["108"] = {
		comment = "己方HP<50%>=1人",
		fn = function(charIndex, side, battleIndex) return partyLowerHPNum(charIndex, side, battleIndex, 0.5, 0) end
	},
	-- NOTE 己方中异常人数>=1
	['201'] = {
		comment = "己方中異常人數>=1",
		fn = function(charIndex, side, battleIndex) return gotAnyStatusNum(charIndex, side, battleIndex) >= 1 end
	},
	-- NOTE 己方中异常人数>=3
	['202'] = {
		comment = "己方中異常人數>=3",
		fn = function(charIndex, side, battleIndex) return gotAnyStatusNum(charIndex, side, battleIndex) >= 3 end
	},
	-- NOTE 己方中异常人数>=5
	['203'] = {
		comment = "己方中異常人數>=5",
		fn = function(charIndex, side, battleIndex) return gotAnyStatusNum(charIndex, side, battleIndex) >= 5 end
	},
}
-- !SECTION


-- NOTE target 获取—— 判断 range 为 2，3 的情况
local function getTargetWithRange23(side, range)
	local allTable = {
		[1] = 40, [2] = 41, ['all'] = 42
	}
	if range == 3 then
		return 42
	end
	if range == 2 then
		return allTable[side + 1]
	end
	return nil
end



-- NOTE 随机目标
-- side 0 是下方， 1 是上方
-- range: 0:single,1: range ,2: sideAll 3. whole
local randomTarget = _.wrap(getTargetWithRange23, function(func, side, battleIndex, range)
	local isRange23 = func(side, range)
	if isRange23 ~= nil then
		return isRange23
	end

	local slotTable = {}

	for slot = side * 10 + 0, side * 10 + 9 do
		local charIndex = Battle.GetPlayer(battleIndex, slot)
		if (charIndex >= 0) then
			table.insert(slotTable, slot)
		end
	end

	local randomSlot = slotTable[NLG.Rand(1, #slotTable)]
	-- 获得真实位置
	local result = getEntryPositionBySlot(battleIndex, randomSlot)
	if range == 0 then
		return result
	end
	if range == 1 then
		return result + 20
	end
	return result
end)



-- NOTE 血最多的
local findMostHp = _.wrap(getTargetWithRange23, function(func, side, battleIndex, range)
	local isRange23 = func(side, range)
	if isRange23 ~= nil then
		return isRange23
	end

	local tagHp = nil;
	local returnSlot;
	for slot = side * 10 + 0, side * 10 + 9 do
		local charIndex = Battle.GetPlayer(battleIndex, slot)
		if (charIndex >= 0) then
			local hp = Char.GetData(charIndex, CONST.对象_血)
			if tagHp == nil then
				tagHp = hp
				returnSlot = slot
			elseif hp > tagHp then
				tagHp = hp;
				returnSlot = slot
			end
		end
	end
	-- 获得真实位置
	local result = getEntryPositionBySlot(battleIndex, returnSlot)
	if range == 0 then
		return result
	end
	if range == 1 then
		return result + 20
	end
	return result
end)
-- NOTE 血最少的
local findLeastHp = _.wrap(getTargetWithRange23, function(func, side, battleIndex, range)
	local isRange23 = func(side, range)
	if isRange23 ~= nil then
		return isRange23
	end

	local tagHp = nil;
	local returnSlot;
	for slot = side * 10 + 0, side * 10 + 9 do
		local charIndex = Battle.GetPlayer(battleIndex, slot)
		if (charIndex >= 0) then
			local hp = Char.GetData(charIndex, CONST.对象_血)
			if tagHp == nil then
				tagHp = hp
				returnSlot = slot
			elseif hp < tagHp then
				tagHp = hp;
				returnSlot = slot
			end
		end
	end
	-- 获得真实位置
	local result = getEntryPositionBySlot(battleIndex, returnSlot)
	if range == 0 then
		return result
	end
	if range == 1 then
		return result + 20
	end
	return result
end)
-- NOTE 血量占比最低的
local findLeastHpRatio = _.wrap(getTargetWithRange23, function(func, side, battleIndex, range)
	local isRange23 = func(side, range)
	if isRange23 ~= nil then
		return isRange23
	end

	local tagHp = nil;
	local returnSlot;
	for slot = side * 10 + 0, side * 10 + 9 do
		local charIndex = Battle.GetPlayer(battleIndex, slot)
		if (charIndex >= 0) then
			local hpRatio = getHp(charIndex) / getMaxHp(charIndex)
			if tagHp == nil then
				tagHp = hpRatio
				returnSlot = slot
			elseif hpRatio < tagHp then
				tagHp = hpRatio;
				returnSlot = slot
			end
		end
	end
	-- 获得真实位置
	local result = getEntryPositionBySlot(battleIndex, returnSlot)
	if range == 0 then
		return result
	end
	if range == 1 then
		return result + 20
	end
	return result
end)

-- NOTE 魔最多的
local findMostMp = _.wrap(getTargetWithRange23, function(func, side, battleIndex, range)
	local isRange23 = func(side, range)
	if isRange23 ~= nil then
		return isRange23
	end

	local tagMp = nil;
	local returnSlot;
	for slot = side * 10 + 0, side * 10 + 9 do
		local charIndex = Battle.GetPlayer(battleIndex, slot)
		if (charIndex >= 0) then
			local mp = Char.GetData(charIndex, CONST.对象_魔)
			if tagMp == nil then
				tagMp = mp
				returnSlot = slot
			elseif mp > tagMp then
				tagMp = mp;
				returnSlot = slot
			end
		end
	end
	-- 获得真实位置
	local result = getEntryPositionBySlot(battleIndex, returnSlot)
	if range == 0 then
		return result
	end
	if range == 1 then
		return result + 20
	end
	return result
end)
-- NOTE 魔最少的
local findLeastMp = _.wrap(getTargetWithRange23, function(func, side, battleIndex, range)
	local isRange23 = func(side, range)
	if isRange23 ~= nil then
		return isRange23
	end

	local tagMp = nil;
	local returnSlot;
	for slot = side * 10 + 0, side * 10 + 9 do
		local charIndex = Battle.GetPlayer(battleIndex, slot)
		if (charIndex >= 0) then
			local mp = Char.GetData(charIndex, CONST.对象_魔)
			if tagMp == nil then
				tagMp = mp
				returnSlot = slot
			elseif mp < tagMp then
				tagMp = mp;
				returnSlot = slot
			end
		end
	end
	-- 获得真实位置
	local result = getEntryPositionBySlot(battleIndex, returnSlot)
	if range == 0 then
		return result
	end
	if range == 1 then
		return result + 20
	end
	return result
end)
-- NOTE 魔量占比最低的
local findLeastMpRatio = _.wrap(getTargetWithRange23, function(func, side, battleIndex, range)
	local isRange23 = func(side, range)
	if isRange23 ~= nil then
		return isRange23
	end

	local tagMp = nil;
	local returnSlot;
	for slot = side * 10 + 0, side * 10 + 9 do
		local charIndex = Battle.GetPlayer(battleIndex, slot)
		if (charIndex >= 0) then
			local mpRatio = getMp(charIndex) / getMaxMp(charIndex)
			if tagMp == nil then
				tagMp = mpRatio
				returnSlot = slot
			elseif mpRatio < tagMp then
				tagMp = mpRatio;
				returnSlot = slot
			end
		end
	end
	-- 获得真实位置
	local result = getEntryPositionBySlot(battleIndex, returnSlot)
	if range == 0 then
		return result
	end
	if range == 1 then
		return result + 20
	end
	return result
end)

-- NOTE 随机玩家单位（含佣兵）
local findRandomPlayer = _.wrap(getTargetWithRange23, function(func, side, battleIndex, range)
	local isRange23 = func(side, range)
	if isRange23 ~= nil then
		return isRange23
	end
	local slotTable = {}

	for slot = side * 10 + 0, side * 10 + 9 do
		local charIndex = Battle.GetPlayer(battleIndex, slot)
		if (charIndex >= 0 and Char.GetData(charIndex, CONST.对象_类型) == CONST.对象类型_人) then
			table.insert(slotTable, slot)
		end
	end
	local returnSlot = slotTable[NLG.Rand(1, #slotTable)]
	-- 获得真实位置
	local result = getEntryPositionBySlot(battleIndex, returnSlot)
	if range == 0 then
		return result
	end
	if range == 1 then
		return result + 20
	end
	return result
end)

-- NOTE 随机宠物单位
local findRandomPet = _.wrap(getTargetWithRange23, function(func, side, battleIndex, range)
	local isRange23 = func(side, range)
	if isRange23 ~= nil then
		return isRange23
	end

	local slotTable = {}

	for slot = side * 10 + 0, side * 10 + 9 do
		local charIndex = Battle.GetPlayer(battleIndex, slot)
		if (charIndex >= 0 and Char.GetData(charIndex, CONST.对象_类型) == CONST.对象类型_宠) then
			table.insert(slotTable, slot)
		end
	end
	local returnSlot = slotTable[NLG.Rand(1, #slotTable)]
	-- 获得真实位置
	local result = getEntryPositionBySlot(battleIndex, returnSlot)
	if range == 0 then
		return result
	end
	if range == 1 then
		return result + 20
	end
	return result
end)
-- NOTE 获取死亡人物
local findDeadPlayer = _.wrap(getTargetWithRange23, function(func, side, battleIndex, range)
	local isRange23 = func(side, range)
	if isRange23 ~= nil then
		return isRange23
	end
	local returnSlot;

	for slot = side * 10 + 0, side * 10 + 9 do
		local charIndex = Battle.GetPlayer(battleIndex, slot)

		if charIndex >= 0 and Char.GetData(charIndex, CONST.对象_战死) == 1 and Char.GetData(charIndex, CONST.对象_类型) == CONST.对象类型_人 then
			returnSlot = slot
		end
	end
	-- 获得真实位置
	local result = getEntryPositionBySlot(battleIndex, returnSlot)
	if range == 0 then
		return result
	end
	if range == 1 then
		return result + 20
	end
	return result
end)

-- NOTE 获取战死单位
local findDeadUnit = _.wrap(getTargetWithRange23, function(func, side, battleIndex, range)
	local isRange23 = func(side, range)
	if isRange23 ~= nil then
		return isRange23
	end

	local slotTable = {}
	for slot = side * 10 + 0, side * 10 + 9 do
		local charIndex = Battle.GetPlayer(battleIndex, slot)
		if charIndex >= 0 and Char.GetData(charIndex, CONST.对象_战死) == 1 then
			table.insert(slotTable, slot)
		end
	end
	local returnSlot = slotTable[NLG.Rand(1, #slotTable)]
	-- 获得真实位置
	local result = getEntryPositionBySlot(battleIndex, returnSlot)
	if range == 0 then
		return result
	end
	if range == 1 then
		return result + 20
	end
	return result
end)

-- NOTE 随机异常单位
local randStatusUnit = _.wrap(getTargetWithRange23, function(func, side, battleIndex, range)
	local isRange23 = func(side, range)
	if isRange23 ~= nil then
		return isRange23
	end

	local slotTable = {}

	for slot = side * 10 + 0, side * 10 + 9 do
		local charIndex = Battle.GetPlayer(battleIndex, slot)
		if charIndex >= 0 then
			if (Char.GetData(charIndex, CONST.对象_ModPoison) > 1 or
					Char.GetData(charIndex, CONST.对象_ModSleep) > 1 or
					Char.GetData(charIndex, CONST.对象_ModStone) > 1 or
					Char.GetData(charIndex, CONST.对象_ModDrunk) > 1 or
					Char.GetData(charIndex, CONST.对象_ModConfusion) > 1 or
					Char.GetData(charIndex, CONST.对象_ModAmnesia) > 1) then
				table.insert(slotTable, slot)
			end
		end
	end
	local returnSlot = slotTable[NLG.Rand(1, #slotTable)]
	-- 获得真实位置
	local result = getEntryPositionBySlot(battleIndex, returnSlot)
	if range == 0 then
		return result
	end
	if range == 1 then
		return result + 20
	end
	return result
end)

-- NOTE 敌方等级最高单位
local findMostLevel = _.wrap(getTargetWithRange23, function(func, side, battleIndex, range)
	local isRange23 = func(side, range)
	if isRange23 ~= nil then
		return isRange23
	end

	local tagLv = nil;
	local returnSlot;
	for slot = side * 10 + 0, side * 10 + 9 do
		local charIndex = Battle.GetPlayer(battleIndex, slot)
		if (charIndex >= 0) then
			local level = Char.GetData(charIndex, CONST.对象_等级)
			if tagLv == nil then
				tagLv = level
				returnSlot = slot
			elseif level < tagLv then
				tagLv = level;
				returnSlot = slot
			end
		end
	end

	-- 获得真实位置
	local result = getEntryPositionBySlot(battleIndex, returnSlot)
	if range == 0 then
		return result
	end
	if range == 1 then
		return result + 20
	end
	return result
end)

-- NOTE 敌方魔量>5%且等级最高单位
local findMostLevelandMp5 = _.wrap(getTargetWithRange23, function(func, side, battleIndex, range)
	local isRange23 = func(side, range)
	if isRange23 ~= nil then
		return isRange23
	end

	local tagLv = nil;
	local returnSlot;
	for slot = side * 10 + 0, side * 10 + 9 do
		local charIndex = Battle.GetPlayer(battleIndex, slot)
		if (charIndex >= 0) then
			local level = Char.GetData(charIndex, CONST.对象_等级)
			local mpRatio = getMp(charIndex) / getMaxMp(charIndex) * 100
			if mpRatio > 5 then
				if tagLv == nil then
					tagLv = level
					returnSlot = slot
				elseif level < tagLv then
					tagLv = level;
					returnSlot = slot
				end
			end
		end
	end

	-- 获得真实位置
	local result = getEntryPositionBySlot(battleIndex, returnSlot)
	if range == 0 then
		return result
	end
	if range == 1 then
		return result + 20
	end
	return result
end)

-- NOTE 对方魔量>50且小于75%的
local findMp50To75per = _.wrap(getTargetWithRange23, function(func, side, battleIndex, range)
	-- print('>>> findMp50To75per')
	local isRange23 = func(side, range)
	if isRange23 ~= nil then
		return isRange23
	end

	local tagMp = nil;
	local returnSlot;
	for slot = side * 10 + 0, side * 10 + 9 do
		local charIndex = Battle.GetPlayer(battleIndex, slot)
		if (charIndex >= 0) then
			local level = Char.GetData(charIndex, CONST.对象_等级)
			local mp = getMp(charIndex)
			local mpRatio = mp / getMaxMp(charIndex)
			if mp >= 50 and mpRatio <= 75 then
				if tagMp == nil then
					tagMp = mp
					returnSlot = slot
					break
				end
			end
		end
	end

	-- print('returnSlot >>> ' .. returnSlot)

	-- 获得真实位置
	local result = getEntryPositionBySlot(battleIndex, returnSlot)
	if range == 0 then
		return result
	end
	if range == 1 then
		return result + 20
	end
	return result
end)

-- SECTION 目标
module.target = {
	-- NOTE 0  己方自身
	["0"] = {
		comment = "自身",
		fn = function(charIndex, side, battleIndex, slot, range) return slot end
	},
	-- NOTE 1 己方阵营 随机
	["1"] = {
		comment = "己方隨機單位",
		fn = function(charIndex, side, battleIndex, slot, range) return randomTarget(side, battleIndex, range) end
	},
	-- NOTE 2 对方阵营 随机
	["2"] = {
		comment = "對方隨機單位",
		fn = function(charIndex, side, battleIndex, slot, range) return randomTarget(oppositeSide(side), battleIndex,
				range) end
	},
	-- NOTE 3 己方血最多的
	["3"] = {
		comment = "己方血最多的",
		fn = function(charIndex, side, battleIndex, slot, range) return findMostHp(side, battleIndex, range) end
	},
	-- NOTE 对方血最多的
	["4"] = {
		comment = "對方血最多的",
		fn = function(charIndex, side, battleIndex, slot, range) return findMostHp(oppositeSide(side), battleIndex, range) end
	},
	-- NOTE 己方血最少的
	["5"] = {
		comment = "己方血最少的",
		fn = function(charIndex, side, battleIndex, slot, range) return findLeastHp(side, battleIndex, range) end
	},
	-- NOTE 对方血最少的
	["6"] = {
		comment = "對方血最少的",
		fn = function(charIndex, side, battleIndex, slot, range) return findLeastHp(oppositeSide(side), battleIndex,
				range) end
	},
	-- NOTE 己方血量占比最低
	["7"] = {
		comment = "己方血量占比最低的",
		fn = function(charIndex, side, battleIndex, slot, range) return findLeastHpRatio(side, battleIndex, range) end
	},
	-- NOTE 对方血量占比最低
	["8"] = {
		comment = "對方血量占比最低的",
		fn = function(charIndex, side, battleIndex, slot, range)
			return findLeastHpRatio(oppositeSide(side), battleIndex,
				range)
		end
	},
	-- 对方魔最低的
	["9"] = {
		comment = "對方魔量占比最低的",
		fn = function(charIndex, side, battleIndex, slot, range)
			return findLeastMpRatio(oppositeSide(side), battleIndex,
				range)
		end
	},
	-- 对方魔量>5%且等级最高的
	["10"] = {
		comment = "對方魔量>5%且等級最高的",
		fn = function(charIndex, side, battleIndex, slot, range)
			return findMostLevelandMp5(oppositeSide(side), battleIndex,
				range)
		end
	},
	-- 对方等级最高的
	["11"] = {
		comment = "對方等級最高的",
		fn = function(charIndex, side, battleIndex, slot, range) return findMostLevel(oppositeSide(side), battleIndex,
				range) end
	},
	-- 对方等级最低的
	-- 对方魔量>50且小于75%的
	["13"] = {
		comment = "對方魔量>50且小於75%的",
		fn = function(charIndex, side, battleIndex, slot, range)
			return findMp50To75per(oppositeSide(side), battleIndex,
				range)
		end
	},
	-- NOTE 己方随机玩家单位
	["44"] = {
		comment = "己方隨機人物",
		fn = function(charIndex, side, battleIndex, slot, range) return findRandomPlayer(side, battleIndex, range) end
	},
	-- NOTE 己方随机宠物单位
	["45"] = {
		comment = "己方隨機寵物",
		fn = function(charIndex, side, battleIndex, slot, range) return findRandomPet(side, battleIndex, range) end
	},
	-- NOTE 己方随机战死人物
	["46"] = {
		comment = "己方戰死人物",
		fn = function(charIndex, side, battleIndex, slot, range) return findDeadPlayer(side, battleIndex, range) end
	},
	-- NOTE 己方随机战死单位
	["47"] = {
		comment = "己方隨機戰死單位",
		fn = function(charIndex, side, battleIndex, slot, range) return findDeadUnit(side, battleIndex, range) end
	},
	-- NOTE 己方随机异常单位
	["48"] = {
		comment = "己方隨機異常單位",
		fn = function(charIndex, side, battleIndex, slot, range) return randStatusUnit(side, battleIndex, range) end
	},
}
-- !SECTION

-- NOTE 计算出行为数据
-- params: charIndex：自己的index, side：自己的side， battleIndex, slot：自己的slot， commands：ai指令数组
-- return: {com1, targetSlot, techId}
function module:calcActionData(charIndex, side, battleIndex, slot, commands)
	-- print("开始",JSON.stringify(commands),charIndex)
	-- print("参数：",charIndex,side,battleIndex,slot,commands)
	for i = 1, #commands do
		local command = commands[i]
		local conditionId = command[1]
		local targetId = command[2]
		local techId = tonumber(command[3])

		-- print('>>>>', command, conditionId, targetId, techId);
		-- 是否满足 condition
		local conditionFn = self.conditions[tostring(conditionId)]["fn"];
		-- print("开始计算条件::", i, self.conditions[tostring(conditionId)]["comment"], techId)
		if conditionFn(charIndex, side, battleIndex) then
			-- print('>>>', self.conditions[tostring(conditionId)]["comment"], conditionFn(charIndex,side,battleIndex))
			local fp = 0;
			if techId == -100 or techId == -200 then
				fp = 0;
			else
				local techIndex = Tech.GetTechIndex(techId)
				fp = Tech.GetData(techIndex, CONST.TECH_FORCEPOINT)
				-- local techName = Tech.GetData(techIndex, CONST.TECH_NAME)
				-- print('>>>' .. techName .. '耗魔:' .. fp);
			end

			local mp = Char.GetData(charIndex, CONST.对象_魔)

			if fp > mp then
				return { CONST.BATTLE_COM.BATTLE_COM_ATTACK, self.target["6"]["fn"](charIndex, side, battleIndex, slot, 0), -1 }
			end

			-- 验证 range
			local techInfo = _.detect(skillInfo.params, function(item)
				local ids = item[2]
				if type(ids) == 'number' and ids == techId then
					return true
				elseif type(ids) == 'table' then
					if techId >= ids[1] and techId <= ids[2] then
						return true
					end
				end
				return false
			end)

			-- print('>>>techInfo', tostring(techInfo))

			if techInfo ~= nil then
				local range = techInfo[4]
				local com1 = techInfo[1]
				local target = self.target[tostring(targetId)]["fn"](charIndex, side, battleIndex, slot, range)
				if techId == -100 or techId == -200 then
					techId = -1
				end

				-- print('>>>', com1, target, targetId)
				-- 当战栗时, 上面的com1,target,targetId错误的出现了 nil,16,13
				-- 当战栗时, 返回了错误的table: {"2":16,"3":609}, 正确的应为{com1(见autoBattleParams),位置,techId}
				return { com1, target, techId }
			end
		end
		-- print("条件不满足, 下一个")
	end
	local target = randomTarget(oppositeSide(side), battleIndex, 0)
	-- 条件不满足 释放默认技能，目标随机
	return { CONST.BATTLE_COM.BATTLE_COM_ATTACK, randomTarget(oppositeSide(side), battleIndex, 0), -1 }
end

-- ANCHOR 加载数据 heresAI.txt
function module:loadData()
	print('heroes >> 加载heroesAI.txt');
	count = 0;
	aiData = {}
	file = io.open('lua/Modules/heroesAI.txt')
	for line in file:lines() do
		if line then
			if string.match(line, '^%s*#') then
				goto continue;
			end
			local data = string.split(string.gsub(line, "\t*\r[^\n]*$", ""), '\t');

			if data and #data >= 4 then
				local id = tonumber(data[1])
				local name = data[2]
				local npcNo = data[3]

				local level = tonumber(data[4])
				local type = tonumber(data[5])
				local jobAncestry = tonumber(data[6])
				-- if npcNo~='1' then
				--   goto continue;
				-- end
				local commands = _(data):chain():rest(7):map(function(c) return string.split(c, ',') end):value()
				table.insert(aiData,
					{
						id = id,
						name = name,
						commands = commands,
						type = type,
						level = level,
						npcNo = npcNo,
						jobAncestry =
							jobAncestry
					})
				count = count + 1;
			end
		end
		::continue::
	end
	self:logInfo('loaded heroesAI', count);
	file:close();
	return aiData;
end

-- SECTION 佣兵AInpc
-- NOTE 窗口流程控制
function module:AINpcTalked(npc, charIndex, seqno, select, data)
	-- print(npc, charIndex, seqno, select, data)
	data = tonumber(data)
	if select == CONST.BUTTON_关闭 then
		return;
	end
	-- NOTE  1 佣兵列表
	if seqno == 1 and data > 0 then
		self:showChooseType(charIndex, data)
	end
	--  NOTE  2 选择Ai
	if seqno == 2 then
		-- 选择的是上一页 下一页
		if data < 0 then
			local page;
			if select == 32 then
				page = sgModule:get(charIndex, "statusPage") + 1
			elseif select == 16 then
				page = sgModule:get(charIndex, "statusPage") - 1
			end
			if page == 0 then
				-- 返回上一级
				self:showChooseType(charIndex, nil, sgModule:get(charIndex, "heroSelected4AI"))
				return
			end
			sgModule:set(charIndex, "statusPage", page)
			self:showAIList(charIndex, page)
		else
			self:showAIComment(charIndex, data)
		end
	end
	-- NOTE 3 AI说明
	if seqno == 3 then
		if select == CONST.BUTTON_确定 then
			self:showCampHeroSkillSlot(charIndex, data)
		end
	end
	-- NOTE  4 技能选择完
	if seqno == 4 and data > 0 then
		self:getAI(charIndex, data)
	end
	-- NOTE 5 选择类型
	if seqno == 5 then
		if data < 0 then
		else
			self:toShowAiList(charIndex, data)
		end
	end
end

-- NOTE 佣兵选择 首页 seqno:1
function module:showAINpcHome(npc, charIndex)
	local windowStr = getModule("heroesFn"):buildCampHeroesList(charIndex)
	NLG.ShowWindowTalked(charIndex, self.AINpc, CONST.窗口_选择框, CONST.BUTTON_关闭, 1, windowStr);
end

-- NOTE 选择宠物还是佣兵 seqno:5
function module:showChooseType(charIndex, data, heroData)
	if data ~= nil and heroData == nil then
		local campHeroes = getModule("heroesFn"):getCampHeroesData(charIndex)
		heroData = campHeroes[data]
		sgModule:set(charIndex, "heroSelected4AI", heroData)
	elseif data == nil and heroData ~= nil then
		sgModule:set(charIndex, "heroSelected4AI", heroData)
	end

	local items = { "設置夥伴AI", "設置寵物AI", }

	local title = "★請選擇要設置AI對象："
	local windowStr = self:NPC_buildSelectionText(title, items);
	NLG.ShowWindowTalked(charIndex, self.AINpc, CONST.窗口_选择框, CONST.BUTTON_上取消, 5, windowStr);
end

-- NOTE 显示AI列表
function module:toShowAiList(charIndex, data)
	sgModule:set(charIndex, "chartypeSelected4AI", data - 1)
	local heroData = sgModule:get(charIndex, "heroSelected4AI")
	local heroLevel = Char.GetData(heroData.index, CONST.对象_等级)

	local itemsData = _.select(self.aiData, function(ai)
		local levelRequired = ai.level

		local isLevelQualified = true;
		local isJobQualified = true;
		local heroJobAncestry = Char.GetData(heroData.index, CONST.对象_职类ID)
		
		if levelRequired==nil then
		elseif (math.floor(heroLevel / 10) + 1) < levelRequired then
			isLevelQualified = false
		end
		if ai.jobAncestry==nil then
		elseif heroJobAncestry ~= ai.jobAncestry and ai.jobAncestry >= 0 then
			isJobQualified = false
		end

		return ai.type == (data - 1) and isLevelQualified and isJobQualified
	end)
	local items = _.map(itemsData, function(ai) return ai.name end)

	sgModule:set(charIndex, "aiDataList4AI", itemsData)
	sgModule:set(charIndex, "statusPage", 1)
	self:showAIList(charIndex, 1)
end

-- NOTE 显示AI列表 seqno:2
function module:showAIList(charIndex, page)
	local itemsData = sgModule:get(charIndex, "aiDataList4AI")
	local items = _.map(itemsData, function(ai) return ai.name end)
	local title = "★選擇AI可以查看說明："
	local buttonType, windowStr = self:dynamicListData(items, title, page)

	NLG.ShowWindowTalked(charIndex, self.AINpc, CONST.窗口_选择框, buttonType, 2, windowStr);
end

-- NOTE 动态列表数据生成
function module:dynamicListData(list, title, page)
	page = page or 1;

	local start_index = (page - 1) * 8 + 1
	local totalPage, rest = math.modf(#list / 8)

	if rest > 0 then
		totalPage = totalPage + 1
	end

	local items = _.slice(list, start_index, 8)
	local windowStr = self:NPC_buildSelectionText(title, items);
	local buttonType;
	if totalPage == 1 then
		buttonType = CONST.BUTTON_上取消
	elseif page == 1 then
		buttonType = CONST.BUTTON_上下取消
	elseif page == totalPage then
		buttonType = CONST.BUTTON_上取消
	else
		buttonType = CONST.BUTTON_上下取消
	end
	return buttonType, windowStr
end

-- NOTE AI说明 seno:3
function module:showAIComment(charIndex, data)
	local heroData = sgModule:get(charIndex, "heroSelected4AI")
	local page = sgModule:get(charIndex, "statusPage")
	local index = (page - 1) * 8 + data

	local aiData = sgModule:get(charIndex, "aiDataList4AI")
	local aiDataSelected = aiData[index]

	local aiId = aiDataSelected.id
	sgModule:set(charIndex, "aiSelected", aiId);
	local commands = aiDataSelected.commands

	-- 判断 是否满足等级和 职业要求
	local levelRequired = aiDataSelected.level

	local heroLevel = Char.GetData(heroData.index, CONST.对象_等级)

	local heroJobAncestry = Char.GetData(heroData.index, CONST.对象_职类ID)
	local isLevelQualified = true;
	local isJobQualified = true;
	local warning = ""
	if (math.floor(heroLevel / 10) + 1) < levelRequired then
		isLevelQualified = false;
		warning = warning .. "夥伴的等級不夠；"
	end
	if heroJobAncestry ~= aiDataSelected.jobAncestry and aiDataSelected.jobAncestry >= 0 then
		isJobQualified = false
		warning = warning .. "夥伴的職業不符；"
	end

	local title = "★AI行動說明\\n\\n"

	local windowStr = title .. _(commands):chain():map(function(command)
			local conditionId = command[1]
			local targetId = command[2]

			local techId = tonumber(command[3])
			if conditionId~=nil and targetId~=nil and techId~=nil  then
				local techName = ""
				if techId == -100 or techId == -200 then
					techName = techId == -100 and "攻击" or "防御"
				else
					local techIndex = Tech.GetTechIndex(techId)
					techName = Tech.GetData(techIndex, CONST.TECH_NAME)
				end

				str = "「" .. self.conditions[tostring(conditionId)]["comment"]
					.. "」对 「" .. self.target[tostring(targetId)]["comment"] .. "」使用 「" .. techName .. "」"
			else
				--str = "「空条件」对 「空对象」使用 「空技能」"
				str = ""
			end
			return str;
		end):join("\\n\\n"):value()
		.. "\\n\\n★判斷優先順序為從上往下，點擊確定可以選擇此AI。\n\n" .. warning
	local buttonType = (isLevelQualified and isJobQualified) and CONST.BUTTON_确定关闭 or CONST.BUTTON_关闭
	NLG.ShowWindowTalked(charIndex, self.AINpc, CONST.窗口_巨信息框, buttonType, 3, windowStr);
end

-- NOTE 显示佣兵技能栏 seqno:3
function module:showCampHeroSkillSlot(charIndex, data)
	local heroData = sgModule:get(charIndex, "heroSelected4AI");
	local chartype = sgModule:get(charIndex, "chartypeSelected4AI")
	local skills
	if chartype == 0 then
		if heroData.skills == nil then
			heroData.skills = { nil, nil, nil, nil, nil, nil, nil, nil }
		end
		skills = heroData.skills
	else
		if heroData.petSkills == nil then
			heroData.petSkills = { nil, nil, nil, nil, nil, nil, nil, nil }
		end
		skills = heroData.petSkills
	end

	local windowStr = getModule("heroesFn"):buildCampHeroSkills(charIndex, skills)
	NLG.ShowWindowTalked(charIndex, self.AINpc, CONST.窗口_选择框, CONST.BUTTON_上取消, 4, windowStr);
end

-- NOTE 登记AI
function module:getAI(charIndex, data)
	local chartype = sgModule:get(charIndex, "chartypeSelected4AI")
	local aiId = sgModule:get(charIndex, "aiSelected");
	local heroData = sgModule:get(charIndex, "heroSelected4AI");
	local skills
	if chartype == 0 then
		skills = heroData.skills
	else
		skills = heroData.petSkills
	end


	skills[data] = aiId

	local name = Char.GetData(heroData.index, CONST.对象_名字)
	NLG.SystemMessage(charIndex, name .. " 記錄了此AI，請在夥伴右鍵選單啟用。")
end

-- !SECTION


--- 加载模块钩子
function module:onLoad()
	self:logInfo('load')
	self.aiData = self:loadData();
	-- print(JSON.stringify(self.aiData))
	-- 秋兔的
	self.AINpc = self:NPC_createNormal('夥伴戰術', 231050, { x = 29, y = 27, mapType = 0, map = 7351, direction = 4 });
	-- self.AINpc = self:NPC_createNormal('行动模式教练', 106452, { x = 30, y = 22, mapType = 0, map = 35800, direction = 6 });
	self:NPC_regTalkedEvent(self.AINpc, Func.bind(self.showAINpcHome, self));
	self:NPC_regWindowTalkedEvent(self.AINpc, Func.bind(self.AINpcTalked, self));
end

--- 卸载模块钩子
function module:onUnload()
	self:logInfo('unload')
end

return module;
