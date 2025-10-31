---模块类
local Module = ModuleBase:createModule('luaTech')


--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BattleLuaSkillEvent', Func.bind(self.OnBattleLuaSkillEventCallback, self))

end


function Module:OnBattleLuaSkillEventCallback(battleIndex, charIndex, SKLFunc, DMGFunc)
  local charSide = Char.GetData(charIndex,CONST.对象_战斗Side);
  local attkSlot = Char.GetData(charIndex,CONST.CHAR_BattleCom2);
  --print(charSide,attkSlot)
  local attkSlot = real_slot(battleIndex,attkSlot);
  local userTechId = Char.GetData(charIndex,CONST.CHAR_BattleCom3);
  local techIndex = Tech.GetTechIndex(userTechId);
  local tech_PM = Tech.GetData(techIndex, CONST.TECH_OPTION);
  local techlv = Tech.GetData(techIndex, CONST.TECH_NECESSARYLV);
  --local techrange = Tech.GetData(techIndex, CONST.TECH_TARGET);
  --目標轉換成矩陣列
  local attkSlot_list = {};
  if (attkSlot<20) then
    table.insert(attkSlot_list, attkSlot);
  elseif (attkSlot>=20 and attkSlot<=29) then
    attkSlot_list = calcTarget(attkSlot);
  elseif (attkSlot>=30 and attkSlot<=39) then
    attkSlot_list = calcTarget(attkSlot);
  elseif (attkSlot==40) then
    attkSlot_list = {0,1,2,3,4,5,6,7,8,9};
  elseif (attkSlot==41) then
    attkSlot_list = {10,11,12,13,14,15,16,17,18,19};
  end
  local skillId = Tech.GetData(techIndex, CONST.TECH_SKILLID);
  local skillIndex = Skill.GetSkillIndex(skillId);
  local skilltype = Skill.GetData(skillIndex, CONST.SKILL_WHICHASSORT);		--0被動 1戰鬥 3魔法

  --矩陣列各目標演譯
  table.forEach(attkSlot_list, function(e)
  local targetEnemy = Battle.GetPlayer(battleIndex, e);
  if (targetEnemy>0) then
    --傷害公式
    local dmg = calcDMG(skilltype,charIndex,targetEnemy);
    --tech總集合的skill
    local skilltech = math.floor(tonumber(userTechId)/100)
    --print(e,targetEnemy,skilltech)
    if (skilltech==2009) then
      --技能動畫圖檔
      local techId = 200899+tonumber(techlv);
      if e==attkSlot_list[1] then	--限定只發一次才不卡
        SKLFunc(techId);
      end
      --顯示傷害值
      Char.SetData(targetEnemy,CONST.对象_血,Char.GetData(targetEnemy,CONST.对象_血)-dmg);
      --技能動畫演譯(不同BM_FLAG)
      local targetEnemy_Com1 = Char.GetData(targetEnemy,CONST.CHAR_BattleCom1);
      local targetEnemy_Com2 = Char.GetData(targetEnemy,CONST.CHAR_BattleCom2);
      local targetEnemy_Com3 = Char.GetData(targetEnemy,CONST.CHAR_BattleCom3);

      local 被攻击方攻反状态 = Char.GetData(targetEnemy,CONST.对象_DamageReflec);
      local 被攻击方攻吸状态 = Char.GetData(targetEnemy,CONST.对象_DamageAbsrob);
      local 被攻击方攻无状态 = Char.GetData(targetEnemy,CONST.对象_DamageVanish);
      local 被攻击方魔吸状态 = Char.GetData(targetEnemy,CONST.对象_DamageMagicAbsrob);
      local 被攻击方魔反状态 = Char.GetData(targetEnemy,CONST.对象_DamageMagicReflec);
      local 被攻击方魔无状态 = Char.GetData(targetEnemy,CONST.对象_DamageMagicVanish);
      local 被攻击方恢复状态 = Char.GetData(targetEnemy,CONST.对象_LpRecovery);
      --print(targetEnemy_Com1,targetEnemy_Com2,targetEnemy_Com3)
      if (targetEnemy_Com1==1 or targetEnemy_Com1==43) then		--GUARD=0x1.SPECIALGARD=0x2B
        local cri_rate = Char.GetData(charIndex,CONST.对象_必杀);
        if ( cri_rate >= math.random(1,100) ) then
          local dmg = dmg*1.25;
          if ( Char.GetData(targetEnemy,CONST.对象_血)<=0 ) then
            if (targetEnemy_Com1==1) then
              local dmg = dmg*0.8;
              DMGFunc(attkSlot,38,dmg);		--死亡0x20.必杀0x2.物理防御0x4
            elseif (targetEnemy_Com1==43) then
              local dmg = dmg*0.5;
              DMGFunc(attkSlot,1058,dmg);		--死亡0x20.必杀0x2.聖盾0x400
            end
            Char.SetData(targetEnemy,CONST.对象_战死,1);
          else
            if (targetEnemy_Com1==1) then
              local dmg = dmg*0.8;
              DMGFunc(e,6,dmg);		--必殺0x2.防禦0x4
            elseif (targetEnemy_Com1==43) then
              local dmg = dmg*0.5;
              DMGFunc(e,1026,dmg);		--必殺0x2.聖盾0x400
            end
          end
        else
          if ( Char.GetData(targetEnemy,CONST.对象_血)<=0 ) then
            if (targetEnemy_Com1==1) then
              local dmg = dmg*0.8;
              DMGFunc(attkSlot,37,dmg);		--死亡0x20.普通0x1.物理防御0x4
            elseif (targetEnemy_Com1==43) then
              local dmg = dmg*0.5;
              DMGFunc(attkSlot,1057,dmg);		--死亡0x20.普通0x1.聖盾0x400
            end
            Char.SetData(targetEnemy,CONST.对象_战死,1);
          else
            if (targetEnemy_Com1==1) then
              local dmg = dmg*0.8;
              DMGFunc(e,5,dmg);			--普通0x1.防禦0x4
            elseif (targetEnemy_Com1==43) then
              local dmg = dmg*0.5;
              DMGFunc(e,1025,dmg);		--普通0x1.聖盾0x400
            end
          end
        end
        --命中時給目標設置數據(特殊效果)
        Char.SetData(targetEnemy,CONST.对象_攻击力, Char.GetData(targetEnemy,CONST.对象_攻击力)-10);
        Char.SetData(targetEnemy,CONST.CHAR_BattleModPoison,2);		--中毒
        Char.SetData(targetEnemy,CONST.对象_ENEMY_HeadGraNo,114175);
        NLG.UpChar(targetEnemy);
        NLG.UpChar(charIndex);
      elseif (targetEnemy_Com1==19 or targetEnemy_Com1==41) then		--EDGE=0x13.P_DODGE=0x29
        if (targetEnemy_Com1==41) then 
          DMGFunc(e,257,0);		--普通0x1.陽炎閃避0x100
        else 
          DMGFunc(e,9,0);		--普通0x1.閃避0x8
        end
      --技能要不觸發巫術以下elseif註解省略
      elseif (skilltype==1 and (被攻击方攻反状态>=1 or 被攻击方攻吸状态>=1 or 被攻击方攻无状态>=1)) then		--BATTLE_COM攻反吸無0x33~0x35
        if (被攻击方攻反状态>=1) then DMGFunc(e,8193,0); end		--普通0x1.攻反0x2000
        if (被攻击方攻吸状态>=1) then DMGFunc(e,16385,0); end		--普通0x1.攻吸0x4000
        if (被攻击方攻无状态>=1) then DMGFunc(e,32769,0); end		--普通0x1.攻无0x8000
      elseif (skilltype==3 and (被攻击方魔反状态>=1 or 被攻击方魔吸状态>=1 or 被攻击方魔无状态>=1)) then		--BATTLE_COM魔吸反無0x36~0x38
        if (被攻击方魔反状态>=1) then DMGFunc(e,65537,0); end		--普通0x1.魔反0x10000
        if (被攻击方魔吸状态>=1) then DMGFunc(e,131073,0); end		--普通0x1.魔吸0x20000
        if (被攻击方魔无状态>=1) then DMGFunc(e,262145,0); end		--普通0x1.魔无0x40000
      else
        --非防禦、聖盾擊中時(內建不能護衛、反擊)
        local cri_rate = Char.GetData(charIndex,CONST.对象_必杀);
        if ( cri_rate >= math.random(1,100) ) then
          local dmg = dmg*1.25;
          if ( Char.GetData(targetEnemy,CONST.对象_血)<=0 ) then
            if (dmg >= 2*Char.GetData(targetEnemy,CONST.对象_最大血)) then
              local AKO = math.random(1,2);
              if AKO==1 then DMGFunc(attkSlot,97,dmg); end
              if AKO==2 then DMGFunc(attkSlot,162,dmg); end
            else
              DMGFunc(attkSlot,34,dmg);		--死亡0x20.必杀0x2
            end
            Char.SetData(targetEnemy,CONST.对象_战死,1);
          else
            DMGFunc(e,2,dmg);		--必殺
          end
        else
          if ( Char.GetData(targetEnemy,CONST.对象_血)<=0 ) then
            if (dmg >= 2*Char.GetData(targetEnemy,CONST.对象_最大血)) then
              local AKO = math.random(1,2);
              if AKO==1 then DMGFunc(attkSlot,97,dmg); end
              if AKO==2 then DMGFunc(attkSlot,161,dmg); end
            else
              DMGFunc(attkSlot,33,dmg);		--死亡0x20.普通0x1
            end
            Char.SetData(targetEnemy,CONST.对象_战死,1);
          else
            DMGFunc(e,1,dmg);		--普通
          end
        end
        --命中時給目標設置數據(特殊效果)
        Char.SetData(targetEnemy,CONST.对象_攻击力, Char.GetData(targetEnemy,CONST.对象_攻击力)-10);
        Char.SetData(targetEnemy,CONST.CHAR_BattleModPoison,2);		--中毒
        Char.SetData(targetEnemy,CONST.对象_ENEMY_HeadGraNo,114175);
        NLG.UpChar(targetEnemy);
        NLG.UpChar(charIndex);
      end

    else
    end

  end
  end)


end


function real_slot(battleIndex,attkSlot)
  if (attkSlot<10) then
    local enemy = Battle.GetPlayer(battleIndex, attkSlot);
    local Slot = Battle.GetEntryPosition(battleIndex,enemy);
    return Slot
  elseif (attkSlot>=10 and attkSlot<20) then
    local enemy = Battle.GetPlayer(battleIndex, attkSlot);
    local Slot = Battle.GetEntryPosition(battleIndex,enemy);
    return Slot
  elseif (attkSlot>=20 and attkSlot<=29) then
    local enemy = Battle.GetPlayer(battleIndex, attkSlot-20);
    local Slot = Battle.GetEntryPosition(battleIndex,enemy);
    return Slot+20
  elseif (attkSlot>=30 and attkSlot<=39) then
    local enemy = Battle.GetPlayer(battleIndex, attkSlot-20);
    local Slot = Battle.GetEntryPosition(battleIndex,enemy);
    return Slot+20
  end
  return attkSlot
end

function calcTarget(attkSlot)
  local attkSlot_list = {};
  if attkSlot==20 then attkSlot_list = {0,1,2,5};
  elseif attkSlot==21 then attkSlot_list = {1,3,0,6};
  elseif attkSlot==22 then attkSlot_list = {2,5,0,7};
  elseif attkSlot==23 then attkSlot_list = {3,1,8};
  elseif attkSlot==24 then attkSlot_list = {4,2,9};
  elseif attkSlot==25 then attkSlot_list = {5,6,7,0};
  elseif attkSlot==26 then attkSlot_list = {6,8,5,1};
  elseif attkSlot==27 then attkSlot_list = {7,9,5,2};
  elseif attkSlot==28 then attkSlot_list = {8,6,3};
  elseif attkSlot==29 then attkSlot_list = {9,7,4};
  elseif attkSlot==30 then attkSlot_list = {10,11,12,15};
  elseif attkSlot==31 then attkSlot_list = {11,13,10,16};
  elseif attkSlot==32 then attkSlot_list = {12,15,10,17};
  elseif attkSlot==33 then attkSlot_list = {13,11,18};
  elseif attkSlot==34 then attkSlot_list = {14,12,19};
  elseif attkSlot==35 then attkSlot_list = {15,16,17,10};
  elseif attkSlot==36 then attkSlot_list = {16,18,15,11};
  elseif attkSlot==37 then attkSlot_list = {17,19,15,12};
  elseif attkSlot==38 then attkSlot_list = {18,16,13};
  elseif attkSlot==39 then attkSlot_list = {19,17,14};
  end
  return attkSlot_list
end

function calcDMG(skilltype,charIndex,targetEnemy)
    if (skilltype==1) then	--物理傷害基礎公式
      local 技能攻击加成 = 100;	--Battle.GetTechOption(charIndex, DD:)
      local 技能防御加成 = 100;
      local 面板攻击 = Char.GetData(charIndex,CONST.对象_攻击力);
      local 面板防御 = Char.GetData(targetEnemy,CONST.对象_防御力);
      local 攻击方最终攻击 = math.ceil((技能攻击加成)/ 100 * 面板攻击 + 面板攻击);
      local 被攻击方最终防御 = math.ceil((技能防御加成) / 100 * 面板防御 + 面板防御);
      if 攻击方最终攻击>241 then 最终攻击 = math.ceil((攻击方最终攻击-241)*0.3+241); else 最终攻击=攻击方最终攻击; end
      if 被攻击方最终防御>241 then 最终防御 = math.ceil((被攻击方最终防御-241)*0.3+241); else 最终防御=被攻击方最终防御; end
      local 伤害 = (最终攻击*最终攻击) / ( 最终攻击/3+最终防御 );

      local ap = {}
      ap[1] = Char.GetData(charIndex, CONST.对象_地属性);
      ap[2] = Char.GetData(charIndex, CONST.对象_水属性);
      ap[3] = Char.GetData(charIndex, CONST.对象_火属性);
      ap[4] = Char.GetData(charIndex, CONST.对象_风属性);
      local dp = {}
      dp[1] = Char.GetData(charIndex, CONST.对象_地属性);
      dp[2] = Char.GetData(charIndex, CONST.对象_水属性);
      dp[3] = Char.GetData(charIndex, CONST.对象_火属性);
      dp[4] = Char.GetData(charIndex, CONST.对象_风属性);
      local 屬性剋制 = Battle.CalcPropScore(ap, dp);
      local 種族剋制 = Battle.CalcAttributeDmgRate(charIndex,targetEnemy);
      --print(屬性剋制,種族剋制)
      local dmg = 伤害 * ( 100 + 屬性剋制 + 種族剋制 ) / 100 * NLG.Rand(90,110) / 100 * math.ceil( 1 * 1 *  1.15 * ( 100 - 0 ) / 100 );		--傷害 * ( 100 + 屬性剋制 + 種族剋制 ) / 100 * rand(90,110) / 100 * [ 石化折扣率 * 野外係數倍率 *  武器傷害倍率 * ( 100 - 祈禱傷害減傷 ) / 100 ]
      local dmg = math.floor(dmg);
      if (dmg<0) then dmg=20*(NLG.Rand(90,110)/100); end
      return dmg
    elseif (skilltype==3) then	--魔法傷害基礎公式
      local 技能攻击加成 = 100;	--Battle.GetTechOption(charIndex, AR:)
      local 技能防御加成 = 100;
      local 面板攻击 = Char.GetData(charIndex,CONST.对象_精神);
      local 面板防御 = Char.GetData(targetEnemy,CONST.对象_防御力)*0.5 + Char.GetData(targetEnemy,CONST.对象_精神)*1.15;
      local 攻击方最终攻击 = math.ceil((技能攻击加成)/ 100 * 面板攻击 + 面板攻击);
      local 被攻击方最终防御 = math.ceil((技能防御加成) / 100 * 面板防御 + 面板防御);
      if 攻击方最终攻击>241 then 最终攻击 = math.ceil((攻击方最终攻击-241)*0.3+241); else 最终攻击=攻击方最终攻击; end
      if 被攻击方最终防御>241 then 最终防御 = math.ceil((被攻击方最终防御-241)*0.3+241); else 最终防御=被攻击方最终防御; end
      local 伤害 = (最终攻击*最终攻击) / ( 最终攻击/3+最终防御 );

      local ap = {}
      ap[1] = Char.GetData(charIndex, CONST.对象_地属性);
      ap[2] = Char.GetData(charIndex, CONST.对象_水属性);
      ap[3] = Char.GetData(charIndex, CONST.对象_火属性);
      ap[4] = Char.GetData(charIndex, CONST.对象_风属性);
      local dp = {}
      dp[1] = Char.GetData(charIndex, CONST.对象_地属性);
      dp[2] = Char.GetData(charIndex, CONST.对象_水属性);
      dp[3] = Char.GetData(charIndex, CONST.对象_火属性);
      dp[4] = Char.GetData(charIndex, CONST.对象_风属性);
      local 屬性剋制 = Battle.CalcPropScore(ap, dp);
      local 種族剋制 = Battle.CalcAttributeDmgRate(charIndex,targetEnemy);
      --print(屬性剋制,種族剋制)
      local dmg = 伤害 * ( 100 + (屬性剋制*1.2) + 種族剋制 ) / 100 * NLG.Rand(90,110) / 100 * math.ceil( 1 * 1 *  1.15 * ( 100 - 0 ) / 100 );		--傷害 * ( 100 + 屬性剋制 + 種族剋制 ) / 100 * rand(90,110) / 100 * [ 石化折扣率 * 野外係數倍率 *  武器傷害倍率 * ( 100 - 祈禱傷害減傷 ) / 100 ]
      local dmg = math.floor(dmg);
      if (dmg<0) then dmg=20*(NLG.Rand(90,110)/100); end
      return dmg
    end
    return 1
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
