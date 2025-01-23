local module = ModuleBase:createModule('heroCall')
local heroesTpl = dofile("lua/Modules/heroesTpl.lua")
local _ = require "lua/Modules/underscore"

function module:heroCallInit(charIndex,targetIndex,itemSlot)
  -- 获取 itemIndex
  local itemIndex = Char.GetItemIndex(charIndex, itemSlot);
  if itemIndex < 0 then
    NLG.Say(charIndex,-1,"【錯誤】未找到道具！",CONST.颜色_红色,4)
    return 
  end
  
  local itemSepType = Item.GetData(itemIndex,CONST.道具_特殊类型)
  if tonumber(itemSepType) ~=  50 then
    NLG.Say(charIndex,-1,"【錯誤】道具的特殊功能類型設置錯誤！",CONST.颜色_红色,4)
    return 
  end

  local heroTplId = Item.GetData(itemIndex,CONST.道具_子参一)
  print('heroTplId', heroTplId);
  if heroTplId == 999 then
    print('!!!!!!')
    return
  end

  -- print(heroTplId,type(heroTplId),itemSepType)
  local toGetHeroData = _.detect(heroesTpl,function(heroes) return heroes[1]==heroTplId  end)

  local heroesData = getModule('setterGetter'):get(charIndex,"heroes")

  if #heroesData>=32 then
    NLG.Say(charIndex,-1,"【提示】最多雇傭32名傭兵。",CONST.颜色_红色,4)
    return
  end

  local toGetId = toGetHeroData[1]
  local isOwned = _.any(heroesData,function(heroData) return heroData.tplId == toGetId  end)
  if isOwned then
    NLG.Say(charIndex,-1,"【提示】夥伴【"..toGetHeroData[2].."】已經召喚了。",CONST.颜色_红色,4)
    return
  end
  local isAbleHire = toGetHeroData[17]==nil and true or toGetHeroData[17](charIndex)
  if not isAbleHire then
    return;
  end 
  local itemId = Item.GetData(itemIndex,CONST.道具_ID);
  
  if(Char.DelItem(charIndex,itemId,1) < 0) then
    NLG.Say(charIndex,-1,"【系統】未知原因導致物品刪除失敗！",CONST.颜色_红色,4)
    return;
  end
  local heroData = getModule('heroesFn'):initHeroData(toGetHeroData,charIndex)
  table.insert(heroesData,heroData)
  getModule('setterGetter'):set(charIndex,"heroes",heroesData)
  NLG.SystemMessage(charIndex,"新的強力夥伴加入了，可以從隊伍設置選擇出戰。")


end


--- 加载模块钩子
function module:onLoad()
  self:logInfo('load')
  self:regCallback('ItemString', Func.bind(self.heroCallInit, self),"LUA_useHeroCall");

end

--- 卸载模块钩子
function module:onUnload()
  self:logInfo('unload')
end

return module
