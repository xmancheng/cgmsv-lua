---模块类
local Module = ModuleBase:createModule(forgingPlans)

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
forging_plan_name[1] = "《武器》帝國重槍";
forging_plan_offering[1] = {{70204,50},{70194,10},{66668,5}};
forging_plan_item[1] = {72106};
forging_plan_gold[1] =5000;
forging_plan_thing[1] = {900204,900204,900204,900204,900204,900204,900204,900204,900204,900204};
forging_plan_grade[1] =3;

forging_plan_name[2] = "《武器》風鷹之弓";
forging_plan_offering[2] = {{70202,50},{70194,10},{66668,5}};
forging_plan_item[2] = {72106};
forging_plan_gold[2] =5000;
forging_plan_thing[2] = {900205,900205,900205,900205,900205,900205,900205,900205,900205,900205};
forging_plan_grade[2] =3;

forging_plan_name[3] = "《武器》風鷹飛鏢";
forging_plan_offering[3] = {{70202,50},{70194,10},{66668,5}};
forging_plan_item[3] = {72106};
forging_plan_gold[3] =5000;
forging_plan_thing[3] = {900206,900206,900206,900206,900206,900206,900206,900206,900206,900206};
forging_plan_grade[3] =3;

forging_plan_name[4] = "《武器》影武之斧";
forging_plan_offering[4] = {{70205,50},{70194,10},{66668,5}};
forging_plan_item[4] = {72106};
forging_plan_gold[4] =5000;
forging_plan_thing[4] = {900207,900207,900207,900207,900207,900207,900207,900207,900207,900207};
forging_plan_grade[4] =3;

forging_plan_name[5] = "《武器》影武短刀";
forging_plan_offering[5] = {{70205,50},{70194,10},{66668,5}};
forging_plan_item[5] = {72106};
forging_plan_gold[5] =5000;
forging_plan_thing[5] = {900208,900208,900208,900208,900208,900208,900208,900208,900208,900208};
forging_plan_grade[5] =3;

forging_plan_name[6] = "《武器》魔導之手";
forging_plan_offering[6] = {{70203,50},{70194,10},{66668,5}};
forging_plan_item[6] = {72106};
forging_plan_gold[6] =5000;
forging_plan_thing[6] = {900209,900209,900209,900209,900209,900209,900209,900209,900209,900209};
forging_plan_grade[6] =3;

forging_plan_name[7] = "《防具》龍騎士頭盔";
forging_plan_offering[7] = {{70204,50},{70194,10},{66668,2}};
forging_plan_item[7] = {72107};
forging_plan_gold[7] =5000;
forging_plan_thing[7] = {900210,900210,900210,900210,900210,900210,900210,900210,900210,900210};
forging_plan_grade[7] =2;

forging_plan_name[8] = "《防具》龍騎士鎧甲";
forging_plan_offering[8] = {{70204,50},{70194,10},{66668,2}};
forging_plan_item[8] = {72107};
forging_plan_gold[8] =5000;
forging_plan_thing[8] = {900211,900211,900211,900211,900211,900211,900211,900211,900211,900211};
forging_plan_grade[8] =2;

forging_plan_name[9] = " 《防具》龍騎士之靴";
forging_plan_offering[9] = {{70204,50},{70194,10},{66668,2}};
forging_plan_item[9] = {72107};
forging_plan_gold[9] =5000;
forging_plan_thing[9] = {900212,900212,900212,900212,900212,900212,900212,900212,900212,900212};
forging_plan_grade[9] =2;

forging_plan_name[10] = " 《防具》狩獵者之帽";
forging_plan_offering[10] = {{70202,50},{70194,10},{66668,2}};
forging_plan_item[10] = {72107};
forging_plan_gold[10] =5000;
forging_plan_thing[10] = {900213,900213,900213,900213,900213,900213,900213,900213,900213,900213};
forging_plan_grade[10] =2;

forging_plan_name[11] = " 《防具》狩獵者之服";
forging_plan_offering[11] = {{70202,50},{70194,10},{66668,2}};
forging_plan_item[11] = {72107};
forging_plan_gold[11] =5000;
forging_plan_thing[11] = {900214,900214,900214,900214,900214,900214,900214,900214,900214,900214};
forging_plan_grade[11] =2;

forging_plan_name[12] = " 《防具》狩獵者之鞋";
forging_plan_offering[12] = {{70202,50},{70194,10},{66668,2}};
forging_plan_item[12] = {72107};
forging_plan_gold[12] =5000;
forging_plan_thing[12] = {900215,900215,900215,900215,900215,900215,900215,900215,900215,900215};
forging_plan_grade[12] =2;

forging_plan_name[13] = " 《防具》追跡者之帽";
forging_plan_offering[13] = {{70205,50},{70194,10},{66668,2}};
forging_plan_item[13] = {72107};
forging_plan_gold[13] =5000;
forging_plan_thing[13] = {900216,900216,900216,900216,900216,900216,900216,900216,900216,900216};
forging_plan_grade[13] =2;

forging_plan_name[14] = " 《防具》追跡者之甲";
forging_plan_offering[14] = {{70205,50},{70194,10},{66668,2}};
forging_plan_item[14] = {72107};
forging_plan_gold[14] =5000;
forging_plan_thing[14] = {900217,900217,900217,900217,900217,900217,900217,900217,900217,900217};
forging_plan_grade[14] =2;

forging_plan_name[15] = " 《防具》追跡者之靴";
forging_plan_offering[15] = {{70205,50},{70194,10},{66668,2}};
forging_plan_item[15] = {72107};
forging_plan_gold[15] =5000;
forging_plan_thing[15] = {900218,900218,900218,900218,900218,900218,900218,900218,900218,900218};
forging_plan_grade[15] =2;

forging_plan_name[16] = " 《防具》聖別者之帽";
forging_plan_offering[16] = {{70203,50},{70194,10},{66668,2}};
forging_plan_item[16] = {72107};
forging_plan_gold[16] =5000;
forging_plan_thing[16] = {900219,900219,900219,900219,900219,900219,900219,900219,900219,900219};
forging_plan_grade[16] =2;

forging_plan_name[17] = " 《防具》聖別者之袍";
forging_plan_offering[17] = {{70203,50},{70194,10},{66668,2}};
forging_plan_item[17] = {72107};
forging_plan_gold[17] =5000;
forging_plan_thing[17] = {900220,900220,900220,900220,900220,900220,900220,900220,900220,900220};
forging_plan_grade[17] =2;

forging_plan_name[18] = " 《防具》聖別者之鞋";
forging_plan_offering[18] = {{70203,50},{70194,10},{66668,2}};
forging_plan_item[18] = {72107};
forging_plan_gold[18] =5000;
forging_plan_thing[18] = {900221,900221,900221,900221,900221,900221,900221,900221,900221,900221};
forging_plan_grade[18] =2;
-----------------------------------------------------
local function calcWarp()
  local page = math.modf(#forging_plan_name / 8) + 1
  local remainder = math.fmod(#forging_plan_name, 8)
  return page, remainder
end

--远程按钮UI呼叫
function Module:forgingPlansInfo(npc, player)
          local winButton = CONST.BUTTON_关闭;
          local msg = "1\\n　　　　　　　　【武防提煉鍛造】\\n"
          for i = 1,8 do
             msg = msg .. "　　◎項目 "..i.."　".. forging_plan_name[i] .. "\\n"
             if (i>=8) then
                 winButton = CONST.BUTTON_下取消;
             end
          end
          NLG.ShowWindowTalked(player, self.forgingerNPC, CONST.窗口_选择框, winButton, 1, msg);
end

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load');
  --self:regCallback('BattleActionTargetEvent',Func.bind(self.battleActionTargetCallback,self))
  --self:regCallback('DamageCalculateEvent',Func.bind(self.damageCalculateCallback,self))

  self:regCallback('ItemExpansionEvent', Func.bind(self.itemExpansionCallback, self))
  self.forgingerNPC = self:NPC_createNormal('武防提煉鍛造', 231137, { x = 73, y = 31, mapType = 0, map = 7351, direction = 0 });
  self:NPC_regWindowTalkedEvent(self.forgingerNPC, function(npc, player, _seqno, _select, _data)
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
              NLG.ShowWindowTalked(player, self.forgingerNPC, CONST.窗口_信息框, CONST.按钮_是否, 2000+seqno, msg);
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
      NLG.ShowWindowTalked(player, self.forgingerNPC, CONST.窗口_信息框, CONST.按钮_确定关闭, 1000+count, msg);
    end
  end)
  self:NPC_regTalkedEvent(self.forgingerNPC, function(npc, player)
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

--道具说明组合接口
function Module:itemExpansionCallback(itemIndex, type, msg, charIndex, slot)
  if (Item.GetData(itemIndex, CONST.道具_子参二)==40 and type==2) then
    --local boom_Skill = tostring(Item.GetData(itemIndex, CONST.道具_USEFUNC));
    local info="";
    local boom_Skill_x = string.split(Item.GetData(itemIndex, CONST.道具_USEFUNC),",");
    if boom_Skill_x~=nil then
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
	end
      
    local info = info .."\n".. msg;
    return info
  end
end
-----------------------------------------------------
--[[多重施法设置
local boom_skill_list = {3,266,267,268,269,270,271};	--多重施法的skill列表
local boom_dmg_rate = {0.75,0.50,0.25,0.01}	--不同重技能对应伤害削弱，类似于乱射
local boom_list = {}
local boom_cnt_num = {}
local boom_cnt_num_aoe = {}
local boom_tag = {}
--动作目标事件
function Module:battleActionTargetCallback(CharIndex, battleIndex, com1, com2, com3, tgl)
	--self:logDebug('battleActionTargetCallback', CharIndex, battleIndex, com1, com2, com3, tgl)
	if Char.IsPlayer(CharIndex) then
		if (com3==300) then		--挑拨迷惑
			if (NLG.Rand(1,4) >= 1) then
				local defCharIndex = Battle.GetPlayer(battleIndex,tgl[1]);
				Char.SetTempData(defCharIndex, '迷惑', 5);
				NLG.SystemMessage(-1, "[系統]發動挑撥敵人陷入迷惑");
			end
		end
		boom_list[CharIndex] = 0;
		boom_cnt_num[CharIndex] = 0;
		boom_cnt_num_aoe[CharIndex] = {};
		if #tgl > 1 then
			boom_tag[CharIndex] = 1
		else 
			boom_tag[CharIndex] = 0
		end
		local skillId = Tech.GetData(Tech.GetTechIndex(com3), CONST.TECH_SKILLID);
		if (CheckInTable(boom_skill_list, skillId)==true) then
			local skill_rate = calcRate(CharIndex,skillId)*10;		--词条皆为10%
			local com_name = Tech.GetData(Tech.GetTechIndex(com3), CONST.TECH_NAME);
			local boom_rate = math.random(1,100);
			local copy_num = 3;
			if (skill_rate >= boom_rate) then
				local msg_tag = CharIndex;
				local msg_name =  Char.GetData(CharIndex,CONST.对象_名字);
				NLG.SystemMessage(msg_tag, msg_name.."："..skill_rate.."%發動多重之"..copy_num.."倍 "..com_name);
				boom_list[CharIndex] = 1
				local return_tgl = copy_list(tgl,copy_num)	
				return 	return_tgl	
			end
		else
			return tgl
		end
    end
	return tgl
end
function copy_list(list, times)
    local new_list = {}
    for i = 1, times do
        for _, value in ipairs(list) do
			--local value = math.random(value-1,value+1)
            table.insert(new_list, value);
        end
    end
    return new_list
end
function calcRate(charIndex,skillId)
    local skill_rate=0;
    for slot=0,6 do
      local itemIndex = Char.GetItemIndex(charIndex,slot);
      if (itemIndex >= 0 and Item.GetData(itemIndex, CONST.道具_子参二)==40) then
        local boom_Skill_x = string.split(Item.GetData(itemIndex, CONST.道具_USEFUNC),",");
        for i=1,#boom_Skill_x do
          local skillId_x = tonumber(boom_Skill_x[i]);
          if (skillId_x>0 and skillId_x==skillId ) then
            skill_rate = skill_rate + 1;
          else
            skill_rate = skill_rate;
          end
        end
      end
    end
    return skill_rate
end

--伤害事件
function Module:damageCalculateCallback(CharIndex, DefCharIndex, OriDamage, Damage, BattleIndex, Com1, Com2, Com3, DefCom1, DefCom2, DefCom3, Flg, ExFlg)
	if (boom_list[CharIndex] == 1) then
		local cnt = 0
		if (boom_tag[CharIndex] == 1) then
			cnt = boom_cnt_num_aoe[CharIndex][DefCharIndex] or 0;
		elseif (boom_tag[CharIndex] == 0) then
			cnt = boom_cnt_num[CharIndex] or 0;
		else
			return Damage
		end
		local max_cnt = #boom_dmg_rate;

		local skill_Coeff = calcDamageCoeff(CharIndex)*0.05;
		local return_dmg = math.floor((boom_dmg_rate[cnt+1]+skill_Coeff)*Damage);
		if (boom_tag[CharIndex] == 1) then
			boom_cnt_num_aoe[CharIndex][DefCharIndex] = cnt + 1;
		elseif (boom_tag[CharIndex] == 0) then
			boom_cnt_num[CharIndex]  = cnt + 1;
		end		
		return return_dmg
	else
		return Damage
	end
end
function calcDamageCoeff(charIndex)
    local skill_Coeff=0;
    for slot=0,6 do
      local itemIndex = Char.GetItemIndex(charIndex,slot);
      if (itemIndex >= 0 and Item.GetData(itemIndex, CONST.道具_子参二)==40) then
        local crit_Skill_x = string.split(Item.GetData(itemIndex, CONST.道具_USEFUNC),",");
        for i=1,#crit_Skill_x do
          local skillId_x = tonumber(crit_Skill_x[i]);
          if (skillId_x>0 and skillId_x==301) then
            skill_Coeff = skill_Coeff + 1;
          else
            skill_Coeff = skill_Coeff;
          end
        end
      end
    end
    return skill_Coeff
end
]]
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
