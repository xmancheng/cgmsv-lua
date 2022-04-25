local EnemyID = {500000,500001,500002,500003,500004,500005,500006,500007,500008,500009};
local Maternal = {arr_rank11,arr_rank12,arr_rank13,arr_rank14,arr_rank15,m6,m7,m8,m9,name,image,tribe};
local Vice = {arr_rank12,arr_rank22,arr_rank23,arr_rank24,arr_rank25,v6,v7,v8,v9};
local ETime = 0;
local E_status = 0;
local mapid = 1000;		--�������ֵ�ͼ���
--
----------------------------------------------------------------------------------------

NL.RegPetFieldEvent(nil,"MyPetPetBreeding");

function MyPetPetBreeding(_PlayerIndex,_PetIndex,PetPos)
	_PetIndex = Char.GetPet(_PlayerIndex,PetPos);
	pItemIndex = Char.GetItemIndex(_PlayerIndex, Char.FindItemId(_PlayerIndex,70188));
	pItemID = Item.GetData(pItemIndex, 0);
	if (VaildChar(pItemIndex) == true and pItemID==70188) then
		satiety = Item.GetData(pItemIndex,%����_�Ӳ�һ%);
		intimacy = Item.GetData(pItemIndex,%����_�Ӳζ�%);
	end
	if (Char.ItemNum(_PlayerIndex,70187) == 0) then
		E_status = 0;
	end
	name = Char.GetData(_PetIndex,%����_����%);
	if (intimacy==100 and E_status==0 and Char.GetData(_PlayerIndex,%����_��ͼ%) ~= mapid) then
		NLG.SystemMessage(_PlayerIndex,"[ϵͳ] ��ǰ����������ר�����أ�");
		return 0;
	end
	if (intimacy==100 and E_status==0 and Char.GetData(_PetIndex,%����_��ɫ%)==6) then
		NLG.SystemMessage(_PlayerIndex,"[ϵͳ] ��ɫ���ֵĳ����޷��������֣�");
		return 0;
	end
	if (intimacy==100 and E_status==0) then
		local name = Char.GetData(_PetIndex,%����_����%);
		Maternal[10] = name;
		Maternal[11] = Char.GetData(_PetIndex,%����_����%);
		Maternal[12] = Char.GetData(_PetIndex,%����_����%);
		Maternal[1] = Pet.FullArtRank(_PetIndex,%�赵_���%);
		Maternal[2] = Pet.FullArtRank(_PetIndex,%�赵_����%);
		Maternal[3] = Pet.FullArtRank(_PetIndex,%�赵_ǿ��%);
		Maternal[4] = Pet.FullArtRank(_PetIndex,%�赵_����%);
		Maternal[5] = Pet.FullArtRank(_PetIndex,%�赵_ħ��%);
		Maternal[6] = Char.GetData(_PetIndex,%����_������%);
		Maternal[7] = Char.GetData(_PetIndex,%����_ˮ����%);
		Maternal[8] = Char.GetData(_PetIndex,%����_������%);
		Maternal[9] = Char.GetData(_PetIndex,%����_������%);
		PetBreedingNpc_Talked( PetBreedingNpc, _PlayerIndex, _Mode);
	end
	if (Char.ItemNum(_PlayerIndex,70187) > 0) then
		E_status = 2;
	end
	if (intimacy==100 and E_status==2 and Char.GetData(_PlayerIndex,%����_��ͼ%) ~= mapid) then
		NLG.SystemMessage(_PlayerIndex,"[ϵͳ] ��ǰ����������ר�����أ�");
		return 0;
	end
	if (intimacy==100 and E_status==2 and Char.GetData(_PetIndex,%����_��ɫ%)==6) then
		NLG.SystemMessage(_PlayerIndex,"[ϵͳ] ��ɫ���ֵĳ����޷��������֣�");
		return 0;
	end
	if (intimacy==100 and E_status==2) then
		Vice[1] = Pet.FullArtRank(_PetIndex,%�赵_���%);
		Vice[2] = Pet.FullArtRank(_PetIndex,%�赵_����%);
		Vice[3] = Pet.FullArtRank(_PetIndex,%�赵_ǿ��%);
		Vice[4] = Pet.FullArtRank(_PetIndex,%�赵_����%);
		Vice[5] = Pet.FullArtRank(_PetIndex,%�赵_ħ��%);
		Vice[6] = Char.GetData(_PetIndex,%����_������%);
		Vice[7] = Char.GetData(_PetIndex,%����_ˮ����%);
		Vice[8] = Char.GetData(_PetIndex,%����_������%);
		Vice[9] = Char.GetData(_PetIndex,%����_������%);
		PetBreedingNpc_Talked( PetBreedingNpc, _PlayerIndex, _Mode);
	end
	return 0;
end

Delegate.RegInit("PetBreedingNpc_Init");

function PetBreedingNpc_Init()
	PetBreedingNpc = NL.CreateNpc(nil, "Myinit");
	Char.SetData(PetBreedingNpc,%����_����%,14682);
	Char.SetData(PetBreedingNpc,%����_ԭ��%,14682);
	Char.SetData(PetBreedingNpc,%����_X%,36);
	Char.SetData(PetBreedingNpc,%����_Y%,33);
	Char.SetData(PetBreedingNpc,%����_��ͼ%,777);
	Char.SetData(PetBreedingNpc,%����_����%,0);
	Char.SetData(PetBreedingNpc,%����_����%,"���ﵰ����");
	NLG.UpChar(PetBreedingNpc);
	Char.SetTalkedEvent(nil, "PetBreedingNpc_Talked", PetBreedingNpc);
	Char.SetWindowTalkedEvent(nil, "PetBreedingNpc_WindowTalked", PetBreedingNpc);
	return true;
end

function Myinit(_MeIndex)
	return true;
end

function PetBreedingNpc_Talked( _NpcIndex, _PlayerIndex, _Mode)
	if (Char.PetNum(_PlayerIndex) >= 5) then
		NLG.SystemMessage(_PlayerIndex, "[ϵͳ] ������λ�ò�����")
		return;
	end
	local WindowMsg =	"\\n                �����ﵰ���֡�" ..
				"\\nѡ����ֻ����չʾ����׼��һ��Ԫ����" ..
				"\\nѡ��ĵ�һֻ��Ϊĸ��" ..
				"\\n�������֡�����ͬĸ��" ..
				"\\n " ..
				"\\n��������������ֵ֮�����" ..
				"\\n�����������ƽ��ֵ����" ..
				"\\n "..
				"\\nѡ��    "..name.."" 
	NLG.ShowWindowTalked(_PlayerIndex, _NpcIndex,%����_��Ϣ��%,%��ť_�Ƿ�%,2,WindowMsg);
	return ;
end


function PetBreedingNpc_WindowTalked( _NpcIndex, _PlayerIndex, _Seqno, _Select, _Data)
	local Gold = Char.GetData(_PlayerIndex, %����_���%);
	local nowTime = os.time();
	if (_Seqno==2) then
		--ȡ����ť
		if (_Select==8) then
			return
		end
		if (_Select==4 and E_status==0 and Gold >= 10000) then
			E_status = 1;
			ETime = os.time();
			Char.GiveItem(_PlayerIndex,70187,1);
			Char.AddGold(_PlayerIndex,-10000);
			eItemIndex = Char.GetItemIndex(_PlayerIndex, Char.FindItemId(_PlayerIndex,70187));
			local egg_name = Item.GetData(eItemIndex,%����_����%);
			local Newname = "[" .. name .. "]" .. egg_name;
			Item.SetData(eItemIndex,%����_����%,Newname);
			Item.UpItem(_PlayerIndex,Char.FindItemId(_PlayerIndex,70187));
			NLG.SystemMessage(_PlayerIndex,"[ϵͳ] ĸ��ѡ����ɣ�");
		end
		if (_Select==4 and E_status==0 and Gold < 10000) then
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,"\\n\\n\\n��ȷ�Ͻ�Ǯ�㹻һ��");
		end
		if (_Select==4 and E_status==2) then
			E_status = 3;
			NLG.SystemMessage(_PlayerIndex,"[ϵͳ] ����ѡ����ɣ�");
		end
	end
	if (_Seqno==1) then
		if (_Select==8) then
			return
		end
		if (_Select==4 and E_status==3 and nowTime - ETime <60) then
			NLG.SystemMessage(_PlayerIndex,"[ϵͳ] ��ȴ����ֳ��ﵰ������");
		end
		if (_Select==4 and E_status == 3 and nowTime - ETime >=60) then
			local enemyid = Maternal[12] + 1;
			Char.AddPet(_PlayerIndex,EnemyID[enemyid]);
			for Slot=0,4 do
				local E_PetIndex = Char.GetPet(_PlayerIndex,Slot);
				local E_image = Char.GetData(E_PetIndex,%����_����%);
				if (E_image == 100902) then
				Pet.SetArtRank(E_PetIndex,%�赵_���%, math.random(Maternal[1],Vice[1]));
				Pet.SetArtRank(E_PetIndex,%�赵_����%, math.random(Maternal[2],Vice[2]));
				Pet.SetArtRank(E_PetIndex,%�赵_ǿ��%, math.random(Maternal[3],Vice[3]));
				Pet.SetArtRank(E_PetIndex,%�赵_����%, math.random(Maternal[4],Vice[4]));
				Pet.SetArtRank(E_PetIndex,%�赵_ħ��%, math.random(Maternal[5],Vice[5]));
				Pet.ReBirth(_PlayerIndex, E_PetIndex);
				Char.SetData(E_PetIndex,%����_������%,(Maternal[6]+Vice[6])/2);
				Char.SetData(E_PetIndex,%����_ˮ����%,(Maternal[7]+Vice[7])/2);
				Char.SetData(E_PetIndex,%����_������%,(Maternal[8]+Vice[8])/2);
				Char.SetData(E_PetIndex,%����_������%,(Maternal[9]+Vice[9])/2);
				Char.SetData(E_PetIndex,%����_����%,Maternal[11]);
				Char.SetData(E_PetIndex,%����_ԭ��%,Maternal[11]);
				Char.SetData(E_PetIndex,%����_����%,Maternal[10]);
				Char.SetData(E_PetIndex,%����_��ɫ%,6);  --���ﵰ����Ϊ��ɫ����
				Pet.UpPet(_PlayerIndex,E_PetIndex);
				Char.DelItem(_PlayerIndex,70187,1);
				NLG.SystemMessage(_PlayerIndex, "[ϵͳ] ���ﵰ����������������")
				end
			end
		end
	end
end

NL.RegItemString("lua/Module/PetBreeding.lua","PetEgg","LUA_usePetEgg");
function PetEgg(_PlayerIndex,_toIndex,_itemslot) --˫������ִ�к���
	if (Char.PetNum(_PlayerIndex) >= 5) then
		NLG.SystemMessage(_PlayerIndex, "[ϵͳ] ������λ�ò�����")
		return;
	end
	local TalkMsg =	"\\n             �����ﵰ���ַ�������" ..
			"\\n " ..
			"\\n               ��ά��������״̬" ..
			"\\n               �����ٴν�������" ..
			"\\n               ������Ϻ���ȴ�" ..
			"\\n                 ��ʮ������" ..
			"\\n " ..
			"\\n "..
			"\\n " 
	NLG.ShowWindowTalked(_PlayerIndex, PetBreedingNpc,%����_��Ϣ��%,%��ť_�Ƿ�%, 1, TalkMsg);
	return 1;
end
