---模块类
local DisguiseSpell = ModuleBase:createModule('disguiseSpell')

Spell_control ={}
for ddd = 0,799 do
	Spell_control[ddd] = {}
	Spell_control[ddd][0] = 0  --初始化指标回合数
	Spell_control[ddd][1] = 0  --初始化持续回合数
end

Spell_tbl = {}
Spell_tbl[1] = {5014,5019}   --一组的techID，下方Spell_tbl.Tech一个tech要新增一列设定
Spell_tbl[2] = {5114,5119}
Spell_tbl[3] = {5214,5219}
Spell_tbl[4] = {5314,5319}

Spell_tbl.Tech = {}
-----------------------------------------------------------
Spell_tbl.Tech[5014] = {110351,2,CONST.CHAR_防御力,0.5}   --变成的原形编号、迷彩持续回合、真实伤害来源、转换倍率
Spell_tbl.Tech[5019] = {110351,2,CONST.CHAR_防御力,0.5}
-----------------------------------------------------------
Spell_tbl.Tech[5114] = {110357,2,CONST.CHAR_回复,0.25}
Spell_tbl.Tech[5119] = {110357,2,CONST.CHAR_回复,0.25}
-----------------------------------------------------------
Spell_tbl.Tech[5214] = {110363,2,CONST.CHAR_攻击力,0.125}
Spell_tbl.Tech[5219] = {110363,2,CONST.CHAR_攻击力,0.125}
-----------------------------------------------------------
Spell_tbl.Tech[5314] = {110369,2,CONST.CHAR_敏捷,0.25}
Spell_tbl.Tech[5319] = {110369,2,CONST.CHAR_敏捷,0.25}
-----------------------------------------------------------

--- 加载模块钩子
function DisguiseSpell:onLoad()
  self:logInfo('load')
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
  self:regCallback('TechOptionEvent', Func.bind(self.OnTechOptionEventCallBack, self))
  self:regCallback('BattleOverEvent', Func.bind(self.battleOverEventCallback, self))
  self:regCallback('BeforeBattleTurnEvent', Func.bind(self.handleBattleAutoCommand, self))
end

function DisguiseSpell:OnTechOptionEventCallBack(charIndex, option, techID, val)
         --self:logDebug('OnTechOptionEventCallBack', charIndex, option, techID, val)
         --使用技能时变身对应迷彩
         for i,w in pairs(Spell_tbl.Tech) do
               if (techID == i) then
                  --NLG.Say(charIndex,charIndex,"【女神加護】！！",4,3);
                  Char.SetData(charIndex,%对象_原形%,w[1]);
                  NLG.UpChar(charIndex);
                  Spell_control[charIndex][1] = 0;
               end
         end

end

function DisguiseSpell:handleBattleAutoCommand(battleIndex)
               local battleturn = Battle.GetTurn(battleIndex);
               for i = 0, 19 do
                     local charIndex = Battle.GetPlayer(battleIndex, i);
                     if charIndex >= 0 then
                           if Char.GetData(charIndex, CONST.CHAR_类型) == CONST.对象类型_人 then
                                 if (battleturn == 0) then
                                     Spell_control[charIndex][0] = 0;
                                     Spell_control[charIndex][1] = 0;
                                  --回合计算
                                 elseif (battleturn > Spell_control[charIndex][0]) then
                                     Spell_control[charIndex][0] = battleturn;
                                     Spell_control[charIndex][1] = Spell_control[charIndex][1] + 1;
                                     for i,w in pairs(Spell_tbl.Tech) do
                                         if (Spell_control[charIndex][1] >= w[2]) then                               --伤害动作回合变形还原
                                             local PlayerImage = Char.GetData(charIndex,%对象_原始图档%);
                                             Char.SetData(charIndex,%对象_原形%,PlayerImage);
                                             NLG.UpChar(charIndex);
                                         end
                                     end
                                 end
                           end
                     end
               end
end

function DisguiseSpell:battleOverEventCallback(battleIndex)
         for jlbs = 0,19 do
               local charIndex = Battle.GetPlayer(battleIndex, jlbs);
               for i,w in pairs(Spell_tbl.Tech) do
                     if (Char.GetData(charIndex,%对象_原形%) == w[1]) then
                        local PlayerImage = Char.GetData(charIndex,%对象_原始图档%);
                        Char.SetData(charIndex,%对象_原形%,PlayerImage);
                        NLG.UpChar(charIndex);
                     end
               end
         end
end

function DisguiseSpell:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
      --self:logDebug('OnDamageCalculateCallBack', charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
         local leader1 = Battle.GetPlayer(battleIndex,0)
         local leader2 = Battle.GetPlayer(battleIndex,5)
         local leader = leader1
         --print(charIndex)
         if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
               leader = leader2
         end
         if flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Char.GetData(charIndex, CONST.CHAR_类型) == CONST.对象类型_人  then
               for i,w in pairs(Spell_tbl.Tech) do
                     if (Char.GetData(charIndex,%对象_原形%) == w[1]) then               --原形增加额外真实伤害
                        Spell_control[charIndex][2] = Battle.GetSlot(battleIndex, charIndex);
                        local Attack = Char.GetData(charIndex,w[3]);
                        local damage = damage + Attack*w[4];
                        print(damage)
                        return damage;
                     end
               end

         else
         end
  return damage;
end

--- 卸载模块钩子
function DisguiseSpell:onUnload()
  self:logInfo('unload')
end

return DisguiseSpell;
