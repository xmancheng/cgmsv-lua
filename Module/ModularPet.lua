local StrModpetEnable = {}
local StrMax_BP = {}
local StrMax_CI = {}
local StrMax_AB = {}
local StrPetID = {}
local StrItemID = {}
local StrEnemyID = {}
local StrJudgment = {}

--  一种道具一段，请整段复制后再修改
local ItemID = 68006                                            --自定义宠物蛋道具编号
StrModpetEnable[ItemID] = 1                                     --
StrItemID[ItemID] = 68006                                       --自定义宠物蛋道具编号
StrMax_BP[ItemID] = 160                                         --总和BP最大值
StrMax_CI[ItemID] = 20                                          --总和四修正最大值
StrMax_AB[ItemID] = 10                                          --总和四属性最大值
StrPetID[ItemID] = {107710,107711,107712,107713,110396,104338}	--开放自定义图檔编号
StrEnemyID[ItemID] = 500007                                     --Enemybase编号
StrJudgment[ItemID] = 0                                              --自定义图檔合法判断
--
local ItemID = 68007                                            --自定义宠物蛋道具编号
StrModpetEnable[ItemID] = 1                                     --
StrItemID[ItemID] = 68007                                       --自定义宠物蛋道具编号
StrMax_BP[ItemID] = 170                                         --总和BP最大值
StrMax_CI[ItemID] = 30                                          --总和四修正最大值
StrMax_AB[ItemID] = 14                                          --总和四属性最大值
StrPetID[ItemID] = {101712,101713,101714}	                --开放自定义图檔编号
StrEnemyID[ItemID] = 500001                                     --Enemybase编号
StrJudgment[ItemID] = 1                                              --自定义图檔合法判断
--
local ItemID = 68008                                            --自定义宠物蛋道具编号
StrModpetEnable[ItemID] = 1                                     --
StrItemID[ItemID] = 68008                                       --自定义宠物蛋道具编号
StrMax_BP[ItemID] = 180                                         --总和BP最大值
StrMax_CI[ItemID] = 35                                          --总和四修正最大值
StrMax_AB[ItemID] = 16                                          --总和四属性最大值
StrPetID[ItemID] = {110556,110557,110558,110559,110560,110561}	--开放自定义图檔编号
StrEnemyID[ItemID] = 500002                                     --Enemybase编号
StrJudgment[ItemID] = 1                                              --自定义图檔合法判断
--
local ItemID = 68009                                            --自定义宠物蛋道具编号
StrModpetEnable[ItemID] = 1                                     --
StrItemID[ItemID] = 68009                                       --自定义宠物蛋道具编号
StrMax_BP[ItemID] = 190                                         --总和BP最大值
StrMax_CI[ItemID] = 40                                          --总和四修正最大值
StrMax_AB[ItemID] = 18                                          --总和四属性最大值
StrPetID[ItemID] = {101622,101623,101934,101244,101245,101824}	--开放自定义图檔编号
StrEnemyID[ItemID] = 500009                                     --Enemybase编号
StrJudgment[ItemID] = 1                                              --自定义图檔合法判断
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
		NLG.SystemMessage(_PlayerIndex, "[系统]宠物栏位置不够。")
		return;
	end
	if (VaildChar(Char.HavePet(_PlayerIndex,500000)) == true) then
		NLG.SystemMessage(_PlayerIndex, "[系统]操作时宠物栏只能有一只自定义宠物。")
		return;
	end
	if (VaildChar(Char.HavePet(_PlayerIndex,500001)) == true) then
		NLG.SystemMessage(_PlayerIndex, "[系统]操作时宠物栏只能有一只自定义宠物。")
		return;
	end
	if (VaildChar(Char.HavePet(_PlayerIndex,500002)) == true) then
		NLG.SystemMessage(_PlayerIndex, "[系统]操作时宠物栏只能有一只自定义宠物。")
		return;
	end
	if (VaildChar(Char.HavePet(_PlayerIndex,500003)) == true) then
		NLG.SystemMessage(_PlayerIndex, "[系统]操作时宠物栏只能有一只自定义宠物。")
		return;
	end
	if (VaildChar(Char.HavePet(_PlayerIndex,500004)) == true) then
		NLG.SystemMessage(_PlayerIndex, "[系统]操作时宠物栏只能有一只自定义宠物。")
		return;
	end
	if (VaildChar(Char.HavePet(_PlayerIndex,500005)) == true) then
		NLG.SystemMessage(_PlayerIndex, "[系统]操作时宠物栏只能有一只自定义宠物。")
		return;
	end
	if (VaildChar(Char.HavePet(_PlayerIndex,500006)) == true) then
		NLG.SystemMessage(_PlayerIndex, "[系统]操作时宠物栏只能有一只自定义宠物。")
		return;
	end
	if (VaildChar(Char.HavePet(_PlayerIndex,500007)) == true) then
		NLG.SystemMessage(_PlayerIndex, "[系统]操作时宠物栏只能有一只自定义宠物。")
		return;
	end
	if (VaildChar(Char.HavePet(_PlayerIndex,500008)) == true) then
		NLG.SystemMessage(_PlayerIndex, "[系统]操作时宠物栏只能有一只自定义宠物。")
		return;
	end
	if (VaildChar(Char.HavePet(_PlayerIndex,500009)) == true) then
		NLG.SystemMessage(_PlayerIndex, "[系统]操作时宠物栏只能有一只自定义宠物。")
		return;
	end
	local TalkMsg =	"4\\n◆自定义宠物蛋◆" ..
			"\\n自由编辑一只宠物的系统" ..
			"\\n包含档次、修正、属性、造型、原始名字" ..
			"\\n请依序进行并在上线状态完成" ..
			"\\n『1.档次』" ..
			"\\n『2.修正』" ..
			"\\n『3.属性』" ..
			"\\n『4.造型』"..
			"\\n『5.取名确认』" 
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
			--NLG.SystemMessage(_PlayerIndex, "[系统]缺少对应的道具。")
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
			local TalkBuf =	"4\\n档次项目共"..tMax_BP.."点：" ..
					"\\n单项最低13点，最高55点" ..
					"\\n请依序进行编辑" ..
					"\\n " ..
					"\\n『体力』" ..
					"\\n『力量』" ..
					"\\n『强度』" ..
					"\\n『速度』"..
					"\\n『魔法』" 
			NLG.ShowWindowTalked(_PlayerIndex, _MeIndex, 2, 2, 10, TalkBuf);
			return;
		end
		if PlayerSelect==2 then
			local TalkBuf =	"4\\n修正项目共"..tMax_CI.."点：" ..
					"\\n单项最低0点，最高30点" ..
					"\\n请依序进行编辑" ..
					"\\n " ..
					"\\n『必杀』" ..
					"\\n『反击』" ..
					"\\n『命中』" ..
					"\\n『闪躲』" 
			NLG.ShowWindowTalked(_PlayerIndex, _MeIndex, 2, 2, 11, TalkBuf);
			return;
		end
		if PlayerSelect==3 then
			local TalkBuf =	"4\\n属性项目共"..tMax_AB.."点：" ..
					"\\n单项最低0点，最高10点" ..
					"\\n请依序进行编辑" ..
					"\\n " ..
					"\\n『地属性』" ..
					"\\n『水属性』" ..
					"\\n『火属性』" ..
					"\\n『风属性』" 
			NLG.ShowWindowTalked(_PlayerIndex, _MeIndex, 2, 2, 12, TalkBuf);
			return;
		end
		if PlayerSelect==4 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%按钮_确定%,13,"\n开放自定义宠物\n\n造型形象编号\n\n参照官方公告连结\n\n请输入编号例如101824！",_MeIndex);
			return;
		end
		if PlayerSelect==5 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%按钮_确定%,14,"\n最后一个步骤了\n\n请为你的宠物\n\n取个名字，不宜太长！",_MeIndex);
			return;
		end
	end
	if _Seqno==10 then
		local PlayerSelect1 = tonumber(_Data)
		if PlayerSelect1==1 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%按钮_确定%,15,"\n档次项目共"..tMax_BP.."点：\n\n体力单项最低13点，体力单项最高55点\n\n请输入体力BP！",_MeIndex);
			return;
		end
		if PlayerSelect1==2 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%按钮_确定%,16,"\n档次项目剩下"..Left_BP2.."点：\n\n力量单项最低13点，力量单项最高55点\n\n请输入力量BP！",_MeIndex);
			return;
		end
		if PlayerSelect1==3 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%按钮_确定%,17,"\n档次项目剩下"..Left_BP3.."点：\n\n强度单项最低13点，强度单项最高55点\n\n请输入强度BP！",_MeIndex);
			return;
		end
		if PlayerSelect1==4 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%按钮_确定%,18,"\n档次项目剩下"..Left_BP4.."点：\n\n速度单项最低13点，速度单项最高55点\n\n请输入速度BP！",_MeIndex);
			return;
		end
		if PlayerSelect1==5 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%按钮_确定%,19,"\n档次项目剩下"..Left_BP5.."点：\n\n魔法单项最低13点，魔法单项最高55点\n\n请输入魔法BP！",_MeIndex);
			return;
		end
	end
	if(tonumber(_Seqno)==15 and tonumber(_Select)==%按钮_确定% and _Data~="")then
		arr_rank11 = tonumber("".._Data.."")
		if arr_rank11 <= 12 or arr_rank11 >= 56 then
			NLG.SystemMessage(_PlayerIndex, "[系统]超出档次范围。当前项目BP单项最低为13点，最高为55点。")
			return;
		end
		if arr_rank11 <= 55 and arr_rank11 >= 13 then
			Left_BP2 = tMax_BP - arr_rank11;
			NLG.SystemMessage(_PlayerIndex, "[系统]档次分配:体力"..arr_rank11.."。")
		else
			NLG.SystemMessage(_PlayerIndex, "[系统]档次点数不足，无法成功分配。")
		end
	end
	if(tonumber(_Seqno)==16 and tonumber(_Select)==%按钮_确定% and _Data~="")then
		arr_rank21 = tonumber("".._Data.."")
		if arr_rank21 <= 12 or arr_rank21 >= 56 then
			NLG.SystemMessage(_PlayerIndex, "[系统]超出档次范围。当前项目BP单项最低为13点，最高为55点。")
			return;
		end
		if arr_rank21 <= 55 and arr_rank21 >= 13 then
			Left_BP3 = Left_BP2 - arr_rank21;
			NLG.SystemMessage(_PlayerIndex, "[系统]档次分配:体力"..arr_rank11..",力量"..arr_rank21.."。")
		else
			NLG.SystemMessage(_PlayerIndex, "[系统]档次点数不足，无法成功分配。")
		end
	end
	if(tonumber(_Seqno)==17 and tonumber(_Select)==%按钮_确定% and _Data~="")then
		arr_rank31 = tonumber("".._Data.."")
		if arr_rank31 <= 12 or arr_rank31 >= 56 then
			NLG.SystemMessage(_PlayerIndex, "[系统]超出档次范围。当前项目BP单项最低为13点，最高为55点。")
			return;
		end
		if arr_rank31 <= 55 and arr_rank31 >= 13 then
			Left_BP4 = Left_BP3 - arr_rank31;
			NLG.SystemMessage(_PlayerIndex, "[系统]档次分配:体力"..arr_rank11..",力量"..arr_rank21..",强度"..arr_rank31.."。")
		else
			NLG.SystemMessage(_PlayerIndex, "[系统]档次点数不足，无法成功分配。")
		end
	end
	if(tonumber(_Seqno)==18 and tonumber(_Select)==%按钮_确定% and _Data~="")then
		arr_rank41 = tonumber("".._Data.."")
		if arr_rank41 <= 12 or arr_rank41 >= 56 then
			NLG.SystemMessage(_PlayerIndex, "[系统]超出档次范围。当前项目BP单项最低为13点，最高为55点。")
			return;
		end
		if arr_rank41 <= 55 and arr_rank41 >= 13 then
			Left_BP5 = Left_BP4 - arr_rank41;
			NLG.SystemMessage(_PlayerIndex, "[系统]档次分配:体力"..arr_rank11..",力量"..arr_rank21..",强度"..arr_rank31..",速度"..arr_rank41.."。")
		else
			NLG.SystemMessage(_PlayerIndex, "[系统]档次点数不足，无法成功分配。")
		end
	end
	if(tonumber(_Seqno)==19 and tonumber(_Select)==%按钮_确定% and _Data~="")then
		arr_rank51 = tonumber("".._Data.."")
		if arr_rank51 <= 12 or arr_rank51 >= 56 then
			NLG.SystemMessage(_PlayerIndex, "[系统]超出档次范围。当前项目BP单项最低为13点，最高为55点。")
			return;
		end
		if arr_rank51 <= 55 and arr_rank51 >= 13 then
			NLG.SystemMessage(_PlayerIndex, "[系统]档次分配:体力"..arr_rank11..",力量"..arr_rank21..",强度"..arr_rank31..",速度"..arr_rank41..",魔法"..arr_rank51.."。")
		else
			NLG.SystemMessage(_PlayerIndex, "[系统]档次点数不足，无法成功分配。")
		end
	end
	if _Seqno==11 then
		local PlayerSelect1 = tonumber(_Data)
		if PlayerSelect1==1 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%按钮_确定%,20,"\n修正项目共"..tMax_CI.."点：\n\n必杀单项最低0点，必杀单项最高30点\n\n请输入必杀！",_MeIndex);
			return;
		end
		if PlayerSelect1==2 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%按钮_确定%,21,"\n修正项目剩下"..Left_CI2.."点：\n\n反击单项最低0点，反击单项最高30点\n\n请输入反击！",_MeIndex);
			return;
		end
		if PlayerSelect1==3 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%按钮_确定%,22,"\n修正项目剩下"..Left_CI3.."点：\n\n命中单项最低0点，命中单项最高30点\n\n请输入命中！",_MeIndex);
			return;
		end
		if PlayerSelect1==4 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%按钮_确定%,23,"\n修正项目剩下"..Left_CI4.."点：\n\n闪躲单项最低0点，闪躲单项最高30点\n\n请输入闪躲！",_MeIndex);
			return;
		end
	end
	if(tonumber(_Seqno)==20 and tonumber(_Select)==%按钮_确定% and _Data~="")then
		critical = tonumber("".._Data.."")
		if critical < 0 or critical >= 31 then
			NLG.SystemMessage(_PlayerIndex, "[系统]超出修正范围。当前项目单项最低为0点，最高为30点。")
			return;
		end
		if critical <= 30 and critical >= 0 then
			Left_CI2 = tMax_CI - critical;
			NLG.SystemMessage(_PlayerIndex, "[系统]修正分配:必杀"..critical.."。")
		else
			NLG.SystemMessage(_PlayerIndex, "[系统]修正点数不足，无法成功分配。")
		end
	end
	if(tonumber(_Seqno)==21 and tonumber(_Select)==%按钮_确定% and _Data~="")then
		counter = tonumber("".._Data.."")
		if counter < 0 or counter >= 31 then
			NLG.SystemMessage(_PlayerIndex, "[系统]超出修正范围。当前项目单项最低为0点，最高为30点。")
			return;
		end
		if counter <= 30 and counter >= 0 then
			Left_CI3 = Left_CI2 - counter;
			NLG.SystemMessage(_PlayerIndex, "[系统]修正分配:必杀"..critical..",反击"..counter.."。")
		else
			NLG.SystemMessage(_PlayerIndex, "[系统]修正点数不足，无法成功分配。")
		end
	end
	if(tonumber(_Seqno)==22 and tonumber(_Select)==%按钮_确定% and _Data~="")then
		hitrate = tonumber("".._Data.."")
		if hitrate < 0 or hitrate >= 31 then
			NLG.SystemMessage(_PlayerIndex, "[系统]超出修正范围。当前项目单项最低为0点，最高为30点。")
			return;
		end
		if hitrate <= 30 and hitrate >= 0 then
			Left_CI4 = Left_CI3 - hitrate;
			NLG.SystemMessage(_PlayerIndex, "[系统]修正分配:必杀"..critical..",反击"..counter..",命中"..hitrate.."。")
		else
			NLG.SystemMessage(_PlayerIndex, "[系统]修正点数不足，无法成功分配。")
		end
	end
	if(tonumber(_Seqno)==23 and tonumber(_Select)==%按钮_确定% and _Data~="")then
		avoid = tonumber("".._Data.."")
		if avoid < 0 or avoid >= 31 then
			NLG.SystemMessage(_PlayerIndex, "[系统]超出修正范围。当前项目单项最低为0点，最高为30点。")
			return;
		end
		CI = critical + counter + hitrate + avoid;
		if CI < tMax_CI or CI > tMax_CI then
			NLG.SystemMessage(_PlayerIndex, "[系统]修正点数不足，无法成功分配。")
			return;
		end
		if (avoid <= 30 and avoid >= 0 ) then
			NLG.SystemMessage(_PlayerIndex, "[系统]修正分配:必杀"..critical..",反击"..counter..",命中"..hitrate..",闪躲"..avoid.."。")
		else
			--NLG.SystemMessage(_PlayerIndex, "[系统]无法自定义的宠物。")
		end
	end
	if _Seqno==12 then
		local PlayerSelect1 = tonumber(_Data)
		if PlayerSelect1==1 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%按钮_确定%,24,"\n属性项目共"..tMax_AB.."点：\n\n地属性单项最低0点，地属性单项最高10点\n\n请输入地属性！",_MeIndex);
			return;
		end
		if PlayerSelect1==2 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%按钮_确定%,25,"\n属性项目剩下"..Left_AB2.."点：\n\n水属性单项最低0点，水属性单项最高10点\n\n请输入水属性！",_MeIndex);
			return;
		end
		if PlayerSelect1==3 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%按钮_确定%,26,"\n属性项目剩下"..Left_AB3.."点：\n\n火属性单项最低0点，火属性单项最高10点\n\n请输入火属性！",_MeIndex);
			return;
		end
		if PlayerSelect1==4 then
			Shor_ShowGAWindowTalk(_PlayerIndex,1,%按钮_确定%,27,"\n属性项目剩下"..Left_AB4.."点：\n\n风属性单项最低0点，风属性单项最高10点\n\n请输入风属性！",_MeIndex);
			return;
		end
	end
	if(tonumber(_Seqno)==24 and tonumber(_Select)==%按钮_确定% and _Data~="")then
		ground = tonumber("".._Data.."")
		if ground < 0 or ground >= 11 then
			NLG.SystemMessage(_PlayerIndex, "[系统]超出属性范围。当前项目单项最低为0点，最高为10点。")
			return;
		end
		if ground <= 10 and ground >= 0 then
			Left_AB2 = tMax_AB - ground;
			NLG.SystemMessage(_PlayerIndex, "[系统]属性分配:地属性"..ground.."。")
		else
			NLG.SystemMessage(_PlayerIndex, "[系统]属性点数不足，无法成功分配。")
		end
	end
	if(tonumber(_Seqno)==25 and tonumber(_Select)==%按钮_确定% and _Data~="")then
		water = tonumber("".._Data.."")
		if water < 0 or water >= 11 then
			NLG.SystemMessage(_PlayerIndex, "[系统]超出属性范围。当前项目单项最低为0点，最高为10点。")
			return;
		end
		if water <= 10 and water >= 0 then
			Left_AB3 = Left_AB2 - water;
			NLG.SystemMessage(_PlayerIndex, "[系统]属性分配:地属性"..ground..",水属性"..water.."。")
		else
			NLG.SystemMessage(_PlayerIndex, "[系统]属性点数不足，无法成功分配。")
		end
	end
	if(tonumber(_Seqno)==26 and tonumber(_Select)==%按钮_确定% and _Data~="")then
		fire = tonumber("".._Data.."")
		if fire < 0 or fire >= 11 then
			NLG.SystemMessage(_PlayerIndex, "[系统]超出属性范围。当前项目单项最低为0点，最高为10点。")
			return;
		end
		if fire <= 10 and fire >= 0 then
			Left_AB4 = Left_AB3 - fire;
			NLG.SystemMessage(_PlayerIndex, "[系统]属性分配:地属性"..ground..",水属性"..water..",火属性"..fire.."。")
		else
			NLG.SystemMessage(_PlayerIndex, "[系统]属性点数不足，无法成功分配。")
		end
	end
	if(tonumber(_Seqno)==27 and tonumber(_Select)==%按钮_确定% and _Data~="")then
		wind = tonumber("".._Data.."")
		if wind < 0 or wind >= 11 then
			NLG.SystemMessage(_PlayerIndex, "[系统]超出属性范围。当前项目单项最低为0点，最高为10点。")
			return;
		end
		AB = ground + water + fire + wind;
		if AB < tMax_AB or AB > tMax_AB then
			NLG.SystemMessage(_PlayerIndex, "[系统]属性点数不足，无法成功分配。")
			return;
		end
		if (wind <= 10 and wind >= 0) then
			NLG.SystemMessage(_PlayerIndex, "[系统]属性分配:地属性"..ground..",水属性"..water..",火属性"..fire..",风属性"..wind.."。")
		else
			--NLG.SystemMessage(_PlayerIndex, "[系统]无法自定义的宠物。")
		end
	end
	if(tonumber(_Seqno)==13 and tonumber(_Select)==%按钮_确定% and _Data~="")then
		PetTD1 = tonumber("".._Data.."")
		if tJudgment == 0 then
			NLG.SystemMessage(_PlayerIndex, "[系统]造型形象编号登录完成:"..PetTD1.."。")
		elseif tJudgment == 1 and PET_CheckInTable(tPetID,PetTD1)==true then
			NLG.SystemMessage(_PlayerIndex, "[系统]造型形象编号登录完成:"..PetTD1.."。")
		else
			NLG.SystemMessage(_PlayerIndex, "[系统]造型形象编号，请参照官方公告连结。")
			return;
		end
	end
	if(tonumber(_Seqno)==14 and tonumber(_Select)==%按钮_确定% and _Data~="") then
		local name = _Data;
		BP = arr_rank11 + arr_rank21 + arr_rank31 + arr_rank41 + arr_rank51;
		if BP < tMax_BP or BP > tMax_BP then
			NLG.SystemMessage(_PlayerIndex, "[系统]请确认档次点数输入正确。")
			return;
		end
		if (BP == tMax_BP and CI == tMax_CI and AB == tMax_AB) then
			Char.AddPet(_PlayerIndex,tEnemyID);
		else
			NLG.SystemMessage(_PlayerIndex, "[系统]请确认前几项点数输入正确。")
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
				NLG.SystemMessage(_PlayerIndex, "[系统]自定义宠物已完美结束。")
			end
		end
	end
end
