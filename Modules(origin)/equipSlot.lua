local Module = ModuleBase:createModule('equipSlot')

local ItemPosName = {"�^ ��", "�� ��", "�� ��", "�� ��", "�� ��", "�Ʒ1", "�Ʒ2", "ˮ ��"}

--local ExpRate = 3;
local StrRequireExp = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,}	--����

function Module:equipSlotInfo(npc, player)
          local winMsg = "1\\nՈ�x��鿴���b����: \\n"
          for targetSlot = 0,7 do
                local targetIndex = EquipSlotStat(player, ItemPosName[targetSlot+1], "Q") or 0;
                local targetItemIndex = Char.GetItemIndex(player, targetSlot);
                if (targetIndex<0) then
                    EquipSlotStat(player, ItemPosName[targetSlot+1], "Q", 0);
                    EquipSlotStat(player, ItemPosName[targetSlot+1], "V", 0);
                end
                if targetItemIndex>=0 then
                        local tStrLv = EquipSlotStat(player, ItemPosName[targetSlot+1], "Q") or 0;
                        local tStrExp = EquipSlotStat(player, ItemPosName[targetSlot+1], "V") or 0;
                        local tStrExp = tStrExp/100;
                        local msg = "��۵ȼ�: ".. tStrLv .. "  Ŀǰ�쾚��: ".. tStrExp .."%";
                        winMsg = winMsg .. ItemPosName[targetSlot+1] .. "��" .. msg .. "\n"
                else
                        winMsg = winMsg .. ItemPosName[targetSlot+1] .. "��" .. "\n"
                end
          end
          NLG.ShowWindowTalked(player, self.equipSloterNPC, CONST.����_ѡ���, CONST.��ť_�ر�, 1, winMsg);
end

-------------------------------------------------------------------------------------------------------------------------------------
--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  --self:regCallback('BattleStartEvent', Func.bind(self.battleStartEventCallback, self))
  --self:regCallback('BattleOverEvent', Func.bind(self.battleOverEventCallback, self))
  self:regCallback('ItemAttachEvent', Func.bind(self.itemAttachCallback, self))
  self:regCallback('ItemDetachEvent', Func.bind(self.itemDetachCallback, self))
  self:regCallback('ItemExpansionEvent', Func.bind(self.itemExpansionCallback, self))

  self.equipSloterNPC = self:NPC_createNormal('�b���۹���', 14682, { x =36 , y = 31, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.equipSloterNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
          local winMsg = "1\\nՈ�x��鿴���b����: \\n"
          for targetSlot = 0,7 do
                local targetIndex = EquipSlotStat(player, ItemPosName[targetSlot+1], "Q") or 0;
                local targetItemIndex = Char.GetItemIndex(player, targetSlot);
                if (targetIndex<0) then
                    EquipSlotStat(player, ItemPosName[targetSlot+1], "Q", 0);
                    EquipSlotStat(player, ItemPosName[targetSlot+1], "V", 0);
                end
                if targetItemIndex>=0 then
                        local tStrLv = EquipSlotStat(player, ItemPosName[targetSlot+1], "Q") or 0;
                        local tStrExp = EquipSlotStat(player, ItemPosName[targetSlot+1], "V") or 0;
                        local tStrExp = tStrExp/100;
                        local msg = "��۵ȼ�: ".. tStrLv .. "  Ŀǰ�쾚��: ".. tStrExp .."%";
                        winMsg = winMsg .. ItemPosName[targetSlot+1] .. "��" .. msg .. "\n"
                else
                        winMsg = winMsg .. ItemPosName[targetSlot+1] .. "��" .. "\n"
                end
          end
          NLG.ShowWindowTalked(player, self.equipSloterNPC, CONST.����_ѡ���, CONST.��ť_�ر�, 1, winMsg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.equipSloterNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --print(data)
    if select > 0 then
      if (seqno == 11 and select == CONST.��ť_�ر�) then
                 return;
      end
      if (seqno == 11 and select == CONST.BUTTON_ȷ�� and data >= 1) then
          local keyNum = data*1;
          local tStrExp = EquipSlotStat(player, ItemPosName[targetSlot+1], "V") or 0;
          if (tStrExp/100>=100) then
              NLG.SystemMessage(player, "[ϵ�y]�쾚�����_100%������");
              return;
          end
          if (targetItemIndex>0) then
              local killNum = Char.ItemNum(player, 70194);
              if (keyNum ~=nil and math.ceil(keyNum)==keyNum) then
                  if (keyNum>killNum) then
                      NLG.SystemMessage(player, "[ϵ�y]�����������㣡");
                      return;
                  else
                      EquipSlotStat(player, ItemPosName[targetSlot+1], "V", tStrExp+keyNum);
                      Char.DelItem(player, 70194, keyNum);
                      local Level = math.floor(tStrExp/1000);
                      if (Level>StrRequireExp[Level] and Level<=StrRequireExp[Level+1]) then
                          EquipSlotStat(player, ItemPosName[targetSlot+1], "Q", StrRequireExp[Level]);
                      else
                          EquipSlotStat(player, ItemPosName[targetSlot+1], "Q", 0);
                      end
                  end
              end
          end
      end

    else
      if (seqno == 1 and select == CONST.��ť_�ر�) then
                 return;
      end
      if (seqno == 1 and data >= 1) then
          targetSlot = data-1;  --װ������� (ѡ����1)
          targetItemIndex = Char.GetItemIndex(player, targetSlot);
          if (targetItemIndex<0) then
              NLG.SystemMessage(player, "[ϵ�y]�����Ĳ���Ҫ�b�䡣");
              return;
          else
              local killNum = Char.ItemNum(player, 70194);
              local winMsg = "���b���ۏ�����\\n"
                                           .."�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
                                           .."���ڴ_�J����YӍ...\\n"
                                           .."\\n���������塡�ۡ�����λ��".. ItemPosName[targetSlot+1] .."\\n"
                                           .."\\n����������ǰ�ɳ��������".. killNum .."\\n"
                                           .."\\nՈ�_�Jݔ��֮��������\\n";
              NLG.ShowWindowTalked(player, self.equipSloterNPC, CONST.����_�����, CONST.BUTTON_ȷ���ر�, 11, winMsg);
          end
      else
                 return;
      end
    end
  end)


end

function Module:itemAttachCallback(charIndex, fromItemIndex)
      local targetSlot = Char.GetTargetItemSlot(charIndex,fromItemIndex)
      print(targetSlot);
      local targetIndex = EquipSlotStat(charIndex, ItemPosName[targetSlot+1], "Q") or 0;
      if (targetIndex<0) then
          EquipSlotStat(charIndex, ItemPosName[targetSlot+1], "Q", 0);
          EquipSlotStat(charIndex, ItemPosName[targetSlot+1], "V", 0);
      end

      local tStrExp = EquipSlotStat(charIndex, ItemPosName[targetSlot+1], "V") or 0;
      setItemStrData(fromItemIndex, tStrExp);
      Item.UpItem(charIndex, targetSlot);
      NLG.UpChar(charIndex);
  return 0;
end

function Module:itemDetachCallback(charIndex, fromItemIndex)
      local targetSlot = Char.GetTargetItemSlot(charIndex,fromItemIndex)
      local targetIndex = EquipSlotStat(charIndex, ItemPosName[targetSlot+1], "Q") or 0;
      if (targetIndex<0) then
          EquipSlotStat(charIndex, ItemPosName[targetSlot+1], "Q", 0);
          EquipSlotStat(charIndex, ItemPosName[targetSlot+1], "V", 0);
      end

  return 0;
end

function Module:itemExpansionCallback(itemIndex, type, msg, charIndex, slot)
  --self:logDebug('itemExpansionCallback', itemIndex, type, msg, charIndex, slot)

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
	local plus = lv * k * ExpRate;
	--��ҷ�
	for playerSlot=0,9 do
		local player = Battle.GetPlayer(battleIndex, playerSlot);
		local WeaponIndex = Char.GetWeapon(player);                --����������
		local ShieldIndex = Char.GetShield(player);                         --���޶�
		if WeaponIndex>0 and Char.EndEvent(player,306) == 1 then                --��Ϊ�Թ��˿�������
			local wandId = Item.GetData(WeaponIndex, CONST.����_ID);
			local targetSlot = Char.GetItemSlot(player, WeaponIndex);
			if (wandId==51003 or wandId==51007 or wandId==51011 or wandId==51015)  then
				local tItemName = Item.GetData(WeaponIndex, CONST.����_����);
				local hStrLv = EquipPlusStat(WeaponIndex, "H") or 0;
				local gStrExp = EquipPlusStat(WeaponIndex, "G") or 0;
				local hMaxLv = 20;
				local RequireExpNumTab = StrRequireExp[wandId]
				local RequireExpNum = RequireExpNumTab[hStrLv+1]
				--�����ֵ
				if EquipPlusStat(WeaponIndex)==nil then Item.SetData(WeaponIndex, CONST.����_��ǰ��, tItemName); end
				if (hStrLv<hMaxLv) then
					EquipPlusStat(WeaponIndex, "G", gStrExp+plus);
					Item.UpItem(player, targetSlot);
					NLG.SystemMessage(player, "[ϵ�y] �C����۷e" .. gStrExp+plus .. "/"..RequireExpNum.."");
				end
				--��������ǿ��
				local gStrExp = EquipPlusStat(WeaponIndex, "G") or 0;
				if (hStrLv<hMaxLv and gStrExp>=RequireExpNum) then
					EquipPlusStat(WeaponIndex, "H", hStrLv+1);
					EquipPlusStat(WeaponIndex, "G", gStrExp-RequireExpNum);
					setItemName(WeaponIndex);
					setItemStrData(WeaponIndex, hStrLv);
					Item.UpItem(player, targetSlot);
					NLG.SystemMessage(player, "[ϵ�y] ��ϲ�C�폊���ɹ���+" .. hStrLv+1 .. "��");
				end
				NLG.UpChar(player);
			end
		end
		if ShieldIndex>0 and Char.EndEvent(player,306) == 1 then
			local wandId = Item.GetData(ShieldIndex, CONST.����_ID);
			local targetSlot = Char.GetItemSlot(player, ShieldIndex);
			if (wandId==51019)  then
				local tItemName = Item.GetData(ShieldIndex, CONST.����_����);
				local hStrLv = EquipPlusStat(ShieldIndex, "H") or 0;
				local gStrExp = EquipPlusStat(ShieldIndex, "G") or 0;
				local hMaxLv = 20;
				local RequireExpNumTab = StrRequireExp[wandId]
				local RequireExpNum = RequireExpNumTab[hStrLv+1]
				--�����ֵ
				if EquipPlusStat(ShieldIndex)==nil then Item.SetData(ShieldIndex, CONST.����_��ǰ��, tItemName); end
				if (hStrLv<hMaxLv) then
					EquipPlusStat(ShieldIndex, "G", gStrExp+plus);
					Item.UpItem(player, targetSlot);
					NLG.SystemMessage(player, "[ϵ�y] �C����۷e" .. gStrExp+plus .. "/"..RequireExpNum.."");
				end
				--��������ǿ��
				local gStrExp = EquipPlusStat(ShieldIndex, "G") or 0;
				if (hStrLv<hMaxLv and gStrExp>=RequireExpNum) then
					EquipPlusStat(ShieldIndex, "H", hStrLv+1);
					EquipPlusStat(ShieldIndex, "G", gStrExp-RequireExpNum);
					setItemName(ShieldIndex);
					setItemStrData(ShieldIndex, hStrLv);
					Item.UpItem(player, targetSlot);
					NLG.SystemMessage(player, "[ϵ�y] ��ϲ�C�폊���ɹ���+" .. hStrLv+1 .. "��");
				end
				NLG.UpChar(player);
			end
		end
	end
end

function EquipSlotStat( _Index, _StatSlot, _StatTab, _StatValue )
	--  E-���裬P- ���ᣬH- �ԣ�G- ��Q- ��ۣ�V- ����
	local tStatTab = {}
	if type(_StatTab)=="nil" then
		--GetAll
		local tItemStat = tostring(Char.GetExtData(_Index, _StatSlot));
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
		Char.SetExtData(_Index, _StatSlot, tStat);
		NLG.UpChar(_Index);
	elseif type(_StatTab)=="string" and type(_StatValue)=="nil" then
		--GetSub
		local tStatTab = EquipSlotStat(_Index, _StatSlot) or {};
		for k,v in pairs(tStatTab) do
			if _StatTab==k then
				return tonumber(v);
			end
		end
		return nil;
	elseif type(_StatTab)=="string" then
		--SetSub
		local tStatTab = EquipSlotStat(_Index, _StatSlot) or {};
		tStatTab[_StatTab]=_StatValue;
		EquipSlotStat(_Index, _StatSlot, tStatTab);
	end
end


function setItemStrData( _ItemIndex, _StrExp)

	local bRate = (1 + _tStrExp/10000) * 0.1;
	local strData={%����_����%,%����_����%,%����_����%,%����_����%,%����_�ظ�%,%����_HP%,%����_MP%}

	for k,v in pairs(strData) do
 		if Item.GetData(_ItemIndex, v)>0 then
			if (k>=1 and k<=5) then
				Item.SetData(_ItemIndex, v, math.floor(Item.GetData(_ItemIndex, v)*bRate));
				Plus= math.floor(Item.GetData(_ItemIndex, v)*bRate) - Item.GetData(_ItemIndex, v);
			elseif (k>=6 and k<=7) then
				Item.SetData(_ItemIndex, v, math.floor(Item.GetData(_ItemIndex, v)*bRate*0.1));
				Plus= math.floor(Item.GetData(_ItemIndex, v)*bRate*0.1) - Item.GetData(_ItemIndex, v);
			end
			local tStat = "";
			local tStat = tStat .. v .. "," .. Plus .. "|";
			Item.SetData(_ItemIndex, CONST.����_���ò���, tStat);
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


Char.GetTargetItemSlot = function(charIndex,fromItemIndex)
  local type = Item.GetData(fromItemIndex, CONST.����_����);
  if (type==8 or type==9) then
      return 0;
  elseif (type==10 or type==11 or type==12) then
      return 1;
  elseif (type==13 or type==14) then
      return 4;
  elseif (type==0 or type==1 or type==2 or type==3 or type==4 or type==5 or type==6 or type==7) then
      local ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_����);
      if (ItemIndex < 0 or  ItemIndex~=fromItemIndex) then
          return 2;
      end
      ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_����)
      if (ItemIndex < 0 or  ItemIndex~=fromItemIndex) then
          return 3;
      end
  end
  return -1;
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
