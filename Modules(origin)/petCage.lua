local Module = ModuleBase:createModule('petCage')

function Module:onLoad()
  self:logInfo('load');
  --通用召唤道具
  self:regCallback('ItemString', Func.bind(self.monCage, self),"LUA_usePetCage");
  self.monCageNPC = self:NPC_createNormal('魔物壓縮箱', 14682, { x = 41, y = 33, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.monCageNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local msg = "\\n@c【魔物壓縮箱】" ..	"\\n\\n\\n確定要放出來箱子內的寵物？";	
        NLG.ShowWindowTalked(player, self.monCageNPC, CONST.窗口_信息框, CONST.按钮_是否, 1, msg);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(self.monCageNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    local CageIndex = CageIndex;
    local CageSlot = CageSlot;
    local CageName = Item.GetData(CageIndex, CONST.道具_名字);
    local enemyId = Item.GetData(CageIndex,CONST.道具_子参一);
    --local enemyLevel = Item.GetData(CageIndex,CONST.道具_子参二);
    local itemDur = Item.GetData(CageIndex,CONST.道具_耐久);
    if select > 0 then
      if seqno == 2 and Char.PetNum(player)==5 and select == CONST.按钮_是 then
                 NLG.SystemMessage(player,"[系統]寵物欄位置已滿。");
                 return;
      elseif seqno == 2 and select == CONST.按钮_否 then
                 return;
      elseif seqno == 2 and select == CONST.按钮_是 then
          if (enemyId ~=nil and enemyId>0) then
              if (itemDur==1) then
                  Char.DelItemBySlot(player, CageSlot);
              elseif (itemDur>1) then
                  Item.SetData(CageIndex,CONST.道具_耐久, itemDur-1);
                  Item.UpItem(player, CageSlot);
                  NLG.UpChar(player);
              end
              --宠物栏空位置
              local EmptySlot = Char.GetPetEmptySlot(player);
              Char.AddPet(player,enemyId);
              local PetIndex = Char.GetPet(player, EmptySlot);
              local arr_rank1_new = Pet.SetArtRank(PetIndex,CONST.宠档_体成, Pet.FullArtRank(PetIndex,CONST.宠档_体成) - 4);
              local arr_rank2_new = Pet.SetArtRank(PetIndex,CONST.宠档_力成, Pet.FullArtRank(PetIndex,CONST.宠档_力成) - 4);
              local arr_rank3_new = Pet.SetArtRank(PetIndex,CONST.宠档_强成, Pet.FullArtRank(PetIndex,CONST.宠档_强成) - 4);
              local arr_rank4_new = Pet.SetArtRank(PetIndex,CONST.宠档_敏成, Pet.FullArtRank(PetIndex,CONST.宠档_敏成) - 4);
              local arr_rank5_new = Pet.SetArtRank(PetIndex,CONST.宠档_魔成, Pet.FullArtRank(PetIndex,CONST.宠档_魔成) - 4);
              Pet.UpPet(player,PetIndex);
              NLG.SystemMessage(player, "[系统]從箱子出來的寵物非常虛弱。")
          else
              NLG.SystemMessage(player,"[系統]道具錯誤。");
              return;
          end
      else
                 return;
      end
    else
      if seqno == 1 and select == CONST.按钮_关闭 then
                 return;
      elseif (seqno == 1 or seqno == 2) and data>=1 then
          local PetSlot = data-1;
          local PetIndex = Char.GetPet(player, PetSlot);
          if (PetIndex>0) then
              local PetId = Char.GetData(PetIndex,CONST.宠物_PETID);
              local PetLevel = Char.GetData(PetIndex,CONST.对象_等级);
              local PetName = Char.GetData(PetIndex,CONST.对象_原名);
              if (PetLevel==1) then
                  if (seqno == 1) then
                      Item.SetData(CageIndex,CONST.道具_名字, "[" .. PetName .. "]" .. CageName);
                      Item.SetData(CageIndex,CONST.道具_子参一, PetId);
                      Item.SetData(CageIndex,CONST.道具_耐久, 1);
                      Item.SetData(CageIndex,CONST.道具_最大耐久, 1);
                      Char.DelSlotPet(player, PetSlot);
                      Item.UpItem(player, CageSlot);
                      NLG.UpChar(player);
                  elseif (seqno == 2 and PetId==enemyId) then
                      local itemDur_Max = Item.GetData(CageIndex,CONST.道具_最大耐久);
                      Item.SetData(CageIndex,CONST.道具_耐久, itemDur+1);
                      if (itemDur==itemDur_Max) then Item.SetData(CageIndex,CONST.道具_最大耐久, itemDur_Max+1); end
                      Char.DelSlotPet(player, PetSlot);
                      Item.UpItem(player, CageSlot);
                      NLG.UpChar(player);
                  elseif (seqno == 2 and PetId~=enemyId) then
                      NLG.SystemMessage(player,"[系統]不同寵物無法存入同個箱子內。");
                      return;
                  end
              else
                 NLG.SystemMessage(player,"[系統]非Lv1無法存入箱子內。");
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
    local enemyId = Item.GetData(CageIndex,CONST.道具_子参一);
    if (enemyId==0) then
          local msg = "4|\\n　　　　　　　　【魔物壓縮箱】\\n"
                              .. "這個箱子還是全新的，可以放入所有Lv1寵物。\\n"
                              .. "但注意:  領出來的寵物會變-20檔喔！\\n\\n"
          for i=0,4 do
                local pet = Char.GetPet(charIndex,i);
                if(pet<0)then
                      msg = msg .. "空\\n";
                else
                      msg = msg .. ""..Char.GetData(pet,CONST.CHAR_名字).."\\n";
                end
          end
          NLG.ShowWindowTalked(charIndex, self.monCageNPC, CONST.窗口_选择框, CONST.按钮_关闭, 1, msg);
          return
    elseif (enemyId>0) then
          local EnemyBaseId = Data.GetEnemyBaseIdByEnemyId(enemyId);
          local EnemyBaseDataIndex = Data.EnemyBaseGetDataIndex(EnemyBaseId);
          local EnemyName = Data.EnemyBaseGetData(EnemyBaseDataIndex, CONST.EnemyBase_名字);
          local msg = "4|\\n　　　　　　　　【魔物壓縮箱】\\n"
                              .. "選擇 「".. EnemyName .."Lv1」 再放入同個箱子中。\\n"
                              .. "或按「是」領出來-20檔的 ".. EnemyName .."！\\n\\n"
          for i=0,4 do
                local pet = Char.GetPet(charIndex,i);
                if(pet<0)then
                      msg = msg .. "空\\n";
                else
                      msg = msg .. ""..Char.GetData(pet,CONST.CHAR_名字).."\\n";
                end
          end
          NLG.ShowWindowTalked(charIndex, self.monCageNPC, CONST.窗口_选择框, CONST.按钮_是否, 2, msg);
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
