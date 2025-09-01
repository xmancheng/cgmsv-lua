---ģ����
local Module = ModuleBase:createModule('pokeBattle')

local playerOFF = 0;
local EncountSet = {
    { Type=1, GymBoss={"������", 14640, 20252,7,4}, dropMenu={74121,74122}, nowEvent={"�����(ǰ������)94",311}, EnemySet = {416364, 416367, 416281, 0, 0, 416438, 416366, 416460, 416461, 0}, EnemyLevel = {20, 20, 20, 20, 20, 20, 20, 20, 20, 20} },		--
    { Type=2, GymBoss={"������", 14679, 20253,7,2}, dropMenu={74118,74119}, nowEvent={"�A�{��(ǰ�}��������)95",312}, EnemySet = {416445, 416363, 416371, 416462, 416463, 0, 416362, 416370, 416408, 416409}, EnemyLevel = {20, 20, 20, 20, 20, 20, 20, 20, 20, 20} },		--
    { Type=3, GymBoss={"������", 14638, 20254,7,2}, dropMenu={74115,74116}, nowEvent={"���~��(ǰ�����ش�)96",313}, EnemySet = {416427, 416398, 416399, 416412, 416413, 416442, 0, 0, 416388, 416368}, EnemyLevel = {20, 20, 20, 20, 20, 20, 20, 20, 20, 20} },		--
    { Type=4, GymBoss={"ˮ����", 14680, 20255,7,3}, dropMenu={74124,74125}, nowEvent={"�����(ǰάŵ����)97",314}, EnemySet = {416428, 416375, 416375, 416453, 416453, 416376, 416452, 416376, 416434, 416434}, EnemyLevel = {20, 20, 20, 20, 20, 20, 20, 20, 20, 20} },		--
    { Type=5, GymBoss={"ľ����", 14691, 20256,6,10}, dropMenu={74127,74128}, nowEvent={"ǳ�t��(ǰ������)98",315}, EnemySet = {416447, 416372, 416457, 0, 0, 416446, 416372, 416456, 416441, 416405}, EnemyLevel = {20, 20, 20, 20, 20, 20, 20, 20, 20, 20} },		--
    { Type=6, GymBoss={"������", 14636, 20257,12,10}, dropMenu={74109,74110}, nowEvent={"���S��(ǰ�Ӽ{��)99",316}, EnemySet = {416423, 416449, 416449, 0, 0, 416425, 416402, 416403, 416451, 416451}, EnemyLevel = {20, 20, 20, 20, 20, 20, 20, 20, 20, 20} },		--
    { Type=7, GymBoss={"������", 14578, 20258,4,3}, dropMenu={74112,74113}, nowEvent={"�tɏ�(ǰ��ŵ���)100",317}, EnemySet = {416436, 416433, 416433, 416421, 0, 0, 416418, 416418, 416419, 416419}, EnemyLevel = {20, 20, 20, 20, 20, 20, 20, 20, 20, 20} },		--
    { Type=8, GymBoss={"��ľ", 14676, 20259,4,3}, dropMenu={74106,74107}, nowEvent={"������(ǰ���ȴ�)101",318}, EnemySet = {416252, 0, 0, 0, 0, 416279, 416278, 416278, 416279, 416279}, EnemyLevel = {50, 50, 50, 50, 50, 50, 50, 50, 50, 50} },		--
}

local rewardPet = {
    73015,73016,73023,73046,73047,73058,	--������
    73014,73018,73042,73043,73048,73049,73061,	--������
	73017,73027,73032,73037,73054,73060,	--������
	73020,73021,73065,	--ˮ����
	73019,73034,73044,73045,73059,73062,	--ľ����
	73040,73041,73052,73053,73063,73064,	--������
	73050,73051,73056,	--������
}

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

  self.GymBossNPC = self:NPC_createNormal('������ІT', 14637, { map =80020, x = 44, y = 44, direction = 4, mapType = 0 })
  Char.SetData(self.GymBossNPC,CONST.����_ENEMY_PetFlg+2,0)--�ɴ�͸��
  self:NPC_regWindowTalkedEvent(self.GymBossNPC, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.����_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select == CONST.BUTTON_�ر� or select == CONST.��ť_�� then
        return;
    end
    local nowGym = tonumber(os.date("%w",os.time()))+1;
    --local gymBoss = tonumber(Field.Get(player, 'GymBoss')) or 0;
    --local gymBossLevel = tonumber(Field.Get(player, 'GymBossLevel')) or 0;
    if seqno == 1 and select == CONST.��ť_�� then
        if (nowGym>=1) then
            local EnemyIdAr = EncountSet[nowGym].EnemySet;
            local BaseLevelAr = EncountSet[nowGym].EnemyLevel;
            local battleIndex = Battle.PVE(player, player, nil, EnemyIdAr, BaseLevelAr,  nil)
            Battle.SetWinEvent("./lua/Modules/pokeBattle.lua", "gymBossNPC_BattleWin", battleIndex);
        end
    end
    --[[if seqno == 1 and data ==1 then
        --Field.Set(player, 'GymBoss', k);
        --Field.Set(player, 'GymBossLevel', 0);
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
    end]]
  end)
  self:NPC_regTalkedEvent(self.GymBossNPC, function(npc, player)
    --local gymBoss = tonumber(Field.Get(player, 'GymBoss')) or 0;
    --local gymBossLevel = tonumber(Field.Get(player, 'GymBossLevel')) or 0;
    local nowGym = tonumber(os.date("%w",os.time()))+1;
    if (NLG.CanTalk(npc, player) == true) then
      --[[local msg = "4\\n@c����^�����"
                .."\\nĿǰ�P��:  ��"..nowGym.."���^\\n"
                .."\\n�����T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
                .."[�����ևLԇ���^����]\\n"
                .."[���Y����ٵ��^����]\\n";]]
      local msg = "\\n@c����^�����"
                .."\\n����Ŀ��:  "..EncountSet[nowGym].GymBoss[1].."���^\\n"
                .."\\n��������������������������������������������\\n"
                .."\\n\\n����[��]�_ʼ����[��]ȡ��\\n";
      NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 1, msg);
    end
    return
  end)

  self.GymRewardNPC = self:NPC_createNormal('���^�����Q', 400223, { map =80010, x = 95, y = 96, direction = 4, mapType = 0 })
  Char.SetData(self.GymRewardNPC,CONST.����_ENEMY_PetFlg+2,0)--�ɴ�͸��
  self:NPC_regWindowTalkedEvent(self.GymRewardNPC, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.����_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select == CONST.BUTTON_�ر� or select == CONST.��ť_�� then
        return;
    end
    local nowGym = tonumber(os.date("%w",os.time()))+1;
    if seqno == 1 and select == CONST.��ť_�� then
        for i=1,7 do
          local gymBadge = Char.NowEvent(player, EncountSet[i].nowEvent[2]);
          if (gymBadge~=1) then
            NLG.SystemMessage(player,"[ϵ�y]��δȡ�����л��¡�");
            return;
          end
        end
        if (Char.ItemSlot(player)>=17) then
          NLG.SystemMessage(player,"[ϵ�y]��Ʒ��λ���ѝM��");
          return;
        end
        for i=1,7 do
          Char.NowEvent(player, EncountSet[i].nowEvent[2],0);
        end
        local lucky = NLG.Rand(1,3);
        for i=1,lucky do
          local rand = NLG.Rand(1,#rewardPet);
          Char.GiveItem(player, rewardPet[rand], 1);
        end
    end
  end)
  self:NPC_regTalkedEvent(self.GymRewardNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "\\n@c����^�����"
                .."\\n�������е��^���«@��1-3���S�C�����ن���\\n"
                .."\\n��������������������������������������������\\n";
      for i=1,7 do
        if (i==1 or i==3 or i==5 or i==7) then msg = msg.."����" end
        msg = msg.. EncountSet[i].GymBoss[1].."���^ "
        local gymBadge = Char.NowEvent(player, EncountSet[i].nowEvent[2]);
        if (gymBadge==1) then msg = msg.."$5����ɡ�$0" else msg = msg.."$8δ���$0��" end
        if (i==2 or i==4 or i==6) then msg = msg.."\\n" elseif (i==7) then msg = msg.."����������������   \\n" end
      end
      NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 1, msg);
    end
    return
  end)
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

	if (Char.GetData(charIndex, CONST.����_��ͼ)==80020) then
	--���佱��
	for p=0,9 do
		local player = Battle.GetPlayIndex(battleIndex, p);
		local drop = {0,0,0,0,0,0,0,1,1,1,}
		local rand = drop[NLG.Rand(1,10)];
		if player>=0 and Char.GetData(player, CONST.����_����) == CONST.��������_�� then
			local nowGym = tonumber(os.date("%w",os.time()))+1;
			Char.NowEvent(player, EncountSet[nowGym].nowEvent[2], 1);
			Char.GiveItem(player, EncountSet[nowGym].dropMenu[NLG.Rand(1,2)], rand);
			Char.Warp(player,0,80010,103,103);
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
