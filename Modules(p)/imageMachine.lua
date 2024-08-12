---模块类
local Module = ModuleBase:createModule('imageMachine')

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback("ItemString", Func.bind(self.ImageMac, self), 'LUA_useImMac');
  self.mirageNPC = self:NPC_createNormal('形象轉換機', 14682, { x = 40, y = 35, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.mirageNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
          local msg = "4|\\n此形象轉換機可以機率性地成功抽出指定寵物的形象並且抽出後再度使用道具，讓沒有此形象的寵物轉換成為這形象！\\n\\n";
          for petSlot=0,4 do
                local petIndex = Char.GetPet(player,petSlot);
                if(petIndex<0)then
                      msg = msg .. "空\\n";
                else
                      msg = msg .. ""..Char.GetData(petIndex,CONST.CHAR_名字).."\\n";
                end
          end
          NLG.ShowWindowTalked(player, self.mirageNPC, CONST.窗口_选择框, CONST.按钮_关闭, 1, msg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.mirageNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --print(data)
    local MacIndex = Char.GetItemIndex(player,MacSlot);
    local MactechId = Item.GetData(MacIndex, CONST.道具_子参一) or 0;
    local ImageName = Item.GetData(MacIndex, CONST.道具_名字);
    if select > 0 then

    else
      if (seqno == 1 and select == CONST.按钮_关闭) then
                 return;
      elseif (seqno == 2 and select == CONST.按钮_关闭) then
                 return;
      end
      if (seqno == 1 and data >= 1) then
          if (MactechId~=0) then
              NLG.SystemMessage(player, "[系統]轉換機已有形象無法提取！");
              return;
          end
          local petSlot = data-1;
          local petIndex = Char.GetPet(player,petSlot);
          if (petIndex>=0) then
              local PetId = Char.GetData(petIndex,CONST.PET_PetID);
              local PetName = Char.GetData(petIndex,CONST.CHAR_名字);
              local PetImage = Char.GetData(petIndex, CONST.对象_形象);
              local SuccRate = 10;					--形象提取机率(%)
              if (type(SuccRate)=="number" and SuccRate>0) then
                  local tMin = 50 - math.floor(SuccRate/2) + 1;
                  local tMax = 50 + math.floor(SuccRate/2) + math.fmod(SuccRate,2);
                  local tLuck = math.random(1, 100);
                  if (tLuck>=tMin and tLuck<=tMax)  then
                      Item.SetData(MacIndex, CONST.道具_名字, "[".. PetName .."]形象轉換機");
                      Item.SetData(MacIndex, CONST.道具_子参一, PetImage);
                      Item.UpItem(player, MacSlot);
                      NLG.UpChar(player);
                      NLG.SystemMessage(player, "[系統]獲得[".. PetName .."]形象轉換機。");
                  else
                      Char.DelItemBySlot(player, MacSlot);
                      NLG.SystemMessage(player, "[系統]提取[".. PetName .."]形象失敗。");
                  end
              end
          else
              return;
          end

      elseif (seqno == 2 and data >= 1) then
          local petSlot = data-1;
          local petIndex = Char.GetPet(player,petSlot);
          if (MactechId==0) then
              NLG.SystemMessage(player, "[系統]轉換機尚未有形象無法進行轉換！");
              return;
          end
          if (petIndex>=0) then
              --local PetId = Char.GetData(petIndex,CONST.PET_PetID);
              local PetName = Char.GetData(petIndex,CONST.CHAR_名字);
              local PetImage = Char.GetData(petIndex, CONST.对象_形象);
              local last = string.find(ImageName, "]", 1);
              local ImageName = string.sub(ImageName, 2, last-1);
              if (MactechId==PetImage) then
                  NLG.SystemMessage(player, "[系統]寵物已經是這個形象！");
                  return;
              end
              Char.SetData(petIndex, CONST.对象_形象,MactechId);
              Pet.UpPet(player, petIndex);
              --Char.DelItem(player,70001,1);
              Char.DelItemBySlot(player, MacSlot);
              NLG.UpChar(player);
              NLG.SystemMessage(player, "[系統]"..PetName.."轉換成為[".. ImageName .."]形象。");
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
    local MactechId = Item.GetData(MacIndex, CONST.道具_子参一) or 0;
    if MactechId==0 then
          local msg = "4|\\n此形象轉換機可以機率性地成功抽出指定寵物的形象並且抽出後再度使用道具，讓沒有此形象的寵物轉換成為這形象！\\n\\n";
          for petSlot=0,4 do
                local petIndex = Char.GetPet(charIndex,petSlot);
                if(petIndex<0)then
                      msg = msg .. "空\\n";
                else
                      msg = msg .. ""..Char.GetData(petIndex,CONST.CHAR_名字).."\\n";
                end
          end
          NLG.ShowWindowTalked(charIndex, self.mirageNPC, CONST.窗口_选择框, CONST.按钮_关闭, 1, msg);
    elseif MactechId>0 then
          local msg = "4|\\n此形象轉換機可以機率性地成功抽出指定寵物的形象並且抽出後再度使用道具，讓沒有此形象的寵物轉換成為這形象！\\n\\n";
          for petSlot=0,4 do
                local petIndex = Char.GetPet(charIndex,petSlot);
                if(petIndex<0)then
                      msg = msg .. "空\\n";
                else
                      msg = msg .. ""..Char.GetData(petIndex,CONST.CHAR_名字).."\\n";
                end
          end
          NLG.ShowWindowTalked(charIndex, self.mirageNPC, CONST.窗口_选择框, CONST.按钮_关闭, 2, msg);
    end
    return 1;
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
