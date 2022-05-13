---ģ����
local MagicSkill = ModuleBase:createModule('magicSkill')

--- ����ģ�鹳��
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
         if Char.GetData(leader2, CONST.CHAR_����) == CONST.��������_�� then
               leader = leader2
         end
         if flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Char.GetData(charIndex, CONST.CHAR_����) == CONST.��������_��  then
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
                 --if Char.GetData(leader,%����_���Ŀ���%) == 1  then
                        --NLG.Say(charIndex,charIndex,"��ǿ�����ӵ�����1������",4,3);
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
                 --if Char.GetData(leader,%����_���Ŀ���%) == 1  then
                        --NLG.Say(charIndex,charIndex,"��ǿ������ˮ����1������",4,3);
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
                 --if Char.GetData(leader,%����_���Ŀ���%) == 1  then
                        --NLG.Say(charIndex,charIndex,"��ǿ�����ӻ�����1������",4,3);
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
                 --if Char.GetData(leader,%����_���Ŀ���%) == 1  then
                        --NLG.Say(charIndex,charIndex,"��ǿ�����ӷ�����1������",4,3);
                 --end
                 return damage;
               end
               if com3 == 25719  then
                 Tech.SetTechMagicAttribute(25719, 0, 0, 0, 10);
                 if Char.GetData(leader,%����_���Ŀ���%) == 1  then
                        NLG.Say(charIndex,charIndex,"���L�ݣ����L�и����L����1������",4,3);
                 end
                 return damage;
               end
               if com3 == 119  then
                 Tech.SetTechMagicAttribute(119, 0, 10, 0, 0);
                 if Char.GetData(leader,%����_���Ŀ���%) == 1  then
                        NLG.Say(charIndex,charIndex,"��ˮ�ݣ�ˮ�Дظ���ˮ����1������",4,3);
                 end
                 return damage;
               end
               if com3 == 26019  then
                 Tech.SetTechMagicAttribute(26019, 0, 10, 0, 0);
                 if Char.GetData(leader,%����_���Ŀ���%) == 1  then
                        NLG.Say(charIndex,charIndex,"��ˮ�����y���̸���ˮ����1������",4,3);
                 end
                 return damage;
               end
               if com3 == 9619  then
                 Tech.SetTechMagicAttribute(9619, 10, 0, 0, 0);
                 if Char.GetData(leader,%����_���Ŀ���%) == 1  then
                        NLG.Say(charIndex,charIndex,"���ף����Zһ�W���ӵ،���1������",4,3);
                 end
                 return damage;
               end
               if com3 == 10509  then
                 Tech.SetTechMagicAttribute(10509, 0, 10, 0, 0);
                 if Char.GetData(leader,%����_���Ŀ���%) == 1  then
                        NLG.Say(charIndex,charIndex,"�������L������ˮ����1������",4,3);
                 end
                 return damage;
               end
               if com3 == 25819  then
                 Tech.SetTechMagicAttribute(25819, 10, 0, 0, 0);
                 if Char.GetData(leader,%����_���Ŀ���%) == 1  then
                        NLG.Say(charIndex,charIndex,"��ݼӢ������ӵ،���1������",4,3);
                 end
                 return damage;
               end
               if com3 == 529  then
                 Tech.SetTechMagicAttribute(529, 0, 0, 10, 0);
                 if Char.GetData(leader,%����_���Ŀ���%) == 1  then
                        NLG.Say(charIndex,charIndex,"�������_�Ի�ȭ���ӻ�����1������",4,3);
                 end
                 return damage;
               end
               if com3 == 629  then
                 Tech.SetTechMagicAttribute(629, 0, 0, 10, 0);
                 if Char.GetData(leader,%����_���Ŀ���%) == 1  then
                        NLG.Say(charIndex,charIndex,"���_�x�ƻ˓����ӻ�����1������",4,3);
                 end
                 return damage;
               end
               if com3 == 201614  then
                 Tech.SetTechMagicAttribute(201614, 0, 0, 0, 10);
                 if Char.GetData(leader,%����_���Ŀ���%) == 1  then
                        NLG.Say(charIndex,charIndex,"�������n���������L����1������",4,3);
                 end
                 return damage;
               end
               if com3 == 11109  then
                 Tech.SetTechMagicAttribute(11109, 0, 0, 0, 10);
                 if Char.GetData(leader,%����_���Ŀ���%) == 1  then
                        NLG.Say(charIndex,charIndex,"����Ӱʮ�֔ظ����L����1������",4,3);
                 end
                 return damage;
               end
               if com3 == 200709  then
                 Tech.SetTechMagicAttribute(200709, 0, 0, 10, 0);
                 if Char.GetData(leader,%����_���Ŀ���%) == 1  then
                        NLG.Say(charIndex,charIndex,"���}ʮ�֌��и��ӻ�����1������",4,3);
                 end
                 return damage;
               end
               if com3 == 8109  then
                 Tech.SetTechMagicAttribute(8109, 0, 0, 10, 0);
                 if Char.GetData(leader,%����_���Ŀ���%) == 1  then
                        NLG.Say(charIndex,charIndex,"���}ʮ����ӡ���ӻ�����1������",4,3);
                 end
                 return damage;
               end
         else
         end
  return damage;
end

--- ж��ģ�鹳��
function MagicSkill:onUnload()
  self:logInfo('unload')
end

return MagicSkill;
