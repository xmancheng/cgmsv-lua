---ģ����
local Module = ModuleBase:createModule('legendBoss')

local EnemySet = {}
local BaseLevelSet = {}
local Pos = {}
local FTime = os.time()
local Setting = 0;
--���н���
--     ��(4)	��(2)	һ(0)	��(1)	��(3)
--     ʮ(9)	��(7)	��(5)	��(6)	��(8)
------------��սNPC����------------
EnemySet[1] = {900030, 0, 0, 900031, 900031, 900031, 900031, 900031, 0, 0}--0����û�й�
BaseLevelSet[1] = {250, 0, 0, 250, 250, 250, 250, 250, 0, 0}
Pos[1] = {"ʮ��ϯ",EnemySet[1],BaseLevelSet[1]}
EnemySet[2] = {900033, 0, 0, 900034, 900034, 900034, 900034, 900034, 0, 0}--0����û�й�
BaseLevelSet[2] = {250, 0, 0, 250, 250, 250, 250, 250, 0, 0}
Pos[2] = {"ʮһϯ",EnemySet[2],BaseLevelSet[2]}
EnemySet[3] = {900036, 0, 0, 900037, 900037, 900037, 900037, 900037, 0, 0}--0����û�й�
BaseLevelSet[3] = {250, 0, 0, 250, 250, 250, 250, 250, 0, 0}
Pos[3] = {"ʮϯ",EnemySet[3],BaseLevelSet[3]}
EnemySet[4] = {900039, 0, 0, 900040, 900040, 900040, 900040, 900040, 0, 0}--0����û�й�
BaseLevelSet[4] = {250, 0, 0, 250, 250, 250, 250, 250, 0, 0}
Pos[4] = {"��ϯ",EnemySet[4],BaseLevelSet[4]}
EnemySet[5] = {900042, 0, 0, 900043, 900043, 900043, 900043, 900043, 0, 0}--0����û�й�
BaseLevelSet[5] = {250, 0, 0, 250, 250, 250, 250, 250, 0, 0}
Pos[5] = {"��ϯ",EnemySet[5],BaseLevelSet[5]}
EnemySet[6] = {900045, 0, 0, 900046, 900046, 900046, 900046, 900046, 0, 0}--0����û�й�
BaseLevelSet[6] = {250, 0, 0, 250, 250, 250, 250, 250, 0, 0}
Pos[6] = {"��ϯ",EnemySet[6],BaseLevelSet[6]}
------------------------------------------------------
--��������
local Pts= 70206;                                    --��Ů��ƻ��
local LegendBoss = {
      { lordNum=1, keyItem=70241, lordName="����}���12ϯ", startImage=105040, transImage = 107912, waitingArea={map=1000,X=233,Y=112}, warpArea={map=25013,X=35,Y=15},
        rewardsItem={71041,71037,71038}, rewardsItem_count=1, prizeItem={70202,70203,70204,70205,70206,72000}, prizeItem_count=1},
      { lordNum=2, keyItem=70242, lordName="����}���11ϯ", startImage=105272, transImage = 110599, waitingArea={map=1000,X=231,Y=112}, warpArea={map=25013,X=35,Y=15},
        rewardsItem={71041,71037,71038}, rewardsItem_count=1, prizeItem={70202,70203,70204,70205,70206,72000}, prizeItem_count=1},
      { lordNum=3, keyItem=70243, lordName="����}���10ϯ", startImage=105112, transImage = 101922, waitingArea={map=1000,X=229,Y=112}, warpArea={map=25013,X=35,Y=15},
        rewardsItem={71041,71037,71038}, rewardsItem_count=1, prizeItem={70202,70203,70204,70205,70206,72000}, prizeItem_count=1},
      { lordNum=4, keyItem=70244, lordName="����}���9ϯ", startImage=105303, transImage = 107103, waitingArea={map=1000,X=227,Y=112}, warpArea={map=25013,X=35,Y=15},
        rewardsItem={71041,71037,71038}, rewardsItem_count=1, prizeItem={70202,70203,70204,70205,70206,72000}, prizeItem_count=1},
      { lordNum=5, keyItem=70245, lordName="����}���8ϯ", startImage=105091, transImage = 107904, waitingArea={map=1000,X=225,Y=112}, warpArea={map=25013,X=35,Y=15},
        rewardsItem={71041,71037,71038}, rewardsItem_count=1, prizeItem={70202,70203,70204,70205,70206,72000}, prizeItem_count=1},
      { lordNum=6, keyItem=70246, lordName="����}���7ϯ", startImage=105523, transImage = 104840, waitingArea={map=1000,X=223,Y=112}, warpArea={map=25013,X=35,Y=15},
        rewardsItem={71041,71037,71038}, rewardsItem_count=1, prizeItem={70202,70203,70204,70205,70206,72000}, prizeItem_count=1},
}
local tbl_duel_user = {};			--��ǰ������ҵ��б�
local tbl_win_user = {};
local legendBossBattle = {}
tbl_LegendBossNPCIndex = tbl_LegendBossNPCIndex or {}
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
  self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self))
  self:regCallback('LoopEvent', Func.bind(self.LegendBoss_LoopEvent,self))
  for k,v in pairs(LegendBoss) do
   if tbl_LegendBossNPCIndex[k] == nil then
    local LegendBossNPC = self:NPC_createNormal(v.lordName, v.startImage, { map = v.waitingArea.map, x = v.waitingArea.X, y = v.waitingArea.Y, direction = 5, mapType = 0 })
    tbl_LegendBossNPCIndex[k] = LegendBossNPC
    self:NPC_regWindowTalkedEvent(tbl_LegendBossNPCIndex[k], function(npc, player, _seqno, _select, _data)
	local cdk = Char.GetData(player,CONST.����_CDK);
	local seqno = tonumber(_seqno)
	local select = tonumber(_select)
	local data = tonumber(_data)
    end)
    self:NPC_regTalkedEvent(tbl_LegendBossNPCIndex[k], function(npc, player)
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
               --���fBOSS
	local playerName = Char.GetData(player,CONST.CHAR_����);
	local partyname = playerName .. "���";
	local playerLv = Char.GetData(player,CONST.CHAR_�ȼ�);
	if playerLv<=100 then
		NLG.SystemMessage(player,"[ϵ�y]ӑ�����h��L�ȼ�Ҫ100����");
		return;
	end

	--local Target_X = Char.GetData(npc, CONST.CHAR_X)  --��ͼx
	--local Target_Y = Char.GetData(npc, CONST.CHAR_Y)  --��ͼy
	local bossImage = Char.GetData(npc,CONST.����_����);
	for k,v in pairs(LegendBoss) do
		if ( k==v.lordNum and bossImage==v.startImage ) then
			table.insert(tbl_duel_user,player);
			table.insert(tbl_duel_user,npc);
			boss_round_start(player, npc, boss_round_callback);

			--Char.DelItem(player, v.keyItem, 1);
                                                            --local slot = Char.FindItemId(player, v.keyItem);
                                                            --local item_indexA = Char.GetItemIndex(player,slot);
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
  end

end
------------------------------------------------
-------��������
--ָ������ѭ��
function Module:handleTalkEvent(charIndex,msg,color,range,size)
	if (msg=="[nr legend on]") then
		local cdk = Char.GetData(charIndex,CONST.����_CDK);
		if (cdk == "123456") then
			for k,v in pairs(LegendBoss) do
				Char.SetLoopEvent('./lua/Modules/legendBoss.lua','LegendBoss_LoopEvent',tbl_LegendBossNPCIndex[k],1000);
			end
			NLG.SystemMessage(charIndex, "[ϵ�y]���f���ɉ��_�š�");
			NLG.UpChar(charIndex);
			return 0;
		end
	end
	return 1;
end
--ת��
function LegendBoss_LoopEvent(LegendBossNPC)
	if (os.date("%X",os.time())=="00:00:01") then
		NLG.SystemMessage(-1,"[ϵ�y]���f���ɉ����F��(218,88)��");
		for k,v in pairs(LegendBoss) do
			local bossImage = Char.GetData(LegendBossNPC,CONST.����_����);
			if ( bossImage==v.startImage ) then
				Char.SetData(LegendBossNPC,CONST.����_X, v.warpArea.X);
				Char.SetData(LegendBossNPC,CONST.����_Y, v.warpArea.Y);
				Char.SetData(LegendBossNPC,CONST.����_��ͼ, v.warpArea.map);
				NLG.UpChar(LegendBossNPC);
			end
		end
	elseif (os.date("%X",os.time())=="23:59:59")  then
		for k,v in pairs(LegendBoss) do
			Char.SetData(tbl_LegendBossNPCIndex[k],CONST.����_X, v.waitingArea.X);
			Char.SetData(tbl_LegendBossNPCIndex[k],CONST.����_Y, v.waitingArea.Y);
			Char.SetData(tbl_LegendBossNPCIndex[k],CONST.����_��ͼ, v.waitingArea.map);
			NLG.UpChar(tbl_LegendBossNPCIndex[k]);
		end
	end
end

function boss_round_start(player, npc, callback)

	--local npc = tbl_duel_user[2];
	tbl_win_user = {};
	tbl_duel_user = {};
	table.insert(tbl_duel_user,player);
	table.insert(tbl_duel_user,npc);

	--��ʼս��
	tbl_UpIndex = {}
	battleindex = {}

	for k,v in pairs(LegendBoss) do
		local bossImage = Char.GetData(npc,CONST.����_����);
		if ( k==v.lordNum and bossImage==v.startImage ) then
			local battleindex = Battle.PVE( player, player, nil, Pos[k][2], Pos[k][3], nil)
			Battle.SetWinEvent("./lua/Modules/legendBoss.lua", "boss_round_callback", battleindex);
			legendBossBattle={}
			table.insert(legendBossBattle, battleindex);
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
	local npc = tbl_duel_user[2];
	if (Char.EndEvent(player, 308) == 1) then
		for k,v in pairs(LegendBoss) do
			local bossImage = Char.GetData(npc,CONST.����_����);
			if ( k==v.lordNum and bossImage==v.startImage ) then
                                                                        --local slot = Char.FindItemId(player, v.keyItem);
                                                                        --local item_indexA = Char.GetItemIndex(player,slot);
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
					for k,v in pairs(LegendBoss) do
						local bossImage = Char.GetData(npc,CONST.����_����);
						if ( k==v.lordNum and bossImage==v.startImage ) then
							local rand = NLG.Rand(1,#v.rewardsItem);
							Char.GiveItem(TeamPlayer, v.rewardsItem[rand], v.rewardsItem_count);
						end
					end
				end
			end
		end
	end
	for k,v in pairs(LegendBoss) do
		local bossImage = Char.GetData(npc,CONST.����_����);
		if ( bossImage==v.startImage ) then
			Char.SetData(npc,CONST.����_X, v.waitingArea.X);
			Char.SetData(npc,CONST.����_Y, v.waitingArea.Y);
			Char.SetData(npc,CONST.����_��ͼ, v.waitingArea.map);
			NLG.UpChar(npc);
		end
	end
	Battle.UnsetWinEvent(battleindex);
	legendBossBattle ={};
end

--������������
function Module:OnbattleStartEventCallback(battleIndex)

	local playerCount = #NLG.GetPlayer();
	table.forEach(legendBossBattle, function(e)
		if  e==battleIndex  then
			NLG.SystemMessage(-1,"[ϵ�y]���f���ɉ�Ѫ��������.������"..playerCount.."�����x5�f��Ѫ����");
		end
	end)
	for i = 10, 19 do
		local enemy = Battle.GetPlayer(battleIndex, i);
		local HP = playerCount * 50000;
		table.forEach(legendBossBattle, function(e)
			if enemy>=0 and e==battleIndex  then
				if (Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900030 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900033 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900036 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900039 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900042 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900045) then
					Char.SetData(enemy, CONST.CHAR_���Ѫ, 1000000);
					Char.SetData(enemy, CONST.CHAR_Ѫ, HP);
					--NLG.SystemMessage(-1,"[ϵ�y]���f���ɉ�Ѫ����������");
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
		table.forEach(legendBossBattle, function(e)
		if Round==0 and enemy>=0 and e==battleIndex  then
			if (Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900030 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900033 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900036 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900039 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900042 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900045) then
				Char.SetData(enemy, CONST.CHAR_���Ѫ, 1000000);     --Ѫ������100��
				Char.SetData(enemy, CONST.CHAR_Ѫ, HP);
			end
		elseif Round>0 and enemy>=0 and e==battleIndex  then
			if (Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900030 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900033 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900036 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900039 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900042 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900045) then
				local Hp_10 = Char.GetData(enemy, CONST.CHAR_���Ѫ); 
				local Hp_5 = Char.GetData(enemy, CONST.CHAR_Ѫ);
				local Hp05 = Hp_5/Hp_10;

				Char.SetData(enemy, CONST.CHAR_���Ѫ, 1000000);     --Ѫ������100��
				Char.SetData(enemy, CONST.CHAR_Ѫ, Hp_5);
				if Hp05<=0.5 then
					for k,v in pairs(LegendBoss) do
						if ( k==v.lordNum and Char.GetData(enemy, CONST.CHAR_����)==v.startImage ) then
							Char.SetData(enemy, CONST.CHAR_����, v.transImage);
							--Char.SetData(enemy, CONST.CHAR_����, v.transImage);
							--Char.SetData(enemy, CONST.CHAR_ԭ��, v.transImage);
							--Char.SetData(enemy, CONST.CHAR_ԭʼͼ��, v.transImage);
							NLG.UpChar(enemy);
						end
					end
					Char.SetData(enemy, CONST.CHAR_������, 10000);
					Char.SetData(enemy, CONST.CHAR_������, 666);
					Char.SetData(enemy, CONST.CHAR_����, 666);
					Char.SetData(enemy, CONST.CHAR_����, 10000);
					Char.SetData(enemy, CONST.CHAR_�ظ�, 66);
					Char.SetData(enemy, CONST.CHAR_��ɱ, 70);
					Char.SetData(enemy, CONST.CHAR_����, 70);
					Char.SetData(enemy, CONST.CHAR_����, 70);
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
		table.forEach(legendBossBattle, function(e)
		if Round>=0 and enemy>=0 and e==battleIndex  then
			if (Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900030 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900033 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900036 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900039 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900042 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900045) then
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
            if (Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900030 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900033 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900036 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900039 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900042 or Char.GetData(enemy, CONST.CHAR_ENEMY_ID)==900045) then
                table.forEach(legendBossBattle, function(e)
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
               if (Char.GetData(aIndex, CONST.CHAR_ENEMY_ID)==900030 or Char.GetData(aIndex, CONST.CHAR_ENEMY_ID)==900033 or Char.GetData(aIndex, CONST.CHAR_ENEMY_ID)==900036 or Char.GetData(aIndex, CONST.CHAR_ENEMY_ID)==900039 or Char.GetData(aIndex, CONST.CHAR_ENEMY_ID)==900042 or Char.GetData(aIndex, CONST.CHAR_ENEMY_ID)==900045) then
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
      if Char.IsEnemy(charIndex) and Char.IsPlayer(defCharIndex) then
        if (Char.GetData(charIndex, CONST.CHAR_ENEMY_ID)==900031 or Char.GetData(charIndex, CONST.CHAR_ENEMY_ID)==900034 or Char.GetData(charIndex, CONST.CHAR_ENEMY_ID)==900037 or Char.GetData(charIndex, CONST.CHAR_ENEMY_ID)==900040 or Char.GetData(charIndex, CONST.CHAR_ENEMY_ID)==900043 or Char.GetData(charIndex, CONST.CHAR_ENEMY_ID)==900046) then
          if (math.fmod(Round, 3)==0 and math.random(1, 100)>=85) then
              local slot = Char.GetEmptyItemSlot(defCharIndex);
              local itemIndex, wslot = Char.GetWeapon(defCharIndex);
              if itemIndex >= 0 then
                  NLG.SystemMessage(defCharIndex,"[ϵ�y]"..Char.GetData(defCharIndex, CONST.CHAR_����).."������ж���ˣ�");
                  if slot < 0 then
                            damage = math.floor(damage * 1.5);
                  else
                            Char.MoveItem(defCharIndex, wslot, slot, -1);
                            Char.SetData(defCharIndex, CONST.CHAR_BattleCom1, CONST.BATTLE_COM.BATTLE_COM_ATTACK);
                            Char.SetData(defCharIndex, CONST.CHAR_BattleCom2, 10);
                            Char.SetData(defCharIndex, CONST.CHAR_BattleCom3, -1);
                            NLG.UpChar(defCharIndex);
                  end
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