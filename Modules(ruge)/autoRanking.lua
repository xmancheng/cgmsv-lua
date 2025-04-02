local Module = ModuleBase:createModule('autoRanking')

local AutoMenus = {
  { "����Ӗ���Ҍ���" },
  { "�^���������˔�" },
  { "�M�Ќ������^��" },
}

---�����������޸�
local FTime = os.time()
local Setting = 0;
local EnterMap = {25290,25,24};
local ExitMap = {25291,24,25};
local LobbyMap = {7351,25,29};
local Enter = 0;
local Number = 0;
local Finish = 0;

local tbl_playerautoranking = {}
local PartyMember = {}

--��������
tbl_swjjc_goinfo = {};
tbl_win_user = {};			--��ǰ����ʤ����ҵ��б�
tbl_duel_user = {};			--��ǰ������ҵ��б�
tbl_trainer = {};
tbl_swjjc_begin = {};
tbl_swjjc_time = {};
tbl_swjjc_setting =
{
	start = 0;
	round_count =1;
	first_round_user_max = 20; 	--��һ������ѡ��������
	this_user_WinFunc = nil;
	WinFunc = nil;				--��ǰ�����������ս��������Ļص�����
};

--��������
round_count = "round_count";
create_battle_count = "create_battle_count";
create_battle_count_bak = "create_battle_count_bak";
tbl_swjjc_goinfo[round_count] = 1;
tbl_swjjc_goinfo[create_battle_count] = 0;
tbl_swjjc_goinfo[create_battle_count_bak] = 0;
begin = "begin";
Loopbegin = "Loopbegin";
time = "time";
tbl_swjjc_begin[begin] = true;
tbl_swjjc_begin[Loopbegin] = false;
tbl_swjjc_time[time] = {};

-------------------------------------------------------------------------
--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self));
  self:regCallback('LoopEvent', Func.bind(self.TrainerBattle_LoopEvent,self));
  self:regCallback('LoopEvent', Func.bind(self.swjjcStartNpcLoopEvent,self));
  rankingNPC = self:NPC_createNormal('���ɉ�Ӗ���Ҍ���', 11394, { map = 7351, x = 26, y = 37, direction = 4, mapType = 0 })
  Char.SetData(rankingNPC,CONST.����_ENEMY_PetFlg+2,0);
  Char.SetLoopEvent('lua/Modules/autoRanking.lua','TrainerBattle_LoopEvent',rankingNPC, 1000);
  self:NPC_regWindowTalkedEvent(rankingNPC, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.����_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if seqno == 1 then
     if data == 1 then  ----������ս
       if (Enter==0) then
         NLG.SystemMessage(player,"[�������]��������r�g��ÿ��20:00-20:29��");
         return;
       end
       if (Setting==1 or Setting==2 or Setting==3 or Setting==-1) then
         NLG.SystemMessage(player,"[�������]Ӗ���Ҍ����ѽ��_ʼ��Ո�ȴ����Ո�����");
         return;
       end
       if (tbl_playerautoranking[cdk]~=nil) then
         Char.Warp(player,0,EnterMap[1],EnterMap[2],EnterMap[3]);
         --NLG.SystemMessage(player,"[�������]���ѽ������^����Ӗ���Ҍ���");
         return;
       end
       if (tbl_playerautoranking[cdk]==nil) then
         local msg = "\\n@cӖ���Ҍ����f��\\n"
                  .. "\\nÿ�����ϰ��c�M�Ј���\\n"
                  .. "\\n��С�r������Ԅ��䌦\\n"
                  .. "\\n��܊�@���ʯ������\\n"
                  .. "\\n���������߫@�ý���\\n";
         NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 11, msg);
       end
     end

     if data == 2 then  ----�ۿ���������&ִ��
       if (Setting==0) then
         NLG.SystemMessage(player,"[�������]�F���ѽ��� ".. Number .." ꠈ����ɹ���");
         return;
       else
         NLG.SystemMessage(player,"[�������]Ӗ���Ҍ������_ʼՈ���ᣡ");
         return;
       end
     end

     if data == 3 then  ----���г����ս
       if (Setting==1 or Setting==2 or Setting==3 or Setting==-1) then
           local msg = "3\\n@c������ِ���^��\\n"
                     .."\\n�����T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n";
           if (tbl_duel_user~=nil) then
             for i = 1, #tbl_duel_user do
               local duelplayer = tbl_duel_user[i];
               local duelplayerName = Char.GetData(duelplayer,CONST.����_����);
               msg = msg .. duelplayerName .. "��VS��".. "\\n"
             end
           end
           NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, CONST.��ť_�ر�, 31, msg);
       else
         NLG.SystemMessage(player,"[�������]Ӗ���Ҍ�����δ�_ʼ��");
         return;
       end
     end

    end
    ------------------------------------------------------------
    if seqno == 11 then  ----������սִ��
     if select == 4 then
       local playerName = Char.GetData(player,CONST.����_����);
       local partyname = playerName .. "���";
       --print(partyname)
       tbl_playerautoranking[cdk] = {}
       table.insert(tbl_playerautoranking[cdk],cdk);
       --table.insert(tbl_playerautoranking[cdk],player);
       --table.insert(tbl_playerautoranking[cdk],partyname);

       PartyMember[cdk] = {}
       for partySlot = 0,4 do 
           local targetcharIndex = Char.GetPartyMember(player,partySlot);
           if targetcharIndex >= 0  then
               table.insert(PartyMember[cdk], partySlot+1, targetcharIndex);
           else
               table.insert(PartyMember[cdk], partySlot+1, -1);
           end
           if (partySlot>=1 and not Char.IsDummy(targetcharIndex)) then
             NLG.SystemMessage(player,"[�������]Ӗ���Ҍ���ֻ�ܺͻ��һ�����ӡ�");
             return;
           end
       end
       table.insert(PartyMember[cdk],cdk);

       Number = Number + 1;
       Char.Warp(player,0,EnterMap[1],EnterMap[2],EnterMap[3]);
     else
       return 0;
     end
    end

    if seqno == 31 then  ----���г����ս&ִ��
     key = data
     local duelplayer= tbl_duel_user[key];
         if ( duelplayer ~= nil ) then
             NLG.WatchEntry(player, tonumber(duelplayer));
         else
             return 0;
         end
    end

  end)

  self:NPC_regTalkedEvent(rankingNPC, function(npc, player)  ----��ս����AutoMenus{}
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "3\\n@c�gӭÿ�Յ���Ӗ���Ҍ���\\n\\n\\n";
      for i = 1, 3 do
        msg = msg .. AutoMenus[i][1] .. "\\n"
      end
      NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, CONST.��ť_�ر�, 1, msg);
    end
    return
  end)

end

function Module:onSellerTalked(npc, player)  ----������̭�콱��
  if (NLG.CanTalk(npc, player) == true) then
     Char.GiveItem(player,631096,5);
     Char.Warp(player,0,LobbyMap[1],LobbyMap[2],LobbyMap[3]);
  end
end
function Module:onSellerSelected(npc, player, seqNo, select, data)
  if select == 2 then
     return
  end
end
------------------------------------------------
-------��������
--ָ������
function Module:handleTalkEvent(charIndex,msg,color,range,size)
	if (msg=="[nr trainerbattle on]") then
		enterStart()
		--swjjcStart(npc);
		if (awardnpc==nil) then
			awardnpc = self:NPC_createNormal( '��̭���Ӫ�', 17092, { map = 25291, x = 25, y = 24, direction = 6, mapType = 0 })
			self:NPC_regTalkedEvent(awardnpc, Func.bind(self.onSellerTalked, self))
			self:NPC_regWindowTalkedEvent(awardnpc, Func.bind(self.onSellerSelected, self));
			Char.SetLoopEvent('./lua/Modules/autoRanking.lua','pkStartNpcLoopEvent', awardnpc,1000);
			tbl_swjjc_goinfo[round_count] = 1
			NLG.SystemMessage(-1,"[�������]Ӗ���Ҍ����_ʼ�������ѽ�ֹ��ǰ���^��");
		else
			Char.SetLoopEvent('./lua/Modules/autoRanking.lua','pkStartNpcLoopEvent', awardnpc,1000);
			tbl_swjjc_goinfo[round_count] = 1
			NLG.SystemMessage(-1,"[�������]Ӗ���Ҍ����_ʼ�������ѽ�ֹ��ǰ���^��");
		end
		return 0;
	elseif (msg=="[nr trainerbattle off]") then
		tbl_swjjc_goinfo[round_count] = 0;
		Setting = changeSetting(0);
		Char.SetLoopEvent('./lua/Modules/autoRanking.lua','pkStartNpcLoopEvent', awardnpc,86400);
		Char.UnsetLoopEvent(awardnpc);
		resetStart()
		NLG.SystemMessage(-1,"[�������]Ӗ���Ҍ����шA�M�Y����");
		return 0;
	end
	return 1;
end
--��ս��ʼѭ��
function TrainerBattle_LoopEvent(rankingNPC)
	local CTime = tonumber(os.date("%H",FTime));
	if (os.date("%X",os.time())=="20:00:00") then
		local MapUser = NLG.GetMapPlayer(0,EnterMap[1]);
		if (MapUser~=-3) then
			for _,v in pairs(MapUser) do
				Char.Warp(v,0,EnterMap[1],EnterMap[2],EnterMap[3]);
			end
		end
		enterStart()
		NLG.SystemMessage(-1,"[�������]Ӗ���Ҍ��𼴌��_ʼ��Ո�M�و��������");
	elseif (os.date("%X",os.time())=="20:20:00") then
		NLG.SystemMessage(-1,"[�������]Ӗ���Ҍ�������ʣ��10��犣�Ո�M�و��������");
	elseif (os.date("%X",os.time())=="20:30:00") then
		--swjjcStart(npc);
		if (awardnpc==nil) then
			awardnpc = Module:NPC_createNormal( '��̭���Ӫ�', 17092, { map = 25291, x = 25, y = 24, direction = 6, mapType = 0 })
			Module:NPC_regTalkedEvent(awardnpc, function(npc, player)
				if (NLG.CanTalk(npc, player) == true) then
					Char.GiveItem(player,631096,5);
					Char.Warp(player,0,LobbyMap[1],LobbyMap[2],LobbyMap[3]);
				end
			end)
			Module:NPC_regWindowTalkedEvent(awardnpc, function(npc, player, seqNo, select, data)
				if select == 2 then
					return
				end
			end)
			Char.SetLoopEvent('./lua/Modules/autoRanking.lua','pkStartNpcLoopEvent', awardnpc,1000);
			tbl_swjjc_goinfo[round_count] = 1
			NLG.SystemMessage(-1,"[�������]Ӗ���Ҍ����_ʼ�������ѽ�ֹ��ǰ���^��");
		else
			Char.SetLoopEvent('./lua/Modules/autoRanking.lua','pkStartNpcLoopEvent', awardnpc,1000);
			tbl_swjjc_goinfo[round_count] = 1
			NLG.SystemMessage(-1,"[�������]Ӗ���Ҍ����_ʼ�������ѽ�ֹ��ǰ���^��");
		end
	elseif (os.date("%X",os.time())=="23:59:59") then
		tbl_swjjc_goinfo[round_count] = 0;
		Setting = changeSetting(0);
		Char.SetLoopEvent('./lua/Modules/autoRanking.lua','pkStartNpcLoopEvent', awardnpc,86400);
		Char.UnsetLoopEvent(awardnpc);
		resetStart()
	end
end

function enterStart()
	Enter = 1;
	Finish = 0;
	return Enter,Finish;
end
function resetStart()
	Enter = 0;
	Number = 0;
	return Enter,Finish;
end
function changeSetting(Set)
	Setting = Set;
	return Setting;
end
function getbattleCount()
	battle_count = tbl_swjjc_goinfo[create_battle_count];
	return battle_count;
end
--����������ѭ�����
function pkStartNpcLoopEvent(awardnpc)

	if (Setting == 0) then	--��һ������
		STime = os.time()
		local timec = STime - FTime;
		tbl_win_user = {};
		tbl_duel_user = {};

		local MapUser = NLG.GetMapPlayer(0, EnterMap[1]);
		tbl_trainer = {};
		if (MapUser~=-3) then	--ս���е�ͼ�ж�û��?
			for i,v in ipairs(MapUser)do
				--NLG.SystemMessage(-1,Char.GetData(v,CONST.����_����));
				if not Char.IsDummy(v) then
					table.insert(tbl_trainer,v);
				end
			end
		end
		playerNum = #tbl_trainer;

		if playerNum>=1 then
			battle_round_start(tbl_trainer,'wincallbackfunc');
			NLG.SystemMessage(-1,"Ӗ���Ҍ��� ��"..tbl_swjjc_goinfo[round_count].."���_ʼ��");
			tbl_swjjc_goinfo[round_count] = tbl_swjjc_goinfo[round_count] + 1;
			Setting = changeSetting(1);
		end
	elseif (Setting == 1) then
		TTime = os.time()
		local timec = TTime - STime;
		if (timec <= 600) then	--10����
			NextRound = 0;
			local battle_count = getbattleCount();
			--print(battle_count)
			if (timec>120 and battle_count >= math.floor(playerNum/2) ) then
				NextRound = 1;
				goto continue
			end
			tbl_win_user = getWinUser();
			for _,v in pairs(tbl_win_user) do
				if (not Char.IsDummy(v) and Char.GetData(v,CONST.����_���Ŀ���) == 1) then
					if (math.fmod(timec,60)==0) then	--1���ӹ���
						NLG.SystemMessage(v,"[�������]��ϲ�@�Ä�����Ո�ȴ�����Ӗ�����g����Y����");
					end
				end
			end
			if (timec==300) then
				NLG.SystemMessageToMap(0, EnterMap[1],"[�������]���x�ж��r�gʣ��5��犣�Ո�M�ٛQ����ؓ��");
			end
		end
		::continue::
		if (timec > 600 or NextRound==1) then	--��ʱ10���ӽ��������߽������
			tbl_duel_user = getDuelUser();
			tbl_win_user = getWinUser();
			for i,j in ipairs(tbl_duel_user)do
				if (j[3]==nil and Char.GetBattleIndex(j[2])>=0) then
					Battle.ExitBattle(j[1]);
					Battle.ExitBattle(j[2]);
				elseif (j[3]==nil and Char.GetBattleIndex(j[2])<0) then
					print(j[1],j[2],j[3])
					table.insert(tbl_win_user,j[2]);
				elseif (j[3]==1 and Char.GetBattleIndex(j[2])<0) then
					print(j[1],j[2],j[3])
					table.insert(tbl_win_user,j[1]);
				end
			end
			Setting = changeSetting(2);
		end
	elseif (Setting == 2) then
		ZTime = os.time()
		local timec = ZTime - TTime;
		if (timec <= 10) then	--���n�ж��������
			wincallbackfunc(tbl_win_user);
			return;
		else
			Setting = changeSetting(3);
		end
	elseif (Setting == 3) then
		WTime = os.time()
		local timec = WTime - ZTime;

		local MapUser = NLG.GetMapPlayer(0, EnterMap[1]);
		tbl_trainer = {};
		if (MapUser~=-3) then	--ս���е�ͼ�ж�û��?
			for i,v in ipairs(MapUser)do
				--NLG.SystemMessage(-1,Char.GetData(v,CONST.����_����));
				if not Char.IsDummy(v) then
					table.insert(tbl_trainer,v);
				end
			end
		end

		if (tonumber(#tbl_trainer)==1) then
			wincallbackfunc(tbl_trainer);
			Setting = -1;
		elseif (tonumber(#tbl_trainer)>=2 and timec <= 30) then
			for _,v in pairs(tbl_trainer) do
				if (not Char.IsDummy(v) and Char.GetData(v,CONST.����_���Ŀ���) == 1) then
					NLG.SystemMessage(v,"[�������]Ӗ���Ҍ�����һ�ؼ����_ʼ������"..tostring(31 - timec).."�롣");
				end
			end
		elseif (tonumber(#tbl_trainer)>=2 and timec > 30) then
			Setting = changeSetting(0);
		else
			return;
		end
	elseif (Setting == -1) then
		ResetTime = os.time()
		local timec = ResetTime - WTime;
		if (timec > 30) then
			tbl_swjjc_goinfo[round_count] = 1;
			Setting = changeSetting(0);
			Char.SetLoopEvent('./lua/Modules/autoRanking.lua','pkStartNpcLoopEvent', awardnpc,86400);
			Char.UnsetLoopEvent(awardnpc);
			NLG.SystemMessage(-1,"[�������]Ӗ���Ҍ����шA�M�Y����");
		end
	end

end

--���������ж�
function wincallbackfunc(tbl_win_user)
	if (tbl_win_user ~= nil and Setting == 2)then
		local MapUser = NLG.GetMapPlayer(0,EnterMap[1]);
		tbl_trainer = {};
		for i,v in ipairs(MapUser)do
			if not Char.IsDummy(v) then
				table.insert(tbl_trainer,v);
			end
		end
		if (tbl_trainer==-3) then
			return;
		else
			warpfailuser(tbl_trainer,tbl_win_user,0,ExitMap[1],ExitMap[2],ExitMap[3]);
		end
	elseif (tbl_win_user ~= nil and Setting == 3)then
		if (Finish == 0) then
			for _,v in pairs(tbl_win_user) do
				if not Char.IsDummy(v) then
					Char.GiveItem(v,631097,1);
					NLG.SystemMessage(-1,"[�������]��ϲӖ����:"..Char.GetData(v,CONST.����_����).."�@�ñ����ˌ����܊��");
					Char.Warp(v,0,LobbyMap[1],LobbyMap[2],LobbyMap[3]);
					--Char.UnsetLoopEvent(awardnpc);
				end
			end
			Finish = 1;
			tbl_playerautoranking = {};
		end
	else
	end
end

--��սִ��
function battle_round_start(tbl_trainer)

	-- �����������
	tbl_trainer = tablereset(tbl_trainer);

	--��ʼΪ������ս��
	--NLG.SystemMessage(-1,"=====Ӗ����=====");
	--NLG.SystemMessage(-1,"================");

	local tbl_UpIndex = {};
	local tbl_DownIndex = {};
	-- �ֳ�������
	for i = 1,tonumber(#tbl_trainer),2 do
	--NLG.SystemMessage(-1,"i:"..i);
		table.insert(tbl_UpIndex,tbl_trainer[i]);
		if(i + 1 > tonumber(#tbl_trainer))then
			table.insert(tbl_DownIndex,-1);
		else
			table.insert(tbl_DownIndex,tbl_trainer[i + 1]);
		end
	--NLG.SystemMessage(-1,"================");
	--NLG.SystemMessage(-1,Char.GetData(tbl_trainer[i],CONST.����_����));
	--NLG.SystemMessage(-1,Char.GetData(tbl_trainer[i+1],CONST.����_����));
	end

	--�Զ����
	for b,p in ipairs(tbl_trainer) do
		local cdk = Char.GetData(p,CONST.����_CDK);
		if PartyMember[cdk] ~= nill and cdk == PartyMember[cdk][6] then
			local playerMapType = Char.GetData(p, CONST.����_��ͼ����);
			local playerMap = Char.GetData(p, CONST.����_��ͼ);
			local playerX = Char.GetData(p, CONST.����_X);
			local playerY = Char.GetData(p, CONST.����_Y);
			for k,v in ipairs(PartyMember[cdk]) do
				local memberMap = Char.GetData(v, CONST.����_��ͼ);
				local memberX = Char.GetData(v, CONST.����_X);
				local memberY = Char.GetData(v, CONST.����_Y);
				if v~=p then
					Char.Warp(v, playerMapType, playerMap, playerX, playerY);
					Char.JoinParty(v, p);
				end
			end
		end
	end
	--��ʼս��
	for j = 1,tonumber(#tbl_UpIndex) + 1,1 do
		--���˫�������ߣ���ʲô��������ֱ������
		if(tbl_UpIndex[j] == nil and tbl_DownIndex[j] == nil)then
		--do nothing		
		--����Ϸ��䵥��Ա��������ֱ�Ӹ����·���Ա����
		elseif(tbl_UpIndex[j] == nil)then
			table.insert(tbl_win_user,tbl_DownIndex[j]);
			NLG.SystemMessage(tbl_DownIndex[j],"[�������]�o�˺����䌦��ֱ�ӕx����Ո�ȴ��e�ˑ��Y�Y����");
		--����·��䵥��Ա��������ֱ�Ӹ����Ϸ���Ա����
		elseif(tbl_DownIndex[j] == nil)then
			table.insert(tbl_win_user,tbl_UpIndex[j]);
			NLG.SystemMessage(tbl_UpIndex[j],"[�������]�o�˺����䌦��ֱ�ӕx����Ո�ȴ��e�ˑ��Y�Y����");
		--��ս
		else
			NLG.SystemMessage(-1,"[�������]"..Char.GetData(tbl_DownIndex[j],CONST.����_����).." VS "..Char.GetData(tbl_UpIndex[j],CONST.����_����));

			tbl_battleIndex = {}
			tbl_battleIndex[j] = Battle.PVP(tbl_UpIndex[j],tbl_DownIndex[j]);	--tbl_UpIndex(�ص�����ǰ��Upվλ��������ҷ�0)
			table.insert(tbl_duel_user,{tbl_UpIndex[j],tbl_DownIndex[j]});

			Battle.SetPVPWinEvent('./lua/Modules/autoRanking.lua', 'battle_wincallback', tbl_battleIndex[j]);
		end
	end


end

--�·�ʤ���¼�
function battle_wincallback(battleIndex)

	local winside = Battle.GetWinSide(battleIndex);
	--print(winside)
	local sideM = 0;
	--tbl_swjjc_goinfo[create_battle_count] = tbl_swjjc_goinfo[create_battle_count] - 1;

	--[[��ȡʤ����
	if (winside == 0) then
		sideM = 0;
	end
	if (winside == 1) then
		sideM = 10;
	end]]
	--��ȡʤ���������ָ�룬����վ��ǰ���ͺ�
	local leader1 = Battle.GetPlayIndex(battleIndex, 0 + 0);
	local leader2 = Battle.GetPlayIndex(battleIndex, 5 + 0);
	if Char.IsPlayer(leader2) then
		leader1 = leader2;
	end

	--��ʤ����Ҽ����б�
    for k,v in pairs(tbl_win_user) do
		if (CheckInTable(tbl_win_user,v)==false) then
			table.insert(tbl_win_user, leader1);
		end
	end
	local safe=0;
	for i,j in ipairs(tbl_duel_user)do
		for k,v in ipairs(tbl_win_user)do
			if (j[1]==v) then
				safe=i;
				table.insert(tbl_duel_user,1);
			end
		end
		if (safe==0) then
			for k,v in pairs(tbl_win_user) do
				if (CheckInTable(tbl_win_user,j[2])==false) then
					table.insert(tbl_win_user,j[2]);
				end
			end
		end
	end

	-- ��ǰ���δ���ս���ܼƴΣ������ж��Ƿ��Ѿ��ﵽ������׼
	tbl_swjjc_goinfo[create_battle_count] = tbl_swjjc_goinfo[create_battle_count] + 1;
	Battle.UnsetPVPWinEvent(battleIndex);

	return tbl_duel_user;
end
function getWinUser()
	tbl_win_user = tbl_win_user;
	return tbl_win_user;
end
function getDuelUser()
	tbl_duel_user = tbl_duel_user;
	return tbl_duel_user;
end
--�Ϸ�ʤ���ֶ��ж�
function checkWinner(tbl_duel_user,tbl_win_user)
	local safe=0;
	for i,j in ipairs(tbl_duel_user)do
		for k,v in ipairs(tbl_win_user)do
			if (j[1]==v) then
				safe=i;
				tbl_duel_user[3]=1;
			end
		end
		if (safe==0) then
			table.insert(tbl_win_user,j[2]);
		end
	end
	return tbl_win_user;
end

--����ʧ�ܵ����
function warpfailuser(tbl_trainer,tbl_win_user,floor,mapid,x,y)
	local failuser = delfailuser(tbl_trainer,tbl_win_user);
	for _,tuser in pairs(failuser) do
		Battle.ExitBattle(tuser);
		Char.Warp(tuser,0,ExitMap[1],ExitMap[2],ExitMap[3]);
		NLG.SystemMessage(tuser,"[�������]���x���cӖ�����g�Č���");
	end
end

--��ȡս��ʧ�ܵ����
function delfailuser(tbl_trainer,tbl_win_user)
	for _,v in pairs(tbl_win_user)do
		for i,w in pairs(tbl_trainer)do
			if(v == w)then
				tbl_trainer[i] = nil;
			end
		end
	end
	return tbl_trainer;
end

--��������б�(δ����)
function tablereset(tbl_trainer)
	local len = #tbl_trainer;
	local xa = NLG.Rand(1,3);
	if ((len-1-xa) <= 1) then
		num = 1;
	else
		num = len-1-xa;
	end
	for i=1,num do
		if ((i+1+xa)>=len) then
			slot = len;
		else
			slot = i+1+xa;
		end
		a = NLG.Rand(1,slot);
		temp=tbl_trainer[a];
		tbl_trainer[a]=tbl_trainer[i];
		tbl_trainer[i]=temp;
	end
	return tbl_trainer;
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
