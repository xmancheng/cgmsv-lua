local EnemySet = {}
local BaseLevelSet = {}
local Pos = {}
local STime = os.time()
local YS = 30 --脚本延时多少秒创建NPC
local SXTime = 15 --NPC刷新时间·秒
--队列解释
--     五	三	一	二	四
--     十	八	六	七	九
------------挑战道场NPC设置------------
EnemySet[1] = {406141, 0, 0, 0, 0, 406142, 406142, 406142, 406142, 406142}--0代表没有怪
EnemySet[2] = {406143, 0, 0, 0, 0, 406144, 406144, 406144, 406144, 406144}
EnemySet[3] = {406145, 0, 0, 0, 0, 406146, 406146, 406146, 406146, 406146}
EnemySet[4] = {406147, 406148, 406148, 0, 0, 406148, 0, 0, 0, 0}
EnemySet[5] = {406149, 406150, 406150, 0, 0, 406150, 406150, 406150, 0, 0}
EnemySet[6] = {406151, 406152, 406152, 0, 0, 0, 0, 0, 0, 0}
EnemySet[7] = {406153, 0, 0, 0, 0, 0, 0, 0, 406154, 406154}
EnemySet[8] = {406155, 0, 0, 406156, 406156, 0, 406156, 406156, 0, 0}
EnemySet[9] = {406157, 0, 0, 0, 0, 406158, 0, 0, 0, 0}
EnemySet[10] = {0, 406159, 406160, 0, 0, 0, 0, 0, 0, 0}
BaseLevelSet[1] = {119, 0, 0, 0, 0, 100, 100, 100, 100, 100}
BaseLevelSet[2] = {119, 0, 0, 0, 0, 100, 100, 100, 100, 100}
BaseLevelSet[3] = {119, 0, 0, 0, 0, 100, 100, 100, 100, 100}
BaseLevelSet[4] = {119, 100, 100, 0, 0, 100, 0, 0, 0, 0}
BaseLevelSet[5] = {119, 100, 100, 0, 0, 100, 100, 100, 0, 0}
BaseLevelSet[6] = {119, 100, 100, 0, 0, 0, 0, 0, 0, 0}
BaseLevelSet[7] = {119, 0, 0, 0, 0, 0, 0, 0, 100, 100}
BaseLevelSet[8] = {119, 0, 0, 100, 100, 0, 100, 100, 0, 0}
BaseLevelSet[9] = {119, 0, 0, 0, 0, 100, 0, 0, 0, 0}
BaseLevelSet[10] = {0, 119, 100, 0, 0, 0, 0, 0, 0, 0}
Pos[1] = {{"威頓",106014,19201,16,17,4,EnemySet[1],1,BaseLevelSet[1]}}
Pos[2] = {{"蕾茵",105377,19201,16,17,4,EnemySet[2],1,BaseLevelSet[2]}}
Pos[3] = {{"桑達",100158,19201,16,17,4,EnemySet[3],1,BaseLevelSet[3]}}
Pos[4] = {{"納塞",110562,19201,16,17,4,EnemySet[4],1,BaseLevelSet[4]}}
Pos[5] = {{"阿瑞斯",117023,19201,16,17,4,EnemySet[5],1,BaseLevelSet[5]}}
Pos[6] = {{"異界怪物",110378,19201,16,17,4,EnemySet[6],1,BaseLevelSet[6]}}
Pos[7] = {{"闇夜暴君",110334,19201,16,17,4,EnemySet[7],1,BaseLevelSet[7]}}
Pos[8] = {{"娜諾蕾西亞",106702,19201,16,17,4,EnemySet[8],1,BaseLevelSet[8]}}
Pos[9] = {{"回來的迪太",101803,19201,16,17,4,EnemySet[9],1,BaseLevelSet[9]}}
Pos[10] = {{"火牛魔王",120064,19201,16,17,4,EnemySet[10],1,BaseLevelSet[10]}}

tbl_RandomBravadoNpcIndex = tbl_RandomBravadoNpcIndex or {}
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

script_map_name[2] = "《單人挑戰二連勝》";
script_map_point[2] = {19201,16,30};
script_map_lvlimit[2] = 120;
script_map_payfor[2] = 5000;
script_map_drop[2] = {70206,661054,661054,661054,661055,661055,661055};

script_map_name[3] = "《單人挑戰三連勝》";
script_map_point[3] = {19201,16,30};
script_map_lvlimit[3] = 120;
script_map_payfor[3] = 5000;
script_map_drop[3] = {70206,661056,661056,661056,661057,661057,661057};

script_map_name[4] = "《單人挑戰五連勝》";
script_map_point[4] = {19201,16,30};
script_map_lvlimit[4] = 120;
script_map_payfor[4] = 5000;
script_map_drop[4] = {70206,661058,661059,661060,661058,661059,661060};

script_map_name[5] = "《單人挑戰十連勝》";
script_map_point[5] = {19201,16,30};
script_map_lvlimit[5] = 120;
script_map_payfor[5] = 5000;
script_map_drop[5] = {661054,661055,661056,661057,661058,661059,661060};

Delegate.RegInit("initBravadoScriptNpc");

function initBravadoScriptNpc_Init(index)
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

function initBravadoScriptNpc()
	if (BravadoScriptNps == nil) then
		BravadoScriptNps = NL.CreateNpc("lua/Module/BravadoScript.lua", "initBravadoScriptNpc_Init");
		Char.SetData(BravadoScriptNps,%对象_形象%,14111);
		Char.SetData(BravadoScriptNps,%对象_原形%,14111);
		Char.SetData(BravadoScriptNps,%对象_X%,238);
		Char.SetData(BravadoScriptNps,%对象_Y%,66);
		Char.SetData(BravadoScriptNps,%对象_地图%,1000);
		Char.SetData(BravadoScriptNps,%对象_方向%,6);
		Char.SetData(BravadoScriptNps,%对象_原名%,"單人挑戰道場");
		NLG.UpChar(BravadoScriptNps);
		Char.SetWindowTalkedEvent("lua/Module/BravadoScript.lua","BravadoScriptA",BravadoScriptNps);
		Char.SetTalkedEvent("lua/Module/BravadoScript.lua","BravadoScriptMsg", BravadoScriptNps);
	end
	if (BravadoScriptNpsB == nil) then
		BravadoScriptNpsB = NL.CreateNpc("lua/Module/BravadoScript.lua", "initBravadoScriptNpc_Init");
		Char.SetData(BravadoScriptNpsB,%对象_形象%,14193);
		Char.SetData(BravadoScriptNpsB,%对象_原形%,14193);
		Char.SetData(BravadoScriptNpsB,%对象_X%,31);
		Char.SetData(BravadoScriptNpsB,%对象_Y%,32);
		Char.SetData(BravadoScriptNpsB,%对象_地图%,19201);
		Char.SetData(BravadoScriptNpsB,%对象_方向%,6);
		Char.SetData(BravadoScriptNpsB,%对象_原名%,"獎勵發放員");
		NLG.UpChar(BravadoScriptNpsB);
		Char.SetWindowTalkedEvent("lua/Module/BravadoScript.lua","BravadoScriptB",BravadoScriptNpsB);
		Char.SetTalkedEvent("lua/Module/BravadoScript.lua","BravadoScriptMsgB", BravadoScriptNpsB);
	end
	if (BravadoScriptNpsC == nil) then
		BravadoScriptNpsC = NL.CreateNpc("lua/Module/BravadoScript.lua", "initBravadoScriptNpc_Init");
		Char.SetData(BravadoScriptNpsC,%对象_形象%,231116);
		Char.SetData(BravadoScriptNpsC,%对象_原形%,231116);
		Char.SetData(BravadoScriptNpsC,%对象_X%,17);
		Char.SetData(BravadoScriptNpsC,%对象_Y%,17);
		Char.SetData(BravadoScriptNpsC,%对象_地图%,777);
		Char.SetData(BravadoScriptNpsC,%对象_方向%,6);
		Char.SetData(BravadoScriptNpsC,%对象_原名%,"明怪設置");
		NLG.UpChar(BravadoScriptNpsC);
		Char.SetLoopEvent(nil, "BravadoScript_LoopEvent",BravadoScriptNpsC, SXTime*1000)
		Char.SetWindowTalkedEvent("lua/Module/BravadoScript.lua","BravadoScriptC",BravadoScriptNpsC);
		Char.SetTalkedEvent("lua/Module/BravadoScript.lua","BravadoScriptMsgC", BravadoScriptNpsC);
	end
end

function BravadoScriptMsgA(_me,_tome)
	if (NLG.CanTalk(_me,_tome) == true) then
		local PlayerLevel = tonumber(Char.GetData(_tome,%对象_等级%));
		
		if (PlayerLevel < 120) then
			NLG.ShowWindowTalked(_tome,_me,%窗口_信息框%,%按钮_确定%,1,NLG.c("\\n\\n\\n先到達120級再來吧！"));
			return;
		end

		if(Time_Out(_tome))then
			script_map_daily_user[Playerkey(_tome)] = os.time();
			for i=1,6 do
				script_map_daily_user_count[i][Playerkey(_tome)] = nil;
			end
		end

		if (script_map_daily_user_count[1][Playerkey(_tome)] == 1) then
			NLG.ShowWindowTalked(_tome,_me,%窗口_信息框%,%按钮_确定%,1,NLG.c("\\n\\n\\n下周再來吧！"));
			return;
		end
		script_map_daily_user_count[1][Playerkey(_tome)] = 1;
		NLG.ShowWindowTalked(_tome,_me,%窗口_信息框%,%按钮_确定%,1,NLG.c("\\n\\n\\n你願意參加單人挑戰得到各式材料嗎？"));
	end
	return;
end



function BravadoScriptMsg(_me,_tome)
	if (NLG.CanTalk(_me,_tome) == true) then
		local _obj = script_map_daily_user[Playerkey(_tome)];
		--如果首次登录
		if (_obj == nil) then 
			script_map_daily_user[Playerkey(_tome)] = os.time();
		end
		if(os.date("%w",_obj) ~= os.date("%w",os.time())) then --判定一星期重置
			script_map_daily_user[Playerkey(_tome)] = os.time();
			for i=1,6 do
				script_map_daily_user_count[i][Playerkey(_tome)] = nil;
			end
		end

		str_ChangeWindow = "4|\\n\\n 			你好!我是挑戰管理員.\\n	 			請問你要挑戰幾勝!...\\n\\n";
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


function BravadoScriptA(_MeIndex,_PlayerIndex,_seqno,_select,_data)
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
		if(Char.ItemNum(_PlayerIndex,70211)>0 or Char.ItemNum(_PlayerIndex,70212)>0 or Char.ItemNum(_PlayerIndex,70213)>0 or Char.ItemNum(_PlayerIndex,70214)>0)then
			NLG.ShowWindowTalked(_PlayerIndex,_MeIndex,%窗口_信息框%,%按钮_关闭%,1,"\\n\\n\\n進入道場前不能有任何資格項鍊。");
			return;
		end
		if(mykgold(_PlayerIndex,script_map_payfor[selectitem]))then
			script_map_daily_user_count[selectitem][Playerkey(_PlayerIndex)] = getcountless + 1;
			if(selectitem ==2 and Char.ItemNum(_PlayerIndex,70211) ==0)then Char.GiveItem(_PlayerIndex,70211,1) end
			if(selectitem ==3 and Char.ItemNum(_PlayerIndex,70212) ==0)then Char.GiveItem(_PlayerIndex,70212,1) end
			if(selectitem ==4 and Char.ItemNum(_PlayerIndex,70213) ==0)then Char.GiveItem(_PlayerIndex,70213,1) end
			if(selectitem ==5 and Char.ItemNum(_PlayerIndex,70214) ==0)then Char.GiveItem(_PlayerIndex,70214,1) end
			Char.DischargeParty(_PlayerIndex)
			Char.Warp(_PlayerIndex,0,script_map_point[selectitem][1],script_map_point[selectitem][2],script_map_point[selectitem][3]);
		else
			NLG.ShowWindowTalked(_PlayerIndex,_MeIndex,%窗口_信息框%,%按钮_关闭%,1,"\\n\\n\\n您的魔幣不夠。");
			return;
		end
	end
end

function BravadoScriptB(_MeIndex,_PlayerIndex,_seqno,_select,_data)

end
function BravadoScriptMsgB(_me,_tome)
	if (NLG.CanTalk(_me,_tome) == true) then
		if (Char.ItemNum(_tome,70211) > 0) then
			if(Char.ItemSlot(_tome)>17)then
				NLG.ShowWindowTalked(_tome,_me,%窗口_信息框%,%按钮_关闭%,1,NLG.c("\\n\\n\\n請至少留出3個背包位置！"));
				return;
			end
			local slot = Char.FindItemId(_tome,70211);
			local item_indexA = Char.GetItemIndex(_tome,slot);
			local win = Item.GetData(item_indexA,%道具_魅力%);
			if (win==2) then
				Char.GiveItem(_tome,70002,25);
				Char.GiveItem(_tome,70015,40);
				Char.GiveItem(_tome,70052,1);
				local PlayerFame = Char.GetData(_tome,%对象_声望%);
				PlayerFame = PlayerFame + 300;
				Char.SetData(_tome,%对象_声望%,PlayerFame);
				local money = Char.GetData(_tome,%对象_金币%);
				Char.SetData(_tome,%对象_金币%,money+5000);
				NLG.UpChar(_tome);
				Char.DelItem(_tome,70211,1);
				NLG.SystemMessage(_tome, "[系統]已領取材料獎勵！")
			else
				NLG.SystemMessage(_tome, "[系統]領取資格不符！！")
			end
			Char.Warp(_tome,0,1000,237,66);
		end
		if (Char.ItemNum(_tome,70212) > 0) then
			if(Char.ItemSlot(_tome)>17)then
				NLG.ShowWindowTalked(_tome,_me,%窗口_信息框%,%按钮_关闭%,1,NLG.c("\\n\\n\\n請至少留出3個背包位置！"));
				return;
			end
			local slot = Char.FindItemId(_tome,70212);
			local item_indexA = Char.GetItemIndex(_tome,slot);
			local win = Item.GetData(item_indexA,%道具_魅力%);
			if (win==3) then
				Char.GiveItem(_tome,66666,50);
				Char.GiveItem(_tome,68999,70);
				Char.GiveItem(_tome,71016,1);
				local PlayerFame = Char.GetData(_tome,%对象_声望%);
				PlayerFame = PlayerFame + 600;
				Char.SetData(_tome,%对象_声望%,PlayerFame);
				local money = Char.GetData(_tome,%对象_金币%);
				Char.SetData(_tome,%对象_金币%,money+8000);
				NLG.UpChar(_tome);
				Char.DelItem(_tome,70212,1);
				NLG.SystemMessage(_tome, "[系統]已領取材料獎勵！")
			else
				NLG.SystemMessage(_tome, "[系統]領取資格不符！！")
			end
			Char.Warp(_tome,0,1000,237,66);
		end
		if (Char.ItemNum(_tome,70213) > 0) then
			if(Char.ItemSlot(_tome)>17)then
				NLG.ShowWindowTalked(_tome,_me,%窗口_信息框%,%按钮_关闭%,1,NLG.c("\\n\\n\\n請至少留出3個背包位置！"));
				return;
			end
			local slot = Char.FindItemId(_tome,70213);
			local item_indexA = Char.GetItemIndex(_tome,slot);
			local win = Item.GetData(item_indexA,%道具_魅力%);
			if (win==5) then
				Char.GiveItem(_tome,68001,10);
				Char.GiveItem(_tome,69157,64);
				Char.GiveItem(_tome,71017,1);
				local PlayerFame = Char.GetData(_tome,%对象_声望%);
				PlayerFame = PlayerFame + 1200;
				Char.SetData(_tome,%对象_声望%,PlayerFame);
				local money = Char.GetData(_tome,%对象_金币%);
				Char.SetData(_tome,%对象_金币%,money+11000);
				NLG.UpChar(_tome);
				Char.DelItem(_tome,70213,1);
				NLG.SystemMessage(_tome, "[系統]已領取材料獎勵！")
			else
				NLG.SystemMessage(_tome, "[系統]領取資格不符！！")
			end
			Char.Warp(_tome,0,1000,237,66);
		end
		if (Char.ItemNum(_tome,70214) > 0) then
			if(Char.ItemSlot(_tome)>17)then
				NLG.ShowWindowTalked(_tome,_me,%窗口_信息框%,%按钮_关闭%,1,NLG.c("\\n\\n\\n請至少留出3個背包位置！"));
				return;
			end
			local slot = Char.FindItemId(_tome,70214);
			local item_indexA = Char.GetItemIndex(_tome,slot);
			local win = Item.GetData(item_indexA,%道具_魅力%);
			if (win==10) then
				Char.GiveItem(_tome,68000,10);
				Char.GiveItem(_tome,70161,1);
				Char.GiveItem(_tome,71018,1);
				local PlayerFame = Char.GetData(_tome,%对象_声望%);
				PlayerFame = PlayerFame + 2500;
				Char.SetData(_tome,%对象_声望%,PlayerFame);
				local money = Char.GetData(_tome,%对象_金币%);
				Char.SetData(_tome,%对象_金币%,money+20000);
				NLG.UpChar(_tome);
				Char.DelItem(_tome,70214,1);
				NLG.SystemMessage(_tome, "[系統]已領取材料獎勵！")
			else
				NLG.SystemMessage(_tome, "[系統]領取資格不符！！")
			end
			Char.Warp(_tome,0,1000,237,66);
		end
		--NLG.ShowWindowTalked(_tome,_me,%窗口_信息框%,%按钮_关闭%,1,NLG.c("\\n\\n\\n下周再來領取聲望和各式材料吧！"));
	end
	return;
end
function BravadoScript_LoopEvent(_MeIndex)
	--创建假人
	local DTime = os.time()
	if DTime - STime >= YS then
		local i = NLG.Rand(1,10)
		local Image = Pos[i][1][2]
		local Name = Pos[i][1][1]
		local Num = Pos[i][1][8]
			if tbl_RandomBravadoNpcIndex[Num] == nil then
				local BravadoScriptNpcIndex = CreateBravadoNpc(Image, Name, 0, Pos[i][1][3], Pos[i][1][4], Pos[i][1][5], Pos[i][1][6])
				tbl_RandomBravadoNpcIndex[Num] = BravadoScriptNpcIndex
			end
	end
end
--NPC对话事件(NPC索引)
function BravadoScriptMsgC(_NpcIndex, _PlayerIndex)
tbl_RandomBravadoNpcIndex = {}
end

--NPC窗口事件(NPC索引)
function BravadoScriptC ( _NpcIndex, _PlayerIndex, _seqno, _select, _data)
	
end
function CreateBravadoNpc(Image, Name, MapType, MapID, PosX, PosY, Dir)
	local BravadoScriptNpcIndex = NL.CreateNpc("./lua/System/BaseModule/Base.lua", "Myinit");
	Char.SetData( BravadoScriptNpcIndex, %对象_形象%, Image);
	Char.SetData( BravadoScriptNpcIndex, %对象_原形%, Image);
	Char.SetData( BravadoScriptNpcIndex, %对象_地图类型%, MapType);
	Char.SetData( BravadoScriptNpcIndex, %对象_地图%, MapID);
	Char.SetData( BravadoScriptNpcIndex, %对象_X%, PosX);
	Char.SetData( BravadoScriptNpcIndex, %对象_Y%, PosY);
	Char.SetData( BravadoScriptNpcIndex, %对象_方向%, Dir);
	Char.SetData( BravadoScriptNpcIndex, %对象_原名%, Name);
	Char.SetData( BravadoScriptNpcIndex, %对象_名色%, NameColor);
	tbl_LuaNpcIndex = tbl_LuaNpcIndex or {}
	tbl_LuaNpcIndex["BravadoNpc"] = BravadoScriptNpcIndex
	Char.SetTalkedEvent(nil, "BravadoNpc__Talked", BravadoScriptNpcIndex)
	Char.SetWindowTalkedEvent(nil, "BravadoNpc__WindowTalked", BravadoScriptNpcIndex)
	Char.SetLoopEvent(nil, "BravadoNpc_LoopEvent", BravadoScriptNpcIndex, math.random(1000,5000))
	NLG.UpChar(BravadoScriptNpcIndex)
	return BravadoScriptNpcIndex
end
function BravadoNpc_LoopEvent(_MeIndex)
	local spell = 6;
	NLG.SetAction(_MeIndex,spell);
	NLG.UpChar(_MeIndex);
end
function BravadoNpc__Talked(_NpcIndex, _PlayerIndex)
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
	local	token ="\n\n\n\n挑戰者"..mz.."準備進入戰鬥嗎？"

       NLG.ShowWindowTalked(_PlayerIndex, _NpcIndex, 0, 1, 1, token)

end
function BravadoNpc__WindowTalked( _NpcIndex, _PlayerIndex, _Seqno, _Select, _Data)
	if _Seqno == 1 then
	local tName = Char.GetData(_NpcIndex, %对象_原名%)
	local tImage = Char.GetData(_NpcIndex, %对象_形象%)
	--创建Boss战斗
	local tBossLv = 1
--	local tBravadoBattleIndex = Battle.PVE( _PlayerIndex, tbl_LuaNpcIndex["BravadoNpc"], nil, tBossList, tLvList, nil)
	if(Char.PartyNum(_PlayerIndex) > 1)then
		NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,2,"\\n\\n\\n請單人進行挑戰。");
		return;
	end
	if(tImage == 106014) then
		local tBravadoBattleIndex = Battle.PVE( _PlayerIndex, _NpcIndex, nil, Pos[1][1][7], Pos[1][1][9], nil)
		Battle.SetWinEvent("./lua/Module/BravadoScript.lua", "BravadoNpc_BattleWin", tBravadoBattleIndex);
	end
	if(tImage == 105377) then
		local tBravadoBattleIndex = Battle.PVE( _PlayerIndex, _NpcIndex, nil, Pos[2][1][7], Pos[2][1][9], nil)
		Battle.SetWinEvent("./lua/Module/BravadoScript.lua", "BravadoNpc_BattleWin", tBravadoBattleIndex);
	end
	if(tImage == 100158) then
		local tBravadoBattleIndex = Battle.PVE( _PlayerIndex, _NpcIndex, nil, Pos[3][1][7], Pos[3][1][9], nil)
		Battle.SetWinEvent("./lua/Module/BravadoScript.lua", "BravadoNpc_BattleWin", tBravadoBattleIndex);
	end
	if(tImage == 110562) then
		local tBravadoBattleIndex = Battle.PVE( _PlayerIndex, _NpcIndex, nil, Pos[4][1][7], Pos[4][1][9], nil)
		Battle.SetWinEvent("./lua/Module/BravadoScript.lua", "BravadoNpc_BattleWin", tBravadoBattleIndex);
	end
	if(tImage == 117023) then
		local tBravadoBattleIndex = Battle.PVE( _PlayerIndex, _NpcIndex, nil, Pos[5][1][7], Pos[5][1][9], nil)
		Battle.SetWinEvent("./lua/Module/BravadoScript.lua", "BravadoNpc_BattleWin", tBravadoBattleIndex);
	end
	if(tImage == 110378) then
		local tBravadoBattleIndex = Battle.PVE( _PlayerIndex, _NpcIndex, nil, Pos[6][1][7], Pos[6][1][9], nil)
		Battle.SetWinEvent("./lua/Module/BravadoScript.lua", "BravadoNpc_BattleWin", tBravadoBattleIndex);
	end
	if(tImage == 110334) then
		local tBravadoBattleIndex = Battle.PVE( _PlayerIndex, _NpcIndex, nil, Pos[7][1][7], Pos[7][1][9], nil)
		Battle.SetWinEvent("./lua/Module/BravadoScript.lua", "BravadoNpc_BattleWin", tBravadoBattleIndex);
	end
	if(tImage == 106702) then
		local tBravadoBattleIndex = Battle.PVE( _PlayerIndex, _NpcIndex, nil, Pos[8][1][7], Pos[8][1][9], nil)
		Battle.SetWinEvent("./lua/Module/BravadoScript.lua", "BravadoNpc_BattleWin", tBravadoBattleIndex);
	end
	if(tImage == 101803) then
		local tBravadoBattleIndex = Battle.PVE( _PlayerIndex, _NpcIndex, nil, Pos[9][1][7], Pos[9][1][9], nil)
		Battle.SetWinEvent("./lua/Module/BravadoScript.lua", "BravadoNpc_BattleWin", tBravadoBattleIndex);
	end
	if(tImage == 120064) then
		local tBravadoBattleIndex = Battle.PVE( _PlayerIndex, _NpcIndex, nil, Pos[10][1][7], Pos[10][1][9], nil)
		Battle.SetWinEvent("./lua/Module/BravadoScript.lua", "BravadoNpc_BattleWin", tBravadoBattleIndex);
	end
 end
end
function BravadoNpc_BattleWin(_BattleIndex, _NpcIndex)
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
			if(Char.ItemNum(tPlayerIndex,70211) > 0) then
				script_map_amount[2][Playerkey(tPlayerIndex)] = getamountless_2 + 1;
				local getamountless_2 = script_map_amount[2][Playerkey(tPlayerIndex)];
				NLG.SystemMessage(tPlayerIndex, "[系統]擊敗了"..Char.GetData(_NpcIndex, %对象_原名%).."獲得1分,累積達到"..getamountless_2.."分")
				Char.GiveItem(tPlayerIndex,script_map_drop[2][drop],1);
				if (getamountless_2 >= 2)then
					NLG.SystemMessage(tPlayerIndex, "[系統]《單人挑戰二連勝》成就達成！")
					local slot = Char.FindItemId(tPlayerIndex,70211);
					local item_indexA = Char.GetItemIndex(tPlayerIndex,slot);
					Item.SetData(item_indexA,%道具_魅力%,2);
					Item.UpItem(tPlayerIndex,slot);
					getamountless_2 = 0;
					script_map_amount[2][Playerkey(tPlayerIndex)] = 0;
					Char.Warp(tPlayerIndex,0,19201,28,35);
				end
			end
			if(Char.ItemNum(tPlayerIndex,70212) > 0) then
				script_map_amount[3][Playerkey(tPlayerIndex)] = getamountless_3 + 1;
				local getamountless_3 = script_map_amount[3][Playerkey(tPlayerIndex)];
				NLG.SystemMessage(tPlayerIndex, "[系統]擊敗了"..Char.GetData(_NpcIndex, %对象_原名%).."獲得1分,累積達到"..getamountless_3.."分")
				Char.GiveItem(tPlayerIndex,script_map_drop[3][drop],1);
				if (getamountless_3 >= 3)then
					NLG.SystemMessage(tPlayerIndex, "[系統]《單人挑戰三連勝》成就達成！")
					local slot = Char.FindItemId(tPlayerIndex,70212);
					local item_indexA = Char.GetItemIndex(tPlayerIndex,slot);
					Item.SetData(item_indexA,%道具_魅力%,3);
					Item.UpItem(tPlayerIndex,slot);
					getamountless_3 = 0;
					script_map_amount[3][Playerkey(tPlayerIndex)] = 0;
					Char.Warp(tPlayerIndex,0,19201,28,35);
				end
			end
			if(Char.ItemNum(tPlayerIndex,70213) > 0) then
				script_map_amount[4][Playerkey(tPlayerIndex)] = getamountless_4 + 1;
				local getamountless_4 = script_map_amount[4][Playerkey(tPlayerIndex)];
				NLG.SystemMessage(tPlayerIndex, "[系統]擊敗了"..Char.GetData(_NpcIndex, %对象_原名%).."獲得1分,累積達到"..getamountless_4.."分")
				Char.GiveItem(tPlayerIndex,script_map_drop[4][drop],1);
				if (getamountless_4 >= 5)then
					NLG.SystemMessage(tPlayerIndex, "[系統]《單人挑戰五連勝》成就達成！")
					local slot = Char.FindItemId(tPlayerIndex,70213);
					local item_indexA = Char.GetItemIndex(tPlayerIndex,slot);
					Item.SetData(item_indexA,%道具_魅力%,5);
					getamountless_4 = 0;
					script_map_amount[4][Playerkey(tPlayerIndex)] = 0;
					Char.Warp(tPlayerIndex,0,19201,28,35);
				end
			end
			if(Char.ItemNum(tPlayerIndex,70214) > 0) then
				script_map_amount[5][Playerkey(tPlayerIndex)] = getamountless_5 + 1;
				local getamountless_5 = script_map_amount[5][Playerkey(tPlayerIndex)];
				NLG.SystemMessage(tPlayerIndex, "[系統]擊敗了"..Char.GetData(_NpcIndex, %对象_原名%).."獲得1分,累積達到"..getamountless_5.."分")
				Char.GiveItem(tPlayerIndex,script_map_drop[5][drop],1);
				if (getamountless_5 >= 10)then
					NLG.SystemMessage(tPlayerIndex, "[系統]《單人挑戰十連勝》成就達成！")
					local slot = Char.FindItemId(tPlayerIndex,70214);
					local item_indexA = Char.GetItemIndex(tPlayerIndex,slot);
					Item.SetData(item_indexA,%道具_魅力%,10);
					getamountless_5 = 0;
					script_map_amount[5][Playerkey(tPlayerIndex)] = 0;
					Char.Warp(tPlayerIndex,0,19201,28,35);
				end
			end
			NL.DelNpc(_NpcIndex)
			local kk = table_n(_NpcIndex,0,'v',tbl_RandomBravadoNpcIndex)
			tbl_RandomBravadoNpcIndex[kk] = nil
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
