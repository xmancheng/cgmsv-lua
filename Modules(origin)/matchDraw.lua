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
       { Num="001", type="S", serial_L=999, serial_H=1000, name="��ϣҹ��(��)", itemid=900208, count=1},        --S(1~4)
       { Num="002", type="S", serial_L=993, serial_H=996, name="����ޱ��(��)", itemid=900209, count=1},
       { Num="003", type="S", serial_L=989, serial_H=992, name="����ƽz(��)", itemid=900210, count=1},
       { Num="004", type="S", serial_L=985, serial_H=988, name="ɪ���S��(��)", itemid=900211, count=1},
       { Num="005", type="A", serial_L=978, serial_H=984, name="�輧�ن���", itemid=910249, count=1},        --A(5~7)
       { Num="006", type="A", serial_L=971, serial_H=977, name="÷Ɲ�ن���", itemid=910250, count=1},
       { Num="007", type="A", serial_L=964, serial_H=970, name="¶���ن���", itemid=910271, count=1},
       { Num="008", type="B", serial_L=944, serial_H=963, name="�}�F�`��", itemid=631092, count=30},        --B(8~10)
       { Num="009", type="B", serial_L=924, serial_H=943, name="�}�F�`��", itemid=631092, count=20},
       { Num="010", type="B", serial_L=904, serial_H=923, name="�}�F�`��", itemid=631092, count=10},
       { Num="011", type="C", serial_L=849, serial_H=903, name="�Tħˎˮ", itemid=70085, count=2},           --C(11~14)
       { Num="012", type="C", serial_L=789, serial_H=848, name="�ħˎˮ", itemid=70086, count=2},
       { Num="013", type="C", serial_L=729, serial_H=788, name="�M��ˎˮ", itemid=70087, count=2},
       { Num="014", type="D", serial_L=669, serial_H=728, name="�����䡿�ڰ����S", itemid=71034, count=1},      --D(15~18)
       { Num="015", type="D", serial_L=608, serial_H=668, name="�����䡿�ڰ����S", itemid=71037, count=1},
       { Num="016", type="D", serial_L=508, serial_H=607, name="��ñ�����ڰ����S", itemid=71040, count=1},
       { Num="017", type="D", serial_L=408, serial_H=507, name="�����z���ڰ����S", itemid=71043, count=1},
       { Num="018", type="D", serial_L=308, serial_H=407, name="��Ьѥ���ڰ����S", itemid=71046, count=1},
       { Num="019", type="E", serial_L=208, serial_H=307, name="������", itemid=910251, count=1},            --E(19~21)
       { Num="020", type="E", serial_L=108, serial_H=207, name="ˎˮ��", itemid=910252, count=1},
       { Num="021", type="E", serial_L=7, serial_H=107, name="��������", itemid=70060, count=1},
}

--[[
local itemMenu={
        {"001","�yԇ����",69000,1},
        {"002","�yԇ����",69000,1},}
]]

local function calcWarp()--����ҳ�������һҳ����
  local totalpage = math.modf(#itemMenu / 6) + 1
  local remainder = math.fmod(#itemMenu, 6)
  return totalpage, remainder
end

function MatchDraw:onLoad()
    self:logInfo('load')
    self:regCallback("ItemString", Func.bind(self.onMatchDraw, self), 'LUA_useDraw');
    local managerNPC = self:NPC_createNormal('���骄����', 14154, { x = 231, y = 106, mapType = 0, map = 1000, direction = 4 });
    self:NPC_regWindowTalkedEvent(managerNPC, function(npc, player, _seqno, _select, _data)
        local column = tonumber(_data)
        local page = tonumber(_seqno)
        local data = tonumber(_data)
        local warpPage = page;
        local winButton = CONST.BUTTON_�ر�;
        --local totalPage, remainder = calcWarp()
        --��������
        local cdk = Char.GetData(player,CONST.����_CDK);
        local regNumber = Char.GetData(player,CONST.����_RegistNumber);
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
        --��ҳ16 ��ҳ32 �ر�/ȡ��2
        if _select > 0 then
                if _select == CONST.BUTTON_�ر� then
                    return;
                end
                --�������
                local choose = tonumber(_seqno);
                if (_select == CONST.BUTTON_ȷ��) then
                        if (data==nil or math.floor(data)~=data) then
                              return;
                        else
                              local key=choose - 1000;
                              if (data<=itemMenu[key][4]) then
                                       local ItemsetIndex = Data.ItemsetGetIndex(itemMenu[key][3]);
                                       local stack = Data.ItemsetGetData(ItemsetIndex, CONST.ITEMSET_MAXREMAIN);
                                       local slot = math.modf(data / stack);                --������ռ�ø���(s��)
                                       local excess = math.fmod(data, stack);            --�����������(1��)
                                       if (excess>0) then slot=slot+1; end
                                       if (Char.ItemSlot(player)<=20-slot) then
                                            itemData[key][4] = itemData[key][4] - data;
                                            Char.GiveItem(player,itemMenu[key][3],data);
                                       else
                                            NLG.Say(player, -1, "ע����ȡ�������^��Ʒ�ڣ�", CONST.��ɫ_��ɫ, CONST.����_��);
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
                                       NLG.Say(player, -1, "��".. itemMenu[key][2] .."����ȡ�������^��".. itemMenu[key][4] .."��", CONST.��ɫ_��ɫ, CONST.����_��);
                                       return;
                              end
                        end
                end
                if (itemMenu~=nil and itemMenu~={}) then
                    local totalPage, remainder = calcWarp()
                    --�����б�
                    if _select == CONST.BUTTON_��һҳ then
                        warpPage = warpPage + 1
                        if (warpPage == totalPage) or ((warpPage == (totalPage - 1) and remainder == 0)) then
                                winButton = CONST.BUTTON_��ȡ��
                        else
                                winButton = CONST.BUTTON_����ȡ��
                        end
                    elseif _select == CONST.BUTTON_��һҳ then
                        warpPage = warpPage - 1
                        if warpPage == 1 then
                                winButton = CONST.BUTTON_��ȡ��
                                if totalPage == 1 then
                                        winButton = CONST.BUTTON_�ر�;
                                end
                        else
                                winButton = CONST.BUTTON_����ȡ��
                        end
                    elseif _select == 2 then
                        warpPage = 1
                        return
                    end
                    local count = 6 * (warpPage - 1)
                    --local winMsg = "3\\n���骄�����б�".. warpPage .."/".. totalPage .."�������������쾮��".. tenjo .."/700\\n"
                    local winMsg = "3\\n���骄�����б�".. warpPage .."/".. totalPage .."��������\\n"
                                                        .."�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
                                                        .."��̖�������������Q������������������\\n";
                    if warpPage == totalPage then
                        for i = 1 + count, remainder + count do
                                local len = #itemMenu[i][2];
                                winMsg = winMsg .."[".. itemMenu[i][1] .."]������".. itemMenu[i][2]
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
                                winMsg = winMsg .."[".. itemMenu[i][1] .."]������".. itemMenu[i][2]
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
                    NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, winButton, warpPage, winMsg);
                else
                    --local winMsg = "3\\n���骄�����б�0/0�������������쾮��".. tenjo .."/700\\n"
                    local winMsg = "3\\n���骄�����б�0/0��������\\n"
                                                        .."�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
                                                        .."��̖�������������Q������������������\\n";
                    NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, CONST.BUTTON_�ر�, 1, winMsg);
                end
        else
                local choose_item = 6 * (warpPage - 1) + column
                --�������
                local winMsg = "���骄����\\n"
                                           .."�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
                                           .."����ȡ������...\\n"
                                           .."\\n��������������".. itemMenu[choose_item][2] .."\\n"
                                           .."\\n����������������ǰ���еĔ�����".. itemMenu[choose_item][4] .."\\n"
                                           .."\\nՈݔ��ȡ��������\\n";
                local choose = choose_item+1000;
                NLG.ShowWindowTalked(player, npc, CONST.����_�����, CONST.BUTTON_ȷ���ر�, choose, winMsg);

        end
    end)
    self:NPC_regTalkedEvent(managerNPC, function(npc, player)  ----���齱����managerMenu{}
            local cdk = Char.GetData(player,CONST.����_CDK);
            local regNumber = Char.GetData(player,CONST.����_RegistNumber);
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
                    local winButton = CONST.BUTTON_��ȡ��;
                    local warpPage = 1;
                    local totalPage, remainder = calcWarp()
                    local count = 6 * (warpPage - 1)
                    --local winMsg = "3\\n���骄�����б�".. warpPage .."/".. totalPage .."�������������쾮��".. tenjo .."/700\\n"
                    local winMsg = "3\\n���骄�����б�".. warpPage .."/".. totalPage .."��������\\n"
                                                        .."�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
                                                        .."��̖�������������Q������������������\\n";
                    if totalPage == 1 then
                                winButton = CONST.BUTTON_�ر�;
                    end
                    if warpPage == totalPage then
                        for i = 1 + count, remainder + count do
                                local len = #itemMenu[i][2];
                                winMsg = winMsg .."[".. itemMenu[i][1] .."]������".. itemMenu[i][2]
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
                                winMsg = winMsg .."[".. itemMenu[i][1] .."]������".. itemMenu[i][2]
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
                    NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, winButton, 1, winMsg);
                else
                    --local winMsg = "3\\n���骄�����б�0/0�������������쾮��".. tenjo .."/700\\n"
                    local winMsg = "3\\n���骄�����б�0/0��������\\n"
                                                        .."�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
                                                        .."��̖�������������Q������������������\\n";
                    NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, CONST.BUTTON_�ر�, 1, winMsg);
                end
            end
            return
    end)

end


function MatchDraw:onMatchDraw(player, targetcharIndex, itemSlot)
          local itemIndex = Char.GetItemIndex(player, itemSlot);
          local ItemID = Item.GetData(itemIndex, CONST.����_ID);
          Char.DelItem(player, ItemID, 1)
          local WinNum = NLG.Rand(7, 1000);
          print(WinNum)
          local cdk = Char.GetData(player,CONST.����_CDK);
          local regNumber = Char.GetData(player,CONST.����_RegistNumber);
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
                         NLG.Say(player, -1, "�쾮���л��".. DrawTbl[1].name .."���صȪ���", CONST.��ɫ_��ɫ, CONST.����_��);               --�쾮
                         return;
                   end]]
                   if (v.type=="S") then
                         renewItemBag(player, v.Num, v.name, v.itemid, v.count);
                         NLG.Say(player, -1, "��ϲ���л��".. v.name .."���صȪ���", CONST.��ɫ_��ɫ, CONST.����_��);               --�صȪ�[0.1%]
                   elseif (v.type=="A") then
                         renewItemBag(player, v.Num, v.name, v.itemid, v.count);
                         NLG.Say(player, -1, "��ϲ���л��".. v.name .."��һ�Ȫ���", CONST.��ɫ_��ɫ, CONST.����_��);               --һ�Ȫ�[0.9%]
                   elseif (v.type=="B") then
                         renewItemBag(player, v.Num, v.name, v.itemid, v.count);
                         NLG.Say(player, -1, "��ϲ���л��".. v.name .."�����Ȫ���",CONST.��ɫ_��ɫ, CONST.����_��);                --���Ȫ�[2%]
                   elseif (v.type=="C") then
                         renewItemBag(player, v.Num, v.name, v.itemid, v.count);
                         NLG.Say(player, -1, "��ϲ���л��".. v.name .."�����Ȫ���",CONST.��ɫ_����ɫ, CONST.����_��);            --���Ȫ�[6%]
                   elseif (v.type=="D") then
                         renewItemBag(player, v.Num, v.name, v.itemid, v.count);
                         NLG.Say(player, -1, "��ϲ���л��".. v.name .."���ĵȪ���",CONST.��ɫ_����ɫ, CONST.����_��);            --�ĵȪ�[30%]
                   elseif (v.type=="E") then
                         renewItemBag(player, v.Num, v.name, v.itemid, v.count);
                         NLG.Say(player, -1, "��ϲ���л��".. v.name .."����ο����", CONST.��ɫ_��ɫ, CONST.����_��);               --��ο��[60%]
                   end
             end
          end
end

function renewItemBag(player,Num,name,itemid,count)
              --print(Num);
              --print(name);
              --print(itemid);
              --print(count);
              --��������
              local cdk = Char.GetData(player,CONST.����_CDK);
              local regNumber = Char.GetData(player,CONST.����_RegistNumber);
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
              --��������
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
              --��������
              function my_comp(a, b)
                         return a[1] < b[1]
              end
              table.sort(itemData, my_comp);
              --�ϴ�����
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