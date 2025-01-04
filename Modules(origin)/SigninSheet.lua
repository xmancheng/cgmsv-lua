--模块类
local Module = ModuleBase:createModule('SigninSheet')

local count_Max = 1;		--次数
--奖励分类
local rewards_list = {};
rewards_list[1] = {"四魂之玉",70194,100};
rewards_list[2] = {"四魂之玉",70194,100};
rewards_list[3] = {"四魂之玉",70194,100};
rewards_list[4] = {"四魂之玉",70194,100};
rewards_list[5] = {"四魂之玉",70194,100};
rewards_list[6] = {"四魂之玉",70194,100};
rewards_list[7] = {"四魂之玉",70194,100};
rewards_list[14] = {"四魂之玉",70194,100};
rewards_list[30] = {"四魂之玉",70194,100};

--剩余次数计算
local signin_daily_rewards_user = {};
local signin_daily_rewards_user_count = {};
signin_daily_rewards_user_count[1] = {};	--个次数计算
--signin_daily_rewards_user_count[2] = {};	--个次数计算

------------------------------------------------------------------------------------------------------------------------
--功能函数
function Time_Check(_obj)	--判定是否一天时间已过
	if (os.date("%d",_obj) ~= os.date("%d",os.time())) then 
		return true;
	end
	return false;
end

function Time_Out(player)	--每日24点为判定超时
	local _obj = signin_daily_rewards_user[Playerkey(player)];
	--如果首次登录
	if (_obj == nil) then 
		signin_daily_rewards_user[Playerkey(player)] = os.time();
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

------------------------------------------------------------------------------------------------------------------------
--加载模块
function Module:onLoad()
	self:logInfo('load')
	self.signInNPC = self:NPC_createNormal('簽到管理員',106602,{x=34, y=33, mapType=0, map=777, direction=6})
	self:NPC_regWindowTalkedEvent(self.signInNPC,Func.bind(self.click,self))
	self:NPC_regTalkedEvent(self.signInNPC,Func.bind(self.facetonpc,self))
end

--远程按钮UI呼叫
function Module:signInInfo(npc, player)
	if (Time_Out(player)) then
		signin_daily_rewards_user[Playerkey(player)] = os.time();
		for i=1,#signin_daily_rewards_user_count do			--每日副本个别次数
			signin_daily_rewards_user_count[i][Playerkey(player)] = nil;
		end
	end

	local rewardscount = signin_daily_rewards_user_count[1][Playerkey(player)];
	if (rewardscount == nil or rewardscount ==0) then
		rewardscount = 0;
		signin_daily_rewards_user_count[1][Playerkey(player)] = 0;

		local daily = tonumber(os.date("%w",os.time()));
		if(os.date("%w",os.time()) =="0")then daily =7; end
		local ItemsetIndex = Data.ItemsetGetIndex(rewards_list[daily][2]);
		local Item_name= Data.ItemsetGetData( ItemsetIndex, CONST.ITEMSET_TRUENAME);
		local Item_image= Data.ItemsetGetData( ItemsetIndex, CONST.ITEMSET_BASEIMAGENUMBER);
		local imageText = "@g,"..Item_image..",5,5,4,0@"

		local Player_image = Char.GetData(player, CONST.对象_形象);
		local imageText_p = "@g,"..Player_image..",17,7,6,6@"

		local msg = "　　　　　　　　【每日簽到系統】\\n"
			.. "　　　$1依照簽到當下的星期日子給予獎勵\\n"
		msg = msg .. imageText .. "\\n\\n　　　　　　　　　　$5" .. Item_name .. "\\n\\n　　　　　　　　　　　" .. rewards_list[daily][3] .. " 個" .. imageText_p

		local SignInCheck = Char.GetExtData(player, '累积签到') or 0;
		msg = msg .. "\\n\\n　　　　　　　　　$4累積簽到:"..SignInCheck.."天"
		NLG.ShowWindowTalked(player, self.signInNPC, CONST.窗口_信息框, CONST.按钮_是否, 1, msg);
	elseif (rewardscount >= count_Max) then
		NLG.SystemMessage(player, "[系統]您已領取每日簽到獎勵。");
		return;
	end
end

function Module:click(npc,player,_seqno,_select,_data)--窗口中点击触发
	local column = tonumber(_data)
	local page = tonumber(_seqno)
	local warpPage = page;
	--上页16 下页32 取消2
	if _select > 0 then
		if (_seqno == 1 and _select == CONST.按钮_否) then
			return;
		elseif (_seqno == 1 and _select == CONST.按钮_是) then
			--local selectitem = tonumber(_data);

			if (Char.GetData(player,CONST.CHAR_等级)<20) then	--等级判定
				NLG.SystemMessage(player, "[系統]您不夠20等級無法領取。");
				return;
			end
			if (Char.ItemSlot(player)>18) then
				NLG.SystemMessage(player, "[系統]請留出背包領取簽到獎勵！");
				return;
			end

			local rewardscount = signin_daily_rewards_user_count[1][Playerkey(player)];
			if (rewardscount == nil) then
				rewardscount = 0;
				signin_daily_rewards_user_count[1][Playerkey(player)] = 0;
			end

			if (rewardscount >= count_Max) then
				NLG.SystemMessage(player, "[系統]您已領取每日簽到獎勵。");
				return;
			else
				signin_daily_rewards_user_count[1][Playerkey(player)] = rewardscount + 1;
				if(os.date("%w",os.time()) =="0")then Char.GiveItem(player,rewards_list[7][2],rewards_list[7][3]) end
				if(os.date("%w",os.time()) =="1")then Char.GiveItem(player,rewards_list[1][2],rewards_list[1][3]) end
				if(os.date("%w",os.time()) =="2")then Char.GiveItem(player,rewards_list[2][2],rewards_list[2][3]) end
				if(os.date("%w",os.time()) =="3")then Char.GiveItem(player,rewards_list[3][2],rewards_list[3][3]) end
				if(os.date("%w",os.time()) =="4")then Char.GiveItem(player,rewards_list[4][2],rewards_list[4][3]) end
				if(os.date("%w",os.time()) =="5")then Char.GiveItem(player,rewards_list[5][2],rewards_list[5][3]) end
				if(os.date("%w",os.time()) =="6")then Char.GiveItem(player,rewards_list[6][2],rewards_list[6][3]) end
				local SignInCheck = Char.GetExtData(player,'累积签到') or 0;
				if (SignInCheck<30) then
					Char.SetExtData(player,'累积签到',SignInCheck+1);
					NLG.UpChar(player);
				else
					Char.SetExtData(player,'累积签到',0);
					NLG.UpChar(player);
				end
				if (SignInCheck==13) then
					Char.GiveItem(player,rewards_list[14][2],rewards_list[14][3]);
				elseif (SignInCheck==29) then
					Char.GiveItem(player,rewards_list[30][2],rewards_list[30][3]);
					Char.SetExtData(player,'累积签到',0);
					NLG.UpChar(player);
				end
			end
		end
	else

	end
end

function Module:facetonpc(npc,player)
	if NLG.CanTalk(npc,player) == true then
		if (Time_Out(player)) then
			signin_daily_rewards_user[Playerkey(player)] = os.time();
			for i=1,#signin_daily_rewards_user_count do			--每日副本个别次数
				signin_daily_rewards_user_count[i][Playerkey(player)] = nil;
			end
		end

		local rewardscount = signin_daily_rewards_user_count[1][Playerkey(player)];
		if (rewardscount == nil or rewardscount ==0) then
			rewardscount = 0;
			signin_daily_rewards_user_count[1][Playerkey(player)] = 0;

			local daily = tonumber(os.date("%w",os.time()));
			if(os.date("%w",os.time()) =="0")then daily =7; end
			local ItemsetIndex = Data.ItemsetGetIndex(rewards_list[daily][2]);
			local Item_name= Data.ItemsetGetData( ItemsetIndex, CONST.ITEMSET_TRUENAME);
			local Item_image= Data.ItemsetGetData( ItemsetIndex, CONST.ITEMSET_BASEIMAGENUMBER);
			local imageText = "@g,"..Item_image..",5,5,4,0@"

			local Player_image = Char.GetData(player, CONST.对象_形象);
			local imageText_p = "@g,"..Player_image..",17,7,6,6@"

			local msg = "　　　　　　　　【每日簽到系統】\\n"
				.. "　　　$1依照簽到當下的星期日子給予獎勵\\n"
			msg = msg .. imageText .. "\\n\\n　　　　　　　　　　$5" .. Item_name .. "\\n\\n　　　　　　　　　　　" .. rewards_list[daily][3] .. " 個" .. imageText_p

			local SignInCheck = Char.GetExtData(player, '累积签到') or 0;
			msg = msg .. "\\n\\n　　　　　　　　　$4累積簽到:"..SignInCheck.."天"
			NLG.ShowWindowTalked(player, self.signInNPC, CONST.窗口_信息框, CONST.按钮_是否, 1, msg);
		elseif (rewardscount >= count_Max) then
			NLG.SystemMessage(player, "[系統]您已領取每日簽到獎勵。");
			return;
		end
	end
	return
end

--卸载模块
function Module:onUnload()
	self:logInfo('unload')
end
return Module
