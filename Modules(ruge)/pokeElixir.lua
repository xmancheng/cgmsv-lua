local Module = ModuleBase:createModule('pokeElixir')



--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load');
  --����֮ʯ
  self:regCallback('ItemString', Func.bind(self.levelupRuby, self),"LUA_useRuby");
  self.ElixirNPC = self:NPC_createNormal('�t��֮ʯ', 14682, { x = 40, y = 31, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.ElixirNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
        local msg = "\\n@c���t��֮ʯ��" ..	"\\n\\n\\n����ⷰ����ȼ��ļtɫ��۔֮ʯ��";	
        NLG.ShowWindowTalked(player, npc, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 11, msg);
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
      if seqno == 11 and select == CONST.��ť_�� then
              return;
      elseif seqno == 11 and select == CONST.��ť_�� then
              return;
      end
    else
      local type = Item.GetData(RubyIndex,CONST.����_�Ӳ�һ);
      local upgrade = Item.GetData(RubyIndex,CONST.����_�Ӳζ�);
      if seqno == 1 and select == CONST.��ť_�ر� then
              return;
      elseif seqno == 2 and select == CONST.��ť_�ر� then
              return;
      else
        if (type==1 and data>0) then
          if (player~=Char.GetPartyMember(player,0)) then
              NLG.SystemMessage(player, "[ϵͳ]�t��֮ʯֻ����L�ſ�ʹ�á�")
              return;
          end
          local playerIndex = Char.GetPartyMember(player,data-1);
          if playerIndex<0 then
              return;
          end
          if not Char.IsDummy(playerIndex) then
              NLG.SystemMessage(player, "[ϵͳ]�t��֮ʯֻ�܌�ⷰ�ʹ�á�")
              return;
          end
          local Name = Char.GetData(playerIndex,CONST.����_����);
          local Level = Char.GetData(playerIndex,CONST.����_�ȼ�);
          local Exp = Char.GetData(playerIndex,CONST.����_����);
          if ( Level+upgrade>=Char.GetData(player,CONST.����_�ȼ�) ) then
              NLG.SystemMessage(player, "[ϵͳ]ⷰ�ȼ����ɳ��^��L��")
              return;
          end
          for i =1,upgrade do
            local Level_up = (Level+1)*(Level+1)*(Level+1)*(Level+1);
            local Level_now = Level*Level*Level*Level;
            Char.SetData(playerIndex,CONST.����_����,(Level_up-Level_now)+Exp);
            NLG.UpChar(playerIndex);
            NLG.SystemMessage(player, "[ϵͳ]"..Name.."�ȼ�������");
            Level = Level+1;
          end
          Char.DelItemBySlot(player, RubySlot);
        elseif (type==2 and data>0) then
          local petIndex = Char.GetPet(player,data-1);
          if petIndex<0 then
              return;
          end
          local Name = Char.GetData(petIndex,CONST.����_����);
          local Level = Char.GetData(petIndex,CONST.����_�ȼ�);
          local Exp = Char.GetData(petIndex,CONST.����_����);
          if ( Level+upgrade>=Char.GetData(player,CONST.����_�ȼ�) ) then
              NLG.SystemMessage(player, "[ϵͳ]����ȼ����ɳ��^���ˡ�")
              return;
          end
          for i =1,upgrade do
            local Level_up = (Level+1)*(Level+1)*(Level+1)*(Level+1);
            local Level_now = Level*Level*Level*Level;
            Char.SetData(petIndex,CONST.����_����,(Level_up-Level_now)+Exp);
            Pet.UpPet(player, petIndex);
            NLG.SystemMessage(player, "[ϵͳ]"..Name.."�ȼ�������");
            Level = Level+1;
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
    local type = Item.GetData(RubyIndex,CONST.����_�Ӳ�һ);
    local upgrade = Item.GetData(RubyIndex,CONST.����_�Ӳζ�);
      if (type==1) then
        local msg = "3|\\n���t��֮ʯ��\\n�x�񼴌������ȼ� "..upgrade.."�� ��ⷰ飡\\n\\n";
        for teamSlot=0,4 do
          local playerIndex = Char.GetPartyMember(charIndex,teamSlot);
          if(playerIndex<0)then
             msg = msg .. "��\\n";
          else
             msg = msg .. ""..Char.GetData(playerIndex,CONST.����_����).."\\n";
          end
        end
        NLG.ShowWindowTalked(charIndex, self.ElixirNPC, CONST.����_ѡ���, CONST.��ť_�ر�, 1, msg);
      elseif (type==2) then
        local msg = "3|\\n������֮����\\n�x�񼴌������ȼ� "..upgrade.."�� �Č��\\n\\n";
        for petSlot=0,4 do
          local petIndex = Char.GetPet(charIndex,petSlot);
          if(petIndex<0)then
             msg = msg .. "��\\n";
          else
             msg = msg .. ""..Char.GetData(petIndex,CONST.����_����).."\\n";
          end
        end
        NLG.ShowWindowTalked(charIndex, self.ElixirNPC, CONST.����_ѡ���, CONST.��ť_�ر�, 2, msg);
      else
        local msg = "\\n@c���t��֮ʯ��" ..	"\\n\\n\\n����ⷰ����ȼ��ļtɫ��۔֮ʯ��";	
        NLG.ShowWindowTalked(charIndex, self.ElixirNPC, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 11, msg);
      end
    return 1;
end

function Module:onUnload()
  self:logInfo('unload')
end

return Module;
