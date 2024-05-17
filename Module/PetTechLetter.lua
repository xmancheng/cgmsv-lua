NL.RegItemString(nil,"My10ItemUse","LUA_useTest10");
NL.RegItemString(nil,"My11ItemUse","LUA_useTest11");
NL.RegItemString(nil,"My12ItemUse","LUA_useTest12");
NL.RegItemString(nil,"My13ItemUse","LUA_useTest13");
NL.RegItemString(nil,"My14ItemUse","LUA_useTest14");
NL.RegItemString(nil,"My15ItemUse","LUA_useTest15");
NL.RegItemString(nil,"My16ItemUse","LUA_useTest16");
NL.RegItemString(nil,"My17ItemUse","LUA_useTest17");
NL.RegItemString(nil,"My18ItemUse","LUA_useTest18");
NL.RegItemString(nil,"My19ItemUse","LUA_useTest19");
NL.RegItemString(nil,"My20ItemUse","LUA_useTest20");

function My10ItemUse(_Player,_toPlayer,_itemSlot)
	local pet = Char.GetPet(_Player,0);
	if (VaildChar(pet)==true and Char.ItemNum(_Player,71020) > 0) then
		for i = 0,9 do
		if Pet.GetSkill(pet,i) == 15002 then
		Pet.DelSkill(pet,i);
		Pet.AddSkill(pet,403);
		Char.DelItem(_Player,71020,1);
		Pet.UpPet(_Player,pet)
		NLG.SystemMessage(_Player, "[系統] 第一格寵物技能學習成功！")
		else

		end
		end
	else
		NLG.SystemMessage(_Player, "[系統] 第一格寵物欄沒有寵物！")
	end
end

function My11ItemUse(_Player,_toPlayer,_itemSlot)
	local pet = Char.GetPet(_Player,0);
	if (VaildChar(pet)==true and Char.ItemNum(_Player,71021) > 0) then
		for i = 0,9 do
		if Pet.GetSkill(pet,i) == 403 then
		Pet.DelSkill(pet,i);
		Pet.AddSkill(pet,405);
		Char.DelItem(_Player,71021,1);
		Pet.UpPet(_Player,pet)
		NLG.SystemMessage(_Player, "[系統] 第一格寵物技能學習成功！")
		else

		end
		end
	else
		NLG.SystemMessage(_Player, "[系統] 第一格寵物欄沒有寵物！")
	end
end

function My12ItemUse(_Player,_toPlayer,_itemSlot)
	local pet = Char.GetPet(_Player,0);
	if (VaildChar(pet)==true and Char.ItemNum(_Player,71022) > 0) then
		for i = 0,9 do
		if Pet.GetSkill(pet,i) == 15002 then
		Pet.DelSkill(pet,i);
		Pet.AddSkill(pet,11100);
		Char.DelItem(_Player,71022,1);
		Pet.UpPet(_Player,pet)
		NLG.SystemMessage(_Player, "[系統] 第一格寵物技能學習成功！")
		else

		end
		end
	else
		NLG.SystemMessage(_Player, "[系統] 第一格寵物欄沒有寵物！")
	end
end

function My13ItemUse(_Player,_toPlayer,_itemSlot)
	local pet = Char.GetPet(_Player,0);
	if (VaildChar(pet)==true and Char.ItemNum(_Player,71023) > 0) then
		for i = 0,9 do
		if Pet.GetSkill(pet,i) == 15002 then
		Pet.DelSkill(pet,i);
		Pet.AddSkill(pet,11105);
		Char.DelItem(_Player,71023,1);
		Pet.UpPet(_Player,pet)
		NLG.SystemMessage(_Player, "[系統] 第一格寵物技能學習成功！")
		else

		end
		end
	else
		NLG.SystemMessage(_Player, "[系統] 第一格寵物欄沒有寵物！")
	end
end

function My14ItemUse(_Player,_toPlayer,_itemSlot)
	local pet = Char.GetPet(_Player,0);
	if (VaildChar(pet)==true and Char.ItemNum(_Player,71024) > 0) then
		for i = 0,9 do
		if Pet.GetSkill(pet,i) == 15002 then
		Pet.DelSkill(pet,i);
		Pet.AddSkill(pet,200705);
		Char.DelItem(_Player,71024,1);
		Pet.UpPet(_Player,pet)
		NLG.SystemMessage(_Player, "[系統] 第一格寵物技能學習成功！")
		else

		end
		end
	else
		NLG.SystemMessage(_Player, "[系統] 第一格寵物欄沒有寵物！")
	end
end

function My15ItemUse(_Player,_toPlayer,_itemSlot)
	local pet = Char.GetPet(_Player,0);
	if (VaildChar(pet)==true and Char.ItemNum(_Player,71025) > 0) then
		for i = 0,9 do
		if Pet.GetSkill(pet,i) == 15002 then
		Pet.DelSkill(pet,i);
		Pet.AddSkill(pet,8105);
		Char.DelItem(_Player,71025,1);
		Pet.UpPet(_Player,pet)
		NLG.SystemMessage(_Player, "[系統] 第一格寵物技能學習成功！")
		else

		end
		end
	else
		NLG.SystemMessage(_Player, "[系統] 第一格寵物欄沒有寵物！")
	end
end

function My16ItemUse(_Player,_toPlayer,_itemSlot)
	local pet = Char.GetPet(_Player,0);
	if (VaildChar(pet)==true and Char.ItemNum(_Player,71026) > 0) then
		for i = 0,9 do
		if Pet.GetSkill(pet,i) == 15002 then
		Pet.DelSkill(pet,i);
		Pet.AddSkill(pet,1319);
		Char.DelItem(_Player,71026,1);
		Pet.UpPet(_Player,pet)
		NLG.SystemMessage(_Player, "[系統] 第一格寵物技能學習成功！")
		else

		end
		end
	else
		NLG.SystemMessage(_Player, "[系統] 第一格寵物欄沒有寵物！")
	end
end

function My17ItemUse(_Player,_toPlayer,_itemSlot)
	local pet = Char.GetPet(_Player,0);
	if (VaildChar(pet)==true and Char.ItemNum(_Player,71027) > 0) then
		for i = 0,9 do
		if Pet.GetSkill(pet,i) == 15002 then
		Pet.DelSkill(pet,i);
		Pet.AddSkill(pet,1419);
		Char.DelItem(_Player,71027,1);
		Pet.UpPet(_Player,pet)
		NLG.SystemMessage(_Player, "[系統] 第一格寵物技能學習成功！")
		else

		end
		end
	else
		NLG.SystemMessage(_Player, "[系統] 第一格寵物欄沒有寵物！")
	end
end

function My18ItemUse(_Player,_toPlayer,_itemSlot)
	local pet = Char.GetPet(_Player,0);
	if (VaildChar(pet)==true and Char.ItemNum(_Player,71028) > 0) then
		for i = 0,9 do
		if Pet.GetSkill(pet,i) == 15002 then
		Pet.DelSkill(pet,i);
		Pet.AddSkill(pet,1519);
		Char.DelItem(_Player,71028,1);
		Pet.UpPet(_Player,pet)
		NLG.SystemMessage(_Player, "[系統] 第一格寵物技能學習成功！")
		else

		end
		end
	else
		NLG.SystemMessage(_Player, "[系統] 第一格寵物欄沒有寵物！")
	end
end

function My19ItemUse(_Player,_toPlayer,_itemSlot)
	local pet = Char.GetPet(_Player,0);
	if (VaildChar(pet)==true and Char.ItemNum(_Player,71029) > 0) then
		for i = 0,9 do
		if Pet.GetSkill(pet,i) == 15002 then
		Pet.DelSkill(pet,i);
		Pet.AddSkill(pet,1619);
		Char.DelItem(_Player,71029,1);
		Pet.UpPet(_Player,pet)
		NLG.SystemMessage(_Player, "[系統] 第一格寵物技能學習成功！")
		else

		end
		end
	else
		NLG.SystemMessage(_Player, "[系統] 第一格寵物欄沒有寵物！")
	end
end

function My20ItemUse(_Player,_toPlayer,_itemSlot)
	local pet = Char.GetPet(_Player,0);
	if (VaildChar(pet)==true and Char.ItemNum(_Player,71030) > 0) then
		for i = 0,9 do
		if Pet.GetSkill(pet,i) == 15002 then
		Pet.DelSkill(pet,i);
		Pet.AddSkill(pet,1719);
		Char.DelItem(_Player,71030,1);
		Pet.UpPet(_Player,pet)
		NLG.SystemMessage(_Player, "[系統] 第一格寵物技能學習成功！")
		else

		end
		end
	else
		NLG.SystemMessage(_Player, "[系統] 第一格寵物欄沒有寵物！")
	end
end
