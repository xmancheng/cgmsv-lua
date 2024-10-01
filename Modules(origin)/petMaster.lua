---ģ����
local Module = ModuleBase:createModule('petMaster')

local StarSysOn = 0;
local MaxStarLv = 4;
local StarEnable_check= {700066};
local StarEnable_list = {};
StarEnable_list[700066] = { {},{},{},{} };  --��1(BP��).��2(������).��3(BP��).��4(���ܻ���ǿ��)

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self.MStarNPC = self:NPC_createNormal('�����Ǽ�����', 104675, { x = 235, y = 116, mapType = 0, map = 1000, direction = 6 });
  self:NPC_regTalkedEvent(self.MStarNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
          local msg = "����������������$1�������Ǽ�������\\n"
                              .. "������������һ�����Ҫ�����Ǽ�����Ҫ����\\n"
                              .. "��������$4ע��:  ���Nλ�Ì����r����ό���^\\n"
          local petIndex = Char.GetPet(player,0);	--����̶���������һ��
          if (petIndex>=0) then
              --��Ҫ����
              local PetId = Char.GetData(petIndex,CONST.PET_PetID);
              local PetName_1 = Char.GetData(petIndex,CONST.����_ԭ��);
              local PetImage_1 = Char.GetData(petIndex,CONST.����_����);
              local imageText_1 = "@g,"..PetImage_1..",3,8,6,0@"
              msg = msg .. "��Ҫ��: "..PetName_1
              --���ϳ���
              local materialPetIndex,mSlot = Char.GetMaterialPet(player,PetId);
              if (materialPetIndex>0) then
                  StarSysOn = 1;
                  local mSlot = mSlot+1;
                  local PetName_2 = Char.GetData(materialPetIndex,CONST.����_ԭ��);
                  local PetImage_2 = Char.GetData(materialPetIndex,CONST.����_����);
                  local imageText_2 = "@g,"..PetImage_2..",13,8,6,0@"
                  msg = msg .. "�������ό�(��"..mSlot.."��): "..PetName_2.."\\n"
                                        .. imageText_1 .. imageText_2;
              else
                  StarSysOn = 0;
                  msg = msg .. "�������ό�(��X��): �o����\\n"
                                        .. imageText_1;
              end
          else
              StarSysOn = 0;
              msg = msg .. "��Ҫ��: �ǿ��Ǽ������Č���" .. "\\n\\n\\n���ό�(��X��): �o����\\n";
          end
          NLG.ShowWindowTalked(player, self.MStarNPC, CONST.����_��Ϣ��, CONST.��ť_ȷ���ر�, 1, msg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.MStarNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    local tPlayerGold = Char.GetData(player, CONST.����_���);
    --print(data)
    if select > 0 then
      if (seqno == 1 and select == CONST.��ť_�ر�) then
                 return;
      elseif (seqno == 1 and select == CONST.��ť_ȷ��) then
          if (tPlayerGold<10000) then
              NLG.SystemMessage(player, "[ϵ�y] �Ǽ�ϵ�y����ÿ�� 1�fG��������Ų��㡣");
              return;
          end
          if (StarSysOn == 1) then
              local petIndex = Char.GetPet(player,0);
              local PetId = Char.GetData(petIndex,CONST.PET_PetID);
              local PetName_1 = Char.GetData(petIndex,CONST.����_ԭ��);
              local materialPetIndex,mSlot = Char.GetMaterialPet(player,PetId);
              local last = string.find(PetName_1, "��", 1);
              local StarLv = string.sub(PetName_1, last+1, -1);
              local PetRawName = string.sub(PetName_1, 1, last-2);
              if (StarLv==nil) then
                  Char.SetData(petIndex,CONST.����_ԭ��, PetRawName .. "��1");
                  Char.DelSlotPet(player, mSlot);
                  Pet.UpPet(player,petIndex);
                  NLG.UpChar(player);
                  NLG.SystemMessage(player, "[ϵ�y] ".. PetRawName .."�ɹ��M�����1��");
              elseif (StarLv>=1 and StarLv<MaxStarLv) then

              else
                  NLG.SystemMessage(player, "[ϵ�y] �Ǽ����_Ŀǰ�_�����ޡ�");
                  return;
              end
          elseif (StarSysOn == 0) then
              NLG.SystemMessage(player, "[ϵ�y] �l�������ϣ��Ǽ�ϵ�yֹͣ������");
              return;
          end
      end
    else

    end
  end)


end


Char.GetMaterialPet = function(charIndex,enemyid)
  for Slot=1,4 do
      local PetIndex = Char.GetPet(charIndex, Slot);
      if (PetIndex >= 0) then
          local MPetId = Char.GetData(PetIndex,CONST.PET_PetID);
          --print(PetIndex,enemyid,MPetId);
          if (enemyid==MPetId) then
              return PetIndex,Slot;
          end
      end
  end
  return -1,-1;
end

function CheckInTable(_idTab, _idVar) ---ѭ������
	for k,v in pairs(_idTab) do
		if v==_idVar then
			return true
		end
	end
	return false
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
