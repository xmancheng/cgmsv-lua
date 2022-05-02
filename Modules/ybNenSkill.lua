---ģ����
local YbNenSkill = ModuleBase:createModule('ybNenSkill')

--- ����ģ�鹳��
function YbNenSkill:onLoad()
  self:logInfo('load')
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
  self:regCallback('TechOptionEvent', Func.bind(self.OnTechOptionEventCallBack, self))
end


function YbNenSkill:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
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
                        NLG.Say(leader,charIndex,"���[�����ء�����",4,3);
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
                        NLG.Say(leader,charIndex,"�����L�C�C������",4,3);
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
                        NLG.Say(leader,charIndex,"���f��Կա�����",4,3);
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
                        NLG.Say(leader,charIndex,"�����L�C�C������",4,3);
                 end
                 --NLG.Say(-1,-1,"����ս��ʱ�����ܵ��������˺�0%����Ч����ս����ÿ�غ����3%�����30%",4,3);
                 return damage;
               end
           end
         elseif  Char.GetData(charIndex, CONST.CHAR_����) == CONST.��������_��  then  ---����Ϊ�������¼�����������ֻ�ܶ�ѡһ
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
         end
  return damage;
end


function YbNenSkill:OnTechOptionEventCallBack(charIndex, option, techID, val)
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
                  if techID >= 1260 and techID <= 1269 and item5_Id == 900329  then
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
            if JL1 >= 1 then
                  if techID >= 2730 and techID <= 2739 and NEN == 6  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ���������ʯǿ����������30%��");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 2730 and techID <= 2739 and NEN == 3  then
                        if option == 'AM:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ���������ʯǿ����������2��");
                              return val+2;
                        end
                        return val
                  end
                  if techID >= 2830 and techID <= 2839 and NEN == 6  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ�����������ǿ����������30%��");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 2830 and techID <= 2839 and NEN == 3  then
                        if option == 'AM:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ�����������ǿ����������2��");
                              return val+2;
                        end
                        return val
                  end
                  if techID >= 2930 and techID <= 2939 and NEN == 6  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ�����������ǿ����������30%��");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 2930 and techID <= 2939 and NEN == 3  then
                        if option == 'AM:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ�����������ǿ����������2��");
                              return val+2;
                        end
                        return val
                  end
                  if techID >= 3030 and techID <= 3039 and NEN == 6  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ�����������ǿ����������30%��");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 3030 and techID <= 3039 and NEN == 3  then
                        if option == 'AM:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ�����������ǿ����������2��");
                              return val+2;
                        end
                        return val
                  end
                  if techID >= 25710 and techID <= 25719 and NEN == 6  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ�����������������������30%��");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 25710 and techID <= 25719 and NEN == 3  then
                        if option == 'AM:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ�����������������������2��");
                              return val+2;
                        end
                        return val
                  end
                  if techID >= 110 and techID <= 119 and NEN == 1  then
                        if option == 'TR:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ��������̵�������������10%��");
                              return val+10;
                        end
                        return val
                  end
                  if techID >= 26010 and techID <= 26019 and NEN == 6  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ����������������������30%��");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 26010 and techID <= 26019 and NEN == 4  then
                        if option == 'SR:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ����������������������50%��");
                              return val+50;
                        end
                        return val
                  end
                  if techID >= 10505 and techID <= 10509 and NEN == 6  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ���������ɱ��׼��������30%��");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 10505 and techID <= 10509 and NEN == 3  then
                        if option == 'AM:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ���������ɱ��׼��������2��");
                              return val+2;
                        end
                        return val
                  end
                  if techID >= 515 and techID <= 519 and NEN == 6  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ�������ը���͹���������30%��");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 25815 and techID <= 25819 and NEN == 6  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ����������������������30%��");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 5019 and techID <= 5319 and NEN == 7  then
                        if option == 'AR:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ�������������������200%��");
                              return val+2;
                        end
                        return val
                  end
                  if techID >= 200510 and techID <= 200518 and NEN == 6  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ���������ɳ����������30%��");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 200510 and techID <= 200518 and NEN == 3  then
                        if option == 'AM:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ���������ɳ����������2��");
                              return val+2;
                        end
                        return val
                  end
                  if techID == 529 and NEN == 6  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ������������ްԻ�ȭ��������30%��");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 25880 and techID <= 25885 and NEN == 3  then
                        if option == 'AM:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ�����������ȭ��������2��");
                              return val+2;
                        end
                        return val
                  end
                  if techID >= 11105 and techID <= 11109 and NEN == 1  then
                        if option == 'TR:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ�����������������������10%��");
                              return val+10;
                        end
                        return val
                  end
                  if techID >= 200705 and techID <= 200709 and NEN == 6  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ������������˺���������30%��");
                              return val+30;
                        end
                        return val
                  end
                  if techID >= 8105 and techID <= 8109 and NEN == 6  then
                        if option == 'DD:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ�����������������������30%��");
                              return val+30;
                        end
                        return val
                  end
                  if techID == 5919 and NEN == 8  then
                        if option == 'CH:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ���������ʹ֮����������2��");
                              return val+2;
                        end
                        return val
                  end
                  if techID == 6019 and NEN == 8  then
                        if option == 'CH:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ���������ʹ֮����������2��");
                              return val+2;
                        end
                        return val
                  end
                  if techID == 6619 and NEN == 8  then
                        if option == 'CH:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ���������ʥ���ٳ�������2��");
                              return val+2;
                        end
                        return val
                  end
                  if techID == 6219 and NEN == 7  then
                        if option == 'AR:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ���������ʥ����������200%��");
                              return val+200;
                        end
                        return val
                  end
                  if techID == 6329 and NEN == 7  then
                        if option == 'AR:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ���������ʥ����������200%��");
                              return val+200;
                        end
                        return val
                  end
                  if techID >= 10628 and techID <= 10629 and NEN == 1  then
                              if option == 'TR:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ�������˲��֮����������10%��");
                              return val+10;
                        end
                        return val
                  end
                  if techID == 200607 and NEN == 7  then
                        if option == 'AR:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ��������׶ݣ�ǧ������������200%��");
                              return val+2;
                        end
                        return val
                  end
                  if techID == 201408 and NEN == 7  then
                        if option == 'AR:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ���������ݣ��һ�����������200%��");
                              return val+2;
                        end
                        return val
                  end
                  if techID == 201209 and NEN == 7  then
                        if option == 'AR:' then
                              NLG.SystemMessage(charIndex,"ר��������Ч���ӳ��ѷ����������ݣ���������������200%��");
                              return val+2;
                        end
                        return val
                  end
                  if techID == 201919 and NEN == 7  then
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
function YbNenSkill:onUnload()
  self:logInfo('unload')
end

return YbNenSkill;
