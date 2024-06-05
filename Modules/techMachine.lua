---模块类
local Module = ModuleBase:createModule('techMachine')

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback("ItemString", Func.bind(self.LearnMac, self), 'LUA_useMac');
  self.learningNPC = self:NPC_createNormal('招式學習機', 14682, { x = 38, y = 35, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.learningNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
          local msg = "4|\\n此招式學習機可以機率性地成功抽出指定的寵物技能並且抽出後再度使用道具，讓沒有此技能的寵物學習到此招式技能！\\n\\n";
          for petSlot=0,4 do
                local petIndex = Char.GetPet(player,petSlot);
                if(petIndex<0)then
                      msg = msg .. "空\\n";
                else
                      msg = msg .. ""..Char.GetData(petIndex,CONST.CHAR_名字).."\\n";
                end
          end
          NLG.ShowWindowTalked(player, self.learningNPC, CONST.窗口_选择框, CONST.按钮_关闭, 1, msg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.learningNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    print(data)
    local MacIndex = Char.GetItemIndex(player,MacSlot);
    local MactechId = Item.GetData(MacIndex, CONST.道具_子参一) or 0;
    if select > 0 then

    else
      if (seqno == 1 and select == CONST.按钮_关闭) then
                 return;
      elseif (seqno == 2 and select == CONST.按钮_关闭) then
                 return;
      elseif (seqno == 11 and select == CONST.按钮_关闭) then
                 return;
      elseif (seqno == 21 and select == CONST.按钮_关闭) then
                 return;
      end
      if (seqno == 1 and data >= 1) then
          local petSlot = data-1;
          petIndex = Char.GetPet(player,petSlot);
          if (petIndex>=0) then
              local PetId = Char.GetData(petIndex,CONST.PET_PetID);
              local enemyBaseIndex = Data.EnemyBaseGetDataIndex(PetId);
              local slotNum = Data.EnemyBaseGetData(enemyBaseIndex, CONST.EnemyBase_技能栏);
              local PetName = Char.GetData(petIndex,CONST.CHAR_名字);
              local PetNameColor = Char.GetData(petIndex, CONST.CHAR_名色);
              local msg = "1|\\n請選擇要抽取出來的寵物技能。\\n";
              for i=2,slotNum-1 do
                    local techId= Pet.GetSkill(petIndex,i);
                    local techIndex = Tech.GetTechIndex(techId);
                    if (techIndex<0) then
                          msg = msg .. "第".. i+1 .."格:  " .. "空\\n";
                    else
                          msg = msg .. "第".. i+1 .."格:  " .. ""..Tech.GetData(techIndex, CONST.TECH_NAME).."\\n";
                    end
              end
              NLG.ShowWindowTalked(player, self.learningNPC, CONST.窗口_选择框, CONST.按钮_关闭, 11, msg);
          end
      elseif (seqno == 2 and data >= 1) then
          local petSlot = data-1;
          petIndex = Char.GetPet(player,petSlot);
          if (petIndex>=0) then
              local PetId = Char.GetData(petIndex,CONST.PET_PetID);
              local enemyBaseIndex = Data.EnemyBaseGetDataIndex(PetId);
              local slotNum = Data.EnemyBaseGetData(enemyBaseIndex, CONST.EnemyBase_技能栏);
              local PetName = Char.GetData(petIndex,CONST.CHAR_名字);
              local PetNameColor = Char.GetData(petIndex, CONST.CHAR_名色);
              local msg = "1|\\n請選擇覆蓋或學習寵物技能的位置。\\n";
              for i=2,slotNum-1 do
                    local techId= Pet.GetSkill(petIndex,i);
                    local techIndex = Tech.GetTechIndex(techId);
                    if (techIndex<0) then
                          msg = msg .. "第".. i+1 .."格:  " .. "空\\n";
                    else
                          msg = msg .. "第".. i+1 .."格:  " .. ""..Tech.GetData(techIndex, CONST.TECH_NAME).."\\n";
                    end
              end
              NLG.ShowWindowTalked(player, self.learningNPC, CONST.窗口_选择框, CONST.按钮_关闭, 21, msg);
          end
      elseif (seqno == 11 and data >= 1) then
          local techSlot = data+1;
          local techId= Pet.GetSkill(petIndex,techSlot);
          local techIndex = Tech.GetTechIndex(techId);
          local techName = Tech.GetData(techIndex, CONST.TECH_NAME);
          if (techId<0) then
              NLG.SystemMessage(player, "[系統]無法辨識的招式。");
              return;
          end
          if (techId~=7300 and techId~=7400 and techId~=15002 and techId~=16000) then
              Item.SetData(MacIndex, CONST.道具_名字, "[".. techName .."]招式學習機");
              Item.SetData(MacIndex, CONST.道具_子参一, techId);
              Item.UpItem(player, MacSlot);
              NLG.UpChar(player);
              NLG.SystemMessage(player, "[系統]獲得[".. techName .."]招式學習機。");
          else
              NLG.SystemMessage(player, "[系統]確定要選這麼普通的招式？");
              return;
          end
      elseif (seqno == 21 and data >= 1) then
          --宠物原本的技能
          local techSlot = data+1;
          local techId= Pet.GetSkill(petIndex,techSlot);
          local PetName = Char.GetData(petIndex,CONST.CHAR_名字);
          --招式机储存的技能
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
          NLG.SystemMessage(player, "[系統]"..PetName.."學習[".. techName .."]招式。");
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
    local techId = Item.GetData(MacIndex, CONST.道具_子参一) or 0;
    if techId==0 then
          local msg = "4|\\n此招式學習機可以機率性地成功抽出指定的寵物技能並且抽出後再度使用道具，讓沒有此技能的寵物學習到此招式技能！\\n\\n";
          for petSlot=0,4 do
                local petIndex = Char.GetPet(charIndex,petSlot);
                if(petIndex<0)then
                      msg = msg .. "空\\n";
                else
                      msg = msg .. ""..Char.GetData(petIndex,CONST.CHAR_名字).."\\n";
                end
          end
          NLG.ShowWindowTalked(charIndex, self.learningNPC, CONST.窗口_选择框, CONST.按钮_关闭, 1, msg);
    elseif techId>0 then
          local msg = "4|\\n此招式學習機可以機率性地成功抽出指定的寵物技能並且抽出後再度使用道具，讓沒有此技能的寵物學習到此招式技能！\\n\\n";
          for petSlot=0,4 do
                local petIndex = Char.GetPet(charIndex,petSlot);
                if(petIndex<0)then
                      msg = msg .. "空\\n";
                else
                      msg = msg .. ""..Char.GetData(petIndex,CONST.CHAR_名字).."\\n";
                end
          end
          NLG.ShowWindowTalked(charIndex, self.learningNPC, CONST.窗口_选择框, CONST.按钮_关闭, 2, msg);
    end
    return 1;
end

--获取宠物装备-水晶
Pet.GetCrystal = function(petIndex)
  local ItemIndex = Char.GetItemIndex(petIndex, CONST.宠道栏_水晶);
  if ItemIndex >= 0 and Item.GetData(ItemIndex, CONST.道具_类型)==CONST.道具类型_宠物水晶 then
    return ItemIndex,CONST.宠道栏_水晶;
  end
  return -1,-1;
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
