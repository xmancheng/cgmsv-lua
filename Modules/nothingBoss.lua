---ģ����
local Module = ModuleBase:createModule('nothingBoss')

local startImage = 108304;      --���涨�c����
local transImage = 108331;      --���Y׃������
local executeEnemy = 406092;      --���Є�����Enemy��̖

local EnemySet = {}
local BaseLevelSet = {}
local Pos = {}
local FTime = os.time()
local Setting = 0;
--���н���
--     ��(4)	��(2)	һ(0)	��(1)	��(3)
--     ʮ(9)	��(7)	��(5)	��(6)	��(8)
------------��սNPC����------------
EnemySet[1] = {0, 406092, 406092, 0, 0, 406092, 0, 0, 406092, 406092}--0����û�й�
BaseLevelSet[1] = {0, 300, 300, 0, 0, 300, 0, 0, 300, 300}
Pos[1] = {"ʮ��ϯ",EnemySet[1],BaseLevelSet[1]}
------------------------------------------------------
--��������
local Pts= 70206;                                    --��Ů��ƻ��
local NothingBoss = {
      { weekday=1, weekdayItem=70241, lordName="ʮ��ϯ", lordImage=101137 , waitingArea={map=1000,X=229,Y=112}, onfieldArea={map=25013,X=35,Y=15},
        rewardsItem={71041,71037,71038}, rewardsItem_count=1, prizeItem={70202,70203,70204,70205,70206,72000}, prizeItem_count=1},
}
tbl_duel_user = {};			--��ǰ������ҵ��б�
tbl_win_user = {};
nothingBossBattle = {}
tbl_NothingBossNPCIndex = tbl_NothingBossNPCIndex or {}
------------------------------------------------
--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BattleStartEvent', Func.bind(self.OnbattleStartEventCallback, self))
  --self:regCallback('BeforeBattleTurnEvent', Func.bind(self.OnBeforeBattleTurnCommand, self))
  self:regCallback('BeforeBattleTurnStartEvent', Func.bind(self.OnBeforeBattleTurnStartCommand, self))
  self:regCallback('AfterBattleTurnEvent', Func.bind(self.OnAfterBattleTurnCommand, self))
  self:regCallback('EnemyCommandEvent', Func.bind(self.OnEnemyCommandCallBack, self))
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
  self:regCallback('BattleDodgeRateEvent', Func.bind(self.OnBattleDodgeRateEvent, self))
  --self:regCallback('BattleOverEvent', Func.bind(self.battleOverEventCallback, self))
    NothingBossNPC = self:NPC_createNormal('�]����', startImage, { map = 1000, x = 229, y = 112, direction = 5, mapType = 0 })
    self:NPC_regWindowTalkedEvent(NothingBossNPC, function(npc, player, _seqno, _select, _data)
	local cdk = Char.GetData(player,CONST.����_CDK);
	local seqno = tonumber(_seqno)
	local select = tonumber(_select)
	local data = tonumber(_data)
    end)
    self:NPC_regTalkedEvent(NothingBossNPC, function(npc, player)
      if(NLG.CheckInFront(player, npc, 1)==false) then
          return ;
      end
      if (NLG.CanTalk(npc, player) == true) then
               --�������
               local i;
               i = Char.GetData(player, CONST.����_����);
               if i >= 4 then 
                              i = i - 4;
               else
                              i = i + 4;		
               end
               Char.SetData(npc, CONST.����_����,i);
               NLG.UpChar(npc);
               --����BOSS
	local playerName = Char.GetData(player,CONST.CHAR_����);
	local partyname = playerName .. "���";
	local playerLv = Char.GetData(player,CONST.CHAR_�ȼ�);
	if playerLv<=100 then
		NLG.SystemMessage(player,"[ϵ�y]ӑ�����h��L�ȼ�Ҫ100����");
		return;
	end
	for k,v in pairs(NothingBoss) do
		if ( 1==v.weekday ) then
			table.insert(tbl_duel_user,player);
			boss_round_start(player, boss_round_callback);

			if (Char.EndEvent(player, 308) == 1) then
				local rand = NLG.Rand(1,#v.prizeItem);
				Char.GiveItem(player, v.prizeItem[rand], v.prizeItem_count);
			end
			local PartyNum = Char.PartyNum(player);
			if (PartyNum>1) then
				for Slot=1,4 do
					local TeamPlayer = Char.GetPartyMember(player,Slot);
					if Char.IsDummy(TeamPlayer)==false then
						if (Char.EndEvent(TeamPlayer, 308) == 1) then
							local rand = NLG.Rand(1,#v.prizeItem);
							Char.GiveItem(TeamPlayer, v.prizeItem[rand], v.prizeItem_count);
						end
					end
				end
			end
		end
	end
      end
      return
    end)

end
------------------------------------------------
-------��������
function boss_round_start(player, callback)

	tbl_win_user = {};
	tbl_duel_user = {};
	table.insert(tbl_duel_user,player);

	--��ʼս��
	tbl_UpIndex = {}
	battleindex = {}

	for k,v in pairs(NothingBoss) do
		if ( 1==v.weekday ) then
			local battleindex = Battle.PVE( player, player, nil, Pos[1][2], Pos[1][3], nil)
			Battle.SetWinEvent("./lua/Modules/nothingBoss.lua", "boss_round_callback", battleindex);
			nothingBossBattle={}
			table.insert(nothingBossBattle, battleindex);
		end
	end
end

function boss_round_callback(battleindex, player)

	local winside = Battle.GetWinSide(battleindex);
	local sideM = 0;

	--��ȡʤ����
	if (winside == 0) then
		sideM = 0;
	end
	if (winside == 1) then
		sideM = 10;
	end
	--��ȡʤ���������ָ�룬����վ��ǰ���ͺ�
	local w1 = Battle.GetPlayIndex(battleindex, 0 + sideM);
	local w2 = Battle.GetPlayIndex(battleindex, 5 + sideM);
	local ww = nil;

	--��ʤ����Ҽ����б�
	tbl_win_user = {}
	if ( Char.GetData(w1, %����_����%) >= %��������_��% ) then
		local ww = w1;
		table.insert(tbl_win_user, ww);
	elseif ( Char.GetData(w2, %����_����%) >= %��������_��% ) then
		local ww = w2;
		table.insert(tbl_win_user, ww);
	else
		local ww = nil;
	end

	local player = tbl_win_user[1];
	if (Char.EndEvent(player, 308) == 1) then
		for k,v in pairs(NothingBoss) do
			if ( 1==v.weekday ) then
				local rand = NLG.Rand(1,#v.rewardsItem);
				Char.GiveItem(player, v.rewardsItem[rand], v.rewardsItem_count);
				NLG.SystemMessage(-1,"��ϲ���: "..Char.GetData(player,CONST.����_����).." ӑ���ɹ�"..v.lordName.."��");
			end
		end
	end
	local PartyNum = Char.PartyNum(player);
	if (PartyNum>1) then
		for Slot=1,4 do
			local TeamPlayer = Char.GetPartyMember(player,Slot);
			if Char.IsDummy(TeamPlayer)==false then
				if (Char.EndEvent(TeamPlayer, 308) == 1) then
					for k,v in pairs(NothingBoss) do
						if ( 1==v.weekday ) then
							local rand = NLG.Rand(1,#v.rewardsItem);
							Char.GiveItem(TeamPlayer, v.rewardsItem[rand], v.rewardsItem_count);
						end
					end
				end
			end
		end
	end
	Battle.UnsetWinEvent(battleindex);
	nothingBossBattle ={};
end

--������������
function Module:OnbattleStartEventCallback(battleIndex)

	local playerCount = #NLG.GetPlayer();
	table.forEach(nothingBossBattle, function(e)
		if  e==battleIndex  then
			NLG.SystemMessage(-1,"[ϵ�y]���珊��Ѫ��������.������"..playerCount.."�����x5�f��Ѫ����");
		end
	end)
	for i = 10, 19 do
		local enemy = Battle.GetPlayer(battleIndex, i);
		local HP = playerCount * 50000;
		table.forEach(nothingBossBattle, function(e)
			if enemy>=0 and e==battleIndex  then
				if Char.GetData(enemy, CONST.����_ENEMY_ID)==900008 or Char.GetData(enemy, CONST.����_ENEMY_ID)==executeEnemy then
					Char.SetData(enemy, CONST.CHAR_���Ѫ, 1000000);
					Char.SetData(enemy, CONST.CHAR_Ѫ, HP);
					--NLG.SystemMessage(-1,"[ϵ�y]���珊��Ѫ����������");
				end
			end
		end)
	end
end
function Module:OnBeforeBattleTurnStartCommand(battleIndex)
	local Round = Battle.GetTurn(battleIndex);
	local playerCount = #NLG.GetPlayer() or 1;
	local HP = playerCount * 50000;
	for i = 10, 19 do
		local enemy = Battle.GetPlayer(battleIndex, i);
		table.forEach(nothingBossBattle, function(e)
		if Round==0 and enemy>=0 and e==battleIndex  then
			if Char.GetData(enemy, CONST.����_ENEMY_ID)==900008 or Char.GetData(enemy, CONST.����_ENEMY_ID)==executeEnemy  then
				Char.SetData(enemy, CONST.CHAR_���Ѫ, 1000000);     --Ѫ������100��
				Char.SetData(enemy, CONST.CHAR_Ѫ, HP);
			end
		elseif Round>0 and enemy>=0 and e==battleIndex  then
			if Char.GetData(enemy, CONST.����_ENEMY_ID)==900008 or Char.GetData(enemy, CONST.����_ENEMY_ID)==executeEnemy  then
				local Hp_10 = Char.GetData(enemy, CONST.CHAR_���Ѫ); 
				local Hp_5 = Char.GetData(enemy, CONST.CHAR_Ѫ);
				local Hp05 = Hp_5/Hp_10;

				Char.SetData(enemy, CONST.CHAR_���Ѫ, 1000000);     --Ѫ������100��
				Char.SetData(enemy, CONST.CHAR_Ѫ, Hp_5);
				if Hp05<=0.5 then
					Char.SetData(enemy, CONST.CHAR_����, transImage);
					Char.SetData(enemy, CONST.CHAR_������, 10000);
					Char.SetData(enemy, CONST.CHAR_������, 666);
					Char.SetData(enemy, CONST.CHAR_����, 10000);
					Char.SetData(enemy, CONST.CHAR_����, 10000);
					Char.SetData(enemy, CONST.CHAR_�ظ�, 66);
					Char.SetData(enemy, CONST.CHAR_��ɱ, 100);
					Char.SetData(enemy, CONST.CHAR_����, 100);
					Char.SetData(enemy, CONST.CHAR_����, 100);
					Char.SetData(enemy, CONST.CHAR_����, 70);
					--Char.SetData(enemy, CONST.����_ENEMY_HeadGraNo,108511);
				end
			end
		end
		--NLG.SystemMessage(-1,"[ϵ�y]���珊��Ѫ����������");
		end)
	end
end
function Module:OnAfterBattleTurnCommand(battleIndex)
	local Round = Battle.GetTurn(battleIndex);
	local leader0 = Battle.GetPlayer(battleIndex, 0);
	local leaderpet0 = Battle.GetPlayer(battleIndex, 5);
	local player = leader0
	local leaderpet = leaderpet0
	if Char.GetData(player, CONST.CHAR_����) == CONST.��������_�� then
		player = leader0
	else
		player = leaderpet
	end
	for i = 10, 19 do
		local enemy = Battle.GetPlayer(battleIndex, i);
		table.forEach(nothingBossBattle, function(e)
		if Round>=0 and enemy>=0 and e==battleIndex  then
			if Char.GetData(enemy, CONST.����_ENEMY_ID)==900008 or Char.GetData(enemy, CONST.����_ENEMY_ID)==executeEnemy  then
				local HP = Char.GetData(enemy,CONST.CHAR_Ѫ);
				Char.SetData(enemy, CONST.CHAR_���Ѫ, 1000000);
				Char.SetData(enemy, CONST.CHAR_Ѫ, HP);
				NLG.UpChar(enemy);
			end
		end
		end)
	end
end
--����ģʽ����ʩ��
function Module:OnEnemyCommandCallBack(battleIndex, side, slot, action)
      local Round = Battle.GetTurn(battleIndex);
      for i = 10, 19 do
         local enemy = Battle.GetPlayer(battleIndex, i);
         if enemy>= 0 then
            if Char.GetData(enemy, CONST.����_ENEMY_ID)==900008 or Char.GetData(enemy, CONST.����_ENEMY_ID)==executeEnemy then
                table.forEach(nothingBossBattle, function(e)
                if Round==5 and e==battleIndex  then
                          --SetCom(enemy, action, CONST.BATTLE_COM.BATTLE_COM_M_DEATH, 40, 8607);
                          SetCom(enemy, action, CONST.BATTLE_COM.BATTLE_COM_P_PARAMETER, 0, 350);
                elseif Round==10 and e==battleIndex  then
                          --SetCom(enemy, action, CONST.BATTLE_COM.BATTLE_COM_M_DEATH, 40, 8609);
                          SetCom(enemy, action, CONST.BATTLE_COM.BATTLE_COM_P_PARAMETER, 0, 358);
                elseif Round>=15 and e==battleIndex  then
                          --SetCom(enemy, action, CONST.BATTLE_COM.BATTLE_COM_M_DEATH, 40, 8659);
                          SetCom(enemy, action, CONST.BATTLE_COM.BATTLE_COM_P_PARAMETER, 0, 359);
                end
                end)
            end
         end
      end
end
function SetCom(charIndex, action, com1, com2, com3)
  if action == 0 then
    Char.SetData(charIndex, CONST.CHAR_BattleCom1, com1)
    Char.SetData(charIndex, CONST.CHAR_BattleCom2, com2)
    Char.SetData(charIndex, CONST.CHAR_BattleCom3, com3)
  else
    Char.SetData(charIndex, CONST.CHAR_BattleCom1, com1)
    Char.SetData(charIndex, CONST.CHAR_BattleCom2, com2)
    Char.SetData(charIndex, CONST.CHAR_BattleCom3, com3)
  end
end

function Module:OnBattleDodgeRateEvent(battleIndex, aIndex, fIndex, rate)
         --self:logDebug('OnBattleDodgeRateCallBack', battleIndex, aIndex, fIndex, rate)
         if Char.IsPlayer(fIndex) and Char.IsEnemy(aIndex) then
               local battleIndex = Char.GetBattleIndex(aIndex);
               local Round = Battle.GetTurn(battleIndex);
               if Char.GetData(aIndex, CONST.����_ENEMY_ID)==executeEnemy then
                   if (Round==5 or Round==10 or Round>=15)  then
                       rate = 0;
                       return rate
                   end
               end
         end
         return rate
end

function Module:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
      local Round = Battle.GetTurn(battleIndex);
      if Char.IsEnemy(charIndex) and Char.GetData(charIndex, CONST.CHAR_ENEMY_ID) == executeEnemy and Char.IsPlayer(defCharIndex) then
          if (math.fmod(Round, 3)==0 and math.random(1, 100)>=85) then
              local slot = Char.GetEmptyItemSlot(defCharIndex);
              local itemIndex, wslot = Char.GetWeapon(defCharIndex);
              if itemIndex >= 0 then
                  NLG.SystemMessage(defCharIndex,"[ϵ�y]"..Char.GetData(defCharIndex, CONST.CHAR_����).."������ж���ˣ�");
                  if slot < 0 then
                            damage = math.floor(damage * 1.5);
                  else
                            Char.MoveItem(defCharIndex, wslot, slot, -1);
                            NLG.UpChar(defCharIndex);
                  end
              end
          end
          return damage;
      end
  return damage;
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;