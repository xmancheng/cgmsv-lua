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
       { Num="001", type="L", serial_L=51, serial_H=51, name="��ʹ֮ף��", itemid=45953, count=1},
       { Num="002", type="A", serial_L=1, serial_H=1, name="��ʹ֮ף��", itemid=45953, count=1},
       { Num="003", type="B", serial_L=2, serial_H=2, name="Ѹ�ٹ���֮��", itemid=46903, count=1},
       { Num="004", type="C", serial_L=3, serial_H=3, name="������֮��", itemid=46901, count=1},
       { Num="005", type="C", serial_L=4, serial_H=4, name="һʯ���B֮��", itemid=46902, count=1},
       { Num="006", type="D", serial_L=5, serial_H=5, name="����֮��", itemid=45979, count=1},
       { Num="007", type="D", serial_L=6, serial_H=6, name="����֮��", itemid=45980, count=1},
       { Num="008", type="E", serial_L=7, serial_H=7, name="��ʿ���o", itemid=45968, count=1},
       { Num="009", type="F", serial_L=8, serial_H=8, name="�󷨎�֮��", itemid=45967, count=1},
       { Num="010", type="G", serial_L=9, serial_H=20, name="���������֭h", itemid=45510, count=1},
       { Num="011", type="H", serial_L=21, serial_H=32, name="�L������֭h", itemid=45512, count=1},
       { Num="012", type="I", serial_L=33, serial_H=50, name="�^�����R�֭h", itemid=45511, count=1},
}


local function calcWarp()--����ҳ�������һҳ����
  local totalpage = math.modf(#itemMenu / 6) + 1
  local remainder = math.fmod(#itemMenu, 6)
  return totalpage, remainder
end

--- ����ģ�鹳��
function IchibanKuji:onLoad()
    self:logInfo('load')
    self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self));
    self:regCallback("ItemString", Func.bind(self.onIchibanKuji, self), 'LUA_useKuji');
    local noticeNPC = self:NPC_createNormal('һ���pُ�I��ʾ', 11556, { x = 226, y = 106, mapType = 0, map = 1000, direction = 0 });
    self:NPC_regWindowTalkedEvent(noticeNPC, function(npc, player, _seqno, _select, _data)
        local column = tonumber(_data)
        local page = tonumber(_seqno)
        local data = tonumber(_data)
        if _select == CONST.BUTTON_��  then
                local winMsg = "ħ��һ���pُ�I�骄�`\\n"
                                           .."�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
                                           .."����ُ�I����...\\n"
                                           .."\\n��������������\\n"
                                           .."\\n�����������������o��ʣ�r�g��\\n"
                                           .."\\nՈݔ��ُ�I����(ÿ�β��ó��^5��)��\\n";
                NLG.ShowWindowTalked(player, npc, CONST.����_�����, CONST.BUTTON_ȷ���ر�, 11, winMsg);
        elseif _select > 0 then
                if _select == CONST.BUTTON_�ر� then
                    return;
                end
                --�o��һ���p�`
                if (_select == CONST.BUTTON_ȷ��) then
                       if (data<=5) then
                             for i=1,data do
                                 --Char.GiveItem(player, 70095, 1);
                                 --local itemSlot = Char.FindItemId(player, 70095);
                                 self:onIchibanKuji(player, targetcharIndex, itemSlot);
                             end
                       else
                             NLG.Say(player, -1, "[ϵ�y]ُ�I�������^һ�����ޣ���", CONST.��ɫ_��ɫ, CONST.����_��);
                             return;
                       end
                end
        end
    end)
    self:NPC_regTalkedEvent(noticeNPC, function(npc, player)  ----һ���p�YӍ��ʾ
          --��ȡǩͲ
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
          --���������ʣ��ǩ��
          if (NLG.CanTalk(npc, player) == true) then
              if (KujiAll~=nil and KujiAll~={}) then
                    local winMsg = "\\n          �������ħ��һ���p�f����ʾ�������\\n"
                                               .."\\n�����[�������Ļ`��������50����Ŀǰʣ�N�`����\\n"
                                               .."\\n�X�T�T�T�j�T�T�T�j�T�T�T�j�T�T�T�j�T�T�T�j�T�T�T�j�T�T�T�["
                                               .."\\n�U�������U���¡��U���á��U���ġ��U���š��U���ơ��U���ǡ��U"
                                               .."\\n�d�T�T�T�p�T�T�T�p�T�T�T�p�T�T�T�p�T�T�T�p�T�T�T�p�T�T�T�g"
                                               .."\\n�U�������U�������U�������U�������U�������U�������U�������U"
                                               .."\\n�^�T�T�T�m�T�T�T�m�T�T�T�m�T�T�T�m�T�T�T�m�T�T�T�m�T�T�T�a"
                                               .."\\n�������p������"..KujiTbl[1].name.."�������¡��p������"..KujiTbl[2].name.."����"
                                               .."\\n���á��p������"..KujiTbl[3].name.." �� "..KujiTbl[4].name.."��"
                                               .."\\n���ġ��p������"..KujiTbl[5].name.." �� "..KujiTbl[6].name.."��"
                                               .."\\n���š��p������"..KujiTbl[7].name.." �������ơ��p������"..KujiTbl[8].name.."����"
                                               .."\\n���ǡ��p������"..KujiTbl[9].name.."����"
                                               .."\\n���ȡ��p������"..KujiTbl[10].name.."����"
                                               .."\\n���ɡ��p������"..KujiTbl[11].name.."����"
                                               .."\\n�������p���������b������ߡ���\\n"
                                               .."\\n��ÿ��1�Σ�1ö��һ���š���ÿ5�����۷e�ϝq1ö��һ���š�"
                                               .."\\n����`�Ὓ�^��С�r����s�r�g�����ûص�1ö��һ���š�"
                                               .."\\n�������ȡ����80���ߣ��@�á������p���~�⪄��";
                    NLG.ShowWindowTalked(player, npc, CONST.����_����Ϣ��, CONST.BUTTON_�Ƿ�, 1, winMsg);
              end
          end
          return
    end)


    local clerkNPC = self:NPC_createNormal('һ���p���ܵ�T', 104925, { x = 228, y = 106, mapType = 0, map = 1000, direction = 4 });
    self:NPC_regWindowTalkedEvent(clerkNPC, function(npc, player, _seqno, _select, _data)
        local column = tonumber(_data)
        local page = tonumber(_seqno)
        local data = tonumber(_data)
        local warpPage = page;
        local winButton = CONST.BUTTON_�ر�;
        --local totalPage, remainder = calcWarp()
        --��������
        local cdk = Char.GetData(player,CONST.����_CDK);
        local tenjo = tonumber(SQL.Run("select Tenjo from lua_hook_character where CdKey='"..cdk.."'")["0_0"])
        local sqldata = SQL.Run("select IchibanKuji1 from lua_hook_character where CdKey='"..cdk.."'")["0_0"]
        local itemData = {};
        if (type(sqldata)=="string") then
               itemData = JSON.decode(sqldata);
               itemMenu = itemData;
        else
               itemMenu={};
        end
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
                    local winMsg = "3\\nһ���p�骄�����б�".. warpPage .."/".. totalPage .."��������\\n"
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
                    local winMsg = "3\\nһ���p�骄�����б�0/0��������\\n"
                                                        .."�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
                                                        .."��̖�������������Q������������������\\n";
                    NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, CONST.BUTTON_�ر�, 1, winMsg);
                end
        else
                local choose_item = 6 * (warpPage - 1) + column
                --�������
                local winMsg = "һ���p�骄����\\n"
                                           .."�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
                                           .."����ȡ������...\\n"
                                           .."\\n��������������".. itemMenu[choose_item][2] .."\\n"
                                           .."\\n����������������ǰ���еĔ�����".. itemMenu[choose_item][4] .."\\n"
                                           .."\\nՈݔ��ȡ��������\\n";
                local choose = choose_item+1000;
                NLG.ShowWindowTalked(player, npc, CONST.����_�����, CONST.BUTTON_ȷ���ر�, choose, winMsg);

        end
    end)
    self:NPC_regTalkedEvent(clerkNPC, function(npc, player)  ----һ���p�齱����managerMenu{}
            local cdk = Char.GetData(player,CONST.����_CDK);
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
                    local winButton = CONST.BUTTON_��ȡ��;
                    local warpPage = 1;
                    local totalPage, remainder = calcWarp()
                    local count = 6 * (warpPage - 1)
                    local winMsg = "3\\nһ���p�骄�����б�".. warpPage .."/".. totalPage .."��������\\n"
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
                    local winMsg = "3\\nһ���p�骄�����б�0/0��������\\n"
                                                        .."�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
                                                        .."��̖�������������Q������������������\\n";
                    NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, CONST.BUTTON_�ر�, 1, winMsg);
                end
            end
            return
    end)

end


function IchibanKuji:onIchibanKuji(player, targetcharIndex, itemSlot)
          local itemIndex = Char.GetItemIndex(player, itemSlot);
          local ItemID = Item.GetData(itemIndex, CONST.����_ID);
          Char.DelItem(player, ItemID, 1)
          --��ȡǩͲ
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
          --ϴ��ǩͲ
          local xr = NLG.Rand(1,3);
          for i=1,#KujiAll-1-xr do
                    r = NLG.Rand(1,i+1+xr);
                    temp=KujiAll[r];
                    KujiAll[r]=KujiAll[i];
                    KujiAll[i]=temp;
          end
          --�齱��λ
          SQL.Run("INSERT INTO lua_hook_character (Name,CdKey,OriginalImageNumber) SELECT Name,CdKey,OriginalImageNumber FROM tbl_character WHERE NOT EXISTS ( SELECT Name FROM lua_hook_character WHERE tbl_character.CdKey=lua_hook_character.CdKey)");
          for k, v in ipairs(KujiTbl) do
             local stick = string.sub(KujiAll[WinNum], 1, 1);
             --print(stick)
             if (WinNum>=1 and WinNum<=#KujiAll) then
                   if (stick=="A" and v.type=="A") then
                         renewItemBag(player, v.Num, v.name, v.itemid, v.count);
                         NLG.Say(player, -1, "��ϲ����ħ��һ���p��".. v.name .."��A�p��", CONST.��ɫ_��ɫ, CONST.����_��);               --A�p[2%]
                   elseif (stick=="B" and v.type=="B") then
                         renewItemBag(player, v.Num, v.name, v.itemid, v.count);
                         NLG.Say(player, -1, "��ϲ����ħ��һ���p��".. v.name .."��B�p��", CONST.��ɫ_��ɫ, CONST.����_��);               --B�p[2%]
                   elseif (stick=="C" and v.type=="C") then
                         renewItemBag(player, v.Num, v.name, v.itemid, v.count);
                         NLG.Say(player, -1, "��ϲ����ħ��һ���p��".. v.name .."��C�p��",CONST.��ɫ_��ɫ, CONST.����_��);                --C�p[4%]
                   elseif (stick=="D" and v.type=="D") then
                         renewItemBag(player, v.Num, v.name, v.itemid, v.count);
                         NLG.Say(player, -1, "��ϲ����ħ��һ���p��".. v.name .."��D�p��",CONST.��ɫ_��ɫ, CONST.����_��);                --D�p[4%]
                   elseif (stick=="E" and v.type=="E") then
                         renewItemBag(player, v.Num, v.name, v.itemid, v.count);
                         NLG.Say(player, -1, "��ϲ����ħ��һ���p��".. v.name .."��E�p��",CONST.��ɫ_��ɫ, CONST.����_��);                 --E�p[2%]
                   elseif (stick=="F" and v.type=="F") then
                         renewItemBag(player, v.Num, v.name, v.itemid, v.count);
                         NLG.Say(player, -1, "��ϲ����ħ��һ���p��".. v.name .."��F�p��",CONST.��ɫ_��ɫ, CONST.����_��);                 --F�p[2%]
                   elseif (stick=="G" and v.type=="G") then
                         renewItemBag(player, v.Num, v.name, v.itemid, v.count);
                         NLG.Say(player, -1, "��ϲ����ħ��һ���p��".. v.name .."��G�p��",CONST.��ɫ_����ɫ, CONST.����_��);            --G�p[24%]
                   elseif (stick=="H" and v.type=="G") then
                         renewItemBag(player, v.Num, v.name, v.itemid, v.count);
                         NLG.Say(player, -1, "��ϲ����ħ��һ���p��".. v.name .."��H�p��",CONST.��ɫ_����ɫ, CONST.����_��);            --H�p[24%]
                   elseif (stick=="I" and v.type=="I") then
                         renewItemBag(player, v.Num, v.name, v.itemid, v.count);
                         NLG.Say(player, -1, "��ϲ����ħ��һ���p��".. v.name .."��I�p��",CONST.��ɫ_����ɫ, CONST.����_��);             --I�p[36%]
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
              local sqldata = SQL.Run("select IchibanKuji1 from lua_hook_character where CdKey='"..cdk.."'")["0_0"]
              local itemData = {};
              if (type(sqldata)=="string" and sqldata~='') then
                   itemData = JSON.decode(sqldata);
              else
                   itemData = {};
              end
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
              local newdata = JSON.encode(sqldata);
              SQL.Run("update lua_hook_character set IchibanKuji1= '"..newdata.."' where CdKey='"..cdk.."'")
              NLG.UpChar(player);

end

function IchibanKuji:handleTalkEvent(charIndex,msg,color,range,size)
	if (msg=="[nr ichiban restart]") then
		local cdk = Char.GetData(charIndex,CONST.����_CDK);
		if (cdk == GMcdk) then
			Field.Set(charIndex, 'ichiban_set_1', JSON.encode(KujiAll_1));
			Field.Set(charIndex, 'ichiban_set_2', JSON.encode(KujiAll_2));
			NLG.SystemMessage(charIndex, "[ϵ�y]һ���p�؆���");
			return 0;
		end
	end
	return 1;
end

function IchibanKuji:onUnload()
        self:logInfo('unload');
end

return IchibanKuji;