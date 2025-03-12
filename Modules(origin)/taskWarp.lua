--ģ����
local Module = ModuleBase:createModule('taskWarp')

--local count_Max = 2;		--��������
--��������
local warp_map_name = {};
local warp_map_point = {};
local warp_map_lvlimit = {};
local warp_map_payfor = {};
local warp_map_relimit = {};
local warp_map_count_Max = {};
--ʣ���������
local warp_map_daily_user = {};
local warp_map_daily_user_count = {};
warp_map_daily_user_count[1] = {};	--����������
warp_map_daily_user_count[2] = {};	--����������
warp_map_daily_user_count[3] = {};	--����������
warp_map_daily_user_count[4] = {};	--����������
warp_map_daily_user_count[5] = {};	--����������
warp_map_daily_user_count[6] = {};	--����������
warp_map_daily_user_count[7] = {};	--����������
warp_map_daily_user_count[8] = {};	--����������
warp_map_daily_user_count[9] = {};	--����������

warp_map_name[1] = "ʮ���m����";
warp_map_point[1] = {7352,37,31};
warp_map_lvlimit[1] = 100;
warp_map_payfor[1] = 10000;
warp_map_relimit[1] =0;
warp_map_count_Max[1] = 1;

warp_map_name[2] = "�}�F�`�b";
warp_map_point[2] = {7353,92,76};
warp_map_lvlimit[2] = 120;
warp_map_payfor[2] = 20000;
warp_map_relimit[2] =0;
warp_map_count_Max[2] = 3;
--[[
warp_map_name[3] = "ħ���C��";
warp_map_point[3] = {1912,5,9};
warp_map_lvlimit[3] = 120;
warp_map_payfor[3] = 20000;
warp_map_relimit[3] =0;
warp_map_count_Max[3] = 3;

warp_map_name[4] = "�W�x����";
warp_map_point[4] = {1913,63,27};
warp_map_lvlimit[4] = 130;
warp_map_payfor[4] = 20000;
warp_map_relimit[4] =0;
warp_map_count_Max[4] = 3;

warp_map_name[5] = "���܅���";
warp_map_point[5] = {1950,60,67};
warp_map_lvlimit[5] = 140;
warp_map_payfor[5] = 20000;
warp_map_relimit[5] =0;
warp_map_count_Max[5] = 3;

warp_map_name[6] = "��ӡħŮ";
warp_map_point[6] = {1914,63,27};
warp_map_lvlimit[6] = 150;
warp_map_payfor[6] = 20000;
warp_map_relimit[6] =0;
warp_map_count_Max[6] = 1;

warp_map_name[7] = "δ�_��";
warp_map_point[7] = {25006,52,227};
warp_map_lvlimit[7] = 60;
warp_map_payfor[7] = 10000;
warp_map_relimit[7] =1;
warp_map_count_Max[7] = 5;

warp_map_name[8] = "δ�_��";
warp_map_point[8] = {7350,7,9};
warp_map_lvlimit[8] = 120;
warp_map_payfor[8] = 10000;
warp_map_relimit[8] =0;
warp_map_count_Max[8] = 5;

warp_map_name[9] = "δ�_��";
warp_map_point[9] = {32744,202,36};
warp_map_lvlimit[9] = 101;
warp_map_payfor[9] = 10000;
warp_map_relimit[9] =0;
warp_map_count_Max[9] = 2;
]]
------------------------------------------------------------------------------------------------------------------------
--���ܺ���
function Time_Check(_obj)	--�ж��Ƿ�һ��ʱ���ѹ�
	if (os.date("%d",_obj) ~= os.date("%d",os.time())) then 
		return true;
	end
	return false;
end

function Time_Out(player)	--ÿ��24��Ϊ�ж���ʱ
	local _obj = warp_map_daily_user[Playerkey(player)];
	--����״ε�¼
	if (_obj == nil) then 
		warp_map_daily_user[Playerkey(player)] = os.time();
		return true;
	else
		return Time_Check(_obj);
	end
end

function Playerkey(player)
	if (player ~= nil) then
		local fanhui1 = Char.GetData(player,CONST.CHAR_����);
		local fanhui2 = Char.GetData(player,CONST.CHAR_CDK);
		if (fanhui1 == nil or fanhui2 == nil) then
			if(fanhui2 == nil) then
				fanhui2 = "bus"
			end
		end
		return fanhui1..fanhui2;
	else
		return 1;
	end
end

function mykgold(player,gold)
	local tjb = Char.GetData(player,CONST.����_���);
	tjb = tjb - gold; 
	if (tjb >= 0) then
		Char.SetData(player,CONST.����_���,tjb);
		NLG.UpChar(player);
		NLG.SystemMessage(player,"������"..gold.." Għ�š�");
		return true;
	end
	return false;
end

------------------------------------------------------------------------------------------------------------------------
--����ģ��
function Module:onLoad()
	self:logInfo('load')
	local warpNPC = self:NPC_createNormal('ÿ������',99086,{x=228, y=83, mapType=0, map=1000, direction=6})
	Char.SetData(warpNPC,CONST.����_ENEMY_PetFlg+2,0)--�ɴ�͸��
	self:NPC_regWindowTalkedEvent(warpNPC,Func.bind(self.click,self))
	self:NPC_regTalkedEvent(warpNPC,Func.bind(self.facetonpc,self))
end

local function calcWarp()--���㷭ҳ
	local page = math.modf(#warp_map_name/8) + 1
	local remainder = math.fmod(#warp_map_name,8)
	return page,remainder
end

function Module:click(npc,player,_seqno,_select,_data)--�����е������
	local column = tonumber(_data)
	local page = tonumber(_seqno)
	local warpPage = page;
	if (page==1000) then	--�ص����˵�
		self:facetonpc(npc, player);
		return;
	end

	local winMsg = "1|\\n�������߼���������ϵ�y ...�Y���xȡ��...��\\n";
	local winButton = CONST.BUTTON_�ر�;
	local totalPage, remainder = calcWarp()
	--��ҳ16 ��ҳ32 ȡ��2
	if _select > 0 then
		--��ҳ��ť
		if _select == 32 then
			warpPage = warpPage + 1
			if (warpPage == totalPage) or (warpPage == (totalPage - 1) and remainder == 0) then
				winButton = 18	--��ȡ��
			else
				winButton = 50	--����ȡ��
			end
		elseif _select == 16 then
			warpPage = warpPage - 1
			if warpPage == 1 then
				winButton = 34	--��ȡ��
			else
				winButton = 50	--����ȡ��
			end
		elseif _select == 2 then
			warpPage = 1
			return
		end
		--������������
		if (Time_Out(player)) then
			warp_map_daily_user[Playerkey(player)] = os.time();
			for i=1,#warp_map_daily_user_count do			--ÿ�ո����������
				warp_map_daily_user_count[i][Playerkey(player)] = nil;
			end
		end
		--��ҳ����
		local count = 8 * (warpPage - 1)
		if warpPage == totalPage then
			for i = 1 + count, remainder + count do
				local tcount = warp_map_daily_user_count[i][Playerkey(player)];
				if (tcount == nil) then
					tcount = warp_map_count_Max[i];
				else
					tcount = warp_map_count_Max[i] - tcount;
				end
				--�����ʽ
				local name_len = #warp_map_name[i];
				if (name_len < 12) then
					name_spacelen = 12 - name_len;
					name_spaceMsg = "";
					for k = 1, math.modf(name_spacelen) do
						name_spaceMsg = name_spaceMsg .." ";
					end
				else
					name_spaceMsg = " ";
				end
				winMsg = winMsg .. ""..warp_map_name[i].. name_spaceMsg .. "�ȼ�:"..warp_map_lvlimit[i].." �D��:"..warp_map_relimit[i].."��<"..warp_map_payfor[i].."Ԫ.ʣ"..tcount.."��>\\n"
			end
		else
			for i = 1 + count, 8 + count do
				local tcount = warp_map_daily_user_count[i][Playerkey(player)];
				if (tcount == nil) then
					tcount = warp_map_count_Max[i];
				else
					tcount = warp_map_count_Max[i] - tcount;
				end

				--�����ʽ
				local name_len = #warp_map_name[i];
				if (name_len < 12) then
					name_spacelen = 12 - name_len;
					name_spaceMsg = "";
					for k = 1, math.modf(name_spacelen) do
						name_spaceMsg = name_spaceMsg .." ";
					end
				else
					name_spaceMsg = " ";
				end
				winMsg = winMsg .. ""..warp_map_name[i].. name_spaceMsg .. "�ȼ�:"..warp_map_lvlimit[i].." �D��:"..warp_map_relimit[i].."��<"..warp_map_payfor[i].."Ԫ.ʣ"..tcount.."��>\\n"
			end
		end
		NLG.ShowWindowTalked(player,npc,CONST.����_ѡ���, winButton, warpPage, winMsg);
	else
		if (_seqno >= 1 and select == CONST.��ť_�ر�) then
			return;
		elseif (_seqno >= 1 and column >= 1) then
			--local selectitem = tonumber(_data);
			local count = 8 * (warpPage - 1) + column;

			local getlvlit = warp_map_lvlimit[count];
			if (getlvlit > Char.GetData(player,CONST.CHAR_�ȼ�)) then	--�ȼ��ж�
				NLG.SystemMessage(player, "���ĵȼ�����"..getlvlit.."���ف�ɣ�");
				return;
			end
			if (Char.PartyNum(player)>1) then			--����ж�
				NLG.SystemMessage(player, "[ϵ�y]�����Ҫ�����M�Ђ��ͣ���");
				return;
			end
			local relvlit = warp_map_relimit[count];
			if (relvlit > Char.GetData(player,CONST.����_��ɫ)) then	--ת���ж�
				NLG.SystemMessage(player, "�����D���Δ�����"..relvlit.."���D�����ف�ɣ�");
				return;
			end

			local getcountless = warp_map_daily_user_count[count][Playerkey(player)];
			if (getcountless ==nil) then
				getcountless = 0;
				warp_map_daily_user_count[count][Playerkey(player)] = 0;
			end
			if (getcountless >= warp_map_count_Max[count]) then
				local msg = "\\n\\n\\n@c���ĴΔ��ѽ������ˡ�"
				NLG.ShowWindowTalked(player,npc,CONST.����_��Ϣ��,CONST.��ť_�ر�, 1000, msg);
				return;
			end

			if (mykgold(player, warp_map_payfor[count])) then
				warp_map_daily_user_count[count][Playerkey(player)] = getcountless + 1;
				Char.DischargeParty(player);
				Char.Warp(player,0, warp_map_point[count][1], warp_map_point[count][2], warp_map_point[count][3]);
			else
				NLG.SystemMessage(player, "\\n\\n\\n����ħ�Ų���");
				return;
			end
		end
	end
end

function Module:facetonpc(npc,player)
	if NLG.CanTalk(npc,player) == true then
		if (Time_Out(player)) then
			warp_map_daily_user[Playerkey(player)] = os.time();
			for i=1,#warp_map_daily_user_count do			--ÿ�ո����������
				warp_map_daily_user_count[i][Playerkey(player)] = nil;
			end
		end

		local winButton = CONST.BUTTON_�ر�;
		local winMsg = "1|\\n�������߼���������ϵ�y ...�Y���xȡ��...��\\n";
		for i=1, 2 do

			local tcount = warp_map_daily_user_count[i][Playerkey(player)];
			if (tcount == nil) then
				tcount = warp_map_count_Max[i];
			else
				tcount = warp_map_count_Max[i] - tcount;
			end

			--�����ʽ
			local name_len = #warp_map_name[i];
			if (name_len < 12) then
				name_spacelen = 12 - name_len;
				name_spaceMsg = "";
				for k = 1, math.modf(name_spacelen) do
					name_spaceMsg = name_spaceMsg .." ";
				end
			else
				name_spaceMsg = " ";
			end
			winMsg = winMsg .. ""..warp_map_name[i].. name_spaceMsg .. "�ȼ�:"..warp_map_lvlimit[i].." �D��:"..warp_map_relimit[i].."��<"..warp_map_payfor[i].."Ԫ.ʣ"..tcount.."��>\\n";
			if (i>=8) then
				winButton = CONST.BUTTON_��ȡ��;
			end
		end
		NLG.ShowWindowTalked(player,npc,CONST.����_ѡ���, winButton, 1, winMsg);
	end
	return
end

--ж��ģ��
function Module:onUnload()
	self:logInfo('unload')
end
return Module
