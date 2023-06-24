local Module = ModuleBase:createModule('encountEX')

local ��������ħˮ = false--���ĵ��߿���
local ��������ħˮ = false--���ĵ��߿���
local ymxs = 900498--��ħ��ˮ
local qmxs = 900497--��ħ��ˮ
local hmxs = 900500--������ˮ
FullMon_control = {}
for full = 0,5 do
	FullMon_control[full] = {}
	FullMon_control[full] = false  --��ʼ�����ֿ���
end

function Module:battleStartEventCallback(battleIndex)
	for i=10, 19 do
		local enemy = Battle.GetPlayIndex(battleIndex, i)
		local player = Battle.GetPlayIndex(battleIndex, 0)
		local playerpet = Battle.GetPlayer(battleIndex, 5)
		if Char.GetData(player, CONST.CHAR_����) == CONST.��������_�� then
			player = player
		else
			player = playerpet
		end
		local hmxsnum = Char.ItemNum(player,hmxs)
		if enemy>=0 and hmxsnum >= 1 and Char.GetData(enemy, CONST.CHAR_����) == CONST.��������_�� and Char.GetData(enemy,CONST.����_ս��״̬) ~= CONST.ս��_BOSSս then
			local enemyId = Char.GetData(enemy, CONST.CHAR_ENEMY_ID);
			local enemyLv = Char.GetData(enemy,CONST.CHAR_�ȼ�);
			--local enemyIndex = Data.EnemyGetDataIndex(enemyId)
			--local enemylow = Data.EnemyGetData(enemyIndex, CONST.Enemy_�������)
			--local enemyhigh = Data.EnemyGetData(enemyIndex, CONST.Enemy_�������)
			--print(enemyId,enemyIndex,enemylow,enemyhigh)
			EnemyIdAr = {enemyId, enemyId, enemyId, enemyId, enemyId, enemyId, enemyId, enemyId, enemyId, enemyId}
			BaseLevelAr = {enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv}
			FullMon_control[player] = true;
		end
	end
end

function Module:LoginGateEvent(player)
	Char.SetData(player,%����_�㲽��%,0);
	Char.SetData(player,%����_������%,0);
	Char.SetLoopEvent(nil,'ymloop',player,0);
	Char.SetData(player,%����_�����п���%,0);
	Char.SetLoopEvent(nil,'qmloop',player,0);
	NLG.UpChar(player);
	FullMon_control[player] = false;
	EnemyIdAr = {}
	BaseLevelAr = {}
	NLG.SystemMessage(player,"�Զ����С������С��M�ֹر��ˣ�");
  return 0;
end

function Module:LogoutEvent(player)
	Char.SetData(player,%����_�㲽��%,0);
	Char.SetData(player,%����_������%,0);
	Char.SetLoopEvent(nil,'ymloop',player,0);
	Char.SetData(player,%����_�����п���%,0);
	Char.SetLoopEvent(nil,'qmloop',player,0);
	NLG.UpChar(player);
	FullMon_control[player] = false;
	EnemyIdAr = {}
	BaseLevelAr = {}
	NLG.SystemMessage(player,"�Զ����С������С��M�ֹر��ˣ�");
  return 0;
end

function Module:onLoad()
	self:logInfo('load')
	self:regCallback('BattleStartEvent', Func.bind(self.battleStartEventCallback, self))
	self:regCallback('LoginGateEvent', Func.bind(self.LoginGateEvent, self))
	self:regCallback('LogoutEvent', Func.bind(self.LogoutEvent, self))
	self:regCallback('LoopEvent', Func.bind(self.ymloop,self))
	self:regCallback('ymloop',function(player)
	local playeryd = Char.GetData(player,%����_ս����%) == 0
	local ymxsnum = Char.ItemNum(player,ymxs)
	local ymbs = Char.GetData(player,%����_�㲽��%)
	local hmxsnum = Char.ItemNum(player,hmxs)
	if playeryd then
		if ��������ħˮ then
			Battle.Encount(player, player);
		else
			if ymbs > 979 then--�޸���ħˮ��������
				Char.SetData(player,%����_�㲽��%,ymbs-1);
				NLG.UpChar(player);
				if FullMon_control[player] == false then
					Battle.Encount(player, player);
				elseif FullMon_control[player] == true and hmxsnum > 1 then
					Char.DelItem(player,hmxs,1);
					Battle.PVE(player, player, nil, EnemyIdAr, BaseLevelAr,  nil)
				elseif FullMon_control[player] == true and hmxsnum == 1 then
 					FullMon_control[player] = false;
					Char.DelItem(player,hmxs,1);
					Battle.PVE(player, player, nil, EnemyIdAr, BaseLevelAr,  nil)
					EnemyIdAr = {}
					BaseLevelAr = {}
				else
					Battle.Encount(player, player);
				end
				NLG.SystemMessage(player,'�Զ�����ʣ��'..(ymbs-980)..'��')
			else
				if ymxsnum > 1 then
					Char.SetData(player,%����_�㲽��%,998);
					Char.DelItem(player,ymxs,1);
					Item.UpItem(player,-1);
					NLG.UpChar(player);
					NLG.SystemMessage(player,'����һ��������ɣ��Զ����м���������'..(ymxsnum-1)..'��������ɡ�');
					Battle.Encount(player, player);
				elseif ymxsnum == 1 then
					Char.SetData(player,%����_�㲽��%,998);
					Char.DelItem(player,ymxs,1);
					Item.UpItem(player,-1);
					NLG.UpChar(player);
					NLG.SystemMessage(player,'�Զ��������һ����Ч,�뼰ʱ���������ɣ�');
					Battle.Encount(player, player);
				else
					Char.SetData(player,%����_�㲽��%,0);
					Char.SetData(player,%����_������%,0);
					Char.SetLoopEvent(nil,'ymloop',player,0);
					NLG.SystemMessage(player,'����������Ĵ������Զ����йرգ�')
				end
			end
		end
	end
	end)
	self:regCallback('LoopEvent', Func.bind(self.qmloop,self))
	self:regCallback('qmloop', function(player)
	local qmxsnum = Char.ItemNum(player,qmxs)
	if qmxsnum > 1 then
		Char.DelItem(player,qmxs,1);
		Item.UpItem(player, -1);
		NLG.SystemMessage(player,'����һƿ�����ͣ������м���������'..(qmxsnum-1)..'ƿ�����͡�');
	elseif qmxsnum == 1 then
		Char.DelItem(player,qmxs,1);
		Item.UpItem(player,-1);
		NLG.SystemMessage(player,'���������һ����Ч,�뼰ʱ��������ͣ�');
	else
		Char.SetData(player,%����_�����п���%,0);
		Char.SetLoopEvent(nil,'qmloop',player,0);
		NLG.UpChar(player);
		NLG.SystemMessage(player,'���������Ĵ����������йرգ�')
	end
	end)
	self:regCallback('TalkEvent', function(player, msg)
	local ymxsnum = Char.ItemNum(player,ymxs)
	local qmxsnum = Char.ItemNum(player,qmxs)
	if (msg == "/1" or msg == "��1") then
		FullMon_control[player] = false;
		EnemyIdAr = {}
		BaseLevelAr = {}
		if Char.GetData(player,%����_�����п���%) == 1 then
			NLG.SystemMessage(player,"������ʹ�ô����ͣ��޷�ʹ���Զ�����");
		elseif Char.GetData(player,%����_�㲽��%) > 0 then
			Char.SetData(player,%����_�㲽��%,0);
			Char.SetData(player,%����_������%,0);
			Char.SetLoopEvent(nil,'ymloop',player,0);
			NLG.UpChar(player);
			NLG.SystemMessage(player,"�Զ����йر��ˣ�");
		elseif ��������ħˮ then
			Char.SetData(player,%����_�㲽��%,999);
			Char.SetData(player,%����_������%,999);
			Char.SetLoopEvent(nil,'ymloop',player,5000);
			NLG.UpChar(player);
			NLG.SystemMessage(player,"�Զ����п�ʼ�ˣ�ÿ5�볢��һ�Ρ�");
		elseif not ��������ħˮ and ymxsnum > 0 then
			Char.SetData(player,%����_�㲽��%,999);
			Char.SetData(player,%����_������%,999);
			Char.SetLoopEvent(nil,'ymloop',player,5000);
			Char.DelItem(player,ymxs,1);
			Item.UpItem(player,-1);
			NLG.UpChar(player);
			NLG.SystemMessage(player,"�Զ����п�ʼ�ˣ�ÿ5�볢��һ�Ρ�");
		elseif not ��������ħˮ and ymxsnum == 0 then
			NLG.SystemMessage(player,'ȱ�ٹ�����ɣ��Զ������޷�������');
		end
	elseif (msg == "/2" or msg == "��2") then
		if Char.GetData(player,%����_�㲽��%)>0 then
			NLG.SystemMessage(player,"������ʹ�ò������У��޷�ʹ�ô����ͣ�");
		elseif Char.GetData(player,%����_�����п���%)==1 then
			Char.SetData(player,%����_�����п���%,0);
			Char.SetLoopEvent(nil,'qmloop',player,0);
			NLG.UpChar(player);
			NLG.SystemMessage(player,"�����й��ܹرգ�");
		elseif ��������ħˮ then
			Char.SetData(player,%����_�����п���%,1);
			NLG.UpChar(player);
			NLG.SystemMessage(player,"�������Ѿ�������");
		elseif not ��������ħˮ and qmxsnum > 0 then
			Char.SetData(player,%����_�����п���%,1);
			Char.SetLoopEvent(nil,'qmloop',player,120000);--�޸���ħˮ����ʱ�䣬��λ����
			NLG.UpChar(player);
			NLG.SystemMessage(player,"�������Ѿ�������");
		elseif not ��������ħˮ and qmxsnum == 0 then
			NLG.SystemMessage(player,'ȱ�ٴ����ͣ��������޷�������');
		end
	end
	end)
end

function Module:onUnload()
  self:logInfo('unload');
end

return Module;
