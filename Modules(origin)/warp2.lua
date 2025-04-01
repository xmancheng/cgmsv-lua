local Warp = ModuleBase:createModule('warp2')

--坐标可以在下面自行添加
local warpPoints = {
  { "靈堂-Lv10", 0, 1538, 15, 18, 100 },
  { "里洞-Lv20", 0, 32511, 24, 15, 500 },
  { "利利可-Lv25", 0, 32505, 9, 8, 500 },
  { "羽音-Lv25", 0, 59503, 72, 161, 500 },
  { "雪山-Lv35", 0, 402, 84, 193, 1000 },
  { "炎洞-Lv40", 0, 15595, 3, 14, 1000 },
  { "聖詔三-Lv45", 0, 24044, 22, 5, 2000 },
  { "雪塔50F", 0, 59850, 77, 59, 2000 },
  { "冰樹-Lv55", 0, 32046, 63, 241, 1500 },
  { "水洞-Lv60", 0, 15542, 16, 25, 1500 },
  { "雪塔70F", 0, 59870, 77, 55, 1500 },
  { "盡頭的風穴", 0, 59670, 177, 135, 2500 },
  { "漢米頓商城", 0, 32205, 125, 133, 4000 },
  { "雪塔80F", 0, 59880, 162, 123, 3000 },
  { "黃蜂區-Lv80", 0, 32201, 169, 90, 4000 },
  { "雪塔90F", 0, 59890, 61, 40, 3000 },
  { "死樹區-Lv90", 0, 32201, 190, 207, 4000 },
  { "彩葉原-Lv100", 0, 32217, 55, 41, 3500 },
  { "彩葉頂-Lv140", 0, 32215, 36, 19, 3500 },

}

local function calcWarp()
  local page = math.modf(#warpPoints / 8) + 1
  local remainder = math.fmod(#warpPoints, 8)
  return page, remainder
end

function Warp:onLoad()
  self:logInfo('load');
  local warpNPC = self:NPC_createNormal('練等傳送', 103010, { x = 246, y = 85, mapType = 0, map = 1000, direction = 0 });
  Char.SetData(warpNPC,CONST.对象_ENEMY_PetFlg+2,0)--可穿透体
  self:NPC_regWindowTalkedEvent(warpNPC, function(npc, player, _seqno, _select, _data)
    local column = tonumber(_data)
    local page = tonumber(_seqno)
    local warpPage = page;
    local winMsg = "1\\n　　　　　〈快速傳送至各練功區，所費不貲〉\\n"
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
          winButton = CONST.BUTTON_上下取消
        end
      elseif _select == 2 then
        warpPage = 1
        return
      end
      local count = 8 * (warpPage - 1)
      if warpPage == totalPage then
        for i = 1 + count, remainder + count do
          --对齐格式
          local name_len = #warpPoints[i][1];
          if (name_len < 12) then
              name_spacelen = 12 - name_len;
              name_spaceMsg = " ";
              for k = 1, math.modf(name_spacelen) do
                  name_spaceMsg = name_spaceMsg .." ";
              end
          else
              name_spaceMsg = " ";
          end
          winMsg = winMsg .. warpPoints[i][1] .. name_spaceMsg .. "  △隊伍每人傳送費: ".. warpPoints[i][6] .."\\n"
        end
      else
        for i = 1 + count, 8 + count do
          --对齐格式
          local name_len = #warpPoints[i][1];
          if (name_len < 12) then
              name_spacelen = 12 - name_len;
              name_spaceMsg = " ";
              for k = 1, math.modf(name_spacelen) do
                  name_spaceMsg = name_spaceMsg .." ";
              end
          else
              name_spaceMsg = " ";
          end
          winMsg = winMsg .. warpPoints[i][1] .. name_spaceMsg .. "  △隊伍每人傳送費: ".. warpPoints[i][6] .."\\n"
        end
      end
      NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, winButton, warpPage, winMsg);
    else
      local count = 8 * (warpPage - 1) + column
      local short = warpPoints[count]
      local PartyNum = Char.PartyNum(player);
      if (PartyNum>0 and Char.GetData(player,CONST.对象_金币) >= short[6]*PartyNum) then
        local fee = short[6]*PartyNum;
		Char.SetData(player,CONST.对象_金币, Char.GetData(player,CONST.对象_金币) - fee);
		NLG.UpChar(player);
		NLG.SystemMessage(player,"隊長交出了"..fee.."。");
        Char.Warp(player, short[2], short[3], short[4], short[5])
      elseif (PartyNum>0 and Char.GetData(player,CONST.对象_金币) < short[6]*PartyNum) then
		NLG.SystemMessage(player,"不夠支付全隊傳送費用，請解散隊伍。");
      elseif (Char.GetData(player,CONST.对象_金币) >= short[6]) then
		Char.SetData(player,CONST.对象_金币, Char.GetData(player,CONST.对象_金币) - short[6]);
		NLG.UpChar(player);
        Char.Warp(player, short[2], short[3], short[4], short[5])
      elseif (Char.GetData(player,CONST.对象_金币) < short[6]) then
		NLG.SystemMessage(player,"傳送費用不足。");
      end
    end
  end)
  self:NPC_regTalkedEvent(warpNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "1\\n　　　　　〈快速傳送至各練功區，所費不貲〉\\n";
      for i = 1, 8 do
        --对齐格式
        local name_len = #warpPoints[i][1];
        if (name_len < 12) then
            name_spacelen = 12 - name_len;
            name_spaceMsg = " ";
            for k = 1, math.modf(name_spacelen) do
                name_spaceMsg = name_spaceMsg .." ";
            end
        else
            name_spaceMsg = " ";
        end
        msg = msg .. warpPoints[i][1] .. name_spaceMsg .. "  △隊伍每人傳送費: ".. warpPoints[i][6] .."\\n"
      end
      NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.BUTTON_下取消, 1, msg);
    end
    return
  end)
end

function Warp:onUnload()
  self:logInfo('unload')
end

return Warp;
