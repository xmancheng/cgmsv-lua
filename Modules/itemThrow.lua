local ItemThrow = ModuleBase:createModule('itemThrow')

--[[Throw_control ={}
for hhh = 0,5 do
	Throw_control[hhh] = {}
	Throw_control[hhh] = false;     --初始化投掷开关
end]]
local MaxLv = 250
local GetitEnable_list = {};
GetitEnable_list[400014] = {1,400014};  --enemy.txt编号，设置1可捕捉、设置0或无设置不可捕捉
GetitEnable_list[400015] = {1,400015};
GetitEnable_list[400125] = {1,401275};
GetitEnable_list[400126] = {1,401276};

GetitEnable_list[900030] = {1,900032};  --第十二席
GetitEnable_list[900033] = {1,900035};  --第十一席
GetitEnable_list[900036] = {1,900038};  --第十席
GetitEnable_list[900039] = {1,900041};  --第九席
GetitEnable_list[900042] = {1,900044};  --第八席
GetitEnable_list[900045] = {1,900047};  --第七席

-----------------------------------------------------------------
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
  --self:regCallback('ItemUseEvent', Func.bind(self.onItemUseEvent, self))
  self:regCallback('ItemString', Func.bind(self.onItemUseEvent, self), 'LUA_usePoke');
  --self:regCallback('BattleActionEvent', Func.bind(self.onBattleActionEvent,self))
  self:regCallback('BattleOverEvent', Func.bind(self.battleOverEventCallback, self))
  self:regCallback('BeforeBattleTurnEvent', Func.bind(self.handleBattleAutoCommand, self))
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
end

function ItemThrow:onItemUseEvent(charIndex, targetCharIndex, itemSlot)
  local itemIndex = Char.GetItemIndex(charIndex,itemSlot);
  local battleIndex = Char.GetBattleIndex(charIndex);
  local ItemID = Item.GetData(itemIndex, CONST.道具_ID);
  if (Item.GetData(itemIndex, CONST.道具_类型)==51) then
      if (battleIndex==-1 and Battle.IsWaitingCommand(charIndex)<=0) then
               NLG.SystemMessage(charIndex,"[道具提示]戰鬥中才能使用的道具");
      else
            if (ItemID==75011) then
               for i = 10, 19 do
                     local enemy = Battle.GetPlayer(battleIndex, i);
                     if enemy == targetCharIndex then
                            print(i)
                            Throw_pos = i+20;
                     end
               end
               --Throw_control[charIndex] = true;
               Char.SetTempData(charIndex, 'PokeBall', 1);
               Char.DelItem(charIndex,75011,1);
               NLG.Say(charIndex,charIndex,"【準備投擲】下回合才丟出！！",4,3);
            end
      end
  end

  return 0;
end

function ItemThrow:battleOverEventCallback(battleIndex)
  for i = 0, 19 do
        local charIndex = Battle.GetPlayer(battleIndex, i);
        if charIndex >= 0 then
               local Poke = Char.GetTempData(charIndex, 'PokeBall') or 0;
               if Poke==1 then
                 Char.SetTempData(charIndex, 'PokeBall', 0);
               end
               --Throw_control[charIndex] = false;
        end
  end
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
                local Poke = Char.GetTempData(charIndex, 'PokeBall') or 0;
                if ybjn and Poke == 1  then
                       Battle.ActionSelect(charIndex, CONST.BATTLE_COM.BATTLE_COM_THROWITEM, Throw_pos, 200209);
                       Char.SetTempData(charIndex, 'PokeBall', 0);
                       --Battle.ActionSelect(charIndex, CONST.BATTLE_COM.BATTLE_COM_P_SPIRACLESHOT, sidetable[charside][1], 403);
                       --Throw_control[charIndex] = false;
                end
        end
  end
  return Throw;
end

function ItemThrow:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
      --self:logDebug('OnDamageCalculateCallBack', charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
         local defHpE = Char.GetData(defCharIndex,CONST.CHAR_血);
         local defHpEM = Char.GetData(defCharIndex,CONST.CHAR_最大血);
         local HpE05 = defHpE/defHpEM;
         local getit= NLG.Rand(1, math.ceil(HpE05*4) );
         local LvE = math.ceil(Char.GetData(defCharIndex,CONST.CHAR_等级)*0.8);
         local LvMR = NLG.Rand(1,MaxLv);
         if com3 == 200209 and Char.GetData(defCharIndex, CONST.CHAR_类型) == CONST.对象类型_怪  then
                if getit == 1 and LvMR >= LvE  then
                        local enemyId = Char.GetData(defCharIndex, CONST.CHAR_ENEMY_ID);
                        --local EnemyBaseId = Data.GetEnemyBaseIdByEnemyId(enemyId);
                        if GetitEnable_list[enemyId][1] == 1  then
                                --Char.AddPet(charIndex,GetitEnable_list[enemyId][2]);
                                Char.GivePet(charIndex,GetitEnable_list[enemyId][2],0);
                                damage = 7777777;
                                return damage;
                        else
                                damage = damage;
                                NLG.Say(charIndex,-1,"【尚未開放捕捉】！！",4,3);
                                return damage;
                        end
                else
                        if Char.GetData(charIndex,%对象_组队开关%) == 1  then
                               local HpRe = defHpE - damage;
                               if (HpRe>0) then
                                   NLG.Say(charIndex,-1,"目標血量剩餘【"..HpRe.."】！！",4,3);
                               end
                        end
                end
         end
  return damage;
end

--[[
function ItemThrow:onBattleActionEvent(charIndex, com1, com2, com3, actionNum)
  if com1 == 9 then
    local itemSlot = com3
    local itemIndex = Char.GetItemIndex(charIndex,itemSlot);
    local battleIndex = Char.GetBattleIndex(charIndex);
    local ItemID = Item.GetData(itemIndex, CONST.道具_ID);
    --local boom = Char.HaveSkill(charIndex,2002);
    --local skillLV = Char.GetSkillLevel(charIndex,boom);
    --local itemlv = Item.GetData(itemIndex, CONST.道具_等级)
    if (Item.GetData(itemIndex, CONST.道具_类型)==51) then
           --第一階段(準備)
           --local enemySlot = com2
           --local Throw_pos = enemySlot+20;
           --Throw_control[charIndex] = true;
           --Char.DelItem(charIndex,ItemID,1);
           --NLG.Say(charIndex,charIndex,"【準備投擲】下回合建議防禦！！",4,3);
           --第二階段(投擲)
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
                         local Poke = Char.GetTempData(charIndex, 'PokeBall') or 0;
                         if ybjn and Poke==1 and actionNum == 1  then
                                --lv = tostring(skillLV-1)
                                --lv = ("20020"..lv)
                                --Battle.ActionSelect(CharIndex, CONST.BATTLE_COM.BATTLE_COM_THROWITEM, sidetable[charside][3], tonumber(lv));
                                Battle.ActionSelect(charIndex, CONST.BATTLE_COM.BATTLE_COM_THROWITEM, Throw_pos, 200209);
                                --Battle.ActionSelect(charIndex, CONST.BATTLE_COM.BATTLE_COM_P_SPIRACLESHOT, sidetable[charside][1], 403);
                                --Throw_control[charIndex] = false;
                         end
                  end
           end
    end
  end
  return;
end
]]

function ItemThrow:onUnload()
  self:logInfo('unload')
end

return ItemThrow;
