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
        {"[001]","�yԇ����",1},
        {"[002]","�yԇ����2",1},
        {"[003]","�yԇ����3",1},
        {"[004]","�yԇ����4",1},
        {"[005]","�yԇ����5",1},
        {"[006]","�yԇ����6",1},
        {"[007]","�yԇ����7",1},
        {"[008]","�yԇ����8",1},
        {"[009]","�yԇ����9",1},
        {"[010]","�yԇ����10",1},
        {"[011]","�yԇ����11",1},
        {"[012]","�yԇ����",1},
        {"[013]","�yԇ����",1},
        {"[014]","�yԇ����",1},
}


local function calcWarp()--����ҳ�������һҳ����
  local totalpage = math.modf(#itemMenu / 6) + 1
  local remainder = math.fmod(#itemMenu, 6)
  return totalpage, remainder
end

function MatchDraw:onLoad()
    self:logInfo('load')
    self:regCallback("ItemString", Func.bind(self.onMatchDraw, self), 'LUA_useDraw');
    local managerNPC = self:NPC_createNormal('���骄����', 104927, { x = 227, y = 83, mapType = 0, map = 1000, direction = 4 });
    self:NPC_regWindowTalkedEvent(managerNPC, function(npc, player, _seqno, _select, _data)
        local column = tonumber(_data)
        local page = tonumber(_seqno)
        local data = tonumber(_data)
        local warpPage = page;
        local winButton = CONST.BUTTON_��ȡ��;
        local totalPage, remainder = calcWarp()
        --��ҳ16 ��ҳ32 �ر�/ȡ��2
        if _select > 0 then
                    --�������
                    local choose = tonumber(_seqno);
                    if (_select == CONST.BUTTON_ȷ��) then
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
                        else
                                winButton = CONST.BUTTON_����ȡ��
                        end
                    elseif _select == 2 then
                        warpPage = 1
                        return
                    end
                    local count = 6 * (warpPage - 1)
                    local winMsg = "3\\n���骄�����б�".. warpPage .."/".. totalPage .."\\n"
                                                        .."�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
                                                        .."��̖�������������Q������������������\\n";
                    if warpPage == totalPage then
                        for i = 1 + count, remainder + count do
                                local len = #itemMenu[i][2];
                                winMsg = winMsg .. itemMenu[i][1] .."����".. itemMenu[i][2]
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
                                winMsg = winMsg .. itemMenu[i][1] .."����".. itemMenu[i][2]
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
                    NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, winButton, warpPage, winMsg);
        else
                local choose_item = 6 * (warpPage - 1) + column
                --�������
                local winMsg = "���骄����\\n"
                                           .."�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
                                           .."����ȡ������...\\n"
                                           .."\\n��������������".. itemMenu[choose_item][2] .."\\n"
                                           .."\\n����������������ǰ���еĔ�����".. itemMenu[choose_item][3] .."\\n"
                                           .."\\nՈݔ��ȡ��������\\n";
                local choose = choose_item+1000;
                NLG.ShowWindowTalked(player, npc, CONST.����_�����, CONST.BUTTON_ȷ���ر�, choose, winMsg);

        end
    end)
    self:NPC_regTalkedEvent(managerNPC, function(npc, player)  ----���齱����managerMenu{}
            if (NLG.CanTalk(npc, player) == true) then
                local warpPage = 1;
                local totalPage, remainder = calcWarp()
                local count = 6 * (warpPage - 1)
                local winMsg = "3\\n���骄�����б�".. warpPage .."/".. totalPage .."\\n"
                                                        .."�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
                                                        .."��̖�������������Q������������������\\n";
                    if warpPage == totalPage then
                        for i = 1 + count, remainder + count do
                                local len = #itemMenu[i][2];
                                winMsg = winMsg .. itemMenu[i][1] .."����".. itemMenu[i][2]
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
                                winMsg = winMsg .. itemMenu[i][1] .."����".. itemMenu[i][2]
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
                NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, CONST.BUTTON_��ȡ��, 1, winMsg);
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
          for k, v in ipairs(DrawTbl) do
             if (WinNum>=v.serial_L and WinNum<=v.serial_H) then
                   if (v.type=="S") then
                         NLG.Say(player, -1, "�صȪ�[0.1%]��", CONST.��ɫ_��ɫ, CONST.����_��);
                   elseif (v.type=="A") then
                         NLG.Say(player, -1, "һ�Ȫ�[0.9%]��", CONST.��ɫ_��ɫ, CONST.����_��);
                   elseif (v.type=="B") then
                         NLG.Say(player, -1, "���Ȫ�[2%]��",CONST.��ɫ_��ɫ, CONST.����_��);
                   elseif (v.type=="C") then
                         NLG.Say(player, -1, "���Ȫ�[6%]��",CONST.��ɫ_����ɫ, CONST.����_��);
                   elseif (v.type=="D") then
                         NLG.Say(player, -1, "�ĵȪ�[30%]��",CONST.��ɫ_����ɫ, CONST.����_��);
                   elseif (v.type=="E") then
                         NLG.Say(player, -1, "��ο��[60%]��", CONST.��ɫ_��ɫ, CONST.����_��);
                   end
             end
          end
end

function MatchDraw:onUnload()
        self:logInfo('unload');
end

return MatchDraw;