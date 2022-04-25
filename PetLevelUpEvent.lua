NL.RegPetLevelUpEvent(nil,"PetLevelUpEvent");
PetTechTable= {}
PetTechTable[1] = {201610,201611,201612,201613,201614}
PetTechTable[2] = {11105,11106,11107,11108,11109}
PetTechTable[3] = {200705,200706,200707,200708,200709}
PetTechTable[4] = {8105,8106,8107,8108,8109}

function PetLevelUpEvent(CharIndex)
	for p=0,4 do
		local pet = Char.GetPet(CharIndex,p);
		if (VaildChar(pet)==true and Char.GetData(pet,%对象_等级%) >= 120) then
			for t = 1,4 do
				for i = 0,9 do
				if Pet.GetSkill(pet,i) == PetTechTable[t][1] then
				Pet.DelSkill(pet,i);
				Pet.AddSkill(pet,PetTechTable[t][2]);
				Pet.UpPet(CharIndex,pet)
				NLG.SystemMessage(CharIndex, "[系统] 宠物技能升级Lv2！")
				else
				end
				end
			end
		else
			--NLG.SystemMessage(CharIndex, "[系统] 没有宠物技能升级！")
		end
		if (VaildChar(pet)==true and Char.GetData(pet,%对象_等级%) >= 140) then
			for t = 1,4 do
				for i = 0,9 do
				if Pet.GetSkill(pet,i) == PetTechTable[t][2] then
				Pet.DelSkill(pet,i);
				Pet.AddSkill(pet,PetTechTable[t][3]);
				Pet.UpPet(CharIndex,pet)
				NLG.SystemMessage(CharIndex, "[系统] 宠物技能升级Lv3！")
				else
				end
				end
			end
		else
			--NLG.SystemMessage(CharIndex, "[系统] 没有宠物技能升级！")
		end
		if (VaildChar(pet)==true and Char.GetData(pet,%对象_等级%) >= 160) then
			for t = 1,4 do
				for i = 0,9 do
				if Pet.GetSkill(pet,i) == PetTechTable[t][3] then
				Pet.DelSkill(pet,i);
				Pet.AddSkill(pet,PetTechTable[t][4]);
				Pet.UpPet(CharIndex,pet)
				NLG.SystemMessage(CharIndex, "[系统] 宠物技能升级Lv4！")
				else
				end
				end
			end
		else
			--NLG.SystemMessage(CharIndex, "[系统] 没有宠物技能升级！")
		end
		if (VaildChar(pet)==true and Char.GetData(pet,%对象_等级%) >= 180) then
			for t = 1,4 do
				for i = 0,9 do
				if Pet.GetSkill(pet,i) == PetTechTable[t][4] then
				Pet.DelSkill(pet,i);
				Pet.AddSkill(pet,PetTechTable[t][5]);
				Pet.UpPet(CharIndex,pet)
				NLG.SystemMessage(CharIndex, "[系统] 宠物技能升级Lv5！")
				else
				end
				end
			end
		else
			--NLG.SystemMessage(CharIndex, "[系统] 没有宠物技能升级！")
		end
	end
	return 0;
end