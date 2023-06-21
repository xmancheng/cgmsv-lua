local Module = ModuleBase:createModule('autoBattle')

local battleData = {};
local zttj0 = 0;
local zttj1 = 0;

function Module:onLoad()
	self:logInfo('load')
	--self:regCallback('TalkEvent', Func.bind(Module.handleChat, self))
	--self:regCallback('LogoutEvent', Func.bind(Module.cleanUp, self))
	--self:regCallback('BattleActionEvent', Func.bind(Module.battleActionEventCallBack, self))
	self:regCallback('DamageCalculateEvent', Func.bind(Module.OnDamageCalculateCallBack, self))
	self:regCallback('BattleOverEvent', Func.bind(Module.battleOverEventCallback, self))
	self:regCallback('BeforeBattleTurnEvent', Func.bind(Module.handleBattleAutoCommand, self))
end

function Module:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
      --self:logDebug('OnDamageCalculateCallBack', charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
	local battleturn = Battle.GetTurn(battleIndex);
	local ztBattleturn = battleturn;
	if (ztBattleturn == 0) then
		ztBattleturn = 0;
		zttj0 = 0
		zttj1 = 0
	elseif (battleturn >= ztBattleturn) then
		ztBattleturn = battleturn+1;
		zttj0 = 0
		zttj1 = 0
		for ztxx = 0,9 do
			local ztrw = Battle.GetPlayer(battleIndex, ztxx);--我方状态人数
			if ztrw >= 0 then
				if Char.GetData(ztrw,CONST.CHAR_BattleModPoison)>=1 or Char.GetData(ztrw,CONST.CHAR_BattleModSleep)>=1 or Char.GetData(ztrw,CONST.CHAR_BattleModStone)>=1 or Char.GetData(ztrw,CONST.CHAR_BattleModDrunk)>=1 or Char.GetData(ztrw,CONST.CHAR_BattleModConfusion)>=1 or Char.GetData(ztrw,CONST.CHAR_BattleModAmnesia)>=1 then
					zttj0 = zttj0 + 1
				end
			end
		end
		for ztxx = 10,19 do
			local ztrw = Battle.GetPlayer(battleIndex, ztxx);--他方状态人数
			if ztrw >= 0 then
				if Char.GetData(ztrw,CONST.CHAR_BattleModPoison)>=1 or Char.GetData(ztrw,CONST.CHAR_BattleModSleep)>=1 or Char.GetData(ztrw,CONST.CHAR_BattleModStone)>=1 or Char.GetData(ztrw,CONST.CHAR_BattleModDrunk)>=1 or Char.GetData(ztrw,CONST.CHAR_BattleModConfusion)>=1 or Char.GetData(ztrw,CONST.CHAR_BattleModAmnesia)>=1 then
					zttj1 = zttj1 + 1
				end
			end
		end
	else
	end
	return damage;
end

function Module:battleOverEventCallback(battleIndex)
	local player = Battle.GetPlayer(battleIndex, 0);
	local player5 = Battle.GetPlayer(battleIndex, 5);
	if Char.GetData(player,%对象_对战开关%) == 1 or Char.GetData(player5,%对象_对战开关%) == 1 then--检测传教超恢开启条件
--		NLG.Say(player,-1,"检测到你开启了对战，传教超恢开启！",0,3);
--		NLG.Say(player5,-1,"检测到你开启了对战，传教超恢开启！",0,3);
	end
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
	local chtj0 = 0
	local chtj1 = 0
	local zstj0 = 0
	local zstj1 = 0
	local zswz0 = 0
	local zswz1 = 10
	for chxx = 10,19 do
		local chrw = Battle.GetPlayer(battleIndex, chxx);--敌方存活人数
		if Char.GetData(chrw,%对象_战死%) == 0 then
			chtj0 = chtj0 + 1
		end
	end
	for chxx = 0,9 do
		local chrw = Battle.GetPlayer(battleIndex, chxx);
		if Char.GetData(chrw,%对象_战死%) == 0 then
			chtj1 = chtj1 + 1
		end
	end
	for zsxx = 0,9 do
		local zsrw = Battle.GetPlayer(battleIndex, zsxx);--我方战死人数
		if Char.GetData(zsrw,%对象_战死%) == 1 then
			zstj0 = zstj0 + 1
			if Char.GetData(zsrw, CONST.CHAR_类型) == CONST.对象类型_人 then
				zswz0 = zsxx
			end
		end
	end
	for zsxx = 10,19 do
		local zsrw = Battle.GetPlayer(battleIndex, zsxx);
		if Char.GetData(zsrw,%对象_战死%) == 1 then
			zstj1 = zstj1 + 1
			if Char.GetData(zsrw, CONST.CHAR_类型) == CONST.对象类型_人 then
				zswz1 = zsxx
			end
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
					local ybqk={300,301,302,303,304,305,306,307,308,309}--乾坤一掷
					--local ybyj={25800,25801,25802,25803,25804,25805,25806,25807,25808,25809}--一击必中
					local ybjj={25700,25701,25702,25703,25704,25705,25706,25707,25708,25709}--戒骄戒躁
					local ybls={9500,9501,9502,9503,9504,9505,9506,9507,9508,9509}--乱射
					local ybqg={400,401,402,403,404,405,406,407,408,409}--气功弹
					local ybch={6600,6601,6602,6603,6604,6605,6606,6607,6608,6609}--超恢
					local ybqj={6800,6801,6802,6803,6804,6805,6806,6807,6808,6809}--气绝
					local ybcb={6300,6301,6302,6303,6304,6305}--超补
					local ybmj={1200,1201,1202,1203,1204,1205,1206,1207,1208,1209}--明镜
					local ybdanti={
					{1930,1931,1932,1933,1934,1935,1936,1937,1938,1939},--单陨
					{2030,2031,2032,2033,2034,2035,2036,2037,2038,2039},--单水
					{2130,2131,2132,2133,2134,2135,2136,2137,2138,2139},--单火
					{2230,2231,2232,2233,2234,2235,2236,2237,2238,2239},--单风
					{3100,3101,3102,3103,3104,3105,3106,3107,3108,3109},--吸血
					}--单体魔法
					local ybquanti={
					{2700,2701,2702,2703,2704,2705,2706,2707,2708,2709},--超陨
					{2800,2801,2802,2803,2804,2805,2806,2807,2808,2809},--超水
					{2900,2901,2902,2903,2904,2905,2906,2907,2908,2909},--超火
					{3000,3001,3002,3003,3004,3005,3006,3007,3008,3009},--超风
					{26700,26701,26702,26703,26704,26705,26706,26707,26708,26709},--精神冲击波
					}--全体魔法
					local cwcy={2750,2751,2752,2753,2754,2755,2756,2757,2758,2759}--超陨
					local cwcs={2850,2851,2852,2853,2854,2855,2856,2857,2858,2859}--超水
					local cwch={2950,2951,2952,2953,2954,2955,2956,2957,2958,2959}--超火
					local cwcf={3050,3051,3052,3053,3054,3055,3056,3057,3058,3059}--超风
					local cwdy={1930,1931,1932,1933,1934,1935,1936,1937,1938,1939}--单陨
					local cwds={2030,2031,2032,2033,2034,2035,2036,2037,2038,2039}--单水
					local cwdh={2130,2131,2132,2133,2134,2135,2136,2137,2138,2139}--单火
					local cwdf={2230,2231,2232,2233,2234,2235,2236,2237,2238,2239}--单风
					local cwmj={1230,1232,1234,1236,1238}--明净
					local ybm1={5,10,15,20,25,30,35,40,45,50}--气功弹，乱射，气绝
					local ybm2={24,48,72,96,120}--超补
					local ybm3={48,96,144,192,240,288,336,384,432,480}--超恢
					local ybm4={5,9,13,17,21,25,29,33,37,41}--戒骄戒躁
					local ybm5={10,18,26,34,42,50,58,66,74,82}--乾坤一掷
					local ybm6={10,16,22,28,34,40,46,52,58,64}--一击必中
					local ybm7={10,20,30,40,50,60,70,80,90,100}--宠物单体魔法
					local ybm8={40,80,120,160,200,240,280,320,360,400}--宠物超魔法
					local ybm9={15,45,75,105,135}--宠物明净
					local yblv = math.floor(rlv/10) + 1
					local cwlv = math.floor(rlv/20) + 1
					if rlv >= 100 then	yblv = 10;cwlv = 5;	end
					local ybjn = Battle.IsWaitingCommand(charIndex);
					--local yb01 = Char.GetData(charIndex,%对象_名字%) == "星织"
					--local yb02 = Char.GetData(charIndex,%对象_名字%) == "七冰"
					--local yb03 = Char.GetData(charIndex,%对象_名字%) == "八重切"
					--local yb04 = Char.GetData(charIndex,%对象_名字%) == "红莲"
					--local yb05 = Char.GetData(charIndex,%对象_名字%) == "奈麻"
					--local yb06 = Char.GetData(charIndex,%对象_名字%) == "重音"
					--local yb07 = Char.GetData(charIndex,%对象_名字%) == "凛音"
					--local yb08 = Char.GetData(charIndex,%对象_名字%) == "绵津见"
					--local yb09 = Char.GetData(charIndex,%对象_名字%) == "伊吹"
					--local yb10 = Char.GetData(charIndex,%对象_名字%) == "阿夏"
					--local ybcw01 = Char.GetData(petIndex,%对象_名字%) == "超级大地鼠"
					--local ybcw02 = Char.GetData(petIndex,%对象_名字%) == "超级恶梦鼠"
					--local ybcw03 = Char.GetData(petIndex,%对象_名字%) == "超级火焰鼠"
					--local ybcw04 = Char.GetData(petIndex,%对象_名字%) == "超级宝石鼠"
					--local ybcw05 = Char.GetData(petIndex,%对象_名字%) == "超级口袋龙"
					--local ybcw06 = Char.GetData(petIndex,%对象_名字%) == "超级迷你龙"
					--local ybcw07 = Char.GetData(petIndex,%对象_名字%) == "超级雏龙"
					--local ybcw08 = Char.GetData(petIndex,%对象_名字%) == "超级穴龙"
					local hp = Char.GetData(charIndex,%对象_血%);
					local hp2 = Char.GetData(petIndex,%对象_血%);
					local hpMax = Char.GetData(charIndex,%对象_最大血%);
					local hpMax2 = Char.GetData(petIndex,%对象_最大血%);
					local mp = Char.GetData(charIndex,%对象_魔%);
					local mp2 = Char.GetData(petIndex,%对象_魔%);
--镜像宠物伙伴AI
					if ybjn and Char.ItemNum(charIndex,900202) > 0 and Char.ItemNum(charIndex,900203) > 0 then     --攻击、明镜《基本》卡
						local tmp1,tmp2 = math.modf(battleturn/6)
						local tmp3,tmp4 = math.modf(battleturn/3)
						local tmp5={tmp2,tmp4}
						local ActionCard = {{CONST.BATTLE_COM.BATTLE_COM_ATTACK, sidetable[charside][1], -1},{CONST.BATTLE_COM.BATTLE_COM_P_CONSENTRATION, -1, 1206}}
						local ACS = 1;
						if (hp <= hpMax/3) then
							ACS = 2;
						end
						if Char.ItemNum(charIndex,900204) > 0 and (hp >= hpMax/2) then  --自身血量大于50%
							table.insert(ActionCard, 3, {CONST.BATTLE_COM.BATTLE_COM_KNIGHTGUARD, sidetable[charside][2], 26106});
							ACS = 3;
							if mp<34 then ACS = 1; end
						end
						if Char.ItemNum(charIndex,900205) > 0 and (hp <= hpMax/10) then  --自身血量少于90%
							table.insert(ActionCard, 3, {CONST.BATTLE_COM.BATTLE_COM_P_HEAL, sidetable[charside][2], 6306});
							ACS = 3;
							if mp<336 then ACS = 1; end
						end
						if Char.ItemNum(charIndex,900206) > 0 and tmp5[playersd] == 0 and Battle.GetType(battleIndex) == 2 then
							table.insert(ActionCard, 3, {CONST.BATTLE_COM.BATTLE_COM_P_LP_RECOVERY, sidetable[charside][2], 6606});
							ACS = 3;
							if mp<336 then ACS = 1; end
						end
						if Char.ItemNum(charIndex,900207) > 0 and (chtj > 2) and (hp > hpMax/3) then  --敌方存活人数>2
							table.insert(ActionCard, 4, {CONST.BATTLE_COM.BATTLE_COM_P_SPIRACLESHOT, sidetable[charside][1], 403});
							ACS = 4;
							if mp<20 then ACS = 1; end
						end
						if Char.ItemNum(charIndex,900208) > 0 and (chtj > 2) and (hp > hpMax/3) then  --敌方存活人数>2
							table.insert(ActionCard, 4, {CONST.BATTLE_COM.BATTLE_COM_ATTACKALL, sidetable[charside][4], 10629});
							ACS = 4;
							if mp<105 then ACS = 1; end
						end
						if Char.ItemNum(charIndex,900209) > 0 and tmp5[playersd] == 0 and Battle.GetType(battleIndex) == 1 then
							table.insert(ActionCard, 5, {CONST.BATTLE_COM.BATTLE_COM_P_ABSORB_PHYSICS, sidetable[charside][5]+Battle.GetSlot(battleIndex, charIndex), 5706});
							ACS = 5;
							if mp<160 then ACS = 1; end
						end
						if Char.ItemNum(charIndex,900210) > 0 and tmp5[playersd] == 0 and Battle.GetType(battleIndex) == 1 then
							table.insert(ActionCard, 5, {CONST.BATTLE_COM.BATTLE_COM_P_ABSORB_MAGIC, sidetable[charside][5]+Battle.GetSlot(battleIndex, charIndex), 5806});
							ACS = 5;
							if mp<160 then ACS = 1; end
						end
						if Char.ItemNum(charIndex,900211) > 0 and (zttj >= 1) then  --我方异常状态人数>=1
							table.insert(ActionCard, 5, {CONST.BATTLE_COM.BATTLE_COM_P_STATUSRECOVER, sidetable[charside][2], 6706});
							ACS = 5;
							if mp<80 then ACS = 1; end
						end
						if Char.ItemNum(charIndex,900212) > 0 and tmp5[playersd] == 0 and Battle.GetType(battleIndex) == 1 and (hp > hpMax/3) then
							table.insert(ActionCard, 6, {CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE, sidetable[charside][3], 3406});
							ACS = 6;
							if mp<70 then ACS = 1; end
						end
						if Char.ItemNum(charIndex,900213) > 0 and tmp5[playersd] == 0 and Battle.GetType(battleIndex) == 1 and (hp > hpMax/3) then
							table.insert(ActionCard, 6, {CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE, sidetable[charside][3], 3606});
							ACS = 6;
							if mp<70 then ACS = 1; end
						end
						if Char.ItemNum(charIndex,900214) > 0 and tmp5[playersd] == 0 and Battle.GetType(battleIndex) == 1 and (hp > hpMax/3) then
							table.insert(ActionCard, 6, {CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE, sidetable[charside][3], 3206});
							ACS = 6;
							if mp<70 then ACS = 1; end
						end
						if Char.ItemNum(charIndex,900215) > 0 and tmp5[playersd] == 0 and Battle.GetType(battleIndex) == 1 and (hp > hpMax/3) then
							table.insert(ActionCard, 6, {CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE, sidetable[charside][3], 3506});
							ACS = 6;
							if mp<70 then ACS = 1; end
						end
						if Char.ItemNum(charIndex,900216) > 0 and (hp > hpMax/3) then
							table.insert(ActionCard, 7, {CONST.BATTLE_COM.BATTLE_COM_P_MAGIC, sidetable[charside][4], 1906});
							ACS = 7;
							if mp<70 then ACS = 1; end
						end
						if Char.ItemNum(charIndex,900217) > 0 and (hp > hpMax/3) then
							table.insert(ActionCard, 7, {CONST.BATTLE_COM.BATTLE_COM_P_MAGIC, sidetable[charside][4], 2006});
							ACS = 7;
							if mp<70 then ACS = 1; end
						end
						if Char.ItemNum(charIndex,900218) > 0 and (hp > hpMax/3) then
							table.insert(ActionCard, 7, {CONST.BATTLE_COM.BATTLE_COM_P_MAGIC, sidetable[charside][4], 2106});
							ACS = 7;
							if mp<70 then ACS = 1; end
						end
						if Char.ItemNum(charIndex,900219) > 0 and (hp > hpMax/3) then
							table.insert(ActionCard, 7, {CONST.BATTLE_COM.BATTLE_COM_P_MAGIC, sidetable[charside][4], 2206});
							ACS = 7;
							if mp<70 then ACS = 1; end
						end
						if Char.ItemNum(charIndex,900220) > 0 and tmp5[playersd] == 0 and Battle.GetType(battleIndex) == 1 then
							table.insert(ActionCard, 8, {CONST.BATTLE_COM.BATTLE_COM_P_TREAT_TYPE, -1, 5006});
							ACS = 8;
							if mp<75 then ACS = 1; end
						end
						if Char.ItemNum(charIndex,900221) > 0 and tmp5[playersd] == 0 and Battle.GetType(battleIndex) == 1 then
							table.insert(ActionCard, 8, {CONST.BATTLE_COM.BATTLE_COM_P_TREAT_TYPE, -1, 5106});
							ACS = 8;
							if mp<75 then ACS = 1; end
						end
						if Char.ItemNum(charIndex,900222) > 0 and tmp5[playersd] == 0 and Battle.GetType(battleIndex) == 1 then
							table.insert(ActionCard, 8, {CONST.BATTLE_COM.BATTLE_COM_P_TREAT_TYPE, -1, 5206});
							ACS = 8;
							if mp<75 then ACS = 1; end
						end
						if Char.ItemNum(charIndex,900223) > 0 and tmp5[playersd] == 0 and Battle.GetType(battleIndex) == 1 then
							table.insert(ActionCard, 8, {CONST.BATTLE_COM.BATTLE_COM_P_TREAT_TYPE, -1, 5306});
							ACS = 8;
							if mp<75 then ACS = 1; end
						end
						Battle.ActionSelect(charIndex,ActionCard[ACS][1],ActionCard[ACS][2],ActionCard[ACS][3]);
					end
--人物AI
--[[
					if ybjn and yb01 then
						local AttackData = {{CONST.BATTLE_COM.BATTLE_COM_ATTACK, sidetable[charside][1], -1},{CONST.BATTLE_COM.BATTLE_COM_P_RANDOMSHOT, sidetable[charside][1], ybls[yblv]},{CONST.BATTLE_COM.BATTLE_COM_P_CONSENTRATION, -1, ybmj[yblv]}}
						local ACC = 1;
						if chtj > 2 and mp >= ybm1[yblv] then
							ACC = 2;
						end
						if hp <= hpMax/3 then
							ACC = 3;
						end
						Battle.ActionSelect(charIndex,AttackData[ACC][1],AttackData[ACC][2],AttackData[ACC][3]);
					elseif ybjn and yb10 then
						local shuxing = math.random(1,5);
						print(shuxing)
						local AttackData = {{CONST.BATTLE_COM.BATTLE_COM_ATTACK, sidetable[charside][1], -1},{CONST.BATTLE_COM.BATTLE_COM_P_MAGIC, sidetable[charside][1], ybdanti[shuxing][yblv]},{CONST.BATTLE_COM.BATTLE_COM_P_MAGIC, sidetable[charside][3], ybquanti[shuxing][yblv]},{CONST.BATTLE_COM.BATTLE_COM_P_CONSENTRATION, sidetable[charside][1], ybdanti[5][yblv]}}
						local ACC = 1;
						if chtj > 4 and mp >= ybm8[yblv] then
							ACC = 3;
							--print(ybquanti[shuxing][yblv])
						elseif mp >= ybm7[yblv] then
							ACC = 2;
							--print(yblv)
							--print(ybquanti[yblv])
						end
						if hp <= hpMax/3 and mp >= ybm7[yblv] then
							ACC = 4;
						end
						Battle.ActionSelect(charIndex,AttackData[ACC][1],AttackData[ACC][2],AttackData[ACC][3]);
					elseif ybjn and yb02 then
						local AttackData = {{CONST.BATTLE_COM.BATTLE_COM_ATTACK, sidetable[charside][1], -1},{CONST.BATTLE_COM.BATTLE_COM_P_RANDOMSHOT, sidetable[charside][1], ybls[yblv]},{CONST.BATTLE_COM.BATTLE_COM_P_CONSENTRATION, -1, ybmj[yblv]}}
						local ACC = 1;
						if chtj > 2 and mp >= ybm1[yblv] then
							ACC = 2;
							--print(yblv)
							--print(ybls[yblv])
						end
						if hp <= hpMax/3 then
							ACC = 3;
						end
						Battle.ActionSelect(charIndex,AttackData[ACC][1],AttackData[ACC][2],AttackData[ACC][3]);
					elseif ybjn and yb03 then
						local AttackData = {{CONST.BATTLE_COM.BATTLE_COM_ATTACK, sidetable[charside][1], -1},{CONST.BATTLE_COM.BATTLE_COM_P_SPIRACLESHOT, sidetable[charside][1], ybqg[yblv]},{CONST.BATTLE_COM.BATTLE_COM_P_CONSENTRATION, -1, ybmj[yblv]}}
						local ACC = 1;
						if chtj > 2 and mp >= ybm1[yblv] then
							ACC = 2;
						end
						if hp <= hpMax/3 then
							ACC = 3;
						end
						Battle.ActionSelect(charIndex,AttackData[ACC][1],AttackData[ACC][2],AttackData[ACC][3]);
					elseif ybjn and yb04 then
						local AttackData = {{CONST.BATTLE_COM.BATTLE_COM_ATTACK, sidetable[charside][1], -1},{CONST.BATTLE_COM.BATTLE_COM_P_SPIRACLESHOT, sidetable[charside][1], ybqg[yblv]},{CONST.BATTLE_COM.BATTLE_COM_P_CONSENTRATION, -1, ybmj[yblv]}}
						local ACC = 1;
						if chtj > 2 and mp >= ybm1[yblv] then
							ACC = 2;
						end
						if hp <= hpMax/3 then
							ACC = 3;
						end
						Battle.ActionSelect(charIndex,AttackData[ACC][1],AttackData[ACC][2],AttackData[ACC][3]);
					elseif ybjn and yb05 then
						local HealRecoveryData = { {CONST.BATTLE_COM.BATTLE_COM_P_LP_RECOVERY, sidetable[charside][2], ybch[yblv]}, {CONST.BATTLE_COM.BATTLE_COM_P_HEAL, sidetable[charside][2], ybcb[cwlv]}, {CONST.BATTLE_COM.BATTLE_COM_P_STATUSRECOVER, sidetable[charside][2], 6702}, {CONST.BATTLE_COM.BATTLE_COM_P_REVIVE, sidetable[charside][6], ybqj[yblv]}, {CONST.BATTLE_COM.BATTLE_COM_ATTACK, sidetable[charside][1], -1}};
						local tmp1,tmp2 = math.modf(battleturn/6)
						local tmp3,tmp4 = math.modf(battleturn/3)
						local tmp5={tmp2,tmp4}
						local HRR = 5;
						if mp >= ybm2[cwlv] then
							HRR = 2;
							if NLG.Rand(1,3)>=3 then
								HRR = 5;
							end
						end
						if (zttj >= 1) and mp >= 40 then
							HRR = 3;
						end
						if (zstj >= 1 or Char.GetData(leader5,%对象_战死%)==1) and mp >= ybm1[yblv] then
							HRR = 4;
						end
						if tmp5[playersd] == 0 and mp >= ybm3[yblv] and (Char.GetData(leader5,%对象_对战开关%) == 1 or Battle.GetType(battleIndex) == 2) then
							HRR = 1;
						end
						Battle.ActionSelect(charIndex, HealRecoveryData[HRR][1], HealRecoveryData[HRR][2], HealRecoveryData[HRR][3]);
					elseif ybjn and yb06 then
						local AttackData = {{CONST.BATTLE_COM.BATTLE_COM_ATTACK, sidetable[charside][1], -1},{CONST.BATTLE_COM.BATTLE_COM_P_PARAMETER, sidetable[charside][1], ybjj[yblv]},{CONST.BATTLE_COM.BATTLE_COM_P_CONSENTRATION, -1, ybmj[yblv]}}
						local ACC = 1;
						if chtj >= 2 and mp >= ybm4[yblv] then
							ACC = 2;
						end
						if hp <= hpMax/3 then
							ACC = 3;
						end
						Battle.ActionSelect(charIndex,AttackData[ACC][1],AttackData[ACC][2],AttackData[ACC][3]);
					elseif ybjn and yb07 then
						local AttackData = {{CONST.BATTLE_COM.BATTLE_COM_ATTACK, sidetable[charside][1], -1},{CONST.BATTLE_COM.BATTLE_COM_P_PARAMETER, sidetable[charside][1], ybjj[yblv]},{CONST.BATTLE_COM.BATTLE_COM_P_CONSENTRATION, -1, ybmj[yblv]}}
						local ACC = 1;
						if chtj >= 2 and mp >= ybm4[yblv] then
							ACC = 2;
						end
						if hp <= hpMax/3 then
							ACC = 3;
						end
						Battle.ActionSelect(charIndex,AttackData[ACC][1],AttackData[ACC][2],AttackData[ACC][3]);
					elseif ybjn and yb08 then
						local AttackData = {{CONST.BATTLE_COM.BATTLE_COM_ATTACK, sidetable[charside][1], -1},{CONST.BATTLE_COM.BATTLE_COM_P_PARAMETER, sidetable[charside][1], ybqk[yblv]},{CONST.BATTLE_COM.BATTLE_COM_P_CONSENTRATION, -1, ybmj[yblv]}}
						local ACC = 1;
						if chtj >= 2 and mp >= ybm5[yblv] then
							ACC = 2;
						end
						if hp <= hpMax/3 then
							ACC = 3;
						end
						Battle.ActionSelect(charIndex,AttackData[ACC][1],AttackData[ACC][2],AttackData[ACC][3]);
					elseif ybjn and yb09 then
						local AttackData = {{CONST.BATTLE_COM.BATTLE_COM_ATTACK, sidetable[charside][1], -1},{CONST.BATTLE_COM.BATTLE_COM_P_PARAMETER, sidetable[charside][1], ybqk[yblv]},{CONST.BATTLE_COM.BATTLE_COM_P_CONSENTRATION, -1, ybmj[yblv]}}
						local ACC = 1;
						if chtj >= 2 and mp >= ybm5[yblv] then
							ACC = 2;
						end
						if hp <= hpMax/3 then
							ACC = 3;
						end
						Battle.ActionSelect(charIndex,AttackData[ACC][1],AttackData[ACC][2],AttackData[ACC][3]);
					end
]]
--宠物AI
--[[
					if ybjn and ybcw01 then
						local AttackData = {{CONST.BATTLE_COM.BATTLE_COM_ATTACK, sidetable[charside][1], -1},{CONST.BATTLE_COM.BATTLE_COM_P_MAGIC, sidetable[charside][1], cwdy[yblv]},{CONST.BATTLE_COM.BATTLE_COM_P_MAGIC, sidetable[charside][3], cwcy[yblv]},{CONST.BATTLE_COM.BATTLE_COM_P_CONSENTRATION, -1, cwmj[cwlv]}}
						local ACC = 1;
						if chtj <= 2 and mp2 >= ybm7[yblv] then
							ACC = 2;
						end
						if chtj > 2 and mp2 >= ybm8[yblv] then
							ACC = 3;
						end
						if hp2 <= hpMax2/3 and mp2>=ybm9[cwlv]then
							ACC = 4;
						end
						Battle.ActionSelect(petIndex,AttackData[ACC][1],AttackData[ACC][2],AttackData[ACC][3]);
					elseif ybjn and ybcw02 then
						local AttackData = {{CONST.BATTLE_COM.BATTLE_COM_ATTACK, sidetable[charside][1], -1},{CONST.BATTLE_COM.BATTLE_COM_P_MAGIC, sidetable[charside][1], cwds[yblv]},{CONST.BATTLE_COM.BATTLE_COM_P_MAGIC, sidetable[charside][3], cwcs[yblv]},{CONST.BATTLE_COM.BATTLE_COM_P_CONSENTRATION, -1, cwmj[cwlv]}}
						local ACC = 1;
						if chtj <= 2 and mp2 >= ybm7[yblv] then
							ACC = 2;
						end
						if chtj > 2 and mp2 >= ybm8[yblv] then
							ACC = 3;
						end
						if hp2 <= hpMax2/3 and mp2>=ybm9[cwlv]then
							ACC = 4;
						end
						Battle.ActionSelect(petIndex,AttackData[ACC][1],AttackData[ACC][2],AttackData[ACC][3]);
					elseif ybjn and ybcw03 then
						local AttackData = {{CONST.BATTLE_COM.BATTLE_COM_ATTACK, sidetable[charside][1], -1},{CONST.BATTLE_COM.BATTLE_COM_P_MAGIC, sidetable[charside][1], cwdh[yblv]},{CONST.BATTLE_COM.BATTLE_COM_P_MAGIC, sidetable[charside][3], cwch[yblv]},{CONST.BATTLE_COM.BATTLE_COM_P_CONSENTRATION, -1, cwmj[cwlv]}}
						local ACC = 1;
						if chtj <= 2 and mp2 >= ybm7[yblv] then
							ACC = 2;
						end
						if chtj > 2 and mp2 >= ybm8[yblv] then
							ACC = 3;
						end
						if hp2 <= hpMax2/3 and mp2>=ybm9[cwlv]then
							ACC = 4;
						end
						Battle.ActionSelect(petIndex,AttackData[ACC][1],AttackData[ACC][2],AttackData[ACC][3]);
					elseif ybjn and ybcw04 then
						local AttackData = {{CONST.BATTLE_COM.BATTLE_COM_ATTACK, sidetable[charside][1], -1},{CONST.BATTLE_COM.BATTLE_COM_P_MAGIC, sidetable[charside][1], cwdf[yblv]},{CONST.BATTLE_COM.BATTLE_COM_P_MAGIC, sidetable[charside][3], cwcf[yblv]},{CONST.BATTLE_COM.BATTLE_COM_P_CONSENTRATION, -1, cwmj[cwlv]}}
						local ACC = 1;
						if chtj <= 2 and mp2 >= ybm7[yblv] then
							ACC = 2;
						end
						if chtj > 2 and mp2 >= ybm8[yblv] then
							ACC = 3;
						end
						if hp2 <= hpMax2/3 and mp2>=ybm9[cwlv]then
							ACC = 4;
						end
						Battle.ActionSelect(petIndex,AttackData[ACC][1],AttackData[ACC][2],AttackData[ACC][3]);
					elseif ybjn and ybcw05 then
						local AttackData = {{CONST.BATTLE_COM.BATTLE_COM_ATTACK, sidetable[charside][1], -1},{CONST.BATTLE_COM.BATTLE_COM_P_CONSENTRATION, -1, cwmj[cwlv]}}
						local ACC = 1;
						if hp2 <= hpMax2/3 and mp2>=ybm9[cwlv]then
							ACC = 2;
						end
						Battle.ActionSelect(petIndex,AttackData[ACC][1],AttackData[ACC][2],AttackData[ACC][3]);
					elseif ybjn and ybcw06 then
						local AttackData = {{CONST.BATTLE_COM.BATTLE_COM_ATTACK, sidetable[charside][1], -1},{CONST.BATTLE_COM.BATTLE_COM_P_CONSENTRATION, -1, cwmj[cwlv]}}
						local ACC = 1;
						if hp2 <= hpMax2/3 and mp2>=ybm9[cwlv]then
							ACC = 2;
						end
						Battle.ActionSelect(petIndex,AttackData[ACC][1],AttackData[ACC][2],AttackData[ACC][3]);
					elseif ybjn and ybcw07 then
						local AttackData = {{CONST.BATTLE_COM.BATTLE_COM_ATTACK, sidetable[charside][1], -1},{CONST.BATTLE_COM.BATTLE_COM_P_CONSENTRATION, -1, cwmj[cwlv]}}
						local ACC = 1;
						if hp2 <= hpMax2/3 and mp2>=ybm9[cwlv]then
							ACC = 2;
						end
						Battle.ActionSelect(petIndex,AttackData[ACC][1],AttackData[ACC][2],AttackData[ACC][3]);
					elseif ybjn and ybcw08 then
						local AttackData = {{CONST.BATTLE_COM.BATTLE_COM_ATTACK, sidetable[charside][1], -1},{CONST.BATTLE_COM.BATTLE_COM_P_CONSENTRATION, -1, cwmj[cwlv]}}
						local ACC = 1;
						if hp2 <= hpMax2/3 and mp2>=ybm9[cwlv]then
							ACC = 2;
						end
						Battle.ActionSelect(petIndex,AttackData[ACC][1],AttackData[ACC][2],AttackData[ACC][3]);
					end
]]
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

function Module:onUnload()
	self:logInfo('unload');
end

return Module;
