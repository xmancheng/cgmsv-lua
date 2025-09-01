local Module = ModuleBase:createModule('swapPet')

function Module:onLoad()
  self:logInfo('load');
  --ͨ�ó����ٻ�����
  self:regCallback('ItemString', Func.bind(self.swapSummon, self),"LUA_useSwapPet");
  self.petSummonNPC = self:NPC_createNormal('�ن����', 14682, { x = 40, y = 33, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.petSummonNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local msg = "\\n@c������􆾡�" ..	"\\n\\n\\n�_��Ҫ�ų����ن���ȵČ��";	
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
    local msg = "\\n@c������􆾡�" ..	"\\n\\n\\n�_��Ҫ�ų����ن���ȵČ��";	
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

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
