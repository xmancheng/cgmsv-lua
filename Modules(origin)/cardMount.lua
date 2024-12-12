local Module = ModuleBase:createModule('cardMount')

local Terra_itemId = 70196;	--地精灵
local Agni_itemId = 70198;	--火精灵
local Aqua_itemId = 70197;	--水精灵
local Ventus_itemId = 70199;	--风精灵
local WingSpeed_List = {110,120,130,140,160,180,200,220,250,300};

local MountEnable_check= {71050,71051,71052,71053,71054,71055,71056,71057,};
local sittingImages={}	--坐騎形象
sittingImages[71050] = 149032;
sittingImages[71051] = 149027;
sittingImages[71052] = 104865;
sittingImages[71053] = 104923;
sittingImages[71054] = 104877;
sittingImages[71055] = 108021;
sittingImages[71056] = 104901;
sittingImages[71057] = 108087;

local sittingCards={}	--攻|防|敏|精|回|血|魔
sittingCards[71050] = "0|0|0|150|0|0|0";		--【蓋歐卡】坐騎卡.精神+150
sittingCards[71051] = "150|0|0|0|0|0|0";		--【固拉多】坐騎卡.攻擊+150
sittingCards[71052] = "0|0|0|0|0|0|0";			--【呆萌豬王】坐騎卡.
sittingCards[71053] = "100|0|0|0|0|0|0";		--【白眉豬王】坐騎卡.攻擊+100
sittingCards[71054] = "0|100|0|0|0|0|0";		--【純白豬王】坐騎卡.防禦+100
sittingCards[71055] = "0|0|100|0|0|0|0";		--【純金豬王】坐騎卡.敏捷+100
sittingCards[71056] = "0|0|0|100|0|0|0";		--【粉心王妃】坐騎卡.精神+100
sittingCards[71057] = "0|0|0|0|100|0|0";		--【綠點王妃】坐騎卡.回復+100
---------------------------------------------------------------------
--远程按钮UI呼叫
--[[function Module:walkingspeed(npc, player)
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
]]
-------------------------------------------------------------------------------------------------------------------------------------
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
--[[
  --移動速度
  self.speedNpc = self:NPC_createNormal('速度快捷', 98972, { x = 37, y = 37, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.speedNpc, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
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
      if (itemIndex~=nil) then
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
]]

  --坐騎卡道具NPC
  self:regCallback('ItemString', Func.bind(self.sittingCard, self),"LUA_useMount");
  self.setupMountNPC = self:NPC_createNormal('坐騎令牌', 14682, { x =34 , y = 31, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.setupMountNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local ElvesIndex = Char.GetItemIndex(player,8);		--物品欄第一格
      if (ElvesIndex>0) then
        ElvesId = Item.GetData(ElvesIndex,CONST.道具_ID);	--精靈之魂id
      else
        return;
      end
      if (ElvesId==70196 or ElvesId==70197 or ElvesId==70198 or ElvesId==70199) then
        sittingId = Item.GetData(ElvesIndex,CONST.道具_幸运);	--精靈之魂(坐騎形象)
      else
        return;
      end
      if (sittingId==0) then
        local msg = "@c【坐騎憑證】\\n"
                 .. "\\n\\n\\n 確定使用此坐騎形象卡嗎？\\n\\n"
        NLG.ShowWindowTalked(player, self.setupMountNPC, CONST.窗口_信息框, CONST.按钮_是否, 1, msg);
      elseif (sittingId>0) then
        local msg = "@c【坐騎憑證】\\n"
                 .. "\\n\\n\\n 確定覆蓋現有的坐騎形象嗎？\\n\\n"
        NLG.ShowWindowTalked(player, self.setupMountNPC, CONST.窗口_信息框, CONST.按钮_是否, 2, msg);
      else
      end
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(self.setupMountNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    local MountIndex = MountIndex;
    local MountSlot = MountSlot;
    local MountId = Item.GetData(MountIndex,CONST.道具_ID);	--坐騎卡
    local MountName = Item.GetData(MountIndex,CONST.道具_名字);	--坐騎卡名
    local ElvesIndex = Char.GetItemIndex(player,8);		--物品欄第一格

    --坐騎卡操作
    if select > 0 then
      if seqno == 1 and select == CONST.按钮_否 then
                 return;
      elseif seqno == 2 and select == CONST.按钮_否 then
                 return;
      elseif seqno == 1 and select == CONST.按钮_是 then
        if (ElvesIndex>0) then
          local ElvesId = Item.GetData(ElvesIndex,CONST.道具_ID);	--精靈之魂id
          if (ElvesId==70196 or ElvesId==70197 or ElvesId==70198 or ElvesId==70199) then
              if ( CheckInTable(MountEnable_check, MountId)==true ) then
                  Char.DelItem(player, MountId, 1);
                  setItemStrData(ElvesIndex, sittingCards[MountId])
                  Item.SetData(ElvesIndex,CONST.道具_幸运,sittingImages[MountId]);
                  Item.UpItem(player,8);
                  NLG.UpChar(player);
                  NLG.PlaySe(player, 212, Char.GetData(player,CONST.对象_X), Char.GetData(player,CONST.对象_Y));
                  NLG.SystemMessage(player, "[系统]"..MountName.." 成功登陸。")
              else
              end
          else
              NLG.SystemMessage(player,"[系統]物品欄第一格未有精靈之魂。");
              return;
          end
        else
            return;
        end
      elseif seqno == 2 and select == CONST.按钮_是 then
        if (ElvesIndex>0) then
          local ElvesId = Item.GetData(ElvesIndex,CONST.道具_ID);		--精靈之魂id
          local sittingId = tonumber(Item.GetData(ElvesIndex,CONST.道具_幸运));		--精靈之魂(坐騎形象)
          --print(sittingId,sittingImages[MountId])
          if (sittingId==sittingImages[MountId]) then
              NLG.SystemMessage(player,"[系統]此坐骑形象已登錄使用。");
              return;
          end
          if (ElvesId==70196 or ElvesId==70197 or ElvesId==70198 or ElvesId==70199) then
              if ( CheckInTable(MountEnable_check, MountId)==true ) then
                  Char.DelItem(player, MountId, 1);
                  for k,v in pairs(sittingCards) do
                    if (sittingImages[k]==sittingId) then
                      setItemRevertData(ElvesIndex, sittingCards[k])	--先移除
                    end
                  end
                  Item.UpItem(player,8);
                  NLG.UpChar(player);
                  setItemStrData(ElvesIndex, sittingCards[MountId])			--再重加
                  Item.SetData(ElvesIndex,CONST.道具_幸运,sittingImages[MountId]);
                  Item.UpItem(player,8);
                  NLG.UpChar(player);
                  NLG.PlaySe(player, 212, Char.GetData(player,CONST.对象_X), Char.GetData(player,CONST.对象_Y));
                  NLG.SystemMessage(player, "[系统]"..MountName.." 成功登陸。")
              else
              end
          else
              NLG.SystemMessage(player,"[系統]物品欄第一格未有精靈之魂。");
              return;
          end
        else
            return;
        end
      else
          return;
      end

    else
    end
  end)


end

--坐騎卡
function Module:sittingCard(charIndex,targetIndex,itemSlot)
    --ItemID = Item.GetData(Char.GetItemIndex(charIndex,itemSlot),0);
    MountSlot = itemSlot;
    MountIndex = Char.GetItemIndex(charIndex,itemSlot);
    local MountId = Item.GetData(MountIndex,CONST.道具_ID);	--坐騎卡
    local ElvesIndex = Char.GetItemIndex(charIndex,8);		--物品欄第一格
    if (ElvesIndex>0) then
      ElvesId = Item.GetData(ElvesIndex,CONST.道具_ID);	--精靈之魂id
    else
      NLG.SystemMessage(charIndex,"[系統]物品欄第一格未有精靈之魂。");
      return 1;
    end
    if (ElvesId==70196 or ElvesId==70197 or ElvesId==70198 or ElvesId==70199) then
      sittingId = Item.GetData(ElvesIndex,CONST.道具_幸运);	--精靈之魂(坐騎形象)
    else
      NLG.SystemMessage(charIndex,"[系統]物品欄第一格未有精靈之魂。");
      return 1;
    end
    if (sittingId==0) then
        local msg = "@c【坐騎憑證】\\n"
                 .. "\\n\\n\\n 確定使用此坐騎形象卡嗎？\\n\\n"
        NLG.ShowWindowTalked(charIndex, self.setupMountNPC, CONST.窗口_信息框, CONST.按钮_是否, 1, msg);
    elseif (sittingId>0) then
        local msg = "@c【坐騎憑證】\\n"
                 .. "\\n\\n\\n 確定覆蓋現有的坐騎形象嗎？\\n\\n"
        NLG.ShowWindowTalked(charIndex, self.setupMountNPC, CONST.窗口_信息框, CONST.按钮_是否, 2, msg);
    else
    end
    return 1;
end
------------------------------------------------------------------------------------------
--增加素质
function setItemStrData( _ItemIndex, _Card)
	local Plus_buffer = {}
	local tItemStat = tostring( _Card);
	if (string.find(tItemStat, "|")==nil) then
		return;
	else
		local strData = {18, 19, 20, 21, 22, 27, 28}	--%道具_攻击%,%道具_防御%,%道具_敏捷%,%道具_精神%,%道具_回复%,%道具_HP%,%道具_MP%
		local Plus_buffer = string.split(tItemStat, "|");

		for k,v in pairs(strData) do
			Item.SetData(_ItemIndex, strData[k], Item.GetData(_ItemIndex, strData[k]) + tonumber(Plus_buffer[k]));
		end
	end
end

--还原素质
function setItemRevertData( _ItemIndex, _Card)
	local Plus_buffer = {}
	local tItemStat = tostring( _Card);
	if (string.find(tItemStat, "|")==nil) then
		return;
	else
		local strData = {18, 19, 20, 21, 22, 27, 28}	--%道具_攻击%,%道具_防御%,%道具_敏捷%,%道具_精神%,%道具_回复%,%道具_HP%,%道具_MP%
		local Plus_buffer = string.split(tItemStat, "|");

		for k,v in pairs(strData) do
			Item.SetData(_ItemIndex, strData[k], Item.GetData(_ItemIndex, strData[k]) - tonumber(Plus_buffer[k]));
		end
	end
end

function CheckInTable(_idTab, _idVar) ---循环函数
	for k,v in pairs(_idTab) do
		if v==_idVar then
			return true
		end
	end
	return false
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
