---ģ����
local Module = ModuleBase:createModule('imageMachine')

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback("ItemString", Func.bind(self.ImageMac, self), 'LUA_useImMac');
  self.mirageNPC = self:NPC_createNormal('�����D�Q�C', 14682, { x = 40, y = 35, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.mirageNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
          local msg = "4|\\n�������D�Q�C���ԙC���Եسɹ����ָ�����������K�ҳ�����ٶ�ʹ�õ��ߣ�׌�]�д�����Č����D�Q�ɞ��@����\\n\\n";
          for petSlot=0,4 do
                local petIndex = Char.GetPet(player,petSlot);
                if(petIndex<0)then
                      msg = msg .. "��\\n";
                else
                      msg = msg .. ""..Char.GetData(petIndex,CONST.����_����).."\\n";
                end
          end
          NLG.ShowWindowTalked(player, self.mirageNPC, CONST.����_ѡ���, CONST.��ť_�ر�, 1, msg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.mirageNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --print(data)
    local MacIndex = Char.GetItemIndex(player,MacSlot);
    local MactechId = Item.GetData(MacIndex, CONST.����_�Ӳ�һ) or 0;
    local ImageName = Item.GetData(MacIndex, CONST.����_����);
    if select > 0 then

    else
      if (seqno == 1 and select == CONST.��ť_�ر�) then
                 return;
      elseif (seqno == 2 and select == CONST.��ť_�ر�) then
                 return;
      end
      if (seqno == 1 and data >= 1) then
          if (MactechId~=0) then
              NLG.SystemMessage(player, "[ϵ�y]�D�Q�C��������o����ȡ��");
              return;
          end
          local petSlot = data-1;
          local petIndex = Char.GetPet(player,petSlot);
          if (petIndex>=0) then
              local PetId = Char.GetData(petIndex,CONST.PET_PetID);
              local PetName = Char.GetData(petIndex,CONST.����_����);
              local PetImage = Char.GetData(petIndex, CONST.����_����);
              local SuccRate = 10;					--������ȡ����(%)
              if (type(SuccRate)=="number" and SuccRate>0) then
                  local tMin = 50 - math.floor(SuccRate/2) + 1;
                  local tMax = 50 + math.floor(SuccRate/2) + math.fmod(SuccRate,2);
                  local tLuck = math.random(1, 100);
                  if (tLuck>=tMin and tLuck<=tMax)  then
                      Item.SetData(MacIndex, CONST.����_����, "[".. PetName .."]�����D�Q�C");
                      Item.SetData(MacIndex, CONST.����_�Ӳ�һ, PetImage);
                      Item.UpItem(player, MacSlot);
                      NLG.UpChar(player);
                      NLG.SystemMessage(player, "[ϵ�y]�@��[".. PetName .."]�����D�Q�C��");
                  else
                      Char.DelItemBySlot(player, MacSlot);
                      NLG.SystemMessage(player, "[ϵ�y]��ȡ[".. PetName .."]����ʧ����");
                  end
              end
          else
              return;
          end

      elseif (seqno == 2 and data >= 1) then
          local petSlot = data-1;
          local petIndex = Char.GetPet(player,petSlot);
          if (MactechId==0) then
              NLG.SystemMessage(player, "[ϵ�y]�D�Q�C��δ������o���M���D�Q��");
              return;
          end
          if (petIndex>=0) then
              --local PetId = Char.GetData(petIndex,CONST.PET_PetID);
              local PetName = Char.GetData(petIndex,CONST.����_����);
              local PetImage = Char.GetData(petIndex, CONST.����_����);
              local last = string.find(ImageName, "]", 1);
              local ImageName = string.sub(ImageName, 2, last-1);
              if (MactechId==PetImage) then
                  NLG.SystemMessage(player, "[ϵ�y]�����ѽ����@������");
                  return;
              end
              Char.SetData(petIndex, CONST.����_����,MactechId);
              Pet.UpPet(player, petIndex);
              --Char.DelItem(player,70001,1);
              Char.DelItemBySlot(player, MacSlot);
              NLG.UpChar(player);
              NLG.SystemMessage(player, "[ϵ�y]"..PetName.."�D�Q�ɞ�[".. ImageName .."]����");
          else
              return;
          end

      else
                 return;
      end
    end
  end)


end

function Module:ImageMac(charIndex,targetIndex,itemSlot)
    ItemID = Item.GetData(Char.GetItemIndex(charIndex,itemSlot),0);
    MacSlot = itemSlot;
    local MacIndex = Char.GetItemIndex(charIndex,MacSlot);
    local MactechId = Item.GetData(MacIndex, CONST.����_�Ӳ�һ) or 0;
    if MactechId==0 then
          local msg = "4|\\n�������D�Q�C���ԙC���Եسɹ����ָ�����������K�ҳ�����ٶ�ʹ�õ��ߣ�׌�]�д�����Č����D�Q�ɞ��@����\\n\\n";
          for petSlot=0,4 do
                local petIndex = Char.GetPet(charIndex,petSlot);
                if(petIndex<0)then
                      msg = msg .. "��\\n";
                else
                      msg = msg .. ""..Char.GetData(petIndex,CONST.����_����).."\\n";
                end
          end
          NLG.ShowWindowTalked(charIndex, self.mirageNPC, CONST.����_ѡ���, CONST.��ť_�ر�, 1, msg);
    elseif MactechId>0 then
          local msg = "2|\\n�x��]�д�����Č���,���óɞ��@������\\n\\n";
          for petSlot=0,4 do
                local petIndex = Char.GetPet(charIndex,petSlot);
                if(petIndex<0)then
                      msg = msg .. "��\\n";
                else
                      msg = msg .. ""..Char.GetData(petIndex,CONST.����_����).."\\n";
                end
          end
          NLG.ShowWindowTalked(charIndex, self.mirageNPC, CONST.����_ѡ���, CONST.��ť_�ر�, 2, msg);
    end
    return 1;
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
