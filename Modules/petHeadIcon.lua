---ģ����
local PetHeadIcon = ModuleBase:createModule('petHeadIcon')

--- ����ģ�鹳��
function PetHeadIcon:onLoad()
  self:logInfo('load')
  self:regCallback('PetFieldEvent', function(CharIndex, PetIndex, PetPos)
    local a6, a1, a2, a3, a4, a5 = Char.GetPetRank(CharIndex,PetPos);
    if (a6==0) then
        --NLG.SetHeadIcon(PetIndex,110060)
        Char.SetData(PetIndex, CONST.����_PET_HeadGraNo,110060)
        NLG.UpChar(PetIndex);
    end
    return 0;
  end)
end

Char.GetPetRank = function(playerIndex,slot)
  local petIndex = Char.GetPet(playerIndex, slot);
  if petIndex >= 0 then
    local arr_rank1 = Pet.GetArtRank(petIndex,CONST.PET_���);
    local arr_rank2 = Pet.GetArtRank(petIndex,CONST.PET_����);
    local arr_rank3 = Pet.GetArtRank(petIndex,CONST.PET_ǿ��);
    local arr_rank4 = Pet.GetArtRank(petIndex,CONST.PET_����);
    local arr_rank5 = Pet.GetArtRank(petIndex,CONST.PET_ħ��);
    local arr_rank11 = Pet.FullArtRank(petIndex, CONST.PET_���);
    local arr_rank21 = Pet.FullArtRank(petIndex, CONST.PET_����);
    local arr_rank31 = Pet.FullArtRank(petIndex, CONST.PET_ǿ��);
    local arr_rank41 = Pet.FullArtRank(petIndex, CONST.PET_����);
    local arr_rank51 = Pet.FullArtRank(petIndex, CONST.PET_ħ��);
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

--- ж��ģ�鹳��
function PetHeadIcon:onUnload()
  self:logInfo('unload')
end

return PetHeadIcon;
