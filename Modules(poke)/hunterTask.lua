--模块类
local Module = ModuleBase:createModule('hunterTask')

local hunter_list = {};

--猎杀分类
hunter_list[1] = {};
hunter_list[1].target = {}
hunter_list[1].reward = {};
hunter_list[1].reward.item = {};
hunter_list[1].name = "《擾亂營地的皮丘》";
hunter_list[1].level_min = 1;
hunter_list[1].level_max = 30;
hunter_list[1].limit = 5;
hunter_list[1].target[1] = {};
hunter_list[1].target[1].name = "皮丘";
hunter_list[1].target[1].amount = 10;
hunter_list[1].reward.gold = 2000;
hunter_list[1].reward.lp = 1500;
hunter_list[1].reward.fp = 1500;
hunter_list[1].reward.item[1] = {id=74098, name="獵殺幣", amount=5,};

hunter_list[2] = {};
hunter_list[2].target = {}
hunter_list[2].reward = {};
hunter_list[2].reward.item = {};
hunter_list[2].name = "《營地的小妖精們》";
hunter_list[2].level_min = 1;
hunter_list[2].level_max = 145;
hunter_list[2].limit = 1;
hunter_list[2].target[1] = {};
hunter_list[2].target[1].name = "寶寶丁";
hunter_list[2].target[1].amount = 100;
hunter_list[2].target[2] = {};
hunter_list[2].target[2].name = "皮寶寶";
hunter_list[2].target[2].amount = 100;
hunter_list[2].reward.gold = 1200;
hunter_list[2].reward.lp = 2500;
hunter_list[2].reward.fp = 2500;
hunter_list[2].reward.item[1] = {id=74095, name="1階進化石", amount=1,};

hunter_list[3] = {};
hunter_list[3].target = {}
hunter_list[3].reward = {};
hunter_list[3].reward.item = {};
hunter_list[3].name = "《分歧路上的昆蟲》";
hunter_list[3].level_min = 10;
hunter_list[3].level_max = 40;
hunter_list[3].limit = 3;
hunter_list[3].target[1] = {};
hunter_list[3].target[1].name = "巴大蝶";
hunter_list[3].target[1].amount = 15;
hunter_list[3].target[2] = {};
hunter_list[3].target[2].name = "大針鋒";
hunter_list[3].target[2].amount = 15;
hunter_list[3].reward.gold = 900;
hunter_list[3].reward.lp = 1700;
hunter_list[3].reward.fp = 1700;
hunter_list[3].reward.item[1] = {id=74098, name="獵殺幣", amount=5,};

hunter_list[4] = {};
hunter_list[4].target = {}
hunter_list[4].reward = {};
hunter_list[4].reward.item = {};
hunter_list[4].name = "《沙漠環境統治者》";
hunter_list[4].level_min = 55;
hunter_list[4].level_max = 145;
hunter_list[4].limit = 3;
hunter_list[4].target[1] = {};
hunter_list[4].target[1].name = "尖牙陸鯊";
hunter_list[4].target[1].amount = 10;
hunter_list[4].target[2] = {};
hunter_list[4].target[2].name = "班基拉斯";
hunter_list[4].target[2].amount = 10;
hunter_list[4].reward.gold = 2000;
hunter_list[4].reward.lp = 4000;
hunter_list[4].reward.fp = 4000;
hunter_list[4].reward.item[1] = {id=74098, name="獵殺幣", amount=15,};

hunter_list[5] = {};
hunter_list[5].target = {}
hunter_list[5].reward = {};
hunter_list[5].reward.item = {};
hunter_list[5].name = "《無人發電廠騷動》";
hunter_list[5].level_min = 65;
hunter_list[5].level_max = 145;
hunter_list[5].limit = 3;
hunter_list[5].target[1] = {};
hunter_list[5].target[1].name = "茸茸羊";
hunter_list[5].target[1].amount = 20;
hunter_list[5].target[2] = {};
hunter_list[5].target[2].name = "皮卡丘";
hunter_list[5].target[2].amount = 50;
hunter_list[5].reward.gold = 2000;
hunter_list[5].reward.lp = 4000;
hunter_list[5].reward.fp = 4000;
hunter_list[5].reward.item[1] = {id=74098, name="獵殺幣", amount=15,};

hunter_list[6] = {};
hunter_list[6].target = {}
hunter_list[6].reward = {};
hunter_list[6].reward.item = {};
hunter_list[6].name = "《遺跡中的守衛者》";
hunter_list[6].level_min = 80;
hunter_list[6].level_max = 145;
hunter_list[6].limit = 2;
hunter_list[6].target[1] = {};
hunter_list[6].target[1].name = "牙牙";
hunter_list[6].target[1].amount = 50;
hunter_list[6].target[2] = {};
hunter_list[6].target[2].name = "利歐路";
hunter_list[6].target[2].amount = 50;
hunter_list[6].reward.gold = 4000;
hunter_list[6].reward.lp = 6500;
hunter_list[6].reward.fp = 6500;
hunter_list[6].reward.item[1] = {id=74096, name="2階進化石", amount=2,};

hunter_list[7] = {};
hunter_list[7].target = {}
hunter_list[7].reward = {};
hunter_list[7].reward.item = {};
hunter_list[7].name = "《來自雪山拜訪者》";
hunter_list[7].level_min = 90;
hunter_list[7].level_max = 145;
hunter_list[7].limit = 1;
hunter_list[7].target[1] = {};
hunter_list[7].target[1].name = "雷吉艾斯";
hunter_list[7].target[1].amount = 1;
hunter_list[7].reward.gold = 5000;
hunter_list[7].reward.lp = 10000;
hunter_list[7].reward.fp = 10000;
hunter_list[7].reward.item[1] = {id=74098, name="獵殺幣", amount=20,};

hunter_list[8] = {};
hunter_list[8].target = {}
hunter_list[8].reward = {};
hunter_list[8].reward.item = {};
hunter_list[8].name = "《大地化身的力量》";
hunter_list[8].level_min = 90;
hunter_list[8].level_max = 145;
hunter_list[8].limit = 1;
hunter_list[8].target[1] = {};
hunter_list[8].target[1].name = "固拉多";
hunter_list[8].target[1].amount = 1;
hunter_list[8].reward.gold = 5000;
hunter_list[8].reward.lp = 10000;
hunter_list[8].reward.fp = 10000;
hunter_list[8].reward.item[1] = {id=74098, name="獵殺幣", amount=20,};

hunter_list[9] = {};
hunter_list[9].target = {}
hunter_list[9].reward = {};
hunter_list[9].reward.item = {};
hunter_list[9].name = "《海洋化身的力量》";
hunter_list[9].level_min = 90;
hunter_list[9].level_max = 145;
hunter_list[9].limit = 1;
hunter_list[9].target[1] = {};
hunter_list[9].target[1].name = "蓋歐卡";
hunter_list[9].target[1].amount = 1;
hunter_list[9].reward.gold = 5000;
hunter_list[9].reward.lp = 10000;
hunter_list[9].reward.fp = 10000;
hunter_list[9].reward.item[1] = {id=74098, name="獵殺幣", amount=20,};

hunter_list[10] = {};
hunter_list[10].target = {}
hunter_list[10].reward = {};
hunter_list[10].reward.item = {};
hunter_list[10].name = "《天空化身的力量》";
hunter_list[10].level_min = 90;
hunter_list[10].level_max = 145;
hunter_list[10].limit = 1;
hunter_list[10].target[1] = {};
hunter_list[10].target[1].name = "烈空座";
hunter_list[10].target[1].amount = 1;
hunter_list[10].reward.gold = 5000;
hunter_list[10].reward.lp = 10000;
hunter_list[10].reward.fp = 10000;
hunter_list[10].reward.item[1] = {id=74098, name="獵殺幣", amount=20,};

hunter_list[11] = {};
hunter_list[11].target = {}
hunter_list[11].reward = {};
hunter_list[11].reward.item = {};
hunter_list[11].name = "《鳳王直屬親衛隊》";
hunter_list[11].level_min = 90;
hunter_list[11].level_max = 145;
hunter_list[11].limit = 1;
hunter_list[11].target[1] = {};
hunter_list[11].target[1].name = "雷公";
hunter_list[11].target[1].amount = 1;
hunter_list[11].target[2] = {};
hunter_list[11].target[2].name = "炎帝";
hunter_list[11].target[2].amount = 1;
hunter_list[11].target[3] = {};
hunter_list[11].target[3].name = "水君";
hunter_list[11].target[3].amount = 1;
hunter_list[11].reward.gold = 15000;
hunter_list[11].reward.lp = 30000;
hunter_list[11].reward.fp = 30000;
hunter_list[11].reward.item[1] = {id=74097, name="超級進化石", amount=1,};

local hunter_list_count = #hunter_list
for i = 1, hunter_list_count do
	hunter_list[i].target.count = #hunter_list[i].target;
end
------------------------------------------------------------------------------------------------------------------------
--加载模块
function Module:onLoad()
	self:logInfo('load')
    self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self))
    self:regCallback('BattleStartEvent', Func.bind(self.OnbattleStartEventCallback, self))
    self:regCallback('BattleOverEvent', Func.bind(self.onBattleOver, self));
	self.hunterNPC = self:NPC_createNormal('德利行特',14630,{x=106, y=110, mapType=0, map=80010, direction=6})
	Char.SetData(self.hunterNPC,CONST.对象_ENEMY_PetFlg+2,0)--可穿透体
	self:NPC_regWindowTalkedEvent(self.hunterNPC,Func.bind(self.click,self))
	self:NPC_regTalkedEvent(self.hunterNPC,Func.bind(self.facetonpc,self))
end

--查询指令
function Module:handleTalkEvent(charIndex,msg,color,range,size)
	if(msg=="mission")then
		hunter_talk_check(charIndex,msg,color,range,size);
		return 0;
	elseif(msg=="/hunter")then
		hunter_callback_fartalk(charIndex, self.hunterNPC);
		return 0;
	end
	return 1;
end
--猎杀任务查询
function hunter_talk_check(player,msg,color,range,size)
	if( tonumber( Field.Get(player,"hunter_flag")) == 0 or tonumber( Field.Get( player, "hunter_flag")) == nil)then
		NLG.SystemMessage(player, "[懸賞任務]沒有接任務。");
	end
	if( tonumber( Field.Get(player, "hunter_flag")) == 1)then
		local i = tonumber( Field.Get(player, "hunter_ongoing_quest"));
		for j = 1, hunter_list[i].target.count do
			local message = "[懸賞任務]";
			message = message..
				"～"..hunter_list[i].name.."～獵殺"..
				hunter_list[i].target[j].name..
				"("..
				Field.Get( player, "hunter_target_"..j)..
				"/"..
				hunter_list[i].target[j].amount..
				")" ;
			NLG.SystemMessage( player, message);
		end
	end
	if( tonumber( Field.Get(player, "hunter_flag")) == 2)then
		NLG.SystemMessage(player, "[懸賞任務]任務已經完成，可以提交。");
	end
	return false;
end

local function calcWarp()--计算翻页
	local page = math.modf(#hunter_list/5) + 1
	local remainder = math.fmod(#hunter_list,5)
	return page,remainder
end

function Module:click(npc,player,_seqno,_select,_data)--窗口中点击触发
	local column = tonumber(_data)
	local page = tonumber(_seqno)
	local warpPage = page;
	local totalPage, remainder = calcWarp()
	--上页16 下页32 取消2
	if _select > 0 then
		if (_seqno>=1000 and _seqno<1100 and (_select==CONST.按钮_关闭 or _select==CONST.按钮_下一页 or _select==CONST.按钮_上一页)) then
			--多页按钮
			--print(warpPage)
			local warpPage = warpPage - 1000;
			local winButton = CONST.BUTTON_关闭;
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

			--多页内容
			local count = 5 * (warpPage - 1)
			if warpPage == totalPage then
				winMsg = "4|\\n　　〈每日獵殺管理系統 ...資料讀取中...〉\\n"
							.." 選擇想要獵殺的懸賞目標\\n"
							.." 指令mission可查詢任務當前進度:\\n";
				for i = 1 + count, remainder + count do
					winMsg = winMsg .. "\\n"..hunter_list[i].name.."...等級："..hunter_list[i].level_min.."～"..hunter_list[i].level_max;
				end
				NLG.ShowWindowTalked(player,npc,CONST.窗口_选择框, winButton, 1000+warpPage, winMsg);
			else
				winMsg = "4|\\n　　〈每日獵殺管理系統 ...資料讀取中...〉\\n"
							.." 選擇想要獵殺的懸賞目標\\n"
							.." 指令mission可查詢任務當前進度:\\n";
				for i = 1 + count, 5 + count do
					winMsg = winMsg .. "\\n"..hunter_list[i].name.."...等級："..hunter_list[i].level_min.."～"..hunter_list[i].level_max;
				end
				NLG.ShowWindowTalked(player,npc,CONST.窗口_选择框, winButton, 1000+warpPage, winMsg);
			end
		elseif (_seqno>1100 and _seqno<2000 and _select == CONST.按钮_是) then
			local nowevent = _seqno-1100;
			local level = Char.GetData(player,CONST.对象_等级);
			local i = nowevent;
			local flag = tonumber( Field.Get(player, "hunter_flag"));
			local lasttime = tonumber( Field.Get(player, "hunter_lasttime_"..i));
			local nowtime = tonumber(os.date( "%d",os.time()));
			local times = tonumber( Field.Get(player, "hunter_limit_"..i));
			if( times == nil)then
				times = 0;
			end
			if( lasttime == nowtime)then
				if( times >= hunter_list[i].limit)then
					NLG.SystemMessage(player, "[系統]超過一天內可完成的次數，請明日再來或者選擇其他任務。");
					return;
				end
			else
				Field.Set(player, "hunter_limit_"..i, 0);
				times = 0;
			end

			if( flag == 1 or flag == 2)then
				NLG.SystemMessage(player, "[系統]已經有正在進行的任務，或任務完成尚未提交。");
				return;
			end
			if( level < hunter_list[i].level_min or level > hunter_list[i].level_max)then
				NLG.SystemMessage(player, "[系統]等級條件不符，請選擇對應等級任務。");
				return;
			end
			Field.Set(player, "hunter_flag", tostring(1));
			Field.Set(player, "hunter_ongoing_quest", tostring(i));
			Field.Set(player, "hunter_lasttime_"..i, nowtime);
			Field.Set(player, "hunter_limit_"..i, times+1);
			for j = 1, hunter_list[i].target.count do
				Field.Set(player, "hunter_target_temporary_"..j, 0);
				Field.Set(player, "hunter_target_"..j, 0);
			end
			NLG.SystemMessage(player, "[系統]任務已接取成功。");
		elseif (_seqno==3000 and _select == CONST.按钮_是) then
			local quest = tonumber( Field.Get(player, "hunter_ongoing_quest"));
			for i = 1, #hunter_list[quest].reward.item do
				Char.GiveItem(player, hunter_list[quest].reward.item[i].id, hunter_list[quest].reward.item[i].amount);
			end

			Char.AddGold(player, hunter_list[quest].reward.gold);
			local lpPool = tonumber(Field.Get(player, 'LpPool')) or 0;
			local fpPool = tonumber(Field.Get(player, 'FpPool')) or 0;
			Field.Set(player, 'LpPool', tostring(lpPool + hunter_list[quest].reward.lp));
			Field.Set(player, 'FpPool', tostring(fpPool + hunter_list[quest].reward.fp));
			NLG.UpChar(player);

			Field.Set(player, "hunter_flag", 0);
			for i = 1, hunter_list[quest].target.count do
				Field.Set(player, "hunter_target_temporary_"..i, 0);
				Field.Set(player, "hunter_target_"..i, 0);
			end
			Field.Set(player, "hunter_ongoing_quest", 0);
			NLG.SystemMessage(player, "[系統]獲得以下獎勵："..hunter_action_reward_generate(quest));
		elseif (_seqno==4000 and _select == CONST.按钮_是) then
			local quest = tonumber( Field.Get(player, "hunter_ongoing_quest"));
			Field.Set(player, "hunter_flag", 0);
			for i = 1, hunter_list[quest].target.count do
				Field.Set(player, "hunter_target_temporary_"..i, 0);
				Field.Set(player, "hunter_target_"..i, 0);
			end
			Field.Set(player, "hunter_ongoing_quest", 0);
			Char.AddGold(player, -1000);
			NLG.SystemMessage(player, "任務已放棄，扣除魔幣1000。");
		end
	else
		if (_seqno >= 1 and select == CONST.按钮_关闭) then
			return;
		elseif (_seqno >= 1000 and column >= 1) then
			--print(column)
			local warpPage = _seqno - 1000;
			local nowevent = 5 * (warpPage - 1) + column;
			local lasttime = tonumber( Field.Get(player, "hunter_lasttime_"..nowevent));
			local nowtime = tonumber(os.date( "%d",os.time()));
			local times = tonumber( Field.Get(player, "hunter_limit_"..nowevent));
			if( times == nil or lasttime == nil or lasttime ~= nowtime)then
				times = 0;
			end

			local msg = "\\n任務名稱："..hunter_list[nowevent].name..
					"\\n等級限制："..hunter_list[nowevent].level_min.."～"..(hunter_list[nowevent].level_max) ..
					"\\n任務要求：";
			for i = 1, hunter_list[nowevent].target.count do
				msg = msg .. hunter_list[nowevent].target[i].name.."×"..hunter_list[nowevent].target[i].amount.." ";
			end

 			msg = msg .. "\\n任務獎勵："..hunter_action_reward_generate( nowevent);
			msg = msg .. "\\n每日任務限制："..times.."/"..hunter_list[nowevent].limit ..
				"\\n\\n☆注意：任務一旦接受，在完成之前變更放棄需處理費，如需放棄任務請查看已接任務列表！";
			NLG.ShowWindowTalked(player,npc,CONST.窗口_信息框,CONST.按钮_是否, 1100+nowevent, msg);
		elseif (_seqno == 1 and column >= 1) then
			--local selectitem = tonumber(_data);
			if (column==1) then	--查看任务列表
				if warpPage == totalPage then
					button = CONST.按钮_关闭;
				else
					button = CONST.按钮_下取消;
				end
				local msg = "4|\\n　　〈每日獵殺管理系統 ...資料讀取中...〉\\n"
							.." 選擇想要獵殺的懸賞目標\\n"
							.." 指令mission可查詢任務當前進度:\\n";
				for i = 1,5 do
					msg = msg .. "\\n"..hunter_list[i].name.."...等級："..hunter_list[i].level_min.."～"..hunter_list[i].level_max;
				end
				NLG.ShowWindowTalked(player,npc,CONST.窗口_选择框, button, 1001, msg);
			elseif (column==2) then	--查看已接任务
				local flag = tonumber( Field.Get(player, "hunter_flag"));
				local msg = nil;
				if( flag == nil or flag == 0)then
					msg = "　　〈每日獵殺管理系統 ...資料讀取中...〉\\n"
						.. "\\n　　　　　　沒有正在進行的任務。";
				else
					local ongoing = tonumber( Field.Get(player, "hunter_ongoing_quest"));
					local lasttime = tonumber( Field.Get(player, "hunter_lasttime_"..ongoing));
					local nowtime = tonumber(os.date( "%d",os.time()));
					local times = tonumber( Field.Get(player, "hunter_limit_"..ongoing));
					if( times == nil or lasttime == nil or lasttime ~= nowtime)then
						times = 0;
					end
		
					msg = "\\n任務名稱："..hunter_list[ongoing].name ..
							"\\n等級限制："..hunter_list[ongoing].level_min.."～"..(hunter_list[ongoing].level_max) ..
							"\\n任務要求：";
					for i = 1, hunter_list[ongoing].target.count do
						msg = msg .. hunter_list[ongoing].target[i].name.."（"..Field.Get(player, "hunter_target_"..i).."/"..hunter_list[ongoing].target[i].amount.."） ";
					end
					msg = msg .. "\\n任務獎勵："..hunter_action_reward_generate(ongoing);
					msg = msg .. "\\n每日任務限制："..times.."/"..hunter_list[ongoing].limit;
				end
				NLG.ShowWindowTalked(player,npc,CONST.窗口_信息框,CONST.按钮_确定, 2000, msg);
			elseif (column==3) then	--提交任务
				local flag = tonumber( Field.Get(player, "hunter_flag"));
				local button = CONST.按钮_关闭;
				if( flag == nil or flag == 0)then
					msg = "　　〈每日獵殺管理系統 ...資料讀取中...〉\\n"
						.. "\\n　　　　　　沒有接受任何任務。";
					button = CONST.按钮_关闭;
				elseif( flag == 1)then
					msg = "　　〈每日獵殺管理系統 ...資料讀取中...〉\\n"
						.. "\\n　　　　　　任務尚未完成。";
					button = CONST.按钮_关闭;
				elseif( flag == 2)then
					local number = tonumber( Field.Get(player, "hunter_ongoing_quest"));
					msg = "　　〈每日獵殺管理系統 ...資料讀取中...〉\\n"
						.. "\\n　　　　　　是否確定提交任務？" .. "\\n你將獲得："..hunter_action_reward_generate(number);
					button = CONST.按钮_是否;
				end
				NLG.ShowWindowTalked(player,npc,CONST.窗口_信息框, button, 3000, msg);
			elseif (column==4) then	--放弃任务
				local flag = tonumber( Field.Get(player, "hunter_flag"));
				local msg = nil;
				if( flag == 0 or flag == nil)then
					local msg = "　　〈每日獵殺管理系統 ...資料讀取中...〉\\n"
							.. "\\n　　　　　　沒有正在進行的任務。";
					NLG.ShowWindowTalked(player,npc,CONST.窗口_信息框, CONST.按钮_确定, 4000, msg);
					return;
				else
					local msg = "　　〈每日獵殺管理系統 ...資料讀取中...〉\\n"
							.."\\n 放棄任務需魔幣1000，且會計算入任務限制數量，你確定嗎？";
				NLG.ShowWindowTalked(player,npc,CONST.窗口_信息框,CONST.按钮_是否, 4000, msg);
				end
			end
		end
	end
end

function Module:facetonpc(npc,player)
	if NLG.CanTalk(npc,player) == true then
		local winButton = CONST.BUTTON_关闭;
		local winMsg = "2|\\n　　〈每日獵殺管理系統 ...資料讀取中...〉\\n\\n"
			.. "查看任務列表\\n"
			.. "查看已接任務\\n"
			.. "提交任務\\n"
			.. "放棄任務";
		NLG.ShowWindowTalked(player,npc,CONST.窗口_选择框, CONST.按钮_关闭, 1, winMsg);
	end
	return
end

function hunter_callback_fartalk(player,npc)
	local winButton = CONST.BUTTON_关闭;
	local winMsg = "2|\\n　　〈每日獵殺管理系統 ...資料讀取中...〉\\n\\n"
		.. "查看任務列表\\n"
		.. "查看已接任務\\n"
		.. "提交任務\\n"
		.. "放棄任務";
	NLG.ShowWindowTalked(player,npc,CONST.窗口_选择框, CONST.按钮_关闭, 1, winMsg);
end

--------------------------------------------------------------------------
--计算是否有猎杀目标
function Module:OnbattleStartEventCallback(battleIndex)
	for i = 0, 4 do
		local player = Battle.GetPlayer(battleIndex,i)
		if(player>-1 and Char.IsPlayer(player)==true)then
			local flag = tonumber( Field.Get(player, "hunter_flag"));
			if( flag == 1)then
				local quest = tonumber( Field.Get(player, "hunter_ongoing_quest"));
				if( quest ~= nil and quest ~= 0)then
					for i = 1, hunter_list[quest].target.count do
						Field.Set(player, "hunter_target_temporary_"..i, 0);
					end
					for oppos = 10, 19 do
						local enemy = Battle.GetPlayer(battleIndex, oppos);
						if( enemy>=0 and Char.IsEnemy(enemy)==true)then
							for i = 1, hunter_list[quest].target.count do
								if( Char.GetData( enemy,CONST.对象_名字) == hunter_list[quest].target[i].name)then
									if( tonumber( Field.Get( player, "hunter_target_"..i)) < hunter_list[quest].target[i].amount)then
										Field.Set( player, "hunter_target_temporary_"..i, tostring( tonumber( Field.Get( player, "hunter_target_temporary_"..i))+1));
									end
								end
							end
						end
					end
				
					local sum = 0;
					for i = 1, hunter_list[quest].target.count do
						local target_count = tonumber( Field.Get( player, "hunter_target_"..i));
						if( target_count ~= nil)then
							if( target_count >= hunter_list[quest].target[i].amount)then
								sum = sum + 1;
							end
						end
					end
					if( sum == hunter_list[quest].target.count)then
						Field.Set( player, "hunter_flag", tostring( 2));
					end
				end
			end
		end
	end
end
--在场玩家给予完成任务
function Module:onBattleOver(battleIndex)
	for i=0,9 do
		local player = Battle.GetPlayer(battleIndex,i)
		if (player>-1 and Char.IsPlayer(player)==true) then
			if (Char.GetData(player,CONST.对象_血) ~= 0) then
				hunter_battle_count(battleIndex, player);
			end
		end
	end
end
--猎杀任务达成
function hunter_battle_count(battleIndex, player)
	local quest = tonumber( Field.Get(player, "hunter_ongoing_quest"));
	if( quest ~= nil and quest ~= 0)then
		local flag = tonumber( Field.Get(player, "hunter_flag"));
		if( flag ~= nil)then
			if( flag == 1)then
				for i = 1, hunter_list[quest].target.count do
					precount = tonumber( Field.Get(player, "hunter_target_temporary_"..i));
					count = tonumber( Field.Get(player, "hunter_target_"..i));
					if( precount == nil)then
						precount = 0;
					end
					if( count == nil)then
						count = 0;
					end
					
					count = count + precount;
					
					Field.Set( player, "hunter_target_"..i, tostring( count));
					NLG.SystemMessage(player,"[系統]獵殺任務："..hunter_list[quest].target[i].name.." "..count.."/"..hunter_list[quest].target[i].amount.."！");
				end
			end
			local sum=0;
			for i = 1, hunter_list[quest].target.count do
				local target_count = tonumber( Field.Get(player, "hunter_target_"..i));
				if( target_count ~= nil)then
					if( target_count >= hunter_list[quest].target[i].amount)then
						sum = sum + 1;
					end
				end
			end
			if( sum == hunter_list[quest].target.count)then
				Field.Set(player, "hunter_flag", tostring( 2));
				for i = 1, hunter_list[quest].target.count do
					NLG.SystemMessage(player,"[系統]獵殺任務："..hunter_list[quest].target[i].name.." 完成！");
				end
			end
		end
	end
end

------------------------------------------------------------------------------------------------------------------------
--功能函数
--战利品说明
function hunter_action_reward_generate(quest)
	local msg = "";
	if( hunter_list[quest].reward.gold ~= 0)then
		msg = msg .. "魔幣×".. hunter_list[quest].reward.gold.." ";
	end
	if( hunter_list[quest].reward.lp ~= 0)then
		msg = msg .. "血池×".. hunter_list[quest].reward.lp.." ";
	end
	if( hunter_list[quest].reward.fp ~= 0)then
		msg = msg .. "魔池×".. hunter_list[quest].reward.fp.." ";
	end
	for i = 1, #hunter_list[quest].reward.item do
		msg = msg .. ""..hunter_list[quest].reward.item[i].name.."×"..hunter_list[quest].reward.item[i].amount.." ";
	end
	return msg;
end

--卸载模块
function Module:onUnload()
	self:logInfo('unload')
end
return Module
