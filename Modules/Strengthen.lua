---ģ����
local Module = ModuleBase:createModule('Strengthen')

local cardList = {
    500215,500216,500217,500218,500219,
    500220,500221,500222,500223,500224,
    500225,500226,500227,500228,500229,
    500230,500231,500232,500233,500234,
    500235,500236,500237,500238,500239,
    500240,500241,500242,500243,500244,
    500245,500246,500247,500248,500249,
}

local StrStrengMaxLv = 9;
local StrSuccRate = {70, 65, 50, 45, 25, 20, 10, 5, 1}                                                                  --����ɹ���
local StrRequireGold = {1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000}               --��������ħ��

local ItemPosName = {"�^ ��", "�� ��", "�� ��", "�� ��", "�� ��", "�Ʒ1", "�Ʒ2", "ˮ ��"}
--�����Ÿ��衿
local StrItemEnable = {}
StrItemEnable[79060] = 1    --������
StrItemEnable[79061] = 1
StrItemEnable[79062] = 1
StrItemEnable[79063] = 1
StrItemEnable[79064] = 1
StrItemEnable[79065] = 1
StrItemEnable[69226] = 1    --���Ͼ���
StrItemEnable[69227] = 1
StrItemEnable[69228] = 1
StrItemEnable[69229] = 1
---------------------------------------------------------------------------------------------
--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self.enchanterNPC = self:NPC_createNormal('�x�迨Ƭ��ħ��', 104746, { x = 27, y = 7, mapType = 0, map = 25000, direction = 4 });
  self:NPC_regTalkedEvent(self.enchanterNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local winMsg = "1\\nՈ�x����Ҫ�x����b�䣺\\n"
        for targetSlot = 0,7 do
                local targetItemIndex = Char.GetItemIndex(player, targetSlot);
                if targetItemIndex>=0 then
                        local tItemID = Item.GetData(targetItemIndex, CONST.����_ID);
                        local tItemName = Item.GetData(targetItemIndex, CONST.����_����);
                        local tStrLv = EquipPlusStat(targetItemIndex, "E") or 0;
                        local tMaxLv = StrStrengMaxLv;
                        local tNeedGold = StrRequireGold[tStrLv+1];
                        local tItemCan = "[�x���]";
                        if (StrItemEnable[tItemID]~=1) then tItemCan="[�x���]"end
                        if (tStrLv>=tMaxLv) then tItemCan="[�x��Max]" end
                        local msg = tItemName .. " " .. tItemCan;
                        winMsg = winMsg .. ItemPosName[targetSlot+1] .. "��" .. msg .. "\n"
                else
                        winMsg = winMsg .. ItemPosName[targetSlot+1] .. "��" .. "\n"
                end
        end
        NLG.ShowWindowTalked(player, self.enchanterNPC, CONST.����_ѡ���, CONST.��ť_ȷ���ر�, 1, winMsg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.enchanterNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --print(data)
    local tPlayerGold = Char.GetData(player, CONST.����_���);
    if select > 0 then
      --�Ƿ񴰿ڻص�
      if (seqno == 1 and select == CONST.��ť_�ر�)  then
                 return;
      end
      if (seqno == 12 and select == CONST.��ť_�ر�) then
                 return;
      end
    else
      --ѡ�񴰿ڻص�
      if (seqno == 1 and data>0)  then      --ѡ��ħ����
          targetSlot = data-1;  --װ������� (ѡ����1)
          targetItemIndex = Char.GetItemIndex(player, targetSlot);
          tItemID = Item.GetData(targetItemIndex, CONST.����_ID);
          tItemName = Item.GetData(targetItemIndex, CONST.����_����);
          tStrLv = EquipPlusStat(targetItemIndex, "E") or 0;
          tMaxLv = StrStrengMaxLv;
          tNeedGold = StrRequireGold[tStrLv+1];
          print(targetItemIndex,tItemName)
          if targetItemIndex>=0 then
                 if (StrItemEnable[tItemID]~=1) then
                        NLG.SystemMessage(player, "[" .. "����Ī" .. "] ���x����b��[" .. tItemName .. "]��[�����x��]��");
                        return;
                 end
                 if (tStrLv>=tMaxLv) then
                        NLG.SystemMessage(player, "[" .. "����Ī" .. "] ���x����b��[" .. tItemName .. "]���_��[�x��Max]��");
                        return;
                 else
                        local winMsg = "1\\nՈ�x��Ҫʹ�õĈD�a��Ƭ(��ħ����)��\\n";
                        for itemSlot = 8,16 do
                              CardIndex = Char.GetItemIndex(player,itemSlot);
                              CardID = Item.GetData(CardIndex,CONST.����_ID);
                              CardLv = Item.GetData(CardIndex,CONST.����_�ȼ�);
                              CardType = Item.GetData(CardIndex,CONST.����_����);
                              CardName = Item.GetData(CardIndex, CONST.����_����);
                              if (tStrLv+1==CardLv and CardType==41) then
                                   winMsg = winMsg .. "��".. itemSlot-7 .."��:" .. CardName .. "��" .. "\\n"
                              else
                                   winMsg = winMsg .. "��".. itemSlot-7 .."��:�o��Ʒ.��Ƭ�ȼ����m�ϴ��x��" .. "\\n"
                              end
                        end
                        NLG.ShowWindowTalked(player, self.enchanterNPC, CONST.����_ѡ���, CONST.BUTTON_�ر�, 12, winMsg);
                 end
          else
                 NLG.SystemMessage(player, "[" .. "����Ī" .. "] ���x��Ĳ�λ�o�b�䣡");
                 return;
          end
      elseif (seqno == 12 and data>0) then      --���и���
          if (targetItemIndex ~=nil) then
                 if (tPlayerGold<tNeedGold) then
                                  NLG.SystemMessage(player, "[" .. "����Ī" .. "] �x����Ҫ" .. tNeedGold .. "G��������Ų��㣡");
                                  return;
                 end
                 locla itemSlot = data+7;
                 CardIndex = Char.GetItemIndex(player,itemSlot);
                 CardID = Item.GetData(CardIndex,CONST.����_ID);
                 CardLv = Item.GetData(CardIndex,CONST.����_�ȼ�);
                 CardType = Item.GetData(CardIndex,CONST.����_����);
                 CardName = Item.GetData(CardIndex, CONST.����_����);
                 if (tStrLv+1==CardLv and CardType==41) then
                     Char.SetData(player, CONST.����_���, tPlayerGold-tNeedGold);
                     Char.DelItem(player, CardID, 1);
                     local SuccRate = StrSuccRate[tStrLv+1];
                     if (type(SuccRate)=="number" and SuccRate>0) then
                                  local tMin = 50 - math.floor(SuccRate/2) + 1;
                                  local tMax = 50 + math.floor(SuccRate/2) + math.fmod(SuccRate,2);
                                  local tLuck = math.random(1, 100);
                                  if tLuck<tMin or tLuck>tMax then
                                                   NLG.SystemMessage(player, "[" .. "����Ī" .. "] �b���x��ʧ��������ħ��������;��½�����");
                                                   return;
                                  end
                     end
                     if EquipPlusStat(targetItemIndex)==nil then Item.SetData(targetItemIndex, CONST.����_��ǰ��, targetName); end
                     EquipPlusStat(targetItemIndex, "E", tStrLv+1);
                     setItemName(targetItemIndex);
                     Item.SetData(targetItemIndex,CONST.����_����, 500);
                     Item.UpItem(targetItemIndex, targetSlot);
                     NLG.SystemMessage(player, "[ϵ�y]Ոж�������b�䣡");
                     NLG.UpChar(player);
                 else
                     NLG.SystemMessage(player, "[ϵ�y]�oЧ���x��");
                     return;
                 end
          end
      else
                 return;
      end
    end
  end)


end


function EquipPlusStat( _ItemIndex, _StatTab, _StatValue )
	--  E-���裬P- ����
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
		if k=="E" then
			ItemName = ItemName .. "+" .. v
		end
	end
	Item.SetData(_ItemIndex, CONST.����_����, ItemName);
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
