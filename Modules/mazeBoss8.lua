local Module = ModuleBase:createModule('mazeBoss8')

local �ƶ�����encount = 406214--�ƶ������encount���
local ������ʱ�� = 1--��λ�룬���
local �ƶ��������� = 230--��λ����, �����޸ģ�Ŀǰ������Կ�
local ս��ͣ��ʱ�� = 30--��λ��, �����һ�غ϶���
local ˢ��ʱ�� = 1800--��λ��
local ɨ�跶Χ = 20--��СΪ(ɨ�跶Χ*2)*(ɨ�跶Χ*2)����
local ս������ = {}
local ͣ�� = 1
local Ŀ�� = -1
local count = 0
local ս������ = {1, 2, 3}--���±���һ��
local ս������ȼ� = {3, 4, 5}--���ϱ���һ��
local Ѳ��·�� = {7, 5, 3, 1}--�����﷽���ƶ���ȷ�����ᱻ��ס����ص�ԭ��
--����, ���, X, Y, ��ͼ����, ��ͼ, ����
local �ƶ��������� = {'����˹', 108171, 46, 39, 0, 60016, 6}
local ����NPC���� = {'����NPC', 105502, 18, 0, 0, 666, 6}
local �ƶ�����˵�� = {'���˰������؝�������횧�磬�@�e�Č��؁K�Ǟ������á�', '�����@Ƭ���������o�ߣ��Ҿ����㣬ֹͣ�����D����t���ܵ��o�M�Ŀ�ʹ��', 
'����Č��ز��Ǟ������˽�j�����ڵģ������댤�������Č��أ���Ҫ����ȥ���҃��ڵĹ�����', '�����Č����N�������ϵ��ǻۺ����}��������������������Ⱦ���㑪ԓ�Ծ�η֮�Č�����', 
 '�x�_�@�e����t�㌢���R������đ�ŭ����������o�����ܵġ�' }

function Module:onLoad()
	self:logInfo('load');
	local �ƶ����� = self:NPC_createNormal(�ƶ���������[1], �ƶ���������[2], { x = �ƶ���������[3], y = �ƶ���������[4], mapType = �ƶ���������[5], map = �ƶ���������[6], direction = �ƶ���������[7] });
	local ���䷶Χ = self:NPC_createNormal(����NPC����[1], ����NPC����[2], { x = ����NPC����[3], y = ����NPC����[4], mapType = ����NPC����[5], map = ����NPC����[6], direction = ����NPC����[7] });
	local ս��ͣ�� = self:NPC_createNormal(����NPC����[1], ����NPC����[2], { x = ����NPC����[3], y = ����NPC����[4], mapType = ����NPC����[5], map = ����NPC����[6], direction = ����NPC����[7] });
	self:regCallback('LoopEvent', Func.bind(self.�ƶ�����ص�, self))
	self:regCallback('LoopEvent', Func.bind(self.���䷶Χ�ص�, self))
	self:regCallback('LoopEvent', Func.bind(self.ս��ͣ�ٻص�, self))
	Char.SetLoopEvent(nil, '���䷶Χ�ص�', ���䷶Χ, ������ʱ��*1000)
	self:regCallback('���䷶Χ�ص�', function(���䷶Χ)
	if Ŀ�� == -1 then
		Char.SetData(�ƶ�����, %����_��ͼ����%, �ƶ���������[5])
		Char.SetData(�ƶ�����, %����_��ͼ%, �ƶ���������[6])
		Char.SetData(�ƶ�����, %����_X%, �ƶ���������[3])
		Char.SetData(�ƶ�����, %����_Y%, �ƶ���������[4])
		Ŀ�� = -2
		count = 0
		NLG.UpChar(�ƶ�����)
		return
	end
	local nowcount = math.fmod(count, #Ѳ��·��) + 1
	NLG.WalkMove(�ƶ�����, Ѳ��·��[nowcount])
	NLG.UpChar(�ƶ�����)
	count = count + 1
	local X = tonumber(Char.GetData(�ƶ�����, %����_X%))
	local Y = tonumber(Char.GetData(�ƶ�����, %����_Y%))
	for i=(X-ɨ�跶Χ), (X+ɨ�跶Χ) do
		for j=(Y-ɨ�跶Χ),(Y+ɨ�跶Χ) do
			local ������Ʒ����, ������Ʒ = Obj.GetObject(�ƶ���������[5], �ƶ���������[6], i, j)
			if #������Ʒ > 0 then
				for k = 1, #������Ʒ do
					local ��� = Obj.GetCharIndex(������Ʒ[k])
					if Char.GetData(���, CONST.CHAR_����) == CONST.��������_�� and not Char.IsDummy(���) then
						Ŀ�� = tonumber(���)
						NLG.TalkToMap(�ƶ���������[5], �ƶ���������[6], �ƶ�����, �ƶ�����˵��[1], %��ɫ_��ɫ%, 0)
						Char.SetLoopEvent(nil, '�ƶ�����ص�', �ƶ�����, �ƶ���������)
						Char.SetLoopEvent(nil, '���䷶Χ�ص�', ���䷶Χ, 0)
						break
					end
				end
			end
		end
	end
	end)
	self:regCallback('�ƶ�����ص�', function(�ƶ�����)
	if Char.GetData(Ŀ��, CONST.CHAR_����) ~= CONST.��������_�� then
		Ŀ�� = -1
		Char.SetLoopEvent(nil, '���䷶Χ�ص�', ���䷶Χ, ������ʱ��*1000)
		Char.SetLoopEvent(nil, '�ƶ�����ص�', �ƶ�����, 0)
		return
	end
	local MAP1 = Char.GetData(Ŀ��, %����_��ͼ����%)
	local FLOOR1 = Char.GetData(Ŀ��, %����_��ͼ%)
	local X1 = tonumber(Char.GetData(Ŀ��, %����_X%))
	local Y1 = tonumber(Char.GetData(Ŀ��, %����_Y%))
	local X = tonumber(Char.GetData(�ƶ�����, %����_X%))
	local Y = tonumber(Char.GetData(�ƶ�����, %����_Y%))
	if MAP1 ~= �ƶ���������[5] or FLOOR1 ~= �ƶ���������[6] then
		Ŀ�� = -1
		Char.SetLoopEvent(nil, '���䷶Χ�ص�', ���䷶Χ, ������ʱ��*1000)
		Char.SetLoopEvent(nil, '�ƶ�����ص�', �ƶ�����, 0)
		return
	end
	local ׷�ٷ���, ׷�ٽ�� = �ƶ�����(X, Y, X1, Y1)
	if ׷�ٽ�� then
		local battleIndex = Char.GetBattleIndex(Ŀ��)
		if battleIndex >= 0 then
			return
		end
		NLG.TalkToMap(�ƶ���������[5], �ƶ���������[6], �ƶ�����, �ƶ�����˵��[2], %��ɫ_��ɫ%, 0)
		if Char.GetData(Ŀ��, CONST.CHAR_����) ~= CONST.��������_�� then
			return
		end
		local encount��� = '3|||0|||||0|'..tostring(�ƶ�����encount)..'|||||||||'
		Battle.Encount(�ƶ�����,Ŀ��,encount���);
		--Battle.PVE(Ŀ��, Ŀ��, nil, ս������, ս������ȼ�)
		battleIndex = Char.GetBattleIndex(Ŀ��)
		ս������[battleIndex] = {}
		ս������[battleIndex] = battleIndex
		Char.SetLoopEvent(nil, '�ƶ�����ص�', �ƶ�����, 0)
		return
	end
	local ����� = NLG.Rand(1, 70)
	if ����� < 2 then
		local ׷�������� = NLG.Rand(5, 7)
		NLG.TalkToMap(�ƶ���������[5], �ƶ���������[6], �ƶ�����, �ƶ�����˵��[׷��������], %��ɫ_��ɫ%, 0)
	end
	local �·��� = {2, -2}--�¼�
	local �·���� = NLG.Rand(1, 2)
	if math.fmod(׷�ٷ���, 2) == 1 then
		local ���з���3, ���з���4 = ��������(X, Y, ׷�ٷ���+1)
		local ���з���5, ���з���6 = ��������(X, Y, ׷�ٷ���-1)
		if NLG.Walkable(MAP1, FLOOR1, ���з���3, ���з���4) == 0 or NLG.Walkable(MAP1, FLOOR1, ���з���5, ���з���6) == 0 then
			׷�ٷ��� = math.fmod(׷�ٷ���+�·���[�·����], 8)
		end
	end
	local ���з���1, ���з���2 = ��������(X, Y, ׷�ٷ���)
	if NLG.Walkable(MAP1, FLOOR1, ���з���1, ���з���2) == 0 then
		׷�ٷ��� = math.fmod(׷�ٷ���+�·���[�·����], 8)
	end--�¼�
	NLG.WalkMove(�ƶ�����, ׷�ٷ���)
	NLG.UpChar(�ƶ�����)
	end)
	self:regCallback('ս��ͣ�ٻص�', function(ս��ͣ��)
	if ͣ�� == 1 then
		local MAP1 = Char.GetData(Ŀ��, %����_��ͼ����%)
		local FLOOR1 = Char.GetData(Ŀ��, %����_��ͼ%)
		if MAP1 ~= �ƶ���������[5] or FLOOR1 ~= �ƶ���������[6] then
			Ŀ�� = -1
		end
		Char.SetLoopEvent(nil, '���䷶Χ�ص�', ���䷶Χ, ������ʱ��*1000)
		Char.SetLoopEvent(nil, 'ս��ͣ�ٻص�', ս��ͣ��, 0)
	elseif ͣ�� == 2 then
		ͣ�� = 1
	elseif ͣ�� == 3 then
		ͣ�� = 1
	end
	end)
	self:regCallback('BattleOverEvent', function(battleIndex)
	if ս������[battleIndex] == nil then
		return
	end
	local �ƶ��������� = true
	for i = 10, 19 do
		local charIndex = Battle.GetPlayer(battleIndex, i)
		if charIndex >= 0 and Char.GetData(charIndex, %����_Ѫ%) > 0 then
			�ƶ��������� = false
		end
	end
	if �ƶ��������� then
		Ŀ�� = -1
		ͣ�� = 2
		NLG.TalkToMap(�ƶ���������[5], �ƶ���������[6], �ƶ�����, �ƶ�����˵��[3], %��ɫ_��ɫ%, 0)
		Char.SetData(�ƶ�����, %����_��ͼ����%, ����NPC����[5])
		Char.SetData(�ƶ�����, %����_��ͼ%, ����NPC����[6])
		Char.SetData(�ƶ�����, %����_X%, ����NPC����[3])
		Char.SetData(�ƶ�����, %����_Y%, ����NPC����[4])
		NLG.UpChar(�ƶ�����)
		Char.SetLoopEvent(nil, 'ս��ͣ�ٻص�', ս��ͣ��, ˢ��ʱ��*1000)
	else
		ͣ�� = 3
		NLG.TalkToMap(�ƶ���������[5], �ƶ���������[6], �ƶ�����, �ƶ�����˵��[4], %��ɫ_��ɫ%, 0)
		Char.SetLoopEvent(nil, 'ս��ͣ�ٻص�', ս��ͣ��, ս��ͣ��ʱ��*1000)
	end
	for i = 0, 9 do
		local ��� = Battle.GetPlayer(battleIndex, i)
		if ��� >= 0 and Char.GetData(���, CONST.CHAR_����) == CONST.��������_�� and not Char.IsDummy(���) then
			if (Char.EndEvent(���, 308) == 1)  then
				NLG.Say(���, -1, "����˹�����f�е�Ӣ�ۣ���ӭ���Ěw��", CONST.��ɫ_��ɫ, CONST.����_��);
			else
				Char.Warp(���, 0, 60017, 44, 55);
				NLG.Say(���, -1, "����˹�����剞������������ʹ�������@�e�����h�o����Ó��", CONST.��ɫ_��ɫ, CONST.����_��);
			end

		end
	end
	ս������[battleIndex] = nil
	end)
	self:regCallback("BattleSurpriseEvent", function(battleIndex, result)
	local battleInfo = ս������[battleIndex];
	if battleInfo == nil then
		return result;
	end
	return 0
	end)
end

function �ƶ�����(X, Y, X1, Y1)
	if not X or not Y or not X1 or not Y1 then
		return
	end
	local ���� = 8
	if X1 > X then
		if Y1 > Y then
			���� = 3
		elseif Y1 < Y then
			���� = 1
		else
			���� = 2
		end
	elseif X1 < X then
		if Y1 > Y then
			���� = 5
		elseif Y1 < Y then
			���� = 7
		else
			���� = 6
		end
	else
		if Y1 > Y then
			���� = 4
		elseif Y1 < Y then
			���� = 0
		end
	end
	local ��� = false
	if math.abs(X-X1) < 1 and math.abs(Y-Y1) < 1 then
		��� = true
	end
	return ����, ���
end

function ��������(X, Y, ����)
	if ����==1 or ����==2 or ����==3 then
		X = X + 1
	elseif ����==5 or ����==6 or ����==7 then
		X = X - 1
	end
	if ����==3 or ����==4 or ����==5 then
		Y = Y + 1
	elseif ����==7 or ����==0 or ����==1 then
		Y = Y - 1
	end
	return X, Y
end

function Module:onUnload()
	self:logInfo('unload')
end

return Module;