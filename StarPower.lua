------------------------------------------------------------------------------
local itemid_18310 = 18310;  --�ص�ˮ����Ƭ
local itemid_18311 = 18311;  --ˮ��ˮ����Ƭ
local itemid_18312 = 18312;  --���ˮ����Ƭ
local itemid_18313 = 18313;  --���ˮ����Ƭ
------------------------------------------------------------------------------
local a1 = {%����_����%,1,%����_����%,3};
local r1 = {%����_HP%,75,%����_MP%,50};
local r2 = {%����_�ҿ�%,28,%����_����%,50};
local r3 = {%����_˯��%,28,%����_����%,30};
local r4 = {%����_ʯ��%,28,%����_�ظ�%,20};
local r5 = {%����_HP%,150,%����_MP%,100};
local r6 = {%����_��%,28,%����_����%,8};
local r7 = {%����_����%,28,%����_��ɱ%,8};
local r8 = {%����_����%,28,%����_����%,8};
local r9 = {%����_ħ��%,25,%����_����%,8};
local r10 = {%����_HP%,300,%����_MP%,200};
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
	local StarGold = star*100;
	local Category1 = Item.GetData(TargetItemIndex,%����_����һ%);
	local Category2 = Item.GetData(TargetItemIndex,%����_���Զ�%);
	local Rate = math.random(1,star);
	if(FromItemID == itemid_18310 or FromItemID == itemid_18311 or FromItemID == itemid_18312 or FromItemID == itemid_18313)then
		if(Item.GetData(TargetItemIndex,%����_����%) ~= 22)then
			NLG.SystemMessage(_PlayerIndex,"[ϵͳ] ���ˮ����������ǿ����");
		end
		if(Gold < StarGold)then
			NLG.SystemMessage(_PlayerIndex,"[ϵͳ] ��ȷ�Ͻ�Ǯ�㹻"..StarGold.."��");
		end
		if(PowerEnable[TargetItemID] == 0)then
			NLG.SystemMessage(_PlayerIndex,"[ϵͳ] ѡ���ˮ���޷�����ǿ����");
		end
		if (star==0 or star == nill) then
			local TargetName = Item.GetData(TargetItemIndex,%����_����%);
			Item.SetData(TargetItemIndex,%����_��ǰ��%,TargetName);
		end
		if (star==100) then
			NLG.SystemMessage(_PlayerIndex,"[ϵͳ] "..Item.GetData(TargetItemIndex,%����_��ǰ��%).."�Ѵ����������");
		end
	end
	if (PowerEnable[TargetItemID] ~= 0 and FromItemID == itemid_18310 and Item.GetData(TargetItemIndex,%����_����%) == 22 and Gold >= StarGold and star <= 99) then
		if (Category1==1 or Category2==1) then
			if (Rate==1) then
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
				NLG.SystemMessage(_PlayerIndex,"[ϵͳ] "..Item.GetData(TargetItemIndex,%����_��ǰ��%).."����ǿ���ɹ���");
			else
				Char.AddGold(_PlayerIndex,-StarGold);
				Char.DelItem(_PlayerIndex,itemid_18310,1);
				NLG.SystemMessage(_PlayerIndex,"[ϵͳ] "..Item.GetData(TargetItemIndex,%����_��ǰ��%).."����ǿ��ʧ�ܣ�");
			end
		else
			NLG.SystemMessage(_PlayerIndex,"[ϵͳ] �����ͬ���Ե�ˮ����������ǿ����");
		end
	end
	if (PowerEnable[TargetItemID] ~= 0 and FromItemID == itemid_18311 and Item.GetData(TargetItemIndex,%����_����%) == 22 and Gold >= StarGold and star <= 99) then
		if (Category1==2 or Category2==2) then
			if (Rate==1) then
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
				NLG.SystemMessage(_PlayerIndex,"[ϵͳ] "..Item.GetData(TargetItemIndex,%����_��ǰ��%).."����ǿ���ɹ���");
			else
				Char.AddGold(_PlayerIndex,-StarGold);
				Char.DelItem(_PlayerIndex,itemid_18311,1);
				NLG.SystemMessage(_PlayerIndex,"[ϵͳ] "..Item.GetData(TargetItemIndex,%����_��ǰ��%).."����ǿ��ʧ�ܣ�");
			end
		else
			NLG.SystemMessage(_PlayerIndex,"[ϵͳ] �����ͬ���Ե�ˮ����������ǿ����");
		end
	end
	if (PowerEnable[TargetItemID] ~= 0 and FromItemID == itemid_18312 and Item.GetData(TargetItemIndex,%����_����%) == 22 and Gold >= StarGold and star <= 99) then
		if (Category1==3 or Category2==3) then
			if (Rate==1) then
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
				NLG.SystemMessage(_PlayerIndex,"[ϵͳ] "..Item.GetData(TargetItemIndex,%����_��ǰ��%).."����ǿ���ɹ���");
			else
				Char.AddGold(_PlayerIndex,-StarGold);
				Char.DelItem(_PlayerIndex,itemid_18312,1);
				NLG.SystemMessage(_PlayerIndex,"[ϵͳ] "..Item.GetData(TargetItemIndex,%����_��ǰ��%).."����ǿ��ʧ�ܣ�");
			end
		else
			NLG.SystemMessage(_PlayerIndex,"[ϵͳ] �����ͬ���Ե�ˮ����������ǿ����");
		end
	end
	if (PowerEnable[TargetItemID] ~= 0 and FromItemID == itemid_18313 and Item.GetData(TargetItemIndex,%����_����%) == 22 and Gold >= StarGold and star <= 99) then
		if (Category1==4 or Category2==4) then
			if (Rate==1) then
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
				NLG.SystemMessage(_PlayerIndex,"[ϵͳ] "..Item.GetData(TargetItemIndex,%����_��ǰ��%).."����ǿ���ɹ���");
			else
				Char.AddGold(_PlayerIndex,-StarGold);
				Char.DelItem(_PlayerIndex,itemid_18313,1);
				NLG.SystemMessage(_PlayerIndex,"[ϵͳ] "..Item.GetData(TargetItemIndex,%����_��ǰ��%).."����ǿ��ʧ�ܣ�");
			end
		else
			NLG.SystemMessage(_PlayerIndex,"[ϵͳ] �����ͬ���Ե�ˮ����������ǿ����");
		end
	end
	return 0;
end
