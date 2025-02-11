local Module = ModuleBase:createModule('pokeVR')

local petMettleTable = {
          {9610,9619,9620,9629},       --对BOSS增,自BOSS减,对人形增,对邪魔增
          {9611,9615,9623,9624},       --对地增,自地减,对飞行增,对昆虫增
          {9612,9616,9627,9628},       --对水增,自水减,对特殊增,对金属增
          {9613,9617,9621,9626},       --对火增,自火减,对龙族增,对野兽增
          {9614,9618,9622,9625},       --对风增,自风减,对不死增,对植物增
}

local virtual_list ={
    71101,71102,71103,71104,71105,71106,71107,71108,71109,71110,
    71111,71112,71113,71114,71115,71116,71117,71118,71119,71120,
    71121,71122,71123,71124,71125,71126,71127,71128,71129,71130,
    71131,71132,71133,
}
local virtualMenu = {}
virtualMenu[71101] = {700101,30};
virtualMenu[71102] = {700102,30};
virtualMenu[71103] = {700103,30};
virtualMenu[71104] = {700104,30};
virtualMenu[71105] = {700105,30};
virtualMenu[71106] = {700106,30};
virtualMenu[71107] = {700107,30};
virtualMenu[71108] = {700108,30};
virtualMenu[71109] = {700109,30};
virtualMenu[71110] = {700110,30};
virtualMenu[71111] = {700111,30};
virtualMenu[71112] = {700112,30};
virtualMenu[71113] = {700113,50};
virtualMenu[71114] = {700114,50};
virtualMenu[71115] = {700115,50};
virtualMenu[71116] = {700116,50};
virtualMenu[71117] = {700117,50};
virtualMenu[71118] = {700118,50};
virtualMenu[71119] = {700119,50};
virtualMenu[71120] = {700120,50};
virtualMenu[71121] = {700121,50};
virtualMenu[71122] = {700122,80};
virtualMenu[71123] = {700123,80};
virtualMenu[71124] = {700124,80};
virtualMenu[71125] = {700125,80};
virtualMenu[71126] = {700126,80};
virtualMenu[71127] = {700127,80};
virtualMenu[71128] = {700128,80};
virtualMenu[71129] = {700129,80};
virtualMenu[71130] = {700130,80};
virtualMenu[71131] = {700131,80};
virtualMenu[71132] = {700132,80};
virtualMenu[71133] = {700133,80};

-------------------------------------------------------------------------------------------------------------------------------------
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load');
  --训练家
  pokeVRNPC = self:NPC_createNormal('夥伴實體化', 14602, { x = 80, y = 46, mapType = 0, map = 7351, direction = 6 });
  self:NPC_regTalkedEvent(pokeVRNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local GoalIndex,GoalSlot = Char.GetVRGoalSlot(player);
        if (GoalIndex>0) then
          local GoalName = Item.GetData(GoalIndex,CONST.道具_名字);
          local msg = "\\n\\n@c 確定要實體化 $5"..GoalName.." $0當作你的寵物嗎？\\n"
                   .. "\\n每次操作實體化裝置，需要支付寶可金幣5個。"
                   .. "\\n\\n\\n\\n$4※注意！優先從前面位置尋找可實體化道具";	
          NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.按钮_确定关闭, 1, msg);
        else
          local msg = "\\n\\n@c物品欄中沒有可以實體化的道具\\n"
                   .. "\\n每次操作實體化裝置，需要支付寶可金幣5個。"
                   .. "\\n\\n\\n\\n$4※注意！優先從前面位置尋找可實體化道具";	
          NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.按钮_关闭, 1, msg);
        end
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(pokeVRNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    local GoalIndex,GoalSlot = Char.GetVRGoalSlot(player);
    if (GoalIndex>0) then
        local ItemId = Item.GetData(GoalIndex,CONST.道具_ID);
        --NPC的宠物
        local EnemyId = virtualMenu[ItemId][1];
        local EnemyBaseId = Data.GetEnemyBaseIdByEnemyId(EnemyId);
        local EnemyBaseDataIndex = Data.EnemyBaseGetDataIndex(EnemyBaseId);
        local EnemyName = Data.EnemyBaseGetData(EnemyBaseDataIndex, CONST.EnemyBase_名字);
        --local EnemyId = Data.EnemyBaseGetData(EnemyBaseDataIndex, CONST.EnemyBase_编号);
        if select > 0 then
          if seqno == 1 and Char.ItemSlot(player)==20 and select == CONST.按钮_确定 then
                NLG.SystemMessage(player,"[系統]物品欄位置已滿。");
                 return;
          elseif seqno == 1 and select == CONST.按钮_关闭 then
                 return;
          elseif seqno == 1 and select == CONST.按钮_确定 then
              if (Char.ItemNum(player, 66668)<5) then
                 NLG.SystemMessage(player,"[系統]金幣數量不足，無法啟動裝置。");
                 return;
              end
              local PetLevel = virtualMenu[ItemId][2];
              --道具栏空位置
              local EmptySlot = Char.GetItemEmptySlot(player);
              Char.GiveItem(player, 71100, 1);
              local ItemIndex = Char.GetItemIndex(player, EmptySlot);
              Item.SetData(ItemIndex,CONST.道具_名字, EnemyName.."精靈球");
              Item.SetData(ItemIndex,CONST.道具_子参一, EnemyId);
              Item.SetData(ItemIndex,CONST.道具_子参二, PetLevel);
              Item.UpItem(player, EmptySlot);
              Char.DelItemBySlot(player, GoalSlot);
              Char.DelItem(player, 66668, 5);
              NLG.PlaySe(player, 279, Char.GetData(player,CONST.对象_X), Char.GetData(player,CONST.对象_Y));
              NLG.UpChar(player);
          else
              return;
          end
        end
    else
        if select > 0 then
          if select == CONST.按钮_关闭 then
            return;
          elseif seqno == 1 and select == CONST.按钮_确定 then
            NLG.SystemMessage(player,"[系統]沒有可以實體化的道具，請重新確認。");
          end
        end
    end
  end)


  --通用宠物召唤道具
  self:regCallback('ItemString', Func.bind(self.swapSummon, self),"LUA_usePokeVR");
  self.petSummonNPC = self:NPC_createNormal('寵物球呼喚', 14682, { x = 40, y = 32, mapType = 0, map = 777, direction = 6 });
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
              local typeRand = math.random(1,#petMettleTable);
              local pos = math.random(1,#petMettleTable[typeRand]);
              Pet.AddSkill(PetIndex, petMettleTable[typeRand][pos], 9);
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

----------------------------------------------------------------
Char.GetVRGoalSlot = function(charIndex)
  for Slot=7,27 do
      local ItemIndex = Char.GetItemIndex(charIndex, Slot);
      --print(ItemIndex);
      if (ItemIndex > 0) then
        local ItemId = Item.GetData(ItemIndex,CONST.道具_ID);
        if (CheckInTable(virtual_list, ItemId)==true) then
          return ItemIndex,Slot;
        end
      end
  end
  return -1,-1;
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


function CheckInTable(_idTab, _idVar) ---循环函数
	for k,v in pairs(_idTab) do
		if v==_idVar then
			return true
		end
	end
	return false
end

function Module:onUnload()
  self:logInfo('unload')
end

return Module;
