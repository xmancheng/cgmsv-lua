---ģ����
local Module = ModuleBase:createModule('uniqueSkills')

local Terra_itemId = 70196;	--�ؾ���
local Agni_itemId = 70198;	--����
local Aqua_itemId = 70197;	--ˮ����
local Ventus_itemId = 70199;	--�羫��
local DropsList = {};
DropsList[1]={47121,47122,47123};	--��
DropsList[2]={47124,47125,47126};	--��
DropsList[3]={47127,47128,47129};	--ǹ
DropsList[4]={47139,47140,47141};	--��
DropsList[5]={47130,47131,47132};	--��
DropsList[6]={47136,47137,47138};	--С��
DropsList[7]={47133,47134,47135};	--������
DropsList[8]={47163,47164,47165};	--��
DropsList[9]={47142,47143,47144};	--��
DropsList[10]={47145,47146,47147};	--ñ
DropsList[11]={47148,47149,47150};	--��
DropsList[12]={47151,47152,47153};	--��
DropsList[13]={47154,47155,47156};	--��
DropsList[14]={47157,47158,47159};	--ѥ
DropsList[15]={47160,47161,47162};	--Ь
DropsList[16]={47167,47169};	--����
DropsList[17]={47171,47173};	--ҩƷ
DropsList[18]={18005,18006,18007,18008,18009};

local FusionEnable_check= {
    47121,47122,    47124,47125,    47127,47128,
    47139,47140,    47130,47131,    47136,47137,
    47133,47134,
    47163,47164,    47142,47143,    47145,47146,
    47148,47149,    47151,47152,    47154,47155,
    47157,47158,    47160,47161,
};
local FusionList = {};
FusionList[47121]=47122;
FusionList[47122]=47123;
FusionList[47124]=47125;
FusionList[47125]=47126;
FusionList[47127]=47128;
FusionList[47128]=47129;
FusionList[47130]=47131;
FusionList[47131]=47132;
FusionList[47133]=47134;
FusionList[47134]=47135;
FusionList[47136]=47137;
FusionList[47137]=47138;
FusionList[47139]=47140;
FusionList[47140]=47141;
FusionList[47142]=47143;
FusionList[47143]=47144;
FusionList[47145]=47146;
FusionList[47146]=47147;
FusionList[47148]=47149;
FusionList[47149]=47150;
FusionList[47151]=47152;
FusionList[47152]=47153;
FusionList[47154]=47155;
FusionList[47155]=47156;
FusionList[47157]=47158;
FusionList[47158]=47159;
FusionList[47160]=47161;
FusionList[47161]=47162;
FusionList[47163]=47164;
FusionList[47164]=47165;

--------------------------------------------------------------------------------------------
--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('ItemOverLapEvent', Func.bind(self.OnItemOverLapEvent, self));
  --self.ItemOverLap = self:regCallback(Func.bind(self.OnItemOverLapEvent, self));
  --NL.RegItemOverLapEvent("./lua/Modules/pokeHatching.lua", self.ItemOverLap);
  self:regCallback('GetExpEvent', Func.bind(self.onGetExpEvent,self));
  self:regCallback('BattleOverEvent', Func.bind(self.battleOverEventCallback, self));
  self:regCallback('GatherItemEvent', function(charIndex, skillId, skillLv, itemNo)
        local burst = NLG.Rand(10, 50);
        if (Char.ItemNum(charIndex, Ventus_itemId)==1 and burst==31) then
            Char.GiveItem(charIndex, itemNo, 1);
            NLG.SortItem(charIndex);
        end
    return;
  end)

end

function Module:onGetExpEvent(charIndex, exp)
    if (Char.IsPlayer(charIndex)==true) then
        if (Char.ItemNum(charIndex, Agni_itemId)==1)then
            return exp * 2;		--��ɫ��ȡ�ľ���˫��
        end
    elseif (Char.IsPet(charIndex)==true) then
        local OwnerIndex = Pet.GetOwner(charIndex);
        if (Char.ItemNum(OwnerIndex, Terra_itemId)==1)then
            return exp * 2;		--�����ȡ�ľ���˫��
        end
    end
    return exp;
end

function Module:OnItemOverLapEvent(charIndex, fromIndex, targetIndex, Num)
    local fromItemID = Item.GetData(fromIndex,0);
    local targetItemID = Item.GetData(targetIndex,0);
    local targetLevel = Item.GetData(targetIndex,CONST.����_�ȼ�);
    local targetType = Item.GetData(targetIndex,CONST.����_����);
    --print(fromItemID,targetItemID)
    if (Char.ItemNum(charIndex, Terra_itemId)==1) then
        if (fromItemID==targetItemID and CheckInTable(FusionEnable_check, targetItemID)==true) then
            local fromSlot = Char.GetSpecifyItemSlot(charIndex,fromIndex);
            local targetSlot = Char.GetSpecifyItemSlot(charIndex,targetIndex);
            Char.DelItemBySlot(charIndex, fromSlot);
            Char.DelItemBySlot(charIndex, targetSlot);
            Char.GiveItem(charIndex, FusionList[targetItemID], 1);
            NLG.UpChar(charIndex);
            return 1;
        end
    end
    return 0;
end

function Module:battleOverEventCallback(battleIndex)
  for i = 0, 9 do
        local charIndex = Battle.GetPlayer(battleIndex, i);
        if (charIndex >= 0 and Char.IsPlayer(charIndex)==true) then
            if (Char.ItemNum(charIndex, Agni_itemId)==0 and Char.ItemNum(charIndex, Aqua_itemId)==1 and Char.ItemNum(charIndex, Ventus_itemId)==0) then
                local totalLp = Char.GetData(charIndex, CONST.����_Ѫ)+5;
                local totalFp = Char.GetData(charIndex, CONST.����_ħ)+5;
                local HP_MAX = Char.GetData(charIndex, CONST.����_���Ѫ);
                local MP_MAX = Char.GetData(charIndex, CONST.����_���ħ);
                if (totalLp>HP_MAX) then totalLp=HP_MAX; end
                if (totalFp>MP_MAX) then totalFp=MP_MAX; end
                Char.SetData(charIndex,CONST.����_Ѫ, totalLp);
                Char.SetData(charIndex,CONST.����_ħ, totalFp);
                NLG.UpChar(charIndex);
                local injury = Char.GetData(charIndex, CONST.CHAR_����);
                local lost = Char.GetData(charIndex, CONST.CHAR_����);
                if ( injury < 1 and lost < 1) then
                    return;
                elseif ( injury > 0 and lost < 1) then
                    Char.SetData(charIndex, CONST.CHAR_����, 0);
                    NLG.UpChar(charIndex);
                elseif ( injury < 1 and lost > 0) then
                    Char.SetData(charIndex, CONST.CHAR_����, 0);
                    NLG.UpChar(charIndex);
                elseif ( injury > 0 and lost > 0) then
                    Char.SetData(charIndex, CONST.CHAR_����, 0);
                    Char.SetData(charIndex, CONST.CHAR_����, 0);
                    NLG.UpChar(charIndex);
                end
            elseif (Char.ItemNum(charIndex, Agni_itemId)==1 and Char.ItemNum(charIndex, Aqua_itemId)==0 and Char.ItemNum(charIndex, Ventus_itemId)==0) then
                --local Level = math.modf(Char.GetData(charIndex, CONST.����_�ȼ�)/10)+1;
                --if (Level>10) then Level = 10; end
                local Rand = NLG.Rand(1, 15);
                local burst = NLG.Rand(1, 50);
                if (burst>=41) then
                    Char.GiveItem(charIndex, DropsList[Rand][1], 1);
                end
            elseif (Char.ItemNum(charIndex, Agni_itemId)==0 and Char.ItemNum(charIndex, Aqua_itemId)==0 and Char.ItemNum(charIndex, Ventus_itemId)==1) then
                --local Level = math.modf(Char.GetData(charIndex, CONST.����_�ȼ�)/10)+1;
                --if (Level>10) then Level = 10; end
                local Rand = NLG.Rand(16, 18);
                local thing = NLG.Rand(1, #DropsList[Rand]);
                local burst = NLG.Rand(10, 50);
                if (burst>=41) then
                    Char.GiveItem(charIndex, DropsList[Rand][thing], 1);
                end
            else
                local burst = NLG.Rand(1, 100);
                if (burst>=97 or burst<=4) then
                    Char.GiveItem(charIndex, 70195, 1);
                end
            end
        end
  end
end


function CheckInTable(_idTab, _idVar) ---ѭ������
	for k,v in pairs(_idTab) do
		if v==_idVar then
			return true
		end
	end
	return false
end

Char.GetSpecifyItemSlot = function(charIndex,testIndex)
  for Slot=8,27 do
      local itemIndex = Char.GetItemIndex(charIndex, Slot);
      if (itemIndex > 0 and itemIndex==testIndex) then
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
