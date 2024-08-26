---ģ����
local Module = ModuleBase:createModule('pokeHatching')

local petList = {
petList[75003]={ {600018,600019}, }		  --����
petList[75004]={ {600018,600019}, }
petList[75005]={ {600018,600019}, }
petList[75006]={ {600018,600019}, }
petList[75007]={ {600018,600019}, }
petList[75008]={ {600018,600019}, }
petList[75009]={ {600018,600019}, }
petList[75010]={ {600018,600019}, }
}

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('ItemOverLapEvent', Func.bind(self.OnItemOverLapEvent, self));
  --self.ItemOverLap = self:regCallback(Func.bind(self.OnItemOverLapEvent, self));
  --NL.RegItemOverLapEvent("./lua/Modules/pokeHatching.lua", self.ItemOverLap);
  self:regCallback('ItemString', Func.bind(self.hatchTools, self),"LUA_useHatch");
  self.IncubatorNPC = self:NPC_createNormal('���ɉ�������', 14682, { x = 38, y = 33, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.IncubatorNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local winMsg = "�����ɉ����������̡�\\n"
                         .."�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
                         .."����ҷһ�N���Ե��^�������˵���\\n\\n"
                         .."�����������m�ṩ��������ϡ�Ќ���C��\\n"
                         .."���������K���ڽ�����Ӌ������100������\\n"
                         .."\\n\\n�Ƿ�_���p�􌢷����˵���\\n";
        NLG.ShowWindowTalked(player, self.IncubatorNPC, CONST.����_��Ϣ��, CONST.BUTTON_�Ƿ�, 1, winMsg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.IncubatorNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --��������
    local OvenIndex =Char.HaveItemID(player, ItemID);
    local OvenSlot = Char.FindItemId(player, ItemID);
    local OvenName = Item.GetData(OvenIndex, CONST.����_����);
    local OvenDur = 100;
    --ע��Ļ���ID
    local fromItemID = Item.GetData(OvenIndex,CONST.����_�Ӳ�һ);
    local typeNum = Item.GetData(OvenIndex,CONST.����_�Ӳζ�);
    if select > 0 then
      --ȷ��ִ��
      if (seqno == 12 and select == CONST.BUTTON_��) then
                 return;
      elseif (seqno == 12 and select == CONST.BUTTON_��)  then
                 local SuccPlus= math.floor(typeNum/5);
                 if (SuccPlus>60) then SuccPlus=60; end
                 local SuccRate = petList[fromItemID][2]+SuccPlus;
                 print(SuccRate)
                 if (SuccRate>100) then SuccRate=100; end
                 if (type(SuccRate)=="number" and SuccRate>0) then
                      local tMin = 50 - math.floor(SuccRate/2) + 1;
                      local tMax = 50 + math.floor(SuccRate/2) + math.fmod(SuccRate,2);
                      local tLuck = math.random(1, 100);
                      if (tLuck>=tMin and tLuck<=tMax)  then
                           Char.AddPet(player, petList[fromItemID][3]);
                      end
                 end
                 Char.DelItemBySlot(player, OvenSlot);
                 NLG.UpChar(player);
      else
                 return;
      end
    else
    end
  end)


end


function Module:hatchTools(charIndex,targetIndex,itemSlot)
    ItemID = Item.GetData(Char.GetItemIndex(charIndex,itemSlot),0);
    OvenSlot =itemSlot;
    local OvenIndex = Char.GetItemIndex(charIndex,itemSlot);
    local winMsg = "�����ɉ����������̡�\\n"
                         .."�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
                         .."����ҷһ�N���Ե��^�������˵���\\n\\n"
                         .."�����������m�ṩ��������ϡ�Ќ���C��\\n"
                         .."���������K���ڽ�����Ӌ������100������\\n"
                         .."\\n\\n�Ƿ�_���p�􌢷����˵���\\n";
        NLG.ShowWindowTalked(charIndex, self.IncubatorNPC, CONST.����_��Ϣ��, CONST.BUTTON_�Ƿ�, 1, winMsg);
    return 1;
end

function Module:OnItemOverLapEvent(charIndex, fromIndex, targetIndex, Num)
    local fromItemID = Item.GetData(fromIndex,0);
    local targetItemID = Item.GetData(targetIndex,0);
    local walkOn = Item.GetData(targetIndex,CONST.����_����);
    print(fromItemID,targetItemID)
    if (targetItemID==75001 and walkOn==0) then
        if (fromItemID==75003 or fromItemID==75004 or fromItemID==75005 or fromItemID==75006 or fromItemID==75007 or fromItemID==75008 or fromItemID==75009 or fromItemID==75010) then
                 local walkCount = Char.GetData(charIndex,CONST.CHAR_�߶�����);
                 Item.SetData(targetIndex,CONST.����_����, walkCount);
                 Item.SetData(targetIndex,CONST.����_����,"["..Item.GetData(fromIndex,CONST.����_����).."]��");
                 Item.SetData(targetIndex,CONST.����_�Ӳ�һ, fromItemID);
                 Item.SetData(targetIndex,CONST.����_�Ӳζ�, 1);
                 Item.SetData(targetIndex,CONST.����_������ʧ, 1);
                 Item.SetData(targetIndex,CONST.����_����, 0);
                 Char.DelItem(charIndex, fromItemID, 1);
                 Item.UpItem(charIndex, Char.FindItemId(charIndex, targetItemID));
                 NLG.UpChar(charIndex);
                 NLG.SystemMessage(charIndex, "[ϵ�y]ע�⣡���G�ؕ���ʧ���o�����ף�");
                 return 1;
        end
    elseif (targetItemID==75001 and walkOn>=1) then
        if (fromItemID==75003 or fromItemID==75004 or fromItemID==75005 or fromItemID==75006 or fromItemID==75007 or fromItemID==75008 or fromItemID==75009 or fromItemID==75010) then
            local setItemID = Item.GetData(targetIndex,CONST.����_�Ӳ�һ);
            local setCount = Item.GetData(targetIndex,CONST.����_�Ӳζ�);
            local typeNum = setCount+1;
            if (setItemID==fromItemID) then
                 local walkCount = Char.GetData(charIndex,CONST.CHAR_�߶�����);
                 local Count = walkCount-walkOn;
                 Item.SetData(targetIndex,CONST.����_����, "["..Item.GetData(fromIndex,CONST.����_����).."]��"..Count.."��");
                 Item.SetData(targetIndex,CONST.����_�Ӳζ�, setCount+1);
                 Char.DelItem(charIndex, fromItemID, 1);
                 Item.UpItem(charIndex, Char.FindItemId(charIndex, targetItemID));
                 NLG.UpChar(charIndex);
                 NLG.SystemMessage(charIndex, "[ϵ�y]�۷e "..Item.GetData(fromIndex,CONST.����_����).." ����:"..typeNum..);
                 return 1;
            else
                 NLG.SystemMessage(charIndex, "[ϵ�y]���N�ѽ���ֻ���ټ�����ͬ�Ļ��������C�ʣ�");
                 return 0;
            end
        end
    end
    return 0;
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
