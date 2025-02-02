--ģ����
local Module = ModuleBase:createModule('SigninSheet')

local count_Max = 1;		--����
--��������
local rewards_list = {};
rewards_list[1] = {"а��������Ƭ",70201,100};
rewards_list[2] = {"�Ļ�֮��",70194,20};
rewards_list[3] = {"�����ǹ�",900504,20};
rewards_list[4] = {"а��������Ƭ",70201,100};
rewards_list[5] = {"��������",631092,1000};
rewards_list[6] = {"а��������Ƭ",70201,100};
rewards_list[7] = {"1ǧG���Q��",70016,10};
rewards_list[14] = {"���ɽ���",66668,50};
rewards_list[30] = {"�ؼ���˹�ز�",51020,100};

--ʣ���������
local signin_daily_rewards_user = {};
local signin_daily_rewards_user_count = {};
signin_daily_rewards_user_count[1] = {};	--����������
--signin_daily_rewards_user_count[2] = {};	--����������

------------------------------------------------------------------------------------------------------------------------
--���ܺ���
function Time_Check(_obj)	--�ж��Ƿ�һ��ʱ���ѹ�
	if (os.date("%d",_obj) ~= os.date("%d",os.time())) then 
		return true;
	end
	return false;
end

function Time_Out(player)	--ÿ��24��Ϊ�ж���ʱ
	local _obj = signin_daily_rewards_user[Playerkey(player)];
	--����״ε�¼
	if (_obj == nil) then 
		signin_daily_rewards_user[Playerkey(player)] = os.time();
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

------------------------------------------------------------------------------------------------------------------------
--����ģ��
function Module:onLoad()
	self:logInfo('load')
	self.signInNPC = self:NPC_createNormal('��������T',106602,{x=34, y=33, mapType=0, map=777, direction=6})
	self:NPC_regWindowTalkedEvent(self.signInNPC,Func.bind(self.click,self))
	self:NPC_regTalkedEvent(self.signInNPC,Func.bind(self.facetonpc,self))
end

--Զ�̰�ťUI����
function Module:signInInfo(npc, player)
	if (Time_Out(player)) then
		signin_daily_rewards_user[Playerkey(player)] = os.time();
		for i=1,#signin_daily_rewards_user_count do			--ÿ�ո����������
			signin_daily_rewards_user_count[i][Playerkey(player)] = nil;
		end
	end

	local rewardscount = signin_daily_rewards_user_count[1][Playerkey(player)];
	if (rewardscount == nil or rewardscount ==0) then
		rewardscount = 0;
		signin_daily_rewards_user_count[1][Playerkey(player)] = 0;

		local daily = tonumber(os.date("%w",os.time()));
		if(os.date("%w",os.time()) =="0")then daily =7; end
		local ItemsetIndex = Data.ItemsetGetIndex(rewards_list[daily][2]);
		local Item_name= Data.ItemsetGetData( ItemsetIndex, CONST.ITEMSET_TRUENAME);
		local Item_image= Data.ItemsetGetData( ItemsetIndex, CONST.ITEMSET_BASEIMAGENUMBER);
		local imageText = "@g,"..Item_image..",5,5,4,0@"

		local Player_image = Char.GetData(player, CONST.����_����);
		local imageText_p = "@g,"..Player_image..",17,7,6,6@"

		local msg = "������������������ÿ�պ���ϵ�y��\\n"
			.. "������$1���պ������µ��������ӽo�誄��\\n"
		msg = msg .. imageText .. "\\n\\n��������������������$5" .. Item_name .. "\\n\\n����������������������" .. rewards_list[daily][3] .. " ��" .. imageText_p

		local SignInCheck = Char.GetExtData(player, '�ۻ�ǩ��') or 0;
		msg = msg .. "\\n\\n������������������$4�۷e����:"..SignInCheck.."��"
		NLG.ShowWindowTalked(player, self.signInNPC, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 1, msg);
	elseif (rewardscount >= count_Max) then
		NLG.SystemMessage(player, "[ϵ�y]�����Iȡÿ�պ������");
		return;
	end
end

function Module:click(npc,player,_seqno,_select,_data)--�����е������
	local column = tonumber(_data)
	local page = tonumber(_seqno)
	local warpPage = page;
	--��ҳ16 ��ҳ32 ȡ��2
	if _select > 0 then
		if (_seqno == 1 and _select == CONST.��ť_��) then
			return;
		elseif (_seqno == 1 and _select == CONST.��ť_��) then
			--local selectitem = tonumber(_data);

			if (Char.GetData(player,CONST.CHAR_�ȼ�)<20) then	--�ȼ��ж�
				NLG.SystemMessage(player, "[ϵ�y]������20�ȼ��o���Iȡ��");
				return;
			end
			if (Char.ItemSlot(player)>18) then
				NLG.SystemMessage(player, "[ϵ�y]Ո���������Iȡ�������");
				return;
			end

			local rewardscount = signin_daily_rewards_user_count[1][Playerkey(player)];
			if (rewardscount == nil) then
				rewardscount = 0;
				signin_daily_rewards_user_count[1][Playerkey(player)] = 0;
			end

			if (rewardscount >= count_Max) then
				NLG.SystemMessage(player, "[ϵ�y]�����Iȡÿ�պ������");
				return;
			else
				signin_daily_rewards_user_count[1][Playerkey(player)] = rewardscount + 1;
				if(os.date("%w",os.time()) =="0")then Char.GiveItem(player,rewards_list[7][2],rewards_list[7][3]) end
				if(os.date("%w",os.time()) =="1")then Char.GiveItem(player,rewards_list[1][2],rewards_list[1][3]) end
				if(os.date("%w",os.time()) =="2")then Char.GiveItem(player,rewards_list[2][2],rewards_list[2][3]) end
				if(os.date("%w",os.time()) =="3")then Char.GiveItem(player,rewards_list[3][2],rewards_list[3][3]) end
				if(os.date("%w",os.time()) =="4")then Char.GiveItem(player,rewards_list[4][2],rewards_list[4][3]) end
				if(os.date("%w",os.time()) =="5")then Char.GiveItem(player,rewards_list[5][2],rewards_list[5][3]) end
				if(os.date("%w",os.time()) =="6")then Char.GiveItem(player,rewards_list[6][2],rewards_list[6][3]) end
				local SignInCheck = Char.GetExtData(player,'�ۻ�ǩ��') or 0;
				if (SignInCheck<30) then
					Char.SetExtData(player,'�ۻ�ǩ��',SignInCheck+1);
					NLG.UpChar(player);
				else
					Char.SetExtData(player,'�ۻ�ǩ��',0);
					NLG.UpChar(player);
				end
				if (SignInCheck==13) then
					Char.GiveItem(player,rewards_list[14][2],rewards_list[14][3]);
				elseif (SignInCheck==29) then
					Char.GiveItem(player,rewards_list[30][2],rewards_list[30][3]);
					Char.SetExtData(player,'�ۻ�ǩ��',0);
					NLG.UpChar(player);
				end
			end
		end
	else

	end
end

function Module:facetonpc(npc,player)
	if NLG.CanTalk(npc,player) == true then
		if (Time_Out(player)) then
			signin_daily_rewards_user[Playerkey(player)] = os.time();
			for i=1,#signin_daily_rewards_user_count do			--ÿ�ո����������
				signin_daily_rewards_user_count[i][Playerkey(player)] = nil;
			end
		end

		local rewardscount = signin_daily_rewards_user_count[1][Playerkey(player)];
		if (rewardscount == nil or rewardscount ==0) then
			rewardscount = 0;
			signin_daily_rewards_user_count[1][Playerkey(player)] = 0;

			local daily = tonumber(os.date("%w",os.time()));
			if(os.date("%w",os.time()) =="0")then daily =7; end
			local ItemsetIndex = Data.ItemsetGetIndex(rewards_list[daily][2]);
			local Item_name= Data.ItemsetGetData( ItemsetIndex, CONST.ITEMSET_TRUENAME);
			local Item_image= Data.ItemsetGetData( ItemsetIndex, CONST.ITEMSET_BASEIMAGENUMBER);
			local imageText = "@g,"..Item_image..",5,5,4,0@"

			local Player_image = Char.GetData(player, CONST.����_����);
			local imageText_p = "@g,"..Player_image..",17,7,6,6@"

			local msg = "������������������ÿ�պ���ϵ�y��\\n"
				.. "������$1���պ������µ��������ӽo�誄��\\n"
			msg = msg .. imageText .. "\\n\\n��������������������$5" .. Item_name .. "\\n\\n����������������������" .. rewards_list[daily][3] .. " ��" .. imageText_p

			local SignInCheck = Char.GetExtData(player, '�ۻ�ǩ��') or 0;
			msg = msg .. "\\n\\n������������������$4�۷e����:"..SignInCheck.."��"
			NLG.ShowWindowTalked(player, self.signInNPC, CONST.����_��Ϣ��, CONST.��ť_�Ƿ�, 1, msg);
		elseif (rewardscount >= count_Max) then
			NLG.SystemMessage(player, "[ϵ�y]�����Iȡÿ�պ������");
			return;
		end
	end
	return
end

--ж��ģ��
function Module:onUnload()
	self:logInfo('unload')
end
return Module
