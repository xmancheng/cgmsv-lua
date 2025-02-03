local Module = ModuleBase:createModule('pokeVR')

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
virtualMenu[71113] = {700113,30};
virtualMenu[71114] = {700114,30};
virtualMenu[71115] = {700115,30};
virtualMenu[71116] = {700116,30};
virtualMenu[71117] = {700117,30};
virtualMenu[71118] = {700118,30};
virtualMenu[71119] = {700119,30};
virtualMenu[71120] = {700120,30};
virtualMenu[71121] = {700121,30};
virtualMenu[71122] = {700122,50};
virtualMenu[71123] = {700123,50};
virtualMenu[71124] = {700124,50};
virtualMenu[71125] = {700125,50};
virtualMenu[71126] = {700126,50};
virtualMenu[71127] = {700127,50};
virtualMenu[71128] = {700128,50};
virtualMenu[71129] = {700129,50};
virtualMenu[71130] = {700130,50};
virtualMenu[71131] = {700131,50};
virtualMenu[71132] = {700132,50};
virtualMenu[71133] = {700133,50};

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load');
  --ѵ����
  pokeVRNPC = self:NPC_createNormal('ⷰ錍�w��', 14602, { x = 80, y = 46, mapType = 0, map = 7351, direction = 6 });
  self:NPC_regTalkedEvent(pokeVRNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local GoalIndex,GoalSlot = Char.GetVRGoalSlot(player);
        if (GoalIndex>0) then
          local GoalName = Item.GetData(GoalIndex,CONST.����_����);
          local msg = "\\n\\n@c �_��Ҫ���w�� $5"..GoalName.." $0������Č���᣿\\n"
                   .. "\\nÿ�β������w���b�ã���Ҫ֧�����ɽ���5����"
                   .. "\\n\\n\\n\\n$4��ע�⣡���ȏ�ǰ��λ�Ì��ҿɌ��w������";	
          NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.��ť_ȷ���ر�, 1, msg);
        else
          local msg = "\\n\\n@c��Ʒ���Л]�п��Ԍ��w���ĵ���\\n"
                   .. "\\nÿ�β������w���b�ã���Ҫ֧�����ɽ���5����"
                   .. "\\n\\n\\n\\n$4��ע�⣡���ȏ�ǰ��λ�Ì��ҿɌ��w������";	
          NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.��ť_�ر�, 1, msg);
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
        local ItemId = Item.GetData(GoalIndex,CONST.����_ID);
        --NPC�ĳ���
        local EnemyId = virtualMenu[ItemId][1];
        local EnemyBaseId = Data.GetEnemyBaseIdByEnemyId(EnemyId);
        local EnemyBaseDataIndex = Data.EnemyBaseGetDataIndex(EnemyBaseId);
        local EnemyName = Data.EnemyBaseGetData(EnemyBaseDataIndex, CONST.EnemyBase_����);
        --local EnemyId = Data.EnemyBaseGetData(EnemyBaseDataIndex, CONST.EnemyBase_���);
        if select > 0 then
          if seqno == 1 and Char.ItemSlot(player)==20 and select == CONST.��ť_ȷ�� then
                NLG.SystemMessage(player,"[ϵ�y]��Ʒ��λ���ѝM��");
                 return;
          elseif seqno == 1 and select == CONST.��ť_�ر� then
                 return;
          elseif seqno == 1 and select == CONST.��ť_ȷ�� then
              if (Char.ItemNum(player, 66668)<5) then
                 NLG.SystemMessage(player,"[ϵ�y]���Ŕ������㣬�o�������b�á�");
                 return;
              end
              local PetLevel = virtualMenu[ItemId][2];
              --��������λ��
              local EmptySlot = Char.GetItemEmptySlot(player);
              Char.GiveItem(player, 71100, 1);
              local ItemIndex = Char.GetItemIndex(player, EmptySlot);
              Item.SetData(ItemIndex,CONST.����_����, EnemyName.."���`��");
              Item.SetData(ItemIndex,CONST.����_�Ӳ�һ, EnemyId);
              Item.SetData(ItemIndex,CONST.����_�Ӳζ�, PetLevel);
              Item.UpItem(player, EmptySlot);
              Char.DelItemBySlot(player, GoalSlot);
              Char.DelItem(player, 66668, 5);
              NLG.PlaySe(player, 279, Char.GetData(player,CONST.����_X), Char.GetData(player,CONST.����_Y));
              NLG.UpChar(player);
          else
              return;
          end
        end
    else
        if select > 0 then
          if select == CONST.��ť_�ر� then
            return;
          elseif seqno == 1 and select == CONST.��ť_ȷ�� then
            NLG.SystemMessage(player,"[ϵ�y]�]�п��Ԍ��w���ĵ��ߣ�Ո���´_�J��");
          end
        end
    end
  end)


  --ͨ�ó����ٻ�����
  self:regCallback('ItemString', Func.bind(self.swapSummon, self),"LUA_usePokeVR");
  self.petSummonNPC = self:NPC_createNormal('�������', 14682, { x = 40, y = 32, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.petSummonNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local msg = "\\n@c������􆾡�" ..	"\\n\\n\\n�_��Ҫ�ų����`��ȵČ��";	
        NLG.ShowWindowTalked(player, self.petSummonNPC, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 1, msg);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(self.petSummonNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    local BallIndex =BallIndex;
    local BallSlot = BallSlot;
    local BallName = Item.GetData(BallIndex, CONST.����_����);
    local last = string.find(BallName, "��", 1);
    local enemyName =string.sub(BallName, 1, last-1);
    local enemyId = Item.GetData(BallIndex,CONST.����_�Ӳ�һ);
    local enemyLevel = Item.GetData(BallIndex,CONST.����_�Ӳζ�);
    if select > 0 then
      if seqno == 1 and Char.PetNum(player)==5 and select == CONST.��ť_�� then
                 NLG.SystemMessage(player,"[ϵ�y]�����λ���ѝM��");
                 return;
      elseif seqno == 1 and select == CONST.��ť_�� then
                 return;
      elseif seqno == 1 and select == CONST.��ť_�� then
          if (enemyId ~=nil and enemyId>0) then
              --��������λ��
              local EmptySlot = Char.GetPetEmptySlot(player);
              Char.AddPet(player,enemyId);
              local PetIndex = Char.GetPet(player, EmptySlot);
              local arr_rank1_new = Pet.GetArtRank(PetIndex,CONST.�赵_���);
              local arr_rank2_new = Pet.GetArtRank(PetIndex,CONST.�赵_����);
              local arr_rank3_new = Pet.GetArtRank(PetIndex,CONST.�赵_ǿ��);
              local arr_rank4_new = Pet.GetArtRank(PetIndex,CONST.�赵_����);
              local arr_rank5_new = Pet.GetArtRank(PetIndex,CONST.�赵_ħ��);
              if (enemyLevel~=1) then
                  Char.SetData(PetIndex,CONST.����_������,enemyLevel-1);
                  Char.SetData(PetIndex,CONST.����_�ȼ�,enemyLevel);
                  Char.SetData(PetIndex,CONST.����_����, (Char.GetData(PetIndex,CONST.����_����) + (arr_rank1_new * (1/24) * (enemyLevel - 1)*100)) );
                  Char.SetData(PetIndex,CONST.����_����, (Char.GetData(PetIndex,CONST.����_����) + (arr_rank2_new * (1/24) * (enemyLevel - 1)*100)) );
                  Char.SetData(PetIndex,CONST.����_ǿ��, (Char.GetData(PetIndex,CONST.����_ǿ��) + (arr_rank3_new * (1/24) * (enemyLevel - 1)*100)) );
                  Char.SetData(PetIndex,CONST.����_�ٶ�, (Char.GetData(PetIndex,CONST.����_�ٶ�) + (arr_rank4_new * (1/24) * (enemyLevel - 1)*100)) );
                  Char.SetData(PetIndex,CONST.����_ħ��, (Char.GetData(PetIndex,CONST.����_ħ��) + (arr_rank5_new * (1/24) * (enemyLevel - 1)*100)) );
              end
              Pet.UpPet(player,PetIndex);
              Char.DelItemBySlot(player, BallSlot);
              NLG.SystemMessage(player, "[ϵͳ]"..enemyName.."�ɹ��􆾳���")
          else
              NLG.SystemMessage(player,"[ϵ�y]�����e�`��");
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
    local msg = "\\n@c������􆾡�" ..	"\\n\\n\\n�_��Ҫ�ų����`��ȵČ��";	
    NLG.ShowWindowTalked(charIndex, self.petSummonNPC, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 1, msg);
    return 1;
end

----------------------------------------------------------------
Char.GetVRGoalSlot = function(charIndex)
  for Slot=7,27 do
      local ItemIndex = Char.GetItemIndex(charIndex, Slot);
      --print(ItemIndex);
      if (ItemIndex > 0) then
        local ItemId = Item.GetData(ItemIndex,CONST.����_ID);
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


function CheckInTable(_idTab, _idVar) ---ѭ������
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
