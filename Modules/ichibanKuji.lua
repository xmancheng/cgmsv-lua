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
local KujiAll_1 = {
         "A1", "B1", "C1", "C2", "D1", "D2", "E1", "F1",
         "G1", "G2", "G3", "G4", "G5", "G6", "G7", "G8", "G9", "G10", "G11", "G12",
}
local KujiAll_2 = {
         "H1","H2","H3","H4","H5","H6","H7","H8","H9","H10","H11","H12",
         "I1","I2","I3","I4","I5","I6","I7","I8","I9","I10","I11","I12","I13","I14","I15","I16","I17","I18",
}
local KujiTbl={
       { Num="001", type="L", serial_L=51, serial_H=51, name="天使之祝福", itemid=45953, count=1},
       { Num="002", type="A", serial_L=1, serial_H=1, name="天使之祝福", itemid=45953, count=1},
       { Num="003", type="B", serial_L=2, serial_H=2, name="迅速果斷之劍", itemid=46903, count=1},
       { Num="004", type="C", serial_L=3, serial_H=3, name="戒驕戒躁之斧", itemid=46901, count=1},
       { Num="005", type="C", serial_L=4, serial_H=4, name="一石二鳥之槍", itemid=46902, count=1},
       { Num="006", type="D", serial_L=5, serial_H=5, name="爆擊之書", itemid=45979, count=1},
       { Num="007", type="D", serial_L=6, serial_H=6, name="必中之書", itemid=45980, count=1},
       { Num="008", type="E", serial_L=7, serial_H=7, name="神導士守護", itemid=45968, count=1},
       { Num="009", type="F", serial_L=8, serial_H=8, name="大法師之魂", itemid=45967, count=1},
       { Num="010", type="G", serial_L=9, serial_H=20, name="強力攻擊手環", itemid=45510, count=1},
       { Num="011", type="H", serial_L=21, serial_H=32, name="風神高速手環", itemid=45512, count=1},
       { Num="012", type="I", serial_L=33, serial_H=50, name="絕對防禦手環", itemid=45511, count=1},
}


local function calcWarp()--计算页数和最后一页数量
  local totalpage = math.modf(#itemMenu / 6) + 1
  local remainder = math.fmod(#itemMenu, 6)
  return totalpage, remainder
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
        local sqldata_1 = Field.Get(gmIndex, 'ichiban_set_1');
        local KujiAll_1 = {};
        if (type(sqldata_1)=="string" and sqldata_1~='') then
               KujiAll_1 = JSON.decode(sqldata_1);
        else
               KujiAll_1 = {};
        end
        local sqldata_2 = Field.Get(gmIndex, 'ichiban_set_2');
        local KujiAll_2 = {};
        if (type(sqldata_2)=="string" and sqldata_2~='') then
               KujiAll_2 = JSON.decode(sqldata_2);
        else
               KujiAll_2 = {};
        end
        local KujiAll = {};
        for i=1,#KujiAll_1 do
              table.insert(KujiAll, KujiAll_1[i]);
        end
        for i=1,#KujiAll_2 do
              table.insert(KujiAll, KujiAll_2[i]);
        end
        if _select == CONST.BUTTON_是  then
                --冷静时间计算

                --所需银币计算

                local winMsg = "魔力一番賞購買抽獎籤\\n"
                                           .."═════════════════════\\n"
                                           .."正在購買道具...\\n"
                                           .."\\n　　　　　　　冷靜期剩下時間：\\n"
                                           .."\\n　　　　　　　一抽所需銀幣：\\n"
                                           .."\\n請輸入購買數量(每次不得超過5張)：\\n";
                NLG.ShowWindowTalked(player, npc, CONST.窗口_输入框, CONST.BUTTON_确定关闭, 11, winMsg);
        elseif _select > 0 then
                if _select == CONST.BUTTON_关闭 then
                    return;
                end
                --给予一番赏签
                if (_select == CONST.BUTTON_确定) then
                       if (data>#KujiAll) then
                             NLG.Say(player, -1, "[系統]購買數量超過目前籤的上限", CONST.颜色_黄色, CONST.字体_中);
                             return;
                       elseif (data<=5) then
                             for i=1,data do
                                 --Char.GiveItem(player, 70095, 1);
                                 --local itemSlot = Char.FindItemId(player, 70095);
                                 self:onIchibanKuji(player, targetcharIndex, itemSlot);
                             end
                       else
                             NLG.Say(player, -1, "[系統]購買數量超過一次上限５張", CONST.颜色_黄色, CONST.字体_中);
                             return;
                       end
                end
        end
    end)
    self:NPC_regTalkedEvent(noticeNPC, function(npc, player)  ----一番賞資訊告示
          --读取签筒
          local gmIndex = NLG.FindUser(GMcdk);
          local sqldata_1 = Field.Get(gmIndex, 'ichiban_set_1');
          local KujiAll_1 = {};
          if (type(sqldata_1)=="string" and sqldata_1~='') then
               KujiAll_1 = JSON.decode(sqldata_1);
          else
               KujiAll_1 = {};
          end
          local sqldata_2 = Field.Get(gmIndex, 'ichiban_set_2');
          local KujiAll_2 = {};
          if (type(sqldata_2)=="string" and sqldata_2~='') then
               KujiAll_2 = JSON.decode(sqldata_2);
          else
               KujiAll_2 = {};
          end
          local KujiAll = {};
          for i=1,#KujiAll_1 do
              table.insert(KujiAll, KujiAll_1[i]);
          end
          for i=1,#KujiAll_2 do
              table.insert(KujiAll, KujiAll_2[i]);
          end
          --计算各种类剩余签数

          if (NLG.CanTalk(npc, player) == true) then
              if (KujiAll~=nil and KujiAll~={}) then
                    local winMsg = "\\n          ★★★★★★魔力一番賞說明告示★★★★★★\\n"
                                               .."\\n　新遊戲完整的籤數總共有50張，目前剩餘籤數：\\n"
                                               .."\\n╔═══╦═══╦═══╦═══╦═══╦═══╦═══╗"
                                               .."\\n║　Ａ　║　Ｂ　║　Ｃ　║　Ｄ　║　Ｅ　║　Ｆ　║　Ｇ　║"
                                               .."\\n╠═══╬═══╬═══╬═══╬═══╬═══╬═══╣"
                                               .."\\n║　　　║　　　║　　　║　　　║　　　║　　　║　　　║"
                                               .."\\n╚═══╩═══╩═══╩═══╩═══╩═══╩═══╝"
                                               .."\\n　Ａ　賞　【　"..KujiTbl[2].name.."　】　Ｂ　賞　【　"..KujiTbl[3].name.."　】"
                                               .."\\n　Ｃ　賞　【　"..KujiTbl[4].name.."　】 【　"..KujiTbl[5].name.."　】"
                                               .."\\n　Ｄ　賞　【　"..KujiTbl[6].name.."　】 【　"..KujiTbl[7].name.."　】"
                                               .."\\n　Ｅ　賞　【　"..KujiTbl[8].name.." 　】　Ｆ　賞　【　"..KujiTbl[9].name.."　】"
                                               .."\\n　Ｇ　賞　【　"..KujiTbl[10].name.."　】"
                                               .."\\n　Ｈ　賞　【　"..KujiTbl[11].name.."　】"
                                               .."\\n　Ｉ　賞　【　"..KujiTbl[12].name.."　】"
                                               .."\\n　最後賞　【　偽裝噴漆道具　】\\n"
                                               .."\\n　每抽1次：1枚〈銀幣〉，每5抽後累積上漲1枚〈銀幣〉"
                                               .."\\n　抽籤後經過八小時的冷卻時間，重置回到1枚〈銀幣〉"
                                               .."\\n　最後抽取到第80抽者，獲得《最後賞》額外獎勵";
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
        local tenjo = tonumber(SQL.Run("select Tenjo from lua_hook_character where CdKey='"..cdk.."'")["0_0"])
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
            local tenjo = tonumber(SQL.Run("select Tenjo from lua_hook_character where CdKey='"..cdk.."'")["0_0"])
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
          local sqldata_1 = Field.Get(gmIndex, 'ichiban_set_1');
          local KujiAll_1 = {};
          if (type(sqldata_1)=="string" and sqldata_1~='') then
               KujiAll_1 = JSON.decode(sqldata_1);
          else
               KujiAll_1 = {};
          end
          local sqldata_2 = Field.Get(gmIndex, 'ichiban_set_2');
          local KujiAll_2 = {};
          if (type(sqldata_2)=="string" and sqldata_2~='') then
               KujiAll_2 = JSON.decode(sqldata_2);
          else
               KujiAll_2 = {};
          end
          local KujiAll = {};
          for i=1,#KujiAll_1 do
              table.insert(KujiAll, KujiAll_1[i]);
          end
          for i=1,#KujiAll_2 do
              table.insert(KujiAll, KujiAll_2[i]);
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
          SQL.Run("INSERT INTO lua_hook_character (Name,CdKey,OriginalImageNumber) SELECT Name,CdKey,OriginalImageNumber FROM tbl_character WHERE NOT EXISTS ( SELECT Name FROM lua_hook_character WHERE tbl_character.CdKey=lua_hook_character.CdKey)");
          for k, v in ipairs(KujiTbl) do
             local stick = string.sub(KujiAll[WinNum], 1, 1);
             local kind = string.sub(KujiAll[WinNum], 2);
             --print(stick,kind)
             if (WinNum>=1 and WinNum<=#KujiAll) then
                   if (stick=="A" and v.type=="A") then
                         renewItemBag(player, v.Num, v.name, v.itemid, v.count);
                         NLG.Say(player, -1, "恭喜抽中魔力一番賞『".. v.name .."』A賞。", CONST.颜色_红色, CONST.字体_中);               --A賞[2%]
                   elseif (stick=="B" and v.type=="B") then
                         renewItemBag(player, v.Num, v.name, v.itemid, v.count);
                         NLG.Say(player, -1, "恭喜抽中魔力一番賞『".. v.name .."』B賞。", CONST.颜色_红色, CONST.字体_中);               --B賞[2%]
                   elseif (stick=="C" and v.type=="C") then
                         if (kind==1 and v.serial_L==3) then
                             renewItemBag(player, v.Num, v.name, v.itemid, v.count);
                             NLG.Say(player, -1, "恭喜抽中魔力一番賞『".. v.name .."』C賞。",CONST.颜色_黄色, CONST.字体_中);                --C賞[2%]
                         elseif (kind==2 and v.serial_L==4) then
                             renewItemBag(player, v.Num, v.name, v.itemid, v.count);
                             NLG.Say(player, -1, "恭喜抽中魔力一番賞『".. v.name .."』C賞。",CONST.颜色_黄色, CONST.字体_中);                --C賞[2%]
                         end
                   elseif (stick=="D" and v.type=="D") then
                         if (kind==1 and v.serial_L==5) then
                             renewItemBag(player, v.Num, v.name, v.itemid, v.count);
                             NLG.Say(player, -1, "恭喜抽中魔力一番賞『".. v.name .."』D賞。",CONST.颜色_黄色, CONST.字体_中);                --D賞[2%]
                         elseif (kind==2 and v.serial_L==6) then
                             renewItemBag(player, v.Num, v.name, v.itemid, v.count);
                             NLG.Say(player, -1, "恭喜抽中魔力一番賞『".. v.name .."』D賞。",CONST.颜色_黄色, CONST.字体_中);                --D賞[2%]
                         end
                   elseif (stick=="E" and v.type=="E") then
                         renewItemBag(player, v.Num, v.name, v.itemid, v.count);
                         NLG.Say(player, -1, "恭喜抽中魔力一番賞『".. v.name .."』E賞。",CONST.颜色_青色, CONST.字体_中);                 --E賞[2%]
                   elseif (stick=="F" and v.type=="F") then
                         renewItemBag(player, v.Num, v.name, v.itemid, v.count);
                         NLG.Say(player, -1, "恭喜抽中魔力一番賞『".. v.name .."』F賞。",CONST.颜色_青色, CONST.字体_中);                 --F賞[2%]
                   elseif (stick=="G" and v.type=="G") then
                         renewItemBag(player, v.Num, v.name, v.itemid, v.count);
                         NLG.Say(player, -1, "恭喜抽中魔力一番賞『".. v.name .."』G賞。",CONST.颜色_灰蓝色, CONST.字体_中);            --G賞[24%]
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
                    NLG.Say(player, -1, "恭喜得到魔力一番賞『".. KujiTbl[1].name .."』最後賞。", CONST.颜色_红色, CONST.字体_中);               --最後賞[%]
                    local KujiAll_1 = {
                             "A1", "B1", "C1", "C2", "D1", "D2", "E1", "F1",
                             "G1", "G2", "G3", "G4", "G5", "G6", "G7", "G8", "G9", "G10", "G11", "G12",
                    }
                    local KujiAll_2 = {
                             "H1","H2","H3","H4","H5","H6","H7","H8","H9","H10","H11","H12",
                             "I1","I2","I3","I4","I5","I6","I7","I8","I9","I10","I11","I12","I13","I14","I15","I16","I17","I18",
                    }
                    Field.Set(gmIndex, 'ichiban_set_1', JSON.encode(KujiAll_1));
                    Field.Set(gmIndex, 'ichiban_set_2', JSON.encode(KujiAll_2));
                    NLG.UpChar(gmIndex);
                    NLG.SystemMessageToMap(0, 1000, "[公告]新一輪的一番賞已經開始，玩家可以去試試手氣！");
          end
          --移除该次已中签
          table.remove(KujiAll, WinNum);
          --赋归剩下签
          if (#KujiAll>=20) then
             local KujiAll_1={}
             local KujiAll_2={}
             for i=1,20 do
                 table.insert(KujiAll_1, KujiAll[i]);
             end
             for i=21,#KujiAll do
                 table.insert(KujiAll_2, KujiAll[i]);
             end
             Field.Set(gmIndex, 'ichiban_set_1', JSON.encode(KujiAll_1));
             Field.Set(gmIndex, 'ichiban_set_2', JSON.encode(KujiAll_2));
             NLG.UpChar(gmIndex);
          else
             local KujiAll_1={}
             local KujiAll_2={}
             for i=1,#KujiAll do
                 table.insert(KujiAll_1, KujiAll[i]);
             end
             Field.Set(gmIndex, 'ichiban_set_1', JSON.encode(KujiAll_1));
             Field.Set(gmIndex, 'ichiban_set_2', JSON.encode(KujiAll_2));
             NLG.UpChar(gmIndex);
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
			Field.Set(charIndex, 'ichiban_set_1', JSON.encode(KujiAll_1));
			Field.Set(charIndex, 'ichiban_set_2', JSON.encode(KujiAll_2));
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
