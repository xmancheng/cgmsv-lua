---ģ����
local Module = ModuleBase:createModule('setupGetProfit')

local itemRestrict = { 70016, }

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('BattleGetProfitEvent', function(battleIndex, side, pos, charaIndex, type, reward)
      local player = charaIndex;
      if (type==0 or type==1 or type==2) then
          local itemIndex = reward;
          local dayLimit = tonumber(Field.Get(player, 'DayLimit')) or 0;
          local oneDay = tonumber(Field.Get(player, 'OneDay')) or 0;
          local onDay = tonumber(os.date("%j",os.time()));
          if (onDay~=oneDay) then
              local dayLimit=0;
              Field.Set(player, 'DayLimit', tostring(dayLimit));
              Field.Set(player, 'OneDay', tostring(onDay));
          end
          local dayLimit = tonumber(Field.Get(player, 'DayLimit'));
          table.forEach(itemRestrict, function(e)
              if (Item.GetData(itemIndex,CONST.����_ID)==e) then
                  local dayLimit=dayLimit+1;
                  Field.Set(player, 'DayLimit', tostring(dayLimit));
              end
          end)
          local dayLimit = tonumber(Field.Get(player, 'DayLimit'));
          if dayLimit>100 then
              NLG.SystemMessage(player, "[ϵ�y]�˵���ȡ�����_ÿ�����ƵĔ�����");
              return 0;
          end
      end
      return reward;
  end)

end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
