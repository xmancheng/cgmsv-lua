---ģ����
local Luac = ModuleBase:createModule('luac')
local allyb = 0

local wanjia = {}--��ұ�
for bbb = 0,100 do
	wanjia[bbb] = {}
	wanjia[bbb][0] = 0--aiͳ��
	for ccc = 1,5 do
		wanjia[bbb][ccc] = -1
	end
end

function Luac:yboffline(player)--�����������Լ��ٻ���ai
	for xxqk = 1,#wanjia[player] do
		if wanjia[player][xxqk] > 0 then
			Char.DelDummy(wanjia[player][xxqk])
		end
	end
	wanjia[player][0] = 0
end

--- ����ģ�鹳��
function Luac:onLoad()

  self:logInfo('load')
  --local fnpc = self:NPC_createNormal('�������', 101003, { x = 38, y = 33, mapType = 0, map = 777, direction = 6 });
  self:regCallback('ScriptCallEvent', function(npcIndex, playerIndex, text, msg)
    self:logDebugF('npcIndex: %s, playerIndex: %s, text: %s, msg: %s', npcIndex, playerIndex, text, msg)
    self:regCallback("LogoutEvent", Func.bind(self.yboffline, self))
    
	player = playerIndex
	npc = npcIndex

	id = Char.GetData(player,%����_CDK%)
	name = Char.GetData(player,%����_����%)
	lv = Char.GetData(player, %����_�ȼ�%)
	Target_MapId = Char.GetData(player,CONST.CHAR_MAP)--��ͼ����
	Target_FloorId = Char.GetData(player,CONST.CHAR_��ͼ)--��ͼ���
	Target_X = Char.GetData(player,CONST.CHAR_X)--��ͼx
	Target_Y = Char.GetData(player,CONST.CHAR_Y)--��ͼy

	if text == 'һ���ٻ�' then
		if wanjia[player][0] > 3 then
			NLG.SystemMessage(player, '���Ѿ��ٻ���4λС����ˣ��������ٻ��ˡ�' )
		elseif allyb > 100 then
			NLG.SystemMessage(player, '��ǰ��·�˿ڱ������޷����Ӷ���ˡ�' )
		else
		for csdd = 1,5 do
			if Char.PartyNum(wanjia[player][csdd]) == -1 then
				Battle.ExitBattle(wanjia[player][csdd]);
				Char.Warp(wanjia[player][csdd], Target_MapId, Target_FloorId, Target_X, Target_Y);
				Char.JoinParty(wanjia[player][csdd],player);
			end
		end
		for num = 1,5 do
			local petIndex1 = Char.GetPet(player,num-1)
			if Char.GetData(petIndex1, 73) ~= CONST.PET_STATE_ս�� then
				if wanjia[player][num] <= 0 and petIndex1 >= 0 then
					local charIndex1 = Char.CreateDummy()--����aiӶ��
					wanjia[player][0] = wanjia[player][0] + 1--ͳ��aiӶ������
					allyb = charIndex1
					print("��ţ�"..charIndex1.."")
					wanjia[player][num] = charIndex1

					Char.SetData(charIndex1, CONST.CHAR_X, Char.GetData(player, CONST.CHAR_X));
					Char.SetData(charIndex1, CONST.CHAR_Y, Char.GetData(player, CONST.CHAR_Y));
					Char.SetData(charIndex1, CONST.CHAR_��ͼ, Char.GetData(player, CONST.CHAR_��ͼ));
					Char.SetData(charIndex1, CONST.CHAR_����, 'С���');
					Char.SetData(charIndex1, CONST.CHAR_��ͼ����, Char.GetData(player,CONST.CHAR_��ͼ����));
					Char.SetData(charIndex1, CONST.CHAR_����, Char.GetData(petIndex1,CONST.CHAR_����));
					Char.SetData(charIndex1, CONST.CHAR_ԭ��, Char.GetData(petIndex1,CONST.CHAR_ԭ��));
					Char.SetData(charIndex1, CONST.CHAR_ԭʼͼ��, Char.GetData(petIndex1,CONST.CHAR_ԭʼͼ��));
					print('charIndex1', charIndex1)
					--print(player)
					Char.SetData(charIndex1, CONST.CHAR_����, Char.GetData(petIndex1,CONST.CHAR_����));
					Char.SetData(charIndex1, CONST.CHAR_����, Char.GetData(petIndex1,CONST.CHAR_����));
					Char.SetData(charIndex1, CONST.CHAR_ǿ��, Char.GetData(petIndex1,CONST.CHAR_ǿ��));
					Char.SetData(charIndex1, CONST.CHAR_�ٶ�, Char.GetData(petIndex1,CONST.CHAR_�ٶ�));
					Char.SetData(charIndex1, CONST.CHAR_ħ��, Char.GetData(petIndex1,CONST.CHAR_ħ��));
					Char.SetData(charIndex1, CONST.CHAR_�ȼ�, Char.GetData(petIndex1,CONST.CHAR_�ȼ�));
					Char.SetData(charIndex1, CONST.CHAR_����, Char.GetData(petIndex1,CONST.CHAR_����));
					NLG.UpChar(charIndex1);
					Char.GiveItem(charIndex1, 9201, 1);
					Char.MoveItem(charIndex1, 8, CONST.EQUIP_ˮ��, -1)
					Char.GiveItem(charIndex1, 18196, 1);--ʵ��ҩ
					Char.GiveItem(charIndex1, 18315, 19);--���
					Char.SetData(charIndex1, CONST.CHAR_Ѫ, Char.GetData(petIndex1,CONST.CHAR_���Ѫ));
					Char.SetData(charIndex1, CONST.CHAR_ħ, Char.GetData(petIndex1,CONST.CHAR_���ħ));
					Char.SetData(charIndex1, CONST.CHAR_ְҵ, 1);      --����
					Char.SetData(charIndex1, CONST.CHAR_ְ��ID, 0);  --����
					Char.SetData(charIndex1, CONST.CHAR_ְ��, 3);

					Char.JoinParty(charIndex1, player);
				else
					--NLG.SystemMessage(player, '���ﲻ���ڡ�' )
				end
			else
				--NLG.SystemMessage(player, 'ս��״̬�����޷��ٻ���' )
			end
		end
		end
	end
	if text == 'һ�����' then
		for xxqk = 1,#wanjia[player] do
			if wanjia[player][xxqk] > 0 then
				Char.DelDummy(wanjia[player][xxqk])
				wanjia[player][xxqk] = -1
			end
		end
		wanjia[player][0] = 0
	end
	
--[[
	local result = table.pack(string.match(text, 'getpetskill:(%d),(%d)'))
    if result and result[1] ~= nil and result[2] ~= nil then
      local petIndex = Char.GetPet(playerIndex, tonumber(result[1]))
      if petIndex >= 0 then
        return Pet.GetSkill(petIndex, tonumber(result[2]))
      end
    end
    result = table.pack(string.match(text, 'addpetskill:(%d),(%d)'))
    if result and result[1] ~= nil and result[2] ~= nil then
      local petIndex = Char.GetPet(playerIndex, tonumber(result[1]))
      if petIndex >= 0 then
        return Pet.AddSkill(petIndex, tonumber(result[2]))
      end
    end
]]	
    return -1;
  end)


--[[  self:NPC_regTalkedEvent(fnpc, function(npc,player)--��ʾwindow
	
	function showwindow(npc,player)
	window = "1"
	.."2"
	NLG.ShowWindowTalked(player,npc,CONST.����_ѡ���,CONST.BUTTON_�ر�,1,window);
	end
	showwindow(fnpc,player)
	return
  end)]]
end

--- ж��ģ�鹳��
function Luac:onUnload()
  self:logInfo('unload')
end

return Luac;
