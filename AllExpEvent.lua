NL.RegGetExpEvent(nil,"AllExpEvent");
NL.RegBattleSkillExpEvent(nil,"AllSkillExpEvent");
expshare_itemid = 70041;
exp_itemid = 70040;
playerexp_itemid = 68011;
skillexp_itemid = 68012;
petexp_itemid = 68013;

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
					local exp = Char.GetData(PetIndex,%����_����%);
					local Ne = exp + Exp;
					Char.SetData(PetIndex,%����_����%,Ne);
					NLG.UpChar(PetIndex);
					--NLG.TalkToCli(CharIndex,-1,"[����ѧϰ��] ��ɫԭʼ�����ѹ�������г��",%��ɫ_��ɫ%,%����_��%);
				end
				if(PetIndex >=0 and Char.ItemNum(CharIndex,petexp_itemid) == 1) then
					local exp = Char.GetData(PetIndex,%����_����%);
					local Ne = exp + Exp* 2;
					Char.SetData(PetIndex,%����_����%,Ne);
					NLG.UpChar(PetIndex);
					--NLG.TalkToCli(CharIndex,-1,"[����ѧϰ��] ��ɫԭʼ������˫����������г��",%��ɫ_��ɫ%,%����_��%);
				end
			end
		end
		if(Char.ItemNum(CharIndex,exp_itemid) > 0 and Char.ItemNum(CharIndex,playerexp_itemid) > 0) then
			local ne = Exp * 3;
			--NLG.TalkToCli(CharIndex,-1,"[ϵͳ] ��ɫ��ȡ�ľ���3����",%��ɫ_��ɫ%,%����_��%);
			return ne;  --��ɫ��ȡ�ľ���3��
		elseif(Char.ItemNum(CharIndex,exp_itemid) > 0 and Char.ItemNum(CharIndex,playerexp_itemid) == 0) then
			local ne = Exp * 1.5;
			--NLG.TalkToCli(CharIndex,-1,"[ϵͳ] ��ɫ��ȡ�ľ���1.5����",%��ɫ_��ɫ%,%����_��%);
			return ne;  --��ɫ��ȡ�ľ���1.5��
		elseif(Char.ItemNum(CharIndex,exp_itemid) == 0 and Char.ItemNum(CharIndex,playerexp_itemid) > 0) then
			local ne = Exp * 2;
			--NLG.TalkToCli(CharIndex,-1,"[ϵͳ] ��ɫ��ȡ�ľ���˫����",%��ɫ_��ɫ%,%����_��%);
			return ne;  --��ɫ��ȡ�ľ���˫��
		end
	end
	return Exp;
end

function AllSkillExpEvent(CharIndex, SkillID, Exp)
	if(Char.ItemNum(CharIndex,skillexp_itemid) > 0) then
		local ne = Exp * 2;
		--NLG.TalkToCli(CharIndex,-1,"[ϵͳ] ��ɫ��ȡ�ļ��ܾ���˫����",%��ɫ_��ɫ%,%����_��%);
		return ne;  --��ɫ��ȡ��ս�����ܾ���˫��
	end
	return Exp;
end
