local Module = ModuleBase:createModule('chasingBoss')

local EnemySet = {}
local BaseLevelSet = {}
local Pos = {}
--队列解释
--     五(4)	三(2)	一(0)	二(1)	四(3)
--     十(9)	八(7)	六(5)	七(6)	九(8)
------------对战NPC设置------------
EnemySet[1] = {0, 0, 0, 0, 0, 0, 406194, 406193, 0, 0}    --0代表没有怪
BaseLevelSet[1] = {0, 0, 0, 0, 0, 0, 140, 140, 0, 0}
Pos[1] = {"賽克特隨從",EnemySet[1],BaseLevelSet[1]}
------------------------------------------------
--local 移动怪物encount = 406214--移动怪物的encount编号
local warningInterval = 1--警戒间隔时间单位秒，勿改
local monsterSpeed = 230--移动怪物移速单位毫秒, 慎重修改，目前比玩家略快
local pauseTime = 60--战后停顿时间单位秒, 含最后一回合动画
local refresh = 1800--刷新时间单位秒
local scope = 30--扫描范围大小为(扫描范围*2)*(扫描范围*2)格子
local battle_Tbl = {}--战斗数据
local pause = 1--停顿
local player = -1--目标
local count = 0
--local 战斗对象 = {1, 2, 3}--和下表长度一致
--local 战斗对象等级 = {3, 4, 5}--和上表长度一致
local path = {7, 5, 3, 1}--巡逻路线往人物方向移动，确保不会被挡住，会回到原点
--名字, 外观, X, Y, 地图类型, 地图, 方向
local enemyData = {'賽克特隨從', 130098, 45, 19, 0, 7903, 6}--移动怪物数据
local aidNPCData = {'追擊輔助NPC', 105502, 18, 0, 0, 666, 6}--辅助NPC数据
local talkData = {'「現在」才是最完美的狀態。', '時間只是個玩具，可以任意擺弄。', '「真正的永恆」應該由強者來選擇，停止世界的變遷才是最完美的結局。',
 '意志掌控，過去、現在與未來應該被自由改寫。' }--移动怪物说话

function Module:onLoad()
	self:logInfo('load');
	local chasingEnemy = self:NPC_createNormal(enemyData[1], enemyData[2], { x = enemyData[3], y = enemyData[4], mapType = enemyData[5], map = enemyData[6], direction = enemyData[7] });--移动怪物
	local warningNPC = self:NPC_createNormal(aidNPCData[1], aidNPCData[2], { x = aidNPCData[3], y = aidNPCData[4], mapType = aidNPCData[5], map = aidNPCData[6], direction = aidNPCData[7] });--警戒范围
	local pauseNPC = self:NPC_createNormal(aidNPCData[1], aidNPCData[2], { x = aidNPCData[3], y = aidNPCData[4], mapType = aidNPCData[5], map = aidNPCData[6], direction = aidNPCData[7] });--战后停顿
	self:regCallback('LoopEvent', Func.bind(self.OnChasingEnemy, self))
	self:regCallback('LoopEvent', Func.bind(self.OnWarningNPC, self))
	self:regCallback('LoopEvent', Func.bind(self.OnPauseNPC, self))
	Char.SetLoopEvent(nil, 'OnWarningNPC', warningNPC, warningInterval*1000)
	self:regCallback('OnWarningNPC', function(warningNPC)
	if player == -1 then
		Char.SetData(chasingEnemy, CONST.对象_地图类型, enemyData[5])
		Char.SetData(chasingEnemy, CONST.对象_地图, enemyData[6])
		Char.SetData(chasingEnemy, CONST.对象_X, enemyData[3])
		Char.SetData(chasingEnemy, CONST.对象_Y, enemyData[4])
		player = -2
		count = 0
		NLG.UpChar(chasingEnemy)
		return
	end
	local nowcount = math.fmod(count, #path) + 1
	NLG.WalkMove(chasingEnemy, path[nowcount])
	NLG.UpChar(chasingEnemy)
	count = count + 1
	local X = tonumber(Char.GetData(chasingEnemy, CONST.对象_X))
	local Y = tonumber(Char.GetData(chasingEnemy, CONST.对象_Y))
	for i=(X-scope), (X+scope) do
		for j=(Y-scope),(Y+scope) do
			local 地面物品数量, 地面物品 = Obj.GetObject(enemyData[5], enemyData[6], i, j)
			if #地面物品 > 0 then
				for k = 1, #地面物品 do
					local leader = Obj.GetCharIndex(地面物品[k])
					if Char.GetData(leader, CONST.对象_类型) == CONST.对象类型_人 and not Char.IsDummy(leader) then
						player = tonumber(leader)
						NLG.TalkToMap(enemyData[5], enemyData[6], chasingEnemy, talkData[1], CONST.颜色_黄色, 0)
						Char.SetLoopEvent(nil, 'OnChasingEnemy', chasingEnemy, monsterSpeed)
						Char.SetLoopEvent(nil, 'OnWarningNPC', warningNPC, 0)
						break
					end
				end
			end
		end
	end
	end)
	self:regCallback('OnChasingEnemy', function(chasingEnemy)
	if Char.GetData(player, CONST.对象_类型) ~= CONST.对象类型_人 then
		player = -1
		Char.SetLoopEvent(nil, 'OnWarningNPC', warningNPC, warningInterval*1000)
		Char.SetLoopEvent(nil, 'OnChasingEnemy', chasingEnemy, 0)
		return
	end
	local MAP1 = Char.GetData(player, CONST.对象_地图类型)
	local FLOOR1 = Char.GetData(player, CONST.对象_地图)
	local X1 = tonumber(Char.GetData(player, CONST.对象_X))
	local Y1 = tonumber(Char.GetData(player, CONST.对象_Y))
	local X = tonumber(Char.GetData(chasingEnemy, CONST.对象_X))
	local Y = tonumber(Char.GetData(chasingEnemy, CONST.对象_Y))
	if MAP1 ~= enemyData[5] or FLOOR1 ~= enemyData[6] then
		player = -1
		Char.SetLoopEvent(nil, 'OnWarningNPC', warningNPC, warningInterval*1000)
		Char.SetLoopEvent(nil, 'OnChasingEnemy', chasingEnemy, 0)
		return
	end
	local TrackingD, TrackingC = DMove(X, Y, X1, Y1)
	if TrackingC then
		local battleIndex = Char.GetBattleIndex(player)
		if battleIndex >= 0 then
			return
		end
		NLG.TalkToMap(enemyData[5], enemyData[6], chasingEnemy, talkData[2], CONST.颜色_黄色, 0)
		if Char.GetData(player, CONST.对象_类型) ~= CONST.对象类型_人 then
			return
		end
		--local encount编号 = '3|||0|||||0|'..tostring(移动怪物encount)..'|||||||||'
		--Battle.Encount(移动怪物,player,encount编号);
		battleindex = Battle.PVE( player, player, nil, Pos[1][2], Pos[1][3], nil)
		--Battle.PVE(player, player, nil, 战斗对象, 战斗对象等级)
		--battleIndex = Char.GetBattleIndex(player)
		battle_Tbl[battleIndex] = {}
		battle_Tbl[battleIndex] = battleIndex
		Char.SetLoopEvent(nil, 'OnChasingEnemy', chasingEnemy, 0)
		return
	end
	local randNo = NLG.Rand(1, 70)
	if randNo < 2 then
		local pursueTalk = NLG.Rand(1, 4)
		NLG.TalkToMap(enemyData[5], enemyData[6], chasingEnemy, talkData[pursueTalk], CONST.颜色_黄色, 0)
	end
	local newDir = {2, -2}--新加新方向
	local newDirValue = NLG.Rand(1, 2)--新方向键
	if math.fmod(TrackingD, 2) == 1 then
		local walkable3, walkable4 = GetDirCoo(X, Y, TrackingD+1)
		local walkable5, walkable6 = GetDirCoo(X, Y, TrackingD-1)
		if NLG.Walkable(MAP1, FLOOR1, walkable3, walkable4) == 0 or NLG.Walkable(MAP1, FLOOR1, walkable5, walkable6) == 0 then
			TrackingD = math.fmod(TrackingD+newDir[newDirValue], 8)
		end
	end
	local walkable1, walkable2 = GetDirCoo(X, Y, TrackingD)--方向坐标
	if NLG.Walkable(MAP1, FLOOR1, walkable1, walkable2) == 0 then
		TrackingD = math.fmod(TrackingD+newDir[newDirValue], 8)
	end--新加
	NLG.WalkMove(chasingEnemy, TrackingD)
	NLG.UpChar(chasingEnemy)
	end)
	self:regCallback('OnPauseNPC', function(pauseNPC)
	if pause == 1 then
		local MAP1 = Char.GetData(player, CONST.对象_地图类型)
		local FLOOR1 = Char.GetData(player, CONST.对象_地图)
		if MAP1 ~= enemyData[5] or FLOOR1 ~= enemyData[6] then
			player = -1
		end
		Char.SetLoopEvent(nil, 'OnWarningNPC', warningNPC, warningInterval*1000)
		Char.SetLoopEvent(nil, 'OnPauseNPC', pauseNPC, 0)
	elseif pause == 2 then
		pause = 1
	elseif pause == 3 then
		pause = 1
	end
	end)
	self:regCallback('BattleOverEvent', function(battleIndex)
	if battle_Tbl[battleIndex] == nil then
		return
	end
	local enemyDeath = true--移动怪物死亡
	for i = 10, 19 do
		local charIndex = Battle.GetPlayer(battleIndex, i)
		if charIndex >= 0 and Char.GetData(charIndex, CONST.对象_血) > 0 then
			enemyDeath = false
		end
	end
	if enemyDeath then
		player = -1
		pause = 2
		NLG.TalkToMap(enemyData[5], enemyData[6], chasingEnemy, talkData[3], CONST.颜色_黄色, 0)
		Char.SetData(chasingEnemy, CONST.对象_地图类型, aidNPCData[5])
		Char.SetData(chasingEnemy, CONST.对象_地图, aidNPCData[6])
		Char.SetData(chasingEnemy, CONST.对象_X, aidNPCData[3])
		Char.SetData(chasingEnemy, CONST.对象_Y, aidNPCData[4])
		NLG.UpChar(chasingEnemy)
		Char.SetLoopEvent(nil, 'OnPauseNPC', pauseNPC, refresh*1000)
	else
		pause = 3
		NLG.TalkToMap(enemyData[5], enemyData[6], chasingEnemy, talkData[4], CONST.颜色_黄色, 0)
		Char.SetLoopEvent(nil, 'OnPauseNPC', pauseNPC, pauseTime*1000)
	end
	for i = 0, 9 do
		local leader = Battle.GetPlayer(battleIndex, i)
		if leader >= 0 and Char.GetData(leader, CONST.对象_类型) == CONST.对象类型_人 and not Char.IsDummy(leader) then
			NLG.Say(leader, -1, "賽克特隨從：見老大之前讓我們會會你！", CONST.颜色_黄色, CONST.字体_大);
		end
	end
	battle_Tbl[battleIndex] = nil
	end)
	self:regCallback("BattleSurpriseEvent", function(battleIndex, result)
	local battleInfo = battle_Tbl[battleIndex];
	if battleInfo == nil then
		return result;
	end
	return 0
	end)
end

function DMove(X, Y, X1, Y1)
	if not X or not Y or not X1 or not Y1 then
		return
	end
	local direction = 8
	if X1 > X then
		if Y1 > Y then
			direction = 3
		elseif Y1 < Y then
			direction = 1
		else
			direction = 2
		end
	elseif X1 < X then
		if Y1 > Y then
			direction = 5
		elseif Y1 < Y then
			direction = 7
		else
			direction = 6
		end
	else
		if Y1 > Y then
			direction = 4
		elseif Y1 < Y then
			direction = 0
		end
	end
	local result = false
	if math.abs(X-X1) < 1 and math.abs(Y-Y1) < 1 then
		result = true
	end
	return direction, result
end

function GetDirCoo(X, Y, direction)
	if direction==1 or direction==2 or direction==3 then
		X = X + 1
	elseif direction==5 or direction==6 or direction==7 then
		X = X - 1
	end
	if direction==3 or direction==4 or direction==5 then
		Y = Y + 1
	elseif direction==7 or direction==0 or direction==1 then
		Y = Y - 1
	end
	return X, Y
end

function Module:onUnload()
	self:logInfo('unload')
end

return Module;