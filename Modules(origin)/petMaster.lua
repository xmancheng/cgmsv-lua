---模块类
local Module = ModuleBase:createModule('petMaster')

local StarSysOn = 0;
local MaxStarLv = 4;
local StarEnable_check= {700066};
local StarEnable_list = {};
StarEnable_list[700066] = { {},{},{},{} };  --★1(BP点).★2(增减伤).★3(BP点).★4(技能或技能强化)

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self.MStarNPC = self:NPC_createNormal('寵物星級超量', 104675, { x = 235, y = 116, mapType = 0, map = 1000, direction = 6 });
  self:NPC_regTalkedEvent(self.MStarNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
          local msg = "　　　　　　　　$1【寵物星級超量】\\n"
                              .. "　　　　　第一格放置要提升星級的主要寵物\\n"
                              .. "　　　　$4注意:  其餘位置將暫時為材料寵物區\\n"
          local petIndex = Char.GetPet(player,0);	--主宠固定宠物栏第一格
          if (petIndex>=0) then
              --主要宠物
              local PetId = Char.GetData(petIndex,CONST.PET_PetID);
              local PetName_1 = Char.GetData(petIndex,CONST.对象_原名);
              local PetImage_1 = Char.GetData(petIndex,CONST.对象_形象);
              local imageText_1 = "@g,"..PetImage_1..",3,8,6,0@"
              msg = msg .. "主要寵: "..PetName_1
              --材料宠物
              local materialPetIndex,mSlot = Char.GetMaterialPet(player,PetId);
              if (materialPetIndex>0) then
                  StarSysOn = 1;
                  local mSlot = mSlot+1;
                  local PetName_2 = Char.GetData(materialPetIndex,CONST.对象_原名);
                  local PetImage_2 = Char.GetData(materialPetIndex,CONST.对象_形象);
                  local imageText_2 = "@g,"..PetImage_2..",13,8,6,0@"
                  msg = msg .. "　　材料寵(第"..mSlot.."格): "..PetName_2.."\\n"
                                        .. imageText_1 .. imageText_2;
              else
                  StarSysOn = 0;
                  msg = msg .. "　　材料寵(第X格): 無符合\\n"
                                        .. imageText_1;
              end
          else
              StarSysOn = 0;
              msg = msg .. "主要寵: 非可星級超量的寵物" .. "\\n\\n\\n材料寵(第X格): 無符合\\n";
          end
          NLG.ShowWindowTalked(player, self.MStarNPC, CONST.窗口_信息框, CONST.按钮_确定关闭, 1, msg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.MStarNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    local tPlayerGold = Char.GetData(player, CONST.对象_金币);
    --print(data)
    if select > 0 then
      if (seqno == 1 and select == CONST.按钮_关闭) then
                 return;
      elseif (seqno == 1 and select == CONST.按钮_确定) then
          if (tPlayerGold<10000) then
              NLG.SystemMessage(player, "[系統] 星級系統操作每次 1萬G，所需金幣不足。");
              return;
          end
          if (StarSysOn == 1) then
              local petIndex = Char.GetPet(player,0);
              local PetId = Char.GetData(petIndex,CONST.PET_PetID);
              local PetName_1 = Char.GetData(petIndex,CONST.对象_原名);
              local materialPetIndex,mSlot = Char.GetMaterialPet(player,PetId);
              local last = string.find(PetName_1, "★", 1);
              local StarLv = string.sub(PetName_1, last+1, -1);
              local PetRawName = string.sub(PetName_1, 1, last-2);
              if (StarLv==nil) then
                  Char.SetData(petIndex,CONST.对象_原名, PetRawName .. "★1");
                  Char.DelSlotPet(player, mSlot);
                  Pet.UpPet(player,petIndex);
                  NLG.UpChar(player);
                  NLG.SystemMessage(player, "[系統] ".. PetRawName .."成功進化為★1。");
              elseif (StarLv>=1 and StarLv<MaxStarLv) then

              else
                  NLG.SystemMessage(player, "[系統] 星級已達目前開放上限。");
                  return;
              end
          elseif (StarSysOn == 0) then
              NLG.SystemMessage(player, "[系統] 條件不符合，星級系統停止操作。");
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

function CheckInTable(_idTab, _idVar) ---循环函数
	for k,v in pairs(_idTab) do
		if v==_idVar then
			return true
		end
	end
	return false
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
