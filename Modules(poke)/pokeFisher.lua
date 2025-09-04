---ģ����
local Module = ModuleBase:createModule('pokeFisher')

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('LoginEvent', Func.bind(self.onLoginEvent, self));
  self:regCallback('LogoutEvent', Func.bind(self.onLogoutEvent, self));
  self:regCallback('LoopEvent', Func.bind(self.fishloop,self))
  self:regCallback('fishloop', function(player)
    local ItemID = Char.GetTempData(player, '����һ�') or 0;
    if (ItemID >0) then
      local floor = Char.GetData(player,CONST.����_��ͼ);
      if (floor~=80024) then
        Char.SetTempData(player, '����һ�', 0);
        Char.SetLoopEvent(nil,'fishloop',player,0);
        Char.UnsetLoopEvent(player);
        NLG.UpChar(player);
        NLG.SystemMessage(player,"[ϵ�y]��鲻��С�u����~��Cֹͣ��");
        return
      end

      local RodIndex = Char.HaveItem(player,ItemID);
      local RodStr = Item.GetData(RodIndex, CONST.����_�;�) or 0;
      if (RodStr >= 1) then
        Item.SetData(RodIndex, CONST.����_�;�, Item.GetData(RodIndex, CONST.����_�;�)-1);
        Item.UpItem(player, -1);

        local dropMenu = {70257,70257,70257,70257,70258,70258,70258,70259};
        local dropRate = {1,1,1,2,1,1,3,1,1,2};
        Char.GiveItem(player, dropMenu[NLG.Rand(1,8)], dropRate[NLG.Rand(1,10)]);
        NLG.SortItem(player);
        NLG.SystemMessage(player,"����1�c�;�ÿ10���M����~��ី�߀��"..(RodStr-1).."�c�;á�");
      else
        local dropMenu = {70257,70257,70257,70257,70258,70258,70258,70259};
        local dropRate = {1,1,1,2,1,1,3,1,1,2};
        Char.GiveItem(player, dropMenu[NLG.Rand(1,8)], dropRate[NLG.Rand(1,10)]);
        NLG.SortItem(player);
        NLG.SystemMessage(player,"ី����Ĵ��M����~�P�]��");
      end
    else
        Char.SetTempData(player, '����һ�', 0);
        Char.SetLoopEvent(nil,'fishloop',player,0);
        Char.UnsetLoopEvent(player);
        NLG.UpChar(player);
        return
    end
  end)

  self:regCallback("ItemString", Func.bind(self.Fishing, self), 'LUA_useFisher');
  self.fishingNPC = self:NPC_createNormal('��~��Cី�', 14682, { x = 41, y = 35, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.fishingNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
          local msg = "\\n@c����~��C��\\n\\n��ី��ѽ��]���;öȟo��ʹ���ˣ�";
          NLG.ShowWindowTalked(player, self.fishingNPC, CONST.����_��Ϣ��, CONST.��ť_�ر�, 2, msg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.fishingNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --print(data)
    local RodIndex = Char.GetItemIndex(player,RodSlot);
    local RodStr = Item.GetData(RodIndex, CONST.����_�;�) or 0;
    if select > 0 then
      if (seqno == 2 and select == CONST.��ť_�ر�) then
                 return;
      elseif (seqno == 1 and select == CONST.��ť_��) then
        local floor = Char.GetData(player,CONST.����_��ͼ);
        if (floor~=80024) then
          NLG.SystemMessage(player,"[ϵ�y]��~ֻ���ڌ��T��С�u���M�С�");
          return
        end
        local ItemID = Char.GetTempData(player, '����һ�') or 0;
        if (RodStr > 1 and ItemID==0) then
          local ItemID = Item.GetData(RodIndex, CONST.����_ID);
          Char.SetTempData(player, '����һ�', ItemID);
          Char.SetLoopEvent(nil,'fishloop',player,10000);
          NLG.SetAction(player, 11);
          NLG.UpChar(player);
        elseif (RodStr == 1 and ItemID==0) then
          local ItemID = Item.GetData(RodIndex, CONST.����_ID);
          Char.DelItemBySlot(player, RodSlot);
          Char.SetTempData(player, '����һ�', ItemID);
          Char.SetLoopEvent(nil,'fishloop',player,10000);
          NLG.SystemMessage(player,"��~����һ����Ч,Ո���r�a��ីͣ�");
        elseif (ItemID>0) then
          Char.SetTempData(player, '����һ�', 0);
          Char.SetLoopEvent(nil,'fishloop',player,0);
          Char.UnsetLoopEvent(player);
          NLG.UpChar(player);
          NLG.SystemMessage(player,"[ϵ�y]��~��Cֹͣ��");	
        end
      elseif (seqno == 1 and select == CONST.��ť_��) then
        Char.SetTempData(player, '����һ�', 0);
        Char.SetLoopEvent(nil,'fishloop',player,0);
        Char.UnsetLoopEvent(player);
        NLG.UpChar(player);
        NLG.SystemMessage(player,"[ϵ�y]��~��Cֹͣ��");	
      end
    else

    end
  end)


end

function Module:Fishing(charIndex,targetIndex,itemSlot)
    ItemID = Item.GetData(Char.GetItemIndex(charIndex,itemSlot),0);
    RodSlot = itemSlot;
    local RodIndex = Char.GetItemIndex(charIndex,RodSlot);
    local RodStr = Item.GetData(RodIndex, CONST.����_�;�) or 0;
    if RodStr>=0 then
          local msg = "\\n@c����~��C��\\n\\n�����ǡ�ʹ��ីͣ��M����~\\n\\n������ֹͣ�����M�е���~";
          NLG.ShowWindowTalked(charIndex, self.fishingNPC, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 1, msg);
    elseif RodStr==0 then
          local msg = "\\n@c����~��C��\\n\\n��ី��ѽ��]���;öȣ��o��ʹ���ˣ�";
          NLG.ShowWindowTalked(charIndex, self.fishingNPC, CONST.����_��Ϣ��, CONST.��ť_�ر�, 2, msg);
    end
    return 1;
end


function Module:onLoginEvent(charIndex)
	local fishingOn = Char.GetTempData(charIndex, '����һ�') or 0;
	if (fishingOn>0) then
		Char.SetTempData(charIndex, '����һ�', 0);
		Char.SetLoopEvent(nil,'fishloop',charIndex,0);
        Char.UnsetLoopEvent(charIndex);
		NLG.UpChar(charIndex);
		NLG.SystemMessage(charIndex,"[ϵ�y]��~��Cֹͣ��");	
	end
end
function Module:onLogoutEvent(charIndex)
	local fishingOn = Char.GetTempData(charIndex, '����һ�') or 0;
	if (fishingOn>0) then
		Char.SetTempData(charIndex, '����һ�', 0);
		Char.SetLoopEvent(nil,'fishloop',charIndex,0);
        Char.UnsetLoopEvent(charIndex);
		NLG.UpChar(charIndex);
		NLG.SystemMessage(charIndex,"[ϵ�y]��~��Cֹͣ��");	
	end
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
