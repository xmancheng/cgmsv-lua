local module = ModuleBase:createModule('heroesAI')
local _ = require "lua/Modules/underscore"
local JSON = require "lua/Modules/json"
--local heroesFn = getModule("heroesFn")
local sgModule = getModule("setterGetter")
local skillInfo = dofile("lua/Modules/autoBattleParams.lua")
local function getHp(charIndex)
	return Char.GetData(charIndex, CONST.����_Ѫ)
end
local function getMaxHp(charIndex)
	return Char.GetData(charIndex, CONST.����_���Ѫ)
end
local function getMp(charIndex)
	return Char.GetData(charIndex, CONST.����_ħ)
end
local function getMaxMp(charIndex)
	return Char.GetData(charIndex, CONST.����_���ħ)
end

function getEntryPositionBySlot(battleIndex, slot)
	local cIndex = Battle.GetPlayer(battleIndex, slot);
	if cIndex >=0 then
		local pos = Battle.GetPos(battleIndex, cIndex);
		return pos;
	else
		print('��ȡcharIndexʧ��: ', cIndex);
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

-- NOTE ѭ������ ��ü��������е�λIndex
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



-- NOTE ѭ���Է� ��öԷ������е�λIndex
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
-- NOTE �Ƿ� ����ĳ��״̬
--   return :true false
local function hasGotStatus(charIndex, side, battleIndex, statusKey)
	return function(charIndex, side, battleIndex)
		local chars = getAttackerSide(charIndex, side, battleIndex)
		return _.any(chars, function(charIndex)
			return Char.GetData(charIndex, statusKey) == 1
		end)
	end
end

-- NOTE �����쳣������
--   return: num
local function gotAnyStatusNum(charIndex, side, battleIndex)
	local chars = getAttackerSide(charIndex, side, battleIndex)
	local statusChars = _.select(chars, function(charIndex)
		return Char.GetData(charIndex, CONST.����_ModPoison) > 1 or
			Char.GetData(charIndex, CONST.����_ModSleep) > 1 or
			Char.GetData(charIndex, CONST.����_ModStone) > 1 or
			Char.GetData(charIndex, CONST.����_ModDrunk) > 1 or
			Char.GetData(charIndex, CONST.����_ModConfusion) > 1 or
			Char.GetData(charIndex, CONST.����_ModAmnesia) > 1
	end)

	return #statusChars;
end



-- NOTE �ж� ����
--   return :true false
local function livesNumEq(charIndex, side, battleIndex, num)
	return function(charIndex, side, battleIndex)
		local chars = getAttackerSide(charIndex, side, battleIndex)
		local liveChars = _.select(chars, function(charIndex)
			return Char.GetData(charIndex, CONST.����_ս��) == 0
		end)
		return #liveChars == num
	end
end
-- NOTE ��ü����������
--  return  num
local function livesNum(charIndex, side, battleIndex)
	local chars = getAttackerSide(charIndex, side, battleIndex)
	local liveChars = _.select(chars, function(charIndex)
		return Char.GetData(charIndex, CONST.����_ս��) == 0
	end)
	return #liveChars
end

-- NOTE ��ü���ս����������
local function deadPlayerNum(charIndex, side, battleIndex)
	local chars = getAttackerSide(charIndex, side, battleIndex)
	local liveChars = _.select(chars, function(charIndex)
		return Char.GetData(charIndex, CONST.����_ս��) == 1 and Char.GetData(charIndex, CONST.����_����) == CONST.��������_��
	end)
	return #liveChars
end

-- NOTE ��ü���ս������
local function deadNum(charIndex, side, battleIndex)
	local chars = getAttackerSide(charIndex, side, battleIndex)
	local liveChars = _.select(chars, function(charIndex)
		return Char.GetData(charIndex, CONST.����_ս��) == 1
	end)
	return #liveChars
end


-- NOTE ��öԷ�����
--  return  num
local function livesDefNum(charIndex, side, battleIndex)
	local chars = getDeffenderSide(charIndex, side, battleIndex)
	local liveChars = _.select(chars, function(charIndex)
		return Char.GetData(charIndex, CONST.����_ս��) == 0
	end)
	return #liveChars
end


-- NOTE ��� ƽ���ȼ�
--  return num
local function averageLevel(charIndexTable)
	local totalLevel = _.reduce(charIndexTable, 0, function(count, charIndex)
		local level = Char.GetData(charIndex, CONST.����_�ȼ�)
		return count + level
	end)
	return totalLevel / #charIndexTable
end

-- NOTE ���� hp < x �ĳ���  y��
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


-- SECTION ����
module.conditions = {
	-- NOTE ���� �������ͷ�
	['0'] = {
		comment = "�o�����l��",
		fn = function(charIndex) return true end
	},
	-- NOTE ����hp =100%
	['4'] = {
		comment = "����hp=100%",
		fn = function(charIndex) return getHp(charIndex) == getMaxHp(charIndex) end
	},
	-- NOTE ����hp > 75%
	['5'] = {
		comment = "����hp>75%",
		fn = function(charIndex) return getHp(charIndex) / getMaxHp(charIndex) > 0.75 end
	},
	-- NOTE ����hp > 50%
	['6'] = {
		comment = "����hp>50%",
		fn = function(charIndex) return getHp(charIndex) / getMaxHp(charIndex) > 0.5 end
	},
	-- NOTE ����hp < 50%
	['7'] = {
		comment = "����hp<50%",
		fn = function(charIndex) return getHp(charIndex) / getMaxHp(charIndex) < 0.5 end
	},
	-- NOTE ����hp < 25%
	['8'] = {
		comment = "����hp<30%",
		fn = function(charIndex) return getHp(charIndex) / getMaxHp(charIndex) < 0.3 end
	},
	-- NOTE ���� mp>=0.5
	['9'] = {
		comment = "����mp>=50%",
		fn = function(charIndex) return getMp(charIndex) / getMaxMp(charIndex) >= 0.5 end
	},
	-- NOTE ����mp<50%
	['10'] = {
		comment = "����mp<50%",
		fn = function(charIndex) return getMp(charIndex) / getMaxMp(charIndex) < 0.5 end
	},

	-- NOTE ������Ӫ�����ж���λ
	["13"] = {
		comment = "�������ж���λ",
		fn = hasGotStatus(CONST.����_ModPoison)
	},
	-- NOTE ������Ӫ���л��ҵ�λ
	["14"] = {
		comment = "�����л�y��λ",
		fn = hasGotStatus(CONST.����_ModConfusion)
	},
	-- NOTE ������Ӫ����ʯ����λ
	["15"] = {
		comment = "������ʯ����λ",
		fn = hasGotStatus(CONST.����_ModStone)
	},
	-- NOTE ������Ӫ����˯�ߵ�λ
	["16"] = {
		comment = "������˯�߆�λ",
		fn = hasGotStatus(CONST.����_ModSleep)
	},
	-- NOTE ������Ӫ���о���λ
	["17"] = {
		comment = "�����о����λ",
		fn = hasGotStatus(CONST.����_ModDrunk)
	},
	-- NOTE ������Ӫ����������λ
	["18"] = {
		comment = "�������z����λ",
		fn = hasGotStatus(CONST.����_ModAmnesia)
	},
	-- NOTE ������Ӫ�д������0
	["19"] = {
		comment = "��������0",
		fn = livesNumEq(charIndex, side, battleIndex, 0)
	},
	-- NOTE ������Ӫ�д������1
	["20"] = {
		comment = "��������1",
		fn = livesNumEq(charIndex, side, battleIndex, 1)
	},
	-- NOTE ������Ӫ�д������2
	["21"] = {
		comment = "��������1",
		fn = livesNumEq(charIndex, side, battleIndex, 2)
	},
	-- NOTE ������Ӫ�д������ ==10
	["22"] = {
		comment = "��������10",
		fn = livesNumEq(charIndex, side, battleIndex, 10)
	},
	-- NOTE ������Ӫ�д������>=8
	["23"] = {
		comment = "�������>=8",
		fn = function(charIndex, side, battleIndex) return livesNum(charIndex, side, battleIndex) >= 8 end
	},
	-- NOTE ������Ӫ�д������>=5
	["24"] = {
		comment = "�������>=5",
		fn = function(charIndex, side, battleIndex) return livesNum(charIndex, side, battleIndex) >= 5 end
	},
	-- NOTE ������Ӫ�д������<5
	["25"] = {
		comment = "�������<5",
		fn = function(charIndex, side, battleIndex) return livesNum(charIndex, side, battleIndex) < 5 end
	},
	-- NOTE ������Ӫ�д������<4
	["26"] = {
		comment = "�������<4",
		fn = function(charIndex, side, battleIndex) return livesNum(charIndex, side, battleIndex) < 4 end
	},
	-- NOTE ������Ӫ�д������<=1
	["27"] = {
		comment = "�������<=1",
		fn = function(charIndex, side, battleIndex) return livesNum(charIndex, side, battleIndex) <= 1 end
	},
	-- NOTE ����ƽ���ȼ� < �з�
	["29"] = {
		comment = "����ƽ���ȼ�<����",
		fn = function(charIndex, side, battleIndex)
			return averageLevel(getAttackerSide(charIndex, side, battleIndex)) <
				averageLevel(getDeffenderSide(charIndex, side, battleIndex))
		end
	},
	-- NOTE ����ƽ���ȼ� >= �з�
	["30"] = {
		comment = "����ƽ���ȼ�>=����",
		fn = function(charIndex, side, battleIndex)
			return averageLevel(getAttackerSide(charIndex, side, battleIndex)) >=
				averageLevel(getDeffenderSide(charIndex, side, battleIndex))
		end
	},
	-- NOTE �Է�ĳһ��λhp ==100%
	["31"] = {
		comment = "����ĳ��λhp=100%",
		fn = function(charIndex, side, battleIndex)
			local defChars = getDeffenderSide(charIndex, side, battleIndex)
			return _.any(defChars, function(charIndex)
				return Char.GetData(charIndex, CONST.����_Ѫ) / Char.GetData(charIndex, CONST.����_���Ѫ) == 1
			end)
		end
	},
	-- NOTE �Է� ĳһ��λhp >75%
	["32"] = {
		comment = "����ĳ��λ>75%",
		fn = function(charIndex, side, battleIndex)
			local defChars = getDeffenderSide(charIndex, side, battleIndex)
			return _.any(defChars, function(charIndex)
				return Char.GetData(charIndex, CONST.����_Ѫ) / Char.GetData(charIndex, CONST.����_���Ѫ) > 0.75
			end)
		end
	},
	-- NOTE �Է� ĳһ��λhp >50%
	["33"] = {
		comment = "����ĳ��λhp>50%",
		fn = function(charIndex, side, battleIndex)
			local defChars = getDeffenderSide(charIndex, side, battleIndex)
			return _.any(defChars, function(charIndex)
				return Char.GetData(charIndex, CONST.����_Ѫ) / Char.GetData(charIndex, CONST.����_���Ѫ) > 0.5
			end)
		end
	},
	-- NOTE �Է� ĳһ��λhp <50%
	["34"] = {
		comment = "����ĳ��λhp<50%",
		fn = function(charIndex, side, battleIndex)
			local defChars = getDeffenderSide(charIndex, side, battleIndex)

			return _.any(defChars, function(charIndex)
				return Char.GetData(charIndex, CONST.����_Ѫ) / Char.GetData(charIndex, CONST.����_���Ѫ) < 0.5
			end)
		end
	},
	-- NOTE �Է� ĳһ��λhp <25%
	["35"] = {
		comment = "����ĳ��λhp<25%",
		fn = function(charIndex, side, battleIndex)
			local defChars = getDeffenderSide(charIndex, side, battleIndex)
			return _.any(defChars, function(charIndex)
				return Char.GetData(charIndex, CONST.����_Ѫ) / Char.GetData(charIndex, CONST.����_���Ѫ) < 0.25
			end)
		end
	},
	-- NOTE �Է�ĳһ��λmp>50��<75%
	["36"] = {
		comment = "����ĳһ��λmp>50��<75%",
		fn = function(charIndex, side, battleIndex)
			local defChars = getDeffenderSide(charIndex, side, battleIndex)
			return _.any(defChars, function(charIndex)
				local mp = Char.GetData(charIndex, CONST.����_ħ)
				local mpRatio = Char.GetData(charIndex, CONST.����_ħ) / Char.GetData(charIndex, CONST.����_���ħ)
				local name = Char.GetData(charIndex, CONST.����_����)
				if mp >= 50 and mpRatio <= 0.75 then
					-- print(name ..' >> ' .. mp .. ' : ' .. mpRatio)
				end
				return mp >= 50 and mpRatio <= 0.75
			end)
		end
	},
	-- NOTE ��һ�غ�
	['54'] = {
		comment = "��һ�غ�",
		fn = function(charIndex, side, battleIndex) return Battle.GetTurn(battleIndex) == 0 end
	},
	-- NOTE �����غ�
	['55'] = {
		comment = "�攵�غ�",
		fn = function(charIndex, side, battleIndex) return math.fmod(Battle.GetTurn(battleIndex) + 1, 2) == 1 end
	},
	-- NOTE ż���غ�
	['56'] = {
		comment = "ż���غ�",
		fn = function(charIndex, side, battleIndex) return math.fmod(Battle.GetTurn(battleIndex) + 1, 2) == 0 end
	},
	-- NOTE ���2�غ�
	['57'] = {
		comment = "�g����2�غ�",
		fn = function(charIndex, side, battleIndex) return math.fmod(Battle.GetTurn(battleIndex), 2) == 0 end
	},
	-- NOTE ���3�غ�
	['58'] = {
		comment = "�g����3�غ�",
		fn = function(charIndex, side, battleIndex) return math.fmod(Battle.GetTurn(battleIndex), 3) == 0 end
	},
	-- NOTE ���4�غ�
	['59'] = {
		comment = "�g����4�غ�",
		fn = function(charIndex, side, battleIndex) return math.fmod(Battle.GetTurn(battleIndex), 4) == 0 end
	},
	-- NOTE ���5�غ�
	['60'] = {
		comment = "�g����5�غ�",
		fn = function(charIndex, side, battleIndex) return math.fmod(Battle.GetTurn(battleIndex), 5) == 0 end
	},
	-- NOTE ���6�غ�
	['61'] = {
		comment = "�g����6�غ�",
		fn = function(charIndex, side, battleIndex) return math.fmod(Battle.GetTurn(battleIndex), 6) == 0 end
	},
	-- NOTE ���7�غ�
	['62'] = {
		comment = "�g����7�غ�",
		fn = function(charIndex, side, battleIndex) return math.fmod(Battle.GetTurn(battleIndex), 7) == 0 end
	},
	-- NOTE ���8�غ�
	['63'] = {
		comment = "�g����8�غ�",
		fn = function(charIndex, side, battleIndex) return math.fmod(Battle.GetTurn(battleIndex), 8) == 0 end
	},
	-- NOTE ���9�غ�
	['64'] = {
		comment = "�g����9�غ�",
		fn = function(charIndex, side, battleIndex) return math.fmod(Battle.GetTurn(battleIndex), 9) == 0 end
	},
	-- NOTE ���10�غ�
	['65'] = {
		comment = "�g����10�غ�",
		fn = function(charIndex, side, battleIndex) return math.fmod(Battle.GetTurn(battleIndex), 10) == 0 end
	},
	-- NOTE ���11�غ�
	['66'] = {
		comment = "�g����11�غ�",
		fn = function(charIndex, side, battleIndex) return math.fmod(Battle.GetTurn(battleIndex), 11) == 0 end
	},
	-- NOTE ���12�غ�
	['67'] = {
		comment = "�g����12�غ�",
		fn = function(charIndex, side, battleIndex) return math.fmod(Battle.GetTurn(battleIndex), 12) == 0 end
	},
	-- NOTE �Է�ֻ��һ�����
	["82"] = {
		comment = "����ֻ��һ�����",
		fn = function(charIndex, side, battleIndex) return livesDefNum(charIndex, side, battleIndex) == 1 end
	},
	-- NOTE �Է���� >1
	["83"] = {
		comment = "������>1",
		fn = function(charIndex, side, battleIndex) return livesDefNum(charIndex, side, battleIndex) >= 1 end
	},
	-- NOTE �Է���� >2
	["84"] = {
		comment = "������>2",
		fn = function(charIndex, side, battleIndex) return livesDefNum(charIndex, side, battleIndex) > 2 end
	},
	-- NOTE �Է���� >3
	["85"] = {
		comment = "������>3",
		fn = function(charIndex, side, battleIndex) return livesDefNum(charIndex, side, battleIndex) > 3 end
	},
	-- NOTE �Է���� >5
	["86"] = {
		comment = "������>5",
		fn = function(charIndex, side, battleIndex) return livesDefNum(charIndex, side, battleIndex) > 5 end
	},
	-- NOTE �Է���� >6
	["87"] = {
		comment = "������>6",
		fn = function(charIndex, side, battleIndex) return livesDefNum(charIndex, side, battleIndex) > 6 end
	},

	-- NOTE ��һ�غ�
	["89"] = {
		comment = "�ǵ�һ�غ�",
		fn = function(charIndex, side, battleIndex) return Battle.GetTurn(battleIndex) == 0 end
	},


	-- --  ���� mp<0.25
	-- ['90']= function(charIndex) return getMp(charIndex)/getMaxMp(charIndex)<0.25 end,
	-- --  ���� mp<0.15
	-- ['91']= function(charIndex) return getMp(charIndex)/getMaxMp(charIndex)<0.15 end,
	-- --  ���� mp<0.05
	-- ['92']= function(charIndex) return getMp(charIndex)/getMaxMp(charIndex)<0.05 end,
	-- NOTE ����HP<50%����5��
	["93"] = {
		comment = "����HP<50%���^5��",
		fn = function(charIndex, side, battleIndex) return partyLowerHPNum(charIndex, side, battleIndex, 0.5, 5) end
	},
	-- NOTE ����HP<50%����4��
	["94"] = {
		comment = "����HP<50%���^4��",
		fn = function(charIndex, side, battleIndex) return partyLowerHPNum(charIndex, side, battleIndex, 0.5, 4) end
	},
	-- NOTE ����HP<75%����5��
	["95"] = {
		comment = "����HP<75%���^5��",
		fn = function(charIndex, side, battleIndex) return partyLowerHPNum(charIndex, side, battleIndex, 0.75, 5) end
	},
	-- NOTE ����HP<75%����4��
	["96"] = {
		comment = "����HP<75%���^4��",
		fn = function(charIndex, side, battleIndex) return partyLowerHPNum(charIndex, side, battleIndex, 0.75, 4) end
	},
	-- NOTE ����������ս��
	["97"] = {
		comment = "�������������",
		fn = function(charIndex, side, battleIndex) return deadPlayerNum(charIndex, side, battleIndex) >= 1 end
	},
	["98"] = {
		comment = "�����І�λ����",
		fn = function(charIndex, side, battleIndex) return deadNum(charIndex, side, battleIndex) >= 1 end
	},
	-- NOTE �Է���� <=8
	["99"] = {
		comment = "������<=8",
		fn = function(charIndex, side, battleIndex) return livesDefNum(charIndex, side, battleIndex) <= 8 end
	},
	-- NOTE �Է���� <=5
	["100"] = {
		comment = "������<=5",
		fn = function(charIndex, side, battleIndex) return livesDefNum(charIndex, side, battleIndex) <= 5 end
	},
	-- NOTE �Է���� <=4
	["101"] = {
		comment = "������<=4",
		fn = function(charIndex, side, battleIndex) return livesDefNum(charIndex, side, battleIndex) <= 4 end
	},
	-- NOTE �Է���� <=3
	["102"] = {
		comment = "������<=3",
		fn = function(charIndex, side, battleIndex) return livesDefNum(charIndex, side, battleIndex) <= 3 end
	},
	-- NOTE �Է���� <=2
	["103"] = {
		comment = "������<=2",
		fn = function(charIndex, side, battleIndex) return livesDefNum(charIndex, side, battleIndex) <= 2 end
	},
	-- NOTE �Է���� <=1
	["104"] = {
		comment = "������<=1",
		fn = function(charIndex, side, battleIndex) return livesDefNum(charIndex, side, battleIndex) <= 1 end
	},
	--NOTE ����HP<30%����0��
	["105"] = {
		comment = "����HP<30%>=1��",
		fn = function(charIndex, side, battleIndex) return partyLowerHPNum(charIndex, side, battleIndex, 0.3, 0) end
	},
	--NOTE ����HP<40%����0��
	["106"] = {
		comment = "����HP<40%>=1��",
		fn = function(charIndex, side, battleIndex) return partyLowerHPNum(charIndex, side, battleIndex, 0.4, 0) end
	},
	--NOTE ����HP<40%����3��
	["107"] = {
		comment = "����HP<40%>=2��",
		fn = function(charIndex, side, battleIndex) return partyLowerHPNum(charIndex, side, battleIndex, 0.4, 2) end
	},
	--NOTE ����HP<50%����1��
	["108"] = {
		comment = "����HP<50%>=1��",
		fn = function(charIndex, side, battleIndex) return partyLowerHPNum(charIndex, side, battleIndex, 0.5, 0) end
	},
	-- NOTE �������쳣����>=1
	['201'] = {
		comment = "�����Ю����˔�>=1",
		fn = function(charIndex, side, battleIndex) return gotAnyStatusNum(charIndex, side, battleIndex) >= 1 end
	},
	-- NOTE �������쳣����>=3
	['202'] = {
		comment = "�����Ю����˔�>=3",
		fn = function(charIndex, side, battleIndex) return gotAnyStatusNum(charIndex, side, battleIndex) >= 3 end
	},
	-- NOTE �������쳣����>=5
	['203'] = {
		comment = "�����Ю����˔�>=5",
		fn = function(charIndex, side, battleIndex) return gotAnyStatusNum(charIndex, side, battleIndex) >= 5 end
	},
}
-- !SECTION


-- NOTE target ��ȡ���� �ж� range Ϊ 2��3 �����
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



-- NOTE ���Ŀ��
-- side 0 ���·��� 1 ���Ϸ�
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
	-- �����ʵλ��
	local result = getEntryPositionBySlot(battleIndex, randomSlot)
	if range == 0 then
		return result
	end
	if range == 1 then
		return result + 20
	end
	return result
end)



-- NOTE Ѫ����
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
			local hp = Char.GetData(charIndex, CONST.����_Ѫ)
			if tagHp == nil then
				tagHp = hp
				returnSlot = slot
			elseif hp > tagHp then
				tagHp = hp;
				returnSlot = slot
			end
		end
	end
	-- �����ʵλ��
	local result = getEntryPositionBySlot(battleIndex, returnSlot)
	if range == 0 then
		return result
	end
	if range == 1 then
		return result + 20
	end
	return result
end)
-- NOTE Ѫ���ٵ�
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
			local hp = Char.GetData(charIndex, CONST.����_Ѫ)
			if tagHp == nil then
				tagHp = hp
				returnSlot = slot
			elseif hp < tagHp then
				tagHp = hp;
				returnSlot = slot
			end
		end
	end
	-- �����ʵλ��
	local result = getEntryPositionBySlot(battleIndex, returnSlot)
	if range == 0 then
		return result
	end
	if range == 1 then
		return result + 20
	end
	return result
end)
-- NOTE Ѫ��ռ����͵�
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
	-- �����ʵλ��
	local result = getEntryPositionBySlot(battleIndex, returnSlot)
	if range == 0 then
		return result
	end
	if range == 1 then
		return result + 20
	end
	return result
end)

-- NOTE ħ����
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
			local mp = Char.GetData(charIndex, CONST.����_ħ)
			if tagMp == nil then
				tagMp = mp
				returnSlot = slot
			elseif mp > tagMp then
				tagMp = mp;
				returnSlot = slot
			end
		end
	end
	-- �����ʵλ��
	local result = getEntryPositionBySlot(battleIndex, returnSlot)
	if range == 0 then
		return result
	end
	if range == 1 then
		return result + 20
	end
	return result
end)
-- NOTE ħ���ٵ�
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
			local mp = Char.GetData(charIndex, CONST.����_ħ)
			if tagMp == nil then
				tagMp = mp
				returnSlot = slot
			elseif mp < tagMp then
				tagMp = mp;
				returnSlot = slot
			end
		end
	end
	-- �����ʵλ��
	local result = getEntryPositionBySlot(battleIndex, returnSlot)
	if range == 0 then
		return result
	end
	if range == 1 then
		return result + 20
	end
	return result
end)
-- NOTE ħ��ռ����͵�
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
	-- �����ʵλ��
	local result = getEntryPositionBySlot(battleIndex, returnSlot)
	if range == 0 then
		return result
	end
	if range == 1 then
		return result + 20
	end
	return result
end)

-- NOTE �����ҵ�λ����Ӷ����
local findRandomPlayer = _.wrap(getTargetWithRange23, function(func, side, battleIndex, range)
	local isRange23 = func(side, range)
	if isRange23 ~= nil then
		return isRange23
	end
	local slotTable = {}

	for slot = side * 10 + 0, side * 10 + 9 do
		local charIndex = Battle.GetPlayer(battleIndex, slot)
		if (charIndex >= 0 and Char.GetData(charIndex, CONST.����_����) == CONST.��������_��) then
			table.insert(slotTable, slot)
		end
	end
	local returnSlot = slotTable[NLG.Rand(1, #slotTable)]
	-- �����ʵλ��
	local result = getEntryPositionBySlot(battleIndex, returnSlot)
	if range == 0 then
		return result
	end
	if range == 1 then
		return result + 20
	end
	return result
end)

-- NOTE ������ﵥλ
local findRandomPet = _.wrap(getTargetWithRange23, function(func, side, battleIndex, range)
	local isRange23 = func(side, range)
	if isRange23 ~= nil then
		return isRange23
	end

	local slotTable = {}

	for slot = side * 10 + 0, side * 10 + 9 do
		local charIndex = Battle.GetPlayer(battleIndex, slot)
		if (charIndex >= 0 and Char.GetData(charIndex, CONST.����_����) == CONST.��������_��) then
			table.insert(slotTable, slot)
		end
	end
	local returnSlot = slotTable[NLG.Rand(1, #slotTable)]
	-- �����ʵλ��
	local result = getEntryPositionBySlot(battleIndex, returnSlot)
	if range == 0 then
		return result
	end
	if range == 1 then
		return result + 20
	end
	return result
end)
-- NOTE ��ȡ��������
local findDeadPlayer = _.wrap(getTargetWithRange23, function(func, side, battleIndex, range)
	local isRange23 = func(side, range)
	if isRange23 ~= nil then
		return isRange23
	end
	local returnSlot;

	for slot = side * 10 + 0, side * 10 + 9 do
		local charIndex = Battle.GetPlayer(battleIndex, slot)

		if charIndex >= 0 and Char.GetData(charIndex, CONST.����_ս��) == 1 and Char.GetData(charIndex, CONST.����_����) == CONST.��������_�� then
			returnSlot = slot
		end
	end
	-- �����ʵλ��
	local result = getEntryPositionBySlot(battleIndex, returnSlot)
	if range == 0 then
		return result
	end
	if range == 1 then
		return result + 20
	end
	return result
end)

-- NOTE ��ȡս����λ
local findDeadUnit = _.wrap(getTargetWithRange23, function(func, side, battleIndex, range)
	local isRange23 = func(side, range)
	if isRange23 ~= nil then
		return isRange23
	end

	local slotTable = {}
	for slot = side * 10 + 0, side * 10 + 9 do
		local charIndex = Battle.GetPlayer(battleIndex, slot)
		if charIndex >= 0 and Char.GetData(charIndex, CONST.����_ս��) == 1 then
			table.insert(slotTable, slot)
		end
	end
	local returnSlot = slotTable[NLG.Rand(1, #slotTable)]
	-- �����ʵλ��
	local result = getEntryPositionBySlot(battleIndex, returnSlot)
	if range == 0 then
		return result
	end
	if range == 1 then
		return result + 20
	end
	return result
end)

-- NOTE ����쳣��λ
local randStatusUnit = _.wrap(getTargetWithRange23, function(func, side, battleIndex, range)
	local isRange23 = func(side, range)
	if isRange23 ~= nil then
		return isRange23
	end

	local slotTable = {}

	for slot = side * 10 + 0, side * 10 + 9 do
		local charIndex = Battle.GetPlayer(battleIndex, slot)
		if charIndex >= 0 then
			if (Char.GetData(charIndex, CONST.����_ModPoison) > 1 or
					Char.GetData(charIndex, CONST.����_ModSleep) > 1 or
					Char.GetData(charIndex, CONST.����_ModStone) > 1 or
					Char.GetData(charIndex, CONST.����_ModDrunk) > 1 or
					Char.GetData(charIndex, CONST.����_ModConfusion) > 1 or
					Char.GetData(charIndex, CONST.����_ModAmnesia) > 1) then
				table.insert(slotTable, slot)
			end
		end
	end
	local returnSlot = slotTable[NLG.Rand(1, #slotTable)]
	-- �����ʵλ��
	local result = getEntryPositionBySlot(battleIndex, returnSlot)
	if range == 0 then
		return result
	end
	if range == 1 then
		return result + 20
	end
	return result
end)

-- NOTE �з��ȼ���ߵ�λ
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
			local level = Char.GetData(charIndex, CONST.����_�ȼ�)
			if tagLv == nil then
				tagLv = level
				returnSlot = slot
			elseif level < tagLv then
				tagLv = level;
				returnSlot = slot
			end
		end
	end

	-- �����ʵλ��
	local result = getEntryPositionBySlot(battleIndex, returnSlot)
	if range == 0 then
		return result
	end
	if range == 1 then
		return result + 20
	end
	return result
end)

-- NOTE �з�ħ��>5%�ҵȼ���ߵ�λ
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
			local level = Char.GetData(charIndex, CONST.����_�ȼ�)
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

	-- �����ʵλ��
	local result = getEntryPositionBySlot(battleIndex, returnSlot)
	if range == 0 then
		return result
	end
	if range == 1 then
		return result + 20
	end
	return result
end)

-- NOTE �Է�ħ��>50��С��75%��
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
			local level = Char.GetData(charIndex, CONST.����_�ȼ�)
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

	-- �����ʵλ��
	local result = getEntryPositionBySlot(battleIndex, returnSlot)
	if range == 0 then
		return result
	end
	if range == 1 then
		return result + 20
	end
	return result
end)

-- SECTION Ŀ��
module.target = {
	-- NOTE 0  ��������
	["0"] = {
		comment = "����",
		fn = function(charIndex, side, battleIndex, slot, range) return slot end
	},
	-- NOTE 1 ������Ӫ ���
	["1"] = {
		comment = "�����S�C��λ",
		fn = function(charIndex, side, battleIndex, slot, range) return randomTarget(side, battleIndex, range) end
	},
	-- NOTE 2 �Է���Ӫ ���
	["2"] = {
		comment = "�����S�C��λ",
		fn = function(charIndex, side, battleIndex, slot, range) return randomTarget(oppositeSide(side), battleIndex,
				range) end
	},
	-- NOTE 3 ����Ѫ����
	["3"] = {
		comment = "����Ѫ����",
		fn = function(charIndex, side, battleIndex, slot, range) return findMostHp(side, battleIndex, range) end
	},
	-- NOTE �Է�Ѫ����
	["4"] = {
		comment = "����Ѫ����",
		fn = function(charIndex, side, battleIndex, slot, range) return findMostHp(oppositeSide(side), battleIndex, range) end
	},
	-- NOTE ����Ѫ���ٵ�
	["5"] = {
		comment = "����Ѫ���ٵ�",
		fn = function(charIndex, side, battleIndex, slot, range) return findLeastHp(side, battleIndex, range) end
	},
	-- NOTE �Է�Ѫ���ٵ�
	["6"] = {
		comment = "����Ѫ���ٵ�",
		fn = function(charIndex, side, battleIndex, slot, range) return findLeastHp(oppositeSide(side), battleIndex,
				range) end
	},
	-- NOTE ����Ѫ��ռ�����
	["7"] = {
		comment = "����Ѫ��ռ����͵�",
		fn = function(charIndex, side, battleIndex, slot, range) return findLeastHpRatio(side, battleIndex, range) end
	},
	-- NOTE �Է�Ѫ��ռ�����
	["8"] = {
		comment = "����Ѫ��ռ����͵�",
		fn = function(charIndex, side, battleIndex, slot, range)
			return findLeastHpRatio(oppositeSide(side), battleIndex,
				range)
		end
	},
	-- �Է�ħ��͵�
	["9"] = {
		comment = "����ħ��ռ����͵�",
		fn = function(charIndex, side, battleIndex, slot, range)
			return findLeastMpRatio(oppositeSide(side), battleIndex,
				range)
		end
	},
	-- �Է�ħ��>5%�ҵȼ���ߵ�
	["10"] = {
		comment = "����ħ��>5%�ҵȼ���ߵ�",
		fn = function(charIndex, side, battleIndex, slot, range)
			return findMostLevelandMp5(oppositeSide(side), battleIndex,
				range)
		end
	},
	-- �Է��ȼ���ߵ�
	["11"] = {
		comment = "�����ȼ���ߵ�",
		fn = function(charIndex, side, battleIndex, slot, range) return findMostLevel(oppositeSide(side), battleIndex,
				range) end
	},
	-- �Է��ȼ���͵�
	-- �Է�ħ��>50��С��75%��
	["13"] = {
		comment = "����ħ��>50��С�75%��",
		fn = function(charIndex, side, battleIndex, slot, range)
			return findMp50To75per(oppositeSide(side), battleIndex,
				range)
		end
	},
	-- NOTE ���������ҵ�λ
	["44"] = {
		comment = "�����S�C����",
		fn = function(charIndex, side, battleIndex, slot, range) return findRandomPlayer(side, battleIndex, range) end
	},
	-- NOTE ����������ﵥλ
	["45"] = {
		comment = "�����S�C����",
		fn = function(charIndex, side, battleIndex, slot, range) return findRandomPet(side, battleIndex, range) end
	},
	-- NOTE �������ս������
	["46"] = {
		comment = "������������",
		fn = function(charIndex, side, battleIndex, slot, range) return findDeadPlayer(side, battleIndex, range) end
	},
	-- NOTE �������ս����λ
	["47"] = {
		comment = "�����S�C������λ",
		fn = function(charIndex, side, battleIndex, slot, range) return findDeadUnit(side, battleIndex, range) end
	},
	-- NOTE ��������쳣��λ
	["48"] = {
		comment = "�����S�C������λ",
		fn = function(charIndex, side, battleIndex, slot, range) return randStatusUnit(side, battleIndex, range) end
	},
}
-- !SECTION

-- NOTE �������Ϊ����
-- params: charIndex���Լ���index, side���Լ���side�� battleIndex, slot���Լ���slot�� commands��aiָ������
-- return: {com1, targetSlot, techId}
function module:calcActionData(charIndex, side, battleIndex, slot, commands)
	-- print("��ʼ",JSON.stringify(commands),charIndex)
	-- print("������",charIndex,side,battleIndex,slot,commands)
	for i = 1, #commands do
		local command = commands[i]
		local conditionId = command[1]
		local targetId = command[2]
		local techId = tonumber(command[3])

		-- print('>>>>', command, conditionId, targetId, techId);
		-- �Ƿ����� condition
		local conditionFn = self.conditions[tostring(conditionId)]["fn"];
		-- print("��ʼ��������::", i, self.conditions[tostring(conditionId)]["comment"], techId)
		if conditionFn(charIndex, side, battleIndex) then
			-- print('>>>', self.conditions[tostring(conditionId)]["comment"], conditionFn(charIndex,side,battleIndex))
			local fp = 0;
			if techId == -100 or techId == -200 then
				fp = 0;
			else
				local techIndex = Tech.GetTechIndex(techId)
				fp = Tech.GetData(techIndex, CONST.TECH_FORCEPOINT)
				-- local techName = Tech.GetData(techIndex, CONST.TECH_NAME)
				-- print('>>>' .. techName .. '��ħ:' .. fp);
			end

			local mp = Char.GetData(charIndex, CONST.����_ħ)

			if fp > mp then
				return { CONST.BATTLE_COM.BATTLE_COM_ATTACK, self.target["6"]["fn"](charIndex, side, battleIndex, slot, 0), -1 }
			end

			-- ��֤ range
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
				-- ��ս��ʱ, �����com1,target,targetId����ĳ����� nil,16,13
				-- ��ս��ʱ, �����˴����table: {"2":16,"3":609}, ��ȷ��ӦΪ{com1(��autoBattleParams),λ��,techId}
				return { com1, target, techId }
			end
		end
		-- print("����������, ��һ��")
	end
	local target = randomTarget(oppositeSide(side), battleIndex, 0)
	-- ���������� �ͷ�Ĭ�ϼ��ܣ�Ŀ�����
	return { CONST.BATTLE_COM.BATTLE_COM_ATTACK, randomTarget(oppositeSide(side), battleIndex, 0), -1 }
end

-- ANCHOR �������� heresAI.txt
function module:loadData()
	print('heroes >> ����heroesAI.txt');
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

-- SECTION Ӷ��AInpc
-- NOTE �������̿���
function module:AINpcTalked(npc, charIndex, seqno, select, data)
	-- print(npc, charIndex, seqno, select, data)
	data = tonumber(data)
	if select == CONST.BUTTON_�ر� then
		return;
	end
	-- NOTE  1 Ӷ���б�
	if seqno == 1 and data > 0 then
		self:showChooseType(charIndex, data)
	end
	--  NOTE  2 ѡ��Ai
	if seqno == 2 then
		-- ѡ�������һҳ ��һҳ
		if data < 0 then
			local page;
			if select == 32 then
				page = sgModule:get(charIndex, "statusPage") + 1
			elseif select == 16 then
				page = sgModule:get(charIndex, "statusPage") - 1
			end
			if page == 0 then
				-- ������һ��
				self:showChooseType(charIndex, nil, sgModule:get(charIndex, "heroSelected4AI"))
				return
			end
			sgModule:set(charIndex, "statusPage", page)
			self:showAIList(charIndex, page)
		else
			self:showAIComment(charIndex, data)
		end
	end
	-- NOTE 3 AI˵��
	if seqno == 3 then
		if select == CONST.BUTTON_ȷ�� then
			self:showCampHeroSkillSlot(charIndex, data)
		end
	end
	-- NOTE  4 ����ѡ����
	if seqno == 4 and data > 0 then
		self:getAI(charIndex, data)
	end
	-- NOTE 5 ѡ������
	if seqno == 5 then
		if data < 0 then
		else
			self:toShowAiList(charIndex, data)
		end
	end
end

-- NOTE Ӷ��ѡ�� ��ҳ seqno:1
function module:showAINpcHome(npc, charIndex)
	local windowStr = getModule("heroesFn"):buildCampHeroesList(charIndex)
	NLG.ShowWindowTalked(charIndex, self.AINpc, CONST.����_ѡ���, CONST.BUTTON_�ر�, 1, windowStr);
end

-- NOTE ѡ����ﻹ��Ӷ�� seqno:5
function module:showChooseType(charIndex, data, heroData)
	if data ~= nil and heroData == nil then
		local campHeroes = getModule("heroesFn"):getCampHeroesData(charIndex)
		heroData = campHeroes[data]
		sgModule:set(charIndex, "heroSelected4AI", heroData)
	elseif data == nil and heroData ~= nil then
		sgModule:set(charIndex, "heroSelected4AI", heroData)
	end

	local items = { "�O��ⷰ�AI", "�O�Ì���AI", }

	local title = "��Ո�x��Ҫ�O��AI����"
	local windowStr = self:NPC_buildSelectionText(title, items);
	NLG.ShowWindowTalked(charIndex, self.AINpc, CONST.����_ѡ���, CONST.BUTTON_��ȡ��, 5, windowStr);
end

-- NOTE ��ʾAI�б�
function module:toShowAiList(charIndex, data)
	sgModule:set(charIndex, "chartypeSelected4AI", data - 1)
	local heroData = sgModule:get(charIndex, "heroSelected4AI")
	local heroLevel = Char.GetData(heroData.index, CONST.����_�ȼ�)

	local itemsData = _.select(self.aiData, function(ai)
		local levelRequired = ai.level

		local isLevelQualified = true;
		local isJobQualified = true;
		local heroJobAncestry = Char.GetData(heroData.index, CONST.����_ְ��ID)
		
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

-- NOTE ��ʾAI�б� seqno:2
function module:showAIList(charIndex, page)
	local itemsData = sgModule:get(charIndex, "aiDataList4AI")
	local items = _.map(itemsData, function(ai) return ai.name end)
	local title = "���x��AI���Բ鿴�f����"
	local buttonType, windowStr = self:dynamicListData(items, title, page)

	NLG.ShowWindowTalked(charIndex, self.AINpc, CONST.����_ѡ���, buttonType, 2, windowStr);
end

-- NOTE ��̬�б���������
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
		buttonType = CONST.BUTTON_��ȡ��
	elseif page == 1 then
		buttonType = CONST.BUTTON_����ȡ��
	elseif page == totalPage then
		buttonType = CONST.BUTTON_��ȡ��
	else
		buttonType = CONST.BUTTON_����ȡ��
	end
	return buttonType, windowStr
end

-- NOTE AI˵�� seno:3
function module:showAIComment(charIndex, data)
	local heroData = sgModule:get(charIndex, "heroSelected4AI")
	local page = sgModule:get(charIndex, "statusPage")
	local index = (page - 1) * 8 + data

	local aiData = sgModule:get(charIndex, "aiDataList4AI")
	local aiDataSelected = aiData[index]

	local aiId = aiDataSelected.id
	sgModule:set(charIndex, "aiSelected", aiId);
	local commands = aiDataSelected.commands

	-- �ж� �Ƿ�����ȼ��� ְҵҪ��
	local levelRequired = aiDataSelected.level

	local heroLevel = Char.GetData(heroData.index, CONST.����_�ȼ�)

	local heroJobAncestry = Char.GetData(heroData.index, CONST.����_ְ��ID)
	local isLevelQualified = true;
	local isJobQualified = true;
	local warning = ""
	if (math.floor(heroLevel / 10) + 1) < levelRequired then
		isLevelQualified = false;
		warning = warning .. "ⷰ�ĵȼ�����"
	end
	if heroJobAncestry ~= aiDataSelected.jobAncestry and aiDataSelected.jobAncestry >= 0 then
		isJobQualified = false
		warning = warning .. "ⷰ���I������"
	end

	local title = "��AI�Є��f��\\n\\n"

	local windowStr = title .. _(commands):chain():map(function(command)
			local conditionId = command[1]
			local targetId = command[2]

			local techId = tonumber(command[3])
			if conditionId~=nil and targetId~=nil and techId~=nil  then
				local techName = ""
				if techId == -100 or techId == -200 then
					techName = techId == -100 and "����" or "����"
				else
					local techIndex = Tech.GetTechIndex(techId)
					techName = Tech.GetData(techIndex, CONST.TECH_NAME)
				end

				str = "��" .. self.conditions[tostring(conditionId)]["comment"]
					.. "���� ��" .. self.target[tostring(targetId)]["comment"] .. "��ʹ�� ��" .. techName .. "��"
			else
				--str = "������������ ���ն���ʹ�� ���ռ��ܡ�"
				str = ""
			end
			return str;
		end):join("\\n\\n"):value()
		.. "\\n\\n���Д���������������£��c���_�������x���AI��\n\n" .. warning
	local buttonType = (isLevelQualified and isJobQualified) and CONST.BUTTON_ȷ���ر� or CONST.BUTTON_�ر�
	NLG.ShowWindowTalked(charIndex, self.AINpc, CONST.����_����Ϣ��, buttonType, 3, windowStr);
end

-- NOTE ��ʾӶ�������� seqno:3
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
	NLG.ShowWindowTalked(charIndex, self.AINpc, CONST.����_ѡ���, CONST.BUTTON_��ȡ��, 4, windowStr);
end

-- NOTE �Ǽ�AI
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

	local name = Char.GetData(heroData.index, CONST.����_����)
	NLG.SystemMessage(charIndex, name .. " ӛ��˴�AI��Ո��ⷰ����I�x�Ά��á�")
end

-- !SECTION


--- ����ģ�鹳��
function module:onLoad()
	self:logInfo('load')
	self.aiData = self:loadData();
	-- print(JSON.stringify(self.aiData))
	-- ���õ�
	self.AINpc = self:NPC_createNormal('ⷰ���g', 231050, { x = 29, y = 27, mapType = 0, map = 7351, direction = 4 });
	-- self.AINpc = self:NPC_createNormal('�ж�ģʽ����', 106452, { x = 30, y = 22, mapType = 0, map = 35800, direction = 6 });
	self:NPC_regTalkedEvent(self.AINpc, Func.bind(self.showAINpcHome, self));
	self:NPC_regWindowTalkedEvent(self.AINpc, Func.bind(self.AINpcTalked, self));
end

--- ж��ģ�鹳��
function module:onUnload()
	self:logInfo('unload')
end

return module;
