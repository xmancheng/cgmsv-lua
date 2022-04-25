local t1 = {"你睡著了喔?我都快餓死了..."};
local t2 = {"你自己一直偷吃都不餵我..."};
local t3 = {"我需要甜食，就是那個啦!"};
local t4 = {"我...我...太感動了!"};
local t5 = {"最近天氣不錯..."};
local t6 = {"無聊就吃東西吧..."};
local t7 = {"讓你喘口氣也好!"};
local t8 = {"哈哈!接下來要去挑戰誰呀!"};
local t9 = {"今天非常順利哦!走吧!我們再去練!"};
local t10 = {"不要以為就可以輕鬆的死亡!"};
local t11 = {"精神不夠啊，重新開始吧"};
local t12 = {"我有出眾的力量和智慧!"};
local t13 = {"很抱歉你只到這種水平... 很讓我失望"};
local t14 = {"活著是空虛的..."};
local t15 = {"不好意思!讓主人擔心了!"};
local t16 = {"恭喜呦!您是我心目中的英雄"};
local t17 = {"時間就是金幣啊! 朋友!"};
local t18 = {"先別急著冒險,讓我陪您喝杯茶再說吧!"};
local t19 = {"是的! 老大!"};
local t20 = {"嗚啦啊啊啊啊啊!!!"};
local talknotes = {t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,t13,t14,t15,t16,t17,t18,t19,t20};
local T_status = 0;
--0:未开始 1:宠物说话公告 2:宠物说话准备 3:宠物说话
local ans_list = {};
local PTime = 0;
local rn = 0;
local rexp = 0;
local lastPTime = os.time();
local MeTime = 0;
local T_T_Rand = 0;
local P_E_Rand = 0;

local nowTalknotesNum = 0;

touch_pet_daily_user = {};
touch_pet_daily_user_count = {};
touch_pet_daily_user_count[1] = {};
touch_pet_daily_user_count[2] = {};
touch_pet_daily_user_count[3] = {};
function Time_Check(_obj) --判定是否一天时间已过
	if (os.date("%d",_obj) ~= os.date("%d",os.time())) then 
		return true;
	end
	return false;
end

function Time_Out(playerindex) --每日24点为判定超时
	local _obj = touch_pet_daily_user[Playerkey(playerindex)];
	--如果首次登录
	if (_obj == nil) then 
		touch_pet_daily_user[Playerkey(playerindex)] = os.time();
		return true;
	else
		return Time_Check(_obj);
	end
end

Delegate.RegInit("PetTalk_Init");


function Myinit(_MeIndex)
	return true;
end


function initPetTalk_referee()
	if (PetTalk_referee == nil) then
		PetTalk_referee = NL.CreateNpc("lua/Module/PetTalk.lua", "Myinit");
		Char.SetData(PetTalk_referee,%对象_形象%,101003);
		Char.SetData(PetTalk_referee,%对象_原形%,101003);
		Char.SetData(PetTalk_referee,%对象_X%,38);
		Char.SetData(PetTalk_referee,%对象_Y%,35);
		Char.SetData(PetTalk_referee,%对象_地图%,777);
		Char.SetData(PetTalk_referee,%对象_方向%,4);
		Char.SetData(PetTalk_referee,%对象_名字%,"宠物说话");
		NLG.UpChar(PetTalk_referee);
		Char.SetTalkedEvent("lua/Module/PetTalk.lua", "PetTalk_referee_Talked", PetTalk_referee);
		Char.SetWindowTalkedEvent("lua/Module/PetTalk.lua", "PetTalk_referee_WindowTalked", PetTalk_referee);
		Char.SetLoopEvent("lua/Module/PetTalk.lua", "PetTalkLoop", PetTalk_referee, 1000);
	end
end



function PetTalk_Init()
	
	initPetTalk_referee();
	
end

function PetTalk_referee_Talked( _MeIndex, _PlayerIndex, _Mode)
	if (Char.PetNum(_PlayerIndex) == 0) then
		NLG.SystemMessage(_PlayerIndex, "[系统]你没有任何的宠物。")
		return;
	end
	local TalkMsg =	"4\\n◆宠物心电感应◆" ..
			"\\n每日与宠物互动的系统" ..
			"\\n可以用料理喂食提升饱食度" ..
			"\\n维持一定饱食度提升亲密度" ..
			"\\n『喂食』" ..
			"\\n『互动』" ..
			"\\n『饱食度』" ..
			"\\n『亲密度』"..
			"\\n" 
	TalkMsg =Shor_GAMsgFormat(TalkMsg);
	Shor_ShowGAWindowTalk(_PlayerIndex, 2, 2, 1,TalkMsg,_MeIndex);
	return ;
end

NL.RegItemString("lua/Module/PetTalk.lua","PetTalk","LUA_usePetTalk");
function PetTalk(_PlayerIndex,_toIndex,_itemslot) --双击道具执行函数
	if (Char.PetNum(_PlayerIndex) == 0) then
		NLG.SystemMessage(_PlayerIndex, "[系统]你没有任何的宠物。")
		return;
	end
	local TalkMsg =	"4\\n◆宠物心电感应◆" ..
			"\\n每日与宠物互动的系统" ..
			"\\n喂食料理提升饱食度" ..
			"\\n每日互动提升亲密度" ..
			"\\n『按时喂食』" ..
			"\\n『亲密互动』" ..
			"\\n『饱食度』" ..
			"\\n『亲密度』"..
			"\\n" 
	TalkMsg =Shor_GAMsgFormat(TalkMsg);
	NLG.ShowWindowTalked(_PlayerIndex,PetTalk_referee,%窗口_选择框%,%按钮_关闭%,1,TalkMsg);
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


function PetTalk_referee_WindowTalked( _MeIndex, _PlayerIndex, _Seqno, _Select, _Data)
	local pet_indexA = Char.GetPet(_PlayerIndex,0);
	pItemIndex = Char.GetItemIndex(_PlayerIndex, Char.FindItemId(_PlayerIndex,70188));
	pItemID = Item.GetData(pItemIndex, 0);
	if (VaildChar(pItemIndex) == true and pItemID==70188) then
		satiety = Item.GetData(pItemIndex,%道具_子参一%);
		intimacy = Item.GetData(pItemIndex,%道具_子参二%);
	end
	--取消按钮
	if _Select==2 then
		return
	end
	
	if _Seqno==1 then
		local PlayerSelect = tonumber(_Data)
		--查询
		if PlayerSelect==1 then
			local Base_satiety = 0;
			for i=8,27 do
				tItemIndex = Char.GetItemIndex(_PlayerIndex, i);
				tItemID = Item.GetData(tItemIndex, 0);
				if (VaildChar(tItemIndex) == true and Item.GetData(tItemIndex,%道具_类型%)==23) then
					local food_level = Item.GetData(tItemIndex,%道具_等级%);
					--local potion_level = Item.GetData(tItemIndex,%道具_等级%);
					local sum_s = satiety + food_level;
					Char.DelItem(_PlayerIndex,tItemID,1);
					pItemIndex = Char.GetItemIndex(_PlayerIndex, Char.FindItemId(_PlayerIndex,70188));
					pItemID = Item.GetData(pItemIndex, 0);
					if (VaildChar(pItemIndex) == true and pItemID==70188) then
						Item.SetData(pItemIndex,%道具_子参一%,sum_s);
						local satiety = Item.GetData(pItemIndex,%道具_子参一%);
						Item.UpItem(_PlayerIndex,p);
						if (satiety >= 100) then
						Item.SetData(pItemIndex,%道具_子参一%,100);
						local satiety = Item.GetData(pItemIndex,%道具_子参一%);
						Item.UpItem(_PlayerIndex,p);
						end
					end
				end
			end
			NLG.SetAction(_PlayerIndex, 7);
			NLG.UpChar(_PlayerIndex);
			local PlayerInMap = Char.GetData(_PlayerIndex,%对象_地图类型%);
			local PlayerInFloor = Char.GetData(_PlayerIndex,%对象_地图%);
			local PlayerInX = Char.GetData(_PlayerIndex,%对象_X%);
			local PlayerInY = Char.GetData(_PlayerIndex,%对象_Y%);
			local pet = Char.GetPet(_PlayerIndex,0);
			local ImageID = Char.GetData(pet, %对象_形象%);
			if (PetTalkModelNpc == nil or index == nil)then
				PetTalkModelNpc = PetTalkModelNpc_Create(Char.GetData(pet,%对象_名字%), ImageID, PlayerInMap, PlayerInFloor, PlayerInX, PlayerInY-1, 4);
			end
			return;
		end
		if PlayerSelect==2 then
			getcountless = touch_pet_daily_user_count[1][Playerkey(_PlayerIndex)];
			if(getcountless ==nil)then
				getcountless = 0;
				touch_pet_daily_user_count[1][Playerkey(_PlayerIndex)] = 0;
			end
			if (getcountless >= 12)then
				NLG.ShowWindowTalked(_PlayerIndex,_MeIndex,%窗口_信息框%,%按钮_关闭%,1,"\\n\\n\\n每日12次的亲密互动次数已经用完了。");
				return;
			end
			NLG.SetAction(_PlayerIndex, 6);
			NLG.UpChar(_PlayerIndex);
			checkAns(_PlayerIndex,msg);
			return;
		end
		if PlayerSelect==3 then
			local TalkCh =	"\\n"..Char.GetData(pet_indexA,%对象_名字%).."：" ..
					"\\n等级："..Char.GetData(pet_indexA,%对象_等级%).."" ..
					"\\n经验："..Char.GetData(pet_indexA,%对象_经验%).."" ..
					"\\n " ..
					"\\n『饱食度』" ..
					"\\n   "..satiety.."％" ..
					"\\n" ..
					"\\n" 
			NLG.ShowWindowTalked(_PlayerIndex, _MeIndex,%窗口_信息框%,%按钮_关闭%, 11, TalkCh);
			return;
		end
		if PlayerSelect==4 then
			local TalkCh =	"\\n"..Char.GetData(pet_indexA,%对象_名字%).."：" ..
					"\\n等级："..Char.GetData(pet_indexA,%对象_等级%).."" ..
					"\\n经验："..Char.GetData(pet_indexA,%对象_经验%).."" ..
					"\\n " ..
					"\\n『亲密度』" ..
					"\\n   "..intimacy.."％" ..
					"\\n" ..
					"\\n" 
			NLG.ShowWindowTalked(_PlayerIndex, _MeIndex,%窗口_信息框%,%按钮_关闭%, 12, TalkCh);
			return;
		end
		if PlayerSelect==5 then
			return;
		end
	end
end

Delegate.RegDelTalkEvent("PetTalk_talk_Event");

function PetTalk_talk_Event(player,msg,color,range,size)


	if(check_msg(msg,"@"))then
		    --NLG.SystemMessage(player,Char.GetData(player,%对象_GM%));
		checkAns(player,msg);
	end	


	local gmpassword = "pettalk";
	if(check_msg(msg,"["..gmpassword.." showquest]") or check_msg(msg,"["..gmpassword.." ShowQuest]")) then
			pettalkStart();
	end
    if(check_msg(msg,"["..gmpassword.." startquest]") or check_msg(msg,"["..gmpassword.." StartQuest]")) then
			pettalkOpen = 1;
            NLG.SystemMessage(player,"您已经开启了宠物说话系统！");
	end
    if(check_msg(msg,"["..gmpassword.." endquest]") or check_msg(msg,"["..gmpassword.." EndQuest]")) then
			pettalkOpen = 0;
            NLG.SystemMessage(player,"您已经关闭了宠物说话系统！");
	end

end

function Init(index)
	return true;
end

NL.RegCharActionEvent(nil,"PetTalk_CharActionEvent");
function PetTalk_CharActionEvent(player,ActionID)
	local pet_A = Char.GetPet(player,0);
	local sum_i = intimacy - 3;
	if (VaildChar(pet_A)==true and ActionID ~= 6 and ActionID ~= 7) then
		pItemIndex = Char.GetItemIndex(player, Char.FindItemId(player,70188));
		pItemID = Item.GetData(pItemIndex, 0);
		if (VaildChar(pItemIndex) == true and pItemID==70188) then
			Item.SetData(pItemIndex,%道具_子参二%,sum_i);
			local intimacy = Item.GetData(pItemIndex,%道具_子参二%);
			Item.UpItem(player,p);
			if (intimacy <= 0) then
			Item.SetData(pItemIndex,%道具_子参二%,0);
			local intimacy = Item.GetData(pItemIndex,%道具_子参二%);
			Item.UpItem(player,p);
			end
		end
		return ;
	end
	if(VaildChar(pet_A)==true and Char.ItemNum(player,70188) > 0 and ActionID == 6)then
		checkAns(player,msg);
	end
end

function PetTalkLoop(index)
	
        if (pettalkOpen ==0)then
           return;
        end

        --如果宠物说话未开始
	MeQTime = os.time();
	T_T_Rand = math.random(1,1001);
	if(T_T_Rand > 500 and T_status == 0 and MeQTime - lastPTime >= 60) then
		lastPTime = os.time();
		T_status = 1;
		ans_list = {};
	end
	if(T_status==0) then
		return;
	end
	--宠物说话系统公告
	if(T_status==1) then
		--if PetTalkModelNpc ~= nil then
		--	NL.DelNpc(PetTalkModelNpc)
		--	PetTalkModelNpc = nil
		--end
		--NLG.SystemMessage(-1,"[系统]如果主人想和宠物说话,开头请加上@");
		ans_list = {};
		T_status = 2;
	end
	--宠物说话系统准备
	if(T_status==2) then
		T_status = 3;
		ans_list = {};
		PTime = os.time();
		--print(os.time());
		--PTimeH = nowTime["hour"];
		--PTimeM = nowTime["min"];
		return;
	end
	--宠物说话
	if(T_status==3) then
		local nowTime = os.time();
		r = math.random(2,20);
		nowTalknotesNum = r;
		if(ans_list[1]~=nil and nowTime - PTime<=60) then
			Item_Rand = math.random(1,15);
			P_E_Rand = math.random(1,3);
			local PlayerInMap = Char.GetData(ans_list[1],%对象_地图类型%);
			local PlayerInFloor = Char.GetData(ans_list[1],%对象_地图%);
			local PlayerInX = Char.GetData(ans_list[1],%对象_X%);
			local PlayerInY = Char.GetData(ans_list[1],%对象_Y%);
			local pet = Char.GetPet(ans_list[1],0);
			local ImageID = Char.GetData(pet, %对象_形象%);
			if (PetTalkModelNpc ~= nil or index ~= nil)then
				--PetTalkModelNpc = PetTalkModelNpc_Create(Char.GetData(pet,%对象_名字%), ImageID, PlayerInMap, PlayerInFloor, PlayerInX, PlayerInY-1, 4);
				NLG.SetAction(PetTalkModelNpc, 9);
				NLG.UpChar(PetTalkModelNpc);
			end
			if (VaildChar(pet)==true and satiety < 6) then
				NLG.SystemMessage(ans_list[1],""..Char.GetData(pet,%对象_名字%)..":"..talknotes[1][1].."");
			end
			if (VaildChar(pet)==true and satiety >= 6) then
				touch_pet_daily_user_count[1][Playerkey(_PlayerIndex)] = getcountless + 1;
				NLG.SystemMessage(ans_list[1],""..Char.GetData(pet,%对象_名字%)..":"..talknotes[r][1].."");
				local sum_s = satiety - 6;
				local sum_i = intimacy + 6;
				pItemIndex = Char.GetItemIndex(ans_list[1], Char.FindItemId(ans_list[1],70188));
				pItemID = Item.GetData(pItemIndex, 0);
				
				if (VaildChar(pItemIndex) == true and pItemID==70188) then
					local satiety = Item.SetData(pItemIndex,%道具_子参一%,sum_s);
					Item.SetData(pItemIndex,%道具_子参二%,sum_i);
					local intimacy = Item.GetData(pItemIndex,%道具_子参二%);
					Item.UpItem(ans_list[1],p);
					if (intimacy >= 100) then
					Item.SetData(pItemIndex,%道具_子参二%,100);
					local intimacy = Item.GetData(pItemIndex,%道具_子参二%);
					Item.UpItem(ans_list[1],p);
					end
				end
				if (Item_Rand == 1) then
				Char.GiveItem(ans_list[1],69001,1);
				end
				if (Item_Rand == 2) then
				Char.GiveItem(ans_list[1],69002,1);
				end
				if (Item_Rand == 3) then
				Char.GiveItem(ans_list[1],69003,1);
				end
				if (Item_Rand == 4) then
				Char.GiveItem(ans_list[1],69004,1);
				end
			end
			if(P_E_Rand == 1 or P_E_Rand == 2 and intimacy >= 20) then
				local rexp = math.random(500,1000 * Char.GetData(pet,%对象_等级%));
				local Pet_Exp = Char.GetData(pet,%对象_经验%);
				local Pet_Exp2 = Pet_Exp + rexp;
				Char.SetData(pet,%对象_经验%,Pet_Exp2);
				Pet.UpPet(ans_list[1],pet);
				NLG.SystemMessage(ans_list[1],""..Char.GetData(pet,%对象_名字%).."获得"..rexp.."经验!");
			end
			if(P_E_Rand == 1 or P_E_Rand == 2 and intimacy >= 50) then
				local rexp = math.random(1000,1500 * Char.GetData(pet,%对象_等级%));
				local Pet_Exp = Char.GetData(pet,%对象_经验%);
				local Pet_Exp2 = Pet_Exp + rexp;
				Char.SetData(pet,%对象_经验%,Pet_Exp2);
				Pet.UpPet(ans_list[1],pet);
				NLG.SystemMessage(ans_list[1],""..Char.GetData(pet,%对象_名字%).."获得"..rexp.."经验!");
			end
			if(P_E_Rand == 3 and intimacy >= 80) then
				local rexp = math.random(2000,2500 * Char.GetData(pet,%对象_等级%));
				local Pet_Exp = Char.GetData(pet,%对象_经验%);
				local Pet_Exp2 = Pet_Exp + rexp;
				Char.SetData(pet,%对象_经验%,Pet_Exp2);
				Pet.UpPet(ans_list[1],pet);
				NLG.SystemMessage(ans_list[1],""..Char.GetData(pet,%对象_名字%).."获得"..rexp.."经验!");
			end
			T_status = 0;
			PTime = 0;
		end
		if(nowTime -PTime == 60 and T_status ~= 0) then
		--if(ans_list[1]==nil and nowTime - PTime ==60) then
			T_status = 0;
			PTime = 0;
			--NLG.SystemMessage(-1,"[系统]宠物没得到主人们的回应");
		end
	end
end

function pettalkStart()
	T_status = 2;
	M_status = 1; 
end

function checkAns(PlayA,msg)
	if(T_status~=3)then
		--NLG.SystemMessage(PlayA,"[系统]宠物说话功能还未开启!");
		return;
	end
	--if(T_status==3)then
	--	NLG.SystemMessage(PlayA,"[系统]您的回应已经传达给宠物!");
	--end
	table.insert(ans_list,PlayA);

end
function PetTalkModelNpc_Create(Name, Image, MapType, MapID, PosX, PosY, Dir)
	local PetTalkModelNpc = NL.CreateNpc("./lua/System/BaseModule/Base.lua", "Myinit");
	Char.SetData( PetTalkModelNpc, %对象_形象%, Image);
	Char.SetData( PetTalkModelNpc, %对象_原形%, Image);
	Char.SetData( PetTalkModelNpc, %对象_地图类型%, MapType);
	Char.SetData( PetTalkModelNpc, %对象_地图%, MapID);
	Char.SetData( PetTalkModelNpc, %对象_X%, PosX);
	Char.SetData( PetTalkModelNpc, %对象_Y%, PosY);
	Char.SetData( PetTalkModelNpc, %对象_方向%, Dir);
	Char.SetData( PetTalkModelNpc, %对象_原名%, Name);
	NLG.UpChar(PetTalkModelNpc)
	--Char.SetTalkedEvent(nil, "PetTalkModelNpc_Talked", PetTalkModelNpc)
	--Char.SetWindowTalkedEvent(nil, "PetTalkModelNpc_WindowTalked", PetTalkModelNpc)
	Char.SetLoopEvent(nil, "PetTalkModelNpcLoop", PetTalkModelNpc, 10000);	
	return PetTalkModelNpc;
end
function PetTalkModelNpcLoop(index)
        --暂时宠模初始
	if(M_status==0 and index ~= nil) then
		NL.DelNpc(index)
		index = nil
	end
	M_status = 1;
	--暂时宠模准备
	if(M_status==1 and index ~= nil) then
		M_status = 2;
		MTime = os.time();
		NLG.SetAction(index,3);
		NLG.WalkMove(index,5);
		NLG.UpChar(index);
	end
	if(M_status==2 and index ~= nil) then
		M_status = 3;
		MTime_1 = os.time();
		if (MTime_1 - MTime <=1) then
		NLG.SetAction(index,3);
		NLG.WalkMove(index,3);
		NLG.UpChar(index);
		end
	end
	if(M_status==3 and index ~= nil) then
		M_status = 4;
		MTime_2 = os.time();
		if (MTime_2 - MTime_1 <=1) then
		NLG.SetAction(index,3);
		NLG.WalkMove(index,1);
		NLG.UpChar(index);
		end
	end
	if(M_status==4 and index ~= nil) then
		M_status = 5;
		MTime_3 = os.time();
		if (MTime_3 - MTime_2 <=1) then
		NLG.SetAction(index,3);
		NLG.WalkMove(index,7);
		NLG.UpChar(index);
		end
	end
	--删除暂时宠模
	if(M_status==5) then
		local now_MTime = os.time();
		if(now_MTime - MTime_3 >= 1) then
			M_status = 1;
			MTime_3 = 0;
		end
		if(now_MTime - MTime_3 <= 1) then
			M_status = 0;
			MTime_3 = 0;
		end
	end
end