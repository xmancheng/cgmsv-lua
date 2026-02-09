---模块类
local Module = ModuleBase:createModule(questBoard)

-- 委託配置表格
local quest_name = {};        -- 委託標題
local quest_description = {}; -- 任務簡述
local quest_requirement = {}; -- 需求道具 {道具編號, 數量}
local quest_reward = {};      -- 獎勵道具 {道具編號, 數量}
local quest_level_limit = {}; -- 需求勇者等級

-- 委託資料範例 (可自行增刪)
quest_name[1] = "《清除哥布林》";
quest_description[1] = "最近法蘭城附近哥布林橫行，公會正在徵集冒險者們討伐大量哥布林，收集綠頭盔來證明你的貢獻。";
quest_requirement[1] = {18195, 5}; -- 需求道具ID, 數量
quest_reward[1] = {75041, 1};      -- 獎勵道具ID (委託狀), 數量
quest_level_limit[1] = 1;          -- 勇者等級限制

quest_name[2] = "《討伐哥布林》";
quest_description[2] = "士兵回報在法蘭城南門外發現哥布林之家，請冒險者支援加入哥布林討伐隊為了榮譽而戰。";
quest_requirement[2] = {18243, 1};
quest_reward[2] = {75042, 1};
quest_level_limit[2] = 10;

quest_name[3] = "《偷吃魚的貓贼》";
quest_description[3] = "拿潘食品店賣魚的帕林正在困擾魚被偷走，夜晚時間到冒險者旅館門口附近探查可疑人事物。";
quest_requirement[3] = {18185, 1};
quest_reward[3] = {75041, 1};
quest_level_limit[3] = 1;

quest_name[4] = "《收集魔法藥草》";
quest_description[4] = "鍊金術師公會正急需一批高品質藥草，這對提升冒險者的補給有很大幫助。";
quest_requirement[4] = {12800, 80};
quest_reward[4] = {75041, 1};
quest_level_limit[4] = 2;

quest_name[5] = "《成為究極廚師》";
quest_description[5] = "王宮食堂正在尋找能幫忙的廚師助手，對廚藝有自信的冒險者們可以去參加挑戰。";
quest_requirement[5] = {18629, 1};
quest_reward[5] = {75041, 1};
quest_level_limit[5] = 5;

quest_name[6] = "《愛貓的女孩》";
quest_description[6] = "法蘭城公寓二樓愛貓的莎佳琦想養貓但公寓是禁止養寵物的。如果你帶著可愛虎人她會很高興。";
quest_requirement[6] = {18306, 1};
quest_reward[6] = {75041, 2};
quest_level_limit[6] = 5;

quest_name[7] = "《競技場的迷宮》";
quest_description[7] = "法蘭城的競技場在白天時定期舉辦衝刺路跑活動，勇者們請以第一名為目標吧。";
quest_requirement[7] = {18396, 1};
quest_reward[7] = {75041, 2};
quest_level_limit[7] = 7;

quest_name[8] = "《討伐洞窟牛鬼》";
quest_description[8] = "伊爾村旅行商人泰勒的女兒被名叫牛鬼的怪物給抓走了，正在找勇士幫助去救他女兒浦部。";
quest_requirement[8] = {18230, 1};
quest_reward[8] = {75041, 2};
quest_level_limit[8] = 8;

quest_name[9] = "《尋找失蹤的雷茲》";
quest_description[9] = "伊爾村醫院的獵人柯薩裘正在四處打探兒子的消息，他兒子去亞留特村打獵已許久未歸。";
quest_requirement[9] = {18302, 1};
quest_reward[9] = {75041, 2};
quest_level_limit[9] = 9;

quest_name[10] = "《畢安札的送禮》";
quest_description[10] = "羅珊娜等待著前往靈堂討伐的士兵畢安札歸來，將她的盼望傳達給畢安札。";
quest_requirement[10] = {18236, 1};
quest_reward[10] = {75041, 2};
quest_level_limit[10] = 10;

quest_name[11] = "《旅館的調查》";
quest_description[11] = "法蘭城剛接手的旅館主人發出委託，希望調查清楚為什麼會傳出鬧鬼的傳聞。";
quest_requirement[11] = {18326, 1};
quest_reward[11] = {75041, 3};
quest_level_limit[11] = 10;

quest_name[12] = "《豪華客船的事件》";
quest_description[12] = "豪華屋中愛說明的漢克偵探以誘人的獎賞徵集有能力的助手一同前往招待的豪華客船。";
quest_requirement[12] = {18899, 1};
quest_reward[12] = {75044, 1};
quest_level_limit[12] = 10;

quest_name[13] = "《奇怪的洞窟》";
quest_description[13] = "亞留特村不斷傳出村民消失，去村莊附近調查看看，如有撿到絲巾交給亞留特村的南希。";
quest_requirement[13] = {18305, 1};
quest_reward[13] = {75041, 2};
quest_level_limit[13] = 11;

quest_name[14] = "《流星山丘巡禮》";
quest_description[14] = "索奇亞島的流星山丘是情侶必去聖地，途中撿到的隕石有機會是能許願成功的流星。";
quest_requirement[14] = {18375, 1};
quest_reward[14] = {75042, 2};
quest_level_limit[14] = 12;

quest_name[15] = "《帶著熊攔路的男人》";
quest_description[15] = "傳聞哈巴魯東邊洞穴有著一位殺熊者，攔下所有經過的人們，委託人希望派人去調查。";
quest_requirement[15] = {18403, 1};
quest_reward[15] = {75041, 1};
quest_level_limit[15] = 13;

quest_name[16] = "《戰士巴其魯的困擾》";
quest_description[16] = "索奇亞海底洞窟也有著一位男人會攔下經過的人們，消息說道他似乎正找尋著弟妹。";
quest_requirement[16] = {18404, 1};
quest_reward[16] = {75041, 3};
quest_level_limit[16] = 13;

quest_name[17] = "《奇利村誘拐事件》";
quest_description[17] = "奇利村老夫婦希望村長調查近期發生的護士誘拐事件找到女兒米內魯帕。";
quest_requirement[17] = {18350, 1};
quest_reward[17] = {75041, 3};
quest_level_limit[17] = 14;

quest_name[18] = "《恐怖旅團的調查》";
quest_description[18] = "索奇亞島馮奴的家委託法蘭城的冒險者，幫助打探傳聞中恐怖旅團的消息。";
quest_requirement[18] = {18421, 1};
quest_reward[18] = {75042, 1};
quest_level_limit[18] = 15;

quest_name[19] = "《砂漠之祠的考古》";
quest_description[19] = "索奇亞砂漠地底有間沙漠之廟，似乎埋藏著古代王族的稀世珍寶。";
quest_requirement[19] = {18464, 1};
quest_reward[19] = {75043, 1};
quest_level_limit[19] = 16;

quest_name[20] = "《咒術師的秘密住處》";
quest_description[20] = "莎蓮娜海底洞窟某處似乎有一個組織，它與法蘭城豪宅的不尋常有些關聯，請前去調查真相。";
quest_requirement[20] = {18378, 1};
quest_reward[20] = {75043, 1};
quest_level_limit[20] = 17;

quest_name[21] = "《蜥蜴戰士團討伐》";
quest_description[21] = "里堡人事部的卡斯巴爾收到來自阿巴尼斯村的緊急傳訊，需派人前往村外東邊蜥蜴之巢平定匪亂。";
quest_requirement[21] = {18577, 1};
quest_reward[21] = {75043, 1};
quest_level_limit[21] = 17;

quest_name[22] = "《艾爾巴尼亞特使》";
quest_description[22] = "特使與舞者可琳遭遇暴風雨，飄流到無人的隱藏之家，遇到一名未知少年的一連串事件。";
quest_requirement[22] = {18806, 1};
quest_reward[22] = {75043, 2};
quest_level_limit[22] = 17;

quest_name[23] = "《雪山之頂的魔物》";
quest_description[23] = "莎蓮娜積雪的山路有著強大的魔物棲息，傳聞它的眼淚有著驅魔避邪效果，委託從未中斷。";
quest_requirement[23] = {17798, 1};
quest_reward[23] = {75044, 1};
quest_level_limit[23] = 18;

quest_name[24] = "《連接時空之物》";
quest_description[24] = "能前往不同時空的神祕之物，似乎與索奇亞角笛大風穴水蜘蛛之眼有密切關係。";
quest_requirement[24] = {18443, 1};
quest_reward[24] = {75042, 1};
quest_level_limit[24] = 20;

quest_name[25] = "《森羅萬象之一》";
quest_description[25] = "芙蕾雅土之洞窟的調查委託。\\n";
quest_requirement[25] = {18973, 1};
quest_reward[25] = {75042, 2};
quest_level_limit[25] = 25;

quest_name[26] = "《森羅萬象之二》";
quest_description[26] = "芙蕾雅炎之洞窟的調查委託。\\n";
quest_requirement[26] = {18975, 1};
quest_reward[26] = {75043, 1};
quest_level_limit[26] = 25;

quest_name[27] = "《森羅萬象之三》";
quest_description[27] = "芙蕾雅水之洞窟的調查委託。\\n";
quest_requirement[27] = {18974, 1};
quest_reward[27] = {75043, 1};
quest_level_limit[27] = 25;

quest_name[28] = "《森羅萬象之四》";
quest_description[28] = "芙蕾雅風之洞窟的調查委託。\\n";
quest_requirement[28] = {18976, 1};
quest_reward[28] = {75042, 2};
quest_level_limit[28] = 25;

-----------------------------------------------------
-- 工具函數：分頁計算
local function calcFilteredWarp(availableCount)
    local totalPage = math.floor((availableCount - 1) / 8) + 1;
    local remainder = math.fmod(availableCount, 8);
    if remainder == 0 and availableCount > 0 then remainder = 8 end
    return totalPage, remainder;
end

-- 獲取玩家符合「勇者等級」的委託清單
--[[function getAvailableQuests(player)
    -- 修改：讀取勇者等級擴展數據
    local braveLv = Char.GetExtData(player,'勇者等级') or 1;
    local availableList = {};
    for i = 1, #quest_name do
        if braveLv >= (quest_level_limit[i] or 0) then
            table.insert(availableList, i); -- 儲存符合條件的原始索引
        end
    end
    return availableList;
end]]

-- 獲取玩家符合「勇者等級」且每天固定隨機抽選至多 8 個的委託清單
function getAvailableQuests(player)
    -- 1. 讀取勇者等級擴展數據
    local braveLv = Char.GetExtData(player, '勇者等级') or 1;
    local fullList = {};
    -- 2. 篩選出所有符合等級限制的委託
    for i = 1, #quest_name do
        if braveLv >= (quest_level_limit[i] or 0) then
            table.insert(fullList, i);
        end
    end
    -- 3. 如果符合條件的委託大於 8 個，則進行「日期固定隨機」
    if #fullList > 8 then
        -- 使用當前日期 (格式如 20231027) 作為隨機種子
        local dateSeed = tonumber(os.date("%Y%m%d"));
        math.randomseed(dateSeed); 
        -- 進行洗牌 (Shuffle)
        for i = #fullList, 2, -1 do
            -- 注意：設定了 seed 後使用 math.random
            local j = math.random(1, i);
            fullList[i], fullList[j] = fullList[j], fullList[i];
        end
        -- 4. 截取前 8 個委託
        local limitedList = {};
        for k = 1, 8 do
            table.insert(limitedList, fullList[k]);
        end
        -- 重要：隨機完畢後，建議將種子重置為系統時間，避免影響到遊戲其他邏輯
        math.randomseed(os.time());
        return limitedList;
    end

    -- 如果不足 8 個，直接返回所有符合條件的委託
    return fullList;
end


-- 生成委託詳情頁面 (左下需求，右下獎勵)
function getQuestDetailMsg(realIdx)
    local reqID = quest_requirement[realIdx][1];
    local rewID = quest_reward[realIdx][1];
    
    local reqIndex = Data.ItemsetGetIndex(reqID);
    local rewIndex = Data.ItemsetGetIndex(rewID);
    
    local reqName = Data.ItemsetGetData(reqIndex, CONST.ITEMSET_TRUENAME);
    local rewName = Data.ItemsetGetData(rewIndex, CONST.ITEMSET_TRUENAME);
    
    local reqImg = Data.ItemsetGetData(reqIndex, CONST.ITEMSET_BASEIMAGENUMBER);
    local rewImg = Data.ItemsetGetData(rewIndex, CONST.ITEMSET_BASEIMAGENUMBER);

    local space=""
    for i=1,16-#reqName do
      space = space .. " "
    end
    local msg = "　　　　　　　　【委託詳細內容】\\n"
             .. "$1委託內容：\\n　　" .. quest_description[realIdx] .. "\\n\\n"
             .. "　　$4〈需求物品〉　　　　　　　　〈委託獎勵〉\\n"
             .. "　　 $5" .. string.sub(reqName,1,16) .. " x" .. quest_requirement[realIdx][2] .. "　　　" ..space.. string.sub(rewName,1,16) .. " x" .. quest_reward[realIdx][2] .. "\\n"
             .. "　　　　　　　　　  $8是否交付?"
             -- 使用 @g 標籤繪製圖檔，左下(X=3)與右下(X=16)
             .. "@g,"..reqImg..",3,8,0,0@" .."@g,243041,6,8,0,0@".."@g,243041,8,8,0,0@".."@g,243041,10,8,0,0@".."@g,243041,12,8,0,0@"
             .. "@g,"..rewImg..",16,8,0,0@"
             --.. "@g,400437,10,5,0,0@"
    return msg;
end

--- 加载模块钩子
function Module:onLoad()
    self:logInfo('load');
    -- 建立一個告示牌外觀的 NPC
    self.BoardNPC = self:NPC_createNormal('冒險者公會委託板', 11563, { x = 235, y = 72, mapType = 0, map = 1000, direction = 6 });
    Char.SetData(self.BoardNPC,CONST.对象_ENEMY_PetFlg+2,0)--可穿透体
    self:NPC_regWindowTalkedEvent(self.BoardNPC, function(npc, player, _seqno, _select, _data)
        local column = tonumber(_data)
        local page = _seqno
        local availableList = getAvailableQuests(player);
        local totalAvailable = #availableList;
        local totalPage, remainder = calcFilteredWarp(totalAvailable);

        -- 處理交付邏輯
        if _select == CONST.按钮_是 then
            if page >= 1000 then
                local realIdx = page - 1000;
                
                -- 1. 空間檢查
                if Char.ItemSlot(player) < 1 then
                    NLG.SystemMessage(player, "[系統]物品欄位不足，請清出空間。");
                    return;
                end
                -- 2. 道具檢查
                local hasNum = Char.ItemNum(player, quest_requirement[realIdx][1]);
                if hasNum < quest_requirement[realIdx][2] then
                    NLG.SystemMessage(player, "[系統]需求物品數量不足。");
                    return;
                else
                    -- 3. 執行交換
                    Char.DelItem(player, quest_requirement[realIdx][1], quest_requirement[realIdx][2]);
                    Char.GiveItem(player, quest_reward[realIdx][1], quest_reward[realIdx][2]);
                    NLG.SystemMessage(player, "[系統]成功完成委託：" .. quest_name[realIdx]);
                end
            end
            return;
        elseif _select == CONST.按钮_否 then
            page = tmpPage;
        end

        -- 分頁按鈕邏輯
        local warpPage = page;
        if _select == CONST.BUTTON_下一页 then warpPage = warpPage + 1;
        elseif _select == CONST.BUTTON_上一页 then warpPage = warpPage - 1;
        elseif _select == CONST.按钮_关闭 then return;
        end

        if _select > 0 then
            -- 顯示清單分頁
            local winButton = CONST.BUTTON_关闭;
            if totalPage > 1 then
                if warpPage <= 1 then winButton = CONST.BUTTON_下取消;
                elseif warpPage >= totalPage then winButton = CONST.BUTTON_上取消;
                else winButton = CONST.BUTTON_上下取消; end
            end

            local winMsg = "1\\n　　　　　　　【冒險者公會委託板】\\n";
            local startIdx = (warpPage - 1) * 8 + 1;
            local endIdx = math.min(warpPage * 8, totalAvailable);

            for i = startIdx, endIdx do
                local rIdx = availableList[i];
                winMsg = winMsg .. "　　◎委託 " .. i .. "　" .. quest_name[rIdx] .. "\\n"
            end
            NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, winButton, warpPage, winMsg);
        else
            tmpPage = warpPage;
            -- 點選特定委託進入詳情頁面
            local selectionIndex = (warpPage - 1) * 8 + column;
            local realIdx = availableList[selectionIndex];
            if realIdx then
                local msg = getQuestDetailMsg(realIdx);
                NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.按钮_是否, 1000 + realIdx, msg);
            end
        end
    end)

    -- NPC 點擊觸發
    self:NPC_regTalkedEvent(self.BoardNPC, function(npc, player)
        if (NLG.CanTalk(npc, player)) then
            local availableList = getAvailableQuests(player);
            local msg = "1\\n　　　　　　　【冒險者公會委託板】\\n";
            
            for i, rIdx in ipairs(availableList) do
                if i <= 8 then
                    msg = msg .. "　　◎委託 " .. i .. "　" .. quest_name[rIdx] .. "\\n"
                end
            end
            
            local winButton = (#availableList > 8) and CONST.BUTTON_下取消 or CONST.BUTTON_关闭;
            NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, winButton, 1, msg);
        end
    end)
end

--- 卸载模块钩子
function Module:onUnload()
    self:logInfo('unload')
end

return Module;
