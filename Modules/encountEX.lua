local Module = ModuleBase:createModule('encountEX')

local 不消耗诱魔水 = false--消耗道具开关
local 不消耗驱魔水 = false--消耗道具开关
local ymxs = 900498--诱魔香水
local qmxs = 900497--驱魔香水
local hmxs = 900500--满怪香水
local gmxs = 900501--黄金喷雾

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
		local gmxsnum = Char.ItemNum(player,gmxs)
		if enemy>=0 and hmxsnum >= 1 and gmxsnum == 0 and Char.GetData(enemy, CONST.CHAR_类型) == CONST.对象类型_怪 and Char.GetData(enemy,CONST.对象_战斗状态) ~= CONST.战斗_BOSS战 then
			local enemyId = Char.GetData(enemy, CONST.CHAR_ENEMY_ID);
			local enemyLv = Char.GetData(enemy,CONST.CHAR_等级);
			--local enemyIndex = Data.EnemyGetDataIndex(enemyId)
			local cdk = Char.GetData(player,CONST.对象_CDK);
			if EnemyTbl[cdk] ~= nill then
				local EnemyIdAr = {enemyId, enemyId, enemyId, enemyId, enemyId, enemyId, enemyId, enemyId, enemyId, enemyId}
				local BaseLevelAr = {enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv}
				table.insert(EnemyTbl[cdk],EnemyIdAr);
				table.insert(EnemyTbl[cdk],BaseLevelAr);
				return EnemyTbl[cdk];
			end
		elseif enemy>=0 and hmxsnum >= 1 and gmxsnum >= 1 and Char.GetData(enemy, CONST.CHAR_类型) == CONST.对象类型_怪 and Char.GetData(enemy,CONST.对象_战斗状态) ~= CONST.战斗_BOSS战 then
			local enemyId = Char.GetData(enemy, CONST.CHAR_ENEMY_ID);
			local enemyLv = Char.GetData(enemy,CONST.CHAR_等级);
			local cdk = Char.GetData(player,CONST.对象_CDK);
			local enemyLv = enemyLv+5;
			if EnemyTbl[cdk] ~= nill then
				local EnemyIdAr = {enemyId, enemyId, enemyId, enemyId, enemyId, enemyId, enemyId, enemyId, enemyId, enemyId}
				local BaseLevelAr = {enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv}
				table.insert(EnemyTbl[cdk],EnemyIdAr);
				table.insert(EnemyTbl[cdk],BaseLevelAr);
				return EnemyTbl[cdk];
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
	NLG.SystemMessage(player,"自動遇敵、不遇敵、滿怪關閉了！");
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
	NLG.SystemMessage(player,"自動遇敵、不遇敵、滿怪關閉了！");
  return 0;
end

function Module:onLoad()
	self:logInfo('load')
	tenMobsNPC = self:NPC_createNormal('滿怪噴霧調用', 14682, { map = 777, x = 40, y = 35, direction = 6, mapType = 0 })
	self:NPC_regWindowTalkedEvent(tenMobsNPC, function(npc, player, _seqno, _select, _data)
		local cdk = Char.GetData(player,CONST.对象_CDK);
		local seqno = tonumber(_seqno)
		local select = tonumber(_select)
		local data = tonumber(_data)
	end)
	self:NPC_regTalkedEvent(tenMobsNPC, function(npc, player)
	if(NLG.CheckInFront(player, npc, 1)==false) then
		return ;
	end
	if (NLG.CanTalk(npc, player) == true) then
	end
	return
	end)

	self:regCallback('BattleStartEvent', Func.bind(self.battleStartEventCallback, self))
	self:regCallback('LoginGateEvent', Func.bind(self.LoginGateEvent, self))
	self:regCallback('LogoutEvent', Func.bind(self.LogoutEvent, self))
	self:regCallback('LoopEvent', Func.bind(self.ymloop,self))
	self:regCallback('ymloop',function(player)
	local playeryd = Char.GetData(player,%对象_战斗中%) == 0
	local ymxsnum = Char.ItemNum(player,ymxs)
	local ymbs = Char.GetData(player,%对象_香步数%)
	local hmxsnum = Char.ItemNum(player,hmxs)
	local gmxsnum = Char.ItemNum(player,gmxs)
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
				elseif cdk == EnemyTbl[cdk][1] and hmxsnum > 1 and gmxsnum == 0 then          --满怪香水
					local PartyNum = Char.PartyNum(player);
					if (PartyNum>1) then
						for Slot=1,PartyNum do
							local TeamPlayer = Char.GetPartyMember(player,Slot);
							if Char.GetBattleIndex(player) >= 0 then
								return
							end
						end
						Char.DelItem(player,hmxs,1);
						Battle.PVE(player, tenMobsNPC, nil, EnemyTbl[cdk][2], EnemyTbl[cdk][3],  nil)
					else
						Char.DelItem(player,hmxs,1);
						Battle.PVE(player, tenMobsNPC, nil, EnemyTbl[cdk][2], EnemyTbl[cdk][3],  nil)
					end
				elseif cdk == EnemyTbl[cdk][1] and hmxsnum > 1 and gmxsnum >= 1 then             --满怪香水&黄金喷雾
					local PartyNum = Char.PartyNum(player);
					if (PartyNum>1) then
						for Slot=1,PartyNum do
							local TeamPlayer = Char.GetPartyMember(player,Slot);
							if Char.GetBattleIndex(player) >= 0 then
								return
							end
						end
						Char.DelItem(player,hmxs,1);
						Char.DelItem(player,gmxs,1);
						Battle.PVE(player, tenMobsNPC, nil, EnemyTbl[cdk][2], EnemyTbl[cdk][3],  nil)
					else
						Char.DelItem(player,hmxs,1);
						Char.DelItem(player,gmxs,1);
						Battle.PVE(player, tenMobsNPC, nil, EnemyTbl[cdk][2], EnemyTbl[cdk][3],  nil)
					end
				elseif cdk == EnemyTbl[cdk][1] and hmxsnum == 1 and gmxsnum == 0 then       --满怪香水
					local PartyNum = Char.PartyNum(player);
					if (PartyNum>1) then
						for Slot=1,PartyNum do
							local TeamPlayer = Char.GetPartyMember(player,Slot);
							if Char.GetBattleIndex(player) >= 0 then
								return
							end
						end
						Char.DelItem(player,hmxs,1);
						Battle.PVE(player, tenMobsNPC, nil, EnemyTbl[cdk][2], EnemyTbl[cdk][3],  nil)
					else
						Char.DelItem(player,hmxs,1);
						Battle.PVE(player, tenMobsNPC, nil, EnemyTbl[cdk][2], EnemyTbl[cdk][3],  nil)
					end
					for i,v in ipairs(EnemyTbl[cdk]) do
						if ( cdk==v )then
							table.remove(EnemyTbl[cdk],i);
							EnemyTbl[cdk] = {};
						end
					end
				elseif cdk == EnemyTbl[cdk][1] and hmxsnum == 1 and gmxsnum >= 1 then         --满怪香水&黄金喷雾
					local PartyNum = Char.PartyNum(player);
					if (PartyNum>1) then
						for Slot=1,PartyNum do
							local TeamPlayer = Char.GetPartyMember(player,Slot);
							if Char.GetBattleIndex(player) >= 0 then
								return
							end
						end
						Char.DelItem(player,hmxs,1);
						Char.DelItem(player,gmxs,1);
						Battle.PVE(player, tenMobsNPC, nil, EnemyTbl[cdk][2], EnemyTbl[cdk][3],  nil)
					else
						Char.DelItem(player,hmxs,1);
						Char.DelItem(player,gmxs,1);
						Battle.PVE(player, tenMobsNPC, nil, EnemyTbl[cdk][2], EnemyTbl[cdk][3],  nil)
					end
					for i,v in ipairs(EnemyTbl[cdk]) do
						if ( cdk==v )then
							table.remove(EnemyTbl[cdk],i);
							EnemyTbl[cdk] = {};
						end
					end
				else
					local PartyNum = Char.PartyNum(player);
					if (PartyNum>1) then
						for Slot=1,PartyNum do
							local TeamPlayer = Char.GetPartyMember(player,Slot);
							if Char.GetBattleIndex(player) >= 0 then
								return
							end
						end
						Battle.Encount(player, player);
					else
						Battle.Encount(player, player);
					end
				end
				NLG.SystemMessage(player,'自動遇敵剩餘'..(ymbs-980)..'步')
			else
				if ymxsnum > 1 then
					Char.SetData(player,%对象_香步数%,998);
					Char.DelItem(player,ymxs,1);
					Item.UpItem(player,-1);
					NLG.UpChar(player);
					NLG.SystemMessage(player,'消耗一個怪物餅乾，自動遇敵繼續，還有'..(ymxsnum-1)..'個怪物餅乾。');
					local PartyNum = Char.PartyNum(player);
					if (PartyNum>1) then
						for Slot=1,PartyNum do
							local TeamPlayer = Char.GetPartyMember(player,Slot);
							if Char.GetBattleIndex(player) >= 0 then
								return
							end
						end
						Battle.Encount(player, player);
					else
						Battle.Encount(player, player);
					end
				elseif ymxsnum == 1 then
					Char.SetData(player,%对象_香步数%,998);
					Char.DelItem(player,ymxs,1);
					Item.UpItem(player,-1);
					NLG.UpChar(player);
					NLG.SystemMessage(player,'自動遇敵最後一次生效,請及時補充怪物餅乾！');
					local PartyNum = Char.PartyNum(player);
					if (PartyNum>1) then
						for Slot=1,PartyNum do
							local TeamPlayer = Char.GetPartyMember(player,Slot);
							if Char.GetBattleIndex(player) >= 0 then
								return
							end
						end
						Battle.Encount(player, player);
					else
						Battle.Encount(player, player);
					end
				else
					Char.SetData(player,%对象_香步数%,0);
					Char.SetData(player,%对象_香上限%,0);
					Char.SetLoopEvent(nil,'ymloop',player,0);
					NLG.SystemMessage(player,'怪物餅乾消耗殆盡，自動遇敵關閉！')
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
		NLG.SystemMessage(player,'消耗一瓶大蒜油，不遇敵繼續，還有'..(qmxsnum-1)..'瓶大蒜油。');
	elseif qmxsnum == 1 then
		Char.DelItem(player,qmxs,1);
		Item.UpItem(player,-1);
		NLG.SystemMessage(player,'不遇敵最後一次生效,請及時補充大蒜油！');
	else
		Char.SetData(player,%对象_不遇敌开关%,0);
		Char.SetLoopEvent(nil,'qmloop',player,0);
		NLG.UpChar(player);
		NLG.SystemMessage(player,'大蒜油消耗殆盡，不遇敵關閉！')
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
			NLG.SystemMessage(player,"你正在使用大蒜油，無法使用自動遇敵");
		elseif Char.GetData(player,%对象_香步数%) > 0 then
			Char.SetData(player,%对象_香步数%,0);
			Char.SetData(player,%对象_香上限%,0);
			Char.SetLoopEvent(nil,'ymloop',player,0);
			NLG.UpChar(player);
			NLG.SystemMessage(player,"自動遇敵關閉了！");
		elseif 不消耗诱魔水 then
			Char.SetData(player,%对象_香步数%,999);
			Char.SetData(player,%对象_香上限%,999);
			Char.SetLoopEvent(nil,'ymloop',player,10000);
			NLG.UpChar(player);
			NLG.SystemMessage(player,"自動遇敵開始了，每10秒嘗試一次。");
		elseif not 不消耗诱魔水 and ymxsnum > 0 then
			Char.SetData(player,%对象_香步数%,999);
			Char.SetData(player,%对象_香上限%,999);
			Char.SetLoopEvent(nil,'ymloop',player,10000);
			Char.DelItem(player,ymxs,1);
			Item.UpItem(player,-1);
			NLG.UpChar(player);
			NLG.SystemMessage(player,"自動遇敵開始了，每10秒嘗試一次。");
		elseif not 不消耗诱魔水 and ymxsnum == 0 then
			NLG.SystemMessage(player,'缺少怪物餅乾，自動遇敵無法開啟！');
		end
	elseif (msg == "/2" or msg == "、2") then
		if Char.GetData(player,%对象_香步数%)>0 then
			NLG.SystemMessage(player,"你正在使用步步遇敵，無法使用大蒜油！");
		elseif Char.GetData(player,%对象_不遇敌开关%)==1 then
			Char.SetData(player,%对象_不遇敌开关%,0);
			Char.SetLoopEvent(nil,'qmloop',player,0);
			NLG.UpChar(player);
			NLG.SystemMessage(player,"不遇敵功能關閉！");
		elseif 不消耗驱魔水 then
			Char.SetData(player,%对象_不遇敌开关%,1);
			NLG.UpChar(player);
			NLG.SystemMessage(player,"不遇敵已經開啟！");
		elseif not 不消耗驱魔水 and qmxsnum > 0 then
			Char.SetData(player,%对象_不遇敌开关%,1);
			Char.SetLoopEvent(nil,'qmloop',player,120000);--修改驱魔水持续时间，单位毫秒
			NLG.UpChar(player);
			NLG.SystemMessage(player,"不遇敵已經開啟！");
		elseif not 不消耗驱魔水 and qmxsnum == 0 then
			NLG.SystemMessage(player,'缺少大蒜油，不遇敵無法開啟！');
		end
	end
	end)
end

function Module:onUnload()
  self:logInfo('unload');
end

return Module;

