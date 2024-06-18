---模块类
local Module = ModuleBase:createModule('mazeHorcrux')

local worldHorcrux = {
  { "[　第一罪：傲慢", 70258, 301, 119010, 551, 26139 },
  { "[　第二罪：嫉妒", 70260, 302, 119022, 552, 200539 },
  { "[　第三罪：憤怒", 70262, 303, 119020, 553, 10539 },
  { "[　第四罪：怠惰", 70264, 304, 119018, 554, 6339 },
  { "[　第五罪：貪婪", 70266, 305, 119021, 555, 26039 },
  { "[　第六罪：暴食", 70268, 306, 119019, 556, 11139 },
  { "[　第七罪：色慾", 70270, 307, 119011, 557, 26739 },
}

local SkillCD = {}
local skillIdHorcrux = {
  {551},{552},{553},{554},{555},{556},{557},
}

--- 页数计算
local function calcWarp()
  local totalpage = math.modf(#worldHorcrux / 7) + 1
  local remainder = math.fmod(#worldHorcrux, 7)
  return totalpage, remainder
end

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('LoginEvent', Func.bind(self.onLoginEvent, self));
  self:regCallback('LogoutEvent', Func.bind(self.onLogoutEvent, self));
  self:regCallback('DropEvent', Func.bind(self.LogoutEvent, self));
  self:regCallback('ItemString', Func.bind(self.onSinUse, self), 'LUA_useSin');
  self:regCallback('TechOptionEvent', Func.bind(self.onTechOptionEvent, self));
  self:regCallback('BattleSkillCheckEvent', Func.bind(self.onBattleSkillCheckEvent, self));
  local HorcruxNPC = self:NPC_createNormal('七罪魂器著裝', 104840, { map = 1000, x = 241, y = 70, direction = 0, mapType = 0 })
  self:NPC_regWindowTalkedEvent(HorcruxNPC, function(npc, player, _seqno, _select, _data)
    local column = tonumber(_data)
    local page = tonumber(_seqno)
    local warpPage = page;
    local winMsg = "2\\n@c選擇已填充的魂器取得七罪技能\\n"
                           .."　　════════════════════\\n";
    local winButton = CONST.BUTTON_关闭;
    local totalPage, remainder = calcWarp()
    --上页16 下页32 关闭/取消2
    if _select > 0 then
      if _select == CONST.BUTTON_下一页 then
        warpPage = warpPage + 1
        if (warpPage == totalPage) or ((warpPage == (totalPage - 1) and remainder == 0)) then
          winButton = CONST.BUTTON_上取消
        else
          winButton = CONST.BUTTON_上下取消
        end
      elseif _select == CONST.BUTTON_上一页 then
        warpPage = warpPage - 1
        if warpPage == 1 then
          winButton = CONST.BUTTON_下取消
        else
          winButton = CONST.BUTTON_下取消
        end
      elseif _select == 2 then
        warpPage = 1
        return
      end
      local count = 7 * (warpPage - 1)
      if warpPage == totalPage then
        for i = 1 + count, remainder + count do
          local flagEvent = Char.EndEvent(player,worldHorcrux[i][3]);
          if (flagEvent == 1) then
              winMsg = winMsg .. worldHorcrux[i][1] .. "　　●已啟動]\\n"
          else
              winMsg = winMsg .. worldHorcrux[i][1] .. "　　○未激活]\\n"
          end
        end
      else
        for i = 1 + count, 7 + count do
          local flagEvent = Char.EndEvent(player,worldHorcrux[i][3]);
          if (flagEvent == 1) then
              winMsg = winMsg .. worldHorcrux[i][1] .. "　　●已啟動]\\n"
          else
              winMsg = winMsg .. worldHorcrux[i][1] .. "　　○未激活]\\n"
          end
        end
      end
      NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, winButton, warpPage, winMsg);
    else
      local count = 7 * (warpPage - 1) + column
      local short = worldHorcrux[count]
      local flagEvent = Char.EndEvent(player, short[3]);
      if (flagEvent == 1) then
          if Char.HaveSkill(player,short[5])>=0 then
              NLG.SetHeadIcon(player, short[4]);
              Char.SetExtData(player, "Saligia", short[4]);
              NLG.SystemMessage(player,"[系統]七大罪技能已連接設置！！");
              return;
          else
              for i, v in ipairs(skillIdHorcrux) do
                  for i = 1, #skillIdHorcrux do
                      if Char.HaveSkill(player,v[1])>=0 then
                          Char.DelSkill(player,v[1],1);
                          NLG.UpChar(player);
                      end
                  end
              end
              if Char.GetSkillNum(player)==Char.GetData(player, CONST.对象_技能栏) then
                  NLG.SystemMessage(player,"[系統]技能格數量不足，請刪除一個技能。");
                  return;
              end
              Char.AddSkill(player,short[5],0,1);
              Char.SetSkillLevel(player, Char.HaveSkill(player,short[5]),1,1);
              --Char.SetSkillExp(player, Char.HaveSkill(player,short[5]),0,0);
              NLG.SystemMessage(player,"[系統]七大罪連接中，請重新登入來設置。");
              NLG.UpChar(player);
              NLG.SetHeadIcon(player, short[4]);
              Char.SetExtData(player, "Saligia", short[4]);
          end
      else
          NLG.SystemMessage(player,"[系統]尚未激活此七大罪魂器！！");
          return;
      end
    end
  end)
  self:NPC_regTalkedEvent(HorcruxNPC, function(npc, player)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    if (NLG.CanTalk(npc, player) == true) then
      local winCase = CONST.窗口_选择框
      local winButton = CONST.BUTTON_关闭;
      local msg = "2\\n@c選擇已填充的魂器取得七罪技能\\n"
                           .."　　════════════════════\\n";
      for i = 1,7 do
        local flagEvent = Char.EndEvent(player,worldHorcrux[i][3]);
        if (flagEvent == 1) then
            msg = msg .. worldHorcrux[i][1] .. "　　●已啟動]\\n"
        else
            msg = msg .. worldHorcrux[i][1] .. "　　○未激活]\\n"
        end
      end
      NLG.ShowWindowTalked(player, npc, winCase, winButton, 1, msg);
    end
    return
  end)

end


function Module:onLogoutEvent(player)
  local IconId = Char.GetExtData(player, "Saligia") or 0;
  --print(IconId)
end

function Module:onLoginEvent(player)
  local IconId = Char.GetExtData(player, "Saligia") or 0;
  if IconId > 0 then
     NLG.SetHeadIcon(player, IconId);
  end
end

--七大罪使用
function Module:onSinUse(charIndex, targetCharIndex, itemSlot)
  local itemIndex = Char.GetItemIndex(charIndex,itemSlot);
  local ItemID = Item.GetData(itemIndex, CONST.道具_ID);
  for i, v in ipairs(worldHorcrux) do
      if (ItemID==v[2]) then
          if (Char.EndEvent(charIndex,v[3])==0) then
              Char.DelItem(charIndex,v[2],1);
              Char.EndEvent(charIndex,v[3],1);
               NLG.SystemMessage(charIndex,"[系統]七大罪魂器激活中！！");
          elseif (Char.EndEvent(charIndex,v[3])==1) then
               NLG.SystemMessage(charIndex,"[系統]已經啟動過此魂器！！");
          end
      end
  end
end

Char.GetSkillNum = function(charIndex)
  local Number=0;
  for Slot=0,14 do
    local SkillID=Char.GetSkillID(charIndex,Slot);
    if SkillID>0 then
        Number=Number+1;
    end
  end
  return Number;
end

function Module:onTechOptionEvent(charIndex, option, techID, val)
      --self:logDebug('onTechOptionCallBack', charIndex, option, techID, val)
	local battleIndex = Char.GetBattleIndex(charIndex);
	local Round = Battle.GetTurn(battleIndex);
	local CD_round = Char.GetTempData(charIndex, '七罪冷却回合') or 0;
	local CD_tech = Char.GetTempData(charIndex, '七罪冷却技能') or -1;
	if ( (Round - CD_round)<=0 or (Round - CD_round)>=2 ) then
		Char.SetTempData(charIndex, '七罪冷却回合', 0);
		Char.SetTempData(charIndex, '七罪冷却技能', -1);
		NLG.UpChar(charIndex);
	end
	for i, v in ipairs(worldHorcrux) do
		if ( techID==v[6]) then
			Char.SetTempData(charIndex, '七罪冷却回合', Round);
			Char.SetTempData(charIndex, '七罪冷却技能', techID);
			NLG.UpChar(charIndex);
		end
	end
end

function Module:onBattleSkillCheckEvent(charIndex, battleIndex, arrayOfSkillEnable)
      --self:logDebug('onBattleSkillCheckEventCallBack', charIndex, battleIndex, arrayOfSkillEnable)
	local Round = Battle.GetTurn(battleIndex);
	local leader0 = Battle.GetPlayer(battleIndex, 0);
	local leaderpet0 = Battle.GetPlayer(battleIndex, 5);
	local leader = leader0
	local leaderpet = leaderpet0
	if Char.GetData(leader, CONST.CHAR_类型) == CONST.对象类型_人 then
		leader = leader0
	else
		leader = leaderpet
	end
	for i = 0, 9 do
		local player = Battle.GetPlayer(battleIndex, i);
		if Round>=0 and player>=0 and Char.GetData(player, CONST.CHAR_类型) == CONST.对象类型_人 then
			local CD_round = Char.GetTempData(charIndex, '七罪冷却回合') or 0;
			local CD_tech = Char.GetTempData(charIndex, '七罪冷却技能') or -1;
			local techIndex = Tech.GetTechIndex(CD_tech);
			local Skill_Id = Tech.GetData(techIndex, CONST.TECH_SKILLID);
			local TechName = Tech.GetData(techIndex, CONST.TECH_NAME);
			--print(techIndex,Skill_Id,TechName)
			for i, v in ipairs(skillIdHorcrux) do
				for i = 1, #skillIdHorcrux do
				if ( Skill_Id==v[1]) then
					for Slot=0,14 do
						local skillSlot=Char.GetSkillID(player,Slot);
						if (Skill_Id==skillSlot) then
							local Countdown = 3-(Round - CD_round);
							arrayOfSkillEnable[Slot+1]=0;
							--NLG.SystemMessage(player,"[系統] "..TechName.." 冷卻"..Countdown.."回合！");
						elseif(Skill_Id<0) then
							arrayOfSkillEnable[Slot+1]=1;
						end
					end
				end
				end
			end
			return arrayOfSkillEnable;
		end
	end
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
