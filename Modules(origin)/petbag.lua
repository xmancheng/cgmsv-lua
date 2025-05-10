---模块类
local Module = ModuleBase:createModule('petbag')

local petbag_list = {
    1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,
    1,1,1,1,1,1,1,1,
}

Module:addMigration(1, "migrate2", function()
  local res = SQL.QueryEx("select * from lua_petdata");
  if res.rows then
    for i, row in ipairs(res.rows) do
      pcall(function()
        local data = JSON.decode(row.data);
        local regId = row.id;
        local cdkey = row.cdkey;
        if data.petbag and data.petbagIndex then
          for i = 1, 5 do		--5页宠物库
            for j = 1, 8 do		--每页8隻宠物
              if data.petbag[i] and data.petbag[i][j] then
                SQL.QueryEx("insert into hook_charaext (cdKey, regNo, sKey, val, valType) values (?,?,?,?,?,?)",
                  cdkey, regId, string.format("petbag-%d-%d", i, j), JSON.encode(data.petbag[i][j]), 0);
              end
            end
          end
          --SQL.QueryEx("insert into hook_charaext (cdKey, regNo, sKey, val, valType) values (?,?,?,?,?,?)",
          --  cdkey, regId, "petbag-index", data.petbagIndex, 1);
        end
      end)
    end
  end
end)

local petFields={
  CONST.对象_类型,
  CONST.对象_形象,
  CONST.对象_原形,
  CONST.对象_MAP,
  CONST.对象_地图,
  CONST.对象_X,
  CONST.对象_Y,
  CONST.对象_方向,
  CONST.对象_等级,
  CONST.对象_血,
  CONST.对象_魔,
  CONST.对象_体力,
  CONST.对象_力量,
  CONST.对象_强度,
  CONST.对象_速度,
  CONST.对象_魔法,
  CONST.对象_运气,
  CONST.对象_种族,
  CONST.对象_地属性,
  CONST.对象_水属性,
  CONST.对象_火属性,
  CONST.对象_风属性,
  CONST.对象_抗毒,
  CONST.对象_抗睡,
  CONST.对象_抗石,
  CONST.对象_抗醉,
  CONST.对象_抗乱,
  CONST.对象_抗忘,
  CONST.对象_必杀,
  CONST.对象_反击,
  CONST.对象_命中,
  CONST.对象_闪躲,
  CONST.对象_道具栏,
  CONST.对象_技能栏,
  CONST.对象_死亡数,
  CONST.对象_伤害数,
  CONST.对象_杀宠数,
  CONST.对象_占卜时间,
  CONST.对象_受伤,
  CONST.对象_移间,
  CONST.对象_循时,
  CONST.对象_经验,
  CONST.对象_升级点,
  CONST.对象_图类,
  CONST.对象_名色,
  CONST.对象_掉魂,
  CONST.对象_原始图档,
  CONST.对象_名字,
  CONST.对象_最大血,
  CONST.对象_最大魔,
  CONST.对象_攻击力,
  CONST.对象_防御力,
  CONST.对象_敏捷,
  CONST.对象_精神,
  CONST.对象_回复,
  CONST.对象_获得经验,
  CONST.对象_EnemyBaseId,
  CONST.PET_DepartureBattleStatus,
  CONST.PET_PetID,
  CONST.PET_技能栏,
  CONST.对象_名色,
  CONST.宠物_获取时等级,
  CONST.宠物_基础忠诚,
  CONST.宠物_捕捉难度,
  CONST.宠物_忠诚,
}

-- NOTE 宠物成长属性key
local petRankFields={
  CONST.PET_体成,
  CONST.PET_力成,
  CONST.PET_强成,
  CONST.PET_敏成,
  CONST.PET_魔成,
}

--------------------------------------------------------------------
local function calcWarp()
  local page = math.modf(#petbag_list / 8) + 1
  local remainder = math.fmod(#petbag_list, 8)
  return page, remainder
end

--远程按钮UI呼叫
function Module:petbagInfo(npc, player)
          local winButton = CONST.按钮_关闭;
          local msg = "2\\n　　　　　　　　【寵物雲端倉庫】\\n\\n"
               .. "　　◎提取存放的寵物\\n\\n"
               .. "　　◎寄存身上的寵物\\n\\n";
          NLG.ShowWindowTalked(player, self.petBankNPC, CONST.窗口_选择框, CONST.按钮_关闭, 777, msg);
end

--------------------------------------------------------------------
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  --self:regCallback('LoginEvent', Func.bind(self.onLoginEvent, self));
  self.petBankNPC = self:NPC_createNormal('寵物雲端倉庫', 14682, { x = 38, y = 30, mapType = 0, map = 777, direction = 6 });
  self:NPC_regWindowTalkedEvent(self.petBankNPC, function(npc, player, _seqno, _select, _data)
    local column = tonumber(_data)
    local page = tonumber(_seqno)
    local warpPage = page;
    --判断使用几页格库
    --[[local petbag_list = {}
    for bagslot = 1, 5 do		--5页宠物库
      for petslot = 1, 8 do
        local bagslotIndex = tonumber(bagslot);
        local petbagPet = Char.GetExtData(player, string.format("petbag-%d-%d", bagslotIndex, petslot));
        pcall(function()
          if petbagPet then
            table.insert(petbag_list, string.format("petbag-%d-%d", bagslot, petslot));
          end
        end)
      end
    end]]
    local winMsg = "1\\n　　　　　　　　【寵物雲端倉庫】\\n"
    local winButton = CONST.按钮_关闭;
    local totalPage, remainder = calcWarp()
    --上页16 下页32 关闭/取消2
    if _select > 0 then
      if _select == CONST.按钮_关闭 then
          if (page==777 or page==778) then
              return
          end
      elseif _select == CONST.按钮_是 then
          if (page>=2001 and page<3000) then
              if (Char.PetNum(player)==5) then
                 NLG.SystemMessage(player,"[系統]寵物欄位置已滿。");
                 return;
              end

              local petNo = petNo;
              local seqno = page - 2000;
              local petbagIndex = tonumber(seqno);
              if petbagIndex < 1 or petbagIndex > 5 then
                NLG.SystemMessage(player, '無效寵物格庫')
                return;
              end
              local petData = {};
              local petbagPet = Char.GetExtData(player, string.format("petbag-%d-%d", petbagIndex, petNo));
              pcall(function()
                if petbagPet then
                  petbagPet = JSON.decode(petbagPet);
                end
              end)
              if type(petbagPet) == 'table' then
                petData = petbagPet
                local EmptySlot = Char.GetPetEmptySlot(player);
                local enemyId = petbagPet.attr[tostring(CONST.PET_PetID)];
                Char.GivePet(player, enemyId, 0);
                local petIndex = Char.GetPet(player,EmptySlot);
                self:insertPetData(petIndex,petData)
                Pet.UpPet(player, petIndex);
                NLG.UpChar(player);
              end
              Char.SetExtData(player, string.format("petbag-%d-%d", petbagIndex, petNo), nil);
              return;
          else
              return;
          end
      elseif _select == CONST.按钮_否 then
          if (page>=2001 and page<3000) then
              --第一页格库
              for slot = 1, 8 do
                local petbagIndex = tonumber(1);
                --Char.SetExtData(player, "petbag-index", petbagIndex);
                local petbagPet = Char.GetExtData(player, string.format("petbag-%d-%d", petbagIndex, slot));
                pcall(function()
                  if petbagPet then
                    petbagPet = JSON.decode(petbagPet);
                  end
                end)
                if type(petbagPet) == 'table' then
                  local enemyId = petbagPet.attr[tostring(CONST.PET_PetID)];
                  local Goal_name = petbagPet.attr[tostring(CONST.对象_名字)];
                  winMsg = winMsg .. "　　格庫["..slot.."]號位: " .. Goal_name .."\\n";
                else
                  winMsg = winMsg .. "　　格庫["..slot.."]號位: 空\\n";
                end
              end
              NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.按钮_下取消, 1000+1, winMsg);
              return
          else
              return
          end
      end
      if (warpPage>=3001) then	--寄存
        local warpPage = warpPage - 3000;
        if _select == CONST.BUTTON_下一页 then
          warpPage = warpPage + 1
          if (warpPage == totalPage) or ((warpPage == (totalPage - 1) and remainder == 0)) then
            winButton = CONST.BUTTON_上取消
          else
            winButton = CONST.BUTTON_上下取消
          end
        elseif _select == CONST.BUTTON_上一页 then
          warpPage = warpPage - 1
          if warpPage == 1 then
            winButton = CONST.BUTTON_下取消
          else
            winButton = CONST.BUTTON_上下取消
          end
        elseif _select == 2 then
          warpPage = 1;
          return;
        end
        print(warpPage)
        local count = 8 * (warpPage - 1)
        if warpPage == totalPage then
          local petbagIndex = tonumber(warpPage);
          if petbagIndex < 1 or petbagIndex > 5 then
              NLG.SystemMessage(player, '無效寵物格庫')
              return;
          end
          --Char.SetExtData(player, "petbag-index", petbagIndex);
          for i = 1, 8  do
            local petbagPet = Char.GetExtData(player, string.format("petbag-%d-%d", petbagIndex, i));
            pcall(function()
              if petbagPet then
                petbagPet = JSON.decode(petbagPet);
              end
            end)
            if type(petbagPet) == 'table' then
              local enemyId = petbagPet.attr[tostring(CONST.PET_PetID)];
              local Goal_name = petbagPet.attr[tostring(CONST.对象_名字)];
              winMsg = winMsg .. "　　格庫["..i+count.."]號位: " .. Goal_name .."\\n";
            else
              winMsg = winMsg .. "　　格庫["..i+count.."]號位: 空\\n";
            end
          end
        else
          local petbagIndex = tonumber(warpPage);
          if petbagIndex < 1 or petbagIndex > 5 then
              NLG.SystemMessage(player, '無效寵物格庫')
              return;
          end
          --Char.SetExtData(player, "petbag-index", petbagIndex);
          for i = 1, 8  do
            local petbagPet = Char.GetExtData(player, string.format("petbag-%d-%d", petbagIndex, i));
            pcall(function()
              if petbagPet then
                petbagPet = JSON.decode(petbagPet);
              end
            end)
            if type(petbagPet) == 'table' then
              local enemyId = petbagPet.attr[tostring(CONST.PET_PetID)];
              local Goal_name = petbagPet.attr[tostring(CONST.对象_名字)];
              winMsg = winMsg .. "　　格庫["..i+count.."]號位: " .. Goal_name .."\\n";
            else
              winMsg = winMsg .. "　　格庫["..i+count.."]號位: 空\\n";
            end
          end
        end
        NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, winButton, 3000+warpPage, winMsg);
      elseif (warpPage>=1001 and warpPage<3000) then	--提取
        local warpPage = warpPage - 1000;
        if _select == CONST.BUTTON_下一页 then
          warpPage = warpPage + 1
          if (warpPage == totalPage) or ((warpPage == (totalPage - 1) and remainder == 0)) then
            winButton = CONST.BUTTON_上取消
          else
            winButton = CONST.BUTTON_上下取消
          end
        elseif _select == CONST.BUTTON_上一页 then
          warpPage = warpPage - 1
          if warpPage == 1 then
            winButton = CONST.BUTTON_下取消
          else
            winButton = CONST.BUTTON_上下取消
          end
        elseif _select == 2 then
          warpPage = 1;
          return;
        end
        local count = 8 * (warpPage - 1)
        if warpPage == totalPage then
          local petbagIndex = tonumber(warpPage);
          if petbagIndex < 1 or petbagIndex > 5 then
              NLG.SystemMessage(player, '無效寵物格庫')
              return;
          end
          --Char.SetExtData(player, "petbag-index", petbagIndex);
          for i = 1, 8  do
            local petbagPet = Char.GetExtData(player, string.format("petbag-%d-%d", petbagIndex, i));
            pcall(function()
              if petbagPet then
                petbagPet = JSON.decode(petbagPet);
              end
            end)
            if type(petbagPet) == 'table' then
              local enemyId = petbagPet.attr[tostring(CONST.PET_PetID)];
              local Goal_name = petbagPet.attr[tostring(CONST.对象_名字)];
              winMsg = winMsg .. "　　格庫["..i+count.."]號位: " .. Goal_name .."\\n";
            else
              winMsg = winMsg .. "　　格庫["..i+count.."]號位: 空\\n";
            end
          end
        else
          local petbagIndex = tonumber(warpPage);
          if petbagIndex < 1 or petbagIndex > 5 then
              NLG.SystemMessage(player, '無效寵物格庫')
              return;
          end
          --Char.SetExtData(player, "petbag-index", petbagIndex);
          for i = 1, 8  do
            local petbagPet = Char.GetExtData(player, string.format("petbag-%d-%d", petbagIndex, i));
            pcall(function()
              if petbagPet then
                petbagPet = JSON.decode(petbagPet);
              end
            end)
            if type(petbagPet) == 'table' then
              local enemyId = petbagPet.attr[tostring(CONST.PET_PetID)];
              local Goal_name = petbagPet.attr[tostring(CONST.对象_名字)];
              winMsg = winMsg .. "　　格庫["..i+count.."]號位: " .. Goal_name .."\\n";
            else
              winMsg = winMsg .. "　　格庫["..i+count.."]號位: 空\\n";
            end
          end
        end
        NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, winButton, 1000+warpPage, winMsg);
      end
    else
      --print(column)
      if (page==777 and column==1) then			--提取
        local warpPage = 1;
        local count = 8 * (warpPage - 1) + column;
        --print(count)

        --第一页格库
        local petbagIndex = tonumber(warpPage);
        if petbagIndex < 1 or petbagIndex > 5 then
            NLG.SystemMessage(player, '無效寵物格庫')
            return;
        end
        --Char.SetExtData(player, "petbag-index", petbagIndex);
        for slot = 1, 8 do
          local petbagPet = Char.GetExtData(player, string.format("petbag-%d-%d", petbagIndex, slot));
          pcall(function()
            if petbagPet then
              petbagPet = JSON.decode(petbagPet);
            end
          end)
          if type(petbagPet) == 'table' then
            local enemyId = petbagPet.attr[tostring(CONST.PET_PetID)];
            local Goal_name = petbagPet.attr[tostring(CONST.对象_名字)];
            winMsg = winMsg .. "　　格庫["..slot.."]號位: " .. Goal_name .."\\n";
          else
            winMsg = winMsg .. "　　格庫["..slot.."]號位: 空\\n";
          end
        end
        NLG.ShowWindowTalked(player, self.petBankNPC, CONST.窗口_选择框, CONST.按钮_下取消, 1000+warpPage, winMsg);
      elseif (page==777 and column==3) then		--寄存
          local msg = "　　　　　　　　【寵物雲端倉庫】\\n"
          local msg = "2|\\n選擇要寄存雲端電腦的寵物:\\n\\n";
          for petSlot=0,4 do
                local petIndex = Char.GetPet(player,petSlot);
                if(petIndex<0)then
                      msg = msg .. "空\\n";
                else
                      msg = msg .. ""..Char.GetData(petIndex,CONST.对象_名字).."\\n";
                end
          end
          NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.按钮_关闭, 778, msg);
      elseif (page==778) then
          updatedPetdata = column-1;
          local petIndex = Char.GetPet(player,updatedPetdata);
          if (petIndex<0) then
            NLG.SystemMessage(player, '[系統]選擇的位置沒有寵物。')
            return;
          end
          --第一页格库
          local petbagIndex = tonumber(1);
          --Char.SetExtData(player, "petbag-index", petbagIndex);
          for slot = 1, 8 do
            local petbagPet = Char.GetExtData(player, string.format("petbag-%d-%d", petbagIndex, slot));
            pcall(function()
              if petbagPet then
                petbagPet = JSON.decode(petbagPet);
              end
            end)
            if type(petbagPet) == 'table' then
              local enemyId = petbagPet.attr[tostring(CONST.PET_PetID)];
              local Goal_name = petbagPet.attr[tostring(CONST.对象_名字)];
              winMsg = winMsg .. "　　格庫["..slot.."]號位: " .. Goal_name .."\\n";
            else
              winMsg = winMsg .. "　　格庫["..slot.."]號位: 空\\n";
            end
          end
          NLG.ShowWindowTalked(player, self.petBankNPC, CONST.窗口_选择框, CONST.按钮_下取消, 3000+1, winMsg);
      elseif (page>=3001) then
          local seqno = page - 3000;
          local petbagIndex = tonumber(seqno);
          --Char.SetExtData(player, "petbag-index", petbagIndex);
          local petbagPet = Char.GetExtData(player, string.format("petbag-%d-%d", petbagIndex, column));
          pcall(function()
            if petbagPet then
              petbagPet = JSON.decode(petbagPet);
            end
          end)
          if type(petbagPet) == 'table' then
            NLG.SystemMessage(player, '[系統]格庫已經有寄存。')
            return;
          end
          local updatedPetdata = updatedPetdata;
          local petIndex = Char.GetPet(player,updatedPetdata);
          local petProfile = self:extractPetData(petIndex)
          --Char.SetExtData(player, "petbag-index", seqno);
          local onpetBagIndex = petbagIndex;
          local r = Char.DelSlotPet(player, updatedPetdata);
          Char.SetExtData(player, string.format("petbag-%d-%d", onpetBagIndex, column), JSON.encode(petProfile));
      elseif (page>=1001 and page<3000) then
          local seqno = page - 1000;
          petNo = column;
          local petbagIndex = tonumber(seqno);
          Char.SetExtData(player, "petbag-index", petbagIndex);

          local petbagPet = Char.GetExtData(player, string.format("petbag-%d-%d", petbagIndex, petNo));
          pcall(function()
            if petbagPet then
              petbagPet = JSON.decode(petbagPet);
            end
          end)
          if type(petbagPet) == 'table' then
            local msg = "　　　　　　　　【寵物雲端倉庫】\\n"
            local msg = msg .. pickupGoalInfo(player,petbagIndex,petNo);
            NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.按钮_是否, 2000+seqno, msg);
          else
            NLG.SystemMessage(player, '[系統]選擇的格庫沒有寵物。')
            return;
          end
      else
          return;
      end
    end
  end)
  self:NPC_regTalkedEvent(self.petBankNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local winButton = CONST.BUTTON_关闭;
      local msg = "2\\n　　　　　　　　【寵物雲端倉庫】\\n\\n"
           .. "　　◎提取存放的寵物\\n\\n"
           .. "　　◎寄存身上的寵物\\n\\n";
      NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, CONST.按钮_关闭, 777, msg);
    end
    return
  end)



end


function Module:onLoginEvent(charIndex)
  local bIndex = Char.GetExtData(charIndex, "petbag-index") or 1;
  Protocol.Send(charIndex, "petbagIndex",  tonumber(bIndex));
end


--目标信息
function pickupGoalInfo(player,petbagIndex,petNo)
      local petbagPet = Char.GetExtData(player, string.format("petbag-%d-%d", petbagIndex, petNo));
      pcall(function()
        if petbagPet then
          petbagPet = JSON.decode(petbagPet);
        end
      end)

      if type(petbagPet) == 'table' then
        local enemyId = petbagPet.attr[tostring(CONST.PET_PetID)];
        local Goal_name = petbagPet.attr[tostring(CONST.对象_名字)];
        local Goal_DataPos_3 = petbagPet.attr[tostring(CONST.对象_种族)];
        local Goal_DataPos_3 = Tribe(Goal_DataPos_3);
        local Goal_DataPos_5 = petbagPet.attr[tostring(CONST.对象_攻击力)];
        local Goal_DataPos_6 = petbagPet.attr[tostring(CONST.对象_防御力)];
        local Goal_DataPos_7 = petbagPet.attr[tostring(CONST.对象_敏捷)];
        local Goal_DataPos_8 = petbagPet.attr[tostring(CONST.对象_精神)];
        local Goal_DataPos_9 = petbagPet.attr[tostring(CONST.对象_回复)];

        local Goal_DataPos_12 = petbagPet.attr[tostring(CONST.对象_命中)];
        local Goal_DataPos_13 = petbagPet.attr[tostring(CONST.对象_必杀)];
        local Goal_DataPos_14 = petbagPet.attr[tostring(CONST.对象_地属性)];
        local Goal_DataPos_15 = petbagPet.attr[tostring(CONST.对象_水属性)];
        local Goal_DataPos_16 = petbagPet.attr[tostring(CONST.对象_火属性)];
        local Goal_DataPos_17 = petbagPet.attr[tostring(CONST.对象_风属性)];
        local Goal_DataPos_18 = petbagPet.attr[tostring(CONST.对象_抗毒)];
        local Goal_DataPos_19 = petbagPet.attr[tostring(CONST.对象_抗醉)];
        local Goal_DataPos_20 = petbagPet.attr[tostring(CONST.对象_抗睡)];
        local Goal_DataPos_21 = petbagPet.attr[tostring(CONST.对象_抗乱)];
        local Goal_DataPos_22 = petbagPet.attr[tostring(CONST.对象_抗石)];
        local Goal_DataPos_23 = petbagPet.attr[tostring(CONST.对象_抗忘)];
        local Goal_DataPos_26 = petbagPet.attr[tostring(CONST.对象_闪躲)];
        local Goal_DataPos_27 = petbagPet.attr[tostring(CONST.对象_反击)];
        local Goal_DataPos_28 = petbagPet.attr[tostring(CONST.对象_等级)];
        local Goal_DataPos_29 = petbagPet.attr[tostring(CONST.对象_原形)];
        local imageText = "@g,"..Goal_DataPos_29..",2,8,6,0@"

        msg = imageText .. "　　$4".. Goal_name .. "\\n"
                         .. "　　　　　　　" .. "$1攻擊 ".. Goal_DataPos_5 .."　" .. "$8必殺 ".. Goal_DataPos_13 .."　" .. "$8反擊 ".. Goal_DataPos_27 .."\\n"
                         .. "　　　　　　　" .. "$1防禦 ".. Goal_DataPos_6 .."　" .. "$8命中 ".. Goal_DataPos_12 .."　" .. "$8閃躲 ".. Goal_DataPos_26 .."\\n"
                         .. "　　　　　　　" .. "$1敏捷 ".. Goal_DataPos_7 .."　" .. "$2抗毒 ".. Goal_DataPos_18 .."　" .. "$2抗醉 ".. Goal_DataPos_19 .."\\n"
                         .. "　　　　　　　" .. "$1精神 ".. Goal_DataPos_8 .."　" .. "$2抗睡 ".. Goal_DataPos_20 .."　" .. "$2抗混 ".. Goal_DataPos_21 .."\\n"
                         .. "　　　　　　　" .. "$1恢復 ".. Goal_DataPos_9 .."　" .. "$2抗石 ".. Goal_DataPos_22 .."　" .. "$2抗忘 ".. Goal_DataPos_23 .."\\n"
                         .. "　　　　　　　" .. "$5地 ".. Goal_DataPos_14/10 .."　" .."$5水 ".. Goal_DataPos_15/10 .."　" .."$5火 ".. Goal_DataPos_16/10 .."　" .."$5風 ".. Goal_DataPos_17/10 .."\\n"
                         .. "　　　　　　　" .. "$9種族 ".. Goal_DataPos_3 .."　" .. "$9等級 ".. Goal_DataPos_28 .."\\n"
      else
        msg = "\\n\\n\\n\\n@c格庫出現錯誤"
      end
      return msg;
end

--种族字符串转换
function Tribe(Tribe)
  if Tribe==0 then
    return "人型系"
  elseif Tribe == 1 then
    return "龍族系"
  elseif Tribe == 2 then
    return "不死系"
  elseif Tribe == 3 then
    return "飛行系"
  elseif Tribe == 4 then
    return "昆蟲系"
  elseif Tribe == 5 then
    return "植物系"
  elseif Tribe == 6 then
    return "野獸系"
  elseif Tribe == 7 then
    return "特殊系"
  elseif Tribe == 8 then
    return "金屬系"
  elseif Tribe == 9 then
    return "邪魔系"
  elseif Tribe == 10 then
    return "神族系"
  elseif Tribe == 11 then
    return "精靈系"
  end
end

--------------------------------------------------------------------
-- NOTE 抽取宠物数据
function Module:extractPetData(petIndex)
  local petProfile = {
    attr={},
    rank={},
    skills={}
  };
  for _, v in pairs(petFields) do
    petProfile.attr[tostring(v)] = Char.GetData(petIndex, v);
    
  end
  for _, v in pairs(petRankFields) do
    petProfile.rank[tostring(v)] = Pet.GetArtRank(petIndex,v);
    
  end
  -- 宠物技能
  local skillTable={}
  for i=0,9 do
    local tech_id = Pet.GetSkill(petIndex, i)
    if tech_id<0 then
      table.insert(skillTable,nil)
    else
      table.insert(skillTable,tech_id)
    end
  end
  petProfile.skills=skillTable
  return petProfile;
end

-- NOTE 赋予宠物数据
function Module:insertPetData(petIndex,petData)
  -- 宠物属性
  for key, v in pairs(petFields) do
    if petData.attr[tostring(v)] ~=nil  then
      Char.SetData(petIndex, v,petData.attr[tostring(v)]);
    end
  end
  -- 忠诚
  -- Char.SetData(petIndex, 495,100);
  -- 宠物成长
  for key, v in pairs(petRankFields) do
    if petData.rank[tostring(v)] ~=nil then
      Pet.SetArtRank(petIndex, v,petData.rank[tostring(v)]);
    end
  end
  -- 宠物技能
  
  for i=0,9 do
    local tech_id = petData.skills[i+1]
    Pet.DelSkill(petIndex,i)
    if tech_id ~=nil then
      
      Pet.AddSkill(petIndex,tech_id)
    
    end
  end


end

Char.GetPetEmptySlot = function(charIndex)
  for Slot=0,4 do
      local PetIndex = Char.GetPet(charIndex, Slot);
      --print(PetIndex);
      if (PetIndex < 0) then
          return Slot;
      end
  end
  return -1;
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
