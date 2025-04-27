---ģ����
local Module = ModuleBase:createModule('appraisalGlass')

local specialEffects = {
  {4,20,35,1640736},	--ӛ�d�����ܷ�����͵�u�ĵ�
  {4,55,35,1020716},	--�b���Ͼ͕��������ߵı��o�������p���u��ħ��
  --{12,50,0,3012354},	--����ֵ׃��50���Ġ�B
  --{13,0,0,3012354},	--͵ȡ������Ʒ�r��ͬ�r�ܽo�蔳�˂�����
  --{13,1,0,3004870},	--ʹ���o�l���ܕr�ܰl�ӷ���
  --{13,3,0,3004873},	--ʹ�����Rֹˮ���ܕr�S�C�رܔ��˵Ĺ���
  {2,62,50,1645959},	--��ʹ���ܡ������aѪ����ħ�p��
  {2,23,50,1645960},	--��ʹ���ܡ������Eʯ����ħ�p��
  {2,24,50,1645961},	--��ʹ���ܡ�������������ħ�p��
  {2,25,50,1645962},	--��ʹ���ܡ��������桯��ħ�p��
  {2,26,50,1645963},	--��ʹ���ܡ������L�С���ħ�p��
  {2,61,50,1645972},	--��ʹ���ܡ��aѪħ������ħ�p��
  {2,40,50,1645973},	--��ʹ���ܡ�����ʯ������ħ�p��
  {2,39,50,1645974},	--��ʹ���ܡ�������˯����ħ�p��
  {2,42,50,1645975},	--��ʹ���ܡ�������y����ħ�p��
  {2,43,50,1645976},	--��ʹ���ܡ������z������ħ�p��
  {2,44,50,1645977},	--��ʹ���ܡ������ж�����ħ�p��
  {2,41,50,1645978},	--��ʹ���ܡ�����������ħ�p��
  {6,8,0,1645919},	--����׃���ɽ���ϵ
  {6,7,0,1645918},	--����׃��������ϵ
  {6,6,0,1645917},	--����׃����Ұ�Fϵ
  {6,5,0,1645916},	--����׃����ֲ��ϵ
  {6,4,0,1645915},	--����׃�������xϵ
  {6,3,0,1645914},	--����׃�����w��ϵ
  {6,2,0,1645913},	--����׃���ɲ���ϵ
  {6,1,0,1645912},	--����׃������ϵ
}

local enemyPetId = {
  404001,404002,404003,404004,404005,404006,404007,404008,404009,404010,
  404011,404012,404013,404014,404015,404016,404017,404018,404019,404020,
  404021,404022,404023,404024,404025,
}
------------------------------------------------
--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  --�a��������
  self:regCallback('ItemString', Func.bind(self.actifyGlass, self),"LUA_useActiGlas");
  AppraisalGlassNPC = self:NPC_createNormal('�a���R', 14682, { x = 38, y = 33, mapType = 0, map = 777, direction = 6 });
  Char.SetData(AppraisalGlassNPC,CONST.����_ENEMY_PetFlg+2,0)--�ɴ�͸��
  self:NPC_regTalkedEvent(AppraisalGlassNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local GoalIndex,GoalSlot = Char.GetUnidentifiedSlot(player);
        if (GoalIndex>0) then
          local GoalName = Item.GetData(GoalIndex,CONST.����_����);
                local msg = "\\n\\n@c��ϵ�y֪ͨ��"
                  .."\\n\\n"
                  .."\\n�Ԅ��Ҍ�δ�a����Ʒ...\\n"
                  .."\\n�_��Ҫ�a�� $5"..GoalName.." $0��\\n";
          NLG.ShowWindowTalked(player, AppraisalGlassNPC, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 1, msg);
        else
                local msg = "\\n\\n@c��ϵ�y֪ͨ��"
                  .."\\n\\n"
                  .."\\n�Ԅ��Ҍ�δ�a����Ʒ...\\n"
                  .."\\n��Ʒ���Л]����Ҫ�a���ĵ��ߡ�\\n";
          NLG.ShowWindowTalked(player, AppraisalGlassNPC, CONST.����_��Ϣ��, CONST.��ť_�ر�, 1, msg);
        end
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(AppraisalGlassNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    local GlassIndex = GlassIndex;
    local GlassSlot = GlassSlot;
    local GoalIndex,GoalSlot = Char.GetUnidentifiedSlot(player);
    if select > 0 then
      if seqno == 1 and select == CONST.��ť_�ر� then
          return;
      elseif seqno == 1 and select == CONST.��ť_�� then
          return;
      elseif seqno == 1 and select == CONST.��ť_�� then
        if (GoalIndex>0) then
          local Special = Item.GetData(GoalIndex,CONST.����_��������);
          local Para1 = Item.GetData(GoalIndex,CONST.����_�Ӳ�һ);
          local Para2 = Item.GetData(GoalIndex,CONST.����_�Ӳζ�);
          if (Special==0 and Item.GetData(GoalIndex, CONST.����_����)==62) then
              local rand = NLG.Rand(1,#specialEffects);
              Item.SetData(GoalIndex,CONST.����_��������, specialEffects[rand][1]);
              Item.SetData(GoalIndex,CONST.����_�Ӳ�һ, specialEffects[rand][2]);
              Item.SetData(GoalIndex,CONST.����_�Ӳζ�, specialEffects[rand][3]);
              Item.SetData(GoalIndex,CONST.����_Explanation1,specialEffects[rand][4]);
              Item.SetData(GoalIndex,CONST.����_����, 66);
              Item.SetData(GoalIndex,CONST.����_�Ѽ���,1);
              Item.UpItem(player, GoalSlot);
              NLG.UpChar(player);
              Char.DelItem(player, 75031, 1);
              NLG.SystemMessage(player,"[ϵͳ]"..Item.GetData(GoalIndex,CONST.����_��ǰ��).."�a���ɹ� "..Item.GetData(GoalIndex,CONST.����_����).."��");
          elseif (Item.GetData(GoalIndex, CONST.����_����)==63) then
              local rand = NLG.Rand(1,#enemyPetId);
              local EnemyDataIndex = Data.EnemyGetDataIndex(enemyPetId[rand]);
              local enemyBaseId = Data.EnemyGetData(EnemyDataIndex, CONST.Enemy_Base���);
              local EnemyBaseDataIndex = Data.EnemyBaseGetDataIndex(enemyBaseId);
              local Enemy_name = Data.EnemyBaseGetData(EnemyBaseDataIndex, CONST.EnemyBase_����);
              Item.SetData(GoalIndex,CONST.����_����,"["..Enemy_name.."]��ӡ����");
              Item.SetData(GoalIndex,CONST.����_����, enemyPetId[rand]);
              Item.SetData(GoalIndex,CONST.����_�Ѽ���,1);
              Item.UpItem(player, GoalSlot);
              NLG.UpChar(player);
              Char.DelItem(player, 75031, 1);
              NLG.SystemMessage(player,"[ϵͳ]�a���ɹ� "..Item.GetData(GoalIndex,CONST.����_����).."��");
          else
              Item.SetData(GoalIndex,CONST.����_�Ѽ���,1);
              Item.UpItem(player, GoalSlot);
              NLG.UpChar(player);
              Char.DelItem(player, 75031, 1);
              NLG.SystemMessage(player,"[ϵͳ]"..Item.GetData(GoalIndex,CONST.����_��ǰ��).."�a���ɹ� "..Item.GetData(GoalIndex,CONST.����_����).."��");
          end
        else
            return;
        end
      else
          return;
      end
    end
  end)


  --����Ч��
  AdditionalEffectsNPC = self:NPC_createNormal('�a��Ч���D��', 14602, { x = 246, y = 76, mapType = 0, map = 1000, direction = 6 });
  Char.SetData(AdditionalEffectsNPC,CONST.����_ENEMY_PetFlg+2,0)--�ɴ�͸��
  self:NPC_regTalkedEvent(AdditionalEffectsNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local ItemIndex = Char.GetItemIndex(player, CONST.EQUIP_����2);
        if (ItemIndex < 0) then
            NLG.SystemMessage(player,"[ϵ�y]�Ʒ2λ�Û]���κε��ߡ�");
            return;
        elseif (ItemIndex >= 0) then
            local CarrierIndex,CarrierSlot = Char.GetIdentifiedSlot(player);
            if (CarrierIndex>0 and Item.GetData(ItemIndex, CONST.����_����)==62) then
                local CarrierName = Data.GetMessage(Item.GetData(CarrierIndex,CONST.����_Explanation1));
                local msg = "\\n\\n@c��ϵ�y֪ͨ��"
                    .."\\n\\n"
                    .."\\n�_��Ҫ�D�� $5"..CarrierName.."\\n"
                    .."\\n���w��Ӱ�Rԭ�е�����Ч���᣿\\n";
                NLG.ShowWindowTalked(player, AdditionalEffectsNPC, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 1, msg);
            elseif (CarrierIndex>0 and Item.GetData(ItemIndex, CONST.����_����)~=62) then
                NLG.SystemMessage(player,"[ϵ�y]�Ʒ2��b����Ӱ�R��");
                return;
            elseif (CarrierIndex<0) then
                local msg = "\\n\\n@c��ϵ�y֪ͨ��"
                    .."\\n\\n"
                    .."\\n�Ԅ��Ҍ��ѽ��a������Ʒ...\\n"
                    .."\\n$4����Ʒ���Л]������Ч���ĵ��ߡ�\\n";
                NLG.ShowWindowTalked(player, AdditionalEffectsNPC, CONST.����_��Ϣ��, CONST.��ť_�ر�, 1, msg);
            end
        end
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(AdditionalEffectsNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    local ItemIndex = Char.GetItemIndex(player, CONST.EQUIP_����2);
    local CarrierIndex,CarrierSlot = Char.GetIdentifiedSlot(player);
    if select > 0 then
      if seqno == 1 and select == CONST.��ť_�ر� then
          return;
      elseif seqno == 1 and select == CONST.��ť_�� then
          return;
      elseif seqno == 1 and select == CONST.��ť_�� then
        if (ItemIndex>0 and CarrierIndex>0) then
          local Special = Item.GetData(CarrierIndex,CONST.����_��������);
          local Para1 = Item.GetData(CarrierIndex,CONST.����_�Ӳ�һ);
          local Para2 = Item.GetData(CarrierIndex,CONST.����_�Ӳζ�);
          local info = Item.GetData(CarrierIndex,CONST.����_Explanation1);

          Item.SetData(ItemIndex,CONST.����_��������, Special);
          Item.SetData(ItemIndex,CONST.����_�Ӳ�һ, Para1);
          Item.SetData(ItemIndex,CONST.����_�Ӳζ�, Para2);
          Item.SetData(ItemIndex,CONST.����_Explanation1, info);
          Item.UpItem(player, CONST.EQUIP_����2);
          Char.DelItemBySlot(player, CarrierSlot);
          NLG.UpChar(player);
          NLG.SystemMessage(player,"[ϵͳ]����Ч���D�Ƴɹ���");
        else
            return;
        end
      else
          return;
      end
    end
  end)

end
------------------------------------------------
----
function Module:actifyGlass(charIndex,targetIndex,itemSlot)
    GlassItemID = Item.GetData(Char.GetItemIndex(charIndex,itemSlot),0);
    GlassSlot =itemSlot;
    GlassIndex = Char.GetItemIndex(charIndex,itemSlot);
    local GoalIndex,GoalSlot = Char.GetUnidentifiedSlot(charIndex);
    if (GoalIndex>0) then
      local GoalName = Item.GetData(GoalIndex,CONST.����_����);
            local msg = "\\n\\n@c��ϵ�y֪ͨ��"
              .."\\n\\n"
              .."\\n�Ԅ��Ҍ�δ�a����Ʒ...\\n"
              .."\\n�_��Ҫ�a�� $5"..GoalName.." $0��\\n";
      NLG.ShowWindowTalked(charIndex, AppraisalGlassNPC, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 1, msg);
    else
            local msg = "\\n\\n@c��ϵ�y֪ͨ��"
              .."\\n\\n"
              .."\\n�Ԅ��Ҍ�δ�a����Ʒ...\\n"
              .."\\n��Ʒ���Л]����Ҫ�a���ĵ��ߡ�\\n";
      NLG.ShowWindowTalked(charIndex, AppraisalGlassNPC, CONST.����_��Ϣ��, CONST.��ť_�ر�, 1, msg);
    end
    return 1;
end

Char.GetUnidentifiedSlot = function(charIndex)
  for Slot=7,27 do
      local ItemIndex = Char.GetItemIndex(charIndex, Slot);
      --print(ItemIndex);
      if (ItemIndex > 0 and Item.GetData(ItemIndex,CONST.����_�Ѽ���)==0) then
        local ItemId = Item.GetData(ItemIndex,CONST.����_ID);
        return ItemIndex,Slot;
      end
  end
  return -1,-1;
end

Char.GetIdentifiedSlot = function(charIndex)
  for Slot=7,27 do
      local ItemIndex = Char.GetItemIndex(charIndex, Slot);
      --print(ItemIndex);
      if (ItemIndex > 0 and Item.GetData(ItemIndex,CONST.����_����)==66) then
        local ItemId = Item.GetData(ItemIndex,CONST.����_ID);
        return ItemIndex,Slot;
      end
  end
  return -1,-1;
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;