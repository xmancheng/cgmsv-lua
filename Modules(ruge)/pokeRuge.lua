---ģ����
local Module = ModuleBase:createModule('pokeRuge')
local sgModule = getModule("setterGetter")
local JSON=require "lua/Modules/json"
local _ = require "lua/Modules/underscore"

-- NOTE ��ѯ���ݿ� heroes ����
function Module:queryHeroesData(charIndex)
  local cdKey = Char.GetData(charIndex, CONST.����_CDK)
  local regNo = Char.GetData(charIndex, CONST.����_RegistNumber)
  local sql="select value from des_heroes where cdkey= "..SQL.sqlValue(cdKey).." and regNo = "..SQL.sqlValue(regNo).." and is_deleted <> 1"
  local res,x =  SQL.QueryEx(sql)

  -- print(sql)
  -- print(res, x)
  local heroesData={};
  if res.rows then
    for i, row in ipairs(res.rows) do
      local value,pos = JSON.parse(row.value)
      -- print('heroesFn::250 >>', value, pos);
      table.insert(heroesData,value)
    end
  end

  return heroesData
end

-- NOTE ���� heroId ��ѯ heroData
function Module:getHeroDataByid(charIndex,id)
    local heroesData = sgModule:get(charIndex,"heroes")
    local heroData = _.detect(heroesData, function(i) return i.id==id end)
    return heroData
end

-- NOTE ��ȡ��սӶ�� ����
function Module:getCampHeroesData(charIndex)
  local heroesData = sgModule:get(charIndex,"heroes") or {}
  return _.select(heroesData,function(item) return item.status==1 end)
end

local rugeBoss = {}
rugeBoss[1] = {"Ruge݆ޒ����", 99453, 7351,9,29}
rugeBoss[2] = {"Ruge�д茦��", 14642, 7351,67,42}
rugeBoss[3] = {"Ruge�S�C��Ʒ", 0, 7351,67,13}
rugeBoss[4] = {"Ruge�S�C��Ʒ", 0, 7351,72,11}
rugeBoss[5] = {"Ruge�S�C��Ʒ", 0, 7351,61,12}

local EnemySet = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
--local MobsSet = {102100,102104,102105,102106,102109,102110,102114,102121,102125,102152,}	--�ӱ�
--local BossSet = {102154,102155,102156,102157,103257,103261,103262,103263,}		--ͷĿ
local MobsSet_L = {710001,710002,710003,710004,710005,710006,}
local MobsSet_M = {710007,710008,710009,710009,710010,710010,710011,710011,710012,710012,}
local MobsSet_H = {710013,710014,710015,710016,710017,710018,710019,710020,}
local BossSet_L = {710013,710014,710015,710016,710017,710018,710019,710020,}
local BossSet_H = {710021,710022,710023,710024,710025,}

function SetEnemySet(Level)

	local EnemySet = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
	local ix=1;
	if Level<30 then    -- ����
		EnemySet[1]=MobsSet_L[NLG.Rand(1,#MobsSet_L)];
		EnemySet[7]=MobsSet_L[NLG.Rand(1,#MobsSet_L)];
		EnemySet[8]=MobsSet_L[NLG.Rand(1,#MobsSet_L)];
	elseif Level>=30 and Level<70 then    -- �߼�
		EnemySet[2]=MobsSet_M[NLG.Rand(1,#MobsSet_M)];
		EnemySet[3]=MobsSet_M[NLG.Rand(1,#MobsSet_M)];
		EnemySet[6]=MobsSet_M[NLG.Rand(1,#MobsSet_M)];
		EnemySet[9]=MobsSet_M[NLG.Rand(1,#MobsSet_M)];
		EnemySet[10]=MobsSet_M[NLG.Rand(1,#MobsSet_M)];
	elseif Level>=70 then    -- ����
		for k=1,10 do
			EnemySet[k]=MobsSet_L[NLG.Rand(1,#MobsSet_L)];
			ix=ix+1;
		end
		EnemySet[4]=MobsSet_H[NLG.Rand(1,#MobsSet_H)];
		EnemySet[5]=MobsSet_H[NLG.Rand(1,#MobsSet_H)];
	end
	--ÿ5��1��λ����BOSS
	if (math.fmod(Level, 10)==4 or math.fmod(Level, 10)==9) then
		if (Level<90) then
			local rand = NLG.Rand(1,#BossSet_L);
			EnemySet[1]=BossSet_L[rand];
		else
			local rand = NLG.Rand(1,#BossSet_H);
			EnemySet[1]=BossSet_H[rand];
		end
	end
	return EnemySet;
end

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BattleStartEvent', Func.bind(self.OnbattleStartEventCallback, self))
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
  RugeNPC = self:NPC_createNormal(rugeBoss[1][1], rugeBoss[1][2], { map = rugeBoss[1][3], x = rugeBoss[1][4], y = rugeBoss[1][5], direction = 0, mapType = 0 })
  Char.SetData(RugeNPC,CONST.����_ENEMY_PetFlg+2,0);
  self:NPC_regWindowTalkedEvent(RugeNPC, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.����_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select == CONST.BUTTON_�ر� then
        return;
    end
    local rugeBossLevel = tonumber(Field.Get(player, 'RugeBossLevel')) or 0;
    if seqno == 1 and select==CONST.BUTTON_��һҳ then
      local msg = "4\\n@c��݆ޒԇ�����ӡ�"
                .."\\n���x��ⷰ�ÿ�ζ���ȫ�µ��_ʼ��\\n"
                .."\\n�����T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
                .."[����ϵⷰ�(̹)��]\\n"
                .."[����ϵⷰ�(��)��]\\n"
                .."[��ˮϵⷰ�(�a)��]\\n";
      NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, CONST.BUTTON_�ر�, 11, msg);
    elseif seqno == 11 then
      local heroesData = self:queryHeroesData(player);
      for k, v in ipairs(heroesData) do
        local heroData = self:getHeroDataByid(player,v.id);
        local heroIndex  = heroData.index
        if heroIndex~=nil then
          Char.LeaveParty(heroIndex);
        end
        getModule('heroesFn'):delHeroDummy(player,heroData);
        getModule('heroesFn'):deleteHeroData(player,v);
      end
      if data==1 then
        Field.Set(player, 'RugeBossLevel', 0);
		Char.SetData(player, CONST.����_�ȼ�, 30);
		Char.SetData(player, CONST.����_����, 0);
		Char.SetData(player, CONST.����_����, 0);
		Char.SetData(player, CONST.����_ǿ��, 0);
		Char.SetData(player, CONST.����_�ٶ�, 0);
		Char.SetData(player, CONST.����_ħ��, 0);
		Char.SetData(player, CONST.����_������, 146);
		Char.SetData(player, CONST.����_����, 0);
		NLG.UpChar(player);
		Char.Warp(player,0,7351,16,28);
		Char.GiveItem(player, 71100, 1);
      elseif data==2 then
        Field.Set(player, 'RugeBossLevel', 0);
		Char.SetData(player, CONST.����_�ȼ�, 30);
		Char.SetData(player, CONST.����_����, 0);
		Char.SetData(player, CONST.����_����, 0);
		Char.SetData(player, CONST.����_ǿ��, 0);
		Char.SetData(player, CONST.����_�ٶ�, 0);
		Char.SetData(player, CONST.����_ħ��, 0);
		Char.SetData(player, CONST.����_������, 146);
		Char.SetData(player, CONST.����_����, 0);
		NLG.UpChar(player);
		Char.Warp(player,0,7351,16,28);
		Char.GiveItem(player, 71101, 1);
      elseif data==3 then
        Field.Set(player, 'RugeBossLevel', 0);
		Char.SetData(player, CONST.����_�ȼ�, 30);
		Char.SetData(player, CONST.����_����, 0);
		Char.SetData(player, CONST.����_����, 0);
		Char.SetData(player, CONST.����_ǿ��, 0);
		Char.SetData(player, CONST.����_�ٶ�, 0);
		Char.SetData(player, CONST.����_ħ��, 0);
		Char.SetData(player, CONST.����_������, 146);
		Char.SetData(player, CONST.����_����, 0);
		NLG.UpChar(player);
		Char.Warp(player,0,7351,16,28);
		Char.GiveItem(player, 71102, 1);
      end
    end
  end)
  self:NPC_regTalkedEvent(RugeNPC, function(npc, player)
    local rugeBossLevel = tonumber(Field.Get(player, 'RugeBossLevel')) or 0;
    local nowLevel = rugeBossLevel+1;
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "\\nŮ���Z�]��"
                .."\\n�㲻�ұ����������ن�����������@�e��Ŀǰ�o���ص�ԭ��������\\n"
                .."\\n�������㡸���_�����Ǹ�⡹�����o����Ů��ӳ��c֧Ԯ\\n"
                .."\\nՈ���@СС�Č��ɉ�������磬�ٴ��_������\\n";
      NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.BUTTON_��ȡ��, 1, msg);
    end
    return
  end)


  RugeNPC2 = self:NPC_createNormal(rugeBoss[2][1], rugeBoss[2][2], { map = rugeBoss[2][3], x = rugeBoss[2][4], y = rugeBoss[2][5], direction = 0, mapType = 0 })
  Char.SetData(RugeNPC2,CONST.����_ENEMY_PetFlg+2,0);
  self:NPC_regWindowTalkedEvent(RugeNPC2, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.����_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select == CONST.BUTTON_�� then
        return;
    elseif seqno == 2 and select == CONST.BUTTON_�� then
        local rugeBossLevel = tonumber(Field.Get(player, 'RugeBossLevel')) or 0;
        local enemyLv = 20 + (rugeBossLevel * 1);
        if (enemyLv>=250) then
            enemyLv =250;
        end
        local EnemyIdAr = SetEnemySet(rugeBossLevel);
        local BaseLevelAr = {enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv}
        local battleIndex = Battle.PVE(player, player, nil, EnemyIdAr, BaseLevelAr,  nil)
        Battle.SetWinEvent("./lua/Modules/pokeRuge.lua", "RugeNPC_BattleWin", battleIndex);
    end
  end)
  self:NPC_regTalkedEvent(RugeNPC2, function(npc, player)
    local rugeBossLevel = tonumber(Field.Get(player, 'RugeBossLevel')) or 0;
    local nowLevel = rugeBossLevel+1;
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "\\n@c��ħ�����ɉ�������"
                .."\\n�M�ȌӔ�: "..nowLevel.."\\n"
                .."\\n�����T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
                .."[���_ʼ�д茦��]\\n";
      NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.BUTTON_�Ƿ�, 2, msg);
    end
    return
  end)

  RugeprizeNPC1 = self:NPC_createNormal(rugeBoss[3][1], rugeBoss[3][2], { map = rugeBoss[3][3], x = rugeBoss[3][4], y = rugeBoss[3][5], direction = 0, mapType = 0 })
  Char.SetData(RugeprizeNPC1,CONST.����_ENEMY_PetFlg+2,0);
  self:NPC_regWindowTalkedEvent(RugeprizeNPC1, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.����_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select == CONST.BUTTON_�� then
        return;
    elseif seqno == 2 and select == CONST.BUTTON_�� then
        local rugeBossLevel = tonumber(Field.Get(player, 'RugeBossLevel')) or 0;
		Char.Warp(player,0,7351,25,29);
    end
  end)
  self:NPC_regTalkedEvent(RugeprizeNPC1, function(npc, player)
    local rugeBossLevel = tonumber(Field.Get(player, 'RugeBossLevel')) or 0;
    local nowLevel = rugeBossLevel+1;
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "\\n@c��ħ�����ɉ�������"
                                             .."\\n��Ʒ�f��: "..nowLevel.."\\n"
                                             .."\\n�����T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
                                             .."[���Iȡ�@���؄e�Ī��]\\n";
      NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.BUTTON_�Ƿ�, 2, msg);
    end
    return
  end)

  --ȫ��aѪ
  RugehealNPC = self:NPC_createNormal('�Y�����', 231052, { x = 39, y = 34, mapType = 0, map = 7351, direction = 0 });
  Char.SetData(RugehealNPC,CONST.����_ENEMY_PetFlg+2,0);
  self:NPC_regTalkedEvent(RugehealNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "\\n\\n@c�؏�ħ��ֵ��+��������ֵ��\\n\\n�؏�����ֵ\\n\\n�؏͌��������ֵ��ħ��ֵ\\n\\nһ�I�؏�ȫ�����͌���ħ��������\\n";
      NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.��ť_ȷ���ر�, 3, msg);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(RugehealNPC, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.����_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select > 0 then
      if seqno == 3 and select == CONST.��ť_ȷ�� then
        gold = Char.GetData(player, CONST.����_���);
        totalGold = 0;
        FpGold = 0;
        LpGold = 0;
        --Ӌ��؏Ϳ����~
        if Char.PartyNum(player)>0 and player==Char.GetPartyMember(player,0) then
          for slot = 0,4 do
            local p = Char.GetPartyMember(player,slot)
            if(p>=0) then
                local lp = Char.GetData(p, CONST.����_Ѫ)
                local maxLp = Char.GetData(p, CONST.����_���Ѫ)
                local fp = Char.GetData(p, CONST.����_ħ)
                local maxFp = Char.GetData(p, CONST.����_���ħ)
                if fp <= maxFp then
                      FpGold = FpGold + maxFp - fp;
                end
                if lp <= maxLp then
                      LpGold = LpGold + maxLp - lp;
                end
            end
          end
        else
                local lp = Char.GetData(player, CONST.����_Ѫ)
                local maxLp = Char.GetData(player, CONST.����_���Ѫ)
                local fp = Char.GetData(player, CONST.����_ħ)
                local maxFp = Char.GetData(player, CONST.����_���ħ)
                if fp <= maxFp then
                      FpGold = FpGold + maxFp - fp;
                end
                if lp <= maxLp then
                      LpGold = LpGold + maxLp - lp;
                end
        end
        print(FpGold,LpGold)
        if FpGold*0.5 >= LpGold then
          totalGold = FpGold;
        else
          totalGold = FpGold + LpGold - FpGold*0.5;
        end
        local msg = "\\n\\n@cȫ꠻؏���Ҫ���M"..totalGold.."������\\n\\n�F�н��X��"..gold.."������\\n\\n\\nҪ�؏͆᣿\\n";
        NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 31, msg);
      --������aѪħ
      elseif seqno == 31 and select == CONST.��ť_�� then
        if gold < totalGold then
                NLG.SystemMessage(player, '���Ų���o���؏�');
                return
        else
                if Char.PartyNum(player)>0 and player==Char.GetPartyMember(player,0) then
                    for slot = 0,4 do
                       local p = Char.GetPartyMember(player,slot);
                       if(p>=0) then
                           local maxLp = Char.GetData(p, CONST.����_���Ѫ);
                           local maxFp = Char.GetData(p, CONST.����_���ħ);
                           Char.SetData(p, CONST.����_Ѫ, maxLp);
                           Char.SetData(p, CONST.����_ħ, maxFp);
                           NLG.UpChar(p);
                           for petSlot  = 0,4 do
                              local petIndex = Char.GetPet(p,petSlot);
                              if petIndex >= 0 then
                                  local maxLp = Char.GetData(petIndex, CONST.����_���Ѫ);
                                  local maxFp = Char.GetData(petIndex, CONST.����_���ħ);
                                  Char.SetData(petIndex, CONST.����_Ѫ, maxLp);
                                  Char.SetData(petIndex, CONST.����_ħ, maxFp);
                                  Pet.UpPet(p, petIndex);
                              end
                           end
                       end
                    end
                    Char.AddGold(player, -totalGold);
                    NLG.UpChar(player);
                else
                           local maxLp = Char.GetData(player, CONST.����_���Ѫ);
                           local maxFp = Char.GetData(player, CONST.����_���ħ);
                           Char.SetData(player, CONST.����_Ѫ, maxLp);
                           Char.SetData(player, CONST.����_ħ, maxFp);
                           NLG.UpChar(player);
                           for petSlot  = 0,4 do
                              local petIndex = Char.GetPet(player,petSlot);
                              if petIndex >= 0 then
                                  local maxLp = Char.GetData(petIndex, CONST.����_���Ѫ);
                                  local maxFp = Char.GetData(petIndex, CONST.����_���ħ);
                                  Char.SetData(petIndex, CONST.����_Ѫ, maxLp);
                                  Char.SetData(petIndex, CONST.����_ħ, maxFp);
                                  Pet.UpPet(player, petIndex);
                              end
                           end
                    Char.AddGold(player, -totalGold);
                    NLG.UpChar(player);
                    --NLG.SystemMessage(player, '��L�ſ�ʹ�ã�');
                end
        end

      end
    end
  end)


end

function Module:OnbattleStartEventCallback(battleIndex)
	local leader1 = Battle.GetPlayer(battleIndex,0)
	local leader2 = Battle.GetPlayer(battleIndex,5)
	local leader = leader1
	if Char.GetData(leader2, CONST.CHAR_����) == CONST.��������_�� then
		leader = leader2
	end
	local rugeBossLevel = tonumber(Field.Get(leader, 'RugeBossLevel')) or 0;
	for i=10, 19 do
		local enemy = Battle.GetPlayIndex(battleIndex, i)
		local player = Battle.GetPlayIndex(battleIndex, i-10)
		 --print(enemy, player)
                                        --local randImage = NLG.Rand(1, #imageNumber);
		local enemyId = Char.GetData(enemy, CONST.����_ENEMY_ID);
		if enemy>=0 and Char.IsEnemy(enemy) then
			if CheckInTable(MobsSet_L,enemyId)==true or CheckInTable(MobsSet_M,enemyId)==true or CheckInTable(MobsSet_H,enemyId)==true  then
				Char.SetTempData(enemy, '��ס', rugeBossLevel);
				Char.SetTempData(enemy, '��', rugeBossLevel);
				--Char.SetData(enemy, CONST.CHAR_����, imageNumber[randImage]);
				--Char.SetData(enemy, CONST.����_ENEMY_HeadGraNo,108510);
				NLG.UpChar(enemy);
				if Char.GetData(player,CONST.����_��ս����) == 1  then
					NLG.Say(player,-1,"����ס�I�򡿡����I��",4,3);
				end
			end
		elseif enemy>=0 and Char.IsEnemy(enemy)  then
			if CheckInTable(BossSet_L,enemyId)==true or CheckInTable(BossSet_H,enemyId)==true  then
				Char.SetTempData(enemy, '��ס', rugeBossLevel);
				Char.SetTempData(enemy, '��', rugeBossLevel);
				NLG.UpChar(enemy);
			end
		end
	end
end

function Module:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
      --self:logDebug('OnDamageCalculateCallBack', charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
      local Round = Battle.GetTurn(battleIndex);
      local leader1 = Battle.GetPlayer(battleIndex,0)
      local leader2 = Battle.GetPlayer(battleIndex,5)
      local leader = leader1
      if Char.GetData(leader2, CONST.CHAR_����) == CONST.��������_�� then
          leader = leader2
      end
      local rugeBossLevel = tonumber(Field.Get(leader, 'RugeBossLevel')) or 0;
      --print(Round)
      if Char.IsEnemy(defCharIndex) then
          local enemyId = Char.GetData(defCharIndex, CONST.����_ENEMY_ID);
          if CheckInTable(MobsSet_L,enemyId)==true or CheckInTable(MobsSet_M,enemyId)==true or CheckInTable(MobsSet_H,enemyId)==true then
            local State = Char.GetTempData(defCharIndex, '��ס') or 0;
            local defDamage = 1 - (State*0.001);
            damage = damage * defDamage;
            return damage;
          end
          if CheckInTable(BossSet_L,enemyId)==true or CheckInTable(BossSet_H,enemyId)==true then
            local State = Char.GetTempData(defCharIndex, '��ס') or 0;
            local defDamage = 1 - (State*0.001);
            damage = damage * defDamage;
            return damage;
          end
      elseif Char.IsEnemy(charIndex) and flg ~= CONST.DamageFlags.Magic then
          local enemyId = Char.GetData(charIndex, CONST.����_ENEMY_ID);
          if CheckInTable(MobsSet_L,enemyId)==true or CheckInTable(MobsSet_M,enemyId)==true or CheckInTable(MobsSet_H,enemyId)==true then
            local State = Char.GetTempData(charIndex, '��') or 0;
            local attDamage = 1 + (State * 0.02);
            damage = damage * attDamage;
            return damage;
          end
          if CheckInTable(BossSet_L,enemyId)==true or CheckInTable(BossSet_H,enemyId)==true then
            local State = Char.GetTempData(charIndex, '��') or 0;
            local attDamage = 1 + (State * 0.02);
            damage = damage * attDamage;
            return damage;
          end
      elseif Char.IsEnemy(charIndex) and flg == CONST.DamageFlags.Magic then
          local enemyId = Char.GetData(charIndex, CONST.����_ENEMY_ID);
          if CheckInTable(MobsSet_L,enemyId)==true or CheckInTable(MobsSet_M,enemyId)==true or CheckInTable(MobsSet_H,enemyId)==true then
            local State = Char.GetTempData(charIndex, '��') or 0;
            local attDamage = 1 + (State * 0.01);
            damage = damage * attDamage;
            return damage;
          end
          if CheckInTable(BossSet_L,enemyId)==true or CheckInTable(BossSet_H,enemyId)==true then
            local State = Char.GetTempData(charIndex, '��') or 0;
            local attDamage = 1 + (State * 0.01);
            damage = damage * attDamage;
            return damage;
          end
       end
  return damage;
end

local dropMenu={
        {"С����������",631093,1},         --ÿ10�����䣬10�������޽���
        {"С����������",631093,2},
        {"�Ʒʯ��",73896,1},
        {"�з���������",631094,2},
        {"�Ʒʯ��",73897,1},
        {"�����������",631095,2},
        {"ˮ��ʯ��",73898,1},
        {"�����ػ���",34638,1},
        {"��ʹ֮ף��",45953,1},
        {"ˮ�������",45993,1},
}
function RugeNPC_BattleWin(battleIndex, charIndex)
	--����ȵ�
	local leader1 = Battle.GetPlayer(battleIndex,0)
	local leader2 = Battle.GetPlayer(battleIndex,5)
	local leader = leader1
	if Char.GetData(leader2, CONST.CHAR_����) == CONST.��������_�� then
		leader = leader2
	end
	local rugeBossLevel = tonumber(Field.Get(leader, 'RugeBossLevel')) or 0;
	local m = rugeBossLevel+1;

	local lv = math.floor(m);
	local lvRank = math.floor(lv/10);
	local lvdrop = math.fmod(lv,10);

	if (Char.GetData(charIndex, CONST.CHAR_��ͼ)==7351) then
--[[
	--���ȵڷ��佱��
	for p=0,9 do
		local player = Battle.GetPlayIndex(battleIndex, p);
		local drop = math.random(0,2);
		if player>=0 and Char.GetData(player, CONST.CHAR_����) == CONST.��������_�� then
			--print(lv,lvRank,drop)
			for k, v in ipairs(dropMenu) do
				if k==lvRank and lvdrop==0  then
					Char.GiveItem(player, dropMenu[k][2], dropMenu[k][3]*drop);
				end
			end
			--if (rugeBossLevel>=99) then
			--	local dropPet = math.random(1,5);
			--	local PetIDMenu = {900007,900008,900009}
			--	if (dropPet<=3) then
			--		Char.AddPet(player,PetIDMenu[dropPet]);
			--	end
			--end
		end
	end
]]
	if (rugeBossLevel>=99) then
		Field.Set(leader, 'RugeBossLevel', 0);
		Char.Warp(charIndex,0,1000,225,86);
	else
		Field.Set(leader, 'RugeBossLevel', rugeBossLevel+1);
		Char.Warp(charIndex,0,7351,67,22);
	end
	end
	Battle.UnsetWinEvent(battleIndex);
end

function CheckInTable(_idTab, _idVar) ---ѭ������
	for k,v in pairs(_idTab) do
		if v==_idVar then
			return true
		end
	end
	return false
end

function mykgold(player,gold)
	local tjb = Char.GetData(player,CONST.����_���);
	tjb = tjb - gold; 
	if (tjb >= 0) then
		Char.SetData(player,CONST.����_���,tjb);
		NLG.UpChar(player);
		NLG.SystemMessage(player,"������"..gold.." Għ�š�");
		return true;
	end
	return false;
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
