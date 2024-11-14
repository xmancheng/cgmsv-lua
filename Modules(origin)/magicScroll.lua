local Module = ModuleBase:createModule('magicScroll')

local ItemPosName = {"�^ ��", "�� ��", "�� ��", "�� ��", "�� ��", "�Ʒ1", "�Ʒ2", "ˮ ��"}
local typeEnable_check = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,65,66,67,68,69,70}

local TelekinesisTable = {
             { Info=7000211, Rate=10},
             { Info=7000212, Rate=15},
             { Info=7000213, Rate=20},
             { Info=7000214, Rate=25},
             { Info=7000215, Rate=30},
             { Info=7000216, Rate=35},
             { Info=7000217, Rate=40},
             { Info=7000218, Rate=45},
             { Info=7000219, Rate=50},
}

local scrollRateTable={}
scrollRateTable[31] ={35,65,80,88,95,100}			--���e�C��35,30,15,8,7,5
scrollRateTable[32] ={4,10,41,71,85,92,97,99,100}		--���e�C��4,6,31,30,14,7,5,2,1
scrollRateTable[33] ={100}

local scrollTable={}	--��|��|��|��|��|Ѫ|ħ|ħ��|ħ��|��|��|��|�W
scrollTable[71032] = "15,20|0,0|0,0|0,0|0,0|15,20|15,20|0,0|0,0|1,2|0,0|1,2|0,0";
scrollTable[71033] = "12,20|0,0|0,0|0,0|0,0|12,20|12,20|0,0|0,0|0,2|0,0|0,2|0,0";
scrollTable[71034] = "14,14|0,0|0,0|0,0|0,0|14,14|14,14|0,0|0,0|1,1|0,0|1,1|0,0";
scrollTable[71035] = "0,0|0,0|0,0|15,20|0,0|15,20|15,20|15,20|0,0|0,0|0,0|0,0|1,2";
scrollTable[71036] = "0,0|0,0|0,0|12,20|0,0|12,20|12,20|12,20|0,0|0,0|0,0|0,0|0,2";
scrollTable[71037] = "0,0|0,0|0,0|14,14|0,0|14,14|14,14|14,14|0,0|0,0|0,0|0,0|1,1";

scrollTable[71038] = "10,15|10,15|10,15|10,15|0,0|10,15|10,15|0,0|10,15|0,0|0,0|0,0|0,0";
scrollTable[71039] = "7,15|7,15|7,15|7,15|0,0|7,15|7,15|0,0|7,15|0,0|0,0|0,0|0,0";
scrollTable[71040] = "9,9|9,9|9,9|9,9|0,0|9,9|9,9|0,0|9,9|0,0|0,0|0,0|0,0";
scrollTable[71041] = "10,15|10,15|10,15|10,15|0,0|10,15|10,15|0,0|10,15|0,0|0,0|0,0|0,0";
scrollTable[71042] = "7,15|7,15|7,15|7,15|0,0|7,15|7,15|0,0|7,15|0,0|0,0|0,0|0,0";
scrollTable[71043] = "9,9|9,9|9,9|9,9|0,0|9,9|9,9|0,0|9,9|0,0|0,0|0,0|0,0";
scrollTable[71044] = "10,15|10,15|10,15|10,15|0,0|10,15|10,15|0,0|10,15|0,0|0,0|0,0|0,0";
scrollTable[71045] = "7,15|7,15|7,15|7,15|0,0|7,15|7,15|0,0|7,15|0,0|0,0|0,0|0,0";
scrollTable[71046] = "9,9|9,9|9,9|9,9|0,0|9,9|9,9|0,0|9,9|0,0|0,0|0,0|0,0";

----------------------------------------------------------------------------------------------
function Module:onLoad()
  self:logInfo('load');
  self:regCallback('ItemString', Func.bind(self.telekinesis, self),"LUA_useScroll");
  self.witcheryNPC = self:NPC_createNormal('ħ�����S��', 14682, { x = 36, y = 33, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.witcheryNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local msg = "\\n@c��ħ�����S��" ..	"\\n\\n�˞�ħ�����õľ��S\\n\\n�֞���������ˡ��ڰ����N��͵ľ��S\\n\\n�n��ɹ��ʽԞ�100%���Y�����S�C���|��\\n\\n";	
        NLG.ShowWindowTalked(player, self.witcheryNPC, CONST.����_��Ϣ��, CONST.��ť_ȷ���ر�, 1, msg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.witcheryNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    local ScrollSpecial = Item.GetData(ScrollIndex,CONST.����_��������);	--���S�N�
    local targetSlot = Item.GetData(ScrollIndex,CONST.����_�Ӳ�һ);	--�n��λ
    local targetIndex = Char.GetItemIndex(player, targetSlot);
    if select > 0 then
      if seqno == 1 and select == CONST.��ť_ȷ�� then
          if (targetIndex ~= nil) then
              local targetName = Item.GetData(targetIndex, CONST.����_����);
              local targetType = Item.GetData(targetIndex,CONST.����_����);
              local targethint = Item.GetData(targetIndex,CONST.����_Explanation2);		--ʣ�N�픵�����f��
              --local Para1 = tonumber(Item.GetData(targetIndex,CONST.����_�Ӳ�һ));
              --local Para2 = tonumber(Item.GetData(targetIndex,CONST.����_�Ӳζ�));
              if (CheckInTable(typeEnable_check, targetType)==true and targethint ~= 7000214) then		--��һ��
                            Item.SetData(targetIndex,CONST.����_Explanation2, 7000214);
                            Item.SetData(targetIndex,CONST.����_����, 500);
                            Item.SetData(targetIndex,CONST.����_ħ��, 500);
                            Item.UpItem(player,targetSlot);
                            --Char.DelItemBySlot(player, Char.FindItemId(player,ItemID));
                            Char.DelItem(player, ItemID,1);
                            NLG.SystemMessage(player, "[ϵ�y] "..targetName.." ��1���n��ɹ���");
                            NLG.UpChar(player);
              elseif (CheckInTable(typeEnable_check, targetType)==true and targethint>=7000214 and targethint<=7000219) then
                      local SRate = math.random(1,100);
                      for k, v in ipairs(TelekinesisTable) do
                            if (targethint == v.Info and SRate >= v.Rate) then
                                Item.SetData(targetIndex,CONST.����_Explanation2, v.Info+1);
                                Item.SetData(targetIndex,CONST.����_����, Item.GetData(targetIndex,CONST.����_����)+500);
                                Item.SetData(targetIndex,CONST.����_ħ��, Item.GetData(targetIndex,CONST.����_ħ��)+500);
                                Item.UpItem(player,targetSlot);
                                --Char.DelItemBySlot(player, Char.FindItemId(player,ItemID));
                                Char.DelItem(player, ItemID,1);
                                NLG.SystemMessage(player, "[ϵ�y] "..targetName.." �n��ɹ���");
                                NLG.UpChar(player);
                            elseif (targethint == v.Info and SRate < v.Rate) then
                                Item.SetData(targetIndex,CONST.����_Explanation2, v.Info+1);
                                Item.UpItem(player,targetSlot);
                                --Char.DelItemBySlot(player, Char.FindItemId(player,ItemID));
                                Char.DelItem(player, ItemID,1);
                                NLG.SystemMessage(player, "[ϵ�y] "..targetName.." ����ʧ���ˣ�");
                            end
                      end
              end
          end
      else

      end

    end
  end)


end


function Module:telekinesis(charIndex,targetIndex,itemSlot)
    ItemID = Item.GetData(Char.GetItemIndex(charIndex,itemSlot),0);
    ScrollSlot =itemSlot;
    ScrollIndex = Char.GetItemIndex(charIndex,itemSlot);
    local ScrollName = Item.GetData(ScrollIndex,CONST.����_����);
    local ScrollSpecial = Item.GetData(ScrollIndex,CONST.����_��������);	--���S�N�
    local targetSlot = Item.GetData(ScrollIndex,CONST.����_�Ӳ�һ);	--�n��λ
    local targetName = ItemPosName[targetSlot+1]
    local msg = "\\n@c"..ScrollName.."\\n"
                        .. "\\n�ˡ����S������λ��$2"..targetName.."\\n"
                        .. "\\n�n�����ɡ������ʣ�$4" .. "100%\\n\\n";

    local ScrollInfo = string.split(scrollTable[ItemID], "|")
    local InfoName =string.split("����|���R|����|����|�؏�|����|ħ��|ħ��|ħ��|�ؚ�|����|����|�W��", "|")
    local formCount = 0
    for i=1,13 do
        local ScrollStat = ScrollInfo[i]
        local StatName = InfoName[i]
        local ScrollSub = string.split(ScrollStat, ",");
        if (tonumber(ScrollSub[1])>0 or tonumber(ScrollSub[2])>0) then
            formCount = formCount+1
            msg = msg .. " $1" .. StatName .."(+".. ScrollSub[1] .. ",+" .. ScrollSub[2] ..") "
            if (math.fmod(formCount,3)==1) then
                msg = msg .."\\n"
            end
        end
    end
    NLG.ShowWindowTalked(charIndex, self.witcheryNPC, CONST.����_��Ϣ��, CONST.��ť_ȷ���ر�, 1, msg);
    return 1;
end


function CheckInTable(_idTab, _idVar) ---ѭ������
	for k,v in pairs(_idTab) do
		if v==_idVar then
			return true
		end
	end
	return false
end

function Module:onUnload()
  self:logInfo('unload')
end

return Module;
