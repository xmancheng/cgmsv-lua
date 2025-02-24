local Module = ModuleBase:createModule('autoRanking')

local AutoMenus = {
  { "����Ӗ���Ҍ���" },
  { "�^���������˔�" },
  { "�M�Ќ������^��" },
}

---�����������޸�
local Number = 0
local tbl_playerautoranking = {}
local PartyMember = {}

--��������
tbl_swjjc_goinfo = {};
tbl_win_user = {};			--��ǰ����ʤ����ҵ��б�
tbl_swjjc_begin = {};
tbl_swjjc_time ={};
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
  self:regCallback('LoopEvent', Func.bind(self.TrainerBattle_LoopEvent,self))
  local rankingNPC = self:NPC_createNormal('���ɉ�Ӗ���Ҍ���', 11394, { map = 7351, x = 26, y = 37, direction = 4, mapType = 0 })
  Char.SetLoopEvent('./lua/Modules/autoRanking.lua','TrainerBattle_LoopEvent',rankingNPC, 1000);
  self:NPC_regWindowTalkedEvent(rankingNPC, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.����_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if seqno == 1 then
     if data == 1 then  ----������ս
       if (tbl_swjjc_setting.start==1 or tbl_swjjc_setting.start==2) then
         NLG.SystemMessage(player,"[ϵ�y]���݌����ѽ��_ʼՈ�ȴ���һ����");
         return;
       end
       if (tbl_playerautoranking[cdk]~=nil) then
         Char.Warp(player,0,25290,15,34);
         --NLG.SystemMessage(player,"[ϵ�y]���ѽ������^��݆���݌���");
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
       if (tbl_swjjc_setting.start==0) then
         NLG.SystemMessage(player,"[ϵ�y]�F���ѽ��� ".. Number .." ꠈ����ɹ���");
         return;
       else
         NLG.SystemMessage(player,"[ϵ�y]���݌������_ʼՈ���ᣡ");
         return;
       end
     end

     if data == 3 then  ----���г����ս
       if (tbl_swjjc_setting.start==1 or tbl_swjjc_setting.start==2) then
           local msg = "3\\n@c������ِ���^��\\n"
                                .."\\n�����T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n";
           for i = 1, #tbl_duel_user do
               local duelplayer = tbl_duel_user[i];
               local duelplayerName = Char.GetData(duelplayer,CONST.����_����);
                   msg = msg .. duelplayerName .. "��VS��".. "\\n"
           end
           NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, CONST.��ť_�ر�, 31, msg);
       else
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
       end
       table.insert(PartyMember[cdk],cdk);

       Number = Number + 1;
       Char.Warp(player,0,25290,15,34);
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
     Char.GiveItem(player,69000,50);
     Char.Warp(player,0,7351,25,29);
  end
end
function Module:onSellerSelected(npc, player, seqNo, select, data)
  if select == 2 then
     return
  end
end

function TrainerBattle_LoopEvent(npc)
	local CTime = tonumber(os.date("%H",FTime));
	if (os.date("%X",os.time())=="20:00:00") then
		tbl_swjjc_setting.start = 0
		NLG.SystemMessage(-1,"[�������]Ӗ���Ҍ��𼴌��_ʼ��Ո�M�و��������");
	elseif (os.date("%X",os.time())=="20:20:00") then
		NLG.SystemMessage(-1,"[�������]Ӗ���Ҍ�������ʣ��10��犣�Ո�M�و��������");
	elseif (os.date("%X",os.time())=="20:30:00") then
		if (tbl_swjjc_setting.start == 0) then
			swjjcStart(npc);
			local awardnpc = self:NPC_createNormal( '��̭��ο��', 17092, { map = 25291, x = 36, y = 13, direction = 6, mapType = 0 })
			self:NPC_regTalkedEvent(awardnpc, Func.bind(self.onSellerTalked, self))
			self:NPC_regWindowTalkedEvent(awardnpc, Func.bind(self.onSellerSelected, self));
			Char.SetLoopEvent('./lua/Modules/autoRanking.lua','swjjcStartNpcLoopEvent', awardnpc,1000); 
			tbl_swjjc_time[time][1] = os.time();
			tbl_swjjc_setting.start = 1
		end
		NLG.SystemMessage(-1,"[�������]Ӗ���Ҍ����_ʼ��������ֹ��ǰ���^��");
	elseif (os.date("%X",os.time())=="23:59:59") then
		tbl_swjjc_setting.start = 0
	end
end


function swjjcStartNpcLoopEvent(index)

	tbl_swjjc_time[time][2] = os.time();
	if (tbl_swjjc_time[time][1] ~= nil) then
		local timec = tbl_swjjc_time[time][2] - tbl_swjjc_time[time][1];
		if (timec <= 20) then
			NLG.SystemMessage(tbl_win_user,"Ӗ���Ҍ�����һ�ؼ����_ʼ������ "..tostring(20 - timec).."�롣");
			tbl_swjjc_begin[Loopbegin] = false;
			return;
		end
	end

	local MapUser = NLG.GetMapPlayer(0,25290);
	if (MapUser ==nil) then
		return;
	end
	if(tbl_swjjc_setting.start == 2) then
		def_round_start(tbl_win_user,'wincallbackfunc');
		tbl_swjjc_begin[Loopbegin] = false;
	else
		return;
	end
	return;
end


function swjjcStart(npc)
	tbl_swjjc_setting.start = 1;

	local MapUser = NLG.GetMapPlayer(0,25290);

	for i,v in ipairs(MapUser)do
	--	NLG.SystemMessage(-1,Char.GetData(v,CONST.����_����));
	end

	setUser_WinFunc('user_WinFunc');
	def_round_start(MapUser,'wincallbackfunc');

end

function wincallbackfunc(tbl_win_user)
	if(tonumber(#tbl_win_user) > 1)then
		for i,v in ipairs(tbl_win_user)do
			if(v == nil)then
				table.remove(tbl_win_user,i);
			end
		end

		--��������ʧ�ܵ���ң�����ѽ-----------------------------
		local MapUser = NLG.GetMapPlayer(0,25290);
		if (MapUser ==nil) then
			return;
		end
		warpfailuser(MapUser,tbl_win_user,0,25291,35,14);
		-------------------------------------------------------
		--�����ֻؿ�
		--tbl_win_user = {};
		--tbl_win_user = winuser;
		tbl_swjjc_begin[begin] = true;
		tbl_swjjc_begin[Loopbegin] = false;
		tbl_swjjc_time[time][1] = os.time();
		tbl_swjjc_setting.start = 2;
		--def_round_start(tbl_win_user,'wincallbackfunc');
	end

	-- ֱ��n���ֻع�������ʤ��һ�����
	if(tonumber(#tbl_win_user) <= 1)then

		--���ߵڶ�����ң�����ѽ-----------------------------
		local MapUser = NLG.GetMapPlayer(0,25290);
		if (MapUser ==nil) then
			return;
		end
		warpfailuser(MapUser,tbl_win_user,0,25291,35,14);
		-----------------------------------------------------

		for _,v in pairs(tbl_win_user) do
			Char.GiveItem(v,69000,50);
			NLG.SystemMessage(-1,"��ϲӖ����:"..Char.GetData(v,CONST.����_����).."�@�ñ����ˌ����܊��");
			Char.Warp(v,0,1000,229,65);
		end
		tbl_playerautoranking = {};
		tbl_swjjc_setting.start = 0;
		Number = 0;

	end
end


function def_round_start(usertable,callback)

	--NLG.SystemMessage(-1,"Ӗ���Ҍ��� ��:"..tbl_swjjc_goinfo[round_count].."���_ʼ��");
	-- Ŀǰս�������Լ�
	tbl_swjjc_goinfo[round_count] = tbl_swjjc_goinfo[round_count] + 1;
	tbl_swjjc_setting.start = 1;

	-- �����������
	usertable = tablereset(usertable);
	-- ����xǿ������Ļص�����
	tbl_swjjc_setting.WinFunc = callback;
	-- ��ʼΪ������ս��
	
	--NLG.SystemMessage(-1,"=====Ӗ����=====");
	--for i,v in ipairs(usertable)do
	--	NLG.SystemMessage(-1,Char.GetData(v,CONST.����_����));	
	--end
	--NLG.SystemMessage(-1,"================");


	local tbl_UpIndex = {};
	local tbl_DownIndex = {};
	-- �ֳ�������
	for i = 1,tonumber(#usertable),2 do
	--	NLG.SystemMessage(-1,"i:"..i);
		table.insert(tbl_UpIndex,usertable[i]);
		if(i + 1 > tonumber(#usertable))then
			table.insert(tbl_DownIndex,-1);
		else
			table.insert(tbl_DownIndex,usertable[i + 1]);
		end
	--	NLG.SystemMessage(-1,"xxxxx=======");
	--	NLG.SystemMessage(-1,Char.GetData(usertable[i],CONST.����_����));
	--	NLG.SystemMessage(-1,Char.GetData(usertable[i+1],CONST.����_����));
	end
	-- ���ʤ������б�	
	tbl_win_user = {};
	tbl_duel_user = {};

	--[[--��Ӷ�����˿�����Ҫ�Զ����
	for b,p in ipairs(usertable) then
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
	]]
	--��ʼս��
	for j = 1,tonumber(#tbl_UpIndex) + 1,1 do
		--���˫�������ߣ���ʲô��������ֱ������
		if(tbl_UpIndex[j] == nil and tbl_DownIndex[j] == nil)then
		--do nothing		
		--����Ϸ��䵥��Ա��������ֱ�Ӹ����·���Ա����
		elseif(tbl_UpIndex[j] == nil)then
			table.insert(tbl_win_user,tbl_DownIndex[j]);
			NLG.SystemMessage(tbl_DownIndex[j],"�o�˺����䌦��ֱ�ӕx����Ո�ȴ��e�ˑ��Y�Y����");
		--����·��䵥��Ա��������ֱ�Ӹ����Ϸ���Ա����
		elseif(tbl_DownIndex[j] == nil)then
			table.insert(tbl_win_user,tbl_UpIndex[j]);
			NLG.SystemMessage(tbl_UpIndex[j],"�o�˺����䌦��ֱ�ӕx����Ո�ȴ��e�ˑ��Y�Y����");
		--��ս
		else
			--NLG.SystemMessage(-1,"[�������]"..Char.GetData(tbl_UpIndex[j],CONST.����_����).." VS "..Char.GetData(tbl_DownIndex[j],CONST.����_����));

			battleIndex = {}
			battleIndex[j] = Battle.PVP(tbl_UpIndex[j], tbl_DownIndex[j]);
			table.insert(tbl_duel_user,tbl_DownIndex[j]);

			-- ��ǰ���δ���ս���ܼƴΣ������ж��Ƿ��Ѿ��ﵽ������׼
			tbl_swjjc_goinfo[create_battle_count] = tbl_swjjc_goinfo[create_battle_count] + 1;
			Battle.SetWinEvent('./lua/Modules/autoRanking.lua', 'def_round_wincallback', battleIndex[j]);
		end
	end
	tbl_swjjc_goinfo[create_battle_count_bak] = tbl_swjjc_goinfo[create_battle_count];
end


function def_round_wincallback(battleIndex)

	local winside = Battle.GetWinSide(battleIndex);
	print(winside)
	local sideM = 0;
	tbl_swjjc_goinfo[create_battle_count] = tbl_swjjc_goinfo[create_battle_count] - 1;

	--��ȡʤ����
	if (winside == 0) then
		sideM = 0;
	end
	if (winside == 1) then
		sideM = 10;
	end
	--��ȡʤ���������ָ�룬����վ��ǰ���ͺ�
	local w1 = Battle.GetPlayIndex(battleIndex, 0 + sideM);
	local w2 = Battle.GetPlayIndex(battleIndex, 5 + sideM);
	local ww = nil;

	print(w1)
	print(w2)
	--��ʤ����Ҽ����б�
	if ( Char.GetData(w1,CONST.����_��½����) >= 1 ) then
		local ww = w1;
		table.insert(tbl_win_user, ww);
	elseif ( Char.GetData(w2,CONST.����_��½����) >= 1 ) then
		local ww = w2;
		table.insert(tbl_win_user, ww);
	else
		local ww = nil;
	end

	local MapUser = NLG.GetMapPlayer(0,25290);
	local MapUserNum = tonumber(#MapUser);
	local shortlist = math.floor(MapUserNum/2);

	--�������ս
	if (tbl_swjjc_setting.round_count == 1)then
		--�ж������Ƿ��Ѵ����ڶ��ֵ�Ҫ��
		if (tonumber(#tbl_win_user) >= shortlist)then
			NLG.SystemMessage(-1,"Ӗ���Ҍ�����һ�غϼ����_ʼ��");
			wincallbackfunc(tbl_win_user);
		end
	else
		--�ж������Ƿ��Ѵ������һ�ֵ�Ҫ��
		if (tbl_swjjc_goinfo['create_battle_count'] == 0)then
			wincallbackfunc(tbl_win_user);
		end
	end
	Battle.UnsetWinEvent(battleIndex);
end


function user_WinFunc(player,mc)
	NLG.SystemMessage(player,"��ϲ�@�Ä�����Ո�ȴ�����Ӗ�����g����Y����");
end

function setUser_WinFunc(winfuncname)
	tbl_swjjc_setting.this_user_WinFunc = winfuncname;
end

--	�������ܣ�����ʧ�ܵ����
function warpfailuser(MapUser,tbl_win_user,floor,mapid,x,y)
	local failuser = delfailuser(MapUser,tbl_win_user);
	for _,tuser in pairs(failuser) do
		Battle.ExitBattle(tuser);
		Char.Warp(tuser,0,25291,35,14);
		NLG.SystemMessage(tuser,"���x���cӖ�����g�Č���");
	end
end

--	�������ܣ���ȡս��ʧ�ܵ����
function delfailuser(MapUser,tbl_win_user)
	for _,v in pairs(tbl_win_user)do
		for i,w in pairs(MapUser)do
			if(v == w)then
				MapUser[i] = nil;
			end
		end
	end
	return MapUser;
end

--	�������ܣ���������б�(δ���)
function tablereset(trainer_tbl)
	local xa = NLG.Rand(1,3);
	if ((#trainer_tbl-1-xa) <= 1) then
		num=1;
	else
		num=(#trainer_tbl-1-xa);
	end
	for i=1,num do
		if ((i+1+xa)>=#trainer_tbl) then
			slot=(#trainer_tbl);
		else
			slot=i+1+xa;
		end
		a = NLG.Rand(1,slot);
		temp=trainer_tbl[a];
		trainer_tbl[a]=trainer_tbl[i];
		trainer_tbl[i]=temp;
	end
	return trainer_tbl;
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
