local script_daily_rewards_user = {};
local script_daily_rewards_user_count = {};
script_daily_rewards_user_count[1] = {};
script_daily_rewards_user_count[2] = {};
local rewards_list = {};
rewards_list[1] = {"�W�ŷ��K(���f)",71019,1};
rewards_list[2] = {"���ܽ��ӱ���",68015,1};
rewards_list[3] = {"���｛�ӱ���",68014,1};
rewards_list[4] = {"���｛�ӱ���",68016,1};
rewards_list[5] = {"���｛�ӱ���",68014,1};
rewards_list[6] = {"���rˮ��(9H)",69999,1};
rewards_list[7] = {"���rˮ��(9H)",69999,1};

Delegate.RegInit("LoginRewards_Init");
Delegate.RegDelLoginEvent("Rewards_LoginEvent");

function initLoginRewardsNpc_Init(index)
	print("���뽱��npc_index = " .. index);
	return 1;
end

function LoginRewards_create() 
	if (RewardsNPC == nil) then
		RewardsNPC = NL.CreateNpc("lua/Module/LoginRewards.lua", "initLoginRewardsNpc_Init");
		Char.SetData(RewardsNPC,%����_����%,106602);
		Char.SetData(RewardsNPC,%����_ԭ��%,106602);
		Char.SetData(RewardsNPC,%����_X%,34);
		Char.SetData(RewardsNPC,%����_Y%,33);
		Char.SetData(RewardsNPC,%����_��ͼ%,777);
		Char.SetData(RewardsNPC,%����_����%,4);
		Char.SetData(RewardsNPC,%����_����%,"���뽱����ʹ");
		NLG.UpChar(RewardsNPC);
		Char.SetTalkedEvent("lua/Module/LoginRewards.lua", "RewardsWindow", RewardsNPC);
		Char.SetWindowTalkedEvent("lua/Module/LoginRewards.lua", "RewardsFunction", RewardsNPC);
	end
end


function Rewards_LoginEvent(_PlayerIndex)
		local _obj = script_daily_rewards_user[Playerkey(_PlayerIndex)];
		--����״ε�¼
		if (_obj == nil) then 
			script_daily_rewards_user[Playerkey(_PlayerIndex)] = os.time();
		end
		if(os.date("%d",_obj) ~= os.date("%d",os.time())) then --�ж�һ������
			script_daily_rewards_user[Playerkey(_PlayerIndex)] = os.time();
			script_daily_rewards_user_count[1][Playerkey(_PlayerIndex)] = nil;
		end
		rewardscount = script_daily_rewards_user_count[1][Playerkey(_PlayerIndex)];
		if(rewardscount ==nil)then
			rewardscount = 0;
			script_daily_rewards_user_count[1][Playerkey(_PlayerIndex)] = 0;
		end
		if (rewardscount >= 1)then
			return;
		end
		if(Char.ItemSlot(_PlayerIndex)>18)then
			NLG.ShowWindowTalked(_PlayerIndex,RewardsNPC,%����_��Ϣ��%,%��ť_�ر�%,1,NLG.c("\\n\\n\\n������������ȡÿ�ս�����"));
			return;
		end
		WindowMsg = "\\n            ������������ȡÿ�ս����������"..
					"\\n\\n��ÿ���������ڼ������������ֶ�Ӧ�Ľ���������ʱ���½�������!\\n"..
					"\\n�X�T�T�T�j�T�T�T�j�T�T�T�j�T�T�T�j�T�T�T�j�T�T�T�j�T�T�T�["..
					"\\n�U��һ���U�������U�������U���ġ��U���塡�U�������U���ա��U"..
					"\\n�d�T�T�T�p�T�T�T�p�T�T�T�p�T�T�T�p�T�T�T�p�T�T�T�p�T�T�T�g"..
					"\\n�U�������U�������U�������U�������U�������U�������U�������U"..
					"\\n�U���١��U���ڡ��U���ۡ��U���ܡ��U���ݡ��U���ޡ��U���ߡ��U"..
					"\\n�U�������U�������U�������U�������U�������U�������U�������U"..
					"\\n�^�T�T�T�m�T�T�T�m�T�T�T�m�T�T�T�m�T�T�T�m�T�T�T�m�T�T�T�a"..
					"\\n���١�����"..rewards_list[1][1].."����"..
					"\\n���ڡ�����"..rewards_list[2][1].."����\\n"..
					"\\n���ۡ�����"..rewards_list[3][1].."����"..
					"\\n���ܡ�����"..rewards_list[4][1].."����\\n"..
					"\\n���ݡ�����"..rewards_list[5][1].."����"..
					"\\n���ޡ�����"..rewards_list[6][1].."����\\n"..
					"\\n���ߡ�����"..rewards_list[7][1].."����"
		NLG.ShowWindowTalked(_PlayerIndex,RewardsNPC, 10, 1, 7, WindowMsg);
	return;
end


function RewardsWindow(_NpcIndex,_PlayerIndex)
	if (NLG.CanTalk(_NpcIndex,_PlayerIndex) == true) then
		local _obj = script_daily_rewards_user[Playerkey(_PlayerIndex)];
		--����״ε�¼
		if (_obj == nil) then 
			script_daily_rewards_user[Playerkey(_PlayerIndex)] = os.time();
		end
		if(os.date("%d",_obj) ~= os.date("%d",os.time())) then --�ж�һ������
			script_daily_rewards_user[Playerkey(_PlayerIndex)] = os.time();
			script_daily_rewards_user_count[1][Playerkey(_PlayerIndex)] = nil;
		end
		rewardscount = script_daily_rewards_user_count[1][Playerkey(_PlayerIndex)];
		if(rewardscount ==nil)then
			rewardscount = 0;
			script_daily_rewards_user_count[1][Playerkey(_PlayerIndex)] = 0;
		end
		if (rewardscount >= 1)then
			return;
		end
		if(Char.ItemSlot(_PlayerIndex)>18)then
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,NLG.c("\\n\\n\\n������������ȡÿ�ս�����"));
			return;
		end
		WindowMsg = "\\n            ������������ȡÿ�ս����������"..
					"\\n\\n��ÿ���������ڼ������������ֶ�Ӧ�Ľ���������ʱ���½�������!\\n"..
					"\\n�X�T�T�T�j�T�T�T�j�T�T�T�j�T�T�T�j�T�T�T�j�T�T�T�j�T�T�T�["..
					"\\n�U��һ���U�������U�������U���ġ��U���塡�U�������U���ա��U"..
					"\\n�d�T�T�T�p�T�T�T�p�T�T�T�p�T�T�T�p�T�T�T�p�T�T�T�p�T�T�T�g"..
					"\\n�U�������U�������U�������U�������U�������U�������U�������U"..
					"\\n�U���١��U���ڡ��U���ۡ��U���ܡ��U���ݡ��U���ޡ��U���ߡ��U"..
					"\\n�U�������U�������U�������U�������U�������U�������U�������U"..
					"\\n�^�T�T�T�m�T�T�T�m�T�T�T�m�T�T�T�m�T�T�T�m�T�T�T�m�T�T�T�a"..
					"\\n���١�����"..rewards_list[1][1].."����"..
					"\\n���ڡ�����"..rewards_list[2][1].."����\\n"..
					"\\n���ۡ�����"..rewards_list[3][1].."����"..
					"\\n���ܡ�����"..rewards_list[4][1].."����\\n"..
					"\\n���ݡ�����"..rewards_list[5][1].."����"..
					"\\n���ޡ�����"..rewards_list[6][1].."����\\n"..
					"\\n���ߡ�����"..rewards_list[7][1].."����"
		NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex, 10, 1, 7, WindowMsg);
	end
	return;
end

function RewardsFunction(_NpcIndex,_PlayerIndex,_SqeNo,_select,_data)
	if (_select == 1) then
		script_daily_rewards_user_count[1][Playerkey(_PlayerIndex)] = rewardscount + 1;
		if(os.date("%w",os.time()) =="0")then Char.GiveItem(_PlayerIndex,rewards_list[7][2],rewards_list[7][3]) end
		if(os.date("%w",os.time()) =="1")then Char.GiveItem(_PlayerIndex,rewards_list[1][2],rewards_list[1][3]) end
		if(os.date("%w",os.time()) =="2")then Char.GiveItem(_PlayerIndex,rewards_list[2][2],rewards_list[2][3]) end
		if(os.date("%w",os.time()) =="3")then Char.GiveItem(_PlayerIndex,rewards_list[3][2],rewards_list[3][3]) end
		if(os.date("%w",os.time()) =="4")then Char.GiveItem(_PlayerIndex,rewards_list[4][2],rewards_list[4][3]) end
		if(os.date("%w",os.time()) =="5")then Char.GiveItem(_PlayerIndex,rewards_list[5][2],rewards_list[5][3]) end
		if(os.date("%w",os.time()) =="6")then Char.GiveItem(_PlayerIndex,rewards_list[6][2],rewards_list[6][3]) end
		--NLG.SystemMessage(_PlayerIndex,"���Ѿ���ȡ���ս�����");
	end
end

function LoginRewards_Init()
	LoginRewards_create();
	return 0;
end