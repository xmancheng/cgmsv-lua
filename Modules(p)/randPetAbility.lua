---ģ����
local Module = ModuleBase:createModule('randPetAbility')

local PetID = {801,600029,600030,600032,600033,600046,600047,600048,600049,600054,600060}
local IdentifyType={}
IdentifyType[1]={40,35,30,20,20}	--������I
IdentifyType[2]={30,40,20,35,20}	--�ų���I
IdentifyType[3]={30,20,40,20,35}	--׃����I
IdentifyType[4]={20,35,20,40,30}	--������I
IdentifyType[5]={20,20,30,35,40}	--�߬F����I
IdentifyType[6]={33,35,30,33,35}	--���|��I

--- ����ģ�鹳��
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
              if ( enemy>=0 and Char.GetData(enemy,CONST.CHAR_�ȼ�)==1 and Char.IsEnemy(enemy) ) then
                  local enemyId = Char.GetData(enemy,CONST.����_ENEMY_ID);
                  local EnemyBaseId = Data.GetEnemyBaseIdByEnemyId(enemyId);
                  --local EnemyDataIndex = Data.EnemyGetDataIndex(enemyId);
                  --local EnemyId = Data.EnemyGetData(EnemyDataIndex, CONST.Enemy_Base���);
                  local randType = NLG.Rand(1,#IdentifyType);
                  --print(EnemyBaseId,EnemyId,randType)
                  if (CheckInTable(PetID,EnemyBaseId)==true and Char.ItemNum(player,900504)>0) then
                      Char.DelItem(player,900504,1);
                      local type_Tbl = IdentifyType[randType]
                      local BYTL1 = Pet.SetArtRank(enemy,CONST.�赵_���, type_Tbl[1] - math.random(0,4));
                      local BYTL2 = Pet.SetArtRank(enemy,CONST.�赵_����, type_Tbl[2] - math.random(0,4));
                      local BYTL3 = Pet.SetArtRank(enemy,CONST.�赵_ǿ��, type_Tbl[3] - math.random(0,4));
                      local BYTL4 = Pet.SetArtRank(enemy,CONST.�赵_����, type_Tbl[4] - math.random(0,4));
                      local BYTL5 = Pet.SetArtRank(enemy,CONST.�赵_ħ��, type_Tbl[5] - math.random(0,4));
                      Char.SetData(enemy,CONST.CHAR_��ɫ,6);
                      NLG.UpChar(enemy);
                      local TL3 = Pet.GetArtRank(enemy,CONST.�赵_���);
                      local GJ3 = Pet.GetArtRank(enemy,CONST.�赵_����);
                      local FY3 = Pet.GetArtRank(enemy,CONST.�赵_ǿ��);
                      local MJ3 = Pet.GetArtRank(enemy,CONST.�赵_����);
                      local MF3 = Pet.GetArtRank(enemy,CONST.�赵_ħ��);
                      if Char.GetData(player,CONST.����_���忪��) == 1  then
                          NLG.Say(player,-1,"�����S�C׃�Q��ͣ��w��".. TL3.."������".. GJ3.."������".. FY3.."���١�".. MJ3.."��ħ��".. MF3.."��",4,3);
                      end
                  end
              end
         end
    end
end

function CheckInTable(_idTab, _idVar) ---ѭ������
	for k,v in pairs(_idTab) do
		if v==_idVar then
			return true
		end
	end
	return false
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;