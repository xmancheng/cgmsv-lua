---模块类
local Module = ModuleBase:createModule('systemJob')

-- 職業階段定義
local JOB_STAGE = {}
JOB_STAGE[0] = "見習";
JOB_STAGE[1] = "正職";
JOB_STAGE[2] = "王宮";
JOB_STAGE[3] = "師範";
JOB_STAGE[4] = "大師";

-- 任務需求、任務傳送起始位置
local quest = {}
quest[2] = {"新手任務",{1533,19,7}, };
quest[93] = {"階級提昇Ⅰ樹精長老",{2110,6,5}, };
quest[92] = {"階級提昇Ⅱ神獸史雷普尼爾",{4011,11,5}, };
quest[91] = {"階級提昇Ⅲ詛咒的迷宮",{4320,13,10}, };
quest[90] = {"階級提昇Ⅳ誓言之花",{59933,101,95}, };


-- 職業樹（依「當前階段」決定顯示）
--------------------------------------------------
-- 見習（遊民 → 見習）
local JOB_Select = {}
JOB_Select[1]={typeName = "近戰系",jobs = {
		{ id = 11, name = "劍士", needLv = 1, endeventId = 2 },
		{ id = 21, name = "戰斧鬥士", needLv = 1, endeventId = 2 },
		{ id = 31, name = "騎士", needLv = 1, endeventId = 2 },
		{ id = 51, name = "士兵", needLv = 1, endeventId = 2 },
		{ id = 151, name = "忍者", needLv = 1, endeventId = 2 },}
};
JOB_Select[2]={typeName = "遠程系",jobs = {
		{ id = 41, name = "弓箭手", needLv = 1, endeventId = 2 },
		{ id = 141, name = "格鬥士", needLv = 1, endeventId = 2 },
		{ id = 121, name = "盗贼", needLv = 1, endeventId = 2 },
		{ id = 161, name = "舞者", needLv = 1, endeventId = 2 },}
};
JOB_Select[3]={typeName = "法術系",jobs = {
		{ id = 61, name = "傳教士", needLv = 1, endeventId = 2 },
		{ id = 71, name = "魔術師", needLv = 1, endeventId = 2 },
		{ id = 81, name = "咒術師", needLv = 1, endeventId = 2 },
		{ id = 131, name = "巫師", needLv = 1, endeventId = 2 },}
};
JOB_Select[4]={typeName = "寵物系",jobs = {
		{ id = 91, name = "封印師", needLv = 1, endeventId = 2 },
		{ id = 101, name = "飼養師", needLv = 1, endeventId = 2 },
		{ id = 111, name = "馴獸師", needLv = 1, endeventId = 2 },}
};

-- 正職後同系列
local JOB_Tree = {}
JOB_Tree[10] = {  --jobs
	{ jobsId = 12, className = "劍士C階", name = "劍士", needLv = 30, endeventId = 93 },-- 正職（見習 → 正職）
	{ jobsId = 13, className = "劍士B階", name = "王宮劍士", needLv = 50, endeventId = 92 },-- 王宮（正職 → 王宮）
	{ jobsId = 14, className = "劍士A階", name = "劍術師範", needLv = 70, endeventId = 91 },-- 師範（王宮 → 師範）
	{ jobsId = 15, className = "劍士S階", name = "劍術大師", needLv = 90, endeventId = 90 },-- 大師（師範 → 大師）
};
JOB_Tree[20] = {
	{ jobsId = 22, className = "戰斧鬥士C階", name = "戰斧鬥士", needLv = 30, endeventId = 93 },-- 正職（見習 → 正職）
	{ jobsId = 23, className = "戰斧鬥士B階", name = "王宮戰斧鬥士", needLv = 50, endeventId = 92 },-- 王宮（正職 → 王宮）
	{ jobsId = 24, className = "戰斧鬥士A階", name = "戰斧師範", needLv = 70, endeventId = 91 },-- 師範（王宮 → 師範）
	{ jobsId = 25, className = "戰斧鬥士S階", name = "戰斧大師", needLv = 90, endeventId = 90 },-- 大師（師範 → 大師）
};
JOB_Tree[30] = {
	{ jobsId = 32, className = "騎士C階", name = "騎士", needLv = 30, endeventId = 93 },-- 正職（見習 → 正職）
	{ jobsId = 33, className = "騎士B階", name = "王宮騎士", needLv = 50, endeventId = 92 },-- 王宮（正職 → 王宮）
	{ jobsId = 34, className = "騎士A階", name = "近衛騎士", needLv = 70, endeventId = 91 },-- 師範（王宮 → 師範）
	{ jobsId = 35, className = "騎士S階", name = "鐵血騎士", needLv = 90, endeventId = 90 },-- 大師（師範 → 大師）
};
JOB_Tree[40] = {
	{ jobsId = 42, className = "弓箭手C階", name = "弓箭手", needLv = 30, endeventId = 93 },-- 正職（見習 → 正職）
	{ jobsId = 43, className = "弓箭手B階", name = "王宮弓箭手", needLv = 50, endeventId = 92 },-- 王宮（正職 → 王宮）
	{ jobsId = 44, className = "弓箭手A階", name = "弓術師範", needLv = 70, endeventId = 91 },-- 師範（王宮 → 師範）
	{ jobsId = 45, className = "弓箭手S階", name = "遊俠", needLv = 90, endeventId = 90 },-- 大師（師範 → 大師）
};
JOB_Tree[50] = {
	{ jobsId = 52, className = "士兵C階", name = "士兵", needLv = 30, endeventId = 93 },-- 正職（見習 → 正職）
	{ jobsId = 53, className = "士兵B階", name = "王宮士兵", needLv = 50, endeventId = 92 },-- 王宮（正職 → 王宮）
	{ jobsId = 54, className = "士兵A階", name = "士兵長", needLv = 70, endeventId = 91 },-- 師範（王宮 → 師範）
	{ jobsId = 55, className = "士兵S階", name = "重戰士", needLv = 90, endeventId = 90 },-- 大師（師範 → 大師）
};
JOB_Tree[60] = {
	{ jobsId = 62, className = "傳教士C階", name = "傳教士", needLv = 30, endeventId = 93 },-- 正職（見習 → 正職）
	{ jobsId = 63, className = "傳教士B階", name = "牧師", needLv = 50, endeventId = 92 },-- 王宮（正職 → 王宮）
	{ jobsId = 64, className = "傳教士A階", name = "主教", needLv = 70, endeventId = 91 },-- 師範（王宮 → 師範）
	{ jobsId = 65, className = "傳教士S階", name = "大主教", needLv = 90, endeventId = 90 },-- 大師（師範 → 大師）
};
JOB_Tree[70] = {
	{ jobsId = 72, className = "魔術師C階", name = "魔術師", needLv = 30, endeventId = 93 },-- 正職（見習 → 正職）
	{ jobsId = 73, className = "魔術師B階", name = "王宮魔法師", needLv = 50, endeventId = 92 },-- 王宮（正職 → 王宮）
	{ jobsId = 74, className = "魔術師A階", name = "魔導士", needLv = 70, endeventId = 91 },-- 師範（王宮 → 師範）
	{ jobsId = 75, className = "魔術師S階", name = "大魔導師", needLv = 90, endeventId = 90 },-- 大師（師範 → 大師）
};
JOB_Tree[80] = {
	{ jobsId = 82, className = "咒術師C階", name = "咒術師", needLv = 30, endeventId = 93 },-- 正職（見習 → 正職）
	{ jobsId = 83, className = "咒術師B階", name = "王宮咒術師", needLv = 50, endeventId = 92 },-- 王宮（正職 → 王宮）
	{ jobsId = 84, className = "咒術師A階", name = "降頭師", needLv = 70, endeventId = 91 },-- 師範（王宮 → 師範）
	{ jobsId = 85, className = "咒術師S階", name = "咒術大師", needLv = 90, endeventId = 90 },-- 大師（師範 → 大師）
};
JOB_Tree[90] = {
	{ jobsId = 92, className = "封印師C階", name = "封印師", needLv = 30, endeventId = 93 },-- 正職（見習 → 正職）
	{ jobsId = 93, className = "封印師B階", name = "王宮封印師", needLv = 50, endeventId = 92 },-- 王宮（正職 → 王宮）
	{ jobsId = 94, className = "封印師A階", name = "封印術師範", needLv = 70, endeventId = 91 },-- 師範（王宮 → 師範）
	{ jobsId = 95, className = "封印師S階", name = "封印大師", needLv = 90, endeventId = 90 },-- 大師（師範 → 大師）
};
JOB_Tree[100] = {
	{ jobsId = 102, className = "飼養師C階", name = "飼養師", needLv = 30, endeventId = 93 },-- 正職（見習 → 正職）
	{ jobsId = 103, className = "飼養師B階", name = "王宮飼養師", needLv = 50, endeventId = 92 },-- 王宮（正職 → 王宮）
	{ jobsId = 104, className = "飼養師A階", name = "高級飼養師", needLv = 70, endeventId = 91 },-- 師範（王宮 → 師範）
	{ jobsId = 105, className = "飼養師S階", name = "飼養大師", needLv = 90, endeventId = 90 },-- 大師（師範 → 大師）
};
JOB_Tree[110] = {
	{ jobsId = 112, className = "馴獸師C階", name = "馴獸師", needLv = 30, endeventId = 93 },-- 正職（見習 → 正職）
	{ jobsId = 113, className = "馴獸師B階", name = "王宮馴獸師", needLv = 50, endeventId = 92 },-- 王宮（正職 → 王宮）
	{ jobsId = 114, className = "馴獸師A階", name = "馴獸師範", needLv = 70, endeventId = 91 },-- 師範（王宮 → 師範）
	{ jobsId = 115, className = "馴獸師S階", name = "馴獸大師", needLv = 90, endeventId = 90 },-- 大師（師範 → 大師）
};
JOB_Tree[120] = {
	{ jobsId = 122, className = "盗贼C階", name = "盗贼", needLv = 30, endeventId = 93 },-- 正職（見習 → 正職）
	{ jobsId = 123, className = "盗贼B階", name = "小偷", needLv = 50, endeventId = 92 },-- 王宮（正職 → 王宮）
	{ jobsId = 124, className = "盗贼A階", name = "詐欺師", needLv = 70, endeventId = 91 },-- 師範（王宮 → 師範）
	{ jobsId = 125, className = "盗贼S階", name = "神偷", needLv = 90, endeventId = 90 },-- 大師（師範 → 大師）
};
JOB_Tree[130] = {
	{ jobsId = 132, className = "巫師C階", name = "巫師", needLv = 30, endeventId = 93 },-- 正職（見習 → 正職）
	{ jobsId = 133, className = "巫師B階", name = "王宮巫師", needLv = 50, endeventId = 92 },-- 王宮（正職 → 王宮）
	{ jobsId = 134, className = "巫師A階", name = "巫術大師", needLv = 70, endeventId = 91 },-- 師範（王宮 → 師範）
	{ jobsId = 135, className = "巫師S階", name = "巫王", needLv = 90, endeventId = 90 },-- 大師（師範 → 大師）
};
JOB_Tree[140] = {
	{ jobsId = 142, className = "格鬥士C階", name = "格鬥士", needLv = 30, endeventId = 93 },-- 正職（見習 → 正職）
	{ jobsId = 143, className = "格鬥士B階", name = "格鬥專家", needLv = 50, endeventId = 92 },-- 王宮（正職 → 王宮）
	{ jobsId = 144, className = "格鬥士A階", name = "格鬥家師範", needLv = 70, endeventId = 91 },-- 師範（王宮 → 師範）
	{ jobsId = 145, className = "格鬥士S階", name = "格鬥王", needLv = 90, endeventId = 90 },-- 大師（師範 → 大師）
};
JOB_Tree[150] = {
	{ jobsId = 152, className = "忍者C階", name = "中級忍者", needLv = 30, endeventId = 93 },-- 正職（見習 → 正職）
	{ jobsId = 153, className = "忍者B階", name = "上級忍者", needLv = 50, endeventId = 92 },-- 王宮（正職 → 王宮）
	{ jobsId = 154, className = "忍者A階", name = "影", needLv = 70, endeventId = 91 },-- 師範（王宮 → 師範）
	{ jobsId = 155, className = "忍者S階", name = "陰", needLv = 90, endeventId = 90 },-- 大師（師範 → 大師）
};
JOB_Tree[160] = {
	{ jobsId = 162, className = "舞者C階", name = "串場藝人", needLv = 30, endeventId = 93 },-- 正職（見習 → 正職）
	{ jobsId = 163, className = "舞者B階", name = "舞者", needLv = 50, endeventId = 92 },-- 王宮（正職 → 王宮）
	{ jobsId = 164, className = "舞者A階", name = "超級巨星", needLv = 70, endeventId = 91 },-- 師範（王宮 → 師範）
	{ jobsId = 165, className = "舞者S階", name = "國際巨星", needLv = 90, endeventId = 90 },-- 大師（師範 → 大師）
};

-------------------------------------------------------------------------
--- 加载模块钩子
function Module:onLoad()
	self:logInfo('load');
	self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self))
	self:regCallback('LoginEvent', Func.bind(self.onLoginEventCallBack,self))
	self.systemNPC = self:NPC_CreateCo('系統提示轉職', 14063, { x = 242, y = 74, mapType = 0, map = 1000, direction = 4 },Func.bind(self.onTalk,self))

end

function Module:handleTalkEvent(player,msg,color,range,size)
	if (msg=="/sys") then
		self.systemNPC:onTalk(self.systemNPC.npc,player);
		return 0;
	end
	return 1;
end

function Module:onLoginEventCallBack(player)
	local playerJobs = Char.GetData(player,CONST.对象_职类ID);
	local playerStage = Char.GetData(player,CONST.对象_职阶);
	if (playerJobs==0) then		--遊民
		self.systemNPC:onTalk(self.systemNPC.npc,player);
	else
		if (playerStage==0 and Char.GetData(player,CONST.对象_等级)>=30) then
			self.systemNPC:onTalk(self.systemNPC.npc,player,"C阶");
		elseif (playerStage==1 and Char.GetData(player,CONST.对象_等级)>=50) then
			self.systemNPC:onTalk(self.systemNPC.npc,player,"B阶");
		elseif (playerStage==2 and Char.GetData(player,CONST.对象_等级)>=70) then
			self.systemNPC:onTalk(self.systemNPC.npc,player,"A阶");
		elseif (playerStage==3 and Char.GetData(player,CONST.对象_等级)>=90) then
			self.systemNPC:onTalk(self.systemNPC.npc,player,"S阶");
		end
	end
	return 0
end
function getlayer(level,selectPath,msg)
	if msg=="C阶" then
		level = 2;
		selectPath[1]=1;
	elseif msg=="B阶" then
		level = 2;
		selectPath[1]=2;
	elseif msg=="A阶" then
		level = 2;
		selectPath[1]=3;
	elseif msg=="S阶" then
		level = 2;
		selectPath[1]=4;
	end
	return level,selectPath
end
function Module:onTalk(co, npc, player, msg, color, size)
	local page = 1
	local level = 1
	local selectPath = {}
	--local npc, player, _seqno, _select, _data = co:next(player, npc, CONST.窗口_信息框, CONST.按钮_关闭, 0, "" )
	local level,selectPath= getlayer(level,selectPath,msg);

	-- 建立顯示用清單
	local function buildList(data, page)
		local list = {}
		for i = 1, 5 do
			local idx = i + (page - 1) * 5
			if data[idx] then
				list[i] = data[idx]
			end
		end
		return list
	end

	-- 玩家目前轉職階段（你可改成用變數或 flag）
	local playerStage = Char.GetData(player,CONST.对象_职阶);
	--print(playerStage)
	if playerStage==4 then
		local msg =
			"\\n\\n@c【系統通知】" ..
			"\\n\\n" ..
			"\\n$4已達到職業最終階段\\n";
		npc, player, _seqno, _select, _data = co:next(player, npc, CONST.窗口_信息框, CONST.按钮_关闭, 0, msg)
		return false
	end

	repeat
		local windowType = CONST.窗口_选择框;
		local msg = "";
		local listData = {}
		local playerJobs = Char.GetData(player,CONST.对象_职类ID);
		local playerStage = Char.GetData(player,CONST.对象_职阶);
		local playerJobId = Char.GetData(player,CONST.对象_职业);
		--print(playerJobs,playerStage,playerJobId)
		local tree = JOB_Tree[playerJobs];
		--------------------------------------------------
		-- 第一層：職業類型(遊民)，職業階級(非遊民)
		--------------------------------------------------
		if level == 1 then
			windowType = CONST.窗口_选择框;
			if (playerJobs==0 or playerJobs==-1) then		--遊民
				if (Char.EndEvent(player,2) == 0) then
					Char.EndEvent(player,2,1);
				end
				msg =
					"4\\n\\n@c【系統通知】" ..
					"\\n\\n——————請選擇職業類型——————\\n"
				for _, v in pairs(JOB_Select) do
					table.insert(listData, v.typeName);
				end
				local list = buildList(listData, page)
				for i=1,#list do
					msg = msg..list[i].."\\n"
				end
			elseif (playerJobs>0 and playerStage>=0) then		--見習
				msg =
					"4\\n\\n@c【系統通知】" ..
					"\\n\\n——————查看升階的條件——————\\n"
				for k, v in pairs(tree) do
					table.insert(listData, v.className);
				end
				local list = buildList(listData, page)
				for i=1,#list do
					msg = msg..list[i].."\\n"
				end
			end
		--------------------------------------------------
		-- 第二層：職業(遊民)，資訊顯示 + 確認(非遊民)
		--------------------------------------------------
		elseif level == 2 then
			windowType = CONST.窗口_选择框;
			if (playerJobs==0 or playerJobs==-1) then		--遊民
				msg =
					"4\\n\\n@c【系統通知】" ..
					"\\n\\n——————選擇轉職的職業——————\\n"
				local group = JOB_Select[selectPath[1]]
				for _, job in pairs(group.jobs) do
					table.insert(listData, job.name);
				end
				local list = buildList(listData, page)
				for i=1,#list do
					msg = msg..list[i].."\\n"
				end
			elseif (playerJobs>0 and playerStage>=0) then		--已就職過
				windowType = CONST.窗口_信息框;
				winMsg =
					"\\n\\n@c【系統通知】" ..
					"\\n\\n"
				local job = tree[selectPath[1]]
				local ok, reason = checkJobCondition(player, job)
				msg =
					"提昇階段：$1" .. JOB_STAGE[selectPath[1]] .. "\\n" ..
					"職業：$1" .. job.className .. "\\n" ..
					"需求等級：$1" .. job.needLv .. "\\n" ..
					"需求任務：$1" .. (quest[job.endeventId][1] or "無") .. "\\n\\n" ..
					"判定：" .. reason .. "\\n\\n" ..
					(ok and "$5點擊【確定】進行提昇" or "$7尚未達成所有提昇條件")
			end
		--------------------------------------------------
		-- 第三層：資訊顯示 + 確認(遊民)
		--------------------------------------------------
		else
			windowType = CONST.窗口_信息框;
			winMsg =
				"\\n\\n@c【系統通知】" ..
				"\\n"
			if (playerJobs==0 or playerJobs==-1) then		--遊民
				local job = JOB_Select[selectPath[1]].jobs[selectPath[2]]
				local ok, reason = checkJobCondition(player, job)
				msg =
					"轉職階段：$1見習\\n" ..
					"職業：$1" .. job.name .. "\\n" ..
					"需求等級：$1" .. job.needLv .. "\\n" ..
					"需求任務：$1" .. (quest[job.endeventId][1] or "無") .. "\\n\\n" ..
					"判定：" .. reason .. "\\n\\n" ..
					(ok and "$5點擊【確定】進行轉職" or "$7尚未達成所有轉職條件")
			end
		end
		--------------------------------------------------
        -- 按鈕邏輯
        --------------------------------------------------
		if level == 1 then
			buttons = CONST.按钮_关闭;
		elseif level == 2 and playerJobs==0 then
			buttons = CONST.按钮_上取消;
		elseif level == 2 and playerJobs~=0 then
			buttons = CONST.按钮_确定关闭;
		elseif level == 3 and playerJobs==0 then
			buttons = CONST.按钮_确定+CONST.按钮_上取消;
		end

		npc, player, _seqno, _select, _data = co:next(player, npc, windowType, buttons, 0, msg);
		_select = tonumber(_select)
		_data = tonumber(_data)
        --------------------------------------------------
        -- 按鈕處理
        --------------------------------------------------
		if _select == 2 then
			return false
		elseif _select == 16 then
			level = level - 1;
			page = 1;
		elseif _select == 1 and level == 3 then
			-- 確認就職
			if (playerJobs==0 or playerJobs==-1) then		--遊民
				local job = JOB_Select[selectPath[1]].jobs[selectPath[2]];
				local ok = checkJobCondition(player, job);
				if ok then
					Char.SetData(player,CONST.对象_职类ID,job.id-1);
					Char.SetData(player,CONST.对象_职阶,0);
					Char.SetData(player,CONST.对象_职业,job.id);
					NLG.SystemMessage(player,"[系統]成功完成就職！");
					NLG.UpChar(player);
				else
					local warpPoint= quest[job.endeventId][2];
					Char.Warp(player,0,warpPoint[1],warpPoint[2],warpPoint[3]);
					--NLG.SystemMessage(player,"[系統]尚未完成任務！");
					return false
				end
			end
			return false
		elseif _select == 1 and level == 2 then
			if (playerJobs>0 and playerStage>=0) then		--已就職過
				local job = tree[selectPath[1]];
				local ok = checkJobCondition(player, job);
				if (playerJobId>=job.jobsId) then
					NLG.SystemMessage(player,"[系統]已經完成此階段任務！");
					return false
				end
				if ok then
					Char.SetData(player,CONST.对象_职阶,playerStage+1);
					Char.SetData(player,CONST.对象_职业,job.jobsId);
					NLG.SystemMessage(player,"[系統]成功完成進階！");
					NLG.UpChar(player);
				else
					local warpPoint= quest[job.endeventId][2];
					Char.Warp(player,0,warpPoint[1],warpPoint[2],warpPoint[3]);
					--NLG.SystemMessage(player,"[系統]尚未達成所有條件！");
					return false
				end
			end
			return false
		elseif _data and _data > 0 then
			selectPath[level] = _data + (page - 1) * 5
			level = level + 1
			page = 1
		end
    until false
end

-- 轉職條件判斷
function checkJobCondition(player, job)
    if Char.GetData(player,CONST.对象_等级) < job.needLv then
        return false, "$8等級不足（需要 Lv." .. job.needLv .. "）"
    end

    if Char.EndEvent(player,job.endeventId) == 0 then
        return false, "$9尚未完成任務"
    end

    return true, "$4完成任務符合條件"
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;


