---模块类
local Module = ModuleBase:createModule('playerShop')

local Open = 0;
local StreetPedlar = {
      { shopType=1, shopName="小傑", shopDesc="強大的寵物", shopImage=105002, shopArea={map=1000,X=227,Y=86,dir=6,action=12},
         itemList={}, itemPriceList={},
         petList={314,314,314,314}, petPriceList={1000,1000,1000,1000} },
      { shopType=2, shopName="凱茲", shopDesc="便宜的低等武器", shopImage=105028, shopArea={map=1000,X=231,Y=108,dir=4,action=11},
         itemList={18,18,18,18,18,22,22,22,22,22}, itemPriceList={800,800,800,800,800,1000,1000,1000,1000,1000},
         petList={}, petPriceList={} },
      { shopType=3, shopName="西恩", shopDesc="便宜的低等武器", shopImage=105053, shopArea={map=1000,X=229,Y=108,dir=4,action=11},
         itemList={809,809,809,809,809,2002,2002,2002,2002,2002}, itemPriceList={1000,1000,1000,1000,1000,800,800,800,800,800},
         petList={}, petPriceList={} },
      { shopType=4, shopName="小胖", shopDesc="便宜的料理", shopImage=105075, shopArea={map=1000,X=219,Y=91,dir=0,action=0},
         itemList={15203,15203,15203,15203,15203,15203,15203,15203,15203,15203}, itemPriceList={600,600,600,600,600,600,600,600,600,600},
         petList={}, petPriceList={} },
      { shopType=5, shopName="功夫小子", shopDesc="強大的寵物", shopImage=105102, shopArea={map=1000,X=227,Y=88,dir=6,action=9},
         itemList={}, itemPriceList={},
         petList={321,321,321,321}, petPriceList={2000,2000,2000,2000} },
      { shopType=6, shopName="貝依", shopDesc="好用的藥水", shopImage=105129, shopArea={map=1000,X=219,Y=89,dir=6,action=0},
         itemList={15607,15607,15607,15607,15607,15607,15607,15607,15607,15607}, itemPriceList={450,450,450,450,450,450,450,450,450,450},
         petList={}, petPriceList={} },
      { shopType=7, shopName="熊男", shopDesc="強大的寵物", shopImage=105150, shopArea={map=1000,X=227,Y=90,dir=6,action=0},
         itemList={}, itemPriceList={},
         petList={722,722,722}, petPriceList={3000,3000,3000} },

      { shopType=8, shopName="烏嚕", shopDesc="黏呼呼的寵物", shopImage=105251, shopArea={map=1000,X=240,Y=86,dir=6,action=6},
         itemList={2823,2823,2823}, itemPriceList={1400,1400,1400},
         petList={501,501,502,502}, petPriceList={200,200,500,500} },
      { shopType=9, shopName="心美", shopDesc="我是制杖師", shopImage=105279, shopArea={map=1000,X=233,Y=114,dir=6,action=11},
         itemList={2404,2413,2447,2447,2449,2449,2449,2449,2449,2449}, itemPriceList={440,900,1600,1600,2200,2200,2200,2200,2200,2200},
         petList={}, petPriceList={} },
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
  MarketNPC = self:NPC_createNormal('假人商店補貨', 99262, { map = 777, x = 34, y = 35, direction = 0, mapType = 0 })
  Char.SetLoopEvent('./lua/Modules/playerShop.lua','StreetPedlar_LoopEvent',MarketNPC, 1000);
  self:NPC_regWindowTalkedEvent(MarketNPC, function(npc, player, _seqno, _select, _data)
  end)
  self:NPC_regTalkedEvent(MarketNPC, function(npc, player)
    return
  end)

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
					local GoodsIndex = Char.GiveItem(shopIndex, v.itemList[i], 3);
					Item.SetData(GoodsIndex,CONST.道具_已鉴定,1);
					Item.UpItem(shopIndex,-1);
					NLG.SortItem(shopIndex);
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
			Stall.Start(shopIndex, v.shopName, v.shopDesc, v.itemPriceList, v.petPriceList)
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
	if (os.date("%X",os.time())=="19:59:59") then
		for k,v in pairs(StreetPedlar) do
			if (k==v.shopType) then
				local shopIndex = tbl_StreetPedlarNPCIndex[k];
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
						local GoodsIndex = Char.GiveItem(shopIndex, v.itemList[i], 3);
						Item.SetData(GoodsIndex,CONST.道具_已鉴定,1);
						Item.UpItem(shopIndex,-1);
						NLG.SortItem(shopIndex);
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


--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
