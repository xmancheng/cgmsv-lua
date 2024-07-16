local QuickUI = ModuleBase:createModule('quickUI')

local PartyMember={}
local onlinePlayerRewards = {}
local rewardsCount = {}

QuickUI:addMigration(1, 'init lua_hook_character', function()
  SQL.querySQL([[
      CREATE TABLE if not exists `lua_hook_character` (
    `Name` char(32) COLLATE gbk_bin NOT NULL,
    `CdKey` char(32) COLLATE gbk_bin NOT NULL,
    `RankedPoints` int(10) NOT NULL Default 0,
    `WingCover` int(10) NOT NULL Default 1,
    `OriginalImageNumber` int(10) NOT NULL,
    `SwitchImageNumber2` int(10) Default 1,
    `SwitchImageNumber3` int(10) Default 1,
    `SwitchImageNumber4` int(10) Default 1,
    `SwitchImageNumber5` int(10) Default 1,
    `SwitchImageNumber6` int(10) Default 1,
    `SwitchImageNumber7` int(10) Default 1,
    `SwitchImageNumber8` int(10) Default 1,
    `SwitchImageNumber9` int(10) Default 1,
    `SwitchImageNumber10` int(10) Default 1,
    `Tenjo` int(10) NOT NULL Default 0,
    `MatchDraw1` mediumtext COLLATE gbk_bin NULL,
    PRIMARY KEY (`CdKey`),
    KEY `Name` (`Name`) USING BTREE
  ) ENGINE=Innodb DEFAULT CHARSET=gbk COLLATE=gbk_bin
  ]])
end);

QuickUI:addMigration(2, 'insertinto lua_hook_character', function()
  SQL.querySQL([[
      INSERT INTO lua_hook_character (Name,CdKey,OriginalImageNumber) SELECT Name,CdKey,OriginalImageNumber FROM tbl_character;
  ]])
end);

function QuickUI:headcover(player, hcID)
  --self:logDebug('headcover', player, hcID)
  if player>=0 and player < 800  then
      --local cdk = Char.GetData(player,CONST.����_CDK);
      --local WingCover = tonumber(SQL.Run("select WingCover from lua_hook_character where CdKey='"..cdk.."'")["0_0"])
      if hcID == 1 and Char.EndEvent(player,21) == 1 and Char.EndEvent(player,105) == 1 and Char.EndEvent(player,143) == 1 then
            local charPtr = Char.GetCharPointer(player)
            ffi.setMemoryInt32(charPtr + 0x5e8 + 0x188 + 0x18, 200);   --walkSpeed
            return 108510;
      end
      if hcID == 1 and Char.EndEvent(player,21) == 1 and Char.EndEvent(player,105) == 1 then
            local charPtr = Char.GetCharPointer(player)
            ffi.setMemoryInt32(charPtr + 0x5e8 + 0x188 + 0x18, 170);   --walkSpeed
            return 120054;
      end
      if hcID == 1 and Char.EndEvent(player,21) == 1 then
            local charPtr = Char.GetCharPointer(player)
            ffi.setMemoryInt32(charPtr + 0x5e8 + 0x188 + 0x18, 150);   --walkSpeed
            return 114177;
      end
      if hcID == 1 and Char.EndEvent(player,0) == 1 then
            local charPtr = Char.GetCharPointer(player)
            ffi.setMemoryInt32(charPtr + 0x5e8 + 0x188 + 0x18, 130);   --walkSpeed
            return 114206;
      end
  end
  return hcID;
end

function QuickUI:shortcut(player, actionID)
  if actionID == %����_�ܲ�% then
    self:walkingspeed(self.speedNpc,player);
  elseif actionID == %����_����% then
    self:teamfever(self.feverNpc,player);
  elseif actionID == %����_ħ��% then
    self:teamheal(self.healNpc,player);
  elseif actionID == %����_����% then
    self:metamo(self.imageNpc,player);
  elseif actionID == %����_��ͷ% then
    self:gather(player);
  elseif actionID == %����_����% then
    self:partyenter(player);
  elseif actionID == %����_����% then
    self:partyform(player);
  elseif actionID == %����_����% then
    self:petinfo(player);
  --elseif actionID == %����_Ͷ��% then
    --self:pettalk(player);
  end
end

function QuickUI:walkingspeed(npc, player)
      local msg = "\\n@c���ƄӼ��١�����΄��������������·�ٶȣ�\\n\\n1.���m�ن�ʿ�wƝ[���߽�ָ]��150��\\n\\n2.Ů���B[����֮��]��200��\\n\\n3.�܂���Ů��[ɭ�_�f��]��250��\\n\\n4.ِ��÷��֮��[ʧ��֮��]��300��\\n";
      NLG.ShowWindowTalked(player, self.speedNpc, CONST.����_��Ϣ��, CONST.��ť_ȷ���ر�, 1, msg);
end

function QuickUI:teamfever(npc, player)
      local msg = "\\n\\n@c��һ�Iȫ꠴򿨡�\\n\\n�Ǵ򿨠�B���򿨠�B\\n\\n�򿨠�B���Ǵ򿨠�B\\n\\n[�_��]��ȫ��M�д�|ȫ꠵Ĵ򿨽Y��\\n";
      NLG.ShowWindowTalked(player, self.feverNpc, CONST.����_��Ϣ��, CONST.��ť_ȷ���ر�, 2, msg);
end

function QuickUI:teamheal(npc, player)
      local msg = "\\n\\n@c�؏�ħ��ֵ��+��������ֵ��\\n\\n�؏�����ֵ\\n\\n�؏͌��������ֵ��ħ��ֵ\\n\\nһ�I�؏�ȫ�����͌���ħ��������\\n";
      NLG.ShowWindowTalked(player, self.healNpc, CONST.����_��Ϣ��, CONST.��ť_ȷ���ر�, 3, msg);
end

function QuickUI:metamo(npc, player)
      local cdk = Char.GetData(player,CONST.����_CDK);
      SQL.Run("INSERT INTO lua_hook_character (Name,CdKey,OriginalImageNumber) SELECT Name,CdKey,OriginalImageNumber FROM tbl_character WHERE NOT EXISTS ( SELECT Name FROM lua_hook_character WHERE tbl_character.CdKey=lua_hook_character.CdKey)");
      local dressing_OImage = tonumber(SQL.Run("select OriginalImageNumber from lua_hook_character where CdKey='"..cdk.."'")["0_0"])
      local msg = ""..dressing_OImage.."|��������������\\n\\n�x[��]ʹ��ɫ���Q������\\n\\n�x[��]�Q��һ퓵�����\\n\\n      1 / 10\\n";
      NLG.ShowWindowTalked(player, self.imageNpc, CONST.����_ͼ��, CONST.��ť_�Ƿ�, 4, msg);
end

function QuickUI:gather(player)
      local playerMapType = Char.GetData(player, CONST.CHAR_��ͼ����);
      local playerMap = Char.GetData(player, CONST.CHAR_��ͼ);
      local playerX = Char.GetData(player, CONST.CHAR_X);
      local playerY = Char.GetData(player, CONST.CHAR_Y);
      if Char.PartyNum(player)>0 and player==Char.GetPartyMember(player,0) then
            for slot = 1,4 do
                local p = Char.GetPartyMember(player,slot)
                if(p>=0) then
                      Char.Warp(p, playerMapType, playerMap, playerX, playerY);
                end
            end
      else
            NLG.SystemMessage(player, '��L�ſ�ʹ�ã�');
      end
end

function QuickUI:partyenter(player)
      local cdk = Char.GetData(player,CONST.����_CDK);
      local playerMapType = Char.GetData(player, CONST.CHAR_��ͼ����);
      local playerMap = Char.GetData(player, CONST.CHAR_��ͼ);
      local playerX = Char.GetData(player, CONST.CHAR_X);
      local playerY = Char.GetData(player, CONST.CHAR_Y);
      if Char.PartyNum(player)>0 and player==Char.GetPartyMember(player,0) then
             PartyMember[cdk] = {}
             for partySlot = 0,4 do 
                    local targetcharIndex = Char.GetPartyMember(player,partySlot);
                    if targetcharIndex >= 0  then
                          table.insert(PartyMember[cdk], partySlot+1, targetcharIndex);
                    else
                          table.insert(PartyMember[cdk], partySlot+1, -1);
                    end
             end
             table.insert(PartyMember[cdk],cdk);
             NLG.SystemMessage(player, '���ɆT�o��ꮅ��');
      else
            NLG.SystemMessage(player, '��L�ſ�ʹ�ã�');
      end
end

function QuickUI:partyform(player)
      local cdk = Char.GetData(player,CONST.����_CDK);
      local playerMapType = Char.GetData(player, CONST.CHAR_��ͼ����);
      local playerMap = Char.GetData(player, CONST.CHAR_��ͼ);
      local playerX = Char.GetData(player, CONST.CHAR_X);
      local playerY = Char.GetData(player, CONST.CHAR_Y);
      if PartyMember[cdk] ~= nill and cdk == PartyMember[cdk][6] then
            if Char.PartyNum(player) == -1 then
                  for i,v in ipairs(PartyMember[cdk]) do
                        local memberMap = Char.GetData(v, CONST.CHAR_��ͼ);
                        local memberX = Char.GetData(v, CONST.CHAR_X);
                        local memberY = Char.GetData(v, CONST.CHAR_Y);
                        if i<=5 and v>-1 and v~=player and memberMap == playerMap then
                              if memberX >= playerX-5 and memberX <= playerX+5 and memberY>= playerY-5 and memberY<= playerY+5 then
                                    Char.Warp(v, playerMapType, playerMap, playerX, playerY);
                                    Char.JoinParty(v, player);
                              else
                                    NLG.SystemMessage(player, '��꠆T���x�^�h���ʧ����');
                              end
                        end
                  end
            end
      else
            NLG.SystemMessage(player, 'Ո��ӛ䛻򸲌����ɆT��');
      end
end

function QuickUI:petinfo(player)
      for petSlot = 0,4 do
            local petIndex = Char.GetPet(player, petSlot);
            local petname = Char.GetData(petIndex, CONST.CHAR_����);
            local arr_rank1 = Pet.GetArtRank(petIndex,CONST.PET_���);
            local arr_rank2 = Pet.GetArtRank(petIndex,CONST.PET_����);
            local arr_rank3 = Pet.GetArtRank(petIndex,CONST.PET_ǿ��);
            local arr_rank4 = Pet.GetArtRank(petIndex,CONST.PET_����);
            local arr_rank5 = Pet.GetArtRank(petIndex,CONST.PET_ħ��);
            local a6, a1, a2, a3, a4, a5 = Char.GetPetRank(player,petSlot);
            if a6 >= 0 then
                  NLG.SystemMessage(player, '---------------------------------------');
                  NLG.SystemMessage(player, ''..petname..'������-'..a6..'�n�Σ�');
                  NLG.SystemMessage(player, '�w'..arr_rank1..'(-'..a1..')��'..arr_rank2..'(-'..a2..')��'..arr_rank3..'(-'..a3..')��'..arr_rank4..'(-'..a4..')ħ'..arr_rank5..'(-'..a5..')');
            end
      end
      NLG.SystemMessage(player, '---------------------------------------');
end

local t1 = {"��˯�����?�Ҷ����I����..."};
local t2 = {"���Լ�һֱ͵�Զ����j��..."};
local t3 = {"����Ҫ��ʳ�������ǂ���!"};
local t4 = {"��...��...̫�Є���!"};
local t5 = {"�����ⲻ�e..."};
local t6 = {"�o�ľͳԖ|����..."};
local t7 = {"׌�㴭�ښ�Ҳ��!"};
local t8 = {"����!����Ҫȥ�����lѽ!"};
local t9 = {"����ǳ����Ŷ!�߰�!�҂���ȥ��!"};
local t10 = {"��Ҫ�Ԟ�Ϳ����p������!"};
local t11 = {"���񲻉򰡣������_ʼ��"};
local t12 = {"���г������������ǻ�!"};
local t13 = {"�ܱ�Ǹ��ֻ���@�Nˮƽ... ��׌��ʧ��"};
local t14 = {"�����ǿ�̓��..."};
local t15 = {"������˼!׌���˓�����!"};
local t16 = {"��ϲ��!��������Ŀ�е�Ӣ��"};
local t17 = {"�r�g���ǽ��Ű�! ����!"};
local t18 = {"�Ȅe����ð�U,׌�������ȱ������f��!"};
local t19 = {"�ǵ�! �ϴ�!"};
local t20 = {"��������������!!!"};
local talknotes = {t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,t13,t14,t15,t16,t17,t18,t19,t20};
function QuickUI:pettalk(player)
      local playerMapType = Char.GetData(player, CONST.CHAR_��ͼ����);
      local playerMap = Char.GetData(player, CONST.CHAR_��ͼ);
      local playerX = Char.GetData(player, CONST.CHAR_X);
      local playerY = Char.GetData(player, CONST.CHAR_Y);
      local playerDir = Char.GetData(player, CONST.CHAR_����);
      if (onlinePlayerRewards[player]==nil and rewardsCount[player]==nil) then
             onlinePlayerRewards[player] = os.time();
             rewardsCount[player] = 0;
      end
      if (rewardsCount[player]>0 and tonumber(os.date("%H",os.time())) - tonumber(os.date("%H",onlinePlayerRewards[player])) < 1) then
            NLG.SystemMessage(player,"�ھ������Iȡ�r�g�o�"..os.date("%X",onlinePlayerRewards[player])..":Ո1С�r���ٴ��Iȡ");
            return
      end
      if (foodNpc == nil) then
            if playerDir==0 then playerX=playerX; playerY=playerY-1;
            elseif playerDir==1 then playerX=playerX+1; playerY=playerY-1;
            elseif playerDir==2 then playerX=playerX+1; playerY=playerY;
            elseif playerDir==3 then playerX=playerX+1; playerY=playerY+1;
            elseif playerDir==4 then playerX=playerX; playerY=playerY+1;
            elseif playerDir==5 then playerX=playerX-1; playerY=playerY+1;
            elseif playerDir==6 then playerX=playerX-1; playerY=playerY;
            elseif playerDir==7 then playerX=playerX-1; playerY=playerY-1;
            end
            foodNpc = self:NPC_createNormal(' ', 27304, { x = playerX, y = playerY, mapType = playerMapType, map = playerMap, direction = 0 });
            rewardsCount[player] = 0;
      elseif (foodNpc ~= nil and Char.ItemSlot(player)<=18) then
            onlinePlayerRewards[player] = os.time();
            rewardsCount[player] = 1;
            for hbnum = 1,4 do 
                  local targetcharIndex = Char.GetPartyMember(player,hbnum);
                  if targetcharIndex >= 0 and Char.IsDummy(targetcharIndex) then
                        local r = math.random(2,20);
                        NLG.SystemMessage(player,""..Char.GetData(targetcharIndex,%����_����%)..":"..talknotes[r][1].."");
                  end
            end
            local giftItemID = {900497,900498,70016,75011}   --�����͡������Ǭ��1000ħ�Ž��Q�������`��
            local rx = math.random(1,4);
            Char.GiveItem(player, giftItemID[rx], rx, '��Č���؁���һЩ���߽o�㣡');
            NL.DelNpc(foodNpc);
            foodNpc = nil;
      elseif (foodNpc ~= nil and Char.ItemSlot(player)>=19) then
            NLG.SystemMessage(player,'��Ʒ�ڿ�M�ˣ�Ո�ճ��ɸ�');
            return
      end
end


function QuickUI:handleTalkEvent(charIndex,msg,color,range,size)
	if (msg=="/book") then
		local msg = "2\\n@c�������ݹ����x��\\n"
			.."�����T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
			.."�����M�һ�I�򿨡�\\n"
			.."�����M�һ�I�֏͡�\\n"
			.."����������Q����\\n"
			.."������·�ƄӼ��١�\\n"
			.."��������һ�I��n��\\n"
			.."�����ɆT����һ�c��\\n"
			.."�������ﻥ��(ÿС�r1��)��\\n";
		NLG.ShowWindowTalked(charIndex, self.quickUInpc, CONST.����_ѡ���, CONST.��ť_�ر�, 1, msg);
		return 0;
	end
	return 1;
end

function QuickUI:onLoad()
  self:logInfo('load');
  self:regCallback('CharActionEvent', Func.bind(self.shortcut, self))
  self:regCallback('HeadCoverEvent', Func.bind(self.headcover, self))
  self:regCallback('ItemString', Func.bind(self.imageCollection, self),"LUA_useMetamoCT");
  self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self));
  self.quickUInpc = self:NPC_createNormal('�������ͼʾ', 98972, { x = 36, y = 37, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.quickUInpc, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "2\\n@c�������ݹ����x��\\n"
            .."�����T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
            .."�����M�һ�I�򿨡�\\n"
            .."�����M�һ�I�֏͡�\\n"
            .."����������Q����\\n"
            .."������·�ƄӼ��١�\\n"
            .."��������һ�I��n��\\n"
            .."�����ɆT����һ�c��\\n"
            .."�������ﻥ��(ÿС�r1��)��\\n";
      NLG.ShowWindowTalked(player, self.quickUInpc, CONST.����_ѡ���, CONST.��ť_�ر�, 1, msg);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(self.quickUInpc, function(npc, player, _seqno, _select, _data)
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    --print(data)
    if select > 0 then
    else
      if (seqno == 1 and select == CONST.��ť_�ر�) then
                 return;
      end
      if (seqno == 1 and data >= 1) then
          local menuSelect = data;
          if menuSelect == 1 then
            self:teamfever(self.feverNpc,player);
          elseif menuSelect == 2 then
            self:teamheal(self.healNpc,player);
          elseif menuSelect == 3 then
            self:metamo(self.imageNpc,player);
          elseif menuSelect == 4 then
            self:walkingspeed(self.speedNpc,player);
          elseif menuSelect == 5 then
            self:petinfo(player);
          elseif menuSelect == 6 then
            self:gather(player);
          elseif menuSelect == 7 then
            self:pettalk(player);
          end
      end
    end
  end)

  --�Ƅ��ٶ�
  self.speedNpc = self:NPC_createNormal('�ٶȿ��', 98972, { x = 37, y = 37, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.speedNpc, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "\\n@c���ƄӼ��١�����΄��������������·�ٶȣ�\\n\\n1.���m�ن�ʿ�wƝ[���߽�ָ]��130��\\n\\n2.Ů���B[����֮��]��150��\\n\\n3.�܂���Ů��[ɭ�_�f��]��170��\\n\\n4.ِ��÷��֮��[ʧ��֮��]��200��\\n";
      NLG.ShowWindowTalked(player, self.speedNpc, CONST.����_��Ϣ��, CONST.��ť_ȷ���ر�, 1, msg);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(self.speedNpc, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.����_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select > 0 then
--[[
      local AccessoryIndex,Slot = Char.GetAccessory(player);
      if seqno == 1 and select == CONST.��ť_ȷ�� and AccessoryIndex>=0 then
            if Item.GetData(AccessoryIndex, CONST.����_ID) ~= 900331  then
                Item.SetData(AccessoryIndex, CONST.����_ID, 900331);
                Item.SetData(AccessoryIndex, CONST.����_����, Item.GetData(AccessoryIndex, CONST.����_����).."[���]" );
                Item.SetData(AccessoryIndex, CONST.����_������ʧ, 1);
                Item.SetData(AccessoryIndex,CONST.����_����, 0);
                Item.UpItem(player, Slot);
                NLG.SetHeadIcon(player,1) 
            elseif Item.GetData(AccessoryIndex, CONST.����_ID) == 900331  then
                self:headcover(player, hcID);
            end
      elseif seqno == 1 and select == CONST.��ť_ȷ�� and AccessoryIndex<0 then
                NLG.SystemMessage(player, "���ϵ�y��·���٣���Ҫ�������b�Ʒ");
      elseif seqno == 1 and select == CONST.��ť_�ر� then
                local charPtr = Char.GetCharPointer(player)
                ffi.setMemoryInt32(charPtr + 0x5e8 + 0x188 + 0x18, 100);   --walkSpeed
                NLG.UpChar(player)
      end
]]
      if seqno == 1 and select == CONST.��ť_ȷ�� then
          if Char.EndEvent(player,0) == 1 then
                Char.SetData(player, CONST.����_����,150);
                NLG.UpChar(player)
                NLG.SetHeadIcon(player, 114206);
          end
          if  Char.EndEvent(player,21) == 1 then
                Char.SetData(player, CONST.����_����,200);
                NLG.UpChar(player)
                NLG.SetHeadIcon(player, 114177);
          end
          if  Char.EndEvent(player,21) == 1 and Char.EndEvent(player,105) == 1 then
                Char.SetData(player, CONST.����_����,250);
                NLG.UpChar(player)
                NLG.SetHeadIcon(player, 120054);
          end
          if  Char.EndEvent(player,21) == 1 and Char.EndEvent(player,105) == 1 and Char.EndEvent(player,143) == 1 then
                Char.SetData(player, CONST.����_����,300);
                NLG.UpChar(player)
                NLG.SetHeadIcon(player, 108510)
          end
      elseif seqno == 1 and select == CONST.��ť_�ر� then
                Char.SetData(player, CONST.����_����,100);
                NLG.UpChar(player)
      end
    end
  end)
  --ȫ꠴�
  self.feverNpc = self:NPC_createNormal('�򿨿��', 98972, { x = 38, y = 37, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.feverNpc, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "\\n\\n@c��һ�Iȫ꠴򿨡�\\n\\n�Ǵ򿨠�B���򿨠�B\\n\\n�򿨠�B���Ǵ򿨠�B\\n\\n[�_��]��ȫ��M�д򿨡�ȫ꠵Ĵ򿨽Y��\\n";
      NLG.ShowWindowTalked(player, self.feverNpc, CONST.����_��Ϣ��, CONST.��ť_ȷ���ر�, 2, msg);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(self.feverNpc, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.����_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select > 0 then
      if seqno == 2 and select == CONST.��ť_ȷ�� then
        for slot = 0,4 do
          local p = Char.GetPartyMember(player,slot)
          if(p>=0) then
                local daka = Char.GetData(p, CONST.����_��);
                local name = Char.GetData(p,CONST.CHAR_����);
                if daka == 1 then
                      Char.FeverStop(p);
                      NLG.UpChar(p);
                      NLG.SystemMessage(player, name.."�P�]�򿨡�");
                end
                if daka == 0 then
                      if Char.IsDummy(p) then
                          Char.SetData(p, CONST.CHAR_��ʱ, 24 * 3600);
                      end
                      Char.FeverStart(p);
                      NLG.UpChar(p);
                      NLG.SystemMessage(player, name.."�򿨳ɹ���");
                end
          else
                --NLG.SystemMessage(player, "�Mꠠ�B�����ô�ȫ꠴򿨡�");
                return
          end
        end
      end
    end
  end)
  --ȫ��aѪ
  self.healNpc = self:NPC_createNormal('��Ѫ���', 98972, { x = 39, y = 37, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.healNpc, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local msg = "\\n\\n@c�؏�ħ��ֵ��+��������ֵ��\\n\\n�؏�����ֵ\\n\\n�؏͌��������ֵ��ħ��ֵ\\n\\nһ�I�؏�ȫ�����͌���ħ��������\\n";
      NLG.ShowWindowTalked(player, self.healNpc, CONST.����_��Ϣ��, CONST.��ť_ȷ���ر�, 3, msg);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(self.healNpc, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.����_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    if select > 0 then
      if seqno == 3 and select == CONST.��ť_ȷ�� then
        gold = Char.GetData(player, CONST.CHAR_���);
        totalGold = 0;
        FpGold = 0;
        LpGold = 0;
        --Ӌ��؏Ϳ����~
        for slot = 0,4 do
          local p = Char.GetPartyMember(player,slot)
          if(p>=0) then
                local lp = Char.GetData(p, CONST.CHAR_Ѫ)
                local maxLp = Char.GetData(p, CONST.CHAR_���Ѫ)
                local fp = Char.GetData(p, CONST.CHAR_ħ)
                local maxFp = Char.GetData(p, CONST.CHAR_���ħ)
                if fp <= maxFp then
                      FpGold = FpGold + maxFp - fp;
                end
                if lp <= maxLp then
                      LpGold = LpGold + maxLp - lp;
                end
          end
        end
        print(FpGold,LpGold)
        if FpGold*0.5 >= LpGold then
          totalGold = FpGold;
        else
          totalGold = FpGold + LpGold - FpGold*0.5;
        end
        local msg = "\\n\\n@cȫ꠻؏���Ҫ���M"..totalGold.."������\\n\\n�F�н��X��"..gold.."������\\n\\n\\nҪ�؏͆᣿\\n";
        NLG.ShowWindowTalked(player, self.healNpc, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 31, msg);
      --������aѪħ
      elseif seqno == 31 and select == CONST.��ť_�� then
        if gold < totalGold then
                NLG.SystemMessage(player, '���Ų���o���؏�');
                return
        else
                if Char.PartyNum(player)>0 and player==Char.GetPartyMember(player,0) then
                    for slot = 0,4 do
                       local p = Char.GetPartyMember(player,slot);
                       if(p>=0) then
                           local maxLp = Char.GetData(p, CONST.CHAR_���Ѫ);
                           local maxFp = Char.GetData(p, CONST.CHAR_���ħ);
                           Char.SetData(p, CONST.CHAR_Ѫ, maxLp);
                           Char.SetData(p, CONST.CHAR_ħ, maxFp);
                           NLG.UpChar(p);
                           for petSlot  = 0,4 do
                              local petIndex = Char.GetPet(p,petSlot);
                              if petIndex >= 0 then
                                  local maxLp = Char.GetData(petIndex, CONST.CHAR_���Ѫ);
                                  local maxFp = Char.GetData(petIndex, CONST.CHAR_���ħ);
                                  Char.SetData(petIndex, CONST.CHAR_Ѫ, maxLp);
                                  Char.SetData(petIndex, CONST.CHAR_ħ, maxFp);
                                  Pet.UpPet(p, petIndex);
                              end
                           end
                       end
                    end
                    Char.AddGold(player, -totalGold);
                    NLG.UpChar(player);
                else
                    NLG.SystemMessage(player, '��L�ſ�ʹ�ã�');
                end
        end

      end
    end
  end)

  --������
  self.imageNpc = self:NPC_createNormal('������', 98972, { x = 40, y = 37, mapType = 0, map = 777, direction = 6 });
  self:NPC_regTalkedEvent(self.imageNpc, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local cdk = Char.GetData(player,CONST.����_CDK);
      SQL.Run("INSERT INTO lua_hook_character (Name,CdKey,OriginalImageNumber) SELECT Name,CdKey,OriginalImageNumber FROM tbl_character WHERE NOT EXISTS ( SELECT Name FROM lua_hook_character WHERE tbl_character.CdKey=lua_hook_character.CdKey)");
      local dressing_OImage = tonumber(SQL.Run("select OriginalImageNumber from lua_hook_character where CdKey='"..cdk.."'")["0_0"])
      local msg = ""..dressing_OImage.."|��������������\\n\\n�x[��]ʹ��ɫ���Q������\\n\\n�x[��]�Q��һ퓵�����\\n\\n      1 / 10\\n";
      NLG.ShowWindowTalked(player, self.imageNpc, CONST.����_ͼ��, CONST.��ť_�Ƿ�, 4, msg);
    end
    return
  end)
  self:NPC_regWindowTalkedEvent(self.imageNpc, function(npc, player, _seqno, _select, _data)
    local cdk = Char.GetData(player,CONST.����_CDK);
    local seqno = tonumber(_seqno)
    local select = tonumber(_select)
    local data = tonumber(_data)
    local dressing_BImage = tonumber(Char.GetData(player,CONST.����_����));
    local dressing_OImage = tonumber(SQL.Run("select OriginalImageNumber from lua_hook_character where CdKey='"..cdk.."'")["0_0"])
    if select > 0 then
      if seqno == 4 and select == CONST.��ť_�� then
            Char.SetData(player,CONST.����_����, dressing_OImage);
            Char.SetData(player,CONST.����_ԭ��, dressing_OImage);
            Char.SetData(player,CONST.����_ԭʼͼ��, dressing_OImage);
            NLG.UpChar(player)
      elseif seqno == 4 and select == CONST.��ť_�� then
            page = seqno*10+1;
            local dressing = tonumber(SQL.Run("select SwitchImageNumber2 from lua_hook_character where CdKey='"..cdk.."'")["0_0"])
            local msg = ""..dressing.."|��������������\\n\\n�x[��]ʹ��ɫ���Q������\\n\\n�x[��]�Q��һ퓵�����\\n\\n      2 / 10\\n";
            NLG.ShowWindowTalked(player, self.imageNpc, CONST.����_ͼ��, CONST.��ť_�Ƿ�, page, msg);
      end
      --�ڶ���������������չʾ
      if seqno == page and select == CONST.��ť_�� then
            local imagepage = page-40+1;
            if page<=49 then
                local dressing = tonumber(SQL.Run("select SwitchImageNumber"..imagepage.." from lua_hook_character where CdKey='"..cdk.."'")["0_0"])
                if dressing_BImage ~= dressing and dressing > 1 then
                    Char.SetData(player,CONST.����_����, dressing);
                    Char.SetData(player,CONST.����_ԭ��, dressing);
                    Char.SetData(player,CONST.����_ԭʼͼ��, dressing);
                    NLG.UpChar(player)                
                else
                    NLG.SystemMessage(player, 'Ո�ȵ�ӛȡ�õ���������Ƭ��');
                    return;
                end
            end
      elseif seqno == page and select == CONST.��ť_�� then
            page = page+1;
            local imagepage = page-40+1;
            if page<=49 then
                local dressing =  tonumber(SQL.Run("select SwitchImageNumber"..imagepage.." from lua_hook_character where CdKey='"..cdk.."'")["0_0"])
                local msg = ""..dressing.."|��������������\\n\\n�x[��]ʹ��ɫ���Q������\\n\\n�x[��]�Q��һ퓵�����\\n\\n      "..imagepage.." / 10\\n";
                NLG.ShowWindowTalked(player, self.imageNpc, CONST.����_ͼ��, CONST.��ť_�Ƿ�, page, msg);
            else
                return;
            end
      end

    end
  end)


end

Char.GetPetRank = function(playerIndex,slot)
  local petIndex = Char.GetPet(playerIndex, slot);
  if petIndex >= 0 then
    local arr_rank1 = Pet.GetArtRank(petIndex,CONST.PET_���);
    local arr_rank2 = Pet.GetArtRank(petIndex,CONST.PET_����);
    local arr_rank3 = Pet.GetArtRank(petIndex,CONST.PET_ǿ��);
    local arr_rank4 = Pet.GetArtRank(petIndex,CONST.PET_����);
    local arr_rank5 = Pet.GetArtRank(petIndex,CONST.PET_ħ��);
    local arr_rank11 = Pet.FullArtRank(petIndex, CONST.PET_���);
    local arr_rank21 = Pet.FullArtRank(petIndex, CONST.PET_����);
    local arr_rank31 = Pet.FullArtRank(petIndex, CONST.PET_ǿ��);
    local arr_rank41 = Pet.FullArtRank(petIndex, CONST.PET_����);
    local arr_rank51 = Pet.FullArtRank(petIndex, CONST.PET_ħ��);
    local a1 = math.abs(arr_rank11 - arr_rank1);
    local a2 = math.abs(arr_rank21 - arr_rank2);
    local a3 = math.abs(arr_rank31 - arr_rank3);
    local a4 = math.abs(arr_rank41 - arr_rank4);
    local a5 = math.abs(arr_rank51 - arr_rank5);
    local a6 = a1 + a2+ a3+ a4+ a5;
    return a6, a1, a2, a3, a4, a5;
  end
  return -1;
end

function QuickUI:imageCollection(charIndex,targetIndex,itemSlot)
    local cdk = Char.GetData(charIndex,CONST.����_CDK);
    local name = Char.GetData(charIndex, CONST.CHAR_����);
    SQL.Run("INSERT INTO lua_hook_character (Name,CdKey,OriginalImageNumber) SELECT Name,CdKey,OriginalImageNumber FROM tbl_character WHERE NOT EXISTS ( SELECT Name FROM lua_hook_character WHERE tbl_character.CdKey=lua_hook_character.CdKey)");
    local Name_data =  SQL.Run("select Name from lua_hook_character where CdKey='"..cdk.."'")["0_0"]

    local ItemIndex = Char.GetItemIndex(charIndex, itemSlot);
    local ItemID = Item.GetData(ItemIndex,0);
    local Special = Item.GetData(ItemIndex,CONST.����_��������);
    local Para1 = tonumber(Item.GetData(ItemIndex,CONST.����_�Ӳ�һ));
    local Para2 = tonumber(Item.GetData(ItemIndex,CONST.����_�Ӳζ�));

    if (Name_data == name) then
        if (Special == 14 and Para1 == 1 and Para2 ~= 0) then
            for image=2,10 do
                local Number =  tonumber(SQL.Run("select SwitchImageNumber"..image.." from lua_hook_character where Name='"..name.."'")["0_0"])
                if Number == 1 then
                    SQL.Run("update lua_hook_character set SwitchImageNumber"..image.." = '"..Para2.."' where Name='"..name.."'");
                    Char.DelItemBySlot(charIndex, itemSlot);
                    return;
                else
                    --NLG.SystemMessage(charIndex, '���������ղؕ��r�ѝM��');
                end
            end
        end
    end
end


Char.GetAccessory = function(charIndex)
  local itemType = {
    { type=15},{ type=16},{ type=17},{ type=18},{ type=19},{ type=20},{ type=21},
  }
  local ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_����1);
  if ItemIndex >= 0 then
    for k, v in ipairs(itemType) do
      if Item.GetData(ItemIndex, CONST.����_����)==v.type then
        return ItemIndex, CONST.EQUIP_����1;
      end
    end
  end
  ItemIndex = Char.GetItemIndex(charIndex, CONST.EQUIP_����2)
  if ItemIndex >= 0 then
    for k, v in ipairs(itemType) do
      if Item.GetData(ItemIndex, CONST.����_����)==v.type then
        return ItemIndex, CONST.EQUIP_����2;
      end
    end
  end
  return -1, -1;
end

function QuickUI:onUnload()
  self:logInfo('unload')
end

return QuickUI;
