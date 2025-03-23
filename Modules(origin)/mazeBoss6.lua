---ģ����
local Module = ModuleBase:createModule('mazeBoss6')

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
	{ Info=CONST.����_���� },{ Info=CONST.����_ԭ�� },{ Info=CONST.����_�ȼ� },{ Info=CONST.����_Ѫ },{ Info=CONST.����_ħ },
	{ Info=CONST.����_���� },{ Info=CONST.����_���� },{ Info=CONST.����_ǿ�� },{ Info=CONST.����_�ٶ� },{ Info=CONST.����_ħ�� },
	{ Info=CONST.����_���� },{ Info=CONST.����_������ },{ Info=CONST.����_ˮ���� },{ Info=CONST.����_������ },{ Info=CONST.����_������ },
	{ Info=CONST.����_���� },{ Info=CONST.����_��˯ },{ Info=CONST.����_��ʯ },{ Info=CONST.����_���� },{ Info=CONST.����_���� },{ Info=CONST.����_���� },
	{ Info=CONST.����_��ɱ },{ Info=CONST.����_���� },{ Info=CONST.����_���� },{ Info=CONST.����_���� },
	{ Info=CONST.����_ְҵ },{ Info=CONST.����_ְ�� },{ Info=CONST.����_ְ��ID },
	{ Info=CONST.����_ԭʼͼ�� },{ Info=CONST.����_���� },{ Info=CONST.����_���Ѫ },{ Info=CONST.����_���ħ },
	{ Info=CONST.����_������ },{ Info=CONST.����_������ },{ Info=CONST.����_���� },{ Info=CONST.����_���� },{ Info=CONST.����_�ظ� },{ Info=CONST.����_ħ�� },{ Info=CONST.����_ħǿ },
}

local EnemySet = {}
local BaseLevelSet = {}
local Pos = {}
--local FTime = os.time()
--local Setting = 0;
--���н���
--     ��(4)	��(2)	һ(0)	��(1)	��(3)
--     ʮ(9)	��(7)	��(5)	��(6)	��(8)
------------��սNPC����------------
local BossEnemyId = 406195;		--����ģʽ�趨����
EnemySet[1] = {406189, 406189, 406189, 406189, 406189, 406195, 406189, 406189, 406189, 406189}    --0����û�й�
BaseLevelSet[1] = {140, 140, 140, 140, 140, 150, 140, 140, 140, 140}
Pos[1] = {"�_�B˹",EnemySet[1],BaseLevelSet[1]}
------------------------------------------------
--��������
--local Switch = 0;					--����������ƿ���1��0��
--local Rank = 0;						--��ʼ���Ѷȷ���
--local BossMap= {60003,40,9}			-- ս������Floor,X,Y
--local OutMap= {1000,242,88}			-- ʧ�ܴ���Floor,X,Y
local LeaveMap= {1000,242,88}		-- �뿪����Floor,X,Y
local BossKey= {70195}				-- ��ͨ(���п���)
local Pts= 70058;					-- ħ�����
local BossRoom = {
      { key=1, keyItem=70195, keyItem_count=1, bossRank=3, limit=5, posNum_L=3, posNum_R=4,
          win={warpWMap=1000, warpWX=242, warpWY=88, getItem = 70075, getItem_count = 50},
          lordName="�_�B˹",
       },    -- ��ͨ(2)
}
local tbl_duel_user = {};			--��ǰ������ҵ��б�
local tbl_win_user = {};
------------------------------------------------
--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BattleStartEvent', Func.bind(self.OnbattleStartEventCallback, self))
  self:regCallback('BeforeBattleTurnEvent', Func.bind(self.OnBeforeBattleTurnCommand, self))
  self:regCallback('AfterBattleTurnEvent', Func.bind(self.OnAfterBattleTurnCommand, self))
  self:regCallback('EnemyCommandEvent', Func.bind(self.OnEnemyCommandCallBack, self))
  self:regCallback('DamageCalculateEvent', Func.bind(self.OnDamageCalculateCallBack, self))
  self:regCallback('BattleInjuryEvent', Func.bind(self.OnBattleInjuryCallBack, self))
  self:regCallback('BattleSurpriseEvent', Func.bind(self.OnBattleSurpriseCallBack, self))
  local Lord6Npc = self:NPC_createNormal('�_�B˹', 130021, { map = 7905, x = 59, y = 134, direction = 6, mapType = 0 })
  Char.SetData(Lord6Npc,CONST.����_ENEMY_PetFlg+2,0)--�ɴ�͸��
  self:regCallback('LoopEvent', Func.bind(self.AutoLord_LoopEvent,self))
  self:NPC_regWindowTalkedEvent(Lord6Npc, function(npc, player, _seqno, _select, _data)
	local cdk = Char.GetData(player,CONST.����_CDK);
	local seqno = tonumber(_seqno)
	local select = tonumber(_select)
	local data = tonumber(_data)
	local json = Field.Get(player, 'WorldDate');
		local ret, WorldDate = nil, nil;
		if json then
			ret, WorldDate = pcall(JSON.decode, json)
		else
			return
		end
	if seqno == 1 then
		if select == CONST.��ť_�� then
			return;
		elseif select == CONST.��ť_��һҳ then
				local msg = "\\n�_�B˹��\\n\\n"
					.."��ԭ�����Ǖr֮��Ů����¶�����Ɂ�ģ�\\n"
					.."���r�g�ÛQ�ߡ�ِ���������V��Ҫ����ゃ\\n"
					.."���F���ҿ���֪����ʲ�N��Ҫ�@�N��\\n"
					.."���ゃ������һȺ����ĺ�ƽ���x��\\n"
					.."�����m�ǵĽY��ע������݆ޒ����\\n";
				NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 11, msg);
		end

	end
	------------------------------------------------------------
	if seqno == 11 then
		if select == CONST.��ť_�� then
			return;
		elseif select == CONST.��ť_�� then
			if ret and #WorldDate > 0 then
				if WorldDate[6][1]==os.date("%w",os.time()) then
					NLG.SystemMessage(player,"[ϵ�y]ÿ�ՃH���M��1��ӑ����");
					Char.Warp(player,0,LeaveMap[1],LeaveMap[2],LeaveMap[3]);
					return;
				end

			else
				WorldDate = {};
				for i=1,7 do
					WorldDate[i]={"7",};
				end
			end
			local playerName = Char.GetData(player,CONST.����_����);
			table.insert(tbl_duel_user,player);
			WorldDate[6] = {
			os.date("%w",os.time()),
			}
			Field.Set(player, 'WorldDate', JSON.encode(WorldDate));
			local PartyNum = Char.PartyNum(player);
			if (PartyNum>1) then
				for Slot=1,4 do
					local TeamPlayer = Char.GetPartyMember(player,Slot);
					if Char.IsDummy(TeamPlayer)==false then
						Field.Set(TeamPlayer, 'WorldDate', JSON.encode(WorldDate));
					end
				end
			end
			def_round_start(player, 'wincallbackfunc');
		end

	end
  end)
  self:NPC_regTalkedEvent(Lord6Npc, function(npc, player)
	if (NLG.CanTalk(npc, player) == true) then
		local msg = "\\n�_�B˹��\\n\\n"
				.."���벻���@������ؚw�@�����磡\\n"
				.."���r�g��ɳ©����r�߂����٣����N�r�g���دB��\\n"
				.."�����ゃ�@Щ�r������Ҳ���F�˷��w��\\n"
				.."�����ѽ��f���������뚧�����磬�����أ�\\n";

		NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.��ť_��һҳ, 1, msg);
	end
	return
  end)


  --[[local Leave1Npc = self:NPC_createNormal('���xɳ©', 235179, { map = 60003, x = 41, y = 9, direction = 6, mapType = 0 })
  self:NPC_regWindowTalkedEvent(Leave1Npc, function(npc, player, _seqno, _select, _data)
  end)
  self:NPC_regTalkedEvent(Leave1Npc, function(npc, player)
	if (NLG.CanTalk(npc, player) == true) then
		if (Char.PartyNum(player)==-1) then
			if (Char.ItemNum(player, BossKey[1]) > 0) then
				local slot = Char.FindItemId(player, BossKey[1]);
				local item_indexA = Char.GetItemIndex(player,slot);
				Char.DelItem(player, BossKey[1], 1);
				Char.GiveItem(player, 70206, 1);
				Char.Warp(player,0,LeaveMap[1],LeaveMap[2],LeaveMap[3]);
				NLG.SystemMessage(player,"��ϧ����ꇣ������ف�����ħ���I����");
			else
				Char.GiveItem(player, 70206, 1);
				Char.Warp(player,0,LeaveMap[1],LeaveMap[2],LeaveMap[3]);
				NLG.SystemMessage(player,"��ϧ����ꇣ������ف�����ħ���I����");
			end
		else
			for k,v in pairs(BossRoom) do
			if (Char.ItemNum(player, v.keyItem) > 0) then
				local slot = Char.FindItemId(player, v.keyItem);
				local item_indexA = Char.GetItemIndex(player,slot);
				Char.DelItem(player, v.keyItem, v.keyItem_count);
				Char.GiveItem(player, 70206, 5);
				Char.Warp(player,0,LeaveMap[1],LeaveMap[2],LeaveMap[3]);
			end
			end
		end
	end
        return
  end)
  ]]

end
------------------------------------------------
-------��������
--ս��ǰȫ�ָ�
function Char.HealAll(player)
	Char.SetData(player,CONST.����_Ѫ, Char.GetData(player,CONST.����_���Ѫ));
	Char.SetData(player,CONST.����_ħ, Char.GetData(player,CONST.����_���ħ));
	Char.SetData(player, CONST.����_����, 0);
	Char.SetData(player, CONST.����_����, 0);
	NLG.UpdateParty(player);
	NLG.UpChar(player);
	for petSlot  = 0,4 do
		local petIndex = Char.GetPet(player,petSlot);
		if petIndex >= 0 then
			local maxLp = Char.GetData(petIndex, CONST.����_���Ѫ);
			local maxFp = Char.GetData(petIndex, CONST.����_���ħ);
			Char.SetData(petIndex, CONST.����_Ѫ, maxLp);
			Char.SetData(petIndex, CONST.����_ħ, maxFp);
			Char.SetData(petIndex, CONST.����_����, 0);
			Pet.UpPet(player, petIndex);
		end
	end
	local PartyNum = Char.PartyNum(player);
	if (PartyNum>1) then
		for Slot=1,4 do
		local TeamPlayer = Char.GetPartyMember(player,Slot);
		if (TeamPlayer>0) then
			Char.SetData(TeamPlayer,CONST.����_Ѫ, Char.GetData(TeamPlayer,CONST.����_���Ѫ));
			Char.SetData(TeamPlayer,CONST.����_ħ, Char.GetData(TeamPlayer,CONST.����_���ħ));
			Char.SetData(TeamPlayer, CONST.����_����, 0);
			Char.SetData(TeamPlayer, CONST.����_����, 0);
			NLG.UpdateParty(TeamPlayer);
			NLG.UpChar(TeamPlayer);
			for petSlot  = 0,4 do
				local petIndex = Char.GetPet(TeamPlayer,petSlot);
				if petIndex >= 0 then
					local maxLp = Char.GetData(petIndex, CONST.����_���Ѫ);
					local maxFp = Char.GetData(petIndex, CONST.����_���ħ);
					Char.SetData(petIndex, CONST.����_Ѫ, maxLp);
					Char.SetData(petIndex, CONST.����_ħ, maxFp);
					Char.SetData(petIndex, CONST.����_����, 0);
					Pet.UpPet(TeamPlayer, petIndex);
				end
			end
		end
		end
	end
end



function def_round_start(player, callback)

	--MapUser = NLG.GetMapPlayer(0,BossMap[1]);
	tbl_win_user = {};
	tbl_duel_user = {};
	table.insert(tbl_duel_user,player);

	--��ʼս��
	tbl_UpIndex = {}
	battleindex = {}


	Char.HealAll(player);
	NLG.SystemMessage(-1,"" ..BossRoom[1].lordName.. "������: " ..Char.GetData(player,CONST.����_����));
	local battleindex = Battle.PVE( player, player, nil, Pos[1][2], Pos[1][3], nil)
	Battle.SetWinEvent("./lua/Modules/mazeBoss6.lua", "def_round_wincallback", battleindex);

end

function def_round_wincallback(battleindex, player)

	local winside = Battle.GetWinSide(battleindex);
	local sideM = 0;

	--��ȡʤ����
	if (winside == 0) then
		sideM = 0;
	end
	if (winside == 1) then
		sideM = 10;
	end
	--��ȡʤ���������ָ�룬����վ��ǰ���ͺ�
	local w1 = Battle.GetPlayIndex(battleindex, 0 + sideM);
	local w2 = Battle.GetPlayIndex(battleindex, 5 + sideM);
	local ww = nil;

	--��ʤ����Ҽ����б�
	tbl_win_user = {}
	if ( Char.GetData(w1, CONST.����_����) == CONST.��������_�� ) then
		local ww = w1;
		table.insert(tbl_win_user, ww);
	elseif ( Char.GetData(w2, CONST.����_����) >= CONST.��������_�� ) then
		local ww = w2;
		table.insert(tbl_win_user, ww);
	else
		local ww = nil;
	end

	--local MapUser = NLG.GetMapPlayer(0, BossMap[1]);
	local player = tbl_win_user[1];

	--FTime = os.time()
	--wincallbackfunc(tbl_win_user);
	Char.GiveItem(player, 70258, 1);
	NLG.SystemMessage(-1,"��ϲ���:"..Char.GetData(player,CONST.����_����).." ӑ���ɹ�"..BossRoom[1].lordName.."��");

	local cdk = Char.GetData(player,CONST.����_CDK);
	SQL.Run("update lua_hook_worldboss set LordEnd6= '1' where CdKey='"..cdk.."'")
	NLG.UpChar(player);
	local PartyNum = Char.PartyNum(player);
	if (PartyNum>1) then
		for Slot=1,4 do
			local TeamPlayer = Char.GetPartyMember(player,Slot);
			if Char.IsDummy(TeamPlayer)==false then
				local cdk = Char.GetData(TeamPlayer,CONST.����_CDK);
				--SQL.Run("INSERT INTO lua_hook_worldboss (Name,CdKey) SELECT Name,CdKey FROM tbl_character WHERE NOT EXISTS ( SELECT Name FROM lua_hook_worldboss WHERE tbl_character.CdKey=lua_hook_worldboss.CdKey)");
				SQL.Run("update lua_hook_worldboss set LordEnd6= '1' where CdKey='"..cdk.."'")
				NLG.UpChar(TeamPlayer);
			end
		end
	end
	Char.Warp(player,0, BossRoom[1].win.warpWMap, BossRoom[1].win.warpWX, BossRoom[1].win.warpWY);
	tbl_win_user = {};

	Battle.UnsetWinEvent(battleindex);
end

------------------------------------------------
--��������
function Module:OnBattleInjuryCallBack(fIndex, aIndex, battleIndex, inject)
      --self:logDebug('OnBattleInjuryCallBack', fIndex, aIndex, battleIndex, inject)
      local Round = Battle.GetTurn(battleIndex);
      --print(Round)
      local Target_FloorId = Char.GetData(fIndex, CONST.����_��ͼ)
      local defHpE = Char.GetData(fIndex,CONST.����_Ѫ);
      if defHpE >=100 and Target_FloorId==7900  then
                 inject = inject*0;
      elseif  Target_FloorId==7900  then
                 inject = inject;
      end
  return inject;
end
--������������
function Module:OnbattleStartEventCallback(battleIndex)
	local Round = Battle.GetTurn(battleIndex);
	local leader0 = Battle.GetPlayer(battleIndex, 0);
	local leaderpet0 = Battle.GetPlayer(battleIndex, 5);
	local player = leader0
	local leaderpet = leaderpet0
	if Char.GetData(player, CONST.����_����) == CONST.��������_�� then
		player = leader0
	else
		player = leaderpet
	end
	local cdk = Char.GetData(player,CONST.����_CDK) or nil;

	--[[local ret = SQL.Run("select Name,WorldLord6 from lua_hook_worldboss where CdKey='"..cdk.."'");
	if(type(ret)=="table" and ret["0_1"]~=nil)then
		LordHP6=tonumber(ret["0_1"]);
	end]]

	local LordHP6 = tonumber(SQL.Run("select WorldLord6 from lua_hook_worldboss where CdKey='"..cdk.."'")["0_0"])
	for i = 10, 19 do
		local enemy = Battle.GetPlayer(battleIndex, i);
		local player = Battle.GetPlayIndex(battleIndex, i-10)
		local HP = LordHP6;
		if (HP<=1000) then
			HP = LordHP6*100;
		end
		if enemy>=0 and Char.GetData(enemy, CONST.����_ENEMY_ID)==406189  then
			--Char.SetData(enemy, CONST.����_���Ѫ, 1000000);
			--Char.SetData(enemy, CONST.����_Ѫ, HP);
			if player>=0 then
 				for k, v in ipairs(playerInfo) do
					Char.SetData(enemy, v.Info, Char.GetData(player, v.Info))
				end
			end
		elseif enemy>=0 and Char.GetData(enemy, CONST.����_ENEMY_ID)==BossEnemyId  then
			Char.SetData(enemy, CONST.����_���Ѫ, 1000000);
			Char.SetData(enemy, CONST.����_Ѫ, HP);
		end
	end
end
function Module:OnBeforeBattleTurnCommand(battleIndex)
	local Round = Battle.GetTurn(battleIndex);
	local leader0 = Battle.GetPlayer(battleIndex, 0);
	local leaderpet0 = Battle.GetPlayer(battleIndex, 5);
	local player = leader0
	local leaderpet = leaderpet0
	if Char.GetData(player, CONST.����_����) == CONST.��������_�� then
		player = leader0
	else
		player = leaderpet
	end
	if (player>=0) then
		cdk = Char.GetData(player,CONST.����_CDK) or nil;
	end

	--[[local ret = SQL.Run("select Name,WorldLord6 from lua_hook_worldboss where CdKey='"..cdk.."'");
	if(type(ret)=="table" and ret["0_1"]~=nil)then
		LordHP6=tonumber(ret["0_1"]);
	end]]
	local LordHP6 = tonumber(SQL.Run("select WorldLord6 from lua_hook_worldboss where CdKey='"..cdk.."'")["0_0"])
	--print(LordHP6)
	for i = 10, 19 do
		local enemy = Battle.GetPlayer(battleIndex, i);
		local HP = LordHP6;
		if (HP<=1000 and Round<1) then
			HP = HP*200;
		end
		if Round==0 and enemy>=0 and Char.GetData(enemy, CONST.����_ENEMY_ID)==406189  then
			Char.SetData(enemy, CONST.����_Ѫ, Char.GetData(enemy,CONST.����_���Ѫ));
			Char.SetData(enemy, CONST.����_ħ, Char.GetData(enemy,CONST.����_���ħ));
		elseif Round>0 and enemy>=0 and Char.GetData(enemy, CONST.����_ENEMY_ID)==406189  then
			local player = Battle.GetPlayIndex(battleIndex, i-10);
			if player>=0 then
 				for k, v in ipairs(playerInfo) do
					Char.SetData(enemy, v.Info, Char.GetData(player, v.Info))
				end
			end
		elseif Round==0 and enemy>=0 and Char.GetData(enemy, CONST.����_ENEMY_ID)==BossEnemyId  then
			Char.SetData(enemy, CONST.����_���Ѫ, 1000000);     --Ѫ������100��
			Char.SetData(enemy, CONST.����_Ѫ, HP);
		elseif Round>0 and enemy>=0 and Char.GetData(enemy, CONST.����_ENEMY_ID)==BossEnemyId  then
			Char.SetData(enemy, CONST.����_���Ѫ, 1000000);     --Ѫ������100��
			Char.SetData(enemy, CONST.����_Ѫ, HP);
			if Round>=5 then
				--Char.SetData(enemy, CONST.����_������, 10000);
				--Char.SetData(enemy, CONST.����_����, 10000);
				--Char.SetData(enemy, CONST.����_����, 100);
				--Char.SetData(enemy, CONST.����_����, 100);
				--Char.SetData(enemy, CONST.����_����, 70);
			end
			if Round>=4 and Round<=8 then
				Char.SetData(enemy, CONST.����_ENEMY_HeadGraNo,114260);
			elseif Round>=9 then
				Char.SetData(enemy, CONST.����_ENEMY_HeadGraNo,114261);
			end
		end
	end
end
function Module:OnAfterBattleTurnCommand(battleIndex)
	local Round = Battle.GetTurn(battleIndex);
	local leader0 = Battle.GetPlayer(battleIndex, 0);
	local leaderpet0 = Battle.GetPlayer(battleIndex, 5);
	local player = leader0
	local leaderpet = leaderpet0
	if Char.GetData(player, CONST.����_����) == CONST.��������_�� then
		player = leader0
	else
		player = leaderpet
	end
	local cdk = Char.GetData(player,CONST.����_CDK) or nil;

	for i = 10, 19 do
		local enemy = Battle.GetPlayer(battleIndex, i);
		if Round>=0 and enemy>=0 and Char.GetData(enemy, CONST.����_ENEMY_ID)==406189  then
			local player = Battle.GetPlayIndex(battleIndex, i-10)
			local HP = Char.GetData(enemy,CONST.����_Ѫ);
			local MP = Char.GetData(enemy,CONST.����_ħ);
			if player>=0 then
 				for k, v in ipairs(playerInfo) do
					Char.SetData(enemy, v.Info, Char.GetData(player, v.Info))
				end
			end
			Char.SetData(enemy, CONST.����_Ѫ, HP);
			Char.SetData(enemy, CONST.����_ħ, MP);
		elseif Round>=1 and enemy>=0 and Char.GetData(enemy, CONST.����_ENEMY_ID)==BossEnemyId  then
			local HP = Char.GetData(enemy,CONST.����_Ѫ);
			Char.SetData(enemy, CONST.����_���Ѫ, 1000000);
			Char.SetData(enemy, CONST.����_Ѫ, HP);
			NLG.SystemMessage(player,"[ϵ�y]�_�B˹Ŀǰʣ�NѪ��"..HP.."��");
			--LordѪ��д���
			if (cdk~=nil) then
				--SQL.Run("INSERT INTO lua_hook_worldboss (Name,CdKey) SELECT Name,CdKey FROM tbl_character WHERE NOT EXISTS ( SELECT Name FROM lua_hook_worldboss WHERE CdKey='"..cdk.."')");
				SQL.Run("update lua_hook_worldboss set WorldLord6= '"..HP.."' where CdKey='"..cdk.."'")
				NLG.UpChar(player);
			end
		end
	end
end
--����ģʽ����ʩ��
function Module:OnEnemyCommandCallBack(battleIndex, side, slot, action)
	local Round = Battle.GetTurn(battleIndex);
	for i = 10, 19 do
		local enemy = Battle.GetPlayer(battleIndex, i);
		local player = Battle.GetPlayIndex(battleIndex, i-10);
		local sidetable = {{10,30,41},{0,20,40}}
		if Round>=1 and enemy>= 0 and Char.GetData(enemy, CONST.����_����) == "�r�իF" then
			SetCom(enemy, action, CONST.BATTLE_COM.BATTLE_COM_ESCAPE, -1, 15001);
		elseif Round>=1 and enemy>= 0 and player>=0 and Char.GetData(enemy, CONST.����_ENEMY_ID)==406189  then
			local skillSlot = NLG.Rand(0, 9);
			for k, v in ipairs(skillParams) do
				local devilside = v.side+1;
				local devilunit = v.unit+1;
				if Char.GetData(player, CONST.����_����) == CONST.��������_��  then                                --���＼��skill
					local devil_skillId=Char.GetSkillID(player,skillSlot);
					if devil_skillId==v.skillId  then
						local deviltech = v.techId[1] + Char.GetSkillLv(player,skillSlot) - 1;
						SetCom(enemy, action, v.com1, sidetable[devilside][devilunit], deviltech);
						return;
					else
						SetCom(enemy, action, CONST.BATTLE_COM.BATTLE_COM_ATTACK, 0, -1);
					end
				elseif Char.GetData(player, CONST.����_����) == CONST.��������_��  then                         --���＼��tech
					local devil_techId=Pet.GetSkill(player,skillSlot);
					if devil_techId>=v.techId[1] and devil_techId<=v.techId[2]  then
						SetCom(enemy, action, v.com1, sidetable[devilside][devilunit], devil_techId);
						return;
					else
						SetCom(enemy, action, CONST.BATTLE_COM.BATTLE_COM_ATTACK, 0, -1);
					end
				end
			end
		elseif Round>=5 and Round<=9 and enemy>= 0 and Char.GetData(enemy, CONST.����_ENEMY_ID)==BossEnemyId  then
			SetCom(enemy, action, CONST.BATTLE_COM.BATTLE_COM_M_DEATH, 40, 8609);
		elseif Round>=10 and enemy>= 0 and Char.GetData(enemy, CONST.����_ENEMY_ID)==BossEnemyId  then
			SetCom(enemy, action, CONST.BATTLE_COM.BATTLE_COM_M_DEATH, 40, 8659);
		end
	end
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

function Module:OnDamageCalculateCallBack(charIndex, defCharIndex, oriDamage, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg)
	local Round = Battle.GetTurn(battleIndex);
	if (Round<1 and flg ~= CONST.DamageFlags.Miss and flg ~= CONST.DamageFlags.Dodge)  then
		if (Char.GetData(defCharIndex, CONST.����_ENEMY_ID)==406189 or Char.GetData(defCharIndex, CONST.����_ENEMY_ID)==BossEnemyId)  then
			local defHpE = Char.GetData(defCharIndex,CONST.����_Ѫ);
			if (damage>=defHpE-1) then
				Char.SetData(defCharIndex, CONST.����_Ѫ, defHpE+damage*1);
				NLG.UpChar(defCharIndex);
				NLG.SystemMessage(charIndex,"[ϵ�y]Ŀǰ�o���ܵ�������");
				damage = damage*0;
			else
				damage = damage*0;
			end
		end
	end
	return damage;
end

--͵Ϯ����
function Module:OnBattleSurpriseCallBack(battleIndex, result)
      --self:logDebug('OnBattleSurpriseCallBack', battleIndex, result)
      local Round = Battle.GetTurn(battleIndex);
      --print(Round)
      local Target_FloorId = Char.GetData(Battle.GetPlayer(battleIndex, 0), CONST.����_��ͼ)
      local Target_X = Char.GetData(Battle.GetPlayer(battleIndex, 0),CONST.����_X)
      local Target_Y = Char.GetData(Battle.GetPlayer(battleIndex, 0),CONST.����_Y)
      if Target_FloorId==7905  then
         result=1;
      end
  return result;
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;