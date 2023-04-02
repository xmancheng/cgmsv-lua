local hbparameter = ModuleBase:createModule('hbparameter')

--- 加载模块钩子
function hbparameter:onLoad()
  self:logInfo('load')
  self:regCallback('ScriptCallEvent', function(npcIndex, playerIndex, text, msg)
    self:logDebugF('npcIndex: %s, playerIndex: %s, text: %s, msg: %s', npcIndex, playerIndex, text, msg)

	player = playerIndex
	npc = npcIndex

	if text == '一键强化' then
		for hbnum = 1,4 do 
			local targetcharIndex = Char.GetPartyMember(player,hbnum)
			if targetcharIndex >= 0 and Char.IsDummy(targetcharIndex) then
				local TL = Char.GetData(targetcharIndex, CONST.CHAR_耐力);  --体成
				local GJ = Char.GetData(targetcharIndex, CONST.CHAR_魅力);  --力成
				local FY = Char.GetData(targetcharIndex, CONST.CHAR_声望);  --强成
				local MJ = Char.GetData(targetcharIndex, CONST.CHAR_灵巧);  --敏成
				local MF = Char.GetData(targetcharIndex, CONST.CHAR_智力);  --魔成
				--print(TL,GJ,FY,MJ,MF)
				local hb = {
					{900203,900203,900205},--体档高
					{900206,900207},--力档高
					{900209,900210},--强档高
					{900212,900213,900214,900215},--速档高
					{900216,900217,900218,900219} --魔档高
				}

				if TL>GJ and TL>=40 then
					Char.GiveItem(targetcharIndex, hb[1][3], 1);  --《特殊》卡
				elseif GJ>MJ and GJ>=40 then
					Char.GiveItem(targetcharIndex, hb[2][1], 1);  --《物理》卡
				elseif FY>TL and FY>=40 then
					Char.GiveItem(targetcharIndex, hb[3][1], 1);  --《變化》卡
				elseif MJ>GJ and MJ>=40 then
					Char.GiveItem(targetcharIndex, hb[4][2], 1);  --《干擾》卡
				elseif MF>GJ and MF>=40 then
					Char.GiveItem(targetcharIndex, hb[5][1], 1);  --《法術》卡
				else
					Char.GiveItem(targetcharIndex, 900208, 1);  --攻擊提升《變化》卡
				end
			end
		end
		NLG.SystemMessage(player, '夥伴強化成功獲得動作技能卡！');
	end

    return -1;
  end)
end


--- 卸载模块钩子
function hbparameter:onUnload()
  self:logInfo('unload')
end

return hbparameter;
