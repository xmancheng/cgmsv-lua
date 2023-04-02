local hbparameter = ModuleBase:createModule('hbparameter')

--- ����ģ�鹳��
function hbparameter:onLoad()
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
				local hb = {
					{900203,900203,900205},--�嵵��
					{900206,900207},--������
					{900208,900209,900210},--ǿ����
					{900212,900213,900214,900215},--�ٵ���
					{900216,900217,900218,900219} --ħ����
				}
				local ItemIndex = Char.GetItemIndex(targetcharIndex, 12)
				if ItemIndex < 0 then
					if TL>GJ then
						Char.GiveItem(targetcharIndex, hb[1][1], 1);  --�����⡷��
					elseif GJ>MF then
						Char.GiveItem(targetcharIndex, hb[2][1], 1);  --��������
					elseif FY>TL then
						Char.GiveItem(targetcharIndex, hb[3][1], 1);  --��׃������
					elseif MJ>GJ then
						Char.GiveItem(targetcharIndex, hb[4][1], 1);  --���ɔ_����
					elseif MF>GJ then
						Char.GiveItem(targetcharIndex, hb[5][1], 1);  --�����g����
					end
				end
			end
		end
		NLG.SystemMessage(player, 'ⷰ鏊���ɹ��@�Ä������ܿ���');
	end

    return -1;
  end)
end


--- ж��ģ�鹳��
function hbparameter:onUnload()
  self:logInfo('unload')
end

return hbparameter;
