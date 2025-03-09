local MatchDraw = ModuleBase:createModule('matchDraw')
local JSON=require "lua/Modules/json"

MatchDraw:addMigration(1, 'init lua_hook_character', function()
  SQL.querySQL([[
      CREATE TABLE if not exists `lua_hook_character` (
    `CdKey` char(32) COLLATE gbk_bin NOT NULL,
    `regNo` int(11) NOT NULL,
    `Tenjo` int(10) NOT NULL Default 0,
    `MatchDraw1` mediumtext COLLATE gbk_bin NOT NULL,
    PRIMARY KEY (`CdKey`),
    KEY `regNo` (`regNo`) USING BTREE
  ) ENGINE=Innodb DEFAULT CHARSET=gbk COLLATE=gbk_bin
  ]])
end);


local DrawTbl={
       { Num="001", type="S", serial_L=999, serial_H=1000, name="蕾希夜弦(弓)", itemid=900208, count=1},        --S(1~4)
       { Num="002", type="S", serial_L=993, serial_H=996, name="卡爾薇娜(格)", itemid=900209, count=1},
       { Num="003", type="S", serial_L=989, serial_H=992, name="伊莉菲絲(法)", itemid=900210, count=1},
       { Num="004", type="S", serial_L=985, serial_H=988, name="瑟爾維亞(斧)", itemid=900211, count=1},
       { Num="005", type="A", serial_L=978, serial_H=984, name="歌姬召喚書", itemid=910249, count=1},        --A(5~7)
       { Num="006", type="A", serial_L=971, serial_H=977, name="梅茲召喚書", itemid=910250, count=1},
       { Num="007", type="A", serial_L=964, serial_H=970, name="露比召喚書", itemid=910271, count=1},
       { Num="008", type="B", serial_L=944, serial_H=963, name="聖獸靈氣", itemid=631092, count=30},        --B(8~10)
       { Num="009", type="B", serial_L=924, serial_H=943, name="聖獸靈氣", itemid=631092, count=20},
       { Num="010", type="B", serial_L=904, serial_H=923, name="聖獸靈氣", itemid=631092, count=10},
       { Num="011", type="C", serial_L=849, serial_H=903, name="誘魔藥水", itemid=70085, count=2},           --C(11~14)
       { Num="012", type="C", serial_L=789, serial_H=848, name="驅魔藥水", itemid=70086, count=2},
       { Num="013", type="C", serial_L=729, serial_H=788, name="滿怪藥水", itemid=70087, count=2},
       { Num="014", type="D", serial_L=669, serial_H=728, name="【攻武】黑暗卷軸", itemid=71034, count=1},      --D(15~18)
       { Num="015", type="D", serial_L=608, serial_H=668, name="【法武】黑暗卷軸", itemid=71037, count=1},
       { Num="016", type="D", serial_L=508, serial_H=607, name="【帽盔】黑暗卷軸", itemid=71040, count=1},
       { Num="017", type="D", serial_L=408, serial_H=507, name="【衣鎧】黑暗卷軸", itemid=71043, count=1},
       { Num="018", type="D", serial_L=308, serial_H=407, name="【鞋靴】黑暗卷軸", itemid=71046, count=1},
       { Num="019", type="E", serial_L=208, serial_H=307, name="料理箱", itemid=910251, count=1},            --E(19~21)
       { Num="020", type="E", serial_L=108, serial_H=207, name="藥水箱", itemid=910252, count=1},
       { Num="021", type="E", serial_L=7, serial_H=107, name="人物形象卡", itemid=70060, count=1},
}

--[[
local itemMenu={
        {"001","測試道具",69000,1},
        {"002","測試道具",69000,1},}
]]

local function calcWarp()--计算页数和最后一页数量
  local totalpage = math.modf(#itemMenu / 6) + 1
  local remainder = math.fmod(#itemMenu, 6)
  return totalpage, remainder
end

function MatchDraw:onLoad()
    self:logInfo('load')
    self:regCallback("ItemString", Func.bind(self.onMatchDraw, self), 'LUA_useDraw');
    local managerNPC = self:NPC_createNormal('火柴抽獎經理', 14154, { x = 231, y = 106, mapType = 0, map = 1000, direction = 4 });
    self:NPC_regWindowTalkedEvent(managerNPC, function(npc, player, _seqno, _select, _data)
        local column = tonumber(_data)
        local page = tonumber(_seqno)
        local data = tonumber(_data)
        local warpPage = page;
        local winButton = CONST.BUTTON_关闭;
        --local totalPage, remainder = calcWarp()
        --下载数据
        local cdk = Char.GetData(player,CONST.对象_CDK);
        local regNumber = Char.GetData(player,CONST.对象_RegistNumber);
        --local tenjo = tonumber(SQL.Run("select Tenjo from lua_hook_character where CdKey='"..cdk.."' and regNo='"..regNumber.."' "))
        local res = SQL.QueryEx("select Tenjo from lua_hook_character where CdKey='"..cdk.."' and regNo='"..regNumber.."'",Tenjo)
        for i,row in ipairs(res.rows) do
           tenjo = tonumber(row.Tenjo);
           if tenjo==nil then tenjo=0; end
        end

        local itemData = {};
        itemMenu = {};
        local sql = SQL.QueryEx("select MatchDraw1 from lua_hook_character where CdKey='"..cdk.."' and regNo='"..regNumber.."'",MatchDraw1)
        for i,row in ipairs(sql.rows) do
          --sqldata = (row.MatchDraw1);
          local MatchDraw1,pos = JSON.parse(row.MatchDraw1)
          itemData = MatchDraw1;
          itemMenu = itemData;
        end

        --[[if (type(sqldata)=="string") then
               itemData = JSON.decode(sqldata);
               itemMenu = itemData;
        else
               itemMenu={};
        end]]
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
                                                --SQL.Run("update lua_hook_character set MatchDraw1= NULL where CdKey='"..cdk.."' and regNo='"..regNumber.."'")
                                                --SQL.querySQL("REPLACE INTO lua_hook_character set MatchDraw1= NULL where CdKey='"..cdk.."' and regNo='"..regNumber.."' ");
                                                SQL.querySQL("REPLACE INTO lua_hook_character (CdKey,regNo,MatchDraw1) VALUES ("..SQL.sqlValue(cdk)..","..SQL.sqlValue(regNumber)..","..SQL.sqlValue(JSON.stringify(itemMenu))..") ");
                                                NLG.UpChar(player);
                                                return;
                                       else
                                                local sqldata = itemData;
                                                --local newdata = JSON.encode(sqldata);
                                                --SQL.Run("update lua_hook_character set MatchDraw1= '"..newdata.."' where CdKey='"..cdk.."' and regNo='"..regNumber.."'")
                                                --SQL.querySQL("REPLACE INTO lua_hook_character set MatchDraw1= '"..SQL.sqlValue(newdata).."' where CdKey='"..cdk.."' and regNo='"..regNumber.."' ");
                                                SQL.querySQL("REPLACE INTO lua_hook_character (CdKey,regNo,MatchDraw1) VALUES ("..SQL.sqlValue(cdk)..","..SQL.sqlValue(regNumber)..","..SQL.sqlValue(JSON.stringify(sqldata))..") ");
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
                    --local winMsg = "3\\n火柴抽獎背包列表".. warpPage .."/".. totalPage .."　　　　保底天井：".. tenjo .."/700\\n"
                    local winMsg = "3\\n火柴抽獎背包列表".. warpPage .."/".. totalPage .."　　　　\\n"
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
                    --local winMsg = "3\\n火柴抽獎背包列表0/0　　　　保底天井：".. tenjo .."/700\\n"
                    local winMsg = "3\\n火柴抽獎背包列表0/0　　　　\\n"
                                                        .."═════════════════════\\n"
                                                        .."序號　　　道具名稱　　　　　　　數量\\n";
                    NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.BUTTON_关闭, 1, winMsg);
                end
        else
                local choose_item = 6 * (warpPage - 1) + column
                --给予道具
                local winMsg = "火柴抽獎背包\\n"
                                           .."═════════════════════\\n"
                                           .."正在取出道具...\\n"
                                           .."\\n　　　　　　　".. itemMenu[choose_item][2] .."\\n"
                                           .."\\n　　　　　　　當前擁有的數量：".. itemMenu[choose_item][4] .."\\n"
                                           .."\\n請輸入取出數量：\\n";
                local choose = choose_item+1000;
                NLG.ShowWindowTalked(player, npc, CONST.窗口_输入框, CONST.BUTTON_确定关闭, choose, winMsg);

        end
    end)
    self:NPC_regTalkedEvent(managerNPC, function(npc, player)  ----火柴抽奖背包managerMenu{}
            local cdk = Char.GetData(player,CONST.对象_CDK);
            local regNumber = Char.GetData(player,CONST.对象_RegistNumber);
            --SQL.querySQL("REPLACE INTO lua_hook_character (CdKey,regNo) VALUES ("..SQL.sqlValue(cdk)..","..SQL.sqlValue(regNumber)..")");
            --SQL.Run("INSERT INTO lua_hook_character (Name,CdKey) SELECT Name,CdKey FROM tbl_character WHERE NOT EXISTS ( SELECT Name FROM lua_hook_character WHERE tbl_character.CdKey=lua_hook_character.CdKey)");
            local res = SQL.QueryEx("select Tenjo from lua_hook_character where CdKey='"..cdk.."' and regNo='"..regNumber.."'",Tenjo)
            for i,row in ipairs(res.rows) do
               tenjo = tonumber(row.Tenjo);
               if tenjo==nil then tenjo=0; end
            end

            local itemData = {};
            itemMenu = {};
            local sql = SQL.QueryEx("select MatchDraw1 from lua_hook_character where CdKey='"..cdk.."' and regNo='"..regNumber.."'",MatchDraw1)
            for i,row in ipairs(sql.rows) do
              --sqldata = (row.MatchDraw1);
              local MatchDraw1,pos = JSON.parse(row.MatchDraw1)
              itemData = MatchDraw1;
              itemMenu = itemData;
            end

            --[[if (type(sqldata)=="string") then
                   itemData = JSON.decode(sqldata);
                   itemMenu = itemData;
            else
                   itemMenu={};
            end]]
            if (NLG.CanTalk(npc, player) == true) then
                if (itemMenu~=nil and itemMenu~={}) then
                    local winButton = CONST.BUTTON_下取消;
                    local warpPage = 1;
                    local totalPage, remainder = calcWarp()
                    local count = 6 * (warpPage - 1)
                    --local winMsg = "3\\n火柴抽獎背包列表".. warpPage .."/".. totalPage .."　　　　保底天井：".. tenjo .."/700\\n"
                    local winMsg = "3\\n火柴抽獎背包列表".. warpPage .."/".. totalPage .."　　　　\\n"
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
                    --local winMsg = "3\\n火柴抽獎背包列表0/0　　　　保底天井：".. tenjo .."/700\\n"
                    local winMsg = "3\\n火柴抽獎背包列表0/0　　　　\\n"
                                                        .."═════════════════════\\n"
                                                        .."序號　　　道具名稱　　　　　　　數量\\n";
                    NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.BUTTON_关闭, 1, winMsg);
                end
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
          local cdk = Char.GetData(player,CONST.对象_CDK);
          local regNumber = Char.GetData(player,CONST.对象_RegistNumber);
          --SQL.querySQL("REPLACE INTO lua_hook_character (CdKey,regNo) VALUES ("..SQL.sqlValue(cdk)..","..SQL.sqlValue(regNumber)..") ");
          --SQL.Run("INSERT INTO lua_hook_character (Name,CdKey) SELECT Name,CdKey FROM tbl_character WHERE NOT EXISTS ( SELECT Name FROM lua_hook_character WHERE tbl_character.CdKey=lua_hook_character.CdKey)");
          local res = SQL.QueryEx("select Tenjo from lua_hook_character where CdKey='"..cdk.."' and regNo='"..regNumber.."'",Tenjo)
          for i,row in ipairs(res.rows) do
             tenjo = tonumber(row.Tenjo);
		     if tenjo==nil then tenjo=0; end
          end
          for k, v in ipairs(DrawTbl) do
             if (WinNum>=v.serial_L and WinNum<=v.serial_H) then
                   --[[if (tenjo>=699) then
                         renewItemBag(player, DrawTbl[1].Num, DrawTbl[1].name, DrawTbl[1].itemid, DrawTbl[1].count);
                         NLG.Say(player, -1, "天井抽中火柴『".. DrawTbl[1].name .."』特等獎。", CONST.颜色_红色, CONST.字体_中);               --天井
                         return;
                   end]]
                   if (v.type=="S") then
                         renewItemBag(player, v.Num, v.name, v.itemid, v.count);
                         NLG.Say(player, -1, "恭喜抽中火柴『".. v.name .."』特等獎。", CONST.颜色_红色, CONST.字体_中);               --特等獎[0.1%]
                   elseif (v.type=="A") then
                         renewItemBag(player, v.Num, v.name, v.itemid, v.count);
                         NLG.Say(player, -1, "恭喜抽中火柴『".. v.name .."』一等獎。", CONST.颜色_黄色, CONST.字体_中);               --一等獎[0.9%]
                   elseif (v.type=="B") then
                         renewItemBag(player, v.Num, v.name, v.itemid, v.count);
                         NLG.Say(player, -1, "恭喜抽中火柴『".. v.name .."』二等獎。",CONST.颜色_青色, CONST.字体_中);                --二等獎[2%]
                   elseif (v.type=="C") then
                         renewItemBag(player, v.Num, v.name, v.itemid, v.count);
                         NLG.Say(player, -1, "恭喜抽中火柴『".. v.name .."』三等獎。",CONST.颜色_灰蓝色, CONST.字体_中);            --三等獎[6%]
                   elseif (v.type=="D") then
                         renewItemBag(player, v.Num, v.name, v.itemid, v.count);
                         NLG.Say(player, -1, "恭喜抽中火柴『".. v.name .."』四等獎。",CONST.颜色_灰绿色, CONST.字体_中);            --四等獎[30%]
                   elseif (v.type=="E") then
                         renewItemBag(player, v.Num, v.name, v.itemid, v.count);
                         NLG.Say(player, -1, "恭喜抽中火柴『".. v.name .."』安慰獎。", CONST.颜色_灰色, CONST.字体_中);               --安慰獎[60%]
                   end
             end
          end
end

function renewItemBag(player,Num,name,itemid,count)
              --print(Num);
              --print(name);
              --print(itemid);
              --print(count);
              --下载数据
              local cdk = Char.GetData(player,CONST.对象_CDK);
              local regNumber = Char.GetData(player,CONST.对象_RegistNumber);
              --local tenjo = tonumber(SQL.QueryEx("select Tenjo from lua_hook_character where CdKey="..cdk.." and regNo="..regNumber.." "))
              local res = SQL.QueryEx("select Tenjo from lua_hook_character where CdKey='"..cdk.."' and regNo='"..regNumber.."'",Tenjo)
              for i,row in ipairs(res.rows) do
                 tenjo = tonumber(row.Tenjo);
                 if tenjo==nil then tenjo=0; end
              end

              local itemData = {};
              local sql = SQL.QueryEx("select MatchDraw1 from lua_hook_character where CdKey='"..cdk.."' and regNo='"..regNumber.."'",MatchDraw1)
              for i,row in ipairs(sql.rows) do
                --sqldata = (row.MatchDraw1);
                local MatchDraw1,pos = JSON.parse(row.MatchDraw1)
                itemData = MatchDraw1;
              end
              --[[if (type(sqldata)=="string" and sqldata~='') then
                   itemData = JSON.decode(sqldata);
              else
                   itemData = {};
              end]]
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
              --local newdata = JSON.encode(sqldata);
              --SQL.Run("update lua_hook_character set MatchDraw1= '"..newdata.."' where CdKey='"..cdk.."' and regNo='"..regNumber.."'")
              --SQL.querySQL("REPLACE INTO lua_hook_character set MatchDraw1= '"..SQL.sqlValue(newdata).."' where CdKey='"..cdk.."' and regNo='"..regNumber.."' ");
              --local tenjo = tenjo+1;
              --if (tenjo==700) then tenjo=0; end
              --SQL.Run("update lua_hook_character set Tenjo= '"..tenjo.."' where CdKey='"..cdk.." and regNo='"..regNumber.."'")
              --SQL.querySQL("REPLACE INTO lua_hook_character set Tenjo= '"..SQL.sqlValue(tenjo).."' where CdKey='"..cdk.." and regNo='"..regNumber.."' ");
              SQL.querySQL("REPLACE INTO lua_hook_character (CdKey,regNo,MatchDraw1) VALUES ("..SQL.sqlValue(cdk)..","..SQL.sqlValue(regNumber)..","..SQL.sqlValue(JSON.stringify(sqldata))..") ");
              NLG.UpChar(player);

end

function MatchDraw:onUnload()
        self:logInfo('unload');
end

return MatchDraw;