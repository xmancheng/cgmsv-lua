local Module = ModuleBase:createModule('ghostHunter')

local StrBaseRate = {}
local StrResistRate = {}
local StrFixRate = {}
local StrRequireExp = {}
--  ʥ����
StrBaseRate[51003] = 	{2, 2, 2, 2, 3, 3, 3, 4, 4 ,5}			--��ͨ���԰ٷֱ�
StrResistRate[51003] = 	{1, 1, 1, 1, 1, 1, 2, 2, 2, 3}			--6����
StrFixRate[51003] = 		{1, 1, 1, 1, 1, 1, 2, 2, 2, 3}			--4����
StrRequireExp[51003] = {1000, 1000, 2000, 2000, 2000, 4000, 4000, 5000, 5000, 5000}	--�Թ���������
--  ʥ�䷨��
StrBaseRate[51007] = 	{2, 2, 2, 2, 3, 3, 3, 4, 4 ,5}			--��ͨ���԰ٷֱ�
StrResistRate[51007] = 	{1, 1, 1, 1, 1, 1, 2, 2, 2, 3}			--6����
StrFixRate[51007] = 		{1, 1, 1, 1, 1, 1, 2, 2, 2, 3}			--4����
StrRequireExp[51007] = {1000, 1000, 2000, 2000, 2000, 4000, 4000, 5000, 5000, 5000}	--�Թ���������
--  ����֮��
StrBaseRate[51011] = 	{2, 2, 2, 2, 3, 3, 3, 4, 4 ,5}			--��ͨ���԰ٷֱ�
StrResistRate[51011] = 	{1, 1, 1, 1, 1, 1, 2, 2, 2, 3}			--6����
StrFixRate[51011] = 		{1, 1, 1, 1, 1, 1, 2, 2, 2, 3}			--4����
StrRequireExp[51011] = {1000, 1000, 2000, 2000, 2000, 4000, 4000, 5000, 5000, 5000}	--�Թ���������
--  ��ɱ���｣
StrBaseRate[51015] = 	{2, 2, 2, 2, 3, 3, 3, 4, 4 ,5}			--��ͨ���԰ٷֱ�
StrResistRate[51015] = 	{1, 1, 1, 1, 1, 1, 2, 2, 2, 3}			--6����
StrFixRate[51015] = 		{1, 1, 1, 1, 1, 1, 2, 2, 2, 3}			--4����
StrRequireExp[51015] = {1000, 1000, 2000, 2000, 2000, 4000, 4000, 5000, 5000, 5000}	--�Թ���������
--  ����֮צ
StrBaseRate[51019] = 	{2, 2, 2, 2, 3, 3, 3, 4, 4 ,5}			--��ͨ���԰ٷֱ�
StrResistRate[51019] = 	{1, 1, 1, 1, 1, 1, 2, 2, 2, 3}			--6����
StrFixRate[51019] = 		{1, 1, 1, 1, 1, 1, 2, 2, 2, 3}			--4����
StrRequireExp[51019] = {1000, 1000, 2000, 2000, 2000, 4000, 4000, 5000, 5000, 5000}	--�Թ���������

--- ����ģ�鹳��
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
			local enemylv = Char.GetData(enemy, CONST.CHAR_�ȼ�);
			table.insert(Dm, i, enemylv);
		else
			table.insert(Dm, i, -1);
		end
	end
end
function Module:battleOverEventCallback(battleIndex)
	if Battle.IsBossBattle(battleIndex) == 1 then     --BOSS��Ч
		return;
	end
	if Battle.GetType(battleIndex) == 2 then            --PVP��Ч
		return;
	end
	--���ƽ���ȼ�
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
	--��ҷ�
	for playerSlot=0,9 do
		local player = Battle.GetPlayer(battleIndex, playerSlot);
		local WeaponIndex = Char.GetWeapon(player);                --����������
		local ShieldIndex = Char.GetShield(player);                         --���޶�
		if WeaponIndex>0 and Char.EndEvent(player,17) == 1 then                --��Ϊ�Թ��˿�������
			local wandId = Item.GetData(WeaponIndex, CONST.����_ID);
			local targetSlot = Char.GetItemSlot(player, WeaponIndex);
			if (wandId==51003 or wandId==51007 or wandId==51011 or wandId==51015)  then
				local tItemName = Item.GetData(WeaponIndex, CONST.����_����);
				local hStrLv = EquipPlusStat(WeaponIndex, "H") or 0;
				local gStrExp = EquipPlusStat(WeaponIndex, "G") or 0;
				local hMaxLv = 10;
				local RequireExpNumTab = StrRequireExpNum[wandId]
				local RequireExpNum = RequireExpNumTab[hStrLv+1]
				--�����ֵ
				if EquipPlusStat(WeaponIndex)==nil then Item.SetData(WeaponIndex, CONST.����_��ǰ��, tItemName); end
				EquipPlusStat(WeaponIndex, "G", gStrExp+plus);
				NLG.SystemMessage(player, "[ϵ�y] �C����۷e" .. gStrExp+plus .. "/"..RequireExpNum.."");
				--��������ǿ��
				if (hStrLv<hMaxLv and gStrExp>=RequireExpNum) then
					EquipPlusStat(WeaponIndex, "H", hStrLv+1);
					EquipPlusStat(WeaponIndex, "G", 0);
					setItemName(WeaponIndex);
					setItemStrData(WeaponIndex, hStrLv);
				end
				Item.UpItem(player, targetSlot);
				NLG.UpChar(player);
				NLG.SystemMessage(player, "[ϵ�y] ��ϲ�C�폊���ɹ���+" .. hStrLv+1 .. "��");
			end
		elseif ShieldIndex>0 and Char.EndEvent(player,17) == 1 then
			local wandId = Item.GetData(ShieldIndex, CONST.����_ID);
			local targetSlot = Char.GetItemSlot(player, ShieldIndex);
			if (wandId==51019)  then
				local tItemName = Item.GetData(ShieldIndex, CONST.����_����);
				local hStrLv = EquipPlusStat(ShieldIndex, "H") or 0;
				local gStrExp = EquipPlusStat(ShieldIndex, "G") or 0;
				local hMaxLv = 10;
				local RequireExpNumTab = StrRequireExpNum[wandId]
				local RequireExpNum = RequireExpNumTab[hStrLv+1]
				--�����ֵ
				if EquipPlusStat(ShieldIndex)==nil then Item.SetData(ShieldIndex, CONST.����_��ǰ��, tItemName); end
				EquipPlusStat(ShieldIndex, "G", gStrExp+plus);
				NLG.SystemMessage(player, "[ϵ�y] �C����۷e" .. gStrExp+plus .. "/"..RequireExpNum.."");
				--��������ǿ��
				if (hStrLv<hMaxLv and gStrExp>=RequireExpNum) then
					EquipPlusStat(ShieldIndex, "H", hStrLv+1);
					EquipPlusStat(ShieldIndex, "G", 0);
					setItemName(ShieldIndex);
					setItemStrData(ShieldIndex, hStrLv);
				end
				Item.UpItem(player, targetSlot);
				NLG.UpChar(player);
				NLG.SystemMessage(player, "[ϵ�y] ��ϲ�C�폊���ɹ���+" .. hStrLv+1 .. "��");
			end
		end
	end
end

function EquipPlusStat( _ItemIndex, _StatTab, _StatValue )
	--  E-���裬P- ���ᣬH- �ԣ�G- ��
	local tStatTab = {}
	if type(_StatTab)=="nil" then
		--GetAll
		local tItemStat = tostring(Item.GetData(_ItemIndex, CONST.����_���ò���));
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
		Item.SetData(_ItemIndex, CONST.����_���ò���, tStat);
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
	local ItemName = Item.GetData(_ItemIndex, CONST.����_��ǰ��);
	--�ѡ�??���怡�����������I
	for k,v in pairs(StatTab) do
		if k=="H" then
			ItemName = ItemName .. "+" .. v
		end
	end
	Item.SetData(_ItemIndex, CONST.����_����, ItemName);
end

function setItemStrData( _ItemIndex, _StrLv)
	local tItemID = Item.GetData(_ItemIndex, 0)
	local bRateTab = StrBaseRate[tItemID]
	local bRate = 1 + bRateTab[_StrLv+1]/100
	Item.SetData(_ItemIndex, %����_����%, Item.GetData(_ItemIndex, %����_����%)*bRate)
	Item.SetData(_ItemIndex, %����_����%, Item.GetData(_ItemIndex, %����_����%)*bRate)
	Item.SetData(_ItemIndex, %����_����%, Item.GetData(_ItemIndex, %����_����%)*bRate)
	Item.SetData(_ItemIndex, %����_����%, Item.GetData(_ItemIndex, %����_����%)*bRate)
	Item.SetData(_ItemIndex, %����_�ظ�%, Item.GetData(_ItemIndex, %����_�ظ�%)*bRate)
	Item.SetData(_ItemIndex, %����_HP%, Item.GetData(_ItemIndex, %����_HP%)*bRate)
	Item.SetData(_ItemIndex, %����_MP%, Item.GetData(_ItemIndex, %����_MP%)*bRate)
	Item.SetData(_ItemIndex, %����_ħ��%, Item.GetData(_ItemIndex, %����_ħ��%)*bRate)
	Item.SetData(_ItemIndex, %����_ħ��%, Item.GetData(_ItemIndex, %����_ħ��%)*bRate)
	--��0�߹̶���ֵ
	local strData={%����_����%,%����_˯��%,%����_ʯ��%,%����_��%,%����_�ҿ�%,%����_����%,%����_��ɱ%,%����_����%,%����_����%,%����_����%}
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
  local ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_����);
  if ItemIndex >= 0 and Item.GetData(ItemIndex, CONST.����_����)==CONST.ITEM_TYPE_�� then
    return ItemIndex,CONST.EQUIP_����;
  end
  ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_����)
  if ItemIndex >= 0 and Item.GetData(ItemIndex, CONST.����_����)==CONST.ITEM_TYPE_�� then
    return ItemIndex,CONST.EQUIP_����;
  end
  return -1,-1;
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
