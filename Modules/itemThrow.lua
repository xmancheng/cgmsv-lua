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
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
end

function ItemThrow:onItemUseEvent(charIndex, targetCharIndex, itemSlot)
  local itemIndex = Char.GetItemIndex(charIndex,itemSlot);
  local battleIndex = Char.GetBattleIndex(charIndex);
  local ItemID = Item.GetData(itemIndex, CONST.道具_ID);
  if (Item.GetData(itemIndex, CONST.道具_类型)==51) then
      if (battleIndex==-1 and Battle.IsWaitingCommand(charIndex)==-1) then
               NLG.SystemMessage(charIndex,"[道具提示]戰鬥中才能使用的道具");
      else
               Throw = true;
               Char.DelItem(charIndex,ItemID,1);
               NLG.Say(charIndex,charIndex,"【準備投擲】！！",4,3);
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

function ItemThrow:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
      --self:logDebug('OnDamageCalculateCallBack', charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
         local defHpE = Char.GetData(defCharIndex,CONST.CHAR_血);
         if com3 == 200209 and CONST.战斗_普通 and Char.GetData(defCharIndex, CONST.CHAR_类型) == CONST.对象类型_怪  then
                if damage>=defHpE  then
                       local enemyId = Char.GetData(defCharIndex, CONST.CHAR_ENEMY_ID);
                       --local EnemyBaseId = Data.GetEnemyBaseIdByEnemyId(enemyId);
                       Char.AddPet(charIndex,enemyId);
                else
                        if Char.GetData(charIndex,%对象_组队开关%) == 1  then
                               local HpRe = defHpE - damage;
                               NLG.Say(charIndex,-1,"目標血量剩餘【"..HpRe.."】！！",4,3);
                        end
                end
         end
  return damage;
end

function ItemThrow:onUnload()
  self:logInfo('unload')
end

return ItemThrow;
