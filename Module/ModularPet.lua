local StrModpetEnable = {}
local StrMax_BP = {}
local StrMax_CI = {}
local StrMax_AB = {}
local StrPetID = {}
local StrItemID = {}
local StrEnemyID = {}

--  һ�ֵ���һ�Σ������θ��ƺ����޸�
local ItemID = 68006                                            --�Զ�����ﵰ���߱��
StrModpetEnable[ItemID] = 1                                     --
StrItemID[ItemID] = 68006                                       --�Զ�����ﵰ���߱��
StrMax_BP[ItemID] = 160                                         --�ܺ�BP���ֵ
StrMax_CI[ItemID] = 20                                          --�ܺ����������ֵ
StrMax_AB[ItemID] = 10                                          --�ܺ����������ֵ
StrPetID[ItemID] = {107710,107711,107712,107713,110396,104338}	--�����Զ���ͼ�n���
StrEnemyID[ItemID] = 500007                                     --Enemybase���
--
local ItemID = 68007                                            --�Զ�����ﵰ���߱��
StrModpetEnable[ItemID] = 1                                     --
StrItemID[ItemID] = 68007                                       --�Զ�����ﵰ���߱��
StrMax_BP[ItemID] = 170                                         --�ܺ�BP���ֵ
StrMax_CI[ItemID] = 30                                          --�ܺ����������ֵ
StrMax_AB[ItemID] = 14                                          --�ܺ����������ֵ
StrPetID[ItemID] = {101712,101713,101714}	                --�����Զ���ͼ�n���
StrEnemyID[ItemID] = 500001                                     --Enemybase���
--
local ItemID = 68008                                            --�Զ�����ﵰ���߱��
StrModpetEnable[ItemID] = 1                                     --
StrItemID[ItemID] = 68008                                       --�Զ�����ﵰ���߱��
StrMax_BP[ItemID] = 180                                         --�ܺ�BP���ֵ
StrMax_CI[ItemID] = 35                                          --�ܺ����������ֵ
StrMax_AB[ItemID] = 16                                          --�ܺ����������ֵ
StrPetID[ItemID] = {110556,110557,110558,110559,110560,110561}	--�����Զ���ͼ�n���
StrEnemyID[ItemID] = 500002                                     --Enemybase���
--
local ItemID = 68009                                            --�Զ�����ﵰ���߱��
StrModpetEnable[ItemID] = 1                                     --
StrItemID[ItemID] = 68009                                       --�Զ�����ﵰ���߱��
StrMax_BP[ItemID] = 190                                         --�ܺ�BP���ֵ
StrMax_CI[ItemID] = 40                                          --�ܺ����������ֵ
StrMax_AB[ItemID] = 18                                          --�ܺ����������ֵ
StrPetID[ItemID] = {101622,101623,101934,101244,101245,101824}	--�����Զ���ͼ�n���
StrEnemyID[ItemID] = 500009                                     --Enemybase���
----------------------------------------------------------------------------------------
Delegate.RegInit("ModularPetNpc_Init");
Delegate.RegDelTalkEvent("ModularPet_TalkEvent");

function ModularPetNpc_Init()
	ModularPetNpc = NL.CreateNpc(nil, "Myinit");
	Char.SetData(ModularPetNpc,%����_����%,14682);
	Char.SetData(ModularPetNpc,%����_ԭ��%,14682);
	Char.SetData(ModularPetNpc,%����_X%,36);
	Char.SetData(ModularPetNpc,%����_Y%,35);
	Char.SetData(ModularPetNpc,%����_��ͼ%,777);
	Char.SetData(ModularPetNpc,%����_����%,0);
	Char.SetData(ModularPetNpc,%����_����%,"�Զ�����ﵰ");
	NLG.UpChar(ModularPetNpc);
	tbl_ModularPetNpc = tbl_ModularPetNpc or {}
	tbl_ModularPetNpc["ModularPetNpc"] = ModularPetNpc;
	Char.SetTalkedEvent(nil, "ModularPetNpc_Talked", ModularPetNpc);
	Char.SetWindowTalkedEvent(nil, "ModularPetNpc_WindowTalked", ModularPetNpc);
	return true;
end

function Myinit(_MeIndex)
	return true;
end

function ModularPetNpc_Talked( _MeIndex, _PlayerIndex, _Mode)
	if (Char.PetNum(_PlayerIndex) >= 5) then
		NLG.SystemMessage(_PlayerIndex, "[ϵͳ]������λ�ò�����")
		return;
	end
	if (VaildChar(Char.HavePet(_PlayerIndex,500000)) == true) then
		NLG.SystemMessage(_PlayerIndex, "[ϵͳ]����ʱ������ֻ����һֻ�Զ�����")
		return;
	end
	if (VaildChar(Char.HavePet(_PlayerIndex,500001)) == true) then
		NLG.SystemMessage(_PlayerIndex, "[ϵͳ]����ʱ������ֻ����һֻ�Զ�����")
		return;
	end
	if (VaildChar(Char.HavePet(_PlayerIndex,500002)) == true) then
		NLG.SystemMessage(_PlayerIndex, "[ϵͳ]����ʱ������ֻ����һֻ�Զ�����")
		return;
	end
	if (VaildChar(Char.HavePet(_PlayerIndex,500003)) == true) then
		NLG.SystemMessage(_PlayerIndex, "[ϵͳ]����ʱ������ֻ����һֻ�Զ�����")
		return;
	end
	if (VaildChar(Char.HavePet(_PlayerIndex,500004)) == true) then
		NLG.SystemMessage(_PlayerIndex, "[ϵͳ]����ʱ������ֻ����һֻ�Զ�����")
		return;
	end
	if (VaildChar(Char.HavePet(_PlayerIndex,500005)) == true) then
		NLG.SystemMessage(_PlayerIndex, "[ϵͳ]����ʱ������ֻ����һֻ�Զ�����")
		return;
	end
	if (VaildChar(Char.HavePet(_PlayerIndex,500006)) == true) then
		NLG.SystemMessage(_PlayerIndex, "[ϵͳ]����ʱ������ֻ����һֻ�Զ�����")
		return;
	end
	if (VaildChar(Char.HavePet(_PlayerIndex,500007)) == true) then
		NLG.SystemMessage(_PlayerIndex, "[ϵͳ]����ʱ������ֻ����һֻ�Զ�����")
		return;
	end
	if (VaildChar(Char.HavePet(_PlayerIndex,500008)) == true) then
		NLG.SystemMessage(_PlayerIndex, "[ϵͳ]����ʱ������ֻ����һֻ�Զ�����")
		return;
	end
	if (VaildChar(Char.HavePet(_PlayerIndex,500009)) == true) then
		NLG.SystemMessage(_PlayerIndex, "[ϵͳ]����ʱ������ֻ����һֻ�Զ�����")
		return;
	end
	local TalkMsg =	"4\\n���Զ�����ﵰ��" ..
			"\\n���ɱ༭һֻ�����ϵͳ" ..
			"\\n�������Ρ����������ԡ����͡�ԭʼ����" ..
			"\\n��������в�������״̬���" ..
			"\\n��1.���Ρ�" ..
			"\\n��2.������" ..
			"\\n��3.���ԡ�" ..
			"\\n��4.���͡�"..
			"\\n��5.ȡ��ȷ�ϡ�" 
	TalkMsg =Shor_GAMsgFormat(TalkMsg);
	Shor_ShowGAWindowTalk(_PlayerIndex, 2, 2, 1,TalkMsg,_MeIndex);
	return ;
end

function Shor_ShowGAWindowTalk(_PlayerIndex,_Window, _Select,_Seqno,_Data,_MePtr)
	return NLG.ShowWindowTalked(_PlayerIndex,_MePtr,_Window,_Select,_Seqno,_Data);
end

function Shor_GAMsgFormat(Msg)
	local tMsg = Split(Msg,"\\n")
	local NewMsg=""
	for i=1,#tMsg do
		if tMsg[i]~="" and string.find(tMsg[i],"|")==nil then
			NewMsg=NewMsg..Shor_strFormat(tMsg[i],45,2).."\\n"
		else
			NewMsg=NewMsg..tMsg[i].."\\n"
		end
		
	end
	return NewMsg
end

function Shor_strFormat(str,str_len,str_type)
	if string.len(str)>str_len then
		str = string.sub(str,1,str_len)
	end
	if(str_type == 3) then
		str_tmp=string.format("%"..str_len.."s", str);
	elseif(str_type == 1) then
		str_tmp=string.format("%-"..str_len.."s", str);
	elseif(str_type == 2) then
		local tmp_splace=math.floor((str_len-string.len(str))/2)+string.len(str);
		str_tmp=string.format("%"..tmp_splace.."s", str);
		str_tmp=string.format("%-"..str_len.."s", str_tmp);
	end
	return str_tmp;
end

NL.RegItemString("lua/Module/ModularPet.lua","ModularPet","LUA_useModPet");
function ModularPet(_PlayerIndex,_toIndex,_itemslot) --˫������ִ�к���
	ModularPetNpc_Talked(tbl_ModularPetNpc["ModularPetNpc"], _PlayerIndex, 0, 0, 0)
	return 1;
end

function ModularPet_TalkEvent(player,msg,color,range,size)
	if msg == "[modpet]" then
		ModularPetNpc_Talked(tbl_ModularPetNpc["ModularPetNpc"], player, 0, 0, 0)
	end
end

function ModularPetNpc_WindowTalked( _MeIndex, _PlayerIndex, _Seqno, _Select, _Data)
	local CdKey = Char.GetData(_PlayerIndex, %����_CDK%)
	for i=8,20 do
		tItemIndex = Char.GetItemIndex(_PlayerIndex, i);
		tItemID = Item.GetData(tItemIndex, 0);
		if (VaildChar(tItemIndex) == true and StrModpetEnable[tItemID] == 1) then
			bItemID = StrItemID[tItemID]
			tMax_BP = StrMax_BP[tItemID]
			tMax_CI = StrMax_CI[tItemID]
			tMax_AB = StrMax_AB[tItemID]
			tPetID = StrPetID[tItemID]
			tEnemyID = StrEnemyID[tItemID]
		end
		if StrModpetEnable[tItemID] ~= 1 then
			--NLG.SystemMessage(_PlayerIndex, "[ϵͳ]ȱ�ٶ�Ӧ�ĵ��ߡ�")
		end
	end
	--ȡ����ť
	if _Select==2 then
		return
	end
	
	if _Seqno==1 then
		local PlayerSelect = tonumber(_Data)
		--��ѯ
		if PlayerSelect==1 then
			local TalkBuf =	"4\\n������Ŀ��"..tMax_BP.."�㣺" ..
					"\\n�������13�㣬���55��" ..
					"\\n��������б༭" ..
					"\\n " ..
					"\\n��������" ..
					"\\n��������" ..
					"\\n��ǿ�ȡ�" ..
					"\\n���ٶȡ�"..
					"\\n��ħ����" 
			NLG.ShowWindowTalked(_PlayerIndex, _MeIndex, 2, 2, 10, TalkBuf);
			return;
		end
		if PlayerSelect==2 then
			local TalkBuf =	"4\\n������Ŀ��"..tMax_CI.."�㣺" ..
					"\\n�������0�㣬���30��" ..
					"\\n��������б༭" ..
					"\\n " ..
					"\\n����ɱ��" ..
					"\\n��������" ..
					"\\n�����С�" ..
					"\\n�����㡻" 
			NLG.ShowWindowTalked(_PlayerIndex, _MeIndex, 2, 2, 11, TalkBuf);
			return;
		end
		if PlayerSelect==3 then
			local TalkBuf =	"4\\n������Ŀ��"..tMax_AB.."�㣺" ..
					"\\n�������0�㣬���10��" ..
					"\\n��������б༭" ..
					"\\n " ..
					"\\n�������ԡ�" ..
					"\\n��ˮ���ԡ�" ..
					"\\n�������ԡ�" ..
					"\\n�������ԡ�" 
			NLG.ShowWindowTalked(_PlayerIndex, _MeIndex, 2, 2, 12, TalkBuf);
			return;
		end
		if PlayerSelect==4 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%��ť_ȷ��%,13,"\n�����Զ������\n\n����������\n\n���չٷ���������\n\n������������101824��",_MeIndex);
			return;
		end
		if PlayerSelect==5 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%��ť_ȷ��%,14,"\n���һ��������\n\n��Ϊ��ĳ���\n\nȡ�����֣�����̫����",_MeIndex);
			return;
		end
	end
	if _Seqno==10 then
		local PlayerSelect1 = tonumber(_Data)
		if PlayerSelect1==1 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%��ť_ȷ��%,15,"\n������Ŀ��"..tMax_BP.."�㣺\n\n�����������13�㣬�����������55��\n\n����������BP��",_MeIndex);
			return;
		end
		if PlayerSelect1==2 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%��ť_ȷ��%,16,"\n������Ŀʣ��"..Left_BP2.."�㣺\n\n�����������13�㣬�����������55��\n\n����������BP��",_MeIndex);
			return;
		end
		if PlayerSelect1==3 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%��ť_ȷ��%,17,"\n������Ŀʣ��"..Left_BP3.."�㣺\n\nǿ�ȵ������13�㣬ǿ�ȵ������55��\n\n������ǿ��BP��",_MeIndex);
			return;
		end
		if PlayerSelect1==4 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%��ť_ȷ��%,18,"\n������Ŀʣ��"..Left_BP4.."�㣺\n\n�ٶȵ������13�㣬�ٶȵ������55��\n\n�������ٶ�BP��",_MeIndex);
			return;
		end
		if PlayerSelect1==5 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%��ť_ȷ��%,19,"\n������Ŀʣ��"..Left_BP5.."�㣺\n\nħ���������13�㣬ħ���������55��\n\n������ħ��BP��",_MeIndex);
			return;
		end
	end
	if(tonumber(_Seqno)==15 and tonumber(_Select)==%��ť_ȷ��% and _Data~="")then
		arr_rank11 = tonumber("".._Data.."")
		if arr_rank11 <= 12 or arr_rank11 >= 56 then
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]�������η�Χ����ǰ��ĿBP�������Ϊ13�㣬���Ϊ55�㡣")
			return;
		end
		if arr_rank11 <= 55 and arr_rank11 >= 13 then
			Left_BP2 = tMax_BP - arr_rank11;
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]���η���:����"..arr_rank11.."��")
		else
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]���ε������㣬�޷��ɹ����䡣")
		end
	end
	if(tonumber(_Seqno)==16 and tonumber(_Select)==%��ť_ȷ��% and _Data~="")then
		arr_rank21 = tonumber("".._Data.."")
		if arr_rank21 <= 12 or arr_rank21 >= 56 then
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]�������η�Χ����ǰ��ĿBP�������Ϊ13�㣬���Ϊ55�㡣")
			return;
		end
		if arr_rank21 <= 55 and arr_rank21 >= 13 then
			Left_BP3 = Left_BP2 - arr_rank21;
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]���η���:����"..arr_rank11..",����"..arr_rank21.."��")
		else
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]���ε������㣬�޷��ɹ����䡣")
		end
	end
	if(tonumber(_Seqno)==17 and tonumber(_Select)==%��ť_ȷ��% and _Data~="")then
		arr_rank31 = tonumber("".._Data.."")
		if arr_rank31 <= 12 or arr_rank31 >= 56 then
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]�������η�Χ����ǰ��ĿBP�������Ϊ13�㣬���Ϊ55�㡣")
			return;
		end
		if arr_rank31 <= 55 and arr_rank31 >= 13 then
			Left_BP4 = Left_BP3 - arr_rank31;
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]���η���:����"..arr_rank11..",����"..arr_rank21..",ǿ��"..arr_rank31.."��")
		else
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]���ε������㣬�޷��ɹ����䡣")
		end
	end
	if(tonumber(_Seqno)==18 and tonumber(_Select)==%��ť_ȷ��% and _Data~="")then
		arr_rank41 = tonumber("".._Data.."")
		if arr_rank41 <= 12 or arr_rank41 >= 56 then
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]�������η�Χ����ǰ��ĿBP�������Ϊ13�㣬���Ϊ55�㡣")
			return;
		end
		if arr_rank41 <= 55 and arr_rank41 >= 13 then
			Left_BP5 = Left_BP4 - arr_rank41;
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]���η���:����"..arr_rank11..",����"..arr_rank21..",ǿ��"..arr_rank31..",�ٶ�"..arr_rank41.."��")
		else
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]���ε������㣬�޷��ɹ����䡣")
		end
	end
	if(tonumber(_Seqno)==19 and tonumber(_Select)==%��ť_ȷ��% and _Data~="")then
		arr_rank51 = tonumber("".._Data.."")
		if arr_rank51 <= 12 or arr_rank51 >= 56 then
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]�������η�Χ����ǰ��ĿBP�������Ϊ13�㣬���Ϊ55�㡣")
			return;
		end
		if arr_rank51 <= 55 and arr_rank51 >= 13 then
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]���η���:����"..arr_rank11..",����"..arr_rank21..",ǿ��"..arr_rank31..",�ٶ�"..arr_rank41..",ħ��"..arr_rank51.."��")
		else
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]���ε������㣬�޷��ɹ����䡣")
		end
	end
	if _Seqno==11 then
		local PlayerSelect1 = tonumber(_Data)
		if PlayerSelect1==1 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%��ť_ȷ��%,20,"\n������Ŀ��"..tMax_CI.."�㣺\n\n��ɱ�������0�㣬��ɱ�������30��\n\n�������ɱ��",_MeIndex);
			return;
		end
		if PlayerSelect1==2 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%��ť_ȷ��%,21,"\n������Ŀʣ��"..Left_CI2.."�㣺\n\n�����������0�㣬�����������30��\n\n�����뷴����",_MeIndex);
			return;
		end
		if PlayerSelect1==3 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%��ť_ȷ��%,22,"\n������Ŀʣ��"..Left_CI3.."�㣺\n\n���е������0�㣬���е������30��\n\n���������У�",_MeIndex);
			return;
		end
		if PlayerSelect1==4 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%��ť_ȷ��%,23,"\n������Ŀʣ��"..Left_CI4.."�㣺\n\n���㵥�����0�㣬���㵥�����30��\n\n���������㣡",_MeIndex);
			return;
		end
	end
	if(tonumber(_Seqno)==20 and tonumber(_Select)==%��ť_ȷ��% and _Data~="")then
		critical = tonumber("".._Data.."")
		if critical < 0 or critical >= 31 then
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]����������Χ����ǰ��Ŀ�������Ϊ0�㣬���Ϊ30�㡣")
			return;
		end
		if critical <= 30 and critical >= 0 then
			Left_CI2 = tMax_CI - critical;
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]��������:��ɱ"..critical.."��")
		else
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]�����������㣬�޷��ɹ����䡣")
		end
	end
	if(tonumber(_Seqno)==21 and tonumber(_Select)==%��ť_ȷ��% and _Data~="")then
		counter = tonumber("".._Data.."")
		if counter < 0 or counter >= 31 then
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]����������Χ����ǰ��Ŀ�������Ϊ0�㣬���Ϊ30�㡣")
			return;
		end
		if counter <= 30 and counter >= 0 then
			Left_CI3 = Left_CI2 - counter;
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]��������:��ɱ"..critical..",����"..counter.."��")
		else
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]�����������㣬�޷��ɹ����䡣")
		end
	end
	if(tonumber(_Seqno)==22 and tonumber(_Select)==%��ť_ȷ��% and _Data~="")then
		hitrate = tonumber("".._Data.."")
		if hitrate < 0 or hitrate >= 31 then
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]����������Χ����ǰ��Ŀ�������Ϊ0�㣬���Ϊ30�㡣")
			return;
		end
		if hitrate <= 30 and hitrate >= 0 then
			Left_CI4 = Left_CI3 - hitrate;
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]��������:��ɱ"..critical..",����"..counter..",����"..hitrate.."��")
		else
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]�����������㣬�޷��ɹ����䡣")
		end
	end
	if(tonumber(_Seqno)==23 and tonumber(_Select)==%��ť_ȷ��% and _Data~="")then
		avoid = tonumber("".._Data.."")
		if avoid < 0 or avoid >= 31 then
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]����������Χ����ǰ��Ŀ�������Ϊ0�㣬���Ϊ30�㡣")
			return;
		end
		CI = critical + counter + hitrate + avoid;
		if CI < tMax_CI or CI > tMax_CI then
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]�����������㣬�޷��ɹ����䡣")
			return;
		end
		if (avoid <= 30 and avoid >= 0 ) then
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]��������:��ɱ"..critical..",����"..counter..",����"..hitrate..",����"..avoid.."��")
		else
			--NLG.SystemMessage(_PlayerIndex, "[ϵͳ]�޷��Զ���ĳ��")
		end
	end
	if _Seqno==12 then
		local PlayerSelect1 = tonumber(_Data)
		if PlayerSelect1==1 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%��ť_ȷ��%,24,"\n������Ŀ��"..tMax_AB.."�㣺\n\n�����Ե������0�㣬�����Ե������10��\n\n����������ԣ�",_MeIndex);
			return;
		end
		if PlayerSelect1==2 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%��ť_ȷ��%,25,"\n������Ŀʣ��"..Left_AB2.."�㣺\n\nˮ���Ե������0�㣬ˮ���Ե������10��\n\n������ˮ���ԣ�",_MeIndex);
			return;
		end
		if PlayerSelect1==3 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%��ť_ȷ��%,26,"\n������Ŀʣ��"..Left_AB3.."�㣺\n\n�����Ե������0�㣬�����Ե������10��\n\n����������ԣ�",_MeIndex);
			return;
		end
		if PlayerSelect1==4 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%��ť_ȷ��%,27,"\n������Ŀʣ��"..Left_AB4.."�㣺\n\n�����Ե������0�㣬�����Ե������10��\n\n����������ԣ�",_MeIndex);
			return;
		end
	end
	if(tonumber(_Seqno)==24 and tonumber(_Select)==%��ť_ȷ��% and _Data~="")then
		ground = tonumber("".._Data.."")
		if ground < 0 or ground >= 11 then
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]�������Է�Χ����ǰ��Ŀ�������Ϊ0�㣬���Ϊ10�㡣")
			return;
		end
		if ground <= 10 and ground >= 0 then
			Left_AB2 = tMax_AB - ground;
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]���Է���:������"..ground.."��")
		else
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]���Ե������㣬�޷��ɹ����䡣")
		end
	end
	if(tonumber(_Seqno)==25 and tonumber(_Select)==%��ť_ȷ��% and _Data~="")then
		water = tonumber("".._Data.."")
		if water < 0 or water >= 11 then
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]�������Է�Χ����ǰ��Ŀ�������Ϊ0�㣬���Ϊ10�㡣")
			return;
		end
		if water <= 10 and water >= 0 then
			Left_AB3 = Left_AB2 - water;
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]���Է���:������"..ground..",ˮ����"..water.."��")
		else
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]���Ե������㣬�޷��ɹ����䡣")
		end
	end
	if(tonumber(_Seqno)==26 and tonumber(_Select)==%��ť_ȷ��% and _Data~="")then
		fire = tonumber("".._Data.."")
		if fire < 0 or fire >= 11 then
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]�������Է�Χ����ǰ��Ŀ�������Ϊ0�㣬���Ϊ10�㡣")
			return;
		end
		if fire <= 10 and fire >= 0 then
			Left_AB4 = Left_AB3 - fire;
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]���Է���:������"..ground..",ˮ����"..water..",������"..fire.."��")
		else
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]���Ե������㣬�޷��ɹ����䡣")
		end
	end
	if(tonumber(_Seqno)==27 and tonumber(_Select)==%��ť_ȷ��% and _Data~="")then
		wind = tonumber("".._Data.."")
		if wind < 0 or wind >= 11 then
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]�������Է�Χ����ǰ��Ŀ�������Ϊ0�㣬���Ϊ10�㡣")
			return;
		end
		AB = ground + water + fire + wind;
		if AB < tMax_AB or AB > tMax_AB then
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]���Ե������㣬�޷��ɹ����䡣")
			return;
		end
		if (wind <= 10 and wind >= 0) then
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]���Է���:������"..ground..",ˮ����"..water..",������"..fire..",������"..wind.."��")
		else
			--NLG.SystemMessage(_PlayerIndex, "[ϵͳ]�޷��Զ���ĳ��")
		end
	end
	if(tonumber(_Seqno)==13 and tonumber(_Select)==%��ť_ȷ��% and _Data~="")then
		PetTD1 = tonumber("".._Data.."")
		if PET_CheckInTable(tPetID,PetTD1)==true then
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]���������ŵ�¼���:"..PetTD1.."��")
		else
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]���������ţ�����չٷ��������ᡣ")
			return;
		end
	end
	if(tonumber(_Seqno)==14 and tonumber(_Select)==%��ť_ȷ��% and _Data~="") then
		local name = _Data;
		BP = arr_rank11 + arr_rank21 + arr_rank31 + arr_rank41 + arr_rank51;
		if BP < tMax_BP or BP > tMax_BP then
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]��ȷ�ϵ��ε���������ȷ��")
			return;
		end
		if (BP == tMax_BP and CI == tMax_CI and AB == tMax_AB) then
			Char.AddPet(_PlayerIndex,tEnemyID);
		else
			NLG.SystemMessage(_PlayerIndex, "[ϵͳ]��ȷ��ǰ�������������ȷ��")
		end
		for Slot=0,4 do
			local _PetIndex = Char.GetPet(_PlayerIndex,Slot);
			local image = Char.GetData(_PetIndex,%����_����%);
			if (BP == tMax_BP and CI == tMax_CI and AB == tMax_AB and image == 100902) then
				Pet.SetArtRank(_PetIndex,%�赵_���%,arr_rank11 - math.random(0,0));  --�Զ���ֲ���������n0~4
				Pet.SetArtRank(_PetIndex,%�赵_����%,arr_rank21 - math.random(0,0));
				Pet.SetArtRank(_PetIndex,%�赵_ǿ��%,arr_rank31 - math.random(0,0));
				Pet.SetArtRank(_PetIndex,%�赵_����%,arr_rank41 - math.random(0,0));
				Pet.SetArtRank(_PetIndex,%�赵_ħ��%,arr_rank51 - math.random(0,0));
				Pet.ReBirth(_PlayerIndex, _PetIndex);
				Char.SetData(_PetIndex,%����_��ɱ%,critical);
				Char.SetData(_PetIndex,%����_����%,counter);
				Char.SetData(_PetIndex,%����_����%,hitrate);
				Char.SetData(_PetIndex,%����_����%,avoid);
				Char.SetData(_PetIndex,%����_������%,ground*10);
				Char.SetData(_PetIndex,%����_ˮ����%,water*10);
				Char.SetData(_PetIndex,%����_������%,fire*10);
				Char.SetData(_PetIndex,%����_������%,wind*10);
				Char.SetData(_PetIndex,%����_����%,PetTD1);
				Char.SetData(_PetIndex,%����_ԭ��%,PetTD1);
				Char.SetData(_PetIndex,%����_����%,name);
				Char.SetData(_PetIndex,%����_��ɫ%,6);  --�Զ������Ϊ��ɫ����
				Pet.UpPet(_PlayerIndex,_PetIndex);
				Char.DelItem(_PlayerIndex,bItemID,1);
				NLG.SystemMessage(_PlayerIndex, "[ϵͳ]�Զ������������������")
			end
		end
	end
end