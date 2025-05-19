---ģ����
local Module = ModuleBase:createModule('pokeBattle')

local playerOFF = 0;
local EncountSet = {
    { Type=1, GymBoss={"С��", 14640, 20252,7,4}, dropMenu={74121,74122}, nowEvent={"�����(ǰ������)",94}, EnemySet = {416322, 0, 0, 0, 0, 416295, 416290, 416290, 0, 0}, EnemyLevel = {50, 50, 50, 50, 50, 50, 50, 50, 50, 50} },		--
    { Type=2, GymBoss={"Сϼ", 14679, 20253,7,2}, dropMenu={74118,74119}, nowEvent={"�A�{��(ǰ�}��������)",95}, EnemySet = {416300, 416299, 416299, 0, 0, 416215, 0, 0, 0, 0}, EnemyLevel = {50, 50, 50, 50, 50, 50, 50, 50, 50, 50} },		--
    { Type=3, GymBoss={"�R־ʿ", 14638, 20254,7,2}, dropMenu={74115,74116}, nowEvent={"���~��(ǰ�����ش�)",96}, EnemySet = {416330, 0, 0, 416213, 416213, 416212, 416212, 416212, 0, 0}, EnemyLevel = {50, 50, 50, 50, 50, 50, 50, 50, 50, 50} },		--
    { Type=4, GymBoss={"���", 14680, 20255,7,3}, dropMenu={74124,74125}, nowEvent={"�����(ǰάŵ����)",97}, EnemySet = {416288, 0, 0, 416241, 416241, 416204, 0, 0, 416204, 416204}, EnemyLevel = {50, 50, 50, 50, 50, 50, 50, 50, 50, 50} },		--
    { Type=5, GymBoss={"����", 14691, 20256,6,10}, dropMenu={74127,74128}, nowEvent={"ǳ�t��(ǰ������)",98}, EnemySet = {0, 416276, 416276, 416272, 416272, 416269, 416269, 416269, 0, 0}, EnemyLevel = {50, 50, 50, 50, 50, 50, 50, 50, 50, 50} },		--
    { Type=6, GymBoss={"����", 14636, 20257,12,10}, dropMenu={74109,74110}, nowEvent={"���S��(ǰ�Ӽ{��)",99}, EnemySet = {0, 416351, 416351, 0, 416217, 416266, 416266, 416266, 0, 0}, EnemyLevel = {50, 50, 50, 50, 50, 50, 50, 50, 50, 50} },		--
    { Type=7, GymBoss={"�Ĳ�", 14578, 20258,4,3}, dropMenu={74112,74113}, nowEvent={"�tɏ�(ǰ��ŵ���)",100}, EnemySet = {416234, 416233, 416233, 0, 0, 416233, 0, 0, 416336, 416336}, EnemyLevel = {50, 50, 50, 50, 50, 50, 50, 50, 50, 50} },		--
    { Type=8, GymBoss={"��ľ", 14676, 20259,4,3}, dropMenu={74106,74107}, nowEvent={"������(ǰ���ȴ�)",101}, EnemySet = {416252, 0, 0, 0, 0, 416279, 416278, 416278, 416279, 416279}, EnemyLevel = {50, 50, 50, 50, 50, 50, 50, 50, 50, 50} },		--
}

tbl_GymBossNPCIndex = tbl_GymBossNPCIndex or {}

local GymsEnemy = {
    123092,123097,123124,	--��ʯ����
    123017,123101,123102,	--ˮ����
    123014,123015,123132,	--������
    123006,123043,123090,	--������
    123071,123074,123078,	--������
    123019,123068,123153,	--����������
    123138,123035,123036,	--������
    123080,123081,123050,	--��������
}	--ImageId

local restraintMap = {
    { 123022,123023,123089,123090,123091, },	--������
    { 123005,123006,123042,123043,123044,123045,123152,123153, },	--������
    { 123013,123014,123015,123016,123058,123059,123060,123130,123131,123132, },	--������
    { 123009,123010,123011,123017,123046,123047,123048,123049,123100,123101,123106,123107,123108,123112,123113,123114,123121,123122,123123, },	--ˮ����
    { 123024,123025,123026,123027,123146,123147,123148,123149,123150, },	--һ������
    { 123018,123019,123020,123021,123115,123116,123117, },	--��������
    { 123050,123051,123052,123067,123068,123151,123154, },	--����������
    { 123061,123062,123094,123095,123096, },	--������
    { 123000,123001,123002,123004,123034,123035,123036,123037,123038,123039,123118,123119,123120,123137,123138,123139, },	--������
    { 123028,123029,123030,123066,123076,123077,123102, },	--��������
    { 123040,123041,123085,123086,123087,123088,123134,123135,123136, },	--������
    { 123092,123093,123097,123098,123099,123124,123125,123126, },	--��ʯ����
    { 123079,123080,123081,123082,123103,123104,123105,123140, },	--��������
    { 123031,123032,123033,123069,123127,123128,123129, },	--��������
    { 123109,123110,123111,123143,123144,123145, },	--������
    { 123003,123055,123056,123057,123063,123064,123065,123083,123084,123133,123141,123142, },	--������
    { 123053,123054,123072,123075,123078, },	--������
    { 123007,123008,123070,123071,123073,123074, },	--������
  }
  local attr = {
    { 1, 2, 1, 1, 1, 0.5, 2, 1, 0.5, 0.5, 0.5, 1, 1,0.5, 0.5, 1, 2, 0.5 },
    { 0.5, 0.5, 1, 2, 1, 1, 1, 1, 0.5, 0.5, 1, 2, 2, 1, 0.5, 0.5, 1, 0.5 },
    { 1, 0.5, 0.5, 2, 1, 1, 1, 1, 1, 2, 1, 1, 0, 1, 1, 0.5, 1, 1 },
    { 1, 0.5, 1, 0.5, 1, 1, 1, 1, 2, 1, 1, 2, 2, 1, 1, 0.5, 1, 1 },
    { 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0.5, 1, 1, 0.5, 1, 1, 1 },
    { 1, 1, 1, 1, 0, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0.5, 1 },
    { 1, 1, 1, 1, 1, 1, 0.5, 1, 1, 1, 2, 1, 1, 1, 0.5, 1, 0, 2 },
    { 1, 1, 1, 0.5, 1, 1, 1, 0.5, 0.5, 2, 1, 1, 2, 1, 0.5, 2, 1, 1 },
    { 2, 2, 1, 0.5, 1, 1, 1, 2, 0.5, 1, 1, 0.5, 1, 1, 2, 0.5, 1, 1 },
    { 2, 2, 0.5, 1, 1, 1, 1, 1, 1, 1, 2, 0.5, 1, 1, 0.5, 1, 1, 1 },
    { 0.5, 1, 1, 1, 2, 0, 0.5, 2, 1, 0.5, 1, 2, 1, 0.5, 2, 1, 2, 0.5 },
    { 2, 1, 1, 1, 1, 1, 1, 2, 2, 2, 0.5, 1, 0.5, 1, 0.5, 1, 1, 1 },
    { 0.5, 0.5, 2, 1, 1, 1, 1, 1, 2, 0, 1, 2, 1, 1, 2, 1, 1, 2 },
    { 1, 1, 1, 1, 1, 1, 1, 1, 0.5, 1, 2, 1, 1, 1, 0.5, 2, 2, 0.5 },
    { 1, 1, 0.5, 0.5, 1, 1, 1, 2, 0.5, 1, 1, 2, 1, 2, 0.5, 1, 1, 1 },
    { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0.5, 2, 1, 1 },
    { 1, 1, 1, 1, 1, 2, 2, 1, 1, 1, 0.5, 1, 1, 0.5, 1, 1, 0.5, 1 },
    { 1, 2, 1, 1, 1, 0.5, 1, 1, 1, 1, 1, 0.5, 0.5, 2, 0, 1, 1, 0.5 },
  }

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BattleStartEvent', Func.bind(self.OnbattleStartEventCallback, self))
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
 for k,v in pairs(EncountSet) do
 if tbl_GymBossNPCIndex[k] == nil then
  local GymBossNPC = self:NPC_createNormal(v.GymBoss[1], v.GymBoss[2], { map =v.GymBoss[3], x = v.GymBoss[4], y = v.GymBoss[5], direction = 4, mapType = 0 })
  tbl_GymBossNPCIndex[k] = GymBossNPC
  self:NPC_regWindowTalkedEvent(tbl_GymBossNPCIndex[k], function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.����_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select == CONST.BUTTON_�ر� then
        return;
    end
    local gymBoss = tonumber(Field.Get(player, 'GymBoss')) or 0;
    local gymBossLevel = tonumber(Field.Get(player, 'GymBossLevel')) or 0;
    if seqno == 1 and data ==1 then

        Field.Set(player, 'GymBoss', k);
        Field.Set(player, 'GymBossLevel', 0);
        local Type = tonumber(Field.Get(player, 'GymBoss'));
        if (Type==v.Type) then
            local EnemyIdAr = v.EnemySet;
            local BaseLevelAr = v.EnemyLevel;
            local battleIndex = Battle.PVE(player, player, nil, EnemyIdAr, BaseLevelAr,  nil)
            Battle.SetWinEvent("./lua/Modules/pokeBattle.lua", "gymBossNPC_BattleWin", battleIndex);
            --local encountId = v.encountId_1st;
            --local battleIndex = Battle.Encount(npc, player, encountId);
        end
    elseif seqno == 1 and data ==2 then
        Field.Set(player, 'GymBoss', k);
        Field.Set(player, 'GymBossLevel', 1);
        local Type = tonumber(Field.Get(player, 'GymBoss'));
        if (Type==v.Type) then
            local EnemyIdAr = v.EnemySet;
            local BaseLevelAr = v.EnemyLevel;
            local battleIndex = Battle.PVE(player, player, nil, EnemyIdAr, BaseLevelAr,  nil)
            Battle.SetWinEvent("./lua/Modules/pokeBattle.lua", "gymBossNPC_BattleWin", battleIndex);
            --local encountId = v.encountId_1st;
            --local battleIndex = Battle.Encount(npc, player, encountId);
        end
    end
  end)
  self:NPC_regTalkedEvent(tbl_GymBossNPCIndex[k], function(npc, player)
    local gymBoss = tonumber(Field.Get(player, 'GymBoss')) or 0;
    local gymBossLevel = tonumber(Field.Get(player, 'GymBossLevel')) or 0;
    local nowGym = k;
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "4\\n@c����^�����"
                .."\\nĿǰ�P��:  ��"..nowGym.."���^\\n"
                .."\\n�����T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
                .."[�����ևLԇ���^����]\\n"
                .."[���Y����ٵ��^����]\\n";
      NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, CONST.��ť_�ر�, 1, msg);
    end
    return
  end)
 end
 end

end

function Module:OnbattleStartEventCallback(battleIndex)
	local leader1 = Battle.GetPlayer(battleIndex,0)
	local leader2 = Battle.GetPlayer(battleIndex,5)
	local leader = leader1
	if Char.GetData(leader2, CONST.����_����) == CONST.��������_�� then
		leader = leader2
	end
	local gymBoss = tonumber(Field.Get(leader, 'GymBoss')) or 0;
	for i=10, 19 do
		local enemy = Battle.GetPlayIndex(battleIndex, i)
		local player = Battle.GetPlayIndex(battleIndex, i-10)
		--local enemyId = Char.GetData(enemy, CONST.����_ENEMY_ID);
		local ImageId = Char.GetData(enemy, CONST.����_����);
		if enemy>=0 and Char.IsEnemy(enemy) and CheckInTable(GymsEnemy,ImageId)==true  then
			Char.SetTempData(enemy, '����', gymBoss);
			NLG.UpChar(enemy);
			if Char.GetData(player,CONST.����_��ս����) == 1  then
				NLG.Say(player,-1,"�����Ԅw�ơ�",4,3);
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
      if Char.GetData(leader2, CONST.����_����) == CONST.��������_�� then
          leader = leader2
      end
      local gymBoss = tonumber(Field.Get(leader, 'GymBoss')) or 0;
      local gymBossLevel = tonumber(Field.Get(leader, 'GymBossLevel')) or 0;
      if gymBossLevel==0 then
          speedRate=1;
      elseif gymBossLevel==1 then
          speedRate=2;
      end
      --print(Round)
      if Char.IsEnemy(defCharIndex) then
          --local enemyId = Char.GetData(defCharIndex, CONST.����_ENEMY_ID);
          local ImageId = Char.GetData(defCharIndex, CONST.����_����);
          if CheckInTable(GymsEnemy,ImageId)==true then
            if Char.IsPlayer(charIndex) and Char.IsDummy(charIndex)==false  then
               if (playerOFF==1 and (Char.GetData(charIndex, CONST.����_��ͼ)==20252 or Char.GetData(charIndex, CONST.����_��ͼ)==20253 or Char.GetData(charIndex, CONST.����_��ͼ)==20254 or Char.GetData(charIndex, CONST.����_��ͼ)==20255 or Char.GetData(charIndex, CONST.����_��ͼ)==20256 or Char.GetData(charIndex, CONST.����_��ͼ)==20257 or Char.GetData(charIndex, CONST.����_��ͼ)==20258 or Char.GetData(charIndex, CONST.����_��ͼ)==20259)) then
                  damage = 1;
               else
                  damage = damage;
               end
               return damage;
            end
            if gymBoss>=0 then
                local a,b = checkRestraint_def(charIndex,defCharIndex);
                if (a==0 or b==0) then
                    damage = 1;
                else
                    --print('��'..a..'��','��'..b..'��','����:'..attr[a][b])
                    damage = damage * attr[a][b] * speedRate;
                end
            end
            return damage;
          end

      elseif Char.IsEnemy(charIndex) and flg ~= CONST.DamageFlags.Magic then
          --local enemyId = Char.GetData(charIndex, CONST.����_ENEMY_ID);
          local ImageId = Char.GetData(charIndex, CONST.����_����);
          if CheckInTable(GymsEnemy,ImageId)==true then
            if Char.IsPlayer(defCharIndex) and Char.IsDummy(defCharIndex)==false  then
               if (Char.GetData(charIndex, CONST.����_��ͼ)==20252 or Char.GetData(charIndex, CONST.����_��ͼ)==20253 or Char.GetData(charIndex, CONST.����_��ͼ)==20254 or Char.GetData(charIndex, CONST.����_��ͼ)==20255 or Char.GetData(charIndex, CONST.����_��ͼ)==20256 or Char.GetData(charIndex, CONST.����_��ͼ)==20257 or Char.GetData(charIndex, CONST.����_��ͼ)==20258 or Char.GetData(charIndex, CONST.����_��ͼ)==20259) then
                  damage = damage;
               end
               return damage;
            end
            --local State = Char.GetTempData(defCharIndex, '����') or 0;
            if gymBoss>=0 then
                local a,b = checkRestraint_att(charIndex,defCharIndex);
                if (a==0 or b==0) then
                    damage = damage;
                else
                    --print('��'..a..'��','��'..b..'��','����:'..attr[a][b])
                    damage = damage * attr[a][b] * speedRate;
                end
            end
            return damage;
          end

      elseif Char.IsEnemy(charIndex) and flg == CONST.DamageFlags.Magic then
          --local enemyId = Char.GetData(charIndex, CONST.����_ENEMY_ID);
          local ImageId = Char.GetData(charIndex, CONST.����_����);
          if CheckInTable(GymsEnemy,ImageId)==true then
            if Char.IsPlayer(defCharIndex) and Char.IsDummy(defCharIndex)==false  then
               if (Char.GetData(charIndex, CONST.����_��ͼ)==20252 or Char.GetData(charIndex, CONST.����_��ͼ)==20253 or Char.GetData(charIndex, CONST.����_��ͼ)==20254 or Char.GetData(charIndex, CONST.����_��ͼ)==20255 or Char.GetData(charIndex, CONST.����_��ͼ)==20256 or Char.GetData(charIndex, CONST.����_��ͼ)==20257 or Char.GetData(charIndex, CONST.����_��ͼ)==20258 or Char.GetData(charIndex, CONST.����_��ͼ)==20259) then
                  damage = damage;
               end
               return damage;
            end
            --local State = Char.GetTempData(defCharIndex, '����') or 0;
            if gymBoss>=0 then
                local a,b = checkRestraint_att(charIndex,defCharIndex);
                if (a==0 or b==0) then
                    damage = damage;
                else
                    --print('��'..a..'��','��'..b..'��','����:'..attr[a][b])
                    damage = damage * attr[a][b] * 0.8 * speedRate;
                end
            end
            return damage;
          end

       end
  return damage;
end

function gymBossNPC_BattleWin(battleIndex, charIndex)
	--����ȵ�
	local leader1 = Battle.GetPlayer(battleIndex,0)
	local leader2 = Battle.GetPlayer(battleIndex,5)
	local leader = leader1
	if Char.GetData(leader2, CONST.CHAR_����) == CONST.��������_�� then
		leader = leader2
	end
	local gymBoss = tonumber(Field.Get(leader, 'GymBoss')) or 0;
	local gymBossLevel = tonumber(Field.Get(leader, 'GymBossLevel')) or 0;

	if (Char.GetData(charIndex, CONST.����_��ͼ)==20252 or Char.GetData(charIndex, CONST.����_��ͼ)==20253 or Char.GetData(charIndex, CONST.����_��ͼ)==20254 or Char.GetData(charIndex, CONST.����_��ͼ)==20255 or Char.GetData(charIndex, CONST.����_��ͼ)==20256 or Char.GetData(charIndex, CONST.����_��ͼ)==20257 or Char.GetData(charIndex, CONST.����_��ͼ)==20258 or Char.GetData(charIndex, CONST.����_��ͼ)==20259) then
	--���佱��
	for p=0,9 do
		local player = Battle.GetPlayIndex(battleIndex, p);
		local drop = {0,0,0,0,0,0,0,1,1,1,}
		local rand = drop[NLG.Rand(1,10)];
		if player>=0 and Char.GetData(player, CONST.����_����) == CONST.��������_�� then
			for k, v in ipairs(EncountSet) do
				if (gymBoss==v.Type) then
					Char.NowEvent(player, v.nowEvent[2], 1);
					Char.GiveItem(player, v.dropMenu[NLG.Rand(1,2)], rand);
				end
			end
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
          --local enemyId_a = Char.GetData(aIndex,CONST.PET_PetID);
          local ImageId_a = Char.GetData(aIndex, CONST.����_����);
          if Char.IsDummy(aIndex)==true  then
              --enemyId_a = Char.GetData(aIndex, CONST.����_���);
              ImageId_a = Char.GetData(aIndex, CONST.����_����);
          end
          --local enemyId_b = Char.GetData(bIndex, CONST.����_ENEMY_ID);
          local ImageId_b = Char.GetData(bIndex, CONST.����_����);
          for i, v in ipairs(restraintMap) do
              for k, enemyId in ipairs(v) do
                    if (v[k]==ImageId_a) then
                        --print(v[k], ImageId_a)
                        a = i;
                    end
              end
           end
           for j, v in ipairs(restraintMap) do
              for k, enemyId in ipairs(v) do
                    if (v[k]==ImageId_b) then
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
          --local enemyId_a = Char.GetData(aIndex, CONST.����_ENEMY_ID);
          --local enemyId_b = Char.GetData(bIndex,CONST.PET_PetID);
          local ImageId_a = Char.GetData(aIndex, CONST.����_����);
          local ImageId_b = Char.GetData(bIndex, CONST.����_����);
          if Char.IsDummy(bIndex)==true  then
              --enemyId_b = Char.GetData(bIndex, CONST.����_���);
              ImageId_b = Char.GetData(bIndex, CONST.����_����);
          end
          for i, v in ipairs(restraintMap) do
              for k, enemyId in ipairs(v) do
                    if (v[k]==ImageId_a) then
                        --print(v[k], ImageId_a)
                        a = i;
                    end
              end
           end
           for j, v in ipairs(restraintMap) do
              for k, enemyId in ipairs(v) do
                    if (v[k]==ImageId_b) then
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
