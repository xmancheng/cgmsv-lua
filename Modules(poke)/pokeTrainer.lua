---模块类
local Module = ModuleBase:createModule('pokeTrainer')

local PokeTrainer = {
      { palType=1, palNum=1, palName="捕蟲少年", palImage=105002, prestige=1000, gold=500,	--palNum数量(1不更动)、palImage外显形象(不重复)、声望、魔币
         popArea={map=80022,LX=59,LY=75, RX=59,RY=75}, watchArea={map=80022,LX=55,LY=73, RX=61,RY=80},		--出没范围(方形坐标)、监视范围(方形坐标)
         talk="捕蟲少年：讓你看看我抓到的蟲蟲。", },		--开战对话
      { palType=2, palNum=1, palName="養鳥人", palImage=106039, prestige=2000, gold=1000,
         popArea={map=80023,LX=47,LY=63, RX=47,RY=63}, watchArea={map=80023,LX=41,LY=61, RX=49,RY=66},
         talk="養鳥人：往來的旅行者接受我的挑戰吧。", },
      { palType=3, palNum=1, palName="登山男", palImage=106577, prestige=2000, gold=1000,
         popArea={map=80013,LX=38,LY=41, RX=38,RY=41}, watchArea={map=80013,LX=38,LY=35, RX=45,RY=42},
         talk="登山男：嘗嘗我的厲害。", },
      { palType=4, palNum=1, palName="赤紅", palImage=105039, prestige=2500, gold=1500,
         popArea={map=80023,LX=62,LY=84, RX=62,RY=84}, watchArea={map=80023,LX=57,LY=76, RX=66,RY=84},
         talk="赤紅：上吧！我的夥伴們。", },
      { palType=5, palNum=1, palName="青綠", palImage=105139, prestige=2500, gold=1500,
         popArea={map=80023,LX=83,LY=44, RX=83,RY=44}, watchArea={map=80023,LX=77,LY=40, RX=82,RY=48},
         talk="青綠：弱者還敢四處逛。", },
      { palType=6, palNum=1, palName="小藍", palImage=105258, prestige=2500, gold=1500,
         popArea={map=80023,LX=79,LY=67, RX=79,RY=67}, watchArea={map=80023,LX=74,LY=64, RX=77,RY=70},
         talk="小藍：華麗的噴射水柱。", },
      { palType=7, palNum=1, palName="祈祷師", palImage=106310, prestige=2000, gold=1000,
         popArea={map=80014,LX=53,LY=45, RX=53,RY=45}, watchArea={map=80014,LX=39,LY=45, RX=67,RY=54},
         talk="祈祷師：你見過幽靈嗎？你說沒看過！我就讓你看看！", },
      { palType=8, palNum=1, palName="空手道王", palImage=105170, prestige=2000, gold=1000,
         popArea={map=80011,LX=76,LY=72, RX=76,RY=72}, watchArea={map=80011,LX=64,LY=62, RX=77,RY=78},
         talk="空手道王：心靈合一。", },
      { palType=9, palNum=1, palName="遺跡迷", palImage=106008, prestige=2000, gold=1000,
         popArea={map=80019,LX=38,LY=71, RX=61,RY=71}, watchArea={map=80019,LX=38,LY=71, RX=61,RY=74},
         talk="遺跡迷：我愛遺跡，更愛從對戰中得到樂趣。", },
      { palType=10, palNum=1, palName="忍者小子", palImage=106053, prestige=2000, gold=1000,
         popArea={map=80013,LX=38,LY=47, RX=38,RY=47}, watchArea={map=80013,LX=37,LY=46, RX=43,RY=52},
         talk="忍者小子：你被忍者伏擊了。", },
      { palType=11, palNum=1, palName="泳褲小伙子", palImage=105114, prestige=2000, gold=1000,
         popArea={map=80024,LX=84,LY=62, RX=84,RY=62}, watchArea={map=80024,LX=77,LY=56, RX=84,RY=64},
         talk="泳褲小伙子：來場夏日對戰吧。", },
      { palType=12, palNum=1, palName="千金小姐", palImage=105277, prestige=2000, gold=5000,
         popArea={map=80024,LX=61,LY=48, RX=61,RY=48}, watchArea={map=80024,LX=60,LY=48, RX=61,RY=50},
         talk="千金小姐：你會願意輸給我吧。", },
      { palType=13, palNum=1, palName="超能力者", palImage=106283, prestige=2000, gold=1000,
         popArea={map=80017,LX=55,LY=68, RX=55,RY=68}, watchArea={map=80017,LX=48,LY=64, RX=62,RY=70},
         talk="超能力者：我想要操控世界的一切。", },
      { palType=14, palNum=1, palName="吹火人", palImage=105095, prestige=3000, gold=500,
         popArea={map=80016,LX=54,LY=63, RX=54,RY=63}, watchArea={map=80016,LX=51,LY=57, RX=58,RY=60},
         talk="吹火人：停下來觀賞我的表演！", },
      { palType=15, palNum=1, palName="馴龍師", palImage=105052, prestige=2000, gold=1000,
         popArea={map=80018,LX=45,LY=46, RX=45,RY=46}, watchArea={map=80018,LX=41,LY=46, RX=50,RY=58},
         talk="馴龍師：路過的旅行者，來場較量吧！", },
}
------------------------------------------------
local EnemySet = {}
local BaseLevelSet = {}
EnemySet[1] = {416289, 0, 0, 0, 0, 0, 0, 0, 0, 0}	--0代表没有怪
BaseLevelSet[1] = {140, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EnemySet[2] = {416228, 416226, 416226, 0, 0, 0, 0, 0, 0, 0}	--0代表没有怪
BaseLevelSet[2] = {160, 150, 150, 0, 0, 0, 0, 0, 0, 0}
EnemySet[3] = {416280, 0, 0, 0, 0, 0, 416291, 416291, 0, 0}	--0代表没有怪
BaseLevelSet[3] = {160, 0, 0, 0, 0, 0, 150, 150, 0, 0}
EnemySet[4] = {0, 416201, 416202, 0, 0, 0, 416198, 416198, 0, 0}	--0代表没有怪
BaseLevelSet[4] = {0, 170, 170, 0, 0, 0, 160, 160, 0, 0}
EnemySet[5] = {416206, 0, 0, 0, 0, 416205, 416205, 416205, 0, 0}	--0代表没有怪
BaseLevelSet[5] = {170, 0, 0, 0, 0, 160, 160, 160, 0, 0}
EnemySet[6] = {416210, 0, 0, 0, 0, 416208, 0, 0, 416207, 416207}	--0代表没有怪
BaseLevelSet[6] = {170, 0, 0, 0, 0, 160, 0, 0, 150, 150}
EnemySet[7] = {416219, 0, 0, 416218, 416218, 0, 416218, 416218, 0, 0}	--0代表没有怪
BaseLevelSet[7] = {160, 0, 0, 150, 150, 0, 150, 150, 0, 0}
EnemySet[8] = {416334, 0, 0, 0, 0, 416333, 416333, 416333, 416333, 416333}	--0代表没有怪
BaseLevelSet[8] = {160, 0, 0, 0, 0, 150, 150, 150, 150, 150}
EnemySet[9] = {416345, 416344, 416344, 0, 0, 0, 0, 0, 0, 0}	--0代表没有怪
BaseLevelSet[9] = {160, 150, 150, 0, 0, 0, 0, 0, 0, 0}
EnemySet[10] = {416276, 416269, 416269, 0, 0, 0, 0, 0, 416272, 416272}	--0代表没有怪
BaseLevelSet[10] = {160, 150, 150, 0, 0, 0, 0, 0, 150, 150}
EnemySet[11] = {416293, 416245, 416245, 416245, 416245, 0, 0, 0, 0, 0}	--0代表没有怪
BaseLevelSet[11] = {160, 150, 150, 150, 150, 0, 0, 0, 0, 0}
EnemySet[12] = {416336, 416281, 416283, 416338, 416329, 0, 0, 0, 0, 0}	--0代表没有怪
BaseLevelSet[12] = {160, 150, 150, 150, 150, 0, 0, 0, 0, 0}
EnemySet[13] = {416327, 0, 0, 0, 416347, 0, 416350, 0, 0, 0}	--0代表没有怪
BaseLevelSet[13] = {160, 0, 0, 0, 150, 0, 150, 0, 0, 0}
EnemySet[14] = {416238, 0, 0, 0, 416284, 0, 416235, 0, 0, 0}	--0代表没有怪
BaseLevelSet[14] = {160, 0, 0, 0, 150, 0, 150, 0, 0, 0}
EnemySet[15] = {416264, 0, 0, 416282, 416323, 0, 416243, 416340, 0, 0}	--0代表没有怪
BaseLevelSet[15] = {170, 0, 0, 150, 150, 0, 150, 150, 0, 0}
------------------------------------------------
local FTime = os.time();			--时间表
tbl_PokeTrainerNPCIndex = tbl_PokeTrainerNPCIndex or {}
------------------------------------------------
--- 加载模块钩子
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
           Char.SetData(tbl_PokeTrainerNPCIndex[k][i],CONST.对象_移速,250);
           Char.SetData(tbl_PokeTrainerNPCIndex[k][i],CONST.对象_ENEMY_PetFlg+2,0);
           Char.SetLoopEvent('./lua/Modules/pokeTrainer.lua','PokeTrainer_LoopEvent',tbl_PokeTrainerNPCIndex[k][i], 2000);
           self:NPC_regWindowTalkedEvent(tbl_PokeTrainerNPCIndex[k][i], function(npc, player, _seqno, _select, _data)
             local cdk = Char.GetData(player,CONST.对象_CDK);
             local seqno = tonumber(_seqno)
             local select = tonumber(_select)
             local data = tonumber(_data)
             if seqno == 1 then  ----报名对战执行
              if select == 4 then
                NLG.SystemMessage(player,"[訓練家]今天對戰的很過癮，約定好明天再戰！");
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
                  local msg = "\\n\\n\\n\\n@c今天已經對戰過，明天的我會更強。\\n";
                  NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.按钮_是否, 1, msg);

                  local npcImage = Char.GetData(tbl_PokeTrainerNPCIndex[k][i],CONST.对象_形象);
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
-------功能设置
--侦测监控
function PokeTrainer_LoopEvent(npc)
	local CTime = tonumber(os.date("%H",FTime));
	for k,v in pairs(PokeTrainer) do
		local npcImage = Char.GetData(npc,CONST.对象_形象);
		local npcFloorId = Char.GetData(npc,CONST.对象_地图);
		if ( k==v.palType and npcImage==v.palImage and npcFloorId==v.popArea.map ) then
			local player_tbl = Char.GetTempData(npc, '追击对战') or nil;
			pcall(function()
				if player_tbl==nil then		--无锁定开始侦测
					local X = tonumber(Char.GetData(npc,CONST.对象_X));
					local Y = tonumber(Char.GetData(npc,CONST.对象_Y));
					for i=v.watchArea.LX, v.watchArea.RX do
						for j=v.watchArea.LY, v.watchArea.RY do
							local obj_tbl = {};
							local obj_num, obj_tbl = Obj.GetObject(0, v.popArea.map, i, j)
							if #obj_tbl > 0 then
								for m = 1, #obj_tbl do
									local player = Obj.GetCharIndex(obj_tbl[m])
									if Char.GetData(player, CONST.对象_类型) == CONST.对象类型_人 and not Char.IsDummy(player) then
										--print(m,i,j)
										--local EliteCheck = Char.GetExtData(player,'菁英对战') or 0;
										local EliteTrainer={}
										local EliteCheck = Field.Get(player, 'EliteBattle') or "0";
										local EliteCheck_raw = string.split(EliteCheck,",");
										--print(EliteCheck,#EliteCheck_raw)
										if (#EliteCheck_raw == #PokeTrainer) then
											for k,v in ipairs(EliteCheck_raw) do
												table.insert(EliteTrainer,tonumber(v));
											end
										elseif (EliteCheck=="0" or #EliteCheck_raw < #PokeTrainer) then
											local Trainer_string = "";
											for i=1,#PokeTrainer do
												if (i==#PokeTrainer) then
													Trainer_string = Trainer_string .. "32";
												else
													Trainer_string = Trainer_string .. "32,";
												end
											end
											--Char.SetExtData(player,'菁英对战', Trainer_string);
											Field.Set(player, 'EliteBattle', Trainer_string);
											NLG.UpChar(player);
											break
										end
										if ( EliteTrainer[k]~=tonumber(os.date("%d",os.time())) ) then
											Char.SetData(npc,CONST.对象_NPC_HeadGraNo,110402);	--111250
											NLG.UpChar(npc);
											Char.SetTempData(npc, '追击对战', player);
											Char.SetLoopEvent('./lua/Modules/pokeTrainer.lua', 'PokeTrainer_LoopEvent', npc, 600);
											break
										else
											--print("本日已经对战过")
											break
										end
									end
								end
							end
						end
					end
				elseif player_tbl then		--已锁定开始追击
					local player = player_tbl;
					local X = tonumber(Char.GetData(npc,CONST.对象_X));
					local Y = tonumber(Char.GetData(npc,CONST.对象_Y));
					local X1 = tonumber(Char.GetData(player,CONST.对象_X));
					local Y1 = tonumber(Char.GetData(player,CONST.对象_Y));
					local dir,allow = moveDir(X, Y, X1, Y1);
					NLG.SetAction(npc,1);
					NLG.WalkMove(npc,dir);
					NLG.UpChar(npc);
					--print(X, Y, X1, Y1)
					if (X1==nil or Y1==nil) then
						Char.SetTempData(npc, '追击对战', nil);
						Char.SetLoopEvent('./lua/Modules/pokeTrainer.lua', 'PokeTrainer_LoopEvent', npc, 2000);
						return
					end

					if allow then
						local battleIndex = Char.GetBattleIndex(player);
						if battleIndex >= 0 then
							return
						end
						--强迫对战开始
						NLG.SystemMessage(player, v.talk);
						local battleIndex = Battle.PVE( player, player, nil, EnemySet[k], BaseLevelSet[k], nil);
						Battle.SetWinEvent("./lua/Modules/pokeTrainer.lua", "PokeTrainerNPC_BattleWin", battleIndex);
						pal_clear(player, npc, v.palType);
						Char.SetTempData(npc, '追击对战', nil);
						Char.SetLoopEvent('./lua/Modules/pokeTrainer.lua', 'PokeTrainer_LoopEvent', npc, 3000);
					else
						if ( X1>v.watchArea.RX or Y1>v.watchArea.RY) then		--逃离右侧范围
							pal_clear(player, npc, v.palType);
							Char.SetTempData(npc, '追击对战', nil);
							Char.SetLoopEvent('./lua/Modules/pokeTrainer.lua', 'PokeTrainer_LoopEvent', npc, 2000);
						elseif ( X1<v.watchArea.LX or Y1<v.watchArea.LY) then	--逃离左侧范围
							pal_clear(player, npc, v.palType);
							Char.SetTempData(npc, '追击对战', nil);
							Char.SetLoopEvent('./lua/Modules/pokeTrainer.lua', 'PokeTrainer_LoopEvent', npc, 2000);
						end
					end
				end
			end)
		end
	end
end


function pal_clear(player, npc, Type)
	--随机转移至起始监视位置
	for k,v in pairs(PokeTrainer) do
		if ( k==Type) then
			local palX = NLG.Rand(v.popArea.LX, v.popArea.RX);
			local palY = NLG.Rand(v.popArea.LY, v.popArea.RY);
			Char.SetData(npc,CONST.对象_X, palX);
			Char.SetData(npc,CONST.对象_Y, palY);
			Char.SetData(npc,CONST.对象_NPC_HeadGraNo,0);
			NLG.SetAction(npc,0);
			NLG.UpChar(npc);
		end
	end
end

function PokeTrainerNPC_BattleWin(battleIndex, charIndex)
	local leader1 = Battle.GetPlayer(battleIndex,0)
	local leader2 = Battle.GetPlayer(battleIndex,5)
	local leader = leader1
	if Char.GetData(leader2, CONST.CHAR_类型) == CONST.对象类型_人 then
		leader = leader2
	end

	--分配奖励
	for p=0,9 do
		local player = Battle.GetPlayIndex(battleIndex, p);
		if player>=0 and Char.GetData(player, CONST.对象_类型) == CONST.对象类型_人 then
			for k,v in pairs(PokeTrainer) do
				local charFloorId = Char.GetData(player,CONST.对象_地图);
				local X = Char.GetData(player,CONST.对象_X);
				local Y = Char.GetData(player,CONST.对象_Y);
				--print(charFloorId,X,Y)
				if ( k==v.palType and charFloorId==v.popArea.map and X>=v.watchArea.LX and X<=v.watchArea.RX and Y>=v.watchArea.LY and Y<=v.watchArea.RY ) then
					local fame = Char.GetData(player,CONST.对象_声望);
					Char.SetData(player,CONST.对象_声望, fame+v.prestige);
					Char.AddGold(player, v.gold);
					NLG.SystemMessage(player,"[系統]目前聲望:"..fame.."，勝利得到額外聲望"..v.prestige.."！");
					NLG.SystemMessage(player,"[系統]勝利時也從對手那得到魔幣"..v.gold.."！");

					--local EliteCheck = Char.GetExtData(player,'菁英对战');
					local EliteTrainer={}
					local EliteCheck = Field.Get(player, 'EliteBattle');
					local EliteCheck_raw = string.split(EliteCheck,",");
					for r,t in ipairs(EliteCheck_raw) do
						if (k==r) then
							table.insert(EliteTrainer,tonumber(os.date("%d",os.time())));
						else
							table.insert(EliteTrainer,tonumber(t));
						end
					end
					--表格转字串
					local Trainer_string = "";
					for r,t in ipairs(EliteTrainer) do
						if (r==#EliteTrainer) then
							Trainer_string = Trainer_string .. t;
						else
							Trainer_string = Trainer_string .. t .. ",";
						end
					end
					--print(Trainer_string)
					--Char.SetExtData(player,'菁英对战', Trainer_string);
					Field.Set(player, 'EliteBattle', Trainer_string);
					NLG.UpChar(player);
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
	local X = Char.GetData(npc,CONST.对象_X)--地图x
	local Y = Char.GetData(npc,CONST.对象_Y)--地图y
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

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
