local Module = ModuleBase:createModule('equipEffects')

local WeaponKindImage_List = {};
WeaponKindImage_List[900204] = 106452;					--道具编号.形象编号
WeaponKindImage_List[900205] = 106552;
WeaponKindImage_List[900206] = 106527;
WeaponKindImage_List[900207] = 106475;
WeaponKindImage_List[900208] = 106727;
WeaponKindImage_List[900209] = 106627;

local WingKindSpeed_List = {};
WingKindSpeed_List[607728] = 130;						--道具编号.30%移速
WingKindSpeed_List[607720] = 150;
WingKindSpeed_List[607721] = 150;
WingKindSpeed_List[607722] = 150;
WingKindSpeed_List[607723] = 150;

local MountKindDuration_List = {};
MountKindDuration_List[71058] = {101001,120000};		--道具编号.120秒
local MountItem = {
    { type=62, name="座騎", defaultImage=25044, place=6, flags=0, job=1, level=10 },
    { type=62, name="座騎", defaultImage=25044, place=6, flags=0, job=2011, level=10 },
    { type=62, name="座騎", defaultImage=25044, place=6, flags=0, job=2021, level=10 },
    { type=62, name="座騎", defaultImage=25044, place=6, flags=0, job=2041, level=10 },
    { type=62, name="座騎", defaultImage=25044, place=6, flags=0, job=2031, level=10 },
    { type=62, name="座騎", defaultImage=25044, place=6, flags=128, job=145, level=10 },
}

-------------------------------------------------------------------------------------------------------------------------------------
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('ItemAttachEvent', Func.bind(self.itemAttachCallback, self))
  self:regCallback('ItemDetachEvent', Func.bind(self.itemDetachCallback, self))
  self:regCallback('LoginEvent', Func.bind(self.onLoginEvent, self));
  self:regCallback('LoginGateEvent', Func.bind(self.onLoginEvent, self));

  self:regCallback('LoopEvent', Func.bind(self.qmloop, self))
  self:regCallback('mountloop', function(player)
    local MountOn = Char.GetTempData(player, 'MountOn') or -1;
    if (Char.GetData(player,CONST.对象_不遇敌开关)==1 and MountOn>=1) then
      if MountOn==2 then
        Char.SetTempData(player, 'MountOn',1);
      elseif MountOn==1 then
        Char.SetData(player,%对象_不遇敌开关%,0);
        Char.UnsetLoopEvent(player);
        Char.SetTempData(player, 'MountOn',0);
        NLG.UpChar(player);
        NLG.SystemMessage(player,'不遇敵關閉，請重新上下座騎！')
      end
    end
  end)

  for k, v in ipairs(MountItem) do
      Item.CreateNewItemType(v.type, v.name, v.defaultImage, v.place, v.flags)
      Item.SetItemTypeEquipLevelForJob(v.job, v.type, v.level)
  end

end

--装备接口
function Module:itemAttachCallback(charIndex, fromItemIndex)
      local itemId = Item.GetData(fromItemIndex, CONST.道具_ID);
      local type = Item.GetData(fromItemIndex, CONST.道具_类型);
      setItemEffectData(charIndex, fromItemIndex, itemId, type);
  return 0;
end

--卸下接口
function Module:itemDetachCallback(charIndex, fromItemIndex)
      local itemId = Item.GetData(fromItemIndex, CONST.道具_ID);
      local type = Item.GetData(fromItemIndex, CONST.道具_类型);
      setItemReEffectData(charIndex, fromItemIndex, itemId, type);
  return 0;
end

function Module:onLoginEvent(charIndex)
      if Char.IsDummy(charIndex) then
            return
      end
      local slotItemIndex_2 = Char.GetItemIndex(charIndex, 2);		--左手(2)
      if (slotItemIndex_2>0) then
        local itemId_2 = Item.GetData(slotItemIndex_2, CONST.道具_ID);
        local type_2 = Item.GetData(slotItemIndex_2, CONST.道具_类型);
        setItemEffectData(charIndex, slotItemIndex_2, itemId_2, type_2);
      end

      local slotItemIndex_5 = Char.GetItemIndex(charIndex, 5);		--饰品1(5)
      if (slotItemIndex_5>0) then
        local itemId_5 = Item.GetData(slotItemIndex_5, CONST.道具_ID);
        local type_5 = Item.GetData(slotItemIndex_5, CONST.道具_类型);
        setItemEffectData(charIndex, slotItemIndex_5, itemId_5, type_5);
      end

      local slotItemIndex_6 = Char.GetItemIndex(charIndex, 6);		--饰品2(6)
      if (slotItemIndex_6>0) then
        local itemId_6 = Item.GetData(slotItemIndex_6, CONST.道具_ID);
        local type_6 = Item.GetData(slotItemIndex_6, CONST.道具_类型);
        setItemEffectData(charIndex, slotItemIndex_6, itemId_6, type_6);
      end
end

------------------------------------------------------------------------------------------
--功能函数
--装备时
function setItemEffectData(_CharIndex, _ItemIndex, _ItemId, _Type)
	if (_Type==0 or _Type==1 or _Type==2 or _Type==3 or _Type==4 or _Type==5 or _Type==6) then
		--local imageId = Item.GetData(_ItemIndex, CONST.道具_自用参数);
		--local Image_buffer = string.split(imageId, "|")
		--change_imageId = tonumber(Image_buffer[1]) or 0;			--加成形象
		--orichange_imageId = tonumber(Image_buffer[2]) or 0;			--玩家原形象
		--print(change_imageId,orichange_imageId)
		local change_imageId = WeaponKindImage_List[_ItemId] or 0;
		if (change_imageId>0) then
			local playerImageId = Char.GetData(_CharIndex, CONST.对象_原始图档);
			--local tStat = change_imageId.."|" ..playerImageId;
			--Item.SetData(_ItemIndex, CONST.道具_自用参数, tStat);
			--Item.UpItem(_CharIndex, -1);
			--Char.SetData(_CharIndex, CONST.对象_形象, change_imageId);
			--Char.SetData(_CharIndex, CONST.对象_可视, change_imageId);
			Char.SetData(_CharIndex, CONST.对象_原形, change_imageId);
			NLG.UpChar(_CharIndex);
		end
	elseif (_Type==55) then			--头饰
		local change_speed = WingKindSpeed_List[_ItemId] or 0;
		if (change_speed>=100) then
			Char.SetData(_CharIndex, CONST.对象_移速, change_speed);
			NLG.UpChar(_CharIndex)
		end
	elseif (_Type==62) then			--座骑
		--不遇敌功能
		if (Char.GetData(_CharIndex,CONST.对象_香步数)>0) then
			NLG.SystemMessage(_CharIndex,"正在使用步步遇敵，無法啟用不遇敵！");
		elseif (Char.GetData(_CharIndex,CONST.对象_不遇敌开关)==1) then
			Char.SetData(_CharIndex,CONST.对象_不遇敌开关,0);
			Char.UnsetLoopEvent(_CharIndex);
			Char.SetTempData(_CharIndex, 'MountOn',0);
			NLG.UpChar(_CharIndex);
			NLG.SystemMessage(_CharIndex,"座騎狀態不遇敵關閉！");
		elseif (Char.GetData(_CharIndex,CONST.对象_不遇敌开关)==0) then
			if (Char.PartyNum(_CharIndex)==-1 or Char.GetPartyMember(_CharIndex,0)==_CharIndex) then
				Char.SetData(_CharIndex,CONST.对象_不遇敌开关,1);
				Char.SetLoopEvent(nil,'mountloop',_CharIndex, MountKindDuration_List[_ItemId][2]);	--修改驱魔持续时间，单位毫秒
				Char.SetTempData(_CharIndex, 'MountOn',2);
				NLG.UpChar(_CharIndex);
				NLG.SystemMessage(_CharIndex,"座騎狀態不遇敵開啟！");
			end
		end
		--騎上座騎
		local sitting_image = MountKindDuration_List[_ItemId][1]
		local MapId = Char.GetData(_CharIndex,CONST.对象_地图类型);
		local FloorId = Char.GetData(_CharIndex,CONST.对象_地图);
		local X = Char.GetData(_CharIndex,CONST.对象_X);
		local Y = Char.GetData(_CharIndex,CONST.对象_Y);
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

--卸下时
function setItemReEffectData(_CharIndex, _ItemIndex, _ItemId, _Type)
	if (_Type==0 or _Type==1 or _Type==2 or _Type==3 or _Type==4 or _Type==5 or _Type==6) then
		--local imageId = Item.GetData(_ItemIndex, CONST.道具_自用参数);
		--local Image_buffer = string.split(imageId, "|")
		--change_imageId = tonumber(Image_buffer[1]) or 0;			--加成形象
		--orichange_imageId = tonumber(Image_buffer[2]) or 0;			--玩家原形象
		--print(change_imageId,orichange_imageId)

		local change_imageId = WeaponKindImage_List[_ItemId] or 0;
		if (change_imageId>0) then
			local playerImageId = Char.GetData(_CharIndex, CONST.对象_原始图档);
			--local tStat = change_imageId.."|" ..playerImageId;
			--Item.SetData(_ItemIndex, CONST.道具_自用参数, tStat);
			--Item.UpItem(_CharIndex, -1);
			--Char.SetData(_CharIndex, CONST.对象_形象, orichange_imageId);
			--Char.SetData(_CharIndex, CONST.对象_可视, orichange_imageId);
			Char.SetData(_CharIndex, CONST.对象_原形, playerImageId);
			NLG.UpChar(_CharIndex);
		end
	elseif (_Type==55) then			--头饰
		Char.SetData(_CharIndex, CONST.对象_移速, 100);
		NLG.UpChar(_CharIndex)
		local ItemIndex = Char.GetItemIndex(_CharIndex, CONST.EQUIP_首饰1);
		if (ItemIndex > 0) then
			local itemId_new = Item.GetData(ItemIndex, CONST.道具_ID);
			local type_new = Item.GetData(ItemIndex, CONST.道具_类型);
			local change_speed_new = WingKindSpeed_List[itemId_new] or 0;
			if (type_new==55 and change_speed_new>=100 ) then
				Char.SetData(_CharIndex, CONST.对象_移速, change_speed_new);
				NLG.UpChar(_CharIndex)
			end
		end
	elseif (_Type==62) then			--座骑
		--不遇敌功能
		if (Char.GetData(_CharIndex,CONST.对象_不遇敌开关)==1) then
			Char.SetData(_CharIndex,CONST.对象_不遇敌开关,0);
			Char.UnsetLoopEvent(_CharIndex);
			Char.SetTempData(_CharIndex, 'MountOn',0);
			NLG.UpChar(_CharIndex);
			NLG.SystemMessage(_CharIndex,"座騎狀態不遇敵關閉！");
		end
		--下来座骑
		NLG.UpChar(_CharIndex)
	end
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
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
