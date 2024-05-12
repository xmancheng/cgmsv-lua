---模块类
local hbSummonLuac = ModuleBase:createModule('hbSummonLuac')
local allyb = 0

local wanjia = {}--玩家表
for bbb = 0,100 do
	wanjia[bbb] = {}
	wanjia[bbb][0] = 0--ai统计
	for ccc = 1,5 do
		wanjia[bbb][ccc] = -1
	end
end

function hbSummonLuac:yboffline(player)--玩家下线清空自己召唤的ai
	if (wanjia[player]~=nil) then
		for xxqk = 1,#wanjia[player] do
			if wanjia[player][xxqk] > 0 then
				Char.DelDummy(wanjia[player][xxqk])
			end
		end
		wanjia[player][0] = 0
		Char.EndEvent(player,17,0);
	end
end

local hbsp = {900330,900333}--饰品

local mfsj = {
	{9213,9212,9211,9210,9209,9208,9207,9206,9205,9201},--1-9地水、10地水晶
	{9222,9221,9220,9219,9218,9217,9216,9215,9214,9202},--1-9水火、10水水晶
	{9231,9230,9229,9228,9227,9226,9225,9224,9223,9203},--1-9火风、10火水晶
	{9240,9239,9238,9237,9236,9235,9234,9233,9232,9204} --1-9风地、10风水晶
}

--- 加载模块钩子
function hbSummonLuac:onLoad()

  self:logInfo('load')
  --local fnpc = self:NPC_createNormal('镜像宠物', 101003, { x = 38, y = 33, mapType = 0, map = 777, direction = 6 });
  self:regCallback('ScriptCallEvent', function(npcIndex, playerIndex, text, msg)
    self:logDebugF('npcIndex: %s, playerIndex: %s, text: %s, msg: %s', npcIndex, playerIndex, text, msg)
    self:regCallback("LogoutEvent", Func.bind(self.yboffline, self))
    
	player = playerIndex
	npc = npcIndex

	id = Char.GetData(player,%对象_CDK%)
	name = Char.GetData(player,%对象_名字%)
	lv = Char.GetData(player, %对象_等级%)
	Target_MapId = Char.GetData(player,CONST.CHAR_MAP)--地图类型
	Target_FloorId = Char.GetData(player,CONST.CHAR_地图)--地图编号
	Target_X = Char.GetData(player,CONST.CHAR_X)--地图x
	Target_Y = Char.GetData(player,CONST.CHAR_Y)--地图y

	if text == '一键召唤' then
		for csdd = 1,5 do
			if Char.PartyNum(wanjia[player][csdd]) == -1 then
				Battle.ExitBattle(wanjia[player][csdd]);
				Char.Warp(wanjia[player][csdd], Target_MapId, Target_FloorId, Target_X, Target_Y);
				Char.JoinParty(wanjia[player][csdd],player);
			end
			local pzw = Char.GetData(player,CONST.CHAR_位置)
			if pzw == 1 then 
				if Char.IsDummy(Char.GetPartyMember(player,1)) then
					Char.SetData(Char.GetPartyMember(player,1),CONST.CHAR_位置,0);
				end
				if Char.IsDummy(Char.GetPartyMember(player,2)) then
					Char.SetData(Char.GetPartyMember(player,2),CONST.CHAR_位置,0);
				end
				if Char.IsDummy(Char.GetPartyMember(player,3)) then
					Char.SetData(Char.GetPartyMember(player,3),CONST.CHAR_位置,1);
				end
				if Char.IsDummy(Char.GetPartyMember(player,4)) then
					Char.SetData(Char.GetPartyMember(player,4),CONST.CHAR_位置,1);
				end
			elseif pzw == 0 then
				if Char.IsDummy(Char.GetPartyMember(player,1)) then
					Char.SetData(Char.GetPartyMember(player,1),CONST.CHAR_位置,1);
				end
				if Char.IsDummy(Char.GetPartyMember(player,2)) then
					Char.SetData(Char.GetPartyMember(player,2),CONST.CHAR_位置,1);
				end
				if Char.IsDummy(Char.GetPartyMember(player,3)) then
					Char.SetData(Char.GetPartyMember(player,3),CONST.CHAR_位置,0);
				end
				if Char.IsDummy(Char.GetPartyMember(player,4)) then
					Char.SetData(Char.GetPartyMember(player,4),CONST.CHAR_位置,0);
				end
			end
		end
		if wanjia[player][0] > 3 then
			NLG.SystemMessage(player, '调整角色前后排再召唤，可以改变队伍阵型。' )
		elseif allyb > 100 then
			NLG.SystemMessage(player, '当前线路人口爆满，无法添加佣兵了。' )
		else
		for num = 1,5 do
			local petIndex1 = Char.GetPet(player,num-1)
			if Char.GetData(petIndex1, 73) ~= CONST.PET_STATE_战斗 then
				if wanjia[player][num] <= 0 and petIndex1 >= 0 then
					local charIndex1 = Char.CreateDummy()--生成ai佣兵
					wanjia[player][0] = wanjia[player][0] + 1--统计ai佣兵数量
					--print("编号："..charIndex1.."")
					wanjia[player][num] = charIndex1
					local TL = Pet.GetArtRank(petIndex1,CONST.PET_体成);
					local GJ = Pet.GetArtRank(petIndex1,CONST.PET_力成);
					local FY = Pet.GetArtRank(petIndex1,CONST.PET_强成);
					local MJ = Pet.GetArtRank(petIndex1,CONST.PET_敏成);
					local MF = Pet.GetArtRank(petIndex1,CONST.PET_魔成);
					Char.SetData(charIndex1, CONST.CHAR_耐力, TL);
					Char.SetData(charIndex1, CONST.CHAR_魅力, GJ);
					Char.SetData(charIndex1, CONST.CHAR_声望, FY);
					Char.SetData(charIndex1, CONST.CHAR_灵巧, MJ);
					Char.SetData(charIndex1, CONST.CHAR_智力, MF);

					Char.SetData(charIndex1, CONST.CHAR_X, Char.GetData(player, CONST.CHAR_X));
					Char.SetData(charIndex1, CONST.CHAR_Y, Char.GetData(player, CONST.CHAR_Y));
					Char.SetData(charIndex1, CONST.CHAR_地图, Char.GetData(player, CONST.CHAR_地图));
					Char.SetData(charIndex1, CONST.CHAR_名字, Char.GetData(petIndex1,CONST.CHAR_名字));
					Char.SetData(charIndex1, CONST.CHAR_地图类型, Char.GetData(player,CONST.CHAR_地图类型));
					Char.SetData(charIndex1, CONST.CHAR_形象, Char.GetData(petIndex1,CONST.CHAR_形象));
					Char.SetData(charIndex1, CONST.CHAR_原形, Char.GetData(petIndex1,CONST.CHAR_原形));
					Char.SetData(charIndex1, CONST.CHAR_原始图档, Char.GetData(petIndex1,CONST.CHAR_原始图档));
					--print('charIndex1', charIndex1)
					--print(player)
					Char.SetData(charIndex1, CONST.CHAR_体力, Char.GetData(petIndex1,CONST.CHAR_体力));
					Char.SetData(charIndex1, CONST.CHAR_力量, Char.GetData(petIndex1,CONST.CHAR_力量));
					Char.SetData(charIndex1, CONST.CHAR_强度, Char.GetData(petIndex1,CONST.CHAR_强度));
					Char.SetData(charIndex1, CONST.CHAR_速度, Char.GetData(petIndex1,CONST.CHAR_速度));
					Char.SetData(charIndex1, CONST.CHAR_魔法, Char.GetData(petIndex1,CONST.CHAR_魔法));
					Char.SetData(charIndex1, CONST.CHAR_等级, Char.GetData(petIndex1,CONST.CHAR_等级));
					Char.SetData(charIndex1, CONST.CHAR_种族, Char.GetData(petIndex1,CONST.CHAR_种族));
					NLG.UpChar(charIndex1);
					local dsj= Char.GetData(petIndex1,CONST.CHAR_地属性);
					local ssj= Char.GetData(petIndex1,CONST.CHAR_水属性);
					local hsj= Char.GetData(petIndex1,CONST.CHAR_火属性);
					local fsj= Char.GetData(petIndex1,CONST.CHAR_风属性);
					if dsj>0 and ssj>0 then
						mf=1;
						sj=math.floor(dsj/10);
					elseif ssj>0 and hsj>0 then
						mf=2;
						sj=math.floor(ssj/10);
					elseif hsj>0 and fsj>0 then
						mf=3;
						sj=math.floor(hsj/10);
					elseif fsj>0 and dsj>0 then
						mf=4;
						sj=math.floor(fsj/10);
					else
						mf=math.random(1,4);
						sj=10;
					end
					Char.GiveItem(charIndex1, mfsj[mf][sj], 1);
					Char.GiveItem(charIndex1, hbsp[1], 1);--饰品1
					Char.GiveItem(charIndex1, hbsp[2], 1);--饰品2
					Char.MoveItem(charIndex1, 8, CONST.EQUIP_水晶, -1);
					Char.MoveItem(charIndex1, 9, CONST.EQUIP_首饰1, -1);
					Char.MoveItem(charIndex1, 10, CONST.EQUIP_首饰2, -1);
					Char.GiveItem(charIndex1, 18196, 1);--实验药
					Char.GiveItem(charIndex1, 18315, 1);--火把
					Char.GiveItem(charIndex1, 900202, 1);--攻击《基本》卡
					Char.GiveItem(charIndex1, 900203, 1);--明镜《基本》卡

					Char.SetData(charIndex1, CONST.CHAR_血, Char.GetData(petIndex1,CONST.CHAR_最大血));
					Char.SetData(charIndex1, CONST.CHAR_魔, Char.GetData(petIndex1,CONST.CHAR_最大魔));
					Char.SetData(charIndex1, CONST.CHAR_抗毒, Char.GetData(petIndex1,CONST.CHAR_抗毒));
					Char.SetData(charIndex1, CONST.CHAR_抗睡, Char.GetData(petIndex1,CONST.CHAR_抗睡));
					Char.SetData(charIndex1, CONST.CHAR_抗石, Char.GetData(petIndex1,CONST.CHAR_抗石));
					Char.SetData(charIndex1, CONST.CHAR_抗醉, Char.GetData(petIndex1,CONST.CHAR_抗醉));
					Char.SetData(charIndex1, CONST.CHAR_抗乱, Char.GetData(petIndex1,CONST.CHAR_抗乱));
					Char.SetData(charIndex1, CONST.CHAR_抗忘, Char.GetData(petIndex1,CONST.CHAR_抗忘));
					Char.SetData(charIndex1, CONST.CHAR_必杀, Char.GetData(petIndex1,CONST.CHAR_必杀));
					Char.SetData(charIndex1, CONST.CHAR_反击, Char.GetData(petIndex1,CONST.CHAR_反击));
					Char.SetData(charIndex1, CONST.CHAR_命中, Char.GetData(petIndex1,CONST.CHAR_命中));
					Char.SetData(charIndex1, CONST.CHAR_闪躲, Char.GetData(petIndex1,CONST.CHAR_闪躲));

					Char.SetData(charIndex1, CONST.CHAR_职业, 1);      --游民
					Char.SetData(charIndex1, CONST.CHAR_职类ID, 0);  --游民
					Char.SetData(charIndex1, CONST.CHAR_职阶, 3);

					Char.JoinParty(charIndex1, player);
				else
					--NLG.SystemMessage(player, '宠物不存在。' )
				end
			else
				--NLG.SystemMessage(player, '战斗状态宠物无法召唤。' )
			end
		end
		Char.EndEvent(player,17,1);  --哈贝鲁村遗迹称号
		end
	end
	if text == '一键解除' then
		for xxqk = 1,#wanjia[player] do
			if wanjia[player][xxqk] > 0 then
				Char.DelDummy(wanjia[player][xxqk])
				wanjia[player][xxqk] = -1
			end
		end
		wanjia[player][0] = 0
		Char.EndEvent(player,17,0);
	end
	
--[[
	local result = table.pack(string.match(text, 'getpetskill:(%d),(%d)'))
    if result and result[1] ~= nil and result[2] ~= nil then
      local petIndex = Char.GetPet(playerIndex, tonumber(result[1]))
      if petIndex >= 0 then
        return Pet.GetSkill(petIndex, tonumber(result[2]))
      end
    end
    result = table.pack(string.match(text, 'addpetskill:(%d),(%d)'))
    if result and result[1] ~= nil and result[2] ~= nil then
      local petIndex = Char.GetPet(playerIndex, tonumber(result[1]))
      if petIndex >= 0 then
        return Pet.AddSkill(petIndex, tonumber(result[2]))
      end
    end
]]	
    return -1;
  end)


--[[  self:NPC_regTalkedEvent(fnpc, function(npc,player)--显示window
	
	function showwindow(npc,player)
	window = "1"
	.."2"
	NLG.ShowWindowTalked(player,npc,CONST.窗口_选择框,CONST.BUTTON_关闭,1,window);
	end
	showwindow(fnpc,player)
	return
  end)]]
end

--- 卸载模块钩子
function hbSummonLuac:onUnload()
  self:logInfo('unload')
end

return hbSummonLuac;
