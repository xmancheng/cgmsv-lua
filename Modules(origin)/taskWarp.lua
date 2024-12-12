--模块类
local Module = ModuleBase:createModule('taskWarp')

--local count_Max = 2;		--副本次数
--副本分类
local warp_map_name = {};
local warp_map_point = {};
local warp_map_lvlimit = {};
local warp_map_payfor = {};
local warp_map_relimit = {};
local warp_map_count_Max = {};
--剩余次数计算
local warp_map_daily_user = {};
local warp_map_daily_user_count = {};
warp_map_daily_user_count[1] = {};	--个次数计算
warp_map_daily_user_count[2] = {};	--个次数计算
warp_map_daily_user_count[3] = {};	--个次数计算
warp_map_daily_user_count[4] = {};	--个次数计算
warp_map_daily_user_count[5] = {};	--个次数计算
warp_map_daily_user_count[6] = {};	--个次数计算
warp_map_daily_user_count[7] = {};	--个次数计算
warp_map_daily_user_count[8] = {};	--个次数计算
warp_map_daily_user_count[9] = {};	--个次数计算

warp_map_name[1] = "惡靈古堡";
warp_map_point[1] = {1921,16,12};
warp_map_lvlimit[1] = 60;
warp_map_payfor[1] = 10000;
warp_map_relimit[1] =0;
warp_map_count_Max[1] = 3;

warp_map_name[2] = "春風的熊(希望水晶)";
warp_map_point[2] = {1903,35,40};
warp_map_lvlimit[2] = 50;
warp_map_payfor[2] = 20000;
warp_map_relimit[2] =0;
warp_map_count_Max[2] = 2;

warp_map_name[3] = "白雪公主(技能草)";
warp_map_point[3] = {1904,5,9};
warp_map_lvlimit[3] = 50;
warp_map_payfor[3] = 20000;
warp_map_relimit[3] =0;
warp_map_count_Max[3] = 2;

warp_map_name[4] = "大墳墓";
warp_map_point[4] = {1908,10,13};
warp_map_lvlimit[4] = 70;
warp_map_payfor[4] = 20000;
warp_map_relimit[4] =0;
warp_map_count_Max[4] = 2;

warp_map_name[5] = "合擊鼠王";
warp_map_point[5] = {1910,10,14};
warp_map_lvlimit[5] = 70;
warp_map_payfor[5] = 20000;
warp_map_relimit[5] =0;
warp_map_count_Max[5] = 5;

warp_map_name[6] = "神魔之塔";
warp_map_point[6] = {9001,8,10};
warp_map_lvlimit[6] = 50;
warp_map_payfor[6] = 10000;
warp_map_relimit[6] =0;
warp_map_count_Max[6] = 5;

warp_map_name[7] = "靈魂之殿";
warp_map_point[7] = {25006,52,227};
warp_map_lvlimit[7] = 60;
warp_map_payfor[7] = 10000;
warp_map_relimit[7] =1;
warp_map_count_Max[7] = 5;

warp_map_name[8] = "幽暗冥界";
warp_map_point[8] = {7350,7,9};
warp_map_lvlimit[8] = 120;
warp_map_payfor[8] = 10000;
warp_map_relimit[8] =0;
warp_map_count_Max[8] = 5;

warp_map_name[9] = "深海一萬里";
warp_map_point[9] = {32744,202,36};
warp_map_lvlimit[9] = 101;
warp_map_payfor[9] = 10000;
warp_map_relimit[9] =0;
warp_map_count_Max[9] = 2;
------------------------------------------------------------------------------------------------------------------------
--功能函数
function Time_Check(_obj)	--判定是否一天时间已过
	if (os.date("%d",_obj) ~= os.date("%d",os.time())) then 
		return true;
	end
	return false;
end

function Time_Out(player)	--每日24点为判定超时
	local _obj = warp_map_daily_user[Playerkey(player)];
	--如果首次登录
	if (_obj == nil) then 
		warp_map_daily_user[Playerkey(player)] = os.time();
		return true;
	else
		return Time_Check(_obj);
	end
end

function Playerkey(player)
	if (player ~= nil) then
		local fanhui1 = Char.GetData(player,CONST.CHAR_名字);
		local fanhui2 = Char.GetData(player,CONST.CHAR_CDK);
		if (fanhui1 == nil or fanhui2 == nil) then
			if(fanhui2 == nil) then
				fanhui2 = "bus"
			end
		end
		return fanhui1..fanhui2;
	else
		return 1;
	end
end

function mykgold(player,gold)
	local tjb = Char.GetData(player,CONST.对象_金币);
	tjb = tjb - gold; 
	if (tjb >= 0) then
		Char.SetData(player,CONST.对象_金币,tjb);
		NLG.UpChar(player);
		NLG.SystemMessage(player,"交出了"..gold.." G魔幣。");
		return true;
	end
	return false;
end

------------------------------------------------------------------------------------------------------------------------
--加载模块
function Module:onLoad()
	self:logInfo('load')
	local warpNPC = self:NPC_createNormal('每日挑戰',99086,{x=226, y=83, mapType=0, map=1000, direction=6})
	self:NPC_regWindowTalkedEvent(warpNPC,Func.bind(self.click,self))
	self:NPC_regTalkedEvent(warpNPC,Func.bind(self.facetonpc,self))
end

local function calcWarp()--计算翻页
	local page = math.modf(#warp_map_name/8) + 1
	local remainder = math.fmod(#warp_map_name,8)
	return page,remainder
end

function Module:click(npc,player,_seqno,_select,_data)--窗口中点击触发
	local column = tonumber(_data)
	local page = tonumber(_seqno)
	local warpPage = page;
	if (page==1000) then	--回到主菜单
		self:facetonpc(npc, player);
		return;
	end

	local winMsg = "1|\\n這裡是副本管理系統，你...要去哪裡...讀取中...\\n";
	local winButton = CONST.BUTTON_关闭;
	local totalPage, remainder = calcWarp()
	--上页16 下页32 取消2
	if _select > 0 then
		--多页按钮
		if _select == 32 then
			warpPage = warpPage + 1
			if (warpPage == totalPage) or (warpPage == (totalPage - 1) and remainder == 0) then
				winButton = 18	--上取消
			else
				winButton = 50	--上下取消
			end
		elseif _select == 16 then
			warpPage = warpPage - 1
			if warpPage == 1 then
				winButton = 34	--下取消
			else
				winButton = 50	--上下取消
			end
		elseif _select == 2 then
			warpPage = 1
			return
		end
		--副本次数计算
		if (Time_Out(player)) then
			warp_map_daily_user[Playerkey(player)] = os.time();
			for i=1,#warp_map_daily_user_count do			--每日副本个别次数
				warp_map_daily_user_count[i][Playerkey(player)] = nil;
			end
		end
		--多页内容
		local count = 8 * (warpPage - 1)
		if warpPage == totalPage then
			for i = 1 + count, remainder + count do
				local tcount = warp_map_daily_user_count[i][Playerkey(player)];
				if (tcount == nil) then
					tcount = warp_map_count_Max[i];
				else
					tcount = warp_map_count_Max[i] - tcount;
				end
				winMsg = winMsg .. " "..warp_map_name[i].."   <金額"..warp_map_payfor[i].."G>  剩餘<"..tcount..">次\\n"
			end
		else
			for i = 1 + count, 8 + count do
				local tcount = warp_map_daily_user_count[i][Playerkey(player)];
				if (tcount == nil) then
					tcount = warp_map_count_Max[i];
				else
					tcount = warp_map_count_Max[i] - tcount;
				end
				winMsg = winMsg .. " "..warp_map_name[i].."   <金額"..warp_map_payfor[i].."G>  剩餘<"..tcount..">次\\n"
			end
		end
		NLG.ShowWindowTalked(player,npc,CONST.窗口_选择框, winButton, warpPage, winMsg);
	else
		if (_seqno >= 1 and select == CONST.按钮_关闭) then
			return;
		elseif (_seqno >= 1 and column >= 1) then
			--local selectitem = tonumber(_data);
			local count = 8 * (warpPage - 1) + column;

			local getlvlit = warp_map_lvlimit[count];
			if (getlvlit > Char.GetData(player,CONST.CHAR_等级)) then	--等级判定
				NLG.SystemMessage(player, "您的等級不夠，"..getlvlit.."級再來吧！");
				return;
			end
			if (Char.PartyNum(player)>1) then			--组队判定
				NLG.SystemMessage(player, "[系統]副本須要單人進行傳送！！");
				return;
			end
			local relvlit = warp_map_relimit[count];
			if (relvlit > Char.GetData(player,CONST.对象_名色)) then	--转生判定
				NLG.SystemMessage(player, "您的轉生次數不夠，"..relvlit.."次轉生後再來吧！");
				return;
			end

			local getcountless = warp_map_daily_user_count[count][Playerkey(player)];
			if (getcountless ==nil) then
				getcountless = 0;
				warp_map_daily_user_count[count][Playerkey(player)] = 0;
			end
			if (getcountless >= warp_map_count_Max[count]) then
				local msg = "\\n\\n\\n@c您的次數已經用完了。"
				NLG.ShowWindowTalked(player,npc,CONST.窗口_信息框,CONST.按钮_关闭, 1000, msg);
				return;
			end

			if (mykgold(player, warp_map_payfor[count])) then
				warp_map_daily_user_count[count][Playerkey(player)] = getcountless + 1;
				Char.DischargeParty(player);
				Char.Warp(player,0, warp_map_point[count][1], warp_map_point[count][2], warp_map_point[count][3]);
			else
				NLG.SystemMessage(player, "\\n\\n\\n您的魔幣不夠。");
				return;
			end
		end
	end
end

function Module:facetonpc(npc,player)
	if NLG.CanTalk(npc,player) == true then
		if (Time_Out(player)) then
			warp_map_daily_user[Playerkey(player)] = os.time();
			for i=1,#warp_map_daily_user_count do			--每日副本个别次数
				warp_map_daily_user_count[i][Playerkey(player)] = nil;
			end
		end

		local winButton = CONST.BUTTON_关闭;
		local winMsg = "1|\\n這裡是副本管理系統，你...要去哪裡...讀取中...\\n";
		for i=1, 8 do

			local tcount = warp_map_daily_user_count[i][Playerkey(player)];
			if (tcount == nil) then
				tcount = warp_map_count_Max[i];
			else
				tcount = warp_map_count_Max[i] - tcount;
			end
			winMsg = winMsg .. " "..warp_map_name[i].."   <金額"..warp_map_payfor[i].."G>  剩餘<"..tcount..">次\\n";
			if (i>=8) then
				winButton = CONST.BUTTON_下取消;
			end
		end
		NLG.ShowWindowTalked(player,npc,CONST.窗口_选择框, winButton, 1, winMsg);
	end
	return
end

--卸载模块
function Module:onUnload()
	self:logInfo('unload')
end
return Module
