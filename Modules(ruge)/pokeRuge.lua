---模块类
local Module = ModuleBase:createModule('pokeRuge')
local sgModule = getModule("setterGetter")
local JSON=require "lua/Modules/json"
local _ = require "lua/Modules/underscore"

-- NOTE 查询数据库 heroes 数据
function Module:queryHeroesData(charIndex)
  local cdKey = Char.GetData(charIndex, CONST.对象_CDK)
  local regNo = Char.GetData(charIndex, CONST.对象_RegistNumber)
  local sql="select value from des_heroes where cdkey= "..SQL.sqlValue(cdKey).." and regNo = "..SQL.sqlValue(regNo).." and is_deleted <> 1"
  local res,x =  SQL.QueryEx(sql)

  -- print(sql)
  -- print(res, x)
  local heroesData={};
  if res.rows then
    for i, row in ipairs(res.rows) do
      local value,pos = JSON.parse(row.value)
      -- print('heroesFn::250 >>', value, pos);
      table.insert(heroesData,value)
    end
  end

  return heroesData
end

-- NOTE 根据 heroId 查询 heroData
function Module:getHeroDataByid(charIndex,id)
    local heroesData = sgModule:get(charIndex,"heroes")
    local heroData = _.detect(heroesData, function(i) return i.id==id end)
    return heroData
end

-- NOTE 获取出战佣兵 数据
function Module:getCampHeroesData(charIndex)
  local heroesData = sgModule:get(charIndex,"heroes") or {}
  return _.select(heroesData,function(item) return item.status==1 end)
end

-----------------------------------------------
--系统设置
local partnerReserve=1;		--1保留.0全删除
local bagItemReserve=1;		--1保留.0全删除
local bagPetReserve=1;		--1保留.0全删除
local poolItemReserve=1;		--1保留.0全删除
-----------------------------------------------
--NPC设置
local rugeBoss = {}
rugeBoss[1] = {"Ruge輪迴啟動", 99453, 7351,9,29}
rugeBoss[2] = {"Ruge切磋對戰", 14642, 7351,67,42}
rugeBoss[3] = {"Ruge隨機獎品", 0, 7351,61,12}
rugeBoss[4] = {"Ruge隨機獎品", 0, 7351,67,13}
rugeBoss[5] = {"Ruge隨機獎品", 0, 7351,72,11}
rugeBoss[6] = {"Ruge回歸輪迴", 98527, 7351,17,33}

local EnemySet = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
--local MobsSet = {102100,102104,102105,102106,102109,102110,102114,102121,102125,102152,}	--杂兵
--local BossSet = {102154,102155,102156,102157,103257,103261,103262,103263,}		--头目
local MobsSet_L = {710001,710002,710003,710004,710005,710006,710007,710008,}		--enemyId
local MobsSet_M = {710009,710010,710011,710012,710013,710014,710015,710016,710017,}
local MobsSet_H = {710018,710019,710020,710021,710022,710023,710024,710025,710026,710027,710028,710029,}
local BossSet_L = {710030,710031,710032,710033,710034,710035,}
local BossSet_H = {710038,710039,710040,710045,710046,710047,}
-----------------------------------------------
local BonusSet_L = {720001,720002,720003,720004,720005,720006,720007,720008,720009,720017,720037,720038,720039,720040,}	--encountId
--720010,720014,720015,720016,
local BonusSet_H = {720018,720019,720020,720021,720022,720023,720024,720026,720027,720028,720029,720032,}
--720011,720012,720013,720025,720030,720031,720033,720034,720035,720036,
-----------------------------------------------
--奖励设置
local prizeMenu = {}
prizeMenu[1] = {
  {3635,4031,4430,4833,5231,5631,6031,},			--装备
  {71101,71102,71103,71104,71105,71106,71107,71108,71109,71110,71111,71112,},			--伙伴
  {72100,72101,74000,74003,74006,74009,74012,74015,74018,74021,74024,74027,74030,74033,74036,74039,},			--稀有道具.技能书
}
prizeMenu[2] = {
  {235,240,245,250,255,260,265,6481,200,205,210,215,220,},			--装备
  {71113,71114,71115,71116,71117,71118,71119,71120,71121,},			--伙伴
  {72102,72103,74001,74004,74007,74010,74013,74016,74019,74022,74025,74028,74031,74034,74037,74040,},			--稀有道具.技能书
}
prizeMenu[3] = {
  {3670,4084,4481,4883,602215,602415,602615,602616,600016,600216,600416,600615,600815,},			--装备
  {71122,71123,71124,71125,71126,71127,71128,71129,71130,71131,71132,71133,},			--伙伴
  {72104,72105,74002,74005,74008,74011,74014,74017,74020,74023,74026,74029,74032,74035,74038,74041,},			--稀有道具.技能书
}
-----------------------------------------------
--成就设置
local achieveList = {
  { nameColor=0, newColor=1, endEvent=301, baselevel=5, finalEnemySet={710042, 710014, 710013, 0, 0, 710015, 0, 0, 0, 710043},},
  { nameColor=1, newColor=5, endEvent=302, baselevel=10, finalEnemySet={720010, 0, 0, 0, 0, 710031, 0, 0, 710032, 710030},},
  { nameColor=5, newColor=2, endEvent=303, baselevel=15, finalEnemySet={720013, 0, 0, 720011, 720012, 720016, 720015, 720014, 0, 0},},
  { nameColor=2, newColor=6, endEvent=304, baselevel=20, finalEnemySet={710041, 0, 0, 0, 710034, 720025, 710033, 710035, 720031, 720030},},
  { nameColor=6, newColor=4, endEvent=305, baselevel=30, finalEnemySet={720033, 0, 0, 710036, 710037, 0, 0, 0, 0, 0},},
  { nameColor=4, newColor=10, endEvent=306, baselevel=40, finalEnemySet={720036, 0, 0, 0, 0, 0, 720035, 720034, 0, 0},},
  { nameColor=10, newColor=10, endEvent=306, baselevel=50, finalEnemySet={710047, 0, 0, 0, 0, 0, 710046, 710045, 0, 0},},
}

-------------------------------------------------------------------------------------------
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BattleStartEvent', Func.bind(self.OnbattleStartEventCallback, self))
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
  self:regCallback('BeforeBattleTurnEvent', Func.bind(self.OnBeforeBattleTurnCommand, self))
  self:regCallback('LoginGateEvent', Func.bind(self.onLoginEvent, self));
  self:regCallback('LevelUpEvent', Func.bind(self.onLevelUpEvent, self));
  self:regCallback('BattlePetLeaveCheckEvent', Func.bind(self.onBattlePetLeaveCheckEvent, self));
  RugeNPC = self:NPC_createNormal(rugeBoss[1][1], rugeBoss[1][2], { map = rugeBoss[1][3], x = rugeBoss[1][4], y = rugeBoss[1][5], direction = 0, mapType = 0 })
  Char.SetData(RugeNPC,CONST.对象_ENEMY_PetFlg+2,0);
  self:NPC_regWindowTalkedEvent(RugeNPC, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select == CONST.按钮_关闭 then
        return;
    end
    local rugeBossLevel = tonumber(Field.Get(player, 'RugeBossLevel')) or 0;
    if seqno == 1 and select==CONST.按钮_下一页 then
      local msg = "@c★輪迴試煉啟動★"
                .."\\n◇選擇夥伴每次都是全新的開始◇"
                .."\\n　　————————————————————\\n";
      local partner = {710001,710002,710003};
      for i = 1,3 do
        local EnemyBaseDataIndex = Data.EnemyBaseGetDataIndex(partner[i]);
        local partner_image = Data.EnemyBaseGetData(EnemyBaseDataIndex, CONST.EnemyBase_形象);
        local partner_space = 3 + 7*(i-1);
        local imageText_i = "@g,"..partner_image..","..partner_space..",8,6,0@"
        msg = msg .. imageText_i
      end
      local msg = msg .."　 $5【　坦克　】　 【　進攻　】　 【　輔助　】\\n"
      NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.按钮_下取消, 11, msg);
    elseif seqno == 11 and select==CONST.按钮_下一页 then
      local msg = "4\\n@c★輪迴試煉啟動★"
                .."\\n◇選擇夥伴每次都是全新的開始◇"
                .."\\n　　————————————————————\\n\\n"
                .."[　選擇  草系夥伴　]\\n"
                .."[　選擇  火系夥伴　]\\n"
                .."[　選擇  水系夥伴　]\\n";
      NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.按钮_关闭, 12, msg);
    elseif seqno == 12 then
      if (partnerReserve==0) then
        local heroesData = self:queryHeroesData(player);
        for k, v in ipairs(heroesData) do
          local heroData = self:getHeroDataByid(player,v.id);
          local heroIndex  = heroData.index
          if heroIndex~=nil then
            Char.LeaveParty(heroIndex);
          end
          getModule('heroesFn'):delHeroDummy(player,heroData);
          getModule('heroesFn'):deleteHeroData(player,v);
        end
      end
      if data==1 then
        Field.Set(player, 'RugeBossLevel', 0);
        Field.Set(player, 'RugeEnemyIdAr', "0");
        local rugePrizeString,rugePrizeId = PrizeTmpTable(player, -1, 0);
        Field.Set(player, 'RugePrizeLevel', rugePrizeString);
        Char.SetData(player, CONST.对象_等级, 30);
        Char.SetData(player, CONST.对象_体力, 0);
        Char.SetData(player, CONST.对象_力量, 0);
        Char.SetData(player, CONST.对象_强度, 0);
        Char.SetData(player, CONST.对象_速度, 0);
        Char.SetData(player, CONST.对象_魔法, 0);
        Char.SetData(player, CONST.对象_升级点, 146);
        if (Char.GetData(player, CONST.对象_名色)==4 or Char.GetData(player, CONST.对象_名色)==10) then
          Char.SetData(player, CONST.对象_等级, 40);
          Char.SetData(player, CONST.对象_升级点, 186);
        end
        Char.SetData(player, CONST.对象_经验, 0);
        Char.SetData(player, CONST.对象_登陆点, 0);
        Char.EndEvent(player, 0, 1);
        NLG.UpChar(player);
        Char.Warp(player,0,7351,16,28);
        Char.GiveItem(player, 71101, 1);
        Char.GiveItem(player, 607728, 1);
      elseif data==2 then
        Field.Set(player, 'RugeBossLevel', 0);
        Field.Set(player, 'RugeEnemyIdAr', "0");
        local rugePrizeString,rugePrizeId = PrizeTmpTable(player, -1, 0);
        Field.Set(player, 'RugePrizeLevel', rugePrizeString);
        Char.SetData(player, CONST.对象_等级, 30);
        Char.SetData(player, CONST.对象_体力, 0);
        Char.SetData(player, CONST.对象_力量, 0);
        Char.SetData(player, CONST.对象_强度, 0);
        Char.SetData(player, CONST.对象_速度, 0);
        Char.SetData(player, CONST.对象_魔法, 0);
        Char.SetData(player, CONST.对象_升级点, 146);
        if (Char.GetData(player, CONST.对象_名色)==4 or Char.GetData(player, CONST.对象_名色)==10) then
          Char.SetData(player, CONST.对象_等级, 40);
          Char.SetData(player, CONST.对象_升级点, 186);
        end
        Char.SetData(player, CONST.对象_经验, 0);
        Char.SetData(player, CONST.对象_登陆点, 0);
        Char.EndEvent(player, 0, 1);
        NLG.UpChar(player);
        Char.Warp(player,0,7351,16,28);
        Char.GiveItem(player, 71102, 1);
        Char.GiveItem(player, 607728, 1);
      elseif data==3 then
        Field.Set(player, 'RugeBossLevel', 0);
        Field.Set(player, 'RugeEnemyIdAr', "0");
        local rugePrizeString,rugePrizeId = PrizeTmpTable(player, -1, 0);
        Field.Set(player, 'RugePrizeLevel', rugePrizeString);
        Char.SetData(player, CONST.对象_等级, 30);
        Char.SetData(player, CONST.对象_体力, 0);
        Char.SetData(player, CONST.对象_力量, 0);
        Char.SetData(player, CONST.对象_强度, 0);
        Char.SetData(player, CONST.对象_速度, 0);
        Char.SetData(player, CONST.对象_魔法, 0);
        Char.SetData(player, CONST.对象_升级点, 146);
        if (Char.GetData(player, CONST.对象_名色)==4 or Char.GetData(player, CONST.对象_名色)==10) then
          Char.SetData(player, CONST.对象_等级, 40);
          Char.SetData(player, CONST.对象_升级点, 186);
        end
        Char.SetData(player, CONST.对象_经验, 0);
        Char.SetData(player, CONST.对象_登陆点, 0);
        Char.EndEvent(player, 0, 1);
        NLG.UpChar(player);
        Char.Warp(player,0,7351,16,28);
        Char.GiveItem(player, 71103, 1);
        Char.GiveItem(player, 607728, 1);
      end
      if (bagItemReserve==0) then
        for slot=0,87 do
          Char.DelItemBySlot(player,slot);
        end
      end
      if (bagPetReserve==0) then
        for slot=0,4 do
          Char.DelSlotPet(player,slot);
        end
      end
      if (poolItemReserve==0) then
        for slot=0,179 do
          Char.RemovePoolItem(player,slot);
        end
      end
      local soulMenu = {70196,70197,70198,70199}
      Char.GiveItem(player,soulMenu[NLG.Rand(1,4)]);
      Char.GiveItem(player,soulMenu[NLG.Rand(1,4)]);
    end
  end)
  self:NPC_regTalkedEvent(RugeNPC, function(npc, player)
    local rugeBossLevel = tonumber(Field.Get(player, 'RugeBossLevel')) or 0;
    local nowLevel = rugeBossLevel+1;
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "\\n女神諾綸："
                .."\\n你不幸被捲入勇者召喚的意外來到了這裡，目前無法回到原本的世界\\n"
                .."\\n為了向你「表達意外的歉意」，將給予你女神加持與支援\\n"
                .."\\n請在這小小的寶可夢奇幻世界，再次開啟人生\\n";
      NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.按钮_下取消, 1, msg);
    end
    return
  end)


  RugeNPC2 = self:NPC_createNormal(rugeBoss[2][1], rugeBoss[2][2], { map = rugeBoss[2][3], x = rugeBoss[2][4], y = rugeBoss[2][5], direction = 4, mapType = 0 })
  Char.SetData(RugeNPC2,CONST.对象_ENEMY_PetFlg+2,0);
  self:NPC_regWindowTalkedEvent(RugeNPC2, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select == CONST.按钮_否 then
        return;
    elseif seqno == 2 and select == CONST.按钮_确定 then
		if (Char.ItemNum(player, 66668)<5) then
          NLG.SystemMessage(player,"[系統]金幣數量不足，無法刷新對戰。");
          return;
        end
        local EnemyIdAr = SetEnemySet(player, 1);
        Char.DelItem(player, 66668, 5);
        NLG.SystemMessage(player,"[系統]交出5金幣刷新對戰。");
    elseif seqno == 2 and select == CONST.按钮_是 then
        local rugeBossLevel = tonumber(Field.Get(player, 'RugeBossLevel')) or 0;
        for k,v in ipairs(achieveList) do
            if (Char.GetData(player, CONST.对象_名色)==v.nameColor) then
                baselevel_now=v.baselevel;
                goto continue
            end
        end
        ::continue::
        local enemyLv = baselevel_now + (rugeBossLevel * 1);
        if (enemyLv>=250) then
            enemyLv =250;
        end
        local EnemyIdAr = SetEnemySet(player, 0);
        local BaseLevelAr = {enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv, enemyLv}
        local battleIndex = Battle.PVE(player, player, nil, EnemyIdAr, BaseLevelAr,  nil)
        Battle.SetWinEvent("./lua/Modules/pokeRuge.lua", "RugeNPC_BattleWin", battleIndex);
    end
  end)
  self:NPC_regTalkedEvent(RugeNPC2, function(npc, player)
    local rugeBossLevel = tonumber(Field.Get(player, 'RugeBossLevel')) or 0;
    local nowLevel = rugeBossLevel+1;
    for k,v in ipairs(achieveList) do
        if (Char.GetData(player, CONST.对象_名色)==v.nameColor) then
            baselevel_now=v.baselevel;
            goto continue
        end
    end
    ::continue::
    local enemyLv = baselevel_now + (rugeBossLevel * 1);
    if (enemyLv>=250) then
        enemyLv =250;
    end
    if (NLG.CanTalk(npc, player) == true) then
      local EnemyIdAr = SetEnemySet(player, 0);
      local EnemyId = EnemyIdAr[1];
      if (rugeBossLevel>=30 and rugeBossLevel<=101) then 
        EnemyId = EnemyIdAr[2];
        if (math.fmod(rugeBossLevel, 10)==4 or math.fmod(rugeBossLevel, 10)==9) then
          EnemyId = EnemyIdAr[1];
        end
      end
      local EnemyDataIndex = Data.EnemyGetDataIndex(EnemyId);
      local enemyBaseId = Data.EnemyGetData(EnemyDataIndex, CONST.Enemy_Base编号);
      local enemyExp = Data.EnemyGetData(EnemyDataIndex, CONST.Enemy_战斗经验);
      local EnemyBaseDataIndex = Data.EnemyBaseGetDataIndex(enemyBaseId);
      local Enemy_name = Data.EnemyBaseGetData(EnemyBaseDataIndex, CONST.EnemyBase_名字);
      local EnemyBase_image =Data.EnemyBaseGetData(EnemyBaseDataIndex, CONST.EnemyBase_形象);
      local imageText = "@g,"..EnemyBase_image..",3,6,6,0@"
      local msg = imageText .."\\n@c★魔力寶可夢肉鴿★"
                            .."\\n進度層數:"..nowLevel.." 怪物等級:"..enemyLv..""
                            .."\\n　　　$5"..Enemy_name.." 最多取得經驗:"..enemyExp.."\\n"
                            .."\\n　　　　　$2怪物造成傷害增加: "..(rugeBossLevel*0.5).."%"
                            .."\\n　　　　　$2怪物減輕受到傷害: "..(rugeBossLevel*0.1).."%\\n"
                            .."\\n　　————————————————————\\n"
                            .."$4[確定]5金幣刷新  [是]開始 [否]取消\\n";

      Char.SetData(RugeNPC2,CONST.对象_形象,EnemyBase_image);
      NLG.UpChar(RugeNPC2);
      NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, 13, 2, msg);
    end
    return
  end)

  RugeNPC3 = self:NPC_createNormal(rugeBoss[6][1], rugeBoss[6][2], { map = rugeBoss[6][3], x = rugeBoss[6][4], y = rugeBoss[6][5], direction = 0, mapType = 0 })
  Char.SetData(RugeNPC3,CONST.对象_ENEMY_PetFlg+2,0);
  self:NPC_regWindowTalkedEvent(RugeNPC3, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select == CONST.按钮_关闭 then
        return;
    end
    if seqno == 1 and select==CONST.按钮_确定 then
        local rugeBossLevel = tonumber(Field.Get(player, 'RugeBossLevel')) or 0;
        if (Char.GetData(player, CONST.对象_名色)==0 and rugeBossLevel==0) then
          NLG.SystemMessage(player,"[系統]輪迴試煉請前方找女神。");
          return;
        elseif (Char.GetData(player, CONST.对象_名色)~=0 and rugeBossLevel==0) then
          NLG.SystemMessage(player,"[系統]聯盟冠軍請重新入場。");
          return;
        end
        if (Char.ItemNum(player, 66668)<30) then
          NLG.SystemMessage(player,"[系統]金幣數量不足，無法傳送。");
          return;
        end
        Field.Set(player, 'RugeBossLevel', 0);
        Field.Set(player, 'RugeEnemyIdAr', "0");
        local rugePrizeString,rugePrizeId = PrizeTmpTable(player, -1, 0);
        Field.Set(player, 'RugePrizeLevel', rugePrizeString);
        Char.SetData(player, CONST.对象_登陆点, 0);
        NLG.UpChar(player);
        Char.Warp(player,0,7351,16,28);
        Char.DelItem(player, 66668, 30);
        NLG.SystemMessage(player,"[系統]交出30金幣重新輪迴進場。");
    end
  end)
  self:NPC_regTalkedEvent(RugeNPC3, function(npc, player)
    local rugeBossLevel = tonumber(Field.Get(player, 'RugeBossLevel')) or 0;
    local nowLevel = rugeBossLevel+1;
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "\\n時空神克洛諾斯："
                .."\\n不知道你遭遇什麼意外事件，掉入召喚儀式的時空裂縫無法回歸\\n"
                .."\\n我可以施展時空神的秘術「幫助你」，將你傳送回去寶可夢奇幻世界\\n"
                .."\\n但是代價不斐需要30金幣，你願意支付嗎？\\n";
      NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.按钮_确定关闭, 1, msg);
    end
    return
  end)

  RugeprizeNPC1 = self:NPC_createNormal(rugeBoss[3][1], rugeBoss[3][2], { map = rugeBoss[3][3], x = rugeBoss[3][4], y = rugeBoss[3][5], direction = 0, mapType = 0 })
  Char.SetData(RugeprizeNPC1,CONST.对象_ENEMY_PetFlg+2,0);
  self:NPC_regWindowTalkedEvent(RugeprizeNPC1, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select == CONST.按钮_否 then
        return;
    elseif seqno == 2 and select == CONST.按钮_确定 then
		if (Char.ItemNum(player, 66668)<2) then
          NLG.SystemMessage(player,"[系統]金幣數量不足，無法刷新獎勵。");
          return;
        end
        local rugeBossLevel = tonumber(Field.Get(player, 'RugeBossLevel')) or 0;
        local rugePrizeString,rugePrizeId = PrizeTmpTable(player, 1, 1);
        Field.Set(player, 'RugePrizeLevel', rugePrizeString);
        Char.DelItem(player, 66668, 2);
        NLG.SystemMessage(player,"[系統]交出2金幣刷新獎勵。");
    elseif seqno == 2 and select == CONST.按钮_是 then
        local rugeBossLevel = tonumber(Field.Get(player, 'RugeBossLevel')) or 0;
        local rugePrizeString,rugePrizeId = PrizeTmpTable(player, 0, 1);
        local itemIndex = Char.GiveItem(player, rugePrizeId, 1);
        Item.SetData(itemIndex, CONST.道具_已鉴定, 1);
        Item.UpItem(player,-1);
        Char.Warp(player,0,7351,25,29);
    end
  end)
  self:NPC_regTalkedEvent(RugeprizeNPC1, function(npc, player)
    local rugeBossLevel = tonumber(Field.Get(player, 'RugeBossLevel')) or 0;
    local nowLevel = rugeBossLevel+1;
    if (NLG.CanTalk(npc, player) == true) then
      local rugePrizeString,rugePrizeId = PrizeTmpTable(player, 0, 1);
      Field.Set(player, 'RugePrizeLevel', rugePrizeString);
      --local ItemsetIndex_Prize = Data.ItemsetGetIndex(prizeMenu[1][1][2]);
      local ItemsetIndex_Prize = Data.ItemsetGetIndex(rugePrizeId);
      local Prize_name = Data.ItemsetGetData(ItemsetIndex_Prize, CONST.ITEMSET_TRUENAME);
      local Prize_DataPos_2 = Data.ItemsetGetData(ItemsetIndex_Prize, CONST.ITEMSET_BASEIMAGENUMBER);
      local Prize_DataPos_3 = Data.ItemsetGetData(ItemsetIndex_Prize, CONST.ITEMSET_EXPLANATION1);
      local Prize_DataPos_3 = Data.GetMessage(Prize_DataPos_3);
      local imageText = "@g,"..Prize_DataPos_2..",3,5,0,0@"

      local msg = imageText .. "\\n@c★魔力寶可夢肉鴿★"
                            .."\\n獎品說明:　　$5"..Prize_name.."\\n"
                            .."\\n\\n　　"..Prize_DataPos_3.."\\n"
                            .."\\n\\n　　————————————————————\\n"
                            .."$4[確定]2金幣刷新  [是]選取 [否]取消\\n";
      NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, 13, 2, msg);
    end
    return
  end)

  RugeprizeNPC2 = self:NPC_createNormal(rugeBoss[4][1], rugeBoss[4][2], { map = rugeBoss[4][3], x = rugeBoss[4][4], y = rugeBoss[4][5], direction = 0, mapType = 0 })
  Char.SetData(RugeprizeNPC2,CONST.对象_ENEMY_PetFlg+2,0);
  self:NPC_regWindowTalkedEvent(RugeprizeNPC2, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select == CONST.按钮_否 then
        return;
    elseif seqno == 2 and select == CONST.按钮_确定 then
		if (Char.ItemNum(player, 66668)<2) then
          NLG.SystemMessage(player,"[系統]金幣數量不足，無法刷新獎勵。");
          return;
        end
        local rugeBossLevel = tonumber(Field.Get(player, 'RugeBossLevel')) or 0;
        local rugePrizeString,rugePrizeId = PrizeTmpTable(player, 1, 2);
        Field.Set(player, 'RugePrizeLevel', rugePrizeString);
        Char.DelItem(player, 66668, 2);
        NLG.SystemMessage(player,"[系統]交出2金幣刷新獎勵。");
    elseif seqno == 2 and select == CONST.按钮_是 then
        local rugeBossLevel = tonumber(Field.Get(player, 'RugeBossLevel')) or 0;
        local rugePrizeString,rugePrizeId = PrizeTmpTable(player, 0, 2);
        local itemIndex = Char.GiveItem(player, rugePrizeId, 1);
        Item.SetData(itemIndex, CONST.道具_已鉴定, 1);
        Item.UpItem(player,-1);
        Char.Warp(player,0,7351,25,29);
    end
  end)
  self:NPC_regTalkedEvent(RugeprizeNPC2, function(npc, player)
    local rugeBossLevel = tonumber(Field.Get(player, 'RugeBossLevel')) or 0;
    local nowLevel = rugeBossLevel+1;
    if (NLG.CanTalk(npc, player) == true) then
      local rugePrizeString,rugePrizeId = PrizeTmpTable(player, 0, 2);
      Field.Set(player, 'RugePrizeLevel', rugePrizeString);
      --local ItemsetIndex_Prize = Data.ItemsetGetIndex(prizeMenu[1][1][2]);
      local ItemsetIndex_Prize = Data.ItemsetGetIndex(rugePrizeId);
      local Prize_name = Data.ItemsetGetData(ItemsetIndex_Prize, CONST.ITEMSET_TRUENAME);
      local Prize_DataPos_2 = Data.ItemsetGetData(ItemsetIndex_Prize, CONST.ITEMSET_BASEIMAGENUMBER);
      local Prize_DataPos_3 = Data.ItemsetGetData(ItemsetIndex_Prize, CONST.ITEMSET_EXPLANATION1);
      local Prize_DataPos_3 = Data.GetMessage(Prize_DataPos_3);
      local imageText = "@g,"..Prize_DataPos_2..",3,5,0,0@"

      local msg = imageText .. "\\n@c★魔力寶可夢肉鴿★"
                            .."\\n獎品說明:　　$5"..Prize_name.."\\n"
                            .."\\n\\n　　"..Prize_DataPos_3.."\\n"
                            .."\\n\\n　　————————————————————\\n"
                            .."$4[確定]2金幣刷新  [是]選取 [否]取消\\n";
      NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, 13, 2, msg);
    end
    return
  end)

  RugeprizeNPC3 = self:NPC_createNormal(rugeBoss[5][1], rugeBoss[5][2], { map = rugeBoss[5][3], x = rugeBoss[5][4], y = rugeBoss[5][5], direction = 0, mapType = 0 })
  Char.SetData(RugeprizeNPC3,CONST.对象_ENEMY_PetFlg+2,0);
  self:NPC_regWindowTalkedEvent(RugeprizeNPC3, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select == CONST.按钮_否 then
        return;
    elseif seqno == 2 and select == CONST.按钮_确定 then
		if (Char.ItemNum(player, 66668)<2) then
          NLG.SystemMessage(player,"[系統]金幣數量不足，無法刷新獎勵。");
          return;
        end
        local rugeBossLevel = tonumber(Field.Get(player, 'RugeBossLevel')) or 0;
        local rugePrizeString,rugePrizeId = PrizeTmpTable(player, 1, 3);
        Field.Set(player, 'RugePrizeLevel', rugePrizeString);
        Char.DelItem(player, 66668, 2);
        NLG.SystemMessage(player,"[系統]交出2金幣刷新獎勵。");
    elseif seqno == 2 and select == CONST.按钮_是 then
        local rugeBossLevel = tonumber(Field.Get(player, 'RugeBossLevel')) or 0;
        local rugePrizeString,rugePrizeId = PrizeTmpTable(player, 0, 3);
        local itemIndex = Char.GiveItem(player, rugePrizeId, 1);
        Item.SetData(itemIndex, CONST.道具_已鉴定, 1);
        Item.UpItem(player,-1);
        Char.Warp(player,0,7351,25,29);
    end
  end)
  self:NPC_regTalkedEvent(RugeprizeNPC3, function(npc, player)
    local rugeBossLevel = tonumber(Field.Get(player, 'RugeBossLevel')) or 0;
    local nowLevel = rugeBossLevel+1;
    if (NLG.CanTalk(npc, player) == true) then
      local rugePrizeString,rugePrizeId = PrizeTmpTable(player, 0, 3);
      Field.Set(player, 'RugePrizeLevel', rugePrizeString);
      --local ItemsetIndex_Prize = Data.ItemsetGetIndex(prizeMenu[1][1][2]);
      local ItemsetIndex_Prize = Data.ItemsetGetIndex(rugePrizeId);
      local Prize_name = Data.ItemsetGetData(ItemsetIndex_Prize, CONST.ITEMSET_TRUENAME);
      local Prize_DataPos_2 = Data.ItemsetGetData(ItemsetIndex_Prize, CONST.ITEMSET_BASEIMAGENUMBER);
      local Prize_DataPos_3 = Data.ItemsetGetData(ItemsetIndex_Prize, CONST.ITEMSET_EXPLANATION1);
      local Prize_DataPos_3 = Data.GetMessage(Prize_DataPos_3);
      local imageText = "@g,"..Prize_DataPos_2..",3,5,0,0@"

      local msg = imageText .. "\\n@c★魔力寶可夢肉鴿★"
                            .."\\n獎品說明:　　$5"..Prize_name.."\\n"
                            .."\\n\\n　　"..Prize_DataPos_3.."\\n"
                            .."\\n\\n　　————————————————————\\n"
                            .."$4[確定]2金幣刷新  [是]選取 [否]取消\\n";
      NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, 13, 2, msg);
    end
    return
  end)

  --全隊補血
  RugehealNPC1 = self:NPC_createNormal('資深喬伊', 231052, { x = 39, y = 34, mapType = 0, map = 7351, direction = 0 });
  Char.SetData(RugehealNPC1,CONST.对象_ENEMY_PetFlg+2,0);
  self:NPC_regTalkedEvent(RugehealNPC1, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "\\n\\n@c回復魔法值（+等量生命值）\\n\\n回復生命值\\n\\n回復寵物的生命值和魔法值\\n\\n$4免費$0回復全隊人物和寵物魔法、生命\\n";
      NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.按钮_确定关闭, 3, msg);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(RugehealNPC1, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select > 0 then
      if seqno == 3 and select == CONST.按钮_确定 then
        --gold = Char.GetData(player, CONST.对象_金币);
        gold = Char.ItemNum(player, 66668);
        memberGold = 0;
        totalGold = 0;
        FpGold = 0;
        LpGold = 0;
        --計算回復總金額
        if Char.PartyNum(player)>0 and player==Char.GetPartyMember(player,0) then
          for slot = 0,4 do
            local p = Char.GetPartyMember(player,slot)
            if(p>=0) then
                memberGold = memberGold + 1
                local lp = Char.GetData(p, CONST.对象_血)
                local maxLp = Char.GetData(p, CONST.对象_最大血)
                local fp = Char.GetData(p, CONST.对象_魔)
                local maxFp = Char.GetData(p, CONST.对象_最大魔)
                if fp <= maxFp then
                      FpGold = FpGold + maxFp - fp;
                end
                if lp <= maxLp then
                      LpGold = LpGold + maxLp - lp;
                end
            end
          end
        else
                memberGold = 0;
                local lp = Char.GetData(player, CONST.对象_血)
                local maxLp = Char.GetData(player, CONST.对象_最大血)
                local fp = Char.GetData(player, CONST.对象_魔)
                local maxFp = Char.GetData(player, CONST.对象_最大魔)
                if fp <= maxFp then
                      FpGold = FpGold + maxFp - fp;
                end
                if lp <= maxLp then
                      LpGold = LpGold + maxLp - lp;
                end
        end
        --print(FpGold,LpGold)
        if FpGold*0.5 >= LpGold then
          totalGold = FpGold;
        else
          totalGold = FpGold + LpGold - FpGold*0.5;
        end
        --local msg = "\\n\\n@c全隊回復需要花費"..totalGold.."個金幣\\n\\n現有金錢是"..gold.."個金幣\\n\\n\\n要回復嗎？\\n";
        local msg = "\\n\\n@c全隊回復需要花費0個金幣\\n\\n現有數量是"..gold.."個寶可金幣\\n\\n\\n要回復嗎？\\n";
        NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.按钮_是否, 31, msg);
      --人物寵物補血魔
      elseif seqno == 31 and select == CONST.按钮_是 then
        --if gold < totalGold then
        if (player>=0) then
                if Char.PartyNum(player)>0 and player==Char.GetPartyMember(player,0) then
                    for slot = 0,4 do
                       local p = Char.GetPartyMember(player,slot);
                       if(p>=0) then
                           local maxLp = Char.GetData(p, CONST.对象_最大血);
                           local maxFp = Char.GetData(p, CONST.对象_最大魔);
                           Char.SetData(p, CONST.对象_血, maxLp);
                           Char.SetData(p, CONST.对象_魔, maxFp);
                           Char.SetData(p, CONST.对象_受伤, 0);
                           Char.SetData(p, CONST.对象_掉魂, 0);
                           NLG.UpChar(p);
                           for petSlot  = 0,4 do
                              local petIndex = Char.GetPet(p,petSlot);
                              if petIndex >= 0 then
                                  local maxLp = Char.GetData(petIndex, CONST.对象_最大血);
                                  local maxFp = Char.GetData(petIndex, CONST.对象_最大魔);
                                  Char.SetData(petIndex, CONST.对象_血, maxLp);
                                  Char.SetData(petIndex, CONST.对象_魔, maxFp);
                                  Char.SetData(petIndex, CONST.对象_受伤, 0);
                                  Pet.UpPet(p, petIndex);
                              end
                           end
                       end
                    end
                    --Char.AddGold(player, -totalGold);
                    NLG.UpChar(player);
                else
                           local maxLp = Char.GetData(player, CONST.对象_最大血);
                           local maxFp = Char.GetData(player, CONST.对象_最大魔);
                           Char.SetData(player, CONST.对象_血, maxLp);
                           Char.SetData(player, CONST.对象_魔, maxFp);
                           NLG.UpChar(player);
                           for petSlot  = 0,4 do
                              local petIndex = Char.GetPet(player,petSlot);
                              if petIndex >= 0 then
                                  local maxLp = Char.GetData(petIndex, CONST.对象_最大血);
                                  local maxFp = Char.GetData(petIndex, CONST.对象_最大魔);
                                  Char.SetData(petIndex, CONST.对象_血, maxLp);
                                  Char.SetData(petIndex, CONST.对象_魔, maxFp);
                                  Pet.UpPet(player, petIndex);
                              end
                           end
                    --Char.AddGold(player, -totalGold);
                    NLG.UpChar(player);
                    --NLG.SystemMessage(player, '隊長才可使用！');
                end
        end

      end
    end
  end)

  RugehealNPC2 = self:NPC_createNormal('資深喬伊', 231052, { x = 84, y = 35, mapType = 0, map = 7351, direction = 0 });
  Char.SetData(RugehealNPC2,CONST.对象_ENEMY_PetFlg+2,0);
  self:NPC_regTalkedEvent(RugehealNPC2, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "\\n\\n@c回復魔法值（+等量生命值）\\n\\n回復生命值\\n\\n回復寵物的生命值和魔法值\\n\\n$4收費$0回復全隊人物和寵物魔法、生命\\n";
      NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.按钮_确定关闭, 3, msg);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(RugehealNPC2, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select > 0 then
      if seqno == 3 and select == CONST.按钮_确定 then
        --gold = Char.GetData(player, CONST.对象_金币);
        gold = Char.ItemNum(player, 66668);
        memberGold = 0;
        totalGold = 0;
        FpGold = 0;
        LpGold = 0;
        --計算回復總金額
        if Char.PartyNum(player)>0 and player==Char.GetPartyMember(player,0) then
          for slot = 0,4 do
            local p = Char.GetPartyMember(player,slot)
            if(p>=0) then
                memberGold = memberGold + 1
                local lp = Char.GetData(p, CONST.对象_血)
                local maxLp = Char.GetData(p, CONST.对象_最大血)
                local fp = Char.GetData(p, CONST.对象_魔)
                local maxFp = Char.GetData(p, CONST.对象_最大魔)
                if fp <= maxFp then
                      FpGold = FpGold + maxFp - fp;
                end
                if lp <= maxLp then
                      LpGold = LpGold + maxLp - lp;
                end
            end
          end
        else
                memberGold = 0;
                local lp = Char.GetData(player, CONST.对象_血)
                local maxLp = Char.GetData(player, CONST.对象_最大血)
                local fp = Char.GetData(player, CONST.对象_魔)
                local maxFp = Char.GetData(player, CONST.对象_最大魔)
                if fp <= maxFp then
                      FpGold = FpGold + maxFp - fp;
                end
                if lp <= maxLp then
                      LpGold = LpGold + maxLp - lp;
                end
        end
        --print(FpGold,LpGold)
        if FpGold*0.5 >= LpGold then
          totalGold = FpGold;
        else
          totalGold = FpGold + LpGold - FpGold*0.5;
        end
        --local msg = "\\n\\n@c全隊回復需要花費"..totalGold.."個金幣\\n\\n現有金錢是"..gold.."個金幣\\n\\n\\n要回復嗎？\\n";
        if Char.GetData(player, CONST.对象_等级)<=40 then
          msg = "\\n\\n@c全隊回復需要花費0個金幣\\n\\n現有數量是"..gold.."個寶可金幣\\n\\n\\n要回復嗎？\\n";
        else
          msg = "\\n\\n@c全隊回復需要花費"..memberGold.."個金幣\\n\\n現有數量是"..gold.."個寶可金幣\\n\\n\\n要回復嗎？\\n";
        end
        NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.按钮_是否, 31, msg);
      --人物寵物補血魔
      elseif seqno == 31 and select == CONST.按钮_是 then
        --if gold < totalGold then
        if (gold < memberGold) then
                if (Char.GetData(player, CONST.对象_等级)<=40) then
                  goto heal
                else
                  NLG.SystemMessage(player, '寶可金幣不足無法回復');
                  return
                end
        end
        ::heal::
        if (player>=0) then
                if Char.PartyNum(player)>0 and player==Char.GetPartyMember(player,0) then
                    for slot = 0,4 do
                       local p = Char.GetPartyMember(player,slot);
                       if(p>=0) then
                           local maxLp = Char.GetData(p, CONST.对象_最大血);
                           local maxFp = Char.GetData(p, CONST.对象_最大魔);
                           Char.SetData(p, CONST.对象_血, maxLp);
                           Char.SetData(p, CONST.对象_魔, maxFp);
                           Char.SetData(p, CONST.对象_受伤, 0);
                           Char.SetData(p, CONST.对象_掉魂, 0);
                           NLG.UpChar(p);
                           for petSlot  = 0,4 do
                              local petIndex = Char.GetPet(p,petSlot);
                              if petIndex >= 0 then
                                  local maxLp = Char.GetData(petIndex, CONST.对象_最大血);
                                  local maxFp = Char.GetData(petIndex, CONST.对象_最大魔);
                                  Char.SetData(petIndex, CONST.对象_血, maxLp);
                                  Char.SetData(petIndex, CONST.对象_魔, maxFp);
                                  Char.SetData(petIndex, CONST.对象_受伤, 0);
                                  Pet.UpPet(p, petIndex);
                              end
                           end
                       end
                    end
                    --Char.AddGold(player, -totalGold);
                    if (Char.GetData(player, CONST.对象_等级)>40) then
                      Char.DelItem(player, 66668, memberGold);
                    end
                    NLG.UpChar(player);
                else
                           local maxLp = Char.GetData(player, CONST.对象_最大血);
                           local maxFp = Char.GetData(player, CONST.对象_最大魔);
                           Char.SetData(player, CONST.对象_血, maxLp);
                           Char.SetData(player, CONST.对象_魔, maxFp);
                           NLG.UpChar(player);
                           for petSlot  = 0,4 do
                              local petIndex = Char.GetPet(player,petSlot);
                              if petIndex >= 0 then
                                  local maxLp = Char.GetData(petIndex, CONST.对象_最大血);
                                  local maxFp = Char.GetData(petIndex, CONST.对象_最大魔);
                                  Char.SetData(petIndex, CONST.对象_血, maxLp);
                                  Char.SetData(petIndex, CONST.对象_魔, maxFp);
                                  Pet.UpPet(player, petIndex);
                              end
                           end
                    --Char.AddGold(player, -totalGold);
                    if (Char.GetData(player, CONST.对象_等级)>40) then
                      Char.DelItem(player, 66668, memberGold);
                    end
                    NLG.UpChar(player);
                    --NLG.SystemMessage(player, '隊長才可使用！');
                end
        end

      end
    end
  end)


end
-------------------------------------------------------------------------------------------
--战斗开始事件(怪物光环)
function Module:OnbattleStartEventCallback(battleIndex)
	local leader1 = Battle.GetPlayer(battleIndex,0)
	local leader2 = Battle.GetPlayer(battleIndex,5)
	local leader = leader1
	if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
		leader = leader2
	end
	local rugeBossLevel = tonumber(Field.Get(leader, 'RugeBossLevel')) or 0;
	for i=10, 19 do
		local enemy = Battle.GetPlayIndex(battleIndex, i)
		local player = Battle.GetPlayIndex(battleIndex, i-10)
		 --print(enemy, player)
                                        --local randImage = NLG.Rand(1, #imageNumber);
		local enemyId = Char.GetData(enemy, CONST.对象_ENEMY_ID);
		if enemy>=0 and Char.IsEnemy(enemy) then
			if CheckInTable(MobsSet_L,enemyId)==true or CheckInTable(MobsSet_M,enemyId)==true or CheckInTable(MobsSet_H,enemyId)==true  then
				Char.SetTempData(enemy, '守住', rugeBossLevel);
				Char.SetTempData(enemy, '狂暴', rugeBossLevel);
				--Char.SetData(enemy, CONST.CHAR_形象, imageNumber[randImage]);
				--Char.SetData(enemy, CONST.对象_ENEMY_HeadGraNo,108510);
				NLG.UpChar(enemy);
				if Char.GetData(player,CONST.对象_对战开关) == 1  then
					NLG.Say(player,-1,"【守住領域】【狂暴領域】",4,3);
				end
			end
			if CheckInTable(BossSet_L,enemyId)==true or CheckInTable(BossSet_H,enemyId)==true  then
				Char.SetTempData(enemy, '守住', rugeBossLevel);
				Char.SetTempData(enemy, '狂暴', rugeBossLevel);
				NLG.UpChar(enemy);
				if Char.GetData(player,CONST.对象_对战开关) == 1  then
					NLG.Say(player,-1,"【守住領域】【狂暴領域】",4,3);
				end
			end
		end
	end
end
--战斗伤害事件(怪物光环)
function Module:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
      --self:logDebug('OnDamageCalculateCallBack', charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
      local Round = Battle.GetTurn(battleIndex);
      local leader1 = Battle.GetPlayer(battleIndex,0)
      local leader2 = Battle.GetPlayer(battleIndex,5)
      local leader = leader1
      if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
          leader = leader2
      end
      local rugeBossLevel = tonumber(Field.Get(leader, 'RugeBossLevel')) or 0;
      --print(Round)
      if Char.IsEnemy(defCharIndex) then
          local enemyId = Char.GetData(defCharIndex, CONST.对象_ENEMY_ID);
          if CheckInTable(MobsSet_L,enemyId)==true or CheckInTable(MobsSet_M,enemyId)==true or CheckInTable(MobsSet_H,enemyId)==true then
            local State = Char.GetTempData(defCharIndex, '守住') or 0;
            local defDamage = 1 - (State*0.001);
            damage = damage * defDamage;
            return damage;
          end
          if CheckInTable(BossSet_L,enemyId)==true or CheckInTable(BossSet_H,enemyId)==true then
            local State = Char.GetTempData(defCharIndex, '守住') or 0;
            local defDamage = 1 - (State*0.001);
            damage = damage * defDamage;
            return damage;
          end
      elseif Char.IsEnemy(charIndex) and flg ~= CONST.DamageFlags.Magic then
          local enemyId = Char.GetData(charIndex, CONST.对象_ENEMY_ID);
          if CheckInTable(MobsSet_L,enemyId)==true or CheckInTable(MobsSet_M,enemyId)==true or CheckInTable(MobsSet_H,enemyId)==true then
            local State = Char.GetTempData(charIndex, '狂暴') or 0;
            local attDamage = 1 + (State * 0.005);
            damage = damage * attDamage;
            return damage;
          end
          if CheckInTable(BossSet_L,enemyId)==true or CheckInTable(BossSet_H,enemyId)==true then
            local State = Char.GetTempData(charIndex, '狂暴') or 0;
            local attDamage = 1 + (State * 0.005);
            damage = damage * attDamage;
            return damage;
          end
      elseif Char.IsEnemy(charIndex) and flg == CONST.DamageFlags.Magic then
          local enemyId = Char.GetData(charIndex, CONST.对象_ENEMY_ID);
          if CheckInTable(MobsSet_L,enemyId)==true or CheckInTable(MobsSet_M,enemyId)==true or CheckInTable(MobsSet_H,enemyId)==true then
            local State = Char.GetTempData(charIndex, '狂暴') or 0;
            local attDamage = 1 + (State * 0.01);
            damage = damage * attDamage;
            return damage;
          end
          if CheckInTable(BossSet_L,enemyId)==true or CheckInTable(BossSet_H,enemyId)==true then
            local State = Char.GetTempData(charIndex, '狂暴') or 0;
            local attDamage = 1 + (State * 0.01);
            damage = damage * attDamage;
            return damage;
          end
       end
  return damage;
end

--回合前事件(奖励怪)
function Module:OnBeforeBattleTurnCommand(battleIndex)
    local Round = Battle.GetTurn(battleIndex);
    local leader1 = Battle.GetPlayer(battleIndex,0)
    local leader2 = Battle.GetPlayer(battleIndex,5)
    local leader = leader1
    if Char.GetData(leader2, CONST.对象_类型) == CONST.对象类型_人 then
        leader = leader2
    end

    if (leader>=0 and Char.IsPlayer(leader) and Char.GetData(leader, CONST.对象_地图)==7351) then
      local rugeBossLevel = tonumber(Field.Get(leader, 'RugeBossLevel')) or 0;
      if rugeBossLevel<60 then Bonus_Encount=BonusSet_L;
      elseif rugeBossLevel>=60 then Bonus_Encount=BonusSet_H;
      end

      local encountIndex,flg = Battle.GetNextBattle(battleIndex);
      --print(encountIndex,flg)
      if (encountIndex==-1 and flg==0) then
        local conBattle = Battle.GetExtData(battleIndex, '奖励连战') or 0;
        if (Round==1 and NLG.Rand(1,100)<=20) then
          Battle.SetExtData(battleIndex, '奖励连战', 1);
          local EncountRand = NLG.Rand(1,#Bonus_Encount);
          local encountIndex = Data.GetEncountIndex(Bonus_Encount[EncountRand]);
          Battle.SetNextBattle(battleIndex,encountIndex, Bonus_Encount[EncountRand]);
          --Battle.SetExtData(battleIndex, '奖励连战', 1);
        elseif (Round>=4 and conBattle==0 and NLG.Rand(1,100)>=95) then
          Battle.SetExtData(battleIndex, '奖励连战', 2);
          local encountIndex = Data.GetEncountIndex(720041);
          Battle.SetNextBattle(battleIndex,encountIndex, 720041);
        end
      else
      end
    else
    end
end
--登回城事件
function Module:onLoginEvent(charIndex)
	if Char.IsDummy(charIndex) then
		return
	end
	if (Char.GetData(charIndex, CONST.对象_名色)~=0 and Char.GetData(charIndex, CONST.对象_地图)==7351) then
		Char.Warp(charIndex,0,7351,16,33);
        NLG.SystemMessage(charIndex,"[系統]冠軍的難度提升，返場需付金幣。");
	end
end
--人物自动配点
function Module:onLevelUpEvent(charIndex)
	local name = Char.GetData(charIndex,CONST.对象_名字)
	if (Char.IsPlayer(charIndex) and Char.GetData(charIndex, CONST.对象_地图)==7351) then
		local levelUpPoint = Char.GetData(charIndex,CONST.对象_升级点);
		local times,rest = math.modf(levelUpPoint/4);
		local pointAttrs = {
			{CONST.对象_体力,"体力"},
			{CONST.对象_力量,"力量"},
			{CONST.对象_强度,"强度"},
			{CONST.对象_速度,"速度"},
			{CONST.对象_魔法,"魔法"},
		}

		if (times>=4) then
			times=4;
		end
		--print(levelUpPoint,times)
		for i=0,times do
			for k,v in pairs(pointAttrs) do
				if (Char.GetData(charIndex,CONST.对象_职类ID)==2010 or Char.GetData(charIndex,CONST.对象_职类ID)==2020 or Char.GetData(charIndex,CONST.对象_职类ID)==2030) then
					pointSetting={1,2,0,1,0};
				elseif (Char.GetData(charIndex,CONST.对象_职类ID)==2040) then
					pointSetting={1,0,0,1,2};
				end
				local data = (pointSetting[k] or 0 )*100

				local originData = Char.GetData(charIndex,pointAttrs[k][1]);
				Char.SetData(charIndex,pointAttrs[k][1], data+originData);
				NLG.UpChar(charIndex);
			end
			local restPoint = Char.GetData(charIndex,CONST.对象_升级点);
			Char.SetData(charIndex,CONST.对象_升级点, restPoint-4);
			NLG.UpChar(charIndex);
		end
	end
end
--战斗宠物行为检测事件
function Module:onBattlePetLeaveCheckEvent(battleIndex, charIndex, type, com1, com2, com3)
	--type number (0:正常, 1:收宠, 2:位置, 3: 发呆, 4: 防御, 5: 攻击， 6: ?, 7: 逃跑)
	--self:logDebug('OnBattlePetLeaveCheckEventCallBack', battleIndex, charIndex, type, com1, com2, com3)
	if (type==7) then
		local type=4;
		NLG.SystemMessage(charIndex,"[系統]寵物差點逃跑了，引誘其進入防禦狀態。");
		return type
	end
	return type
end
--战斗结束胜利事件
function RugeNPC_BattleWin(battleIndex, charIndex)
	--计算等第
	local leader1 = Battle.GetPlayer(battleIndex,0)
	local leader2 = Battle.GetPlayer(battleIndex,5)
	local leader = leader1
	if Char.GetData(leader2, CONST.对象_类型) == CONST.对象类型_人 then
		leader = leader2
	end
	local rugeBossLevel = tonumber(Field.Get(leader, 'RugeBossLevel')) or 0;
	local m = rugeBossLevel+1;

	local lv = math.floor(m);
	local lvRank = math.floor(lv/10);
	local lvdrop = math.fmod(lv,10);

	if (Char.GetData(charIndex, CONST.对象_地图)==7351) then
	for p=0,9 do
		local player = Battle.GetPlayIndex(battleIndex, p);
		local drop = math.random(1,5);
		if player>=0 and Char.IsPlayer(player)==true and not Char.IsDummy(player) then
			Char.GiveItem(player, 66668, drop);
		end
	end

	local conBattle = Battle.GetExtData(battleIndex, '奖励连战') or 0;
	if (conBattle==2) then
		for p=0,9 do
			local player = Battle.GetPlayIndex(battleIndex, p);
			if player>=0 and Char.IsPlayer(player)==true and not Char.IsDummy(player) then
			Char.GiveItem(player, 66668, 100);
			end	
		end
		Battle.SetExtData(battleIndex, '奖励连战', 0);
	end
--[[
	--依等第分配奖励
	for p=0,9 do
		local player = Battle.GetPlayIndex(battleIndex, p);
		local drop = math.random(0,2);
		if player>=0 and Char.GetData(player, CONST.CHAR_类型) == CONST.对象类型_人 then
			--print(lv,lvRank,drop)
			for k, v in ipairs(dropMenu) do
				if k==lvRank and lvdrop==0  then
					Char.GiveItem(player, dropMenu[k][2], dropMenu[k][3]*drop);
				end
			end
			--if (rugeBossLevel>=99) then
			--	local dropPet = math.random(1,5);
			--	local PetIDMenu = {900007,900008,900009}
			--	if (dropPet<=3) then
			--		Char.AddPet(player,PetIDMenu[dropPet]);
			--	end
			--end
		end
	end
]]
	if (rugeBossLevel>=99) then
		for k,v in ipairs(achieveList) do
			if (Char.GetData(leader, CONST.对象_名色)==v.nameColor) then
				Char.SetData(leader, CONST.对象_名色, v.newColor);
				Char.SetData(leader, CONST.对象_登陆点, 1);
				Char.EndEvent(leader, v.endEvent, 1);
				NLG.UpChar(leader);
				Char.CheckTitle(leader);
				goto continue
			end
		end
		::continue::
		Field.Set(leader, 'RugeBossLevel', 0);
		Field.Set(leader, 'RugeEnemyIdAr', "0");
		local rugePrizeString,rugePrizeId = PrizeTmpTable(leader, -1, 0);
		Field.Set(leader, 'RugePrizeLevel', rugePrizeString);
		local meowHat = {607720,607721,607722,607723}
		Char.GiveItem(leader,meowHat[NLG.Rand(1,4)]);
		Char.Warp(charIndex,0,7351,6,28);
	else
		Field.Set(leader, 'RugeBossLevel', rugeBossLevel+1);
		Field.Set(leader, 'RugeEnemyIdAr', "0");
		Char.Warp(charIndex,0,7351,67,22);
	end
	end
	Battle.UnsetWinEvent(battleIndex);
end

-------------------------------------------------------------------------------------------
----功能函数
--对战组合
function SetEnemySet(player, type)
	local rugeEnemySet={}
	local rugeBossLevel = tonumber(Field.Get(player, 'RugeBossLevel')) or 0;

	local rugeEnemyIdAr = Field.Get(player, 'RugeEnemyIdAr');
	if (#rugeEnemyIdAr>2) then
		local rugeEnemyIdAr_raw = string.split(rugeEnemyIdAr,",")
		for k,v in ipairs(rugeEnemyIdAr_raw) do
			table.insert(rugeEnemySet,tonumber(v));
		end
		iniEnemyIdAr = 1
	else
		rugeEnemySet = {710001, 0, 0, 0, 0, 0, 710002, 710003, 0, 0};
		iniEnemyIdAr = 0
	end
	--print(iniEnemyIdAr)

	if (iniEnemyIdAr==0 and type==0) or (iniEnemyIdAr==1 and type==1)then
		local EnemySet = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
		local ix=1;
		if rugeBossLevel<10 then    -- 入门
			EnemySet[1]=MobsSet_L[NLG.Rand(1,#MobsSet_L)];
		elseif rugeBossLevel>=10 and rugeBossLevel<30 then    -- 初级
			EnemySet[1]=MobsSet_L[NLG.Rand(1,#MobsSet_L)];
			EnemySet[7]=MobsSet_L[NLG.Rand(1,#MobsSet_L)];
			EnemySet[8]=MobsSet_L[NLG.Rand(1,#MobsSet_L)];
		elseif rugeBossLevel>=30 and rugeBossLevel<50 then    -- 中级
			EnemySet[2]=MobsSet_M[NLG.Rand(1,#MobsSet_M)];
			EnemySet[3]=MobsSet_M[NLG.Rand(1,#MobsSet_M)];
			EnemySet[6]=MobsSet_M[NLG.Rand(1,#MobsSet_M)];
			EnemySet[9]=MobsSet_M[NLG.Rand(1,#MobsSet_M)];
			EnemySet[10]=MobsSet_M[NLG.Rand(1,#MobsSet_M)];
		elseif rugeBossLevel>=50 and rugeBossLevel<70 then    -- 高级
			for k=6,10 do
				EnemySet[k]=MobsSet_L[NLG.Rand(1,#MobsSet_L)];
				ix=ix+1;
			end
			EnemySet[2]=MobsSet_H[NLG.Rand(1,#MobsSet_H)];
			EnemySet[3]=MobsSet_H[NLG.Rand(1,#MobsSet_H)];
		elseif rugeBossLevel>=70 and rugeBossLevel<90 then    -- 超级
			for k=6,10 do
				EnemySet[k]=MobsSet_M[NLG.Rand(1,#MobsSet_M)];
				ix=ix+1;
			end
			EnemySet[2]=MobsSet_H[NLG.Rand(1,#MobsSet_H)];
			EnemySet[3]=MobsSet_H[NLG.Rand(1,#MobsSet_H)];
		elseif rugeBossLevel>=90 then    -- 绝级
			for k=7,10 do
				EnemySet[k]=MobsSet_H[NLG.Rand(1,#MobsSet_H)];
				ix=ix+1;
			end
			EnemySet[2]=BossSet_L[NLG.Rand(1,#BossSet_L)];
			EnemySet[3]=BossSet_L[NLG.Rand(1,#BossSet_L)];
			EnemySet[6]=BossSet_L[NLG.Rand(1,#BossSet_L)];
		end
		--每5级1号位放入BOSS
		if (math.fmod(rugeBossLevel, 10)==4 or math.fmod(rugeBossLevel, 10)==9) then
			if (rugeBossLevel>=10 and rugeBossLevel<20) then
				local rand = NLG.Rand(1,#BossSet_L);
				EnemySet[5]=BossSet_L[rand];
			elseif (rugeBossLevel>=20 and rugeBossLevel<75) then
				local rand = NLG.Rand(1,#BossSet_L);
				EnemySet[1]=BossSet_L[rand];
			elseif (rugeBossLevel>=75 and rugeBossLevel<=98) then
				local rand = NLG.Rand(1,#BossSet_H);
				EnemySet[1]=BossSet_H[rand];
			elseif (rugeBossLevel==99) then
				for k,v in ipairs(achieveList) do
					if (Char.GetData(player, CONST.对象_名色)==v.nameColor) then
						EnemySet=v.finalEnemySet;
					end
				end
			end
		end
		local rugeEnemyTemp = ""
		for k,v in ipairs(EnemySet) do
			if (k==#EnemySet) then
				rugeEnemyTemp = rugeEnemyTemp .. v;
			else
				rugeEnemyTemp = rugeEnemyTemp .. v .. ",";
			end
		end
		--print(rugeEnemyTemp)
		Field.Set(player, 'RugeEnemyIdAr', rugeEnemyTemp);
		--NLG.UpChar(player);
		return EnemySet
	else
		return rugeEnemySet
	end
	return rugeEnemySet
end

--奖励抽取与刷新
function PrizeTmpTable(player, type, line)
	local rugeBossLevel = tonumber(Field.Get(player, 'RugeBossLevel')) or 0;
	if rugeBossLevel<35 then level=1;
	elseif rugeBossLevel>=35 and rugeBossLevel<75 then level=2;
	elseif rugeBossLevel>=75 then level=3;
	end

	local rugePrizeString = Field.Get(player, 'RugePrizeLevel');
	local rugePrizeLevel_raw = string.split(rugePrizeString,",")
	local rugePrizeLevel_level = tonumber(rugePrizeLevel_raw[1]) or 0;
	local rugePrizeLevel_roll_1 = tonumber(rugePrizeLevel_raw[2]) or 0;
	local rugePrizeLevel_roll_2 = tonumber(rugePrizeLevel_raw[3]) or 0;
	local rugePrizeLevel_roll_3 = tonumber(rugePrizeLevel_raw[4]) or 0;

	if line==1 then rugePrizeId = rugePrizeLevel_roll_1;
	elseif line==2 then rugePrizeId = rugePrizeLevel_roll_2;
	elseif line==3 then rugePrizeId = rugePrizeLevel_roll_3;
	end

	if type==-1 then
		local rugePrizeString = "0," ..rugePrizeLevel_roll_1.. "," ..rugePrizeLevel_roll_2.. "," ..rugePrizeLevel_roll_3;
		return rugePrizeString,-1		--奖励道具编号
	elseif type==0 and rugeBossLevel>rugePrizeLevel_level then
		--装备池洗牌
		local prizeTbl = {}
		for k,v in ipairs(prizeMenu[level][1]) do
			table.insert(prizeTbl,v);
		end
		rugePrizeLevel_roll_1 = prizeTbl[NLG.Rand(1,#prizeTbl)];
		--伙伴池洗牌
		local prizeTbl = {}
		for k,v in ipairs(prizeMenu[level][2]) do
			table.insert(prizeTbl,v);
		end
		rugePrizeLevel_roll_2 = prizeTbl[NLG.Rand(1,#prizeTbl)];
		--技能池洗牌
		local prizeTbl = {}
		for k,v in ipairs(prizeMenu[level][3]) do
			table.insert(prizeTbl,v);
		end
		rugePrizeLevel_roll_3 = prizeTbl[NLG.Rand(1,#prizeTbl)];

		local rugePrizeString = rugeBossLevel .. "," ..rugePrizeLevel_roll_1.. "," ..rugePrizeLevel_roll_2.. "," ..rugePrizeLevel_roll_3;
		if line==1 then rugePrizeId = rugePrizeLevel_roll_1;
		elseif line==2 then rugePrizeId = rugePrizeLevel_roll_2;
		elseif line==3 then rugePrizeId = rugePrizeLevel_roll_3;
		end
		return rugePrizeString,rugePrizeId		--奖励道具编号
	elseif type==1 then
		local prizeTbl = {}
		if line==1 then
			repeat
				for k,v in ipairs(prizeMenu[level][1]) do
					table.insert(prizeTbl,v);
				end
			until rugePrizeLevel_roll_1 ~= prizeTbl[NLG.Rand(1,#prizeTbl)]
			rugePrizeLevel_roll_1 = prizeTbl[NLG.Rand(1,#prizeTbl)];
			rugePrizeId = rugePrizeLevel_roll_1
		elseif line==2 then
			repeat
				for k,v in ipairs(prizeMenu[level][2]) do
					table.insert(prizeTbl,v);
				end
			until rugePrizeLevel_roll_2 ~= prizeTbl[NLG.Rand(1,#prizeTbl)]
			rugePrizeLevel_roll_2 = prizeTbl[NLG.Rand(1,#prizeTbl)];
			rugePrizeId = rugePrizeLevel_roll_2
		elseif line==3 then
			repeat
				for k,v in ipairs(prizeMenu[level][3]) do
					table.insert(prizeTbl,v);
				end
			until rugePrizeLevel_roll_3 ~= prizeTbl[NLG.Rand(1,#prizeTbl)]
			rugePrizeLevel_roll_3 = prizeTbl[NLG.Rand(1,#prizeTbl)];
			rugePrizeId = rugePrizeLevel_roll_3
		end
		local rugePrizeString = rugeBossLevel .. "," ..rugePrizeLevel_roll_1.. "," ..rugePrizeLevel_roll_2.. "," ..rugePrizeLevel_roll_3;
		return rugePrizeString,rugePrizeId		--奖励道具编号
	end
	return rugePrizeString,rugePrizeId
end

function CheckInTable(_idTab, _idVar) ---循环函数
	for k,v in pairs(_idTab) do
		if v==_idVar then
			return true
		end
	end
	return false
end

function mykgold(player,gold)
	local tjb = Char.GetData(player,CONST.对象_金币);
	tjb = tjb - gold; 
	if (tjb >= 0) then
		Char.SetData(player,CONST.对象_金币,tjb);
		NLG.UpChar(player);
		NLG.SystemMessage(player,"交出了"..gold.." G魔幣。");
		return true;
	end
	return false;
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
