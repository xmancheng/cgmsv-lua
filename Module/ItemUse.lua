--药？	魔丸	1			LUA_useItemUseA						70001	98893	10000	43		0	1	1	93	1	1	1	1	100																																																																0	1	0	0		0	140000	1647779	100	0	0	0	0	0
if type(tbl_ItemUse) ~= "table" then tbl_ItemUse = {} end
tbl_ItemUse[1]={{["血"]="+100",["魔"]="+100",},3,"[道具提示]每回合回复生命80 魔力100，持续5回合"}
tbl_ItemUse[2]={{["血"]="-20",["魔"]="+120",},3,"[道具提示]每回合減少生命 20 回復魔力120 持續3回合，第3回合後 攻擊力永久提升105%",3}
tbl_ItemUse[3]={{["血"]="+140",["魔"]="-40",},3,"[道具提示]每回合回復生命140 減少魔力 40 持續3回合，第3回合後 攻擊力永久提升105%",3}
tbl_ItemUse[4]={{["血"]="-60",["魔"]="+260",},3,"[道具提示]每回合減少生命 60 回復魔力260 持續3回合，第3回合後 攻擊力永久提升105%",3}
tbl_ItemUse[5]={{["血"]="+380",["魔"]="-80",},3,"[道具提示]每回合回復生命380 減少魔力 80 持續3回合，第3回合後 攻擊力永久提升105%",3}
--tbl_ItemUse[道具自用参数值]={{["血"]="+100",["魔"]="+100",},持续回合,"[道具提示]每回合回复生命100 魔力100，持续3回合"}
--注意道具叠加数要设置1
local tbl_Round = {}
local tbl_IUse = {}
NL.RegItemString(nil,"ItemUseA","LUA_useItemUseA");
function ItemUseA(CharIndex,ToCharIndex,ItemSlot)
	if(Char.GetBattleIndex(CharIndex) == -1)then
		NLG.SystemMessage(ToCharIndex,"[道具提示]戰鬥中才能使用的道具")
	else
		local ItemIndex = Char.GetItemIndex(CharIndex,ItemSlot)
		local ItemVal = tonumber(Item.GetData(ItemIndex,%道具_自用参数%))
		local ItemID = Item.GetData(ItemIndex,%道具_ID%);
		local battleIndex = Char.GetBattleIndex(CharIndex);
		local leader = Battle.GetPlayer(battleIndex, 0);
		local leaderpet = Battle.GetPlayer(battleIndex, 5);
		if (Char.GetData(leader, %对象_类型%) ==  %对象类型_人%) then
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
			NLG.SystemMessage(leader5,"[道具提示]每場戰鬥只能使用該道具一次")
		end	
	end
	return 0
end

NL.RegBattleActionEvent(nil,"BItemUseA")
function BItemUseA(_PlayerIndex, battle, Com1, Com2, Com3, ActionNum)
	if tbl_Round[_PlayerIndex] == nil then  return end --没有激活BUFF道具
	if tbl_Round[_PlayerIndex] > tbl_ItemUse[tbl_IUse[_PlayerIndex]][2] then  --超过BUFF最大回合
		if tbl_Round[_PlayerIndex] > tbl_ItemUse[tbl_IUse[_PlayerIndex]][4] then
			local Power = Char.GetData(_PlayerIndex,%对象_攻击力%);
			local PEffect = Power*1.05;
			Char.SetData(_PlayerIndex,%对象_攻击力%,PEffect);
			--NLG.SystemMessage(_PlayerIndex,"[道具提示]攻擊力提升105%")
		end
		--NLG.SystemMessage(_PlayerIndex,"[道具提示]每回合持續效果結束")
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
		if tbl_IUse[_PlayerIndex] ~= nil and tbl_ItemUse[tbl_IUse[_PlayerIndex]] ~= nil  then --激活BUFF道具
			tbl_IUse[_PlayerIndex] = nil
			tbl_Round[_PlayerIndex] = nil
		end
	end
	return 0
end

function ItemUseA_val(expr)--字符串进行运算
	f= loadstring('return ' .. expr)
    return f()
end
function ItemUseA_Const(expr)--字符串进行运算
		f = loadstring("local tC = %对象_" .. expr .. "%; return tC;")
    return f()
end
