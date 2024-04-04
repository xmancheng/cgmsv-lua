---模块类
local Module = ModuleBase:createModule('mazeHorcrux')

local worldHorcrux = {
  { "[　第一罪：傲慢", 70258, 301, 119010 },
  { "[　第二罪：嫉妒", 70260, 302, 119022 },
  { "[　第三罪：憤怒", 70262, 303, 119020 },
  { "[　第四罪：怠惰", 70264, 304, 119018 },
  { "[　第五罪：貪婪", 70266, 305, 119021 },
  { "[　第六罪：暴食", 70267, 306, 119019 },
  { "[　第七罪：色慾", 70270, 307, 119011 },
}

--- 页数计算
local function calcWarp()
  local totalpage = math.modf(#worldHorcrux / 6) + 1
  local remainder = math.fmod(#worldHorcrux, 6)
  return totalpage, remainder
end

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('LoginEvent', Func.bind(self.onLoginEvent, self));
  self:regCallback('LogoutEvent', Func.bind(self.onLogoutEvent, self));
  self:regCallback('DropEvent', Func.bind(self.LogoutEvent, self));
  self:regCallback('ItemString', Func.bind(self.onSinUse, self), 'LUA_useSin');
  local HorcruxNPC = self:NPC_createNormal('七罪魂器著裝', 104840, { map = 1000, x = 241, y = 70, direction = 0, mapType = 0 })
  self:NPC_regWindowTalkedEvent(HorcruxNPC, function(npc, player, _seqno, _select, _data)
    local column = tonumber(_data)
    local page = tonumber(_seqno)
    local warpPage = page;
    local winMsg = "3\\n@c選擇已填充的魂器取得七罪技能\\n"
                           .."\\n　　════════════════════\\n";
    local winButton = CONST.BUTTON_关闭;
    local totalPage, remainder = calcWarp()
    --上页16 下页32 关闭/取消2
    if _select > 0 then
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
          winButton = CONST.BUTTON_下取消
        end
      elseif _select == 2 then
        warpPage = 1
        return
      end
      local count = 6 * (warpPage - 1)
      if warpPage == totalPage then
        for i = 1 + count, remainder + count do
          local flagEvent = Char.EndEvent(player,worldHorcrux[i][1]);
          if (flagEvent == 1) then
              winMsg = winMsg .. worldHorcrux[i][1] .. "　　●已啟動]\\n"
          else
              winMsg = winMsg .. worldHorcrux[i][1] .. "　　○未激活]\\n"
          end
        end
      else
        for i = 1 + count, 6 + count do
          local flagEvent = Char.EndEvent(player,worldHorcrux[i][1]);
          if (flagEvent == 1) then
              winMsg = winMsg .. worldHorcrux[i][1] .. "　　●已啟動]\\n"
          else
              winMsg = winMsg .. worldHorcrux[i][1] .. "　　○未激活]\\n"
          end
        end
      end
      NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, winButton, warpPage, winMsg);
    else
      local count = 6 * (warpPage - 1) + column
      local short = worldHorcrux[count]
      local flagEvent = Char.EndEvent(player, short[3]);
      if (flagEvent == 1) then
          NLG.SetHeadIcon(player, short[4]);
          Char.SetExtData(player, "Saligia", short[4]);
      else
          NLG.SystemMessage(player,"[系統]尚未激活此七大罪魂器！！");
          return;
      end
    end
  end)
  self:NPC_regTalkedEvent(HorcruxNPC, function(npc, player)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    if (NLG.CanTalk(npc, player) == true) then
      local winCase = CONST.窗口_选择框
      local winButton = CONST.BUTTON_关闭;
      local msg = "3\\n@c選擇已填充的魂器取得七罪技能\\n"
                           .."\\n　　════════════════════\\n";
      for i = 1,7 do
        local flagEvent = Char.EndEvent(player,worldHorcrux[i][3]);
        if (flagEvent == 1) then
            msg = msg .. worldHorcrux[i][1] .. "　　●已啟動]\\n"
        else
            msg = msg .. worldHorcrux[i][1] .. "　　○未激活]\\n"
        end
      end
      NLG.ShowWindowTalked(player, npc, winCase, winButton, 1, msg);
    end
    return
  end)

end


function Module:onLogoutEvent(player)
  local IconId = Char.GetExtData(player, "Saligia") or 0;
  --print(IconId)
end

function Module:onLoginEvent(player)
  local IconId = Char.GetExtData(player, "Saligia") or 0;
  if IconId > 0 then
     NLG.SetHeadIcon(player, IconId);
  end
end

--七大罪使用
function Module:onSinUse(charIndex, targetCharIndex, itemSlot)
  local itemIndex = Char.GetItemIndex(charIndex,itemSlot);
  local ItemID = Item.GetData(itemIndex, CONST.道具_ID);
  for i, v in ipairs(worldHorcrux) do
      if (ItemID==v[2]) then
          if (Char.EndEvent(charIndex,v[3])==0) then
              Char.DelItem(charIndex,v[2],1);
              Char.EndEvent(charIndex,v[3],1);
               NLG.SystemMessage(charIndex,"[系統]七大罪魂器激活中！！");
          elseif (Char.EndEvent(charIndex,v[3])==1) then
               NLG.SystemMessage(charIndex,"[系統]已經啟動過此魂器！！");
          end
      end
  end
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
