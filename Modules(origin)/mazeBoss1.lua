---模块类
local Module = ModuleBase:createModule('mazeBoss1')

local EnemySet = {}
local BaseLevelSet = {}
local Pos = {}
--local FTime = os.time()
--local Setting = 0;
--队列解释
--     五(4)	三(2)	一(0)	二(1)	四(3)
--     十(9)	八(7)	六(5)	七(6)	九(8)
------------对战NPC设置------------
local BossEnemyId = 320134;		--暴走模式设定对象
EnemySet[1] = {0, 320124, 320124, 0, 0, 320134, 0, 0, 320124, 320124}    --0代表没有怪
BaseLevelSet[1] = {0, 105, 105, 0, 0, 110, 0, 0, 105, 105}
Pos[1] = {"迷霧森林之主",EnemySet[1],BaseLevelSet[1]}
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
          lordName="迷霧森林之主",
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
  local Lord1Npc = self:NPC_createNormal('守護石碑', 11394, { map = 7900, x = 17, y = 0, direction = 6, mapType = 0 })
  Char.SetData(Lord1Npc,CONST.对象_ENEMY_PetFlg+2,0)--可穿透体
  self:regCallback('LoopEvent', Func.bind(self.AutoLord_LoopEvent,self))
  self:NPC_regWindowTalkedEvent(Lord1Npc, function(npc, player, _seqno, _select, _data)
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
		if select == CONST.按钮_关闭 then
			return;
		elseif select == CONST.按钮_下一页 then  ----参加领主讨伐
			--[[local retEnd = SQL.Run("select Name,LordEnd1 from lua_hook_worldboss order by LordEnd1 desc ");
			if (type(retEnd)=="table" and retEnd["0_1"]~=nil) then
				worldLayer = tonumber(retEnd["0_1"]);
			end]]
			--print(worldLayer)
			--if(Char.ItemNum(player,BossKey[1])>0) then
				--NLG.SystemMessage(player,"[系統]想進行討伐不能持有過期憑證。");
				--return;
			--elseif (Char.ItemNum(player,16440)<=0) then
				--NLG.SystemMessage(player,"[系統]此處刻著傲慢印記，似乎須要傲慢的罪書來共鳴。");
				--return;
			--else
				local msg = "\\n迷霧森林之主：\\n\\n"
					.."　意外的時空旅者！你是否具備勇氣與力量？\\n"
					.."　就由我這古老的樹精長老來進行試煉吧\\n"
					.."　通過挑戰後就能開始前往「時之殿」的旅途。\\n";
				NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.按钮_是否, 11, msg);
			--end
		end

	end
	------------------------------------------------------------
	if seqno == 11 then  ----超級模式执行
		--key = data+4
		if select == CONST.按钮_否 then
			return;
		elseif select == CONST.按钮_是 then
			if ret and #WorldDate > 0 then
				if WorldDate[1][1]==os.date("%w",os.time()) then
					NLG.SystemMessage(player,"[系統]每日僅能進行1次討伐。");
					Char.Warp(player,0,LeaveMap[1],LeaveMap[2],LeaveMap[3]);
					return;
				end

			else
				WorldDate = {};
				for i=1,7 do
					WorldDate[i]={"7",};
				end
			end
			local playerName = Char.GetData(player,CONST.对象_名字);
			--print(key)
			--[[local MapUser = NLG.GetMapPlayer(0, BossMap[1]);
			if (MapUser ~= -3 ) then
				local msg = "\\n@c請等待前一組挑戰者\\n"
				.. "\\n每次只准許一隊進行房間攻略\\n"
				.. "\\n進入領地後立即會遭遇戰鬥\\n"
				.. "\\n勝利獎勵全部會分配給隊長\\n"
				.. "\\n請將戰利品與戰友們共享\\n";
				NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.按钮_确定, 22, msg);
				return;
			end]]
			--Rank = BossRoom[1].bossRank;
			Char.HealAll(player);
			--Char.GiveItem(player, BossRoom[1].keyItem, BossRoom[1].keyItem_count);
			--local slot = Char.FindItemId(player, BossRoom[1].keyItem);
			--local item_indexA = Char.GetItemIndex(player,slot);
			--Item.SetData(item_indexA,CONST.道具_魅力, BossRoom[1].posNum_L);
			--Item.SetData(item_indexA,CONST.道具_幸运, BossRoom[1].bossRank);
			--Item.UpItem(player,slot);
			table.insert(tbl_duel_user,player);
			--Char.Warp(player,0, BossMap[1], BossMap[2], BossMap[3]);
			--Char.SetLoopEvent('./lua/Modules/mazeBoss1.lua','AutoLord_LoopEvent',player,1000);
			--WorldDate = {}
			WorldDate[1] = {
			os.date("%w",os.time()),
			}
			Field.Set(player, 'WorldDate', JSON.encode(WorldDate));
			local PartyNum = Char.PartyNum(player);
			if (PartyNum>1) then
				for Slot=1,4 do
					local TeamPlayer = Char.GetPartyMember(player,Slot);
					if Char.IsDummy(TeamPlayer)==false then
						Field.Set(TeamPlayer, 'WorldDate', JSON.encode(WorldDate));
					end
				end
			end
			def_round_start(player, 'wincallbackfunc');
		else
			return 0;
		end
	end


  end)
  self:NPC_regTalkedEvent(Lord1Npc, function(npc, player)
	if (NLG.CanTalk(npc, player) == true) then
		local msg = "\\n迷霧森林之主：\\n\\n"
				.."　時之民是一群流浪於時間洪流中的守護者\\n"
				.."　身負掌控時間碎片的秘術，卻也因漫長歲月的\\n"
				.."　侵蝕逐漸變得虛幻他們的居所不再是穩固的城\\n"
				.."　鎮，而是漂浮於裂隙邊緣的「時之殿」一座由\\n"
				.."　破碎時光與魔力凝結而成的靜謐聖域。\\n";
		NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.按钮_下取消, 1, msg);
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
	Battle.SetWinEvent("./lua/Modules/mazeBoss1.lua", "def_round_wincallback", battleindex);

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
	SQL.Run("update lua_hook_worldboss set LordEnd1= '1' where CdKey='"..cdk.."'")
	NLG.UpChar(player);
	local PartyNum = Char.PartyNum(player);
	if (PartyNum>1) then
		for Slot=1,4 do
			local TeamPlayer = Char.GetPartyMember(player,Slot);
			if Char.IsDummy(TeamPlayer)==false then
				local cdk = Char.GetData(TeamPlayer,CONST.对象_CDK);
				--SQL.Run("INSERT INTO lua_hook_worldboss (Name,CdKey) SELECT Name,CdKey FROM tbl_character WHERE NOT EXISTS ( SELECT Name FROM lua_hook_worldboss WHERE tbl_character.CdKey=lua_hook_worldboss.CdKey)");
				SQL.Run("update lua_hook_worldboss set LordEnd1= '1' where CdKey='"..cdk.."'")
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

	--[[local ret = SQL.Run("select Name,WorldLord1 from lua_hook_worldboss where CdKey='"..cdk.."'");
	if(type(ret)=="table" and ret["0_1"]~=nil)then
		LordHP1=tonumber(ret["0_1"]);
	end]]

	local LordHP1 = tonumber(SQL.Run("select WorldLord1 from lua_hook_worldboss where CdKey='"..cdk.."'")["0_0"])
	for i = 10, 19 do
		local enemy = Battle.GetPlayer(battleIndex, i);
		local HP = LordHP1;
		if (HP<=1000) then
			HP = LordHP1*100;
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

	--[[local ret = SQL.Run("select Name,WorldLord1 from lua_hook_worldboss where CdKey='"..cdk.."'");
	if(type(ret)=="table" and ret["0_1"]~=nil)then
		LordHP1=tonumber(ret["0_1"]);
	end]]
	local LordHP1 = tonumber(SQL.Run("select WorldLord1 from lua_hook_worldboss where CdKey='"..cdk.."'")["0_0"])
	--print(LordHP1)
	for i = 10, 19 do
		local enemy = Battle.GetPlayer(battleIndex, i);
		local HP = LordHP1;
		if (HP<=1000 and Round<1) then
			HP = HP*100;
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
				SQL.Run("update lua_hook_worldboss set WorldLord1= '"..HP.."' where CdKey='"..cdk.."'")
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
			NLG.SystemMessage(charIndex,"[系統]魔物領主目前無法受到傷害！");
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