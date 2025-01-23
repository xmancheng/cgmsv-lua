local module = ModuleBase:createModule('heroesFn')
local JSON=require "lua/Modules/json"
local _ = require "lua/Modules/underscore"
local sgModule = getModule("setterGetter")
local heroesTpl = dofile("lua/Modules/heroesTpl.lua")
local heroesAI = getModule("heroesAI");


function getEntryPositionBySlot(battleIndex, slot)
  local cIndex = Battle.GetPlayer(battleIndex, slot);
  if cIndex >=0 then
    local pos = Battle.GetPos(battleIndex, cIndex);
    return pos;
  else
    print('获取charIndex失败: ', cIndex);
    return -5;
  end
end


-- NOTE 雇佣时 佣兵同玩家同等级
local syncWithPlayer=true;
--NOTE 中文映射字典
local nameMap={
  status={
    ['1']='【出戰】',
    ['2']='【待命】'
  },
  equipLocation={
    [tostring(CONST.位置_头)]="「頭部」",
    [tostring(CONST.位置_身)]="「身體」",
    [tostring(CONST.位置_左手)]="「左手」",
    [tostring(CONST.位置_右手)]="「右手」",
    [tostring(CONST.位置_腿)]="「足部」",
    [tostring(CONST.位置_首饰1)]="「飾品1」",
    [tostring(CONST.位置_首饰2)]="「飾品2」",
    [tostring(CONST.位置_水晶)]="「水晶」",
  }
}
-- NOTE 出战选项
local heroOpList=function(status) return {nameMap['status'][tostring(status)],"備戰狀態","遣散"} end
-- NOTE 物品的所有属性key
local itemFields = { }
for i = 0, 0x4b do
  table.insert(itemFields, i);
end
for i = 0, 0xd do
  table.insert(itemFields, i + 2000);
end
-- NOTE 治疗价格 {min,max, 价格}
local healPrice={
  {1,20,200},{21,40,300},{41,60,400},{61,80,500},{81,100,600},{101,120,800},{121,140,1000},{141,160,1200},{161,180,1400},{181,200,1600},
}
-- NOTE 宠物的所有属性key
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
  CONST.对象_魔攻,
  CONST.对象_魔抗,
  CONST.对象_EnemyBaseId,
  CONST.PET_DepartureBattleStatus,
  CONST.PET_PetID,
  CONST.PET_技能栏,
  CONST.对象_魅力,
  CONST.对象_耐力,
  CONST.对象_灵巧,
  CONST.对象_智力,
  CONST.对象_魅力,
  CONST.对象_声望,
  CONST.对象_职业,
  CONST.对象_职阶,
  CONST.对象_职类ID,
  CONST.对象_名色,
}

-- NOTE 宠物成长属性key
local petRankFields={
  CONST.PET_体成,
  CONST.PET_力成,
  CONST.PET_强成,
  CONST.PET_敏成,
  CONST.PET_魔成,
}

-- NOTE 加点常量
local pointAttrs = {
  {CONST.对象_体力,"体力"},
  {CONST.对象_力量,"力量"},
  {CONST.对象_强度,"强度"},
  {CONST.对象_速度,"速度"},
  {CONST.对象_魔法,"魔法"},
}
-- NOTE 佣兵自动加点模式
-- local autoPointingPattern={'12010','21010','00022','10012','22000','10102','20011','20002'}
local autoPointingPattern={'12010','21010','00022','10012','22000','02020','20011','20002'}

-- NOTE 宠物自动加点模式
local petAutoPointingPattern={'10000','01000','00100','00010','00001'}

-- NOTE 名色常量
local nameColorRareMap={
  ["R"]=0,
  ["SR"]=1,
  ["SSR"]=2,
  ["UR"]=6,
}

--字体颜色：0=白，1=浅蓝，2=淡紫，3=深蓝，4=黄，5=浅绿，6=红，7=灰，8=蓝灰，9=灰绿，10=空，11=骨灰，12=泥色，

-- NOTE 新增-初始化佣兵
function module:initHeroData(toGetHeroData,charIndex)
  local tplId = toGetHeroData[1] or 1
  local name = toGetHeroData[2]
  local mainJob = toGetHeroData[4]
  local jobAncestry = toGetHeroData[5]
  local jobRank = toGetHeroData[6] 
  local image = toGetHeroData[7] or 100000
  local level = toGetHeroData[8] or 1
  local vital = toGetHeroData[9] or 0 
  local str = toGetHeroData[10] or 0 
  local tgh = toGetHeroData[11] or 0 
  local quick = toGetHeroData[12] or 0 
  local magic = toGetHeroData[13] or 0 
  local leveluppoint = toGetHeroData[14] or 0 
  local rare = toGetHeroData[15] or 'R' 
  local aiDatas = {} 
  self:deepcopy(aiDatas,toGetHeroData[18] or {})

  local petAiDatas = toGetHeroData[19] or {}
  local modValue = toGetHeroData[21] or {}

  if syncWithPlayer then
    local charLevel = Char.GetData(charIndex,CONST.对象_等级)
    local point=4*(charLevel-1);
    if rare =="SR" then
      -- 初始20 more 1
      point=20+((4 + 1)*(charLevel-1))
    elseif rare =="SSR" then
      -- 初始40 more 2
      point=40+((4+2)*(charLevel-1))
    elseif rare =="UR" then
      -- 初始80 more 4
      point=80+((4+4)*(charLevel-1))
    end
  end

  local charValue = {
    [tostring(CONST.对象_名字)]=name,
    [tostring(CONST.对象_形象)]=image,
    [tostring(CONST.对象_原形)]=image,
    [tostring(CONST.对象_原始图档)]=image,
    [tostring(CONST.对象_体力)]=vital*100,
    [tostring(CONST.对象_力量)]=str*100,
    [tostring(CONST.对象_强度)]=tgh*100,
    [tostring(CONST.对象_速度)]=quick*100,
    [tostring(CONST.对象_魔法)]=magic*100,
    [tostring(CONST.对象_等级)]=level,
    [tostring(CONST.对象_升级点)]=leveluppoint,
    [tostring(CONST.对象_职业)]=mainJob,
    [tostring(CONST.对象_职类ID)]=jobAncestry,
    [tostring(CONST.对象_职阶)]=jobRank,
    [tostring(CONST.对象_名色)]=nameColorRareMap[rare],
  }

  _.extend(charValue,modValue)
  
  return {
    id=string.formatNumber(os.time(), 36) .. string.formatNumber(math.random(1, 36 * 36 * 36), 36),
    tplId = tplId,
    name=name,
    trueName=name,
    attr=charValue,
    -- 1. 出战, 2. 待命
    status=2,
    index=nil,
    items={ },
    
    pets={ },
    -- petIndex=nil,
    -- ai slot
    skills=aiDatas,
    heroBattleTech=aiDatas[1],
    petSkills=petAiDatas,
    petBattleTech=petAiDatas[1],
    -- 是否获得了绑定宠物 （首次实例化佣兵时触发）
    petGranted=false,
    -- 是否获得了初始装备（首次实例化佣兵时触发）
    equipmentGranted=false,
    -- 佣兵自动加点模式
    autoPointing=nil,
    -- 是否开启佣兵自动加点
    isAutoPointing=1,
    -- 战宠自动加点模式
    petAutoPointing=nil,
    -- 是否开启战宠自动加点
    isPetAutoPointing=0,

  }
end

-- NOTE 查询数据库 heroes 数据
function module:queryHeroesData(charIndex)
  local cdKey = Char.GetData(charIndex, CONST.对象_CDK)
  local regNo = Char.GetData(charIndex, CONST.对象_RegistNumber)
  local sql="select value from des_heroes where cdkey= "..SQL.sqlValue(cdKey).." and regNo = "..SQL.sqlValue(regNo).." and is_deleted <> 1"
  local res,x =  SQL.QueryEx(sql)

  -- print(sql)
  -- print(res, x)
  local heroesData={};
  if res.rows then
    for i, row in ipairs(res.rows) do
      local value,pos = JSON.parse(row.value)
      -- print('heroesFn::250 >>', value, pos);
      table.insert(heroesData,value)
    end
  end

  return heroesData
end

-- NOTE 保存heroes数据
function module:saveHeroesData(charIndex, heroesData)
  local cdKey = Char.GetData(charIndex, CONST.对象_CDK)
  local regNo = Char.GetData(charIndex, CONST.对象_RegistNumber)
  
  if #heroesData == 0 then
    return;
  end
  local sqlValuesStr = _(heroesData):chain()
    :map(function(item) 
        return "("..SQL.sqlValue(item.id)..","
        ..SQL.sqlValue(cdKey)..","
        ..SQL.sqlValue(regNo)..","
        ..SQL.sqlValue(JSON.stringify(item))..")"
      end)
    :join(",")
    :value();
  local sql="replace into  des_heroes ( id,cdkey,regNo,value) values "..sqlValuesStr

  local r = SQL.querySQL(sql)
  print("保存数据",r)
end

-- NOTE 保存单个hero数据
function module:saveHeroData(charIndex,heroData)
  local cdKey = Char.GetData(charIndex, CONST.对象_CDK)
  local regNo = Char.GetData(charIndex, CONST.对象_RegistNumber)

  local sql="replace into  des_heroes ( id,cdkey,regNo,value) values ("
  ..SQL.sqlValue(heroData.id)..","
  ..SQL.sqlValue(cdKey)..","
  ..SQL.sqlValue(regNo)..","
  ..SQL.sqlValue(JSON.stringify(heroData))..")"
  -- print("保存单个hero数据",sql)
  local r = SQL.querySQL(sql)
  print("保存数据",r)
end

-- NOTE 根据 heroId 查询 heroData
function module:getHeroDataByid(charIndex,id)
    local heroesData = sgModule:get(charIndex,"heroes")
    local heroData = _.detect(heroesData, function(i) return i.id==id end)
    return heroData
end

-- NOTE 文字构建：酒馆首页
function module:buildRecruitSelection()
  local title = "★夥伴中心\\n"
  local items = {
    "邀請夥伴",
    "隊伍設置",
  }
  local windowStr = self:NPC_buildSelectionText(title,items);
  return windowStr
end

-- NOTE 文字构建:佣兵能力数值描述 
-- function module:buildAttrDescriptionForHero(heroData)
  
  -- local title= "     ".. self:getHeroName(heroData) .."\n";
  -- local windowStr = "等级:"..heroData['attr'][tostring(CONST.对象_等级)].."   升级点:"..heroData['attr'][tostring(CONST.对象_升级点)]
    -- .."\n体力:"..(heroData['attr'][tostring(CONST.对象_体力)]/100).."  力量:"..(heroData['attr'][tostring(CONST.对象_力量)]/100)
    -- .." 强度:"..(heroData['attr'][tostring(CONST.对象_强度)]/100).."  速度:"..(heroData['attr'][tostring(CONST.对象_速度)]/100)
    -- .." 魔法:"..(heroData['attr'][tostring(CONST.对象_魔法)]/100)
    -- .."\n战斗状态:"..nameMap["status"][tostring(heroData.status)]
  -- return title..windowStr
-- end

-- NOTE 获取佣兵名字, 当佣兵已出战(有index)时, 通过Char.GetData获取名字, 否则, 获取佣兵原始名字
function module:getHeroName(heroData)
  local heroIndex = heroData.index;
  if heroIndex and heroIndex > 0 then
    local heroName = Char.GetData(heroIndex, CONST.对象_名字)
    return heroName
  else
    return heroData['name']
  end
  return nil
end

function module:buildAttrDescriptionForHero(heroData)
  local title= "" .. self:getHeroName(heroData) .."\n\n";
  local windowStr = "戰鬥狀態:"..nameMap["status"][tostring(heroData.status)]
    .. "\n\n等級:"..heroData['attr'][tostring(CONST.对象_等级)]
    .."\n\n未加點數:"..heroData['attr'][tostring(CONST.对象_升级点)]
	  -- .."\n\n攻击力:"..heroData['attr'][tostring(CONST.对象_攻击力)]
	  -- .."\n防御力:"..heroData['attr'][tostring(CONST.对象_防御力)]
	  -- .."\n敏捷:"..heroData['attr'][tostring(CONST.对象_敏捷)]
	  -- .."\n精神:"..heroData['attr'][tostring(CONST.对象_精神)]
	  -- .."\n回复:"..heroData['attr'][tostring(CONST.对象_回复)]
	  -- .."\n\n必杀:"..heroData['attr'][tostring(CONST.对象_必杀)].."反击:"..heroData['attr'][tostring(CONST.对象_反击)]
	  -- .."\n命中:"..heroData['attr'][tostring(CONST.对象_命中)].."闪躲:"..heroData['attr'][tostring(CONST.对象_闪躲)]
	  -- .."\n\n抗中毒:"..heroData['attr'][tostring(CONST.对象_抗毒)].."抗昏睡:"..heroData['attr'][tostring(CONST.对象_抗睡)].."抗石化:"..heroData['attr'][tostring(CONST.对象_抗石)]
	  -- .."\n抗酒醉:"..heroData['attr'][tostring(CONST.对象_抗醉)].."抗混乱:"..heroData['attr'][tostring(CONST.对象_抗乱)].."抗遗忘:"..heroData['attr'][tostring(CONST.对象_抗忘)]
	  -- .."\n\n地:"..heroData['attr'][tostring(CONST.对象_地属性)].."水:"..heroData['attr'][tostring(CONST.对象_水属性)].."火:"..heroData['attr'][tostring(CONST.对象_火属性)].."风:"..heroData['attr'][tostring(CONST.对象_风属性)]

  return title..windowStr
end




-- NOTE 文字构建:出战佣兵状态描述 
function module:buildDescriptionForCampHero(heroData,page)
  local heroIndex = heroData.index;
  local name = Char.GetData(heroIndex,CONST.对象_名字)
  local level = Char.GetData(heroIndex,CONST.对象_等级)
  local leveluppoint = Char.GetData(heroIndex,CONST.对象_升级点)
  local vital = Char.GetData(heroIndex,CONST.对象_体力)/100
  local str = Char.GetData(heroIndex,CONST.对象_力量)/100
  local tgh = Char.GetData(heroIndex,CONST.对象_强度)/100
  local quick = Char.GetData(heroIndex,CONST.对象_速度)/100
  local magic = Char.GetData(heroIndex,CONST.对象_魔法)/100
  local Tribe = Char.GetData(heroIndex,CONST.对象_种族)
  local att = Char.GetData(heroIndex,CONST.对象_攻击力)
  local def = Char.GetData(heroIndex,CONST.对象_防御力)
  local agl = Char.GetData(heroIndex,CONST.对象_敏捷)
  local spr = Char.GetData(heroIndex,CONST.对象_精神)
  local rec = Char.GetData(heroIndex,CONST.对象_回复)
  local exp = Char.GetData(heroIndex,CONST.对象_经验)
  local hp = Char.GetData(heroIndex,CONST.对象_血)
  local mp = Char.GetData(heroIndex,CONST.对象_魔)
  local maxhp = Char.GetData(heroIndex,CONST.对象_最大血)
  local maxmp = Char.GetData(heroIndex,CONST.对象_最大魔)
  local Attrib_Earth = Char.GetData(heroIndex,CONST.对象_地属性)
  local Attrib_Water = Char.GetData(heroIndex,CONST.对象_水属性)
  local Attrib_Fire = Char.GetData(heroIndex,CONST.对象_火属性)
  local Attrib_Wind = Char.GetData(heroIndex,CONST.对象_风属性)
  local critical = Char.GetData(heroIndex,CONST.对象_必杀)
  local counter = Char.GetData(heroIndex,CONST.对象_反击)
  local hitrate = Char.GetData(heroIndex,CONST.对象_命中)
  local avoid = Char.GetData(heroIndex,CONST.对象_闪躲)
  local poison = Char.GetData(heroIndex,CONST.对象_抗毒)
  local sleep = Char.GetData(heroIndex,CONST.对象_抗睡)
  local stone = Char.GetData(heroIndex,CONST.对象_抗石)
  local drunk = Char.GetData(heroIndex,CONST.对象_抗醉)
  local confused = Char.GetData(heroIndex,CONST.对象_抗乱)
  local insomnia = Char.GetData(heroIndex,CONST.对象_抗忘)
  local injured = Char.GetData(heroIndex,CONST.对象_受伤)
  local soulLost = Char.GetData(heroIndex,CONST.对象_掉魂)
  local charm = Char.GetData(heroIndex,CONST.对象_魅力)
  -- 背包内容
  local bagItems = self:buildCampHeroItem(nil,heroData)
  
  local bagItemsStr = _(bagItems):chain():join("   "):value();
  local title= "".. self:getHeroName(heroData) .."\n";
  local windowStr="";

  local feverTime = Char.GetData(heroIndex, CONST.对象_卡时)
  -- 总修正计算

  for slot=0,7 do
    local itemIndex = Char.GetItemIndex(heroIndex,slot)
    if itemIndex>=0 then
      critical = critical+ (Item.GetData(itemIndex,CONST.道具_必杀) or 0)
      
      counter =counter+ (Item.GetData(itemIndex,CONST.道具_反击) or 0)
      hitrate =  hitrate +  (Item.GetData(itemIndex,CONST.道具_命中) or 0)
      avoid = avoid +  (Item.GetData(itemIndex,CONST.道具_闪躲) or 0)
      poison = poison +  (Item.GetData(itemIndex,CONST.道具_毒抗) or 0)
      sleep = sleep +  (Item.GetData(itemIndex,CONST.道具_睡抗) or 0)
      stone = stone +  (Item.GetData(itemIndex,CONST.道具_石抗) or 0)
      drunk = drunk +  (Item.GetData(itemIndex,CONST.道具_醉抗) or 0)
      confused =confused +  (Item.GetData(itemIndex,CONST.道具_乱抗) or 0)
      insomnia =insomnia +  (Item.GetData(itemIndex,CONST.道具_忘抗) or 0)
    end
  end

  if page == 1 then
    windowStr = "\n等級:"..level.."    未加點數:"..leveluppoint.."    種族:"..self:Tribe(Tribe)
    .."\n\n生命: "..hp.."/"..maxhp.." 魔力："..mp.."/"..maxmp
    .."\n\n體力:"..vital.."  力量:"..str
    .." 強度:"..tgh.."  速度:"..quick
    .." 魔法:"..magic
    .."\n\n攻擊："..att.." 防禦："..def.." 敏捷："..agl.." 精神："..spr.." 回復："..rec
    .."\n\n地："..Attrib_Earth.."  水:"..Attrib_Water.."  火："..Attrib_Fire.."  風："..Attrib_Wind
    ..'\n\n健康:'..self:healthColor(injured)..''.."  掉魂："..soulLost.."  魅力:"..charm
    .."\n\n必殺："..critical.." 命中："..hitrate.." 反擊："..counter.." 閃躲："..avoid
    .."\n\n抗毒："..poison.." 抗昏睡："..sleep.." 抗石化："..stone
    .."\n\n抗醉："..drunk.." 抗混亂："..confused .." 抗遺忘："..insomnia
    .."\n\n卡時(打卡後同步)："..feverTime.."  經驗："..exp
  else
    windowStr="\n物品:"
    .."\n\n"..bagItemsStr
  end

  return title..windowStr
end

-- NOTE 文字构建：队伍状态描述
function module:buildDescriptionForParty(charIndex)
  local campHeroes=self:getCampHeroesData(charIndex)
  return _(campHeroes):chain():map(function(heroData) 
    local len2=6
    local heroIndex = heroData.index;
    local name = Char.GetData(heroIndex,CONST.对象_名字)
    local level = self:strFill(Char.GetData(heroIndex,CONST.对象_等级),len2,' ')
    local leveluppoint = Char.GetData(heroIndex,CONST.对象_升级点)
    
    local vital = self:strFill(Char.GetData(heroIndex,CONST.对象_体力)/100,len2,' ')
    local str = self:strFill(Char.GetData(heroIndex,CONST.对象_力量)/100,len2,' ')
    local tgh = self:strFill(Char.GetData(heroIndex,CONST.对象_强度)/100,len2,' ')
    local quick = self:strFill(Char.GetData(heroIndex,CONST.对象_速度)/100,len2,' ')
    local magic = self:strFill(Char.GetData(heroIndex,CONST.对象_魔法)/100,len2,' ')
    local Tribe = Char.GetData(heroIndex,CONST.对象_种族)

    local att = self:strFill(Char.GetData(heroIndex,CONST.对象_攻击力),len2,' ')
    local def = self:strFill(Char.GetData(heroIndex,CONST.对象_防御力),len2,' ')
    local agl = self:strFill(Char.GetData(heroIndex,CONST.对象_敏捷),len2,' ')
    local spr = self:strFill(Char.GetData(heroIndex,CONST.对象_精神),len2,' ')
    local rec = self:strFill(Char.GetData(heroIndex,CONST.对象_回复),len2,' ')
    local exp = self:strFill(Char.GetData(heroIndex,CONST.对象_经验),len2,' ')
    local hp = Char.GetData(heroIndex,CONST.对象_血)
    local mp = Char.GetData(heroIndex,CONST.对象_魔)
    local maxhp = Char.GetData(heroIndex,CONST.对象_最大血)
    local maxmp = Char.GetData(heroIndex,CONST.对象_最大魔)

    local injured = Char.GetData(heroIndex,CONST.对象_受伤)
    local soulLost = Char.GetData(heroIndex,CONST.对象_掉魂)
    local jobId = Char.GetData(heroIndex,CONST.对象_职业)
    --local jobName = getModule("gmsvData").jobs[tostring(jobId)][1]
    local jobName = heroTplData[3];
    local windowStr = "".. self:strFill(self:getHeroName(heroData), 16, ' ')..jobName..  "等級:"..level.."  未加點數:"..leveluppoint
      .."\n生命:"..hp.."/"..maxhp.." 魔力:"..mp.."/"..maxmp
      .."\n体力:"..vital.."力量:"..str
      .."强度:"..tgh.."速度:"..quick
      .."魔法:"..magic
      .."\n攻击:"..att.."防御:"..def.."敏捷:"..agl.."精神:"..spr.."回复:"..rec

      ..'\n健康:'..self:healthColor(injured)..''.."  掉魂:"..soulLost.."     經驗:"..exp
    return windowStr
  end):join("\n\n"):value()

end

-- NOTE 文字构建:宠物状态描述 
function module:buildDescriptionForPet(heroData,petIndex,page)
  local name = Char.GetData(petIndex,CONST.对象_名字)
  local level = Char.GetData(petIndex,CONST.对象_等级)
  local leveluppoint = Char.GetData(petIndex,CONST.对象_升级点)
  local vital =math.floor(Char.GetData(petIndex,CONST.对象_体力)/100) 
  local str = math.floor(Char.GetData(petIndex,CONST.对象_力量)/100)
  local tgh = math.floor(Char.GetData(petIndex,CONST.对象_强度)/100)
  local quick = math.floor(Char.GetData(petIndex,CONST.对象_速度)/100)
  local magic = math.floor(Char.GetData(petIndex,CONST.对象_魔法)/100)
  local Tribe = Char.GetData(petIndex,CONST.对象_种族)
  local att = Char.GetData(petIndex,CONST.对象_攻击力)
  local def = Char.GetData(petIndex,CONST.对象_防御力)
  local agl = Char.GetData(petIndex,CONST.对象_敏捷)
  local spr = Char.GetData(petIndex,CONST.对象_精神)
  local rec = Char.GetData(petIndex,CONST.对象_回复)
  local exp = Char.GetData(petIndex,CONST.对象_经验) or 0;
  local hp = Char.GetData(petIndex,CONST.对象_血)
  local mp = Char.GetData(petIndex,CONST.对象_魔)
  local maxhp = Char.GetData(petIndex,CONST.对象_最大血)
  local maxmp = Char.GetData(petIndex,CONST.对象_最大魔)
  local Attrib_Earth = Char.GetData(petIndex,CONST.对象_地属性)
  local Attrib_Water = Char.GetData(petIndex,CONST.对象_水属性)
  local Attrib_Fire = Char.GetData(petIndex,CONST.对象_火属性)
  local Attrib_Wind = Char.GetData(petIndex,CONST.对象_风属性)
  local critical = Char.GetData(petIndex,CONST.对象_必杀)
  local counter = Char.GetData(petIndex,CONST.对象_反击)
  local hitrate = Char.GetData(petIndex,CONST.对象_命中)
  local avoid = Char.GetData(petIndex,CONST.对象_闪躲)
  local poison = Char.GetData(petIndex,CONST.对象_抗毒)
  local sleep = Char.GetData(petIndex,CONST.对象_抗睡)
  local stone = Char.GetData(petIndex,CONST.对象_抗石)
  local drunk = Char.GetData(petIndex,CONST.对象_抗醉)
  local confused = Char.GetData(petIndex,CONST.对象_抗乱)
  local insomnia = Char.GetData(petIndex,CONST.对象_抗忘)
  local injured = Char.GetData(petIndex,CONST.对象_受伤)
  local soulLost = Char.GetData(petIndex,CONST.对象_掉魂)
  local loyalty = Char.GetData(petIndex,495)
  local title= ""..name.."\n";
  local windowStr="";
  if page == 1 then
    windowStr = "\n等級:"..level.."    升級點:"..leveluppoint.."    種族:"..self:Tribe(Tribe)
    .."\n\n生命: "..hp.."/"..maxhp.." 魔力："..mp.."/"..maxmp
    .."\n\n體力:"..vital.."  力量:"..str
    .." 強度:"..tgh.."  速度:"..quick
    .." 魔法:"..magic
    .."\n\n攻擊："..att.." 防禦："..def.." 敏捷："..agl.." 精神："..spr.." 回復："..rec
    .."\n\n地："..Attrib_Earth.."  水:"..Attrib_Water.."  火："..Attrib_Fire.."  風："..Attrib_Wind
    .."\n\n健康:"..self:healthColor(injured).."  經驗："..exp
  else
    windowStr = "\n必殺："..critical.." 反擊："..counter.." 命中："..hitrate.." 閃躲："..avoid
    .."\n\n抗毒："..poison.." 抗睡："..sleep.." 抗石："..stone
    .."\n\n抗醉："..drunk.." 抗亂："..confused .." 抗忘："..insomnia
    .."\n\n忠诚："..loyalty
  end

  return title..windowStr
end

-- NOTE 文字构建 : 佣兵列表
function module:buildListForHero(heroData)
  local heroTplId = heroData.tplId
  local heroTplData = _.detect(heroesTpl,function(tpl) return tpl[1]==heroTplId end)

  -- 获取 job 
  local jobId = heroData.attr[tostring(CONST.对象_职业)]
  local jobs = getModule("gmsvData").jobs;
  -- print(jobId, '>>>', jobs[tostring(jobId)][1], #jobs )
  --local jobName = getModule("gmsvData").jobs[tostring(jobId)][1]
  local jobName = heroTplData[3];

  -- 获取等级
  local level = heroData.attr[tostring(CONST.对象_等级)]

  -- local title="    【"..heroTplData[15].."】  ".. self:getHeroName(heroData) .."  职业:"..jobName
  return ""..heroTplData[15].."  ".. self:getHeroName(heroData) .."  "..jobName.."Lv"..level.." "..nameMap["status"][tostring(heroData.status)]
end

-- NOTE 文字构建: 佣兵操作 面板
function module:buildOperatorForHero(heroData)
  local name ="     ".. self:getHeroName(heroData) .."\\n";
  local toBeActStatus = heroData.status == 1 and 2 or 1
  local items = heroOpList(toBeActStatus)
  return self:NPC_buildSelectionText(name,items);
end

-- NOTE  创建假人-佣兵
function module:generateHeroDummy(charIndex,heroData)
  
  local heroIndex = Char.CreateDummy()
  self:logInfo("index:",heroIndex,heroData.id)
  local heroesOnline = sgModule:getGlobal("heroesOnline")
  if heroesOnline == nil then
    heroesOnline={}
    sgModule:setGlobal("heroesOnline",heroesOnline)
  end
  heroesOnline[heroIndex]=heroData;
  heroData.index = heroIndex
  heroData.owner = charIndex
  -- 新字段 兼容，赋予默认值
  heroData.isAutoPointing=heroData.isAutoPointing or 0 
  heroData.isPetAutoPointing=heroData.isPetAutoPointing or 0 


  for key, v in pairs(petFields) do

    if heroData.attr[tostring(v)] ~=nil then
      
      Char.SetData(heroIndex, v,heroData.attr[tostring(v)]);
    end
  end

  local mapType = Char.GetData(charIndex, CONST.对象_地图类型);
  local targetX = 0;
  local targetY = 0;
  local targetMapId = 0;

  targetX = Char.GetData(charIndex,CONST.对象_X);
  targetY = Char.GetData(charIndex,CONST.对象_Y);
  targetMapId = Char.GetData(charIndex,CONST.对象_地图);

  Char.SetData(heroIndex, CONST.对象_X, targetX);
  Char.SetData(heroIndex, CONST.对象_Y, targetY);
  Char.SetData(heroIndex, CONST.对象_地图, targetMapId);
  Char.SetData(heroIndex, CONST.对象_地图类型, mapType);
  
  -- 首次创建，给初始值
  local c = Char.SetData(heroIndex, CONST.对象_血, Char.GetData(heroIndex, CONST.对象_最大血));
  c = Char.SetData(heroIndex, CONST.对象_魔, Char.GetData(heroIndex, CONST.对象_最大魔));
  c = heroData.attr[tostring(CONST.对象_魅力)] == nil and Char.SetData(heroIndex, CONST.对象_魅力, 100) or Char.SetData(heroIndex, CONST.对象_魅力, heroData.attr[tostring(CONST.对象_魅力)]);

  -- 调教
  Char.AddSkill(heroIndex, 71); 
  Char.SetSkillLevel(heroIndex,0,10);
  NLG.UpChar(heroIndex);

  local heroTplId = heroData.tplId
  local heroTplData = _.detect(heroesTpl,function(tpl) return tpl[1]==heroTplId end)
  if heroTplData== nil then
    NLG.SystemMessage(dummyIndex,"存在未知夥伴。")
  end

  -- 道具赋予
  if not heroData.equipmentGranted then
    -- 初始化装备给予
    if heroTplData[23]~=nil and type(heroTplData[23])=='table' then
      local itemTable = heroTplData[23]
      for i = 1,8 do
        local slot = i-1
        local itemId = itemTable[i]
        if itemId ==nil then
          goto continue
        end
        local itemIndex = Char.GiveItem(heroIndex, itemId, 1, false);

        if itemIndex >= 0 then
          Item.SetData( itemIndex , CONST.道具_已鉴定 ,1)
          local addSlot = Char.GetItemSlot(heroIndex, itemIndex)
          
          if addSlot ~= slot then
            
            Char.MoveItem(heroIndex, addSlot, slot, -1)
          end
          
        end
        ::continue::
      end
      
    end
    heroData.equipmentGranted=true
  else
    for i,ItemData in pairs(heroData.items or {}) do
    
      local slot = tonumber(i)
      
      local itemId = ItemData[tostring(CONST.道具_ID)]
      
      local itemIndex = Char.GiveItem(heroIndex, itemId, 1, false);
      
      if itemIndex >= 0 then
        self:insertItemData(itemIndex,ItemData)
        local addSlot = Char.GetItemSlot(heroIndex, itemIndex)
        
        if addSlot ~= slot then
          
          Char.MoveItem(heroIndex, addSlot, slot, -1)

        end
        
      end
  
    end
  end

  Item.UpItem(heroIndex,-1)
  -- 创建 宠物
  
  if not heroData.petGranted then
    -- 进行初始化宠物赋予

    if heroTplData[22]~=nil and type(heroTplData[22])=='table' then
      local enemyId = heroTplData[22][1]

      _.each(heroTplData[22],function(enemyId) 
        if enemyId ~=nil then
          petIndex = Char.AddPet(heroIndex, enemyId);

          Pet.UpPet(heroIndex,petIndex);
        end
      end)
    end
    Char.SetPetDepartureState(heroIndex, 0,CONST.PET_STATE_战斗)
    heroData.petGranted=true
  else
    local petsData=heroData.pets or {}
    local tempSlot = {}
    for slot = 0,4 do
      local petData = petsData[tostring(slot)]
      local petIndex;
      if petData ~= nil then
            -- 根据petid 获取 enemyId
        local petId = petData.attr[tostring(CONST.PET_PetID)]
        --local enemyId = getModule("gmsvData").enemy[tostring(petId)]?    --local enemyId = getModule("gmsvData").enmeyBase2enemy[tostring(petId)]?
        local enemyId = petId;
        if enemyId ~=nil then
          enemyId = tonumber(enemyId)
          petIndex = Char.AddPet(heroIndex, enemyId);
          
          self:insertPetData(petIndex,petData)
          -- 宠物出战状态设置
          if petData.attr[tostring(CONST.PET_DepartureBattleStatus)] ~=nil then
            
            Char.SetPetDepartureState(heroIndex, slot,petData.attr[tostring(CONST.PET_DepartureBattleStatus)])
          end
  
        end
      else
        petIndex =Char.AddPet(heroIndex, 1);
        table.insert(tempSlot,slot)
      end
      Pet.UpPet(heroIndex,petIndex);
    end
    -- 删除 占位的宠物
    _.each(tempSlot,function(slot) 
      Char.DelSlotPet(heroIndex, slot)
    end)
  end

  Char.JoinParty(heroIndex, charIndex, true);
  
end

-- NOTE 删除假人 -佣兵
function module:delHeroDummy(charIndex,heroData)
  if not heroData.index then
    return;
  end
  -- self:saveHeroData(charIndex,heroData)
  local heroesOnline = sgModule:getGlobal("heroesOnline")
  heroesOnline[heroData.index]=nil;
  Char.DelDummy(heroData.index)
  heroData.index=nil;
end

-- NOTE 文字构建：佣兵管理首页
function module:buildManagementForHero(charIndex)
  local title="★隊伍管理"
  local items={
    "  全隊打卡",
    "  關閉打卡",
    "  治療隊伍",
    "  夥伴管理",
    "  夥伴一覽",
    "  夥伴歸隊",
    "  夥伴隊伍",
  }

  return self:NPC_buildSelectionText(title,items);
end

-- NOTE 获取出战佣兵 数据
function module:getCampHeroesData(charIndex)
  local heroesData = sgModule:get(charIndex,"heroes") or {}
  
  return _.select(heroesData,function(item) return item.status==1 end)
end

--  NOTE 文字构建： 出战佣兵列表
function module:buildCampHeroesList(charIndex)
  local campHeroes = self:getCampHeroesData(charIndex)
  local title = "★出戰中的夥伴："
  local items=_.map(campHeroes,function(item)
    return self:getHeroName(item) 
  end)
  return self:NPC_buildSelectionText(title,items);
end

-- NOTE 文字构建： 出战佣兵操作
function module:buildCampHeroOperator(charIndex,heroData)
  local heroIndex = heroData.index;
  local name = self:getHeroName(heroData)
  -- 获取 job 
  local jobId = Char.GetData(heroIndex,CONST.对象_职业)
  --local jobName = getModule("gmsvData").jobs[tostring(jobId)][1]
  local jobName = heroTplData[3];
  -- 获取说明
  local heroTplId = heroData.tplId
  local heroTplData = _.detect(heroesTpl,function(tpl) return tpl[1]==heroTplId end)

  local title="【"..name.."】    「"..heroTplData[15].."」級 :"..jobName

  local aiId1 = heroData.heroBattleTech or -1
  local aiData1 = _.detect(getModule("heroesAI").aiData,function(data) return data.id==aiId1 end)
  local name1=aiData1~=nil and aiData1.name or "未設定"

  local aiId2 = heroData.petBattleTech or -1
  local aiData2 = _.detect(getModule("heroesAI").aiData,function(data) return data.id==aiId2 end)
  local name2=aiData2~=nil and aiData2.name or "未設定"

  local items={
    "夥伴狀態",
    "寵物狀態",
    --"水晶選擇",
    --"交換物品",
    --"刪除物品",
    "加點設置",
    "夥伴AI設置".."【"..name1.."】",
    "寵物AI設置".."【"..name2.."】",
    --"夥伴改名",
    --"更換形象"
  }

  return self:NPC_buildSelectionText(title,items);
end

-- NOTE 文字构建：出战佣兵道具浏览 
function module:buildCampHeroItem(charIndex,heroData)
  local heroIndex = heroData.index
  local items={}
  for i = 0, 27 do
    local itemIndex = Char.GetItemIndex(heroIndex, i)
    local pre=""
    if i<=7 then
      pre=""..nameMap['equipLocation'][tostring(i)]..":"
    else
      pre=""
    end
    if itemIndex >= 0 then
      table.insert(items,pre..Item.GetData(itemIndex, CONST.道具_名字))

    else
      table.insert(items,pre.."無物品")
    end
  end
  
  return items
end

-- NOTE 文字构建：玩家背包浏览
function module:buildPlayerItem(charIndex)
  
  local items={}
  for i = 8, 27 do
    local itemIndex = Char.GetItemIndex(charIndex, i)
    local pre=""
    if i<=7 then
      pre=nameMap['equipLocation'][tostring(i)]..":"
    end
    if itemIndex >= 0 then
      table.insert(items,pre..Item.GetData(itemIndex, CONST.道具_名字))

    else
      table.insert(items,pre.."無物品")
    end
  end
  return items
end

-- NOTE 抽取 物品数据
function module:extractItemData(itemIndex)
  local item = {};
  for _, v in pairs(itemFields) do
    item[tostring(v)] = Item.GetData(itemIndex, v);
  end
  return item;
end
--  NOTE 赋予 物品属性
function  module:insertItemData(itemIndex,itemData)
  for _, field in pairs(itemFields) do
    local r = 0;
    if type(itemData[tostring(field)]) ~= 'nil' then
      r = Item.SetData(itemIndex, field, itemData[tostring(field)]);
    end
  end
end

-- NOTE 缓存物品数据
function module:cacheHeroItemData(heroData)
  local heroIndex = heroData.index
  heroData.items={}
  for slot =0,27 do
    local itemIndex = Char.GetItemIndex(heroIndex,slot);
    if itemIndex>=0 then
      local data = self:extractItemData(itemIndex)
      heroData.items[tostring(slot)]=data;
    end
  end
end

-- NOTE 缓存宠物数据
function module:cacheHeroPetsData(heroData)
  local heroIndex = heroData.index
  heroData.pets={}
  for slot = 0,4 do
    local petIndex = Char.GetPet(heroIndex,slot)
    
    if petIndex>=0 then
      local data = self:extractPetData(petIndex)
      heroData.pets[tostring(slot)]=data;
    end
  end
end

-- NOTE 缓存佣兵数据
function module:cacheHeroAttrData(heroData)
  local heroIndex= heroData.index;
  local item={}
  -- 用宠物的key？ 勉强用一下
  for _, v in pairs(petFields) do
    item[tostring(v)] = Char.GetData(heroIndex, v);
    
  end
  heroData.attr=item
end

-- NOTE 抽取宠物数据
function module:extractPetData(petIndex)
  local item = {
    attr={},
    rank={},
    skills={}
  };
  for _, v in pairs(petFields) do
    item.attr[tostring(v)] = Char.GetData(petIndex, v);
    
  end
  for _, v in pairs(petRankFields) do
    item.rank[tostring(v)] = Pet.GetArtRank(petIndex,v);
    
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
  item.skills=skillTable
  return item;
end

-- NOTE 赋予宠物数据
function module:insertPetData(petIndex,petData)
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

-- NOTE 文字构建：佣兵宠物浏览
function module:buildCampHeroPets(heroData)
  local heroIndex = heroData.index;
  local items={}
  for i=0,4 do
    local petIndex = Char.GetPet(heroIndex, i)
    if petIndex>=0 then
      local status =  Char.GetData(petIndex, CONST.PET_DepartureBattleStatus);
      local suffix=""
      if status ==  CONST.PET_STATE_战斗 then
        suffix=" 【出戰】"
      end
      table.insert(items,Char.GetData(petIndex,CONST.对象_名字)..suffix)
    else
      table.insert(items,"空")
    end
  end
  local title="請選擇寵物"
  return self:NPC_buildSelectionText(title,items);
end

-- NOTE 文字构建：佣兵宠物命令
function module:buildCampHeroPetOperator(charIndex,heroData)
  local heroIndex = heroData.index;
  local petSlot = sgModule:get(charIndex,"heroPetSlotSelected");
  local petIndex= Char.GetPet(heroIndex,petSlot)
  local items={}
  table.insert(items,"寵物交換")
  if petIndex>=0 then
    
    if (Char.GetData(petIndex, CONST.PET_DepartureBattleStatus) == CONST.PET_STATE_战斗) then
      table.insert(items,"寵物待命")
      
    else
      table.insert(items,"寵物出戰")
      
    end
    table.insert(items,"寵物狀態")
    -- table.insert(items,"设置战斗技能")
  else
    table.insert(items,"")
    table.insert(items,"")
  end
  
  
  local title="請選擇指令："
  return self:NPC_buildSelectionText(title,items);
end

-- NOTE 文字构建：玩家宠物浏览
function module:buildPlayerPets(charIndex)
  local items={}
  for i=0,4 do
    local petIndex = Char.GetPet(charIndex, i)
    if petIndex>=0 then
      table.insert(items,Char.GetData(petIndex,CONST.对象_名字))
    else
      table.insert(items,"空")
    end
  end
  local title="請選擇交給夥伴的寵物"
  return self:NPC_buildSelectionText(title,items);
end

-- NOTE  随机目标 
-- side 0 是下方， 1 是上方
-- range: 0:single,1: range ,2: all
function module:randomTarget(side,battle,range)
  
  local allTable={
    [1]=40,[2]=41,['all']=42
  }
  local start = 0
  if range==2 then
     return allTable[side+1]
  end
  if range == 1 then
    start = 20
  end

  if side == 1 then
    start = start +10
  end

  local slotTable = {}
  
  for slot = side*10+0,side*10+9 do
    -- print("slot",slot)
    local charIndex = Battle.GetPlayer(battle, slot) 
    -- print("charIndex",charIndex)
    if(charIndex>=0) then
      table.insert(slotTable,slot)
    end

  end
 
  return slotTable[NLG.Rand(1,#slotTable)]
end

-- NOTE 战斗时 对面的side值
function module:oppositeSide(side)
  if side==0 then
    return 1
  else
    return 0
  end
end

function module:healthColor(injured)
  if injured==0 then
    return "正常"
  elseif injured>0 and injured<=25 then
    return "白傷"
  elseif injured>25 and injured<=50 then
    return "黃傷"
  elseif injured>50 and injured<=75 then
    return "紫傷"
  elseif injured>75 and injured<=100 then
    return "紅傷"
  end
end

function module:Tribe(Tribe)
  if Tribe==0 then
    return "人型"
  elseif Tribe == 1 then
    return "龍"
  elseif Tribe == 2 then
    return "不死"
  elseif Tribe == 3 then
    return "飛行"
  elseif Tribe == 4 then
    return "昆蟲"
  elseif Tribe == 5 then
    return "植物"
  elseif Tribe == 6 then
    return "野獸"
  elseif Tribe == 7 then
    return "特殊"
  elseif Tribe == 8 then
    return "金屬"
  elseif Tribe == 9 then
    return "邪魔"

  end
end

-- NOTE 治疗及招魂
function module:heal(charIndex,treatTarget)
  
  local money = Char.GetData(charIndex, CONST.对象_金币);
  local treatTargetName =  Char.GetData(treatTarget, CONST.对象_名字);
  local injured = Char.GetData(treatTarget, CONST.对象_受伤)

  -- 补血魔
  local lp = Char.GetData(treatTarget, CONST.对象_血)
  local maxLp = Char.GetData(treatTarget, CONST.对象_最大血)
  local fp = Char.GetData(treatTarget, CONST.对象_魔)
  local maxFp = Char.GetData(treatTarget, CONST.对象_最大魔)

  local lpCost = maxLp - lp
  local fpCost = maxFp-fp
  local totalCost = lpCost+fpCost
  if totalCost>0 then
    if money>totalCost then
      Char.SetData(charIndex, CONST.对象_金币, money - totalCost);
      Char.SetData(treatTarget, CONST.对象_血, maxLp)
      Char.SetData(treatTarget, CONST.对象_魔, maxFp)
      NLG.SystemMessage(charIndex, treatTargetName.."補充了生命與魔力，扣除了"..totalCost.."魔幣。");
    else
      NLG.SystemMessage(charIndex, "抱歉，您的魔幣不足，"..treatTargetName.."需要"..totalCost.."魔幣才能補充生命與魔力。");
    end

  end

  -- 治疗
  money = Char.GetData(charIndex, CONST.对象_金币);
  if (injured < 1) then
    NLG.SystemMessage(charIndex, treatTargetName.."無需治療。");
  else
    for k,v in pairs(healPrice) do
      if injured>= v[1] and injured<=v[2] then
        if money>= v[3] then
          Char.SetData(treatTarget, CONST.对象_受伤, 0);
          Char.SetData(charIndex, CONST.对象_金币, money - v[3]);
          NLG.UpdateParty(charIndex);
          NLG.UpdateParty(treatTarget);
          -- NLG.UpChar(charIndex);
          -- NLG.UpChar(treatTarget);
          NLG.SystemMessage(charIndex, treatTargetName.."治療完畢，扣除了"..v[3].."魔幣。");
        else
          NLG.SystemMessage(charIndex, "抱歉，您的魔幣不足以支付"..treatTargetName.."治療需要的"..v[3].."魔幣。");
          return 
        end
      end
    end
  end
 

  money = Char.GetData(charIndex, CONST.对象_金币);
  -- 招魂
  local soulLost = Char.GetData(treatTarget,CONST.对象_掉魂);
  local treatTargetLv = Char.GetData(treatTarget,CONST.对象_等级);
  local cost = soulLost*200*treatTargetLv;
  if money >= cost and soulLost > 0 then
    -- print(money-cost)
    Char.SetData(charIndex,CONST.对象_金币,money-cost);
    Char.SetData(treatTarget,CONST.对象_掉魂,0);
    -- NLG.UpChar(treatTarget);
    NLG.SystemMessage(charIndex,"招魂完成，扣除了"..cost.."魔幣。");	
  
  end
  if money < cost then
    NLG.SystemMessage(charIndex,"缺少招魂所需的"..cost.."魔幣。");	
  end

end

-- NOTE 全队 打卡

function module:partyFeverControl(charIndex,command)
  for slot = 0,4 do
    local p =Char.GetPartyMember(charIndex,slot)
    if(p>=0) then
      if Char.IsDummy(p) then
          Char.SetData(p, CONST.对象_卡时, 24 * 3600);
      end
      local name = Char.GetData(p,CONST.对象_名字);
      if(command ==1) then
        Char.FeverStart(p);
        NLG.UpChar(p);
        NLG.SystemMessage(charIndex, name.."打卡成功。");	
      elseif(command ==0) then
        Char.FeverStop(p);
        NLG.UpChar(p);
        NLG.SystemMessage(charIndex, name.."關閉了打卡。");	
      end
      
    end
  end
end

-- NOTE 文字构建：加点
function module:buildSetPoint(charIndex,heroIndex,page)
  
  local restPoint= Char.GetData(heroIndex,CONST.对象_升级点)
  local pointSetting =sgModule:get(charIndex,"pointSetting") or {}
  local pointsBeSetted = _(pointSetting):chain():values():reduce(0, 
  function(count, item) 
    return count+item
  end):value()
  local warningMsg=""
  if restPoint<pointsBeSetted then
    warningMsg="  ※升級點數不足，請重新分配。"
  end
  local windowStr="剩餘點數:【"..(restPoint-pointsBeSetted).."】"..warningMsg
  .."\n已分配點數：".._(pointAttrs):chain():map(function(attrArray) return "\n「"..attrArray[2].."」："..(pointSetting[attrArray[1]] or "") end):join(""):value()
  .."\n----------------------"
  .."\n輸入分配【"..pointAttrs[page][2].."】的點數:"
  return windowStr

end

-- TODO 文字构建: 改名
function module:rename(charIndex, heroData, page)
  local heroIndex = heroData.index;
  -- 获取 job 
  local jobId = Char.GetData(heroIndex,CONST.对象_职业)
  local jobName = getModule("gmsvData").jobs[tostring(jobId)][1]
  -- 获取说明
  local heroTplId = heroData.tplId
  local heroTplData = _.detect(heroesTpl,function(tpl) return tpl[1]==heroTplId end)
  local oriName = getHeroName(heroData)

  local windowStr="　【" .. heroTplData[15] .. "】　" .. oriName .."　　　職業：" .. jobName .. "\n\n　\n　請輸入新的名字：\n\n"

  return windowStr

end

-- NOTE 缓存 加点数据
function module:cachePointSetting(charIndex,page,data)
  
  local pointSetting =sgModule:get(charIndex,"pointSetting")
  if pointSetting ==nil then
    pointSetting={}
  end
  pointSetting[pointAttrs[page][1]]=data
  sgModule:set(charIndex,"pointSetting",pointSetting)
end

-- NOTE 给佣兵加点
function module:setPoint(charIndex,heroIndex)
  -- 判断 点数是否够
  local name = Char.GetData(heroIndex,CONST.对象_名字)
  local restPoint= Char.GetData(heroIndex,CONST.对象_升级点)
  local pointSetting =sgModule:get(charIndex,"pointSetting")
  local pointsBeSetted = _(pointSetting):chain():values():reduce(0, 
  function(count, item) 
    return count+item
  end):value()
  if restPoint<pointsBeSetted then
    NLG.SystemMessage(charIndex, "點數分配錯誤，請按照提示填寫。");
    return
  end
  -- 判断 分配点数是否超过总点数的一半
  local vital = Char.GetData(heroIndex,CONST.对象_体力)/100
  local str = Char.GetData(heroIndex,CONST.对象_力量)/100
  local tgh = Char.GetData(heroIndex,CONST.对象_强度)/100
  local quick = Char.GetData(heroIndex,CONST.对象_速度)/100
  local magic = Char.GetData(heroIndex,CONST.对象_魔法)/100

  local addedPoint =vital+str+tgh+quick+magic

  local totalPoint = addedPoint + Char.GetData(heroIndex,CONST.对象_升级点)
  for key,arr in pairs(pointAttrs) do
    local data = (pointSetting[arr[1]] or 0 )
    if data== 0 then
      goto continue
    end
   
    local originData = Char.GetData(heroIndex,arr[1])/100
    
    if data+originData>totalPoint/2 then
      
      NLG.Say(charIndex,-1,"點數分配錯誤，單項點數超過最大值，一般為了總點數的一半。",CONST.颜色_红色,0)
      return 
    end
    ::continue::
  end



  Char.SetData(heroIndex,CONST.对象_升级点, restPoint-pointsBeSetted);
  _.each(pointAttrs,function(arr) 
    local data = (pointSetting[arr[1]] or 0 )*100
    if data== 0 then
      return
    end
   
    local originData = Char.GetData(heroIndex,arr[1])
    Char.SetData(heroIndex,arr[1], data+originData);
  end)
  NLG.UpChar(heroIndex);
  local msg = _(pointAttrs):chain():map(function(arr) return arr[2].."+"..pointSetting[arr[1]] end):join(","):value()
  NLG.SystemMessage(charIndex, name..msg);
end

-- NOTE 文字构建：技能浏览
function module:buildCampHeroSkills(charIndex,skills)
  
  local items={}
  for i =1,8 do
    if skills[i]==nil then
      table.insert(items,"空")
    else
      local aiId= skills[i]
      local aiData = _.detect(getModule("heroesAI").aiData,function(data) return data.id==aiId end)

      local name=aiData.name
      table.insert(items,name)
    end
   
  end
  local title="★AI列表"
  return self:NPC_buildSelectionText(title,items);
end

-- NOTE 文字构建：佣兵加点主页
function module:buildHeroOperationSecWindow(charIndex,heroData)
  local heroIndex = heroData.index;
  -- 获取 job 
  local jobId = Char.GetData(heroIndex,CONST.对象_职业)
  --local jobName = getModule("gmsvData").jobs[tostring(jobId)][1]

  -- 获取说明
  local heroTplId = heroData.tplId
  local heroTplData = _.detect(heroesTpl,function(tpl) return tpl[1]==heroTplId end)

  local labelAutoPointing=  heroData.isAutoPointing==0 and "未開啟" or "已開啟"
  local labelPetAUtoPointing = heroData.isPetAutoPointing==0 and "未開啟" or "已開啟"

  local jobName = heroTplData[3];
  local title="    【"..heroTplData[15].."】  ".. self:getHeroName(heroData) .."  定位:"..jobName

  local items = {"夥伴加點","寵物加點","夥伴自動加點方案("..(heroData.autoPointing or '未選擇')..")","寵物自動加點方案("..(heroData.petAutoPointing  or '未選擇')..")","夥伴自動加點開關【"..labelAutoPointing.."】","寵物自動加點開關【"..labelPetAUtoPointing.."】"}
  return self:NPC_buildSelectionText(title,items);

end

-- NOTE 文字构建：自动加点模式选择
-- params: 0 :佣兵，1：宠物
function module:buildAutoPointSelect(type)
  local pattern;
  if type==0 then
    pattern=autoPointingPattern
  elseif type == 1 then
    pattern = petAutoPointingPattern
  end
  local title="★選擇加點方案(體力/力量/強度/敏捷/魔法)"
  return self:NPC_buildSelectionText(title,pattern);
  
end

-- NOTE 设置自动加点模式
function module:setAutoPionting(charIndex,heroData,patternIndex)
  heroData.autoPointing = autoPointingPattern[patternIndex]
end

-- NOTE 设置宠物自动加点模式
function module:setPetAutoPionting(charIndex,heroData,patternIndex)
  heroData.petAutoPointing = petAutoPointingPattern[patternIndex]
end

-- NOTE  执行对象自动加点
function module:autoPoint(charIndex,setting)
  local name=Char.GetData(charIndex,CONST.对象_名字)
  -- logInfo(name,setting)
  local levelUpPoint = Char.GetData(charIndex,CONST.对象_升级点)
  if setting== nil then
    return false,"未找到自动加点方案。"
  end
  for i=1,5 do
    local c = string.sub(setting,i,i)
    local point = tonumber(c)
    if point==nil then
      return false,"自动加点方案错误。"
    end
    if point ==0 then
      goto continue
    end
    
    local type =pointAttrs[i][1]
    -- print("type",type,Char.GetData(charIndex,type),point)
    Char.SetData(charIndex,type,point*100+Char.GetData(charIndex,type))
    levelUpPoint=levelUpPoint-point
    -- if levelUpPoint ==0 then
    --   Char.SetData(charIndex,CONST.对象_升级点, levelUpPoint)
    --   return true,""
    -- end
    ::continue::
  end
  Char.SetData(charIndex,CONST.对象_升级点, levelUpPoint)
  return true,""
end

-- NOTE 更换水晶
function module:changeCrystal(charIndex,heroData,crystalId)
  local heroIndex = heroData.index
  local heroName = Char.GetData(heroIndex,CONST.对象_名字)
  -- 删除水晶
  Char.DelItemBySlot(heroIndex,CONST.位置_水晶)
  local emptySlot = Char.GetEmptyItemSlot(heroIndex)
  local itemData=nil
  if emptySlot<0 then
    -- 先缓存最后一个物品然后删了
    local itemIndex = Char.GetItemIndex(heroIndex,27)
    itemData= self:extractItemData(itemIndex)
    Char.DelItemBySlot(heroIndex,27)
  end

  -- 给水晶，然后装上
  local newCrystalIndex =Char.GiveItem(heroIndex, crystalId, 1);
  local addSlot = Char.GetItemSlot(heroIndex, newCrystalIndex)
	Char.MoveItem(heroIndex, addSlot, CONST.位置_水晶, -1);
  -- 还原物品
  if itemData ~=nil then
    local itemId = itemData[tostring(CONST.道具_ID)]
    local originItemIndex = Char.GiveItem(heroIndex, itemId, 1, false);
      
    if originItemIndex >= 0 then
      self:insertItemData(originItemIndex,itemData)

    end
    Item.UpItem(heroIndex,27)
  end
  
  Item.UpItem(heroIndex,CONST.位置_水晶)
  NLG.SystemMessage(charIndex, heroName.."替换了水晶。");
end

-- NOTE 删除 hero
function module:deleteHeroData(charIndex,heroData)

  if heroData.status == 1 then
    heroData.status=2
    -- 删除佣兵
    local res,err =pcall( function() 
      self:delHeroDummy(charIndex,heroData)
    end)
    -- print(res,err)
  end

  local sql = "update des_heroes set is_deleted = 1 where id = ? "
  local res,ttt =  SQL.QueryEx(sql,heroData.id)
  
  if res.status ~= 0 then
    NLG.SystemMessage(charIndex, "数据库错误，请重试");
    print("heroData.id",heroData.id)
    return
  end
  local heroesData = sgModule:get(charIndex,"heroes")
  local newHeroesData = _.reject(heroesData,function(hero) return hero.id== heroData.id end)
  sgModule:set(charIndex,"heroes",newHeroesData)
  NLG.SystemMessage(charIndex, heroData.name.."已遣散這位夥伴，有緣再見吧。");
end

-- NOTE function 深拷贝
function module:deepcopy(tDest, tSrc)
  for key,value in pairs(tSrc) do
      if type(value)=='table' and value["spuer"]==nil then
          tDest[key] = {}
          self:deepcopy(tDest[key],value)
      else
          tDest[key]=value
      end
  end
end

-- NOTE functions 随机排列表
function module:shuffle(tbl) -- suffles numeric indices
  local len, random = #tbl, math.random ;
  for i = len, 2, -1 do
      local j = random( 1, i );
      tbl[i], tbl[j] = tbl[j], tbl[i];
  end
  return tbl;
end

-- NOTE 填完整 string.fill
function module:strFill(str,len,filler)
  str=tostring(str)
  local strLen =string.len(str)
  -- print(str,strLen,str..string.rep(filler, len-strLen).."|")
  return str..string.rep(filler, len-strLen)
end

--- 加载模块钩子
function module:onLoad()
  self:logInfo('load')

end

--- 卸载模块钩子
function module:onUnload()
  self:logInfo('unload')
end

return module;
