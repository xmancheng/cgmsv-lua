---模块类
local Module = ModuleBase:createModule('setupGetProfit')
local sgModule = getModule("setterGetter")

local ipmacRestrict ={}
local itemRestrict = { 70016, }

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BattleGetProfitEvent', function(battleIndex, side, pos, charaIndex, type, reward)
      if Char.IsDummy(charaIndex) then
          heroesOnline=sgModule:getGlobal("heroesOnline")
          heroData = heroesOnline[charaIndex]
          player= heroData.owner
      else
          player = charaIndex;
      end
      local cdk = Char.GetData(player,CONST.对象_CDK);
      local myIP = NLG.GetIp(player);
      --local myMAC = NLG.GetMAC(player);
      --print(cdk,myIP)
      if (type==0 or type==1 or type==2) then
          local itemIndex = reward;
          local dayLimit = tonumber(Field.Get(player, 'DayLimit')) or 0;
          local oneDay = tonumber(Field.Get(player, 'OneDay')) or 0;
          local onDay = tonumber(os.date("%j",os.time()));
          if (onDay~=oneDay) then
              local dayLimit=0;
              Field.Set(player, 'DayLimit', tostring(dayLimit));
              Field.Set(player, 'OneDay', tostring(onDay));
              if ipmacRestrict[cdk] ~= nill then
                  table.remove(ipmacRestrict[cdk],tostring(myIP));
              end
          end
          local dayLimit = tonumber(Field.Get(player, 'DayLimit'));
          table.forEach(itemRestrict, function(e)
              if (Item.GetData(itemIndex,CONST.道具_ID)==e) then
                  local dayLimit=dayLimit+1;
                  Field.Set(player, 'DayLimit', tostring(dayLimit));
              end
          end)
          local dayLimit = tonumber(Field.Get(player, 'DayLimit'));
          if dayLimit>100 then
              if ipmacRestrict[cdk] == nill then
                  ipmacRestrict[cdk]={}
              end
              table.insert(ipmacRestrict[cdk],tostring(myIP));
              NLG.SystemMessage(player, "[系統]此道具取得已達每日限制的數量！");
              return 0;
          else
              if ipmacRestrict[cdk] ~= nill then
                    table.forEach(ipmacRestrict[cdk], function(e)
                          if (tostring(myIP)==e) then
                              NLG.SystemMessage(player, "[系統]此道具取得已達每日限制的數量！");
                              return 0;
                          end
                    end)
              end
          end
      end
      return reward;
  end)

end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
