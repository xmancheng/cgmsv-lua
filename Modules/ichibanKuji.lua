local IchibanKuji = ModuleBase:createModule('ichibanKuji')

IchibanKuji:addMigration(1, 'init lua_hook_character', function()
  SQL.querySQL([[
      CREATE TABLE if not exists `lua_hook_character` (
    `Name` char(32) COLLATE gbk_bin NOT NULL,
    `CdKey` char(32) COLLATE gbk_bin NOT NULL,
    `RankedPoints` int(10) NOT NULL Default 0,
    `WingCover` int(10) NOT NULL Default 1,
    `OriginalImageNumber` int(10) NOT NULL,
    `SwitchImageNumber2` int(10) Default 1,
    `SwitchImageNumber3` int(10) Default 1,
    `SwitchImageNumber4` int(10) Default 1,
    `SwitchImageNumber5` int(10) Default 1,
    `SwitchImageNumber6` int(10) Default 1,
    `SwitchImageNumber7` int(10) Default 1,
    `SwitchImageNumber8` int(10) Default 1,
    `SwitchImageNumber9` int(10) Default 1,
    `SwitchImageNumber10` int(10) Default 1,
    `Tenjo` int(10) NOT NULL Default 0,
    `MatchDraw1` mediumtext COLLATE gbk_bin NULL,
    `IchibanKuji1` mediumtext COLLATE gbk_bin NULL,
    PRIMARY KEY (`CdKey`),
    KEY `Name` (`Name`) USING BTREE
  ) ENGINE=Innodb DEFAULT CHARSET=gbk COLLATE=gbk_bin
  ]])
end);

IchibanKuji:addMigration(2, 'insertinto lua_hook_character', function()
  SQL.querySQL([[
      INSERT INTO lua_hook_character (Name,CdKey,OriginalImageNumber) SELECT Name,CdKey,OriginalImageNumber FROM tbl_character;
  ]])
end);

local GMcdk = "123456";
local KujiAll = {
         "A1", "B1", "C1", "D1", "E1", "E2", "F1", "F2",
         "G1", "G2", "G3", "G4", "G5", "G6", "G7", "G8", "G9", "G10", "G11", "G12",
         "H1","H2","H3","H4","H5","H6","H7","H8","H9","H10","H11","H12",
         "I1","I2","I3","I4","I5","I6","I7","I8","I9","I10","I11","I12","I13","I14","I15","I16","I17","I18",
}

local KujiTbl={
       { Num="001", type="L", serial_L=51, serial_H=51, name="黃金轉蛋", itemid=70025, count=1},
       { Num="002", type="A", serial_L=1, serial_H=1, name="盜獵紫龍召喚書", itemid=70107, count=1},
       { Num="003", type="B", serial_L=2, serial_H=2, name="盜獵綠龍召喚書", itemid=70108, count=1},
       { Num="004", type="C", serial_L=3, serial_H=3, name="盜獵橙龍召喚書", itemid=70109, count=1},
       { Num="005", type="D", serial_L=4, serial_H=4, name="盜獵黃龍召喚書", itemid=70110, count=1},
       { Num="006", type="E", serial_L=5, serial_H=6, name="金色王冠", itemid=68017, count=1},
       { Num="007", type="F", serial_L=7, serial_H=8, name="銀色王冠", itemid=68018, count=1},
       { Num="008", type="G", serial_L=9, serial_H=20, name="火柴抽抽樂", itemid=70094, count=1},
       { Num="009", type="H", serial_L=21, serial_H=32, name="龍之豆莢", itemid=70165, count=1},
       { Num="010", type="I", serial_L=33, serial_H=50, name="青銅轉蛋", itemid=70027, count=1},
}


local function calcWarp()--计算页数和最后一页数量
  local totalpage = math.modf(#itemMenu / 6) + 1
  local remainder = math.fmod(#itemMenu, 6)
  return totalpage, remainder
end

local function calcSpace(textlen)
  local len = textlen
  if len <= 20 then
      spacelen = 20 - len;
      spaceMsg = " ";
      for i = 1, math.modf(spacelen) do
          spaceMsg = spaceMsg .." ";
      end
  end
  return spaceMsg
end

--- 加载模块钩子
function IchibanKuji:onLoad()
    self:logInfo('load')
    self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self));
    self:regCallback("ItemString", Func.bind(self.onIchibanKuji, self), 'LUA_useKuji');
    local noticeNPC = self:NPC_createNormal('一番賞購買告示', 11556, { x = 226, y = 106, mapType = 0, map = 1000, direction = 0 });
    self:NPC_regWindowTalkedEvent(noticeNPC, function(npc, player, _seqno, _select, _data)
        local column = tonumber(_data)
        local page = tonumber(_seqno)
        local data = tonumber(_data)
          --读取签筒
        local gmIndex = NLG.FindUser(GMcdk);
        --local sqldata = Char.GetExtData(gmIndex, 'ichiban_set');
        local sqldata = tostring(SQL.Run("select val from hook_charaext where cdKey='"..GMcdk.."' and sKey='ichiban_set'")["0_0"])
        local KujiAll = {};
        if (type(sqldata)=="string" and sqldata~='') then
               KujiAll = JSON.decode(sqldata);
        else
               KujiAll = {};
        end
        if (page == 1)  then
            if (_select == CONST.BUTTON_是)  then
                --冷静时间计算
                local IBtime = Char.GetExtData(player, 'ichiban_time') or 0;
                local days = tonumber(os.date("%j",os.time())) - tonumber(os.date("%j",IBtime));
                local hours = tonumber(os.date("%H",os.time())) - tonumber(os.date("%H",IBtime));
                local minutes = tonumber(os.date("%M",os.time())) - tonumber(os.date("%M",IBtime));
                totalMinutes = days*24*60+hours*60+minutes;
                if (totalMinutes>=10) then
                    Char.SetExtData(player, 'ichiban_count', 0);
                    Char.SetExtData(player, 'ichiban_time', 0);
                    timestamp = 0;
                else
                    timestamp = 10 - totalMinutes;
                end
                local winMsg = "魔力一番賞購買抽獎籤\\n"
                                           .."═════════════════════\\n"
                                           .."正在購買抽獎籤...\\n"
                                           .."\\n　　　　　　　\\n"
                                           .."\\n　　　　　　　冷靜期剩下時間： "..timestamp.." 分\\n"
                                           .."\\n請輸入購買數量(每次不得超過5張)：\\n";
                NLG.ShowWindowTalked(player, npc, CONST.窗口_输入框, CONST.BUTTON_确定关闭, 11, winMsg);
            else
                return;
            end
        end
        if (page == 11)  then
                if (_select == CONST.BUTTON_关闭)  then
                    return;
                end
                if (_select == CONST.BUTTON_确定)  then
                   if (data ~=nil and math.ceil(data)==data) then
                       if (data>#KujiAll) then
                             NLG.Say(player, -1, "[系統]購買數量超過目前籤的上限", CONST.颜色_黄色, CONST.字体_中);
                             return;
                       elseif (data>5) then
                             NLG.Say(player, -1, "[系統]購買數量超過一次上限５張", CONST.颜色_黄色, CONST.字体_中);
                             return;
                       end
                       --所需银币计算
                       local count = Char.GetExtData(player, 'ichiban_count') or 0;
                       local stack = math.modf(count/5);                     --此数量组数(s组)
                       local silver = stack+1;                                             --当前数量下有的银币最高价
                       excess, decimals = math.modf((data+count)/5);                      --不成组的数量
                       print(excess,decimals)
                       if stack>=0 then
                           number= data;
                           cash = 1*silver*data;
                       end
                       if (excess>=stack+1) then
                           remain = excess*5 - count;    --凑满一组余差额签数
                           if (decimals==0) then
                               decimals = 0;                         --刚好凑满一组(可交易)
                           else
                               decimals = -1;                       --超出原价银币之数量(拒绝交易)
                           end
                       else
                           decimals = 0;                             --数量无超出(可交易)
                       end
                       local winMsg = "魔力一番賞購買抽獎籤\\n"
                                                  .."═════════════════════\\n"
                                                  .."正在準備抽獎中...\\n"
                                                  .."\\n　　　　　一抽可能最高銀幣：◎ "..silver.." 枚\\n"
                                                  .."\\n　　　　　　　總共所需銀幣：◎ "..cash.." 枚\\n"
                                                  .."\\n　　　　　是否確定進行一番賞抽獎？\\n";
                       NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.BUTTON_确定关闭, 12, winMsg);
                   end
                end
        end
        if (page == 12) then
                if (_select == CONST.BUTTON_关闭)  then
                    return;
                end
                if (_select == CONST.BUTTON_确定)  then
                   if (decimals<0) then
                             NLG.Say(player, -1, "[系統]此組銀幣費率只能再購買"..remain.."張！", CONST.颜色_黄色, CONST.字体_中);
                             return;
                   end
                   --给予一番赏签
                   if (Char.ItemNum(player, 67777)<cash) then
                             NLG.Say(player, -1, "[系統]一番賞銀幣不足！", CONST.颜色_黄色, CONST.字体_中);
                             return;
                   else
                             Char.DelItem(player, 67777, cash);
                             myNumber = 1;
                             while myNumber < number+1 do
                                 --Char.GiveItem(player, 70095, 1);
                                 --local itemSlot = Char.FindItemId(player, 70095);
                                 local res,err =pcall( function() 
                                     self:onIchibanKuji(player, targetcharIndex, itemSlot);
                                     myNumber = myNumber + 1;
                                 end)
                             end
                             local count = Char.GetExtData(player, 'ichiban_count') or 0;
                             local time = Char.GetExtData(player, 'ichiban_time') or 0;
                             Char.SetExtData(player, 'ichiban_count', count+number);
                             if (time==0)  then
                                 Char.SetExtData(player, 'ichiban_time', os.time() );
                             end
                   end
                end
        end
    end)
    self:NPC_regTalkedEvent(noticeNPC, function(npc, player)  ----一番賞資訊告示
          local cdk = Char.GetData(player,CONST.对象_CDK);
          SQL.Run("INSERT INTO lua_hook_character (Name,CdKey,OriginalImageNumber) SELECT Name,CdKey,OriginalImageNumber FROM tbl_character WHERE NOT EXISTS ( SELECT Name FROM lua_hook_character WHERE tbl_character.CdKey=lua_hook_character.CdKey)");
          --读取签筒
          local gmIndex = NLG.FindUser(GMcdk);
          --local sqldata = Char.GetExtData(gmIndex, 'ichiban_set');
          local sqldata = tostring(SQL.Run("select val from hook_charaext where cdKey='"..GMcdk.."' and sKey='ichiban_set'")["0_0"])
          local KujiAll = {};
          if (type(sqldata)=="string" and sqldata~='') then
               KujiAll = JSON.decode(sqldata);
          else
               KujiAll = {};
          end
          --计算各种类剩余签数
          local KujiLen = #KujiAll; local Kuji_A=0; local Kuji_B=0; local Kuji_C=0; local Kuji_D=0; local Kuji_E=0; local Kuji_F=0; local Kuji_G=0; local Kuji_H=0; local Kuji_I=0;
          table.forEach(KujiAll, function(e)
                    if string.sub(e, 1, 1)=="A" then Kuji_A = Kuji_A+1;
                    elseif string.sub(e, 1, 1)=="B" then Kuji_B = Kuji_B+1;
                    elseif string.sub(e, 1, 1)=="C" then Kuji_C = Kuji_C+1;
                    elseif string.sub(e, 1, 1)=="D" then Kuji_D = Kuji_D+1;
                    elseif string.sub(e, 1, 1)=="E" then Kuji_E = Kuji_E+1;
                    elseif string.sub(e, 1, 1)=="F" then Kuji_F = Kuji_F+1;
                    elseif string.sub(e, 1, 1)=="G" then Kuji_G = Kuji_G+1;
                    elseif string.sub(e, 1, 1)=="H" then Kuji_H = Kuji_H+1;
                    elseif string.sub(e, 1, 1)=="I" then Kuji_I = Kuji_I+1;
                    end
          end)
          if (NLG.CanTalk(npc, player) == true) then
              if (KujiAll~=nil and KujiAll~={}) then
                    local winMsg = "\\n          ★★★★★★魔力一番賞說明告示★★★★★★\\n"
                                               .."\\n　新遊戲完整的籤數總共有50張，目前剩餘籤數："..KujiLen.."\\n"
                                               .."\\n╔═══════════════════════════╗"
                                               .."\\n║　Ａ　賞　"..KujiTbl[2].name..""..calcSpace(#KujiTbl[2].name)..""..Kuji_A..""..calcSpace(#tostring(Kuji_A)).."║"
                                               .."\\n║　Ｂ　賞　"..KujiTbl[3].name..""..calcSpace(#KujiTbl[3].name)..""..Kuji_B..""..calcSpace(#tostring(Kuji_B)).."║"
                                               .."\\n║　Ｃ　賞　"..KujiTbl[4].name..""..calcSpace(#KujiTbl[4].name)..""..Kuji_C..""..calcSpace(#tostring(Kuji_C)).."║"
                                               .."\\n║　Ｄ　賞　"..KujiTbl[5].name..""..calcSpace(#KujiTbl[5].name)..""..Kuji_D..""..calcSpace(#tostring(Kuji_D)).."║"
                                               .."\\n╠═══════════════════════════╣"
                                               .."\\n║　Ｅ　賞　"..KujiTbl[6].name..""..calcSpace(#KujiTbl[6].name)..""..Kuji_E..""..calcSpace(#tostring(Kuji_E)).."║"
                                               .."\\n║　Ｆ　賞　"..KujiTbl[7].name..""..calcSpace(#KujiTbl[7].name)..""..Kuji_F..""..calcSpace(#tostring(Kuji_F)).."║"
                                               .."\\n╠═══════════════════════════╣"
                                               .."\\n║　Ｇ　賞　"..KujiTbl[8].name..""..calcSpace(#KujiTbl[8].name)..""..Kuji_G..""..calcSpace(#tostring(Kuji_G)).."║"
                                               .."\\n║　Ｈ　賞　"..KujiTbl[9].name..""..calcSpace(#KujiTbl[9].name)..""..Kuji_H..""..calcSpace(#tostring(Kuji_H)).."║"
                                               .."\\n║　Ｉ　賞　"..KujiTbl[10].name..""..calcSpace(#KujiTbl[10].name)..""..Kuji_I..""..calcSpace(#tostring(Kuji_I)).."║"
                                               .."\\n╚═══════════════════════════╝"
                                               .."\\n　　最後賞　【　"..KujiTbl[1].name.."　】\\n"
                                               .."\\n　每抽1次：1枚〈銀幣〉，每5抽後累積上漲1枚〈銀幣〉"
                                               .."\\n　抽籤後經過10分鐘的冷卻時間，重置回到1枚〈銀幣〉"
                                               .."\\n　最後抽取到第50抽者，獲得《最後賞》額外獎勵";
                    NLG.ShowWindowTalked(player, npc, CONST.窗口_巨信息框, CONST.BUTTON_是否, 1, winMsg);
              end
          end
          return
    end)


    local clerkNPC = self:NPC_createNormal('一番賞保管店員', 104925, { x = 228, y = 106, mapType = 0, map = 1000, direction = 4 });
    self:NPC_regWindowTalkedEvent(clerkNPC, function(npc, player, _seqno, _select, _data)
        local column = tonumber(_data)
        local page = tonumber(_seqno)
        local data = tonumber(_data)
        local warpPage = page;
        local winButton = CONST.BUTTON_关闭;
        --local totalPage, remainder = calcWarp()
        --下载数据
        local cdk = Char.GetData(player,CONST.对象_CDK);
        local sqldata = SQL.Run("select IchibanKuji1 from lua_hook_character where CdKey='"..cdk.."'")["0_0"]
        local itemData = {};
        if (type(sqldata)=="string") then
               itemData = JSON.decode(sqldata);
               itemMenu = itemData;
        else
               itemMenu={};
        end
        --上页16 下页32 关闭/取消2
        if _select > 0 then
                if _select == CONST.BUTTON_关闭 then
                    return;
                end
                --给予道具
                local choose = tonumber(_seqno);
                if (_select == CONST.BUTTON_确定) then
                        if (data==nil or math.floor(data)~=data) then
                              return;
                        else
                              local key=choose - 1000;
                              if (data<=itemMenu[key][4]) then
                                       local ItemsetIndex = Data.ItemsetGetIndex(itemMenu[key][3]);
                                       local stack = Data.ItemsetGetData(ItemsetIndex, CONST.ITEMSET_MAXREMAIN);
                                       local slot = math.modf(data / stack);                --此数量占用格数(s组)
                                       local excess = math.fmod(data, stack);            --不成组的数量(1格)
                                       if (excess>0) then slot=slot+1; end
                                       if (Char.ItemSlot(player)<=20-slot) then
                                            itemData[key][4] = itemData[key][4] - data;
                                            Char.GiveItem(player,itemMenu[key][3],data);
                                       else
                                            NLG.Say(player, -1, "注意提取數量超過物品欄！", CONST.颜色_黄色, CONST.字体_中);
                                            return;
                                       end
                                       if (itemData[key][4]==0) then
                                            table.remove(itemData,key);
                                            itemMenu = itemData;
                                       end
                                       if (#itemMenu==0) then
                                                itemMenu={};
                                                SQL.Run("update lua_hook_character set IchibanKuji1= NULL where CdKey='"..cdk.."'")
                                                NLG.UpChar(player);
                                                return;
                                       else
                                                local sqldata = itemData;
                                                local newdata = JSON.encode(sqldata);
                                                SQL.Run("update lua_hook_character set IchibanKuji1= '"..newdata.."' where CdKey='"..cdk.."'")
                                                NLG.UpChar(player);
                                                return;
                                       end
                              else
                                       NLG.Say(player, -1, "『".. itemMenu[key][2] .."』提取數量超過『".. itemMenu[key][4] .."』", CONST.颜色_黄色, CONST.字体_中);
                                       return;
                              end
                        end
                end
                if (itemMenu~=nil and itemMenu~={}) then
                    local totalPage, remainder = calcWarp()
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
                                if totalPage == 1 then
                                        winButton = CONST.BUTTON_关闭;
                                end
                        else
                                winButton = CONST.BUTTON_上下取消
                        end
                    elseif _select == 2 then
                        warpPage = 1
                        return
                    end
                    local count = 6 * (warpPage - 1)
                    local winMsg = "3\\n一番賞抽獎背包列表".. warpPage .."/".. totalPage .."　　　　\\n"
                                                        .."═════════════════════\\n"
                                                        .."序號　　　道具名稱　　　　　　　數量\\n";
                    if warpPage == totalPage then
                        for i = 1 + count, remainder + count do
                                local len = #itemMenu[i][2];
                                winMsg = winMsg .."[".. itemMenu[i][1] .."]　　　".. itemMenu[i][2]
                                if len <= 20 then
                                      spacelen = 20 - len;
                                      spaceMsg = " ";
                                      for i = 1, math.modf(spacelen) do
                                              spaceMsg = spaceMsg .." ";
                                      end
                                end
                                winMsg = winMsg .. spaceMsg .. itemMenu[i][4] .."\\n"
                        end
                    else
                        for i = 1 + count, 6 + count do
                                local len = #itemMenu[i][2];
                                winMsg = winMsg .."[".. itemMenu[i][1] .."]　　　".. itemMenu[i][2]
                                if len <= 20 then
                                      spacelen = 20 - len;
                                      spaceMsg = " ";
                                      for i = 1, math.modf(spacelen) do
                                              spaceMsg = spaceMsg .." ";
                                      end
                                end
                                winMsg = winMsg .. spaceMsg .. itemMenu[i][4] .."\\n"
                        end
                    end
                    NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, winButton, warpPage, winMsg);
                else
                    local winMsg = "3\\n一番賞抽獎背包列表0/0　　　　\\n"
                                                        .."═════════════════════\\n"
                                                        .."序號　　　道具名稱　　　　　　　數量\\n";
                    NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.BUTTON_关闭, 1, winMsg);
                end
        else
                local choose_item = 6 * (warpPage - 1) + column
                --给予道具
                local winMsg = "一番賞抽獎背包\\n"
                                           .."═════════════════════\\n"
                                           .."正在取出道具...\\n"
                                           .."\\n　　　　　　　".. itemMenu[choose_item][2] .."\\n"
                                           .."\\n　　　　　　　當前擁有的數量：".. itemMenu[choose_item][4] .."\\n"
                                           .."\\n請輸入取出數量：\\n";
                local choose = choose_item+1000;
                NLG.ShowWindowTalked(player, npc, CONST.窗口_输入框, CONST.BUTTON_确定关闭, choose, winMsg);

        end
    end)
    self:NPC_regTalkedEvent(clerkNPC, function(npc, player)  ----一番賞抽奖背包managerMenu{}
            local cdk = Char.GetData(player,CONST.对象_CDK);
            SQL.Run("INSERT INTO lua_hook_character (Name,CdKey,OriginalImageNumber) SELECT Name,CdKey,OriginalImageNumber FROM tbl_character WHERE NOT EXISTS ( SELECT Name FROM lua_hook_character WHERE tbl_character.CdKey=lua_hook_character.CdKey)");
            local sqldata = SQL.Run("select IchibanKuji1 from lua_hook_character where CdKey='"..cdk.."'")["0_0"]
            local itemData = {};
            if (type(sqldata)=="string") then
                   itemData = JSON.decode(sqldata);
                   itemMenu = itemData;
            else
                   itemMenu={};
            end
            if (NLG.CanTalk(npc, player) == true) then
                if (itemMenu~=nil and itemMenu~={}) then
                    local winButton = CONST.BUTTON_下取消;
                    local warpPage = 1;
                    local totalPage, remainder = calcWarp()
                    local count = 6 * (warpPage - 1)
                    local winMsg = "3\\n一番賞抽獎背包列表".. warpPage .."/".. totalPage .."　　　　\\n"
                                                        .."═════════════════════\\n"
                                                        .."序號　　　道具名稱　　　　　　　數量\\n";
                    if totalPage == 1 then
                                winButton = CONST.BUTTON_关闭;
                    end
                    if warpPage == totalPage then
                        for i = 1 + count, remainder + count do
                                local len = #itemMenu[i][2];
                                winMsg = winMsg .."[".. itemMenu[i][1] .."]　　　".. itemMenu[i][2]
                                if len <= 20 then
                                      spacelen = 20 - len;
                                      spaceMsg = " ";
                                      for i = 1, math.modf(spacelen) do
                                              spaceMsg = spaceMsg .." ";
                                      end
                                end
                                winMsg = winMsg .. spaceMsg .. itemMenu[i][4] .."\\n"
                        end
                    else
                        for i = 1 + count, 6 + count do
                                local len = #itemMenu[i][2];
                                winMsg = winMsg .."[".. itemMenu[i][1] .."]　　　".. itemMenu[i][2]
                                if len <= 20 then
                                      spacelen = 20 - len;
                                      spaceMsg = " ";
                                      for i = 1, math.modf(spacelen) do
                                              spaceMsg = spaceMsg .." ";
                                      end
                                end
                                winMsg = winMsg .. spaceMsg .. itemMenu[i][4] .."\\n"
                        end
                    end
                    NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, winButton, 1, winMsg);
                else
                    local winMsg = "3\\n一番賞抽獎背包列表0/0　　　　\\n"
                                                        .."═════════════════════\\n"
                                                        .."序號　　　道具名稱　　　　　　　數量\\n";
                    NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.BUTTON_关闭, 1, winMsg);
                end
            end
            return
    end)

end


function IchibanKuji:onIchibanKuji(player, targetcharIndex, itemSlot)
          local itemIndex = Char.GetItemIndex(player, itemSlot);
          local ItemID = Item.GetData(itemIndex, CONST.道具_ID);
          Char.DelItem(player, ItemID, 1)
          --读取签筒
          local gmIndex = NLG.FindUser(GMcdk);
          --local sqldata = Char.GetExtData(gmIndex, 'ichiban_set');
          local sqldata = tostring(SQL.Run("select val from hook_charaext where cdKey='"..GMcdk.."' and sKey='ichiban_set'")["0_0"])
          local KujiAll = {};
          if (type(sqldata)=="string" and sqldata~='') then
               KujiAll = JSON.decode(sqldata);
          else
               KujiAll = {};
          end
          local WinNum = NLG.Rand(1, #KujiAll);
          print(WinNum)
          --洗牌签筒
          local xr = NLG.Rand(1,3);
          for i=1,#KujiAll-1-xr do
                  r = NLG.Rand(1,i+1+xr);
                  temp=KujiAll[r];
                  KujiAll[r]=KujiAll[i];
                  KujiAll[i]=temp;
          end
          --抽奖就位
          --SQL.Run("INSERT INTO lua_hook_character (Name,CdKey,OriginalImageNumber) SELECT Name,CdKey,OriginalImageNumber FROM tbl_character WHERE NOT EXISTS ( SELECT Name FROM lua_hook_character WHERE tbl_character.CdKey=lua_hook_character.CdKey)");
          for k, v in ipairs(KujiTbl) do
             local stick = string.sub(KujiAll[WinNum], 1, 1);
             local kind = string.sub(KujiAll[WinNum], 2);
             print(stick,kind)
             if (WinNum>=1 and WinNum<=#KujiAll) then
                   if (stick=="A" and v.type=="A") then
                         renewItemBag(player, v.Num, v.name, v.itemid, v.count);
                         NLG.Say(player, -1, "恭喜抽中魔力一番賞『".. v.name .."』A賞。", CONST.颜色_红色, CONST.字体_中);               --A賞[2%]
                   elseif (stick=="B" and v.type=="B") then
                         renewItemBag(player, v.Num, v.name, v.itemid, v.count);
                         NLG.Say(player, -1, "恭喜抽中魔力一番賞『".. v.name .."』B賞。", CONST.颜色_绿色, CONST.字体_中);               --B賞[2%]
                   elseif (stick=="C" and v.type=="C") then
                         renewItemBag(player, v.Num, v.name, v.itemid, v.count);
                         NLG.Say(player, -1, "恭喜抽中魔力一番賞『".. v.name .."』C賞。",CONST.颜色_黄色, CONST.字体_中);                --C賞[2%]
                   elseif (stick=="D" and v.type=="D") then
                         renewItemBag(player, v.Num, v.name, v.itemid, v.count);
                         NLG.Say(player, -1, "恭喜抽中魔力一番賞『".. v.name .."』D賞。",CONST.颜色_蓝色, CONST.字体_中);                --D賞[2%]
                   elseif (stick=="E" and v.type=="E") then
                         renewItemBag(player, v.Num, v.name, v.itemid, v.count);
                         NLG.Say(player, -1, "恭喜抽中魔力一番賞『".. v.name .."』E賞。",CONST.颜色_青色, CONST.字体_中);                 --E賞[4%]
                   elseif (stick=="F" and v.type=="F") then
                         renewItemBag(player, v.Num, v.name, v.itemid, v.count);
                         NLG.Say(player, -1, "恭喜抽中魔力一番賞『".. v.name .."』F賞。",CONST.颜色_青色, CONST.字体_中);                 --F賞[4%]
                   elseif (stick=="G" and v.type=="G") then
                         renewItemBag(player, v.Num, v.name, v.itemid, v.count);
                         NLG.Say(player, -1, "恭喜抽中魔力一番賞『".. v.name .."』G賞。",CONST.颜色_灰色, CONST.字体_中);                --G賞[24%]
                   elseif (stick=="H" and v.type=="G") then
                         renewItemBag(player, v.Num, v.name, v.itemid, v.count);
                         NLG.Say(player, -1, "恭喜抽中魔力一番賞『".. v.name .."』H賞。",CONST.颜色_灰蓝色, CONST.字体_中);            --H賞[24%]
                   elseif (stick=="I" and v.type=="I") then
                         renewItemBag(player, v.Num, v.name, v.itemid, v.count);
                         NLG.Say(player, -1, "恭喜抽中魔力一番賞『".. v.name .."』I賞。",CONST.颜色_灰绿色, CONST.字体_中);             --I賞[36%]
                   end
             end
          end
          if (#KujiAll==1) then
                    renewItemBag(player, KujiTbl[1].Num, KujiTbl[1].name, KujiTbl[1].itemid, KujiTbl[1].count);
                    NLG.Say(player, -1, "恭喜得到魔力一番賞『".. KujiTbl[1].name .."』最後賞。", CONST.颜色_紫色, CONST.字体_中);               --最後賞[%]
          end
          --移除该次已中签
          table.remove(KujiAll, WinNum);
          --赋归剩下签
          --Char.SetExtData(gmIndex, 'ichiban_set', JSON.encode(KujiAll));
          local newdata = JSON.encode(KujiAll);
          SQL.Run("update hook_charaext set val= '"..newdata.."' where cdKey='"..GMcdk.."' and sKey='ichiban_set'")
          NLG.UpChar(gmIndex);
          if (#KujiAll==0) then
                    local KujiAll = {
                             "A1", "B1", "C1", "D1", "E1", "E2", "F1", "F2",
                             "G1", "G2", "G3", "G4", "G5", "G6", "G7", "G8", "G9", "G10", "G11", "G12",
                             "H1","H2","H3","H4","H5","H6","H7","H8","H9","H10","H11","H12",
                             "I1","I2","I3","I4","I5","I6","I7","I8","I9","I10","I11","I12","I13","I14","I15","I16","I17","I18",
                    }
                    --洗牌签筒
                    local xr = NLG.Rand(1,3);
                    for i=1,#KujiAll-1-xr do
                            r = NLG.Rand(1,i+1+xr);
                            temp=KujiAll[r];
                            KujiAll[r]=KujiAll[i];
                            KujiAll[i]=temp;
                    end
                    --Char.SetExtData(gmIndex, 'ichiban_set', JSON.encode(KujiAll));
                    local newdata = JSON.encode(KujiAll);
                    SQL.querySQL("update hook_charaext set val= '"..newdata.."' where cdKey='"..GMcdk.."' and sKey='ichiban_set'")
                    SQL.querySQL("update hook_charaext set val= '0' where sKey='ichiban_count'")
                    SQL.querySQL("update hook_charaext set val= '0' where sKey='ichiban_time'")
                    NLG.UpChar(gmIndex);
                    NLG.SystemMessageToMap(0, 1000, "[公告]新一輪的一番賞已經開始，玩家可以去試試手氣！");
          end
end

function renewItemBag(player,Num,name,itemid,count)
              --print(Num);
              --print(name);
              --print(itemid);
              --print(count);
              --下载数据
              local cdk = Char.GetData(player,CONST.对象_CDK);
              local sqldata = SQL.Run("select IchibanKuji1 from lua_hook_character where CdKey='"..cdk.."'")["0_0"]
              local itemData = {};
              if (type(sqldata)=="string" and sqldata~='') then
                   itemData = JSON.decode(sqldata);
              else
                   itemData = {};
              end
              --更新数据
              local boxCheck = 0;
              for k, v in pairs(itemData) do
                   if (itemData[k]~=nil and itemData[k][3]==itemid)  then
                         itemData[k][4] = itemData[k][4] + count;
                   elseif (itemData[k][3]~=itemid) then
                         boxCheck = boxCheck+1;
                   end
              end
              local boxlen = tonumber(#itemData);
              if ( boxCheck==boxlen )  then
                         local boxEX=boxlen+1;
                         itemData[boxEX] = {}
                         table.insert(itemData[boxEX], Num);
                         table.insert(itemData[boxEX], name);
                         table.insert(itemData[boxEX], itemid);
                         table.insert(itemData[boxEX], count);
              end
              --排序数据
              function my_comp(a, b)
                            return a[1] < b[1]
              end
              table.sort(itemData, my_comp);
              --上传数据
              local sqldata = itemData;
              local newdata = JSON.encode(sqldata);
              SQL.Run("update lua_hook_character set IchibanKuji1= '"..newdata.."' where CdKey='"..cdk.."'")
              NLG.UpChar(player);

end

function IchibanKuji:handleTalkEvent(charIndex,msg,color,range,size)
	if (msg=="[nr ichiban restart]") then
		local cdk = Char.GetData(charIndex,CONST.对象_CDK);
		if (cdk == GMcdk) then
			--洗牌签筒
			local xr = NLG.Rand(1,3);
			for i=1,#KujiAll-1-xr do
				r = NLG.Rand(1,i+1+xr);
				temp=KujiAll[r];
				KujiAll[r]=KujiAll[i];
				KujiAll[i]=temp;
			end
			Char.SetExtData(charIndex, 'ichiban_set', JSON.encode(KujiAll));
			local newdata = JSON.encode(KujiAll);
			SQL.querySQL("update hook_charaext set val= '"..newdata.."' where cdKey='"..GMcdk.."' and sKey='ichiban_set'")
			SQL.querySQL("update hook_charaext set val= '0' where sKey='ichiban_count'")
			SQL.querySQL("update hook_charaext set val= '0' where sKey='ichiban_time'")
			NLG.SystemMessage(charIndex, "[系統]一番賞重啟。");
			NLG.UpChar(charIndex);
			return 0;
		end
	end
	return 1;
end

function IchibanKuji:onUnload()
        self:logInfo('unload');
end

return IchibanKuji;
