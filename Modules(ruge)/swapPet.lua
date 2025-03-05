local Module = ModuleBase:createModule('swapPet')

local SwapNPC = {
    { Type=1, TeamStar={"�����Ƥ��", 231063, 20300,211,294}, NpcEnemy={"�F���xҹ",700061}, PlayerPet={"ȹ��С��",700009} },
    { Type=2, TeamStar={"�����÷���", 231069, 20300,417,347}, NpcEnemy={"���^С��",700062}, PlayerPet={"�����W��",700017}  },
    { Type=3, TeamStar={"���������", 14569, 20300,385,200}, NpcEnemy={"���ľ",700065}, PlayerPet={"ħ����ż",700040}  },
    { Type=4, TeamStar={"����ꠊW���ϼ�", 14581, 20300,261,28}, NpcEnemy={"����ʯ",700066}, PlayerPet={"���Q���",700005}  },
    { Type=5, TeamStar={"���������", 14095, 20300,499,128}, NpcEnemy={"������",700064}, PlayerPet={"����ˮĸ",700024}  },
    { Type=6, TeamStar={"�����ĵ��", 14093, 20300,294,398}, NpcEnemy={"������",700063}, PlayerPet={"�pβ����",700028}  },
}
tbl_TeamStarNPCIndex = tbl_TeamStarNPCIndex or {}

local petMettleTable = {
          {9610,9619,9620,9629},       --��BOSS��,��BOSS��,��������,��аħ��
          {9611,9615,9623,9624},       --�Ե���,�Եؼ�,�Է�����,��������
          {9612,9616,9627,9628},       --��ˮ��,��ˮ��,��������,�Խ�����
          {9613,9617,9621,9626},       --�Ի���,�Ի��,��������,��Ұ����
          {9614,9618,9622,9625},       --�Է���,�Է��,�Բ�����,��ֲ����
}

function Module:onLoad()
  self:logInfo('load');
  --������ѵ����1
 for k,v in pairs(SwapNPC) do
 if tbl_TeamStarNPCIndex[k] == nil then
  local petSwapNPC = self:NPC_createNormal(v.TeamStar[1], v.TeamStar[2], { x = v.TeamStar[4], y = v.TeamStar[5], mapType = 0, map = v.TeamStar[3], direction = 0 });
  tbl_TeamStarNPCIndex[k] = petSwapNPC
  self:NPC_regTalkedEvent(tbl_TeamStarNPCIndex[k], function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local msg = "\\n\\n@c�Һ���Ҫ "..v.PlayerPet[1].."����������@�b�����Ԓ������\\n\\n�_��Ҫ���ҵ� "..v.NpcEnemy[1].." ���Q�᣿\\n\\n\\n\\n��ע�⣡���h�H��1�bԓ�������M�н��Q";	
        NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 1, msg);
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
        --NPC�ĳ���
        local EnemyId = v.NpcEnemy[2];
        local EnemyBaseId = Data.GetEnemyBaseIdByEnemyId(EnemyId);
        local EnemyBaseDataIndex = Data.EnemyBaseGetDataIndex(EnemyBaseId);
        local EnemyName = Data.EnemyBaseGetData(EnemyBaseDataIndex, CONST.EnemyBase_����);
        --local EnemyId = Data.EnemyBaseGetData(EnemyBaseDataIndex, CONST.EnemyBase_���);
        --�����NPCҪ��Ŀ�����
        local PetSlot = Char.HavePet(player, v.PlayerPet[2]);
        local PetIndex = Char.GetPet(player, PetSlot);
        if select > 0 then
          if seqno == 1 and Char.ItemSlot(player)==20 and select == CONST.��ť_�� then
                NLG.SystemMessage(player,"[ϵ�y]��Ʒ��λ���ѝM��");
                 return;
          elseif seqno == 1 and select == CONST.��ť_�� then
                 return;
          elseif seqno == 1 and select == CONST.��ť_�� then
              if (PetIndex>0) then
                  local PetId = Char.GetData(PetIndex,CONST.����_PETID);
                  local PetLevel = Char.GetData(PetIndex,CONST.����_�ȼ�);
                  --��������λ��
                  local EmptySlot = Char.GetItemEmptySlot(player);
                  Char.GiveItem(player, 68019, 1);
                  local ItemIndex = Char.GetItemIndex(player, EmptySlot);
                  --local BallItemID = Item.GetData(ItemIndex,0);
                  Item.SetData(ItemIndex,CONST.����_����, EnemyName.."���`��");
                  Item.SetData(ItemIndex,CONST.����_�Ӳ�һ, EnemyId);
                  Item.SetData(ItemIndex,CONST.����_�Ӳζ�, PetLevel);
                  Char.DelPet(player, PetId, PetLevel, 1);
                  Item.UpItem(player, EmptySlot);
                  NLG.UpChar(player);
              else
                 NLG.SystemMessage(player, v.TeamStar[1]..":��]����Ҫ�Č���Ҳ�Ҫ���㽻�Q��");
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


  --ͨ�ó����ٻ�����
  self:regCallback('ItemString', Func.bind(self.swapSummon, self),"LUA_useSwapPet");
  self.petSummonNPC = self:NPC_createNormal('�������', 14682, { x = 40, y = 33, mapType = 0, map = 777, direction = 6 });
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
              local typeRand = math.random(1,#petMettleTable);
              local pos = math.random(1,#petMettleTable[typeRand]);
              Pet.AddSkill(PetIndex, petMettleTable[typeRand][pos], 9);
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
