local hbReinforceLuac = ModuleBase:createModule('hbReinforceLuac')

--- 加载模块钩子
function hbReinforceLuac:onLoad()
  self:logInfo('load')
  self:regCallback('ScriptCallEvent', function(npcIndex, playerIndex, text, msg)
    self:logDebugF('npcIndex: %s, playerIndex: %s, text: %s, msg: %s', npcIndex, playerIndex, text, msg)
    self:regCallback('BattleStartEvent', Func.bind(hbReinforceLuac.battleStartEventCallback, self))
    self:regCallback('BattleOverEvent', Func.bind(hbReinforceLuac.battleOverEventCallback, self))

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
					{900203,900204,900205},--体档高
					{900206,900207},--力档高
					{900209,900210,900211},--强档高
					{900212,900213,900214,900215},--速档高
					{900216,900217,900218,900219} --魔档高
				}

				if TL>GJ and TL>=40 then
					if MJ<10 then
						Char.GiveItem(targetcharIndex, hb[1][1], 1);  --譽《特殊》卡
					elseif MJ<30 then
						Char.GiveItem(targetcharIndex, hb[1][2], 1);  --補《特殊》卡
					else
						Char.GiveItem(targetcharIndex, hb[1][3], 1);  --恢《特殊》卡
					end
				elseif GJ>MJ and GJ>=40 then
					if TL<20 then
						Char.GiveItem(targetcharIndex, hb[2][2], 1);  --分《物理》卡
					else
						Char.GiveItem(targetcharIndex, hb[2][1], 1);  --彈《物理》卡
					end
				elseif FY>TL and FY>=40 then
					if GJ<20 and MF>=20 then
						Char.GiveItem(targetcharIndex, hb[3][1], 1);  --攻《變化》卡
					elseif MF<20 and GJ>=20 then
						Char.GiveItem(targetcharIndex, hb[3][2], 1);  --魔《變化》卡
					else
						Char.GiveItem(targetcharIndex, hb[3][3], 1);  --潔《變化》卡
					end
				elseif MJ>GJ and MJ>=40 then
					if GJ<10 then
						Char.GiveItem(targetcharIndex, hb[4][2], 1);  --混《干擾》卡
					elseif GJ<20 then
						Char.GiveItem(targetcharIndex, hb[4][3], 1);  --毒《干擾》卡
					elseif GJ<30 then
						Char.GiveItem(targetcharIndex, hb[4][4], 1);  --醉《干擾》卡
					else
						Char.GiveItem(targetcharIndex, hb[4][1], 1);  --石《干擾》卡
					end
				elseif MF>GJ and MF>=40 then
					Char.GiveItem(targetcharIndex, hb[5][math.random(1,4)], 1);  --《法術》卡
				else
					Char.GiveItem(targetcharIndex, 900208, 1);  --海洋祈禱《變化》卡
				end
			end
		end
		NLG.SystemMessage(player, '夥伴強化成功獲得動作技能卡！');
	end
	if text == '一键成长' then
		local itemIndex = Char.HaveItem(player,900100);
		local Slot = Char.GetItemSlot(player, itemIndex);
		local Exp = Item.GetData(itemIndex,CONST.道具_耐久);
		for i = 1,5 do
		local petIndex = Char.GetPet(player, i - 1);
			if petIndex > 0 then 
				Char.SetData(petIndex,CONST.CHAR_经验,Char.GetData(petIndex,CONST.CHAR_经验)+Exp);
				Pet.UpPet(player, petIndex);
			end
		end
		Item.SetData(itemIndex,CONST.道具_耐久, 0);
		Item.UpItem(player, Slot);
		NLG.SystemMessage(player, '累積的經驗值共享給所有寵物！');
	end

    return -1;
  end)
end

local Dm={}
function hbReinforceLuac:battleStartEventCallback(battleIndex)
	for i=10,19 do
		local enemy = Battle.GetPlayer(battleIndex, i);
		if enemy >0 then
			local enemylv = Char.GetData(enemy, CONST.CHAR_等级);
			table.insert(Dm, i, enemylv);
		else
			table.insert(Dm, i, -1);
		end
	end
end
function hbReinforceLuac:battleOverEventCallback(battleIndex)
	local player = Battle.GetPlayer(battleIndex, 0);
	local itemIndex = Char.HaveItem(player,900100);
	local Slot = Char.GetItemSlot(player, itemIndex);
	if Char.EndEvent(player,17) == 1 then --检测累积获得的经验值开启条件
		local Exp = Item.GetData(itemIndex,CONST.道具_耐久);
		local m = 0;
		local k = 0;
		for i=10,19 do
			if Dm[i]>0 then
				m = m+Dm[i];
				k = k+1;
			end
		end
		local lv = math.floor(m/k);
		local plus = lv*(lv+13)*k;
		if Exp >= 6250000 then
			Item.SetData(itemIndex,CONST.道具_耐久, 6250000);
			Item.UpItem(player, Slot);
		else
			Item.SetData(itemIndex,CONST.道具_耐久, Exp+plus);
			Item.SetData(itemIndex,CONST.道具_最大耐久, 6250000);
			Item.UpItem(player, Slot);
		end
		--NLG.Say(player,-1,"检测到累积获得的经验值开启！",0,3);
	end
end

--- 卸载模块钩子
function hbReinforceLuac:onUnload()
  self:logInfo('unload')
end

return hbReinforceLuac;