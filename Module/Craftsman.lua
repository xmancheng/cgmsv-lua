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
StrStrengEnable[-1] = 0	--�Ƿ���Ĭ������
StrStrengEnable[-2] = 1	--�Ƿ���Ĭ������
StrStrengEnable[-3] = 1	--�Ƿ���Ĭ������
--������ǿ����
local ItemType = -2	--���õ���Ʒ����(0~6)
StrStrengMaxLv[ItemType] = 9									--����ǿ���ȼ���������
StrBaseRate[ItemType] = 	{4, 4, 3, 3, 3, 2, 2, 2, 2}			--��ͨ���԰ٷֱ�
StrResistRate[ItemType] = 	{1, 1, 1, 1, 1, 1, 1, 1, 1}			--6���԰ٷֱ�
StrFixRate[ItemType] = 		{1, 1, 1, 1, 1, 1, 1, 1, 1}			--4�����ٷֱ�
StrSuccRate[ItemType] = 	{50, 45, 40, 35, 25, 20, 20, 20, 15}	--ǿ���ɹ���
StrBreakRate[ItemType] = 	{0, 0, 0, 0, 0, 0, 0, 0, 0}		--ǿ���ƻ���
StrRequireItemID[ItemType] = {71037, 71037, 71037, 71037, 71037, 71037, 71037, 71037, 71037}		--ǿ��������ƷID��ǿ��ʯID��
StrRequireItemNum[ItemType] = {1, 4, 9, 16, 25, 36, 49, 64, 81, 100}			--ǿ��������Ʒ������ǿ��ʯ������
StrRequireGold[ItemType] = {500, 2000, 4500, 8000, 12500, 18000, 24500, 32000, 40500, 50000}	--ǿ��������
--������ǿ����
local ItemType = -3	--���õ���Ʒ����(7~14)
StrStrengMaxLv[ItemType] = 9									--����ǿ���ȼ���������
StrBaseRate[ItemType] = 	{4, 4, 3, 3, 3, 2, 2, 2, 2}			--��ͨ���԰ٷֱ�
StrResistRate[ItemType] = 	{1, 1, 1, 1, 1, 1, 1, 1, 1}			--6���԰ٷֱ�
StrFixRate[ItemType] = 		{1, 1, 1, 1, 1, 1, 1, 1, 1}			--4�����ٷֱ�
StrSuccRate[ItemType] = 	{50, 45, 40, 35, 25, 20, 20, 20, 15}	--ǿ���ɹ���
StrBreakRate[ItemType] = 	{0, 0, 0, 0, 0, 0, 0, 0, 0}		--ǿ���ƻ���
StrRequireItemID[ItemType] = {71038, 71038, 71038, 71038, 71038, 71038, 71038, 71038, 71038}		--ǿ��������ƷID��ǿ��ʯID��
StrRequireItemNum[ItemType] = {1, 4, 9, 16, 25, 36, 49, 64, 81, 100}			--ǿ��������Ʒ������ǿ��ʯ������
StrRequireGold[ItemType] = {500, 2000, 4500, 8000, 12500, 18000, 24500, 32000, 40500, 50000}	--ǿ��������
--����������ǿ����
local ItemType = -1
StrStrengMaxLv[ItemType] = 9									--����ǿ���ȼ���������
StrBaseRate[ItemType] = 	{4, 4, 3, 3, 3, 2, 2, 2, 2}			--��ͨ���԰ٷֱ�
StrResistRate[ItemType] = 	{1, 1, 1, 1, 1, 1, 1, 1, 1}			--6���԰ٷֱ�
StrFixRate[ItemType] = 		{1, 1, 1, 1, 1, 1, 1, 1, 1}			--4�����ٷֱ�
StrSuccRate[ItemType] = 	{50, 45, 40, 35, 25, 20, 20, 20, 15}	--ǿ���ɹ���
StrBreakRate[ItemType] = 	{0, 0, 0, 0, 0, 0, 0, 0, 0}		--ǿ���ƻ���
StrRequireItemID[ItemType] = {71038, 71038, 71038, 71038, 71038, 71038, 71038, 71038, 71038}		--ǿ��������ƷID��ǿ��ʯID��
StrRequireItemNum[ItemType] = {1, 4, 9, 16, 25, 36, 49, 64, 81, 100}			--ǿ��������Ʒ������ǿ��ʯ������
StrRequireGold[ItemType] = {500, 2000, 4500, 8000, 12500, 18000, 24500, 32000, 40500, 50000}	--ǿ��������

--����ֹǿ����
--  һ��װ��һ�У���ֵ��д0����
local StrItemEnable = {}
StrItemEnable[980491] = 0
StrItemEnable[250] = 0    --ˮ��֮��
StrItemEnable[69105] = 0    --Ԫ������������
StrItemEnable[69106] = 0
StrItemEnable[69107] = 0
StrItemEnable[69108] = 0
StrItemEnable[70053] = 0    --����ȫ֧���g��
StrItemEnable[70054] = 0
StrItemEnable[70055] = 0
StrItemEnable[70056] = 0
StrItemEnable[70057] = 0
StrItemEnable[70058] = 0
StrItemEnable[70059] = 0
StrItemEnable[70060] = 0
StrItemEnable[79060] = 0    --������
StrItemEnable[79061] = 0
StrItemEnable[79062] = 0
StrItemEnable[79063] = 0
StrItemEnable[79064] = 0
StrItemEnable[79065] = 0
StrItemEnable[69226] = 0    --���Ͼ���
StrItemEnable[69227] = 0
StrItemEnable[69228] = 0
StrItemEnable[69229] = 0
StrItemEnable[79215] = 0    --�����^��̖
StrItemEnable[79216] = 0
StrItemEnable[79217] = 0
StrItemEnable[79218] = 0
StrItemEnable[79219] = 0
StrItemEnable[79220] = 0
StrItemEnable[79221] = 0
StrItemEnable[79222] = 0
StrItemEnable[79223] = 0
StrItemEnable[79224] = 0
StrItemEnable[79225] = 0
StrItemEnable[79226] = 0
StrItemEnable[79227] = 0
StrItemEnable[79228] = 0
StrItemEnable[79229] = 0
StrItemEnable[79230] = 0
StrItemEnable[79231] = 0
StrItemEnable[79232] = 0
StrItemEnable[79233] = 0
StrItemEnable[79234] = 0
StrItemEnable[79235] = 0
StrItemEnable[79236] = 0
StrItemEnable[79237] = 0
StrItemEnable[79238] = 0
StrItemEnable[79239] = 0
StrItemEnable[79240] = 0
StrItemEnable[79241] = 0
StrItemEnable[79242] = 0
StrItemEnable[79243] = 0
StrItemEnable[79244] = 0
StrItemEnable[79245] = 0
StrItemEnable[79246] = 0
StrItemEnable[79247] = 0
StrItemEnable[79248] = 0
StrItemEnable[79249] = 0


------------------------------------------------------------------------------
------------------------------------------------------------------------------
--                 �������ű�ϵͳ���á���������רҵ���������޸ģ�
------------------------------------------------------------------------------
local ItemPosName = {"�^ ��", "�� ��", "�� ��", "�� ��", "�� ��", "�Ʒ1", "�Ʒ2", "ˮ ��"}
------------------------------------------------------------------------------

function CraftsmanNpc_Func(index)
	print("Craftsman.Index=" .. index);
	return 1;
end

Delegate.RegInit("CraftsmanNpc_Init");
function CraftsmanNpc_Init()
	local CraftsmanNpc = NL.CreateNpc("lua/Module/Craftsman.lua", "CraftsmanNpc_Func");
	Char.SetData( CraftsmanNpc, %����_����%,105502);
	Char.SetData( CraftsmanNpc, %����_ԭ��%,105502);
	Char.SetData( CraftsmanNpc, %����_��ͼ%,25000);
	Char.SetData( CraftsmanNpc, %����_X%,28);
	Char.SetData( CraftsmanNpc, %����_Y%,7);
	Char.SetData( CraftsmanNpc, %����_����%,4);
	Char.SetData( CraftsmanNpc, %����_����%,"�b�侫����");
	NLG.UpChar( CraftsmanNpc)

	tbl_LuaNpcIndex = {}
	tbl_LuaNpcIndex["CraftsmanNpc"] = CraftsmanNpc

	if (Char.SetTalkedEvent(nil, "CraftsmanNpc_Talked", CraftsmanNpc) < 0) then
		print("CraftsmanNpc_Talked ע���¼�ʧ�ܡ�");
		return false;
	end

	if (Char.SetWindowTalkedEvent(nil, "CraftsmanNpc_WindowTalked", CraftsmanNpc) < 0) then
		print("CraftsmanNpc_WindowTalked ע���¼�ʧ�ܡ�");
		return false;
	end

	return true;
end

function CraftsmanNpc_Talked( _MeIndex, _PlayerIndex, _Mode)

	if(NLG.CheckInFront(_PlayerIndex, _MeIndex, 1)==false and _Mode~=1) then
		return ;
	end 

	NLG.ShowWindowTalked(_PlayerIndex, _MeIndex, 2, 2, 1,
			"8\n����������������" .. "�b�侫����" .. "��" ..
			"\n����һλ���԰������၆�������񽳣������p�tɫ" ..
			"\n�^���F�����^�����ć������c�Р����������s��" ..
			"\n���N�YԴ�c���ˡ�����������о���Ό����|��s" ..
			"\n�����زģ���ʹ�����׃�î����h����" ..
			"\n�����@λ�����������񽳣����˴���ɳ©����݆ޒ" ..
			"\n�ذl���𠎣����ڞ�ð�U���߂������b�䡣" .. 
			"\n" ..
			"\n����������������������s������"
			);

	return ;
end

function CraftsmanNpc_WindowTalked( _MeIndex, _PlayerIndex, _Seqno, _Select, _Data)

	--print("\n_MeIndex=" .. _MeIndex .. ", _PlayerIndex=" .. _PlayerIndex .. ", _Seqno=" .. _Seqno .. ", _Data=" .. _Data)
	
	--ȡ����ť
	if _Select==2 then
		return
	end

	if _Seqno==1 then
		local PlayerSelect = tonumber(_Data)
		if PlayerSelect==1 then
			--����ǿ��
			local TalkBuf = "1|\nՈ�x����Ҫ��s�����������b�䣺\n"
			for i = 0,7 do
				local tItemIndex = Char.GetItemIndex(_PlayerIndex, i);
				if tItemIndex>=0 then
					local tItemID = Item.GetData(tItemIndex, %����_ID%)
					--print("tItemID=" .. tItemID)
					local tItemName = Item.GetData(tItemIndex, %����_����%)
					local tStrLv = EquipPlusStat(tItemIndex, "S") or 0
					local tType = Item.GetData(tItemIndex, %����_����%);
					if (tType>=0 and tType<=6) then
						tTypeID = -2;
					elseif (tType>=7 and tType<=14) then 
						tTypeID = -3;
					else
						tTypeID = -1;
					end
					--���������иĶ�
					local tMaxLv = StrStrengMaxLv[tTypeID]
					local tNeedItemNumTab = StrRequireItemNum[tTypeID]
					local tNeedItemNum = tNeedItemNumTab[tStrLv+1]
					local tNeedGoldTab = StrRequireGold[tTypeID]
					local tNeedGold = tNeedGoldTab[tStrLv+1]
					local tItemCan = "[ǿ����]  " .. tNeedItemNum .. "��|"  .. string.format("%.2f", tNeedGold/10000) .. "W"
					if StrItemEnable[tItemID]==0 and StrStrengEnable[tTypeID]==1 then
						tItemCan="[ǿ����]"
					elseif StrStrengEnable[tTypeID]==1 then
						tItemCan="[ǿ����]  " .. tNeedItemNum .. "��|"  .. string.format("%.2f", tNeedGold/10000) .. "W"
					elseif StrStrengEnable[tTypeID]~=1 then
						tItemCan="[ǿ����]"
					end
					if tStrLv>=tMaxLv then tItemCan="[ǿ��Max]" end
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
			local tType = Item.GetData(tItemIndex, %����_����%);
			if (tType>=0 and tType<=6) then
				tTypeID = -2;
			elseif (tType>=7 and tType<=14) then 
				tTypeID = -3;
			else
				tTypeID = -1;
			end
			--CheckEnable
			local tStrLv = EquipPlusStat(tItemIndex, "S") or 0
			local tMaxLv = StrStrengMaxLv[tTypeID]
			if StrItemEnable[tItemID]==0 and StrStrengEnable[tTypeID]==1 then
				NLG.SystemMessage(_PlayerIndex, "[" .. "������" .. "] ���x����b��[" .. tItemName .. "]��[���ɏ���]��")
				return
			elseif StrStrengEnable[tTypeID]==1 then
			elseif StrStrengEnable[tTypeID]~=1 then
				NLG.SystemMessage(_PlayerIndex, "[" .. "������" .. "] ���x����b��[" .. tItemName .. "]��[���ɏ���]��")
				return
			end
			if tStrLv>=tMaxLv then
				NLG.SystemMessage(_PlayerIndex, "[" .. "������" .. "] ���x����b��[" .. tItemName .. "]���_��[����Max]��")
				return
			end
			if StrStrengEnable[tTypeID]==0 then
				NLG.SystemMessage(_PlayerIndex, "[" .. "������" .. "] ���x����b��[" .. tItemName .. "]��[���ɏ���]��")
				return
			end
			if EquipPlusStat(tItemIndex, "D")~=nil then
				NLG.SystemMessage(_PlayerIndex, "[" .. "������" .. "] ���x����b��[" .. tItemName .. "]��[ħ���b��]�����_���O�ޣ�")
				return
			end
			if EquipPlusStat(tItemIndex, "E")~=nil then
				NLG.SystemMessage(_PlayerIndex, "[" .. "������" .. "] ���x����b��[" .. tItemName .. "]��Ѫ����ħ���o���^�m������")
				return
			end
			if EquipPlusStat(tItemIndex, "R")~=nil then
				NLG.SystemMessage(_PlayerIndex, "[" .. "������" .. "] ���x����b��[" .. tItemName .. "]���Ƕ���ģ��o���^�m������")
				return
			end
			--CheckGold
			local tNeedGoldTab = StrRequireGold[tTypeID]
			local tNeedGold = tonumber(tNeedGoldTab[tStrLv+1]) or 0
			if tPlayerGold<tNeedGold then
				NLG.SystemMessage(_PlayerIndex, "[" .. "������" .. "] ������Ҫ" .. tNeedGold .. "G��������Ų��㣡")
				return
			end
			--CheckRequireItem
			local RequireItemIDTab = StrRequireItemID[tTypeID]
			local RequireItemID = RequireItemIDTab[tStrLv+1]
			local RequireItemNumTab = StrRequireItemNum[tTypeID]
			local RequireItemNum = RequireItemNumTab[tStrLv+1]
			if type(RequireItemID)=="number" and RequireItemID>0 and type(RequireItemNum)=="number" and RequireItemNum>0 then
				if Char.ItemNum(_PlayerIndex, RequireItemID)<RequireItemNum then
					NLG.SystemMessage(_PlayerIndex, "[" .. "������" .. "] ����������߲��㣡")
					return
				end
			end
			--DelGold
			Char.SetData(_PlayerIndex, %����_���%, tPlayerGold-tNeedGold)
			--DelItem
			Char.DelItem(_PlayerIndex, RequireItemID, RequireItemNum)
			--CheckBreak
			local BreakRateTab = StrBreakRate[tTypeID]
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
					NLG.SystemMessage(_PlayerIndex, "[" .. "������" .. "] �@�^���ǂ����y����춻����]���ƺã�����b��صך����ˡ���")
					--CraftsmanNpc_WindowTalked( _MeIndex, _PlayerIndex, 1, 1, 1)
					return
				end
			end
			--CheckSuccess
			local SuccRateTab = StrSuccRate[tTypeID]
			local SuccRate = SuccRateTab[tStrLv+1]
			if type(SuccRate)=="number" and SuccRate>0 then
				local tMin = 50 - math.floor(SuccRate/2) + 1
				local tMax = 50 + math.floor(SuccRate/2) + math.fmod(SuccRate,2)
				local tLuck = math.random(1, 100)
				if tLuck<tMin or tLuck>tMax then
					NLG.SystemMessage(_PlayerIndex, "[" .. "������" .. "] �ܲ��ң�����b�䏊��ʧ�����������b��K�]�Гp�ġ���")
					CraftsmanNpc_WindowTalked( _MeIndex, _PlayerIndex, 1, 1, 1)
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
			NLG.SystemMessage(_PlayerIndex, "[" .. "������" .. "] ��ϲ�㣡�b��ɹ�������+" .. tStrLv+1 .. "��")
			if (tStrLv+1>=7) then
				NLG.SystemMessage(-1, "[" .. "������" .. "] ��ϲ "..Char.GetData(_PlayerIndex, %����_����%).."���� Item.GetData(tItemIndex, %����_��ǰ��%) �ɹ�������+" .. tStrLv+1 .. "��")
			end
			--print("δ������=" .. Item.GetData(tItemIndex, %����_��ǰ��%))
			--print("�Ѽ�����=" .. Item.GetData(tItemIndex, %����_����%))
			--print("���ò���=" .. Item.GetData(tItemIndex, %����_���ò���%))
			CraftsmanNpc_WindowTalked( _MeIndex, _PlayerIndex, 1, 1, 1)
		else
			NLG.SystemMessage(_PlayerIndex, "[" .. "������" .. "] �@�e�]���b�䣬���돊�����Ƥ�w�᣿")
			--CraftsmanNpc_WindowTalked( _MeIndex, _PlayerIndex, 1, 1, 1)
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
	local tType = Item.GetData(_ItemIndex, %����_����%);
	if (tType>=0 and tType<=6) then
		tTypeID = -2;
	elseif (tType>=7 and tType<=14) then 
		tTypeID = -3;
	else
		tTypeID = -1;
	end
	local bRateTab = StrBaseRate[tTypeID]
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
	local rRateTab = StrResistRate[tTypeID]
	local rRate = 1 + rRateTab[_StrLv+1]/100
	Item.SetData(_ItemIndex, %����_����%, Item.GetData(_ItemIndex, %����_����%)*rRate)
	Item.SetData(_ItemIndex, %����_˯��%, Item.GetData(_ItemIndex, %����_˯��%)*rRate)
	Item.SetData(_ItemIndex, %����_ʯ��%, Item.GetData(_ItemIndex, %����_ʯ��%)*rRate)
	Item.SetData(_ItemIndex, %����_��%, Item.GetData(_ItemIndex, %����_��%)*rRate)
	Item.SetData(_ItemIndex, %����_�ҿ�%, Item.GetData(_ItemIndex, %����_�ҿ�%)*rRate)
	Item.SetData(_ItemIndex, %����_����%, Item.GetData(_ItemIndex, %����_����%)*rRate)
	--Fix
	local fRateTab = StrFixRate[tTypeID]
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
