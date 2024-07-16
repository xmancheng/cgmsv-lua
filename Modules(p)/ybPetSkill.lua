---ģ����
local YbPetSkill = ModuleBase:createModule('ybPetSkill')

local petMettleTable = {
             { MettleType=1, type=CONST.CHAR_EnemyBossFlg, info=CONST.Enemy_�Ƿ�BOSS, skillId=9610 , val = 1.15},              --��BOSS���������˺�
             { MettleType=3, type=CONST.CHAR_������, info=CONST.����_��, skillId=9611 , val = 1.05},              --�Ե����Զ��������˺�
             { MettleType=3, type=CONST.CHAR_ˮ����, info=CONST.����_ˮ, skillId=9612 , val = 1.05},              --��ˮ���Զ��������˺�
             { MettleType=3, type=CONST.CHAR_������, info=CONST.����_��, skillId=9613 , val = 1.05},              --�Ի����Զ��������˺�
             { MettleType=3, type=CONST.CHAR_������, info=CONST.����_��, skillId=9614 , val = 1.05},              --�Է����Զ��������˺�
             { MettleType=4, type=CONST.CHAR_������, info=CONST.����_��, skillId=9615 , val = 0.95},              --�������Ե����Զ����˺�
             { MettleType=4, type=CONST.CHAR_ˮ����, info=CONST.����_ˮ, skillId=9616 , val = 0.95},              --��������ˮ���Զ����˺�
             { MettleType=4, type=CONST.CHAR_������, info=CONST.����_��, skillId=9617 , val = 0.95},              --�������Ի����Զ����˺�
             { MettleType=4, type=CONST.CHAR_������, info=CONST.����_��, skillId=9618 , val = 0.95},              --�������Է����Զ����˺�
             { MettleType=2, type=CONST.CHAR_EnemyBossFlg, info=CONST.Enemy_�Ƿ�BOSS, skillId=9619 , val = 0.85},              --��������BOSS�����˺�
             { MettleType=5, type=CONST.CHAR_����, info=CONST.����_����, skillId=9620 , val = 1.25},              --������ϵ���������˺�
             { MettleType=5, type=CONST.CHAR_����, info=CONST.����_��, skillId=9621 , val = 1.25},              --������ϵ���������˺�
             { MettleType=5, type=CONST.CHAR_����, info=CONST.����_����, skillId=9622 , val = 1.25},              --�Բ���ϵ���������˺�
             { MettleType=5, type=CONST.CHAR_����, info=CONST.����_����, skillId=9623 , val = 1.25},              --�Է���ϵ���������˺�
             { MettleType=5, type=CONST.CHAR_����, info=CONST.����_����, skillId=9624 , val = 1.25},              --������ϵ���������˺�
             { MettleType=5, type=CONST.CHAR_����, info=CONST.����_ֲ��, skillId=9625 , val = 1.25},              --��ֲ��ϵ���������˺�
             { MettleType=5, type=CONST.CHAR_����, info=CONST.����_Ұ��, skillId=9626 , val = 1.25},              --��Ұ��ϵ���������˺�
             { MettleType=5, type=CONST.CHAR_����, info=CONST.����_����, skillId=9627 , val = 1.25},              --������ϵ���������˺�
             { MettleType=5, type=CONST.CHAR_����, info=CONST.����_����, skillId=9628 , val = 1.25},              --�Խ���ϵ���������˺�
             { MettleType=5, type=CONST.CHAR_����, info=CONST.����_аħ, skillId=9629 , val = 1.05},              --��аħϵ���������˺�
}

--- ����ģ�鹳��
function YbPetSkill:onLoad()
  self:logInfo('load')
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
  self:regCallback('TechOptionEvent', Func.bind(self.OnTechOptionEventCallBack, self))
end

--��ȡ����װ��-ˮ��
Pet.GetCrystal = function(petIndex)
  local ItemIndex = Char.GetItemIndex(petIndex, CONST.�����_ˮ��);
  if ItemIndex >= 0 and Item.GetData(ItemIndex, CONST.����_����)==CONST.��������_����ˮ�� then
    return ItemIndex,CONST.�����_ˮ��;
  end
  return -1,-1;
end

function YbPetSkill:AwakenEvoDamage(charIndex, defCharIndex, damage, battleIndex, flg)
        if Char.IsPet(charIndex) then
            local PetCrystalIndex = Pet.GetCrystal(charIndex);                --������
            local PetCrystal_Name = Item.GetData(PetCrystalIndex, CONST.����_����);
            local Attack = Char.GetData(charIndex,CONST.CHAR_������);
            local Defense = Char.GetData(charIndex,CONST.CHAR_������);
            local Agile = Char.GetData(charIndex,CONST.CHAR_����);
            local Spirit = Char.GetData(charIndex,CONST.CHAR_����);
            local Recover = Char.GetData(charIndex,CONST.CHAR_�ظ�);
            if PetCrystal_Name~=nil then
                 local wandId = Item.GetData(PetCrystalIndex, CONST.����_ID);
                 local bindId = Item.GetData(PetCrystalIndex, CONST.����_��������);
                 local typeId = Item.GetData(PetCrystalIndex, CONST.����_�Ӳ�һ);
                 local typeLv = Item.GetData(PetCrystalIndex, CONST.����_�Ӳζ�);
                 local Slot = Char.HavePet(Pet.GetOwner(charIndex), bindId);
                 local EnemyId = Char.GetPet(Pet.GetOwner(charIndex), Slot);
                 local typeList = { {0.02,0.05,0.05,0.05,0.08}, {0.08,0.05,0.05,0.05,0.02}, {0.05,0.08,0.05,0.03,0.03}, {0.03,0.05,0.08,0.03,0.05}, {0.05,0.03,0.03,0.08,0.05}, {0.05,0.05,0.05,0.05,0.05}}
                 if (wandId==69031 or wandId==69040)  then
                        table.forEach(typeList, function(e)
                            for k, v in ipairs(typeList) do
                                if (EnemyId==charIndex and Char.GetData(charIndex,CONST.PET_DepartureBattleStatus)==CONST.PET_STATE_ս�� and typeId>0 and typeId==k) then
                                    if flg==CONST.DamageFlags.Normal or flg==CONST.DamageFlags.Critical then
                                        if (typeId==1 or typeId==2 or typeId==4 or typeId==6 or typeId==3) then
                                            if typeLv<10 then typeLvRate=1.1;
                                            elseif typeLv>=10 and typeLv<20  then typeLvRate=1.2;
                                            elseif typeLv>=20 then typeLvRate=1.3; end
                                            damage = damage + typeLvRate * (Attack * v[1] + Defense * v[2] + Agile * v[3] + Spirit * v[4] + Recover * v[5]);
                                            --NLG.Say(-1,-1,"���X��֮������������",4,3);
                                            return damage;
                                        end
                                    elseif flg==CONST.DamageFlags.Magic then
                                        if (typeId==5 or typeId==6) then
                                            if typeLv<10 then typeLvRate=3;
                                            elseif typeLv>=10 and typeLv<20  then typeLvRate=3.1;
                                            elseif typeLv>=20 then typeLvRate=3.2; end
                                            damage = damage + typeLvRate * (Attack * v[1] + Defense * v[2] + Agile * v[3] + Spirit * v[4] + Recover * v[5]);
                                            --NLG.Say(-1,-1,"���X��֮������������",4,3);
                                            return damage;
                                        end
                                    end
                                end
                            end
                        end)
                 end
            end
        end
    return damage;
end

function YbPetSkill:tempDamage(charIndex, defCharIndex, damage, battleIndex)
        for k, v in ipairs(petMettleTable) do
           if (v.MettleType==1 and Char.GetData(charIndex, CONST.CHAR_����) == CONST.��������_��)  then           --����BOSS�����Ը�
               for i=0,9 do
                   local skillId = Pet.GetSkill(charIndex, i)
                   if (skillId == v.skillId and Char.GetData(defCharIndex, v.type) == 1) then
                       damage = damage * v.val;
                       --NLG.Say(-1,-1,"�����Ը񱻶�Ч������",4,3);
                       return damage;
                   end
               end
           elseif (v.MettleType==2 and Char.GetData(defCharIndex, CONST.CHAR_����) == CONST.��������_��)  then     --�ܷ�BOSS�����Ը�
               for i=0,9 do
                   local skillId = Pet.GetSkill(defCharIndex, i)
                   if (skillId == v.skillId and Char.GetData(charIndex, v.type) == 1) then
                       damage = damage * v.val;
                       --NLG.Say(-1,-1,"�����Ը񱻶�Ч������",4,3);
                       return damage;
                   end
               end
           elseif (v.MettleType==3 and Char.GetData(charIndex, CONST.CHAR_����) == CONST.��������_��)  then            --������������س����Ը�
               for i=0,9 do
                   local skillId = Pet.GetSkill(charIndex, i)
                   if (skillId == v.skillId and Char.GetData(defCharIndex, v.type) >= 10) then
                       damage = damage * v.val;
                       --NLG.Say(-1,-1,"�����Ը񱻶�Ч������",4,3);
                       return damage;
                   end
               end
           elseif (v.MettleType==4 and Char.GetData(defCharIndex, CONST.CHAR_����) == CONST.��������_��)  then     --�ܷ���������س����Ը�
               for i=0,9 do
                   local skillId = Pet.GetSkill(defCharIndex, i)
                   if (skillId == v.skillId and Char.GetData(charIndex, v.type) >= 10) then
                       damage = damage * v.val;
                       --NLG.Say(-1,-1,"�����Ը񱻶�Ч������",4,3);
                       return damage;
                   end
               end
           elseif (v.MettleType==5 and Char.GetData(charIndex, CONST.CHAR_����) == CONST.��������_��)  then           --������������Ը�
               for i=0,9 do
                   local skillId = Pet.GetSkill(charIndex, i)
                   if (skillId == v.skillId and Char.GetData(defCharIndex, v.type) == v.info) then
                       damage = damage * v.val;
                       --NLG.Say(-1,-1,"�����Ը񱻶�Ч������",4,3);
                       return damage;
                   end
               end
           end

         end
    return damage;
end

function YbPetSkill:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
      --self:logDebug('OnDamageCalculateCallBack', charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
         local leader1 = Battle.GetPlayer(battleIndex,0)
         local leader2 = Battle.GetPlayer(battleIndex,5)
         local leader = leader1
         if Char.GetData(leader2, CONST.CHAR_����) == CONST.��������_�� then
               leader = leader2
         end
         if  flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Char.GetData(defCharIndex, CONST.CHAR_����) == CONST.��������_��  then  ---����Ϊ�����ܹ����¼�����������ֻ�ܶ�ѡһ
           local damage_temp = self:tempDamage(charIndex, defCharIndex, damage, battleIndex);
           local damage = damage_temp;
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
                 --NLG.Say(-1,-1,"����ս��ʱ�����ܵ��������˺�0%����Ч����ս����ÿ�غ����3%�����30%",4,3);
                 return damage;
               end
           end
           return damage;
         elseif  flg == CONST.DamageFlags.Magic and Char.GetData(defCharIndex, CONST.CHAR_����) == CONST.��������_��  then  ---����Ϊħ���ܹ����¼�����������ֻ�ܶ�ѡһ
           local damage_temp = self:tempDamage(charIndex, defCharIndex, damage, battleIndex);
           local damage = damage_temp;
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
                 --NLG.Say(-1,-1,"����ս��ʱ�����ܵ���ħ���˺�0%����Ч����ս����ÿ�غ����3%�����30%",4,3);
                 return damage;
               end
           end
           return damage;
         elseif  flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Char.GetData(charIndex, CONST.CHAR_����) == CONST.��������_��  then  ---����Ϊ�������¼�����������ֻ�ܶ�ѡһ
           --��ʦ��ɫ�ӳ�
           if (Char.GetData(charIndex,CONST.����_ս��Side)==0 and Battle.GetType(battleIndex)==1) then
               claws = Char.GetTempData(leader, '�׻�צ') or 0;
               teeth = Char.GetTempData(leader, '�ڱ���') or 0;
               horns = Char.GetTempData(leader, '���߽�') or 0;
               damage = damage*math.floor( (1+(claws+teeth+horns)/10) );
           end
           --����ӳ�
           local damage_temp = self:tempDamage(charIndex, defCharIndex, damage, battleIndex);
           local damage_TA = damage_temp + self:AwakenEvoDamage(charIndex, defCharIndex, damage, battleIndex, flg);
           local damage = math.floor(damage_TA*0.5);
           --print(damage_temp,damage_TA,damage)
           --�����ؼ�
           if (com3 == 9509)  then    --���LѸ��
               local State = Char.GetTempData(defCharIndex, '��͸') or 0;
               print(State)
               if (State>=0 and State<=12) then
                   Char.SetTempData(defCharIndex, '��͸', State+1);
                   damage = damage * ((State+1)/12);
                   return damage;
               elseif (State>=13)  then
                   Char.SetTempData(defCharIndex, '��͸', 0);
                   damage = damage * 1;
                   return damage;
               end
           end
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
           return damage;
         elseif  flg == CONST.DamageFlags.Magic and Char.GetData(charIndex, CONST.CHAR_����) == CONST.��������_��  then
           --��ʦ��ɫ�ӳ�
           if (Char.GetData(charIndex,CONST.����_ս��Side)==0 and Battle.GetType(battleIndex)==1) then
               claws = Char.GetTempData(leader, '�׻�צ') or 0;
               teeth = Char.GetTempData(leader, '�ڱ���') or 0;
               horns = Char.GetTempData(leader, '���߽�') or 0;
               damage = damage*math.floor( (1+(claws+teeth+horns)/10) );
           end
           --����ӳ�
           local damage_temp = self:tempDamage(charIndex, defCharIndex, damage, battleIndex);
           local damage_TA = damage_temp + self:AwakenEvoDamage(charIndex, defCharIndex, damage, battleIndex, flg);
           local damage = math.floor(damage_TA*0.5);
           --�����ؼ�
           if (com3 == 2729) then    --ǧ�xʯ��-SE
               
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
               if Char.GetData(leader,%����_���Ŀ���%) == 1  then
                      NLG.Say(leader,charIndex,"��ħ������������",4,3);
               end
		if NLG.Rand(1,10)>=8  then
                   Char.SetData(defCharIndex, CONST.CHAR_BattleModStone, 2);
                   NLG.UpChar(defCharIndex);
               end
           return damage;
		end
         end
  return damage;
end


function YbPetSkill:OnTechOptionEventCallBack(charIndex, option, techID, val)
      --self:logDebug('OnTechOptionEventCallBack', charIndex, option, techID, val)
      if Char.IsDummy(charIndex) then
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
end

--- ж��ģ�鹳��
function YbPetSkill:onUnload()
  self:logInfo('unload')
end

return YbPetSkill;
