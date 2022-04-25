------------------------------------------------------------------------------
local itemid_card = 70001;
local itemid_ball = 69993;
------------------------------------------------------------------------------
local OverSoulEnable = {}
OverSoulEnable[9305] = 0  --0 ��ֹ������������ˮ��������Ϊ����ID
OverSoulEnable[9315] = 0
OverSoulEnable[9325] = 0
OverSoulEnable[9335] = 0
OverSoulEnable[9410] = 0
OverSoulEnable[9420] = 0
OverSoulEnable[9430] = 0
OverSoulEnable[9440] = 0
OverSoulEnable[69129] = 0
OverSoulEnable[69130] = 0
OverSoulEnable[69131] = 0
OverSoulEnable[69132] = 0
OverSoulEnable[69211] = 0
OverSoulEnable[69212] = 0
OverSoulEnable[69213] = 0
OverSoulEnable[69214] = 0
------------------------------------------------------------------------------

Delegate.RegInit("PetMirage_Init");

function initPetMirageNpc_Init(index)
	print("����û�NPC_index = " .. index);
	return 1;
end

function PetMirage_create()
	if (PetMirageNPC == nil) then
		PetMirageNPC = NL.CreateNpc("lua/Module/PetMirage.lua", "initPetMirageNpc_Init");
		Char.SetData(PetMirageNPC,%����_����%,104893);
		Char.SetData(PetMirageNPC,%����_ԭ��%,104893);
		Char.SetData(PetMirageNPC,%����_��ͼ%,1000);
		Char.SetData(PetMirageNPC,%����_X%,232);
		Char.SetData(PetMirageNPC,%����_Y%,83);
		Char.SetData(PetMirageNPC,%����_����%,4);
		Char.SetData(PetMirageNPC,%����_����%,"ͨ����");
		NLG.UpChar(PetMirageNPC);
		Char.SetTalkedEvent("lua/Module/PetMirage.lua", "PetMirageWindow", PetMirageNPC);
		Char.SetWindowTalkedEvent("lua/Module/PetMirage.lua", "PetMirageFunction", PetMirageNPC);
	end
end

function PetMirageWindow(_NpcIndex,_PlayerIndex)
	if (NLG.CanTalk(_NpcIndex,_PlayerIndex) == true) then
		WindowMsg = "3|\\n\\n           ��ѡ����Ҫ����������ĳ���  \\n\\n";
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

NL.RegItemString("lua/Module/PetMirage.lua","TransPet","LUA_useTransPet");
function TransPet(_PlayerIndex,_toIndex,_itemslot) --˫������ִ�к���
	ItemID = Item.GetData(Char.GetItemIndex(_PlayerIndex,_itemslot),0);
	local TalkMsg =		"\\n                �����ﳬ�����" ..
				"\\n��������������Ը�����ˮ��" ..
				"\\n��ʹ��ɫ��۸ı�Ϊ��������" ..
				"\\n " ..
				"\\nж��ˮ�������������״̬" ..
				"\\nװ��ˮ�����ظ�������״̬" ..
				"\\n " ..
				"\\nѡ��    ��������ˮ����"..
				"\\n " 
	NLG.ShowWindowTalked(_PlayerIndex, PetMirageNPC,%����_��Ϣ��%,%��ť_�Ƿ�%, 2, TalkMsg);
	return 1;
end

--����û�
function PetMirageFunction(_NpcIndex,_PlayerIndex,_SqeNo,_select,_data)
	if (_SqeNo ==1) then
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
--		if(Char.GetData(_PetIndex,%����_�ȼ�%) ~= 1) then
--			NLG.SystemMessage(_PlayerIndex,"[ϵͳ]�޷��Է�1��������лû�!");
--			return;
--		end
--		if(Char.GetData(_PetIndex,%����_��ɫ%) ~= 0) then
--			NLG.SystemMessage(_PlayerIndex,"[ϵͳ]�޷���ת��������лû�!");
--			return;
--		end
--		if Char.GetData(_PetIndex,%����_��ȡʱ�ȼ�%) ~= 1 then
--			NLG.SystemMessage(_PlayerIndex,"[ϵͳ] Ұ�������޷��û���")
--			return;
--		end
		local Gold = Char.GetData(_PlayerIndex, %����_���%)
		local nameA = Char.GetData(_PetIndex,%����_����%);
		local mirage = Char.GetData(_PetIndex,%����_����%);
		local mirage1 = Char.GetData(_PetIndex,%����_ԭ��%);
		local ground = Char.GetData(_PetIndex,%����_������%);
		local water = Char.GetData(_PetIndex,%����_ˮ����%);
		local fire = Char.GetData(_PetIndex,%����_������%);
		local wind = Char.GetData(_PetIndex,%����_������%);

		local item_indexB = Char.GetItemIndex(_PlayerIndex,8);
		local nameB = Item.GetData(item_indexB,%����_����%);
		local type = Item.GetData(item_indexB,%����_��������%);
		local Para1 = Item.GetData(item_indexB,%����_�Ӳ�һ%);
		local Para2 = Item.GetData(item_indexB,%����_�Ӳζ�%);

		if (Char.ItemNum(_PlayerIndex,itemid_card) > 0 and Char.ItemNum(_PlayerIndex,itemid_ball) > 0) then
			NLG.SystemMessage(_PlayerIndex,"[ϵͳ]��ȷ����Ʒ��ֻ���г����������︽��ý��");
			return;
		end
		if (Char.ItemNum(_PlayerIndex,itemid_card) > 0 and Para2 == 0 and type == 14 and Gold < 10000) then
			NLG.SystemMessage(_PlayerIndex,"[ϵͳ]��ȷ�Ͻ�Ǯ����һ��!");
			return;
		end
		if (Char.ItemNum(_PlayerIndex,itemid_card) > 0 and Para2 == 0 and type == 14 and Gold >= 10000 and Char.ItemNum(_PlayerIndex,itemid_ball) <=0 ) then
			local Newname = nameA .. nameB;
			Item.SetData(item_indexB,%����_�Ӳζ�%,mirage1);
			Item.SetData(item_indexB,%����_����%,Newname);
			Item.UpItem(_PlayerIndex,8);
			Char.AddGold(_PlayerIndex,-10000);
			Msg = "\\n\\n\\n     ���ĳ��� "..Char.GetData(_PetIndex,%����_����%).." ���帽���ڿ�Ƭ��!   \\n"
					.."  \\n"
					.."            Ѱ�������帽�����\\n"
					.."            �������������ı�\\n";
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_ȷ��%,3,Msg);
			return 0;
		end
		if (Char.ItemNum(_PlayerIndex,itemid_card) > 0 and Para2 ~= 0 and type == 14) then
			NLG.SystemMessage(_PlayerIndex,"[ϵͳ]��ȷ����Ʒ����һ���Ƿ�Ϊδʹ�ó��������");
			return;
		end
		if (Char.ItemNum(_PlayerIndex,itemid_card) >= 0 and type ~= 14) then
			NLG.SystemMessage(_PlayerIndex,"[ϵͳ]��ȷ����Ʒ����һ���Ƿ�Ϊ�����������︽��ý�飡");
			return;
		end
		if (Char.ItemNum(_PlayerIndex,itemid_ball) > 0 and Para2 == 0 and type == 14 and Gold < 100000) then
			NLG.SystemMessage(_PlayerIndex,"[ϵͳ]��ȷ�Ͻ�Ǯ����ʮ��!");
			return;
		end
		if (Char.ItemNum(_PlayerIndex,itemid_ball) > 0 and Para2 == 0 and type == 14 and Gold >= 100000 and Char.ItemNum(_PlayerIndex,itemid_card) <=0 ) then
			local Newname = nameA .. nameB;
			Item.SetData(item_indexB,%����_�Ӳζ�%,mirage1);
			Item.SetData(item_indexB,%����_����%,Newname);
			if (ground >0 and fire < 0)then
				Atype_1 = 1;
				Ameter_1 = ground;
				if (water >0)then
					Atype_2 = 2;
					Ameter_2 = water;
				end
				if (wind >0)then
					Atype_2 = 4;
					Ameter_2 = wind;
				end
			else
				Atype_1 = 3;
				Ameter_1 = fire;
				if (water >0)then
					Atype_2 = 2;
					Ameter_2 = water;
				end
				if (wind >0)then
					Atype_2 = 4;
					Ameter_2 = wind;
				end
			end
			Item.SetData(item_indexB,%����_����һ%,Atype_1);
			Item.SetData(item_indexB,%����_����һֵ%,Ameter_1);
			Item.SetData(item_indexB,%����_���Զ�%,Atype_2);
			Item.SetData(item_indexB,%����_���Զ�ֵ%,Ameter_2);
			Item.UpItem(_PlayerIndex,8);
			Char.AddGold(_PlayerIndex,-100000);
			Msg = "\\n\\n\\n     ���ĳ��� "..Char.GetData(_PetIndex,%����_����%).." ���帽����ý����!   \\n"
					.."            ��˫�����︽��ý��\\n"
					.."            ��ˮ�����Գ������\\n"
					.."  \\n"
					.."            ����װ��ʱ������״̬\\n"
					.."            �������ɸó������\\n";
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_ȷ��%,3,Msg);
			return 0;
		end
		if (Char.ItemNum(_PlayerIndex,itemid_ball) > 0 and Para2 ~= 0 and type == 14) then
			NLG.SystemMessage(_PlayerIndex,"[ϵͳ]��ȷ����Ʒ����һ���Ƿ�Ϊδʹ�ó��︽��ý�飡");
			return;
		end
		if (Char.ItemNum(_PlayerIndex,itemid_ball) >= 0 and type ~= 14) then
			NLG.SystemMessage(_PlayerIndex,"[ϵͳ]��ȷ����Ʒ����һ���Ƿ�Ϊ�����������︽��ý�飡");
			return;
		end
	end
	if (_SqeNo ==2) then
		--ȡ����ť
		local item_indexB = Char.GetItemIndex(_PlayerIndex,Char.FindItemId(_PlayerIndex,ItemID));
		local item_indexC = Char.GetItemIndex(_PlayerIndex,7);
		local TargetItemID = Item.GetData(item_indexC,0);
		local nameC = Item.GetData(item_indexC,%����_����%);
		if (_select==8) then
			return
		end
		if (_select==4 and Item.GetData(item_indexB,%����_�Ӳζ�%)==0) then
			NLG.SystemMessage(_PlayerIndex,"[ϵͳ]��ȷ�ϳ��������Ƿ�����ý���ˣ�");
			return;
		end
		if (nameC == nill) then
			NLG.SystemMessage(_PlayerIndex,"[ϵͳ]��ȷ������װ������ˮ��!");
			return;
		end
		if(string.find(nameC,"in") ~= nill ) then
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]ˮ���޷��������������塣");
			return;
		end
		if (_select==4 and Item.GetData(item_indexB,%����_�Ӳζ�%)~=0 and OverSoulEnable[TargetItemID] ~= 0) then
			local figure = Char.GetData(_PlayerIndex,%����_ԭʼͼ��%);
			local nameB = Item.GetData(item_indexB,%����_����%);
			local nameC = Item.GetData(item_indexC,%����_����%);
			local nameB_R = string.find(nameB,"��");
			local nameA_P= string.sub(nameB, 1, nameB_R-1);
			local Newname = "[" .. nameA_P .. "] in ˮ��" ;
			local Sitting = Item.GetData(item_indexB,%����_�Ӳζ�%);
			local Atype_1 = Item.GetData(item_indexB,%����_����һ%);
			local Ameter_1 = Item.GetData(item_indexB,%����_����һֵ%);
			local Atype_2 = Item.GetData(item_indexB,%����_���Զ�%);
			local Ameter_2 = Item.GetData(item_indexB,%����_���Զ�ֵ%);
			Char.SetData(_PlayerIndex,%����_����%,Sitting);
			Char.SetData(_PlayerIndex,%����_ԭ��%,Sitting);
			Char.SetData(_PlayerIndex,%����_ԭʼͼ��%,Sitting);
			NLG.UpChar(_PlayerIndex);
			Item.SetData(item_indexC,%����_��ǰ��%,Newname);
			Item.SetData(item_indexC,%����_����%,Newname);
			Item.SetData(item_indexC,%����_�Ӳζ�%,Sitting);
			Item.SetData(item_indexC,%����_�Ӳ�һ%,figure);
			Item.SetData(item_indexC,%����_����һ%,Atype_1);
			Item.SetData(item_indexC,%����_����һֵ%,Ameter_1);
			Item.SetData(item_indexC,%����_���Զ�%,Atype_2);
			Item.SetData(item_indexC,%����_���Զ�ֵ%,Ameter_2);
			if (Atype_1 ==1 and Atype_1 ~=3) then
				if (Atype_2 == 2) then
					itemimage = 27513;
					itemdirect = 179205;
				end
				if (Atype_2 == 4) then
					itemimage = 27514;
					itemdirect = 179232;
				end
			else
				if (Atype_2 == 2) then
					itemimage = 27516;
					itemdirect = 179214;
				end
				if (Atype_2 == 4) then
					itemimage = 27515;
					itemdirect = 179223;
				end
			end
			Item.SetData(item_indexC,%����_ͼ%,itemimage);
			Item.SetData(item_indexC,58,itemdirect);
			Item.UpItem(_PlayerIndex,7);
			Char.DelItem(_PlayerIndex,ItemID,1);
			NLG.SystemMessage(_PlayerIndex,"������״̬OVER-SOUL��");
		else
			NLG.SystemMessage(_PlayerIndex,"[ϵͳ]�޷�������������ˮ����");
		end
	end
end

function PetMirage_Init()
	PetMirage_create();

end