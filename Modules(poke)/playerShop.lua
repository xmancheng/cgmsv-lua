---模块类
local Module = ModuleBase:createModule('playerShop')

local Open = 0;
local StreetPedlar = {
      { shopType=1, walkMode=0, shopName="小傑", shopDesc="強大的寵物", shopImage=105002, shopArea={map=1000,X=227,Y=86,dir=6,action=12},
         itemList={}, itemPriceList={},
         petList={314,314,314,314}, petPriceList={1000,1000,1000,1000} },
      { shopType=2, walkMode=0, shopName="凱茲", shopDesc="便宜的低等武器", shopImage=105028, shopArea={map=1000,X=231,Y=108,dir=4,action=11},
         itemList={18,18,18,18,18,22,22,22,22,22}, itemPriceList={800,800,800,800,800,1000,1000,1000,1000,1000},
         petList={}, petPriceList={} },
      { shopType=3, walkMode=0, shopName="西恩", shopDesc="便宜的低等武器", shopImage=105053, shopArea={map=1000,X=229,Y=108,dir=4,action=11},
         itemList={809,809,809,809,809,2002,2002,2002,2002,2002}, itemPriceList={1000,1000,1000,1000,1000,800,800,800,800,800},
         petList={}, petPriceList={} },
      { shopType=4, walkMode=0, shopName="小胖", shopDesc="便宜的料理", shopImage=105075, shopArea={map=1000,X=219,Y=91,dir=0,action=0},
         itemList={15203,15203,15203,15203,15203,15203,15203,15203,15203,15203}, itemPriceList={600,600,600,600,600,600,600,600,600,600},
         petList={}, petPriceList={} },
      { shopType=5, walkMode=0, shopName="功夫小子", shopDesc="強大的寵物", shopImage=105102, shopArea={map=1000,X=227,Y=88,dir=6,action=9},
         itemList={}, itemPriceList={},
         petList={321,321,321,321}, petPriceList={2000,2000,2000,2000} },
      { shopType=6, walkMode=0, shopName="貝依", shopDesc="好用的藥水", shopImage=105129, shopArea={map=1000,X=219,Y=89,dir=6,action=0},
         itemList={15607,15607,15607,15607,15607,15607,15607,15607,15607,15607}, itemPriceList={450,450,450,450,450,450,450,450,450,450},
         petList={}, petPriceList={} },
      { shopType=7, walkMode=0, shopName="熊男", shopDesc="強大的寵物", shopImage=105150, shopArea={map=1000,X=227,Y=90,dir=6,action=0},
         itemList={}, itemPriceList={},
         petList={722,722,722}, petPriceList={3000,3000,3000} },

      { shopType=8, walkMode=0, shopName="烏嚕", shopDesc="黏呼呼的寵物", shopImage=105251, shopArea={map=1000,X=240,Y=86,dir=6,action=6},
         itemList={2823,2823,2823}, itemPriceList={1400,1400,1400},
         petList={501,501,502,502}, petPriceList={200,200,500,500} },
      { shopType=9, walkMode=0, shopName="心美", shopDesc="我是制杖師", shopImage=105279, shopArea={map=1000,X=233,Y=114,dir=6,action=11},
         itemList={2404,2413,2447,2447,2449,2449,2449,2449,2449,2449}, itemPriceList={440,900,1600,1600,2200,2200,2200,2200,2200,2200},
         petList={}, petPriceList={} },
      { shopType=10, walkMode=0, shopName="艾咪", shopDesc="歡迎光臨", shopImage=105303, shopArea={map=1000,X=227,Y=108,dir=4,action=1},
         itemList={4821,4821,4821,4821,4821}, itemPriceList={1400,1400,1400,1400,1400},
         petList={}, petPriceList={} },
      { shopType=11, walkMode=0, shopName="梅古", shopDesc="歡迎光臨", shopImage=105330, shopArea={map=1000,X=226,Y=108,dir=4,action=1},
         itemList={4421,4421,4421,4421,4421}, itemPriceList={1400,1400,1400,1400,1400},
         petList={}, petPriceList={} },
      { shopType=12, walkMode=0, shopName="春麗", shopDesc="買雙新鞋好過年", shopImage=105352, shopArea={map=1000,X=224,Y=109,dir=6,action=6},
         itemList={5631,5631,5631,5631,5631,6031,6031,6031,6031,6031}, itemPriceList={1300,1300,1300,1300,1300,1200,1200,1200,1200,1200},
         petList={}, petPriceList={} },
      { shopType=13, walkMode=0, shopName="凱茵", shopDesc="大力出奇蹟", shopImage=105375, shopArea={map=1000,X=229,Y=112,dir=7,action=5},
         itemList={852,852,852,1658,1658,1658,6434,6434,6434,6434}, itemPriceList={3600,3600,3600,3400,3400,3400,1200,1200,1200,1200},
         petList={}, petPriceList={} },
      { shopType=14, walkMode=0, shopName="依露", shopDesc="歡迎光臨", shopImage=105402, shopArea={map=1000,X=228,Y=114,dir=6,action=1},
         itemList={3620,3620,3620,4020,4020,4020,5231,5231,5231,5231}, itemPriceList={960,960,9600,1000,1000,1000,1800,1800,1800,1800},
         petList={}, petPriceList={} },

      --{ shopType=29, walkMode=1, shopName="時雨", shopDesc="忍者神出鬼沒", shopImage=106477, shopArea={map=1000,X=230,Y=111,dir=6,action=1},
      --   itemList={18558,18559,18560,18562,18563,70200,70052,70052,70052}, itemPriceList={2000,2000,2000,2000,2000,3000,5000,7000,9000},
      --   petList={}, petPriceList={} },
}
------------------------------------------------
local FTime = os.time();			--时间表
tbl_StreetPedlarNPCIndex = tbl_StreetPedlarNPCIndex or {}
------------------------------------------------
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self))
  self:regCallback('LoopEvent', Func.bind(self.StreetPedlar_LoopEvent,self))
  self:regCallback('CharaStallSoldEvent', Func.bind(self.OnCharaStallSoldEventCallback, self))
  self:regCallback('CharaStallStartEvent', Func.bind(self.OnCharaStallStartEventCallback, self))
  self:regCallback('CharaStallEndEvent', Func.bind(self.OnCharaStallEndEventCallback, self))
  self:regCallback('CharaStallBrowseEvent', Func.bind(self.OnCharaStallBrowseEventCallback, self))

end

function Module:handleTalkEvent(charIndex,msg,color,range,size)
	if (msg=="/shop" and Open==0) then
		for k,v in pairs(StreetPedlar) do
			if (tbl_StreetPedlarNPCIndex[k] == nil) then
				tbl_StreetPedlarNPCIndex[k] = {}
			end
			local shopIndex = Char.CreateDummy()
			tbl_StreetPedlarNPCIndex[k] = shopIndex;
			Char.SetLoopEvent('./lua/Modules/playerShop.lua','StreetPedlar_LoopEvent',tbl_StreetPedlarNPCIndex[k], 1000);
			Char.SetData(shopIndex,CONST.对象_等级, NLG.Rand(10, 100));
			Char.SetData(shopIndex,CONST.对象_名字, v.shopName);
			Char.SetData(shopIndex,CONST.对象_形象, v.shopImage);
			Char.SetData(shopIndex,CONST.对象_原形, v.shopImage);
			Char.SetData(shopIndex,CONST.对象_方向, v.shopArea.dir);
			Char.Warp(shopIndex, 0, v.shopArea.map, v.shopArea.X, v.shopArea.Y);
			NLG.SetAction(shopIndex, v.shopArea.action);
			NLG.UpChar(shopIndex);
			if (#v.itemList>=1) then
				for i=1,#v.itemList do
					local ItemsetIndex = Data.ItemsetGetIndex(v.itemList[i]);
					local itemType = Data.ItemsetGetData(ItemsetIndex, CONST.ITEMSET_TYPE);
                    if (itemType==23 or itemType==43) then
					  local GoodsIndex = Char.GiveItem(shopIndex, v.itemList[i], 3);
					  Item.SetData(GoodsIndex,CONST.道具_已鉴定,1);
					  NLG.SortItem(shopIndex);
                    else
					  local GoodsIndex = Char.GiveItem(shopIndex, v.itemList[i], 1);
					  Item.SetData(GoodsIndex,CONST.道具_已鉴定,1);
                    end
					Item.UpItem(shopIndex,-1);
				end
			end
			if (#v.petList>=1) then
				for i=1,#v.petList do
					local petIndex= Char.AddPet(shopIndex, v.petList[i]);
					local arr_rank1 = Pet.GetArtRank(petIndex,CONST.PET_体成);
					local arr_rank2 = Pet.GetArtRank(petIndex,CONST.PET_力成);
					local arr_rank3 = Pet.GetArtRank(petIndex,CONST.PET_强成);
					local arr_rank4 = Pet.GetArtRank(petIndex,CONST.PET_敏成);
					local arr_rank5 = Pet.GetArtRank(petIndex,CONST.PET_魔成);
					local petname = arr_rank1..","..arr_rank2..","..arr_rank3..","..arr_rank4..","..arr_rank5;
					Char.SetData(petIndex,CONST.对象_名字, petname);
					Pet.UpPet(shopIndex,petIndex);
					local petName = Char.GetData(petIndex,CONST.对象_名字);
					local petImage = Char.GetData(petIndex,CONST.对象_形象);
					local petUUID = Pet.GetUUID(petIndex);
					if (v.walkMode==0) then
						local displayIndex = Char.CreateDummy()
						Char.SetData(displayIndex,CONST.对象_名字, petName);
						Char.SetData(displayIndex,CONST.对象_形象, petImage);
						Char.SetData(displayIndex,CONST.对象_原形, petImage);
						Char.SetData(displayIndex,CONST.对象_原始图档, petImage);
						Char.SetData(displayIndex,CONST.对象_方向, v.shopArea.dir);
						Char.SetData(displayIndex,CONST.对象_账号, petUUID);
						Char.Warp(displayIndex, 0, v.shopArea.map, v.shopArea.X+i, v.shopArea.Y);
						NLG.UpChar(displayIndex);
					end
				end
			end
			Stall.Start(shopIndex, v.shopName, v.shopDesc, v.itemPriceList, v.petPriceList)
			if (v.walkMode==1) then
				Char.SetData(shopIndex,CONST.对象_经验, v.shopArea.map);
				Char.SetData(shopIndex,CONST.对象_名色, 4);
				NLG.UpChar(shopIndex);
			end
		end
        Open = 1;
		return 0;
	elseif (msg=="/shop" and Open==1) then
		return 0;
	end
	return 1;
end

function StreetPedlar_LoopEvent(npc)
	local CTime = tonumber(os.date("%H",FTime));
	local shopIndex = npc;
	if (os.date("%X",os.time())=="19:59:59") then
		for k,v in pairs(StreetPedlar) do
			if (k==v.shopType) then
				Stall.End(shopIndex)
				--清空存货
				for i = 8,Char.GetData(shopIndex,CONST.对象_道具栏)-1 do
					local itemIndex = Char.GetItemIndex(shopIndex,i);
					if (itemIndex > -1) then
						Item.Kill(shopIndex,itemIndex,i);
					end
				end
				for i = 0,4 do
					local petIndex = Char.GetPet(shopIndex,i);
					local petUUID = Pet.GetUUID(petIndex);
					local FloorId = Char.GetData(shopIndex,CONST.对象_地图);
					local X = Char.GetData(shopIndex,CONST.对象_X);
					local Y = Char.GetData(shopIndex,CONST.对象_Y);
					local num,tbl = Obj.GetObject(0,FloorId,X+1+i,Y);
					for j=1,#tbl do
						local displayIndex = Obj.GetCharIndex(tbl[j]);
						if (Char.IsDummy(displayIndex) and Char.GetData(displayIndex,CONST.对象_形象)==petImage and Char.GetData(displayIndex,CONST.对象_账号)==petUUID) then
							Char.DelDummy(displayIndex);
						end
					end
					Char.DelSlotPet(shopIndex,i);
				end
				--重新补货
				if (#v.itemList>=1) then
					for i=1,#v.itemList do
					  local ItemsetIndex = Data.ItemsetGetIndex(v.itemList[i]);
					  local itemType = Data.ItemsetGetData(ItemsetIndex, CONST.ITEMSET_TYPE);
                      if (itemType==23 or itemType==43) then
					    local GoodsIndex = Char.GiveItem(shopIndex, v.itemList[i], 3);
					    Item.SetData(GoodsIndex,CONST.道具_已鉴定,1);
						NLG.SortItem(shopIndex);
                      else
					    local GoodsIndex = Char.GiveItem(shopIndex, v.itemList[i], 1);
					    Item.SetData(GoodsIndex,CONST.道具_已鉴定,1);
                      end
					  Item.UpItem(shopIndex,-1);
					end
				end
				if (#v.petList>=1) then
					for i=1,#v.petList do
						local petIndex= Char.AddPet(shopIndex, v.petList[i]);
						local arr_rank1 = Pet.GetArtRank(petIndex,CONST.PET_体成);
						local arr_rank2 = Pet.GetArtRank(petIndex,CONST.PET_力成);
						local arr_rank3 = Pet.GetArtRank(petIndex,CONST.PET_强成);
						local arr_rank4 = Pet.GetArtRank(petIndex,CONST.PET_敏成);
						local arr_rank5 = Pet.GetArtRank(petIndex,CONST.PET_魔成);
						local petname = arr_rank1..","..arr_rank2..","..arr_rank3..","..arr_rank4..","..arr_rank5;
						Char.SetData(petIndex,CONST.对象_名字, petname);
						Pet.UpPet(shopIndex,petIndex);
						local petName = Char.GetData(petIndex,CONST.对象_名字);
						local petImage = Char.GetData(petIndex,CONST.对象_形象);
						local petUUID = Pet.GetUUID(petIndex);
						if (v.walkMode==0) then
							local displayIndex = Char.CreateDummy()
							Char.SetData(displayIndex,CONST.对象_名字, petName);
							Char.SetData(displayIndex,CONST.对象_形象, petImage);
							Char.SetData(displayIndex,CONST.对象_原形, petImage);
							Char.SetData(displayIndex,CONST.对象_原始图档, petImage);
							Char.SetData(displayIndex,CONST.对象_方向, v.shopArea.dir);
							Char.SetData(displayIndex,CONST.对象_账号, petUUID);
							Char.Warp(displayIndex, 0, v.shopArea.map, v.shopArea.X+i, v.shopArea.Y);
							NLG.UpChar(displayIndex);
						end
					end
				end
				Stall.Start(shopIndex, v.shopName, v.shopDesc, v.itemPriceList, v.petPriceList)
				if (v.walkMode==1) then
					Char.SetData(shopIndex,CONST.对象_经验, v.shopArea.map);
					Char.SetData(shopIndex,CONST.对象_名色, 4);
					NLG.UpChar(shopIndex);
				end
			end
		end
	end
	local excess = math.random(1,10);
	for k,v in pairs(StreetPedlar) do
		if (k==v.shopType) then
			if (Char.GetData(shopIndex,CONST.对象_名色)==4 and excess>=7) then
				local dir = math.random(0, 7);
				local walk = 1;
				local X,Y = Char.GetLocation(shopIndex,dir);
				if (NLG.Walkable(0, Char.GetData(shopIndex,CONST.对象_经验), X, Y)==1) then
					NLG.SetAction(shopIndex,walk);
					NLG.WalkMove(shopIndex,dir);
					NLG.UpChar(shopIndex);
				end
				Stall.Start(shopIndex, v.shopName, v.shopDesc, v.itemPriceList, v.petPriceList)
			end
		end
	end
end

---摆摊有物品交易成功时触发的事件。
function Module:OnCharaStallSoldEventCallback(buyer, seller, itemIndex, petIndex, price)
---@param buyer  number 购买者的对象index，该值由Lua引擎传递给本函数。
---@param seller  number 售卖者的对象index，该值由Lua引擎传递给本函数。
---@param itemIndex  number 售出道具Index，该值由Lua引擎传递给本函数。
---@param petIndex  number 售出宠物Index，该值由Lua引擎传递给本函数。
---@param price  number 响应事件的道具的消费数量，该值由Lua引擎传递给本函数。
  if (itemIndex>0) then
    --local item_pos = Char.GetItemSlot(seller,itemIndex);
    --Stall.BuyItem(buyer, seller, item_pos)
    --Stall.GetItemPrice(seller, item_pos)
  elseif (petIndex>0) then
    local petImage = Char.GetData(petIndex,CONST.对象_形象);
    local petUUID = Pet.GetUUID(petIndex);
    local FloorId = Char.GetData(seller,CONST.对象_地图);
    local X = Char.GetData(seller,CONST.对象_X);
    local Y = Char.GetData(seller,CONST.对象_Y);
    for slot=0,4 do
      local num,tbl = Obj.GetObject(0,FloorId,X+1+slot,Y);
      for i=1,#tbl do
        local displayIndex = Obj.GetCharIndex(tbl[i]);
        if (Char.IsDummy(displayIndex) and Char.GetData(displayIndex,CONST.对象_形象)==petImage and Char.GetData(displayIndex,CONST.对象_账号)==petUUID) then
          Char.DelDummy(displayIndex);
        end
      end
    end
    --local pet_pos = Char.GetPetSlot(seller,petIndex);
    --Stall.BuyPet(buyer, seller, pet_pos)
    --Stall.GetPetPrice(seller, pet_pos)
  end


end

---摆摊开始事件
function Module:OnCharaStallStartEventCallback(seller)
---@param seller  number 售卖者的对象index，该值由Lua引擎传递给本函数。
end
---摆摊结束事件
function Module:OnCharaStallEndEventCallback(seller)
---@param seller  number 售卖者的对象index，该值由Lua引擎传递给本函数。
end

function Module:OnCharaStallBrowseEventCallback(buyer,seller)
---@param buyer  number 购买者的对象index，该值由Lua引擎传递给本函数。
---@param seller  number 售卖者的对象index，该值由Lua引擎传递给本函数。
end

Char.GetItemSlot = function(charIndex,itemIndex)
  for slot=8,27 do
    local tempIndex = Char.GetItemIndex(charIndex,slot);
    if (tempIndex == itemIndex) then
      return slot;
    end
  end
end

Char.GetPetSlot = function(charIndex,petIndex)
  for slot=0,4 do
    local tempIndex = Char.GetPet(charIndex,slot);
    if (tempIndex == petIndex) then
      return slot;
    end
  end
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
