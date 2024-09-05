------------------------------------------------------------------------------
local itemid_18310 = 18310;  --地的水晶碎片
local itemid_18311 = 18311;  --水的水晶碎片
local itemid_18312 = 18312;  --火的水晶碎片
local itemid_18313 = 18313;  --风的水晶碎片
------------------------------------------------------------------------------
local a1 = {%道具_攻击%,5,%道具_精神%,5};
local r1 = {%道具_HP%,200,%道具_MP%,200};
local r2 = {%道具_乱抗%,28,%道具_防御%,200};
local r3 = {%道具_睡抗%,28,%道具_敏捷%,100};
local r4 = {%道具_石抗%,28,%道具_回复%,50};
local r5 = {%道具_HP%,1000,%道具_MP%,1000};
local r6 = {%道具_醉抗%,28,%道具_闪躲%,8};
local r7 = {%道具_毒抗%,28,%道具_必杀%,8};
local r8 = {%道具_忘抗%,28,%道具_反击%,8};
local r9 = {%道具_魔抗%,25,%道具_命中%,8};
local r10 = {%道具_HP%,1500,%道具_MP%,1000};
local Abilitynotes = {a1};                        --每一星固定增加的数值
local Bonus = {r1,r2,r3,r4,r5,r6,r7,r8,r9,r10};   --每十星额外增加的数值
------------------------------------------------------------------------------
local PowerEnable = {}
PowerEnable[9305] = 0  --0 禁止星力强化，括号为道具ID
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
	local Gold = Char.GetData(_PlayerIndex, %对象_金币%);
	local FromItemID = Item.GetData(FromItemIndex,0);
	local TargetItemID = Item.GetData(TargetItemIndex,0);
	local star = Item.GetData(TargetItemIndex,%道具_幸运%);
	local StarGold = star*10;
	local Category1 = Item.GetData(TargetItemIndex,%道具_属性一%);
	local Category2 = Item.GetData(TargetItemIndex,%道具_属性二%);
	local Rate = math.random(1,100);
	if(FromItemID == itemid_18310 or FromItemID == itemid_18311 or FromItemID == itemid_18312 or FromItemID == itemid_18313)then
		if(Item.GetData(TargetItemIndex,%道具_类型%) ~= 22)then
			NLG.SystemMessage(_PlayerIndex,"[系統] 請對水晶進行星力強化！");
		end
		if(Gold < StarGold)then
			NLG.SystemMessage(_PlayerIndex,"[系統] 請確認金錢足夠"..StarGold.."！");
		end
		if(PowerEnable[TargetItemID] == 0)then
			NLG.SystemMessage(_PlayerIndex,"[系統] 選擇的水晶無法星力強化！");
		end
		if (star==0 or star == nill) then
			local TargetName = Item.GetData(TargetItemIndex,%道具_名字%);
			Item.SetData(TargetItemIndex,%道具_鉴前名%,TargetName);
		end
		if (star==100) then
			NLG.SystemMessage(_PlayerIndex,"[系統] "..Item.GetData(TargetItemIndex,%道具_鉴前名%).."已達最高星力！");
		end
	end
	if (PowerEnable[TargetItemID] ~= 0 and FromItemID == itemid_18310 and Item.GetData(TargetItemIndex,%道具_类型%) == 22 and Gold >= StarGold and star <= 99) then
		if (Category1==1 or Category2==1) then
			if (Rate>=star) then
				local OriName = Item.GetData(TargetItemIndex,%道具_鉴前名%);
				local starstate = star + 1;
				Newname = starstate.."星◎" .. OriName;
				Item.SetData(TargetItemIndex,%道具_名字%,Newname);
				local S1 = Item.GetData(TargetItemIndex,Abilitynotes[1][1]);
				local S1_A = S1 + Abilitynotes[1][2];
				local S2 = Item.GetData(TargetItemIndex,Abilitynotes[1][3]);
				local S2_A = S2 + Abilitynotes[1][4];
				Item.SetData(TargetItemIndex,Abilitynotes[1][1],S1_A);
				Item.SetData(TargetItemIndex,Abilitynotes[1][3],S2_A);
				Item.SetData(TargetItemIndex,%道具_幸运%,star+1);
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
				NLG.SystemMessage(_PlayerIndex,"[系統] "..Item.GetData(TargetItemIndex,%道具_鉴前名%).."星力強化成功！");
			else
				Char.AddGold(_PlayerIndex,-StarGold);
				Char.DelItem(_PlayerIndex,itemid_18310,1);
				NLG.SystemMessage(_PlayerIndex,"[系統] "..Item.GetData(TargetItemIndex,%道具_鉴前名%).."星力強化失敗！");
			end
		else
			NLG.SystemMessage(_PlayerIndex,"[系統] 請對相同屬性的水晶進行星力強化！");
		end
	end
	if (PowerEnable[TargetItemID] ~= 0 and FromItemID == itemid_18311 and Item.GetData(TargetItemIndex,%道具_类型%) == 22 and Gold >= StarGold and star <= 99) then
		if (Category1==2 or Category2==2) then
			if (Rate>=star) then
				local OriName = Item.GetData(TargetItemIndex,%道具_鉴前名%);
				local starstate = star + 1;
				Newname = starstate.."星◎" .. OriName;
				Item.SetData(TargetItemIndex,%道具_名字%,Newname);
				local S1 = Item.GetData(TargetItemIndex,Abilitynotes[1][1]);
				local S1_A = S1 + Abilitynotes[1][2];
				local S2 = Item.GetData(TargetItemIndex,Abilitynotes[1][3]);
				local S2_A = S2 + Abilitynotes[1][4];
				Item.SetData(TargetItemIndex,Abilitynotes[1][1],S1_A);
				Item.SetData(TargetItemIndex,Abilitynotes[1][3],S2_A);
				Item.SetData(TargetItemIndex,%道具_幸运%,star+1);
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
				NLG.SystemMessage(_PlayerIndex,"[系統] "..Item.GetData(TargetItemIndex,%道具_鉴前名%).."星力強化成功！");
			else
				Char.AddGold(_PlayerIndex,-StarGold);
				Char.DelItem(_PlayerIndex,itemid_18311,1);
				NLG.SystemMessage(_PlayerIndex,"[系統] "..Item.GetData(TargetItemIndex,%道具_鉴前名%).."星力強化失敗！");
			end
		else
			NLG.SystemMessage(_PlayerIndex,"[系統] 請對相同屬性的水晶進行星力強化！");
		end
	end
	if (PowerEnable[TargetItemID] ~= 0 and FromItemID == itemid_18312 and Item.GetData(TargetItemIndex,%道具_类型%) == 22 and Gold >= StarGold and star <= 99) then
		if (Category1==3 or Category2==3) then
			if (Rate>=star) then
				local OriName = Item.GetData(TargetItemIndex,%道具_鉴前名%);
				local starstate = star + 1;
				Newname = starstate.."星◎" .. OriName;
				Item.SetData(TargetItemIndex,%道具_名字%,Newname);
				local S1 = Item.GetData(TargetItemIndex,Abilitynotes[1][1]);
				local S1_A = S1 + Abilitynotes[1][2];
				local S2 = Item.GetData(TargetItemIndex,Abilitynotes[1][3]);
				local S2_A = S2 + Abilitynotes[1][4];
				Item.SetData(TargetItemIndex,Abilitynotes[1][1],S1_A);
				Item.SetData(TargetItemIndex,Abilitynotes[1][3],S2_A);
				Item.SetData(TargetItemIndex,%道具_幸运%,star+1);
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
				NLG.SystemMessage(_PlayerIndex,"[系統] "..Item.GetData(TargetItemIndex,%道具_鉴前名%).."星力強化成功！");
			else
				Char.AddGold(_PlayerIndex,-StarGold);
				Char.DelItem(_PlayerIndex,itemid_18312,1);
				NLG.SystemMessage(_PlayerIndex,"[系統] "..Item.GetData(TargetItemIndex,%道具_鉴前名%).."星力強化失敗！");
			end
		else
			NLG.SystemMessage(_PlayerIndex,"[系統] 請對相同屬性的水晶進行星力強化！");
		end
	end
	if (PowerEnable[TargetItemID] ~= 0 and FromItemID == itemid_18313 and Item.GetData(TargetItemIndex,%道具_类型%) == 22 and Gold >= StarGold and star <= 99) then
		if (Category1==4 or Category2==4) then
			if (Rate>=star) then
				local OriName = Item.GetData(TargetItemIndex,%道具_鉴前名%);
				local starstate = star + 1;
				Newname = starstate.."星◎" .. OriName;
				Item.SetData(TargetItemIndex,%道具_名字%,Newname);
				local S1 = Item.GetData(TargetItemIndex,Abilitynotes[1][1]);
				local S1_A = S1 + Abilitynotes[1][2];
				local S2 = Item.GetData(TargetItemIndex,Abilitynotes[1][3]);
				local S2_A = S2 + Abilitynotes[1][4];
				Item.SetData(TargetItemIndex,Abilitynotes[1][1],S1_A);
				Item.SetData(TargetItemIndex,Abilitynotes[1][3],S2_A);
				Item.SetData(TargetItemIndex,%道具_幸运%,star+1);
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
				NLG.SystemMessage(_PlayerIndex,"[系統] "..Item.GetData(TargetItemIndex,%道具_鉴前名%).."星力強化成功！");
			else
				Char.AddGold(_PlayerIndex,-StarGold);
				Char.DelItem(_PlayerIndex,itemid_18313,1);
				NLG.SystemMessage(_PlayerIndex,"[系統] "..Item.GetData(TargetItemIndex,%道具_鉴前名%).."星力強化失敗！");
			end
		else
			NLG.SystemMessage(_PlayerIndex,"[系統] 請對相同屬性的水晶進行星力強化！");
		end
	end

	local walkOn = Item.GetData(TargetItemIndex,CONST.道具_幸运);
	if (TargetItemID==75001 and walkOn==0) then
		if (FromItemID==75003 or FromItemID==75004 or FromItemID==75005 or FromItemID==75006 or FromItemID==75007 or FromItemID==75008 or FromItemID==75009 or FromItemID==75010) then
			local walkCount = Char.GetData(_PlayerIndex,CONST.CHAR_走动次数);
			Item.SetData(TargetItemIndex,CONST.道具_幸运, walkCount);
			Item.SetData(TargetItemIndex,CONST.道具_名字,"["..Item.GetData(FromItemIndex,CONST.道具_名字).."]蛋");
			Item.SetData(TargetItemIndex,CONST.道具_子参一, FromItemID);
			Item.SetData(TargetItemIndex,CONST.道具_子参二, 1);
			Item.SetData(TargetItemIndex,CONST.道具_丢地消失, 1);
			Item.SetData(TargetItemIndex,CONST.道具_宠邮, 0);
			Char.DelItem(_PlayerIndex, FromItemID, 1);
			Item.UpItem(_PlayerIndex, Char.FindItemId(_PlayerIndex, TargetItemID));
			NLG.SystemMessage(_PlayerIndex, "[系統]注意！蛋丟地會消失、無法交易！");
			NLG.UpChar(_PlayerIndex);
			return 1;
		end
	elseif (TargetItemID==75001 and walkOn>=1) then
		if (FromItemID==75003 or FromItemID==75004 or FromItemID==75005 or FromItemID==75006 or FromItemID==75007 or FromItemID==75008 or FromItemID==75009 or FromItemID==75010) then
			local setItemID = Item.GetData(TargetItemIndex,CONST.道具_子参一);
			local setCount = Item.GetData(TargetItemIndex,CONST.道具_子参二);
			local typeNum = setCount+1;
			if (setItemID==FromItemID) then
				local walkCount = Char.GetData(_PlayerIndex,CONST.CHAR_走动次数);
				local Count = walkCount-walkOn;
				Item.SetData(TargetItemIndex,CONST.道具_名字, "["..Item.GetData(FromItemIndex,CONST.道具_名字).."]蛋"..Count.."步");
				Item.SetData(TargetItemIndex,CONST.道具_子参二, setCount+1);
				NLG.SystemMessage(_PlayerIndex, "[系統]累積 "..Item.GetData(FromItemIndex,CONST.道具_名字).." 數量:"..typeNum);
				Char.DelItem(_PlayerIndex, FromItemID, 1);
				Item.UpItem(_PlayerIndex, Char.FindItemId(_PlayerIndex, TargetItemID));
				NLG.UpChar(_PlayerIndex);
				return 1;
			else
				NLG.SystemMessage(_PlayerIndex, "[系統]蛋種已綁定只能再加入相同的徽章提升機率！");
				return 0;
			end
		end
    	end
	return 0;
end
