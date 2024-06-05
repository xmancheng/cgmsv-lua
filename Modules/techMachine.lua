---ģ����
local Module = ModuleBase:createModule('techMachine')

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback("ItemString", Func.bind(self.LearnMac, self), 'LUA_useMac');
  self.learningNPC = self:NPC_createNormal('��ʽ�W���C', 14682, { x = 38, y = 35, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.learningNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
          local msg = "4|\\n����ʽ�W���C���ԙC���Եسɹ����ָ���Č��＼�܁K�ҳ�����ٶ�ʹ�õ��ߣ�׌�]�д˼��ܵČ���W��������ʽ���ܣ�\\n\\n";
          for petSlot=0,4 do
                local petIndex = Char.GetPet(player,petSlot);
                if(petIndex<0)then
                      msg = msg .. "��\\n";
                else
                      msg = msg .. ""..Char.GetData(petIndex,CONST.CHAR_����).."\\n";
                end
          end
          NLG.ShowWindowTalked(player, self.learningNPC, CONST.����_ѡ���, CONST.��ť_�ر�, 1, msg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.learningNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    print(data)
    local MacIndex = Char.GetItemIndex(player,MacSlot);
    local MactechId = Item.GetData(MacIndex, CONST.����_�Ӳ�һ) or 0;
    if select > 0 then

    else
      if (seqno == 1 and select == CONST.��ť_�ر�) then
                 return;
      elseif (seqno == 2 and select == CONST.��ť_�ر�) then
                 return;
      elseif (seqno == 11 and select == CONST.��ť_�ر�) then
                 return;
      elseif (seqno == 21 and select == CONST.��ť_�ر�) then
                 return;
      end
      if (seqno == 1 and data >= 1) then
          local petSlot = data-1;
          petIndex = Char.GetPet(player,petSlot);
          if (petIndex>=0) then
              local PetId = Char.GetData(petIndex,CONST.PET_PetID);
              local enemyBaseIndex = Data.EnemyBaseGetDataIndex(PetId);
              local slotNum = Data.EnemyBaseGetData(enemyBaseIndex, CONST.EnemyBase_������);
              local PetName = Char.GetData(petIndex,CONST.CHAR_����);
              local PetNameColor = Char.GetData(petIndex, CONST.CHAR_��ɫ);
              local msg = "1|\\nՈ�x��Ҫ��ȡ����Č��＼�ܡ�\\n";
              for i=2,slotNum-1 do
                    local techId= Pet.GetSkill(petIndex,i);
                    local techIndex = Tech.GetTechIndex(techId);
                    if (techIndex<0) then
                          msg = msg .. "��".. i+1 .."��:  " .. "��\\n";
                    else
                          msg = msg .. "��".. i+1 .."��:  " .. ""..Tech.GetData(techIndex, CONST.TECH_NAME).."\\n";
                    end
              end
              NLG.ShowWindowTalked(player, self.learningNPC, CONST.����_ѡ���, CONST.��ť_�ر�, 11, msg);
          end
      elseif (seqno == 2 and data >= 1) then
          local petSlot = data-1;
          petIndex = Char.GetPet(player,petSlot);
          if (petIndex>=0) then
              local PetId = Char.GetData(petIndex,CONST.PET_PetID);
              local enemyBaseIndex = Data.EnemyBaseGetDataIndex(PetId);
              local slotNum = Data.EnemyBaseGetData(enemyBaseIndex, CONST.EnemyBase_������);
              local PetName = Char.GetData(petIndex,CONST.CHAR_����);
              local PetNameColor = Char.GetData(petIndex, CONST.CHAR_��ɫ);
              local msg = "1|\\nՈ�x���w��W�����＼�ܵ�λ�á�\\n";
              for i=2,slotNum-1 do
                    local techId= Pet.GetSkill(petIndex,i);
                    local techIndex = Tech.GetTechIndex(techId);
                    if (techIndex<0) then
                          msg = msg .. "��".. i+1 .."��:  " .. "��\\n";
                    else
                          msg = msg .. "��".. i+1 .."��:  " .. ""..Tech.GetData(techIndex, CONST.TECH_NAME).."\\n";
                    end
              end
              NLG.ShowWindowTalked(player, self.learningNPC, CONST.����_ѡ���, CONST.��ť_�ر�, 21, msg);
          end
      elseif (seqno == 11 and data >= 1) then
          local techSlot = data+1;
          local techId= Pet.GetSkill(petIndex,techSlot);
          local techIndex = Tech.GetTechIndex(techId);
          local techName = Tech.GetData(techIndex, CONST.TECH_NAME);
          if (techId<0) then
              NLG.SystemMessage(player, "[ϵ�y]�o�����R����ʽ��");
              return;
          end
          if (techId~=7300 and techId~=7400 and techId~=15002 and techId~=16000) then
              Item.SetData(MacIndex, CONST.����_����, "[".. techName .."]��ʽ�W���C");
              Item.SetData(MacIndex, CONST.����_�Ӳ�һ, techId);
              Item.UpItem(player, MacSlot);
              NLG.UpChar(player);
              NLG.SystemMessage(player, "[ϵ�y]�@��[".. techName .."]��ʽ�W���C��");
          else
              NLG.SystemMessage(player, "[ϵ�y]�_��Ҫ�x�@�N��ͨ����ʽ��");
              return;
          end
      elseif (seqno == 21 and data >= 1) then
          --����ԭ���ļ���
          local techSlot = data+1;
          local techId= Pet.GetSkill(petIndex,techSlot);
          local PetName = Char.GetData(petIndex,CONST.CHAR_����);
          --��ʽ������ļ���
          local techIndex = Tech.GetTechIndex(MactechId);
          local techName = Tech.GetData(techIndex, CONST.TECH_NAME);
          if (techId>0) then
              Pet.DelSkill(petIndex, techSlot)
              Pet.AddSkill(petIndex, MactechId, techSlot);
          else
              Pet.AddSkill(petIndex, MactechId, techSlot);
          end
          Pet.UpPet(player, petIndex);
          --Char.DelItem(player,75017,1);
          Char.DelItemBySlot(player, MacSlot);
          NLG.UpChar(player);
          NLG.SystemMessage(player, "[ϵ�y]"..PetName.."�W��[".. techName .."]��ʽ��");
      else
                 return;
      end
    end
  end)


end

function Module:LearnMac(charIndex,targetIndex,itemSlot)
    ItemID = Item.GetData(Char.GetItemIndex(charIndex,itemSlot),0);
    MacSlot = itemSlot;
    local MacIndex = Char.GetItemIndex(charIndex,MacSlot);
    local techId = Item.GetData(MacIndex, CONST.����_�Ӳ�һ) or 0;
    if techId==0 then
          local msg = "4|\\n����ʽ�W���C���ԙC���Եسɹ����ָ���Č��＼�܁K�ҳ�����ٶ�ʹ�õ��ߣ�׌�]�д˼��ܵČ���W��������ʽ���ܣ�\\n\\n";
          for petSlot=0,4 do
                local petIndex = Char.GetPet(charIndex,petSlot);
                if(petIndex<0)then
                      msg = msg .. "��\\n";
                else
                      msg = msg .. ""..Char.GetData(petIndex,CONST.CHAR_����).."\\n";
                end
          end
          NLG.ShowWindowTalked(charIndex, self.learningNPC, CONST.����_ѡ���, CONST.��ť_�ر�, 1, msg);
    elseif techId>0 then
          local msg = "4|\\n����ʽ�W���C���ԙC���Եسɹ����ָ���Č��＼�܁K�ҳ�����ٶ�ʹ�õ��ߣ�׌�]�д˼��ܵČ���W��������ʽ���ܣ�\\n\\n";
          for petSlot=0,4 do
                local petIndex = Char.GetPet(charIndex,petSlot);
                if(petIndex<0)then
                      msg = msg .. "��\\n";
                else
                      msg = msg .. ""..Char.GetData(petIndex,CONST.CHAR_����).."\\n";
                end
          end
          NLG.ShowWindowTalked(charIndex, self.learningNPC, CONST.����_ѡ���, CONST.��ť_�ر�, 2, msg);
    end
    return 1;
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
