--ҩ��	ħ��	1			LUA_useItemUseA						70001	98893	10000	43		0	1	1	93	1	1	1	1	100																																																																0	1	0	0		0	140000	1647779	100	0	0	0	0	0
if type(tbl_ItemUse) ~= "table" then tbl_ItemUse = {} end
tbl_ItemUse[1]={{["Ѫ"]="+100",["ħ"]="+100",},3,"[������ʾ]ÿ�غϻظ�����80 ħ��100������5�غ�"}
tbl_ItemUse[2]={{["Ѫ"]="-20",["ħ"]="+120",},3,"[������ʾ]ÿ�غϜp������ 20 �؏�ħ��120 ���m3�غϣ���3�غ��� ��������������105%",3}
tbl_ItemUse[3]={{["Ѫ"]="+140",["ħ"]="-40",},3,"[������ʾ]ÿ�غϻ؏�����140 �p��ħ�� 40 ���m3�غϣ���3�غ��� ��������������105%",3}
tbl_ItemUse[4]={{["Ѫ"]="-60",["ħ"]="+260",},3,"[������ʾ]ÿ�غϜp������ 60 �؏�ħ��260 ���m3�غϣ���3�غ��� ��������������105%",3}
tbl_ItemUse[5]={{["Ѫ"]="+380",["ħ"]="-80",},3,"[������ʾ]ÿ�غϻ؏�����380 �p��ħ�� 80 ���m3�غϣ���3�غ��� ��������������105%",3}
--tbl_ItemUse[�������ò���ֵ]={{["Ѫ"]="+100",["ħ"]="+100",},�����غ�,"[������ʾ]ÿ�غϻظ�����100 ħ��100������3�غ�"}
--ע����ߵ�����Ҫ����1
local tbl_Round = {}
local tbl_IUse = {}
NL.RegItemString(nil,"ItemUseA","LUA_useItemUseA");
function ItemUseA(CharIndex,ToCharIndex,ItemSlot)
	if(Char.GetBattleIndex(CharIndex) == -1)then
		NLG.SystemMessage(ToCharIndex,"[������ʾ]���Y�в���ʹ�õĵ���")
	else
		local ItemIndex = Char.GetItemIndex(CharIndex,ItemSlot)
		local ItemVal = tonumber(Item.GetData(ItemIndex,%����_���ò���%))
		local ItemID = Item.GetData(ItemIndex,%����_ID%);
		local battleIndex = Char.GetBattleIndex(CharIndex);
		local leader = Battle.GetPlayer(battleIndex, 0);
		local leaderpet = Battle.GetPlayer(battleIndex, 5);
		if (Char.GetData(leader, %����_����%) ==  %��������_��%) then
			leader5 = leader
		else
			leader5 = leaderpet
		end
		if tbl_IUse[ToCharIndex] == nil then
			tbl_Round[ToCharIndex] = 0
			tbl_IUse[ToCharIndex] = ItemVal
			NLG.SystemMessage(leader5,tbl_ItemUse[ItemVal][3])
			Char.DelItem(CharIndex, ItemID, 1);
			--Item.Kill(CharIndex, ItemIndex, ItemSlot)
		else
			NLG.SystemMessage(leader5,"[������ʾ]ÿ�����Yֻ��ʹ��ԓ����һ��")
		end	
	end
	return 0
end

NL.RegBattleActionEvent(nil,"BItemUseA")
function BItemUseA(_PlayerIndex, battle, Com1, Com2, Com3, ActionNum)
	if tbl_Round[_PlayerIndex] == nil then  return end --û�м���BUFF����
	if tbl_Round[_PlayerIndex] > tbl_ItemUse[tbl_IUse[_PlayerIndex]][2] then  --����BUFF���غ�
		if tbl_Round[_PlayerIndex] > tbl_ItemUse[tbl_IUse[_PlayerIndex]][4] then
			local Power = Char.GetData(_PlayerIndex,%����_������%);
			local PEffect = Power*1.05;
			Char.SetData(_PlayerIndex,%����_������%,PEffect);
			--NLG.SystemMessage(_PlayerIndex,"[������ʾ]����������105%")
		end
		--NLG.SystemMessage(_PlayerIndex,"[������ʾ]ÿ�غϳ��mЧ���Y��")
		return
	end
	for i,v in pairs(tbl_ItemUse[tbl_IUse[_PlayerIndex]][1]) do
		local BName = ItemUseA_Const(i)
		local Old = Char.GetData(_PlayerIndex,BName);
		local BEffect =ItemUseA_val(Old..v)
		Char.SetData(_PlayerIndex,BName,BEffect);
	end
	tbl_Round[_PlayerIndex] = tbl_Round[_PlayerIndex] + 1
	return
end
Delegate.RegDelBattleOverEvent("BBItemUseA_BattleOver")
function BBItemUseA_BattleOver(BattleIndex)	
	for i=0,9 do
		local _PlayerIndex = Battle.GetPlayer(BattleIndex, i)
		if tbl_IUse[_PlayerIndex] ~= nil and tbl_ItemUse[tbl_IUse[_PlayerIndex]] ~= nil  then --����BUFF����
			tbl_IUse[_PlayerIndex] = nil
			tbl_Round[_PlayerIndex] = nil
		end
	end
	return 0
end

function ItemUseA_val(expr)--�ַ�����������
	f= loadstring('return ' .. expr)
    return f()
end
function ItemUseA_Const(expr)--�ַ�����������
		f = loadstring("local tC = %����_" .. expr .. "%; return tC;")
    return f()
end
