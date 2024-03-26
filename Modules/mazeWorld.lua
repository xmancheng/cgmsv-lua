---ģ����
local Module = ModuleBase:createModule('mazeWorld')
local playerexp_itemid = 68011;    --���｛�ӱ�ȯ(1H)
local petexp_itemid = 68013;         --���｛�ӱ�ȯ(1H)
local exp_itemid = 70040;               --��ɫ�н��؈(1.5��)
local expshare_itemid = 70041;     --����W���b��

local worldPoints = {
  { "���մ�Lv1", 0, 60001, 21, 30 },
  { "���Fɭ��Lv30", 0, 60002, 114, 104 },
  { "�Ŵ��z�ELv50", 0, 60004, 10, 10 },
  { "��ҹ؈��Lv70", 0, 60006, 10, 10 },
  { "��F����Lv90", 0, 60008, 10, 10 },
  { "���Ѝ���Lv110", 0, 60010, 10, 10 },
  { "�����u�ZLv130", 0, 60012, 10, 10 },
  { "Ⱥ��֮�pLv150", 0, 60014, 10, 10 },
}

--- ҳ������
local function calcWarp()
  local totalpage = math.modf(#worldPoints / 6) + 1
  local remainder = math.fmod(#worldPoints, 6)
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
  local mazeNPC = self:NPC_createNormal('�Y��������T', 108511, { map = 25003, x = 15, y = 28, direction = 0, mapType = 0 })
  self:NPC_regWindowTalkedEvent(mazeNPC, function(npc, player, _seqno, _select, _data)
    local column = tonumber(_data)
    local page = tonumber(_seqno)
    local warpPage = page;
    local winMsg = "3\\n@cǰ���D������Y����ð�U\\n"
                           .."\\n�����T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
                           .. worldPoints[1][1] .. "\\n";
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
      local count = 6 * (warpPage - 1)
      if warpPage == totalPage then
        for i = 1 + count, remainder + count do
          winMsg = winMsg .. worldPoints[i][1] .. "\\n"
        end
      else
        for i = 1 + count, 6 + count do
          winMsg = winMsg .. worldPoints[i][1] .. "\\n"
        end
      end
      NLG.ShowWindowTalked(player, npc, CONST.����_ѡ���, winButton, warpPage, winMsg);
    else
      local count = 6 * (warpPage - 1) + column
      local short = worldPoints[count]
      local lastTimes = Char.GetExtData(player, "MazeTimeF") or 0;
      if (Char.GetData(player,CONST.CHAR_���)<5000) then
          NLG.SystemMessage(player,"[ϵ�y]]�Y������ʹ��r5000ħ�ţ���");
          return;
      elseif (Char.PartyNum(player)>=2) then
          NLG.SystemMessage(player,"[ϵ�y]�Y�����Ҫ�����M�Ђ��ͣ���");
          return;
      else
          if lastTimes == 0 then
              Char.AddGold(player, -5000);
              Char.Warp(player, short[2], short[3], short[4], short[5])
              Char.SetExtData(player, "MazeTimeF", os.time());
              Char.SetExtData(player, "MazeTimeS", 0);
              Char.SetLoopEvent('./lua/Modules/mazeWorld.lua','InTheWorld_LoopEvent',player,60000);
          else
              Char.Warp(player, short[2], short[3], short[4], short[5])
              Char.SetLoopEvent('./lua/Modules/mazeWorld.lua','InTheWorld_LoopEvent',player,60000);
          end
      end
    end
  end)
  self:NPC_regTalkedEvent(mazeNPC, function(npc, player)
    if (NLG.CanTalk(npc, player) == true) then
      local winCase = CONST.����_ѡ���
      local winButton = CONST.BUTTON_�ر�;
      local msg = "3\\n@cǰ���D������Y����ð�U\\n"
                           .."\\n�����T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T\\n"
                           .. worldPoints[1][1] .. "\\n";
      for i = 1,7 do
        local flag=i+300;
        if (Char.EndEvent(player,flag) == 1) then
            msg = msg .. worldPoints[i+1][1] .. "\\n"
            if (i>=7) then
                winButton = CONST.BUTTON_��ȡ��;
            end
        else
            msg = msg
        end
      end
      --[[if (Char.GetData(player, CONST.����_��ɫ)<=0 or Char.GetData(player, CONST.ALBUM31)<=0) then
                msg = "\\n\\n\\n@c��Č���߀����\\n"
                                            .."\\n�D�����ف��@�e\\n";
                winCase = CONST.����_��Ϣ��;
      end]]
      NLG.ShowWindowTalked(player, npc, winCase, winButton, 1, msg);
    end
    return
  end)

end


function Module:onGetExpEvent(charIndex, exp)
	local ret1 = SQL.Run("select EndEvent301 from tbl_character order by EndEvent301 desc ");
	local ret2 = SQL.Run("select EndEvent302 from tbl_character order by EndEvent302 desc ");
	local ret3 = SQL.Run("select EndEvent303 from tbl_character order by EndEvent303 desc ");
	local ret4 = SQL.Run("select EndEvent304 from tbl_character order by EndEvent304 desc ");
	local ret5 = SQL.Run("select EndEvent305 from tbl_character order by EndEvent305 desc ");
	local ret6 = SQL.Run("select EndEvent306 from tbl_character order by EndEvent306 desc ");
	local ret7 = SQL.Run("select EndEvent307 from tbl_character order by EndEvent307 desc ");
	if (type(ret1)=="table" and ret1["1_0"]~=nil) then
		worldLayer1 = ret1["1_0"];
	elseif (type(ret2)=="table" and ret2["1_0"]~=nil) then
		worldLayer2 = ret2["1_0"];
	elseif (type(ret3)=="table" and ret3["1_0"]~=nil) then
		worldLayer3 = ret3["1_0"];
	elseif (type(ret4)=="table" and ret4["1_0"]~=nil) then
		worldLayer4 = ret4["1_0"];
	elseif (type(ret5)=="table" and ret5["1_0"]~=nil) then
		worldLayer5 = ret5["1_0"];
	elseif (type(ret6)=="table" and ret6["1_0"]~=nil) then
		worldLayer6 = ret6["1_0"];
	elseif (type(ret7)=="table" and ret7["1_0"]~=nil) then
		worldLayer7 = ret7["1_0"];
	end
	--[[worldLayer1 = Char.EndEvent(charIndex,301);	worldLayer2 = Char.EndEvent(charIndex,302);	worldLayer3 = Char.EndEvent(charIndex,303);
	worldLayer4 = Char.EndEvent(charIndex,304);	worldLayer5 = Char.EndEvent(charIndex,305);	worldLayer6 = Char.EndEvent(charIndex,306);
	worldLayer7 = Char.EndEvent(charIndex,307);
	]]
	if (Char.GetData(charIndex, CONST.����_��ɫ)>0 or Char.GetData(charIndex, CONST.ALBUM31)>0) then
		if Char.GetData(charIndex,CONST.����_�ȼ�) >= 30 and worldLayer1 == 0 then
			NLG.SystemMessage(charIndex,"���Ѹ���D����30����Ո�c��Һ���ͨ�PBOSS����ǰ����ѱ��i����")
			return 0
		end
		if Char.GetData(charIndex,CONST.����_�ȼ�) >= 50 and worldLayer2 == 0 then
			NLG.SystemMessage(charIndex,"���Ѹ���D����50����Ո�c��Һ���ͨ�PBOSS����ǰ����ѱ��i����")
			return 0
		end
		if Char.GetData(charIndex,CONST.����_�ȼ�) >= 70 and worldLayer3 == 0 then
			NLG.SystemMessage(charIndex,"���Ѹ���D����70����Ո�c��Һ���ͨ�PBOSS����ǰ����ѱ��i����")
			return 0
		end
		if Char.GetData(charIndex,CONST.����_�ȼ�) >= 90 and worldLayer4 == 0 then
			NLG.SystemMessage(charIndex,"���Ѹ���D����90����Ո�c��Һ���ͨ�PBOSS����ǰ����ѱ��i����")
			return 0
		end
		if Char.GetData(charIndex,CONST.����_�ȼ�) >= 110 and worldLayer5 == 0 then
			NLG.SystemMessage(charIndex,"���Ѹ���D����110����Ո�c��Һ���ͨ�PBOSS����ǰ����ѱ��i����")
			return 0
		end
		if Char.GetData(charIndex,CONST.����_�ȼ�) >= 130 and worldLayer6 == 0 then
			NLG.SystemMessage(charIndex,"���Ѹ���D����130����Ո�c��Һ���ͨ�PBOSS����ǰ����ѱ��i����")
			return 0
		end
		if Char.GetData(charIndex,CONST.����_�ȼ�) >= 150 and worldLayer7 == 0 then
			NLG.SystemMessage(charIndex,"���Ѹ���D����150����Ո�c��Һ���ͨ�PBOSS����ǰ����ѱ��i����")
			return 0
		end
	else
		if(Char.ItemNum(charIndex,playerexp_itemid) >= 0 or Char.ItemNum(charIndex,petexp_itemid) >= 0 or Char.ItemNum(charIndex,expshare_itemid) >= 0 or Char.ItemNum(charIndex,exp_itemid) >= 0) then
			if(Char.ItemNum(charIndex,expshare_itemid) > 0) then
				for Slot=0,4 do
					local PetIndex = Char.GetPet(charIndex,Slot);
					if(PetIndex >=0 and Char.ItemNum(charIndex,petexp_itemid) == 0) then
						local Exp = Char.GetData(PetIndex,%����_����%);
						local Ne = Exp + exp;
						Char.SetData(PetIndex,%����_����%,Ne);
						NLG.UpChar(PetIndex);
						--NLG.TalkToCli(charIndex,-1,"[����ѧϰ��] ��ɫԭʼ�����ѹ�������г��",%��ɫ_��ɫ%,%����_��%);
					end
					if(PetIndex >=0 and Char.ItemNum(charIndex,petexp_itemid) == 1) then
						local Exp = Char.GetData(PetIndex,%����_����%);
						local Ne = Exp + exp* 2;
						Char.SetData(PetIndex,%����_����%,Ne);
						NLG.UpChar(PetIndex);
						--NLG.TalkToCli(charIndex,-1,"[����ѧϰ��] ��ɫԭʼ������˫����������г��",%��ɫ_��ɫ%,%����_��%);
					end
				end
			end
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

function InTheWorld_LoopEvent(player)
  local FTime = Char.GetExtData(player, "MazeTimeF") or 0;
  local STime = Char.GetExtData(player, "MazeTimeS") or 0;
  local Target_FloorId = Char.GetData(player,CONST.CHAR_��ͼ);
  if FTime > 0 then
    if STime >0 then
        if ( (os.time() - STime) + (STime - FTime) ) >= 12000 and Target_FloorId>=60002 and Target_FloorId<=60007 then
            Char.Warp(player,0,25003,14,27);
            NLG.SystemMessage(player,"[ϵ�y]�r�޽Y�������x�_�Y���硣");
            Char.SetExtData(player, "MazeTimeF", 0);
            Char.SetExtData(player, "MazeTimeS", 0);
            Char.UnsetLoopEvent(player);
        elseif ( (os.time() - STime) + (STime - FTime) ) >= 300 and Target_FloorId>=60002 and Target_FloorId<=60007 then
            NLG.SystemMessage(player,"[ϵ�y]ʣ�����犌������x�_�Y���硣");
        end
    else
        if (os.time() - FTime) >= 12000 and Target_FloorId>=60002 and Target_FloorId<=60007 then
            Char.Warp(player,0,25003,14,27);
            NLG.SystemMessage(player,"[ϵ�y]�r�޽Y�������x�_�Y���硣");
            Char.SetExtData(player, "MazeTimeF", 0);
            Char.SetExtData(player, "MazeTimeS", 0);
            Char.UnsetLoopEvent(player);
        elseif (os.time() - FTime) >= 300 and Target_FloorId>=60002 and Target_FloorId<=60007 then
            NLG.SystemMessage(player,"[ϵ�y]ʣ�����犌������x�_�Y���硣");
        end
    end
  else

  end
end

function Module:onLogoutEvent(player)
  local FTime = Char.GetExtData(player, "MazeTimeF") or 0;
  local STime = Char.GetExtData(player, "MazeTimeS") or 0;
  if FTime > 0 then
    if STime >0 then
            Char.SetExtData(player, "MazeTimeF", 0);
            Char.SetExtData(player, "MazeTimeS", 0);
    else
            Char.SetExtData(player, "MazeTimeS", os.time());
    end
  end
end

function Module:onLoginEvent(player)
  local FTime = Char.GetExtData(player, "MazeTimeF") or 0;
  local STime = Char.GetExtData(player, "MazeTimeS") or 0;
  if FTime > 0 then
            Char.SetLoopEvent('./lua/Modules/mazeWorld.lua','InTheWorld_LoopEvent',player,60000);
  else
            local Target_FloorId = Char.GetData(player,CONST.CHAR_��ͼ);
            if Target_FloorId>=60002 and Target_FloorId<=60007 then
                Char.Warp(player,0,25003,14,27);
                NLG.SystemMessage(player,"[ϵ�y]�r�Ղ��ͻ�ԭ�����硣");
            end
  end
end

--- ж��ģ�鹳��
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
