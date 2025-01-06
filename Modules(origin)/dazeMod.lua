---模块类
local Module = ModuleBase:createModule(dazeMod)

--多重施法设置
local boom_skill_list = {3,266,267,268,269,270,271};	--多重施法的skill列表
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

end

-------------------------------------------------------
--动作目标事件
function Module:battleActionTargetCallback(CharIndex, battleIndex, com1, com2, com3, tgl)
	--self:logDebug('battleActionTargetCallback', CharIndex, battleIndex, com1, com2, com3, tgl)
	if Char.IsPlayer(CharIndex) then
		if (com3==300) then		--挑拨迷惑
			if (NLG.Rand(1,4) >= 1) then
				local defCharIndex = Battle.GetPlayer(battleIndex,tgl[1]);
				Char.SetTempData(defCharIndex, '迷惑', 5);
				NLG.SystemMessage(-1, "[系統]發動挑撥敵人陷入迷惑");
			end
		end
		boom_list[CharIndex] = 0;
		boom_cnt_num[CharIndex] = 0;
		boom_cnt_num_aoe[CharIndex] = {};
		if #tgl > 1 then
			boom_tag[CharIndex] = 1
		else 
			boom_tag[CharIndex] = 0
		end
		local skillId = Tech.GetData(Tech.GetTechIndex(com3), CONST.TECH_SKILLID);
		if (CheckInTable(boom_skill_list, skillId)==true) then
			local skill_rate = calcRate(CharIndex,skillId)*10;		--词条皆为10%
			local com_name = Tech.GetData(Tech.GetTechIndex(com3), CONST.TECH_NAME);
			local boom_rate = math.random(1,100);
			local copy_num = 3;
			if (skill_rate >= boom_rate) then
				local msg_tag = CharIndex;
				local msg_name =  Char.GetData(CharIndex,CONST.对象_名字);
				NLG.SystemMessage(msg_tag, msg_name.."："..skill_rate.."%發動多重之"..copy_num.."倍 "..com_name);
				boom_list[CharIndex] = 1
				local return_tgl = copy_list(tgl,copy_num)	
				return 	return_tgl	
			end
		else
			return tgl
		end
	elseif Char.IsPet(CharIndex) then
		if (com3==300) then		--挑拨迷惑
			if (NLG.Rand(1,4) >= 1) then
				local defCharIndex = Battle.GetPlayer(battleIndex,tgl[1]);
				Char.SetTempData(defCharIndex, '迷惑', 5);
				NLG.SystemMessage(-1, "[系統]發動挑撥敵人陷入迷惑");
			end
		end
		return tgl
	elseif Char.IsEnemy(CharIndex) then
		local daze_debuff = Char.GetTempData(CharIndex, '迷惑') or 0;
		if (daze_debuff>0) then
			Char.SetTempData(CharIndex, '迷惑', daze_debuff-1);
			local tgl = calcPlayerHighHP_list(tgl,battleIndex);
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
function calcRate(charIndex,skillId)
    local skill_rate=0;
    for slot=0,6 do
      local itemIndex = Char.GetItemIndex(charIndex,slot);
      if (itemIndex >= 0 and Item.GetData(itemIndex, CONST.道具_子参二)==40) then
        local boom_Skill_x = string.split(Item.GetData(itemIndex, CONST.道具_USEFUNC),",");
        for i=1,#boom_Skill_x do
          local skillId_x = tonumber(boom_Skill_x[i]);
          if (skillId_x>0 and skillId_x==skillId ) then
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
		local return_dmg = math.floor((boom_dmg_rate[cnt+1]+skill_Coeff)*Damage);
		if (boom_tag[CharIndex] == 1) then
			boom_cnt_num_aoe[CharIndex][DefCharIndex] = cnt + 1;
		elseif (boom_tag[CharIndex] == 0) then
			boom_cnt_num[CharIndex]  = cnt + 1;
		end		
		return return_dmg
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
