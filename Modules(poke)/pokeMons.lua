local Module = ModuleBase:createModule('pokeMons')

tbl_MonsIndex = tbl_MonsIndex or {}
-----------------------------------------------------------------
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('AutoBattleCommandEvent', Func.bind(self.onAutoBattleCommandEvent, self));
  --self:regCallback('LoginEvent',Func.bind(self.onLoginEvent,self));
  self:regCallback('BattleSurpriseEvent',Func.bind(self.onBattleSurpriseEvent,self));
  self:regCallback('BeforeBattleTurnEvent', Func.bind(self.onBeforeBattleTurnCallback, self));
  self:regCallback('AfterBattleTurnEvent', Func.bind(self.onAfterBattleTurnCallback, self));
  self:regCallback('BattleOverEvent', Func.bind(self.onBattleOverCallback, self));
  Item.CreateNewItemType( 64, "AI模組", 400188, -1, 0);

end

-- --- 處理自動戰鬥指令事件 (引擎要求發送指令時被呼叫)
function Module:onAutoBattleCommandEvent(battleIndex, ch)
	local autoBattleIndex = battleIndex;
	local petSlot = Char.GetData(ch, CONST.对象_战宠);
	local ridePet = Char.GetData(ch, CONST.对象_骑宠);
	local ch2 = ch;	-- ch2 預設等於玩家 ch
	--print(ch, ch2, ridePet, petSlot, Battle.GetTurn(battleIndex));
	-- 判斷戰寵是否存在
	if petSlot >= 0 and petSlot < 5 then
		ch2 = Char.GetPet(ch, petSlot);
	end
	--print(ch, ch2, ridePet, petSlot, Battle.GetTurn(battleIndex));

	-- 如果騎寵和戰寵是同一隻，則將 ch 索引設定為寵物
	if ridePet >= 0 and ridePet < 5 and ridePet == petSlot then
		ch = ch2;
	end
	--print(ch, ch2, ridePet, petSlot, Battle.GetTurn(battleIndex));

    -- 發送指令 (主要角色/騎寵)
    DoAction(ch, 1, autoBattleIndex);
    -- 發送指令 (戰寵/玩家本人，如果 ch 和 ch2 不同)
    DoAction(ch2, 2, autoBattleIndex);
    return 1;
end

-- --- 執行戰鬥動作
function DoAction(charIndex, actionNum, autoBattleIndex)
	--print(charIndex, actionNum, Battle.IsWaitingCommand(charIndex));
	if (Battle.IsWaitingCommand(charIndex)~=1) then return end

	local battleturn = Battle.GetTurn(autoBattleIndex);
	if Char.IsPlayer(charIndex) then
		local level = Char.GetData(charIndex, CONST.对象_等级);
		local cg1 = Char.GetData(charIndex, CONST.对象_体力);
		local cg2 = Char.GetData(charIndex, CONST.对象_力量);
		local cg3 = Char.GetData(charIndex, CONST.对象_强度);
		local cg4 = Char.GetData(charIndex, CONST.对象_速度);
		local cg5 = Char.GetData(charIndex, CONST.对象_魔法);
		--print(cg1,cg2,cg3,cg4,cg5);
		if (battleturn==0) then		--開場召喚夥伴
			local cdk = Char.GetData(charIndex, CONST.对象_CDK);
			if (actionNum==1) then
				for itemSlot=8,11 do
					local itemIndex = Char.GetItemIndex(charIndex, itemSlot);
					if (itemIndex>0) then
						local itemType = Item.GetData(itemIndex,CONST.对象_类型);		--類型64 AI模組
						local itemId = Item.GetData(itemIndex,CONST.道具_ID);
						local itemInfo_45 = Item.GetData(itemIndex,CONST.道具_特殊类型);	--形象編號
						if (itemType == 64 and itemInfo_45 > 0) then	--itemInfo_45表已成功激活
							local itemName = Item.GetData(itemIndex,CONST.道具_名字);
							local AIType = Item.GetData(itemIndex,CONST.道具_等级);		--AI模式
							local monsType = Item.GetData(itemIndex,CONST.道具_幸运);		--怪物類型
							local itemInfo_32 = Item.GetData(itemIndex,CONST.道具_属性一);
							local itemInfo_33 = Item.GetData(itemIndex,CONST.道具_属性二);
							local itemInfo_34 = Item.GetData(itemIndex,CONST.道具_属性一值);
							local itemInfo_35 = Item.GetData(itemIndex,CONST.道具_属性二值);
							local itemInfo_46 = Item.GetData(itemIndex,CONST.道具_子参一);	--施放tech編號
							local itemInfo_47 = Item.GetData(itemIndex,CONST.道具_子参二);	--進化素質加成表

							local MonsIndex = Char.CreateDummy()
							table.insert(tbl_MonsIndex[cdk],MonsIndex);
							Char.SetData(MonsIndex,CONST.对象_种族, 0);
							--屬性
							Char.GiveItem(MonsIndex, 19200, 1);
							Char.MoveItem(MonsIndex, 8, 5, -1);
							local item_1 = Char.HaveItem(MonsIndex,19200);
							Item.SetData(item_1,CONST.道具_属性一,itemInfo_32);
							Item.SetData(item_1,CONST.道具_属性二,itemInfo_33);
							Item.SetData(item_1,CONST.道具_属性一值,itemInfo_34);
							Item.SetData(item_1,CONST.道具_属性二值,itemInfo_35);
							Item.UpItem(MonsIndex, -1);
							--[[超過雙屬可行方案
							Char.GiveItem(MonsIndex, 19538, 1);
							Char.MoveItem(MonsIndex, 9, 6, -1);
							local item_2 = Char.HaveItem(MonsIndex,19538);
							Item.SetData(item_2,CONST.道具_属性一,3);
							Item.SetData(item_2,CONST.道具_属性二,4);
							Item.SetData(item_2,CONST.道具_属性一值,petbagPet.attr[tostring(CONST.对象_火属性)]);
							Item.SetData(item_2,CONST.道具_属性二值,petbagPet.attr[tostring(CONST.对象_风属性)]);
							Item.UpItem(MonsIndex, -1);]]
							--簡易全屬方案
							--Char.SetData(MonsIndex,CONST.对象_地属性, 20);
							--Char.SetData(MonsIndex,CONST.对象_水属性, 20);
							--Char.SetData(MonsIndex,CONST.对象_火属性, 20);
							--Char.SetData(MonsIndex,CONST.对象_风属性, 20);
							Char.SetData(MonsIndex,CONST.对象_形象, itemInfo_45);
							Char.SetData(MonsIndex,CONST.对象_原形, itemInfo_45);
							Char.SetData(MonsIndex,CONST.对象_职阶, AIType);			--AI模式

							--local skills = {}
							--table.insert(skills,itemInfo_46);
							--Char.SetTempData(MonsIndex, '自走技能', JSON.encode(skills));		--施放tech編號
							Char.SetData(MonsIndex,CONST.对象_金币, itemInfo_46);		--施放tech編號

							Char.SetData(MonsIndex,CONST.对象_名字, itemName);
							Char.SetData(MonsIndex,CONST.对象_等级, level);
							--怪物類型
							if monsType>=1 then
								cg2 = Char.GetData(charIndex, CONST.对象_魔法);
								cg5 = Char.GetData(charIndex, CONST.对象_力量);
							end
							Char.SetData(MonsIndex, CONST.对象_体力, cg1);
							Char.SetData(MonsIndex, CONST.对象_力量, cg2);
							Char.SetData(MonsIndex, CONST.对象_强度, cg3);
							Char.SetData(MonsIndex, CONST.对象_速度, cg4);
							Char.SetData(MonsIndex, CONST.对象_魔法, cg5);
							NLG.UpChar(MonsIndex);
							--進化加成(需倚賴在裝備上)
							Char.GiveItem(MonsIndex, 19538, 1);
							Char.MoveItem(MonsIndex, 9, 6, -1);
							local item_2 = Char.HaveItem(MonsIndex,19538);
							Item.SetData(item_2,CONST.道具_生命,0);
							Item.SetData(item_2,CONST.道具_魔力,0);
							Item.SetData(item_2,CONST.道具_攻击,0);
							Item.SetData(item_2,CONST.道具_防御,0);
							Item.SetData(item_2,CONST.道具_敏捷,0);
							Item.SetData(item_2,CONST.道具_精神,0);
							Item.SetData(item_2,CONST.道具_回复,0);
							Item.UpItem(MonsIndex, -1);
							Char.SetData(MonsIndex,CONST.对象_血, Char.GetData(MonsIndex,CONST.对象_最大血));
							Char.SetData(MonsIndex,CONST.对象_魔, Char.GetData(MonsIndex,CONST.对象_最大魔));
							NLG.UpChar(MonsIndex);
							--加入戰鬥
							--Char.Warp(MonsIndex,Char.GetData(charIndex,CONST.对象_MAP),Char.GetData(charIndex,CONST.对象_地图),Char.GetData(charIndex,CONST.对象_X),Char.GetData(charIndex,CONST.对象_Y));
							Char.JoinParty(MonsIndex, charIndex, true);
							Battle.JoinBattle(charIndex, MonsIndex);
						else
						end
					else
					end
				end
				--開場玩家隊長召喚
				Battle.ActionSelect(charIndex, CONST.BATTLE_COM.BATTLE_COM_COPY, 0, 26306);		--羊頭狗肉
				--Battle.ActionSelect(charIndex, CONST.BATTLE_COM.BATTLE_COM_DETECTENEMY, 10, 10701);		--偵查
			elseif (actionNum==2) then
				--開場玩家隊長防禦
				Battle.ActionSelect(charIndex, CONST.BATTLE_COM.BATTLE_COM_GUARD, -1, -1);
			end
		end
	elseif Char.IsPet(charIndex) then
		--開場寵物防禦
		Battle.ActionSelect(charIndex, CONST.BATTLE_COM.BATTLE_COM_GUARD, -1, -1);
	end
end
--登入事件
function Module:onLoginEvent(charIndex)
	local floor = Char.GetData(charIndex, CONST.对象_地图);
	if (floor==100) then	-- 只要在地圖 100，強制開啟自動戰鬥
		Char.SetData(charIndex, CONST.对象_自动战斗开关, 1);
		NLG.SystemMessage(charIndex, "[系統] 登入檢查：您位於特殊區域，已自動開啟自動戰鬥。");
	else
		-- 不在該地圖，則確保關閉（或是維持現狀，看你的設計需求
		Char.SetData(charIndex, CONST.对象_自动战斗开关, 0);
	end
	return 0;
end
--偷襲事件
function Module:onBattleSurpriseEvent(battleIndex, result)
	local player = Battle.GetPlayer(battleIndex, 0);
	if (player>=0) then
		local floor = Char.GetData(player, CONST.对象_地图);
		if (floor==100) then	--地圖檢查(只在指定地圖生效)
			Char.DischargeParty(player);
			Char.SetData(player, CONST.对象_自动战斗开关, 1);
			if (Char.GetData(player,CONST.对象_队聊开关) == 1) then
				-- 只要在地圖100必定偷襲且開場第一回強制開啟自動戰鬥
				NLG.SystemMessage(player, "[系統]位於特殊區域首回必定偷襲。");
				NLG.SystemMessage(player, "[系統]位於特殊區域首回開啟自動戰鬥無法攻擊。");
			end
			return 1;	--偷袭形式 0不偷袭，1偷袭，2被偷袭
		end
	end
	return result;
end
--回合前事件
function Module:onBeforeBattleTurnCallback(battleIndex)
	local player = Battle.GetPlayIndex(battleIndex,0);
	local battleturn = Battle.GetTurn(battleIndex);
	local floor = Char.GetData(player, CONST.对象_地图);
	if (floor==100 and battleturn==0) then
		local cdk = Char.GetData(player, CONST.对象_CDK);
		if (tbl_MonsIndex[cdk] == nil) then
			tbl_MonsIndex[cdk] = {}
		else
			for k,v in pairs(tbl_MonsIndex[cdk]) do
				Char.LeaveParty(v);
				Char.DelDummy(v);
			end
			tbl_MonsIndex[cdk] = {}
		end
	elseif (battleturn>=1) then
		-- 不在該地圖則關閉或非開場時關閉
		Char.SetData(player, CONST.对象_自动战斗开关, 0);
	end
	for i=0,9 do
		local ai_index = Battle.GetPlayer(battleIndex,i);
		if ai_index >= 0 then
			if Char.IsDummy(ai_index) and Battle.IsWaitingCommand(ai_index)== 1 then
				local cg1 = Char.GetData(ai_index, CONST.对象_最大血);
				local cg2 = Char.GetData(ai_index, CONST.对象_最大魔);
				local cg3 = Char.GetData(ai_index, CONST.对象_攻击力);
				local cg4 = Char.GetData(ai_index, CONST.对象_防御力);
				local cg5 = Char.GetData(ai_index, CONST.对象_敏捷);
				local cg6 = Char.GetData(ai_index, CONST.对象_精神);
				local cg7 = Char.GetData(ai_index, CONST.对象_回复);
				print(cg1,cg2,cg3,cg4,cg5);

				local AIType = Char.GetData(ai_index,CONST.对象_职阶);	--AI模式
				local techId = Char.GetData(ai_index,CONST.对象_金币);	--施放tech編號
				Battle.ActionSelect(ai_index, CONST.BATTLE_COM.BATTLE_COM_ATTACK,math.random(10,19), techId);
				local petindex = Char.GetPet(ai_index,0);
				local 出战宠物slot = Char.GetData(ai_index,CONST.对象_战宠);
				if (petindex < 0 or 出战宠物slot == -1) then
					Battle.ActionSelect(ai_index, CONST.BATTLE_COM.BATTLE_COM_ATTACK,math.random(10,19), techId);
				end
				NLG.UpChar(ai_index);
			end
		end
	end
end
--回合後事件
function Module:onAfterBattleTurnCallback(battleIndex)
	local player = Battle.GetPlayIndex(battleIndex,0);
	local battleturn = Battle.GetTurn(battleIndex);
	local floor = Char.GetData(player, CONST.对象_地图);
	if (floor==100 and battleturn>=0) then
		Char.SetData(player, CONST.对象_自动战斗开关, 0);
	end
end
--戰鬥結束事件
function Module:onBattleOverCallback(battleIndex)
	local player = Battle.GetPlayer(battleIndex, 0);
	if (player>=0) then
		local floor = Char.GetData(player, CONST.对象_地图);
		if (floor==100) then	--地圖檢查(只在指定地圖生效)
			Char.DischargeParty(player);
			if (Char.GetData(player,CONST.对象_队聊开关) == 1) then
				NLG.SystemMessage(player, "[系統]位於特殊區域戰鬥結束即解散隊伍。");
			end
		end
	end
	return 0;
end

function CheckInTable(_idTab, _idVar) ---循环函数
	for k,v in pairs(_idTab) do
		if v==_idVar then
			return true
		end
	end
	return false
end

function Module:onUnload()
  self:logInfo('unload')
end

return Module;
