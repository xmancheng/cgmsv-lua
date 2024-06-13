local EnemySet = {}
local BaseLevelSet = {}
local Pos = {}
local STime = os.time()
local YS = 30 --脚本延时多少秒创建NPC
local SXTime = 60 --NPC刷新时间·秒
local PlantStep = 0
--队列解释
--     五	三	一	二	四
--     十	八	六	七	九
------------随机BOSS设置------------
EnemySet[1] = {100087, 102320, 102320, 0, 0, 0, 0, 0, 102321, 102321}--0代表没有怪
BaseLevelSet[1] = {50, 30, 30, 0, 0, 0, 0, 0, 30, 30}
------------------------------------------------
Pos[1] = {{"櫻子果",500178,25011,9,5,0,EnemySet[1],1,BaseLevelSet[1]}}
Pos[2] = {{"蘋野果",500179,25011,9,6,0,EnemySet[1],2,BaseLevelSet[1]}}
Pos[3] = {{"榴石果",500180,25011,9,7,0,EnemySet[1],3,BaseLevelSet[1]}}
Pos[4] = {{"枝荔果",500198,25011,21,12,0,EnemySet[1],4,BaseLevelSet[1]}}
Pos[5] = {{"利木果",500194,25011,15,5,0,EnemySet[1],5,BaseLevelSet[1]}}
Pos[6] = {{"文柚果",500195,25011,15,6,0,EnemySet[1],6,BaseLevelSet[1]}}
Pos[7] = {{"凰梨果",500196,25011,15,7,0,EnemySet[1],7,BaseLevelSet[1]}}
Pos[8] = {{"蔓莓果",500197,25011,5,1,0,EnemySet[1],8,BaseLevelSet[1]}}
Pos[9] = {{"異奇果",500184,25011,21,5,0,EnemySet[1],9,BaseLevelSet[1]}}
Pos[10] = {{"墨莓果",500185,25011,21,6,0,EnemySet[1],10,BaseLevelSet[1]}}
Pos[11] = {{"椰木果",500186,25011,21,7,0,EnemySet[1],11,BaseLevelSet[1]}}
Pos[12] = {{"哈密果",500193,25011,21,14,0,EnemySet[1],12,BaseLevelSet[1]}}
Pos[13] = {{"橙橙果",500181,25011,9,12,0,EnemySet[1],13,BaseLevelSet[1]}}
Pos[14] = {{"番荔果",500182,25011,9,13,0,EnemySet[1],14,BaseLevelSet[1]}}
Pos[15] = {{"霧蓮果",500183,25011,9,14,0,EnemySet[1],15,BaseLevelSet[1]}}
Pos[16] = {{"莓莓果",500191,25011,21,13,0,EnemySet[1],16,BaseLevelSet[1]}}
Pos[17] = {{"芒芒果",500188,25011,15,12,0,EnemySet[1],17,BaseLevelSet[1]}}
Pos[18] = {{"蕉香果",500189,25011,5,0,0,EnemySet[1],18,BaseLevelSet[1]}}
Pos[19] = {{"岳竹果",500190,25011,15,13,0,EnemySet[1],19,BaseLevelSet[1]}}
Pos[20] = {{"比巴果",500199,25011,15,14,0,EnemySet[1],20,BaseLevelSet[1]}}

tbl_PlantberryNpcIndex = tbl_PlantberryNpcIndex or {}
------------------------------------------------
local petBerryTable = {
      --加体力树果
      { itemID = 69011, value_plus = CONST.CHAR_体力, val_plus = 1000, value_minus = CONST.CHAR_力量, val_minus = 1000, name="櫻子果", imageID=500178},
      { itemID = 69012, value_plus = CONST.CHAR_体力, val_plus = 1000, value_minus = CONST.CHAR_强度, val_minus = 1000, name="蘋野果", imageID=500179},
      { itemID = 69013, value_plus = CONST.CHAR_体力, val_plus = 1000, value_minus = CONST.CHAR_速度, val_minus = 1000, name="榴石果", imageID=500180},
      { itemID = 69014, value_plus = CONST.CHAR_体力, val_plus = 1000, value_minus = CONST.CHAR_魔法, val_minus = 1000, name="枝荔果", imageID=500198},
      --加力量树果
      { itemID = 69015, value_plus = CONST.CHAR_力量, val_plus = 1000, value_minus = CONST.CHAR_体力, val_minus = 1000, name="利木果", imageID=500194},
      { itemID = 69016, value_plus = CONST.CHAR_力量, val_plus = 1000, value_minus = CONST.CHAR_强度, val_minus = 1000, name="文柚果", imageID=500195},
      { itemID = 69017, value_plus = CONST.CHAR_力量, val_plus = 1000, value_minus = CONST.CHAR_速度, val_minus = 1000, name="凰梨果", imageID=500196},
      { itemID = 69018, value_plus = CONST.CHAR_力量, val_plus = 1000, value_minus = CONST.CHAR_魔法, val_minus = 1000, name="蔓莓果", imageID=500197},
      --加强度树果
      { itemID = 69019, value_plus = CONST.CHAR_强度, val_plus = 1000, value_minus = CONST.CHAR_体力, val_minus = 1000, name="異奇果", imageID=500184},
      { itemID = 69020, value_plus = CONST.CHAR_强度, val_plus = 1000, value_minus = CONST.CHAR_力量, val_minus = 1000, name="墨莓果", imageID=500185},
      { itemID = 69021, value_plus = CONST.CHAR_强度, val_plus = 1000, value_minus = CONST.CHAR_速度, val_minus = 1000, name="椰木果", imageID=500186},
      { itemID = 69022, value_plus = CONST.CHAR_强度, val_plus = 1000, value_minus = CONST.CHAR_魔法, val_minus = 1000, name="哈密果", imageID=500193},
      --加速度树果
      { itemID = 69023, value_plus = CONST.CHAR_速度, val_plus = 1000, value_minus = CONST.CHAR_体力, val_minus = 1000, name="橙橙果", imageID=500181},
      { itemID = 69024, value_plus = CONST.CHAR_速度, val_plus = 1000, value_minus = CONST.CHAR_力量, val_minus = 1000, name="番荔果", imageID=500182},
      { itemID = 69025, value_plus = CONST.CHAR_速度, val_plus = 1000, value_minus = CONST.CHAR_强度, val_minus = 1000, name="霧蓮果", imageID=500183},
      { itemID = 69026, value_plus = CONST.CHAR_速度, val_plus = 1000, value_minus = CONST.CHAR_魔法, val_minus = 1000, name="莓莓果", imageID=500191},
      --加魔法树果
      { itemID = 69027, value_plus = CONST.CHAR_魔法, val_plus = 1000, value_minus = CONST.CHAR_体力, val_minus = 1000, name="芒芒果", imageID=500188},
      { itemID = 69028, value_plus = CONST.CHAR_魔法, val_plus = 1000, value_minus = CONST.CHAR_力量, val_minus = 1000, name="蕉香果", imageID=500189},
      { itemID = 69029, value_plus = CONST.CHAR_魔法, val_plus = 1000, value_minus = CONST.CHAR_强度, val_minus = 1000, name="岳竹果", imageID=500190},
      { itemID = 69030, value_plus = CONST.CHAR_魔法, val_plus = 1000, value_minus = CONST.CHAR_速度, val_minus = 1000, name="比巴果", imageID=500199},
}

------------------------------------------------
Delegate.RegInit("PetBerry_Init");

function initPetBerryNpc_Init(index)
	print("宠物树果npc_index = " .. index);
	return 1;
end

function PetBerry_create() 
	if (berryNpc == nil) then
		berryNpc = NL.CreateNpc("lua/Module/PetBerry.lua", "initPetBerryNpc_Init");
		Char.SetData(berryNpc,%对象_形象%,231063);
		Char.SetData(berryNpc,%对象_原形%,231063);
		Char.SetData(berryNpc,%对象_X%,6);
		Char.SetData(berryNpc,%对象_Y%,1);
		Char.SetData(berryNpc,%对象_地图%,25011);
		Char.SetData(berryNpc,%对象_方向%,6);
		Char.SetData(berryNpc,%对象_名字%,"樹果名人");
		NLG.UpChar(berryNpc);
		Char.SetTalkedEvent("lua/Module/PetBerry.lua", "BerryWindow", berryNpc);
		Char.SetWindowTalkedEvent("lua/Module/PetBerry.lua", "BerryFunction", berryNpc);
	end
	if (PlantberryNpc == nil) then
		PlantberryNpc = NL.CreateNpc("lua/Module/PetBerry.lua", "initPetBerryNpc_Init");
		Char.SetData(PlantberryNpc,%对象_形象%,231116);
		Char.SetData(PlantberryNpc,%对象_原形%,231116);
		Char.SetData(PlantberryNpc,%对象_X%,19);
		Char.SetData(PlantberryNpc,%对象_Y%,19);
		Char.SetData(PlantberryNpc,%对象_地图%,777);
		Char.SetData(PlantberryNpc,%对象_方向%,6);
		Char.SetData(PlantberryNpc,%对象_原名%,"樹果植物設置");
		NLG.UpChar(PlantberryNpc);
		Char.SetLoopEvent(nil, "Plantberry_LoopEvent",PlantberryNpc, SXTime*1000)
		Char.SetWindowTalkedEvent("lua/Module/PetBerry.lua","PlantBerryWindow",PlantberryNpc);
		Char.SetTalkedEvent("lua/Module/PetBerry.lua","PlantBerryFunction", PlantberryNpc);
	end
end

NL.RegItemString("lua/Module/PetBerry.lua","BerryItem","LUA_useBerry");
function BerryItem(player,_toIndex,_itemslot) --双击道具执行函数
    if (NLG.CanTalk(berryNpc,player) == false) then
          local itemIndex = Char.GetItemIndex(player, _itemslot);
          ItemID = Item.GetData(itemIndex, CONST.道具_ID);
          local msg = "3|\\n你要選擇哪隻寵物餵食樹果？樹果可以改變寵物的BP素質，目前品種會增加10點但減少另一項10點！\\n\\n";
          for i=0,4 do
                local pet = Char.GetPet(player,i);
                if(pet<0)then
                      msg = msg .. "空\\n";
                else
                      msg = msg .. ""..Char.GetData(pet,CONST.CHAR_名字).."\\n";
                end
          end
          NLG.ShowWindowTalked(player, berryNpc, CONST.窗口_选择框, CONST.按钮_关闭, 1, msg);
    end
    return;
end

function BerryWindow(npc,player)
    if (NLG.CanTalk(npc, player) == true) then
          local msg = "3|\\n你要選擇哪隻寵物餵食樹果？樹果可以改變寵物的BP素質，目前品種會增加10點但減少另一項10點！\\n\\n";
          for i=0,4 do
                local pet = Char.GetPet(player,i);
                if(pet<0)then
                      msg = msg .. "空\\n";
                else
                      msg = msg .. ""..Char.GetData(pet,CONST.CHAR_名字).."\\n";
                end
          end
          NLG.ShowWindowTalked(player, berryNpc, CONST.窗口_选择框, CONST.按钮_关闭, 1, msg);
    end
    return
end

function BerryFunction(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --選擇吃樹果寵物
    if select == 0 then
      if seqno == 1 and data >= 1 then
        local slot = data-1;
        local petIndex = Char.GetPet(player,slot);
        if petIndex>=0 and ItemID ~=nil  then
             local pet_name = Char.GetData(petIndex,CONST.CHAR_名字);
             for k,v in pairs(petBerryTable) do
                local pet_minus = Char.GetData(petIndex, v.value_minus);
                if pet_minus >1000 and ItemID == v.itemID  then
                     Char.SetData(petIndex, v.value_plus, Char.GetData(petIndex,v.value_plus) + v.val_plus);
                     Char.SetData(petIndex, v.value_minus, Char.GetData(petIndex,v.value_minus) - v.val_minus);
                     Pet.UpPet(player, petIndex);
                     Char.DelItem(player, v.itemID, 1);
                     NLG.SystemMessage(player, '寵物 '..pet_name..' 吃下樹果產生變化！');
                end
             end
        end
      end
    end

end

function Plantberry_LoopEvent(_MeIndex)
	--创建植物
	local DTime = os.time()
	if DTime - STime >= YS then
		for i=1,20 do
		local Image = 114206
		local Name = Pos[i][1][1].."幼苗"
		local Num = Pos[i][1][8]
			if tbl_PlantberryNpcIndex[Num] == nil then
				local PlantberryNpcIndex = CreatePlantNpc(Image, Name, 0, Pos[i][1][3], Pos[i][1][4], Pos[i][1][5], Pos[i][1][6])
				tbl_PlantberryNpcIndex[Num] = PlantberryNpcIndex
			end
		end
	end
end
--NPC对话事件(NPC索引)
function PlantBerryFunction(_NpcIndex, _PlayerIndex)
tbl_PlantberryNpcIndex = {}
end
--NPC窗口事件(NPC索引)
function PlantBerryWindow( _NpcIndex, _PlayerIndex, _seqno, _select, _data)

end

function CreatePlantNpc(Image, Name, MapType, MapID, PosX, PosY, Dir)
	local PlantNpcIndex = NL.CreateNpc("./lua/System/BaseModule/Base.lua", "Myinit");
	Char.SetData( PlantNpcIndex, %对象_形象%, Image);
	Char.SetData( PlantNpcIndex, %对象_原形%, Image);
	Char.SetData( PlantNpcIndex, %对象_地图类型%, MapType);
	Char.SetData( PlantNpcIndex, %对象_地图%, MapID);
	Char.SetData( PlantNpcIndex, %对象_X%, PosX);
	Char.SetData( PlantNpcIndex, %对象_Y%, PosY);
	Char.SetData( PlantNpcIndex, %对象_方向%, Dir);
	Char.SetData( PlantNpcIndex, %对象_原名%, Name);
	Char.SetData( PlantNpcIndex, %对象_名色%, NameColor);
	tbl_LuaPlantNpcIndex = tbl_LuaPlantNpcIndex or {}
	tbl_LuaPlantNpcIndex["PlantNpc"] = PlantNpcIndex
	Char.SetTalkedEvent(nil, "PlantNpc__Talked", PlantNpcIndex)
	Char.SetWindowTalkedEvent(nil, "PlantNpc__WindowTalked", PlantNpcIndex)
	Char.SetLoopEvent(nil, "PlantNpc_LoopEvent", PlantNpcIndex, 600000)
	NLG.UpChar(PlantNpcIndex)
	return PlantNpcIndex
end
function PlantNpc_LoopEvent(_MeIndex)
	local tName = Char.GetData(_MeIndex, %对象_原名%)
	local tImage = Char.GetData(_MeIndex, %对象_形象%)
	for k,v in pairs(petBerryTable) do
		if (tName == v.name.."幼苗" and tImage == 114206 and PlantStep==0)  then
			PlantStep=1;
		elseif (tName == v.name.."幼苗" and tImage == 114206 and PlantStep==1)  then
			PlantStep=0;
			Char.SetData(_MeIndex, %对象_形象%, v.imageID);
			Char.SetData(_MeIndex, %对象_原形%, v.imageID);
			Char.SetData(_MeIndex, %对象_原名%, v.name);
			NLG.UpChar(_MeIndex);
		end
	end
end
function PlantNpc__Talked(_NpcIndex, _PlayerIndex)
	if(NLG.CheckInFront(_PlayerIndex, _NpcIndex, 1)==false and _Mode~=1) then
		return ;
	end
	--面向玩家
	local i;
	i = Char.GetData(_PlayerIndex, %对象_方向%);
	if i >= 4 then 
		i = i - 4;
	else
		i = i + 4;		
	end
	Char.SetData(_NpcIndex, %对象_方向%,i);
	NLG.UpChar( _NpcIndex);
	local tName = Char.GetData(_NpcIndex, %对象_原名%)
	local tImage = Char.GetData(_NpcIndex, %对象_形象%)
	if(tImage ~= 114206) then
		msg ="\\n\\n\\n\\n@c確定要摘取 "..tName.." 果實嗎？"
	else
		msg ="\\n\\n\\n\\n@c "..tName.." 尚未成熟，請細心照料等待！"
	end
	NLG.ShowWindowTalked(_PlayerIndex, _NpcIndex, 0, 1, 1, msg);
end

function PlantNpc__WindowTalked( _NpcIndex, _PlayerIndex, _Seqno, _Select, _Data)
	if _Seqno == 1 then
	local tName = Char.GetData(_NpcIndex, %对象_原名%)
	local tImage = Char.GetData(_NpcIndex, %对象_形象%)
	if(tImage ~= 114206) then
		for k,v in pairs(petBerryTable) do
			if tImage == v.imageID  then
				Char.GiveItem(_PlayerIndex, v.itemID, 1);
				if(math.random(1,10) >= 8) then           --随机进入树果守护兽战斗
					local tPlantBattleIndex = Battle.PVE( _PlayerIndex, _NpcIndex, nil, Pos[1][1][7], Pos[1][1][9], nil)
					Battle.SetWinEvent("./lua/Module/PetBerry.lua", "PlantNpc_BattleWin", tPlantBattleIndex);
					NL.DelNpc(_NpcIndex)
					local dp = table_n(_NpcIndex,0,'v',tbl_PlantberryNpcIndex)
					tbl_PlantberryNpcIndex[dp] = nil
				else
					NL.DelNpc(_NpcIndex)
					local dp = table_n(_NpcIndex,0,'v',tbl_PlantberryNpcIndex)
					tbl_PlantberryNpcIndex[dp] = nil
				end
				STime = os.time()
			end
		end

	end
	end
end

function PlantNpc_BattleWin(_BattleIndex, _NpcIndex)
		local tImage = Char.GetData(_NpcIndex, %对象_形象%)
		local tPlayerIndex = Battle.GetPlayIndex( _BattleIndex, 0)
		local plantBoss_drop = {};
		plantBoss_drop = {69018,69028};
		local drop_type = math.random(1,2);
		local drop_val = math.random(3,5);
		if tPlayerIndex>=0 and Char.GetData(tPlayerIndex,%对象_类型%)==1 then
			if(tImage ~= 114206) then
				Char.GiveItem(tPlayerIndex, plantBoss_drop[drop_type], drop_val);
				--NL.DelNpc(_NpcIndex)
				--local dp = table_n(_NpcIndex,0,'v',tbl_PlantberryNpcIndex)
				--tbl_PlantberryNpcIndex[dp] = nil
			end
		end
		Battle.UnsetWinEvent( _BattleIndex);
	--return 1
end


function table_n(c1,c2,n,t)
	for key, value in pairs(t) do
		if c1 == value and n == 'v' then
			return key
		end
	end
end

function PetBerry_Init()
	PetBerry_create();
	return 0;
end
