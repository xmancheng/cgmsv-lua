local PetHatching = ModuleBase:createModule('petHatching')

local petNpcIndex = {}
--[[for list = 0,50 do
	petNpcIndex[list] = {}
                    petNpcIndex[list][1] = -1
                    petNpcIndex[list][2] = -1
end]]

local petMettleTable = {
          {9610,9619,9620,9629},       --對BOSS增,自BOSS減,對人形增,對邪魔增
          {9611,9615,9623,9624},       --對地增,自地減,對飛行增,對昆蟲增
          {9612,9616,9627,9628},       --對水增,自水減,對特殊增,對金屬增
          {9613,9617,9621,9626},       --對火增,自火減,對龍族增,對野獸增
          {9614,9618,9622,9625},       --對風增,自風減,對不死增,對植物增
}

-- NOTE 宠物的所有属性key
local petFields={
CONST.CHAR_类型,
CONST.CHAR_形象,
CONST.CHAR_原形,
CONST.CHAR_MAP,
CONST.CHAR_地图,
CONST.CHAR_X,
CONST.CHAR_Y,
CONST.CHAR_方向,
CONST.CHAR_等级,
CONST.CHAR_血,
CONST.CHAR_魔,
CONST.CHAR_体力,
CONST.CHAR_力量,
CONST.CHAR_强度,
CONST.CHAR_速度,
CONST.CHAR_魔法,
CONST.CHAR_运气,
CONST.CHAR_种族,
CONST.CHAR_地属性,
CONST.CHAR_水属性,
CONST.CHAR_火属性,
CONST.CHAR_风属性,
CONST.CHAR_抗毒,
CONST.CHAR_抗睡,
CONST.CHAR_抗石,
CONST.CHAR_抗醉,
CONST.CHAR_抗乱,
CONST.CHAR_抗忘,
CONST.CHAR_必杀,
CONST.CHAR_反击,
CONST.CHAR_命中,
CONST.CHAR_闪躲,
CONST.CHAR_道具栏,
CONST.CHAR_技能栏,
CONST.CHAR_死亡数,
CONST.CHAR_伤害数,
CONST.CHAR_杀宠数,
CONST.CHAR_占卜时间,
CONST.CHAR_受伤,
CONST.CHAR_移间,
CONST.CHAR_循时,
CONST.CHAR_经验,
CONST.CHAR_升级点,
CONST.CHAR_图类,
CONST.CHAR_名色,
CONST.CHAR_掉魂,
CONST.CHAR_原始图档,
CONST.CHAR_名字,
CONST.CHAR_原名,
CONST.CHAR_最大血,
CONST.CHAR_最大魔,
CONST.CHAR_攻击力,
CONST.CHAR_防御力,
CONST.CHAR_敏捷,
CONST.CHAR_精神,
CONST.CHAR_回复,
CONST.CHAR_获得经验,
CONST.CHAR_魔攻,
CONST.CHAR_魔抗,
CONST.CHAR_EnemyBaseId,
CONST.PET_主人RegistNumber,
CONST.PET_DepartureBattleStatus,
CONST.PET_PetID,
CONST.PET_技能栏,
CONST.PET_获取时等级,
CONST.CHAR_主人CD,
CONST.CHAR_主人名字,
CONST.CHAR_主人原名,
}

-- NOTE 宠物成长属性key
local petRankFields={
CONST.PET_体成,
CONST.PET_力成,
CONST.PET_强成,
CONST.PET_敏成,
CONST.PET_魔成,
}

function PetHatching:onLoad()
  self:logInfo('load');
  --资深训练家爷爷
  self.seniorNpc = self:NPC_createNormal('資深訓練家爺爺', 231085, { x = 17, y = 13, mapType = 0, map = 25010, direction = 6 });
  self:NPC_regTalkedEvent(self.seniorNpc, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local seniorCheck = Char.GetExtData(player, "经验库S") or 0;
      if seniorCheck <=0 then
          local msg = "3|\\n你求我幫忙訓練寵物嗎？每次只能訓練一隻寵物，且會依最終獲得的經驗值進行收費！\\n\\n";
          for i=0,4 do
                local pet = Char.GetPet(player,i);
                if(pet<0)then
                      msg = msg .. "空\\n";
                else
                      msg = msg .. ""..Char.GetData(pet,CONST.CHAR_名字).."\\n";
                end
          end
          NLG.ShowWindowTalked(player, self.seniorNpc, CONST.窗口_选择框, CONST.按钮_关闭, 1, msg);
      elseif seniorCheck >0 then
          local SBTime = Char.GetExtData(player, "经验库STime");
          local days = tonumber(os.date("%j",os.time())) - tonumber(os.date("%j",SBTime));
          local hours = tonumber(os.date("%H",os.time())) - tonumber(os.date("%H",SBTime));
          local minutes = tonumber(os.date("%M",os.time())) - tonumber(os.date("%M",SBTime));
          totalMinutes = days*24*60+hours*60+minutes;
          totalGold = totalMinutes*10;
          if (totalGold>=432000) then
              totalMinutes = 43200;       --最高保管上限30天經驗4萬3200
              totalGold = 432000;           --最高收費上限30天的43萬2000
          end
          local msg = "\\n\\n@c目前已訓練時間： "..totalMinutes.." 分\\n\\n\\n現在要領回寵物嗎？\\n\\n總共需要："..totalGold.."魔幣\\n\\n";
          NLG.ShowWindowTalked(player, self.seniorNpc, CONST.窗口_信息框, CONST.按钮_是否, 2, msg);
      end
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(self.seniorNpc, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --保管寵物階段
    if select == 0 then
      if seqno == 1 and data >= 1 then
        local slot = data-1;
        local petIndex = Char.GetPet(player,slot);
        if petIndex>=0 then
             local data = self:extractPetData(petIndex);
             local pet_level = Char.GetData(petIndex, CONST.CHAR_等级);
             local pet_name = Char.GetData(petIndex,CONST.CHAR_名字);
             local pet_image = Char.GetData(petIndex,CONST.CHAR_形象);
             local Pet_ID = Char.GetData(petIndex,CONST.PET_PetID);
             Char.SetExtData(player, "经验库S", Pet_ID);
             Char.SetExtData(player, "经验库STime", os.time() );
             Char.SetExtData(player, "经验库SPet", JSON.encode(data) );
             if petNpcIndex[cdk]==nill then
                    petNpcIndex[cdk] = {}
                    petNpcIndex[cdk][1]=-1
                    petNpcIndex[cdk][2]=-1
             end
             petNpcIndex[cdk][1] = Char.CreateDummy()
             Char.TradePet(player, slot, petNpcIndex[cdk][1]);
             self:regCallback('LoopEvent', Func.bind(self.pnloop,self))
             self:regCallback('pnloop', function(NpcIndex)
                     local dir = math.random(0, 7);
                     local walk = 1;
                     local X,Y = Char.GetLocation(NpcIndex,dir);
                     if (NLG.Walkable(0, 25010, X, Y)==1) then
                         NLG.SetAction(NpcIndex,walk);
                         NLG.WalkMove(NpcIndex,dir);
                         NLG.UpChar(NpcIndex);
                     end
             end)
             Char.SetLoopEvent(nil, 'pnloop', petNpcIndex[cdk][1], math.random(10000,50000));
             Char.SetData(petNpcIndex[cdk][1], CONST.CHAR_等级, pet_level);
             Char.SetData(petNpcIndex[cdk][1], CONST.CHAR_名字, pet_name);
             Char.SetData(petNpcIndex[cdk][1], CONST.CHAR_形象, pet_image);
             Char.SetData(petNpcIndex[cdk][1], CONST.CHAR_原形, pet_image);
             Char.SetData(petNpcIndex[cdk][1], CONST.CHAR_原始图档, pet_image);
             NLG.UpChar(petNpcIndex[cdk][1]);
             Char.Warp(petNpcIndex[cdk][1], 0, 25010, math.random(6,14), math.random(2,17));
             NLG.SystemMessage(player, '寵物 '..pet_name..' 已送進去訓練');
             NLG.UpChar(player);
        end
      end
    --取回寵物階段
    elseif select > 0 then
      if seqno == 2 and select == CONST.按钮_是 then
        local gold = Char.GetData(player, CONST.CHAR_金币);
        if gold < totalGold then
                NLG.SystemMessage(player, '金幣不足無法領回寵物');
                return
        else
            if Char.GetEmptyPetSlot(player) < 0 then
                NLG.SystemMessage(player, '寵物沒有回來的空位');
                return
            else
                local petData= {}
                local Pet_ID = Char.GetExtData(player, "经验库S");
                local data = Char.GetExtData(player, "经验库SPet");
                local petData = JSON.decode(data);
                --取得經驗值
                if petNpcIndex[cdk]==nill then
                    petNpcIndex[cdk] = {}
                    petNpcIndex[cdk][1]=-1
                    petNpcIndex[cdk][2]=-1
                end
                if petNpcIndex[cdk][1]==-1 then
                    petNpcIndex[cdk][1] = Char.CreateDummy()
                    petIndex = Char.GetPet(petNpcIndex[cdk][1],0);
                    if petIndex<0 then
                        Char.AddPet(petNpcIndex[cdk][1], Pet_ID);
                        petIndex = Char.GetPet(petNpcIndex[cdk][1],0);
                        self:insertPetData(petIndex,petData);
                        Pet.UpPet(petNpcIndex[cdk][1],petIndex);
                    end
                elseif petNpcIndex[cdk][1]>=0 then
                    petIndex = Char.GetPet(petNpcIndex[cdk][1],0);
                end
                local level = Char.GetData(petIndex, CONST.CHAR_等级);
                local exp = Char.GetData(petIndex, CONST.CHAR_经验);
                local plusExp = totalMinutes * level * 12;
                Char.SetData(petIndex, CONST.CHAR_经验, exp+plusExp);
                Pet.UpPet(petNpcIndex[cdk][1], petIndex);
                --取回寵物
                Char.TradePet(petNpcIndex[cdk][1], 0, player);
                Char.AddGold(player, -totalGold);
                Char.DelDummy(petNpcIndex[cdk][1])
                petNpcIndex[cdk][1] = -1
                Char.SetExtData(player, "经验库S", 0);
                Char.SetExtData(player, "经验库STime", 0);
                Char.SetExtData(player, "经验库SPet", 0);
                NLG.UpChar(player);
                NLG.SystemMessage(player, '寵物回到你的身邊');
            end
        end
      end

    end
  end)

  --新手饲育家奶奶
  self.juniorNpc = self:NPC_createNormal('新手飼育家奶奶', 231089, { x = 17, y = 10, mapType = 0, map = 25010, direction = 6 });
  self:NPC_regTalkedEvent(self.juniorNpc, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local juniorCheck = Char.GetExtData(player, "经验库J") or 0;
      if juniorCheck <=0 then
          local msg = "3|\\n我可以幫忙你飼養寵物！每次只能飼養一隻寵物，且除了獲得經驗值還可以拿營養物！\\n\\n";
          for i=0,4 do
                local pet = Char.GetPet(player,i);
                if(pet<0)then
                      msg = msg .. "空\\n";
                else
                      msg = msg .. ""..Char.GetData(pet,CONST.CHAR_名字).."\\n";
                end
          end
          NLG.ShowWindowTalked(player, self.juniorNpc, CONST.窗口_选择框, CONST.按钮_关闭, 1, msg);
      elseif juniorCheck >0 then
          local JBTime = Char.GetExtData(player, "经验库JTime");
          local days = tonumber(os.date("%j",os.time())) - tonumber(os.date("%j",JBTime));
          local hours = tonumber(os.date("%H",os.time())) - tonumber(os.date("%H",JBTime));
          local minutes = tonumber(os.date("%M",os.time())) - tonumber(os.date("%M",JBTime));
          totalMinutes = days*24*60+hours*60+minutes;
          totalGold = totalMinutes*10;
          if (totalGold>=432000) then
              totalMinutes = 43200;       --最高保管上限30天經驗4萬3200
              totalGold = 432000;           --最高收費上限30天的43萬2000
          end
          local msg = "\\n\\n@c目前已訓練時間： "..totalMinutes.." 分\\n\\n\\n現在要領回寵物嗎？\\n\\n總共需要："..totalGold.."魔幣\\n\\n";
          NLG.ShowWindowTalked(player, self.juniorNpc, CONST.窗口_信息框, CONST.按钮_是否, 2, msg);
      end
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(self.juniorNpc, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --保管寵物階段
    if select == 0 then
      if seqno == 1 and data >= 1 then
        local slot = data-1;
        local petIndex = Char.GetPet(player,slot);
        if petIndex>=0 then
             local data = self:extractPetData(petIndex);
             local pet_level = Char.GetData(petIndex, CONST.CHAR_等级);
             local pet_name = Char.GetData(petIndex,CONST.CHAR_名字);
             local pet_image = Char.GetData(petIndex,CONST.CHAR_形象);
             local Pet_ID = Char.GetData(petIndex,CONST.PET_PetID);
             Char.SetExtData(player, "经验库J", Pet_ID);
             Char.SetExtData(player, "经验库JTime", os.time() );
             Char.SetExtData(player, "经验库JPet", JSON.encode(data) );
             if petNpcIndex[cdk]==nill then
                    petNpcIndex[cdk] = {}
                    petNpcIndex[cdk][1]=-1
                    petNpcIndex[cdk][2]=-1
             end
             petNpcIndex[cdk][2] = Char.CreateDummy()
             Char.TradePet(player, slot, petNpcIndex[cdk][2]);
             self:regCallback('LoopEvent', Func.bind(self.pnloop,self))
             self:regCallback('pnloop', function(NpcIndex)
                     local dir = math.random(0, 7);
                     local walk = 1;
                     local X,Y = Char.GetLocation(NpcIndex,dir);
                     if (NLG.Walkable(0, 25010, X, Y)==1) then
                         NLG.SetAction(NpcIndex,walk);
                         NLG.WalkMove(NpcIndex,dir);
                         NLG.UpChar(NpcIndex);
                     end
             end)
             Char.SetLoopEvent(nil, 'pnloop', petNpcIndex[cdk][2], math.random(10000,50000));
             Char.SetData(petNpcIndex[cdk][2], CONST.CHAR_等级, pet_level);
             Char.SetData(petNpcIndex[cdk][2], CONST.CHAR_名字, pet_name);
             Char.SetData(petNpcIndex[cdk][2], CONST.CHAR_形象, pet_image);
             Char.SetData(petNpcIndex[cdk][2], CONST.CHAR_原形, pet_image);
             Char.SetData(petNpcIndex[cdk][2], CONST.CHAR_原始图档, pet_image);
             NLG.UpChar(petNpcIndex[cdk][2]);
             Char.Warp(petNpcIndex[cdk][2], 0, 25010, math.random(6,14), math.random(2,17));
             NLG.SystemMessage(player, '寵物 '..pet_name..' 已送進去訓練');
             NLG.UpChar(player);
        end
      end
    --取回寵物階段
    elseif select > 0 then
      if seqno == 2 and select == CONST.按钮_是 then
        local gold = Char.GetData(player, CONST.CHAR_金币);
        if gold < totalGold then
                NLG.SystemMessage(player, '金幣不足無法領回寵物');
                return
        else
            if Char.GetEmptyPetSlot(player) < 0 then
                NLG.SystemMessage(player, '寵物沒有回來的空位');
                return
            else
                local petData= {}
                local Pet_ID = Char.GetExtData(player, "经验库J");
                local data = Char.GetExtData(player, "经验库JPet");
                local petData = JSON.decode(data);
                --取得經驗值
                if petNpcIndex[cdk]==nill then
                    petNpcIndex[cdk] = {}
                    petNpcIndex[cdk][1]=-1
                    petNpcIndex[cdk][2]=-1
                end
                if petNpcIndex[cdk][2]==-1 then
                    petNpcIndex[cdk][2] = Char.CreateDummy()
                    petIndex = Char.GetPet(petNpcIndex[cdk][2],0);
                    if petIndex<0 then
                        Char.AddPet(petNpcIndex[cdk][2], Pet_ID);
                        petIndex = Char.GetPet(petNpcIndex[cdk][2],0);
                        self:insertPetData(petIndex,petData);
                        Pet.UpPet(petNpcIndex[cdk][2],petIndex);
                    end
                elseif petNpcIndex[cdk][2]>=0 then
                    petIndex = Char.GetPet(petNpcIndex[cdk][2],0);
                end
                local level = Char.GetData(petIndex, CONST.CHAR_等级);
                local exp = Char.GetData(petIndex, CONST.CHAR_经验);
                local plusExp = totalMinutes * level * 10;
                Char.SetData(petIndex, CONST.CHAR_经验, exp+plusExp);
                Pet.UpPet(petNpcIndex[cdk][2], petIndex);
                --取回寵物
                if Char.ItemSlot(player)<20 then
                    if (totalMinutes>=60 and totalMinutes<180) then
                        Char.GiveItem(player, 900504, math.random(1,2), '獲得生蛋營養物');
                    elseif (totalMinutes>=180 and totalMinutes<480) then
                        Char.GiveItem(player, 900504, math.random(4,8), '獲得生蛋營養物');
                    elseif (totalMinutes>=480) then
                        Char.GiveItem(player, 900504, math.random(8,10), '獲得生蛋營養物');
                    end
                else
                    NLG.SystemMessage(player, '物品欄沒有空位');
                    return
                end
                Char.TradePet(petNpcIndex[cdk][2], 0, player);
                Char.AddGold(player, -totalGold);
                Char.DelDummy(petNpcIndex[cdk][2])
                petNpcIndex[cdk][2] = -1
                Char.SetExtData(player, "经验库J", 0);
                Char.SetExtData(player, "经验库JTime", 0);
                Char.SetExtData(player, "经验库JPet", 0);
                NLG.UpChar(player);
                NLG.SystemMessage(player, '寵物回到你的身邊');
            end
        end
      end

    end
  end)

  --年轻的魔物研究员
  self.researchNpc = self:NPC_createNormal('年輕的魔物研究員', 260020, { x = 19, y = 5, mapType = 0, map = 25010, direction = 6 });
  self:NPC_regTalkedEvent(self.researchNpc, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local seniorCheck = Char.GetExtData(player, "经验库S") or 0;
      local juniorCheck = Char.GetExtData(player, "经验库J") or 0;
      if seniorCheck >0 and  juniorCheck >0  then
          local researchCheck = Char.GetExtData(player, "研究员R") or 0;
          local RTime = Char.GetExtData(player, "研究员Time") or 0;
          local days = tonumber(os.date("%j",os.time())) - tonumber(os.date("%j",RTime));
          local hours = tonumber(os.date("%H",os.time())) - tonumber(os.date("%H",RTime));
          local minutes = tonumber(os.date("%M",os.time())) - tonumber(os.date("%M",RTime));
          local totalMinutes = days*24*60+hours*60+minutes;
          if (researchCheck==0)  then
              local msg = "\\n\\n@c目前已研究時間： 0 分\\n\\n\\n要餵養看看神奇糖果嗎？\\n\\n第一天研究需要：4個\\n\\n";
              NLG.ShowWindowTalked(player, self.researchNpc, CONST.窗口_信息框, CONST.按钮_是否, 31, msg);
          end
          if (researchCheck==1 and days>=1)  then
              local msg = "\\n\\n@c目前已研究時間： "..totalMinutes.." 分\\n\\n\\n觀察魔物蛋的反應良好！\\n\\n第二天研究需要：8個神奇糖果\\n\\n";
              NLG.ShowWindowTalked(player, self.researchNpc, CONST.窗口_信息框, CONST.按钮_是否, 32, msg);
          elseif (researchCheck==1 and days<1)  then
              local msg = "\\n\\n@c目前已研究時間： "..totalMinutes.." 分\\n\\n\\n研究須等待超過1440分鐘！\\n\\n第二天研究需要：8個神奇糖果\\n\\n";
              NLG.ShowWindowTalked(player, self.researchNpc, CONST.窗口_信息框, CONST.按钮_是否, 3, msg);
          end
          if (researchCheck==2 and days>=1)  then
              local msg = "\\n\\n@c目前已研究時間： "..totalMinutes.." 分\\n\\n\\n特殊的魔物快要出來了！\\n\\n最後的研究需要：16個神奇糖果和5萬魔幣\\n\\n";
              NLG.ShowWindowTalked(player, self.researchNpc, CONST.窗口_信息框, CONST.按钮_是否, 33, msg);
          elseif (researchCheck==2 and days<1)  then
              local msg = "\\n\\n@c目前已研究時間： "..totalMinutes.." 分\\n\\n\\n研究須等待超過1440分鐘！\\n\\n最後的研究需要：16個神奇糖果和5萬魔幣\\n\\n";
              NLG.ShowWindowTalked(player, self.researchNpc, CONST.窗口_信息框, CONST.按钮_是否, 3, msg);
          end
      else
          local msg = "\\n\\n@c請先去找爺爺和奶奶保管你的寵物\\n\\n兩邊都寄放後來找我\\n\\n一起研究如何讓魔物生蛋！\\n\\n";
          NLG.ShowWindowTalked(player, self.researchNpc, CONST.窗口_信息框,CONST.按钮_确定, 3, msg);
      end
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(self.researchNpc, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --餵養蛋階段
    if select > 0 then
      if seqno == 31 and select == CONST.按钮_是 then
        if Char.ItemNum(player,900504)>=4 then
                Char.SetExtData(player, "研究员R", 1);
                Char.SetExtData(player, "研究员Time", os.time() );
                Char.DelItem(player,900504,4);
        else
                NLG.SystemMessage(player, '神奇糖果需要4個');
                return
        end
      elseif seqno == 32 and select == CONST.按钮_是 then
        if Char.ItemNum(player,900504)>=8 then
                Char.SetExtData(player, "研究员R", 2);
                Char.SetExtData(player, "研究员Time", os.time() );
                Char.DelItem(player,900504,8);
        else
                NLG.SystemMessage(player, '神奇糖果需要8個');
                return
        end
    --領養寵物階段
      elseif seqno == 33 and select == CONST.按钮_是 then
        local gold = Char.GetData(player, CONST.CHAR_金币);
        if gold < 50000 then
                NLG.SystemMessage(player, '領養寵物須要5萬金幣');
                return
        else
            if Char.GetEmptyPetSlot(player) < 0 then
                NLG.SystemMessage(player, '寵物沒有回來的空位');
                return
            else
                if Char.ItemNum(player,900504)>=16 then
                    Char.SetExtData(player, "研究员R", 3);
                    Char.DelItem(player,900504,16);
                else
                    NLG.SystemMessage(player, '神奇糖果需要16個');
                    return
                end
                local Pet_ID = Char.GetExtData(player, "经验库S");
                local PetSlot = Char.GetEmptyPetSlot(player);
                Char.AddPet(player, Pet_ID);
                local petIndex = Char.GetPet(player,PetSlot);
                local typeRand = math.random(1,#petMettleTable);
                local pos = math.random(1,#petMettleTable[typeRand]);
                Pet.AddSkill(petIndex, petMettleTable[typeRand][pos], 9);
                Pet.UpPet(player, petIndex);
                --取回寵物
                Char.AddGold(player, -50000);
                Char.SetExtData(player, "研究员R", 0);
                Char.SetExtData(player, "研究员Time", 0);
                NLG.UpChar(player);
                NLG.SystemMessage(player, '恭喜獲得有天生性格的Lv1寵物');
            end
        end
      end

    end
  end)


end




-- NOTE 抽取宠物数据
function PetHatching:extractPetData(petIndex)
  local item = {
    attr={},
    rank={},
    skills={}
  };
  for _, v in pairs(petFields) do
    item.attr[tostring(v)] = Char.GetData(petIndex, v);
    
  end
  for _, v in pairs(petRankFields) do
    item.rank[tostring(v)] = Pet.GetArtRank(petIndex,v);
    
  end
  -- 宠物技能
  local skillTable={}
  for i=0,9 do
    local tech_id = Pet.GetSkill(petIndex, i)
    if tech_id<0 then
      table.insert(skillTable,nil)
    else
      table.insert(skillTable,tech_id)
    end
  end
  item.skills=skillTable
  return item;
end
-- NOTE 赋予宠物数据
function PetHatching:insertPetData(petIndex,petData)
  -- 宠物属性
  for key, v in pairs(petFields) do
    if petData.attr[tostring(v)] ~=nil  then
      Char.SetData(petIndex, v,petData.attr[tostring(v)]);
    end
  end
  -- 忠诚
  -- Char.SetData(petIndex, 495,100);
  -- 宠物成长
  for key, v in pairs(petRankFields) do
    if petData.rank[tostring(v)] ~=nil then
      Pet.SetArtRank(petIndex, v,petData.rank[tostring(v)]);
    end
  end
  -- 宠物技能
  
  for i=0,9 do
    local tech_id = petData.skills[i+1]
    Pet.DelSkill(petIndex,i)
    if tech_id ~=nil then
      
      Pet.AddSkill(petIndex,tech_id, i)
    
    end
  end


end

Char.GetLocation = function(NpcIndex,dir)
	local X = Char.GetData(NpcIndex,CONST.CHAR_X)--地图x
	local Y = Char.GetData(NpcIndex,CONST.CHAR_Y)--地图y
	if dir==0 then
		Y=Y-1;
	elseif dir==1 then
		X=X+1;
		Y=Y-1;
	elseif dir==2 then
		X=X+1;
	elseif dir==3 then
		X=X+1;
		Y=Y+1;
	elseif dir==4 then
		Y=Y+1;
	elseif dir==5 then
		X=X-1;
		Y=Y+1;
	elseif dir==6 then
		X=X-1;
	elseif dir==7 then
		X=X-1;
		Y=Y-1;
	end
	return X,Y;
end

function PetHatching:onUnload()
  self:logInfo('unload')
end

return PetHatching;
