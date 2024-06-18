---模块类
local Module = ModuleBase:createModule('nothingBoss')

local EnemySet = {}
local BaseLevelSet = {}
local Pos = {}
local FTime = os.time()
local Setting = 0;
--队列解释
--     五(4)	三(2)	一(0)	二(1)	四(3)
--     十(9)	八(7)	六(5)	七(6)	九(8)
------------对战NPC设置------------
EnemySet[1] = {900030, 0, 0, 900031, 900031, 900031, 900031, 900031, 0, 0}--0代表没有怪
BaseLevelSet[1] = {250, 0, 0, 250, 250, 250, 250, 250, 0, 0}
Pos[1] = {"十二席",EnemySet[1],BaseLevelSet[1]}
EnemySet[2] = {900033, 0, 0, 900034, 900034, 900034, 900034, 900034, 0, 0}--0代表没有怪
BaseLevelSet[2] = {250, 0, 0, 250, 250, 250, 250, 250, 0, 0}
Pos[2] = {"十一席",EnemySet[2],BaseLevelSet[2]}
EnemySet[3] = {900036, 0, 0, 900037, 900037, 900037, 900037, 900037, 0, 0}--0代表没有怪
BaseLevelSet[3] = {250, 0, 0, 250, 250, 250, 250, 250, 0, 0}
Pos[3] = {"十席",EnemySet[3],BaseLevelSet[3]}
EnemySet[4] = {900039, 0, 0, 900040, 900040, 900040, 900040, 900040, 0, 0}--0代表没有怪
BaseLevelSet[4] = {250, 0, 0, 250, 250, 250, 250, 250, 0, 0}
Pos[4] = {"九席",EnemySet[4],BaseLevelSet[4]}
EnemySet[5] = {900042, 0, 0, 900043, 900043, 900043, 900043, 900043, 0, 0}--0代表没有怪
BaseLevelSet[5] = {250, 0, 0, 250, 250, 250, 250, 250, 0, 0}
Pos[5] = {"八席",EnemySet[5],BaseLevelSet[5]}
EnemySet[6] = {900045, 0, 0, 900046, 900046, 900046, 900046, 900046, 0, 0}--0代表没有怪
BaseLevelSet[6] = {250, 0, 0, 250, 250, 250, 250, 250, 0, 0}
Pos[6] = {"七席",EnemySet[6],BaseLevelSet[6]}
------------------------------------------------------
--背景设置
local Pts= 70206;                                    --真女神苹果
local NothingBoss = {
      { lordNum=1, keyItem=70241, lordName="漆黑聖典第12席", startImage=105040, transImage = 107912, waitingArea={map=1000,X=233,Y=112}, warpArea={map=25013,X=35,Y=15},
        rewardsItem={71041,71037,71038}, rewardsItem_count=1, prizeItem={70202,70203,70204,70205,70206,72000}, prizeItem_count=1},
      { lordNum=2, keyItem=70242, lordName="漆黑聖典第11席", startImage=105272, transImage = 110599, waitingArea={map=1000,X=231,Y=112}, warpArea={map=25013,X=35,Y=15},
        rewardsItem={71041,71037,71038}, rewardsItem_count=1, prizeItem={70202,70203,70204,70205,70206,72000}, prizeItem_count=1},
      { lordNum=3, keyItem=70243, lordName="漆黑聖典第10席", startImage=105112, transImage = 101922, waitingArea={map=1000,X=229,Y=112}, warpArea={map=25013,X=35,Y=15},
        rewardsItem={71041,71037,71038}, rewardsItem_count=1, prizeItem={70202,70203,70204,70205,70206,72000}, prizeItem_count=1},
      { lordNum=4, keyItem=70244, lordName="漆黑聖典第9席", startImage=105303, transImage = 107103, waitingArea={map=1000,X=227,Y=112}, warpArea={map=25013,X=35,Y=15},
        rewardsItem={71041,71037,71038}, rewardsItem_count=1, prizeItem={70202,70203,70204,70205,70206,72000}, prizeItem_count=1},
      { lordNum=5, keyItem=70245, lordName="漆黑聖典第8席", startImage=105091, transImage = 107904, waitingArea={map=1000,X=225,Y=112}, warpArea={map=25013,X=35,Y=15},
        rewardsItem={71041,71037,71038}, rewardsItem_count=1, prizeItem={70202,70203,70204,70205,70206,72000}, prizeItem_count=1},
      { lordNum=6, keyItem=70246, lordName="漆黑聖典第7席", startImage=105523, transImage = 104840, waitingArea={map=1000,X=223,Y=112}, warpArea={map=25013,X=35,Y=15},
        rewardsItem={71041,71037,71038}, rewardsItem_count=1, prizeItem={70202,70203,70204,70205,70206,72000}, prizeItem_count=1},
}
local tbl_duel_user = {};			--当前场次玩家的列表
local tbl_win_user = {};
local nothingBossBattle = {}
tbl_NothingBossNPCIndex = tbl_NothingBossNPCIndex or {}
------------------------------------------------
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BattleStartEvent', Func.bind(self.OnbattleStartEventCallback, self))
  --self:regCallback('BeforeBattleTurnEvent', Func.bind(self.OnBeforeBattleTurnCommand, self))
  self:regCallback('BeforeBattleTurnStartEvent', Func.bind(self.OnBeforeBattleTurnStartCommand, self))
  self:regCallback('AfterBattleTurnEvent', Func.bind(self.OnAfterBattleTurnCommand, self))
  self:regCallback('EnemyCommandEvent', Func.bind(self.OnEnemyCommandCallBack, self))
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
  self:regCallback('BattleDodgeRateEvent', Func.bind(self.OnBattleDodgeRateEvent, self))
  --self:regCallback('BattleOverEvent', Func.bind(self.battleOverEventCallback, self))
  for k,v in pairs(NothingBoss) do
   if tbl_NothingBossNPCIndex[k] == nil then
    local NothingBossNPC = self:NPC_createNormal(v.lordName, v.startImage, { map = v.waitingArea.map, x = v.waitingArea.X, y = v.waitingArea.Y, direction = 5, mapType = 0 })
    tbl_NothingBossNPCIndex[k] = NothingBossNPC
    self:NPC_regWindowTalkedEvent(tbl_NothingBossNPCIndex[k], function(npc, player, _seqno, _select, _data)
	local cdk = Char.GetData(player,CONST.对象_CDK);
	local seqno = tonumber(_seqno)
	local select = tonumber(_select)
	local data = tonumber(_data)
    end)
    self:NPC_regTalkedEvent(tbl_NothingBossNPCIndex[k], function(npc, player)
      if(NLG.CheckInFront(player, npc, 1)==false) then
          return ;
      end
      if (NLG.CanTalk(npc, player) == true) then
               --面向玩家
               local i;
               i = Char.GetData(player, CONST.对象_方向);
               if i >= 4 then 
                              i = i - 4;
               else
                              i = i + 4;		
               end
               Char.SetData(npc, CONST.对象_方向,i);
               NLG.UpChar(npc);
               --世界BOSS
	local playerName = Char.GetData(player,CONST.CHAR_名字);
	local partyname = playerName .. "－隊";
	local playerLv = Char.GetData(player,CONST.CHAR_等级);
	if playerLv<=100 then
		NLG.SystemMessage(player,"[系統]討伐建議隊長等級要100以上");
		return;
	end

	local Target_X = Char.GetData(npc, CONST.CHAR_X)  --地图x
	local Target_Y = Char.GetData(npc, CONST.CHAR_Y)  --地图y
	for k,v in pairs(NothingBoss) do
		if ( k==v.lordNum and Char.HaveItem(player, v.keyItem)>0 and Target_X==v.waitingArea.X and Target_Y==v.waitingArea.Y) then
			table.insert(tbl_duel_user,player);
			boss_round_start(player, boss_round_callback);

			--Char.DelItem(player, v.keyItem, 1);
                                                            local slot = Char.FindItemId(player, v.keyItem);
                                                            local item_indexA = Char.GetItemIndex(player,slot);
                                                            Item.SetData(item_indexA,CONST.道具_幸运,77);
                                                            Item.UpItem(player,slot);
			if (Char.EndEvent(player, 308) == 1) then
				local rand = NLG.Rand(1,#v.prizeItem);
				Char.GiveItem(player, v.prizeItem[rand], v.prizeItem_count);
			end
			local PartyNum = Char.PartyNum(player);
			if (PartyNum>1) then
				for Slot=1,4 do
					local TeamPlayer = Char.GetPartyMember(player,Slot);
					if Char.IsDummy(TeamPlayer)==false then
						if (Char.EndEvent(TeamPlayer, 308) == 1) then
							local rand = NLG.Rand(1,#v.prizeItem);
							Char.GiveItem(TeamPlayer, v.prizeItem[rand], v.prizeItem_count);
						end
					end
				end
			end
		end
	end
      end
      return
    end)
   end
  end

end
------------------------------------------------
-------功能设置
function boss_round_start(player, callback)

	local npc = tbl_duel_user[2];
	tbl_win_user = {};
	tbl_duel_user = {};
	table.insert(tbl_duel_user,player);

	--开始战斗
	tbl_UpIndex = {}
	battleindex = {}

	for k,v in pairs(NothingBoss) do
		if ( k==v.lordNum and Char.HaveItem(player, v.keyItem)>0 ) then
			local battleindex = Battle.PVE( player, player, nil, Pos[k][2], Pos[k][3], nil)
			Battle.SetWinEvent("./lua/Modules/nothingBoss.lua", "boss_round_callback", battleindex);
			nothingBossBattle={}
			table.insert(nothingBossBattle, battleindex);
		end
	end
end

function boss_round_callback(battleindex, player)

	local winside = Battle.GetWinSide(battleindex);
	local sideM = 0;

	--获取胜利方
	if (winside == 0) then
		sideM = 0;
	end
	if (winside == 1) then
		sideM = 10;
	end
	--获取胜利方的玩家指针，可能站在前方和后方
	local w1 = Battle.GetPlayIndex(battleindex, 0 + sideM);
	local w2 = Battle.GetPlayIndex(battleindex, 5 + sideM);
	local ww = nil;

	--把胜利玩家加入列表
	tbl_win_user = {}
	if ( Char.GetData(w1, %对象_类型%) >= %对象类型_人% ) then
		local ww = w1;
		table.insert(tbl_win_user, ww);
	elseif ( Char.GetData(w2, %对象_类型%) >= %对象类型_人% ) then
		local ww = w2;
		table.insert(tbl_win_user, ww);
	else
		local ww = nil;
	end

	local player = tbl_win_user[1];
	if (Char.EndEvent(player, 308) == 1) then
		for k,v in pairs(NothingBoss) do
			if ( k==v.lordNum and Char.HaveItem(player, v.keyItem)>0 ) then
                                                                        local slot = Char.FindItemId(player, v.keyItem);
                                                                        local item_indexA = Char.GetItemIndex(player,slot);
                                                                        local Rank = Item.GetData(item_indexA, CONST.道具_幸运);
                                                                        if (Rank==77) then
                                                                                Char.DelItem(player, v.keyItem, 1);
				local rand = NLG.Rand(1,#v.rewardsItem);
				Char.GiveItem(player, v.rewardsItem[rand], v.rewardsItem_count);
				NLG.SystemMessage(-1,"恭喜玩家: "..Char.GetData(player,CONST.对象_名字).." 討伐成功"..v.lordName.."。");
                                                                        end
			end
		end
	end
	local PartyNum = Char.PartyNum(player);
	if (PartyNum>1) then
		for Slot=1,4 do
			local TeamPlayer = Char.GetPartyMember(player,Slot);
			if Char.IsDummy(TeamPlayer)==false then
				if (Char.EndEvent(TeamPlayer, 308) == 1) then
					for k,v in pairs(NothingBoss) do
						if ( k==v.lordNum and Char.HaveItem(player, v.keyItem)>0 ) then
							local rand = NLG.Rand(1,#v.rewardsItem);
							Char.GiveItem(TeamPlayer, v.rewardsItem[rand], v.rewardsItem_count);
						end
					end
				end
			end
		end
	end
	Battle.UnsetWinEvent(battleindex);
	nothingBossBattle ={};
end

--超级领主设置
function Module:OnbattleStartEventCallback(battleIndex)

	local playerCount = #NLG.GetPlayer();
	table.forEach(nothingBossBattle, function(e)
		if  e==battleIndex  then
			NLG.SystemMessage(-1,"[系統]漆黑聖典血量超激增.總共有"..playerCount.."名玩家x5萬的血量！");
		end
	end)
	for i = 10, 19 do
		local enemy = Battle.GetPlayer(battleIndex, i);
		local HP = playerCount * 50000;
		table.forEach(nothingBossBattle, function(e)
			if enemy>=0 and e==battleIndex  then
				if (Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900030 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900033 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900036 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900039 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900042 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900045) then
					Char.SetData(enemy, CONST.CHAR_最大血, 1000000);
					Char.SetData(enemy, CONST.CHAR_血, HP);
					--NLG.SystemMessage(-1,"[系統]世界強敵血量超激增！");
				end
			end
		end)
	end
end
function Module:OnBeforeBattleTurnStartCommand(battleIndex)
	local Round = Battle.GetTurn(battleIndex);
	local playerCount = #NLG.GetPlayer() or 1;
	local HP = playerCount * 50000;
	for i = 10, 19 do
		local enemy = Battle.GetPlayer(battleIndex, i);
		table.forEach(nothingBossBattle, function(e)
		if Round==0 and enemy>=0 and e==battleIndex  then
			if (Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900030 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900033 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900036 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900039 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900042 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900045) then
				Char.SetData(enemy, CONST.CHAR_最大血, 1000000);     --血量上限100万
				Char.SetData(enemy, CONST.CHAR_血, HP);
			end
		elseif Round>0 and enemy>=0 and e==battleIndex  then
			if (Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900030 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900033 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900036 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900039 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900042 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900045) then
				local Hp_10 = Char.GetData(enemy, CONST.CHAR_最大血); 
				local Hp_5 = Char.GetData(enemy, CONST.CHAR_血);
				local Hp05 = Hp_5/Hp_10;

				Char.SetData(enemy, CONST.CHAR_最大血, 1000000);     --血量上限100万
				Char.SetData(enemy, CONST.CHAR_血, Hp_5);
				if Hp05<=0.5 then
					for k,v in pairs(NothingBoss) do
						if ( k==v.lordNum and Char.GetData(enemy, CONST.CHAR_形象)==v.startImage ) then
							Char.SetData(enemy, CONST.CHAR_形象, v.transImage);
							--Char.SetData(enemy, CONST.CHAR_可视, v.transImage);
							--Char.SetData(enemy, CONST.CHAR_原形, v.transImage);
							--Char.SetData(enemy, CONST.CHAR_原始图档, v.transImage);
							NLG.UpChar(enemy);
						end
					end
					Char.SetData(enemy, CONST.CHAR_攻击力, 10000);
					Char.SetData(enemy, CONST.CHAR_防御力, 666);
					Char.SetData(enemy, CONST.CHAR_敏捷, 666);
					Char.SetData(enemy, CONST.CHAR_精神, 10000);
					Char.SetData(enemy, CONST.CHAR_回复, 66);
					Char.SetData(enemy, CONST.CHAR_必杀, 70);
					Char.SetData(enemy, CONST.CHAR_闪躲, 70);
					Char.SetData(enemy, CONST.CHAR_命中, 70);
					Char.SetData(enemy, CONST.CHAR_反击, 70);
					--Char.SetData(enemy, CONST.对象_ENEMY_HeadGraNo,108511);
				end
			end
		end
		--NLG.SystemMessage(-1,"[系統]世界強敵血量超激增！");
		end)
	end
end
function Module:OnAfterBattleTurnCommand(battleIndex)
	local Round = Battle.GetTurn(battleIndex);
	local leader0 = Battle.GetPlayer(battleIndex, 0);
	local leaderpet0 = Battle.GetPlayer(battleIndex, 5);
	local player = leader0
	local leaderpet = leaderpet0
	if Char.GetData(player, CONST.CHAR_类型) == CONST.对象类型_人 then
		player = leader0
	else
		player = leaderpet
	end
	for i = 10, 19 do
		local enemy = Battle.GetPlayer(battleIndex, i);
		table.forEach(nothingBossBattle, function(e)
		if Round>=0 and enemy>=0 and e==battleIndex  then
			if (Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900030 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900033 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900036 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900039 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900042 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900045) then
				local HP = Char.GetData(enemy,CONST.CHAR_血);
				Char.SetData(enemy, CONST.CHAR_最大血, 1000000);
				Char.SetData(enemy, CONST.CHAR_血, HP);
				NLG.UpChar(enemy);
			end
		end
		end)
	end
end
--暴走模式技能施放
function Module:OnEnemyCommandCallBack(battleIndex, side, slot, action)
      local Round = Battle.GetTurn(battleIndex);
      for i = 10, 19 do
         local enemy = Battle.GetPlayer(battleIndex, i);
         if enemy>= 0 then
            if (Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900030 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900033 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900036 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900039 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900042 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900045) then
                table.forEach(nothingBossBattle, function(e)
                if Round==5 and e==battleIndex  then
                          --SetCom(enemy, action, CONST.BATTLE_COM.BATTLE_COM_M_DEATH, 40, 8607);
                          SetCom(enemy, action, CONST.BATTLE_COM.BATTLE_COM_P_PARAMETER, 0, 350);
                elseif Round==10 and e==battleIndex  then
                          --SetCom(enemy, action, CONST.BATTLE_COM.BATTLE_COM_M_DEATH, 40, 8609);
                          SetCom(enemy, action, CONST.BATTLE_COM.BATTLE_COM_P_PARAMETER, 0, 358);
                elseif Round>=15 and e==battleIndex  then
                          --SetCom(enemy, action, CONST.BATTLE_COM.BATTLE_COM_M_DEATH, 40, 8659);
                          SetCom(enemy, action, CONST.BATTLE_COM.BATTLE_COM_P_PARAMETER, 0, 359);
                end
                end)
            end
         end
      end
end
function SetCom(charIndex, action, com1, com2, com3)
  if action == 0 then
    Char.SetData(charIndex, CONST.CHAR_BattleCom1, com1)
    Char.SetData(charIndex, CONST.CHAR_BattleCom2, com2)
    Char.SetData(charIndex, CONST.CHAR_BattleCom3, com3)
  else
    Char.SetData(charIndex, CONST.CHAR_BattleCom1, com1)
    Char.SetData(charIndex, CONST.CHAR_BattleCom2, com2)
    Char.SetData(charIndex, CONST.CHAR_BattleCom3, com3)
  end
end

function Module:OnBattleDodgeRateEvent(battleIndex, aIndex, fIndex, rate)
         --self:logDebug('OnBattleDodgeRateCallBack', battleIndex, aIndex, fIndex, rate)
         if Char.IsPlayer(fIndex) and Char.IsEnemy(aIndex) then
               local battleIndex = Char.GetBattleIndex(aIndex);
               local Round = Battle.GetTurn(battleIndex);
               if (Char.GetData(aIndex, CONST.CHAR_ENEMY_ID)==900030 or Char.GetData(aIndex, CONST.CHAR_ENEMY_ID)==900033 or Char.GetData(aIndex, CONST.CHAR_ENEMY_ID)==900036 or Char.GetData(aIndex, CONST.CHAR_ENEMY_ID)==900039 or Char.GetData(aIndex, CONST.CHAR_ENEMY_ID)==900042 or Char.GetData(aIndex, CONST.CHAR_ENEMY_ID)==900045) then
                   if (Round==5 or Round==10 or Round>=15)  then
                       rate = 0;
                       return rate
                   end
               end
         end
         return rate
end

function Module:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
      local Round = Battle.GetTurn(battleIndex);
      if Char.IsEnemy(charIndex) and Char.IsPlayer(defCharIndex) then
        if (Char.GetData(charIndex, CONST.CHAR_ENEMY_ID)==900031 or Char.GetData(charIndex, CONST.CHAR_ENEMY_ID)==900034 or Char.GetData(charIndex, CONST.CHAR_ENEMY_ID)==900037 or Char.GetData(charIndex, CONST.CHAR_ENEMY_ID)==900040 or Char.GetData(charIndex, CONST.CHAR_ENEMY_ID)==900043 or Char.GetData(charIndex, CONST.CHAR_ENEMY_ID)==900046) then
          if (math.fmod(Round, 3)==0 and math.random(1, 100)>=85) then
              local slot = Char.GetEmptyItemSlot(defCharIndex);
              local itemIndex, wslot = Char.GetWeapon(defCharIndex);
              if itemIndex >= 0 then
                  NLG.SystemMessage(defCharIndex,"[系統]"..Char.GetData(defCharIndex, CONST.CHAR_名字).."武器被卸下了！");
                  if slot < 0 then
                            damage = math.floor(damage * 1.5);
                  else
                            Char.MoveItem(defCharIndex, wslot, slot, -1);
                            Char.SetData(defCharIndex, CONST.CHAR_BattleCom1, CONST.BATTLE_COM.BATTLE_COM_ATTACK);
                            Char.SetData(defCharIndex, CONST.CHAR_BattleCom2, 10);
                            Char.SetData(defCharIndex, CONST.CHAR_BattleCom3, -1);
                            NLG.UpChar(defCharIndex);
                  end
              end
          end
        end
        return damage;
      end
  return damage;
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
