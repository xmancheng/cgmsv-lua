---模块类
local Module = ModuleBase:createModule('petRush')

local eventGoal = 600018;
local goalLevel_min = 50;
local goalLevel_max = 70;
local eventLuckyNum = 6;
local eventItemID = {}
eventItemID[1] = {75020,75021,75022,75023}	--A等獎
eventItemID[2] = {75020,75021,75022,75023}	--B等獎
eventItemID[3] = {75020,75021,75022,75023}	--C等獎
eventItemID[4] = {75020,75021,75022,75023}	--D等獎
------------------------------------------------------------------------------------------------
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self.bountyNPC = self:NPC_createNormal('寶可夢懸賞單', 11797, { x = 245, y = 79, mapType = 0, map = 1000, direction = 0 });
  self:NPC_regTalkedEvent(self.bountyNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
          local EnemyDataIndex = Data.EnemyGetDataIndex(eventGoal);		--enemyId
          local enemyBaseId = Data.EnemyGetData(EnemyDataIndex, CONST.Enemy_Base编号);
          local EnemyBaseDataIndex = Data.EnemyBaseGetDataIndex(enemyBaseId);	--enemyBaseId
          local eventGoalName = Data.EnemyBaseGetData(EnemyBaseDataIndex, CONST.EnemyBase_名字);
          local msg = "　　　　　　　【寶可夢練等兌獎活動】\\n"
                              .. "　本期時間：2024/07/15 - 2024/08/31\\n"
                              .. "　本期目標：".. eventGoalName .."\\n"
                              .. "　限制等級："..goalLevel_min.."-"..goalLevel_max.."\\n\\n"
                              .. "　　※玩法：生命、魔力、攻擊、防禦、敏捷\\n"
                              .. "　　五圍數值中尾數符合幾個： "..eventLuckyNum.." 呢？\\n"
                              .. "　　4 個：A獎【羈絆技能招式機】\\n"
                              .. "　　3 個：B獎【強力技能招式機】\\n"
                              .. "　　2 個：C獎【性格技能招式機】\\n"
                              .. "　　1 個：D獎【五級技能招式機】\\n";
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
              if (count==4) then
                 local rand = NLG.Rand(1,#eventItemID[1]);
                 Char.GiveItem(player, eventItemID[1][rand], 1);
                 NLG.Say(player, -1, "[系統]恭喜玩家 "..Char.GetData(player,CONST.对象_名字).." 交付懸賞A等獎。", CONST.颜色_黄色, CONST.字体_中);
              elseif (count==3) then
                 local rand = NLG.Rand(1,#eventItemID[2]);
                 Char.GiveItem(player, eventItemID[2][rand], 1);
                 NLG.Say(player, -1, "[系統]恭喜玩家 "..Char.GetData(player,CONST.对象_名字).." 交付懸賞B等獎。", CONST.颜色_黄色, CONST.字体_中);
              elseif (count==2) then
                 local rand = NLG.Rand(1,#eventItemID[3]);
                 Char.GiveItem(player, eventItemID[3][rand], 1);
                 NLG.Say(player, -1, "[系統]恭喜玩家 "..Char.GetData(player,CONST.对象_名字).." 交付懸賞C等獎。", CONST.颜色_黄色, CONST.字体_中);
              elseif (count==1) then
                 local rand = NLG.Rand(1,#eventItemID[4]);
                 Char.GiveItem(player, eventItemID[4][rand], 1);
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

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
