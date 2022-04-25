local EnemyID = {500000,500001,500002,500003,500004,500005,500006,500007,500008,500009};
local Maternal = {arr_rank11,arr_rank12,arr_rank13,arr_rank14,arr_rank15,m6,m7,m8,m9,name,image,tribe};
local Vice = {arr_rank12,arr_rank22,arr_rank23,arr_rank24,arr_rank25,v6,v7,v8,v9};
local ETime = 0;
local E_status = 0;
local mapid = 1000;		--宠物配种地图编号
--
----------------------------------------------------------------------------------------

NL.RegPetFieldEvent(nil,"MyPetPetBreeding");

function MyPetPetBreeding(_PlayerIndex,_PetIndex,PetPos)
	_PetIndex = Char.GetPet(_PlayerIndex,PetPos);
	pItemIndex = Char.GetItemIndex(_PlayerIndex, Char.FindItemId(_PlayerIndex,70188));
	pItemID = Item.GetData(pItemIndex, 0);
	if (VaildChar(pItemIndex) == true and pItemID==70188) then
		satiety = Item.GetData(pItemIndex,%道具_子参一%);
		intimacy = Item.GetData(pItemIndex,%道具_子参二%);
	end
	if (Char.ItemNum(_PlayerIndex,70187) == 0) then
		E_status = 0;
	end
	name = Char.GetData(_PetIndex,%对象_名字%);
	if (intimacy==100 and E_status==0 and Char.GetData(_PlayerIndex,%对象_地图%) ~= mapid) then
		NLG.SystemMessage(_PlayerIndex,"[系统] 请前往宠物配种专属场地！");
		return 0;
	end
	if (intimacy==100 and E_status==0 and Char.GetData(_PetIndex,%对象_名色%)==6) then
		NLG.SystemMessage(_PlayerIndex,"[系统] 红色名字的宠物无法进行配种！");
		return 0;
	end
	if (intimacy==100 and E_status==0) then
		local name = Char.GetData(_PetIndex,%对象_名字%);
		Maternal[10] = name;
		Maternal[11] = Char.GetData(_PetIndex,%对象_形象%);
		Maternal[12] = Char.GetData(_PetIndex,%对象_种族%);
		Maternal[1] = Pet.FullArtRank(_PetIndex,%宠档_体成%);
		Maternal[2] = Pet.FullArtRank(_PetIndex,%宠档_力成%);
		Maternal[3] = Pet.FullArtRank(_PetIndex,%宠档_强成%);
		Maternal[4] = Pet.FullArtRank(_PetIndex,%宠档_敏成%);
		Maternal[5] = Pet.FullArtRank(_PetIndex,%宠档_魔成%);
		Maternal[6] = Char.GetData(_PetIndex,%对象_地属性%);
		Maternal[7] = Char.GetData(_PetIndex,%对象_水属性%);
		Maternal[8] = Char.GetData(_PetIndex,%对象_火属性%);
		Maternal[9] = Char.GetData(_PetIndex,%对象_风属性%);
		PetBreedingNpc_Talked( PetBreedingNpc, _PlayerIndex, _Mode);
	end
	if (Char.ItemNum(_PlayerIndex,70187) > 0) then
		E_status = 2;
	end
	if (intimacy==100 and E_status==2 and Char.GetData(_PlayerIndex,%对象_地图%) ~= mapid) then
		NLG.SystemMessage(_PlayerIndex,"[系统] 请前往宠物配种专属场地！");
		return 0;
	end
	if (intimacy==100 and E_status==2 and Char.GetData(_PetIndex,%对象_名色%)==6) then
		NLG.SystemMessage(_PlayerIndex,"[系统] 红色名字的宠物无法进行配种！");
		return 0;
	end
	if (intimacy==100 and E_status==2) then
		Vice[1] = Pet.FullArtRank(_PetIndex,%宠档_体成%);
		Vice[2] = Pet.FullArtRank(_PetIndex,%宠档_力成%);
		Vice[3] = Pet.FullArtRank(_PetIndex,%宠档_强成%);
		Vice[4] = Pet.FullArtRank(_PetIndex,%宠档_敏成%);
		Vice[5] = Pet.FullArtRank(_PetIndex,%宠档_魔成%);
		Vice[6] = Char.GetData(_PetIndex,%对象_地属性%);
		Vice[7] = Char.GetData(_PetIndex,%对象_水属性%);
		Vice[8] = Char.GetData(_PetIndex,%对象_火属性%);
		Vice[9] = Char.GetData(_PetIndex,%对象_风属性%);
		PetBreedingNpc_Talked( PetBreedingNpc, _PlayerIndex, _Mode);
	end
	return 0;
end

Delegate.RegInit("PetBreedingNpc_Init");

function PetBreedingNpc_Init()
	PetBreedingNpc = NL.CreateNpc(nil, "Myinit");
	Char.SetData(PetBreedingNpc,%对象_形象%,14682);
	Char.SetData(PetBreedingNpc,%对象_原形%,14682);
	Char.SetData(PetBreedingNpc,%对象_X%,36);
	Char.SetData(PetBreedingNpc,%对象_Y%,33);
	Char.SetData(PetBreedingNpc,%对象_地图%,777);
	Char.SetData(PetBreedingNpc,%对象_方向%,0);
	Char.SetData(PetBreedingNpc,%对象_名字%,"宠物蛋配种");
	NLG.UpChar(PetBreedingNpc);
	Char.SetTalkedEvent(nil, "PetBreedingNpc_Talked", PetBreedingNpc);
	Char.SetWindowTalkedEvent(nil, "PetBreedingNpc_WindowTalked", PetBreedingNpc);
	return true;
end

function Myinit(_MeIndex)
	return true;
end

function PetBreedingNpc_Talked( _NpcIndex, _PlayerIndex, _Mode)
	if (Char.PetNum(_PlayerIndex) >= 5) then
		NLG.SystemMessage(_PlayerIndex, "[系统] 宠物栏位置不够。")
		return;
	end
	local WindowMsg =	"\\n                ◆宠物蛋配种◆" ..
				"\\n选择两只宠物展示，并准备一万元配种" ..
				"\\n选择的第一只视为母体" ..
				"\\n宝宝名字、形象同母体" ..
				"\\n " ..
				"\\n档次以两体的最大值之间随机" ..
				"\\n属性以两体的平均值决定" ..
				"\\n "..
				"\\n选择    "..name.."" 
	NLG.ShowWindowTalked(_PlayerIndex, _NpcIndex,%窗口_信息框%,%按钮_是否%,2,WindowMsg);
	return ;
end


function PetBreedingNpc_WindowTalked( _NpcIndex, _PlayerIndex, _Seqno, _Select, _Data)
	local Gold = Char.GetData(_PlayerIndex, %对象_金币%);
	local nowTime = os.time();
	if (_Seqno==2) then
		--取消按钮
		if (_Select==8) then
			return
		end
		if (_Select==4 and E_status==0 and Gold >= 10000) then
			E_status = 1;
			ETime = os.time();
			Char.GiveItem(_PlayerIndex,70187,1);
			Char.AddGold(_PlayerIndex,-10000);
			eItemIndex = Char.GetItemIndex(_PlayerIndex, Char.FindItemId(_PlayerIndex,70187));
			local egg_name = Item.GetData(eItemIndex,%道具_名字%);
			local Newname = "[" .. name .. "]" .. egg_name;
			Item.SetData(eItemIndex,%道具_名字%,Newname);
			Item.UpItem(_PlayerIndex,Char.FindItemId(_PlayerIndex,70187));
			NLG.SystemMessage(_PlayerIndex,"[系统] 母体选择完成！");
		end
		if (_Select==4 and E_status==0 and Gold < 10000) then
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_信息框%,%按钮_关闭%,1,"\\n\\n\\n请确认金钱足够一万！");
		end
		if (_Select==4 and E_status==2) then
			E_status = 3;
			NLG.SystemMessage(_PlayerIndex,"[系统] 副体选择完成！");
		end
	end
	if (_Seqno==1) then
		if (_Select==8) then
			return
		end
		if (_Select==4 and E_status==3 and nowTime - ETime <60) then
			NLG.SystemMessage(_PlayerIndex,"[系统] 请等待配种宠物蛋孵化！");
		end
		if (_Select==4 and E_status == 3 and nowTime - ETime >=60) then
			local enemyid = Maternal[12] + 1;
			Char.AddPet(_PlayerIndex,EnemyID[enemyid]);
			for Slot=0,4 do
				local E_PetIndex = Char.GetPet(_PlayerIndex,Slot);
				local E_image = Char.GetData(E_PetIndex,%对象_形象%);
				if (E_image == 100902) then
				Pet.SetArtRank(E_PetIndex,%宠档_体成%, math.random(Maternal[1],Vice[1]));
				Pet.SetArtRank(E_PetIndex,%宠档_力成%, math.random(Maternal[2],Vice[2]));
				Pet.SetArtRank(E_PetIndex,%宠档_强成%, math.random(Maternal[3],Vice[3]));
				Pet.SetArtRank(E_PetIndex,%宠档_敏成%, math.random(Maternal[4],Vice[4]));
				Pet.SetArtRank(E_PetIndex,%宠档_魔成%, math.random(Maternal[5],Vice[5]));
				Pet.ReBirth(_PlayerIndex, E_PetIndex);
				Char.SetData(E_PetIndex,%对象_地属性%,(Maternal[6]+Vice[6])/2);
				Char.SetData(E_PetIndex,%对象_水属性%,(Maternal[7]+Vice[7])/2);
				Char.SetData(E_PetIndex,%对象_火属性%,(Maternal[8]+Vice[8])/2);
				Char.SetData(E_PetIndex,%对象_风属性%,(Maternal[9]+Vice[9])/2);
				Char.SetData(E_PetIndex,%对象_形象%,Maternal[11]);
				Char.SetData(E_PetIndex,%对象_原形%,Maternal[11]);
				Char.SetData(E_PetIndex,%对象_名字%,Maternal[10]);
				Char.SetData(E_PetIndex,%对象_名色%,6);  --宠物蛋配种为红色名字
				Pet.UpPet(_PlayerIndex,E_PetIndex);
				Char.DelItem(_PlayerIndex,70187,1);
				NLG.SystemMessage(_PlayerIndex, "[系统] 宠物蛋配种已完美结束。")
				end
			end
		end
	end
end

NL.RegItemString("lua/Module/PetBreeding.lua","PetEgg","LUA_usePetEgg");
function PetEgg(_PlayerIndex,_toIndex,_itemslot) --双击道具执行函数
	if (Char.PetNum(_PlayerIndex) >= 5) then
		NLG.SystemMessage(_PlayerIndex, "[系统] 宠物栏位置不够。")
		return;
	end
	local TalkMsg =	"\\n             ◆宠物蛋配种孵蛋器◆" ..
			"\\n " ..
			"\\n               请维持在上线状态" ..
			"\\n               请勿再次进行配种" ..
			"\\n               配种完毕后须等待" ..
			"\\n                 六十秒后孵化" ..
			"\\n " ..
			"\\n "..
			"\\n " 
	NLG.ShowWindowTalked(_PlayerIndex, PetBreedingNpc,%窗口_信息框%,%按钮_是否%, 1, TalkMsg);
	return 1;
end
