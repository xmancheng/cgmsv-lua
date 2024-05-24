---ģ����
local Module = ModuleBase:createModule('petEvolution')

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self.awakeningNPC = self:NPC_createNormal('ռ���ëF��', 104905, { x = 28, y = 40, mapType = 0, map = 60010, direction = 6 });
  self:NPC_regTalkedEvent(self.awakeningNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
          local msg = "4|\\n��Č�����ˮ���ˆ᣿�����ԽY����׌�����X�ѡ�����㎧���100�����ԽY�����Ҿ͎����a����������͑B�����m߀�����^�m�����X�ѵȼ���\\n\\n";
          for i=0,4 do
                local pet = Char.GetPet(player,i);
                if(pet<0)then
                      msg = msg .. "��\\n";
                else
                      msg = msg .. ""..Char.GetData(pet,CONST.CHAR_����).."\\n";
                end
          end
          NLG.ShowWindowTalked(player, self.awakeningNPC, CONST.����_ѡ���, CONST.��ť_�ر�, 1, msg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.awakeningNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    print(data)
    if select > 0 then

    else
      if (seqno == 1 and select == CONST.��ť_�ر�) then
                 return;
      elseif (seqno == 1 and data >= 1) then
          local petSlot = data-1;
          local petIndex = Char.GetPet(player,petSlot);
          if (petIndex>=0) then
              local PetId = Char.GetData(petIndex,CONST.PET_PetID);
              local PetCrystalIndex,targetSlot = Pet.GetCrystal(petIndex);
              local PetCrystal_Name = Item.GetData(PetCrystalIndex, CONST.����_����);
              local bindId = Item.GetData(PetCrystalIndex, CONST.����_��������) or 0;
              local typeId = Item.GetData(PetCrystalIndex, CONST.����_�Ӳ�һ) or 0;
              local typeLv = Item.GetData(PetCrystalIndex, CONST.����_�Ӳζ�) or 0;
              if (PetCrystalIndex<0) then
                 NLG.SystemMessage(player, "[ϵ�y]������δ�b���κ�ˮ����");
                 return;
              end
              if (bindId==0 and typeId==0 and typeLv==0) then
                 if (Char.ItemNum(player, 69163)>=100 and Char.ItemNum(player, 69164)>=100 and Char.ItemNum(player, 69165)>=100 and Char.ItemNum(player, 69166)>=100) then
                     --ɾ����Ҫ�Ĳ���
                     Char.DelItem(player, 69163, 100);
                     Char.DelItem(player, 69164, 100);
                     Char.DelItem(player, 69165, 100);
                     Char.DelItem(player, 69166, 100);
                     --����������̬
                     local TL = Pet.GetArtRank(petIndex, CONST.PET_���);
                     local GJ = Pet.GetArtRank(petIndex, CONST.PET_����);
                     local FY = Pet.GetArtRank(petIndex, CONST.PET_ǿ��);
                     local MJ = Pet.GetArtRank(petIndex, CONST.PET_����);
                     local MF = Pet.GetArtRank(petIndex, CONST.PET_ħ��);
                     if TL>GJ and TL>=40 then
                         PetType=1;
                         Identify="������";
                     elseif GJ>MJ and GJ>=40 then
                         PetType=2;
                         Identify="�ų���";
                     elseif FY>TL and FY>=40 then
                         PetType=3;
                         Identify="׃����";
                     elseif MJ>GJ and MJ>=40 then
                         PetType=4;
                         Identify="������";
                     elseif MF>GJ and MF>=40 then
                         PetType=5;
                         Identify="�߬F����";
                     else
                         PetType=6;
                         Identify="���|��";
                     end
                     --ˮ������Ч����¼
                     local Aname = "[" ..Identify.. "]"..PetCrystal_Name;
                     local Newname = "[" ..Identify.. "]"..PetCrystal_Name.."+1";
                     Item.SetData(PetCrystalIndex,CONST.����_����, Newname);
                     Item.SetData(PetCrystalIndex,CONST.����_��ǰ��, Aname);
                     Item.SetData(PetCrystalIndex,CONST.����_��������, PetId);
                     Item.SetData(PetCrystalIndex,CONST.����_�Ӳ�һ, PetType);
                     Item.SetData(PetCrystalIndex,CONST.����_�Ӳζ�, 1);
                     Item.UpItem(petIndex, targetSlot);
                     NLG.SystemMessage(player, "[ϵ�y]�����a����ɣ�����"..Identify.."��");
                     NLG.UpChar(player);
                 else
                     NLG.SystemMessage(player, "[ϵ�y]���ԽY����������o���a����");
                     return;
                 end
              elseif (bindId~=0 and typeId~=0 and typeLv>=1) then
                 local itemMaterial = (typeLv+1)*100;
                 if (Char.ItemNum(player, 69163)>=itemMaterial and Char.ItemNum(player, 69164)>=itemMaterial and Char.ItemNum(player, 69165)>=itemMaterial and Char.ItemNum(player, 69166)>=itemMaterial) then
                     --ɾ����Ҫ�Ĳ���
                     Char.DelItem(player, 69163, itemMaterial);
                     Char.DelItem(player, 69164, itemMaterial);
                     Char.DelItem(player, 69165, itemMaterial);
                     Char.DelItem(player, 69166, itemMaterial);
                     --��������
                     local Aname = Item.GetData(PetCrystalIndex,CONST.����_��ǰ��);
                     local typeLv_New = typeLv+1;
                     local Newname = Aname.."+"..typeLv_New;
                     Item.SetData(PetCrystalIndex,CONST.����_����, Newname);
                     Item.SetData(PetCrystalIndex,CONST.����_�Ӳζ�, typeLv_New);
                     Item.UpItem(petIndex, targetSlot);
                     NLG.SystemMessage(player, "[ϵ�y]�����X�������ɹ�+"..typeLv_New.."��");
                     NLG.UpChar(player);
                 else
                     NLG.SystemMessage(player, "[ϵ�y]�����X����������Č��ԽY��: "..itemMaterial.."����");
                 end
              end
          end
      else
                 return;
      end
    end
  end)


end

--��ȡ����װ��-ˮ��
Pet.GetCrystal = function(petIndex)
  local ItemIndex = Char.GetItemIndex(petIndex, CONST.�����_ˮ��);
  if ItemIndex >= 0 and Item.GetData(ItemIndex, CONST.����_����)==CONST.��������_����ˮ�� then
    return ItemIndex,CONST.�����_ˮ��;
  end
  return -1,-1;
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
