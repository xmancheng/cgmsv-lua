---ģ����
local Module = ModuleBase:createModule('deathJJC')
local ItemMenus = {
  { "[��������G��ʯ������]x1����������60", 661061, 60, 1},
  { "[��������֮����������]x1����������30", 70162, 20, 1},
  { "[��������׃���ġ�����]x1����������20", 72000, 20, 1},
  { "[��������ɫ�X�ѡ�����]x5����������10", 69157, 10, 5},
  { "[�������y�ſ���������]x2����������10", 68001, 10, 2},
  { "[�����������e��ȯ����]x10��������10", 69000, 10, 10},
}

local EnemySet = {}
local BaseLevelSet = {}
local Pos = {}
--local STime = os.time()
--local YS = 30 --�ű���ʱ�����봴��NPC
--local SXTime = 15 --NPCˢ��ʱ�䡤��
local FTime = os.time()
local Setting = 0;
--���н���
--     ��(4)	��(2)	һ(0)	��(1)	��(3)
--     ʮ(9)	��(7)	��(5)	��(6)	��(8)
------------��սNPC����------------
EnemySet[1] = {700000, 0, 0, 0, 0, 710001, 0, 0, 0, 0}    --0����û�й�
EnemySet[2] = {700001, 0, 0, 0, 0, 710002, 0, 0, 0, 0}
EnemySet[3] = {700002, 0, 0, 0, 0, 710003, 0, 0, 0, 0}
EnemySet[4] = {700003, 0, 0, 0, 0, 710004, 0, 0, 0, 0}
EnemySet[5] = {700004, 0, 0, 0, 0, 710005, 0, 0, 0, 0}
EnemySet[6] = {700000, 700001, 700002, 0, 0, 710001, 710002, 710003, 0, 0}
EnemySet[7] = {700003, 700004, 700005, 0, 0, 710004, 710005, 710006, 0, 0}
EnemySet[8] = {700006, 700007, 700008, 0, 0, 710007, 710008, 710009, 0, 0}
EnemySet[9] = {700009, 700010, 700011, 0, 0, 710010, 710011, 710012, 0, 0}
EnemySet[10] = {700012, 700013, 700014, 0, 0, 710013, 710014, 710015, 0, 0}
EnemySet[11] = {700000, 700001, 700002, 700003, 700004, 710001, 710002, 710003, 710004, 710005}
EnemySet[12] = {700000, 700001, 700002, 700003, 700004, 710001, 710002, 710003, 710004, 710005}
EnemySet[13] = {700000, 700001, 700002, 700003, 700004, 710001, 710002, 710003, 710004, 710005}
EnemySet[14] = {700000, 700001, 700002, 700003, 700004, 710001, 710002, 710003, 710004, 710005}
EnemySet[15] = {700000, 700001, 700002, 700003, 700004, 710001, 710002, 710003, 710004, 710005}
BaseLevelSet[1] = {160, 0, 0, 0, 0, 160, 0, 0, 0, 0}
BaseLevelSet[2] = {160, 0, 0, 0, 0, 160, 0, 0, 0, 0}
BaseLevelSet[3] = {160, 0, 0, 0, 0, 160, 0, 0, 0, 0}
BaseLevelSet[4] = {160, 0, 0, 0, 0, 160, 0, 0, 0, 0}
BaseLevelSet[5] = {160, 0, 0, 0, 0, 160, 0, 0, 0, 0}
BaseLevelSet[6] = {160, 160, 160, 0, 0, 160, 160, 160, 0, 0}
BaseLevelSet[7] = {160, 160, 160, 0, 0, 160, 160, 160, 0, 0}
BaseLevelSet[8] = {160, 160, 160, 0, 0, 160, 160, 160, 0, 0}
BaseLevelSet[9] = {160, 160, 160, 0, 0, 160, 160, 160, 0, 0}
BaseLevelSet[10] = {160, 160, 160, 0, 0, 160, 160, 160, 0, 0}
BaseLevelSet[11] = {160, 160, 160, 160, 160, 160, 160, 160, 160, 160}
BaseLevelSet[12] = {160, 160, 160, 160, 160, 160, 160, 160, 160, 160}
BaseLevelSet[13] = {160, 160, 160, 160, 160, 160, 160, 160, 160, 160}
BaseLevelSet[14] = {160, 160, 160, 160, 160, 160, 160, 160, 160, 160}
BaseLevelSet[15] = {160, 160, 160, 160, 160, 160, 160, 160, 160, 160}
Pos[1] = {"�����C��",EnemySet[1],BaseLevelSet[1]}      -- ����(1~5)
Pos[2] = {"�����C��",EnemySet[2],BaseLevelSet[2]}
Pos[3] = {"�����C��",EnemySet[3],BaseLevelSet[3]}
Pos[4] = {"�����C��",EnemySet[4],BaseLevelSet[4]}
Pos[5] = {"�����C��",EnemySet[5],BaseLevelSet[5]}
Pos[6] = {"�����C��",EnemySet[6],BaseLevelSet[6]}                  -- �߼�(6~10)
Pos[7] = {"�����C��",EnemySet[7],BaseLevelSet[7]}
Pos[8] = {"�����C��",EnemySet[8],BaseLevelSet[8]}
Pos[9] = {"�����C��",EnemySet[9],BaseLevelSet[9]} 
Pos[10] = {"�����C��",EnemySet[10],BaseLevelSet[10]}
Pos[11] = {"�����C��",EnemySet[11],BaseLevelSet[11]}             -- ����(11~15)
Pos[12] = {"�����C��",EnemySet[12],BaseLevelSet[12]}
Pos[13] = {"�����C��",EnemySet[13],BaseLevelSet[13]}
Pos[14] = {"�����C��",EnemySet[14],BaseLevelSet[14]}
Pos[15] = {"�����C��",EnemySet[15],BaseLevelSet[15]}
------------------------------------------------
local CharSet = {700000,700001,700002,700003,700004,700005,700006,700007,700008,700009,700010,
                                             700011,700012,700013,700014,700015,700016,700017,700018,700019,700020,
                                             700021,700022,700023,700024,700025,700026,700027,700028,700029,700030}
local PetSet = {710001,710002,710003,710004,710005,710006,710007,710008,710009,710010,
                            710011,710012,710013,710014,710015,710016,710017,710018,710019,710020,
                            710021,710022,710023,710024,710025,710026,710027,710028,710029,710030,
                            710031,710032,710033,710034,710035,710036,710037,710038,710039,710040,
                            710041,710042,710043,710044,710045,710046,710047,710048,710049,710050,
                            710051,710052,710053,710054,710055,710056,710057,710058,710059}
------------------------------------------------
--��������
local Switch = 1;                          --����������ƿ���1��0��
local Rank = 0;                             --�Ѷȷ���
local BossMap= {25292,24,25} -- ս������Floor,X,Y(�����ߡ���ͬ����)
local OutMap= {25293,35,14}  -- ʧ�ܴ���Floor,X,Y(�����ߡ���ͬ����)
local LeaveMap= {1000,237,99}  -- �뿪����Floor,X,Y(�����ߡ���ͬ����)
local BossKey= {70213,70213,70213} -- �������߼�������
local Pts= 69000;                        --����ȯ
local BossRoom = {
      { key=1, keyItem=70213, keyItem_count=1, bossRank=1, limit=-1, posNum_L=1, posNum_R=6,
          win={warpWMap=1000, warpWX=237, warpWY=99, getItem = 69000, getItem_count = 5},
          lose={warpLMap=25293, warpLX=35, warpLY=14, getItem = 69000, getItem_count = 1},
       },    -- ����(1~5)
      { key=3, keyItem=70213, keyItem_count=1, bossRank=2, limit=3, posNum_L=6, posNum_R=11,
          win={warpWMap=1000, warpWX=237, warpWY=99, getItem = 69000, getItem_count = 10},
          lose={warpLMap=25293, warpLX=35, warpLY=14, getItem = 69000, getItem_count = 1},
       },    -- �߼�(6~10)
      { key=5, keyItem=70213, keyItem_count=1, bossRank=3, limit=5, posNum_L=11, posNum_R=16,
          win={warpWMap=1000, warpWX=237, warpWY=99, getItem = 69000, getItem_count = 20},
          lose={warpLMap=25293, warpLX=35, warpLY=14, getItem = 69000, getItem_count = 1},
       },    -- ����(11~15)
}
tbl_duel_user = {};			--��ǰ������ҵ��б�
tbl_win_user = {};
------------------------------------------------
--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BattleSurpriseEvent', Func.bind(self.OnBattleSurpriseCallBack, self))
  self:regCallback('BattleInjuryEvent', Func.bind(self.OnBattleInjuryCallBack, self))
  local deathnpc = self:NPC_createNormal('��������������', 235174, { map = 1000, x = 237, y = 98, direction = 4, mapType = 0 })
  self:regCallback('LoopEvent', Func.bind(self.AutoRanking_LoopEvent,self))
  self:NPC_regWindowTalkedEvent(deathnpc, function(npc, player, _seqno, _select, _data)
	local cdk = Char.GetData(player,CONST.����_CDK);
	local seqno = tonumber(_seqno)
	local select = tonumber(_select)
	local data = tonumber(_data)			
	if seqno == 1 then
		if data == 2 then  ----������ս
			if(Char.ItemNum(player,BossKey[1])>0 or Char.ItemNum(player,BossKey[2])>0 or Char.ItemNum(player,BossKey[3])>0) then
				NLG.SystemMessage(player,"[ϵ�y]�M�����������������κ��Y���倡�");
				return;
			else
				local msg = "3\\n@c�x��������������ģʽ\\n"
					.."\\n�����T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T"
					.. "\\n����������1�ˡ�VS��1��\\n"
					.. "\\n�߼�������3�ˡ�VS��3��\\n"
					.. "\\n�^��������5�ˡ�VS��5��\\n";
				NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, CONST.BUTTON_�ر�, 21, msg);
			end
		end
		if data == 3 then  ----�ۿ�˵��
			if (NLG.CanTalk(npc, player) == true) then
			local msg = "\\n@cՈԔ����x���������f��\\n"
				.. "\\n�x��1�ˡ�3�ˡ�5�˵Ĺ���ģʽ\\n"
				.. "\\n�M��������_ʼ�Ԅ��䌦���Y\\n"
				.. "\\n���ˑ��ٿɫ@��Խ��e��\\n"
				.. "\\n����ʧ����1���e��\\n";
			NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.BUTTON_ȷ��, 31, msg);
			end
		end
		if data == 4 then  ----���г����ս
			if (tbl_duel_user~=nil) then
			local msg = "3\\n@c���������^����\\n"
				.."\\n�����T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n";
				for i = 1, #tbl_duel_user do
				local duelplayer = tbl_duel_user[i];
				local duelplayerName = Char.GetData(duelplayer,CONST.CHAR_����);
				local rankLevel = {"����","�߼�","�^��"};
				if (duelplayerName~=nil and Rank>=1) then
					msg = msg .. duelplayerName .. "��VS��".. rankLevel[Rank] .."����\\n"
				end
			end
			NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, CONST.BUTTON_�ر�, 41, msg);
			else
				return;
			end
		end
		if data == 5 then  ----��½���ڻ���
			if (NLG.CanTalk(npc, player) == true) then
			local key = Char.FindItemId(player,Pts);
			local item = Char.GetItemIndex(player,key);
			local PointCount = Char.ItemNum(player,Pts);
			local msg = "\\n@c����L�ڸ����e��\\n"
				.. "\\n�����T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
				.. "\\n�������e��ȯ����".. PointCount .. "��ȫ���ς���?\\n";
			NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.BUTTON_�Ƿ�, 51, msg);
			end
		end
		if data == 6 then  ----��ѯ����&ִ��
			if (NLG.CanTalk(npc, player) == true) then
			local PointCount = tonumber(SQL.Run("select RankedPoints from lua_hook_character where CdKey='"..cdk.."'")["0_0"])
			local msg = "\\n@c��ԃ�����c������\\n"
				.. "\\n�����T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
				.. "\\n�������e�֡�����".. PointCount .. "ȯ\\n";
			NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.BUTTON_ȷ��, 61, msg);
			end
		end
		if data == 7 then  ----�һ�����
			if (NLG.CanTalk(npc, player) == true) then
			local msg = "3\\n@c���Q���������\\n"
				.."\\n�����T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n";
				for i = 1, 6 do
					msg = msg .. ItemMenus[i][1] .. "\\n"
				end
			NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, CONST.BUTTON_�ر�, 71, msg);
			end
		end
	end
	------------------------------------------------------------
	if seqno == 21 then  ----������սִ��
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
				.. "\\n�M����ؼ��_ʼ�Ԅ��䌦���Y\\n"
				.. "\\n��������ȫ��������o��L\\n"
				.. "\\nՈ������Ʒ�c��т�����\\n";
				NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.BUTTON_ȷ��, 22, msg);
				return;
			end
			for k,v in pairs(BossRoom) do
				if ( key==v.key ) then
					if( Switch==1 and Char.PartyNum(player) ~= v.limit) then
						local msg = "\\n\\n\\n\\n@c�����蜐�����_�˔�����\\n";
						NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.BUTTON_ȷ��, 23, msg);
						return;
					elseif( Switch==1 and Char.PartyNum(player) == v.limit) then
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
						Char.SetLoopEvent('./lua/Modules/deathJJC.lua','AutoRanking_LoopEvent',player,1000);
					elseif( Switch==0) then
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
						Char.SetLoopEvent('./lua/Modules/deathJJC.lua','AutoRanking_LoopEvent',player,1000);
					end
				end
			end
			def_round_start(player, 'wincallbackfunc');
		else
			return 0;
		end
	end
	if seqno == 41 then  ----���г����ս&ִ��
		key = data
		local duelplayer= tbl_duel_user[key];
		if ( duelplayer ~= nil ) then
			NLG.WatchEntry(player, tonumber(duelplayer));
		else
			return 0;
		end
	end
	if seqno == 51 then  ----��½���ڻ���ִ��
		if select == 4 then
			local key = Char.FindItemId(player,Pts);
			local item = Char.GetItemIndex(player,key);
			local PointCount = Char.ItemNum(player,Pts);
			local Restcount = tonumber(SQL.Run("select RankedPoints from lua_hook_character where CdKey='"..cdk.."'")["0_0"])
			local Restcount = Restcount + PointCount;
			SQL.Run("update lua_hook_character set RankedPoints= '"..Restcount.."' where CdKey='"..cdk.."'")
			NLG.UpChar(player);
			Char.DelItem(player,Pts,PointCount);
			NLG.SystemMessage(player,"[ϵ�y]�ѳɹ��ς����и����e��ȯ��");
		else
			return 0;
		end
	end
	if seqno == 71 then  ----�һ�����ִ��
		key = data
		if select == 2 then
			return;
		end
		if key == data then
			local PointCount = tonumber(SQL.Run("select RankedPoints from lua_hook_character where CdKey='"..cdk.."'")["0_0"])
			local itemcost= ItemMenus[data][3];
			if ( PointCount >= itemcost ) then
				local Restcount = PointCount - itemcost;
				SQL.Run("update lua_hook_character set RankedPoints= '"..Restcount.."' where CdKey='"..cdk.."'")
				NLG.UpChar(player);
				Char.GiveItem(player,ItemMenus[data][2],ItemMenus[data][4]);
			else
				NLG.SystemMessage(player,"[ϵ�y]�����e�֔������㣡");
				return 0;
			end
		end
	end
  end)
  self:NPC_regTalkedEvent(deathnpc, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
               local msg = "1\\n@c�gӭ�M����������������\\n\\n"
                                             .."[��������������]\\n" 
                                             .."[���^�������f����]\\n" 
                                             .."[���M�Ј����^��]\\n" 
                                             .."[������L�ڷe�֡�]\\n" 
                                             .."[����ԃ�����c����]\\n" 
                                             .."[�����Q�������]\\n" ;
               NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, CONST.BUTTON_�ر�, 1, msg);
    end
    return
  end)


  local deathLosenpc = self:NPC_createNormal('��̭�I��̎', 235175, { map = 25293, x = 36, y = 13, direction = 6, mapType = 0 })
  self:NPC_regWindowTalkedEvent(deathLosenpc, function(npc, player, _seqno, _select, _data)
  end)
  self:NPC_regTalkedEvent(deathLosenpc, function(npc, player)
	if (NLG.CanTalk(npc, player) == true) then
		if (Char.PartyNum(player)==-1) then
			if (Char.ItemNum(player, BossKey[1]) > 0) then
				local slot = Char.FindItemId(player, BossKey[1]);
				local item_indexA = Char.GetItemIndex(player,slot);
				Char.DelItem(player, BossKey[1], 1);
				Char.GiveItem(player, 69000, 1);
				Char.Warp(player,0,LeaveMap[1],LeaveMap[2],LeaveMap[3]);
			else
				Char.Warp(player,0,LeaveMap[1],LeaveMap[2],LeaveMap[3]);
			end
		else
			for k,v in pairs(BossRoom) do
			if (Char.ItemNum(player, v.keyItem) > 0) then
				local slot = Char.FindItemId(player, v.keyItem);
				local item_indexA = Char.GetItemIndex(player,slot);
				Char.DelItem(player, v.keyItem, v.keyItem_count);
				Char.GiveItem(player, v.lose.getItem, v.lose.getItem_count);
				Char.Warp(player,0,v.win.warpWMap,v.win.warpWX,v.win.warpWY);
			end
			end
		end
	end
        return
  end)


end

function SetEnemySet(Rank)
	local xr = NLG.Rand(1,3);
	for i=1,#CharSet-1-xr do
		r = NLG.Rand(1,i+1+xr);
		temp=CharSet[r];
		CharSet[r]=CharSet[i];
		CharSet[i]=temp;
	end
	for i=1,#PetSet-1-xr do
		r = NLG.Rand(1,i+1+xr);
		temp=PetSet[r];
		PetSet[r]=PetSet[i];
		PetSet[i]=temp;
	end
	local ix=1;
	if Rank==1 then    -- ����
		for k=1,5 do
			EnemySet[k][1]=CharSet[ix];
			EnemySet[k][6]=PetSet[ix];
			ix=ix+1;
		end
	elseif Rank==2 then    -- �߼�
		for k=6,10 do
			EnemySet[k][1]=CharSet[ix];
			EnemySet[k][2]=CharSet[ix+1];
			EnemySet[k][3]=CharSet[ix+2];
			EnemySet[k][6]=PetSet[ix];
			EnemySet[k][7]=PetSet[ix+1];
			EnemySet[k][8]=PetSet[ix+2];
			ix=ix+1;
		end
	elseif Rank==3 then    -- ����
		for k=11,15 do
			EnemySet[k][1]=CharSet[ix];
			EnemySet[k][2]=CharSet[ix+1];
			EnemySet[k][3]=CharSet[ix+2];
			EnemySet[k][4]=CharSet[ix+3];
			EnemySet[k][5]=CharSet[ix+4];
			EnemySet[k][6]=PetSet[ix];
			EnemySet[k][7]=PetSet[ix+1];
			EnemySet[k][8]=PetSet[ix+2];
			EnemySet[k][9]=PetSet[ix+3];
			EnemySet[k][10]=PetSet[ix+4];
			ix=ix+1;
		end
	end
end

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
	--battleindex[player] = Battle.PVP(tbl_UpIndex[1], player);
	--Battle.SetPVPWinEvent('./lua/Modules/deathJJC.lua', 'def_round_wincallback', battleindex);

	for k,v in pairs(BossRoom) do
		if (Char.ItemNum(player, v.keyItem)>0)  then
			local slot = Char.FindItemId(player, v.keyItem);
			local item_indexA = Char.GetItemIndex(player,slot);
			local Num = Item.GetData(item_indexA,CONST.����_����);
			local Rank = Item.GetData(item_indexA,CONST.����_����);
			if (Num>=v.posNum_L and Num<v.posNum_R and Rank==v.bossRank)then
				Char.HealAll(player);
				SetEnemySet(Rank);
				NLG.SystemMessage(-1,"����M��:"..Pos[Num][1].." VS "..Char.GetData(player,%����_����%));
				local battleindex = Battle.PVE( player, player, nil, Pos[Num][2], Pos[Num][3], nil)
				Battle.SetGainMode(battleindex, CONST.ս��_PVP);
				Battle.SetWinEvent("./lua/Modules/deathJJC.lua", "def_round_wincallback", battleindex);
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
	for _,w in pairs(MapUser)do
		if (Char.GetData(w, %����_����%) > 0) then
		Char.SetData(w, %����_����%, 0);
		NLG.UpdateParty(w);
		NLG.UpChar(w);
		end
	end
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

function AutoRanking_LoopEvent(_MeIndex)
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
		if (timec <= 30) then
			local player = tbl_win_user[1];
			if Char.GetData(player,CONST.CHAR_���Ŀ���) == 1  then
				NLG.SystemMessageToMap(0, BossMap[1],"����������һ�غϼ����_ʼ��ʣ�N"..tostring(31 - timec).."�롣");
			end
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
				if (Num==v.posNum_R and Rank==v.bossRank) then
					Char.DelItem(w, v.keyItem, v.keyItem_count);
					Char.GiveItem(w, v.win.getItem, v.win.getItem_count);
					NLG.SystemMessage(-1,"��ϲ���: "..Char.GetData(w,%����_����%).." ��������������܊��");
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
		NLG.SystemMessage(tuser,"��ݔ�ˣ����x���c����������������");
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
--͵Ϯ����������
function Module:OnBattleSurpriseCallBack(battleIndex, result)
      --self:logDebug('OnBattleSurpriseCallBack', battleIndex, result)
      local Round = Battle.GetTurn(battleIndex);
      --print(Round)
      local APN = 0; 
      for i = 0, 9 do
            local charIndex = Battle.GetPlayer(battleIndex, i);
            local AP = Char.GetData(charIndex,CONST.CHAR_������);
            if charIndex >= 0 and AP>=1500  then
                 APN = APN+1;
            else
                 APN = APN;
            end
      end
      if APN>=1 then
            if Char.GetData(Battle.GetPlayer(battleIndex, 0),CONST.CHAR_���Ŀ���) == 1  then
                  NLG.SystemMessageToMap(0, BossMap[1],"�O����K��������������͸�ˣ�����̫��Ҳ�Ǖ��l��żȻ����������");
            end
            result=2;
      else
            result=0;
      end
  return result;
end
function Module:OnBattleInjuryCallBack(fIndex, aIndex, battleIndex, inject)
      --self:logDebug('OnBattleInjuryCallBack', fIndex, aIndex, battleIndex, inject)
      local Round = Battle.GetTurn(battleIndex);
      --print(Round)
      local defHpE = Char.GetData(fIndex,CONST.CHAR_Ѫ);
      if  defHpE >=100  then
                 inject = inject*0;
      else
                 inject = inject;
      end
  return inject;
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;