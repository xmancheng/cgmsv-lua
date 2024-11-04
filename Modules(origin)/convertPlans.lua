---模块类
local Module = ModuleBase:createModule(convertPlans)

--分类自行添加
local convert_plan_name = {};
local convert_plan_offering = {};
local convert_plan_item = {};
local convert_plan_gold = {};
local convert_plan_pet = {};
--
convert_plan_name[1] = "《航海王》索隆";
convert_plan_offering[1] = {321,401,31};
convert_plan_item[1] = {70261};
convert_plan_gold[1] =5000;
convert_plan_pet[1] = {321,321,321,321,321,404000,404000,404000,404000,404000};

convert_plan_name[2] = "《航海王》香吉士";
convert_plan_offering[2] = {314,421,831};
convert_plan_item[2] = {70261};
convert_plan_gold[2] =5000;
convert_plan_pet[2] = {314,314,314,314,314,404001,404001,404001,404001,404001};

convert_plan_name[3] = "《航海王》娜美";
convert_plan_offering[3] = {3,255,522};
convert_plan_item[3] = {70263};
convert_plan_gold[3] =15000;
convert_plan_pet[3] = {3,3,3,3,3,404002,404002,404002,404002,404002};

convert_plan_name[4] = "《航海王》魯夫Gear4";
convert_plan_offering[4] = {503,801,104};
convert_plan_item[4] = {70264};
convert_plan_gold[4] =25000;
convert_plan_pet[4] = {503,503,503,503,503,503,503,404003,404003,404003};

convert_plan_name[5] = "《火影忍者》鳴人";
convert_plan_offering[5] = {5,833,101};
convert_plan_item[5] = {70263};
convert_plan_gold[5] =5000;
convert_plan_pet[5] = {5,5,5,5,5,404005,404005,404005,404005,404005};

convert_plan_name[6] = "《火影忍者》佐助";
convert_plan_offering[6] = {114,11,602};
convert_plan_item[6] = {70259};
convert_plan_gold[6] =5000;
convert_plan_pet[6] = {114,114,114,114,114,404006,404006,404006,404006,404006};

convert_plan_name[7] = "《火影忍者》宇智波鼬";
convert_plan_offering[7] = {402,325,23};
convert_plan_item[7] = {70262};
convert_plan_gold[7] =15000;
convert_plan_pet[7] = {402,402,402,402,402,402,404010,404010,404010,404010};

convert_plan_name[8] = "《火影忍者》綱手";
convert_plan_offering[8] = {634,722,502};
convert_plan_item[8] = {70265};
convert_plan_gold[8] =15000;
convert_plan_pet[8] = {634,634,634,634,634,634,404009,404009,404009,404009};

convert_plan_name[9] = "《七龍珠》超賽三";
convert_plan_offering[9] = {814,1,21603};
convert_plan_item[9] = {70257};
convert_plan_gold[9] =25000;
convert_plan_pet[9] = {814,814,814,814,814,814,814,404021,404021,404021};

convert_plan_name[10] = "《七龍珠》18號";
convert_plan_offering[10] = {835,2,21604};
convert_plan_item[10] = {70257};
convert_plan_gold[10] =25000;
convert_plan_pet[10] = {835,835,835,835,835,835,835,404022,404022,404022};

convert_plan_name[11] = "《格鬥天王 XIII》八神庵";
convert_plan_offering[11] = {723,122,523};
convert_plan_item[11] = {70258};
convert_plan_gold[11] =25000;
convert_plan_pet[11] = {723,723,723,723,723,723,723,404018,404018,404018};

convert_plan_name[12] = "《格鬥天王 XIII》不知火舞";
convert_plan_offering[12] = {601,803,203};
convert_plan_item[12] = {70265};
convert_plan_gold[12] =25000;
convert_plan_pet[12] = {601,601,601,601,601,601,601,404019,404019,404019};
-------------------------------------------------
local function calcWarp()
  local page = math.modf(#convert_plan_name / 8) + 1
  local remainder = math.fmod(#convert_plan_name, 8)
  return page, remainder
end

--远程按钮UI呼叫
function Module:convertPlansInfo(npc, player)
          local winButton = CONST.BUTTON_关闭;
          local msg = "1\\n　　　　　　　　【寵物異變改造】\\n"
          for i = 1,8 do
             msg = msg .. "　　◎項目 "..i.."　".. convert_plan_name[i] .. "\\n"
             if (i>=8) then
                 winButton = CONST.BUTTON_下取消;
             end
          end
          NLG.ShowWindowTalked(player, self.converterNPC, CONST.窗口_选择框, winButton, 1, msg);
end

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load');
  self.converterNPC = self:NPC_createNormal('寵物異變改造', 14682, { x = 38, y = 31, mapType = 0, map = 777, direction = 6 });
  self:NPC_regWindowTalkedEvent(self.converterNPC, function(npc, player, _seqno, _select, _data)
    local column = tonumber(_data)
    local page = tonumber(_seqno)
    local warpPage = page;
    local winMsg = "1\\n　　　　　　　　【寵物異變改造】\\n"
    local winButton = CONST.BUTTON_关闭;
    local totalPage, remainder = calcWarp()
    --上页16 下页32 关闭/取消2
    if _select > 0 then
      if _select == CONST.按钮_确定 then
          if (page>=1001) then
              local seqno = page - 1000;
              local msg = "　　　　　　　　【寵物異變改造】\\n"
                                  .. "　　　$1需要以下所有材料才能進行異變改造\\n$5"
              local msg = msg .. convertOfferingInfo(seqno)
              NLG.ShowWindowTalked(player, self.converterNPC, CONST.窗口_信息框, CONST.按钮_是否, 2000+seqno, msg);
              return
          else
              return
          end
      elseif _select == CONST.按钮_关闭 then
          if (page>=1001) then
              local winButton = CONST.BUTTON_关闭;
              local msg = "1\\n　　　　　　　　【寵物異變改造】\\n"
              for i = 1,8 do
                 msg = msg .. "　　◎項目 "..i.."　".. convert_plan_name[i] .. "\\n"
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
              convertMutation(seqno,player)
              return
          else
              return
          end
      elseif _select == CONST.按钮_否 then
          if (page>=2001) then
              local count = page - 2000;
              local msg = "　　　　　　　　【寵物異變改造】\\n"
              local msg = msg .. convertGoalInfo(count);
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
            winMsg = winMsg .. "　　◎項目 "..i.."　".. convert_plan_name[i] .. "\\n"
        end
      else
        for i = 1 + count, 8 + count do
            winMsg = winMsg .. "　　◎項目 "..i.."　".. convert_plan_name[i] .. "\\n"
        end
      end
      NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, winButton, warpPage, winMsg);
    else
      local count = 8 * (warpPage - 1) + column
      --print(count)
      local msg = "　　　　　　　　【寵物異變改造】\\n"
      local msg = msg .. convertGoalInfo(count);
      NLG.ShowWindowTalked(player, self.converterNPC, CONST.窗口_信息框, CONST.按钮_确定关闭, 1000+count, msg);
    end
  end)
  self:NPC_regTalkedEvent(self.converterNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local winButton = CONST.BUTTON_关闭;
      local msg = "1\\n　　　　　　　　【寵物異變改造】\\n"
      for i = 1,8 do
         msg = msg .. "　　◎項目 "..i.."　".. convert_plan_name[i] .. "\\n"
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
function convertGoalInfo(count)
      local EnemyDataIndex_Goal = Data.EnemyGetDataIndex(convert_plan_pet[count][10]);
      local enemyBaseId_Goal = Data.EnemyGetData(EnemyDataIndex_Goal, CONST.Enemy_Base编号);
      local EnemyBaseDataIndex_Goal = Data.EnemyBaseGetDataIndex(enemyBaseId_Goal);
      local Goal_name = Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_名字);
      local Goal_DataPos_3 = Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_种族);
      local Goal_DataPos_3 = Tribe(Goal_DataPos_3);
      local Goal_DataPos_4 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_体力);
      local Goal_DataPos_5 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_力量);
      local Goal_DataPos_6 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_强度);
      local Goal_DataPos_7 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_速度);
      local Goal_DataPos_8 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, 8);
      local Goal_DataPos_12 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_命中);
      local Goal_DataPos_13 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_必杀);
      local Goal_DataPos_14 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_地属性);
      local Goal_DataPos_15 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_水属性);
      local Goal_DataPos_16 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_火属性);
      local Goal_DataPos_17 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_风属性);
      local Goal_DataPos_18 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_抗毒);
      local Goal_DataPos_19 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_抗醉);
      local Goal_DataPos_20 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_抗睡);
      local Goal_DataPos_21 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_抗混乱);
      local Goal_DataPos_22 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_抗石化);
      local Goal_DataPos_23 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_抗遗忘);
      local Goal_DataPos_26 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_闪躲);
      local Goal_DataPos_27 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_反击);
      local Goal_DataPos_28 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_技能栏);
      local Goal_DataPos_29 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_形象);
      local imageText = "@g,"..Goal_DataPos_29..",2,8,6,0@"
      local Goal_DataPos_35 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_出生技能1);
      local Goal_DataPos_36 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_出生技能2);
      local Goal_DataPos_37 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_出生技能3);
      local Goal_DataPos_38 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_出生技能4);
      local Goal_DataPos_39 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_出生技能5);
      local Goal_DataPos_40 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_出生技能6);
      local Goal_DataPos_41 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_出生技能7);
      local Goal_DataPos_42 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_出生技能8);
      local Goal_DataPos_43 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_出生技能9);
      local Goal_DataPos_44 =Data.EnemyBaseGetData(EnemyBaseDataIndex_Goal, CONST.EnemyBase_出生技能10);
      local msg = imageText .. "　　$4".. Goal_name .. "\\n"
                         .. "　　　　　　　" .. "$1體力 ".. Goal_DataPos_4+2 .."　" .. "$8必殺 ".. Goal_DataPos_13 .."　" .. "$8反擊 ".. Goal_DataPos_27 .."\\n"
                         .. "　　　　　　　" .. "$1力量 ".. Goal_DataPos_5+2 .."　" .. "$8命中 ".. Goal_DataPos_12 .."　" .. "$8閃躲 ".. Goal_DataPos_26 .."\\n"
                         .. "　　　　　　　" .. "$1強度 ".. Goal_DataPos_6+2 .."　" .. "$2抗毒 ".. Goal_DataPos_18 .."　" .. "$2抗醉 ".. Goal_DataPos_19 .."\\n"
                         .. "　　　　　　　" .. "$1速度 ".. Goal_DataPos_7+2 .."　" .. "$2抗睡 ".. Goal_DataPos_20 .."　" .. "$2抗混 ".. Goal_DataPos_21 .."\\n"
                         .. "　　　　　　　" .. "$1魔法 ".. Goal_DataPos_8+2 .."　" .. "$2抗石 ".. Goal_DataPos_22 .."　" .. "$2抗忘 ".. Goal_DataPos_23 .."\\n"
                         .. "　　　　　　　" .. "$5地 ".. Goal_DataPos_14/10 .."　" .."$5水 ".. Goal_DataPos_15/10 .."　" .."$5火 ".. Goal_DataPos_16/10 .."　" .."$5風 ".. Goal_DataPos_17/10 .."\\n"
                         .. "　　　　　　　" .. "$9種族 ".. Goal_DataPos_3 .."　" .. "$9技能格 ".. Goal_DataPos_28 .."\\n"
      return msg;
end

--祭品信息
function convertOfferingInfo(seqno)
              local msg = "";
              for i = 1,#convert_plan_offering[seqno] do
                  local EnemyDataIndex_i = Data.EnemyGetDataIndex(convert_plan_offering[seqno][i]);
                  local enemyBaseId_i = Data.EnemyGetData(EnemyDataIndex_i, CONST.Enemy_Base编号);
                  local EnemyBaseDataIndex_i = Data.EnemyBaseGetDataIndex(enemyBaseId_i);
                  local offering_name_i = Data.EnemyBaseGetData(EnemyBaseDataIndex_i, CONST.EnemyBase_名字);
                  local offering_image_i = Data.EnemyBaseGetData(EnemyBaseDataIndex_i, CONST.EnemyBase_形象);
                  local offering_image_ix = 3 + 7*(i-1);
                  local imageText_i = "@g,"..offering_image_i..","..offering_image_ix..",6,4,0@"
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
                  msg = msg .. spaceMsg .. offering_name_i .. "Lv1" .. spaceMsg .. imageText_i
              end
              local Gold = convert_plan_gold[seqno];
              local ItemsetIndex = Data.ItemsetGetIndex(convert_plan_item[seqno][1]);
              local Item_name= Data.ItemsetGetData( ItemsetIndex, CONST.ITEMSET_TRUENAME);
              local probRate = prob(seqno,convert_plan_pet[seqno][10]);
              local msg = msg .. "\\n\\n\\n\\n\\n　$5道具: ".. Item_name .. "1個" .. "　　$5魔幣: " .. Gold .. " G\\n"
                                              .. "　$4成功機率: ".. probRate .. "%" .. "　　$9失敗殘念品: 第一順位之寵物"
      return msg;
end

--异变改造执行
function convertMutation(seqno,player)
              if (Char.ItemNum(player, convert_plan_item[seqno][1])==0) then
                  NLG.SystemMessage(player,"[系統]缺少改造的設計圖。");
                  return
              end
              if (Char.GetData(player, CONST.对象_金币)<convert_plan_gold[seqno]) then
                  NLG.SystemMessage(player,"[系統]改造所需金幣不足。");
                  return
              end
              for i = 1,#convert_plan_offering[seqno] do
                  local petSlot = Char.HavePet(player, convert_plan_offering[seqno][i]);
                  if (petSlot>=0) then
                      local petIndex = Char.GetPet(player,petSlot);
                      if (Char.GetData(petIndex,CONST.对象_等级)>=2) then
                          NLG.SystemMessage(player,"[系統]改造所需寵物非Lv1。");
                          return
                      end
                  else
                      NLG.SystemMessage(player,"[系統]缺少改造所需寵物。");
                      return
                  end
              end
              Char.DelItem(player, convert_plan_item[seqno][1], 1);
              Char.AddGold(player, -convert_plan_gold[seqno]);
              local randCatch= NLG.Rand(1, #convert_plan_pet[seqno] );
              for i = 1,#convert_plan_offering[seqno] do
                  Char.DelPet(player, convert_plan_offering[seqno][i], 1, 1);
              end
              Char.GivePet(player,convert_plan_pet[seqno][randCatch],0);
end

--目标成功率计算
function prob(count,id)
  for i=1,10 do
      if (convert_plan_pet[count][i]==id) then
          local prob = ( (11-i)/10 )*100;
          return prob;
      end
  end
  return -1;
end

--种族字符串转换
function Tribe(Tribe)
  if Tribe==0 then
    return "人型系"
  elseif Tribe == 1 then
    return "龍族系"
  elseif Tribe == 2 then
    return "不死系"
  elseif Tribe == 3 then
    return "飛行系"
  elseif Tribe == 4 then
    return "昆蟲系"
  elseif Tribe == 5 then
    return "植物系"
  elseif Tribe == 6 then
    return "野獸系"
  elseif Tribe == 7 then
    return "特殊系"
  elseif Tribe == 8 then
    return "金屬系"
  elseif Tribe == 9 then
    return "邪魔系"
  elseif Tribe == 10 then
    return "神族系"
  elseif Tribe == 11 then
    return "精靈系"
  end
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
