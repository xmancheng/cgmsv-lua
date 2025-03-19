---模块类
local Module = ModuleBase:createModule('skillSheet')

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback("ItemString", Func.bind(self.LearnSheet, self), 'LUA_useSheet');
  self.getTipsNPC = self:NPC_createNormal('技能秘笈', 14682, { x = 36, y = 29, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.getTipsNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
          local msg = "1|\\n角色技能秘笈 (仍有職業限制)！\\n";
          for skillSlot=0,8 do
                local skillId = Char.GetSkillID(player,skillSlot);
                local skillIndex = Skill.GetSkillIndex(skillId);
                if(skillIndex<0)then
                      msg = msg .. "第".. skillSlot+1 .."格:〈無技能〉\\n";
                else
                      msg = msg .. "第".. skillSlot+1 .."格:〈"..Skill.GetData(skillIndex, CONST.SKILL_NAME).."〉\\n";
                end
          end
          NLG.ShowWindowTalked(player, self.getTipsNPC, CONST.窗口_选择框, CONST.BUTTON_下取消, 1, msg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.getTipsNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --print(data)
    local SheetIndex = Char.GetItemIndex(player,SheetSlot);
    local SheetskillJob = Item.GetData(SheetIndex, CONST.道具_特殊类型) or 0;
    local SheetskillId = Item.GetData(SheetIndex, CONST.道具_子参一) or 0;
    local SheetskillLv = Item.GetData(SheetIndex, CONST.道具_子参二) or 1;
    if select > 0 then
      if (seqno == 1 and select == CONST.按钮_关闭) then
                 return;
      elseif (seqno == 2 and select == CONST.按钮_关闭) then
                 return;
      elseif (seqno == 11 and select == CONST.按钮_关闭) then
                 return;
      end
          local slotNum = Char.GetData(player, CONST.CHAR_技能栏);
          local msg = "1|\\n角色技能秘笈 (仍有職業限制)！\\n";
          for skillSlot=9, slotNum-1 do
                local skillId = Char.GetSkillID(player,skillSlot);
                local skillIndex = Skill.GetSkillIndex(skillId);
                if(skillIndex<0)then
                      msg = msg .. "第".. skillSlot+1 .."格:〈無技能〉\\n";
                else
                      msg = msg .. "第".. skillSlot+1 .."格:〈"..Skill.GetData(skillIndex, CONST.SKILL_NAME).."〉\\n";
                end
          end
          NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.按钮_关闭, 2, msg);

    else
      if (seqno >= 1 and data >= 1) then
          if (SheetskillJob~=0) then
            if (Char.GetData(player,CONST.对象_职类ID)~=SheetskillJob) then
                NLG.SystemMessage(player, "[系統]職業不符無法學習！");
                return;
            end
          end
          --原本的技能
          local skillSlot = data-1;
          if (seqno == 2) then
              skillSlot = 9 + data-1;
          end
          local skillId = Char.GetSkillID(player,skillSlot) or -1;
          local skillIndex = Skill.GetSkillIndex(skillId);
          local SkillName = Skill.GetData(skillIndex, CONST.SKILL_NAME);
          --秘籍的技能
          local SheetIndex = Skill.GetSkillIndex(SheetskillId);
          local SheetName = Skill.GetData(SheetIndex, CONST.SKILL_NAME);
          --判定有无重复技能
          for i=0,14 do
              playerskills = Char.GetSkillID(player,i);
              if (SheetskillId==playerskills) then
                if (SheetskillLv<=Char.GetSkillLevel(player,i)) then
                  NLG.SystemMessage(player, "[系統]角色已學習過此技能！");
                  return;
                end
              end
          end
          local expPlus = 0;
          if SheetskillLv==4 then
            expPlus = 19800;
          elseif SheetskillLv==6 then
            expPlus = 82800;
          elseif SheetskillLv==8 then
            expPlus = 183600;
          end
          --替换或给予秘籍的技能
          if (skillId>0) then
              Char.DelSkill(player,skillId,1);
              Char.AddSkill(player,SheetskillId,0,1);
              Char.SetSkillExp(player,skillSlot,expPlus,1);	--直升10级技能经验322200
              Char.SetSkillLevel(player,skillSlot,SheetskillLv,1);	--直升10级技能
          elseif (skillId==0) then
                  return;
          else
              Char.AddSkill(player,SheetskillId,0,1);
              Char.SetSkillExp(player,skillSlot,expPlus,1);	--直升10级技能经验322200
              Char.SetSkillLevel(player,skillSlot,SheetskillLv,1);	--直升10级技能
          end
          Char.DelItemBySlot(player, SheetSlot);
          NLG.UpChar(player);
          NLG.SystemMessage(player, "[系統]角色完成學習[".. SheetName .."]技能Lv"..SheetskillLv.."。");
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
    local SheetskillJob = Item.GetData(SheetIndex, CONST.道具_特殊类型) or 0;
    local SheetskillId = Item.GetData(SheetIndex, CONST.道具_子参一) or 0;
    local SheetskillLv = Item.GetData(SheetIndex, CONST.道具_子参二) or 1;
    if SheetskillId>0 then
          local msg = "1|\\n角色技能秘笈 (仍有職業限制)！\\n";
          for skillSlot=0,8 do
                local skillId = Char.GetSkillID(charIndex,skillSlot);
                local skillIndex = Skill.GetSkillIndex(skillId);
                if(skillIndex<0)then
                      msg = msg .. "第".. skillSlot+1 .."格:〈無技能〉\\n";
                else
                      msg = msg .. "第".. skillSlot+1 .."格:〈"..Skill.GetData(skillIndex, CONST.SKILL_NAME).."〉\\n";
                end
          end
          NLG.ShowWindowTalked(charIndex, self.getTipsNPC, CONST.窗口_选择框, CONST.BUTTON_下取消, 1, msg);
    end
    return 1;
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
