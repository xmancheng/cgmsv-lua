NL.RegItemAttachEvent(nil,"RegItemAttachEvent");
NL.RegItemDetachEvent(nil,"RegItemDetachEvent");

CardTable= {}
CardTable[1] = {%����_����%,5000,14,8,3,%����_����%,Plus1,"����"};
CardTable[2] = {%����_ǿ��%,5000,14,8,1,%����_����%,Plus1,"����"};
CardTable[3] = {%����_�ٶ�%,5000,14,8,4,%����_��ɱ%,Plus1,"��ɱ"};
CardTable[4] = {%����_ħ��%,5000,14,8,2,%����_����%,Plus1,"����"};

CardTable[5] = {%����_����%,700,14,9,1,%����_ǿ��%,Plus,"ǿ��"};
CardTable[6] = {%����_����%,700,14,9,2,%����_����%,Plus,"����"};
CardTable[7] = {%����_����%,700,14,9,3,%����_ħ��%,Plus,"ħ��"};
CardTable[8] = {%����_����%,700,14,9,4,%����_�ٶ�%,Plus,"�ٶ�"};

function RegItemAttachEvent(player,item)
	local Special = Item.GetData(item,%����_��������%);
	local Para1 = Item.GetData(item,%����_�Ӳ�һ%);
	local Para2 = Item.GetData(item,%����_�Ӳζ�%);
	local Luck = Item.GetData(item,%����_����%);
	local FromItemID = Item.GetData(item,0);
	local Slot = Char.FindItemId(player,FromItemID);
	for i = 1,4 do
		local b = Char.GetData(player,CardTable[i][1]);
		if (b >= CardTable[i][2] and Special == CardTable[i][3] and Para1 == CardTable[i][4] and Para2 == CardTable[i][5])then
			CardTable[i][7] = math.floor( (b - CardTable[i][2])/1000 );
			local PretArr= Char.GetData(player,CardTable[i][6]);
			Char.SetData(player,CardTable[i][6], PretArr+CardTable[i][7]);
			NLG.UpChar(player);
			Item.SetData(item,%����_����%, CardTable[i][7]);
			Item.UpItem(item,Slot);
			NLG.SystemMessage(player,"�Ƭ�ӳɡ� ���".. CardTable[i][8] .."��������".. CardTable[i][7] .."�����ӳ�");
		end
	end
	for j = 5,8 do
		local p = Char.GetData(player,CardTable[j][1]);
		if (p >= CardTable[j][2] and Special == CardTable[j][3] and Para1 == CardTable[j][4] and Para2 == CardTable[j][5])then
			CardTable[j][7] = (math.floor(p/CardTable[j][2]) )*100;
			local PretArr= Char.GetData(player,CardTable[j][6]);
			Char.SetData(player,CardTable[j][6], PretArr+CardTable[j][7]);
			NLG.UpChar(player);
			Item.SetData(item,%����_����%, CardTable[j][7]);
			Item.UpItem(item,Slot);
			NLG.SystemMessage(player,"�Ƭ�ӳɡ� ���".. CardTable[j][8] .."��������".. CardTable[j][7]/100 .."�����ӳ�");
		end
	end
	local Gold = Char.GetData(player, %����_���%);
	if(Item.GetData(item,%����_����%) == 22)then
		if(Item.GetData(item,%����_�Ӳζ�%) == 0)then
			--NLG.SystemMessage(player,"[ϵͳ] ˮ������ϳ������");
		else
			if(Item.GetData(item,%����_��������%) == 0)then
			local figure = Item.GetData(item,%����_�Ӳ�һ%);
			local Sitting = Item.GetData(item,%����_�Ӳζ�%);
			Char.SetData(player,%����_����%,Sitting);
			Char.SetData(player,%����_ԭ��%,Sitting);
			Char.SetData(player,%����_ԭʼͼ��%,Sitting);
			--NLG.SetHeadIcon(player,figure);
			NLG.UpChar(player);
			end
		end
	end
end

function RegItemDetachEvent(player,item)
	local Special = Item.GetData(item,%����_��������%);
	local Para1 = Item.GetData(item,%����_�Ӳ�һ%);
	local Para2 = Item.GetData(item,%����_�Ӳζ�%);
	local Luck = Item.GetData(item,%����_����%);
	local FromItemID = Item.GetData(item,0);
	local Slot = Char.FindItemId(player,FromItemID);
	for i = 1,4 do
		local PostArr = Char.GetData(player,CardTable[i][6]);
		if (Special == CardTable[i][3] and Para1 == CardTable[i][4] and Para2 == CardTable[i][5])then
			Char.SetData(player,CardTable[i][6], PostArr - Luck);
			NLG.UpChar(player);
			Item.SetData(item,%����_����%, 0);
			Item.UpItem(item,Slot);
			--CardResetEvent_D(player);
			NLG.SystemMessage(player,"�Ƭ�ӳɡ� ȡ��".. CardTable[i][8] .."��������".. Luck .."�����ӳ�");
		end
	end
	for j = 5,8 do
		local PostArr = Char.GetData(player,CardTable[j][6]);
		if (Special == CardTable[j][3] and Para1 == CardTable[j][4] and Para2 == CardTable[j][5])then
			Char.SetData(player,CardTable[j][6], PostArr - Luck);
			NLG.UpChar(player);
			Item.SetData(item,%����_����%, 0);
			Item.UpItem(item,Slot);
			--CardResetEvent_W(player);
			NLG.SystemMessage(player,"�Ƭ�ӳɡ� ȡ��".. CardTable[j][8] .."��������".. Luck/100 .."�����ӳ�");
		end
	end
	local Gold = Char.GetData(player, %����_���%);
	if(Item.GetData(item,%����_����%) == 22)then
		if(Item.GetData(item,%����_�Ӳζ�%) == 0)then
			--NLG.SystemMessage(player,"[ϵͳ] ˮ������ϳ������");
		else
			if(Item.GetData(item,%����_��������%) == 0)then
			local figure = Item.GetData(item,%����_�Ӳ�һ%);
			local Sitting = Item.GetData(item,%����_�Ӳζ�%);
			Char.SetData(player,%����_����%,figure);
			Char.SetData(player,%����_ԭ��%,figure);
			Char.SetData(player,%����_ԭʼͼ��%,figure);
			--NLG.SetHeadIcon(player,1);
			NLG.UpChar(player);
			end
		end
	end
end
