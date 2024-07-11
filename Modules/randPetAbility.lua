---模块类
local Module = ModuleBase:createModule('randPetAbility')

local PetID = {600029,600030,600032,600033,600046,600047,600048,600049,600054,600060}
local IdentifyType={}
IdentifyType[1]={40,35,30,20,20}	--強化型I
IdentifyType[2]={30,40,20,35,20}	--放出型I
IdentifyType[3]={30,20,40,20,35}	--變化型I
IdentifyType[4]={20,35,20,40,30}	--操作型I
IdentifyType[5]={20,20,30,35,40}	--具現化型I
IdentifyType[6]={33,35,30,33,35}	--特質型I

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BattleStartEvent', Func.bind(self.OnbattleStartEventCallback, self))
end

function Module:OnbattleStartEventCallback(battleIndex)
    if (Battle.GetType(battleIndex)==1) then
         for i=10, 19 do
              local enemy = Battle.GetPlayIndex(battleIndex, i);
              local player = Battle.GetPlayIndex(battleIndex, 0);
               --print(enemy, player)
              if ( enemy>=0 and Char.GetData(enemy,CONST.CHAR_等级)==1 and Char.IsEnemy(enemy) ) then
                  local enemyId = Char.GetData(enemy,CONST.对象_ENEMY_ID);
                  local EnemyBaseId = Data.GetEnemyBaseIdByEnemyId(enemyId);
                  --local EnemyDataIndex = Data.EnemyGetDataIndex(enemyId);
                  --local EnemyId = Data.EnemyGetData(EnemyDataIndex, CONST.Enemy_Base编号);
                  local randType = NLG.Rand(1,#IdentifyType);
                  --print(EnemyBaseId,EnemyId,randType)
                  if (CheckInTable(PetID,EnemyBaseId)==true and Char.ItemNum(player,900504)>0) then
                      Char.DelItem(player,900504,1);
                      local type_Tbl = IdentifyType[randType]
                      local BYTL1 = Pet.SetArtRank(enemy,CONST.宠档_体成, type_Tbl[1] - math.random(0,4));
                      local BYTL2 = Pet.SetArtRank(enemy,CONST.宠档_力成, type_Tbl[2] - math.random(0,4));
                      local BYTL3 = Pet.SetArtRank(enemy,CONST.宠档_强成, type_Tbl[3] - math.random(0,4));
                      local BYTL4 = Pet.SetArtRank(enemy,CONST.宠档_敏成, type_Tbl[4] - math.random(0,4));
                      local BYTL5 = Pet.SetArtRank(enemy,CONST.宠档_魔成, type_Tbl[5] - math.random(0,4));
                      Char.SetData(enemy,CONST.CHAR_名色,6);
                      NLG.UpChar(enemy);
                      local TL3 = Pet.GetArtRank(enemy,CONST.宠档_体成);
                      local GJ3 = Pet.GetArtRank(enemy,CONST.宠档_力成);
                      local FY3 = Pet.GetArtRank(enemy,CONST.宠档_强成);
                      local MJ3 = Pet.GetArtRank(enemy,CONST.宠档_敏成);
                      local MF3 = Pet.GetArtRank(enemy,CONST.宠档_魔成);
                      if Char.GetData(player,CONST.对象_家族开关) == 1  then
                          NLG.Say(player,-1,"怪物隨機變換類型：體【".. TL3.."】力【".. GJ3.."】強【".. FY3.."】速【".. MJ3.."】魔【".. MF3.."】",4,3);
                      end
                  end
              end
         end
    end
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
