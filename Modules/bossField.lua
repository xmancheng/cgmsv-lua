---模块类
local Module = ModuleBase:createModule('bossField')

local damage_Max = 99999;

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BattleStartEvent', Func.bind(self.OnbattleStartEventCallback, self))
  self:regCallback('AfterBattleTurnEvent', Func.bind(self.OnAfterBattleTurnCommand, self))
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
  self:regCallback('BattleHealCalculateEvent', Func.bind(self.OnBattleHealCalculateCallBack, self))
end

function Module:OnbattleStartEventCallback(battleIndex)
         for i=10, 19 do
              local enemy = Battle.GetPlayIndex(battleIndex, i)
              local player = Battle.GetPlayIndex(battleIndex, i-10)
               --print(enemy, player)
              if enemy>=0 and Char.IsEnemy(enemy) then
                  Char.SetTempData(enemy, '守住', 3);
                  Char.SetTempData(enemy, '狂暴', 3);
                  if Char.GetData(player,CONST.对象_对战开关) == 1  then
                     NLG.Say(player,-1,"【守住領域】【狂暴領域】",4,3);
                 end
              end
         end
end

function Module:OnAfterBattleTurnCommand(battleIndex)
	local Round = Battle.GetTurn(battleIndex);
	local leader1 = Battle.GetPlayer(battleIndex,0)
	local leader2 = Battle.GetPlayer(battleIndex,5)
	local leader = leader1
	if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
		leader = leader2
	end
	local Target_FloorId = Char.GetData(leader,CONST.CHAR_地图);
	if (Target_FloorId==25013) then
		FieldEffect = 1;
	end
	for i = 0, 9 do
		local player = Battle.GetPlayer(battleIndex, i);
		if (player>=0 and math.fmod(Round, 2)==0 and FieldEffect==1)  then
			local playerHP = Char.GetData(player, CONST.CHAR_血);
			if (playerHP>=500) then
				Char.SetData(player, CONST.CHAR_血, playerHP*0.7);
			end
			--if Char.GetData(player,CONST.对象_对战开关) == 1  then
				NLG.Say(player,-1,"受到【誅伏賜死】領域影響每回合都會減少30%生命。",4,3);
			--end
		end
	end
	FieldEffect = 0;
end

function Module:OnBattleHealCalculateCallBack(charIndex, defCharIndex, oriheal, heal, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg, ExFlg)
         local leader1 = Battle.GetPlayer(battleIndex,0)
         local leader2 = Battle.GetPlayer(battleIndex,5)
         local leader = leader1
         --print(charIndex, com1, com2, com3, defCom1, defCom2, defCom3)
         if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
               leader = leader2
         end
         if (com3==6219 or com3==6319 )  then
             if Char.IsEnemy(defCharIndex) then
                 local Buff1 = Char.GetTempData(defCharIndex, '守住') or 0;
                 local Buff2 = Char.GetTempData(defCharIndex, '狂暴') or 0;
                 if (Buff1 > 0 or Buff2 > 0)  then
                       if (Buff1>=2 or Buff2>=2)  then
                           Char.SetTempData(defCharIndex, '守住', 1);
                           Char.SetTempData(defCharIndex, '狂暴', 1);
                           if Char.GetData(leader,CONST.对象_对战开关) == 1  then
                               NLG.Say(leader,-1,"【守住領域】【狂暴領域】降為1層",4,3);
                           end
                       elseif (Buff1==1 or Buff2==1)  then
                           Char.SetTempData(defCharIndex, '守住', 0);
                           Char.SetTempData(defCharIndex, '狂暴', 0);
                           if Char.GetData(leader,CONST.对象_对战开关) == 1  then
                               NLG.Say(leader,-1,"【守住領域】【狂暴領域】降為0層",4,3);
                           end
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

         if flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Char.IsEnemy(defCharIndex)  then
               local GTime = NLG.GetGameTime();
               if (GTime>=0)  then
                     local State = Char.GetTempData(defCharIndex, '守住') or 0;
                     if (damage>=999 and Char.GetData(defCharIndex, CONST.CHAR_ENEMY_ID) == 400125) then
                             if (State>0 and Char.IsEnemy(defCharIndex)) then
                                 damage = 999;
                                 return damage;
                             end
                     end
                     if (GTime==0 and damage>=damage_Max and Char.GetData(defCharIndex, CONST.CHAR_EnemyBossFlg) == 1) then
                         if (State>0) then
                             if (State>=1)  then
                                 damage = damage_Max;
                                 if Char.GetData(leader,CONST.对象_对战开关) == 1  then
                                     NLG.Say(leader,-1,"【守住】怪物受到的傷害上限值為"..damage_Max.."，守住剩餘"..State.."層",4,3);
                                 end
                                 return damage;
                             end
                         else
                             damage = damage;
                         end
                     else
                         damage = damage;
                     end
               else
               end
               return damage;
         end

         if flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and flg ~= CONST.DamageFlags.Magic and Char.IsEnemy(charIndex)  then
               local GTime = NLG.GetGameTime();
               if (GTime==2)  then
                     local State = Char.GetTempData(charIndex, '狂暴') or 0;
                     if (Char.GetData(charIndex, CONST.CHAR_EnemyBossFlg) == 1) then
                         local d1= Char.GetData(charIndex, CONST.CHAR_攻击力);
                         local d2= Char.GetData(defCharIndex, CONST.CHAR_攻击力);
                         local d3= Char.GetData(defCharIndex, CONST.CHAR_防御力);
                         local d4= Char.GetData(defCharIndex, CONST.CHAR_精神);
                         if (State>0) then
                            if d2>=500 and d2<=4000 then
                                 local damage_Max = (d1*0.8)-(d3-120)*10+(d4*State/100);
                                 if damage_Max<=9 then damage_Max = 9; end
                                 if damage_Max>=99 then damage_Max = 99; end
                                 damage = damage+damage_Max;
                                 if Char.GetData(leader,CONST.对象_对战开关) == 1  then
                                     NLG.Say(leader,-1,"【狂暴】怪物提高對你的額外傷害為"..damage_Max.."，狂暴剩餘"..State.."層",4,3);
                                 end
                                 return damage;
                            elseif d2>=4001 and d2<=9999 then
                                 local damage_Max = (d1*0.8)-(d3-180)*10+(d4*State/10);
                                 if damage_Max<=99 then damage_Max = 99; end
                                 if damage_Max>=999 then damage_Max = 999; end
                                 damage = damage+damage_Max;
                                 if Char.GetData(leader,CONST.对象_对战开关) == 1  then
                                     NLG.Say(leader,-1,"【狂暴】怪物提高對你的額外傷害為"..damage_Max.."，狂暴剩餘"..State.."層",4,3);
                                 end
                                 return damage;
                            elseif d2>=10000 then
                                 local damage_Max = (d1*0.8)-(d3-240)*10+(d4*State/1);
                                 if damage_Max<=999 then damage_Max = 999; end
                                 if damage_Max>=9999 then damage_Max = 9999; end
                                 damage = damage+damage_Max;
                                 if Char.GetData(leader,CONST.对象_对战开关) == 1  then
                                     NLG.Say(leader,-1,"【狂暴】怪物提高對你的額外傷害為"..damage_Max.."，狂暴剩餘"..State.."層",4,3);
                                 end
                                 return damage;
                            else
                                 damage = damage;
                                 return damage;
                            end
                         end
                     end
               end
               return damage;
         elseif flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and flg == CONST.DamageFlags.Magic and Char.IsEnemy(charIndex)  then
               local GTime = NLG.GetGameTime();
               if (GTime==2)  then
                     local State = Char.GetTempData(charIndex, '狂暴') or 0;
                     if (Char.GetData(charIndex, CONST.CHAR_EnemyBossFlg) == 1) then
                         local d1= Char.GetData(charIndex, CONST.CHAR_精神);
                         local d2= Char.GetData(defCharIndex, CONST.CHAR_精神);
                         local d3= Char.GetData(defCharIndex, CONST.CHAR_魔抗);
                         local d4= Char.GetData(defCharIndex, CONST.CHAR_攻击力);
                         if (State>0) then
                            if (com3 == 2729)  then    --千鈞石箭-SE
                                if NLG.Rand(1,10)>=8  then
                                    Char.SetData(defCharIndex, CONST.CHAR_BattleModStone, 2);
                                    NLG.UpChar(defCharIndex);
                                end
                            end
                            if d2>=500 and d2<=2000 then
                                 local damage_Max = (d1*0.8)-(d3-50)*10+(d4*State/100);
                                 if damage_Max<=9 then damage_Max = 9; end
                                 if damage_Max>=99 then damage_Max = 99; end
                                 damage = damage+damage_Max;
                                 if Char.GetData(leader,CONST.对象_对战开关) == 1  then
                                     NLG.Say(leader,-1,"【狂暴】怪物提高對你的額外傷害為"..damage_Max.."，狂暴剩餘"..State.."層",4,3);
                                 end
                                 return damage;
                            elseif d2>=2001 and d2<=9999 then
                                 local damage_Max = (d1*0.8)-(d3-100)*10+(d4*State/10);
                                 if damage_Max<=99 then damage_Max = 99; end
                                 if damage_Max>=999 then damage_Max = 999; end
                                 damage = damage+damage_Max;
                                 if Char.GetData(leader,CONST.对象_对战开关) == 1  then
                                     NLG.Say(leader,-1,"【狂暴】怪物提高對你的額外傷害為"..damage_Max.."，狂暴剩餘"..State.."層",4,3);
                                 end
                                 return damage;
                            elseif d2>=10000 then
                                 local damage_Max = (d1*0.8)-(d3-240)*10+(d4*State/1);
                                 if damage_Max<=999 then damage_Max = 999; end
                                 if damage_Max>=9999 then damage_Max = 9999; end
                                 damage = damage+damage_Max;
                                 if Char.GetData(leader,CONST.对象_对战开关) == 1  then
                                     NLG.Say(leader,-1,"【狂暴】怪物提高對你的額外傷害為"..damage_Max.."，狂暴剩餘"..State.."層",4,3);
                                 end
                                 return damage;
                            else
                                 damage = damage;
                                 return damage;
                            end
                         end
                     end
               end
               return damage;
         else
         end
  return damage;
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
