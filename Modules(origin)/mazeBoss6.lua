---模块类
local Module = ModuleBase:createModule('mazeBoss6')

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
	{ Info=CONST.对象_形象 },{ Info=CONST.对象_原形 },{ Info=CONST.对象_等级 },{ Info=CONST.对象_血 },{ Info=CONST.对象_魔 },
	{ Info=CONST.对象_体力 },{ Info=CONST.对象_力量 },{ Info=CONST.对象_强度 },{ Info=CONST.对象_速度 },{ Info=CONST.对象_魔法 },
	{ Info=CONST.对象_种族 },{ Info=CONST.对象_地属性 },{ Info=CONST.对象_水属性 },{ Info=CONST.对象_火属性 },{ Info=CONST.对象_风属性 },
	{ Info=CONST.对象_抗毒 },{ Info=CONST.对象_抗睡 },{ Info=CONST.对象_抗石 },{ Info=CONST.对象_抗醉 },{ Info=CONST.对象_抗乱 },{ Info=CONST.对象_抗忘 },
	{ Info=CONST.对象_必杀 },{ Info=CONST.对象_反击 },{ Info=CONST.对象_命中 },{ Info=CONST.对象_闪躲 },
	{ Info=CONST.对象_职业 },{ Info=CONST.对象_职阶 },{ Info=CONST.对象_职类ID },
	{ Info=CONST.对象_原始图档 },{ Info=CONST.对象_名字 },{ Info=CONST.对象_最大血 },{ Info=CONST.对象_最大魔 },
	{ Info=CONST.对象_攻击力 },{ Info=CONST.对象_防御力 },{ Info=CONST.对象_敏捷 },{ Info=CONST.对象_精神 },{ Info=CONST.对象_回复 },{ Info=CONST.对象_魔攻 },{ Info=CONST.对象_魔强 },
}

local EnemySet = {}
local BaseLevelSet = {}
local Pos = {}
--local FTime = os.time()
--local Setting = 0;
--队列解释
--     五(4)	三(2)	一(0)	二(1)	四(3)
--     十(9)	八(7)	六(5)	七(6)	九(8)
------------对战NPC设置------------
local BossEnemyId = 406195;		--暴走模式设定对象
EnemySet[1] = {406189, 406189, 406189, 406189, 406189, 406195, 406189, 406189, 406189, 406189}    --0代表没有怪
BaseLevelSet[1] = {140, 140, 140, 140, 140, 150, 140, 140, 140, 140}
Pos[1] = {"羅連斯",EnemySet[1],BaseLevelSet[1]}
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
          lordName="羅連斯",
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
  self:regCallback('BattleSurpriseEvent', Func.bind(self.OnBattleSurpriseCallBack, self))
  local Lord6Npc = self:NPC_createNormal('羅連斯', 130021, { map = 7905, x = 59, y = 134, direction = 6, mapType = 0 })
  Char.SetData(Lord6Npc,CONST.对象_ENEMY_PetFlg+2,0)--可穿透体
  self:regCallback('LoopEvent', Func.bind(self.AutoLord_LoopEvent,self))
  self:NPC_regWindowTalkedEvent(Lord6Npc, function(npc, player, _seqno, _select, _data)
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
				local msg = "\\n羅連斯：\\n\\n"
					.."　原來你是時之巫女·艾露西亞派來的！\\n"
					.."　時間裁決者·賽克特曾告訴我要打擊你們\\n"
					.."　現在我總算知道為什麼他要這麼做\\n"
					.."　你們，真是一群天真的和平主義者\\n"
					.."　法蘭城的結局注定不斷輪迴……\\n";
				NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.按钮_是否, 11, msg);
		end

	end
	------------------------------------------------------------
	if seqno == 11 then
		if select == CONST.按钮_否 then
			return;
		elseif select == CONST.按钮_是 then
			if ret and #WorldDate > 0 then
				if WorldDate[6][1]==os.date("%w",os.time()) then
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
			table.insert(tbl_duel_user,player);
			WorldDate[6] = {
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
		end

	end
  end)
  self:NPC_regTalkedEvent(Lord6Npc, function(npc, player)
	if (NLG.CanTalk(npc, player) == true) then
		local msg = "\\n羅連斯：\\n\\n"
				.."　想不到這次提早回歸這個世界！\\n"
				.."　時間的沙漏被逆時者們加速，各種時間線重疊。\\n"
				.."　而你們這些時空旅者也出現了分體。\\n"
				.."　我已經說服他們加入毀滅世界，那你呢？\\n";

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
	Battle.SetWinEvent("./lua/Modules/mazeBoss6.lua", "def_round_wincallback", battleindex);

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
	SQL.Run("update lua_hook_worldboss set LordEnd6= '1' where CdKey='"..cdk.."'")
	NLG.UpChar(player);
	local PartyNum = Char.PartyNum(player);
	if (PartyNum>1) then
		for Slot=1,4 do
			local TeamPlayer = Char.GetPartyMember(player,Slot);
			if Char.IsDummy(TeamPlayer)==false then
				local cdk = Char.GetData(TeamPlayer,CONST.对象_CDK);
				--SQL.Run("INSERT INTO lua_hook_worldboss (Name,CdKey) SELECT Name,CdKey FROM tbl_character WHERE NOT EXISTS ( SELECT Name FROM lua_hook_worldboss WHERE tbl_character.CdKey=lua_hook_worldboss.CdKey)");
				SQL.Run("update lua_hook_worldboss set LordEnd6= '1' where CdKey='"..cdk.."'")
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

	--[[local ret = SQL.Run("select Name,WorldLord6 from lua_hook_worldboss where CdKey='"..cdk.."'");
	if(type(ret)=="table" and ret["0_1"]~=nil)then
		LordHP6=tonumber(ret["0_1"]);
	end]]

	local LordHP6 = tonumber(SQL.Run("select WorldLord6 from lua_hook_worldboss where CdKey='"..cdk.."'")["0_0"])
	for i = 10, 19 do
		local enemy = Battle.GetPlayer(battleIndex, i);
		local player = Battle.GetPlayIndex(battleIndex, i-10)
		local HP = LordHP6;
		if (HP<=1000) then
			HP = LordHP6*100;
		end
		if enemy>=0 and Char.GetData(enemy, CONST.对象_ENEMY_ID)==406189  then
			--Char.SetData(enemy, CONST.对象_最大血, 1000000);
			--Char.SetData(enemy, CONST.对象_血, HP);
			if player>=0 then
 				for k, v in ipairs(playerInfo) do
					Char.SetData(enemy, v.Info, Char.GetData(player, v.Info))
				end
			end
		elseif enemy>=0 and Char.GetData(enemy, CONST.对象_ENEMY_ID)==BossEnemyId  then
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

	--[[local ret = SQL.Run("select Name,WorldLord6 from lua_hook_worldboss where CdKey='"..cdk.."'");
	if(type(ret)=="table" and ret["0_1"]~=nil)then
		LordHP6=tonumber(ret["0_1"]);
	end]]
	local LordHP6 = tonumber(SQL.Run("select WorldLord6 from lua_hook_worldboss where CdKey='"..cdk.."'")["0_0"])
	--print(LordHP6)
	for i = 10, 19 do
		local enemy = Battle.GetPlayer(battleIndex, i);
		local HP = LordHP6;
		if (HP<=1000 and Round<1) then
			HP = HP*200;
		end
		if Round==0 and enemy>=0 and Char.GetData(enemy, CONST.对象_ENEMY_ID)==406189  then
			Char.SetData(enemy, CONST.对象_血, Char.GetData(enemy,CONST.对象_最大血));
			Char.SetData(enemy, CONST.对象_魔, Char.GetData(enemy,CONST.对象_最大魔));
		elseif Round>0 and enemy>=0 and Char.GetData(enemy, CONST.对象_ENEMY_ID)==406189  then
			local player = Battle.GetPlayIndex(battleIndex, i-10);
			if player>=0 then
 				for k, v in ipairs(playerInfo) do
					Char.SetData(enemy, v.Info, Char.GetData(player, v.Info))
				end
			end
		elseif Round==0 and enemy>=0 and Char.GetData(enemy, CONST.对象_ENEMY_ID)==BossEnemyId  then
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
		if Round>=0 and enemy>=0 and Char.GetData(enemy, CONST.对象_ENEMY_ID)==406189  then
			local player = Battle.GetPlayIndex(battleIndex, i-10)
			local HP = Char.GetData(enemy,CONST.对象_血);
			local MP = Char.GetData(enemy,CONST.对象_魔);
			if player>=0 then
 				for k, v in ipairs(playerInfo) do
					Char.SetData(enemy, v.Info, Char.GetData(player, v.Info))
				end
			end
			Char.SetData(enemy, CONST.对象_血, HP);
			Char.SetData(enemy, CONST.对象_魔, MP);
		elseif Round>=1 and enemy>=0 and Char.GetData(enemy, CONST.对象_ENEMY_ID)==BossEnemyId  then
			local HP = Char.GetData(enemy,CONST.对象_血);
			Char.SetData(enemy, CONST.对象_最大血, 1000000);
			Char.SetData(enemy, CONST.对象_血, HP);
			NLG.SystemMessage(player,"[系統]羅連斯目前剩餘血量"..HP.."！");
			--Lord血量写入库
			if (cdk~=nil) then
				--SQL.Run("INSERT INTO lua_hook_worldboss (Name,CdKey) SELECT Name,CdKey FROM tbl_character WHERE NOT EXISTS ( SELECT Name FROM lua_hook_worldboss WHERE CdKey='"..cdk.."')");
				SQL.Run("update lua_hook_worldboss set WorldLord6= '"..HP.."' where CdKey='"..cdk.."'")
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
		local player = Battle.GetPlayIndex(battleIndex, i-10);
		local sidetable = {{10,30,41},{0,20,40}}
		if Round>=1 and enemy>= 0 and Char.GetData(enemy, CONST.对象_名字) == "時空獸" then
			SetCom(enemy, action, CONST.BATTLE_COM.BATTLE_COM_ESCAPE, -1, 15001);
		elseif Round>=1 and enemy>= 0 and player>=0 and Char.GetData(enemy, CONST.对象_ENEMY_ID)==406189  then
			local skillSlot = NLG.Rand(0, 9);
			for k, v in ipairs(skillParams) do
				local devilside = v.side+1;
				local devilunit = v.unit+1;
				if Char.GetData(player, CONST.对象_类型) == CONST.对象类型_人  then                                --人物技能skill
					local devil_skillId=Char.GetSkillID(player,skillSlot);
					if devil_skillId==v.skillId  then
						local deviltech = v.techId[1] + Char.GetSkillLv(player,skillSlot) - 1;
						SetCom(enemy, action, v.com1, sidetable[devilside][devilunit], deviltech);
						return;
					else
						SetCom(enemy, action, CONST.BATTLE_COM.BATTLE_COM_ATTACK, 0, -1);
					end
				elseif Char.GetData(player, CONST.对象_类型) == CONST.对象类型_宠  then                         --宠物技能tech
					local devil_techId=Pet.GetSkill(player,skillSlot);
					if devil_techId>=v.techId[1] and devil_techId<=v.techId[2]  then
						SetCom(enemy, action, v.com1, sidetable[devilside][devilunit], devil_techId);
						return;
					else
						SetCom(enemy, action, CONST.BATTLE_COM.BATTLE_COM_ATTACK, 0, -1);
					end
				end
			end
		elseif Round>=5 and Round<=9 and enemy>= 0 and Char.GetData(enemy, CONST.对象_ENEMY_ID)==BossEnemyId  then
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
	if (Round<1 and flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge)  then
		if (Char.GetData(defCharIndex, CONST.对象_ENEMY_ID)==406189 or Char.GetData(defCharIndex, CONST.对象_ENEMY_ID)==BossEnemyId)  then
			local defHpE = Char.GetData(defCharIndex,CONST.对象_血);
			if (damage>=defHpE-1) then
				Char.SetData(defCharIndex, CONST.对象_血, defHpE+damage*1);
				NLG.UpChar(defCharIndex);
				NLG.SystemMessage(charIndex,"[系統]目前無法受到傷害！");
				damage = damage*0;
			else
				damage = damage*0;
			end
		end
	end
	return damage;
end

--偷袭设置
function Module:OnBattleSurpriseCallBack(battleIndex, result)
      --self:logDebug('OnBattleSurpriseCallBack', battleIndex, result)
      local Round = Battle.GetTurn(battleIndex);
      --print(Round)
      local Target_FloorId = Char.GetData(Battle.GetPlayer(battleIndex, 0), CONST.对象_地图)
      local Target_X = Char.GetData(Battle.GetPlayer(battleIndex, 0),CONST.对象_X)
      local Target_Y = Char.GetData(Battle.GetPlayer(battleIndex, 0),CONST.对象_Y)
      if Target_FloorId==7905  then
         result=1;
      end
  return result;
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;