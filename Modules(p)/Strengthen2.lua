---ģ����
local Module = ModuleBase:createModule('Strengthen2')

local cardList = {
  CONST.����_����,  CONST.����_����,  CONST.����_����,  CONST.����_����,  CONST.����_�ظ�,
  CONST.����_��ɱ,  CONST.����_����,  CONST.����_����,  CONST.����_����,
  CONST.����_����,  CONST.����_ħ��,
  CONST.����_����,  CONST.����_����,  CONST.����_����,
  CONST.����_����,  CONST.����_˯��,  CONST.����_ʯ��,  CONST.����_��,  CONST.����_�ҿ�,  CONST.����_����,
  CONST.����_ħ��,  CONST.����_ħ��,
}

local StrStrengMaxLv = 9;
local StrSuccRate = {70, 65, 50, 35, 27, 22, 16, 11, 7}                                                                  --����ɹ���
local StrBreakRate = {0, 0, 0, 0, 0, 8, 10, 12, 14}                                                                           --�����ƻ���
local StrRequireGold = {1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000}                 --��������ħ��

local ItemPosName = {"�^ ��", "�� ��", "�� ��", "�� ��", "�� ��", "�Ʒ1", "�Ʒ2", "ˮ ��"}
function PartName(CardPara1)
    local PartName={}
    if CardPara1==0 then            --ͷ
        PartName={"�^ ��"};
    elseif CardPara1==1 then    --��
        PartName={"�� ��"};
    elseif CardPara1==3 then    --��
        PartName={"������"};
    elseif CardPara1==4 then    --��
        PartName={"�� ��"};
    elseif CardPara1==5 then    --��
        PartName={"� Ʒ"};
    elseif CardPara1==6 then    --��
        PartName={"� Ʒ"};
    end
    return PartName;
end
--�����Ÿ��衿
local StrItemEnable = {}
StrItemEnable[51000] = 1    --�}��
StrItemEnable[51001] = 1
StrItemEnable[51002] = 1
StrItemEnable[51004] = 1    --�}��
StrItemEnable[51005] = 1
StrItemEnable[51006] = 1
StrItemEnable[51008] = 1    --���L
StrItemEnable[51009] = 1
StrItemEnable[51010] = 1
StrItemEnable[51012] = 1    --�횢
StrItemEnable[51013] = 1
StrItemEnable[51014] = 1
StrItemEnable[51016] = 1    --�횢
StrItemEnable[51017] = 1
StrItemEnable[51018] = 1
---------------------------------------------------------------------------------------------
--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self.enchanterNPC = self:NPC_createNormal('ħ���x����Sħ��', 104746, { x = 214, y = 82, mapType = 0, map = 1000, direction = 6 });
  self:NPC_regTalkedEvent(self.enchanterNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local winMsg = "1\\nՈ�x����Ҫħ���x����b�䣺\\n"
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
          if (targetItemIndex>0) then
                 tItemID = Item.GetData(targetItemIndex, CONST.����_ID);
                 tItemName = Item.GetData(targetItemIndex, CONST.����_����);
                 tStrLv = EquipPlusStat(targetItemIndex, "E") or 0;
                 tMaxLv = StrStrengMaxLv;
                 tNeedGold = StrRequireGold[tStrLv+1];
                 --print(targetItemIndex,tItemName)
                 if (StrItemEnable[tItemID]~=1) then
                        NLG.SystemMessage(player, "[" .. "����Ī" .. "] ���x����b��[" .. tItemName .. "]��[�����x��]��");
                        return;
                 end
                 if (tStrLv>=tMaxLv) then
                        NLG.SystemMessage(player, "[" .. "����Ī" .. "] ���x����b��[" .. tItemName .. "]���_��[�x��Max]��");
                        return;
                 else
                        local winMsg = "1\\nՈ�x��Ҫʹ�õ�ħ�����S(�x�������)��\\n";
                        for itemSlot = 8,16 do
                           CardIndex = Char.GetItemIndex(player,itemSlot);
                           if (CardIndex>0) then
                              CardID = Item.GetData(CardIndex,CONST.����_ID);
                              CardLv = Item.GetData(CardIndex,CONST.����_�ȼ�);
                              CardType = Item.GetData(CardIndex,CONST.����_����);
                              CardName = Item.GetData(CardIndex, CONST.����_����);
                              CardSpecial = Item.GetData(CardIndex, CONST.����_��������);   --ħ������41
                              CardPara1 = Item.GetData(CardIndex, CONST.����_�Ӳ�һ);         --װ����0~7
                              if (CardPara1==5 and targetSlot==6) then CardPara1=6; end
                              --[[if (CardSpecial==41) then
                                   last = string.find(CardName, "��", 1);
                                   CardName = string.sub(CardName, 1, last-1);
                              end]]
                              equipName = PartName(CardPara1);
                              if (tStrLv+1==CardLv and CardSpecial==41) then
                                   winMsg = winMsg .. "��".. itemSlot-7 .."��:��" .. CardName .. "��ħ���x��cost| " ..tNeedGold.. "G\\n"
                              elseif (CardSpecial==41) then
                                   winMsg = winMsg .. "��".. itemSlot-7 .."��:��" .. CardName .. "��" .. "ʹ����".. equipName[1] .."+"..CardLv.." [�x���]\\n"
                              else
                                   winMsg = winMsg .. "��".. itemSlot-7 .."��:  ��ħ�����S" .. "\\n"
                              end
                           else
                                   winMsg = winMsg .. "��".. itemSlot-7 .."��:  �o��Ʒ" .. "\\n"
                           end
                        end
                        NLG.ShowWindowTalked(player, self.enchanterNPC, CONST.����_ѡ���, CONST.BUTTON_�ر�, 12, winMsg);
                 end
          else
                 NLG.SystemMessage(player, "[" .. "����Ī" .. "] ���x��Ĳ�λ�o�b�䣡");
                 return;
          end
      elseif (seqno == 12 and data>0) then      --���и���
          if (tPlayerGold<tNeedGold) then
               NLG.SystemMessage(player, "[" .. "����Ī" .. "] �x����Ҫ" .. tNeedGold .. "G��������Ų��㣡");
               return;
          end
          if (targetItemIndex>0) then
              local itemSlot = data+7;
              CardIndex = Char.GetItemIndex(player,itemSlot);
              if (CardIndex>0) then
                 CardID = Item.GetData(CardIndex,CONST.����_ID);
                 CardLv = Item.GetData(CardIndex,CONST.����_�ȼ�);
                 CardDur = Item.GetData(CardIndex,CONST.����_�;�);
                 CardName = Item.GetData(CardIndex, CONST.����_����);
                 CardSpecial = Item.GetData(CardIndex, CONST.����_��������);   --ħ������41
                 CardPara1 = Item.GetData(CardIndex, CONST.����_�Ӳ�һ);         --װ����0~7
                 CardPara2 = Item.GetData(CardIndex, CONST.����_�Ӳζ�);         --�˾���ʹ�ô���
                 local cardData= self:extractItemData(CardIndex);
                 if (CardPara1==5 and targetSlot==6) then CardPara1=6; end
                 if (tStrLv+1==CardLv and CardSpecial==41) then
                     Char.SetData(player, CONST.����_���, tPlayerGold-tNeedGold);
                     local SuccRate = StrSuccRate[tStrLv+1];
                     if (type(SuccRate)=="number" and SuccRate>0) then
                            local tMin = 50 - math.floor(SuccRate/2) + 1;
                            local tMax = 50 + math.floor(SuccRate/2) + math.fmod(SuccRate,2);
                            local tLuck = math.random(1, 100);
                            if (tLuck<tMin or tLuck>tMax)  then
                                    --+6�����ƻ�
                                    if (tStrLv+1>=6) then
                                        local BreakRate = StrBreakRate[tStrLv+1]
                                        if (type(BreakRate)=="number" and BreakRate>0) then
                                            local tMin = 50 - math.floor(BreakRate/2) + 1;
                                            local tMax = 50 + math.floor(BreakRate/2) + math.fmod(BreakRate,2);
                                            local tLuck = math.random(1, 100);
                                            if (tLuck>=tMin and tLuck<=tMax and Char.ItemNum(player, 71041)==0) then
                                                Char.DelItem(player, CardID, 1);
                                                Item.Kill(player, targetItemIndex, targetSlot);
                                                NLG.SystemMessage(player, "[" .. "����Ī" .. "] �b��ħ���x���ʧ���������Óp������");
                                                return;
                                            elseif (tLuck>=tMin and tLuck<=tMax and Char.ItemNum(player, 71041)>=1) then
                                                Char.DelItem(player, CardID, 1);
                                                Char.DelItem(player, 71041, 1);
                                                NLG.SystemMessage(player, "[" .. "����Ī" .. "] �b��ħ���x���ʧ���������U�з���ʯ����");
                                                return;
                                            end
                                        end
                                    end
                                    Char.DelItem(player, CardID, 1);
                                    NLG.SystemMessage(player, "[" .. "����Ī" .. "] �b��ħ���x��ʧ������");
                                    return;
                            end
                            Char.DelItem(player, CardID, 1);
                            if EquipPlusStat(targetItemIndex)==nil then Item.SetData(targetItemIndex, CONST.����_��ǰ��, tItemName); end
                            EquipPlusStat(targetItemIndex, "E", tStrLv+1);
                            setItemName(targetItemIndex);
                            --Item.SetData(targetItemIndex,CONST.����_����, 600);
                            setItemEnchData(targetItemIndex,cardData);
                            Item.UpItem(player, targetSlot);
                            NLG.UpChar(player);
                            NLG.SystemMessage(player, "[" .. "����Ī" .. "] ��ϲ�㣡ħ���x��ɹ���+" .. tStrLv+1 .. "��");
                            if (tStrLv+1>=7) then
                                      NLG.SystemMessage(-1, "[" .. "����Ī" .. "] ��ϲ "..Char.GetData(player, CONST.����_����).."���� "..Item.GetData(targetItemIndex, CONST.����_��ǰ��).." ħ���x��ɹ���+" .. tStrLv+1 .. "��");
                            end
                     end
                 else
                     NLG.SystemMessage(player, "[" .. "����Ī" .. "] �oЧ���x��");
                     return;
                 end
              else
                     return;     --����Ʒ
              end
          else
                 return;
          end
      else
                 return;         --�޲���
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

function Module:extractItemData(CardIndex)
	local item = {
		attr={},
	};
	for _, v in pairs(cardList) do
		item.attr[tostring(v)] = Item.GetData(CardIndex, v);
	end
	return item;
end

function setItemEnchData(targetItemIndex,cardData)
	for key, v in pairs(cardList) do
		local ability = Item.GetData(targetItemIndex, v);
		if cardData.attr[tostring(v)] ~=nil  then
			Item.SetData(targetItemIndex, v, ability+cardData.attr[tostring(v)]);
		end
	end
end
--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
