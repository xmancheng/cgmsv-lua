---模块类
local Module = ModuleBase:createModule(dazeMod)

--多重施法设置
--local boom_skill_list = {3,266,267,268,269,270,271};	--多重施法的skill列表
local boom_dmg_rate = {0.75,0.50,0.25,0.01}	--不同重技能对应伤害削弱，类似于乱射
local boom_list = {}
local boom_cnt_num = {}
local boom_cnt_num_aoe = {}
local boom_tag = {}

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load');
  self:regCallback('BattleActionTargetEvent',Func.bind(self.battleActionTargetCallback,self))
  self:regCallback('DamageCalculateEvent',Func.bind(self.damageCalculateCallback,self))
  self:regCallback('BattleStartEvent', Func.bind(self.OnbattleStarCommand, self))
  self:regCallback('BeforeBattleTurnEvent', Func.bind(self.OnbattleStarCommand, self))

end

-------------------------------------------------------
--动作目标事件
function Module:battleActionTargetCallback(charIndex, battleIndex, com1, com2, com3, tgl)
	--self:logDebug('battleActionTargetCallback', charIndex, battleIndex, com1, com2, com3, tgl)
	local leader1 = Battle.GetPlayer(battleIndex,0)
	local leader2 = Battle.GetPlayer(battleIndex,5)
	local leader = leader1
	if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
		leader = leader2
	end
	if Char.IsPlayer(charIndex) then
		local skill302_rate = calcParalysisRate(charIndex,skillId)*2;		--麻痹词条为2%
		if (skill302_rate >= NLG.Rand(1,100)) then		--麻痹
			local para_debuff = Char.GetTempData(defCharIndex, '麻痹') or 0;
			if (para_debuff<=0) then
				local defCharIndex = Battle.GetPlayer(battleIndex,tgl[1]);
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
				local daze_debuff = Char.GetTempData(defCharIndex, '迷惑') or 0;
				if (daze_debuff<=0) then
					local defCharIndex = Battle.GetPlayer(battleIndex,tgl[1]);
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
      if (itemIndex >= 0 and Item.GetData(itemIndex, CONST.道具_子参二)==40) then
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
      if (itemIndex >= 0 and Item.GetData(itemIndex, CONST.道具_子参二)==40) then
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
	if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
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
	elseif Char.IsEnemy(CharIndex) then
		local daze_debuff = Char.GetTempData(CharIndex, '迷惑') or 0;
		local daze_dmg_rate = {0.75,0.70,0.65,0.60,0.55}
		if (daze_debuff>0) then
			local Damage = Damage*daze_dmg_rate[daze_debuff];
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
      if (itemIndex >= 0 and Item.GetData(itemIndex, CONST.道具_子参二)==40) then
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
      if (itemIndex >= 0 and Item.GetData(itemIndex, CONST.道具_子参二)==40) then
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
    for i=0, 19 do
        local petIndex = Battle.GetPlayIndex(battleIndex, i)
        if (petIndex>=0 and Char.IsPet(petIndex)) then
            --[[for war=0,23 do
                local warIndex =  Battle.GetBattleCharacterStatus(petIndex, war);
                print(warIndex)
            end]]
            local a,b,c = calcBondBuff(petIndex);
            if (a>0) then
                if (Battle.GetBattleCharacterStatus(petIndex, CONST.战属_攻增)==0) then
                    --Battle.SetBattleCharacterStatus(petIndex, CONST.战属_攻增,200);
                    Battle.SetBattleCharacterStatus(Battle.GetPlayIndex(battleIndex, 10), CONST.战属_属转,50);
                    --Battle.SetBattleCharacterStatus(petIndex, CONST.战属_慢舞回合,2);
                    --Battle.SetBattleCharacterStatus(petIndex, CONST.战属_慢舞值,100);
                    --Battle.SetBattleCharacterStatus(petIndex, CONST.战属_恢增,1000);
                    --Battle.SetBattleCharacterStatus(petIndex, CONST.战属_恢复回合,2);
                    --Battle.SetBattleCharacterStatus(petIndex, CONST.战属_参数,30);
                    NLG.UpChar(petIndex);
                end
            elseif (b>0) then

            elseif (c>0) then

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
      if (itemIndex >= 0 and Item.GetData(itemIndex, CONST.道具_子参二)==41) then
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
