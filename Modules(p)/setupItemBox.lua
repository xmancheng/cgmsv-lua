---模块类
local Module = ModuleBase:createModule('setupItemBox')

local itemBox = {
    { boxItem_id=66667, boxItem_count=1},	--宝箱可开出的道具编号、道具数量
    { boxItem_id=66667, boxItem_count=3},
    { boxItem_id=66667, boxItem_count=5},
}

local enemyBox = {
    {606025, 50, 0,606026, 50, 0,606027, 50, 0},	-- id，等级，随机等级，例子：{0, 100, 5, 1, 1, 0}生成0号怪物100-105级，1号怪物1级
}
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('ItemBoxGenerateEvent', function(mapId, floor, itemBoxType, adm)
      local n = NLG.Rand(1, 100);
      -- 1% 黑宝箱，1%白宝箱， 98%普通宝箱
      if n > 99 then
        return { 18003, adm }	--白宝箱
      end
      if n > 98 then
        return { 18004, adm }	--黑宝箱
      end
      return { 18002, adm }; 	--普通宝箱
  end)

  self:regCallback('ItemBoxLootEvent', function(charIndex, mapId, floor, X, Y, boxType, adm)
      if (boxType==18002) then	--普通宝箱
          local rand = NLG.Rand(1,#itemBox);
          Char.GiveItem(charIndex, itemBox[rand].boxItem_id, itemBox[rand].boxItem_count);
          return 1;	-- 返回1拦截默认物品, 返回0不拦截
      elseif (boxType==18003 or boxType==18004) then	--黑宝箱，白宝箱
          Char.GiveItem(charIndex, 900504, 50);
          local PartyNum = Char.PartyNum(charIndex);
          return 1;
      end
      return 1;
  end)

  self:regCallback('ItemBoxEncountRateEvent', function(charIndex, mapId, floor, X, Y, itemIndex)
      local n = NLG.Rand(1, 100);
      if n > 70 then
          Rate = 100;
      elseif n <= 70 then
          Rate = 0;
      end
      return Rate;	--遇敌概率
  end)

  self:regCallback('ItemBoxEncountEvent', function(charIndex, mapId, floor, X, Y, itemIndex)
      local rand = NLG.Rand(1,#enemyBox);
      enemy_tbl = enemyBox[rand];
      return enemy_tbl;		--返回nil不拦截
  end)

end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
