------------------------------------------------------------------------------
------------------------------------------------------------------------------
--                 ����������ǿ�����á�����
------------------------------------------------------------------------------
local StrStrengEnable = {}
local StrStrengMaxLv = {}
local StrBaseRate = {}
local StrResistRate = {}
local StrFixRate = {}
local StrSuccRate = {}
local StrBreakRate = {}
local StrRequireItemID = {}
local StrRequireItemNum = {}
local StrRequireGold = {}
local StrBinding = 0								--ǿ����װ���Ƿ񲻿ɽ��ף�ѡ�0-���󶨣�1-�󶨣�
--��Ĭ�����á�
--  ����������װ������ǿ��
StrStrengEnable[-1] = 1	--�Ƿ���Ĭ������
StrStrengMaxLv[-1] = 9									--����ǿ���ȼ���������
StrBaseRate[-1] = 	{4, 4, 3, 3, 3, 2, 2, 2, 2}			--��ͨ���԰ٷֱ�
StrResistRate[-1] = 	{1, 1, 1, 1, 1, 1, 1, 1, 1}			--6���԰ٷֱ�
StrFixRate[-1] = 		{1, 1, 1, 1, 1, 1, 1, 1, 1}			--4�����ٷֱ�
StrSuccRate[-1] = 	{50, 45, 40, 35, 25, 20, 20, 20, 15}	--ǿ���ɹ���
StrBreakRate[-1] = 	{10, 10, 10, 10, 10, 10, 10, 10, 10}		--ǿ���ƻ���
StrRequireItemID[-1] = {69126, 69126, 69126, 69126, 69126, 69126, 69126, 69126, 69126}		--ǿ��������ƷID��ǿ��ʯID��
StrRequireItemNum[-1] = {1, 1, 2, 2, 2, 4, 4, 5, 5, 5}			--ǿ��������Ʒ������ǿ��ʯ������
StrRequireGold[-1] = {1000, 1000, 2000, 2000, 2000, 4000, 4000, 5000, 5000, 5000}	--ǿ��������
--������ǿ����
--  һ��װ��һ�Σ������θ��ƺ����޸�
local ItemID = 69109	--�������õ���ƷID
StrStrengEnable[ItemID] = 1
StrStrengMaxLv[ItemID] = 9									--����ǿ���ȼ���������
StrBaseRate[ItemID] = 	{1, 1, 1, 1, 1, 1, 1, 1, 1}			--��ͨ���԰ٷֱ�
StrResistRate[ItemID] = 	{10, 10, 5, 4, 3, 2, 1, 1, 1}			--6���԰ٷֱ�
StrFixRate[ItemID] = 		{4, 4, 4, 5, 5, 5, 5, 5, 5}			--4�����ٷֱ�
StrSuccRate[ItemID] =	{100, 100, 80, 80, 50, 40, 30, 20, 10}	--ǿ���ɹ���
StrBreakRate[ItemID] = 	{5, 5, 5, 5, 5, 5, 5, 10, 15}		--ǿ���ƻ���
StrRequireItemID[ItemID] = {69127, 69127, 69127, 69127, 69127, 69127, 69127, 69127, 69127}		--ǿ��������ƷID��ǿ��ʯID��
StrRequireItemNum[ItemID] = {1, 1, 2, 2, 2, 4, 4, 5, 5, 5}			--ǿ��������Ʒ������ǿ��ʯ������
StrRequireGold[ItemID] = {1000, 1000, 2000, 2000, 2000, 4000, 4000, 5000, 5000, 5000}	--ǿ��������
--  һ��װ��һ�Σ������θ��ƺ����޸�
local ItemID = 16424	--�������õ���ƷID
StrStrengEnable[ItemID] = 1
StrStrengMaxLv[ItemID] = 9									--����ǿ���ȼ���������
StrBaseRate[ItemID] = 	{1, 1, 1, 1, 1, 1, 1, 1, 1}			--��ͨ���԰ٷֱ�
StrResistRate[ItemID] = 	{4, 4, 4, 5, 5, 6, 7, 8, 9}			--6���԰ٷֱ�
StrFixRate[ItemID] = 		{4, 4, 4, 5, 5, 6, 7, 8, 9}			--4�����ٷֱ�
StrSuccRate[ItemID] =	{100, 100, 80, 80, 50, 40, 30, 20, 10}	--ǿ���ɹ���
StrBreakRate[ItemID] = 	{5, 5, 5, 5, 5, 5, 5, 10, 15}		--ǿ���ƻ���
StrRequireItemID[ItemID] = {69127, 69127, 69127, 69127, 69127, 69127, 69127, 69127, 69127}		--ǿ��������ƷID��ǿ��ʯID��
StrRequireItemNum[ItemID] = {1, 1, 2, 2, 2, 4, 4, 5, 5, 5}			--ǿ��������Ʒ������ǿ��ʯ������
StrRequireGold[ItemID] = {1000, 1000, 2000, 2000, 2000, 4000, 4000, 5000, 5000, 5000}--ǿ��������
--  һ��װ��һ�Σ������θ��ƺ����޸�
local ItemID = 69129	--�������õ���ƷID
StrStrengEnable[ItemID] = 1
StrStrengMaxLv[ItemID] = 9									--����ǿ���ȼ���������
StrBaseRate[ItemID] = 	{10, 5, 5, 4, 4, 3, 3, 2, 2}			--��ͨ���԰ٷֱ�
StrResistRate[ItemID] = 	{1, 1, 1, 1, 1, 1, 1, 1, 1}			--6���԰ٷֱ�
StrFixRate[ItemID] = 		{1, 1, 1, 1, 1, 1, 1, 1, 1}			--4�����ٷֱ�
StrSuccRate[ItemID] =	{100, 80, 80, 70, 60, 50, 40, 30, 20}	--ǿ���ɹ���
StrBreakRate[ItemID] = 	{10, 10, 10, 10, 10, 10, 10, 10, 10}		--ǿ���ƻ���
StrRequireItemID[ItemID] = {69128, 69128, 69128, 69128, 69128, 69128, 69128, 69128, 69128}		--ǿ��������ƷID��ǿ��ʯID��
StrRequireItemNum[ItemID] = {1, 1, 2, 2, 2, 4, 4, 5, 5, 5}			--ǿ��������Ʒ������ǿ��ʯ������
StrRequireGold[ItemID] = {1000, 1000, 2000, 2000, 2000, 4000, 4000, 5000, 5000, 5000}	--ǿ��������
--  һ��װ��һ�Σ������θ��ƺ����޸�
local ItemID = 69130	--�������õ���ƷID
StrStrengEnable[ItemID] = 1
StrStrengMaxLv[ItemID] = 9									--����ǿ���ȼ���������
StrBaseRate[ItemID] = 	{10, 5, 5, 4, 4, 3, 3, 2, 2}			--��ͨ���԰ٷֱ�
StrResistRate[ItemID] = 	{1, 1, 1, 1, 1, 1, 1, 1, 1}			--6���԰ٷֱ�
StrFixRate[ItemID] = 		{1, 1, 1, 1, 1, 1, 1, 1, 1}			--4�����ٷֱ�
StrSuccRate[ItemID] =	{100, 80, 80, 70, 60, 50, 40, 30, 20}	--ǿ���ɹ���
StrBreakRate[ItemID] = 	{10, 10, 10, 10, 10, 10, 10, 10, 10}		--ǿ���ƻ���
StrRequireItemID[ItemID] = {69128, 69128, 69128, 69128, 69128, 69128, 69128, 69128, 69128}		--ǿ��������ƷID��ǿ��ʯID��
StrRequireItemNum[ItemID] = {1, 1, 2, 2, 2, 4, 4, 5, 5, 5}			--ǿ��������Ʒ������ǿ��ʯ������
StrRequireGold[ItemID] = {1000, 1000, 2000, 2000, 2000, 4000, 4000, 5000, 5000, 5000}--ǿ��������
--  һ��װ��һ�Σ������θ��ƺ����޸�
local ItemID = 69131	--�������õ���ƷID
StrStrengEnable[ItemID] = 1
StrStrengMaxLv[ItemID] = 9									--����ǿ���ȼ���������
StrBaseRate[ItemID] = 	{10, 5, 5, 4, 4, 3, 3, 2, 2}			--��ͨ���԰ٷֱ�
StrResistRate[ItemID] = 	{1, 1, 1, 1, 1, 1, 1, 1, 1}			--6���԰ٷֱ�
StrFixRate[ItemID] = 		{1, 1, 1, 1, 1, 1, 1, 1, 1}			--4�����ٷֱ�
StrSuccRate[ItemID] =	{100, 80, 80, 70, 60, 50, 40, 30, 20}	--ǿ���ɹ���
StrBreakRate[ItemID] = 	{10, 10, 10, 10, 10, 10, 10, 10, 10}		--ǿ���ƻ���
StrRequireItemID[ItemID] = {69128, 69128, 69128, 69128, 69128, 69128, 69128, 69128, 69128}		--ǿ��������ƷID��ǿ��ʯID��
StrRequireItemNum[ItemID] = {1, 1, 2, 2, 2, 4, 4, 5, 5, 5}			--ǿ��������Ʒ������ǿ��ʯ������
StrRequireGold[ItemID] = {1000, 1000, 2000, 2000, 2000, 4000, 4000, 5000, 5000, 5000}	--ǿ��������
--  һ��װ��һ�Σ������θ��ƺ����޸�
local ItemID = 69132	--�������õ���ƷID
StrStrengEnable[ItemID] = 1
StrStrengMaxLv[ItemID] = 9									--����ǿ���ȼ���������
StrBaseRate[ItemID] = 	{10, 5, 5, 4, 4, 3, 3, 2, 2}			--��ͨ���԰ٷֱ�
StrResistRate[ItemID] = 	{1, 1, 1, 1, 1, 1, 1, 1, 1}			--6���԰ٷֱ�
StrFixRate[ItemID] = 		{1, 1, 1, 1, 1, 1, 1, 1, 1}			--4�����ٷֱ�
StrSuccRate[ItemID] =	{100, 80, 80, 70, 60, 50, 40, 30, 20}	--ǿ���ɹ���
StrBreakRate[ItemID] = 	{10, 10, 10, 10, 10, 10, 10, 10, 10}		--ǿ���ƻ���
StrRequireItemID[ItemID] = {69128, 69128, 69128, 69128, 69128, 69128, 69128, 69128, 69128}		--ǿ��������ƷID��ǿ��ʯID��
StrRequireItemNum[ItemID] = {1, 1, 2, 2, 2, 4, 4, 5, 5, 5}			--ǿ��������Ʒ������ǿ��ʯ������
StrRequireGold[ItemID] = {1000, 1000, 2000, 2000, 2000, 4000, 4000, 5000, 5000, 5000}	--ǿ��������
--  һ��װ��һ�Σ������θ��ƺ����޸�
local ItemID = 70034	--�������õ���ƷID
StrStrengEnable[ItemID] = 1
StrStrengMaxLv[ItemID] = 9									--����ǿ���ȼ���������
StrBaseRate[ItemID] = 	{2, 2, 2, 2, 3, 3, 3, 4, 4}			--��ͨ���԰ٷֱ�
StrResistRate[ItemID] = 	{4, 4, 4, 5, 5, 6, 7, 8, 9}			--6���԰ٷֱ�
StrFixRate[ItemID] = 		{4, 4, 4, 5, 5, 6, 7, 8, 9}			--4�����ٷֱ�
StrSuccRate[ItemID] =	{100, 100, 80, 80, 50, 40, 30, 20, 10}	--ǿ���ɹ���
StrBreakRate[ItemID] = 	{10, 10, 10, 10, 10, 10, 10, 10, 10}		--ǿ���ƻ���
StrRequireItemID[ItemID] = {69127, 69127, 69127, 69127, 69127, 69127, 69127, 69127, 69127}		--ǿ��������ƷID��ǿ��ʯID��
StrRequireItemNum[ItemID] = {1, 1, 2, 2, 2, 4, 4, 5, 5, 5}			--ǿ��������Ʒ������ǿ��ʯ������
StrRequireGold[ItemID] = {1000, 1000, 2000, 2000, 2000, 4000, 4000, 5000, 5000, 5000}	--ǿ��������
--  һ��װ��һ�Σ������θ��ƺ����޸�
local ItemID = 70036	--�������õ���ƷID
StrStrengEnable[ItemID] = 1
StrStrengMaxLv[ItemID] = 9									--����ǿ���ȼ���������
StrBaseRate[ItemID] = 	{2, 2, 2, 2, 3, 3, 3, 4, 4}			--��ͨ���԰ٷֱ�
StrResistRate[ItemID] = 	{4, 4, 4, 5, 5, 6, 7, 8, 9}			--6���԰ٷֱ�
StrFixRate[ItemID] = 		{4, 4, 4, 5, 5, 6, 7, 8, 9}			--4�����ٷֱ�
StrSuccRate[ItemID] =	{100, 100, 80, 80, 50, 40, 30, 20, 10}	--ǿ���ɹ���
StrBreakRate[ItemID] = 	{10, 10, 10, 10, 10, 10, 10, 10, 10}		--ǿ���ƻ���
StrRequireItemID[ItemID] = {69127, 69127, 69127, 69127, 69127, 69127, 69127, 69127, 69127}		--ǿ��������ƷID��ǿ��ʯID��
StrRequireItemNum[ItemID] = {1, 1, 2, 2, 2, 4, 4, 5, 5, 5}			--ǿ��������Ʒ������ǿ��ʯ������
StrRequireGold[ItemID] = {1000, 1000, 2000, 2000, 2000, 4000, 4000, 5000, 5000, 5000}	--ǿ��������
--  һ��װ��һ�Σ������θ��ƺ����޸�
local ItemID = 70037	--�������õ���ƷID
StrStrengEnable[ItemID] = 1
StrStrengMaxLv[ItemID] = 9									--����ǿ���ȼ���������
StrBaseRate[ItemID] = 	{2, 2, 2, 2, 3, 3, 3, 4, 4}			--��ͨ���԰ٷֱ�
StrResistRate[ItemID] = 	{4, 4, 4, 5, 5, 6, 7, 8, 9}			--6���԰ٷֱ�
StrFixRate[ItemID] = 		{4, 4, 4, 5, 5, 6, 7, 8, 9}			--4�����ٷֱ�
StrSuccRate[ItemID] =	{100, 100, 80, 80, 50, 40, 30, 20, 10}	--ǿ���ɹ���
StrBreakRate[ItemID] = 	{10, 10, 10, 10, 10, 10, 10, 10, 10}		--ǿ���ƻ���
StrRequireItemID[ItemID] = {69127, 69127, 69127, 69127, 69127, 69127, 69127, 69127, 69127}		--ǿ��������ƷID��ǿ��ʯID��
StrRequireItemNum[ItemID] = {1, 1, 2, 2, 2, 4, 4, 5, 5, 5}			--ǿ��������Ʒ������ǿ��ʯ������
StrRequireGold[ItemID] = {1000, 1000, 2000, 2000, 2000, 4000, 4000, 5000, 5000, 5000}	--ǿ��������
--  һ��װ��һ�Σ������θ��ƺ����޸�
local ItemID = 70038	--�������õ���ƷID
StrStrengEnable[ItemID] = 1
StrStrengMaxLv[ItemID] = 9									--����ǿ���ȼ���������
StrBaseRate[ItemID] = 	{2, 2, 2, 2, 3, 3, 3, 4, 4}			--��ͨ���԰ٷֱ�
StrResistRate[ItemID] = 	{4, 4, 4, 5, 5, 6, 7, 8, 9}			--6���԰ٷֱ�
StrFixRate[ItemID] = 		{4, 4, 4, 5, 5, 6, 7, 8, 9}			--4�����ٷֱ�
StrSuccRate[ItemID] =	{100, 100, 80, 80, 50, 40, 30, 20, 10}	--ǿ���ɹ���
StrBreakRate[ItemID] = 	{10, 10, 10, 10, 10, 10, 10, 10, 10}		--ǿ���ƻ���
StrRequireItemID[ItemID] = {69127, 69127, 69127, 69127, 69127, 69127, 69127, 69127, 69127}		--ǿ��������ƷID��ǿ��ʯID��
StrRequireItemNum[ItemID] = {1, 1, 2, 2, 2, 4, 4, 5, 5, 5}			--ǿ��������Ʒ������ǿ��ʯ������
StrRequireGold[ItemID] = {1000, 1000, 2000, 2000, 2000, 4000, 4000, 5000, 5000, 5000}	--ǿ��������
--����ֹǿ����
--  һ��װ��һ�У���ֵ��д0����
StrStrengEnable[980491] = 0
StrStrengEnable[250] = 0    --ˮ��֮��
StrStrengEnable[69105] = 0    --Ԫ������������
StrStrengEnable[69106] = 0
StrStrengEnable[69107] = 0
StrStrengEnable[69108] = 0
StrStrengEnable[70053] = 0    --����ȫ֧���g��
StrStrengEnable[70054] = 0
StrStrengEnable[70055] = 0
StrStrengEnable[70056] = 0
StrStrengEnable[70057] = 0
StrStrengEnable[70058] = 0
StrStrengEnable[70059] = 0
StrStrengEnable[70060] = 0
StrStrengEnable[79060] = 0    --������
StrStrengEnable[79061] = 0
StrStrengEnable[79062] = 0
StrStrengEnable[79063] = 0
StrStrengEnable[79064] = 0
StrStrengEnable[79065] = 0
StrStrengEnable[69226] = 0    --���Ͼ���
StrStrengEnable[69227] = 0
StrStrengEnable[69228] = 0
StrStrengEnable[69229] = 0
StrStrengEnable[79215] = 0    --�����^��̖
StrStrengEnable[79216] = 0
StrStrengEnable[79217] = 0
StrStrengEnable[79218] = 0
StrStrengEnable[79219] = 0
StrStrengEnable[79220] = 0
StrStrengEnable[79221] = 0
StrStrengEnable[79222] = 0
StrStrengEnable[79223] = 0
StrStrengEnable[79224] = 0
StrStrengEnable[79225] = 0
StrStrengEnable[79226] = 0
StrStrengEnable[79227] = 0
StrStrengEnable[79228] = 0
StrStrengEnable[79229] = 0
StrStrengEnable[79230] = 0
StrStrengEnable[79231] = 0
StrStrengEnable[79232] = 0
StrStrengEnable[79233] = 0
StrStrengEnable[79234] = 0
StrStrengEnable[79235] = 0
StrStrengEnable[79236] = 0
StrStrengEnable[79237] = 0
StrStrengEnable[79238] = 0
StrStrengEnable[79239] = 0
StrStrengEnable[79240] = 0
StrStrengEnable[79241] = 0
StrStrengEnable[79242] = 0
StrStrengEnable[79243] = 0
StrStrengEnable[79244] = 0
StrStrengEnable[79245] = 0
StrStrengEnable[79246] = 0
StrStrengEnable[79247] = 0
StrStrengEnable[79248] = 0
StrStrengEnable[79249] = 0


------------------------------------------------------------------------------
------------------------------------------------------------------------------
--                 �������ű�ϵͳ���á���������רҵ���������޸ģ�
------------------------------------------------------------------------------
local ItemPosName = {"�^ ��", "�� ��", "�� ��", "�� ��", "�� ��", "�Ʒ1", "�Ʒ2", "ˮ ��"}
------------------------------------------------------------------------------

function BlacksmithNpc_Func(index)
	print("Blacksmith.Index=" .. index);
	return 1;
end

Delegate.RegInit("BlacksmithNpc_Init");
function BlacksmithNpc_Init()
	local BlacksmithNpc = NL.CreateNpc("lua/Module/Blacksmiths.lua", "BlacksmithNpc_Func");
	Char.SetData( BlacksmithNpc, %����_����%,105527);
	Char.SetData( BlacksmithNpc, %����_ԭ��%,105527);
	Char.SetData( BlacksmithNpc, %����_��ͼ%,25000);
	Char.SetData( BlacksmithNpc, %����_X%,29);
	Char.SetData( BlacksmithNpc, %����_Y%,7);
	Char.SetData( BlacksmithNpc, %����_����%,4);
	Char.SetData( BlacksmithNpc, %����_����%,"�b�侫���F��");
	NLG.UpChar( BlacksmithNpc)

	tbl_LuaNpcIndex = {}
	tbl_LuaNpcIndex["BlacksmithNpc"] = BlacksmithNpc

	if (Char.SetTalkedEvent(nil, "BlacksmithNpc_Talked", BlacksmithNpc) < 0) then
		print("BlacksmithNpc_Talked ע���¼�ʧ�ܡ�");
		return false;
	end

	if (Char.SetWindowTalkedEvent(nil, "BlacksmithNpc_WindowTalked", BlacksmithNpc) < 0) then
		print("BlacksmithNpc_WindowTalked ע���¼�ʧ�ܡ�");
		return false;
	end

	return true;
end

function BlacksmithNpc_Talked( _MeIndex, _PlayerIndex, _Mode)

	if(NLG.CheckInFront(_PlayerIndex, _MeIndex, 1)==false and _Mode~=1) then
		return ;
	end 

	NLG.ShowWindowTalked(_PlayerIndex, _MeIndex, 2, 2, 1,
			"8\n����������������" .. "�b�侫���F��" .. "��" ..
			"\n����һλ�����Р��������������F������������" ..
			"\n������������֪�������������Ĺ��l�������h��ħ" ..
			"\n���r�ڵ��`�������u���������f�κ��b�佛�^����" ..
			"\n����֮��������������׃�ø��ӈ��g��" ..
			"\n�����@λ�����y��������F�����������У����˵�" ..
			"\n����֮�F�m��̖�������uˇ���˂������b�䡣" .. 
			"\n" ..
			"\n������������������������������"
			);

	return ;
end

function BlacksmithNpc_WindowTalked( _MeIndex, _PlayerIndex, _Seqno, _Select, _Data)

	--print("\n_MeIndex=" .. _MeIndex .. ", _PlayerIndex=" .. _PlayerIndex .. ", _Seqno=" .. _Seqno .. ", _Data=" .. _Data)
	
	--ȡ����ť
	if _Select==2 then
		return
	end

	if _Seqno==1 then
		local PlayerSelect = tonumber(_Data)
		if PlayerSelect==1 then
			--����ǿ��
			local TalkBuf = "1|\nՈ�x����Ҫ�����������b�䣺\n"
			for i = 0,7 do
				local tItemIndex = Char.GetItemIndex(_PlayerIndex, i);
				if tItemIndex>=0 then
					local tItemID = Item.GetData(tItemIndex, %����_ID%)
					--print("tItemID=" .. tItemID)
					local tItemName = Item.GetData(tItemIndex, %����_����%)
					local tStrLv = EquipPlusStat(tItemIndex, "S") or 0
					local tMaxLv = StrStrengMaxLv[tItemID] or StrStrengMaxLv[-1]
					local tNeedItemNumTab = StrRequireItemNum[tItemID] or StrRequireItemNum[-1]
					local tNeedItemNum = tNeedItemNumTab[tStrLv+1]
					local tNeedGoldTab = StrRequireGold[tItemID] or StrRequireGold[-1]
					local tNeedGold = tNeedGoldTab[tStrLv+1]
					local tItemCan = "[ǿ����]  " .. tNeedItemNum .. "��|"  .. string.format("%.2f", tNeedGold/10000) .. "W"
					if StrStrengEnable[tItemID]~=1 and StrStrengEnable[-1]~=1 then tItemCan="[ǿ����]" end
					if tStrLv>=tMaxLv then tItemCan="[ǿ��Max]" end
					if StrStrengEnable[tItemID]==0 then tItemCan="[ǿ��X]" end
					if EquipPlusStat(tItemIndex, "D")~=nil then tItemCan="[ǿ����]" end
					if EquipPlusStat(tItemIndex, "E")~=nil then tItemCan="[ǿ����]" end
					if EquipPlusStat(tItemIndex, "R")~=nil then tItemCan="[ǿ����]" end
					local Buf = tItemName .. " " .. tItemCan
					TalkBuf = TalkBuf .. ItemPosName[i+1] .. "��" .. Buf .. "\n"
				else
					TalkBuf = TalkBuf .. ItemPosName[i+1] .. "��" .. "\n"
				end
			end
			NLG.ShowWindowTalked(_PlayerIndex, _MeIndex, 2, 2, 10, TalkBuf)
			return
		end
	end

	--����ǿ��
	if _Seqno==10 then
		local PlayerSelect = tonumber(_Data)
		local tPlayerGold = Char.GetData(_PlayerIndex, %����_���%)
		local tItemPos = PlayerSelect - 1
		local tItemIndex = Char.GetItemIndex(_PlayerIndex, tItemPos);
		if tItemIndex>=0 then
			local tItemID = Item.GetData(tItemIndex, %����_ID%)
			local tItemName = Item.GetData(tItemIndex, %����_����%)
			--CheckEnable
			local tStrLv = EquipPlusStat(tItemIndex, "S") or 0
			local tMaxLv = StrStrengMaxLv[tItemID] or StrStrengMaxLv[-1]
			if StrStrengEnable[tItemID]~=1 and StrStrengEnable[-1]~=1 then
				NLG.SystemMessage(_PlayerIndex, "[" .. "�����F��" .. "] ���x����b��[" .. tItemName .. "]��[���ɏ���]��")
				return
			end
			if tStrLv>=tMaxLv then
				NLG.SystemMessage(_PlayerIndex, "[" .. "�����F��" .. "] ���x����b��[" .. tItemName .. "]���_��[����Max]��")
				return
			end
			if StrStrengEnable[tItemID]==0 then
				NLG.SystemMessage(_PlayerIndex, "[" .. "�����F��" .. "] ���x����b��[" .. tItemName .. "]��[���ɏ���]��")
				return
			end
			if EquipPlusStat(tItemIndex, "D")~=nil then
				NLG.SystemMessage(_PlayerIndex, "[" .. "�����F��" .. "] ���x����b��[" .. tItemName .. "]��[ħ���b��]�����_���O�ޣ�")
				return
			end
			if EquipPlusStat(tItemIndex, "E")~=nil then
				NLG.SystemMessage(_PlayerIndex, "[" .. "�����F��" .. "] ���x����b��[" .. tItemName .. "]��Ѫ����ħ���o���^�m������")
				return
			end
			if EquipPlusStat(tItemIndex, "R")~=nil then
				NLG.SystemMessage(_PlayerIndex, "[" .. "�����F��" .. "] ���x����b��[" .. tItemName .. "]���Ƕ���ģ��o���^�m������")
				return
			end
			--CheckGold
			local tNeedGoldTab = StrRequireGold[tItemID] or StrRequireGold[-1]
			local tNeedGold = tonumber(tNeedGoldTab[tStrLv+1]) or 0
			if tPlayerGold<tNeedGold then
				NLG.SystemMessage(_PlayerIndex, "[" .. "�����F��" .. "] ������Ҫ" .. tNeedGold .. "G��������Ų��㣡")
				return
			end
			--CheckRequireItem
			local RequireItemIDTab = StrRequireItemID[tItemID] or StrRequireItemID[-1]
			local RequireItemID = RequireItemIDTab[tStrLv+1]
			local RequireItemNumTab = StrRequireItemNum[tItemID] or StrRequireItemNum[-1]
			local RequireItemNum = RequireItemNumTab[tStrLv+1]
			if type(RequireItemID)=="number" and RequireItemID>0 and type(RequireItemNum)=="number" and RequireItemNum>0 then
				if Char.ItemNum(_PlayerIndex, RequireItemID)<RequireItemNum then
					NLG.SystemMessage(_PlayerIndex, "[" .. "�����F��" .. "] ����������߲��㣡")
					return
				end
			end
			--DelGold
			Char.SetData(_PlayerIndex, %����_���%, tPlayerGold-tNeedGold)
			--DelItem
			Char.DelItem(_PlayerIndex, RequireItemID, RequireItemNum)
			--CheckBreak
			local BreakRateTab = StrBreakRate[tItemID] or StrBreakRate[-1]
			local BreakRate = BreakRateTab[tStrLv+1]
			if type(BreakRate)=="number" and BreakRate>0 then
				local tMin = 50 - math.floor(BreakRate/2) + 1
				local tMax = 50 + math.floor(BreakRate/2) + math.fmod(BreakRate,2)
				local tLuck = math.random(1, 100)
				if tLuck>=tMin and tLuck<=tMax then
					--Item.SetData(tItemIndex, %����_ID%, 10203947)
					--Char.DelItem(_PlayerIndex, 10203947)
					--Char.DelItemByPos(_PlayerIndex, tItemPos)
					Item.Kill(_PlayerIndex, tItemIndex, tItemPos)
					NLG.SystemMessage(_PlayerIndex, "[" .. "�����F��" .. "] �@�^���ǂ����y����춻����]���ƺã�����b��صך����ˡ���")
					--BlacksmithNpc_WindowTalked( _MeIndex, _PlayerIndex, 1, 1, 1)
					return
				end
			end
			--CheckSuccess
			local SuccRateTab = StrSuccRate[tItemID] or StrSuccRate[-1]
			local SuccRate = SuccRateTab[tStrLv+1]
			if type(SuccRate)=="number" and SuccRate>0 then
				local tMin = 50 - math.floor(SuccRate/2) + 1
				local tMax = 50 + math.floor(SuccRate/2) + math.fmod(SuccRate,2)
				local tLuck = math.random(1, 100)
				if tLuck<tMin or tLuck>tMax then
					NLG.SystemMessage(_PlayerIndex, "[" .. "�����F��" .. "] �ܲ��ң�����b�䏊��ʧ�����������b��K�]�Гp�ġ���")
					BlacksmithNpc_WindowTalked( _MeIndex, _PlayerIndex, 1, 1, 1)
					return
				end
			end
			--SetData
			setItemStrData(tItemIndex, tStrLv)
			--SetStat
			--if Item.GetData(tItemIndex, %����_���ò���%)=="" then Item.SetData(tItemIndex, %����_��ǰ��%, tItemName) end
			if EquipPlusStat(tItemIndex)==nil then Item.SetData(tItemIndex, %����_��ǰ��%, tItemName) end
			EquipPlusStat(tItemIndex, "S", tStrLv+1)
			setItemName(tItemIndex)
			--Set Binding
			if StrBinding==1 or StrBinding==true then
				Item.SetData(tItemIndex, %����_�ɳ���%, 0)
				Item.SetData(tItemIndex, %����_����%, 0)
				Item.SetData(tItemIndex, %����_������ʧ%, 1)
			end
			--UpItem
			Item.UpItem(_PlayerIndex, tItemPos)
			NLG.UpChar(_PlayerIndex)
			NLG.SystemMessage(_PlayerIndex, "[" .. "�����F��" .. "] ��ϲ�㣡�b��ɹ�������+" .. tStrLv+1 .. "��")
			if (tStrLv+1>=7) then
				NLG.SystemMessage(-1, "[" .. "�����F��" .. "] ��ϲ "..Char.GetData(_PlayerIndex, %����_����%).."���� Item.GetData(tItemIndex, %����_��ǰ��%) �ɹ�������+" .. tStrLv+1 .. "��")
			end
			--print("δ������=" .. Item.GetData(tItemIndex, %����_��ǰ��%))
			--print("�Ѽ�����=" .. Item.GetData(tItemIndex, %����_����%))
			--print("���ò���=" .. Item.GetData(tItemIndex, %����_���ò���%))
			BlacksmithNpc_WindowTalked( _MeIndex, _PlayerIndex, 1, 1, 1)
		else
			NLG.SystemMessage(_PlayerIndex, "[" .. "�����F��" .. "] �@�e�]���b�䣬���돊�����Ƥ�w�᣿")
			--BlacksmithNpc_WindowTalked( _MeIndex, _PlayerIndex, 1, 1, 1)
		end
	end

	return
end

function EquipPlusStat( _ItemIndex, _StatTab, _StatValue )
	--  S-ǿ����R-���ģ�D-ħ����L-��ʱ
	local tStatTab = {}
	if type(_StatTab)=="nil" then
		--GetAll
		local tItemStat = Item.GetData(_ItemIndex, %����_���ò���%)
		if string.find(tItemStat, ",")==nil then
			return nil
		end
		if string.find(tItemStat, "|")==nil then
			local tSub = Split(tItemStat, ",")
			tStatTab[tSub[1]]=tonumber(tSub[2])
			return tStatTab
		end
		local tStat = Split(tItemStat, "|")
		for k,v in pairs(tStat) do
			local tSub = Split(v, ",")
			tStatTab[tSub[1]]=tonumber(tSub[2])
		end
		return tStatTab
	elseif type(_StatTab)=="table" then
		--SetAll
		local tStat = ""
		for k,v in pairs(_StatTab) do
			tStat = tStat .. k .. "," .. v .. "|"
		end
		Item.SetData(_ItemIndex, %����_���ò���%, tStat)
	elseif type(_StatTab)=="string" and type(_StatValue)=="nil" then
		--GetSub
		local tStatTab = EquipPlusStat(_ItemIndex) or {}
		for k,v in pairs(tStatTab) do
			if _StatTab==k then
				return tonumber(v)
			end
		end
		return nil
	elseif type(_StatTab)=="string" then
		--SetSub
		local tStatTab = EquipPlusStat(_ItemIndex) or {}
		tStatTab[_StatTab]=_StatValue
		EquipPlusStat(_ItemIndex, tStatTab)
	end
end

function setItemStrData( _ItemIndex, _StrLv )
	local tItemID = Item.GetData(_ItemIndex, 0)
	local bRateTab = StrBaseRate[tItemID] or StrBaseRate[-1]
	local bRate = 1 + bRateTab[_StrLv+1]/100
	Item.SetData(_ItemIndex, %����_����%, Item.GetData(_ItemIndex, %����_����%)*bRate)
	Item.SetData(_ItemIndex, %����_����%, Item.GetData(_ItemIndex, %����_����%)*bRate)
	Item.SetData(_ItemIndex, %����_����%, Item.GetData(_ItemIndex, %����_����%)*bRate)
	Item.SetData(_ItemIndex, %����_����%, Item.GetData(_ItemIndex, %����_����%)*bRate)
	Item.SetData(_ItemIndex, %����_�ظ�%, Item.GetData(_ItemIndex, %����_�ظ�%)*bRate)
	Item.SetData(_ItemIndex, %����_HP%, Item.GetData(_ItemIndex, %����_HP%)*bRate)
	Item.SetData(_ItemIndex, %����_MP%, Item.GetData(_ItemIndex, %����_MP%)*bRate)
	--Item.SetData(_ItemIndex, %����_ħ��%, Item.GetData(_ItemIndex, %����_ħ��%)*bRate)
	--Item.SetData(_ItemIndex, %����_ħ��%, Item.GetData(_ItemIndex, %����_ħ��%)*bRate)
	--Resist
	local rRateTab = StrResistRate[tItemID] or StrResistRate[-1]
	local rRate = 1 + rRateTab[_StrLv+1]/100
	Item.SetData(_ItemIndex, %����_����%, Item.GetData(_ItemIndex, %����_����%)*rRate)
	Item.SetData(_ItemIndex, %����_˯��%, Item.GetData(_ItemIndex, %����_˯��%)*rRate)
	Item.SetData(_ItemIndex, %����_ʯ��%, Item.GetData(_ItemIndex, %����_ʯ��%)*rRate)
	Item.SetData(_ItemIndex, %����_��%, Item.GetData(_ItemIndex, %����_��%)*rRate)
	Item.SetData(_ItemIndex, %����_�ҿ�%, Item.GetData(_ItemIndex, %����_�ҿ�%)*rRate)
	Item.SetData(_ItemIndex, %����_����%, Item.GetData(_ItemIndex, %����_����%)*rRate)
	--Fix
	local fRateTab = StrFixRate[tItemID] or StrFixRate[-1]
	local fRate = 1 + fRateTab[_StrLv+1]/100
	Item.SetData(_ItemIndex, %����_��ɱ%, Item.GetData(_ItemIndex, %����_��ɱ%)*fRate)
	Item.SetData(_ItemIndex, %����_����%, Item.GetData(_ItemIndex, %����_����%)*fRate)
	Item.SetData(_ItemIndex, %����_����%, Item.GetData(_ItemIndex, %����_����%)*fRate)
	Item.SetData(_ItemIndex, %����_����%, Item.GetData(_ItemIndex, %����_����%)*fRate)
	
end

function setItemName( _ItemIndex , _Name)
	local StatTab = EquipPlusStat( _ItemIndex )
	local ItemName = Item.GetData(_ItemIndex, %����_��ǰ��%)
	--�ѡ�??���怡�����������I
	for k,v in pairs(StatTab) do
		if k=="S" then
			ItemName = ItemName .. "+" .. v
		elseif k=="R" then
			if v~=nil and v>0 then
				ItemName = _Name .. ItemName
			end
		elseif k=="D" then
			if v~=nil and v>0 then
				ItemName = "�" .. ItemName
			end
		elseif k=="L" then
			if v~=nil and v>0 then
				ItemName = "?" .. ItemName
			end
		elseif k=="E" then
			if v~=nil and v>0 then
				ItemName = "�d" .. ItemName
			end
		end
	end
	Item.SetData(_ItemIndex, %����_����%, ItemName)
end