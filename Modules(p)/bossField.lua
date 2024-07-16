---ģ����
local Module = ModuleBase:createModule('bossField')

local RaceRatelist = {}

local PhyVoid = {406199}  --������Чenemyid
local MagicVoid = {406198} --ħ����Чenemyid
local ElmTech = {} or nil
local damage_Max = 99999;

--- ����ģ�鹳��
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
                  Char.SetTempData(enemy, '��ס', 3);
                  Char.SetTempData(enemy, '��', 3);
                  if Char.GetData(player,CONST.����_��ս����) == 1  then
                     NLG.Say(player,-1,"����ס�I�򡿡����I��",4,3);
                 end
              end
         end
end

function Module:OnAfterBattleTurnCommand(battleIndex)
	local Round = Battle.GetTurn(battleIndex);
	local leader1 = Battle.GetPlayer(battleIndex,0)
	local leader2 = Battle.GetPlayer(battleIndex,5)
	local leader = leader1
	if Char.GetData(leader2, CONST.CHAR_����) == CONST.��������_�� then
		leader = leader2
	end
	local Target_FloorId = Char.GetData(leader,CONST.CHAR_��ͼ);
	if (Target_FloorId==25013) then
		FieldEffect = 1;
	end
	for i = 0, 9 do
		local player = Battle.GetPlayer(battleIndex, i);
		if (player>=0 and math.fmod(Round, 2)==0 and FieldEffect==1)  then
			local playerHP = Char.GetData(player, CONST.CHAR_Ѫ);
			if (playerHP>=500) then
				Char.SetData(player, CONST.CHAR_Ѫ, playerHP*0.7);
			end
			--if Char.GetData(player,CONST.����_��ս����) == 1  then
				NLG.Say(player,-1,"�ܵ����D���n�����I��Ӱ�ÿ�غ϶����p��30%������",4,3);
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
         if Char.GetData(leader2, CONST.CHAR_����) == CONST.��������_�� then
               leader = leader2
         end
         if (com3==6219 or com3==6319 )  then
             if Char.IsEnemy(defCharIndex) then
                 local Buff1 = Char.GetTempData(defCharIndex, '��ס') or 0;
                 local Buff2 = Char.GetTempData(defCharIndex, '��') or 0;
                 if (Buff1 > 0 or Buff2 > 0)  then
                       if (Buff1>=2 or Buff2>=2)  then
                           Char.SetTempData(defCharIndex, '��ס', 1);
                           Char.SetTempData(defCharIndex, '��', 1);
                           if Char.GetData(leader,CONST.����_��ս����) == 1  then
                               NLG.Say(leader,-1,"����ס�I�򡿡����I�򡿽���1��",4,3);
                           end
                       elseif (Buff1==1 or Buff2==1)  then
                           Char.SetTempData(defCharIndex, '��ס', 0);
                           Char.SetTempData(defCharIndex, '��', 0);
                           if Char.GetData(leader,CONST.����_��ս����) == 1  then
                               NLG.Say(leader,-1,"����ס�I�򡿡����I�򡿽���0��",4,3);
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
         if Char.GetData(leader2, CONST.CHAR_����) == CONST.��������_�� then
               leader = leader2
         end

         if flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Char.IsEnemy(defCharIndex)  then
               --�������(����oЧ)
               if CheckInTable(PhyVoid,Char.GetData(defCharIndex,CONST.����_ENEMY_ID))==true and (flg == 0 or flg == 8 or flg == 1 or flg == 9) then
                              damage = 1;
               end
               --�������(ħ����Ч)
               if CheckInTable(MagicVoid,Char.GetData(defCharIndex,CONST.����_ENEMY_ID))==true and flg == 5 then
                              damage = 1;
               end
               --�I����ס
               local GTime = NLG.GetGameTime();
               if (GTime>=0)  then
                     local State = Char.GetTempData(defCharIndex, '��ס') or 0;
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
                                 if Char.GetData(leader,CONST.����_��ս����) == 1  then
                                     NLG.Say(leader,-1,"����ס�������ܵ��Ă�������ֵ��"..damage_Max.."����סʣ�N"..State.."��",4,3);
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
                     local State = Char.GetTempData(charIndex, '��') or 0;
                     if (Char.GetData(charIndex, CONST.CHAR_EnemyBossFlg) == 1) then
                         local d1= Char.GetData(charIndex, CONST.CHAR_������);
                         local d2= Char.GetData(defCharIndex, CONST.CHAR_������);
                         local d3= Char.GetData(defCharIndex, CONST.CHAR_������);
                         local d4= Char.GetData(defCharIndex, CONST.CHAR_����);
                         if (State>0) then
                            if d2>=500 and d2<=4000 then
                                 local damage_Max = (d1*0.8)-(d3-120)*10+(d4*State/100);
                                 if damage_Max<=9 then damage_Max = 9; end
                                 if damage_Max>=99 then damage_Max = 99; end
                                 damage = damage+damage_Max;
                                 if Char.GetData(leader,CONST.����_��ս����) == 1  then
                                     NLG.Say(leader,-1,"���񱩡�������ߌ�����~�������"..damage_Max.."����ʣ�N"..State.."��",4,3);
                                 end
                                 return damage;
                            elseif d2>=4001 and d2<=9999 then
                                 local damage_Max = (d1*0.8)-(d3-180)*10+(d4*State/10);
                                 if damage_Max<=99 then damage_Max = 99; end
                                 if damage_Max>=999 then damage_Max = 999; end
                                 damage = damage+damage_Max;
                                 if Char.GetData(leader,CONST.����_��ս����) == 1  then
                                     NLG.Say(leader,-1,"���񱩡�������ߌ�����~�������"..damage_Max.."����ʣ�N"..State.."��",4,3);
                                 end
                                 return damage;
                            elseif d2>=10000 then
                                 local damage_Max = (d1*0.8)-(d3-240)*10+(d4*State/1);
                                 if damage_Max<=999 then damage_Max = 999; end
                                 if damage_Max>=9999 then damage_Max = 9999; end
                                 damage = damage+damage_Max;
                                 if Char.GetData(leader,CONST.����_��ս����) == 1  then
                                     NLG.Say(leader,-1,"���񱩡�������ߌ�����~�������"..damage_Max.."����ʣ�N"..State.."��",4,3);
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
               local StatsRate_Mind = 1;  --�쳣״̬�Ծ���Ӱ�����(��Ӱ���ɱ��ʽ��ľ���)
               local StatsRate_critical = 1; --�쳣״̬�Ա�ɱ���ʵ�Ӱ�����
               local StatsRate_dmg = 1; --�쳣״̬���˺�(�Ǳ�ɱ)��Ӱ�����
               local StatsRate_Cdmg = 1; --�쳣״���˺�(��ɱ)��Ӱ�����
               local ServerRate = 0.5;
               local Amnd_R = Char.GetData(charIndex, CONST.CHAR_����);
               local Amnd = math.max(Conver_240(Amnd_R * StatsRate_Mind),1);
               local TechRate = (Battle.GetTechOption(charIndex,"AR:") + Battle.GetTechOption(charIndex,"D1:"))/60 + 0.5;
               print("TechRate:"..TechRate)

               local Dmnd_R = math.max(Char.GetData(defCharIndex, CONST.CHAR_����),100);
               local Dmnd = Conver_240(Dmnd_R * StatsRate_Mind);

               local dp = {}
               dp[1] = Char.GetData(defCharIndex, CONST.CHAR_������);
               dp[2] = Char.GetData(defCharIndex, CONST.CHAR_ˮ����);
               dp[3] = Char.GetData(defCharIndex, CONST.CHAR_������);
               dp[4] = Char.GetData(defCharIndex, CONST.CHAR_������);
               local AttRate_1 = 1;
               if ElmTech[com3] ~= nil then
                              AttRate_1 = Battle.CalcPropScore(ElmTech[com3], dp);
               end
               local AttRate_2 = Battle.CalcAttributeDmgRate(charIndex, defCharIndex);
               local AttRate = (AttRate_1 - 1) + (AttRate_2 - 1) * 0.5 + 1;
               local RaceRate = Battle.CalcTribeDmgRate(charIndex, defCharIndex) + 1;
               local RndRate = NLG.Rand(90,110) / 100;

               local dmg = math.floor( ((Amnd / (0.67 + Dmnd / Amnd))* TechRate )* AttRate * RaceRate * RndRate * StatsRate_dmg * ServerRate);
               --print("Amnd_R:"..Amnd_R.." Dmnd_R:"..Dmnd_R.." Matk:"..Matk.." AttRate:"..AttRate.." RaceRate"..RaceRate.." RndRate"..RndRate);
               print("Amnd_R:"..Amnd_R.." Dmnd_R:"..Dmnd_R.." AttRate:"..AttRate.." RaceRate"..RaceRate.." RndRate"..RndRate);

               --��������
               local criticalDmg = 0;
               local criticalRate = NLG.Rand(1,200);
               local char_cr = math.floor((Char.GetData(charIndex, CONST.����_��ɱ) - Char.GetData(defCharIndex, CONST.����_��ɱ)) * StatsRate_critical);
               print("char_cr:"..char_cr)
               if criticalRate <= char_cr then
                              criticalDmg = math.floor(Dmnd_R * 1 * Char.GetData(charIndex, CONST.CHAR_�ȼ�) / Char.GetData(defCharIndex, CONST.CHAR_�ȼ�) * StatsRate_Cdmg);
               end		
               damage = dmg + criticalDmg;
               --�I��ӏ�
               local GTime = NLG.GetGameTime();
               if (GTime==2)  then
                     local State = Char.GetTempData(charIndex, '��') or 0;
                     if (Char.GetData(charIndex, CONST.CHAR_EnemyBossFlg) == 1) then
                         local d1= Char.GetData(charIndex, CONST.CHAR_����);
                         local d2= Char.GetData(defCharIndex, CONST.CHAR_����);
                         local d3= Char.GetData(defCharIndex, CONST.CHAR_ħ��);
                         local d4= Char.GetData(defCharIndex, CONST.CHAR_������);
                         if (State>0) then
                            if (com3 == 2729)  then    --ǧ�xʯ��-SE
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
                                 if Char.GetData(leader,CONST.����_��ս����) == 1  then
                                     NLG.Say(leader,-1,"���񱩡�������ߌ�����~�������"..damage_Max.."����ʣ�N"..State.."��",4,3);
                                 end
                                 return damage;
                            elseif d2>=2001 and d2<=9999 then
                                 local damage_Max = (d1*0.8)-(d3-100)*10+(d4*State/10);
                                 if damage_Max<=99 then damage_Max = 99; end
                                 if damage_Max>=999 then damage_Max = 999; end
                                 damage = damage+damage_Max;
                                 if Char.GetData(leader,CONST.����_��ս����) == 1  then
                                     NLG.Say(leader,-1,"���񱩡�������ߌ�����~�������"..damage_Max.."����ʣ�N"..State.."��",4,3);
                                 end
                                 return damage;
                            elseif d2>=10000 then
                                 local damage_Max = (d1*0.8)-(d3-240)*10+(d4*State/1);
                                 if damage_Max<=999 then damage_Max = 999; end
                                 if damage_Max>=9999 then damage_Max = 9999; end
                                 damage = damage+damage_Max;
                                 if Char.GetData(leader,CONST.����_��ս����) == 1  then
                                     NLG.Say(leader,-1,"���񱩡�������ߌ�����~�������"..damage_Max.."����ʣ�N"..State.."��",4,3);
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


function CheckInTable(_idTab, _idVar) ---ѭ������
	for k,v in pairs(_idTab) do
		if v==_idVar then
			return true
		end
	end
	return false
end

function Conver_240(Num)
	if Num >= 240 then
		local a = math.floor((Num - 240 ) * 0.3 + 240)
		return a
	else
		return Num
	end
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;