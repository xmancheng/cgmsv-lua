local EnemySet = {}
local BaseLevelSet = {}
local Pos = {}
local STime = os.time()
local YS = 30 --�ű���ʱ�����봴��NPC
local SXTime = 15 --NPCˢ��ʱ�䡤��
--���н���
--     ��	��	һ	��	��
--     ʮ	��	��	��	��
------------���⵺ð�����NPC����------------
EnemySet[1] = {0, 406135, 406135, 0, 0, 0, 0, 0, 406135, 406135}--0����û�й�
EnemySet[2] = {0, 406136, 406136, 0, 0, 0, 0, 0, 406136, 406136}
EnemySet[3] = {0, 406137, 406137, 0, 0, 0, 0, 0, 406137, 406137}
EnemySet[4] = {0, 406138, 406138, 0, 0, 0, 0, 0, 406138, 406138}
EnemySet[5] = {0, 406139, 406139, 0, 0, 0, 0, 0, 406139, 406139}
EnemySet[6] = {406140, 406135, 406136, 0, 0, 406137, 0, 0, 406138, 406139}
BaseLevelSet[1] = {0, 90, 90, 0, 0, 0, 0, 0, 90, 90}
BaseLevelSet[2] = {0, 90, 90, 0, 0, 0, 0, 0, 90, 90}
BaseLevelSet[3] = {0, 90, 90, 0, 0, 0, 0, 0, 90, 90}
BaseLevelSet[4] = {0, 90, 90, 0, 0, 0, 0, 0, 90, 90}
BaseLevelSet[5] = {0, 90, 90, 0, 0, 0, 0, 0, 90, 90}
BaseLevelSet[6] = {100, 90, 90, 0, 0, 90, 0, 0, 90, 90}
Pos[1] = {{"�ɿɵ����",104845,38301,70,40,4,EnemySet[1],1,BaseLevelSet[1]},{"���൰���",104846,38301,75,50,0,EnemySet[2],2,BaseLevelSet[2]},{"���ɵ����",104847,38301,65,45,2,EnemySet[3],3,BaseLevelSet[3]},{"���͵����",104848,38301,45,52,1,EnemySet[4],4,BaseLevelSet[4]},{"Ĩ�走���",104849,38301,93,55,5,EnemySet[5],5,BaseLevelSet[5]}}
Pos[2] = {{"�ɿɵ����",104845,38301,77,62,4,EnemySet[1],6,BaseLevelSet[1]},{"���൰���",104846,38301,54,59,0,EnemySet[2],7,BaseLevelSet[2]},{"���ɵ����",104847,38301,53,74,2,EnemySet[3],8,BaseLevelSet[3]},{"���͵����",104848,38301,73,72,1,EnemySet[4],9,BaseLevelSet[4]},{"Ĩ�走���",104849,38301,91,81,5,EnemySet[5],10,BaseLevelSet[5]}}
Pos[3] = {{"�ɿɵ����",104845,38301,61,99,4,EnemySet[1],11,BaseLevelSet[1]},{"���൰���",104846,38301,84,98,0,EnemySet[2],12,BaseLevelSet[2]},{"���ɵ����",104847,38301,70,82,2,EnemySet[3],13,BaseLevelSet[3]},{"���͵����",104848,38301,78,113,1,EnemySet[4],14,BaseLevelSet[4]},{"Ĩ�走���",104849,38301,92,68,5,EnemySet[5],15,BaseLevelSet[5]}}
Pos[4] = {{"BIG��MOM",104313,38301,49,34,4,EnemySet[6],60,BaseLevelSet[6]}}

------------�Ϲϴ�������NPC����------------
EnemySet[7] = {406130, 406130, 406130, 0, 0, 406130, 406130, 406130, 0, 0}
EnemySet[8] = {406131, 406131, 406131, 0, 0, 406131, 406131, 406131, 0, 0}
EnemySet[9] = {406132, 406132, 406132, 0, 0, 406132, 406132, 406132, 0, 0}
EnemySet[10] = {406133, 406133, 406133, 0, 0, 406133, 406133, 406133, 0, 0}
EnemySet[11] = {406134, 0, 0, 406132, 406133, 0, 406130, 406131, 0, 0}
BaseLevelSet[7] = {70, 70, 70, 0, 0, 70, 70, 70, 0, 0}
BaseLevelSet[8] = {70, 70, 70, 0, 0, 70, 70, 70, 0, 0}
BaseLevelSet[9] = {70, 70, 70, 0, 0, 70, 70, 70, 0, 0}
BaseLevelSet[10] = {70, 70, 70, 0, 0, 70, 70, 70, 0, 0}
BaseLevelSet[11] = {70, 0, 0, 70, 70, 0, 70, 70, 0, 0}
Pos[5] = {{"�����Ϲϵ�",104685,38190,70,134,0,EnemySet[7],16,BaseLevelSet[7]},{"�����Ϲϵ�",104686,38190,71,115,4,EnemySet[8],17,BaseLevelSet[8]},{"�����Ϲϵ�",104398,38190,86,111,1,EnemySet[9],18,BaseLevelSet[9]},{"�����Ϲϵ�",104399,38190,101,115,2,EnemySet[10],19,BaseLevelSet[10]}}
Pos[6] = {{"�����Ϲϵ�",104685,38190,85,91,0,EnemySet[7],20,BaseLevelSet[7]},{"�����Ϲϵ�",104686,38190,69,99,4,EnemySet[8],21,BaseLevelSet[8]},{"�����Ϲϵ�",104398,38190,100,86,1,EnemySet[9],22,BaseLevelSet[9]},{"�����Ϲϵ�",104399,38190,83,72,2,EnemySet[10],23,BaseLevelSet[10]}}
Pos[7] = {{"�����Ϲϵ�",104685,38190,117,105,0,EnemySet[7],24,BaseLevelSet[7]},{"�����Ϲϵ�",104686,38190,103,100,4,EnemySet[8],25,BaseLevelSet[8]},{"�����Ϲϵ�",104398,38190,121,113,1,EnemySet[9],26,BaseLevelSet[9]},{"�����Ϲϵ�",104399,38190,103,130,2,EnemySet[10],27,BaseLevelSet[10]}}
Pos[8] = {{"�޴���ʥ�Ϲ�",104937,38190,114,81,6,EnemySet[11],61,BaseLevelSet[11]}}

------------����֮�������NPC����------------
EnemySet[12] = {406125, 406125, 406125, 406125, 406125, 406125, 406125, 406125, 0, 0}
EnemySet[13] = {406126, 406126, 406126, 406126, 406126, 406126, 406126, 406126, 0, 0}
EnemySet[14] = {406127, 406127, 406127, 406127, 406127, 406127, 406127, 406127, 0, 0}
EnemySet[15] = {406128, 406128, 406128, 406128, 406128, 406128, 406128, 406128, 0, 0}
EnemySet[16] = {406129, 406125, 406126, 406127, 406128, 0, 0, 0, 0, 0}
BaseLevelSet[12] = {50, 50, 50, 50, 50, 50, 50, 50, 0, 0}
BaseLevelSet[13] = {50, 50, 50, 50, 50, 50, 50, 50, 0, 0}
BaseLevelSet[14] = {50, 50, 50, 50, 50, 50, 50, 50, 0, 0}
BaseLevelSet[15] = {50, 50, 50, 50, 50, 50, 50, 50, 0, 0}
BaseLevelSet[16] = {50, 50, 50, 50, 50, 0, 0, 0, 0, 0}
Pos[9] = {{"������С��",104759,38304,51,76,0,EnemySet[12],28,BaseLevelSet[12]},{"������С��",104760,38304,34,61,4,EnemySet[13],29,BaseLevelSet[13]},{"ҩ����С��",104761,38304,64,81,1,EnemySet[14],30,BaseLevelSet[14]},{"������С��",104762,38304,78,75,2,EnemySet[15],31,BaseLevelSet[15]}}
Pos[10] = {{"������С��",104759,38304,66,96,0,EnemySet[12],32,BaseLevelSet[12]},{"������С��",104760,38304,78,99,4,EnemySet[13],33,BaseLevelSet[13]},{"ҩ����С��",104761,38304,93,88,1,EnemySet[14],34,BaseLevelSet[14]},{"������С��",104762,38304,87,70,2,EnemySet[15],35,BaseLevelSet[15]}}
Pos[11] = {{"������С��",104759,38304,71,49,0,EnemySet[12],36,BaseLevelSet[12]},{"������С��",104760,38304,54,49,4,EnemySet[13],37,BaseLevelSet[13]},{"ҩ����С��",104761,38304,70,32,1,EnemySet[14],38,BaseLevelSet[14]},{"������С��",104762,38304,57,32,2,EnemySet[15],39,BaseLevelSet[15]}}
Pos[12] = {{"���绮����",104758,38304,67,67,5,EnemySet[16],62,BaseLevelSet[16]}}

------------�ɾ�С��ɭ���NPC����------------
EnemySet[17] = {406120, 406120, 406120, 406120, 406120, 406120, 406120, 406120, 406120, 406120}
EnemySet[18] = {406121, 406121, 406121, 406121, 406121, 406121, 406121, 406121, 406121, 406121}
EnemySet[19] = {406122, 406122, 406122, 406122, 406122, 406122, 406122, 406122, 406122, 406122}
EnemySet[20] = {406123, 406123, 406123, 406123, 406123, 406123, 406123, 406123, 406123, 406123}
EnemySet[21] = {406124, 406124, 406124, 406124, 406124, 406124, 406124, 406124, 406124, 406124}
BaseLevelSet[17] = {30, 30, 30, 30, 30, 30, 30, 30, 30, 30}
BaseLevelSet[18] = {30, 30, 30, 30, 30, 30, 30, 30, 30, 30}
BaseLevelSet[19] = {30, 30, 30, 30, 30, 30, 30, 30, 30, 30}
BaseLevelSet[20] = {30, 30, 30, 30, 30, 30, 30, 30, 30, 30}
BaseLevelSet[21] = {30, 30, 30, 30, 30, 30, 30, 30, 30, 30}
Pos[13] = {{"��Ҷ��",104680,38191,97,114,0,EnemySet[17],40,BaseLevelSet[17]},{"��Ҷ��",104681,38191,103,147,4,EnemySet[18],41,BaseLevelSet[18]},{"ħҶ��",104682,38191,102,154,1,EnemySet[19],42,BaseLevelSet[19]},{"��Ҷ��",104683,38191,91,157,2,EnemySet[20],43,BaseLevelSet[20]},{"��Ҷ��",104684,38191,93,147,5,EnemySet[21],44,BaseLevelSet[21]}}
Pos[14] = {{"��Ҷ��",104680,38191,67,113,0,EnemySet[17],45,BaseLevelSet[17]},{"��Ҷ��",104681,38191,71,117,4,EnemySet[18],46,BaseLevelSet[18]},{"ħҶ��",104682,38191,57,120,1,EnemySet[19],47,BaseLevelSet[19]},{"��Ҷ��",104683,38191,69,128,2,EnemySet[20],48,BaseLevelSet[20]},{"��Ҷ��",104684,38191,63,133,5,EnemySet[21],49,BaseLevelSet[21]}}
Pos[15] = {{"��Ҷ��",104680,38191,104,76,0,EnemySet[17],50,BaseLevelSet[17]},{"��Ҷ��",104681,38191,107,82,4,EnemySet[18],51,BaseLevelSet[18]},{"ħҶ��",104682,38191,104,90,1,EnemySet[19],52,BaseLevelSet[19]},{"��Ҷ��",104683,38191,95,83,2,EnemySet[20],53,BaseLevelSet[20]},{"��Ҷ��",104684,38191,106,98,5,EnemySet[21],54,BaseLevelSet[21]}}
Pos[16] = {{"��Ҷ��",104680,38191,127,89,0,EnemySet[17],55,BaseLevelSet[17]},{"��Ҷ��",104681,38191,131,98,4,EnemySet[18],56,BaseLevelSet[18]},{"ħҶ��",104682,38191,131,106,1,EnemySet[19],57,BaseLevelSet[19]},{"��Ҷ��",104683,38191,127,116,2,EnemySet[20],58,BaseLevelSet[20]},{"��Ҷ��",104684,38191,118,106,5,EnemySet[21],59,BaseLevelSet[21]}}

tbl_RandomActivityNpcIndex = tbl_RandomActivityNpcIndex or {}
------------------------------------------------
local script_map_name = {};
local script_map_point = {};
local script_map_lvlimit = {};
local script_map_payfor = {};
local script_map_drop = {};
local script_map_daily_user = {};
local script_map_daily_user_count = {};
script_map_daily_user_count[1] = {};
script_map_daily_user_count[2] = {};
script_map_daily_user_count[3] = {};
script_map_daily_user_count[4] = {};
script_map_daily_user_count[5] = {};
script_map_daily_user_count[6] = {};
local script_map_amount = {};
script_map_amount[2] = {};
script_map_amount[3] = {};
script_map_amount[4] = {};
script_map_amount[5] = {};

script_map_name[2] = "���ɾ�С��ɭ��";
script_map_point[2] = {38191,107,65};
script_map_lvlimit[2] = 30;
script_map_payfor[2] = 2000;
script_map_drop[2] = {70200,70200,70200,70201,70202,70202,70202};

script_map_name[3] = "������֮���ġ�";
script_map_point[3] = {38304,64,24};
script_map_lvlimit[3] = 50;
script_map_payfor[3] = 2000;
script_map_drop[3] = {70200,70200,70200,70201,70203,70203,70203};

script_map_name[4] = "���Ϲϴ������";
script_map_point[4] = {38190,67,118};
script_map_lvlimit[4] = 70;
script_map_payfor[4] = 2000;
script_map_drop[4] = {70200,70201,70201,70204,70204,70204,70204};

script_map_name[5] = "�����⵺ð�ա�";
script_map_point[5] = {38301,67,37};
script_map_lvlimit[5] = 90;
script_map_payfor[5] = 2000;
script_map_drop[5] = {70200,70201,70201,70205,70205,70205,70205};

Delegate.RegInit("initActivityScriptNpc");

function initActivityScriptNpc_Init(index)
	return 1;
end

function mykgold(_PlayerIndex,gold)
	local tjb = Char.GetData(_PlayerIndex,%����_���%);
	tjb = tjb - gold; 
	if(tjb >= 0)then
		Char.SetData(_PlayerIndex,%����_���%,tjb);
		NLG.UpChar(_PlayerIndex);
		NLG.SystemMessage(_PlayerIndex,"������"..gold.." Għ�ҡ�");
		return true;
	end
	return false;
end

function initActivityScriptNpc()
	if (ActivityScriptNps == nil) then
		ActivityScriptNps = NL.CreateNpc("lua/Module/ActivityScript.lua", "initActivityScriptNpc_Init");
		Char.SetData(ActivityScriptNps,%����_����%,260069);
		Char.SetData(ActivityScriptNps,%����_ԭ��%,260069);
		Char.SetData(ActivityScriptNps,%����_X%,219);
		Char.SetData(ActivityScriptNps,%����_Y%,84);
		Char.SetData(ActivityScriptNps,%����_��ͼ%,1000);
		Char.SetData(ActivityScriptNps,%����_����%,6);
		Char.SetData(ActivityScriptNps,%����_ԭ��%,"ÿ�ջ����");
		NLG.UpChar(ActivityScriptNps);
		Char.SetWindowTalkedEvent("lua/Module/ActivityScript.lua","ActivityScriptA",ActivityScriptNps);
		Char.SetTalkedEvent("lua/Module/ActivityScript.lua","ActivityScriptMsg", ActivityScriptNps);
	end
	if (ActivityScriptNpsB == nil) then
		ActivityScriptNpsB = NL.CreateNpc("lua/Module/ActivityScript.lua", "initActivityScriptNpc_Init");
		Char.SetData(ActivityScriptNpsB,%����_����%,231119);
		Char.SetData(ActivityScriptNpsB,%����_ԭ��%,231119);
		Char.SetData(ActivityScriptNpsB,%����_X%,218);
		Char.SetData(ActivityScriptNpsB,%����_Y%,83);
		Char.SetData(ActivityScriptNpsB,%����_��ͼ%,1000);
		Char.SetData(ActivityScriptNpsB,%����_����%,6);
		Char.SetData(ActivityScriptNpsB,%����_ԭ��%,"��������Ա");
		NLG.UpChar(ActivityScriptNpsB);
		Char.SetWindowTalkedEvent("lua/Module/ActivityScript.lua","ActivityScriptB",ActivityScriptNpsB);
		Char.SetTalkedEvent("lua/Module/ActivityScript.lua","ActivityScriptMsgB", ActivityScriptNpsB);
	end
	if (ActivityScriptNpsC == nil) then
		ActivityScriptNpsC = NL.CreateNpc("lua/Module/ActivityScript.lua", "initActivityScriptNpc_Init");
		Char.SetData(ActivityScriptNpsC,%����_����%,231116);
		Char.SetData(ActivityScriptNpsC,%����_ԭ��%,231116);
		Char.SetData(ActivityScriptNpsC,%����_X%,16);
		Char.SetData(ActivityScriptNpsC,%����_Y%,16);
		Char.SetData(ActivityScriptNpsC,%����_��ͼ%,777);
		Char.SetData(ActivityScriptNpsC,%����_����%,6);
		Char.SetData(ActivityScriptNpsC,%����_ԭ��%,"��������");
		NLG.UpChar(ActivityScriptNpsC);
		Char.SetLoopEvent(nil, "ActivityScript_LoopEvent",ActivityScriptNpsC, SXTime*1000)
		Char.SetWindowTalkedEvent("lua/Module/ActivityScript.lua","ActivityScriptC",ActivityScriptNpsC);
		Char.SetTalkedEvent("lua/Module/ActivityScript.lua","ActivityScriptMsgC", ActivityScriptNpsC);
	end
end

function ActivityScriptMsgA(_me,_tome)
	if (NLG.CanTalk(_me,_tome) == true) then
		local PlayerLevel = tonumber(Char.GetData(_tome,%����_�ȼ�%));
		
		if (PlayerLevel < 20) then
			NLG.ShowWindowTalked(_tome,_me,%����_��Ϣ��%,%��ť_ȷ��%,1,NLG.c("\\n\\n\\n�ȵ���20�������ɣ�"));
			return;
		end

		if(Time_Out(_tome))then
			script_map_daily_user[Playerkey(_tome)] = os.time();
			for i=1,6 do
				script_map_daily_user_count[i][Playerkey(_tome)] = nil;
			end
		end

		if (script_map_daily_user_count[1][Playerkey(_tome)] == 1) then
			NLG.ShowWindowTalked(_tome,_me,%����_��Ϣ��%,%��ť_ȷ��%,1,NLG.c("\\n\\n\\n���������ɣ�"));
			return;
		end
		script_map_daily_user_count[1][Playerkey(_tome)] = 1;
		NLG.ShowWindowTalked(_tome,_me,%����_��Ϣ��%,%��ť_ȷ��%,1,NLG.c("\\n\\n\\n��Ը��μӻ�����õ�����ֵ��ϡ�е�����"));
	end
	return;
end



function ActivityScriptMsg(_me,_tome)
	if (NLG.CanTalk(_me,_tome) == true) then
		local _obj = script_map_daily_user[Playerkey(_tome)];
		--����״ε�¼
		if (_obj == nil) then 
			script_map_daily_user[Playerkey(_tome)] = os.time();
		end
		if (os.date("%P",_obj) ~= os.date("%P",os.time())) then --�ж��ϡ���������
			script_map_daily_user[Playerkey(_tome)] = os.time();
			for i=1,6 do
				script_map_daily_user_count[i][Playerkey(_tome)] = nil;
			end
		end

		str_ChangeWindow = "4|\\n\\n 			���!���Ǹ�������Ա.\\n	 			������Ҫȥ��!...\\n\\n";
		for i=2,5 do
			local tcount = script_map_daily_user_count[i][Playerkey(_tome)];
			if(tcount == nil)then
				tcount = 1;
			
			else
				tcount = 1 - tcount;
			end
			str_ChangeWindow = str_ChangeWindow .. "<"..script_map_payfor[i].."G>".." "..script_map_name[i].." ʣ��".."<"..tcount..">��".."\\n";

		end
		NLG.ShowWindowTalked(_tome,_me,%����_ѡ���%,%��ť_�ر�%,1,str_ChangeWindow);
	end
	return;
end


function ActivityScriptA(_MeIndex,_PlayerIndex,_seqno,_select,_data)
	if ((_select == 0 or _select == "0") and (_data ~= "")) then
		local selectitem = tonumber(_data)+1;
		

		if (selectitem==nil or (selectitem~=nil and (selectitem > 5 or selectitem <= 0))) then
				NLG.ShowWindowTalked(_PlayerIndex,_MeIndex,%����_��Ϣ��%,%��ť_�ر�%,1,"\\n\\n\\n����ѡ���λ�ò�����!");
				return;
		end

		local getlvlit = script_map_lvlimit[selectitem];
		if(getlvlit > Char.GetData(_PlayerIndex,%����_�ȼ�%))then
			NLG.ShowWindowTalked(_PlayerIndex,_MeIndex,%����_��Ϣ��%,%��ť_�ر�%,1,"\\n\\n\\n���ĵȼ���������Ҫ"..getlvlit.."�ſɽ��롣");
			return;

		end
		local getcountless = script_map_daily_user_count[selectitem][Playerkey(_PlayerIndex)];
		if(getcountless ==nil)then
			getcountless = 0;
			script_map_daily_user_count[selectitem][Playerkey(_PlayerIndex)] = 0;
		end
		
		
		if (getcountless >= 1)then
			NLG.ShowWindowTalked(_PlayerIndex,_MeIndex,%����_��Ϣ��%,%��ť_�ر�%,1,"\\n\\n\\n���Ĵ����Ѿ������ˡ�");
			return;

		end

		if(Char.PartyNum(_PlayerIndex) > 1)then
			NLG.ShowWindowTalked(_PlayerIndex,_MeIndex,%����_��Ϣ��%,%��ť_�ر�%,1,"\\n\\n\\n���ɢ���顣");
			return;
		end

		if(mykgold(_PlayerIndex,script_map_payfor[selectitem]))then
			script_map_daily_user_count[selectitem][Playerkey(_PlayerIndex)] = getcountless + 1;
			Char.DischargeParty(_PlayerIndex)
			Char.Warp(_PlayerIndex,0,script_map_point[selectitem][1],script_map_point[selectitem][2],script_map_point[selectitem][3]);
		else
			NLG.ShowWindowTalked(_PlayerIndex,_MeIndex,%����_��Ϣ��%,%��ť_�ر�%,1,"\\n\\n\\n����ħ�Ҳ�����");
			return;
		end
	end
end


function ActivityScriptB(_MeIndex,_PlayerIndex,_seqno,_select,_data)

end
function ActivityScriptMsgB(_me,_tome)
	if (NLG.CanTalk(_me,_tome) == true) then
		if (Char.ItemNum(_tome,70196) > 0) then
			Char.DelItem(_tome,70196,1);
			local PlayerLevel = tonumber(Char.GetData(_tome,%����_�ȼ�%));
			local PlayerExp = tonumber(Char.GetData(_tome,%����_����%));
			Char.SetData(_tome,%����_����%,PlayerExp+PlayerLevel*PlayerLevel*10);
			NLG.UpChar(_tome);
			NLG.ShowWindowTalked(_tome,_me,%����_��Ϣ��%,%��ť_ȷ��%,1,NLG.c("\\n\\n\\n���ĺã�������õ��ľ���ֵ��"));
		end
		if (Char.ItemNum(_tome,70197) > 0) then
			Char.DelItem(_tome,70197,1);
			local PlayerLevel = tonumber(Char.GetData(_tome,%����_�ȼ�%));
			local PlayerExp = tonumber(Char.GetData(_tome,%����_����%));
			Char.SetData(_tome,%����_����%,PlayerExp+PlayerLevel*PlayerLevel*12);
			NLG.UpChar(_tome);
			NLG.ShowWindowTalked(_tome,_me,%����_��Ϣ��%,%��ť_ȷ��%,1,NLG.c("\\n\\n\\n���ĺã�������õ��ľ���ֵ��"));
		end
		if (Char.ItemNum(_tome,70198) > 0) then
			Char.DelItem(_tome,70198,1);
			local PlayerLevel = tonumber(Char.GetData(_tome,%����_�ȼ�%));
			local PlayerExp = tonumber(Char.GetData(_tome,%����_����%));
			Char.SetData(_tome,%����_����%,PlayerExp+PlayerLevel*PlayerLevel*15);
			NLG.UpChar(_tome);
			NLG.ShowWindowTalked(_tome,_me,%����_��Ϣ��%,%��ť_ȷ��%,1,NLG.c("\\n\\n\\n���ĺã�������õ��ľ���ֵ��"));
		end
		if (Char.ItemNum(_tome,70199) > 0) then
			Char.DelItem(_tome,70199,1);
			local PlayerLevel = tonumber(Char.GetData(_tome,%����_�ȼ�%));
			local PlayerExp = tonumber(Char.GetData(_tome,%����_����%));
			Char.SetData(_tome,%����_����%,PlayerExp+PlayerLevel*PlayerLevel*20);
			NLG.UpChar(_tome);
			NLG.ShowWindowTalked(_tome,_me,%����_��Ϣ��%,%��ť_ȷ��%,1,NLG.c("\\n\\n\\n���ĺã�������õ��ľ���ֵ��"));
		end
		if (Char.ItemNum(_tome,70200) > 0) then
			if(Char.ItemSlot(_tome)>19)then
				NLG.ShowWindowTalked(_tome,_me,%����_��Ϣ��%,%��ť_�ر�%,1,NLG.c("\\n\\n\\n����������1������λ�ã�"));
				return;
			end
			local PlayerFame = Char.GetData(_tome,%����_����%);
			PlayerFame = PlayerFame + 30;
			Char.SetData(_tome,%����_����%,PlayerFame);
			local money = Char.GetData(_tome,%����_���%);
			Char.SetData(_tome,%����_���%,money+500);
			NLG.UpChar(_tome);
			NLG.ShowWindowTalked(_tome,_me,%����_��Ϣ��%,%��ť_�ر�%,1,NLG.c("\\n\\n\\n���պý���Ľ�������"));
		end
		if (Char.ItemNum(_tome,70201) > 0) then
			if(Char.ItemSlot(_tome)>19)then
				NLG.ShowWindowTalked(_tome,_me,%����_��Ϣ��%,%��ť_�ر�%,1,NLG.c("\\n\\n\\n����������1������λ�ã�"));
				return;
			end
			local PlayerFame = Char.GetData(_tome,%����_����%);
			PlayerFame = PlayerFame + 60;
			Char.SetData(_tome,%����_����%,PlayerFame);
			local money = Char.GetData(_tome,%����_���%);
			Char.SetData(_tome,%����_���%,money+1000);
			local KaShi = Char.GetData(_tome,%����_��ʱ%);
			Char.SetData(_tome,%����_��ʱ%,KaShi+900);
			NLG.UpChar(_tome);
			NLG.ShowWindowTalked(_tome,_me,%����_��Ϣ��%,%��ť_�ر�%,1,NLG.c("\\n\\n\\n���պý���Ľ�������"));
		end
		NLG.ShowWindowTalked(_tome,_me,%����_��Ϣ��%,%��ť_�ر�%,1,NLG.c("\\n\\n\\n����������ȡ����ֵ��ϡ�е��߰ɣ�"));
	end
	return;
end
function ActivityScript_LoopEvent(_MeIndex)
	--��������
	local DTime = os.time()
	if DTime - STime >= YS then
		for i = 1,3 do
		local Posn = NLG.Rand(1,#Pos[i])
		local Image = Pos[i][Posn][2]
		local Name = Pos[i][Posn][1]
		local Num = Pos[i][Posn][8]
			if tbl_RandomActivityNpcIndex[Num] == nil then
				local ActivityScriptNpcIndex = CreateActivityNpc(Image, Name, 0, Pos[i][Posn][3], Pos[i][Posn][4], Pos[i][Posn][5], Pos[i][Posn][6])
				tbl_RandomActivityNpcIndex[Num] = ActivityScriptNpcIndex
			end
		end
		if (tbl_RandomActivityNpcIndex[Pos[4][1][1]] == nil and getamountless_5 ~= nil and getamountless_5 >= 90) then
			local ActivityScriptNpcIndex = CreateActivityNpc(Pos[4][1][2], Pos[4][1][1], 0, Pos[4][1][3], Pos[4][1][4], Pos[4][1][5], Pos[4][1][6])
			tbl_RandomActivityNpcIndex[Pos[4][1][1]] = ActivityScriptNpcIndex
		else
		end
		for j = 5,7 do
		local Posn = NLG.Rand(1,#Pos[j])
		local Image = Pos[j][Posn][2]
		local Name = Pos[j][Posn][1]
		local Num = Pos[j][Posn][8]
			if tbl_RandomActivityNpcIndex[Num] == nil then
				local ActivityScriptNpcIndex = CreateActivityNpc(Image, Name, 0, Pos[j][Posn][3], Pos[j][Posn][4], Pos[j][Posn][5], Pos[j][Posn][6])
				tbl_RandomActivityNpcIndex[Num] = ActivityScriptNpcIndex
			end
		end
		if (tbl_RandomActivityNpcIndex[Pos[8][1][1]] == nil and getamountless_4 ~= nil and getamountless_4 >= 35) then
			local ActivityScriptNpcIndex = CreateActivityNpc(Pos[8][1][2], Pos[8][1][1], 0, Pos[8][1][3], Pos[8][1][4], Pos[8][1][5], Pos[8][1][6])
			tbl_RandomActivityNpcIndex[Pos[8][1][1]] = ActivityScriptNpcIndex
		else
		end
		for k = 9,11 do
		local Posn = NLG.Rand(1,#Pos[k])
		local Image = Pos[k][Posn][2]
		local Name = Pos[k][Posn][1]
		local Num = Pos[k][Posn][8]
			if tbl_RandomActivityNpcIndex[Num] == nil then
				local ActivityScriptNpcIndex = CreateActivityNpc(Image, Name, 0, Pos[k][Posn][3], Pos[k][Posn][4], Pos[k][Posn][5], Pos[k][Posn][6])
				tbl_RandomActivityNpcIndex[Num] = ActivityScriptNpcIndex
			end
		end
		if (tbl_RandomActivityNpcIndex[Pos[12][1][1]] == nil and getamountless_3 ~= nil and getamountless_3 >= 20) then
			local ActivityScriptNpcIndex = CreateActivityNpc(Pos[12][1][2], Pos[12][1][1], 0, Pos[12][1][3], Pos[12][1][4], Pos[12][1][5], Pos[12][1][6])
			tbl_RandomActivityNpcIndex[Pos[12][1][1]] = ActivityScriptNpcIndex
		else
		end
		for f = 13,16 do
		local Posn = NLG.Rand(1,#Pos[f])
		local Image = Pos[f][Posn][2]
		local Name = Pos[f][Posn][1]
		local Num = Pos[f][Posn][8]
			if tbl_RandomActivityNpcIndex[Num] == nil then
				local ActivityScriptNpcIndex = CreateActivityNpc(Image, Name, 0, Pos[f][Posn][3], Pos[f][Posn][4], Pos[f][Posn][5], Pos[f][Posn][6])
				tbl_RandomActivityNpcIndex[Num] = ActivityScriptNpcIndex
			end
		end
	end
end
--NPC�Ի��¼�(NPC����)
function ActivityScriptMsgC(_NpcIndex, _PlayerIndex)
tbl_RandomActivityNpcIndex = {}
end

--NPC�����¼�(NPC����)
function ActivityScriptC ( _NpcIndex, _PlayerIndex, _seqno, _select, _data)
	
end
function CreateActivityNpc(Image, Name, MapType, MapID, PosX, PosY, Dir)
	local ActivityScriptNpcIndex = NL.CreateNpc("./lua/System/BaseModule/Base.lua", "Myinit");
	Char.SetData( ActivityScriptNpcIndex, %����_����%, Image);
	Char.SetData( ActivityScriptNpcIndex, %����_ԭ��%, Image);
	Char.SetData( ActivityScriptNpcIndex, %����_��ͼ����%, MapType);
	Char.SetData( ActivityScriptNpcIndex, %����_��ͼ%, MapID);
	Char.SetData( ActivityScriptNpcIndex, %����_X%, PosX);
	Char.SetData( ActivityScriptNpcIndex, %����_Y%, PosY);
	Char.SetData( ActivityScriptNpcIndex, %����_����%, Dir);
	Char.SetData( ActivityScriptNpcIndex, %����_ԭ��%, Name);
	Char.SetData( ActivityScriptNpcIndex, %����_��ɫ%, NameColor);
	tbl_LuaNpcIndex = tbl_LuaNpcIndex or {}
	tbl_LuaNpcIndex["ActivityNpc"] = ActivityScriptNpcIndex
	Char.SetTalkedEvent(nil, "ActivityNpc__Talked", ActivityScriptNpcIndex)
	Char.SetWindowTalkedEvent(nil, "ActivityNpc__WindowTalked", ActivityScriptNpcIndex)
	Char.SetLoopEvent(nil, "ActivityNpc_LoopEvent", ActivityScriptNpcIndex, math.random(1000,5000))
	NLG.UpChar(ActivityScriptNpcIndex)
	return ActivityScriptNpcIndex
end
function ActivityNpc_LoopEvent(_MeIndex)
	local dir = math.random(0, 7);
	local walk = 1;
	NLG.SetAction(_MeIndex,walk);
	NLG.WalkMove(_MeIndex,dir);
	NLG.UpChar(_MeIndex);
end
function ActivityNpc__Talked(_NpcIndex, _PlayerIndex)
	if(NLG.CheckInFront(_PlayerIndex, _NpcIndex, 1)==false and _Mode~=1) then
		return ;
	end
	--�������
	local i;
	i = Char.GetData(_PlayerIndex, %����_����%);
	if i >= 4 then 
		i = i - 4;
	else
		i = i + 4;		
	end
	Char.SetData(_NpcIndex, %����_����%,i);
	NLG.UpChar( _NpcIndex);
	local mz = "��"..Char.GetData(_PlayerIndex,%����_����%).. "��"
	local	token ="\n\n\n\n����ץ��׼������ս������"

       NLG.ShowWindowTalked(_PlayerIndex, _NpcIndex, 0, 1, 1, token)

end
function ActivityNpc__WindowTalked( _NpcIndex, _PlayerIndex, _Seqno, _Select, _Data)
	if _Seqno == 1 then
	local tName = Char.GetData(_NpcIndex, %����_ԭ��%)
	local tImage = Char.GetData(_NpcIndex, %����_����%)
	--����Bossս��
	local tBossLv = 1
--	local tActivityBattleIndex = Battle.PVE( _PlayerIndex, tbl_LuaNpcIndex["ActivityNpc"], nil, tBossList, tLvList, nil)
	--local script_partymember_list = {};
	--script_partymember_list[1] = Char.GetPartyMember( _PlayerIndex,0);
	--script_partymember_list[2] = Char.GetPartyMember( _PlayerIndex,1);
	--script_partymember_list[3] = Char.GetPartyMember( _PlayerIndex,2);
	--script_partymember_list[4] = Char.GetPartyMember( _PlayerIndex,3);
	--script_partymember_list[5] = Char.GetPartyMember( _PlayerIndex,4);
	if(tImage == 104845 or tImage == 104846 or tImage == 104847 or tImage == 104848 or tImage == 104849) then
		local P5 = tImage - 104844;
		local tActivityBattleIndex = Battle.PVE( _PlayerIndex, _NpcIndex, nil, Pos[1][P5][7], Pos[1][P5][9], nil)
		Battle.SetWinEvent( nil, "ActivityNpc_BattleWin", tActivityBattleIndex);
	end
	if(tImage == 104313) then
		local tActivityBattleIndex = Battle.PVE( _PlayerIndex, _NpcIndex, nil, Pos[4][1][7], Pos[4][1][9], nil)
		Battle.SetWinEvent( nil, "ActivityNpc_BattleWin", tActivityBattleIndex);
	end
	if(tImage == 104686 or tImage == 104685) then
		local P4 = tImage - 104684;
		local tActivityBattleIndex = Battle.PVE( _PlayerIndex, _NpcIndex, nil, Pos[5][P4][7], Pos[5][P4][9], nil)
		Battle.SetWinEvent( nil, "ActivityNpc_BattleWin", tActivityBattleIndex);
	end
	if(tImage == 104399 or tImage == 104398) then
		local P4 = tImage - 104395;
		local tActivityBattleIndex = Battle.PVE( _PlayerIndex, _NpcIndex, nil, Pos[5][P4][7], Pos[5][P4][9], nil)
		Battle.SetWinEvent( nil, "ActivityNpc_BattleWin", tActivityBattleIndex);
	end
	if(tImage == 104937) then
		local tActivityBattleIndex = Battle.PVE( _PlayerIndex, _NpcIndex, nil, Pos[8][1][7], Pos[8][1][9], nil)
		Battle.SetWinEvent( nil, "ActivityNpc_BattleWin", tActivityBattleIndex);
	end
	if(tImage == 104759 or tImage == 104760 or tImage == 104761 or tImage == 104762) then
		local P3 = tImage - 104758;
		local tActivityBattleIndex = Battle.PVE( _PlayerIndex, _NpcIndex, nil, Pos[9][P3][7], Pos[9][P3][9], nil)
		Battle.SetWinEvent( nil, "ActivityNpc_BattleWin", tActivityBattleIndex);
	end
	if(tImage == 104758) then
		local tActivityBattleIndex = Battle.PVE( _PlayerIndex, _NpcIndex, nil, Pos[12][1][7], Pos[12][1][9], nil)
		Battle.SetWinEvent( nil, "ActivityNpc_BattleWin", tActivityBattleIndex);
	end
	if(tImage == 104680 or tImage == 104681 or tImage == 104682 or tImage == 104683 or tImage == 104684) then
		local P2 = tImage - 104679;
		local tActivityBattleIndex = Battle.PVE( _PlayerIndex, _NpcIndex, nil, Pos[13][P2][7], Pos[13][P2][9], nil)
		Battle.SetWinEvent( nil, "ActivityNpc_BattleWin", tActivityBattleIndex);
	end
 end
end
function ActivityNpc_BattleWin(_BattleIndex, _NpcIndex)
		local tImage = Char.GetData(_NpcIndex, %����_����%)
		local tPlayerIndex = Battle.GetPlayIndex( _BattleIndex, 0)
		getamountless_2 = script_map_amount[2][Playerkey(tPlayerIndex)];
		getamountless_3 = script_map_amount[3][Playerkey(tPlayerIndex)];
		getamountless_4 = script_map_amount[4][Playerkey(tPlayerIndex)];
		getamountless_5 = script_map_amount[5][Playerkey(tPlayerIndex)];
		if(getamountless_2 ==nil)then
			getamountless_2 = 0;
			script_map_amount[2][Playerkey(tPlayerIndex)] = 0;
		end
		if(getamountless_3 ==nil)then
			getamountless_3 = 0;
			script_map_amount[3][Playerkey(tPlayerIndex)] = 0;
		end
		if(getamountless_4 ==nil)then
			getamountless_4 = 0;
			script_map_amount[4][Playerkey(tPlayerIndex)] = 0;
		end
		if(getamountless_5 ==nil)then
			getamountless_5 = 0;
			script_map_amount[5][Playerkey(tPlayerIndex)] = 0;
		end
		local drop = math.random(1,7);
		if tPlayerIndex>=0 and Char.GetData(tPlayerIndex,%����_����%)==1 then
			if(tImage == 104845 or tImage == 104846 or tImage == 104847 or tImage == 104848 or tImage == 104849) then
				script_map_amount[5][Playerkey(tPlayerIndex)] = getamountless_5 + 10;
				local getamountless_5 = script_map_amount[5][Playerkey(tPlayerIndex)];
				NLG.SystemMessage(tPlayerIndex, "[ϵͳ]������"..Char.GetData(_NpcIndex, %����_ԭ��%).."���10��,�ۻ��ﵽ"..getamountless_5.."��")
				--Char.GiveItem(tPlayerIndex,script_map_drop[5][drop],1);
				for i=0,9 do    Char.GiveItem(Battle.GetPlayIndex( _BattleIndex, i),script_map_drop[5][drop],1);    end
				if (getamountless_5 >= 100)then
					NLG.SystemMessage(tPlayerIndex, "[ϵͳ]�����⵺ð�ա�ݼӢǿ�м������֣�")
				end
			end
			if(tImage == 104313) then
				NLG.SystemMessage(tPlayerIndex, "[ϵͳ]�����⵺ð�ա������Ѿ�������")
				--Char.GiveItem(tPlayerIndex,70199,1);
				for i=0,9 do    Char.GiveItem(Battle.GetPlayIndex( _BattleIndex, i),70199,1);    end
				getamountless_5 = 0;
				script_map_amount[5][Playerkey(tPlayerIndex)] = 0;
				Char.Warp(tPlayerIndex,0,1000,218,84);
			end
			if(tImage == 104686 or tImage == 104685 or tImage == 104399 or tImage == 104398) then
				script_map_amount[4][Playerkey(tPlayerIndex)] = getamountless_4 + 5;
				local getamountless_4 = script_map_amount[4][Playerkey(tPlayerIndex)];
				NLG.SystemMessage(tPlayerIndex, "[ϵͳ]������"..Char.GetData(_NpcIndex, %����_ԭ��%).."���5��,�ۻ��ﵽ"..getamountless_4.."��")
				--Char.GiveItem(tPlayerIndex,script_map_drop[4][drop],1);
				for i=0,9 do    Char.GiveItem(Battle.GetPlayIndex( _BattleIndex, i),script_map_drop[4][drop],1);    end
				if (getamountless_4 >= 40)then
					NLG.SystemMessage(tPlayerIndex, "[ϵͳ]���Ϲϴ������ݼӢǿ�м������֣�")
				end
			end
			if(tImage == 104937) then
				NLG.SystemMessage(tPlayerIndex, "[ϵͳ]���Ϲϴ�����������Ѿ�������")
				--Char.GiveItem(tPlayerIndex,70198,1);
				for i=0,9 do    Char.GiveItem(Battle.GetPlayIndex( _BattleIndex, i),70198,1);    end
				getamountless_4 = 0;
				script_map_amount[4][Playerkey(tPlayerIndex)] = 0;
				Char.Warp(tPlayerIndex,0,1000,218,84);
			end
			if(tImage == 104759 or tImage == 104760 or tImage == 104761 or tImage == 104762) then
				script_map_amount[3][Playerkey(tPlayerIndex)] = getamountless_3 + 5;
				local getamountless_3 = script_map_amount[3][Playerkey(tPlayerIndex)];
				NLG.SystemMessage(tPlayerIndex, "[ϵͳ]������"..Char.GetData(_NpcIndex, %����_ԭ��%).."���5��,�ۻ��ﵽ"..getamountless_3.."��")
				--Char.GiveItem(tPlayerIndex,script_map_drop[3][drop],1);
				for i=0,9 do    Char.GiveItem(Battle.GetPlayIndex( _BattleIndex, i),script_map_drop[3][drop],1);    end
				if (getamountless_3 >= 25)then
					NLG.SystemMessage(tPlayerIndex, "[ϵͳ]������֮���ġ�ݼӢǿ�м������֣�")
				end
			end
			if(tImage == 104758) then
				NLG.SystemMessage(tPlayerIndex, "[ϵͳ]������֮���ġ������Ѿ�������")
				--Char.GiveItem(tPlayerIndex,70197,1);
				for i=0,9 do    Char.GiveItem(Battle.GetPlayIndex( _BattleIndex, i),70197,1);    end
				getamountless_3 = 0;
				script_map_amount[3][Playerkey(tPlayerIndex)] = 0;
				Char.Warp(tPlayerIndex,0,1000,218,84);
			end
			if(tImage == 104680 or tImage == 104681 or tImage == 104682 or tImage == 104683 or tImage == 104684) then
				script_map_amount[2][Playerkey(tPlayerIndex)] = getamountless_2 + 1;
				local getamountless_2 = script_map_amount[2][Playerkey(tPlayerIndex)];
				NLG.SystemMessage(tPlayerIndex, "[ϵͳ]������"..Char.GetData(_NpcIndex, %����_ԭ��%).."���1��,�ۻ��ﵽ"..getamountless_2.."��")
				--Char.GiveItem(tPlayerIndex,script_map_drop[2][drop],1);
				for i=0,9 do    Char.GiveItem(Battle.GetPlayIndex( _BattleIndex, i),script_map_drop[2][drop],1);    end
				if (getamountless_2 >= 100)then
					NLG.SystemMessage(tPlayerIndex, "[ϵͳ]���ɾ�С��ɭ�������Ѿ�������")
					--Char.GiveItem(tPlayerIndex,70196,1);
				for i=0,9 do    Char.GiveItem(Battle.GetPlayIndex( _BattleIndex, i),70196,1);    end
					getamountless_2 = 0;
					script_map_amount[2][Playerkey(tPlayerIndex)] = 0;
					Char.Warp(tPlayerIndex,0,1000,218,84);
				end
			end
			NL.DelNpc(_NpcIndex)
			local kk = table_n(_NpcIndex,0,'v',tbl_RandomActivityNpcIndex)
			tbl_RandomActivityNpcIndex[kk] = nil
		end
	return 1
end

function table_n(c1,c2,n,t)
	for key, value in pairs(t) do
		if c1 == value and n == 'v' then
			return key
		end
	end
end