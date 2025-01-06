---ģ����
local Module = ModuleBase:createModule(dazeMod)

--����ʩ������
local boom_skill_list = {3,266,267,268,269,270,271};	--����ʩ����skill�б�
local boom_dmg_rate = {0.75,0.50,0.25,0.01}	--��ͬ�ؼ��ܶ�Ӧ�˺�����������������
local boom_list = {}
local boom_cnt_num = {}
local boom_cnt_num_aoe = {}
local boom_tag = {}

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load');
  self:regCallback('BattleActionTargetEvent',Func.bind(self.battleActionTargetCallback,self))
  self:regCallback('DamageCalculateEvent',Func.bind(self.damageCalculateCallback,self))

end

-------------------------------------------------------
--����Ŀ���¼�
function Module:battleActionTargetCallback(CharIndex, battleIndex, com1, com2, com3, tgl)
	--self:logDebug('battleActionTargetCallback', CharIndex, battleIndex, com1, com2, com3, tgl)
	if Char.IsPlayer(CharIndex) then
		if (com3==300) then		--�����Ի�
			if (NLG.Rand(1,4) >= 1) then
				local defCharIndex = Battle.GetPlayer(battleIndex,tgl[1]);
				Char.SetTempData(defCharIndex, '�Ի�', 5);
				NLG.SystemMessage(-1, "[ϵ�y]�l�����ܔ��������Ի�");
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
			local skill_rate = calcRate(CharIndex,skillId)*10;		--������Ϊ10%
			local com_name = Tech.GetData(Tech.GetTechIndex(com3), CONST.TECH_NAME);
			local boom_rate = math.random(1,100);
			local copy_num = 3;
			if (skill_rate >= boom_rate) then
				local msg_tag = CharIndex;
				local msg_name =  Char.GetData(CharIndex,CONST.����_����);
				NLG.SystemMessage(msg_tag, msg_name.."��"..skill_rate.."%�l�Ӷ���֮"..copy_num.."�� "..com_name);
				boom_list[CharIndex] = 1
				local return_tgl = copy_list(tgl,copy_num)	
				return 	return_tgl	
			end
		else
			return tgl
		end
	elseif Char.IsPet(CharIndex) then
		if (com3==300) then		--�����Ի�
			if (NLG.Rand(1,4) >= 1) then
				local defCharIndex = Battle.GetPlayer(battleIndex,tgl[1]);
				Char.SetTempData(defCharIndex, '�Ի�', 5);
				NLG.SystemMessage(-1, "[ϵ�y]�l�����ܔ��������Ի�");
			end
		end
		return tgl
	elseif Char.IsEnemy(CharIndex) then
		local daze_debuff = Char.GetTempData(CharIndex, '�Ի�') or 0;
		if (daze_debuff>0) then
			Char.SetTempData(CharIndex, '�Ի�', daze_debuff-1);
			local tgl = calcPlayerHighHP_list(tgl,battleIndex);
			return tgl
		else
			return tgl
		end
    end
end

--���ӻ�����Ŀ��
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
--���������������
function calcRate(charIndex,skillId)
    local skill_rate=0;
    for slot=0,6 do
      local itemIndex = Char.GetItemIndex(charIndex,slot);
      if (itemIndex >= 0 and Item.GetData(itemIndex, CONST.����_�Ӳζ�)==40) then
        local boom_Skill_x = string.split(Item.GetData(itemIndex, CONST.����_USEFUNC),",");
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
--�����ҷ����Ѫ
function calcPlayerHighHP_list(tgl,battleIndex)
    local new_list = {}
	local HP_More={};
	HP_More[1]=1;
	HP_More[2]=0;
	for i = 0,9 do
		local player = Battle.GetPlayer(battleIndex, i);
		if (player>=0) then
			local HP = Char.GetData(player,CONST.����_Ѫ);
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
--�˺��¼�
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
		local daze_debuff = Char.GetTempData(CharIndex, '�Ի�') or 0;
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
--�������������ϵ��
function calcDamageCoeff(charIndex)
    local skill_Coeff=0;
    for slot=0,6 do
      local itemIndex = Char.GetItemIndex(charIndex,slot);
      if (itemIndex >= 0 and Item.GetData(itemIndex, CONST.����_�Ӳζ�)==40) then
        local crit_Skill_x = string.split(Item.GetData(itemIndex, CONST.����_USEFUNC),",");
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

function CheckInTable(_idTab, _idVar) ---ѭ������
	for k,v in pairs(_idTab) do
		if v==_idVar then
			return true
		end
	end
	return false
end
--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
