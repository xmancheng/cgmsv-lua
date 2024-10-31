local Module = ModuleBase:createModule('petCage')

function Module:onLoad()
  self:logInfo('load');
  --ͨ���ٻ�����
  self:regCallback('ItemString', Func.bind(self.monCage, self),"LUA_usePetCage");
  self.monCageNPC = self:NPC_createNormal('ħ��s��', 14682, { x = 41, y = 33, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.monCageNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local msg = "\\n@c��ħ��s�䡿" ..	"\\n\\n\\n�_��Ҫ�ų������ӃȵČ��";	
        NLG.ShowWindowTalked(player, self.monCageNPC, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 1, msg);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(self.monCageNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    local CageIndex = CageIndex;
    local CageSlot = CageSlot;
    local CageName = Item.GetData(CageIndex, CONST.����_����);
    local enemyId = Item.GetData(CageIndex,CONST.����_�Ӳ�һ);
    --local enemyLevel = Item.GetData(CageIndex,CONST.����_�Ӳζ�);
    local itemDur = Item.GetData(CageIndex,CONST.����_�;�);
    if select > 0 then
      if seqno == 2 and Char.PetNum(player)==5 and select == CONST.��ť_�� then
                 NLG.SystemMessage(player,"[ϵ�y]�����λ���ѝM��");
                 return;
      elseif seqno == 2 and select == CONST.��ť_�� then
                 return;
      elseif seqno == 2 and select == CONST.��ť_�� then
          if (enemyId ~=nil and enemyId>0) then
              if (itemDur==1) then
                  Char.DelItemBySlot(player, CageSlot);
              elseif (itemDur>1) then
                  Item.SetData(CageIndex,CONST.����_�;�, itemDur-1);
                  Item.UpItem(player, CageSlot);
                  NLG.UpChar(player);
              end
              --��������λ��
              local EmptySlot = Char.GetPetEmptySlot(player);
              Char.AddPet(player,enemyId);
              local PetIndex = Char.GetPet(player, EmptySlot);
              local arr_rank1_new = Pet.SetArtRank(PetIndex,CONST.�赵_���, Pet.FullArtRank(PetIndex,CONST.�赵_���) - 4);
              local arr_rank2_new = Pet.SetArtRank(PetIndex,CONST.�赵_����, Pet.FullArtRank(PetIndex,CONST.�赵_����) - 4);
              local arr_rank3_new = Pet.SetArtRank(PetIndex,CONST.�赵_ǿ��, Pet.FullArtRank(PetIndex,CONST.�赵_ǿ��) - 4);
              local arr_rank4_new = Pet.SetArtRank(PetIndex,CONST.�赵_����, Pet.FullArtRank(PetIndex,CONST.�赵_����) - 4);
              local arr_rank5_new = Pet.SetArtRank(PetIndex,CONST.�赵_ħ��, Pet.FullArtRank(PetIndex,CONST.�赵_ħ��) - 4);
              Pet.UpPet(player,PetIndex);
              NLG.SystemMessage(player, "[ϵͳ]�����ӳ���Č���ǳ�̓����")
          else
              NLG.SystemMessage(player,"[ϵ�y]�����e�`��");
              return;
          end
      else
                 return;
      end
    else
      if seqno == 1 and select == CONST.��ť_�ر� then
                 return;
      elseif (seqno == 1 or seqno == 2) and data>=1 then
          local PetSlot = data-1;
          local PetIndex = Char.GetPet(player, PetSlot);
          if (PetIndex>0) then
              local PetId = Char.GetData(PetIndex,CONST.����_PETID);
              local PetLevel = Char.GetData(PetIndex,CONST.����_�ȼ�);
              local PetName = Char.GetData(PetIndex,CONST.����_ԭ��);
              if (PetLevel==1) then
                  if (seqno == 1) then
                      Item.SetData(CageIndex,CONST.����_����, "[" .. PetName .. "]" .. CageName);
                      Item.SetData(CageIndex,CONST.����_�Ӳ�һ, PetId);
                      Item.SetData(CageIndex,CONST.����_�;�, 1);
                      Item.SetData(CageIndex,CONST.����_����;�, 1);
                      Char.DelSlotPet(player, PetSlot);
                      Item.UpItem(player, CageSlot);
                      NLG.UpChar(player);
                  elseif (seqno == 2 and PetId==enemyId) then
                      local itemDur_Max = Item.GetData(CageIndex,CONST.����_����;�);
                      Item.SetData(CageIndex,CONST.����_�;�, itemDur+1);
                      if (itemDur==itemDur_Max) then Item.SetData(CageIndex,CONST.����_����;�, itemDur_Max+1); end
                      Char.DelSlotPet(player, PetSlot);
                      Item.UpItem(player, CageSlot);
                      NLG.UpChar(player);
                  elseif (seqno == 2 and PetId~=enemyId) then
                      NLG.SystemMessage(player,"[ϵ�y]��ͬ����o������ͬ�����Ӄȡ�");
                      return;
                  end
              else
                 NLG.SystemMessage(player,"[ϵ�y]��Lv1�o���������Ӄȡ�");
                 return;
              end
          else
                 return;
          end
      end
    end
  end)


end


function Module:monCage(charIndex,targetIndex,itemSlot)
    ItemID = Item.GetData(Char.GetItemIndex(charIndex,itemSlot),0);
    CageSlot =itemSlot;
    CageIndex = Char.GetItemIndex(charIndex,itemSlot);
    local enemyId = Item.GetData(CageIndex,CONST.����_�Ӳ�һ);
    if (enemyId==0) then
          local msg = "4|\\n������������������ħ��s�䡿\\n"
                              .. "�@������߀��ȫ�µģ����Է�������Lv1���\\n"
                              .. "��ע��:  �I����Č����׃-20�nร�\\n\\n"
          for i=0,4 do
                local pet = Char.GetPet(charIndex,i);
                if(pet<0)then
                      msg = msg .. "��\\n";
                else
                      msg = msg .. ""..Char.GetData(pet,CONST.CHAR_����).."\\n";
                end
          end
          NLG.ShowWindowTalked(charIndex, self.monCageNPC, CONST.����_ѡ���, CONST.��ť_�ر�, 1, msg);
          return
    elseif (enemyId>0) then
          local EnemyBaseId = Data.GetEnemyBaseIdByEnemyId(enemyId);
          local EnemyBaseDataIndex = Data.EnemyBaseGetDataIndex(EnemyBaseId);
          local EnemyName = Data.EnemyBaseGetData(EnemyBaseDataIndex, CONST.EnemyBase_����);
          local msg = "4|\\n������������������ħ��s�䡿\\n"
                              .. "�x�� ��".. EnemyName .."Lv1�� �ٷ���ͬ�������С�\\n"
                              .. "�򰴡��ǡ��I����-20�n�� ".. EnemyName .."��\\n\\n"
          for i=0,4 do
                local pet = Char.GetPet(charIndex,i);
                if(pet<0)then
                      msg = msg .. "��\\n";
                else
                      msg = msg .. ""..Char.GetData(pet,CONST.CHAR_����).."\\n";
                end
          end
          NLG.ShowWindowTalked(charIndex, self.monCageNPC, CONST.����_ѡ���, CONST.��ť_�Ƿ�, 2, msg);
          return
    else
        return 1;
    end

end

Char.GetPetEmptySlot = function(charIndex)
  for Slot=0,4 do
      local PetIndex = Char.GetPet(charIndex, Slot);
      --print(PetIndex);
      if (PetIndex < 0) then
          return Slot;
      end
  end
  return -1;
end

function Module:onUnload()
  self:logInfo('unload')
end

return Module;
