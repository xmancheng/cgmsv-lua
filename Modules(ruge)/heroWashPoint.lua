local module = ModuleBase:createModule('heroWashPoint')

local itemId=778020

local function startswith ( str, substr)  
  if str == nil or substr == nil then  
      return nil, "the string or the sub-stirng parameter is nil"  
  end  
  if string.find(str, substr) ~= 1 then  
      return false  
  else  
      return true  
  end  
end


function module:onScriptCall(npcIndex, charIndex, text, msg)

  if not startswith(text,"佣兵洗点")then
    return
  end

  local windowStr = getModule('heroesFn'):buildCampHeroesList(charIndex)
  NLG.ShowWindowTalked(charIndex, self.npc, CONST.窗口_选择框, CONST.按钮_关闭, 1,windowStr);

end

function module:onTalkedEvent(npc, charIndex, seqno, select, data)


  data=tonumber(data)
  if select == CONST.按钮_关闭 then
    return ;
  end
  local campHeroes = getModule('heroesFn'):getCampHeroesData(charIndex)
  local heroData = campHeroes[data]
  local heroIndex = heroData.index;

  local vital = Char.GetData(heroIndex,CONST.对象_体力)/100
  local str = Char.GetData(heroIndex,CONST.对象_力量)/100
  local tgh = Char.GetData(heroIndex,CONST.对象_强度)/100
  local quick = Char.GetData(heroIndex,CONST.对象_速度)/100
  local magic = Char.GetData(heroIndex,CONST.对象_魔法)/100

  local addedPoint =vital+str+tgh+quick+magic

  local totalPoint = addedPoint + Char.GetData(heroIndex,CONST.对象_升级点)
  if(Char.DelItem(charIndex,itemId,1) < 0) then
    NLG.SystemMessage(charIndex,"[系統]未知原因導致物品刪除失敗!");
    return;
  end
  -- 洗点
  Char.SetData(heroIndex,CONST.对象_升级点 ,totalPoint)
  Char.SetData(heroIndex,CONST.对象_体力,0)
  Char.SetData(heroIndex,CONST.对象_力量,0)
  Char.SetData(heroIndex,CONST.对象_强度,0)
  Char.SetData(heroIndex,CONST.对象_速度,0)
  Char.SetData(heroIndex,CONST.对象_魔法,0)

  NLG.UpChar(heroIndex)
  NLG.SystemMessage(charIndex,"傭兵洗點成功");
end

function module:onLoad()
  self:logInfo('load')
  self:regCallback('ScriptCallEvent', Func.bind(self.onScriptCall, self))
  self.npc = self:NPC_createNormal('傭兵洗點', 105502, { x = 25, y = 12, mapType = 0, map = 777, direction = 4 });
  -- self:NPC_regTalkedEvent(self.npc, Func.bind(self.showAINpcHome, self));
  self:NPC_regWindowTalkedEvent(self.npc, Func.bind(self.onTalkedEvent, self));
end

function module:onUnload()
  self:logInfo('unload')
end

return module;
