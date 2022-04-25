Delegate.RegDelBattleStartEvent("ScouterReport");
zcq_itemid = 70034;--侦测道具编号ID,可自行修改

function ScouterReport(battle)
	for BWhile=10,19 do
		local PlayerIndex = Battle.GetPlayer(battle,BWhile);
		
		if(VaildChar(PlayerIndex)==true) then
			if(Char.GetData(PlayerIndex,%对象_名字%) ~= "取消检测") then
				for BPWhile=0,4 do
					local BPlayerIndex = Battle.GetPlayer(battle,BPWhile);
					if(BPlayerIndex >= 0 and Char.ItemNum(BPlayerIndex,zcq_itemid) > 0) then
						local ground = Char.GetData(PlayerIndex,%对象_地属性%);
						local water = Char.GetData(PlayerIndex,%对象_水属性%);
						local fire = Char.GetData(PlayerIndex,%对象_火属性%);
						local wind = Char.GetData(PlayerIndex,%对象_风属性%);
						local xue = Char.GetData(PlayerIndex,%对象_血%);
						local combat = Char.GetData(PlayerIndex,%对象_攻击力%);
						NLG.TalkToCli(BPlayerIndex,-1,"[史考特侦测]"..Char.GetData(PlayerIndex,%对象_名字%).."为地属性".. ground.."　水属性".. water.."　火属性".. fire.."　风属性".. wind.."，生命值".. xue.."/".. xue.."，战斗力高达".. combat.."！",%颜色_黄色%,%字体_小%);
					end
				end
			end
		end
	end
end
