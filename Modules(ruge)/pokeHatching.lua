---ģ����
local Module = ModuleBase:createModule('pokeHatching')

local petMettleTable = {
          {9610,9619,9620,9629},       --��BOSS��,��BOSS��,��������,��аħ��
          {9611,9615,9623,9624},       --�Ե���,�Եؼ�,�Է�����,��������
          {9612,9616,9627,9628},       --��ˮ��,��ˮ��,��������,�Խ�����
          {9613,9617,9621,9626},       --�Ի���,�Ի��,��������,��Ұ����
          {9614,9618,9622,9625},       --�Է���,�Է��,�Բ�����,��ֲ����
}

local walkHatching = 1000;	--����������·����
local petList = {};
petList[75003]={ {700001,700002,700003,700004,700005,700006}, {700003,700004,700005,700006}, {700005,700006} };		  --����
petList[75004]={ {700007,700008,700009,700010,700011,700012}, {700009,700010,700011,700012}, {700011,700012} };
petList[75005]={ {700013,700014,700015,700016,700017,700018}, {700015,700016,700017,700018}, {700017,700018} };
petList[75006]={ {700019,700020,700021,700022,700023,700024}, {700021,700022,700023,700024}, {700023,700024} };
petList[75007]={ {700025,700026,700027,700028,700029,700030}, {700027,700028,700029,700030}, {700029,700030} };
petList[75008]={ {700031,700032,700033,700034,700035,700036}, {700033,700034,700035,700036}, {700035,700036} };
petList[75009]={ {700037,700038,700039,700040,700041,700042}, {700039,700040,700041,700042}, {700041,700042} };
petList[75010]={ {700043,700044,700045,700046,700047,700048}, {700045,700046,700047,700048}, {700047,700048} };


--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('ItemOverLapEvent', Func.bind(self.OnItemOverLapEvent, self));
  self.ItemOverLap = self:regCallback(Func.bind(self.OnItemOverLapEvent, self));
  NL.RegItemOverLapEvent("./lua/Modules/pokeHatching.lua", self.ItemOverLap);
  self:regCallback('ItemString', Func.bind(self.hatchTools, self),"LUA_useHatch");
  self.IncubatorNPC = self:NPC_createNormal('���ɉ�������', 14682, { x = 38, y = 33, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.IncubatorNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local winMsg = "�����ɉ����������̡�\\n"
                         .."�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
                         .."����ҷһ�N���Ե��^�������˵���\\n\\n"
                         .."��������������Ӌ������"..walkHatching.."������\\n"
                         .."�����������m����ͬһ�N���¸��²���\\n"
                         .."���������_��5��10���Ąӌ��ﵰ��\\n"
                         .."\\n�Ƿ�_���p�􌢷����˵���\\n";
        NLG.ShowWindowTalked(player, self.IncubatorNPC, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 1, winMsg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.IncubatorNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --��������
    local OvenIndex = OvenIndex;
    local OvenSlot = OvenSlot;
    local OvenName = Item.GetData(OvenIndex, CONST.����_����);
    local first = string.find(OvenName, "��", 1);
    local last = string.find(OvenName, "��", 1);
    if (first==nil or last==nil) then
        OvenDur = 0;
    else
        OvenDur = tonumber(string.sub(OvenName, first+2, last-1));
    end
    --print(OvenDur)
    --local OvenDur = 100;
    --ע��Ļ���ID
    local fromItemID = Item.GetData(OvenIndex,CONST.����_�Ӳ�һ);
    local typeNum = Item.GetData(OvenIndex,CONST.����_�Ӳζ�);
    if select > 0 then
      --ȷ��ִ��
      if (seqno == 1 and select == CONST.��ť_��) then
                 return;
      elseif (seqno == 1 and select == CONST.��ť_��)  then
          if (OvenDur>=walkHatching) then
                 if (Char.PetNum(player)==5) then
                     NLG.SystemMessage(player, "[ϵ�y]����ڿ��g���㡣");
                     return;
                 end
                 --��������λ��
                 local EmptySlot = Char.GetPetEmptySlot(player);
                 local SuccRate = typeNum;
                 if (typeNum>=1 and typeNum<5) then
                      local tLuck = math.random(1, #petList[fromItemID][1]);
                      Char.AddPet(player, petList[fromItemID][1][tLuck]);
                 elseif (typeNum>=5 and typeNum<10) then
                      local tLuck = math.random(1, #petList[fromItemID][2]);
                      Char.AddPet(player, petList[fromItemID][2][tLuck]);
                 elseif (typeNum>=10) then
                      local tLuck = math.random(1, #petList[fromItemID][3]);
                      Char.AddPet(player, petList[fromItemID][3][tLuck]);
                 end
                 local PetIndex = Char.GetPet(player, EmptySlot);
                 local typeRand = math.random(1,#petMettleTable);
                 local pos = math.random(1,#petMettleTable[typeRand]);
                 Pet.AddSkill(PetIndex, petMettleTable[typeRand][pos], 9);
                 Pet.UpPet(player,PetIndex);
                 Char.DelItemBySlot(player, OvenSlot);
                 NLG.UpChar(player);
          else
                 NLG.SystemMessage(player, "[ϵ�y]���������Ҫ�Ĳ������㡣");
                 return;
          end
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
    OvenIndex = Char.GetItemIndex(charIndex,itemSlot);
    local winMsg = "�����ɉ����������̡�\\n"
                         .."�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
                         .."����ҷһ�N���Ե��^�������˵���\\n\\n"
                         .."��������������Ӌ������"..walkHatching.."������\\n"
                         .."�����������m����ͬһ�N���¸��²���\\n"
                         .."���������_��5��10���Ąӌ��ﵰ��\\n"
                         .."\\n�Ƿ�_���p�􌢷����˵���\\n";
        NLG.ShowWindowTalked(charIndex, self.IncubatorNPC, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 1, winMsg);
    return 1;
end

function Module:OnItemOverLapEvent(charIndex, fromIndex, targetIndex, Num)
    local fromItemID = Item.GetData(fromIndex,0);
    local targetItemID = Item.GetData(targetIndex,0);
    local walkOn = Item.GetData(targetIndex,CONST.����_����);
    --print(fromItemID,targetItemID)
    if (targetItemID==75001 and walkOn==0) then
        if (fromItemID==75003 or fromItemID==75004 or fromItemID==75005 or fromItemID==75006 or fromItemID==75007 or fromItemID==75008 or fromItemID==75009 or fromItemID==75010) then
                 local walkCount = Char.GetData(charIndex,CONST.����_�߶�����);
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
                 local walkCount = Char.GetData(charIndex,CONST.����_�߶�����);
                 local Count = walkCount-walkOn;
                 Item.SetData(targetIndex,CONST.����_����, "["..Item.GetData(fromIndex,CONST.����_����).."]��"..Count.."��");
                 Item.SetData(targetIndex,CONST.����_�Ӳζ�, setCount+1);
                 NLG.SystemMessage(charIndex, "[ϵ�y]�۷e "..Item.GetData(fromIndex,CONST.����_����).." ����:"..typeNum);
                 Char.DelItem(charIndex, fromItemID, 1);
                 Item.UpItem(charIndex, Char.FindItemId(charIndex, targetItemID));
                 NLG.UpChar(charIndex);
                 return 1;
            else
                 NLG.SystemMessage(charIndex, "[ϵ�y]���N�ѽ���ֻ���ټ�����ͬ�Ļ��������C�ʣ�");
                 return 0;
            end
        end
    end
    return 0;
end

Char.GetPetEmptySlot = function(charIndex)
  for Slot=0,4 do
      local PetIndex = Char.GetPet(charIndex, Slot);
      --print(PetIndex);
      if (PetIndex < 0) then
          return Slot;
      end
  end
  return -1;
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
