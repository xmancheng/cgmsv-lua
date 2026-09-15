---模块类
local Module = ModuleBase:createModule('petCultivation')

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
-- 客戶端封包通訊同步
--------------------------------------------------
function Module:SendData(fd,head,data)
    local player = tonumber(Protocol.GetCharByFd(fd))
    if head == 'RequestPetCultivationData' then
      local petSlot = tonumber(data[1]);
      if not petSlot then return end

      local petIndex = Char.GetPet(player, petSlot-1);
      if petIndex <= 0 then
        Protocol.Send(player,'ResponsePetCultivationData',"0|0|0|0|0|0|0,0,0,0,0,0,0,0,0,0")
        return
      end

      local id1 = petSlot;
      local id2 = Char.GetData(petIndex,CONST.对象_原名);			--PetName
      local id3,id5 = GetCultivationData(player,petIndex);		--cultivationExp, cultivationCount
	  local id4 = GetCultivationExpNeed(id5);					--expNeed
	  local id6 = IsPetCultivationMaxed(petIndex) and 1 or 0;	--maxed

	  local gradeData = {}										--寵物目前檔次與最高檔次
	  for _, gradeType in ipairs(PET_GRADE_TYPES) do
        local currentRank = Pet.GetArtRank(petIndex,gradeType);
        local fullRank = Pet.FullArtRank(petIndex,gradeType);
        table.insert(gradeData,tostring(currentRank));
        table.insert(gradeData,tostring(fullRank));
      end
      Protocol.Send(player,'ResponsePetCultivationData', id1.."|"..id2.."|"..id3.."|"..id4.."|"..id5.."|"..id6.."|"..table.concat(gradeData, ","))
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
        Protocol.Send(player,'ResponseMaterialPetData',"0|0|0|0|0")
        return
      end
      local PetId = Char.GetData(petIndex,CONST.宠物_PETID);
      local material_List = GetMaterialPet(player,PetId,mainSlot);
      local pack = material_List[1] .."," ..material_List[2] .."|"
                .. material_List[3] .."," ..material_List[4] .."|"
                .. material_List[5] .."," ..material_List[6] .."|"
                .. material_List[7] .."," ..material_List[8] .."|"
                .. material_List[9] .."," ..material_List[10]
      Protocol.Send(player,'ResponseMaterialPetData', pack)
    end
    return 1
end

function Module:ExecuteCultivation(fd, head, data)
    local player = tonumber(Protocol.GetCharByFd(fd))
    if head ~= "ExecutePetCultivation" then
        return 1
    end
    if not data or not data[1] then
        return 1
    end
    --------------------------------------------------
    -- 1. 解析主寵
    --------------------------------------------------
    local mainSlot = tonumber(data[1])
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
    local materialString = data[2] or ""
    local materialSlots = {}
    for slot in string.gmatch(materialString, "[^,]+") do
        local materialSlot = tonumber(slot)
        if materialSlot then
            table.insert(materialSlots, materialSlot)
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
    local totalExp = #materialPets * SACRIFICE_PET_EXP
    --------------------------------------------------
    -- 5. 取得目前培養資料
    --------------------------------------------------
    local currentExp, cultivationCount = GetCultivationData(player, mainPetIndex)
    currentExp = tonumber(currentExp) or 0
    cultivationCount = tonumber(cultivationCount) or 0
    local expNeed = GetCultivationExpNeed(cultivationCount)
    --------------------------------------------------
    -- 6. 增加 EXP
    --------------------------------------------------
    currentExp = currentExp + totalExp
    --------------------------------------------------
    -- 7. 達標就增加資質
    --------------------------------------------------
    while currentExp >= expNeed do
        currentExp = currentExp - expNeed
        local success = IncreaseRandomGrade(player,mainPetIndex)
        if not success then
            currentExp = 0
            break
        end
        cultivationCount = cultivationCount + 1;
        expNeed = GetCultivationExpNeed(cultivationCount)
    end
    --------------------------------------------------
    -- 8. 寫回培養資料
    --------------------------------------------------
    Char.SetExtData(mainPetIndex,"吸收经验",currentExp);
    Char.SetExtData(mainPetIndex,"吸收次数",cultivationCount);
    --------------------------------------------------
    -- 9. 消耗材料寵物
    --------------------------------------------------

    -- 這裡先不要直接照抄 API
    -- 請使用你目前伺服器實際的「刪除寵物」API。
    --
    -- 因為目前提供給我的 petCultivation.lua
    -- 沒有出現刪除寵物的既有 API，
    -- 所以這裡不能憑空指定 Char.DelPet / Char.RemovePet 等名稱。

    --------------------------------------------------
    -- 10. 重新同步主寵資料
    --------------------------------------------------
    Protocol.Send(player,"ResponsePetCultivationData",...)
    return 1
end

------------------------------------------------
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')

  -- 註冊 UI 封包請求
  self:regCallback('ProtocolOnRecv',Func.bind(self.SendData,self),'RequestPetCultivationData')	--前端索求遊戲數據
  self:regCallback('ProtocolOnRecv',Func.bind(self.material_SendData,self),'GetMaterialPet')
  self:regCallback('ProtocolOnRecv',Func.bind(self.ExecuteCultivation,self),'ExecutePetCultivation')

end

-- 回傳寵物欄所有寵物及判斷是否同名(enemyid)
function GetMaterialPet(charIndex,enemyid,mainSlot)
  local MaterialPetData = {}
  for Slot=1,5 do
      local PetIndex = Char.GetPet(charIndex, Slot-1);
      if (PetIndex > 0 and Slot ~= mainSlot) then
          local MPetId = Char.GetData(PetIndex,CONST.宠物_PETID);
          --print(PetIndex,enemyid,MPetId);
          if (enemyid==MPetId) then
              table.insert(MaterialPetData,tostring(Char.GetData(PetIndex,CONST.对象_原名)));
              table.insert(MaterialPetData,tostring(Char.GetData(PetIndex,CONST.对象_等级)));
          else
              table.insert(MaterialPetData,"不符合");
              table.insert(MaterialPetData,"_");
          end
      elseif (PetIndex >= 0 and Slot == mainSlot) then
          table.insert(MaterialPetData,"主寵物");
          table.insert(MaterialPetData,tostring(Char.GetData(PetIndex,CONST.对象_等级)));
      elseif (PetIndex < 0) then
          table.insert(MaterialPetData,"空");
          table.insert(MaterialPetData,"_");
      end
  end
  return MaterialPetData;
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
    Pet.SetArtRank(petIndex,selected.type,newRank)
    return true,selected.index,oldRank,newRank
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