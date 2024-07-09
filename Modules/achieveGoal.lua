---模块类
local Module = ModuleBase:createModule('achieveGoal')

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self))
  self:regCallback('TechOptionEvent', Func.bind(self.OnTechOptionEventCallBack, self))
  self:regCallback('BattleOverEvent', Func.bind(self.OnBattleOverCallBack, self))
end

function Module:handleTalkEvent(charIndex,msg,color,range,size)
	if (msg=="/achieve") then
		local flag_magician = tonumber( Field.Get( charIndex, 'achieve_flag_magician')) or 0;
		local flag_ares = tonumber( Field.Get( charIndex, 'achieve_flag_ares')) or 0;
		local flag_elf = tonumber( Field.Get( charIndex, 'achieve_flag_elf')) or 0;
		local flag_night = tonumber( Field.Get( charIndex, 'achieve_flag_night')) or 0;
		local flag_asura = tonumber( Field.Get( charIndex, 'achieve_flag_asura')) or 0;
		NLG.SystemMessage(charIndex, "煉獄【"..flag_magician.."/3000】次.狂勇【"..flag_ares.."/3000】次");
		NLG.SystemMessage(charIndex, "精靈【"..flag_elf.."/3000】次.幻影【"..flag_night.."/3000】次");
		NLG.SystemMessage(charIndex, "修羅【"..flag_asura"/3000】次");
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
            if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
                  leader = leader2
            end
            local Round = Battle.GetTurn(battleIndex);
            local symf_round= Char.GetTempData(charIndex, '魔法回合') or 0;
            if (Round==0 or (Round - symf_round)>=1) then
                  local jobs = Char.GetData(charIndex, CONST.对象_职类ID);
                  if ( jobs==15 or jobs==45 or jobs==75 or jobs==115 or jobs==145) then
                      local flag_magician = tonumber( Field.Get( charIndex, 'achieve_flag_magician')) or 0;
                      local flag_ares = tonumber( Field.Get( charIndex, 'achieve_flag_ares')) or 0;
                      local flag_elf = tonumber( Field.Get( charIndex, 'achieve_flag_elf')) or 0;
                      local flag_night = tonumber( Field.Get( charIndex, 'achieve_flag_night')) or 0;
                      local flag_asura = tonumber( Field.Get( charIndex, 'achieve_flag_asura')) or 0;
                      if (techID == 26709)  then    --精波10
                         Char.SetTempData(charIndex, '魔法回合', Round);
                         NLG.UpChar(charIndex);
                         if ( Round>0) then
                            Field.Set(charIndex, 'achieve_flag_magician', tonumber( flag_magician+1));
                         end
                      elseif (techID == 200509)  then    --追月10
                         Char.SetTempData(charIndex, '魔法回合', Round);
                         NLG.UpChar(charIndex);
                         if ( Round>0) then
                            Field.Set(charIndex, 'achieve_flag_ares', tonumber( flag_ares+1));
                         end
                      elseif (techID == 9509)  then    --乱射10
                         Char.SetTempData(charIndex, '魔法回合', Round);
                         NLG.UpChar(charIndex);
                         if ( Round>0) then
                            Field.Set(charIndex, 'achieve_flag_elf', tonumber( flag_elf+1));
                         end
                      elseif (techID == 26609)  then    --因果10
                         Char.SetTempData(charIndex, '魔法回合', Round);
                         NLG.UpChar(charIndex);
                         if ( Round>0) then
                            Field.Set(charIndex, 'achieve_flag_night', tonumber( flag_night+1));
                         end
                      elseif (techID == 409)  then    --气功10
                         Char.SetTempData(charIndex, '魔法回合', Round);
                         NLG.UpChar(charIndex);
                         if ( Round>0) then
                            Field.Set(charIndex, 'achieve_flag_asura', tonumber( flag_asura+1));
                         end
                      end
                  end
            end
      end
      return val
end

function Module:OnBattleOverCallBack(battleIndex)
       for i=0, 9 do
            local charIndex = Battle.GetPlayIndex(battleIndex, i)
            if charIndex>=0 and Char.IsPlayer(charIndex) then
                --成就累积
                local flag_magician = tonumber( Field.Get( charIndex, 'achieve_flag_magician')) or 0;
                local flag_ares = tonumber( Field.Get( charIndex, 'achieve_flag_ares')) or 0;
                local flag_elf = tonumber( Field.Get( charIndex, 'achieve_flag_elf')) or 0;
                local flag_night = tonumber( Field.Get( charIndex, 'achieve_flag_night')) or 0;
                local flag_asura = tonumber( Field.Get( charIndex, 'achieve_flag_asura')) or 0;
                --成就等级
                local flag_magician_level = tonumber( Field.Get( charIndex, 'achieve_flag_magician_level')) or 0;
                local flag_ares_level = tonumber( Field.Get( charIndex, 'achieve_flag_ares_level')) or 0;
                local flag_elf_level = tonumber( Field.Get( charIndex, 'achieve_flag_elf_level')) or 0;
                local flag_night_level = tonumber( Field.Get( charIndex, 'achieve_flag_night_level')) or 0;
                local flag_asura_level = tonumber( Field.Get( charIndex, 'achieve_flag_asura_level')) or 0;
                if (flag_magician>=3000 and flag_magician_level==0)  then
                    Field.Set(charIndex, 'achieve_flag_magician_level', 1);
                    NLG.SystemMessage(charIndex,"[系統]完成職業成就，永久提升攻擊力4點！");
                    Char.SetData(charIndex, CONST.CHAR_攻击力, Char.GetData(charIndex, CONST.CHAR_攻击力) + 4);
                    NLG.UpChar(charIndex);
                elseif (flag_ares>=3000 and flag_ares_level==0)  then
                    Field.Set(charIndex, 'achieve_flag_ares_level', 1);
                    NLG.SystemMessage(charIndex,"[系統]完成職業成就，永久提升攻擊力4點！");
                    Char.SetData(charIndex, CONST.CHAR_攻击力, Char.GetData(charIndex, CONST.CHAR_攻击力) + 4);
                    NLG.UpChar(charIndex);
                elseif (flag_elf>=3000 and flag_elf_level==0)  then
                    Field.Set(charIndex, 'achieve_flag_elf_level', 1);
                    NLG.SystemMessage(charIndex,"[系統]完成職業成就，永久提升攻擊力4點！");
                    Char.SetData(charIndex, CONST.CHAR_攻击力, Char.GetData(charIndex, CONST.CHAR_攻击力) + 4);
                    NLG.UpChar(charIndex);
                elseif (flag_night>=3000 and flag_night_level==0)  then
                    Field.Set(charIndex, 'achieve_flag_night_level', 1);
                    NLG.SystemMessage(charIndex,"[系統]完成職業成就，永久提升攻擊力4點！");
                    Char.SetData(charIndex, CONST.CHAR_攻击力, Char.GetData(charIndex, CONST.CHAR_攻击力) + 4);
                    NLG.UpChar(charIndex);
                elseif (flag_asura>=3000 and flag_asura_level==0)  then
                    Field.Set(charIndex, 'achieve_flag_asura_level', 1);
                    NLG.SystemMessage(charIndex,"[系統]完成職業成就，永久提升攻擊力4點！");
                    Char.SetData(charIndex, CONST.CHAR_攻击力, Char.GetData(charIndex, CONST.CHAR_攻击力) + 4);
                    NLG.UpChar(charIndex);
                end
            end
       end
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;