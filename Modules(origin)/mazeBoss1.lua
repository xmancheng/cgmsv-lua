---ģ����
local Module = ModuleBase:createModule('mazeBoss1')

local EnemySet = {}
local BaseLevelSet = {}
local Pos = {}
--local FTime = os.time()
--local Setting = 0;
--���н���
--     ��(4)	��(2)	һ(0)	��(1)	��(3)
--     ʮ(9)	��(7)	��(5)	��(6)	��(8)
------------��սNPC����------------
local BossEnemyId = 320134;		--����ģʽ�趨����
EnemySet[1] = {0, 320124, 320124, 0, 0, 320134, 0, 0, 320124, 320124}    --0����û�й�
BaseLevelSet[1] = {0, 105, 105, 0, 0, 110, 0, 0, 105, 105}
Pos[1] = {"���Fɭ��֮��",EnemySet[1],BaseLevelSet[1]}
------------------------------------------------
--��������
--local Switch = 0;					--����������ƿ���1��0��
--local Rank = 0;						--��ʼ���Ѷȷ���
--local BossMap= {60003,40,9}			-- ս������Floor,X,Y
--local OutMap= {1000,242,88}			-- ʧ�ܴ���Floor,X,Y
local LeaveMap= {1000,242,88}		-- �뿪����Floor,X,Y
local BossKey= {70195}				-- ��ͨ(���п���)
local Pts= 70058;					-- ħ�����
local BossRoom = {
      { key=1, keyItem=70195, keyItem_count=1, bossRank=3, limit=5, posNum_L=3, posNum_R=4,
          win={warpWMap=1000, warpWX=242, warpWY=88, getItem = 70075, getItem_count = 50},
          lordName="���Fɭ��֮��",
       },    -- ��ͨ(2)
}
local tbl_duel_user = {};			--��ǰ������ҵ��б�
local tbl_win_user = {};
------------------------------------------------
--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BattleStartEvent', Func.bind(self.OnbattleStartEventCallback, self))
  self:regCallback('BeforeBattleTurnEvent', Func.bind(self.OnBeforeBattleTurnCommand, self))
  self:regCallback('AfterBattleTurnEvent', Func.bind(self.OnAfterBattleTurnCommand, self))
  self:regCallback('EnemyCommandEvent', Func.bind(self.OnEnemyCommandCallBack, self))
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
  self:regCallback('BattleInjuryEvent', Func.bind(self.OnBattleInjuryCallBack, self))
  local Lord1Npc = self:NPC_createNormal('���oʯ��', 11394, { map = 7900, x = 17, y = 0, direction = 6, mapType = 0 })
  Char.SetData(Lord1Npc,CONST.����_ENEMY_PetFlg+2,0)--�ɴ�͸��
  self:regCallback('LoopEvent', Func.bind(self.AutoLord_LoopEvent,self))
  self:NPC_regWindowTalkedEvent(Lord1Npc, function(npc, player, _seqno, _select, _data)
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
		if select == CONST.��ť_�ر� then
			return;
		elseif select == CONST.��ť_��һҳ then  ----�μ������ַ�
			--[[local retEnd = SQL.Run("select Name,LordEnd1 from lua_hook_worldboss order by LordEnd1 desc ");
			if (type(retEnd)=="table" and retEnd["0_1"]~=nil) then
				worldLayer = tonumber(retEnd["0_1"]);
			end]]
			--print(worldLayer)
			--if(Char.ItemNum(player,BossKey[1])>0) then
				--NLG.SystemMessage(player,"[ϵ�y]���M��ӑ�����ܳ����^�ڑ{�C��");
				--return;
			--elseif (Char.ItemNum(player,16440)<=0) then
				--NLG.SystemMessage(player,"[ϵ�y]��̎��������ӡӛ���ƺ��Ҫ������������Q��");
				--return;
			--else
				local msg = "\\n���Fɭ��֮����\\n\\n"
					.."������ĕr�����ߣ����Ƿ�߂����c������\\n"
					.."���������@���ϵĘ侫�L�ρ��M��ԇ����\\n"
					.."��ͨ�^����������_ʼǰ�����r֮�����;��\\n";
				NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 11, msg);
			--end
		end

	end
	------------------------------------------------------------
	if seqno == 11 then  ----����ģʽִ��
		--key = data+4
		if select == CONST.��ť_�� then
			return;
		elseif select == CONST.��ť_�� then
			if ret and #WorldDate > 0 then
				if WorldDate[1][1]==os.date("%w",os.time()) then
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
			local playerName = Char.GetData(player,CONST.����_����);
			--print(key)
			--[[local MapUser = NLG.GetMapPlayer(0, BossMap[1]);
			if (MapUser ~= -3 ) then
				local msg = "\\n@cՈ�ȴ�ǰһ�M������\\n"
				.. "\\nÿ��ֻ׼�Sһ��M�з��g����\\n"
				.. "\\n�M���I�����������������Y\\n"
				.. "\\n��������ȫ��������o��L\\n"
				.. "\\nՈ������Ʒ�c���т�����\\n";
				NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.��ť_ȷ��, 22, msg);
				return;
			end]]
			--Rank = BossRoom[1].bossRank;
			Char.HealAll(player);
			--Char.GiveItem(player, BossRoom[1].keyItem, BossRoom[1].keyItem_count);
			--local slot = Char.FindItemId(player, BossRoom[1].keyItem);
			--local item_indexA = Char.GetItemIndex(player,slot);
			--Item.SetData(item_indexA,CONST.����_����, BossRoom[1].posNum_L);
			--Item.SetData(item_indexA,CONST.����_����, BossRoom[1].bossRank);
			--Item.UpItem(player,slot);
			table.insert(tbl_duel_user,player);
			--Char.Warp(player,0, BossMap[1], BossMap[2], BossMap[3]);
			--Char.SetLoopEvent('./lua/Modules/mazeBoss1.lua','AutoLord_LoopEvent',player,1000);
			--WorldDate = {}
			WorldDate[1] = {
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
			def_round_start(player, 'wincallbackfunc');
		else
			return 0;
		end
	end


  end)
  self:NPC_regTalkedEvent(Lord1Npc, function(npc, player)
	if (NLG.CanTalk(npc, player) == true) then
		local msg = "\\n���Fɭ��֮����\\n\\n"
				.."���r֮����һȺ����축r�g�����е����o��\\n"
				.."����ؓ�ƿؕr�g��Ƭ�����g���sҲ�����L�q�µ�\\n"
				.."�����g��u׃��̓�������ľ��������Ƿ��̵ĳ�\\n"
				.."��患�����Ư�����϶߅���ġ��r֮�һ����\\n"
				.."������r���cħ�����Y���ɵ��o�k�}��\\n";
		NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.��ť_��ȡ��, 1, msg);
	end
	return
  end)


  --[[local Leave1Npc = self:NPC_createNormal('���xɳ©', 235179, { map = 60003, x = 41, y = 9, direction = 6, mapType = 0 })
  self:NPC_regWindowTalkedEvent(Leave1Npc, function(npc, player, _seqno, _select, _data)
  end)
  self:NPC_regTalkedEvent(Leave1Npc, function(npc, player)
	if (NLG.CanTalk(npc, player) == true) then
		if (Char.PartyNum(player)==-1) then
			if (Char.ItemNum(player, BossKey[1]) > 0) then
				local slot = Char.FindItemId(player, BossKey[1]);
				local item_indexA = Char.GetItemIndex(player,slot);
				Char.DelItem(player, BossKey[1], 1);
				Char.GiveItem(player, 70206, 1);
				Char.Warp(player,0,LeaveMap[1],LeaveMap[2],LeaveMap[3]);
				NLG.SystemMessage(player,"��ϧ����ꇣ������ف�����ħ���I����");
			else
				Char.GiveItem(player, 70206, 1);
				Char.Warp(player,0,LeaveMap[1],LeaveMap[2],LeaveMap[3]);
				NLG.SystemMessage(player,"��ϧ����ꇣ������ف�����ħ���I����");
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
  ]]

end
------------------------------------------------
-------��������
--ս��ǰȫ�ָ�
function Char.HealAll(player)
	Char.SetData(player,CONST.����_Ѫ, Char.GetData(player,CONST.����_���Ѫ));
	Char.SetData(player,CONST.����_ħ, Char.GetData(player,CONST.����_���ħ));
	Char.SetData(player, CONST.����_����, 0);
	Char.SetData(player, CONST.����_����, 0);
	NLG.UpdateParty(player);
	NLG.UpChar(player);
	for petSlot  = 0,4 do
		local petIndex = Char.GetPet(player,petSlot);
		if petIndex >= 0 then
			local maxLp = Char.GetData(petIndex, CONST.����_���Ѫ);
			local maxFp = Char.GetData(petIndex, CONST.����_���ħ);
			Char.SetData(petIndex, CONST.����_Ѫ, maxLp);
			Char.SetData(petIndex, CONST.����_ħ, maxFp);
			Char.SetData(petIndex, CONST.����_����, 0);
			Pet.UpPet(player, petIndex);
		end
	end
	local PartyNum = Char.PartyNum(player);
	if (PartyNum>1) then
		for Slot=1,4 do
		local TeamPlayer = Char.GetPartyMember(player,Slot);
		if (TeamPlayer>0) then
			Char.SetData(TeamPlayer,CONST.����_Ѫ, Char.GetData(TeamPlayer,CONST.����_���Ѫ));
			Char.SetData(TeamPlayer,CONST.����_ħ, Char.GetData(TeamPlayer,CONST.����_���ħ));
			Char.SetData(TeamPlayer, CONST.����_����, 0);
			Char.SetData(TeamPlayer, CONST.����_����, 0);
			NLG.UpdateParty(TeamPlayer);
			NLG.UpChar(TeamPlayer);
			for petSlot  = 0,4 do
				local petIndex = Char.GetPet(TeamPlayer,petSlot);
				if petIndex >= 0 then
					local maxLp = Char.GetData(petIndex, CONST.����_���Ѫ);
					local maxFp = Char.GetData(petIndex, CONST.����_���ħ);
					Char.SetData(petIndex, CONST.����_Ѫ, maxLp);
					Char.SetData(petIndex, CONST.����_ħ, maxFp);
					Char.SetData(petIndex, CONST.����_����, 0);
					Pet.UpPet(TeamPlayer, petIndex);
				end
			end
		end
		end
	end
end



function def_round_start(player, callback)

	--MapUser = NLG.GetMapPlayer(0,BossMap[1]);
	tbl_win_user = {};
	tbl_duel_user = {};
	table.insert(tbl_duel_user,player);

	--��ʼս��
	tbl_UpIndex = {}
	battleindex = {}


	Char.HealAll(player);
	NLG.SystemMessage(-1,"" ..BossRoom[1].lordName.. "������: " ..Char.GetData(player,CONST.����_����));
	local battleindex = Battle.PVE( player, player, nil, Pos[1][2], Pos[1][3], nil)
	Battle.SetWinEvent("./lua/Modules/mazeBoss1.lua", "def_round_wincallback", battleindex);

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
	if ( Char.GetData(w1, CONST.����_����) == CONST.��������_�� ) then
		local ww = w1;
		table.insert(tbl_win_user, ww);
	elseif ( Char.GetData(w2, CONST.����_����) >= CONST.��������_�� ) then
		local ww = w2;
		table.insert(tbl_win_user, ww);
	else
		local ww = nil;
	end

	--local MapUser = NLG.GetMapPlayer(0, BossMap[1]);
	local player = tbl_win_user[1];

	--FTime = os.time()
	--wincallbackfunc(tbl_win_user);
	Char.GiveItem(player, 70258, 1);
	NLG.SystemMessage(-1,"��ϲ���:"..Char.GetData(player,CONST.����_����).." ӑ���ɹ�"..BossRoom[1].lordName.."��");

	local cdk = Char.GetData(player,CONST.����_CDK);
	SQL.Run("update lua_hook_worldboss set LordEnd1= '1' where CdKey='"..cdk.."'")
	NLG.UpChar(player);
	local PartyNum = Char.PartyNum(player);
	if (PartyNum>1) then
		for Slot=1,4 do
			local TeamPlayer = Char.GetPartyMember(player,Slot);
			if Char.IsDummy(TeamPlayer)==false then
				local cdk = Char.GetData(TeamPlayer,CONST.����_CDK);
				--SQL.Run("INSERT INTO lua_hook_worldboss (Name,CdKey) SELECT Name,CdKey FROM tbl_character WHERE NOT EXISTS ( SELECT Name FROM lua_hook_worldboss WHERE tbl_character.CdKey=lua_hook_worldboss.CdKey)");
				SQL.Run("update lua_hook_worldboss set LordEnd1= '1' where CdKey='"..cdk.."'")
				NLG.UpChar(TeamPlayer);
			end
		end
	end
	Char.Warp(player,0, BossRoom[1].win.warpWMap, BossRoom[1].win.warpWX, BossRoom[1].win.warpWY);
	tbl_win_user = {};

	Battle.UnsetWinEvent(battleindex);
end

------------------------------------------------
--��������
function Module:OnBattleInjuryCallBack(fIndex, aIndex, battleIndex, inject)
      --self:logDebug('OnBattleInjuryCallBack', fIndex, aIndex, battleIndex, inject)
      local Round = Battle.GetTurn(battleIndex);
      --print(Round)
      local Target_FloorId = Char.GetData(fIndex, CONST.����_��ͼ)
      local defHpE = Char.GetData(fIndex,CONST.����_Ѫ);
      if defHpE >=100 and Target_FloorId==7900  then
                 inject = inject*0;
      elseif  Target_FloorId==7900  then
                 inject = inject;
      end
  return inject;
end
--������������
function Module:OnbattleStartEventCallback(battleIndex)
	local Round = Battle.GetTurn(battleIndex);
	local leader0 = Battle.GetPlayer(battleIndex, 0);
	local leaderpet0 = Battle.GetPlayer(battleIndex, 5);
	local player = leader0
	local leaderpet = leaderpet0
	if Char.GetData(player, CONST.����_����) == CONST.��������_�� then
		player = leader0
	else
		player = leaderpet
	end
	local cdk = Char.GetData(player,CONST.����_CDK) or nil;

	--[[local ret = SQL.Run("select Name,WorldLord1 from lua_hook_worldboss where CdKey='"..cdk.."'");
	if(type(ret)=="table" and ret["0_1"]~=nil)then
		LordHP1=tonumber(ret["0_1"]);
	end]]

	local LordHP1 = tonumber(SQL.Run("select WorldLord1 from lua_hook_worldboss where CdKey='"..cdk.."'")["0_0"])
	for i = 10, 19 do
		local enemy = Battle.GetPlayer(battleIndex, i);
		local HP = LordHP1;
		if (HP<=1000) then
			HP = LordHP1*100;
		end
		if enemy>=0 and Char.GetData(enemy, CONST.����_ENEMY_ID)==BossEnemyId  then
			Char.SetData(enemy, CONST.����_���Ѫ, 1000000);
			Char.SetData(enemy, CONST.����_Ѫ, HP);
		end
	end
end
function Module:OnBeforeBattleTurnCommand(battleIndex)
	local Round = Battle.GetTurn(battleIndex);
	local leader0 = Battle.GetPlayer(battleIndex, 0);
	local leaderpet0 = Battle.GetPlayer(battleIndex, 5);
	local player = leader0
	local leaderpet = leaderpet0
	if Char.GetData(player, CONST.����_����) == CONST.��������_�� then
		player = leader0
	else
		player = leaderpet
	end
	if (player>=0) then
		cdk = Char.GetData(player,CONST.����_CDK) or nil;
	end

	--[[local ret = SQL.Run("select Name,WorldLord1 from lua_hook_worldboss where CdKey='"..cdk.."'");
	if(type(ret)=="table" and ret["0_1"]~=nil)then
		LordHP1=tonumber(ret["0_1"]);
	end]]
	local LordHP1 = tonumber(SQL.Run("select WorldLord1 from lua_hook_worldboss where CdKey='"..cdk.."'")["0_0"])
	--print(LordHP1)
	for i = 10, 19 do
		local enemy = Battle.GetPlayer(battleIndex, i);
		local HP = LordHP1;
		if (HP<=1000 and Round<1) then
			HP = HP*100;
		end
		if Round==0 and enemy>=0 and Char.GetData(enemy, CONST.����_ENEMY_ID)==BossEnemyId  then
			Char.SetData(enemy, CONST.����_���Ѫ, 1000000);     --Ѫ������100��
			Char.SetData(enemy, CONST.����_Ѫ, HP);
		elseif Round>0 and enemy>=0 and Char.GetData(enemy, CONST.����_ENEMY_ID)==BossEnemyId  then
			Char.SetData(enemy, CONST.����_���Ѫ, 1000000);     --Ѫ������100��
			Char.SetData(enemy, CONST.����_Ѫ, HP);
			if Round>=5 then
				--Char.SetData(enemy, CONST.����_������, 10000);
				--Char.SetData(enemy, CONST.����_����, 10000);
				--Char.SetData(enemy, CONST.����_����, 100);
				--Char.SetData(enemy, CONST.����_����, 100);
				--Char.SetData(enemy, CONST.����_����, 70);
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
	if Char.GetData(player, CONST.����_����) == CONST.��������_�� then
		player = leader0
	else
		player = leaderpet
	end
	local cdk = Char.GetData(player,CONST.����_CDK) or nil;

	for i = 10, 19 do
		local enemy = Battle.GetPlayer(battleIndex, i);
		if Round>=0 and enemy>=0 and Char.GetData(enemy, CONST.����_ENEMY_ID)==BossEnemyId  then
			local HP = Char.GetData(enemy,CONST.����_Ѫ);
			Char.SetData(enemy, CONST.����_���Ѫ, 1000000);
			Char.SetData(enemy, CONST.����_Ѫ, HP);
			NLG.SystemMessage(player,"[ϵ�y]ħ���I��Ŀǰʣ�NѪ��"..HP.."��");
			NLG.UpChar(enemy);
			--LordѪ��д���
			if (cdk~=nil) then
				--SQL.Run("INSERT INTO lua_hook_worldboss (Name,CdKey) SELECT Name,CdKey FROM tbl_character WHERE NOT EXISTS ( SELECT Name FROM lua_hook_worldboss WHERE CdKey='"..cdk.."')");
				SQL.Run("update lua_hook_worldboss set WorldLord1= '"..HP.."' where CdKey='"..cdk.."'")
				NLG.UpChar(player);
			end
		end
	end
end
--����ģʽ����ʩ��
function Module:OnEnemyCommandCallBack(battleIndex, side, slot, action)
	local Round = Battle.GetTurn(battleIndex);
	for i = 10, 19 do
		local enemy = Battle.GetPlayer(battleIndex, i);
		if Round>=5 and Round<=9 and enemy>= 0 and Char.GetData(enemy, CONST.����_ENEMY_ID)==BossEnemyId  then
			SetCom(enemy, action, CONST.BATTLE_COM.BATTLE_COM_M_DEATH, 40, 8609);
		elseif Round>=10 and enemy>= 0 and Char.GetData(enemy, CONST.����_ENEMY_ID)==BossEnemyId  then
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

function Module:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
	local Round = Battle.GetTurn(battleIndex);
	if (Round<1 and Char.GetData(defCharIndex, CONST.����_ENEMY_ID)==BossEnemyId and flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge)  then
		local defHpE = Char.GetData(defCharIndex,CONST.����_Ѫ);
		if (damage>=defHpE-1) then
			Char.SetData(defCharIndex, CONST.����_Ѫ, defHpE+damage*1);
			NLG.UpChar(defCharIndex);
			NLG.SystemMessage(charIndex,"[ϵ�y]ħ���I��Ŀǰ�o���ܵ�������");
			damage = damage*0;
		else
			damage = damage*0;
		end
	end
	return damage;
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;