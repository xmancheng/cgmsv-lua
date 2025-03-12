---模块类
local Module = ModuleBase:createModule(forgingPlans2)

--词条技能
local player_skillAffixes_list = {300,301,302,303};		--skill詞綴編號列表
local skillAffixes_info = {}
skillAffixes_info[300] = "物理技能10%使出迴旋擊";
skillAffixes_info[301] = "迴旋擊的傷害增加5%";
skillAffixes_info[302] = "物理技能2%造成麻痺";
skillAffixes_info[303] = "攻擊魔法5%重強度詠唱";


--分类自行添加
local forging_plan_name = {};		--表单显示道具名称
local forging_plan_offering = {};	--最多三组的材料设置{道具编号,数量}
local forging_plan_item = {};		--制作设计图(数量1)
local forging_plan_gold = {};		--需求金币
local forging_plan_thing = {};		--10组成品制作结果(连动成功率)
local forging_plan_grade = {};		--品质(随机词条数目0~3)
--
forging_plan_name[1] = "芙蕾亞之劍LV2";
forging_plan_offering[1] = {{70006,1},{70058,1},{70059,10}};
forging_plan_item[1] = {70053};
forging_plan_gold[1] =250000;
forging_plan_thing[1] = {70007,70007,70007,70007,70007,70007,70007,70007,70007,70007};
forging_plan_grade[1] =2;

forging_plan_name[2] = "芙蕾亞之斧LV2";
forging_plan_offering[2] = {{70009,1},{70058,1},{70059,10}};
forging_plan_item[2] = {70053};
forging_plan_gold[2] =250000;
forging_plan_thing[2] = {70010,70010,70010,70010,70010,70010,70010,70010,70010,70010};
forging_plan_grade[2] =2;

forging_plan_name[3] = "芙蕾亞之槍LV2";
forging_plan_offering[3] = {{70012,1},{70058,1},{70059,10}};
forging_plan_item[3] = {70053};
forging_plan_gold[3] =250000;
forging_plan_thing[3] = {70013,70013,70013,70013,70013,70013,70013,70013,70013,70013};
forging_plan_grade[3] =2;

forging_plan_name[4] = "芙蕾亞之弓LV2";
forging_plan_offering[4] = {{70015,1},{70058,1},{70059,10}};
forging_plan_item[4] = {70053};
forging_plan_gold[4] =250000;
forging_plan_thing[4] = {70016,70016,70016,70016,70016,70016,70016,70016,70016,70016};
forging_plan_grade[4] =2;

forging_plan_name[5] = "芙蕾亞之杖LV2";
forging_plan_offering[5] = {{70018,1},{70058,1},{70059,10}};
forging_plan_item[5] = {70053};
forging_plan_gold[5] =250000;
forging_plan_thing[5] = {70019,70019,70019,70019,70019,70019,70019,70019,70019,70019};
forging_plan_grade[5] =2;

forging_plan_name[6] = "芙蕾亞迴力鏢LV2";
forging_plan_offering[6] = {{70021,1},{70058,1},{70059,10}};
forging_plan_item[6] = {70053};
forging_plan_gold[6] =250000;
forging_plan_thing[6] = {70022,70022,70022,70022,70022,70022,70022,70022,70022,70022};
forging_plan_grade[6] =2;

forging_plan_name[7] = "芙蕾亞小刀LV2";
forging_plan_offering[7] = {{70024,1},{70058,1},{70059,10}}
forging_plan_item[7] = {70053};
forging_plan_gold[7] =250000;
forging_plan_thing[7] = {70025,70025,70025,70025,70025,70025,70025,70025,70025,70025};
forging_plan_grade[7] =2;

forging_plan_name[8] = "芙蕾亞之拳LV2";
forging_plan_offering[8] = {{70027,1},{70058,1},{70059,10}}
forging_plan_item[8] = {70053};
forging_plan_gold[8] =250000;
forging_plan_thing[8] = {70028,70028,70028,70028,70028,70028,70028,70028,70028,70028};
forging_plan_grade[8] =2;

forging_plan_name[9] = "芙蕾亞之帽LV2";
forging_plan_offering[9] = {{70030,1},{70058,1},{70059,10}}
forging_plan_item[9] = {70056};
forging_plan_gold[9] =250000;
forging_plan_thing[9] = {70031,70031,70031,70031,70031,70031,70031,70031,70031,70031};
forging_plan_grade[9] =2;

forging_plan_name[10] = "芙蕾亞之服LV2";
forging_plan_offering[10] = {{70033,1},{70058,1},{70059,10}}
forging_plan_item[10] = {70056};
forging_plan_gold[10] =250000;
forging_plan_thing[10] = {70034,70034,70034,70034,70034,70034,70034,70034,70034,70034};
forging_plan_grade[10] =2;

forging_plan_name[11] = "芙蕾亞之袍LV2";
forging_plan_offering[11] = {{70036,1},{70058,1},{70059,10}}
forging_plan_item[11] = {70056};
forging_plan_gold[11] =250000;
forging_plan_thing[11] = {70037,70037,70037,70037,70037,70037,70037,70037,70037,70037};
forging_plan_grade[11] =2;

forging_plan_name[12] = "芙蕾亞鎧甲LV2";
forging_plan_offering[12] = {{70039,1},{70058,1},{70059,10}}
forging_plan_item[12] = {70056};
forging_plan_gold[12] =250000;
forging_plan_thing[12] = {70040,70040,70040,70040,70040,70040,70040,70040,70040,70040};
forging_plan_grade[12] =2;

forging_plan_name[13] = "芙蕾亞之盔LV2";
forging_plan_offering[13] = {{70042,1},{70058,1},{70059,10}}
forging_plan_item[13] = {70056};
forging_plan_gold[13] =250000;
forging_plan_thing[13] = {70043,70043,70043,70043,70043,70043,70043,70043,70043,70043};
forging_plan_grade[13] =2;

forging_plan_name[14] = "芙蕾亞之靴LV2";
forging_plan_offering[14] = {{70046,1},{70058,1},{70059,10}}
forging_plan_item[14] = {70056};
forging_plan_gold[14] =250000;
forging_plan_thing[14] = {70047,70047,70047,70047,70047,70047,70047,70047,70047,70047};
forging_plan_grade[14] =2;

forging_plan_name[15] = "芙蕾亞之鞋LV2";
forging_plan_offering[15] = {{70049,1},{70058,1},{70059,10}}
forging_plan_item[15] = {70056};
forging_plan_gold[15] =250000;
forging_plan_thing[15] = {70050,70050,70050,70050,70050,70050,70050,70050,70050,70050};
forging_plan_grade[15] =2;
-------------------------------------------------
local function calcWarp()
  local page = math.modf(#forging_plan_name / 8) + 1
  local remainder = math.fmod(#forging_plan_name, 8)
  return page, remainder
end

--远程按钮UI呼叫
function Module:forgingPlansInfo2(npc, player)
          local winButton = CONST.BUTTON_关闭;
          local msg = "1\\n　　　　　　　　【武防提煉鍛造】\\n"
          for i = 1,8 do
             msg = msg .. "　　◎項目 "..i.."　".. forging_plan_name[i] .. "\\n"
             if (i>=8) then
                 winButton = CONST.BUTTON_下取消;
             end
          end
          NLG.ShowWindowTalked(player, self.forgingerNPC2, CONST.窗口_选择框, winButton, 1, msg);
end

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load');
  self.forgingerNPC2 = self:NPC_createNormal('LV2武防提煉鍛造', 231136, { x = 216, y = 78, mapType = 0, map = 1000, direction = 0 });
  self:NPC_regWindowTalkedEvent(self.forgingerNPC2, function(npc, player, _seqno, _select, _data)
    local column = tonumber(_data)
    local page = tonumber(_seqno)
    local warpPage = page;
    local winMsg = "1\\n　　　　　　　　【武防提煉鍛造】\\n"
    local winButton = CONST.BUTTON_关闭;
    local totalPage, remainder = calcWarp()
    --上页16 下页32 关闭/取消2
    if _select > 0 then
      if _select == CONST.按钮_确定 then
          if (page>=1001) then
              local seqno = page - 1000;
              local msg = "　　　　　　　　【武防提煉鍛造】\\n"
                                  .. "　　　$1需要以下所有材料才能進行提煉鍛造\\n$5"
              local msg = msg .. forgingOfferingInfo(seqno)
              NLG.ShowWindowTalked(player, self.forgingerNPC2, CONST.窗口_信息框, CONST.按钮_是否, 2000+seqno, msg);
              return
          else
              return
          end
      elseif _select == CONST.按钮_关闭 then
          if (page>=1001) then
              local winButton = CONST.BUTTON_关闭;
              local msg = "1\\n　　　　　　　　【武防提煉鍛造】\\n"
              for i = 1,8 do
                 msg = msg .. "　　◎項目 "..i.."　".. forging_plan_name[i] .. "\\n"
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
              local seqno = page - 2000;
              forgingMutation(seqno,player)
              return
          else
              return
          end
      elseif _select == CONST.按钮_否 then
          if (page>=2001) then
              local count = page - 2000;
              local msg = "　　　　　　　　【武防提煉鍛造】\\n"
              local msg = msg .. forgingGoalInfo(count);
              NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.按钮_确定关闭, 1000+count, msg);
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
      local count = 8 * (warpPage - 1)
      if warpPage == totalPage then
        for i = 1 + count, remainder + count do
            winMsg = winMsg .. "　　◎項目 "..i.."　".. forging_plan_name[i] .. "\\n"
        end
      else
        for i = 1 + count, 8 + count do
            winMsg = winMsg .. "　　◎項目 "..i.."　".. forging_plan_name[i] .. "\\n"
        end
      end
      NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, winButton, warpPage, winMsg);
    else
      local count = 8 * (warpPage - 1) + column
      --print(count)
      local msg = "　　　　　　　　【武防提煉鍛造】\\n"
      local msg = msg .. forgingGoalInfo(count);
      NLG.ShowWindowTalked(player, self.forgingerNPC2, CONST.窗口_信息框, CONST.按钮_确定关闭, 1000+count, msg);
    end
  end)
  self:NPC_regTalkedEvent(self.forgingerNPC2, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local winButton = CONST.BUTTON_关闭;
      local msg = "1\\n　　　　　　　　【武防提煉鍛造】\\n"
      for i = 1,8 do
         msg = msg .. "　　◎項目 "..i.."　".. forging_plan_name[i] .. "\\n"
         if (i>=8) then
             winButton = CONST.BUTTON_下取消;
         end
      end
      NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, winButton, 1, msg);
    end
    return
  end)
end

---------------------------------------------------------------------------------------------------------------
--目标信息
function forgingGoalInfo(count)
      local ItemsetIndex_Goal = Data.ItemsetGetIndex(forging_plan_thing[count][10]);
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
      return msg;
end

--祭品信息
function forgingOfferingInfo(seqno)
              local msg = "";
              for i = 1,#forging_plan_offering[seqno] do
                  local ItemsetIndex_i = Data.ItemsetGetIndex(forging_plan_offering[seqno][i][1]);
                  local ItemNum_i = Data.ItemsetGetIndex(forging_plan_offering[seqno][i][2]);
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
              local Gold = forging_plan_gold[seqno];
              local ItemsetIndex = Data.ItemsetGetIndex(forging_plan_item[seqno][1]);
              local Item_name= Data.ItemsetGetData( ItemsetIndex, CONST.ITEMSET_TRUENAME);
              local probRate = prob(seqno,forging_plan_thing[seqno][10]);
              local msg = msg .. "\\n\\n\\n\\n　$5設計圖: ".. Item_name .. "1個" .. "　　$5魔幣: " .. Gold .. " G\\n"
                                              .. "　$4成功機率: ".. probRate .. "%" .. "　　"
      return msg;
end

--提炼锻造执行
function forgingMutation(seqno,player)
              if (Char.ItemNum(player, forging_plan_item[seqno][1])==0) then
                  NLG.SystemMessage(player,"[系統]缺少鍛造的設計圖。");
                  return
              end
              if (Char.GetData(player, CONST.对象_金币)<forging_plan_gold[seqno]) then
                  NLG.SystemMessage(player,"[系統]改造所需金幣不足。");
                  return
              end
              for i = 1,#forging_plan_offering[seqno] do
                  local itemIndex = Char.HaveItem(player, forging_plan_offering[seqno][i][1]);
                  if (itemIndex>=0) then
                      local itemNum = Char.ItemNum(player,forging_plan_offering[seqno][i][1]);
                      if (itemNum < forging_plan_offering[seqno][i][2]) then
                          NLG.SystemMessage(player,"[系統]鍛造所需材料數量不足。");
                          return
                      end
                  else
                      NLG.SystemMessage(player,"[系統]缺少鍛造所需材料。");
                      return
                  end
              end
              Char.DelItem(player, forging_plan_item[seqno][1], 1);
              Char.AddGold(player, -forging_plan_gold[seqno]);
              local randCatch= NLG.Rand(1, #forging_plan_thing[seqno] );
              for i = 1,#forging_plan_offering[seqno] do
                  Char.DelItem(player, forging_plan_offering[seqno][i][1], forging_plan_offering[seqno][i][2]);
              end
              local newSlot = Char.GetEmptyItemSlot(player);				--自创接口
              Char.GiveItem(player,forging_plan_thing[seqno][randCatch],1);
              --词条赋予
              local WeaponIndex = Char.GetItemIndex(player,newSlot);
              Item.SetData(WeaponIndex, CONST.道具_子参二, 40);
              local skillId="";
              local grade = forging_plan_grade[seqno];
              if (grade>0) then
                for i=1,grade do
                  local rand = NLG.Rand(1,#player_skillAffixes_list);
                  if i<grade then
                    skillId = skillId .. player_skillAffixes_list[rand]..",";
                  else
                    skillId = skillId .. player_skillAffixes_list[rand];
                  end
                end
                Item.SetData(WeaponIndex, CONST.道具_USEFUNC, skillId);
                Item.UpItem(player, newSlot);
                NLG.UpChar(player);
              else
              end
end

--目标成功率计算
function prob(count,id)
  for i=1,10 do
      if (forging_plan_thing[count][i]==id) then
          local prob = ( (11-i)/10 )*100;
          return prob;
      end
  end
  return -1;
end

--空道具格(制作出的新武器位置)
function Char.GetEmptyItemSlot(charIndex)
  if not Char.IsValidCharIndex(charIndex) then
    return -1;
  end
  if Char.GetData(charIndex, CONST.CHAR_类型) ~= CONST.对象类型_人 then
    return -1;
  end
  for i = 8, 27 do
    if Char.GetItemIndex(charIndex, i) == -2 then
      return i;
    end
  end
  return -2;
end

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

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
