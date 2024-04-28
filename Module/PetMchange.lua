------------------------------------------------------------------------------
local itemid_70001 = 70001;
------------------------------------------------------------------------------

Delegate.RegInit("PetMchange_Init");

function initPetMchangeNpc_Init(index)
	print("具现幻化NPC_index = " .. index);
	return 1;
end

function PetMchange_create()
	if (PetMchangeNPC == nil) then
		PetMchangeNPC = NL.CreateNpc("lua/Module/PetMchange.lua", "initPetMchangeNpc_Init");
		Char.SetData(PetMchangeNPC,%对象_形象%,104892);
		Char.SetData(PetMchangeNPC,%对象_原形%,104892);
		Char.SetData(PetMchangeNPC,%对象_地图%,1180);
		Char.SetData(PetMchangeNPC,%对象_X%,10);
		Char.SetData(PetMchangeNPC,%对象_Y%,16);
		Char.SetData(PetMchangeNPC,%对象_方向%,6);
		Char.SetData(PetMchangeNPC,%对象_名字%,"帕契族");
		NLG.UpChar(PetMchangeNPC);
		Char.SetTalkedEvent("lua/Module/PetMchange.lua", "PetMchangeWindow", PetMchangeNPC);
		Char.SetWindowTalkedEvent("lua/Module/PetMchange.lua", "PetMchangeFunction", PetMchangeNPC);
	end
end

function PetMchangeWindow(_NpcIndex,_PlayerIndex)
	if (NLG.CanTalk(_NpcIndex,_PlayerIndex) == true) then
		WindowMsg = "3|\\n\\n↓選擇附身合體的寵物(使用提取的形象)↓ \\n\\n";
		for i=0,4 do
			local pet = Char.GetPet(_PlayerIndex,i);
	
			if(VaildChar(pet)==false)then
				WindowMsg = WindowMsg .. "空\\n";
			else
				WindowMsg = WindowMsg .. ""..Char.GetData(pet,%对象_名字%).."\\n";
			end
		end		
		NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_选择框%,%按钮_关闭%,1,WindowMsg);
	end
	return;
end

--宠物具现
function PetMchangeFunction(_NpcIndex,_PlayerIndex,_SqeNo,_select,_data)
	local selectitem = tonumber(_data) - 1;
	print(tonumber(_data));
	if(selectitem == nil or selectitem > 4 or selectitem < 0) then
		--NLG.SystemMessage(_PlayerIndex,"[系统]您所选择的位置不正常!");
		return;
	end

	local _PetIndex = Char.GetPet(_PlayerIndex,selectitem);
	if (VaildChar(_PetIndex) == false) then
		NLG.SystemMessage(_PlayerIndex,"[系統]請確定您對應的寵物欄有寵物!");
		return;
	end
--	if(Char.GetData(_PetIndex,%对象_等级%) ~= 1) then
--		NLG.SystemMessage(_PlayerIndex,"[系统]无法对非1级宠物进行附身合体!");
--		return;
--	end
--	if(Char.GetData(_PetIndex,%对象_名色%) ~= 0) then
--		NLG.SystemMessage(_PlayerIndex,"[系统]无法对转生宠物进行附身合体!");
--		return;
--	end
--	if Char.GetData(_PetIndex,%宠物_获取时等级%) ~= 1 then
--		NLG.SystemMessage(_PlayerIndex,"[系统] 野生宠物无法附身合体。")
--		return;
--	end
	local nameA = Char.GetData(_PetIndex,%对象_名字%);
	local mirage = Char.GetData(_PetIndex,%对象_形象%);
	local mirage1 = Char.GetData(_PetIndex,%对象_原形%);
	local item_indexB = Char.GetItemIndex(_PlayerIndex,8);
	local nameB = Item.GetData(item_indexB,%道具_名字%);
	local type = Item.GetData(item_indexB,%道具_特殊类型%);
	local Para1 = Item.GetData(item_indexB,%道具_子参一%);
	local Para2 = Item.GetData(item_indexB,%道具_子参二%);

	if (Char.ItemNum(_PlayerIndex,itemid_70001) > 0 and Para2 ~= 0 and Para1 == 2 and type == 14) then
		Char.SetData(_PetIndex,%对象_形象%,Para2);
		Char.SetData(_PetIndex,%对象_原形%,Para2);
		Pet.UpPet(_PlayerIndex,_PetIndex);
		NLG.SystemMessage(_PlayerIndex,"[系統]您的寵物 "..Char.GetData(_PetIndex,%对象_名字%).." 附身合體完畢!");
		Item.Kill(_PlayerIndex,item_indexB,8);
		return 0;
	end
	if (Char.ItemNum(_PlayerIndex,itemid_70001) > 0 and Para2 == 0 and type == 14) then
		NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄第一欄是否為已使用寵物變身卡！");
		return;
	end
	if (Char.ItemNum(_PlayerIndex,itemid_70001) >= 0 and type ~= 14) then
		NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄第一欄是否為寵物變身卡！");
		return;
	end
	if (Char.ItemNum(_PlayerIndex,itemid_70001) == 0) then
		NLG.SystemMessage(_PlayerIndex,"[系統]請確認物品欄第一欄是否為寵物變身卡！");
		return;
	end
end

function PetMchange_Init()
	PetMchange_create();

end
