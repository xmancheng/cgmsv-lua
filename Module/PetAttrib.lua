------------------------------------------------------------------------------
local itemid_70052 = 70052;
------------------------------------------------------------------------------

Delegate.RegInit("PetAttrib_Init");

function initPetAttribNpc_Init(index)
	print("��������ϴ��NPC_index = " .. index);
	return 1;
end

function PetAttrib_create()
	if (PetAttribNPC == nil) then
		PetAttribNPC = NL.CreateNpc("lua/Module/PetAttrib.lua", "initPetAttribNpc_Init");
		Char.SetData(PetAttribNPC,%����_����%,101025);
		Char.SetData(PetAttribNPC,%����_ԭ��%,101025);
		Char.SetData(PetAttribNPC,%����_��ͼ%,1000);
		Char.SetData(PetAttribNPC,%����_X%,224);
		Char.SetData(PetAttribNPC,%����_Y%,83);
		Char.SetData(PetAttribNPC,%����_����%,4);
		Char.SetData(PetAttribNPC,%����_����%,"����ϴ����ʦ");
		NLG.UpChar(PetAttribNPC);
		Char.SetTalkedEvent("lua/Module/PetAttrib.lua", "PetAttribWindow", PetAttribNPC);
		Char.SetWindowTalkedEvent("lua/Module/PetAttrib.lua", "PetAttribFunction", PetAttribNPC);
	end
end

NL.RegItemString("lua/Module/PetAttrib.lua","PetAttrib","LUA_usePetAtt");
function PetAttrib(_PlayerIndex,_toIndex,_itemslot) --˫������ִ�к���
	if (NLG.CanTalk(PetAttribNPC,_PlayerIndex) == false) then
		WindowMsg = "3|\\n\\n           ��ѡ����Ҫϴ���ĳ�������  \\n\\n";
		for i=0,4 do
			local pet = Char.GetPet(_PlayerIndex,i);
	
			if(VaildChar(pet)==false)then
				WindowMsg = WindowMsg .. "��\\n";
			else
				WindowMsg = WindowMsg .. ""..Char.GetData(pet,%����_����%).."\\n";
			end
		end		
		NLG.ShowWindowTalked(_PlayerIndex,PetAttribNPC,%����_ѡ���%,%��ť_�ر�%,1,WindowMsg);
	end
	return;
end


function PetAttribWindow(_NpcIndex,_PlayerIndex)
	if (NLG.CanTalk(_NpcIndex,_PlayerIndex) == true) then
		WindowMsg = "3|\\n\\n           ��ѡ����Ҫϴ���ĳ�������  \\n\\n";
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

--��������
function PetAttribFunction(_NpcIndex,_PlayerIndex,_SqeNo,_select,_data)
	if (_SqeNo==1) then
		local selectitem = tonumber(_data) - 1;
		print(tonumber(_data));
		if(selectitem == nil or selectitem > 4 or selectitem < 0) then
			NLG.SystemMessage(_PlayerIndex,"[ϵͳ]����ѡ���λ�ò�����!");
			return;
		end
		_PetIndex = Char.GetPet(_PlayerIndex,selectitem);
		if (VaildChar(_PetIndex) == false) then
			NLG.SystemMessage(_PlayerIndex,"[ϵͳ]��ȷ������Ӧ�ĳ������г���!");
			return;
		end
--		if(Char.GetData(_PetIndex,%����_�ȼ�%) ~= 1) then
--			NLG.SystemMessage(_PlayerIndex,"[ϵͳ]�޷��Է�1���������ϴ��!");
--			return;
--		end
		if(Char.GetData(_PetIndex,%����_��ɫ%) ~= 0) then
			NLG.SystemMessage(_PlayerIndex,"[ϵͳ]�޷���ת���������ϴ��!");
			return;
		end
--		if Char.GetData(_PetIndex,%����_��ȡʱ�ȼ�%) ~= 1 then
--			NLG.SystemMessage(_PlayerIndex,"[ϵͳ] Ұ�������޷�ϴ����")
--			return;
--		end
		Level = Char.GetData(_PetIndex,%����_�ȼ�%);
		arr_rank1 = Pet.GetArtRank(_PetIndex,%�赵_���%);
		arr_rank11 = Pet.FullArtRank(_PetIndex,%�赵_���%);
		arr_rank2 = Pet.GetArtRank(_PetIndex,%�赵_����%);
		arr_rank21 = Pet.FullArtRank(_PetIndex,%�赵_����%);
		arr_rank3 = Pet.GetArtRank(_PetIndex,%�赵_ǿ��%);
		arr_rank31 = Pet.FullArtRank(_PetIndex,%�赵_ǿ��%);
		arr_rank4 = Pet.GetArtRank(_PetIndex,%�赵_����%);
		arr_rank41 = Pet.FullArtRank(_PetIndex,%�赵_����%);
		arr_rank5 = Pet.GetArtRank(_PetIndex,%�赵_ħ��%);
		arr_rank51 = Pet.FullArtRank(_PetIndex,%�赵_ħ��%);
		a1 = math.abs(arr_rank1 - arr_rank11);
		a2 = math.abs(arr_rank2 - arr_rank21);
		a3 = math.abs(arr_rank3 - arr_rank31);
		a4 = math.abs(arr_rank4 - arr_rank41);
		a5 = math.abs(arr_rank5 - arr_rank51);
		a6 = a1 + a2+ a3+ a4+ a5;
	end
	if a6 == 0 then
		NLG.SystemMessage(_PlayerIndex,"[ϵͳ]���ĳ��� "..Char.GetData(_PetIndex,%����_����%).." �Ѿ�������!");
		return;
	end
	if a6 > 20 then
		NLG.SystemMessage(_PlayerIndex,"[ϵͳ]�޷��԰׻��������ϴ��!");
		return;
	end
	if (_SqeNo==1 and Char.ItemNum(_PlayerIndex,itemid_70052) == 0) then
		NLG.SystemMessage(_PlayerIndex,"[ϵͳ]��ȷ����Ʒ����ϴ�n����");
		return;
	end
	if (_SqeNo==1 and Char.ItemNum(_PlayerIndex,itemid_70052) > 0) then
		Pet.SetArtRank(_PetIndex,%�赵_���%,Pet.FullArtRank(_PetIndex,%�赵_���%) - math.random(0,4));
		Pet.SetArtRank(_PetIndex,%�赵_����%,Pet.FullArtRank(_PetIndex,%�赵_����%) - math.random(0,4));
		Pet.SetArtRank(_PetIndex,%�赵_ǿ��%,Pet.FullArtRank(_PetIndex,%�赵_ǿ��%) - math.random(0,4));
		Pet.SetArtRank(_PetIndex,%�赵_����%,Pet.FullArtRank(_PetIndex,%�赵_����%) - math.random(0,4));
		Pet.SetArtRank(_PetIndex,%�赵_ħ��%,Pet.FullArtRank(_PetIndex,%�赵_ħ��%) - math.random(0,4));

		Pet.ReBirth(_PlayerIndex, _PetIndex);
		Pet.UpPet(_PlayerIndex,_PetIndex);
		Char.DelItem(_PlayerIndex,itemid_70052,1);
		local arr_rank1_new = Pet.GetArtRank(_PetIndex,%�赵_���%);
		local arr_rank2_new = Pet.GetArtRank(_PetIndex,%�赵_����%);
		local arr_rank3_new = Pet.GetArtRank(_PetIndex,%�赵_ǿ��%);
		local arr_rank4_new = Pet.GetArtRank(_PetIndex,%�赵_����%);
		local arr_rank5_new = Pet.GetArtRank(_PetIndex,%�赵_ħ��%);
		local a1_new = math.abs(arr_rank1_new - arr_rank11);
		local a2_new = math.abs(arr_rank2_new - arr_rank21);
		local a3_new = math.abs(arr_rank3_new - arr_rank31);
		local a4_new = math.abs(arr_rank4_new - arr_rank41);
		local a5_new = math.abs(arr_rank5_new - arr_rank51);
		local a6_new = a1_new + a2_new+ a3_new+ a4_new+ a5_new;
		if(Level~=1) then
			Char.SetData(_PetIndex,%����_������%,Level-1);
			Char.SetData(_PetIndex,%����_�ȼ�%,Level);
			Char.SetData(_PetIndex,%����_����%, (Char.GetData(_PetIndex,%����_����%) + (arr_rank1_new * (1/24) * (Level - 1)*100)) );
			Char.SetData(_PetIndex,%����_����%, (Char.GetData(_PetIndex,%����_����%) + (arr_rank2_new * (1/24) * (Level - 1)*100)) );
			Char.SetData(_PetIndex,%����_ǿ��%, (Char.GetData(_PetIndex,%����_ǿ��%) + (arr_rank3_new * (1/24) * (Level - 1)*100)) );
			Char.SetData(_PetIndex,%����_�ٶ�%, (Char.GetData(_PetIndex,%����_�ٶ�%) + (arr_rank4_new * (1/24) * (Level - 1)*100)) );
			Char.SetData(_PetIndex,%����_ħ��%, (Char.GetData(_PetIndex,%����_ħ��%) + (arr_rank5_new * (1/24) * (Level - 1)*100)) );
			Pet.UpPet(_PlayerIndex,_PetIndex);
		end
		local	PetInfoMsg = "�� �� ��:  "..Char.GetData(_PetIndex,%����_����%).."\\n"
					.."         ���µ��n��    ��ǰ���n�� \\n"
					.."��������:  -"..a1_new.." ��       -"..a1.." �� \\n"
					.."��������:  -"..a2_new.." ��       -"..a2.." �� \\n"
					.."��������:  -"..a3_new.." ��       -"..a3.." �� \\n"
					.."���ݵ���:  -"..a4_new.." ��       -"..a4.." �� \\n"
					.."ħ������:  -"..a5_new.." ��       -"..a5.." �� \\n"
					.."�� �� ��:  -"..a6_new.."         -"..a6.." \\n"
					.."ѡ���ǡ������µ��n     ѡ���񡿻ظ�ǰ���n \\n"
					.."���粻ѡ����رմ��ڻ����µ��n \\n";
		NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�Ƿ�%,12,PetInfoMsg);
	end
	if (_SqeNo==12 and _select==4) then
		NLG.SystemMessage(_PlayerIndex,"[ϵͳ]���ĳ��� "..Char.GetData(_PetIndex,%����_����%).." ϴ�����!");
	end
	if (_SqeNo==12 and _select==8) then
		Pet.SetArtRank(_PetIndex,%�赵_���%,arr_rank1);
		Pet.SetArtRank(_PetIndex,%�赵_����%,arr_rank2);
		Pet.SetArtRank(_PetIndex,%�赵_ǿ��%,arr_rank3);
		Pet.SetArtRank(_PetIndex,%�赵_����%,arr_rank4);
		Pet.SetArtRank(_PetIndex,%�赵_ħ��%,arr_rank5);
		Pet.ReBirth(_PlayerIndex, _PetIndex);
		Pet.UpPet(_PlayerIndex,_PetIndex);
		if(Level~=1) then
			Char.SetData(_PetIndex,%����_������%,Level-1);
			Char.SetData(_PetIndex,%����_�ȼ�%,Level);
			Char.SetData(_PetIndex,%����_����%, (Char.GetData(_PetIndex,%����_����%) + (arr_rank1 * (1/24) * (Level - 1)*100)) );
			Char.SetData(_PetIndex,%����_����%, (Char.GetData(_PetIndex,%����_����%) + (arr_rank2 * (1/24) * (Level - 1)*100)) );
			Char.SetData(_PetIndex,%����_ǿ��%, (Char.GetData(_PetIndex,%����_ǿ��%) + (arr_rank3 * (1/24) * (Level - 1)*100)) );
			Char.SetData(_PetIndex,%����_�ٶ�%, (Char.GetData(_PetIndex,%����_�ٶ�%) + (arr_rank4 * (1/24) * (Level - 1)*100)) );
			Char.SetData(_PetIndex,%����_ħ��%, (Char.GetData(_PetIndex,%����_ħ��%) + (arr_rank5 * (1/24) * (Level - 1)*100)) );
			Pet.UpPet(_PlayerIndex,_PetIndex);
		end
		NLG.SystemMessage(_PlayerIndex,"[ϵͳ]���ĳ��� "..Char.GetData(_PetIndex,%����_����%).." �ظ�����!");
	end
end

function PetAttrib_Init()
	PetAttrib_create();

end