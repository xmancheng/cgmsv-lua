local Module = ModuleBase:createModule('swapPet')

function Module:onLoad()
  self:logInfo('load');
  --通用宠物召唤道具
  self:regCallback('ItemString', Func.bind(self.swapSummon, self),"LUA_useSwapPet");
  self.petSummonNPC = self:NPC_createNormal('召喚球呼喚', 14682, { x = 40, y = 33, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.petSummonNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local msg = "\\n@c【寵物呼喚】" ..	"\\n\\n\\n確定要放出來召喚球內的寵物？";	
        NLG.ShowWindowTalked(player, self.petSummonNPC, CONST.窗口_信息框, CONST.按钮_是否, 1, msg);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(self.petSummonNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    local BallIndex =BallIndex;
    local BallSlot = BallSlot;
    local BallName = Item.GetData(BallIndex, CONST.道具_名字);
    local last = string.find(BallName, "召", 1);
    local enemyName =string.sub(BallName, 1, last-1);
    local enemyId = Item.GetData(BallIndex,CONST.道具_子参一);
    local enemyLevel = Item.GetData(BallIndex,CONST.道具_子参二);
    if select > 0 then
      if seqno == 1 and Char.PetNum(player)==5 and select == CONST.按钮_是 then
                 NLG.SystemMessage(player,"[系統]寵物欄位置已滿。");
                 return;
      elseif seqno == 1 and select == CONST.按钮_否 then
                 return;
      elseif seqno == 1 and select == CONST.按钮_是 then
          if (enemyId ~=nil and enemyId>0) then
              --宠物栏空位置
              local EmptySlot = Char.GetPetEmptySlot(player);
              Char.AddPet(player,enemyId);
              local PetIndex = Char.GetPet(player, EmptySlot);
              local arr_rank1_new = Pet.GetArtRank(PetIndex,CONST.宠档_体成);
              local arr_rank2_new = Pet.GetArtRank(PetIndex,CONST.宠档_力成);
              local arr_rank3_new = Pet.GetArtRank(PetIndex,CONST.宠档_强成);
              local arr_rank4_new = Pet.GetArtRank(PetIndex,CONST.宠档_敏成);
              local arr_rank5_new = Pet.GetArtRank(PetIndex,CONST.宠档_魔成);
              if (enemyLevel~=1) then
                  Char.SetData(PetIndex,CONST.对象_升级点,enemyLevel-1);
                  Char.SetData(PetIndex,CONST.对象_等级,enemyLevel);
                  Char.SetData(PetIndex,CONST.对象_体力, (Char.GetData(PetIndex,CONST.对象_体力) + (arr_rank1_new * (1/24) * (enemyLevel - 1)*100)) );
                  Char.SetData(PetIndex,CONST.对象_力量, (Char.GetData(PetIndex,CONST.对象_力量) + (arr_rank2_new * (1/24) * (enemyLevel - 1)*100)) );
                  Char.SetData(PetIndex,CONST.对象_强度, (Char.GetData(PetIndex,CONST.对象_强度) + (arr_rank3_new * (1/24) * (enemyLevel - 1)*100)) );
                  Char.SetData(PetIndex,CONST.对象_速度, (Char.GetData(PetIndex,CONST.对象_速度) + (arr_rank4_new * (1/24) * (enemyLevel - 1)*100)) );
                  Char.SetData(PetIndex,CONST.对象_魔法, (Char.GetData(PetIndex,CONST.对象_魔法) + (arr_rank5_new * (1/24) * (enemyLevel - 1)*100)) );
              end
              Pet.UpPet(player,PetIndex);
              Char.DelItemBySlot(player, BallSlot);
              NLG.SystemMessage(player, "[系统]"..enemyName.."成功呼喚出來。")
          else
              NLG.SystemMessage(player,"[系統]道具錯誤。");
              return;
          end
      else
                 return;
      end
    end
  end)


end


function Module:swapSummon(charIndex,targetIndex,itemSlot)
    ItemID = Item.GetData(Char.GetItemIndex(charIndex,itemSlot),0);
    BallSlot =itemSlot;
    BallIndex = Char.GetItemIndex(charIndex,itemSlot);
    local msg = "\\n@c【寵物呼喚】" ..	"\\n\\n\\n確定要放出來召喚球內的寵物？";	
    NLG.ShowWindowTalked(charIndex, self.petSummonNPC, CONST.窗口_信息框, CONST.按钮_是否, 1, msg);
    return 1;
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

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
