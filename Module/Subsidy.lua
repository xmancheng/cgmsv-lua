local mystery = {16440,16441,16442,16443,16444,16445,16446};

NL.RegMergeItemEvent(nil,"Subsidy");

function Subsidy(PlayerIndex, SkillID, SkillLv, ItemIndex)
	if(ItemIndex ~=-1) then
		local rand = NLG.Rand(1, SkillLv);
		local Gold = rand*100;
		Char.AddGold(PlayerIndex,Gold);
		NLG.SystemMessage(PlayerIndex,"[系統] 獲得"..Gold.."金幣！");
		local Rand = math.random(1,100);
		local id = math.random(1,7);
		if(Rand >= 90) then
			Char.GiveItem(PlayerIndex,mystery[id],1);
			NLG.SystemMessage(PlayerIndex,"[系統] 恭喜獲得神秘物品！");
		end
	end
end
