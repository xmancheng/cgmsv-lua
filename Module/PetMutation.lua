------------------------------------------------------------------------------
local StrPetMutationEnable = {}
------------------------------------------------------------------------------
--  һ�����һ��                                          --
StrPetMutationEnable[1] = {"�������","׃������",403001,72001,72002}      --ԭ��,��׃ԭ��,��׃���,���讐׃���߱��
StrPetMutationEnable[2] = {"��ը��","�ۼtը��",403002,72003,72004}

StrPetMutationEnable[3] = {"�تz��Ȯ","�׫F",403003,72005,72006}
StrPetMutationEnable[4] = {"�S���з","�����з",403004,72007,72008}

StrPetMutationEnable[5] = {"�S��","�����S��",403005,72009,72010}
StrPetMutationEnable[6] = {"�侫","���f�侫",403006,72011,72012}

StrPetMutationEnable[7] = {"Һ�Bʷ�Rķ","����Һ�Bʷ�Rķ",403007,72013,72014}
StrPetMutationEnable[8] = {"���","�ѻ����",403008,72015,72016}

StrPetMutationEnable[9] = {"����","�S������",403009,72017,72018}
StrPetMutationEnable[10] = {"ˮ����","����ˮ����",403010,72019,72020}

StrPetMutationEnable[11] = {"������","С����",403011,72021,72022}
StrPetMutationEnable[12] = {"���_","��녌���",403012,72023,72024}

StrPetMutationEnable[13] = {"������","�f����",403013,72025,72026}
StrPetMutationEnable[14] = {"ܥ���x","����x",403014,72027,72028}
StrPetMutationEnable[15] = {"ʯ���","ʯ��ħ��",403015,72029,72030}
------------------------------------------------------------------------------

Delegate.RegInit("PetMutation_Init");

function initPetMutationNpc_Init(index)
	print("���ﲻ�����NPC_index = " .. index);
	return 1;
end

function PetMutation_create()
	if (PetMutationNPC == nil) then
		PetMutationNPC = NL.CreateNpc("lua/Module/PetMutation.lua", "initPetMutationNpc_Init");
		Char.SetData(PetMutationNPC,%����_����%,14087);
		Char.SetData(PetMutationNPC,%����_ԭ��%,14087);
		Char.SetData(PetMutationNPC,%����_��ͼ%,25007);
		Char.SetData(PetMutationNPC,%����_X%,10);
		Char.SetData(PetMutationNPC,%����_Y%,10);
		Char.SetData(PetMutationNPC,%����_����%,6);
		Char.SetData(PetMutationNPC,%����_����%,"�����˲�ʿ");
		NLG.UpChar(PetMutationNPC);
		Char.SetTalkedEvent("lua/Module/PetMutation.lua", "PetMutationWindow", PetMutationNPC);
		Char.SetWindowTalkedEvent("lua/Module/PetMutation.lua", "PetMutationFunction", PetMutationNPC);
	end
end

NL.RegItemString("lua/Module/PetMutation.lua","PetMutation","LUA_usePetMuta");
function PetMutation(_PlayerIndex,_toIndex,_itemslot) --˫������ִ�к���
	if (NLG.CanTalk(PetMutationNPC,_PlayerIndex) == false) then
		WindowMsg = "4|\\n\\nŶ�������������õ��Ǯ�׃�����������׃��������Ҿ͎��㏊������  \\n\\n";
		for i=0,4 do
			local pet = Char.GetPet(_PlayerIndex,i);
	
			if(VaildChar(pet)==false)then
				WindowMsg = WindowMsg .. "��\\n";
			else
				WindowMsg = WindowMsg .. ""..Char.GetData(pet,%����_����%).."\\n";
			end
		end		
		NLG.ShowWindowTalked(_PlayerIndex,PetMutationNPC,%����_ѡ���%,%��ť_�ر�%,5,WindowMsg);
	end
	return;
end


function PetMutationWindow(_NpcIndex,_PlayerIndex)
	if (NLG.CanTalk(_NpcIndex,_PlayerIndex) == true) then
		if (Char.PetNum(_PlayerIndex) >= 5) then
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]������λ�ò�����")
			return;
		end
		for slot=0,4 do
			local R_PetIndex = Char.GetPet(_PlayerIndex,slot);
			local PetID = Char.GetData(R_PetIndex,%����_ԭ��%);
			for i=1,15 do
			if (PetID == StrPetMutationEnable[i][2]) then
				NLG.SystemMessage(_PlayerIndex, "[ϵͳ]����ʱ������������׃�����")
				return;
			end
			end
		end
		WindowMsg = "4|\\n\\n�㎧��Ĳ��ϣ������������׌�@ֻħ��l����׃��Ҫԇԇ���᣿  \\n\\n";
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

--���ﮐ׃
function PetMutationFunction(_NpcIndex,_PlayerIndex,_SqeNo,_select,_data)
	if (_SqeNo==1) then
		selectitem = tonumber(_data) - 1;
		print(tonumber(_data));
		if(selectitem == nil or selectitem > 4 or selectitem < 0) then
			NLG.SystemMessage(_PlayerIndex,"[ϵͳ]����ѡ���λ�ò�����!");
			return;
		end
		_PetIndex = Char.GetPet(_PlayerIndex,selectitem);
		EnemyID = Char.GetData(_PetIndex,%����_ԭ��%);

		if (VaildChar(_PetIndex) == false) then
			NLG.SystemMessage(_PlayerIndex,"[ϵͳ]��ȷ������Ӧ�ĳ������г���!");
			return;
		end
--		if(Char.GetData(_PetIndex,%����_�ȼ�%) ~= 1) then
--			NLG.SystemMessage(_PlayerIndex,"[ϵͳ]�޷��Է�1������������!");
--			return;
--		end
		if(Char.GetData(_PetIndex,%����_��ɫ%) ~= 0) then
			NLG.SystemMessage(_PlayerIndex,"[ϵͳ]�޷���ת������������!");
			return;
		end
--		if Char.GetData(_PetIndex,%����_��ȡʱ�ȼ�%) ~= 1 then
--			NLG.SystemMessage(_PlayerIndex,"[ϵͳ] Ұ�������޷���䡣")
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
		if a6 > 20 then
			NLG.SystemMessage(_PlayerIndex,"[ϵͳ]�޷��԰׻�����������!");
			return;
		end
		local	PetInfoMsg = "�� �� ��:  "..Char.GetData(_PetIndex,%����_����%).."\\n"
					.."         ����  ��  ��  ����\\n"
					.."��������:  -"..a1.." ��      ���ݵ���:  -"..a4.." �� \\n"
					.."��������:  -"..a2.." ��      ħ������:  -"..a5.." �� \\n"
					.."��������:  -"..a3.." ��      �� �� ��:  -"..a6.." \\n"
					.."   \\n"
					.."ÿ����5000�о����ã��������ɹ�\\n"
					.."����ȼ�Խ�ߣ����ɹ���Խ��\\n"
					.."ʧ�ܵõ���Լ1��������20����ͬ��Լ�´αسɹ�\\n"
					.."ѡ���ǡ�������䣬���β���ı� \\n";
		if (Char.ItemNum(_PlayerIndex,StrPetMutationEnable[1][4]) < 20 ) then
			if (EnemyID == StrPetMutationEnable[1][1]) then
				NLG.SystemMessage(_PlayerIndex,"[ϵͳ]��ȷ����Ʒ����������");
			end
		else
			if (EnemyID == StrPetMutationEnable[1][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�Ƿ�%,12,PetInfoMsg);
				EnemyNum = 1;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetMutationEnable[2][4]) < 20 ) then
			if (EnemyID == StrPetMutationEnable[2][1]) then
				NLG.SystemMessage(_PlayerIndex,"[ϵͳ]��ȷ����Ʒ����������");
			end
		else
			if (EnemyID == StrPetMutationEnable[2][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�Ƿ�%,12,PetInfoMsg);
				EnemyNum = 2;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetMutationEnable[3][4]) < 20 ) then
			if (EnemyID == StrPetMutationEnable[3][1]) then
				NLG.SystemMessage(_PlayerIndex,"[ϵͳ]��ȷ����Ʒ����������");
			end
		else
			if (EnemyID == StrPetMutationEnable[3][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�Ƿ�%,12,PetInfoMsg);
				EnemyNum = 3;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetMutationEnable[4][4]) < 20 ) then
			if (EnemyID == StrPetMutationEnable[4][1]) then
				NLG.SystemMessage(_PlayerIndex,"[ϵͳ]��ȷ����Ʒ����������");
			end
		else
			if (EnemyID == StrPetMutationEnable[4][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�Ƿ�%,12,PetInfoMsg);
				EnemyNum = 4;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetMutationEnable[5][4]) < 20 ) then
			if (EnemyID == StrPetMutationEnable[5][1]) then
				NLG.SystemMessage(_PlayerIndex,"[ϵͳ]��ȷ����Ʒ����������");
			end
		else
			if (EnemyID == StrPetMutationEnable[5][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�Ƿ�%,12,PetInfoMsg);
				EnemyNum = 5;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetMutationEnable[6][4]) < 20 ) then
			if (EnemyID == StrPetMutationEnable[6][1]) then
				NLG.SystemMessage(_PlayerIndex,"[ϵͳ]��ȷ����Ʒ����������");
			end
		else
			if (EnemyID == StrPetMutationEnable[6][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�Ƿ�%,12,PetInfoMsg);
				EnemyNum = 6;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetMutationEnable[7][4]) < 20 ) then
			if (EnemyID == StrPetMutationEnable[7][1]) then
				NLG.SystemMessage(_PlayerIndex,"[ϵͳ]��ȷ����Ʒ����������");
			end
		else
			if (EnemyID == StrPetMutationEnable[7][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�Ƿ�%,12,PetInfoMsg);
				EnemyNum = 7;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetMutationEnable[8][4]) < 20 ) then
			if (EnemyID == StrPetMutationEnable[8][1]) then
				NLG.SystemMessage(_PlayerIndex,"[ϵͳ]��ȷ����Ʒ����������");
			end
		else
			if (EnemyID == StrPetMutationEnable[8][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�Ƿ�%,12,PetInfoMsg);
				EnemyNum = 8;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetMutationEnable[9][4]) < 20 ) then
			if (EnemyID == StrPetMutationEnable[9][1]) then
				NLG.SystemMessage(_PlayerIndex,"[ϵͳ]��ȷ����Ʒ����������");
			end
		else
			if (EnemyID == StrPetMutationEnable[9][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�Ƿ�%,12,PetInfoMsg);
				EnemyNum = 9;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetMutationEnable[10][4]) < 20 ) then
			if (EnemyID == StrPetMutationEnable[10][1]) then
				NLG.SystemMessage(_PlayerIndex,"[ϵͳ]��ȷ����Ʒ����������");
			end
		else
			if (EnemyID == StrPetMutationEnable[10][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�Ƿ�%,12,PetInfoMsg);
				EnemyNum = 10;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetMutationEnable[11][4]) < 20 ) then
			if (EnemyID == StrPetMutationEnable[11][1]) then
				NLG.SystemMessage(_PlayerIndex,"[ϵͳ]��ȷ����Ʒ����������");
			end
		else
			if (EnemyID == StrPetMutationEnable[11][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�Ƿ�%,12,PetInfoMsg);
				EnemyNum = 11;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetMutationEnable[12][4]) < 20 ) then
			if (EnemyID == StrPetMutationEnable[12][1]) then
				NLG.SystemMessage(_PlayerIndex,"[ϵͳ]��ȷ����Ʒ����������");
			end
		else
			if (EnemyID == StrPetMutationEnable[12][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�Ƿ�%,12,PetInfoMsg);
				EnemyNum = 12;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetMutationEnable[13][4]) < 20 ) then
			if (EnemyID == StrPetMutationEnable[13][1]) then
				NLG.SystemMessage(_PlayerIndex,"[ϵͳ]��ȷ����Ʒ����������");
			end
		else
			if (EnemyID == StrPetMutationEnable[13][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�Ƿ�%,12,PetInfoMsg);
				EnemyNum = 13;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetMutationEnable[14][4]) < 20 ) then
			if (EnemyID == StrPetMutationEnable[14][1]) then
				NLG.SystemMessage(_PlayerIndex,"[ϵͳ]��ȷ����Ʒ����������");
			end
		else
			if (EnemyID == StrPetMutationEnable[14][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�Ƿ�%,12,PetInfoMsg);
				EnemyNum = 14;
			end
		end
		if (Char.ItemNum(_PlayerIndex,StrPetMutationEnable[15][4]) < 20 ) then
			if (EnemyID == StrPetMutationEnable[15][1]) then
				NLG.SystemMessage(_PlayerIndex,"[ϵͳ]��ȷ����Ʒ����������");
			end
		else
			if (EnemyID == StrPetMutationEnable[15][1]) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�Ƿ�%,12,PetInfoMsg);
				EnemyNum = 15;
			end
		end
	end
	if (_SqeNo==12 and _select==4) then
		if (Char.GetData(_PlayerIndex, %����_���%) < 5000) then
			NLG.SystemMessage(_PlayerIndex,"[ϵͳ]��ȷ�Ͻ�Ǯ����ÿ�ε��о�������ǧ!");
			return;
		end
		local M_Point = 21 - math.ceil(Level/10);
		local M_Rate = math.random( 1, M_Point );
		if ( M_Rate ~=1 and Char.ItemNum(_PlayerIndex,StrPetMutationEnable[EnemyNum][5]) < 20) then
			Char.DelItem(_PlayerIndex,StrPetMutationEnable[EnemyNum][4],20);
			Char.GiveItem(_PlayerIndex,StrPetMutationEnable[EnemyNum][5],1);
			Char.AddGold(_PlayerIndex,-5000);
			NLG.SystemMessage(_PlayerIndex,"[ϵͳ]�˴εı����о�ʧ��!");
			return;
		end
		if ( M_Rate ~=1 and Char.ItemNum(_PlayerIndex,StrPetMutationEnable[EnemyNum][5]) >= 20) then
			Char.AddPet(_PlayerIndex,StrPetMutationEnable[EnemyNum][3]);
			for Slot=0,4 do
				local R_PetIndex = Char.GetPet(_PlayerIndex,Slot);
				local PetID = Char.GetData(R_PetIndex,%����_ԭ��%);
				if (PetID == StrPetMutationEnable[EnemyNum][2] ) then
					Pet.SetArtRank(R_PetIndex,%�赵_���%,Pet.FullArtRank(R_PetIndex,%�赵_���%) - a1);
					Pet.SetArtRank(R_PetIndex,%�赵_����%,Pet.FullArtRank(R_PetIndex,%�赵_����%) - a2);
					Pet.SetArtRank(R_PetIndex,%�赵_ǿ��%,Pet.FullArtRank(R_PetIndex,%�赵_ǿ��%) - a3);
					Pet.SetArtRank(R_PetIndex,%�赵_����%,Pet.FullArtRank(R_PetIndex,%�赵_����%) - a4);
					Pet.SetArtRank(R_PetIndex,%�赵_ħ��%,Pet.FullArtRank(R_PetIndex,%�赵_ħ��%) - a5);
					Pet.ReBirth(_PlayerIndex, R_PetIndex);
					Pet.UpPet(_PlayerIndex,R_PetIndex);
					Char.DelItem(_PlayerIndex,StrPetMutationEnable[EnemyNum][4],20);
					Char.DelItem(_PlayerIndex,StrPetMutationEnable[EnemyNum][5],20);
					Char.DelSlotPet(_PlayerIndex,selectitem);
					Char.AddGold(_PlayerIndex,-5000);
					local arr_rank1_new = Pet.GetArtRank(R_PetIndex,%�赵_���%);
					local arr_rank2_new = Pet.GetArtRank(R_PetIndex,%�赵_����%);
					local arr_rank3_new = Pet.GetArtRank(R_PetIndex,%�赵_ǿ��%);
					local arr_rank4_new = Pet.GetArtRank(R_PetIndex,%�赵_����%);
					local arr_rank5_new = Pet.GetArtRank(R_PetIndex,%�赵_ħ��%);
					if(Level~=1 ) then
						Char.SetData(R_PetIndex,%����_������%,Level-1);
						Char.SetData(R_PetIndex,%����_�ȼ�%,Level);
						Char.SetData(R_PetIndex,%����_����%, (Char.GetData(R_PetIndex,%����_����%) + (arr_rank1_new * (1/24) * (Level - 1)*100)) );
						Char.SetData(R_PetIndex,%����_����%, (Char.GetData(R_PetIndex,%����_����%) + (arr_rank2_new * (1/24) * (Level - 1)*100)) );
						Char.SetData(R_PetIndex,%����_ǿ��%, (Char.GetData(R_PetIndex,%����_ǿ��%) + (arr_rank3_new * (1/24) * (Level - 1)*100)) );
						Char.SetData(R_PetIndex,%����_�ٶ�%, (Char.GetData(R_PetIndex,%����_�ٶ�%) + (arr_rank4_new * (1/24) * (Level - 1)*100)) );
						Char.SetData(R_PetIndex,%����_ħ��%, (Char.GetData(R_PetIndex,%����_ħ��%) + (arr_rank5_new * (1/24) * (Level - 1)*100)) );
						Pet.UpPet(_PlayerIndex,R_PetIndex);
					end
				end
			end
		end
		if ( M_Rate ==1 ) then
			Char.AddPet(_PlayerIndex,StrPetMutationEnable[EnemyNum][3]);
			for Slot=0,4 do
				local R_PetIndex = Char.GetPet(_PlayerIndex,Slot);
				local PetID = Char.GetData(R_PetIndex,%����_ԭ��%);
				if (PetID == StrPetMutationEnable[EnemyNum][2] ) then
					Pet.SetArtRank(R_PetIndex,%�赵_���%,Pet.FullArtRank(R_PetIndex,%�赵_���%) - a1);
					Pet.SetArtRank(R_PetIndex,%�赵_����%,Pet.FullArtRank(R_PetIndex,%�赵_����%) - a2);
					Pet.SetArtRank(R_PetIndex,%�赵_ǿ��%,Pet.FullArtRank(R_PetIndex,%�赵_ǿ��%) - a3);
					Pet.SetArtRank(R_PetIndex,%�赵_����%,Pet.FullArtRank(R_PetIndex,%�赵_����%) - a4);
					Pet.SetArtRank(R_PetIndex,%�赵_ħ��%,Pet.FullArtRank(R_PetIndex,%�赵_ħ��%) - a5);
					Pet.ReBirth(_PlayerIndex, R_PetIndex);
					Pet.UpPet(_PlayerIndex,R_PetIndex);
					Char.DelItem(_PlayerIndex,StrPetMutationEnable[EnemyNum][4],20);
					Char.DelSlotPet(_PlayerIndex,selectitem);
					Char.AddGold(_PlayerIndex,-5000);
					local arr_rank1_new = Pet.GetArtRank(R_PetIndex,%�赵_���%);
					local arr_rank2_new = Pet.GetArtRank(R_PetIndex,%�赵_����%);
					local arr_rank3_new = Pet.GetArtRank(R_PetIndex,%�赵_ǿ��%);
					local arr_rank4_new = Pet.GetArtRank(R_PetIndex,%�赵_����%);
					local arr_rank5_new = Pet.GetArtRank(R_PetIndex,%�赵_ħ��%);
					if(Level~=1 ) then
						Char.SetData(R_PetIndex,%����_������%,Level-1);
						Char.SetData(R_PetIndex,%����_�ȼ�%,Level);
						Char.SetData(R_PetIndex,%����_����%, (Char.GetData(R_PetIndex,%����_����%) + (arr_rank1_new * (1/24) * (Level - 1)*100)) );
						Char.SetData(R_PetIndex,%����_����%, (Char.GetData(R_PetIndex,%����_����%) + (arr_rank2_new * (1/24) * (Level - 1)*100)) );
						Char.SetData(R_PetIndex,%����_ǿ��%, (Char.GetData(R_PetIndex,%����_ǿ��%) + (arr_rank3_new * (1/24) * (Level - 1)*100)) );
						Char.SetData(R_PetIndex,%����_�ٶ�%, (Char.GetData(R_PetIndex,%����_�ٶ�%) + (arr_rank4_new * (1/24) * (Level - 1)*100)) );
						Char.SetData(R_PetIndex,%����_ħ��%, (Char.GetData(R_PetIndex,%����_ħ��%) + (arr_rank5_new * (1/24) * (Level - 1)*100)) );
						Pet.UpPet(_PlayerIndex,R_PetIndex);
					end
				end
			end	
		end
	end
	if (_SqeNo==12 and _select==8) then
		return;
	end
	if (_SqeNo==5) then
		selectitem = tonumber(_data) - 1;
		_PetIndex = Char.GetPet(_PlayerIndex,selectitem);
		EnemyID = Char.GetData(_PetIndex,%����_ԭ��%);
		local ground = Char.GetData(_PetIndex,%����_������%)
		local water = Char.GetData(_PetIndex,%����_ˮ����%)
		local fire = Char.GetData(_PetIndex,%����_������%)
		local wind = Char.GetData(_PetIndex,%����_������%)
		if(selectitem == nil or selectitem > 4 or selectitem < 0) then
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]����ʱ����������׃�����");
			return;
		end
		if(Char.ItemNum(_PlayerIndex,72000) < 100) then
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]�����Ҫ��׃��������100����");
			return;
		end
		if(string.find(EnemyID,"+") ~= nill ) then
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]׃�������ѽ������^��");
			return;
		end
		if(EnemyID == StrPetMutationEnable[1][2] or EnemyID == StrPetMutationEnable[2][2] or EnemyID == StrPetMutationEnable[3][2] or 
			EnemyID == StrPetMutationEnable[4][2] or EnemyID == StrPetMutationEnable[5][2] or EnemyID == StrPetMutationEnable[6][2] or 
			EnemyID == StrPetMutationEnable[7][2] or EnemyID == StrPetMutationEnable[8][2] or EnemyID == StrPetMutationEnable[9][2] or 
			EnemyID == StrPetMutationEnable[10][2] or EnemyID == StrPetMutationEnable[11][2] or EnemyID == StrPetMutationEnable[12][2] or 
			EnemyID == StrPetMutationEnable[13][2] or EnemyID == StrPetMutationEnable[14][2] or EnemyID == StrPetMutationEnable[15][2]) then
			if (ground >0 ) then
				Char.SetData(_PetIndex,%����_������%, Char.GetData(_PetIndex,%����_������%) +10);
				Pet.UpPet(_PlayerIndex,_PetIndex);
			end
			if (water >0 ) then
				Char.SetData(_PetIndex,%����_ˮ����%, Char.GetData(_PetIndex,%����_ˮ����%) +10);
				Pet.UpPet(_PlayerIndex,_PetIndex);
			end
			if (fire >0 ) then
				Char.SetData(_PetIndex,%����_������%, Char.GetData(_PetIndex,%����_������%) +10);
				Pet.UpPet(_PlayerIndex,_PetIndex);
			end
			if (wind >0 ) then
				Char.SetData(_PetIndex,%����_������%, Char.GetData(_PetIndex,%����_������%) +10);
				Pet.UpPet(_PlayerIndex,_PetIndex);
			end
			Char.DelItem(_PlayerIndex,72000,100);
			Char.SetData(_PetIndex,%����_ԭ��%, EnemyID.."+" );
			Pet.UpPet(_PlayerIndex,_PetIndex);
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]׃��������ɹ�!");
		else
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]ֻ��׃��������ԏ�����");
			return;
		end
	end
end

function PetMutation_Init()
	PetMutation_create();

end