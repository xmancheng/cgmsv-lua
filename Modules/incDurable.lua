---模块类
local Module = ModuleBase:createModule('incDurable')

local ItemPosName = {"頭 部", "身 体", "右 手", "左 手", "足 部", "飾品1", "飾品2", "水 晶"}

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self.maintainNPC = self:NPC_createNormal('魂魄轉換保養魔人', 104745, { x =26 , y = 7, mapType = 0, map = 25000, direction = 4 });
  self:NPC_regTalkedEvent(self.maintainNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
          local killNum = Char.GetData(player,CONST.CHAR_伤害数);
          local winMsg = "1\\n請選擇保養增加耐久的裝備:    剩餘魂量【"..killNum.."】\\n"
          for targetSlot = 0,7 do
                local targetItemIndex = Char.GetItemIndex(player, targetSlot);
                if targetItemIndex>=0 then
                        local tItemID = Item.GetData(targetItemIndex, CONST.道具_ID);
                        local tItemName = Item.GetData(targetItemIndex, CONST.道具_名字);
                        local targetDur_MIN = Item.GetData(targetItemIndex,CONST.道具_耐久);
                        local targetDur_MAX = Item.GetData(targetItemIndex,CONST.道具_最大耐久);
                        local tStrLv = EquipPlusStat(targetItemIndex, "E") or 0;
                        local tItemCan = "[保養Ｘ]";
                        if (tStrLv>=7) then tItemCan="[保養Ｏ]" end
                        local msg = tItemName .. " "..targetDur_MIN.."/"..targetDur_MAX.. tItemCan;
                        winMsg = winMsg .. ItemPosName[targetSlot+1] .. "：" .. msg .. "\n"
                else
                        winMsg = winMsg .. ItemPosName[targetSlot+1] .. "：" .. "\n"
                end
          end
          NLG.ShowWindowTalked(player, self.maintainNPC, CONST.窗口_选择框, CONST.按钮_关闭, 1, winMsg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.maintainNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --print(data)
    if select > 0 then
      if (seqno == 11 and select == CONST.按钮_关闭) then
                 return;
      end
      if (seqno == 11 and select == CONST.BUTTON_确定 and data >= 1) then
          local keyNum = data;
          if (targetItemIndex>0) then
              local killNum = Char.GetData(player,CONST.CHAR_伤害数);
              local tItemID = Item.GetData(targetItemIndex, CONST.道具_ID);
              local tItemName = Item.GetData(targetItemIndex, CONST.道具_名字);
              local tStrLv = EquipPlusStat(targetItemIndex, "E") or 0;
              if (keyNum ~=nil and math.ceil(keyNum)==keyNum) then
                  if (keyNum>killNum) then
                      NLG.SystemMessage(player, "[" .. "古力莫" .. "] 你的魂量目前為【" .. killNum .. "】無法超過！");
                      return;
                  else
                      local targetDur_MIN = Item.GetData(targetItemIndex,CONST.道具_耐久);
                      local targetDur_MAX = Item.GetData(targetItemIndex,CONST.道具_最大耐久);
                      Item.SetData(targetItemIndex,CONST.道具_耐久, targetDur_MIN + keyNum);
                      Item.SetData(targetItemIndex,CONST.道具_最大耐久, targetDur_MAX + keyNum);
                      Char.SetData(player,CONST.CHAR_伤害数, killNum - keyNum);
                      Item.UpItem(player, targetSlot);
                      NLG.UpChar(player);
                      NLG.SystemMessage(player, "[" .. "古力莫" .. "] 魂魄轉換保養成功回復耐久" .. keyNum .. "！");
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
          if (targetItemIndex>0) then
              local killNum = Char.GetData(player,CONST.CHAR_伤害数);
              local tItemID = Item.GetData(targetItemIndex, CONST.道具_ID);
              local tItemName = Item.GetData(targetItemIndex, CONST.道具_名字);
              local tStrLv = EquipPlusStat(targetItemIndex, "E") or 0;
              if (tStrLv<7) then
                  NLG.SystemMessage(player, "[" .. "古力莫" .. "] 你選擇的裝備[" .. tItemName .. "]為[不可保養]！");
                  return;
              end
              local winMsg = "【魂魄轉換保養】\\n"
                                           .."═════════════════════\\n"
                                           .."正在設定耐久...\\n"
                                           .."\\n　　　　裝　備　名　稱：".. tItemName .."\\n"
                                           .."\\n　　　　當前擁有的魂量：".. killNum .."\\n"
                                           .."\\n請輸入回復的耐久量：\\n";
              NLG.ShowWindowTalked(player, self.maintainNPC, CONST.窗口_输入框, CONST.BUTTON_确定关闭, 11, winMsg);
          end

      else
                 return;
      end
    end
  end)


end


function EquipPlusStat( _ItemIndex, _StatTab, _StatValue )
	--  E-赋予，P- 喷漆
	local tStatTab = {}
	if type(_StatTab)=="nil" then
		--GetAll
		local tItemStat = tostring(Item.GetData(_ItemIndex, CONST.道具_自用参数));
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
		Item.SetData(_ItemIndex, CONST.道具_自用参数, tStat);
	elseif type(_StatTab)=="string" and type(_StatValue)=="nil" then
		--GetSub
		local tStatTab = EquipPlusStat(_ItemIndex) or {};
		for k,v in pairs(tStatTab) do
			if _StatTab==k then
				return tonumber(v);
			end
		end
		return nil;
	elseif type(_StatTab)=="string" then
		--SetSub
		local tStatTab = EquipPlusStat(_ItemIndex) or {};
		tStatTab[_StatTab]=_StatValue;
		EquipPlusStat(_ItemIndex, tStatTab);
	end
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
