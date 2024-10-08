---模块类
local Module = ModuleBase:createModule('uniqueSkills')

local Terra_itemId = 70196;	--地精灵
local Agni_itemId = 70198;	--火精灵
local Aqua_itemId = 70197;	--水精灵
local Ventus_itemId = 70199;	--风精灵
local DropsList = {};
DropsList[1]={47121,47122,47123};	--剑
DropsList[2]={47124,47125,47126};	--斧
DropsList[3]={47127,47128,47129};	--枪
DropsList[4]={47139,47140,47141};	--杖
DropsList[5]={47130,47131,47132};	--弓
DropsList[6]={47136,47137,47138};	--小刀
DropsList[7]={47133,47134,47135};	--回力镖
DropsList[8]={47163,47164,47165};	--盾
DropsList[9]={47142,47143,47144};	--盔
DropsList[10]={47145,47146,47147};	--帽
DropsList[11]={47148,47149,47150};	--铠
DropsList[12]={47151,47152,47153};	--衣
DropsList[13]={47154,47155,47156};	--袍
DropsList[14]={47157,47158,47159};	--靴
DropsList[15]={47160,47161,47162};	--鞋
DropsList[16]={15201,15203,15209};	--料理
DropsList[17]={15606,15608,15610};	--药品
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
--- 加载模块钩子
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
            return exp * 1.5;		--角色获取的经验双倍
        end
    elseif (Char.IsPet(charIndex)==true) then
        local OwnerIndex = Pet.GetOwner(charIndex);
        if (Char.ItemNum(OwnerIndex, Terra_itemId)==1)then
            return exp * 2;		--宠物获取的经验双倍
        end
    end
    return exp;
end

function Module:OnItemOverLapEvent(charIndex, fromIndex, targetIndex, Num)
    local fromItemID = Item.GetData(fromIndex,0);
    local targetItemID = Item.GetData(targetIndex,0);
    local targetLevel = Item.GetData(targetIndex,CONST.道具_等级);
    local targetType = Item.GetData(targetIndex,CONST.道具_类型);
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
            if (Char.ItemNum(charIndex, Agni_itemId)==0 and Char.ItemNum(charIndex, Aqua_itemId)==1 and Char.ItemNum(charIndex, Ventus_itemId)==0 and Char.ItemNum(charIndex, Terra_itemId)==0) then
                local totalLp = Char.GetData(charIndex, CONST.对象_血)+25;
                local totalFp = Char.GetData(charIndex, CONST.对象_魔)+25;
                local HP_MAX = Char.GetData(charIndex, CONST.对象_最大血);
                local MP_MAX = Char.GetData(charIndex, CONST.对象_最大魔);
                if (totalLp>HP_MAX) then totalLp=HP_MAX; end
                if (totalFp>MP_MAX) then totalFp=MP_MAX; end
                Char.SetData(charIndex,CONST.对象_血, totalLp);
                Char.SetData(charIndex,CONST.对象_魔, totalFp);
                NLG.UpChar(charIndex);
                local injury = Char.GetData(charIndex, CONST.CHAR_受伤);
                local lost = Char.GetData(charIndex, CONST.CHAR_掉魂);
                if ( injury < 1 and lost < 1) then
                    return;
                elseif ( injury > 0 and lost < 1) then
                    Char.SetData(charIndex, CONST.CHAR_受伤, 0);
                    NLG.UpChar(charIndex);
                elseif ( injury < 1 and lost > 0) then
                    Char.SetData(charIndex, CONST.CHAR_掉魂, 0);
                    NLG.UpChar(charIndex);
                elseif ( injury > 0 and lost > 0) then
                    Char.SetData(charIndex, CONST.CHAR_受伤, 0);
                    Char.SetData(charIndex, CONST.CHAR_掉魂, 0);
                    NLG.UpChar(charIndex);
                end
            elseif (Char.ItemNum(charIndex, Agni_itemId)==1 and Char.ItemNum(charIndex, Aqua_itemId)==0 and Char.ItemNum(charIndex, Ventus_itemId)==0 and Char.ItemNum(charIndex, Terra_itemId)==0) then
                --local Level = math.modf(Char.GetData(charIndex, CONST.对象_等级)/10)+1;
                --if (Level>10) then Level = 10; end
                local Rand = NLG.Rand(1, 15);
                local burst = NLG.Rand(1, 50);
                if (burst>=41) then
                    Char.GiveItem(charIndex, DropsList[Rand][1], 1);
                end
            elseif (Char.ItemNum(charIndex, Agni_itemId)==0 and Char.ItemNum(charIndex, Aqua_itemId)==0 and Char.ItemNum(charIndex, Ventus_itemId)==1 and Char.ItemNum(charIndex, Terra_itemId)==0) then
                --local Level = math.modf(Char.GetData(charIndex, CONST.对象_等级)/10)+1;
                --if (Level>10) then Level = 10; end
                local Rand = NLG.Rand(16, 18);
                local thing = NLG.Rand(1, #DropsList[Rand]);
                local burst = NLG.Rand(10, 50);
                if (burst>=41) then
                    Char.GiveItem(charIndex, DropsList[Rand][thing], 1);
                end
            elseif (Char.ItemNum(charIndex, Agni_itemId)==0 and Char.ItemNum(charIndex, Aqua_itemId)==0 and Char.ItemNum(charIndex, Ventus_itemId)==0 and Char.ItemNum(charIndex, Terra_itemId)==1) then
                local amount = NLG.Rand(10, 100);
                local burst = NLG.Rand(10, 50);
                if (burst>=41) then
                    Char.AddGold(charIndex, amount);
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


function CheckInTable(_idTab, _idVar) ---循环函数
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

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
