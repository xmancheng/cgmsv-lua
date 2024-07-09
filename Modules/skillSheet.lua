---ģ����
local Module = ModuleBase:createModule('skillSheet')

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback("ItemString", Func.bind(self.LearnSheet, self), 'LUA_useSheet');
  self.getTipsNPC = self:NPC_createNormal('��������', 14682, { x = 36, y = 29, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.getTipsNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
          local msg = "1|\\n��ɫ�������� (�����I����)��\\n";
          for skillSlot=0,8 do
                local skillId = Char.GetSkillID(player,skillSlot);
                local skillIndex = Skill.GetSkillIndex(skillId);
                if(skillIndex<0)then
                      msg = msg .. "��".. skillSlot+1 .."��:���o���ܡ�\\n";
                else
                      msg = msg .. "��".. skillSlot+1 .."��:��"..Skill.GetData(skillIndex, CONST.SKILL_NAME).."��\\n";
                end
          end
          NLG.ShowWindowTalked(player, self.getTipsNPC, CONST.����_ѡ���, CONST.BUTTON_��ȡ��, 1, msg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.getTipsNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --print(data)
    local SheetIndex = Char.GetItemIndex(player,SheetSlot);
    local SheetskillId = Item.GetData(SheetIndex, CONST.����_�Ӳ�һ) or 0;
    if select > 0 then
          local slotNum = Char.GetData(player, CONST.CHAR_������);
          local msg = "1|\\n��ɫ�������� (�����I����)��\\n";
          for skillSlot=9, slotNum-1 do
                local skillId = Char.GetSkillID(player,skillSlot);
                local skillIndex = Skill.GetSkillIndex(skillId);
                if(skillIndex<0)then
                      msg = msg .. "��".. skillSlot+1 .."��:���o���ܡ�\\n";
                else
                      msg = msg .. "��".. skillSlot+1 .."��:��"..Skill.GetData(skillIndex, CONST.SKILL_NAME).."��\\n";
                end
          end
          NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, CONST.��ť_�ر�, 2, msg);
    else
      if (seqno == 1 and select == CONST.��ť_�ر�) then
                 return;
      elseif (seqno == 2 and select == CONST.��ť_�ر�) then
                 return;
      elseif (seqno == 11 and select == CONST.��ť_�ر�) then
                 return;
      end
      if (seqno >= 1 and data >= 1) then
          --ԭ���ļ���
          local skillSlot = data-1;
          if (seqno == 2) then
              skillSlot = 8 + data-1;
          end
          local skillId = Char.GetSkillID(player,skillSlot) or -1;
          local skillIndex = Skill.GetSkillIndex(skillId);
          local SkillName = Skill.GetData(skillIndex, CONST.SKILL_NAME);
          --�ؼ��ļ���
          local SheetIndex = Skill.GetSkillIndex(SheetskillId);
          local SheetName = Skill.GetData(SheetIndex, CONST.SKILL_NAME);
          --�ж������ظ�����
          for i=0,14 do
              playerskills = Char.GetSkillID(player,i);
              if (SheetskillId==playerskills) then
                  NLG.SystemMessage(player, "[ϵ�y]��ɫ�ьW���^�˼��ܣ�");
                  return;
              end
          end
          --�滻������ؼ��ļ���
          if (skillId>0) then
              Char.DelSkill(player,skillId,1);
              Char.AddSkill(player,SheetskillId,0,1);
          elseif (skillId==0) then
                  return;
          else
              Char.AddSkill(player,SheetskillId,0,1);
          end
          Char.DelItemBySlot(player, SheetSlot);
          NLG.UpChar(player);
          NLG.SystemMessage(player, "[ϵ�y]��ɫ��ɌW��[".. SheetName .."]���ܡ�");
      else
                 return;
      end
    end
  end)


end

function Module:LearnSheet(charIndex,targetIndex,itemSlot)
    ItemID = Item.GetData(Char.GetItemIndex(charIndex,itemSlot),0);
    SheetSlot = itemSlot;
    local SheetIndex = Char.GetItemIndex(charIndex,SheetSlot);
    local SheetskillId = Item.GetData(SheetIndex, CONST.����_�Ӳ�һ) or 0;
    if SheetskillId>0 then
          local msg = "1|\\n��ɫ�������� (�����I����)��\\n";
          for skillSlot=0,8 do
                local skillId = Char.GetSkillID(charIndex,skillSlot);
                local skillIndex = Skill.GetSkillIndex(skillId);
                if(skillIndex<0)then
                      msg = msg .. "��".. skillSlot+1 .."��:���o���ܡ�\\n";
                else
                      msg = msg .. "��".. skillSlot+1 .."��:��"..Skill.GetData(skillIndex, CONST.SKILL_NAME).."��\\n";
                end
          end
          NLG.ShowWindowTalked(charIndex, self.getTipsNPC, CONST.����_ѡ���, CONST.BUTTON_��ȡ��, 1, msg);
    end
    return 1;
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
