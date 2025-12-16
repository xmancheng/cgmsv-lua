---模块类
local Module = ModuleBase:createModule('playerBattle')

local Open = 0;
local PKArena = {
      { pkType=1, walkMode=1, opponentsName="時雨", opponentsImage=106477, opponentsArea={map=1401,X=21,Y=35,dir=6,action=1},
      ai_list={'時雨','忍者',106477,154,150,201,'500|不改|不改|不改|250|不改|不改|200|15|15|15|15|800|999'} },
      { pkType=2, walkMode=1, opponentsName="時雨", opponentsImage=106477, opponentsArea={map=1401,X=22,Y=35,dir=6,action=1},
      ai_list={'時雨','忍者',106477,154,150,201,'500|不改|不改|不改|250|不改|不改|200|15|15|15|15|800|999'} },
      { pkType=3, walkMode=1, opponentsName="時雨", opponentsImage=106477, opponentsArea={map=1401,X=22,Y=35,dir=6,action=1},
      ai_list={'時雨','忍者',106477,154,150,201,'500|不改|不改|不改|250|不改|不改|200|15|15|15|15|800|999'} },
      { pkType=4, walkMode=1, opponentsName="時雨", opponentsImage=106477, opponentsArea={map=1401,X=22,Y=35,dir=6,action=1},
      ai_list={'時雨','忍者',106477,154,150,201,'500|不改|不改|不改|250|不改|不改|200|15|15|15|15|800|999'} },
      { pkType=5, walkMode=1, opponentsName="時雨", opponentsImage=106477, opponentsArea={map=1401,X=23,Y=35,dir=6,action=1},
      ai_list={'時雨','忍者',106477,154,150,201,'500|不改|不改|不改|250|不改|不改|200|15|15|15|15|800|999'} },
      { pkType=6, walkMode=1, opponentsName="時雨", opponentsImage=106477, opponentsArea={map=1401,X=23,Y=35,dir=6,action=1},
      ai_list={'時雨','忍者',106477,154,150,201,'500|不改|不改|不改|250|不改|不改|200|15|15|15|15|800|999'} },
      { pkType=7, walkMode=1, opponentsName="時雨", opponentsImage=106477, opponentsArea={map=1401,X=23,Y=35,dir=6,action=1},
      ai_list={'時雨','忍者',106477,154,150,201,'500|不改|不改|不改|250|不改|不改|200|15|15|15|15|800|999'} },
      { pkType=8, walkMode=1, opponentsName="時雨", opponentsImage=106477, opponentsArea={map=1401,X=24,Y=35,dir=6,action=1},
      ai_list={'時雨','忍者',106477,154,150,201,'500|不改|不改|不改|250|不改|不改|200|15|15|15|15|800|999'} },
      { pkType=9, walkMode=1, opponentsName="時雨", opponentsImage=106477, opponentsArea={map=1401,X=24,Y=35,dir=6,action=1},
      ai_list={'時雨','忍者',106477,154,150,201,'500|不改|不改|不改|250|不改|不改|200|15|15|15|15|800|999'} },
      { pkType=10, walkMode=1, opponentsName="時雨", opponentsImage=106477, opponentsArea={map=1401,X=24,Y=35,dir=6,action=1},
      ai_list={'時雨','忍者',106477,154,150,201,'500|不改|不改|不改|250|不改|不改|200|15|15|15|15|800|999'} },
      { pkType=11, walkMode=1, opponentsName="時雨", opponentsImage=106477, opponentsArea={map=1401,X=25,Y=35,dir=6,action=1},
      ai_list={'時雨','忍者',106477,154,150,201,'500|不改|不改|不改|250|不改|不改|200|15|15|15|15|800|999'} },
      { pkType=12, walkMode=1, opponentsName="時雨", opponentsImage=106477, opponentsArea={map=1401,X=25,Y=35,dir=6,action=1},
      ai_list={'時雨','忍者',106477,154,150,201,'500|不改|不改|不改|250|不改|不改|200|15|15|15|15|800|999'} },
      { pkType=13, walkMode=1, opponentsName="時雨", opponentsImage=106477, opponentsArea={map=1401,X=25,Y=35,dir=6,action=1},
      ai_list={'時雨','忍者',106477,154,150,201,'500|不改|不改|不改|250|不改|不改|200|15|15|15|15|800|999'} },
      { pkType=14, walkMode=1, opponentsName="時雨", opponentsImage=106477, opponentsArea={map=1401,X=25,Y=35,dir=6,action=1},
      ai_list={'時雨','忍者',106477,154,150,201,'500|不改|不改|不改|250|不改|不改|200|15|15|15|15|800|999'} },
      { pkType=15, walkMode=1, opponentsName="時雨", opponentsImage=106477, opponentsArea={map=1401,X=25,Y=35,dir=6,action=1},
      ai_list={'時雨','忍者',106477,154,150,201,'500|不改|不改|不改|250|不改|不改|200|15|15|15|15|800|999'} },
      { pkType=16, walkMode=1, opponentsName="時雨", opponentsImage=106477, opponentsArea={map=1401,X=26,Y=35,dir=6,action=1},
      ai_list={'時雨','忍者',106477,154,150,201,'500|不改|不改|不改|250|不改|不改|200|15|15|15|15|800|999'} },
      { pkType=17, walkMode=1, opponentsName="時雨", opponentsImage=106477, opponentsArea={map=1401,X=26,Y=35,dir=6,action=1},
      ai_list={'時雨','忍者',106477,154,150,201,'500|不改|不改|不改|250|不改|不改|200|15|15|15|15|800|999'} },
      { pkType=18, walkMode=1, opponentsName="時雨", opponentsImage=106477, opponentsArea={map=1401,X=26,Y=35,dir=6,action=1},
      ai_list={'時雨','忍者',106477,154,150,201,'500|不改|不改|不改|250|不改|不改|200|15|15|15|15|800|999'} },
      { pkType=19, walkMode=1, opponentsName="時雨", opponentsImage=106477, opponentsArea={map=1401,X=26,Y=35,dir=6,action=1},
      ai_list={'時雨','忍者',106477,154,150,201,'500|不改|不改|不改|250|不改|不改|200|15|15|15|15|800|999'} },
      { pkType=20, walkMode=1, opponentsName="時雨", opponentsImage=106477, opponentsArea={map=1401,X=26,Y=35,dir=6,action=1},
      ai_list={'時雨','忍者',106477,154,150,201,'500|不改|不改|不改|250|不改|不改|200|15|15|15|15|800|999'} },
}

local dummylevel = 100;
local equipConstant = {--初始化快捷装备参数常量
	CONST.道具_生命,CONST.道具_魔力,CONST.道具_攻击,CONST.道具_防御,CONST.道具_敏捷,CONST.道具_精神,CONST.道具_魔攻,
	CONST.道具_魔抗,CONST.道具_反击,CONST.道具_命中,CONST.道具_必杀,CONST.道具_闪躲,CONST.道具_回复,CONST.道具_魅力,
}
local change_list={
name = {'小明劍士','中正路勇者','黑色戰士','老王不賣了','雞排要加辣','刀下不留人','小志很兇','Kill小黑','Dark阿凱','冰封之心','赤焰法王','風之旅人','白銀之刃','地獄火','蒼月','銀狼','無情','亞爾迪斯','米卡艾爾','露娜菲爾','瑟莉絲','菲歐娜','暗黑破壞神',},
image = {105002,105014,105027,105039,105045,105052,105064,105095,105102,105127,105252,105258,105264,105270,105277,105289,105302,105320,105333,105352,105377,106002,106033,106052,106095,106114,106127,106252,106264,106277,106283,106295,106302,106314,106327,106352,106377,},
jobname = {'弓箭手','劍士','戰斧鬥士','騎士','格鬥','魔法師','傳教士','巫師',},
job = { {44,40},{14,10},{24,20},{34,30},{144,140},{74,70},{64,60},{134,130}, },
equip = {--'武器血|武器魔|武器攻|武器防|武器敏|武器精|武器魔攻|武器魔抗|武器反|武器命|武器必|武器闪|武器回|武器魅'
     {215,'200|200|219|135|64|不改|不改|不改|不改|15|11|25|200|999'},
     {201,'200|200|300|315|不改|不改|不改|35|不改|-5|不改|65|200|999'},
     {206,'200|200|331|294|-72|不改|不改|35|不改|-5|36|45|200|999'},
     {211,'200|200|252|425|不改|不改|不改|135|15|10|不改|45|200|999'},
     {250,'200|200|50|235|64|不改|不改|100|不改|20|5|20|200|999'},
     {220,'200|550|不改|160|17|65|200|不改|不改|不改|不改|10|200|999'},
     {220,'300|550|不改|160|17|65|200|不改|不改|不改|不改|10|400|999'},
     {220,'300|550|不改|160|17|65|200|不改|不改|不改|不改|10|400|999'},
  },
}

------------------------------------------------
local FTime = os.time();			--时间表
tbl_PKArenaNPCIndex = tbl_PKArenaNPCIndex or {}
------------------------------------------------
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self))
  self:regCallback('LoopEvent', Func.bind(self.PKArena_LoopEvent,self))
  self:regCallback('BeforeBattleTurnEvent', Func.bind(self.handleBattleAutoCommand, self))

end

function Module:handleBattleAutoCommand(battleIndex)
	local player = {}
	if Battle.GetType(battleIndex) == CONST.战斗_PVP then
		local side=0
		local leader1 = Battle.GetPlayer(battleIndex,0)
		local leader2 = Battle.GetPlayer(battleIndex,5)
		local leader3 = Battle.GetPlayer(battleIndex,10)
		local leader4 = Battle.GetPlayer(battleIndex,15)
		if Char.IsPlayer(leader1) and Char.IsDummy(leader1) then
			ai_leader = leader1
			side=0
		elseif Char.IsPlayer(leader2) and Char.IsDummy(leader2) then
			ai_leader = leader2
			side=0
		elseif Char.IsPlayer(leader3) and Char.IsDummy(leader3) then
			ai_leader = leader3
			side=1
		elseif Char.IsPlayer(leader4) and Char.IsDummy(leader4) then
			ai_leader = leader4
			side=1
		end
		local sidetable = {{NLG.Rand(10,19),NLG.Rand(30,39),41},{NLG.Rand(0,9),NLG.Rand(20,29),40},}
		local charside = side+1;

		for i = 0, 19 do
			local ai_index = Battle.GetPlayer(battleIndex, i)
			if ai_index >= 0 then
				if Char.IsPlayer(ai_index) then--收录人的index
					player[i] = ai_index
				end

				if Char.IsDummy(ai_index) and Char.GetData(ai_index,CONST.对象_地图)~=777 then--ai判断
					player[i] = ai_index
					--print('ai自动战斗：',ai_index,petindex)
					if Battle.IsWaitingCommand(ai_index) then--职业使用技能判断
						local 职业类 = Char.GetData(ai_index,CONST.对象_职类ID)
						local 战斗指令接口 = CONST.BATTLE_COM--别改，会爆炸
						local 技能选择接口 = Battle.ActionSelect--别改，会爆炸
						--第1动
						if 职业类 == 40 then--弓
							local 技能表 = {
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_RANDOMSHOT,math.random(0,9),9509) end,--乱射
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_DELAYATTACK,math.random(0,9),25809) end,--一击必中
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_DODGE,math.random(0,9),909) end,--阳炎
							}
							if math.random(1,100) < 70 then--乱射释放概率70%
								pcall(技能表[1])
							else--其它技能随机施放
								local 随机施放 = math.random(1,#技能表)
								pcall(技能表[随机施放])
							end
						end
						if 职业类 == 10 then--剑
							local 技能表 = {
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_FIRSTATTACK,math.random(0,9),26209) end,--迅速
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_BLASTWAVE,math.random(0,9),200509) end,--剑气--请确认你的tech也是这个编号
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_PARAMETER,math.random(0,9),309) end,--乾坤
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_PARAMETER,math.random(0,9),109) end,--诸刃
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_RENZOKU,math.random(0,9),9) end,--连击破碎
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_RENZOKU,math.random(0,9),8) end,--连击乱舞
							}
							local 随机施放 = math.random(1,#技能表)
							pcall(技能表[随机施放])
						end
						if 职业类 == 20 then--斧
							local 技能表 = {
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_DELAYATTACK,math.random(0,9),25709) end,--戒骄戒躁
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_PARAMETER,math.random(0,9),309) end,--乾坤
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_PARAMETER,math.random(0,9),109) end,--诸刃
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_RENZOKU,math.random(0,9),9) end,--连击破碎
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_RENZOKU,math.random(0,9),8) end,--连击乱舞
							}
							if math.random(1,100) < 70 then--戒骄戒躁释放概率70%
								pcall(技能表[1])
							else--其它技能随机施放
								local 随机施放 = math.random(1,#技能表)
								pcall(技能表[随机施放])
							end
						end
						if 职业类 == 30 then--骑
							local 技能表 = {
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_BILLIARD,math.random(5,9),26009) end,--一石二鸟
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_PARAMETER,math.random(0,9),309) end,--乾坤
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_PARAMETER,math.random(0,9),109) end,--诸刃
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_RENZOKU,math.random(0,9),9) end,--连击破碎
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_RENZOKU,math.random(0,9),8) end,--连击乱舞
							}
							if math.random(1,100) < 50 then--一石二鸟释放概率50%
								pcall(技能表[1])
							else--其它技能随机施放
								local 随机施放 = math.random(1,#技能表)
								pcall(技能表[随机施放])
							end
						end
						if 职业类 == 140 then--格
							local 技能表 = {
								function() 技能选择接口(ai_index, 战斗指令接口.BATTLE_COM_P_SPIRACLESHOT,math.random(0,9),409) end,--气功弹
								function() 技能选择接口(ai_index, 战斗指令接口.BATTLE_COM_P_PANIC,math.random(0,9),9409) end,--混乱攻击
								function() 技能选择接口(ai_index, 战斗指令接口.BATTLE_COM_P_GUARDBREAK,math.random(0,9),509) end,--崩击
							}
							if math.random(1,100) < 70 then--气功弹释放概率70%
								pcall(技能表[1])
							else--其它技能随机施放
								local 随机施放 = math.random(1,#技能表)
								pcall(技能表[随机施放])
							end
						end
						if 职业类 == 70 then--魔
							local 技能表 = {
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_MAGIC,40,2709) end,--超陨
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_MAGIC,40,2809) end,--超冰
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_MAGIC,40,2909) end,--超火
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_MAGIC,40,3009) end,--超风
							}
							local 随机施放 = math.random(1,#技能表)
							pcall(技能表[随机施放])
						end
						if 职业类 == 60 then--传
							local 技能表 = {
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_HEAL,41,6309) end,--超强补血
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_HEAL,math.random(30,39),6209) end,--强力补血
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_HEAL,math.random(10,91),6109) end,--补血
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_REVIVE,math.random(10,19),6809) end,--气绝
							}
							if math.random(1,100) < 70 then--超强补血释放概率70%
								pcall(技能表[1])
							else--其它技能随机施放
								local 随机施放 = math.random(1,#技能表)
								pcall(技能表[随机施放])
							end
						end
						if 职业类 == 130 then--巫
							local 技能表 = {
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_LP_RECOVERY,41,6609) end,--超强恢复
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_STATUSRECOVER,41,6709) end,--洁净
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_REVIVE,math.random(10,19),6809) end,--气绝
							}
							local 随机施放 = math.random(1,#技能表)
							pcall(技能表[随机施放])
						end
						if 职业类 == 80 then--咒
							local 技能表 = {
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_STATUSCHANGE,40,4409) end,--超强毒
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_STATUSCHANGE,40,4509) end,--超强睡
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_STATUSCHANGE,40,4609) end,--超强石
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_STATUSCHANGE,40,4709) end,--超强醉
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_STATUSCHANGE,40,4809) end,--超强乱
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_STATUSCHANGE,40,4909) end,--超强忘
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_REVERSE_TYPE,math.random(10,19),5409) end,--属性反转
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_REFLECTION_PHYSICS,math.random(10,19),5509) end,--攻反
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_INEFFECTIVE_PHYSICS,math.random(10,19),5909) end,--攻无
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_ABSORB_PHYSICS,math.random(10,19),5709) end,--攻吸
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_REFLECTION_MAGIC,math.random(10,19),5609) end,--魔反
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_INEFFECTIVE_MAGIC,math.random(10,19),6009) end,--魔无
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_ABSORB_MAGIC,math.random(10,19),5809) end,--魔吸
							}
							if math.random(1,100) < 50 then--超咒放概率50%
								local 随机施放 = math.random(1,6)
								pcall(技能表[随机施放])
							else--其它技能随机施放
								local 随机施放 = math.random(7,#技能表)
								pcall(技能表[随机施放])
							end
						end
						if 职业类 == 150 then--忍
							local 技能表 = {
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_ASSASSIN,math.random(0,9),9609) end,--暗杀
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_P_DODGE,math.random(0,9),909) end,--阳炎
								--function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_ATTACKALL,math.random(10,19),10601) end,--影分身--请确认你的tech也是这个编号
							}
							if Battle.GetType(battleIndex) == CONST.战斗_BOSS战 then--boss战，不暗杀
								local 随机施放 = math.random(1,#技能表)
								pcall(技能表[随机施放])
							else
								if math.random(1,100) < 20 then--暗杀概率50%
									pcall(技能表[1])
								else
									local 随机施放 = math.random(1,#技能表)
									pcall(技能表[随机施放])
								end
							end
						end
						--第2动
						--local petindex = Battle.GetPlayer(battleIndex,math.fmod(i + 5,10))
						local petindex = Char.GetPet(ai_index,0)
						if petindex >= 0 then--如果带宠物，宠物使用技能
							--print('宠物名字 = '..Char.GetData(petindex,CONST.对象_名字))
							local 宠物技能表 = {--宠物施放的技能，需要宠物真的有学这个技能，否则无法施放，最多10个，人不用学，也无限制
								--function() 技能选择接口(petindex,战斗指令接口.BATTLE_COM_ATTACK,math.random(10,19),-1) end,--攻击
								--function() 技能选择接口(petindex,战斗指令接口.BATTLE_COM_GUARD,-1,-1) end,--防御
								function() 技能选择接口(petindex,战斗指令接口.BATTLE_COM_P_SPECIALGARD,-1,838) end,--圣盾
								function() 技能选择接口(petindex,战斗指令接口.BATTLE_COM_P_RENZOKU,math.random(0,9),38) end,--连击
								function() 技能选择接口(petindex,战斗指令接口.BATTLE_COM_P_PARAMETER,math.random(0,9),138) end,--诸刃
								function() 技能选择接口(petindex,战斗指令接口.BATTLE_COM_P_PARAMETER,math.random(0,9),338) end,--乾坤
								function() 技能选择接口(petindex,战斗指令接口.BATTLE_COM_P_MAGIC,math.random(20,29),2339) end,--强力陨石魔法
								function() 技能选择接口(petindex,战斗指令接口.BATTLE_COM_P_MAGIC,math.random(20,29),2439) end,--强力冰冻魔法
								function() 技能选择接口(petindex,战斗指令接口.BATTLE_COM_P_MAGIC,math.random(20,29),2539) end,--强力火焰魔法
								function() 技能选择接口(petindex,战斗指令接口.BATTLE_COM_P_MAGIC,math.random(20,29),2639) end,--强力风刃魔法
								function() 技能选择接口(petindex,战斗指令接口.BATTLE_COM_M_BLOODATTACK,math.random(0,9),8138) end,--吸血攻击
								function() 技能选择接口(petindex,战斗指令接口.BATTLE_COM_M_STATUSATTACK,math.random(0,9),7738) end,--石化攻击
							}
							local 随机施放 = math.random(1,#宠物技能表)
							--print('随机 = '..随机施放)
							pcall(宠物技能表[随机施放])
						else--没带宠物，ai佣兵2动普攻
							local 技能表 = {
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_ATTACK,math.random(0,9),-1) end,--攻击
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_GUARD,-1,-1) end,--防御
								function() 技能选择接口(ai_index,战斗指令接口.BATTLE_COM_POSITION,-1,-1) end,--换位、定点移动
							}
							local 随机施放 = math.random(1, #技能表)
							pcall(技能表[随机施放])
						end
					end
				end
			end
		end
	end
end

function Module:handleTalkEvent(charIndex,msg,color,range,size)
	if (msg=="/battle" and Open==0) then
		leader_tbl = {}
		for k,v in pairs(PKArena) do
			if (tbl_PKArenaNPCIndex[k] == nil) then
				tbl_PKArenaNPCIndex[k] = {}
			end
			local opponentsIndex = Char.CreateDummy()
			tbl_PKArenaNPCIndex[k] = opponentsIndex;
			Char.SetLoopEvent('./lua/Modules/playerBattle.lua','PKArena_LoopEvent',tbl_PKArenaNPCIndex[k], 1000);
			Char.SetData(opponentsIndex,CONST.对象_名字, v.opponentsName);
			Char.SetData(opponentsIndex,CONST.对象_形象, v.opponentsImage);
			Char.SetData(opponentsIndex,CONST.对象_原形, v.opponentsImage);
			Char.SetData(opponentsIndex,CONST.对象_方向, v.opponentsArea.dir);

			Char.SetData(opponentsIndex, CONST.对象_魅力, 100)
			Char.SetData(opponentsIndex, CONST.对象_等级, dummylevel)
			Char.SetData(opponentsIndex, CONST.对象_种族, 0)--人形系
			Char.SetData(opponentsIndex, CONST.对象_职业, v.ai_list[4])
			Char.SetData(opponentsIndex, CONST.对象_职类ID, v.ai_list[5])
			Char.SetData(opponentsIndex, CONST.对象_职阶, 3)--3转正式职业

			local 人_攻击力 = (15+(dummylevel-1)*2)*100;
			local 人_体力 = (15+(dummylevel-1)*2 - 90)*100;
			if (v.ai_list[5]==70) then--魔
				人_攻击力 = 0;
				人_魔法 = (15+(dummylevel-1)*2)*100;
			elseif (v.ai_list[5]==60 or v.ai_list[5]==130 or v.ai_list[5]==80) then--传巫咒
				人_攻击力 = 0;
				人_体力 = (15+(dummylevel-1)*2)*100;
				人_魔法 = (15+(dummylevel-1)*2 - 90)*100;
			end
			Char.SetData(opponentsIndex, CONST.对象_体力, 人_体力)
			Char.SetData(opponentsIndex, CONST.对象_力量, 人_攻击力)
			Char.SetData(opponentsIndex, CONST.对象_强度, 0)
			Char.SetData(opponentsIndex, CONST.对象_速度, 9000)
			Char.SetData(opponentsIndex, CONST.对象_魔法, 0)

			local itemindex = Char.GiveItem(opponentsIndex, v.ai_list[6], 1)--给1件装备
			Item.SetData(itemindex,CONST.道具_已鉴定,1)
			Item.SetData(itemindex,CONST.道具_等级,1)
			local equipMod = string.split(v.ai_list[7],'|')
			for k,v in pairs(equipMod) do
				if v == '不改' then
					equipMod[k] = false
				else
					equipMod[k] = tonumber(v)
				end
			end
			for i = 1,#equipMod do--开始篡改
				if equipMod[i] then
					Item.SetData(itemindex,equipConstant[i],equipMod[i]);
				end
			end
			Item.UpItem(opponentsIndex,-1);
			NLG.UpChar(opponentsIndex);
			local nowitemslot = Char.GetItemSlot(opponentsIndex, itemindex);
			local stat = false
			if v.ai_list[5] == 140 then
				Char.MoveItem(opponentsIndex, nowitemslot, CONST.位置_身, -1)
			else
				Char.MoveItem(opponentsIndex, nowitemslot, CONST.位置_左手, -1)
			end

			local itemindex = Char.GiveItem(opponentsIndex, math.random(9205,9240), 1)--给随机水晶
			Item.SetData(itemindex,CONST.道具_已鉴定,1)
			Item.UpItem(opponentsIndex,-1)
			NLG.UpChar(opponentsIndex)
			local nowitemslot = Char.GetItemSlot(opponentsIndex, itemindex)
			Char.MoveItem(opponentsIndex, nowitemslot, CONST.位置_水晶, -1)

			Char.SetData(opponentsIndex,CONST.对象_对战开关, 1);
			Char.Warp(opponentsIndex, 0, v.opponentsArea.map, v.opponentsArea.X, v.opponentsArea.Y);
			--NLG.SetAction(opponentsIndex, v.opponentsArea.action);
			NLG.UpChar(opponentsIndex);

			--[[if (v.walkMode==1) then
				Char.SetData(opponentsIndex,CONST.对象_经验, v.opponentsArea.map);
				Char.SetData(opponentsIndex,CONST.对象_名色, 4);
				NLG.UpChar(opponentsIndex);
				--Char.SetAutoWalk(opponentsIndex, true, 5, 10, 1, 3, 1, 3);--未生效
			end]]
			if (k==1 or k==2 or k==5 or k==8 or k==11 or k==16) then	--隊長
				Char.SetTempData(opponentsIndex,'假人队长',1);
				table.insert(leader_tbl,opponentsIndex);
			else
				if k>=3 and k<=4 then Char.JoinParty(opponentsIndex, leader_tbl[2], true);
				elseif k>=6 and k<=7 then Char.JoinParty(opponentsIndex, leader_tbl[3], true);
				elseif k>=9 and k<=10 then Char.JoinParty(opponentsIndex, leader_tbl[4], true);
				elseif k>=12 and k<=15 then Char.JoinParty(opponentsIndex, leader_tbl[5], true);
				elseif k>=17 and k<=20 then Char.JoinParty(opponentsIndex, leader_tbl[6], true);
				end
			end
		end
        Open = 1;
		return 0;
	elseif (msg=="/battle" and Open==1) then
		return 0;
	end
	return 1;
end

function PKArena_LoopEvent(npc)
	local opponentsIndex = npc;
	--local CTime = tonumber(os.date("%H",FTime));
	local HTime = tostring(Char.GetTempData(opponentsIndex,'假人重置')) or "00";
	if ( HTime=="00" or tostring(os.date("%H",os.time()))~=HTime) then
			Char.SetTempData(opponentsIndex,'假人重置', tostring(os.date("%H",os.time())));
			Char.SetData(opponentsIndex,CONST.对象_名字, change_list.name[NLG.Rand(1,#change_list.name)]);
			Char.SetData(opponentsIndex,CONST.对象_形象, change_list.image[NLG.Rand(1,#change_list.image)]);
			Char.SetData(opponentsIndex,CONST.对象_原形, change_list.image[NLG.Rand(1,#change_list.image)]);
			local rand = NLG.Rand(1,8);
			Char.SetData(opponentsIndex,CONST.对象_职业, change_list.job[rand][1]);
			Char.SetData(opponentsIndex,CONST.对象_职类ID, change_list.job[rand][2]);

			local jobType = Char.GetData(opponentsIndex,CONST.对象_职类ID);
			local 人_攻击力 = (15+(dummylevel-1)*2)*100;
			local 人_体力 = (15+(dummylevel-1)*2 - 90)*100;
			if (jobType==70) then--魔
				人_攻击力 = 0;
				人_魔法 = (15+(dummylevel-1)*2)*100;
			elseif (jobType==60 or jobType==130 or jobType==80) then--传巫咒
				人_攻击力 = 0;
				人_体力 = (15+(dummylevel-1)*2)*100;
				人_魔法 = (15+(dummylevel-1)*2 - 90)*100;
			end
			Char.SetData(opponentsIndex, CONST.对象_体力, 人_体力)
			Char.SetData(opponentsIndex, CONST.对象_力量, 人_攻击力)
			Char.SetData(opponentsIndex, CONST.对象_强度, 0)
			Char.SetData(opponentsIndex, CONST.对象_速度, 9000)
			Char.SetData(opponentsIndex, CONST.对象_魔法, 0)
			NLG.UpChar(opponentsIndex);

			local itemindex = Char.GiveItem(opponentsIndex, change_list.equip[rand][1], 1)--给1件装备
			Item.SetData(itemindex,CONST.道具_已鉴定,1)
			Item.SetData(itemindex,CONST.道具_等级,1)
			local equipMod = string.split(change_list.equip[rand][2],'|')
			for k,v in pairs(equipMod) do
				if v == '不改' then
					equipMod[k] = false
				else
					equipMod[k] = tonumber(v)
				end
			end
			for i = 1,#equipMod do--开始篡改
				if equipMod[i] then
					Item.SetData(itemindex,equipConstant[i],equipMod[i]);
				end
			end
			Item.UpItem(opponentsIndex,-1);
			NLG.UpChar(opponentsIndex);
			local nowitemslot = Char.GetItemSlot(opponentsIndex, itemindex);
			local stat = false
			if jobType == 140 then
				Char.MoveItem(opponentsIndex, nowitemslot, CONST.位置_身, -1)
			else
				Char.MoveItem(opponentsIndex, nowitemslot, CONST.位置_左手, -1)
			end

			local itemindex = Char.GiveItem(opponentsIndex, math.random(9205,9240), 1)--给随机水晶
			Item.SetData(itemindex,CONST.道具_已鉴定,1)
			Item.UpItem(opponentsIndex,-1)
			NLG.UpChar(opponentsIndex)
			local nowitemslot = Char.GetItemSlot(opponentsIndex, itemindex)
			Char.MoveItem(opponentsIndex, nowitemslot, CONST.位置_水晶, -1)

			Char.AddSkill(opponentsIndex, 71)--调教
			Char.SetSkillLevel(opponentsIndex,0,10)
			local petindex = -1
			repeat
				petindex = Char.GivePet(opponentsIndex, math.random(1,904))--给随机宠物
			until petindex > 0
			Char.SetData(petindex,CONST.对象_忠诚,100)
			Char.SetData(petindex,CONST.对象_基础忠诚,100)
			Char.SetPetDepartureState(opponentsIndex, 0, CONST.PET_STATE_战斗)
			Char.SetData(opponentsIndex, CONST.CHAR_战宠, 0)
			Char.SetData(petindex,CONST.PET_DepartureBattleStatus, CONST.PET_STATE_战斗)
			Char.SetData(petindex,CONST.对象_等级, dummylevel)
			Char.SetData(petindex,CONST.对象_体力, dummylevel*100*1.2)
			Char.SetData(petindex,CONST.对象_魔法, dummylevel*100*2)
			Char.SetData(petindex,CONST.对象_力量, dummylevel*100)
			Char.SetData(petindex,CONST.对象_强度, dummylevel*100*0.1)
			Char.SetData(petindex,CONST.对象_速度, dummylevel*100*0.5)
			Char.SetData(petindex,CONST.对象_技能栏,10)
			for killslot = 0,9 do--清除垃圾技能
				Pet.DelSkill(petindex,killslot);
			end
			--宠物最多给10个技能，请注意计算
			Pet.AddSkill(petindex, 838)--圣盾
			Pet.AddSkill(petindex, 38)--连击
			Pet.AddSkill(petindex, 138)--诸刃
			Pet.AddSkill(petindex, 338)--乾坤
			Pet.AddSkill(petindex, 2339)--强力陨石魔法
			Pet.AddSkill(petindex, 2439)--强力冰冻魔法
			Pet.AddSkill(petindex, 2539)--强力火焰魔法
			Pet.AddSkill(petindex, 2639)--强力风刃魔法
			Pet.AddSkill(petindex, 8138)--吸血攻击
			Pet.AddSkill(petindex, 7738)--石化攻击
			Pet.UpPet(opponentsIndex, petindex);
	end
	local excess = math.random(1,10);
	for k,v in pairs(PKArena) do
		if (k==v.pkType) then
			Char.SetData(opponentsIndex,CONST.对象_对战开关, 1);
			local walkOn = Char.GetTempData(opponentsIndex,'假人队长') or 0;
			--[[if (walkOn==1 and excess>=9) then
				local dir = math.random(0, 7);
				local X,Y = Char.GetLocation(opponentsIndex,dir);
				if (NLG.Walkable(0, Char.GetData(opponentsIndex,CONST.对象_经验), X, Y)==1) then
					NLG.SetAction(opponentsIndex,0);
					NLG.WalkMove(opponentsIndex,dir);
					NLG.UpChar(opponentsIndex);
				end
			end]]
		end
	end
end


Char.GetLocation = function(npc,dir)
	local X = Char.GetData(npc,CONST.对象_X)--地图x
	local Y = Char.GetData(npc,CONST.对象_Y)--地图y
	if dir==0 then
		Y=Y-1;
	elseif dir==1 then
		X=X+1;
		Y=Y-1;
	elseif dir==2 then
		X=X+1;
	elseif dir==3 then
		X=X+1;
		Y=Y+1;
	elseif dir==4 then
		Y=Y+1;
	elseif dir==5 then
		X=X-1;
		Y=Y+1;
	elseif dir==6 then
		X=X-1;
	elseif dir==7 then
		X=X-1;
		Y=Y-1;
	end
	return X,Y;
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;