local AutoRanking = ModuleBase:createModule('autoRanking')
local AutoMenus = {
  { "[���������ݶ�ս��]" },
  { "[���ۿ�����������]" },
  { "[�����г����ս��]" },
  { "[����½���ڻ��֡�]" },
  { "[����ѯ���ݵ�����]" },
  { "[���һ����ݽ�����]" },
}

local ItemMenus = {
  { "[����Ӷ����¶�����ޡ�]x1��������300", 900200, 300, 1},
  { "[����������ͼ��������]x1��������100", 70024, 100, 1},
  { "[��������֮��ɰ������]x5��������50", 70161, 50, 5},
  { "[�������︽��ý�顡��]x1��������20", 69993, 20, 1},
  { "[������ˮ��ǿ��ʯ����]x10��������5", 69128, 5, 10},
  { "[���������ݻ���ȯ����]x10��������10", 69000, 10, 10},
}

local Number = 0
local tbl_playerautoranking = {}

---�����������޸�
--PartyList = {}
--for sss = 1,40 do
--PartyList[sss] = {}
--PartyList[sss][1] = {
--{ name = '������Q', member1 = '��L', member2 = '꠆T', member3 = '꠆T', member4 = '꠆T', member5 = '꠆T', win = 0, lose = 0 },
--}
--end

--��������
tbl_swjjc_goinfo = {};
tbl_win_user = {};			--��ǰ����ʤ����ҵ��б�
tbl_swjjc_begin = {};
tbl_swjjc_time ={};
tbl_swjjc_setting =
{
	start = 0;
	round_count =1;
	first_round_user_max = 40; 	--��һ������ѡ��������
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

--- ����ģ�鹳��
function AutoRanking:onLoad()
  self:logInfo('load')
  local rankingnpc = self:NPC_createNormal('�Զ����ݶ�սģʽ', 11394, { map = 1000, x = 229, y = 64, direction = 4, mapType = 0 })
  self:NPC_regWindowTalkedEvent(rankingnpc, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.����_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --print(seqno)
    --print(select)
    --print(data)
    print(cdk)
    if seqno == 1 then
     if data == 1 then  ----�������ݶ�ս
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
         local msg = "\\n@c����ϸ�Ķ�����˵��\\n"
                             .. "\\n�������鷽���Զ���ʼ��ս\\n"
                             .. "\\n����ʱ�δ�������������\\n"
                             .. "\\n�ھ��ɻ��5�Ż���\\n"
                             .. "\\n����μ���1�Ż���\\n";
         NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.BUTTON_�Ƿ�, 11, msg);
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
           local msg = "3\\n@c���ݹ�ս����\\n"
                                .."\\n�����T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n";
           for i = 1, #tbl_duel_user do
               local duelplayer = tbl_duel_user[i];
               local duelplayerName = Char.GetData(duelplayer,CONST.CHAR_����);
                   msg = msg .. duelplayerName .. "��VS��".. "\\n"
           end
           NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, CONST.BUTTON_�ر�, 31, msg);
       else
         return;
       end
     end

     if data == 4 then  ----��½���ڻ���
       if (NLG.CanTalk(npc, player) == true) then
           local key = Char.FindItemId(player,69000);
           local item = Char.GetItemIndex(player,key);
           local PointCount = Char.ItemNum(player,69000);
           local msg = "\\n@c��½�������ݻ���\\n"
                             .. "\\n�����T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
                             .. "\\n�����ݻ���ȯ����".. PointCount .. "��ȫ���ϴ���?\\n";
           NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.BUTTON_�Ƿ�, 41, msg);
       end
     end

     if data == 5 then  ----��ѯ���ݵ���&ִ��
       if (NLG.CanTalk(npc, player) == true) then
         local PointCount = tonumber(SQL.Run("select ThankFlower from tbl_character where CdKey='"..cdk.."'")["0_0"])
         local msg = "\\n@c��ѯ���ݵ�������\\n"
                             .. "\\n�����T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
                             .. "\\n�����ݻ��֡�����".. PointCount .. "ȯ\\n";
         NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.BUTTON_�ر�, 51, msg);
       end
     end

     if data == 6 then  ----�һ����ݽ���
       if (NLG.CanTalk(npc, player) == true) then
           local msg = "3\\n@c�һ����ݽ�������\\n"
                                .."\\n�����T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n";
           for i = 1, 6 do
               msg = msg .. ItemMenus[i][1] .. "\\n"
           end
           NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, CONST.BUTTON_�ر�, 61, msg);
       end
     end

    end
    ------------------------------------------------------------
    if seqno == 11 then  ----�������ݶ�սִ��
     if select == 4 then
       local playerName = Char.GetData(player,CONST.CHAR_����);
       local partyname = playerName .. "���";
       --print(partyname)
       tbl_playerautoranking[cdk] = {}
       table.insert(tbl_playerautoranking[cdk],cdk);
       --table.insert(tbl_playerautoranking[cdk],player);
       --table.insert(tbl_playerautoranking[cdk],partyname);
       Number = Number + 1;
       Char.Warp(player,0,25290,15,34);
       if (Number >= 4) then
         swjjcStart(player);
         local awardnpc = self:NPC_createNormal( '��̭�콱��', 17092, { map = 25291, x = 36, y = 13, direction = 6, mapType = 0 })
         self:NPC_regTalkedEvent(awardnpc, Func.bind(self.onSellerTalked, self))
         self:NPC_regWindowTalkedEvent(awardnpc, Func.bind(self.onSellerSelected, self));
         Char.SetLoopEvent('lua/Modules/autoRanking.lua','swjjcStartNpcLoopEvent', awardnpc,1000); 
         tbl_swjjc_time[time][1] = os.time();
         tbl_swjjc_setting.start = 1
       end
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

    if seqno == 41 then  ----��½���ڻ���ִ��
     if select == 4 then
       local key = Char.FindItemId(player,69000);
       local item = Char.GetItemIndex(player,key);
       local PointCount = Char.ItemNum(player,69000);
       local Restcount = tonumber(SQL.Run("select ThankFlower from tbl_character where CdKey='"..cdk.."'")["0_0"])
       local Restcount =Restcount + PointCount;
       SQL.Run("update tbl_character set ThankFlower= '"..Restcount.."' where CdKey='"..cdk.."'")
       Char.DelItem(player,69000,PointCount);
       NLG.UpChar(player);
       NLG.SystemMessage(player,"[ϵ�y]�ѳɹ��ς��������ݷe��ȯ��");
     else
       return 0;
     end
    end

    if seqno == 61 then  ----�һ����ݽ���ִ��
     key = data
     if select == 2 then
         return;
     end
     if key == data then
         local PointCount = tonumber(SQL.Run("select ThankFlower from tbl_character where CdKey='"..cdk.."'")["0_0"])
         local itemcost= ItemMenus[data][3];
         if ( PointCount >= itemcost ) then
             local Restcount = PointCount - itemcost;
             SQL.Run("update tbl_character set ThankFlower= '"..Restcount.."' where CdKey='"..cdk.."'")
             Char.GiveItem(player,ItemMenus[data][2],ItemMenus[data][4]);
             NLG.UpChar(player);
         else
             NLG.SystemMessage(player,"[ϵ�y]���ݷe�֔������㣡");
             return 0;
         end
     end
    end


  end)


  self:NPC_regTalkedEvent(rankingnpc, function(npc, player)  ----���ݶ�ս����AutoMenus{}
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "1\\n@c��ӭ�������ݶ�ս����\\n";
      for i = 1, 6 do
        msg = msg .. AutoMenus[i][1] .. "\\n"
      end
      NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, CONST.BUTTON_�ر�, 1, msg);
    end
    return
  end)

end


function AutoRanking:onSellerTalked(npc, player)  ----������̭�콱��
  if (NLG.CanTalk(npc, player) == true) then
     Char.GiveItem(player,69000,1);
     Char.Warp(player,0,1000,229,65);
  end
end

function AutoRanking:onSellerSelected(npc, player, seqNo, select, data)
  --print(select)
  --print(data)
  if select == 2 then
     return
  end
end

function swjjcStartNpcLoopEvent(index)
	--if(tbl_swjjc_begin[Loopbegin] == true)then
	--	return;
	--end
	--tbl_swjjc_begin[Loopbegin] = true;
	--if(tbl_swjjc_begin[begin]  == false)then
	--	tbl_swjjc_begin[Loopbegin] = false;
	--	return;
	--end


	--if (tbl_swjjc_setting.start ~=0) then
	--	for i,v in ipairs(MapUser) do
	--		if ( Char.GetBattleIndex(v) ~= -1 ) then
	--			tbl_swjjc_begin[Loopbegin] = false;
	--			return;
	--		elseif ( Char.GetBattleIndex(v) == -1 ) then
	--			for i,v in ipairs(tbl_win_user) do
	--			NLG.SystemMessage(tbl_win_user,"��վ�������һ�غϼ�����ʼ��");
	--			wincallbackfunc(tbl_win_user);
	--			end
	--		end
	--	end
	--end

	--tbl_swjjc_begin[begin] = false;
	tbl_swjjc_time[time][2] = os.time();
	if (tbl_swjjc_time[time][1] ~= nil) then
		local timec = tbl_swjjc_time[time][2] - tbl_swjjc_time[time][1];
		if (timec <= 20) then
			NLG.SystemMessage(tbl_win_user,"��վ�������һ�غϼ�����ʼ��ʣ�� "..tostring(20 - timec).."�롣");
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


function swjjcStart(player)
	tbl_swjjc_setting.start = 1;

	local MapUser = NLG.GetMapPlayer(0,25290);

	for i,v in ipairs(MapUser)do
	--	NLG.SystemMessage(-1,Char.GetData(v,%����_����%));
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
			Char.GiveItem(v,69000,5);
			NLG.SystemMessage(-1,"��ϲ���:"..Char.GetData(v,%����_����%).."��ñ�����վ������ھ���");
			Char.Warp(v,0,1000,229,65);
		end
		tbl_playerautoranking = {};
		tbl_swjjc_setting.start = 0;
		Number = 0;

	end
end




--[[ def_round_start
	�������ܣ� ÿһ�غϵĿ�ʼ����һ�غϲ����Ʊ���������ǰfirst_round_user_max��ʤ���߽���������غϾ�����ս�������������
	������䵥�ߣ���ֱ�ӽ���
	����1)usertable:��ʾ������ҵ��б�
	    2)funcallback:������������ִ�еĻص�������������xǿ֮�󴥷�
	    **funtcion callback(
		 ����һ:table ��������
		)
]]
function def_round_start(usertable,callback)

	--NLG.SystemMessage(-1,"��վ����� ��:"..tbl_swjjc_goinfo[round_count].."����ʼ��");
	-- Ŀǰս�������Լ�
	tbl_swjjc_goinfo[round_count] = tbl_swjjc_goinfo[round_count] + 1;
	tbl_swjjc_setting.start = 1;

	-- �����������
	usertable = tablereset(usertable);
	-- ����xǿ������Ļص�����
	tbl_swjjc_setting.WinFunc = callback;
	-- ��ʼΪ������ս��
	
	--NLG.SystemMessage(-1,"====�������====");
	--for i,v in ipairs(usertable)do
	--	NLG.SystemMessage(-1,Char.GetData(v,%����_����%));	
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
	--	NLG.SystemMessage(-1,Char.GetData(usertable[i],%����_����%));
	--	NLG.SystemMessage(-1,Char.GetData(usertable[i+1],%����_����%));
	end
	-- ���ʤ������б�	
	tbl_win_user = {};
	tbl_duel_user = {};
	
	--��ʼս��
	for j = 1,tonumber(#tbl_UpIndex) + 1,1 do
		--���˫�������ߣ���ʲô��������ֱ������
		if(tbl_UpIndex[j] == nil and tbl_DownIndex[j] == nil)then
		   --do nothing		
		--����Ϸ��䵥��Ա��������ֱ�Ӹ����·���Ա����
		elseif(tbl_UpIndex[j] == nil)then
			table.insert(tbl_win_user,tbl_DownIndex[j]);
			NLG.SystemMessage(tbl_DownIndex[j],"���˺�����ԣ��㽫ֱ�ӽ�������ȴ�����ս��������");
		--����·��䵥��Ա��������ֱ�Ӹ����Ϸ���Ա����
		elseif(tbl_DownIndex[j] == nil)then
			table.insert(tbl_win_user,tbl_UpIndex[j]);
			NLG.SystemMessage(tbl_UpIndex[j],"���˺�����ԣ��㽫ֱ�ӽ�������ȴ�����ս��������");
		--��ս
		else
			--NLG.SystemMessage(-1,"pk:"..Char.GetData(tbl_UpIndex[j],%����_����%).." VS "..Char.GetData(tbl_DownIndex[j],%����_����%));

			battleindex = {}
			battleindex[j] = Battle.PVP(tbl_UpIndex[j], tbl_DownIndex[j]);
			table.insert(tbl_duel_user,tbl_DownIndex[j]);

			-- ��ǰ���δ���ս���ܼƴΣ������ж��Ƿ��Ѿ��ﵽ������׼
			tbl_swjjc_goinfo[create_battle_count] = tbl_swjjc_goinfo[create_battle_count] + 1;
			Battle.SetPVPWinEvent('lua/Modules/autoRanking.lua', 'def_round_wincallback', battleindex[j]);
		end
	end
	tbl_swjjc_goinfo[create_battle_count_bak] = tbl_swjjc_goinfo[create_battle_count];
end


--[[ def_round_wincallback
	�������ܣ� ��ǰ����ս��������ÿ�����ʤ����Ļص�������
	���ﵽ�����ν�����׼ʱ(��һ����Ϊfirst_round_user_max����ʤ�������ೡ��Ϊ�������ս������)������xǿ��������
	
	������1)number battleindex:��ʾս��ָ��
	    
]]

function def_round_wincallback(battleindex)

	local winside = Battle.GetWinSide(battleindex);
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
	local w1 = Battle.GetPlayIndex(battleindex, 0 + sideM);
	local w2 = Battle.GetPlayIndex(battleindex, 5 + sideM);
	local ww = nil;

	print(w1)
	print(w2)
	--��ʤ����Ҽ����б�
	if ( Char.GetData(w1,CONST.CHAR_��½����) >= 1 ) then
		local ww = w1;
		table.insert(tbl_win_user, ww);
	elseif ( Char.GetData(w2,CONST.CHAR_��½����) >= 1 ) then
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
			NLG.SystemMessage(-1,"��վ�������һ�غϼ�����ʼ��");
			wincallbackfunc(tbl_win_user);
		end
	else
		--�ж������Ƿ��Ѵ������һ�ֵ�Ҫ��
		if (tbl_swjjc_goinfo['create_battle_count'] == 0)then
			wincallbackfunc(tbl_win_user);
		end
	end

end


function user_WinFunc(player,mc)
	NLG.SystemMessage(player,"��ϲ����ʤ�������ĵȴ�������ҽ���ս����");
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
		NLG.SystemMessage(tuser,"�����ˣ���л���룡");
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
function tablereset(_table)
	return  _table;
end

--- ж��ģ�鹳��
function AutoRanking:onUnload()
  self:logInfo('unload')
end

return AutoRanking;
