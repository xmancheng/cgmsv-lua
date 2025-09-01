---模块类
local Module = ModuleBase:createModule(sewingPlans)

--词条技能
local player_skillAffixes_list = {500,501,502,503};		--skill詞綴編號列表
local skillAffixes_info = {}
skillAffixes_info[500] = "回合結束時5%極巨化";
skillAffixes_info[501] = "血量20%以下攻擊增加10%";
skillAffixes_info[502] = "血量35-65%防禦增加10%";
skillAffixes_info[503] = "血量85%以上速度增加10%";

--分类自行添加
local sewing_plan_name = {};		--表单显示道具名称
local sewing_plan_offering = {};	--最多三组的材料设置{道具编号,数量}
local sewing_plan_item = {};		--制作设计图(数量5)
local sewing_plan_gold = {};		--需求金币
local sewing_plan_thing = {};		--10组成品制作结果(连动成功率)
local sewing_plan_grade = {};		--品质(随机词条数目0~3)
--
sewing_plan_name[1] = "《寵物水晶》幽冥礦核";
sewing_plan_offering[1] = {{66167,20},{66176,20},{66192,20}};
sewing_plan_item[1] = {70250};
sewing_plan_gold[1] =5000;
sewing_plan_thing[1] = {69040,69040,69040,69040,69040,69040,69040,69040,69040,69040};
sewing_plan_grade[1] =3;

sewing_plan_name[2] = "《寵物水晶》炎燄赤晶";
sewing_plan_offering[2] = {{66169,20},{66177,20},{66194,20}};
sewing_plan_item[2] = {70251};
sewing_plan_gold[2] =5000;
sewing_plan_thing[2] = {69041,69041,69041,69041,69041,69041,69041,69041,69041,69041};
sewing_plan_grade[2] =3;

sewing_plan_name[3] = "《寵物水晶》湧潮靈晶";
sewing_plan_offering[3] = {{66171,20},{66178,20},{66196,20}};
sewing_plan_item[3] = {70252};
sewing_plan_gold[3] =5000;
sewing_plan_thing[3] = {69042,69042,69042,69042,69042,69042,69042,69042,69042,69042};
sewing_plan_grade[3] =3;

sewing_plan_name[4] = "《寵物水晶》翠綠魂藤";
sewing_plan_offering[4] = {{66173,20},{66179,20},{66198,20}};
sewing_plan_item[4] = {70253};
sewing_plan_gold[4] =5000;
sewing_plan_thing[4] = {69043,69043,69043,69043,69043,69043,69043,69043,69043,69043};
sewing_plan_grade[4] =3;

sewing_plan_name[5] = "《寵物水晶》雷煌晶核";
sewing_plan_offering[5] = {{66175,20},{66180,20},{66200,20}};
sewing_plan_item[5] = {70254};
sewing_plan_gold[5] =5000;
sewing_plan_thing[5] = {69044,69044,69044,69044,69044,69044,69044,69044,69044,69044};
sewing_plan_grade[5] =3;

sewing_plan_name[6] = "《寵物水晶》聖耀輝石";
sewing_plan_offering[6] = {{66194,20},{66196,20},{66200,20}};
sewing_plan_item[6] = {70255};
sewing_plan_gold[6] =5000;
sewing_plan_thing[6] = {69045,69045,69045,69045,69045,69045,69045,69045,69045,69045};
sewing_plan_grade[6] =3;

sewing_plan_name[7] = "《寵物水晶》虛空魔核";
sewing_plan_offering[7] = {{70251,5},{70252,5},{70253,5}};
sewing_plan_item[7] = {70256};
sewing_plan_gold[7] =5000;
sewing_plan_thing[7] = {69046,69046,69046,69046,69046,69046,69046,69046,69046,69046};
sewing_plan_grade[7] =3;
-----------------------------------------------------
local function calcWarp()
  local page = math.modf(#sewing_plan_name / 8) + 1
  local remainder = math.fmod(#sewing_plan_name, 8)
  return page, remainder
end

--远程按钮UI呼叫
function Module:sewingPlansInfo(npc, player)
          local winButton = CONST.BUTTON_关闭;
          local msg = "1\\n　　　　　　　　【寵物水晶製作】\\n"
          for i = 1,7 do
             msg = msg .. "　　◎項目 "..i.."　".. sewing_plan_name[i] .. "\\n"
             if (i>=8) then
                 winButton = CONST.BUTTON_下取消;
             end
          end
          NLG.ShowWindowTalked(player, self.sewingerNPC, CONST.窗口_选择框, winButton, 1, msg);
end

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load');
  --self:regCallback('ItemExpansionEvent', Func.bind(self.itemExpansionCallback, self))
  self.sewingerNPC = self:NPC_createNormal('寵物水晶製作', 99220, { x = 92, y = 110, mapType = 0, map = 80010, direction = 0 });
  self:NPC_regWindowTalkedEvent(self.sewingerNPC, function(npc, player, _seqno, _select, _data)
    local column = tonumber(_data)
    local page = tonumber(_seqno)
    local warpPage = page;
    local winMsg = "1\\n　　　　　　　　【寵物水晶製作】\\n"
    local winButton = CONST.BUTTON_关闭;
    local totalPage, remainder = calcWarp()
    --上页16 下页32 关闭/取消2
    if _select > 0 then
      if _select == CONST.按钮_确定 then
          if (page>=1001) then
              local seqno = page - 1000;
              local msg = "　　　　　　　　【寵物水晶製作】\\n"
                                  .. "　　　$1需要以下所有材料才能進行組合製作\\n$5"
              local msg = msg .. sewingOfferingInfo(seqno)
              NLG.ShowWindowTalked(player, self.sewingerNPC, CONST.窗口_信息框, CONST.按钮_是否, 2000+seqno, msg);
              return
          else
              return
          end
      elseif _select == CONST.按钮_关闭 then
          if (page>=1001) then
              local winButton = CONST.BUTTON_关闭;
              local msg = "1\\n　　　　　　　　【寵物水晶製作】\\n"
              for i = 1,7 do
                 msg = msg .. "　　◎項目 "..i.."　".. sewing_plan_name[i] .. "\\n"
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
              sewingMutation(seqno,player)
              return
          else
              return
          end
      elseif _select == CONST.按钮_否 then
          if (page>=2001) then
              local count = page - 2000;
              local msg = "　　　　　　　　【寵物水晶製作】\\n"
              local msg = msg .. sewingGoalInfo(count);
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
            winMsg = winMsg .. "　　◎項目 "..i.."　".. sewing_plan_name[i] .. "\\n"
        end
      else
        for i = 1 + count, 8 + count do
            winMsg = winMsg .. "　　◎項目 "..i.."　".. sewing_plan_name[i] .. "\\n"
        end
      end
      NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, winButton, warpPage, winMsg);
    else
      local count = 8 * (warpPage - 1) + column
      --print(count)
      local msg = "　　　　　　　　【寵物水晶製作】\\n"
      local msg = msg .. sewingGoalInfo(count);
      NLG.ShowWindowTalked(player, self.sewingerNPC, CONST.窗口_信息框, CONST.按钮_确定关闭, 1000+count, msg);
    end
  end)
  self:NPC_regTalkedEvent(self.sewingerNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local winButton = CONST.BUTTON_关闭;
      local msg = "1\\n　　　　　　　　【寵物水晶製作】\\n"
      for i = 1,7 do
         msg = msg .. "　　◎項目 "..i.."　".. sewing_plan_name[i] .. "\\n"
         if (i>=8) then
             winButton = CONST.BUTTON_下取消;
         end
      end
      NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, winButton, 1, msg);
    end
    return
  end)
end

--道具说明组合接口
function Module:itemExpansionCallback(itemIndex, type, msg, charIndex, slot)
  if (Item.GetData(itemIndex, CONST.道具_子参二)==41 and type==2) then
    --local boom_Skill = tostring(Item.GetData(itemIndex, CONST.道具_USEFUNC));
    local info="";
    local boom_Skill_x = string.split(Item.GetData(itemIndex, CONST.道具_USEFUNC),",");
    for i=1,#boom_Skill_x do
      local skillId = tonumber(boom_Skill_x[i]);
      if (skillId>0) then
        if (i<#boom_Skill_x) then
          info = info .. skillAffixes_info[skillId] .."\n";
        else
          info = info .. skillAffixes_info[skillId];
        end
      else
      end
    end
      
    local info = info .."\n".. msg;
    return info
  end
end

---------------------------------------------------------------------------------------------------------------
--目标信息
function sewingGoalInfo(count)
      local ItemsetIndex_Goal = Data.ItemsetGetIndex(sewing_plan_thing[count][10]);
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
                         .. "　　　　　　　" .. "$1攻擊 ".. Goal_DataPos_6 .."-50　" .. "$8必殺 ".. Goal_DataPos_11 .."　" .. "$8反擊 ".. Goal_DataPos_12 .."\\n"
                         .. "　　　　　　　" .. "$1防禦 ".. Goal_DataPos_7 .."-50　" .. "$8命中 ".. Goal_DataPos_13 .."　" .. "$8閃躲 ".. Goal_DataPos_14 .."\\n"
                         .. "　　　　　　　" .. "$1敏捷 ".. Goal_DataPos_8 .."-50　" .. "$2抗毒 ".. Goal_DataPos_20 .."　" .. "$2抗醉 ".. Goal_DataPos_23 .."\\n"
                         .. "　　　　　　　" .. "$1精神 ".. Goal_DataPos_9 .."-50　" .. "$2抗睡 ".. Goal_DataPos_21 .."　" .. "$2抗混 ".. Goal_DataPos_24 .."\\n"
                         .. "　　　　　　　" .. "$1恢復 ".. Goal_DataPos_10 .."-50　" .. "$2抗石 ".. Goal_DataPos_22 .."　" .. "$2抗忘 ".. Goal_DataPos_25 .."\\n"
                         .. "　　　　　　　" .. "$4生命 300-400　魔力 300-400 \\n"
                         .. "　　　　　　　" .. "$9類型 ".. Goal_DataPos_3 .."　" .. "$9等級 ".. Goal_DataPos_5 .."　" .. "$9耐久 ".. Goal_DataPos_4 .."\\n"
      return msg;
end

--祭品信息
function sewingOfferingInfo(seqno)
              local msg = "";
              for i = 1,#sewing_plan_offering[seqno] do
                  local ItemsetIndex_i = Data.ItemsetGetIndex(sewing_plan_offering[seqno][i][1]);
                  local ItemNum_i = Data.ItemsetGetIndex(sewing_plan_offering[seqno][i][2]);
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
              local Gold = sewing_plan_gold[seqno];
              local ItemsetIndex = Data.ItemsetGetIndex(sewing_plan_item[seqno][1]);
              local Item_name= Data.ItemsetGetData( ItemsetIndex, CONST.ITEMSET_TRUENAME);
              local probRate = prob(seqno,sewing_plan_thing[seqno][10]);
              local msg = msg .. "\\n\\n\\n\\n　$5核心原料: ".. Item_name .. "5個" .. "　　$5魔幣: " .. Gold .. " G\\n"
                                              .. "　$4成功機率: ".. probRate .. "%" .. "　　"
      return msg;
end

--製作执行
function sewingMutation(seqno,player)
              if (Char.ItemNum(player, sewing_plan_item[seqno][1])<5) then
                  NLG.SystemMessage(player,"[系統]缺少製作的核心原料。");
                  return
              end
              if (Char.GetData(player, CONST.对象_金币)<sewing_plan_gold[seqno]) then
                  NLG.SystemMessage(player,"[系統]製作所需金幣不足。");
                  return
              end
              for i = 1,#sewing_plan_offering[seqno] do
                  local itemIndex = Char.HaveItem(player, sewing_plan_offering[seqno][i][1]);
                  if (itemIndex>=0) then
                      local itemNum = Char.ItemNum(player,sewing_plan_offering[seqno][i][1]);
                      if (itemNum < sewing_plan_offering[seqno][i][2]) then
                          NLG.SystemMessage(player,"[系統]製作所需材料數量不足。");
                          return
                      end
                  else
                      NLG.SystemMessage(player,"[系統]缺少製作所需材料。");
                      return
                  end
              end
              Char.DelItem(player, sewing_plan_item[seqno][1], 5);
              Char.AddGold(player, -sewing_plan_gold[seqno]);
              local randCatch= NLG.Rand(1, #sewing_plan_thing[seqno] );
              for i = 1,#sewing_plan_offering[seqno] do
                  Char.DelItem(player, sewing_plan_offering[seqno][i][1], sewing_plan_offering[seqno][i][2]);
              end

              local newSlot = Char.GetEmptyItemSlot(player);				--自创接口
              Char.GiveItem(player,sewing_plan_thing[seqno][randCatch],1);
              --[[
              --词条赋予
              local WeaponIndex = Char.GetItemIndex(player,newSlot);
              Item.SetData(WeaponIndex, CONST.道具_子参二, 41);
              local skillId="";
              local grade = sewing_plan_grade[seqno];
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
              end]]
end

--目标成功率计算
function prob(count,id)
  for i=1,10 do
      if (sewing_plan_thing[count][i]==id) then
          local prob = ( (11-i)/10 )*100;
          return prob;
      end
  end
  return -1;
end

--空道具格(制作出的新道具位置)
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
