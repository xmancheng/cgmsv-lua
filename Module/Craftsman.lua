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
StrStrengEnable[-1] = 0	--是否开启默认设置
StrStrengEnable[-2] = 1	--是否开启默认设置
StrStrengEnable[-3] = 1	--是否开启默认设置
--【武器强化】设置的物品类型(0~6)
StrStrengMaxLv[-2] = 9									--最大可强化等级（次数）
StrBaseRate[-2] = 	{4, 4, 3, 3, 3, 2, 2, 2, 2}			--普通属性百分比
StrResistRate[-2] = 	{1, 1, 1, 1, 1, 1, 2, 2, 2}			--6抗性
StrFixRate[-2] = 	{1, 1, 1, 1, 1, 1, 2, 2, 2}			--4修正
StrSuccRate[-2] = 	{50, 45, 40, 35, 25, 20, 20, 20, 15}	--强化成功率
StrBreakRate[-2] = 	{0, 0, 0, 0, 0, 0, 0, 0, 0}		--强化破坏率
StrRequireItemID[-2] = {71037, 71037, 71037, 71037, 71037, 71037, 71037, 71037, 71037}		--强化需求物品ID（强化石ID）
StrRequireItemNum[-2] = {1, 4, 9, 16, 25, 36, 49, 64, 81, 100}			--强化需求物品数量（强化石数量）
StrRequireGold[-2] = {500, 2000, 4500, 8000, 12500, 18000, 24500, 32000, 40500, 50000}	--强化所需金币
--【防具强化】--设置的物品类型(7~14)
StrStrengMaxLv[-3] = 9									--最大可强化等级（次数）
StrBaseRate[-3] = 	{4, 4, 3, 3, 3, 2, 2, 2, 2}			--普通属性百分比
StrResistRate[-3] = 	{1, 1, 1, 1, 1, 1, 2, 2, 2}			--6抗性
StrFixRate[-3] = 	{1, 1, 1, 1, 1, 1, 2, 2, 2}			--4修正
StrSuccRate[-3] = 	{50, 45, 40, 35, 25, 20, 20, 20, 15}	--强化成功率
StrBreakRate[-3] = 	{0, 0, 0, 0, 0, 0, 0, 0, 0}		--强化破坏率
StrRequireItemID[-3] = {71038, 71038, 71038, 71038, 71038, 71038, 71038, 71038, 71038}		--强化需求物品ID（强化石ID）
StrRequireItemNum[-3] = {1, 4, 9, 16, 25, 36, 49, 64, 81, 100}			--强化需求物品数量（强化石数量）
StrRequireGold[-3] = {500, 2000, 4500, 8000, 12500, 18000, 24500, 32000, 40500, 50000}	--强化所需金币
--【其他不能强化】
StrStrengMaxLv[-1] = 9									--最大可强化等级（次数）
StrBaseRate[-1] = 	{4, 4, 3, 3, 3, 2, 2, 2, 2}			--普通属性百分比
StrResistRate[-1] = 	{1, 1, 1, 1, 1, 1, 2, 2, 2}			--6抗性
StrFixRate[-1] = 	{1, 1, 1, 1, 1, 1, 2, 2, 2}			--4修正
StrSuccRate[-1] = 	{50, 45, 40, 35, 25, 20, 20, 20, 15}	--强化成功率
StrBreakRate[-1] = 	{0, 0, 0, 0, 0, 0, 0, 0, 0}		--强化破坏率
StrRequireItemID[-1] = {71038, 71038, 71038, 71038, 71038, 71038, 71038, 71038, 71038}		--强化需求物品ID（强化石ID）
StrRequireItemNum[-1] = {1, 4, 9, 16, 25, 36, 49, 64, 81, 100}			--强化需求物品数量（强化石数量）
StrRequireGold[-1] = {500, 2000, 4500, 8000, 12500, 18000, 24500, 32000, 40500, 50000}	--强化所需金币

--【禁止强化】
--  一个装备一行，数值填写0即可
local StrItemEnable = {}
StrItemEnable[980491] = 0
StrItemEnable[250] = 0    --水龍之服
StrItemEnable[69105] = 0    --元素力量增幅器
StrItemEnable[69106] = 0
StrItemEnable[69107] = 0
StrItemEnable[69108] = 0
StrItemEnable[70053] = 0    --★完全支配術★
StrItemEnable[70054] = 0
StrItemEnable[70055] = 0
StrItemEnable[70056] = 0
StrItemEnable[70057] = 0
StrItemEnable[70058] = 0
StrItemEnable[70059] = 0
StrItemEnable[70060] = 0
StrItemEnable[79060] = 0    --副武器
StrItemEnable[79061] = 0
StrItemEnable[79062] = 0
StrItemEnable[79063] = 0
StrItemEnable[79064] = 0
StrItemEnable[79065] = 0
StrItemEnable[69226] = 0    --古老巨龍
StrItemEnable[69227] = 0
StrItemEnable[69228] = 0
StrItemEnable[69229] = 0
StrItemEnable[79215] = 0    --噴漆過編號
StrItemEnable[79216] = 0
StrItemEnable[79217] = 0
StrItemEnable[79218] = 0
StrItemEnable[79219] = 0
StrItemEnable[79220] = 0
StrItemEnable[79221] = 0
StrItemEnable[79222] = 0
StrItemEnable[79223] = 0
StrItemEnable[79224] = 0
StrItemEnable[79225] = 0
StrItemEnable[79226] = 0
StrItemEnable[79227] = 0
StrItemEnable[79228] = 0
StrItemEnable[79229] = 0
StrItemEnable[79230] = 0
StrItemEnable[79231] = 0
StrItemEnable[79232] = 0
StrItemEnable[79233] = 0
StrItemEnable[79234] = 0
StrItemEnable[79235] = 0
StrItemEnable[79236] = 0
StrItemEnable[79237] = 0
StrItemEnable[79238] = 0
StrItemEnable[79239] = 0
StrItemEnable[79240] = 0
StrItemEnable[79241] = 0
StrItemEnable[79242] = 0
StrItemEnable[79243] = 0
StrItemEnable[79244] = 0
StrItemEnable[79245] = 0
StrItemEnable[79246] = 0
StrItemEnable[79247] = 0
StrItemEnable[79248] = 0
StrItemEnable[79249] = 0


------------------------------------------------------------------------------
------------------------------------------------------------------------------
--                 【【【脚本系统设置】】】（非专业人事请勿修改）
------------------------------------------------------------------------------
local ItemPosName = {"頭 部", "身 体", "右 手", "左 手", "足 部", "飾品1", "飾品2", "水 晶"}
------------------------------------------------------------------------------

function CraftsmanNpc_Func(index)
	print("Craftsman.Index=" .. index);
	return 1;
end

Delegate.RegInit("CraftsmanNpc_Init");
function CraftsmanNpc_Init()
	local CraftsmanNpc = NL.CreateNpc("lua/Module/Craftsman.lua", "CraftsmanNpc_Func");
	Char.SetData( CraftsmanNpc, %对象_形象%,105502);
	Char.SetData( CraftsmanNpc, %对象_原形%,105502);
	Char.SetData( CraftsmanNpc, %对象_地图%,25000);
	Char.SetData( CraftsmanNpc, %对象_X%,28);
	Char.SetData( CraftsmanNpc, %对象_Y%,7);
	Char.SetData( CraftsmanNpc, %对象_方向%,4);
	Char.SetData( CraftsmanNpc, %对象_名字%,"裝備精煉神匠");
	NLG.UpChar( CraftsmanNpc)

	tbl_LuaNpcIndex = {}
	tbl_LuaNpcIndex["CraftsmanNpc"] = CraftsmanNpc

	if (Char.SetTalkedEvent(nil, "CraftsmanNpc_Talked", CraftsmanNpc) < 0) then
		print("CraftsmanNpc_Talked 注册事件失败。");
		return false;
	end

	if (Char.SetWindowTalkedEvent(nil, "CraftsmanNpc_WindowTalked", CraftsmanNpc) < 0) then
		print("CraftsmanNpc_WindowTalked 注册事件失败。");
		return false;
	end

	return true;
end

function CraftsmanNpc_Talked( _MeIndex, _PlayerIndex, _Mode)

	if(NLG.CheckInFront(_PlayerIndex, _MeIndex, 1)==false and _Mode~=1) then
		return ;
	end 

	NLG.ShowWindowTalked(_PlayerIndex, _MeIndex, 2, 2, 1,
			"8\n　　　　　　　◆" .. "裝備精煉神匠" .. "◆" ..
			"\n　　一位來自艾爾巴尼亞的流浪神匠，有著緋紅色" ..
			"\n頭髮的誇張外觀，他的國家曾與托爾法吉亞交雜著" ..
			"\n各種淵源與爭端。因此他不斷研究如何將物質濃縮" ..
			"\n成神級素材，能使鍛造物變得異常鋒利。" ..
			"\n　　這位艾國的流浪神匠，為了打破沙漏不再輪迴" ..
			"\n地發生戰爭，正在為冒險勇者們精煉裝備。" .. 
			"\n" ..
			"\n　　　　　　　　　『濃縮精煉』"
			);

	return ;
end

function CraftsmanNpc_WindowTalked( _MeIndex, _PlayerIndex, _Seqno, _Select, _Data)

	--print("\n_MeIndex=" .. _MeIndex .. ", _PlayerIndex=" .. _PlayerIndex .. ", _Seqno=" .. _Seqno .. ", _Data=" .. _Data)
	
	--取消按钮
	if _Select==2 then
		return
	end

	if _Seqno==1 then
		local PlayerSelect = tonumber(_Data)
		if PlayerSelect==1 then
			--属性强化
			local TalkBuf = "1|\n請選擇需要濃縮精煉強化的裝備：\n"
			for i = 0,7 do
				local tItemIndex = Char.GetItemIndex(_PlayerIndex, i);
				if tItemIndex>=0 then
					local tItemID = Item.GetData(tItemIndex, %道具_ID%)
					--print("tItemID=" .. tItemID)
					local tItemName = Item.GetData(tItemIndex, %道具_名字%)
					local tStrLv = EquipPlusStat(tItemIndex, "S") or 0
					local tType = Item.GetData(tItemIndex, %道具_类型%);
					if (tType>=0 and tType<=6) then
						tTypeID = -2;
					elseif (tType>=7 and tType<=14) then 
						tTypeID = -3;
					else
						tTypeID = -1;
					end
					--以下内容有改动
					local tMaxLv = StrStrengMaxLv[tTypeID]
					local tNeedItemNumTab = StrRequireItemNum[tTypeID]
					local tNeedItemNum = tNeedItemNumTab[tStrLv+1]
					local tNeedGoldTab = StrRequireGold[tTypeID]
					local tNeedGold = tNeedGoldTab[tStrLv+1]
					local tItemCan = "[强化Ｏ]  " .. tNeedItemNum .. "個|"  .. string.format("%.2f", tNeedGold/10000) .. "W"
					if StrItemEnable[tItemID]==0 and StrStrengEnable[tTypeID]==1 then
						tItemCan="[强化Ｘ]"
					elseif StrStrengEnable[tTypeID]==1 then
						tItemCan="[强化Ｏ]  " .. tNeedItemNum .. "個|"  .. string.format("%.2f", tNeedGold/10000) .. "W"
					elseif StrStrengEnable[tTypeID]~=1 then
						tItemCan="[强化Ｘ]"
					end
					if tStrLv>=tMaxLv then tItemCan="[强化Max]" end
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
			local tType = Item.GetData(tItemIndex, %道具_类型%);
			if (tType>=0 and tType<=6) then
				tTypeID = -2;
			elseif (tType>=7 and tType<=14) then 
				tTypeID = -3;
			else
				tTypeID = -1;
			end
			--CheckEnable
			local tStrLv = EquipPlusStat(tItemIndex, "S") or 0
			local tMaxLv = StrStrengMaxLv[tTypeID]
			if StrItemEnable[tItemID]==0 and StrStrengEnable[tTypeID]==1 then
				NLG.SystemMessage(_PlayerIndex, "[" .. "流浪神匠" .. "] 你選擇的裝備[" .. tItemName .. "]為[不可強化]！")
				return
			elseif StrStrengEnable[tTypeID]==1 then
			elseif StrStrengEnable[tTypeID]~=1 then
				NLG.SystemMessage(_PlayerIndex, "[" .. "流浪神匠" .. "] 你選擇的裝備[" .. tItemName .. "]為[不可強化]！")
				return
			end
			if tStrLv>=tMaxLv then
				NLG.SystemMessage(_PlayerIndex, "[" .. "流浪神匠" .. "] 你選擇的裝備[" .. tItemName .. "]已達到[強化Max]！")
				return
			end
			if StrStrengEnable[tTypeID]==0 then
				NLG.SystemMessage(_PlayerIndex, "[" .. "流浪神匠" .. "] 你選擇的裝備[" .. tItemName .. "]為[不可強化]！")
				return
			end
			if EquipPlusStat(tItemIndex, "D")~=nil then
				NLG.SystemMessage(_PlayerIndex, "[" .. "流浪神匠" .. "] 你選擇的裝備[" .. tItemName .. "]為[魔化裝備]，已達到極限！")
				return
			end
			if EquipPlusStat(tItemIndex, "E")~=nil then
				NLG.SystemMessage(_PlayerIndex, "[" .. "流浪神匠" .. "] 你選擇的裝備[" .. tItemName .. "]已血煉附魔，無法繼續強化！")
				return
			end
			if EquipPlusStat(tItemIndex, "R")~=nil then
				NLG.SystemMessage(_PlayerIndex, "[" .. "流浪神匠" .. "] 你選擇的裝備[" .. tItemName .. "]已鑲嵌符文，無法繼續強化！")
				return
			end
			--CheckGold
			local tNeedGoldTab = StrRequireGold[tTypeID]
			local tNeedGold = tonumber(tNeedGoldTab[tStrLv+1]) or 0
			if tPlayerGold<tNeedGold then
				NLG.SystemMessage(_PlayerIndex, "[" .. "流浪神匠" .. "] 強化需要" .. tNeedGold .. "G，所需金幣不足！")
				return
			end
			--CheckRequireItem
			local RequireItemIDTab = StrRequireItemID[tTypeID]
			local RequireItemID = RequireItemIDTab[tStrLv+1]
			local RequireItemNumTab = StrRequireItemNum[tTypeID]
			local RequireItemNum = RequireItemNumTab[tStrLv+1]
			if type(RequireItemID)=="number" and RequireItemID>0 and type(RequireItemNum)=="number" and RequireItemNum>0 then
				if Char.ItemNum(_PlayerIndex, RequireItemID)<RequireItemNum then
					NLG.SystemMessage(_PlayerIndex, "[" .. "流浪神匠" .. "] 強化所需道具不足！")
					return
				end
			end
			--DelGold
			Char.SetData(_PlayerIndex, %对象_金币%, tPlayerGold-tNeedGold)
			--DelItem
			Char.DelItem(_PlayerIndex, RequireItemID, RequireItemNum)
			--CheckBreak
			local BreakRateTab = StrBreakRate[tTypeID]
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
					NLG.SystemMessage(_PlayerIndex, "[" .. "流浪神匠" .. "] 這絕對是個災難！由於火力沒控制好，你的裝備徹底毀壞了……")
					--CraftsmanNpc_WindowTalked( _MeIndex, _PlayerIndex, 1, 1, 1)
					return
				end
			end
			--CheckSuccess
			local SuccRateTab = StrSuccRate[tTypeID]
			local SuccRate = SuccRateTab[tStrLv+1]
			if type(SuccRate)=="number" and SuccRate>0 then
				local tMin = 50 - math.floor(SuccRate/2) + 1
				local tMax = 50 + math.floor(SuccRate/2) + math.fmod(SuccRate,2)
				local tLuck = math.random(1, 100)
				if tLuck<tMin or tLuck>tMax then
					NLG.SystemMessage(_PlayerIndex, "[" .. "流浪神匠" .. "] 很不幸，你的裝備強化失敗……所幸裝備並沒有損壞……")
					CraftsmanNpc_WindowTalked( _MeIndex, _PlayerIndex, 1, 1, 1)
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
			NLG.SystemMessage(_PlayerIndex, "[" .. "流浪神匠" .. "] 恭喜你！裝備成功強化到+" .. tStrLv+1 .. "！")
			if (tStrLv+1>=7) then
				NLG.SystemMessage(-1, "[" .. "流浪神匠" .. "] 恭喜 "..Char.GetData(_PlayerIndex, %对象_名字%).."！將 "..Item.GetData(tItemIndex, %道具_鉴前名%).." 成功強化到+" .. tStrLv+1 .. "！")
			end
			--print("未鉴定名=" .. Item.GetData(tItemIndex, %道具_鉴前名%))
			--print("已鉴定名=" .. Item.GetData(tItemIndex, %道具_名字%))
			--print("自用参数=" .. Item.GetData(tItemIndex, %道具_自用参数%))
			CraftsmanNpc_WindowTalked( _MeIndex, _PlayerIndex, 1, 1, 1)
		else
			NLG.SystemMessage(_PlayerIndex, "[" .. "流浪神匠" .. "] 這裡沒有裝備，你想強化你的皮膚嗎？")
			--CraftsmanNpc_WindowTalked( _MeIndex, _PlayerIndex, 1, 1, 1)
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

function setItemStrData( _ItemIndex, _StrLv )
	local tItemID = Item.GetData(_ItemIndex, 0)
	local tType = Item.GetData(_ItemIndex, %道具_类型%);
	if (tType>=0 and tType<=6) then
		tTypeID = -2;
	elseif (tType>=7 and tType<=14) then 
		tTypeID = -3;
	else
		tTypeID = -1;
	end
	local bRateTab = StrBaseRate[tTypeID]
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
	local rRateTab = StrResistRate[tTypeID]
	local rRate = rRateTab[_StrLv+1]
	--Fix
	local fRateTab = StrFixRate[tTypeID]
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
