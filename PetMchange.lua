------------------------------------------------------------------------------
local itemid_70001 = 70001;
------------------------------------------------------------------------------

Delegate.RegInit("PetMchange_Init");

function initPetMchangeNpc_Init(index)
	print("���ֻû�NPC_index = " .. index);
	return 1;
end

function PetMchange_create()
	if (PetMchangeNPC == nil) then
		PetMchangeNPC = NL.CreateNpc("lua/Module/PetMchange.lua", "initPetMchangeNpc_Init");
		Char.SetData(PetMchangeNPC,%����_����%,104892);
		Char.SetData(PetMchangeNPC,%����_ԭ��%,104892);
		Char.SetData(PetMchangeNPC,%����_��ͼ%,1000);
		Char.SetData(PetMchangeNPC,%����_X%,233);
		Char.SetData(PetMchangeNPC,%����_Y%,83);
		Char.SetData(PetMchangeNPC,%����_����%,4);
		Char.SetData(PetMchangeNPC,%����_����%,"������");
		NLG.UpChar(PetMchangeNPC);
		Char.SetTalkedEvent("lua/Module/PetMchange.lua", "PetMchangeWindow", PetMchangeNPC);
		Char.SetWindowTalkedEvent("lua/Module/PetMchange.lua", "PetMchangeFunction", PetMchangeNPC);
	end
end

function PetMchangeWindow(_NpcIndex,_PlayerIndex)
	if (NLG.CanTalk(_NpcIndex,_PlayerIndex) == true) then
		WindowMsg = "3|\\n\\n           ��ѡ����Ҫ�������ĳ���  \\n\\n";
		for i=0,4 do
			local pet = Char.GetPet(_PlayerIndex,i);
	
			if(VaildChar(pet)==false)then
				WindowMsg = WindowMsg .. "��\\n";
			else
				WindowMsg = WindowMsg .. ""..Char.GetData(pet,%����_����%).."\\n";
			end
		end		
		NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_ѡ���%,%��ť_�ر�%,1,WindowMsg);
	end
	return;
end

--�������
function PetMchangeFunction(_NpcIndex,_PlayerIndex,_SqeNo,_select,_data)
	local selectitem = tonumber(_data) - 1;
	print(tonumber(_data));
	if(selectitem == nil or selectitem > 4 or selectitem < 0) then
		NLG.SystemMessage(_PlayerIndex,"[ϵͳ]����ѡ���λ�ò�����!");
		return;
	end

	local _PetIndex = Char.GetPet(_PlayerIndex,selectitem);
	if (VaildChar(_PetIndex) == false) then
		NLG.SystemMessage(_PlayerIndex,"[ϵͳ]��ȷ������Ӧ�ĳ������г���!");
		return;
	end
--	if(Char.GetData(_PetIndex,%����_�ȼ�%) ~= 1) then
--		NLG.SystemMessage(_PlayerIndex,"[ϵͳ]�޷��Է�1��������и������!");
--		return;
--	end
--	if(Char.GetData(_PetIndex,%����_��ɫ%) ~= 0) then
--		NLG.SystemMessage(_PlayerIndex,"[ϵͳ]�޷���ת��������и������!");
--		return;
--	end
--	if Char.GetData(_PetIndex,%����_��ȡʱ�ȼ�%) ~= 1 then
--		NLG.SystemMessage(_PlayerIndex,"[ϵͳ] Ұ�������޷�������塣")
--		return;
--	end
	local nameA = Char.GetData(_PetIndex,%����_����%);
	local mirage = Char.GetData(_PetIndex,%����_����%);
	local mirage1 = Char.GetData(_PetIndex,%����_ԭ��%);
	local item_indexB = Char.GetItemIndex(_PlayerIndex,8);
	local nameB = Item.GetData(item_indexB,%����_����%);
	local type = Item.GetData(item_indexB,%����_��������%);
	local Para1 = Item.GetData(item_indexB,%����_�Ӳ�һ%);
	local Para2 = Item.GetData(item_indexB,%����_�Ӳζ�%);

	if (Char.ItemNum(_PlayerIndex,itemid_70001) > 0 and Para2 ~= 0 and Para1 == 2 and type == 14) then
		Char.SetData(_PetIndex,%����_����%,Para2);
		Char.SetData(_PetIndex,%����_ԭ��%,Para2);
		Pet.UpPet(_PlayerIndex,_PetIndex);
		NLG.SystemMessage(_PlayerIndex,"[ϵͳ]���ĳ��� "..Char.GetData(_PetIndex,%����_����%).." ����������!");
		Item.Kill(_PlayerIndex,item_indexB,8);
		return 0;
	end
	if (Char.ItemNum(_PlayerIndex,itemid_70001) > 0 and Para2 == 0 and type == 14) then
		NLG.SystemMessage(_PlayerIndex,"[ϵͳ]��ȷ����Ʒ����һ���Ƿ�Ϊ��ʹ�ó��������");
		return;
	end
	if (Char.ItemNum(_PlayerIndex,itemid_70001) >= 0 and type ~= 14) then
		NLG.SystemMessage(_PlayerIndex,"[ϵͳ]��ȷ����Ʒ����һ���Ƿ�Ϊ���������");
		return;
	end
	if (Char.ItemNum(_PlayerIndex,itemid_70001) == 0) then
		NLG.SystemMessage(_PlayerIndex,"[ϵͳ]��ȷ����Ʒ����һ���Ƿ�Ϊ���������");
		return;
	end
end

function PetMchange_Init()
	PetMchange_create();

end