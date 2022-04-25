local CountCrest = {}
------------------------------------------------------------------------------
------------------------------------------------------------------------------
local CrestEnable = {}
CrestEnable[20016] = 0  --0 ��ֹ���£�����Ϊ����ID
local ItemPosTable = {}
ItemPosTable[70207] = 0
ItemPosTable[70208] = 1
ItemPosTable[70209] = 4
ItemPosTable[70210] = 2
local CrestName = {}
CrestName[1] = {"����W",7000207,"�،���",%����_������%,%����_�ظ�%,1.5,"[��������] ����؏�����50%��"}
CrestName[2] = {"������",7000208,"ˮ����",%����_ˮ����%,%����_������%,1.2,"[�Զ�ŭĿ] ������R������20%��"}
CrestName[3] = {"������",7000209,"������",%����_������%,%����_������%,1.2,"[���͹���] ���﹥��������20%��"}
CrestName[4] = {"������",7000210,"�L����",%����_������%,%����_����%,1.3,"[��ۙ��Ӱ] ������������30%��"}
------------------------------------------------------------------------------

Delegate.RegDelBattleStartEvent("Crest_BattleStart");
function Crest_BattleStart(BattleIndex)
	CountCrest[1] = 0
	CountCrest[2] = 0
	CountCrest[3] = 0
	CountCrest[4] = 0
	for i=0,9 do
		local _PlayerIndex = Battle.GetPlayer(BattleIndex, i)
		for k=0,4 do
			local item = Char.GetItemIndex(_PlayerIndex,k);
			local Crestitem = Item.GetData(item,58);
			if (Crestitem==7000207) then
				CountCrest[1] = CountCrest[1] + 1
			end
			if (Crestitem==7000208) then
				CountCrest[2] = CountCrest[2] + 1
			end
			if (Crestitem==7000209) then
				CountCrest[3] = CountCrest[3] + 1
			end
			if (Crestitem==7000210) then
				CountCrest[4] = CountCrest[4] + 1
			end
		end
		if(CountCrest[1] > 0 and Char.GetData(_PlayerIndex,%��������_��%) == 3) then
			local plus = CountCrest[1];
			local msg = "[�y��Ч��] ���������،���"..plus.."�c��"
			Char.SetData(_PlayerIndex,%����_������%, Char.GetData(_PlayerIndex,%����_������%) + plus*10);
			--NLG.TalkToCli(-1,-1,msg,%��ɫ_��ɫ%,%����_��%);
			if(plus >= 3) then
				local heal = Char.GetData(_PlayerIndex,%����_�ظ�%);
				local New_50heal = heal * 1.5;
				Char.SetData(_PlayerIndex,%����_�ظ�%,New_50heal);
				--NLG.TalkToCli(-1,-1,"[��������] ��һ�غό���؏�����50%��",%��ɫ_��ɫ%,%����_��%);
			end
		end
		if(CountCrest[2] > 0 and Char.GetData(_PlayerIndex,%��������_��%) == 3) then
			local plus = CountCrest[2];
			local msg = "[�y��Ч��] ��������ˮ����"..plus.."�c��"
			Char.SetData(_PlayerIndex,%����_ˮ����%, Char.GetData(_PlayerIndex,%����_ˮ����%) + plus*10);
			--NLG.TalkToCli(-1,-1,msg,%��ɫ_��ɫ%,%����_��%);
			if(plus >= 3) then
				local tough = Char.GetData(_PlayerIndex,%����_������%);
				local New_20tough = tough * 1.2;
				Char.SetData(_PlayerIndex,%����_������%,New_20tough);
				--NLG.TalkToCli(-1,-1,"[�Զ�ŭĿ] ��һ�غό�����R������20%��",%��ɫ_��ɫ%,%����_��%);
			end
		end
		if(CountCrest[3] > 0 and Char.GetData(_PlayerIndex,%��������_��%) == 3) then
			local plus = CountCrest[3];
			local msg = "[�y��Ч��] ��������������"..plus.."�c��"
			Char.SetData(_PlayerIndex,%����_������%, Char.GetData(_PlayerIndex,%����_������%) + plus*10);
			--NLG.TalkToCli(-1,-1,msg,%��ɫ_��ɫ%,%����_��%);
			if(plus >= 3) then
				local power = Char.GetData(_PlayerIndex,%����_������%);
				local New_20power = power * 1.2;
				Char.SetData(_PlayerIndex,%����_������%,New_20power);
				--NLG.TalkToCli(-1,-1,"[���͹���] ��һ�غό��﹥��������20%��",%��ɫ_��ɫ%,%����_��%);
			end
		end
		if(CountCrest[4] > 0 and Char.GetData(_PlayerIndex,%��������_��%) == 3) then
			local plus = CountCrest[4];
			local msg = "[�y��Ч��] ���������L����"..plus.."�c��"
			Char.SetData(_PlayerIndex,%����_������%, Char.GetData(_PlayerIndex,%����_������%) + plus*10);
			--NLG.TalkToCli(-1,-1,msg,%��ɫ_��ɫ%,%����_��%);
			if(plus >= 3) then
				local agi = Char.GetData(_PlayerIndex,%����_����%);
				local New_30agi = agi * 1.3;
				Char.SetData(_PlayerIndex,%����_����%,New_30agi);
				--NLG.TalkToCli(-1,-1,"[��ۙ��Ӱ] ��һ�غό�����������30%��",%��ɫ_��ɫ%,%����_��%);
			end
		end
	end
	return 0
end
Delegate.RegDelBattleOverEvent("Crest_BattleOver");
function Crest_BattleOver(BattleIndex)
	for i=0,9 do
		local _PlayerIndex = Battle.GetPlayer(BattleIndex, i)
		if(CountCrest[1] > 0 and Char.GetData(_PlayerIndex,%��������_��%) == 3) then
			local plus = CountCrest[1];
			local msg = "[�y��Ч��] ������Ի؏�ԭ�"
			Char.SetData(_PlayerIndex,%����_������%, Char.GetData(_PlayerIndex,%����_������%) - plus*10);
			--NLG.TalkToCli(-1,-1,msg,%��ɫ_��ɫ%,%����_��%);
		end
		if(CountCrest[2] > 0 and Char.GetData(_PlayerIndex,%��������_��%) == 3) then
			local plus = CountCrest[2];
			local msg = "[�y��Ч��] ������Ի؏�ԭ�"
			Char.SetData(_PlayerIndex,%����_ˮ����%, Char.GetData(_PlayerIndex,%����_ˮ����%) - plus*10);
			--NLG.TalkToCli(-1,-1,msg,%��ɫ_��ɫ%,%����_��%);
		end
		if(CountCrest[3] > 0 and Char.GetData(_PlayerIndex,%��������_��%) == 3) then
			local plus = CountCrest[3];
			local msg = "[�y��Ч��] ������Ի؏�ԭ�"
			Char.SetData(_PlayerIndex,%����_������%, Char.GetData(_PlayerIndex,%����_������%) - plus*10);
			--NLG.TalkToCli(-1,-1,msg,%��ɫ_��ɫ%,%����_��%);
		end
		if(CountCrest[4] > 0 and Char.GetData(_PlayerIndex,%��������_��%) == 3) then
			local plus = CountCrest[4];
			local msg = "[�y��Ч��] ������Ի؏�ԭ�"
			Char.SetData(_PlayerIndex,%����_������%, Char.GetData(_PlayerIndex,%����_������%) - plus*10);
			--NLG.TalkToCli(-1,-1,msg,%��ɫ_��ɫ%,%����_��%);
		end
	end
	return 0
end


NL.RegBattleActionEvent(nil,"Crest_A")

function Crest_A(_PlayerIndex, battle, Com1, Com2, Com3, ActionNum)
	for i=1,4 do
		if(CountCrest[i] > 0 and Char.GetData(_PlayerIndex,%��������_��%) == 3) then
			local plus = CountCrest[i];
			local msg = "[�y��Ч��] ��������"..CrestName[i][3]..plus.."�c��"
			Char.SetData(_PlayerIndex, CrestName[i][4], Char.GetData(_PlayerIndex, CrestName[i][4]) + plus);
			NLG.TalkToCli(-1,-1,msg,%��ɫ_��ɫ%,%����_��%);
			if(plus >= 3) then
				local ability = Char.GetData(_PlayerIndex,CrestName[i][5]);
				local New_ability = ability * CrestName[i][6];
				Char.SetData(_PlayerIndex,CrestName[i][5],New_ability);
				NLG.TalkToCli(-1,-1,CrestName[i][7],%��ɫ_��ɫ%,%����_��%);
			end
		end
	end
	return
end

Delegate.RegInit("EquipCrestNpc_Init");

function EquipCrestNpc_Init()
	EquipCrestNpc = NL.CreateNpc(nil, "Myinit");
	Char.SetData(EquipCrestNpc,%����_����%,14682);
	Char.SetData(EquipCrestNpc,%����_ԭ��%,14682);
	Char.SetData(EquipCrestNpc,%����_X%,38);
	Char.SetData(EquipCrestNpc,%����_Y%,31);
	Char.SetData(EquipCrestNpc,%����_��ͼ%,777);
	Char.SetData(EquipCrestNpc,%����_����%,0);
	Char.SetData(EquipCrestNpc,%����_����%,"��������");
	NLG.UpChar(EquipCrestNpc);
	Char.SetTalkedEvent(nil, "EquipCrestNpc_Talked", EquipCrestNpc);
	Char.SetWindowTalkedEvent(nil, "EquipCrestNpc_WindowTalked", EquipCrestNpc);
	return true;
end

function Myinit(_MeIndex)
	return true;
end

NL.RegItemString("lua/Module/EquipCrest.lua","Crest","LUA_useCrest");
function Crest(_PlayerIndex,_toIndex,_itemslot) --˫������ִ�к���
	ItemID = Item.GetData(Char.GetItemIndex(_PlayerIndex,_itemslot),0);
	local TalkMsg =		"\\n                ���������¡�" ..
				"\\n��װ�����������������" ..
				"\\n������ս��������������" ..
				"\\n " ..
				"\\n�����ظ����轫����" ..
				"\\n�޷���Ӱ����������" ..
				"\\n " ..
				"\\nѡ��    ���������¡�"..
				"\\n " 
	NLG.ShowWindowTalked(_PlayerIndex, EquipCrestNpc,%����_��Ϣ��%,%��ť_�Ƿ�%, 1, TalkMsg);
	return 1;
end

function EquipCrestNpc_Talked( _NpcIndex, _PlayerIndex, _Mode)
	if (NLG.CanTalk(_NpcIndex,_PlayerIndex) == true) then
		local WindowMsg = "3|\\n                ���������¡�" ..	"\\n�Ƴ����½��޷��ظ����������Ϊ��Ǯʮ��\\n\\n";
		for i=0,4 do
			local item = Char.GetItemIndex(_PlayerIndex,i);

			if(VaildChar(item)==false)then
				WindowMsg = WindowMsg .. " 			 			��\\n";
			else
				WindowMsg = WindowMsg .. " 			 			"..Item.GetData(item,%����_����%).."\\n";
			end
		end		
		NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_ѡ���%,%��ť_�ر�%,2,WindowMsg);
	end
	return ;
end


function EquipCrestNpc_WindowTalked( _NpcIndex, _PlayerIndex, _Seqno, _Select, _Data)
	local Gold = Char.GetData(_PlayerIndex, %����_���%);
	local item_indexA = Char.GetItemIndex(_PlayerIndex,Char.FindItemId(_PlayerIndex,ItemID));
	local item_indexB = Char.GetItemIndex(_PlayerIndex,ItemPosTable[ItemID]);
	local TargetItemID = Item.GetData(item_indexB,0);
	if (_Seqno==1) then
		if (_Select==8) then
			return
		end
		if (_Select==4 and item_indexB == -2) then
			return
		end
		if (_Select==4 and Item.GetData(item_indexB,%����_��󹥻�����%)>=2) then
			NLG.SystemMessage(_PlayerIndex,"[ϵͳ] �޷�����������£�");
			return
		end
		if (_Select==4 and item_indexB ~= -2 and CrestEnable[TargetItemID] ~= 0) then
			local suit = math.random(1,4);
			Item.SetData(item_indexB,%����_��ӡ%,1);
			Item.SetData(item_indexB,%����_��ӡ���%,CrestName[suit][1]);
			Item.SetData(item_indexB,58,CrestName[suit][2]);
			Item.UpItem(_PlayerIndex,ItemPosTable[ItemID]);

			NLG.SystemMessage(_PlayerIndex,"[ϵͳ] �������³ɹ���");
			Char.DelItem(_PlayerIndex,ItemID,1);
		else
			NLG.SystemMessage(_PlayerIndex,"[ϵͳ] �޷�����������£�");
		end
	end
	if (_Seqno==2) then
		--ȡ����ť
		local selectitem = tonumber(_Data) - 1;
		if (selectitem==nil or (selectitem~=nil and (selectitem > 4 or selectitem < 0))) then
				NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,3,"\\n\\n\\n����ѡ���λ�ò�������");
				return;
		end
		local item_indexB = Char.GetItemIndex(_PlayerIndex,selectitem);
		if (VaildChar(item_indexB) == false) then
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,4,"\\n\\n\\n��ȷ������Ӧ��װ������װ����");
			return;
		end
		if (selectitem<=4 and Item.GetData(item_indexB,%����_��󹥻�����%)>=2) then
			NLG.SystemMessage(_PlayerIndex,"[ϵͳ] �޷��Ƴ����£�");
			return;
		end
		if (selectitem<=4 and Item.GetData(item_indexB,%����_��󹥻�����%)<=1 and Item.GetData(item_indexB,58)~=0 and Gold >= 100000) then
			Item.SetData(item_indexB,%����_��ӡ%,0);
			Item.SetData(item_indexB,%����_��ӡ���%,0);
			Item.SetData(item_indexB,58,0);
			Item.UpItem(_PlayerIndex,selectitem);
			Char.AddGold(_PlayerIndex,-100000);
			NLG.SystemMessage(_PlayerIndex,"[ϵͳ] �Ƴ����³ɹ���");
		end
		if (selectitem<=4 and Gold < 100000) then
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,3,"\\n\\n\\n��ȷ�Ͻ�Ǯ�㹻ʮ��");
		end
	end
end


