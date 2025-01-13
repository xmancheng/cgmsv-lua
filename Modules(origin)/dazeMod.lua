---模块类
local Module = ModuleBase:createModule(dazeMod)

--多重施法设置
--local boom_skill_list = {3,266,267,268,269,270,271};	--多重施法的skill列表
local boom_dmg_rate = {0.75,0.50,0.25,0.01}	--不同重技能对应伤害削弱，类似于乱射
local boom_list = {}
local boom_cnt_num = {}
local boom_cnt_num_aoe = {}
local boom_tag = {}

local BondImage_List = {};
BondImage_List[1] = {{106627},50,10,CONST.战属_攻增,-10};		--形象组合、几率、敌我(10,0)、战属、增减数值%

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load');
  self:regCallback('BattleActionTargetEvent',Func.bind(self.battleActionTargetCallback,self))
  self:regCallback('DamageCalculateEvent',Func.bind(self.damageCalculateCallback,self))
  --self:regCallback('BattleStartEvent', Func.bind(self.OnbattleStarCommand, self))
  self:regCallback('BeforeBattleTurnEvent', Func.bind(self.OnbattleStarCommand, self))
  self:regCallback('AfterBattleTurnEvent', Func.bind(self.OnAfterBattleTurnCommand, self))

end

-------------------------------------------------------
--动作目标事件
function Module:battleActionTargetCallback(charIndex, battleIndex, com1, com2, com3, tgl)
	--self:logDebug('battleActionTargetCallback', charIndex, battleIndex, com1, com2, com3, tgl)
	local leader1 = Battle.GetPlayer(battleIndex,0)
	local leader2 = Battle.GetPlayer(battleIndex,5)
	local leader = leader1
	if Char.GetData(leader2, CONST.对象_类型) == CONST.对象类型_人 then
		leader = leader2
	end
	if Char.IsPlayer(charIndex) then
		local skill302_rate = calcParalysisRate(charIndex,skillId)*2;		--麻痹词条为2%
		if (skill302_rate >= NLG.Rand(1,100)) then		--麻痹
			local defCharIndex = Battle.GetPlayer(battleIndex,tgl[1]);
			local para_debuff = Char.GetTempData(defCharIndex, '麻痹') or 0;
			if (para_debuff<=0) then
				Char.SetTempData(defCharIndex, '麻痹', 3);
				--NLG.SystemMessage(leader, "[系統]發動使敵人陷入麻痺");
			end
		end
		boom_list[charIndex] = 0;
		boom_cnt_num[charIndex] = 0;
		boom_cnt_num_aoe[charIndex] = {};
		if #tgl > 1 then
			boom_tag[charIndex] = 1
		else 
			boom_tag[charIndex] = 0
		end
		local skillId = Tech.GetData(Tech.GetTechIndex(com3), CONST.TECH_SKILLID);
		--if (CheckInTable(boom_skill_list, skillId)==true) then
		if (skillId >= 0) then
			local skill300_rate = calcWhirlwindRate(charIndex,skillId)*10;		--回旋击词条为10%
			local com_name = Tech.GetData(Tech.GetTechIndex(com3), CONST.TECH_NAME);
			local copy_num = 3;
			if (skill300_rate >= NLG.Rand(1,100)) then
				local msg_name =  Char.GetData(charIndex,CONST.对象_名字);
				--NLG.SystemMessage(charIndex, msg_name.."："..skill300_rate.."%發動"..copy_num.."倍 "..com_name);
				boom_list[charIndex] = 1
				local return_tgl = copy_list(tgl,copy_num)	
				return 	return_tgl	
			end
		else
			return tgl
		end
	elseif Char.IsPet(charIndex) then
		if (com3==300) then		--挑拨迷惑
			if (NLG.Rand(1,4) >= 3) then
				local defCharIndex = Battle.GetPlayer(battleIndex,tgl[1]);
				local daze_debuff = Char.GetTempData(defCharIndex, '迷惑') or 0;
				if (daze_debuff<=0) then
					Char.SetTempData(defCharIndex, '迷惑', 5);
					--NLG.SystemMessage(leader, "[系統]發動挑撥敵人陷入迷惑");
				end
			end
		end
		return tgl
	elseif Char.IsEnemy(charIndex) then
		local PosSlot = Battle.GetPos(battleIndex,charIndex);
		local PosName = position(PosSlot);
		local EnemyName = Char.GetData(charIndex,CONST.对象_名字);
		local daze_debuff = Char.GetTempData(charIndex, '迷惑') or 0;
		local para_debuff = Char.GetTempData(charIndex, '麻痹') or 0;
		if (daze_debuff>0) then
			NLG.SystemMessage(-1, "[系統]"..PosName.."的"..EnemyName.."陷入迷惑");
			Char.SetTempData(leader, '迷惑', daze_debuff-1);
			local tgl = calcPlayerHighHP_list(tgl,battleIndex);
			return tgl
		elseif (para_debuff>0 and daze_debuff<=0) then
			NLG.SystemMessage(-1, "[系統]"..PosName.."的"..EnemyName.."陷入麻痺");
			Char.SetTempData(leader, '麻痹', para_debuff-1);
			tgl[1]=30;
			local tgl = tgl;
			return tgl
		else
			return tgl
		end
    end
end

--增加回旋击目标
function copy_list(list, times)
    local new_list = {}
    for i = 1, times do
        for _, value in ipairs(list) do
			--local value = math.random(value-1,value+1)
            table.insert(new_list, value);
        end
    end
    return new_list
end
--计算回旋击发动率
function calcWhirlwindRate(charIndex)
    local skill_rate=0;
    for slot=0,6 do
      local itemIndex = Char.GetItemIndex(charIndex,slot);
      if (itemIndex >= 0 and Item.GetData(itemIndex, CONST.道具_子参二)==40) then		--人装词条类别40
        local boom_Skill_x = string.split(Item.GetData(itemIndex, CONST.道具_USEFUNC),",");
        for i=1,#boom_Skill_x do
          local skillId_x = tonumber(boom_Skill_x[i]);
          if (skillId_x>0 and skillId_x==300) then
            skill_rate = skill_rate + 1;
          else
            skill_rate = skill_rate;
          end
        end
      end
    end
    return skill_rate
end
--计算麻痹发动率
function calcParalysisRate(charIndex)
    local skill_rate=0;
    for slot=0,6 do
      local itemIndex = Char.GetItemIndex(charIndex,slot);
      if (itemIndex >= 0 and Item.GetData(itemIndex, CONST.道具_子参二)==40) then		--人装词条类别40
        local paralysis_Skill_x = string.split(Item.GetData(itemIndex, CONST.道具_USEFUNC),",");
        for i=1,#paralysis_Skill_x do
          local skillId_x = tonumber(paralysis_Skill_x[i]);
          if (skillId_x>0 and skillId_x==302) then
            skill_rate = skill_rate + 1;
          else
            skill_rate = skill_rate;
          end
        end
      end
    end
    return skill_rate
end
--计算我方最高血
function calcPlayerHighHP_list(tgl,battleIndex)
    local new_list = {}
	local HP_More={};
	HP_More[1]=1;
	HP_More[2]=0;
	for i = 0,9 do
		local player = Battle.GetPlayer(battleIndex, i);
		if (player>=0) then
			local HP = Char.GetData(player,CONST.对象_血);
			if (HP>=HP_More[1]) then
				HP_More[1]=HP;
				HP_More[2]=i;
			else
				HP_More[1]=HP_More[1];
				HP_More[2]=HP_More[2];
			end
		end
	end
	for key,value in ipairs(tgl) do
		if (value<10) then
			tgl[key]=HP_More[2];
		end
	end
	local new_list = tgl;
    return new_list
end

-------------------------------------------------------
--伤害事件
function Module:damageCalculateCallback(CharIndex, DefCharIndex, OriDamage, Damage, BattleIndex, Com1, Com2, Com3, DefCom1, DefCom2, DefCom3, Flg, ExFlg)
	local leader1 = Battle.GetPlayer(BattleIndex,0)
	local leader2 = Battle.GetPlayer(BattleIndex,5)
	local leader = leader1
	if Char.GetData(leader2, CONST.对象_类型) == CONST.对象类型_人 then
		leader = leader2
	end
	if Char.IsPlayer(CharIndex) then
		if (Flg == CONST.DamageFlags.Magic) then
			local super_skill_list = {19,20,21,22,23,24,25,26,27,28,29,30,31,1011};
			local skillId = Tech.GetData(Tech.GetTechIndex(Com3), CONST.TECH_SKILLID);
			if (CheckInTable(super_skill_list, skillId)==true) then
				local skill303_rate = calcChantCoeff(CharIndex)*5;		--咏唱词条为5%
				if (skill303_rate >= NLG.Rand(1,100)) then
					NLG.SystemMessage(leader, "[系統]發動重強度150%詠唱");
					local Damage = math.floor(Damage*1.50);
					return Damage
				end
				return Damage
			end
			return Damage
		elseif (Flg == CONST.DamageFlags.Normal or Flg == CONST.DamageFlags.Critical) then
			if (boom_list[CharIndex] == 1) then
				local cnt = 0
				if (boom_tag[CharIndex] == 1) then
					cnt = boom_cnt_num_aoe[CharIndex][DefCharIndex] or 0;
				elseif (boom_tag[CharIndex] == 0) then
					cnt = boom_cnt_num[CharIndex] or 0;
				else
					return Damage
				end
				local max_cnt = #boom_dmg_rate;

				local skill_Coeff = calcDamageCoeff(CharIndex)*0.05;
				local Damage = math.floor((boom_dmg_rate[cnt+1]+skill_Coeff)*Damage);
				if (boom_tag[CharIndex] == 1) then
					boom_cnt_num_aoe[CharIndex][DefCharIndex] = cnt + 1;
				elseif (boom_tag[CharIndex] == 0) then
					boom_cnt_num[CharIndex]  = cnt + 1;
				end
				return Damage
			end
			return Damage
		end
		return Damage
	else
		return Damage
	end
end
--计算回旋击增伤系数
function calcDamageCoeff(charIndex)
    local skill_Coeff=0;
    for slot=0,6 do
      local itemIndex = Char.GetItemIndex(charIndex,slot);
      if (itemIndex >= 0 and Item.GetData(itemIndex, CONST.道具_子参二)==40) then		--人装词条类别40
        local crit_Skill_x = string.split(Item.GetData(itemIndex, CONST.道具_USEFUNC),",");
        for i=1,#crit_Skill_x do
          local skillId_x = tonumber(crit_Skill_x[i]);
          if (skillId_x>0 and skillId_x==301) then
            skill_Coeff = skill_Coeff + 1;
          else
            skill_Coeff = skill_Coeff;
          end
        end
      end
    end
    return skill_Coeff
end
--计算咏唱增伤系数
function calcChantCoeff(charIndex)
    local skill_Coeff=0;
    for slot=0,6 do
      local itemIndex = Char.GetItemIndex(charIndex,slot);
      if (itemIndex >= 0 and Item.GetData(itemIndex, CONST.道具_子参二)==40) then		--人装词条类别40
        local crit_Skill_x = string.split(Item.GetData(itemIndex, CONST.道具_USEFUNC),",");
        for i=1,#crit_Skill_x do
          local skillId_x = tonumber(crit_Skill_x[i]);
          if (skillId_x>0 and skillId_x==303) then
            skill_Coeff = skill_Coeff + 1;
          else
            skill_Coeff = skill_Coeff;
          end
        end
      end
    end
    return skill_Coeff
end

-------------------------------------------------------
--回合前事件
function Module:OnbattleStarCommand(battleIndex)
    --宠装词条BUFF
    for i=0,19 do
        local charIndex = Battle.GetPlayIndex(battleIndex, i)
        if (charIndex>=0 and Char.IsPet(charIndex)) then
            local defHp = Char.GetData(charIndex,CONST.对象_血);
            local defHpM = Char.GetData(charIndex,CONST.对象_最大血);
            local hpCondition = defHp/defHpM;
            local a,b,c = calcBondBuff(charIndex);
            if (a>0 and hpCondition<=0.20) then
                if (Battle.GetBattleCharacterStatus(charIndex, CONST.战属_攻增)==0) then
                    Battle.SetBattleCharacterStatus(charIndex, CONST.战属_攻增, a*10);
                    Battle.SetBattleCharacterStatus(charIndex, CONST.战属_防增, 0);
                    Battle.SetBattleCharacterStatus(charIndex, CONST.战属_敏增, 0);
                    NLG.UpChar(charIndex);
                end
            elseif (b>0 and hpCondition>=0.35 and hpCondition<=0.65) then
                if (Battle.GetBattleCharacterStatus(charIndex, CONST.战属_防增)==0) then
                    Battle.SetBattleCharacterStatus(charIndex, CONST.战属_防增, b*10);
                    Battle.SetBattleCharacterStatus(charIndex, CONST.战属_攻增, 0);
                    Battle.SetBattleCharacterStatus(charIndex, CONST.战属_敏增, 0);
                    NLG.UpChar(charIndex);
                end
            elseif (c>0 and hpCondition>=0.85) then
                if (Battle.GetBattleCharacterStatus(charIndex, CONST.战属_敏增)==0) then
                    Battle.SetBattleCharacterStatus(charIndex, CONST.战属_敏增, c*10);
                    Battle.SetBattleCharacterStatus(charIndex, CONST.战属_攻增, 0);
                    Battle.SetBattleCharacterStatus(charIndex, CONST.战属_防增, 0);
                    NLG.UpChar(charIndex);
                end
            else
                Battle.SetBattleCharacterStatus(charIndex, CONST.战属_攻增, 0);
                Battle.SetBattleCharacterStatus(charIndex, CONST.战属_防增, 0);
                Battle.SetBattleCharacterStatus(charIndex, CONST.战属_敏增, 0);
                NLG.UpChar(charIndex);
            end
            --Battle.SetBattleCharacterStatus(Battle.GetPlayIndex(battleIndex, 10), CONST.战属_属转,50);
            --Battle.SetBattleCharacterStatus(charIndex, CONST.战属_慢舞回合,2);
            --Battle.SetBattleCharacterStatus(charIndex, CONST.战属_慢舞值,100);
            --Battle.SetBattleCharacterStatus(charIndex, CONST.战属_恢增,1000);
            --Battle.SetBattleCharacterStatus(charIndex, CONST.战属_恢复回合,2);
            --Battle.SetBattleCharacterStatus(charIndex, CONST.战属_参数,30);
        elseif (charIndex>=0 and Char.IsEnemy(charIndex)) then
            local daze_debuff = Char.GetTempData(charIndex, '迷惑') or 0;
            if (daze_debuff>0) then
                Battle.SetBattleCharacterStatus(charIndex, CONST.战属_攻增,-10);
                NLG.UpChar(charIndex);
            else
                Battle.SetBattleCharacterStatus(charIndex, CONST.战属_攻增,0);
                NLG.UpChar(charIndex);
            end
        end
    end
    --形象羁绊特技
    local image_tpl = {};
    for i=0,9 do
        local charIndex = Battle.GetPlayIndex(battleIndex, i)
        if (charIndex>=0) then
            local image = Char.GetData(charIndex,CONST.对象_形象);
            table.insert(image_tpl,image);
        end
    end
    for k,v in pairs(BondImage_List) do
        local BondType = calcBondType(v[1],image_tpl,k);
        if (BondType>0 and k==BondType)then
            local pos= tonumber(v[3]);
            for i=0+pos,9+pos do
              local charIndex = Battle.GetPlayIndex(battleIndex, i)
              if (charIndex>=0 and Char.IsEnemy(charIndex)) then
                if (v[2] >= NLG.Rand(1,100)) then
                  Battle.SetBattleCharacterStatus(charIndex, v[4], tonumber(v[5]));
                  NLG.UpChar(charIndex);
                else
                  local prop = {CONST.战属_攻增,CONST.战属_防增,CONST.战属_敏增};
                  for k,v in pairs(prop) do
                    if (Battle.GetBattleCharacterStatus(charIndex,v)~=0) then
                      Battle.SetBattleCharacterStatus(charIndex,v,0);
                    end
                  end
                  NLG.UpChar(charIndex);
                end
              end
            end
        end
    end
end

--计算攻防敏增益
function calcBondBuff(petIndex)
    local skill_Buff_a=0;
    local skill_Buff_b=0;
    local skill_Buff_c=0;
    for slot=0,4 do
      local itemIndex = Char.GetItemIndex(petIndex,slot);
      if (itemIndex >= 0 and Item.GetData(itemIndex, CONST.道具_子参二)==41) then		--宠装词条类别41
        local bond_Skill_x = string.split(Item.GetData(itemIndex, CONST.道具_USEFUNC),",");
        for i=1,#bond_Skill_x do
          local skillId_x = tonumber(bond_Skill_x[i]);
          if (skillId_x>0 and skillId_x==501) then
            skill_Buff_a = skill_Buff_a + 1;
          elseif (skillId_x>0 and skillId_x==502) then
            skill_Buff_b = skill_Buff_b + 1;
          elseif (skillId_x>0 and skillId_x==503) then
            skill_Buff_c = skill_Buff_c + 1;
          else
            skill_Buff_a = skill_Buff_a;
            skill_Buff_b = skill_Buff_b;
            skill_Buff_c = skill_Buff_c;
          end
        end
      end
    end
    return skill_Buff_a,skill_Buff_b,skill_Buff_c
end
--计算组合类型
function calcBondType(bondImage_list,image_tpl,type)
    local tpl = {};
    local BondType=0;
    --local BondCount=0;
    for k,v in pairs(image_tpl) do
      for i=1,#bondImage_list do
        if (bondImage_list[i]==v and CheckInTable(tpl,v)==false) then
          --BondCount=BondCount+1;
          table.insert(tpl,v);
        end
      end
    end
    --if (BondCount>=#bondImage_list) then
    if (#tpl == #bondImage_list) then
      local BondType = type;
      return BondType
    end
    return BondType
end
-------------------------------------------------------
--回合后事件
function Module:OnAfterBattleTurnCommand(battleIndex)
    local Round = Battle.GetTurn(battleIndex);
    local leader1 = Battle.GetPlayer(battleIndex,0)
    local leader2 = Battle.GetPlayer(battleIndex,5)
    local leader = leader1
    if Char.GetData(leader2, CONST.对象_类型) == CONST.对象类型_人 then
        leader = leader2
    end

    for i=0,19 do
        local charIndex = Battle.GetPlayIndex(battleIndex, i)
        if (charIndex>=0 and Char.IsPet(charIndex)) then
            --重置状态
            if (Battle.GetBattleCharacterStatus(charIndex, CONST.战属_慢舞回合)>=2) then
                Battle.SetBattleCharacterStatus(charIndex, CONST.战属_慢舞回合,1);
                Battle.SetBattleCharacterStatus(charIndex, CONST.战属_慢舞值,100);
            elseif (Battle.GetBattleCharacterStatus(charIndex, CONST.战属_慢舞回合)==1) then
                Battle.SetBattleCharacterStatus(charIndex, CONST.战属_慢舞回合,0);
                Battle.SetBattleCharacterStatus(charIndex, CONST.战属_慢舞值,0);
            end
            --发动状态
            local skill500_rate = calcDynamaxRate(charIndex)*5;		--极巨化词条为5%
            if (skill500_rate>= NLG.Rand(1,100)) then
                Battle.SetBattleCharacterStatus(charIndex, CONST.战属_慢舞回合,2);
                Battle.SetBattleCharacterStatus(charIndex, CONST.战属_慢舞值,100);
            end
        end
    end
end

--计算极巨化发动率
function calcDynamaxRate(petIndex)
    local skill_rate=0;
    for slot=0,4 do
      local itemIndex = Char.GetItemIndex(petIndex,slot);
      if (itemIndex >= 0 and Item.GetData(itemIndex, CONST.道具_子参二)==41) then		--宠装词条类别41
        local dynamax_Skill_x = string.split(Item.GetData(itemIndex, CONST.道具_USEFUNC),",");
        for i=1,#dynamax_Skill_x do
          local skillId_x = tonumber(dynamax_Skill_x[i]);
          if (skillId_x>0 and skillId_x==500) then
            skill_rate = skill_rate + 1;
          else
            skill_rate = skill_rate;
          end
        end
      end
    end
    return skill_rate
end


function position(PosSlot)
  if PosSlot == 10 then
    return "後排中間"
  elseif PosSlot == 11 then
    return "後排中右"
  elseif PosSlot == 12 then
    return "後排中左"
  elseif PosSlot == 13 then
    return "後排最右"
  elseif PosSlot == 14 then
    return "後排最左"
  elseif PosSlot == 15 then
    return "前排中間"
  elseif PosSlot == 16 then
    return "前排中右"
  elseif PosSlot == 17 then
    return "前排中左"
  elseif PosSlot == 18 then
    return "前排最右"
  elseif PosSlot == 19 then
    return "前排最左"
  end
end

function CheckInTable(_idTab, _idVar) ---循环函数
	for k,v in pairs(_idTab) do
		if v==_idVar then
			return true
		end
	end
	return false
end
--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
