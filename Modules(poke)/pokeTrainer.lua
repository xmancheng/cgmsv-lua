---ģ����
local Module = ModuleBase:createModule('pokeTrainer')

local PokeTrainer = {
      { palType=1, palNum=1, palName="���x����", palImage=105002, prestige=5000, gold=2000,	--palNum����(1������)��palImage��������(���ظ�)��������ħ��
         popArea={map=80022,LX=56,LY=74, RX=59,RY=78}, watchArea={map=80022,LX=55,LY=73, RX=61,RY=80},		--��û��Χ(��������)�����ӷ�Χ(��������)
         talk="���x���꣺׌�㿴����ץ�����x�x��", },		--��ս�Ի�
}
------------------------------------------------
local EnemySet = {}
local BaseLevelSet = {}
EnemySet[1] = {426392, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0����û�й�
BaseLevelSet[1] = {20, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[2] = {426360, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0����û�й�
BaseLevelSet[2] = {30, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[3] = {426361, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0����û�й�
BaseLevelSet[3] = {40, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[4] = {426434, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0����û�й�
BaseLevelSet[4] = {40, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[5] = {426376, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0����û�й�
BaseLevelSet[5] = {50, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[6] = {426386, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0����û�й�
BaseLevelSet[6] = {50, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[7] = {426380, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0����û�й�
BaseLevelSet[7] = {50, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[8] = {426430, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0����û�й�
BaseLevelSet[8] = {70, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[9] = {426448, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0����û�й�
BaseLevelSet[9] = {80, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[10] = {426450, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0����û�й�
BaseLevelSet[10] = {80, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[11] = {426459, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0����û�й�
BaseLevelSet[11] = {100, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[12] = {416402, 0, 0, 0, 0, 416398, 416398, 416398, 416398, 416398}	--0����û�й�
BaseLevelSet[12] = {150, 0, 0, 0, 0, 120, 120, 120, 120, 120}
EnemySet[13] = {416403, 0, 0, 0, 0, 416399, 416399, 416399, 416399, 416399}	--0����û�й�
BaseLevelSet[13] = {150, 0, 0, 0, 0, 120, 120, 120, 120, 120}
EnemySet[14] = {416356, 0, 0, 416426, 416426, 0, 416427, 416427, 0, 0}	--0����û�й�
BaseLevelSet[14] = {150, 0, 0, 130, 130, 0, 130, 130, 0, 0}
------------------------------------------------
local FTime = os.time();			--ʱ���
tbl_PokeTrainerNPCIndex = tbl_PokeTrainerNPCIndex or {}
------------------------------------------------
--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('LoopEvent', Func.bind(self.PokeTrainer_LoopEvent,self))
  self:regCallback('LoopEvent', Func.bind(self.moveTrainer_LoopEvent,self))
  for k,v in pairs(PokeTrainer) do
    if (tbl_PokeTrainerNPCIndex[k] == nil) then
        tbl_PokeTrainerNPCIndex[k] = {}
    end
    for i=1, v.palNum do
       if (tbl_PokeTrainerNPCIndex[k][i] == nil) then
           local palX = NLG.Rand(v.popArea.LX, v.popArea.RX);
           local palY = NLG.Rand(v.popArea.LY, v.popArea.RY);
           local PokeTrainerNPC = self:NPC_createNormal(v.palName, v.palImage, { map = v.popArea.map, x = palX, y = palY, direction = 5, mapType = 0 })
           tbl_PokeTrainerNPCIndex[k][i] = PokeTrainerNPC
           Char.SetData(tbl_PokeTrainerNPCIndex[k][i],CONST.����_����,250);
           Char.SetData(tbl_PokeTrainerNPCIndex[k][i],CONST.����_ENEMY_PetFlg+2,0);
           Char.SetLoopEvent('./lua/Modules/pokeTrainer.lua','PokeTrainer_LoopEvent',tbl_PokeTrainerNPCIndex[k][i], 2000);
           self:NPC_regWindowTalkedEvent(tbl_PokeTrainerNPCIndex[k][i], function(npc, player, _seqno, _select, _data)
             local cdk = Char.GetData(player,CONST.����_CDK);
             local seqno = tonumber(_seqno)
             local select = tonumber(_select)
             local data = tonumber(_data)
             if seqno == 1 then  ----������սִ��
              if select == 4 then
                NLG.SystemMessage(player,"[Ӗ����]���쌦��ĺ��^�a���s���������ّ�");
              else
                return 0;
              end
             end

           end)
           self:NPC_regTalkedEvent(tbl_PokeTrainerNPCIndex[k][i], function(npc, player)
             if(NLG.CheckInFront(player, npc, 1)==false) then
                 return;
             end
             if (NLG.CanTalk(npc, player) == true) then
                  local msg = "\\n\\n\\n\\n@c�����ѽ������^��������ҕ�������\\n";
                  NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 1, msg);

                  local npcImage = Char.GetData(tbl_PokeTrainerNPCIndex[k][i],CONST.����_����);
                  local npc = tbl_PokeTrainerNPCIndex[k][i];
                  --if ( k==v.palType and npcImage==v.palImage) then
                  --   local battleIndex = Battle.PVE( player, player, nil, EnemySet[k], BaseLevelSet[k], nil);
                  --   Battle.SetWinEvent("./lua/Modules/pokeTrainer.lua", "paradeLordNPC_BattleWin", battleIndex);
                  --end
             end
             return
           end)
       end
    end
  end


end
------------------------------------------------
-------��������
--�����
function PokeTrainer_LoopEvent(npc)
	local CTime = tonumber(os.date("%H",FTime));
	for k,v in pairs(PokeTrainer) do
		local npcImage = Char.GetData(npc,CONST.����_����);
		local npcFloorId = Char.GetData(npc,CONST.����_��ͼ);
		if ( k==v.palType and npcImage==v.palImage and npcFloorId==v.popArea.map ) then
			local player_tbl = Char.GetTempData(npc, '׷����ս') or nil;
			pcall(function()
				if player_tbl==nil then		--��������ʼ���
					local X = tonumber(Char.GetData(npc,CONST.����_X));
					local Y = tonumber(Char.GetData(npc,CONST.����_Y));
					for i=v.watchArea.LX, v.watchArea.RX do
						for j=v.watchArea.LY, v.watchArea.RY do
							local obj_tbl = {};
							local obj_num, obj_tbl = Obj.GetObject(0, v.popArea.map, i, j)
							if #obj_tbl > 0 then
								for m = 1, #obj_tbl do
									local player = Obj.GetCharIndex(obj_tbl[m])
									if Char.GetData(player, CONST.����_����) == CONST.��������_�� and not Char.IsDummy(player) then
										--print(m,i,j)
										Char.SetTempData(npc, '׷����ս', player);
										Char.SetLoopEvent('./lua/Modules/pokeTrainer.lua', 'PokeTrainer_LoopEvent', npc, 600);
										break
									end
								end
							end
						end
					end
				elseif player_tbl then		--��������ʼ׷��
					local player = player_tbl;
					local X = tonumber(Char.GetData(npc,CONST.����_X));
					local Y = tonumber(Char.GetData(npc,CONST.����_Y));
					local X1 = tonumber(Char.GetData(player,CONST.����_X));
					local Y1 = tonumber(Char.GetData(player,CONST.����_Y));
					local dir,allow = moveDir(X, Y, X1, Y1);
					NLG.SetAction(npc,1);
					NLG.WalkMove(npc,dir);
					NLG.UpChar(npc);
					--print(X, Y, X1, Y1)
					if (X1==nil or Y1==nil) then
						Char.SetTempData(npc, '׷����ս', nil);
						Char.SetLoopEvent('./lua/Modules/pokeTrainer.lua', 'PokeTrainer_LoopEvent', npc, 2000);
						return
					end

					if allow then
						local battleIndex = Char.GetBattleIndex(player);
						if battleIndex >= 0 then
							return
						end
						--ǿ�ȶ�ս��ʼ
						NLG.SystemMessage(player, v.talk);
						local battleIndex = Battle.PVE( player, player, nil, EnemySet[k], BaseLevelSet[k], nil);
						Battle.SetWinEvent("./lua/Modules/pokeTrainer.lua", "PokeTrainerNPC_BattleWin", battleIndex);
						pal_clear(player, npc, v.palType);
						Char.SetLoopEvent('./lua/Modules/pokeTrainer.lua', 'PokeTrainer_LoopEvent', npc, 2000);
					else
						if ( X1>v.watchArea.RX or Y1>v.watchArea.RY) then		--�����Ҳ෶Χ
							pal_clear(player, npc, v.palType);
							Char.SetTempData(npc, '׷����ս', nil);
							Char.SetLoopEvent('./lua/Modules/pokeTrainer.lua', 'PokeTrainer_LoopEvent', npc, 2000);
						elseif ( X1<v.watchArea.LX or Y1<v.watchArea.LY) then	--������෶Χ
							pal_clear(player, npc, v.palType);
							Char.SetTempData(npc, '׷����ս', nil);
							Char.SetLoopEvent('./lua/Modules/pokeTrainer.lua', 'PokeTrainer_LoopEvent', npc, 2000);
						end
					end
				end
			end)
		end
	end
end


function pal_clear(player, npc, Type)
	--���ת������ʼ����λ��
	for k,v in pairs(PokeTrainer) do
		if ( k==Type) then
			local palX = NLG.Rand(v.popArea.LX, v.popArea.RX);
			local palY = NLG.Rand(v.popArea.LY, v.popArea.RY);
			Char.SetData(npc,CONST.����_X, palX);
			Char.SetData(npc,CONST.����_Y, palY);
			NLG.SetAction(npc,0);
			NLG.UpChar(npc);
		end
	end
end

function PokeTrainerNPC_BattleWin(battleIndex, charIndex)
	local leader1 = Battle.GetPlayer(battleIndex,0)
	local leader2 = Battle.GetPlayer(battleIndex,5)
	local leader = leader1
	if Char.GetData(leader2, CONST.CHAR_����) == CONST.��������_�� then
		leader = leader2
	end

	--���佱��
	for p=0,9 do
		local player = Battle.GetPlayIndex(battleIndex, p);
		if player>=0 and Char.GetData(player, CONST.����_����) == CONST.��������_�� then
			for k,v in pairs(PokeTrainer) do
				local charFloorId = Char.GetData(player,CONST.����_��ͼ);
				local X = Char.GetData(player,CONST.����_X);
				local Y = Char.GetData(player,CONST.����_Y);
				print(charFloorId,X,Y)
				if ( k==v.palType and charFloorId==v.popArea.map and X>=v.watchArea.LX and X<=v.watchArea.RX and Y>=v.watchArea.LY and Y<=v.watchArea.RY ) then
					local fame = Char.GetData(player,CONST.����_����);
					Char.SetData(player,CONST.����_����, fame+v.prestige);
					Char.AddGold(player, v.gold);
					NLG.SystemMessage(player,"[ϵ�y]Ŀǰ��:"..fame.."�������õ��~����"..v.prestige.."��");
					NLG.SystemMessage(player,"[ϵ�y]�����rҲ�Č����ǵõ�ħ��"..v.gold.."��");
				end
			end
		end
	end
	Battle.UnsetWinEvent(battleIndex);
end

function moveDir(X, Y, X1, Y1)
	if not X or not Y or not X1 or not Y1 then
		return
	end
	local dir = 8
	if X1 > X then
		if Y1 > Y then
			dir = 3
		elseif Y1 < Y then
			dir = 1
		else
			dir = 2
		end
	elseif X1 < X then
		if Y1 > Y then
			dir = 5
		elseif Y1 < Y then
			dir = 7
		else
			dir = 6
		end
	else
		if Y1 > Y then
			dir = 4
		elseif Y1 < Y then
			dir = 0
		end
	end
	local allow = false
	if math.abs(X-X1) < 1 and math.abs(Y-Y1) < 1 then
		allow = true
	end
	return dir, allow
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