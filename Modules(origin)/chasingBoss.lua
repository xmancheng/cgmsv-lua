local Module = ModuleBase:createModule('chasingBoss')

local EnemySet = {}
local BaseLevelSet = {}
local Pos = {}
--���н���
--     ��(4)	��(2)	һ(0)	��(1)	��(3)
--     ʮ(9)	��(7)	��(5)	��(6)	��(8)
------------��սNPC����------------
EnemySet[1] = {0, 0, 0, 0, 0, 0, 406194, 406193, 0, 0}    --0����û�й�
BaseLevelSet[1] = {0, 0, 0, 0, 0, 0, 140, 140, 0, 0}
Pos[1] = {"ِ�����S��",EnemySet[1],BaseLevelSet[1]}
------------------------------------------------
--local �ƶ�����encount = 406214--�ƶ������encount���
local warningInterval = 1--������ʱ�䵥λ�룬���
local monsterSpeed = 230--�ƶ��������ٵ�λ����, �����޸ģ�Ŀǰ������Կ�
local pauseTime = 60--ս��ͣ��ʱ�䵥λ��, �����һ�غ϶���
local refresh = 1800--ˢ��ʱ�䵥λ��
local scope = 30--ɨ�跶Χ��СΪ(ɨ�跶Χ*2)*(ɨ�跶Χ*2)����
local battle_Tbl = {}--ս������
local pause = 1--ͣ��
local player = -1--Ŀ��
local count = 0
--local ս������ = {1, 2, 3}--���±���һ��
--local ս������ȼ� = {3, 4, 5}--���ϱ���һ��
local path = {7, 5, 3, 1}--Ѳ��·�������﷽���ƶ���ȷ�����ᱻ��ס����ص�ԭ��
--����, ���, X, Y, ��ͼ����, ��ͼ, ����
local enemyData = {'ِ�����S��', 130098, 45, 19, 0, 7903, 6}--�ƶ���������
local aidNPCData = {'׷���o��NPC', 105502, 18, 0, 0, 666, 6}--����NPC����
local talkData = {'���F�ڡ������������Ġ�B��', '�r�gֻ�ǂ���ߣ���������[Ū��', '�����������a����ԓ�ɏ��߁��x��ֹͣ�����׃�w�����������ĽY�֡�',
 '��־�ƿأ��^ȥ���F���cδ�푪ԓ�����ɸČ���' }--�ƶ�����˵��

function Module:onLoad()
	self:logInfo('load');
	local chasingEnemy = self:NPC_createNormal(enemyData[1], enemyData[2], { x = enemyData[3], y = enemyData[4], mapType = enemyData[5], map = enemyData[6], direction = enemyData[7] });--�ƶ�����
	local warningNPC = self:NPC_createNormal(aidNPCData[1], aidNPCData[2], { x = aidNPCData[3], y = aidNPCData[4], mapType = aidNPCData[5], map = aidNPCData[6], direction = aidNPCData[7] });--���䷶Χ
	local pauseNPC = self:NPC_createNormal(aidNPCData[1], aidNPCData[2], { x = aidNPCData[3], y = aidNPCData[4], mapType = aidNPCData[5], map = aidNPCData[6], direction = aidNPCData[7] });--ս��ͣ��
	self:regCallback('LoopEvent', Func.bind(self.OnChasingEnemy, self))
	self:regCallback('LoopEvent', Func.bind(self.OnWarningNPC, self))
	self:regCallback('LoopEvent', Func.bind(self.OnPauseNPC, self))
	Char.SetLoopEvent(nil, 'OnWarningNPC', warningNPC, warningInterval*1000)
	self:regCallback('OnWarningNPC', function(warningNPC)
	if player == -1 then
		Char.SetData(chasingEnemy, CONST.����_��ͼ����, enemyData[5])
		Char.SetData(chasingEnemy, CONST.����_��ͼ, enemyData[6])
		Char.SetData(chasingEnemy, CONST.����_X, enemyData[3])
		Char.SetData(chasingEnemy, CONST.����_Y, enemyData[4])
		player = -2
		count = 0
		NLG.UpChar(chasingEnemy)
		return
	end
	local nowcount = math.fmod(count, #path) + 1
	NLG.WalkMove(chasingEnemy, path[nowcount])
	NLG.UpChar(chasingEnemy)
	count = count + 1
	local X = tonumber(Char.GetData(chasingEnemy, CONST.����_X))
	local Y = tonumber(Char.GetData(chasingEnemy, CONST.����_Y))
	for i=(X-scope), (X+scope) do
		for j=(Y-scope),(Y+scope) do
			local ������Ʒ����, ������Ʒ = Obj.GetObject(enemyData[5], enemyData[6], i, j)
			if #������Ʒ > 0 then
				for k = 1, #������Ʒ do
					local leader = Obj.GetCharIndex(������Ʒ[k])
					if Char.GetData(leader, CONST.����_����) == CONST.��������_�� and not Char.IsDummy(leader) then
						player = tonumber(leader)
						NLG.TalkToMap(enemyData[5], enemyData[6], chasingEnemy, talkData[1], CONST.��ɫ_��ɫ, 0)
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
	if Char.GetData(player, CONST.����_����) ~= CONST.��������_�� then
		player = -1
		Char.SetLoopEvent(nil, 'OnWarningNPC', warningNPC, warningInterval*1000)
		Char.SetLoopEvent(nil, 'OnChasingEnemy', chasingEnemy, 0)
		return
	end
	local MAP1 = Char.GetData(player, CONST.����_��ͼ����)
	local FLOOR1 = Char.GetData(player, CONST.����_��ͼ)
	local X1 = tonumber(Char.GetData(player, CONST.����_X))
	local Y1 = tonumber(Char.GetData(player, CONST.����_Y))
	local X = tonumber(Char.GetData(chasingEnemy, CONST.����_X))
	local Y = tonumber(Char.GetData(chasingEnemy, CONST.����_Y))
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
		NLG.TalkToMap(enemyData[5], enemyData[6], chasingEnemy, talkData[2], CONST.��ɫ_��ɫ, 0)
		if Char.GetData(player, CONST.����_����) ~= CONST.��������_�� then
			return
		end
		--local encount��� = '3|||0|||||0|'..tostring(�ƶ�����encount)..'|||||||||'
		--Battle.Encount(�ƶ�����,player,encount���);
		battleindex = Battle.PVE( player, player, nil, Pos[1][2], Pos[1][3], nil)
		--Battle.PVE(player, player, nil, ս������, ս������ȼ�)
		--battleIndex = Char.GetBattleIndex(player)
		battle_Tbl[battleIndex] = {}
		battle_Tbl[battleIndex] = battleIndex
		Char.SetLoopEvent(nil, 'OnChasingEnemy', chasingEnemy, 0)
		return
	end
	local randNo = NLG.Rand(1, 70)
	if randNo < 2 then
		local pursueTalk = NLG.Rand(1, 4)
		NLG.TalkToMap(enemyData[5], enemyData[6], chasingEnemy, talkData[pursueTalk], CONST.��ɫ_��ɫ, 0)
	end
	local newDir = {2, -2}--�¼��·���
	local newDirValue = NLG.Rand(1, 2)--�·����
	if math.fmod(TrackingD, 2) == 1 then
		local walkable3, walkable4 = GetDirCoo(X, Y, TrackingD+1)
		local walkable5, walkable6 = GetDirCoo(X, Y, TrackingD-1)
		if NLG.Walkable(MAP1, FLOOR1, walkable3, walkable4) == 0 or NLG.Walkable(MAP1, FLOOR1, walkable5, walkable6) == 0 then
			TrackingD = math.fmod(TrackingD+newDir[newDirValue], 8)
		end
	end
	local walkable1, walkable2 = GetDirCoo(X, Y, TrackingD)--��������
	if NLG.Walkable(MAP1, FLOOR1, walkable1, walkable2) == 0 then
		TrackingD = math.fmod(TrackingD+newDir[newDirValue], 8)
	end--�¼�
	NLG.WalkMove(chasingEnemy, TrackingD)
	NLG.UpChar(chasingEnemy)
	end)
	self:regCallback('OnPauseNPC', function(pauseNPC)
	if pause == 1 then
		local MAP1 = Char.GetData(player, CONST.����_��ͼ����)
		local FLOOR1 = Char.GetData(player, CONST.����_��ͼ)
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
	local enemyDeath = true--�ƶ���������
	for i = 10, 19 do
		local charIndex = Battle.GetPlayer(battleIndex, i)
		if charIndex >= 0 and Char.GetData(charIndex, CONST.����_Ѫ) > 0 then
			enemyDeath = false
		end
	end
	if enemyDeath then
		player = -1
		pause = 2
		NLG.TalkToMap(enemyData[5], enemyData[6], chasingEnemy, talkData[3], CONST.��ɫ_��ɫ, 0)
		Char.SetData(chasingEnemy, CONST.����_��ͼ����, aidNPCData[5])
		Char.SetData(chasingEnemy, CONST.����_��ͼ, aidNPCData[6])
		Char.SetData(chasingEnemy, CONST.����_X, aidNPCData[3])
		Char.SetData(chasingEnemy, CONST.����_Y, aidNPCData[4])
		NLG.UpChar(chasingEnemy)
		Char.SetLoopEvent(nil, 'OnPauseNPC', pauseNPC, refresh*1000)
	else
		pause = 3
		NLG.TalkToMap(enemyData[5], enemyData[6], chasingEnemy, talkData[4], CONST.��ɫ_��ɫ, 0)
		Char.SetLoopEvent(nil, 'OnPauseNPC', pauseNPC, pauseTime*1000)
	end
	for i = 0, 9 do
		local leader = Battle.GetPlayer(battleIndex, i)
		if leader >= 0 and Char.GetData(leader, CONST.����_����) == CONST.��������_�� and not Char.IsDummy(leader) then
			NLG.Say(leader, -1, "ِ�����S�ģ�Ҋ�ϴ�֮ǰ׌�҂������㣡", CONST.��ɫ_��ɫ, CONST.����_��);
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