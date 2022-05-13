---模块类
local MagicSkill = ModuleBase:createModule('magicSkill')

--- 加载模块钩子
function MagicSkill:onLoad()
  self:logInfo('load')
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
end


function MagicSkill:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
      --self:logDebug('OnDamageCalculateCallBack', charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
         local leader1 = Battle.GetPlayer(battleIndex,0)
         local leader2 = Battle.GetPlayer(battleIndex,5)
         local leader = leader1
         --print(charIndex)
         if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
               leader = leader2
         end
         if flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Char.GetData(charIndex, CONST.CHAR_类型) == CONST.对象类型_人  then
               if com3 >= 2730 and com3 <= 2739  then
                 Tech.SetTechMagicAttribute(2730, 10, 0, 0, 0);
                 Tech.SetTechMagicAttribute(2731, 10, 0, 0, 0);
                 Tech.SetTechMagicAttribute(2732, 10, 0, 0, 0);
                 Tech.SetTechMagicAttribute(2733, 10, 0, 0, 0);
                 Tech.SetTechMagicAttribute(2734, 10, 0, 0, 0);
                 Tech.SetTechMagicAttribute(2735, 10, 0, 0, 0);
                 Tech.SetTechMagicAttribute(2736, 10, 0, 0, 0);
                 Tech.SetTechMagicAttribute(2737, 10, 0, 0, 0);
                 Tech.SetTechMagicAttribute(2738, 10, 0, 0, 0);
                 Tech.SetTechMagicAttribute(2739, 10, 0, 0, 0);
                 --if Char.GetData(leader,%对象_队聊开关%) == 1  then
                        --NLG.Say(charIndex,charIndex,"【强击附加地属性1】！！",4,3);
                 --end
                 return damage;
               end
               if com3 >= 2830 and com3 <= 2839  then
                 Tech.SetTechMagicAttribute(2830, 0, 10, 0, 0);
                 Tech.SetTechMagicAttribute(2831, 0, 10, 0, 0);
                 Tech.SetTechMagicAttribute(2832, 0, 10, 0, 0);
                 Tech.SetTechMagicAttribute(2833, 0, 10, 0, 0);
                 Tech.SetTechMagicAttribute(2834, 0, 10, 0, 0);
                 Tech.SetTechMagicAttribute(2835, 0, 10, 0, 0);
                 Tech.SetTechMagicAttribute(2836, 0, 10, 0, 0);
                 Tech.SetTechMagicAttribute(2837, 0, 10, 0, 0);
                 Tech.SetTechMagicAttribute(2838, 0, 10, 0, 0);
                 Tech.SetTechMagicAttribute(2839, 0, 10, 0, 0);
                 --if Char.GetData(leader,%对象_队聊开关%) == 1  then
                        --NLG.Say(charIndex,charIndex,"【强击附加水属性1】！！",4,3);
                 --end
                 return damage;
               end
               if com3 >= 2930 and com3 <= 2939  then
                 Tech.SetTechMagicAttribute(2930, 0, 0, 10, 0);
                 Tech.SetTechMagicAttribute(2931, 0, 0, 10, 0);
                 Tech.SetTechMagicAttribute(2932, 0, 0, 10, 0);
                 Tech.SetTechMagicAttribute(2933, 0, 0, 10, 0);
                 Tech.SetTechMagicAttribute(2934, 0, 0, 10, 0);
                 Tech.SetTechMagicAttribute(2935, 0, 0, 10, 0);
                 Tech.SetTechMagicAttribute(2936, 0, 0, 10, 0);
                 Tech.SetTechMagicAttribute(2937, 0, 0, 10, 0);
                 Tech.SetTechMagicAttribute(2938, 0, 0, 10, 0);
                 Tech.SetTechMagicAttribute(2939, 0, 0, 10, 0);
                 --if Char.GetData(leader,%对象_队聊开关%) == 1  then
                        --NLG.Say(charIndex,charIndex,"【强击附加火属性1】！！",4,3);
                 --end
                 return damage;
               end
               if com3 >= 3030 and com3 <= 3039  then
                 Tech.SetTechMagicAttribute(3030, 0, 0, 0, 10);
                 Tech.SetTechMagicAttribute(3031, 0, 0, 0, 10);
                 Tech.SetTechMagicAttribute(3032, 0, 0, 0, 10);
                 Tech.SetTechMagicAttribute(3033, 0, 0, 0, 10);
                 Tech.SetTechMagicAttribute(3034, 0, 0, 0, 10);
                 Tech.SetTechMagicAttribute(3035, 0, 0, 0, 10);
                 Tech.SetTechMagicAttribute(3036, 0, 0, 0, 10);
                 Tech.SetTechMagicAttribute(3037, 0, 0, 0, 10);
                 Tech.SetTechMagicAttribute(3038, 0, 0, 0, 10);
                 Tech.SetTechMagicAttribute(3039, 0, 0, 0, 10);
                 --if Char.GetData(leader,%对象_队聊开关%) == 1  then
                        --NLG.Say(charIndex,charIndex,"【强击附加风属性1】！！",4,3);
                 --end
                 return damage;
               end
               if com3 == 25719  then
                 Tech.SetTechMagicAttribute(25719, 0, 0, 0, 10);
                 if Char.GetData(leader,%对象_队聊开关%) == 1  then
                        NLG.Say(charIndex,charIndex,"【風遁．旋風刃附加風屬性1】！！",4,3);
                 end
                 return damage;
               end
               if com3 == 119  then
                 Tech.SetTechMagicAttribute(119, 0, 10, 0, 0);
                 if Char.GetData(leader,%对象_队聊开关%) == 1  then
                        NLG.Say(charIndex,charIndex,"【水遁．水刃斬附加水屬性1】！！",4,3);
                 end
                 return damage;
               end
               if com3 == 26019  then
                 Tech.SetTechMagicAttribute(26019, 0, 10, 0, 0);
                 if Char.GetData(leader,%对象_队聊开关%) == 1  then
                        NLG.Say(charIndex,charIndex,"【水．波紋擊刺附加水屬性1】！！",4,3);
                 end
                 return damage;
               end
               if com3 == 9619  then
                 Tech.SetTechMagicAttribute(9619, 10, 0, 0, 0);
                 if Char.GetData(leader,%对象_队聊开关%) == 1  then
                        NLG.Say(charIndex,charIndex,"【雷．霹靂一閃附加地屬性1】！！",4,3);
                 end
                 return damage;
               end
               if com3 == 10509  then
                 Tech.SetTechMagicAttribute(10509, 0, 10, 0, 0);
                 if Char.GetData(leader,%对象_队聊开关%) == 1  then
                        NLG.Say(charIndex,charIndex,"【箭雨風暴附加水屬性1】！！",4,3);
                 end
                 return damage;
               end
               if com3 == 25819  then
                 Tech.SetTechMagicAttribute(25819, 10, 0, 0, 0);
                 if Char.GetData(leader,%对象_队聊开关%) == 1  then
                        NLG.Say(charIndex,charIndex,"【菁英射擊附加地屬性1】！！",4,3);
                 end
                 return damage;
               end
               if com3 == 529  then
                 Tech.SetTechMagicAttribute(529, 0, 0, 10, 0);
                 if Char.GetData(leader,%对象_队聊开关%) == 1  then
                        NLG.Say(charIndex,charIndex,"【阿修羅霸凰拳附加火屬性1】！！",4,3);
                 end
                 return damage;
               end
               if com3 == 629  then
                 Tech.SetTechMagicAttribute(629, 0, 0, 10, 0);
                 if Char.GetData(leader,%对象_队聊开关%) == 1  then
                        NLG.Say(charIndex,charIndex,"【羅剎破凰擊附加火屬性1】！！",4,3);
                 end
                 return damage;
               end
               if com3 == 201614  then
                 Tech.SetTechMagicAttribute(201614, 0, 0, 0, 10);
                 if Char.GetData(leader,%对象_队聊开关%) == 1  then
                        NLG.Say(charIndex,charIndex,"【音速衝擊波附加風屬性1】！！",4,3);
                 end
                 return damage;
               end
               if com3 == 11109  then
                 Tech.SetTechMagicAttribute(11109, 0, 0, 0, 10);
                 if Char.GetData(leader,%对象_队聊开关%) == 1  then
                        NLG.Say(charIndex,charIndex,"【幻影十字斬附加風屬性1】！！",4,3);
                 end
                 return damage;
               end
               if com3 == 200709  then
                 Tech.SetTechMagicAttribute(200709, 0, 0, 10, 0);
                 if Char.GetData(leader,%对象_队聊开关%) == 1  then
                        NLG.Say(charIndex,charIndex,"【聖十字審判附加火屬性1】！！",4,3);
                 end
                 return damage;
               end
               if com3 == 8109  then
                 Tech.SetTechMagicAttribute(8109, 0, 0, 10, 0);
                 if Char.GetData(leader,%对象_队聊开关%) == 1  then
                        NLG.Say(charIndex,charIndex,"【聖十字烙印附加火屬性1】！！",4,3);
                 end
                 return damage;
               end
         else
         end
  return damage;
end

--- 卸载模块钩子
function MagicSkill:onUnload()
  self:logInfo('unload')
end

return MagicSkill;
