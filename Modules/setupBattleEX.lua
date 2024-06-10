---模块类
local Module = ModuleBase:createModule('setupBattleEX')

local teamBuff = {}

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('CalcCriticalRateEvent', Func.bind(self.OnCalcCriticalRateEvent, self));
  self:regCallback('BattleDodgeRateEvent', Func.bind(self.OnBattleDodgeRateEvent, self));
  self:regCallback('BattleCounterRateEvent', Func.bind(self.OnBattleCounterRateEvent, self));
  self:regCallback('BattleOverEvent', Func.bind(self.OnBattleOverEvent, self));
end

function Module:OnCalcCriticalRateEvent(aIndex, fIndex, rate)
         --self:logDebug('OnCalcCriticalRateCallBack', aIndex, fIndex, rate)
         if Char.IsPlayer(aIndex) and Char.IsEnemy(fIndex) then
               local battleIndex = Char.GetBattleIndex(aIndex);
               local leader1 = Battle.GetPlayer(battleIndex,0)
               local leader2 = Battle.GetPlayer(battleIndex,5)
               local leader = leader1
               if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
                   leader = leader2
               end
               local cdk = Char.GetData(leader,CONST.对象_CDK);
               local Round = Battle.GetTurn(battleIndex);
               local WeaponIndex = Char.GetWeapon(aIndex);                --左右手
               local Weapon_Name = Item.GetData(WeaponIndex, CONST.道具_名字);
               if Weapon_Name~=nil then
                   local wandId = Item.GetData(WeaponIndex, CONST.道具_ID);
                   if (wandId== 79256)  then
                       rate = 100;
                       local Count = tonumber(TeamBuff_Tbl(cdk,1));
                       if Count>=1 and Count<5  then
                           --Char.SetData(aIndex, CONST.对象_PET_HeadGraNo, 108510);
                           --NLG.SetHeadIcon(aIndex, 108510);
                           Char.SetTempData(leader, '白虎爪', 1);
                       elseif Count>=5 and Count<10  then
                           Char.SetTempData(leader, '白虎爪', 2);
                       elseif Count>=10 then
                           Char.SetTempData(leader, '白虎爪', 3);
                       end
                       return rate
                   end
               end
         end
         return rate
end

function Module:OnBattleDodgeRateEvent(battleIndex, aIndex, fIndex, rate)
         --self:logDebug('OnBattleDodgeRateCallBack', battleIndex, aIndex, fIndex, rate)
         if Char.IsPlayer(aIndex) and Char.IsEnemy(fIndex) then
               local cdk = Char.GetData(aIndex,CONST.对象_CDK);
               local battleIndex = Char.GetBattleIndex(aIndex);
               local leader1 = Battle.GetPlayer(battleIndex,0)
               local leader2 = Battle.GetPlayer(battleIndex,5)
               local leader = leader1
               if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
                   leader = leader2
               end
               local cdk = Char.GetData(leader,CONST.对象_CDK);
               local Round = Battle.GetTurn(battleIndex);
               local WeaponIndex = Char.GetWeapon(aIndex);                --左右手
               local Weapon_Name = Item.GetData(WeaponIndex, CONST.道具_名字);
               if Weapon_Name~=nil then
                   local wandId = Item.GetData(WeaponIndex, CONST.道具_ID);
                   if (wandId== 79255)  then
                       rate = 0;
                       local Count = tonumber(TeamBuff_Tbl(cdk,3));
                       if Count>=1 and Count<5  then
                           Char.SetTempData(leader, '黑豹牙', 1);
                       elseif Count>=5 and Count<10  then
                           Char.SetTempData(leader, '黑豹牙', 2);
                       elseif Count>=10 then
                           Char.SetTempData(leader, '黑豹牙', 3);
                       end
                       return rate
                   end
               end
         end
         return rate
end

function Module:OnBattleCounterRateEvent(battleIndex, aIndex, fIndex, rate)
         --self:logDebug('OnBattleCounterRateCallBack', battleIndex, aIndex, fIndex, rate)
         if Char.IsPlayer(aIndex) and Char.IsEnemy(fIndex) then
               local battleIndex = Char.GetBattleIndex(aIndex);
               local leader1 = Battle.GetPlayer(battleIndex,0)
               local leader2 = Battle.GetPlayer(battleIndex,5)
               local leader = leader1
               if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
                   leader = leader2
               end
               local cdk = Char.GetData(leader,CONST.对象_CDK);
               local Round = Battle.GetTurn(battleIndex);
               local WeaponIndex = Char.GetWeapon(aIndex);                --左右手
               local Weapon_Name = Item.GetData(WeaponIndex, CONST.道具_名字);
               if Weapon_Name~=nil then
                   local wandId = Item.GetData(WeaponIndex, CONST.道具_ID);
                   if (wandId== 79257)  then
                       rate = 100;
                       local Count = tonumber(TeamBuff_Tbl(cdk,4));
                       if Count>=1 and Count<5  then
                           Char.SetTempData(leader, '黄蛇角', 1);
                       elseif Count>=5 and Count<10  then
                           Char.SetTempData(leader, '黄蛇角', 2);
                       elseif Count>=10  then
                           Char.SetTempData(leader, '黄蛇角', 3);
                       end
                       return rate
                   end
               end
         end
         return rate
end

function TeamBuff_Tbl(cdk,part)
       if teamBuff[cdk] == nill then
              teamBuff[cdk] = {}
              table.insert(teamBuff[cdk],cdk);
              table.insert(teamBuff[cdk],1);
              table.insert(teamBuff[cdk],1);
              table.insert(teamBuff[cdk],1);
       else
              for i,v in ipairs(teamBuff[cdk]) do
                     if ( cdk==v )then
                         if part==2 then
                             teamBuff[cdk][2] = teamBuff[cdk][2] + 1;
                             return teamBuff[cdk][2]
                         elseif part==3 then
                             teamBuff[cdk][3] = teamBuff[cdk][3] + 1;
                             return teamBuff[cdk][3]
                         elseif part==4 then
                             teamBuff[cdk][4] = teamBuff[cdk][4] + 1;
                             return teamBuff[cdk][4]
                         end
                     end
              end
       end
       return 1
end

function Module:OnBattleOverEvent(battleIndex)
         local leader1 = Battle.GetPlayer(battleIndex,0)
         local leader2 = Battle.GetPlayer(battleIndex,5)
         local leader = leader1
         if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
               leader = leader2
         end
         if (leader>=0) then
               local cdk = Char.GetData(leader,CONST.对象_CDK);
               local claws = Char.GetTempData(leader, '白虎爪') or 0;
               local teeth = Char.GetTempData(leader, '黑豹牙') or 0;
               local horns = Char.GetTempData(leader, '黄蛇角') or 0;
               --print(claws,teeth,horns)
               if (claws>0 or teeth>0 or horns>0 ) then
                   Char.SetTempData(leader, '白虎爪', 0);
                   Char.SetTempData(leader, '黑豹牙', 0);
                   Char.SetTempData(leader, '黄蛇角', 0);
                   NLG.UpChar(leader);
                   teamBuff[cdk] = {}
               end
         end
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
