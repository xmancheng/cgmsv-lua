---模块类
local Module = ModuleBase:createModule('petMaster')

local StarSysOn = 0;
local MaxStarLv = 4;
local StarRequireLevel = {10, 30, 50, 70, 100};
local StarRequireGold = {1000, 15000, 20000, 40000, 50000};
local StarEnable_check= {500000,500001,500002,500003,500004,500005,500006,500007,500008,500009,
                         500010,500011,500012,500013,500014,500015,500016,500017,500018,500019,
                         500020,500021,500022,500023,500024,500025,500026,500027,500028,500029,
                         500030,500031,500032,500033,500034,500035,500036,500037,500038,500039,
                         500040,500041,500042,500043,500044,500045,500046,500047,500048,500049,
                         500050,500051,500052,500053,500054,500055,500056,500057,500058,500059,
                         500060,500061,500062};
local StarEnable_list = {};
StarEnable_list[700066] = { 1 };		--第1型:气功弹LV3、力量100点、精灵族、升级气功弹LV7
StarEnable_list[700067] = { 2 };		--第2型:超法(4選1)LV3、魔法100点、精灵族、升级超法LV7
StarEnable_list[700068] = { 3 };		--第3型:超咒(4選1)LV3、速度70点魔法30点、精灵族、升级超咒LV7
StarEnable_list[700069] = { 4 };		--第4型:輔助(4選1)LV3、体力70点魔法30点、精灵族、升级輔助LV7

StarEnable_list[500000] = { 2 };		--凱西
StarEnable_list[500001] = { 3 };		--化石翼龍
StarEnable_list[500002] = { 1 };		--波士可多拉
StarEnable_list[500003] = { 3 };		--雙尾怪手
StarEnable_list[500004] = { 1 };		--超級電龍
StarEnable_list[500005] = { 1 };		--風速狗
StarEnable_list[500006] = { 3 };		--太古盔甲
StarEnable_list[500007] = { 1 };		--月桂葉
StarEnable_list[500008] = { 3 };		--狩獵鳳蝶
StarEnable_list[500009] = { 1 };		--水箭龜
StarEnable_list[500010] = { 4 };		--幸福蛋
StarEnable_list[500011] = { 2 };		--呆火駝
StarEnable_list[500012] = { 4 };		--雪拉比
StarEnable_list[500013] = { 1 };		--噴火龍
StarEnable_list[500014] = { 2 };		--刺甲貝
StarEnable_list[500015] = { 1 };		--卡拉卡拉
StarEnable_list[500016] = { 1 };		--頓甲
StarEnable_list[500017] = { 1 };		--快龍
StarEnable_list[500018] = { 3 };		--三地鼠
StarEnable_list[500019] = { 4 };		--伊布
StarEnable_list[500020] = { 2 };		--帝王拿波
StarEnable_list[500021] = { 3 };		--沙漠蜻蜓
StarEnable_list[500022] = { 1 };		--烈咬陸鯊
StarEnable_list[500023] = { 3 };		--蓋諾賽克特
StarEnable_list[500024] = { 2 };		--耿鬼
StarEnable_list[500025] = { 2 };		--冰鬼護
StarEnable_list[500026] = { 1 };		--甲賀忍蛙
StarEnable_list[500027] = { 1 };		--固拉多
StarEnable_list[500028] = { 4 };		--鳳王
StarEnable_list[500029] = { 3 };		--胡帕
StarEnable_list[500030] = { 1 };		--三首惡龍
StarEnable_list[500031] = { 4 };		--基拉祈(紅)
StarEnable_list[500032] = { 2 };		--蓋歐卡
StarEnable_list[500033] = { 4 };		--拉普拉斯
StarEnable_list[500034] = { 1 };		--路卡利歐
StarEnable_list[500035] = { 2 };		--洛奇亞
StarEnable_list[500036] = { 1 };		--怪力
StarEnable_list[500037] = { 4 };		--瑪機雅娜
StarEnable_list[500038] = { 1 };		--瑪夏多
StarEnable_list[500039] = { 3 };		--喵喵
StarEnable_list[500040] = { 1 };		--超級巨金怪
StarEnable_list[500041] = { 4 };		--夢幻
StarEnable_list[500042] = { 1 };		--尼多王
StarEnable_list[500043] = { 1 };		--尼多后
StarEnable_list[500044] = { 1 };		--蚊香君
StarEnable_list[500045] = { 3 };		--烈空坐
StarEnable_list[500046] = { 2 };		--呆呆王
StarEnable_list[500047] = { 1 };		--卡比獸(創)
StarEnable_list[500048] = { 2 };		--卡璞鰭鰭
StarEnable_list[500049] = { 1 };		--卡璞鳴鳴
StarEnable_list[500050] = { 1 };		--班基拉斯
StarEnable_list[500051] = { 3 };		--超級妙蛙花
StarEnable_list[500052] = { 2 };		--波爾凱尼恩
StarEnable_list[500053] = { 3 };		--雙彈瓦斯
StarEnable_list[500054] = { 1 };		--利歐路
StarEnable_list[500055] = { 1 };		--超級巨沼怪
StarEnable_list[500056] = { 2 };		--超夢Y
StarEnable_list[500057] = { 1 };		--天使衛兵
StarEnable_list[500058] = { 5 };		--奧蘿拉.第5型:追月LV3、力量100点、神族、升级追月LV7
StarEnable_list[500059] = { 2 };		--凡賽妮
StarEnable_list[500060] = { 1 };		--卡麗娜
StarEnable_list[500061] = { 3 };		--南川夏
StarEnable_list[500062] = { 6 };		--艾爾瑪.第6型:乱射LV3、力量100点、神族、升级乱射LV7

-------------------------------------------------------------------------------------------------------------------------------------
--远程按钮UI呼叫
function Module:petMasterInfo(npc, player)
          local msg = "　　　　　　　　$1【寵物星級超量】\\n"
                              .. "　　　　　第一格放置要提升星級的主要寵物\\n"
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
        Char.SetData(petIndex, CONST.对象_PET_HeadGraNo,120007);
        NLG.UpChar(petIndex);
    end
    return 0;
  end)
  self:regCallback('BattleStartEvent', Func.bind(self.OnbattleStarCommand, self))
  self:regCallback('BeforeBattleTurnEvent', Func.bind(self.OnbattleStarCommand, self))
  self.MStarNPC = self:NPC_createNormal('寵物星級超量', 104675, { x = 235, y = 116, mapType = 0, map = 1000, direction = 6 });
  self:NPC_regTalkedEvent(self.MStarNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
          local msg = "　　　　　　　　$1【寵物星級超量】\\n"
                              .. "　　　　　第一格放置要提升星級的主要寵物\\n"
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
                    Char.SetData(petIndex, CONST.对象_PET_HeadGraNo,120007);
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
	elseif (Type==5) then
		if (StarLv==1) then		--★1
			Pet.AddSkill(petIndex, 200502);
		elseif (StarLv==2) then	--★2
			Char.SetData(petIndex,CONST.对象_力量, Char.GetData(petIndex,CONST.对象_力量)+10000);
		elseif (StarLv==3) then	--★3
			Char.SetData(petIndex,CONST.对象_种族, 10);
		elseif (StarLv==4) then	--★4
			for i = 0,9 do
				if (Pet.GetSkill(petIndex,i)==200502) then
					Pet.DelSkill(petIndex,i);
					Pet.AddSkill(petIndex,200506);
				end
			end
		end
	elseif (Type==6) then
		if (StarLv==1) then		--★1
			Pet.AddSkill(petIndex, 9502);
		elseif (StarLv==2) then	--★2
			Char.SetData(petIndex,CONST.对象_力量, Char.GetData(petIndex,CONST.对象_力量)+10000);
		elseif (StarLv==3) then	--★3
			Char.SetData(petIndex,CONST.对象_种族, 10);
		elseif (StarLv==4) then	--★4
			for i = 0,9 do
				if (Pet.GetSkill(petIndex,i)==9502) then
					Pet.DelSkill(petIndex,i);
					Pet.AddSkill(petIndex,9506);
				end
			end
		end
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
