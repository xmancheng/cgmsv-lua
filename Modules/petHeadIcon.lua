---模块类
local PetHeadIcon = ModuleBase:createModule('petHeadIcon')

--- 加载模块钩子
function PetHeadIcon:onLoad()
  self:logInfo('load')
  self:regCallback('PetFieldEvent', function(CharIndex, PetIndex, PetPos)
    local a6, a1, a2, a3, a4, a5 = Char.GetPetRank(CharIndex,PetPos);
    if (a6==0) then
        --NLG.SetHeadIcon(PetIndex,110060)
        Char.SetData(PetIndex, CONST.对象_PET_HeadGraNo,110060)
        NLG.UpChar(PetIndex);
    end
    return 0;
  end)

  self:regCallback('GatherItemEvent', function(charIndex, skillId, skillLv, itemNo)
    for Slot=0,4 do
        local petIndex = Char.GetPet(charIndex, Slot);
        if (petIndex>0 and Char.GetData(petIndex,CONST.PET_DepartureBattleStatus)==CONST.PET_STATE_战斗) then
            if (itemNo>0 and Char.GetData(petIndex,CONST.宠物_PETID)==401275) then
                  local injury = Char.GetData(charIndex, CONST.CHAR_受伤);
                  local PalLife = Char.GetData(petIndex,CONST.对象_血);
                  local Hit = PalLife-injury;
                  if ( injury < 1) then
                      return;
                  else
                      if (Hit>0) then
                          Char.SetData(petIndex,CONST.对象_血,Hit);
                          Pet.UpPet(charIndex,petIndex);
                          Char.SetData(charIndex, CONST.CHAR_受伤, 0);
                          NLG.UpChar(charIndex);
                          NLG.SystemMessage(charIndex, "[系統]你的寵物給予你治療");
                      else
                          NLG.SystemMessage(charIndex, "[系統]你的寵物需要休息了");
                      end
                  end
            elseif (itemNo>0 and Char.GetData(petIndex,CONST.宠物_PETID)==401276) then
                  local burst = NLG.Rand(1, 5);
                  if (itemNo==70162 or itemNo==70163) then
                      if (burst==1) then
                          Char.GiveItem(charIndex, itemNo, 3);
                          NLG.SortItem(charIndex);
                          NLG.SystemMessage(charIndex, "[系統]雅芙莉特幫忙採集");
                      end
                  end
            elseif (itemNo>0 and Char.GetData(petIndex,CONST.宠物_PETID)==401277) then
                  local burst = NLG.Rand(1, 5);
                  if (itemNo==70162 or itemNo==70163) then
                      if (burst==1) then
                          Char.GiveItem(charIndex, itemNo, 3);
                          NLG.SortItem(charIndex);
                          NLG.SystemMessage(charIndex, "[系統]雅芙莉特幫忙採集");
                      end
                  end
                  local injury = Char.GetData(charIndex, CONST.CHAR_受伤);
                  local PalLife = Char.GetData(petIndex,CONST.对象_血);
                  local Hit = PalLife-injury;
                  if ( injury < 1) then
                      return;
                  else
                      if (Hit>0) then
                          Char.SetData(petIndex,CONST.对象_血,Hit);
                          Pet.UpPet(charIndex,petIndex);
                          Char.SetData(charIndex, CONST.CHAR_受伤, 0);
                          NLG.UpChar(charIndex);
                          NLG.SystemMessage(charIndex, "[系統]你的寵物給予你治療");
                      else
                          NLG.SystemMessage(charIndex, "[系統]你的寵物需要休息了");
                      end
                  end
            end

        end
    end
    return;
  end)

end

Char.GetPetRank = function(playerIndex,slot)
  local petIndex = Char.GetPet(playerIndex, slot);
  if petIndex >= 0 then
    local arr_rank1 = Pet.GetArtRank(petIndex,CONST.PET_体成);
    local arr_rank2 = Pet.GetArtRank(petIndex,CONST.PET_力成);
    local arr_rank3 = Pet.GetArtRank(petIndex,CONST.PET_强成);
    local arr_rank4 = Pet.GetArtRank(petIndex,CONST.PET_敏成);
    local arr_rank5 = Pet.GetArtRank(petIndex,CONST.PET_魔成);
    local arr_rank11 = Pet.FullArtRank(petIndex, CONST.PET_体成);
    local arr_rank21 = Pet.FullArtRank(petIndex, CONST.PET_力成);
    local arr_rank31 = Pet.FullArtRank(petIndex, CONST.PET_强成);
    local arr_rank41 = Pet.FullArtRank(petIndex, CONST.PET_敏成);
    local arr_rank51 = Pet.FullArtRank(petIndex, CONST.PET_魔成);
    local a1 = math.abs(arr_rank11 - arr_rank1);
    local a2 = math.abs(arr_rank21 - arr_rank2);
    local a3 = math.abs(arr_rank31 - arr_rank3);
    local a4 = math.abs(arr_rank41 - arr_rank4);
    local a5 = math.abs(arr_rank51 - arr_rank5);
    local a6 = a1 + a2+ a3+ a4+ a5;
    return a6, a1, a2, a3, a4, a5;
  end
  return -1;
end

--- 卸载模块钩子
function PetHeadIcon:onUnload()
  self:logInfo('unload')
end

return PetHeadIcon;
