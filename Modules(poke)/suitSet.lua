---模块类(重構版)
local Module = ModuleBase:createModule('suitSet')
--需在ModuleConfig启用loadModule('charStatusExtend')
local ClearFlag = {};
-- 终极攻击
local boom_dmg_rate = {0.75,0.50,0.25,0.01}	--不同重技能对应伤害削弱，类似于乱射
local boom_list = {}
local boom_cnt_num = {}
local boom_cnt_num_aoe = {}
local boom_tag = {}

-- 套装定义
---(CONST.对象_最大血,xue)(CONST.对象_最大魔,mo)(CONST.对象_攻击力,gong)(CONST.对象_防御力,fang)(CONST.对象_敏捷,min)
---(CONST.对象_必杀,bi)(CONST.对象_反击,fan)(CONST.对象_命中,ming)(CONST.对象_闪躲,shan)
---(CONST.对象_抗毒,du)(CONST.对象_抗睡,shui)(CONST.对象_抗石,shi)(CONST.对象_抗醉,zui)(CONST.对象_抗乱,luan)(CONST.对象_抗忘,wang)
---(CONST.对象_魔攻,mogong)(CONST.对象_魔抗,mokang)(CONST.对象_精神,jingshen)(CONST.对象_回复,huifu)
---(终极攻击,zhongji[1~100])
local suitDefs = {};
suitDefs[1]={
	members = {80008},	--itemId
	parts = {
		{ desc="(1/1)終極技能效果100%", attr={ zhongji=100, gong=1000 } },
	},
}
suitDefs[2]={
	members = {80010, 80011},	--itemId
	parts = {
		{ desc="(1/2)+1000HP生命力", attr={ xue=1000 } },
		{ desc="(2/2)+500MP魔法力", attr={ mo=500 } },
	},
}


------------------------------------------------------------------
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('ItemExpansionEvent', Func.bind(self.itemExpansionCallback, self))
  self:regCallback('BattleActionTargetEvent',Func.bind(self.battleActionTargetCallback,self))

end

-- 道具说明组合接口(套裝觸發)
function Module:itemExpansionCallback(itemIndex, type, msg, charIndex, slot)
  if (type==1) then
    local itemId = Item.GetData(itemIndex, CONST.道具_ID);
    --local suitset = string.split(Item.GetData(itemIndex, CONST.道具_ATTACHFUNC),",");
    --if #suitset <= 1 then return end

    --道具说明
    local suit = findSuitByItemId(itemId);
    if not suit then return end
    local info = ""	--说明重置
    local count = Char.GetSuitSetNum(charIndex, suit);	--套装数目
    for i = 1, #suit.parts do
      local part = suit.parts[i];
      if count >= i then
        info = info .. "$1" .. part.desc .. "\n"
      else
        info = info .. "$7" .. part.desc .. "\n"
      end
    end

    --清空属性(全套装变动件数计算)
    local temp = 0;
    for _, suit in pairs(suitDefs) do	--全套装
      local count = Char.GetSuitSetNum(charIndex, suit);	--某套装生效件数
      for i = 1, #suit.parts do
        local part = suit.parts[i];
        if count >= i then
          temp = temp + 1;
        end
      end
    end
    --清空属性(第一次、有变动)
    if not ClearFlag[charIndex] or ClearFlag[charIndex].Num~=temp then
      getModule('charStatusExtend'):clearCharStatus(charIndex);
      Char.SetTempData(charIndex, '终极攻击', 0);
      ClearFlag[charIndex] = {}		--true
      ClearFlag[charIndex].Num = 0;
    end
    --属性加成
    for _, suit in pairs(suitDefs) do	--全套装
      local count = Char.GetSuitSetNum(charIndex, suit);	--某套装生效件数
      for i = 1, #suit.parts do
        local part = suit.parts[i];
        if count >= i then
          ClearFlag[charIndex].Num = ClearFlag[charIndex].Num + 1;
          --各属性加成
          for key, val in pairs(part.attr) do
            if key=="xue" then getModule('charStatusExtend'):addCharStatus(charIndex, CONST.对象_最大血, val);
            elseif key=="mo" then getModule('charStatusExtend'):addCharStatus(charIndex, CONST.对象_最大魔, val);
            elseif key=="gong" then getModule('charStatusExtend'):addCharStatus(charIndex, CONST.对象_攻击力, val);
            elseif key=="fang" then getModule('charStatusExtend'):addCharStatus(charIndex, CONST.对象_防御力, val);
            elseif key=="min" then getModule('charStatusExtend'):addCharStatus(charIndex, CONST.对象_敏捷, val);
            elseif key=="bi" then getModule('charStatusExtend'):addCharStatus(charIndex, CONST.对象_必杀, val);
            elseif key=="fan" then getModule('charStatusExtend'):addCharStatus(charIndex, CONST.对象_反击, val);
            elseif key=="ming" then getModule('charStatusExtend'):addCharStatus(charIndex, CONST.对象_命中, val);
            elseif key=="shan" then getModule('charStatusExtend'):addCharStatus(charIndex, CONST.对象_闪躲, val);
            elseif key=="du" then getModule('charStatusExtend'):addCharStatus(charIndex, CONST.对象_抗毒, val);
            elseif key=="shui" then getModule('charStatusExtend'):addCharStatus(charIndex, CONST.对象_抗睡, val);
            elseif key=="shi" then getModule('charStatusExtend'):addCharStatus(charIndex, CONST.对象_抗石, val);
            elseif key=="zui" then getModule('charStatusExtend'):addCharStatus(charIndex, CONST.对象_抗醉, val);
            elseif key=="luan" then getModule('charStatusExtend'):addCharStatus(charIndex, CONST.对象_抗乱, val);
            elseif key=="wang" then getModule('charStatusExtend'):addCharStatus(charIndex, CONST.对象_抗忘, val);
            elseif key=="mogong" then getModule('charStatusExtend'):addCharStatus(charIndex, CONST.对象_魔攻, val);
            elseif key=="mokang" then getModule('charStatusExtend'):addCharStatus(charIndex, CONST.对象_魔抗, val);
            elseif key=="jingshen" then getModule('charStatusExtend'):addCharStatus(charIndex, CONST.对象_精神, val);
            elseif key=="huifu" then getModule('charStatusExtend'):addCharStatus(charIndex, CONST.对象_回复, val);

            elseif key=="zhongji" then local token=Char.GetTempData(charIndex,'终极攻击') or 0; Char.SetTempData(charIndex, '终极攻击', token+part.attr.zhongji);
            end
          end
        end
      end
    end
    NLG.UpChar(charIndex);
    Char.UpCharStatus(charIndex);
    return info
  end
end


-- 找出某道具itemId属于哪个套装
function findSuitByItemId(itemId)
    for _, suit in pairs(suitDefs) do
        for _, id in ipairs(suit.members) do
            if (id == itemId) then
                return suit;
            end
        end
    end
    return nil
end

-- 计算角色穿戴某套装件数
Char.GetSuitSetNum = function(charIndex, suit)
	if not suit then return 0 end
	local count = 0
	for Slot = 0,7 do
		local itemIndex = Char.GetItemIndex(charIndex, Slot);
		local itemId = Item.GetData(itemIndex, CONST.道具_ID);
		if itemId and itemId ~= 0 then
			for _, sid in ipairs(suit.members) do
				if (sid == itemId) then
					count = count + 1;
					break
				end
			end
		end
	end
	return count;
end

--动作目标事件
function Module:battleActionTargetCallback(charIndex, battleIndex, com1, com2, com3, tgl)
	--self:logDebug('battleActionTargetCallback', charIndex, battleIndex, com1, com2, com3, tgl)
	local leader1 = Battle.GetPlayer(battleIndex,0)
	local leader2 = Battle.GetPlayer(battleIndex,5)
	local leader = leader1
	if Char.GetData(leader2, CONST.对象_类型) == CONST.对象类型_人 then
		leader = leader2
	end
	if Char.IsDummy(charIndex) then
		return
	end
	if Char.IsPlayer(charIndex) then
		boom_list[charIndex] = 0;
		boom_cnt_num[charIndex] = 0;
		boom_cnt_num_aoe[charIndex] = {};
		if #tgl > 1 then
			boom_tag[charIndex] = 1
		else 
			boom_tag[charIndex] = 0
		end
		local skillId = Tech.GetData(Tech.GetTechIndex(com3), CONST.TECH_SKILLID);
		--if (CheckInTable(boom_skill_list, skillId)==true) then
		if (skillId >= 0) then
			local skill300_rate = Char.GetTempData(charIndex,'终极攻击') or 0;		--终极攻击词条
			local com_name = Tech.GetData(Tech.GetTechIndex(com3), CONST.TECH_NAME);
			local copy_num = 2;
			if (skill300_rate >= NLG.Rand(1,100)) then
				local msg_name =  Char.GetData(charIndex,CONST.对象_名字);
				--NLG.SystemMessage(charIndex, msg_name.."："..skill300_rate.."%發動"..copy_num.."倍 "..com_name);
				boom_list[charIndex] = 1
				local return_tgl = copy_list(tgl,copy_num)	
				return 	return_tgl	
			end
		else
			return tgl
		end
    end
end
--增加终极攻击目标
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


--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
