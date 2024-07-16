---模块类
local Module = ModuleBase:createModule('huntingZone')

local Pts = 68999;                        --狩獵調查積分
-----------------------------------------------------------------------------------------------
--精灵球物资位置
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
--草地、水边稀有度分类
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

--怪物分布区域
local EnemyArea = {}
--草地
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
--水边
EnemyArea[12]={44,71,55,75,EnemySet_WC,EnemySet_WG,EnemySet_WR,EnemySet_WV}
EnemyArea[13]={77,61,82,66,EnemySet_WC,EnemySet_WG,EnemySet_WR,EnemySet_WV}
EnemyArea[14]={33,49,35,53,EnemySet_WC,EnemySet_WG,EnemySet_WR,EnemySet_WV}
EnemyArea[15]={29,39,31,43,EnemySet_WC,EnemySet_WG,EnemySet_WR,EnemySet_WV}
EnemyArea[16]={33,33,35,37,EnemySet_WC,EnemySet_WG,EnemySet_WR,EnemySet_WV}
EnemyArea[17]={8,73,13,75,EnemySet_WC,EnemySet_WG,EnemySet_WR,EnemySet_WV}

-----------------------------------------------------------------------------------------------
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self));
  self:regCallback('VSEnemyCreateEvent', Func.bind(self.OnVSEnemyCreateEvent, self));
  self:regCallback('EnemyCommandEvent', Func.bind(self.OnEnemyCommandCallBack, self));
  self:regCallback('ItemUseEvent', Func.bind(self.onItemUseEvent, self));
  self:regCallback('ItemString', Func.bind(self.onMudUse, self), 'LUA_useMud');  --泥
  self:regCallback('ItemString', Func.bind(self.onBaitUse, self), 'LUA_useBait');  --餌
  self:regCallback('SealEvent', Func.bind(self.OnSealEventCallBack, self));
  self:regCallback('BeforeBattleTurnEvent', Func.bind(self.handleBattleAutoCommand, self));
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self));
  self:regCallback('BattleOverEvent', Func.bind(self.battleOverEventCallback, self));
  self:regCallback('LoginEvent', Func.bind(self.onLoginEvent, self));
  self:regCallback('LogoutEvent', Func.bind(self.onLogoutEvent, self));
  local wildnpc = self:NPC_createNormal('狩獵地帶管理人', 98092, { map = 1000, x = 240, y = 74, direction = 0, mapType = 0 })
  self:regCallback('LoopEvent', Func.bind(self.Qualifications_LoopEvent,self))
  self:NPC_regWindowTalkedEvent(wildnpc, function(npc, player, _seqno, _select, _data)
	local cdk = Char.GetData(player,CONST.对象_CDK);
	local seqno = tonumber(_seqno)
	local select = tonumber(_select)
	local data = tonumber(_data)			
	if seqno == 1 then
		if data == 2 then  ----报名
			if(Char.ItemNum(player, WildSetting.Item_1)>0 or Char.ItemNum(player, WildSetting.Item_3)>0 ) then
				NLG.SystemMessage(player,"[系統]進入狩獵地帶不能有入場券。");
				return;
			else
				local msg = "3\\n@c報名參加狩獵地帶的巡查\\n"
					.."\\n　　════════════════════"
					.. "\\n　200魔幣！參加1小時！\\n"
					.. "\\n　500魔幣！參加3小時！\\n";
				NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.BUTTON_关闭, 21, msg);
			end
		end
		if data == 3 then  ----观看说明
			if (NLG.CanTalk(npc, player) == true) then
			local msg = "\\n@c請詳細閱讀狩獵地帶說明\\n"
				.. "\\n限時幾小時進行捕捉狩獵\\n"
				.. "\\n搜尋並取得原野上的物資\\n"
				.. "\\n注意日、夜怪物數量改變\\n"
				.. "\\n原野怪物無法攜帶出來\\n";
			NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.BUTTON_确定, 31, msg);
			end
		end
	end
	------------------------------------------------------------
	if seqno == 21 then  ----报名执行
		key = data
		if select == 2 then
			return;
		end
		if key == data then
			local playerName = Char.GetData(player,CONST.CHAR_名字);
			--print(key)
			if (Char.GetData(player,CONST.CHAR_金币)<200) then
				local msg = "\\n@c參加須要個人進行報名！！\\n"
					.."\\n支付入場費用200魔幣\\n"
					.."\\n進入後可以尋找夥伴組隊\\n"
					.."\\n留意入場券上倒數的時間\\n";
				NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.BUTTON_确定, 22, msg);
				return;
			elseif (Char.PartyNum(player)>=2) then
				local msg = "\\n@c參加須要個人進行報名！！\\n"
					.."\\n支付入場費用200、500魔幣\\n"
					.."\\n進入後可以尋找夥伴組隊\\n"
					.."\\n留意入場券上倒數的時間\\n";
				NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.BUTTON_确定, 22, msg);
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
               local msg = "1\\n@c歡迎報名狩獵地帶的巡查\\n\\n"
                                             .."[　報名參加狩獵　]\\n" 
                                             .."[　觀看狩獵說明　]\\n" ;
               NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.BUTTON_关闭, 1, msg);
    end
    return
  end)

  local wild2npc = self:NPC_createNormal('狩獵地帶管理人', 98092, { map = 20233, x = 52, y = 83, direction = 0, mapType = 0 })
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
        wilditemNpc[id] = self:NPC_createNormal('狩獵球物資', 252896, { map = 20233, x = WildBoxArea[id][1], y = WildBoxArea[id][2], direction = 6, mapType = 0 })
        self:NPC_regWindowTalkedEvent(wilditemNpc[id], function(npc, player, _seqno, _select, _data)
        end)
        self:NPC_regTalkedEvent(wilditemNpc[id], function(npc, player)
	if (NLG.CanTalk(npc, player) == true) then
		if Char.ItemSlot(player) >= 19 then
			NLG.SystemMessage(player,"[系統]你的背包太滿，拿不了物資！");
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
					NLG.SystemMessage(player,"[系統]請等待"..timesec.."秒後再領取。");
				end
			end
		end
	end
            return
        end)
  end

end

-----------------------------------------------------------------------------------------------
---以下为各function功能
--指令查询捕获、逃跑率
function Module:handleTalkEvent(charIndex,msg,color,range,size)
	if (msg=="/poke" or msg=="/POKE")then
		local Target_FloorId = Char.GetData(charIndex,CONST.CHAR_地图);
		local battleIndex = Char.GetBattleIndex(charIndex);
		if (Target_FloorId==20233 and battleIndex<0) then
			NLG.SystemMessage(charIndex, "[系統]非戰鬥中無法查詢捕獲、逃跑率。");
			return 0;
		elseif (Target_FloorId==20233 and battleIndex>=0) then
			--NLG.SystemMessage(charIndex, "---------------------------------------");
			--NLG.SystemMessage(charIndex, "４　　　２　　　０　　　１　　　３");
			--NLG.SystemMessage(charIndex, "９　　　７　　　５　　　６　　　８");
			NLG.SystemMessage(charIndex, "---------------------------------------");
			for i = 10, 19 do
				local pokmon = Battle.GetPlayer(battleIndex, i);
				local infoSlot = i-10;
				if pokmon >= 0 then
					local capture = Char.GetTempData(pokmon, '捕獲率') or 0;
					local runaway = Char.GetTempData(pokmon, '逃跑率') or 0;
					NLG.SystemMessage(charIndex, "第 "..infoSlot.." 位  捕獲程度："..capture.."  逃跑程度："..runaway.."");
				end
			end
			NLG.SystemMessage(charIndex, "---------------------------------------");
			return 0;
		end
	end
	return 1;
end
--物资冷却
function WildBoxNpc_LoopEvent(player)
	local CTime = Char.GetTempData(player, 'CTime') or 0;
	if (os.time() - CTime) >= 30 then
		Char.SetTempData(player, 'CTime', 0);
		Char.UnsetLoopEvent(player);
		NLG.UpChar(player);
	end
end
--留场资格
function Qualifications_LoopEvent(player)
	local cdk = Char.GetData(player,CONST.对象_CDK);
	if (Char.ItemNum(player, WildSetting.Item_1)>0 or Char.ItemNum(player, WildSetting.Item_3)>0 ) then
		--NLG.SystemMessage(player,"[系統]仍符合待在狩獵地帶的資格。");
		for k, v in ipairs(DelList) do
			if (Char.HavePet(player, v.PetID)>= 0) then
				Char.DelSlotPet(player, Char.HavePet(player, v.PetID));
				local PointCount = v.count;
				--local Restcount = tonumber(SQL.Run("select RankedPoints from lua_hook_character where CdKey='"..cdk.."'")["0_0"])
				--local Restcount = Restcount + PointCount;
				--SQL.Run("update lua_hook_character set RankedPoints= '"..Restcount.."' where CdKey='"..cdk.."'")
				Char.GiveItem(player, Pts, v.count);
				--NLG.SystemMessage(player,"[系統]獲得 "..PointCount.." 張狩獵積分券。");
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
		NLG.SystemMessage(player,"[系統]時間到了傳送離開狩獵地帶。");
	end
end

--怪物出没
function Module:OnVSEnemyCreateEvent(player, groupId, enemyNum, enemyList)
	--self:logDebug('OnVSEnemyCreateCallBack', player, groupId, enemyNum, enemyList)
	-- boss战不生效
	local isBoss = false
	table.forEach(enemyList, function(e)
		if Data.EnemyGetData(e, CONST.Enemy_是否BOSS) == 1 then
			isBoss = true
		end
	end)
	if isBoss then
		return 0
	end

	-- 若在狩獵地帶
	local Target_MapId = Char.GetData(player,CONST.CHAR_MAP)--地图类型
	local Target_FloorId = Char.GetData(player,CONST.CHAR_地图)--地图编号
	local Target_X = Char.GetData(player,CONST.CHAR_X)--地图x
	local Target_Y = Char.GetData(player,CONST.CHAR_Y)--地图y
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

--封印卡道具使用限制
function Module:onItemUseEvent(charIndex, targetCharIndex, itemSlot)
  local itemIndex = Char.GetItemIndex(charIndex,itemSlot);
  local battleIndex = Char.GetBattleIndex(charIndex);
  local ItemID = Item.GetData(itemIndex, CONST.道具_ID);
  local Target_FloorId = Char.GetData(charIndex,CONST.CHAR_地图)
  if (Item.GetData(itemIndex, CONST.道具_类型)==40) then
      if (Target_FloorId==20233 and ItemID~=75014) then
               NLG.SystemMessage(charIndex,"[道具提示]請用狩獵球捕捉！");
               return -1;
      else
               return 0;
      end
  end
end

--泥巴使用
function Module:onMudUse(charIndex, targetCharIndex, itemSlot)
  local itemIndex = Char.GetItemIndex(charIndex,itemSlot);
  local battleIndex = Char.GetBattleIndex(charIndex);
  local ItemID = Item.GetData(itemIndex, CONST.道具_ID);
  local Target_FloorId = Char.GetData(charIndex,CONST.CHAR_地图)
  if (Item.GetData(itemIndex, CONST.道具_类型)==53) then
      if (battleIndex==-1 and Battle.IsWaitingCommand(charIndex)<=0) then
               NLG.SystemMessage(charIndex,"[道具提示]戰鬥中才能使用的道具");
      else
            if (Target_FloorId~=20233) then
                NLG.SystemMessage(charIndex,"[道具提示]只能在狩獵地帶使用的道具");
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
                     NLG.Say(charIndex,charIndex,"下回合才【投擲泥巴】！！",4,3);
                end
            end
      end
  end
end
--诱饵使用
function Module:onBaitUse(charIndex, targetCharIndex, itemSlot)
  local itemIndex = Char.GetItemIndex(charIndex,itemSlot);
  local battleIndex = Char.GetBattleIndex(charIndex);
  local ItemID = Item.GetData(itemIndex, CONST.道具_ID);
  local Target_FloorId = Char.GetData(charIndex,CONST.CHAR_地图)
  if (Item.GetData(itemIndex, CONST.道具_类型)==53) then
      if (battleIndex==-1 and Battle.IsWaitingCommand(charIndex)<=0) then
               NLG.SystemMessage(charIndex,"[道具提示]戰鬥中才能使用的道具");
      else
            if (Target_FloorId~=20233) then
                NLG.SystemMessage(charIndex,"[道具提示]只能在狩獵地帶使用的道具");
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
                     NLG.Say(charIndex,charIndex,"下回合才【投擲誘餌】！！",4,3);
                end
            end
      end
  end
end
--泥巴、诱饵动作相关
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

--捕获率、逃跑率伤害接口
function Module:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
      --self:logDebug('OnDamageCalculateCallBack', charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
         local capture = Char.GetTempData(defCharIndex, '捕獲率') or 0;
         local runaway = Char.GetTempData(defCharIndex, '逃跑率') or 0;
         local Target_FloorId = Char.GetData(charIndex,CONST.CHAR_地图);
         if Char.GetData(charIndex,CONST.对象_战斗状态) ~= CONST.战斗_BOSS战 and Char.GetData(defCharIndex, CONST.CHAR_类型) == CONST.对象类型_怪  then
                if com3 == 2330 and Target_FloorId==20233  then
                    if capture<5 then
                        Char.SetTempData(defCharIndex, '捕獲率',capture+2);
                        --NLG.SystemMessage(charIndex,"[系統]捕獲率上升2");
                        local down= NLG.Rand(1,5);
                        if down>=4 then
                            if runaway<5 then
                                Char.SetTempData(defCharIndex, '逃跑率',runaway+2);
                                --NLG.SystemMessage(charIndex,"[系統]逃跑率上升2");
                            end
                        end
                        damage = damage*0;
                    end
                elseif com3 == 2530 and Target_FloorId==20233  then
                    if runaway>-5 then
                        Char.SetTempData(defCharIndex, '逃跑率',runaway-2);
                        --NLG.SystemMessage(charIndex,"[系統]逃跑率下降2");
                        local down= NLG.Rand(1,5);
                        if down>=4 then
                            if capture>-5 then
                                Char.SetTempData(defCharIndex, '捕獲率',capture-2);
                                --NLG.SystemMessage(charIndex,"[系統]捕獲率下降2");
                            end
                        end
                        damage = damage*0;
                    end
                end
         end
  return damage;
end

--逃跑执行
function Module:OnEnemyCommandCallBack(battleIndex, side, slot, action)
      local Round = Battle.GetTurn(battleIndex);
      for i = 10, 19 do
            local defCharIndex = Battle.GetPlayer(battleIndex, i);
            local charIndex = Battle.GetPlayIndex(battleIndex, i-10);
            if defCharIndex >= 0 then
                local runaway = Char.GetTempData(defCharIndex, '逃跑率') or 0;
                local Target_FloorId = Char.GetData(charIndex,CONST.CHAR_地图);
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

--封印结果
function Module:OnSealEventCallBack(charIndex, enemyIndex, ret)
  --self:logDebug('OnSealEventCallBack', charIndex, enemyIndex, ret)
         local capture = Char.GetTempData(enemyIndex, '捕獲率') or 0;
         local Target_FloorId = Char.GetData(charIndex,CONST.CHAR_地图);
         if Char.PetNum(charIndex)==5 then
             NLG.SystemMessage(charIndex,"[系統]寵物欄已滿無法抓取");
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

--结束、注销初始化
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
--原登即出场
function Module:onLoginEvent(charIndex)
	local Target_FloorId = Char.GetData(charIndex,CONST.CHAR_地图);
	if Target_FloorId==20233 then
		Char.Warp(charIndex,0,1000,240,75);
		NLG.SystemMessage(charIndex,"[系統]傳送離開狩獵地帶。");	
	end
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
