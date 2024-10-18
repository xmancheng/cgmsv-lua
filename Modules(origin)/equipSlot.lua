local Module = ModuleBase:createModule('equipSlot')

local ItemPosName = {"頭 部", "身 体", "右 手", "左 手", "足 部", "飾品1", "飾品2", "水 晶"}

--local ExpRate = 3;
local StrRequireExp = {1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000, 11000,}	--经验

--远程按钮UI呼叫
function Module:equipSlotInfo(npc, player)
          local winMsg = "1\\n　　　　　　　　【角色裝備插槽】\\n"
          for targetSlot = 0,4 do
                local targetIndex = EquipSlotStat(player, ItemPosName[targetSlot+1], "Q");
                local targetItemIndex = Char.GetItemIndex(player, targetSlot);
                if (targetIndex==nil) then
                    EquipSlotStat(player, ItemPosName[targetSlot+1], "Q", 0);
                    EquipSlotStat(player, ItemPosName[targetSlot+1], "V", 0);
                end

                local tStrLv = EquipSlotStat(player, ItemPosName[targetSlot+1], "Q");
                local tStrExp = EquipSlotStat(player, ItemPosName[targetSlot+1], "V");
                local tStrExp = tStrExp/100;
                local msg = "插槽等級: ".. tStrLv .. "  目前熟練度: ".. tStrExp .."%";
                winMsg = winMsg .. ItemPosName[targetSlot+1] .. "：" .. msg .. "\n"
          end
          NLG.ShowWindowTalked(player, self.equipSloterNPC, CONST.窗口_选择框, CONST.按钮_关闭, 1, winMsg);
end

-------------------------------------------------------------------------------------------------------------------------------------
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('ItemAttachEvent', Func.bind(self.itemAttachCallback, self))
  self:regCallback('ItemDetachEvent', Func.bind(self.itemDetachCallback, self))
  self:regCallback('ItemExpansionEvent', Func.bind(self.itemExpansionCallback, self))

  self.equipSloterNPC = self:NPC_createNormal('裝備插槽管理', 14682, { x =36 , y = 31, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.equipSloterNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
          local winMsg = "1\\n　　　　　　　　【角色裝備插槽】\\n"
          for targetSlot = 0,4 do
                local targetIndex = EquipSlotStat(player, ItemPosName[targetSlot+1], "Q");
                local targetItemIndex = Char.GetItemIndex(player, targetSlot);
                if (targetIndex==nil) then
                    EquipSlotStat(player, ItemPosName[targetSlot+1], "Q", 0);
                    EquipSlotStat(player, ItemPosName[targetSlot+1], "V", 0);
                end

                local tStrLv = EquipSlotStat(player, ItemPosName[targetSlot+1], "Q");
                local tStrExp = EquipSlotStat(player, ItemPosName[targetSlot+1], "V");
                local tStrExp = tStrExp/100;
                local msg = "插槽等級: ".. tStrLv .. "  目前熟練度: ".. tStrExp .."%";
                winMsg = winMsg .. ItemPosName[targetSlot+1] .. "：" .. msg .. "\n"
          end
          NLG.ShowWindowTalked(player, self.equipSloterNPC, CONST.窗口_选择框, CONST.按钮_关闭, 1, winMsg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.equipSloterNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --print(data)
    if select > 0 then
      if (seqno == 11 and select == CONST.按钮_关闭) then
                 return;
      end
      if (seqno == 11 and select == CONST.BUTTON_确定 and data >= 1) then
          local keyNum = data*1;
          local tStrExp = EquipSlotStat(player, ItemPosName[targetSlot+1], "V");
          if (tStrExp/100>=100) then
              NLG.SystemMessage(player, "[系統]熟練度已達100%能量！");
              return;
          end
          if (targetSlot>=0) then
              local killNum = Char.ItemNum(player, 70194);
              local tStrLv = EquipSlotStat(player, ItemPosName[targetSlot+1], "Q");
              if (keyNum ~=nil and math.ceil(keyNum)==keyNum) then
                  if (keyNum>killNum) then
                      NLG.SystemMessage(player, "[系統]伏特能量不足！");
                      return;
                  else
                      EquipSlotStat(player, ItemPosName[targetSlot+1], "V", tStrExp+keyNum);
                      Char.DelItem(player, 70194, keyNum);
                      local tStrExp = EquipSlotStat(player, ItemPosName[targetSlot+1], "V");
                      if (tStrLv<10 and tStrExp>=StrRequireExp[tStrLv+1]) then
                          EquipSlotStat(player, ItemPosName[targetSlot+1], "Q", tStrLv+1);
                      --elseif (tStrExp>StrRequireExp[tStrLv+1] and tStrExp<=StrRequireExp[tStrLv+2]) then
                      --    EquipSlotStat(player, ItemPosName[targetSlot+1], "Q", tStrLv+1);
                      end
                  end
              end
          end
      end

    else
      if (seqno == 1 and select == CONST.按钮_关闭) then
                 return;
      end
      if (seqno == 1 and data >= 1) then
              targetSlot = data-1;  --装备格参数 (选项少1)
              targetItemIndex = Char.GetItemIndex(player, targetSlot);
              local killNum = Char.ItemNum(player, 70194);
              local winMsg = "$1【裝備插槽強化】\\n"
                                           .."═════════════════════\\n"
                                           .."正在確認插槽資訊...\\n"
                                           .."\\n　　　　插　槽　部　位：$1".. ItemPosName[targetSlot+1] .."\\n"
                                           .."\\n　　　　當前可充入的量：$4".. killNum .."\\n"
                                           .."\\n請確認輸入之伏特量：\\n";
              NLG.ShowWindowTalked(player, self.equipSloterNPC, CONST.窗口_输入框, CONST.BUTTON_确定关闭, 11, winMsg);
      else
                 return;
      end
    end
  end)


end

function Module:itemAttachCallback(charIndex, fromItemIndex)
      local targetSlot = Char.GetTargetItemSlot(charIndex,fromItemIndex)
      print(targetSlot);
      local targetIndex = EquipSlotStat(charIndex, ItemPosName[targetSlot+1], "Q");
      if (targetIndex==nil) then
          EquipSlotStat(charIndex, ItemPosName[targetSlot+1], "Q", 0);
          EquipSlotStat(charIndex, ItemPosName[targetSlot+1], "V", 0);
      end

      local tStrLv = EquipSlotStat(charIndex, ItemPosName[targetSlot+1], "Q");
      setItemStrData(fromItemIndex, tStrLv);
      Item.UpItem(charIndex, targetSlot);
      NLG.UpChar(charIndex);
  return 0;
end

function Module:itemDetachCallback(charIndex, fromItemIndex)
      local targetSlot = Char.GetTargetItemSlot(charIndex,fromItemIndex)
      local targetIndex = EquipSlotStat(charIndex, ItemPosName[targetSlot+1], "Q");
      if (targetIndex==nil) then
          EquipSlotStat(charIndex, ItemPosName[targetSlot+1], "Q", 0);
          EquipSlotStat(charIndex, ItemPosName[targetSlot+1], "V", 0);
      end

      setItemRevertData(fromItemIndex);
      Item.UpItem(charIndex, targetSlot);
      NLG.UpChar(charIndex);
  return 0;
end

function Module:itemExpansionCallback(itemIndex, type, msg, charIndex, slot)
  --self:logDebug('itemExpansionCallback', itemIndex, type, msg, charIndex, slot)

end

------------------------------------------------------------------------------------------
--功能函数
function EquipSlotStat( _Index, _StatSlot, _StatTab, _StatValue )
	--  E-赋予，P- 喷漆，H- 猎，G- 鬼，Q- 插槽，V- 伏特
	local tStatTab = {}
	if type(_StatTab)=="nil" then
		--GetAll
		local tItemStat = tostring(Char.GetExtData(_Index, _StatSlot));
		if string.find(tItemStat, ",")==nil then
			return nil;
		end
		if string.find(tItemStat, "|")==nil then
			local tSub = string.split(tItemStat, ",");
			tStatTab[tSub[1]]=tonumber(tSub[2]);
			return tStatTab;
		end
		local tStat = string.split(tItemStat, "|")
		for k,v in pairs(tStat) do
			local tSub = string.split(v, ",");
			tStatTab[tSub[1]]=tonumber(tSub[2]);
		end
		return tStatTab;
	elseif type(_StatTab)=="table" then
		--SetAll
		local tStat = "";
		for k,v in pairs(_StatTab) do
			tStat = tStat .. k .. "," .. v .. "|";
		end
		Char.SetExtData(_Index, _StatSlot, tStat);
		NLG.UpChar(_Index);
	elseif type(_StatTab)=="string" and type(_StatValue)=="nil" then
		--GetSub
		local tStatTab = EquipSlotStat(_Index, _StatSlot) or {};
		for k,v in pairs(tStatTab) do
			if _StatTab==k then
				return tonumber(v);
			end
		end
		return nil;
	elseif type(_StatTab)=="string" then
		--SetSub
		local tStatTab = EquipSlotStat(_Index, _StatSlot) or {};
		tStatTab[_StatTab]=_StatValue;
		EquipSlotStat(_Index, _StatSlot, tStatTab);
	end
end

--装备时增加素质
function setItemStrData( _ItemIndex, _StrLv)

	--SQL.Run("ALTER TABLE tbl_item MODIFY COLUMN Argument char(45) Default 0");

	local bRate = 1 + (_StrLv/10 * 2);
	local hRate = 1 + (_StrLv/10 * 2 * 0.1);
	local strData = {18, 19, 20, 21, 22, 27, 28}	--%道具_攻击%,%道具_防御%,%道具_敏捷%,%道具_精神%,%道具_回复%,%道具_HP%,%道具_MP%

	for k,v in pairs(strData) do
 		if Item.GetData(_ItemIndex, v)>0 then
			if (k>=1 and k<=5) then
				Plus= math.floor(Item.GetData(_ItemIndex, v)*bRate) - Item.GetData(_ItemIndex, v);
				Item.SetData(_ItemIndex, v, math.floor(Item.GetData(_ItemIndex, v)*bRate));
			elseif (k>=6 and k<=7) then
				Plus= math.floor(Item.GetData(_ItemIndex, v)*hRate) - Item.GetData(_ItemIndex, v);
				Item.SetData(_ItemIndex, v, math.floor(Item.GetData(_ItemIndex, v)*hRate));
			end
			local tStat = Item.GetData(_ItemIndex, CONST.道具_自用参数) or "";
			local tStat = tStat .. v .. "," .. Plus .. "|";
			Item.SetData(_ItemIndex, CONST.道具_自用参数, tStat);
		end
	end
end
--卸下时还原素质
function setItemRevertData( _ItemIndex)
	local tStatTab = {}
	local tItemStat = tostring(Item.GetData(_ItemIndex, CONST.道具_自用参数));
	if (string.find(tItemStat, ",")==nil or string.find(tItemStat, "|")==nil) then
		return;
	else
		--local strData = {18, 19, 20, 21, 22, 27, 28}	--%道具_攻击%,%道具_防御%,%道具_敏捷%,%道具_精神%,%道具_回复%,%道具_HP%,%道具_MP%
		local tStat = string.split(tItemStat, "|");
		for k,v in pairs(tStat) do
			if (type(v)=="string" and k<#tStat) then
				local tSub = string.split(v, ",");
				if (type(tSub)=="table") then
					Item.SetData(_ItemIndex, tonumber(tSub[1]), Item.GetData(_ItemIndex, tonumber(tSub[1])) - tonumber(tSub[2]));
				end
			else
			end
		end
		Item.SetData(_ItemIndex, CONST.道具_自用参数, "");
	end
end

------------------------------------------------------------------------------------------
--自定义接口
Char.GetTargetItemSlot = function(charIndex,fromItemIndex)
  local type = Item.GetData(fromItemIndex, CONST.道具_类型);
  if (type==8 or type==9) then
      return 0;
  elseif (type==10 or type==11 or type==12) then
      return 1;
  elseif (type==13 or type==14) then
      return 4;
  elseif (type==0 or type==1 or type==2 or type==3 or type==4 or type==5 or type==6 or type==7) then
      local ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_左手);
      if (ItemIndex < 0) then
          return 2;
      end
      ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_右手);
      if (ItemIndex < 0) then
          return 3;
      end
  elseif (type==15 or type==16 or type==17 or type==18 or type==19 or type==20 or type==21 or type==55) then
      local ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_首饰1);
      if (ItemIndex < 0) then
          return 6;
      end
      ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_首饰2);
      if (ItemIndex < 0) then
          return 5;
      end
  elseif (type==22) then
      return 7;
  end
  return -1;
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
