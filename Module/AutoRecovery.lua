Delegate.RegDelBattleOverEvent("AutoRecovery");
full_itemid = 70039;

function AutoRecovery(battle)
	for BPWhile=0,9 do
		local BPlayerIndex = Battle.GetPlayer(battle,BPWhile);
		if(BPlayerIndex >= 0 and Char.ItemNum(BPlayerIndex,full_itemid) > 0) then
			local HP = Char.GetData(BPlayerIndex,%����_Ѫ%);
			local MP = Char.GetData(BPlayerIndex,%����_ħ%);
			local Full_HP = HP + 1000;
			local Full_MP = MP + 1000;
			Char.SetData(BPlayerIndex,%����_Ѫ%,Full_HP);
			Char.SetData(BPlayerIndex,%����_ħ%,Full_MP);
			NLG.TalkToCli(BPlayerIndex,-1,"��¯��ħ��������ζ��������Ԫ��������",%��ɫ_��ɫ%,%����_��%);
		end
		if(BPlayerIndex >= 0 and Char.GetData(BPlayerIndex,%����_�ȼ�%) <= 100 and Char.GetData(BPlayerIndex,%����_Ѫ%)<Char.GetData(BPlayerIndex,%����_���Ѫ%)) then
			Char.SetData(BPlayerIndex,%����_Ѫ%,Char.GetData(BPlayerIndex,%����_���Ѫ%));
			Char.SetData(BPlayerIndex,%����_ħ%,Char.GetData(BPlayerIndex,%����_���ħ%));
			NLG.UpChar(BPlayerIndex);
			NLG.TalkToCli(BPlayerIndex,-1,"[����ʹ��Ϣ]δ��Lv100�ܵ���ʹ��ף��,����ֵ��ħ��ֵ�ָ�ȫ����",%��ɫ_��ɫ%,%����_��%);
		end
		if(VaildChar(BPlayerIndex)==true and Char.GetData(BPlayerIndex,%����_����%) == %��������_��%)then
			NLG.SortItem(BPlayerIndex);
			--NLG.SystemMessage(BPlayerIndex,"����������ϡ�");
		end
	end
	return 1;
end