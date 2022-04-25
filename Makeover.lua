local dressing_makeover_user = {};                  --Player名单
local dressing_makeover_user_list = {};             --形象表单
dressing_makeover_user_list[1] = {};
dressing_makeover_user_list[1].BImage = {};
dressing_makeover_user_list[1].BBImage = {};
dressing_makeover_user_list[1].OImage = {};

dressing_makeover_user_list[2] = {};
dressing_makeover_user_list[2].BImage = {};
dressing_makeover_user_list[2].BBImage = {};
dressing_makeover_user_list[2].OImage = {};

dressing_makeover_user_list[3] = {};
dressing_makeover_user_list[3].BImage = {};
dressing_makeover_user_list[3].BBImage = {};
dressing_makeover_user_list[3].OImage = {};

dressing_makeover_user_list[4] = {};
dressing_makeover_user_list[4].BImage = {};
dressing_makeover_user_list[4].BBImage = {};
dressing_makeover_user_list[4].OImage = {};

dressing_makeover_user_list[5] = {};
dressing_makeover_user_list[5].BImage = {};
dressing_makeover_user_list[5].BBImage = {};
dressing_makeover_user_list[5].OImage = {};
------------------------------------------------------------------------------

Delegate.RegInit("Makeover_Init");

function initMakeoverNpc_Init(index)
	print("变装侦探npc_index = " .. index);
	return 1;
end

function Makeover_create() 
	if (dressingNPC == nil) then
		dressingNPC = NL.CreateNpc("lua/Module/Makeover.lua", "initMakeoverNpc_Init");
		Char.SetData(dressingNPC,%对象_形象%,117124);
		Char.SetData(dressingNPC,%对象_原形%,117124);
		Char.SetData(dressingNPC,%对象_X%,233);
		Char.SetData(dressingNPC,%对象_Y%,89);
		Char.SetData(dressingNPC,%对象_地图%,1000);
		Char.SetData(dressingNPC,%对象_方向%,6);
		Char.SetData(dressingNPC,%对象_名字%,"变装侦探");
		NLG.UpChar(dressingNPC);
		Char.SetTalkedEvent("lua/Module/Makeover.lua", "DressingWindow", dressingNPC);
		Char.SetWindowTalkedEvent("lua/Module/Makeover.lua", "DressingFunction", dressingNPC);
	end
end

NL.RegItemString("lua/Module/Makeover.lua","Makeover","LUA_useMakeUp");
function Makeover(_PlayerIndex,_toIndex,_itemslot) --双击道具执行函数
	if (NLG.CanTalk(dressingNPC,_PlayerIndex) == false) then
		local _obj = dressing_makeover_user[Playerkey(_PlayerIndex)];
		if (_obj == nil) then 
			dressing_makeover_user[Playerkey(_PlayerIndex)] = Char.GetData(_PlayerIndex,%对象_账号%);
			for i=2,5 do
				dressing_makeover_user_list[i][Playerkey(_PlayerIndex)] = nil;
			end
		end
		DressingWindowMsg = "4|\\n      ★★★★储存形象或进行变装★★★★"..
				"\\n　　　　　　※持变身卡选择已存形象将覆盖"..
				"\\n　　　　　形象编号　　　　　　　　　　　　　"..
				"\\n　　════════════════════"..
				"\\n　　　　『原始形象(已绑定)』\\n";
		for i=2,5 do
			local makeover = dressing_makeover_user_list[i][Playerkey(_PlayerIndex)];
			if(makeover == nil)then
				DressingWindowMsg = DressingWindowMsg .. "　　　　『形象(空)』\\n";
			else
				DressingWindowMsg = DressingWindowMsg .. "　　　　『形象("..dressing_makeover_user_list[i].BImage..")』\\n";
			end
		end
		NLG.ShowWindowTalked(_PlayerIndex,dressingNPC,%窗口_选择框%,%按钮_关闭%,1,DressingWindowMsg);
	end
	return;
end

function DressingWindow(_NpcIndex,_PlayerIndex)
	if (NLG.CanTalk(_NpcIndex,_PlayerIndex) == true) then
		local _obj = dressing_makeover_user[Playerkey(_PlayerIndex)];
		if (_obj == nil) then 
			dressing_makeover_user[Playerkey(_PlayerIndex)] = Char.GetData(_PlayerIndex,%对象_账号%);
			for i=2,5 do
				dressing_makeover_user_list[i][Playerkey(_PlayerIndex)] = nil;
			end
		end
		DressingWindowMsg = "4|\\n      ★★★★储存形象或进行变装★★★★"..
				"\\n　　　　　　※持变身卡选择已存形象将覆盖"..
				"\\n　　　　　形象编号　　　　　　　　　　　　　"..
				"\\n　　════════════════════"..
				"\\n　　　　『原始形象(已绑定)』\\n";
		for i=2,5 do
			local makeover = dressing_makeover_user_list[i][Playerkey(_PlayerIndex)];
			if(makeover == nil)then
				DressingWindowMsg = DressingWindowMsg .. "　　　　『形象(空)』\\n";
			else
				DressingWindowMsg = DressingWindowMsg .. "　　　　『形象("..dressing_makeover_user_list[i].BImage..")』\\n";
			end
		end
		NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%窗口_选择框%,%按钮_关闭%,1,DressingWindowMsg);
	end
	return;
end

function DressingFunction(_NpcIndex,_PlayerIndex,_SqeNo,_select,_data)
	if ((_select == 0 or _select == "0") and (_data ~= "")) then
		local selectitem = tonumber(_data);
		local makeover = dressing_makeover_user_list[selectitem][Playerkey(_PlayerIndex)];
		local dressing_BImage = tonumber(Char.GetData(_PlayerIndex,%对象_形象%));
		local dressing_BBImage = tonumber(Char.GetData(_PlayerIndex,%对象_原形%));
		local dressing_OImage = tonumber(Char.GetData(_PlayerIndex,%对象_原始图档%));

		local item_D = Char.GetItemIndex(_PlayerIndex,Char.FindItemId(_PlayerIndex,69991));
		local image_key = Item.GetData(item_D,%道具_子参一%);
		if (selectitem == 1 and dressing_OImage ~= dressing_BImage) then
			dressing_makeover_user_list[1][Playerkey(_PlayerIndex)] = true;
			dressing_makeover_user_list[1].BImage = dressing_OImage;
			dressing_makeover_user_list[1].BBImage = dressing_OImage;
			dressing_makeover_user_list[1].OImage = dressing_OImage;
			Char.SetData(_PlayerIndex,%对象_形象%,dressing_OImage);
			Char.SetData(_PlayerIndex,%对象_原形%,dressing_OImage);
			Char.SetData(_PlayerIndex,%对象_原始图档%,dressing_OImage);
			NLG.UpChar(_PlayerIndex);
			NLG.SystemMessage(_PlayerIndex,"形象编号变装成功。");
		end
		if (makeover == nil and selectitem ~= 1) then
			local item = Char.GetItemIndex(_PlayerIndex,Char.FindItemId(_PlayerIndex,69990));
			local Special = Item.GetData(item,%道具_特殊类型%);
			local Para1 = Item.GetData(item,%道具_子参一%);
			local Para2 = Item.GetData(item,%道具_子参二%);
			if (Special == 14 and Para1 == 1 and Para2 ~= 0 and Char.ItemNum(_PlayerIndex,69990) >= 1) then
				local _zc2 = tonumber(Item.GetData(item,%道具_子参二%));
				dressing_makeover_user_list[selectitem][Playerkey(_PlayerIndex)] = true;
				dressing_makeover_user_list[selectitem].BImage = _zc2;
				dressing_makeover_user_list[selectitem].BBImage = _zc2;
				dressing_makeover_user_list[selectitem].OImage = dressing_OImage;
				Char.SetData(_PlayerIndex,%对象_形象%,_zc2);
				Char.SetData(_PlayerIndex,%对象_原形%,_zc2);
				NLG.UpChar(_PlayerIndex);

				Item.SetData(item_D,%道具_子参一%,_zc2);
				Item.UpItem(_PlayerIndex,Char.FindItemId(_PlayerIndex,69991));
				Char.DelItem(_PlayerIndex,69990,1);
				NLG.SystemMessage(_PlayerIndex,"形象编号变装成功。");
			else
				NLG.SystemMessage(_PlayerIndex,"请先去欢乐转盘取得形象编号。");
				return;
			end
		end
		if (makeover ~= nil and selectitem ~= 1 and Char.ItemNum(_PlayerIndex,69990) == 0) then
			Char.SetData(_PlayerIndex,%对象_形象%,dressing_makeover_user_list[selectitem].BImage);
			Char.SetData(_PlayerIndex,%对象_原形%,dressing_makeover_user_list[selectitem].BBImage);
			NLG.UpChar(_PlayerIndex);

			NLG.SystemMessage(_PlayerIndex,"形象编号变装成功。");
		end
		if (makeover ~= nil and selectitem ~= 1 and Char.ItemNum(_PlayerIndex,69990) > 0) then
			local item = Char.GetItemIndex(_PlayerIndex,Char.FindItemId(_PlayerIndex,69990));
			local Special = Item.GetData(item,%道具_特殊类型%);
			local Para1 = Item.GetData(item,%道具_子参一%);
			local Para2 = Item.GetData(item,%道具_子参二%);
			if (Special == 14 and Para1 == 1 and Para2 ~= 0) then
				local item = Char.GetItemIndex(_PlayerIndex,Char.FindItemId(_PlayerIndex,69990));
				local _zc2 = tonumber(Item.GetData(item,%道具_子参二%));
				dressing_makeover_user_list[selectitem][Playerkey(_PlayerIndex)] = true;
				dressing_makeover_user_list[selectitem].BImage = _zc2;
				dressing_makeover_user_list[selectitem].BBImage = _zc2;
				dressing_makeover_user_list[selectitem].OImage = dressing_OImage;
				Char.SetData(_PlayerIndex,%对象_形象%,_zc2);
				Char.SetData(_PlayerIndex,%对象_原形%,_zc2);
				NLG.UpChar(_PlayerIndex);

				Item.SetData(item_D,%道具_子参一%,_zc2);
				Item.UpItem(_PlayerIndex,Char.FindItemId(_PlayerIndex,69991));
				Char.DelItem(_PlayerIndex,69990,1);
				NLG.SystemMessage(_PlayerIndex,"形象编号变装成功。");
			end
		end
	end
end

function Makeover_Init()
	Makeover_create();
	return 0;
end
