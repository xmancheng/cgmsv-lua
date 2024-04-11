---ģ����
local Module = ModuleBase:createModule('mazeBoss5')

local EnemySet = {}
local BaseLevelSet = {}
local Pos = {}
local FTime = os.time()
local Setting = 0;
--���н���
--     ��(4)	��(2)	һ(0)	��(1)	��(3)
--     ʮ(9)	��(7)	��(5)	��(6)	��(8)
------------��սNPC����------------
EnemySet[1] = {406215, 406218, 406219, 406214, 406214, 406215, 406216, 406216, 406217, 406217}    --0����û�й�
EnemySet[2] = {406220, 0, 0, 0, 0, 0, 406198, 406199, 0, 0}
EnemySet[3] = {406215, 406218, 406219, 406214, 406214, 406215, 406216, 406216, 406217, 406217}
EnemySet[4] = {0, 0, 0, 0, 0, 0, 406198, 406199, 0, 0}
EnemySet[5] = {406220, 0, 0, 0, 0, 0, 0, 0, 0, 0}
BaseLevelSet[1] = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100}
BaseLevelSet[2] = {110, 0, 0, 0, 0, 0, 100, 100, 0, 0}
BaseLevelSet[3] = {100, 100, 100, 100, 100, 100, 100, 100, 100, 100}
BaseLevelSet[4] = {0, 0, 0, 0, 0, 0, 100, 100, 0, 0}
BaseLevelSet[5] = {110, 0, 0, 0, 0, 0, 0, 0, 0, 0}
Pos[1] = {"ˮĸ����",EnemySet[1],BaseLevelSet[1]}
Pos[2] = {"ˮĸ����",EnemySet[2],BaseLevelSet[2]}
Pos[3] = {"ˮĸ����",EnemySet[3],BaseLevelSet[3]}
Pos[4] = {"�ⰵ���`",EnemySet[4],BaseLevelSet[4]}
Pos[5] = {"ˮĸ����",EnemySet[5],BaseLevelSet[5]}
------------------------------------------------
--��������
local Switch = 1;                          --����������ƿ���1��0��
local Rank = 0;                             --��ʼ���Ѷȷ���
local BossMap= {60011,15,19} -- ս������Floor,X,Y(�����ա���ͬ����)
local OutMap= {60001,21,30}  -- ʧ�ܴ���Floor,X,Y(�����ա���ͬ����)
local LeaveMap= {60001,21,30}  -- �뿪����Floor,X,Y(�����ա���ͬ����)
local BossKey= {70195,70195,70195} -- ��������ͨ������
local Pts= 70206;                                    --��Ů��ƻ��
local BossRoom = {
      { key=1, keyItem=70195, keyItem_count=1, bossRank=1, limit=-1, posNum_L=1, posNum_R=2,
          win={warpWMap=60001, warpWX=21, warpWY=30, getItem = 70265, getItem_count = 1},
          lordName="ˮĸ����",
       },    -- ����(1)
      { key=3, keyItem=70195, keyItem_count=1, bossRank=2, limit=3, posNum_L=2, posNum_R=3,
          win={warpWMap=60001, warpWX=21, warpWY=30, getItem = 70265, getItem_count = 6},
          lordName="ˮĸ����",
       },    -- ��ͨ(2)
      { key=5, keyItem=70195, keyItem_count=1, bossRank=3, limit=5, posNum_L=3, posNum_R=6,
          win={warpWMap=60001, warpWX=21, warpWY=30, getItem = 70206, getItem_count = 25},
          lordName="ˮĸ����",
       },    -- ����(3)
}
tbl_duel_user = {};			--��ǰ������ҵ��б�
tbl_win_user = {};
------------------------------------------------
--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BattleStartEvent', Func.bind(self.OnbattleStartEventCallback, self))
  self:regCallback('BeforeBattleTurnEvent', Func.bind(self.OnBeforeBattleTurnCommand, self))
  self:regCallback('AfterBattleTurnEvent', Func.bind(self.OnAfterBattleTurnCommand, self))
  self:regCallback('EnemyCommandEvent', Func.bind(self.OnEnemyCommandCallBack, self))
  self:regCallback('BattleInjuryEvent', Func.bind(self.OnBattleInjuryCallBack, self))
  local Lord5Npc = self:NPC_createNormal('�^���I��ӑ��', 11394, { map = 60010, x = 74, y = 121, direction = 6, mapType = 0 })
  self:regCallback('LoopEvent', Func.bind(self.AutoLord_LoopEvent,self))
  self:NPC_regWindowTalkedEvent(Lord5Npc, function(npc, player, _seqno, _select, _data)
	local cdk = Char.GetData(player,CONST.����_CDK);
	local seqno = tonumber(_seqno)
	local select = tonumber(_select)
	local data = tonumber(_data)
	local json = Field.Get(player, 'WorldDate');
		local ret, WorldDate = nil, nil;
		if json then
			ret, WorldDate = pcall(JSON.decode, json)
		else
			return
		end
	if seqno == 1 then
		if data == 1 then  ----�μ������ַ�
			local retEnd = SQL.Run("select Name,LordEnd5 from lua_hook_worldboss order by LordEnd5 desc ");
			if (type(retEnd)=="table" and retEnd["0_1"]~=nil) then
				worldLayer = tonumber(retEnd["0_1"]);
			end
			--print(worldLayer)
			if(Char.ItemNum(player,BossKey[1])>0 or Char.ItemNum(player,BossKey[2])>0 or Char.ItemNum(player,BossKey[3])>0) then
				NLG.SystemMessage(player,"[ϵ�y]���M��ӑ�����ܳ����^�ڑ{�C��");
				return;
			else
				if worldLayer == 0 then
					local msg = "7\\n@c�x��^���I��ӑ����ģʽ\\n"
						.."\\n�����T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T"
						.. "\\n̓��ģʽ��δ�_��\\n"
						.. "\\n��ͨģʽ��δ�_��\\n"
						.. "\\n����ģʽ�����Y����\\n";
					NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, CONST.BUTTON_�ر�, 11, msg);
				elseif worldLayer == 1 then
					local msg = "3\\n@c�x��^���I��ӑ����ģʽ\\n"
						.."\\n�����T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T"
						.. "\\n̓��ģʽ��һ����Y\\n"
						.. "\\n��ͨģʽ��һ����Y\\n";
					NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, CONST.BUTTON_�ر�, 12, msg);
				end
			end
		end
		if data == 2 then  ----�鿴����ϸ��
			if (NLG.CanTalk(npc, player) == true) then
			local msg = "\\n@cՈ�x��Ҫ���Եď���ģʽ\\n"
				.. "\\nBOSSδ��ӑ���^�r���H�г���ģʽ\\n"
				.. "\\n�M���I�����������������Y\\n"
				.. "\\n����ģʽ���I���鹲�Yģʽ\\n"
				.. "\\n��������߫@�ê����b��\\n";
			NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.BUTTON_ȷ��, 21, msg);
			end
		end
		if data == 3 then  ----�ۿ��ַ�ʵ��
			if (tbl_duel_user~=nil) then
			local msg = "3\\n@c�^��Ŀǰӑ���Č��r\\n"
				.."\\n�����T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n";
				for i = 1, #tbl_duel_user do
				local duelplayer = tbl_duel_user[i];
				local duelplayerName = Char.GetData(duelplayer,CONST.CHAR_����);
				local rankLevel = {"̓��","��ͨ","�^��"};
				if (duelplayerName~=nil and Rank>=1) then
					msg = msg .. "�I��������:  " ..duelplayerName.. "�  ��".. rankLevel[Rank] .."ģʽ\\n"
				end
			end
			NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, CONST.BUTTON_�ر�, 31, msg);
			else
				return;
			end
		end
	end
	------------------------------------------------------------
	if seqno == 11 then  ----����ģʽִ��
		key = data+4
		if select == 2 then
			return;
		end
		if key == data+4 then
			if ret and #WorldDate > 0 then
				if WorldDate[5][1]==os.date("%w",os.time()) then
					NLG.SystemMessage(player,"[ϵ�y]ÿ�ՃH���M��1��ӑ����");
					Char.Warp(player,0,LeaveMap[1],LeaveMap[2],LeaveMap[3]);
					return;
				end
			else
				WorldDate = {};
				for i=1,7 do
					WorldDate[i]={"7",};
				end
			end
			local playerName = Char.GetData(player,CONST.CHAR_����);
			local partyname = playerName .. "���";
			--print(key)
			local MapUser = NLG.GetMapPlayer(0, BossMap[1]);
			if (MapUser ~= -3 ) then
				local msg = "\\n@cՈ�ȴ�ǰһ�M������\\n"
				.. "\\nÿ��ֻ׼�Sһ��M�з��g����\\n"
				.. "\\n�M���I�����������������Y\\n"
				.. "\\n��������ȫ��������o��L\\n"
				.. "\\nՈ������Ʒ�c���т�����\\n";
				NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.BUTTON_ȷ��, 22, msg);
				return;
			end
			for k,v in pairs(BossRoom) do
				if ( key==v.key ) then
					Rank = v.bossRank;
					Char.HealAll(player);
					Char.GiveItem(player, v.keyItem, v.keyItem_count);
					local slot = Char.FindItemId(player, v.keyItem);
					local item_indexA = Char.GetItemIndex(player,slot);
					Item.SetData(item_indexA,CONST.����_����, v.posNum_L);
					Item.SetData(item_indexA,CONST.����_����, v.bossRank);
					Item.UpItem(player,slot);
					table.insert(tbl_duel_user,player);
					Char.Warp(player,0, BossMap[1], BossMap[2], BossMap[3]);
					Char.SetLoopEvent('./lua/Modules/mazeBoss5.lua','AutoLord_LoopEvent',player,1000);
					--WorldDate = {}
					WorldDate[5] = {
					os.date("%w",os.time()),
					}
					Field.Set(player, 'WorldDate', JSON.encode(WorldDate));
					local PartyNum = Char.PartyNum(player);
					if (PartyNum>1) then
						for Slot=1,4 do
							local TeamPlayer = Char.GetPartyMember(player,Slot);
							if Char.IsDummy(TeamPlayer)==false then
								Field.Set(TeamPlayer, 'WorldDate', JSON.encode(WorldDate));
							end
						end
					end
				end
			end
			def_round_start(player, 'wincallbackfunc');
		else
			return 0;
		end
	end
	if seqno == 12 then  ----�μ������ַ�ִ��
		key = data
		if select == 2 then
			return;
		end
		if key == data then
			local playerName = Char.GetData(player,CONST.CHAR_����);
			local partyname = playerName .. "���";
			--print(key)
			local MapUser = NLG.GetMapPlayer(0, BossMap[1]);
			if (MapUser ~= -3 ) then
				local msg = "\\n@cՈ�ȴ�ǰһ�M������\\n"
				.. "\\nÿ��ֻ׼�Sһ��M�з��g����\\n"
				.. "\\n�M���I�����������������Y\\n"
				.. "\\n��������ȫ��������o��L\\n"
				.. "\\nՈ������Ʒ�c���т�����\\n";
				NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.BUTTON_ȷ��, 22, msg);
				return;
			end
			for k,v in pairs(BossRoom) do
				if ( key==v.key ) then
					Rank = v.bossRank;
					Char.HealAll(player);
					Char.GiveItem(player, v.keyItem, v.keyItem_count);
					local slot = Char.FindItemId(player, v.keyItem);
					local item_indexA = Char.GetItemIndex(player,slot);
					Item.SetData(item_indexA,CONST.����_����, v.posNum_L);
					Item.SetData(item_indexA,CONST.����_����, v.bossRank);
					Item.UpItem(player,slot);
					table.insert(tbl_duel_user,player);
					Char.Warp(player,0, BossMap[1], BossMap[2], BossMap[3]);
					Char.SetLoopEvent('./lua/Modules/mazeBoss5.lua','AutoLord_LoopEvent',player,1000);
				end
			end
			def_round_start(player, 'wincallbackfunc');
		else
			return 0;
		end
	end
	if seqno == 31 then  ----�ۿ��ַ�ʵ��&ִ��
		key = data
		local duelplayer= tbl_duel_user[key];
		if ( duelplayer ~= nil ) then
			NLG.WatchEntry(player, tonumber(duelplayer));
		else
			return 0;
		end
	end
  end)
  self:NPC_regTalkedEvent(Lord5Npc, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
               local msg = "4\\n\\n@c�ﳬ��ħ����I��λ������̎��\\n"
                                             .."\\n�����T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
                                             .."[�������I��ӑ����]\\n" 
                                             .."[���鿴���Լ�����]\\n" 
                                             .."[���^��ӑ�����r��]\\n";
               NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, CONST.BUTTON_�ر�, 1, msg);
    end
    return
  end)


  local Leave5Npc = self:NPC_createNormal('���xɳ©', 235179, { map = 60011, x = 58, y = 19, direction = 6, mapType = 0 })
  self:NPC_regWindowTalkedEvent(Leave5Npc, function(npc, player, _seqno, _select, _data)
  end)
  self:NPC_regTalkedEvent(Leave5Npc, function(npc, player)
	if (NLG.CanTalk(npc, player) == true) then
		if (Char.PartyNum(player)==-1) then
			if (Char.ItemNum(player, BossKey[1]) > 0) then
				local slot = Char.FindItemId(player, BossKey[1]);
				local item_indexA = Char.GetItemIndex(player,slot);
				Char.DelItem(player, BossKey[1], 1);
				Char.GiveItem(player, 70206, 1);
				Char.Warp(player,0,LeaveMap[1],LeaveMap[2],LeaveMap[3]);
				NLG.SystemMessage(player,"��ϧ����ꇣ������ف������^���I����");
			else
				Char.GiveItem(player, 70206, 1);
				Char.Warp(player,0,LeaveMap[1],LeaveMap[2],LeaveMap[3]);
				NLG.SystemMessage(player,"��ϧ����ꇣ������ف������^���I����");
			end
		else
			for k,v in pairs(BossRoom) do
			if (Char.ItemNum(player, v.keyItem) > 0) then
				local slot = Char.FindItemId(player, v.keyItem);
				local item_indexA = Char.GetItemIndex(player,slot);
				Char.DelItem(player, v.keyItem, v.keyItem_count);
				Char.GiveItem(player, 70206, 5);
				Char.Warp(player,0,LeaveMap[1],LeaveMap[2],LeaveMap[3]);
			end
			end
		end
	end
        return
  end)

end
------------------------------------------------
-------��������
--ս��ǰȫ�ָ�
function Char.HealAll(player)
	Char.SetData(player,%����_Ѫ%, Char.GetData(player,%����_���Ѫ%));
	Char.SetData(player,%����_ħ%, Char.GetData(player,%����_���ħ%));
	Char.SetData(player, %����_����%, 0);
	Char.SetData(player, %����_����%, 0);
	NLG.UpdateParty(player);
	NLG.UpChar(player);
	for petSlot  = 0,4 do
		local petIndex = Char.GetPet(player,petSlot);
		if petIndex >= 0 then
			local maxLp = Char.GetData(petIndex, CONST.CHAR_���Ѫ);
			local maxFp = Char.GetData(petIndex, CONST.CHAR_���ħ);
			Char.SetData(petIndex, CONST.CHAR_Ѫ, maxLp);
			Char.SetData(petIndex, CONST.CHAR_ħ, maxFp);
			Char.SetData(petIndex, %����_����%, 0);
			Pet.UpPet(player, petIndex);
		end
	end
	local PartyNum = Char.PartyNum(player);
	if (PartyNum>1) then
		for Slot=1,4 do
		local TeamPlayer = Char.GetPartyMember(player,Slot);
		if (TeamPlayer>0) then
			Char.SetData(TeamPlayer,%����_Ѫ%, Char.GetData(TeamPlayer,%����_���Ѫ%));
			Char.SetData(TeamPlayer,%����_ħ%, Char.GetData(TeamPlayer,%����_���ħ%));
			Char.SetData(TeamPlayer, %����_����%, 0);
			Char.SetData(TeamPlayer, %����_����%, 0);
			NLG.UpdateParty(TeamPlayer);
			NLG.UpChar(TeamPlayer);
			for petSlot  = 0,4 do
				local petIndex = Char.GetPet(TeamPlayer,petSlot);
				if petIndex >= 0 then
					local maxLp = Char.GetData(petIndex, CONST.CHAR_���Ѫ);
					local maxFp = Char.GetData(petIndex, CONST.CHAR_���ħ);
					Char.SetData(petIndex, CONST.CHAR_Ѫ, maxLp);
					Char.SetData(petIndex, CONST.CHAR_ħ, maxFp);
					Char.SetData(petIndex, %����_����%, 0);
					Pet.UpPet(TeamPlayer, petIndex);
				end
			end
		end
		end
	end
end



function def_round_start(player, callback)

	MapUser = NLG.GetMapPlayer(0,BossMap[1]);
	tbl_win_user = {};
	tbl_duel_user = {};
	table.insert(tbl_duel_user,player);

	--��ʼս��
	tbl_UpIndex = {}
	battleindex = {}

	for k,v in pairs(BossRoom) do
		if (Char.ItemNum(player, v.keyItem)>0)  then
			local slot = Char.FindItemId(player, v.keyItem);
			local item_indexA = Char.GetItemIndex(player,slot);
			local Num = Item.GetData(item_indexA,CONST.����_����);
			local Rank = Item.GetData(item_indexA,CONST.����_����);
			if (Num>=v.posNum_L and Num<v.posNum_R and Rank==v.bossRank)then
				Char.HealAll(player);
				if (v.bossRank==3) then
					NLG.SystemMessage(-1,"" ..v.lordName.. "������:  " ..Char.GetData(player,CONST.CHAR_����).. "�");
				end
				local battleindex = Battle.PVE( player, player, nil, Pos[Num][2], Pos[Num][3], nil)
				Battle.SetWinEvent("./lua/Modules/mazeBoss5.lua", "def_round_wincallback", battleindex);
			end
		end
	end
end

function def_round_wincallback(battleindex, player)

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

	local MapUser = NLG.GetMapPlayer(0, BossMap[1]);
	local player = tbl_win_user[1];

	for k,v in pairs(BossRoom) do
		if (Char.ItemNum(player, v.keyItem)>0) then
			local slot = Char.FindItemId(player, v.keyItem);
			local item_indexA = Char.GetItemIndex(player,slot);
			local Num = Item.GetData(item_indexA,CONST.����_����);
			local Rank = Item.GetData(item_indexA,CONST.����_����);
			if (Num>=v.posNum_L and Num<v.posNum_R and Rank==v.bossRank)then
				Item.SetData(item_indexA,CONST.����_����,Num+1);
				Item.UpItem(player,slot);
			end
		end
	end
	FTime = os.time()
	wincallbackfunc(tbl_win_user);
end

function AutoLord_LoopEvent(_MeIndex)
	local BTime= os.time()
	local timec = BTime - FTime;

	local MapUser = NLG.GetMapPlayer(0, BossMap[1]);
	if (MapUser == -3 and tonumber(#tbl_win_user) == 0 ) then
		Setting = 0;
	elseif (MapUser ~= -3 and tonumber(#tbl_win_user) >= 1 ) then
		Setting = 1;
	elseif (MapUser ~= -3 and tonumber(#tbl_win_user) == 0 ) then
		if (tbl_duel_user[1] ~= nil) then
			local PartyNum = Char.PartyNum(tbl_duel_user[1]);
			local DeadNum = 0;
			for _,w in pairs(MapUser)do
				if (Char.GetData(w,%����_Ѫ%)<=1) then
					DeadNum = DeadNum+1;
				end
			end
			if (PartyNum==-1) then
	 			if (DeadNum==1) then
					Setting = 2;
				end
			elseif (PartyNum>=1) then
				if (DeadNum==PartyNum) then
					Setting = 2;
				end
			end
		else
			return;
		end
	end

	if (Setting == 1) then
		if (timec <= 20) then
			local player = tbl_win_user[1];
			NLG.SystemMessageToMap(0, BossMap[1],"��һ�غϼ����_ʼ��ʣ�N"..tostring(21 - timec).."�롣");
			return;
		else
			local player = tbl_win_user[1];
			if Char.GetBattleIndex(player) >= 0 then
				--print("˫��ս��")
			else
				for _,v in pairs(tbl_win_user) do
					def_round_start(v, 'wincallbackfunc');
				end
				tbl_win_user = {};
				Setting = 0;
			end
		end
	elseif (Setting == 2) then
		wincallbackfunc(tbl_win_user);
		return;
	elseif (Setting == 0) then
		return;
	end
end

function wincallbackfunc(tbl_win_user)
	if (tbl_win_user ~= nil and tonumber(#tbl_win_user) >= 1)then
		-----------------------------------------------------
		for _,w in pairs(tbl_win_user) do
			for k,v in pairs(BossRoom) do
			if (Char.ItemNum(w, v.keyItem)>0) then
				local slot = Char.FindItemId(w, v.keyItem);
				local item_indexA = Char.GetItemIndex(w,slot);
				local Num = Item.GetData(item_indexA,CONST.����_����);
				local Rank = Item.GetData(item_indexA,CONST.����_����);
				if (Num==5 and Rank==v.bossRank) then
					Char.Warp(w,0, 60011, 52, 18);
				end
				if (Num==v.posNum_R and Rank==v.bossRank) then
					Char.DelItem(w, v.keyItem, v.keyItem_count);
					Char.GiveItem(w, v.win.getItem, v.win.getItem_count);
					if (v.bossRank==3) then
						Char.GiveItem(w, 70266, 1);
						NLG.SystemMessage(-1,"��ϲ���: "..Char.GetData(w,%����_����%).."� ӑ���ɹ�"..v.lordName.."��");
					end
					local cdk = Char.GetData(w,CONST.����_CDK);
					SQL.Run("update lua_hook_worldboss set LordEnd5= '1' where CdKey='"..cdk.."'")
					NLG.UpChar(w);
					local PartyNum = Char.PartyNum(w);
					if (PartyNum>1) then
						for Slot=1,4 do
							local TeamPlayer = Char.GetPartyMember(w,Slot);
							if Char.IsDummy(TeamPlayer)==false then
								local cdk = Char.GetData(TeamPlayer,CONST.����_CDK);
								SQL.Run("INSERT INTO lua_hook_worldboss (Name,CdKey) SELECT Name,CdKey FROM tbl_character WHERE NOT EXISTS ( SELECT Name FROM lua_hook_worldboss WHERE tbl_character.CdKey=lua_hook_worldboss.CdKey)");
								SQL.Run("update lua_hook_worldboss set LordEnd5= '1' where CdKey='"..cdk.."'")
								NLG.UpChar(TeamPlayer);
							end
						end
					end
					Char.Warp(w,0, v.win.warpWMap, v.win.warpWX, v.win.warpWY);
					tbl_win_user = {};
					Setting = 0;
					Rank = 0;
				elseif (Num>=v.posNum_L and Num<v.posNum_R and Rank==v.bossRank) then
					Setting = 1;
				end
			end
			end
		end
	else
		-----------------------------------------------------
		local MapUser = NLG.GetMapPlayer(0, BossMap[1]);
		if (MapUser == -3) then
			return;
		else
			warpfailuser(MapUser,tbl_win_user,0,OutMap[1],OutMap[2],OutMap[3]);
			Rank = 0;
			tbl_win_user = {};
			tbl_duel_user = {};

		end
	end
end


--	�������ܣ�����ʧ�ܵ����
function warpfailuser(MapUser,tbl_win_user,floor,mapid,x,y)
	local failuser = delfailuser(MapUser,tbl_win_user);
	for _,tuser in pairs(failuser) do
		Battle.ExitBattle(tuser);
		if (Char.GetData(tuser, CONST.CHAR_����) > 0) then
			Char.SetData(tuser, %����_����%, 0);
			NLG.UpdateParty(tuser);
			NLG.UpChar(tuser);
		end
		Char.Warp(tuser,0,OutMap[1],OutMap[2],OutMap[3]);
		NLG.SystemMessage(tuser,"��ϧ����ꇣ������ف������^���I����");
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

------------------------------------------------
--��������
function Module:OnBattleInjuryCallBack(fIndex, aIndex, battleIndex, inject)
      --self:logDebug('OnBattleInjuryCallBack', fIndex, aIndex, battleIndex, inject)
      local Round = Battle.GetTurn(battleIndex);
      --print(Round)
      local Target_FloorId = Char.GetData(fIndex, CONST.CHAR_��ͼ)
      local defHpE = Char.GetData(fIndex,CONST.CHAR_Ѫ);
      if defHpE >=100 and Target_FloorId==BossMap[1]  then
                 inject = inject*0;
      elseif  Target_FloorId==BossMap[1]  then
                 inject = inject;
      end
  return inject;
end
--������������
function Module:OnbattleStartEventCallback(battleIndex)
	local Sum=0;
	local ret = SQL.Run("select Name,WorldLord5 from lua_hook_worldboss order by WorldLord5 asc limit 3");
	if(type(ret)=="table" and ret["0_1"]~=nil)then
		LordHP5=tonumber(ret["0_1"]);
	end
	for i = 10, 19 do
		local enemy = Battle.GetPlayer(battleIndex, i);
		local HP = LordHP5;
		if enemy>=0 and Char.GetData(enemy, CONST.����_ENEMY_ID)==406220  then
			Char.SetData(enemy, CONST.CHAR_���Ѫ, 1000000);
			Char.SetData(enemy, CONST.CHAR_Ѫ, HP);
		end
	end
end
function Module:OnBeforeBattleTurnCommand(battleIndex)
	local Round = Battle.GetTurn(battleIndex);
	local ret = SQL.Run("select Name,WorldLord5 from lua_hook_worldboss order by WorldLord5 asc limit 3");
	if(type(ret)=="table" and ret["0_1"]~=nil)then
		LordHP5=tonumber(ret["0_1"]);
	end
	--print(LordHP5)
	for i = 10, 19 do
		local enemy = Battle.GetPlayer(battleIndex, i);
		local HP = LordHP5;
		if Round==0 and enemy>=0 and Char.GetData(enemy, CONST.����_ENEMY_ID)==406220  then
			Char.SetData(enemy, CONST.CHAR_���Ѫ, 1000000);     --Ѫ������100��
			Char.SetData(enemy, CONST.CHAR_Ѫ, HP);
			Char.SetData(enemy, CONST.CHAR_������, 420);
		elseif Round>0 and enemy>=0 and Char.GetData(enemy, CONST.����_ENEMY_ID)==406220  then
			Char.SetData(enemy, CONST.CHAR_���Ѫ, 1000000);     --Ѫ������100��
			Char.SetData(enemy, CONST.CHAR_Ѫ, HP);
			Char.SetData(enemy, CONST.CHAR_������, 420);
			if NLG.Rand(1,10)>=5  then
				local BuffData = {CONST.CHAR_BattleReverse, CONST.CHAR_BattleLpRecovery};
				local ch = NLG.Rand(1,2);
				Char.SetData(enemy, BuffData[ch], 1);
			end
			if Round>=5 then
				Char.SetData(enemy, CONST.CHAR_������, 4000);
				Char.SetData(enemy, CONST.CHAR_����, 4000);
				Char.SetData(enemy, CONST.CHAR_����, 100);
				Char.SetData(enemy, CONST.CHAR_����, 100);
				Char.SetData(enemy, CONST.CHAR_����, 30);
			end
			if Round>=4 and Round<=8 then
				Char.SetData(enemy, CONST.����_ENEMY_HeadGraNo,114260);
			elseif Round>=9 then
				Char.SetData(enemy, CONST.����_ENEMY_HeadGraNo,114261);
			end
		end
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
	--ǿӲ������Ѫ���ָ�
	local HP_More={};
	HP_More[1]=1;
	for i = 10, 19 do
		local enemy = Battle.GetPlayer(battleIndex, i);
		if Round>=0 and enemy>=0 and Char.GetData(enemy, CONST.����_ENEMY_ID)==406219  then
                                                            local HP = Char.GetData(enemy,CONST.CHAR_Ѫ);
			if (HP>=HP_More[1]) then
				HP_More[1]=HP;
			else
				HP_More[1]=HP_More[1];
			end
		end
	end
	--ʣ��Ѫ��д���
	for i = 10, 19 do
		local enemy = Battle.GetPlayer(battleIndex, i);
		if Round>=0 and enemy>=0 and Char.GetData(enemy, CONST.����_ENEMY_ID)==406220  then
			local HP = Char.GetData(enemy,CONST.CHAR_Ѫ);
			Char.SetData(enemy, CONST.CHAR_���Ѫ, 1000000);
			Char.SetData(enemy, CONST.CHAR_Ѫ, HP);
			NLG.SystemMessage(player,"[ϵ�y]�^���I��Ŀǰʣ�NѪ��"..HP.."��");
			NLG.UpChar(enemy);
			--LordѪ��д���
			local cdk = Char.GetData(player,CONST.����_CDK) or nil;
			if (cdk~=nil) then
				SQL.Run("INSERT INTO lua_hook_worldboss (Name,CdKey) SELECT Name,CdKey FROM tbl_character WHERE NOT EXISTS ( SELECT Name FROM lua_hook_worldboss WHERE CdKey='"..cdk.."')");
				SQL.Run("update lua_hook_worldboss set WorldLord5= '"..HP.."' where CdKey='"..cdk.."'")
				NLG.UpChar(player);
			end
		elseif Round>=4 and enemy>=0 and Char.GetData(enemy, CONST.����_ENEMY_ID)==406219  then
			Char.SetData(enemy, CONST.CHAR_���Ѫ, 1000000);
			Char.SetData(enemy, CONST.CHAR_Ѫ, HP_More[1]);
			NLG.UpChar(enemy);
		end
	end
end
--����ģʽ����ʩ��
function Module:OnEnemyCommandCallBack(battleIndex, side, slot, action)
      local Round = Battle.GetTurn(battleIndex);
      for i = 10, 19 do
            local enemy = Battle.GetPlayer(battleIndex, i);
            if Round>=10 and Round<=14 and enemy>= 0 and Char.GetData(enemy, CONST.����_ENEMY_ID)==406220  then
                          SetCom(enemy, action, CONST.BATTLE_COM.BATTLE_COM_M_DEATH, 40, 8609);
            elseif Round>=15 and enemy>= 0 and Char.GetData(enemy, CONST.����_ENEMY_ID)==406220  then
                          SetCom(enemy, action, CONST.BATTLE_COM.BATTLE_COM_M_DEATH, 40, 8659);
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

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;