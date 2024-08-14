---ģ����
local Module = ModuleBase:createModule('demonSlayer')

local endlessBoss = {"�o�޳ǹ�", 14641, 1000,215,90}
local EnemySet = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
local CharSet = {606038,606039,606040,606041,606042,606043,}

function SetEnemySet(Level)
	local xr = NLG.Rand(1,3);
	for i=1,#CharSet-1-xr do
		r = NLG.Rand(1,i+1+xr);
		temp=CharSet[r];
		CharSet[r]=CharSet[i];
		CharSet[i]=temp;
	end
	local ix=1;
	if Level<30 then    -- ����
		for k=1,3 do
			EnemySet[k]=CharSet[ix];
			ix=ix+1;
		end
	elseif Level>=30 and Level<70 then    -- �߼�
		for k=1,5 do
			EnemySet[k]=CharSet[ix];
			ix=ix+1;
		end
	elseif Level>70 then    -- ����
		for k=1,10 do
			EnemySet[k]=CharSet[ix];
			ix=ix+1;
		end
	end
end

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BattleStartEvent', Func.bind(self.OnbattleStartEventCallback, self))
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
  endlessBossNPC = self:NPC_createNormal(endlessBoss[1], endlessBoss[2], { map = endlessBoss[3], x = endlessBoss[4], y = endlessBoss[5], direction = 0, mapType = 0 })
  self:NPC_regWindowTalkedEvent(endlessBossNPC, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.����_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select == CONST.BUTTON_�ر� then
        return;
    end
    if seqno == 1 and data ==1 then
        local endlessBossLevel = tonumber(Field.Get(player, 'EndlessBossLevel')) or 0;
        local enemyLv = 30 + (endlessBossLevel * 2);
        if (enemyLv>=250) then
            enemyLv =250;
        end
        SetEnemySet(endlessBossLevel);
        local EnemyIdAr = EnemySet;
        local BaseLevelAr = {enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv}
        local battleIndex = Battle.PVE(player, player, nil, EnemyIdAr, BaseLevelAr,  nil)
        Battle.SetWinEvent("./lua/Modules/demonSlayer.lua", "endlessBossNPC_BattleWin", battleIndex);
    elseif seqno == 1 and data ==2 then
        Field.Set(player, 'EndlessBossLevel', 0);
        NLG.SystemMessage(player,"[ϵ�y]�����ßo�M֮��ӑ���ȼ���");
        return;
    end
  end)
  self:NPC_regTalkedEvent(endlessBossNPC, function(npc, player)
    local endlessBossLevel = tonumber(Field.Get(player, 'EndlessBossLevel')) or 0;
    local nowLevel = endlessBossLevel+1;
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "4\\n@c��o�޳ǹ횢��΄ա�"
                                             .."\\n�M�ȵȼ�: "..nowLevel.."\\n"
                                             .."\\n�����T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
                                             .."[�����ӹ����y�o�Kӑ����]\\n"
                                             .."[�����ßo�޳ǹ횢�ȼ���]\\n";
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
	local endlessBossLevel = tonumber(Field.Get(leader, 'EndlessBossLevel')) or 0;
	for i=10, 19 do
		local enemy = Battle.GetPlayIndex(battleIndex, i)
		local player = Battle.GetPlayIndex(battleIndex, i-10)
		 --print(enemy, player)
                                        --local randImage = NLG.Rand(1, #imageNumber);
		local enemyId = Char.GetData(enemy, CONST.����_ENEMY_ID);
		if enemy>=0 and Char.IsEnemy(enemy) and CheckInTable(CharSet,enemyId)==true  then
			Char.SetTempData(enemy, '��ס', endlessBossLevel);
			Char.SetTempData(enemy, '��', endlessBossLevel);
			--Char.SetData(enemy, CONST.CHAR_����, imageNumber[randImage]);
			--Char.SetData(enemy, CONST.����_ENEMY_HeadGraNo,108510);
			NLG.UpChar(enemy);
			if Char.GetData(player,CONST.����_��ս����) == 1  then
				NLG.Say(player,-1,"����ס�I�򡿡����I��",4,3);
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
      local endlessBossLevel = tonumber(Field.Get(leader, 'EndlessBossLevel')) or 0;
      --print(Round)
      if Char.IsEnemy(defCharIndex) then
          local enemyId = Char.GetData(defCharIndex, CONST.����_ENEMY_ID);
          if CheckInTable(CharSet,enemyId)==true then
            local State = Char.GetTempData(defCharIndex, '��ס') or 0;
            local defDamage = 1 - (State*0.01);
            damage = damage * defDamage;
            return damage;
          end
      elseif Char.IsEnemy(charIndex) and flg ~= CONST.DamageFlags.Magic then
          local enemyId = Char.GetData(charIndex, CONST.����_ENEMY_ID);
          if CheckInTable(CharSet,enemyId)==true then
            local State = Char.GetTempData(charIndex, '��') or 0;
            local attDamage = 1 + (State * 0.02);
            damage = damage * attDamage;
            return damage;
          end
      elseif Char.IsEnemy(charIndex) and flg == CONST.DamageFlags.Magic then
          local enemyId = Char.GetData(charIndex, CONST.����_ENEMY_ID);
          if CheckInTable(CharSet,enemyId)==true then
            local State = Char.GetTempData(charIndex, '��') or 0;
            local attDamage = 1 + (State * 0.01);
            damage = damage * attDamage;
            return damage;
          end
       end
  return damage;
end

local dropMenu={
        {"�Ļ�֮��С��Ƭ",51071,1},         --ÿ10��һ���������䣬10�������޽���
        {"�Ļ�֮��С��Ƭ",51071,1},
        {"�Ļ�֮��С��Ƭ",51071,1},
        {"�Ļ�֮��С��Ƭ",51071,2},
        {"�Ļ�֮��С��Ƭ",51071,2},
        {"�Ļ�֮������Ƭ",51072,1},
        {"�Ļ�֮������Ƭ",51072,1},
        {"�Ļ�֮������Ƭ",51072,2},
        {"�Ļ�֮������Ƭ",51072,2},
        {"�Ļ�֮�����Ƭ",51073,1},
        {"�Ļ�֮�����Ƭ",51073,1},
        {"�Ļ�֮�����Ƭ",51073,1},
        {"�Ļ�֮�����Ƭ",51073,1},
        {"�����ǹ�",900504,100},
        {"���ɽ���",66668,5},
        {"���ɽ���",66668,10},
        {"����",70053,5},
        {"����",70053,10},
        {"������ʽ�W���C",75017,1},
}
function endlessBossNPC_BattleWin(battleIndex, charIndex)
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
		end
	end
	if (endlessBossLevel>=100) then
		Field.Set(leader, 'EndlessBossLevel', 0);
	else
		Field.Set(leader, 'EndlessBossLevel', endlessBossLevel+1);
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

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
