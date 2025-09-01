local Module = ModuleBase:createModule('pokeCards')


-----------------------------------------------------------------
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BattleSkillCheckEvent', Func.bind(self.onBattleSkillCheckEvent, self))
  self:regCallback('BattleActionEvent', Func.bind(self.onBattleActionEvent, self));
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self));
  --self:regCallback('CalcFpConsumeEvent', Func.bind(self.onCalcFpConsumeEvent, self));
  self:regCallback('BattleCalcDexEvent', Func.bind(self.OnBattleCalcDexEvent, self));
  self:regCallback('BattleDodgeRateEvent', Func.bind(self.OnBattleDodgeRateEvent, self));

  self:regCallback('BattleStartEvent', Func.bind(self.OnbattleStartEventCallback, self));
  self:regCallback('BattleOverEvent', Func.bind(self.battleOverEventCallback, self));
  Item.CreateNewItemType( 63, "技能卡牌", 400260, -1, 0);

end

function Module:onBattleSkillCheckEvent(charIndex, battleIndex, arrayOfSkillEnable)
	--self:logDebug('onBattleSkillCheckEventCallBack', charIndex, battleIndex, arrayOfSkillEnable)
	local Round = Battle.GetTurn(battleIndex);
	if Char.IsPlayer(charIndex) and Char.IsDummy(charIndex)==false  then
		local floor = Char.GetData(charIndex,CONST.对象_地图);
		if (floor==80011 or floor==80012 or floor==80013 or floor==80014 or floor==80015 or floor==80016 or floor==80017 or floor==80018 or floor==80019 or floor==80020 or floor==80021 or floor==80022 or floor==80023 or floor==80024 or floor==80025) then
			for Slot=0,14 do
				local skillSlot=Char.GetSkillID(charIndex,Slot);
				arrayOfSkillEnable[Slot+1]=0;
			end
			return arrayOfSkillEnable;
		end
	end
	return arrayOfSkillEnable;
end

function Module:onBattleActionEvent(charIndex, Com1, Com2, Com3, ActionNum)
  --self:logDebug('onBattleActionEventCallBack', charIndex, Com1, Com2, Com3, ActionNum)
  local battleIndex = Char.GetBattleIndex(charIndex);
  local charside = 1;
  local ybside = Char.GetData(charIndex, CONST.对象_战斗Side);
  if ybside == 1 then
    charside = 2;
  end
  if (Com1==9 and Char.GetData(charIndex, CONST.对象_战宠)>-1 and Char.IsPlayer(charIndex)==true) then
    if (ActionNum==1) then
      local Page = Char.GetBagPage(charIndex);
      --print(Com3)
      if (Page==0) then Com3 = Com3;
      elseif (Page==1) then Com3 = Com3+20;
      elseif (Page==2) then Com3 = Com3+40;
      elseif (Page==3) then Com3 = Com3+60;
      end
      local ItemSlot = Com3;
      local ItemIndex = Char.GetItemIndex(charIndex,ItemSlot);
      --local ItemID = Item.GetData(ItemIndex, CONST.道具_ID);
      if (Item.GetData(ItemIndex, CONST.道具_类型)==63) then
        if (battleIndex==-1) then
          if (Char.GetData(charIndex,CONST.对象_队聊开关) == 1) then
            NLG.SystemMessage(charIndex,"[道具提示]戰鬥中才能使用的道具");
          end
        else
          local com1 = Item.GetData(ItemIndex,CONST.道具_特殊类型)-1000;
          if (Item.GetData(ItemIndex,CONST.道具_子参一)>=20 and Item.GetData(ItemIndex,CONST.道具_子参一)<=29) then
            com2 = Com2+20;
          elseif (Item.GetData(ItemIndex,CONST.道具_子参一)==40) then
            com2 = 41;
          else
            com2 = Com2;
          end
          local com3 = Item.GetData(ItemIndex,CONST.道具_子参二);

          if (com3==200209) then
            local enemyId = Item.GetData(ItemIndex,CONST.道具_幸运);
            local ThrowItemOn = Char.GetTempData(charIndex, 'ThrowItem') or 0;
            if (ThrowItemOn==0) then
              Char.DelItem(charIndex,74200,1);
              Char.SetTempData(charIndex, 'ThrowItem', enemyId);
              Battle.ActionSelect(charIndex, com1, com2, com3);
            end
          else
            Battle.ActionSelect(charIndex, com1, com2, com3);
          end
          Char.SetTempData(charIndex, 'Cards', 1);
          --[[local TechIndex = Tech.GetTechIndex(com3);
          local TechName = Tech.GetData(TechIndex, CONST.TECH_NAME);
          NLG.Say(charIndex,charIndex,"【丟出卡牌】使出"..TechName.."！！",4,3);]]
        end
      end
    end
  elseif (Com1==9 and Char.IsPlayer(charIndex)==true) then
    Battle.ActionSelect(charIndex, CONST.BATTLE_COM.BATTLE_COM_ATTACK, Com2, -1);
    NLG.SystemMessage(charIndex,"[系统]使用卡牌需要和寵物一起出戰。");
  end

end

function Module:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
	if (Char.IsEnemy(defCharIndex) and Char.IsDummy(charIndex)==false) then
		local floor = Char.GetData(charIndex,CONST.对象_地图);
		if (com3==200209) and (floor==80011 or floor==80012 or floor==80013 or floor==80014 or floor==80015 or floor==80016 or floor==80017 or floor==80018 or floor==80019 or floor==80020 or floor==80021 or floor==80022 or floor==80023 or floor==80024 or floor==80025) then
			local defHpE = Char.GetData(defCharIndex,CONST.对象_血);
			local defHpEM = Char.GetData(defCharIndex,CONST.对象_最大血);
			local HpE05 = defHpE/defHpEM;
			local getit= NLG.Rand(1, math.ceil(HpE05*4) );
			local LvE = math.ceil(Char.GetData(defCharIndex,CONST.对象_等级)*0.8);
			local LvMR = NLG.Rand(1,145);
			if (Char.GetData(defCharIndex,CONST.对象_等级) == 1)  then
				local PetSlot = Char.GetPetEmptySlot(charIndex);
				local enemyId = Char.GetData(defCharIndex, CONST.对象_ENEMY_ID);
				if ( getit == 1 and LvMR >= LvE) then
					Char.GivePet(charIndex,enemyId,0);
					if (PetSlot>=0) then
						local PetIndex = Char.GetPet(charIndex, PetSlot);
						--local typeRand = math.random(1,#petMettleTable);
						--local pos = math.random(1,#petMettleTable[typeRand]);
						--Pet.AddSkill(PetIndex, petMettleTable[typeRand][pos], 9);
						Pet.UpPet(charIndex,PetIndex);
						NLG.UpChar(charIndex);
					end
					Char.SetTempData(charIndex, 'ThrowItem', 0);
					local damage = 7777777;
					return damage;
				else
					Char.SetTempData(charIndex, 'ThrowItem', 0);
					local damage = 1;
					return damage;
				end
			else
				Char.SetTempData(charIndex, 'ThrowItem', 0);
				local damage = 1;
				return damage;
			end
		end
	elseif (Char.IsEnemy(defCharIndex) and Char.IsDummy(charIndex)==true) then
		local floor = Char.GetData(charIndex,CONST.对象_地图);
		if (floor==80011 or floor==80012 or floor==80013 or floor==80014 or floor==80015 or floor==80016 or floor==80017 or floor==80018 or floor==80019 or floor==80020 or floor==80021 or floor==80022 or floor==80023 or floor==80024 or floor==80025) then
			local damage = 1;
			return damage;
		end
	end
	return damage;
end


--卡牌耗魔减半
function Module:onCalcFpConsumeEvent(charIndex, techId, Fp)
	if (Char.IsPlayer(charIndex) and Char.IsDummy(charIndex)==false) then
		local Cards = Char.GetTempData(charIndex, 'Cards') or 0;
		if (Cards == 1) then
			local TechIndex = Tech.GetTechIndex(techId);
			local originFP = Tech.GetData(TechIndex, CONST.TECH_FORCEPOINT);
			local Fp = math.ceil(originFP * 0.5);
			return Fp;
		end
		return Fp;
	end
	return Fp;
end
--卡牌优先
function Module:OnBattleCalcDexEvent(battleIndex, charIndex, action, flg, dex)
	--self:logDebug('OnBattleCalcDexEvent', battleIndex, charIndex, action, flg, dex)
	if (Char.IsPlayer(charIndex) and Char.IsDummy(charIndex)==false) then
		local Cards = Char.GetTempData(charIndex, 'Cards') or 0;
		if (Cards == 1) then
			local dex = 3000;
			return dex;
		end
		return dex;
	end
	return dex;
end
--卡牌必中
function Module:OnBattleDodgeRateEvent(battleIndex, aIndex, fIndex, rate)
	--self:logDebug('OnBattleDodgeRateCallBack', battleIndex, aIndex, fIndex, rate)
	local battleIndex = Char.GetBattleIndex(aIndex);
	if Char.IsPlayer(aIndex) and Char.IsEnemy(fIndex) then	--必中
		local Cards = Char.GetTempData(aIndex, 'Cards') or 0;
		if (Cards == 1)  then
			--Char.SetTempData(aIndex, 'Cards', 0);
			rate = 0;
			return rate
		end
	else
	end
	return rate
end

--树果掉落
function Module:OnbattleStartEventCallback(battleIndex)
	Dm = {};
	for i=10, 19 do
		local enemy = Battle.GetPlayIndex(battleIndex, i);
		local player = Battle.GetPlayIndex(battleIndex, 0);
		local floor = Char.GetData(player,CONST.对象_地图);
		if (floor==80011 or floor==80012 or floor==80013 or floor==80014 or floor==80015 or floor==80016 or floor==80017 or floor==80018 or floor==80019 or floor==80020 or floor==80021 or floor==80022 or floor==80023 or floor==80024 or floor==80025) then
			if (enemy>=0) then
				local enemylv = Char.GetData(enemy, CONST.对象_等级);
				table.insert(Dm, i, enemylv);
			else
				table.insert(Dm, i, -1);
			end
		end
	end
end

function Module:battleOverEventCallback(battleIndex)
	--计算平均等级及等第
	if (Dm~=nil) then
		local m = 0;
		local k = 0;
		for p=10,19 do
			if Dm[p]>0 then
				m = m+Dm[p];
				k = k+1;
			end
		end
		lv = math.floor(m/k);
	end
	for i=0,9 do
		local player = Battle.GetPlayer(battleIndex,i);
		local floor = Char.GetData(player,CONST.对象_地图);
		if (floor==80011 or floor==80012 or floor==80013 or floor==80014 or floor==80015 or floor==80016 or floor==80017 or floor==80018 or floor==80019 or floor==80020 or floor==80021 or floor==80022 or floor==80023 or floor==80024 or floor==80025) then
			if (player>-1 and Char.GetData(player, CONST.对象_等级) <= lv*2) then
				local dropMenu = {69011,69012,69013,69014};
				local dropRate = {0,0,0,0,1,0,0,0,0,0};
				Char.GiveItem(player, dropMenu[NLG.Rand(1,4)], dropRate[NLG.Rand(1,10)]);
			end
		end
	end
end


--功能函数
Char.GetItemEmptySlot = function(charIndex)
  local Page = Char.GetBagPage(charIndex);
  if (Page==0) then
    for Slot=7,27 do
      local ItemIndex = Char.GetItemIndex(charIndex, Slot);
      --print(ItemIndex);
      if (ItemIndex < 0) then
          return Slot;
      end
    end
  elseif (Page==1) then
    for Slot=28,47 do
      local ItemIndex = Char.GetItemIndex(charIndex, Slot);
      --print(ItemIndex);
      if (ItemIndex < 0) then
          return Slot;
      end
    end
  elseif (Page==2) then
    for Slot=48,67 do
      local ItemIndex = Char.GetItemIndex(charIndex, Slot);
      --print(ItemIndex);
      if (ItemIndex < 0) then
          return Slot;
      end
    end
  elseif (Page==3) then
    for Slot=68,87 do
      local ItemIndex = Char.GetItemIndex(charIndex, Slot);
      --print(ItemIndex);
      if (ItemIndex < 0) then
          return Slot;
      end
    end
  end
  return -1;
end

Char.GetPetEmptySlot = function(charIndex)
  for Slot=0,4 do
      local PetIndex = Char.GetPet(charIndex, Slot);
      --print(PetIndex);
      if (PetIndex < 0) then
          return Slot;
      end
  end
  return -1;
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
