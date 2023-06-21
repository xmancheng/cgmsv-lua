local ItemThrow = ModuleBase:createModule('itemThrow')

function ItemThrow:setItemData(itemIndex, value)
  ---@type ItemExt
  local itemExt = getModule('itemExt')
  return itemExt:setItemData(itemIndex, value)
end

function ItemThrow:getItemData(itemIndex)
  ---@type ItemExt
  local itemExt = getModule('itemExt')
  return itemExt:getItemData(itemIndex)
end

local DmgType = CONST.DamageFlags

function ItemThrow:onLoad()
  self:logInfo('load')
  self:regCallback('ItemUseEvent', Func.bind(self.onItemUseEvent, self))
  self:regCallback('BeforeBattleTurnEvent', Func.bind(self.handleBattleAutoCommand, self))
end

function ItemThrow:onItemUseEvent(charIndex, targetCharIndex, itemSlot)
  local itemIndex = Char.GetItemIndex(charIndex,itemSlot);
  local battleIndex = Char.GetBattleIndex(charIndex);
  if (Item.GetData(itemIndex, CONST.道具_类型)==51) then
      NLG.Say(charIndex,charIndex,"【投擲】！！",4,3);
      if (battleIndex==-1 and Battle.IsWaitingCommand(charIndex)==-1) then
               NLG.SystemMessage(charIndex,"[道具提示]戰鬥中才能使用的道具");
      else
               Throw = true;
               NLG.Say(charIndex,charIndex,"【炸彈】！！",4,3);
      end
  end

  return 0;
end

function ItemThrow:handleBattleAutoCommand(battleIndex)
  for i = 0, 19 do
        local charIndex = Battle.GetPlayer(battleIndex, i);
        if charIndex >= 0 then
                local sidetable = {{10,40,41,30,20},{0,41,40,30,20}}
                local charside = 1
                local ybside = Char.GetData(charIndex,%对象_战斗Side%)
                if ybside == 1 then
                        charside = 2
                end
                local ybjn = Battle.IsWaitingCommand(charIndex);
                if ybjn and Throw == true then
                       Battle.ActionSelect(charIndex, CONST.BATTLE_COM.BATTLE_COM_THROWITEM, sidetable[charside][3], 200209);
                       --Battle.ActionSelect(charIndex, CONST.BATTLE_COM.BATTLE_COM_P_SPIRACLESHOT, sidetable[charside][1], 403);
                       Throw = false;
                end
        end
  end
  return Throw;
end

function ItemThrow:onUnload()
  self:logInfo('unload')
end

return ItemThrow;
