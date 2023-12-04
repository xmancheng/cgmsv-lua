local EnemySet = {}
local BaseLevelSet = {}
local Pos = {}
local STime = os.time()
local YS = 30 --�ű���ʱ�����봴��NPC
local SXTime = 60 --NPCˢ��ʱ�䡤��
local PlantStep = 0
--���н���
--     ��	��	һ	��	��
--     ʮ	��	��	��	��
------------���BOSS����------------
EnemySet[1] = {100087, 102320, 102320, 0, 0, 0, 0, 0, 102321, 102321}--0����û�й�
BaseLevelSet[1] = {50, 30, 30, 0, 0, 0, 0, 0, 30, 30}
------------------------------------------------
Pos[1] = {{"���ӹ�",500178,25011,9,5,0,EnemySet[1],1,BaseLevelSet[1]}}
Pos[2] = {{"�OҰ��",500179,25011,9,6,0,EnemySet[1],2,BaseLevelSet[1]}}
Pos[3] = {{"��ʯ��",500180,25011,9,7,0,EnemySet[1],3,BaseLevelSet[1]}}
Pos[4] = {{"֦���",500198,25011,21,12,0,EnemySet[1],4,BaseLevelSet[1]}}
Pos[5] = {{"��ľ��",500194,25011,15,5,0,EnemySet[1],5,BaseLevelSet[1]}}
Pos[6] = {{"���ֹ�",500195,25011,15,6,0,EnemySet[1],6,BaseLevelSet[1]}}
Pos[7] = {{"�����",500196,25011,15,7,0,EnemySet[1],7,BaseLevelSet[1]}}
Pos[8] = {{"��ݮ��",500197,25011,5,1,0,EnemySet[1],8,BaseLevelSet[1]}}
Pos[9] = {{"�����",500184,25011,21,5,0,EnemySet[1],9,BaseLevelSet[1]}}
Pos[10] = {{"īݮ��",500185,25011,21,6,0,EnemySet[1],10,BaseLevelSet[1]}}
Pos[11] = {{"Ҭľ��",500186,25011,21,7,0,EnemySet[1],11,BaseLevelSet[1]}}
Pos[12] = {{"���ܹ�",500193,25011,21,14,0,EnemySet[1],12,BaseLevelSet[1]}}
Pos[13] = {{"�ȳȹ�",500181,25011,9,12,0,EnemySet[1],13,BaseLevelSet[1]}}
Pos[14] = {{"�����",500182,25011,9,13,0,EnemySet[1],14,BaseLevelSet[1]}}
Pos[15] = {{"�Fɏ��",500183,25011,9,14,0,EnemySet[1],15,BaseLevelSet[1]}}
Pos[16] = {{"ݮݮ��",500191,25011,21,13,0,EnemySet[1],16,BaseLevelSet[1]}}
Pos[17] = {{"ââ��",500188,25011,15,12,0,EnemySet[1],17,BaseLevelSet[1]}}
Pos[18] = {{"�����",500189,25011,5,0,0,EnemySet[1],18,BaseLevelSet[1]}}
Pos[19] = {{"�����",500190,25011,15,13,0,EnemySet[1],19,BaseLevelSet[1]}}
Pos[20] = {{"�Ȱ͹�",500199,25011,15,14,0,EnemySet[1],20,BaseLevelSet[1]}}

tbl_PlantberryNpcIndex = tbl_PlantberryNpcIndex or {}
------------------------------------------------
local petBerryTable = {
      --����������
      { itemID = 69011, value_plus = CONST.CHAR_����, val_plus = 1000, value_minus = CONST.CHAR_����, val_minus = 1000, name="���ӹ�", imageID=500178},
      { itemID = 69012, value_plus = CONST.CHAR_����, val_plus = 1000, value_minus = CONST.CHAR_ǿ��, val_minus = 1000, name="�OҰ��", imageID=500179},
      { itemID = 69013, value_plus = CONST.CHAR_����, val_plus = 1000, value_minus = CONST.CHAR_�ٶ�, val_minus = 1000, name="��ʯ��", imageID=500180},
      { itemID = 69014, value_plus = CONST.CHAR_����, val_plus = 1000, value_minus = CONST.CHAR_ħ��, val_minus = 1000, name="֦���", imageID=500198},
      --����������
      { itemID = 69015, value_plus = CONST.CHAR_����, val_plus = 1000, value_minus = CONST.CHAR_����, val_minus = 1000, name="��ľ��", imageID=500194},
      { itemID = 69016, value_plus = CONST.CHAR_����, val_plus = 1000, value_minus = CONST.CHAR_ǿ��, val_minus = 1000, name="���ֹ�", imageID=500195},
      { itemID = 69017, value_plus = CONST.CHAR_����, val_plus = 1000, value_minus = CONST.CHAR_�ٶ�, val_minus = 1000, name="�����", imageID=500196},
      { itemID = 69018, value_plus = CONST.CHAR_����, val_plus = 1000, value_minus = CONST.CHAR_ħ��, val_minus = 1000, name="��ݮ��", imageID=500197},
      --��ǿ������
      { itemID = 69019, value_plus = CONST.CHAR_ǿ��, val_plus = 1000, value_minus = CONST.CHAR_����, val_minus = 1000, name="�����", imageID=500184},
      { itemID = 69020, value_plus = CONST.CHAR_ǿ��, val_plus = 1000, value_minus = CONST.CHAR_����, val_minus = 1000, name="īݮ��", imageID=500185},
      { itemID = 69021, value_plus = CONST.CHAR_ǿ��, val_plus = 1000, value_minus = CONST.CHAR_�ٶ�, val_minus = 1000, name="Ҭľ��", imageID=500186},
      { itemID = 69022, value_plus = CONST.CHAR_ǿ��, val_plus = 1000, value_minus = CONST.CHAR_ħ��, val_minus = 1000, name="���ܹ�", imageID=500193},
      --���ٶ�����
      { itemID = 69023, value_plus = CONST.CHAR_�ٶ�, val_plus = 1000, value_minus = CONST.CHAR_����, val_minus = 1000, name="�ȳȹ�", imageID=500181},
      { itemID = 69024, value_plus = CONST.CHAR_�ٶ�, val_plus = 1000, value_minus = CONST.CHAR_����, val_minus = 1000, name="�����", imageID=500182},
      { itemID = 69025, value_plus = CONST.CHAR_�ٶ�, val_plus = 1000, value_minus = CONST.CHAR_ǿ��, val_minus = 1000, name="�Fɏ��", imageID=500183},
      { itemID = 69026, value_plus = CONST.CHAR_�ٶ�, val_plus = 1000, value_minus = CONST.CHAR_ħ��, val_minus = 1000, name="ݮݮ��", imageID=500191},
      --��ħ������
      { itemID = 69027, value_plus = CONST.CHAR_ħ��, val_plus = 1000, value_minus = CONST.CHAR_����, val_minus = 1000, name="ââ��", imageID=500188},
      { itemID = 69028, value_plus = CONST.CHAR_ħ��, val_plus = 1000, value_minus = CONST.CHAR_����, val_minus = 1000, name="�����", imageID=500189},
      { itemID = 69029, value_plus = CONST.CHAR_ħ��, val_plus = 1000, value_minus = CONST.CHAR_ǿ��, val_minus = 1000, name="�����", imageID=500190},
      { itemID = 69030, value_plus = CONST.CHAR_ħ��, val_plus = 1000, value_minus = CONST.CHAR_�ٶ�, val_minus = 1000, name="�Ȱ͹�", imageID=500199},
}

------------------------------------------------
Delegate.RegInit("PetBerry_Init");

function initPetBerryNpc_Init(index)
	print("��������npc_index = " .. index);
	return 1;
end

function PetBerry_create() 
	if (berryNpc == nil) then
		berryNpc = NL.CreateNpc("lua/Module/PetBerry.lua", "initPetBerryNpc_Init");
		Char.SetData(berryNpc,%����_����%,231063);
		Char.SetData(berryNpc,%����_ԭ��%,231063);
		Char.SetData(berryNpc,%����_X%,6);
		Char.SetData(berryNpc,%����_Y%,1);
		Char.SetData(berryNpc,%����_��ͼ%,25011);
		Char.SetData(berryNpc,%����_����%,6);
		Char.SetData(berryNpc,%����_����%,"�������");
		NLG.UpChar(berryNpc);
		Char.SetTalkedEvent("lua/Module/PetBerry.lua", "BerryWindow", berryNpc);
		Char.SetWindowTalkedEvent("lua/Module/PetBerry.lua", "BerryFunction", berryNpc);
	end
	if (PlantberryNpc == nil) then
		PlantberryNpc = NL.CreateNpc("lua/Module/PetBerry.lua", "initPetBerryNpc_Init");
		Char.SetData(PlantberryNpc,%����_����%,231116);
		Char.SetData(PlantberryNpc,%����_ԭ��%,231116);
		Char.SetData(PlantberryNpc,%����_X%,19);
		Char.SetData(PlantberryNpc,%����_Y%,19);
		Char.SetData(PlantberryNpc,%����_��ͼ%,777);
		Char.SetData(PlantberryNpc,%����_����%,6);
		Char.SetData(PlantberryNpc,%����_ԭ��%,"����ֲ������");
		NLG.UpChar(PlantberryNpc);
		Char.SetLoopEvent(nil, "Plantberry_LoopEvent",PlantberryNpc, SXTime*1000)
		Char.SetWindowTalkedEvent("lua/Module/PetBerry.lua","PlantBerryWindow",PlantberryNpc);
		Char.SetTalkedEvent("lua/Module/PetBerry.lua","PlantBerryFunction", PlantberryNpc);
	end
end

NL.RegItemString("lua/Module/PetBerry.lua","BerryItem","LUA_useBerry");
function BerryItem(player,_toIndex,_itemslot) --˫������ִ�к���
    if (NLG.CanTalk(berryNpc,player) == false) then
          local itemIndex = Char.GetItemIndex(player, _itemslot);
          ItemID = Item.GetData(itemIndex, CONST.����_ID);
          local msg = "3|\\n��Ҫ�x�����b�����jʳ�����������Ը�׃�����BP���|��ĿǰƷ�N������10�c���p����һ�10�c��\\n\\n";
          for i=0,4 do
                local pet = Char.GetPet(player,i);
                if(pet<0)then
                      msg = msg .. "��\\n";
                else
                      msg = msg .. ""..Char.GetData(pet,CONST.CHAR_����).."\\n";
                end
          end
          NLG.ShowWindowTalked(player, berryNpc, CONST.����_ѡ���, CONST.��ť_�ر�, 1, msg);
    end
    return;
end

function BerryWindow(npc,player)
    if (NLG.CanTalk(npc, player) == true) then
          local msg = "3|\\n��Ҫ�x�����b�����jʳ�����������Ը�׃�����BP���|��ĿǰƷ�N������10�c���p����һ�10�c��\\n\\n";
          for i=0,4 do
                local pet = Char.GetPet(player,i);
                if(pet<0)then
                      msg = msg .. "��\\n";
                else
                      msg = msg .. ""..Char.GetData(pet,CONST.CHAR_����).."\\n";
                end
          end
          NLG.ShowWindowTalked(player, berryNpc, CONST.����_ѡ���, CONST.��ť_�ر�, 1, msg);
    end
    return
end

function BerryFunction(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.����_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --�x��Ԙ������
    if select == 0 then
      if seqno == 1 and data >= 1 then
        local slot = data-1;
        local petIndex = Char.GetPet(player,slot);
        if petIndex>=0 and ItemID ~=nil  then
             local pet_name = Char.GetData(petIndex,CONST.CHAR_����);
             for k,v in pairs(petBerryTable) do
                local pet_minus = Char.GetData(petIndex, v.value_minus);
                if pet_minus >1000 and ItemID == v.itemID  then
                     Char.SetData(petIndex, v.value_plus, Char.GetData(petIndex,v.value_plus) + v.val_plus);
                     Char.SetData(petIndex, v.value_minus, Char.GetData(petIndex,v.value_minus) - v.val_minus);
                     Pet.UpPet(player, petIndex);
                     Char.DelItem(player, v.itemID, 1);
                     NLG.SystemMessage(player, '���� '..pet_name..' ������a��׃����');
                end
             end
        end
      end
    end

end

function Plantberry_LoopEvent(_MeIndex)
	--����ֲ��
	local DTime = os.time()
	if DTime - STime >= YS then
		for i=1,20 do
		local Image = 114206
		local Name = Pos[i][1][1].."����"
		local Num = Pos[i][1][8]
			if tbl_PlantberryNpcIndex[Num] == nil then
				local PlantberryNpcIndex = CreatePlantNpc(Image, Name, 0, Pos[i][1][3], Pos[i][1][4], Pos[i][1][5], Pos[i][1][6])
				tbl_PlantberryNpcIndex[Num] = PlantberryNpcIndex
			end
		end
	end
end
--NPC�Ի��¼�(NPC����)
function PlantBerryFunction(_NpcIndex, _PlayerIndex)
tbl_PlantberryNpcIndex = {}
end
--NPC�����¼�(NPC����)
function PlantBerryWindow( _NpcIndex, _PlayerIndex, _seqno, _select, _data)

end

function CreatePlantNpc(Image, Name, MapType, MapID, PosX, PosY, Dir)
	local PlantNpcIndex = NL.CreateNpc("./lua/System/BaseModule/Base.lua", "Myinit");
	Char.SetData( PlantNpcIndex, %����_����%, Image);
	Char.SetData( PlantNpcIndex, %����_ԭ��%, Image);
	Char.SetData( PlantNpcIndex, %����_��ͼ����%, MapType);
	Char.SetData( PlantNpcIndex, %����_��ͼ%, MapID);
	Char.SetData( PlantNpcIndex, %����_X%, PosX);
	Char.SetData( PlantNpcIndex, %����_Y%, PosY);
	Char.SetData( PlantNpcIndex, %����_����%, Dir);
	Char.SetData( PlantNpcIndex, %����_ԭ��%, Name);
	Char.SetData( PlantNpcIndex, %����_��ɫ%, NameColor);
	tbl_LuaPlantNpcIndex = tbl_LuaPlantNpcIndex or {}
	tbl_LuaPlantNpcIndex["PlantNpc"] = PlantNpcIndex
	Char.SetTalkedEvent(nil, "PlantNpc__Talked", PlantNpcIndex)
	Char.SetWindowTalkedEvent(nil, "PlantNpc__WindowTalked", PlantNpcIndex)
	Char.SetLoopEvent(nil, "PlantNpc_LoopEvent", PlantNpcIndex, 600000)
	NLG.UpChar(PlantNpcIndex)
	return PlantNpcIndex
end
function PlantNpc_LoopEvent(_MeIndex)
	local tName = Char.GetData(_MeIndex, %����_ԭ��%)
	local tImage = Char.GetData(_MeIndex, %����_����%)
	for k,v in pairs(petBerryTable) do
		if (tName == v.name.."����" and tImage == 114206 and PlantStep==0)  then
			PlantStep=1;
		elseif (tName == v.name.."����" and tImage == 114206 and PlantStep==1)  then
			PlantStep=0;
			Char.SetData(_MeIndex, %����_����%, v.imageID);
			Char.SetData(_MeIndex, %����_ԭ��%, v.imageID);
			Char.SetData(_MeIndex, %����_ԭ��%, v.name);
			NLG.UpChar(_MeIndex);
		end
	end
end
function PlantNpc__Talked(_NpcIndex, _PlayerIndex)
	if(NLG.CheckInFront(_PlayerIndex, _NpcIndex, 1)==false and _Mode~=1) then
		return ;
	end
	--�������
	local i;
	i = Char.GetData(_PlayerIndex, %����_����%);
	if i >= 4 then 
		i = i - 4;
	else
		i = i + 4;		
	end
	Char.SetData(_NpcIndex, %����_����%,i);
	NLG.UpChar( _NpcIndex);
	local tName = Char.GetData(_NpcIndex, %����_ԭ��%)
	local tImage = Char.GetData(_NpcIndex, %����_����%)
	if(tImage ~= 114206) then
		msg ="\\n\\n\\n\\n@c�_��Ҫժȡ "..tName.." �����᣿"
	else
		msg ="\\n\\n\\n\\n@c "..tName.." ��δ���죬Ո�������ϵȴ���"
	end
	NLG.ShowWindowTalked(_PlayerIndex, _NpcIndex, 0, 1, 1, msg);
end

function PlantNpc__WindowTalked( _NpcIndex, _PlayerIndex, _Seqno, _Select, _Data)
	if _Seqno == 1 then
	local tName = Char.GetData(_NpcIndex, %����_ԭ��%)
	local tImage = Char.GetData(_NpcIndex, %����_����%)
	if(tImage ~= 114206) then
		for k,v in pairs(petBerryTable) do
			if tImage == v.imageID  then
				Char.GiveItem(_PlayerIndex, v.itemID, 1);
				if(math.random(1,10) >= 8) then           --������������ػ���ս��
					local tPlantBattleIndex = Battle.PVE( _PlayerIndex, _NpcIndex, nil, Pos[1][1][7], Pos[1][1][9], nil)
					Battle.SetWinEvent( nil, "PlantNpc_BattleWin", tPlantBattleIndex);
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
		local tImage = Char.GetData(_NpcIndex, %����_����%)
		local tPlayerIndex = Battle.GetPlayIndex( _BattleIndex, 0)
		local plantBoss_drop = {};
		plantBoss_drop = {69018,69028};
		local drop_type = math.random(1,2);
		local drop_val = math.random(3,5);
		if tPlayerIndex>=0 and Char.GetData(tPlayerIndex,%����_����%)==1 then
			if(tImage ~= 114206) then
				Char.GiveItem(tPlayerIndex, plantBoss_drop[drop_type], drop_val);
				NL.DelNpc(_NpcIndex)
				local dp = table_n(_NpcIndex,0,'v',tbl_PlantberryNpcIndex)
				tbl_PlantberryNpcIndex[dp] = nil
			end
		end
	return 1
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
