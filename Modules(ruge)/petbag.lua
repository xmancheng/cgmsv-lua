---ģ����
local Module = ModuleBase:createModule('petbag')
local sgModule = getModule("setterGetter")

local petbag_list = {
    1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,
}

Module:addMigration(1, "migrate2", function()
  local res = SQL.QueryEx("select * from lua_petdata");
  if res.rows then
    for i, row in ipairs(res.rows) do
      pcall(function()
        local data = JSON.decode(row.data);
        local regId = row.id;
        local cdkey = row.cdkey;
        if data.petbag and data.petbagIndex then
          for i = 1, 5 do		--5ҳ�����
            for j = 1, 8 do		--ÿҳ8�b����
              if data.petbag[i] and data.petbag[i][j] then
                SQL.QueryEx("insert into hook_charaext (cdKey, regNo, sKey, val, valType) values (?,?,?,?,?,?)",
                  cdkey, regId, string.format("petbag-%d-%d", i, j), JSON.encode(data.petbag[i][j]), 0);
              end
            end
          end
          --SQL.QueryEx("insert into hook_charaext (cdKey, regNo, sKey, val, valType) values (?,?,?,?,?,?)",
          --  cdkey, regId, "petbag-index", data.petbagIndex, 1);
        end
      end)
    end
  end
end)

local petFields={
  CONST.����_����,
  CONST.����_����,
  CONST.����_ԭ��,
  CONST.����_MAP,
  CONST.����_��ͼ,
  CONST.����_X,
  CONST.����_Y,
  CONST.����_����,
  CONST.����_�ȼ�,
  CONST.����_Ѫ,
  CONST.����_ħ,
  CONST.����_����,
  CONST.����_����,
  CONST.����_ǿ��,
  CONST.����_�ٶ�,
  CONST.����_ħ��,
  CONST.����_����,
  CONST.����_����,
  CONST.����_������,
  CONST.����_ˮ����,
  CONST.����_������,
  CONST.����_������,
  CONST.����_����,
  CONST.����_��˯,
  CONST.����_��ʯ,
  CONST.����_����,
  CONST.����_����,
  CONST.����_����,
  CONST.����_��ɱ,
  CONST.����_����,
  CONST.����_����,
  CONST.����_����,
  CONST.����_������,
  CONST.����_������,
  CONST.����_������,
  CONST.����_�˺���,
  CONST.����_ɱ����,
  CONST.����_ռ��ʱ��,
  CONST.����_����,
  CONST.����_�Ƽ�,
  CONST.����_ѭʱ,
  CONST.����_����,
  CONST.����_������,
  CONST.����_ͼ��,
  CONST.����_��ɫ,
  CONST.����_����,
  CONST.����_ԭʼͼ��,
  CONST.����_����,
  CONST.����_���Ѫ,
  CONST.����_���ħ,
  CONST.����_������,
  CONST.����_������,
  CONST.����_����,
  CONST.����_����,
  CONST.����_�ظ�,
  CONST.����_��þ���,
  CONST.����_EnemyBaseId,
  CONST.PET_DepartureBattleStatus,
  CONST.PET_PetID,
  CONST.PET_������,
  CONST.����_��ɫ,
  CONST.����_����,
  CONST.����_����,
  CONST.����_����,
  CONST.����_����,
  CONST.����_����,
  CONST.����_����,
  CONST.����_��ȡʱ�ȼ�,
  CONST.����_�����ҳ�,
  CONST.����_��׽�Ѷ�,
  CONST.����_�ҳ�,
  --CONST.����_����CDK;		--4003
  --CONST.����_��������;	--4004
}

-- NOTE ����ɳ�����key
local petRankFields={
  CONST.PET_���,
  CONST.PET_����,
  CONST.PET_ǿ��,
  CONST.PET_����,
  CONST.PET_ħ��,
}

-- NOTE ��Ʒ����������key
local itemFields = { }
for i = 0, 0x4e do
  table.insert(itemFields, i);
end
for i = 0, 0xd do
  table.insert(itemFields, i + 4000);
end
--------------------------------------------------------------------
local leader_tbl = {}
local chess_tbl = {}
local skill_tbl = {}

local chessFields={
  CONST.����_����,
  CONST.����_ԭ��,
  CONST.����_�ȼ�,
  CONST.����_Ѫ,
  CONST.����_ħ,
  CONST.����_����,
  CONST.����_����,
  CONST.����_ǿ��,
  CONST.����_�ٶ�,
  CONST.����_ħ��,
  CONST.����_����,
  CONST.����_����,
  CONST.����_������,
  CONST.����_ˮ����,
  CONST.����_������,
  CONST.����_������,
  CONST.����_����,
  CONST.����_��˯,
  CONST.����_��ʯ,
  CONST.����_����,
  CONST.����_����,
  CONST.����_����,
  CONST.����_��ɱ,
  CONST.����_����,
  CONST.����_����,
  CONST.����_����,
  --CONST.����_������,
  --CONST.����_������,
  CONST.����_������,
  CONST.����_�˺���,
  CONST.����_ɱ����,
  CONST.����_ռ��ʱ��,
  CONST.����_����,
  CONST.����_�Ƽ�,
  CONST.����_ѭʱ,
  CONST.����_����,
  CONST.����_������,
  CONST.����_ͼ��,
  CONST.����_��ɫ,
  CONST.����_����,
  CONST.����_ԭʼͼ��,
  CONST.����_����,
  CONST.����_���Ѫ,
  CONST.����_���ħ,
  CONST.����_������,
  CONST.����_������,
  CONST.����_����,
  CONST.����_����,
  CONST.����_�ظ�,
  CONST.����_��ɫ,
  --CONST.����_����,
  --CONST.����_����,
  --CONST.����_����,
  --CONST.����_����,
  CONST.����_����,
}

-- {skillId,	com1,	com3(techId),	0 ���� |1 �Է���Ŀǰû�ã� ��Ŀ������λ�� 0 sigle| 1 range | 2 sideall |3 whole }
skillParams={

	-- �Դ�����
	{skillId=269,com1=CONST.BATTLE_COM.BATTLE_COM_P_SPIRACLESHOT,techId={200500,200509},side=1,unit=0},
	{skillId=111,com1=CONST.BATTLE_COM.BATTLE_COM_AXEBOMBER,techId={11100,11109},side=1,unit=0},
	{skillId=273,com1=CONST.BATTLE_COM.BATTLE_COM_P_SPIRACLESHOT,techId={399,399},side=1,unit=0},
	{skillId=274,com1=CONST.BATTLE_COM.BATTLE_COM_P_SPIRACLESHOT,techId={499,499},side=1,unit=0},
	{skillId=3100,com1=CONST.BATTLE_COM.BATTLE_COM_P_PARAMETER,techId={310000,310002},side=1,unit=0},
	{skillId=3100,com1=CONST.BATTLE_COM.BATTLE_COM_P_SPIRACLESHOT,techId={310003,310005},side=1,unit=0},
	{skillId=3100,com1=CONST.BATTLE_COM.BATTLE_COM_P_PARAMETER,techId={310006,310011},side=1,unit=0},
	{skillId=3101,com1=CONST.BATTLE_COM.BATTLE_COM_P_PARAMETER,techId={310100,310102},side=1,unit=0},
	{skillId=3101,com1=CONST.BATTLE_COM.BATTLE_COM_P_SPIRACLESHOT,techId={310103,310105},side=1,unit=0},
	{skillId=3101,com1=CONST.BATTLE_COM.BATTLE_COM_P_RENZOKU,techId={310106,310108},side=1,unit=0},
	{skillId=3101,com1=CONST.BATTLE_COM.BATTLE_COM_P_PARAMETER,techId={310109,310111},side=1,unit=0},
	-- ����
	{skillId=73,com1=CONST.BATTLE_COM.BATTLE_COM_ATTACK,techId={7300,7300},side=1,unit=0},
	-- ����
	{skillId=74,com1=CONST.BATTLE_COM.BATTLE_COM_GUARD,techId={7400,7400},side=0,unit=0},
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
	-- ���ﶨ���ƶ�
	{skillId=160,com1=CONST.BATTLE_COM.BATTLE_COM_POSITION,techId={16000,16000},side=0,unit=0},
	-- ����ʲô������
	{skillId=170,com1=CONST.BATTLE_COM.BATTLE_COM_NONE,techId={15002,15002},side=0,unit=0},
	-- ����
	{skillId=72,com1=CONST.BATTLE_COM.BATTLE_COM_P_STEAL,techId={7200,7299},side=0,unit=0},
}

--------------------------------------------------------------------
local function calcWarp()
  local page = math.modf(#petbag_list / 8) + 1
  local remainder = math.fmod(#petbag_list, 8)
  return page, remainder
end

--Զ�̰�ťUI����
function Module:petbagInfo(npc, player)
          local winButton = CONST.��ť_�ر�;
          local msg = "2\\n����������������������녶˂}�졿\\n\\n"
               .. "��������ȡ��ŵČ���\\n\\n"
               .. "������Ĵ����ϵČ���\\n\\n";
          NLG.ShowWindowTalked(player, self.petBankNPC, CONST.����_ѡ���, CONST.��ť_�ر�, 777, msg);
end

--------------------------------------------------------------------
--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self))
  self:regCallback('BeforeBattleTurnEvent', Func.bind(self.handleBattleAutoCommand, self))
  --self:regCallback('LoginEvent', Func.bind(self.onLoginEvent, self));
  self.petBankNPC = self:NPC_createNormal('����녶˂}��', 14682, { x = 38, y = 30, mapType = 0, map = 777, direction = 6 });
  self:NPC_regWindowTalkedEvent(self.petBankNPC, function(npc, player, _seqno, _select, _data)
    local column = tonumber(_data)
    local page = tonumber(_seqno)
    local warpPage = page;
    --�ж�ʹ�ü�ҳ���
    --[[local petbag_list = {}
    for bagslot = 1, 5 do		--5ҳ�����
      for petslot = 1, 8 do
        local bagslotIndex = tonumber(bagslot);
        local petbagPet = Char.GetExtData(player, string.format("petbag-%d-%d", bagslotIndex, petslot));
        pcall(function()
          if petbagPet then
            table.insert(petbag_list, string.format("petbag-%d-%d", bagslot, petslot));
          end
        end)
      end
    end]]
    local winMsg = "1\\n����������������������녶˂}�졿\\n"
    local winButton = CONST.��ť_�ر�;
    local totalPage, remainder = calcWarp()
    --��ҳ16 ��ҳ32 �ر�/ȡ��2
    if _select > 0 then
      if _select == CONST.��ť_�ر� then
          if (page==777 or page==778) then
              return
          end
      elseif _select == CONST.��ť_�� then
          if (page>=2001 and page<3000) then
              if (Char.PetNum(player)==5) then
                 NLG.SystemMessage(player,"[ϵ�y]�����λ���ѝM��");
                 return;
              end

              local petNo = petNo;
              local seqno = page - 2000;
              local petbagIndex = tonumber(seqno);
              if petbagIndex < 1 or petbagIndex > 5 then
                NLG.SystemMessage(player, '�oЧ������')
                return;
              end
              local petData = {};
              local petbagPet = Char.GetExtData(player, string.format("petbag-%d-%d", petbagIndex, petNo));
              pcall(function()
                if petbagPet then
                  petbagPet = JSON.decode(petbagPet);
                end
              end)
              if type(petbagPet) == 'table' then
                petData = petbagPet
                local EmptySlot = Char.GetPetEmptySlot(player);
                local enemyId = petbagPet.attr[tostring(CONST.PET_PetID)];
                Char.GivePet(player, enemyId, 0);
                local petIndex = Char.GetPet(player,EmptySlot);
                self:insertPetData(petIndex,petData)
                Pet.UpPet(player, petIndex);

                --����װ��
                for i,petsData_item in pairs(petData.items or {}) do
                  local item_slot = tonumber(i)
                  local itemId = petsData_item[tostring(CONST.����_ID)]
                  local itemIndex = Char.GiveItem(player, itemId, 1, false);
                  if itemIndex >= 0 then
                    self:insertItemData(itemIndex,petsData_item)
                    local addSlot = Char.GetItemSlot(player, itemIndex);
                    if addSlot ~= item_slot then
                      Pet.MoveItem(player, 0, addSlot, EmptySlot+1, item_slot);
                    end
                  end
                end
                Pet.UpPet(player, petIndex);
                NLG.UpChar(player);
              end
              Char.SetExtData(player, string.format("petbag-%d-%d", petbagIndex, petNo), nil);
              return;
          else
              return;
          end
      elseif _select == CONST.��ť_�� then
          if (page>=2001 and page<3000) then
              --��һҳ���
              for slot = 1, 8 do
                local petbagIndex = tonumber(1);
                --Char.SetExtData(player, "petbag-index", petbagIndex);
                local petbagPet = Char.GetExtData(player, string.format("petbag-%d-%d", petbagIndex, slot));
                pcall(function()
                  if petbagPet then
                    petbagPet = JSON.decode(petbagPet);
                  end
                end)
                if type(petbagPet) == 'table' then
                  local enemyId = petbagPet.attr[tostring(CONST.PET_PetID)];
                  local Goal_name = petbagPet.attr[tostring(CONST.����_����)];
                  winMsg = winMsg .. "�������["..slot.."]̖λ: " .. Goal_name .."\\n";
                else
                  winMsg = winMsg .. "�������["..slot.."]̖λ: ��\\n";
                end
              end
              NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, CONST.��ť_��ȡ��, 1000+1, winMsg);
              return
          else
              return
          end
      end
      if (warpPage>=3001) then	--�Ĵ�
        local warpPage = warpPage - 3000;
        if _select == CONST.BUTTON_��һҳ then
          warpPage = warpPage + 1
          if (warpPage == totalPage) or ((warpPage == (totalPage - 1) and remainder == 0)) then
            winButton = CONST.BUTTON_��ȡ��
          else
            winButton = CONST.BUTTON_����ȡ��
          end
        elseif _select == CONST.BUTTON_��һҳ then
          warpPage = warpPage - 1
          if warpPage == 1 then
            winButton = CONST.BUTTON_��ȡ��
          else
            winButton = CONST.BUTTON_����ȡ��
          end
        elseif _select == 2 then
          warpPage = 1;
          return;
        end
        print(warpPage)
        local count = 8 * (warpPage - 1)
        if warpPage == totalPage then
          local petbagIndex = tonumber(warpPage);
          if petbagIndex < 1 or petbagIndex > 5 then
              NLG.SystemMessage(player, '�oЧ������')
              return;
          end
          --Char.SetExtData(player, "petbag-index", petbagIndex);
          for i = 1, 8  do
            local petbagPet = Char.GetExtData(player, string.format("petbag-%d-%d", petbagIndex, i));
            pcall(function()
              if petbagPet then
                petbagPet = JSON.decode(petbagPet);
              end
            end)
            if type(petbagPet) == 'table' then
              local enemyId = petbagPet.attr[tostring(CONST.PET_PetID)];
              local Goal_name = petbagPet.attr[tostring(CONST.����_����)];
              winMsg = winMsg .. "�������["..i+count.."]̖λ: " .. Goal_name .."\\n";
            else
              winMsg = winMsg .. "�������["..i+count.."]̖λ: ��\\n";
            end
          end
        else
          local petbagIndex = tonumber(warpPage);
          if petbagIndex < 1 or petbagIndex > 5 then
              NLG.SystemMessage(player, '�oЧ������')
              return;
          end
          --Char.SetExtData(player, "petbag-index", petbagIndex);
          for i = 1, 8  do
            local petbagPet = Char.GetExtData(player, string.format("petbag-%d-%d", petbagIndex, i));
            pcall(function()
              if petbagPet then
                petbagPet = JSON.decode(petbagPet);
              end
            end)
            if type(petbagPet) == 'table' then
              local enemyId = petbagPet.attr[tostring(CONST.PET_PetID)];
              local Goal_name = petbagPet.attr[tostring(CONST.����_����)];
              winMsg = winMsg .. "�������["..i+count.."]̖λ: " .. Goal_name .."\\n";
            else
              winMsg = winMsg .. "�������["..i+count.."]̖λ: ��\\n";
            end
          end
        end
        NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, winButton, 3000+warpPage, winMsg);
      elseif (warpPage>=1001 and warpPage<3000) then	--��ȡ
        local warpPage = warpPage - 1000;
        if _select == CONST.BUTTON_��һҳ then
          warpPage = warpPage + 1
          if (warpPage == totalPage) or ((warpPage == (totalPage - 1) and remainder == 0)) then
            winButton = CONST.BUTTON_��ȡ��
          else
            winButton = CONST.BUTTON_����ȡ��
          end
        elseif _select == CONST.BUTTON_��һҳ then
          warpPage = warpPage - 1
          if warpPage == 1 then
            winButton = CONST.BUTTON_��ȡ��
          else
            winButton = CONST.BUTTON_����ȡ��
          end
        elseif _select == 2 then
          warpPage = 1;
          return;
        end
        local count = 8 * (warpPage - 1)
        if warpPage == totalPage then
          local petbagIndex = tonumber(warpPage);
          if petbagIndex < 1 or petbagIndex > 5 then
              NLG.SystemMessage(player, '�oЧ������')
              return;
          end
          --Char.SetExtData(player, "petbag-index", petbagIndex);
          for i = 1, 8  do
            local petbagPet = Char.GetExtData(player, string.format("petbag-%d-%d", petbagIndex, i));
            pcall(function()
              if petbagPet then
                petbagPet = JSON.decode(petbagPet);
              end
            end)
            if type(petbagPet) == 'table' then
              local enemyId = petbagPet.attr[tostring(CONST.PET_PetID)];
              local Goal_name = petbagPet.attr[tostring(CONST.����_����)];
              winMsg = winMsg .. "�������["..i+count.."]̖λ: " .. Goal_name .."\\n";
            else
              winMsg = winMsg .. "�������["..i+count.."]̖λ: ��\\n";
            end
          end
        else
          local petbagIndex = tonumber(warpPage);
          if petbagIndex < 1 or petbagIndex > 5 then
              NLG.SystemMessage(player, '�oЧ������')
              return;
          end
          --Char.SetExtData(player, "petbag-index", petbagIndex);
          for i = 1, 8  do
            local petbagPet = Char.GetExtData(player, string.format("petbag-%d-%d", petbagIndex, i));
            pcall(function()
              if petbagPet then
                petbagPet = JSON.decode(petbagPet);
              end
            end)
            if type(petbagPet) == 'table' then
              local enemyId = petbagPet.attr[tostring(CONST.PET_PetID)];
              local Goal_name = petbagPet.attr[tostring(CONST.����_����)];
              winMsg = winMsg .. "�������["..i+count.."]̖λ: " .. Goal_name .."\\n";
            else
              winMsg = winMsg .. "�������["..i+count.."]̖λ: ��\\n";
            end
          end
        end
        NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, winButton, 1000+warpPage, winMsg);
      end
    else
      --print(column)
      if (page==777 and column==1) then			--��ȡ
        local warpPage = 1;
        local count = 8 * (warpPage - 1) + column;
        --print(count)

        --��һҳ���
        local petbagIndex = tonumber(warpPage);
        if petbagIndex < 1 or petbagIndex > 5 then
            NLG.SystemMessage(player, '�oЧ������')
            return;
        end
        --Char.SetExtData(player, "petbag-index", petbagIndex);
        for slot = 1, 8 do
          local petbagPet = Char.GetExtData(player, string.format("petbag-%d-%d", petbagIndex, slot));
          pcall(function()
            if petbagPet then
              petbagPet = JSON.decode(petbagPet);
            end
          end)
          if type(petbagPet) == 'table' then
            local enemyId = petbagPet.attr[tostring(CONST.PET_PetID)];
            local Goal_name = petbagPet.attr[tostring(CONST.����_����)];
            winMsg = winMsg .. "�������["..slot.."]̖λ: " .. Goal_name .."\\n";
          else
            winMsg = winMsg .. "�������["..slot.."]̖λ: ��\\n";
          end
        end
        NLG.ShowWindowTalked(player, self.petBankNPC, CONST.����_ѡ���, CONST.��ť_��ȡ��, 1000+warpPage, winMsg);
      elseif (page==777 and column==3) then		--�Ĵ�
          local msg = "����������������������녶˂}�졿\\n"
          local msg = "2|\\n�x��Ҫ�Ĵ�녶���X�Č���:\\n\\n";
          for petSlot=0,4 do
                local petIndex = Char.GetPet(player,petSlot);
                if(petIndex<0)then
                      msg = msg .. "��\\n";
                else
                      msg = msg .. ""..Char.GetData(petIndex,CONST.����_����).."\\n";
                end
          end
          NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, CONST.��ť_�ر�, 778, msg);
      elseif (page==778) then
          updatedPetdata = column-1;
          local petIndex = Char.GetPet(player,updatedPetdata);
          if (petIndex<0) then
            NLG.SystemMessage(player, '[ϵ�y]�x���λ�Û]�Ќ��')
            return;
          end
          --��һҳ���
          local petbagIndex = tonumber(1);
          --Char.SetExtData(player, "petbag-index", petbagIndex);
          for slot = 1, 8 do
            local petbagPet = Char.GetExtData(player, string.format("petbag-%d-%d", petbagIndex, slot));
            pcall(function()
              if petbagPet then
                petbagPet = JSON.decode(petbagPet);
              end
            end)
            if type(petbagPet) == 'table' then
              local enemyId = petbagPet.attr[tostring(CONST.PET_PetID)];
              local Goal_name = petbagPet.attr[tostring(CONST.����_����)];
              winMsg = winMsg .. "�������["..slot.."]̖λ: " .. Goal_name .."\\n";
            else
              winMsg = winMsg .. "�������["..slot.."]̖λ: ��\\n";
            end
          end
          NLG.ShowWindowTalked(player, self.petBankNPC, CONST.����_ѡ���, CONST.��ť_��ȡ��, 3000+1, winMsg);
      elseif (page>=3001) then
          local seqno = page - 3000;
          local petbagIndex = tonumber(seqno);
          --Char.SetExtData(player, "petbag-index", petbagIndex);
          local petbagPet = Char.GetExtData(player, string.format("petbag-%d-%d", petbagIndex, column));
          pcall(function()
            if petbagPet then
              petbagPet = JSON.decode(petbagPet);
            end
          end)
          if type(petbagPet) == 'table' then
            NLG.SystemMessage(player, '[ϵ�y]����ѽ��мĴ档')
            return;
          end
          local updatedPetdata = updatedPetdata;
          local petIndex = Char.GetPet(player,updatedPetdata);
          local petProfile = self:extractPetData(petIndex)
          --Char.SetExtData(player, "petbag-index", seqno);
          local onpetBagIndex = petbagIndex;
          local r = Char.DelSlotPet(player, updatedPetdata);
          Char.SetExtData(player, string.format("petbag-%d-%d", onpetBagIndex, column), JSON.encode(petProfile));
      elseif (page>=1001 and page<3000) then
          local seqno = page - 1000;
          petNo = column;
          local petbagIndex = tonumber(seqno);
          Char.SetExtData(player, "petbag-index", petbagIndex);

          local petbagPet = Char.GetExtData(player, string.format("petbag-%d-%d", petbagIndex, petNo));
          pcall(function()
            if petbagPet then
              petbagPet = JSON.decode(petbagPet);
            end
          end)
          if type(petbagPet) == 'table' then
            local msg = "����������������������녶˂}�졿\\n"
            local msg = msg .. pickupGoalInfo(player,petbagIndex,petNo);
            NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 2000+seqno, msg);
          else
            NLG.SystemMessage(player, '[ϵ�y]�x��ĸ��]�Ќ��')
            return;
          end
      else
          return;
      end
    end
  end)
  self:NPC_regTalkedEvent(self.petBankNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local winButton = CONST.BUTTON_�ر�;
      local msg = "2\\n����������������������녶˂}�졿\\n\\n"
           .. "��������ȡ��ŵČ���\\n\\n"
           .. "������Ĵ����ϵČ���\\n\\n";
      NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, CONST.��ť_�ر�, 777, msg);
    end
    return
  end)


  self.ChessNPC = self:NPC_createNormal('�����Ԅӌ���', 14682, { x = 218, y = 93, mapType = 0, map = 1000, direction = 0 });
  Char.SetData(self.ChessNPC,CONST.����_ENEMY_PetFlg+2,0);
  self:NPC_regWindowTalkedEvent(self.ChessNPC, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.����_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select == CONST.��ť_�ر� then
        return;
    end
    if seqno == 1 then
      if data==1 then
        if (chess_tbl[player]~=nil) then
          for k,v in ipairs(chess_tbl[player]) do
            Char.DelDummy(v);
          end
        end
        leader_tbl = {}
        skill_tbl = {}
        --�ҷ��������
        local petbagIndex = tonumber(1);	--�ƿ��1ҳǰ5�b��
        for slot = 1, 3 do
          local petbagPet = Char.GetExtData(player, string.format("petbag-%d-%d", petbagIndex, slot)) or nil;
          pcall(function()
            if petbagPet~=nil then
              petbagPet = JSON.decode(petbagPet);
            end
          end)
          if type(petbagPet) == 'table' then
            local enemyId = petbagPet.attr[tostring(CONST.PET_PetID)];
            local chessIndex = Char.CreateDummy()
            for key, value in pairs(chessFields) do
              if petbagPet.attr[tostring(value)] ~=nil then
                Char.SetData(chessIndex, value,petbagPet.attr[tostring(value)]);
              end
            end
            Char.SetData(chessIndex, CONST.����_����, 1);		--CONST.��������_NPC
            Char.SetData(chessIndex, CONST.����_ְҵ, 481);		--����ְ
            Char.SetData(chessIndex, CONST.����_ְ��ID, 480);		--����ְ
            Char.SetData(chessIndex, CONST.����_ְ��, 3);
            --skill_tbl[slot+1] = petbagPet.skills
            Char.SetTempData(chessIndex, '���߼���', JSON.encode(petbagPet.skills));

            if (chessIndex~=nil and slot==1) then
              local chess_leader_AIndex = chessIndex;
              local leader_name = petbagPet.attr[tostring(CONST.����_����)];
              print("��L:"..leader_name)
              table.insert(leader_tbl,chess_leader_AIndex);

              local playercdk = Char.GetData(player,CONST.����_CDK);
              Char.SetTempData(chess_leader_AIndex, '��������', playercdk);
            elseif (chessIndex~=nil) then
              Char.JoinParty(chessIndex, leader_tbl[1], true);
            end
            chess_tbl[player]={};
            table.insert(chess_tbl[player],chessIndex);
          else
            print("["..slot.."]̖λ:��");
          end
        end
        --Char.Warp(leader_tbl[1], 0, 1000, 218, 89);

        --�������
        local petbagIndex = tonumber(1);	--�ƿ��1ҳǰ5�b��
        --local comIndex = "xman123456";
        --[[local partyNum = tonumber(SQL.Run("select COUNT(*) from hook_charaext where sKey='petbag-1-1'")["0_0"]);
        local rand = NLG.Rand(0,partyNum-1);]]

        local cdKey_tbl = {}
        local sKey_tbl = {}
        local val_tbl = {}
        local playercdk = Char.GetData(player,CONST.����_CDK);
        local ret = SQL.Run("select cdKey,sKey,val from hook_charaext where sKey='petbag-1-1' and cdKey!='"..playercdk.."'");
        for k,v in pairs(ret) do
          if v ~= 0 then
            local n = tonumber(string.sub(k,1,1))
            local a = tostring(n..'_0')
            local b = tostring(n..'_1')
            local c = tostring(n..'_2')
            if k == a then
              cdKey_tbl[n+1] = v
            end
            if k == b then
              sKey_tbl[n+1] = v
            end
            if k == c then
              val_tbl[n+1] = v
            end
          end
        end
        local rand = NLG.Rand(0,#cdKey_tbl-1);
        local comIndex = tostring(cdKey_tbl[rand+1]);
        --print(rand,comIndex)
        for slot = 1, 3 do
          --local petbagPet = Char.GetExtData(comIndex, string.format("petbag-%d-%d", petbagIndex, slot));
          --local sqldata = tostring(SQL.Run("select val from hook_charaext where cdKey='"..comIndex.."' and sKey='petbag-1-1'")["0_0"])
          local slotIndex = tostring('petbag-1-'..tostring(slot));
          --print(slotIndex)

          local petbagPet = {};
          local switch=0;
          pcall(function()
            local sqldata = tostring(SQL.Run("select val from hook_charaext where cdKey='"..comIndex.."' and sKey='"..slotIndex.."'")["0_0"])
            if (type(sqldata)=="string" and sqldata~='') then
               petbagPet = JSON.decode(sqldata);
               if petbagPet.attr[tostring(CONST.PET_PetID)]~=nil then
                 switch=1;
               else
                 switch=0;
               end
            end
          end)
          if type(petbagPet) == 'table' and switch==1 then
            local enemyId = petbagPet.attr[tostring(CONST.PET_PetID)];
            local chessIndex = Char.CreateDummy()
            for key, value in pairs(chessFields) do
              if petbagPet.attr[tostring(value)] ~=nil then
                Char.SetData(chessIndex, value, petbagPet.attr[tostring(value)]);
              end
            end
            Char.SetData(chessIndex, CONST.����_����, 1);		--CONST.��������_NPC
            Char.SetData(chessIndex, CONST.����_ְҵ, 481);		--����ְ
            Char.SetData(chessIndex, CONST.����_ְ��ID, 480);		--����ְ
            Char.SetData(chessIndex, CONST.����_ְ��, 3);
            --skill_tbl[slot+10] = petbagPet.skills
            Char.SetTempData(chessIndex, '���߼���', JSON.encode(petbagPet.skills));

            if (chessIndex~=nil and slot==1) then
              local chess_leader_BIndex = chessIndex;
              local leader_name = petbagPet.attr[tostring(CONST.����_����)];
              print("��L:"..leader_name)
              table.insert(leader_tbl,chess_leader_BIndex);
            elseif (chessIndex~=nil) then
              Char.JoinParty(chessIndex, leader_tbl[2], true);
            end
            chess_tbl[player]={};
            table.insert(chess_tbl[player],chessIndex);
          else
            print("["..slot.."]̖λ:��");
          end
        end
        --Char.Warp(leader_tbl[2], 0, 1000, 218, 87);

        --����
        local battleIndex = Battle.PVP(leader_tbl[1],leader_tbl[2]);
        Battle.SetPVPWinEvent('./lua/Modules/petbag.lua', 'battle_wincallback', battleIndex);
        --��ս
        NLG.WatchEntry(player, tonumber(leader_tbl[1]));
      elseif data==2 then
        if (chess_tbl[player]~=nil) then
          for k,v in ipairs(chess_tbl[player]) do
            Char.DelDummy(v);
          end
        end
        leader_tbl = {}
        skill_tbl = {}
        --�ҷ��������
        local petbagIndex = tonumber(1);	--�ƿ��1ҳǰ5�b��
        for slot = 1, 5 do
          local petbagPet = Char.GetExtData(player, string.format("petbag-%d-%d", petbagIndex, slot)) or nil;
          pcall(function()
            if petbagPet~=nil then
              petbagPet = JSON.decode(petbagPet);
            end
          end)
          if type(petbagPet) == 'table' then
            local enemyId = petbagPet.attr[tostring(CONST.PET_PetID)];
            local chessIndex = Char.CreateDummy()
            for key, value in pairs(chessFields) do
              if petbagPet.attr[tostring(value)] ~=nil then
                Char.SetData(chessIndex, value,petbagPet.attr[tostring(value)]);
              end
            end
            Char.SetData(chessIndex, CONST.����_����, 1);		--CONST.��������_NPC
            Char.SetData(chessIndex, CONST.����_ְҵ, 481);		--����ְ
            Char.SetData(chessIndex, CONST.����_ְ��ID, 480);		--����ְ
            Char.SetData(chessIndex, CONST.����_ְ��, 3);
            --skill_tbl[slot+1] = petbagPet.skills
            Char.SetTempData(chessIndex, '���߼���', JSON.encode(petbagPet.skills));

            if (chessIndex~=nil and slot==1) then
              local chess_leader_AIndex = chessIndex;
              local leader_name = petbagPet.attr[tostring(CONST.����_����)];
              print("��L:"..leader_name)
              table.insert(leader_tbl,chess_leader_AIndex);

              local playercdk = Char.GetData(player,CONST.����_CDK);
              Char.SetTempData(chess_leader_AIndex, '��������', playercdk);
            elseif (chessIndex~=nil) then
              Char.JoinParty(chessIndex, leader_tbl[1], true);
            end
            chess_tbl[player]={};
            table.insert(chess_tbl[player],chessIndex);
          else
            print("["..slot.."]̖λ:��");
          end
        end
        --Char.Warp(leader_tbl[1], 0, 1000, 218, 89);

        --�������
        local petbagIndex = tonumber(1);	--�ƿ��1ҳǰ5�b��
        --local comIndex = "xman123456";
        --[[local partyNum = tonumber(SQL.Run("select COUNT(*) from hook_charaext where sKey='petbag-1-1'")["0_0"]);
        local rand = NLG.Rand(0,partyNum-1);]]

        local cdKey_tbl = {}
        local sKey_tbl = {}
        local val_tbl = {}
        local playercdk = Char.GetData(player,CONST.����_CDK);
        local ret = SQL.Run("select cdKey,sKey,val from hook_charaext where sKey='petbag-1-1' and cdKey!='"..playercdk.."'");
        for k,v in pairs(ret) do
          if v ~= 0 then
            local n = tonumber(string.sub(k,1,1))
            local a = tostring(n..'_0')
            local b = tostring(n..'_1')
            local c = tostring(n..'_2')
            if k == a then
              cdKey_tbl[n+1] = v
            end
            if k == b then
              sKey_tbl[n+1] = v
            end
            if k == c then
              val_tbl[n+1] = v
            end
          end
        end
        local rand = NLG.Rand(0,#cdKey_tbl-1);
        local comIndex = tostring(cdKey_tbl[rand+1]);
        --print(rand,comIndex)
        for slot = 1, 5 do
          --local petbagPet = Char.GetExtData(comIndex, string.format("petbag-%d-%d", petbagIndex, slot));
          --local sqldata = tostring(SQL.Run("select val from hook_charaext where cdKey='"..comIndex.."' and sKey='petbag-1-1'")["0_0"])
          local slotIndex = tostring('petbag-1-'..tostring(slot));
          --print(slotIndex)

          local petbagPet = {};
          local switch=0;
          pcall(function()
            local sqldata = tostring(SQL.Run("select val from hook_charaext where cdKey='"..comIndex.."' and sKey='"..slotIndex.."'")["0_0"])
            if (type(sqldata)=="string" and sqldata~='') then
               petbagPet = JSON.decode(sqldata);
               if petbagPet.attr[tostring(CONST.PET_PetID)]~=nil then
                 switch=1;
               else
                 switch=0;
               end
            end
          end)
          if type(petbagPet) == 'table' and switch==1 then
            local enemyId = petbagPet.attr[tostring(CONST.PET_PetID)];
            local chessIndex = Char.CreateDummy()
            for key, value in pairs(chessFields) do
              if petbagPet.attr[tostring(value)] ~=nil then
                Char.SetData(chessIndex, value, petbagPet.attr[tostring(value)]);
              end
            end
            Char.SetData(chessIndex, CONST.����_����, 1);		--CONST.��������_NPC
            Char.SetData(chessIndex, CONST.����_ְҵ, 481);		--����ְ
            Char.SetData(chessIndex, CONST.����_ְ��ID, 480);		--����ְ
            Char.SetData(chessIndex, CONST.����_ְ��, 3);
            --skill_tbl[slot+10] = petbagPet.skills
            Char.SetTempData(chessIndex, '���߼���', JSON.encode(petbagPet.skills));

            if (chessIndex~=nil and slot==1) then
              local chess_leader_BIndex = chessIndex;
              local leader_name = petbagPet.attr[tostring(CONST.����_����)];
              print("��L:"..leader_name)
              table.insert(leader_tbl,chess_leader_BIndex);
            elseif (chessIndex~=nil) then
              Char.JoinParty(chessIndex, leader_tbl[2], true);
            end
            chess_tbl[player]={};
            table.insert(chess_tbl[player],chessIndex);
          else
            print("["..slot.."]̖λ:��");
          end
        end
        --Char.Warp(leader_tbl[2], 0, 1000, 218, 87);

        --����
        local battleIndex = Battle.PVP(leader_tbl[1],leader_tbl[2]);
        Battle.SetPVPWinEvent('./lua/Modules/petbag.lua', 'battle_wincallback', battleIndex);
        --��ս
        NLG.WatchEntry(player, tonumber(leader_tbl[1]));
      elseif data==3 then
        if (chess_tbl[player]~=nil) then
          for k,v in ipairs(chess_tbl[player]) do
            Char.DelDummy(v);
          end
        end
        leader_tbl = {}
        skill_tbl = {}
        --�ҷ��������
        local petbagIndex = tonumber(1);	--�ƿ��1ҳǰ5�b��
        for slot = 1, 5 do
          local petbagPet = Char.GetExtData(player, string.format("petbag-%d-%d", petbagIndex, slot)) or nil;
          pcall(function()
            if petbagPet~=nil then
              petbagPet = JSON.decode(petbagPet);
            end
          end)
          if type(petbagPet) == 'table' then
            local enemyId = petbagPet.attr[tostring(CONST.PET_PetID)];
            chess_tbl[player]={};
            chess_tbl[player][slot] = Char.CreateDummy()
            print(chess_tbl[player][slot])
            for key, value in pairs(chessFields) do
              if petbagPet.attr[tostring(value)] ~=nil then
                Char.SetData(chess_tbl[player][slot], value,petbagPet.attr[tostring(value)]);
              end
            end
            Char.SetData(chess_tbl[player][slot], CONST.����_����,1);		--CONST.��������_��
            Char.SetData(chess_tbl[player][slot], CONST.����_����,100);
            Char.SetData(chess_tbl[player][slot], CONST.����_ְҵ,115);		--�Z�F��
            Char.SetData(chess_tbl[player][slot], CONST.����_ְ��ID,110);		--�Z�F��
            Char.SetData(chess_tbl[player][slot], CONST.����_ְ��,5);
            Char.AddSkill(chess_tbl[player][slot], 71); 
            Char.SetSkillLevel(chess_tbl[player][slot],0,10);
            NLG.UpChar(chess_tbl[player][slot]);
            --skill_tbl[slot+1] = petbagPet.skills
            Char.SetTempData(chess_tbl[player][slot], '���߼���', JSON.encode(petbagPet.skills));

            --��6~10��
              local petbagIndex = tonumber(2);	--�ƿ��2ҳǰ5�b��
              local petData = {};
              local petbagPet_chess = Char.GetExtData(player, string.format("petbag-%d-%d", petbagIndex, slot)) or nil;
              pcall(function()
                if petbagPet_chess~=nil then
                  petbagPet_chess = JSON.decode(petbagPet_chess);
                end
              end)
              if type(petbagPet_chess) == 'table' then
                petData = petbagPet_chess
                local enemyId = petbagPet_chess.attr[tostring(CONST.PET_PetID)];
                petIndex = Char.AddPet(chess_tbl[player][slot], enemyId);
                self:insertPetData(petIndex,petData)
                Char.SetData(petIndex,CONST.����_�ҳ�,100);
                Pet.UpPet(chess_tbl[player][slot], petIndex);
                Char.SetPetDepartureState(chess_tbl[player][slot],0,CONST.PET_STATE_ս��);
                NLG.UpChar(chess_tbl[player][slot]);
              else
                --print("["..(slot+5).."]̖λ:��");
              end

            if (chess_tbl[player][slot]~=nil and slot==1) then
              local chess_leader_AIndex = chess_tbl[player][slot];
              local leader_name = petbagPet.attr[tostring(CONST.����_����)];
              print("��L:"..leader_name)
              table.insert(leader_tbl,chess_leader_AIndex);

              local playercdk = Char.GetData(player,CONST.����_CDK);
              Char.SetTempData(chess_leader_AIndex, '��������', playercdk);
            elseif (chess_tbl[player][slot]~=nil) then
              Char.JoinParty(chess_tbl[player][slot], leader_tbl[1], true);
            end
            --table.insert(chess_tbl[player],chessIndex);
          else
            --print("["..slot.."]̖λ:��");
          end
        end
        --Char.Warp(leader_tbl[1], 0, 1000, 218, 89);

        --�������
        local petbagIndex = tonumber(1);	--�ƿ��1ҳǰ5�b��
        --local comIndex = "xman123456";
        --[[local partyNum = tonumber(SQL.Run("select COUNT(*) from hook_charaext where sKey='petbag-1-1'")["0_0"]);
        local rand = NLG.Rand(0,partyNum-1);]]

        local cdKey_tbl = {}
        local sKey_tbl = {}
        local val_tbl = {}
        local playercdk = Char.GetData(player,CONST.����_CDK);
        local ret = SQL.Run("select cdKey,sKey,val from hook_charaext where sKey='petbag-1-1' and cdKey!='"..playercdk.."'");
        for k,v in pairs(ret) do
          if v ~= 0 then
            local n = tonumber(string.sub(k,1,1))
            local a = tostring(n..'_0')
            local b = tostring(n..'_1')
            local c = tostring(n..'_2')
            if k == a then
              cdKey_tbl[n+1] = v
            end
            if k == b then
              sKey_tbl[n+1] = v
            end
            if k == c then
              val_tbl[n+1] = v
            end
          end
        end
        local rand = NLG.Rand(0,#cdKey_tbl-1);
        local comIndex = tostring(cdKey_tbl[rand+1]);
        --print(rand,comIndex)
        for slot = 1, 5 do
          --local petbagPet = Char.GetExtData(comIndex, string.format("petbag-%d-%d", petbagIndex, slot));
          --local sqldata = tostring(SQL.Run("select val from hook_charaext where cdKey='"..comIndex.."' and sKey='petbag-1-1'")["0_0"])
          local slotIndex = tostring('petbag-1-'..tostring(slot));
          --print(slotIndex)

          local petbagPet = {};
          local switch=0;
          pcall(function()
            local sqldata = tostring(SQL.Run("select val from hook_charaext where cdKey='"..comIndex.."' and sKey='"..slotIndex.."'")["0_0"])
            if (type(sqldata)=="string" and sqldata~='') then
               petbagPet = JSON.decode(sqldata);
               if petbagPet.attr[tostring(CONST.PET_PetID)]~=nil then
                 switch=1;
               else
                 switch=0;
               end
            end
          end)
          if type(petbagPet) == 'table' and switch==1 then
            local enemyId = petbagPet.attr[tostring(CONST.PET_PetID)];
            chess_tbl[player][slot+10] = Char.CreateDummy()
            print(chess_tbl[player][slot+10])
            for key, value in pairs(chessFields) do
              if petbagPet.attr[tostring(value)] ~=nil then
                Char.SetData(chess_tbl[player][slot+10], value, petbagPet.attr[tostring(value)]);
              end
            end
            Char.SetData(chess_tbl[player][slot+10], CONST.����_����,1);		--CONST.��������_��
            Char.SetData(chess_tbl[player][slot+10], CONST.����_����,100);
            Char.SetData(chess_tbl[player][slot+10], CONST.����_ְҵ,115);		--�Z�F��
            Char.SetData(chess_tbl[player][slot+10], CONST.����_ְ��ID,110);		--�Z�F��
            Char.SetData(chess_tbl[player][slot+10], CONST.����_ְ��,5);
            Char.AddSkill(chess_tbl[player][slot+10], 71); 
            Char.SetSkillLevel(chess_tbl[player][slot+10],0,10);
            NLG.UpChar(chess_tbl[player][slot+10]);
            --skill_tbl[slot+10] = petbagPet.skills
            Char.SetTempData(chess_tbl[player][slot+10], '���߼���', JSON.encode(petbagPet.skills));

            --��6~10��
              local slotIndex = tostring('petbag-2-'..tostring(slot));
              local petbagPet_chess = {};
              local switch=0;
              pcall(function()
                local sqldata = tostring(SQL.Run("select val from hook_charaext where cdKey='"..comIndex.."' and sKey='"..slotIndex.."'")["0_0"])
                if (type(sqldata)=="string" and sqldata~='') then
                   petbagPet_chess = JSON.decode(sqldata);
                   if petbagPet_chess.attr[tostring(CONST.PET_PetID)]~=nil then
                     switch=1;
                   else
                     switch=0;
                   end
                end
              end)

              local petData = {};

              pcall(function()
                if petbagPet_chess then
                  petbagPet_chess = JSON.decode(petbagPet_chess);
                end
              end)
              if type(petbagPet_chess) == 'table' and switch==1 then
                petData = petbagPet_chess
                local enemyId = petbagPet_chess.attr[tostring(CONST.PET_PetID)];
                local petIndex = Char.AddPet(chess_tbl[player][slot+10], enemyId);
                self:insertPetData(petIndex,petData)
                Char.SetData(petIndex,CONST.����_�ҳ�,100);
                Pet.UpPet(chess_tbl[player][slot+10], petIndex);
                Char.SetPetDepartureState(chess_tbl[player][slot+10],0,CONST.PET_STATE_ս��);
                NLG.UpChar(chess_tbl[player][slot+10]);
              else
                --print("["..(slot+5).."]̖λ:��");
              end

            if (chess_tbl[player][slot+10]~=nil and slot==1) then
              local chess_leader_BIndex = chess_tbl[player][slot+10];
              local leader_name = petbagPet.attr[tostring(CONST.����_����)];
              print("��L:"..leader_name)
              table.insert(leader_tbl,chess_leader_BIndex);
            elseif (chess_tbl[player][slot+10]~=nil) then
              Char.JoinParty(chess_tbl[player][slot+10], leader_tbl[2], true);
            end
            --table.insert(chess_tbl[player],chessIndex);
          else
            --print("["..slot.."]̖λ:��");
          end
        end
        --Char.Warp(leader_tbl[2], 0, 1000, 218, 87);

        --����
        local battleIndex = Battle.PVP(leader_tbl[1],leader_tbl[2]);
        Battle.SetPVPWinEvent('./lua/Modules/petbag.lua', 'battle_wincallback', battleIndex);
        --��ս
        NLG.WatchEntry(player, tonumber(leader_tbl[1]));
      elseif data==4 then
        if (NLG.CanTalk(npc, player) == true) then
          local cdKey_tbl = {}
          local val_tbl = {}
          local ret = SQL.Run("select cdKey,sKey,val from hook_charaext where sKey='���߻���' order by val desc ");
          for k,v in pairs(ret) do
            if v ~= 0 then
              local n = tonumber(string.sub(k,1,1))
              local a = tostring(n..'_0')
              local b = tostring(n..'_1')
              local c = tostring(n..'_2')
              if k == a then
                cdKey_tbl[n+1] = v
              end
              if k == c then
                val_tbl[n+1] = v
              end
            end
          end

          local playerName = Char.GetData(player,CONST.����_����);
          local pts = Char.GetExtData(player, '���߻���') or 0;

          local msg = "@c�����������匦��\\n"
                   .. " �ҵķe��:      ".. playerName .. "      " .. pts .. " Pts\\n";

          for i=1,#cdKey_tbl do
            local charIndex = NLG.FindUser(cdKey_tbl[i]);
            --local charName = Char.GetData(charIndex,CONST.����_����);
            local charName = tostring(SQL.Run("select Name from tbl_character where cdKey='"..cdKey_tbl[i].."'")["0_0"]);
            local pts = val_tbl[i] or 0;

            --�����ʽ
            local name_len = #charName;
            if (name_len < 16) then
              name_spacelen = 16 - name_len;
              name_spaceMsg = " ";
              for k = 1, math.modf(name_spacelen) do
                name_spaceMsg = name_spaceMsg .." ";
              end
            else
              name_spaceMsg = " ";
            end

            msg = msg .. " ��"..i.."��  ".. charName .. name_spaceMsg .. pts .. " Pts\\n";
          end
          NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.��ť_�ر�, 41, msg);
        end

      end
    end
  end)
  self:NPC_regTalkedEvent(self.ChessNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "3\\n@c�����������匦��\\n\\n\\n"
               .. " ���������䌦 " .. "\\n"
               .. " ���������䌦 " .. "\\n"
               .. " ����ʮ���䌦 " .. "\\n"
               .. " �e��������ԃ " .. "\\n";
      NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, CONST.��ť_�ر�, 1, msg);
    end
    return
  end)

end

function Module:handleBattleAutoCommand(battleIndex)
  local Round = Battle.GetTurn(battleIndex);
  local alive = 0;
  for slot = 0,19 do
    local npc = Battle.GetPlayer(battleIndex, slot);
    if (npc>0 and Char.GetData(npc, CONST.����_ս��) == 0) then
      alive = alive+1;
    end
  end
  if (Round>=0 and Char.IsDummy(Battle.GetPlayer(battleIndex,0))) then
    local STime = os.time();
    repeat
      local FTime = os.time();
      local timec = FTime - STime;
    until (timec >= alive*1.3)  else
    --until (timec >= 5)  else
  end

  local poss={}
  for i = 0, 4 do
    table.insert(poss,i)
  end
  for i = 10, 14 do
    table.insert(poss,i)
  end
  table.forEach(poss, function(e)
    local dummyIndex = Battle.GetPlayer(battleIndex, e);
    -- ��������ˣ��˳�
    if dummyIndex < 0 then
      return
    end
    -- ������Ǽ��ˣ��˳�
    if not Char.IsDummy(dummyIndex) then
      return
    end

    -- �����Ӷ�� ���˳�
    local heroesOnline=sgModule:getGlobal("heroesOnline")
    if heroesOnline[dummyIndex] then
      return
    end

    -- ��������ڵȴ�����˳�
    local isWaiting = Battle.IsWaitingCommand(dummyIndex)
    if isWaiting ~=1 then
      return
    end

    if (Char.GetData(dummyIndex, CONST.����_ս��) == 1) then
      Battle.ActionSelect(dummyIndex, CONST.BATTLE_COM.BATTLE_COM_NONE, -1, 15002);
    end
    local side=0
    if e>9 then
      side=1
    end
    local sidetable = {{NLG.Rand(0,9),NLG.Rand(20,29),40},{NLG.Rand(10,19),NLG.Rand(30,39),41},{NLG.Rand(0,9),NLG.Rand(20,29),40},}
    --local charside = side+1;
    local charside = side+2;

    local skill_tbl = Char.GetTempData(dummyIndex, '���߼���') or nil;
    pcall(function()
      if skill_tbl then
        techId_tbl = JSON.decode(skill_tbl);
      end
    end)
    --local techId_tbl = skill_tbl[e+1];
    local count = 0;
    repeat
      local techSlot = NLG.Rand(1, 10);
      count = count + 1;
      chessTechId = tonumber(techId_tbl[techSlot]);
    until (chessTechId ~= nil) or (count==3)

    --print(chessTechId)
    -- ��һ������
    for k, v in pairs(skillParams) do
      if (chessTechId == nil) then
        chessTechId = 7300;
      end
      local chessSide = side + v.side + 1;
      local chessUnit = v.unit+1;
      local target = smartTargetSelection(battleIndex,sidetable[chessSide][chessUnit],chessTechId)
      if chessTechId>=v.techId[1] and chessTechId<=v.techId[2]  then
        Battle.ActionSelect(dummyIndex, v.com1, target, chessTechId);
        goto next
      end
    end
    Battle.ActionSelect(dummyIndex, CONST.BATTLE_COM.BATTLE_COM_ATTACK, sidetable[charside][1],-1);
    ::next::

    -- ��ȡ�����
    local petSLot = math.fmod(e + 5, 10)+side*10;
    local petIndex = Battle.GetPlayer(battleIndex, petSLot);

    if petIndex < 0 then
      local charside = side+2;
      local AtorDf = NLG.Rand(1, 2);
      if (AtorDf==1) then
        Battle.ActionSelect(dummyIndex, CONST.BATTLE_COM.BATTLE_COM_ATTACK, sidetable[charside][1],-1);
      elseif (AtorDf==2) then
        Battle.ActionSelect(dummyIndex, CONST.BATTLE_COM.BATTLE_COM_GUARD, -1,-1);
      end
    else

        local EnemyId = Char.GetData(petIndex,CONST.PET_PetID);
        local EnemyDataIndex = Data.EnemyGetDataIndex(EnemyId);
        local enemyBaseId = Data.EnemyGetData(EnemyDataIndex, CONST.Enemy_Base���);
        local EnemyBaseDataIndex = Data.EnemyBaseGetDataIndex(enemyBaseId);
        local skillNum =Data.EnemyBaseGetData(EnemyBaseDataIndex, CONST.EnemyBase_������);
        local skillSlot = NLG.Rand(0, skillNum-1);
        for k, v in pairs(skillParams) do
          local chessTechId = Pet.GetSkill(petIndex,skillSlot);
          if (chessTechId == -1) then
            chessTechId = 7300;
          end
          local chessSide = side + v.side + 1;
          local chessUnit = v.unit+1;
          local target = smartTargetSelection(battleIndex,sidetable[chessSide][chessUnit],chessTechId)
          if chessTechId>=v.techId[1] and chessTechId<=v.techId[2]  then
            Battle.ActionSelect(petIndex, v.com1, target, chessTechId);
            goto over
          end
        end
        local charside = side+2;
        local AtorDf = NLG.Rand(1, 2);
        if (AtorDf==1) then
          Battle.ActionSelect(petIndex, CONST.BATTLE_COM.BATTLE_COM_ATTACK, sidetable[charside][1],-1);
        elseif (AtorDf==2) then
          Battle.ActionSelect(petIndex, CONST.BATTLE_COM.BATTLE_COM_GUARD, -1,-1);
        end
        ::over::
    end
  end)
end

function battle_wincallback(battleIndex)
  local winside = Battle.GetWinSide(battleIndex);
  local poss={}
  for i = 0, 4 do
    table.insert(poss,i)
  end
  for i = 10, 14 do
    table.insert(poss,i)
  end

  table.forEach(poss, function(e)
    local dummyIndex = Battle.GetPlayer(battleIndex, e);
    -- ��������ˣ��˳�
    if dummyIndex < 0 then
      return
    end
    -- ������Ǽ��ˣ��˳�
    if not Char.IsDummy(dummyIndex) then
      return
    end

    -- �����Ӷ�� ���˳�
    local heroesOnline=sgModule:getGlobal("heroesOnline")
    if heroesOnline[dummyIndex] then
      return
    end

    if (e==0) then
      local playercdk = Char.GetTempData(dummyIndex, '��������');
      local player = NLG.FindUser(playercdk);
      local pts = Char.GetExtData(player, '���߻���') or 0;
      Char.SetExtData(player, '���߻���', pts+1);
      NLG.UpChar(player);
    end
    Char.DelDummy(dummyIndex);

  end)

  Battle.UnsetPVPWinEvent(battleIndex);
end


function Module:handleTalkEvent(charIndex,msg,color,range,size)
	if (msg=="/chess") then
		self:petbagInfo(self.petBankNPC, charIndex);
		return 0;
	end
	return 1;
end

function Module:onLoginEvent(charIndex)
  local bIndex = Char.GetExtData(charIndex, "petbag-index") or 1;
  Protocol.Send(charIndex, "petbagIndex",  tonumber(bIndex));
end


--Ŀ����Ϣ
function pickupGoalInfo(player,petbagIndex,petNo)
      local petbagPet = Char.GetExtData(player, string.format("petbag-%d-%d", petbagIndex, petNo));
      pcall(function()
        if petbagPet then
          petbagPet = JSON.decode(petbagPet);
        end
      end)

      if type(petbagPet) == 'table' then
        local enemyId = petbagPet.attr[tostring(CONST.PET_PetID)];
        local Goal_name = petbagPet.attr[tostring(CONST.����_����)];
        local Goal_DataPos_3 = petbagPet.attr[tostring(CONST.����_����)];
        local Goal_DataPos_3 = Tribe(Goal_DataPos_3);
        local Goal_DataPos_5 = petbagPet.attr[tostring(CONST.����_������)];
        local Goal_DataPos_6 = petbagPet.attr[tostring(CONST.����_������)];
        local Goal_DataPos_7 = petbagPet.attr[tostring(CONST.����_����)];
        local Goal_DataPos_8 = petbagPet.attr[tostring(CONST.����_����)];
        local Goal_DataPos_9 = petbagPet.attr[tostring(CONST.����_�ظ�)];

        local Goal_DataPos_12 = petbagPet.attr[tostring(CONST.����_����)];
        local Goal_DataPos_13 = petbagPet.attr[tostring(CONST.����_��ɱ)];
        local Goal_DataPos_14 = petbagPet.attr[tostring(CONST.����_������)];
        local Goal_DataPos_15 = petbagPet.attr[tostring(CONST.����_ˮ����)];
        local Goal_DataPos_16 = petbagPet.attr[tostring(CONST.����_������)];
        local Goal_DataPos_17 = petbagPet.attr[tostring(CONST.����_������)];
        local Goal_DataPos_18 = petbagPet.attr[tostring(CONST.����_����)];
        local Goal_DataPos_19 = petbagPet.attr[tostring(CONST.����_����)];
        local Goal_DataPos_20 = petbagPet.attr[tostring(CONST.����_��˯)];
        local Goal_DataPos_21 = petbagPet.attr[tostring(CONST.����_����)];
        local Goal_DataPos_22 = petbagPet.attr[tostring(CONST.����_��ʯ)];
        local Goal_DataPos_23 = petbagPet.attr[tostring(CONST.����_����)];
        local Goal_DataPos_26 = petbagPet.attr[tostring(CONST.����_����)];
        local Goal_DataPos_27 = petbagPet.attr[tostring(CONST.����_����)];
        local Goal_DataPos_28 = petbagPet.attr[tostring(CONST.����_�ȼ�)];
        local Goal_DataPos_29 = petbagPet.attr[tostring(CONST.����_ԭ��)];
        local imageText = "@g,"..Goal_DataPos_29..",2,8,6,0@"

        msg = imageText .. "����$4".. Goal_name .. "\\n"
                         .. "��������������" .. "$1���� ".. Goal_DataPos_5 .."��" .. "$8�ؚ� ".. Goal_DataPos_13 .."��" .. "$8���� ".. Goal_DataPos_27 .."\\n"
                         .. "��������������" .. "$1���R ".. Goal_DataPos_6 .."��" .. "$8���� ".. Goal_DataPos_12 .."��" .. "$8�W�� ".. Goal_DataPos_26 .."\\n"
                         .. "��������������" .. "$1���� ".. Goal_DataPos_7 .."��" .. "$2���� ".. Goal_DataPos_18 .."��" .. "$2���� ".. Goal_DataPos_19 .."\\n"
                         .. "��������������" .. "$1���� ".. Goal_DataPos_8 .."��" .. "$2��˯ ".. Goal_DataPos_20 .."��" .. "$2���� ".. Goal_DataPos_21 .."\\n"
                         .. "��������������" .. "$1�֏� ".. Goal_DataPos_9 .."��" .. "$2��ʯ ".. Goal_DataPos_22 .."��" .. "$2���� ".. Goal_DataPos_23 .."\\n"
                         .. "��������������" .. "$5�� ".. Goal_DataPos_14/10 .."��" .."$5ˮ ".. Goal_DataPos_15/10 .."��" .."$5�� ".. Goal_DataPos_16/10 .."��" .."$5�L ".. Goal_DataPos_17/10 .."\\n"
                         .. "��������������" .. "$9�N�� ".. Goal_DataPos_3 .."��" .. "$9�ȼ� ".. Goal_DataPos_28 .."\\n"
      else
        msg = "\\n\\n\\n\\n@c�����F�e�`"
      end
      return msg;
end

--�����ַ���ת��
function Tribe(Tribe)
  if Tribe==0 then
    return "����ϵ"
  elseif Tribe == 1 then
    return "����ϵ"
  elseif Tribe == 2 then
    return "����ϵ"
  elseif Tribe == 3 then
    return "�w��ϵ"
  elseif Tribe == 4 then
    return "���xϵ"
  elseif Tribe == 5 then
    return "ֲ��ϵ"
  elseif Tribe == 6 then
    return "Ұ�Fϵ"
  elseif Tribe == 7 then
    return "����ϵ"
  elseif Tribe == 8 then
    return "����ϵ"
  elseif Tribe == 9 then
    return "аħϵ"
  elseif Tribe == 10 then
    return "����ϵ"
  elseif Tribe == 11 then
    return "���`ϵ"
  end
end

--------------------------------------------------------------------
-- NOTE ��ȡ��������
function Module:extractPetData(petIndex)
  local petProfile = {
    attr={},
    rank={},
    skills={},
    items={},
  };
  for _, v in pairs(petFields) do
    petProfile.attr[tostring(v)] = Char.GetData(petIndex, v);
    
  end
  for _, v in pairs(petRankFields) do
    petProfile.rank[tostring(v)] = Pet.GetArtRank(petIndex,v);
    
  end
  -- ���＼��
  local skillTable={}
  for i=0,9 do
    local tech_id = Pet.GetSkill(petIndex, i)
    if tech_id<0 then
      table.insert(skillTable,nil)
    else
      table.insert(skillTable,tech_id)
    end
  end
  petProfile.skills=skillTable

  --����װ��
  local items={}
  for item_slot = 0,4 do
    local itemIndex = Char.GetItemIndex(petIndex,item_slot);
    if itemIndex>=0 then
      local data = self:extractItemData(itemIndex)
      petProfile.items[tostring(item_slot)]=data;
    end
  end

  return petProfile;
end

-- NOTE �����������
function Module:insertPetData(petIndex,petData)
  -- ��������
  for key, v in pairs(petFields) do
    if petData.attr[tostring(v)] ~=nil  then
      Char.SetData(petIndex, v,petData.attr[tostring(v)]);
    end
  end
  -- �ҳ�
  -- Char.SetData(petIndex, 495,100);
  -- ����ɳ�
  for key, v in pairs(petRankFields) do
    if petData.rank[tostring(v)] ~=nil then
      Pet.SetArtRank(petIndex, v,petData.rank[tostring(v)]);
    end
  end
  -- ���＼��
  
  for i=0,9 do
    local tech_id = petData.skills[i+1]
    Pet.DelSkill(petIndex,i)
    if tech_id ~=nil then
      
      Pet.AddSkill(petIndex,tech_id)
    
    end
  end


end

-- NOTE ��ȡ ��Ʒ����
function Module:extractItemData(itemIndex)
  local item = {};
  for _, v in pairs(itemFields) do
    item[tostring(v)] = Item.GetData(itemIndex, v);
  end
  return item;
end
--  NOTE ���� ��Ʒ����
function Module:insertItemData(itemIndex,itemData)
  for _, field in pairs(itemFields) do
    local r = 0;
    if type(itemData[tostring(field)]) ~= 'nil' then
      r = Item.SetData(itemIndex, field, itemData[tostring(field)]);
    end
  end
end

function smartTargetSelection(battleIndex,com2,com3)
  local chessSide = com2 - math.fmod(com2, 10);

  if (com3>=6100 and com3<=6199) or (com3>=6200 and com3<=6299) or (com3>=6300 and com3<=6399) then
    -- NOTE ����Ѫ��ռ�����
    local tagHp = nil;
    local returnSlot;
    for slot = chessSide + 0, chessSide + 9 do
      local charIndex = Battle.GetPlayer(battleIndex, slot)
      if (charIndex >= 0) then
        local hpRatio = Char.GetData(charIndex, CONST.����_Ѫ) / Char.GetData(charIndex, CONST.����_���Ѫ)
        if tagHp == nil then
          tagHp = hpRatio
          returnSlot = slot
        elseif hpRatio < tagHp then
          tagHp = hpRatio;
          returnSlot = slot
        end
      end
    end
    return returnSlot;
  elseif (com3>=6800 and com3<=6899) then
    local slotTable = {}
    for slot = chessSide + 0, chessSide + 9 do
      local charIndex = Battle.GetPlayer(battleIndex, slot)
      if charIndex >= 0 and Char.GetData(charIndex, CONST.����_ս��) == 1 then
        table.insert(slotTable, slot)
      end
    end
    local returnSlot = slotTable[NLG.Rand(1, #slotTable)]
    return returnSlot;
  else
    -- NOTE Ѫ���ٵ�
    local tagHp = nil;
    local returnSlot;
    for slot = chessSide + 0, chessSide + 9 do
      local charIndex = Battle.GetPlayer(battleIndex, slot)
      if (charIndex >= 0) then
        local hp = Char.GetData(charIndex, CONST.����_Ѫ)
        if tagHp == nil then
         tagHp = hp
         returnSlot = slot
        elseif hp < tagHp then
         tagHp = hp;
         returnSlot = slot
        end
      end
    end
    return returnSlot;
  end
  local returnSlot = NLG.Rand(chessSide + 0, chessSide + 9)
  return returnSlot;
end


Char.GetPetEmptySlot = function(charIndex)
  for Slot=0,4 do
      local PetIndex = Char.GetPet(charIndex, Slot);
      --print(PetIndex);
      if (PetIndex < 0) then
          return Slot;
      end
  end
  return -1;
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
