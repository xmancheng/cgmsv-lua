local Module = ModuleBase:createModule('encountEX')

local unDelYMX = true; -- 不消耗诱魔香开关
local unDelQMX = true; -- 不消耗驱魔香开关
local unDelMGX = true; -- 不消耗满怪水开关
local unDelHJPW = false; -- 不消耗黄金喷雾开关
local useCharLV = false; -- 黄金喷雾基于人物等级

local ymxs = 900498 --诱魔香id, 1瓶100步, 使用增加步数
local qmxs = 900497 --驱魔香id
local mgx = 20230019 --满怪香水id, 需有耐久度, 不可叠放
local hjpw = 20230020 --黄金喷雾id(怪物等级=第一个怪物等级+5), 需有耐久度, 不可叠放


local EnemyTbl = {}

-- 战前回调, 生成用于满怪的敌人数组EnemyTbl[cdk], 
function Module:battleStartEventCallback(battleIndex)
	local player = Battle.GetPlayIndex(battleIndex, 0)
	local playerpet = Battle.GetPlayer(battleIndex, 5)
	if Char.GetData(player, CONST.对象_类型) == CONST.对象类型_人 then
		player = player
	else
		player = playerpet
	end

	local cdk = Char.GetData(player,CONST.对象_CDK);
	local curBattleEnemyTbl = {}
	if EnemyTbl[cdk] == nil then
		EnemyTbl[cdk] = {}
		table.insert(EnemyTbl[cdk],cdk);
	end
	if EnemyTbl[cdk][3] ~= nil then
		-- 如果已存在敌人记录，则不刷新敌人信息
		return
	end

	for i=10, 19 do
		local enemy = Battle.GetPlayIndex(battleIndex, i);
		if enemy >= 0 then
			local enemyId = Char.GetData(enemy, CONST.对象_ENEMY_ID);
			local enemyLv = Char.GetData(enemy,CONST.对象_等级);
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



-- 登出回城回调, 清空待遇敌列表, 并关闭香
function Module:LoginGateEvent(player)
	local cdk = Char.GetData(player,CONST.对象_CDK);
	Char.SetData(player,CONST.对象_香步数,0);
	Char.SetData(player,CONST.对象_香上限,0);
	Char.SetLoopEvent(nil, 'ymloop', player, 0);
	Char.SetData(player,CONST.对象_不遇敌开关,0);
	Char.SetLoopEvent(nil, 'qmloop', player, 0);
	NLG.UpChar(player);
	if EnemyTbl[cdk] ~= nil then
		EnemyTbl[cdk] = {};
	end
	NLG.SystemMessage(player,"自動遇敵、不遇敵、滿怪關閉了！");
	return 0;
end

-- 登出回调, 清空待遇敌列表, 并关闭香
function Module:LogoutEvent(player)
	local cdk = Char.GetData(player,CONST.对象_CDK);
	Char.SetData(player,CONST.对象_香步数,0);
	Char.SetData(player,CONST.对象_香上限,0);
	Char.SetLoopEvent(nil,'ymloop', player, 0);
	Char.SetData(player,CONST.对象_不遇敌开关,0);
	Char.SetLoopEvent(nil,'qmloop', player, 0);
	NLG.UpChar(player);
	if EnemyTbl[cdk] ~= nil then
		EnemyTbl[cdk] = {};
	end
	NLG.SystemMessage(player,"自動遇敵、不遇敵、滿怪關閉了！");
	return 0;
end

function Module:onLoad()
	self:logInfo('load')
	self:regCallback('BattleStartEvent', Func.bind(self.battleStartEventCallback, self))
	self:regCallback('LoginGateEvent', Func.bind(self.LoginGateEvent, self))
	self:regCallback('LogoutEvent', Func.bind(self.LogoutEvent, self))
	self:regCallback('LoopEvent', Func.bind(self.ymloop, self))
	self:regCallback('ymloop', function(player)
		local playeryd = Char.GetData(player,CONST.对象_战斗中) == 0;
		local ymxsNum = Char.ItemNum(player,ymxs);
		local ymbs = Char.GetData(player,CONST.对象_香步数);
		local mgxNum = Char.ItemNum(player,mgx);
		local hjpwNum = Char.ItemNum(player,hjpw);
		local cdk = Char.GetData(player,CONST.对象_CDK);
		local playerLV = Char.GetData(player, CONST.对象_等级);
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
				Char.SetData(player,CONST.对象_香步数,0);
				Char.SetData(player,CONST.对象_香上限,0);
				Char.SetLoopEvent(nil,'ymloop',player,0);
				NLG.SystemMessage(player,'檢測隊伍受傷，自動遇敵關閉！')
				return;
			end

			if ymbs > 0 then
				--诱魔香有剩余步数, 优先消耗已有步数
				-- 无满怪水
				-- 有满怪水, 无喷雾
				-- 有满怪水, 有喷雾
				Char.SetData(player, CONST.对象_香步数, ymbs-1);
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
				NLG.SystemMessage(player,'自動遇敵剩餘'..ymbs..'步')
			else
				if ymxsNum > 1 then
					Char.SetData(player,CONST.对象_香步数, 100);
					if not unDelYMX then
						Char.DelItem(player,ymxs,1);
						Item.UpItem(player,-1);
					end
					NLG.UpChar(player);
					NLG.SystemMessage(player,'消耗一個怪物餅乾，自動遇敵繼續，還有'..(ymxsNum-1)..'個怪物餅乾。');
					Battle.Encount(player, player);
				elseif ymxsNum == 1 then
					Char.SetData(player,CONST.对象_香步数, 100);
					if not unDelYMX then
						Char.DelItem(player,ymxs,1);
						Item.UpItem(player,-1);
					end
					NLG.UpChar(player);
					NLG.SystemMessage(player,'自動遇敵最後一次生效，請及時補充怪物餅乾！');
					Battle.Encount(player, player);
				else
					Char.SetData(player,CONST.对象_香步数,0);
					Char.SetData(player,CONST.对象_香上限,0);
					Char.SetLoopEvent(nil,'ymloop',player,0);
					NLG.SystemMessage(player,'怪物餅乾消耗殆盡，自動遇敵關閉！')
				end
			end
		end
	end)
	self:regCallback('LoopEvent', Func.bind(self.qmloop, self))
	self:regCallback('qmloop', function(player)
		if qmxsnum >= 1 then
			Char.DelItem(player,qmxs,1);
			Item.UpItem(player, -1);
			NLG.SystemMessage(player,'消耗一瓶大蒜油，不遇敵繼續，還有'..(qmxsnum-1)..'瓶大蒜油。');
		else
			Char.SetData(player,CONST.对象_不遇敌开关,0);
			Char.SetLoopEvent(nil,'qmloop',player,0);
			NLG.UpChar(player);
			NLG.SystemMessage(player,'大蒜油消耗殆盡，不遇敵關閉！')
		end
	end)
	self:regCallback('TalkEvent', function(player, msg)
		local ymxsNum = Char.ItemNum(player,ymxs)
		local qmxsnum = Char.ItemNum(player,qmxs)
		local cdk = Char.GetData(player,CONST.对象_CDK);
		if (msg == "/1" or msg == "、1") then
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

			if Char.GetData(player,CONST.对象_不遇敌开关) == 1 then
				NLG.SystemMessage(player,"你正在使用大蒜油，無法使用自動遇敵");
			elseif Char.GetData(player,CONST.对象_香步数) > 0 then
				Char.SetData(player,CONST.对象_香步数,0);
				Char.SetData(player,CONST.对象_香上限,0);
				Char.SetLoopEvent(nil,'ymloop',player,0);
				NLG.UpChar(player);
				NLG.SystemMessage(player,"自動遇敵關閉了！");
			elseif unDelYMX then
				Char.SetData(player,CONST.对象_香步数,999);
				Char.SetData(player,CONST.对象_香上限,999);
				Char.SetLoopEvent(nil,'ymloop',player,5000);
				NLG.UpChar(player);
				NLG.SystemMessage(player,"自動遇敵開始了，每5秒嘗試一次。");
			elseif not unDelYMX and ymxsNum > 0 then
				Char.SetData(player,CONST.对象_香步数, 100);
				Char.SetData(player,CONST.对象_香上限, 100);
				Char.SetLoopEvent(nil,'ymloop',player,5000);
				Char.DelItem(player,ymxs,1);
				Item.UpItem(player,-1);
				NLG.UpChar(player);
				NLG.SystemMessage(player,"自動遇敵開始了，每5秒嘗試一次。");
			elseif not unDelYMX and ymxsNum == 0 then
				NLG.SystemMessage(player,'缺少怪物餅乾，自動遇敵無法開啟！');
			end
		elseif (msg == "/2" or msg == "、2") then
			if Char.GetData(player,CONST.对象_香步数)>0 then
				NLG.SystemMessage(player,"你正在使用步步遇敵，無法使用大蒜油！");
			elseif Char.GetData(player,CONST.对象_不遇敌开关)==1 then
				Char.SetData(player,CONST.对象_不遇敌开关,0);
				Char.SetLoopEvent(nil,'qmloop',player,0);
				NLG.UpChar(player);
				NLG.SystemMessage(player,"不遇敵功能關閉！");
			elseif unDelQMX then
				Char.SetData(player,CONST.对象_不遇敌开关,1);
				NLG.UpChar(player);
				NLG.SystemMessage(player,"不遇敵已經開啟！");
			elseif not unDelQMX and qmxsnum > 0 then
				Char.SetData(player,CONST.对象_不遇敌开关,1);
				Char.SetLoopEvent(nil,'qmloop',player,120000);--修改驱魔水持续时间，单位毫秒
				NLG.UpChar(player);
				NLG.SystemMessage(player,"不遇敵已經開啟！");
			elseif not unDelQMX and qmxsnum == 0 then
				NLG.SystemMessage(player,'缺少大蒜油，不遇敵無法開啟！');
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
				local injured_p = Char.GetData(p, CONST.对象_受伤);
				if injured_p>25 then Yellow=Yellow+1; end
				local petSlot = Char.GetData(p, CONST.对象_战宠);
				if petSlot > 0 then
					local petIndex = Char.GetPet(p,petSlot);
					local injured_t = Char.GetData(petIndex, CONST.对象_受伤);
					if injured_t>25 then Yellow=Yellow+1; end
				end
			end
		end
	else
		local injured_p = Char.GetData(player, CONST.对象_受伤);
		if injured_p>25 then Yellow=Yellow+1; end
		local petSlot = Char.GetData(player, CONST.对象_战宠);
		if petSlot > 0 then
			local petIndex = Char.GetPet(player,petSlot);
			local injured_t = Char.GetData(petIndex, CONST.对象_受伤);
			if injured_t>25 then Yellow=Yellow+1; end
		end
	end
	return Yellow;
end

function Module:onUnload()
	self:logInfo('unload');
end

return Module;
