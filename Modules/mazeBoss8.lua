local Module = ModuleBase:createModule('mazeBoss8')

local 移动怪物encount = 406214--移动怪物的encount编号
local 警戒间隔时间 = 1--单位秒，勿改
local 移动怪物移速 = 230--单位毫秒, 慎重修改，目前比玩家略快
local 战后停顿时间 = 30--单位秒, 含最后一回合动画
local 刷新时间 = 1800--单位秒
local 扫描范围 = 20--大小为(扫描范围*2)*(扫描范围*2)格子
local 战斗数据 = {}
local 停顿 = 1
local 目标 = -1
local count = 0
local 战斗对象 = {1, 2, 3}--和下表长度一致
local 战斗对象等级 = {3, 4, 5}--和上表长度一致
local 巡逻路线 = {7, 5, 3, 1}--往人物方向移动，确保不会被挡住，会回到原点
--名字, 外观, X, Y, 地图类型, 地图, 方向
local 移动怪物数据 = {'索拉斯', 108171, 46, 39, 0, 60016, 6}
local 辅助NPC数据 = {'辅助NPC', 105502, 18, 0, 0, 666, 6}
local 移动怪物说话 = {'凡人啊，你的貪婪將帶來毀滅，這裡的寶藏並非為你所用。', '我是這片墳場的守護者，我警告你，停止你的企圖，否則將受到無盡的苦痛。', 
'龍族的寶藏不是為了人類的私慾而存在的，你若想尋找真正的寶藏，就要用心去尋找內在的光明。', '墳場的寶藏蘊含著古老的智慧和神聖的力量，它們不應被污染，你應該以敬畏之心對待。', 
 '離開這裡，否則你將面臨我龍族的憤怒，它將是你無法承受的。' }

function Module:onLoad()
	self:logInfo('load');
	local 移动怪物 = self:NPC_createNormal(移动怪物数据[1], 移动怪物数据[2], { x = 移动怪物数据[3], y = 移动怪物数据[4], mapType = 移动怪物数据[5], map = 移动怪物数据[6], direction = 移动怪物数据[7] });
	local 警戒范围 = self:NPC_createNormal(辅助NPC数据[1], 辅助NPC数据[2], { x = 辅助NPC数据[3], y = 辅助NPC数据[4], mapType = 辅助NPC数据[5], map = 辅助NPC数据[6], direction = 辅助NPC数据[7] });
	local 战后停顿 = self:NPC_createNormal(辅助NPC数据[1], 辅助NPC数据[2], { x = 辅助NPC数据[3], y = 辅助NPC数据[4], mapType = 辅助NPC数据[5], map = 辅助NPC数据[6], direction = 辅助NPC数据[7] });
	self:regCallback('LoopEvent', Func.bind(self.移动怪物回调, self))
	self:regCallback('LoopEvent', Func.bind(self.警戒范围回调, self))
	self:regCallback('LoopEvent', Func.bind(self.战后停顿回调, self))
	Char.SetLoopEvent(nil, '警戒范围回调', 警戒范围, 警戒间隔时间*1000)
	self:regCallback('警戒范围回调', function(警戒范围)
	if 目标 == -1 then
		Char.SetData(移动怪物, %对象_地图类型%, 移动怪物数据[5])
		Char.SetData(移动怪物, %对象_地图%, 移动怪物数据[6])
		Char.SetData(移动怪物, %对象_X%, 移动怪物数据[3])
		Char.SetData(移动怪物, %对象_Y%, 移动怪物数据[4])
		目标 = -2
		count = 0
		NLG.UpChar(移动怪物)
		return
	end
	local nowcount = math.fmod(count, #巡逻路线) + 1
	NLG.WalkMove(移动怪物, 巡逻路线[nowcount])
	NLG.UpChar(移动怪物)
	count = count + 1
	local X = tonumber(Char.GetData(移动怪物, %对象_X%))
	local Y = tonumber(Char.GetData(移动怪物, %对象_Y%))
	for i=(X-扫描范围), (X+扫描范围) do
		for j=(Y-扫描范围),(Y+扫描范围) do
			local 地面物品数量, 地面物品 = Obj.GetObject(移动怪物数据[5], 移动怪物数据[6], i, j)
			if #地面物品 > 0 then
				for k = 1, #地面物品 do
					local 玩家 = Obj.GetCharIndex(地面物品[k])
					if Char.GetData(玩家, CONST.CHAR_类型) == CONST.对象类型_人 and not Char.IsDummy(玩家) then
						目标 = tonumber(玩家)
						NLG.TalkToMap(移动怪物数据[5], 移动怪物数据[6], 移动怪物, 移动怪物说话[1], %颜色_红色%, 0)
						Char.SetLoopEvent(nil, '移动怪物回调', 移动怪物, 移动怪物移速)
						Char.SetLoopEvent(nil, '警戒范围回调', 警戒范围, 0)
						break
					end
				end
			end
		end
	end
	end)
	self:regCallback('移动怪物回调', function(移动怪物)
	if Char.GetData(目标, CONST.CHAR_类型) ~= CONST.对象类型_人 then
		目标 = -1
		Char.SetLoopEvent(nil, '警戒范围回调', 警戒范围, 警戒间隔时间*1000)
		Char.SetLoopEvent(nil, '移动怪物回调', 移动怪物, 0)
		return
	end
	local MAP1 = Char.GetData(目标, %对象_地图类型%)
	local FLOOR1 = Char.GetData(目标, %对象_地图%)
	local X1 = tonumber(Char.GetData(目标, %对象_X%))
	local Y1 = tonumber(Char.GetData(目标, %对象_Y%))
	local X = tonumber(Char.GetData(移动怪物, %对象_X%))
	local Y = tonumber(Char.GetData(移动怪物, %对象_Y%))
	if MAP1 ~= 移动怪物数据[5] or FLOOR1 ~= 移动怪物数据[6] then
		目标 = -1
		Char.SetLoopEvent(nil, '警戒范围回调', 警戒范围, 警戒间隔时间*1000)
		Char.SetLoopEvent(nil, '移动怪物回调', 移动怪物, 0)
		return
	end
	local 追踪方向, 追踪结果 = 移动方向(X, Y, X1, Y1)
	if 追踪结果 then
		local battleIndex = Char.GetBattleIndex(目标)
		if battleIndex >= 0 then
			return
		end
		NLG.TalkToMap(移动怪物数据[5], 移动怪物数据[6], 移动怪物, 移动怪物说话[2], %颜色_红色%, 0)
		if Char.GetData(目标, CONST.CHAR_类型) ~= CONST.对象类型_人 then
			return
		end
		local encount编号 = '3|||0|||||0|'..tostring(移动怪物encount)..'|||||||||'
		Battle.Encount(移动怪物,目标,encount编号);
		--Battle.PVE(目标, 目标, nil, 战斗对象, 战斗对象等级)
		battleIndex = Char.GetBattleIndex(目标)
		战斗数据[battleIndex] = {}
		战斗数据[battleIndex] = battleIndex
		Char.SetLoopEvent(nil, '移动怪物回调', 移动怪物, 0)
		return
	end
	local 随机数 = NLG.Rand(1, 70)
	if 随机数 < 2 then
		local 追踪垃圾话 = NLG.Rand(5, 7)
		NLG.TalkToMap(移动怪物数据[5], 移动怪物数据[6], 移动怪物, 移动怪物说话[追踪垃圾话], %颜色_红色%, 0)
	end
	local 新方向 = {2, -2}--新加
	local 新方向键 = NLG.Rand(1, 2)
	if math.fmod(追踪方向, 2) == 1 then
		local 可行方向3, 可行方向4 = 方向坐标(X, Y, 追踪方向+1)
		local 可行方向5, 可行方向6 = 方向坐标(X, Y, 追踪方向-1)
		if NLG.Walkable(MAP1, FLOOR1, 可行方向3, 可行方向4) == 0 or NLG.Walkable(MAP1, FLOOR1, 可行方向5, 可行方向6) == 0 then
			追踪方向 = math.fmod(追踪方向+新方向[新方向键], 8)
		end
	end
	local 可行方向1, 可行方向2 = 方向坐标(X, Y, 追踪方向)
	if NLG.Walkable(MAP1, FLOOR1, 可行方向1, 可行方向2) == 0 then
		追踪方向 = math.fmod(追踪方向+新方向[新方向键], 8)
	end--新加
	NLG.WalkMove(移动怪物, 追踪方向)
	NLG.UpChar(移动怪物)
	end)
	self:regCallback('战后停顿回调', function(战后停顿)
	if 停顿 == 1 then
		local MAP1 = Char.GetData(目标, %对象_地图类型%)
		local FLOOR1 = Char.GetData(目标, %对象_地图%)
		if MAP1 ~= 移动怪物数据[5] or FLOOR1 ~= 移动怪物数据[6] then
			目标 = -1
		end
		Char.SetLoopEvent(nil, '警戒范围回调', 警戒范围, 警戒间隔时间*1000)
		Char.SetLoopEvent(nil, '战后停顿回调', 战后停顿, 0)
	elseif 停顿 == 2 then
		停顿 = 1
	elseif 停顿 == 3 then
		停顿 = 1
	end
	end)
	self:regCallback('BattleOverEvent', function(battleIndex)
	if 战斗数据[battleIndex] == nil then
		return
	end
	local 移动怪物死亡 = true
	for i = 10, 19 do
		local charIndex = Battle.GetPlayer(battleIndex, i)
		if charIndex >= 0 and Char.GetData(charIndex, %对象_血%) > 0 then
			移动怪物死亡 = false
		end
	end
	if 移动怪物死亡 then
		目标 = -1
		停顿 = 2
		NLG.TalkToMap(移动怪物数据[5], 移动怪物数据[6], 移动怪物, 移动怪物说话[3], %颜色_红色%, 0)
		Char.SetData(移动怪物, %对象_地图类型%, 辅助NPC数据[5])
		Char.SetData(移动怪物, %对象_地图%, 辅助NPC数据[6])
		Char.SetData(移动怪物, %对象_X%, 辅助NPC数据[3])
		Char.SetData(移动怪物, %对象_Y%, 辅助NPC数据[4])
		NLG.UpChar(移动怪物)
		Char.SetLoopEvent(nil, '战后停顿回调', 战后停顿, 刷新时间*1000)
	else
		停顿 = 3
		NLG.TalkToMap(移动怪物数据[5], 移动怪物数据[6], 移动怪物, 移动怪物说话[4], %颜色_红色%, 0)
		Char.SetLoopEvent(nil, '战后停顿回调', 战后停顿, 战后停顿时间*1000)
	end
	for i = 0, 9 do
		local 玩家 = Battle.GetPlayer(battleIndex, i)
		if 玩家 >= 0 and Char.GetData(玩家, CONST.CHAR_类型) == CONST.对象类型_人 and not Char.IsDummy(玩家) then
			if (Char.EndEvent(玩家, 308) == 1)  then
				NLG.Say(玩家, -1, "索拉斯：傳說中的英雄，恭迎您的歸來！", CONST.颜色_红色, CONST.字体_大);
			else
				Char.Warp(玩家, 0, 60017, 44, 55);
				NLG.Say(玩家, -1, "索拉斯：龍族墳場的力量將會使你困在這裡，永遠無法逃脫！", CONST.颜色_红色, CONST.字体_大);
			end

		end
	end
	战斗数据[battleIndex] = nil
	end)
	self:regCallback("BattleSurpriseEvent", function(battleIndex, result)
	local battleInfo = 战斗数据[battleIndex];
	if battleInfo == nil then
		return result;
	end
	return 0
	end)
end

function 移动方向(X, Y, X1, Y1)
	if not X or not Y or not X1 or not Y1 then
		return
	end
	local 方向 = 8
	if X1 > X then
		if Y1 > Y then
			方向 = 3
		elseif Y1 < Y then
			方向 = 1
		else
			方向 = 2
		end
	elseif X1 < X then
		if Y1 > Y then
			方向 = 5
		elseif Y1 < Y then
			方向 = 7
		else
			方向 = 6
		end
	else
		if Y1 > Y then
			方向 = 4
		elseif Y1 < Y then
			方向 = 0
		end
	end
	local 结果 = false
	if math.abs(X-X1) < 1 and math.abs(Y-Y1) < 1 then
		结果 = true
	end
	return 方向, 结果
end

function 方向坐标(X, Y, 方向)
	if 方向==1 or 方向==2 or 方向==3 then
		X = X + 1
	elseif 方向==5 or 方向==6 or 方向==7 then
		X = X - 1
	end
	if 方向==3 or 方向==4 or 方向==5 then
		Y = Y + 1
	elseif 方向==7 or 方向==0 or 方向==1 then
		Y = Y - 1
	end
	return X, Y
end

function Module:onUnload()
	self:logInfo('unload')
end

return Module;