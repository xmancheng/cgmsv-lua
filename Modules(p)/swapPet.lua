local Module = ModuleBase:createModule('swapPet')

local SwapNPC = {
    { Type=1, TeamStar={"天星隊皮拿", 231063, 20300,211,294}, NpcEnemy={"流氓熊貓",700065}, PlayerPet={"火焰雞",600029} },
    { Type=2, TeamStar={"天星隊梅洛可", 231069, 20300,417,347}, NpcEnemy={"波爾凱尼恩",700053}, PlayerPet={"咩利羊",700013}  },
    { Type=3, TeamStar={"天星隊秋明", 14569, 20300,385,200}, NpcEnemy={"蓋諾賽克特",700050}, PlayerPet={"胡地",700037}  },
    { Type=4, TeamStar={"天星隊奧爾迪加", 14581, 20300,261,28}, NpcEnemy={"瑪機雅娜",700067}, PlayerPet={"狩獵鳳蝶",700002}  },
    { Type=5, TeamStar={"天星隊枇琶", 14095, 20300,499,128}, NpcEnemy={"凱路迪歐",700064}, PlayerPet={"蚊香君",700019}  },
    { Type=6, TeamStar={"天星隊牡丹", 14093, 20300,294,398}, NpcEnemy={"雷吉奇卡斯",700049}, PlayerPet={"伊布",700027}  },
}
tbl_TeamStarNPCIndex = tbl_TeamStarNPCIndex or {}

function Module:onLoad()
  self:logInfo('load');
  --交换的训练家1
 for k,v in pairs(SwapNPC) do
 if tbl_TeamStarNPCIndex[k] == nil then
  local petSwapNPC = self:NPC_createNormal(v.TeamStar[1], v.TeamStar[2], { x = v.TeamStar[4], y = v.TeamStar[5], mapType = 0, map = v.TeamStar[3], direction = 0 });
  tbl_TeamStarNPCIndex[k] = petSwapNPC
  self:NPC_regTalkedEvent(tbl_TeamStarNPCIndex[k], function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local msg = "\\n\\n@c我好想要 "..v.PlayerPet[1].."，你如果有這隻寵物的話．．．\\n\\n確定要和我的 "..v.NpcEnemy[1].." 交換嗎？\\n\\n\\n\\n※注意！建議僅有1隻該寵物再進行交換";	
        NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.按钮_是否, 1, msg);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(tbl_TeamStarNPCIndex[k], function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    Field.Set(player, 'TeamStar', k);
    local Type = tonumber(Field.Get(player, 'TeamStar'));
    if (Type==v.Type) then
        --NPC的宠物
        local EnemyId = v.NpcEnemy[2];
        local EnemyBaseId = Data.GetEnemyBaseIdByEnemyId(EnemyId);
        local EnemyBaseDataIndex = Data.EnemyBaseGetDataIndex(EnemyBaseId);
        local EnemyName = Data.EnemyBaseGetData(EnemyBaseDataIndex, CONST.EnemyBase_名字);
        --local EnemyId = Data.EnemyBaseGetData(EnemyBaseDataIndex, CONST.EnemyBase_编号);
        --玩家有NPC要的目标宠物
        local PetSlot = Char.HavePet(player, v.PlayerPet[2]);
        local PetIndex = Char.GetPet(player, PetSlot);
        if select > 0 then
          if seqno == 1 and Char.ItemSlot(player)==20 and select == CONST.按钮_是 then
                NLG.SystemMessage(player,"[系統]物品欄位置已滿。");
                 return;
          elseif seqno == 1 and select == CONST.按钮_否 then
                 return;
          elseif seqno == 1 and select == CONST.按钮_是 then
              if (PetIndex>0) then
                  local PetId = Char.GetData(PetIndex,CONST.宠物_PETID);
                  local PetLevel = Char.GetData(PetIndex,CONST.对象_等级);
                  --道具栏空位置
                  local EmptySlot = Char.GetItemEmptySlot(player);
                  Char.GiveItem(player, 68019, 1);
                  local ItemIndex = Char.GetItemIndex(player, EmptySlot);
                  --local BallItemID = Item.GetData(ItemIndex,0);
                  Item.SetData(ItemIndex,CONST.道具_名字, EnemyName.."精靈球");
                  Item.SetData(ItemIndex,CONST.道具_子参一, EnemyId);
                  Item.SetData(ItemIndex,CONST.道具_子参二, PetLevel);
                  Char.DelPet(player, PetId, PetLevel, 1);
                  Item.UpItem(player, EmptySlot);
                  NLG.UpChar(player);
              else
                 NLG.SystemMessage(player, v.TeamStar[1]..":你沒有我要的寵物，我不要跟你交換。");
                 return;
              end
          else
                 return;
          end
        end
    end
  end)
 end
 end


  --通用宠物召唤道具
  self:regCallback('ItemString', Func.bind(self.swapSummon, self),"LUA_useSwapPet");
  self.petSummonNPC = self:NPC_createNormal('寵物球呼喚', 14682, { x = 40, y = 33, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.petSummonNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local msg = "\\n@c【寵物呼喚】" ..	"\\n\\n\\n確定要放出來精靈球內的寵物？";	
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
    local last = string.find(BallName, "精", 1);
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
    local msg = "\\n@c【寵物呼喚】" ..	"\\n\\n\\n確定要放出來精靈球內的寵物？";	
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

Char.GetItemEmptySlot = function(charIndex)
  for Slot=7,27 do
      local ItemIndex = Char.GetItemIndex(charIndex, Slot);
      --print(ItemIndex);
      if (ItemIndex < 0) then
          return Slot;
      end
  end
  return -1;
end

function Module:onUnload()
  self:logInfo('unload')
end

return Module;
