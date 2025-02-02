---模块类
local Module = ModuleBase:createModule('uniqueSkills')

local Terra_itemId = 70196;	--地精灵
local Agni_itemId = 70198;	--火精灵
local Aqua_itemId = 70197;	--水精灵
local Ventus_itemId = 70199;	--风精灵
local DropsList = {};
DropsList[1]={3,39,63};		--剑
DropsList[2]={809,838,867};		--斧
DropsList[3]={1606,1634,1669};		--枪
DropsList[4]={2402,2446,2478};		--杖
DropsList[5]={2002,2038,2062};		--弓
DropsList[6]={3204,3235,3269};		--小刀
DropsList[7]={2801,2832,2863};		--回力镖
DropsList[8]={6402,6434,6463};		--盾
DropsList[9]={3602,3635,3664};		--盔
DropsList[10]={4001,4031,4062};	--帽
DropsList[11]={4405,4434,4461};	--铠
DropsList[12]={4806,4833,4860};	--衣
DropsList[13]={5205,5231,5262};	--袍
DropsList[14]={5601,5631,5660};	--靴
DropsList[15]={6002,6031,6063};	--鞋
DropsList[16]={15201,15203,15209};	--料理
DropsList[17]={15606,15608,15610};	--药品
DropsList[18]={18005,18006,18007,18008,18009};

local FusionEnable_check= {
    3,18,28,39,48,57,63,77,87,97,
    809,811,826,838,842,852,867,872,885,895,
    1606,1613,1625,1634,1649,1658,1669,1673,1686,1695,
    2002,2017,2023,2038,2042,2052,2062,2078,2083,2098,
    2402,2418,2434,2446,2450,2462,2478,2486,2495,2497,
    2801,2815,2823,2832,2843,2850,2863,2874,2889,2899,
    3204,3213,3229,3235,3241,3253,3269,3279,3281,3299,
    3602,3612,3620,3635,3640,3651,3664,3671,3682,2692,
    4001,4010,4020,4031,4042,4051,4062,4074,4084,4092,
    4405,4411,4421,4434,4444,4458,4461,4471,4481,4491,
    4806,4813,4821,4833,4844,4853,4860,4873,4883,4893,
    5205,5211,5223,5231,5244,5253,5262,5274,5282,5291,
    5601,5612,5621,5631,5641,5654,5660,5673,5681,5691,
    6002,6011,6025,6031,6040,6052,6063,6074,6081,6091,
    6402,6412,6425,6434,6449,6457,6463,6477,6481,6491,
};
local FusionList = {};
FusionList[3]=18;
FusionList[18]=28;
FusionList[28]=39;
FusionList[39]=48;
FusionList[48]=57;
FusionList[57]=63;
FusionList[63]=77;
FusionList[77]=87;
FusionList[87]=97;
FusionList[97]=600015;
FusionList[809]=811;
FusionList[811]=826;
FusionList[826]=838;
FusionList[838]=842;
FusionList[842]=852;
FusionList[852]=867;
FusionList[867]=872;
FusionList[872]=885;
FusionList[885]=895;
FusionList[895]=600215;
FusionList[1606]=1613;
FusionList[1613]=1625;
FusionList[1625]=1634;
FusionList[1634]=1649;
FusionList[1649]=1658;
FusionList[1658]=1669;
FusionList[1669]=1673;
FusionList[1673]=1686;
FusionList[1686]=1695;
FusionList[1695]=600415;
FusionList[2002]=2017;
FusionList[2017]=2023;
FusionList[2023]=2038;
FusionList[2038]=2042;
FusionList[2042]=2052;
FusionList[2052]=2062;
FusionList[2062]=2078;
FusionList[2078]=2083;
FusionList[2083]=2098;
FusionList[2098]=600615;
FusionList[2402]=2418;
FusionList[2418]=2434;
FusionList[2434]=2446;
FusionList[2446]=2450;
FusionList[2450]=2462;
FusionList[2462]=2478;
FusionList[2478]=2486;
FusionList[2486]=2495;
FusionList[2495]=2497;
FusionList[2497]=600815;
FusionList[2801]=2815;
FusionList[2815]=2823;
FusionList[2823]=2832;
FusionList[2832]=2843;
FusionList[2843]=2850;
FusionList[2850]=2863;
FusionList[2863]=2874;
FusionList[2874]=2889;
FusionList[2889]=2899;
FusionList[2899]=601015;
FusionList[3204]=3213;
FusionList[3213]=3229;
FusionList[3229]=3235;
FusionList[3235]=3241;
FusionList[3241]=3253;
FusionList[3253]=3269;
FusionList[3269]=3279;
FusionList[3279]=3281;
FusionList[3281]=3299;
FusionList[3299]=601215;

FusionList[3602]=3612;
FusionList[3612]=3620;
FusionList[3620]=3635;
FusionList[3635]=3640;
FusionList[3640]=3651;
FusionList[3651]=3664;
FusionList[3664]=3671;
FusionList[3671]=3682;
FusionList[3682]=3692;
FusionList[3692]=601415;
FusionList[4001]=4010;
FusionList[4010]=4020;
FusionList[4020]=4031;
FusionList[4031]=4042;
FusionList[4042]=4051;
FusionList[4051]=4062;
FusionList[4062]=4074;
FusionList[4074]=4084;
FusionList[4084]=4092;
FusionList[4092]=601615;
FusionList[4405]=4411;
FusionList[4411]=4421;
FusionList[4421]=4434;
FusionList[4434]=4444;
FusionList[4444]=4458;
FusionList[4458]=4461;
FusionList[4461]=4471;
FusionList[4471]=4481;
FusionList[4481]=4491;
FusionList[4491]=601815;
FusionList[4806]=4813;
FusionList[4813]=4821;
FusionList[4821]=4833;
FusionList[4833]=4844;
FusionList[4844]=4853;
FusionList[4853]=4860;
FusionList[4860]=4873;
FusionList[4873]=4883;
FusionList[4883]=4893;
FusionList[4893]=602015;
FusionList[5205]=5211;
FusionList[5211]=5223;
FusionList[5223]=5231;
FusionList[5231]=5244;
FusionList[5244]=5253;
FusionList[5253]=5262;
FusionList[5262]=5274;
FusionList[5274]=5282;
FusionList[5282]=5291;
FusionList[5291]=602215;
FusionList[5601]=5612;
FusionList[5612]=5621;
FusionList[5621]=5631;
FusionList[5631]=5641;
FusionList[5641]=5654;
FusionList[5654]=5660;
FusionList[5660]=5673;
FusionList[5673]=5681;
FusionList[5681]=5691;
FusionList[5691]=602415;
FusionList[6002]=6011;
FusionList[6011]=6025;
FusionList[6025]=6031;
FusionList[6031]=6040;
FusionList[6040]=6052;
FusionList[6052]=6063;
FusionList[6063]=6074;
FusionList[6074]=6081;
FusionList[6081]=6091;
FusionList[6091]=602615;
FusionList[6402]=6412;
FusionList[6412]=6425;
FusionList[6425]=6434;
FusionList[6434]=6449;
FusionList[6449]=6457;
FusionList[6457]=6463;
FusionList[6463]=6477;
FusionList[6477]=6481;
FusionList[6481]=6491;
FusionList[6491]=602815;

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
            if (fromSlot==-1 or targetSlot==-1) then
                NLG.SystemMessage(charIndex,"[系統]合成須在物品欄第一分頁");
                return 0;
            end
            Char.DelItemBySlot(charIndex, fromSlot);
            Char.DelItemBySlot(charIndex, targetSlot);
            local itemIndex = Char.GiveItem(charIndex, FusionList[targetItemID], 1);
            Item.SetData(itemIndex , CONST.道具_已鉴定 ,1);
            Item.UpItem(charIndex,-1)
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
                local Level = math.modf(Char.GetData(charIndex, CONST.对象_等级)/10)+1;
                if (Level>=13) then itemset = 3; elseif (Level>=8 and Level<13) then itemset = 2; elseif (Level>=1 and Level<8) then itemset = 1; end
                local Rand = NLG.Rand(1, 15);
                local burst = NLG.Rand(1, 50);
                if (burst>=41) then
                    local itemIndex = Char.GiveItem(charIndex, DropsList[Rand][itemset], 1);
                    Item.SetData(itemIndex , CONST.道具_已鉴定 ,1);
                    Item.UpItem(charIndex,-1)
                end
            elseif (Char.ItemNum(charIndex, Agni_itemId)==0 and Char.ItemNum(charIndex, Aqua_itemId)==0 and Char.ItemNum(charIndex, Ventus_itemId)==1 and Char.ItemNum(charIndex, Terra_itemId)==0) then
                --local Level = math.modf(Char.GetData(charIndex, CONST.对象_等级)/10)+1;
                --if (Level>10) then Level = 10; end
                local Rand = NLG.Rand(16, 18);
                local thing = NLG.Rand(1, #DropsList[Rand]);
                local burst = NLG.Rand(10, 50);
                if (burst>=41) then
                    local itemIndex = Char.GiveItem(charIndex, DropsList[Rand][thing], 1);
                    Item.SetData(itemIndex , CONST.道具_已鉴定 ,1);
                    Item.UpItem(charIndex,-1)
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
