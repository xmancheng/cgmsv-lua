local Module = ModuleBase:createModule('encountEX')

local unDelYMX = true; -- ��������ħ�㿪��
local unDelQMX = true; -- ��������ħ�㿪��
local unDelMGX = true; -- ����������ˮ����
local unDelHJPW = false; -- �����Ļƽ�������
local useCharLV = false; -- �ƽ������������ȼ�

local ymxs = 900498 --��ħ��id, 1ƿ100��, ʹ�����Ӳ���
local qmxs = 900497 --��ħ��id
local mgx = 20230019 --������ˮid, �����;ö�, ���ɵ���
local hjpw = 20230020 --�ƽ�����id(����ȼ�=��һ������ȼ�+5), �����;ö�, ���ɵ���


local EnemyTbl = {}

-- սǰ�ص�, �����������ֵĵ�������EnemyTbl[cdk], 
function Module:battleStartEventCallback(battleIndex)
	local player = Battle.GetPlayIndex(battleIndex, 0)
	local playerpet = Battle.GetPlayer(battleIndex, 5)
	if Char.GetData(player, CONST.����_����) == CONST.��������_�� then
		player = player
	else
		player = playerpet
	end

	local cdk = Char.GetData(player,CONST.����_CDK);
	local curBattleEnemyTbl = {}
	if EnemyTbl[cdk] == nil then
		EnemyTbl[cdk] = {}
		table.insert(EnemyTbl[cdk],cdk);
	end
	if EnemyTbl[cdk][3] ~= nil then
		-- ����Ѵ��ڵ��˼�¼����ˢ�µ�����Ϣ
		return
	end

	for i=10, 19 do
		local enemy = Battle.GetPlayIndex(battleIndex, i);
		if enemy >= 0 then
			local enemyId = Char.GetData(enemy, CONST.����_ENEMY_ID);
			local enemyLv = Char.GetData(enemy,CONST.����_�ȼ�);
			if not curBattleEnemyTbl[enemyId] then
				curBattleEnemyTbl[enemyId] = enemyLv;
			elseif curBattleEnemyTbl[enemyId] < enemyLv then
				curBattleEnemyTbl[enemyId] = enemyLv;
			end
		end
	end

	local tmpTbl = {};
	for id, lv in pairs(curBattleEnemyTbl) do
		table.insert(tmpTbl, {id, lv});
	end

	EnemyTbl[cdk][2] = tmpTbl;
	EnemyTbl[cdk][3] = 1;

end



-- �ǳ��سǻص�, ��մ������б�, ���ر���
function Module:LoginGateEvent(player)
	local cdk = Char.GetData(player,CONST.����_CDK);
	Char.SetData(player,CONST.����_�㲽��,0);
	Char.SetData(player,CONST.����_������,0);
	Char.SetLoopEvent(nil, 'ymloop', player, 0);
	Char.SetData(player,CONST.����_�����п���,0);
	Char.SetLoopEvent(nil, 'qmloop', player, 0);
	NLG.UpChar(player);
	if EnemyTbl[cdk] ~= nil then
		EnemyTbl[cdk] = {};
	end
	NLG.SystemMessage(player,"�Ԅ����������������M���P�]�ˣ�");
	return 0;
end

-- �ǳ��ص�, ��մ������б�, ���ر���
function Module:LogoutEvent(player)
	local cdk = Char.GetData(player,CONST.����_CDK);
	Char.SetData(player,CONST.����_�㲽��,0);
	Char.SetData(player,CONST.����_������,0);
	Char.SetLoopEvent(nil,'ymloop', player, 0);
	Char.SetData(player,CONST.����_�����п���,0);
	Char.SetLoopEvent(nil,'qmloop', player, 0);
	NLG.UpChar(player);
	if EnemyTbl[cdk] ~= nil then
		EnemyTbl[cdk] = {};
	end
	NLG.SystemMessage(player,"�Ԅ����������������M���P�]�ˣ�");
	return 0;
end

function Module:onLoad()
	self:logInfo('load')
	self:regCallback('BattleStartEvent', Func.bind(self.battleStartEventCallback, self))
	self:regCallback('LoginGateEvent', Func.bind(self.LoginGateEvent, self))
	self:regCallback('LogoutEvent', Func.bind(self.LogoutEvent, self))
	self:regCallback('LoopEvent', Func.bind(self.ymloop, self))
	self:regCallback('ymloop', function(player)
		local playeryd = Char.GetData(player,CONST.����_ս����) == 0;
		local ymxsNum = Char.ItemNum(player,ymxs);
		local ymbs = Char.GetData(player,CONST.����_�㲽��);
		local mgxNum = Char.ItemNum(player,mgx);
		local hjpwNum = Char.ItemNum(player,hjpw);
		local cdk = Char.GetData(player,CONST.����_CDK);
		local playerLV = Char.GetData(player, CONST.����_�ȼ�);
		if playeryd then
			if unDelYMX then
				ymxsNum = 999
				ymbs = 999
			end

			if unDelMGX then
				mgxNum = 999
			end

			if unDelHJPW then
				hjpwNum = 999
			end

			if (Char.GetYellowInjured(player)>=1) then
				Char.SetData(player,CONST.����_�㲽��,0);
				Char.SetData(player,CONST.����_������,0);
				Char.SetLoopEvent(nil,'ymloop',player,0);
				NLG.SystemMessage(player,'�z�y����܂����Ԅ������P�]��')
				return;
			end

			if ymbs > 0 then
				--��ħ����ʣ�ಽ��, �����������в���
				-- ������ˮ
				-- ������ˮ, ������
				-- ������ˮ, ������
				Char.SetData(player, CONST.����_�㲽��, ymbs-1);
				NLG.UpChar(player);
				if cdk == EnemyTbl[cdk][1]then
					if EnemyTbl[cdk][2] == nil then
						Battle.Encount(player, player);
					elseif mgxNum == 0 then
						Battle.Encount(player, player);
					elseif mgxNum > 1 then
						if not unDelMGX then
							Char.DelItem(player,mgx,1);
							Item.UpItem(player, -1);
						end

						local curBattleEnemyTbl = EnemyTbl[cdk][2];
						local enemyIdTbl = {};
						local enemyLvTbl = {};
						for i=1, 10 do
							local rndIdx = NLG.Rand(1, #curBattleEnemyTbl);
							table.insert(enemyIdTbl, curBattleEnemyTbl[rndIdx][1]);

							if hjpwNum > 0 then
								if useCharLV then
									table.insert(enemyLvTbl, playerLV+5);
								else
									table.insert(enemyLvTbl, curBattleEnemyTbl[rndIdx][2]);
								end
							else
								table.insert(enemyLvTbl, curBattleEnemyTbl[rndIdx][2]);
							end
						end

						if hjpwNum > 0 then
							if not unDelHJPW then
								Char.DelItem(player, hjpw, 1);
								Item.UpItem(player, -1);
							end
						end

						Battle.PVE(player, player, nil, enemyIdTbl, enemyLvTbl,  nil)
					else
						Battle.Encount(player, player);
					end
				else
					Battle.Encount(player, player);
				end
				NLG.SystemMessage(player,'�Ԅ�����ʣ�N'..ymbs..'��')
			else
				if ymxsNum > 1 then
					Char.SetData(player,CONST.����_�㲽��, 100);
					if not unDelYMX then
						Char.DelItem(player,ymxs,1);
						Item.UpItem(player,-1);
					end
					NLG.UpChar(player);
					NLG.SystemMessage(player,'����һ�������Ǭ���Ԅ������^�m��߀��'..(ymxsNum-1)..'�������Ǭ��');
					Battle.Encount(player, player);
				elseif ymxsNum == 1 then
					Char.SetData(player,CONST.����_�㲽��, 100);
					if not unDelYMX then
						Char.DelItem(player,ymxs,1);
						Item.UpItem(player,-1);
					end
					NLG.UpChar(player);
					NLG.SystemMessage(player,'�Ԅ���������һ����Ч��Ո���r�a������Ǭ��');
					Battle.Encount(player, player);
				else
					Char.SetData(player,CONST.����_�㲽��,0);
					Char.SetData(player,CONST.����_������,0);
					Char.SetLoopEvent(nil,'ymloop',player,0);
					NLG.SystemMessage(player,'�����Ǭ���Ĵ��M���Ԅ������P�]��')
				end
			end
		end
	end)
	self:regCallback('LoopEvent', Func.bind(self.qmloop, self))
	self:regCallback('qmloop', function(player)
		if qmxsnum >= 1 then
			Char.DelItem(player,qmxs,1);
			Item.UpItem(player, -1);
			NLG.SystemMessage(player,'����һƿ�����ͣ��������^�m��߀��'..(qmxsnum-1)..'ƿ�����͡�');
		else
			Char.SetData(player,CONST.����_�����п���,0);
			Char.SetLoopEvent(nil,'qmloop',player,0);
			NLG.UpChar(player);
			NLG.SystemMessage(player,'���������Ĵ��M���������P�]��')
		end
	end)
	self:regCallback('TalkEvent', function(player, msg)
		local ymxsNum = Char.ItemNum(player,ymxs)
		local qmxsnum = Char.ItemNum(player,qmxs)
		local cdk = Char.GetData(player,CONST.����_CDK);
		if (msg == "/1" or msg == "��1") then
			if EnemyTbl[cdk] == nil then
				EnemyTbl[cdk] = {}
				table.insert(EnemyTbl[cdk],cdk);
				print('EnemyTbl[cdk] 249', EnemyTbl[cdk])
			else
				for i,v in ipairs(EnemyTbl[cdk]) do
					if ( cdk==v )then
						table.remove(EnemyTbl[cdk],i);
						EnemyTbl[cdk] = {};
					end
				end
				table.insert(EnemyTbl[cdk],cdk);
			end

			if Char.GetData(player,CONST.����_�����п���) == 1 then
				NLG.SystemMessage(player,"������ʹ�ô����ͣ��o��ʹ���Ԅ�����");
			elseif Char.GetData(player,CONST.����_�㲽��) > 0 then
				Char.SetData(player,CONST.����_�㲽��,0);
				Char.SetData(player,CONST.����_������,0);
				Char.SetLoopEvent(nil,'ymloop',player,0);
				NLG.UpChar(player);
				NLG.SystemMessage(player,"�Ԅ������P�]�ˣ�");
			elseif unDelYMX then
				Char.SetData(player,CONST.����_�㲽��,999);
				Char.SetData(player,CONST.����_������,999);
				Char.SetLoopEvent(nil,'ymloop',player,5000);
				NLG.UpChar(player);
				NLG.SystemMessage(player,"�Ԅ������_ʼ�ˣ�ÿ5��Lԇһ�Ρ�");
			elseif not unDelYMX and ymxsNum > 0 then
				Char.SetData(player,CONST.����_�㲽��, 100);
				Char.SetData(player,CONST.����_������, 100);
				Char.SetLoopEvent(nil,'ymloop',player,5000);
				Char.DelItem(player,ymxs,1);
				Item.UpItem(player,-1);
				NLG.UpChar(player);
				NLG.SystemMessage(player,"�Ԅ������_ʼ�ˣ�ÿ5��Lԇһ�Ρ�");
			elseif not unDelYMX and ymxsNum == 0 then
				NLG.SystemMessage(player,'ȱ�ٹ����Ǭ���Ԅ������o���_����');
			end
		elseif (msg == "/2" or msg == "��2") then
			if Char.GetData(player,CONST.����_�㲽��)>0 then
				NLG.SystemMessage(player,"������ʹ�ò����������o��ʹ�ô����ͣ�");
			elseif Char.GetData(player,CONST.����_�����п���)==1 then
				Char.SetData(player,CONST.����_�����п���,0);
				Char.SetLoopEvent(nil,'qmloop',player,0);
				NLG.UpChar(player);
				NLG.SystemMessage(player,"�����������P�]��");
			elseif unDelQMX then
				Char.SetData(player,CONST.����_�����п���,1);
				NLG.UpChar(player);
				NLG.SystemMessage(player,"�������ѽ��_����");
			elseif not unDelQMX and qmxsnum > 0 then
				Char.SetData(player,CONST.����_�����п���,1);
				Char.SetLoopEvent(nil,'qmloop',player,120000);--�޸���ħˮ����ʱ�䣬��λ����
				NLG.UpChar(player);
				NLG.SystemMessage(player,"�������ѽ��_����");
			elseif not unDelQMX and qmxsnum == 0 then
				NLG.SystemMessage(player,'ȱ�ٴ����ͣ��������o���_����');
			end
		end
	end)
end

Char.GetYellowInjured = function(player)
	local Yellow = 0;
	if Char.PartyNum(player)>0 and player==Char.GetPartyMember(player,0) then
		for slot = 0,4 do
			local p = Char.GetPartyMember(player,slot);
			if(p>=0) then
				local injured_p = Char.GetData(p, CONST.����_����);
				if injured_p>25 then Yellow=Yellow+1; end
				local petSlot = Char.GetData(p, CONST.����_ս��);
				if petSlot > 0 then
					local petIndex = Char.GetPet(p,petSlot);
					local injured_t = Char.GetData(petIndex, CONST.����_����);
					if injured_t>25 then Yellow=Yellow+1; end
				end
			end
		end
	else
		local injured_p = Char.GetData(player, CONST.����_����);
		if injured_p>25 then Yellow=Yellow+1; end
		local petSlot = Char.GetData(player, CONST.����_ս��);
		if petSlot > 0 then
			local petIndex = Char.GetPet(player,petSlot);
			local injured_t = Char.GetData(petIndex, CONST.����_����);
			if injured_t>25 then Yellow=Yellow+1; end
		end
	end
	return Yellow;
end

function Module:onUnload()
	self:logInfo('unload');
end

return Module;
