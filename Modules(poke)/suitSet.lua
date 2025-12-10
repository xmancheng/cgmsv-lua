---模块类(重構版)
local Module = ModuleBase:createModule('suitSet')
--需在ModuleConfig启用loadModule('charStatusExtend')
local ClearFlag = {};

-- 套装定义
local suitDefs = {};
suitDefs[1]={
	members = {80008},	--itemId
	parts = {
		{ desc="(1/1)+1000攻擊力", attr={ ATK=1000 } },
	},
}
suitDefs[2]={
	members = {80010, 80011},	--itemId
	parts = {
		{ desc="(1/2)+1000HP生命力", attr={ HP=1000 } },
		{ desc="(2/2)+500MP魔法力", attr={ MP=500 } },
	},
}


------------------------------------------------------------------
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('ItemExpansionEvent', Func.bind(self.itemExpansionCallback, self))

end

-- 道具说明组合接口(套裝觸發)
function Module:itemExpansionCallback(itemIndex, type, msg, charIndex, slot)
  if (type==1) then
    local itemId = Item.GetData(itemIndex, CONST.道具_ID);
    local suitset = string.split(Item.GetData(itemIndex, CONST.道具_ATTACHFUNC),",");
    if #suitset <= 1 then return end

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
          if part.attr.HP then getModule('charStatusExtend'):addCharStatus(charIndex, CONST.对象_最大血, part.attr.HP) end
          if part.attr.MP then getModule('charStatusExtend'):addCharStatus(charIndex, CONST.对象_最大魔, part.attr.MP) end
          if part.attr.ATK then getModule('charStatusExtend'):addCharStatus(charIndex, CONST.对象_攻击力, part.attr.ATK) end
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

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
