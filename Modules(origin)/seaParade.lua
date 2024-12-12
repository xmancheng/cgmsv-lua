---ģ����
local Module = ModuleBase:createModule('seaParade')

local PalEnemy = {
      { palType=1, palNum=2, enMode=1, palName="С���~", palImage=108136, popArea={map=32744,LX=147,LY=46, RX=213,RY=100},	--palNum����������palImage��������(���ظ�)����û��Χ(��������)
         encount=0, prizeItem_id={50005}, prizeItem_count={1} },						--encount���л��ʡ�prizeItem�������(���ظ����飬��߸���ϻ���)
      { palType=2, palNum=2, enMode=1, palName="С���~", palImage=108137, popArea={map=32744,LX=147,LY=46, RX=213,RY=100},
         encount=0, prizeItem_id={50006}, prizeItem_count={1} },
      { palType=3, palNum=2, enMode=1, palName="С���~", palImage=108138, popArea={map=32744,LX=147,LY=46, RX=213,RY=100},
         encount=0, prizeItem_id={50001}, prizeItem_count={1} },
      { palType=4, palNum=2, enMode=1, palName="С���~", palImage=108139, popArea={map=32744,LX=147,LY=46, RX=213,RY=100},
         encount=0, prizeItem_id={50002}, prizeItem_count={1} },
      { palType=5, palNum=1, enMode=1, palName="С���~����", palImage=108141, popArea={map=32744,LX=147,LY=46, RX=213,RY=100},
         encount=0, prizeItem_id={50003}, prizeItem_count={2} },

      { palType=6, palNum=2, enMode=1, palName="ˮĸ", palImage=108123, popArea={map=32744,LX=116,LY=167, RX=162,RY=213},
         encount=0, prizeItem_id={49002}, prizeItem_count={1} },
      { palType=7, palNum=2, enMode=1, palName="ˮĸ", palImage=108124, popArea={map=32744,LX=116,LY=167, RX=162,RY=213},
         encount=0, prizeItem_id={50017}, prizeItem_count={1} },
      { palType=8, palNum=2, enMode=1, palName="ˮĸ", palImage=108125, popArea={map=32744,LX=116,LY=167, RX=162,RY=213},
         encount=0, prizeItem_id={50001}, prizeItem_count={1} },
      { palType=9, palNum=2, enMode=1, palName="ˮĸ", palImage=108126, popArea={map=32744,LX=116,LY=167, RX=162,RY=213},
         encount=0, prizeItem_id={50011}, prizeItem_count={1} },
      { palType=10, palNum=1, enMode=1, palName="ˮĸ����", palImage=108127, popArea={map=32744,LX=116,LY=167, RX=162,RY=213},
         encount=0, prizeItem_id={50004}, prizeItem_count={2} },

      { palType=11, palNum=2, enMode=1, palName="���~", palImage=108117, popArea={map=32744,LX=34,LY=96, RX=133,RY=160},
         encount=0, prizeItem_id={50014}, prizeItem_count={1} },
      { palType=12, palNum=2, enMode=1, palName="���~", palImage=108118, popArea={map=32744,LX=34,LY=96, RX=133,RY=160},
         encount=0, prizeItem_id={50016}, prizeItem_count={1} },
      { palType=13, palNum=2, enMode=1, palName="���~", palImage=108119, popArea={map=32744,LX=34,LY=96, RX=133,RY=160},
         encount=0, prizeItem_id={50018}, prizeItem_count={1} },
      { palType=14, palNum=2, enMode=1, palName="���~", palImage=108120, popArea={map=32744,LX=34,LY=96, RX=133,RY=160},
         encount=0, prizeItem_id={50013}, prizeItem_count={1} },
      { palType=15, palNum=1, enMode=1, palName="���~����", palImage=108121, popArea={map=32744,LX=34,LY=96, RX=133,RY=160},
         encount=0, prizeItem_id={50015}, prizeItem_count={2} },

      { palType=16, palNum=2, enMode=1, palName="���r", palImage=108111, popArea={map=32744,LX=42,LY=174, RX=115,RY=217},
         encount=0, prizeItem_id={50010}, prizeItem_count={1} },
      { palType=17, palNum=2, enMode=1, palName="���r", palImage=108112, popArea={map=32744,LX=42,LY=174, RX=115,RY=217},
         encount=0, prizeItem_id={50008}, prizeItem_count={1} },
      { palType=18, palNum=2, enMode=1, palName="���r", palImage=108113, popArea={map=32744,LX=42,LY=174, RX=115,RY=217},
         encount=0, prizeItem_id={50007}, prizeItem_count={1} },
      { palType=19, palNum=2, enMode=1, palName="���r", palImage=108114, popArea={map=32744,LX=42,LY=174, RX=115,RY=217},
         encount=0, prizeItem_id={50009}, prizeItem_count={1} },
      { palType=20, palNum=1, enMode=1, palName="���r����", palImage=108116, popArea={map=32744,LX=42,LY=174, RX=115,RY=217},
         encount=0, prizeItem_id={50012}, prizeItem_count={2} },

}
------------------------------------------------
local EnemySet = {}
local BaseLevelSet = {}
EnemySet[1] = {600101, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0����û�й�
BaseLevelSet[1] = {2, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[2] = {600102, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0����û�й�
BaseLevelSet[2] = {2, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[3] = {600103, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0����û�й�
BaseLevelSet[3] = {2, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[4] = {600104, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0����û�й�
BaseLevelSet[4] = {2, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[5] = {600074, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0����û�й�
BaseLevelSet[5] = {50, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[6] = {600075, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0����û�й�
BaseLevelSet[6] = {50, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[7] = {600076, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0����û�й�
BaseLevelSet[7] = {50, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[8] = {600077, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0����û�й�
BaseLevelSet[8] = {50, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[9] = {600078, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0����û�й�
BaseLevelSet[9] = {30, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[10] = {600079, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0����û�й�
BaseLevelSet[10] = {30, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[11] = {600080, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0����û�й�
BaseLevelSet[11] = {50, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[12] = {600081, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0����û�й�
BaseLevelSet[12] = {50, 0, 0, 0, 0, 0, 0, 0, 0, 0}
------------------------------------------------
local FTime = os.time();			--ʱ���
tbl_PalEnemyNPCIndex = tbl_PalEnemyNPCIndex or {}
------------------------------------------------
--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('LoopEvent', Func.bind(self.PalEnemy_LoopEvent,self))
  for k,v in pairs(PalEnemy) do
    if (tbl_PalEnemyNPCIndex[k] == nil) then
        tbl_PalEnemyNPCIndex[k] = {}
    end
    for i=1, v.palNum do
       if (tbl_PalEnemyNPCIndex[k][i] == nil) then
           local palX = NLG.Rand(v.popArea.LX, v.popArea.RX);
           local palY = NLG.Rand(v.popArea.LY, v.popArea.RY);
           local PalEnemyNPC = self:NPC_createNormal(v.palName, v.palImage, { map = v.popArea.map, x = palX, y = palY, direction = 5, mapType = 0 })
           tbl_PalEnemyNPCIndex[k][i] = PalEnemyNPC
           Char.SetLoopEvent('./lua/Modules/seaParade.lua','PalEnemy_LoopEvent',tbl_PalEnemyNPCIndex[k][i], 1000);
           self:regCallback('CharActionEvent', function(player, actionID)
             local Target_FloorId = Char.GetData(player,CONST.CHAR_��ͼ);
             if (actionID == CONST.����_���� and Target_FloorId==32744 and v.enMode==1) then
                  local playerLv = Char.GetData(player,CONST.CHAR_�ȼ�);
                  if (playerLv<=100) then
                      NLG.SystemMessage(player,"[ϵ�y]�ȼ��Ҫ100���ϡ�");
                      return;
                  end
                  local npcImage = Char.GetData(tbl_PalEnemyNPCIndex[k][i],CONST.����_����);
                  local npc = tbl_PalEnemyNPCIndex[k][i];
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
                                local Target_FloorId = Char.GetData(player,CONST.CHAR_��ͼ)--��ͼ���
                                local Target_X = Char.GetData(player,CONST.CHAR_X)--��ͼx
                                local Target_Y = Char.GetData(player,CONST.CHAR_Y)--��ͼy
                                Char.Warp(player,Target_MapId,Target_FloorId,Target_X,Target_Y);
                                NLG.UpChar(player);
                            end
                        end
                     end
                  end
             elseif (v.enMode==0) then
                      return;
             else
             end
           end)
           self:NPC_regWindowTalkedEvent(tbl_PalEnemyNPCIndex[k][i], function(npc, player, _seqno, _select, _data)
	local cdk = Char.GetData(player,CONST.����_CDK);
	local seqno = tonumber(_seqno)
	local select = tonumber(_select)
	local data = tonumber(_data)
           end)
           self:NPC_regTalkedEvent(tbl_PalEnemyNPCIndex[k][i], function(npc, player)
             if(NLG.CheckInFront(player, npc, 1)==false) then
                 return ;
             end
             if (v.enMode==1 and NLG.CanTalk(npc, player) == true) then
                 NLG.SystemMessage(player,"[ϵ�y]Ոʹ�ù������ץ����");
                 return ;
             elseif (v.enMode==0 and NLG.CanTalk(npc, player) == true) then
                  local playerLv = Char.GetData(player,CONST.CHAR_�ȼ�);
                  if (playerLv<=100) then
                      NLG.SystemMessage(player,"[ϵ�y]�ȼ��Ҫ100���ϡ�");
                      return;
                  end
                  local npcImage = Char.GetData(tbl_PalEnemyNPCIndex[k][i],CONST.����_����);
                  local npc = tbl_PalEnemyNPCIndex[k][i];
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
                                local Target_FloorId = Char.GetData(player,CONST.CHAR_��ͼ)--��ͼ���
                                local Target_X = Char.GetData(player,CONST.CHAR_X)--��ͼx
                                local Target_Y = Char.GetData(player,CONST.CHAR_Y)--��ͼy
                                Char.Warp(player,Target_MapId,Target_FloorId,Target_X,Target_Y);
                                NLG.UpChar(player);
                            end
                        end
                     end
                  end

             end
             return
           end)
       end
    end
  end


end
------------------------------------------------
-------��������
--ת��
function PalEnemy_LoopEvent(npc)
	local CTime = tonumber(os.date("%H",FTime));
	if ( os.date("%M",os.time())=="15") or (os.date("%M",os.time())=="30") or (os.date("%M",os.time())=="45") or (os.date("%M",os.time())=="00") then
		if ( os.date("%S",os.time())=="00") or (os.date("%S",os.time())=="01") or (os.date("%S",os.time())=="02") then
		for k,v in pairs(PalEnemy) do
			local npcImage = Char.GetData(npc,CONST.����_����);
			if ( k==v.palType and npcImage==v.palImage ) then
				local palX = NLG.Rand(v.popArea.LX, v.popArea.RX);
				local palY = NLG.Rand(v.popArea.LY, v.popArea.RY);
				Char.SetData(npc,CONST.����_X, palX);
				Char.SetData(npc,CONST.����_Y, palY);
				Char.SetData(npc,CONST.����_��ͼ, v.popArea.map);
				NLG.UpChar(npc);
			end
		end
		end
	elseif (os.date("%X",os.time())=="23:59:59") or (os.date("%X",os.time())=="11:59:59") or (os.date("%X",os.time())=="12:59:59") or (os.date("%X",os.time())=="16:59:59") or (os.date("%X",os.time())=="17:59:59") or (os.date("%X",os.time())=="19:59:59") or (os.date("%X",os.time())=="20:59:59") or (os.date("%X",os.time())=="21:59:59") then
		for k,v in pairs(PalEnemy) do
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
	if (Char.GetData(npc,CONST.����_��ͼ)==32744 and excess>=7) then
		local dir = math.random(0, 7);
		local walk = 1;
		local X,Y = Char.GetLocation(npc,dir);
		if (NLG.Walkable(0, 32744, X, Y)==1) then
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

Char.GetLocation = function(npc,dir)
	local X = Char.GetData(npc,CONST.CHAR_X)--��ͼx
	local Y = Char.GetData(npc,CONST.CHAR_Y)--��ͼy
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