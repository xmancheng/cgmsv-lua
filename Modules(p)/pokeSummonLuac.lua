---模块类
local Module = ModuleBase:createModule('pokeSummonLuac')

--伙伴设置
local allyb = 0
local wanjia = {}--玩家表
for bbb = 0,100 do
	wanjia[bbb] = {}
	wanjia[bbb][0] = 0--ai统计
	for ccc = 1,2 do
		wanjia[bbb][ccc] = -1
	end
end

--自动战斗
local battleData = {};
local zttj0 = 0;
local zttj1 = 0;

function Module:yboffline(player)--玩家下线清空自己召唤的ai
	if (wanjia[player]~=nil) then
		for xxqk = 1,#wanjia[player] do
			if wanjia[player][xxqk] > 0 then
				Char.DelDummy(wanjia[player][xxqk])
			end
		end
		wanjia[player][0] = 0
		Char.EndEvent(player,17,0);
	end
end

--local hbsp = {900330,900333}--饰品

local mfsj = {
	{9213,9212,9211,9210,9209,9208,9207,9206,9205,9201},--1-9地水、10地水晶
	{9222,9221,9220,9219,9218,9217,9216,9215,9214,9202},--1-9水火、10水水晶
	{9231,9230,9229,9228,9227,9226,9225,9224,9223,9203},--1-9火风、10火水晶
	{9240,9239,9238,9237,9236,9235,9234,9233,9232,9204} --1-9风地、10风水晶
}

--- 加载模块钩子
function Module:onLoad()

  self:logInfo('load')
  --local fnpc = self:NPC_createNormal('镜像宠物', 101003, { x = 38, y = 33, mapType = 0, map = 777, direction = 6 });
  self:regCallback('BeforeBattleTurnEvent', Func.bind(self.handleBattleAutoCommand, self))
  self:regCallback('BattleOverEvent', Func.bind(self.battleOverEventCallback, self))
  self:regCallback('ScriptCallEvent', function(npcIndex, playerIndex, text, msg)
    self:logDebugF('npcIndex: %s, playerIndex: %s, text: %s, msg: %s', npcIndex, playerIndex, text, msg)
    self:regCallback("LogoutEvent", Func.bind(self.yboffline, self))
    
	player = playerIndex
	npc = npcIndex

	id = Char.GetData(player,%对象_CDK%)
	name = Char.GetData(player,%对象_名字%)
	lv = Char.GetData(player, %对象_等级%)
	Target_MapId = Char.GetData(player,CONST.CHAR_MAP)--地图类型
	Target_FloorId = Char.GetData(player,CONST.CHAR_地图)--地图编号
	Target_X = Char.GetData(player,CONST.CHAR_X)--地图x
	Target_Y = Char.GetData(player,CONST.CHAR_Y)--地图y

	if text == '一键召唤' then
		for csdd = 1,2 do
			if Char.PartyNum(wanjia[player][csdd]) == -1 then
				Battle.ExitBattle(wanjia[player][csdd]);
				Char.Warp(wanjia[player][csdd], Target_MapId, Target_FloorId, Target_X, Target_Y);
				Char.JoinParty(wanjia[player][csdd],player);
			end
			local pzw = Char.GetData(player,CONST.CHAR_位置)
			if pzw == 1 then 
				if Char.IsDummy(Char.GetPartyMember(player,1)) then
					Char.SetData(Char.GetPartyMember(player,1),CONST.CHAR_位置,0);
				end
				if Char.IsDummy(Char.GetPartyMember(player,2)) then
					Char.SetData(Char.GetPartyMember(player,2),CONST.CHAR_位置,0);
				end
				if Char.IsDummy(Char.GetPartyMember(player,3)) then
					Char.SetData(Char.GetPartyMember(player,3),CONST.CHAR_位置,1);
				end
				if Char.IsDummy(Char.GetPartyMember(player,4)) then
					Char.SetData(Char.GetPartyMember(player,4),CONST.CHAR_位置,1);
				end
			elseif pzw == 0 then
				if Char.IsDummy(Char.GetPartyMember(player,1)) then
					Char.SetData(Char.GetPartyMember(player,1),CONST.CHAR_位置,1);
				end
				if Char.IsDummy(Char.GetPartyMember(player,2)) then
					Char.SetData(Char.GetPartyMember(player,2),CONST.CHAR_位置,1);
				end
				if Char.IsDummy(Char.GetPartyMember(player,3)) then
					Char.SetData(Char.GetPartyMember(player,3),CONST.CHAR_位置,0);
				end
				if Char.IsDummy(Char.GetPartyMember(player,4)) then
					Char.SetData(Char.GetPartyMember(player,4),CONST.CHAR_位置,0);
				end
			end
		end
		if wanjia[player][0] > 3 then
			NLG.SystemMessage(player, '调整角色前后排再召唤，可以改变队伍阵型。' )
		elseif allyb > 100 then
			NLG.SystemMessage(player, '当前线路人口爆满，无法添加佣兵了。' )
		else
		for num = 1,2 do
			local petIndex1 = Char.GetPet(player,num-1)
			if Char.GetData(petIndex1, CONST.PET_DepartureBattleStatus) ~= CONST.PET_STATE_战斗 then
				if wanjia[player][num] <= 0 and petIndex1 >= 0 then
					local charIndex1 = Char.CreateDummy()--生成ai佣兵
					wanjia[player][0] = wanjia[player][0] + 1--统计ai佣兵数量
					--print("编号："..charIndex1.."")
					wanjia[player][num] = charIndex1
					local TL = Pet.GetArtRank(petIndex1,CONST.PET_体成);
					local GJ = Pet.GetArtRank(petIndex1,CONST.PET_力成);
					local FY = Pet.GetArtRank(petIndex1,CONST.PET_强成);
					local MJ = Pet.GetArtRank(petIndex1,CONST.PET_敏成);
					local MF = Pet.GetArtRank(petIndex1,CONST.PET_魔成);
					Char.SetData(charIndex1, CONST.CHAR_耐力, TL);
					Char.SetData(charIndex1, CONST.CHAR_魅力, GJ);
					Char.SetData(charIndex1, CONST.CHAR_声望, FY);
					Char.SetData(charIndex1, CONST.CHAR_灵巧, MJ);
					Char.SetData(charIndex1, CONST.CHAR_智力, MF);

					Char.SetData(charIndex1, CONST.CHAR_X, Char.GetData(player, CONST.CHAR_X));
					Char.SetData(charIndex1, CONST.CHAR_Y, Char.GetData(player, CONST.CHAR_Y));
					Char.SetData(charIndex1, CONST.CHAR_地图, Char.GetData(player, CONST.CHAR_地图));
					Char.SetData(charIndex1, CONST.CHAR_名字, Char.GetData(petIndex1,CONST.CHAR_名字));
					Char.SetData(charIndex1, CONST.CHAR_地图类型, Char.GetData(player,CONST.CHAR_地图类型));
					Char.SetData(charIndex1, CONST.CHAR_形象, Char.GetData(petIndex1,CONST.CHAR_形象));
					Char.SetData(charIndex1, CONST.CHAR_原形, Char.GetData(petIndex1,CONST.CHAR_原形));
					Char.SetData(charIndex1, CONST.CHAR_原始图档, Char.GetData(petIndex1,CONST.CHAR_原始图档));
					--print('charIndex1', charIndex1)
					--print(player)
					Char.SetData(charIndex1, CONST.CHAR_体力, Char.GetData(petIndex1,CONST.CHAR_体力));
					Char.SetData(charIndex1, CONST.CHAR_力量, Char.GetData(petIndex1,CONST.CHAR_力量));
					Char.SetData(charIndex1, CONST.CHAR_强度, Char.GetData(petIndex1,CONST.CHAR_强度));
					Char.SetData(charIndex1, CONST.CHAR_速度, Char.GetData(petIndex1,CONST.CHAR_速度));
					Char.SetData(charIndex1, CONST.CHAR_魔法, Char.GetData(petIndex1,CONST.CHAR_魔法));
					Char.SetData(charIndex1, CONST.CHAR_等级, Char.GetData(petIndex1,CONST.CHAR_等级));
					Char.SetData(charIndex1, CONST.CHAR_种族, Char.GetData(petIndex1,CONST.CHAR_种族));
					NLG.UpChar(charIndex1);
					local dsj= Char.GetData(petIndex1,CONST.CHAR_地属性);
					local ssj= Char.GetData(petIndex1,CONST.CHAR_水属性);
					local hsj= Char.GetData(petIndex1,CONST.CHAR_火属性);
					local fsj= Char.GetData(petIndex1,CONST.CHAR_风属性);
					if dsj>0 and ssj>0 then
						mf=1;
						sj=math.floor(dsj/10);
					elseif ssj>0 and hsj>0 then
						mf=2;
						sj=math.floor(ssj/10);
					elseif hsj>0 and fsj>0 then
						mf=3;
						sj=math.floor(hsj/10);
					elseif fsj>0 and dsj>0 then
						mf=4;
						sj=math.floor(fsj/10);
					else
						mf=math.random(1,4);
						sj=10;
					end
					Char.GiveItem(charIndex1, mfsj[mf][sj], 1);
					--Char.GiveItem(charIndex1, hbsp[1], 1);--饰品1
					--Char.GiveItem(charIndex1, hbsp[2], 1);--饰品2
					Char.MoveItem(charIndex1, 8, CONST.EQUIP_水晶, -1);
					--Char.MoveItem(charIndex1, 9, CONST.EQUIP_首饰1, -1);
					--Char.MoveItem(charIndex1, 10, CONST.EQUIP_首饰2, -1);
					--Char.GiveItem(charIndex1, 18196, 1);--实验药
					--Char.GiveItem(charIndex1, 18315, 1);--火把
					Char.GiveItem(charIndex1, 900202, 1);--攻击《基本》卡
					Char.GiveItem(charIndex1, 900203, 1);--明镜《基本》卡

					Char.SetData(charIndex1, CONST.CHAR_血, Char.GetData(petIndex1,CONST.CHAR_最大血));
					Char.SetData(charIndex1, CONST.CHAR_魔, Char.GetData(petIndex1,CONST.CHAR_最大魔));
					Char.SetData(charIndex1, CONST.CHAR_抗毒, Char.GetData(petIndex1,CONST.CHAR_抗毒));
					Char.SetData(charIndex1, CONST.CHAR_抗睡, Char.GetData(petIndex1,CONST.CHAR_抗睡));
					Char.SetData(charIndex1, CONST.CHAR_抗石, Char.GetData(petIndex1,CONST.CHAR_抗石));
					Char.SetData(charIndex1, CONST.CHAR_抗醉, Char.GetData(petIndex1,CONST.CHAR_抗醉));
					Char.SetData(charIndex1, CONST.CHAR_抗乱, Char.GetData(petIndex1,CONST.CHAR_抗乱));
					Char.SetData(charIndex1, CONST.CHAR_抗忘, Char.GetData(petIndex1,CONST.CHAR_抗忘));
					Char.SetData(charIndex1, CONST.CHAR_必杀, Char.GetData(petIndex1,CONST.CHAR_必杀));
					Char.SetData(charIndex1, CONST.CHAR_反击, Char.GetData(petIndex1,CONST.CHAR_反击));
					Char.SetData(charIndex1, CONST.CHAR_命中, Char.GetData(petIndex1,CONST.CHAR_命中));
					Char.SetData(charIndex1, CONST.CHAR_闪躲, Char.GetData(petIndex1,CONST.CHAR_闪躲));

					Char.SetData(charIndex1, CONST.CHAR_职业, 1);      --游民
					Char.SetData(charIndex1, CONST.CHAR_职类ID, 0);  --游民
					Char.SetData(charIndex1, CONST.CHAR_职阶, 3);

					Char.SetData(charIndex1, CONST.CHAR_金币, Char.GetData(petIndex1,CONST.PET_PetID));

					Char.JoinParty(charIndex1, player);
				else
					--NLG.SystemMessage(player, '宠物不存在。' )
				end
			else
				--NLG.SystemMessage(player, '战斗状态宠物无法召唤。' )
			end
		end
		--Char.EndEvent(player,17,1);  --哈贝鲁村遗迹称号
		end
	end
	if text == '一键解除' then
		for xxqk = 1,#wanjia[player] do
			if wanjia[player][xxqk] > 0 then
				Char.DelDummy(wanjia[player][xxqk])
				wanjia[player][xxqk] = -1
			end
		end
		wanjia[player][0] = 0
		--Char.EndEvent(player,17,0);
	end

    return -1;
  end)

end

--宝可梦伙伴自动战斗
function Module:battleOverEventCallback(battleIndex)
	local player = Battle.GetPlayer(battleIndex, 0);
	local player5 = Battle.GetPlayer(battleIndex, 5);
	battleData[battleIndex] = nil;
end

function Module:handleBattleAutoCommand(battleIndex)
	local leader0 = Battle.GetPlayer(battleIndex, 0)
	local leaderpet0 = Battle.GetPlayer(battleIndex, 5)
	local leader1 = Battle.GetPlayer(battleIndex, 10)
	local leaderpet1 = Battle.GetPlayer(battleIndex, 15)
	local playersd0 = 2
	local playersd1 = 2
	for i = 0, 4 do
		local charIndex = Battle.GetPlayer(battleIndex, i);
		local petIndex = Battle.GetPlayer(battleIndex, math.fmod(i + 5, 10));
		if charIndex >= 0 and petIndex >= 0 then
			playersd0 = 1
		end
	end
	for i = 10, 14 do
		local charIndex = Battle.GetPlayer(battleIndex, i);
		local petIndex = Battle.GetPlayer(battleIndex, math.fmod(i - 5, 10)+10);
		if charIndex >= 0 and petIndex >= 0 then
			playersd1 = 1
		end
	end
	local battleturn = Battle.GetTurn(battleIndex)
	if battleData[battleIndex] == battleturn then
		return
	end
	battleData[battleIndex] = battleturn;
	local hasAutoBattle = false;
--	self:logDebug('handleBattleAutoCommand', battleIndex)
--	self:logDebug('battleturn', battleturn);
	local hasPlayer = false;
	for i = 0, 19 do
		local charIndex = Battle.GetPlayer(battleIndex, i);
		local petIndex = Battle.GetPlayer(battleIndex, math.fmod(i + 5, 10));
		if charIndex >= 0 then
			if Char.IsDummy(charIndex) then
				local sidetable = {{10,40,41,30,20,zswz0},{0,41,40,30,20,zswz1}}
				local charside = 1
				local ybside = Char.GetData(charIndex,%对象_战斗Side%)
				local playersd = playersd0
				local leader = leader0
				local leaderpet = leaderpet0
				local chtj = chtj0
				local zstj = zstj0
				local zttj = zttj0
				local leader5 = leader
				if ybside == 1 then
					charside = 2
					playersd = playersd1
					leader = leader1
					leaderpet = leaderpet1
					petIndex = Battle.GetPlayer(battleIndex, math.fmod(i - 5, 10)+10)
					chtj = chtj1
					zstj = zstj1
					zttj = zttj1
				end
				if Char.GetData(leader, CONST.CHAR_类型) == CONST.对象类型_人 then
					leader5 = leader
				else
					leader5 = leaderpet
				end
				if leader5 < 0 then
					Battle.ActionSelect(charIndex, CONST.BATTLE_COM.BATTLE_COM_ESCAPE, -1, -1);
				else
--					self:logDebug('auto battle', charIndex, petIndex);
					hasAutoBattle = true;
					local rlv = Char.GetData(leader5,%对象_等级%)

					local yblv = math.floor(rlv/10) + 1
					local cwlv = math.floor(rlv/20) + 1
					if rlv >= 100 then	yblv = 10;cwlv = 5;	end
					local ybjn = Battle.IsWaitingCommand(charIndex);

					local hp = Char.GetData(charIndex,%对象_血%);
					local hp2 = Char.GetData(petIndex,%对象_血%);
					local hpMax = Char.GetData(charIndex,%对象_最大血%);
					local hpMax2 = Char.GetData(petIndex,%对象_最大血%);
					local mp = Char.GetData(charIndex,%对象_魔%);
					local mp2 = Char.GetData(petIndex,%对象_魔%);
--镜像宠物伙伴AI
					if Char.GetData(charIndex,%对象_战死%) == 1 then
						Battle.ActionSelect(charIndex, CONST.BATTLE_COM.BATTLE_COM_NONE, -1, -1);
					end
					if ybjn and Char.ItemNum(charIndex,900202) > 0 and Char.ItemNum(charIndex,900203) > 0 then     --攻击、明镜《基本》卡
						local ActionCard = {{CONST.BATTLE_COM.BATTLE_COM_ATTACK, sidetable[charside][1], -1},{CONST.BATTLE_COM.BATTLE_COM_P_CONSENTRATION, -1, 1206}}
						local ACS = 1;
						if (hp <= hpMax/3) then
							ACS = 2;
						end
						Battle.ActionSelect(charIndex,ActionCard[ACS][1],ActionCard[ACS][2],ActionCard[ACS][3]);
					end
				end
				if petIndex < 0 then
					Battle.ActionSelect(charIndex, CONST.BATTLE_COM.BATTLE_COM_ATTACK, sidetable[charside][1], -1);
				else
					Battle.ActionSelect(petIndex,CONST.BATTLE_COM.BATTLE_COM_ATTACK, sidetable[charside][1], -1);
				end
			else
				hasPlayer = true;
			end
		end
	end
--	self:logDebug(hasAutoBattle, hasPlayer, not hasPlayer)
	return hasAutoBattle;
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
