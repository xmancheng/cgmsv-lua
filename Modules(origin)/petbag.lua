---模块类
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
          for i = 1, 5 do		--5页宠物库
            for j = 1, 8 do		--每页8隻宠物
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
  CONST.对象_类型,
  CONST.对象_形象,
  CONST.对象_原形,
  CONST.对象_MAP,
  CONST.对象_地图,
  CONST.对象_X,
  CONST.对象_Y,
  CONST.对象_方向,
  CONST.对象_等级,
  CONST.对象_血,
  CONST.对象_魔,
  CONST.对象_体力,
  CONST.对象_力量,
  CONST.对象_强度,
  CONST.对象_速度,
  CONST.对象_魔法,
  CONST.对象_运气,
  CONST.对象_种族,
  CONST.对象_地属性,
  CONST.对象_水属性,
  CONST.对象_火属性,
  CONST.对象_风属性,
  CONST.对象_抗毒,
  CONST.对象_抗睡,
  CONST.对象_抗石,
  CONST.对象_抗醉,
  CONST.对象_抗乱,
  CONST.对象_抗忘,
  CONST.对象_必杀,
  CONST.对象_反击,
  CONST.对象_命中,
  CONST.对象_闪躲,
  CONST.对象_道具栏,
  CONST.对象_技能栏,
  CONST.对象_死亡数,
  CONST.对象_伤害数,
  CONST.对象_杀宠数,
  CONST.对象_占卜时间,
  CONST.对象_受伤,
  CONST.对象_移间,
  CONST.对象_循时,
  CONST.对象_经验,
  CONST.对象_升级点,
  CONST.对象_图类,
  CONST.对象_名色,
  CONST.对象_掉魂,
  CONST.对象_原始图档,
  CONST.对象_名字,
  CONST.对象_最大血,
  CONST.对象_最大魔,
  CONST.对象_攻击力,
  CONST.对象_防御力,
  CONST.对象_敏捷,
  CONST.对象_精神,
  CONST.对象_回复,
  CONST.对象_获得经验,
  CONST.对象_EnemyBaseId,
  CONST.PET_DepartureBattleStatus,
  CONST.PET_PetID,
  CONST.PET_技能栏,
  CONST.对象_名色,
  CONST.对象_魅力,
  CONST.对象_耐力,
  CONST.对象_灵巧,
  CONST.对象_智力,
  CONST.对象_魅力,
  CONST.对象_声望,
  CONST.宠物_获取时等级,
  CONST.宠物_基础忠诚,
  CONST.宠物_捕捉难度,
  CONST.宠物_忠诚,
  --CONST.对象_主人CDK;		--4003
  --CONST.对象_主人名字;	--4004
}

-- NOTE 宠物成长属性key
local petRankFields={
  CONST.PET_体成,
  CONST.PET_力成,
  CONST.PET_强成,
  CONST.PET_敏成,
  CONST.PET_魔成,
}

-- NOTE 物品的所有属性key
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
  CONST.对象_形象,
  CONST.对象_原形,
  CONST.对象_等级,
  CONST.对象_血,
  CONST.对象_魔,
  CONST.对象_体力,
  CONST.对象_力量,
  CONST.对象_强度,
  CONST.对象_速度,
  CONST.对象_魔法,
  CONST.对象_运气,
  CONST.对象_种族,
  CONST.对象_地属性,
  CONST.对象_水属性,
  CONST.对象_火属性,
  CONST.对象_风属性,
  CONST.对象_抗毒,
  CONST.对象_抗睡,
  CONST.对象_抗石,
  CONST.对象_抗醉,
  CONST.对象_抗乱,
  CONST.对象_抗忘,
  CONST.对象_必杀,
  CONST.对象_反击,
  CONST.对象_命中,
  CONST.对象_闪躲,
  --CONST.对象_道具栏,
  --CONST.对象_技能栏,
  CONST.对象_死亡数,
  CONST.对象_伤害数,
  CONST.对象_杀宠数,
  CONST.对象_占卜时间,
  CONST.对象_受伤,
  CONST.对象_移间,
  CONST.对象_循时,
  CONST.对象_经验,
  CONST.对象_升级点,
  CONST.对象_图类,
  CONST.对象_名色,
  CONST.对象_掉魂,
  CONST.对象_原始图档,
  CONST.对象_名字,
  CONST.对象_最大血,
  CONST.对象_最大魔,
  CONST.对象_攻击力,
  CONST.对象_防御力,
  CONST.对象_敏捷,
  CONST.对象_精神,
  CONST.对象_回复,
  CONST.对象_名色,
  --CONST.对象_魅力,
  --CONST.对象_耐力,
  --CONST.对象_灵巧,
  --CONST.对象_智力,
  CONST.对象_声望,
}

-- {skillId,	com1,	com3(techId),	0 己方 |1 对方（目前没用） ，目标点击单位： 0 sigle| 1 range | 2 sideall |3 whole }
skillParams={

	-- 自创技能
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
	-- 攻击
	{skillId=73,com1=CONST.BATTLE_COM.BATTLE_COM_ATTACK,techId={7300,7300},side=1,unit=0},
	-- 防御
	{skillId=74,com1=CONST.BATTLE_COM.BATTLE_COM_GUARD,techId={7400,7400},side=0,unit=0},
	-- 连击
	{skillId=0,com1=CONST.BATTLE_COM.BATTLE_COM_P_RENZOKU,techId={0,99},side=1,unit=0},
	-- 诸刃
	{skillId=1,com1=CONST.BATTLE_COM.BATTLE_COM_P_PARAMETER,techId={100,199},side=1,unit=0},
	-- 乾坤
	{skillId=3,com1=CONST.BATTLE_COM.BATTLE_COM_P_PARAMETER,techId={300,399},side=1,unit=0},
	-- 气功蛋
	{skillId=4,com1=CONST.BATTLE_COM.BATTLE_COM_P_SPIRACLESHOT,techId={400,499},side=1,unit=0},
	-- 崩击
	{skillId=5,com1=CONST.BATTLE_COM.BATTLE_COM_P_GUARDBREAK,techId={500,599},side=1,unit=0},
	-- 战栗袭心
	{skillId=6,com1=CONST.BATTLE_COM.BATTLE_COM_P_FORCECUT,techId={600,699},side=1,unit=0},
	-- 护卫
	{skillId=7,com1=CONST.BATTLE_COM.BATTLE_COM_P_BODYGUARD,techId={700,799},side=0,unit=0},
	-- 圣盾
	{skillId=8,com1=CONST.BATTLE_COM.BATTLE_COM_P_SPECIALGARD,techId={800,899},side=0,unit=0},
	-- 阳炎
	{skillId=9,com1=CONST.BATTLE_COM.BATTLE_COM_P_DODGE,techId={900,999},side=1,unit=0},
	-- 防御魔法攻击
	{skillId=10,com1=CONST.BATTLE_COM.BATTLE_COM_P_MAGICGARD,techId={1000,1000},side=0,unit=0},
	-- 反击
	{skillId=11,com1=CONST.BATTLE_COM.BATTLE_COM_P_CROSSCOUNTER,techId={1100,1199},side=0,unit=0},
	-- 明镜止水
	{skillId=12,com1=CONST.BATTLE_COM.BATTLE_COM_P_CONSENTRATION,techId={1200,1299},side=0,unit=0},
	-- 陨石魔法
	{skillId=19,com1=CONST.BATTLE_COM.BATTLE_COM_P_MAGIC,techId={1900,1999},side=1,unit=0},
	-- 冰冻魔法
	{skillId=20,com1=CONST.BATTLE_COM.BATTLE_COM_P_MAGIC,techId={2000,2099},side=1,unit=0},
	-- 火焰魔法
	{skillId=21,com1=CONST.BATTLE_COM.BATTLE_COM_P_MAGIC,techId={2100,2199},side=1,unit=0},
	-- 风刃魔法
	{skillId=22,com1=CONST.BATTLE_COM.BATTLE_COM_P_MAGIC,techId={2200,2299},side=1,unit=0},
	-- 强力陨石
	{skillId=23,com1=CONST.BATTLE_COM.BATTLE_COM_P_MAGIC,techId={2300,2399},side=1,unit=1},
	-- 强力冰冻
	{skillId=24,com1=CONST.BATTLE_COM.BATTLE_COM_P_MAGIC,techId={2400,2499},side=1,unit=1},
	-- 强力火焰
	{skillId=25,com1=CONST.BATTLE_COM.BATTLE_COM_P_MAGIC,techId={2500,2599},side=1,unit=1},
	-- 强力风刃
	{skillId=26,com1=CONST.BATTLE_COM.BATTLE_COM_P_MAGIC,techId={2600,2699},side=1,unit=1},
	-- 超强陨石
	{skillId=27,com1=CONST.BATTLE_COM.BATTLE_COM_P_MAGIC,techId={2700,2799},side=1,unit=2},
	-- 超强冰冻
	{skillId=28,com1=CONST.BATTLE_COM.BATTLE_COM_P_MAGIC,techId={2800,2899},side=1,unit=2},
	-- 超强火焰
	{skillId=29,com1=CONST.BATTLE_COM.BATTLE_COM_P_MAGIC,techId={2900,2999},side=1,unit=2},
	-- 超强风刃
	{skillId=30,com1=CONST.BATTLE_COM.BATTLE_COM_P_MAGIC,techId={3000,3099},side=1,unit=2},
	-- 吸血魔法
	{skillId=31,com1=CONST.BATTLE_COM.BATTLE_COM_P_DORAIN,techId={3100,3199},side=1,unit=0},
	-- 补血
	{skillId=61,com1=CONST.BATTLE_COM.BATTLE_COM_P_HEAL,techId={6100,6199},side=0,unit=0},
	-- 强力补血
	{skillId=62,com1=CONST.BATTLE_COM.BATTLE_COM_P_HEAL,techId={6200,6299},side=0,unit=1},
	-- 超强补血
	{skillId=63,com1=CONST.BATTLE_COM.BATTLE_COM_P_HEAL,techId={6300,6399},side=0,unit=2},
	-- 恢复
	{skillId=64,com1=CONST.BATTLE_COM.BATTLE_COM_P_LP_RECOVERY,techId={6400,6499},side=0,unit=0},
	-- 强力恢复
	{skillId=65,com1=CONST.BATTLE_COM.BATTLE_COM_P_LP_RECOVERY,techId={6500,6599},side=0,unit=1},
	-- 超强恢复
	{skillId=66,com1=CONST.BATTLE_COM.BATTLE_COM_P_LP_RECOVERY,techId={6600,6699},side=0,unit=2},
	-- 洁净 单体目标
	{skillId=67,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSRECOVER,techId={6700,6702},side=0,unit=0},
	-- 洁净 强力目标
	{skillId=67,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSRECOVER,techId={6703,6705},side=0,unit=1},
	-- 洁净 强超强目标
	{skillId=67,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSRECOVER,techId={6706,6799},side=0,unit=2},
	-- 气绝回复
	{skillId=68,com1=CONST.BATTLE_COM.BATTLE_COM_P_REVIVE,techId={6800,6899},side=0,unit=0},
	-- 宠物毒性攻击
	{skillId=75,com1=CONST.BATTLE_COM.BATTLE_COM_M_STATUSATTACK,techId={7500,7599},side=1,unit=0},
	-- 宠物昏睡攻击
	{skillId=76,com1=CONST.BATTLE_COM.BATTLE_COM_M_STATUSATTACK,techId={7600,7699},side=1,unit=0},
	-- 宠物石化攻击
	{skillId=77,com1=CONST.BATTLE_COM.BATTLE_COM_M_STATUSATTACK,techId={7700,7799},side=1,unit=0},
	-- 宠物酒醉攻击
	{skillId=78,com1=CONST.BATTLE_COM.BATTLE_COM_M_STATUSATTACK,techId={7800,7899},side=1,unit=0},
	-- 宠物混乱攻击
	{skillId=79,com1=CONST.BATTLE_COM.BATTLE_COM_M_STATUSATTACK,techId={7900,7999},side=1,unit=0},
	-- 宠物遗忘攻击
	{skillId=80,com1=CONST.BATTLE_COM.BATTLE_COM_M_STATUSATTACK,techId={8000,8099},side=1,unit=0},
	-- 宠物吸血攻击
	{skillId=81,com1=CONST.BATTLE_COM.BATTLE_COM_M_BLOODATTACK,techId={8100,8199},side=1,unit=0},
	-- 混乱攻击
	{skillId=94,com1=CONST.BATTLE_COM.BATTLE_COM_P_PANIC,techId={9400,9499},side=1,unit=0},
	-- 乱射
	{skillId=95,com1=CONST.BATTLE_COM.BATTLE_COM_P_RANDOMSHOT,techId={9500,9599},side=1,unit=0},
	-- 戒骄戒躁
	{skillId=1001,com1=CONST.BATTLE_COM.BATTLE_COM_DELAYATTACK,techId={25700,25799},side=1,unit=0},
	-- 一击必中
	{skillId=1002,com1=CONST.BATTLE_COM.BATTLE_COM_DELAYATTACK,techId={25800,25899},side=1,unit=0},
	-- 毒击
	{skillId=1003,com1=CONST.BATTLE_COM.BATTLE_COM_M_STATUSATTACK,techId={25900,25999},side=1,unit=0},
	-- 一石二鸟
	{skillId=1004,com1=CONST.BATTLE_COM.BATTLE_COM_BILLIARD,techId={26000,26099},side=1,unit=0},
	-- 骑士之誉
	{skillId=1005,com1=CONST.BATTLE_COM.BATTLE_COM_KNIGHTGUARD,techId={26100,26199},side=0,unit=0},
	-- 迅速果断
	{skillId=1006,com1=CONST.BATTLE_COM.BATTLE_COM_FIRSTATTACK,techId={26200,26299},side=1,unit=0},
	-- 羊头狗肉
	{skillId=1007,com1=CONST.BATTLE_COM.BATTLE_COM_COPY,techId={26300,26399},side=1,unit=0},
	-- 因果报应
	{skillId=1010,com1=CONST.BATTLE_COM.BATTLE_COM_RETRIBUTION,techId={26600,26699},side=1,unit=0},
	-- 追月
	{skillId=2005,com1=CONST.BATTLE_COM.BATTLE_COM_BLASTWAVE,techId={200500,200599},side=1,unit=0},
	-- 中毒魔法
	{skillId=32,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={3200,3299},side=1,unit=0},
	-- 昏睡魔法
	{skillId=33,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={3300,3399},side=1,unit=0},
	-- 石化魔法
	{skillId=34,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={3400,3499},side=1,unit=0},
	-- 酒醉魔法
	{skillId=35,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={3500,3599},side=1,unit=0},
	-- 混乱魔法
	{skillId=36,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={3600,3699},side=1,unit=0},
	-- 遗忘魔法
	{skillId=37,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={3700,3799},side=1,unit=0},
	-- 强力中毒魔法
	{skillId=38,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={3800,3899},side=1,unit=1},
	-- 强力昏睡魔法
	{skillId=39,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={3900,3999},side=1,unit=1},
	-- 强力石化魔法
	{skillId=40,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={4000,4099},side=1,unit=1},
	-- 强力酒醉魔法
	{skillId=41,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={4100,4199},side=1,unit=1},
	-- 强力混乱魔法
	{skillId=42,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={4200,4299},side=1,unit=1},
	-- 强力遗忘魔法
	{skillId=43,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={4300,4399},side=1,unit=1},
	-- 超强中毒魔法
	{skillId=44,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={4400,4499},side=1,unit=2},
	-- 超强昏睡魔法
	{skillId=45,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={4500,4599},side=1,unit=2},
	-- 超强石化魔法
	{skillId=46,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={4600,4699},side=1,unit=2},
	-- 超强酒醉魔法
	{skillId=47,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={4700,4799},side=1,unit=2},
	-- 超强混乱魔法
	{skillId=48,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={4800,4899},side=1,unit=2},
	-- 超强遗忘魔法
	{skillId=49,com1=CONST.BATTLE_COM.BATTLE_COM_P_STATUSCHANGE,techId={4900,4999},side=1,unit=2},
	-- 大地的祈祷
	{skillId=50,com1=CONST.BATTLE_COM.BATTLE_COM_P_TREAT_TYPE,techId={5000,5099},side=0,unit=0},
	-- 海洋的祈祷
	{skillId=51,com1=CONST.BATTLE_COM.BATTLE_COM_P_TREAT_TYPE,techId={5100,5199},side=0,unit=0},
	-- 火焰的祈祷
	{skillId=52,com1=CONST.BATTLE_COM.BATTLE_COM_P_TREAT_TYPE,techId={5200,5299},side=0,unit=0},
	-- 云群的祈祷
	{skillId=53,com1=CONST.BATTLE_COM.BATTLE_COM_P_TREAT_TYPE,techId={5300,5399},side=0,unit=0},
	-- 属性反转
	{skillId=54,com1=CONST.BATTLE_COM.BATTLE_COM_P_REVERSE_TYPE,techId={5400,5499},side=0,unit=0},
	-- 攻击反弹
	{skillId=55,com1=CONST.BATTLE_COM.BATTLE_COM_P_REFLECTION_PHYSICS,techId={5500,5599},side=0,unit=0},
	-- 魔法反弹
	{skillId=56,com1=CONST.BATTLE_COM.BATTLE_COM_P_REFLECTION_MAGIC,techId={5600,5699},side=0,unit=0},
	-- 攻击吸收
	{skillId=57,com1=CONST.BATTLE_COM.BATTLE_COM_P_ABSORB_PHYSICS,techId={5700,5799},side=0,unit=0},
	-- 魔法吸收
	{skillId=58,com1=CONST.BATTLE_COM.BATTLE_COM_P_ABSORB_MAGIC,techId={5800,5899},side=0,unit=0},
	-- 攻击无效
	{skillId=59,com1=CONST.BATTLE_COM.BATTLE_COM_P_INEFFECTIVE_PHYSICS,techId={5900,5999},side=0,unit=0},
	-- 魔法无效
	{skillId=60,com1=CONST.BATTLE_COM.BATTLE_COM_P_INEFFECTIVE_MAGIC,techId={6000,6099},side=0,unit=0},
	-- 宠物定点移动
	{skillId=160,com1=CONST.BATTLE_COM.BATTLE_COM_POSITION,techId={16000,16000},side=0,unit=0},
	-- 宠物什么都不做
	{skillId=170,com1=CONST.BATTLE_COM.BATTLE_COM_NONE,techId={15002,15002},side=0,unit=0},
	-- 盗窃
	{skillId=72,com1=CONST.BATTLE_COM.BATTLE_COM_P_STEAL,techId={7200,7299},side=0,unit=0},
}

--------------------------------------------------------------------
local function calcWarp()
  local page = math.modf(#petbag_list / 8) + 1
  local remainder = math.fmod(#petbag_list, 8)
  return page, remainder
end

--远程按钮UI呼叫
function Module:petbagInfo(npc, player)
          local winButton = CONST.按钮_关闭;
          local msg = "2\\n　　　　　　　　【寵物雲端倉庫】\\n\\n"
               .. "　　◎提取存放的寵物\\n\\n"
               .. "　　◎寄存身上的寵物\\n\\n";
          NLG.ShowWindowTalked(player, self.petBankNPC, CONST.窗口_选择框, CONST.按钮_关闭, 777, msg);
end

--------------------------------------------------------------------
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self))
  self:regCallback('BeforeBattleTurnEvent', Func.bind(self.handleBattleAutoCommand, self))
  --self:regCallback('LoginEvent', Func.bind(self.onLoginEvent, self));
  self.petBankNPC = self:NPC_createNormal('寵物雲端倉庫', 14682, { x = 38, y = 30, mapType = 0, map = 777, direction = 6 });
  self:NPC_regWindowTalkedEvent(self.petBankNPC, function(npc, player, _seqno, _select, _data)
    local column = tonumber(_data)
    local page = tonumber(_seqno)
    local warpPage = page;
    --判断使用几页格库
    --[[local petbag_list = {}
    for bagslot = 1, 5 do		--5页宠物库
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
    local winMsg = "1\\n　　　　　　　　【寵物雲端倉庫】\\n"
    local winButton = CONST.按钮_关闭;
    local totalPage, remainder = calcWarp()
    --上页16 下页32 关闭/取消2
    if _select > 0 then
      if _select == CONST.按钮_关闭 then
          if (page==777 or page==778) then
              return
          end
      elseif _select == CONST.按钮_是 then
          if (page>=2001 and page<3000) then
              if (Char.PetNum(player)==5) then
                 NLG.SystemMessage(player,"[系統]寵物欄位置已滿。");
                 return;
              end

              local petNo = petNo;
              local seqno = page - 2000;
              local petbagIndex = tonumber(seqno);
              if petbagIndex < 1 or petbagIndex > 5 then
                NLG.SystemMessage(player, '無效寵物格庫')
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

                --宠物装备
                for i,petsData_item in pairs(petData.items or {}) do
                  local item_slot = tonumber(i)
                  local itemId = petsData_item[tostring(CONST.道具_ID)]
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
      elseif _select == CONST.按钮_否 then
          if (page>=2001 and page<3000) then
              --第一页格库
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
                  local Goal_name = petbagPet.attr[tostring(CONST.对象_名字)];
                  winMsg = winMsg .. "　　格庫["..slot.."]號位: " .. Goal_name .."\\n";
                else
                  winMsg = winMsg .. "　　格庫["..slot.."]號位: 空\\n";
                end
              end
              NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.按钮_下取消, 1000+1, winMsg);
              return
          else
              return
          end
      end
      if (warpPage>=3001) then	--寄存
        local warpPage = warpPage - 3000;
        if _select == CONST.BUTTON_下一页 then
          warpPage = warpPage + 1
          if (warpPage == totalPage) or ((warpPage == (totalPage - 1) and remainder == 0)) then
            winButton = CONST.BUTTON_上取消
          else
            winButton = CONST.BUTTON_上下取消
          end
        elseif _select == CONST.BUTTON_上一页 then
          warpPage = warpPage - 1
          if warpPage == 1 then
            winButton = CONST.BUTTON_下取消
          else
            winButton = CONST.BUTTON_上下取消
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
              NLG.SystemMessage(player, '無效寵物格庫')
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
              local Goal_name = petbagPet.attr[tostring(CONST.对象_名字)];
              winMsg = winMsg .. "　　格庫["..i+count.."]號位: " .. Goal_name .."\\n";
            else
              winMsg = winMsg .. "　　格庫["..i+count.."]號位: 空\\n";
            end
          end
        else
          local petbagIndex = tonumber(warpPage);
          if petbagIndex < 1 or petbagIndex > 5 then
              NLG.SystemMessage(player, '無效寵物格庫')
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
              local Goal_name = petbagPet.attr[tostring(CONST.对象_名字)];
              winMsg = winMsg .. "　　格庫["..i+count.."]號位: " .. Goal_name .."\\n";
            else
              winMsg = winMsg .. "　　格庫["..i+count.."]號位: 空\\n";
            end
          end
        end
        NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, winButton, 3000+warpPage, winMsg);
      elseif (warpPage>=1001 and warpPage<3000) then	--提取
        local warpPage = warpPage - 1000;
        if _select == CONST.BUTTON_下一页 then
          warpPage = warpPage + 1
          if (warpPage == totalPage) or ((warpPage == (totalPage - 1) and remainder == 0)) then
            winButton = CONST.BUTTON_上取消
          else
            winButton = CONST.BUTTON_上下取消
          end
        elseif _select == CONST.BUTTON_上一页 then
          warpPage = warpPage - 1
          if warpPage == 1 then
            winButton = CONST.BUTTON_下取消
          else
            winButton = CONST.BUTTON_上下取消
          end
        elseif _select == 2 then
          warpPage = 1;
          return;
        end
        local count = 8 * (warpPage - 1)
        if warpPage == totalPage then
          local petbagIndex = tonumber(warpPage);
          if petbagIndex < 1 or petbagIndex > 5 then
              NLG.SystemMessage(player, '無效寵物格庫')
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
              local Goal_name = petbagPet.attr[tostring(CONST.对象_名字)];
              winMsg = winMsg .. "　　格庫["..i+count.."]號位: " .. Goal_name .."\\n";
            else
              winMsg = winMsg .. "　　格庫["..i+count.."]號位: 空\\n";
            end
          end
        else
          local petbagIndex = tonumber(warpPage);
          if petbagIndex < 1 or petbagIndex > 5 then
              NLG.SystemMessage(player, '無效寵物格庫')
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
              local Goal_name = petbagPet.attr[tostring(CONST.对象_名字)];
              winMsg = winMsg .. "　　格庫["..i+count.."]號位: " .. Goal_name .."\\n";
            else
              winMsg = winMsg .. "　　格庫["..i+count.."]號位: 空\\n";
            end
          end
        end
        NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, winButton, 1000+warpPage, winMsg);
      end
    else
      --print(column)
      if (page==777 and column==1) then			--提取
        local warpPage = 1;
        local count = 8 * (warpPage - 1) + column;
        --print(count)

        --第一页格库
        local petbagIndex = tonumber(warpPage);
        if petbagIndex < 1 or petbagIndex > 5 then
            NLG.SystemMessage(player, '無效寵物格庫')
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
            local Goal_name = petbagPet.attr[tostring(CONST.对象_名字)];
            winMsg = winMsg .. "　　格庫["..slot.."]號位: " .. Goal_name .."\\n";
          else
            winMsg = winMsg .. "　　格庫["..slot.."]號位: 空\\n";
          end
        end
        NLG.ShowWindowTalked(player, self.petBankNPC, CONST.窗口_选择框, CONST.按钮_下取消, 1000+warpPage, winMsg);
      elseif (page==777 and column==3) then		--寄存
          local msg = "　　　　　　　　【寵物雲端倉庫】\\n"
          local msg = "2|\\n選擇要寄存雲端電腦的寵物:\\n\\n";
          for petSlot=0,4 do
                local petIndex = Char.GetPet(player,petSlot);
                if(petIndex<0)then
                      msg = msg .. "空\\n";
                else
                      msg = msg .. ""..Char.GetData(petIndex,CONST.对象_名字).."\\n";
                end
          end
          NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.按钮_关闭, 778, msg);
      elseif (page==778) then
          updatedPetdata = column-1;
          local petIndex = Char.GetPet(player,updatedPetdata);
          if (petIndex<0) then
            NLG.SystemMessage(player, '[系統]選擇的位置沒有寵物。')
            return;
          end
          --第一页格库
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
              local Goal_name = petbagPet.attr[tostring(CONST.对象_名字)];
              winMsg = winMsg .. "　　格庫["..slot.."]號位: " .. Goal_name .."\\n";
            else
              winMsg = winMsg .. "　　格庫["..slot.."]號位: 空\\n";
            end
          end
          NLG.ShowWindowTalked(player, self.petBankNPC, CONST.窗口_选择框, CONST.按钮_下取消, 3000+1, winMsg);
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
            NLG.SystemMessage(player, '[系統]格庫已經有寄存。')
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
            local msg = "　　　　　　　　【寵物雲端倉庫】\\n"
            local msg = msg .. pickupGoalInfo(player,petbagIndex,petNo);
            NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.按钮_是否, 2000+seqno, msg);
          else
            NLG.SystemMessage(player, '[系統]選擇的格庫沒有寵物。')
            return;
          end
      else
          return;
      end
    end
  end)
  self:NPC_regTalkedEvent(self.petBankNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local winButton = CONST.BUTTON_关闭;
      local msg = "2\\n　　　　　　　　【寵物雲端倉庫】\\n\\n"
           .. "　　◎提取存放的寵物\\n\\n"
           .. "　　◎寄存身上的寵物\\n\\n";
      NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.按钮_关闭, 777, msg);
    end
    return
  end)


  self.ChessNPC = self:NPC_createNormal('寵物自動對戰', 14682, { x = 218, y = 93, mapType = 0, map = 1000, direction = 0 });
  Char.SetData(self.ChessNPC,CONST.对象_ENEMY_PetFlg+2,0);
  self:NPC_regWindowTalkedEvent(self.ChessNPC, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select == CONST.按钮_关闭 then
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
        --我方棋子组队
        local petbagIndex = tonumber(1);	--云库第1页前5隻宠
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
            Char.SetData(chessIndex, CONST.对象_类型, 1);		--CONST.对象类型_NPC
            Char.SetData(chessIndex, CONST.对象_职业, 481);		--超级职
            Char.SetData(chessIndex, CONST.对象_职类ID, 480);		--超级职
            Char.SetData(chessIndex, CONST.对象_职阶, 3);
            --skill_tbl[slot+1] = petbagPet.skills
            Char.SetTempData(chessIndex, '自走技能', JSON.encode(petbagPet.skills));

            if (chessIndex~=nil and slot==1) then
              local chess_leader_AIndex = chessIndex;
              local leader_name = petbagPet.attr[tostring(CONST.对象_名字)];
              print("隊長:"..leader_name)
              table.insert(leader_tbl,chess_leader_AIndex);

              local playercdk = Char.GetData(player,CONST.对象_CDK);
              Char.SetTempData(chess_leader_AIndex, '自走棋手', playercdk);
            elseif (chessIndex~=nil) then
              Char.JoinParty(chessIndex, leader_tbl[1], true);
            end
            chess_tbl[player]={};
            table.insert(chess_tbl[player],chessIndex);
          else
            print("["..slot.."]號位:空");
          end
        end
        --Char.Warp(leader_tbl[1], 0, 1000, 218, 89);

        --随机对手
        local petbagIndex = tonumber(1);	--云库第1页前5隻宠
        --local comIndex = "xman123456";
        --[[local partyNum = tonumber(SQL.Run("select COUNT(*) from hook_charaext where sKey='petbag-1-1'")["0_0"]);
        local rand = NLG.Rand(0,partyNum-1);]]

        local cdKey_tbl = {}
        local sKey_tbl = {}
        local val_tbl = {}
        local playercdk = Char.GetData(player,CONST.对象_CDK);
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
            Char.SetData(chessIndex, CONST.对象_类型, 1);		--CONST.对象类型_NPC
            Char.SetData(chessIndex, CONST.对象_职业, 481);		--超级职
            Char.SetData(chessIndex, CONST.对象_职类ID, 480);		--超级职
            Char.SetData(chessIndex, CONST.对象_职阶, 3);
            --skill_tbl[slot+10] = petbagPet.skills
            Char.SetTempData(chessIndex, '自走技能', JSON.encode(petbagPet.skills));

            if (chessIndex~=nil and slot==1) then
              local chess_leader_BIndex = chessIndex;
              local leader_name = petbagPet.attr[tostring(CONST.对象_名字)];
              print("隊長:"..leader_name)
              table.insert(leader_tbl,chess_leader_BIndex);
            elseif (chessIndex~=nil) then
              Char.JoinParty(chessIndex, leader_tbl[2], true);
            end
            chess_tbl[player]={};
            table.insert(chess_tbl[player],chessIndex);
          else
            print("["..slot.."]號位:空");
          end
        end
        --Char.Warp(leader_tbl[2], 0, 1000, 218, 87);

        --自走
        local battleIndex = Battle.PVP(leader_tbl[1],leader_tbl[2]);
        Battle.SetPVPWinEvent('./lua/Modules/petbag.lua', 'battle_wincallback', battleIndex);
        --观战
        NLG.WatchEntry(player, tonumber(leader_tbl[1]));
      elseif data==2 then
        if (chess_tbl[player]~=nil) then
          for k,v in ipairs(chess_tbl[player]) do
            Char.DelDummy(v);
          end
        end
        leader_tbl = {}
        skill_tbl = {}
        --我方棋子组队
        local petbagIndex = tonumber(1);	--云库第1页前5隻宠
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
            Char.SetData(chessIndex, CONST.对象_类型, 1);		--CONST.对象类型_NPC
            Char.SetData(chessIndex, CONST.对象_职业, 481);		--超级职
            Char.SetData(chessIndex, CONST.对象_职类ID, 480);		--超级职
            Char.SetData(chessIndex, CONST.对象_职阶, 3);
            --skill_tbl[slot+1] = petbagPet.skills
            Char.SetTempData(chessIndex, '自走技能', JSON.encode(petbagPet.skills));

            if (chessIndex~=nil and slot==1) then
              local chess_leader_AIndex = chessIndex;
              local leader_name = petbagPet.attr[tostring(CONST.对象_名字)];
              print("隊長:"..leader_name)
              table.insert(leader_tbl,chess_leader_AIndex);

              local playercdk = Char.GetData(player,CONST.对象_CDK);
              Char.SetTempData(chess_leader_AIndex, '自走棋手', playercdk);
            elseif (chessIndex~=nil) then
              Char.JoinParty(chessIndex, leader_tbl[1], true);
            end
            chess_tbl[player]={};
            table.insert(chess_tbl[player],chessIndex);
          else
            print("["..slot.."]號位:空");
          end
        end
        --Char.Warp(leader_tbl[1], 0, 1000, 218, 89);

        --随机对手
        local petbagIndex = tonumber(1);	--云库第1页前5隻宠
        --local comIndex = "xman123456";
        --[[local partyNum = tonumber(SQL.Run("select COUNT(*) from hook_charaext where sKey='petbag-1-1'")["0_0"]);
        local rand = NLG.Rand(0,partyNum-1);]]

        local cdKey_tbl = {}
        local sKey_tbl = {}
        local val_tbl = {}
        local playercdk = Char.GetData(player,CONST.对象_CDK);
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
            Char.SetData(chessIndex, CONST.对象_类型, 1);		--CONST.对象类型_NPC
            Char.SetData(chessIndex, CONST.对象_职业, 481);		--超级职
            Char.SetData(chessIndex, CONST.对象_职类ID, 480);		--超级职
            Char.SetData(chessIndex, CONST.对象_职阶, 3);
            --skill_tbl[slot+10] = petbagPet.skills
            Char.SetTempData(chessIndex, '自走技能', JSON.encode(petbagPet.skills));

            if (chessIndex~=nil and slot==1) then
              local chess_leader_BIndex = chessIndex;
              local leader_name = petbagPet.attr[tostring(CONST.对象_名字)];
              print("隊長:"..leader_name)
              table.insert(leader_tbl,chess_leader_BIndex);
            elseif (chessIndex~=nil) then
              Char.JoinParty(chessIndex, leader_tbl[2], true);
            end
            chess_tbl[player]={};
            table.insert(chess_tbl[player],chessIndex);
          else
            print("["..slot.."]號位:空");
          end
        end
        --Char.Warp(leader_tbl[2], 0, 1000, 218, 87);

        --自走
        local battleIndex = Battle.PVP(leader_tbl[1],leader_tbl[2]);
        Battle.SetPVPWinEvent('./lua/Modules/petbag.lua', 'battle_wincallback', battleIndex);
        --观战
        NLG.WatchEntry(player, tonumber(leader_tbl[1]));
      elseif data==3 then
        if (chess_tbl[player]~=nil) then
          for k,v in ipairs(chess_tbl[player]) do
            Char.DelDummy(v);
          end
        end
        leader_tbl = {}
        skill_tbl = {}
        --我方棋子组队
        local petbagIndex = tonumber(1);	--云库第1页前5隻宠
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
            Char.SetData(chess_tbl[player][slot], CONST.对象_类型,1);		--CONST.对象类型_人
            Char.SetData(chess_tbl[player][slot], CONST.对象_魅力,100);
            Char.SetData(chess_tbl[player][slot], CONST.对象_职业,115);		--馴獸大師
            Char.SetData(chess_tbl[player][slot], CONST.对象_职类ID,110);		--馴獸大師
            Char.SetData(chess_tbl[player][slot], CONST.对象_职阶,5);
            Char.AddSkill(chess_tbl[player][slot], 71); 
            Char.SetSkillLevel(chess_tbl[player][slot],0,10);
            NLG.UpChar(chess_tbl[player][slot]);
            --skill_tbl[slot+1] = petbagPet.skills
            Char.SetTempData(chess_tbl[player][slot], '自走技能', JSON.encode(petbagPet.skills));

            --第6~10宠
              local petbagIndex = tonumber(2);	--云库第2页前5隻宠
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
                Char.SetData(petIndex,CONST.宠物_忠诚,100);
                Pet.UpPet(chess_tbl[player][slot], petIndex);
                Char.SetPetDepartureState(chess_tbl[player][slot],0,CONST.PET_STATE_战斗);
                NLG.UpChar(chess_tbl[player][slot]);
              else
                --print("["..(slot+5).."]號位:空");
              end

            if (chess_tbl[player][slot]~=nil and slot==1) then
              local chess_leader_AIndex = chess_tbl[player][slot];
              local leader_name = petbagPet.attr[tostring(CONST.对象_名字)];
              print("隊長:"..leader_name)
              table.insert(leader_tbl,chess_leader_AIndex);

              local playercdk = Char.GetData(player,CONST.对象_CDK);
              Char.SetTempData(chess_leader_AIndex, '自走棋手', playercdk);
            elseif (chess_tbl[player][slot]~=nil) then
              Char.JoinParty(chess_tbl[player][slot], leader_tbl[1], true);
            end
            --table.insert(chess_tbl[player],chessIndex);
          else
            --print("["..slot.."]號位:空");
          end
        end
        --Char.Warp(leader_tbl[1], 0, 1000, 218, 89);

        --随机对手
        local petbagIndex = tonumber(1);	--云库第1页前5隻宠
        --local comIndex = "xman123456";
        --[[local partyNum = tonumber(SQL.Run("select COUNT(*) from hook_charaext where sKey='petbag-1-1'")["0_0"]);
        local rand = NLG.Rand(0,partyNum-1);]]

        local cdKey_tbl = {}
        local sKey_tbl = {}
        local val_tbl = {}
        local playercdk = Char.GetData(player,CONST.对象_CDK);
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
            Char.SetData(chess_tbl[player][slot+10], CONST.对象_类型,1);		--CONST.对象类型_人
            Char.SetData(chess_tbl[player][slot+10], CONST.对象_魅力,100);
            Char.SetData(chess_tbl[player][slot+10], CONST.对象_职业,115);		--馴獸大師
            Char.SetData(chess_tbl[player][slot+10], CONST.对象_职类ID,110);		--馴獸大師
            Char.SetData(chess_tbl[player][slot+10], CONST.对象_职阶,5);
            Char.AddSkill(chess_tbl[player][slot+10], 71); 
            Char.SetSkillLevel(chess_tbl[player][slot+10],0,10);
            NLG.UpChar(chess_tbl[player][slot+10]);
            --skill_tbl[slot+10] = petbagPet.skills
            Char.SetTempData(chess_tbl[player][slot+10], '自走技能', JSON.encode(petbagPet.skills));

            --第6~10宠
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
                Char.SetData(petIndex,CONST.宠物_忠诚,100);
                Pet.UpPet(chess_tbl[player][slot+10], petIndex);
                Char.SetPetDepartureState(chess_tbl[player][slot+10],0,CONST.PET_STATE_战斗);
                NLG.UpChar(chess_tbl[player][slot+10]);
              else
                --print("["..(slot+5).."]號位:空");
              end

            if (chess_tbl[player][slot+10]~=nil and slot==1) then
              local chess_leader_BIndex = chess_tbl[player][slot+10];
              local leader_name = petbagPet.attr[tostring(CONST.对象_名字)];
              print("隊長:"..leader_name)
              table.insert(leader_tbl,chess_leader_BIndex);
            elseif (chess_tbl[player][slot+10]~=nil) then
              Char.JoinParty(chess_tbl[player][slot+10], leader_tbl[2], true);
            end
            --table.insert(chess_tbl[player],chessIndex);
          else
            --print("["..slot.."]號位:空");
          end
        end
        --Char.Warp(leader_tbl[2], 0, 1000, 218, 87);

        --自走
        local battleIndex = Battle.PVP(leader_tbl[1],leader_tbl[2]);
        Battle.SetPVPWinEvent('./lua/Modules/petbag.lua', 'battle_wincallback', battleIndex);
        --观战
        NLG.WatchEntry(player, tonumber(leader_tbl[1]));
      elseif data==4 then
        if (NLG.CanTalk(npc, player) == true) then
          local cdKey_tbl = {}
          local val_tbl = {}
          local ret = SQL.Run("select cdKey,sKey,val from hook_charaext where sKey='自走积分' order by val desc ");
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

          local playerName = Char.GetData(player,CONST.对象_名字);
          local pts = Char.GetExtData(player, '自走积分') or 0;

          local msg = "@c【寵物自走棋對戰】\\n"
                   .. " 我的積分:      ".. playerName .. "      " .. pts .. " Pts\\n";

          for i=1,#cdKey_tbl do
            local charIndex = NLG.FindUser(cdKey_tbl[i]);
            --local charName = Char.GetData(charIndex,CONST.对象_名字);
            local charName = tostring(SQL.Run("select Name from tbl_character where cdKey='"..cdKey_tbl[i].."'")["0_0"]);
            local pts = val_tbl[i] or 0;

            --对齐格式
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

            msg = msg .. " 第"..i.."名  ".. charName .. name_spaceMsg .. pts .. " Pts\\n";
          end
          NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.按钮_关闭, 41, msg);
        end

      end
    end
  end)
  self:NPC_regTalkedEvent(self.ChessNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "3\\n@c【寵物自走棋對戰】\\n\\n\\n"
               .. " 對戰三人配對 " .. "\\n"
               .. " 對戰五人配對 " .. "\\n"
               .. " 對戰十人配對 " .. "\\n"
               .. " 積分排名查詢 " .. "\\n";
      NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.按钮_关闭, 1, msg);
    end
    return
  end)

end

function Module:handleBattleAutoCommand(battleIndex)
  local Round = Battle.GetTurn(battleIndex);
  local alive = 0;
  for slot = 0,19 do
    local npc = Battle.GetPlayer(battleIndex, slot);
    if (npc>0 and Char.GetData(npc, CONST.对象_战死) == 0) then
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
    -- 如果不是人，退出
    if dummyIndex < 0 then
      return
    end
    -- 如果不是假人，退出
    if not Char.IsDummy(dummyIndex) then
      return
    end

    -- 如果是佣兵 ，退出
    local heroesOnline=sgModule:getGlobal("heroesOnline")
    if heroesOnline[dummyIndex] then
      return
    end

    -- 如果不是在等待命令，退出
    local isWaiting = Battle.IsWaitingCommand(dummyIndex)
    if isWaiting ~=1 then
      return
    end

    if (Char.GetData(dummyIndex, CONST.对象_战死) == 1) then
      Battle.ActionSelect(dummyIndex, CONST.BATTLE_COM.BATTLE_COM_NONE, -1, 15002);
    end
    local side=0
    if e>9 then
      side=1
    end
    local sidetable = {{NLG.Rand(0,9),NLG.Rand(20,29),40},{NLG.Rand(10,19),NLG.Rand(30,39),41},{NLG.Rand(0,9),NLG.Rand(20,29),40},}
    --local charside = side+1;
    local charside = side+2;

    local skill_tbl = Char.GetTempData(dummyIndex, '自走技能') or nil;
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
    -- 第一个命令
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

    -- 获取其宠物
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
        local enemyBaseId = Data.EnemyGetData(EnemyDataIndex, CONST.Enemy_Base编号);
        local EnemyBaseDataIndex = Data.EnemyBaseGetDataIndex(enemyBaseId);
        local skillNum =Data.EnemyBaseGetData(EnemyBaseDataIndex, CONST.EnemyBase_技能栏);
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
    -- 如果不是人，退出
    if dummyIndex < 0 then
      return
    end
    -- 如果不是假人，退出
    if not Char.IsDummy(dummyIndex) then
      return
    end

    -- 如果是佣兵 ，退出
    local heroesOnline=sgModule:getGlobal("heroesOnline")
    if heroesOnline[dummyIndex] then
      return
    end

    if (e==0) then
      local playercdk = Char.GetTempData(dummyIndex, '自走棋手');
      local player = NLG.FindUser(playercdk);
      local pts = Char.GetExtData(player, '自走积分') or 0;
      Char.SetExtData(player, '自走积分', pts+1);
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


--目标信息
function pickupGoalInfo(player,petbagIndex,petNo)
      local petbagPet = Char.GetExtData(player, string.format("petbag-%d-%d", petbagIndex, petNo));
      pcall(function()
        if petbagPet then
          petbagPet = JSON.decode(petbagPet);
        end
      end)

      if type(petbagPet) == 'table' then
        local enemyId = petbagPet.attr[tostring(CONST.PET_PetID)];
        local Goal_name = petbagPet.attr[tostring(CONST.对象_名字)];
        local Goal_DataPos_3 = petbagPet.attr[tostring(CONST.对象_种族)];
        local Goal_DataPos_3 = Tribe(Goal_DataPos_3);
        local Goal_DataPos_5 = petbagPet.attr[tostring(CONST.对象_攻击力)];
        local Goal_DataPos_6 = petbagPet.attr[tostring(CONST.对象_防御力)];
        local Goal_DataPos_7 = petbagPet.attr[tostring(CONST.对象_敏捷)];
        local Goal_DataPos_8 = petbagPet.attr[tostring(CONST.对象_精神)];
        local Goal_DataPos_9 = petbagPet.attr[tostring(CONST.对象_回复)];

        local Goal_DataPos_12 = petbagPet.attr[tostring(CONST.对象_命中)];
        local Goal_DataPos_13 = petbagPet.attr[tostring(CONST.对象_必杀)];
        local Goal_DataPos_14 = petbagPet.attr[tostring(CONST.对象_地属性)];
        local Goal_DataPos_15 = petbagPet.attr[tostring(CONST.对象_水属性)];
        local Goal_DataPos_16 = petbagPet.attr[tostring(CONST.对象_火属性)];
        local Goal_DataPos_17 = petbagPet.attr[tostring(CONST.对象_风属性)];
        local Goal_DataPos_18 = petbagPet.attr[tostring(CONST.对象_抗毒)];
        local Goal_DataPos_19 = petbagPet.attr[tostring(CONST.对象_抗醉)];
        local Goal_DataPos_20 = petbagPet.attr[tostring(CONST.对象_抗睡)];
        local Goal_DataPos_21 = petbagPet.attr[tostring(CONST.对象_抗乱)];
        local Goal_DataPos_22 = petbagPet.attr[tostring(CONST.对象_抗石)];
        local Goal_DataPos_23 = petbagPet.attr[tostring(CONST.对象_抗忘)];
        local Goal_DataPos_26 = petbagPet.attr[tostring(CONST.对象_闪躲)];
        local Goal_DataPos_27 = petbagPet.attr[tostring(CONST.对象_反击)];
        local Goal_DataPos_28 = petbagPet.attr[tostring(CONST.对象_等级)];
        local Goal_DataPos_29 = petbagPet.attr[tostring(CONST.对象_原形)];
        local imageText = "@g,"..Goal_DataPos_29..",2,8,6,0@"

        msg = imageText .. "　　$4".. Goal_name .. "\\n"
                         .. "　　　　　　　" .. "$1攻擊 ".. Goal_DataPos_5 .."　" .. "$8必殺 ".. Goal_DataPos_13 .."　" .. "$8反擊 ".. Goal_DataPos_27 .."\\n"
                         .. "　　　　　　　" .. "$1防禦 ".. Goal_DataPos_6 .."　" .. "$8命中 ".. Goal_DataPos_12 .."　" .. "$8閃躲 ".. Goal_DataPos_26 .."\\n"
                         .. "　　　　　　　" .. "$1敏捷 ".. Goal_DataPos_7 .."　" .. "$2抗毒 ".. Goal_DataPos_18 .."　" .. "$2抗醉 ".. Goal_DataPos_19 .."\\n"
                         .. "　　　　　　　" .. "$1精神 ".. Goal_DataPos_8 .."　" .. "$2抗睡 ".. Goal_DataPos_20 .."　" .. "$2抗混 ".. Goal_DataPos_21 .."\\n"
                         .. "　　　　　　　" .. "$1恢復 ".. Goal_DataPos_9 .."　" .. "$2抗石 ".. Goal_DataPos_22 .."　" .. "$2抗忘 ".. Goal_DataPos_23 .."\\n"
                         .. "　　　　　　　" .. "$5地 ".. Goal_DataPos_14/10 .."　" .."$5水 ".. Goal_DataPos_15/10 .."　" .."$5火 ".. Goal_DataPos_16/10 .."　" .."$5風 ".. Goal_DataPos_17/10 .."\\n"
                         .. "　　　　　　　" .. "$9種族 ".. Goal_DataPos_3 .."　" .. "$9等級 ".. Goal_DataPos_28 .."\\n"
      else
        msg = "\\n\\n\\n\\n@c格庫出現錯誤"
      end
      return msg;
end

--种族字符串转换
function Tribe(Tribe)
  if Tribe==0 then
    return "人型系"
  elseif Tribe == 1 then
    return "龍族系"
  elseif Tribe == 2 then
    return "不死系"
  elseif Tribe == 3 then
    return "飛行系"
  elseif Tribe == 4 then
    return "昆蟲系"
  elseif Tribe == 5 then
    return "植物系"
  elseif Tribe == 6 then
    return "野獸系"
  elseif Tribe == 7 then
    return "特殊系"
  elseif Tribe == 8 then
    return "金屬系"
  elseif Tribe == 9 then
    return "邪魔系"
  elseif Tribe == 10 then
    return "神族系"
  elseif Tribe == 11 then
    return "精靈系"
  end
end

--------------------------------------------------------------------
-- NOTE 抽取宠物数据
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
  -- 宠物技能
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

  --宠物装备
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

-- NOTE 赋予宠物数据
function Module:insertPetData(petIndex,petData)
  -- 宠物属性
  for key, v in pairs(petFields) do
    if petData.attr[tostring(v)] ~=nil  then
      Char.SetData(petIndex, v,petData.attr[tostring(v)]);
    end
  end
  -- 忠诚
  -- Char.SetData(petIndex, 495,100);
  -- 宠物成长
  for key, v in pairs(petRankFields) do
    if petData.rank[tostring(v)] ~=nil then
      Pet.SetArtRank(petIndex, v,petData.rank[tostring(v)]);
    end
  end
  -- 宠物技能
  
  for i=0,9 do
    local tech_id = petData.skills[i+1]
    Pet.DelSkill(petIndex,i)
    if tech_id ~=nil then
      
      Pet.AddSkill(petIndex,tech_id)
    
    end
  end


end

-- NOTE 抽取 物品数据
function Module:extractItemData(itemIndex)
  local item = {};
  for _, v in pairs(itemFields) do
    item[tostring(v)] = Item.GetData(itemIndex, v);
  end
  return item;
end
--  NOTE 赋予 物品属性
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
    -- NOTE 己方血量占比最低
    local tagHp = nil;
    local returnSlot;
    for slot = chessSide + 0, chessSide + 9 do
      local charIndex = Battle.GetPlayer(battleIndex, slot)
      if (charIndex >= 0) then
        local hpRatio = Char.GetData(charIndex, CONST.对象_血) / Char.GetData(charIndex, CONST.对象_最大血)
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
      if charIndex >= 0 and Char.GetData(charIndex, CONST.对象_战死) == 1 then
        table.insert(slotTable, slot)
      end
    end
    local returnSlot = slotTable[NLG.Rand(1, #slotTable)]
    return returnSlot;
  else
    -- NOTE 血最少的
    local tagHp = nil;
    local returnSlot;
    for slot = chessSide + 0, chessSide + 9 do
      local charIndex = Battle.GetPlayer(battleIndex, slot)
      if (charIndex >= 0) then
        local hp = Char.GetData(charIndex, CONST.对象_血)
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

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
