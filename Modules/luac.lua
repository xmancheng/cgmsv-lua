---模块类
local Luac = ModuleBase:createModule('luac')
local allyb = 0

local wanjia = {}--玩家表
for bbb = 0,100 do
	wanjia[bbb] = {}
	wanjia[bbb][0] = 0--ai统计
	for ccc = 1,5 do
		wanjia[bbb][ccc] = -1
	end
end

function Luac:yboffline(player)--玩家下线清空自己召唤的ai
	for xxqk = 1,#wanjia[player] do
		if wanjia[player][xxqk] > 0 then
			Char.DelDummy(wanjia[player][xxqk])
		end
	end
	wanjia[player][0] = 0
end

--- 加载模块钩子
function Luac:onLoad()

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
		if wanjia[player][0] > 3 then
			NLG.SystemMessage(player, '您已经召唤了4位小伙伴了，不能再召唤了。' )
		elseif allyb > 100 then
			NLG.SystemMessage(player, '当前线路人口爆满，无法添加佣兵了。' )
		else
		for csdd = 1,5 do
			if Char.PartyNum(wanjia[player][csdd]) == -1 then
				Battle.ExitBattle(wanjia[player][csdd]);
				Char.Warp(wanjia[player][csdd], Target_MapId, Target_FloorId, Target_X, Target_Y);
				Char.JoinParty(wanjia[player][csdd],player);
			end
		end
		for num = 1,5 do
			local petIndex1 = Char.GetPet(player,num-1)
			if Char.GetData(petIndex1, 73) ~= CONST.PET_STATE_战斗 then
				if wanjia[player][num] <= 0 and petIndex1 >= 0 then
					local charIndex1 = Char.CreateDummy()--生成ai佣兵
					wanjia[player][0] = wanjia[player][0] + 1--统计ai佣兵数量
					allyb = charIndex1
					print("编号："..charIndex1.."")
					wanjia[player][num] = charIndex1

					Char.SetData(charIndex1, CONST.CHAR_X, Char.GetData(player, CONST.CHAR_X));
					Char.SetData(charIndex1, CONST.CHAR_Y, Char.GetData(player, CONST.CHAR_Y));
					Char.SetData(charIndex1, CONST.CHAR_地图, Char.GetData(player, CONST.CHAR_地图));
					Char.SetData(charIndex1, CONST.CHAR_名字, '小伙伴');
					Char.SetData(charIndex1, CONST.CHAR_地图类型, Char.GetData(player,CONST.CHAR_地图类型));
					Char.SetData(charIndex1, CONST.CHAR_形象, Char.GetData(petIndex1,CONST.CHAR_形象));
					Char.SetData(charIndex1, CONST.CHAR_原形, Char.GetData(petIndex1,CONST.CHAR_原形));
					Char.SetData(charIndex1, CONST.CHAR_原始图档, Char.GetData(petIndex1,CONST.CHAR_原始图档));
					print('charIndex1', charIndex1)
					--print(player)
					Char.SetData(charIndex1, CONST.CHAR_体力, Char.GetData(petIndex1,CONST.CHAR_体力));
					Char.SetData(charIndex1, CONST.CHAR_力量, Char.GetData(petIndex1,CONST.CHAR_力量));
					Char.SetData(charIndex1, CONST.CHAR_强度, Char.GetData(petIndex1,CONST.CHAR_强度));
					Char.SetData(charIndex1, CONST.CHAR_速度, Char.GetData(petIndex1,CONST.CHAR_速度));
					Char.SetData(charIndex1, CONST.CHAR_魔法, Char.GetData(petIndex1,CONST.CHAR_魔法));
					Char.SetData(charIndex1, CONST.CHAR_等级, Char.GetData(petIndex1,CONST.CHAR_等级));
					Char.SetData(charIndex1, CONST.CHAR_种族, Char.GetData(petIndex1,CONST.CHAR_种族));
					NLG.UpChar(charIndex1);
					Char.GiveItem(charIndex1, 9201, 1);
					Char.MoveItem(charIndex1, 8, CONST.EQUIP_水晶, -1)
					Char.GiveItem(charIndex1, 18196, 1);--实验药
					Char.GiveItem(charIndex1, 18315, 19);--火把
					Char.SetData(charIndex1, CONST.CHAR_血, Char.GetData(petIndex1,CONST.CHAR_最大血));
					Char.SetData(charIndex1, CONST.CHAR_魔, Char.GetData(petIndex1,CONST.CHAR_最大魔));
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
function Luac:onUnload()
  self:logInfo('unload')
end

return Luac;
