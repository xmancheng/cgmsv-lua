---ģ����
local SpecialSkill = ModuleBase:createModule('specialSkill')

Equipment ={}
for eee = 0,799 do
	Equipment[eee] = {}
	Equipment[eee][0] = 0  --��ʼ���غ���
	Equipment[eee][1] = 0  --��ʼ�������
end


--- ����ģ�鹳��
function SpecialSkill:onLoad()
  self:logInfo('load')
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
  self:regCallback('TechOptionEvent', Func.bind(self.OnTechOptionEventCallBack, self))
end


function SpecialSkill:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
      --self:logDebug('OnDamageCalculateCallBack', charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
         local leader1 = Battle.GetPlayer(battleIndex,0)
         local leader2 = Battle.GetPlayer(battleIndex,5)
         local leader = leader1
         --print(charIndex)
         if Char.GetData(leader2, CONST.CHAR_����) == CONST.��������_�� then
               leader = leader2
         end
         if flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Char.GetData(charIndex, CONST.CHAR_����) == CONST.��������_��  then
               local RaceType = Char.GetData(charIndex,CONST.CHAR_����);
               if ( RaceType == CONST.����_���� ) then 
                 local battleturn = Battle.GetTurn(battleIndex);
                 if (battleturn > Equipment[charIndex][0]) then
                     Equipment[charIndex][0] = battleturn;
                     Equipment[charIndex][1] = 0;
                 end
                 local turnhit = Equipment[charIndex][1] + 1;
                 local cj= 1 + (turnhit*0.015);
                 if turnhit>=20 then
                          cj = 1.3;
                 end
                 local damage = damage * cj;
                 print(damage)
                 Equipment[charIndex][1] = turnhit;
                 if Char.GetData(leader,%����_���Ŀ���%) == 1  then
                        NLG.Say(charIndex,charIndex,"����š�����",4,3);
                 end
                 --NLG.Say(-1,-1,"����ϵ����ʹĿ��������ܵ����˺���ߣ���Ч����ս����ÿ�δ������1.5%��ÿ�غ����ô���",4,3);
                 return damage;
               end
               if ( RaceType == CONST.����_���� ) then 
                 local battleturn = Battle.GetTurn(battleIndex);
                 local defHp = Char.GetData(defCharIndex,CONST.CHAR_Ѫ);
                 local defHpM = Char.GetData(defCharIndex,CONST.CHAR_���Ѫ);
                 local Hp05 = defHp/defHpM;
                 if Hp05<=0.5  then
                        yy = 1.2;
                 else
                        yy = 1;
                 end
                 if NLG.Rand(1,10)>=8  then
                        damage = damage * yy;
                        if Char.GetData(leader,%����_���Ŀ���%) == 1  then
                               NLG.Say(charIndex,charIndex,"����������",4,3);
                        end
                 else
                        damage = damage;
                 end
                 print(damage)
                 --NLG.Say(-1,-1,"����ϵ����ÿ������˺�ʱ����30%�ļ��ʶԵ�ǰ����ֵ����50%��Ŀ���˺����20%",4,3);
                 return damage;
               end
               if ( RaceType == CONST.����_���� ) then 
                 local battleturn = Battle.GetTurn(battleIndex);
                 local defHp = Char.GetData(defCharIndex,CONST.CHAR_Ѫ);
                 local dy = defHp*0.5;
                 if dy>=damage  then
                        dy = damage;
                 end
                 if NLG.Rand(1,10)>=8  then
                        damage = damage + dy;
                        if Char.GetData(leader,%����_���Ŀ���%) == 1  then
                               NLG.Say(charIndex,charIndex,"����Һ������",4,3);
                        end
                 else
                        damage = damage;
                 end
                 print(damage)
                 --NLG.Say(-1,-1,"����ϵ����ÿ������˺�ʱ����30%�ļ��ʶ�Ŀ����ɶ���ĵ�ͬ��Ŀ�굱ǰ����ֵһ����ж��˺�",4,3);
                 return damage;
               end
               if ( RaceType == CONST.����_Ұ�� ) then 
                 local battleturn = Battle.GetTurn(battleIndex);
                 local defHpM = Char.GetData(defCharIndex,CONST.CHAR_���Ѫ);
                 local damage = damage + (defHpM*0.1);
                 print(damage)
                 if Char.GetData(leader,%����_���Ŀ���%) == 1  then
                        NLG.Say(charIndex,charIndex,"��˺�ѡ�����",4,3);
                 end
                 --NLG.Say(-1,-1,"Ұ��ϵ����ʹĿ���ܵ��������ֵ10%�ĳ�Ѫ�˺�",4,3);
                 return damage;
               end
               if ( RaceType == CONST.����_���� ) then 
                 local battleturn = Battle.GetTurn(battleIndex);
                 local defHp = Char.GetData(charIndex,CONST.CHAR_Ѫ);
                 local defHpM = Char.GetData(charIndex,CONST.CHAR_���Ѫ);
                 local Hp05 = defHp/defHpM;
                 if Hp05<=0.5  then
                        fc = 1+(1-Hp05);
                        damage = damage * fc;
                        if Char.GetData(leader,%����_���Ŀ���%) == 1  then
                               NLG.Say(charIndex,charIndex,"���ͳ𡿣���",4,3);
                        end
                 else
                        damage = damage;
                 end
                 print(damage)
                 --NLG.Say(-1,-1,"����ϵ���ﵱ���Ѫ������50%����Ŀ�������ʧѪ��%�ĸ����˺�",4,3);
                 return damage;
               end
               if ( RaceType == CONST.����_���� ) then 
                 local battleturn = Battle.GetTurn(battleIndex);
                 local defHpM = Char.GetData(charIndex,CONST.CHAR_���Ѫ);
                 local zb = defHpM*0.045;
                 local damage = damage + zb;
                 print(damage)
                 if Char.GetData(leader,%����_���Ŀ���%) == 1  then
                        NLG.Say(charIndex,charIndex,"���ϱڡ�����",4,3);
                 end
                 --NLG.Say(-1,-1,"����ϵ��������˺�ʱ�������Ŀ������൱�����Ѫ��4.5%���˺�",4,3);
                 return damage;
               end
         else
         end
  return damage;
end


function SpecialSkill:OnTechOptionEventCallBack(charIndex, option, techID, val)
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
                  local item2 = Char.GetItemIndex(charIndex, 2);
                  local item2_Id = Item.GetData(item2, CONST.����_ID);
                  local item3 = Char.GetItemIndex(charIndex, 3);
                  local item3_Id = Item.GetData(item3, CONST.����_ID);
                  if techID >= 2730 and techID <= 2739 and NEN == CONST.����_Ұ��  then
                        if option == 'DD:' then
                              if Char.GetData(leader,%����_���Ŀ���%) == 1  then
                                  NLG.Say(leader,charIndex,"��ǿ��������",4,3);
                              end
                              --NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ���������ʯǿ����������30%��");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 2730 and techID <= 2739 and NEN == CONST.����_����  then
                        if option == 'AM:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ���������ʯǿ����������2��");
                              return val+2;
                        end
                        return val
                  end
                  if techID >= 2830 and techID <= 2839 and NEN == CONST.����_Ұ��  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ�����������ǿ����������30%��");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 2830 and techID <= 2839 and NEN == CONST.����_����  then
                        if option == 'AM:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ�����������ǿ����������2��");
                              return val+2;
                        end
                        return val
                  end
                  if techID >= 2930 and techID <= 2939 and NEN == CONST.����_Ұ��  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ�����������ǿ����������30%��");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 2930 and techID <= 2939 and NEN == CONST.����_����  then
                        if option == 'AM:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ�����������ǿ����������2��");
                              return val+2;
                        end
                        return val
                  end
                  if techID >= 3030 and techID <= 3039 and NEN == CONST.����_Ұ��  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ�����������ǿ����������30%��");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 3030 and techID <= 3039 and NEN == CONST.����_����  then
                        if option == 'AM:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ�����������ǿ����������2��");
                              return val+2;
                        end
                        return val
                  end
                  if techID >= 25710 and techID <= 25719 and NEN == CONST.����_Ұ��  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ�����������������������30%��");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 25710 and techID <= 25719 and NEN == CONST.����_����  then
                        if option == 'AM:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ�����������������������2��");
                              return val+2;
                        end
                        return val
                  end
                  if techID >= 110 and techID <= 119 and NEN == CONST.����_��  then
                        if option == 'TR:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ��������̵�������������10%��");
                              return val+10;
                        end
                        return val
                  end
                  if techID >= 26010 and techID <= 26019 and NEN == CONST.����_Ұ��  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ����������������������30%��");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 26010 and techID <= 26019 and NEN == CONST.����_����  then
                        if option == 'SR:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ����������������������50%��");
                              return val+50;
                        end
                        return val
                  end
                  if techID >= 10505 and techID <= 10509 and NEN == CONST.����_Ұ��  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ���������ɱ��׼��������30%��");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 10505 and techID <= 10509 and NEN == CONST.����_����  then
                        if option == 'AM:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ���������ɱ��׼��������2��");
                              return val+2;
                        end
                        return val
                  end
                  if techID >= 515 and techID <= 519 and NEN == CONST.����_Ұ��  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ�������ը���͹���������30%��");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 25815 and techID <= 25819 and NEN == CONST.����_Ұ��  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ����������������������30%��");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 5019 and techID <= 5319 and NEN == CONST.����_����  then
                        if option == 'AR:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ�������������������200%��");
                              return val+2;
                        end
                        return val
                  end
                  if techID >= 200510 and techID <= 200518 and NEN == CONST.����_Ұ��  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ���������ɳ����������30%��");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 200510 and techID <= 200518 and NEN == CONST.����_����  then
                        if option == 'AM:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ���������ɳ����������2��");
                              return val+2;
                        end
                        return val
                  end
                  if techID == 529 and NEN == CONST.����_Ұ��  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ������������ްԻ�ȭ��������30%��");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 25880 and techID <= 25885 and NEN == CONST.����_����  then
                        if option == 'AM:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ�����������ȭ��������2��");
                              return val+2;
                        end
                        return val
                  end
                  if techID >= 11105 and techID <= 11109 and NEN == CONST.����_��  then
                        if option == 'TR:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ�����������������������10%��");
                              return val+10;
                        end
                        return val
                  end
                  if techID >= 200705 and techID <= 200709 and NEN == CONST.����_Ұ��  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ������������˺���������30%��");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 8105 and techID <= 8109 and NEN == CONST.����_Ұ��  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ�����������������������30%��");
                              return val+30;
                        end
                        return val
                  end
                  if techID == 5919 and NEN == CONST.����_����  then
                        if option == 'CH:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ���������ʹ֮����������2��");
                              return val+2;
                        end
                        return val
                  end
                  if techID == 6019 and NEN == CONST.����_����  then
                        if option == 'CH:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ���������ʹ֮����������2��");
                              return val+2;
                        end
                        return val
                  end
                  if techID == 6619 and NEN == CONST.����_����  then
                        if option == 'CH:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ���������ʥ���ٳ�������2��");
                              return val+2;
                        end
                        return val
                  end
                  if techID == 6219 and NEN == CONST.����_����  then
                        if option == 'AR:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ���������ʥ����������200%��");
                              return val+200;
                        end
                        return val
                  end
                  if techID == 6329 and NEN == CONST.����_����  then
                        if option == 'AR:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ���������ʥ����������200%��");
                              return val+200;
                        end
                        return val
                  end
                  if techID >= 10628 and techID <= 10629 and NEN == CONST.����_��  then
                              if option == 'TR:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ�������˲��֮����������10%��");
                              return val+10;
                        end
                        return val
                  end
                  if techID == 200607 and NEN == CONST.����_����  then
                        if option == 'AR:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ��������׶ݣ�ǧ������������200%��");
                              return val+2;
                        end
                        return val
                  end
                  if techID == 201408 and NEN == CONST.����_����  then
                        if option == 'AR:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ���������ݣ��һ�����������200%��");
                              return val+2;
                        end
                        return val
                  end
                  if techID == 201209 and NEN == CONST.����_����  then
                        if option == 'AR:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ����������ݣ���������������200%��");
                              return val+2;
                        end
                        return val
                  end
                  if techID == 201919 and NEN == CONST.����_����  then
                        if option == 'AR:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ�����������ת����������200%��");
                              return val+200;
                        end
                        return val
                  end
            end
      end
end

function pequipitemZS(index,itemid)  ---����
      
 for k=2,2 do
     local itemindex = Char.GetItemIndex(index,k);
     if(itemid == Item.GetData(itemindex, %����_ID%))then
        return true;
     end
 end
 return false;

end

function pequipitemYS(index,itemid)  --����
      
 for k=3,3 do
     local itemindex = Char.GetItemIndex(index,k);
     if(itemid == Item.GetData(itemindex, %����_ID%))then
        return true;
     end
 end
 return false;

end

function pequipitemT(index,itemid)  ---ͷ��
      
 for k=0,0 do
     local itemindex = Char.GetItemIndex(index,k);
     if(itemid == Item.GetData(itemindex, %����_ID%))then
        return true;
     end
 end
 return false;

end

function pequipitemS(index,itemid)  ---��
      
 for k=1,1 do
     local itemindex = Char.GetItemIndex(index,k);
     if(itemid == Item.GetData(itemindex, %����_ID%))then
        return true;
     end
 end
 return false;

end

function pequipitemX(index,itemid)  ---Ь
      
 for k=4,4 do
     local itemindex = Char.GetItemIndex(index,k);
     if(itemid == Item.GetData(itemindex, %����_ID%))then
        return true;
     end
 end
 return false;

end

function pequipitemSS1(index,itemid) --��Ʒ1
      
 for k=5,5 do
     local itemindex = Char.GetItemIndex(index,k);
     if(itemid == Item.GetData(itemindex, %����_ID%))then
        return true;
     end
 end
 return false;

end

function pequipitemSS2(index,itemid) --��Ʒ2
      
 for k=6,6 do
     local itemindex = Char.GetItemIndex(index,k);
     if(itemid == Item.GetData(itemindex, %����_ID%))then
        return true;
     end
 end
 return false;

end

function pequipitemSJ(index,itemid) --ˮ��
      
 for k=7,7 do
     local itemindex = Char.GetItemIndex(index,k);
     if(itemid == Item.GetData(itemindex, %����_ID%))then
        return true;
     end
 end
 return false;

end

--- ж��ģ�鹳��
function SpecialSkill:onUnload()
  self:logInfo('unload')
end

return SpecialSkill;
