---模块类
local Module = ModuleBase:createModule('battleMirrorDevil')

-- {skillId,	com1,	com3(techId),	0 己方 |1 对方（目前没用） ，目标点击单位： 0 sigle| 1 range | 2 sideall |3 whole }
skillParams={
	-- 连击
	{skillId=0,com1=CONST.BATTLE_COM.BATTLE_COM_P_RENZOKU,techId={0,99},side=1,unit=0},
	-- 诸刃
	{skillId=1,com1=CONST.BATTLE_COM.BATTLE_COM_P_PARAMETER,techId={100,199},side=1,unit=0},
	-- 乾坤
	{skillId=3,com1=CONST.BATTLE_COM.BATTLE_COM_P_PARAMETER,techId={300,399},side=1,unit=0},
	-- 气功蛋
	{skillId=4,com1=CONST.BATTLE_COM.BATTLE_COM_P_SPIRACLESHOT,techId={400,499},side=1,unit=0},
	-- 崩击
	{skillId=5,com1=CONST.BATTLE_COM.BATTLE_COM_P_GUARDBREAK,techId={500,599},side=1,unit=0},
	-- 战栗袭心
	{skillId=6,com1=CONST.BATTLE_COM.BATTLE_COM_P_FORCECUT,techId={600,699},side=1,unit=0},
	-- 护卫
	{skillId=7,com1=CONST.BATTLE_COM.BATTLE_COM_P_BODYGUARD,techId={700,799},side=0,unit=0},
	-- 圣盾
	{skillId=8,com1=CONST.BATTLE_COM.BATTLE_COM_P_SPECIALGARD,techId={800,899},side=0,unit=0},
	-- 阳炎
	{skillId=9,com1=CONST.BATTLE_COM.BATTLE_COM_P_DODGE,techId={900,999},side=1,unit=0},
	-- 防御魔法攻击
	{skillId=10,com1=CONST.BATTLE_COM.BATTLE_COM_P_MAGICGARD,techId={1000,1000},side=0,unit=0},
	-- 反击
	{skillId=11,com1=CONST.BATTLE_COM.BATTLE_COM_P_CROSSCOUNTER,techId={1100,1199},side=0,unit=0},
	-- 明镜止水
	{skillId=12,com1=CONST.BATTLE_COM.BATTLE_COM_P_CONSENTRATION,techId={1200,1299},side=0,unit=0},
	-- 陨石魔法
	{skillId=19,com1=CONST.BATTLE_COM.BATTLE_COM_P_MAGIC,techId={1900,1999},side=1,unit=0},
	-- 冰冻魔法
	{skillId=20,com1=CONST.BATTLE_COM.BATTLE_COM_P_MAGIC,techId={2000,2099},side=1,unit=0},
	-- 火焰魔法
	{skillId=21,com1=CONST.BATTLE_COM.BATTLE_COM_P_MAGIC,techId={2100,2199},side=1,unit=0},
	-- 风刃魔法
	{skillId=22,com1=CONST.BATTLE_COM.BATTLE_COM_P_MAGIC,techId={2200,2299},side=1,unit=0},
	-- 强力陨石
	{skillId=23,com1=CONST.BATTLE_COM.BATTLE_COM_P_MAGIC,techId={2300,2399},side=1,unit=1},
	-- 强力冰冻
	{skillId=24,com1=CONST.BATTLE_COM.BATTLE_COM_P_MAGIC,techId={2400,2499},side=1,unit=1},
	-- 强力火焰
	{skillId=25,com1=CONST.BATTLE_COM.BATTLE_COM_P_MAGIC,techId={2500,2599},side=1,unit=1},
	-- 强力风刃
	{skillId=26,com1=CONST.BATTLE_COM.BATTLE_COM_P_MAGIC,techId={2600,2699},side=1,unit=1},
	-- 超强陨石
	{skillId=27,com1=CONST.BATTLE_COM.BATTLE_COM_P_MAGIC,techId={2700,2799},side=1,unit=2},
	-- 超强冰冻
	{skillId=28,com1=CONST.BATTLE_COM.BATTLE_COM_P_MAGIC,techId={2800,2899},side=1,unit=2},
	-- 超强火焰
	{skillId=29,com1=CONST.BATTLE_COM.BATTLE_COM_P_MAGIC,techId={2900,2999},side=1,unit=2},
	-- 超强风刃
	{skillId=30,com1=CONST.BATTLE_COM.BATTLE_COM_P_MAGIC,techId={3000,3099},side=1,unit=2},
	-- 吸血魔法
	{skillId=31,com1=CONST.BATTLE_COM.BATTLE_COM_P_DORAIN,techId={3100,3199},side=1,unit=0},
	-- 中毒魔法
	{skillId=32,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={3200,3299},side=1,unit=0},
	-- 昏睡魔法
	{skillId=33,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={3300,3399},side=1,unit=0},
	-- 石化魔法
	{skillId=34,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={3400,3499},side=1,unit=0},
	-- 酒醉魔法
	{skillId=35,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={3500,3599},side=1,unit=0},
	-- 混乱魔法
	{skillId=36,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={3600,3699},side=1,unit=0},
	-- 遗忘魔法
	{skillId=37,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={3700,3799},side=1,unit=0},
	-- 强力中毒魔法
	{skillId=38,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={3800,3899},side=1,unit=1},
	-- 强力昏睡魔法
	{skillId=39,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={3900,3999},side=1,unit=1},
	-- 强力石化魔法
	{skillId=40,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={4000,4099},side=1,unit=1},
	-- 强力酒醉魔法
	{skillId=41,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={4100,4199},side=1,unit=1},
	-- 强力混乱魔法
	{skillId=42,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={4200,4299},side=1,unit=1},
	-- 强力遗忘魔法
	{skillId=43,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={4300,4399},side=1,unit=1},
	-- 超强中毒魔法
	{skillId=44,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={4400,4499},side=1,unit=2},
	-- 超强昏睡魔法
	{skillId=45,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={4500,4599},side=1,unit=2},
	-- 超强石化魔法
	{skillId=46,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={4600,4699},side=1,unit=2},
	-- 超强酒醉魔法
	{skillId=47,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={4700,4799},side=1,unit=2},
	-- 超强混乱魔法
	{skillId=48,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={4800,4899},side=1,unit=2},
	-- 超强遗忘魔法
	{skillId=49,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={4900,4999},side=1,unit=2},
	-- 大地的祈祷
	{skillId=50,com1=CONST.BATTLE_COM.BATTLE_COM_P_TREAT_TYPE,techId={5000,5099},side=0,unit=0},
	-- 海洋的祈祷
	{skillId=51,com1=CONST.BATTLE_COM.BATTLE_COM_P_TREAT_TYPE,techId={5100,5199},side=0,unit=0},
	-- 火焰的祈祷
	{skillId=52,com1=CONST.BATTLE_COM.BATTLE_COM_P_TREAT_TYPE,techId={5200,5299},side=0,unit=0},
	-- 云群的祈祷
	{skillId=53,com1=CONST.BATTLE_COM.BATTLE_COM_P_TREAT_TYPE,techId={5300,5399},side=0,unit=0},
	-- 属性反转
	{skillId=54,com1=CONST.BATTLE_COM.BATTLE_COM_P_REVERSE_TYPE,techId={5400,5499},side=0,unit=0},
	-- 攻击反弹
	{skillId=55,com1=CONST.BATTLE_COM.BATTLE_COM_P_REFLECTION_PHYSICS,techId={5500,5599},side=0,unit=0},
	-- 魔法反弹
	{skillId=56,com1=CONST.BATTLE_COM.BATTLE_COM_P_REFLECTION_MAGIC,techId={5600,5699},side=0,unit=0},
	-- 攻击吸收
	{skillId=57,com1=CONST.BATTLE_COM.BATTLE_COM_P_ABSORB_PHYSICS,techId={5700,5799},side=0,unit=0},
	-- 魔法吸收
	{skillId=58,com1=CONST.BATTLE_COM.BATTLE_COM_P_ABSORB_MAGIC,techId={5800,5899},side=0,unit=0},
	-- 攻击无效
	{skillId=59,com1=CONST.BATTLE_COM.BATTLE_COM_P_INEFFECTIVE_PHYSICS,techId={5900,5999},side=0,unit=0},
	-- 魔法无效
	{skillId=60,com1=CONST.BATTLE_COM.BATTLE_COM_P_INEFFECTIVE_MAGIC,techId={6000,6099},side=0,unit=0},
	-- 补血
	{skillId=61,com1=CONST.BATTLE_COM.BATTLE_COM_P_HEAL,techId={6100,6199},side=0,unit=0},
	-- 强力补血
	{skillId=62,com1=CONST.BATTLE_COM.BATTLE_COM_P_HEAL,techId={6200,6299},side=0,unit=1},
	-- 超强补血
	{skillId=63,com1=CONST.BATTLE_COM.BATTLE_COM_P_HEAL,techId={6300,6399},side=0,unit=2},
	-- 恢复
	{skillId=64,com1=CONST.BATTLE_COM.BATTLE_COM_P_LP_RECOVERY,techId={6400,6499},side=0,unit=0},
	-- 强力恢复
	{skillId=65,com1=CONST.BATTLE_COM.BATTLE_COM_P_LP_RECOVERY,techId={6500,6599},side=0,unit=1},
	-- 超强恢复
	{skillId=66,com1=CONST.BATTLE_COM.BATTLE_COM_P_LP_RECOVERY,techId={6600,6699},side=0,unit=2},
	-- 洁净 单体目标
	{skillId=67,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSRECOVER,techId={6700,6702},side=0,unit=0},
	-- 洁净 强力目标
	{skillId=67,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSRECOVER,techId={6703,6705},side=0,unit=1},
	-- 洁净 强超强目标
	{skillId=67,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSRECOVER,techId={6706,6799},side=0,unit=2},
	-- 气绝回复
	{skillId=68,com1=CONST.BATTLE_COM.BATTLE_COM_P_REVIVE,techId={6800,6899},side=0,unit=0},
	-- 盗窃
	{skillId=72,com1=CONST.BATTLE_COM.BATTLE_COM_P_STEAL,techId={7200,7299},side=0,unit=0},
	-- 宠物普通攻击
	{skillId=73,com1=CONST.BATTLE_COM.BATTLE_COM_ATTACK,techId={7300,7300},side=1,unit=0},
	-- 宠物防御
	{skillId=74,com1=CONST.BATTLE_COM.BATTLE_COM_GUARD,techId={7400,7400},side=0,unit=0},
	-- 宠物毒性攻击
	{skillId=75,com1=CONST.BATTLE_COM.BATTLE_COM_M_STATUSATTACK,techId={7500,7599},side=1,unit=0},
	-- 宠物昏睡攻击
	{skillId=76,com1=CONST.BATTLE_COM.BATTLE_COM_M_STATUSATTACK,techId={7600,7699},side=1,unit=0},
	-- 宠物石化攻击
	{skillId=77,com1=CONST.BATTLE_COM.BATTLE_COM_M_STATUSATTACK,techId={7700,7799},side=1,unit=0},
	-- 宠物酒醉攻击
	{skillId=78,com1=CONST.BATTLE_COM.BATTLE_COM_M_STATUSATTACK,techId={7800,7899},side=1,unit=0},
	-- 宠物混乱攻击
	{skillId=79,com1=CONST.BATTLE_COM.BATTLE_COM_M_STATUSATTACK,techId={7900,7999},side=1,unit=0},
	-- 宠物遗忘攻击
	{skillId=80,com1=CONST.BATTLE_COM.BATTLE_COM_M_STATUSATTACK,techId={8000,8099},side=1,unit=0},
	-- 宠物吸血攻击
	{skillId=81,com1=CONST.BATTLE_COM.BATTLE_COM_M_BLOODATTACK,techId={8100,8199},side=1,unit=0},
	-- 混乱攻击
	{skillId=94,com1=CONST.BATTLE_COM.BATTLE_COM_P_PANIC,techId={9400,9499},side=1,unit=0},
	-- 乱射
	{skillId=95,com1=CONST.BATTLE_COM.BATTLE_COM_P_RANDOMSHOT,techId={9500,9599},side=1,unit=0},
	-- 宠物定点移动
	{skillId=160,com1=CONST.BATTLE_COM.BATTLE_COM_POSITION,techId={16000,16000},side=0,unit=0},
	-- 宠物什么都不做
	{skillId=170,com1=CONST.BATTLE_COM.BATTLE_COM_NONE,techId={15002,15002},side=0,unit=0},
	-- 戒骄戒躁
	{skillId=1001,com1=CONST.BATTLE_COM.BATTLE_COM_DELAYATTACK,techId={25700,25799},side=1,unit=0},
	-- 一击必中
	{skillId=1002,com1=CONST.BATTLE_COM.BATTLE_COM_DELAYATTACK,techId={25800,25899},side=1,unit=0},
	-- 毒击
	{skillId=1003,com1=CONST.BATTLE_COM.BATTLE_COM_M_STATUSATTACK,techId={25900,25999},side=1,unit=0},
	-- 一石二鸟
	{skillId=1004,com1=CONST.BATTLE_COM.BATTLE_COM_BILLIARD,techId={26000,26099},side=1,unit=0},
	-- 骑士之誉
	{skillId=1005,com1=CONST.BATTLE_COM.BATTLE_COM_KNIGHTGUARD,techId={26100,26199},side=0,unit=0},
	-- 迅速果断
	{skillId=1006,com1=CONST.BATTLE_COM.BATTLE_COM_FIRSTATTACK,techId={26200,26299},side=1,unit=0},
	-- 羊头狗肉
	{skillId=1007,com1=CONST.BATTLE_COM.BATTLE_COM_COPY,techId={26300,26399},side=1,unit=0},
	-- 因果报应
	{skillId=1010,com1=CONST.BATTLE_COM.BATTLE_COM_RETRIBUTION,techId={26600,26699},side=1,unit=0},
	-- 追月
	{skillId=2005,com1=CONST.BATTLE_COM.BATTLE_COM_BLASTWAVE,techId={200500,200599},side=1,unit=0},
}

local playerInfo = {
	{ Info=CONST.CHAR_形象 },{ Info=CONST.CHAR_原形 },{ Info=CONST.CHAR_等级 },{ Info=CONST.CHAR_血 },{ Info=CONST.CHAR_魔 },
	{ Info=CONST.CHAR_体力 },{ Info=CONST.CHAR_力量 },{ Info=CONST.CHAR_强度 },{ Info=CONST.CHAR_速度 },{ Info=CONST.CHAR_魔法 },
	{ Info=CONST.CHAR_种族 },{ Info=CONST.CHAR_地属性 },{ Info=CONST.CHAR_水属性 },{ Info=CONST.CHAR_火属性 },{ Info=CONST.CHAR_风属性 },
	{ Info=CONST.CHAR_抗毒 },{ Info=CONST.CHAR_抗睡 },{ Info=CONST.CHAR_抗石 },{ Info=CONST.CHAR_抗醉 },{ Info=CONST.CHAR_抗乱 },{ Info=CONST.CHAR_抗忘 },
	{ Info=CONST.CHAR_必杀 },{ Info=CONST.CHAR_反击 },{ Info=CONST.CHAR_命中 },{ Info=CONST.CHAR_闪躲 },
	{ Info=CONST.CHAR_职业 },{ Info=CONST.CHAR_职阶 },{ Info=CONST.CHAR_职类ID },
	{ Info=CONST.CHAR_原始图档 },{ Info=CONST.CHAR_名字 },{ Info=CONST.CHAR_最大血 },{ Info=CONST.CHAR_最大魔 },
	{ Info=CONST.CHAR_攻击力 },{ Info=CONST.CHAR_防御力 },{ Info=CONST.CHAR_敏捷 },{ Info=CONST.CHAR_精神 },{ Info=CONST.CHAR_回复 },{ Info=CONST.CHAR_魔攻 },{ Info=CONST.CHAR_魔强 },
}

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BattleStartEvent', Func.bind(self.OnbattleStartEventCallback, self))
  self:regCallback('BeforeBattleTurnEvent', Func.bind(self.OnBeforeBattleTurnCommand, self))
  self:regCallback('AfterBattleTurnEvent', Func.bind(self.OnAfterBattleTurnCommand, self))
  self:regCallback('EnemyCommandEvent', Func.bind(self.OnEnemyCommandCallBack, self))
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
  self:regCallback('BattleSurpriseEvent', Func.bind(self.OnBattleSurpriseCallBack, self))
  local devilNpc = self:NPC_createNormal('水鏡惡魔史萊姆', 101503, { map = 1000, x = 215, y = 90, direction = 4, mapType = 0 })
  self:NPC_regWindowTalkedEvent(devilNpc, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select == CONST.BUTTON_否 then
        return;
    end
    if select == CONST.BUTTON_是 then
        local EnemyIdAr = {406180, 406181, 406182, 406183, 406184, 406185, 406186, 406187, 406188, 406189}
        local BaseLevelAr = {199, 199, 199, 199, 199, 199, 199, 199, 199, 199}
        local BattleIndex = Battle.PVE(player, player, nil, EnemyIdAr, BaseLevelAr,  nil)
        Battle.SetWinEvent("./lua/Modules/battleMirrorDevil.lua", "DevilNpc_BattleWin", BattleIndex);
        --Battle.Encount(npc, player, "3|||0|||||3|406180|5|2|5|2|")
    end
  end)
  self:NPC_regTalkedEvent(devilNpc, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local winMsg = "\\n\\n\\n@c警告！此魔物喜好鏡射複製\\n"
                                          .. "\\n　　\\n"
                                          .. "\\n你想要挑戰水鏡惡魔史萊姆嗎？\\n";
      NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.BUTTON_是否, 1, winMsg);
    end
    return
  end)

  local remainsNpc = self:NPC_createNormal('水鏡惡魔史萊姆', 101503, { map = 60004, x = 61, y = 101, direction = 6, mapType = 0 })
  self:NPC_regWindowTalkedEvent(remainsNpc, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select == CONST.BUTTON_否 then
        return;
    end
    if select == CONST.BUTTON_是 then
        local EnemyIdAr = {406180, 406181, 406182, 406183, 406184, 406185, 406186, 406187, 406188, 406189}
        local BaseLevelAr = {66, 66, 66, 66, 66, 66, 66, 66, 66, 66}
        local BattleIndex = Battle.PVE(player, player, nil, EnemyIdAr, BaseLevelAr,  nil)
        Battle.SetWinEvent("./lua/Modules/battleMirrorDevil.lua", "DevilNpc_BattleWin", BattleIndex);
        --Battle.Encount(npc, player, "3|||0|||||3|406180|5|2|5|2|")
    end
  end)
  self:NPC_regTalkedEvent(remainsNpc, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
          if (Char.EndEvent(player,301)==1) then
                winMsg = "\\n\\n\\n@c看不出來你是擁有傲慢魂器之人\\n"
                                                  .. "\\n就讓我來秤秤你的斤兩吧！\\n"
                                                  .. "\\n水鏡惡魔不會對你們放水了\\n";
          else
                winMsg = "\\n\\n\\n@c警告！此魔物喜好鏡射複製\\n"
                                              .. "\\n你想要挑戰水鏡惡魔史萊姆嗎？\\n"
                                              .. "\\n(敵人血量隨回合數會大幅減少)\\n";
          end
          NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.BUTTON_是否, 1, winMsg);
    end
    return
  end)

end

function Module:OnbattleStartEventCallback(battleIndex)
	for i=10, 19 do
		local enemy = Battle.GetPlayIndex(battleIndex, i)
		local player = Battle.GetPlayIndex(battleIndex, i-10)
		 --print(enemy, player)
		if enemy>=0 and Char.GetData(enemy, CONST.CHAR_名字) == "水鏡惡魔史萊姆" and Char.GetData(enemy, CONST.对象_ENEMY_ID)>=406180 and Char.GetData(enemy, CONST.对象_ENEMY_ID)<= 406189  then
			if player>=0 then
 				for k, v in ipairs(playerInfo) do
					Char.SetData(enemy, v.Info, Char.GetData(player, v.Info))
					Char.SetData(enemy, CONST.对象_ENEMY_HeadGraNo,108510)
				end
			end
		end
	end
end
function Module:OnBeforeBattleTurnCommand(battleIndex)
	local Round = Battle.GetTurn(battleIndex);
	for i = 10, 19 do
		local enemy = Battle.GetPlayer(battleIndex, i);
		if Round==0 and Char.GetData(enemy, CONST.CHAR_名字) ~= "水鏡惡魔史萊姆"  then
			if enemy>=0 and Char.GetData(enemy, CONST.对象_ENEMY_ID)>=406180 and Char.GetData(enemy, CONST.对象_ENEMY_ID)<= 406189  then
				Char.SetData(enemy, CONST.CHAR_血, Char.GetData(enemy,CONST.CHAR_最大血));
				Char.SetData(enemy, CONST.CHAR_魔, Char.GetData(enemy,CONST.CHAR_最大魔));
			end
		elseif Round>=1 and Char.GetData(enemy, CONST.CHAR_名字) ~= "水鏡惡魔史萊姆"  then
			if enemy>=0 and Char.GetData(enemy, CONST.对象_ENEMY_ID)>=406180 and Char.GetData(enemy, CONST.对象_ENEMY_ID)<= 406189  then
				local player = Battle.GetPlayIndex(battleIndex, i-10);
				NLG.SystemMessage(player,"[系統]水鏡惡魔史萊姆，隨著回合慢慢失去血量");
				if (Char.EndEvent(player,301)==1) then
					HP= 1 - (Round*0.05);
					if Round>=20 then
						HP = 0.01;
					end	
				else
					HP= 1 - (Round*0.1);
					if Round>=10 then
						HP = 0.01;
					end
				end
				if player>=0 then
 					for k, v in ipairs(playerInfo) do
						Char.SetData(enemy, v.Info, Char.GetData(player, v.Info))
					end
				end
				Char.SetData(enemy, CONST.CHAR_血, Char.GetData(enemy,CONST.CHAR_最大血)*HP);
				Char.SetData(enemy, CONST.对象_ENEMY_HeadGraNo,0)
			end
		end
	end
	--[[if Round>=2 then
		Battle.SetDexRearrangeRate(battleIndex,50);
	end]]
end
function Module:OnAfterBattleTurnCommand(battleIndex)
	local Round = Battle.GetTurn(battleIndex);
	for i = 10, 19 do
		local enemy = Battle.GetPlayer(battleIndex, i);
		if Round>=1 and Char.GetData(enemy, CONST.CHAR_名字) ~= "水鏡惡魔史萊姆"  then
			local player = Battle.GetPlayIndex(battleIndex, i-10)
                                                            local HP = Char.GetData(enemy,CONST.CHAR_血);
                                                            local MP = Char.GetData(enemy,CONST.CHAR_魔);
			if enemy>=0 and Char.GetData(enemy, CONST.对象_ENEMY_ID)>=406180 and Char.GetData(enemy, CONST.对象_ENEMY_ID)<= 406189  then
				if player>=0 then
 					for k, v in ipairs(playerInfo) do
						Char.SetData(enemy, v.Info, Char.GetData(player, v.Info))
					end
				end
			end
			Char.SetData(enemy, CONST.CHAR_血, HP);
			Char.SetData(enemy, CONST.CHAR_魔, MP);
			NLG.UpChar(enemy);
		end
	end

end

function Module:OnEnemyCommandCallBack(battleIndex, side, slot, action)
      local Round = Battle.GetTurn(battleIndex);
      for i = 10, 19 do
            local devil_charIndex = Battle.GetPlayer(battleIndex, i);
            local player = Battle.GetPlayIndex(battleIndex, i-10);
            if devil_charIndex >= 0 then
                  local sidetable = {{10,30,41},{0,20,40}}
                  if Round>=1 and Char.GetData(devil_charIndex, CONST.CHAR_名字) == "水鏡惡魔史萊姆" and Char.GetData(devil_charIndex, CONST.对象_ENEMY_ID)>=406180 and Char.GetData(devil_charIndex, CONST.对象_ENEMY_ID)<= 406189  then
                          SetCom(devil_charIndex, action, CONST.BATTLE_COM.BATTLE_COM_ESCAPE, -1, 15001);
                  elseif player>=0 and Round>=1 and Char.GetData(devil_charIndex, CONST.CHAR_名字) ~= "水鏡惡魔史萊姆" and Char.GetData(devil_charIndex, CONST.对象_ENEMY_ID)>=406180 and Char.GetData(devil_charIndex, CONST.对象_ENEMY_ID)<= 406189  then
                      --SetCom(devil_charIndex, action, CONST.BATTLE_COM.BATTLE_COM_P_SPIRACLESHOT, sidetable[devilside][1], 403);
                         local skillSlot = NLG.Rand(0, 9);
                         for k, v in ipairs(skillParams) do
                             local devilside = v.side+1;
                             local devilunit = v.unit+1;
                             if Char.GetData(player, CONST.CHAR_类型) == CONST.对象类型_人  then                                --人物技能skill
                                 local devil_skillId=Char.GetSkillID(player,skillSlot);
                                 if devil_skillId==v.skillId  then
                                    local deviltech = v.techId[1] + Char.GetSkillLv(player,skillSlot) - 1;
                                    SetCom(devil_charIndex, action, v.com1, sidetable[devilside][devilunit], deviltech);
                                    return;
                                 else
                                    SetCom(devil_charIndex, action, CONST.BATTLE_COM.BATTLE_COM_ATTACK, 0, -1);
                                 end
                             elseif Char.GetData(player, CONST.CHAR_类型) == CONST.对象类型_宠  then                         --宠物技能tech
                                 local devil_techId=Pet.GetSkill(player,skillSlot);
                                 if devil_techId>=v.techId[1] and devil_techId<=v.techId[2]  then
                                    SetCom(devil_charIndex, action, v.com1, sidetable[devilside][devilunit], devil_techId);
                                    return;
                                 else
                                    SetCom(devil_charIndex, action, CONST.BATTLE_COM.BATTLE_COM_ATTACK, 0, -1);
                                 end
                             end
                         end
                  end
            end
      end
end

function Module:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
      --self:logDebug('OnDamageCalculateCallBack', charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
      local Round = Battle.GetTurn(battleIndex);
      --print(Round)
      if Round<=10 and Char.GetData(defCharIndex, CONST.对象_ENEMY_ID)>=406180 and Char.GetData(defCharIndex, CONST.对象_ENEMY_ID)<= 406189 and flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge  then
               local defHpE = Char.GetData(defCharIndex,CONST.CHAR_血);
               if damage>=defHpE-1 then
                 Char.SetData(defCharIndex, CONST.CHAR_血, defHpE+damage*1);
                 NLG.UpChar(defCharIndex);
                 damage = damage*0;
               else
                 damage = damage*0;
               end
      end
  return damage;
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

local dropMenu={
        {"怪物餅乾",900498,1},         --每10级一个掉落区间，10级以下无奖励
        {"怪物餅乾",900498,1},
        {"怪物餅乾",900498,1},
        {"怪物餅乾",900498,2},
        {"怪物餅乾",900498,2},
        {"大蒜油",900497,1},
        {"大蒜油",900497,1},
        {"大蒜油",900497,2},
        {"大蒜油",900497,2},
        {"聚魔十件套組",900605,1},
        {"噴霧十件套組",900606,1},
        {"Lv1卷軸書冊",900611,1},
        {"Lv2卷軸書冊",900612,1},
        {"地屬性結晶",69163,1},
        {"水屬性結晶",69164,1},
        {"火屬性結晶",69165,1},
        {"風屬性結晶",69166,1},
        {"神奇糖果",900504,1},
        {"魔力銀幣卡",68001,10},
}
function DevilNpc_BattleWin(battleIndex, charIndex)
	--计算平均等级及等第
	local Dm={}
	for i = 10, 19 do
		local devil_charIndex = Battle.GetPlayer(battleIndex, i);
		local player = Battle.GetPlayIndex(battleIndex, i-10);
		if player >=0 then
			local playerlv = Char.GetData(player, CONST.CHAR_等级);
			table.insert(Dm, i-10, playerlv);
		else
			table.insert(Dm, i-10, -1);
		end
	end
	--计算平均等级及等第
	local m = 0;
	local k = 0;
	for p=0,9 do
		if Dm[p]>0 then
			m = m+Dm[p];
			k = k+1;
		end
	end
	if (Char.GetData(charIndex, CONST.CHAR_地图)==60004) then
		Char.GiveItem(charIndex, 70188, 1);
	end
	local lv = math.floor(m/k);
	local lvRank = math.floor(lv/10);
	--依等第分配奖励
	for p=0,9 do
		local player = Battle.GetPlayIndex(battleIndex, p);
		local drop = math.random(0,3);
		if player>=0 and Char.GetData(player, CONST.CHAR_类型) == CONST.对象类型_人 then
			--print(lv,lvRank,drop)
			for k, v in ipairs(dropMenu) do
				if k==lvRank and lvRank>=1  then
					Char.GiveItem(player, dropMenu[k][2], dropMenu[k][3]*drop);
				end
			end
		end
	end
	Battle.UnsetWinEvent(battleIndex);
end

--偷袭设置
function Module:OnBattleSurpriseCallBack(battleIndex, result)
      --self:logDebug('OnBattleSurpriseCallBack', battleIndex, result)
      local Round = Battle.GetTurn(battleIndex);
      --print(Round)
      local Target_FloorId = Char.GetData(Battle.GetPlayer(battleIndex, 0), CONST.CHAR_地图)
      local Target_X = Char.GetData(Battle.GetPlayer(battleIndex, 0),CONST.CHAR_X)
      local Target_Y = Char.GetData(Battle.GetPlayer(battleIndex, 0),CONST.CHAR_Y)
      if Target_FloorId==1000  then
         if (Target_X>=214 and Target_X<=216 and Target_Y>=89 and Target_Y<=91) then 
            result=2;
         end
      end
  return result;
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
