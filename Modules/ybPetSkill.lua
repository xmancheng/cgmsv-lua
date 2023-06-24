---ģ����
local YbPetSkill = ModuleBase:createModule('ybPetSkill')

--- ����ģ�鹳��
function YbPetSkill:onLoad()
  self:logInfo('load')
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
  self:regCallback('TechOptionEvent', Func.bind(self.OnTechOptionEventCallBack, self))
end


function YbPetSkill:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
      --self:logDebug('OnDamageCalculateCallBack', charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
         local leader1 = Battle.GetPlayer(battleIndex,0)
         local leader2 = Battle.GetPlayer(battleIndex,5)
         local leader = leader1
         if Char.GetData(leader2, CONST.CHAR_����) == CONST.��������_�� then
               leader = leader2
         end
         if  flg == CONST.DamageFlags.Normal and Char.GetData(defCharIndex, CONST.CHAR_����) == CONST.��������_��  then  ---����Ϊ�����ܹ����¼�����������ֻ�ܶ�ѡһ
           for i=0,9 do
               local skillId = Pet.GetSkill(defCharIndex, i)
               if (skillId == 1319) then  --���ﱻ�����[�����ء�
                 local battleturn= Battle.GetTurn(battleIndex);
                 local yrzz= 0.75 + (battleturn*0.05);
                 if battleturn>=10 then
                          yrzz = 1.25;
                 end
                 local damage = damage * yrzz;
                 print(damage)
                 if Char.GetData(leader,%����_���Ŀ���%) == 1  then
                        NLG.Say(leader,defCharIndex,"���[�����ء�����",4,3);
                 end
                 --NLG.Say(-1,-1,"����ս��ʱ�����ܵ��������˺�25%����Ч����ս����ÿ�غϼ���5%����������50%",4,3);
                 return damage;
               end
               if (skillId == 1519) then  --���ﱻ�����������ݡ�
                 local battleturn= Battle.GetTurn(battleIndex);
                 local wfll= 1 - (battleturn*0.03);
                 if battleturn>=10 then
                          wfll = 0.7;
                 end
                 local damage = damage * wfll;
                 print(damage)
                 if Char.GetData(leader,%����_���Ŀ���%) == 1  then
                        NLG.Say(leader,defCharIndex,"�����L�C�C������",4,3);
                 end
                 --NLG.Say(-1,-1,"����ս��ʱ�����ܵ���ħ���˺�0%����Ч����ս����ÿ�غ����3%�����30%",4,3);
                 return damage;
               end
           end
         elseif  flg == CONST.DamageFlags.Magic and Char.GetData(defCharIndex, CONST.CHAR_����) == CONST.��������_��  then  ---����Ϊħ���ܹ����¼�����������ֻ�ܶ�ѡһ
           for i=0,9 do
               local skillId = Pet.GetSkill(defCharIndex, i)
               if (skillId == 1419) then  --���ﱻ�����f��Կա�
                 local battleturn= Battle.GetTurn(battleIndex);
                 local wnjk= 0.75 + (battleturn*0.05);
                 if battleturn>=10 then
                          wnjk = 1.25;
                 end
                 local damage = damage * wnjk;
                 print(damage)
                 if Char.GetData(leader,%����_���Ŀ���%) == 1  then
                        NLG.Say(leader,defCharIndex,"���f��Կա�����",4,3);
                 end
                 --NLG.Say(-1,-1,"����ս��ʱ�����ܵ���ħ���˺�25%����Ч����ս����ÿ�غϼ���5%����������50%",4,3);
                 return damage;
               end
               if (skillId == 1519) then  --���ﱻ�����������ݡ�
                 local battleturn= Battle.GetTurn(battleIndex);
                 local wfll= 1 - (battleturn*0.03);
                 if battleturn>=10 then
                          wfll = 0.7;
                 end
                 local damage = damage * wfll;
                 print(damage)
                 if Char.GetData(leader,%����_���Ŀ���%) == 1  then
                        NLG.Say(leader,defCharIndex,"�����L�C�C������",4,3);
                 end
                 --NLG.Say(-1,-1,"����ս��ʱ�����ܵ��������˺�0%����Ч����ս����ÿ�غ����3%�����30%",4,3);
                 return damage;
               end
           end
         elseif  flg == CONST.DamageFlags.Normal and Char.GetData(charIndex, CONST.CHAR_����) == CONST.��������_��  then  ---����Ϊ�������¼�����������ֻ�ܶ�ѡһ
           for i=0,9 do
               local skillId = Pet.GetSkill(charIndex, i)
               if (skillId == 1619) then  --���ﱻ��������η��
                 local battleturn= Battle.GetTurn(battleIndex);
                 local ddww= 1.3 - (battleturn*0.06);
                 if battleturn>=5 then
                          ddww = 1;
                 end
                 local damage = damage * ddww;
                 print(damage)
                 if Char.GetData(leader,%����_���Ŀ���%) == 1  then
                        NLG.Say(leader,charIndex,"����đ�oη������",4,3);
                 end
                 --NLG.Say(-1,-1,"����ս��ʱ�����ɵ������˺�30%����Ч����ս����ÿ�غϽ���6%",4,3);
                 return damage;
               end
               if (skillId == 1719) then  --���ﱻ������սĥ����
                 local battleturn= Battle.GetTurn(battleIndex);
                 local bzml= 1 + (battleturn*0.06);
                 if battleturn>=5 then
                          bzml = 1.3;
                 end
                 local damage = damage * bzml;
                 print(damage)
                 if Char.GetData(leader,%����_���Ŀ���%) == 1  then
                        NLG.Say(leader,charIndex,"���ّ�ĥ��������",4,3);
                 end
                 --NLG.Say(-1,-1,"����ս��ʱ�����ɵ������˺�0%����Ч����ս����ÿ�غ�����6%�����30%",4,3);
                 return damage;
               end
           end
         elseif  flg == CONST.DamageFlags.Magic and Char.GetData(charIndex, CONST.CHAR_����) == CONST.��������_��  then
               local LvRate = Char.GetData(charIndex,CONST.CHAR_�ȼ�);
               local Spirit = Char.GetData(charIndex,CONST.CHAR_����);
               if LvRate <= 50  then
                        LvRate = 1;
               else
                        LvRate = LvRate/50;
               end
               if Spirit <= 200  then
                        SpRate = 1;
               else
                        SpRate = Spirit/200;
               end
               local damage = damage * SpRate + Spirit * 0.5 * LvRate ;
               print(damage)
               --if Char.GetData(leader,%����_���Ŀ���%) == 1  then
                      --NLG.Say(leader,charIndex,"��ħ������������",4,3);
               --end
              return damage;

         end
  return damage;
end


function YbPetSkill:OnTechOptionEventCallBack(charIndex, option, techID, val)
      --self:logDebug('OnTechOptionEventCallBack', charIndex, option, techID, val)
      local battleIndex = Char.GetBattleIndex(charIndex)
      local leader1 = Battle.GetPlayer(battleIndex,0)
      local leader2 = Battle.GetPlayer(battleIndex,5)
      local leader = leader1
      if Char.GetData(leader2, CONST.CHAR_����) == CONST.��������_�� then
            leader = leader2
      end
      if Char.GetData(charIndex, CONST.CHAR_����) == CONST.��������_�� then
            local NEN = Char.GetData(charIndex,CONST.CHAR_����);
            local JL1 = NLG.Rand(1,4);
            --print(NEN)
            --print(JL1)
            if JL1 >= 1 then
                  local item5 = Char.GetItemIndex(charIndex, 5);
                  local item5_Id = Item.GetData(item5, CONST.����_ID);
                  local item6 = Char.GetItemIndex(charIndex, 6);
                  local item6_Id = Item.GetData(item6, CONST.����_ID);
                  if techID >= 400 and techID <= 409 and item6_Id == 900333  then
                        if option == 'DD:' then
                              if Char.GetData(leader,%����_���Ŀ���%) == 1  then
                                  NLG.Say(leader,charIndex,"���ۚ⡿����",4,3);
                              end
                              --NLG.Say(-1,-1,"Ӷ������ǿ��Ч���ӳ��ѷ���������������������30%��",4,3);
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 9500 and techID <= 9509 and item6_Id == 900333  then
                        if option == 'AM:' then
                              if Char.GetData(leader,%����_���Ŀ���%) == 1  then
                                  NLG.Say(leader,charIndex,"���E�꡿����",4,3);
                              end
                              --NLG.Say(-1,-1,"Ӷ������ǿ��Ч���ӳ��ѷ�������������������3��",4,3);
                              return val+3;
                        end
                        return val
                  end
                  if techID >= 6600 and techID <= 6609 and item5_Id == 900330 then
                        if option == 'RR:' then
                              if Char.GetData(leader,%����_���Ŀ���%) == 1  then
                                  NLG.Say(leader,charIndex,"���}�꡿����",4,3);
                              end
                              --NLG.Say(-1,-1,"Ӷ������ǿ��Ч���ӳ��ѷ�������������������100%��",4,3);
                              return val+100;
                        end
                        return val
                  end
                  if techID >= 1260 and techID <= 1269 and item5_Id == 900330  then
                        if option == 'D2:' then
                              if Char.GetData(leader,%����_���Ŀ���%) == 1  then
                                  NLG.Say(leader,charIndex,"���`�⡿����",4,3);
                              end
                              --NLG.Say(-1,-1,"Ӷ������ǿ��Ч���ӳ��ѷ�������������������100%��",4,3);
                              return val+100;
                        end
                        return val
                  end
            end
      end
end

--- ж��ģ�鹳��
function YbPetSkill:onUnload()
  self:logInfo('unload')
end

return YbPetSkill;
