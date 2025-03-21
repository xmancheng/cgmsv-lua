---模块类
local Module = ModuleBase:createModule('mazeBoss5')

local EnemySet = {}
local BaseLevelSet = {}
local Pos = {}
--local FTime = os.time()
--local Setting = 0;
--队列解释
--     五(4)	三(2)	一(0)	二(1)	四(3)
--     十(9)	八(7)	六(5)	七(6)	九(8)
------------对战NPC设置------------
local BossEnemyId = 406188;		--暴走模式设定对象
EnemySet[1] = {406188, 406187, 406187, 406186, 406186, 406186, 0, 0, 406186, 406186}    --0代表没有怪
BaseLevelSet[1] = {140, 130, 130, 130, 130, 130, 0, 0, 130, 130}
Pos[1] = {"克羅諾斯",EnemySet[1],BaseLevelSet[1]}
------------------------------------------------
--背景设置
--local Switch = 0;					--组队人数限制开关1开0关
--local Rank = 0;						--初始化难度分类
--local BossMap= {60003,40,9}			-- 战斗场景Floor,X,Y
--local OutMap= {1000,242,88}			-- 失败传送Floor,X,Y
local LeaveMap= {1000,242,88}		-- 离开传送Floor,X,Y
local BossKey= {70195}				-- 普通(可有可无)
local Pts= 70058;					-- 魔族核心
local BossRoom = {
      { key=1, keyItem=70195, keyItem_count=1, bossRank=3, limit=5, posNum_L=3, posNum_R=4,
          win={warpWMap=1000, warpWX=242, warpWY=88, getItem = 70075, getItem_count = 50},
          lordName="克羅諾斯",
       },    -- 普通(2)
}
local tbl_duel_user = {};			--当前场次玩家的列表
local tbl_win_user = {};
------------------------------------------------
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BattleStartEvent', Func.bind(self.OnbattleStartEventCallback, self))
  self:regCallback('BeforeBattleTurnEvent', Func.bind(self.OnBeforeBattleTurnCommand, self))
  self:regCallback('AfterBattleTurnEvent', Func.bind(self.OnAfterBattleTurnCommand, self))
  self:regCallback('EnemyCommandEvent', Func.bind(self.OnEnemyCommandCallBack, self))
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
  self:regCallback('BattleInjuryEvent', Func.bind(self.OnBattleInjuryCallBack, self))
  local Lord5Npc = self:NPC_createNormal('克羅諾斯·分體', 130084, { map = 7904, x = 93, y = 75, direction = 5, mapType = 0 })
  Char.SetData(Lord5Npc,CONST.对象_ENEMY_PetFlg+2,0)--可穿透体
  self:regCallback('LoopEvent', Func.bind(self.AutoLord_LoopEvent,self))
  self:NPC_regWindowTalkedEvent(Lord5Npc, function(npc, player, _seqno, _select, _data)
	local cdk = Char.GetData(player,CONST.对象_CDK);
	local seqno = tonumber(_seqno)
	local select = tonumber(_select)
	local data = tonumber(_data)
	local json = Field.Get(player, 'WorldDate');
		local ret, WorldDate = nil, nil;
		if json then
			ret, WorldDate = pcall(JSON.decode, json)
		else
			return
		end
	if seqno == 1 then
		if select == CONST.按钮_否 then
			return;
		elseif select == CONST.按钮_下一页 then
				local msg = "\\n克羅諾斯·分體：\\n\\n"
					.."　每一個選擇將決定裂隙的命运也將改變你的未來\\n"
					.."　而當龍魂碎片集齊的那一刻！\\n"
					.."　真正的命运審判將會降臨！\\n"
					.."　克羅諾斯將甦醒，歷史的齒輪將開始轉動！\\n"
					.."　世界的結局……\\n";
				NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.按钮_是否, 11, msg);
		end

	end
	------------------------------------------------------------
	if seqno == 11 then
		if select == CONST.按钮_否 then
			return;
		elseif select == CONST.按钮_是 then
			local cdk = Char.GetData(player,CONST.对象_CDK);
			SQL.Run("update lua_hook_worldboss set LordEnd5= '1' where CdKey='"..cdk.."'")
			NLG.UpChar(player);
			local PartyNum = Char.PartyNum(player);
			if (PartyNum>1) then
				for Slot=1,4 do
					local TeamPlayer = Char.GetPartyMember(player,Slot);
					if Char.IsDummy(TeamPlayer)==false then
						local cdk = Char.GetData(TeamPlayer,CONST.对象_CDK);
						--SQL.Run("INSERT INTO lua_hook_worldboss (Name,CdKey) SELECT Name,CdKey FROM tbl_character WHERE NOT EXISTS ( SELECT Name FROM lua_hook_worldboss WHERE tbl_character.CdKey=lua_hook_worldboss.CdKey)");
						SQL.Run("update lua_hook_worldboss set LordEnd5= '1' where CdKey='"..cdk.."'")
						NLG.UpChar(TeamPlayer);
					end
				end
			end
			NLG.SystemMessage(player,"[系統]開啟時空迴廊，你的選擇影響著世界走向。");
		end

	end
  end)
  self:NPC_regTalkedEvent(Lord5Npc, function(npc, player)
	if (NLG.CanTalk(npc, player) == true) then
		local msg = "\\n克羅諾斯·分體：\\n\\n"
				.."　遠古的四大神獸，在時之裂隙的四方沉睡\\n"
				.."　它們的力量是克羅諾斯遺留下來的最後防線。\\n"
				.."　你必須決定是以戰勝的方式奪取它們的力量？\\n"
				.."　還是以信念與意志獲得它們的認可？\\n";

		NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.按钮_下一页, 1, msg);
	end
	return
  end)


  --[[local Leave1Npc = self:NPC_createNormal('逃離沙漏', 235179, { map = 60003, x = 41, y = 9, direction = 6, mapType = 0 })
  self:NPC_regWindowTalkedEvent(Leave1Npc, function(npc, player, _seqno, _select, _data)
  end)
  self:NPC_regTalkedEvent(Leave1Npc, function(npc, player)
	if (NLG.CanTalk(npc, player) == true) then
		if (Char.PartyNum(player)==-1) then
			if (Char.ItemNum(player, BossKey[1]) > 0) then
				local slot = Char.FindItemId(player, BossKey[1]);
				local item_indexA = Char.GetItemIndex(player,slot);
				Char.DelItem(player, BossKey[1], 1);
				Char.GiveItem(player, 70206, 1);
				Char.Warp(player,0,LeaveMap[1],LeaveMap[2],LeaveMap[3]);
				NLG.SystemMessage(player,"可惜敗下陣，明天再來挑戰魔物領主！");
			else
				Char.GiveItem(player, 70206, 1);
				Char.Warp(player,0,LeaveMap[1],LeaveMap[2],LeaveMap[3]);
				NLG.SystemMessage(player,"可惜敗下陣，明天再來挑戰魔物領主！");
			end
		else
			for k,v in pairs(BossRoom) do
			if (Char.ItemNum(player, v.keyItem) > 0) then
				local slot = Char.FindItemId(player, v.keyItem);
				local item_indexA = Char.GetItemIndex(player,slot);
				Char.DelItem(player, v.keyItem, v.keyItem_count);
				Char.GiveItem(player, 70206, 5);
				Char.Warp(player,0,LeaveMap[1],LeaveMap[2],LeaveMap[3]);
			end
			end
		end
	end
        return
  end)
  ]]

end
------------------------------------------------
-------功能设置
--战斗前全恢复
function Char.HealAll(player)
	Char.SetData(player,CONST.对象_血, Char.GetData(player,CONST.对象_最大血));
	Char.SetData(player,CONST.对象_魔, Char.GetData(player,CONST.对象_最大魔));
	Char.SetData(player, CONST.对象_受伤, 0);
	Char.SetData(player, CONST.对象_掉魂, 0);
	NLG.UpdateParty(player);
	NLG.UpChar(player);
	for petSlot  = 0,4 do
		local petIndex = Char.GetPet(player,petSlot);
		if petIndex >= 0 then
			local maxLp = Char.GetData(petIndex, CONST.对象_最大血);
			local maxFp = Char.GetData(petIndex, CONST.对象_最大魔);
			Char.SetData(petIndex, CONST.对象_血, maxLp);
			Char.SetData(petIndex, CONST.对象_魔, maxFp);
			Char.SetData(petIndex, CONST.对象_受伤, 0);
			Pet.UpPet(player, petIndex);
		end
	end
	local PartyNum = Char.PartyNum(player);
	if (PartyNum>1) then
		for Slot=1,4 do
		local TeamPlayer = Char.GetPartyMember(player,Slot);
		if (TeamPlayer>0) then
			Char.SetData(TeamPlayer,CONST.对象_血, Char.GetData(TeamPlayer,CONST.对象_最大血));
			Char.SetData(TeamPlayer,CONST.对象_魔, Char.GetData(TeamPlayer,CONST.对象_最大魔));
			Char.SetData(TeamPlayer, CONST.对象_受伤, 0);
			Char.SetData(TeamPlayer, CONST.对象_掉魂, 0);
			NLG.UpdateParty(TeamPlayer);
			NLG.UpChar(TeamPlayer);
			for petSlot  = 0,4 do
				local petIndex = Char.GetPet(TeamPlayer,petSlot);
				if petIndex >= 0 then
					local maxLp = Char.GetData(petIndex, CONST.对象_最大血);
					local maxFp = Char.GetData(petIndex, CONST.对象_最大魔);
					Char.SetData(petIndex, CONST.对象_血, maxLp);
					Char.SetData(petIndex, CONST.对象_魔, maxFp);
					Char.SetData(petIndex, CONST.对象_受伤, 0);
					Pet.UpPet(TeamPlayer, petIndex);
				end
			end
		end
		end
	end
end



function def_round_start(player, callback)

	--MapUser = NLG.GetMapPlayer(0,BossMap[1]);
	tbl_win_user = {};
	tbl_duel_user = {};
	table.insert(tbl_duel_user,player);

	--开始战斗
	tbl_UpIndex = {}
	battleindex = {}


	Char.HealAll(player);
	NLG.SystemMessage(-1,"" ..BossRoom[1].lordName.. "挑戰者: " ..Char.GetData(player,CONST.对象_名字));
	local battleindex = Battle.PVE( player, player, nil, Pos[1][2], Pos[1][3], nil)
	Battle.SetWinEvent("./lua/Modules/mazeBoss5.lua", "def_round_wincallback", battleindex);

end

function def_round_wincallback(battleindex, player)

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
	if ( Char.GetData(w1, CONST.对象_类型) == CONST.对象类型_人 ) then
		local ww = w1;
		table.insert(tbl_win_user, ww);
	elseif ( Char.GetData(w2, CONST.对象_类型) >= CONST.对象类型_人 ) then
		local ww = w2;
		table.insert(tbl_win_user, ww);
	else
		local ww = nil;
	end

	--local MapUser = NLG.GetMapPlayer(0, BossMap[1]);
	local player = tbl_win_user[1];

	--FTime = os.time()
	--wincallbackfunc(tbl_win_user);
	Char.GiveItem(player, 70258, 1);
	NLG.SystemMessage(-1,"恭喜玩家:"..Char.GetData(player,CONST.对象_名字).." 討伐成功"..BossRoom[1].lordName.."。");

	local cdk = Char.GetData(player,CONST.对象_CDK);
	SQL.Run("update lua_hook_worldboss set LordEnd5= '1' where CdKey='"..cdk.."'")
	NLG.UpChar(player);
	local PartyNum = Char.PartyNum(player);
	if (PartyNum>1) then
		for Slot=1,4 do
			local TeamPlayer = Char.GetPartyMember(player,Slot);
			if Char.IsDummy(TeamPlayer)==false then
				local cdk = Char.GetData(TeamPlayer,CONST.对象_CDK);
				--SQL.Run("INSERT INTO lua_hook_worldboss (Name,CdKey) SELECT Name,CdKey FROM tbl_character WHERE NOT EXISTS ( SELECT Name FROM lua_hook_worldboss WHERE tbl_character.CdKey=lua_hook_worldboss.CdKey)");
				SQL.Run("update lua_hook_worldboss set LordEnd5= '1' where CdKey='"..cdk.."'")
				NLG.UpChar(TeamPlayer);
			end
		end
	end
	Char.Warp(player,0, BossRoom[1].win.warpWMap, BossRoom[1].win.warpWX, BossRoom[1].win.warpWY);
	tbl_win_user = {};

	Battle.UnsetWinEvent(battleindex);
end

------------------------------------------------
--受伤设置
function Module:OnBattleInjuryCallBack(fIndex, aIndex, battleIndex, inject)
      --self:logDebug('OnBattleInjuryCallBack', fIndex, aIndex, battleIndex, inject)
      local Round = Battle.GetTurn(battleIndex);
      --print(Round)
      local Target_FloorId = Char.GetData(fIndex, CONST.对象_地图)
      local defHpE = Char.GetData(fIndex,CONST.对象_血);
      if defHpE >=100 and Target_FloorId==7900  then
                 inject = inject*0;
      elseif  Target_FloorId==7900  then
                 inject = inject;
      end
  return inject;
end
--超级领主设置
function Module:OnbattleStartEventCallback(battleIndex)
	local Round = Battle.GetTurn(battleIndex);
	local leader0 = Battle.GetPlayer(battleIndex, 0);
	local leaderpet0 = Battle.GetPlayer(battleIndex, 5);
	local player = leader0
	local leaderpet = leaderpet0
	if Char.GetData(player, CONST.对象_类型) == CONST.对象类型_人 then
		player = leader0
	else
		player = leaderpet
	end
	local cdk = Char.GetData(player,CONST.对象_CDK) or nil;

	--[[local ret = SQL.Run("select Name,WorldLord5 from lua_hook_worldboss where CdKey='"..cdk.."'");
	if(type(ret)=="table" and ret["0_1"]~=nil)then
		LordHP5=tonumber(ret["0_1"]);
	end]]

	local LordHP5 = tonumber(SQL.Run("select WorldLord5 from lua_hook_worldboss where CdKey='"..cdk.."'")["0_0"])
	for i = 10, 19 do
		local enemy = Battle.GetPlayer(battleIndex, i);
		local HP = LordHP5;
		if (HP<=1000) then
			HP = LordHP5*100;
		end
		if enemy>=0 and Char.GetData(enemy, CONST.对象_ENEMY_ID)==BossEnemyId  then
			Char.SetData(enemy, CONST.对象_最大血, 1000000);
			Char.SetData(enemy, CONST.对象_血, HP);
		end
	end
end
function Module:OnBeforeBattleTurnCommand(battleIndex)
	local Round = Battle.GetTurn(battleIndex);
	local leader0 = Battle.GetPlayer(battleIndex, 0);
	local leaderpet0 = Battle.GetPlayer(battleIndex, 5);
	local player = leader0
	local leaderpet = leaderpet0
	if Char.GetData(player, CONST.对象_类型) == CONST.对象类型_人 then
		player = leader0
	else
		player = leaderpet
	end
	if (player>=0) then
		cdk = Char.GetData(player,CONST.对象_CDK) or nil;
	end

	--[[local ret = SQL.Run("select Name,WorldLord5 from lua_hook_worldboss where CdKey='"..cdk.."'");
	if(type(ret)=="table" and ret["0_1"]~=nil)then
		LordHP5=tonumber(ret["0_1"]);
	end]]
	local LordHP5 = tonumber(SQL.Run("select WorldLord5 from lua_hook_worldboss where CdKey='"..cdk.."'")["0_0"])
	--print(LordHP5)
	for i = 10, 19 do
		local enemy = Battle.GetPlayer(battleIndex, i);
		local HP = LordHP5;
		if (HP<=1000 and Round<1) then
			HP = HP*200;
		end
		if Round==0 and enemy>=0 and Char.GetData(enemy, CONST.对象_ENEMY_ID)==BossEnemyId  then
			Char.SetData(enemy, CONST.对象_最大血, 1000000);     --血量上限100万
			Char.SetData(enemy, CONST.对象_血, HP);
		elseif Round>0 and enemy>=0 and Char.GetData(enemy, CONST.对象_ENEMY_ID)==BossEnemyId  then
			Char.SetData(enemy, CONST.对象_最大血, 1000000);     --血量上限100万
			Char.SetData(enemy, CONST.对象_血, HP);
			if Round>=5 then
				--Char.SetData(enemy, CONST.对象_攻击力, 10000);
				--Char.SetData(enemy, CONST.对象_精神, 10000);
				--Char.SetData(enemy, CONST.对象_命中, 100);
				--Char.SetData(enemy, CONST.对象_闪躲, 100);
				--Char.SetData(enemy, CONST.对象_反击, 70);
			end
			if Round>=4 and Round<=8 then
				Char.SetData(enemy, CONST.对象_ENEMY_HeadGraNo,114260);
			elseif Round>=9 then
				Char.SetData(enemy, CONST.对象_ENEMY_HeadGraNo,114261);
			end
		end
	end
end
function Module:OnAfterBattleTurnCommand(battleIndex)
	local Round = Battle.GetTurn(battleIndex);
	local leader0 = Battle.GetPlayer(battleIndex, 0);
	local leaderpet0 = Battle.GetPlayer(battleIndex, 5);
	local player = leader0
	local leaderpet = leaderpet0
	if Char.GetData(player, CONST.对象_类型) == CONST.对象类型_人 then
		player = leader0
	else
		player = leaderpet
	end
	local cdk = Char.GetData(player,CONST.对象_CDK) or nil;

	for i = 10, 19 do
		local enemy = Battle.GetPlayer(battleIndex, i);
		if Round>=0 and enemy>=0 and Char.GetData(enemy, CONST.对象_ENEMY_ID)==BossEnemyId  then
			local HP = Char.GetData(enemy,CONST.对象_血);
			Char.SetData(enemy, CONST.对象_最大血, 1000000);
			Char.SetData(enemy, CONST.对象_血, HP);
			NLG.SystemMessage(player,"[系統]魔物領主目前剩餘血量"..HP.."！");
			NLG.UpChar(enemy);
			--Lord血量写入库
			if (cdk~=nil) then
				--SQL.Run("INSERT INTO lua_hook_worldboss (Name,CdKey) SELECT Name,CdKey FROM tbl_character WHERE NOT EXISTS ( SELECT Name FROM lua_hook_worldboss WHERE CdKey='"..cdk.."')");
				SQL.Run("update lua_hook_worldboss set WorldLord5= '"..HP.."' where CdKey='"..cdk.."'")
				NLG.UpChar(player);
			end
		end
	end
end
--暴走模式技能施放
function Module:OnEnemyCommandCallBack(battleIndex, side, slot, action)
	local Round = Battle.GetTurn(battleIndex);
	for i = 10, 19 do
		local enemy = Battle.GetPlayer(battleIndex, i);
		if Round>=5 and Round<=9 and enemy>= 0 and Char.GetData(enemy, CONST.对象_ENEMY_ID)==BossEnemyId  then
			SetCom(enemy, action, CONST.BATTLE_COM.BATTLE_COM_M_DEATH, 40, 8609);
		elseif Round>=10 and enemy>= 0 and Char.GetData(enemy, CONST.对象_ENEMY_ID)==BossEnemyId  then
			SetCom(enemy, action, CONST.BATTLE_COM.BATTLE_COM_M_DEATH, 40, 8659);
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

function Module:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
	local Round = Battle.GetTurn(battleIndex);
	if (Round<1 and Char.GetData(defCharIndex, CONST.对象_ENEMY_ID)==BossEnemyId and flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge)  then
		local defHpE = Char.GetData(defCharIndex,CONST.对象_血);
		if (damage>=defHpE-1) then
			Char.SetData(defCharIndex, CONST.对象_血, defHpE+damage*1);
			NLG.UpChar(defCharIndex);
			NLG.SystemMessage(charIndex,"[系統]克羅諾斯目前無法受到傷害！");
			damage = damage*0;
		else
			damage = damage*0;
		end
	end
	return damage;
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;