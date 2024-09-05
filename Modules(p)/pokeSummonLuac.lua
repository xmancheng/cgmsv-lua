---ģ����
local Module = ModuleBase:createModule('pokeSummonLuac')

--�������
local allyb = 0
local wanjia = {}--��ұ�
for bbb = 0,100 do
	wanjia[bbb] = {}
	wanjia[bbb][0] = 0--aiͳ��
	for ccc = 1,2 do
		wanjia[bbb][ccc] = -1
	end
end

--�Զ�ս��
local battleData = {};
local zttj0 = 0;
local zttj1 = 0;

function Module:yboffline(player)--�����������Լ��ٻ���ai
	if (wanjia[player]~=nil) then
		for xxqk = 1,#wanjia[player] do
			if wanjia[player][xxqk] > 0 then
				Char.DelDummy(wanjia[player][xxqk])
			end
		end
		wanjia[player][0] = 0
		Char.EndEvent(player,17,0);
	end
end

--local hbsp = {900330,900333}--��Ʒ

local mfsj = {
	{9213,9212,9211,9210,9209,9208,9207,9206,9205,9201},--1-9��ˮ��10��ˮ��
	{9222,9221,9220,9219,9218,9217,9216,9215,9214,9202},--1-9ˮ��10ˮˮ��
	{9231,9230,9229,9228,9227,9226,9225,9224,9223,9203},--1-9��硢10��ˮ��
	{9240,9239,9238,9237,9236,9235,9234,9233,9232,9204} --1-9��ء�10��ˮ��
}

--- ����ģ�鹳��
function Module:onLoad()

  self:logInfo('load')
  --local fnpc = self:NPC_createNormal('�������', 101003, { x = 38, y = 33, mapType = 0, map = 777, direction = 6 });
  self:regCallback('BeforeBattleTurnEvent', Func.bind(self.handleBattleAutoCommand, self))
  self:regCallback('BattleOverEvent', Func.bind(self.battleOverEventCallback, self))
  self:regCallback('ScriptCallEvent', function(npcIndex, playerIndex, text, msg)
    self:logDebugF('npcIndex: %s, playerIndex: %s, text: %s, msg: %s', npcIndex, playerIndex, text, msg)
    self:regCallback("LogoutEvent", Func.bind(self.yboffline, self))
    
	player = playerIndex
	npc = npcIndex

	id = Char.GetData(player,%����_CDK%)
	name = Char.GetData(player,%����_����%)
	lv = Char.GetData(player, %����_�ȼ�%)
	Target_MapId = Char.GetData(player,CONST.CHAR_MAP)--��ͼ����
	Target_FloorId = Char.GetData(player,CONST.CHAR_��ͼ)--��ͼ���
	Target_X = Char.GetData(player,CONST.CHAR_X)--��ͼx
	Target_Y = Char.GetData(player,CONST.CHAR_Y)--��ͼy

	if text == 'һ���ٻ�' then
		for csdd = 1,2 do
			if Char.PartyNum(wanjia[player][csdd]) == -1 then
				Battle.ExitBattle(wanjia[player][csdd]);
				Char.Warp(wanjia[player][csdd], Target_MapId, Target_FloorId, Target_X, Target_Y);
				Char.JoinParty(wanjia[player][csdd],player);
			end
			local pzw = Char.GetData(player,CONST.CHAR_λ��)
			if pzw == 1 then 
				if Char.IsDummy(Char.GetPartyMember(player,1)) then
					Char.SetData(Char.GetPartyMember(player,1),CONST.CHAR_λ��,0);
				end
				if Char.IsDummy(Char.GetPartyMember(player,2)) then
					Char.SetData(Char.GetPartyMember(player,2),CONST.CHAR_λ��,0);
				end
				if Char.IsDummy(Char.GetPartyMember(player,3)) then
					Char.SetData(Char.GetPartyMember(player,3),CONST.CHAR_λ��,1);
				end
				if Char.IsDummy(Char.GetPartyMember(player,4)) then
					Char.SetData(Char.GetPartyMember(player,4),CONST.CHAR_λ��,1);
				end
			elseif pzw == 0 then
				if Char.IsDummy(Char.GetPartyMember(player,1)) then
					Char.SetData(Char.GetPartyMember(player,1),CONST.CHAR_λ��,1);
				end
				if Char.IsDummy(Char.GetPartyMember(player,2)) then
					Char.SetData(Char.GetPartyMember(player,2),CONST.CHAR_λ��,1);
				end
				if Char.IsDummy(Char.GetPartyMember(player,3)) then
					Char.SetData(Char.GetPartyMember(player,3),CONST.CHAR_λ��,0);
				end
				if Char.IsDummy(Char.GetPartyMember(player,4)) then
					Char.SetData(Char.GetPartyMember(player,4),CONST.CHAR_λ��,0);
				end
			end
		end
		if wanjia[player][0] > 3 then
			NLG.SystemMessage(player, '������ɫǰ�������ٻ������Ըı�������͡�' )
		elseif allyb > 100 then
			NLG.SystemMessage(player, '��ǰ��·�˿ڱ������޷����Ӷ���ˡ�' )
		else
		for num = 1,2 do
			local petIndex1 = Char.GetPet(player,num-1)
			if Char.GetData(petIndex1, CONST.PET_DepartureBattleStatus) ~= CONST.PET_STATE_ս�� then
				if wanjia[player][num] <= 0 and petIndex1 >= 0 then
					local charIndex1 = Char.CreateDummy()--����aiӶ��
					wanjia[player][0] = wanjia[player][0] + 1--ͳ��aiӶ������
					--print("��ţ�"..charIndex1.."")
					wanjia[player][num] = charIndex1
					local TL = Pet.GetArtRank(petIndex1,CONST.PET_���);
					local GJ = Pet.GetArtRank(petIndex1,CONST.PET_����);
					local FY = Pet.GetArtRank(petIndex1,CONST.PET_ǿ��);
					local MJ = Pet.GetArtRank(petIndex1,CONST.PET_����);
					local MF = Pet.GetArtRank(petIndex1,CONST.PET_ħ��);
					Char.SetData(charIndex1, CONST.CHAR_����, TL);
					Char.SetData(charIndex1, CONST.CHAR_����, GJ);
					Char.SetData(charIndex1, CONST.CHAR_����, FY);
					Char.SetData(charIndex1, CONST.CHAR_����, MJ);
					Char.SetData(charIndex1, CONST.CHAR_����, MF);

					Char.SetData(charIndex1, CONST.CHAR_X, Char.GetData(player, CONST.CHAR_X));
					Char.SetData(charIndex1, CONST.CHAR_Y, Char.GetData(player, CONST.CHAR_Y));
					Char.SetData(charIndex1, CONST.CHAR_��ͼ, Char.GetData(player, CONST.CHAR_��ͼ));
					Char.SetData(charIndex1, CONST.CHAR_����, Char.GetData(petIndex1,CONST.CHAR_����));
					Char.SetData(charIndex1, CONST.CHAR_��ͼ����, Char.GetData(player,CONST.CHAR_��ͼ����));
					Char.SetData(charIndex1, CONST.CHAR_����, Char.GetData(petIndex1,CONST.CHAR_����));
					Char.SetData(charIndex1, CONST.CHAR_ԭ��, Char.GetData(petIndex1,CONST.CHAR_ԭ��));
					Char.SetData(charIndex1, CONST.CHAR_ԭʼͼ��, Char.GetData(petIndex1,CONST.CHAR_ԭʼͼ��));
					--print('charIndex1', charIndex1)
					--print(player)
					Char.SetData(charIndex1, CONST.CHAR_����, Char.GetData(petIndex1,CONST.CHAR_����));
					Char.SetData(charIndex1, CONST.CHAR_����, Char.GetData(petIndex1,CONST.CHAR_����));
					Char.SetData(charIndex1, CONST.CHAR_ǿ��, Char.GetData(petIndex1,CONST.CHAR_ǿ��));
					Char.SetData(charIndex1, CONST.CHAR_�ٶ�, Char.GetData(petIndex1,CONST.CHAR_�ٶ�));
					Char.SetData(charIndex1, CONST.CHAR_ħ��, Char.GetData(petIndex1,CONST.CHAR_ħ��));
					Char.SetData(charIndex1, CONST.CHAR_�ȼ�, Char.GetData(petIndex1,CONST.CHAR_�ȼ�));
					Char.SetData(charIndex1, CONST.CHAR_����, Char.GetData(petIndex1,CONST.CHAR_����));
					NLG.UpChar(charIndex1);
					local dsj= Char.GetData(petIndex1,CONST.CHAR_������);
					local ssj= Char.GetData(petIndex1,CONST.CHAR_ˮ����);
					local hsj= Char.GetData(petIndex1,CONST.CHAR_������);
					local fsj= Char.GetData(petIndex1,CONST.CHAR_������);
					if dsj>0 and ssj>0 then
						mf=1;
						sj=math.floor(dsj/10);
					elseif ssj>0 and hsj>0 then
						mf=2;
						sj=math.floor(ssj/10);
					elseif hsj>0 and fsj>0 then
						mf=3;
						sj=math.floor(hsj/10);
					elseif fsj>0 and dsj>0 then
						mf=4;
						sj=math.floor(fsj/10);
					else
						mf=math.random(1,4);
						sj=10;
					end
					Char.GiveItem(charIndex1, mfsj[mf][sj], 1);
					--Char.GiveItem(charIndex1, hbsp[1], 1);--��Ʒ1
					--Char.GiveItem(charIndex1, hbsp[2], 1);--��Ʒ2
					Char.MoveItem(charIndex1, 8, CONST.EQUIP_ˮ��, -1);
					--Char.MoveItem(charIndex1, 9, CONST.EQUIP_����1, -1);
					--Char.MoveItem(charIndex1, 10, CONST.EQUIP_����2, -1);
					--Char.GiveItem(charIndex1, 18196, 1);--ʵ��ҩ
					--Char.GiveItem(charIndex1, 18315, 1);--���
					Char.GiveItem(charIndex1, 900202, 1);--��������������
					Char.GiveItem(charIndex1, 900203, 1);--��������������

					Char.SetData(charIndex1, CONST.CHAR_Ѫ, Char.GetData(petIndex1,CONST.CHAR_���Ѫ));
					Char.SetData(charIndex1, CONST.CHAR_ħ, Char.GetData(petIndex1,CONST.CHAR_���ħ));
					Char.SetData(charIndex1, CONST.CHAR_����, Char.GetData(petIndex1,CONST.CHAR_����));
					Char.SetData(charIndex1, CONST.CHAR_��˯, Char.GetData(petIndex1,CONST.CHAR_��˯));
					Char.SetData(charIndex1, CONST.CHAR_��ʯ, Char.GetData(petIndex1,CONST.CHAR_��ʯ));
					Char.SetData(charIndex1, CONST.CHAR_����, Char.GetData(petIndex1,CONST.CHAR_����));
					Char.SetData(charIndex1, CONST.CHAR_����, Char.GetData(petIndex1,CONST.CHAR_����));
					Char.SetData(charIndex1, CONST.CHAR_����, Char.GetData(petIndex1,CONST.CHAR_����));
					Char.SetData(charIndex1, CONST.CHAR_��ɱ, Char.GetData(petIndex1,CONST.CHAR_��ɱ));
					Char.SetData(charIndex1, CONST.CHAR_����, Char.GetData(petIndex1,CONST.CHAR_����));
					Char.SetData(charIndex1, CONST.CHAR_����, Char.GetData(petIndex1,CONST.CHAR_����));
					Char.SetData(charIndex1, CONST.CHAR_����, Char.GetData(petIndex1,CONST.CHAR_����));

					Char.SetData(charIndex1, CONST.CHAR_ְҵ, 1);      --����
					Char.SetData(charIndex1, CONST.CHAR_ְ��ID, 0);  --����
					Char.SetData(charIndex1, CONST.CHAR_ְ��, 3);

					Char.SetData(charIndex1, CONST.CHAR_���, Char.GetData(petIndex1,CONST.PET_PetID));

					Char.JoinParty(charIndex1, player);
				else
					--NLG.SystemMessage(player, '���ﲻ���ڡ�' )
				end
			else
				--NLG.SystemMessage(player, 'ս��״̬�����޷��ٻ���' )
			end
		end
		--Char.EndEvent(player,17,1);  --����³���ż��ƺ�
		end
	end
	if text == 'һ�����' then
		for xxqk = 1,#wanjia[player] do
			if wanjia[player][xxqk] > 0 then
				Char.DelDummy(wanjia[player][xxqk])
				wanjia[player][xxqk] = -1
			end
		end
		wanjia[player][0] = 0
		--Char.EndEvent(player,17,0);
	end

    return -1;
  end)

end

--�����λ���Զ�ս��
function Module:battleOverEventCallback(battleIndex)
	local player = Battle.GetPlayer(battleIndex, 0);
	local player5 = Battle.GetPlayer(battleIndex, 5);
	battleData[battleIndex] = nil;
end

function Module:handleBattleAutoCommand(battleIndex)
	local leader0 = Battle.GetPlayer(battleIndex, 0)
	local leaderpet0 = Battle.GetPlayer(battleIndex, 5)
	local leader1 = Battle.GetPlayer(battleIndex, 10)
	local leaderpet1 = Battle.GetPlayer(battleIndex, 15)
	local playersd0 = 2
	local playersd1 = 2
	for i = 0, 4 do
		local charIndex = Battle.GetPlayer(battleIndex, i);
		local petIndex = Battle.GetPlayer(battleIndex, math.fmod(i + 5, 10));
		if charIndex >= 0 and petIndex >= 0 then
			playersd0 = 1
		end
	end
	for i = 10, 14 do
		local charIndex = Battle.GetPlayer(battleIndex, i);
		local petIndex = Battle.GetPlayer(battleIndex, math.fmod(i - 5, 10)+10);
		if charIndex >= 0 and petIndex >= 0 then
			playersd1 = 1
		end
	end
	local battleturn = Battle.GetTurn(battleIndex)
	if battleData[battleIndex] == battleturn then
		return
	end
	battleData[battleIndex] = battleturn;
	local hasAutoBattle = false;
--	self:logDebug('handleBattleAutoCommand', battleIndex)
--	self:logDebug('battleturn', battleturn);
	local hasPlayer = false;
	for i = 0, 19 do
		local charIndex = Battle.GetPlayer(battleIndex, i);
		local petIndex = Battle.GetPlayer(battleIndex, math.fmod(i + 5, 10));
		if charIndex >= 0 then
			if Char.IsDummy(charIndex) then
				local sidetable = {{10,40,41,30,20,zswz0},{0,41,40,30,20,zswz1}}
				local charside = 1
				local ybside = Char.GetData(charIndex,%����_ս��Side%)
				local playersd = playersd0
				local leader = leader0
				local leaderpet = leaderpet0
				local chtj = chtj0
				local zstj = zstj0
				local zttj = zttj0
				local leader5 = leader
				if ybside == 1 then
					charside = 2
					playersd = playersd1
					leader = leader1
					leaderpet = leaderpet1
					petIndex = Battle.GetPlayer(battleIndex, math.fmod(i - 5, 10)+10)
					chtj = chtj1
					zstj = zstj1
					zttj = zttj1
				end
				if Char.GetData(leader, CONST.CHAR_����) == CONST.��������_�� then
					leader5 = leader
				else
					leader5 = leaderpet
				end
				if leader5 < 0 then
					Battle.ActionSelect(charIndex, CONST.BATTLE_COM.BATTLE_COM_ESCAPE, -1, -1);
				else
--					self:logDebug('auto battle', charIndex, petIndex);
					hasAutoBattle = true;
					local rlv = Char.GetData(leader5,%����_�ȼ�%)

					local yblv = math.floor(rlv/10) + 1
					local cwlv = math.floor(rlv/20) + 1
					if rlv >= 100 then	yblv = 10;cwlv = 5;	end
					local ybjn = Battle.IsWaitingCommand(charIndex);

					local hp = Char.GetData(charIndex,%����_Ѫ%);
					local hp2 = Char.GetData(petIndex,%����_Ѫ%);
					local hpMax = Char.GetData(charIndex,%����_���Ѫ%);
					local hpMax2 = Char.GetData(petIndex,%����_���Ѫ%);
					local mp = Char.GetData(charIndex,%����_ħ%);
					local mp2 = Char.GetData(petIndex,%����_ħ%);
--���������AI
					if Char.GetData(charIndex,%����_ս��%) == 1 then
						Battle.ActionSelect(charIndex, CONST.BATTLE_COM.BATTLE_COM_NONE, -1, -1);
					end
					if ybjn and Char.ItemNum(charIndex,900202) > 0 and Char.ItemNum(charIndex,900203) > 0 then     --��������������������
						local ActionCard = {{CONST.BATTLE_COM.BATTLE_COM_ATTACK, sidetable[charside][1], -1},{CONST.BATTLE_COM.BATTLE_COM_P_CONSENTRATION, -1, 1206}}
						local ACS = 1;
						if (hp <= hpMax/3) then
							ACS = 2;
						end
						Battle.ActionSelect(charIndex,ActionCard[ACS][1],ActionCard[ACS][2],ActionCard[ACS][3]);
					end
				end
				if petIndex < 0 then
					Battle.ActionSelect(charIndex, CONST.BATTLE_COM.BATTLE_COM_ATTACK, sidetable[charside][1], -1);
				else
					Battle.ActionSelect(petIndex,CONST.BATTLE_COM.BATTLE_COM_ATTACK, sidetable[charside][1], -1);
				end
			else
				hasPlayer = true;
			end
		end
	end
--	self:logDebug(hasAutoBattle, hasPlayer, not hasPlayer)
	return hasAutoBattle;
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
