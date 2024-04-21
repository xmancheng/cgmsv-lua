local Module = ModuleBase:createModule('easyPet')

function Module:onLoad()
  self:logInfo('load');
  self:regCallback('ItemString', Func.bind(self.summon, self),"LUA_useEasyPet");
  self.easyPetNPC = self:NPC_createNormal('���Ό����ن���', 14682, { x = 66, y = 66, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.easyPetNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local msg = "\\n@c����â���ن�ꇡ�" ..	"\\n\\nֻҪ�ӄ���ָ���ε�ݔ������̖\\n\\n�Ϳ����ن�����Č���ħ��ⷰ�\\n\\n\\nՈݔ������̖��";	
        NLG.ShowWindowTalked(player, self.easyPetNPC, CONST.����_�����, CONST.��ť_ȷ���ر�, 1, msg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.easyPetNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select > 0 then
      if seqno == 1 and Char.PetNum(player)==5 and select == CONST.��ť_ȷ�� then
                 NLG.SystemMessage(player,"[ϵ�y]�����λ���ѝM��");
                 return;
      elseif seqno == 1 and Char.HavePet(player, 500009)>0 and select == CONST.��ť_ȷ�� then
                 NLG.SystemMessage(player,"[ϵ�y]����ڲ����������ن�����");
                 return;
      elseif seqno == 1 and select == CONST.��ť_ȷ�� then
                 PetImage = tonumber("".._data.."")
                 local msg = "\\n@c����â���ن�ꇡ�" ..	"\\n\\n\\n�x���ǡ��ن�����35/55/20/30/10\\n\\n\\n�x�����ن�ħ��20/10/30/35/55\\n\\n";	
                 NLG.ShowWindowTalked(player, self.easyPetNPC, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 11, msg);
      end
      if seqno == 11 and select == CONST.��ť_�� then
          if (PetImage > 0) then
                 Char.AddPet(player,500009);
                 local Slot = Char.HavePet(player, 500009);
                 local PetIndex = Char.GetPet(player, Slot);
                 Pet.SetArtRank(PetIndex,CONST.PET_���,35 - math.random(0,1));  --�Զ���ֲ���������n0~4
                 Pet.SetArtRank(PetIndex,CONST.PET_����,55 - math.random(0,1));
                 Pet.SetArtRank(PetIndex,CONST.PET_ǿ��,20 - math.random(0,1));
                 Pet.SetArtRank(PetIndex,CONST.PET_����,30 - math.random(0,1));
                 Pet.SetArtRank(PetIndex,CONST.PET_ħ��,10 - math.random(0,1));
                 Pet.ReBirth(player,PetIndex);
                 Char.SetData(PetIndex,CONST.����_��ɱ,0);
                 Char.SetData(PetIndex,CONST.����_����,0);
                 Char.SetData(PetIndex,CONST.����_����,0);
                 Char.SetData(PetIndex,CONST.����_����,0);
                 Char.SetData(PetIndex,CONST.����_������,30);
                 Char.SetData(PetIndex,CONST.����_ˮ����,30);
                 Char.SetData(PetIndex,CONST.����_������,30);
                 Char.SetData(PetIndex,CONST.����_������,30);
                 Char.SetData(PetIndex,CONST.����_����,100);
                 Char.SetData(PetIndex,CONST.����_��˯,100);
                 Char.SetData(PetIndex,CONST.����_��ʯ,100);
                 Char.SetData(PetIndex,CONST.����_����,100);
                 Char.SetData(PetIndex,CONST.����_����,100);
                 Char.SetData(PetIndex,CONST.����_����,100);
                 Char.SetData(PetIndex,CONST.����_����,PetImage);
                 Char.SetData(PetIndex,CONST.����_ԭ��,PetImage);
                 Char.SetData(PetIndex,CONST.����_����,"������ԇ��ħ��");
                 Char.SetData(PetIndex,CONST.����_��ɫ,6);             --�Զ������Ϊ��ɫ����
                 Pet.UpPet(player,PetIndex)
                 Char.DelItem(player,ItemID,1);
                 NLG.SystemMessage(player, "[ϵͳ]�ن�ħ��xʽ�����Y����")
          else
                 NLG.SystemMessage(player,"[ϵ�y]ݔ�������̖�����ϸ�ʽ��");
                 return;
          end
      elseif seqno == 11 and select == CONST.��ť_�� then
          if (PetImage > 0) then
                 Char.AddPet(player,500009);
                 local Slot = Char.HavePet(player, 500009);
                 local PetIndex = Char.GetPet(player, Slot);
                 Pet.SetArtRank(PetIndex,CONST.PET_���,20 - math.random(0,1));  --�Զ���ֲ���������n0~4
                 Pet.SetArtRank(PetIndex,CONST.PET_����,10 - math.random(0,1));
                 Pet.SetArtRank(PetIndex,CONST.PET_ǿ��,30 - math.random(0,1));
                 Pet.SetArtRank(PetIndex,CONST.PET_����,35 - math.random(0,1));
                 Pet.SetArtRank(PetIndex,CONST.PET_ħ��,55 - math.random(0,1));
                 Pet.ReBirth(player,PetIndex);
                 Char.SetData(PetIndex,CONST.����_��ɱ,0);
                 Char.SetData(PetIndex,CONST.����_����,0);
                 Char.SetData(PetIndex,CONST.����_����,0);
                 Char.SetData(PetIndex,CONST.����_����,0);
                 Char.SetData(PetIndex,CONST.����_������,30);
                 Char.SetData(PetIndex,CONST.����_ˮ����,30);
                 Char.SetData(PetIndex,CONST.����_������,30);
                 Char.SetData(PetIndex,CONST.����_������,30);
                 Char.SetData(PetIndex,CONST.����_����,100);
                 Char.SetData(PetIndex,CONST.����_��˯,100);
                 Char.SetData(PetIndex,CONST.����_��ʯ,100);
                 Char.SetData(PetIndex,CONST.����_����,100);
                 Char.SetData(PetIndex,CONST.����_����,100);
                 Char.SetData(PetIndex,CONST.����_����,100);
                 Char.SetData(PetIndex,CONST.����_����,PetImage);
                 Char.SetData(PetIndex,CONST.����_ԭ��,PetImage);
                 Char.SetData(PetIndex,CONST.����_����,"ħ����ԇ��ħ��");
                 Char.SetData(PetIndex,CONST.����_��ɫ,6);             --�Զ������Ϊ��ɫ����
                 Pet.UpPet(player,PetIndex)
                 Char.DelItem(player,ItemID,1);
                 NLG.SystemMessage(player, "[ϵͳ]�ن�ħ��xʽ�����Y����")
          else
                 NLG.SystemMessage(player,"[ϵ�y]ݔ�������̖�����ϸ�ʽ��");
                 return;
          end
      else
                 return;
      end

    end
  end)


end


function Module:summon(charIndex,targetIndex,itemSlot)
    ItemID = Item.GetData(Char.GetItemIndex(charIndex,itemSlot),0);
    local msg = "\\n@c����â���ن�ꇡ�" ..	"\\n\\nֻҪ�ӄ���ָ���ε�ݔ������̖\\n\\n�Ϳ����ن�����Č���ħ��ⷰ�\\n\\n\\nՈݔ������̖��";	
    NLG.ShowWindowTalked(charIndex, self.easyPetNPC, CONST.����_�����, CONST.��ť_ȷ���ر�, 1, msg);
    return 1;
end

function Module:onUnload()
  self:logInfo('unload')
end

return Module;
