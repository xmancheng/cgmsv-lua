local script_daily_rewards_user = {};
local script_daily_rewards_user_count = {};
script_daily_rewards_user_count[1] = {};
script_daily_rewards_user_count[2] = {};
local rewards_list = {};
rewards_list[1] = {"閃炫方塊(傳說)",71019,1};
rewards_list[2] = {"技能經驗加倍包",68015,1};
rewards_list[3] = {"人物經驗加倍包",68014,1};
rewards_list[4] = {"寵物經驗加倍包",68016,1};
rewards_list[5] = {"人物經驗加倍包",68014,1};
rewards_list[6] = {"卡時水晶(9H)",69999,1};
rewards_list[7] = {"卡時水晶(9H)",69999,1};

Delegate.RegInit("LoginRewards_Init");
Delegate.RegDelLoginEvent("Rewards_LoginEvent");

function initLoginRewardsNpc_Init(index)
	print("登入奖励npc_index = " .. index);
	return 1;
end

function LoginRewards_create() 
	if (RewardsNPC == nil) then
		RewardsNPC = NL.CreateNpc("lua/Module/LoginRewards.lua", "initLoginRewardsNpc_Init");
		Char.SetData(RewardsNPC,%对象_形象%,106602);
		Char.SetData(RewardsNPC,%对象_原形%,106602);
		Char.SetData(RewardsNPC,%对象_X%,34);
		Char.SetData(RewardsNPC,%对象_Y%,33);
		Char.SetData(RewardsNPC,%对象_地图%,777);
		Char.SetData(RewardsNPC,%对象_方向%,4);
		Char.SetData(RewardsNPC,%对象_名字%,"登入奖励大使");
		NLG.UpChar(RewardsNPC);
		Char.SetTalkedEvent("lua/Module/LoginRewards.lua", "RewardsWindow", RewardsNPC);
		Char.SetWindowTalkedEvent("lua/Module/LoginRewards.lua", "RewardsFunction", RewardsNPC);
	end
end


function Rewards_LoginEvent(_PlayerIndex)
		local _obj = script_daily_rewards_user[Playerkey(_PlayerIndex)];
		--如果首次登录
		if (_obj == nil) then 
			script_daily_rewards_user[Playerkey(_PlayerIndex)] = os.time();
		end
		if(os.date("%d",_obj) ~= os.date("%d",os.time())) then --判定一天重置
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
			NLG.ShowWindowTalked(_PlayerIndex,RewardsNPC,%窗口_信息框%,%按钮_关闭%,1,NLG.c("\\n\\n\\n請留出背包領取每日獎勵！"));
			return;
		end
		WindowMsg = "\\n            ★★★★★★登入領取每日獎勵★★★★★★"..
					"\\n\\n　每週依據星期幾給予下面數字對應的獎勵，不定時更新獎勵內容!\\n"..
					"\\n╔═══╦═══╦═══╦═══╦═══╦═══╦═══╗"..
					"\\n║　一　║　二　║　三　║　四　║　五　║　六　║　日　║"..
					"\\n╠═══╬═══╬═══╬═══╬═══╬═══╬═══╣"..
					"\\n║　　　║　　　║　　　║　　　║　　　║　　　║　　　║"..
					"\\n║　①　║　②　║　③　║　④　║　⑤　║　⑥　║　⑦　║"..
					"\\n║　　　║　　　║　　　║　　　║　　　║　　　║　　　║"..
					"\\n╚═══╩═══╩═══╩═══╩═══╩═══╩═══╝"..
					"\\n　①　【　"..rewards_list[1][1].."　】"..
					"\\n　②　【　"..rewards_list[2][1].."　】\\n"..
					"\\n　③　【　"..rewards_list[3][1].."　】"..
					"\\n　④　【　"..rewards_list[4][1].."　】\\n"..
					"\\n　⑤　【　"..rewards_list[5][1].."　】"..
					"\\n　⑥　【　"..rewards_list[6][1].."　】\\n"..
					"\\n　⑦　【　"..rewards_list[7][1].."　】"
		NLG.ShowWindowTalked(_PlayerIndex,RewardsNPC, 10, 1, 7, WindowMsg);
	return;
end


function RewardsWindow(_NpcIndex,_PlayerIndex)
	if (NLG.CanTalk(_NpcIndex,_PlayerIndex) == true) then
		local _obj = script_daily_rewards_user[Playerkey(_PlayerIndex)];
		--如果首次登录
		if (_obj == nil) then 
			script_daily_rewards_user[Playerkey(_PlayerIndex)] = os.time();
		end
		if(os.date("%d",_obj) ~= os.date("%d",os.time())) then --判定一天重置
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
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,NLG.c("\\n\\n\\n請留出背包領取每日獎勵！"));
			return;
		end
		WindowMsg = "\\n            ★★★★★★登入領取每日獎勵★★★★★★"..
					"\\n\\n　每週依據星期幾給予下面數字對應的獎勵，不定時更新獎勵內容!\\n"..
					"\\n╔═══╦═══╦═══╦═══╦═══╦═══╦═══╗"..
					"\\n║　一　║　二　║　三　║　四　║　五　║　六　║　日　║"..
					"\\n╠═══╬═══╬═══╬═══╬═══╬═══╬═══╣"..
					"\\n║　　　║　　　║　　　║　　　║　　　║　　　║　　　║"..
					"\\n║　①　║　②　║　③　║　④　║　⑤　║　⑥　║　⑦　║"..
					"\\n║　　　║　　　║　　　║　　　║　　　║　　　║　　　║"..
					"\\n╚═══╩═══╩═══╩═══╩═══╩═══╩═══╝"..
					"\\n　①　【　"..rewards_list[1][1].."　】"..
					"\\n　②　【　"..rewards_list[2][1].."　】\\n"..
					"\\n　③　【　"..rewards_list[3][1].."　】"..
					"\\n　④　【　"..rewards_list[4][1].."　】\\n"..
					"\\n　⑤　【　"..rewards_list[5][1].."　】"..
					"\\n　⑥　【　"..rewards_list[6][1].."　】\\n"..
					"\\n　⑦　【　"..rewards_list[7][1].."　】"
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
		--NLG.SystemMessage(_PlayerIndex,"你已經領取本日獎勵。");
	end
end

function LoginRewards_Init()
	LoginRewards_create();
	return 0;
end
