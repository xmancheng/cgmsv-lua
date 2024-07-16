---ģ����
local Module = ModuleBase:createModule('huntingZone')

local Pts = 68999;                        --���C�{��e��
-----------------------------------------------------------------------------------------------
--����������λ��
local wilditemNpc = {}
local WildBoxArea = {}
WildBoxArea[1]={48,72}
WildBoxArea[2]={51,72}
WildBoxArea[3]={93,66}
WildBoxArea[4]={82,58}
WildBoxArea[5]={90,60}
WildBoxArea[6]={67,51}
WildBoxArea[7]={45,38}
WildBoxArea[8]={59,46}
WildBoxArea[9]={44,29}
WildBoxArea[10]={28,26}
WildBoxArea[11]={13,70}
WildBoxArea[12]={7,65}
WildBoxArea[13]={27,74}
WildBoxArea[14]={17,76}
-----------------------------------------------------------------------------------------------
local WildSetting = {Map=20233, X=50, Y=87, Item_1=75012, Item_3=75013}
--�ݵء�ˮ��ϡ�жȷ���
local EnemySet_C = {600001,600001,600002,600003,600003,600002}
local EnemySet_G = {600004,600005,600006,60006}
local EnemySet_R = {600007,600008,600009,600008}
local EnemySet_V = {600010,600011,600024}
local EnemySet_WC = {600012,600012,600012,600012,600012,600012}
local EnemySet_WG = {600013,600013,600013,600013}
local EnemySet_WR = {600014,600015}
local EnemySet_WV = {600016,600017,600024}
local DelList = {
       {count=1, PetID=600001}, {count=1, PetID=600002}, {count=1, PetID=600003}, {count=1, PetID=600012}, {count=1, PetID=600060}, 
       {count=2, PetID=600004}, {count=2, PetID=600005}, {count=2, PetID=600006}, {count=2, PetID=600013}, 
       {count=3, PetID=600007}, {count=3, PetID=600008}, {count=3, PetID=600009}, {count=3, PetID=600014}, {count=3, PetID=600015},
       {count=4, PetID=600010}, {count=4, PetID=600011}, {count=4, PetID=600016}, {count=4, PetID=600017}, {count=4, PetID=600024}
}

--����ֲ�����
local EnemyArea = {}
--�ݵ�
EnemyArea[1]={38,65,42,75,EnemySet_C,EnemySet_G,EnemySet_R,EnemySet_V}
EnemyArea[2]={39,80,47,86,EnemySet_C,EnemySet_G,EnemySet_R,EnemySet_V}
EnemyArea[3]={57,74,61,84,EnemySet_C,EnemySet_G,EnemySet_R,EnemySet_V}
EnemyArea[4]={83,72,91,74,EnemySet_C,EnemySet_G,EnemySet_R,EnemySet_V}
EnemyArea[5]={66,58,75,66,EnemySet_C,EnemySet_G,EnemySet_R,EnemySet_V}
EnemyArea[6]={74,51,93,56,EnemySet_C,EnemySet_G,EnemySet_R,EnemySet_V}
EnemyArea[7]={43,52,52,57,EnemySet_C,EnemySet_G,EnemySet_R,EnemySet_V}
EnemyArea[8]={33,39,38,52,EnemySet_C,EnemySet_G,EnemySet_R,EnemySet_V}
EnemyArea[9]={53,25,60,34,EnemySet_C,EnemySet_G,EnemySet_R,EnemySet_V}
EnemyArea[10]={27,26,33,32,EnemySet_C,EnemySet_G,EnemySet_R,EnemySet_V}
EnemyArea[11]={6,82,22,85,EnemySet_C,EnemySet_G,EnemySet_R,EnemySet_V}
--ˮ��
EnemyArea[12]={44,71,55,75,EnemySet_WC,EnemySet_WG,EnemySet_WR,EnemySet_WV}
EnemyArea[13]={77,61,82,66,EnemySet_WC,EnemySet_WG,EnemySet_WR,EnemySet_WV}
EnemyArea[14]={33,49,35,53,EnemySet_WC,EnemySet_WG,EnemySet_WR,EnemySet_WV}
EnemyArea[15]={29,39,31,43,EnemySet_WC,EnemySet_WG,EnemySet_WR,EnemySet_WV}
EnemyArea[16]={33,33,35,37,EnemySet_WC,EnemySet_WG,EnemySet_WR,EnemySet_WV}
EnemyArea[17]={8,73,13,75,EnemySet_WC,EnemySet_WG,EnemySet_WR,EnemySet_WV}

-----------------------------------------------------------------------------------------------
--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self));
  self:regCallback('VSEnemyCreateEvent', Func.bind(self.OnVSEnemyCreateEvent, self));
  self:regCallback('EnemyCommandEvent', Func.bind(self.OnEnemyCommandCallBack, self));
  self:regCallback('ItemUseEvent', Func.bind(self.onItemUseEvent, self));
  self:regCallback('ItemString', Func.bind(self.onMudUse, self), 'LUA_useMud');  --��
  self:regCallback('ItemString', Func.bind(self.onBaitUse, self), 'LUA_useBait');  --�D
  self:regCallback('SealEvent', Func.bind(self.OnSealEventCallBack, self));
  self:regCallback('BeforeBattleTurnEvent', Func.bind(self.handleBattleAutoCommand, self));
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self));
  self:regCallback('BattleOverEvent', Func.bind(self.battleOverEventCallback, self));
  self:regCallback('LoginEvent', Func.bind(self.onLoginEvent, self));
  self:regCallback('LogoutEvent', Func.bind(self.onLogoutEvent, self));
  local wildnpc = self:NPC_createNormal('���C�؎�������', 98092, { map = 1000, x = 240, y = 74, direction = 0, mapType = 0 })
  self:regCallback('LoopEvent', Func.bind(self.Qualifications_LoopEvent,self))
  self:NPC_regWindowTalkedEvent(wildnpc, function(npc, player, _seqno, _select, _data)
	local cdk = Char.GetData(player,CONST.����_CDK);
	local seqno = tonumber(_seqno)
	local select = tonumber(_select)
	local data = tonumber(_data)			
	if seqno == 1 then
		if data == 2 then  ----����
			if(Char.ItemNum(player, WildSetting.Item_1)>0 or Char.ItemNum(player, WildSetting.Item_3)>0 ) then
				NLG.SystemMessage(player,"[ϵ�y]�M�����C�؎����������ȯ��");
				return;
			else
				local msg = "3\\n@c�����������C�؎���Ѳ��\\n"
					.."\\n�����T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T"
					.. "\\n��200ħ�ţ�����1С�r��\\n"
					.. "\\n��500ħ�ţ�����3С�r��\\n";
				NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, CONST.BUTTON_�ر�, 21, msg);
			end
		end
		if data == 3 then  ----�ۿ�˵��
			if (NLG.CanTalk(npc, player) == true) then
			local msg = "\\n@cՈԔ����x���C�؎��f��\\n"
				.. "\\n�ޕr��С�r�M�в�׽���C\\n"
				.. "\\n�ь��Kȡ��ԭҰ�ϵ����Y\\n"
				.. "\\nע���ա�ҹ�������׃\\n"
				.. "\\nԭҰ����o���y������\\n";
			NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.BUTTON_ȷ��, 31, msg);
			end
		end
	end
	------------------------------------------------------------
	if seqno == 21 then  ----����ִ��
		key = data
		if select == 2 then
			return;
		end
		if key == data then
			local playerName = Char.GetData(player,CONST.CHAR_����);
			--print(key)
			if (Char.GetData(player,CONST.CHAR_���)<200) then
				local msg = "\\n@c�����Ҫ�����M�Ј�������\\n"
					.."\\n֧������M��200ħ��\\n"
					.."\\n�M������Ԍ���ⷰ�M�\\n"
					.."\\n�������ȯ�ϵ����ĕr�g\\n";
				NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.BUTTON_ȷ��, 22, msg);
				return;
			elseif (Char.PartyNum(player)>=2) then
				local msg = "\\n@c�����Ҫ�����M�Ј�������\\n"
					.."\\n֧������M��200��500ħ��\\n"
					.."\\n�M������Ԍ���ⷰ�M�\\n"
					.."\\n�������ȯ�ϵ����ĕr�g\\n";
				NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.BUTTON_ȷ��, 22, msg);
				return;
			else
				if key==1 then
					Char.AddGold(player, -200);
					Char.GiveItem(player, WildSetting.Item_1, 1);
					Char.Warp(player,0, WildSetting.Map, WildSetting.X, WildSetting.Y);
					Char.SetLoopEvent('./lua/Modules/huntingZone.lua','Qualifications_LoopEvent',player,2000);
				elseif key==3 then
					Char.AddGold(player, -500);
					Char.GiveItem(player, WildSetting.Item_3, 1);
					Char.Warp(player,0, WildSetting.Map, WildSetting.X, WildSetting.Y);
					Char.SetLoopEvent('./lua/Modules/huntingZone.lua','Qualifications_LoopEvent',player,2000);
				end
			end
			
		else
			return 0;
		end
	end
  end)
  self:NPC_regTalkedEvent(wildnpc, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
               local msg = "1\\n@c�gӭ�������C�؎���Ѳ��\\n\\n"
                                             .."[�������������C��]\\n" 
                                             .."[���^�����C�f����]\\n" ;
               NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, CONST.BUTTON_�ر�, 1, msg);
    end
    return
  end)

  local wild2npc = self:NPC_createNormal('���C�؎�������', 98092, { map = 20233, x = 52, y = 83, direction = 0, mapType = 0 })
  self:regCallback('LoopEvent', Func.bind(self.Qualifications_LoopEvent,self))
  self:NPC_regWindowTalkedEvent(wild2npc, function(npc, player, _seqno, _select, _data)
  end)
  self:NPC_regTalkedEvent(wild2npc, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        Char.SetLoopEvent('./lua/Modules/huntingZone.lua','Qualifications_LoopEvent',player,2000);
    end
    return
  end)

  self:regCallback('LoopEvent', Func.bind(self.WildBoxNpc_LoopEvent,self))
  for id=1,#WildBoxArea do
        wilditemNpc[id] = self:NPC_createNormal('���C�����Y', 252896, { map = 20233, x = WildBoxArea[id][1], y = WildBoxArea[id][2], direction = 6, mapType = 0 })
        self:NPC_regWindowTalkedEvent(wilditemNpc[id], function(npc, player, _seqno, _select, _data)
        end)
        self:NPC_regTalkedEvent(wilditemNpc[id], function(npc, player)
	if (NLG.CanTalk(npc, player) == true) then
		if Char.ItemSlot(player) >= 19 then
			NLG.SystemMessage(player,"[ϵ�y]��ı���̫�M���ò������Y��");
			return;
		else
			local itemTbl= {75014,75015,75016};
			local ir= NLG.Rand(1,3);
			local nr= NLG.Rand(1,5);
			local CTime = Char.GetTempData(player, 'CTime') or 0;
			if CTime==0 then
				Char.GiveItem(player, itemTbl[ir], nr);
				Char.SetTempData(player, 'CTime', os.time() );
				Char.SetLoopEvent('./lua/Modules/huntingZone.lua','WildBoxNpc_LoopEvent',player,30000);
				NLG.UpChar(player);
			else
				local timesec = 30 - (os.time() - CTime);
				if (timesec<=0) then
					Char.GiveItem(player, itemTbl[ir], nr);
					Char.SetTempData(player, 'CTime', os.time() );
					Char.SetLoopEvent('./lua/Modules/huntingZone.lua','WildBoxNpc_LoopEvent',player,30000);
					NLG.UpChar(player);
				else
					NLG.SystemMessage(player,"[ϵ�y]Ո�ȴ�"..timesec.."�������Iȡ��");
				end
			end
		end
	end
            return
        end)
  end

end

-----------------------------------------------------------------------------------------------
---����Ϊ��function����
--ָ���ѯ����������
function Module:handleTalkEvent(charIndex,msg,color,range,size)
	if (msg=="/poke" or msg=="/POKE")then
		local Target_FloorId = Char.GetData(charIndex,CONST.CHAR_��ͼ);
		local battleIndex = Char.GetBattleIndex(charIndex);
		if (Target_FloorId==20233 and battleIndex<0) then
			NLG.SystemMessage(charIndex, "[ϵ�y]�Ǒ��Y�Пo����ԃ���@�������ʡ�");
			return 0;
		elseif (Target_FloorId==20233 and battleIndex>=0) then
			--NLG.SystemMessage(charIndex, "---------------------------------------");
			--NLG.SystemMessage(charIndex, "����������������������������������");
			--NLG.SystemMessage(charIndex, "����������������������������������");
			NLG.SystemMessage(charIndex, "---------------------------------------");
			for i = 10, 19 do
				local pokmon = Battle.GetPlayer(battleIndex, i);
				local infoSlot = i-10;
				if pokmon >= 0 then
					local capture = Char.GetTempData(pokmon, '���@��') or 0;
					local runaway = Char.GetTempData(pokmon, '������') or 0;
					NLG.SystemMessage(charIndex, "�� "..infoSlot.." λ  ���@�̶ȣ�"..capture.."  ���̶ܳȣ�"..runaway.."");
				end
			end
			NLG.SystemMessage(charIndex, "---------------------------------------");
			return 0;
		end
	end
	return 1;
end
--������ȴ
function WildBoxNpc_LoopEvent(player)
	local CTime = Char.GetTempData(player, 'CTime') or 0;
	if (os.time() - CTime) >= 30 then
		Char.SetTempData(player, 'CTime', 0);
		Char.UnsetLoopEvent(player);
		NLG.UpChar(player);
	end
end
--�����ʸ�
function Qualifications_LoopEvent(player)
	local cdk = Char.GetData(player,CONST.����_CDK);
	if (Char.ItemNum(player, WildSetting.Item_1)>0 or Char.ItemNum(player, WildSetting.Item_3)>0 ) then
		--NLG.SystemMessage(player,"[ϵ�y]�Է��ϴ������C�؎����Y��");
		for k, v in ipairs(DelList) do
			if (Char.HavePet(player, v.PetID)>= 0) then
				Char.DelSlotPet(player, Char.HavePet(player, v.PetID));
				local PointCount = v.count;
				--local Restcount = tonumber(SQL.Run("select RankedPoints from lua_hook_character where CdKey='"..cdk.."'")["0_0"])
				--local Restcount = Restcount + PointCount;
				--SQL.Run("update lua_hook_character set RankedPoints= '"..Restcount.."' where CdKey='"..cdk.."'")
				Char.GiveItem(player, Pts, v.count);
				--NLG.SystemMessage(player,"[ϵ�y]�@�� "..PointCount.." �����C�e��ȯ��");
				--NLG.UpChar(player);
			end
		end
		return;
	else
		for k, v in ipairs(DelList) do
			if (Char.HavePet(player, v.PetID)>= 0) then
				Char.DelSlotPet(player, Char.HavePet(player, v.PetID));
			end
		end
		Char.LeaveParty(player);
		Battle.ExitBattle(player);
		Char.Warp(player,0,1000,240,75);
		Char.UnsetLoopEvent(player);
		NLG.SystemMessage(player,"[ϵ�y]�r�g���˂����x�_���C�؎���");
	end
end

--�����û
function Module:OnVSEnemyCreateEvent(player, groupId, enemyNum, enemyList)
	--self:logDebug('OnVSEnemyCreateCallBack', player, groupId, enemyNum, enemyList)
	-- bossս����Ч
	local isBoss = false
	table.forEach(enemyList, function(e)
		if Data.EnemyGetData(e, CONST.Enemy_�Ƿ�BOSS) == 1 then
			isBoss = true
		end
	end)
	if isBoss then
		return 0
	end

	-- �������C�؎�
	local Target_MapId = Char.GetData(player,CONST.CHAR_MAP)--��ͼ����
	local Target_FloorId = Char.GetData(player,CONST.CHAR_��ͼ)--��ͼ���
	local Target_X = Char.GetData(player,CONST.CHAR_X)--��ͼx
	local Target_Y = Char.GetData(player,CONST.CHAR_Y)--��ͼy
 	local GTime = NLG.GetGameTime();
 	local enemyListAft = {}
	if Target_FloorId==20233 and groupId==1003  then
		if GTime ==0 or GTime ==3 then
			local enemyNum= NLG.Rand(6,8);
			for enemyslot=1,enemyNum do
				local EncountRate = {5,5,5,5,5,5,6,6,6,6,6,7,7,7,8}
				local xr = EncountRate[NLG.Rand(1,15)];
				for k, v in ipairs(EnemyArea) do
					if Target_X >= EnemyArea[k][1] and Target_Y >= EnemyArea[k][2] and Target_X <= EnemyArea[k][3] and Target_Y <= EnemyArea[k][4] then
						local xxr= NLG.Rand(1,#EnemyArea[k][xr]);
						local EnemyDataIndex = Data.EnemyGetDataIndex(EnemyArea[k][xr][xxr]);
						enemyListAft[enemyslot]=EnemyDataIndex;
					end
				end
			end
			return enemyListAft
		elseif GTime ==1 or GTime ==2 then
			local enemyNum= NLG.Rand(3,5);
			for enemyslot=1,enemyNum do
				local EncountRate = {5,5,5,5,5,5,6,6,6,6,6,7,7,7,8}
				local xr = EncountRate[NLG.Rand(1,15)];
				for k, v in ipairs(EnemyArea) do
					if Target_X >= EnemyArea[k][1] and Target_Y >= EnemyArea[k][2] and Target_X <= EnemyArea[k][3] and Target_Y <= EnemyArea[k][4] then
						local xxr= NLG.Rand(1,#EnemyArea[k][xr]);
						local EnemyDataIndex = Data.EnemyGetDataIndex(EnemyArea[k][xr][xxr]);
						enemyListAft[enemyslot]=EnemyDataIndex;
					end
				end
			end
			return enemyListAft
		end
	end
	return 0
end

--��ӡ������ʹ������
function Module:onItemUseEvent(charIndex, targetCharIndex, itemSlot)
  local itemIndex = Char.GetItemIndex(charIndex,itemSlot);
  local battleIndex = Char.GetBattleIndex(charIndex);
  local ItemID = Item.GetData(itemIndex, CONST.����_ID);
  local Target_FloorId = Char.GetData(charIndex,CONST.CHAR_��ͼ)
  if (Item.GetData(itemIndex, CONST.����_����)==40) then
      if (Target_FloorId==20233 and ItemID~=75014) then
               NLG.SystemMessage(charIndex,"[������ʾ]Ո�����C��׽��");
               return -1;
      else
               return 0;
      end
  end
end

--���ʹ��
function Module:onMudUse(charIndex, targetCharIndex, itemSlot)
  local itemIndex = Char.GetItemIndex(charIndex,itemSlot);
  local battleIndex = Char.GetBattleIndex(charIndex);
  local ItemID = Item.GetData(itemIndex, CONST.����_ID);
  local Target_FloorId = Char.GetData(charIndex,CONST.CHAR_��ͼ)
  if (Item.GetData(itemIndex, CONST.����_����)==53) then
      if (battleIndex==-1 and Battle.IsWaitingCommand(charIndex)<=0) then
               NLG.SystemMessage(charIndex,"[������ʾ]���Y�в���ʹ�õĵ���");
      else
            if (Target_FloorId~=20233) then
                NLG.SystemMessage(charIndex,"[������ʾ]ֻ�������C�؎�ʹ�õĵ���");
            else
                if (ItemID==75015) then
                     for i = 10, 19 do
                         local enemy = Battle.GetPlayer(battleIndex, i);
                         if enemy == targetCharIndex then
                                        --Throw_pos = i+20;
                                        Throw_pos = 41;
                         end
                     end
                     Char.SetTempData(charIndex, 'MudOn', 1);
                     Char.DelItem(charIndex,75015,1);
                     NLG.Say(charIndex,charIndex,"�»غϲš�Ͷ�S��͡�����",4,3);
                end
            end
      end
  end
end
--�ն�ʹ��
function Module:onBaitUse(charIndex, targetCharIndex, itemSlot)
  local itemIndex = Char.GetItemIndex(charIndex,itemSlot);
  local battleIndex = Char.GetBattleIndex(charIndex);
  local ItemID = Item.GetData(itemIndex, CONST.����_ID);
  local Target_FloorId = Char.GetData(charIndex,CONST.CHAR_��ͼ)
  if (Item.GetData(itemIndex, CONST.����_����)==53) then
      if (battleIndex==-1 and Battle.IsWaitingCommand(charIndex)<=0) then
               NLG.SystemMessage(charIndex,"[������ʾ]���Y�в���ʹ�õĵ���");
      else
            if (Target_FloorId~=20233) then
                NLG.SystemMessage(charIndex,"[������ʾ]ֻ�������C�؎�ʹ�õĵ���");
            else
                if (ItemID==75016) then
                     for i = 10, 19 do
                         local enemy = Battle.GetPlayer(battleIndex, i);
                         if enemy == targetCharIndex then
                                        --Throw_pos = i+20;
                                        Throw_pos = 41;
                         end
                     end
                     Char.SetTempData(charIndex, 'BaitOn', 1);
                     Char.DelItem(charIndex,75016,1);
                     NLG.Say(charIndex,charIndex,"�»غϲš�Ͷ�S�T�D������",4,3);
                end
            end
      end
  end
end
--��͡��ն��������
function Module:handleBattleAutoCommand(battleIndex)
  for i = 0, 9 do
        local charIndex = Battle.GetPlayer(battleIndex, i);
        if charIndex >= 0 then
                local ybjn = Battle.IsWaitingCommand(charIndex);
                local Mud = Char.GetTempData(charIndex, 'MudOn') or 0;
                local Bait = Char.GetTempData(charIndex, 'BaitOn') or 0;
                if ybjn and Mud == 1  then
                       Battle.ActionSelect(charIndex, CONST.BATTLE_COM.BATTLE_COM_P_MAGIC, Throw_pos, 2330);
                       Char.SetTempData(charIndex, 'MudOn', 0);
                elseif ybjn and Bait == 1  then
                       Battle.ActionSelect(charIndex, CONST.BATTLE_COM.BATTLE_COM_P_MAGIC, Throw_pos, 2530);
                       Char.SetTempData(charIndex, 'BaitOn', 0);
                end
        end
  end
  return Throw;
end

--�����ʡ��������˺��ӿ�
function Module:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
      --self:logDebug('OnDamageCalculateCallBack', charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
         local capture = Char.GetTempData(defCharIndex, '���@��') or 0;
         local runaway = Char.GetTempData(defCharIndex, '������') or 0;
         local Target_FloorId = Char.GetData(charIndex,CONST.CHAR_��ͼ);
         if Char.GetData(charIndex,CONST.����_ս��״̬) ~= CONST.ս��_BOSSս and Char.GetData(defCharIndex, CONST.CHAR_����) == CONST.��������_��  then
                if com3 == 2330 and Target_FloorId==20233  then
                    if capture<5 then
                        Char.SetTempData(defCharIndex, '���@��',capture+2);
                        --NLG.SystemMessage(charIndex,"[ϵ�y]���@������2");
                        local down= NLG.Rand(1,5);
                        if down>=4 then
                            if runaway<5 then
                                Char.SetTempData(defCharIndex, '������',runaway+2);
                                --NLG.SystemMessage(charIndex,"[ϵ�y]����������2");
                            end
                        end
                        damage = damage*0;
                    end
                elseif com3 == 2530 and Target_FloorId==20233  then
                    if runaway>-5 then
                        Char.SetTempData(defCharIndex, '������',runaway-2);
                        --NLG.SystemMessage(charIndex,"[ϵ�y]�������½�2");
                        local down= NLG.Rand(1,5);
                        if down>=4 then
                            if capture>-5 then
                                Char.SetTempData(defCharIndex, '���@��',capture-2);
                                --NLG.SystemMessage(charIndex,"[ϵ�y]���@���½�2");
                            end
                        end
                        damage = damage*0;
                    end
                end
         end
  return damage;
end

--����ִ��
function Module:OnEnemyCommandCallBack(battleIndex, side, slot, action)
      local Round = Battle.GetTurn(battleIndex);
      for i = 10, 19 do
            local defCharIndex = Battle.GetPlayer(battleIndex, i);
            local charIndex = Battle.GetPlayIndex(battleIndex, i-10);
            if defCharIndex >= 0 then
                local runaway = Char.GetTempData(defCharIndex, '������') or 0;
                local Target_FloorId = Char.GetData(charIndex,CONST.CHAR_��ͼ);
                if Target_FloorId==20233 then
                    local RandRun = runaway*50;
                    local ESCAPE = NLG.Rand(0,255);
                    if defCharIndex >= 0 and ESCAPE<=RandRun  then
                          SetCom(defCharIndex, action, CONST.BATTLE_COM.BATTLE_COM_ESCAPE, -1, 15001);
                    end
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

--��ӡ���
function Module:OnSealEventCallBack(charIndex, enemyIndex, ret)
  --self:logDebug('OnSealEventCallBack', charIndex, enemyIndex, ret)
         local capture = Char.GetTempData(enemyIndex, '���@��') or 0;
         local Target_FloorId = Char.GetData(charIndex,CONST.CHAR_��ͼ);
         if Char.PetNum(charIndex)==5 then
             NLG.SystemMessage(charIndex,"[ϵ�y]������ѝM�o��ץȡ");
         end
         if Target_FloorId==20233 then
             local RandCap = capture*50;
             local CAPTURE = NLG.Rand(0,255);
             if CAPTURE<=RandCap then
                 ret=1;
             end
         end
  return ret;
end

--������ע����ʼ��
function Module:battleOverEventCallback(battleIndex)
  for i = 0, 9 do
        local charIndex = Battle.GetPlayer(battleIndex, i);
        if charIndex >= 0 then
              local Mud = Char.GetTempData(charIndex, 'MudOn') or 0;
              local Bait = Char.GetTempData(charIndex, 'BaitOn') or 0;
              if Mud==1 then
                 Char.SetTempData(charIndex, 'MudOn', 0);
              elseif Bait==1 then
                 Char.SetTempData(charIndex, 'BaitOn', 0);
              end
        end
  end
end
function Module:onLogoutEvent(charIndex)
	local Mud = Char.GetTempData(charIndex, 'MudOn');
	local Bait = Char.GetTempData(charIndex, 'BaitOn');
	if Mud then
		Char.SetTempData(charIndex, 'MudOn', 0);
	elseif Bait then
		Char.SetTempData(charIndex, 'BaitOn', 0);
	end
end
--ԭ�Ǽ�����
function Module:onLoginEvent(charIndex)
	local Target_FloorId = Char.GetData(charIndex,CONST.CHAR_��ͼ);
	if Target_FloorId==20233 then
		Char.Warp(charIndex,0,1000,240,75);
		NLG.SystemMessage(charIndex,"[ϵ�y]�����x�_���C�؎���");	
	end
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
