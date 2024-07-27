---ģ����
local Module = ModuleBase:createModule('petPalHelp')

local palList = {
{ petID=600021, type=1, heal=20, pickitem=-1, pickitemNum=0},  --����
{ petID=600101, type=2, heal=0, pickitem=510222, pickitemNum=4},  --�ɼ�
{ petID=600102, type=2, heal=0, pickitem=510233, pickitemNum=4},  --�ɼ�
{ petID=600103, type=2, heal=0, pickitem=510255, pickitemNum=4},  --�ɼ�
{ petID=600104, type=2, heal=0, pickitem=510244, pickitemNum=4},  --�ɼ�
{ petID=600067, type=3, heal=10, pickitem=900504, pickitemNum=3},  --����+�ɼ�
{ petID=600068, type=3, heal=10, pickitem=900504, pickitemNum=3},  --����+�ɼ�
}

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('GatherItemEvent', function(charIndex, skillId, skillLv, itemNo)
    for Slot=0,4 do
        local petIndex = Char.GetPet(charIndex, Slot);
        if (petIndex>0 and Char.GetData(petIndex,CONST.PET_DepartureBattleStatus)==CONST.PET_STATE_ս��) then
            local PETID = Char.GetData(petIndex,CONST.����_PETID);
            table.forEach(palList, function(e)
              if (itemNo>0 and PETID == e.petID)  then
                  if (e.type==2 or e.type==3) then
                      local burst = NLG.Rand(1, 5);
                      if (itemNo==e.pickitem and e.pickitemNum>0) then
                          if (burst==1) then
                              Char.GiveItem(charIndex, itemNo, e.pickitemNum);
                              NLG.SortItem(charIndex);
                              NLG.SystemMessage(charIndex, "[ϵ�y]��Č����æ�񼯶�����"..e.pickitemNum.."��");
                          end
                      end
                  end
                  if (e.type==1 or e.type==3) then
                      local injury = Char.GetData(charIndex, CONST.CHAR_����);
                      if ( injury < 1) then
                          return;
                      else
                          if (injury>0 and e.heal>0) then
                              Char.SetData(charIndex, CONST.CHAR_����, injury+e.heal);
                              NLG.UpChar(charIndex);
                              NLG.SystemMessage(charIndex, "[ϵ�y]��Č���o�����ί�����"..e.heal.."�c");
                          end
                      end
                  end
              end
            end)
        end
    end
    return;
  end)

end


--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
