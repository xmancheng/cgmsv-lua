------------------------------------------------------------------------------
------------------------------------------------------------------------------
--                 【【【属性强化设置】】】
------------------------------------------------------------------------------
local StrStrengEnable = {}
local StrStrengMaxLv = {}
local StrBaseRate = {}
local StrResistRate = {}
local StrFixRate = {}
local StrSuccRate = {}
local StrBreakRate = {}
local StrRequireItemID = {}
local StrRequireItemNum = {}
local StrRequireGold = {}
local StrBinding = 0								--强化后装备是否不可交易（选项：0-不绑定，1-绑定）
--【默认设置】
--  开启后所有装备均可强化
StrStrengEnable[-1] = 1	--是否开启默认设置
StrStrengMaxLv[-1] = 9									--最大可强化等级（次数）
StrBaseRate[-1] = 	{4, 4, 3, 3, 3, 2, 2, 2, 2}			--普通属性百分比
StrResistRate[-1] = 	{1, 1, 1, 1, 1, 1, 2, 2, 2}			--6抗性
StrFixRate[-1] = 	{1, 1, 1, 1, 1, 1, 2, 2, 2}			--4修正
StrSuccRate[-1] = 	{50, 45, 40, 35, 25, 20, 20, 20, 15}	--强化成功率
StrBreakRate[-1] = 	{10, 10, 10, 10, 10, 10, 10, 10, 10}		--强化破坏率
StrRequireItemID[-1] = {69126, 69126, 69126, 69126, 69126, 69126, 69126, 69126, 69126}		--强化需求物品ID（强化石ID）
StrRequireItemNum[-1] = {1, 1, 2, 2, 2, 4, 4, 5, 5, 5}			--强化需求物品数量（强化石数量）
StrRequireGold[-1] = {1000, 1000, 2000, 2000, 2000, 4000, 4000, 5000, 5000, 5000}	--强化所需金币
--【特殊强化】
--  一个装备一段，请整段复制后再修改
StrStrengEnable[69109] = 1
StrStrengMaxLv[69109] = 9									--最大可强化等级（次数）
StrBaseRate[69109] = 	{1, 1, 1, 1, 1, 1, 1, 1, 1}			--普通属性百分比
StrResistRate[69109] = 	{1, 1, 1, 1, 1, 1, 2, 2, 2}			--6抗性
StrFixRate[69109] = 		{1, 1, 1, 1, 1, 1, 2, 2, 2}			--4修正
StrSuccRate[69109] =	{100, 100, 80, 80, 50, 40, 30, 20, 10}	--强化成功率
StrBreakRate[69109] = 	{5, 5, 5, 5, 5, 5, 5, 10, 15}		--强化破坏率
StrRequireItemID[69109] = {69127, 69127, 69127, 69127, 69127, 69127, 69127, 69127, 69127}		--强化需求物品ID（强化石ID）
StrRequireItemNum[69109] = {1, 1, 2, 2, 2, 4, 4, 5, 5, 5}			--强化需求物品数量（强化石数量）
StrRequireGold[69109] = {1000, 1000, 2000, 2000, 2000, 4000, 4000, 5000, 5000, 5000}	--强化所需金币
--  一个装备一段，请整段复制后再修改
StrStrengEnable[16424] = 1
StrStrengMaxLv[16424] = 9									--最大可强化等级（次数）
StrBaseRate[16424] = 	{1, 1, 1, 1, 1, 1, 1, 1, 1}			--普通属性百分比
StrResistRate[16424] = 	{1, 1, 1, 1, 1, 1, 2, 2, 2}			--6抗性
StrFixRate[16424] = 		{1, 1, 1, 1, 1, 1, 2, 2, 2}			--4修正
StrSuccRate[16424] =	{100, 100, 80, 80, 50, 40, 30, 20, 10}	--强化成功率
StrBreakRate[16424] = 	{5, 5, 5, 5, 5, 5, 5, 10, 15}		--强化破坏率
StrRequireItemID[16424] = {69127, 69127, 69127, 69127, 69127, 69127, 69127, 69127, 69127}		--强化需求物品ID（强化石ID）
StrRequireItemNum[16424] = {1, 1, 2, 2, 2, 4, 4, 5, 5, 5}			--强化需求物品数量（强化石数量）
StrRequireGold[16424] = {1000, 1000, 2000, 2000, 2000, 4000, 4000, 5000, 5000, 5000}--强化所需金币
--  一个装备一段，请整段复制后再修改
StrStrengEnable[69129] = 1
StrStrengMaxLv[69129] = 9									--最大可强化等级（次数）
StrBaseRate[69129] = 	{10, 5, 5, 4, 4, 3, 3, 2, 2}			--普通属性百分比
StrResistRate[69129] = 	{1, 1, 1, 1, 1, 1, 2, 2, 2}			--6抗性
StrFixRate[69129] = 		{1, 1, 1, 1, 1, 1, 2, 2, 2}			--4修正
StrSuccRate[69129] =	{100, 80, 80, 70, 60, 50, 40, 30, 20}	--强化成功率
StrBreakRate[69129] = 	{10, 10, 10, 10, 10, 10, 10, 10, 10}		--强化破坏率
StrRequireItemID[69129] = {69128, 69128, 69128, 69128, 69128, 69128, 69128, 69128, 69128}		--强化需求物品ID（强化石ID）
StrRequireItemNum[69129] = {1, 1, 2, 2, 2, 4, 4, 5, 5, 5}			--强化需求物品数量（强化石数量）
StrRequireGold[69129] = {1000, 1000, 2000, 2000, 2000, 4000, 4000, 5000, 5000, 5000}	--强化所需金币
--  一个装备一段，请整段复制后再修改
StrStrengEnable[69130] = 1
StrStrengMaxLv[69130] = 9									--最大可强化等级（次数）
StrBaseRate[69130] = 	{10, 5, 5, 4, 4, 3, 3, 2, 2}			--普通属性百分比
StrResistRate[69130] = 	{1, 1, 1, 1, 1, 1, 2, 2, 2}			--6抗性
StrFixRate[69130] = 		{1, 1, 1, 1, 1, 1, 2, 2, 2}			--4修正
StrSuccRate[69130] =	{100, 80, 80, 70, 60, 50, 40, 30, 20}	--强化成功率
StrBreakRate[69130] = 	{10, 10, 10, 10, 10, 10, 10, 10, 10}		--强化破坏率
StrRequireItemID[69130] = {69128, 69128, 69128, 69128, 69128, 69128, 69128, 69128, 69128}		--强化需求物品ID（强化石ID）
StrRequireItemNum[69130] = {1, 1, 2, 2, 2, 4, 4, 5, 5, 5}			--强化需求物品数量（强化石数量）
StrRequireGold[69130] = {1000, 1000, 2000, 2000, 2000, 4000, 4000, 5000, 5000, 5000}--强化所需金币
--  一个装备一段，请整段复制后再修改
StrStrengEnable[69131] = 1
StrStrengMaxLv[69131] = 9									--最大可强化等级（次数）
StrBaseRate[69131] = 	{10, 5, 5, 4, 4, 3, 3, 2, 2}			--普通属性百分比
StrResistRate[69131] = 	{1, 1, 1, 1, 1, 1, 2, 2, 2}			--6抗性
StrFixRate[69131] = 		{1, 1, 1, 1, 1, 1, 2, 2, 2}			--4修正
StrSuccRate[69131] =	{100, 80, 80, 70, 60, 50, 40, 30, 20}	--强化成功率
StrBreakRate[69131] = 	{10, 10, 10, 10, 10, 10, 10, 10, 10}		--强化破坏率
StrRequireItemID[69131] = {69128, 69128, 69128, 69128, 69128, 69128, 69128, 69128, 69128}		--强化需求物品ID（强化石ID）
StrRequireItemNum[69131] = {1, 1, 2, 2, 2, 4, 4, 5, 5, 5}			--强化需求物品数量（强化石数量）
StrRequireGold[69131] = {1000, 1000, 2000, 2000, 2000, 4000, 4000, 5000, 5000, 5000}	--强化所需金币
--  一个装备一段，请整段复制后再修改
StrStrengEnable[69132] = 1
StrStrengMaxLv[69132] = 9									--最大可强化等级（次数）
StrBaseRate[69132] = 	{10, 5, 5, 4, 4, 3, 3, 2, 2}			--普通属性百分比
StrResistRate[69132] = 	{1, 1, 1, 1, 1, 1, 2, 2, 2}			--6抗性
StrFixRate[69132] = 		{1, 1, 1, 1, 1, 1, 2, 2, 2}			--4修正
StrSuccRate[69132] =	{100, 80, 80, 70, 60, 50, 40, 30, 20}	--强化成功率
StrBreakRate[69132] = 	{10, 10, 10, 10, 10, 10, 10, 10, 10}		--强化破坏率
StrRequireItemID[69132] = {69128, 69128, 69128, 69128, 69128, 69128, 69128, 69128, 69128}		--强化需求物品ID（强化石ID）
StrRequireItemNum[69132] = {1, 1, 2, 2, 2, 4, 4, 5, 5, 5}			--强化需求物品数量（强化石数量）
StrRequireGold[69132] = {1000, 1000, 2000, 2000, 2000, 4000, 4000, 5000, 5000, 5000}	--强化所需金币
--  一个装备一段，请整段复制后再修改
StrStrengEnable[70034] = 1
StrStrengMaxLv[70034] = 9									--最大可强化等级（次数）
StrBaseRate[70034] = 	{2, 2, 2, 2, 3, 3, 3, 4, 4}			--普通属性百分比
StrResistRate[70034] = 	{1, 1, 1, 1, 1, 1, 2, 2, 2}			--6抗性
StrFixRate[70034] = 		{1, 1, 1, 1, 1, 1, 2, 2, 2}			--4修正
StrSuccRate[70034] =	{100, 100, 80, 80, 50, 40, 30, 20, 10}	--强化成功率
StrBreakRate[70034] = 	{10, 10, 10, 10, 10, 10, 10, 10, 10}		--强化破坏率
StrRequireItemID[70034] = {69127, 69127, 69127, 69127, 69127, 69127, 69127, 69127, 69127}		--强化需求物品ID（强化石ID）
StrRequireItemNum[70034] = {1, 1, 2, 2, 2, 4, 4, 5, 5, 5}			--强化需求物品数量（强化石数量）
StrRequireGold[70034] = {1000, 1000, 2000, 2000, 2000, 4000, 4000, 5000, 5000, 5000}	--强化所需金币
--  一个装备一段，请整段复制后再修改
StrStrengEnable[70036] = 1
StrStrengMaxLv[70036] = 9									--最大可强化等级（次数）
StrBaseRate[70036] = 	{2, 2, 2, 2, 3, 3, 3, 4, 4}			--普通属性百分比
StrResistRate[70036] = 	{1, 1, 1, 1, 1, 1, 2, 2, 2}			--6抗性
StrFixRate[70036] = 		{1, 1, 1, 1, 1, 1, 2, 2, 2}			--4修正
StrSuccRate[70036] =	{100, 100, 80, 80, 50, 40, 30, 20, 10}	--强化成功率
StrBreakRate[70036] = 	{10, 10, 10, 10, 10, 10, 10, 10, 10}		--强化破坏率
StrRequireItemID[70036] = {69127, 69127, 69127, 69127, 69127, 69127, 69127, 69127, 69127}		--强化需求物品ID（强化石ID）
StrRequireItemNum[70036] = {1, 1, 2, 2, 2, 4, 4, 5, 5, 5}			--强化需求物品数量（强化石数量）
StrRequireGold[70036] = {1000, 1000, 2000, 2000, 2000, 4000, 4000, 5000, 5000, 5000}	--强化所需金币
--  一个装备一段，请整段复制后再修改
StrStrengEnable[70037] = 1
StrStrengMaxLv[70037] = 9									--最大可强化等级（次数）
StrBaseRate[70037] = 	{2, 2, 2, 2, 3, 3, 3, 4, 4}			--普通属性百分比
StrResistRate[70037] = 	{1, 1, 1, 1, 1, 1, 2, 2, 2}			--6抗性
StrFixRate[70037] = 		{1, 1, 1, 1, 1, 1, 2, 2, 2}			--4修正
StrSuccRate[70037] =	{100, 100, 80, 80, 50, 40, 30, 20, 10}	--强化成功率
StrBreakRate[70037] = 	{10, 10, 10, 10, 10, 10, 10, 10, 10}		--强化破坏率
StrRequireItemID[70037] = {69127, 69127, 69127, 69127, 69127, 69127, 69127, 69127, 69127}		--强化需求物品ID（强化石ID）
StrRequireItemNum[70037] = {1, 1, 2, 2, 2, 4, 4, 5, 5, 5}			--强化需求物品数量（强化石数量）
StrRequireGold[70037] = {1000, 1000, 2000, 2000, 2000, 4000, 4000, 5000, 5000, 5000}	--强化所需金币
--  一个装备一段，请整段复制后再修改
StrStrengEnable[70038] = 1
StrStrengMaxLv[70038] = 9									--最大可强化等级（次数）
StrBaseRate[70038] = 	{2, 2, 2, 2, 3, 3, 3, 4, 4}			--普通属性百分比
StrResistRate[70038] = 	{1, 1, 1, 1, 1, 1, 2, 2, 2}			--6抗性
StrFixRate[70038] = 		{1, 1, 1, 1, 1, 1, 2, 2, 2}			--4修正
StrSuccRate[70038] =	{100, 100, 80, 80, 50, 40, 30, 20, 10}	--强化成功率
StrBreakRate[70038] = 	{10, 10, 10, 10, 10, 10, 10, 10, 10}		--强化破坏率
StrRequireItemID[70038] = {69127, 69127, 69127, 69127, 69127, 69127, 69127, 69127, 69127}		--强化需求物品ID（强化石ID）
StrRequireItemNum[70038] = {1, 1, 2, 2, 2, 4, 4, 5, 5, 5}			--强化需求物品数量（强化石数量）
StrRequireGold[70038] = {1000, 1000, 2000, 2000, 2000, 4000, 4000, 5000, 5000, 5000}	--强化所需金币
--【禁止强化】
--  一个装备一行，数值填写0即可
StrStrengEnable[980491] = 0
StrStrengEnable[250] = 0    --水龍之服
StrStrengEnable[69105] = 0    --元素力量增幅器
StrStrengEnable[69106] = 0
StrStrengEnable[69107] = 0
StrStrengEnable[69108] = 0
StrStrengEnable[70053] = 0    --★完全支配術★
StrStrengEnable[70054] = 0
StrStrengEnable[70055] = 0
StrStrengEnable[70056] = 0
StrStrengEnable[70057] = 0
StrStrengEnable[70058] = 0
StrStrengEnable[70059] = 0
StrStrengEnable[70060] = 0
StrStrengEnable[79060] = 0    --副武器
StrStrengEnable[79061] = 0
StrStrengEnable[79062] = 0
StrStrengEnable[79063] = 0
StrStrengEnable[79064] = 0
StrStrengEnable[79065] = 0
StrStrengEnable[69226] = 0    --古老巨龍
StrStrengEnable[69227] = 0
StrStrengEnable[69228] = 0
StrStrengEnable[69229] = 0
StrStrengEnable[79215] = 0    --噴漆過編號
StrStrengEnable[79216] = 0
StrStrengEnable[79217] = 0
StrStrengEnable[79218] = 0
StrStrengEnable[79219] = 0
StrStrengEnable[79220] = 0
StrStrengEnable[79221] = 0
StrStrengEnable[79222] = 0
StrStrengEnable[79223] = 0
StrStrengEnable[79224] = 0
StrStrengEnable[79225] = 0
StrStrengEnable[79226] = 0
StrStrengEnable[79227] = 0
StrStrengEnable[79228] = 0
StrStrengEnable[79229] = 0
StrStrengEnable[79230] = 0
StrStrengEnable[79231] = 0
StrStrengEnable[79232] = 0
StrStrengEnable[79233] = 0
StrStrengEnable[79234] = 0
StrStrengEnable[79235] = 0
StrStrengEnable[79236] = 0
StrStrengEnable[79237] = 0
StrStrengEnable[79238] = 0
StrStrengEnable[79239] = 0
StrStrengEnable[79240] = 0
StrStrengEnable[79241] = 0
StrStrengEnable[79242] = 0
StrStrengEnable[79243] = 0
StrStrengEnable[79244] = 0
StrStrengEnable[79245] = 0
StrStrengEnable[79246] = 0
StrStrengEnable[79247] = 0
StrStrengEnable[79248] = 0
StrStrengEnable[79249] = 0


------------------------------------------------------------------------------
------------------------------------------------------------------------------
--                 【【【脚本系统设置】】】（非专业人事请勿修改）
------------------------------------------------------------------------------
local ItemPosName = {"頭 部", "身 体", "右 手", "左 手", "足 部", "飾品1", "飾品2", "水 晶"}
------------------------------------------------------------------------------

function BlacksmithNpc_Func(index)
	print("Blacksmith.Index=" .. index);
	return 1;
end

Delegate.RegInit("BlacksmithNpc_Init");
function BlacksmithNpc_Init()
	local BlacksmithNpc = NL.CreateNpc("lua/Module/Blacksmiths.lua", "BlacksmithNpc_Func");
	Char.SetData( BlacksmithNpc, %对象_形象%,105527);
	Char.SetData( BlacksmithNpc, %对象_原形%,105527);
	Char.SetData( BlacksmithNpc, %对象_地图%,25000);
	Char.SetData( BlacksmithNpc, %对象_X%,29);
	Char.SetData( BlacksmithNpc, %对象_Y%,7);
	Char.SetData( BlacksmithNpc, %对象_方向%,4);
	Char.SetData( BlacksmithNpc, %对象_名字%,"裝備精煉鐵匠");
	NLG.UpChar( BlacksmithNpc)

	tbl_LuaNpcIndex = {}
	tbl_LuaNpcIndex["BlacksmithNpc"] = BlacksmithNpc

	if (Char.SetTalkedEvent(nil, "BlacksmithNpc_Talked", BlacksmithNpc) < 0) then
		print("BlacksmithNpc_Talked 注册事件失败。");
		return false;
	end

	if (Char.SetWindowTalkedEvent(nil, "BlacksmithNpc_WindowTalked", BlacksmithNpc) < 0) then
		print("BlacksmithNpc_WindowTalked 注册事件失败。");
		return false;
	end

	return true;
end

function BlacksmithNpc_Talked( _MeIndex, _PlayerIndex, _Mode)

	if(NLG.CheckInFront(_PlayerIndex, _MeIndex, 1)==false and _Mode~=1) then
		return ;
	end 

	NLG.ShowWindowTalked(_PlayerIndex, _MeIndex, 2, 2, 1,
			"8\n　　　　　　　◆" .. "裝備精煉鐵匠" .. "◆" ..
			"\n　　一位來自托爾法吉亞的神秘鐵匠，純真的外表" ..
			"\n下有著不為人知的力量，在她的故鄉流傳著遠古魔" ..
			"\n法時期的靈魂容器製作法，據說任何裝備經過他們" ..
			"\n的神之手鍛造改良，都會變得更加堅韌。" ..
			"\n　　這位王國難民的神秘鐵匠，為了修行，為了得" ..
			"\n到神之鐵鎚封號，正在賣藝為人們精煉裝備。" .. 
			"\n" ..
			"\n　　　　　　　　　『精煉強化』"
			);

	return ;
end

function BlacksmithNpc_WindowTalked( _MeIndex, _PlayerIndex, _Seqno, _Select, _Data)

	--print("\n_MeIndex=" .. _MeIndex .. ", _PlayerIndex=" .. _PlayerIndex .. ", _Seqno=" .. _Seqno .. ", _Data=" .. _Data)
	
	--取消按钮
	if _Select==2 then
		return
	end

	if _Seqno==1 then
		local PlayerSelect = tonumber(_Data)
		if PlayerSelect==1 then
			--属性强化
			local TalkBuf = "1|\n請選擇需要精煉強化的裝備：\n"
			for i = 0,7 do
				local tItemIndex = Char.GetItemIndex(_PlayerIndex, i);
				if tItemIndex>=0 then
					local tItemID = Item.GetData(tItemIndex, %道具_ID%)
					--print("tItemID=" .. tItemID)
					local tItemName = Item.GetData(tItemIndex, %道具_名字%)
					local tStrLv = EquipPlusStat(tItemIndex, "S") or 0
					local tMaxLv = StrStrengMaxLv[tItemID] or StrStrengMaxLv[-1]
					local tNeedItemNumTab = StrRequireItemNum[tItemID] or StrRequireItemNum[-1]
					local tNeedItemNum = tNeedItemNumTab[tStrLv+1]
					local tNeedGoldTab = StrRequireGold[tItemID] or StrRequireGold[-1]
					local tNeedGold = tNeedGoldTab[tStrLv+1]
					local tItemCan = "[强化Ｏ]  " .. tNeedItemNum .. "個|"  .. string.format("%.2f", tNeedGold/10000) .. "W"
					if StrStrengEnable[tItemID]~=1 and StrStrengEnable[-1]~=1 then tItemCan="[强化Ｘ]" end
					if tStrLv>=tMaxLv then tItemCan="[强化Max]" end
					if StrStrengEnable[tItemID]==0 then tItemCan="[强化X]" end
					if EquipPlusStat(tItemIndex, "D")~=nil then tItemCan="[强化Ｘ]" end
					if EquipPlusStat(tItemIndex, "E")~=nil then tItemCan="[强化Ｘ]" end
					if EquipPlusStat(tItemIndex, "R")~=nil then tItemCan="[强化Ｘ]" end
					local Buf = tItemName .. " " .. tItemCan
					TalkBuf = TalkBuf .. ItemPosName[i+1] .. "：" .. Buf .. "\n"
				else
					TalkBuf = TalkBuf .. ItemPosName[i+1] .. "：" .. "\n"
				end
			end
			NLG.ShowWindowTalked(_PlayerIndex, _MeIndex, 2, 2, 10, TalkBuf)
			return
		end
	end

	--属性强化
	if _Seqno==10 then
		local PlayerSelect = tonumber(_Data)
		local tPlayerGold = Char.GetData(_PlayerIndex, %对象_金币%)
		local tItemPos = PlayerSelect - 1
		local tItemIndex = Char.GetItemIndex(_PlayerIndex, tItemPos);
		if tItemIndex>=0 then
			local tItemID = Item.GetData(tItemIndex, %道具_ID%)
			local tItemName = Item.GetData(tItemIndex, %道具_名字%)
			--CheckEnable
			local tStrLv = EquipPlusStat(tItemIndex, "S") or 0
			local tMaxLv = StrStrengMaxLv[tItemID] or StrStrengMaxLv[-1]
			if StrStrengEnable[tItemID]~=1 and StrStrengEnable[-1]~=1 then
				NLG.SystemMessage(_PlayerIndex, "[" .. "神秘鐵匠" .. "] 你選擇的裝備[" .. tItemName .. "]為[不可強化]！")
				return
			end
			if tStrLv>=tMaxLv then
				NLG.SystemMessage(_PlayerIndex, "[" .. "神秘鐵匠" .. "] 你選擇的裝備[" .. tItemName .. "]已達到[強化Max]！")
				return
			end
			if StrStrengEnable[tItemID]==0 then
				NLG.SystemMessage(_PlayerIndex, "[" .. "神秘鐵匠" .. "] 你選擇的裝備[" .. tItemName .. "]為[不可強化]！")
				return
			end
			if EquipPlusStat(tItemIndex, "D")~=nil then
				NLG.SystemMessage(_PlayerIndex, "[" .. "神秘鐵匠" .. "] 你選擇的裝備[" .. tItemName .. "]為[魔化裝備]，已達到極限！")
				return
			end
			if EquipPlusStat(tItemIndex, "E")~=nil then
				NLG.SystemMessage(_PlayerIndex, "[" .. "神秘鐵匠" .. "] 你選擇的裝備[" .. tItemName .. "]已血煉附魔，無法繼續強化！")
				return
			end
			if EquipPlusStat(tItemIndex, "R")~=nil then
				NLG.SystemMessage(_PlayerIndex, "[" .. "神秘鐵匠" .. "] 你選擇的裝備[" .. tItemName .. "]已鑲嵌符文，無法繼續強化！")
				return
			end
			--CheckGold
			local tNeedGoldTab = StrRequireGold[tItemID] or StrRequireGold[-1]
			local tNeedGold = tonumber(tNeedGoldTab[tStrLv+1]) or 0
			if tPlayerGold<tNeedGold then
				NLG.SystemMessage(_PlayerIndex, "[" .. "神秘鐵匠" .. "] 強化需要" .. tNeedGold .. "G，所需金幣不足！")
				return
			end
			--CheckRequireItem
			local RequireItemIDTab = StrRequireItemID[tItemID] or StrRequireItemID[-1]
			local RequireItemID = RequireItemIDTab[tStrLv+1]
			local RequireItemNumTab = StrRequireItemNum[tItemID] or StrRequireItemNum[-1]
			local RequireItemNum = RequireItemNumTab[tStrLv+1]
			if type(RequireItemID)=="number" and RequireItemID>0 and type(RequireItemNum)=="number" and RequireItemNum>0 then
				if Char.ItemNum(_PlayerIndex, RequireItemID)<RequireItemNum then
					NLG.SystemMessage(_PlayerIndex, "[" .. "神秘鐵匠" .. "] 強化所需道具不足！")
					return
				end
			end
			--DelGold
			Char.SetData(_PlayerIndex, %对象_金币%, tPlayerGold-tNeedGold)
			--DelItem
			Char.DelItem(_PlayerIndex, RequireItemID, RequireItemNum)
			--CheckSuccess
			local SuccRateTab = StrSuccRate[tItemID] or StrSuccRate[-1]
			local SuccRate = SuccRateTab[tStrLv+1]
			if type(SuccRate)=="number" and SuccRate>0 then
				local tMin = 50 - math.floor(SuccRate/2) + 1
				local tMax = 50 + math.floor(SuccRate/2) + math.fmod(SuccRate,2)
				local tLuck = math.random(1, 100)
				if tLuck<tMin or tLuck>tMax then
					NLG.SystemMessage(_PlayerIndex, "[" .. "神秘鐵匠" .. "] 很不幸，你的裝備強化失敗……所幸裝備並沒有損壞……")
					BlacksmithNpc_WindowTalked( _MeIndex, _PlayerIndex, 1, 1, 1)
					--CheckBreak
					local BreakRateTab = StrBreakRate[tItemID] or StrBreakRate[-1]
					local BreakRate = BreakRateTab[tStrLv+1]
					if type(BreakRate)=="number" and BreakRate>0 then
						local tMin = 50 - math.floor(BreakRate/2) + 1
						local tMax = 50 + math.floor(BreakRate/2) + math.fmod(BreakRate,2)
						local tLuck = math.random(1, 100)
						if tLuck>=tMin and tLuck<=tMax then
							--Item.SetData(tItemIndex, %道具_ID%, 10203947)
							--Char.DelItem(_PlayerIndex, 10203947)
							--Char.DelItemByPos(_PlayerIndex, tItemPos)
							Item.Kill(_PlayerIndex, tItemIndex, tItemPos)
							NLG.SystemMessage(_PlayerIndex, "[" .. "神秘鐵匠" .. "] 這絕對是個災難！由於火力沒控制好，你的裝備徹底毀壞了……")
							--BlacksmithNpc_WindowTalked( _MeIndex, _PlayerIndex, 1, 1, 1)
							return
						end
					end
					return
				end
			end
			--SetData
			setItemStrData(tItemIndex, tStrLv)
			--SetStat
			--if Item.GetData(tItemIndex, %道具_自用参数%)=="" then Item.SetData(tItemIndex, %道具_鉴前名%, tItemName) end
			if EquipPlusStat(tItemIndex)==nil then Item.SetData(tItemIndex, %道具_鉴前名%, tItemName) end
			EquipPlusStat(tItemIndex, "S", tStrLv+1)
			setItemName(tItemIndex)
			--Set Binding
			if StrBinding==1 or StrBinding==true then
				Item.SetData(tItemIndex, %道具_可出售%, 0)
				Item.SetData(tItemIndex, %道具_宠邮%, 0)
				Item.SetData(tItemIndex, %道具_丢地消失%, 1)
			end
			--UpItem
			Item.UpItem(_PlayerIndex, tItemPos)
			NLG.UpChar(_PlayerIndex)
			NLG.SystemMessage(_PlayerIndex, "[" .. "神秘鐵匠" .. "] 恭喜你！裝備成功強化到+" .. tStrLv+1 .. "！")
			if (tStrLv+1>=7) then
				NLG.SystemMessage(-1, "[" .. "神秘鐵匠" .. "] 恭喜 "..Char.GetData(_PlayerIndex, %对象_名字%).."！將 "..Item.GetData(tItemIndex, %道具_鉴前名%).." 成功強化到+" .. tStrLv+1 .. "！")
			end
			--print("未鉴定名=" .. Item.GetData(tItemIndex, %道具_鉴前名%))
			--print("已鉴定名=" .. Item.GetData(tItemIndex, %道具_名字%))
			--print("自用参数=" .. Item.GetData(tItemIndex, %道具_自用参数%))
			BlacksmithNpc_WindowTalked( _MeIndex, _PlayerIndex, 1, 1, 1)
		else
			NLG.SystemMessage(_PlayerIndex, "[" .. "神秘鐵匠" .. "] 這裡沒有裝備，你想強化你的皮膚嗎？")
			--BlacksmithNpc_WindowTalked( _MeIndex, _PlayerIndex, 1, 1, 1)
		end
	end

	return
end

function EquipPlusStat( _ItemIndex, _StatTab, _StatValue )
	--  S-强化，R-符文，D-魔化，L-限时
	local tStatTab = {}
	if type(_StatTab)=="nil" then
		--GetAll
		local tItemStat = Item.GetData(_ItemIndex, %道具_自用参数%)
		if string.find(tItemStat, ",")==nil then
			return nil
		end
		if string.find(tItemStat, "|")==nil then
			local tSub = Split(tItemStat, ",")
			tStatTab[tSub[1]]=tonumber(tSub[2])
			return tStatTab
		end
		local tStat = Split(tItemStat, "|")
		for k,v in pairs(tStat) do
			local tSub = Split(v, ",")
			tStatTab[tSub[1]]=tonumber(tSub[2])
		end
		return tStatTab
	elseif type(_StatTab)=="table" then
		--SetAll
		local tStat = ""
		for k,v in pairs(_StatTab) do
			tStat = tStat .. k .. "," .. v .. "|"
		end
		Item.SetData(_ItemIndex, %道具_自用参数%, tStat)
	elseif type(_StatTab)=="string" and type(_StatValue)=="nil" then
		--GetSub
		local tStatTab = EquipPlusStat(_ItemIndex) or {}
		for k,v in pairs(tStatTab) do
			if _StatTab==k then
				return tonumber(v)
			end
		end
		return nil
	elseif type(_StatTab)=="string" then
		--SetSub
		local tStatTab = EquipPlusStat(_ItemIndex) or {}
		tStatTab[_StatTab]=_StatValue
		EquipPlusStat(_ItemIndex, tStatTab)
	end
end

function setItemStrData( _ItemIndex, _StrLv)
	local tItemID = Item.GetData(_ItemIndex, 0)
	local bRateTab = StrBaseRate[tItemID] or StrBaseRate[-1]
	local bRate = 1 + bRateTab[_StrLv+1]/100
	Item.SetData(_ItemIndex, %道具_攻击%, Item.GetData(_ItemIndex, %道具_攻击%)*bRate)
	Item.SetData(_ItemIndex, %道具_防御%, Item.GetData(_ItemIndex, %道具_防御%)*bRate)
	Item.SetData(_ItemIndex, %道具_敏捷%, Item.GetData(_ItemIndex, %道具_敏捷%)*bRate)
	Item.SetData(_ItemIndex, %道具_精神%, Item.GetData(_ItemIndex, %道具_精神%)*bRate)
	Item.SetData(_ItemIndex, %道具_回复%, Item.GetData(_ItemIndex, %道具_回复%)*bRate)
	Item.SetData(_ItemIndex, %道具_HP%, Item.GetData(_ItemIndex, %道具_HP%)*bRate)
	Item.SetData(_ItemIndex, %道具_MP%, Item.GetData(_ItemIndex, %道具_MP%)*bRate)
	Item.SetData(_ItemIndex, %道具_魔攻%, Item.GetData(_ItemIndex, %道具_魔攻%)*bRate)
	Item.SetData(_ItemIndex, %道具_魔抗%, Item.GetData(_ItemIndex, %道具_魔抗%)*bRate)
	--非0者固定加值
	local strData={%道具_毒抗%,%道具_睡抗%,%道具_石抗%,%道具_醉抗%,%道具_乱抗%,%道具_忘抗%,%道具_必杀%,%道具_反击%,%道具_命中%,%道具_闪躲%}
	--Resist
	local rRateTab = StrResistRate[tItemID] or StrResistRate[-1]
	local rRate = rRateTab[_StrLv+1]
	--Fix
	local fRateTab = StrFixRate[tItemID] or StrFixRate[-1]
	local fRate = fRateTab[_StrLv+1]
	for k,v in pairs(strData) do
 		if Item.GetData(_ItemIndex, v)>0 then
			if (k>=1 and k<=6) then
				Item.SetData(_ItemIndex, v, Item.GetData(_ItemIndex, v)+rRate)
			elseif (k>=7 and k<=10) then
				Item.SetData(_ItemIndex, v, Item.GetData(_ItemIndex, v)+fRate)
			end
		end
	end
	
end

function setItemName( _ItemIndex , _Name)
	local StatTab = EquipPlusStat( _ItemIndex )
	local ItemName = Item.GetData(_ItemIndex, %道具_鉴前名%)
	--⊙¤??Фф€◎●◇◆□■★☆㊣
	for k,v in pairs(StatTab) do
		if k=="S" then
			ItemName = ItemName .. "+" .. v
		elseif k=="R" then
			if v~=nil and v>0 then
				ItemName = _Name .. ItemName
			end
		elseif k=="D" then
			if v~=nil and v>0 then
				ItemName = "€" .. ItemName
			end
		elseif k=="L" then
			if v~=nil and v>0 then
				ItemName = "?" .. ItemName
			end
		elseif k=="E" then
			if v~=nil and v>0 then
				ItemName = "卍" .. ItemName
			end
		end
	end
	Item.SetData(_ItemIndex, %道具_名字%, ItemName)
end
