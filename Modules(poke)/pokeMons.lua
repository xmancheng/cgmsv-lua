local Module = ModuleBase:createModule('pokeMons')

local card_Lslot = 8;
local card_Rslot = 27;
local AIinfo = {
  "敵方首領目標",
  "敵方血低目標",
  "敵方血高目標",
  "敵方隨機目標",
  "我方血低目標",
  "我方隊長目標",
}

local Assortment = {
  {"力速型","500,200,150,30,50,2000,2000"},
  {"魔速型","100,200,150,80,50,2000,2000"},
  {"體速型","300,200,150,30,90,2000,2000"},
  {"魔防型","100,250,100,90,60,2000,2000"},
  {"力體速型","400,200,120,30,80,2000,2000"},
  {"魔體速型","100,200,120,50,80,2000,2000"},
}
local skillParams={
  -- 自创技能
  [2005] = {CONST.BATTLE_COM.BATTLE_COM_P_SPIRACLESHOT},
  [106] = {CONST.BATTLE_COM.BATTLE_COM_ATTACKALL},
  [3100] = {CONST.BATTLE_COM.BATTLE_COM_P_PARAMETER,CONST.BATTLE_COM.BATTLE_COM_P_SPIRACLESHOT,CONST.BATTLE_COM.BATTLE_COM_P_PARAMETER,CONST.BATTLE_COM.BATTLE_COM_P_PARAMETER},
  [3101] = {CONST.BATTLE_COM.BATTLE_COM_P_PARAMETER,CONST.BATTLE_COM.BATTLE_COM_P_SPIRACLESHOT,CONST.BATTLE_COM.BATTLE_COM_P_RENZOKU,CONST.BATTLE_COM.BATTLE_COM_P_PARAMETER},
  [3102] = {CONST.BATTLE_COM.BATTLE_COM_P_PARAMETER,CONST.BATTLE_COM.BATTLE_COM_M_BLOODATTACK,CONST.BATTLE_COM.BATTLE_COM_DELAYATTACK,CONST.BATTLE_COM.BATTLE_COM_AXEBOMBER},
  [3103] = {CONST.BATTLE_COM.BATTLE_COM_ATTACKALL,CONST.BATTLE_COM.BATTLE_COM_P_SPIRACLESHOT,CONST.BATTLE_COM.BATTLE_COM_P_SPIRACLESHOT,CONST.BATTLE_COM.BATTLE_COM_AXEBOMBER},

  [0] = {CONST.BATTLE_COM.BATTLE_COM_P_RENZOKU},	-- 连击
  [1] = {CONST.BATTLE_COM.BATTLE_COM_P_PARAMETER},	-- 诸刃
  [3] = {CONST.BATTLE_COM.BATTLE_COM_P_PARAMETER},	-- 乾坤
  [4] = {CONST.BATTLE_COM.BATTLE_COM_P_SPIRACLESHOT},	-- 气功蛋
  [5] = {CONST.BATTLE_COM.BATTLE_COM_P_GUARDBREAK},	-- 崩击
  [6] = {CONST.BATTLE_COM.BATTLE_COM_P_FORCECUT},	-- 战栗袭心
  [7] = {CONST.BATTLE_COM.BATTLE_COM_P_BODYGUARD},	-- 护卫
  [8] = {CONST.BATTLE_COM.BATTLE_COM_P_SPECIALGARD},	-- 圣盾
  [9] = {CONST.BATTLE_COM.BATTLE_COM_P_DODGE},	-- 阳炎
  [10] = {CONST.BATTLE_COM.BATTLE_COM_P_MAGICGARD},	-- 防御魔法攻击
  [11] = {CONST.BATTLE_COM.BATTLE_COM_P_CROSSCOUNTER},	-- 反击
  [12] = {CONST.BATTLE_COM.BATTLE_COM_P_CONSENTRATION},	-- 明镜止水

  [19] = {CONST.BATTLE_COM.BATTLE_COM_P_MAGIC},	-- 陨石魔法
  [20] = {CONST.BATTLE_COM.BATTLE_COM_P_MAGIC},	-- 冰冻魔法
  [21] = {CONST.BATTLE_COM.BATTLE_COM_P_MAGIC},	-- 火焰魔法
  [22] = {CONST.BATTLE_COM.BATTLE_COM_P_MAGIC},	-- 风刃魔法
  [23] = {CONST.BATTLE_COM.BATTLE_COM_P_MAGIC},	-- 强力陨石
  [24] = {CONST.BATTLE_COM.BATTLE_COM_P_MAGIC},	-- 强力冰冻
  [25] = {CONST.BATTLE_COM.BATTLE_COM_P_MAGIC},	-- 强力火焰
  [26] = {CONST.BATTLE_COM.BATTLE_COM_P_MAGIC},	-- 强力风刃
  [27] = {CONST.BATTLE_COM.BATTLE_COM_P_MAGIC},	-- 超强陨石
  [28] = {CONST.BATTLE_COM.BATTLE_COM_P_MAGIC},	-- 超强冰冻
  [29] = {CONST.BATTLE_COM.BATTLE_COM_P_MAGIC},	-- 超强火焰
  [30] = {CONST.BATTLE_COM.BATTLE_COM_P_MAGIC},	-- 超强风刃

  [31] = {CONST.BATTLE_COM.BATTLE_COM_P_DORAIN},	-- 吸血魔法
  [61] = {CONST.BATTLE_COM.BATTLE_COM_P_HEAL},	-- 补血
  [62] = {CONST.BATTLE_COM.BATTLE_COM_P_HEAL},	-- 强力补血
  [63] = {CONST.BATTLE_COM.BATTLE_COM_P_HEAL},	-- 超强补血
  [64] = {CONST.BATTLE_COM.BATTLE_COM_P_LP_RECOVERY},	-- 恢复
  [65] = {CONST.BATTLE_COM.BATTLE_COM_P_LP_RECOVERY},	-- 强力恢复
  [66] = {CONST.BATTLE_COM.BATTLE_COM_P_LP_RECOVERY},	-- 超强恢复
  [67] = {CONST.BATTLE_COM.BATTLE_COM_P_STATUSRECOVER},	-- 洁净
  [68] = {CONST.BATTLE_COM.BATTLE_COM_P_REVIVE},	-- 气绝回复

  [73] = {CONST.BATTLE_COM.BATTLE_COM_ATTACK},	-- 攻击
  [74] = {CONST.BATTLE_COM.BATTLE_COM_GUARD},	-- 防御
  [160] = {CONST.BATTLE_COM.BATTLE_COM_POSITION},	-- 定点移动
  [150] = {CONST.BATTLE_COM.BATTLE_COM_NONE},	-- 什么都不做 
  [75] = {CONST.BATTLE_COM.BATTLE_COM_M_STATUSATTACK},	-- 毒性攻击
  [76] = {CONST.BATTLE_COM.BATTLE_COM_M_STATUSATTACK},	-- 昏睡攻击
  [77] = {CONST.BATTLE_COM.BATTLE_COM_M_STATUSATTACK},	-- 石化攻击
  [78] = {CONST.BATTLE_COM.BATTLE_COM_M_STATUSATTACK},	-- 酒醉攻击
  [79] = {CONST.BATTLE_COM.BATTLE_COM_M_STATUSATTACK},	-- 混乱攻击
  [80] = {CONST.BATTLE_COM.BATTLE_COM_M_STATUSATTACK},	-- 遗忘攻击
  [81] = {CONST.BATTLE_COM.BATTLE_COM_M_BLOODATTACK},	-- 吸血攻击

  [94] = {CONST.BATTLE_COM.BATTLE_COM_P_PANIC},	-- 混乱攻击
  [95] = {CONST.BATTLE_COM.BATTLE_COM_P_RANDOMSHOT},	-- 乱射
  [257] = {CONST.BATTLE_COM.BATTLE_COM_DELAYATTACK},	-- 戒骄戒躁
  [258] = {CONST.BATTLE_COM.BATTLE_COM_DELAYATTACK},	-- 一击必中
  [259] = {CONST.BATTLE_COM.BATTLE_COM_M_STATUSATTACK},	-- 毒击
  [260] = {CONST.BATTLE_COM.BATTLE_COM_BILLIARD},	-- 一石二鸟
  [261] = {CONST.BATTLE_COM.BATTLE_COM_KNIGHTGUARD},	-- 骑士之誉
  [262] = {CONST.BATTLE_COM.BATTLE_COM_FIRSTATTACK},	-- 迅速果断
  [266] = {CONST.BATTLE_COM.BATTLE_COM_RETRIBUTION},	-- 因果报应

  [32] = {CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE},	-- 中毒魔法
  [33] = {CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE},	-- 昏睡魔法
  [34] = {CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE},	-- 石化魔法
  [35] = {CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE},	-- 酒醉魔法
  [36] = {CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE},	-- 混乱魔法
  [37] = {CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE},	-- 遗忘魔法
  [38] = {CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE},	-- 强力中毒魔法
  [39] = {CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE},	-- 强力昏睡魔法
  [40] = {CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE},	-- 强力石化魔法
  [41] = {CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE},	-- 强力酒醉魔法
  [42] = {CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE},	-- 强力混乱魔法
  [43] = {CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE},	-- 强力遗忘魔法
  [44] = {CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE},	-- 超强中毒魔法
  [45] = {CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE},	-- 超强昏睡魔法
  [46] = {CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE},	-- 超强石化魔法
  [47] = {CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE},	-- 超强酒醉魔法
  [48] = {CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE},	-- 超强混乱魔法
  [49] = {CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE},	-- 超强遗忘魔法

  [50] = {CONST.BATTLE_COM.BATTLE_COM_P_TREAT_TYPE},	-- 大地的祈祷
  [51] = {CONST.BATTLE_COM.BATTLE_COM_P_TREAT_TYPE},	-- 海洋的祈祷
  [52] = {CONST.BATTLE_COM.BATTLE_COM_P_TREAT_TYPE},	-- 火焰的祈祷
  [53] = {CONST.BATTLE_COM.BATTLE_COM_P_TREAT_TYPE},	-- 云群的祈祷

  [54] = {CONST.BATTLE_COM.BATTLE_COM_P_REVERSE_TYPE},	-- 属性反转
  [55] = {CONST.BATTLE_COM.BATTLE_COM_P_REFLECTION_PHYSICS},	-- 攻击反弹
  [56] = {CONST.BATTLE_COM.BATTLE_COM_P_REFLECTION_MAGIC},	-- 魔法反弹
  [57] = {CONST.BATTLE_COM.BATTLE_COM_P_ABSORB_PHYSICS},	-- 攻击吸收
  [58] = {CONST.BATTLE_COM.BATTLE_COM_P_ABSORB_MAGIC},	-- 魔法吸收
  [59] = {CONST.BATTLE_COM.BATTLE_COM_P_INEFFECTIVE_PHYSICS},	-- 攻击无效
  [60] = {CONST.BATTLE_COM.BATTLE_COM_P_INEFFECTIVE_MAGIC},	-- 魔法无效
}

local skillCom={
  -- 自创技能
  [2005] = {0},
  [106] = {20},
  [3100] = {0,0,0},
  [3101] = {0,0,0,0},
  [3102] = {0,0,0,20},
  [3103] = {20,0,0,41},

  [0] = {0},	-- 连击
  [1] = {0},	-- 诸刃
  [3] = {0},	-- 乾坤
  [4] = {0},	-- 气功蛋
  [5] = {0},	-- 崩击
  [6] = {0},	-- 战栗袭心
  [7] = {0},	-- 护卫
  [8] = {-1},	-- 圣盾
  [9] = {-1},	-- 阳炎
  [10] = {-1},	-- 防御魔法攻击
  [11] = {-1},	-- 反击
  [12] = {-1},	-- 明镜止水

  [19] = {0},	-- 陨石魔法
  [20] = {0},	-- 冰冻魔法
  [21] = {0},	-- 火焰魔法
  [22] = {0},	-- 风刃魔法
  [23] = {20},	-- 强力陨石
  [24] = {20},	-- 强力冰冻
  [25] = {20},	-- 强力火焰
  [26] = {20},	-- 强力风刃
  [27] = {41},	-- 超强陨石
  [28] = {41},	-- 超强冰冻
  [29] = {41},	-- 超强火焰
  [30] = {41},	-- 超强风刃

  [31] = {0},	-- 吸血魔法
  [61] = {0},	-- 补血
  [62] = {20},	-- 强力补血
  [63] = {40},	-- 超强补血
  [64] = {0},	-- 恢复
  [65] = {20},	-- 强力恢复
  [66] = {40},	-- 超强恢复
  [67] = {0,0,20,40},	-- 洁净
  [68] = {0,0,20,20},	-- 气绝回复

  [73] = {-1},	-- 攻击
  [74] = {-1},	-- 防御
  [160] = {-1},	-- 定点移动
  [150] = {-1},	-- 什么都不做 
  [75] = {0},	-- 毒性攻击
  [76] = {0},	-- 昏睡攻击
  [77] = {0},	-- 石化攻击
  [78] = {0},	-- 酒醉攻击
  [79] = {0},	-- 混乱攻击
  [80] = {0},	-- 遗忘攻击
  [81] = {0},	-- 吸血攻击

  [94] = {0},	-- 混乱攻击
  [95] = {0},	-- 乱射
  [257] = {0},	-- 戒骄戒躁
  [258] = {0},	-- 一击必中
  [259] = {0},	-- 毒击
  [260] = {0},	-- 一石二鸟
  [261] = {0},	-- 骑士之誉
  [262] = {0},	-- 迅速果断
  [266] = {0},	-- 因果报应

  [32] = {0},	-- 中毒魔法
  [33] = {0},	-- 昏睡魔法
  [34] = {0},	-- 石化魔法
  [35] = {0},	-- 酒醉魔法
  [36] = {0},	-- 混乱魔法
  [37] = {0},	-- 遗忘魔法
  [38] = {20},	-- 强力中毒魔法
  [39] = {20},	-- 强力昏睡魔法
  [40] = {20},	-- 强力石化魔法
  [41] = {20},	-- 强力酒醉魔法
  [42] = {20},	-- 强力混乱魔法
  [43] = {20},	-- 强力遗忘魔法
  [44] = {41},	-- 超强中毒魔法
  [45] = {41},	-- 超强昏睡魔法
  [46] = {41},	-- 超强石化魔法
  [47] = {41},	-- 超强酒醉魔法
  [48] = {41},	-- 超强混乱魔法
  [49] = {41},	-- 超强遗忘魔法

  [50] = {0},	-- 大地的祈祷
  [51] = {0},	-- 海洋的祈祷
  [52] = {0},	-- 火焰的祈祷
  [53] = {0},	-- 云群的祈祷

  [54] = {0,0,20,40},	-- 属性反转
  [55] = {0,0,20,40},	-- 攻击反弹
  [56] = {0,0,20,40},	-- 魔法反弹
  [57] = {0,0,20,40},	-- 攻击吸收
  [58] = {0,0,20,40},	-- 魔法吸收
  [59] = {0,0,20,40},	-- 攻击无效
  [60] = {0,0,20,40},	-- 魔法无效
}

local techManual = {
  {Name="喚獸技能學習師", Image=14682, Area={map=20335,X=13,Y=85}, Dynamo=1, TechInfo={{7300,100},{7400,100},{1030,100},{16000,100},{15002,50},{738,1600},{838,1600},{938,1600},}, },
  {Name="喚獸技能學習師", Image=14682, Area={map=20335,X=16,Y=85}, Dynamo=2, TechInfo={{7300,100},{7400,100},{1030,100},{16000,100},{15002,50},{736,400},{836,400},{936,400},}, },
  {Name="喚獸技能學習師", Image=14682, Area={map=20335,X=15,Y=76}, Dynamo=1, TechInfo={{38,1600},{138,1600},{338,1600},{538,1600},{638,1600},{1138,1600},{1238,2700},{8138,2025},}, },
  {Name="喚獸技能學習師", Image=14682, Area={map=20335,X=17,Y=76}, Dynamo=2, TechInfo={{36,400},{136,400},{336,400},{536,400},{636,400},{1136,400},{1236,500},{8136,625},}, },
  {Name="喚獸技能學習師", Image=14682, Area={map=20335,X=13,Y=65}, Dynamo=1, TechInfo={{1903,800},{1906,2450},{1909,5000},{2003,800},{2006,2450},{2009,5000},{2103,800},{2106,2450},{2109,5000},{2203,800},{2206,2450},{2209,5000},}, },
  {Name="喚獸技能學習師", Image=14682, Area={map=20335,X=15,Y=65}, Dynamo=2, TechInfo={{1902,450},{1905,1800},{1908,4050},{2002,450},{2005,1800},{2008,4050},{2102,450},{2105,1800},{2108,4050},{2202,450},{2205,1800},{2208,4050},}, },
  {Name="喚獸技能學習師", Image=14682, Area={map=20335,X=15,Y=54}, Dynamo=1, TechInfo={{2306,1600},{2309,4900},{2709,10000},{2406,1600},{2409,4900},{2809,10000},{2506,1600},{2509,4900},{2909,10000},{2606,1600},{2609,4900},{3009,10000},}, },
  {Name="喚獸技能學習師", Image=14682, Area={map=20335,X=17,Y=54}, Dynamo=2, TechInfo={{2305,900},{2308,3600},{2708,8100},{2405,900},{2408,3600},{2808,8100},{2505,900},{2508,3600},{2908,8100},{2605,900},{2608,3600},{3008,8100},}, },
  {Name="喚獸技能學習師", Image=14682, Area={map=20335,X=13,Y=43}, Dynamo=1, TechInfo={{7538,1215},{7638,1215},{7738,1215},{7838,1215},{7938,1215},{8038,1215},{6703,5025},}, },
  {Name="喚獸技能學習師", Image=14682, Area={map=20335,X=15,Y=43}, Dynamo=2, TechInfo={{7536,735},{7636,735},{7736,735},{7836,735},{7936,735},{8036,735},{6700,4215},}, },
  {Name="喚獸技能學習師", Image=14682, Area={map=20335,X=15,Y=32}, Dynamo=1, TechInfo={{3206,1600},{3306,1600},{3406,1600},{3506,1600},{3606,1600},{3706,1600},{3806,4900},{3906,4900},{4006,4900},{4106,4900},{4206,4900},{4306,4900},{4406,10000},{4506,10000},{4606,10000},{4706,10000},{4806,10000},{4906,10000},}, },
  {Name="喚獸技能學習師", Image=14682, Area={map=20335,X=17,Y=32}, Dynamo=2, TechInfo={{3203,900},{3303,900},{3403,900},{3503,900},{3603,900},{3703,900},{3803,3600},{3903,3600},{4003,3600},{4103,3600},{4203,3600},{4303,3600},{4403,8100},{4503,8100},{4603,8100},{4703,8100},{4803,8100},{4903,8100},}, },
  {Name="喚獸技能學習師", Image=14682, Area={map=20335,X=13,Y=21}, Dynamo=1, TechInfo={{6106,1600},{6406,1600},{6206,4900},{6506,4900},{6306,10000},{6606,10000},{5500,3215},{5600,3215},{5700,3215},{5800,3215},{5900,3215},{6000,3215},}, },
  {Name="喚獸技能學習師", Image=14682, Area={map=20335,X=15,Y=21}, Dynamo=2, TechInfo={{6103,900},{6403,900},{6203,3600},{6503,3600},{6303,8100},{6603,8100},{5500,2735},{5600,2735},{5700,2735},{5800,2735},{5900,2735},{6000,2735},}, },

  {Name="喚獸技能學習師", Image=14682, Area={map=20335,X=11,Y=8}, Dynamo=1, TechInfo={{310002,7600},{310005,7600},{310008,7600},{310011,7600},}, },
  {Name="喚獸技能學習師", Image=14682, Area={map=20335,X=12,Y=8}, Dynamo=2, TechInfo={{310000,6400},{310003,6400},{310006,6400},{310009,6400},}, },
  {Name="喚獸技能學習師", Image=14682, Area={map=20335,X=14,Y=8}, Dynamo=1, TechInfo={{310102,7600},{310105,7600},{310108,7600},{310111,7600},}, },
  {Name="喚獸技能學習師", Image=14682, Area={map=20335,X=15,Y=8}, Dynamo=2, TechInfo={{310100,6400},{310103,6400},{310106,6400},{310109,6400},}, },
  {Name="喚獸技能學習師", Image=14682, Area={map=20335,X=17,Y=8}, Dynamo=1, TechInfo={{310202,7600},{310205,7600},{310208,7600},{310211,7600},}, },
  {Name="喚獸技能學習師", Image=14682, Area={map=20335,X=18,Y=8}, Dynamo=2, TechInfo={{310200,6400},{310203,6400},{310206,6400},{310209,6400},}, },
  {Name="喚獸技能學習師", Image=14682, Area={map=20335,X=11,Y=6}, Dynamo=1, TechInfo={{10629,7600},{310305,7600},{310308,7600},{310311,7600},}, },
  {Name="喚獸技能學習師", Image=14682, Area={map=20335,X=12,Y=6}, Dynamo=2, TechInfo={{10627,6400},{310303,6400},{310306,6400},{310309,6400},}, },
}

tbl_MonsIndex = tbl_MonsIndex or {}
tbl_techManualNPCIndex = tbl_techManualNPCIndex or {}
-----------------------------------------------------------------
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('AutoBattleCommandEvent', Func.bind(self.onAutoBattleCommandEvent, self));
  --self:regCallback('LoginEvent',Func.bind(self.onLoginEvent,self));
  self:regCallback('BattleSurpriseEvent',Func.bind(self.onBattleSurpriseEvent,self));
  self:regCallback('BeforeBattleTurnEvent', Func.bind(self.onBeforeBattleTurnCallback, self));
  self:regCallback('AfterBattleTurnEvent', Func.bind(self.onAfterBattleTurnCallback, self));
  self:regCallback('BattleOverEvent', Func.bind(self.onBattleOverCallback, self));
  Item.CreateNewItemType( 64, "喚獸卡牌", 400188, -1, 0);

  --喚獸卡牌
  self:regCallback('ItemString', Func.bind(self.mechanism, self),"LUA_useOrgan");
  self.applianceNPC = self:NPC_createNormal('AI行動模式', 14682, { x = 42, y = 33, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.applianceNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local msg = "\\n@c【喚獸卡牌行動模式】" ..	"\\n\\n[敵方單體隨機]模式\\n[我方單體血少]模式\\n[敵方單體血少]模式\\n[敵方單體血多]模式\\n[敵方全體目標]模式\\n[我方全體目標]模式";	
        NLG.ShowWindowTalked(player, self.applianceNPC, CONST.窗口_信息框, CONST.按钮_关闭, 1, msg);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(self.applianceNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    APPSlot = APPSlot;
    APPIndex = Char.GetItemIndex(player,APPSlot);
    if select > 0 then
      if seqno == 1 and select == CONST.按钮_关闭 then
        return
      elseif seqno == 1 and select == CONST.按钮_确定 then
        local AIType = Item.GetData(APPIndex,CONST.道具_等级);		--AI模式
        local msg = "3\\n @c【喚獸卡牌行動模式】\\n"
                .. " ※選擇切換的卡牌行動模式\\n\\n"
        for i=1,#AIinfo do
          if (i==AIType) then
            msg = msg .. "◆　" .. AIinfo[i].."\\n"
          else
            msg = msg .. "◇　" .. AIinfo[i].."\\n"
          end
        end
        NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.按钮_关闭, 2, msg);
      end
    else
      if seqno == 2 and data > 0 then
        Item.SetData(APPIndex,CONST.道具_等级,tonumber(data));		--AI模式
        Item.UpItem(player, APPSlot);
        NLG.PlaySe(player, 279, Char.GetData(player,CONST.对象_X), Char.GetData(player,CONST.对象_Y));
        NLG.UpChar(player);
      end
    end
  end)

  --精靈球
  self:regCallback('ItemString', Func.bind(self.mmessage, self),"LUA_useMonsInfo");
  self.pokeVRNPC = self:NPC_createNormal('精靈喚獸登錄', 14682, { x = 41, y = 33, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.pokeVRNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local msg = "　　　　　　　　【精靈喚獸資訊】\\n"
               .. "　　$4小火龍\\n"
               .. "　　　　　　　$1喚獸類型 [力速型]\\n"
               .. "　　　　　　　$1攜帶技能 [攻擊]\\n"
               .. "　　　　　　　$2適性模式 [敵方單體隨機]\\n\\n"
               .. "　　　　　　　$5地 10　水 10　火 10　風 10\\n";
        NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.按钮_关闭, 1, msg);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(self.pokeVRNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    BallSlot = BallSlot;
    BallIndex = Char.GetItemIndex(player,BallSlot);
    local GoalIndex,GoalSlot = Char.GetVRGoalSlot(player);
    if (GoalIndex>0) then
        if select > 0 then
          if select == CONST.按钮_关闭 then
                 return;
          elseif seqno == 1 and select == CONST.按钮_确定 then
            local GoalName = Item.GetData(GoalIndex,CONST.道具_名字);
            local itemName = Item.GetData(BallIndex,CONST.道具_名字);
            local last = string.find(itemName, "]", 1);
            local MonsName = string.sub(itemName, 2, last-1);
            local msg = "\\n@c【喚獸與卡牌綁定流程】\\n\\n"
               .. "\\n找尋到品欄中的 $2"..GoalName.."\\n\\n"
               .. "\\n$5"..MonsName.." $0確定要與卡牌進行綁定嗎？\\n"
               --.. " $4※如非適當的配對，可移動物品欄卡牌的先後順序";
            NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.按钮_确定关闭, 2, msg);
          elseif seqno == 2 and select == CONST.按钮_确定 then
            local itemName = Item.GetData(BallIndex,CONST.道具_名字);
            local last = string.find(itemName, "]", 1);
            local MonsName = string.sub(itemName, 2, last-1);
            Item.SetData(GoalIndex,CONST.道具_名字,"["..MonsName.."]配對卡牌");
            Item.SetData(GoalIndex,CONST.道具_特殊类型, Item.GetData(BallIndex,CONST.道具_特殊类型));	--形象編號
            Item.SetData(GoalIndex,CONST.道具_幸运, Item.GetData(BallIndex,CONST.道具_幸运));		--怪物類型
            Item.SetData(GoalIndex,CONST.道具_属性一, Item.GetData(BallIndex,CONST.道具_属性一));
            Item.SetData(GoalIndex,CONST.道具_属性二, Item.GetData(BallIndex,CONST.道具_属性二));
            Item.SetData(GoalIndex,CONST.道具_属性一值, Item.GetData(BallIndex,CONST.道具_属性一值));
            Item.SetData(GoalIndex,CONST.道具_属性二值, Item.GetData(BallIndex,CONST.道具_属性二值));
            Item.SetData(GoalIndex,CONST.道具_子参一, Item.GetData(BallIndex,CONST.道具_子参一));	--第一回施放tech編號
            Item.SetData(GoalIndex,CONST.道具_子参二, Item.GetData(BallIndex,CONST.道具_子参二));	--第二回施放tech編號
            --天生加成
            Item.SetData(GoalIndex,CONST.道具_攻击, Item.GetData(BallIndex,CONST.道具_攻击));
            Item.SetData(GoalIndex,CONST.道具_防御, Item.GetData(BallIndex,CONST.道具_防御));
            Item.SetData(GoalIndex,CONST.道具_敏捷, Item.GetData(BallIndex,CONST.道具_敏捷));
            Item.SetData(GoalIndex,CONST.道具_精神, Item.GetData(BallIndex,CONST.道具_精神));
            Item.SetData(GoalIndex,CONST.道具_回复, Item.GetData(BallIndex,CONST.道具_回复));
            Item.SetData(GoalIndex,CONST.道具_生命, Item.GetData(BallIndex,CONST.道具_生命));
            Item.SetData(GoalIndex,CONST.道具_魔力, Item.GetData(BallIndex,CONST.道具_魔力));
            Item.UpItem(player, GoalSlot);
            Char.DelItemBySlot(player, BallSlot);
            NLG.PlaySe(player, 279, Char.GetData(player,CONST.对象_X), Char.GetData(player,CONST.对象_Y));
            NLG.UpChar(player);
          else
              return;
          end
        end
    else
        if select > 0 then
          if select == CONST.按钮_关闭 then
            return;
          elseif seqno == 1 and select == CONST.按钮_确定 then
            NLG.SystemMessage(player,"[系統]沒有找到可使用之全新模式卡牌，請重新確認。");
          end
        end
    end
  end)

  --技能學習
 for k,v in pairs(techManual) do
  if tbl_techManualNPCIndex[k] == nil then
  local TechLearningNPC = self:NPC_createNormal(v.Name,v.Image, { mapType=0, map=v.Area.map, x=v.Area.X, y=v.Area.Y, direction=4 });
  tbl_techManualNPCIndex[k] = TechLearningNPC;
  Char.SetData(TechLearningNPC,CONST.对象_ENEMY_PetFlg+2,0);
  self:NPC_regTalkedEvent(tbl_techManualNPCIndex[k], function(npc, player)
    -- 数据结构: NPC图档|窗口名称|NPC对话|未知1|未知2|标题N|耗魔N|价格N|介绍文字N|...
    if (NLG.CanTalk(npc, player) == true) then
        local dynamo = v.Dynamo;
        if (dynamo==1) then namo="『一動技能』"; elseif (dynamo==2) then namo="『二動技能』"; end
        local msg = "14682|喚獸"..namo.."學習|\n我可以讓你道具欄的喚獸卡牌學習技能哦|未知1|未知2|"
        for i=1,#v.TechInfo do
          local techId = v.TechInfo[i][1];
          local techGold = v.TechInfo[i][2];
          local TechIndex = Tech.GetTechIndex(techId);
          local TechName = Tech.GetData(TechIndex, CONST.TECH_NAME);
          local TechFP = Tech.GetData(TechIndex, CONST.TECH_FORCEPOINT);
          local msgId = Tech.GetData(TechIndex, CONST.TECH_COMMENT);
          local TechComment = Data.GetMessage(msgId);
          msg = msg .. TechName.."|"..TechFP.."|"..techGold.."|\n"..TechComment.."|"
        end
        NLG.ShowWindowTalked(player, npc, 24, CONST.按钮_上下取消, 99, msg);	--CONST.窗口_宠技学习选择技能框
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(tbl_techManualNPCIndex[k], function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select > 0 then
      if select == CONST.按钮_关闭 then
        return;
      end
    end
    if (seqno == 99) then
      local dynamo = v.Dynamo;
      TechSort = data+1;
      if (dynamo==1) then namo="『一動技能』"; elseif (dynamo==2) then namo="『二動技能』"; end
      local msg = "3\\n @c【喚獸卡牌技能學習】\\n"
               .. " ※選擇哪個卡牌的"..namo.."覆蓋學習\\n\\n"
      for Slot=8,11 do
        local APPIndex = Char.GetItemIndex(player,Slot);
        if (APPIndex>0) then
          local itemName = Item.GetData(APPIndex,CONST.道具_名字);
          local itemType = Item.GetData(APPIndex,CONST.对象_类型);		--類型64 AI模式
          local itemInfo_45 = Item.GetData(APPIndex,CONST.道具_特殊类型);	--形象編號
          if (itemType == 64 and itemInfo_45 > 0) then
            msg = msg .. "◎　" ..itemName.."\\n"
          else
            msg = msg .. "◎　空\\n"
          end
        else
            msg = msg .. "◎　空\\n"
        end
      end
      NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.按钮_关闭, 1, msg);
    elseif (seqno == 1) then
      local dynamo = v.Dynamo;
      local techId = v.TechInfo[TechSort][1];
      local techGold = v.TechInfo[TechSort][2];
      if (Char.GetData(player,CONST.对象_金币)<techGold) then
         NLG.SystemMessage(player, "[系統]學習技能需要" ..techGold.. "G。");
         return;
      end
      if (techId>0) then
        local Slot = data+7;
        local APPIndex = Char.GetItemIndex(player,Slot);
        if (APPIndex>0) then
          local itemType = Item.GetData(APPIndex,CONST.对象_类型);		--類型64 AI模式
          local itemInfo_45 = Item.GetData(APPIndex,CONST.道具_特殊类型);	--形象編號
          if (itemType ~= 64 or itemInfo_45 == 0) then
             NLG.SystemMessage(player,"[系統]只有配對卡牌可學習技能，請重新確認。");
             return;
          end
          local itemName = Item.GetData(APPIndex,CONST.道具_名字);
          local last = string.find(itemName, "]", 1);
          local MonsName = string.sub(itemName, 2, last-1);
          local itemInfo_46 = Item.GetData(APPIndex,CONST.道具_子参一);	--第一回施放tech編號
          local itemInfo_47 = Item.GetData(APPIndex,CONST.道具_子参二);	--第一回施放tech編號
          local TechIndex = Tech.GetTechIndex(techId);
          local TechName = Tech.GetData(TechIndex, CONST.TECH_NAME);
          if (itemType == 64 and itemInfo_46 == techId and dynamo==1) then
             NLG.SystemMessage(player,"[系統]卡牌技能和學習技能相同。");
             return;
          elseif (itemType == 64 and itemInfo_45 > 0 and dynamo==1) then
             Item.SetData(APPIndex,CONST.道具_子参一, techId);	--第一回施放tech編號
             Item.UpItem(player, Slot);
             Char.AddGold(player, -techGold);
             NLG.SystemMessage(player,"[系統]花費"..techGold.."G "..MonsName.."學習了"..TechName.."。");
             NLG.UpChar(player);
          elseif (itemType == 64 and itemInfo_47 == techId and dynamo==2) then
             NLG.SystemMessage(player,"[系統]卡牌技能和學習技能相同。");
             return;
          elseif (itemType == 64 and itemInfo_45 > 0 and dynamo==2) then
             Item.SetData(APPIndex,CONST.道具_子参二, techId);	--第二回施放tech編號
             Item.UpItem(player, Slot);
             Char.AddGold(player, -techGold);
             NLG.SystemMessage(player,"[系統]花費"..techGold.."G "..MonsName.."學習了"..TechName.."。");
             NLG.UpChar(player);
          end
        end
      end
    end
  end)
  end
 end


end

-- AI模式怪獸訊息
function Module:mechanism(charIndex,targetIndex,itemSlot)
    local ItemID = Item.GetData(Char.GetItemIndex(charIndex,itemSlot),0);
    APPSlot = itemSlot;
    APPIndex = Char.GetItemIndex(charIndex,itemSlot);

    local itemType = Item.GetData(APPIndex,CONST.对象_类型);		--類型64 AI模式
    local itemInfo_45 = Item.GetData(APPIndex,CONST.道具_特殊类型);	--形象編號
    if (itemType == 64 and itemInfo_45 > 0) then	--itemInfo_45表已成功激活
      local itemName = Item.GetData(APPIndex,CONST.道具_名字);
      local last = string.find(itemName, "]", 1);
      local MonsName = string.sub(itemName, 2, last-1);
      local AIType = Item.GetData(APPIndex,CONST.道具_等级);		--AI模式
      local monsType = Item.GetData(APPIndex,CONST.道具_幸运);		--怪物類型
      local itemInfo_4003 = Item.GetData(APPIndex,CONST.道具_自用参数);	--進化加成表
      local equipMod = string.split(itemInfo_4003,',');
      if equipMod[1]=="" then
        for i=1,7 do
          equipMod[i] = tonumber(0);
        end
      else
        for k,v in pairs(equipMod) do
          equipMod[k] = tonumber(v);
        end
      end
      local itemInfo_32 = Item.GetData(APPIndex,CONST.道具_属性一);
      local itemInfo_33 = Item.GetData(APPIndex,CONST.道具_属性二);
      local itemInfo_34 = Item.GetData(APPIndex,CONST.道具_属性一值);
      local itemInfo_35 = Item.GetData(APPIndex,CONST.道具_属性二值);
      local Goal_DataPos_14 = 0;
      local Goal_DataPos_15 = 0;
      local Goal_DataPos_16 = 0;
      local Goal_DataPos_17 = 0;
      if itemInfo_32==1 then Goal_DataPos_14=itemInfo_34;
      elseif itemInfo_32==2 then Goal_DataPos_15=itemInfo_34;
      elseif itemInfo_32==3 then Goal_DataPos_16=itemInfo_34;
      elseif itemInfo_32==4 then Goal_DataPos_17=itemInfo_34; end
      if itemInfo_33==1 then Goal_DataPos_14=itemInfo_35;
      elseif itemInfo_33==2 then Goal_DataPos_15=itemInfo_35;
      elseif itemInfo_33==3 then Goal_DataPos_16=itemInfo_35;
      elseif itemInfo_33==4 then Goal_DataPos_17=itemInfo_35; end

      local awakeLv = Item.GetData(APPIndex,CONST.道具_最大耐久);	--覺醒等級
      local plus = GetAwakenPower(awakeLv);

      local itemInfo_46 = Item.GetData(APPIndex,CONST.道具_子参一);	--第一回施放tech編號
      local TechIndex_46 = Tech.GetTechIndex(itemInfo_46);
      local TechName_46 = Tech.GetData(TechIndex_46, CONST.TECH_NAME);

      local itemInfo_47 = Item.GetData(APPIndex,CONST.道具_子参二);	--第二回施放tech編號
      local TechIndex_47 = Tech.GetTechIndex(itemInfo_47);
      local TechName_47 = Tech.GetData(TechIndex_47, CONST.TECH_NAME);
      local imageText = "@g,"..itemInfo_45..",2,8,6,0@"
      msg = imageText .. "　　　　　　　　【喚獸卡牌行動模式】\\n"
               .. "　　$4".. MonsName .. "\\n"
               .. "　　　　　　　$2喚獸類型 ["..Assortment[monsType][1].."]　人形系\\n"
               .. "　　　　　　　$1行動模式 ["..AIinfo[AIType].."]\\n"
               .. "　　　　　　　$1一動技能 ["..TechName_46.."]\\n"
               .. "　　　　　　　$1二動技能 ["..TechName_47.."]\\n"
               .. "　　　　　　　$5地 ".. Goal_DataPos_14/10 .."　" .."$5水 ".. Goal_DataPos_15/10 .."　" .."$5火 ".. Goal_DataPos_16/10 .."　" .."$5風 ".. Goal_DataPos_17/10 .."\\n"
               .. "　　　　　　　$4▽額外加成能力▽　$0基本值"..plus.."點▲\\n"
               .. "　　　　　　　$4攻擊 "..equipMod[1].."　".."防禦 "..equipMod[2].."　".."敏捷 "..equipMod[3].."\\n"
               .. "　　　　　　　$4精神 "..equipMod[4].."　".."恢復 "..equipMod[5].."\\n";
      NLG.ShowWindowTalked(charIndex, self.applianceNPC, CONST.窗口_信息框, CONST.按钮_确定关闭, 1, msg);
    elseif (itemType == 64 and itemInfo_45 <= 0) then
      local itemName = Item.GetData(APPIndex,CONST.道具_名字);
      msg = "\\n@c【喚獸卡牌行動模式】\\n\\n"
               .. "\\n此為 "..itemName.."\\n\\n"
               .. "\\n$7尚未與精靈喚獸進行成功綁定\\n";
      NLG.ShowWindowTalked(charIndex, self.applianceNPC, CONST.窗口_信息框, CONST.按钮_关闭, 1, msg);
    end
    return 1;
end

-- 精靈球怪獸訊息
function Module:mmessage(charIndex,targetIndex,itemSlot)
    local ItemID = Item.GetData(Char.GetItemIndex(charIndex,itemSlot),0);
    BallSlot = itemSlot;
    BallIndex = Char.GetItemIndex(charIndex,itemSlot);

      local itemInfo_45 = Item.GetData(BallIndex,CONST.道具_特殊类型);	--形象編號
      local itemName = Item.GetData(BallIndex,CONST.道具_名字);
      local last = string.find(itemName, "]", 1);
      local MonsName = string.sub(itemName, 2, last-1);
      local AIType = Item.GetData(BallIndex,CONST.道具_等级);		--AI模式
      local monsType = Item.GetData(BallIndex,CONST.道具_幸运);		--怪物類型
      local monsTypeName = Assortment[monsType][1];
      local itemInfo_32 = Item.GetData(BallIndex,CONST.道具_属性一);
      local itemInfo_33 = Item.GetData(BallIndex,CONST.道具_属性二);
      local itemInfo_34 = Item.GetData(BallIndex,CONST.道具_属性一值);
      local itemInfo_35 = Item.GetData(BallIndex,CONST.道具_属性二值);
      local Goal_DataPos_14 = 0;
      local Goal_DataPos_15 = 0;
      local Goal_DataPos_16 = 0;
      local Goal_DataPos_17 = 0;
      if itemInfo_32==1 then Goal_DataPos_14=itemInfo_34;
      elseif itemInfo_32==2 then Goal_DataPos_15=itemInfo_34;
      elseif itemInfo_32==3 then Goal_DataPos_16=itemInfo_34;
      elseif itemInfo_32==4 then Goal_DataPos_17=itemInfo_34; end
      if itemInfo_33==1 then Goal_DataPos_14=itemInfo_35;
      elseif itemInfo_33==2 then Goal_DataPos_15=itemInfo_35;
      elseif itemInfo_33==3 then Goal_DataPos_16=itemInfo_35;
      elseif itemInfo_33==4 then Goal_DataPos_17=itemInfo_35; end

      local itemInfo_46 = Item.GetData(BallIndex,CONST.道具_子参一);	--第一回施放tech編號
      local TechIndex_46 = Tech.GetTechIndex(itemInfo_46);
      local TechName_46 = Tech.GetData(TechIndex_46, CONST.TECH_NAME);
      local itemInfo_47 = Item.GetData(BallIndex,CONST.道具_子参二);	--第二回施放tech編號
      local TechIndex_47 = Tech.GetTechIndex(itemInfo_47);
      local TechName_47 = Tech.GetData(TechIndex_47, CONST.TECH_NAME);

      local imageText = "@g,"..itemInfo_45..",2,8,6,0@"
      local imageText_2 = "@g,239526,10,4,4,0@"
      msg = imageText .. "　　　　　　　　【精靈喚獸資訊】\\n"
               .. "　　$4".. MonsName .. "\\n"
               .. "　　　　　　　$2喚獸類型 ["..monsTypeName.."]\\n"
               .. "　　　　　　　$1行動模式 [尚未綁定生效]\\n"
               .. "　　　　　　　$1一動技能 ["..TechName_46.."]\\n"
               .. "　　　　　　　$1二動技能 ["..TechName_47.."]\\n"
               .. "　　　　　　　$5地 ".. Goal_DataPos_14/10 .."　" .."$5水 ".. Goal_DataPos_15/10 .."　" .."$5火 ".. Goal_DataPos_16/10 .."　" .."$5風 ".. Goal_DataPos_17/10 .."\\n";
      --local msg = msg .. imageText_2
    NLG.ShowWindowTalked(charIndex, self.pokeVRNPC, CONST.窗口_信息框, CONST.按钮_确定关闭, 1, msg);
    return 1;
end
-- 搜尋全新AI模式
Char.GetVRGoalSlot = function(charIndex)
	for Slot=8,47 do
		local ItemIndex = Char.GetItemIndex(charIndex, Slot);
		--print(ItemIndex);
		if (ItemIndex > 0) then
			local ItemId = Item.GetData(ItemIndex,CONST.道具_ID);
			local itemType = Item.GetData(ItemIndex,CONST.对象_类型);		--類型64 AI模式
			local itemInfo_45 = Item.GetData(ItemIndex,CONST.道具_特殊类型);	--形象編號
			if (itemType == 64 and itemInfo_45 <= 0) then
				return ItemIndex,Slot;
			end
		end
	end
	return -1,-1;
end
----------------------------------------------------------------
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
		--local cg1 = Char.GetData(charIndex, CONST.对象_体力);
		--local cg2 = Char.GetData(charIndex, CONST.对象_力量);
		--local cg3 = Char.GetData(charIndex, CONST.对象_强度);
		--local cg4 = Char.GetData(charIndex, CONST.对象_速度);
		--local cg5 = Char.GetData(charIndex, CONST.对象_魔法);
		--print(cg1,cg2,cg3,cg4,cg5);
		if (battleturn==0) then		--開場召喚夥伴
			local cdk = Char.GetData(charIndex, CONST.对象_CDK);
			if (actionNum==1) then
				local standby = 0;
				for itemSlot=card_Lslot,card_Rslot do
					local itemIndex = Char.GetItemIndex(charIndex, itemSlot);
					if (itemIndex>0) then
						local itemType = Item.GetData(itemIndex,CONST.对象_类型);		--類型64 AI模式
						local itemId = Item.GetData(itemIndex,CONST.道具_ID);
						local itemInfo_45 = Item.GetData(itemIndex,CONST.道具_特殊类型);	--形象編號
						if (itemType == 64 and itemInfo_45 > 0) then	--itemInfo_45表已成功激活
							local itemName = Item.GetData(itemIndex,CONST.道具_名字);
							local last = string.find(itemName, "]", 1);
							local MonsName = string.sub(itemName, 2, last-1);
							local AIType = Item.GetData(itemIndex,CONST.道具_等级);		--AI模式
							local monsType = Item.GetData(itemIndex,CONST.道具_幸运);		--怪物類型
							local itemInfo_32 = Item.GetData(itemIndex,CONST.道具_属性一);
							local itemInfo_33 = Item.GetData(itemIndex,CONST.道具_属性二);
							local itemInfo_34 = Item.GetData(itemIndex,CONST.道具_属性一值);
							local itemInfo_35 = Item.GetData(itemIndex,CONST.道具_属性二值);
							local itemInfo_46 = Item.GetData(itemIndex,CONST.道具_子参一);	--第一回施放tech編號
							local itemInfo_47 = Item.GetData(itemIndex,CONST.道具_子参二);	--第二回施放tech編號

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
							--天生加成(需倚賴在裝備上)
							Item.SetData(item_1,CONST.道具_攻击,Item.GetData(itemIndex,CONST.道具_攻击));
							Item.SetData(item_1,CONST.道具_防御,Item.GetData(itemIndex,CONST.道具_防御));
							Item.SetData(item_1,CONST.道具_敏捷,Item.GetData(itemIndex,CONST.道具_敏捷));
							Item.SetData(item_1,CONST.道具_精神,Item.GetData(itemIndex,CONST.道具_精神));
							Item.SetData(item_1,CONST.道具_回复,Item.GetData(itemIndex,CONST.道具_回复));
							Item.SetData(item_1,CONST.道具_生命,Item.GetData(itemIndex,CONST.道具_生命));
							Item.SetData(item_1,CONST.道具_魔力,Item.GetData(itemIndex,CONST.道具_魔力));
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
							Char.SetData(MonsIndex,CONST.对象_金币, itemInfo_46);			--第一回施放tech編號
							Char.SetData(MonsIndex,CONST.对象_银行金币, itemInfo_47);		--第二回施放tech編號

							Char.SetData(MonsIndex,CONST.对象_名字, MonsName);
							Char.SetData(MonsIndex,CONST.对象_等级, level);
							local awakeLv = Item.GetData(itemIndex,CONST.道具_最大耐久);	--覺醒等級
							local plus = GetAwakenPower(awakeLv)*100;
							--怪物類型
							local cg1,cg2,cg3,cg4,cg5 = setAssortment(level,monsType);
							Char.SetData(MonsIndex, CONST.对象_体力, cg1+plus);
							Char.SetData(MonsIndex, CONST.对象_力量, cg2+plus);
							Char.SetData(MonsIndex, CONST.对象_强度, cg3+plus);
							Char.SetData(MonsIndex, CONST.对象_速度, cg4+plus);
							Char.SetData(MonsIndex, CONST.对象_魔法, cg5+plus);
							NLG.UpChar(MonsIndex);
							--進化加成(需倚賴在裝備上)
							local itemInfo_4003 = Item.GetData(itemIndex,CONST.道具_自用参数);	--進化加成表
							local equipMod = string.split(itemInfo_4003,',');
							if equipMod[1]=="" then
								for i=1,7 do
									equipMod[i] = tonumber(0);
								end
							else
								for k,v in pairs(equipMod) do
									equipMod[k] = tonumber(v);
								end
							end
							Char.GiveItem(MonsIndex, 19538, 1);
							Char.MoveItem(MonsIndex, 9, 6, -1);
							local item_2 = Char.HaveItem(MonsIndex,19538);
							Item.SetData(item_2,CONST.道具_攻击,equipMod[1]);
							Item.SetData(item_2,CONST.道具_防御,equipMod[2]);
							Item.SetData(item_2,CONST.道具_敏捷,equipMod[3]);
							Item.SetData(item_2,CONST.道具_精神,equipMod[4]);
							Item.SetData(item_2,CONST.道具_回复,equipMod[5]);
							Item.SetData(item_2,CONST.道具_生命,equipMod[6]);
							Item.SetData(item_2,CONST.道具_魔力,equipMod[7]);
							Item.UpItem(MonsIndex, -1);
							Char.SetData(MonsIndex,CONST.对象_血, Char.GetData(MonsIndex,CONST.对象_最大血));
							Char.SetData(MonsIndex,CONST.对象_魔, Char.GetData(MonsIndex,CONST.对象_最大魔));
							NLG.UpChar(MonsIndex);
							--加入戰鬥
							--Char.Warp(MonsIndex,Char.GetData(charIndex,CONST.对象_MAP),Char.GetData(charIndex,CONST.对象_地图),Char.GetData(charIndex,CONST.对象_X),Char.GetData(charIndex,CONST.对象_Y));
							Char.JoinParty(MonsIndex, charIndex, true);
							Battle.JoinBattle(charIndex, MonsIndex);
							standby = standby+1;
						else
						end
					else
					end
					if (standby>=4) then
						goto next
					end
				end
				::next::
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
		local switch = checkAISummon(player);
		--local floor = Char.GetData(player, CONST.对象_地图);
		if (switch==true and Char.PartyNum(player)==-1) then	--地圖檢查(只在指定地圖生效)
			--Char.DischargeParty(player);
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
	local switch = checkAISummon(player);
	--local floor = Char.GetData(player, CONST.对象_地图);
	if (switch==true and battleturn==0) then
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
	if (switch==true) then
		for i=0,9 do
			local ai_index = Battle.GetPlayer(battleIndex,i);
			if ai_index >= 0 then
				if Char.IsDummy(ai_index) and Battle.IsWaitingCommand(ai_index)== 1 then
					local mod1 = Char.GetData(ai_index, CONST.对象_攻击力);
					local mod2 = Char.GetData(ai_index, CONST.对象_防御力);
					local mod3 = Char.GetData(ai_index, CONST.对象_敏捷);
					local mod4 = Char.GetData(ai_index, CONST.对象_精神);
					local mod5 = Char.GetData(ai_index, CONST.对象_回复);
					local mod6 = Char.GetData(ai_index, CONST.对象_最大血);
					local mod7 = Char.GetData(ai_index, CONST.对象_最大魔);
					print(mod1,mod2,mod3,mod4,mod5,mod6,mod7);

					local AIType = Char.GetData(ai_index,CONST.对象_职阶);	--AI模式
					local techId_1 = Char.GetData(ai_index,CONST.对象_金币);		--第一回施放tech編號
					local techId_2 = Char.GetData(ai_index,CONST.对象_银行金币);	--第二回施放tech編號
					local IMAGEId_1,order_1 = math.modf(techId_1 / 100);
					local IMAGEId_2,order_2 = math.modf(techId_2 / 100);
					local order = math.floor(order_1*100);
					--print(IMAGEId_1,order)
					if (#skillParams[IMAGEId_1]>1) then
						if (order==0 or order==1 or order==2 or order==27 or order==29) then
							com1=1;
						elseif (order==3 or order==4 or order==5) then
							com1=2;
						elseif (order==6 or order==7 or order==8) then
							com1=3;
						elseif (order==9 or order==10 or order==11) then
							com1=4;
						end
					else
						com1=1;
					end
					local tSlot = smartTargetSelection(battleIndex,AIType,techId_1);
					if skillCom[IMAGEId_1][com1]==40 or skillCom[IMAGEId_1][com1]==41 then	--全體技能
						com2 = skillCom[IMAGEId_1][com1];
					elseif skillCom[IMAGEId_1][com1]==-1 then	--非指向技能
						com2 = tSlot;
					else
						com2 = tSlot + skillCom[IMAGEId_1][com1];
					end
					local action_tbl = {
					    function() Battle.ActionSelect(ai_index,skillParams[IMAGEId_1][com1], com2, techId_1) end,
					}
					pcall(action_tbl[1])
					--Battle.ActionSelect(ai_index, skillParams[IMAGEId_1][com1], com2, techId_1);

					local petindex = Char.GetPet(ai_index,0);
					local 出战宠物slot = Char.GetData(ai_index,CONST.对象_战宠);
					if (petindex < 0 or 出战宠物slot == -1) then
						local order = math.floor(order_2*100);
						--print(IMAGEId_2,order)
						if (#skillParams[IMAGEId_2]>1) then
							if (order==0 or order==1 or order==2 or order==27 or order==29) then
								com1=1;
							elseif (order==3 or order==4 or order==5) then
								com1=2;
							elseif (order==6 or order==7 or order==8) then
								com1=3;
							elseif (order==9 or order==10 or order==11) then
								com1=4;
							end
						else
							com1=1;
						end
						local tSlot = smartTargetSelection(battleIndex,AIType,techId_2);
						if skillCom[IMAGEId_2][com1]==40 or skillCom[IMAGEId_2][com1]==41 then	--全體技能
							com2 = skillCom[IMAGEId_2][com1];
						elseif skillCom[IMAGEId_2][com1]==-1 then	--非指向技能
							com2 = tSlot;
						else
							com2 = tSlot + skillCom[IMAGEId_2][com1];
						end
						local action_tbl = {
							function() Battle.ActionSelect(ai_index,skillParams[IMAGEId_2][com1], com2, techId_2) end,
						}
						pcall(action_tbl[1])
						--Battle.ActionSelect(ai_index, CONST.BATTLE_COM.BATTLE_COM_ATTACK,math.random(10,19), techId_2);
					end
					NLG.UpChar(ai_index);
				end
			end
		end
	end
end
--回合後事件
function Module:onAfterBattleTurnCallback(battleIndex)
	local player = Battle.GetPlayIndex(battleIndex,0);
	local battleturn = Battle.GetTurn(battleIndex);
	local switch = checkAISummon(player);
	--local floor = Char.GetData(player, CONST.对象_地图);
	if (switch==true and battleturn>=0) then
		Char.SetData(player, CONST.对象_自动战斗开关, 0);
	end
end
--戰鬥結束事件
function Module:onBattleOverCallback(battleIndex)
	local player = Battle.GetPlayer(battleIndex, 0);
	if (player>=0) then
		local switch = checkAISummon(player);
		--local floor = Char.GetData(player, CONST.对象_地图);
		if (switch==true and Char.IsDummy(Battle.GetPlayIndex(battleIndex,1))) then	--地圖檢查(只在指定地圖生效)
			local standby = 0;
			for itemSlot=card_Lslot,card_Rslot do
				local itemIndex = Char.GetItemIndex(player, itemSlot);
				if (itemIndex>0) then
					local itemType = Item.GetData(itemIndex,CONST.对象_类型);		--類型64 AI模式
					local itemInfo_45 = Item.GetData(itemIndex,CONST.道具_特殊类型);	--形象編號
					if (itemType == 64 and itemInfo_45 > 0 and Item.GetData(itemIndex,CONST.道具_最大耐久)>=1) then
						local itemName = Item.GetData(itemIndex,CONST.道具_名字);
						local last = string.find(itemName, "]", 1);
						local MonsName = string.sub(itemName, 2, last-1);
						local monsType = Item.GetData(itemIndex,CONST.道具_幸运);		--怪物類型

						local awakeLv = Item.GetData(itemIndex,CONST.道具_最大耐久);
						local awakeExp = Item.GetData(itemIndex,CONST.道具_耐久);
						local awakeExp = awakeExp + Battle.GetTurn(battleIndex)-1;
						-- 覺醒度經驗
						local need = GetAwakenExpNeed(awakeLv);
						if (awakeExp >= need and need~=0) then
							Item.SetData(itemIndex,CONST.道具_耐久,0);
							Item.SetData(itemIndex,CONST.道具_最大耐久,awakeLv + 1);
							NLG.SystemMessage(player, "[系統]"..MonsName.."覺醒等級提升。");
						elseif (awakeExp < need and need~=0) then
							Item.SetData(itemIndex,CONST.道具_耐久,awakeExp);
						end
						--進化
						if (awakeLv==3600 and Item.GetData(itemIndex,CONST.道具_丢地消失)==0) then
							Item.SetData(itemIndex,CONST.道具_丢地消失,1);
							Item.SetData(itemIndex,CONST.道具_宠邮,0);
							Item.SetData(itemIndex,CONST.道具_自用参数,Assortment[monsType][2]);
							Item.SetData(itemIndex,CONST.道具_特殊类型,Item.GetData(itemIndex,CONST.道具_特殊类型)+1);	--形象編號
							NLG.SystemMessage(player, "[系統]"..MonsName.."發出光芒，外型似乎出現變化。");
						end
						Item.UpItem(player, itemSlot);
						NLG.UpChar(player);
						standby = standby+1;
					end
				end
				if (standby>=4) then
					goto next
				end
			end
			::next::
			Char.DischargeParty(player);
			if (Char.GetData(player,CONST.对象_队聊开关) == 1) then
				NLG.SystemMessage(player, "[系統]位於特殊區域戰鬥結束即解散隊伍。");
			end
		end
	end
	return 0;
end

-- 檢查是否有AI模式
function checkAISummon(player)
	for itemSlot=card_Lslot,card_Rslot do
		local itemIndex = Char.GetItemIndex(player,itemSlot);
		if (itemIndex>0) then
			local itemType = Item.GetData(itemIndex,CONST.对象_类型);		--類型64 AI模式
			local itemInfo_45 = Item.GetData(itemIndex,CONST.道具_特殊类型);	--形象編號
			if (itemType == 64 and itemInfo_45 > 0) then
				return true
			end
		end
	end
	return false
end
--AI模式選擇目標對象
function smartTargetSelection(battleIndex,AIType,techId)
  local tSlot = 10;
  -- NOTE 敵方隨機目標
  if (AIType==1) then	-- NOTE 敵方首領目標
    local tSlot = 10;
    return tSlot;
  elseif (AIType==2) then	-- NOTE 敵方血低
    local tagHp = nil;
    for slot = 10,19 do
      local charIndex = Battle.GetPlayer(battleIndex, slot);
      if (charIndex >= 0) then
        local hpRatio = Char.GetData(charIndex, CONST.对象_血) / Char.GetData(charIndex, CONST.对象_最大血);
        if tagHp == nil then
          tagHp = hpRatio;
          tSlot = slot;
        elseif hpRatio < tagHp then	--敵方血量占比最低
          tagHp = hpRatio;
          tSlot = slot;
        end
      end
    end
    return tSlot;
  elseif (AIType==3) then	-- NOTE 敵方血高
    local tagHp = nil;
    for slot = 10,19 do
      local charIndex = Battle.GetPlayer(battleIndex, slot);
      if (charIndex >= 0) then
        local hpRatio = Char.GetData(charIndex, CONST.对象_血) / Char.GetData(charIndex, CONST.对象_最大血);
        if tagHp == nil then
          tagHp = hpRatio;
          tSlot = slot;
        elseif hpRatio > tagHp then	--敵方血量占比最高
          tagHp = hpRatio;
          tSlot = slot;
        end
      end
    end
    return tSlot;
  elseif (AIType==4) then
    local tSlot = math.random(10,19);
    return tSlot;
  elseif (AIType==5) then	-- NOTE 我方血低
    local tagHp = nil;
    for slot = 0,9 do
      local charIndex = Battle.GetPlayer(battleIndex, slot);
      if (charIndex >= 0) then
        local hpRatio = Char.GetData(charIndex, CONST.对象_血) / Char.GetData(charIndex, CONST.对象_最大血);
        if tagHp == nil then
          tagHp = hpRatio;
          tSlot = slot;
        elseif hpRatio < tagHp then	--己方血量占比最低
          tagHp = hpRatio;
          tSlot = slot;
        end
      end
    end
    return tSlot;
  elseif (AIType==6) then	-- NOTE 我方隊長目標
    local tSlot = 0;
    return tSlot;
  end
  return tSlot;
end
-- 怪獸類型及配點
function setAssortment(level,monsType)
	local cg1,cg2,cg3,cg4,cg5 = 0,0,0,0,0;
	if (monsType==1) then	--力速型
		cg2 = (15+(level-1)*2)*100;
		cg4 = (15+(level-1)*2)*100;
	elseif (monsType==2) then	--魔速型
		cg5 = (15+(level-1)*2)*100;
		cg4 = (15+(level-1)*2)*100;
	elseif (monsType==3) then	--體速型
		cg1 = (15+(level-1)*2)*100;
		cg4 = (15+(level-1)*2)*100;
	elseif (monsType==4) then	--魔防型
		cg5 = (15+(level-1)*2)*100;
		cg3 = (15+(level-1)*2)*100;
	elseif (monsType==5) then	--力體速型
		if level<=101 then
			cg4 = level*100;
			cg2 = (15+(level-1)*2)*100;
			cg1 = (15+(level-1)*2 - level)*100;
		else
			cg4 = 10000;	--100敏
			cg2 = (15+(level-1)*2)*100;
			cg1 = (15+(level-1)*2 - 100)*100;
		end
	elseif (monsType==6) then	--魔體速型
		if level<=101 then
			cg4 = level*100;
			cg5 = (15+(level-1)*2)*100;
			cg1 = (15+(level-1)*2 - level)*100;
		else
			cg4 = 10000;	--100敏
			cg5 = (15+(level-1)*2)*100;
			cg1 = (15+(level-1)*2 - 100)*100;
		end
	end
	return cg1,cg2,cg3,cg4,cg5;
end

-- 覺醒度表
function GetAwakenExpNeed(lv)
	if lv >= 9999 then return 0 end
    local K = 9999;
    local C = 500;
	return math.floor(K * lv / (lv + C));
end
-- 累積型加成表
function GetAwakenPower(lv)
    local Pmax = 900;
    local C = 2500;
	return math.floor(Pmax * lv^2 / (lv^2 + C^2) ) ;
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
