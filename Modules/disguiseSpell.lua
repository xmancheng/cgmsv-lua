---ģ����
local DisguiseSpell = ModuleBase:createModule('disguiseSpell')

Spell_control ={}
for ddd = 0,10 do
	Spell_control[ddd] = {}
	Spell_control[ddd][0] = 0  --��ʼ��ָ��غ���
	Spell_control[ddd][1] = 0  --��ʼ�������غ���
end

Spell_tbl = {}
--��������
Spell_tbl[1] = {5014,5019}   --һ���techID���·�Spell_tbl.Techһ��techҪ����һ���趨
Spell_tbl[2] = {5114,5119}
Spell_tbl[3] = {5214,5219}
Spell_tbl[4] = {5314,5319}
--�ܷ�����
--Spell_tbl[5] = {6519,6219,6619,6329}
--Spell_tbl[6] = {26116,26117,26118}


Spell_tbl.Tech = {}
-----------------------------------------------------------
Spell_tbl.Tech[5014] = {110351,2,CONST.CHAR_������,0.5}   --��ɵ�ԭ�α�š��Բʳ����غϡ���ʵ�˺���Դ��ת������
Spell_tbl.Tech[5019] = {110351,2,CONST.CHAR_������,0.5}
-----------------------------------------------------------
Spell_tbl.Tech[5114] = {110357,2,CONST.CHAR_�ظ�,0.25}
Spell_tbl.Tech[5119] = {110357,2,CONST.CHAR_�ظ�,0.25}
-----------------------------------------------------------
Spell_tbl.Tech[5214] = {110363,2,CONST.CHAR_������,0.125}
Spell_tbl.Tech[5219] = {110363,2,CONST.CHAR_������,0.125}
-----------------------------------------------------------
Spell_tbl.Tech[5314] = {110369,2,CONST.CHAR_����,0.25}
Spell_tbl.Tech[5319] = {110369,2,CONST.CHAR_����,0.25}
-----------------------------------------------------------
--Spell_tbl.Tech[6519] = {110599,1,CONST.CHAR_���Ѫ,0.25}   --��ɵ�ԭ�α�š��Բʳ����غϡ����ٹ̶��˺���Դ��ת������
--Spell_tbl.Tech[6219] = {110599,1,CONST.CHAR_���Ѫ,0.25}
--Spell_tbl.Tech[6619] = {110599,2,CONST.CHAR_���Ѫ,0.25}
--Spell_tbl.Tech[6329] = {110599,2,CONST.CHAR_���Ѫ,0.25}
-----------------------------------------------------------
--Spell_tbl.Tech[26116] = {120160,1,CONST.CHAR_������,2}   --��ɵ�ԭ�α�š��Բʳ����غϡ����ٹ̶��˺���Դ��ת������
--Spell_tbl.Tech[26117] = {120160,2,CONST.CHAR_������,2}
--Spell_tbl.Tech[26118] = {120160,3,CONST.CHAR_������,2}
-----------------------------------------------------------

--- ����ģ�鹳��
function DisguiseSpell:onLoad()
  self:logInfo('load')
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
  self:regCallback('TechOptionEvent', Func.bind(self.OnTechOptionEventCallBack, self))
  self:regCallback('BattleOverEvent', Func.bind(self.battleOverEventCallback, self))
  self:regCallback('BeforeBattleTurnEvent', Func.bind(self.handleBattleAutoCommand, self))
end

function DisguiseSpell:handleBattleAutoCommand(battleIndex)
               local battleturn = Battle.GetTurn(battleIndex);
               for i = 0, 19 do
                     local charIndex = Battle.GetPlayer(battleIndex, i);
                     if charIndex >= 0 then
                           if Char.GetData(charIndex, CONST.CHAR_����) == CONST.��������_�� then
                                 if (battleturn == 0) then
                                     Spell_control[charIndex][0] = 0;
                                     Spell_control[charIndex][1] = 0;
                                  --�غϼ���
                                 elseif (battleturn > Spell_control[charIndex][0]) then
                                     Spell_control[charIndex][0] = battleturn;
                                     Spell_control[charIndex][1] = Spell_control[charIndex][1] + 1;
                                     for i,w in pairs(Spell_tbl.Tech) do
                                         if (Spell_control[charIndex][1] >= w[2]) then                               --�˺������غϱ��λ�ԭ
                                             local PlayerImage = Char.GetData(charIndex,%����_ԭʼͼ��%);
                                             Char.SetData(charIndex,%����_ԭ��%,PlayerImage);
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
                         if (Char.GetData(charIndex,%����_ԭ��%) == w[1]) then
                            local PlayerImage = Char.GetData(charIndex,%����_ԭʼͼ��%);
                            Char.SetData(charIndex,%����_ԭ��%,PlayerImage);
                            NLG.UpChar(charIndex);
                         end
               end
         end
end

function DisguiseSpell:OnTechOptionEventCallBack(charIndex, option, techID, val)
         --self:logDebug('OnTechOptionEventCallBack', charIndex, option, techID, val)
         --ʹ�ü���ʱ�����Ӧ�Բ�
         for i,w in pairs(Spell_tbl.Tech) do
               if (techID == i) then
                  --NLG.Say(charIndex,charIndex,"��Ů����o������",4,3);
                  Char.SetData(charIndex,%����_ԭ��%,w[1]);
                  NLG.UpChar(charIndex);
                  Spell_control[charIndex][1] = 0;
               end
         end

end

function DisguiseSpell:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
      --self:logDebug('OnDamageCalculateCallBack', charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
         local leader1 = Battle.GetPlayer(battleIndex,0)
         local leader2 = Battle.GetPlayer(battleIndex,5)
         local leader = leader1
         --print(charIndex)
         if Char.GetData(leader2, CONST.CHAR_����) == CONST.��������_�� then
               leader = leader2
         end
         if flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Char.GetData(charIndex, CONST.CHAR_����) == CONST.��������_��  then
            for i,w in pairs(Spell_tbl.Tech) do
                  if (Char.GetData(charIndex,%����_ԭ��%) == w[1]) then               --ԭ�����Ӷ�����ʵ�˺�
                        local Attack = Char.GetData(charIndex,w[3]);
                        local damage = damage + Attack*w[4];
                        print(damage)
                        return damage;
                  end
            end

--         elseif flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge and Char.GetData(defCharIndex, CONST.CHAR_����) == CONST.��������_��  then
--            for i,w in pairs(Spell_tbl.Tech) do
--                  if (Char.GetData(defCharIndex,%����_ԭ��%) == w[1]) then         --ԭ�μ��ٹ̶���ֵ�˺�
--                        local Injury = Char.GetData(defCharIndex,w[3]);
--                        local damage = damage - Injury*w[4];
--                        if damage<=1 then
--                               damage = 1;
--                        end
--                        print(damage)
--                        return damage;
--                  end
--            end

         else
         end
  return damage;
end

--- ж��ģ�鹳��
function DisguiseSpell:onUnload()
  self:logInfo('unload')
end

return DisguiseSpell;
