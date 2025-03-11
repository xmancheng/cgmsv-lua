local Warp = ModuleBase:createModule('warp')

--坐标可以在下面自行添加
local warpPoints = {
  { "聖拉魯卡村", 0, 100, 134, 218, 1000 },
  { "伊爾村", 0, 100, 681, 343, 1000 },
  { "亞留特村", 0, 100, 587, 51, 1000 },
  { "維諾亞村", 0, 100, 330, 480, 1000 },
  { "奇利村", 0, 300, 273, 294, 1000 },
  { "加納村", 0, 300, 702, 147, 1000 },
  { "傑諾瓦鎮", 0, 400, 217, 455, 1000 },
  { "蒂娜村", 0, 400, 570, 274, 1000 },
  { "阿巴尼斯村", 0, 402, 183, 164, 1000 },
  { "阿凱魯法村", 0, 33200, 99, 165, 1000 },
  { "坎那貝拉村", 0, 33500, 17, 76, 1000 },
  { "哥拉爾鎮", 0, 43100, 120, 107, 1000 },
  { "魯米那斯村", 0, 43000, 322, 883, 1000 },
  { "米諾基亞村", 0, 43000, 431, 823, 1000 },
  { "雷克塔爾鎮", 0, 43000, 556, 313, 1000 },
  { "亞諾曼城", 0, 30010, 150, 123, 1000 },
  { "尼維爾海村", 0, 30001, 600, 470, 1000 },
  { "雷歐娜村", 0, 30014, 60, 52, 1000 },
  { "克瑞村", 0, 30012, 32, 55, 1000 },
  { "摩頓村", 0, 30013, 92, 42, 1000 },
  { "達米達村", 0, 32034, 19, 65, 1000 },
  { "柯馬特依村", 0, 57452, 64, 72, 1000 },
  { "艾爾莎新城", 0, 59520, 143, 108, 1000 },
  { "辛梅爾", 0, 59519, 26, 17, 1000 },
  { "漢米頓村", 0, 32205, 127, 138, 1000 },
  { "亞紀城", 0, 32277, 33, 56, 1000 },
  { "光之路", 0, 59505, 165, 83, 1000 },
  { "雪塔頂", 0, 59906, 103, 21, 1000 },
}

local function calcWarp()
  local page = math.modf(#warpPoints / 8) + 1
  local remainder = math.fmod(#warpPoints, 8)
  return page, remainder
end

function Warp:onLoad()
  self:logInfo('load');
  local warpNPC = self:NPC_createNormal('村莊傳送', 103010, { x = 246, y = 91, mapType = 0, map = 1000, direction = 0 });
  Char.SetData(warpNPC,CONST.对象_ENEMY_PetFlg+2,0)--可穿透体
  self:NPC_regWindowTalkedEvent(warpNPC, function(npc, player, _seqno, _select, _data)
    local column = tonumber(_data)
    local page = tonumber(_seqno)
    local warpPage = page;
    local winMsg = "1\\n　　　　　〈快速傳送至各村莊，所費不貲〉\\n"
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
      local msg = "1\\n　　　　　〈快速傳送至各村莊，所費不貲〉\\n";
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
