------------------------------------------------------------------------------
local itemid_18310 = 18310;  --�ص�ˮ����Ƭ
local itemid_18311 = 18311;  --ˮ��ˮ����Ƭ
local itemid_18312 = 18312;  --���ˮ����Ƭ
local itemid_18313 = 18313;  --���ˮ����Ƭ
------------------------------------------------------------------------------
local a1 = {%����_����%,5,%����_����%,5};
local r1 = {%����_HP%,200,%����_MP%,200};
local r2 = {%����_�ҿ�%,28,%����_����%,200};
local r3 = {%����_˯��%,28,%����_����%,100};
local r4 = {%����_ʯ��%,28,%����_�ظ�%,50};
local r5 = {%����_HP%,1000,%����_MP%,1000};
local r6 = {%����_��%,28,%����_����%,8};
local r7 = {%����_����%,28,%����_��ɱ%,8};
local r8 = {%����_����%,28,%����_����%,8};
local r9 = {%����_ħ��%,25,%����_����%,8};
local r10 = {%����_HP%,1500,%����_MP%,1000};
local Abilitynotes = {a1};                        --ÿһ�ǹ̶����ӵ���ֵ
local Bonus = {r1,r2,r3,r4,r5,r6,r7,r8,r9,r10};   --ÿʮ�Ƕ������ӵ���ֵ
------------------------------------------------------------------------------
local PowerEnable = {}
PowerEnable[9305] = 0  --0 ��ֹ����ǿ��������Ϊ����ID
PowerEnable[9315] = 0
PowerEnable[9325] = 0
PowerEnable[9335] = 0
PowerEnable[9410] = 0
PowerEnable[9420] = 0
PowerEnable[9430] = 0
PowerEnable[9440] = 0
PowerEnable[69129] = 0
PowerEnable[69130] = 0
PowerEnable[69131] = 0
PowerEnable[69132] = 0
------------------------------------------------------------------------------
NL.RegItemOverLapEvent(nil,"StarPower");

function StarPower(_PlayerIndex, FromItemIndex, TargetItemIndex, Num)
	local Gold = Char.GetData(_PlayerIndex, %����_���%);
	local FromItemID = Item.GetData(FromItemIndex,0);
	local TargetItemID = Item.GetData(TargetItemIndex,0);
	local star = Item.GetData(TargetItemIndex,%����_����%);
	local StarGold = star*10;
	local Category1 = Item.GetData(TargetItemIndex,%����_����һ%);
	local Category2 = Item.GetData(TargetItemIndex,%����_���Զ�%);
	local Rate = math.random(1,100);
	if(FromItemID == itemid_18310 or FromItemID == itemid_18311 or FromItemID == itemid_18312 or FromItemID == itemid_18313)then
		if(Item.GetData(TargetItemIndex,%����_����%) ~= 22)then
			NLG.SystemMessage(_PlayerIndex,"[ϵ�y] Ո��ˮ���M������������");
		end
		if(Gold < StarGold)then
			NLG.SystemMessage(_PlayerIndex,"[ϵ�y] Ո�_�J���X���"..StarGold.."��");
		end
		if(PowerEnable[TargetItemID] == 0)then
			NLG.SystemMessage(_PlayerIndex,"[ϵ�y] �x���ˮ���o������������");
		end
		if (star==0 or star == nill) then
			local TargetName = Item.GetData(TargetItemIndex,%����_����%);
			Item.SetData(TargetItemIndex,%����_��ǰ��%,TargetName);
		end
		if (star==100) then
			NLG.SystemMessage(_PlayerIndex,"[ϵ�y] "..Item.GetData(TargetItemIndex,%����_��ǰ��%).."���_���������");
		end
	end
	if (PowerEnable[TargetItemID] ~= 0 and FromItemID == itemid_18310 and Item.GetData(TargetItemIndex,%����_����%) == 22 and Gold >= StarGold and star <= 99) then
		if (Category1==1 or Category2==1) then
			if (Rate>=star) then
				local OriName = Item.GetData(TargetItemIndex,%����_��ǰ��%);
				local starstate = star + 1;
				Newname = starstate.."�ǡ�" .. OriName;
				Item.SetData(TargetItemIndex,%����_����%,Newname);
				local S1 = Item.GetData(TargetItemIndex,Abilitynotes[1][1]);
				local S1_A = S1 + Abilitynotes[1][2];
				local S2 = Item.GetData(TargetItemIndex,Abilitynotes[1][3]);
				local S2_A = S2 + Abilitynotes[1][4];
				Item.SetData(TargetItemIndex,Abilitynotes[1][1],S1_A);
				Item.SetData(TargetItemIndex,Abilitynotes[1][3],S2_A);
				Item.SetData(TargetItemIndex,%����_����%,star+1);
				Item.UpItem(_PlayerIndex,Char.FindItemId(_PlayerIndex,TargetItemID));
				if (star==9 or star==19 or star==29 or star==39 or star==49 or star==59 or star==69 or star==79 or star==89 or star==99) then
					local B1 = Item.GetData(TargetItemIndex,Bonus[math.ceil(star/10)][1]);
					local B1_A = B1 + Bonus[math.ceil(star/10)][2];
					local B2 = Item.GetData(TargetItemIndex,Bonus[math.ceil(star/10)][3]);
					local B2_A = B2 + Bonus[math.ceil(star/10)][4];
					Item.SetData(TargetItemIndex,Bonus[math.ceil(star/10)][1],B1_A);
					Item.SetData(TargetItemIndex,Bonus[math.ceil(star/10)][3],B2_A);
					Item.UpItem(_PlayerIndex,Char.FindItemId(_PlayerIndex,TargetItemID));
				end
				Char.AddGold(_PlayerIndex,-StarGold);
				Char.DelItem(_PlayerIndex,itemid_18310,1);
				NLG.SystemMessage(_PlayerIndex,"[ϵ�y] "..Item.GetData(TargetItemIndex,%����_��ǰ��%).."���������ɹ���");
			else
				Char.AddGold(_PlayerIndex,-StarGold);
				Char.DelItem(_PlayerIndex,itemid_18310,1);
				NLG.SystemMessage(_PlayerIndex,"[ϵ�y] "..Item.GetData(TargetItemIndex,%����_��ǰ��%).."��������ʧ����");
			end
		else
			NLG.SystemMessage(_PlayerIndex,"[ϵ�y] Ո����ͬ���Ե�ˮ���M������������");
		end
	end
	if (PowerEnable[TargetItemID] ~= 0 and FromItemID == itemid_18311 and Item.GetData(TargetItemIndex,%����_����%) == 22 and Gold >= StarGold and star <= 99) then
		if (Category1==2 or Category2==2) then
			if (Rate>=star) then
				local OriName = Item.GetData(TargetItemIndex,%����_��ǰ��%);
				local starstate = star + 1;
				Newname = starstate.."�ǡ�" .. OriName;
				Item.SetData(TargetItemIndex,%����_����%,Newname);
				local S1 = Item.GetData(TargetItemIndex,Abilitynotes[1][1]);
				local S1_A = S1 + Abilitynotes[1][2];
				local S2 = Item.GetData(TargetItemIndex,Abilitynotes[1][3]);
				local S2_A = S2 + Abilitynotes[1][4];
				Item.SetData(TargetItemIndex,Abilitynotes[1][1],S1_A);
				Item.SetData(TargetItemIndex,Abilitynotes[1][3],S2_A);
				Item.SetData(TargetItemIndex,%����_����%,star+1);
				Item.UpItem(_PlayerIndex,Char.FindItemId(_PlayerIndex,TargetItemID));
				if (star==9 or star==19 or star==29 or star==39 or star==49 or star==59 or star==69 or star==79 or star==89 or star==99) then
					local B1 = Item.GetData(TargetItemIndex,Bonus[math.ceil(star/10)][1]);
					local B1_A = B1 + Bonus[math.ceil(star/10)][2];
					local B2 = Item.GetData(TargetItemIndex,Bonus[math.ceil(star/10)][3]);
					local B2_A = B2 + Bonus[math.ceil(star/10)][4];
					Item.SetData(TargetItemIndex,Bonus[math.ceil(star/10)][1],B1_A);
					Item.SetData(TargetItemIndex,Bonus[math.ceil(star/10)][3],B2_A);
					Item.UpItem(_PlayerIndex,Char.FindItemId(_PlayerIndex,TargetItemID));
				end
				Char.AddGold(_PlayerIndex,-StarGold);
				Char.DelItem(_PlayerIndex,itemid_18311,1);
				NLG.SystemMessage(_PlayerIndex,"[ϵ�y] "..Item.GetData(TargetItemIndex,%����_��ǰ��%).."���������ɹ���");
			else
				Char.AddGold(_PlayerIndex,-StarGold);
				Char.DelItem(_PlayerIndex,itemid_18311,1);
				NLG.SystemMessage(_PlayerIndex,"[ϵ�y] "..Item.GetData(TargetItemIndex,%����_��ǰ��%).."��������ʧ����");
			end
		else
			NLG.SystemMessage(_PlayerIndex,"[ϵ�y] Ո����ͬ���Ե�ˮ���M������������");
		end
	end
	if (PowerEnable[TargetItemID] ~= 0 and FromItemID == itemid_18312 and Item.GetData(TargetItemIndex,%����_����%) == 22 and Gold >= StarGold and star <= 99) then
		if (Category1==3 or Category2==3) then
			if (Rate>=star) then
				local OriName = Item.GetData(TargetItemIndex,%����_��ǰ��%);
				local starstate = star + 1;
				Newname = starstate.."�ǡ�" .. OriName;
				Item.SetData(TargetItemIndex,%����_����%,Newname);
				local S1 = Item.GetData(TargetItemIndex,Abilitynotes[1][1]);
				local S1_A = S1 + Abilitynotes[1][2];
				local S2 = Item.GetData(TargetItemIndex,Abilitynotes[1][3]);
				local S2_A = S2 + Abilitynotes[1][4];
				Item.SetData(TargetItemIndex,Abilitynotes[1][1],S1_A);
				Item.SetData(TargetItemIndex,Abilitynotes[1][3],S2_A);
				Item.SetData(TargetItemIndex,%����_����%,star+1);
				Item.UpItem(_PlayerIndex,Char.FindItemId(_PlayerIndex,TargetItemID));
				if (star==9 or star==19 or star==29 or star==39 or star==49 or star==59 or star==69 or star==79 or star==89 or star==99) then
					local B1 = Item.GetData(TargetItemIndex,Bonus[math.ceil(star/10)][1]);
					local B1_A = B1 + Bonus[math.ceil(star/10)][2];
					local B2 = Item.GetData(TargetItemIndex,Bonus[math.ceil(star/10)][3]);
					local B2_A = B2 + Bonus[math.ceil(star/10)][4];
					Item.SetData(TargetItemIndex,Bonus[math.ceil(star/10)][1],B1_A);
					Item.SetData(TargetItemIndex,Bonus[math.ceil(star/10)][3],B2_A);
					Item.UpItem(_PlayerIndex,Char.FindItemId(_PlayerIndex,TargetItemID));
				end
				Char.AddGold(_PlayerIndex,-StarGold);
				Char.DelItem(_PlayerIndex,itemid_18312,1);
				NLG.SystemMessage(_PlayerIndex,"[ϵ�y] "..Item.GetData(TargetItemIndex,%����_��ǰ��%).."���������ɹ���");
			else
				Char.AddGold(_PlayerIndex,-StarGold);
				Char.DelItem(_PlayerIndex,itemid_18312,1);
				NLG.SystemMessage(_PlayerIndex,"[ϵ�y] "..Item.GetData(TargetItemIndex,%����_��ǰ��%).."��������ʧ����");
			end
		else
			NLG.SystemMessage(_PlayerIndex,"[ϵ�y] Ո����ͬ���Ե�ˮ���M������������");
		end
	end
	if (PowerEnable[TargetItemID] ~= 0 and FromItemID == itemid_18313 and Item.GetData(TargetItemIndex,%����_����%) == 22 and Gold >= StarGold and star <= 99) then
		if (Category1==4 or Category2==4) then
			if (Rate>=star) then
				local OriName = Item.GetData(TargetItemIndex,%����_��ǰ��%);
				local starstate = star + 1;
				Newname = starstate.."�ǡ�" .. OriName;
				Item.SetData(TargetItemIndex,%����_����%,Newname);
				local S1 = Item.GetData(TargetItemIndex,Abilitynotes[1][1]);
				local S1_A = S1 + Abilitynotes[1][2];
				local S2 = Item.GetData(TargetItemIndex,Abilitynotes[1][3]);
				local S2_A = S2 + Abilitynotes[1][4];
				Item.SetData(TargetItemIndex,Abilitynotes[1][1],S1_A);
				Item.SetData(TargetItemIndex,Abilitynotes[1][3],S2_A);
				Item.SetData(TargetItemIndex,%����_����%,star+1);
				Item.UpItem(_PlayerIndex,Char.FindItemId(_PlayerIndex,TargetItemID));
				if (star==9 or star==19 or star==29 or star==39 or star==49 or star==59 or star==69 or star==79 or star==89 or star==99) then
					local B1 = Item.GetData(TargetItemIndex,Bonus[math.ceil(star/10)][1]);
					local B1_A = B1 + Bonus[math.ceil(star/10)][2];
					local B2 = Item.GetData(TargetItemIndex,Bonus[math.ceil(star/10)][3]);
					local B2_A = B2 + Bonus[math.ceil(star/10)][4];
					Item.SetData(TargetItemIndex,Bonus[math.ceil(star/10)][1],B1_A);
					Item.SetData(TargetItemIndex,Bonus[math.ceil(star/10)][3],B2_A);
					Item.UpItem(_PlayerIndex,Char.FindItemId(_PlayerIndex,TargetItemID));
				end
				Char.AddGold(_PlayerIndex,-StarGold);
				Char.DelItem(_PlayerIndex,itemid_18313,1);
				NLG.SystemMessage(_PlayerIndex,"[ϵ�y] "..Item.GetData(TargetItemIndex,%����_��ǰ��%).."���������ɹ���");
			else
				Char.AddGold(_PlayerIndex,-StarGold);
				Char.DelItem(_PlayerIndex,itemid_18313,1);
				NLG.SystemMessage(_PlayerIndex,"[ϵ�y] "..Item.GetData(TargetItemIndex,%����_��ǰ��%).."��������ʧ����");
			end
		else
			NLG.SystemMessage(_PlayerIndex,"[ϵ�y] Ո����ͬ���Ե�ˮ���M������������");
		end
	end

	local walkOn = Item.GetData(TargetItemIndex,CONST.����_����);
	if (TargetItemID==75001 and walkOn==0) then
		if (FromItemID==75003 or FromItemID==75004 or FromItemID==75005 or FromItemID==75006 or FromItemID==75007 or FromItemID==75008 or FromItemID==75009 or FromItemID==75010) then
			local walkCount = Char.GetData(_PlayerIndex,CONST.CHAR_�߶�����);
			Item.SetData(TargetItemIndex,CONST.����_����, walkCount);
			Item.SetData(TargetItemIndex,CONST.����_����,"["..Item.GetData(FromItemIndex,CONST.����_����).."]��");
			Item.SetData(TargetItemIndex,CONST.����_�Ӳ�һ, FromItemID);
			Item.SetData(TargetItemIndex,CONST.����_�Ӳζ�, 1);
			Item.SetData(TargetItemIndex,CONST.����_������ʧ, 1);
			Item.SetData(TargetItemIndex,CONST.����_����, 0);
			Char.DelItem(_PlayerIndex, FromItemID, 1);
			Item.UpItem(_PlayerIndex, Char.FindItemId(_PlayerIndex, TargetItemID));
			NLG.SystemMessage(_PlayerIndex, "[ϵ�y]ע�⣡���G�ؕ���ʧ���o�����ף�");
			NLG.UpChar(_PlayerIndex);
			return 1;
		end
	elseif (TargetItemID==75001 and walkOn>=1) then
		if (FromItemID==75003 or FromItemID==75004 or FromItemID==75005 or FromItemID==75006 or FromItemID==75007 or FromItemID==75008 or FromItemID==75009 or FromItemID==75010) then
			local setItemID = Item.GetData(TargetItemIndex,CONST.����_�Ӳ�һ);
			local setCount = Item.GetData(TargetItemIndex,CONST.����_�Ӳζ�);
			local typeNum = setCount+1;
			if (setItemID==FromItemID) then
				local walkCount = Char.GetData(_PlayerIndex,CONST.CHAR_�߶�����);
				local Count = walkCount-walkOn;
				Item.SetData(TargetItemIndex,CONST.����_����, "["..Item.GetData(FromItemIndex,CONST.����_����).."]��"..Count.."��");
				Item.SetData(TargetItemIndex,CONST.����_�Ӳζ�, setCount+1);
				NLG.SystemMessage(_PlayerIndex, "[ϵ�y]�۷e "..Item.GetData(FromItemIndex,CONST.����_����).." ����:"..typeNum);
				Char.DelItem(_PlayerIndex, FromItemID, 1);
				Item.UpItem(_PlayerIndex, Char.FindItemId(_PlayerIndex, TargetItemID));
				NLG.UpChar(_PlayerIndex);
				return 1;
			else
				NLG.SystemMessage(_PlayerIndex, "[ϵ�y]���N�ѽ���ֻ���ټ�����ͬ�Ļ��������C�ʣ�");
				return 0;
			end
		end
    	end
	return 0;
end
