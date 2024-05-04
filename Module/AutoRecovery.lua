Delegate.RegDelBattleOverEvent("AutoRecovery");
full_itemid = 70039;

function AutoRecovery(battle)
	for BPWhile=0,9 do
		local BPlayerIndex = Battle.GetPlayer(battle,BPWhile);
		if(BPlayerIndex >= 0 and Char.ItemNum(BPlayerIndex,full_itemid) > 0) then
			local HP = Char.GetData(BPlayerIndex,%对象_血%);
			local MP = Char.GetData(BPlayerIndex,%对象_魔%);
			local Full_HP = HP + 50;
			local Full_MP = MP + 50;
			Char.SetData(BPlayerIndex,%对象_血%,Full_HP);
			Char.SetData(BPlayerIndex,%对象_魔%,Full_MP);
			if (Char.GetData(BPlayerIndex, %对象_队聊开关%) == 1)  then
				NLG.TalkToCli(BPlayerIndex,-1,"烤爐將魔物作成美味料理，讓人元氣滿滿！",%颜色_黄色%,%字体_中%);
			end
		end
		if(BPlayerIndex >= 0 and Char.GetData(BPlayerIndex,%对象_等级%) <= 100 and Char.GetData(BPlayerIndex,%对象_血%)<Char.GetData(BPlayerIndex,%对象_最大血%)) then
			Char.SetData(BPlayerIndex,%对象_血%,Char.GetData(BPlayerIndex,%对象_最大血%));
			Char.SetData(BPlayerIndex,%对象_魔%,Char.GetData(BPlayerIndex,%对象_最大魔%));
			NLG.UpChar(BPlayerIndex);
			if (Char.GetData(BPlayerIndex, %对象_队聊开关%) == 1)  then
				NLG.TalkToCli(BPlayerIndex,-1,"[大天使氣息]未滿Lv100受到天使的祝福,生命值與魔力值恢復全滿！",%颜色_黄色%,%字体_中%);
			end
		end
		if(VaildChar(BPlayerIndex)==true and Char.GetData(BPlayerIndex,%对象_类型%) == %对象类型_人%)then
			NLG.SortItem(BPlayerIndex);
			--NLG.SystemMessage(BPlayerIndex,"背包整理完畢。");
		end
	end
	return 1;
end
