local ItemThrow = ModuleBase:createModule('itemThrow')

--[[Throw_control ={}
for hhh = 0,5 do
	Throw_control[hhh] = {}
	Throw_control[hhh] = false;     --初始化投掷开关
end]]
local MaxLv = 250
local BallKind_check= {75011,75018,75019};
local BallKind_list = {};
BallKind_list[75011] = 1;    --精靈球
BallKind_list[75018] = 2;    --超級球
BallKind_list[75019] = 3;    --高級球

local GetitEnable_check= {400014,400015,400125,400126,600024,600074,600075,600076,600077,600078,600079,600080,600081,700051,700052,700054,700056,700057,700058,700060,700061,700062,700063};
local GetitEnable_list = {};
GetitEnable_list[400014] = {400014};  --enemy.txt编号
GetitEnable_list[400015] = {400015};
GetitEnable_list[400125] = {401275};
GetitEnable_list[400126] = {401276};

GetitEnable_list[600024] = {600018,600018,600018,600018,600019,600019,600019,600020,600020,600021,600021,600022,600022,600023};  --影子寵
GetitEnable_list[600074] = {600074};
GetitEnable_list[600075] = {600075};
GetitEnable_list[600076] = {600076};
GetitEnable_list[600077] = {600077};
GetitEnable_list[600078] = {600078};
GetitEnable_list[600079] = {600079};
GetitEnable_list[600080] = {600080};
GetitEnable_list[600081] = {600081};

GetitEnable_list[700051] = {700051};
GetitEnable_list[700052] = {700052};
GetitEnable_list[700054] = {700054};
GetitEnable_list[700056] = {700056};
GetitEnable_list[700057] = {700057};
GetitEnable_list[700058] = {700058};
GetitEnable_list[700060] = {700060};
GetitEnable_list[700061] = {700061};
GetitEnable_list[700062] = {700062};
GetitEnable_list[700063] = {700063};

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
  self:regCallback('BattleDodgeRateEvent', Func.bind(self.OnBattleDodgeRateEvent, self))
end

function ItemThrow:onItemUseEvent(charIndex, targetCharIndex, itemSlot)
  local itemIndex = Char.GetItemIndex(charIndex,itemSlot);
  local battleIndex = Char.GetBattleIndex(charIndex);
  local ItemID = Item.GetData(itemIndex, CONST.道具_ID);
  if (Item.GetData(itemIndex, CONST.道具_类型)==51) then
      if (battleIndex==-1 and Battle.IsWaitingCommand(charIndex)<=0) then
               NLG.SystemMessage(charIndex,"[道具提示]戰鬥中才能使用的道具");
      else
            if (CheckInTable(BallKind_check,ItemID)==true) then
               for i = 10, 19 do
                     local enemy = Battle.GetPlayer(battleIndex, i);
                     if enemy == targetCharIndex then
                            --print(i)
                            --Throw_pos = i+20;
                            Throw_pos = i;
                     end
               end
               --Throw_control[charIndex] = true;
               Char.SetTempData(charIndex, 'PokeBall', 1);
               Char.SetTempData(charIndex, 'PokeBallKind', BallKind_list[ItemID]);
               Char.DelItem(charIndex,ItemID,1);
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
               if Poke>=1 then
                 Char.SetTempData(charIndex, 'PokeBall', 0);
                 Char.SetTempData(charIndex, 'PokeBallKind', 0);
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
                       Char.SetTempData(charIndex, 'PokeBall', 2);
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
         local ballKind = Char.GetTempData(charIndex, 'PokeBallKind') or 0;
         local CatchRateUp = PokeCatchRate(ballKind);
         if com3 == 200209 and Char.GetData(defCharIndex, CONST.CHAR_类型) == CONST.对象类型_怪  then
                if (getit == 1 and (LvMR+CatchRateUp) >= LvE)  then
                        local enemyId = Char.GetData(defCharIndex, CONST.对象_ENEMY_ID);
                        --local EnemyBaseId = Data.GetEnemyBaseIdByEnemyId(enemyId);
                        if (CheckInTable(GetitEnable_check,enemyId)==true)  then
                                --Char.AddPet(charIndex,GetitEnable_list[enemyId][2]);
                                local randCatch= NLG.Rand(1, #GetitEnable_list[enemyId] );
                                Char.GivePet(charIndex,GetitEnable_list[enemyId][randCatch],0);
                                damage = 7777777;
                                Char.SetTempData(charIndex, 'PokeBall', 0);
                                return damage;
                        else
                                damage = damage;
                                Char.SetTempData(charIndex, 'PokeBall', 0);
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
                        Char.SetTempData(charIndex, 'PokeBall', 0);
                        damage = damage*0;
                        return damage;
                end
         end
  return damage;
end

function ItemThrow:OnBattleDodgeRateEvent(battleIndex, aIndex, fIndex, rate)
      --self:logDebug('OnBattleDodgeRateCallBack', battleIndex, aIndex, fIndex, rate)
      local battleIndex = Char.GetBattleIndex(aIndex);
      if Char.IsPlayer(aIndex) and Char.IsEnemy(fIndex) then	--必中
          local Poke = Char.GetTempData(aIndex, 'PokeBall') or 0;
          if Poke == 2  then
                  rate = 0;
                  return rate
          end
      else
      end
      return rate
end

function PokeCatchRate(ballKind)
         local catchRateUp = 0;
         if ballKind==1 then
             catchRateUp = 5;
         elseif ballKind==2 then
             catchRateUp = 10;
         elseif ballKind==3 then
             catchRateUp = 15;
         end
    return catchRateUp;
end

function CheckInTable(_idTab, _idVar) ---循环函数
	for k,v in pairs(_idTab) do
		if v==_idVar then
			return true
		end
	end
	return false
end

function ItemThrow:onUnload()
  self:logInfo('unload')
end

return ItemThrow;
