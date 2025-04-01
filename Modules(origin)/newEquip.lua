local Module = ModuleBase:createModule('newEquip')

local mirageImage_List = {};
mirageImage_List[71048] = 130148;					--道具编号.形象编号.碇真嗣
mirageImage_List[71049] = 130149;					--道具编号.形象编号.綾波零
mirageImage_List[71050] = 130150;					--道具编号.形象编号.明日香
mirageImage_List[71051] = 130151;					--道具编号.形象编号.安茲·烏爾·恭
mirageImage_List[71052] = 130152;					--道具编号.形象编号.雅兒貝德
mirageImage_List[71053] = 130153;					--道具编号.形象编号.夏提雅
mirageImage_List[71054] = 130154;					--道具编号.形象编号.Saber
mirageImage_List[71055] = 130155;					--道具编号.形象编号.Archer
mirageImage_List[71056] = 130156;					--道具编号.形象编号.Lancer
mirageImage_List[71057] = 130157;					--道具编号.形象编号.八神庵
mirageImage_List[71058] = 130158;					--道具编号.形象编号.草薙京
mirageImage_List[71059] = 130159;					--道具编号.形象编号.利姆路
mirageImage_List[71060] = 130160;					--道具编号.形象编号.蜜莉姆
mirageImage_List[71061] = 130161;					--道具编号.形象编号.紅丸
mirageImage_List[71062] = 130162;					--道具编号.形象编号.朱菜


local MountItem = {
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=11, level=4 },	--劍士
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=12, level=6 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=13, level=8 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=14, level=10 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=15, level=15 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=21, level=4 },	--戰斧鬥士
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=22, level=6 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=23, level=8 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=24, level=10 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=25, level=15 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=31, level=4 },	--騎士
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=32, level=6 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=33, level=8 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=34, level=10 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=35, level=15 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=41, level=4 },	--弓箭手
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=42, level=6 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=43, level=8 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=44, level=10 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=45, level=15 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=51, level=4 },	--士兵
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=52, level=6 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=53, level=8 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=54, level=10 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=55, level=15 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=61, level=4 },	--傳教士
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=62, level=6 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=63, level=8 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=64, level=10 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=65, level=15 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=71, level=4 },	--魔術師
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=72, level=6 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=73, level=8 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=74, level=10 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=75, level=15 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=81, level=4 },	--咒術師
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=82, level=6 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=83, level=8 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=84, level=10 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=85, level=15 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=91, level=4 },	--封印師
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=92, level=6 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=93, level=8 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=94, level=10 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=95, level=15 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=101, level=4 },	--飼養師
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=102, level=6 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=103, level=8 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=104, level=10 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=105, level=15 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=111, level=4 },	--馴獸師
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=112, level=6 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=113, level=8 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=114, level=10 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=115, level=15 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=121, level=4 },	--盜賊
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=122, level=6 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=123, level=8 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=124, level=10 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=125, level=15 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=131, level=4 },	--巫師
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=132, level=6 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=133, level=8 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=134, level=10 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=135, level=15 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=141, level=4 },	--格鬥
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=142, level=6 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=143, level=8 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=144, level=10 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=145, level=15 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=151, level=4 },	--忍者
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=152, level=6 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=153, level=8 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=154, level=10 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=155, level=15 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=161, level=4 },	--舞者
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=162, level=6 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=163, level=8 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=164, level=10 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=165, level=15 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=411, level=4 },	--偵探
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=412, level=6 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=413, level=8 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=414, level=10 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=415, level=15 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=421, level=4 },	--仙人
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=422, level=6 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=423, level=8 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=424, level=10 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=425, level=15 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=431, level=4 },	--護士
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=432, level=6 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=433, level=8 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=434, level=10 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=435, level=15 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=441, level=4 },	--醫師
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=442, level=6 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=443, level=8 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=444, level=10 },
    { type=62, name="影鏡", defaultImage=402187, place=6, flags=0, job=445, level=15 },
}

-------------------------------------------------------------------------------------------------------------------------------------
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('ItemAttachEvent', Func.bind(self.itemAttachCallback, self))
  self:regCallback('ItemDetachEvent', Func.bind(self.itemDetachCallback, self))
  self:regCallback('LoginEvent', Func.bind(self.onLoginEvent, self));
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
	if (_Type==62) then
		--local imageId = Item.GetData(_ItemIndex, CONST.道具_自用参数);
		--local Image_buffer = string.split(imageId, "|")
		--change_imageId = tonumber(Image_buffer[1]) or 0;			--加成形象
		--orichange_imageId = tonumber(Image_buffer[2]) or 0;			--玩家原形象
		--print(change_imageId,orichange_imageId)
		local change_imageId = mirageImage_List[_ItemId] or 0;
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
	end
end

--卸下时
function setItemReEffectData(_CharIndex, _ItemIndex, _ItemId, _Type)
	if (_Type==62) then
		--local imageId = Item.GetData(_ItemIndex, CONST.道具_自用参数);
		--local Image_buffer = string.split(imageId, "|")
		--change_imageId = tonumber(Image_buffer[1]) or 0;			--加成形象
		--orichange_imageId = tonumber(Image_buffer[2]) or 0;			--玩家原形象
		--print(change_imageId,orichange_imageId)

		local change_imageId = mirageImage_List[_ItemId] or 0;
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
	end
end


--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
