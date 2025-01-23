local module = ModuleBase:createModule('heroCall')
local heroesTpl = dofile("lua/Modules/heroesTpl.lua")
local _ = require "lua/Modules/underscore"

function module:heroCallInit(charIndex,targetIndex,itemSlot)
  -- ��ȡ itemIndex
  local itemIndex = Char.GetItemIndex(charIndex, itemSlot);
  if itemIndex < 0 then
    NLG.Say(charIndex,-1,"���e�`��δ�ҵ����ߣ�",CONST.��ɫ_��ɫ,4)
    return 
  end
  
  local itemSepType = Item.GetData(itemIndex,CONST.����_��������)
  if tonumber(itemSepType) ~=  50 then
    NLG.Say(charIndex,-1,"���e�`�����ߵ����⹦������O���e�`��",CONST.��ɫ_��ɫ,4)
    return 
  end

  local heroTplId = Item.GetData(itemIndex,CONST.����_�Ӳ�һ)
  print('heroTplId', heroTplId);
  if heroTplId == 999 then
    print('!!!!!!')
    return
  end

  -- print(heroTplId,type(heroTplId),itemSepType)
  local toGetHeroData = _.detect(heroesTpl,function(heroes) return heroes[1]==heroTplId  end)

  local heroesData = getModule('setterGetter'):get(charIndex,"heroes")

  if #heroesData>=32 then
    NLG.Say(charIndex,-1,"����ʾ�����͂�32�������",CONST.��ɫ_��ɫ,4)
    return
  end

  local toGetId = toGetHeroData[1]
  local isOwned = _.any(heroesData,function(heroData) return heroData.tplId == toGetId  end)
  if isOwned then
    NLG.Say(charIndex,-1,"����ʾ��ⷰ顾"..toGetHeroData[2].."���ѽ��ن��ˡ�",CONST.��ɫ_��ɫ,4)
    return
  end
  local isAbleHire = toGetHeroData[17]==nil and true or toGetHeroData[17](charIndex)
  if not isAbleHire then
    return;
  end 
  local itemId = Item.GetData(itemIndex,CONST.����_ID);
  
  if(Char.DelItem(charIndex,itemId,1) < 0) then
    NLG.Say(charIndex,-1,"��ϵ�y��δ֪ԭ������Ʒ�h��ʧ����",CONST.��ɫ_��ɫ,4)
    return;
  end
  local heroData = getModule('heroesFn'):initHeroData(toGetHeroData,charIndex)
  table.insert(heroesData,heroData)
  getModule('setterGetter'):set(charIndex,"heroes",heroesData)
  NLG.SystemMessage(charIndex,"�µď���ⷰ�����ˣ����ԏ�����O���x�����")


end


--- ����ģ�鹳��
function module:onLoad()
  self:logInfo('load')
  self:regCallback('ItemString', Func.bind(self.heroCallInit, self),"LUA_useHeroCall");

end

--- ж��ģ�鹳��
function module:onUnload()
  self:logInfo('unload')
end

return module
