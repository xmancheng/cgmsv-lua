-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
--ahsin���ģ�����Ӷ��
--�汾��20250721c
--��lua����������m�е��¿����
--�׷���̳ www.cnmlb.com ��ȡ���°汾

--���ڹ��ܱȽϷḻ����ѷ������ѡ�����bվ����ޡ�һ�����������ְɣ�
--https://space.bilibili.com/21127109
--qqȺ��85199642

--��luaֻ֧��cgmsv+�¿�ܣ���Ȼ100%�ܲ�����
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

--ģ����
local ����Ӷ��Module = ModuleBase:createModule('����Ӷ��')--����Ӷ��

--����ģ�鹳��
function ����Ӷ��Module:onLoad()
	self:logInfo('load')
	self:regCallback('LoginEvent', Func.bind(self.���ߴ���, self))--���ߴ���
	self:regCallback('LoginGateEvent', Func.bind(self.�ǻس�����, self))--�ǻس����㴥��
	self:regCallback('ResetCharaBattleStateEvent', Func.bind(self.�ǻس�����, self))--ս���󴥷�2
	self:regCallback('BattleOverEvent', Func.bind(self.ս����������, self))--ս����������
	self:regCallback('BeforeBattleTurnEvent', Func.bind(self.�غϿ�ʼǰ����, self))--�غϿ�ʼǰ����
	self:regCallback('TalkEvent', Func.bind(self.���˵��, self))--���˵��
	self:regCallback('AfterWarpEvent', Func.bind(self.���ʹ���, self))--���ʹ���
	self:regCallback('LogoutEvent', Func.bind(self.���ߵ��ߴ���, self))--���ߴ���
	self:regCallback('DropEvent', Func.bind(self.���ߵ��ߴ���, self))--���ߴ���
	ai_npc = self:NPC_createNormal('aiӶ������',104862,{x=234,y=70,mapType=0,map=1000,direction=6})--aiӶ������npc
	self:NPC_regWindowTalkedEvent(ai_npc,Func.bind(self.��������,self))--aiӶ������npc���ڰ�ť����
	self:NPC_regTalkedEvent(ai_npc,Func.bind(self.����npc����,self))--����ai_npc����
	local ������ұ� = NLG.GetPlayer() or false--��ȡ������ұ��������Ӷ��
	if ������ұ� ~= -1 then
		for k,v in pairs(������ұ�) do
			if Char.IsDummy(v) then
				Char.LeaveParty(v)
				Char.DelDummy(v)
			end
		end
		������ұ� = nil
	end
end

--ְҵͳ�ƣ� ��-44 | ��-14 | ��-24 | ��-34 | ��-144 | ħ-74 | ��-64 | ��-134 | ��-84 | ��-154
--����ͳ�ƣ� ˮ����215 | 201���� | 206��³��˹ | 211��� | 220ˮ���� | 250ˮ��֮��-�� ,��luaֻ�и񶷻��Զ��жϸ����·�������ְҵĬ�ϴ�����
--20250721��ʼ��֧�ִ۸�Ӷ���ֳ��������ԣ��Ӵ�Ӷ������Ҫװ����������һ�������͹��ˣ����ԾͲ����ˣ���ʹ����Ҳ����bt�����ܸ���
--����ai = {��,ai����,ְҵ��ʾ,ͼ��id,job,jobrank,����id,'����Ѫ|����ħ|������|������|������|������|����ħ��|����ħ��|������|������|������|������|������|������',��ͨ�۸�}
--�������������Բ�����Ĭ�ϵģ�д�����ġ����ɣ����������ּ��ɣ�֧�ָ���
local ai_list = {
{1,'���S','������',120119,44,40,215,'����|����|����|����|����|����|����|����|����|����|����|15|200|999',100},
{2,'����','��ʿ',105509,14,10,201,'����|����|����|����|����|����|����|����|����|����|����|����|200|999',100},
{3,'��܊','ս����ʿ',105150,24,20,206,'����|����|����|����|����|����|����|����|����|����|����|����|200|999',100},
{4,'��Ұ','��ʿ',105061,34,30,211,'����|����|����|����|����|����|����|����|����|����|����|����|200|999',100},
{5,'���_','��',105102,144,140,250,'����|����|����|����|����|����|����|����|����|����|����|15|200|999',100},
{6,'����','ħ��ʦ',105266,74,70,220,'����|����|����|����|����|����|����|����|����|����|����|����|200|999',100},
{7,'����','����ʿ',105285,64,60,220,'500|����|����|����|����|����|����|����|����|����|����|����|800|999',200},
{8,'Īа','��ʦ',105416,134,130,220,'500|����|����|����|����|����|����|����|����|����|����|����|800|999',200},

{9,'GM���S','������',120119,44,40,215,'2000|����|500|����|����|����|����|����|����|����|����|15|200|999',100},
{10,'GM����','��ʿ',105509,14,10,201,'2000|����|500|����|����|����|����|����|����|����|����|����|200|999',100},
{11,'GM��܊','ս����ʿ',105150,24,20,206,'2000|����|500|����|����|����|����|100|����|����|����|����|200|999',100},
{12,'GM��Ұ','��ʿ',105061,34,30,211,'2000|����|500|����|����|����|����|100|����|70|����|����|200|999',100},
{13,'GM���_','��',105102,144,140,250,'2000|����|500|����|����|����|����|����|����|����|����|15|200|999',100},
{14,'GM����','ħ��ʦ',105266,74,70,220,'2000|1000|����|����|����|1000|350|����|����|����|����|����|200|999',100},
{15,'GM����','����ʿ',105285,64,60,220,'5000|1000|����|����|����|����|����|����|����|����|����|����|800|999',200},
{16,'GMĪа','��ʦ',105416,134,130,220,'5000|1000|����|����|500|����|����|����|����|����|����|����|800|999',200},
--{9,'����','��ʿ',108324,14,10,201,'����|����|����|����|����|����|����|����|����|����|����|����|200|999',150},
--{10,'˾����ѩ','����ʦ',108233,84,80,220,'500|����|����|����|����|����|����|����|����|����|����|����|800|999',300},
--{11,'���ǲ���','����',102860,154,150,201,'500|����|����|����|250|����|����|200|15|15|15|15|800|999',500},--bossս���˲���ɱ�趨�������ĳЩ��ͨս����Ҳ����boss���㲻���Ƽ�ע�Ͱ�ɱ����
--{12,'GM','GM',170001,481,480,220,'999|999|999|999|999|999|999|999|999|999|999|999|999|999',1000},--����ְҵ��������job��û��481������ñ�̬��ע��
}
local ��ͨ���� = 1--0ħ�ң�1�Զ����
local �Զ������ = 'CN��'
local �Զ����itemid = 88888
local ai��͵ȼ� = 70--�����ҵȼ�С��70��ai�ȼ�ǿ��Ϊ70����ҵȼ�����70��ai�ȼ�������˵ĵȼ���
local ai�˿����� = 999999999--diy����ÿ��·������ai�˿�����
local �����ļӶ������ȼ� = 20
local ai�˿�ͳ�� = 0--��ʼ������
local ս������� = {}--��ʼ��ս�������
local ��ҳ���ai�� = {}--��ʼ��������ݱ�
local ����ҳ = {}--��ʼ����ҷ�ҳ���ݱ�
local ���Ԥ���嵥 = {}--��ʼ�����Ԥ���嵥
local װ�������� = {--��ʼ�����װ����������
	CONST.����_����,CONST.����_ħ��,CONST.����_����,CONST.����_����,CONST.����_����,CONST.����_����,CONST.����_ħ��,
	CONST.����_ħ��,CONST.����_����,CONST.����_����,CONST.����_��ɱ,CONST.����_����,CONST.����_�ظ�,CONST.����_����,
}

function ����Ӷ��Module:����npc����(npc,player)--����ai_npc����
	if Char.GetData(player,CONST.����_�ȼ�) < �����ļӶ������ȼ� then
		NLG.ShowWindowTalked(player,player,CONST.����_��Ϣ��,CONST.��ť_�ر�,player+404404,'@c��CNħ�� AI��Ӷ��ϵͳ��\\n\\n\\n\\n����'..�����ļӶ������ȼ�..'�������ɡ�')
		return
	end
	local ����״̬ = {}
	for i = 1,#ai_list do
		if not ��ҳ���ai��[player] then
			self:���ߴ���(player)
		end
		if ��ҳ���ai��[player][i] >= 1 then
			����״̬[i] = '������'
		else
			����״̬[i] = '��ļ'
		end
	end
	local ռ���� = 2 + #ai_list
	local �ּ�ҳ = math.ceil(ռ����/10)
	local �������� = '1|@c\\n��CNħ�� AI��Ӷ��ϵͳ��'
	..'\\n--> ��Ӷ����� <--'
	local GMcdk = Char.GetData(player,CONST.����_GM);
	print(GMcdk)
	if GMcdk==0 then
		for j = 1,8 do
			j = j + ((����ҳ[player]-1)*8)
			�������� = �������� .. left('\\n'..ai_list[j][2],15)..left(ai_list[j][3],15)..left(����״̬[j],11)
			--if j >= #ai_list then
			--	break
			--end
		end
	elseif GMcdk==1 then
		for j = 9,16 do
			j = j + ((����ҳ[player]-1)*8)
			�������� = �������� .. left('\\n'..ai_list[j][2],15)..left(ai_list[j][3],15)..left(����״̬[j],11)
			if j >= #ai_list then
				break
			end
		end
	end
	if ����ҳ[player]-1 == 0 then--��ҳ
		NLG.ShowWindowTalked(player,npc,CONST.����_ѡ���,CONST.��ť_�ر�,player+3330,��������)
	elseif ����ҳ[player] == �ּ�ҳ then--���һҳ
		NLG.ShowWindowTalked(player,npc,CONST.����_ѡ���,CONST.��ť_�ر�+CONST.��ť_��һҳ,player+3330,��������)
	else--�м�ҳ
		NLG.ShowWindowTalked(player,npc,CONST.����_ѡ���,CONST.��ť_�ر�+CONST.��ť_��һҳ+CONST.��ť_��һҳ,player+3330,��������)
	end
end

function ����Ӷ��Module:��������(npc,player,seq,sel,data)--aiӶ������npc���ڰ�ť����
	seq = tonumber(seq)
	sel = tonumber(sel)
	data = shuzipanduan(data)
	--print('seq��'..seq)
	--print('sel��'..sel)
	--print('data��'..data)
	if sel == 2	then--ȡ��
		print('aiӶ����������ȡ��')
		return
	end
	if sel == 16 and seq == player+404404 then--����ҳ����һҳ
		self:����npc����(npc,player)
		return
	end
	if sel == 16 and seq == 0 then--��һҳ
		self:����npc����(npc,player)
		return
	end
	if sel == 16 and seq == player+8888 then--���򷵻���һҳ
		self:����npc����(npc,player)
		return
	end
	if seq == player+3330 then--��һҳ
		if data == 1 then
			local �������� = '@c               ��CNħ�� AI��Ӷ��ϵͳ��顿'
			..'\\n'
			..'\\n1��ÿ����������ļ4����Ӷ�����һ�ӣ���Ӷ�������Ѿ�����������boss���䡣'
			..'\\n'
			..'\\n2����Ӷ��ÿ��ս������Զ����ơ��лꡢ��Ѫ����ħ�����������κθ�Ԥ����������Ӷ��ս����������Ҳ��Ӱ���������ս����'
			..'\\n'
			..'\\n3����Ӷ����ս���У�û�غϻ��Զ���ħ���������赣��ս���еĹ�Ӷ����ûħ�ż��ܡ�'
			..'\\n'
			..'\\n4����Ӷ�������ԡ��ȼ��Ȼ�ο���Ľ�ɫ�������Բ�������ˮ�������������ϵħ�����Ի��Ե��ߡ�'
			..'\\n'
			..'\\n5����Ӷ��ս���в������ʹ�ñ�ְҵ���ܣ���Ӷ���ĳ������ʹ�ó����ḻ�ĳ��＼�ܡ����Ǿ����ʲô���ܣ������г��ԡ�'
			..'\\n'
			..'\\n6����ϵͳ������飬�����͵������Ӷ����Ϊ�������ʹ��ʱ������������֮ʱ����������Ȼ�Ƽ����ע�ؼ�ǿ�����Լ���'
			..'\\n'
			..'\\n7��������ݼ���/killai ������й�Ӷ�� /aiback ��Ӷ��˲����'
			NLG.ShowWindowTalked(player,npc,CONST.����_����Ϣ��,CONST.��ť_�ر�+CONST.��ť_��һҳ,0,��������)
			return
		end
		if sel == 32 then--��һҳ
			����ҳ[player] = ����ҳ[player] + 1
			--print('����ҳ[player] = '..����ҳ[player])
			self:����npc����(npc,player)
			return
		end
		if sel == 16 then--��һҳ
			����ҳ[player] = ����ҳ[player] - 1
			--print('����ҳ[player] = '..����ҳ[player])
			self:����npc����(npc,player)
			return
		end
		for i = 2,9 do--�����ļ/���
			if data == i then
				i = i + ((����ҳ[player]-1)*8) -1
				local GMcdk = Char.GetData(player,CONST.����_GM);
				if GMcdk==1 then i=i+8; end
				local �Ƿ�ͨ =  Char.GetExtData(player,'ai-'..ai_list[i][2]) or 'no'
				if �Ƿ�ͨ == 'no' then
					���Ԥ���嵥[player] = i
					local ��λ = false
					if ��ͨ���� == 0 then
						��λ = 'ħ��'
					else
						��λ = �Զ������
					end
					local �������� = '@c��CNħ�� AI��Ӷ��ϵͳ��'
					..'\\n\\n\\n['..ai_list[i][2]..'] ��û��ͨ'
					..'\\n\\n�۸�'..ai_list[i][9]..' '..��λ
					..'\\n\\n\\n�Ƿ���'
					NLG.ShowWindowTalked(player,npc,CONST.����_��Ϣ��,CONST.��ť_�Ƿ�+CONST.��ť_��һҳ,player+8888,��������)
					return
				end
				��ļai(player,i)
				self:����npc����(npc,player)
				return
			end
		end
	end
	if seq == player+8888 and sel == 4 then--�����Ӷ��
		local Ԥ��Ŀ�� = ���Ԥ���嵥[player]
		local �շѼ۸� = ai_list[Ԥ��Ŀ��][9]
		print('���Ԥ���嵥 = '..���Ԥ���嵥[player])
		print('�շѼ۸� = '..�շѼ۸�)
		if ��ͨ���� == 0 then--ħ��
			if Char.GetGold(player) < �շѼ۸� then
				NLG.ShowWindowTalked(player,npc,CONST.����_��Ϣ��,CONST.��ť_��һҳ,player+404404,'@c��CNħ�� AI��Ӷ��ϵͳ��\\n\\n\\n\\n��ûǮ�ˡ�')
				return
			elseif Char.GetGold(player) >= �շѼ۸� then
				Char.AddGold(player,-�շѼ۸�)
				NLG.ShowWindowTalked(player,npc,CONST.����_��Ϣ��,CONST.��ť_��һҳ,player+404404,'@c��CNħ�� AI��Ӷ��ϵͳ��\\n\\n\\n\\���ѳɹ����� ['..ai_list[Ԥ��Ŀ��][2]..']��')
				NLG.Say(player,-1,'����֧����'..�շѼ۸�..' ���',CONST.��ɫ_��ɫ,CONST.����_��)--����Ǯ֪ͨ
				Char.SetExtData(player,'ai-'..ai_list[Ԥ��Ŀ��][2],'yes')
				Char.SaveToDb(player)
				return
			end
		elseif ��ͨ���� == 1 then--�Զ����
			local ��ҳ��е��Զ���ұ����� = Char.ItemNum(player,�Զ����itemid)
			if ��ҳ��е��Զ���ұ����� < �շѼ۸� then
				NLG.ShowWindowTalked(player,npc,CONST.����_��Ϣ��,CONST.��ť_��һҳ,player+404404,'@c��CNħ�� AI��Ӷ��ϵͳ��\\n\\n\\n\\n��û'..�Զ������..'�ˡ�')
				return
			elseif ��ҳ��е��Զ���ұ����� >= �շѼ۸� then
				Char.DelItem(player,�Զ����itemid,�շѼ۸�,true)
				NLG.ShowWindowTalked(player,npc,CONST.����_��Ϣ��,CONST.��ť_��һҳ,player+404404,'@c��CNħ�� AI��Ӷ��ϵͳ��\\n\\n\\n\\���ѳɹ����� ['..ai_list[Ԥ��Ŀ��][2]..']')
				Char.SetExtData(player,'ai-'..ai_list[Ԥ��Ŀ��][2],'yes')
				Char.SaveToDb(player)
				return
			end
		end
		return
	end
end

function ����Ӷ��Module:�ǻس�����(player)--�ǻس����㴥��
	if not ��ҳ���ai��[player] then--reload�����ݱ��ʼ��
		self:���ߴ���(player)
	end
	if ��ҳ���ai��[player][0] >= 0 then
		self:���˵��(player,'/aiback')
	end
	return 0
end

function ����Ӷ��Module:���ߴ���(player)--���ߴ���������ai�������ݱ�
	��ҳ���ai��[player] = {}
	����ҳ[player] = 1
	��ҳ���ai��[player][0] = 0--ai��������ͳ��
	for i = 1,#ai_list do
		��ҳ���ai��[player][i] = -1
	end
	return 0
end

function ����Ӷ��Module:���ʹ���(player,map,floor,x,y,aftermap,afterfloor,afterx,aftery)--���ʹ���
	if Char.IsDummy(player) then
		--print('ai_index��ţ�'..player)
		return
	else
		if not ��ҳ���ai��[player] then--reload�����ݱ��ʼ��
			self:���ߴ���(player)
		end
		--print('���index��ţ�'..player)
		if ��ҳ���ai��[player][0] >= 0 then
			for i = 1,#ai_list do
				if Char.PartyNum(��ҳ���ai��[player][i]) == -1 then
					Char.Warp(��ҳ���ai��[player][i],aftermap,afterfloor,afterx,aftery)
					Char.SetData(player,CONST.����_��ӿ���,1)
					Char.JoinParty(��ҳ���ai��[player][i],player)
				end
			end
		end
	end
end

function ����Ӷ��Module:���ߵ��ߴ���(player)--���ߴ���
	--print('������ߵ��ߴ���')
	for i = 1,#ai_list do
		if ��ҳ���ai��[player][i] > 0 then
			Char.DelDummy(��ҳ���ai��[player][i])
			��ҳ���ai��[player][0] = 0
		end
	end
	��ҳ���ai��[player][0] = 0
end

function ����Ӷ��Module:���˵��(player,msg,color,range,size)--���˵��
	if not ��ҳ���ai��[player] then--reload�����ݱ��ʼ��
		self:���ߴ���(player)
	end
	if msg == '/aiyb' or msg == '��aiyb' then
		self:����npc����(ai_npc,player)
		return 0
	end
	if msg == '/aiback' or msg == '��aiback' then
		if ��ҳ���ai��[player][0] <= 0 then
			return 0
		end
		local wjmap = Char.GetData(player,CONST.����_MAP)
		local wjfloor = Char.GetData(player,CONST.����_��ͼ)
		local wjx = Char.GetData(player,CONST.����_X)
		local wjy = Char.GetData(player,CONST.����_Y)
		for i = 1,#ai_list do
			if Char.PartyNum(��ҳ���ai��[player][i]) == -1 then
				Char.Warp(��ҳ���ai��[player][i],wjmap,wjfloor,wjx,wjy)
				Char.SetData(player,CONST.����_��ӿ���,1)
				Char.JoinParty(��ҳ���ai��[player][i],player)
			end
		end
		return 0
	end
	if msg == '/killai' or msg == '��killai' then--�ɵ�ai������
		for i = 1,#ai_list do
			if ��ҳ���ai��[player][i] > 0 then
				Char.DelDummy(��ҳ���ai��[player][i])
				��ҳ���ai��[player][i] = -1
				��ҳ���ai��[player][0] = 0
			end
		end
		NLG.PlaySe(player,72,0,0)
		Char.DischargeParty(player)
		NLG.SystemMessage(player, '�ѿ�������Ӷ����' )
		return 0
	end
	return 1--pass talk
end

function ����Ӷ��Module:ս����������(battleindex)--ս�󴥷�
	ս�������[battleindex] = nil
	for i = 0,19 do--ai�Զ���Ѫ��ħ���лꡢ����
		local ai = Battle.GetPlayer(battleindex,i) or -1
		if Char.IsDummy(ai) then--ai�ж�
			--print('ai����״̬��'..Char.GetData(ai,CONST.����_����))
			--print('ai����״̬��'..Char.GetData(ai,CONST.����_����))
			Char.SetData(ai,CONST.����_����,0)
			NLG.UpChar(ai)
			Char.SetData(ai,CONST.����_����,0)
			NLG.UpChar(ai)
			Char.SetData(ai,CONST.����_Ѫ,Char.GetData(ai,CONST.����_���Ѫ))
			Char.SetData(ai,CONST.����_ħ,Char.GetData(ai,CONST.����_���ħ))
			local װ��index = false
			if Char.GetData(ai,CONST.����_ְ��ID) == 140 then--�񶷻�ȡ�·�index
				װ��index = Char.GetItemIndex(ai,CONST.λ��_��)
			else--����ְҵ��ȡ����index
				װ��index = Char.GetItemIndex(ai,CONST.λ��_����)
			end
			local ˮ��index = Char.GetItemIndex(ai,CONST.λ��_ˮ��)
			Item.SetData(װ��index,CONST.����_�;�,9999)--��װ��
			Item.SetData(װ��index,CONST.����_����;�,9999)--��װ��
			Item.SetData(ˮ��index,CONST.����_�;�,9999)--��װ��
			Item.SetData(ˮ��index,CONST.����_����;�,9999)--��װ��
			local ai_petslot = Char.GetData(ai,CONST.����_ս��) or -1--ai�����ж�
			if ai_petslot > -1 then--����г���
				local ai_pet = Char.GetPet(ai,ai_petslot)
				Char.SetData(ai_pet,CONST.����_����,0)
				Char.SetData(ai_pet,CONST.����_�ҳ�,100)
				Char.SetData(ai_pet,CONST.����_�����ҳ�,100)
				Char.SetPetDepartureState(ai, 0, CONST.PET_STATE_ս��)
				Char.SetData(ai, CONST.CHAR_ս��, 0)
				Char.SetData(ai_pet,CONST.PET_DepartureBattleStatus, CONST.PET_STATE_ս��)
				Char.SetData(ai_pet,CONST.����_Ѫ,Char.GetData(ai_pet,CONST.����_���Ѫ))
				Char.SetData(ai_pet,CONST.����_ħ,Char.GetData(ai_pet,CONST.����_���ħ))
				Pet.UpPet(ai,ai_pet)
				NLG.UpChar(ai_pet)
			end
			NLG.UpChar(ai)
		end
		if Char.IsPlayer(ai) then--����ж�
			self:���˵��(ai,'/aiback')
		end
	end
	return 0
end

function ����Ӷ��Module:�غϿ�ʼǰ����(battleindex)
	--ְҵͳ�ƣ� ��-44 | ��-14 | ��-24 | ��-34 | ��-144 | ħ-74 | ��-64 | ��-134 | ��-84 | ��-154
	local ����index = Battle.GetTurn(battleindex)
	if ս�������[battleindex] == ����index then
		return
	end
	ս�������[battleindex] = ����index
	--print('�غϿ�ʼǰ������battleindex��'..battleindex)
	--print('����index��'..����index)
	local player = {}--��Ҵ洢
	for i = 0, 19 do
		local ai_index = Battle.GetPlayer(battleindex, i)
		if ai_index >= 0 then
			if Char.IsPlayer(ai_index) then--��¼�˵�index
				player[i] = ai_index
			end
			if Char.IsDummy(ai_index) then--ai�ж�
				player[i] = ai_index
				if Char.GetData(ai_index,CONST.����_ħ) < 500 then--ȷ��aiһֱ��ħ�����޷ż���
					Char.SetData(ai_index,CONST.����_ħ,Char.GetData(ai_index,CONST.����_���ħ))
				end
				--print('ai�Զ�ս����',ai_index,petindex)
				if Battle.IsWaitingCommand(ai_index) then--ְҵʹ�ü����ж�
					local ְҵ�� = Char.GetData(ai_index,CONST.����_ְ��ID)
					local ս��ָ��ӿ� = CONST.BATTLE_COM--��ģ��ᱬը
					local ����ѡ��ӿ� = Battle.ActionSelect--��ģ��ᱬը
					if Battle.GetType(battleindex) == CONST.ս��_PVP then--PK��·
						Char.SimpleLogout(ai_index)
						goto pk�Թ�
					end
					--��1��
					if ְҵ�� == 40 then--��
						local ���ܱ� = {
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_P_RANDOMSHOT,math.random(10,19),9509) end,--����
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_DELAYATTACK,math.random(10,19),25809) end,--һ������
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_P_DODGE,math.random(10,19),909) end,--����
						}
						if math.random(1,100) < 70 then--�����ͷŸ���70%
							pcall(���ܱ�[1])
						else--�����������ʩ��
							local ���ʩ�� = math.random(1,#���ܱ�)
							pcall(���ܱ�[���ʩ��])
						end
					end
					if ְҵ�� == 10 then--��
						local ���ܱ� = {
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_FIRSTATTACK,math.random(10,19),26209) end,--Ѹ��
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_BLASTWAVE,math.random(10,19),200509) end,--����--��ȷ�����techҲ��������
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_P_PARAMETER,math.random(10,19),309) end,--Ǭ��
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_P_PARAMETER,math.random(10,19),109) end,--����
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_P_RENZOKU,math.random(10,19),9) end,--��������
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_P_RENZOKU,math.random(10,19),8) end,--��������
						}
						local ���ʩ�� = math.random(1,#���ܱ�)
						pcall(���ܱ�[���ʩ��])
					end
					if ְҵ�� == 20 then--��
						local ���ܱ� = {
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_DELAYATTACK,math.random(10,19),25709) end,--�佾����
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_P_PARAMETER,math.random(10,19),309) end,--Ǭ��
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_P_PARAMETER,math.random(10,19),109) end,--����
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_P_RENZOKU,math.random(10,19),9) end,--��������
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_P_RENZOKU,math.random(10,19),8) end,--��������
						}
						if math.random(1,100) < 70 then--�佾�����ͷŸ���70%
							pcall(���ܱ�[1])
						else--�����������ʩ��
							local ���ʩ�� = math.random(1,#���ܱ�)
							pcall(���ܱ�[���ʩ��])
						end
					end
					if ְҵ�� == 30 then--��
						local ���ܱ� = {
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_BILLIARD,math.random(15,19),26009) end,--һʯ����
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_P_PARAMETER,math.random(10,19),309) end,--Ǭ��
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_P_PARAMETER,math.random(10,19),109) end,--����
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_P_RENZOKU,math.random(10,19),9) end,--��������
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_P_RENZOKU,math.random(10,19),8) end,--��������
						}
						if math.random(1,100) < 50 then--һʯ�����ͷŸ���50%
							pcall(���ܱ�[1])
						else--�����������ʩ��
							local ���ʩ�� = math.random(1,#���ܱ�)
							pcall(���ܱ�[���ʩ��])
						end
					end
					if ְҵ�� == 140 then--��
						local ���ܱ� = {
							function() ����ѡ��ӿ�(ai_index, ս��ָ��ӿ�.BATTLE_COM_P_SPIRACLESHOT,math.random(10,19),409) end,--������
							function() ����ѡ��ӿ�(ai_index, ս��ָ��ӿ�.BATTLE_COM_P_PANIC,math.random(10,19),9409) end,--���ҹ���
							function() ����ѡ��ӿ�(ai_index, ս��ָ��ӿ�.BATTLE_COM_P_GUARDBREAK,math.random(10,19),509) end,--����
						}
						if math.random(1,100) < 70 then--�������ͷŸ���70%
							pcall(���ܱ�[1])
						else--�����������ʩ��
							local ���ʩ�� = math.random(1,#���ܱ�)
							pcall(���ܱ�[���ʩ��])
						end
					end
					if ְҵ�� == 70 then--ħ
						local ���ܱ� = {
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_P_MAGIC,41,2709) end,--����
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_P_MAGIC,41,2809) end,--����
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_P_MAGIC,41,2909) end,--����
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_P_MAGIC,41,3009) end,--����
						}
						local ���ʩ�� = math.random(1,#���ܱ�)
						pcall(���ܱ�[���ʩ��])
					end
					if ְҵ�� == 60 then--��
						local ���ܱ� = {
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_P_HEAL,40,6309) end,--��ǿ��Ѫ
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_P_HEAL,math.random(20,29),6209) end,--ǿ����Ѫ
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_P_HEAL,math.random(0,9),6109) end,--��Ѫ
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_P_REVIVE,math.random(0,9),6809) end,--����
						}
						if math.random(1,100) < 70 then--��ǿ��Ѫ�ͷŸ���70%
							pcall(���ܱ�[1])
						else--�����������ʩ��
							local ���ʩ�� = math.random(1,#���ܱ�)
							pcall(���ܱ�[���ʩ��])
						end
					end
					if ְҵ�� == 130 then--��
						local ���ܱ� = {
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_P_LP_RECOVERY,40,6609) end,--��ǿ�ָ�
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_P_STATUSRECOVER,40,6709) end,--�ྻ
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_P_REVIVE,math.random(0,9),6809) end,--����
						}
						local ���ʩ�� = math.random(1,#���ܱ�)
						pcall(���ܱ�[���ʩ��])
					end
					if ְҵ�� == 80 then--��
						local ���ܱ� = {
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_P_STATUSCHANGE,41,4409) end,--��ǿ��
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_P_STATUSCHANGE,41,4509) end,--��ǿ˯
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_P_STATUSCHANGE,41,4609) end,--��ǿʯ
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_P_STATUSCHANGE,41,4709) end,--��ǿ��
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_P_STATUSCHANGE,41,4809) end,--��ǿ��
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_P_STATUSCHANGE,41,4909) end,--��ǿ��
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_P_REVERSE_TYPE,math.random(0,19),5409) end,--���Է�ת
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_P_REFLECTION_PHYSICS,math.random(0,9),5509) end,--����
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_P_INEFFECTIVE_PHYSICS,math.random(0,9),5909) end,--����
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_P_ABSORB_PHYSICS,math.random(0,9),5709) end,--����
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_P_REFLECTION_MAGIC,math.random(0,9),5609) end,--ħ��
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_P_INEFFECTIVE_MAGIC,math.random(0,9),6009) end,--ħ��
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_P_ABSORB_MAGIC,math.random(0,9),5809) end,--ħ��
						}
						if math.random(1,100) < 50 then--����Ÿ���50%
							local ���ʩ�� = math.random(1,6)
							pcall(���ܱ�[���ʩ��])
						else--�����������ʩ��
							local ���ʩ�� = math.random(7,#���ܱ�)
							pcall(���ܱ�[���ʩ��])
						end
					end
					if ְҵ�� == 150 then--��
						local ���ܱ� = {
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_P_ASSASSIN,math.random(10,19),9609) end,--��ɱ
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_P_DODGE,math.random(10,19),909) end,--����
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_ATTACKALL,math.random(10,19),10601) end,--Ӱ����--��ȷ�����techҲ��������
						}
						if Battle.GetType(battleindex) == CONST.ս��_BOSSս then--bossս������ɱ
							local ���ʩ�� = math.random(2,#���ܱ�)
							pcall(���ܱ�[���ʩ��])
						else
							if math.random(1,100) < 50 then--��ɱ����50%
								pcall(���ܱ�[1])
							else
								local ���ʩ�� = math.random(2,#���ܱ�)
								pcall(���ܱ�[���ʩ��])
							end
						end
					end
					if Char.GetData(ai_index,CONST.����_ְҵ) == 481 then--GM����
						local ���ܱ� = {
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_M_DEATH,math.random(0,19),8602) end,--���弴��--��ȷ�����techҲ��������
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_P_ASSASSIN,math.random(10,19),9609) end,--��ɱ
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_M_EARTHQUAKE,math.random(40,41),9708) end,--���֮ŭ--��ȷ�����techҲ��������
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_P_DANCE,-1,9802) end,--���
						}
						local ���ʩ�� = math.random(1,#���ܱ�)
						pcall(���ܱ�[���ʩ��])
					end
					--��2��
					--local petindex = Battle.GetPlayer(battleindex,math.fmod(i + 5,10))
					local petindex = Char.GetPet(ai_index,0)
					if petindex >= 0 then--������������ʹ�ü���
						--print('�������� = '..Char.GetData(petindex,CONST.����_����))
						local ���＼�ܱ� = {--����ʩ�ŵļ��ܣ���Ҫ���������ѧ������ܣ������޷�ʩ�ţ����10�����˲���ѧ��Ҳ������
							--function() ����ѡ��ӿ�(petindex,ս��ָ��ӿ�.BATTLE_COM_ATTACK,math.random(10,19),-1) end,--����
							--function() ����ѡ��ӿ�(petindex,ս��ָ��ӿ�.BATTLE_COM_GUARD,-1,-1) end,--����
							function() ����ѡ��ӿ�(petindex,ս��ָ��ӿ�.BATTLE_COM_P_SPECIALGARD,-1,838) end,--ʥ��
							function() ����ѡ��ӿ�(petindex,ս��ָ��ӿ�.BATTLE_COM_P_RENZOKU,math.random(10,19),38) end,--����
							function() ����ѡ��ӿ�(petindex,ս��ָ��ӿ�.BATTLE_COM_P_PARAMETER,math.random(10,19),138) end,--����
							function() ����ѡ��ӿ�(petindex,ս��ָ��ӿ�.BATTLE_COM_P_PARAMETER,math.random(10,19),338) end,--Ǭ��
							function() ����ѡ��ӿ�(petindex,ս��ָ��ӿ�.BATTLE_COM_P_MAGIC,math.random(30,39),2339) end,--ǿ����ʯħ��
							function() ����ѡ��ӿ�(petindex,ս��ָ��ӿ�.BATTLE_COM_P_MAGIC,math.random(30,39),2439) end,--ǿ������ħ��
							function() ����ѡ��ӿ�(petindex,ս��ָ��ӿ�.BATTLE_COM_P_MAGIC,math.random(30,39),2539) end,--ǿ������ħ��
							function() ����ѡ��ӿ�(petindex,ս��ָ��ӿ�.BATTLE_COM_P_MAGIC,math.random(30,39),2639) end,--ǿ������ħ��
							function() ����ѡ��ӿ�(petindex,ս��ָ��ӿ�.BATTLE_COM_M_BLOODATTACK,math.random(10,19),8138) end,--��Ѫ����
							function() ����ѡ��ӿ�(petindex,ս��ָ��ӿ�.BATTLE_COM_M_STATUSATTACK,math.random(10,19),7738) end,--ʯ������
						}
						local ���ʩ�� = math.random(1,#���＼�ܱ�)
						--print('��� = '..���ʩ��)
						pcall(���＼�ܱ�[���ʩ��])
					else--û�����aiӶ��2���չ�
						local ���ܱ� = {
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_ATTACK,10,-1) end,--����
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_GUARD,-1,-1) end,--����
							function() ����ѡ��ӿ�(ai_index,ս��ָ��ӿ�.BATTLE_COM_POSITION,-1,-1) end,--��λ�������ƶ�
						}
						local ���ʩ�� = math.random(1, #���ܱ�)
						pcall(���ܱ�[���ʩ��])
					end
					::pk�Թ�::
				end
			end
		end
	end
	if Battle.GetType(battleindex) == CONST.ս��_PVP then--PKֻ����
		for k,v in pairs(player) do
			if Char.IsPlayer(v) then
				for d,j in pairs(player) do
					if Char.IsDummy(j) then
						NLG.Say(v,j,'���޷�����pk��ֻ����·����',math.random(0,9),math.random(0,4))
					end
				end
			end
		end
	end
end

function ����ai(player,ai��,ai����,aiְҵ��ʾ,ai����,aiְҵ,aiְҵ��,aiװ��,aiװ���۸Ĳ���)
	--ְҵͳ�ƣ� ��-44 | ��-14 | ��-24 | ��-34 | ��-144 | ħ-74 | ��-64 | ��-134 | ��-84 | ��-154
	local ��_�ȼ� = Char.GetData(player,CONST.����_�ȼ�)
	local ��_���� = Char.GetData(player,CONST.����_����)
	local ��_ħ�� = Char.GetData(player,CONST.����_ħ��)
	local ��_������ = Char.GetData(player,CONST.����_����)
	local ��_������ = Char.GetData(player,CONST.����_ǿ��)
	local ��_���� = Char.GetData(player,CONST.����_�ٶ�)
	local ����� = math.random(110,130)--����110~130�������--Ȼ��ai�ο���������bp��110%~130%���ɸ���bp
	if ��_�ȼ� < ai��͵ȼ� then--�����ҵȼ�С��70��ai�ȼ�ǿ��Ϊ70����ҵȼ�����70��ai�ȼ�������˵ĵȼ���
		��_�ȼ� = ai��͵ȼ�
	end
	��_���� = ��_���� / 100 * �����
	��_ħ�� = ��_ħ�� / 100 * �����
	��_������ = ��_������ / 100 * �����
	��_������ = ��_������ / 100 * �����
	��_���� = ��_���� / 100 * �����
	if aiְҵ��ʾ == 'ħ��ʦ' then--��ʦ�����趨
		if ��_���� > 2500 then
			��_���� = 2500
		end
		��_������ = 0
		if ��_������ < 5000 then
			��_������ = 5000
		end
		if ��_ħ�� < 50000 then
			��_ħ�� = 50000
		end
	end
	if aiְҵ��ʾ == '����ʿ' or aiְҵ��ʾ == '��ʦ' or aiְҵ��ʾ == '����ʦ' then--���������趨
		��_������ = 0
		if ��_���� < 50000 then
			��_���� = 50000
		end
		if ��_ħ�� < 25000 then
			��_ħ�� = 25000
		end
	end
	local ai_index = Char.CreateDummy()--����aiӶ��
	print('--------------------------------')
	print('�ɹ���ļӶ������ţ�'..ai_index)
	��ҳ���ai��[player][0] = ��ҳ���ai��[player][0] + 1--ͳ��aiӶ������
	ai�˿�ͳ�� = ai_index
	��ҳ���ai��[player][ai��] = ai_index
	Char.SetData(ai_index, CONST.CHAR_X, Char.GetData(player, CONST.CHAR_X))
	Char.SetData(ai_index, CONST.CHAR_Y, Char.GetData(player, CONST.CHAR_Y))
	Char.SetData(ai_index, CONST.CHAR_��ͼ, Char.GetData(player, CONST.CHAR_��ͼ))
	Char.SetData(ai_index, CONST.CHAR_����, ai����)
	Char.SetData(ai_index, CONST.CHAR_��ͼ����, Char.GetData(player, CONST.CHAR_��ͼ����))
	Char.SetData(ai_index, CONST.CHAR_����, ai����)
	Char.SetData(ai_index, CONST.CHAR_ԭ��, ai����)
	Char.SetData(ai_index, CONST.CHAR_ԭʼͼ��, ai����)
	Char.SetData(ai_index, CONST.CHAR_����, ��_����)
	Char.SetData(ai_index, CONST.CHAR_����, ��_������)
	Char.SetData(ai_index, CONST.CHAR_ǿ��, ��_������)
	Char.SetData(ai_index, CONST.CHAR_�ٶ�, ��_����)
	Char.SetData(ai_index, CONST.CHAR_ħ��, ��_ħ��)
	Char.SetData(ai_index, CONST.CHAR_����, 100)
	Char.SetData(ai_index, CONST.CHAR_�ȼ�, ��_�ȼ�)
	Char.SetData(ai_index, CONST.CHAR_����, 0)--����ϵ
	Char.SetData(ai_index, CONST.����_ְҵ, aiְҵ)
	Char.SetData(ai_index, CONST.����_ְ��ID, aiְҵ��)
	Char.SetData(ai_index, CONST.����_ְ��, 3)--3ת��ʽְҵ
	local itemindex = Char.GiveItem(ai_index, aiװ��, 1)--��1��װ��
	Item.SetData(itemindex,CONST.����_�Ѽ���,1)
	Item.SetData(itemindex,CONST.����_�ȼ�,1)--װ������Ϊ1����ʡ��Ӷ���ȼ��ʹ�����
	--����ai = {��,ai����,ְҵ��ʾ,ͼ��id,job,jobrank,����id,'����Ѫ|����ħ|������|������|������|������|����ħ��|����ħ��|������|������|������|������|������|������',��ͨ�۸�}
	local װ���۸� = split(aiװ���۸Ĳ���,'|')
	for k,v in pairs(װ���۸�) do
		if v == '����' then
			װ���۸�[k] = false
		else
			װ���۸�[k] = tonumber(v)
		end
	end
	--for k,v in pairs(װ���۸�) do
	--	print(k,v)
	--end
	for ��Ŀ = 1,#װ���۸� do--��ʼ�۸�
		if װ���۸�[��Ŀ] then
			Item.SetData(itemindex,װ��������[��Ŀ],װ���۸�[��Ŀ])
		end
	end
	Item.UpItem(ai_index,-1)
	NLG.UpChar(ai_index)
	local nowitemslot = Char.GetItemSlot(ai_index, itemindex)
	--print('������Ʒλ�� = '..nowitemslot)
	local stat = false
	if aiְҵ��ʾ == '��ʿ' then
		stat = Char.MoveItem(ai_index, nowitemslot, CONST.λ��_��, -1)
	else
		stat = Char.MoveItem(ai_index, nowitemslot, CONST.λ��_����, -1)
	end
	--print('�ƶ���Ʒ = '..stat)
	print('������'..Item.GetData(itemindex,CONST.����_�Ѽ�����))
	--print('�Ƿ������ = '..Item.GetData(itemindex,CONST.����_�Ѽ���))
	--itemindex = false
	itemindex = Char.GiveItem(ai_index, math.random(9205,9240), 1)--�����ˮ��
	Item.SetData(itemindex,CONST.����_�Ѽ���,1)
	Item.UpItem(ai_index,-1)
	NLG.UpChar(ai_index)
	nowitemslot = Char.GetItemSlot(ai_index, itemindex)
	--print('������Ʒλ�� = '..nowitemslot)
	stat = Char.MoveItem(ai_index, nowitemslot, CONST.λ��_ˮ��, -1)
	--print('�ƶ���Ʒ = '..stat)
	print('ˮ����'..Item.GetData(itemindex,CONST.����_�Ѽ�����))
	--print('�Ƿ������ = '..Item.GetData(itemindex,CONST.����_�Ѽ���))
	Char.GiveItem(ai_index, 2, 100)--��������
	--print('ai���������� = '..Char.GetData(ai_index,CONST.����_������)-8)
	--print('ai������ռ������ = '..Char.ItemSlot(ai_index))
	Char.AddSkill(ai_index, 71)--����
	Char.SetSkillLevel(ai_index,0,10)
	local petindex = -1
	repeat
		petindex = Char.GivePet(ai_index, math.random(1,904))--���������
	until petindex > 0
	Char.SetData(petindex,CONST.����_�ҳ�,100)
	Char.SetData(petindex,CONST.����_�����ҳ�,100)
	Char.SetPetDepartureState(ai_index, 0, CONST.PET_STATE_ս��)
	Char.SetData(ai_index, CONST.CHAR_ս��, 0)
	Char.SetData(petindex,CONST.PET_DepartureBattleStatus, CONST.PET_STATE_ս��)
	Char.SetData(petindex,CONST.����_�ȼ�,��_�ȼ�)
	Char.SetData(petindex,CONST.CHAR_����, ��_�ȼ�*100*1.2)
	Char.SetData(petindex,CONST.CHAR_ħ��, ��_�ȼ�*100*2)
	Char.SetData(petindex,CONST.CHAR_����, ��_�ȼ�*100)
	Char.SetData(petindex,CONST.CHAR_ǿ��, ��_�ȼ�*100*0.1)
	Char.SetData(petindex,CONST.CHAR_�ٶ�, ��_�ȼ�*100*0.5)
	Char.SetData(petindex,CONST.����_������,10)
	for killslot = 0,9 do--�����������
		Pet.DelSkill(petindex,killslot)
	end
	--��������10�����ܣ���ע�����
	Pet.AddSkill(petindex, 838)--ʥ��
	Pet.AddSkill(petindex, 38)--����
	Pet.AddSkill(petindex, 138)--����
	Pet.AddSkill(petindex, 338)--Ǭ��
	Pet.AddSkill(petindex, 2339)--ǿ����ʯħ��
	Pet.AddSkill(petindex, 2439)--ǿ������ħ��
	Pet.AddSkill(petindex, 2539)--ǿ������ħ��
	Pet.AddSkill(petindex, 2639)--ǿ������ħ��
	Pet.AddSkill(petindex, 8138)--��Ѫ����
	Pet.AddSkill(petindex, 7738)--ʯ������
	Char.SetData(player,CONST.����_��ӿ���,1)
	Char.JoinParty(ai_index, player)
	NLG.UpChar(ai_index)
	NLG.UpChar(player)
	Char.SetData(ai_index, CONST.����_Ѫ, Char.GetData(ai_index, CONST.����_���Ѫ))
	Char.SetData(ai_index, CONST.����_ħ, Char.GetData(ai_index, CONST.����_���ħ))
	Char.SetData(petindex, CONST.����_Ѫ, Char.GetData(petindex, CONST.����_���Ѫ))
	Char.SetData(petindex, CONST.����_ħ, Char.GetData(petindex, CONST.����_���ħ))
	NLG.UpChar(ai_index)
	NLG.UpChar(player)
	Pet.UpPet(ai_index, petindex)
	local vital = Char.GetData(ai_index,CONST.����_����)
	local HP = Char.GetData(ai_index,CONST.����_���Ѫ)
	local magic = Char.GetData(ai_index,CONST.����_ħ��)
	local MP = Char.GetData(ai_index,CONST.����_���ħ)
	local rec = Char.GetData(ai_index,CONST.����_�ظ�)
	local atk = Char.GetData(ai_index,CONST.����_����)
	local def = Char.GetData(ai_index,CONST.����_ǿ��)
	local quk = Char.GetData(ai_index,CONST.����_�ٶ�)
	local js = Char.GetData(ai_index,CONST.����_����)
	local job = Char.GetData(ai_index,CONST.����_ְҵ)
	print('��������ai���ԣ�'..job..' ��'..vital..' ħ'..magic..' ��'..atk..' ǿ'..def..' ��'..quk..' HP'..HP..' MP'..MP..' ��'..rec..' ��'..js)--ÿ100=1��bp
	print('--------------------------------')
end

function ��ļai(player,ai��)--��ļai
	--print('------------------ai�� = '..ai��)
	if ��ҳ���ai��[player][ai��] >= 0 then
		NLG.PlaySe(player,72,0,0)
		Char.LeaveParty(��ҳ���ai��[player][ai��])
		Char.DelDummy(��ҳ���ai��[player][ai��])
		��ҳ���ai��[player][ai��] = -1
		��ҳ���ai��[player][0] = ��ҳ���ai��[player][0] - 1
	elseif ��ҳ���ai��[player][0] > 3 then
		NLG.ShowWindowTalked(player,ai_npc,CONST.����_��Ϣ��,CONST.��ť_��һҳ,player+404404,'@c��CNħ�� AI��Ӷ��ϵͳ��\\n\\n\\n\\n���Ѿ��ٻ���4λС����ˣ��������ٻ��ˡ�')
	elseif ai�˿�ͳ�� > ai�˿����� then
		NLG.ShowWindowTalked(player,ai_npc,CONST.����_��Ϣ��,CONST.��ť_��һҳ,player+404404,'@c��CNħ�� AI��Ӷ��ϵͳ��\\n\\n\\n\\n��ǰ��·�˿ڱ������޷����Ӷ���ˡ�')
	elseif Char.PartyNum(player) >= 5 then
		--print('�������� = '..Char.PartyNum(player))
		NLG.ShowWindowTalked(player,ai_npc,CONST.����_��Ϣ��,CONST.��ť_��һҳ,player+404404,'@c��CNħ�� AI��Ӷ��ϵͳ��\\n\\n\\n\\n��Ķ�������������')
	elseif ��ҳ���ai��[player][ai��] == -1 then
		����ai(player,ai_list[ai��][1],ai_list[ai��][2],ai_list[ai��][3],ai_list[ai��][4],ai_list[ai��][5],ai_list[ai��][6],ai_list[ai��][7],ai_list[ai��][8])
	end
end

function shuzipanduan(data)--���ֻ��ı��ж�
	local wenben = data
	local shuzi = data
	if tonumber(data) == nil then
		return tostring(wenben)
	else
		return tonumber(shuzi)
	end
end

function left(str,len)--����
    local char = ' ' -- ���ո�
	if len-#str >= 0 then
		local padding = string.rep(char,len-#str)
		return str..padding
	else
		local text = '����̫�����޸�'
		local padding = string.rep(char,len-#text)
		return text..padding
	end
end

function split(str,split_char)--�ָ�ո����ݵ�table
    local sub_str_tab = {}
    while (true) do
		local pos = string.find(str, split_char)
		if (not pos) then
			sub_str_tab[#sub_str_tab + 1] = str
			break
		end
		local sub_str = string.sub(str, 1, pos - 1)
		sub_str_tab[#sub_str_tab + 1] = sub_str
		str = string.sub(str, pos + 1, #str)
    end
    return sub_str_tab
end

--ж��ģ�鹳��
function ����Ӷ��Module:onUnload()
	self:logInfo('unload')
end

return ����Ӷ��Module
