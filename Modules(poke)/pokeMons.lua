local Module = ModuleBase:createModule('pokeMons')

local AIinfo = {
  "敵方隨機目標",
  "我方血少目標",
  "敵方血少目標",
  "敵方血多目標",
  "敵方首領目標",
  "我方隊長目標",
}

local Assortment = {
  "力速型",
  "魔速型",
  "體速型",
  "魔防型",
  "力體速型",
  "魔體速型",
}
local skillParams={
  -- 自创技能
  [2005] = {CONST.BATTLE_COM.BATTLE_COM_P_SPIRACLESHOT},
  [106] = {CONST.BATTLE_COM.BATTLE_COM_ATTACKALL},
  [3100] = {CONST.BATTLE_COM.BATTLE_COM_P_PARAMETER,CONST.BATTLE_COM.BATTLE_COM_P_SPIRACLESHOT,CONST.BATTLE_COM.BATTLE_COM_P_PARAMETER},
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
  [27] = {40},	-- 超强陨石
  [28] = {40},	-- 超强冰冻
  [29] = {40},	-- 超强火焰
  [30] = {40},	-- 超强风刃

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

tbl_MonsIndex = tbl_MonsIndex or {}
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

      local itemInfo_46 = Item.GetData(APPIndex,CONST.道具_子参一);	--第一回施放tech編號
      local TechIndex_46 = Tech.GetTechIndex(itemInfo_46);
      local TechName_46 = Tech.GetData(TechIndex_46, CONST.TECH_NAME);

      local itemInfo_47 = Item.GetData(APPIndex,CONST.道具_子参二);	--第二回施放tech編號
      local TechIndex_47 = Tech.GetTechIndex(itemInfo_47);
      local TechName_47 = Tech.GetData(TechIndex_47, CONST.TECH_NAME);
      local imageText = "@g,"..itemInfo_45..",2,8,6,0@"
      msg = imageText .. "　　　　　　　　【喚獸卡牌行動模式】\\n"
               .. "　　$4".. MonsName .. "\\n"
               .. "　　　　　　　$2喚獸類型 ["..Assortment[monsType].."]　人形系\\n"
               .. "　　　　　　　$1行動模式 ["..AIinfo[AIType].."]\\n"
               .. "　　　　　　　$1一動技能 ["..TechName_46.."]\\n"
               .. "　　　　　　　$1二動技能 ["..TechName_47.."]\\n"
               .. "　　　　　　　$5地 ".. Goal_DataPos_14/10 .."　" .."$5水 ".. Goal_DataPos_15/10 .."　" .."$5火 ".. Goal_DataPos_16/10 .."　" .."$5風 ".. Goal_DataPos_17/10 .."\\n"
               .. "　　　　　　　$4▽額外加成能力▽\\n"
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
      local monsTypeName = Assortment[monsType];
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
				for itemSlot=8,11 do
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
							--怪物類型
							local cg1,cg2,cg3,cg4,cg5 = setAssortment(level,monsType);
							Char.SetData(MonsIndex, CONST.对象_体力, cg1);
							Char.SetData(MonsIndex, CONST.对象_力量, cg2);
							Char.SetData(MonsIndex, CONST.对象_强度, cg3);
							Char.SetData(MonsIndex, CONST.对象_速度, cg4);
							Char.SetData(MonsIndex, CONST.对象_魔法, cg5);
							NLG.UpChar(MonsIndex);
							--進化加成(需倚賴在裝備上)
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
						else
						end
					else
					end
				end
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
						com2 = skillCom[IMAGEId_1][com1];
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
						elseif skillCom[IMAGEId_1][com1]==-1 then	--非指向技能
							com2 = skillCom[IMAGEId_1][com1];
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
	for itemSlot=8,11 do
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
  if (AIType==1) then
    local tSlot = math.random(10,19);
    return tSlot;
  elseif (AIType==2) then	-- NOTE 我方血少
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
  elseif (AIType==3) then	-- NOTE 敵方血少
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
  elseif (AIType==4) then	-- NOTE 敵方血多
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
  elseif (AIType==5) then	-- NOTE 敵方首領目標
    local tSlot = 10;
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
