local mystery = {16440,16441,16442,16443,16444,16445,16446};

NL.RegMergeItemEvent(nil,"Subsidy");

function Subsidy(PlayerIndex, SkillID, SkillLv, ItemIndex)
	if(ItemIndex ~=-1) then
		local Gold = SkillLv*100;
		Char.AddGold(PlayerIndex,Gold);
		NLG.SystemMessage(PlayerIndex,"[系统] 获得"..Gold.."金币！");
		local Rand = math.random(1,100);
		local id = math.random(1,7);
		if(Rand == 100) then
			Char.GiveItem(PlayerIndex,mystery[id],1);
			NLG.SystemMessage(PlayerIndex,"[系统] 恭喜获得神秘物品！");
		end
	end
end