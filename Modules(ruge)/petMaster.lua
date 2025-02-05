---模块类
local Module = ModuleBase:createModule('petMaster')

local StarSysOn = 0;
local StarRequireLevel = {10, 30, 50, 70, 100};
local StarRequireGold = {1000, 15000, 20000, 40000, 50000};

local StarEnable_check= {
    700101,700102,700103,700104,700105,700106,700107,700108,700109,700110,
    700111,700112,700113,700114,700115,700116,700117,700118,700119,700120,
    700121,700122,700123,700124,700125,700126,700127,700128,700129,700130,
    700131,700132,700133,
    700201,700202,700203,700204,700205,700206,700207,700208,
}
local StarEnable_list = {};
--StarEnable_list[700066] = { 1 };		--第1型:气功弹LV3、力量100点、精灵族、升级气功弹LV7
--StarEnable_list[700067] = { 2 };		--第2型:超法(4選1)LV3、魔法100点、精灵族、升级超法LV7
--StarEnable_list[700068] = { 3 };		--第3型:超咒(4選1)LV3、速度70点魔法30点、精灵族、升级超咒LV7
--StarEnable_list[700069] = { 4 };		--第4型:輔助(4選1)LV3、体力70点魔法30点、精灵族、升级輔助LV7
StarEnable_list[700101] = {3, 1};		--第1型:只能進化3星(每進化一星酌量給攻敏BP)
StarEnable_list[700102] = {3, 1};
StarEnable_list[700103] = {3, 2};		--第2型:只能進化3星(每進化一星酌量給敏魔BP)
StarEnable_list[700104] = {3, 1};
StarEnable_list[700105] = {3, 1};
StarEnable_list[700106] = {3, 2};
StarEnable_list[700107] = {3, 2};
StarEnable_list[700108] = {3, 2};
StarEnable_list[700109] = {3, 2};
StarEnable_list[700110] = {3, 2};
StarEnable_list[700111] = {3, 1};
StarEnable_list[700112] = {3, 1};
StarEnable_list[700113] = {3, 2};
StarEnable_list[700114] = {3, 1};
StarEnable_list[700115] = {3, 1};
StarEnable_list[700116] = {3, 1};
StarEnable_list[700117] = {3, 1};
StarEnable_list[700118] = {3, 1};
StarEnable_list[700119] = {3, 2};
StarEnable_list[700120] = {3, 2};
StarEnable_list[700121] = {3, 2};
StarEnable_list[700122] = {5, 3};		--第3型:只能進化5星(每進化一星酌量給攻敏BP)
StarEnable_list[700123] = {5, 3};
StarEnable_list[700124] = {5, 3};
StarEnable_list[700125] = {5, 3};
StarEnable_list[700126] = {5, 4};		--第4型:只能進化5星(每進化一星酌量給敏魔BP)
StarEnable_list[700127] = {5, 4};
StarEnable_list[700128] = {5, 3};
StarEnable_list[700129] = {5, 3};
StarEnable_list[700130] = {5, 3};
StarEnable_list[700131] = {5, 4};
StarEnable_list[700132] = {5, 4};
StarEnable_list[700133] = {5, 3};

StarEnable_list[700201] = {5, 4};
StarEnable_list[700202] = {5, 3};
StarEnable_list[700203] = {5, 3};
StarEnable_list[700204] = {5, 4};
StarEnable_list[700205] = {5, 3};
StarEnable_list[700206] = {5, 4};
StarEnable_list[700207] = {5, 3};
StarEnable_list[700208] = {5, 3};

---------------------------------------------------------------------
local StarTech_list = {};
StarTech_list[700101] = { 1442 };		--妙蛙種子.茂盛
StarTech_list[700102] = { 1443 };		--小火龍.猛火
StarTech_list[700103] = { 1444 };		--傑尼龜.激流
StarTech_list[700104] = { 1442 };		--木木梟.茂盛
StarTech_list[700105] = { 1443 };		--火斑喵.猛火
StarTech_list[700106] = { 1444 };		--球球海獅.激流
StarTech_list[700107] = { 1442 };		--菊草葉.茂盛
StarTech_list[700108] = { 1443 };		--火球鼠.猛火
StarTech_list[700109] = { 1444 };		--小鋸鱷.激流
StarTech_list[700110] = { 1442 };		--木守宮.茂盛
StarTech_list[700111] = { 1443 };		--火雉雞.猛火
StarTech_list[700112] = { 1444 };		--水躍魚.激流
StarTech_list[700113] = { 1442 };		--草苗龜.茂盛
StarTech_list[700114] = { 1443 };		--小火焰猴.猛火
StarTech_list[700115] = { 1444 };		--波加曼.激流
StarTech_list[700116] = { 1442 };		--藤藤蛇.茂盛
StarTech_list[700117] = { 1443 };		--暖暖豬.猛火
StarTech_list[700118] = { 1444 };		--水水獺.激流
StarTech_list[700119] = { 1442 };		--哈力栗.茂盛
StarTech_list[700120] = { 1443 };		--火狐狸.猛火
StarTech_list[700121] = { 1444 };		--呱呱泡蛙.激流
StarTech_list[700122] = { 1445 };		--皮卡丘.靜電
StarTech_list[700123] = { 1446 };		--幼基拉斯.毅力
StarTech_list[700124] = { 1441 };		--牙牙.健壯胸肌
StarTech_list[700125] = { 1453 };		--利歐路.不屈之心
StarTech_list[700126] = { 1452 };		--索羅亞.迷人之軀
StarTech_list[700127] = { 1447 };		--圓陸鯊.沙隱
StarTech_list[700128] = { 1452 };		--捲捲耳.迷人之軀
StarTech_list[700129] = { 1448 };		--帕奇利茲.蓄電
StarTech_list[700130] = { 1450 };		--伊布.適應力
StarTech_list[700131] = { 1449 };		--時拉比.飄浮
StarTech_list[700132] = { 1449 };		--瑪納霏.飄浮
StarTech_list[700133] = { 1440 };		--瑪夏多.銳利目光

StarTech_list[700201] = { 1446 };		--可達鴨.毅力
StarTech_list[700202] = { 1450 };		--不良蛙.適應力
StarTech_list[700203] = { 1441 };		--小箭雀.健壯胸肌
StarTech_list[700204] = { 1444 };		--甲賀忍蛙.激流
StarTech_list[700205] = { 1442 };		--狙射樹梟.茂盛
StarTech_list[700206] = { 1451 };		--露奈雅拉.壓迫感
StarTech_list[700207] = { 1451 };		--索爾迦雷歐.壓迫感
StarTech_list[700208] = { 1451 };		--奈克洛茲瑪.壓迫感

-------------------------------------------------------------------------------------------------------------------------------------
--远程按钮UI呼叫
function Module:petMasterInfo(npc, player)
          local msg = "　　　　　　　　【寵物星級超量】\\n"
                              .. "　　　　　$1第一格放置要提升星級的主要寵物\\n"
                              .. "　　　　$2注意:  其餘位置將暫時為材料寵物區\\n"
          local petIndex = Char.GetPet(player,0);	--主宠固定宠物栏第一格
          local PetId = Char.GetData(petIndex,CONST.PET_PetID);
          if (petIndex>=0 and CheckInTable(StarEnable_check, PetId)==true) then
              --主要宠物
              local PetName_1 = Char.GetData(petIndex,CONST.对象_原名);
              local PetImage_1 = Char.GetData(petIndex,CONST.对象_形象);
              local imageText_1 = "@g,"..PetImage_1..",3,8,6,0@"
              msg = msg .. "$4主要寵: "..PetName_1
              --材料宠物
              local materialPetIndex,mSlot = Char.GetMaterialPet(player,PetId);
              if (materialPetIndex>0) then
                  StarSysOn = 1;
                  local mSlot = mSlot+1;
                  local PetName_2 = Char.GetData(materialPetIndex,CONST.对象_原名);
                  local PetImage_2 = Char.GetData(materialPetIndex,CONST.对象_形象);
                  local imageText_2 = "@g,"..PetImage_2..",13,8,6,0@"
                  msg = msg .. "　　$2材料寵(第"..mSlot.."格): "..PetName_2.."\\n"
                                        .. imageText_1 .. imageText_2;
              else
                  StarSysOn = 0;
                  msg = msg .. "　　$2材料寵(第X格): 無符合\\n"
                                        .. imageText_1;
              end
          else
              StarSysOn = 0;
              msg = msg .. "主要寵: 非可星級超量的寵物" .. "\\n\\n\\n材料寵(第X格): 無符合\\n";
          end
          NLG.ShowWindowTalked(player, self.MStarNPC, CONST.窗口_信息框, CONST.按钮_确定关闭, 1, msg);
end

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('PetFieldEvent', function(player, petIndex, PetPos)
    local StarLv = Char.GetPetStar(player,PetPos);
    if (StarLv>=4) then
        Char.SetData(petIndex, CONST.对象_PET_HeadGraNo,119646);
        NLG.UpChar(petIndex);
    end
    return 0;
  end)
  self:regCallback('BattleStartEvent', Func.bind(self.OnbattleStarCommand, self))
  self:regCallback('BeforeBattleTurnEvent', Func.bind(self.OnbattleStarCommand, self))
  self.MStarNPC = self:NPC_createNormal('寵物星級超量', 104675, { x = 235, y = 116, mapType = 0, map = 1000, direction = 6 });
  self:NPC_regTalkedEvent(self.MStarNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
          local msg = "　　　　　　　　【寵物星級超量】\\n"
                              .. "　　　　　$1第一格放置要提升星級的主要寵物\\n"
                              .. "　　　　$2注意:  其餘位置將暫時為材料寵物區\\n"
          local petIndex = Char.GetPet(player,0);	--主宠固定宠物栏第一格
          local PetId = Char.GetData(petIndex,CONST.PET_PetID);
          if (petIndex>=0 and CheckInTable(StarEnable_check, PetId)==true) then
              --主要宠物
              local PetName_1 = Char.GetData(petIndex,CONST.对象_原名);
              local PetImage_1 = Char.GetData(petIndex,CONST.对象_形象);
              local imageText_1 = "@g,"..PetImage_1..",3,8,6,0@"
              msg = msg .. "$4主要寵: "..PetName_1
              --材料宠物
              local materialPetIndex,mSlot = Char.GetMaterialPet(player,PetId);
              if (materialPetIndex>0) then
                  StarSysOn = 1;
                  local mSlot = mSlot+1;
                  local PetName_2 = Char.GetData(materialPetIndex,CONST.对象_原名);
                  local PetImage_2 = Char.GetData(materialPetIndex,CONST.对象_形象);
                  local imageText_2 = "@g,"..PetImage_2..",13,8,6,0@"
                  msg = msg .. "　　$2材料寵(第"..mSlot.."格): "..PetName_2.."\\n"
                                        .. imageText_1 .. imageText_2;
              else
                  StarSysOn = 0;
                  msg = msg .. "　　$2材料寵(第X格): 無符合\\n"
                                        .. imageText_1;
              end
          else
              StarSysOn = 0;
              msg = msg .. "主要寵: 非可星級超量的寵物" .. "\\n\\n\\n材料寵(第X格): 無符合\\n";
          end
          NLG.ShowWindowTalked(player, self.MStarNPC, CONST.窗口_信息框, CONST.按钮_确定关闭, 1, msg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.MStarNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    local tPlayerGold = Char.GetData(player, CONST.对象_金币);
    --print(data)
    if select > 0 then
      if (seqno == 1 and select == CONST.按钮_关闭) then
                 return;
      elseif (seqno == 1 and select == CONST.按钮_确定) then
          if (StarSysOn == 1) then
              local petIndex = Char.GetPet(player,0);
              local PetId = Char.GetData(petIndex,CONST.PET_PetID);
              local MaxStarLv = StarEnable_list[PetId][1];
              local Type = StarEnable_list[PetId][1];
              local PetName_1 = Char.GetData(petIndex,CONST.对象_原名);
              local PetLevel_1 = Char.GetData(petIndex,CONST.对象_等级);
              local materialPetIndex,mSlot = Char.GetMaterialPet(player,PetId);
              local PetName_2 = Char.GetData(materialPetIndex,CONST.对象_原名);
              local PetGetLevel_2 = Char.GetData(materialPetIndex,CONST.宠物_获取时等级);
              if (PetGetLevel_2~=1) then
                  NLG.SystemMessage(player, "[系統] 材料寵物非從1級訓練的寶寶。");
                  return;
              end
              local last = string.find(PetName_1, "★", 1);
              if (last==nil) then
                  --防低吃高机制
                  local last_2 = string.find(PetName_2, "★", 1);
                  if (last_2==nil) then StarLv_2 = 0; else StarLv_2=tonumber(string.sub(PetName_2, last_2+2, -1)); end
                  if ( 1<StarLv_2 ) then
                      NLG.SystemMessage(player, "[系統] 請確認材料寵物的星級。");
                      return;
                  end
                  if (PetLevel_1<StarRequireLevel[1]) then
                      NLG.SystemMessage(player, "[系統] 主要寵物的等級未達".. StarRequireLevel[1] .."。");
                      return;
                  end
                  if (tPlayerGold<StarRequireGold[1]) then
                      NLG.SystemMessage(player, "[系統] 星級系統操作費用 "..StarRequireGold[1].."G，所需金幣不足。");
                      return;
                  end
                  local PetRawName = PetName_1;
                  Char.SetData(petIndex,CONST.对象_原名, PetRawName .. "★1");
                  RunStar(petIndex, Type, 1);
                  Char.DelSlotPet(player, mSlot);
                  Pet.UpPet(player,petIndex);
                  Char.AddGold(player, -StarRequireGold[1]);
                  NLG.UpChar(player);
                  NLG.SystemMessage(player, "[系統] ".. PetRawName .."成功進化為★1。");
              elseif (last~=nil) then
                  local StarLv = tonumber(string.sub(PetName_1, last+2, -1));
                  local PetRawName = string.sub(PetName_1, 1, last-1);
                  if (StarLv>=1 and StarLv<MaxStarLv) then
                      --防低吃高机制
                      local last_2 = string.find(PetName_2, "★", 1);
                      if (last_2==nil) then StarLv_2 = 0; else StarLv_2=tonumber(string.sub(PetName_2, last_2+2, -1)); end
                      if ( StarLv<StarLv_2 ) then
                          NLG.SystemMessage(player, "[系統] 請確認材料寵物的星級。");
                          return;
                      end
                      local StarLv=StarLv+1;		--升级过星级Lv
                      if (PetLevel_1<StarRequireLevel[StarLv]) then
                          NLG.SystemMessage(player, "[系統] 主要寵物的等級未達".. StarRequireLevel[StarLv] .."。");
                          return;
                      end
                      if (tPlayerGold<StarRequireGold[StarLv]) then
                          NLG.SystemMessage(player, "[系統] 星級系統操作費用 "..StarRequireGold[StarLv].."G，所需金幣不足。");
                          return;
                      end
                      Char.SetData(petIndex,CONST.对象_原名, PetRawName .. "★".. StarLv);
                      RunStar(petIndex, Type, StarLv);
                      Char.DelSlotPet(player, mSlot);
                      Pet.UpPet(player,petIndex);
                      Char.AddGold(player, -StarRequireGold[StarLv]);
                      NLG.UpChar(player);
                      NLG.SystemMessage(player, "[系統] ".. PetRawName .."成功進化為★".. StarLv .."。");
                  else
                      NLG.SystemMessage(player, "[系統] 星級已達目前開放上限。");
                      return;
                  end
              end
          elseif (StarSysOn == 0) then
              NLG.SystemMessage(player, "[系統] 條件不符合，星級系統停止操作。");
              return;
          end
      end
    else

    end
  end)


end

function Module:OnbattleStarCommand(battleIndex)
    for i=0, 19 do
        local petIndex = Battle.GetPlayIndex(battleIndex, i)
        if (petIndex>=0 and Char.IsPet(petIndex)) then
            local PetName = Char.GetData(petIndex,CONST.对象_原名);
            local last = string.find(PetName, "★", 1);
            if (last==nil) then
                    NLG.UpChar(petIndex);
            elseif (last~=nil) then
                local StarLv = tonumber(string.sub(PetName, last+2, -1));
                if (StarLv>=4) then
                    Char.SetData(petIndex, CONST.对象_PET_HeadGraNo,119646);
                    NLG.UpChar(petIndex);
                else
                    NLG.UpChar(petIndex);
                end
            end
        end
    end
end


--各类型宠物升星执行
function RunStar(petIndex,Type,StarLv)
	local PetId = Char.GetData(petIndex,CONST.PET_PetID);
	if (Type==1) then
		if (StarLv==1) then		--★1
			Char.SetData(petIndex,CONST.对象_力量, Char.GetData(petIndex,CONST.对象_力量)+500);
			Char.SetData(petIndex,CONST.对象_速度, Char.GetData(petIndex,CONST.对象_速度)+500);
		elseif (StarLv==2) then	--★2
			Char.SetData(petIndex,CONST.对象_力量, Char.GetData(petIndex,CONST.对象_力量)+1000);
			Char.SetData(petIndex,CONST.对象_速度, Char.GetData(petIndex,CONST.对象_速度)+1000);
		elseif (StarLv==3) then	--★3
			Char.SetData(petIndex,CONST.对象_力量, Char.GetData(petIndex,CONST.对象_力量)+2000);
			Char.SetData(petIndex,CONST.对象_速度, Char.GetData(petIndex,CONST.对象_速度)+2000);
			if StarTech_list[PetId][1]>0 then
				Pet.AddSkill(petIndex,StarTech_list[PetId][1],8);
			end
		end
	elseif (Type==2) then
		if (StarLv==1) then		--★1
			Char.SetData(petIndex,CONST.对象_魔法, Char.GetData(petIndex,CONST.对象_魔法)+500);
			Char.SetData(petIndex,CONST.对象_速度, Char.GetData(petIndex,CONST.对象_速度)+500);
		elseif (StarLv==2) then	--★2
			Char.SetData(petIndex,CONST.对象_魔法, Char.GetData(petIndex,CONST.对象_魔法)+1000);
			Char.SetData(petIndex,CONST.对象_速度, Char.GetData(petIndex,CONST.对象_速度)+1000);
		elseif (StarLv==3) then	--★3
			Char.SetData(petIndex,CONST.对象_魔法, Char.GetData(petIndex,CONST.对象_魔法)+2000);
			Char.SetData(petIndex,CONST.对象_速度, Char.GetData(petIndex,CONST.对象_速度)+2000);
			if StarTech_list[PetId][1]>0 then
				Pet.AddSkill(petIndex,StarTech_list[PetId][1],8);
			end
		end
	elseif (Type==3) then
		if (StarLv==1) then		--★1
			Char.SetData(petIndex,CONST.对象_力量, Char.GetData(petIndex,CONST.对象_力量)+500);
			Char.SetData(petIndex,CONST.对象_速度, Char.GetData(petIndex,CONST.对象_速度)+500);
		elseif (StarLv==2) then	--★2
			Char.SetData(petIndex,CONST.对象_力量, Char.GetData(petIndex,CONST.对象_力量)+800);
			Char.SetData(petIndex,CONST.对象_速度, Char.GetData(petIndex,CONST.对象_速度)+800);
		elseif (StarLv==3) then	--★3
			Char.SetData(petIndex,CONST.对象_力量, Char.GetData(petIndex,CONST.对象_力量)+1200);
			Char.SetData(petIndex,CONST.对象_速度, Char.GetData(petIndex,CONST.对象_速度)+1200);
		elseif (StarLv==4) then	--★4
			Char.SetData(petIndex,CONST.对象_力量, Char.GetData(petIndex,CONST.对象_力量)+1500);
			Char.SetData(petIndex,CONST.对象_速度, Char.GetData(petIndex,CONST.对象_速度)+1500);
			if StarTech_list[PetId][1]>0 then
				Pet.AddSkill(petIndex,StarTech_list[PetId][1],8);
			else
				local techSet = {1440,1441}
				local techRand = NLG.Rand(1,2);
				Pet.AddSkill(petIndex, techSet[techRand],8);
			end
		elseif (StarLv==5) then	--★5
			Char.SetData(petIndex,CONST.对象_力量, Char.GetData(petIndex,CONST.对象_力量)+3000);
			Char.SetData(petIndex,CONST.对象_速度, Char.GetData(petIndex,CONST.对象_速度)+3000);
		end
	elseif (Type==4) then
		if (StarLv==1) then		--★1
			Char.SetData(petIndex,CONST.对象_魔法, Char.GetData(petIndex,CONST.对象_魔法)+500);
			Char.SetData(petIndex,CONST.对象_速度, Char.GetData(petIndex,CONST.对象_速度)+500);
		elseif (StarLv==2) then	--★2
			Char.SetData(petIndex,CONST.对象_魔法, Char.GetData(petIndex,CONST.对象_魔法)+800);
			Char.SetData(petIndex,CONST.对象_速度, Char.GetData(petIndex,CONST.对象_速度)+800);
		elseif (StarLv==3) then	--★3
			Char.SetData(petIndex,CONST.对象_魔法, Char.GetData(petIndex,CONST.对象_魔法)+1200);
			Char.SetData(petIndex,CONST.对象_速度, Char.GetData(petIndex,CONST.对象_速度)+1200);
		elseif (StarLv==4) then	--★4
			Char.SetData(petIndex,CONST.对象_魔法, Char.GetData(petIndex,CONST.对象_魔法)+1500);
			Char.SetData(petIndex,CONST.对象_速度, Char.GetData(petIndex,CONST.对象_速度)+1500);
			if StarTech_list[PetId][1]>0 then
				Pet.AddSkill(petIndex,StarTech_list[PetId][1],8);
			else
				local techSet = {1440,1441}
				local techRand = NLG.Rand(1,2);
				Pet.AddSkill(petIndex, techSet[techRand],8);
			end
		elseif (StarLv==5) then	--★5
			Char.SetData(petIndex,CONST.对象_魔法, Char.GetData(petIndex,CONST.对象_魔法)+3000);
			Char.SetData(petIndex,CONST.对象_速度, Char.GetData(petIndex,CONST.对象_速度)+3000);
		end
--[[
	if (Type==1) then
		if (StarLv==1) then		--★1
			Pet.AddSkill(petIndex, 402);
		elseif (StarLv==2) then	--★2
			Char.SetData(petIndex,CONST.对象_力量, Char.GetData(petIndex,CONST.对象_力量)+10000);
		elseif (StarLv==3) then	--★3
			Char.SetData(petIndex,CONST.对象_种族, 11);
		elseif (StarLv==4) then	--★4
			for i = 0,9 do
				if (Pet.GetSkill(petIndex,i)==402) then
					Pet.DelSkill(petIndex,i);
					Pet.AddSkill(petIndex,406);
				end
			end
		end
	elseif (Type==2) then
		if (StarLv==1) then		--★1
			local magicSet = {2702,2802,2902,3002}
			local magicRand = NLG.Rand(1,4);
			Pet.AddSkill(petIndex, magicSet[magicRand]);
		elseif (StarLv==2) then	--★2
			Char.SetData(petIndex,CONST.对象_魔法, Char.GetData(petIndex,CONST.对象_魔法)+10000);
		elseif (StarLv==3) then	--★3
			Char.SetData(petIndex,CONST.对象_种族, 11);
		elseif (StarLv==4) then	--★4
			for i = 0,9 do
				if (Pet.GetSkill(petIndex,i)==2702) then
					Pet.DelSkill(petIndex,i);
					Pet.AddSkill(petIndex,2706);
				elseif (Pet.GetSkill(petIndex,i)==2802) then
					Pet.DelSkill(petIndex,i);
					Pet.AddSkill(petIndex,2806);
				elseif (Pet.GetSkill(petIndex,i)==2902) then
					Pet.DelSkill(petIndex,i);
					Pet.AddSkill(petIndex,2906);
				elseif (Pet.GetSkill(petIndex,i)==3002) then
					Pet.DelSkill(petIndex,i);
					Pet.AddSkill(petIndex,3006);
				end
			end
		end
	elseif (Type==3) then
		if (StarLv==1) then		--★1
			local magicSet = {4402,4502,4602,4802}
			local magicRand = NLG.Rand(1,4);
			Pet.AddSkill(petIndex, magicSet[magicRand]);
		elseif (StarLv==2) then	--★2
			Char.SetData(petIndex,CONST.对象_速度, Char.GetData(petIndex,CONST.对象_速度)+7000);
			Char.SetData(petIndex,CONST.对象_魔法, Char.GetData(petIndex,CONST.对象_魔法)+3000);
		elseif (StarLv==3) then	--★3
			Char.SetData(petIndex,CONST.对象_种族, 11);
		elseif (StarLv==4) then	--★4
			for i = 0,9 do
				if (Pet.GetSkill(petIndex,i)==4402) then
					Pet.DelSkill(petIndex,i);
					Pet.AddSkill(petIndex,4406);
				elseif (Pet.GetSkill(petIndex,i)==4502) then
					Pet.DelSkill(petIndex,i);
					Pet.AddSkill(petIndex,4506);
				elseif (Pet.GetSkill(petIndex,i)==4602) then
					Pet.DelSkill(petIndex,i);
					Pet.AddSkill(petIndex,4606);
				elseif (Pet.GetSkill(petIndex,i)==4802) then
					Pet.DelSkill(petIndex,i);
					Pet.AddSkill(petIndex,4806);
				end
			end
		end
	elseif (Type==4) then
		if (StarLv==1) then		--★1
			local magicSet = {6302,6602,6702,6802}
			local magicRand = NLG.Rand(1,4);
			Pet.AddSkill(petIndex, magicSet[magicRand]);
		elseif (StarLv==2) then	--★2
			Char.SetData(petIndex,CONST.对象_体力, Char.GetData(petIndex,CONST.对象_体力)+7000);
			Char.SetData(petIndex,CONST.对象_魔法, Char.GetData(petIndex,CONST.对象_魔法)+3000);
		elseif (StarLv==3) then	--★3
			Char.SetData(petIndex,CONST.对象_种族, 11);
		elseif (StarLv==4) then	--★4
			for i = 0,9 do
				if (Pet.GetSkill(petIndex,i)==6302) then
					Pet.DelSkill(petIndex,i);
					Pet.AddSkill(petIndex,6306);
				elseif (Pet.GetSkill(petIndex,i)==6602) then
					Pet.DelSkill(petIndex,i);
					Pet.AddSkill(petIndex,6606);
				elseif (Pet.GetSkill(petIndex,i)==6702) then
					Pet.DelSkill(petIndex,i);
					Pet.AddSkill(petIndex,6706);
				elseif (Pet.GetSkill(petIndex,i)==6802) then
					Pet.DelSkill(petIndex,i);
					Pet.AddSkill(petIndex,6806);
				end
			end
		end
]]
	else
	end
end

--方便接口
Char.GetMaterialPet = function(charIndex,enemyid)
  for Slot=1,4 do
      local PetIndex = Char.GetPet(charIndex, Slot);
      if (PetIndex >= 0) then
          local MPetId = Char.GetData(PetIndex,CONST.PET_PetID);
          --print(PetIndex,enemyid,MPetId);
          if (enemyid==MPetId) then
              return PetIndex,Slot;
          end
      end
  end
  return -1,-1;
end

Char.GetPetStar = function(playerIndex,slot)
  local petIndex = Char.GetPet(playerIndex, slot);
  if petIndex >= 0 then
    local PetName = Char.GetData(petIndex,CONST.对象_原名);
    local last = string.find(PetName, "★", 1);
    if (last==nil) then
        local StarLv = 0;
        return StarLv;
    elseif (last~=nil) then
        local StarLv = tonumber(string.sub(PetName, last+2, -1));
        return StarLv;
    end
  end
  return -1;
end

function CheckInTable(_idTab, _idVar) ---循环函数
	for k,v in pairs(_idTab) do
		if v==_idVar then
			return true
		end
	end
	return false
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
