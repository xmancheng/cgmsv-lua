local MatchDraw = ModuleBase:createModule('matchDraw')

local DrawTbl={
       { Num="[001]", type="S", serial_L=1000, serial_H=1000, itemid=69000, count=1},        --S(1)
       { Num="[002]", type="A", serial_L=996, serial_H=999, itemid=69000, count=1},             --A(2~3)
       { Num="[003]", type="A", serial_L=991, serial_H=995, itemid=69000, count=1},
       { Num="[004]", type="B", serial_L=985, serial_H=990, itemid=69000, count=1},             --B(4~6)
       { Num="[005]", type="B", serial_L=978, serial_H=984, itemid=69000, count=1},
       { Num="[006]", type="B", serial_L=970, serial_H=977, itemid=69000, count=1},
       { Num="[007]", type="C", serial_L=955, serial_H=969, itemid=69000, count=1},             --C(7~10)
       { Num="[008]", type="C", serial_L=940, serial_H=954, itemid=69000, count=1},
       { Num="[009]", type="C", serial_L=925, serial_H=939, itemid=69000, count=1},
       { Num="[010]", type="C", serial_L=909, serial_H=924, itemid=69000, count=1},
       { Num="[011]", type="D", serial_L=849, serial_H=908, itemid=69000, count=1},             --D(11~15)
       { Num="[012]", type="D", serial_L=789, serial_H=848, itemid=69000, count=1},
       { Num="[013]", type="D", serial_L=729, serial_H=788, itemid=69000, count=1},
       { Num="[014]", type="D", serial_L=669, serial_H=728, itemid=69000, count=1},
       { Num="[015]", type="D", serial_L=608, serial_H=668, itemid=69000, count=1},
       { Num="[016]", type="E", serial_L=508, serial_H=607, itemid=69000, count=1},             --E(16~21)
       { Num="[017]", type="E", serial_L=408, serial_H=507, itemid=69000, count=1},
       { Num="[018]", type="E", serial_L=308, serial_H=407, itemid=69000, count=1},
       { Num="[019]", type="E", serial_L=208, serial_H=307, itemid=69000, count=1},
       { Num="[020]", type="E", serial_L=108, serial_H=207, itemid=69000, count=1},
       { Num="[021]", type="E", serial_L=7, serial_H=107, itemid=69000, count=1},
}

local itemMenu={
        {"[001]","測試道具",1},
        {"[002]","測試道具2",1},
        {"[003]","測試道具3",1},
        {"[004]","測試道具4",1},
        {"[005]","測試道具5",1},
        {"[006]","測試道具6",1},
        {"[007]","測試道具7",1},
        {"[008]","測試道具8",1},
        {"[009]","測試道具9",1},
        {"[010]","測試道具10",1},
        {"[011]","測試道具11",1},
        {"[012]","測試道具",1},
        {"[013]","測試道具",1},
        {"[014]","測試道具",1},
}


local function calcWarp()--计算页数和最后一页数量
  local totalpage = math.modf(#itemMenu / 6) + 1
  local remainder = math.fmod(#itemMenu, 6)
  return totalpage, remainder
end

function MatchDraw:onLoad()
    self:logInfo('load')
    self:regCallback("ItemString", Func.bind(self.onMatchDraw, self), 'LUA_useDraw');
    local managerNPC = self:NPC_createNormal('火柴抽獎經理', 104927, { x = 227, y = 83, mapType = 0, map = 1000, direction = 4 });
    self:NPC_regWindowTalkedEvent(managerNPC, function(npc, player, _seqno, _select, _data)
        local column = tonumber(_data)
        local page = tonumber(_seqno)
        local data = tonumber(_data)
        local warpPage = page;
        local winButton = CONST.BUTTON_下取消;
        local totalPage, remainder = calcWarp()
        --上页16 下页32 关闭/取消2
        if _select > 0 then
                    --给予道具
                    local choose = tonumber(_seqno);
                    if (_select == CONST.BUTTON_确定) then
                        if (data==nil or math.floor(data)~=data) then
                              return;
                        else
                              for k=1, #itemMenu do
                                  if (choose == 1000+k) then
                                    Char.GiveItem(player,69000,data);
                                    return;
                                  end
                              end
                        end
                    end

                    --道具列表
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
                    local count = 6 * (warpPage - 1)
                    local winMsg = "3\\n火柴抽獎背包列表".. warpPage .."/".. totalPage .."\\n"
                                                        .."═════════════════════\\n"
                                                        .."序號　　　道具名稱　　　　　　　數量\\n";
                    if warpPage == totalPage then
                        for i = 1 + count, remainder + count do
                                local len = #itemMenu[i][2];
                                winMsg = winMsg .. itemMenu[i][1] .."　　".. itemMenu[i][2]
                                if len <= 22 then
                                      spacelen = 22 - len;
                                      spaceMsg = " ";
                                      for i = 1, math.modf(spacelen) do
                                              spaceMsg = spaceMsg .." ";
                                      end
                                end
                                winMsg = winMsg .. spaceMsg .. itemMenu[i][3] .."\\n"
                        end
                    else
                        for i = 1 + count, 6 + count do
                                local len = #itemMenu[i][2];
                                winMsg = winMsg .. itemMenu[i][1] .."　　".. itemMenu[i][2]
                                if len <= 22 then
                                      spacelen = 22 - len;
                                      spaceMsg = " ";
                                      for i = 1, math.modf(spacelen) do
                                              spaceMsg = spaceMsg .." ";
                                      end
                                end
                                winMsg = winMsg .. spaceMsg .. itemMenu[i][3] .."\\n"
                        end
                    end
                    NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, winButton, warpPage, winMsg);
        else
                local choose_item = 6 * (warpPage - 1) + column
                --给予道具
                local winMsg = "火柴抽獎背包\\n"
                                           .."═════════════════════\\n"
                                           .."正在取出道具...\\n"
                                           .."\\n　　　　　　　".. itemMenu[choose_item][2] .."\\n"
                                           .."\\n　　　　　　　當前擁有的數量：".. itemMenu[choose_item][3] .."\\n"
                                           .."\\n請輸入取出數量：\\n";
                local choose = choose_item+1000;
                NLG.ShowWindowTalked(player, npc, CONST.窗口_输入框, CONST.BUTTON_确定关闭, choose, winMsg);

        end
    end)
    self:NPC_regTalkedEvent(managerNPC, function(npc, player)  ----火柴抽奖背包managerMenu{}
            if (NLG.CanTalk(npc, player) == true) then
                local warpPage = 1;
                local totalPage, remainder = calcWarp()
                local count = 6 * (warpPage - 1)
                local winMsg = "3\\n火柴抽獎背包列表".. warpPage .."/".. totalPage .."\\n"
                                                        .."═════════════════════\\n"
                                                        .."序號　　　道具名稱　　　　　　　數量\\n";
                    if warpPage == totalPage then
                        for i = 1 + count, remainder + count do
                                local len = #itemMenu[i][2];
                                winMsg = winMsg .. itemMenu[i][1] .."　　".. itemMenu[i][2]
                                if len <= 22 then
                                      spacelen = 22 - len;
                                      spaceMsg = " ";
                                      for i = 1, math.modf(spacelen) do
                                              spaceMsg = spaceMsg .." ";
                                      end
                                end
                                winMsg = winMsg .. spaceMsg .. itemMenu[i][3] .."\\n"
                        end
                    else
                        for i = 1 + count, 6 + count do
                                local len = #itemMenu[i][2];
                                winMsg = winMsg .. itemMenu[i][1] .."　　".. itemMenu[i][2]
                                if len <= 22 then
                                      spacelen = 22 - len;
                                      spaceMsg = " ";
                                      for i = 1, math.modf(spacelen) do
                                              spaceMsg = spaceMsg .." ";
                                      end
                                end
                                winMsg = winMsg .. spaceMsg .. itemMenu[i][3] .."\\n"
                        end
                    end
                NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.BUTTON_下取消, 1, winMsg);
            end
            return
    end)

end


function MatchDraw:onMatchDraw(player, targetcharIndex, itemSlot)
          local itemIndex = Char.GetItemIndex(player, itemSlot);
          local ItemID = Item.GetData(itemIndex, CONST.道具_ID);
          Char.DelItem(player, ItemID, 1)
          local WinNum = NLG.Rand(7, 1000);
          print(WinNum)
          for k, v in ipairs(DrawTbl) do
             if (WinNum>=v.serial_L and WinNum<=v.serial_H) then
                   if (v.type=="S") then
                         NLG.Say(player, -1, "特等獎[0.1%]。", CONST.颜色_红色, CONST.字体_中);
                   elseif (v.type=="A") then
                         NLG.Say(player, -1, "一等獎[0.9%]。", CONST.颜色_黄色, CONST.字体_中);
                   elseif (v.type=="B") then
                         NLG.Say(player, -1, "二等獎[2%]。",CONST.颜色_青色, CONST.字体_中);
                   elseif (v.type=="C") then
                         NLG.Say(player, -1, "三等獎[6%]。",CONST.颜色_灰蓝色, CONST.字体_中);
                   elseif (v.type=="D") then
                         NLG.Say(player, -1, "四等獎[30%]。",CONST.颜色_灰绿色, CONST.字体_中);
                   elseif (v.type=="E") then
                         NLG.Say(player, -1, "安慰獎[60%]。", CONST.颜色_灰色, CONST.字体_中);
                   end
             end
          end
end

function MatchDraw:onUnload()
        self:logInfo('unload');
end

return MatchDraw;