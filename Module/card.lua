NL.RegItemAttachEvent(nil,"RegItemAttachEvent");
NL.RegItemDetachEvent(nil,"RegItemDetachEvent");

CardTable= {}
CardTable[1] = {%对象_力量%,700,14,9,1,%对象_强度%,Plus,"强度"};
CardTable[2] = {%对象_力量%,700,14,9,2,%对象_体力%,Plus,"体力"};
CardTable[3] = {%对象_力量%,700,14,9,3,%对象_魔法%,Plus,"魔法"};
CardTable[4] = {%对象_力量%,700,14,9,4,%对象_速度%,Plus,"速度"};

CardTable[5] = {%对象_强度%,5000,14,8,1,%对象_反击%,Plus1,"反击"};
CardTable[6] = {%对象_魔法%,5000,14,8,2,%对象_闪躲%,Plus1,"闪躲"};
CardTable[7] = {%对象_体力%,5000,14,8,3,%对象_命中%,Plus1,"命中"};
CardTable[8] = {%对象_速度%,5000,14,8,4,%对象_必杀%,Plus1,"必杀"};

function RegItemAttachEvent(player,item)
	local Special = Item.GetData(item,%道具_特殊类型%);
	local Para1 = Item.GetData(item,%道具_子参一%);
	local Para2 = Item.GetData(item,%道具_子参二%);
	local Luck = Item.GetData(item,%道具_幸运%);
	local FromItemID = Item.GetData(item,0);
	local Slot = Char.FindItemId(player,FromItemID);
	for j = 1,4 do
		local p = Char.GetData(player,CardTable[j][1]);
		if (p >= CardTable[j][2] and Special == CardTable[j][3] and Para1 == CardTable[j][4] and Para2 == CardTable[j][5])then
			CardTable[j][7] = (math.floor(p/CardTable[j][2]) )*100;
			local PretArr= Char.GetData(player,CardTable[j][6]);
			Char.SetData(player,CardTable[j][6], PretArr+CardTable[j][7]);
			NLG.UpChar(player);
			Item.SetData(item,%道具_幸运%, CardTable[j][7]);
			Item.UpItem(player,Slot);
			NLG.SystemMessage(player,"☆卡片加成☆ 獲得".. CardTable[j][8] .."能力屬性".. CardTable[j][7]/100 .."點額外加成");
		end
	end
	for i = 5,8 do
		local b = Char.GetData(player,CardTable[i][1]);
		if (b >= CardTable[i][2] and Special == CardTable[i][3] and Para1 == CardTable[i][4] and Para2 == CardTable[i][5])then
			CardTable[i][7] = math.floor( (b - CardTable[i][2])/1000 );
			local PretArr= Char.GetData(player,CardTable[i][6]);
			Char.SetData(player,CardTable[i][6], PretArr+CardTable[i][7]);
			NLG.UpChar(player);
			Item.SetData(item,%道具_幸运%, CardTable[i][7]);
			Item.UpItem(player,Slot);
			NLG.SystemMessage(player,"☆卡片加成☆ 獲得".. CardTable[i][8] .."修正屬性".. CardTable[i][7] .."點額外加成");
		end
	end
	local Gold = Char.GetData(player, %对象_金币%);
	if(Item.GetData(item,%道具_类型%) == 22)then
		if(Item.GetData(item,%道具_子参二%) == 0)then
			--NLG.SystemMessage(player,"[系统] 水晶无组合宠物座骑！");
		else
			if(Item.GetData(item,%道具_特殊类型%) == 0)then
			local figure = Item.GetData(item,%道具_子参一%);
			local Sitting = Item.GetData(item,%道具_子参二%);
			Char.SetData(player,%对象_形象%,Sitting);
			Char.SetData(player,%对象_原形%,Sitting);
			Char.SetData(player,%对象_原始图档%,Sitting);
			--NLG.SetHeadIcon(player,figure);
			NLG.UpChar(player);
			end
		end
	end
end

function RegItemDetachEvent(player,item)
	local Special = Item.GetData(item,%道具_特殊类型%);
	local Para1 = Item.GetData(item,%道具_子参一%);
	local Para2 = Item.GetData(item,%道具_子参二%);
	local Luck = Item.GetData(item,%道具_幸运%);
	local FromItemID = Item.GetData(item,0);
	local Slot = Char.FindItemId(player,FromItemID);
	for j = 1,4 do
		local PostArr = Char.GetData(player,CardTable[j][6]);
		if (Special == CardTable[j][3] and Para1 == CardTable[j][4] and Para2 == CardTable[j][5])then
			Char.SetData(player,CardTable[j][6], PostArr - Luck);
			NLG.UpChar(player);
			Item.SetData(item,%道具_幸运%, 0);
			Item.UpItem(player,Slot);
			--CardResetEvent_W(player);
			NLG.SystemMessage(player,"☆卡片加成☆ 取消".. CardTable[j][8] .."能力屬性".. Luck/100 .."點額外加成");
		end
	end
	for i = 5,8 do
		local PostArr = Char.GetData(player,CardTable[i][6]);
		if (Special == CardTable[i][3] and Para1 == CardTable[i][4] and Para2 == CardTable[i][5])then
			Char.SetData(player,CardTable[i][6], PostArr - Luck);
			NLG.UpChar(player);
			Item.SetData(item,%道具_幸运%, 0);
			Item.UpItem(player,Slot);
			--CardResetEvent_D(player);
			NLG.SystemMessage(player,"☆卡片加成☆ 取消".. CardTable[i][8] .."修正屬性".. Luck .."點額外加成");
		end
	end
	local Gold = Char.GetData(player, %对象_金币%);
	if(Item.GetData(item,%道具_类型%) == 22)then
		if(Item.GetData(item,%道具_子参二%) == 0)then
			--NLG.SystemMessage(player,"[系统] 水晶无组合宠物座骑！");
		else
			if(Item.GetData(item,%道具_特殊类型%) == 0)then
			local figure = Item.GetData(item,%道具_子参一%);
			local Sitting = Item.GetData(item,%道具_子参二%);
			Char.SetData(player,%对象_形象%,figure);
			Char.SetData(player,%对象_原形%,figure);
			Char.SetData(player,%对象_原始图档%,figure);
			--NLG.SetHeadIcon(player,1);
			NLG.UpChar(player);
			end
		end
	end
end
