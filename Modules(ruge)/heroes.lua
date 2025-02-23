-- 1. ����cgmsv 24.2b�汾
-- 2. ������Ӷ����������
-- 3. ������Ӷ������������
-- 4. �޸���һЩAI����, ������һЩAI����
-- 5. �޸������Թ�������ʱ�ı���
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


-- Ӷ��ħ�� ���ʣ�����Ϊ0.5 ��Ϊ ԭ����һ�룩
local heroFpReduce=1.0

-- ����ļ�б�
local heroesR=_.select(heroesTpl,function(heroes) return heroes[20]==1 end)
local heroesSR=_.select(heroesTpl,function(heroes) return heroes[20]==2 end)
local heroesSSR=_.select(heroesTpl,function(heroes) return heroes[20]==4 end)
local heroesUR=_.select(heroesTpl,function(heroes) return heroes[20]==9 end)


---Ǩ�ƶ���
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
-- SECTION  ���� �����̿���
function module:recruitTalked(npc, charIndex, seqno, select, data) 
  -- ע��: ��ע��data������, ����ű���Ҫ, ��data����tonumber����, �����Ҫ�ַ���ֵ, ����tonumber֮ǰ
  -- NOTE 60 Ӷ���������� 
  if seqno == 60 then
    if select == CONST.BUTTON_ȷ�� then
      if data ~= nil then
        data = tostring(data)
        if data == '' then
          NLG.TalkToCli(charIndex, -1, '���Q���ɞ��', 4, 1)
        else
          local heroData = sgModule:get(charIndex, "heroSelected");
          local heroIndex = heroData.index;
          local oriName = Char.GetData(heroIndex, CONST.����_����)
          self:renameHero(charIndex, heroData, data)
          NLG.TalkToCli(charIndex, -1, 'ⷰ顾' .. oriName .. '���Ѹ�����: ' .. data, 4, 1)
        end
      end
    end
  end

  if seqno == 61 then
    if CONST.BUTTON_ȷ�� then
      data = tonumber(data)
      if data then
        local heroData = sgModule:get(charIndex,"heroSelected");
        local heroIndex = heroData.index;
        local oriName = Char.GetData(heroIndex, CONST.����_����);
        local oriMetamo = Char.GetData(heroIndex, CONST.����_ԭʼͼ��);
        self:remetamoHero(heroIndex, data)
        NLG.TalkToCli(charIndex, -1, 'ⷰ顾' .. oriName .. '���������ɡ�' .. oriMetamo .. '��׃����: ��' .. data .. '��', 4, 1)
      else
        NLG.TalkToCli(charIndex, -1, 'Ոݔ�����_������̖(����)', 4, 1)
      end
    end
  end

  data=tonumber(data)
  if select == CONST.BUTTON_�ر� then
    return ;
  end

  -- NOTE  1 ��ļ
  if seqno== 1 and data>0 then
    -- ��ļӶ��
    if data==1 then
      self:showRecruitWindow(charIndex);
    end
    -- ����
    if data==2 then
      sgModule:set(charIndex,"heroListPage",1)
      self:showHeroListWindow(charIndex,1);
    end
  end
  -- NOTE  2 ѡ������ӵ�Ӷ��
  if seqno== 2 and data>0 then
    local heroesData = sgModule:get(charIndex,"heroes")
    if #heroesData>= 32 then
      NLG.SystemMessage(charIndex,"����ʾ�����͂�32��ⷰ顣")
      return
    end
    -- ���ݳ�ʼ��
    -- local randomHeroes = sgModule:get(charIndex,"randomHeroes")
    local toGetHeroData = heroesR[data]
    local toGetId = toGetHeroData[1]
    local isOwned = _.any(heroesData,function(heroData) return heroData.tplId == toGetId  end)
    if isOwned then
      NLG.Say(charIndex,self.shortcutNpc,"����ʾ��ⷰ顾"..toGetHeroData[2].."���ѽ��͂��ˡ�",CONST.��ɫ_��ɫ,4)
      return
    end
    local isAbleHire = toGetHeroData[17]==nil and true or toGetHeroData[17](charIndex)
    if not isAbleHire then
      return;
    end 

    local heroData = heroesFn:initHeroData(toGetHeroData,charIndex)
    table.insert(heroesData,heroData)
    sgModule:set(charIndex,"heroes",heroesData)

    NLG.SystemMessage(charIndex,"�µď���ⷰ�����ˣ����ԏ�����O���x�����")
  end
  --  NOTE  3 �����ʾӶ���б�
  if seqno == 3 then
    
    if data<0 then
      -- ѡ�������һҳ ��һҳ
      local page;
      if select == 32 then
        page =  sgModule:get(charIndex,"heroListPage")+1
        
      elseif select == 16 then
        page =  sgModule:get(charIndex,"heroListPage")-1
      end
      -- ������һ��
      if page ==0 then
        self:recruit(self.shortcutNpc,charIndex)
      end
      sgModule:set(charIndex,"heroListPage",page)
      self:showHeroListWindow(charIndex,page)
    else
      -- ѡ�����Ӷ��  �������Ӷ������
      self:showHeroOperationWindow(charIndex,data)
    end
    
    
  end
  --  SECTION 4 ���ѡ�� Ӷ���Ĳ���
  if seqno==4  then

    if data<0 then
      -- NOTE ���� Ӷ�� �б�ҳ
      if select == 16 then
        local page =  sgModule:get(charIndex,"heroListPage")
        self:showHeroListWindow(charIndex,page)
      end
    else
      --NOTE ����/����
      if data == 1 then
        self:handleCampaign(charIndex)
      end
      --NOTE �鿴״̬
      if data == 2 then
        self:showHeroDataWindow(charIndex)
      end
      --NOTE ���
      if data == 3 then
        self:showFireConfirmWindow(charIndex)
      end
    end
    
  end
  -- !SECTION
  -- NOTE 5 �鿴Ӷ��״̬
  if seqno ==5  then

    -- NOTE ���� Ӷ�� ����ҳ
    if select == 16 then
      local heroData = sgModule:get(charIndex,"heroSelected")
      self:reShowHeroOperationWindow(charIndex,heroData)
    end

  end

  --  SECTION  6 ������ҳ ѡ����
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
  --  NOTE  7 Ӷ�� ѡ���
  if seqno==7 and data>0 then
    self:showCampHeroOperationWindow(charIndex,data)
  end

  --  SECTION 8 Ӷ�� ����ѡ��
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
  -- NOTE 9 Ӷ�� ״̬ ����Ϣ��
  if seqno ==9 then
    -- ѡ�������һҳ ��һҳ
    local page;
    if select == 32 then
      page =  sgModule:get(charIndex,"statusPage")+1
      
    elseif select == 16 then
      page =  sgModule:get(charIndex,"statusPage")-1
    end
    sgModule:set(charIndex,"statusPage",page)
    self:showCampHeroDataWindow(charIndex,page)

  end
  -- NOTE 10 Ӷ�� ���� 
  if seqno ==10  then
    -- ѡ�������һҳ ��һҳ
    if data<0 then
      local page;
      if select == 32 then
        page =  sgModule:get(charIndex,"statusPage")+1
        
      elseif select == 16 then
        page =  sgModule:get(charIndex,"statusPage")-1
      end
      if page ==0 then
        -- ������һ��
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
  -- NOTE 11 ��� ���� ���
  if seqno ==11  then
    -- ѡ�������һҳ ��һҳ
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
  -- NOTE 13 Ӷ�������б�
  if seqno== 13 then
    if data<0 then
    else
      self:showPetOperationWindow(charIndex,data)
    end
  end
  -- SECTION 14 Ӷ������������
  if seqno== 14 then
    if data<0 then
    else
      if data == 1 then
        --NOTE ��������
        self:showPlayerPetWindow(charIndex,data)
      end
      if data == 2 then
        --NOTE ��ս/��Ϣ
        self:setPetDeparture(charIndex)
      end
      if data ==3 then
        --NOTE ����״̬
        sgModule:set(charIndex,"statusPage",1)
        self:showPetDataWindow(charIndex,1)
      end

    end
  end
  -- !SECTION
  -- NOTE 15 ��ҳ����б�
  if seqno== 15 then
    if data<0 then
    else
      self:switchPet(charIndex,data)
    end
  end
  -- NOTE 16 Ӷ������״̬ ��Ϣ��
  if seqno== 16 then
    -- ѡ�������һҳ ��һҳ
    local page;
    if select == 32 then
      page =  sgModule:get(charIndex,"statusPage")+1
      
    elseif select == 16 then
      page =  sgModule:get(charIndex,"statusPage")-1
    end
    sgModule:set(charIndex,"statusPage",page)
    self:showPetDataWindow(charIndex,page)
  end
  -- NOTE 17 Ӷ���ӵ� �����
  if seqno== 17 then
    
    -- ѡ�������һҳ ��һҳ
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
  -- NOTE 18 Ӷ��ս��AIѡ���
  if seqno== 18 then
    if data<0 then

    else
      -- ����Ӷ��ս������
      self:setHeroBattleSkill(charIndex,data)
    end

  end
  -- NOTE 19 ����ս��AIѡ���
  if seqno== 19 then
    if data<0 then
      -- ѡ�������һҳ ��һҳ
      local page;
      if select == 32 then
        page =  sgModule:get(charIndex,"statusPage")+1
        
      elseif select == 16 then
        page =  sgModule:get(charIndex,"statusPage")-1
      end
      sgModule:set(charIndex,"statusPage",page)
      self:showPetSkills(charIndex,page)
    else
      -- ���ó���ս������
      self:setPetBattleSkill(charIndex,data)
    end

  end
  -- NOTE 20 ���Ӷ��ȷ�ϴ��� 
  if seqno== 20 then
    if select == CONST.BUTTON_ȷ�� then
      self:fireHero(charIndex)
    else
    end

  end
  -- NOTE 22 ս��ӵ� �����
  if seqno== 22 then
    -- ѡ�������һҳ ��һҳ
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
  -- SECTION 23 Ӷ���ӵ���ҳ
  if seqno== 23 then
    if data<0 then
      -- ѡ�������һҳ ��һҳ
      if select == CONST.BUTTON_��һҳ then
        local heroData = sgModule:get(charIndex,"heroSelected")
        self:showCampHeroOperationWindow(charIndex,nil,heroData,1)
      end
    else
      -- NOTE Ӷ���ֶ��ӵ�
      if data == 1 then
        sgModule:set(charIndex,"statusPage",1)
        sgModule:set(charIndex,"pointSetting",{})
        self:showCampHeroSetPoint(charIndex,1)
      end
      -- NOTE �����ֶ��ӵ�
      if data == 2 then
        sgModule:set(charIndex,"statusPage",1)
        sgModule:set(charIndex,"pointSetting",{})
        self:showBattlePetSetPoint(charIndex,1)
      end
      -- NOTE Ӷ���Զ��ӵ�����
      if data == 3 then
        self:showAutoPointSelection(charIndex)
      end
      -- NOTE �����Զ��ӵ�����
      if data == 4 then
        self:showPetAutoPointSelection(charIndex)
      end
      -- NOTE ����/�ر�Ӷ���Զ��ӵ�
      if data ==5 then
        self:swtichAutoPointing(charIndex,0)
      end
      -- NOTE ����/�ر�ս���Զ��ӵ�
      if data ==6 then
        self:swtichAutoPointing(charIndex,1)
      end
    end
   
  end
  -- !SECTION
  -- NOTE 24 ѡ���˼ӵ�ģʽ
  if seqno== 24 then
    if data<0 then
      -- ѡ�������һҳ ��һҳ
      if select == CONST.BUTTON_��һҳ then
        self:showAutoPointSelection(charIndex)
      end
    else
      
      self:setAutoPionting(charIndex,data)
    end
    
  end
  -- NOTE 25 ѡ����ս��ӵ�ģʽ
  if seqno== 25 then
    if data<0 then
      -- ѡ�������һҳ ��һҳ
      if select == CONST.BUTTON_��һҳ then
        self:showAutoPointSelection(charIndex)
      end
    else
      
      self:setPetAutoPionting(charIndex,data)
    end
  end
  -- NOTE 26 ѡ����ˮ��
  if seqno== 26 then
    if data<0 then
      -- ѡ�������һҳ ��һҳ
      if select == CONST.BUTTON_��һҳ then
        -- ������һ��
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

-- !SECTION  ���� �����̿���


-- NOTE ��ʾ ��ļӶ�� �Ի��� seqno:2
function module:showRecruitWindow(charIndex) 
  local title="���x������Ո��ⷰ飺"
  local items={}

  for k,v in pairs(heroesR) do
    -- �����������  ְҵ: ְҵ����  �츳: 4���ַ�
    local tmpTable = {{v[2], 14},{" ��λ:",6},{v[3],10},{" Ʒ�|:",6},{v[15], 4}}
    local tmpStr = strExt.strParse(tmpTable);
    table.insert(items, tmpStr);
  end

  local windowStr = self:NPC_buildSelectionText(title,items);
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.����_ѡ���, CONST.BUTTON_�ر�, 2,windowStr);
end

-- NOTE �ƹ���ҳ �Ի��� seqno:1
function module:recruit(npc,charIndex)
  local windowStr = heroesFn:buildRecruitSelection()
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.����_ѡ���, CONST.BUTTON_�ر�, 1,windowStr);
end

-- NOTE  ��ʾӶ���б� seqno:3
function module:showHeroListWindow(charIndex,page)
  local title = "���ҵ�ⷰ��б�"
  -- Ӷ�� ���� ��ȡ
  local heroesData = sgModule:get(charIndex, "heroes")
  for idx = 1 , #heroesData do 
  end

  -- ��� Ӷ������Ϊ�б�
  local items = _.map(heroesData, function(data)
      return heroesFn:buildListForHero(data)
    end
  )

  -- ��ȡ ������ʾ��Ҫ������
  local buttonType,windowStr=self:dynamicListData(items,title,page)
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.����_ѡ���, buttonType, 3,windowStr);
end

-- NOTE ��̬�б���������
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
    buttonType=CONST.BUTTON_��ȡ��
  elseif page ==1 then
    buttonType=CONST.BUTTON_����ȡ��
  elseif page == totalPage then
    buttonType=CONST.BUTTON_��ȡ��
  else 
    buttonType = CONST.BUTTON_����ȡ��
  end
  return buttonType,windowStr
end

-- NOTE �״� ��ʾӶ������ ��� seqno: 4
function module:showHeroOperationWindow(charIndex,data)
  
  local heroesData=sgModule:get(charIndex,"heroes")
  local page = sgModule:get(charIndex,"heroListPage")
 
  local index = (page-1)*8+data
  local heroData = heroesData[index]
  
  -- ���� ѡ�е�hero id
  sgModule:set(charIndex,"heroSelected",heroData)
  local windowStr = heroesFn:buildOperatorForHero(heroData)
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.����_ѡ���, CONST.BUTTON_��ȡ��, 4,windowStr);
end

-- NOTE ���� ��ʾӶ������ ��� seqno: 4
function module:reShowHeroOperationWindow(charIndex,heroData)
  
  local heroData=  sgModule:get(charIndex,"heroSelected");
  -- local heroData = heroesFn:getHeroDataByid(charIndex,heroId)

  local windowStr = heroesFn:buildOperatorForHero(heroData)
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.����_ѡ���, CONST.BUTTON_��ȡ��, 4,windowStr);
end

-- NOTE ��ʾ Ӷ����ֵ seqno:5
function module:showHeroDataWindow(charIndex)
  local heroData=  sgModule:get(charIndex,"heroSelected");
  local windowStr = heroesFn:buildAttrDescriptionForHero(heroData)
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.����_����Ϣ��, CONST.BUTTON_��ȡ��, 5,windowStr);
end

-- NOTE ���� ����/����  ����Ӷ������ ��� 
function module:handleCampaign(charIndex)
  local heroData=  sgModule:get(charIndex,"heroSelected");
  if heroData.status == 1 then
    heroData.status=2
    -- ɾ��Ӷ��
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
    -- �ж��Ƿ���4��
    local count = _.reduce(heroesData, 0, 
      function(count, item) 
        if item.status == 1 then 
          return count+1
        end
        return count
      end)
    if count >=4 then
      NLG.Say(charIndex,self.shortcutNpc,"�����ⷰ鲻�ܳ��^4����",CONST.��ɫ_��ɫ,4)
    else
      heroData.status=1
      -- ���ɼ���
      heroesFn:generateHeroDummy(charIndex, heroData)
    end
    
  end
  local page =  sgModule:get(charIndex,"heroListPage")
  self:showHeroListWindow(charIndex,page)
end

-- NOTE ��½ʱ ����Ӷ�� ����
function module:onLoginEvent(charIndex)
  local heroesData = heroesFn:queryHeroesData(charIndex);
  heroesData= heroesData or {}  
  sgModule:set(charIndex,"heroes",heroesData)
  local campHeroesData=heroesFn:getCampHeroesData(charIndex)
  -- ��¼��ʼ  ���� ����Ӷ��
  _.each(campHeroesData,function(heroData) 
     heroesFn:generateHeroDummy(charIndex,heroData)
  end)
end

-- NOTE  �ǳ�ʱ �ұ���Ӷ�� ����
function module:onLogoutEvent(charIndex)
  local heroesData=sgModule:get(charIndex,"heroes")
  local campHeroesData=heroesFn:getCampHeroesData(charIndex)
  _.each(campHeroesData,function(heroData)
    if not Char.IsValidCharIndex(heroData.index) then
      print("��Ч��Ӷ����",heroData.index)
      return
    end
    --��������  ɾ�� ����  
    heroesFn:cacheHeroAttrData(heroData)
    heroesFn:cacheHeroItemData(heroData)
    heroesFn:cacheHeroPetsData(heroData)
    heroesFn:delHeroDummy(charIndex,heroData)
  end)
  heroesFn:saveHeroesData(charIndex,heroesData)
end
-- NOTE ����Ӷ������
function module:saveHeroesOnTime(charIndex)
  local heroesData=sgModule:get(charIndex,"heroes")
  local campHeroesData=heroesFn:getCampHeroesData(charIndex)
  _.each(campHeroesData,function(heroData) 
    if not Char.IsValidCharIndex(heroData.index) then
      print("��Ч��Ӷ����",heroData.index)
      return
    end
    --��������  ɾ�� ����  
    heroesFn:cacheHeroAttrData(heroData)
    heroesFn:cacheHeroItemData(heroData)
    heroesFn:cacheHeroPetsData(heroData)
  end)
  heroesFn:saveHeroesData(charIndex,heroesData)
end

-- NOTE ��ݼ�ctrl+2 ���� ����˵� 
function module:shortcut(charIndex, actionID)
  if actionID == %����_����% then
    self:management(self.shortcutNpc,charIndex);
  end
end

-- NOTE  ���� ��ҳ seqno:6
function module:management(npc, charIndex)
  local windowStr= heroesFn:buildManagementForHero(charIndex)
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.����_ѡ���, CONST.BUTTON_�ر�, 6, windowStr);
end

-- NOTE Ӷ����� and �ۼ�
function module:gatherHeroes(charIndex)
  local heroesData = sgModule:get(charIndex,"heroes")
  local Target_FloorId=Char.GetData(charIndex, CONST.����_��ͼ)
  local Target_MapId=Char.GetData(charIndex, CONST.����_��ͼ����)
  local Target_X=Char.GetData(charIndex, CONST.����_X)
  local Target_Y=Char.GetData(charIndex, CONST.����_Y)
  local campHeroes = _.select(heroesData,function(item) return item.status==1 end)
  for _,heroData in pairs(campHeroes) do
    local heroIndex  = heroData.index
    -- �ȴ�����
    -- �жϱ�������Ƿ�����
    local partyNum = Char.PartyNum(charIndex)
    if(partyNum>=5) then 
      NLG.SystemMessage(charIndex, "����ѝM��");	
      
      return 
    end
    
    if(heroIndex>0) then
      -- �������ߵض�������
      local invitedPartyNum = Char.PartyNum(heroIndex)

      if(invitedPartyNum>0) then
        NLG.SystemMessage(charIndex, "��"..heroesFn:getHeroName(heroData).."�����ǳ����B��");
      else
        -- ��һ������ ��Ա���ڶ��������ӳ�
        Char.Warp(heroIndex, Target_MapId, Target_FloorId, Target_X, Target_Y)
        Char.JoinParty(heroIndex, charIndex, true); 
      end

    end
  end
end

-- NOTE ��ʾ����Ӷ���б� seqno:7
function module:showCampHeroesList(charIndex)
  local windowStr = heroesFn:buildCampHeroesList(charIndex)
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.����_ѡ���, CONST.BUTTON_�ر�, 7,windowStr);
end

-- NOTE ��ʾӶ���Ĳ������ seqno:8
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
  -- ��ȡ job 
  local jobId = Char.GetData(heroIndex,CONST.����_ְҵ)
  --local jobName = getModule("gmsvData").jobs[tostring(jobId)][1]
  -- ��ȡ˵��
  local heroTplId = heroData.tplId
  local heroTplData = _.detect(heroesTpl,function(tpl) return tpl[1]==heroTplId end)
  local jobName = heroTplData[3];
  local title="��"..name.."��    ��"..heroTplData[15].."���� :"..jobName;

  local aiId1 = heroData.heroBattleTech or -1
  local aiData1 = _.detect(heroesAI.aiData,function(data) return data.id==aiId1 end)
  local name1=aiData1~=nil and aiData1.name or "δ�趨"

  local aiId2 = heroData.petBattleTech or -1
  local aiData2 = _.detect(heroesAI.aiData,function(data) return data.id==aiId2 end)
  local name2=aiData2~=nil and aiData2.name or "δ�趨"

  local list = {
    "ⷰ��B",
    "�����B",
    --"ˮ���x��",
    "���Q��Ʒ",
    "�h����Ʒ",
    "���c�O��",
    "ⷰ�AI�O��".."��"..name1.."��",
    "����AI�O��".."��"..name2.."��",
    --"ⷰ����",
    --"���Q����"
  }

  local buttonType, windowStr = self:dynamicListData(list, title, page)
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.����_ѡ���, buttonType, 8, windowStr);

  -- local windowStr = heroesFn:buildCampHeroOperator(charIndex,heroData)
  -- local buttonType = self:dynamicListData(items,title,page)
  -- NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.����_ѡ���, CONST.BUTTON_��ȡ��, 8, windowStr);
end


-- NOTE ��ʾ  ����Ӷ��״̬ seqno:9
function module:showCampHeroDataWindow(charIndex,page)
  local heroData=  sgModule:get(charIndex,"heroSelected");
  local windowStr = heroesFn:buildDescriptionForCampHero(heroData,page)
  local buttonType
  if page==1 then
    buttonType=CONST.BUTTON_��ȡ��
  else
    buttonType=CONST.BUTTON_��ȡ��
  end
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.����_����Ϣ��, buttonType, 9,windowStr);
end

--  NOTE ��ʾ ����Ӷ������ seqno:10
function module:showCampHeroItemWindow(charIndex,page)
  local heroData=  sgModule:get(charIndex,"heroSelected");
  local items=heroesFn:buildCampHeroItem(charIndex,heroData)
  local title="��" .. heroesFn:getHeroName(heroData) .. "������Ʒ"
  -- ��ȡ ������ʾ��Ҫ������
  local buttonType,windowStr=self:dynamicListData(items,title,page)
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.����_ѡ���, buttonType, 10,windowStr);
end


-- NOTE ѡ�� ����Ӷ������ 
function module:toSwitchItemWithPlayer(charIndex,data)
  local heroData=  sgModule:get(charIndex,"heroSelected");
  local statusPage = sgModule:get(charIndex,"statusPage");
  local heroItemSlotSelected = (statusPage-1)*8+data-1
  -- ��¼ ѡ���Ӷ�� slot
  sgModule:set(charIndex,"heroItemSlotSelected",heroItemSlotSelected);
  sgModule:set(charIndex,"playerPage",1)
  self:showPlayerItem(charIndex,1)
end

-- NOTE ɾ�� ѡ�е�Ӷ������
function module:delCampHeroItem(charIndex,data)
  local heroData=  sgModule:get(charIndex,"heroSelected");
  local statusPage = sgModule:get(charIndex,"statusPage");
  local heroItemSlotSelected = (statusPage-1)*8+data-1
  local r = Char.DelItemBySlot(heroData.index,heroItemSlotSelected)
  Item.UpItem(heroData.index,heroItemSlotSelected)
  self:showCampHeroItemWindow(charIndex,statusPage)
end


-- NOTE ��ʾ ��ұ������ߴ��� seqno:11
function module:showPlayerItem(charIndex,page)
  local items=heroesFn:buildPlayerItem(charIndex)
  local title="��" .. Char.GetData(charIndex,CONST.����_����) .. "������Ʒ"
  -- ��ȡ ������ʾ��Ҫ������
  local buttonType,windowStr=self:dynamicListData(items,title,page)
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.����_ѡ���, buttonType, 11,windowStr);
end

-- NOTE �����Ʒ��Ӷ������
function module:switchItem(charIndex,data)
  local heroData=  sgModule:get(charIndex,"heroSelected");
  local heroIndex=  heroData.index;
  local playerPage=  sgModule:get(charIndex,"playerPage")
  local playerSlot = (playerPage-1)*8+data+7
  local playerItemIndex =  Char.GetItemIndex(charIndex, playerSlot)
  
  local playerItemData= nil;
  -- ��ҵ���������ȡ
  if playerItemIndex>=0 then
    playerItemData= heroesFn:extractItemData(playerItemIndex);
    Char.DelItemBySlot(charIndex, playerSlot);

    local r = Char.GetEmptyItemSlot(heroIndex);
    if r<0 then
      NLG.SystemMessage(charIndex,"ⷰ鱳���ѝM��Ո������Ʒ�ڡ�")
      return
    end
  end
  
  -- Ӷ�� ���� ������ȡ
  local heroItemSlotSelected=sgModule:get(charIndex,"heroItemSlotSelected");
  local heroItemIndex =  Char.GetItemIndex(heroIndex, heroItemSlotSelected)
  local heroItemData= nil;
  if heroItemIndex>=0 then
    heroItemData= heroesFn:extractItemData(heroItemIndex);
    Char.DelItemBySlot(heroIndex, heroItemSlotSelected);
  end
  
  -- ��Ӷ������ ������� 
  if heroItemData~=nil then
    local itemId = heroItemData[tostring(CONST.����_ID)]
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
  -- ����ҵ��߸�Ӷ��
  if playerItemData~= nil then
    
  
    local itemId = playerItemData[tostring(CONST.����_ID)]
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
  -- ��ɺ� ��ʾӶ������
  local page = sgModule:get(charIndex,"statusPage")
  self:showCampHeroItemWindow(charIndex,page)
end


-- NOTE ��ʾӶ������ seqno:13
function module:showCampHeroPetWindow(charIndex)
  local heroData=  sgModule:get(charIndex,"heroSelected");
  local windowStr=heroesFn:buildCampHeroPets(heroData)
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.����_ѡ���, CONST.BUTTON_��ȡ��, 13,windowStr);
end

-- NOTE ��ʾ ���������� seqno:14
function module:showPetOperationWindow(charIndex,data)
  local heroPetSlotSelected = tonumber(data)-1
  -- ��¼ ѡ��ĳ��� slot
  sgModule:set(charIndex,"heroPetSlotSelected",heroPetSlotSelected);
  local heroData=  sgModule:get(charIndex,"heroSelected");
  local windowStr=  heroesFn:buildCampHeroPetOperator(charIndex,heroData)
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.����_ѡ���, CONST.BUTTON_��ȡ��, 14,windowStr);
end

-- NOTE  ��ʾ��ҳ��� seqno:15
function module:showPlayerPetWindow(charIndex)
  local windowStr=heroesFn:buildPlayerPets(charIndex)
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.����_ѡ���, CONST.BUTTON_��ȡ��, 15,windowStr);
end

-- NOTE �������� 
function module:switchPet(charIndex,data)
  local heroData=  sgModule:get(charIndex,"heroSelected");
  local heroIndex = heroData.index
  local heroPetSlot =sgModule:get(charIndex,"heroPetSlotSelected");
  local heroPetIndex = Char.GetPet(heroIndex,heroPetSlot)
  local playerPetSlot = tonumber(data)-1
  local playerPetIndex = Char.GetPet(charIndex,playerPetSlot)

  if heroPetIndex >=0 then
    if Char.GetEmptyPetSlot(charIndex) < 0 then
      NLG.SystemMessage(charIndex,"��Č���ڝM�ˡ�")
      return;
    end
    -- ��Ӷ����������
    local r= Char.TradePet(heroIndex, heroPetSlot, charIndex)
    if r<0 then
      NLG.SystemMessage(charIndex,"��")
      return;
    end
    Pet.UpPet(charIndex,heroPetIndex)
  end
  -- ����ҳ����Ӷ��

  if playerPetIndex>=0 then
    local r= Char.TradePet(charIndex, playerPetSlot, heroIndex)
    if r<0 then
      NLG.SystemMessage(charIndex,"��ҵČ���ڝM�ˡ�")
      return;
    end
    Pet.UpPet(heroIndex,playerPetIndex)
  end

  --  ��ɺ󣬷��� Ӷ�������б�ҳ
  self:showCampHeroPetWindow(charIndex)
end

-- NOTE ��ʾ  ����״̬���� seqno:16
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
    buttonType=CONST.BUTTON_��ȡ��
  else
    buttonType=CONST.BUTTON_��ȡ��
  end
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.����_����Ϣ��, buttonType, 16,windowStr);
end

-- NOTE ���ó����ս״̬
function module:setPetDeparture(charIndex)
  local heroData=  sgModule:get(charIndex,"heroSelected");
  local heroIndex = heroData.index
  local heroPetSlot =sgModule:get(charIndex,"heroPetSlotSelected");
  local heroPetIndex = Char.GetPet(heroIndex,heroPetSlot)
  local status =  Char.GetData(heroPetIndex, CONST.PET_DepartureBattleStatus);
  if status == CONST.PET_STATE_ս�� then
    Char.SetPetDepartureState(heroIndex,heroPetSlot,CONST.PET_STATE_����)
  else
    Char.SetPetDepartureState(heroIndex,heroPetSlot,CONST.PET_STATE_ս��)
  end

end

-- NOTE ��ʾ ����Ӷ�� �ӵ� seqno:17
function module:showCampHeroSetPoint(charIndex,page)
  local heroData=  sgModule:get(charIndex,"heroSelected");
  local heroIndex = heroData.index

  local windowStr=heroesFn:buildSetPoint(charIndex,heroIndex,page)
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.����_�����, CONST.BUTTON_����ȡ��, 17,windowStr);
end

-- NOTE ���üӵ�
function module:setPoint(charIndex,heroIndex)
  local heroData=  sgModule:get(charIndex,"heroSelected");
  local heroIndex = heroData.index
  heroesFn:setPoint(charIndex,heroIndex)
end

-- NOTE ��ʾ���� ս��ӵ� seqno:22
function module:showBattlePetSetPoint(charIndex,page)
  local heroData=  sgModule:get(charIndex,"heroSelected");
  local heroIndex = heroData.index
  local petSlot = Char.GetData(heroIndex, CONST.����_ս��);
  if petSlot<0 then
    NLG.Say(charIndex,self.shortcutNpc,"Ո���O�ó������",CONST.��ɫ_��ɫ,4)
    return
  end
  petIndex = Char.GetPet(heroIndex, petSlot);

  local windowStr=heroesFn:buildSetPoint(charIndex,petIndex,page)
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.����_�����, CONST.BUTTON_����ȡ��, 22,windowStr);
end

-- NOTE ���ó���ӵ�
function module:setPetPoint(charIndex)
  local heroData=  sgModule:get(charIndex,"heroSelected");
  local heroIndex = heroData.index
  local petSlot = Char.GetData(heroIndex, CONST.����_ս��);
  if petSlot<0 then
    NLG.Say(charIndex,self.shortcutNpc,"Ո���O�ó������",CONST.��ɫ_��ɫ,4)
    return
  end
  petIndex = Char.GetPet(heroIndex, petSlot);

  heroesFn:setPoint(charIndex,petIndex)
end

-- NOTE ս����ʼ�¼�
function module:onBattleStart(battleIndex)
  for pos=0,19 do
		local charIndex = Battle.GetPlayer(battleIndex,pos);
		if charIndex<0 then
      return
    end
    if (Char.GetData(charIndex,%����_��%) == %��������_��%) and (not Char.IsDummy(charIndex)) then
      -- ��ȡ �������ڵ�ͼ 
      local Target_FloorId=Char.GetData(charIndex, CONST.����_��ͼ)
      local Target_MapId=Char.GetData(charIndex, CONST.����_��ͼ����)
      local Target_X=Char.GetData(charIndex, CONST.����_X)
      local Target_Y=Char.GetData(charIndex, CONST.����_Y)
      local campHeroesData = heroesFn:getCampHeroesData(charIndex) or {}
      _.each(campHeroesData,function(heroData) 
        local heroIndex = heroData.index
        local floor=Char.GetData(heroIndex, CONST.����_��ͼ)
        local mapId=Char.GetData(heroIndex, CONST.����_��ͼ����)
        if floor ~= Target_FloorId or mapId ~= Target_MapId then
          Char.Warp(heroIndex, Target_MapId, Target_FloorId, Target_X, Target_Y)
        end

      end)
    end
		
	end
end

-- NOTE ս�����غϿ�ʼ ս��ָ��
function module:handleDummyCommand(battleIndex)
  local poss={}
  for i = 0, 19 do
    table.insert(poss,i)
  end
  _.each(poss,function(pos) 
    local dummyIndex = Battle.GetPlayer(battleIndex, pos);
    -- ��������ˣ��˳�
    if dummyIndex < 0 then
      return
    end
    -- ������Ǽ��ˣ��˳�
    if not Char.IsDummy(dummyIndex) then
      return
    end
    -- �������Ӷ�� ���˳�
    local heroesOnline=sgModule:getGlobal("heroesOnline")
    if not heroesOnline[dummyIndex] then
      return
    end
    local heroData = heroesOnline[dummyIndex]
    -- ��� owner���ڱ���ս�����˳�ս��
    local ownerIndex= heroData.owner
    local ownerSlot = Battle.GetSlot(battleIndex,ownerIndex)

    if ownerSlot<0  then
      Battle.ExitBattle(dummyIndex);
      return
    end
    -- ��������ڵȴ�����˳�
    local isWaiting =Battle.IsWaitingCommand(dummyIndex)
    if isWaiting ~=1 then
      return 
    end
    local side=0
    if pos>9 then
      side=1
    end 

    -- ��ȡ ai
    local heroesOnline = sgModule:getGlobal("heroesOnline")

    local aiId = heroData.heroBattleTech
    local aiData =  _.detect(heroesAI.aiData,function(data) return data.id==aiId end)
    local commands=aiData ==nil and {} or aiData.commands
    local actionData = heroesAI:calcActionData(dummyIndex,side,battleIndex,pos,commands)
    
    -- ��һ������
    Battle.ActionSelect(dummyIndex, actionData[1],actionData[2] , actionData[3]);

    -- ��ȡ�����
    local petSLot = math.fmod(pos + 5, 10)+side*10;
    local petIndex = Battle.GetPlayer(battleIndex, petSLot);
    
    if petIndex<0 then
      -- �ڶ�����ͨ����Է�Ѫ���ٵ�
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
-- NOTE ��ȡ ��Ϊ����
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
-- NOTE �����¼�
function module:handleWarpEvent(charIndex,Ori_MapId, Ori_FloorId, Ori_X, Ori_Y, Target_MapId, Target_FloorId, Target_X, Target_Y)
  return 0
end
-- NOTE ���ͺ��¼�
function module:handleAfterWarpEvent(charIndex,Ori_MapId, Ori_FloorId, Ori_X, Ori_Y, Target_MapId, Target_FloorId, Target_X, Target_Y)
  -- ����Ǽ��� �˳�
  if Char.IsDummy(charIndex) then
    return 0;
  end
  local campHeroesData = heroesFn:getCampHeroesData(charIndex) or {}
  
  _.each(campHeroesData,function(heroData) 
    local heroIndex = heroData.index;
    local battleIndex= Char.GetData(heroIndex, CONST.����_BattleIndex)
    
    
    if battleIndex>=0 then
      if Char.GetData(heroIndex, CONST.����_ս����) > 0 and Battle.GetWinSide(battleIndex)==-1 then
        Battle.ExitBattle(heroIndex);
      end
    end

    local partyNum = Char.PartyNum(charIndex)
    if(partyNum>=5) then 	
      return 0
    end

    local invitedPartyNum = Char.PartyNum(heroIndex)
    if invitedPartyNum<=0  then
      -- ��һ������ ��Ա���ڶ��������ӳ�
      Char.Warp(heroIndex, Target_MapId, Target_FloorId, Target_X, Target_Y)
      Char.JoinParty(heroIndex, charIndex, true); 
    end

  end)
  return 0;
end
-- NOTE ����
function module:heal(charIndex)
  local campHeroesData = heroesFn:getCampHeroesData(charIndex);
  
  _.each(campHeroesData,function(heroData) 
    heroesFn:heal(charIndex,heroData.index)
    -- ���� ����
    for heroPetSlot = 0,4 do
      local petIndex = Char.GetPet(heroData.index,heroPetSlot)
      if petIndex>=0 then
        heroesFn:heal(charIndex,petIndex)
      end
    end
    NLG.UpChar(heroData.index);
  end)
  heroesFn:heal(charIndex,charIndex)
  -- ���� ����
  for heroPetSlot = 0,4 do
    local petIndex = Char.GetPet(charIndex,heroPetSlot)
    if petIndex>=0 then
      heroesFn:heal(charIndex,petIndex)
    end
  end
  NLG.UpChar(charIndex);
end
-- NOTE Ӷ��������� seq:18
function module:showCampHeroSkills(charIndex,page)
  local heroData=  sgModule:get(charIndex,"heroSelected");
  local skills = heroData.skills;
  local windowStr=heroesFn:buildCampHeroSkills(charIndex,skills)
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.����_ѡ���, CONST.BUTTON_��ȡ��, 18,windowStr);
end

-- NOTE ����Ӷ��AI
function module:setHeroBattleSkill(charIndex,data)
  local heroData=  sgModule:get(charIndex,"heroSelected");
  local heroIndex = heroData.index
  local aiId = heroData.skills[data]
  if aiId==nil or  aiId<0 then
    NLG.SystemMessage(charIndex,"Ո�x����Ч��AI��")
    return  
  end
  local aiData = _.detect(heroesAI.aiData,function(ai) return ai.id==aiId end)
  -- print('>>>',aiData);
  local name=aiData.name
  heroData.heroBattleTech = aiId;
  NLG.SystemMessage(charIndex,"ӛ���ɣ�ⷰ�đ��YAI�ǣ�"..name)
end

-- NOTE ��ʾ���＼���б� seqno:19
function module:showPetSkills(charIndex,page)
  local heroData=  sgModule:get(charIndex,"heroSelected");
  local petSkills = heroData.petSkills;
  local windowStr=heroesFn:buildCampHeroSkills(charIndex,petSkills)
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.����_ѡ���, CONST.BUTTON_��ȡ��, 19,windowStr);
end

-- NOTE ���� ����AI
function module:setPetBattleSkill(charIndex,data)

  local heroData=  sgModule:get(charIndex,"heroSelected");
  local heroIndex = heroData.index
  local aiId = heroData.petSkills[data]
  if aiId==nil or  aiId<0 then
    NLG.SystemMessage(charIndex,"Ո�x����Ч�ļ��ܡ�")
    return  
  end
  local aiData = _.detect(heroesAI.aiData,function(ai) return ai.id==aiId end)
  local name = aiData.name
  heroData.petBattleTech = aiId;
  NLG.SystemMessage(charIndex,"ӛ���ɣ�����đ��YAI�ǣ�"..name)
end

-- NOTE ���Ӷ��
function module:fireHero(charIndex)
  local heroData=  sgModule:get(charIndex,"heroSelected");
  heroesFn:deleteHeroData(charIndex,heroData)
  local page =  sgModule:get(charIndex,"heroListPage")
  self:showHeroListWindow(charIndex,page)
end

-- NOTE ���ȷ�ϴ��� seqno:20
function module:showFireConfirmWindow(charIndex)
  local heroData = sgModule:get(charIndex,"heroSelected");
  local windowStr="\n\n�Ｔ��ǲɢⷰ飺��"..heroesFn:getHeroName(heroData).."��"
  .."\n\n��ǲɢ���ⷰ��ʧȥ���Ќ��ԣ��b���c���"
  .."\n\n��������_��ǲɢ��ⷰ�᣿��������"
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.����_��Ϣ��, CONST.BUTTON_ȷ���ر�, 20, windowStr);

end

-- DONE Ӷ������
function module:renameHero(charIndex, heroData, newName)
  local heroIndex = heroData.index;
  Char.SetData(heroIndex, CONST.����_����, newName)
  
  -- DONE: ��Ҫͬ���޸�heroData.name heroData.trueName
  heroData.name = newName;
  heroData.trueName = newName;
  heroesFn:saveHeroData(charIndex, heroData)
  
  NLG.UpChar(heroIndex)
end

-- DONE: Ӷ���������� seqno:60
function module:showRename(charIndex)
  local heroData=  sgModule:get(charIndex, "heroSelected");
  local heroIndex = heroData.index;
  -- ��ȡ job 
  local jobId = Char.GetData(heroIndex,CONST.����_ְҵ)
  local jobName = getModule("gmsvData").jobs[tostring(jobId)][1]
  -- ��ȡ˵��
  local heroTplId = heroData.tplId
  local heroTplData = _.detect(heroesTpl,function(tpl) return tpl[1]==heroTplId end)
  local oriName = Char.GetData(heroIndex, CONST.����_����)

  local windowStr="����" .. heroTplData[15] .. "����" .. oriName .."�������I��" .. jobName .. "\n\n��\n��Ոݔ���µ����֣�\n\n"

  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.����_�����, CONST.BUTTON_ȷ���ر�, 60, windowStr);
end


function module:remetamoHero(charIndex, newMetamo)
  Char.SetData(charIndex, %����_����%, newMetamo)
  Char.SetData(charIndex, %����_ԭ��%, newMetamo)
  NLG.UpChar(charIndex)
end

-- DONE Ӷ�������󴰿� seqno:61
function module:showRemetamo(charIndex)
  local heroData=  sgModule:get(charIndex, "heroSelected");
  local heroIndex = heroData.index;
  -- ��ȡ job 
  local jobId = Char.GetData(heroIndex,CONST.����_ְҵ)
  local jobName = getModule("gmsvData").jobs[tostring(jobId)][1]
  -- ��ȡ˵��
  local heroTplId = heroData.tplId
  local heroTplData = _.detect(heroesTpl,function(tpl) return tpl[1]==heroTplId end)
  local oriName = Char.GetData(heroIndex, CONST.����_����)
  local oriMetamo = Char.GetData(heroIndex, %����_����%)


  local windowStr="����" .. heroTplData[15] .. "����" .. oriName .."�������I��" .. jobName
  .. "\n\n  Ո���ñ�����, ����̖Ո���в�ԃ"
  .. "\n\n����ǰ����̖:" .. oriMetamo 
  .. "\n\n��Ոݔ���µ�����̖��\n\n"
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.����_�����, CONST.BUTTON_ȷ���ر�, 61, windowStr);
end

-- TODO: Ӷ��������ȷ�ϴ��� seqno:62
function module:showRemetamoOK(charIndex, newMetamo)
  local windowStr = "@g,"..newMetamo..",1,4,4,1@���µ������:"..newMetamo.."";
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST["����_��Ϣ��"], CONST.BUTTON_ȷ��ȡ��, 62, windowStr);
end

-- NOTE  Ӷ�������¼�
function module:onLevelUpEvent(charIndex)
  local name = Char.GetData(charIndex,CONST.����_����)
  --logInfo("herolevelup",name,Char.GetData(charIndex,CONST.����_��))

  -- ������Ǽ��ˣ��˳�
  if not Char.IsDummy(charIndex) then
    return
  end
  -- �������Ӷ�� ���˳�
  local heroesOnline=sgModule:getGlobal("heroesOnline")
  local heroData = heroesOnline[charIndex]
  if not heroesOnline[charIndex] then
    return
  end

  -- ��ȡ heroTpl ���� ִ�������ص�����
  local heroTplId = heroData.tplId
  local heroTplData = _.detect(heroesTpl,function(tpl) return tpl[1]==heroTplId end)
  if heroTplData== nil then
    NLG.SystemMessage(charIndex,"�e�`��ⷰ顣")
  end
  if heroTplData and  heroTplData[16] ~= nil then
    -- �����charIndex
    heroTplData[16](charIndex)
  end

  -- �ر����Զ��ӵ㣬�˳�
  if heroData.isAutoPointing == 0 then
    return
  end
  local levelUpPoint = Char.GetData(charIndex,CONST.����_������)
  local times,rest = math.modf(levelUpPoint/4)
  
  for i=1,times+1 do
    heroesFn:autoPoint(charIndex,heroData.autoPointing)
  end

  --NLG.SystemMessage(heroData.owner,name.."�ȼ��������ԄӼ��c��"..(heroData.autoPointing))
end

-- NOTE ս�������¼�
function module:onPetLevelUpEvent(charIndex,petIndex)
  local name = Char.GetData(charIndex,CONST.����_����)
  --logInfo("petlevelup",name,Char.GetData(charIndex,CONST.����_��))

  -- �������Ӷ�� ���˳�
  local heroesOnline=sgModule:getGlobal("heroesOnline")
  if not heroesOnline[charIndex] then
    return
  end
  local heroData = heroesOnline[charIndex]
  local heroIndex = heroData.index;

  -- �ر����Զ��ӵ㣬�˳�
  if heroData.isPetAutoPointing == 0 then
    return
  end

  local petSlot = Char.GetData(heroIndex, CONST.����_ս��);
  if petSlot<0 then
    NLG.Say(charIndex,-1,"[��ʾ]�Ҳ������",CONST.��ɫ_��ɫ,4)
    return
  end

  local petIndex = Char.GetPet(heroIndex, petSlot);
  -- Char.SetLoopEvent(nil, 'petlevelupLoop', petIndex, 0);
  local heroIndex=  Pet.GetOwner(petIndex)
  local name = Char.GetData(heroIndex,CONST.����_����)
  local heroesOnline=sgModule:getGlobal("heroesOnline")
  local heroData = heroesOnline[heroIndex]
  local petSlot = Char.GetData(heroIndex, CONST.����_ս��);
  
  local petName=Char.GetData(petIndex,CONST.����_����)
  -- �����Զ��ӵ�
  local levelUpPoint = Char.GetData(petIndex,CONST.����_������)
  local times,rest = math.modf(levelUpPoint/1)
  
  for i=1,times+1 do
    getModule('heroesFn'):autoPoint(petIndex,heroData.petAutoPointing)
  end
  
  --NLG.SystemMessage(heroData.owner,name.."�Č��"..petName.."���ȼ��������ԄӼ��c��"..(heroData.petAutoPointing))
end

-- NOTE ս�������¼�
function module:onCalcFpConsumeEvent(charIndex,techId,fpConsume)
  -- local name = Char.GetData(charIndex,CONST.����_����)
  -- logInfo("ս������",name,charIndex,techId,fpConsume)
  local heroesOnline=sgModule:getGlobal("heroesOnline")
  local heroData = heroesOnline[charIndex]
  -- �������Ӷ�� ���˳�
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

-- NOTE �Ҽ�����¼�
function module:onRightClickEvent(charIndex, dummyIndex)
    -- ������Ǽ��ˣ��˳�
    if not Char.IsDummy(dummyIndex) then
      return
    end

    -- �������Ӷ�� ���˳�
    local heroesOnline=sgModule:getGlobal("heroesOnline")
    local heroData = heroesOnline[dummyIndex]
    if not heroesOnline[dummyIndex] then
      return
    end

    -- Ӷ����owner
    if heroData.owner ~= charIndex then
      return
    end

    self:showCampHeroOperationWindow(charIndex,nil,heroData,1)

end

-- NOTE ��ʾ����һ�� seqno:21
function module:showPartyStatus(charIndex)
  
  local windowStr = heroesFn:buildDescriptionForParty(charIndex)
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.����_����Ϣ��, CONST.BUTTON_�ر�, 21,windowStr);
end

-- NOTE Ӷ���ӵ���ҳ seqno:23
function module:showHeroOperationSecWindow(charIndex)
  local heroData = sgModule:get(charIndex,"heroSelected")
  local windowStr = heroesFn:buildHeroOperationSecWindow(charIndex,heroData)
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.����_ѡ���, CONST.BUTTON_��ȡ��, 23,windowStr);
end

-- NOTE ��ʾ�ӵ�ģʽѡ�� seqno:24
function module:showAutoPointSelection(charIndex)
  local windowStr=heroesFn:buildAutoPointSelect(0);
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.����_ѡ���, CONST.BUTTON_��ȡ��, 24,windowStr);
end
-- NOTE ��ʾս��ӵ�ģʽѡ�� seqno:25
function module:showPetAutoPointSelection(charIndex)
  local windowStr=heroesFn:buildAutoPointSelect(1);
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.����_ѡ���, CONST.BUTTON_��ȡ��, 25,windowStr);
end

-- NOTE ����Ӷ���Զ��ӵ�ģʽ
function module:setAutoPionting(charIndex,data)

  local heroData = sgModule:get(charIndex,"heroSelected");

  heroesFn:setAutoPionting(charIndex,heroData,data)
  local name = Char.GetData(heroData.index,CONST.����_����)
  NLG.SystemMessage(charIndex,name.."׃�����ԄӼ��c������")
  self:showHeroOperationSecWindow(charIndex)
end

-- NOTE ����ս���Զ��ӵ�ģʽ
function module:setPetAutoPionting(charIndex,data)
  local heroData = sgModule:get(charIndex,"heroSelected");
  heroesFn:setPetAutoPionting(charIndex,heroData,data)
  local name = Char.GetData(heroData.index,CONST.����_����)
  NLG.SystemMessage(charIndex,name.."׃���ˌ�����ԄӼ��c������")
  self:showHeroOperationSecWindow(charIndex)
end

-- NOTE ����/�ر� �Զ��ӵ�
-- params type: 0��Ӷ����1������
function module:swtichAutoPointing(charIndex,type)
  local heroData = sgModule:get(charIndex,"heroSelected");
  if type==0 then
    if heroData.autoPointing==nil then
      NLG.SystemMessage(charIndex,"Ո���O��ⷰ���ԄӼ��c������")
      return;
    end
    heroData.isAutoPointing=heroData.isAutoPointing==0 and 1 or 0
  elseif type ==1 then
    if heroData.petAutoPointing==nil then
      NLG.SystemMessage(charIndex,"Ո���O�Ì�����ԄӼ��c������")
      return;
    end
    heroData.isPetAutoPointing=heroData.isPetAutoPointing==0 and 1 or 0
  end
  self:showHeroOperationSecWindow(charIndex)
end

-- NOTE ��ʾˮ������ seqno:26
function module:showCrystalSelection(charIndex)
  local items={"�،���ˮ��","ˮ����ˮ��","������ˮ��","�L����ˮ��"}
  local title="�x��ˮ����"
  local windowStr = self:NPC_buildSelectionText(title,items);
  NLG.ShowWindowTalked(charIndex, self.shortcutNpc, CONST.����_ѡ���, CONST.BUTTON_��ȡ��, 26,windowStr);
end

-- ����ˮ��
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

-- NOTE �����ȡ�¼�
function module:onGetExpEvent(charIndex,exp)

end

-- NOTE �������̿���
function module:skillNpcTalked(npc, charIndex, seqno, select, data)
  data=tonumber(data)
  if select == CONST.BUTTON_�ر� then
    return ;
  end
  -- NOTE  1 Ӷ���б�
  if seqno== 1 and data>0 then
    self:showSkills(charIndex,data)
  end
  --  NOTE  2 ѡ����
  if seqno==2  then
    -- ѡ�������һҳ ��һҳ
    if data<0 then

    else
      self:showCampHeroSkillSlot(charIndex,data)
    end
  end
  -- NOTE  3 ����ѡ����
  if seqno== 3 and data>0 then
    self:getSkill(charIndex,data)
  end
end

-- NOTE Ӷ��ѡ�� ��ҳ seqno:1
function module:showSkillNpcHome(npc,charIndex)
  local windowStr = heroesFn:buildCampHeroesList(charIndex)
  NLG.ShowWindowTalked(charIndex, self.skillNpc, CONST.����_ѡ���, CONST.BUTTON_�ر�, 1,windowStr);
end
-- NOTE ѡ���� seqno:2
function module:showSkills(charIndex,data,heroData)
  if data~= nil and heroData == nil then
    local campHeroes = heroesFn:getCampHeroesData(charIndex)
    heroData = campHeroes[data]
    sgModule:set(charIndex,"heroSelected4skill",heroData)
  end
  local heroIndex= heroData.index;
  local skillLv = math.ceil(Char.GetData(heroIndex,CONST.����_�ȼ�)/10) 
  
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
  local title="Ո�x����"
  local windowStr=  self:NPC_buildSelectionText(title,items);
  
  NLG.ShowWindowTalked(charIndex, self.skillNpc, CONST.����_ѡ���, CONST.BUTTON_��ȡ��,2,windowStr);
end

-- NOTE ��ʾӶ�������� seqno:3
function module:showCampHeroSkillSlot(charIndex,data)
  local techId = (sgModule:get(charIndex,"techIdsAbleToGet"))[data];
  sgModule:set(charIndex,"skillSelected",techId);
  local heroData=  sgModule:get(charIndex,"heroSelected4skill");
  local windowStr=heroesFn:buildCampHeroSkills(charIndex,heroData)
  NLG.ShowWindowTalked(charIndex, self.skillNpc, CONST.����_ѡ���, CONST.BUTTON_��ȡ��, 3,windowStr);

end

-- NOTE ִ�еǼǼ���
function module:getSkill(charIndex,data)
  local techId = sgModule:get(charIndex,"skillSelected");
  local heroData=  sgModule:get(charIndex,"heroSelected4skill");
  if heroData.skills == nil then
    heroData.skills={nil,nil,nil,nil,nil,nil,nil,nil} 
  end
  heroData.skills[data]=techId
  local name = Char.GetData(heroData.index,CONST.����_����)
  NLG.SystemMessage(charIndex,name.."����ӛ䛳ɹ���")
end

-- !SECTION 
--- NOTE ����ģ�鹳��
function module:onLoad()
  self:logInfo('load')
  -- ��reload ������module
  reloadModule("autoBattleParams")
  reloadModule("heroesFn")
  
  self:regCallback('CharActionEvent', Func.bind(self.shortcut, self))
  -- npc 
  self.shortcutNpc = self:NPC_createNormal('ⷰ鼯�Y', 231048, { x = 29, y = 29, mapType = 0, map = 7351, direction = 4 });
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

--- NOTE ж��ģ�鹳��
function module:onUnload()
  self:logInfo('unload')
end

return module;
