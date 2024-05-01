---模块类
local Module = ModuleBase:createModule('sprayPaint')

local sprayList = {
    500215,500216,500217,500218,500219,
    500220,500221,500222,500223,500224,
    500225,500226,500227,500228,500229,
    500230,500231,500232,500233,500234,
    500235,500236,500237,500238,500239,
    500240,500241,500242,500243,500244,
    500245,500246,500247,500248,500249,
}

local EquipType = {}
function ChooseType(sprayType,targetType)
    local EquipType = {};
    if sprayType==0 then            --头
        EquipType={ {"帽子",9}, {"頭盔",8} };
    elseif sprayType==1 then    --身
        EquipType={ {"衣服",11}, {"鎧甲",10}, {"長袍",12} };
    elseif sprayType==2 then    --右
        if (targetType==0) then TypeName="劍";
        elseif (targetType==1) then TypeName="斧";
        elseif (targetType==2) then TypeName="槍";
        elseif (targetType==3) then TypeName="杖";
        elseif (targetType==4) then TypeName="弓";
        elseif (targetType==5) then TypeName="小刀";
        elseif (targetType==6) then TypeName="迴力鏢";
        end
        EquipType={ {TypeName,targetType} };
    elseif sprayType==4 then    --足
        EquipType={ {"鞋子",14}, {"靴子",13} };
    elseif sprayType==5 then    --饰
        EquipType={ {"手環",15}, {"樂器",16}, {"項鍊",17}, {"戒指",18}, {"頭帶",19}, {"耳環",20}, {"護身符",21} };
    end
    return EquipType;
end

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('ItemDurabilityChangedEvent', Func.bind(self.OnItemDurabilityChangedEventCallback, self));
  self:regCallback('ItemString', Func.bind(self.sprayTools, self),"LUA_useProFilm");
  self.paintingNPC = self:NPC_createNormal('特殊噴漆鍍膜師傅', 14682, { x = 36, y = 31, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.paintingNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local msg = "\\n@c【裝備噴漆鍍膜】" ..	"\\n\\n噴漆鍍膜後的裝備可以避免致死打擊、沉重打擊所造成的高耐久損耗。當完成同系列上膜的套裝，獲得套裝能力素質加成效果。\\n※注意：鍍膜後將無法進行賦予強化"
                                                                               ..	"\\n\\n確定使用 噴漆工具，為 武器、防具 噴漆鍍膜嗎？";
        NLG.ShowWindowTalked(player, self.paintingNPC, CONST.窗口_信息框, CONST.按钮_确定关闭, 1, msg);
    end
    return
  end)

  self:NPC_regWindowTalkedEvent(self.paintingNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --喷漆工具
    local ItemIndex =Char.HaveItemID(player, ItemID);
    local ItemSlot = Char.FindItemId(player, ItemID);
    local sprayType = Item.GetData(ItemIndex, CONST.道具_子参一);
    local sprayImage = Item.GetData(ItemIndex,CONST.道具_子参二);
    --目标装备
    local targetSlot = sprayType;      --装备位置格
    local targetItemIndex = Char.GetItemIndex(player,targetSlot);
    local targetType = Item.GetData(targetItemIndex, CONST.道具_类型);
    local targetName = Item.GetData(targetItemIndex, CONST.道具_名字);
    local spraySkin = tonumber(EquipPlusStat(targetItemIndex, "P")) or 0;
    --print(ItemSlot,sprayType,sprayImage,targetName,spraySkin)
    print(data)
    if select > 0 then
      if (targetItemIndex<0) then
                 NLG.SystemMessage(player, "[系統]請先穿上對應部位的裝備！");
                 return;
      elseif (targetType>=65 and targetType<=70) then
                 NLG.SystemMessage(player, "[系統]副武器無法進行噴漆鍍膜！");
                 return;
      end
      if (seqno == 1 and select == CONST.按钮_确定 and spraySkin>0)  then
                 local msg = "\\n@c【裝備噴漆鍍膜】" ..	"\\n\\n\\n此裝備已經進行過噴漆鍍膜\\n\\n\\n選『是』確定以新的噴漆覆蓋鍍膜\\n\\n";
                 NLG.ShowWindowTalked(player, self.paintingNPC, CONST.窗口_信息框, CONST.按钮_是否, 11, msg);
      elseif (seqno == 1 and select == CONST.按钮_确定)  then
                 EquipType = ChooseType(sprayType,targetType);
                 local msg = "2\\n@c【裝備噴漆鍍膜】\\n↓決定噴漆可轉化的裝備類型↓\\n";
                 for i=1,#EquipType do
                                  msg = msg .. EquipType[i][1].."\\n"
                 end
                 NLG.ShowWindowTalked(player, self.paintingNPC, CONST.窗口_选择框, CONST.BUTTON_关闭, 12, msg);
      elseif (seqno == 11 and select == CONST.按钮_是)  then
                 EquipType = ChooseType(sprayType,targetType);
                 local msg = "2\\n@c【裝備噴漆鍍膜】\\n↓決定噴漆可轉化的裝備類型↓\\n";
                 for i=1,#EquipType do
                                  msg = msg .. EquipType[i][1].."\\n"
                 end
                 NLG.ShowWindowTalked(player, self.paintingNPC, CONST.窗口_选择框, CONST.BUTTON_关闭, 12, msg);
      else
                 return;
      end

    else
      --喷漆操作
      if (seqno == 12 and select == CONST.按钮_关闭) then
                 return;
      elseif (seqno == 12 and data>0) then
          if (targetItemIndex ~=nil) then
                 Char.DelItem(player, ItemID, 1);
                 if EquipPlusStat(targetItemIndex)==nil then Item.SetData(targetItemIndex, CONST.道具_鉴前名, targetName); end
                 EquipPlusStat(targetItemIndex, "P", sprayImage);
                 Item.SetData(targetItemIndex,CONST.道具_图, sprayImage);
                 Item.SetData(targetItemIndex,CONST.道具_类型, EquipType[data][2]);
                 Item.UpItem(targetItemIndex, targetSlot);
                 NLG.SystemMessage(player, "[系統]請卸下重新裝備！");
                 NLG.UpChar(player);
          end
      else
                 return;
      end
    end
  end)


end


function Module:sprayTools(charIndex,targetIndex,itemSlot)
    ItemID = Item.GetData(Char.GetItemIndex(charIndex,itemSlot),0);
    local ItemIndex = Char.GetItemIndex(charIndex,itemSlot);
    local sprayName = Item.GetData(ItemIndex, CONST.道具_名字);
    local sprayType = Item.GetData(ItemIndex, CONST.道具_子参一);
    local sprayImage = Item.GetData(ItemIndex,CONST.道具_子参二);
    local targetSlot= sprayType;
    if (Char.GetItemIndex(charIndex,targetSlot)>0) then
             targetName = Item.GetData(Char.GetItemIndex(charIndex,targetSlot), CONST.道具_名字);
    else
             targetName = "空";
    end
    local msg = "\\n@c【裝備噴漆鍍膜】" ..	"\\n\\n噴漆鍍膜後的裝備可以避免致死打擊、沉重打擊所造成的高耐久損耗。當完成同系列上膜的套裝，獲得套裝能力素質加成效果。\\n※注意：鍍膜後將無法進行賦予強化"
                                                                           ..	"\\n\\n確定使用 "..sprayName.." 工具，在 "..targetName.." 裝備上面噴漆鍍膜嗎？";
    NLG.ShowWindowTalked(charIndex, self.paintingNPC, CONST.窗口_信息框, CONST.按钮_确定关闭, 1, msg);
    return 1;
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

---ItemDurabilityChangedEvent的回调函数
---[@group NL.RegItemDurabilityChangedEvent]
---@param itemIndex number ItemIndex
---@param oldDurability number 原来的耐久
---@param newDurability number 变化后的耐久
---@param value number 变化值
---@param mode number 0正常战斗损耗（1-2耐久），1致死打击（-50%当前耐久），2沉重打击（-10%最大耐久），3装备破坏技能
---@return number @新的mode，用于mode为1、2时返回0取消对应提示
function OnItemDurabilityChangedEventCallback(itemIndex, oldDurability, newDurability, value, mode)
    local itemName = Item.GetData(itemIndex, CONST.道具_名字);
    local spraySkin = tonumber(EquipPlusStat(targetItemIndex, "P")) or 0;
    local player = Item.GetOwner(itemIndex)
    if mode== 1 or mode==2 then
          table.forEach(sprayList, function(e)
                    if (spraySkin==e) then
                              NLG.Say(player, -1, ""..Char.GetData(player,CONST.对象_名字).." 的 ".. itemName .." 因為塗料受到特殊保護！",CONST.颜色_黄色, CONST.字体_中);
                              return 0;
                    end
          end)
    end
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
