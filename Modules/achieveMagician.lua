---ģ����
local Module = ModuleBase:createModule('achieveMagician')

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self))
  self:regCallback('TechOptionEvent', Func.bind(self.OnTechOptionEventCallBack, self))
  self:regCallback('BattleOverEvent', Func.bind(self.OnBattleOverCallBack, self))
end

function Module:handleTalkEvent(charIndex,msg,color,range,size)
	if (msg=="/magician") then
		local flag_earth = math.floor(tonumber( Field.Get( charIndex, 'magician_flag_earth'))) or 0;
		local flag_water = math.floor(tonumber( Field.Get( charIndex, 'magician_flag_water'))) or 0;
		local flag_fire = math.floor(tonumber( Field.Get( charIndex, 'magician_flag_fire'))) or 0;
		local flag_wind = math.floor(tonumber( Field.Get( charIndex, 'magician_flag_wind'))) or 0;
		NLG.SystemMessage(charIndex, "�����Eʯħ����"..flag_earth.."����.��������ħ����"..flag_water.."����");
		NLG.SystemMessage(charIndex, "��������ħ����"..flag_fire.."����.�����L��ħ����"..flag_wind.."����");
		return 0;
	end
	return 1;
end

function Module:OnTechOptionEventCallBack(charIndex, option, techID, val)
      --self:logDebug('OnTechOptionEventCallBack', charIndex, option, techID, val)
      if Char.IsPlayer(charIndex) then
            local battleIndex = Char.GetBattleIndex(charIndex)
            local leader1 = Battle.GetPlayer(battleIndex,0)
            local leader2 = Battle.GetPlayer(battleIndex,5)
            local leader = leader1
            if Char.GetData(leader2, CONST.CHAR_����) == CONST.��������_�� then
                  leader = leader2
            end
            local WeaponIndex = Char.GetWeapon(charIndex);
            local Round = Battle.GetTurn(battleIndex);
            local symf_round= Char.GetTempData(charIndex, 'ħ���غ�') or 0;
            if (WeaponIndex>0) then
                  local wandId = Item.GetData(WeaponIndex, CONST.����_ID);
                  if ( Round==0 or (Round - symf_round)>=1) then
                      local flag_earth = tonumber( Field.Get( charIndex, 'magician_flag_earth')) or 0;
                      local flag_water = tonumber( Field.Get( charIndex, 'magician_flag_water')) or 0;
                      local flag_fire = tonumber( Field.Get( charIndex, 'magician_flag_fire')) or 0;
                      local flag_wind = tonumber( Field.Get( charIndex, 'magician_flag_wind')) or 0;
                      if (techID == 2709 and wandId == 79013)  then    --װ��[Ҽ֮��]���ʹ�ó���Lv10
                         Char.SetTempData(charIndex, 'ħ���غ�', Round);
                         NLG.UpChar(charIndex);
                         if ( Round==0) then
                            Field.Set(charIndex, 'magician_flag_earth', tonumber( flag_earth+(1/20)));
                         else
                            Field.Set(charIndex, 'magician_flag_earth', tonumber( flag_earth+1));
                         end
                      elseif (techID == 2809 and wandId == 79013)  then
                            Char.SetTempData(charIndex, 'ħ���غ�', Round);
                            NLG.UpChar(charIndex);
                         if ( Round==0) then
                            Field.Set(charIndex, 'magician_flag_water', tonumber( flag_water+(1/20)));
                         else
                            Field.Set(charIndex, 'magician_flag_water', tonumber( flag_water+1));
                         end
                      elseif (techID == 2909 and wandId == 79013)  then
                            Char.SetTempData(charIndex, 'ħ���غ�', Round);
                            NLG.UpChar(charIndex);
                         if ( Round==0) then
                            Field.Set(charIndex, 'magician_flag_fire', tonumber( flag_fire+(1/20)));
                         else
                            Field.Set(charIndex, 'magician_flag_fire', tonumber( flag_fire+1));
                         end
                      elseif (techID == 3009 and wandId == 79013)  then
                            Char.SetTempData(charIndex, 'ħ���غ�', Round);
                            NLG.UpChar(charIndex);
                         if ( Round==0) then
                            Field.Set(charIndex, 'magician_flag_wind', tonumber( flag_wind+(1/20)));
                         else
                            Field.Set(charIndex, 'magician_flag_wind', tonumber( flag_wind+1));
                         end
                      end
                  end
            end
      end
      return val
end

function Module:OnBattleOverCallBack(battleIndex)
       for i=0, 9 do
            local player = Battle.GetPlayIndex(battleIndex, i)
            if player>=0 and Char.IsPlayer(player) then
                local WeaponIndex,targetSlot = Char.GetWeapon(player);
                if (WeaponIndex>0) then
                  local wandId = Item.GetData(WeaponIndex, CONST.����_ID);
                  if (wandId == 79013)  then
                      local flag_earth = math.floor(tonumber( Field.Get( player, 'magician_flag_earth'))) or 0;
                      local flag_water = math.floor(tonumber( Field.Get( player, 'magician_flag_water'))) or 0;
                      local flag_fire = math.floor(tonumber( Field.Get( player, 'magician_flag_fire'))) or 0;
                      local flag_wind = math.floor(tonumber( Field.Get( player, 'magician_flag_wind'))) or 0;
                      if (Char.ItemSlot(player)<20) then
                          if (flag_earth>=3000 and flag_water>=3000 and flag_fire>=3000 and flag_wind>=3000)  then
                              Field.Set(player, 'magician_flag_earth', 0);
                              Field.Set(player, 'magician_flag_water', 0);
                              Field.Set(player, 'magician_flag_fire', 0);
                              Field.Set(player, 'magician_flag_wind', 0);
                              NLG.SystemMessage(player,"[ϵ�y]��������l���Wҫ���ǹ⣬���ͮa��׃����");
                              Char.DelItemBySlot(player, targetSlot);
                              local itemID={79213,79214};
                              local rate = NLG.Rand(1,2);
                              Char.GiveItem(player, itemID[rate], 1);
                          end
                      else
                      end
                  end
                end
            end
       end
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;