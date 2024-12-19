---模块类
local Module = ModuleBase:createModule(pokeSlot)

local slot_roll_1 = {149000,149000,149003,149003,149012,149015,149038,149039,149054};	--第一轨形象
local slot_roll_2 = {149000,149000,149003,149003,149012,149015,149038,149039,149054};	--第二轨形象
local slot_roll_3 = {149000,149000,149003,149003,149012,149015,149038,149039,149054};	--第三轨形象
local slot_Lotto_list_triple = {};		--同花奖励
slot_Lotto_list_triple[149000] = {66668,5};
slot_Lotto_list_triple[149003] = {66668,5};
slot_Lotto_list_triple[149012] = {66668,6};
slot_Lotto_list_triple[149015] = {66668,7};
slot_Lotto_list_triple[149038] = {66668,8};
slot_Lotto_list_triple[149039] = {66668,9};
slot_Lotto_list_triple[149054] = {66668,10};

local slot_Lotto_list_dual = {};		--成对奖励
slot_Lotto_list_dual[149000] = {66668,2};
slot_Lotto_list_dual[149003] = {66668,2};
slot_Lotto_list_dual[149012] = {66668,3};
slot_Lotto_list_dual[149015] = {66668,3};
slot_Lotto_list_dual[149038] = {66668,3};
slot_Lotto_list_dual[149039] = {66668,3};
slot_Lotto_list_dual[149054] = {66668,4};

-------------------------------------------------
--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load');
  self.slotMachineNPC = self:NPC_createNormal('寶可拉霸機', 12950, { x = 225, y = 93, mapType = 0, map = 1000, direction = 0 });
  self:NPC_regWindowTalkedEvent(self.slotMachineNPC, function(npc, player, _seqno, _select, _data)
    local column = tonumber(_data)
    local page = tonumber(_seqno)
    local warpPage = page;
    local winButton = CONST.BUTTON_关闭;

    --print(_seqno,_select,_data)
    --上页16 下页32 关闭/取消2
    if _select > 0 then
      if _select == CONST.按钮_确定 then
          if (page==1001) then
              Char.AddGold(player, -1000000);
              local seqno = page - 1000;
              local msg = "@c　　【寶可拉霸機】\\n"
                       .. "　　　$1-------　第十次拉霸的結果如下　-------\\n$5"
              local msg = msg .. slotEventInfo(player,seqno,10)
              local msg = msg .. "\\n\\n\\n\\n\\n\\n　　$4◇獎勵已經發放◇"
              NLG.ShowWindowTalked(player, self.slotMachineNPC, CONST.窗口_信息框, CONST.按钮_关闭, 2000+seqno, msg);
              return
          else
              return
          end
      elseif _select == CONST.按钮_关闭 then
      end
      if _select == CONST.BUTTON_下一页 then
        if (page==1003) then
          local seqno = page - 1000;
          local msg = "@c　　【寶可拉霸機】\\n"
          local msg = msg .. slotEventInfo(player,seqno,1);
          local msg = msg .. "\\n\\n\\n\\n\\n\\n\\n　　▽拉霸過程非最終結果▽"
          NLG.ShowWindowTalked(player, self.slotMachineNPC, CONST.窗口_信息框, CONST.按钮_下一页, 1000+seqno+1, msg);
        elseif (page==1004) then
          Char.AddGold(player, -100000);
          local seqno = page - 1000;
          local msg = "@c　　【寶可拉霸機】\\n"
                   .. "　　　$1-------　本次拉霸的結果如下　-------\\n$5"
          local msg = msg .. slotEventInfo(player,seqno,1);
          local msg = msg .. "\\n\\n\\n\\n\\n\\n　　$4◇獎勵已經發放◇"
          NLG.ShowWindowTalked(player, self.slotMachineNPC, CONST.窗口_信息框, CONST.按钮_关闭, 2000+seqno, msg);
        end
      elseif _select == 2 then
        return
      end

    else
      --local count = 8 * (warpPage - 1) + column
      --print(count)
      if (column==1) then
          if (Char.GetData(player, CONST.对象_金币)<1000000) then
            NLG.SystemMessage(player,"[系統]拉霸所需金幣不足100萬。");
            return
          end
          local msg = "@c　　【寶可拉霸機】\\n"
          local msg = msg .. slotMachineInfo(column);
          NLG.ShowWindowTalked(player, self.slotMachineNPC, CONST.窗口_信息框, CONST.按钮_确定关闭, 1000+column, msg);
      elseif (column==3) then
          if (Char.GetData(player, CONST.对象_金币)<100000) then
            NLG.SystemMessage(player,"[系統]拉霸所需金幣不足10萬。");
            return
          end
          local msg = "@c　　【寶可拉霸機】\\n"
          local msg = msg .. slotMachineInfo(column);
          NLG.ShowWindowTalked(player, self.slotMachineNPC, CONST.窗口_信息框, CONST.按钮_下一页, 1000+column, msg);
      end
    end
  end)
  self:NPC_regTalkedEvent(self.slotMachineNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local winButton = CONST.BUTTON_关闭;
      local msg = "4\\n@c　　【寶可拉霸機】\\n"
               .. "　　支付魔幣進行拉霸遊戲：\\n"
               .. "　　成對2-4代金幣、同花5-10代金幣\\n\\n"
               .. "　　◎快速遊玩拉霸機10次100萬魔幣\\n\\n"
               .. "　　◎單次遊玩拉霸機01次010萬魔幣\\n"

      NLG.ShowWindowTalked(player, npc, CONST.窗口_选择框, winButton, 1, msg);
    end
    return
  end)
end

---------------------------------------------------------------------------------------------------------------
--信息
function slotMachineInfo(column)
      local msg = "";
      local slot_roll_image_1 = slot_roll_1[1];
      local slot_roll_image_2 = slot_roll_2[1];
      local slot_roll_image_3 = slot_roll_3[1];
      local imageText_1 = "@g,"..slot_roll_image_1..",3,6,4,0@"
      local imageText_2 = "@g,"..slot_roll_image_2..",10,6,4,0@"
      local imageText_3 = "@g,"..slot_roll_image_3..",17,6,4,0@"
      msg = msg .. "  " .. imageText_1 .. "  " .. imageText_2 .. "  " .. imageText_3
      return msg;
end

function slotEventInfo(player,seqno,count)
      local goalSet = NLG.Rand(1,#slot_roll_1);		--定锚点
      for k=1,count do
        --第一轨
        local xa = NLG.Rand(1,3);
        for i=1,#slot_roll_1-1-xa do
            a = NLG.Rand(1,i+1+xa);
            temp=slot_roll_1[a];
            slot_roll_1[a]=slot_roll_1[i];
            slot_roll_1[i]=temp;
        end
        --第二轨
        local xb = NLG.Rand(1,3);
        for i=1,#slot_roll_2-1-xb do
            b = NLG.Rand(1,i+1+xb);
            temp=slot_roll_2[b];
            slot_roll_2[b]=slot_roll_2[i];
            slot_roll_2[i]=temp;
        end
        --第三轨
        local xc = NLG.Rand(1,3);
        for i=1,#slot_roll_3-1-xc do
            c = NLG.Rand(1,i+1+xc);
            temp=slot_roll_3[c];
            slot_roll_3[c]=slot_roll_3[i];
            slot_roll_3[i]=temp;
        end

        local ImageId,eventCheck = slotMachineCheck(slot_roll_1[goalSet],slot_roll_2[goalSet],slot_roll_3[goalSet])

        if (seqno==1 or seqno==4) then
          if (ImageId>0 and eventCheck==3) then			--同花
            Char.GiveItem(player, slot_Lotto_list_triple[ImageId][1], slot_Lotto_list_triple[ImageId][2]);
          elseif (ImageId>0 and eventCheck==2) then		--成对
            Char.GiveItem(player, slot_Lotto_list_dual[ImageId][1], slot_Lotto_list_dual[ImageId][2]);
          end
        end
        NLG.SortItem(player);
      end

      --最後結果顯示
      local msg = "";
      local slot_roll_image_1 = slot_roll_1[goalSet];
      local slot_roll_image_2 = slot_roll_2[goalSet];
      local slot_roll_image_3 = slot_roll_3[goalSet];
      local imageText_1 = "@g,"..slot_roll_image_1..",3,6,4,0@"
      local imageText_2 = "@g,"..slot_roll_image_2..",10,6,4,0@"
      local imageText_3 = "@g,"..slot_roll_image_3..",17,6,4,0@"
      msg = msg .. "  " .. imageText_1 .. "  " .. imageText_2 .. "  " .. imageText_3
      return msg;
end

function slotMachineCheck(roll_a,roll_b,roll_c)
     local ImageId = 0;
     local eventCheck = 0;
     if roll_a==roll_b and roll_a==roll_c and roll_b==roll_c then
       local ImageId = roll_a;
       local eventCheck = 3;
       return ImageId,eventCheck;
     elseif roll_a~=roll_b and roll_a~=roll_c and roll_b~=roll_c then
       local ImageId = 0;
       local eventCheck = 0;
       return ImageId,eventCheck;
     else
       local eventCheck = 2;
       if roll_a==roll_b and roll_a~=roll_c then
         ImageId = roll_a;
       elseif roll_a==roll_c and roll_a~=roll_b then
         ImageId = roll_a;
       elseif roll_b==roll_c and roll_b~=roll_a then
         ImageId = roll_b;
       end
       return ImageId,eventCheck;
     end

     return ImageId,eventCheck;
end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
