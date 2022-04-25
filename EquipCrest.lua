local CountCrest = {}
------------------------------------------------------------------------------
------------------------------------------------------------------------------
local CrestEnable = {}
CrestEnable[20016] = 0  --0 禁止纹章，括号为道具ID
local ItemPosTable = {}
ItemPosTable[70207] = 0
ItemPosTable[70208] = 1
ItemPosTable[70209] = 4
ItemPosTable[70210] = 2
local CrestName = {}
CrestName[1] = {"塔格奧",7000207,"地屬性",%对象_地属性%,%对象_回复%,1.5,"[不動明王] 寵物回復提升50%！"}
CrestName[2] = {"塔拉夏",7000208,"水屬性",%对象_水属性%,%对象_防御力%,1.2,"[堅定怒目] 寵物防禦力提升20%！"}
CrestName[3] = {"艾爾多",7000209,"火屬性",%对象_火属性%,%对象_攻击力%,1.2,"[勇猛果敢] 寵物攻擊力提升20%！"}
CrestName[4] = {"娜塔亞",7000210,"風屬性",%对象_风属性%,%对象_敏捷%,1.3,"[迷蹤幻影] 寵物敏捷提升30%！"}
------------------------------------------------------------------------------

Delegate.RegDelBattleStartEvent("Crest_BattleStart");
function Crest_BattleStart(BattleIndex)
	CountCrest[1] = 0
	CountCrest[2] = 0
	CountCrest[3] = 0
	CountCrest[4] = 0
	for i=0,9 do
		local _PlayerIndex = Battle.GetPlayer(BattleIndex, i)
		for k=0,4 do
			local item = Char.GetItemIndex(_PlayerIndex,k);
			local Crestitem = Item.GetData(item,58);
			if (Crestitem==7000207) then
				CountCrest[1] = CountCrest[1] + 1
			end
			if (Crestitem==7000208) then
				CountCrest[2] = CountCrest[2] + 1
			end
			if (Crestitem==7000209) then
				CountCrest[3] = CountCrest[3] + 1
			end
			if (Crestitem==7000210) then
				CountCrest[4] = CountCrest[4] + 1
			end
		end
		if(CountCrest[1] > 0 and Char.GetData(_PlayerIndex,%对象类型_宠%) == 3) then
			local plus = CountCrest[1];
			local msg = "[紋章效果] 寵物提升地屬性"..plus.."點！"
			Char.SetData(_PlayerIndex,%对象_地属性%, Char.GetData(_PlayerIndex,%对象_地属性%) + plus*10);
			--NLG.TalkToCli(-1,-1,msg,%颜色_黄色%,%字体_中%);
			if(plus >= 3) then
				local heal = Char.GetData(_PlayerIndex,%对象_回复%);
				local New_50heal = heal * 1.5;
				Char.SetData(_PlayerIndex,%对象_回复%,New_50heal);
				--NLG.TalkToCli(-1,-1,"[不動明王] 第一回合寵物回復提升50%！",%颜色_黄色%,%字体_中%);
			end
		end
		if(CountCrest[2] > 0 and Char.GetData(_PlayerIndex,%对象类型_宠%) == 3) then
			local plus = CountCrest[2];
			local msg = "[紋章效果] 寵物提升水屬性"..plus.."點！"
			Char.SetData(_PlayerIndex,%对象_水属性%, Char.GetData(_PlayerIndex,%对象_水属性%) + plus*10);
			--NLG.TalkToCli(-1,-1,msg,%颜色_黄色%,%字体_中%);
			if(plus >= 3) then
				local tough = Char.GetData(_PlayerIndex,%对象_防御力%);
				local New_20tough = tough * 1.2;
				Char.SetData(_PlayerIndex,%对象_防御力%,New_20tough);
				--NLG.TalkToCli(-1,-1,"[堅定怒目] 第一回合寵物防禦力提升20%！",%颜色_黄色%,%字体_中%);
			end
		end
		if(CountCrest[3] > 0 and Char.GetData(_PlayerIndex,%对象类型_宠%) == 3) then
			local plus = CountCrest[3];
			local msg = "[紋章效果] 寵物提升火屬性"..plus.."點！"
			Char.SetData(_PlayerIndex,%对象_火属性%, Char.GetData(_PlayerIndex,%对象_火属性%) + plus*10);
			--NLG.TalkToCli(-1,-1,msg,%颜色_黄色%,%字体_中%);
			if(plus >= 3) then
				local power = Char.GetData(_PlayerIndex,%对象_攻击力%);
				local New_20power = power * 1.2;
				Char.SetData(_PlayerIndex,%对象_攻击力%,New_20power);
				--NLG.TalkToCli(-1,-1,"[勇猛果敢] 第一回合寵物攻擊力提升20%！",%颜色_黄色%,%字体_中%);
			end
		end
		if(CountCrest[4] > 0 and Char.GetData(_PlayerIndex,%对象类型_宠%) == 3) then
			local plus = CountCrest[4];
			local msg = "[紋章效果] 寵物提升風屬性"..plus.."點！"
			Char.SetData(_PlayerIndex,%对象_风属性%, Char.GetData(_PlayerIndex,%对象_风属性%) + plus*10);
			--NLG.TalkToCli(-1,-1,msg,%颜色_黄色%,%字体_中%);
			if(plus >= 3) then
				local agi = Char.GetData(_PlayerIndex,%对象_敏捷%);
				local New_30agi = agi * 1.3;
				Char.SetData(_PlayerIndex,%对象_敏捷%,New_30agi);
				--NLG.TalkToCli(-1,-1,"[迷蹤幻影] 第一回合寵物敏捷提升30%！",%颜色_黄色%,%字体_中%);
			end
		end
	end
	return 0
end
Delegate.RegDelBattleOverEvent("Crest_BattleOver");
function Crest_BattleOver(BattleIndex)
	for i=0,9 do
		local _PlayerIndex = Battle.GetPlayer(BattleIndex, i)
		if(CountCrest[1] > 0 and Char.GetData(_PlayerIndex,%对象类型_宠%) == 3) then
			local plus = CountCrest[1];
			local msg = "[紋章效果] 寵物屬性回復原狀！"
			Char.SetData(_PlayerIndex,%对象_地属性%, Char.GetData(_PlayerIndex,%对象_地属性%) - plus*10);
			--NLG.TalkToCli(-1,-1,msg,%颜色_黄色%,%字体_中%);
		end
		if(CountCrest[2] > 0 and Char.GetData(_PlayerIndex,%对象类型_宠%) == 3) then
			local plus = CountCrest[2];
			local msg = "[紋章效果] 寵物屬性回復原狀！"
			Char.SetData(_PlayerIndex,%对象_水属性%, Char.GetData(_PlayerIndex,%对象_水属性%) - plus*10);
			--NLG.TalkToCli(-1,-1,msg,%颜色_黄色%,%字体_中%);
		end
		if(CountCrest[3] > 0 and Char.GetData(_PlayerIndex,%对象类型_宠%) == 3) then
			local plus = CountCrest[3];
			local msg = "[紋章效果] 寵物屬性回復原狀！"
			Char.SetData(_PlayerIndex,%对象_火属性%, Char.GetData(_PlayerIndex,%对象_火属性%) - plus*10);
			--NLG.TalkToCli(-1,-1,msg,%颜色_黄色%,%字体_中%);
		end
		if(CountCrest[4] > 0 and Char.GetData(_PlayerIndex,%对象类型_宠%) == 3) then
			local plus = CountCrest[4];
			local msg = "[紋章效果] 寵物屬性回復原狀！"
			Char.SetData(_PlayerIndex,%对象_风属性%, Char.GetData(_PlayerIndex,%对象_风属性%) - plus*10);
			--NLG.TalkToCli(-1,-1,msg,%颜色_黄色%,%字体_中%);
		end
	end
	return 0
end


NL.RegBattleActionEvent(nil,"Crest_A")

function Crest_A(_PlayerIndex, battle, Com1, Com2, Com3, ActionNum)
	for i=1,4 do
		if(CountCrest[i] > 0 and Char.GetData(_PlayerIndex,%对象类型_宠%) == 3) then
			local plus = CountCrest[i];
			local msg = "[紋章效果] 寵物提升"..CrestName[i][3]..plus.."點！"
			Char.SetData(_PlayerIndex, CrestName[i][4], Char.GetData(_PlayerIndex, CrestName[i][4]) + plus);
			NLG.TalkToCli(-1,-1,msg,%颜色_黄色%,%字体_中%);
			if(plus >= 3) then
				local ability = Char.GetData(_PlayerIndex,CrestName[i][5]);
				local New_ability = ability * CrestName[i][6];
				Char.SetData(_PlayerIndex,CrestName[i][5],New_ability);
				NLG.TalkToCli(-1,-1,CrestName[i][7],%颜色_黄色%,%字体_中%);
			end
		end
	end
	return
end

Delegate.RegInit("EquipCrestNpc_Init");

function EquipCrestNpc_Init()
	EquipCrestNpc = NL.CreateNpc(nil, "Myinit");
	Char.SetData(EquipCrestNpc,%对象_形象%,14682);
	Char.SetData(EquipCrestNpc,%对象_原形%,14682);
	Char.SetData(EquipCrestNpc,%对象_X%,38);
	Char.SetData(EquipCrestNpc,%对象_Y%,31);
	Char.SetData(EquipCrestNpc,%对象_地图%,777);
	Char.SetData(EquipCrestNpc,%对象_方向%,0);
	Char.SetData(EquipCrestNpc,%对象_名字%,"宠物纹章");
	NLG.UpChar(EquipCrestNpc);
	Char.SetTalkedEvent(nil, "EquipCrestNpc_Talked", EquipCrestNpc);
	Char.SetWindowTalkedEvent(nil, "EquipCrestNpc_WindowTalked", EquipCrestNpc);
	return true;
end

function Myinit(_MeIndex)
	return true;
end

NL.RegItemString("lua/Module/EquipCrest.lua","Crest","LUA_useCrest");
function Crest(_PlayerIndex,_toIndex,_itemslot) --双击道具执行函数
	ItemID = Item.GetData(Char.GetItemIndex(_PlayerIndex,_itemslot),0);
	local TalkMsg =		"\\n                ◆宠物纹章◆" ..
				"\\n将装备随机赋予四种纹章" ..
				"\\n纹章在战斗提升宠物属性" ..
				"\\n " ..
				"\\n纹章重复赋予将覆盖" ..
				"\\n无法与影子武器共存" ..
				"\\n " ..
				"\\n选择    『赋予纹章』"..
				"\\n " 
	NLG.ShowWindowTalked(_PlayerIndex, EquipCrestNpc,%窗口_信息框%,%按钮_是否%, 1, TalkMsg);
	return 1;
end

function EquipCrestNpc_Talked( _NpcIndex, _PlayerIndex, _Mode)
	if (NLG.CanTalk(_NpcIndex,_PlayerIndex) == true) then
		local WindowMsg = "3|\\n                ◆宠物纹章◆" ..	"\\n移除纹章将无法回复，所需费用为金钱十万\\n\\n";
		for i=0,4 do
			local item = Char.GetItemIndex(_PlayerIndex,i);

			if(VaildChar(item)==false)then
				WindowMsg = WindowMsg .. " 			 			空\\n";
			else
				WindowMsg = WindowMsg .. " 			 			"..Item.GetData(item,%道具_名字%).."\\n";
			end
		end		
		NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_选择框%,%按钮_关闭%,2,WindowMsg);
	end
	return ;
end


function EquipCrestNpc_WindowTalked( _NpcIndex, _PlayerIndex, _Seqno, _Select, _Data)
	local Gold = Char.GetData(_PlayerIndex, %对象_金币%);
	local item_indexA = Char.GetItemIndex(_PlayerIndex,Char.FindItemId(_PlayerIndex,ItemID));
	local item_indexB = Char.GetItemIndex(_PlayerIndex,ItemPosTable[ItemID]);
	local TargetItemID = Item.GetData(item_indexB,0);
	if (_Seqno==1) then
		if (_Select==8) then
			return
		end
		if (_Select==4 and item_indexB == -2) then
			return
		end
		if (_Select==4 and Item.GetData(item_indexB,%道具_最大攻击数量%)>=2) then
			NLG.SystemMessage(_PlayerIndex,"[系统] 无法赋予宠物纹章！");
			return
		end
		if (_Select==4 and item_indexB ~= -2 and CrestEnable[TargetItemID] ~= 0) then
			local suit = math.random(1,4);
			Item.SetData(item_indexB,%道具_刻印%,1);
			Item.SetData(item_indexB,%道具_刻印玩家%,CrestName[suit][1]);
			Item.SetData(item_indexB,58,CrestName[suit][2]);
			Item.UpItem(_PlayerIndex,ItemPosTable[ItemID]);

			NLG.SystemMessage(_PlayerIndex,"[系统] 宠物纹章成功！");
			Char.DelItem(_PlayerIndex,ItemID,1);
		else
			NLG.SystemMessage(_PlayerIndex,"[系统] 无法赋予宠物纹章！");
		end
	end
	if (_Seqno==2) then
		--取消按钮
		local selectitem = tonumber(_Data) - 1;
		if (selectitem==nil or (selectitem~=nil and (selectitem > 4 or selectitem < 0))) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,3,"\\n\\n\\n您所选择的位置不正常！");
				return;
		end
		local item_indexB = Char.GetItemIndex(_PlayerIndex,selectitem);
		if (VaildChar(item_indexB) == false) then
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,4,"\\n\\n\\n请确定您对应的装备栏有装备！");
			return;
		end
		if (selectitem<=4 and Item.GetData(item_indexB,%道具_最大攻击数量%)>=2) then
			NLG.SystemMessage(_PlayerIndex,"[系统] 无法移除纹章！");
			return;
		end
		if (selectitem<=4 and Item.GetData(item_indexB,%道具_最大攻击数量%)<=1 and Item.GetData(item_indexB,58)~=0 and Gold >= 100000) then
			Item.SetData(item_indexB,%道具_刻印%,0);
			Item.SetData(item_indexB,%道具_刻印玩家%,0);
			Item.SetData(item_indexB,58,0);
			Item.UpItem(_PlayerIndex,selectitem);
			Char.AddGold(_PlayerIndex,-100000);
			NLG.SystemMessage(_PlayerIndex,"[系统] 移除纹章成功！");
		end
		if (selectitem<=4 and Gold < 100000) then
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,3,"\\n\\n\\n请确认金钱足够十万！");
		end
	end
end


