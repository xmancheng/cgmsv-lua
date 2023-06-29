local Module = ModuleBase:createModule('encountEX')

local 不消耗诱魔水 = false--消耗道具开关
local 不消耗驱魔水 = false--消耗道具开关
local ymxs = 900498--诱魔香水
local qmxs = 900497--驱魔香水
local hmxs = 900500--满怪香水

local EnemyTbl = {}

function Module:battleStartEventCallback(battleIndex)
	for i=10, 19 do
		local enemy = Battle.GetPlayIndex(battleIndex, i)
		local player = Battle.GetPlayIndex(battleIndex, 0)
		local playerpet = Battle.GetPlayer(battleIndex, 5)
		if Char.GetData(player, CONST.CHAR_类型) == CONST.对象类型_人 then
			player = player
		else
			player = playerpet
		end
		local hmxsnum = Char.ItemNum(player,hmxs)
		if enemy>=0 and hmxsnum >= 1 and Char.GetData(enemy, CONST.CHAR_类型) == CONST.对象类型_怪 and Char.GetData(enemy,CONST.对象_战斗状态) ~= CONST.战斗_BOSS战 then
			local enemyId = Char.GetData(enemy, CONST.CHAR_ENEMY_ID);
			local enemyLv = Char.GetData(enemy,CONST.CHAR_等级);
			--local enemyIndex = Data.EnemyGetDataIndex(enemyId)
			--local enemylow = Data.EnemyGetData(enemyIndex, CONST.Enemy_最低数量)
			--local enemyhigh = Data.EnemyGetData(enemyIndex, CONST.Enemy_最高数量)
			--print(enemyId,enemyIndex,enemylow,enemyhigh)
			local cdk = Char.GetData(player,CONST.对象_CDK);
			if EnemyTbl[cdk] ~= nill then
				local EnemyIdAr = {enemyId, enemyId, enemyId, enemyId, enemyId, enemyId, enemyId, enemyId, enemyId, enemyId}
				local BaseLevelAr = {enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv}
				table.insert(EnemyTbl[cdk],EnemyIdAr);
				table.insert(EnemyTbl[cdk],BaseLevelAr);
			end
		end
	end
end

function Module:LoginGateEvent(player)
	local cdk = Char.GetData(player,CONST.对象_CDK);
	Char.SetData(player,%对象_香步数%,0);
	Char.SetData(player,%对象_香上限%,0);
	Char.SetLoopEvent(nil,'ymloop',player,0);
	Char.SetData(player,%对象_不遇敌开关%,0);
	Char.SetLoopEvent(nil,'qmloop',player,0);
	NLG.UpChar(player);
	if EnemyTbl[cdk] ~= nill then
		for i,v in ipairs(EnemyTbl[cdk]) do
			if ( cdk==v )then
				table.remove(EnemyTbl[cdk],i);
				EnemyTbl[cdk] = {};
			end
		end
	end
	NLG.SystemMessage(player,"自动遇敌、不遇敌、滿怪关闭了！");
  return 0;
end

function Module:LogoutEvent(player)
	local cdk = Char.GetData(player,CONST.对象_CDK);
	Char.SetData(player,%对象_香步数%,0);
	Char.SetData(player,%对象_香上限%,0);
	Char.SetLoopEvent(nil,'ymloop',player,0);
	Char.SetData(player,%对象_不遇敌开关%,0);
	Char.SetLoopEvent(nil,'qmloop',player,0);
	NLG.UpChar(player);
	if EnemyTbl[cdk] ~= nill then
		for i,v in ipairs(EnemyTbl[cdk]) do
			if ( cdk==v )then
				table.remove(EnemyTbl[cdk],i);
				EnemyTbl[cdk] = {};
			end
		end
	end
	NLG.SystemMessage(player,"自动遇敌、不遇敌、滿怪关闭了！");
  return 0;
end

function Module:onLoad()
	self:logInfo('load')
	self:regCallback('BattleStartEvent', Func.bind(self.battleStartEventCallback, self))
	self:regCallback('LoginGateEvent', Func.bind(self.LoginGateEvent, self))
	self:regCallback('LogoutEvent', Func.bind(self.LogoutEvent, self))
	self:regCallback('LoopEvent', Func.bind(self.ymloop,self))
	self:regCallback('ymloop',function(player)
	local playeryd = Char.GetData(player,%对象_战斗中%) == 0
	local ymxsnum = Char.ItemNum(player,ymxs)
	local ymbs = Char.GetData(player,%对象_香步数%)
	local hmxsnum = Char.ItemNum(player,hmxs)
	local cdk = Char.GetData(player,CONST.对象_CDK);
	if playeryd then
		if 不消耗诱魔水 then
			Battle.Encount(player, player);
		else
			if ymbs > 979 then--修改诱魔水持续步数
				Char.SetData(player,%对象_香步数%,ymbs-1);
				NLG.UpChar(player);
				if cdk == EnemyTbl[cdk][1] and EnemyTbl[cdk][2] == nill then
					Battle.Encount(player, player);
				elseif cdk == EnemyTbl[cdk][1] and hmxsnum > 1 then
					Char.DelItem(player,hmxs,1);
					Battle.PVE(player, player, nil, EnemyTbl[cdk][2], EnemyTbl[cdk][3],  nil)
				elseif cdk == EnemyTbl[cdk][1] and hmxsnum == 1 then
					Char.DelItem(player,hmxs,1);
					Battle.PVE(player, player, nil, EnemyTbl[cdk][2], EnemyTbl[cdk][3],  nil)
					for i,v in ipairs(EnemyTbl[cdk]) do
						if ( cdk==v )then
							table.remove(EnemyTbl[cdk],i);
							EnemyTbl[cdk] = {};
						end
					end
				else
					Battle.Encount(player, player);
				end
				NLG.SystemMessage(player,'自动遇敌剩余'..(ymbs-980)..'步')
			else
				if ymxsnum > 1 then
					Char.SetData(player,%对象_香步数%,998);
					Char.DelItem(player,ymxs,1);
					Item.UpItem(player,-1);
					NLG.UpChar(player);
					NLG.SystemMessage(player,'消耗一个怪物饼干，自动遇敌继续，还有'..(ymxsnum-1)..'个怪物饼干。');
					Battle.Encount(player, player);
				elseif ymxsnum == 1 then
					Char.SetData(player,%对象_香步数%,998);
					Char.DelItem(player,ymxs,1);
					Item.UpItem(player,-1);
					NLG.UpChar(player);
					NLG.SystemMessage(player,'自动遇敌最后一次生效,请及时补充怪物饼干！');
					Battle.Encount(player, player);
				else
					Char.SetData(player,%对象_香步数%,0);
					Char.SetData(player,%对象_香上限%,0);
					Char.SetLoopEvent(nil,'ymloop',player,0);
					NLG.SystemMessage(player,'怪物饼干消耗殆尽，自动遇敌关闭！')
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
		NLG.SystemMessage(player,'消耗一瓶大蒜油，不遇敌继续，还有'..(qmxsnum-1)..'瓶大蒜油。');
	elseif qmxsnum == 1 then
		Char.DelItem(player,qmxs,1);
		Item.UpItem(player,-1);
		NLG.SystemMessage(player,'不遇敌最后一次生效,请及时补充大蒜油！');
	else
		Char.SetData(player,%对象_不遇敌开关%,0);
		Char.SetLoopEvent(nil,'qmloop',player,0);
		NLG.UpChar(player);
		NLG.SystemMessage(player,'大蒜油消耗殆尽，不遇敌关闭！')
	end
	end)
	self:regCallback('TalkEvent', function(player, msg)
	local ymxsnum = Char.ItemNum(player,ymxs)
	local qmxsnum = Char.ItemNum(player,qmxs)
	local cdk = Char.GetData(player,CONST.对象_CDK);
	if (msg == "/1" or msg == "、1") then
		if EnemyTbl[cdk] == nill then
			EnemyTbl[cdk] = {}
			table.insert(EnemyTbl[cdk],cdk);
		else
			for i,v in ipairs(EnemyTbl[cdk]) do
				if ( cdk==v )then
					table.remove(EnemyTbl[cdk],i);
					EnemyTbl[cdk] = {};
				end
			end
			table.insert(EnemyTbl[cdk],cdk);
		end
		if Char.GetData(player,%对象_不遇敌开关%) == 1 then
			NLG.SystemMessage(player,"你正在使用大蒜油，无法使用自动遇敌");
		elseif Char.GetData(player,%对象_香步数%) > 0 then
			Char.SetData(player,%对象_香步数%,0);
			Char.SetData(player,%对象_香上限%,0);
			Char.SetLoopEvent(nil,'ymloop',player,0);
			NLG.UpChar(player);
			NLG.SystemMessage(player,"自动遇敌关闭了！");
		elseif 不消耗诱魔水 then
			Char.SetData(player,%对象_香步数%,999);
			Char.SetData(player,%对象_香上限%,999);
			Char.SetLoopEvent(nil,'ymloop',player,5000);
			NLG.UpChar(player);
			NLG.SystemMessage(player,"自动遇敌开始了，每5秒尝试一次。");
		elseif not 不消耗诱魔水 and ymxsnum > 0 then
			Char.SetData(player,%对象_香步数%,999);
			Char.SetData(player,%对象_香上限%,999);
			Char.SetLoopEvent(nil,'ymloop',player,5000);
			Char.DelItem(player,ymxs,1);
			Item.UpItem(player,-1);
			NLG.UpChar(player);
			NLG.SystemMessage(player,"自动遇敌开始了，每5秒尝试一次。");
		elseif not 不消耗诱魔水 and ymxsnum == 0 then
			NLG.SystemMessage(player,'缺少怪物饼干，自动遇敌无法开启！');
		end
	elseif (msg == "/2" or msg == "、2") then
		if Char.GetData(player,%对象_香步数%)>0 then
			NLG.SystemMessage(player,"你正在使用步步遇敌，无法使用大蒜油！");
		elseif Char.GetData(player,%对象_不遇敌开关%)==1 then
			Char.SetData(player,%对象_不遇敌开关%,0);
			Char.SetLoopEvent(nil,'qmloop',player,0);
			NLG.UpChar(player);
			NLG.SystemMessage(player,"不遇敌功能关闭！");
		elseif 不消耗驱魔水 then
			Char.SetData(player,%对象_不遇敌开关%,1);
			NLG.UpChar(player);
			NLG.SystemMessage(player,"不遇敌已经开启！");
		elseif not 不消耗驱魔水 and qmxsnum > 0 then
			Char.SetData(player,%对象_不遇敌开关%,1);
			Char.SetLoopEvent(nil,'qmloop',player,120000);--修改驱魔水持续时间，单位毫秒
			NLG.UpChar(player);
			NLG.SystemMessage(player,"不遇敌已经开启！");
		elseif not 不消耗驱魔水 and qmxsnum == 0 then
			NLG.SystemMessage(player,'缺少大蒜油，不遇敌无法开启！');
		end
	end
	end)
end

function Module:onUnload()
  self:logInfo('unload');
end

return Module;
