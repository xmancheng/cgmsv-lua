local Module = ModuleBase:createModule('pokeElixir')

local partner_expRate = {1,1,1,1,1,2,2,2,2,2,5,5,5,5,5,10,10,10,10,10}		--每10级获得经验比率X分之一
local pet_expRate = {1,1,1,1,1,2,2,2,2,2,5,5,5,5,5,10,10,10,10,10}			--例如:1~10级得到升级所需1/1经验:51~60级得到升级所需1/2经验

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load');
  --贤者之石
  self:regCallback('ItemString', Func.bind(self.levelupRuby, self),"LUA_useRuby");
  self.ElixirNPC = self:NPC_createNormal('賢者之石', 14682, { x = 40, y = 31, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.ElixirNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local msg = "\\n@c【賢者之石】" ..	"\\n\\n\\n提升夥伴或寵物等級的紅色奇蹟之石！";	
        NLG.ShowWindowTalked(player, npc, CONST.窗口_信息框, CONST.按钮_是否, 11, msg);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(self.ElixirNPC, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    local RubyIndex = RubyIndex;
    local RubySlot = RubySlot;
    if select > 0 then
      if seqno == 11 and select == CONST.按钮_否 then
              return;
      elseif seqno == 11 and select == CONST.按钮_是 then
              return;
      end
    else
      local type = Item.GetData(RubyIndex,CONST.道具_子参一);
      local upgrade = Item.GetData(RubyIndex,CONST.道具_子参二);
      if seqno == 1 and select == CONST.按钮_关闭 then
              return;
      elseif seqno == 2 and select == CONST.按钮_关闭 then
              return;
      else
        if (type==1 and data>0) then
          if (player~=Char.GetPartyMember(player,0)) then
              NLG.SystemMessage(player, "[系统]賢者之石只有隊長才可使用。")
              return;
          end
          local playerIndex = Char.GetPartyMember(player,data-1);
          if playerIndex<0 then
              return;
          end
          if not Char.IsDummy(playerIndex) then
              NLG.SystemMessage(player, "[系统]賢者之石只能對夥伴使用。")
              return;
          end
          local Name = Char.GetData(playerIndex,CONST.对象_名字);
          local Level = Char.GetData(playerIndex,CONST.对象_等级);
          if ( Level+upgrade>=Char.GetData(player,CONST.对象_等级) ) then
              NLG.SystemMessage(player, "[系统]夥伴等級不可超過隊長。")
              return;
          end
          for i=1,upgrade do
            --经验值比率
            local Level = Char.GetData(playerIndex,CONST.对象_等级);
            local Exp = Char.GetData(playerIndex,CONST.对象_经验);
            local lvRank = math.ceil(Level/10);
            local expRate = (1/partner_expRate[lvRank]);
            --经验值计算公式
            local Level_up = (Level+1)*(Level+1)*(Level+1)*(Level+1);
            local Level_now = Level*Level*Level*Level;
            local Exp_up = math.floor((Level_up-Level_now)*expRate);
            Char.SetData(playerIndex,CONST.对象_经验, Exp_up+Exp);
            NLG.UpChar(playerIndex);
            NLG.UpChar(player);
            NLG.SystemMessage(player, "[系统]"..Name.."獲得"..Exp_up.."經驗值。");
            if (Char.GetData(playerIndex,CONST.对象_等级)>Level) then
              NLG.SystemMessage(player, "[系统]"..Name.."等級提升。");
            end
          end
          Char.DelItemBySlot(player, RubySlot);
        elseif (type==2 and data>0) then
          local petIndex = Char.GetPet(player,data-1);
          if petIndex<0 then
              return;
          end
          local Name = Char.GetData(petIndex,CONST.对象_名字);
          local Level = Char.GetData(petIndex,CONST.对象_等级);
          if ( Level+upgrade>=Char.GetData(player,CONST.对象_等级) ) then
              NLG.SystemMessage(player, "[系统]寵物等級不可超過主人。")
              return;
          end
          for i=1,upgrade do
            --经验值比率
            local Level = Char.GetData(petIndex,CONST.对象_等级);
            local Exp = Char.GetData(petIndex,CONST.对象_经验);
            local lvRank = math.ceil(Level/10);
            local expRate = (1/pet_expRate[lvRank]);
            --经验值计算公式
            local Level_up = (Level+1)*(Level+1)*(Level+1)*(Level+1);
            local Level_now = Level*Level*Level*Level;
            local Exp_up = math.floor((Level_up-Level_now)*expRate);
            Char.SetData(petIndex,CONST.对象_经验, Exp_up+Exp);
            Pet.UpPet(player, petIndex);
            NLG.UpChar(player);
            NLG.SystemMessage(player, "[系统]"..Name.."獲得"..Exp_up.."經驗值。");
            if (Char.GetData(petIndex,CONST.对象_等级)>Level) then
              NLG.SystemMessage(player, "[系统]"..Name.."等級提升。");
            end
          end
          Char.DelItemBySlot(player, RubySlot);
        end
      end
    end
  end)


end


function Module:levelupRuby(charIndex,targetIndex,itemSlot)
    ItemID = Item.GetData(Char.GetItemIndex(charIndex,itemSlot),0);
    RubySlot =itemSlot;
    RubyIndex = Char.GetItemIndex(charIndex,itemSlot);
    local type = Item.GetData(RubyIndex,CONST.道具_子参一);
    local upgrade = Item.GetData(RubyIndex,CONST.道具_子参二);
      if (type==1) then
        local msg = "4|\\n【賢者之石】\\n選擇即將獲得 "..upgrade.."次經驗值 提升等級的夥伴！\\n"
                  .."※比率:1-50[100%]、51-100[50%]、101-160[20%]\\n\\n";
        for teamSlot=0,4 do
          local playerIndex = Char.GetPartyMember(charIndex,teamSlot);
          if(playerIndex<0)then
             msg = msg .. "空\\n";
          else
             msg = msg .. ""..Char.GetData(playerIndex,CONST.对象_名字).."\\n";
          end
        end
        NLG.ShowWindowTalked(charIndex, self.ElixirNPC, CONST.窗口_选择框, CONST.按钮_关闭, 1, msg);
      elseif (type==2) then
        local msg = "4|\\n【神奇之果】\\n選擇即將獲得 "..upgrade.."次經驗值 提升等級的寵物！\\n"
                  .."※比率:1-50[100%]、51-100[50%]、101-160[20%]\\n\\n";
        for petSlot=0,4 do
          local petIndex = Char.GetPet(charIndex,petSlot);
          if(petIndex<0)then
             msg = msg .. "空\\n";
          else
             msg = msg .. ""..Char.GetData(petIndex,CONST.对象_名字).."\\n";
          end
        end
        NLG.ShowWindowTalked(charIndex, self.ElixirNPC, CONST.窗口_选择框, CONST.按钮_关闭, 2, msg);
      else
        local msg = "\\n@c【賢者之石】" ..	"\\n\\n\\n提升夥伴或寵物等級的紅色奇蹟之石！";	
        NLG.ShowWindowTalked(charIndex, self.ElixirNPC, CONST.窗口_信息框, CONST.按钮_是否, 11, msg);
      end
    return 1;
end

function Module:onUnload()
  self:logInfo('unload')
end

return Module;
