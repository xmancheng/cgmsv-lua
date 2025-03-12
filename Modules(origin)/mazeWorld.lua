---ģ����
local Module = ModuleBase:createModule('mazeWorld')
local playerexp_itemid = 68011;    --���｛�ӱ�ȯ(1H)
local petexp_itemid = 68013;         --���｛�ӱ�ȯ(1H)
local exp_itemid = 70040;               --��ɫ�н��؈(1.5��)
local expshare_itemid = 70041;     --����W���b��

Module:addMigration(1, 'init lua_hook_worldboss', function()
  SQL.querySQL([[
      CREATE TABLE if not exists `lua_hook_worldboss` (
    `Name` char(32) COLLATE gbk_bin NOT NULL,
    `CdKey` char(32) COLLATE gbk_bin NOT NULL,
    `regNo` int(11) NOT NULL,
    `WorldLord1` int(10) NOT NULL Default 100000,
    `LordEnd1` int(10) NOT NULL Default 0,
    `WorldLord2` int(10) NOT NULL Default 200000,
    `LordEnd2` int(10) NOT NULL Default 0,
    `WorldLord3` int(10) NOT NULL Default 300000,
    `LordEnd3` int(10) NOT NULL Default 0,
    `WorldLord4` int(10) NOT NULL Default 400000,
    `LordEnd4` int(10) NOT NULL Default 0,
    `WorldLord5` int(10) NOT NULL Default 500000,
    `LordEnd5` int(10) NOT NULL Default 0,
    `WorldLord6` int(10) NOT NULL Default 600000,
    `LordEnd6` int(10) NOT NULL Default 0,
    `WorldLord7` int(10) NOT NULL Default 700000,
    `LordEnd7` int(10) NOT NULL Default 0,
    `WorldLord8` int(10) NOT NULL Default 800000,
    `LordEnd8` int(10) NOT NULL Default 0,
    `WorldLord9` int(10) NOT NULL Default 900000,
    `LordEnd9` int(10) NOT NULL Default 0,
    `WorldLord10` int(10) NOT NULL Default 1000000,
    `LordEnd10` int(10) NOT NULL Default 0,
    PRIMARY KEY (`CdKey`),
    KEY `regNo` (`regNo`) USING BTREE
  ) ENGINE=Innodb DEFAULT CHARSET=gbk COLLATE=gbk_bin
  ]])
end);


local worldPoints = {
  { "���Fɭ��Lv110", 0, 7900, 4, 1, 5000 },
  { "�Ŵ��z�ELv120", 0, 7901, 2, 60, 5000 },
  { "��ҹ؈��Lv130", 0, 60006, 107, 80, 5000 },
  { "��Į�{��Lv140", 0, 60008, 33, 24, 5000 },
  { "���`֮��Lv150", 0, 60010, 46, 42, 5000 },
  { "�����ؾ�Lv160", 0, 60012, 15, 15, 5000 },
  { "���RԭҰLv170", 0, 60014, 44, 51, 5000 },
  { "���剞��Lv180", 0, 60016, 26, 47, 5000 },
}

local mazeMap = {
    { 7900, 7900 }, { 7901, 7901 }, { 60006, 60006 }, { 60008, 60001 }, { 60010, 60001 }, { 60012, 60001 }, { 60014, 60001 },
}
local worldExp = {
    { Event="LordEnd1", L_level=101, R_level=110, Upload=120, UniItem=70258},
    { Event="LordEnd2", L_level=111, R_level=120, Upload=130, UniItem=70260},
    { Event="LordEnd3", L_level=121, R_level=130, Upload=140, UniItem=70262},
    { Event="LordEnd4", L_level=131, R_level=140, Upload=150, UniItem=70264},
    { Event="LordEnd5", L_level=141, R_level=150, Upload=160, UniItem=70266},
    { Event="LordEnd6", L_level=151, R_level=160, Upload=170, UniItem=70267},
    { Event="LordEnd7", L_level=161, R_level=170, Upload=180, UniItem=70270},
}

local Horcrux = {
  { 301, },  { 302, },  { 303, },  { 304, },  { 305, },  { 306, },  { 307, },
}
--- ҳ������
local function calcWarp()
  local totalpage = math.modf(#worldPoints / 7) + 1
  local remainder = math.fmod(#worldPoints, 7)
  return totalpage, remainder
end

--- ����ģ�鹳��
function Module:onLoad()
  self:logInfo('load')
  self:regCallback('GetExpEvent', Func.bind(self.onGetExpEvent,self));
  self:regCallback('LoginEvent', Func.bind(self.onLoginEvent, self));
  self:regCallback('LogoutEvent', Func.bind(self.onLogoutEvent, self));
  self:regCallback('DropEvent', Func.bind(self.LogoutEvent, self));
  self:regCallback('LoopEvent', Func.bind(self.InTheWorld_LoopEvent,self))
  local mazeNPC = self:NPC_createNormal('�r�Ղ���', 121001, { map = 1000, x = 242, y = 88, direction = 0, mapType = 0 })
  Char.SetData(mazeNPC,CONST.����_ENEMY_PetFlg+2,0)--�ɴ�͸��
  self:NPC_regWindowTalkedEvent(mazeNPC, function(npc, player, _seqno, _select, _data)
    local column = tonumber(_data)
    local page = tonumber(_seqno)
    local warpPage = page;
    local winButton = CONST.BUTTON_�ر�;
    local totalPage, remainder = calcWarp()
    --��ҳ16 ��ҳ32 �ر�/ȡ��2
    if _select > 0 then
      if _select == CONST.BUTTON_��һҳ then
        warpPage = warpPage + 1
        if (warpPage == totalPage) or ((warpPage == (totalPage - 1) and remainder == 0)) then
          winButton = CONST.BUTTON_��ȡ��
        else
          winButton = CONST.BUTTON_����ȡ��
        end
      elseif _select == CONST.BUTTON_��һҳ then
        warpPage = warpPage - 1
        if warpPage == 1 then
          winButton = CONST.BUTTON_��ȡ��
        else
          winButton = CONST.BUTTON_��ȡ��
        end
      elseif _select == 2 then
        warpPage = 1
        return
      end
      local count = 7 * (warpPage - 1)
      if warpPage == totalPage then
        local cdk = Char.GetData(player,CONST.����_CDK);
        local winMsg = "2\\n@cǰ���D������Y���gð�U\\n"
                               .."��������������������������������������������\\n";
        for i = 1 + count, remainder + count do
            local flag=i-1;
            local event = tonumber(SQL.Run("select LordEnd"..flag.." from lua_hook_worldboss where CdKey='"..cdk.."'")["0_0"])
            if (event == 1) then
                if (i>=#worldPoints+1) then
                        winMsg = winMsg
                else
                        winMsg = winMsg .. worldPoints[i][1] .. "  �����ÿ�˂����M: ".. worldPoints[i][6] .."\\n"
                end
            else
                winMsg = winMsg
            end
            --[[if (i>=9) then
                        winMsg = winMsg .. worldPoints[i][1] .. "  �����ÿ�˂����M: ".. worldPoints[i][6] .."\\n"
            end]]
        end
        NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, winButton, warpPage, winMsg);
      else
        local winMsg = "2\\n@cǰ���D������Y���gð�U\\n"
                           .."��������������������������������������������\\n"
        local cdk = Char.GetData(player,CONST.����_CDK);
        for i = 1 + count, 7 + count do
            local flag=i;
            local event = tonumber(SQL.Run("select LordEnd"..flag.." from lua_hook_worldboss where CdKey='"..cdk.."'")["0_0"])
            if (i==1) then
                winMsg = winMsg .. worldPoints[1][1] .. "  �����ÿ�˂����M: ".. worldPoints[1][6] .."\\n"
            end
            if (event == 1) then
                if (i>=7) then
                    winMsg = winMsg
                else
                    winMsg = winMsg .. worldPoints[i+1][1] .. "  �����ÿ�˂����M: ".. worldPoints[i+1][6] .."\\n"
                end
            else
                winMsg= winMsg
            end
        end
        NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, winButton, warpPage, winMsg);
      end
    else
      local count = 7 * (warpPage - 1) + column
      local short = worldPoints[count]
      local lastTimes = Char.GetExtData(player, "MazeTimeF") or 0;
      --[[
      if (Char.GetData(player,CONST.CHAR_���)<5000) then
          NLG.SystemMessage(player,"[ϵ�y]�Y���g���ʹ��r5000ħ�ţ���");
          return;
      elseif (Char.PartyNum(player)>=2) then
          NLG.SystemMessage(player,"[ϵ�y]�Y���g�Ҫ�����M�Ђ��ͣ���");
          return;
      ]]
      if (count==8) then
          if (Char.PartyNum(player)>=2) then
            NLG.SystemMessage(player,"[ϵ�y]�Y���g�Ҫ�����M�Ђ��ͣ���");
            return;
          end
          local flagEvent1 = Char.EndEvent(player,Horcrux[1][1]);
          local flagEvent2 = Char.EndEvent(player,Horcrux[2][1]);
          local flagEvent3 = Char.EndEvent(player,Horcrux[3][1]);
          local flagEvent4 = Char.EndEvent(player,Horcrux[4][1]);
          local flagEvent5 = Char.EndEvent(player,Horcrux[5][1]);
          local flagEvent6 = Char.EndEvent(player,Horcrux[6][1]);
          local flagEvent7 = Char.EndEvent(player,Horcrux[7][1]);
          if (flagEvent1==1 and flagEvent2==1 and flagEvent3==1 and flagEvent4==1 and flagEvent5==1 and flagEvent6==1 and flagEvent7==1) then
                  Char.AddGold(player, -5000);
                  Char.Warp(player, short[2], short[3], short[4], short[5])
          else
                  NLG.SystemMessage(player,"[ϵ�y]������������Ӳŷ����M���Y�񣡣�");
                  return;
          end
      else
          if lastTimes == 0 then
              local PartyNum = Char.PartyNum(player);
              if (PartyNum>0 and Char.GetData(player,CONST.����_���) >= short[6]*PartyNum) then
                local fee = short[6]*PartyNum;
		        Char.SetData(player,CONST.����_���, Char.GetData(player,CONST.����_���) - fee);
		        NLG.UpChar(player);
		        NLG.SystemMessage(player,"��L������"..fee.."��");
                Char.Warp(player, short[2], short[3], short[4], short[5])
                Char.SetExtData(player, "MazeTimeF", os.time());
                Char.SetExtData(player, "MazeTimeS", 0);
                Char.SetExtData(player, "MazeTimeT", 0);
                Char.SetLoopEvent('./lua/Modules/mazeWorld.lua','InTheWorld_LoopEvent',player,60000);
              elseif (PartyNum>0 and Char.GetData(player,CONST.����_���) < short[6]*PartyNum) then
		        NLG.SystemMessage(player,"����֧��ȫꠂ����M�ã�Ո��ɢ��顣");
              elseif (Char.GetData(player,CONST.����_���) >= short[6]) then
		        Char.SetData(player,CONST.����_���, Char.GetData(player,CONST.����_���) - short[6]);
		        NLG.UpChar(player);
                Char.Warp(player, short[2], short[3], short[4], short[5])
                Char.SetExtData(player, "MazeTimeF", os.time());
                Char.SetExtData(player, "MazeTimeS", 0);
                Char.SetExtData(player, "MazeTimeT", 0);
                Char.SetLoopEvent('./lua/Modules/mazeWorld.lua','InTheWorld_LoopEvent',player,60000);
              elseif (Char.GetData(player,CONST.����_���) < short[6]) then
		        NLG.SystemMessage(player,"�����M�ò��㡣");
              end
          else
              Char.Warp(player, short[2], short[3], short[4], short[5])
              NLG.SystemMessage(player,"[ϵ�y]߀�ڕr�ރȂ��Ͳ���Ҫ�M�á�");
              Char.SetLoopEvent('./lua/Modules/mazeWorld.lua','InTheWorld_LoopEvent',player,60000);
          end
      end
    end
  end)
  self:NPC_regTalkedEvent(mazeNPC, function(npc, player)
    local name = Char.GetData(player,CONST.����_����);
    local cdk = Char.GetData(player,CONST.����_CDK);
    local regNumber = Char.GetData(player,CONST.����_RegistNumber);

    local ret, open = nil,nil;
    ret, open = pcall(SQL.Run,"select regNo from lua_hook_worldboss where CdKey='"..cdk.."'")
    if (open==-3) then
      SQL.querySQL("REPLACE INTO lua_hook_worldboss (Name,CdKey,regNo) VALUES ("..SQL.sqlValue(name)..","..SQL.sqlValue(cdk)..","..SQL.sqlValue(regNumber)..") ");
    end
    --SQL.Run("INSERT INTO lua_hook_worldboss (Name,CdKey) SELECT Name,CdKey FROM tbl_character WHERE NOT EXISTS ( SELECT Name FROM lua_hook_worldboss WHERE tbl_character.CdKey=lua_hook_worldboss.CdKey)");

    if (NLG.CanTalk(npc, player) == true) then
      local winCase = CONST.����_ѡ���
      local winButton = CONST.BUTTON_�ر�;
      local winMsg = "2\\n@cǰ���D������Y���gð�U\\n"
                           .."��������������������������������������������\\n"
      for i = 1,7 do
            local flag=i;
            local event = tonumber(SQL.Run("select LordEnd"..flag.." from lua_hook_worldboss where CdKey='"..cdk.."'")["0_0"])
            if (i==1) then
                winMsg = winMsg .. worldPoints[1][1] .. "  �����ÿ�˂����M: ".. worldPoints[1][6] .."\\n"
            end
            if (event == 1) then
                if (i>=7) then
                    winButton = CONST.BUTTON_��ȡ��;
                    winMsg = winMsg
                else
                    winMsg = winMsg .. worldPoints[i+1][1] .. "  �����ÿ�˂����M: ".. worldPoints[i+1][6] .."\\n"
                end
            else
                winMsg = winMsg
            end
      end
      if (Char.GetData(player, CONST.����_��ɫ)<=0) then
                winMsg = "\\n\\n\\n@c��Č���߀����\\n"
                       .."\\n�D�����ف��@�e\\n";
                winCase = CONST.����_��Ϣ��;
                winButton = CONST.BUTTON_�ر�;
      end
      NLG.ShowWindowTalked(player, npc, winCase, winButton, 1, winMsg);
    end
    return
  end)

end


function Module:onGetExpEvent(charIndex, exp)
	--[[worldLayer1 = Char.EndEvent(charIndex,301);	worldLayer2 = Char.EndEvent(charIndex,302);	worldLayer3 = Char.EndEvent(charIndex,303);
	worldLayer4 = Char.EndEvent(charIndex,304);	worldLayer5 = Char.EndEvent(charIndex,305);	worldLayer6 = Char.EndEvent(charIndex,306);
	worldLayer7 = Char.EndEvent(charIndex,307);
	]]
	local Target_FloorId = Char.GetData(charIndex,CONST.CHAR_��ͼ);
	--print(Target_FloorId)
	if (Char.GetData(charIndex, CONST.����_����) == CONST.��������_�� and Char.GetData(charIndex, CONST.����_��ɫ)>0 and Char.GetData(charIndex,CONST.����_�ȼ�)>=101) then
		if (Target_FloorId==mazeMap[1][1] or Target_FloorId==mazeMap[1][2]) then
			if (Char.GetData(charIndex,CONST.����_�ȼ�)>=worldExp[1].R_level and Char.GetWorldCheck(1) == 0) then
				NLG.SystemMessage(charIndex,"���Ѹ���D����"..worldExp[1].R_level.."����Ո�c��Һ���ͨ�PBOSS����ǰ����ѱ��i����")
				return 0
			elseif (Char.GetData(charIndex,CONST.����_�ȼ�)>=worldExp[1].Upload and Char.GetWorldCheck(1) == 1) then
				NLG.SystemMessage(charIndex,"Ոǰ����һ�������c��Һ���ͨ�PBOSS����ǰ����ѱ��i����")
				return 0
			elseif (Char.GetData(charIndex,CONST.����_�ȼ�)>=worldExp[1].L_level and Char.GetData(charIndex,CONST.����_�ȼ�)<worldExp[1].R_level) then
				for Slot=0,4 do
					local PartyCharIndex = Char.GetPartyMember(charIndex,Slot);
					if (PartyCharIndex>=0 and Char.ItemNum(PartyCharIndex,worldExp[1].UniItem)>0 and Target_FloorId==mazeMap[1][1]) then    --�����ж���װ��
						NLG.SystemMessage(charIndex,"[��Ѫ����b��] ���ӳ�1.5����");
						return exp * 1.5;  --��ɫ��ȡ�ľ���1.5��
					end
				end
				return exp;
			end
		elseif (Target_FloorId==mazeMap[2][1] or Target_FloorId==mazeMap[2][2]) then
			if (Char.GetData(charIndex,CONST.����_�ȼ�)>=worldExp[2].R_level and Char.GetWorldCheck(2) == 0) then
				NLG.SystemMessage(charIndex,"���Ѹ���D����"..worldExp[2].R_level.."����Ո�c��Һ���ͨ�PBOSS����ǰ����ѱ��i����")
				return 0
			elseif (Char.GetData(charIndex,CONST.����_�ȼ�)>=worldExp[2].Upload and Char.GetWorldCheck(2) == 1) then
				NLG.SystemMessage(charIndex,"Ոǰ����һ�������c��Һ���ͨ�PBOSS����ǰ����ѱ��i����")
				return 0
			elseif (Char.GetData(charIndex,CONST.����_�ȼ�)>=worldExp[2].L_level and Char.GetData(charIndex,CONST.����_�ȼ�)<worldExp[2].R_level) then
				for Slot=0,4 do
					local PartyCharIndex = Char.GetPartyMember(charIndex,Slot);
					if (PartyCharIndex>=0 and Char.ItemNum(PartyCharIndex,worldExp[2].UniItem)>0 and Target_FloorId==mazeMap[2][1]) then    --�����ж���װ��
						NLG.SystemMessage(charIndex,"[��Ѫ����b��] ���ӳ�1.5����");
						return exp * 1.5;  --��ɫ��ȡ�ľ���1.5��
					end
				end
				return exp;
			end
		elseif (Target_FloorId==mazeMap[3][1] or Target_FloorId==mazeMap[3][2]) then
			if (Char.GetData(charIndex,CONST.����_�ȼ�)>=worldExp[3].R_level and Char.GetWorldCheck(3) == 0) then
				NLG.SystemMessage(charIndex,"���Ѹ���D����"..worldExp[3].R_level.."����Ո�c��Һ���ͨ�PBOSS����ǰ����ѱ��i����")
				return 0
			elseif (Char.GetData(charIndex,CONST.����_�ȼ�)>=worldExp[3].Upload and Char.GetWorldCheck(3) == 1) then
				NLG.SystemMessage(charIndex,"Ոǰ����һ�������c��Һ���ͨ�PBOSS����ǰ����ѱ��i����")
				return 0
			elseif (Char.GetData(charIndex,CONST.����_�ȼ�)>=worldExp[3].L_level and Char.GetData(charIndex,CONST.����_�ȼ�)<worldExp[3].R_level) then
				for Slot=0,4 do
					local PartyCharIndex = Char.GetPartyMember(charIndex,Slot);
					if (PartyCharIndex>=0 and Char.ItemNum(PartyCharIndex,worldExp[3].UniItem)>0 and Target_FloorId==mazeMap[3][1]) then    --�����ж���װ��
						NLG.SystemMessage(charIndex,"[��Ѫ����b��] ���ӳ�1.5����");
						return exp * 1.5;  --��ɫ��ȡ�ľ���1.5��
					end
				end
				return exp;
			end
		elseif (Target_FloorId==mazeMap[4][1] or Target_FloorId==mazeMap[4][2]) then
			if (Char.GetData(charIndex,CONST.����_�ȼ�)>=worldExp[4].R_level and Char.GetWorldCheck(4) == 0) then
				NLG.SystemMessage(charIndex,"���Ѹ���D����"..worldExp[4].R_level.."����Ո�c��Һ���ͨ�PBOSS����ǰ����ѱ��i����")
				return 0
			elseif (Char.GetData(charIndex,CONST.����_�ȼ�)>=worldExp[4].Upload and Char.GetWorldCheck(4) == 1) then
				NLG.SystemMessage(charIndex,"Ոǰ����һ�������c��Һ���ͨ�PBOSS����ǰ����ѱ��i����")
				return 0
			elseif (Char.GetData(charIndex,CONST.����_�ȼ�)>=worldExp[4].L_level and Char.GetData(charIndex,CONST.����_�ȼ�)<worldExp[4].R_level) then
				for Slot=0,4 do
					local PartyCharIndex = Char.GetPartyMember(charIndex,Slot);
					if (PartyCharIndex>=0 and Char.ItemNum(PartyCharIndex,worldExp[4].UniItem)>0 and Target_FloorId==mazeMap[4][1]) then    --�����ж���װ��
						NLG.SystemMessage(charIndex,"[��Ѫ����b��] ���ӳ�1.5����");
						return exp * 1.5;  --��ɫ��ȡ�ľ���1.5��
					end
				end
				return exp;
			end
		elseif (Target_FloorId==mazeMap[5][1] or Target_FloorId==mazeMap[5][2]) then
			if (Char.GetData(charIndex,CONST.����_�ȼ�)>=worldExp[5].R_level and Char.GetWorldCheck(5) == 0) then
				NLG.SystemMessage(charIndex,"���Ѹ���D����"..worldExp[5].R_level.."����Ո�c��Һ���ͨ�PBOSS����ǰ����ѱ��i����")
				return 0
			elseif (Char.GetData(charIndex,CONST.����_�ȼ�)>=worldExp[5].Upload and Char.GetWorldCheck(5) == 1) then
				NLG.SystemMessage(charIndex,"Ոǰ����һ�������c��Һ���ͨ�PBOSS����ǰ����ѱ��i����")
				return 0
			elseif (Char.GetData(charIndex,CONST.����_�ȼ�)>=worldExp[5].L_level and Char.GetData(charIndex,CONST.����_�ȼ�)<worldExp[5].R_level) then
				for Slot=0,4 do
					local PartyCharIndex = Char.GetPartyMember(charIndex,Slot);
					if (PartyCharIndex>=0 and Char.ItemNum(PartyCharIndex,worldExp[5].UniItem)>0 and Target_FloorId==mazeMap[5][1]) then    --�����ж���װ��
						NLG.SystemMessage(charIndex,"[��Ѫ����b��] ���ӳ�1.5����");
						return exp * 1.5;  --��ɫ��ȡ�ľ���1.5��
					end
				end
				return exp;
			end
		elseif (Target_FloorId==mazeMap[6][1] or Target_FloorId==mazeMap[6][2]) then
			if (Char.GetData(charIndex,CONST.����_�ȼ�)>=worldExp[6].R_level and Char.GetWorldCheck(6) == 0) then
				NLG.SystemMessage(charIndex,"���Ѹ���D����"..worldExp[6].R_level.."����Ո�c��Һ���ͨ�PBOSS����ǰ����ѱ��i����")
				return 0
			elseif (Char.GetData(charIndex,CONST.����_�ȼ�)>=worldExp[6].Upload and Char.GetWorldCheck(6) == 1) then
				NLG.SystemMessage(charIndex,"Ոǰ����һ�������c��Һ���ͨ�PBOSS����ǰ����ѱ��i����")
				return 0
			elseif (Char.GetData(charIndex,CONST.����_�ȼ�)>=worldExp[6].L_level and Char.GetData(charIndex,CONST.����_�ȼ�)<worldExp[6].R_level) then
				for Slot=0,4 do
					local PartyCharIndex = Char.GetPartyMember(charIndex,Slot);
					if (PartyCharIndex>=0 and Char.ItemNum(PartyCharIndex,worldExp[6].UniItem)>0 and Target_FloorId==mazeMap[6][1]) then    --�����ж���װ��
						NLG.SystemMessage(charIndex,"[��Ѫ����b��] ���ӳ�1.5����");
						return exp * 1.5;  --��ɫ��ȡ�ľ���1.5��
					end
				end
				return exp;
			end
		elseif (Target_FloorId==mazeMap[7][1] or Target_FloorId==mazeMap[7][2]) then
			if (Char.GetData(charIndex,CONST.����_�ȼ�)>=worldExp[7].R_level and Char.GetWorldCheck(7) == 0) then
				NLG.SystemMessage(charIndex,"���Ѹ���D����"..worldExp[7].R_level.."����Ո�c��Һ���ͨ�PBOSS����ǰ����ѱ��i����")
				return 0
			elseif (Char.GetData(charIndex,CONST.����_�ȼ�)>=worldExp[7].Upload and Char.GetWorldCheck(7) == 1) then
				NLG.SystemMessage(charIndex,"Ոǰ����һ�������c��Һ���ͨ�PBOSS����ǰ����ѱ��i����")
				return 0
			elseif (Char.GetData(charIndex,CONST.����_�ȼ�)>=worldExp[7].L_level and Char.GetData(charIndex,CONST.����_�ȼ�)<worldExp[7].R_level) then
				for Slot=0,4 do
					local PartyCharIndex = Char.GetPartyMember(charIndex,Slot);
					if (PartyCharIndex>=0 and Char.ItemNum(PartyCharIndex,worldExp[7].UniItem)>0 and Target_FloorId==mazeMap[7][1]) then    --�����ж���װ��
						NLG.SystemMessage(charIndex,"[��Ѫ����b��] ���ӳ�1.5����");
						return exp * 1.5;  --��ɫ��ȡ�ľ���1.5��
					end
				end
				return exp;
			end
		else
			if Char.GetData(charIndex,CONST.����_���Ŀ���) == 1 then
				NLG.SystemMessage(charIndex,"�D����Ոǰ���Y���g����һ�����磬��ǰ����ѱ��i����")
			end
			return 0
		end
	else
		if (Char.GetData(charIndex, CONST.����_����) == CONST.��������_��) then
			local PetIndex = charIndex;
			local OwnercharIndex = Pet.GetOwner(PetIndex);
			if (Char.ItemNum(OwnercharIndex,petexp_itemid) == 1) then
				local exp=exp * 2;
				if (Char.ItemNum(OwnercharIndex,expshare_itemid) > 0) then
					for Slot=0,4 do
						local PocketPetIndex = Char.GetPet(OwnercharIndex,Slot);
						if (PocketPetIndex>=0 and PocketPetIndex~=PetIndex) then
							local Exp = Char.GetData(PocketPetIndex,%����_����%);
							local Ne = Exp + exp;
							Char.SetData(PocketPetIndex,%����_����%,Ne);
							Pet.UpPet(OwnercharIndex, PocketPetIndex);
							--NLG.TalkToCli(OwnercharIndex,-1,"[����ѧϰ��] ���ﾭ����˫��������������",%��ɫ_��ɫ%,%����_��%);
						end
					end
				end
				return exp;  --�����ȡ�ľ���2��
			elseif (Char.ItemNum(OwnercharIndex,petexp_itemid) == 0) then
				local exp=exp;
				if (Char.ItemNum(OwnercharIndex,expshare_itemid) > 0) then
					for Slot=0,4 do
						local PocketPetIndex = Char.GetPet(OwnercharIndex,Slot);
						if (PocketPetIndex>=0 and PocketPetIndex~=PetIndex) then
							local Exp = Char.GetData(PocketPetIndex,%����_����%);
							local Ne = Exp + exp;
							Char.SetData(PocketPetIndex,%����_����%,Ne);
							Pet.UpPet(OwnercharIndex, PocketPetIndex);
							--NLG.TalkToCli(OwnercharIndex,-1,"[����ѧϰ��] ���ﾭ���ѹ�����������",%��ɫ_��ɫ%,%����_��%);
						end
					end
				end
				return exp;  --�����ȡ�ľ����޼ӱ�
			end
		elseif (Char.GetData(charIndex, CONST.����_����) == CONST.��������_��) then
 			if (Char.ItemNum(charIndex,playerexp_itemid) >= 0 or Char.ItemNum(charIndex,exp_itemid) >= 0) then
				if(Char.ItemNum(charIndex,exp_itemid) > 0 and Char.ItemNum(charIndex,playerexp_itemid) > 0) then
					return exp * 3;  --��ɫ��ȡ�ľ���3��
				elseif(Char.ItemNum(charIndex,exp_itemid) > 0 and Char.ItemNum(charIndex,playerexp_itemid) == 0) then
					return exp * 1.5;  --��ɫ��ȡ�ľ���1.5��
				elseif(Char.ItemNum(charIndex,exp_itemid) == 0 and Char.ItemNum(charIndex,playerexp_itemid) > 0) then
					return exp * 2;  --��ɫ��ȡ�ľ���˫��
				end
			end
		end
	end
end

function InTheWorld_LoopEvent(player)
 if player>=0 then
  local FTime = Char.GetExtData(player, "MazeTimeF") or 0;
  local STime = Char.GetExtData(player, "MazeTimeS") or 0;
  local TTime = Char.GetExtData(player, "MazeTimeT") or 0;
  local Target_FloorId = Char.GetData(player,CONST.����_��ͼ);
  if FTime > 0 then
    if STime >0 then
        if (os.time() - TTime) >= 12000 - (STime - FTime) and Target_FloorId>=7900 and Target_FloorId<=7907 then
            Char.Warp(player,0,1000,241,88);
            NLG.SystemMessage(player,"[ϵ�y]�r�޽Y�������x�_�Y���g��");
            Char.SetExtData(player, "MazeTimeF", 0);
            Char.SetExtData(player, "MazeTimeS", 0);
            Char.SetExtData(player, "MazeTimeT", 0);
            Char.UnsetLoopEvent(player);
        elseif (os.time() - TTime) == 300 - (STime - FTime) and Target_FloorId>=7900 and Target_FloorId<=7907 then
            NLG.SystemMessage(player,"[ϵ�y]ʣ�����犌������x�_�Y���g��");
        end
    else
        if (os.time() - FTime) >= 12000 and Target_FloorId>=7900 and Target_FloorId<=7907 then
            Char.Warp(player,0,1000,241,88);
            NLG.SystemMessage(player,"[ϵ�y]�r�޽Y�������x�_�Y���g��");
            Char.SetExtData(player, "MazeTimeF", 0);
            Char.SetExtData(player, "MazeTimeS", 0);
            Char.SetExtData(player, "MazeTimeT", 0);
            Char.UnsetLoopEvent(player);
        elseif (os.time() - FTime) == 300 and Target_FloorId>=7900 and Target_FloorId<=7907 then
            NLG.SystemMessage(player,"[ϵ�y]ʣ�����犌������x�_�Y���g��");
        end
    end
  else

  end
 end
end

function Module:onLogoutEvent(player)
 if player>=0 then
  local FTime = Char.GetExtData(player, "MazeTimeF") or 0;
  local STime = Char.GetExtData(player, "MazeTimeS") or 0;
  local TTime = Char.GetExtData(player, "MazeTimeT") or 0;
  if FTime > 0 then
    if STime >0 then
            Char.SetExtData(player, "MazeTimeF", 0);
            Char.SetExtData(player, "MazeTimeS", 0);
            Char.SetExtData(player, "MazeTimeT", 0);
    else
            Char.SetExtData(player, "MazeTimeS", os.time());
    end
    Char.UnsetLoopEvent(player);
  end
 end
end

function Module:onLoginEvent(player)
 if player>=0 then
  local FTime = Char.GetExtData(player, "MazeTimeF") or 0;
  local STime = Char.GetExtData(player, "MazeTimeS") or 0;
  local TTime = Char.GetExtData(player, "MazeTimeT") or 0;
  if FTime > 0 then
            Char.SetExtData(player, "MazeTimeT", os.time());
            Char.SetLoopEvent('./lua/Modules/mazeWorld.lua','InTheWorld_LoopEvent',player,60000);
  else
            local Target_FloorId = Char.GetData(player,CONST.����_��ͼ);
            if Target_FloorId>=7900 and Target_FloorId<=7907 then
                Char.Warp(player,0,1000,241,88);
                Char.UnsetLoopEvent(player);
                NLG.SystemMessage(player,"[ϵ�y]�r�Ղ��ͻ�ԭ�����硣");
            end
  end
 end
end

Char.GetWorldCheck = function(chapter)
	local LordEnd = worldExp[chapter].Event;
	local ret = SQL.Run("select Name,"..LordEnd.." from lua_hook_worldboss order by "..LordEnd.." desc ");
	if (type(ret)=="table" and ret["0_1"]~=nil) then
		worldLayer = tonumber(ret["0_1"]);
	end
	return worldLayer;
end
--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
