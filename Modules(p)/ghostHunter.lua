local Module = ModuleBase:createModule('ghostHunter')

local StrBaseRate = {}
local StrResistRate = {}
local StrFixRate = {}
local StrRequireExp = {}
--  圣龙剑
StrBaseRate[51003] = 	{2, 2, 2, 2, 3, 3, 3, 4, 4 ,5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5}			--普通属性百分比
StrResistRate[51003] = 	{1, 1, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3}			--6抗性
StrFixRate[51003] = 		{1, 1, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3}			--4修正
StrRequireExp[51003] = {1000, 1000, 2000, 2000, 2000, 4000, 4000, 5000, 5000, 5000, 100000, 100000, 200000, 200000, 200000, 400000, 400000, 500000, 500000, 500000, 9999999}	--猎鬼升级经验
--  圣典法杖
StrBaseRate[51007] = 	{2, 2, 2, 2, 3, 3, 3, 4, 4 , 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5}			--普通属性百分比
StrResistRate[51007] = 	{1, 1, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3}			--6抗性
StrFixRate[51007] = 		{1, 1, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3}			--4修正
StrRequireExp[51007] = {1000, 1000, 2000, 2000, 2000, 4000, 4000, 5000, 5000, 5000, 100000, 100000, 200000, 200000, 200000, 400000, 400000, 500000, 500000, 500000, 9999999}	--猎鬼升级经验
--  疾风之弓
StrBaseRate[51011] = 	{2, 2, 2, 2, 3, 3, 3, 4, 4 ,5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5}			--普通属性百分比
StrResistRate[51011] = 	{1, 1, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3}			--6抗性
StrFixRate[51011] = 		{1, 1, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3}			--4修正
StrRequireExp[51011] = {1000, 1000, 2000, 2000, 2000, 4000, 4000, 5000, 5000, 5000, 100000, 100000, 200000, 200000, 200000, 400000, 400000, 500000, 500000, 500000, 9999999}	--猎鬼升级经验
--  鬼杀手里剑
StrBaseRate[51015] = 	{2, 2, 2, 2, 3, 3, 3, 4, 4 ,5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5}			--普通属性百分比
StrResistRate[51015] = 	{1, 1, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3}			--6抗性
StrFixRate[51015] = 		{1, 1, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3}			--4修正
StrRequireExp[51015] = {1000, 1000, 2000, 2000, 2000, 4000, 4000, 5000, 5000, 5000, 100000, 100000, 200000, 200000, 200000, 400000, 400000, 500000, 500000, 500000, 9999999}	--猎鬼升级经验
--  兽王之爪
StrBaseRate[51019] = 	{2, 2, 2, 2, 3, 3, 3, 4, 4 ,5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5}			--普通属性百分比
StrResistRate[51019] = 	{1, 1, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3}			--6抗性
StrFixRate[51019] = 		{1, 1, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3}			--4修正
StrRequireExp[51019] = {1000, 1000, 2000, 2000, 2000, 4000, 4000, 5000, 5000, 5000, 100000, 100000, 200000, 200000, 200000, 400000, 400000, 500000, 500000, 500000, 9999999}	--猎鬼升级经验

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BattleStartEvent', Func.bind(self.battleStartEventCallback, self))
  self:regCallback('BattleOverEvent', Func.bind(self.battleOverEventCallback, self))
end

local Dm={}
function Module:battleStartEventCallback(battleIndex)
	for i=10,19 do
		local enemy = Battle.GetPlayer(battleIndex, i);
		if enemy >0 then
			local enemylv = Char.GetData(enemy, CONST.CHAR_等级);
			table.insert(Dm, i, enemylv);
		else
			table.insert(Dm, i, -1);
		end
	end
end
function Module:battleOverEventCallback(battleIndex)
	if Battle.IsBossBattle(battleIndex) == 1 then     --BOSS无效
		return;
	end
	if Battle.GetType(battleIndex) == 2 then            --PVP无效
		return;
	end
	--鬼怪平均等级
	local m = 0;
	local k = 0;
	for i=10,19 do
		if Dm[i]>0 then
			m = m+Dm[i];
			k = k+1;
		end
	end
	local lv = math.floor(m/k);
	local plus = lv*(lv+13)*k;
	--玩家方
	for playerSlot=0,9 do
		local player = Battle.GetPlayer(battleIndex, playerSlot);
		local WeaponIndex = Char.GetWeapon(player);                --左右手武器
		local ShieldIndex = Char.GetShield(player);                         --修罗盾
		if WeaponIndex>0 and Char.EndEvent(player,306) == 1 then                --成为猎鬼人开启功能
			local wandId = Item.GetData(WeaponIndex, CONST.道具_ID);
			local targetSlot = Char.GetItemSlot(player, WeaponIndex);
			if (wandId==51003 or wandId==51007 or wandId==51011 or wandId==51015)  then
				local tItemName = Item.GetData(WeaponIndex, CONST.道具_名字);
				local hStrLv = EquipPlusStat(WeaponIndex, "H") or 0;
				local gStrExp = EquipPlusStat(WeaponIndex, "G") or 0;
				local hMaxLv = 20;
				local RequireExpNumTab = StrRequireExp[wandId]
				local RequireExpNum = RequireExpNumTab[hStrLv+1]
				--打鬼经验值
				if EquipPlusStat(WeaponIndex)==nil then Item.SetData(WeaponIndex, CONST.道具_鉴前名, tItemName); end
				if (hStrLv<hMaxLv) then
					EquipPlusStat(WeaponIndex, "G", gStrExp+plus);
					NLG.SystemMessage(player, "[系統] 獵鬼經驗累積" .. gStrExp+plus .. "/"..RequireExpNum.."");
				end
				--武器精炼强化
				if (hStrLv<hMaxLv and gStrExp>=RequireExpNum) then
					EquipPlusStat(WeaponIndex, "H", hStrLv+1);
					EquipPlusStat(WeaponIndex, "G", 0);
					setItemName(WeaponIndex);
					setItemStrData(WeaponIndex, hStrLv);
					NLG.SystemMessage(player, "[系統] 恭喜獵鬼強化成功到+" .. hStrLv+1 .. "！");
				else
					return;
				end
				Item.UpItem(player, targetSlot);
				NLG.UpChar(player);
			end
		elseif ShieldIndex>0 and Char.EndEvent(player,306) == 1 then
			local wandId = Item.GetData(ShieldIndex, CONST.道具_ID);
			local targetSlot = Char.GetItemSlot(player, ShieldIndex);
			if (wandId==51019)  then
				local tItemName = Item.GetData(ShieldIndex, CONST.道具_名字);
				local hStrLv = EquipPlusStat(ShieldIndex, "H") or 0;
				local gStrExp = EquipPlusStat(ShieldIndex, "G") or 0;
				local hMaxLv = 20;
				local RequireExpNumTab = StrRequireExp[wandId]
				local RequireExpNum = RequireExpNumTab[hStrLv+1]
				--打鬼经验值
				if EquipPlusStat(ShieldIndex)==nil then Item.SetData(ShieldIndex, CONST.道具_鉴前名, tItemName); end
				if (hStrLv<hMaxLv) then
					EquipPlusStat(ShieldIndex, "G", gStrExp+plus);
					NLG.SystemMessage(player, "[系統] 獵鬼經驗累積" .. gStrExp+plus .. "/"..RequireExpNum.."");
				end
				--武器精炼强化
				if (hStrLv<hMaxLv and gStrExp>=RequireExpNum) then
					EquipPlusStat(ShieldIndex, "H", hStrLv+1);
					EquipPlusStat(ShieldIndex, "G", 0);
					setItemName(ShieldIndex);
					setItemStrData(ShieldIndex, hStrLv);
					NLG.SystemMessage(player, "[系統] 恭喜獵鬼強化成功到+" .. hStrLv+1 .. "！");
				else
					return;
				end
				Item.UpItem(player, targetSlot);
				NLG.UpChar(player);
			end
		end
	end
end

function EquipPlusStat( _ItemIndex, _StatTab, _StatValue )
	--  E-赋予，P- 喷漆，H- 猎，G- 鬼
	local tStatTab = {}
	if type(_StatTab)=="nil" then
		--GetAll
		local tItemStat = tostring(Item.GetData(_ItemIndex, CONST.道具_自用参数));
		if string.find(tItemStat, ",")==nil then
			return nil;
		end
		if string.find(tItemStat, "|")==nil then
			local tSub = string.split(tItemStat, ",");
			tStatTab[tSub[1]]=tonumber(tSub[2]);
			return tStatTab;
		end
		local tStat = string.split(tItemStat, "|")
		for k,v in pairs(tStat) do
			local tSub = string.split(v, ",");
			tStatTab[tSub[1]]=tonumber(tSub[2]);
		end
		return tStatTab;
	elseif type(_StatTab)=="table" then
		--SetAll
		local tStat = "";
		for k,v in pairs(_StatTab) do
			tStat = tStat .. k .. "," .. v .. "|";
		end
		Item.SetData(_ItemIndex, CONST.道具_自用参数, tStat);
	elseif type(_StatTab)=="string" and type(_StatValue)=="nil" then
		--GetSub
		local tStatTab = EquipPlusStat(_ItemIndex) or {};
		for k,v in pairs(tStatTab) do
			if _StatTab==k then
				return tonumber(v);
			end
		end
		return nil;
	elseif type(_StatTab)=="string" then
		--SetSub
		local tStatTab = EquipPlusStat(_ItemIndex) or {};
		tStatTab[_StatTab]=_StatValue;
		EquipPlusStat(_ItemIndex, tStatTab);
	end
end

function setItemName( _ItemIndex , _Name)
	local StatTab = EquipPlusStat( _ItemIndex );
	local ItemName = Item.GetData(_ItemIndex, CONST.道具_鉴前名);
	--⊙¤??Фф€◎●◇◆□■★☆㊣
	for k,v in pairs(StatTab) do
		if k=="H" then
			ItemName = ItemName .. "+" .. v
		end
	end
	Item.SetData(_ItemIndex, CONST.道具_名字, ItemName);
end

function setItemStrData( _ItemIndex, _StrLv)
	local tItemID = Item.GetData(_ItemIndex, 0)
	local bRateTab = StrBaseRate[tItemID]
	local bRate = 1 + bRateTab[_StrLv+1]/100
	Item.SetData(_ItemIndex, %道具_攻击%, Item.GetData(_ItemIndex, %道具_攻击%)*bRate)
	Item.SetData(_ItemIndex, %道具_防御%, Item.GetData(_ItemIndex, %道具_防御%)*bRate)
	Item.SetData(_ItemIndex, %道具_敏捷%, Item.GetData(_ItemIndex, %道具_敏捷%)*bRate)
	Item.SetData(_ItemIndex, %道具_精神%, Item.GetData(_ItemIndex, %道具_精神%)*bRate)
	Item.SetData(_ItemIndex, %道具_回复%, Item.GetData(_ItemIndex, %道具_回复%)*bRate)
	Item.SetData(_ItemIndex, %道具_HP%, Item.GetData(_ItemIndex, %道具_HP%)*bRate)
	Item.SetData(_ItemIndex, %道具_MP%, Item.GetData(_ItemIndex, %道具_MP%)*bRate)
	Item.SetData(_ItemIndex, %道具_魔攻%, Item.GetData(_ItemIndex, %道具_魔攻%)*bRate)
	Item.SetData(_ItemIndex, %道具_魔抗%, Item.GetData(_ItemIndex, %道具_魔抗%)*bRate)
	--非0者固定加值
	local strData={%道具_毒抗%,%道具_睡抗%,%道具_石抗%,%道具_醉抗%,%道具_乱抗%,%道具_忘抗%,%道具_必杀%,%道具_反击%,%道具_命中%,%道具_闪躲%}
	--Resist
	local rRateTab = StrResistRate[tItemID] or StrResistRate[-1]
	local rRate = rRateTab[_StrLv+1]
	--Fix
	local fRateTab = StrFixRate[tItemID] or StrFixRate[-1]
	local fRate = fRateTab[_StrLv+1]
	for k,v in pairs(strData) do
 		if Item.GetData(_ItemIndex, v)>0 then
			if (k>=1 and k<=6) then
				Item.SetData(_ItemIndex, v, Item.GetData(_ItemIndex, v)+rRate)
			elseif (k>=7 and k<=10) then
				Item.SetData(_ItemIndex, v, Item.GetData(_ItemIndex, v)+fRate)
			end
		end
	end
	
end

Char.GetShield = function(charIndex)
  local ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_左手);
  if ItemIndex >= 0 and Item.GetData(ItemIndex, CONST.道具_类型)==CONST.ITEM_TYPE_盾 then
    return ItemIndex,CONST.EQUIP_左手;
  end
  ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_右手)
  if ItemIndex >= 0 and Item.GetData(ItemIndex, CONST.道具_类型)==CONST.ITEM_TYPE_盾 then
    return ItemIndex,CONST.EQUIP_右手;
  end
  return -1,-1;
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
