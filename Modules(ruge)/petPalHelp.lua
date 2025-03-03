---模块类
local Module = ModuleBase:createModule('petPalHelp')

local palList = {
{ petID=600021, type=1, heal=20, pickitem=-1, pickitemNum=0},  --治疗
{ petID=600101, type=2, heal=0, pickitem=510222, pickitemNum=4},  --采集
{ petID=600102, type=2, heal=0, pickitem=510233, pickitemNum=4},  --采集
{ petID=600103, type=2, heal=0, pickitem=510255, pickitemNum=4},  --采集
{ petID=600104, type=2, heal=0, pickitem=510244, pickitemNum=4},  --采集
{ petID=600067, type=3, heal=10, pickitem=900504, pickitemNum=3},  --治疗+采集
{ petID=600068, type=3, heal=10, pickitem=900504, pickitemNum=3},  --治疗+采集
}

local EnemySet = {}
local BaseLevelSet = {}
local EnemySet_WC = {700019,700019,700020,700020}
local EnemySet_WG = {700049,700050,700051,700052,700053,700054,700055,700056,700057}
local EnemySet_WR = {700058,700059,700060,700061,700062,700063,700064,700065,700066}
local EnemySet_WV = {700067,700068,700069,700070,700071,700072}
local EnemyArea = {EnemySet_WC,EnemySet_WG,EnemySet_WR,EnemySet_WV}

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('GatherItemEvent', function(charIndex, skillId, skillLv, itemNo)
    if (skillId==254) then
        local burst = NLG.Rand(1, 100);
        if (Char.ItemNum(charIndex, 900671)>=1 and burst==51) then
            local enemyNum= NLG.Rand(1,3);
            for enemyslot=1,enemyNum do
                local EncountRate = {1,1,1,1,1,1,1,1,2,2,2,2,3,3,4}
                local xr = EncountRate[NLG.Rand(1,15)];
                local xxr= NLG.Rand(1,#EnemyArea[xr]);
                local Enemy = EnemyArea[xr][xxr];
                EnemySet[enemyslot]=Enemy;
                BaseLevelSet[enemyslot]=100;
            end
            --Char.DelItem(charIndex, 900671, 1);
            Battle.PVE( charIndex, charIndex, nil, EnemySet, BaseLevelSet, nil);
        end
    end
    for Slot=0,4 do
        local petIndex = Char.GetPet(charIndex, Slot);
        if (petIndex>0 and Char.GetData(petIndex,CONST.PET_DepartureBattleStatus)==CONST.PET_STATE_战斗) then
            local PETID = Char.GetData(petIndex,CONST.宠物_PETID);
            table.forEach(palList, function(e)
              if (itemNo>0 and PETID == e.petID)  then
                  if (e.type==2 or e.type==3) then
                      local burst = NLG.Rand(1, 5);
                      if (itemNo==e.pickitem and e.pickitemNum>0) then
                          if (burst==1) then
                              Char.GiveItem(charIndex, itemNo, e.pickitemNum);
                              NLG.SortItem(charIndex);
                              NLG.SystemMessage(charIndex, "[系統]你的寵物幫忙採集多增加"..e.pickitemNum.."個");
                          end
                      end
                  end
                  if (e.type==1 or e.type==3) then
                      local injury = Char.GetData(charIndex, CONST.CHAR_受伤);
                      if ( injury < 1) then
                          return;
                      else
                          if (injury>0 and e.heal>0) then
                              Char.SetData(charIndex, CONST.CHAR_受伤, injury-e.heal);
                              if (injury - e.heal<=0) then
                                  Char.SetData(charIndex, CONST.CHAR_受伤, 0);
                              end
                              NLG.UpChar(charIndex);
                              NLG.SystemMessage(charIndex, "[系統]你的寵物給予你治療傷勢"..e.heal.."點");
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


--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
