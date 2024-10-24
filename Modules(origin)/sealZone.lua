---模块类
local Module = ModuleBase:createModule('sealZone')

local EnemySet = {}
local BaseLevelSet = {}
--local EnemySet_WC = {700019,700019,700020,700020}
--local EnemySet_WG = {606025,606026,606027,700043,700044}
--local EnemySet_WR = {700054,700056,700060,700061}
--local EnemySet_WV = {700051,700052,700057,700058,700062,700063}
--local EnemyArea = {EnemySet_WC,EnemySet_WG,EnemySet_WR,EnemySet_WV}

local gradeLevel = 135;	--校正总档次标准
local BabyEnemy = {
      --{ popEnemy=1000, baitItem=14848, foodItem=18195, popArea={map=100,LX=0,LY=0, RX=839,RY=609} },		--迷你蝙蝠
      --{ popEnemy=1003, baitItem=14942, foodItem=18195, popArea={map=100,LX=451,LY=150, RX=498,RY=250} },		--哥布林
      { popEnemy=500000, baitItem=69005, foodItem=69017, popArea={map=20300,LX=296,LY=512, RX=307,RY=531} },	--凱西
      { popEnemy=500001, baitItem=69006, foodItem=69018, popArea={map=20300,LX=296,LY=512, RX=307,RY=531} },	--化石翼龍
      { popEnemy=500002, baitItem=69005, foodItem=69023, popArea={map=20300,LX=304,LY=493, RX=330,RY=502} },	--波士可多拉
      { popEnemy=500003, baitItem=69006, foodItem=69016, popArea={map=20300,LX=304,LY=493, RX=330,RY=502} },	--雙尾怪手
      { popEnemy=500004, baitItem=69005, foodItem=69017, popArea={map=20300,LX=350,LY=485, RX=392,RY=519} },	--超級電龍
      { popEnemy=500005, baitItem=69006, foodItem=69018, popArea={map=20300,LX=350,LY=485, RX=392,RY=519} },	--風速狗
      { popEnemy=500006, baitItem=69005, foodItem=69023, popArea={map=20300,LX=288,LY=429, RX=329,RY=478} },	--太古盔甲
      { popEnemy=500007, baitItem=69006, foodItem=69016, popArea={map=20300,LX=288,LY=429, RX=329,RY=478} },	--月桂葉
      { popEnemy=500008, baitItem=69005, foodItem=69017, popArea={map=20300,LX=265,LY=485, RX=289,RY=508} },	--狩獵鳳蝶
      { popEnemy=500010, baitItem=69006, foodItem=69018, popArea={map=20300,LX=265,LY=485, RX=289,RY=508} },	--幸福蛋
      { popEnemy=500011, baitItem=69007, foodItem=69028, popArea={map=20300,LX=226,LY=365, RX=249,RY=418} },	--呆火駝
      { popEnemy=500012, baitItem=69008, foodItem=69023, popArea={map=20300,LX=226,LY=365, RX=249,RY=418} },	--雪拉比
      { popEnemy=500014, baitItem=69007, foodItem=69023, popArea={map=20300,LX=163,LY=379, RX=221,RY=428} },	--刺甲貝
      { popEnemy=500015, baitItem=69008, foodItem=69016, popArea={map=20300,LX=163,LY=379, RX=221,RY=428} },	--卡拉卡拉
      { popEnemy=500016, baitItem=69005, foodItem=69017, popArea={map=20300,LX=333,LY=341, RX=348,RY=463} },	--頓甲
      { popEnemy=500017, baitItem=69006, foodItem=69016, popArea={map=20300,LX=333,LY=341, RX=348,RY=463} },	--快龍
      { popEnemy=500018, baitItem=69007, foodItem=69028, popArea={map=20300,LX=103,LY=439, RX=144,RY=504} },	--三地鼠
      { popEnemy=500020, baitItem=69008, foodItem=69018, popArea={map=20300,LX=103,LY=439, RX=144,RY=504} },	--帝王拿波
      { popEnemy=500021, baitItem=69005, foodItem=69023, popArea={map=20300,LX=390,LY=405, RX=413,RY=459} },	--沙漠蜻蜓
      { popEnemy=500022, baitItem=69006, foodItem=69018, popArea={map=20300,LX=390,LY=405, RX=413,RY=459} },	--烈咬陸鯊
      { popEnemy=500023, baitItem=69009, foodItem=69016, popArea={map=20300,LX=426,LY=395, RX=452,RY=421} },	--蓋諾賽克特
      { popEnemy=500024, baitItem=69010, foodItem=69018, popArea={map=20300,LX=426,LY=395, RX=452,RY=421} },	--耿鬼
      { popEnemy=500025, baitItem=69009, foodItem=69023, popArea={map=20300,LX=513,LY=358, RX=541,RY=399} },	--冰鬼護
      { popEnemy=500026, baitItem=69010, foodItem=69028, popArea={map=20300,LX=513,LY=358, RX=541,RY=399} },	--甲賀忍蛙
      { popEnemy=500029, baitItem=69009, foodItem=69017, popArea={map=20300,LX=449,LY=326, RX=493,RY=344} },	--胡帕
      { popEnemy=500031, baitItem=69010, foodItem=69028, popArea={map=20300,LX=449,LY=326, RX=493,RY=344} },	--基拉祈
      { popEnemy=500033, baitItem=69006, foodItem=69016, popArea={map=20300,LX=298,LY=252, RX=356,RY=299} },	--拉普拉斯
      { popEnemy=500036, baitItem=69005, foodItem=69023, popArea={map=20300,LX=298,LY=252, RX=356,RY=299} },	--怪力
      { popEnemy=500037, baitItem=69009, foodItem=69016, popArea={map=20300,LX=70,LY=126, RX=80,RY=149} },		--瑪機雅娜
      { popEnemy=500040, baitItem=69010, foodItem=69028, popArea={map=20300,LX=70,LY=126, RX=80,RY=149} },		--超級巨金怪
      { popEnemy=500042, baitItem=69008, foodItem=69016, popArea={map=20300,LX=103,LY=41, RX=192,RY=74} },		--尼多王
      { popEnemy=500043, baitItem=69007, foodItem=69028, popArea={map=20300,LX=103,LY=41, RX=192,RY=74} },		--尼多后
      { popEnemy=500044, baitItem=69006, foodItem=69016, popArea={map=20300,LX=266,LY=99, RX=287,RY=122} },	--蚊香君
      { popEnemy=500046, baitItem=69007, foodItem=69028, popArea={map=20300,LX=266,LY=99, RX=287,RY=122} },	--呆呆王
      { popEnemy=500048, baitItem=69007, foodItem=69023, popArea={map=20300,LX=451,LY=148, RX=479,RY=172} },	--卡璞鰭鰭
      { popEnemy=500049, baitItem=69006, foodItem=69018, popArea={map=20300,LX=451,LY=148, RX=479,RY=172} },	--卡璞鳴鳴
      { popEnemy=500052, baitItem=69008, foodItem=69018, popArea={map=20300,LX=402,LY=19, RX=429,RY=29} },		--波爾凱尼恩
      { popEnemy=500053, baitItem=69009, foodItem=69023, popArea={map=20300,LX=402,LY=19, RX=429,RY=29} },		--雙彈瓦斯
}

local petMettleTable = {
          {9610,9619,9620,9629},       --对BOSS增,自BOSS减,对人形增,对邪魔增
          {9611,9615,9623,9624},       --对地增,自地减,对飞行增,对昆虫增
          {9612,9616,9627,9628},       --对水增,自水减,对特殊增,对金属增
          {9613,9617,9621,9626},       --对火增,自火减,对龙族增,对野兽增
          {9614,9618,9622,9625},       --对风增,自风减,对不死增,对植物增
}
-----------------------------------------------------------------------------------------------
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  --self:regCallback('ItemUseEvent', Func.bind(self.onItemUseEvent, self));
  self:regCallback('SealEvent', Func.bind(self.OnSealEventCallBack, self));
  self:regCallback('BattleOverEvent', Func.bind(self.battleOverEventCallback, self));
  self:regCallback('LoginEvent', Func.bind(self.battleOverEventCallback, self));
  self:regCallback('LogoutEvent', Func.bind(self.battleOverEventCallback, self));
  self:regCallback('EnemyCommandEvent', Func.bind(self.OnEnemyCommandCallBack, self));
  --设置陷阱
  self:regCallback('GatherItemEvent', function(charIndex, skillId, skillLv, itemNo)
    if (skillId==229) then
        local Target_FloorId = Char.GetData(charIndex,CONST.CHAR_地图);
        local Target_X = Char.GetData(charIndex,CONST.CHAR_X);
        local Target_Y = Char.GetData(charIndex,CONST.CHAR_Y);
        local burst = NLG.Rand(1,40);
        for k, v in ipairs(BabyEnemy) do
            local baitSlot = Char.FindItemId(charIndex,v.baitItem);
            if baitSlot>0 then
                local ItemIndex = Char.GetItemIndex(charIndex, baitSlot);
                local baitNum = tonumber(Item.GetData(ItemIndex,CONST.道具_堆叠数));
                if (baitNum>=1 and Target_FloorId==v.popArea.map and Target_X>=v.popArea.LX and Target_Y>=v.popArea.LY and Target_X<=v.popArea.RX and Target_Y<=v.popArea.RY) then
                    EnemySet[1]=v.popEnemy;
                    BaseLevelSet[1]=2;
                    if (baitNum>=burst) then
                        Char.DelItemBySlot(charIndex, baitSlot);
                        NLG.SystemMessage(charIndex,"[系統]遭遇吸引來的怪物...");
                        Battle.PVE( charIndex, charIndex, nil, EnemySet, BaseLevelSet, nil);
                        goto continue
                    else
                        if Char.GetData(charIndex,CONST.对象_队聊开关) == 1  then
                            NLG.SystemMessage(charIndex,"[系統]薰香設置中...");
                        end
                    end
                end
            end
        end
        ::continue::
--[[
            local enemyNum= NLG.Rand(1,3);
            for enemyslot=1,enemyNum do
                local EncountRate = {1,1,1,1,1,1,1,1,2,2,2,2,3,3,4}
                local xr = EncountRate[NLG.Rand(1,15)];
                local xxr= NLG.Rand(1,#EnemyArea[xr]);
                local Enemy = EnemyArea[xr][xxr];
                EnemySet[enemyslot]=Enemy;
                BaseLevelSet[enemyslot]=100;
            end
]]
    end
  end)

end

-----------------------------------------------------------------------------------------------
---以下为各function功能
--封印卡道具使用限制
function Module:onItemUseEvent(charIndex, targetCharIndex, itemSlot)
  local itemIndex = Char.GetItemIndex(charIndex,itemSlot);
  local battleIndex = Char.GetBattleIndex(charIndex);
  local ItemID = Item.GetData(itemIndex, CONST.道具_ID);
  local Target_FloorId = Char.GetData(charIndex,CONST.CHAR_地图)
  if (Item.GetData(itemIndex, CONST.道具_类型)==40) then
      if (battleIndex==-1 and Battle.IsWaitingCommand(charIndex)<=0) then
               NLG.SystemMessage(charIndex,"[道具提示]戰鬥中才能使用的道具");
               return -1;
      elseif (Target_FloorId==20233 and ItemID~=75014) then
               NLG.SystemMessage(charIndex,"[道具提示]請用狩獵球捕捉！");
               return -1;
      else
               return 0;
      end
  end
end

--封印结果
function Module:OnSealEventCallBack(charIndex, enemyIndex, ret)
  --self:logDebug('OnSealEventCallBack', charIndex, enemyIndex, ret)
         local battleIndex = Char.GetBattleIndex(charIndex);
         local capture = Char.GetSkillLv(charIndex, Char.HaveSkill(charIndex,69) ) or 0;
         local Target_FloorId = Char.GetData(charIndex,CONST.CHAR_地图);
         local EmptySlot = Char.GetPetEmptySlot(charIndex);
         local SealSlot = Char.GetTempData(charIndex, 'SealOn') or -1;
         if (Char.PetNum(charIndex)==5) then
             NLG.SystemMessage(charIndex,"[系統]寵物欄已滿無法抓取");
             return ret;
         end
         --if (SealSlot>=0) then
             --NLG.SystemMessage(charIndex,"[系統]一場戰鬥只能封印一隻怪物");
             --ret=-1;
             --return ret;
         --end
         local defHpE = Char.GetData(enemyIndex,CONST.CHAR_血);
         local defHpEM = Char.GetData(enemyIndex,CONST.CHAR_最大血);
         local HpE05 = defHpE/defHpEM;
         local getit= NLG.Rand(1, math.ceil(HpE05*3) );
         local LvE = math.ceil(Char.GetData(enemyIndex,CONST.CHAR_等级)*0.8);
         local LvMR = NLG.Rand(1,250);
         local a61 = Char.GetEnemyAllRank(enemyIndex);
         if (Char.IsEnemy(enemyIndex) and Battle.GetType(battleIndex)==CONST.战斗_普通 and Char.GetData(enemyIndex, CONST.CHAR_EnemyBossFlg)==0) then
             local RandCap = capture*25;
             local CAPTURE = NLG.Rand(0,255);
             if (a61<=140 and CAPTURE<=RandCap and getit==1 and LvMR>=LvE) then
                 ret=1;
             elseif (a61>140) then
                 NLG.SystemMessage(charIndex,"[系統]怪物無法封印");
                 ret=-1;
                 return ret;
             end
             if (ret==1) then
                 if (a61 <= gradeLevel) then
                     local resmax = gradeLevel-a61;
                     local resmin = gradeLevel-a61-5;
                     local type = NLG.Rand(1,2);
                     local BPdistribute = { {5,resmax,0,5}, {0,0,5,resmax} };
                     repeat
                          res1 = NLG.Rand(0, math.ceil(resmin/2) );
                          res2 = NLG.Rand(BPdistribute[type][1], BPdistribute[type][2] );
                          res3 = NLG.Rand(0, math.ceil(resmin/4) );
                          res4 = NLG.Rand(0, math.ceil(resmin/2) );
                          res5 = NLG.Rand(BPdistribute[type][3], BPdistribute[type][4] );
                          max2 = res1+res2+res3+res4+res5;
                          if (max2 > resmax or max2 < resmin) then
                              --print('不符合，重试。')
                          end
                     until (max2 < resmax) and (max2 > resmin)
                 end
                 local arr_rank1 = Pet.GetArtRank(enemyIndex,CONST.宠档_体成);
                 local arr_rank2 = Pet.GetArtRank(enemyIndex,CONST.宠档_力成);
                 local arr_rank3 = Pet.GetArtRank(enemyIndex,CONST.宠档_强成);
                 local arr_rank4 = Pet.GetArtRank(enemyIndex,CONST.宠档_敏成);
                 local arr_rank5 = Pet.GetArtRank(enemyIndex,CONST.宠档_魔成);
                 local BYTL1 = Pet.SetArtRank(enemyIndex,CONST.宠档_体成, arr_rank1 + res1);
                 local BYTL2 = Pet.SetArtRank(enemyIndex,CONST.宠档_力成, arr_rank2 + res2);
                 local BYTL3 = Pet.SetArtRank(enemyIndex,CONST.宠档_强成, arr_rank3 + res3);
                 local BYTL4 = Pet.SetArtRank(enemyIndex,CONST.宠档_敏成, arr_rank4 + res4);
                 local BYTL5 = Pet.SetArtRank(enemyIndex,CONST.宠档_魔成, arr_rank5 + res5);
                 NLG.UpChar(enemyIndex);
                 Char.SetTempData(charIndex, 'SealOn', 1);
                 Char.SetTempData(charIndex, 'SealOn_'..tostring(EmptySlot)..'', EmptySlot);
             end
         end
  return ret;
end

--结束、注销初始化
function Module:battleOverEventCallback(battleIndex)
  for i = 0, 9 do
        local charIndex = Battle.GetPlayer(battleIndex, i);
        if charIndex >= 0 then
            local SealSlot = Char.GetTempData(charIndex, 'SealOn') or -1;
            if SealSlot>=0 then
              for EmptySlot=0,4 do
                  local PetSlot = Char.GetTempData(charIndex, 'SealOn_'..tostring(EmptySlot)..'') or -1;
                  if (PetSlot>=0) then
                      local PetIndex = Char.GetPet(charIndex, PetSlot);
                      local typeRand = math.random(1,#petMettleTable);
                      local pos = math.random(1,#petMettleTable[typeRand]);
                      Pet.AddSkill(PetIndex, petMettleTable[typeRand][pos], 9);
                      Char.SetData(PetIndex,CONST.对象_原名, Char.GetData(PetIndex,CONST.对象_原名).."異種");
                      Pet.UpPet(charIndex,PetIndex);
                      NLG.UpChar(charIndex);
                  end
              end
              Char.SetTempData(charIndex, 'SealOn', -1);
              for i=0,4 do
                  Char.SetTempData(charIndex, 'SealOn_'..tostring(i)..'', -1);
              end
            end
        end
  end
end

--诱饵时避免自爆
function Module:OnEnemyCommandCallBack(battleIndex, side, slot, action)
      local leader1 = Battle.GetPlayer(battleIndex,0)
      local leader2 = Battle.GetPlayer(battleIndex,5)
      local leader = leader1
      if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
            leader = leader2
      end
      local Round = Battle.GetTurn(battleIndex);
      for i = 10, 19 do
         local enemy = Battle.GetPlayer(battleIndex, i);
         if enemy>= 0 then
             for k, v in ipairs(BabyEnemy) do
                if (Char.GetData(enemy, CONST.CHAR_等级)<=3 and Char.GetData(enemy, CONST.对象_ENEMY_ID)==v.popEnemy) then
                    if (Char.ItemNum(leader, v.foodItem)>=1) then
                          Char.DelItem(leader, v.foodItem, 1);
                          NLG.SystemMessage(leader,"[系統]"..Char.GetData(enemy,CONST.对象_原名).."津津有味地品嘗食物。");
                          SetCom(enemy, action, CONST.BATTLE_COM.BATTLE_COM_NONE, -1, 15002);
                    end
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

Char.GetPetEmptySlot = function(charIndex)
  for Slot=0,4 do
      local PetIndex = Char.GetPet(charIndex, Slot);
      --print(PetIndex);
      if (PetIndex < 0) then
          return Slot;
      end
  end
  return -1;
end

Char.GetEnemyAllRank = function(enemyIndex)
  local enemyIndex = enemyIndex;
  if enemyIndex >= 0 then
    local a11 = Pet.FullArtRank(enemyIndex, CONST.PET_体成);
    local a21 = Pet.FullArtRank(enemyIndex, CONST.PET_力成);
    local a31 = Pet.FullArtRank(enemyIndex, CONST.PET_强成);
    local a41 = Pet.FullArtRank(enemyIndex, CONST.PET_敏成);
    local a51 = Pet.FullArtRank(enemyIndex, CONST.PET_魔成);
    local a61 = a11 + a21+ a31+ a41+ a51;
    return a61, a11, a21, a31, a41, a51;
  end
  return -1;
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
