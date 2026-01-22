local QuickUI = ModuleBase:createModule('quickUI')

local PartyMember={}

local Terra_itemId = 70196;	--地精灵
local Agni_itemId = 70198;	--火精灵
local Aqua_itemId = 70197;	--水精灵
local Ventus_itemId = 70199;	--风精灵
local WingSpeed_List = {110,120,130,140,160,180,200,220,250,300};
local WingKind_List = {};
WingKind_List[70196]={119012,119012,119012,119012,119012,119012,119012,119012,119012,119016};
WingKind_List[70198]={119014,119014,119014,119014,119014,119014,119014,119014,119014,119016};
WingKind_List[70197]={119013,119013,119013,119013,119013,119013,119013,119013,119013,119016};
WingKind_List[70199]={119015,119015,119015,119015,119015,119015,119015,119015,119015,119016};

----------------------------------------------------------------------------
function QuickUI:shortcut(player, actionID)
  if actionID == CONST.动作_剪刀 then
    self:petinfo(player);
  end
end

function QuickUI:walkingspeed(npc, player)
      --local msg = "\\n@c【移動加速】完成任務逐步提升至最高走路速度！\\n\\n1.王宮召喚士蓋茲[死者戒指]【150】\\n\\n2.女神卡連[六曜之塔]【200】\\n\\n3.受傷的女人[森羅萬象]【250】\\n\\n4.賽格梅特之魂[失翼之龍]【300】\\n";
      --local msg = "\\n@c【移動加速】收集四魂之玉強化你的精靈之魂！\\n\\n精靈之魂Lv1【110】　　精靈之魂Lv6【180】\\n　　　　Lv2【120】　　　　　　Lv7【200】\\n　　　　Lv3【130】　　　　　　Lv8【220】\\n　　　　Lv4【140】　　　　　　Lv9【250】\\n　　　　Lv5【160】　　　　　　Lv10【300】\\n";
      local msg = "\\n　【移動加速】收集四魂之玉強化你的精靈之魂！\\n\\n　Lv1【110】　　Lv6【180】　　↓坐騎形象↓\\n　Lv2【120】　　Lv7【200】\\n　Lv3【130】　　Lv8【220】\\n　Lv4【140】　　Lv9【250】\\n　Lv5【160】　　Lv10【300】\\n";
      if (Char.ItemNum(player, Agni_itemId)==0 and Char.ItemNum(player, Aqua_itemId)==1 and Char.ItemNum(player, Ventus_itemId)==0 and Char.ItemNum(player, Terra_itemId)==0) then
          local itemIndex = Char.HaveItem(player, Aqua_itemId);
          local sitting_image= Item.GetData(itemIndex,CONST.道具_幸运);
          local imageText = "@g,"..sitting_image..",15,7,6,0@"
          msg = imageText .. msg;
      elseif (Char.ItemNum(player, Agni_itemId)==1 and Char.ItemNum(player, Aqua_itemId)==0 and Char.ItemNum(player, Ventus_itemId)==0 and Char.ItemNum(player, Terra_itemId)==0) then
          local itemIndex = Char.HaveItem(player, Agni_itemId);
          local sitting_image= Item.GetData(itemIndex,CONST.道具_幸运);
          local imageText = "@g,"..sitting_image..",15,7,6,0@"
          msg = imageText .. msg;
      elseif (Char.ItemNum(player, Agni_itemId)==0 and Char.ItemNum(player, Aqua_itemId)==0 and Char.ItemNum(player, Ventus_itemId)==1 and Char.ItemNum(player, Terra_itemId)==0) then
          local itemIndex = Char.HaveItem(player, Ventus_itemId);
          local sitting_image= Item.GetData(itemIndex,CONST.道具_幸运);
          local imageText = "@g,"..sitting_image..",15,7,6,0@"
          msg = imageText .. msg;
      elseif (Char.ItemNum(player, Agni_itemId)==0 and Char.ItemNum(player, Aqua_itemId)==0 and Char.ItemNum(player, Ventus_itemId)==0 and Char.ItemNum(player, Terra_itemId)==1) then
          local itemIndex = Char.HaveItem(player, Terra_itemId);
          local sitting_image= Item.GetData(itemIndex,CONST.道具_幸运);
          local imageText = "@g,"..sitting_image..",15,7,6,0@"
          msg = imageText .. msg;
      else
          msg = msg;
      end
      NLG.ShowWindowTalked(player, self.speedNpc, CONST.窗口_信息框, CONST.按钮_确定关闭, 1, msg);
end

function QuickUI:teamfever(npc, player)
      local msg = "\\n\\n@c【一鍵全隊打卡】\\n\\n非打卡狀態→打卡狀態\\n\\n打卡狀態→非打卡狀態\\n\\n[確定]幫全隊進行打卡|全隊的打卡結束\\n";
      NLG.ShowWindowTalked(player, self.feverNpc, CONST.窗口_信息框, CONST.按钮_确定关闭, 2, msg);
end

function QuickUI:teamheal(npc, player)
      local msg = "\\n\\n@c回復魔法值（+等量生命值）\\n\\n回復生命值\\n\\n回復寵物的生命值和魔法值\\n\\n一鍵回復全隊人物和寵物魔法、生命\\n";
      NLG.ShowWindowTalked(player, self.healNpc, CONST.窗口_信息框, CONST.按钮_确定关闭, 3, msg);
end

function QuickUI:gather(player)
      local playerMapType = Char.GetData(player, CONST.对象_地图类型);
      local playerMap = Char.GetData(player, CONST.对象_地图);
      local playerX = Char.GetData(player, CONST.对象_X);
      local playerY = Char.GetData(player, CONST.对象_Y);
      if Char.PartyNum(player)>0 and player==Char.GetPartyMember(player,0) then
            for slot = 1,4 do
                local p = Char.GetPartyMember(player,slot)
                if(p>=0) then
                      Char.Warp(p, playerMapType, playerMap, playerX, playerY);
                end
            end
      else
            NLG.SystemMessage(player, '隊長才可使用！');
      end
end

function QuickUI:partyenter(player)
      local cdk = Char.GetData(player,CONST.对象_CDK);
      local playerMapType = Char.GetData(player, CONST.对象_地图类型);
      local playerMap = Char.GetData(player, CONST.对象_地图);
      local playerX = Char.GetData(player, CONST.对象_X);
      local playerY = Char.GetData(player, CONST.对象_Y);
      if Char.PartyNum(player)>0 and player==Char.GetPartyMember(player,0) then
             PartyMember[cdk] = {}
             for partySlot = 0,4 do 
                    local targetcharIndex = Char.GetPartyMember(player,partySlot);
                    if targetcharIndex >= 0  then
                          table.insert(PartyMember[cdk], partySlot+1, targetcharIndex);
                    else
                          table.insert(PartyMember[cdk], partySlot+1, -1);
                    end
             end
             table.insert(PartyMember[cdk],cdk);
             NLG.SystemMessage(player, '隊伍成員紀錄完畢！');
      else
            NLG.SystemMessage(player, '隊長才可使用！');
      end
end

function QuickUI:partyform(player)
      local cdk = Char.GetData(player,CONST.对象_CDK);
      local playerMapType = Char.GetData(player, CONST.对象_地图类型);
      local playerMap = Char.GetData(player, CONST.对象_地图);
      local playerX = Char.GetData(player, CONST.对象_X);
      local playerY = Char.GetData(player, CONST.对象_Y);
      if PartyMember[cdk] ~= nill and cdk == PartyMember[cdk][6] then
            if Char.PartyNum(player) == -1 then
                  for i,v in ipairs(PartyMember[cdk]) do
                        local memberMap = Char.GetData(v, CONST.对象_地图);
                        local memberX = Char.GetData(v, CONST.对象_X);
                        local memberY = Char.GetData(v, CONST.对象_Y);
                        if i<=5 and v>-1 and v~=player and memberMap == playerMap then
                              if memberX >= playerX-5 and memberX <= playerX+5 and memberY>= playerY-5 and memberY<= playerY+5 then
                                    Char.Warp(v, playerMapType, playerMap, playerX, playerY);
                                    Char.JoinParty(v, player);
                              else
                                    NLG.SystemMessage(player, '有隊員距離過遠入隊失敗！');
                              end
                        end
                  end
            end
      else
            NLG.SystemMessage(player, '請先記錄或覆寫隊伍成員！');
      end
end

function QuickUI:petinfo(player)
      for petSlot = 0,4 do
            local petIndex = Char.GetPet(player, petSlot);
            local petname = Char.GetData(petIndex, CONST.对象_名字);
            local arr_rank1 = Pet.GetArtRank(petIndex,CONST.PET_体成);
            local arr_rank2 = Pet.GetArtRank(petIndex,CONST.PET_力成);
            local arr_rank3 = Pet.GetArtRank(petIndex,CONST.PET_强成);
            local arr_rank4 = Pet.GetArtRank(petIndex,CONST.PET_敏成);
            local arr_rank5 = Pet.GetArtRank(petIndex,CONST.PET_魔成);
            local a6, a1, a2, a3, a4, a5 = Char.GetPetRank(player,petSlot);
            local TrueName = Char.GetData(petIndex,CONST.对象_原名);
            --local last = string.find(TrueName, "異種", 1) or nil;
            local last = nil;
            local a61 = arr_rank1+arr_rank2+arr_rank3+arr_rank4+arr_rank5;
            if last~=nil then
                  NLG.SystemMessage(player, '---------------------------------------');
                  NLG.SystemMessage(player, ''..TrueName..'：總共是《'..a61..'》成長檔次');
                  NLG.SystemMessage(player, '體成長'..arr_rank1..' 力成長'..arr_rank2..' 強成長'..arr_rank3..' 速成長'..arr_rank4..' 魔成長'..arr_rank5);
            elseif last==nil and a6 >= 0 then
                  NLG.SystemMessage(player, '---------------------------------------');
                  NLG.SystemMessage(player, ''..petname..'：總共-'..a6..'檔次！');
                  NLG.SystemMessage(player, '體'..arr_rank1..'(-'..a1..')力'..arr_rank2..'(-'..a2..')強'..arr_rank3..'(-'..a3..')速'..arr_rank4..'(-'..a4..')魔'..arr_rank5..'(-'..a5..')');
            end
      end
      NLG.SystemMessage(player, '---------------------------------------');
end

function QuickUI:handleTalkEvent(charIndex,msg,color,range,size)
	if (msg=="/book") then
		local msg = "2\\n@c　特殊便捷功能選單\\n"
			.."　　════════════════════\\n"
			.."　《組隊一鍵打卡》\\n"
			.."　《組隊一鍵恢復》\\n"
			.."　《隊伍成員紀錄》\\n"
			.."　《隊伍成員集結》\\n"
			.."　《成員集中一點》\\n"
			.."　《走路移動加速》\\n"
			.."　《寵物一鍵算檔》\\n";
		NLG.ShowWindowTalked(charIndex, self.quickUInpc, CONST.窗口_选择框, CONST.按钮_关闭, 1, msg);
		return 0;
	end
	return 1;
end

-------------------------------------------------------------------------------------------------------------------------------------
function QuickUI:onLoad()
  self:logInfo('load');
  self:regCallback('CharActionEvent', Func.bind(self.shortcut, self))
  self:regCallback('ItemString', Func.bind(self.imageCollection, self),"LUA_useMetamoCT");
  self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self));
  self:regCallback('LoginEvent', Func.bind(self.onLoginEvent, self));
  self:regCallback('LoginGateEvent', Func.bind(self.onLoginEvent, self));

  self.quickUInpc = self:NPC_createNormal('动作快捷图示', 98972, { x = 36, y = 37, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.quickUInpc, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "2\\n@c　特殊便捷功能選單\\n"
            .."　　════════════════════\\n"
            .."　《組隊一鍵打卡》\\n"
            .."　《組隊一鍵恢復》\\n"
            .."　《隊伍成員紀錄》\\n"
            .."　《隊伍成員集結》\\n"
            .."　《成員集中一點》\\n"
            .."　《走路移動加速》\\n"
            .."　《寵物一鍵算檔》\\n";
      NLG.ShowWindowTalked(player, self.quickUInpc, CONST.窗口_选择框, CONST.按钮_关闭, 1, msg);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(self.quickUInpc, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --print(data)
    if select > 0 then
    else
      if (seqno == 1 and select == CONST.按钮_关闭) then
                 return;
      end
      if (seqno == 1 and data >= 1) then
          local menuSelect = data;
          if menuSelect == 1 then
            self:teamfever(self.feverNpc,player);
          elseif menuSelect == 2 then
            self:teamheal(self.healNpc,player);
          elseif menuSelect == 3 then
            self:partyenter(player);
          elseif menuSelect == 4 then
            self:partyform(player);
          elseif menuSelect == 5 then
            self:gather(player);
          elseif menuSelect == 6 then
            self:walkingspeed(self.speedNpc,player);
          elseif menuSelect == 7 then
            self:petinfo(player);
          end
      end
    end
  end)

  --移動速度
  self.speedNpc = self:NPC_createNormal('速度快捷', 98972, { x = 37, y = 37, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.speedNpc, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      --local msg = "\\n@c【移動加速】完成任務逐步提升至最高走路速度！\\n\\n1.王宮召喚士蓋茲[死者戒指]【130】\\n\\n2.女神卡連[六曜之塔]【150】\\n\\n3.受傷的女人[森羅萬象]【170】\\n\\n4.賽格梅特之魂[失翼之龍]【200】\\n";
      --local msg = "\\n@c【移動加速】收集四魂之玉強化你的精靈之魂！\\n\\n精靈之魂Lv1【110】　　精靈之魂Lv6【180】\\n　　　　Lv2【120】　　　　　　Lv7【200】\\n　　　　Lv3【130】　　　　　　Lv8【220】\\n　　　　Lv4【140】　　　　　　Lv9【250】\\n　　　　Lv5【160】　　　　　　Lv10【300】\\n";
      local msg = "\\n　【移動加速】收集四魂之玉強化你的精靈之魂！\\n\\n　Lv1【110】　　Lv6【180】　　↓坐騎形象↓\\n　Lv2【120】　　Lv7【200】\\n　Lv3【130】　　Lv8【220】\\n　Lv4【140】　　Lv9【250】\\n　Lv5【160】　　Lv10【300】\\n";
      if (Char.ItemNum(player, Agni_itemId)==0 and Char.ItemNum(player, Aqua_itemId)==1 and Char.ItemNum(player, Ventus_itemId)==0 and Char.ItemNum(player, Terra_itemId)==0) then
          local itemIndex = Char.HaveItem(player, Aqua_itemId);
          local sitting_image= Item.GetData(itemIndex,CONST.道具_幸运);
          local imageText = "@g,"..sitting_image..",15,7,6,0@"
          msg = imageText .. msg;
      elseif (Char.ItemNum(player, Agni_itemId)==1 and Char.ItemNum(player, Aqua_itemId)==0 and Char.ItemNum(player, Ventus_itemId)==0 and Char.ItemNum(player, Terra_itemId)==0) then
          local itemIndex = Char.HaveItem(player, Agni_itemId);
          local sitting_image= Item.GetData(itemIndex,CONST.道具_幸运);
          local imageText = "@g,"..sitting_image..",15,7,6,0@"
          msg = imageText .. msg;
      elseif (Char.ItemNum(player, Agni_itemId)==0 and Char.ItemNum(player, Aqua_itemId)==0 and Char.ItemNum(player, Ventus_itemId)==1 and Char.ItemNum(player, Terra_itemId)==0) then
          local itemIndex = Char.HaveItem(player, Ventus_itemId);
          local sitting_image= Item.GetData(itemIndex,CONST.道具_幸运);
          local imageText = "@g,"..sitting_image..",15,7,6,0@"
          msg = imageText .. msg;
      elseif (Char.ItemNum(player, Agni_itemId)==0 and Char.ItemNum(player, Aqua_itemId)==0 and Char.ItemNum(player, Ventus_itemId)==0 and Char.ItemNum(player, Terra_itemId)==1) then
          local itemIndex = Char.HaveItem(player, Terra_itemId);
          local sitting_image= Item.GetData(itemIndex,CONST.道具_幸运);
          local imageText = "@g,"..sitting_image..",15,7,6,0@"
          msg = imageText .. msg;
      else
          msg = msg;
      end
      NLG.ShowWindowTalked(player, self.speedNpc, CONST.窗口_信息框, CONST.按钮_确定关闭, 1, msg);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(self.speedNpc, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select > 0 then
      if seqno == 1 and select == CONST.按钮_确定 then
          if (Char.ItemNum(player, Agni_itemId)==0 and Char.ItemNum(player, Aqua_itemId)==1 and Char.ItemNum(player, Ventus_itemId)==0 and Char.ItemNum(player, Terra_itemId)==0) then
                itemIndex = Char.HaveItem(player, Aqua_itemId);
                local level = Item.GetData(itemIndex,CONST.道具_等级);
                Char.SetData(player, CONST.对象_移速, WingSpeed_List[level]);
                Char.SetTempData(player, 'MountOn',1);
                NLG.UpChar(player)
                --NLG.SetHeadIcon(player, WingKind_List[Aqua_itemId][level]);
          elseif (Char.ItemNum(player, Agni_itemId)==1 and Char.ItemNum(player, Aqua_itemId)==0 and Char.ItemNum(player, Ventus_itemId)==0 and Char.ItemNum(player, Terra_itemId)==0) then
                itemIndex = Char.HaveItem(player, Agni_itemId);
                local level = Item.GetData(itemIndex,CONST.道具_等级);
                Char.SetData(player, CONST.对象_移速, WingSpeed_List[level]);
                Char.SetTempData(player, 'MountOn',1);
                NLG.UpChar(player)
                --NLG.SetHeadIcon(player, WingKind_List[Agni_itemId][level]);
          elseif (Char.ItemNum(player, Agni_itemId)==0 and Char.ItemNum(player, Aqua_itemId)==0 and Char.ItemNum(player, Ventus_itemId)==1 and Char.ItemNum(player, Terra_itemId)==0) then
                itemIndex = Char.HaveItem(player, Ventus_itemId);
                local level = Item.GetData(itemIndex,CONST.道具_等级);
                Char.SetData(player, CONST.对象_移速, WingSpeed_List[level]);
                Char.SetTempData(player, 'MountOn',1);
                NLG.UpChar(player)
                --NLG.SetHeadIcon(player, WingKind_List[Ventus_itemId][level]);
          elseif (Char.ItemNum(player, Agni_itemId)==0 and Char.ItemNum(player, Aqua_itemId)==0 and Char.ItemNum(player, Ventus_itemId)==0 and Char.ItemNum(player, Terra_itemId)==1) then
                itemIndex = Char.HaveItem(player, Terra_itemId);
                local level = Item.GetData(itemIndex,CONST.道具_等级);
                Char.SetData(player, CONST.对象_移速, WingSpeed_List[level]);
                Char.SetTempData(player, 'MountOn',1);
                NLG.UpChar(player)
                --NLG.SetHeadIcon(player, WingKind_List[Terra_itemId][level]);
          else
                Char.SetData(player, CONST.对象_移速,100);
                NLG.UpChar(player)
          end
      elseif seqno == 1 and select == CONST.按钮_关闭 then
                Char.SetData(player, CONST.对象_移速,100);
                Char.SetTempData(player, 'MountOn',0);
                NLG.UpChar(player)
      end
      --坐骑
      if (itemIndex>0) then
          local sitting_image = Item.GetData(itemIndex,CONST.道具_幸运);
          local MountOn = Char.GetTempData(player, 'MountOn') or -1;
          if (sitting_image>0 and MountOn>=1) then
              local MapId = Char.GetData(player,CONST.对象_地图类型);
              local FloorId = Char.GetData(player,CONST.对象_地图);
              local X = Char.GetData(player,CONST.对象_X);
              local Y = Char.GetData(player,CONST.对象_Y);
              local objNum,objTbl = Obj.GetObject(MapId, FloorId, X, Y);
              --print(objNum,objTbl)
              players = NLG.GetPlayer();
              for k, v in ipairs(objTbl) do
                    local playerIndex = Obj.GetCharIndex(v)
                    local sittingIndex = tonumber(playerIndex)+1;
                    --print(playerIndex,sittingIndex,objTbl[1])
                    if (Obj.GetType(v)==1) then	---1：非法 | 0：未使用 | 1：角色 | 2：道具 | 3：金币 | 4：传送点 | 5：船 | 6：载具
                        --Protocol.Send(v,'NI',from10to62(objTbl[1])..'|'..x..'|'..y..'|70|0|101001|650|-1')	--骑宠1 70
                        Protocol.Send(playerIndex,'NI',from10to62(objTbl[1])..'|'..X..'|'..Y..'|70|'..sittingIndex..'|'..sitting_image..'|650|-1')
                        for k, v in ipairs(players) do
                            local names = Char.GetData(v,CONST.对象_原名) or -1;
                            local maps = Char.GetData(v,CONST.对象_地图) or -1;
                            if names~=-1 and maps==FloorId then 
                                 Protocol.Send(v,'NI',from10to62(objTbl[1])..'|'..X..'|'..Y..'|70|'..sittingIndex..'|'..sitting_image..'|650|-1')
                            end
                        end
                    end
              end
          end
      else
      end
    end
  end)
  --全隊打卡
  self.feverNpc = self:NPC_createNormal('打卡快捷', 98972, { x = 38, y = 37, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.feverNpc, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "\\n\\n@c【一鍵全隊打卡】\\n\\n非打卡狀態→打卡狀態\\n\\n打卡狀態→非打卡狀態\\n\\n[確定]幫全隊進行打卡、全隊的打卡結束\\n";
      NLG.ShowWindowTalked(player, self.feverNpc, CONST.窗口_信息框, CONST.按钮_确定关闭, 2, msg);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(self.feverNpc, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select > 0 then
      if seqno == 2 and select == CONST.按钮_确定 then
       if Char.PartyNum(player)>0 and player==Char.GetPartyMember(player,0) then
          for slot = 0,4 do
            local p = Char.GetPartyMember(player,slot)
            if(p>=0) then
                local daka = Char.GetData(p, CONST.对象_打卡);
                local name = Char.GetData(p,CONST.对象_名字);
                if daka == 1 then
                      Char.FeverStop(p);
                      NLG.UpChar(p);
                      NLG.SystemMessage(player, name.."關閉打卡。");
                end
                if daka == 0 then
                      if Char.IsDummy(p) then
                          Char.SetData(p, CONST.对象_卡时, 24 * 3600);
                      end
                      Char.FeverStart(p);
                      NLG.UpChar(p);
                      NLG.SystemMessage(player, name.."打卡成功。");
                end
            end
          end
       else
          local daka = Char.GetData(player, CONST.对象_打卡);
          local name = Char.GetData(player,CONST.对象_名字);
            if daka == 1 then
                Char.FeverStop(player);
                NLG.UpChar(player);
                NLG.SystemMessage(player, name.."關閉打卡。");
            end
            if daka == 0 then
                  Char.FeverStart(player);
                  NLG.UpChar(player);
                  NLG.SystemMessage(player, name.."打卡成功。");
            end
            --NLG.SystemMessage(player, "組隊狀態才能用此全隊打卡。");
       end
      end
    end
  end)
  --全隊補血
  self.healNpc = self:NPC_createNormal('补血快捷', 98972, { x = 39, y = 37, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.healNpc, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "\\n\\n@c回復魔法值（+等量生命值）\\n\\n回復生命值\\n\\n回復寵物的生命值和魔法值\\n\\n一鍵回復全隊人物和寵物魔法、生命\\n";
      NLG.ShowWindowTalked(player, self.healNpc, CONST.窗口_信息框, CONST.按钮_确定关闭, 3, msg);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(self.healNpc, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.对象_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select > 0 then
      if seqno == 3 and select == CONST.按钮_确定 then
        gold = Char.GetData(player, CONST.对象_金币);
        totalGold = 0;
        FpGold = 0;
        LpGold = 0;
        --計算回復總金額
        if Char.PartyNum(player)>0 and player==Char.GetPartyMember(player,0) then
          for slot = 0,4 do
            local p = Char.GetPartyMember(player,slot)
            if(p>=0) then
                local lp = Char.GetData(p, CONST.对象_血)
                local maxLp = Char.GetData(p, CONST.对象_最大血)
                local fp = Char.GetData(p, CONST.对象_魔)
                local maxFp = Char.GetData(p, CONST.对象_最大魔)
                if fp <= maxFp then
                      FpGold = FpGold + maxFp - fp;
                end
                if lp <= maxLp then
                      LpGold = LpGold + maxLp - lp;
                end
            end
          end
        else
                local lp = Char.GetData(player, CONST.对象_血)
                local maxLp = Char.GetData(player, CONST.对象_最大血)
                local fp = Char.GetData(player, CONST.对象_魔)
                local maxFp = Char.GetData(player, CONST.对象_最大魔)
                if fp <= maxFp then
                      FpGold = FpGold + maxFp - fp;
                end
                if lp <= maxLp then
                      LpGold = LpGold + maxLp - lp;
                end
        end
        print(FpGold,LpGold)
        if FpGold*0.5 >= LpGold then
          totalGold = FpGold;
        else
          totalGold = FpGold + LpGold - FpGold*0.5;
        end

        local InGold = tonumber(Char.GetData(player, CONST.对象_受伤)) * 5;
        local SoGold = tonumber(Char.GetData(player, CONST.对象_等级)) * tonumber(Char.GetData(player, CONST.对象_掉魂)) * 50;
        totalGold = totalGold + InGold + SoGold;
        local msg = "\\n\\n@c全隊回復需要花費"..totalGold.."個金幣\\n\\n現有金錢是"..gold.."個金幣\\n\\n\\n要回復嗎？\\n";
        NLG.ShowWindowTalked(player, self.healNpc, CONST.窗口_信息框, CONST.按钮_是否, 31, msg);
      --人物寵物補血魔
      elseif seqno == 31 and select == CONST.按钮_是 then
        if gold < totalGold then
                NLG.SystemMessage(player, '金幣不足無法回復');
                return
        else
                if Char.PartyNum(player)>0 and player==Char.GetPartyMember(player,0) then
                    for slot = 0,4 do
                       local p = Char.GetPartyMember(player,slot);
                       if(p>=0) then
                           local maxLp = Char.GetData(p, CONST.对象_最大血);
                           local maxFp = Char.GetData(p, CONST.对象_最大魔);
                           Char.SetData(p, CONST.对象_血, maxLp);
                           Char.SetData(p, CONST.对象_魔, maxFp);
						   Char.SetData(p, CONST.对象_受伤, 0);
                           Char.SetData(p, CONST.对象_掉魂, 0);
                           NLG.UpChar(p);
                           for petSlot  = 0,4 do
                              local petIndex = Char.GetPet(p,petSlot);
                              if petIndex >= 0 then
                                  local maxLp = Char.GetData(petIndex, CONST.对象_最大血);
                                  local maxFp = Char.GetData(petIndex, CONST.对象_最大魔);
                                  Char.SetData(petIndex, CONST.对象_血, maxLp);
                                  Char.SetData(petIndex, CONST.对象_魔, maxFp);
						          Char.SetData(petIndex, CONST.对象_受伤, 0);
                                  Pet.UpPet(p, petIndex);
                              end
                           end
                       end
                    end
                    Char.AddGold(player, -totalGold);
                    NLG.UpChar(player);
                else
                           local maxLp = Char.GetData(player, CONST.对象_最大血);
                           local maxFp = Char.GetData(player, CONST.对象_最大魔);
                           Char.SetData(player, CONST.对象_血, maxLp);
                           Char.SetData(player, CONST.对象_魔, maxFp);
						   Char.SetData(player, CONST.对象_受伤, 0);
                           Char.SetData(player, CONST.对象_掉魂, 0);
                           NLG.UpChar(player);
                           for petSlot  = 0,4 do
                              local petIndex = Char.GetPet(player,petSlot);
                              if petIndex >= 0 then
                                  local maxLp = Char.GetData(petIndex, CONST.对象_最大血);
                                  local maxFp = Char.GetData(petIndex, CONST.对象_最大魔);
                                  Char.SetData(petIndex, CONST.对象_血, maxLp);
                                  Char.SetData(petIndex, CONST.对象_魔, maxFp);
						          Char.SetData(petIndex, CONST.对象_受伤, 0);
                                  Pet.UpPet(player, petIndex);
                              end
                           end
                    Char.AddGold(player, -totalGold);
                    NLG.UpChar(player);
                    --NLG.SystemMessage(player, '隊長才可使用！');
                end
        end

      end
    end
  end)


end

function QuickUI:onLoginEvent(charIndex)
      if Char.IsDummy(charIndex) then
        return
      end
      if (Char.ItemNum(charIndex, Agni_itemId)==0 and Char.ItemNum(charIndex, Aqua_itemId)==1 and Char.ItemNum(charIndex, Ventus_itemId)==0 and Char.ItemNum(charIndex, Terra_itemId)==0) then
            itemIndex = Char.HaveItem(charIndex, Aqua_itemId);
            local level = Item.GetData(itemIndex,CONST.道具_等级);
            Char.SetData(charIndex, CONST.对象_移速, WingSpeed_List[level]);
            NLG.UpChar(charIndex)
            NLG.SetHeadIcon(charIndex, WingKind_List[Aqua_itemId][level]);
      elseif (Char.ItemNum(charIndex, Agni_itemId)==1 and Char.ItemNum(charIndex, Aqua_itemId)==0 and Char.ItemNum(charIndex, Ventus_itemId)==0 and Char.ItemNum(charIndex, Terra_itemId)==0) then
            itemIndex = Char.HaveItem(charIndex, Agni_itemId);
            local level = Item.GetData(itemIndex,CONST.道具_等级);
            Char.SetData(charIndex, CONST.对象_移速, WingSpeed_List[level]);
            NLG.UpChar(charIndex)
            NLG.SetHeadIcon(charIndex, WingKind_List[Agni_itemId][level]);
      elseif (Char.ItemNum(charIndex, Agni_itemId)==0 and Char.ItemNum(charIndex, Aqua_itemId)==0 and Char.ItemNum(charIndex, Ventus_itemId)==1 and Char.ItemNum(charIndex, Terra_itemId)==0) then
            itemIndex = Char.HaveItem(charIndex, Ventus_itemId);
            local level = Item.GetData(itemIndex,CONST.道具_等级);
            Char.SetData(charIndex, CONST.对象_移速, WingSpeed_List[level]);
            NLG.UpChar(charIndex)
            NLG.SetHeadIcon(charIndex, WingKind_List[Ventus_itemId][level]);
      elseif (Char.ItemNum(charIndex, Agni_itemId)==0 and Char.ItemNum(charIndex, Aqua_itemId)==0 and Char.ItemNum(charIndex, Ventus_itemId)==0 and Char.ItemNum(charIndex, Terra_itemId)==1) then
            itemIndex = Char.HaveItem(charIndex, Terra_itemId);
            local level = Item.GetData(itemIndex,CONST.道具_等级);
            Char.SetData(charIndex, CONST.对象_移速, WingSpeed_List[level]);
            NLG.UpChar(charIndex)
            NLG.SetHeadIcon(charIndex, WingKind_List[Terra_itemId][level]);
      else
            Char.SetData(charIndex, CONST.对象_移速,100);
            NLG.UpChar(charIndex)
      end
      if (itemIndex~=nil) then
          local sitting_image = Item.GetData(itemIndex,CONST.道具_幸运);
          local MountOn = Char.GetTempData(charIndex, 'MountOn') or -1;
          if (sitting_image>0 and MountOn>=1) then
              local MapId = Char.GetData(charIndex,CONST.对象_地图类型);
              local FloorId = Char.GetData(charIndex,CONST.对象_地图);
              local X = Char.GetData(charIndex,CONST.对象_X);
              local Y = Char.GetData(charIndex,CONST.对象_Y);
              local objNum,objTbl = Obj.GetObject(MapId, FloorId, X, Y);
              --print(objNum,objTbl)
              players = NLG.GetPlayer();
              for k, v in ipairs(objTbl) do
                    local playerIndex = Obj.GetCharIndex(v)
                    local sittingIndex = tonumber(playerIndex)+1;
                    --print(playerIndex,sittingIndex,objTbl[1])
                    if (Obj.GetType(v)==1) then	---1：非法 | 0：未使用 | 1：角色 | 2：道具 | 3：金币 | 4：传送点 | 5：船 | 6：载具
                        --Protocol.Send(v,'NI',from10to62(objTbl[1])..'|'..x..'|'..y..'|70|0|101001|650|-1')	--骑宠1 70
                        Protocol.Send(playerIndex,'NI',from10to62(objTbl[1])..'|'..X..'|'..Y..'|70|'..sittingIndex..'|'..sitting_image..'|650|-1')
                        for k, v in ipairs(players) do
                            local names = Char.GetData(v,CONST.对象_原名) or -1;
                            local maps = Char.GetData(v,CONST.对象_地图) or -1;
                            if names~=-1 and maps==FloorId then 
                                 Protocol.Send(v,'NI',from10to62(objTbl[1])..'|'..X..'|'..Y..'|70|'..sittingIndex..'|'..sitting_image..'|650|-1')
                            end
                        end
                    end
              end
          end
      end
end
-----------------------------------------------------------------------------------------
Char.GetPetRank = function(playerIndex,slot)
  local petIndex = Char.GetPet(playerIndex, slot);
  if petIndex >= 0 then
    local arr_rank1 = Pet.GetArtRank(petIndex,CONST.PET_体成);
    local arr_rank2 = Pet.GetArtRank(petIndex,CONST.PET_力成);
    local arr_rank3 = Pet.GetArtRank(petIndex,CONST.PET_强成);
    local arr_rank4 = Pet.GetArtRank(petIndex,CONST.PET_敏成);
    local arr_rank5 = Pet.GetArtRank(petIndex,CONST.PET_魔成);
    local arr_rank11 = Pet.FullArtRank(petIndex, CONST.PET_体成);
    local arr_rank21 = Pet.FullArtRank(petIndex, CONST.PET_力成);
    local arr_rank31 = Pet.FullArtRank(petIndex, CONST.PET_强成);
    local arr_rank41 = Pet.FullArtRank(petIndex, CONST.PET_敏成);
    local arr_rank51 = Pet.FullArtRank(petIndex, CONST.PET_魔成);
    local a1 = math.abs(arr_rank11 - arr_rank1);
    local a2 = math.abs(arr_rank21 - arr_rank2);
    local a3 = math.abs(arr_rank31 - arr_rank3);
    local a4 = math.abs(arr_rank41 - arr_rank4);
    local a5 = math.abs(arr_rank51 - arr_rank5);
    local a6 = a1 + a2+ a3+ a4+ a5;
    return a6, a1, a2, a3, a4, a5;
  end
  return -1;
end


Char.GetAccessory = function(charIndex)
  local itemType = {
    { type=15},{ type=16},{ type=17},{ type=18},{ type=19},{ type=20},{ type=21},
  }
  local ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_首饰1);
  if ItemIndex >= 0 then
    for k, v in ipairs(itemType) do
      if Item.GetData(ItemIndex, CONST.道具_类型)==v.type then
        return ItemIndex, CONST.EQUIP_首饰1;
      end
    end
  end
  ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_首饰2)
  if ItemIndex >= 0 then
    for k, v in ipairs(itemType) do
      if Item.GetData(ItemIndex, CONST.道具_类型)==v.type then
        return ItemIndex, CONST.EQUIP_首饰2;
      end
    end
  end
  return -1, -1;
end

function from10to62(num)
	local dict = {"0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
		"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"};--进制数
	local result = ''
	--local bin = ''

	while num > 0 do
		result = tostring(dict[(num % 62)+1]) .. result--取余数并拼接到进制数的前面
		num = math.floor(num / 62)--整除62
	end

	return result

	--[[
	print('明文：'..result)
	--string反转开始
	local str_num = tostring(result)
	local reversed_str = ''
	for i = 1, #str_num do
		reversed_str = string.sub(str_num, i, i) .. reversed_str
	end
	local reversed_num = tostring(reversed_str)
	--print('反转：'..reversed_num)
	--print('长度：'..#reversed_num)
	return reversed_num
	]]
end

function QuickUI:onUnload()
  self:logInfo('unload')
end

return QuickUI;
