local StrModpetEnable = {}
local StrMax_BP = {}
local StrMax_CI = {}
local StrMax_AB = {}
local StrPetID = {}
local StrItemID = {}
local StrEnemyID = {}
local StrJudgment = {}

--  一种道具一段，请整段复制后再修改
StrModpetEnable[68006] = 1                                     --
StrItemID[68006] = 68006                                       --自定义宠物蛋道具编号
StrMax_BP[68006] = 160                                         --总和BP最大值
StrMax_CI[68006] = 20                                          --总和四修正最大值
StrMax_AB[68006] = 10                                          --总和四属性最大值
StrPetID[68006] = {107710,107711,107712,107713,110396,104338}	--开放自定义图檔编号
StrEnemyID[68006] = 500007                                     --Enemybase编号
StrJudgment[68006] = 0                                              --自定义图檔合法判断
--
StrModpetEnable[68007] = 1                                     --
StrItemID[68007] = 68007                                       --自定义宠物蛋道具编号
StrMax_BP[68007] = 170                                         --总和BP最大值
StrMax_CI[68007] = 30                                          --总和四修正最大值
StrMax_AB[68007] = 14                                          --总和四属性最大值
StrPetID[68007] = {101712,101713,101714}	                --开放自定义图檔编号
StrEnemyID[68007] = 500001                                     --Enemybase编号
StrJudgment[68007] = 1                                              --自定义图檔合法判断
--
StrModpetEnable[68008] = 1                                     --
StrItemID[68008] = 68008                                       --自定义宠物蛋道具编号
StrMax_BP[68008] = 180                                         --总和BP最大值
StrMax_CI[68008] = 35                                          --总和四修正最大值
StrMax_AB[68008] = 16                                          --总和四属性最大值
StrPetID[68008] = {110556,110557,110558,110559,110560,110561}	--开放自定义图檔编号
StrEnemyID[68008] = 500002                                     --Enemybase编号
StrJudgment[68008] = 1                                              --自定义图檔合法判断
--
StrModpetEnable[68009] = 1                                     --
StrItemID[68009] = 68009                                       --自定义宠物蛋道具编号
StrMax_BP[68009] = 190                                         --总和BP最大值
StrMax_CI[68009] = 40                                          --总和四修正最大值
StrMax_AB[68009] = 18                                          --总和四属性最大值
StrPetID[68009] = {101622,101623,101934,101244,101245,101824}	--开放自定义图檔编号
StrEnemyID[68009] = 500009                                     --Enemybase编号
StrJudgment[68009] = 1                                              --自定义图檔合法判断
----------------------------------------------------------------------------------------
Delegate.RegInit("ModularPetNpc_Init");
Delegate.RegDelTalkEvent("ModularPet_TalkEvent");

function ModularPetNpc_Init()
	ModularPetNpc = NL.CreateNpc(nil, "Myinit");
	Char.SetData(ModularPetNpc,%对象_形象%,14682);
	Char.SetData(ModularPetNpc,%对象_原形%,14682);
	Char.SetData(ModularPetNpc,%对象_X%,36);
	Char.SetData(ModularPetNpc,%对象_Y%,35);
	Char.SetData(ModularPetNpc,%对象_地图%,777);
	Char.SetData(ModularPetNpc,%对象_方向%,0);
	Char.SetData(ModularPetNpc,%对象_名字%,"自定义宠物蛋");
	NLG.UpChar(ModularPetNpc);
	tbl_ModularPetNpc = tbl_ModularPetNpc or {}
	tbl_ModularPetNpc["ModularPetNpc"] = ModularPetNpc;
	Char.SetTalkedEvent(nil, "ModularPetNpc_Talked", ModularPetNpc);
	Char.SetWindowTalkedEvent(nil, "ModularPetNpc_WindowTalked", ModularPetNpc);
	return true;
end

function Myinit(_MeIndex)
	return true;
end

function ModularPetNpc_Talked( _MeIndex, _PlayerIndex, _Mode)
	if (Char.PetNum(_PlayerIndex) >= 5) then
		NLG.SystemMessage(_PlayerIndex, "[系統]寵物欄位置不夠。")
		return;
	end
	if (VaildChar(Char.HavePet(_PlayerIndex,500000)) == true) then
		NLG.SystemMessage(_PlayerIndex, "[系統]操作時寵物欄只能有一隻自訂寵物。")
		return;
	end
	if (VaildChar(Char.HavePet(_PlayerIndex,500001)) == true) then
		NLG.SystemMessage(_PlayerIndex, "[系統]操作時寵物欄只能有一隻自訂寵物。")
		return;
	end
	if (VaildChar(Char.HavePet(_PlayerIndex,500002)) == true) then
		NLG.SystemMessage(_PlayerIndex, "[系統]操作時寵物欄只能有一隻自訂寵物。")
		return;
	end
	if (VaildChar(Char.HavePet(_PlayerIndex,500003)) == true) then
		NLG.SystemMessage(_PlayerIndex, "[系統]操作時寵物欄只能有一隻自訂寵物。")
		return;
	end
	if (VaildChar(Char.HavePet(_PlayerIndex,500004)) == true) then
		NLG.SystemMessage(_PlayerIndex, "[系統]操作時寵物欄只能有一隻自訂寵物。")
		return;
	end
	if (VaildChar(Char.HavePet(_PlayerIndex,500005)) == true) then
		NLG.SystemMessage(_PlayerIndex, "[系統]操作時寵物欄只能有一隻自訂寵物。")
		return;
	end
	if (VaildChar(Char.HavePet(_PlayerIndex,500006)) == true) then
		NLG.SystemMessage(_PlayerIndex, "[系統]操作時寵物欄只能有一隻自訂寵物。")
		return;
	end
	if (VaildChar(Char.HavePet(_PlayerIndex,500007)) == true) then
		NLG.SystemMessage(_PlayerIndex, "[系統]操作時寵物欄只能有一隻自訂寵物。")
		return;
	end
	if (VaildChar(Char.HavePet(_PlayerIndex,500008)) == true) then
		NLG.SystemMessage(_PlayerIndex, "[系統]操作時寵物欄只能有一隻自訂寵物。")
		return;
	end
	if (VaildChar(Char.HavePet(_PlayerIndex,500009)) == true) then
		NLG.SystemMessage(_PlayerIndex, "[系統]操作時寵物欄只能有一隻自訂寵物。")
		return;
	end
	local TalkMsg =	"4\\n◆自訂寵物蛋◆" ..
			"\\n自由編輯一隻寵物的系統" ..
			"\\n包含檔次、修正、屬性、造型、原始名字" ..
			"\\n請依序進行並在上線狀態完成" ..
			"\\n『1.檔次』" ..
			"\\n『2.修正』" ..
			"\\n『3.屬性』" ..
			"\\n『4.造型』"..
			"\\n『5.取名確認』"
	TalkMsg =Shor_GAMsgFormat(TalkMsg);
	Shor_ShowGAWindowTalk(_PlayerIndex, 2, 2, 1,TalkMsg,_MeIndex);
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

NL.RegItemString("lua/Module/ModularPet.lua","ModularPet","LUA_useModPet");
function ModularPet(_PlayerIndex,_toIndex,_itemslot) --双击道具执行函数
	ModularPetNpc_Talked(tbl_ModularPetNpc["ModularPetNpc"], _PlayerIndex, 0, 0, 0)
	return 1;
end

function ModularPet_TalkEvent(player,msg,color,range,size)
	if msg == "[modpet]" then
		ModularPetNpc_Talked(tbl_ModularPetNpc["ModularPetNpc"], player, 0, 0, 0)
	end
end

function ModularPetNpc_WindowTalked( _MeIndex, _PlayerIndex, _Seqno, _Select, _Data)
	local CdKey = Char.GetData(_PlayerIndex, %对象_CDK%)
	for i=8,20 do
		tItemIndex = Char.GetItemIndex(_PlayerIndex, i);
		tItemID = Item.GetData(tItemIndex, 0);
		if (VaildChar(tItemIndex) == true and StrModpetEnable[tItemID] == 1) then
			bItemID = StrItemID[tItemID]
			tMax_BP = StrMax_BP[tItemID]
			tMax_CI = StrMax_CI[tItemID]
			tMax_AB = StrMax_AB[tItemID]
			tPetID = StrPetID[tItemID]
			tEnemyID = StrEnemyID[tItemID]
			tJudgment = StrJudgment[tItemID]
		end
		if StrModpetEnable[tItemID] ~= 1 then
			--NLG.SystemMessage(_PlayerIndex, "[系統]缺少對應的道具。")
		end
	end
	--取消按钮
	if _Select==2 then
		return
	end
	

	if _Seqno==1 then
		local PlayerSelect = tonumber(_Data)
		--查询
		if PlayerSelect==1 then
			local TalkBuf =	"4\\n檔次項目共"..tMax_BP.."點：" ..
					"\\n單項最低13點，最高55點" ..
					"\\n請依序進行編輯" ..
					"\\n " ..
					"\\n『體力』" ..
					"\\n『力量』" ..
					"\\n『強度』" ..
					"\\n『速度』"..
					"\\n『魔法』"
			NLG.ShowWindowTalked(_PlayerIndex, _MeIndex, 2, 2, 10, TalkBuf);
			return;
		end
		if PlayerSelect==2 then
			local TalkBuf =	"4\\n修正項目共"..tMax_CI.."點：" ..
					"\\n單項最低0點，最高30點" ..
					"\\n請依序進行編輯" ..
					"\\n " ..
					"\\n『必殺』" ..
					"\\n『反擊』" ..
					"\\n『命中』" ..
					"\\n『閃躲』"
			NLG.ShowWindowTalked(_PlayerIndex, _MeIndex, 2, 2, 11, TalkBuf);
			return;
		end
		if PlayerSelect==3 then
			local TalkBuf =	"4\\n屬性專案共"..tMax_AB.."點：" ..
					"\\n單項最低0點，最高10點" ..
					"\\n請依序進行編輯" ..
					"\\n " ..
					"\\n『地屬性』" ..
					"\\n『水屬性』" ..
					"\\n『火屬性』" ..
					"\\n『風屬性』"
			NLG.ShowWindowTalked(_PlayerIndex, _MeIndex, 2, 2, 12, TalkBuf);
			return;
		end
		if PlayerSelect==4 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%按钮_确定%,13,"\n開放自訂寵物\n\n造型形象編號\n\n參照官方公告連結\n\n請輸入編號例如101824！",_MeIndex);
			return;
		end
		if PlayerSelect==5 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%按钮_确定%,14,"\n最後一個步驟了\n\n請為你的寵物\n\n取個名字，不宜太長！",_MeIndex);
			return;
		end
	end
	if _Seqno==10 then
		local PlayerSelect1 = tonumber(_Data)
		if PlayerSelect1==1 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%按钮_确定%,15,"\n檔次項目共"..tMax_BP.."點：\n\n體力單項最低13點，體力單項最高55點\n\n請輸入體力BP！",_MeIndex);
			return;
		end
		if PlayerSelect1==2 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%按钮_确定%,16,"\n檔次項目剩下"..Left_BP2.."點：\n\n力量單項最低13點，力量單項最高55點\n\n請輸入力量BP！",_MeIndex);
			return;
		end
		if PlayerSelect1==3 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%按钮_确定%,17,"\n檔次項目剩下"..Left_BP3.."點：\n\n強度單項最低13點，強度單項最高55點\n\n請輸入強度BP！",_MeIndex);
			return;
		end
		if PlayerSelect1==4 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%按钮_确定%,18,"\n檔次項目剩下"..Left_BP4.."點：\n\n速度單項最低13點，速度單項最高55點\n\n請輸入速度BP！",_MeIndex);
			return;
		end
		if PlayerSelect1==5 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%按钮_确定%,19,"\n檔次項目剩下"..Left_BP5.."點：\n\n魔法單項最低13點，魔法單項最高55點\n\n請輸入魔法BP！",_MeIndex);
			return;
		end
	end
	if(tonumber(_Seqno)==15 and tonumber(_Select)==%按钮_确定% and _Data~="")then
		arr_rank11 = tonumber("".._Data.."")
		if arr_rank11 <= 12 or arr_rank11 >= 56 then
			NLG.SystemMessage(_PlayerIndex, "[系統]超出檔次範圍。當前項目BP單項最低為13點，最高為55點。")
			return;
		end
		if arr_rank11 <= 55 and arr_rank11 >= 13 then
			Left_BP2 = tMax_BP - arr_rank11;
			NLG.SystemMessage(_PlayerIndex, "[系統]檔次分配:體力"..arr_rank11.."。")
		else
			NLG.SystemMessage(_PlayerIndex, "[系統]檔次點數不足，無法成功分配。")
		end
	end
	if(tonumber(_Seqno)==16 and tonumber(_Select)==%按钮_确定% and _Data~="")then
		arr_rank21 = tonumber("".._Data.."")
		if arr_rank21 <= 12 or arr_rank21 >= 56 then
			NLG.SystemMessage(_PlayerIndex, "[系統]超出檔次範圍。當前項目BP單項最低為13點，最高為55點。")
			return;
		end
		if arr_rank21 <= 55 and arr_rank21 >= 13 then
			Left_BP3 = Left_BP2 - arr_rank21;
			NLG.SystemMessage(_PlayerIndex, "[系統]檔次分配:體力"..arr_rank11..",力量"..arr_rank21.."。")
		else
			NLG.SystemMessage(_PlayerIndex, "[系統]檔次點數不足，無法成功分配。")
		end
	end
	if(tonumber(_Seqno)==17 and tonumber(_Select)==%按钮_确定% and _Data~="")then
		arr_rank31 = tonumber("".._Data.."")
		if arr_rank31 <= 12 or arr_rank31 >= 56 then
			NLG.SystemMessage(_PlayerIndex, "[系統]超出檔次範圍。當前項目BP單項最低為13點，最高為55點。")
			return;
		end
		if arr_rank31 <= 55 and arr_rank31 >= 13 then
			Left_BP4 = Left_BP3 - arr_rank31;
			NLG.SystemMessage(_PlayerIndex, "[系統]檔次分配:體力"..arr_rank11..",力量"..arr_rank21..",強度"..arr_rank31.."。")
		else
			NLG.SystemMessage(_PlayerIndex, "[系統]檔次點數不足，無法成功分配。")
		end
	end
	if(tonumber(_Seqno)==18 and tonumber(_Select)==%按钮_确定% and _Data~="")then
		arr_rank41 = tonumber("".._Data.."")
		if arr_rank41 <= 12 or arr_rank41 >= 56 then
			NLG.SystemMessage(_PlayerIndex, "[系統]超出檔次範圍。當前項目BP單項最低為13點，最高為55點。")
			return;
		end
		if arr_rank41 <= 55 and arr_rank41 >= 13 then
			Left_BP5 = Left_BP4 - arr_rank41;
			NLG.SystemMessage(_PlayerIndex, "[系統]檔次分配:體力"..arr_rank11..",力量"..arr_rank21..",強度"..arr_rank31..",速度"..arr_rank41.."。")
		else
			NLG.SystemMessage(_PlayerIndex, "[系統]檔次點數不足，無法成功分配。")
		end
	end
	if(tonumber(_Seqno)==19 and tonumber(_Select)==%按钮_确定% and _Data~="")then
		arr_rank51 = tonumber("".._Data.."")
		if arr_rank51 <= 12 or arr_rank51 >= 56 then
			NLG.SystemMessage(_PlayerIndex, "[系統]超出檔次範圍。當前項目BP單項最低為13點，最高為55點。")
			return;
		end
		if arr_rank51 <= 55 and arr_rank51 >= 13 then
			NLG.SystemMessage(_PlayerIndex, "[系統]檔次分配:體力"..arr_rank11..",力量"..arr_rank21..",強度"..arr_rank31..",速度"..arr_rank41..",魔法"..arr_rank51.."。")
		else
			NLG.SystemMessage(_PlayerIndex, "[系統]檔次點數不足，無法成功分配。")
		end
	end
	if _Seqno==11 then
		local PlayerSelect1 = tonumber(_Data)
		if PlayerSelect1==1 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%按钮_确定%,20,"\n修正專案共"..tMax_CI.."點：\n\n必殺單項最低0點，必殺單項最高30點\n\n請輸入必殺！",_MeIndex);
			return;
		end
		if PlayerSelect1==2 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%按钮_确定%,21,"\n修正專案剩下"..Left_CI2.."點：\n\n反擊單項最低0點，反擊單項最高30點\n\n請輸入反擊！",_MeIndex);
			return;
		end
		if PlayerSelect1==3 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%按钮_确定%,22,"\n修正專案剩下"..Left_CI3.."點：\n\n命中單項最低0點，命中單項最高30點\n\n請輸入命中！",_MeIndex);
			return;
		end
		if PlayerSelect1==4 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%按钮_确定%,23,"\n修正專案剩下"..Left_CI4.."點：\n\n閃躲單項最低0點，閃躲單項最高30點\n\n請輸入閃躲！",_MeIndex);
			return;
		end
	end
	if(tonumber(_Seqno)==20 and tonumber(_Select)==%按钮_确定% and _Data~="")then
		critical = tonumber("".._Data.."")
		if critical < 0 or critical >= 31 then
			NLG.SystemMessage(_PlayerIndex, "[系統]超出修正範圍。當前項目單項最低為0點，最高為30點。")
			return;
		end
		if critical <= 30 and critical >= 0 then
			Left_CI2 = tMax_CI - critical;
			NLG.SystemMessage(_PlayerIndex, "[系統]修正分配:必殺"..critical.."。")
		else
			NLG.SystemMessage(_PlayerIndex, "[系統]修正點數不足，無法成功分配。")
		end
	end
	if(tonumber(_Seqno)==21 and tonumber(_Select)==%按钮_确定% and _Data~="")then
		counter = tonumber("".._Data.."")
		if counter < 0 or counter >= 31 then
			NLG.SystemMessage(_PlayerIndex, "[系統]超出修正範圍。當前項目單項最低為0點，最高為30點。")
			return;
		end
		if counter <= 30 and counter >= 0 then
			Left_CI3 = Left_CI2 - counter;
			NLG.SystemMessage(_PlayerIndex, "[系統]修正分配:必殺"..critical..",反擊"..counter.."。")
		else
			NLG.SystemMessage(_PlayerIndex, "[系統]修正點數不足，無法成功分配。")
		end
	end
	if(tonumber(_Seqno)==22 and tonumber(_Select)==%按钮_确定% and _Data~="")then
		hitrate = tonumber("".._Data.."")
		if hitrate < 0 or hitrate >= 31 then
			NLG.SystemMessage(_PlayerIndex, "[系統]超出修正範圍。當前項目單項最低為0點，最高為30點。")
			return;
		end
		if hitrate <= 30 and hitrate >= 0 then
			Left_CI4 = Left_CI3 - hitrate;
			NLG.SystemMessage(_PlayerIndex, "[系統]修正分配:必殺"..critical..",反擊"..counter..",命中"..hitrate.."。")
		else
			NLG.SystemMessage(_PlayerIndex, "[系統]修正點數不足，無法成功分配。")
		end
	end
	if(tonumber(_Seqno)==23 and tonumber(_Select)==%按钮_确定% and _Data~="")then
		avoid = tonumber("".._Data.."")
		if avoid < 0 or avoid >= 31 then
			NLG.SystemMessage(_PlayerIndex, "[系統]超出修正範圍。當前項目單項最低為0點，最高為30點。")
			return;
		end
		CI = critical + counter + hitrate + avoid;
		if CI < tMax_CI or CI > tMax_CI then
			NLG.SystemMessage(_PlayerIndex, "[系統]修正點數不足，無法成功分配。")
			return;
		end
		if (avoid <= 30 and avoid >= 0 ) then
			NLG.SystemMessage(_PlayerIndex, "[系統]修正分配:必殺"..critical..",反擊"..counter..",命中"..hitrate..",閃躲"..avoid.."。")
		else
			--NLG.SystemMessage(_PlayerIndex, "[系統]無法自訂的寵物。")
		end
	end
	if _Seqno==12 then
		local PlayerSelect1 = tonumber(_Data)
		if PlayerSelect1==1 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%按钮_确定%,24,"\n屬性專案共"..tMax_AB.."點：\n\n地屬性單項最低0點，地屬性單項最高10點\n\n請輸入地屬性！",_MeIndex);
			return;
		end
		if PlayerSelect1==2 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%按钮_确定%,25,"\n屬性專案剩下"..Left_AB2.."點：\n\n水屬性單項最低0點，水屬性單項最高10點\n\n請輸入水屬性！",_MeIndex);
			return;
		end
		if PlayerSelect1==3 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%按钮_确定%,26,"\n屬性專案剩下"..Left_AB3.."點：\n\n火屬性單項最低0點，火屬性單項最高10點\n\n請輸入火屬性！",_MeIndex);
			return;
		end
		if PlayerSelect1==4 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%按钮_确定%,27,"\n屬性專案剩下"..Left_AB4.."點：\n\n風屬性單項最低0點，風屬性單項最高10點\n\n請輸入風屬性！",_MeIndex);
			return;
		end
	end
	if(tonumber(_Seqno)==24 and tonumber(_Select)==%按钮_确定% and _Data~="")then
		ground = tonumber("".._Data.."")
		if ground < 0 or ground >= 11 then
			NLG.SystemMessage(_PlayerIndex, "[系統]超出屬性範圍。當前項目單項最低為0點，最高為10點。")
			return;
		end
		if ground <= 10 and ground >= 0 then
			Left_AB2 = tMax_AB - ground;
			NLG.SystemMessage(_PlayerIndex, "[系統]屬性分配:地屬性"..ground.."。")
		else
			NLG.SystemMessage(_PlayerIndex, "[系統]屬性點數不足，無法成功分配。")
		end
	end
	if(tonumber(_Seqno)==25 and tonumber(_Select)==%按钮_确定% and _Data~="")then
		water = tonumber("".._Data.."")
		if water < 0 or water >= 11 then
			NLG.SystemMessage(_PlayerIndex, "[系統]超出屬性範圍。當前項目單項最低為0點，最高為10點。")
			return;
		end
		if water <= 10 and water >= 0 then
			Left_AB3 = Left_AB2 - water;
			NLG.SystemMessage(_PlayerIndex, "[系統]屬性分配:地屬性"..ground..",水屬性"..water.."。")
		else
			NLG.SystemMessage(_PlayerIndex, "[系統]屬性點數不足，無法成功分配。")
		end
	end
	if(tonumber(_Seqno)==26 and tonumber(_Select)==%按钮_确定% and _Data~="")then
		fire = tonumber("".._Data.."")
		if fire < 0 or fire >= 11 then
			NLG.SystemMessage(_PlayerIndex, "[系統]超出屬性範圍。當前項目單項最低為0點，最高為10點。")
			return;
		end
		if fire <= 10 and fire >= 0 then
			Left_AB4 = Left_AB3 - fire;
			NLG.SystemMessage(_PlayerIndex, "[系統]屬性分配:地屬性"..ground..",水屬性"..water..",火屬性"..fire.."。")
		else
			NLG.SystemMessage(_PlayerIndex, "[系統]屬性點數不足，無法成功分配。")
		end
	end
	if(tonumber(_Seqno)==27 and tonumber(_Select)==%按钮_确定% and _Data~="")then
		wind = tonumber("".._Data.."")
		if wind < 0 or wind >= 11 then
			NLG.SystemMessage(_PlayerIndex, "[系統]超出屬性範圍。當前項目單項最低為0點，最高為10點。")
			return;
		end
		AB = ground + water + fire + wind;
		if AB < tMax_AB or AB > tMax_AB then
			NLG.SystemMessage(_PlayerIndex, "[系統]屬性點數不足，無法成功分配。")
			return;
		end
		if (wind <= 10 and wind >= 0) then
			NLG.SystemMessage(_PlayerIndex, "[系統]屬性分配:地屬性"..ground..",水屬性"..water..",火屬性"..fire..",風屬性"..wind.."。")
		else
			--NLG.SystemMessage(_PlayerIndex, "[系統]無法自訂的寵物。")
		end
	end
	if(tonumber(_Seqno)==13 and tonumber(_Select)==%按钮_确定% and _Data~="")then
		PetTD1 = tonumber("".._Data.."")
		if tJudgment == 0 then
			NLG.SystemMessage(_PlayerIndex, "[系統]造型形象編號登錄完成:"..PetTD1.."。")
		elseif tJudgment == 1 and PET_CheckInTable(tPetID,PetTD1)==true then
			NLG.SystemMessage(_PlayerIndex, "[系統]造型形象編號登錄完成:"..PetTD1.."。")
		else
			NLG.SystemMessage(_PlayerIndex, "[系統]造型形象編號，請參照官方公告連結。")
			return;
		end
	end
	if(tonumber(_Seqno)==14 and tonumber(_Select)==%按钮_确定% and _Data~="") then
		local name = _Data;
		BP = arr_rank11 + arr_rank21 + arr_rank31 + arr_rank41 + arr_rank51;
		if BP < tMax_BP or BP > tMax_BP then
			NLG.SystemMessage(_PlayerIndex, "[系統]請確認檔次點數輸入正確。")
			return;
		end
		if (BP == tMax_BP and CI == tMax_CI and AB == tMax_AB) then
			Char.AddPet(_PlayerIndex,tEnemyID);
		else
			NLG.SystemMessage(_PlayerIndex, "[系統]請確認前幾項點數輸入正確。")
		end
		for Slot=0,4 do
			local _PetIndex = Char.GetPet(_PlayerIndex,Slot);
			local image = Char.GetData(_PetIndex,%对象_形象%);
			if (BP == tMax_BP and CI == tMax_CI and AB == tMax_AB and image == 100902) then
				Pet.SetArtRank(_PetIndex,%宠档_体成%,arr_rank11 - math.random(0,0));  --自定义分布后随机掉檔0~4
				Pet.SetArtRank(_PetIndex,%宠档_力成%,arr_rank21 - math.random(0,0));
				Pet.SetArtRank(_PetIndex,%宠档_强成%,arr_rank31 - math.random(0,0));
				Pet.SetArtRank(_PetIndex,%宠档_敏成%,arr_rank41 - math.random(0,0));
				Pet.SetArtRank(_PetIndex,%宠档_魔成%,arr_rank51 - math.random(0,0));
				Pet.ReBirth(_PlayerIndex, _PetIndex);
				Char.SetData(_PetIndex,%对象_必杀%,critical);
				Char.SetData(_PetIndex,%对象_反击%,counter);
				Char.SetData(_PetIndex,%对象_命中%,hitrate);
				Char.SetData(_PetIndex,%对象_闪躲%,avoid);
				Char.SetData(_PetIndex,%对象_地属性%,ground*10);
				Char.SetData(_PetIndex,%对象_水属性%,water*10);
				Char.SetData(_PetIndex,%对象_火属性%,fire*10);
				Char.SetData(_PetIndex,%对象_风属性%,wind*10);
				Char.SetData(_PetIndex,%对象_形象%,PetTD1);
				Char.SetData(_PetIndex,%对象_原形%,PetTD1);
				Char.SetData(_PetIndex,%对象_名字%,name);
				Char.SetData(_PetIndex,%对象_名色%,6);  --自定义宠物为红色名字
				Pet.UpPet(_PlayerIndex,_PetIndex);
				Char.DelItem(_PlayerIndex,bItemID,1);
				NLG.SystemMessage(_PlayerIndex, "[系統]自訂寵物已完美結束。")
			end
		end
	end
end
