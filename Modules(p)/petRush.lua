---模块类
local Module = ModuleBase:createModule('petRush')

local eventGoal = 600018;
local goalLevel_min = 50;
local goalLevel_max = 70;
local eventLuckyNum = 6;
local eventTechID = {}
eventTechID[1] = {9630,9631,9632,9633,9634,9635,9636,9637,9638,9639}	--A等獎
eventTechID[2] = {9640,9641,9642,9643,9644,9645,9646,9647,9648,9649}	--B等獎
eventTechID[3] = {9610,9619,9620,9621,9622,9623,9624,9625,9626,9627,9628,9629}	--C等獎
eventTechID[4] = {9611,9612,9613,9614,9615,9616,9617,9618,404,200504}	--D等獎
------------------------------------------------------------------------------------------------
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self.bountyNPC = self:NPC_createNormal('寶可夢懸賞單', 11797, { x = 245, y = 84, mapType = 0, map = 1000, direction = 0 });
  self:NPC_regTalkedEvent(self.bountyNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
          local EnemyDataIndex = Data.EnemyGetDataIndex(eventGoal);		--enemyId
          local enemyBaseId = Data.EnemyGetData(EnemyDataIndex, CONST.Enemy_Base编号);
          local EnemyBaseDataIndex = Data.EnemyBaseGetDataIndex(enemyBaseId);	--enemyBaseId
          local eventGoalName = Data.EnemyBaseGetData(EnemyBaseDataIndex, CONST.EnemyBase_名字);
          local msg = "　　　　　　　【寶可夢練等兌獎活動】\\n"
                              .. "　本期時間：2024/07/15 - 2024/08/31\\n"
                              .. "　本期目標：".. eventGoalName .."\\n"
                              .. "　限制等級："..goalLevel_min.."-"..goalLevel_max.."\\n"
                              .. "　　※玩法：生命、魔力、攻擊、防禦、敏捷\\n"
                              .. "　　五圍數值中尾數符合幾個： "..eventLuckyNum.." 呢？\\n"
                              .. "　　4 個：A獎.10款隨機之【羈絆增傷招式機】\\n"
                              .. "　　3 個：B獎.10款隨機之【羈絆減傷招式機】\\n"
                              .. "　　2 個：C獎.12款隨機之【性格技能招式機】\\n"
                              .. "　　1 個：D獎.【氣功彈、追月、性格招式機】\\n";
          NLG.ShowWindowTalked(player, self.bountyNPC, CONST.窗口_信息框, CONST.按钮_确定关闭, 1, msg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.bountyNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --print(data)
    if select > 0 then
      if (seqno == 1 and select == CONST.按钮_关闭) then
                 return;
      elseif (seqno == 1 and select == CONST.按钮_确定)  then
                 local msg = "3|\\n【你的寵物詳細資訊】\\n"
                                  .. "↓選擇要交出哪隻寵物，兌換懸賞級別獎勵↓\\n\\n";
                 for i=0,4 do
                       local pet = Char.GetPet(player,i);
                       if(pet<0)then
                             msg = msg .. "空\\n";
                       else
                             local count = Calcuquant(pet);
                             msg = msg .. ""..Char.GetData(pet,CONST.CHAR_名字).."　　符合的尾數有 ".. count .." 個\\n";
                       end
                 end
                 NLG.ShowWindowTalked(player, self.bountyNPC, CONST.窗口_选择框, CONST.BUTTON_关闭, 11, msg);
      elseif (seqno == 12 and select == CONST.按钮_否)  then
                 return;
      elseif (seqno == 12 and select == CONST.按钮_是) then
          petSlot = petSlot;
          local petIndex = Char.GetPet(player,petSlot);
          local count = Calcuquant(petIndex);
          if (count==0) then
                 NLG.SystemMessage(player, "[系統]再訓練看看，說不定會不一樣！");
                 return;
          end
          if (petIndex>=0) then
              local count = Calcuquant(petIndex);
              Char.DelSlotPet(player, petSlot);
              local newSlot = Char.GetEmptyItemSlot(player);
              if (count==4) then
                 local rand = NLG.Rand(1,#eventTechID[1]);
                 local techId = eventTechID[1][rand];
                 local techIndex = Tech.GetTechIndex(techId);
                 local techName = Tech.GetData(techIndex, CONST.TECH_NAME);
                 Char.GiveItem(player, 75017, 1);
                 local MacIndex = Char.GetItemIndex(player,newSlot);
                 Item.SetData(MacIndex, CONST.道具_名字, "[".. techName .."]招式學習機");
                 Item.SetData(MacIndex, CONST.道具_子参一, techId);
                 Item.UpItem(player, newSlot);
                 NLG.UpChar(player);
                 NLG.Say(player, -1, "[系統]恭喜玩家 "..Char.GetData(player,CONST.对象_名字).." 交付懸賞A等獎。", CONST.颜色_黄色, CONST.字体_中);
              elseif (count==3) then
                 local rand = NLG.Rand(1,#eventTechID[2]);
                 local techId = eventTechID[2][rand];
                 local techIndex = Tech.GetTechIndex(techId);
                 local techName = Tech.GetData(techIndex, CONST.TECH_NAME);
                 Char.GiveItem(player, 75017, 1);
                 local MacIndex = Char.GetItemIndex(player,newSlot);
                 Item.SetData(MacIndex, CONST.道具_名字, "[".. techName .."]招式學習機");
                 Item.SetData(MacIndex, CONST.道具_子参一, techId);
                 Item.UpItem(player, newSlot);
                 NLG.UpChar(player);
                 NLG.Say(player, -1, "[系統]恭喜玩家 "..Char.GetData(player,CONST.对象_名字).." 交付懸賞B等獎。", CONST.颜色_黄色, CONST.字体_中);
              elseif (count==2) then
                 local rand = NLG.Rand(1,#eventTechID[3]);
                 local techId = eventTechID[3][rand];
                 local techIndex = Tech.GetTechIndex(techId);
                 local techName = Tech.GetData(techIndex, CONST.TECH_NAME);
                 Char.GiveItem(player, 75017, 1);
                 local MacIndex = Char.GetItemIndex(player,newSlot);
                 Item.SetData(MacIndex, CONST.道具_名字, "[".. techName .."]招式學習機");
                 Item.SetData(MacIndex, CONST.道具_子参一, techId);
                 Item.UpItem(player, newSlot);
                 NLG.UpChar(player);
                 NLG.Say(player, -1, "[系統]恭喜玩家 "..Char.GetData(player,CONST.对象_名字).." 交付懸賞C等獎。", CONST.颜色_黄色, CONST.字体_中);
              elseif (count==1) then
                 local rand = NLG.Rand(1,#eventTechID[4]);
                 local techId = eventTechID[4][rand];
                 local techIndex = Tech.GetTechIndex(techId);
                 local techName = Tech.GetData(techIndex, CONST.TECH_NAME);
                 Char.GiveItem(player, 75017, 1);
                 local MacIndex = Char.GetItemIndex(player,newSlot);
                 Item.SetData(MacIndex, CONST.道具_名字, "[".. techName .."]招式學習機");
                 Item.SetData(MacIndex, CONST.道具_子参一, techId);
                 Item.UpItem(player, newSlot);
                 NLG.UpChar(player);
                 NLG.Say(player, -1, "[系統]恭喜玩家 "..Char.GetData(player,CONST.对象_名字).." 交付懸賞D等獎。", CONST.颜色_黄色, CONST.字体_中);
              end
          end
      end

    else
      if (seqno == 11 and select == CONST.按钮_关闭) then
                 return;
      elseif (seqno == 11 and data >= 1) then
          petSlot = data-1;
          local petIndex = Char.GetPet(player,petSlot);
          if (petIndex>=0) then
              local PetId = Char.GetData(petIndex,CONST.PET_PetID);
              local count = Calcuquant(petIndex);
              local goalLevel = Char.GetData(petIndex, CONST.CHAR_等级);
              if (PetId~=eventGoal) then
                 NLG.SystemMessage(player, "[系統]選擇的寵物不是懸賞目標！");
                 return;
              end
              if (goalLevel<goalLevel_min) then
                 NLG.SystemMessage(player, "[系統]寵物等級未達"..goalLevel_min.."！");
                 return;
              elseif (goalLevel>goalLevel_max) then
                 NLG.SystemMessage(player, "[系統]寵物等級超過"..goalLevel_max.."！");
                 return;
              end
              if (Char.ItemSlot(player)>18) then
                 NLG.SystemMessage(player, "[系統]請留下兩格物品欄空位！");
                 return;
              end
              local msg = "\\n@c【寶可夢練等兌獎活動】\\n"
                                  .. "　\\n"
                                  .. "　\\n"
                                  .. "是否確定要交出這隻寵物？\\n"
                                  .. "　\\n"
                                  .. "五圍數值中尾數符合: ".. count .." 個\\n";
              NLG.ShowWindowTalked(player, self.bountyNPC, CONST.窗口_信息框, CONST.按钮_是否, 12, msg);
          else
              return;
          end
      else
                 return;
      end
    end
  end)


end

function Calcuquant(pet)
         local count = 0;
         local maxLp = math.fmod(Char.GetData(pet, CONST.CHAR_最大血)/1, 10);
         local maxFp = math.fmod(Char.GetData(pet, CONST.CHAR_最大魔)/1, 10);
         local Attack = math.fmod(Char.GetData(pet,CONST.CHAR_攻击力)/1, 10);
         local Defense = math.fmod(Char.GetData(pet,CONST.CHAR_防御力)/1, 10);
         local Agile = math.fmod(Char.GetData(pet,CONST.CHAR_敏捷)/1, 10);
         if (maxLp==eventLuckyNum) then
             count = count+1;
         end
         if (maxFp==eventLuckyNum) then
             count = count+1;
         end
         if (Attack==eventLuckyNum) then
             count = count+1;
         end
         if (Defense==eventLuckyNum) then
             count = count+1;
         end
         if (Agile==eventLuckyNum) then
             count = count+1;
         end
    return count;
end

function Char.GetEmptyItemSlot(charIndex)
  if not Char.IsValidCharIndex(charIndex) then
    return -1;
  end
  if Char.GetData(charIndex, CONST.CHAR_类型) ~= CONST.对象类型_人 then
    return -1;
  end
  for i = 8, 27 do
    if Char.GetItemIndex(charIndex, i) == -2 then
      return i;
    end
  end
  return -2;
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
