---模块类
local Module = ModuleBase:createModule('petCultivation')

------------------------------------------------
-- 寵物吸收設定
------------------------------------------------
-- 每一隻同名犧牲寵物提供多少培養 EXP
local SACRIFICE_PET_EXP = 100
-- 第一階培養所需 EXP
local FIRST_EXP_NEED = 100
-- 每成功增加 1 點品階後，下一階需求 EXP 倍率
local EXP_GROWTH_RATE = 1.15

local PET_GRADE_TYPES = {
    CONST.PET_体成,
    CONST.PET_力成,
    CONST.PET_强成,
    CONST.PET_敏成,
    CONST.PET_魔成,
}
--------------------------------------------------
-- 寵物技能資料表
--
-- 欄位：
-- name       = 技能名稱
-- gradeIndex = 五圍索引
-- gradeValue = 檔次門檻
-- levelLimit = 等級限制，-1 代表不限
-- petID      = PETID 限制，-1 代表不限
--
-- 五圍索引：
-- 1 = 體力
-- 2 = 力量
-- 3 = 強度
-- 4 = 速度
-- 5 = 魔法
local PET_GRADE_NAMES = {
    [1] = "體力",
    [2] = "力量",
    [3] = "強度",
    [4] = "速度",
    [5] = "魔法",
}
--------------------------------------------------
local PET_SKILL_DATA = {
    { name = "騎士之譽LV4", techId = 26103, gradeIndex = 1, gradeValue = 40, levelLimit = 10, petID = -1,},
    { name = "攻擊吸收LV1", techId = 5700, gradeIndex = 1, gradeValue = 45, levelLimit = 30, petID = -1,},
    { name = "魔法吸收LV1", techId = 5800, gradeIndex = 1, gradeValue = 45, levelLimit = 30, petID = -1,},
    --------------------------------------------------
    { name = "戒驕戒躁LV4", techId = 25703, gradeIndex = 2, gradeValue = 30, levelLimit = -1, petID = -1,},
    { name = "氣功彈LV4", techId = 403, gradeIndex = 2, gradeValue = 40, levelLimit = 10, petID = -1,},
    { name = "活殺氣功彈", techId = 409, gradeIndex = 2, gradeValue = 45, levelLimit = 30, petID = -1,},
    --------------------------------------------------
    { name = "強力恢復魔法LV4", techId = 6503, gradeIndex = 3, gradeValue = 40, levelLimit = 25, petID = -1,},
    { name = "攻擊反彈LV1", techId = 5500, gradeIndex = 3, gradeValue = 45, levelLimit = 30, petID = -1,},
    { name = "魔法反彈LV1", techId = 5600, gradeIndex = 3, gradeValue = 45, levelLimit = 30, petID = -1,},
    { name = "屬性反轉LV4", techId = 5403, gradeIndex = 3, gradeValue = 50, levelLimit = 40, petID = -1,},
    --------------------------------------------------
    { name = "追月LV4", techId = 200503, gradeIndex = 4, gradeValue = 40, levelLimit = 10, petID = -1,},
    { name = "鴻雁追月", techId = 200509, gradeIndex = 4, gradeValue = 45, levelLimit = 30, petID = -1,},
    { name = "潔凈魔法LV4", techId = 6703, gradeIndex = 4, gradeValue = 50, levelLimit = 40, petID = -1,},
    --------------------------------------------------
    { name = "強力補血魔法LV4", techId = 6203, gradeIndex = 5, gradeValue = 40, levelLimit = 20, petID = -1,},
    { name = "超強隕石魔法LV4", techId = 2703, gradeIndex = 5, gradeValue = 50, levelLimit = 40, petID = -1,},
    { name = "超強冰凍魔法LV4", techId = 2803, gradeIndex = 5, gradeValue = 50, levelLimit = 40, petID = -1,},
    { name = "超強火焰魔法LV4", techId = 2903, gradeIndex = 5, gradeValue = 50, levelLimit = 40, petID = -1,},
    { name = "超強風刃魔法LV4", techId = 3003, gradeIndex = 5, gradeValue = 50, levelLimit = 40, petID = -1,},
}
------------------------------------------------
-- 寵物突破設定
------------------------------------------------
local BREAKTHROUGH_MAX_RANK = 170	--目前伺服器突破檔次上限
local BREAKTHROUGH_AMOUNTS = {		--合法突破幅度
    [2] = true,
    [3] = true,
}
local BREAKTHROUGH_CRYSTALS = {
    [18310] = 1, -- 地之水晶碎片
    [18311] = 2, -- 水之水晶碎片
    [18312] = 3, -- 火之水晶碎片
    [18313] = 4, -- 風之水晶碎片
}
local BREAKTHROUGH_CRYSTAL_COST = {
    { min = 110, max = 120, cost = 5 },
    { min = 120, max = 125, cost = 10 },
    { min = 126, max = 130, cost = 15 },
    { min = 131, max = 135, cost = 20 },
    { min = 136, max = 139, cost = 30 },
    { min = 140, max = 144, cost = 60 },
    { min = 145, max = 149, cost = 100 },
    { min = 150, max = 154, cost = 160 },
    { min = 155, max = 159, cost = 240 },
    { min = 160, max = 164, cost = 350 },
    { min = 165, max = 169, cost = 500 },
}
local BREAKTHROUGH_RECIPES = {
    -- 4選2
    ["1,2"] = {1,2},
    ["1,3"] = {1,3},
    ["1,4"] = {1,4},
    ["2,3"] = {1,5},
    ["2,4"] = {3,5},
    ["3,4"] = {2,4},
    -- 4選3
    ["1,2,3"] = {1,2,3},
    ["1,2,4"] = {1,2,4},
    ["1,3,4"] = {1,2,5},
    ["2,3,4"] = {3,4,5},
}
local BREAKTHROUGH_RECIPE_NAMES = {
    ["1,2"] = "岩潮之契",
    ["1,3"] = "炎岩之契",
    ["1,4"] = "蒼嵐之契",
    ["2,3"] = "熾潮之契",
    ["2,4"] = "蒼風之契",
    ["3,4"] = "炎嵐之契",
    ["1,2,3"] = "大地熔潮之契",
    ["1,2,4"] = "大地蒼嵐之契",
    ["1,3,4"] = "炎岩天風之契",
    ["2,3,4"] = "熾潮天嵐之契",
}
--------------------------------------------------
-- 客戶端封包通訊同步
--------------------------------------------------
function Module:SendData(fd,head,data)
    local player = tonumber(Protocol.GetCharByFd(fd))
    if head == 'RequestPetCultivationData' then
      local requestData = data[1] or ""
      local requestArr = {}
      for value in string.gmatch(requestData, "[^|]+") do
        table.insert(requestArr, value)
      end
      local page = tonumber(requestArr[1]) or 1
      local petSlot = tonumber(requestArr[2])
      if not petSlot then return end

      local petIndex = Char.GetPet(player, petSlot-1);
      if petIndex <= 0 then
        Protocol.Send(player,'ResponsePetCultivationData',"0|0|0|0|0|0|0|0,0,0,0,0,0,0,0,0,0|"..tostring(page))
        return
      end

      local id1 = petSlot;
      local id2 = Char.GetData(petIndex,CONST.对象_原名);			--PetName
      local id3,id5 = GetCultivationData(player,petIndex);		--cultivationExp, cultivationCount
	  local id4 = GetCultivationExpNeed(id5);					--expNeed
	  local id6 = IsPetCultivationMaxed(petIndex) and 1 or 0;	--maxed
	  local id7 = IsPetProtectLocked(player, petIndex);			--locked
	  --寵物目前檔次與最高檔次
	  local gradeData = {}
	  for _, gradeType in ipairs(PET_GRADE_TYPES) do
        local currentRank = Pet.GetArtRank(petIndex,gradeType);
        local fullRank = Pet.FullArtRank(petIndex,gradeType);
        table.insert(gradeData,tostring(currentRank));
        table.insert(gradeData,tostring(fullRank));
      end
      Protocol.Send(player,'ResponsePetCultivationData', id1.."|"..id2.."|"..id3.."|"..id4.."|"..id5.."|"..id6.."|"..id7.."|"..table.concat(gradeData, ",").."|"..tostring(page))
    end
    return 1
end
function Module:SwitchExecute(fd,head,data)
    local player = tonumber(Protocol.GetCharByFd(fd))
    if head == 'SwitchLocked' then
      local mainSlot = tonumber(data[1]);
      if not mainSlot then return end

      local petIndex = Char.GetPet(player, mainSlot-1);
      if petIndex <= 0 then
        Protocol.Send(player,'ResponsePetCultivationData',"0|0|0|0|0|0|0|0,0,0,0,0,0,0,0,0,0|"..tostring(page))
        return
      end
      local locked = Char.GetExtData(petIndex, '吸收锁定') or 0;
      if locked==0 then
          Char.SetExtData(petIndex, '吸收锁定', 1);
      elseif locked==1 then
          Char.SetExtData(petIndex, '吸收锁定', 0);
      end
      Pet.UpPet(player, petIndex);

      local id1 = mainSlot;
      local id2 = Char.GetData(petIndex,CONST.对象_原名);			--PetName
      local id3,id5 = GetCultivationData(player,petIndex);		--cultivationExp, cultivationCount
	  local id4 = GetCultivationExpNeed(id5);					--expNeed
	  local id6 = IsPetCultivationMaxed(petIndex) and 1 or 0;	--maxed
	  local id7 = IsPetProtectLocked(player, petIndex);			--locked
	  --寵物目前檔次與最高檔次
	  local gradeData = {}
	  for _, gradeType in ipairs(PET_GRADE_TYPES) do
        local currentRank = Pet.GetArtRank(petIndex,gradeType);
        local fullRank = Pet.FullArtRank(petIndex,gradeType);
        table.insert(gradeData,tostring(currentRank));
        table.insert(gradeData,tostring(fullRank));
      end
      Protocol.Send(player,'ResponsePetCultivationData', id1.."|"..id2.."|"..id3.."|"..id4.."|"..id5.."|"..id6.."|"..id7.."|"..table.concat(gradeData, ",").."|"..tostring(page))
    end
    return 1
end
function Module:material_SendData(fd,head,data)
    local player = tonumber(Protocol.GetCharByFd(fd))
    if head == 'GetMaterialPet' then
      local mainSlot = tonumber(data[1]);
      if not mainSlot then return end

      local petIndex = Char.GetPet(player, mainSlot-1);
      if petIndex <= 0 then
        Protocol.Send(player,'ResponseMaterialPetData',"0,0|0,0|0,0|0,0|0,0")
        return
      end
      local PetId = Char.GetData(petIndex,CONST.宠物_PETID);
      local material_List,locked_List = GetMaterialPet(player,PetId,mainSlot);
      -- 保護鎖定
      Protocol.Send(player,'ResponseLockedPetData', locked_List[1].."|"..locked_List[2].."|"..locked_List[3].."|"..locked_List[4].."|"..locked_List[5])
      -- 名字、等級
      local pack = material_List[1] .."," ..material_List[2] .."|"
                .. material_List[3] .."," ..material_List[4] .."|"
                .. material_List[5] .."," ..material_List[6] .."|"
                .. material_List[7] .."," ..material_List[8] .."|"
                .. material_List[9] .."," ..material_List[10]
      Protocol.Send(player,'ResponseMaterialPetData', pack)
    end
    return 1
end

-- 執行寵物吸收
function Module:ExecuteCultivation(fd, head, data)
    local player = tonumber(Protocol.GetCharByFd(fd))
    if head ~= 'ExecutePetCultivation' then
        return 1
    end

    local arr = {}
    for slot in string.gmatch(data[1], "[^|]+") do
        local arrslot = tostring(slot)
        if arrslot then
            table.insert(arr, arrslot);
        end
    end
    if not arr or not arr[1] then
        return 1
    end
    --------------------------------------------------
    -- 1. 解析主寵
    --------------------------------------------------
    local mainSlot = tonumber(arr[1])
    if not mainSlot then
        return 1
    end
    local mainPetIndex = Char.GetPet(player, mainSlot-1);
    if mainPetIndex <= 0 then
        return 1
    end
    --------------------------------------------------
    -- 2. 解析材料 Slot
    --------------------------------------------------
    local materialString = arr[2] or ""
    local materialSlots = {}
    for slot in string.gmatch(materialString, "[^,]+") do
        local materialSlot = tonumber(slot)
        if materialSlot then
            table.insert(materialSlots, materialSlot);
        end
    end
    if #materialSlots <= 0 then
        return 1
    end
    --------------------------------------------------
    -- 3. 驗證材料寵物
    --------------------------------------------------
    local mainPetId = Char.GetData(mainPetIndex,CONST.宠物_PETID);
    local materialPets = {}
    for _, materialSlot in ipairs(materialSlots) do
        -- 不允許材料 = 主寵
        if materialSlot == mainSlot then
            return 1
        end
        local materialPetIndex = Char.GetPet(player,materialSlot-1);
        if materialPetIndex <= 0 then
            return 1
        end
        -- 檢查材料寵物是否被保護鎖定
        local materialLocked = Char.GetExtData(materialPetIndex, '吸收锁定') or 0
        if tonumber(materialLocked) == 1 then
            NLG.SystemMessage(player, "[系統] 鎖定的寵物不能作為材料。")
            return 1
        end

        local materialPetId = Char.GetData(materialPetIndex, CONST.宠物_PETID)
        -- 必須與主寵相同 PETID
        if materialPetId ~= mainPetId then
            NLG.SystemMessage(player, "[系統] 勾選名單內有不同名稱的寵物。");
            return 1
        end
        table.insert(materialPets, {slot = materialSlot,index = materialPetIndex})
    end
    --------------------------------------------------
    -- 4. 計算培養 EXP
    --------------------------------------------------
    local totalExp = GetMaterialPetsCultivationExp(materialPets);
    --------------------------------------------------
    -- 5. 取得目前培養資料
    --------------------------------------------------
    local currentExp, cultivationCount = GetCultivationData(player, mainPetIndex);
    local expNeed = GetCultivationExpNeed(cultivationCount);
    --------------------------------------------------
    -- 6. 增加 EXP
    --------------------------------------------------
    currentExp = currentExp + totalExp;
    --------------------------------------------------
    -- 7. 達標就增加資質
    --------------------------------------------------
    for count = 1,#materialPets do
        if currentExp >= expNeed then
            currentExp = currentExp - expNeed;
            cultivationCount = cultivationCount + 1;
            local success = IncreaseRandomGrade(player,mainPetIndex);	-- 8. 升檔及寫回培養資料
        end
        expNeed = GetCultivationExpNeed(cultivationCount);
        Char.SetExtData(mainPetIndex,"吸收经验",currentExp);
        Char.SetExtData(mainPetIndex,"吸收次数",cultivationCount);
        NLG.UpChar(mainPetIndex);
        NLG.UpChar(player);
    end
    --------------------------------------------------
    -- 9. 消耗材料寵物
    --------------------------------------------------
    table.sort(materialSlots, function(a, b)
        return a > b
    end)
    for _, materialSlot in ipairs(materialSlots) do
        Char.DelSlotPet(player, materialSlot-1);
    end
    --------------------------------------------------
    -- 10. 重新同步主寵資料
    --------------------------------------------------
    local id1 = mainSlot;
    local id2 = Char.GetData(mainPetIndex,CONST.对象_原名);			--PetName
    local id3,id5 = GetCultivationData(player,mainPetIndex);		--cultivationExp, cultivationCount
    local id4 = GetCultivationExpNeed(id5);						--expNeed
	local id6 = IsPetCultivationMaxed(mainPetIndex) and 1 or 0;	--maxed
	local id7 = IsPetProtectLocked(player, mainPetIndex);			--locked

	local gradeData = {}										--寵物目前檔次與最高檔次
	for _, gradeType in ipairs(PET_GRADE_TYPES) do
        local currentRank = Pet.GetArtRank(mainPetIndex,gradeType);
        local fullRank = Pet.FullArtRank(mainPetIndex,gradeType);
        table.insert(gradeData,tostring(currentRank));
        table.insert(gradeData,tostring(fullRank));
    end
    Protocol.Send(player,'ResponsePetCultivationData', id1.."|"..id2.."|"..id3.."|"..id4.."|"..id5.."|"..id6.."|"..id7.."|"..table.concat(gradeData, ",").."|1")
    return 1
end

-- 執行寵物突破
function Module:ExecutePetBreakthrough(fd, head, data)
    if head ~= 'ExecutePetBreakthrough' then
        return 1
    end
    local player = tonumber(Protocol.GetCharByFd(fd))
    if not player or player < 0 then
        return 1
    end
    if not data or not data[1] then
        return 1
    end
    ------------------------------------------------
    -- 1. 解析：
    -- 寵物欄位|18310,18312
    ------------------------------------------------
    local packet = data[1]
    local splitData = {}
    for value in string.gmatch(packet, "[^|]+") do
        table.insert(splitData, value)
    end
    local petSlot = tonumber(splitData[1])
    if not petSlot then
        NLG.SystemMessage(player, "[系統] 寵物欄位無效")
        return 1
    end
    ------------------------------------------------
    -- 2. 取得寵物
    ------------------------------------------------
    if petSlot < 1 or petSlot > 5 then
        NLG.SystemMessage(player, "[系統] 寵物欄位無效")
        return 1
    end
    local petIndex = Char.GetPet(player, petSlot - 1)
    if not petIndex or petIndex <= 0 then
        NLG.SystemMessage(player, "[系統] 找不到指定寵物")
        return 1
    end
    ------------------------------------------------
    -- 3. 解析水晶
    ------------------------------------------------
    local crystalString = splitData[2] or ""
    local crystalIds = {}
    for value in string.gmatch(crystalString, "[^,]+") do
        local crystalId = tonumber(value)
        if not crystalId then
            NLG.SystemMessage(player, "[系統] 水晶資料錯誤")
            return 1
        end
        table.insert(crystalIds, crystalId)
    end
    ------------------------------------------------
    -- 4. 必須選 2～3 種
    ------------------------------------------------
    if #crystalIds < 2 or #crystalIds > 3 then
        NLG.SystemMessage(player, "[系統] 必須選擇 2～3 種水晶")
        return 1
    end
    ------------------------------------------------
    -- 5. 不允許重複水晶
    ------------------------------------------------
    local crystalUsed = {}
    for _, crystalId in ipairs(crystalIds) do
        if crystalUsed[crystalId] then
            NLG.SystemMessage(player, "[系統] 不可重複選擇水晶")
            return 1
        end
        crystalUsed[crystalId] = true
        if not BREAKTHROUGH_CRYSTALS[crystalId] then
            NLG.SystemMessage(player, "[系統] 未知的水晶")
            return 1
        end
    end
    ------------------------------------------------
    -- 6. 取得合法配方
    ------------------------------------------------
    local recipeKey = GetBreakthroughRecipeKey(crystalIds)
    if not recipeKey then
        NLG.SystemMessage(player, "[系統] 無效的水晶組合")
        return 1
    end
    local recipe = BREAKTHROUGH_RECIPES[recipeKey]
    if not recipe then
        NLG.SystemMessage(player, "[系統] 此水晶組合不存在")
        return 1
    end
    ------------------------------------------------
    -- 7. 五項能力必須全部滿檔
    ------------------------------------------------
    for i = 1, 5 do
        local gradeType = PET_GRADE_TYPES[i]
        local currentRank =
            tonumber(Pet.GetArtRank(petIndex, gradeType)) or 0
        local fullRank =
            tonumber(Pet.FullArtRank(petIndex, gradeType)) or 0
        if currentRank < fullRank then
            NLG.SystemMessage(player, "[系統] 寵物五項能力尚未全部滿檔")
            return 1
        end
    end
    ------------------------------------------------
    -- 8. 計算目前總檔次
    ------------------------------------------------
    local totalRank = 0
    for i = 1, 5 do
        local gradeType = PET_GRADE_TYPES[i]
        totalRank = totalRank + (tonumber(Pet.GetArtRank(petIndex, gradeType)) or 0)
    end
    ------------------------------------------------
    -- 9. 總檔次限制
    ------------------------------------------------
    if totalRank < 110 then
        NLG.SystemMessage(player, "[系統] 寵物總檔次不足110")
        return 1
    end
    if totalRank >= 170 then
        NLG.SystemMessage(player, "[系統] 寵物總檔次已達"..BREAKTHROUGH_MAX_RANK)
        return 1
    end
    local breakthroughCount = #recipe
    if not IsBreakthroughAmountAllowed(totalRank, breakthroughCount) then
        NLG.SystemMessage(player, "[系統] 請選擇+2或+3刻印文字以符合"..BREAKTHROUGH_MAX_RANK.."上限")
        return 1
    end
    ------------------------------------------------
    -- 10. 計算每種水晶需求
    ------------------------------------------------
    local crystalCost = GetBreakthroughCrystalCost(totalRank)
    if not crystalCost then
        NLG.SystemMessage(player, "[系統] 無法計算水晶需求")
        return 1
    end
    ------------------------------------------------
    -- 11. 檢查所有水晶數量
    ------------------------------------------------
    for _, crystalId in ipairs(crystalIds) do
        local itemCount = tonumber(Char.ItemNum(player, crystalId)) or 0
        if itemCount < crystalCost then
            NLG.SystemMessage(player,"[系統] 水晶碎片不足，每種碎片都需要："..tostring(crystalCost))
            return 1
        end
    end
    ------------------------------------------------
    -- 12. 再次確認所有條件後，開始扣除水晶
    ------------------------------------------------
    for _, crystalId in ipairs(crystalIds) do
        Char.DelItem(player, crystalId, crystalCost);
    end
    ------------------------------------------------
    -- 13. 套用突破屬性
    ------------------------------------------------
    for _, statIndex in ipairs(recipe) do
        local gradeType = PET_GRADE_TYPES[statIndex]
        local currentRank = tonumber(Pet.GetArtRank(petIndex, gradeType)) or 0
        Pet.SetArtRank(petIndex, gradeType, currentRank + 1);
    end
    ------------------------------------------------
    -- 14. 更新寵物
    ------------------------------------------------
    Pet.UpPet(player, petIndex);
    SetNonLv1PetRebirth(player, petIndex);
    ------------------------------------------------
    -- 15. 回傳系統訊息
    ------------------------------------------------
    local engraved = BREAKTHROUGH_RECIPE_NAMES[recipeKey];
    NLG.SystemMessage(player,"[系統] 寵物突破成功！刻印文字《"..engraved.."》")
    ------------------------------------------------
    -- 16. 回傳最新培養資料
    ------------------------------------------------
    local id1 = petSlot;
    local id2 = Char.GetData(petIndex,CONST.对象_原名);
    local id3, id5 = GetCultivationData(player, petIndex);
    local id4 = GetCultivationExpNeed(id5);
    local id6 = IsPetCultivationMaxed(petIndex) and 1 or 0;
    local id7 = IsPetProtectLocked(player, petIndex);

    local gradeData = {}
    for _, gradeType in ipairs(PET_GRADE_TYPES) do
        local currentRank = Pet.GetArtRank(petIndex, gradeType);
        local fullRank = Pet.FullArtRank(petIndex, gradeType);
        table.insert(gradeData, tostring(currentRank))
        table.insert(gradeData, tostring(fullRank))
    end
    Protocol.Send(player,'ResponsePetCultivationData', id1.."|"..id2.."|"..id3.."|"..id4.."|"..id5.."|"..id6.."|"..id7.."|"..table.concat(gradeData, ",").."|2")
    return 1
end
-- 回傳寵物技能清單
function Module:SendPetSkillData(fd, head, data)
    if head ~= "RequestPetSkillData" then
        return 1
    end

    local player = tonumber(Protocol.GetCharByFd(fd))
    if not player or player < 0 then
        return 1
    end

    local packetData = BuildPetSkillDataString()
    Protocol.Send(player,"ResponsePetSkillData",packetData)
    return 1
end

-- 執行學習寵物技能
function Module:LearnPetSkill(fd, head, data)
    if head ~= "LearnPetSkill" then
        return 1
    end
    local player = tonumber(Protocol.GetCharByFd(fd))
    if not player or player < 0 or not data or not data[1] then
        return 1
    end

    -- 封包格式：寵物欄位|techId
    local packet = {}
    for value in string.gmatch(data[1], "[^|]+") do
        table.insert(packet, value)
    end
    local petSlot = tonumber(packet[1]);
    local MactechId = tonumber(packet[2]);

    if not petSlot or petSlot < 1 or petSlot > 5
        or not MactechId or MactechId <= 0 then
        return 1
    end
    local petIndex = Char.GetPet(player, petSlot - 1);
    if not petIndex or petIndex <= 0 then
        NLG.SystemMessage(player, "[系統]找不到指定的寵物！");
        return 1
    end

    -- 查找技能資料
    local skillData = nil
    for _, skill in ipairs(PET_SKILL_DATA) do
        if tonumber(skill.techId) == MactechId then
            skillData = skill
            break
        end
    end
    if not skillData then
        NLG.SystemMessage(player, "[系統]找不到指定的技能資料！");
        return 1
    end

    -- 後端重新檢查檔次，避免只靠前端判斷
    local gradeIndex = tonumber(skillData.gradeIndex) or 0
    local requiredGrade = tonumber(skillData.gradeValue) or 0
    if gradeIndex < 1 or gradeIndex > 5 then
        return 1
    end
    local gradeType = PET_GRADE_TYPES[gradeIndex]
    local currentGrade = tonumber(Pet.GetArtRank(petIndex, gradeType)) or 0
    if currentGrade < requiredGrade then
        NLG.SystemMessage(player, "[系統]寵物的檔次不足，無法學習此技能！");
        return 1
    end
    -- 後端重新檢查等級，避免只靠前端判斷
    local requiredLevel = tonumber(skillData.levelLimit) or -1
    local currentLevel = Char.GetData(petIndex,CONST.对象_等级);
    if currentLevel < requiredLevel then
        NLG.SystemMessage(player, "[系統]寵物的等級不足，無法學習此技能！");
        return 1
    end
    -- 後端重新檢查寵物Id，避免只靠前端判斷
    local requiredPetId = tonumber(skillData.petID) or -1
    local currentPetId = Char.GetData(petIndex,CONST.宠物_PETID);
    if (requiredPetId ~= -1 and currentPetId ~= requiredPetId) then
        NLG.SystemMessage(player, "[系統]寵物資格不符，無法學習此技能！");
        return 1
    end

    -- 判定有無重複技能，並尋找第一個空技能欄位
    for i = 0, 9 do
        local petskill = Pet.GetSkill(petIndex, i);
        if tonumber(petskill) == MactechId then
            NLG.SystemMessage(player, "[系統]寵物已學習過此招式！");
            return 1
        end
    end
    if Char.GetSkillNum(petIndex)==Char.GetData(petIndex, CONST.对象_技能栏) then
        NLG.SystemMessage(player, "[系統]寵物技能欄位已滿，無法學習！");
        return 1
    end
    -- 確認招式存在
    local techIndex = Tech.GetTechIndex(MactechId);
    if not techIndex or techIndex <= 0 then
        NLG.SystemMessage(player, "[系統]找不到此招式的資料！");
        return 1
    end

    -- 學習技能：空欄位直接新增，不覆蓋既有技能
    Pet.AddSkill(petIndex, MactechId);
    Pet.UpPet(player, petIndex);
    NLG.UpChar(player);

    local techName = Tech.GetData(techIndex, CONST.TECH_NAME);
    NLG.SystemMessage(player,"[系統]寵物成功學會「" .. tostring(techName or skillData.name) .. "」！");
    return 1
end

------------------------------------------------
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')

  -- 註冊 UI 封包請求
  self:regCallback('ProtocolOnRecv',Func.bind(self.SendData,self),'RequestPetCultivationData')	--前端索求遊戲數據
  self:regCallback('ProtocolOnRecv',Func.bind(self.SwitchExecute,self),'SwitchLocked')
  self:regCallback('ProtocolOnRecv',Func.bind(self.material_SendData,self),'GetMaterialPet')
  self:regCallback('ProtocolOnRecv',Func.bind(self.ExecuteCultivation,self),'ExecutePetCultivation')
  self:regCallback('ProtocolOnRecv',Func.bind(self.ExecutePetBreakthrough,self),'ExecutePetBreakthrough')
  self:regCallback('ProtocolOnRecv',Func.bind(self.SendPetSkillData, self),'RequestPetSkillData')
  self:regCallback('ProtocolOnRecv',Func.bind(self.LearnPetSkill, self),'LearnPetSkill')

end

----------------------
-- 回傳寵物欄所有寵物及判斷是否同名(enemyid)
function GetMaterialPet(charIndex,enemyid,mainSlot)
  local MaterialPetData = {}
  local LockedPetData = {}
  for Slot=1,5 do
      local PetIndex = Char.GetPet(charIndex, Slot-1);
      if (PetIndex > 0 and Slot ~= mainSlot) then
          local MPetId = Char.GetData(PetIndex,CONST.宠物_PETID);
          --print(PetIndex,enemyid,MPetId);
          if (enemyid==MPetId) then
              table.insert(MaterialPetData,tostring(Char.GetData(PetIndex,CONST.对象_原名)));
              table.insert(MaterialPetData,tostring(Char.GetData(PetIndex,CONST.对象_等级)));
              table.insert(LockedPetData,tostring(Char.GetExtData(PetIndex,'吸收锁定') or 0));
          else
              table.insert(MaterialPetData,tostring(Char.GetData(PetIndex,CONST.对象_原名)));
              table.insert(MaterialPetData,"_");
              table.insert(LockedPetData,tostring(Char.GetExtData(PetIndex,'吸收锁定') or 0));
          end
      elseif (PetIndex > 0 and Slot == mainSlot) then
          table.insert(MaterialPetData,"主寵物");
          table.insert(MaterialPetData,tostring(Char.GetData(PetIndex,CONST.对象_等级)));
          table.insert(LockedPetData,tostring(Char.GetExtData(PetIndex,'吸收锁定') or 0));
      elseif (PetIndex < 0) then
          table.insert(MaterialPetData,"空");
          table.insert(MaterialPetData,"_");
          table.insert(LockedPetData,"_");
      end
  end
  return MaterialPetData,LockedPetData;
end
-- 寵物檔次改變後重生
function SetNonLv1PetRebirth(player, petIndex)
    local Level = Char.GetData(petIndex,CONST.对象_等级);
    local arr_rank1_new = Pet.GetArtRank(petIndex,CONST.PET_体成);
    local arr_rank2_new = Pet.GetArtRank(petIndex,CONST.PET_力成);
    local arr_rank3_new = Pet.GetArtRank(petIndex,CONST.PET_强成);
    local arr_rank4_new = Pet.GetArtRank(petIndex,CONST.PET_敏成);
    local arr_rank5_new = Pet.GetArtRank(petIndex,CONST.PET_魔成);
    if(Level>=1) then
        Char.SetData(petIndex,CONST.对象_升级点,Level-1);
        Char.SetData(petIndex,CONST.对象_等级,Level);
        Char.SetData(petIndex,CONST.对象_体力, (Char.GetData(petIndex,CONST.对象_体力) + (arr_rank1_new * (1/24) * (Level - 1)*100)) );
        Char.SetData(petIndex,CONST.对象_力量, (Char.GetData(petIndex,CONST.对象_力量) + (arr_rank2_new * (1/24) * (Level - 1)*100)) );
        Char.SetData(petIndex,CONST.对象_强度, (Char.GetData(petIndex,CONST.对象_强度) + (arr_rank3_new * (1/24) * (Level - 1)*100)) );
        Char.SetData(petIndex,CONST.对象_速度, (Char.GetData(petIndex,CONST.对象_速度) + (arr_rank4_new * (1/24) * (Level - 1)*100)) );
        Char.SetData(petIndex,CONST.对象_魔法, (Char.GetData(petIndex,CONST.对象_魔法) + (arr_rank5_new * (1/24) * (Level - 1)*100)) );
        Pet.UpPet(player,petIndex);
        return
    elseif(Level<1) then
        return
    end
end
----------------------
-- 取得培養保護鎖定
function IsPetProtectLocked(player, petIndex)
    local locked = Char.GetExtData(petIndex, '吸收锁定') or 0;
    return locked
end
-- 取得培養資料
function GetCultivationData(player, petIndex)
    local exp = Char.GetExtData(petIndex, '吸收经验') or 0;
    local count = Char.GetExtData(petIndex, '吸收次数') or 0;
    return exp, count
end
-- 計算下一階需求 EXP
function GetCultivationExpNeed(cultivationCount)
    local cultivationCount = tonumber(cultivationCount) or 0
    local expNeed = FIRST_EXP_NEED * (EXP_GROWTH_RATE ^ cultivationCount)
    return math.floor(expNeed)
end
-- 判斷五項品階是否已經全部滿階
function IsPetCultivationMaxed(petIndex)
    if not petIndex or petIndex <= 0 then
        return true
    end
    for _, gradeType in ipairs(PET_GRADE_TYPES) do
        local currentRank = tonumber(Pet.GetArtRank(petIndex,gradeType)) or 0;
        local fullRank = tonumber(Pet.FullArtRank(petIndex,gradeType)) or 0;
        if currentRank < fullRank then
            return false
        end
    end
    return true
end
-- 取得尚未滿階的品階
function GetAvailableGrades(petIndex)
    local result = {};
    for gradeIndex, gradeType in ipairs(PET_GRADE_TYPES) do
        local currentRank = tonumber(Pet.GetArtRank(petIndex,gradeType)) or 0;
        local fullRank = tonumber(Pet.FullArtRank(petIndex,gradeType)) or 0;
        if currentRank < fullRank then
            table.insert(result, {index = gradeIndex,type = gradeType,current = currentRank,full = fullRank})
        end
    end
    return result
end
-- 隨機提升一項品階
function IncreaseRandomGrade(player, petIndex)
    local availableGrades = GetAvailableGrades(petIndex);
    if #availableGrades <= 0 then
        return false, 0, 0, 0
    end
    local randomIndex = NLG.Rand(1, #availableGrades);
    local selected = availableGrades[randomIndex];
    local oldRank = selected.current;
    local newRank = oldRank + 1;
    if newRank > selected.full then
        newRank = selected.full;
    end
    Pet.SetArtRank(petIndex,selected.type,newRank);
    Pet.ReBirth(player, petIndex);
    Pet.UpPet(player, petIndex);

    SetNonLv1PetRebirth(player, petIndex);	--重生計算寵物能力
    return true,selected.index,oldRank,newRank
end
-- 計算培養經驗
function GetMaterialPetCultivationExp(petLevel)
    petLevel = tonumber(petLevel) or 0
    if petLevel <= 0 then
        return 0
    end
    if petLevel >= 100 then
        return 0
    end
    local decreaseStep = math.floor((petLevel - 1) / 5)
    local exp = SACRIFICE_PET_EXP - decreaseStep * 5
    if exp < 0 then
        exp = 0
    end
    return exp
end
-- 加總所有材料的培養經驗
function GetMaterialPetsCultivationExp(materialPets)
    local totalExp = 0
    for _, materialPet in ipairs(materialPets or {}) do
        local petLevel = Char.GetData(materialPet.index,CONST.对象_等级);
        totalExp = totalExp + GetMaterialPetCultivationExp(petLevel)
    end
    return totalExp
end
----------------------
-- 取得突破水晶碎片消耗量
function GetBreakthroughCrystalCost(totalRank)
    totalRank = tonumber(totalRank) or 0
    for _, data in ipairs(BREAKTHROUGH_CRYSTAL_COST) do
        if totalRank >= data.min and totalRank <= data.max then
            return data.cost
        end
    end
    return nil
end
-- 取得突破配方 Key
function GetBreakthroughRecipeKey(crystalIds)
    local indexes = {}
    for _, crystalId in ipairs(crystalIds) do
        local index = BREAKTHROUGH_CRYSTALS[crystalId]
        if not index then
            return nil
        end
        table.insert(indexes, index)
    end
    table.sort(indexes)
    return table.concat(indexes, ",")
end
-- 突破增加數值合法性檢測
function IsBreakthroughAmountAllowed(totalRank, amount)
    totalRank = tonumber(totalRank) or 0
    amount = tonumber(amount) or 0
    if not BREAKTHROUGH_AMOUNTS[amount] then
        return false
    end
    local remain = BREAKTHROUGH_MAX_RANK - totalRank
    if remain <= 0 then
        return false
    end
    if amount > remain then
        return false
    end
    local remainAfter = remain - amount
    if remainAfter == 1 then
        return false
    end
    return true
end
----------------------
--產生寵物技能列表封包字串-技能名稱,檔次索引,檔次門檻,等級限制,PETID 多筆技能使用 ; 分隔
function BuildPetSkillDataString()
    local result = {}

    for _, skill in ipairs(PET_SKILL_DATA) do
        local skillName = tostring(skill.name or "")
        local techId = tonumber(skill.techId) or 0
        local gradeIndex = tonumber(skill.gradeIndex) or 0
        local gradeValue = tonumber(skill.gradeValue) or 0
        local levelLimit = tonumber(skill.levelLimit) or -1
        local petID = tonumber(skill.petID) or -1

        local skillData = table.concat({skillName,tostring(techId),tostring(gradeIndex),tostring(gradeValue),tostring(levelLimit),tostring(petID),}, ",")
        table.insert(result, skillData)
    end

    return table.concat(result, "|")
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