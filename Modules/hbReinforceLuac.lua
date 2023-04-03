local hbReinforceLuac = ModuleBase:createModule('hbReinforceLuac')

--- ����ģ�鹳��
function hbReinforceLuac:onLoad()
  self:logInfo('load')
  self:regCallback('ScriptCallEvent', function(npcIndex, playerIndex, text, msg)
    self:logDebugF('npcIndex: %s, playerIndex: %s, text: %s, msg: %s', npcIndex, playerIndex, text, msg)

	player = playerIndex
	npc = npcIndex

	if text == 'һ��ǿ��' then
		for hbnum = 1,4 do 
			local targetcharIndex = Char.GetPartyMember(player,hbnum)
			if targetcharIndex >= 0 and Char.IsDummy(targetcharIndex) then
				local TL = Char.GetData(targetcharIndex, CONST.CHAR_����);  --���
				local GJ = Char.GetData(targetcharIndex, CONST.CHAR_����);  --����
				local FY = Char.GetData(targetcharIndex, CONST.CHAR_����);  --ǿ��
				local MJ = Char.GetData(targetcharIndex, CONST.CHAR_����);  --����
				local MF = Char.GetData(targetcharIndex, CONST.CHAR_����);  --ħ��
				--print(TL,GJ,FY,MJ,MF)
				local hb = {
					{900203,900204,900205},--�嵵��
					{900206,900207},--������
					{900209,900210,900211},--ǿ����
					{900212,900213,900214,900215},--�ٵ���
					{900216,900217,900218,900219} --ħ����
				}

				if TL>GJ and TL>=40 then
					if MJ<10 then
						Char.GiveItem(targetcharIndex, hb[1][1], 1);  --�u�����⡷��
					elseif MJ<30 then
						Char.GiveItem(targetcharIndex, hb[1][2], 1);  --�a�����⡷��
					else
						Char.GiveItem(targetcharIndex, hb[1][3], 1);  --�֡����⡷��
					end
				elseif GJ>MJ and GJ>=40 then
					if TL<20 then
						Char.GiveItem(targetcharIndex, hb[2][2], 1);  --����������
					else
						Char.GiveItem(targetcharIndex, hb[2][1], 1);  --ꖡ�������
					end
				elseif FY>TL and FY>=40 then
					if GJ<20 and MF>=20 then
						Char.GiveItem(targetcharIndex, hb[3][1], 1);  --����׃������
					elseif MF<20 and GJ>=20 then
						Char.GiveItem(targetcharIndex, hb[3][2], 1);  --ħ��׃������
					else
						Char.GiveItem(targetcharIndex, hb[3][3], 1);  --����׃������
					end
				elseif MJ>GJ and MJ>=40 then
					if GJ<10 then
						Char.GiveItem(targetcharIndex, hb[4][2], 1);  --�졶�ɔ_����
					elseif GJ<20 then
						Char.GiveItem(targetcharIndex, hb[4][3], 1);  --�����ɔ_����
					elseif GJ<30 then
						Char.GiveItem(targetcharIndex, hb[4][4], 1);  --���ɔ_����
					else
						Char.GiveItem(targetcharIndex, hb[4][1], 1);  --�B���ɔ_����
					end
				elseif MF>GJ and MF>=40 then
					Char.GiveItem(targetcharIndex, hb[5][math.random(1,4)], 1);  --�����g����
				else
					Char.GiveItem(targetcharIndex, 900208, 1);  --����������׃������
				end
			end
		end
		NLG.SystemMessage(player, 'ⷰ鏊���ɹ��@�Ä������ܿ���');
	end

    return -1;
  end)
end


--- ж��ģ�鹳��
function hbReinforceLuac:onUnload()
  self:logInfo('unload')
end

return hbReinforceLuac;
