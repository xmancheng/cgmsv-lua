--ģ����
local Module = ModuleBase:createModule('hunterTask')

local hunter_list = {};

--��ɱ����
hunter_list[1] = {};
hunter_list[1].target = {}
hunter_list[1].reward = {};
hunter_list[1].reward.item = {};
hunter_list[1].name = "���_�y�I�ص�Ƥ��";
hunter_list[1].level_min = 1;
hunter_list[1].level_max = 30;
hunter_list[1].limit = 5;
hunter_list[1].target[1] = {};
hunter_list[1].target[1].name = "Ƥ��";
hunter_list[1].target[1].amount = 10;
hunter_list[1].reward.gold = 2000;
hunter_list[1].reward.lp = 1500;
hunter_list[1].reward.fp = 1500;
hunter_list[1].reward.item[1] = {id=74098, name="�C����", amount=5,};

hunter_list[2] = {};
hunter_list[2].target = {}
hunter_list[2].reward = {};
hunter_list[2].reward.item = {};
hunter_list[2].name = "���I�ص�С��������";
hunter_list[2].level_min = 1;
hunter_list[2].level_max = 145;
hunter_list[2].limit = 1;
hunter_list[2].target[1] = {};
hunter_list[2].target[1].name = "������";
hunter_list[2].target[1].amount = 100;
hunter_list[2].target[2] = {};
hunter_list[2].target[2].name = "Ƥ����";
hunter_list[2].target[2].amount = 100;
hunter_list[2].reward.gold = 1200;
hunter_list[2].reward.lp = 2500;
hunter_list[2].reward.fp = 2500;
hunter_list[2].reward.item[1] = {id=74095, name="1�A�M��ʯ", amount=1,};

hunter_list[3] = {};
hunter_list[3].target = {}
hunter_list[3].reward = {};
hunter_list[3].reward.item = {};
hunter_list[3].name = "������·�ϵ����x��";
hunter_list[3].level_min = 10;
hunter_list[3].level_max = 40;
hunter_list[3].limit = 3;
hunter_list[3].target[1] = {};
hunter_list[3].target[1].name = "�ʹ��";
hunter_list[3].target[1].amount = 15;
hunter_list[3].target[2] = {};
hunter_list[3].target[2].name = "����h";
hunter_list[3].target[2].amount = 15;
hunter_list[3].reward.gold = 900;
hunter_list[3].reward.lp = 1700;
hunter_list[3].reward.fp = 1700;
hunter_list[3].reward.item[1] = {id=74098, name="�C����", amount=5,};

hunter_list[4] = {};
hunter_list[4].target = {}
hunter_list[4].reward = {};
hunter_list[4].reward.item = {};
hunter_list[4].name = "��ɳĮ�h���y���ߡ�";
hunter_list[4].level_min = 55;
hunter_list[4].level_max = 145;
hunter_list[4].limit = 3;
hunter_list[4].target[1] = {};
hunter_list[4].target[1].name = "�������";
hunter_list[4].target[1].amount = 10;
hunter_list[4].target[2] = {};
hunter_list[4].target[2].name = "�����˹";
hunter_list[4].target[2].amount = 10;
hunter_list[4].reward.gold = 2000;
hunter_list[4].reward.lp = 4000;
hunter_list[4].reward.fp = 4000;
hunter_list[4].reward.item[1] = {id=74098, name="�C����", amount=15,};

hunter_list[5] = {};
hunter_list[5].target = {}
hunter_list[5].reward = {};
hunter_list[5].reward.item = {};
hunter_list[5].name = "���o�˰l늏S�}�ӡ�";
hunter_list[5].level_min = 65;
hunter_list[5].level_max = 145;
hunter_list[5].limit = 3;
hunter_list[5].target[1] = {};
hunter_list[5].target[1].name = "������";
hunter_list[5].target[1].amount = 20;
hunter_list[5].target[2] = {};
hunter_list[5].target[2].name = "Ƥ����";
hunter_list[5].target[2].amount = 50;
hunter_list[5].reward.gold = 2000;
hunter_list[5].reward.lp = 4000;
hunter_list[5].reward.fp = 4000;
hunter_list[5].reward.item[1] = {id=74098, name="�C����", amount=15,};

hunter_list[6] = {};
hunter_list[6].target = {}
hunter_list[6].reward = {};
hunter_list[6].reward.item = {};
hunter_list[6].name = "���z�E�е����l�ߡ�";
hunter_list[6].level_min = 80;
hunter_list[6].level_max = 145;
hunter_list[6].limit = 2;
hunter_list[6].target[1] = {};
hunter_list[6].target[1].name = "����";
hunter_list[6].target[1].amount = 50;
hunter_list[6].target[2] = {};
hunter_list[6].target[2].name = "���W·";
hunter_list[6].target[2].amount = 50;
hunter_list[6].reward.gold = 4000;
hunter_list[6].reward.lp = 6500;
hunter_list[6].reward.fp = 6500;
hunter_list[6].reward.item[1] = {id=74096, name="2�A�M��ʯ", amount=2,};

hunter_list[7] = {};
hunter_list[7].target = {}
hunter_list[7].reward = {};
hunter_list[7].reward.item = {};
hunter_list[7].name = "������ѩɽ���L�ߡ�";
hunter_list[7].level_min = 90;
hunter_list[7].level_max = 145;
hunter_list[7].limit = 1;
hunter_list[7].target[1] = {};
hunter_list[7].target[1].name = "�׼���˹";
hunter_list[7].target[1].amount = 1;
hunter_list[7].reward.gold = 5000;
hunter_list[7].reward.lp = 10000;
hunter_list[7].reward.fp = 10000;
hunter_list[7].reward.item[1] = {id=74098, name="�C����", amount=20,};

hunter_list[8] = {};
hunter_list[8].target = {}
hunter_list[8].reward = {};
hunter_list[8].reward.item = {};
hunter_list[8].name = "����ػ����������";
hunter_list[8].level_min = 90;
hunter_list[8].level_max = 145;
hunter_list[8].limit = 1;
hunter_list[8].target[1] = {};
hunter_list[8].target[1].name = "������";
hunter_list[8].target[1].amount = 1;
hunter_list[8].reward.gold = 5000;
hunter_list[8].reward.lp = 10000;
hunter_list[8].reward.fp = 10000;
hunter_list[8].reward.item[1] = {id=74098, name="�C����", amount=20,};

hunter_list[9] = {};
hunter_list[9].target = {}
hunter_list[9].reward = {};
hunter_list[9].reward.item = {};
hunter_list[9].name = "���������������";
hunter_list[9].level_min = 90;
hunter_list[9].level_max = 145;
hunter_list[9].limit = 1;
hunter_list[9].target[1] = {};
hunter_list[9].target[1].name = "�w�W��";
hunter_list[9].target[1].amount = 1;
hunter_list[9].reward.gold = 5000;
hunter_list[9].reward.lp = 10000;
hunter_list[9].reward.fp = 10000;
hunter_list[9].reward.item[1] = {id=74098, name="�C����", amount=20,};

hunter_list[10] = {};
hunter_list[10].target = {}
hunter_list[10].reward = {};
hunter_list[10].reward.item = {};
hunter_list[10].name = "����ջ����������";
hunter_list[10].level_min = 90;
hunter_list[10].level_max = 145;
hunter_list[10].limit = 1;
hunter_list[10].target[1] = {};
hunter_list[10].target[1].name = "�ҿ���";
hunter_list[10].target[1].amount = 1;
hunter_list[10].reward.gold = 5000;
hunter_list[10].reward.lp = 10000;
hunter_list[10].reward.fp = 10000;
hunter_list[10].reward.item[1] = {id=74098, name="�C����", amount=20,};

hunter_list[11] = {};
hunter_list[11].target = {}
hunter_list[11].reward = {};
hunter_list[11].reward.item = {};
hunter_list[11].name = "���P��ֱ���H�lꠡ�";
hunter_list[11].level_min = 90;
hunter_list[11].level_max = 145;
hunter_list[11].limit = 1;
hunter_list[11].target[1] = {};
hunter_list[11].target[1].name = "�׹�";
hunter_list[11].target[1].amount = 1;
hunter_list[11].target[2] = {};
hunter_list[11].target[2].name = "�׵�";
hunter_list[11].target[2].amount = 1;
hunter_list[11].target[3] = {};
hunter_list[11].target[3].name = "ˮ��";
hunter_list[11].target[3].amount = 1;
hunter_list[11].reward.gold = 15000;
hunter_list[11].reward.lp = 30000;
hunter_list[11].reward.fp = 30000;
hunter_list[11].reward.item[1] = {id=74097, name="�����M��ʯ", amount=1,};

local hunter_list_count = #hunter_list
for i = 1, hunter_list_count do
	hunter_list[i].target.count = #hunter_list[i].target;
end
------------------------------------------------------------------------------------------------------------------------
--����ģ��
function Module:onLoad()
	self:logInfo('load')
    self:regCallback('TalkEvent', Func.bind(self.handleTalkEvent, self))
    self:regCallback('BattleStartEvent', Func.bind(self.OnbattleStartEventCallback, self))
    self:regCallback('BattleOverEvent', Func.bind(self.onBattleOver, self));
	self.hunterNPC = self:NPC_createNormal('��������',14630,{x=106, y=110, mapType=0, map=80010, direction=6})
	Char.SetData(self.hunterNPC,CONST.����_ENEMY_PetFlg+2,0)--�ɴ�͸��
	self:NPC_regWindowTalkedEvent(self.hunterNPC,Func.bind(self.click,self))
	self:NPC_regTalkedEvent(self.hunterNPC,Func.bind(self.facetonpc,self))
end

--��ѯָ��
function Module:handleTalkEvent(charIndex,msg,color,range,size)
	if(msg=="mission")then
		hunter_talk_check(charIndex,msg,color,range,size);
		return 0;
	elseif(msg=="/hunter")then
		hunter_callback_fartalk(charIndex, self.hunterNPC);
		return 0;
	end
	return 1;
end
--��ɱ�����ѯ
function hunter_talk_check(player,msg,color,range,size)
	if( tonumber( Field.Get(player,"hunter_flag")) == 0 or tonumber( Field.Get( player, "hunter_flag")) == nil)then
		NLG.SystemMessage(player, "[���p�΄�]�]�н��΄ա�");
	end
	if( tonumber( Field.Get(player, "hunter_flag")) == 1)then
		local i = tonumber( Field.Get(player, "hunter_ongoing_quest"));
		for j = 1, hunter_list[i].target.count do
			local message = "[���p�΄�]";
			message = message..
				"��"..hunter_list[i].name.."���C��"..
				hunter_list[i].target[j].name..
				"("..
				Field.Get( player, "hunter_target_"..j)..
				"/"..
				hunter_list[i].target[j].amount..
				")" ;
			NLG.SystemMessage( player, message);
		end
	end
	if( tonumber( Field.Get(player, "hunter_flag")) == 2)then
		NLG.SystemMessage(player, "[���p�΄�]�΄��ѽ���ɣ������ύ��");
	end
	return false;
end

local function calcWarp()--���㷭ҳ
	local page = math.modf(#hunter_list/5) + 1
	local remainder = math.fmod(#hunter_list,5)
	return page,remainder
end

function Module:click(npc,player,_seqno,_select,_data)--�����е������
	local column = tonumber(_data)
	local page = tonumber(_seqno)
	local warpPage = page;
	local totalPage, remainder = calcWarp()
	--��ҳ16 ��ҳ32 ȡ��2
	if _select > 0 then
		if (_seqno>=1000 and _seqno<1100 and (_select==CONST.��ť_�ر� or _select==CONST.��ť_��һҳ or _select==CONST.��ť_��һҳ)) then
			--��ҳ��ť
			--print(warpPage)
			local warpPage = warpPage - 1000;
			local winButton = CONST.BUTTON_�ر�;
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

			--��ҳ����
			local count = 5 * (warpPage - 1)
			if warpPage == totalPage then
				winMsg = "4|\\n������ÿ�իC������ϵ�y ...�Y���xȡ��...��\\n"
							.." �x����Ҫ�C���đ��pĿ��\\n"
							.." ָ��mission�ɲ�ԃ�΄ծ�ǰ�M��:\\n";
				for i = 1 + count, remainder + count do
					winMsg = winMsg .. "\\n"..hunter_list[i].name.."...�ȼ���"..hunter_list[i].level_min.."��"..hunter_list[i].level_max;
				end
				NLG.ShowWindowTalked(player,npc,CONST.����_ѡ���, winButton, 1000+warpPage, winMsg);
			else
				winMsg = "4|\\n������ÿ�իC������ϵ�y ...�Y���xȡ��...��\\n"
							.." �x����Ҫ�C���đ��pĿ��\\n"
							.." ָ��mission�ɲ�ԃ�΄ծ�ǰ�M��:\\n";
				for i = 1 + count, 5 + count do
					winMsg = winMsg .. "\\n"..hunter_list[i].name.."...�ȼ���"..hunter_list[i].level_min.."��"..hunter_list[i].level_max;
				end
				NLG.ShowWindowTalked(player,npc,CONST.����_ѡ���, winButton, 1000+warpPage, winMsg);
			end
		elseif (_seqno>1100 and _seqno<2000 and _select == CONST.��ť_��) then
			local nowevent = _seqno-1100;
			local level = Char.GetData(player,CONST.����_�ȼ�);
			local i = nowevent;
			local flag = tonumber( Field.Get(player, "hunter_flag"));
			local lasttime = tonumber( Field.Get(player, "hunter_lasttime_"..i));
			local nowtime = tonumber(os.date( "%d",os.time()));
			local times = tonumber( Field.Get(player, "hunter_limit_"..i));
			if( times == nil)then
				times = 0;
			end
			if( lasttime == nowtime)then
				if( times >= hunter_list[i].limit)then
					NLG.SystemMessage(player, "[ϵ�y]���^һ��ȿ���ɵĴΔ���Ո�����ف�����x�������΄ա�");
					return;
				end
			else
				Field.Set(player, "hunter_limit_"..i, 0);
				times = 0;
			end

			if( flag == 1 or flag == 2)then
				NLG.SystemMessage(player, "[ϵ�y]�ѽ��������M�е��΄գ����΄������δ�ύ��");
				return;
			end
			if( level < hunter_list[i].level_min or level > hunter_list[i].level_max)then
				NLG.SystemMessage(player, "[ϵ�y]�ȼ��l��������Ո�x�񌦑��ȼ��΄ա�");
				return;
			end
			Field.Set(player, "hunter_flag", tostring(1));
			Field.Set(player, "hunter_ongoing_quest", tostring(i));
			Field.Set(player, "hunter_lasttime_"..i, nowtime);
			Field.Set(player, "hunter_limit_"..i, times+1);
			for j = 1, hunter_list[i].target.count do
				Field.Set(player, "hunter_target_temporary_"..j, 0);
				Field.Set(player, "hunter_target_"..j, 0);
			end
			NLG.SystemMessage(player, "[ϵ�y]�΄��ѽ�ȡ�ɹ���");
		elseif (_seqno==3000 and _select == CONST.��ť_��) then
			local quest = tonumber( Field.Get(player, "hunter_ongoing_quest"));
			for i = 1, #hunter_list[quest].reward.item do
				Char.GiveItem(player, hunter_list[quest].reward.item[i].id, hunter_list[quest].reward.item[i].amount);
			end

			Char.AddGold(player, hunter_list[quest].reward.gold);
			local lpPool = tonumber(Field.Get(player, 'LpPool')) or 0;
			local fpPool = tonumber(Field.Get(player, 'FpPool')) or 0;
			Field.Set(player, 'LpPool', tostring(lpPool + hunter_list[quest].reward.lp));
			Field.Set(player, 'FpPool', tostring(fpPool + hunter_list[quest].reward.fp));
			NLG.UpChar(player);

			Field.Set(player, "hunter_flag", 0);
			for i = 1, hunter_list[quest].target.count do
				Field.Set(player, "hunter_target_temporary_"..i, 0);
				Field.Set(player, "hunter_target_"..i, 0);
			end
			Field.Set(player, "hunter_ongoing_quest", 0);
			NLG.SystemMessage(player, "[ϵ�y]�@�����ª��"..hunter_action_reward_generate(quest));
		elseif (_seqno==4000 and _select == CONST.��ť_��) then
			local quest = tonumber( Field.Get(player, "hunter_ongoing_quest"));
			Field.Set(player, "hunter_flag", 0);
			for i = 1, hunter_list[quest].target.count do
				Field.Set(player, "hunter_target_temporary_"..i, 0);
				Field.Set(player, "hunter_target_"..i, 0);
			end
			Field.Set(player, "hunter_ongoing_quest", 0);
			Char.AddGold(player, -1000);
			NLG.SystemMessage(player, "�΄��ѷŗ����۳�ħ��1000��");
		end
	else
		if (_seqno >= 1 and select == CONST.��ť_�ر�) then
			return;
		elseif (_seqno >= 1000 and column >= 1) then
			--print(column)
			local warpPage = _seqno - 1000;
			local nowevent = 5 * (warpPage - 1) + column;
			local lasttime = tonumber( Field.Get(player, "hunter_lasttime_"..nowevent));
			local nowtime = tonumber(os.date( "%d",os.time()));
			local times = tonumber( Field.Get(player, "hunter_limit_"..nowevent));
			if( times == nil or lasttime == nil or lasttime ~= nowtime)then
				times = 0;
			end

			local msg = "\\n�΄����Q��"..hunter_list[nowevent].name..
					"\\n�ȼ����ƣ�"..hunter_list[nowevent].level_min.."��"..(hunter_list[nowevent].level_max) ..
					"\\n�΄�Ҫ��";
			for i = 1, hunter_list[nowevent].target.count do
				msg = msg .. hunter_list[nowevent].target[i].name.."��"..hunter_list[nowevent].target[i].amount.." ";
			end

 			msg = msg .. "\\n�΄ժ��"..hunter_action_reward_generate( nowevent);
			msg = msg .. "\\nÿ���΄����ƣ�"..times.."/"..hunter_list[nowevent].limit ..
				"\\n\\n��ע�⣺�΄�һ�����ܣ������֮ǰ׃���ŗ���̎���M������ŗ��΄�Ո�鿴�ѽ��΄��б�";
			NLG.ShowWindowTalked(player,npc,CONST.����_��Ϣ��,CONST.��ť_�Ƿ�, 1100+nowevent, msg);
		elseif (_seqno == 1 and column >= 1) then
			--local selectitem = tonumber(_data);
			if (column==1) then	--�鿴�����б�
				if warpPage == totalPage then
					button = CONST.��ť_�ر�;
				else
					button = CONST.��ť_��ȡ��;
				end
				local msg = "4|\\n������ÿ�իC������ϵ�y ...�Y���xȡ��...��\\n"
							.." �x����Ҫ�C���đ��pĿ��\\n"
							.." ָ��mission�ɲ�ԃ�΄ծ�ǰ�M��:\\n";
				for i = 1,5 do
					msg = msg .. "\\n"..hunter_list[i].name.."...�ȼ���"..hunter_list[i].level_min.."��"..hunter_list[i].level_max;
				end
				NLG.ShowWindowTalked(player,npc,CONST.����_ѡ���, button, 1001, msg);
			elseif (column==2) then	--�鿴�ѽ�����
				local flag = tonumber( Field.Get(player, "hunter_flag"));
				local msg = nil;
				if( flag == nil or flag == 0)then
					msg = "������ÿ�իC������ϵ�y ...�Y���xȡ��...��\\n"
						.. "\\n�������������]�������M�е��΄ա�";
				else
					local ongoing = tonumber( Field.Get(player, "hunter_ongoing_quest"));
					local lasttime = tonumber( Field.Get(player, "hunter_lasttime_"..ongoing));
					local nowtime = tonumber(os.date( "%d",os.time()));
					local times = tonumber( Field.Get(player, "hunter_limit_"..ongoing));
					if( times == nil or lasttime == nil or lasttime ~= nowtime)then
						times = 0;
					end
		
					msg = "\\n�΄����Q��"..hunter_list[ongoing].name ..
							"\\n�ȼ����ƣ�"..hunter_list[ongoing].level_min.."��"..(hunter_list[ongoing].level_max) ..
							"\\n�΄�Ҫ��";
					for i = 1, hunter_list[ongoing].target.count do
						msg = msg .. hunter_list[ongoing].target[i].name.."��"..Field.Get(player, "hunter_target_"..i).."/"..hunter_list[ongoing].target[i].amount.."�� ";
					end
					msg = msg .. "\\n�΄ժ��"..hunter_action_reward_generate(ongoing);
					msg = msg .. "\\nÿ���΄����ƣ�"..times.."/"..hunter_list[ongoing].limit;
				end
				NLG.ShowWindowTalked(player,npc,CONST.����_��Ϣ��,CONST.��ť_ȷ��, 2000, msg);
			elseif (column==3) then	--�ύ����
				local flag = tonumber( Field.Get(player, "hunter_flag"));
				local button = CONST.��ť_�ر�;
				if( flag == nil or flag == 0)then
					msg = "������ÿ�իC������ϵ�y ...�Y���xȡ��...��\\n"
						.. "\\n�������������]�н����κ��΄ա�";
					button = CONST.��ť_�ر�;
				elseif( flag == 1)then
					msg = "������ÿ�իC������ϵ�y ...�Y���xȡ��...��\\n"
						.. "\\n�������������΄���δ��ɡ�";
					button = CONST.��ť_�ر�;
				elseif( flag == 2)then
					local number = tonumber( Field.Get(player, "hunter_ongoing_quest"));
					msg = "������ÿ�իC������ϵ�y ...�Y���xȡ��...��\\n"
						.. "\\n�������������Ƿ�_���ύ�΄գ�" .. "\\n�㌢�@�ã�"..hunter_action_reward_generate(number);
					button = CONST.��ť_�Ƿ�;
				end
				NLG.ShowWindowTalked(player,npc,CONST.����_��Ϣ��, button, 3000, msg);
			elseif (column==4) then	--��������
				local flag = tonumber( Field.Get(player, "hunter_flag"));
				local msg = nil;
				if( flag == 0 or flag == nil)then
					local msg = "������ÿ�իC������ϵ�y ...�Y���xȡ��...��\\n"
							.. "\\n�������������]�������M�е��΄ա�";
					NLG.ShowWindowTalked(player,npc,CONST.����_��Ϣ��, CONST.��ť_ȷ��, 4000, msg);
					return;
				else
					local msg = "������ÿ�իC������ϵ�y ...�Y���xȡ��...��\\n"
							.."\\n �ŗ��΄���ħ��1000���ҕ�Ӌ�����΄����Ɣ�������_���᣿";
				NLG.ShowWindowTalked(player,npc,CONST.����_��Ϣ��,CONST.��ť_�Ƿ�, 4000, msg);
				end
			end
		end
	end
end

function Module:facetonpc(npc,player)
	if NLG.CanTalk(npc,player) == true then
		local winButton = CONST.BUTTON_�ر�;
		local winMsg = "2|\\n������ÿ�իC������ϵ�y ...�Y���xȡ��...��\\n\\n"
			.. "�鿴�΄��б�\\n"
			.. "�鿴�ѽ��΄�\\n"
			.. "�ύ�΄�\\n"
			.. "�ŗ��΄�";
		NLG.ShowWindowTalked(player,npc,CONST.����_ѡ���, CONST.��ť_�ر�, 1, winMsg);
	end
	return
end

function hunter_callback_fartalk(player,npc)
	local winButton = CONST.BUTTON_�ر�;
	local winMsg = "2|\\n������ÿ�իC������ϵ�y ...�Y���xȡ��...��\\n\\n"
		.. "�鿴�΄��б�\\n"
		.. "�鿴�ѽ��΄�\\n"
		.. "�ύ�΄�\\n"
		.. "�ŗ��΄�";
	NLG.ShowWindowTalked(player,npc,CONST.����_ѡ���, CONST.��ť_�ر�, 1, winMsg);
end

--------------------------------------------------------------------------
--�����Ƿ�����ɱĿ��
function Module:OnbattleStartEventCallback(battleIndex)
	for i = 0, 4 do
		local player = Battle.GetPlayer(battleIndex,i)
		if(player>-1 and Char.IsPlayer(player)==true)then
			local flag = tonumber( Field.Get(player, "hunter_flag"));
			if( flag == 1)then
				local quest = tonumber( Field.Get(player, "hunter_ongoing_quest"));
				if( quest ~= nil and quest ~= 0)then
					for i = 1, hunter_list[quest].target.count do
						Field.Set(player, "hunter_target_temporary_"..i, 0);
					end
					for oppos = 10, 19 do
						local enemy = Battle.GetPlayer(battleIndex, oppos);
						if( enemy>=0 and Char.IsEnemy(enemy)==true)then
							for i = 1, hunter_list[quest].target.count do
								if( Char.GetData( enemy,CONST.����_����) == hunter_list[quest].target[i].name)then
									if( tonumber( Field.Get( player, "hunter_target_"..i)) < hunter_list[quest].target[i].amount)then
										Field.Set( player, "hunter_target_temporary_"..i, tostring( tonumber( Field.Get( player, "hunter_target_temporary_"..i))+1));
									end
								end
							end
						end
					end
				
					local sum = 0;
					for i = 1, hunter_list[quest].target.count do
						local target_count = tonumber( Field.Get( player, "hunter_target_"..i));
						if( target_count ~= nil)then
							if( target_count >= hunter_list[quest].target[i].amount)then
								sum = sum + 1;
							end
						end
					end
					if( sum == hunter_list[quest].target.count)then
						Field.Set( player, "hunter_flag", tostring( 2));
					end
				end
			end
		end
	end
end
--�ڳ���Ҹ����������
function Module:onBattleOver(battleIndex)
	for i=0,9 do
		local player = Battle.GetPlayer(battleIndex,i)
		if (player>-1 and Char.IsPlayer(player)==true) then
			if (Char.GetData(player,CONST.����_Ѫ) ~= 0) then
				hunter_battle_count(battleIndex, player);
			end
		end
	end
end
--��ɱ������
function hunter_battle_count(battleIndex, player)
	local quest = tonumber( Field.Get(player, "hunter_ongoing_quest"));
	if( quest ~= nil and quest ~= 0)then
		local flag = tonumber( Field.Get(player, "hunter_flag"));
		if( flag ~= nil)then
			if( flag == 1)then
				for i = 1, hunter_list[quest].target.count do
					precount = tonumber( Field.Get(player, "hunter_target_temporary_"..i));
					count = tonumber( Field.Get(player, "hunter_target_"..i));
					if( precount == nil)then
						precount = 0;
					end
					if( count == nil)then
						count = 0;
					end
					
					count = count + precount;
					
					Field.Set( player, "hunter_target_"..i, tostring( count));
					NLG.SystemMessage(player,"[ϵ�y]�C���΄գ�"..hunter_list[quest].target[i].name.." "..count.."/"..hunter_list[quest].target[i].amount.."��");
				end
			end
			local sum=0;
			for i = 1, hunter_list[quest].target.count do
				local target_count = tonumber( Field.Get(player, "hunter_target_"..i));
				if( target_count ~= nil)then
					if( target_count >= hunter_list[quest].target[i].amount)then
						sum = sum + 1;
					end
				end
			end
			if( sum == hunter_list[quest].target.count)then
				Field.Set(player, "hunter_flag", tostring( 2));
				for i = 1, hunter_list[quest].target.count do
					NLG.SystemMessage(player,"[ϵ�y]�C���΄գ�"..hunter_list[quest].target[i].name.." ��ɣ�");
				end
			end
		end
	end
end

------------------------------------------------------------------------------------------------------------------------
--���ܺ���
--ս��Ʒ˵��
function hunter_action_reward_generate(quest)
	local msg = "";
	if( hunter_list[quest].reward.gold ~= 0)then
		msg = msg .. "ħ�š�".. hunter_list[quest].reward.gold.." ";
	end
	if( hunter_list[quest].reward.lp ~= 0)then
		msg = msg .. "Ѫ�ء�".. hunter_list[quest].reward.lp.." ";
	end
	if( hunter_list[quest].reward.fp ~= 0)then
		msg = msg .. "ħ�ء�".. hunter_list[quest].reward.fp.." ";
	end
	for i = 1, #hunter_list[quest].reward.item do
		msg = msg .. ""..hunter_list[quest].reward.item[i].name.."��"..hunter_list[quest].reward.item[i].amount.." ";
	end
	return msg;
end

--ж��ģ��
function Module:onUnload()
	self:logInfo('unload')
end
return Module
