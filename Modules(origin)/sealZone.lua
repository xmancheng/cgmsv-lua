---ģ����
local Module = ModuleBase:createModule('sealZone')

local EnemySet = {}
local BaseLevelSet = {}
--local EnemySet_WC = {700019,700019,700020,700020}
--local EnemySet_WG = {606025,606026,606027,700043,700044}
--local EnemySet_WR = {700054,700056,700060,700061}
--local EnemySet_WV = {700051,700052,700057,700058,700062,700063}
--local EnemyArea = {EnemySet_WC,EnemySet_WG,EnemySet_WR,EnemySet_WV}

local gradeLevel = 135;	--У���ܵ��α�׼
local BabyEnemy = {
      { popEnemy=1000, baitItem=14848, popArea={map=100,LX=0,LY=0, RX=839,RY=609} },		--��������
      { popEnemy=1003, baitItem=14942, popArea={map=100,LX=451,LY=150, RX=498,RY=250} },	--�粼��
}

local petMettleTable = {
          {9610,9619,9620,9629},       --��BOSS��,��BOSS��,��������,��аħ��
          {9611,9615,9623,9624},       --�Ե���,�Եؼ�,�Է�����,��������
          {9612,9616,9627,9628},       --��ˮ��,��ˮ��,��������,�Խ�����
          {9613,9617,9621,9626},       --�Ի���,�Ի��,��������,��Ұ����
          {9614,9618,9622,9625},       --�Է���,�Է��,�Բ�����,��ֲ����
}
-----------------------------------------------------------------------------------------------
--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  --self:regCallback('ItemUseEvent', Func.bind(self.onItemUseEvent, self));
  self:regCallback('SealEvent', Func.bind(self.OnSealEventCallBack, self));
  self:regCallback('BattleOverEvent', Func.bind(self.battleOverEventCallback, self));
  self:regCallback('LoginEvent', Func.bind(self.battleOverEventCallback, self));
  self:regCallback('LogoutEvent', Func.bind(self.battleOverEventCallback, self));
  --��������
  self:regCallback('GatherItemEvent', function(charIndex, skillId, skillLv, itemNo)
    if (skillId==225) then
        local Target_FloorId = Char.GetData(charIndex,CONST.CHAR_��ͼ);
        local Target_X = Char.GetData(charIndex,CONST.CHAR_X);
        local Target_Y = Char.GetData(charIndex,CONST.CHAR_Y);
        local burst = NLG.Rand(1,100);
        for k, v in ipairs(BabyEnemy) do
            local baitSlot = Char.FindItemId(charIndex,v.baitItem);
            if baitSlot>0 then
                local ItemIndex = Char.GetItemIndex(charIndex, baitSlot);
                local baitNum = tonumber(Item.GetData(ItemIndex,CONST.����_�ѵ���));
                if (baitNum>=1 and Target_FloorId==v.popArea.map and Target_X>=v.popArea.LX and Target_Y>=v.popArea.LY and Target_X<=v.popArea.RX and Target_Y<=v.popArea.RY) then
                    EnemySet[1]=v.popEnemy;
                    BaseLevelSet[1]=2;
                    if (baitNum>=burst) then
                        Char.DelItemBySlot(charIndex, baitSlot);
                        Battle.PVE( charIndex, charIndex, nil, EnemySet, BaseLevelSet, nil);
                    end
                end
            end
        end
--[[
            local enemyNum= NLG.Rand(1,3);
            for enemyslot=1,enemyNum do
                local EncountRate = {1,1,1,1,1,1,1,1,2,2,2,2,3,3,4}
                local xr = EncountRate[NLG.Rand(1,15)];
                local xxr= NLG.Rand(1,#EnemyArea[xr]);
                local Enemy = EnemyArea[xr][xxr];
                EnemySet[enemyslot]=Enemy;
                BaseLevelSet[enemyslot]=100;
            end
]]
    end
  end)

end

-----------------------------------------------------------------------------------------------
---����Ϊ��function����
--��ӡ������ʹ������
function Module:onItemUseEvent(charIndex, targetCharIndex, itemSlot)
  local itemIndex = Char.GetItemIndex(charIndex,itemSlot);
  local battleIndex = Char.GetBattleIndex(charIndex);
  local ItemID = Item.GetData(itemIndex, CONST.����_ID);
  local Target_FloorId = Char.GetData(charIndex,CONST.CHAR_��ͼ)
  if (Item.GetData(itemIndex, CONST.����_����)==40) then
      if (battleIndex==-1 and Battle.IsWaitingCommand(charIndex)<=0) then
               NLG.SystemMessage(charIndex,"[������ʾ]���Y�в���ʹ�õĵ���");
               return -1;
      elseif (Target_FloorId==20233 and ItemID~=75014) then
               NLG.SystemMessage(charIndex,"[������ʾ]Ո�����C��׽��");
               return -1;
      else
               return 0;
      end
  end
end

--��ӡ���
function Module:OnSealEventCallBack(charIndex, enemyIndex, ret)
  --self:logDebug('OnSealEventCallBack', charIndex, enemyIndex, ret)
         local battleIndex = Char.GetBattleIndex(charIndex);
         local capture = Char.GetSkillLv(charIndex, Char.HaveSkill(charIndex,69) ) or 0;
         local Target_FloorId = Char.GetData(charIndex,CONST.CHAR_��ͼ);
         local EmptySlot = Char.GetPetEmptySlot(charIndex);
         local SealSlot = Char.GetTempData(charIndex, 'SealOn') or -1;
         if (Char.PetNum(charIndex)==5) then
             NLG.SystemMessage(charIndex,"[ϵ�y]������ѝM�o��ץȡ");
         end
         if (SealSlot>=0) then
             NLG.SystemMessage(charIndex,"[ϵ�y]һ�����Yֻ�ܷ�ӡһ�b����");
             ret=-1;
             return ret;
         end
         local defHpE = Char.GetData(enemyIndex,CONST.CHAR_Ѫ);
         local defHpEM = Char.GetData(enemyIndex,CONST.CHAR_���Ѫ);
         local HpE05 = defHpE/defHpEM;
         local getit= NLG.Rand(1, math.ceil(HpE05*3) );
         local LvE = math.ceil(Char.GetData(enemyIndex,CONST.CHAR_�ȼ�)*0.8);
         local LvMR = NLG.Rand(1,250);
         local a61 = Char.GetEnemyAllRank(enemyIndex);
         if (Char.IsEnemy(enemyIndex) and Battle.GetType(battleIndex)==CONST.ս��_��ͨ and Char.GetData(enemyIndex, CONST.CHAR_EnemyBossFlg)==0) then
             local RandCap = capture*25;
             local CAPTURE = NLG.Rand(0,255);
             if (a61<=140 and CAPTURE<=RandCap and getit==1 and LvMR>=LvE) then
                 ret=1;
             elseif (a61>140) then
                 NLG.SystemMessage(charIndex,"[ϵ�y]����o����ӡ");
                 ret=-1;
                 return ret;
             end
             if (ret==1) then
                 if (a61 <= gradeLevel) then
                     local resmax = gradeLevel-a61;
                     local resmin = gradeLevel-a61-5;
                     local type = NLG.Rand(1,2);
                     local BPdistribute = { {5,resmax,0,5}, {0,0,5,resmax} };
                     repeat
                          res1 = NLG.Rand(0, math.ceil(resmin/2) );
                          res2 = NLG.Rand(BPdistribute[type][1], BPdistribute[type][2] );
                          res3 = NLG.Rand(0, math.ceil(resmin/4) );
                          res4 = NLG.Rand(0, math.ceil(resmin/2) );
                          res5 = NLG.Rand(BPdistribute[type][3], BPdistribute[type][4] );
                          max2 = res1+res2+res3+res4+res5;
                          if (max2 > resmax or max2 < resmin) then
                              --print('�����ϣ����ԡ�')
                          end
                     until (max2 < resmax) and (max2 > resmin)
                 end
                 local arr_rank1 = Pet.GetArtRank(enemyIndex,CONST.�赵_���);
                 local arr_rank2 = Pet.GetArtRank(enemyIndex,CONST.�赵_����);
                 local arr_rank3 = Pet.GetArtRank(enemyIndex,CONST.�赵_ǿ��);
                 local arr_rank4 = Pet.GetArtRank(enemyIndex,CONST.�赵_����);
                 local arr_rank5 = Pet.GetArtRank(enemyIndex,CONST.�赵_ħ��);
                 local BYTL1 = Pet.SetArtRank(enemyIndex,CONST.�赵_���, arr_rank1 + res1);
                 local BYTL2 = Pet.SetArtRank(enemyIndex,CONST.�赵_����, arr_rank2 + res2);
                 local BYTL3 = Pet.SetArtRank(enemyIndex,CONST.�赵_ǿ��, arr_rank3 + res3);
                 local BYTL4 = Pet.SetArtRank(enemyIndex,CONST.�赵_����, arr_rank4 + res4);
                 local BYTL5 = Pet.SetArtRank(enemyIndex,CONST.�赵_ħ��, arr_rank5 + res5);
                 NLG.UpChar(enemyIndex);
                 Char.SetTempData(charIndex, 'SealOn', EmptySlot);
             end
         end
  return ret;
end

--������ע����ʼ��
function Module:battleOverEventCallback(battleIndex)
  for i = 0, 9 do
        local charIndex = Battle.GetPlayer(battleIndex, i);
        if charIndex >= 0 then
              local SealSlot = Char.GetTempData(charIndex, 'SealOn') or -1;
              if SealSlot>=0 then
                 local PetIndex = Char.GetPet(charIndex, SealSlot);
                 local typeRand = math.random(1,#petMettleTable);
                 local pos = math.random(1,#petMettleTable[typeRand]);
                 Pet.AddSkill(PetIndex, petMettleTable[typeRand][pos], 9);
                 Char.SetData(PetIndex,CONST.����_ԭ��, Char.GetData(PetIndex,CONST.����_ԭ��).."���N");
                 Pet.UpPet(charIndex,PetIndex);
                 NLG.UpChar(charIndex);
                 Char.SetTempData(charIndex, 'SealOn', -1);
              end
        end
  end
end

Char.GetPetEmptySlot = function(charIndex)
  for Slot=0,4 do
      local PetIndex = Char.GetPet(charIndex, Slot);
      --print(PetIndex);
      if (PetIndex < 0) then
          return Slot;
      end
  end
  return -1;
end

Char.GetEnemyAllRank = function(enemyIndex)
  local enemyIndex = enemyIndex;
  if enemyIndex >= 0 then
    local a11 = Pet.FullArtRank(enemyIndex, CONST.PET_���);
    local a21 = Pet.FullArtRank(enemyIndex, CONST.PET_����);
    local a31 = Pet.FullArtRank(enemyIndex, CONST.PET_ǿ��);
    local a41 = Pet.FullArtRank(enemyIndex, CONST.PET_����);
    local a51 = Pet.FullArtRank(enemyIndex, CONST.PET_ħ��);
    local a61 = a11 + a21+ a31+ a41+ a51;
    return a61, a11, a21, a31, a41, a51;
  end
  return -1;
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
