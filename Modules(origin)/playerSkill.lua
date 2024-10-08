---模块类
local Module = ModuleBase:createModule('playerSkill')

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BeforeBattleTurnEvent', Func.bind(self.OnbattleStarCommand, self))
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
  self:regCallback('BattleHealCalculateEvent', Func.bind(self.OnBattleHealCalculateCallBack, self))
  self:regCallback('BattleOverEvent', Func.bind(self.battleOverEventCallback, self));
  self:regCallback('LoginGateEvent', Func.bind(self.onLogbattleOverEvent, self));
  self:regCallback('LogoutEvent', Func.bind(self.onLogbattleOverEvent, self));
end


function Module:OnBattleHealCalculateCallBack(charIndex, defCharIndex, oriheal, heal, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg, ExFlg)
         local leader1 = Battle.GetPlayer(battleIndex,0)
         local leader2 = Battle.GetPlayer(battleIndex,5)
         local leader = leader1
         --print(charIndex, com1, com2, com3, defCom1, defCom2, defCom3)
         if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
               leader = leader2
         end
         if (flg==CONST.HealDamageFlags.Heal)  then    --補血治療魔法
            if (com3==6300 or com3==6301 or com3==6302)  then
               if (Char.IsPlayer(defCharIndex)==true or Char.IsPet(defCharIndex)==true) then
                   local D_Buff = Char.GetTempData(defCharIndex, '防御增益') or 0;
                   if (D_Buff<=5)  then
                       heal = 666;
                       Char.SetTempData(defCharIndex, '防御增益', 5);
                   end
               end
            end
            return heal;
         elseif (flg==CONST.HealDamageFlags.Recovery)  then    --恢復魔法
               return heal;
         elseif (flg==CONST.HealDamageFlags.Consentration)  then    --明鏡止水
            if (com3==1200 or com3==1201 or com3==1202)  then
               if (Char.IsPlayer(defCharIndex)==true or Char.IsPet(defCharIndex)==true) then
                   local A_Buff = Char.GetTempData(defCharIndex, '攻击增益') or 0;
                   if (A_Buff<=3)  then
                       heal = 350;
                       Char.SetTempData(defCharIndex, '攻击增益', 3);
                   end
               end
            end
            return heal;
         end
         return heal;
end

function Module:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg, ExFlg)
      --self:logDebug('OnDamageCalculateCallBack', charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg, ExFlg)
         local leader1 = Battle.GetPlayer(battleIndex,0)
         local leader2 = Battle.GetPlayer(battleIndex,5)
         local leader = leader1
         --print(charIndex, com1, com2, com3, defCom1, defCom2, defCom3)
         if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
               leader = leader2
         end
         if flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Char.IsPlayer(defCharIndex)==true  then
               local D_Buff = Char.GetTempData(defCharIndex, '防御增益') or 0;
               if (D_Buff >= 1)  then
                   local damage = math.floor(oriDamage * 0.8);
                   --print(oriDamage,damage);
                   Char.SetTempData(defCharIndex, '防御增益', D_Buff - 1);
                   return damage;
               end
               return damage;
         elseif flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Char.IsPlayer(charIndex)==true  then
               local A_Buff = Char.GetTempData(charIndex, '攻击增益') or 0;
               if (A_Buff >= 1)  then
                   local damage = math.floor(oriDamage * 1.35);
                   --print(oriDamage,damage);
                   Char.SetTempData(charIndex, '攻击增益', A_Buff - 1);
                   return damage;
               end
               return damage;
         elseif flg == CONST.DamageFlags.Magic and Char.IsPlayer(charIndex)==true  then
               local A_Buff = Char.GetTempData(charIndex, '攻击增益') or 0;
               if (A_Buff >= 1)  then
                   local damage = math.floor(oriDamage * 1.35);
                   --print(oriDamage,damage);
                   Char.SetTempData(charIndex, '攻击增益', A_Buff - 1);
                   return damage;
               end
               return damage;
         else
         end
  return damage;
end

function Module:OnbattleStarCommand(battleIndex)
    for i=0, 19 do
        local charIndex = Battle.GetPlayIndex(battleIndex, i)
        if (charIndex>=0 and Char.IsPlayer(charIndex)==true) then
            local A_Buff = Char.GetTempData(charIndex, '攻击增益') or 0;
            if (A_Buff >= 1) then
                    NLG.SetHeadIcon(charIndex, 119646);
            else
                    NLG.SetHeadIcon(charIndex, 1);
            end
        end
    end
end

--结束、注销初始化
function Module:battleOverEventCallback(battleIndex)
  for i = 0, 19 do
        local charIndex = Battle.GetPlayer(battleIndex, i);
        if charIndex >= 0 then
              local A_Buff = Char.GetTempData(charIndex, '攻击增益') or 0;
              local D_Buff = Char.GetTempData(charIndex, '防御增益') or 0;
              if (A_Buff >= 1) then
                 Char.SetTempData(charIndex, '攻击增益', 0);
              end
              if (D_Buff >= 1) then
                 Char.SetTempData(charIndex, '防御增益', 0);
              end
        end
  end
end
function Module:onLogbattleOverEvent(charIndex)
	local A_Buff = Char.GetTempData(charIndex, '攻击增益') or 0;
	local D_Buff = Char.GetTempData(charIndex, '防御增益') or 0;
	if (A_Buff >= 1) then
		Char.SetTempData(charIndex, '攻击增益', 0);
	end
	if (D_Buff >= 1) then
		Char.SetTempData(charIndex, '防御增益', 0);
	end
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
