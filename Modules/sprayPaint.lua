---ģ����
local Module = ModuleBase:createModule('sprayPaint')

local sprayList = {
    500215,500216,500217,500218,500219,
    500220,500221,500222,500223,500224,
    500225,500226,500227,500228,500229,
    500230,500231,500232,500233,500234,
    500235,500236,500237,500238,500239,
    500240,500241,500242,500243,500244,
    500245,500246,500247,500248,500249,
}

local EquipType = {}
function ChooseType(sprayType,targetType)
    local EquipType = {};
    if sprayType==0 then            --ͷ
        EquipType={ {"ñ��",9}, {"�^��",8} };
    elseif sprayType==1 then    --��
        EquipType={ {"�·�",11}, {"�z��",10}, {"�L��",12} };
    elseif sprayType==2 then    --��
        if (targetType==0) then TypeName="��";
        elseif (targetType==1) then TypeName="��";
        elseif (targetType==2) then TypeName="��";
        elseif (targetType==3) then TypeName="��";
        elseif (targetType==4) then TypeName="��";
        elseif (targetType==5) then TypeName="С��";
        elseif (targetType==6) then TypeName="ޒ���S";
        end
        EquipType={ {TypeName,targetType} };
    elseif sprayType==4 then    --��
        EquipType={ {"Ь��",14}, {"ѥ��",13} };
    elseif sprayType==5 then    --��
        EquipType={ {"�֭h",15}, {"����",16}, {"��",17}, {"��ָ",18}, {"�^��",19}, {"���h",20}, {"�o���",21} };
    end
    return EquipType;
end

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('ItemDurabilityChangedEvent', Func.bind(self.OnItemDurabilityChangedEventCallback, self));
  self:regCallback('ItemString', Func.bind(self.sprayTools, self),"LUA_useProFilm");
  self.paintingNPC = self:NPC_createNormal('���⇊���Ĥ����', 14682, { x = 36, y = 31, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.paintingNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local msg = "\\n@c���b�䇊���Ĥ��" ..	"\\n\\n�����Ĥ����b����Ա���������������ش������ɵĸ��;Óp�ġ������ͬϵ����Ĥ�����b���@�����b�������|�ӳ�Ч����\\n��ע�⣺�Ĥ�ጢ�o���M���x�菊��"
                                                                               ..	"\\n\\n�_��ʹ�� ���Ṥ�ߣ��� ���������� �����Ĥ�᣿";
        NLG.ShowWindowTalked(player, self.paintingNPC, CONST.����_��Ϣ��, CONST.��ť_ȷ���ر�, 1, msg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.paintingNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --���Ṥ��
    local ItemIndex =Char.HaveItemID(player, ItemID);
    local ItemSlot = Char.FindItemId(player, ItemID);
    local sprayType = Item.GetData(ItemIndex, CONST.����_�Ӳ�һ);
    local sprayImage = Item.GetData(ItemIndex,CONST.����_�Ӳζ�);
    --Ŀ��װ��
    local targetSlot = sprayType;      --װ��λ�ø�
    local targetItemIndex = Char.GetItemIndex(player,targetSlot);
    local targetType = Item.GetData(targetItemIndex, CONST.����_����);
    local targetName = Item.GetData(targetItemIndex, CONST.����_����);
    local spraySkin = tonumber(EquipPlusStat(targetItemIndex, "P")) or 0;
    --print(ItemSlot,sprayType,sprayImage,targetName,spraySkin)
    print(data)
    if select > 0 then
      if (targetItemIndex<0) then
                 NLG.SystemMessage(player, "[ϵ�y]Ո�ȴ��ό�����λ���b�䣡");
                 return;
      elseif (targetType>=65 and targetType<=70) then
                 NLG.SystemMessage(player, "[ϵ�y]�������o���M�Ї����Ĥ��");
                 return;
      end
      if (seqno == 1 and select == CONST.��ť_ȷ�� and spraySkin>0)  then
                 local msg = "\\n@c���b�䇊���Ĥ��" ..	"\\n\\n\\n���b���ѽ��M���^�����Ĥ\\n\\n\\n�x���ǡ��_�����µć��Ḳ�w�Ĥ\\n\\n";
                 NLG.ShowWindowTalked(player, self.paintingNPC, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 11, msg);
      elseif (seqno == 1 and select == CONST.��ť_ȷ��)  then
                 EquipType = ChooseType(sprayType,targetType);
                 local msg = "2\\n@c���b�䇊���Ĥ��\\n���Q��������D�����b����͡�\\n";
                 for i=1,#EquipType do
                                  msg = msg .. EquipType[i][1].."\\n"
                 end
                 NLG.ShowWindowTalked(player, self.paintingNPC, CONST.����_ѡ���, CONST.BUTTON_�ر�, 12, msg);
      elseif (seqno == 11 and select == CONST.��ť_��)  then
                 EquipType = ChooseType(sprayType,targetType);
                 local msg = "2\\n@c���b�䇊���Ĥ��\\n���Q��������D�����b����͡�\\n";
                 for i=1,#EquipType do
                                  msg = msg .. EquipType[i][1].."\\n"
                 end
                 NLG.ShowWindowTalked(player, self.paintingNPC, CONST.����_ѡ���, CONST.BUTTON_�ر�, 12, msg);
      else
                 return;
      end

    else
      --�������
      if (seqno == 12 and select == CONST.��ť_�ر�) then
                 return;
      elseif (seqno == 12 and data>0) then
          if (targetItemIndex ~=nil) then
                 Char.DelItem(player, ItemID, 1);
                 if EquipPlusStat(targetItemIndex)==nil then Item.SetData(targetItemIndex, CONST.����_��ǰ��, targetName); end
                 EquipPlusStat(targetItemIndex, "P", sprayImage);
                 Item.SetData(targetItemIndex,CONST.����_ͼ, sprayImage);
                 Item.SetData(targetItemIndex,CONST.����_����, EquipType[data][2]);
                 Item.UpItem(targetItemIndex, targetSlot);
                 NLG.SystemMessage(player, "[ϵ�y]Ոж�������b�䣡");
                 NLG.UpChar(player);
          end
      else
                 return;
      end
    end
  end)


end


function Module:sprayTools(charIndex,targetIndex,itemSlot)
    ItemID = Item.GetData(Char.GetItemIndex(charIndex,itemSlot),0);
    local ItemIndex = Char.GetItemIndex(charIndex,itemSlot);
    local sprayName = Item.GetData(ItemIndex, CONST.����_����);
    local sprayType = Item.GetData(ItemIndex, CONST.����_�Ӳ�һ);
    local sprayImage = Item.GetData(ItemIndex,CONST.����_�Ӳζ�);
    local targetSlot= sprayType;
    if (Char.GetItemIndex(charIndex,targetSlot)>0) then
             targetName = Item.GetData(Char.GetItemIndex(charIndex,targetSlot), CONST.����_����);
    else
             targetName = "��";
    end
    local msg = "\\n@c���b�䇊���Ĥ��" ..	"\\n\\n�����Ĥ����b����Ա���������������ش������ɵĸ��;Óp�ġ������ͬϵ����Ĥ�����b���@�����b�������|�ӳ�Ч����\\n��ע�⣺�Ĥ�ጢ�o���M���x�菊��"
                                                                           ..	"\\n\\n�_��ʹ�� "..sprayName.." ���ߣ��� "..targetName.." �b�����懊���Ĥ�᣿";
    NLG.ShowWindowTalked(charIndex, self.paintingNPC, CONST.����_��Ϣ��, CONST.��ť_ȷ���ر�, 1, msg);
    return 1;
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

---ItemDurabilityChangedEvent�Ļص�����
---[@group NL.RegItemDurabilityChangedEvent]
---@param itemIndex number ItemIndex
---@param oldDurability number ԭ�����;�
---@param newDurability number �仯����;�
---@param value number �仯ֵ
---@param mode number 0����ս����ģ�1-2�;ã���1���������-50%��ǰ�;ã���2���ش����-10%����;ã���3װ���ƻ�����
---@return number @�µ�mode������modeΪ1��2ʱ����0ȡ����Ӧ��ʾ
function OnItemDurabilityChangedEventCallback(itemIndex, oldDurability, newDurability, value, mode)
    local itemName = Item.GetData(itemIndex, CONST.����_����);
    local spraySkin = tonumber(EquipPlusStat(targetItemIndex, "P")) or 0;
    local player = Item.GetOwner(itemIndex)
    if mode== 1 or mode==2 then
          table.forEach(sprayList, function(e)
                    if (spraySkin==e) then
                              NLG.Say(player, -1, ""..Char.GetData(player,CONST.����_����).." �� ".. itemName .." ���T���ܵ����Ᵽ�o��",CONST.��ɫ_��ɫ, CONST.����_��);
                              return 0;
                    end
          end)
    end
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
