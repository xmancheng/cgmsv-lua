local Module = ModuleBase:createModule('phySlot')

-- 重新定義 4 個核心部位
local ItemPosName = {"頭 部", "身 体", "手 部", "足 部"}
-- 0:頭, 1:身, 2:右, 3:左, 4:足
local SlotMapping = {
    [1] = {0},       -- 頭部對應 Slot 0
    [2] = {1},       -- 身體對應 Slot 1
    [3] = {2, 3},    -- 手部對應 Slot 2(右) 和 3(左)
    [4] = {4}        -- 足部對應 Slot 4
}

local MaxLv = 999
local MaxExp = 9999
local energy = 75038	--能量道具編號
---------------------------------------------------------------------
-- K曲線計算函數
---------------------------------------------------------------------
-- 等級轉經驗門檻 (用於判斷升級)
function GetExpByLv(lv)
    if lv <= 1 then return 10 end
    -- 將中心點 (m) 設為 400，k 設為 0.008
    -- 這會讓 1-200 級非常輕鬆，400 級後經驗需求開始明顯增加，高等級逼近 9999
    return math.floor(MaxExp / (1 + math.exp(-0.008 * (lv - 400))))
end

-- 等級轉屬性加成係數 (取代原本的石板+等級公式)
-- 這裡設計一個 K 曲線，讓 Lv 999 時達到預設的最大加成
function GetRateByLv(lv, isHPMP)
    local baseRate = lv / MaxLv
    -- K曲線：f(x) = x / (1 + (1-x)*k) ，k值越高曲線越早抬升
    local k = 3.5 
    local curve = baseRate / (1 + (1 - baseRate) * k)
    
    if isHPMP then
        return curve * 0.4 -- 假設血魔最大加成 40%
    else
        return curve * 0.25 -- 假設攻防敏最大加成 25%
    end
end

--------------------------------------------------------------------
-- UI 顯示
function Module:phySlotInfo(npc, player)
    local winMsg = "3\\n　　　　　　　　【角色核心訓練】\\n"
                     .."　　部位　　等級　　經驗值　　加成(攻/血)\\n"
                     .."--------------------------------------\\n"
    for i = 1, #ItemPosName do
        local tStrLv = tonumber(PhySlotStat(player, ItemPosName[i], "Q"));
        local tStrExp = tonumber(PhySlotStat(player, ItemPosName[i], "V"));
        if (tStrLv==nil) then
            PhySlotStat(player, ItemPosName[i], "Q", 0);
            PhySlotStat(player, ItemPosName[i], "V", 0);
        end
        local rateB = math.floor(GetRateByLv(tStrLv, false) * 100)
        local rateH = math.floor(GetRateByLv(tStrLv, true) * 100)
        
        winMsg = winMsg .."　".. ItemPosName[i] .. "   [Lv." .. tStrLv .. "]　" 
                        .. tStrExp .. "　　(" .. rateB .. "%/" .. rateH .. "%)\n"
    end
    NLG.ShowWindowTalked(player, self.phySloterNPC, CONST.窗口_选择框, CONST.按钮_关闭, 1, winMsg);
end

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('ItemAttachEvent', Func.bind(self.itemAttachCallback, self))
  self:regCallback('ItemDetachEvent', Func.bind(self.itemDetachCallback, self))

  self.phySloterNPC = self:NPC_createNormal('裝備插槽管理', 14682, { x =36 , y = 31, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.phySloterNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
          local winMsg = "3\\n　　　　　　　　【角色核心訓練】\\n"
                           .."　　部位　　等級　　經驗值　　加成(攻/血)\\n"
                           .."--------------------------------------\\n"
          for i = 1, #ItemPosName do
              local tStrLv = tonumber(PhySlotStat(player, ItemPosName[i], "Q"));
              local tStrExp = tonumber(PhySlotStat(player, ItemPosName[i], "V"));
              if (tStrLv==nil) then
                  PhySlotStat(player, ItemPosName[i], "Q", 0);
                  PhySlotStat(player, ItemPosName[i], "V", 0);
              end
              local rateB = math.floor(GetRateByLv(tStrLv, false) * 100)
              local rateH = math.floor(GetRateByLv(tStrLv, true) * 100)
        
              winMsg = winMsg .."　".. ItemPosName[i] .. "   [Lv." .. tStrLv .. "]　" 
                              .. tStrExp .. "　　(" .. rateB .. "%/" .. rateH .. "%)\n"
          end
          NLG.ShowWindowTalked(player, self.phySloterNPC, CONST.窗口_选择框, CONST.按钮_关闭, 1, winMsg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.phySloterNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --print(data)
    if select > 0 then
      if (seqno == 11 and select == CONST.按钮_关闭) then
         return;
      end
      if (seqno == 11 and select == CONST.BUTTON_确定 and data >= 1) then
          local addExp = tonumber(data) or 0; -- 玩家輸入要充入的伏特量
          local uiIdx = targetUIIdx;
          local posName = ItemPosName[uiIdx];
          local curExp = tonumber(PhySlotStat(player, posName, "V")) or 0;
          local curLv = tonumber(PhySlotStat(player, posName, "Q")) or 0;

          if (curLv >= MaxLv) then
              NLG.SystemMessage(player, "[系統]該部位已達最高等級999");
              return;
          end
          if addExp <= 0 or addExp > Char.ItemNum(player, energy) then	-- 能量道具數量
              NLG.SystemMessage(player, "[系統]能量不足或輸入錯誤。");
              return;
          end

          -- 1. 更新經驗與等級
          local newExp = math.min(MaxExp, curExp + addExp);	--計算更新經驗
          local newLv = curLv;
          for lv = curLv + 1, MaxLv do
            if newExp >= GetExpByLv(lv) then newLv = lv else break end	--新經驗計算新等級
          end
          Char.DelItem(player, energy, addExp);	-- 扣除道具
          PhySlotStat(player, posName, "V", newExp);
          PhySlotStat(player, posName, "Q", newLv);

          -- 2. 同步刷新所有映射的 Game Slots
          for _, gameSlot in ipairs(SlotMapping[uiIdx]) do
            local itemIndex = Char.GetItemIndex(player, gameSlot);
            if itemIndex >= 0 then
               setItemRevertData(itemIndex);		-- 先還原舊等級加成
               setItemStrData(itemIndex, newLv);	-- 賦予新等級加成
               Item.UpItem(player, gameSlot);
            end
          end
          NLG.UpChar(player);
          NLG.SystemMessage(player, "[系統] " .. posName .. " 強化完成，目前等級 Lv." .. newLv);
      end

    else
      if (seqno == 1 and select == CONST.按钮_关闭) then
         return;
      end
      if (seqno == 1 and data >= 1) then
        targetUIIdx = data -- 暫存玩家選的 UI 索引 (1-4)
        local killNum = Char.ItemNum(player, energy);
        local winMsg = "　　　　　　　　$1【角色訓練強化】\\n"
                     .."═════════════════════\\n"
                     .."正在確認核心資訊...\\n"
                     .."\\n　　　　確認部位：$2".. ItemPosName[targetUIIdx] .."\\n"
                     .."\\n　　　　當前能量：$4".. killNum .."\\n"
                     .."\\n請輸入欲充入的能量數值：\\n";
        NLG.ShowWindowTalked(player, self.phySloterNPC, CONST.窗口_输入框, CONST.按钮_确定关闭, 11, winMsg);
      else
        return;
      end
    end
  end)


end
-- 強化邏輯與 NPC 事件 (此處省略部分重複的 NPC 註冊代碼，重點在於經驗邏輯)
-- ... (在對話事件中加入等級判定)
-- local nextExp = GetExpByLv(tStrLv + 1)
-- if tStrExp >= nextExp and tStrLv < MaxLv then 
--    PhySlotStat(player, ItemPosName[targetSlot+1], "Q", tStrLv + 1)
-- end

---------------------------------------------------------------------
------------------------------------------------------------------------------------------
--功能函数
function PhySlotStat( _Index, _StatSlot, _StatTab, _StatValue )
	--  E-赋予，P- 喷漆，H- 猎，G- 鬼，Q- 插槽，V- 伏特，C- 卡片
	local tStatTab = {}
	if type(_StatTab)=="nil" then
		--GetAll
		local tItemStat = tostring(Char.GetExtData(_Index, _StatSlot));
		if string.find(tItemStat, ",")==nil then
			return nil;
		end
		if string.find(tItemStat, "|")==nil then
			local tSub = string.split(tItemStat, ",");
			tStatTab[tSub[1]]=tonumber(tSub[2]);
			return tStatTab;
		end
		local tStat = string.split(tItemStat, "|")
		for k,v in pairs(tStat) do
			local tSub = string.split(v, ",");
			tStatTab[tSub[1]]=tSub[2];
		end
		return tStatTab;
	elseif type(_StatTab)=="table" then
		--SetAll
		local tStat = "";
		for k,v in pairs(_StatTab) do
			tStat = tStat .. k .. "," .. v .. "|";
		end
		Char.SetExtData(_Index, _StatSlot, tStat);
		NLG.UpChar(_Index);
	elseif type(_StatTab)=="string" and type(_StatValue)=="nil" then
		--GetSub
		local tStatTab = PhySlotStat(_Index, _StatSlot) or {};
		for k,v in pairs(tStatTab) do
			if _StatTab==k then
				return v;
			end
		end
		return nil;
	elseif type(_StatTab)=="string" then
		--SetSub
		local tStatTab = PhySlotStat(_Index, _StatSlot) or {};
		tStatTab[_StatTab]=_StatValue;
		PhySlotStat(_Index, _StatSlot, tStatTab);
	end
end


-- 修改後的穿戴回呼
function Module:itemAttachCallback(charIndex, fromItemIndex)
    if Char.IsDummy(charIndex) or Char.IsPet(charIndex) then return 0 end

    -- 1. 透過類型獲取「部位名稱」，用來抓取共用經驗條等級
    local posName = Char.GetTargetItemSlotName(charIndex, fromItemIndex);
    if not posName then return 0 end

    -- 2. 獲取該部位等級並賦予能力
    local tStrLv = tonumber(PhySlotStat(charIndex, posName, "Q")) or 0
    setItemStrData(fromItemIndex, tStrLv);

    -- 3. 重要：尋找該道具「目前位於」哪一個裝備欄位 (物理 Slot)
    -- 不要使用自定義的 GetTargetItemSlot，改用遍歷尋找
    local targetSlot = -1;
    for i = 0, 4 do -- 檢查頭、身、右、左、足
        if Char.GetItemIndex(charIndex, i) == fromItemIndex then
            targetSlot = i;
            break;
        end
    end
    Item.UpItem(charIndex, targetSlot);
    NLG.UpChar(charIndex);
    --Char.SaveToDb(charIndex);
    return 0
end
-- 修改後的卸下回呼
function Module:itemDetachCallback(charIndex, fromItemIndex)
    if Char.IsDummy(charIndex) or Char.IsPet(charIndex) then return 0 end

    -- 1. 獲取該部位等級並減除能力
    setItemRevertData(fromItemIndex);
    -- 執行還原
    local targetSlot = -1;
    for i = 0, 4 do -- 檢查頭、身、右、左、足
        if Char.GetItemIndex(charIndex, i) == fromItemIndex then
            targetSlot = i;
            break;
        end
    end
    Item.UpItem(charIndex, targetSlot);

    -- 更新角色狀態
    NLG.UpChar(charIndex);
    --Char.SaveToDb(charIndex);
    return 0
end


-- 裝備時增加素質 (更新版)
function setItemStrData(_ItemIndex, _StrLv)
    local strData = {18, 19, 20, 21, 22, 27, 28} -- 攻,防,敏,精,回,血,魔
    local Plus_buffer = {}

    -- 根據新等級獲取 K 曲線倍率
    local bRate = GetRateByLv(_StrLv, false)
    local hRate = GetRateByLv(_StrLv, true)

    for k, v in pairs(strData) do
        local baseVal = Item.GetData(_ItemIndex, v)
        local plus = 0
        if baseVal ~= 0 then -- 即使是負值裝備也進行計算
            if k <= 5 then
                plus = math.floor(baseVal * bRate)
            else
                plus = math.floor(baseVal * hRate)
            end
            Item.SetData(_ItemIndex, v, baseVal + plus);
        end
        Plus_buffer[k] = plus -- 記錄這次增加了多少數值
    end

    -- 將這 7 項數值用 "|" 隔開存入道具參數，供還原時使用
    local tStat = table.concat(Plus_buffer, "|");
    Item.SetData(_ItemIndex, CONST.道具_自用参数, tostring(tStat));
end

-- 卸下時還原素質 (針對 1~999 級設計)
function setItemRevertData(_ItemIndex)
    local tItemStat = tostring(Item.GetData(_ItemIndex, CONST.道具_自用参数));
    
    -- 安全檢查：確保有記錄加成數值才進行扣除
    if tItemStat == "" or string.find(tItemStat, "|") == nil then
        return
    end

    local strData = {18, 19, 20, 21, 22, 27, 28}
    local Plus_buffer = string.split(tItemStat, "|")

    for k, v in pairs(strData) do
        -- 讀取當前數值並減去當初增加的數值
        local currentVal = Item.GetData(_ItemIndex, v)
        local addedVal = tonumber(Plus_buffer[k]) or 0
        Item.SetData(_ItemIndex, v, currentVal - addedVal);
    end

    -- 清空道具參數，防止重複扣除
    Item.SetData(_ItemIndex, CONST.道具_自用参数, "");
end

-- 回傳對應 ItemPosName 的字串
Char.GetTargetItemSlotName = function(charIndex, fromItemIndex)
    local type = Item.GetData(fromItemIndex, CONST.道具_类型);
    if type == 8 or type == 9 then return "頭 部"
    elseif type >= 10 and type <= 12 then return "身 体"
    elseif type >= 0 and type <= 7 then return "手 部" -- 劍、斧、矛、杖、弓、投擲、盾等全部歸類手部
    elseif type == 13 or type == 14 then return "足 部"
    end
    return nil
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;