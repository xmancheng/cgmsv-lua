---ģ����
local Module = ModuleBase:createModule('battleMirrorDevil')

-- {skillId,	com1,	com3(techId),	0 ���� |1 �Է���Ŀǰû�ã� ��Ŀ������λ�� 0 sigle| 1 range | 2 sideall |3 whole }
skillParams={
	-- ����
	{skillId=0,com1=CONST.BATTLE_COM.BATTLE_COM_P_RENZOKU,techId={0,99},side=1,unit=0},
	-- ����
	{skillId=1,com1=CONST.BATTLE_COM.BATTLE_COM_P_PARAMETER,techId={100,199},side=1,unit=0},
	-- Ǭ��
	{skillId=3,com1=CONST.BATTLE_COM.BATTLE_COM_P_PARAMETER,techId={300,399},side=1,unit=0},
	-- ������
	{skillId=4,com1=CONST.BATTLE_COM.BATTLE_COM_P_SPIRACLESHOT,techId={400,499},side=1,unit=0},
	-- ����
	{skillId=5,com1=CONST.BATTLE_COM.BATTLE_COM_P_GUARDBREAK,techId={500,599},side=1,unit=0},
	-- ս��Ϯ��
	{skillId=6,com1=CONST.BATTLE_COM.BATTLE_COM_P_FORCECUT,techId={600,699},side=1,unit=0},
	-- ����
	{skillId=7,com1=CONST.BATTLE_COM.BATTLE_COM_P_BODYGUARD,techId={700,799},side=0,unit=0},
	-- ʥ��
	{skillId=8,com1=CONST.BATTLE_COM.BATTLE_COM_P_SPECIALGARD,techId={800,899},side=0,unit=0},
	-- ����
	{skillId=9,com1=CONST.BATTLE_COM.BATTLE_COM_P_DODGE,techId={900,999},side=1,unit=0},
	-- ����ħ������
	{skillId=10,com1=CONST.BATTLE_COM.BATTLE_COM_P_MAGICGARD,techId={1000,1000},side=0,unit=0},
	-- ����
	{skillId=11,com1=CONST.BATTLE_COM.BATTLE_COM_P_CROSSCOUNTER,techId={1100,1199},side=0,unit=0},
	-- ����ֹˮ
	{skillId=12,com1=CONST.BATTLE_COM.BATTLE_COM_P_CONSENTRATION,techId={1200,1299},side=0,unit=0},
	-- ��ʯħ��
	{skillId=19,com1=CONST.BATTLE_COM.BATTLE_COM_P_MAGIC,techId={1900,1999},side=1,unit=0},
	-- ����ħ��
	{skillId=20,com1=CONST.BATTLE_COM.BATTLE_COM_P_MAGIC,techId={2000,2099},side=1,unit=0},
	-- ����ħ��
	{skillId=21,com1=CONST.BATTLE_COM.BATTLE_COM_P_MAGIC,techId={2100,2199},side=1,unit=0},
	-- ����ħ��
	{skillId=22,com1=CONST.BATTLE_COM.BATTLE_COM_P_MAGIC,techId={2200,2299},side=1,unit=0},
	-- ǿ����ʯ
	{skillId=23,com1=CONST.BATTLE_COM.BATTLE_COM_P_MAGIC,techId={2300,2399},side=1,unit=1},
	-- ǿ������
	{skillId=24,com1=CONST.BATTLE_COM.BATTLE_COM_P_MAGIC,techId={2400,2499},side=1,unit=1},
	-- ǿ������
	{skillId=25,com1=CONST.BATTLE_COM.BATTLE_COM_P_MAGIC,techId={2500,2599},side=1,unit=1},
	-- ǿ������
	{skillId=26,com1=CONST.BATTLE_COM.BATTLE_COM_P_MAGIC,techId={2600,2699},side=1,unit=1},
	-- ��ǿ��ʯ
	{skillId=27,com1=CONST.BATTLE_COM.BATTLE_COM_P_MAGIC,techId={2700,2799},side=1,unit=2},
	-- ��ǿ����
	{skillId=28,com1=CONST.BATTLE_COM.BATTLE_COM_P_MAGIC,techId={2800,2899},side=1,unit=2},
	-- ��ǿ����
	{skillId=29,com1=CONST.BATTLE_COM.BATTLE_COM_P_MAGIC,techId={2900,2999},side=1,unit=2},
	-- ��ǿ����
	{skillId=30,com1=CONST.BATTLE_COM.BATTLE_COM_P_MAGIC,techId={3000,3099},side=1,unit=2},
	-- ��Ѫħ��
	{skillId=31,com1=CONST.BATTLE_COM.BATTLE_COM_P_DORAIN,techId={3100,3199},side=1,unit=0},
	-- �ж�ħ��
	{skillId=32,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={3200,3299},side=1,unit=0},
	-- ��˯ħ��
	{skillId=33,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={3300,3399},side=1,unit=0},
	-- ʯ��ħ��
	{skillId=34,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={3400,3499},side=1,unit=0},
	-- ����ħ��
	{skillId=35,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={3500,3599},side=1,unit=0},
	-- ����ħ��
	{skillId=36,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={3600,3699},side=1,unit=0},
	-- ����ħ��
	{skillId=37,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={3700,3799},side=1,unit=0},
	-- ǿ���ж�ħ��
	{skillId=38,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={3800,3899},side=1,unit=1},
	-- ǿ����˯ħ��
	{skillId=39,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={3900,3999},side=1,unit=1},
	-- ǿ��ʯ��ħ��
	{skillId=40,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={4000,4099},side=1,unit=1},
	-- ǿ������ħ��
	{skillId=41,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={4100,4199},side=1,unit=1},
	-- ǿ������ħ��
	{skillId=42,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={4200,4299},side=1,unit=1},
	-- ǿ������ħ��
	{skillId=43,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={4300,4399},side=1,unit=1},
	-- ��ǿ�ж�ħ��
	{skillId=44,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={4400,4499},side=1,unit=2},
	-- ��ǿ��˯ħ��
	{skillId=45,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={4500,4599},side=1,unit=2},
	-- ��ǿʯ��ħ��
	{skillId=46,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={4600,4699},side=1,unit=2},
	-- ��ǿ����ħ��
	{skillId=47,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={4700,4799},side=1,unit=2},
	-- ��ǿ����ħ��
	{skillId=48,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={4800,4899},side=1,unit=2},
	-- ��ǿ����ħ��
	{skillId=49,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={4900,4999},side=1,unit=2},
	-- ��ص���
	{skillId=50,com1=CONST.BATTLE_COM.BATTLE_COM_P_TREAT_TYPE,techId={5000,5099},side=0,unit=0},
	-- �������
	{skillId=51,com1=CONST.BATTLE_COM.BATTLE_COM_P_TREAT_TYPE,techId={5100,5199},side=0,unit=0},
	-- �������
	{skillId=52,com1=CONST.BATTLE_COM.BATTLE_COM_P_TREAT_TYPE,techId={5200,5299},side=0,unit=0},
	-- ��Ⱥ����
	{skillId=53,com1=CONST.BATTLE_COM.BATTLE_COM_P_TREAT_TYPE,techId={5300,5399},side=0,unit=0},
	-- ���Է�ת
	{skillId=54,com1=CONST.BATTLE_COM.BATTLE_COM_P_REVERSE_TYPE,techId={5400,5499},side=0,unit=0},
	-- ��������
	{skillId=55,com1=CONST.BATTLE_COM.BATTLE_COM_P_REFLECTION_PHYSICS,techId={5500,5599},side=0,unit=0},
	-- ħ������
	{skillId=56,com1=CONST.BATTLE_COM.BATTLE_COM_P_REFLECTION_MAGIC,techId={5600,5699},side=0,unit=0},
	-- ��������
	{skillId=57,com1=CONST.BATTLE_COM.BATTLE_COM_P_ABSORB_PHYSICS,techId={5700,5799},side=0,unit=0},
	-- ħ������
	{skillId=58,com1=CONST.BATTLE_COM.BATTLE_COM_P_ABSORB_MAGIC,techId={5800,5899},side=0,unit=0},
	-- ������Ч
	{skillId=59,com1=CONST.BATTLE_COM.BATTLE_COM_P_INEFFECTIVE_PHYSICS,techId={5900,5999},side=0,unit=0},
	-- ħ����Ч
	{skillId=60,com1=CONST.BATTLE_COM.BATTLE_COM_P_INEFFECTIVE_MAGIC,techId={6000,6099},side=0,unit=0},
	-- ��Ѫ
	{skillId=61,com1=CONST.BATTLE_COM.BATTLE_COM_P_HEAL,techId={6100,6199},side=0,unit=0},
	-- ǿ����Ѫ
	{skillId=62,com1=CONST.BATTLE_COM.BATTLE_COM_P_HEAL,techId={6200,6299},side=0,unit=1},
	-- ��ǿ��Ѫ
	{skillId=63,com1=CONST.BATTLE_COM.BATTLE_COM_P_HEAL,techId={6300,6399},side=0,unit=2},
	-- �ָ�
	{skillId=64,com1=CONST.BATTLE_COM.BATTLE_COM_P_LP_RECOVERY,techId={6400,6499},side=0,unit=0},
	-- ǿ���ָ�
	{skillId=65,com1=CONST.BATTLE_COM.BATTLE_COM_P_LP_RECOVERY,techId={6500,6599},side=0,unit=1},
	-- ��ǿ�ָ�
	{skillId=66,com1=CONST.BATTLE_COM.BATTLE_COM_P_LP_RECOVERY,techId={6600,6699},side=0,unit=2},
	-- �ྻ ����Ŀ��
	{skillId=67,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSRECOVER,techId={6700,6702},side=0,unit=0},
	-- �ྻ ǿ��Ŀ��
	{skillId=67,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSRECOVER,techId={6703,6705},side=0,unit=1},
	-- �ྻ ǿ��ǿĿ��
	{skillId=67,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSRECOVER,techId={6706,6799},side=0,unit=2},
	-- �����ظ�
	{skillId=68,com1=CONST.BATTLE_COM.BATTLE_COM_P_REVIVE,techId={6800,6899},side=0,unit=0},
	-- ����
	{skillId=72,com1=CONST.BATTLE_COM.BATTLE_COM_P_STEAL,techId={7200,7299},side=0,unit=0},
	-- ������ͨ����
	{skillId=73,com1=CONST.BATTLE_COM.BATTLE_COM_ATTACK,techId={7300,7300},side=1,unit=0},
	-- �������
	{skillId=74,com1=CONST.BATTLE_COM.BATTLE_COM_GUARD,techId={7400,7400},side=0,unit=0},
	-- ���ﶾ�Թ���
	{skillId=75,com1=CONST.BATTLE_COM.BATTLE_COM_M_STATUSATTACK,techId={7500,7599},side=1,unit=0},
	-- �����˯����
	{skillId=76,com1=CONST.BATTLE_COM.BATTLE_COM_M_STATUSATTACK,techId={7600,7699},side=1,unit=0},
	-- ����ʯ������
	{skillId=77,com1=CONST.BATTLE_COM.BATTLE_COM_M_STATUSATTACK,techId={7700,7799},side=1,unit=0},
	-- ���������
	{skillId=78,com1=CONST.BATTLE_COM.BATTLE_COM_M_STATUSATTACK,techId={7800,7899},side=1,unit=0},
	-- ������ҹ���
	{skillId=79,com1=CONST.BATTLE_COM.BATTLE_COM_M_STATUSATTACK,techId={7900,7999},side=1,unit=0},
	-- ������������
	{skillId=80,com1=CONST.BATTLE_COM.BATTLE_COM_M_STATUSATTACK,techId={8000,8099},side=1,unit=0},
	-- ������Ѫ����
	{skillId=81,com1=CONST.BATTLE_COM.BATTLE_COM_M_BLOODATTACK,techId={8100,8199},side=1,unit=0},
	-- ���ҹ���
	{skillId=94,com1=CONST.BATTLE_COM.BATTLE_COM_P_PANIC,techId={9400,9499},side=1,unit=0},
	-- ����
	{skillId=95,com1=CONST.BATTLE_COM.BATTLE_COM_P_RANDOMSHOT,techId={9500,9599},side=1,unit=0},
	-- ���ﶨ���ƶ�
	{skillId=160,com1=CONST.BATTLE_COM.BATTLE_COM_POSITION,techId={16000,16000},side=0,unit=0},
	-- ����ʲô������
	{skillId=170,com1=CONST.BATTLE_COM.BATTLE_COM_NONE,techId={15002,15002},side=0,unit=0},
	-- �佾����
	{skillId=1001,com1=CONST.BATTLE_COM.BATTLE_COM_DELAYATTACK,techId={25700,25799},side=1,unit=0},
	-- һ������
	{skillId=1002,com1=CONST.BATTLE_COM.BATTLE_COM_DELAYATTACK,techId={25800,25899},side=1,unit=0},
	-- ����
	{skillId=1003,com1=CONST.BATTLE_COM.BATTLE_COM_M_STATUSATTACK,techId={25900,25999},side=1,unit=0},
	-- һʯ����
	{skillId=1004,com1=CONST.BATTLE_COM.BATTLE_COM_BILLIARD,techId={26000,26099},side=1,unit=0},
	-- ��ʿ֮��
	{skillId=1005,com1=CONST.BATTLE_COM.BATTLE_COM_KNIGHTGUARD,techId={26100,26199},side=0,unit=0},
	-- Ѹ�ٹ���
	{skillId=1006,com1=CONST.BATTLE_COM.BATTLE_COM_FIRSTATTACK,techId={26200,26299},side=1,unit=0},
	-- ��ͷ����
	{skillId=1007,com1=CONST.BATTLE_COM.BATTLE_COM_COPY,techId={26300,26399},side=1,unit=0},
	-- �����Ӧ
	{skillId=1010,com1=CONST.BATTLE_COM.BATTLE_COM_RETRIBUTION,techId={26600,26699},side=1,unit=0},
	-- ׷��
	{skillId=2005,com1=CONST.BATTLE_COM.BATTLE_COM_BLASTWAVE,techId={200500,200599},side=1,unit=0},
}

local playerInfo = {
	{ Info=CONST.CHAR_���� },{ Info=CONST.CHAR_ԭ�� },{ Info=CONST.CHAR_�ȼ� },{ Info=CONST.CHAR_Ѫ },{ Info=CONST.CHAR_ħ },
	{ Info=CONST.CHAR_���� },{ Info=CONST.CHAR_���� },{ Info=CONST.CHAR_ǿ�� },{ Info=CONST.CHAR_�ٶ� },{ Info=CONST.CHAR_ħ�� },
	{ Info=CONST.CHAR_���� },{ Info=CONST.CHAR_������ },{ Info=CONST.CHAR_ˮ���� },{ Info=CONST.CHAR_������ },{ Info=CONST.CHAR_������ },
	{ Info=CONST.CHAR_���� },{ Info=CONST.CHAR_��˯ },{ Info=CONST.CHAR_��ʯ },{ Info=CONST.CHAR_���� },{ Info=CONST.CHAR_���� },{ Info=CONST.CHAR_���� },
	{ Info=CONST.CHAR_��ɱ },{ Info=CONST.CHAR_���� },{ Info=CONST.CHAR_���� },{ Info=CONST.CHAR_���� },
	{ Info=CONST.CHAR_ְҵ },{ Info=CONST.CHAR_ְ�� },{ Info=CONST.CHAR_ְ��ID },
	{ Info=CONST.CHAR_ԭʼͼ�� },{ Info=CONST.CHAR_���� },{ Info=CONST.CHAR_���Ѫ },{ Info=CONST.CHAR_���ħ },
	{ Info=CONST.CHAR_������ },{ Info=CONST.CHAR_������ },{ Info=CONST.CHAR_���� },{ Info=CONST.CHAR_���� },{ Info=CONST.CHAR_�ظ� },{ Info=CONST.CHAR_ħ�� },{ Info=CONST.CHAR_ħǿ },
}

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BattleStartEvent', Func.bind(self.OnbattleStartEventCallback, self))
  self:regCallback('BeforeBattleTurnEvent', Func.bind(self.OnBeforeBattleTurnCommand, self))
  self:regCallback('AfterBattleTurnEvent', Func.bind(self.OnAfterBattleTurnCommand, self))
  self:regCallback('EnemyCommandEvent', Func.bind(self.OnEnemyCommandCallBack, self))
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
  local devilNpc = self:NPC_createNormal('ˮ�R��ħʷ�Rķ', 101503, { map = 1000, x = 215, y = 90, direction = 4, mapType = 0 })
  self:NPC_regWindowTalkedEvent(devilNpc, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.����_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select == CONST.BUTTON_�� then
        return;
    end
    if select == CONST.BUTTON_�� then
        local EnemyIdAr = {406180, 406181, 406182, 406183, 406184, 406185, 406186, 406187, 406188, 406189}
        local BaseLevelAr = {66, 66, 66, 66, 66, 66, 66, 66, 66, 66}
        local BattleIndex = Battle.PVE(player, player, nil, EnemyIdAr, BaseLevelAr,  nil)
        Battle.SetWinEvent(nil, "DevilNpc_BattleWin", BattleIndex);
        --Battle.Encount(npc, player, "3|||0|||||3|406180|5|2|5|2|")
    end
  end)
  self:NPC_regTalkedEvent(devilNpc, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local winMsg = "\\n\\n\\n@c����Ҫ����ˮ�R��ħʷ�Rķ�᣿\\n";
      NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.BUTTON_�Ƿ�, 1, winMsg);
    end
    return
  end)
end

function Module:OnbattleStartEventCallback(battleIndex)
	for i=10, 19 do
		local enemy = Battle.GetPlayIndex(battleIndex, i)
		local player = Battle.GetPlayIndex(battleIndex, i-10)
                                        --print(enemy, player)
		if enemy>=0 and Char.GetData(enemy, CONST.CHAR_����) == "ˮ�R��ħʷ�Rķ"  then
			if player>=0 then
 				for k, v in ipairs(playerInfo) do
					Char.SetData(enemy, v.Info, Char.GetData(player, v.Info))
					Char.SetData(enemy, CONST.����_ENEMY_HeadGraNo,108510)
				end
			end
		end
	end
end
function Module:OnBeforeBattleTurnCommand(battleIndex)
	local Round = Battle.GetTurn(battleIndex);
	for i = 10, 19 do
		local enemy = Battle.GetPlayer(battleIndex, i);
		if Round==0 and Char.GetData(enemy, CONST.CHAR_����) ~= "ˮ�R��ħʷ�Rķ"  then
			Char.SetData(enemy, CONST.CHAR_Ѫ, Char.GetData(enemy,CONST.CHAR_���Ѫ));
			Char.SetData(enemy, CONST.CHAR_ħ, Char.GetData(enemy,CONST.CHAR_���ħ));
		elseif Round==2 and Char.GetData(enemy, CONST.CHAR_����) ~= "ˮ�R��ħʷ�Rķ"  then
			Char.SetData(enemy, CONST.����_ENEMY_HeadGraNo,0)
		end
	end
	if Round>=1 then
		Battle.SetDexRearrangeRate(battleIndex,50);
	end
end
function Module:OnAfterBattleTurnCommand(battleIndex)
	local Round = Battle.GetTurn(battleIndex);
	for i = 10, 19 do
		local enemy = Battle.GetPlayer(battleIndex, i);
		if Round>=1 and Char.GetData(enemy, CONST.CHAR_����) ~= "ˮ�R��ħʷ�Rķ"  then
			local player = Battle.GetPlayIndex(battleIndex, i-10)
                                                            local HP = Char.GetData(enemy,CONST.CHAR_Ѫ);
                                                            local MP = Char.GetData(enemy,CONST.CHAR_ħ);
			if enemy>=0 and Char.GetData(enemy, CONST.����_ENEMY_ID)>=406180 and Char.GetData(enemy, CONST.����_ENEMY_ID)<= 406189  then
				if player>=0 then
 					for k, v in ipairs(playerInfo) do
						Char.SetData(enemy, v.Info, Char.GetData(player, v.Info))
					end
				end
			end
			Char.SetData(enemy, CONST.CHAR_Ѫ, HP);
			Char.SetData(enemy, CONST.CHAR_ħ, MP);
                                                            NLG.UpChar(enemy);
		end
	end

end

function Module:OnEnemyCommandCallBack(battleIndex, side, slot, action)
      local Round = Battle.GetTurn(battleIndex);
      for i = 10, 19 do
            local devil_charIndex = Battle.GetPlayer(battleIndex, i);
            local player = Battle.GetPlayIndex(battleIndex, i-10);
            if devil_charIndex >= 0 then
                  local sidetable = {{10,30,41},{0,20,40}}
                  if Round>=1 and Char.GetData(devil_charIndex, CONST.CHAR_����) == "ˮ�R��ħʷ�Rķ"  then
                      SetCom(devil_charIndex, action, CONST.BATTLE_COM.BATTLE_COM_ESCAPE, -1, 15001);
                  elseif Round>=1 and Char.GetData(devil_charIndex, CONST.CHAR_����) ~= "ˮ�R��ħʷ�Rķ" and player>=0  then
                      --SetCom(devil_charIndex, action, CONST.BATTLE_COM.BATTLE_COM_P_SPIRACLESHOT, sidetable[devilside][1], 403);
                         local skillSlot = NLG.Rand(0, 9);
                         for k, v in ipairs(skillParams) do
                             local devilside = v.side+1;
                             local devilunit = v.unit+1;
                             if Char.GetData(player, CONST.CHAR_����) == CONST.��������_��  then                                --���＼��skill
                                 local devil_skillId=Char.GetSkillID(player,skillSlot);
                                 if devil_skillId==v.skillId  then
                                    local deviltech = v.techId[1] + Char.GetSkillLv(player,skillSlot) - 1;
                                    SetCom(devil_charIndex, action, v.com1, sidetable[devilside][devilunit], deviltech);
                                    return;
                                 else
                                    SetCom(devil_charIndex, action, CONST.BATTLE_COM.BATTLE_COM_ATTACK, 0, -1);
                                 end
                             elseif Char.GetData(player, CONST.CHAR_����) == CONST.��������_��  then                         --���＼��tech
                                 local devil_techId=Pet.GetSkill(player,skillSlot);
                                 if devil_techId>=v.techId[1] and devil_techId<=v.techId[2]  then
                                    SetCom(devil_charIndex, action, v.com1, sidetable[devilside][devilunit], devil_techId);
                                    return;
                                 else
                                    SetCom(devil_charIndex, action, CONST.BATTLE_COM.BATTLE_COM_ATTACK, 0, -1);
                                 end
                             end
                         end
                  end
            end
      end
end

function Module:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
      --self:logDebug('OnDamageCalculateCallBack', charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
      local Round = Battle.GetTurn(battleIndex);
      --print(Round)
      if Round==0 and Char.GetData(defCharIndex, CONST.����_ENEMY_ID)>=406180 and Char.GetData(defCharIndex, CONST.����_ENEMY_ID)<= 406189 and flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge  then
               local defHpE = Char.GetData(defCharIndex,CONST.CHAR_Ѫ);
               if damage>=defHpE-1 then
                 Char.SetData(defCharIndex, CONST.CHAR_Ѫ, defHpE+damage*0.1);
                 NLG.UpChar(defCharIndex);
                 damage = damage*0;
               else
                 damage = damage*0;
               end
      end
  return damage;
end

function SetCom(charIndex, action, com1, com2, com3)
  if action == 0 then
    Char.SetData(charIndex, CONST.CHAR_BattleCom1, com1)
    Char.SetData(charIndex, CONST.CHAR_BattleCom2, com2)
    Char.SetData(charIndex, CONST.CHAR_BattleCom3, com3)
  else
    Char.SetData(charIndex, CONST.CHAR_BattleCom1, com1)
    Char.SetData(charIndex, CONST.CHAR_BattleCom2, com2)
    Char.SetData(charIndex, CONST.CHAR_BattleCom3, com3)
  end
end

local dropMenu={
        {"�����Ǭ",900498,1},         --ÿ10��һ���������䣬10�������޽���
        {"�����Ǭ",900498,1},
        {"�����Ǭ",900498,1},
        {"�����Ǭ",900498,2},
        {"�����Ǭ",900498,2},
        {"������",900497,1},
        {"������",900497,1},
        {"������",900497,2},
        {"������",900497,2},
        {"�،��ԽY��",69163,1},
        {"ˮ���ԽY��",69164,1},
        {"�����ԽY��",69165,1},
        {"�L���ԽY��",69166,1},
        {"�^Ŀ�e��ȯ",69000,1},
        {"ħ���y�ſ�",68001,1},
        {"ħ�����ſ�",68000,1},
        {"�W�ŷ��K(����)",71016,1},
        {"�W�ŷ��K(ϡ��)",71017,1},
        {"�W�ŷ��K(��Ҋ)",71018,1},
}
function DevilNpc_BattleWin(battleIndex, charIndex)
	--����ƽ���ȼ����ȵ�
	local Dm={}
	for i = 10, 19 do
		local devil_charIndex = Battle.GetPlayer(battleIndex, i);
		local player = Battle.GetPlayIndex(battleIndex, i-10);
		if player >0 then
			local playerlv = Char.GetData(player, CONST.CHAR_�ȼ�);
			table.insert(Dm, i-10, playerlv);
		else
			table.insert(Dm, i-10, -1);
		end
	end
	--����ƽ���ȼ����ȵ�
	local m = 0;
	local k = 0;
	for p=0,9 do
		if Dm[i]>0 then
			m = m+Dm[i];
			k = k+1;
		end
	end
	local lv = math.floor(m/k);
	local lvRank = math.floor(lv/10);
	--���ȵڷ��佱��
	for p=0,9 do
		local player = Battle.GetPlayIndex(battleIndex, p);
		local drop = math.random(0,3);
		if player>=0 and Char.GetData(player, CONST.CHAR_����) == CONST.��������_�� then
			for k, v in ipairs(dropMenu) do
				if k==lvRank and lvRank>=1  then
					Char.GiveItem(player, dropMenu[k][2], dropMenu[k][3]*drop);
				end
			end
		end
	end
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
