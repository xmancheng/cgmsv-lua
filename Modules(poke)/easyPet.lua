local Module = ModuleBase:createModule('easyPet')

--���ŵĳ���������
local PetImageTbl = {
    123000,123005,123010,123016,123019,123020,123021,
}

------------------------------------------------------------------------------------
function Module:onLoad()
  self:logInfo('load');
  self:regCallback('ItemString', Func.bind(self.summon, self),"LUA_useEasyPet");
  self.easyPetNPC = self:NPC_createNormal('���Ό����ن���', 14682, { x = 66, y = 66, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.easyPetNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local msg = "\\n@c����â���ن�ꇡ�" ..	"\\n\\n�M�ϏĴ�偸������Ĕ���\\n\\n�Ϳ����ن�������ħŮⷰ�\\n\\n\\nՈݔ������̖��";	
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
                 local msg = "\\n@c����â���ن�ꇡ�" ..	"\\n\\n\\n�x���ǡ��ن�����31/51/16/26/6\\n\\n\\n�x�����ن�ħ��16/6/26/31/51\\n\\n";	
                 NLG.ShowWindowTalked(player, self.easyPetNPC, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 11, msg);
      end
      if seqno == 11 and select == CONST.��ť_�� then
          if (PetImage ~=nil and math.ceil(PetImage)==PetImage) then
              if (Image_CheckInTable(PetImageTbl,PetImage)==true and PetImage>=123000 and PetImage<=130000) then
                 local numX = NLG.Rand(100,499);
                 Char.SetData(player,CONST.����_Ѫ, Char.GetData(player,CONST.����_Ѫ)-100);
                 NLG.UpChar(player);
                 Char.AddPet(player,500009);
                 local Slot = Char.HavePet(player, 500009);
                 local PetIndex = Char.GetPet(player, Slot);
                 Pet.SetArtRank(PetIndex,CONST.PET_���,31 - math.random(0,1));  --�Զ���ֲ���������n0~4
                 Pet.SetArtRank(PetIndex,CONST.PET_����,51 - math.random(0,1));
                 Pet.SetArtRank(PetIndex,CONST.PET_ǿ��,16 - math.random(0,1));
                 Pet.SetArtRank(PetIndex,CONST.PET_����,26 - math.random(0,1));
                 Pet.SetArtRank(PetIndex,CONST.PET_ħ��,6 - math.random(0,1));
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
                 Char.SetData(PetIndex,CONST.����_����,"������ħŮ"..numX.."̖");
                 --Char.SetData(PetIndex,CONST.����_��ɫ,6);             --�Զ������Ϊ��ɫ����
                 Pet.UpPet(player,PetIndex)
                 Char.DelItem(player,ItemID,1);
                 NLG.SystemMessage(player, "[ϵͳ]�I��������K�����Y���s�����Y����")
              else
                 NLG.SystemMessage(player,"[ϵ�y]ݔ�������̖���ڹ����ȡ�");
                 return;
              end
          else
                 NLG.SystemMessage(player,"[ϵ�y]ݔ�������̖�����ϸ�ʽ��");
                 return;
          end
      elseif seqno == 11 and select == CONST.��ť_�� then
          if (PetImage ~=nil and math.ceil(PetImage)==PetImage) then
              if (Image_CheckInTable(PetImageTbl,PetImage)==true and PetImage>=123000 and PetImage<=130000) then
                 local numY = NLG.Rand(500,999);
                 Char.SetData(player,CONST.����_Ѫ, Char.GetData(player,CONST.����_Ѫ)-100);
                 NLG.UpChar(player);
                 Char.AddPet(player,500009);
                 local Slot = Char.HavePet(player, 500009);
                 local PetIndex = Char.GetPet(player, Slot);
                 Pet.SetArtRank(PetIndex,CONST.PET_���,16 - math.random(0,1));  --�Զ���ֲ���������n0~4
                 Pet.SetArtRank(PetIndex,CONST.PET_����,6 - math.random(0,1));
                 Pet.SetArtRank(PetIndex,CONST.PET_ǿ��,26 - math.random(0,1));
                 Pet.SetArtRank(PetIndex,CONST.PET_����,31 - math.random(0,1));
                 Pet.SetArtRank(PetIndex,CONST.PET_ħ��,51 - math.random(0,1));
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
                 Char.SetData(PetIndex,CONST.����_����,"ħ����ħŮ"..numY.."̖");
                 --Char.SetData(PetIndex,CONST.����_��ɫ,6);             --�Զ������Ϊ��ɫ����
                 Pet.UpPet(player,PetIndex)
                 Char.DelItem(player,ItemID,1);
                 NLG.SystemMessage(player, "[ϵͳ]�I��������K�����Y���s�����Y����")
              else
                 NLG.SystemMessage(player,"[ϵ�y]ݔ�������̖���ڹ����ȡ�");
                 return;
              end
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
    local msg = "\\n@c����â���ن�ꇡ�" ..	"\\n\\n�M�ϏĴ�偸������Ĕ���\\n\\n�Ϳ����ن�������ħŮⷰ�\\n\\n\\nՈݔ������̖��";	
    NLG.ShowWindowTalked(charIndex, self.easyPetNPC, CONST.����_�����, CONST.��ť_ȷ���ر�, 1, msg);
    return 1;
end

function Image_CheckInTable(_idTab, _idVar) ---ѭ������
	for k,v in pairs(_idTab) do
		print(v .. " = " .. _idVar)
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
