local EnemySet = {}
local BaseLevelSet = {}
local Pos = {}
local STime = os.time()
local YS = 600 --脚本延时多少秒创建NPC
local SXTime = 60 --NPC刷新时间·秒
--队列解释
--     五	三	一	二	四
--     十	八	六	七	九
------------蛋糕岛冒险随机NPC设置------------
EnemySet[1] = {0, 406135, 406135, 0, 0, 0, 0, 0, 406135, 406135}--0代表没有怪
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
Pos[1] = {{"可可蛋糕怪",104845,38301,70,40,4,EnemySet[1],1,BaseLevelSet[1]},{"芋泥蛋糕怪",104846,38301,75,50,0,EnemySet[2],2,BaseLevelSet[2]},{"薄荷蛋糕怪",104847,38301,65,45,2,EnemySet[3],3,BaseLevelSet[3]},{"奶油蛋糕怪",104848,38301,45,52,1,EnemySet[4],4,BaseLevelSet[4]},{"抹茶蛋糕怪",104849,38301,93,55,5,EnemySet[5],5,BaseLevelSet[5]}}
Pos[2] = {{"可可蛋糕怪",104845,38301,77,62,4,EnemySet[1],6,BaseLevelSet[1]},{"芋泥蛋糕怪",104846,38301,54,59,0,EnemySet[2],7,BaseLevelSet[2]},{"薄荷蛋糕怪",104847,38301,53,74,2,EnemySet[3],8,BaseLevelSet[3]},{"奶油蛋糕怪",104848,38301,73,72,1,EnemySet[4],9,BaseLevelSet[4]},{"抹茶蛋糕怪",104849,38301,91,81,5,EnemySet[5],10,BaseLevelSet[5]}}
Pos[3] = {{"可可蛋糕怪",104845,38301,61,99,4,EnemySet[1],11,BaseLevelSet[1]},{"芋泥蛋糕怪",104846,38301,84,98,0,EnemySet[2],12,BaseLevelSet[2]},{"薄荷蛋糕怪",104847,38301,70,82,2,EnemySet[3],13,BaseLevelSet[3]},{"奶油蛋糕怪",104848,38301,78,113,1,EnemySet[4],14,BaseLevelSet[4]},{"抹茶蛋糕怪",104849,38301,92,68,5,EnemySet[5],15,BaseLevelSet[5]}}
Pos[4] = {{"BIG·MOM",104313,38301,49,34,4,EnemySet[6],60,BaseLevelSet[6]}}

------------南瓜大进击随机NPC设置------------
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
Pos[5] = {{"柳橙南瓜燈",104685,38190,70,134,0,EnemySet[7],16,BaseLevelSet[7]},{"暗紅南瓜燈",104686,38190,71,115,4,EnemySet[8],17,BaseLevelSet[8]},{"亮黃南瓜燈",104398,38190,86,111,1,EnemySet[9],18,BaseLevelSet[9]},{"深綠南瓜燈",104399,38190,101,115,2,EnemySet[10],19,BaseLevelSet[10]}}
Pos[6] = {{"柳橙南瓜燈",104685,38190,85,91,0,EnemySet[7],20,BaseLevelSet[7]},{"暗紅南瓜燈",104686,38190,69,99,4,EnemySet[8],21,BaseLevelSet[8]},{"亮黃南瓜燈",104398,38190,100,86,1,EnemySet[9],22,BaseLevelSet[9]},{"深綠南瓜燈",104399,38190,83,72,2,EnemySet[10],23,BaseLevelSet[10]}}
Pos[7] = {{"柳橙南瓜燈",104685,38190,117,105,0,EnemySet[7],24,BaseLevelSet[7]},{"暗紅南瓜燈",104686,38190,103,100,4,EnemySet[8],25,BaseLevelSet[8]},{"亮黃南瓜燈",104398,38190,121,113,1,EnemySet[9],26,BaseLevelSet[9]},{"深綠南瓜燈",104399,38190,103,130,2,EnemySet[10],27,BaseLevelSet[10]}}
Pos[8] = {{"巨大萬聖南瓜",104937,38190,114,81,6,EnemySet[11],61,BaseLevelSet[11]}}

------------悠闲之粽夏随机NPC设置------------
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
Pos[9] = {{"果酸粽小子",104759,38304,51,76,0,EnemySet[12],28,BaseLevelSet[12]},{"麻辣粽小子",104760,38304,34,61,4,EnemySet[13],29,BaseLevelSet[13]},{"藥苦粽小子",104761,38304,64,81,1,EnemySet[14],30,BaseLevelSet[14]},{"瓜甜粽小子",104762,38304,78,75,2,EnemySet[15],31,BaseLevelSet[15]}}
Pos[10] = {{"果酸粽小子",104759,38304,66,96,0,EnemySet[12],32,BaseLevelSet[12]},{"麻辣粽小子",104760,38304,78,99,4,EnemySet[13],33,BaseLevelSet[13]},{"藥苦粽小子",104761,38304,93,88,1,EnemySet[14],34,BaseLevelSet[14]},{"瓜甜粽小子",104762,38304,87,70,2,EnemySet[15],35,BaseLevelSet[15]}}
Pos[11] = {{"果酸粽小子",104759,38304,71,49,0,EnemySet[12],36,BaseLevelSet[12]},{"麻辣粽小子",104760,38304,54,49,4,EnemySet[13],37,BaseLevelSet[13]},{"藥苦粽小子",104761,38304,70,32,1,EnemySet[14],38,BaseLevelSet[14]},{"瓜甜粽小子",104762,38304,57,32,2,EnemySet[15],39,BaseLevelSet[15]}}
Pos[12] = {{"端午划龍舟",104758,38304,67,67,5,EnemySet[16],62,BaseLevelSet[16]}}

------------仙境小妖森随机NPC设置------------
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
Pos[13] = {{"綠葉靈",104680,38191,97,114,0,EnemySet[17],40,BaseLevelSet[17]},{"紅葉靈",104681,38191,103,147,4,EnemySet[18],41,BaseLevelSet[18]},{"魔葉靈",104682,38191,102,154,1,EnemySet[19],42,BaseLevelSet[19]},{"藍葉靈",104683,38191,91,157,2,EnemySet[20],43,BaseLevelSet[20]},{"黃葉靈",104684,38191,93,147,5,EnemySet[21],44,BaseLevelSet[21]}}
Pos[14] = {{"綠葉靈",104680,38191,67,113,0,EnemySet[17],45,BaseLevelSet[17]},{"紅葉靈",104681,38191,71,117,4,EnemySet[18],46,BaseLevelSet[18]},{"魔葉靈",104682,38191,57,120,1,EnemySet[19],47,BaseLevelSet[19]},{"藍葉靈",104683,38191,69,128,2,EnemySet[20],48,BaseLevelSet[20]},{"黃葉靈",104684,38191,63,133,5,EnemySet[21],49,BaseLevelSet[21]}}
Pos[15] = {{"綠葉靈",104680,38191,104,76,0,EnemySet[17],50,BaseLevelSet[17]},{"紅葉靈",104681,38191,107,82,4,EnemySet[18],51,BaseLevelSet[18]},{"魔葉靈",104682,38191,104,90,1,EnemySet[19],52,BaseLevelSet[19]},{"藍葉靈",104683,38191,95,83,2,EnemySet[20],53,BaseLevelSet[20]},{"黃葉靈",104684,38191,106,98,5,EnemySet[21],54,BaseLevelSet[21]}}
Pos[16] = {{"綠葉靈",104680,38191,127,89,0,EnemySet[17],55,BaseLevelSet[17]},{"紅葉靈",104681,38191,131,98,4,EnemySet[18],56,BaseLevelSet[18]},{"魔葉靈",104682,38191,131,106,1,EnemySet[19],57,BaseLevelSet[19]},{"藍葉靈",104683,38191,127,116,2,EnemySet[20],58,BaseLevelSet[20]},{"黃葉靈",104684,38191,118,106,5,EnemySet[21],59,BaseLevelSet[21]}}

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

script_map_name[2] = "《仙境小妖森》";
script_map_point[2] = {38191,107,65};
script_map_lvlimit[2] = 30;
script_map_payfor[2] = 2000;
script_map_drop[2] = {70200,70200,70200,70201,70202,70202,70202};

script_map_name[3] = "《悠閒之粽夏》";
script_map_point[3] = {38304,64,24};
script_map_lvlimit[3] = 50;
script_map_payfor[3] = 2000;
script_map_drop[3] = {70200,70200,70200,70201,70203,70203,70203};

script_map_name[4] = "《南瓜大進擊》";
script_map_point[4] = {38190,67,118};
script_map_lvlimit[4] = 70;
script_map_payfor[4] = 2000;
script_map_drop[4] = {70200,70201,70201,70204,70204,70204,70204};

script_map_name[5] = "《蛋糕島冒險》";
script_map_point[5] = {38301,67,37};
script_map_lvlimit[5] = 90;
script_map_payfor[5] = 2000;
script_map_drop[5] = {70200,70201,70201,70205,70205,70205,70205};

Delegate.RegInit("initActivityScriptNpc");

function initActivityScriptNpc_Init(index)
	return 1;
end

function mykgold(_PlayerIndex,gold)
	local tjb = Char.GetData(_PlayerIndex,%对象_金币%);
	tjb = tjb - gold; 
	if(tjb >= 0)then
		Char.SetData(_PlayerIndex,%对象_金币%,tjb);
		NLG.UpChar(_PlayerIndex);
		NLG.SystemMessage(_PlayerIndex,"交出了"..gold.." G魔幣。");
		return true;
	end
	return false;
end

function initActivityScriptNpc()
	if (ActivityScriptNps == nil) then
		ActivityScriptNps = NL.CreateNpc("lua/Module/ActivityScript.lua", "initActivityScriptNpc_Init");
		Char.SetData(ActivityScriptNps,%对象_形象%,260069);
		Char.SetData(ActivityScriptNps,%对象_原形%,260069);
		Char.SetData(ActivityScriptNps,%对象_X%,219);
		Char.SetData(ActivityScriptNps,%对象_Y%,84);
		Char.SetData(ActivityScriptNps,%对象_地图%,1000);
		Char.SetData(ActivityScriptNps,%对象_方向%,6);
		Char.SetData(ActivityScriptNps,%对象_原名%,"每日活動副本");
		NLG.UpChar(ActivityScriptNps);
		Char.SetWindowTalkedEvent("lua/Module/ActivityScript.lua","ActivityScriptA",ActivityScriptNps);
		Char.SetTalkedEvent("lua/Module/ActivityScript.lua","ActivityScriptMsg", ActivityScriptNps);
	end
	if (ActivityScriptNpsB == nil) then
		ActivityScriptNpsB = NL.CreateNpc("lua/Module/ActivityScript.lua", "initActivityScriptNpc_Init");
		Char.SetData(ActivityScriptNpsB,%对象_形象%,231119);
		Char.SetData(ActivityScriptNpsB,%对象_原形%,231119);
		Char.SetData(ActivityScriptNpsB,%对象_X%,218);
		Char.SetData(ActivityScriptNpsB,%对象_Y%,83);
		Char.SetData(ActivityScriptNpsB,%对象_地图%,1000);
		Char.SetData(ActivityScriptNpsB,%对象_方向%,6);
		Char.SetData(ActivityScriptNpsB,%对象_原名%,"獎勵發放員");
		NLG.UpChar(ActivityScriptNpsB);
		Char.SetWindowTalkedEvent("lua/Module/ActivityScript.lua","ActivityScriptB",ActivityScriptNpsB);
		Char.SetTalkedEvent("lua/Module/ActivityScript.lua","ActivityScriptMsgB", ActivityScriptNpsB);
	end
	if (ActivityScriptNpsC == nil) then
		ActivityScriptNpsC = NL.CreateNpc("lua/Module/ActivityScript.lua", "initActivityScriptNpc_Init");
		Char.SetData(ActivityScriptNpsC,%对象_形象%,231116);
		Char.SetData(ActivityScriptNpsC,%对象_原形%,231116);
		Char.SetData(ActivityScriptNpsC,%对象_X%,16);
		Char.SetData(ActivityScriptNpsC,%对象_Y%,16);
		Char.SetData(ActivityScriptNpsC,%对象_地图%,777);
		Char.SetData(ActivityScriptNpsC,%对象_方向%,6);
		Char.SetData(ActivityScriptNpsC,%对象_原名%,"明怪設置");
		NLG.UpChar(ActivityScriptNpsC);
		Char.SetLoopEvent(nil, "ActivityScript_LoopEvent",ActivityScriptNpsC, SXTime*1000)
		Char.SetWindowTalkedEvent("lua/Module/ActivityScript.lua","ActivityScriptC",ActivityScriptNpsC);
		Char.SetTalkedEvent("lua/Module/ActivityScript.lua","ActivityScriptMsgC", ActivityScriptNpsC);
	end
end

function ActivityScriptMsgA(_me,_tome)
	if (NLG.CanTalk(_me,_tome) == true) then
		local PlayerLevel = tonumber(Char.GetData(_tome,%对象_等级%));
		
		if (PlayerLevel < 20) then
			NLG.ShowWindowTalked(_tome,_me,%窗口_信息框%,%按钮_确定%,1,NLG.c("\\n\\n\\n先到達20級再來吧！"));
			return;
		end

		if(Time_Out(_tome))then
			script_map_daily_user[Playerkey(_tome)] = os.time();
			for i=1,6 do
				script_map_daily_user_count[i][Playerkey(_tome)] = nil;
			end
		end

		if (script_map_daily_user_count[1][Playerkey(_tome)] == 1) then
			NLG.ShowWindowTalked(_tome,_me,%窗口_信息框%,%按钮_确定%,1,NLG.c("\\n\\n\\n明天再來吧！"));
			return;
		end
		script_map_daily_user_count[1][Playerkey(_tome)] = 1;
		NLG.ShowWindowTalked(_tome,_me,%窗口_信息框%,%按钮_确定%,1,NLG.c("\\n\\n\\n你願意參加活動副本得到經驗值和稀有道具嗎？"));
	end
	return;
end



function ActivityScriptMsg(_me,_tome)
	if (NLG.CanTalk(_me,_tome) == true) then
		local _obj = script_map_daily_user[Playerkey(_tome)];
		--如果首次登录
		if (_obj == nil) then 
			script_map_daily_user[Playerkey(_tome)] = os.time();
		end
		if (os.date("%P",_obj) ~= os.date("%P",os.time())) then --判定上、下午重置
			script_map_daily_user[Playerkey(_tome)] = os.time();
			for i=1,6 do
				script_map_daily_user_count[i][Playerkey(_tome)] = nil;
			end
		end

		str_ChangeWindow = "4|\\n\\n 			你好!我是副本管理員.\\n	 			請問你要去哪!...\\n\\n";
		for i=2,5 do
			local tcount = script_map_daily_user_count[i][Playerkey(_tome)];
			if(tcount == nil)then
				tcount = 1;
			
			else
				tcount = 1 - tcount;
			end
			str_ChangeWindow = str_ChangeWindow .. "<"..script_map_payfor[i].."G>".." "..script_map_name[i].." 剩餘".."<"..tcount..">次".."\\n";

		end
		NLG.ShowWindowTalked(_tome,_me,%窗口_选择框%,%按钮_关闭%,1,str_ChangeWindow);
	end
	return;
end


function ActivityScriptA(_MeIndex,_PlayerIndex,_seqno,_select,_data)
	if ((_select == 0 or _select == "0") and (_data ~= "")) then
		local selectitem = tonumber(_data)+1;
		

		if (selectitem==nil or (selectitem~=nil and (selectitem > 5 or selectitem <= 0))) then
				--NLG.ShowWindowTalked(_PlayerIndex,_MeIndex,%窗口_信息框%,%按钮_关闭%,1,"\\n\\n\\n您所选择的位置不正常!");
				return;
		end

		local getlvlit = script_map_lvlimit[selectitem];
		if(getlvlit > Char.GetData(_PlayerIndex,%对象_等级%))then
			NLG.ShowWindowTalked(_PlayerIndex,_MeIndex,%窗口_信息框%,%按钮_关闭%,1,"\\n\\n\\n您的等級不夠，需要"..getlvlit.."才可進入。");
			return;

		end
		local getcountless = script_map_daily_user_count[selectitem][Playerkey(_PlayerIndex)];
		if(getcountless ==nil)then
			getcountless = 0;
			script_map_daily_user_count[selectitem][Playerkey(_PlayerIndex)] = 0;
		end
		
		
		if (getcountless >= 1)then
			NLG.ShowWindowTalked(_PlayerIndex,_MeIndex,%窗口_信息框%,%按钮_关闭%,1,"\\n\\n\\n您的次數已經用完了。");
			return;

		end

		if(Char.PartyNum(_PlayerIndex) > 1)then
			NLG.ShowWindowTalked(_PlayerIndex,_MeIndex,%窗口_信息框%,%按钮_关闭%,1,"\\n\\n\\n請解散隊伍。");
			return;
		end

		if(mykgold(_PlayerIndex,script_map_payfor[selectitem]))then
			script_map_daily_user_count[selectitem][Playerkey(_PlayerIndex)] = getcountless + 1;
			Char.DischargeParty(_PlayerIndex)
			Char.Warp(_PlayerIndex,0,script_map_point[selectitem][1],script_map_point[selectitem][2],script_map_point[selectitem][3]);
		else
			NLG.ShowWindowTalked(_PlayerIndex,_MeIndex,%窗口_信息框%,%按钮_关闭%,1,"\\n\\n\\n您的魔幣不夠。");
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
			local PlayerLevel = tonumber(Char.GetData(_tome,%对象_等级%));
			local PlayerExp = tonumber(Char.GetData(_tome,%对象_经验%));
			Char.SetData(_tome,%对象_经验%,PlayerExp+PlayerLevel*PlayerLevel*10);
			NLG.UpChar(_tome);
			NLG.ShowWindowTalked(_tome,_me,%窗口_信息框%,%按钮_确定%,1,NLG.c("\\n\\n\\n做的好，這是你得到的經驗值！"));
		end
		if (Char.ItemNum(_tome,70197) > 0) then
			Char.DelItem(_tome,70197,1);
			local PlayerLevel = tonumber(Char.GetData(_tome,%对象_等级%));
			local PlayerExp = tonumber(Char.GetData(_tome,%对象_经验%));
			Char.SetData(_tome,%对象_经验%,PlayerExp+PlayerLevel*PlayerLevel*12);
			NLG.UpChar(_tome);
			NLG.ShowWindowTalked(_tome,_me,%窗口_信息框%,%按钮_确定%,1,NLG.c("\\n\\n\\n做的好，這是你得到的經驗值！"));
		end
		if (Char.ItemNum(_tome,70198) > 0) then
			Char.DelItem(_tome,70198,1);
			local PlayerLevel = tonumber(Char.GetData(_tome,%对象_等级%));
			local PlayerExp = tonumber(Char.GetData(_tome,%对象_经验%));
			Char.SetData(_tome,%对象_经验%,PlayerExp+PlayerLevel*PlayerLevel*15);
			NLG.UpChar(_tome);
			NLG.ShowWindowTalked(_tome,_me,%窗口_信息框%,%按钮_确定%,1,NLG.c("\\n\\n\\n做的好，這是你得到的經驗值！"));
		end
		if (Char.ItemNum(_tome,70199) > 0) then
			Char.DelItem(_tome,70199,1);
			local PlayerLevel = tonumber(Char.GetData(_tome,%对象_等级%));
			local PlayerExp = tonumber(Char.GetData(_tome,%对象_经验%));
			Char.SetData(_tome,%对象_经验%,PlayerExp+PlayerLevel*PlayerLevel*20);
			NLG.UpChar(_tome);
			NLG.ShowWindowTalked(_tome,_me,%窗口_信息框%,%按钮_确定%,1,NLG.c("\\n\\n\\n做的好，這是你得到的經驗值！"));
		end
		if (Char.ItemNum(_tome,70200) > 0) then
			if(Char.ItemSlot(_tome)>19)then
				NLG.ShowWindowTalked(_tome,_me,%窗口_信息框%,%按钮_关闭%,1,NLG.c("\\n\\n\\n請至少留出1個背包位置！"));
				return;
			end
			local PlayerFame = Char.GetData(_tome,%对象_声望%);
			PlayerFame = PlayerFame + 30;
			Char.SetData(_tome,%对象_声望%,PlayerFame);
			local money = Char.GetData(_tome,%对象_金币%);
			Char.SetData(_tome,%对象_金币%,money+500);
			NLG.UpChar(_tome);
			NLG.ShowWindowTalked(_tome,_me,%窗口_信息框%,%按钮_关闭%,1,NLG.c("\\n\\n\\n請收好今天的獎勵！！"));
		end
		if (Char.ItemNum(_tome,70201) > 0) then
			if(Char.ItemSlot(_tome)>19)then
				NLG.ShowWindowTalked(_tome,_me,%窗口_信息框%,%按钮_关闭%,1,NLG.c("\\n\\n\\n請至少留出1個背包位置！"));
				return;
			end
			local PlayerFame = Char.GetData(_tome,%对象_声望%);
			PlayerFame = PlayerFame + 60;
			Char.SetData(_tome,%对象_声望%,PlayerFame);
			local money = Char.GetData(_tome,%对象_金币%);
			Char.SetData(_tome,%对象_金币%,money+1000);
			local KaShi = Char.GetData(_tome,%对象_卡时%);
			Char.SetData(_tome,%对象_卡时%,KaShi+900);
			NLG.UpChar(_tome);
			NLG.ShowWindowTalked(_tome,_me,%窗口_信息框%,%按钮_关闭%,1,NLG.c("\\n\\n\\n請收好今天的獎勵！！"));
		end
		NLG.ShowWindowTalked(_tome,_me,%窗口_信息框%,%按钮_关闭%,1,NLG.c("\\n\\n\\n明天再來領取經驗值和稀有道具吧！"));
	end
	return;
end
function ActivityScript_LoopEvent(_MeIndex)
	--创建假人
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
--NPC对话事件(NPC索引)
function ActivityScriptMsgC(_NpcIndex, _PlayerIndex)
tbl_RandomActivityNpcIndex = {}
end

--NPC窗口事件(NPC索引)
function ActivityScriptC ( _NpcIndex, _PlayerIndex, _seqno, _select, _data)
	
end
function CreateActivityNpc(Image, Name, MapType, MapID, PosX, PosY, Dir)
	local ActivityScriptNpcIndex = NL.CreateNpc("./lua/System/BaseModule/Base.lua", "Myinit");
	Char.SetData( ActivityScriptNpcIndex, %对象_形象%, Image);
	Char.SetData( ActivityScriptNpcIndex, %对象_原形%, Image);
	Char.SetData( ActivityScriptNpcIndex, %对象_地图类型%, MapType);
	Char.SetData( ActivityScriptNpcIndex, %对象_地图%, MapID);
	Char.SetData( ActivityScriptNpcIndex, %对象_X%, PosX);
	Char.SetData( ActivityScriptNpcIndex, %对象_Y%, PosY);
	Char.SetData( ActivityScriptNpcIndex, %对象_方向%, Dir);
	Char.SetData( ActivityScriptNpcIndex, %对象_原名%, Name);
	Char.SetData( ActivityScriptNpcIndex, %对象_名色%, NameColor);
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
	--面向玩家
	local i;
	i = Char.GetData(_PlayerIndex, %对象_方向%);
	if i >= 4 then 
		i = i - 4;
	else
		i = i + 4;		
	end
	Char.SetData(_NpcIndex, %对象_方向%,i);
	NLG.UpChar( _NpcIndex);
	local mz = "『"..Char.GetData(_PlayerIndex,%对象_名字%).. "』"
	local	token ="\n\n\n\n它被抓到準備進入戰鬥！？"

       NLG.ShowWindowTalked(_PlayerIndex, _NpcIndex, 0, 1, 1, token)

end
function ActivityNpc__WindowTalked( _NpcIndex, _PlayerIndex, _Seqno, _Select, _Data)
	if _Seqno == 1 then
	local tName = Char.GetData(_NpcIndex, %对象_原名%)
	local tImage = Char.GetData(_NpcIndex, %对象_形象%)
	--创建Boss战斗
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
		Battle.SetWinEvent("./lua/Module/ActivityScript.lua", "ActivityNpc_BattleWin", tActivityBattleIndex);
	end
	if(tImage == 104313) then
		local tActivityBattleIndex = Battle.PVE( _PlayerIndex, _NpcIndex, nil, Pos[4][1][7], Pos[4][1][9], nil)
		Battle.SetWinEvent("./lua/Module/ActivityScript.lua", "ActivityNpc_BattleWin", tActivityBattleIndex);
	end
	if(tImage == 104686 or tImage == 104685) then
		local P4 = tImage - 104684;
		local tActivityBattleIndex = Battle.PVE( _PlayerIndex, _NpcIndex, nil, Pos[5][P4][7], Pos[5][P4][9], nil)
		Battle.SetWinEvent("./lua/Module/ActivityScript.lua", "ActivityNpc_BattleWin", tActivityBattleIndex);
	end
	if(tImage == 104399 or tImage == 104398) then
		local P4 = tImage - 104395;
		local tActivityBattleIndex = Battle.PVE( _PlayerIndex, _NpcIndex, nil, Pos[5][P4][7], Pos[5][P4][9], nil)
		Battle.SetWinEvent("./lua/Module/ActivityScript.lua", "ActivityNpc_BattleWin", tActivityBattleIndex);
	end
	if(tImage == 104937) then
		local tActivityBattleIndex = Battle.PVE( _PlayerIndex, _NpcIndex, nil, Pos[8][1][7], Pos[8][1][9], nil)
		Battle.SetWinEvent("./lua/Module/ActivityScript.lua", "ActivityNpc_BattleWin", tActivityBattleIndex);
	end
	if(tImage == 104759 or tImage == 104760 or tImage == 104761 or tImage == 104762) then
		local P3 = tImage - 104758;
		local tActivityBattleIndex = Battle.PVE( _PlayerIndex, _NpcIndex, nil, Pos[9][P3][7], Pos[9][P3][9], nil)
		Battle.SetWinEvent("./lua/Module/ActivityScript.lua", "ActivityNpc_BattleWin", tActivityBattleIndex);
	end
	if(tImage == 104758) then
		local tActivityBattleIndex = Battle.PVE( _PlayerIndex, _NpcIndex, nil, Pos[12][1][7], Pos[12][1][9], nil)
		Battle.SetWinEvent("./lua/Module/ActivityScript.lua", "ActivityNpc_BattleWin", tActivityBattleIndex);
	end
	if(tImage == 104680 or tImage == 104681 or tImage == 104682 or tImage == 104683 or tImage == 104684) then
		local P2 = tImage - 104679;
		local tActivityBattleIndex = Battle.PVE( _PlayerIndex, _NpcIndex, nil, Pos[13][P2][7], Pos[13][P2][9], nil)
		Battle.SetWinEvent("./lua/Module/ActivityScript.lua", "ActivityNpc_BattleWin", tActivityBattleIndex);
	end
 end
end
function ActivityNpc_BattleWin(_BattleIndex, _NpcIndex)
		local tImage = Char.GetData(_NpcIndex, %对象_形象%)
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
		if tPlayerIndex>=0 and Char.GetData(tPlayerIndex,%对象_类型%)==1 then
			if(tImage == 104845 or tImage == 104846 or tImage == 104847 or tImage == 104848 or tImage == 104849) then
				script_map_amount[5][Playerkey(tPlayerIndex)] = getamountless_5 + 10;
				local getamountless_5 = script_map_amount[5][Playerkey(tPlayerIndex)];
				local ichiban = math.random(5,6);
				Char.GiveItem(tPlayerIndex, 67778, ichiban);
				NLG.SystemMessage(tPlayerIndex, "[系統]擊敗了"..Char.GetData(_NpcIndex, %对象_原名%).."獲得10分,累積達到"..getamountless_5.."分")
				Char.GiveItem(tPlayerIndex,script_map_drop[5][drop],1);
				for i=0,9 do    Char.GiveItem(Battle.GetPlayIndex( _BattleIndex, i),script_map_drop[5][drop],1);    end
				if (getamountless_5 >= 100)then
					NLG.SystemMessage(tPlayerIndex, "[系統]《蛋糕島冒險》菁英強敵即將出現！")
				end
			end
			if(tImage == 104313) then
				NLG.SystemMessage(tPlayerIndex, "[系統]《蛋糕島冒險》副本已經結束！")
				--Char.GiveItem(tPlayerIndex,70199,1);
				for i=0,9 do    Char.GiveItem(Battle.GetPlayIndex( _BattleIndex, i),70199,1);    end
				getamountless_5 = 0;
				script_map_amount[5][Playerkey(tPlayerIndex)] = 0;
				Char.Warp(tPlayerIndex,0,1000,218,84);
			end
			if(tImage == 104686 or tImage == 104685 or tImage == 104399 or tImage == 104398) then
				script_map_amount[4][Playerkey(tPlayerIndex)] = getamountless_4 + 5;
				local getamountless_4 = script_map_amount[4][Playerkey(tPlayerIndex)];
				local ichiban = math.random(3,4);
				Char.GiveItem(tPlayerIndex, 67778, ichiban);
				NLG.SystemMessage(tPlayerIndex, "[系統]擊敗了"..Char.GetData(_NpcIndex, %对象_原名%).."獲得5分,累積達到"..getamountless_4.."分")
				Char.GiveItem(tPlayerIndex,script_map_drop[4][drop],1);
				for i=0,9 do    Char.GiveItem(Battle.GetPlayIndex( _BattleIndex, i),script_map_drop[4][drop],1);    end
				if (getamountless_4 >= 40)then
					NLG.SystemMessage(tPlayerIndex, "[系統]《南瓜大進擊》菁英強敵即將出現！")
				end
			end
			if(tImage == 104937) then
				NLG.SystemMessage(tPlayerIndex, "[系统]《南瓜大进击》副本已经结束！")
				--Char.GiveItem(tPlayerIndex,70198,1);
				for i=0,9 do    Char.GiveItem(Battle.GetPlayIndex( _BattleIndex, i),70198,1);    end
				getamountless_4 = 0;
				script_map_amount[4][Playerkey(tPlayerIndex)] = 0;
				Char.Warp(tPlayerIndex,0,1000,218,84);
			end
			if(tImage == 104759 or tImage == 104760 or tImage == 104761 or tImage == 104762) then
				script_map_amount[3][Playerkey(tPlayerIndex)] = getamountless_3 + 5;
				local getamountless_3 = script_map_amount[3][Playerkey(tPlayerIndex)];
				local ichiban = math.random(2,3);
				Char.GiveItem(tPlayerIndex, 67778, ichiban);
				NLG.SystemMessage(tPlayerIndex, "[系統]擊敗了"..Char.GetData(_NpcIndex, %对象_原名%).."獲得5分,累積達到"..getamountless_3.."分")
				Char.GiveItem(tPlayerIndex,script_map_drop[3][drop],1);
				for i=0,9 do    Char.GiveItem(Battle.GetPlayIndex( _BattleIndex, i),script_map_drop[3][drop],1);    end
				if (getamountless_3 >= 25)then
					NLG.SystemMessage(tPlayerIndex, "[系统]《悠闲之粽夏》菁英强敌即将出现！")
				end
			end
			if(tImage == 104758) then
				NLG.SystemMessage(tPlayerIndex, "[系统]《悠闲之粽夏》副本已经结束！")
				--Char.GiveItem(tPlayerIndex,70197,1);
				for i=0,9 do    Char.GiveItem(Battle.GetPlayIndex( _BattleIndex, i),70197,1);    end
				getamountless_3 = 0;
				script_map_amount[3][Playerkey(tPlayerIndex)] = 0;
				Char.Warp(tPlayerIndex,0,1000,218,84);
			end
			if(tImage == 104680 or tImage == 104681 or tImage == 104682 or tImage == 104683 or tImage == 104684) then
				script_map_amount[2][Playerkey(tPlayerIndex)] = getamountless_2 + 1;
				local getamountless_2 = script_map_amount[2][Playerkey(tPlayerIndex)];
				local ichiban = math.random(1,2);
				Char.GiveItem(tPlayerIndex, 67778, ichiban);
				NLG.SystemMessage(tPlayerIndex, "[系統]擊敗了"..Char.GetData(_NpcIndex, %对象_原名%).."獲得1分,累積達到"..getamountless_2.."分")
				Char.GiveItem(tPlayerIndex,script_map_drop[2][drop],1);
				for i=0,9 do    Char.GiveItem(Battle.GetPlayIndex( _BattleIndex, i),script_map_drop[2][drop],1);    end
				if (getamountless_2 >= 100)then
					NLG.SystemMessage(tPlayerIndex, "[系統]《仙境小妖森》副本已經結束！")
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
		Battle.UnsetWinEvent( _BattleIndex);
	--return 1
end

function table_n(c1,c2,n,t)
	for key, value in pairs(t) do
		if c1 == value and n == 'v' then
			return key
		end
	end
end
