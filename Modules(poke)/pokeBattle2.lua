---模块类
local Module = ModuleBase:createModule('pokeBattle2')

local playerOFF = 0;
local EncountSet = {
    { Type=1, GymBoss={"日曜日", 14640, 20252,7,4}, dropMenu={74121,74122}, nowEvent={"深灰市(前伊爾村)94",311}, EnemySet = {415053, 0, 0, 0, 0, 0, 415062, 415062, 0, 0}, EnemyLevel = {60, 60, 60, 60, 60, 60, 60, 60, 60, 60} },		--
    { Type=2, GymBoss={"月曜日", 14679, 20253,7,2}, dropMenu={74118,74119}, nowEvent={"華藍市(前聖拉魯卡村)95",312}, EnemySet = {415050, 0, 0, 0, 0, 0, 415058, 415058, 0, 0}, EnemyLevel = {60, 60, 60, 60, 60, 60, 60, 60, 60, 60} },		--
    { Type=3, GymBoss={"火曜日", 14638, 20254,7,2}, dropMenu={74115,74116}, nowEvent={"枯葉市(前亞留特村)96",313}, EnemySet = {415057, 0, 0, 0, 0, 0, 415061, 415061, 0, 0}, EnemyLevel = {60, 60, 60, 60, 60, 60, 60, 60, 60, 60} },		--
    { Type=4, GymBoss={"水曜日", 14680, 20255,7,3}, dropMenu={74124,74125}, nowEvent={"玉虹市(前维诺亞村)97",314}, EnemySet = {415056, 0, 0, 0, 0, 0, 415052, 415052, 0, 0}, EnemyLevel = {60, 60, 60, 60, 60, 60, 60, 60, 60, 60} },		--
    { Type=5, GymBoss={"木曜日", 14691, 20256,6,10}, dropMenu={74127,74128}, nowEvent={"浅紅市(前奇利村)98",315}, EnemySet = {415062, 0, 0, 0, 0, 0, 415060, 415060, 0, 0}, EnemyLevel = {60, 60, 60, 60, 60, 60, 60, 60, 60, 60} },		--
    { Type=6, GymBoss={"金曜日", 14636, 20257,12,10}, dropMenu={74109,74110}, nowEvent={"金黃市(前加納村)99",316}, EnemySet = {415051, 0, 0, 0, 0, 0, 415054, 415054, 0, 0}, EnemyLevel = {60, 60, 60, 60, 60, 60, 60, 60, 60, 60} },		--
    { Type=7, GymBoss={"土曜日", 14578, 20258,4,3}, dropMenu={74112,74113}, nowEvent={"紅蓮鎮(前傑诺瓦鎮)100",317}, EnemySet = {415055, 0, 0, 0, 0, 0, 415059, 415059, 0, 0}, EnemyLevel = {60, 60, 60, 60, 60, 60, 60, 60, 60, 60} },		--
    { Type=8, GymBoss={"坂木", 14676, 20259,4,3}, dropMenu={74106,74107}, nowEvent={"常青市(前蒂娜村)101",318}, EnemySet = {416252, 0, 0, 0, 0, 416279, 416278, 416278, 416279, 416279}, EnemyLevel = {50, 50, 50, 50, 50, 50, 50, 50, 50, 50} },		--
}

local monsCard = {76009,76033,76035,76040,76047,76049,76044,76050,76053,76059,76066,76074,76078,}

local rewardPet = {
    73015,73016,73023,73046,73047,73058,	--日曜日
    73014,73018,73042,73043,73048,73049,73061,	--月曜日
	73017,73027,73032,73037,73054,73060,	--火曜日
	73020,73021,73065,	--水曜日
	73019,73034,73044,73045,73059,73062,	--木曜日
	73040,73041,73052,73053,73063,73064,	--金曜日
	73050,73051,73056,	--土曜日
}

local GymsEnemy = {
    123092,123097,123124,	--岩石属性
    123017,123101,123102,	--水属性
    123014,123015,123132,	--电属性
    123006,123043,123090,	--草属性
    123071,123074,123078,	--毒属性
    123019,123068,123153,	--超能力属性
    123138,123035,123036,	--火属性
    123080,123081,123050,	--地面属性
}	--ImageId

local restraintMap = {
    { 123022,123023,123089,123090,123091, },	--虫属性
    { 123005,123006,123042,123043,123044,123045,123152,123153, },	--草属性
    { 123013,123014,123015,123016,123058,123059,123060,123130,123131,123132, },	--电属性
    { 123009,123010,123011,123017,123046,123047,123048,123049,123100,123101,123106,123107,123108,123112,123113,123114,123121,123122,123123, },	--水属性
    { 123024,123025,123026,123027,123146,123147,123148,123149,123150, },	--一般属性
    { 123018,123019,123020,123021,123115,123116,123117, },	--幽灵属性
    { 123050,123051,123052,123067,123068,123151,123154, },	--超能力属性
    { 123061,123062,123094,123095,123096, },	--冰属性
    { 123000,123001,123002,123004,123034,123035,123036,123037,123038,123039,123118,123119,123120,123137,123138,123139, },	--火属性
    { 123028,123029,123030,123066,123076,123077,123102, },	--飞行属性
    { 123040,123041,123085,123086,123087,123088,123134,123135,123136, },	--格斗属性
    { 123092,123093,123097,123098,123099,123124,123125,123126, },	--岩石属性
    { 123079,123080,123081,123082,123103,123104,123105,123140, },	--地面属性
    { 123031,123032,123033,123069,123127,123128,123129, },	--妖精属性
    { 123109,123110,123111,123143,123144,123145, },	--钢属性
    { 123003,123055,123056,123057,123063,123064,123065,123083,123084,123133,123141,123142, },	--龙属性
    { 123053,123054,123072,123075,123078, },	--恶属性
    { 123007,123008,123070,123071,123073,123074, },	--毒属性
  }
  local attr = {
    { 1, 2, 1, 1, 1, 0.5, 2, 1, 0.5, 0.5, 0.5, 1, 1,0.5, 0.5, 1, 2, 0.5 },
    { 0.5, 0.5, 1, 2, 1, 1, 1, 1, 0.5, 0.5, 1, 2, 2, 1, 0.5, 0.5, 1, 0.5 },
    { 1, 0.5, 0.5, 2, 1, 1, 1, 1, 1, 2, 1, 1, 0, 1, 1, 0.5, 1, 1 },
    { 1, 0.5, 1, 0.5, 1, 1, 1, 1, 2, 1, 1, 2, 2, 1, 1, 0.5, 1, 1 },
    { 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0.5, 1, 1, 0.5, 1, 1, 1 },
    { 1, 1, 1, 1, 0, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0.5, 1 },
    { 1, 1, 1, 1, 1, 1, 0.5, 1, 1, 1, 2, 1, 1, 1, 0.5, 1, 0, 2 },
    { 1, 1, 1, 0.5, 1, 1, 1, 0.5, 0.5, 2, 1, 1, 2, 1, 0.5, 2, 1, 1 },
    { 2, 2, 1, 0.5, 1, 1, 1, 2, 0.5, 1, 1, 0.5, 1, 1, 2, 0.5, 1, 1 },
    { 2, 2, 0.5, 1, 1, 1, 1, 1, 1, 1, 2, 0.5, 1, 1, 0.5, 1, 1, 1 },
    { 0.5, 1, 1, 1, 2, 0, 0.5, 2, 1, 0.5, 1, 2, 1, 0.5, 2, 1, 2, 0.5 },
    { 2, 1, 1, 1, 1, 1, 1, 2, 2, 2, 0.5, 1, 0.5, 1, 0.5, 1, 1, 1 },
    { 0.5, 0.5, 2, 1, 1, 1, 1, 1, 2, 0, 1, 2, 1, 1, 2, 1, 1, 2 },
    { 1, 1, 1, 1, 1, 1, 1, 1, 0.5, 1, 2, 1, 1, 1, 0.5, 2, 2, 0.5 },
    { 1, 1, 0.5, 0.5, 1, 1, 1, 2, 0.5, 1, 1, 2, 1, 2, 0.5, 1, 1, 1 },
    { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0.5, 2, 1, 1 },
    { 1, 1, 1, 1, 1, 2, 2, 1, 1, 1, 0.5, 1, 1, 0.5, 1, 1, 0.5, 1 },
    { 1, 2, 1, 1, 1, 0.5, 1, 1, 1, 1, 1, 0.5, 0.5, 2, 0, 1, 1, 0.5 },
  }

local warp_area_name = {};
local warp_area_area = {};
local warp_area_flag = {};
warp_area_name[1] = "自創招式房間";
warp_area_area[1] = {20335,6,8};
warp_area_flag[1] = 311;

warp_area_name[2] = "戰鬥技能房間";
warp_area_area[2] = {20335,24,78};
warp_area_flag[2] = 312;

warp_area_name[3] = "單體魔法房間";
warp_area_area[3] = {20335,6,67};
warp_area_flag[3] = 313;

warp_area_name[4] = "群體魔法房間";
warp_area_area[4] = {20335,24,56};
warp_area_flag[4] = 314;

warp_area_name[5] = "狀態攻擊房間";
warp_area_area[5] = {20335,6,45};
warp_area_flag[5] = 315;

warp_area_name[6] = "狀態魔法房間";
warp_area_area[6] = {20335,24,34};
warp_area_flag[6] = 316;

warp_area_name[7] = "輔助魔法房間";
warp_area_area[7] = {20335,6,23};
warp_area_flag[7] = 317;

--- 獲取玩家當前可見的傳送清單
function getPlayerAvailableList(player)
	local availableList = {};
	for i = 2, #warp_area_name do
		if (Char.NowEvent(player, warp_area_flag[i]) == 1) then
			table.insert(availableList, i); -- 儲存原始索引
		end
	end
	if (Char.NowEvent(player, warp_area_flag[1]) == 1 and #availableList>=6) then
		availableList = {1,2,3,4,5,6,7};
	end
	return availableList;
end
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BattleStartEvent', Func.bind(self.OnbattleStartEventCallback, self))
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))

  self.GymBossNPC = self:NPC_createNormal('對戰裁判員', 14637, { map =80002, x = 18, y = 18, direction = 4, mapType = 0 })
  Char.SetData(self.GymBossNPC,CONST.对象_ENEMY_PetFlg+2,0)--可穿透体
  self:NPC_regWindowTalkedEvent(self.GymBossNPC, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select == CONST.BUTTON_关闭 or select == CONST.按钮_否 then
        return;
    end
    local nowGym = tonumber(os.date("%w",os.time()))+1;
    --local gymBoss = tonumber(Field.Get(player, 'GymBoss')) or 0;
    --local gymBossLevel = tonumber(Field.Get(player, 'GymBossLevel')) or 0;
    if seqno == 1 and select == CONST.按钮_是 then
        if (nowGym>=1) then
            local EnemyIdAr = EncountSet[nowGym].EnemySet;
            local BaseLevelAr = EncountSet[nowGym].EnemyLevel;
            local battleIndex = Battle.PVE(player, player, nil, EnemyIdAr, BaseLevelAr,  nil)
            Battle.SetWinEvent("./lua/Modules/pokeBattle2.lua", "gymBossNPC_BattleWin", battleIndex);
        end
    end
    --[[if seqno == 1 and data ==1 then
        --Field.Set(player, 'GymBoss', k);
        --Field.Set(player, 'GymBossLevel', 0);
        local Type = tonumber(Field.Get(player, 'GymBoss'));
        if (Type==v.Type) then
            local EnemyIdAr = v.EnemySet;
            local BaseLevelAr = v.EnemyLevel;
            local battleIndex = Battle.PVE(player, player, nil, EnemyIdAr, BaseLevelAr,  nil)
            Battle.SetWinEvent("./lua/Modules/pokeBattle2.lua", "gymBossNPC_BattleWin", battleIndex);
            --local encountId = v.encountId_1st;
            --local battleIndex = Battle.Encount(npc, player, encountId);
        end
    elseif seqno == 1 and data ==2 then
        Field.Set(player, 'GymBoss', k);
        Field.Set(player, 'GymBossLevel', 1);
        local Type = tonumber(Field.Get(player, 'GymBoss'));
        if (Type==v.Type) then
            local EnemyIdAr = v.EnemySet;
            local BaseLevelAr = v.EnemyLevel;
            local battleIndex = Battle.PVE(player, player, nil, EnemyIdAr, BaseLevelAr,  nil)
            Battle.SetWinEvent("./lua/Modules/pokeBattle2.lua", "gymBossNPC_BattleWin", battleIndex);
            --local encountId = v.encountId_1st;
            --local battleIndex = Battle.Encount(npc, player, encountId);
        end
    end]]
  end)
  self:NPC_regTalkedEvent(self.GymBossNPC, function(npc, player)
    --local gymBoss = tonumber(Field.Get(player, 'GymBoss')) or 0;
    --local gymBossLevel = tonumber(Field.Get(player, 'GymBossLevel')) or 0;
    local nowGym = tonumber(os.date("%w",os.time()))+1;
    if (NLG.CanTalk(npc, player) == true) then
      --[[local msg = "4\\n@c★道館挑戰★"
                .."\\n目前關卡:  第"..nowGym.."道館\\n"
                .."\\n　　════════════════════\\n"
                .."[　新手嘗試道館挑戰　]\\n"
                .."[　資深加速道館挑戰　]\\n";]]
      local msg = "\\n@c★道館挑戰★"
                .."\\n對戰目標:  "..EncountSet[nowGym].GymBoss[1].."道館\\n"
                .."\\n　　————————————————————\\n"
                .."\\n\\n　 [是]開始　　[否]取消\\n";
      NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.按钮_是否, 1, msg);
    end
    return
  end)

  self.GymRewardNPC = self:NPC_createNormal('道館徽章兌換', 400223, { map =20314, x = 26, y = 29, direction = 4, mapType = 0 })
  Char.SetData(self.GymRewardNPC,CONST.对象_ENEMY_PetFlg+2,0)--可穿透体
  self:NPC_regWindowTalkedEvent(self.GymRewardNPC, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select == CONST.BUTTON_关闭 or select == CONST.按钮_否 then
        return;
    end
    local nowGym = tonumber(os.date("%w",os.time()))+1;
    if seqno == 1 and select == CONST.按钮_是 then
        for i=1,7 do
          local gymBadge = Char.NowEvent(player, EncountSet[i].nowEvent[2]);
          if (gymBadge~=1) then
            NLG.SystemMessage(player,"[系統]尚未取得所有徽章。");
            return;
          end
        end
        if (Char.ItemSlot(player)>=25) then
          NLG.SystemMessage(player,"[系統]物品欄位置已滿。");
          return;
        end
        for i=1,7 do
          Char.NowEvent(player, EncountSet[i].nowEvent[2],0);
        end
        local lucky = NLG.Rand(3,5);
        for i=1,lucky do
          local rand = NLG.Rand(1,#monsCard);
          Char.GiveItem(player, monsCard[rand], 1);
        end
    end
  end)
  self:NPC_regTalkedEvent(self.GymRewardNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "\\n@c★道館挑戰★"
                .."\\n交出所有道館徽章獲得3-5個喚獸球\\n"
                .."\\n　　————————————————————\\n";
      for i=1,7 do
        if (i==1 or i==3 or i==5 or i==7) then msg = msg.."　　" end
        msg = msg.. EncountSet[i].GymBoss[1].."道館 "
        local gymBadge = Char.NowEvent(player, EncountSet[i].nowEvent[2]);
        if (gymBadge==1) then msg = msg.."$5已完成　$0" else msg = msg.."$8未完成$0　" end
        if (i==2 or i==4 or i==6) then msg = msg.."\\n" elseif (i==7) then msg = msg.."　　　　　　　　   \\n" end
      end
      NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.按钮_是否, 1, msg);
    end
    return
  end)

  self.boardNPC = self:NPC_createNormal('傳送告示板', 11562, { x = 23, y = 85, mapType = 0, map = 20335, direction = 4 });
  Char.SetData(self.boardNPC,CONST.对象_ENEMY_PetFlg+2,0)--可穿透体
  self:NPC_regWindowTalkedEvent(self.boardNPC, function(npc, player, _seqno, _select, _data)
    local column = tonumber(_data)
    local page = tonumber(_seqno)
    local warpPage = page;
    local winMsg = "1\\n　　　　　　　　【技能學習傳送許可】\\n"
    local winButton = CONST.BUTTON_关闭;
	local availableList = getPlayerAvailableList(player);
    -- 1. 處理關閉
    if _select == CONST.按钮_关闭 then
        return;
    end
    -- 2. 處理分頁按鈕切換
    local warpPage = page;
    if _select == CONST.BUTTON_下一页 then
        warpPage = warpPage + 1;
    elseif _select == CONST.BUTTON_上一页 then
        warpPage = warpPage - 1;
    end
    -- 3. 判斷「點選項目」
    if _select > 0 then
        -- 顯示選單介面
        local winButton = CONST.BUTTON_关闭;
    else
        -- 玩家點選了某個項目 (_select == 0)
        local selectionIndex = column;
        local realIdx = availableList[selectionIndex];	-- 透過映射表抓回真實 ID
        if realIdx then
            Char.DischargeParty(player);
            Char.Warp(player,0,warp_area_area[realIdx][1],warp_area_area[realIdx][2],warp_area_area[realIdx][3]);
        end
    end
  end)
  self:NPC_regTalkedEvent(self.boardNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local availableList = getPlayerAvailableList(player);
      local msg = "1\\n　　　　　　　　【技能學習傳送許可】\\n"
      -- 根據可用清單生成 UI
      for showIdx, realIdx in ipairs(availableList) do
         if (showIdx <= 8) then
           msg = msg .. "　　◎開放許可 " .. showIdx .. "　" .. warp_area_name[realIdx] .. "\\n"
         end
      end
      NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.按钮_关闭, 1, msg);
    end
    return
  end)

end

function Module:OnbattleStartEventCallback(battleIndex)
	local leader1 = Battle.GetPlayer(battleIndex,0)
	local leader2 = Battle.GetPlayer(battleIndex,5)
	local leader = leader1
	if Char.GetData(leader2, CONST.对象_类型) == CONST.对象类型_人 then
		leader = leader2
	end
	local gymBoss = tonumber(Field.Get(leader, 'GymBoss')) or 0;
	for i=10, 19 do
		local enemy = Battle.GetPlayIndex(battleIndex, i)
		local player = Battle.GetPlayIndex(battleIndex, i-10)
		--local enemyId = Char.GetData(enemy, CONST.对象_ENEMY_ID);
		local ImageId = Char.GetData(enemy, CONST.对象_形象);
		if enemy>=0 and Char.IsEnemy(enemy) and CheckInTable(GymsEnemy,ImageId)==true  then
			Char.SetTempData(enemy, '克制', gymBoss);
			NLG.UpChar(enemy);
			if Char.GetData(player,CONST.对象_对战开关) == 1  then
				NLG.Say(player,-1,"【屬性剋制】",4,3);
			end
		end
	end
end

function Module:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
      --self:logDebug('OnDamageCalculateCallBack', charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
      local Round = Battle.GetTurn(battleIndex);
      local leader1 = Battle.GetPlayer(battleIndex,0)
      local leader2 = Battle.GetPlayer(battleIndex,5)
      local leader = leader1
      if Char.GetData(leader2, CONST.对象_类型) == CONST.对象类型_人 then
          leader = leader2
      end
      local gymBoss = tonumber(Field.Get(leader, 'GymBoss')) or 0;
      local gymBossLevel = tonumber(Field.Get(leader, 'GymBossLevel')) or 0;
      if gymBossLevel==0 then
          speedRate=1;
      elseif gymBossLevel==1 then
          speedRate=2;
      end
      --print(Round)
      if Char.IsEnemy(defCharIndex) then
          --local enemyId = Char.GetData(defCharIndex, CONST.对象_ENEMY_ID);
          local ImageId = Char.GetData(defCharIndex, CONST.对象_形象);
          if CheckInTable(GymsEnemy,ImageId)==true then
            if Char.IsPlayer(charIndex) and Char.IsDummy(charIndex)==false  then
               if (playerOFF==1 and (Char.GetData(charIndex, CONST.对象_地图)==20252 or Char.GetData(charIndex, CONST.对象_地图)==20253 or Char.GetData(charIndex, CONST.对象_地图)==20254 or Char.GetData(charIndex, CONST.对象_地图)==20255 or Char.GetData(charIndex, CONST.对象_地图)==20256 or Char.GetData(charIndex, CONST.对象_地图)==20257 or Char.GetData(charIndex, CONST.对象_地图)==20258 or Char.GetData(charIndex, CONST.对象_地图)==20259)) then
                  damage = 1;
               else
                  damage = damage;
               end
               return damage;
            end
            if gymBoss>=0 then
                local a,b = checkRestraint_def(charIndex,defCharIndex);
                if (a==0 or b==0) then
                    damage = 1;
                else
                    --print('第'..a..'列','第'..b..'欄','倍率:'..attr[a][b])
                    damage = damage * attr[a][b] * speedRate;
                end
            end
            return damage;
          end

      elseif Char.IsEnemy(charIndex) and flg ~= CONST.DamageFlags.Magic then
          --local enemyId = Char.GetData(charIndex, CONST.对象_ENEMY_ID);
          local ImageId = Char.GetData(charIndex, CONST.对象_形象);
          if CheckInTable(GymsEnemy,ImageId)==true then
            if Char.IsPlayer(defCharIndex) and Char.IsDummy(defCharIndex)==false  then
               if (Char.GetData(charIndex, CONST.对象_地图)==20252 or Char.GetData(charIndex, CONST.对象_地图)==20253 or Char.GetData(charIndex, CONST.对象_地图)==20254 or Char.GetData(charIndex, CONST.对象_地图)==20255 or Char.GetData(charIndex, CONST.对象_地图)==20256 or Char.GetData(charIndex, CONST.对象_地图)==20257 or Char.GetData(charIndex, CONST.对象_地图)==20258 or Char.GetData(charIndex, CONST.对象_地图)==20259) then
                  damage = damage;
               end
               return damage;
            end
            --local State = Char.GetTempData(defCharIndex, '克制') or 0;
            if gymBoss>=0 then
                local a,b = checkRestraint_att(charIndex,defCharIndex);
                if (a==0 or b==0) then
                    damage = damage;
                else
                    --print('第'..a..'列','第'..b..'欄','倍率:'..attr[a][b])
                    damage = damage * attr[a][b] * speedRate;
                end
            end
            return damage;
          end

      elseif Char.IsEnemy(charIndex) and flg == CONST.DamageFlags.Magic then
          --local enemyId = Char.GetData(charIndex, CONST.对象_ENEMY_ID);
          local ImageId = Char.GetData(charIndex, CONST.对象_形象);
          if CheckInTable(GymsEnemy,ImageId)==true then
            if Char.IsPlayer(defCharIndex) and Char.IsDummy(defCharIndex)==false  then
               if (Char.GetData(charIndex, CONST.对象_地图)==20252 or Char.GetData(charIndex, CONST.对象_地图)==20253 or Char.GetData(charIndex, CONST.对象_地图)==20254 or Char.GetData(charIndex, CONST.对象_地图)==20255 or Char.GetData(charIndex, CONST.对象_地图)==20256 or Char.GetData(charIndex, CONST.对象_地图)==20257 or Char.GetData(charIndex, CONST.对象_地图)==20258 or Char.GetData(charIndex, CONST.对象_地图)==20259) then
                  damage = damage;
               end
               return damage;
            end
            --local State = Char.GetTempData(defCharIndex, '克制') or 0;
            if gymBoss>=0 then
                local a,b = checkRestraint_att(charIndex,defCharIndex);
                if (a==0 or b==0) then
                    damage = damage;
                else
                    --print('第'..a..'列','第'..b..'欄','倍率:'..attr[a][b])
                    damage = damage * attr[a][b] * 0.8 * speedRate;
                end
            end
            return damage;
          end

       end
  return damage;
end

function gymBossNPC_BattleWin(battleIndex, charIndex)
	--计算等第
	local leader1 = Battle.GetPlayer(battleIndex,0)
	local leader2 = Battle.GetPlayer(battleIndex,5)
	local leader = leader1
	if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
		leader = leader2
	end
	local gymBoss = tonumber(Field.Get(leader, 'GymBoss')) or 0;
	local gymBossLevel = tonumber(Field.Get(leader, 'GymBossLevel')) or 0;

	if (Char.GetData(charIndex, CONST.对象_地图)==80002) then
	--分配奖励
	for p=0,9 do
		local player = Battle.GetPlayIndex(battleIndex, p);
		local drop = {0,0,0,0,0,0,0,1,1,1,}
		local rand = drop[NLG.Rand(1,10)];
		if player>=0 and Char.GetData(player, CONST.对象_类型) == CONST.对象类型_人 then
			local nowGym = tonumber(os.date("%w",os.time()))+1;
			Char.NowEvent(player, EncountSet[nowGym].nowEvent[2], 1);
			--Char.GiveItem(player, EncountSet[nowGym].dropMenu[NLG.Rand(1,2)], rand);
			Char.AddGold(player, 5000);
			NLG.SystemMessage(player, "[系統]戰勝道館戰獲得5000G金幣。");
			Char.Warp(player,0,20314,23,32);
		end
	end
	end
	Battle.UnsetWinEvent(battleIndex);
end

function CheckInTable(_idTab, _idVar) ---循环函数
	for k,v in pairs(_idTab) do
		if v==_idVar then
			return true
		end
	end
	return false
end

--我方攻charIndex,怪方守defCharIndex
function checkRestraint_def(aIndex,bIndex)
          local a=0;
          local b=0;
          --local enemyId_a = Char.GetData(aIndex,CONST.PET_PetID);
          local ImageId_a = Char.GetData(aIndex, CONST.对象_形象);
          if Char.IsDummy(aIndex)==true  then
              --enemyId_a = Char.GetData(aIndex, CONST.对象_金币);
              ImageId_a = Char.GetData(aIndex, CONST.对象_形象);
          end
          --local enemyId_b = Char.GetData(bIndex, CONST.对象_ENEMY_ID);
          local ImageId_b = Char.GetData(bIndex, CONST.对象_形象);
          for i, v in ipairs(restraintMap) do
              for k, enemyId in ipairs(v) do
                    if (v[k]==ImageId_a) then
                        --print(v[k], ImageId_a)
                        a = i;
                    end
              end
           end
           for j, v in ipairs(restraintMap) do
              for k, enemyId in ipairs(v) do
                    if (v[k]==ImageId_b) then
                        b = j;
                    end
              end
           end
           return a,b;
end

--怪方攻charIndex,我方守defCharIndex
function checkRestraint_att(aIndex,bIndex)
          local a=0;
          local b=0;
          --local enemyId_a = Char.GetData(aIndex, CONST.对象_ENEMY_ID);
          --local enemyId_b = Char.GetData(bIndex,CONST.PET_PetID);
          local ImageId_a = Char.GetData(aIndex, CONST.对象_形象);
          local ImageId_b = Char.GetData(bIndex, CONST.对象_形象);
          if Char.IsDummy(bIndex)==true  then
              --enemyId_b = Char.GetData(bIndex, CONST.对象_金币);
              ImageId_b = Char.GetData(bIndex, CONST.对象_形象);
          end
          for i, v in ipairs(restraintMap) do
              for k, enemyId in ipairs(v) do
                    if (v[k]==ImageId_a) then
                        --print(v[k], ImageId_a)
                        a = i;
                    end
              end
           end
           for j, v in ipairs(restraintMap) do
              for k, enemyId in ipairs(v) do
                    if (v[k]==ImageId_b) then
                        b = j;
                    end
              end
           end
           return a,b;
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
