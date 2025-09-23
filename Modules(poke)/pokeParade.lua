---ģ����
local Module = ModuleBase:createModule('pokeParade')

local PokeEnemy = {
      { palType=1, palNum=20, enMode=0, palName="Ұ�����ɉ�", palImage=121000, popArea={map=80028,LX=60,LY=70, RX=130,RY=140},	--palNum����������palImage��������(���ظ�)����û��Χ(��������)
         encount=80, prizeItem_id={75024,74200}, prizeItem_count={1,1} },						--encount���л��ʡ�prizeItem�������(���ظ����飬��߸���ϻ���)
      { palType=2, palNum=15, enMode=0, palName="Ұ�����ɉ�", palImage=121091, popArea={map=80028,LX=60,LY=70, RX=130,RY=140},
         encount=80, prizeItem_id={75024,74200}, prizeItem_count={1,1} },
      { palType=3, palNum=10, enMode=0, palName="Ұ�����ɉ�", palImage=121021, popArea={map=80028,LX=60,LY=70, RX=130,RY=140},
         encount=80, prizeItem_id={75024,74200}, prizeItem_count={1,1} },
      { palType=4, palNum=5, enMode=0, palName="Ұ�����ɉ�", palImage=121115, popArea={map=80028,LX=60,LY=70, RX=130,RY=140},
         encount=80, prizeItem_id={75024,74200}, prizeItem_count={3,3} },
      { palType=5, palNum=1, enMode=2, palName="�^���^Ŀ", palImage=121046, popArea={map=80028,LX=91,LY=100, RX=96,RY=95},
         encount=100, prizeItem_id={75025}, prizeItem_count={1} },
      { palType=6, palNum=1, enMode=3, palName="�^���^Ŀ", palImage=121047, popArea={map=80028,LX=102,LY=95, RX=107,RY=100},
         encount=100, prizeItem_id={75025}, prizeItem_count={1} },
      { palType=7, palNum=1, enMode=4, palName="�^���I��", palImage=121286, popArea={map=80028,LX=67,LY=74, RX=130,RY=79},
         encount=100, prizeItem_id={75026}, prizeItem_count={1} },
}
------------------------------------------------
local EnemySet = {}
local BaseLevelSet = {}
EnemySet[1] = {416360, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0����û�й�
BaseLevelSet[1] = {30, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[2] = {416434, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0����û�й�
BaseLevelSet[2] = {40, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[3] = {416380, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0����û�й�
BaseLevelSet[3] = {50, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[4] = {416459, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0����û�й�
BaseLevelSet[4] = {50, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[5] = {416402, 0, 0, 0, 0, 416398, 416398, 416398, 416398, 416398}	--0����û�й�
BaseLevelSet[5] = {150, 0, 0, 0, 0, 120, 120, 120, 120, 120}
EnemySet[6] = {416403, 0, 0, 0, 0, 416399, 416399, 416399, 416399, 416399}	--0����û�й�
BaseLevelSet[6] = {150, 0, 0, 0, 0, 120, 120, 120, 120, 120}
EnemySet[7] = {416356, 0, 0, 416426, 416426, 0, 416427, 416427, 0, 0}	--0����û�й�
BaseLevelSet[7] = {150, 0, 0, 130, 130, 0, 130, 130, 0, 0}
------------------------------------------------
local FTime = os.time();			--ʱ���
tbl_PokeEnemyNPCIndex = tbl_PokeEnemyNPCIndex or {}
------------------------------------------------
--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('LoopEvent', Func.bind(self.PokeEnemy_LoopEvent,self))
  for k,v in pairs(PokeEnemy) do
    if (tbl_PokeEnemyNPCIndex[k] == nil) then
        tbl_PokeEnemyNPCIndex[k] = {}
    end
    for i=1, v.palNum do
       if (tbl_PokeEnemyNPCIndex[k][i] == nil) then
           local palX = NLG.Rand(v.popArea.LX, v.popArea.RX);
           local palY = NLG.Rand(v.popArea.LY, v.popArea.RY);
           local PokeEnemyNPC = self:NPC_createNormal(v.palName, v.palImage, { map = v.popArea.map, x = palX, y = palY, direction = 5, mapType = 0 })
           tbl_PokeEnemyNPCIndex[k][i] = PokeEnemyNPC
           Char.SetLoopEvent('./lua/Modules/pokeParade.lua','PokeEnemy_LoopEvent',tbl_PokeEnemyNPCIndex[k][i], 1000);
           self:regCallback('CharActionEvent', function(player, actionID)
             local Target_FloorId = Char.GetData(player,CONST.����_��ͼ);
             if (actionID == CONST.����_���� and Target_FloorId==80028 and v.enMode==1) then
                  local npcImage = Char.GetData(tbl_PokeEnemyNPCIndex[k][i],CONST.����_����);
                  local npc = tbl_PokeEnemyNPCIndex[k][i];
                  if ( NLG.CheckInFront(player, npc, 1)==false) then
                        return;
                  else
                     if ( k==v.palType and npcImage==v.palImage) then
                        if ( Char.ItemSlot(player)>19)then
                            NLG.SystemMessage(player,"[ϵ�y]��Ʒ���ѝM��");
                            return;
                        else
                            if( NLG.Rand(1,100) <= v.encount )then
                                Battle.PVE( player, player, nil, EnemySet[k], BaseLevelSet[k], nil);
                                pal_clear(player, npc);
                            else
                                local rand = NLG.Rand(1,#v.prizeItem_id);
                                Char.GiveItem(player, v.prizeItem_id[rand], v.prizeItem_count[rand]);
                                pal_clear(player, npc);
                                local Target_MapId = Char.GetData(player,CONST.CHAR_MAP)--��ͼ����
                                local Target_FloorId = Char.GetData(player,CONST.����_��ͼ)--��ͼ���
                                local Target_X = Char.GetData(player,CONST.����_X)--��ͼx
                                local Target_Y = Char.GetData(player,CONST.����_Y)--��ͼy
                                Char.Warp(player,Target_MapId,Target_FloorId,Target_X,Target_Y);
                                NLG.UpChar(player);
                            end
                        end
                     end
                  end
             elseif (v.enMode==0 or v.enMode==2) then
                      return;
             else
             end
           end)

           self:NPC_regWindowTalkedEvent(tbl_PokeEnemyNPCIndex[k][i], function(npc, player, _seqno, _select, _data)
             local cdk = Char.GetData(player,CONST.����_CDK);
             local seqno = tonumber(_seqno)
             local select = tonumber(_select)
             local data = tonumber(_data)
           end)
           self:NPC_regTalkedEvent(tbl_PokeEnemyNPCIndex[k][i], function(npc, player)
             if(NLG.CheckInFront(player, npc, 1)==false) then
                 return ;
             end
             if (v.enMode==1 and NLG.CanTalk(npc, player) == true) then
                 NLG.SystemMessage(player,"[ϵ�y]Ոʹ�ù������ץ����");
                 return ;
             elseif (v.enMode==0 and NLG.CanTalk(npc, player) == true) then
                  local npcImage = Char.GetData(tbl_PokeEnemyNPCIndex[k][i],CONST.����_����);
                  local npc = tbl_PokeEnemyNPCIndex[k][i];
                  if ( NLG.CheckInFront(player, npc, 1)==false) then
                        return;
                  else
                     if ( k==v.palType and npcImage==v.palImage) then
                        --if ( Char.ItemSlot(player)>19)then
                            --NLG.SystemMessage(player,"[ϵ�y]��Ʒ���ѝM��");
                            --return;
                        --else
                            --if( NLG.Rand(1,100) <= v.encount )then
                                Battle.PVE( player, player, nil, EnemySet[k], BaseLevelSet[k], nil);
                                pal_clear(player, npc);
                            --else
                            --    local rand = NLG.Rand(1,#v.prizeItem_id);
                            --    Char.GiveItem(player, v.prizeItem_id[rand], v.prizeItem_count[rand]);
                            --    pal_clear(player, npc);
                            --    local Target_MapId = Char.GetData(player,CONST.CHAR_MAP)--��ͼ����
                            --    local Target_FloorId = Char.GetData(player,CONST.����_��ͼ)--��ͼ���
                            --    local Target_X = Char.GetData(player,CONST.����_X)--��ͼx
                            --    local Target_Y = Char.GetData(player,CONST.����_Y)--��ͼy
                            --    Char.Warp(player,Target_MapId,Target_FloorId,Target_X,Target_Y);
                            --    NLG.UpChar(player);
                            --end
                        --end
                     end
                  end
             elseif (v.enMode==2 and NLG.CanTalk(npc, player) == true) then
                  local npcImage = Char.GetData(tbl_PokeEnemyNPCIndex[k][i],CONST.����_����);
                  local npc = tbl_PokeEnemyNPCIndex[k][i];
                  if ( NLG.CheckInFront(player, npc, 1)==false) then
                        return;
                  else
                     if ( k==v.palType and npcImage==v.palImage) then
                        if ( Char.HaveItem(player, 631085)<0 and Char.HaveItem(player, 631086)<0 )then
                            NLG.SystemMessage(player,"[ϵ�y]ȱ���ֿ����������ֿ����𡹡�");
                            return;
                        elseif ( Char.HaveItem(player, 631085)<0 and Char.HaveItem(player, 631086)>0 )then
                            NLG.SystemMessage(player,"[ϵ�y]ȱ���ֿ���������");
                            return;
                        elseif ( Char.HaveItem(player, 631085)>0 and Char.HaveItem(player, 631086)<0 )then
                            NLG.SystemMessage(player,"[ϵ�y]ȱ���ֿ����𡹡�");
                            return;
                        end
                        Char.DelItem(player,631085,1,1);
                        Char.DelItem(player,631086,1,1);
                        local battleIndex = Battle.PVE( player, player, nil, EnemySet[k], BaseLevelSet[k], nil);
                        Battle.SetWinEvent("./lua/Modules/pokeParade.lua", "paradeBossNPC_BattleWin", battleIndex);
                        pal_clear(player, npc);
                     end
                  end
             elseif (v.enMode==3 and NLG.CanTalk(npc, player) == true) then
                  local npcImage = Char.GetData(tbl_PokeEnemyNPCIndex[k][i],CONST.����_����);
                  local npc = tbl_PokeEnemyNPCIndex[k][i];
                  if ( NLG.CheckInFront(player, npc, 1)==false) then
                        return;
                  else
                     if ( k==v.palType and npcImage==v.palImage) then
                        if ( Char.HaveItem(player, 631087)<0 and Char.HaveItem(player, 631088)<0 )then
                            NLG.SystemMessage(player,"[ϵ�y]ȱ���ֿ����^�����ֿ����򡹡�");
                            return;
                        elseif ( Char.HaveItem(player, 631087)<0 and Char.HaveItem(player, 631088)>0 )then
                            NLG.SystemMessage(player,"[ϵ�y]ȱ���ֿ����^����");
                            return;
                        elseif ( Char.HaveItem(player, 631087)>0 and Char.HaveItem(player, 631088)<0 )then
                            NLG.SystemMessage(player,"[ϵ�y]ȱ���ֿ����򡹡�");
                            return;
                        end
                        Char.DelItem(player,631087,1,1);
                        Char.DelItem(player,631088,1,1);
                        local battleIndex = Battle.PVE( player, player, nil, EnemySet[k], BaseLevelSet[k], nil);
                        Battle.SetWinEvent("./lua/Modules/pokeParade.lua", "paradeBossNPC_BattleWin", battleIndex);
                        pal_clear(player, npc);
                     end
                  end
             elseif (v.enMode==4 and NLG.CanTalk(npc, player) == true) then
                  local npcImage = Char.GetData(tbl_PokeEnemyNPCIndex[k][i],CONST.����_����);
                  local npc = tbl_PokeEnemyNPCIndex[k][i];
                  if ( NLG.CheckInFront(player, npc, 1)==false) then
                        return;
                  else
                     if ( k==v.palType and npcImage==v.palImage) then
                        if ( Char.HaveItem(player, 631085)<0 or Char.HaveItem(player, 631086)<0 or Char.HaveItem(player, 631087)<0 or Char.HaveItem(player, 631088)<0 or Char.HaveItem(player, 631089)<0 or Char.HaveItem(player, 631090)<0 )then
                            NLG.SystemMessage(player,"[ϵ�y]���R�ֿ������������𡹡����^�������򡹡����I������������");
                            return;
                        end
                        Char.DelItem(player,631085,1,1);
                        Char.DelItem(player,631086,1,1);
                        Char.DelItem(player,631087,1,1);
                        Char.DelItem(player,631088,1,1);
                        Char.DelItem(player,631089,1,1);
                        Char.DelItem(player,631090,1,1);
                        local battleIndex = Battle.PVE( player, player, nil, EnemySet[k], BaseLevelSet[k], nil);
                        Battle.SetWinEvent("./lua/Modules/pokeParade.lua", "paradeLordNPC_BattleWin", battleIndex);
                        pal_clear(player, npc);
                     end
                  end
             end
             return
           end)
       end
    end
  end

  huntingNPC = self:NPC_createNormal('���C���������', 14580, { map = 80010, x = 106, y = 96, direction = 4, mapType = 0 })
  Char.SetData(huntingNPC,CONST.����_ENEMY_PetFlg+2,0);
  self:NPC_regWindowTalkedEvent(huntingNPC, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.����_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if seqno == 1 then  ----������սִ��
     if select == 4 then
       if (os.date("%H",os.time())~="20") then
         NLG.SystemMessage(player,"[�������]��������r�g��ÿ��20:00-20:29��");
         return;
       end
       if (os.date("%H",os.time())=="20") and (os.date("%M",os.time())>="31") then
         NLG.SystemMessage(player,"[�������]���C������ѽ��_ʼ��Ո�ȴ����Ո�����");
         return;
       end
       Char.Warp(player,0,80028,98,139);
     else
       return 0;
     end
    end

  end)
  self:NPC_regTalkedEvent(huntingNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "\\n@c���C������f��\\n"
                  .. "\\nÿ�����ϰ��c�����M��\\n"
                  .. "��С�r���P�]�������\\n"
                  .. "ÿ�δ���r�g��һС�r\\n\\n"
                  .. "�M�ϵ����ֿ��M�Ќ���\\n"
                  .. "�ռ��ֿ����Q��ʽ��Ʒ\\n";
      NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 1, msg);
    end
    return
  end)


end
------------------------------------------------
-------��������
--ת��
function PokeEnemy_LoopEvent(npc)
	local CTime = tonumber(os.date("%H",FTime));
	if (os.date("%X",os.time())=="19:59:59") then
		local MapUser = NLG.GetMapPlayer(0,80028);
		if (MapUser~=-3) then
			for _,v in pairs(MapUser) do
				Char.Warp(v,0,80010,103,103);
			end
		end
		NLG.SystemMessage(-1,"[�������]���C����������_ʼ��Ո�M�و��������");
	elseif (os.date("%X",os.time())=="20:20:00") then
		NLG.SystemMessage(-1,"[�������]���C���������ʣ��10��犣�Ո�M�و��������");
	elseif (os.date("%X",os.time())=="21:00:00") then
		local MapUser = NLG.GetMapPlayer(0,80028);
		if (MapUser~=-3) then
			for _,v in pairs(MapUser) do
				Char.Warp(v,0,80010,103,103);
			end
		end
		NLG.SystemMessage(-1,"[�������]�������C������ѽY���������ͅ������x����");
	--[[elseif (os.date("%H",os.time())~="20") then
		local MapUser = NLG.GetMapPlayer(0,80028);
		if (MapUser~=-3) then
			for _,v in pairs(MapUser) do
				Char.Warp(v,0,80010,103,103);
			end
		end]]
	elseif (os.date("%M",os.time())=="8") or (os.date("%M",os.time())=="16") or (os.date("%M",os.time())=="24") or (os.date("%M",os.time())=="32") or (os.date("%M",os.time())=="40") or (os.date("%M",os.time())=="48") or (os.date("%M",os.time())=="56") or (os.date("%M",os.time())=="00") then
		if (os.date("%S",os.time())=="00") or (os.date("%S",os.time())=="01") then
		for k,v in pairs(PokeEnemy) do
			local npcImage = Char.GetData(npc,CONST.����_����);
			local npcFloorId = Char.GetData(npc,CONST.����_��ͼ);
			if ( k==v.palType and npcImage==v.palImage and npcFloorId==777 ) then
				local palX = NLG.Rand(v.popArea.LX, v.popArea.RX);
				local palY = NLG.Rand(v.popArea.LY, v.popArea.RY);
				Char.SetData(npc,CONST.����_X, palX);
				Char.SetData(npc,CONST.����_Y, palY);
				Char.SetData(npc,CONST.����_��ͼ, v.popArea.map);
				NLG.UpChar(npc);
			end
		end
		end
	elseif (os.date("%X",os.time())=="23:59:59") or (os.date("%X",os.time())=="19:59:59") then
		for k,v in pairs(PokeEnemy) do
			local npcImage = Char.GetData(npc,CONST.����_����);
			if ( k==v.palType and npcImage==v.palImage ) then
				Char.SetData(npc,CONST.����_X, 43);
				Char.SetData(npc,CONST.����_Y, 38);
				Char.SetData(npc,CONST.����_��ͼ, 777);
				NLG.UpChar(npc);
			end
		end
	end
	local excess = math.random(1,10);
	if (Char.GetData(npc,CONST.����_��ͼ)==80028 and excess>=7) then
		local dir = math.random(0, 7);
		local walk = 1;
		local X,Y = Char.GetLocation(npc,dir);
		if (NLG.Walkable(0, 80028, X, Y)==1) then
			NLG.SetAction(npc,walk);
			NLG.WalkMove(npc,dir);
			NLG.UpChar(npc);
		end
	end
end

function pal_clear(player, npc)
	--ת�������ؿռ�
	Char.SetData(npc,CONST.����_X, 43);
	Char.SetData(npc,CONST.����_Y, 38);
	Char.SetData(npc,CONST.����_��ͼ, 777);
	NLG.UpChar(npc);
end

function paradeBossNPC_BattleWin(battleIndex, charIndex)
	local leader1 = Battle.GetPlayer(battleIndex,0)
	local leader2 = Battle.GetPlayer(battleIndex,5)
	local leader = leader1
	if Char.GetData(leader2, CONST.CHAR_����) == CONST.��������_�� then
		leader = leader2
	end

	if (Char.GetData(charIndex, CONST.����_��ͼ)==80028) then
	--���佱��
	for p=0,9 do
		local player = Battle.GetPlayIndex(battleIndex, p);
		local drop = {0,0,0,0,0,1,1,1,1,1,}
		local rand = drop[NLG.Rand(1,10)];
		local dropMenu = {70052,70052,68018};
		if player>=0 and Char.GetData(player, CONST.����_����) == CONST.��������_�� then
			Char.GiveItem(player, dropMenu[NLG.Rand(1,3)], rand);
		end
	end
	end
	Battle.UnsetWinEvent(battleIndex);
end

function paradeLordNPC_BattleWin(battleIndex, charIndex)
	local leader1 = Battle.GetPlayer(battleIndex,0)
	local leader2 = Battle.GetPlayer(battleIndex,5)
	local leader = leader1
	if Char.GetData(leader2, CONST.CHAR_����) == CONST.��������_�� then
		leader = leader2
	end

	if (Char.GetData(charIndex, CONST.����_��ͼ)==80028) then
	--���佱��
	for p=0,9 do
		local player = Battle.GetPlayIndex(battleIndex, p);
		local drop = {0,0,0,0,0,1,1,1,1,1,}
		local rand = drop[NLG.Rand(1,10)];
		local dropMenu = {70052,70052,68017};
		if player>=0 and Char.GetData(player, CONST.����_����) == CONST.��������_�� then
			Char.GiveItem(player, dropMenu[NLG.Rand(1,3)], rand);
		end
	end
	end
	Battle.UnsetWinEvent(battleIndex);
end

Char.GetLocation = function(npc,dir)
	local X = Char.GetData(npc,CONST.����_X)--��ͼx
	local Y = Char.GetData(npc,CONST.����_Y)--��ͼy
	if dir==0 then
		Y=Y-1;
	elseif dir==1 then
		X=X+1;
		Y=Y-1;
	elseif dir==2 then
		X=X+1;
	elseif dir==3 then
		X=X+1;
		Y=Y+1;
	elseif dir==4 then
		Y=Y+1;
	elseif dir==5 then
		X=X-1;
		Y=Y+1;
	elseif dir==6 then
		X=X-1;
	elseif dir==7 then
		X=X-1;
		Y=Y-1;
	end
	return X,Y;
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;