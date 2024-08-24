---ģ����
local Module = ModuleBase:createModule('pokeGym')

local gymBoss = {}
gymBoss[1] = {"����", 14641, 1000,226,88}

local EncountSet = {
    { Type=1, encountId_1st=600082, encountId_2nd=600083, EnId_1st= {600084,600084,600086,600087}, encountId_3rd=600085, EnId_2nd = {600086,600087,600087} },	--Bug(encountId)
}

local GymsEnemy = {600082,600083,600084,600085,600086,600087,}	--EnemyId
local restraintMap = {
    { 600019,600082,600083,600084,600085,600086,600087 },	--������
    { 600028,600069,600070 },	--������
    { 606033 },	--������
    { 600030,600072 },	--ˮ����
    { 600074,600077 },	--һ������
    { 600018, },	--��������
    { 600073 },	--����������
    { 606030 },	--������
    { 600029,606036,600071 },	--������
    { 600068,600075,600081 },	--��������
    { 600078,600080 },	--������
    { 600076,600079 },	--��ʯ����
  }
  local attr = {
    { 1, 2, 1, 1, 1, 0.5, 1, 1, 0.5, 0.5, 0.5, 1 },
    { 0.5, 0.5, 1, 2, 1, 1, 1, 1, 0.5, 0.5, 1, 2 },
    { 1, 0.5, 0.5, 2, 1, 1, 1, 1, 1, 2, 1, 1 },
    { 1, 0.5, 1, 0.5, 1, 1, 1, 1, 2, 1, 1, 2 },
    { 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0.5 },
    { 1, 1, 1, 1, 0, 2, 2, 1, 1, 1, 1, 1 },
    { 1, 1, 1, 1, 1, 1, 0.5, 1, 1, 1, 2, 1 },
    { 1, 1, 1, 0.5, 1, 1, 1, 0.5, 0.5, 2, 1, 1 },
    { 2, 2, 1, 0.5, 1, 1, 1, 2, 0.5, 1, 1, 0.5 },
    { 2, 2, 0.5, 1, 1, 1, 1, 1, 1, 1, 2, 0.5 },
    { 0.5, 1, 1, 1, 2, 0, 0.5, 2, 1, 0.5, 1, 2 },
    { 2, 1, 1, 1, 1, 1, 1, 2, 2, 2, 0.5, 1 },
  }
--local �������� = {}
--local �������� = {}
--local ������ = {}
--local ������ = {}
--local ������ = {}
--local ������ = {}

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BattleStartEvent', Func.bind(self.OnbattleStartEventCallback, self))
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
  self:regCallback('BattleNextEnemyInitEvent', Func.bind(self.OnBattleNextEnemyInitCallBack, self))

  gymBossNPC = self:NPC_createNormal(gymBoss[1][1], gymBoss[1][2], { map = gymBoss[1][3], x = gymBoss[1][4], y = gymBoss[1][5], direction = 0, mapType = 0 })
  self:NPC_regWindowTalkedEvent(gymBossNPC, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.����_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select == CONST.BUTTON_�ر� then
        return;
    end
    local gymBossLevel = tonumber(Field.Get(player, 'GymBossLevel')) or 0;
    if seqno == 1 and data ==1 then
        local PartyNum = Char.PartyNum(player);
        if (PartyNum>3) then
            NLG.SystemMessage(player,"[ϵ�y]���ɆT���ܳ��^3�ˡ�");
            return;
        elseif (PartyNum==-1) then
            NLG.SystemMessage(player,"[ϵ�y]���^��ֻ��1�b��������c���y��");
            return;
        elseif (PartyNum>=1 and PartyNum<=3) then
            for Slot=1,2 do
                local TeamPlayer = Char.GetPartyMember(player,Slot);
                if Char.IsDummy(TeamPlayer)==false then
                    NLG.SystemMessage(player,"[ϵ�y]���N2λ�ɆTֻ�����ن���ⷰ顣");
                    return;
                end
            end
        end
        Field.Set(player, 'GymBossLevel', 1);
        local Type = tonumber(Field.Get(player, 'GymBossLevel'));
        local battleIndex = Battle.Encount(npc, player, "3|0,1000,225,88||0|||||0|600082|||||");
        Battle.SetWinEvent("./lua/Modules/pokeGym.lua", "gymBossNPC_BattleWin", battleIndex);
    elseif seqno == 1 and data ==2 then
        Field.Set(player, 'GymBossLevel', 0);
        NLG.SystemMessage(player,"[ϵ�y]�����ðˌ��Ե��^Ѳޒ��");
        return;
    end
  end)
  self:NPC_regTalkedEvent(gymBossNPC, function(npc, player)
    local gymBossLevel = tonumber(Field.Get(player, 'GymBossLevel')) or 0;
    local nowLevel = gymBossLevel+1;
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "4\\n@c��ÿ�LѲޒ�˵��^�΄ա�"
                                             .."\\n�����M��:  ��"..nowLevel.."���^\\n"
                                             .."\\n�����T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
                                             .."[�����Ӱˌ��Ե��^����]\\n"
                                             .."[�����ðˌ��Ե��^Ѳޒ��]\\n";
      NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, CONST.BUTTON_�ر�, 1, msg);
    end
    return
  end)

end

function Module:OnbattleStartEventCallback(battleIndex)
	local leader1 = Battle.GetPlayer(battleIndex,0)
	local leader2 = Battle.GetPlayer(battleIndex,5)
	local leader = leader1
	if Char.GetData(leader2, CONST.CHAR_����) == CONST.��������_�� then
		leader = leader2
	end
	local gymBossLevel = tonumber(Field.Get(leader, 'GymBossLevel')) or 0;
	for i=10, 19 do
		local enemy = Battle.GetPlayIndex(battleIndex, i)
		local player = Battle.GetPlayIndex(battleIndex, i-10)
		local enemyId = Char.GetData(enemy, CONST.����_ENEMY_ID);
		if enemy>=0 and Char.IsEnemy(enemy) and CheckInTable(GymsEnemy,enemyId)==true  then
			Char.SetTempData(enemy, '����', gymBossLevel);
			NLG.UpChar(enemy);
			if Char.GetData(player,CONST.����_��ս����) == 1  then
				NLG.Say(player,-1,"�����Ԅw�ơ�",4,3);
			end
		end
	end
end

function Module:OnBattleNextEnemyInitCallBack(battleIndex, flg)
      local leader1 = Battle.GetPlayer(battleIndex,0)
      local leader2 = Battle.GetPlayer(battleIndex,5)
      local leader = leader1
      if Char.GetData(leader2, CONST.CHAR_����) == CONST.��������_�� then
          leader = leader2
      end
      local gymBossLevel = tonumber(Field.Get(leader, 'GymBossLevel')) or 0;
      local encountId = Data.GetEncountData(flg, CONST.ENCOUNT_INDEX)
      --print(encountId, flg)
      if (encountId==600083) then
          local Bug_EnId = {600084,600084,600086,600087}
          local roundRand = NLG.Rand(1,4);
          local encountIndex = Data.GetEncountIndex(Bug_EnId[roundRand])
          Battle.SetNextBattle(battleIndex,encountIndex, Bug_EnId[roundRand])
      elseif (encountId==600085) then
          local Bug_EnId = {600086,600087,600087}
          local roundRand = NLG.Rand(1,3);
          local encountIndex = Data.GetEncountIndex(Bug_EnId[roundRand])
          Battle.SetNextBattle(battleIndex,encountIndex, Bug_EnId[roundRand])
      end
  return flg;
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
      local gymBossLevel = tonumber(Field.Get(leader, 'GymBossLevel')) or 0;
      --print(Round)
      if Char.IsEnemy(defCharIndex) then
          local enemyId = Char.GetData(defCharIndex, CONST.����_ENEMY_ID);
          if CheckInTable(GymsEnemy,enemyId)==true then
            if Char.IsPlayer(charIndex) and Char.IsDummy(charIndex)==false  then
               if (Char.GetData(charIndex, CONST.CHAR_��ͼ)==1000) then
                  damage = 1;
               else
                  damage = damage;
               end
               return damage;
            end
            --local State = Char.GetTempData(defCharIndex, '����') or 0;
            if gymBossLevel>=0 then
                local a,b = checkRestraint_def(charIndex,defCharIndex);
                if (a==0 or b==0) then
                    damage = 1;
                else
                    print('��'..a..'��','��'..b..'��','����:'..attr[a][b])
                    damage = damage * attr[a][b];
                end
            end
            return damage;
          end

      elseif Char.IsEnemy(charIndex) and flg ~= CONST.DamageFlags.Magic then
          local enemyId = Char.GetData(charIndex, CONST.����_ENEMY_ID);
          if CheckInTable(GymsEnemy,enemyId)==true then
            if Char.IsPlayer(defCharIndex) and Char.IsDummy(defCharIndex)==false  then
               if (Char.GetData(defCharIndex, CONST.CHAR_��ͼ)==1000) then
                  damage = damage;
               end
               return damage;
            end
            --local State = Char.GetTempData(defCharIndex, '����') or 0;
            if gymBossLevel>=0 then
                local a,b = checkRestraint_att(charIndex,defCharIndex);
                if (a==0 or b==0) then
                    damage = 1;
                else
                    print('��'..a..'��','��'..b..'��','����:'..attr[a][b])
                    damage = damage * attr[a][b];
                end
            end
            return damage;
          end

      elseif Char.IsEnemy(charIndex) and flg == CONST.DamageFlags.Magic then
          local enemyId = Char.GetData(charIndex, CONST.����_ENEMY_ID);
          if CheckInTable(GymsEnemy,enemyId)==true then
            if Char.IsPlayer(defCharIndex) and Char.IsDummy(defCharIndex)==false  then
               if (Char.GetData(defCharIndex, CONST.CHAR_��ͼ)==1000) then
                  damage = damage;
               end
               return damage;
            end
            --local State = Char.GetTempData(defCharIndex, '����') or 0;
            if gymBossLevel>=0 then
                local a,b = checkRestraint_att(charIndex,defCharIndex);
                if (a==0 or b==0) then
                    damage = 1;
                else
                    print('��'..a..'��','��'..b..'��','����:'..attr[a][b])
                    damage = damage * attr[a][b] * 0.8;
                end
            end
            return damage;
          end

       end
  return damage;
end

local dropMenu={
        {"�Ļ�֮��С��Ƭ",51071,1},         --ÿ10��һ���������䣬10�������޽���
        {"�Ļ�֮��С��Ƭ",51071,2},
        {"�Ļ�֮������Ƭ",51072,1},
        {"�Ļ�֮������Ƭ",51072,2},
        {"�Ļ�֮�����Ƭ",51073,1},
        {"�����ǹ�",900504,100},
        {"���ɽ���",66668,5},
        {"���ɽ���",66668,10},
        {"����",70053,5},
        {"������ʽ�W���C",75017,1},
}
function gymBossNPC_BattleWin(battleIndex, charIndex)
	--����ȵ�
	local leader1 = Battle.GetPlayer(battleIndex,0)
	local leader2 = Battle.GetPlayer(battleIndex,5)
	local leader = leader1
	if Char.GetData(leader2, CONST.CHAR_����) == CONST.��������_�� then
		leader = leader2
	end
	local endlessBossLevel = tonumber(Field.Get(leader, 'EndlessBossLevel')) or 0;
	local m = endlessBossLevel+1;

	local lv = math.floor(m);
	local lvRank = math.floor(lv/10);

	if (Char.GetData(charIndex, CONST.CHAR_��ͼ)==20300 or Char.GetData(charIndex, CONST.CHAR_��ͼ)==7342 or Char.GetData(charIndex, CONST.CHAR_��ͼ)==7343) then
	--���ȵڷ��佱��
	for p=0,9 do
		local player = Battle.GetPlayIndex(battleIndex, p);
		local drop = math.random(0,2);
		if player>=0 and Char.GetData(player, CONST.CHAR_����) == CONST.��������_�� then
			--print(lv,lvRank,drop)
			for k, v in ipairs(dropMenu) do
				if k==lvRank and lvRank>=1  then
					Char.GiveItem(player, dropMenu[k][2], dropMenu[k][3]*drop);
				end
			end
			if (endlessBossLevel>=99) then
				local dropPet = math.random(1,5);
				local PetIDMenu = {900007,900008,900009}
				if (dropPet<=3) then
					Char.AddPet(player,PetIDMenu[dropPet]);
				end
			end
		end
	end
	if (endlessBossLevel>=99) then
		Field.Set(leader, 'EndlessBossLevel', 0);
		Char.Warp(charIndex,0,20300,293,456);
	else
		Field.Set(leader, 'EndlessBossLevel', endlessBossLevel+1);
		if (endlessBossLevel==0) then
			Char.Warp(charIndex,0,7342,4,32);
		elseif (endlessBossLevel==29) then
			Char.Warp(charIndex,0,7343,35,3);
		elseif (endlessBossLevel==49) then
			Char.Warp(charIndex,0,7342,24,41);
		elseif (endlessBossLevel==69) then
			Char.Warp(charIndex,0,7343,35,3);
		end
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

--�ҷ���charIndex,�ַ���defCharIndex
function checkRestraint_def(aIndex,bIndex)
          local a=0;
          local b=0;
          local enemyId_a = Char.GetData(aIndex,CONST.PET_PetID);
          if Char.IsDummy(aIndex)==true  then
              enemyId_a = Char.GetData(aIndex, CONST.CHAR_���);
          end
          local enemyId_b = Char.GetData(bIndex, CONST.����_ENEMY_ID);
          for i, v in ipairs(restraintMap) do
              for k, enemyId in ipairs(v) do
                    if (v[k]==enemyId_a) then
                        --print(v[k], enemyId_a)
                        a = i;
                    end
              end
           end
           for j, v in ipairs(restraintMap) do
              for k, enemyId in ipairs(v) do
                    if (v[k]==enemyId_b) then
                        b = j;
                    end
              end
           end
           return a,b;
end

--�ַ���charIndex,�ҷ���defCharIndex
function checkRestraint_att(aIndex,bIndex)
          local a=0;
          local b=0;
          local enemyId_a = Char.GetData(aIndex, CONST.����_ENEMY_ID);
          local enemyId_b = Char.GetData(bIndex,CONST.PET_PetID);
          if Char.IsDummy(aIndex)==true  then
              enemyId_b = Char.GetData(bIndex, CONST.CHAR_���);
          end
          for i, v in ipairs(restraintMap) do
              for k, enemyId in ipairs(v) do
                    if (v[k]==enemyId_a) then
                        --print(v[k], enemyId_a)
                        a = i;
                    end
              end
           end
           for j, v in ipairs(restraintMap) do
              for k, enemyId in ipairs(v) do
                    if (v[k]==enemyId_b) then
                        b = j;
                    end
              end
           end
           return a,b;
end
--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
