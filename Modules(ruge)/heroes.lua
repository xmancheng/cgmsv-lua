-- 1. 适配cgmsv 24.2b版本
-- 2. 增加了佣兵更名功能
-- 3. 增加了佣兵更换形象功能
-- 4. 修复了一些AI策略, 新增了一些AI条件
-- 5. 修复了在迷宫中上线时的报错
-- 6. 


local module = ModuleBase:createModule('heroes')
local JSON=require "lua/Modules/json"
local _ = require "lua/Modules/underscore"
local skillInfo = dofile("lua/Modules/autoBattleParams.lua")
local sgModule = getModule("setterGetter")
local heroesTpl = dofile("lua/Modules/heroesTpl.lua")
local heroesAI = getModule("heroesAI")
-- local resetCharBattleState = ffi.cast('int (__cdecl*)(uint32_t a1)', 0x0048C020);
local strExt = require "lua/Modules/strExt";


-- 佣兵魔耗 倍率（设置为0.5 即为 原来的一半）
local heroFpReduce=1.0

-- 的招募列表
local heroesR=_.select(heroesTpl,function(heroes) return heroes[20]==1 end)
local heroesSR=_.select(heroesTpl,function(heroes) return heroes[20]==2 end)
local heroesSSR=_.select(heroesTpl,function(heroes) return heroes[20]==4 end)
local heroesUR=_.select(heroesTpl,function(heroes) return heroes[20]==9 end)


---迁移定义
module:addMigration(1, 'init des_heroes', function()
  SQL.querySQL([[
      CREATE TABLE if not exists `des_heroes` (
    `id` varchar(11) COLLATE gbk_bin NOT NULL,
    `cdKey` varchar(32) COLLATE gbk_bin NOT NULL,
    `regNo` int(11) NOT NULL,
    `value` mediumtext COLLATE gbk_bin,
    `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `is_deleted` tinyint(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `is_deleted` (`is_deleted`) USING BTREE
  ) ENGINE=Innodb DEFAULT CHARSET=gbk COLLATE=gbk_bin
  ]])
end);

local heroesFn = getModule("heroesFn")
-- SECTION  窗口 主流程控制
function module:recruitTalked(npc, charIndex, seqno, select, data) 
  -- 注意: 请注意data的类型, 后面脚本需要, 将data做了tonumber处理, 如果需要字符串值, 请在tonumber之前
  -- NOTE 60 佣兵改名窗口 
  if seqno == 60 then
    if select == CONST.BUTTON_确认 then
      if data ~= nil then
        data = tostring(data)
        if data == '' then
          NLG.TalkToCli(charIndex, -1, '名稱不可為空', 4, 1)
        else
          local heroData = sgModule:get(charIndex, "heroSelected");
          local heroIndex = heroData.index;
          local oriName = Char.GetData(heroIndex, CONST.对象_名字)
          self:renameHero(charIndex, heroData, data)
          NLG.TalkToCli(charIndex, -1, '夥伴【' .. oriName .. '】已更名為: ' .. data, 4, 1)
        end
      end
    end
  end

  if seqno == 61 then
    if CONST.BUTTON_确认 then
      data = tonumber(data)
      if data then
        local heroData = sgModule:get(charIndex,"heroSelected");
        local heroIndex = heroData.index;
        local oriName = Char.GetData(heroIndex, CONST.对象_名字);
        local oriMetamo = Char.GetData(heroIndex, CONST.对象_原始图档);
        self:remetamoHero(heroIndex, data)
        NLG.TalkToCli(charIndex, -1, '夥伴【' .. oriName .. '】形象已由【' .. oriMetamo .. '】變更為: 【' .. data .. '】', 4, 1)
      else
        NLG.TalkToCli(charIndex, -1, '請輸入正確的形象編號(數字)', 4, 1)
      end
    end
  end

  data=tonumber(data)
  if select == CONST.BUTTON_关闭 then
    return ;
  end

  -- NOTE  1 招募
  if seqno== 1 and data>0 then
    -- 招募佣兵
    if data==1 then
      self:showRecruitWindow(charIndex);
    end
    -- 下令
    if data==2 then
      sgModule:set(charIndex,"heroListPage",1)
      self:showHeroListWindow(charIndex,1);
    end
  end
  -- NOTE  2 选择了添加的佣兵
  if seqno== 2 and data>0 then
    local heroesData = sgModule:get(charIndex,"heroes")
    if #heroesData>= 32 then
      NLG.SystemMessage(charIndex,"【提示】最多雇傭32名夥伴。")
      return
    end
    -- 数据初始化
    -- local randomHeroes = sgModule:get(charIndex,"randomHeroes")
    local toGetHeroData = heroesR[data]
    local toGetId = toGetHeroData[1]
    local isOwned = _.any(heroesData,function(heroData) return heroData.tplId == toGetId  end)
    if isOwned then
      NLG.Say(charIndex,self.shortcutNpc,"【提示】夥伴【"..toGetHeroData[2].."】已經雇傭了。",CONST.颜色_红色,4)
      return
    end
    local isAbleHire = toGetHeroData[17]==nil and true or toGetHeroData[17](charIndex)
    if not isAbleHire then
      return;
    end 

    local heroData = heroesFn:initHeroData(toGetHeroData,charIndex)
    table.insert(heroesData,heroData)
    sgModule:set(charIndex,"heroes",heroesData)

    NLG.SystemMessage(charIndex,"新的強力夥伴加入了，可以從隊伍設置選擇出戰。")
  end
  --  NOTE  3 下令：显示佣兵列表
  if seqno == 3 then
    
    if data<0 then
      -- 选择的是上一页 下一页
      local page;
      if select == 32 then
        page =  sgModule:get(charIndex,"heroListPage")+1
        
      elseif select == 16 then
        page =  sgModule:get(charIndex,"heroListPage")-1
      end
      -- 返回上一级
      if page ==0 then
        self:recruit(self.shortcutNpc,charIndex)
      end
      sgModule:set(charIndex,"heroListPage",page)
      self:showHeroListWindow(charIndex,page)
    else
      -- 选择的是佣兵  进入操作佣兵界面
      self:showHeroOperationWindow(charIndex,data)
    end
    
    
  end
  --  SECTION 4 下令：选择 佣兵的操作
  if seqno==4  then

    if data<0 then
      -- NOTE 进入 佣兵 列表页
      if select == 16 then
        local page =  sgModule:get(charIndex,"heroListPage")
        self:showHeroListWindow(charIndex,page)
      end
    else
      --NOTE 出征/待命
      if data == 1 then
        self:handleCampaign(charIndex)
      end
      --NOTE 查看状态
      if data == 2 then
        self:showHeroDataWindow(charIndex)
      end
      --NOTE 解雇
      if data == 3 then
        self:showFireConfirmWindow(charIndex)
      end
    end
    
  end
  -- !SECTION
  -- NOTE 5 查看佣兵状态
  if seqno ==5  then

    -- NOTE 进入 佣兵 操作页
    if select == 16 then
      local heroData = sgModule:get(charIndex,"heroSelected")
      self:reShowHeroOperationWindow(charIndex,heroData)
    end

  end

  --  SECTION  6 管理首页 选择项
  if seqno ==6 and data>0 then

    if data==1 then
      heroesFn:partyFeverControl(charIndex,1);
    end

    if data==2 then
      heroesFn:partyFeverControl(charIndex,0);
    end

    if data==3 then
      self:heal(charIndex)
    end

    if data == 4 then
      self:showCampHeroesList(charIndex)
    end

    if data == 5 then
      self:showPartyStatus(charIndex)
    end

    if data == 6 then
      self:gatherHeroes(charIndex);
    end

    if data == 7 then
      sgModule:set(charIndex,"heroListPage",1)
      self:showHeroListWindow(charIndex,1);

    end

  end

  -- !SECTION
  --  NOTE  7 佣兵 选择后
  if seqno==7 and data>0 then
    self:showCampHeroOperationWindow(charIndex,data)
  end

  --  SECTION 8 佣兵 操作选择
  if seqno==8  then
    local curOperationPage = sgModule:get(charIndex,"operationPage")
    if curOperationPage == 1 then
      if data<0 then
        if select == 16 then
          self:showCampHeroesList(charIndex)
        elseif select == 32 then
          self:showCampHeroOperationWindow(charIndex,nil,sgModule:get(charIndex,"heroSelected"),2)
        end
      else
        if data == 1 then
          sgModule:set(charIndex,"statusPage",1)
          self:showCampHeroDataWindow(charIndex,1)
        end

        if data == 2 then
          self:showCampHeroPetWindow(charIndex)
        end
--[[
        if data == 3 then
          sgModule:set(charIndex,"statusPage",1)
          self:showCrystalSelection(charIndex,1)
        end
]]
        --if data == 4 then
        if data == 3 then
          sgModule:set(charIndex,"statusPage",1)
  
          sgModule:set(charIndex,"statusItemWindow",0)
          self:showCampHeroItemWindow(charIndex,1)
        end

        --if data == 5 then
        if data == 4 then
          sgModule:set(charIndex,"statusPage",1)
  
          sgModule:set(charIndex,"statusItemWindow",1)
          self:showCampHeroItemWindow(charIndex,1)
        end

        --if data == 6 then
        if data == 5 then
          self:showHeroOperationSecWindow(charIndex)
        end

        --if data == 7 then
        if data == 6 then
          sgModule:set(charIndex,"statusPage",1)
          self:showCampHeroSkills(charIndex,1)
        end

        --if data == 8 then
        if data == 7 then
          sgModule:set(charIndex,"statusPage",1)
          self:showPetSkills(charIndex,1)
        end

      end
    elseif curOperationPage == 2 then
      if data<0 then
        if select == 16 then
          self:showCampHeroOperationWindow(charIndex,nil,sgModule:get(charIndex,"heroSelected"),1)
        end
      else
        if data == 1 then
          sgModule:set(charIndex,"statusPage",1)
          self:showRename(charIndex)
        end

        if data == 2 then
          sgModule:set(charIndex,"statusPage",1)
          self:showRemetamo(charIndex)
        end
      end
    end
  end

  -- !SECTION
  -- NOTE 9 佣兵 状态 的信息框
  if seqno ==9 then
    -- 选择的是上一页 下一页
    local page;
    if select == 32 then
      page =  sgModule:get(charIndex,"statusPage")+1
      
    elseif select == 16 then
      page =  sgModule:get(charIndex,"statusPage")-1
    end
    sgModule:set(charIndex,"statusPage",page)
    self:showCampHeroDataWindow(charIndex,page)

  end
  -- NOTE 10 佣兵 道具 
  if seqno ==10  then
    -- 选择的是上一页 下一页
    if data<0 then
      local page;
      if select == 32 then
        page =  sgModule:get(charIndex,"statusPage")+1
        
      elseif select == 16 then
        page =  sgModule:get(charIndex,"statusPage")-1
      end
      if page ==0 then
        -- 返回上一级
        self:showCampHeroOperationWindow(charIndex,nil,sgModule:get(charIndex,"heroSelected"),1)
        return
      end

      sgModule:set(charIndex,"statusPage",page)
      self:showCampHeroItemWindow(charIndex,page)
    else
      local statusItemWindow = sgModule:get(charIndex,"statusItemWindow")
      if statusItemWindow == 0 then
        self:toSwitchItemWithPlayer(charIndex,data)
      else
        self:delCampHeroItem(charIndex,data)
      end

    end

  end
  -- NOTE 11 玩家 背包 浏览
  if seqno ==11  then
    -- 选择的是上一页 下一页
    if data<0 then
      local page;
      if select == 32 then
        page =  sgModule:get(charIndex,"playerPage")+1
        
      elseif select == 16 then
        page =  sgModule:get(charIndex,"playerPage")-1
      end
      sgModule:set(charIndex,"playerPage",page)
      self:showPlayerItem(charIndex,page)
    else
      self:switchItem(charIndex,data)
    end
    

  end
  -- NOTE 13 佣兵宠物列表
  if seqno== 13 then
    if data<0 then
    else
      self:showPetOperationWindow(charIndex,data)
    end
  end
  -- SECTION 14 佣兵宠物操作面板
  if seqno== 14 then
    if data<0 then
    else
      if data == 1 then
        --NOTE 交换宠物
        self:showPlayerPetWindow(charIndex,data)
      end
      if data == 2 then
        --NOTE 出战/休息
        self:setPetDeparture(charIndex)
      end
      if data ==3 then
        --NOTE 宠物状态
        sgModule:set(charIndex,"statusPage",1)
        self:showPetDataWindow(charIndex,1)
      end

    end
  end
  -- !SECTION
  -- NOTE 15 玩家宠物列表
  if seqno== 15 then
    if data<0 then
    else
      self:switchPet(charIndex,data)
    end
  end
  -- NOTE 16 佣兵宠物状态 信息框
  if seqno== 16 then
    -- 选择的是上一页 下一页
    local page;
    if select == 32 then
      page =  sgModule:get(charIndex,"statusPage")+1
      
    elseif select == 16 then
      page =  sgModule:get(charIndex,"statusPage")-1
    end
    sgModule:set(charIndex,"statusPage",page)
    self:showPetDataWindow(charIndex,page)
  end
  -- NOTE 17 佣兵加点 输入框
  if seqno== 17 then
    
    -- 选择的是上一页 下一页
    local page=sgModule:get(charIndex,"statusPage");
    heroesFn:cachePointSetting(charIndex,page,data or 0)
    if select == 32 then
      page =  page+1
      
    elseif select == 16 then
      page =  page-1
    end
    sgModule:set(charIndex,"statusPage",page)
    if page>5 then
      self:setPoint(charIndex)
      return;
    end
    self:showCampHeroSetPoint(charIndex,page)
  end
  -- NOTE 18 佣兵战斗AI选择后
  if seqno== 18 then
    if data<0 then

    else
      -- 设置佣兵战斗技能
      self:setHeroBattleSkill(charIndex,data)
    end

  end
  -- NOTE 19 宠物战斗AI选择后
  if seqno== 19 then
    if data<0 then
      -- 选择的是上一页 下一页
      local page;
      if select == 32 then
        page =  sgModule:get(charIndex,"statusPage")+1
        
      elseif select == 16 then
        page =  sgModule:get(charIndex,"statusPage")-1
      end
      sgModule:set(charIndex,"statusPage",page)
      self:showPetSkills(charIndex,page)
    else
      -- 设置宠物战斗技能
      self:setPetBattleSkill(charIndex,data)
    end

  end
  -- NOTE 20 解雇佣兵确认窗口 
  if seqno== 20 then
    if select == CONST.BUTTON_确定 then
      self:fireHero(charIndex)
    else
    end

  end
  -- NOTE 22 战宠加点 输入框
  if seqno== 22 then
    -- 选择的是上一页 下一页
    local page=sgModule:get(charIndex,"statusPage");
    heroesFn:cachePointSetting(charIndex,page,data or 0)
    if select == 32 then
      page =  page+1
      
    elseif select == 16 then
      page =  page-1
    end
    sgModule:set(charIndex,"statusPage",page)
    if page>5 then
      self:setPetPoint(charIndex)
      return;
    end
    self:showBattlePetSetPoint(charIndex,page)
  end
  -- SECTION 23 佣兵加点主页
  if seqno== 23 then
    if data<0 then
      -- 选择的是上一页 下一页
      if select == CONST.BUTTON_上一页 then
        local heroData = sgModule:get(charIndex,"heroSelected")
        self:showCampHeroOperationWindow(charIndex,nil,heroData,1)
      end
    else
      -- NOTE 佣兵手动加点
      if data == 1 then
        sgModule:set(charIndex,"statusPage",1)
        sgModule:set(charIndex,"pointSetting",{})
        self:showCampHeroSetPoint(charIndex,1)
      end
      -- NOTE 宠物手动加点
      if data == 2 then
        sgModule:set(charIndex,"statusPage",1)
        sgModule:set(charIndex,"pointSetting",{})
        self:showBattlePetSetPoint(charIndex,1)
      end
      -- NOTE 佣兵自动加点设置
      if data == 3 then
        self:showAutoPointSelection(charIndex)
      end
      -- NOTE 宠物自动加点设置
      if data == 4 then
        self:showPetAutoPointSelection(charIndex)
      end
      -- NOTE 开启/关闭佣兵自动加点
      if data ==5 then
        self:swtichAutoPointing(charIndex,0)
      end
      -- NOTE 开启/关闭战宠自动加点
      if data ==6 then
        self:swtichAutoPointing(charIndex,1)
      end
    end
   
  end
  -- !SECTION
  -- NOTE 24 选择了加点模式
  if seqno== 24 then
    if data<0 then
      -- 选择的是上一页 下一页
      if select == CONST.BUTTON_上一页 then
        self:showAutoPointSelection(charIndex)
      end
    else
      
      self:setAutoPionting(charIndex,data)
    end
    
  end
  -- NOTE 25 选择了战宠加点模式
  if seqno== 25 then
    if data<0 then
      -- 选择的是上一页 下一页
      if select == CONST.BUTTON_上一页 then
        self:showAutoPointSelection(charIndex)
      end
    else
      
      self:setPetAutoPionting(charIndex,data)
    end
  end
  -- NOTE 26 选择了水晶
  if seqno== 26 then
    if data<0 then
      -- 选择的是上一页 下一页
      if select == CONST.BUTTON_上一页 then
        -- 返回上一级
        self:showCampHeroOperationWindow(charIndex,nil,sgModule:get(charIndex,"heroSelected"),1)
      end
    else
      if sgModule:get(charIndex,"heroSelected") == nil then
        self:changeCrystalForHeroes(charIndex,data)
      else
        self:changeCrystal(charIndex,data)
      end
      
    end
    
  end
  
end

-- !SECTION  窗口 主流程控制


-- NOTE 显示 招募佣兵 对话框 seqno:2
function module:showRecruitWindow(charIndex) 
  local title="★選擇想邀請的夥伴："
  local items={}

  for k,v in pairs(heroesR) do
    -- 名字最大六字  职业: 职业四字  天赋: 4个字符
    local tmpTable = {{v[2], 14},{" 定位:",6},{v[3],10},{" 品質:",6},{v[15], 4}}
    local tmpStr = strExt.strParse(tmpTable);
    table.insert(items, tmpStr);
  end

  local windowStr = self:NPC_buildSelectionText(title,items);
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.窗口_选择框, CONST.BUTTON_关闭, 2,windowStr);
end

-- NOTE 酒馆首页 对话框 seqno:1
function module:recruit(npc,charIndex)
  local windowStr = heroesFn:buildRecruitSelection()
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.窗口_选择框, CONST.BUTTON_关闭, 1,windowStr);
end

-- NOTE  显示佣兵列表 seqno:3
function module:showHeroListWindow(charIndex,page)
  local title = "★我的夥伴列表："
  -- 佣兵 数据 获取
  local heroesData = sgModule:get(charIndex, "heroes")
  for idx = 1 , #heroesData do 
  end

  -- 组合 佣兵名作为列表
  local items = _.map(heroesData, function(data)
      return heroesFn:buildListForHero(data)
    end
  )

  -- 获取 窗口显示需要的数据
  local buttonType,windowStr=self:dynamicListData(items,title,page)
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.窗口_选择框, buttonType, 3,windowStr);
end

-- NOTE 动态列表数据生成
function module:dynamicListData(list,title,page)
 
  page = page or 1 ;
  
  local start_index = (page-1)*8+1
  local totalPage,rest = math.modf(#list/8)
  
  if rest>0 then
    totalPage=totalPage+1
  end
  
  local items = _.slice(list, start_index, 8)
  local windowStr = self:NPC_buildSelectionText(title,items);
  local buttonType;
  if  totalPage ==1 then
    buttonType=CONST.BUTTON_上取消
  elseif page ==1 then
    buttonType=CONST.BUTTON_上下取消
  elseif page == totalPage then
    buttonType=CONST.BUTTON_上取消
  else 
    buttonType = CONST.BUTTON_上下取消
  end
  return buttonType,windowStr
end

-- NOTE 首次 显示佣兵操作 面板 seqno: 4
function module:showHeroOperationWindow(charIndex,data)
  
  local heroesData=sgModule:get(charIndex,"heroes")
  local page = sgModule:get(charIndex,"heroListPage")
 
  local index = (page-1)*8+data
  local heroData = heroesData[index]
  
  -- 缓存 选中的hero id
  sgModule:set(charIndex,"heroSelected",heroData)
  local windowStr = heroesFn:buildOperatorForHero(heroData)
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.窗口_选择框, CONST.BUTTON_上取消, 4,windowStr);
end

-- NOTE 二次 显示佣兵操作 面板 seqno: 4
function module:reShowHeroOperationWindow(charIndex,heroData)
  
  local heroData=  sgModule:get(charIndex,"heroSelected");
  -- local heroData = heroesFn:getHeroDataByid(charIndex,heroId)

  local windowStr = heroesFn:buildOperatorForHero(heroData)
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.窗口_选择框, CONST.BUTTON_上取消, 4,windowStr);
end

-- NOTE 显示 佣兵数值 seqno:5
function module:showHeroDataWindow(charIndex)
  local heroData=  sgModule:get(charIndex,"heroSelected");
  local windowStr = heroesFn:buildAttrDescriptionForHero(heroData)
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.窗口_巨信息框, CONST.BUTTON_上取消, 5,windowStr);
end

-- NOTE 处理 出征/待命  重置佣兵操作 面板 
function module:handleCampaign(charIndex)
  local heroData=  sgModule:get(charIndex,"heroSelected");
  if heroData.status == 1 then
    heroData.status=2
    -- 删除佣兵
    local res,err =pcall( function() 
      local heroIndex  = heroData.index
      Char.LeaveParty(heroIndex);
      heroesFn:cacheHeroAttrData(heroData)
      heroesFn:cacheHeroItemData(heroData)
      heroesFn:cacheHeroPetsData(heroData)
      heroesFn:delHeroDummy(charIndex,heroData)
    end)
  else
    local heroesData = sgModule:get(charIndex,"heroes");
    -- 判断是否满4人
    local count = _.reduce(heroesData, 0, 
      function(count, item) 
        if item.status == 1 then 
          return count+1
        end
        return count
      end)
    if count >=4 then
      NLG.Say(charIndex,self.shortcutNpc,"出戰的夥伴不能超過4個。",CONST.颜色_红色,4)
    else
      heroData.status=1
      -- 生成假人
      heroesFn:generateHeroDummy(charIndex, heroData)
    end
    
  end
  local page =  sgModule:get(charIndex,"heroListPage")
  self:showHeroListWindow(charIndex,page)
end

-- NOTE 登陆时 查找佣兵 数据
function module:onLoginEvent(charIndex)
  local heroesData = heroesFn:queryHeroesData(charIndex);
  heroesData= heroesData or {}  
  sgModule:set(charIndex,"heroes",heroesData)
  local campHeroesData=heroesFn:getCampHeroesData(charIndex)
  -- 登录初始  生成 出征佣兵
  _.each(campHeroesData,function(heroData) 
     heroesFn:generateHeroDummy(charIndex,heroData)
  end)
end

-- NOTE  登出时 且保存佣兵 数据
function module:onLogoutEvent(charIndex)
  local heroesData=sgModule:get(charIndex,"heroes")
  local campHeroesData=heroesFn:getCampHeroesData(charIndex)
  _.each(campHeroesData,function(heroData)
    if not Char.IsValidCharIndex(heroData.index) then
      print("无效的佣兵。",heroData.index)
      return
    end
    --保存数据  删除 假人  
    heroesFn:cacheHeroAttrData(heroData)
    heroesFn:cacheHeroItemData(heroData)
    heroesFn:cacheHeroPetsData(heroData)
    heroesFn:delHeroDummy(charIndex,heroData)
  end)
  heroesFn:saveHeroesData(charIndex,heroesData)
end
-- NOTE 保存佣兵数据
function module:saveHeroesOnTime(charIndex)
  local heroesData=sgModule:get(charIndex,"heroes")
  local campHeroesData=heroesFn:getCampHeroesData(charIndex)
  _.each(campHeroesData,function(heroData) 
    if not Char.IsValidCharIndex(heroData.index) then
      print("无效的佣兵。",heroData.index)
      return
    end
    --保存数据  删除 假人  
    heroesFn:cacheHeroAttrData(heroData)
    heroesFn:cacheHeroItemData(heroData)
    heroesFn:cacheHeroPetsData(heroData)
  end)
  heroesFn:saveHeroesData(charIndex,heroesData)
end

-- NOTE 快捷键ctrl+2 呼出 管理菜单 
function module:shortcut(charIndex, actionID)
  if actionID == %动作_招手% then
    self:management(self.shortcutNpc,charIndex);
  end
end

-- NOTE  管理 首页 seqno:6
function module:management(npc, charIndex)
  local windowStr= heroesFn:buildManagementForHero(charIndex)
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.窗口_选择框, CONST.BUTTON_关闭, 6, windowStr);
end

-- NOTE 佣兵入队 and 聚集
function module:gatherHeroes(charIndex)
  local heroesData = sgModule:get(charIndex,"heroes")
  local Target_FloorId=Char.GetData(charIndex, CONST.对象_地图)
  local Target_MapId=Char.GetData(charIndex, CONST.对象_地图类型)
  local Target_X=Char.GetData(charIndex, CONST.对象_X)
  local Target_Y=Char.GetData(charIndex, CONST.对象_Y)
  local campHeroes = _.select(heroesData,function(item) return item.status==1 end)
  for _,heroData in pairs(campHeroes) do
    local heroIndex  = heroData.index
    -- 先传过来
    -- 判断本身队伍是否满人
    local partyNum = Char.PartyNum(charIndex)
    if(partyNum>=5) then 
      NLG.SystemMessage(charIndex, "隊伍已滿。");	
      
      return 
    end
    
    if(heroIndex>0) then
      -- 被邀请者地队伍人数
      local invitedPartyNum = Char.PartyNum(heroIndex)

      if(invitedPartyNum>0) then
        NLG.SystemMessage(charIndex, "【"..heroesFn:getHeroName(heroData).."】已是出戰狀態。");
      else
        -- 第一个参数 队员，第二个参数队长
        Char.Warp(heroIndex, Target_MapId, Target_FloorId, Target_X, Target_Y)
        Char.JoinParty(heroIndex, charIndex, true); 
      end

    end
  end
end

-- NOTE 显示出征佣兵列表 seqno:7
function module:showCampHeroesList(charIndex)
  local windowStr = heroesFn:buildCampHeroesList(charIndex)
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.窗口_选择框, CONST.BUTTON_关闭, 7,windowStr);
end

-- NOTE 显示佣兵的操作面板 seqno:8
function module:showCampHeroOperationWindow(charIndex, data, heroData, page)
  page = page or 1;
  sgModule:set(charIndex,"operationPage", page)
  if data~= nil and heroData == nil then
    local campHeroes = heroesFn:getCampHeroesData(charIndex)
    heroData = campHeroes[data]
    sgModule:set(charIndex,"heroSelected",heroData)
  elseif data== nil and heroData ~= nil then
    sgModule:set(charIndex,"heroSelected",heroData)
  end

  local heroIndex = heroData.index;
  local name = heroesFn:getHeroName(heroData);
  -- 获取 job 
  local jobId = Char.GetData(heroIndex,CONST.对象_职业)
  --local jobName = getModule("gmsvData").jobs[tostring(jobId)][1]
  -- 获取说明
  local heroTplId = heroData.tplId
  local heroTplData = _.detect(heroesTpl,function(tpl) return tpl[1]==heroTplId end)
  local jobName = heroTplData[3];
  local title="【"..name.."】    「"..heroTplData[15].."」级 :"..jobName;

  local aiId1 = heroData.heroBattleTech or -1
  local aiData1 = _.detect(heroesAI.aiData,function(data) return data.id==aiId1 end)
  local name1=aiData1~=nil and aiData1.name or "未设定"

  local aiId2 = heroData.petBattleTech or -1
  local aiData2 = _.detect(heroesAI.aiData,function(data) return data.id==aiId2 end)
  local name2=aiData2~=nil and aiData2.name or "未设定"

  local list = {
    "夥伴狀態",
    "寵物狀態",
    --"水晶選擇",
    "交換物品",
    "刪除物品",
    "加點設置",
    "夥伴AI設置".."【"..name1.."】",
    "寵物AI設置".."【"..name2.."】",
    --"夥伴改名",
    --"更換形象"
  }

  local buttonType, windowStr = self:dynamicListData(list, title, page)
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.窗口_选择框, buttonType, 8, windowStr);

  -- local windowStr = heroesFn:buildCampHeroOperator(charIndex,heroData)
  -- local buttonType = self:dynamicListData(items,title,page)
  -- NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.窗口_选择框, CONST.BUTTON_上取消, 8, windowStr);
end


-- NOTE 显示  出征佣兵状态 seqno:9
function module:showCampHeroDataWindow(charIndex,page)
  local heroData=  sgModule:get(charIndex,"heroSelected");
  local windowStr = heroesFn:buildDescriptionForCampHero(heroData,page)
  local buttonType
  if page==1 then
    buttonType=CONST.BUTTON_下取消
  else
    buttonType=CONST.BUTTON_上取消
  end
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.窗口_巨信息框, buttonType, 9,windowStr);
end

--  NOTE 显示 出征佣兵道具 seqno:10
function module:showCampHeroItemWindow(charIndex,page)
  local heroData=  sgModule:get(charIndex,"heroSelected");
  local items=heroesFn:buildCampHeroItem(charIndex,heroData)
  local title="【" .. heroesFn:getHeroName(heroData) .. "】的物品"
  -- 获取 窗口显示需要的数据
  local buttonType,windowStr=self:dynamicListData(items,title,page)
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.窗口_选择框, buttonType, 10,windowStr);
end


-- NOTE 选中 出征佣兵道具 
function module:toSwitchItemWithPlayer(charIndex,data)
  local heroData=  sgModule:get(charIndex,"heroSelected");
  local statusPage = sgModule:get(charIndex,"statusPage");
  local heroItemSlotSelected = (statusPage-1)*8+data-1
  -- 记录 选择的佣兵 slot
  sgModule:set(charIndex,"heroItemSlotSelected",heroItemSlotSelected);
  sgModule:set(charIndex,"playerPage",1)
  self:showPlayerItem(charIndex,1)
end

-- NOTE 删除 选中的佣兵道具
function module:delCampHeroItem(charIndex,data)
  local heroData=  sgModule:get(charIndex,"heroSelected");
  local statusPage = sgModule:get(charIndex,"statusPage");
  local heroItemSlotSelected = (statusPage-1)*8+data-1
  local r = Char.DelItemBySlot(heroData.index,heroItemSlotSelected)
  Item.UpItem(heroData.index,heroItemSlotSelected)
  self:showCampHeroItemWindow(charIndex,statusPage)
end


-- NOTE 显示 玩家背包道具窗口 seqno:11
function module:showPlayerItem(charIndex,page)
  local items=heroesFn:buildPlayerItem(charIndex)
  local title="【" .. Char.GetData(charIndex,CONST.对象_名字) .. "】的物品"
  -- 获取 窗口显示需要的数据
  local buttonType,windowStr=self:dynamicListData(items,title,page)
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.窗口_选择框, buttonType, 11,windowStr);
end

-- NOTE 玩家物品与佣兵交换
function module:switchItem(charIndex,data)
  local heroData=  sgModule:get(charIndex,"heroSelected");
  local heroIndex=  heroData.index;
  local playerPage=  sgModule:get(charIndex,"playerPage")
  local playerSlot = (playerPage-1)*8+data+7
  local playerItemIndex =  Char.GetItemIndex(charIndex, playerSlot)
  
  local playerItemData= nil;
  -- 玩家道具数据提取
  if playerItemIndex>=0 then
    playerItemData= heroesFn:extractItemData(playerItemIndex);
    Char.DelItemBySlot(charIndex, playerSlot);

    local r = Char.GetEmptyItemSlot(heroIndex);
    if r<0 then
      NLG.SystemMessage(charIndex,"夥伴背包已滿，請整理物品欄。")
      return
    end
  end
  
  -- 佣兵 道具 数据提取
  local heroItemSlotSelected=sgModule:get(charIndex,"heroItemSlotSelected");
  local heroItemIndex =  Char.GetItemIndex(heroIndex, heroItemSlotSelected)
  local heroItemData= nil;
  if heroItemIndex>=0 then
    heroItemData= heroesFn:extractItemData(heroItemIndex);
    Char.DelItemBySlot(heroIndex, heroItemSlotSelected);
  end
  
  -- 把佣兵道具 给予玩家 
  if heroItemData~=nil then
    local itemId = heroItemData[tostring(CONST.道具_ID)]
    local itemIndex = Char.GiveItem(charIndex, itemId, 1, false);
    if itemIndex >= 0 then
      heroesFn:insertItemData(itemIndex,heroItemData)
      local slot = Char.GetItemSlot(charIndex, itemIndex)
      if slot ~= playerSlot then
        Char.MoveItem(charIndex, slot, playerSlot, -1)
      end
      Item.UpItem(charIndex,playerSlot)
    end
    
  end
  -- 把玩家道具给佣兵
  if playerItemData~= nil then
    
  
    local itemId = playerItemData[tostring(CONST.道具_ID)]
    local itemIndex = Char.GiveItem(heroData.index, itemId, 1, false);
    if itemIndex >= 0 then
      heroesFn:insertItemData(itemIndex,playerItemData)
      local slot = Char.GetItemSlot(heroIndex, itemIndex)
      if slot ~= heroItemSlotSelected then
        Char.MoveItem(heroIndex, slot, heroItemSlotSelected, -1)
      end
      Item.UpItem(heroIndex,heroItemSlotSelected)
      
    end
  end
  NLG.UpChar(heroIndex)
  -- 完成后 显示佣兵背包
  local page = sgModule:get(charIndex,"statusPage")
  self:showCampHeroItemWindow(charIndex,page)
end


-- NOTE 显示佣兵宠物 seqno:13
function module:showCampHeroPetWindow(charIndex)
  local heroData=  sgModule:get(charIndex,"heroSelected");
  local windowStr=heroesFn:buildCampHeroPets(heroData)
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.窗口_选择框, CONST.BUTTON_上取消, 13,windowStr);
end

-- NOTE 显示 宠物操作面板 seqno:14
function module:showPetOperationWindow(charIndex,data)
  local heroPetSlotSelected = tonumber(data)-1
  -- 记录 选择的宠物 slot
  sgModule:set(charIndex,"heroPetSlotSelected",heroPetSlotSelected);
  local heroData=  sgModule:get(charIndex,"heroSelected");
  local windowStr=  heroesFn:buildCampHeroPetOperator(charIndex,heroData)
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.窗口_选择框, CONST.BUTTON_上取消, 14,windowStr);
end

-- NOTE  显示玩家宠物 seqno:15
function module:showPlayerPetWindow(charIndex)
  local windowStr=heroesFn:buildPlayerPets(charIndex)
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.窗口_选择框, CONST.BUTTON_上取消, 15,windowStr);
end

-- NOTE 交换宠物 
function module:switchPet(charIndex,data)
  local heroData=  sgModule:get(charIndex,"heroSelected");
  local heroIndex = heroData.index
  local heroPetSlot =sgModule:get(charIndex,"heroPetSlotSelected");
  local heroPetIndex = Char.GetPet(heroIndex,heroPetSlot)
  local playerPetSlot = tonumber(data)-1
  local playerPetIndex = Char.GetPet(charIndex,playerPetSlot)

  if heroPetIndex >=0 then
    if Char.GetEmptyPetSlot(charIndex) < 0 then
      NLG.SystemMessage(charIndex,"你的寵物欄滿了。")
      return;
    end
    -- 把佣兵宠物给玩家
    local r= Char.TradePet(heroIndex, heroPetSlot, charIndex)
    if r<0 then
      NLG.SystemMessage(charIndex,"。")
      return;
    end
    Pet.UpPet(charIndex,heroPetIndex)
  end
  -- 把玩家宠物给佣兵

  if playerPetIndex>=0 then
    local r= Char.TradePet(charIndex, playerPetSlot, heroIndex)
    if r<0 then
      NLG.SystemMessage(charIndex,"玩家的寵物欄滿了。")
      return;
    end
    Pet.UpPet(heroIndex,playerPetIndex)
  end

  --  完成后，返回 佣兵宠物列表页
  self:showCampHeroPetWindow(charIndex)
end

-- NOTE 显示  宠物状态窗口 seqno:16
function module:showPetDataWindow(charIndex,page)
  local heroData=  sgModule:get(charIndex,"heroSelected");
  local heroIndex = heroData.index
  local heroPetSlot =sgModule:get(charIndex,"heroPetSlotSelected");
  local heroPetIndex = Char.GetPet(heroIndex,heroPetSlot)
  if heroPetIndex<0 then
    return;
  end
  local windowStr = heroesFn:buildDescriptionForPet(heroData,heroPetIndex,page)
  local buttonType
  if page==1 then
    buttonType=CONST.BUTTON_下取消
  else
    buttonType=CONST.BUTTON_上取消
  end
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.窗口_巨信息框, buttonType, 16,windowStr);
end

-- NOTE 设置宠物出战状态
function module:setPetDeparture(charIndex)
  local heroData=  sgModule:get(charIndex,"heroSelected");
  local heroIndex = heroData.index
  local heroPetSlot =sgModule:get(charIndex,"heroPetSlotSelected");
  local heroPetIndex = Char.GetPet(heroIndex,heroPetSlot)
  local status =  Char.GetData(heroPetIndex, CONST.PET_DepartureBattleStatus);
  if status == CONST.PET_STATE_战斗 then
    Char.SetPetDepartureState(heroIndex,heroPetSlot,CONST.PET_STATE_待命)
  else
    Char.SetPetDepartureState(heroIndex,heroPetSlot,CONST.PET_STATE_战斗)
  end

end

-- NOTE 显示 设置佣兵 加点 seqno:17
function module:showCampHeroSetPoint(charIndex,page)
  local heroData=  sgModule:get(charIndex,"heroSelected");
  local heroIndex = heroData.index

  local windowStr=heroesFn:buildSetPoint(charIndex,heroIndex,page)
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.窗口_输入框, CONST.BUTTON_上下取消, 17,windowStr);
end

-- NOTE 设置加点
function module:setPoint(charIndex,heroIndex)
  local heroData=  sgModule:get(charIndex,"heroSelected");
  local heroIndex = heroData.index
  heroesFn:setPoint(charIndex,heroIndex)
end

-- NOTE 显示设置 战宠加点 seqno:22
function module:showBattlePetSetPoint(charIndex,page)
  local heroData=  sgModule:get(charIndex,"heroSelected");
  local heroIndex = heroData.index
  local petSlot = Char.GetData(heroIndex, CONST.对象_战宠);
  if petSlot<0 then
    NLG.Say(charIndex,self.shortcutNpc,"請先設置出戰寵物。",CONST.颜色_红色,4)
    return
  end
  petIndex = Char.GetPet(heroIndex, petSlot);

  local windowStr=heroesFn:buildSetPoint(charIndex,petIndex,page)
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.窗口_输入框, CONST.BUTTON_上下取消, 22,windowStr);
end

-- NOTE 设置宠物加点
function module:setPetPoint(charIndex)
  local heroData=  sgModule:get(charIndex,"heroSelected");
  local heroIndex = heroData.index
  local petSlot = Char.GetData(heroIndex, CONST.对象_战宠);
  if petSlot<0 then
    NLG.Say(charIndex,self.shortcutNpc,"請先設置出戰寵物。",CONST.颜色_红色,4)
    return
  end
  petIndex = Char.GetPet(heroIndex, petSlot);

  heroesFn:setPoint(charIndex,petIndex)
end

-- NOTE 战斗开始事件
function module:onBattleStart(battleIndex)
  for pos=0,19 do
		local charIndex = Battle.GetPlayer(battleIndex,pos);
		if charIndex<0 then
      return
    end
    if (Char.GetData(charIndex,%对象_序%) == %对象类型_人%) and (not Char.IsDummy(charIndex)) then
      -- 获取 对象所在地图 
      local Target_FloorId=Char.GetData(charIndex, CONST.对象_地图)
      local Target_MapId=Char.GetData(charIndex, CONST.对象_地图类型)
      local Target_X=Char.GetData(charIndex, CONST.对象_X)
      local Target_Y=Char.GetData(charIndex, CONST.对象_Y)
      local campHeroesData = heroesFn:getCampHeroesData(charIndex) or {}
      _.each(campHeroesData,function(heroData) 
        local heroIndex = heroData.index
        local floor=Char.GetData(heroIndex, CONST.对象_地图)
        local mapId=Char.GetData(heroIndex, CONST.对象_地图类型)
        if floor ~= Target_FloorId or mapId ~= Target_MapId then
          Char.Warp(heroIndex, Target_MapId, Target_FloorId, Target_X, Target_Y)
        end

      end)
    end
		
	end
end

-- NOTE 战斗：回合开始 战斗指令
function module:handleDummyCommand(battleIndex)
  local poss={}
  for i = 0, 19 do
    table.insert(poss,i)
  end
  _.each(poss,function(pos) 
    local dummyIndex = Battle.GetPlayer(battleIndex, pos);
    -- 如果不是人，退出
    if dummyIndex < 0 then
      return
    end
    -- 如果不是假人，退出
    if not Char.IsDummy(dummyIndex) then
      return
    end
    -- 如果不是佣兵 ，退出
    local heroesOnline=sgModule:getGlobal("heroesOnline")
    if not heroesOnline[dummyIndex] then
      return
    end
    local heroData = heroesOnline[dummyIndex]
    -- 如果 owner不在本场战斗，退出战斗
    local ownerIndex= heroData.owner
    local ownerSlot = Battle.GetSlot(battleIndex,ownerIndex)

    if ownerSlot<0  then
      Battle.ExitBattle(dummyIndex);
      return
    end
    -- 如果不是在等待命令，退出
    local isWaiting =Battle.IsWaitingCommand(dummyIndex)
    if isWaiting ~=1 then
      return 
    end
    local side=0
    if pos>9 then
      side=1
    end 

    -- 获取 ai
    local heroesOnline = sgModule:getGlobal("heroesOnline")

    local aiId = heroData.heroBattleTech
    local aiData =  _.detect(heroesAI.aiData,function(data) return data.id==aiId end)
    local commands=aiData ==nil and {} or aiData.commands
    local actionData = heroesAI:calcActionData(dummyIndex,side,battleIndex,pos,commands)
    
    -- 第一个命令
    Battle.ActionSelect(dummyIndex, actionData[1],actionData[2] , actionData[3]);

    -- 获取其宠物
    local petSLot = math.fmod(pos + 5, 10)+side*10;
    local petIndex = Battle.GetPlayer(battleIndex, petSLot);
    
    if petIndex<0 then
      -- 第二轮普通，打对方血最少的
      Battle.ActionSelect(dummyIndex,CONST.BATTLE_COM.BATTLE_COM_ATTACK,getModule("heroesAI").target["6"]["fn"](dummyIndex,side,battleIndex,pos,0) ,-1);

    else
      local petAiId = heroData.petBattleTech
      local petAiData =  _.detect(heroesAI.aiData,function(data) return data.id==petAiId end)
      local petCommands=petAiData ==nil and {} or petAiData.commands
      
      local petActionData = heroesAI:calcActionData(petIndex,side,battleIndex,petSLot,petCommands)
      Battle.ActionSelect(petIndex, petActionData[1],petActionData[2] , petActionData[3]);
    end
  end)
end
-- NOTE 获取 行为数据
-- function module:getActionInfo(techId)
--   if techId == nil then
--     return {CONST.BATTLE_COM.BATTLE_COM_P_PARAMETER,300,1,0}
--   end
--   local result = _.detect(skillInfo.params,function(item) 
--     local ids=item[2]
--     if type(ids) == 'number' then
--       return true 
--     elseif type(ids) == 'table' then
--       if techId >= ids[1] and techId<= ids[2] then
--         return true
--       end
--     end
--     return false
--   end)
--   if result ~=nil and next(result) ~=nil then
--     result[2] = techId
--     return result
--   end
--   return {CONST.BATTLE_COM.BATTLE_COM_P_PARAMETER,300,1,0}
-- end
-- NOTE 传送事件
function module:handleWarpEvent(charIndex,Ori_MapId, Ori_FloorId, Ori_X, Ori_Y, Target_MapId, Target_FloorId, Target_X, Target_Y)
  return 0
end
-- NOTE 传送后事件
function module:handleAfterWarpEvent(charIndex,Ori_MapId, Ori_FloorId, Ori_X, Ori_Y, Target_MapId, Target_FloorId, Target_X, Target_Y)
  -- 如果是假人 退出
  if Char.IsDummy(charIndex) then
    return 0;
  end
  local campHeroesData = heroesFn:getCampHeroesData(charIndex) or {}
  
  _.each(campHeroesData,function(heroData) 
    local heroIndex = heroData.index;
    local battleIndex= Char.GetData(heroIndex, CONST.对象_BattleIndex)
    
    
    if battleIndex>=0 then
      if Char.GetData(heroIndex, CONST.对象_战斗中) > 0 and Battle.GetWinSide(battleIndex)==-1 then
        Battle.ExitBattle(heroIndex);
      end
    end

    local partyNum = Char.PartyNum(charIndex)
    if(partyNum>=5) then 	
      return 0
    end

    local invitedPartyNum = Char.PartyNum(heroIndex)
    if invitedPartyNum<=0  then
      -- 第一个参数 队员，第二个参数队长
      Char.Warp(heroIndex, Target_MapId, Target_FloorId, Target_X, Target_Y)
      Char.JoinParty(heroIndex, charIndex, true); 
    end

  end)
  return 0;
end
-- NOTE 治疗
function module:heal(charIndex)
  local campHeroesData = heroesFn:getCampHeroesData(charIndex);
  
  _.each(campHeroesData,function(heroData) 
    heroesFn:heal(charIndex,heroData.index)
    -- 治疗 宠物
    for heroPetSlot = 0,4 do
      local petIndex = Char.GetPet(heroData.index,heroPetSlot)
      if petIndex>=0 then
        heroesFn:heal(charIndex,petIndex)
      end
    end
    NLG.UpChar(heroData.index);
  end)
  heroesFn:heal(charIndex,charIndex)
  -- 治疗 宠物
  for heroPetSlot = 0,4 do
    local petIndex = Char.GetPet(charIndex,heroPetSlot)
    if petIndex>=0 then
      heroesFn:heal(charIndex,petIndex)
    end
  end
  NLG.UpChar(charIndex);
end
-- NOTE 佣兵技能浏览 seq:18
function module:showCampHeroSkills(charIndex,page)
  local heroData=  sgModule:get(charIndex,"heroSelected");
  local skills = heroData.skills;
  local windowStr=heroesFn:buildCampHeroSkills(charIndex,skills)
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.窗口_选择框, CONST.BUTTON_上取消, 18,windowStr);
end

-- NOTE 设置佣兵AI
function module:setHeroBattleSkill(charIndex,data)
  local heroData=  sgModule:get(charIndex,"heroSelected");
  local heroIndex = heroData.index
  local aiId = heroData.skills[data]
  if aiId==nil or  aiId<0 then
    NLG.SystemMessage(charIndex,"請選擇有效的AI。")
    return  
  end
  local aiData = _.detect(heroesAI.aiData,function(ai) return ai.id==aiId end)
  -- print('>>>',aiData);
  local name=aiData.name
  heroData.heroBattleTech = aiId;
  NLG.SystemMessage(charIndex,"記錄完成，夥伴的戰鬥AI是："..name)
end

-- NOTE 显示宠物技能列表 seqno:19
function module:showPetSkills(charIndex,page)
  local heroData=  sgModule:get(charIndex,"heroSelected");
  local petSkills = heroData.petSkills;
  local windowStr=heroesFn:buildCampHeroSkills(charIndex,petSkills)
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.窗口_选择框, CONST.BUTTON_上取消, 19,windowStr);
end

-- NOTE 设置 宠物AI
function module:setPetBattleSkill(charIndex,data)

  local heroData=  sgModule:get(charIndex,"heroSelected");
  local heroIndex = heroData.index
  local aiId = heroData.petSkills[data]
  if aiId==nil or  aiId<0 then
    NLG.SystemMessage(charIndex,"請選擇有效的技能。")
    return  
  end
  local aiData = _.detect(heroesAI.aiData,function(ai) return ai.id==aiId end)
  local name = aiData.name
  heroData.petBattleTech = aiId;
  NLG.SystemMessage(charIndex,"記錄完成，寵物的戰鬥AI是："..name)
end

-- NOTE 解雇佣兵
function module:fireHero(charIndex)
  local heroData=  sgModule:get(charIndex,"heroSelected");
  heroesFn:deleteHeroData(charIndex,heroData)
  local page =  sgModule:get(charIndex,"heroListPage")
  self:showHeroListWindow(charIndex,page)
end

-- NOTE 解雇确认窗口 seqno:20
function module:showFireConfirmWindow(charIndex)
  local heroData = sgModule:get(charIndex,"heroSelected");
  local windowStr="\n\n★即將遣散夥伴：【"..heroesFn:getHeroName(heroData).."】"
  .."\n\n※遣散後此夥伴會失去所有屬性；裝備與寵物。"
  .."\n\n★★★★★★★確定遣散此夥伴嗎？★★★★★★★"
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.窗口_信息框, CONST.BUTTON_确定关闭, 20, windowStr);

end

-- DONE 佣兵改名
function module:renameHero(charIndex, heroData, newName)
  local heroIndex = heroData.index;
  Char.SetData(heroIndex, CONST.对象_名字, newName)
  
  -- DONE: 需要同步修改heroData.name heroData.trueName
  heroData.name = newName;
  heroData.trueName = newName;
  heroesFn:saveHeroData(charIndex, heroData)
  
  NLG.UpChar(heroIndex)
end

-- DONE: 佣兵改名窗口 seqno:60
function module:showRename(charIndex)
  local heroData=  sgModule:get(charIndex, "heroSelected");
  local heroIndex = heroData.index;
  -- 获取 job 
  local jobId = Char.GetData(heroIndex,CONST.对象_职业)
  local jobName = getModule("gmsvData").jobs[tostring(jobId)][1]
  -- 获取说明
  local heroTplId = heroData.tplId
  local heroTplData = _.detect(heroesTpl,function(tpl) return tpl[1]==heroTplId end)
  local oriName = Char.GetData(heroIndex, CONST.对象_名字)

  local windowStr="　【" .. heroTplData[15] .. "】　" .. oriName .."　　　職業：" .. jobName .. "\n\n　\n　請輸入新的名字：\n\n"

  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.窗口_输入框, CONST.BUTTON_确定关闭, 60, windowStr);
end


function module:remetamoHero(charIndex, newMetamo)
  Char.SetData(charIndex, %对象_形象%, newMetamo)
  Char.SetData(charIndex, %对象_原形%, newMetamo)
  NLG.UpChar(charIndex)
end

-- DONE 佣兵改形象窗口 seqno:61
function module:showRemetamo(charIndex)
  local heroData=  sgModule:get(charIndex, "heroSelected");
  local heroIndex = heroData.index;
  -- 获取 job 
  local jobId = Char.GetData(heroIndex,CONST.对象_职业)
  local jobName = getModule("gmsvData").jobs[tostring(jobId)][1]
  -- 获取说明
  local heroTplId = heroData.tplId
  local heroTplData = _.detect(heroesTpl,function(tpl) return tpl[1]==heroTplId end)
  local oriName = Char.GetData(heroIndex, CONST.对象_名字)
  local oriMetamo = Char.GetData(heroIndex, %对象_形象%)


  local windowStr="　【" .. heroTplData[15] .. "】　" .. oriName .."　　　職業：" .. jobName
  .. "\n\n  請慎用本功能, 形象編號請自行查詢"
  .. "\n\n　當前形象編號:" .. oriMetamo 
  .. "\n\n　請輸入新的形象編號：\n\n"
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.窗口_输入框, CONST.BUTTON_确定关闭, 61, windowStr);
end

-- TODO: 佣兵改形象确认窗口 seqno:62
function module:showRemetamoOK(charIndex, newMetamo)
  local windowStr = "@g,"..newMetamo..",1,4,4,1@　新的形象為:"..newMetamo.."";
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST["窗口_信息框"], CONST.BUTTON_确定取消, 62, windowStr);
end

-- NOTE  佣兵升级事件
function module:onLevelUpEvent(charIndex)
  local name = Char.GetData(charIndex,CONST.对象_名字)
  --logInfo("herolevelup",name,Char.GetData(charIndex,CONST.对象_序))

  -- 如果不是假人，退出
  if not Char.IsDummy(charIndex) then
    return
  end
  -- 如果不是佣兵 ，退出
  local heroesOnline=sgModule:getGlobal("heroesOnline")
  local heroData = heroesOnline[charIndex]
  if not heroesOnline[charIndex] then
    return
  end

  -- 获取 heroTpl 数据 执行升级回调函数
  local heroTplId = heroData.tplId
  local heroTplData = _.detect(heroesTpl,function(tpl) return tpl[1]==heroTplId end)
  if heroTplData== nil then
    NLG.SystemMessage(charIndex,"錯誤的夥伴。")
  end
  if heroTplData and  heroTplData[16] ~= nil then
    -- 这里的charIndex
    heroTplData[16](charIndex)
  end

  -- 关闭了自动加点，退出
  if heroData.isAutoPointing == 0 then
    return
  end
  local levelUpPoint = Char.GetData(charIndex,CONST.对象_升级点)
  local times,rest = math.modf(levelUpPoint/4)
  
  for i=1,times+1 do
    heroesFn:autoPoint(charIndex,heroData.autoPointing)
  end

  --NLG.SystemMessage(heroData.owner,name.."等級提升，自動加點："..(heroData.autoPointing))
end

-- NOTE 战宠升级事件
function module:onPetLevelUpEvent(charIndex,petIndex)
  local name = Char.GetData(charIndex,CONST.对象_名字)
  --logInfo("petlevelup",name,Char.GetData(charIndex,CONST.对象_序))

  -- 如果不是佣兵 ，退出
  local heroesOnline=sgModule:getGlobal("heroesOnline")
  if not heroesOnline[charIndex] then
    return
  end
  local heroData = heroesOnline[charIndex]
  local heroIndex = heroData.index;

  -- 关闭了自动加点，退出
  if heroData.isPetAutoPointing == 0 then
    return
  end

  local petSlot = Char.GetData(heroIndex, CONST.对象_战宠);
  if petSlot<0 then
    NLG.Say(charIndex,-1,"[提示]找不到寵物。",CONST.颜色_红色,4)
    return
  end

  local petIndex = Char.GetPet(heroIndex, petSlot);
  -- Char.SetLoopEvent(nil, 'petlevelupLoop', petIndex, 0);
  local heroIndex=  Pet.GetOwner(petIndex)
  local name = Char.GetData(heroIndex,CONST.对象_名字)
  local heroesOnline=sgModule:getGlobal("heroesOnline")
  local heroData = heroesOnline[heroIndex]
  local petSlot = Char.GetData(heroIndex, CONST.对象_战宠);
  
  local petName=Char.GetData(petIndex,CONST.对象_名字)
  -- 进行自动加点
  local levelUpPoint = Char.GetData(petIndex,CONST.对象_升级点)
  local times,rest = math.modf(levelUpPoint/1)
  
  for i=1,times+1 do
    getModule('heroesFn'):autoPoint(petIndex,heroData.petAutoPointing)
  end
  
  --NLG.SystemMessage(heroData.owner,name.."的寵物【"..petName.."】等級提升，自動加點："..(heroData.petAutoPointing))
end

-- NOTE 战斗耗蓝事件
function module:onCalcFpConsumeEvent(charIndex,techId,fpConsume)
  -- local name = Char.GetData(charIndex,CONST.对象_名字)
  -- logInfo("战斗耗蓝",name,charIndex,techId,fpConsume)
  local heroesOnline=sgModule:getGlobal("heroesOnline")
  local heroData = heroesOnline[charIndex]
  -- 如果不是佣兵 ，退出
  if not heroesOnline[charIndex] then
    return fpConsume
  end
  local techIndex = Tech.GetTechIndex(techId)
  local originFP=Tech.GetData(techIndex, CONST.TECH_FORCEPOINT)
  if fpConsume<0 then
    return math.ceil(originFP*heroFpReduce)
  end
  return math.ceil(fpConsume*heroFpReduce)
end

-- NOTE 右键点击事件
function module:onRightClickEvent(charIndex, dummyIndex)
    -- 如果不是假人，退出
    if not Char.IsDummy(dummyIndex) then
      return
    end

    -- 如果不是佣兵 ，退出
    local heroesOnline=sgModule:getGlobal("heroesOnline")
    local heroData = heroesOnline[dummyIndex]
    if not heroesOnline[dummyIndex] then
      return
    end

    -- 佣兵的owner
    if heroData.owner ~= charIndex then
      return
    end

    self:showCampHeroOperationWindow(charIndex,nil,heroData,1)

end

-- NOTE 显示队伍一览 seqno:21
function module:showPartyStatus(charIndex)
  
  local windowStr = heroesFn:buildDescriptionForParty(charIndex)
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.窗口_巨信息框, CONST.BUTTON_关闭, 21,windowStr);
end

-- NOTE 佣兵加点主页 seqno:23
function module:showHeroOperationSecWindow(charIndex)
  local heroData = sgModule:get(charIndex,"heroSelected")
  local windowStr = heroesFn:buildHeroOperationSecWindow(charIndex,heroData)
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.窗口_选择框, CONST.BUTTON_上取消, 23,windowStr);
end

-- NOTE 显示加点模式选择 seqno:24
function module:showAutoPointSelection(charIndex)
  local windowStr=heroesFn:buildAutoPointSelect(0);
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.窗口_选择框, CONST.BUTTON_上取消, 24,windowStr);
end
-- NOTE 显示战宠加点模式选择 seqno:25
function module:showPetAutoPointSelection(charIndex)
  local windowStr=heroesFn:buildAutoPointSelect(1);
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.窗口_选择框, CONST.BUTTON_上取消, 25,windowStr);
end

-- NOTE 设置佣兵自动加点模式
function module:setAutoPionting(charIndex,data)

  local heroData = sgModule:get(charIndex,"heroSelected");

  heroesFn:setAutoPionting(charIndex,heroData,data)
  local name = Char.GetData(heroData.index,CONST.对象_名字)
  NLG.SystemMessage(charIndex,name.."變更了自動加點方案。")
  self:showHeroOperationSecWindow(charIndex)
end

-- NOTE 设置战宠自动加点模式
function module:setPetAutoPionting(charIndex,data)
  local heroData = sgModule:get(charIndex,"heroSelected");
  heroesFn:setPetAutoPionting(charIndex,heroData,data)
  local name = Char.GetData(heroData.index,CONST.对象_名字)
  NLG.SystemMessage(charIndex,name.."變更了寵物的自動加點方案。")
  self:showHeroOperationSecWindow(charIndex)
end

-- NOTE 开启/关闭 自动加点
-- params type: 0：佣兵，1：宠物
function module:swtichAutoPointing(charIndex,type)
  local heroData = sgModule:get(charIndex,"heroSelected");
  if type==0 then
    if heroData.autoPointing==nil then
      NLG.SystemMessage(charIndex,"請先設置夥伴的自動加點方案。")
      return;
    end
    heroData.isAutoPointing=heroData.isAutoPointing==0 and 1 or 0
  elseif type ==1 then
    if heroData.petAutoPointing==nil then
      NLG.SystemMessage(charIndex,"請先設置寵物的自動加點方案。")
      return;
    end
    heroData.isPetAutoPointing=heroData.isPetAutoPointing==0 and 1 or 0
  end
  self:showHeroOperationSecWindow(charIndex)
end

-- NOTE 显示水晶窗口 seqno:26
function module:showCrystalSelection(charIndex)
  local items={"地屬性水晶","水屬性水晶","火屬性水晶","風屬性水晶"}
  local title="選擇水晶："
  local windowStr = self:NPC_buildSelectionText(title,items);
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.窗口_选择框, CONST.BUTTON_上取消, 26,windowStr);
end

-- 更换水晶
function module:changeCrystal(charIndex,data)
  
  local crystalItemIdMpa={33202200,33202210,33202220,33202230};
  local crystalId = crystalItemIdMpa[data]
  local heroData = sgModule:get(charIndex,"heroSelected");
  heroesFn:changeCrystal(charIndex,heroData,crystalId)
  self:showCampHeroOperationWindow(charIndex,nil,sgModule:get(charIndex,"heroSelected"),1)
end

function module:changeCrystalForHeroes(charIndex,data)
  local crystalItemIdMpa={33202200,33202210,33202220,33202230};
  local crystalId = crystalItemIdMpa[data]
  local campHeroes = heroesFn:getCampHeroesData(charIndex)
  _.each(campHeroes,function(heroData) 
    
    heroesFn:changeCrystal(charIndex,heroData,crystalId)
  
  end)
 
  self:management(self.shortcutNpc,charIndex)
end

-- NOTE 经验获取事件
function module:onGetExpEvent(charIndex,exp)

end

-- NOTE 窗口流程控制
function module:skillNpcTalked(npc, charIndex, seqno, select, data)
  data=tonumber(data)
  if select == CONST.BUTTON_关闭 then
    return ;
  end
  -- NOTE  1 佣兵列表
  if seqno== 1 and data>0 then
    self:showSkills(charIndex,data)
  end
  --  NOTE  2 选择技能
  if seqno==2  then
    -- 选择的是上一页 下一页
    if data<0 then

    else
      self:showCampHeroSkillSlot(charIndex,data)
    end
  end
  -- NOTE  3 技能选择完
  if seqno== 3 and data>0 then
    self:getSkill(charIndex,data)
  end
end

-- NOTE 佣兵选择 首页 seqno:1
function module:showSkillNpcHome(npc,charIndex)
  local windowStr = heroesFn:buildCampHeroesList(charIndex)
  NLG.ShowWindowTalked(charIndex, self.skillNpc, CONST.窗口_选择框, CONST.BUTTON_关闭, 1,windowStr);
end
-- NOTE 选择技能 seqno:2
function module:showSkills(charIndex,data,heroData)
  if data~= nil and heroData == nil then
    local campHeroes = heroesFn:getCampHeroesData(charIndex)
    heroData = campHeroes[data]
    sgModule:set(charIndex,"heroSelected4skill",heroData)
  end
  local heroIndex= heroData.index;
  local skillLv = math.ceil(Char.GetData(heroIndex,CONST.对象_等级)/10) 
  
  local items={}
  local techIdItems={}
  _.each(skillInfo.params,function(param) 
    local ids = param[2]
    if type(ids) == 'number' then
      local techIndex = Tech.GetTechIndex(ids)
      local lv=Tech.GetData(techIndex, CONST.TECH_NECESSARYLV)
      if lv ~= skillLv then
        return;
      end
      local name=Tech.GetData(techIndex, CONST.TECH_NAME)
      table.insert(items,name)
      table.insert(techIdItems,ids)
    else
      for techId = ids[1],ids[2] do
        local techIndex = Tech.GetTechIndex(techId)
        local lv=Tech.GetData(techIndex, CONST.TECH_NECESSARYLV)
        if lv ~= skillLv then
          return;
        end
        local name=Tech.GetData(techIndex, CONST.TECH_NAME)
        table.insert(items,name)
        table.insert(techIdItems,techId)
      end
    end
  end)
  sgModule:set(charIndex,"techIdsAbleToGet",techIdItems);
  local title="請選擇技能"
  local windowStr=  self:NPC_buildSelectionText(title,items);
  
  NLG.ShowWindowTalked(charIndex, self.skillNpc, CONST.窗口_选择框, CONST.BUTTON_上取消,2,windowStr);
end

-- NOTE 显示佣兵技能栏 seqno:3
function module:showCampHeroSkillSlot(charIndex,data)
  local techId = (sgModule:get(charIndex,"techIdsAbleToGet"))[data];
  sgModule:set(charIndex,"skillSelected",techId);
  local heroData=  sgModule:get(charIndex,"heroSelected4skill");
  local windowStr=heroesFn:buildCampHeroSkills(charIndex,heroData)
  NLG.ShowWindowTalked(charIndex, self.skillNpc, CONST.窗口_选择框, CONST.BUTTON_上取消, 3,windowStr);

end

-- NOTE 执行登记技能
function module:getSkill(charIndex,data)
  local techId = sgModule:get(charIndex,"skillSelected");
  local heroData=  sgModule:get(charIndex,"heroSelected4skill");
  if heroData.skills == nil then
    heroData.skills={nil,nil,nil,nil,nil,nil,nil,nil} 
  end
  heroData.skills[data]=techId
  local name = Char.GetData(heroData.index,CONST.对象_名字)
  NLG.SystemMessage(charIndex,name.."技能記錄成功。")
end

-- !SECTION 
--- NOTE 加载模块钩子
function module:onLoad()
  self:logInfo('load')
  -- 先reload 依赖的module
  reloadModule("autoBattleParams")
  reloadModule("heroesFn")
  
  self:regCallback('CharActionEvent', Func.bind(self.shortcut, self))
  -- npc 
  self.shortcutNpc = self:NPC_createNormal('夥伴集結', 231048, { x = 29, y = 29, mapType = 0, map = 7351, direction = 4 });
  self:NPC_regTalkedEvent(self.shortcutNpc, Func.bind(self.recruit, self));
  self:NPC_regWindowTalkedEvent(self.shortcutNpc, Func.bind(self.recruitTalked, self));

  self:regCallback('BeforeBattleTurnEvent', Func.bind(self.handleDummyCommand, self))
  self:regCallback('LoginEvent', Func.bind(self.onLoginEvent, self));
  self:regCallback('LogoutEvent', Func.bind(self.onLogoutEvent, self));
  self:regCallback('AfterWarpEvent', Func.bind(self.handleAfterWarpEvent, self))
  self:regCallback('BattleStartEvent', Func.bind(self.onBattleStart, self))
  self:regCallback("LevelUpEvent", Func.bind(self.onLevelUpEvent, self))
  self:regCallback("LevelUpEvent", Func.bind(self.onPetLevelUpEvent, self))
  self:regCallback("CalcFpConsumeEvent",Func.bind(self.onCalcFpConsumeEvent, self))
  self:regCallback("RightClickEvent",Func.bind(self.onRightClickEvent, self))

end

--- NOTE 卸载模块钩子
function module:onUnload()
  self:logInfo('unload')
end

return module;
