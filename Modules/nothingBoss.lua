---模块类
local Module = ModuleBase:createModule('nothingBoss')

local startImage = 108304;      --外面定點形象
local transImage = 108331;      --戰鬥變身形象
local executeEnemy = 406092;      --執行動作的Enemy編號

local EnemySet = {}
local BaseLevelSet = {}
local Pos = {}
local FTime = os.time()
local Setting = 0;
--队列解释
--     五(4)	三(2)	一(0)	二(1)	四(3)
--     十(9)	八(7)	六(5)	七(6)	九(8)
------------对战NPC设置------------
EnemySet[1] = {0, 406092, 406092, 0, 0, 406092, 0, 0, 406092, 406092}--0代表没有怪
BaseLevelSet[1] = {0, 300, 300, 0, 0, 300, 0, 0, 300, 300}
Pos[1] = {"十二席",EnemySet[1],BaseLevelSet[1]}
------------------------------------------------------
--背景设置
local Pts= 70206;                                    --真女神苹果
local NothingBoss = {
      { weekday=1, weekdayItem=70241, lordName="十二席", lordImage=101137 , waitingArea={map=1000,X=229,Y=112}, onfieldArea={map=25013,X=35,Y=15},
        rewardsItem={71041,71037,71038}, rewardsItem_count=1, prizeItem={70202,70203,70204,70205,70206,72000}, prizeItem_count=1},
}
tbl_duel_user = {};			--当前场次玩家的列表
tbl_win_user = {};
nothingBossBattle = {}
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
    NothingBossNPC = self:NPC_createNormal('沒事強敵', startImage, { map = 1000, x = 229, y = 112, direction = 5, mapType = 0 })
    self:NPC_regWindowTalkedEvent(NothingBossNPC, function(npc, player, _seqno, _select, _data)
	local cdk = Char.GetData(player,CONST.对象_CDK);
	local seqno = tonumber(_seqno)
	local select = tonumber(_select)
	local data = tonumber(_data)
    end)
    self:NPC_regTalkedEvent(NothingBossNPC, function(npc, player)
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
	for k,v in pairs(NothingBoss) do
		if ( 1==v.weekday ) then
			table.insert(tbl_duel_user,player);
			boss_round_start(player, boss_round_callback);

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
------------------------------------------------
-------功能设置
function boss_round_start(player, callback)

	tbl_win_user = {};
	tbl_duel_user = {};
	table.insert(tbl_duel_user,player);

	--开始战斗
	tbl_UpIndex = {}
	battleindex = {}

	for k,v in pairs(NothingBoss) do
		if ( 1==v.weekday ) then
			local battleindex = Battle.PVE( player, player, nil, Pos[1][2], Pos[1][3], nil)
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
			if ( 1==v.weekday ) then
				local rand = NLG.Rand(1,#v.rewardsItem);
				Char.GiveItem(player, v.rewardsItem[rand], v.rewardsItem_count);
				NLG.SystemMessage(-1,"恭喜玩家: "..Char.GetData(player,CONST.对象_名字).." 討伐成功"..v.lordName.."。");
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
						if ( 1==v.weekday ) then
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
			NLG.SystemMessage(-1,"[系統]世界強敵血量超激增.總共有"..playerCount.."名玩家x5萬的血量！");
		end
	end)
	for i = 10, 19 do
		local enemy = Battle.GetPlayer(battleIndex, i);
		local HP = playerCount * 50000;
		table.forEach(nothingBossBattle, function(e)
			if enemy>=0 and e==battleIndex  then
				if Char.GetData(enemy, CONST.对象_ENEMY_ID)==900008 or Char.GetData(enemy, CONST.对象_ENEMY_ID)==executeEnemy then
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
			if Char.GetData(enemy, CONST.对象_ENEMY_ID)==900008 or Char.GetData(enemy, CONST.对象_ENEMY_ID)==executeEnemy  then
				Char.SetData(enemy, CONST.CHAR_最大血, 1000000);     --血量上限100万
				Char.SetData(enemy, CONST.CHAR_血, HP);
			end
		elseif Round>0 and enemy>=0 and e==battleIndex  then
			if Char.GetData(enemy, CONST.对象_ENEMY_ID)==900008 or Char.GetData(enemy, CONST.对象_ENEMY_ID)==executeEnemy  then
				local Hp_10 = Char.GetData(enemy, CONST.CHAR_最大血); 
				local Hp_5 = Char.GetData(enemy, CONST.CHAR_血);
				local Hp05 = Hp_5/Hp_10;

				Char.SetData(enemy, CONST.CHAR_最大血, 1000000);     --血量上限100万
				Char.SetData(enemy, CONST.CHAR_血, Hp_5);
				if Hp05<=0.5 then
					Char.SetData(enemy, CONST.CHAR_形象, transImage);
					Char.SetData(enemy, CONST.CHAR_攻击力, 10000);
					Char.SetData(enemy, CONST.CHAR_防御力, 666);
					Char.SetData(enemy, CONST.CHAR_敏捷, 10000);
					Char.SetData(enemy, CONST.CHAR_精神, 10000);
					Char.SetData(enemy, CONST.CHAR_回复, 66);
					Char.SetData(enemy, CONST.CHAR_必杀, 100);
					Char.SetData(enemy, CONST.CHAR_闪躲, 100);
					Char.SetData(enemy, CONST.CHAR_命中, 100);
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
			if Char.GetData(enemy, CONST.对象_ENEMY_ID)==900008 or Char.GetData(enemy, CONST.对象_ENEMY_ID)==executeEnemy  then
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
            if Char.GetData(enemy, CONST.对象_ENEMY_ID)==900008 or Char.GetData(enemy, CONST.对象_ENEMY_ID)==executeEnemy then
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
               if Char.GetData(aIndex, CONST.对象_ENEMY_ID)==executeEnemy then
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
      if Char.IsEnemy(charIndex) and Char.GetData(charIndex, CONST.CHAR_ENEMY_ID) == executeEnemy and Char.IsPlayer(defCharIndex) then
          if (math.fmod(Round, 3)==0 and math.random(1, 100)>=85) then
              local slot = Char.GetEmptyItemSlot(defCharIndex);
              local itemIndex, wslot = Char.GetWeapon(defCharIndex);
              if itemIndex >= 0 then
                  NLG.SystemMessage(defCharIndex,"[系統]"..Char.GetData(defCharIndex, CONST.CHAR_名字).."武器被卸下了！");
                  if slot < 0 then
                            damage = math.floor(damage * 1.5);
                  else
                            Char.MoveItem(defCharIndex, wslot, slot, -1);
                            NLG.UpChar(defCharIndex);
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