Delegate.RegDelBattleStartEvent("ScouterReport");
zcq_itemid = 70034;--�����߱��ID,�������޸�

function ScouterReport(battle)
	for BWhile=10,19 do
		local PlayerIndex = Battle.GetPlayer(battle,BWhile);
		
		if(VaildChar(PlayerIndex)==true) then
			if(Char.GetData(PlayerIndex,%����_����%) ~= "ȡ�����") then
				for BPWhile=0,4 do
					local BPlayerIndex = Battle.GetPlayer(battle,BPWhile);
					if(BPlayerIndex >= 0 and Char.ItemNum(BPlayerIndex,zcq_itemid) > 0) then
						local ground = Char.GetData(PlayerIndex,%����_������%);
						local water = Char.GetData(PlayerIndex,%����_ˮ����%);
						local fire = Char.GetData(PlayerIndex,%����_������%);
						local wind = Char.GetData(PlayerIndex,%����_������%);
						local xue = Char.GetData(PlayerIndex,%����_Ѫ%);
						local combat = Char.GetData(PlayerIndex,%����_������%);
						NLG.TalkToCli(BPlayerIndex,-1,"[ʷ�������]"..Char.GetData(PlayerIndex,%����_����%).."Ϊ������".. ground.."��ˮ����".. water.."��������".. fire.."��������".. wind.."������ֵ".. xue.."/".. xue.."��ս�����ߴ�".. combat.."��",%��ɫ_��ɫ%,%����_С%);
					end
				end
			end
		end
	end
end
