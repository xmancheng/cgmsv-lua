---模块类
local Module = ModuleBase:createModule(simpleDIYs)

--分类自行添加
local diy_plan_name = {};		--表单显示道具名称
local diy_plan_offering = {};	--最多三组的材料设置{道具编号,数量(数量不超过99)}
local diy_plan_gold = {};		--需求金币
local diy_plan_thing = {};		--10组成品制作结果(连动成功率)[不超过4种]
local diy_plan_level = {};		--需求探索等级
--
diy_plan_name[1] = "《誘魔藥水,滿怪藥水》 1";
diy_plan_offering[1] = {{70262,10},{70266,10},{70270,10}};
diy_plan_gold[1] =100;
diy_plan_thing[1] = {70085,70085,70085,70085,70085,70085,70085,70085,70085,70087,};
diy_plan_level[1] = 1;

diy_plan_name[2] = "《誘魔藥水,滿怪藥水》 2";
diy_plan_offering[2] = {{70262,20},{70266,20},{70270,20}};
diy_plan_gold[2] =500;
diy_plan_thing[2] = {70085,70085,70085,70085,70085,70085,70085,70085,70087,70087,};
diy_plan_level[2] = 10;

diy_plan_name[3] = "《滿怪藥水,寵物壓縮箱》";
diy_plan_offering[3] = {{70262,20},{70265,20},{70269,20}};
diy_plan_gold[3] =2000;
diy_plan_thing[3] = {70087,70087,70087,70087,70200,70200,70200,70200,70200,70200};
diy_plan_level[3] = 20;

diy_plan_name[4] = "《初級移動坐騎》";
diy_plan_offering[4] = {{70262,80},{70266,80},{70270,80}};
diy_plan_gold[4] =5000;
diy_plan_thing[4] = {75004,75004,75004,75004,75013,75013,75018,75018,75053,75053};
diy_plan_level[4] = 5;

diy_plan_name[5] = "《誘魔藥水,驅魔藥水》";
diy_plan_offering[5] = {{70263,20},{70267,20},{70271,20}};
diy_plan_gold[5] =2000;
diy_plan_thing[5] = {70085,70085,70085,70085,70085,70085,70085,70085,70086,70086};
diy_plan_level[5] = 30;

diy_plan_name[6] = "《寵物洗檔裝置,銀色王冠》";
diy_plan_offering[6] = {{70251,5},{70252,5},{70250,5}};
diy_plan_gold[6] =5000;
diy_plan_thing[6] = {70052,70052,70052,70052,70052,70052,70052,68018,68018,68018};
diy_plan_level[6] = 50;

diy_plan_name[7] = "《寵物洗檔裝置,金色王冠》";
diy_plan_offering[7] = {{70253,5},{70254,5},{70255,5}};
diy_plan_gold[7] =6000;
diy_plan_thing[7] = {70052,70052,70052,70052,70052,70052,70052,70052,70052,68017};
diy_plan_level[7] = 70;

-----------------------------------------------------
local function calcWarp()
  local page = math.modf(#diy_plan_name / 8) + 1
  local remainder = math.fmod(#diy_plan_name, 8)
  return page, remainder
end

local function calcFilteredWarp(availableCount)
  local totalPage = math.floor((availableCount - 1) / 8) + 1;
  local remainder = math.fmod(availableCount, 8);
  if remainder == 0 and availableCount > 0 then remainder = 8 end
  return totalPage, remainder;
end

--远程按钮UI呼叫
function Module:simpleDIYsInfo(npc, player)
          local winButton = CONST.BUTTON_关闭;
          local msg = "1\\n　　　　　　　　【簡易道具合成】\\n"
          for i = 1,8 do
             msg = msg .. "　　◎項目 "..i.."　".. diy_plan_name[i] .. "\\n"
             if (i>=8) then
                 winButton = CONST.BUTTON_下取消;
             end
          end
          NLG.ShowWindowTalked(player, self.DIYerNPC, CONST.窗口_选择框, winButton, 1, msg);
end

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load');
  self.DIYerNPC = self:NPC_createNormal('組合工作台', 400222, { x = 34, y = 27, mapType = 0, map = 20311, direction = 0 });
  self:NPC_regWindowTalkedEvent(self.DIYerNPC, function(npc, player, _seqno, _select, _data)
    local column = tonumber(_data)
    local page = tonumber(_seqno)
    local warpPage = page;
    local winMsg = "1\\n　　　　　　　　【簡易道具合成】\\n"
    local winButton = CONST.BUTTON_关闭;
    --local totalPage, remainder = calcWarp()
	local availableList = getPlayerAvailableList(player);
    local totalAvailable = #availableList;
    local totalPage, remainder = calcFilteredWarp(totalAvailable);
    -- 1. 處理「確定製作」與「查看詳情」的跳轉邏輯
    if _select == CONST.按钮_是 then
        if (page >= 2001) then
            local realIdx = page - 2000;
            diyMutation(realIdx, player);
            return;
        else
            return;
        end
    elseif _select == CONST.按钮_确定 then
        if (page >= 1001) then
            local realIdx = page - 1000;
            local msg = "　　　　　　　　【確認合成材料】\\n"
                     .. "　　　$1確認要消耗以下材料進行製作嗎？\\n$5"
            msg = msg .. diyOfferingInfo(realIdx);
            NLG.ShowWindowTalked(player, self.DIYerNPC, CONST.窗口_信息框, CONST.按钮_是否, 2000 + realIdx, msg);
            return;
        else
            return;
        end
    elseif _select == CONST.按钮_关闭 then
        return;
    elseif _select == CONST.按钮_否 then
        -- 返回主選單第一頁
        page = 1;
    end

    -- 2. 處理分頁按鈕切換
    local warpPage = page;
    if _select == CONST.BUTTON_下一页 then
        warpPage = warpPage + 1;
    elseif _select == CONST.BUTTON_上一页 then
        warpPage = warpPage - 1;
    end

    -- 3. 判斷是「點選項目」還是「切換頁面」
    if _select > 0 then
        -- 顯示選單介面
        local winButton = CONST.BUTTON_关闭;
        if totalPage > 1 then
            if warpPage <= 1 then winButton = CONST.BUTTON_下取消;
            elseif warpPage >= totalPage then winButton = CONST.BUTTON_上取消;
            else winButton = CONST.BUTTON_上下取消; end
        end

        local winMsg = "1\\n　　　　　　　　【簡易道具合成】\\n";
        local startIdx = (warpPage - 1) * 8 + 1;
        local endIdx = math.min(warpPage * 8, totalAvailable);

        for i = startIdx, endIdx do
            local realIdx = availableList[i];
            winMsg = winMsg .. "　　◎項目 " .. i .. "　" .. diy_plan_name[realIdx] .. "\\n";
        end
        NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, winButton, warpPage, winMsg);
    else
        -- 玩家點選了某個項目 (_select == 0)
        local selectionIndex = (warpPage - 1) * 8 + column;
        local realIdx = availableList[selectionIndex];	-- 透過映射表抓回真實 ID
        if realIdx then
            local msg = "　　　　　　　　【簡易道具合成】\\n" .. diyGoalInfo(realIdx);
            NLG.ShowWindowTalked(player, self.DIYerNPC, CONST.窗口_信息框, CONST.按钮_确定关闭, 1000 + realIdx, msg);
        end
    end
--[[
    --上页16 下页32 关闭/取消2
    if _select > 0 then
      if _select == CONST.按钮_确定 then
          if (page>=1001) then
              local realIdx = page - 1000;
              local msg = "　　　　　　　　【簡易道具合成】\\n"
                                  .. "　　　$1需要以下所有材料才能進行合成\\n$5"
              local msg = msg .. diyOfferingInfo(realIdx)
              NLG.ShowWindowTalked(player, self.DIYerNPC, CONST.窗口_信息框, CONST.按钮_是否, 2000+realIdx, msg);
              return
          else
              return
          end
      elseif _select == CONST.按钮_关闭 then
          if (page>=1001) then
              local msg = "1\\n　　　　　　　　【簡易道具合成】\\n"
              for i = 1,8 do
                 msg = msg .. "　　◎項目 "..i.."　".. diy_plan_name[i] .. "\\n"
                 if (i>=8) then
                     winButton = CONST.BUTTON_下取消;
                 end
              end
              NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, winButton, 1, msg);
              return
          else
              return
          end
      elseif _select == CONST.按钮_是 then
          if (page>=2001) then
              local realIdx = page - 2000;
              forgingMutation(realIdx,player)
              return
          else
              return
          end
      elseif _select == CONST.按钮_否 then
          if (page>=2001) then
              local realIdx = page - 2000;
              local msg = "　　　　　　　　【可能獲得的成品】\\n"
              local msg = msg .. diyGoalInfo(realIdx);
              NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.按钮_确定关闭, 1000+realIdx, msg);
              return
          else
              return
          end
      end
      if _select == CONST.BUTTON_下一页 then
        warpPage = warpPage + 1
        if (warpPage == totalPage) or ((warpPage == (totalPage - 1) and remainder == 0)) then
          winButton = CONST.BUTTON_上取消
        else
          winButton = CONST.BUTTON_上下取消
        end
      elseif _select == CONST.BUTTON_上一页 then
        warpPage = warpPage - 1
        if warpPage == 1 then
          winButton = CONST.BUTTON_下取消
        else
          winButton = CONST.BUTTON_上下取消
        end
      elseif _select == 2 then
        warpPage = 1
        return
      end
      local realIdx = 8 * (warpPage - 1)
      if warpPage == totalPage then
        for i = 1 + realIdx, remainder + realIdx do
            winMsg = winMsg .. "　　◎項目 "..i.."　".. diy_plan_name[i] .. "\\n"
        end
      else
        for i = 1 + realIdx, 8 + realIdx do
            winMsg = winMsg .. "　　◎項目 "..i.."　".. diy_plan_name[i] .. "\\n"
        end
      end
      NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, winButton, warpPage, winMsg);
    else
      local realIdx = 8 * (warpPage - 1) + column
      --print(realIdx)
      local msg = "　　　　　　　　【可能獲得的成品】\\n"
      local msg = msg .. diyGoalInfo(realIdx);
      NLG.ShowWindowTalked(player, self.DIYerNPC, CONST.窗口_信息框, CONST.按钮_确定关闭, 1000+realIdx, msg);
    end
]]
  end)
  self:NPC_regTalkedEvent(self.DIYerNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local winButton = CONST.BUTTON_关闭;
      local availableList = getPlayerAvailableList(player);

      local msg = "1\\n　　　　　　　　【簡易道具合成】\\n"
      -- 根據可用清單生成 UI
      for showIdx, realIdx in ipairs(availableList) do
         if (showIdx <= 8) then
           msg = msg .. "　　◎項目 " .. showIdx .. "　" .. diy_plan_name[realIdx] .. "\\n"
         end
         if (showIdx >= 8) then
             winButton = CONST.BUTTON_下取消;
         end
      end
      --[[for i = 1,4 do
         msg = msg .. "　　◎項目 "..i.."　".. diy_plan_name[i] .. "\\n"
         if (i>=8) then
             winButton = CONST.BUTTON_下取消;
         end
      end]]
      NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, winButton, 1, msg);
    end
    return
  end)
end

---------------------------------------------------------------------------------------------------------------
--- 獲取玩家當前可見的合成清單
function getPlayerAvailableList(player)
	local exploreLv = Char.GetExtData(player, '探索等级') or 1;
	local availableList = {};
	for i = 1, #diy_plan_name do
		if exploreLv >= (diy_plan_level[i] or 0) then
			table.insert(availableList, i); -- 儲存原始索引
		end
	end
	return availableList;
end

--目标信息
function diyGoalInfo(realIdx)
	local results = diy_plan_thing[realIdx];
	local counts = {} -- 用於統計：[道具ID] = 數量

	-- 1. -- 統計機率
	for _, itemId in ipairs(results) do
		counts[itemId] = (counts[itemId] or 0) + 1;
	end

	-- 2. 將統計結果轉入新表以便排序
	local sortedList = {}
	for itemId, count in pairs(counts) do
		table.insert(sortedList, {id = itemId, count = count})
	end

	-- 3. 依照 count (機率) 大小進行降序排序 (從大到小)
	table.sort(sortedList, function(a, b)
		return a.count > b.count
	end)

	-- 4. 遍歷統計結果，生成圖示與機率文字
	local idx = 0
	local msg = "\\n ";
	for _, data in pairs(sortedList) do
		local ItemIndex = Data.ItemsetGetIndex(data.id);
		local name = Data.ItemsetGetData(ItemIndex, CONST.ITEMSET_TRUENAME);
		msg = msg .. "   " .. "$5" .. string.sub(name,1,4) .. "    "
		idx = idx + 1;
		if idx >= 4 then break end
	end

	local idx = 0
	msg = msg.."\\n"
	for _, data in pairs(sortedList) do
		local ItemIndex = Data.ItemsetGetIndex(data.id);
		local name = Data.ItemsetGetData(ItemIndex, CONST.ITEMSET_TRUENAME);
		local image = Data.ItemsetGetData(ItemIndex, CONST.ITEMSET_BASEIMAGENUMBER);
		local rate = data.count * 10 .. "%" -- 每個位置代表10%
		msg = msg .. "   " .. "$4[" .. rate .. "]" .. "   "
		idx = idx + 1;
		if idx >= 4 then break end
	end

	local idx = 0
	msg = msg.."\\n"
	for _, data in pairs(sortedList) do
		local ItemIndex = Data.ItemsetGetIndex(data.id);
		local image = Data.ItemsetGetData(ItemIndex, CONST.ITEMSET_BASEIMAGENUMBER);
		local imgX = 2 + (idx * 5); -- 這裡只是範例，建議垂直排列較清晰
		local imageText_idx = "@g,"..image..","..imgX..",6,0,0@"
		msg = msg .. imageText_idx
		idx = idx + 1;
		if idx >= 4 then break end
	end

--[[
      local ItemsetIndex_Goal = Data.ItemsetGetIndex(diy_plan_thing[count][10]);
      local Goal_name = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_TRUENAME);
      local Goal_DataPos_2 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_BASEIMAGENUMBER);
      local imageText = "@g,"..Goal_DataPos_2..",3,4,0,0@"

      local Goal_DataPos_3 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_TYPE);
      local Goal_DataPos_3 = Type(Goal_DataPos_3);
      local Goal_DataPos_4 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_MAXDURABILITY);
      local Goal_DataPos_5 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_LEVEL);
      local Goal_DataPos_6 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_MODIFYATTACK);
      local Goal_DataPos_7 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_MODIFYDEFENCE);
      local Goal_DataPos_8 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_MODIFYAGILITY);
      local Goal_DataPos_9 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_MODIFYMAGIC);
      local Goal_DataPos_10 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_MODIFYRECOVERY);

      local Goal_DataPos_11 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_MODIFYCRITICAL);
      local Goal_DataPos_12 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_MODIFYCOUNTER);
      local Goal_DataPos_13 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_MODIFYHITRATE);
      local Goal_DataPos_14 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_MODIFYAVOID);

      local Goal_DataPos_15 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_MODIFYHP);
      local Goal_DataPos_16 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_MODIFYFORCEPOINT);
      local Goal_DataPos_17 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_MODIFYLUCK);
      local Goal_DataPos_18 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_MODIFYCHARISMA);
      local Goal_DataPos_19 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_MODIFYCHARM);
      local Goal_DataPos_20 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_POISON);
      local Goal_DataPos_21 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_SLEEP);
      local Goal_DataPos_22 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_STONE);
      local Goal_DataPos_23 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_DRUNK);
      local Goal_DataPos_24 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_CONFUSION);
      local Goal_DataPos_25 = Data.ItemsetGetData(ItemsetIndex_Goal, CONST.ITEMSET_AMNESIA);

      local msg = imageText .. "　　$4".. Goal_name .. "\\n"
                         .. "　　　　　　　" .. "$1攻擊 ".. Goal_DataPos_6 .."　" .. "$8必殺 ".. Goal_DataPos_11 .."　" .. "$8反擊 ".. Goal_DataPos_12 .."\\n"
                         .. "　　　　　　　" .. "$1防禦 ".. Goal_DataPos_7 .."　" .. "$8命中 ".. Goal_DataPos_13 .."　" .. "$8閃躲 ".. Goal_DataPos_14 .."\\n"
                         .. "　　　　　　　" .. "$1敏捷 ".. Goal_DataPos_8 .."　" .. "$2抗毒 ".. Goal_DataPos_20 .."　" .. "$2抗醉 ".. Goal_DataPos_23 .."\\n"
                         .. "　　　　　　　" .. "$1精神 ".. Goal_DataPos_9 .."　" .. "$2抗睡 ".. Goal_DataPos_21 .."　" .. "$2抗混 ".. Goal_DataPos_24 .."\\n"
                         .. "　　　　　　　" .. "$1恢復 ".. Goal_DataPos_10 .."　" .. "$2抗石 ".. Goal_DataPos_22 .."　" .. "$2抗忘 ".. Goal_DataPos_25 .."\\n"
                         .. "　　　　　　　" .. " \\n"
                         .. "　　　　　　　" .. "$9類型 ".. Goal_DataPos_3 .."　" .. "$9等級 ".. Goal_DataPos_5 .."　" .. "$9耐久 ".. Goal_DataPos_4 .."\\n"
]]
	return msg;
end

--祭品信息
function diyOfferingInfo(realIdx)
	local msg = "";
	for i = 1,#diy_plan_offering[realIdx] do
		local ItemsetIndex_i = Data.ItemsetGetIndex(diy_plan_offering[realIdx][i][1]);
		local ItemNum_i = Data.ItemsetGetIndex(diy_plan_offering[realIdx][i][2]);
		local offering_name_i = Data.ItemsetGetData(ItemsetIndex_i, CONST.ITEMSET_TRUENAME);
		local offering_image_i = Data.ItemsetGetData(ItemsetIndex_i, CONST.ITEMSET_BASEIMAGENUMBER);
		local offering_image_ix = 3 + 7*(i-1);
		local imageText_i = "@g,"..offering_image_i..","..offering_image_ix..",4,0,0@"
		local len = #offering_name_i;
		if len <= 12 then
			spacelen = 12 - len;
			spaceMsg = "";
			for i = 1, math.modf(spacelen/2) do
				spaceMsg = spaceMsg .." ";
			end
		else
			spaceMsg = "";
		end
		msg = msg .. spaceMsg .. offering_name_i ..ItemNum_i.."個" .. spaceMsg .. imageText_i
	end
	local Gold = diy_plan_gold[realIdx];

	--local probRate = prob(realIdx,diy_plan_thing[realIdx][10]);
	local msg = msg .. "\\n\\n\\n\\n　$4魔幣: " .. Gold .. " G"
	return msg;
end

--道具合成执行
function diyMutation(realIdx,player)
	if (Char.GetData(player, CONST.对象_金币)<diy_plan_gold[realIdx]) then
		NLG.SystemMessage(player,"[系統]改造所需金幣不足。");
		return
	end
	for i = 1,#diy_plan_offering[realIdx] do
		local itemIndex = Char.HaveItem(player, diy_plan_offering[realIdx][i][1]);
		if (itemIndex>=0) then
			local itemNum = Char.ItemNum(player,diy_plan_offering[realIdx][i][1]);
			if (itemNum < diy_plan_offering[realIdx][i][2]) then
				NLG.SystemMessage(player,"[系統]合成所需材料數量不足。");
				return
			end
		else
			NLG.SystemMessage(player,"[系統]缺少合成所需材料。");
			return
		end
	end
	Char.AddGold(player, -diy_plan_gold[realIdx]);
	local randCatch= NLG.Rand(1, #diy_plan_thing[realIdx] );
	for i = 1,#diy_plan_offering[realIdx] do
		Char.DelItem(player, diy_plan_offering[realIdx][i][1], diy_plan_offering[realIdx][i][2]);
	end
	Char.GiveItem(player,diy_plan_thing[realIdx][randCatch],1);
end

--目标成功率计算
--[[function prob(count,id)
  for i=1,10 do
      if (diy_plan_thing[count][i]==id) then
          local prob = ( (11-i)/10 )*100;
          return prob;
      end
  end
  return -1;
end]]

--类型字符串转换
function Type(Type)
  if Type==0 then
    return "劍"
  elseif Type == 1 then
    return "斧"
  elseif Type == 2 then
    return "槍"
  elseif Type == 3 then
    return "杖"
  elseif Type == 4 then
    return "弓"
  elseif Type == 5 then
    return "小刀"
  elseif Type == 6 then
    return "迴力鏢"
  elseif Type == 7 then
    return "盾"
  elseif Type == 8 then
    return "頭盔"
  elseif Type == 9 then
    return "帽子"
  elseif Type == 10 then
    return "鎧甲"
  elseif Type == 11 then
    return "衣服"
  elseif Type == 12 then
    return "長袍"
  elseif Type == 13 then
    return "靴子"
  elseif Type == 14 then
    return "鞋子"
  elseif Type == 15 then
    return "手環"
  elseif Type == 16 then
    return "樂器"
  elseif Type == 17 then
    return "項鍊"
  elseif Type == 18 then
    return "戒指"
  elseif Type == 19 then
    return "頭帶"
  elseif Type == 20 then
    return "耳環"
  elseif Type == 21 then
    return "護身符"
  elseif Type == 22 then
    return "水晶"
  elseif Type == 55 then
    return "頭飾"
  elseif Type == 56 then
    return "寵物水晶"
  elseif Type == 57 then
    return "寵物飾品"
  elseif Type == 58 then
    return "寵物裝甲"
  elseif Type == 59 then
    return "寵物服飾"
  elseif Type == 60 then
    return "寵物頸圈"
  elseif Type == 61 then
    return "寵物護符"
  elseif Type == 65 then
    return "令旗"
  elseif Type == 66 then
    return "魔劍"
  elseif Type == 67 then
    return "陷阱"
  elseif Type == 68 then
    return "書籍"
  elseif Type == 69 then
    return "風魔"
  elseif Type == 70 then
    return "拳套"
  else
    return "不明"
  end
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
