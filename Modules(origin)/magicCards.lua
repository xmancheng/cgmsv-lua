local Module = ModuleBase:createModule('magicCards')

local petMettleTable = {
          {9610,9619,9620,9629},       --对BOSS增,自BOSS减,对人形增,对邪魔增
          {9611,9615,9623,9624},       --对地增,自地减,对飞行增,对昆虫增
          {9612,9616,9627,9628},       --对水增,自水减,对特殊增,对金属增
          {9613,9617,9621,9626},       --对火增,自火减,对龙族增,对野兽增
          {9614,9618,9622,9625},       --对风增,自风减,对不死增,对植物增
}

local petEvolution_check = {
    404001,404002,404003,404004,404005,404006,404007,404008,404009,404010,
    404011,404012,404013,404014,404015,404016,404017,404018,404019,404020,
    404021,404022,404023,404024,404025,
};	--enemy编号

local petEvolution_list = {};
petEvolution_list[404001] = {140001,405,408,"雪原翼龍"};
petEvolution_list[404002] = {140005,405,408,"暴躁狂蜂"};
petEvolution_list[404003] = {140007,26105,26108,"針刺顎龜"};
petEvolution_list[404004] = {140009,6405,6408,"紅葉樹妖"};
petEvolution_list[404005] = {140011,405,408,"火山飛龍"};
petEvolution_list[404006] = {140013,6105,6108,"湖澤蛇龍"};
petEvolution_list[404007] = {140015,26205,26208,"迅雷飛獸"};
petEvolution_list[404008] = {140017,405,408,"木果陸鯊"};
petEvolution_list[404009] = {140019,5405,5408,"嫵媚妖朵"};
petEvolution_list[404010] = {140021,7638,4508,"皮皮鬼魂"};
petEvolution_list[404011] = {140023,26105,26108,"拉納鬼龍"};
petEvolution_list[404012] = {140025,7538,4408,"伊賀武蛙"};
petEvolution_list[404013] = {140027,405,408,"天線幻獸"};
petEvolution_list[404014] = {140029,26105,26108,"三首多龍"};
petEvolution_list[404015] = {140033,405,408,"光彩酋龍"};
petEvolution_list[404016] = {140035,405,408,"電電洛亞"};
petEvolution_list[404017] = {140037,405,408,"假面拳力"};
petEvolution_list[404018] = {140039,6805,6808,"天照之幻"};
petEvolution_list[404019] = {140041,26705,26708,"月讀之夢"};
petEvolution_list[404020] = {140045,405,408,"電械帕龍"};
petEvolution_list[404021] = {140047,26005,26008,"電柵工獸"};
petEvolution_list[404022] = {140049,26105,26108,"森灌獵蜥"};
petEvolution_list[404023] = {140051,26105,26108,"飛刺螳螂"};
petEvolution_list[404024] = {140053,1238,6805,"貓貓巨獸"};
petEvolution_list[404025] = {140055,6705,6708,"引擎雷獸"};

function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BattleActionEvent', Func.bind(self.onBattleActionEvent, self));
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self));
  self:regCallback('BattleCalcDexEvent', Func.bind(self.OnBattleCalcDexEvent, self));
  self:regCallback('BeforeBattleTurnEvent', Func.bind(self.OnbattleStarCommand, self));
  self:regCallback('BattleOverEvent', Func.bind(self.onBattleOver, self));
  self:regCallback('BattleExitEvent', Func.bind(self.onBattleExit, self));
  Item.CreateNewItemType( 63, "技能卡牌", 26409, -1, 0);

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
      local ItemSlot = Com3;
      local ItemIndex = Char.GetItemIndex(charIndex,ItemSlot);
      local ItemID = Item.GetData(ItemIndex, CONST.道具_ID);
      if (Item.GetData(ItemIndex, CONST.道具_类型)==63 and Item.GetData(ItemIndex, CONST.道具_已鉴定)==1) then
        if (battleIndex==-1) then
          if (Char.GetData(charIndex,CONST.对象_队聊开关) == 1) then
            NLG.SystemMessage(charIndex,"[道具提示]戰鬥中才能使用的道具");
          end
        else
          local com1 = Item.GetData(ItemIndex,CONST.道具_特殊类型)-1000;
          local com2 = Item.GetData(ItemIndex,CONST.道具_子参一);
          local com3 = Item.GetData(ItemIndex,CONST.道具_子参二);

          local TechIndex = Tech.GetTechIndex(com3);
          local originFP = Tech.GetData(TechIndex, CONST.TECH_FORCEPOINT);
          if (Char.GetData(charIndex, CONST.对象_魔) < originFP) then
            NLG.SystemMessage(charIndex,"[系统]使用卡牌的魔法力不足。");
            return
          end

          if (com3==200209) then
            local enemyId = Item.GetData(ItemIndex,CONST.道具_幸运);
            local ThrowItemOn = Char.GetTempData(charIndex, 'ThrowItem') or 0;
            if (ThrowItemOn==0) then
              local com2 = Com2
              Char.SetTempData(charIndex, 'ThrowItem', enemyId);
              Battle.ActionSelect(charIndex, com1, com2, com3);
            end
            Char.SetTempData(charIndex, 'Cards', 1);
            if (ItemID==74042) then
              Char.DelItem(charIndex,74042,1);
			else
              Char.DelItemBySlot(charIndex, ItemSlot);
            end
            NLG.Say(charIndex,charIndex,"【丟出卡牌】使出帕獸封印術！！",4,3);
          else
            Battle.ActionSelect(charIndex, com1, com2, com3);
            Char.SetTempData(charIndex, 'Cards', 1);
            Char.DelItemBySlot(charIndex, ItemSlot);
            local TechName = Tech.GetData(TechIndex, CONST.TECH_NAME);
            NLG.Say(charIndex,charIndex,"【丟出卡牌】使出"..TechName.."！！",4,3);
          end
        end
      elseif (Item.GetData(ItemIndex, CONST.道具_类型)==63 and Item.GetData(ItemIndex, CONST.道具_已鉴定)==0) then
        NLG.SystemMessage(charIndex,"無法使用未經鑑定之卡牌。");
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
		if (com3==200209 and floor==20300) then
			local defHpE = Char.GetData(defCharIndex,CONST.对象_血);
			local ThrowItemOn = Char.GetTempData(charIndex, 'ThrowItem') or 0;	--针对enemyId进行封印
			if (ThrowItemOn>0) then
				if (Char.GetData(defCharIndex,CONST.对象_等级) == 1)  then
					local PetSlot = Char.GetPetEmptySlot(charIndex);
					local enemyId = Char.GetData(defCharIndex, CONST.对象_ENEMY_ID);
					if (ThrowItemOn==enemyId) then
						Char.GivePet(charIndex,enemyId,0);
						if (PetSlot>=0) then
							local PetIndex = Char.GetPet(charIndex, PetSlot);
							local typeRand = math.random(1,#petMettleTable);
							local pos = math.random(1,#petMettleTable[typeRand]);
							Pet.AddSkill(PetIndex, petMettleTable[typeRand][pos], 9);
							Pet.UpPet(charIndex,PetIndex);
							NLG.UpChar(charIndex);
						end
						Char.SetTempData(charIndex, 'ThrowItem', 0);
						local damage = 7777777;
						return damage;
					else
						Char.SetTempData(charIndex, 'ThrowItem', 0);
						local damage = 4444444;
						return damage;
					end
				else
					Char.SetTempData(charIndex, 'ThrowItem', 0);
					local damage = defHpE*0.5;
					return damage;
				end
			end
		elseif (com3~=200209 and floor==20300) then
			local damage = damage*0.50;
			return damage;
		elseif (com3==200209 and floor~=20300) then
			Char.SetTempData(charIndex, 'ThrowItem', 0);
			return damage;
		elseif (Char.IsPet(charIndex) == true) then
			local cdk = Char.GetData(charIndex,CONST.对象_主人CDK);
			local OwnerIndex = NLG.FindUser(cdk);
			local Ownerfloor = Char.GetData(OwnerIndex,CONST.对象_地图);
			if (Ownerfloor==20300) then
				local damage = damage*0.25;
				return damage;
			else
				return damage;
			end
		end
	elseif (Char.IsEnemy(defCharIndex) and Char.IsDummy(charIndex)==true) then
		local floor = Char.GetData(charIndex,CONST.对象_地图);
		if (floor==20300) then
			local damage = damage*1.75;
			return damage;
		else
			return damage;
		end
	end
	return damage;
end

--卡牌优先
function Module:OnBattleCalcDexEvent(battleIndex, charIndex, action, flg, dex)
	--self:logDebug('OnBattleCalcDexEvent', battleIndex, charIndex, action, flg, dex)
	if (Char.IsPlayer(charIndex) and Char.IsDummy(charIndex)==false) then
		local Cards = Char.GetTempData(charIndex, 'Cards') or 0;
		if (Cards == 1) then
			Char.SetTempData(charIndex, 'Cards', 0);
			local dex = 1500;
			return dex;
		end
		return dex;
	end
	return dex;
end

function Module:OnbattleStarCommand(battleIndex)
	local Round = Battle.GetTurn(battleIndex);
	local leader1 = Battle.GetPlayer(battleIndex,0)
	local leader2 = Battle.GetPlayer(battleIndex,5)
	local leader = leader1
	if Char.GetData(leader2, CONST.对象_类型) == CONST.对象类型_人 then
		leader = leader2
	end
	if (Round==0) then
		Char.SetTempData(leader, '全屏魔法', 0);
	elseif (Round>=1) then
		local Vigor_pre = Char.GetTempData(leader, '全屏魔法') or 0;
		local Count = 0;
		for i=0,9 do
			local player = Battle.GetPlayIndex(battleIndex, i)
			if (player>=0) then
				if (Char.GetData(player, CONST.对象_战死)==0) then
					Count = Count+1;
				end
			end
		end
		Char.SetTempData(leader, '全屏魔法', Vigor_pre + Count);
		local Vigor = Char.GetTempData(leader, '全屏魔法') or 0;
		if (Vigor >= 100) then
			local cardItemId = {75034,75035,75036,75037};
			local rand = NLG.Rand(1,#cardItemId);
			Char.GiveItem(leader, cardItemId[rand], 1, false);
			NLG.SystemMessage(leader,"[系統] 達到100氣力值獲得全屏魔法。");
			Char.SetTempData(leader, '全屏魔法', 0);
		else
			if (Char.GetData(leader,CONST.对象_队聊开关) == 1) then
				NLG.SystemMessage(leader,"[系統] 累積"..Vigor.."氣力值。");
			end
		end
	end

end

--战斗结束进化
function Module:onBattleOver(battleIndex)
	for i=0,9 do
		local player = Battle.GetPlayer(battleIndex,i)
		if (player>-1 and Char.IsPlayer(player)==true) then
			for PetSlot=0,4 do
				local petIndex = Char.GetPet(player, PetSlot);
				if (petIndex>-1 and Char.GetData(petIndex, CONST.PET_DepartureBattleStatus) == CONST.PET_STATE_战斗) then
					local PetName = Char.GetData(petIndex,CONST.对象_名字);
					local PetId = Char.GetData(petIndex,CONST.PET_PetID);
					local petCoreIndex = Char.GetItemIndex(petIndex, CONST.宠道栏_颈圈);
					if ( petCoreIndex>-1 and CheckInTable(petEvolution_check,PetId)==true ) then
						local ItemID = Item.GetData(petCoreIndex, CONST.道具_ID);
						local petLevel = Char.GetData(petIndex, CONST.对象_等级);
						local burst = NLG.Rand(1,145);
						if (petLevel>=140 and petLevel>=burst) then
							--进化五围档次增加10
							local arts = { CONST.PET_体成, CONST.PET_力成, CONST.PET_强成, CONST.PET_敏成, CONST.PET_魔成 };
							pet_arts = table.map(arts, function(v)
								return { v, Pet.GetArtRank(petIndex, v) + 10 };
							end)
							table.forEach(pet_arts, function(v)
								Pet.SetArtRank(petIndex, v[1], v[2]);
							end);
							Pet.ReBirth(player, petIndex);
							table.forEach(pet_arts, function(v)
								Pet.SetArtRank(petIndex, v[1], v[2]);
							end);

							local arr_rank1_new = Pet.GetArtRank(petIndex,CONST.PET_体成);
							local arr_rank2_new = Pet.GetArtRank(petIndex,CONST.PET_力成);
							local arr_rank3_new = Pet.GetArtRank(petIndex,CONST.PET_强成);
							local arr_rank4_new = Pet.GetArtRank(petIndex,CONST.PET_敏成);
							local arr_rank5_new = Pet.GetArtRank(petIndex,CONST.PET_魔成);
							if (petLevel~=1) then
								Char.SetData(petIndex,CONST.对象_升级点,petLevel-1);
								Char.SetData(petIndex,CONST.对象_等级,petLevel);
								Char.SetData(petIndex,CONST.对象_体力, (Char.GetData(petIndex,CONST.对象_体力) + (arr_rank1_new * (1/24) * (petLevel - 1)*100)) );
								Char.SetData(petIndex,CONST.对象_力量, (Char.GetData(petIndex,CONST.对象_力量) + (arr_rank2_new * (1/24) * (petLevel - 1)*100)) );
								Char.SetData(petIndex,CONST.对象_强度, (Char.GetData(petIndex,CONST.对象_强度) + (arr_rank3_new * (1/24) * (petLevel - 1)*100)) );
								Char.SetData(petIndex,CONST.对象_速度, (Char.GetData(petIndex,CONST.对象_速度) + (arr_rank4_new * (1/24) * (petLevel - 1)*100)) );
								Char.SetData(petIndex,CONST.对象_魔法, (Char.GetData(petIndex,CONST.对象_魔法) + (arr_rank5_new * (1/24) * (petLevel - 1)*100)) );
							end

							--携带物配对成长
							if (ItemID==69047) then
								Char.SetData(petIndex, CONST.对象_必杀, Char.GetData(petIndex, CONST.对象_必杀) + 50);
							elseif (ItemID==69048) then
								Char.SetData(petIndex, CONST.对象_反击, Char.GetData(petIndex, CONST.对象_反击) + 50);
							elseif (ItemID==69049) then
								Char.SetData(petIndex, CONST.对象_命中, Char.GetData(petIndex, CONST.对象_命中) + 50);
							elseif (ItemID==69050) then
								Char.SetData(petIndex, CONST.对象_闪躲, Char.GetData(petIndex, CONST.对象_闪躲) + 50);
							end

							--形象改变、技能升级
							Char.SetData(petIndex, CONST.对象_形象,petEvolution_list[PetId][1]);
							Char.SetData(petIndex, CONST.对象_可视,petEvolution_list[PetId][1]);
							Char.SetData(petIndex, CONST.对象_原形,petEvolution_list[PetId][1]);
							Char.SetData(petIndex, CONST.对象_原始图档,petEvolution_list[PetId][1]);
							for slot=0,9 do
								if (Pet.GetSkill(petIndex,slot)==petEvolution_list[PetId][2]) then
									Pet.DelSkill(petIndex,slot);
									Pet.AddSkill(petIndex,petEvolution_list[PetId][3],slot);
								end
							end
							Char.SetData(petIndex,CONST.对象_名字,petEvolution_list[PetId][4]);

							Pet.UpPet(player, petIndex);
							NLG.UpChar(player);
							NLG.SystemMessage(player, "[系統]"..PetName.."散發著光正在產生變化。");
						end
					end
				else
				end
			end
		else
		end
	end
end
--离开战斗结束清理卡牌
function Module:onBattleExit(player, battleIndex, type)
	for cardItemId=75034,75037 do
		if (player>-1 and Char.HaveItem(player,cardItemId)>-1) then
			Char.DelItem(player, cardItemId, Char.ItemNum(player, cardItemId), false);
		end
	end
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
