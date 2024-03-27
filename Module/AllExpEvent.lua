--NL.RegGetExpEvent(nil,"AllExpEvent");
NL.RegBattleSkillExpEvent(nil,"BattleSkillExpEvent");
NL.RegProductSkillExpEvent(nil,"ProductSkillExpEvent");
--expshare_itemid = 70041;
--exp_itemid = 70040;
--playerexp_itemid = 68011;
skillexp_itemid = 68012;
--petexp_itemid = 68013;

--[[
function AllExpEvent(CharIndex, Exp)
	if(Char.IsFeverTime(CharIndex) == 1) then
		Exp = Exp * 2;
	else
		Exp = Exp;
	end
	if(Char.ItemNum(CharIndex,playerexp_itemid) >= 0 or Char.ItemNum(CharIndex,petexp_itemid) >= 0 or Char.ItemNum(CharIndex,expshare_itemid) >= 0 or Char.ItemNum(CharIndex,exp_itemid) >= 0) then
		if(Char.ItemNum(CharIndex,expshare_itemid) > 0) then
			for Slot=0,4 do
				local PetIndex = Char.GetPet(CharIndex,Slot);
				if(PetIndex >=0 and Char.ItemNum(CharIndex,petexp_itemid) == 0) then
					local exp = Char.GetData(PetIndex,%对象_经验%);
					local Ne = exp + Exp;
					Char.SetData(PetIndex,%对象_经验%,Ne);
					NLG.UpChar(PetIndex);
					--NLG.TalkToCli(CharIndex,-1,"[宠物学习器] 角色原始经验已共享给所有宠物！",%颜色_黄色%,%字体_中%);
				end
				if(PetIndex >=0 and Char.ItemNum(CharIndex,petexp_itemid) == 1) then
					local exp = Char.GetData(PetIndex,%对象_经验%);
					local Ne = exp + Exp* 2;
					Char.SetData(PetIndex,%对象_经验%,Ne);
					NLG.UpChar(PetIndex);
					--NLG.TalkToCli(CharIndex,-1,"[宠物学习器] 角色原始经验已双倍共享给所有宠物！",%颜色_黄色%,%字体_中%);
				end
			end
		end
		if(Char.ItemNum(CharIndex,exp_itemid) > 0 and Char.ItemNum(CharIndex,playerexp_itemid) > 0) then
			local ne = Exp * 3;
			--NLG.TalkToCli(CharIndex,-1,"[系统] 角色获取的经验3倍！",%颜色_黄色%,%字体_中%);
			return ne;  --角色获取的经验3倍
		elseif(Char.ItemNum(CharIndex,exp_itemid) > 0 and Char.ItemNum(CharIndex,playerexp_itemid) == 0) then
			local ne = Exp * 1.5;
			--NLG.TalkToCli(CharIndex,-1,"[系统] 角色获取的经验1.5倍！",%颜色_黄色%,%字体_中%);
			return ne;  --角色获取的经验1.5倍
		elseif(Char.ItemNum(CharIndex,exp_itemid) == 0 and Char.ItemNum(CharIndex,playerexp_itemid) > 0) then
			local ne = Exp * 2;
			--NLG.TalkToCli(CharIndex,-1,"[系统] 角色获取的经验双倍！",%颜色_黄色%,%字体_中%);
			return ne;  --角色获取的经验双倍
		end
	end
	--if (Char.GetData(CharIndex,%对象_序%) == %对象类型_人%) and (not Char.IsDummy(CharIndex)) then
	--	for i = 1 , 5 do
	--		if Char.HaveItem(CharIndex,900100) > -1 then
	--		local petIndex = Char.GetPet(CharIndex, i - 1)
	--			if petIndex > 0 then 
	--				Char.SetData(petIndex,CONST.CHAR_经验,Char.GetData(petIndex,CONST.CHAR_经验)+Exp)
	--				return 0
	--			end
	--		end
	--	end
	--end

	return Exp;
end
]]

function BattleSkillExpEvent(CharIndex, SkillID, Exp)
	if(Char.ItemNum(CharIndex,skillexp_itemid) > 0) then
		local ne = Exp * 2;
		--NLG.TalkToCli(CharIndex,-1,"[系统] 角色获取的战斗技能经验双倍！",%颜色_黄色%,%字体_中%);
		return ne;  --角色获取的战斗技能经验双倍
	end
	return Exp;
end

function ProductSkillExpEvent(CharIndex, SkillID, Exp)
	if(Char.ItemNum(CharIndex,skillexp_itemid) > 0) then
		local ne = Exp * 2;
		--NLG.TalkToCli(CharIndex,-1,"[系统] 角色获取的生产技能经验双倍！",%颜色_黄色%,%字体_中%);
		return ne;  --角色获取的生产技能经验双倍
	end
	return Exp;
end
