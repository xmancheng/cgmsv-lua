-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
--ahsin���ģ�����GM����
--�汾��20241116
--��lua����������m�е��¿����
--�׷���̳ www.cnmlb.com ��ȡ���°汾

--���ڹ��ܱȽϷḻ����ѷ������ѡ�����bվ����ޡ�һ�����������ְɣ�
--https://space.bilibili.com/21127109
--qqȺ��85199642

--��luaֻ֧��cgmsv+�¿�ܣ���Ȼ100%�ܲ�����
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

--ģ����
local ahsin_gm_tool_ultraModule = ModuleBase:createModule('ahsin_gm_tool_ultra')

--����ģ�鹳��
function ahsin_gm_tool_ultraModule:onLoad()
	self:logInfo('load')
	gmnpc = self:NPC_createNormal('���gm',103010,{x=18,y=18,mapType=0,map=777,direction=6})--������npc�����û��777��ͼ���Լ���һ��
	self:NPC_regWindowTalkedEvent(gmnpc,Func.bind(self.egm,self))--gm����npc����
	self:regCallback('CharActionEvent',Func.bind(self.playerpose,self))--��Ҷ�������
	self:regCallback('TalkEvent',Func.bind(self.wanjiashuohua,self))--���˵������
	--����ΪС���ݹ��ܴ���
	darkroomnpc = self:NPC_createNormal('���ר��Ů�͹ܼ�',14592,{x=53,y=46,mapType=0,map=0,direction=6})--С���ݹܼ�npc��վ�ڵ�ͼ0������Ҫ�Լ���
	self:NPC_regTalkedEvent(darkroomnpc,Func.bind(self.face2npc,self))--����С���ݹܼ�npc����
	self:NPC_regWindowTalkedEvent(darkroomnpc,Func.bind(self.face2npc2,self))--С���ݹܼ�npc���ڰ�ť����
	self:regCallback('LoginEvent',Func.bind(self.jinru,self))--����ʱ����
	self:regCallback('AfterWarpEvent',Func.bind(self.chuansonghou,self))--���ͺ󴥷�
	self:regCallback('jishiqi',Func.bind(self.jishiqi,self))--�ӳټ�ʱ�������afterwarp��fw
end

-------------------------------------------------------------------------------------
-----------����������Լ���
local yzmkg = 0--�Ƿ���������֤�룬1=�� 0=�أ�������Բ��ģ��ɿش��ڲ˵��ɿ��ƿ���
local warpmax = 15--ÿ�����ۼƵ�����ʱ��������֤�룬����
local yzmcw = 5--������֤���������������Σ���С����
local bsryzmcs = 60--��������֤�볬�������룬��С����
local xiaoheiwu = 0--С���ݵ�ͼ����ͼ���0=������Լ�diy���ǵ������С���ݹܼ�npcλ��ҲҪ��
local xhwx = 43--С����x����
local xhwy = 46--С����y����
local gmzs = 13--gmͨ�����ƺ������ڣ�����13=���֣���ctrl+4����/44���棬�Լ�diy
local gmzl1 = "/g"--gm��������ָ��1����ctrl+4���棬�Լ�diy
local gmzl2 = "��g"--gm��������ָ��2����ctrl+4���棬�Լ�diy
local amgm = "[woshigm]"--���ٻ��gm����
local enemymax = 315149--����������data/enemy.txt���жϣ���д����enemy��š������ڲ�ѯ�������enemyid

--��֤��ר��--����diy��Խ��Խ��
local yzmpp = {
{'��','0','ling','��','��','�R','O','o','LING','lING'},
{'һ','1','yi','Ҽ','��','��','I','��','YI','yI'},
{'��','2','er','�E','�r','��','II','��','ER','eR'},
{'��','3','san','��','��','��','III','��','SAN','sAN'},
{'��','4','si','��','�','��','IV','��','SI','sI'},
{'��','5','wu','��','��','��','V','��','WU','wU'},
{'��','6','liu','�','��','��','VI','��','LIU','lIU'},
{'��','7','qi','��','��','��','VII','��','QI','qI'},
{'��','8','ba','��','�X','��','VIII','��','BA','bA'},
{'��','9','jiu','��','�C','��','IX','��','JIU','jIU'},
}
local yzmlie = 10--��֤������
-----------����������Լ���
-------------------------------------------------------------------------------------
local players = {}--ȫ���������index��
local jishi = {}--��ʼ����ʱ��
local warptimes = {}--���ͼ������������ã��κδ��ͷ�ʽ�����ȥ
local yzm = {}--��֤��ר�ñ�
local yzmer = {}--��֤������
local bsryzm = {}--��������֤�뵹��ʱ
local nowpage = {}--������ѯר��
local nownum = 0--ͼ������ɫ�鿴��ר��
local nowaudio = 0--���ֲ���ר��
local sdkg = 0--gmר�ã�������·����
--require("./modules/62")--����62����

----------����ʱ��������һ�Σ�enemyid����ϵͳ
local pet_enemyindex = {}--����enemytxt index��
local pet_enemyid = {}--����enemyid��
for i = 1,enemymax do--����data/enemy.txt enemyid��� 1~999999 ��lua
	pet_enemyindex[i] = Data.EnemyGetDataIndex(i) or -1--m��Ĭ��callback --��ȡenemytxt index
	if pet_enemyindex[i] > -1 then--�ų���enemytxt index
		pet_enemyid[i] = Data.EnemyGetData(pet_enemyindex[i],1) or "��ѯʧ��"--ͨ��enemytxt index��ȡenemybaseid ���浽enemyid�� --����0=enemyid ����1=enemybaseid
	end
end

function ck_enemyid(enemybaseid)--enemyid����ϵͳ
	for k,v in pairs(pet_enemyid) do--v=enemybaseid k=enemyid 
		if tonumber(v) == tonumber(enemybaseid) then
			return k
		end
	end
end
----------����ϵͳ����

function ahsin_gm_tool_ultraModule:playerpose(player,aid)--ctrl+4��������
	player = tonumber(player)
	if Char.GetData(player,%����_GM%) == 0 then--��gm������
		return
	end
	if aid == gmzs then--��ɫ����
		showwindow(player)
	end
end

function showwindow(player)--��ʾGM����������
	local neirong = "@c1\\n��ahsin�ľ��OGM���ߡ�"
	.."\\n"
	.."\\n�@ȡ�ھ�����б�"
	.."\\n�l����"
	.."\\n�o�|��"
	.."\\n����w��"
	.."\\n��Ҹ߼�����"
	.."\\n�����ԃ"
	.."\\n�_�l�߹���"
	.."\\n2024-11-16�� | QȺ85199642"
	NLG.ShowWindowTalked(player,gmnpc,%����_ѡ���%,%��ť_�ر�%,player+1888,neirong)
end

function ahsin_gm_tool_ultraModule:wanjiashuohua(player,msg)--gm˵����������
	local amgm2 = "[Char.SetGM]"
	if msg == gmzl1 or msg == gmzl2 then
		if Char.GetData(player,%����_GM%) == 1 then--��gm������
			showwindow(player)
		end
	end
	if msg == amgm or msg == amgm2 then
		if Char.GetData(player,%����_GM%) == 0 then--�����Ҳ���gm���͸�gmȨ��
			Char.SetData(player,%����_GM%,1)
			NLG.SystemMessage(player,"���ѳ�Ϊgm")
			NLG.UpChar(player)--ˢ��һ�º�̨
		else--�������Ѿ���gm�����ջ�gmȨ��
			Char.SetData(player,%����_GM%,0)
			NLG.SystemMessage(player,"���Ѿ�����gm��")
			NLG.UpChar(player)--ˢ��һ�º�̨
		end
	end
	return 1
end

function ahsin_gm_tool_ultraModule:egm(gmnpc,player,seqno,select,data)--�������ѡ���

	seqno = tonumber(seqno)
	select = tonumber(select)
	data = shuzipanduan(data)
	--print("select��"..select)
	--print("data��"..data)
	--print("seqno��"..seqno)

	if seqno == player+1888 and data == 2 then--����б�1������
		local neirong = "4@c\\n���@ȡ�ھ�����б�"
		.."\\n"
		.."\\ngmsv���_���Լ��[���У�����ͬ�rݔ���б�"
		.."\\n"
		.."\\n"
		.."\\nȫ���ھ�����б�"
		.."\\n"
		.."\\n��ǰ�؈D�ھ�����б�"
		NLG.ShowWindowTalked(player,gmnpc,%����_ѡ���%,%��ť_��ȡ��%,player+2888,neirong)
	elseif seqno == player+1888 and data == 9 then--��ǰ��ͼ��������б�
		showwindow(player)
	elseif seqno == player+2888 and data == 2 then--ȫ����������б�
		liebiao(player,1)
	elseif seqno == player+2888 and data == 4 then--��ǰ��ͼ��������б�
		liebiao(player,2)
	elseif seqno == player+2888 and select == 16 then--����б�����һҳ
		showwindow(player)
	elseif seqno == player+1888 and data == 3 then--ȫ���������봰��
		local neirong = "@c\\n\\n���l�͹��桿"
		.."\\n\\n\\n\\nՈݔ�빫�����"
		NLG.ShowWindowTalked(player,gmnpc,%����_�����%,19,player+3888,neirong)
	elseif seqno == player+3888 and select == 1 then--ȫ�����淢��
		NLG.SystemMessage(-1,"GM���棺"..data)
	elseif seqno == player+3888 and select == 16 then--ȫ�����淢��������һҳ
		showwindow(player)
	elseif seqno == player+1888 and data == 4 then--������
		local neirong = "4@c\\n\\n���o�|����"
		.."\\n\\n"
		.."\\n����"
		.."\\n����"
		.."\\n�X"
		.."\\n���"
		NLG.ShowWindowTalked(player,gmnpc,%����_ѡ���%,%��ť_��ȡ��%,player+4888,neirong)
	elseif seqno == player+4888 and select == 16 then--������������һҳ
		showwindow(player)
	elseif seqno == player+4888 and data == 1 then--������
		local neirong = "@c���o���ߡ�"
		.."\\n"
		.."\\nՈݔ�� ��̖�ո�itemid�ո���"
		.."\\n����ahsin�l��1��Q�����ahsin 18658 1"
		.."\\n����ȫ���ھ���Ұl��1��Q�����all 18658 1"
		.."\\n\\n$2Ո�]�⣺ϵ�y�����Д���ұ�����B��"
		.."\\n$2Ո��ǰ׌������Мʂ��λ��"
		NLG.ShowWindowTalked(player,gmnpc,%����_�����%,19,player+5888,neirong)
	elseif seqno == player+5888 and select == 16 then--�����ߣ�����һҳ
		showwindow(player)
	elseif seqno == player+5888 and select == 1 then--�����߿�ʼ
		local giveitem = split(data," ")--�ָ�����
		if giveitem[1] == nil or giveitem[2] == nil or giveitem[3] == nil then
			NLG.Say(player,-1,"ݔ���ʽ�e�`��Ո���Lԇ��",6)
		else
			--NLG.SystemMessage(player,giveitem[1])
			--NLG.SystemMessage(player,giveitem[2])
			--NLG.SystemMessage(player,giveitem[3])
			geidongxi(1,player,giveitem[1],giveitem[2],giveitem[3])--��ʼ��
		end
	elseif seqno == player+4888 and data == 2 then--�����￪ʼ
		local neirong = "@c���o���"
		.."\\n"
		.."\\nՈݔ�� ��̖�ո�enemyid"
		.."\\n����ahsin�l����ؐ��˹��ahsin 911"
		.."\\n����ȫ���ھ���Ұl����ؐ��˹��all 911"
		.."\\n\\n$2Ո�]�⣺ϵ�y�����Д���Ҍ���ڠ�B��"
		.."\\n$2Ո��ǰ׌������Мʂ��λ��"
		NLG.ShowWindowTalked(player,gmnpc,%����_�����%,19,player+6888,neirong)
	elseif seqno == player+6888 and select == 16 then--���������һҳ
		showwindow(player)
	elseif seqno == player+6888 and select == 1 then--�����￪ʼ
		local givepet = split(data," ")--�ָ�����
		if givepet[1] == nil or givepet[2] == nil then
			NLG.Say(player,-1,"ݔ���ʽ�e�`��Ո���Lԇ��",6)
		else
			geidongxi(2,player,givepet[1],givepet[2])--��ʼ��
		end
	elseif seqno == player+4888 and data == 3 then--�����
		local neirong = "@c���o�X��"
		.."\\n"
		.."\\nՈݔ�� ��̖�ո���"
		.."\\n����ahsin�l��50�f��ahsin 500000"
		.."\\n����ȫ���ھ���Ұl��50�f��all 500000"
		.."\\n֧��ؓ�����ɿ۳�������ϵ��X��"
		.."\\n\\n$2Ո�]�⣺ϵ�y�����Д�����X����B��"
		.."\\n$2Ո��ǰ׌������Мʂ��λ��"
		NLG.ShowWindowTalked(player,gmnpc,%����_�����%,19,player+7888,neirong)
	elseif seqno == player+7888 and select == 16 then--��Ǯ������һҳ
		showwindow(player)
	elseif seqno == player+7888 and select == 1 then--��Ǯ��ʼ
		local givegold = split(data," ")--�ָ�����
		if givegold[1] == nil or givegold[2] == nil then
			NLG.Say(player,-1,"ݔ���ʽ�e�`��Ո���Lԇ��",6)
		else
			geidongxi(3,player,givegold[1],givegold[2])--��ʼ��
		end
	elseif seqno == player+4888 and data == 4 then--�����鿪ʼ
		local neirong = "@c���o��򞡿"
		.."\\n"
		.."\\nՈݔ�� ��̖�ո���"
		.."\\n����ahsin�l��50�f��򞣺ahsin 500000"
		.."\\n����ȫ���ھ���Ұl��50�f��򞣺all 500000"
		.."\\n֧��ؓ�����ɿ۳���ҽ�򞣬���ȼ��������͡�"
		.."\\ncgmsv����㷨�c�n����򞲻ͬ�����wȺ�Y����"
		.."\\n$2Ո�]�⣺ϵ�y�����Д���ҽ���B��"
		.."\\n$2�o̫����߿�̫����ˆ��}�����ޔ����졣"
		NLG.ShowWindowTalked(player,gmnpc,%����_�����%,19,player+8888,neirong)
	elseif seqno == player+8888 and select == 16 then--�����飬����һҳ
		showwindow(player)
	elseif seqno == player+8888 and select == 1 then--�����鿪ʼ
		local giveexp = split(data," ")--�ָ�����
		if giveexp[1] == nil or giveexp[2] == nil then
			NLG.Say(player,-1,"ݔ���ʽ�e�`��Ո���Lԇ��",6)
		else
			geidongxi(4,player,giveexp[1],giveexp[2])--��ʼ��
		end
	elseif seqno == player+1888 and data == 5 then--�ɿ�
		local neirong = "2@c\\n������w�ء�"
		.."\\n"
		.."\\n�w�������߅"
		.."\\n������ن������@�e"
		.."\\n�Ѯ�ǰ�؈D�ھ�����ن������@�e"
		.."\\n��ȫ���ھ�����ن������@�e"
		.."\\n"
		.."\\n�Զ��x����"
		.."\\n������C�a�_�P����C��ͨ�^���˕���С����"
		.."\\n�������ȥС����"
		NLG.ShowWindowTalked(player,gmnpc,%����_ѡ���%,%��ť_��ȡ��%,player+9888,neirong)
	elseif seqno == player+9888 and select == 16 then--�ɿأ�����һҳ
		showwindow(player)
	elseif seqno == player+9888 and data == 1 then--�������
		local neirong = "@c���w�������߅��"
		.."\\n\\n\\n"
		.."\\nՈݔ�� Ŀ������~̖"
		NLG.ShowWindowTalked(player,gmnpc,%����_�����%,19,player+10888,neirong)
	elseif seqno == player+10888 and select == 16 then--������ң�����һҳ
		showwindow(player)
	elseif seqno == player+10888 and select == 1 then--������ҿ�ʼ
		local warpto = split(data," ")--�ָ�����
		if warpto[1] == nil then
			NLG.Say(player,-1,"ݔ���ʽ�e�`��Ո���Lԇ��",6)
		else
			fei(1,player,warpto[1])--��ʼ��
		end
	elseif seqno == player+9888 and data == 7 then--�ɿأ�����������֤��
		if yzmkg == 1 then
			yzmkg = 0
			NLG.SystemMessage(player,'������C�aϵ�y�����P�]��')
		else
			yzmkg = 1
			NLG.SystemMessage(player,'������C�aϵ�y�����_����')
		end
	elseif seqno == player+9888 and data == 2 then--�ٻ����
		local neirong = "@c���ن���ҵ����@߅��"
		.."\\n\\n\\n"
		.."\\nՈݔ�� ���ن���Ҏ�̖"
		NLG.ShowWindowTalked(player,gmnpc,%����_�����%,19,player+11888,neirong)
	elseif seqno == player+11888 and select == 16 then--�ٻ���ң�����һҳ
		showwindow(player)
	elseif seqno == player+11888 and select == 1 then--�ٻ���ҿ�ʼ
		local warpf = split(data," ")--�ָ�����
		if warpf[1] == nil then
			NLG.Say(player,-1,"ݔ���ʽ�e�`��Ո���Lԇ��",6)
		else
			fei(2,player,warpf[1])--��ʼ�ٻ�
		end
	elseif seqno == player+9888 and data == 6 then--�����
		local neirong = "@c���Զ��x�����_ʼ��"
		.."\\n\\n"
		.."\\nՈݔ�� Ŀ�ĵ�"
		.."\\n\\n����͵����m�ǣ�ݔ�룺0 1000 242 88"
		NLG.ShowWindowTalked(player,gmnpc,%����_�����%,19,player+12888,neirong)
	elseif seqno == player+12888 and select == 16 then--����ɣ�����һҳ
		showwindow(player)
	elseif seqno == player+12888 and select == 1 then--����ɿ�ʼ
		local selfwarp = split(data," ")--�ָ�����
		if selfwarp[1] == nil or selfwarp[2] == nil or selfwarp[3] == nil or selfwarp[4] == nil then
			NLG.Say(player,-1,"ݔ���ʽ�e�`��Ո���Lԇ��",6)
		else
			fei(3,player,"none",selfwarp[1],selfwarp[2],selfwarp[3],selfwarp[4])--��ʼ�����
		end
	elseif seqno == player+1888 and data == 6 then--��ҿ���
		local neirong = "1@c\\n����ҿ��ơ�"
		.."\\n\\n"
		.."\\n�߳�ָ�����"
		.."\\n\\n�߳�ȫ����ң��Լ�����"
		.."\\n\\n��̖"
		.."\\n\\n���"
		NLG.ShowWindowTalked(player,gmnpc,%����_ѡ���%,%��ť_��ȡ��%,player+13888,neirong)
	elseif seqno == player+13888 and select == 16 then--��ҿ��ƣ�����һҳ
		showwindow(player)
	elseif seqno == player+13888 and data == 5 then--�߳�ȫ�����
		players = NLG.GetPlayer()--��ȡ������ұ�
		for k, v in pairs(players) do
			if v ~= player then
				NLG.DropPlayer(v)
			end
		end
		NLG.SystemMessage(player,"ȫ��������߳���")
	elseif seqno == player+13888 and data == 3 then--�߳�ָ�����
		local neirong = "@c���߳�ָ����ҡ�"
		.."\\n\\n\\n"
		.."\\nՈݔ�� ָ����Ҏ�̖"
		NLG.ShowWindowTalked(player,gmnpc,%����_�����%,19,player+14888,neirong)
	elseif seqno == player+14888 and select == 16 then--�߳�ָ����ң�����һҳ
		showwindow(player)
	elseif seqno == player+14888 and select == 1 then--�߳�ָ����ҿ�ʼ
		local badid = split(data," ")--�ָ�����
		if badid[1] == nil then
			NLG.Say(player,-1,"ݔ���ʽ�e�`��Ո���Lԇ��",6)
		else
			wanjiakz(1,player,badid[1])--��ʼ�������
		end
	elseif seqno == player+13888 and data == 7 then--���
		local neirong = "@c�������Ҏ�̖��"
		.."\\n\\n\\n"
		.."\\nՈݔ�� ָ����Ҏ�̖"
		NLG.ShowWindowTalked(player,gmnpc,%����_�����%,19,player+15888,neirong)
	elseif seqno == player+15888 and select == 16 then--��ţ�����һҳ
		showwindow(player)
	elseif seqno == player+15888 and select == 1 then--��ſ�ʼ
		local badid = split(data," ")--�ָ�����
		if badid[1] == nil then
			NLG.Say(player,-1,"ݔ���ʽ�e�`��Ո���Lԇ��",6)
		else
			wanjiakz(2,player,badid[1])--��ʼ�������
		end
	elseif seqno == player+13888 and data == 9 then--���
		local neirong = "@c����������Ҏ�̖��"
		.."\\n\\n\\n"
		.."\\nՈݔ�� ָ����Ҏ�̖"
		NLG.ShowWindowTalked(player,gmnpc,%����_�����%,19,player+16888,neirong)
	elseif seqno == player+16888 and select == 16 then--��⣬����һҳ
		showwindow(player)
	elseif seqno == player+16888 and select == 1 then--��⿪ʼ
		local badid = split(data," ")--�ָ�����
		if badid[1] == nil then
			NLG.Say(player,-1,"ݔ���ʽ�e�`��Ո���Lԇ��",6)
		else
			wanjiakz(3,player,badid[1])--��ʼ�������
		end
	elseif seqno == player+1888 and data == 7 then--��ѯ����
		local neirong = "1@c\\n����ԃ���ܡ�"
		.."\\n\\n"
		.."\\n��ԃ��ǰ�Č���"
		.."\\n��ԃ�����"
		.."\\n��ԃ��Ʒ��"
		.."\\n"
		.."\\n�h����ǰ�����دB�r֔��������"--δ��ȫ���ԣ����ܳ����ɾ��ʧ�ܣ������ȡ����Ȩ������������ճ��ﱳ��
		.."\\n�@ȡ��ǰ�������Йࣨ�دB�r֔��������"
		NLG.ShowWindowTalked(player,gmnpc,%����_ѡ���%,%��ť_��ȡ��%,player+26888,neirong)
	elseif seqno == player+26888 and data == 7 then--ɾ����ǰ����
		faceto(4,player)
	elseif seqno == player+26888 and data == 8 then--��ȡ��ǰ��������Ȩ
		faceto(8,player)
	elseif seqno == player+26888 and data == 3 then--��ԃ��ǰ����
		faceto(nil,player)
		--[[
		local neirong = "6@c\\n����ѯ��ǰ�Ķ���"
		.."\\n\\n"
		.."\\n$2Ŀǰֻ֧���ˡ��裬ѡ�������bug��"
		.."\\n������Ŀ�꣬Ȼ��ѡ��"
		.."\\n"
		.."\\n��ѯ����ǰ�����"
		.."\\n��ѯ����ǰ�����"
		NLG.ShowWindowTalked(player,gmnpc,%����_ѡ���%,%��ť_��ȡ��%,player+17888,neirong)
	elseif seqno == player+17888 and select == 16 then--��ѯ������һҳ
		showwindow(player)
	elseif seqno == player+17888 and data == 1 then--��ѯ��
		faceto(1,player)
	elseif seqno == player+17888 and data == 1 then--��ѯ��
		faceto(2,player)
	]]
	elseif seqno == player+26888 and data == 4 then--��ѯ������
		chaxun(player)--��ѯ������
	elseif seqno == player+26888 and select == 16 then--��ѯ���ܷ���
		showwindow(player)
	elseif seqno == player+27888 and select == 16 then--��ѯ���ܷ���
		showwindow(player)
	elseif seqno == player+28888 and select == 16 then--��ѯ���ܷ���
		showwindow(player)
	elseif seqno == player+9888 and data == 3 then--�ٻ���ǰ��ͼ�������
		fei(4,player)--��ʼ��
	elseif seqno == player+9888 and data == 4 then--�ٻ�ȫ���������
		fei(5,player)--��ʼ��
	elseif seqno == player+9888 and data == 8 then--�����ȥС����
		local neirong = "@c��С���ݹ��ܡ�"
		.."\\n"
		.."\\nՈݔ�� ָ����Ҏ�̖�ո���]�씵"
		.."\\n"
		.."\\n����]һ�죺ahsin 1"
		.."\\n�������]��ahsin 0"
		.."\\n"
		.."\\n$2֧��С���c��һС�r�s0.042�����켴0.5��"
		.."\\n$2�씵�����B�ӣ�ֻ�����w��"
		NLG.ShowWindowTalked(player,gmnpc,%����_�����%,19,player+18888,neirong)
	elseif seqno == player+18888 and select == 16 then--С���ݣ�����һҳ
		showwindow(player)
	elseif seqno == player+18888 and select == 1 then--С���ݿ�ʼ
		local blockwanjia = split(data," ")--�ָ�����
		blockwanjia[2] = blockwanjia[2] or 0
		if blockwanjia[1] == nil then
			NLG.Say(player,-1,"ݔ���ʽ�e�`��Ո���Lԇ��",6)
		else
			fei(6,player,blockwanjia[1],blockwanjia[2])--��ʼ��
		end
	elseif data == 8 and seqno == player+1888 then--�����߹���
		local neirong = "1\\n@c���_�l�߹��� - ���@�Y�����ֶ��"
		.."\\n"
		.."\\nGM��������·�_�P��3����"--̫����ص�ͼʱ��Դ����Լ�diy
		.."\\n�D�n�鿴"
		.."\\n����鿴"
		.."\\n�ɫ�鿴"
		.."\\n�����yԇ"
		.."\\n������Լ����������b����⣩��"
		.."\\n������Լ�����ڡ�"
		.."\\n������Լ��������"
		NLG.ShowWindowTalked(player,gmnpc,%����_ѡ���%,%��ť_��ȡ��%,player+19888,neirong)
	elseif seqno == player+19888 and select == 16 then--�����߹��ߣ�����һҳ
		showwindow(player)
	elseif data == 2 and seqno == player+19888 then--GM������·
		if sdkg == 0 then
			sdkg = 1
			Char.SetData(player,CONST.����_����,300)--3����
			NLG.UpChar(player)
			NLG.SystemMessage(player,'GM������·300%���_����')
		else
			sdkg = 0
			Char.SetData(player,CONST.����_����,100)--ԭ��
			NLG.UpChar(player)
			NLG.SystemMessage(player,'GM������·���P�]��')
		end
	elseif data == 3 and seqno == player+19888 then--ͼ���鿴
		local neirong = "@c���D�n�鿴�����@ʾ�t�ա�"
		.."\\n\\n\\n\\n\\n"
		.."\\n\\n\\nݔ��D�n��̖���_ʼ�鿴��"
		NLG.ShowWindowTalked(player,gmnpc,%����_�����%,3,player+20888,neirong)
	elseif select == 1 and seqno == player+20888 then--ͼ���鿴��������
		if tonumber(data) ~= nil then
			nownum = data
			local neirong = "@c���D�n�鿴�����@ʾ�t�ա�"
			.."\\n��ǰ��̖"..data.."\\n@g,"..data.."@"
			.."\\n\\n\\n\\n\\n\\n�^�mݔ�뾎̖�鿴����퓲鿴�R���D�n��"
			NLG.ShowWindowTalked(player,gmnpc,%����_�����%,51,player+20888,neirong)
		else
			NLG.ShowWindowTalked(player,gmnpc,%����_�����%,3,player+20888,"@c���D�n�鿴�����@ʾ�t�ա�\\n\\n\\n\\n\\n\\n\\n\\n$2��ݔ��ă��ݲ����_��Ոݔ�뼃���־�̖��")
		end
	elseif select == 2 and seqno == player+20888 then--ͼ���鿴ȡ������һҳ
		showwindow(player)
	elseif seqno == player+20888 and select == 16 then--ͼ���鿴������һҳ
		nownum = nownum - 1
		local neirong = "@c���D�n�鿴�����@ʾ�t�ա�"
		.."\\n��ǰ��̖"..nownum.."\\n@g,"..nownum.."@"
		.."\\n\\n\\n\\n\\n\\n�^�mݔ�뾎̖�鿴����퓲鿴�R���D�n��"
		NLG.ShowWindowTalked(player,gmnpc,%����_�����%,51,player+20888,neirong)
	elseif seqno == player+20888 and select == 32 then--ͼ���鿴������һҳ
		nownum = nownum + 1
		local neirong = "@c���D�n�鿴�����@ʾ�t�ա�"
		.."\\n��ǰ��̖"..nownum.."\\n@g,"..nownum.."@"
		.."\\n\\n\\n\\n\\n\\n�^�mݔ�뾎̖�鿴����퓲鿴�R���D�n��"
		NLG.ShowWindowTalked(player,gmnpc,%����_�����%,51,player+20888,neirong)
	elseif data == 4 and seqno == player+19888 then--����鿴
		local neirong = "@c������鿴��"
		.."\\n\\n"
		.."\\n�I0��   ��1�|��   �|2�J"
		.."\\n"
		.."\\n��7����         �|��3��"
		.."\\n"
		.."\\n�L6��   ��5����   ��4�K"
		NLG.ShowWindowTalked(player,gmnpc,%����_��Ϣ��%,%��ť_��ȡ��%,player+21888,neirong)
	elseif seqno == player+21888 and select == 16 then--�����߹��ߣ�����һҳ
		showwindow(player)
	elseif data == 5 and seqno == player+19888 then--��ɫ�鿴
		nownum = 1
		local neirong = "@c���ɫ�鿴��"
		.."\\n\\n��ǰ��"..nownum.."�"
		.."\\n\\n0~9����A�ɫ�����£�"
		.."\\n\\n   $0��0 $1��1 $2��2 $3��3 $4��4 $5��5 $6��6 $7��7 $8��8 $9��9"
		.."\\n\\n\\n��퓲鿴С����cg֧�ֵ��ɫ"
		NLG.ShowWindowTalked(player,gmnpc,%����_��Ϣ��%,%��ť_��ȡ��%,player+22888,neirong)
	elseif seqno == player+22888 and select == 2 then--�����߹��ߣ�����һҳ
		showwindow(player)
	elseif seqno == player+22888 and select == 16 then--��ɫ�鿴������һҳ
		if nownum -1  <= 1 then
			nownum = 1
			local neirong = "@c���ɫ�鿴��"
			.."\\n\\n��ǰ��"..nownum.."�"
			.."\\n\\n0~9����A�ɫ�����£�"
			.."\\n\\n   $0��0 $1��1 $2��2 $3��3 $4��4 $5��5 $6��6 $7��7 $8��8 $9��9"
			.."\\n\\n\\n��퓲鿴С����cg֧�ֵ��ɫ"
			NLG.ShowWindowTalked(player,gmnpc,%����_��Ϣ��%,%��ť_��ȡ��%,player+22888,neirong)
			showcolor(player,nownum)
		else
			nownum = nownum - 1
			local neirong = "@c���ɫ�鿴��"
			.."\\n\\n��ǰ��"..nownum.."�"
			.."\\n\\n0~9����A�ɫ�����£�"
			.."\\n\\n   $0��0 $1��1 $2��2 $3��3 $4��4 $5��5 $6��6 $7��7 $8��8 $9��9"
			.."\\n\\n\\n��퓲鿴С����cg֧�ֵ��ɫ"
			NLG.ShowWindowTalked(player,gmnpc,%����_��Ϣ��%,%��ť_����ȡ��%,player+22888,neirong)
			showcolor(player,nownum)
		end
	elseif seqno == player+22888 and select == 32 then--��ɫ�鿴������һҳ
		if nownum +1 >= 4 then
			nownum = 4
			local neirong = "@c���ɫ�鿴��"
			.."\\n\\n��ǰ��"..nownum.."�"
			.."\\n\\n0~9����A�ɫ�����£�"
			.."\\n\\n   $0��0 $1��1 $2��2 $3��3 $4��4 $5��5 $6��6 $7��7 $8��8 $9��9"
			.."\\n\\n\\n��퓲鿴С����cg֧�ֵ��ɫ"
			NLG.ShowWindowTalked(player,gmnpc,%����_��Ϣ��%,%��ť_��ȡ��%,player+22888,neirong)
			showcolor(player,nownum)
		else
			nownum = nownum + 1
			local neirong = "@c���ɫ�鿴��"
			.."\\n\\n��ǰ��"..nownum.."�"
			.."\\n\\n0~9����A�ɫ�����£�"
			.."\\n\\n   $0��0 $1��1 $2��2 $3��3 $4��4 $5��5 $6��6 $7��7 $8��8 $9��9"
			.."\\n\\n\\n��퓲鿴С����cg֧�ֵ��ɫ"
			NLG.ShowWindowTalked(player,gmnpc,%����_��Ϣ��%,%��ť_����ȡ��%,player+22888,neirong)
			showcolor(player,nownum)
		end
	elseif data == 6 and seqno == player+19888 then--���ֲ���
		NLG.PlaySe(player,nowaudio,0,0)
		local neirong = '@c�������yԇ��'
		..'\\n\\n��ǰ���ţ� '..nowaudio..' ̖����'
		.."\\n\\n\\n$4Ոݔ��0���ϼ����ӣ��]�������̖��ݔ���e�`��$0"
		.."\\n\\n\\n��퓡���ݔ�뾎̖���Lԇ����������"
		NLG.ShowWindowTalked(player,gmnpc,%����_�����%,51,player+29888,neirong)
	elseif select == 16 and seqno == player+29888 then--���ֲ�����һ��
		if nowaudio > 0 then
			nowaudio = nowaudio - 1
		end
		NLG.PlaySe(player,nowaudio,0,0)
		local neirong = '@c�������yԇ��'
		..'\\n\\n��ǰ���ţ� '..nowaudio..' ̖����'
		.."\\n\\n\\n$4Ոݔ��0���ϼ����ӣ��]�������̖��ݔ���e�`��$0"
		.."\\n\\n\\n��퓡���ݔ�뾎̖���Lԇ����������"
		NLG.ShowWindowTalked(player,gmnpc,%����_�����%,51,player+29888,neirong)
	elseif select == 32 and seqno == player+29888 then--���ֲ�����һ��
			nowaudio = nowaudio + 1
		NLG.PlaySe(player,nowaudio,0,0)
		local neirong = '@c�������yԇ��'
		..'\\n\\n��ǰ���ţ� '..nowaudio..' ̖����'
		.."\\n\\n\\n$4Ոݔ��0���ϼ����ӣ��]�������̖��ݔ���e�`��$0"
		.."\\n\\n\\n��퓡���ݔ�뾎̖���Lԇ����������"
		NLG.ShowWindowTalked(player,gmnpc,%����_�����%,51,player+29888,neirong)
	elseif select == 1 and seqno == player+29888 then--���ֲ��ԣ�ָ����Ų���
		if tonumber(data) >= 0 then
			nowaudio = data
		end
		NLG.PlaySe(player,nowaudio,0,0)
		local neirong = '@c�������yԇ��'
		..'\\n\\n��ǰ���ţ� '..nowaudio..' ̖����'
		.."\\n\\n\\n$4Ոݔ��0���ϼ����ӣ��]�������̖��ݔ���e�`��$0"
		.."\\n\\n\\n��퓡���ݔ�뾎̖���Lԇ����������"
		NLG.ShowWindowTalked(player,gmnpc,%����_�����%,51,player+29888,neirong)
	elseif select == 2 and seqno == player+29888 then--���ֲ��ԣ�ȡ��
		showwindow(player)
	elseif data == 7 and seqno == player+19888 then--���GM�Լ�����
		local neirong = "@c����ձ��� - ���b����⡿"
		.."\\n\\n\\n\\n\\n����ˆ᣿��ձ�������"
		NLG.ShowWindowTalked(player,gmnpc,%����_��Ϣ��%,17,player+23888,neirong)
	elseif select == 1 and seqno == player+23888 then--ȷ�����GM�Լ�����
		for i = 8,Char.GetData(player,CONST.CHAR_������)-1 do
			local iindex = Char.GetItemIndex(player,i)
			if iindex > -1 then
				Item.Kill(player,iindex,i)
			end
		end
		NLG.SystemMessage(player,'�����ѽ���գ��ѽ��o�����ء�')
	elseif data == 8 and seqno == player+19888 then--���GM�Լ�����
		local neirong = "@c����Ռ��"
		.."\\n\\n\\n\\n\\n����ˆ᣿��Ռ��￩��"
		NLG.ShowWindowTalked(player,gmnpc,%����_��Ϣ��%,17,player+24888,neirong)
	elseif select == 1 and seqno == player+24888 then--ȷ�����GM�Լ�����
		for i = 0,4 do
			Char.DelSlotPet(player,i)
		end
		NLG.SystemMessage(player,'�����ѽ���գ��ѽ��o�����ء�')
	elseif select == 16 and seqno == player+23888 then--��ձ�������
		showwindow(player)
	elseif select == 16 and seqno == player+24888 then--��ճ��ﷵ��
		showwindow(player)
	elseif data == 9 and seqno == player+19888 then--һ��1����0���顢30�㡢��ְҵ
		local neirong = "@c����ս�ɫ��"
		.."\\n\\n\\n\\n\\n����ˆ᣿��ս�ɫ���������"
		NLG.ShowWindowTalked(player,gmnpc,%����_��Ϣ��%,17,player+25888,neirong)
	elseif select == 16 and seqno == player+25888 then--��ճ��ﷵ��
		showwindow(player)
	elseif select == 1 and seqno == player+25888 then--һ��1����0���顢30�㡢��ְҵ
		Char.SetData(player,%����_�ȼ�%,1)
		Char.SetData(player,%����_����%,0)
		Char.SetData(player,%����_����%,0)
		Char.SetData(player,%����_����%,0)
		Char.SetData(player,%����_ǿ��%,0)
		Char.SetData(player,%����_�ٶ�%,0)
		Char.SetData(player,%����_ħ��%,0)
		Char.SetData(player,%����_����%,0)
		Char.SetData(player,%����_����%,0)
		Char.SetData(player,%����_����%,0)
		Char.SetData(player,%����_����%,0)
		Char.SetData(player,%����_����%,0)
		Char.SetData(player,%����_������%,30)
		Char.SetData(player,%����_��ʱ%,0)
		Char.SetData(player,%����_ְҵ%,1)
		Char.SetData(player,%����_ְ��%,0)
		Char.SetData(player,%����_������%,10)
		for i = 0,14 do
			local dskill = Char.GetSkillID(player,i)
			if dskill > -1 then
				Char.DelSkill(player,dskill)
			end
		end
		NLG.SystemMessage(player,'��ɫ�w��ɹ����ѽ��o�����ء�')
		NLG.UpChar(player)
	elseif seqno == player+26888 and data == 5 then--��ѯ������
		nowpage[player] = 1
		chaxun_bag(player,0)
	elseif seqno == player+98888 and select == 32 then--������һҳ
		chaxun_bag(player,1)
	elseif seqno == player+98888 and select == 16 then--������һҳ
		chaxun_bag(player,-1)
	else
		print("ȡ��")
	end
end

function chaxun_bag(player,page)--��ѯ����
	local itemindex = {}
	local itemname = {}
	local itemid = {}
	local itemtype = {}
	local maxbag = Char.GetData(player,CONST.����_������)
	nowpage[player] = nowpage[player] + page
	--print('���ڵڼ�ҳ = '..nowpage[player])
	local listnum = nil
	local slots = nil
	local maxpage = {[28]=1,[48]=2,[68]=3,[88]=4}
	local neirong = '               ����ԃ���ߙڣ��Ѵ����Ĳ�չʾ��\\n                     <��'..nowpage[player]..'퓣���'..maxpage[maxbag]..'�> ����\\n\\n'
	
	if nowpage[player] == 1 then
		for i = 8,27 do
			itemindex[i] = Char.GetItemIndex(player,i)
			if itemindex[i] > 0 then
				itemname[i] = Item.GetData(itemindex[i],%����_����%) or '��'
				itemid[i] = Item.GetData(itemindex[i],%����_ID%) or '��'
				itemtype[i] = Item.GetData(itemindex[i],%����_����%) or '��'
			else
				itemname[i] = '��'
				itemid[i] = '��'
				itemtype[i] = '��'
			end
			neirong = neirong .. 'λ��'..(i-7)..'��'..itemname[i]..'����ͣ�'..itemtype[i]..'������id��'..itemid[i]..'\\n'
		end
		if maxbag > 28 then
			NLG.ShowWindowTalked(player,gmnpc,%����_����Ϣ��%,33,player+98888,neirong)
		else
			NLG.ShowWindowTalked(player,gmnpc,%����_����Ϣ��%,1,player+98888,neirong)
		end
		return
	end
	
	if nowpage[player] == 2 then
		for i = 28,47 do
			itemindex[i] = Char.GetItemIndex(player,i)
			if itemindex[i] > 0 then
				itemname[i] = Item.GetData(itemindex[i],%����_����%) or '��'
				itemid[i] = Item.GetData(itemindex[i],%����_ID%) or '��'
				itemtype[i] = Item.GetData(itemindex[i],%����_����%) or '��'
			else
				itemname[i] = '��'
				itemid[i] = '��'
				itemtype[i] = '��'
			end
			neirong = neirong .. 'λ��'..(i-7)..'��'..itemname[i]..'����ͣ�'..itemtype[i]..'������id��'..itemid[i]..'\\n'
		end
		if maxbag > 48 then
			NLG.ShowWindowTalked(player,gmnpc,%����_����Ϣ��%,49,player+98888,neirong)
		else
			NLG.ShowWindowTalked(player,gmnpc,%����_����Ϣ��%,17,player+98888,neirong)
		end
		return
	end

	if nowpage[player] == 3 then
		for i = 48,67 do
			itemindex[i] = Char.GetItemIndex(player,i)
			if itemindex[i] > 0 then
				itemname[i] = Item.GetData(itemindex[i],%����_����%) or '��'
				itemid[i] = Item.GetData(itemindex[i],%����_ID%) or '��'
				itemtype[i] = Item.GetData(itemindex[i],%����_����%) or '��'
			else
				itemname[i] = '��'
				itemid[i] = '��'
				itemtype[i] = '��'
			end
			neirong = neirong .. 'λ��'..(i-7)..'��'..itemname[i]..'����ͣ�'..itemtype[i]..'������id��'..itemid[i]..'\\n'
		end
		if maxbag > 68 then
			NLG.ShowWindowTalked(player,gmnpc,%����_����Ϣ��%,49,player+98888,neirong)
		else
			NLG.ShowWindowTalked(player,gmnpc,%����_����Ϣ��%,17,player+98888,neirong)
		end
		return
	end
	
	if nowpage[player] == 4 then
		for i = 68,87 do
			itemindex[i] = Char.GetItemIndex(player,i)
			if itemindex[i] > 0 then
				itemname[i] = Item.GetData(itemindex[i],%����_����%) or '��'
				itemid[i] = Item.GetData(itemindex[i],%����_ID%) or '��'
				itemtype[i] = Item.GetData(itemindex[i],%����_����%) or '��'
			else
				itemname[i] = '��'
				itemid[i] = '��'
				itemtype[i] = '��'
			end
			neirong = neirong .. 'λ��'..(i-7)..'��'..itemname[i]..'����ͣ�'..itemtype[i]..'������id��'..itemid[i]..'\\n'
		end
		NLG.ShowWindowTalked(player,gmnpc,%����_����Ϣ��%,17,player+98888,neirong)
	end
end

function showcolor(player,nn)--��ɫ����չʾ
	if nn == 2 then
		NLG.Say(player,-1,"�ɫ10��Hello���@��һ�lCNħ���ɫ�yԇ�ġ�",10,0)
		NLG.Say(player,-1,"�ɫ11��Hello���@��һ�lCNħ���ɫ�yԇ�ġ�",11,0)
		NLG.Say(player,-1,"�ɫ12��Hello���@��һ�lCNħ���ɫ�yԇ�ġ�",12,0)
		NLG.Say(player,-1,"�ɫ13��Hello���@��һ�lCNħ���ɫ�yԇ�ġ�",13,0)
	elseif nn == 3 then
		NLG.Say(player,-1,"�ɫ14��Hello���@��һ�lCNħ���ɫ�yԇ�ġ�",14,0)
		NLG.Say(player,-1,"�ɫ15��Hello���@��һ�lCNħ���ɫ�yԇ�ġ�",15,0)
		NLG.Say(player,-1,"�ɫ16��Hello���@��һ�lCNħ���ɫ�yԇ�ġ�",16,0)
		NLG.Say(player,-1,"�ɫ17��Hello���@��һ�lCNħ���ɫ�yԇ�ġ�",17,0)
	elseif nn == 4 then
		NLG.Say(player,-1,"�ɫ18��Hello���@��һ�lCNħ���ɫ�yԇ�ġ�",18,0)
		NLG.Say(player,-1,"�ɫ19��Hello���@��һ�lCNħ���ɫ�yԇ�ġ�",19,0)
		NLG.Say(player,-1,"�ɫ20��Hello���@��һ�lCNħ���ɫ�yԇ�ġ�",20,0)
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

function shuzipanduan(data)--���ֻ��ı��ж�
	local wenben = data
	local shuzi = data
	if tonumber(data) == nil then
		return tostring(wenben)
	else
		return tonumber(shuzi)
	end
end

function liebiao(player,gongneng)--����б����
	if gongneng == 1 then
		local onlineplayers = NLG.GetOnLinePlayer() or 0
		NLG.SystemMessage(player,"ȫ���ھ�����б�(��̖|����|�ȼ�|λ��)���˔���"..onlineplayers)
		print("ȫ���ھ�����б�(��̖|����|�ȼ�|λ��)���˔���"..onlineplayers)
		players = NLG.GetPlayer()--��ȡ������ұ�
		local paixu = 0
		for k, v in pairs(players) do
			local cdks = Char.GetData(v,%����_CDK%) or -1
			local names = Char.GetData(v,%����_ԭ��%) or -1
			local lvs = Char.GetData(v,%����_�ȼ�%) or -1
			local mapstype = tonumber(Char.GetData(v,%����_��ͼ����%)) or -1
			local maps = tonumber(Char.GetData(v,%����_��ͼ%)) or -1
			local xs = tonumber(Char.GetData(v,%����_X%)) or -1
			local ys = tonumber(Char.GetData(v,%����_Y%)) or -1
			if names ~= -1 then
				mapsname = NLG.GetMapName(mapstype,maps)
				paixu = paixu + 1
				NLG.SystemMessage(player,paixu.."��"..cdks.." | "..names.." | "..lvs.."�� | "..mapsname.." | "..mapstype.." "..maps.." "..xs.." "..ys)
				print(paixu.."��"..cdks.." | "..names.." | "..lvs.."�� | "..mapsname.." | "..mapstype.." "..maps.." "..xs.." "..ys)
			end
		end
	elseif gongneng == 2 then
		local mapstype = tonumber(Char.GetData(player,%����_��ͼ����%)) or -1
		local maps = tonumber(Char.GetData(player,%����_��ͼ%)) or -1
		local inmapplayers = NLG.GetMapPlayerNum(mapstype,maps) or 0
		NLG.SystemMessage(player,"��ǰ��ͼ��������б�(�˺�|����|�ȼ�|λ��)��������"..inmapplayers)
		print("��ǰ�؈D�ھ�����б�(��̖|����|�ȼ�|λ��)���˔���"..inmapplayers)
		players = NLG.GetPlayer()--��ȡ������ұ�
		local paixu = 0
		for k, v in pairs(players) do
			local cdks = Char.GetData(v,%����_CDK%) or -1
			local names = Char.GetData(v,%����_ԭ��%) or -1
			local lvs = Char.GetData(v,%����_�ȼ�%) or -1
			mapstype = tonumber(Char.GetData(v,%����_��ͼ����%)) or -1
			maps = tonumber(Char.GetData(v,%����_��ͼ%)) or -1
			local xs = tonumber(Char.GetData(v,%����_X%)) or -1
			local ys = tonumber(Char.GetData(v,%����_Y%)) or -1
			local playermap = tonumber(Char.GetData(player,%����_��ͼ%))
			if names ~= -1 and maps == playermap then
				mapsname = NLG.GetMapName(mapstype,maps)
				paixu = paixu + 1
				NLG.SystemMessage(player,paixu.."��"..cdks.." | "..names.." | "..lvs.."�� | "..mapsname.." | "..mapstype.." "..maps.." "..xs.." "..ys)
				print(paixu.."��"..cdks.." | "..names.." | "..lvs.."�� | "..mapsname.." | "..mapstype.." "..maps.." "..xs.." "..ys)
			end
		end
	end
end

function geidongxi(fangshi,player,g1,g2,g3)--ͳһ���Ź���,fangshi 1=������ 2=������ 3=����� 4=������
	g1 = tostring(g1) or "err"
	g2 = tonumber(g2) or -9999999
	g3 = tonumber(g3) or -1
	if g1 == "err" or g2 == -9999999 then
		NLG.Say(player,-1,"ݔ���ʽ���_�����ǔ����e�`��Ո���Lԇ��",6)
		return
	end
	local wanjia = NLG.FindUser(g1)--��ȡ��������Աindex
	if wanjia == -1 and g1 ~= "all" then
		NLG.Say(player,-1,"ԓ��Ҳ��ھ������ߛ]���@����ң�Ո���Lԇ��",6)
		return
	end
	
	if fangshi == 1 then--������
		if g2 < 0 then
			NLG.Say(player,-1,"��Ʒid���ܞ�ؓ����",6)
			return
		end
		if g3 < 0 or g3 == -1 then
			NLG.Say(player,-1,"��Ʒ����������",6)
			return
		end
		if g1 == "all" then--ȫ�巢��
			players = NLG.GetPlayer()--��ȡ������ұ�
			for k, v in pairs(players) do
				Char.GiveItem(v,g2,g3)
			end
			NLG.SystemMessage(-1,"GM�o��l������Ʒ��Ո�鿴������")
			NLG.SystemMessage(player,"�����ھ���ң���Ʒ�l����ɡ�")
		else--���˷���
			Char.GiveItem(wanjia,g2,g3)
			NLG.SystemMessage(player,"��Ʒ�l����ɡ�")
			NLG.SystemMessage(wanjia,"GM�o��l������Ʒ��Ո�鿴������")
		end
	end

	if fangshi == 2 then--������
		if g2 < 0 then
			NLG.Say(player,-1,"����id���ܞ�ؓ����",6)
			return
		end
		if g1 == "all" then--ȫ�巢��
			players = NLG.GetPlayer()--��ȡ������ұ�
			for k, v in pairs(players) do
				Char.AddPet(v,g2)
			end
			NLG.SystemMessage(-1,"GM�o��l���ˌ��Ո�鿴������")
			NLG.SystemMessage(player,"�����ھ���ң�����l����ɡ�")
		else--���˷���
			Char.AddPet(wanjia,g2)
			NLG.SystemMessage(player,"����l����ɡ�")
			NLG.SystemMessage(wanjia,"GM�o��l���ˌ��Ո�鿴������")
		end
	end

	if fangshi == 3 then--��Ǯ
		if g2 > 1000000 or g2 < -1000000 then
			NLG.SystemMessage(player,"�����ܳ��^100�f��")
			return
		end
		if g1 == "all" then--ȫ�巢��
			players = NLG.GetPlayer()--��ȡ������ұ�
			for k, v in pairs(players) do
				Char.AddGold(v,g2)
				--Char.SetData(v,%����_���%,g2)
			end
			NLG.SystemMessage(-1,"GM�o��l�X�ˣ�Ո�鿴�X����")
			NLG.SystemMessage(player,"�����ھ���ң��l�X��ɡ�")
		else
			Char.AddGold(wanjia,g2)
			--Char.SetData(wanjia,%����_���%,g2)
			NLG.SystemMessage(player,"�l�X��ɡ�")
			NLG.SystemMessage(wanjia,"GM�o��l�X�ˣ�Ո�鿴�X����")
		end
	end
	
	if fangshi == 4 then--������
		if g1 == "all" then--ȫ�巢��
			players = NLG.GetPlayer()--��ȡ������ұ�
			for k, v in pairs(players) do
				Char.SetData(v,%����_����%,g2)
				NLG.UpChar(v)
			end
			NLG.SystemMessage(-1,"GM�o��l����ˣ�Ո�鿴��B���Еr����Ҫ��һ������ˢ�µȼ���")
			NLG.SystemMessage(player,"�����ھ���ң��l�����ɡ�")
		else
			Char.SetData(wanjia,%����_����%,g2)
			NLG.UpChar(wanjia)
			NLG.SystemMessage(player,"�l�����ɡ�")
			NLG.SystemMessage(wanjia,"GM�o��l����ˣ�Ո�鿴��B���Еr����Ҫ��һ������ˢ�µȼ���")
		end
	end
end

function fei(mode,gm,wanjia,floor,map,x,y)--�ɿع��ܣ�mode1=�ɵ�����Ǳ� 2=�ٻ���� 3=�Զ���� 4=�ٻ���ǰ��ͼ������� 5=�ٻ�ȫ����� 6=С����
	local wanjia = tostring(wanjia) or "err"
	local tofloor = tonumber(floor) or -1
	local tomap = tonumber(map) or -1
	local tox = tonumber(x) or -1
	local toy = tonumber(y) or -1

	if wanjia == "err" then
		NLG.Say(gm,-1,"ԓ��Ҳ��ھ������ߛ]���@����ң������w�Д����e�`��Ո���Lԇ��",6)
		return
	end

	if mode == 1 then--��ʼ�����
		local wanjia = tonumber(NLG.FindUser(wanjia))--��ȡ��������Աindex
		if wanjia == -1 then
			NLG.Say(gm,-1,"ԓ��Ҳ��ھ������ߛ]���@����ң�Ո���Lԇ��",6)
			return
		end
		local ffloor = tonumber(Char.GetData(wanjia,%����_��ͼ����%))
		local fmap = tonumber(Char.GetData(wanjia,%����_��ͼ%))
		local fx = tonumber(Char.GetData(wanjia,%����_X%))
		local fy = tonumber(Char.GetData(wanjia,%����_Y%))
		Char.Warp(gm,ffloor,fmap,fx,fy)
	end
	
	if mode == 2 then--��ʼ�ٻ����
		local wanjia = tonumber(NLG.FindUser(wanjia))--��ȡ��������Աindex
		if wanjia == -1 then
			NLG.Say(gm,-1,"ԓ��Ҳ��ھ������ߛ]���@����ң�Ո���Lԇ��",6)
			return
		end
		local floorf = tonumber(Char.GetData(gm,%����_��ͼ����%))
		local mapf = tonumber(Char.GetData(gm,%����_��ͼ%))
		local xf = tonumber(Char.GetData(gm,%����_X%))
		local yf = tonumber(Char.GetData(gm,%����_Y%))
		Char.Warp(wanjia,floorf,mapf,xf,yf)
		NLG.SystemMessage(wanjia,"���ѱ�GM�ن����K���͵�����߅��")
	end
	
	if mode == 3 then--��ʼ�����
		floor = tonumber(floor)
		map = tonumber(map)
		x = tonumber(x)
		y = tonumber(y)
		if floor > 2 or floor < 0 or map < 0 or x <0 or y < 0 then
			NLG.Say(gm,-1,"�����e�`��Ո���Lԇ��",6)
		end
		Char.Warp(gm,floor,map,x,y)
	end
	
	if mode == 4 then--��ʼ�ٻ���ǰ��ͼ�������
		local floorme = tonumber(Char.GetData(gm,%����_��ͼ����%))
		local mapme = tonumber(Char.GetData(gm,%����_��ͼ%))
		local xme = tonumber(Char.GetData(gm,%����_X%))
		local yme = tonumber(Char.GetData(gm,%����_Y%))
		local inmapplayers = NLG.GetMapPlayerNum(floorme,mapme) or 0
		players = NLG.GetPlayer()--��ȡ������ұ�
		for k, v in pairs(players) do
			if v ~= gm and Char.GetData(v,%����_��ͼ%) == mapme then
				Char.Warp(v,floorme,mapme,xme,yme)
				NLG.SystemMessage(v,"���ѱ�GM�ن����K���͵�����߅��")
			end
		end
		if inmapplayers == 1 or inmapplayers == 0 then
			NLG.SystemMessage(gm,"��ǰ�؈D���������]�����ˣ��ن�ʧ����")
		else
			NLG.SystemMessage(gm,"�ن����؈D������� "..(inmapplayers-1).." �ˣ��ɹ���")
		end
	end
	
	if mode == 5 then--��ʼ�ٻ�ȫ���������
		local floorme = tonumber(Char.GetData(gm,%����_��ͼ����%))
		local mapme = tonumber(Char.GetData(gm,%����_��ͼ%))
		local xme = tonumber(Char.GetData(gm,%����_X%))
		local yme = tonumber(Char.GetData(gm,%����_Y%))
		local onlineplayers = NLG.GetOnLinePlayer() or 0
		players = NLG.GetPlayer()--��ȡ������ұ�
		for k, v in pairs(players) do
			if v ~= gm then
				Char.Warp(v,floorme,mapme,xme,yme)
				NLG.SystemMessage(v,"���ѱ�GM�ن����K���͵�����߅��")
			end
		end
		if onlineplayers == 1 or onlineplayers == 0 then
			NLG.SystemMessage(gm,"��ǰ�؈D���������]�����ˣ��ن�ʧ����")
		else
			NLG.SystemMessage(gm,"�ن����؈D������� "..(onlineplayers-1).." �ˣ��ɹ���")
		end
	end

	if mode == 6 then--�����ȥС����
		local wanjia = tonumber(NLG.FindUser(wanjia))--��ȡ��������Աindex
		if wanjia == -1 then
			NLG.Say(gm,-1,"ԓ��Ҳ��ھ������ߛ]���@����ң�Ո���Lԇ��",6)
			return
		end
		--if gm == wanjia then
		--	NLG.Say(gm,-1,"�㲻�ܰ��Լ���С���ݡ�",6)
		--	return
		--end
		local shichang = tonumber(floor) or -1
		if shichang < 0 then
			NLG.Say(gm,-1,"�씵���ɞ�ؓ����Ո���Lԇ��",6)
			return
		end
		if shichang <= 0 then
			NLG.SystemMessage(wanjia,"GM�ѽ�����Ľ��]�������ϲ�̝Mጷš�")
			NLG.SystemMessage(gm,"�ь�"..Char.GetData(wanjia,%����_����%).."�Ľ��]�����")
			Field.Set(wanjia,"blockenddate",0)
			Field.Set(wanjia,"block",0)
			NLG.UpChar(wanjia)
			return
		--[[elseif shichang > 0 then
			local riqi = os.time()
			local endblockriqi = riqi + (1*24*60*60)--��һ��
			local wanjianame = Char.GetData(wanjia,%����_����%)
			Field.Set(wanjia,"blockenddate",endblockriqi)
			NLG.SystemMessage(gm,wanjianame.."�����͵�С���ݣ������գ�"..os.date("%Y-%m-%d %H:%M:%S",riqi).." ����գ�"..os.date("%Y-%m-%d %H:%M:%S",endblockriqi))
			NLG.SystemMessage(wanjia,"���Ѿ�����С���ݣ��ͷ����ڣ�"..os.date("%Y-%m-%d %H:%M:%S",endblockriqi).."������������ϵGM��")
			]]
		else
			local riqi = os.time()
			local endblockriqi = riqi + (shichang*24*60*60)--��������
			endblockriqi = math.floor(endblockriqi + 0.5)--��������
			local wanjianame = Char.GetData(wanjia,%����_����%)
			Field.Set(wanjia,"blockenddate",endblockriqi)
			Field.Set(wanjia,"block",1)
			NLG.SystemMessage(gm,"������С�����ˣ�"..wanjianame.." �����գ�"..os.date("%Y-%m-%d %H:%M:%S",riqi).." ����գ�"..os.date("%Y-%m-%d %H:%M:%S",endblockriqi))
			NLG.SystemMessage(wanjia,"���ѽ����PС���ݣ�ጷ����ڣ�"..os.date("%Y-%m-%d %H:%M:%S",endblockriqi).."���І��}ՈϵGM��")
			Char.DischargeParty(wanjia)
			Char.Warp(wanjia,0,xiaoheiwu,xhwx,xhwy)
			NLG.UpChar(wanjia)
			return
		end
		--NLG.SystemMessage(wanjia,"����ĳ��ԭ�����ѱ����͵�С���ݣ����������뵽Ⱥ����GM��")
	end
end

function wanjiakz(style,player,wanjia)--��ҿ��ƹ��� style1=�߳�ָ����� 2=��� 3=���
	local wanjia = tostring(wanjia) or "err"
	if wanjia == "err" then
		NLG.Say(player,-1,"Ŀ�ˎ�̖�����e�`��Ո���Lԇ��",6)
		return
	end
	
	if style == 1 then--��ʼ�߳�ָ�����
		local wanjia = tonumber(NLG.FindUser(wanjia))--��ȡ��������Աindex
		if wanjia == -1 then
			NLG.Say(player,-1,"ԓ��Ҳ��ھ������ߛ]���@����ң�Ո���Lԇ��",6)
			return
		elseif wanjia == player then
			NLG.Say(player,-1,"�Լ��������Լ���Ո���Lԇ��",6)
			return
		end
		NLG.DropPlayer(wanjia)
		NLG.SystemMessage(player,"ָ��������߳���")
	end
	
	if style == 2 then--��ʼ���
		if Char.GetData(player,%����_CDK%) == wanjia then
			NLG.Say(player,-1,"�Լ����ܷ��Լ�̖��Ո���Lԇ��",6)
			return
		end
		local tuser = SQL.querySQL("select * from tbl_user where CdKey='"..wanjia.."'")--["0_0"]
		--tuser = tostring(tuser) or "none"
		--if tuser == "none" then
		--print("tuser:"..tuser)
		if tuser == SQL.CONST_RET_NO_ROW then
			NLG.Say(player,-1,"mysql��tbl_user�Л]���ҵ��@���~̖��Ո���Lԇ��",6)
			return
		end
		SQL.Run("update tbl_user set EnableFlg = '0' where CdKey= '"..wanjia.."'")
		NLG.SystemMessage(player,"��Ҏ�̖��"..wanjia.."����ͣ���̖��")
	end
	
	if style == 3 then--��ʼ���
		if Char.GetData(player,%����_CDK%) == wanjia then
			NLG.Say(player,-1,"�Լ����ܲ����Լ���̖��Ո���Lԇ��",6)
			return
		end
		--print("tuser:"..tuser)
		local tuser = SQL.querySQL("select * from tbl_user where CdKey='"..wanjia.."'")--["0_0"]
		--tuser = tostring(tuser) or "none"
		--if tuser == "none" then
		if tuser == SQL.CONST_RET_NO_ROW then
			NLG.Say(player,-1,"mysql��tbl_user�Л]���ҵ��@����̖��Ո���Lԇ��",6)
			return
		end
		SQL.Run("update tbl_user set EnableFlg = '1' where CdKey= '"..wanjia.."'")
		NLG.SystemMessage(player,"��Ҏ�̖��"..wanjia.."���ѽ�⡣")
	end
end

function faceto(xuanze,player)--��ѯ��ǰ�Ķ����ܣ�xunze = 4ʱ��Ϊ����kill���� xuanze = 8ʱ�����Ի�ȡ��������Ȩ
	local nowfloor = Char.GetData(player,%����_��ͼ����%)
	local nowmap = Char.GetData(player,%����_��ͼ%)
	local nowx = Char.GetData(player,%����_X%)
	local nowy = Char.GetData(player,%����_Y%)
	local nowf = Char.GetData(player,%����_����%)
	--NLG.SystemMessage(player,"xyf:"..nowx.." "..nowy.." "..nowf)
	
	if nowf == 2 then--�����㷨
		nowx = nowx + 1
	elseif nowf == 3 then
		nowx = nowx + 1
		nowy = nowy + 1
	elseif nowf == 4 then
		nowy = nowy + 1
	elseif nowf == 5 then
		nowx = nowx - 1
		nowy = nowy + 1
	elseif nowf == 6 then
		nowx = nowx - 1
	elseif nowf == 7 then
		nowx = nowx - 1
		nowy = nowy - 1
	elseif nowf == 0 then
		nowy = nowy - 1
	elseif nowf == 1 then
		nowx = nowx + 1
		nowy = nowy - 1
	end
	
	local mubiao2 = {}
	local mubiao,mubiao2 = Obj.GetObject(nowfloor,nowmap,nowx,nowy)
	--print("mubiao��"..mubiao)
	--[[for k, v in pairs(mubiao2) do
		if v ~= player then
			print("mubiao2��"..v)
		end
	end]]
	--print("mubiao2[1]��"..mubiao2[1])
	local mubiao1 = mubiao2[1] or -1
	if mubiao1 > -1 then
		mubiao1 = Obj.GetCharIndex(mubiao1)
		--print("mubiao1:"..mubiao1)
	--else
	--	NLG.SystemMessage(player,"�޷��������ǰ�Ķ�����û��ʲô���õ����ݿɲ顣")
	end
	local mbtype = Char.GetData(mubiao1,%����_����%) or -100
	--print("mbtype:"..mbtype)
	if xuanze == 8 then--���Ի�ȡ��������Ȩ
		if mbtype == 3 then
			Char.SetData(mubiao1,%����_����CDK%,Char.GetData(player,%����_CDK%))
			Char.SetData(mubiao1,%����_�˺�%,Char.GetData(player,%����_CDK%))
			Char.SetData(mubiao1,%����_����%,'gm������...')
			NLG.UpChar(player)
			NLG.UpChar(mubiao1)
			NLG.SystemMessage(player,'�@ȡ���Й�ɹ������ԓ������ˡ�')
			NLG.SystemMessage(player,'�ȼ�����ģ�Ո����[nr level 999]��')
		else
			NLG.SystemMessage(player,'�@ȡ���Й�ʧ����Ո�{��վλ���]���دB��')
		end
		return
	end
	if xuanze == 4 then--����ɾ������
		mubiao2[1] = mubiao2[1] or -1
		if mubiao2[1] ~= -1 and mbtype == 3 then
			Obj.SetDelTime(mubiao2[1],0)
			NLG.SystemMessage(player,'�Lԇ�h����ǰ����ɹ���')
		elseif mubiao2[1] ~= -1 and mbtype == -100 then
			Obj.RemoveObject(mubiao2[1])
			NLG.SystemMessage(player,'�Lԇ�h����ǰ���߳ɹ���')
		elseif mubiao2[1] ~= -1 and mbtype >= -4 then
			NL.DelNpc(mubiao2[1])
			NLG.SystemMessage(player,'�Lԇ�h����ǰNPC/���˳ɹ��������ؓ��')
		else
			NLG.SystemMessage(player,'�Lԇ�h��Ŀ��ʧ����Ŀ�y���Ʉh����')
			return
		end
		local playermap = tonumber(Char.GetData(player,%����_��ͼ%))
		players = NLG.GetPlayer()--��ȡ������ұ�
		for k, v in pairs(players) do--����upchar
			local names = Char.GetData(v,%����_ԭ��%) or -1
			local maps = tonumber(Char.GetData(v,%����_��ͼ%)) or -1
			if names ~= -1 and maps == playermap then
				Protocol.Send(v,'uSB',from10to62(mubiao2[1]))
			end
		end
		return
	end
	if mubiao == 0 then--��
		--NLG.SystemMessage(player,"�޷��������ǰ�Ķ�����û��ʲô���õ����ݿɲ顣")
		local neirong = '@c����ԃ��ǰ����'
		..'\\n'
		..'\\n\\n\\n�o���z�y����ǰ�Ė|�����]��ʲ�����õĔ����ɲ顣'
		NLG.ShowWindowTalked(player,gmnpc,%����_��Ϣ��%,18,player+28888,neirong)
		return
	elseif mbtype == 1 then--��ɫ
		local mbname = Char.GetData(mubiao1,%����_����%) or '��'
		local mbid = Char.GetData(mubiao1,%����_CDK%) or '��'
		local mbdpn = Char.GetData(mubiao1,%����_DataPN%) or '��'
		if mbdpn == 0 then
			mbdpn = "��"
		else
			mbdpn = "��"
		end
		--NLG.SystemMessage(player,"���ͣ��ˣ������ǣ�"..mbname.."���˺��ǣ�"..mbid)
		local neirong = nil
		if Char.IsDummy(mubiao1) then
			neirong = '@c����ԃ��ǰ����'
			..'\\n'
			.."\\n��ͣ�����\\n\\n�����ǣ�"..mbname.."\\n\\n��̖�ǣ�"..mbid..'\\n\\n��ɫλ�ã�'..mbdpn
		else
			neirong = '@c����ԃ��ǰ����'
			..'\\n'
			.."\\n��ͣ���\\n\\n�����ǣ�"..mbname.."\\n\\n��̖�ǣ�"..mbid..'\\n\\n��ɫλ�ã�'..mbdpn
		end
		NLG.ShowWindowTalked(player,gmnpc,%����_��Ϣ��%,18,player+28888,neirong)
	elseif mbtype == 3 then--����
		--local mbid = Char.GetData(mubiao1,%����_CDK%)
		--mbid = NLG.FindUser(mbzhuren)
		local mbname = Char.GetData(mubiao1,%����_����%) or '��'
		local mbzhuren = Char.GetData(mubiao1,%����_����CDK%) or '��'
		local mbname2 = Char.GetData(mubiao1,%����_��������%) or '��'
		local enemyid = Char.GetData(mubiao1,CONST.PET_PetID) or '��'
		local real_enemyid = ck_enemyid(enemyid) or '��ԃʧ��'
		--NLG.SystemMessage(player,"���ͣ��裬index��ţ�"..mubiao1.."��enemybase��ţ�"..enemyid.."�������ǣ�"..mbname)
		--NLG.SystemMessage(player,"�����˺��ǣ�"..mbzhuren.."�����������ǣ�"..mbname2..'��enemy�����ʱ�޷���ѯ')
		local neirong = '@c����ԃ��ǰ����'
		..'\\n'
		.."\\n��ͣ���\\nindex��̖��"..mubiao1.."\\nenemybase��̖��"..enemyid.."\\n�����ǣ�"..mbname
		--.."\\n�����˺��ǣ�"..mbzhuren.."\\n���������ǣ�"..mbname2..'\\nenemy�����ʱ�޷���ѯ'
		.."\\n���ˎ�̖�ǣ�"..mbzhuren.."\\n���������ǣ�"..mbname2..'\\nenemy��̖��'..real_enemyid
		NLG.ShowWindowTalked(player,gmnpc,%����_��Ϣ��%,18,player+28888,neirong)
	elseif mbtype == 2 then--�֣��ò���
		--NLG.SystemMessage(player,"���ͣ��֣�û��ʲô���õ����ݿɲ顣")
		local neirong = '@c����ԃ��ǰ����'
		..'\\n'
		.."\\n\\n\\n��ͣ��֣��]��ʲ�����õĔ����ɲ顣"
		NLG.ShowWindowTalked(player,gmnpc,%����_��Ϣ��%,18,player+28888,neirong)
	elseif mbtype >= 4 then--NPC
		local mbname = Char.GetData(mubiao1,%����_����%) or '��'
		--NLG.SystemMessage(player,"���ͣ�NPC�����֣�"..mbname.."��index��ţ�"..mubiao1.."�����ͣ�"..mbtype)
		local neirong = '@c����ԃ��ǰ����'
		..'\\n'
		.."\\n��ͣ�NPC\\n\\n���֣�"..mbname.."\\n\\nindex��̖��"..mubiao1.."\\n\\n��;�̖��"..mbtype
		NLG.ShowWindowTalked(player,gmnpc,%����_��Ϣ��%,18,player+28888,neirong)
	elseif mbtype == -100 then--���ߣ�ΪǮ��ʱ���б�������Ӱ��
		local itemname = Item.GetData(mubiao1,%����_����%) or '��'
		local itemid = Item.GetData(mubiao1,%����_ID%) or '��'
		local itemtype = Item.GetData(mubiao1,%����_����%) or '��'
		--NLG.SystemMessage(player,"���ͣ����ߣ����֣�"..itemname.."��index��ţ�"..mubiao1)
		--NLG.SystemMessage(player,"typeid��"..itemtype.."������"..mubiao.."������id��"..itemid)
		local neirong = '@c����ԃ��ǰ����'
		..'\\n'
		.."\\n��ͣ�����\\n���֣�"..itemname.."\\nindex��̖��"..mubiao1
		.."\\ntypeid��"..itemtype.."\\n������"..mubiao.."\\n����id��"..itemid
		NLG.ShowWindowTalked(player,gmnpc,%����_��Ϣ��%,18,player+28888,neirong)
	end
end

function chaxun(player)--��ѯ 1=������ 2=������
	local pet = {}
	local petname = {}
	local petenemyid = {}
	local real_enemyid2 = {}
	for i = 0,4 do
		pet[i] = Char.GetPet(player,i)--slot
		if pet[i] == -1 then
			petname[i] = '��'
			petenemyid[i] = '��'
			real_enemyid2[i] = '��'
		else
			petname[i] = Char.GetData(pet[i],%����_ԭ��%) or '��'
			petenemyid[i] = Char.GetData(pet[i],CONST.PET_PetID) or '��'
			if petenemyid[i] ~= '��' then
				real_enemyid2[i] = ck_enemyid(petenemyid[i])
			else
				real_enemyid2[i] = '��'
			end
		end
	end

	local neirong = '@c����ԃ����ڡ�'
	..'\\n\\n'
	..'\\n'
	..'\\n���֣�'..petname[0]..'��enemybase��̖��'..petenemyid[0]..'��enemy��̖��'..real_enemyid2[0]
	..'\\n'
	..'\\n���֣�'..petname[1]..'��enemybase��̖��'..petenemyid[1]..'��enemy��̖��'..real_enemyid2[1]
	..'\\n'
	..'\\n���֣�'..petname[2]..'��enemybase��̖��'..petenemyid[2]..'��enemy��̖��'..real_enemyid2[2]
	..'\\n'
	..'\\n���֣�'..petname[3]..'��enemybase��̖��'..petenemyid[3]..'��enemy��̖��'..real_enemyid2[3]
	..'\\n'
	..'\\n���֣�'..petname[4]..'��enemybase��̖��'..petenemyid[4]..'��enemy��̖��'..real_enemyid2[4]
	NLG.ShowWindowTalked(player,gmnpc,%����_����Ϣ��%,18,player+27888,neirong)
end

--[[
function ahsin_gm_tool_ultraModule:smallblackhouse(player)--С���ݣ��ǳ��سǵ㴥��
	local isblocked = tonumber(Field.Get(player,"block")) or 0--С����״̬
	if isblocked == 1 then
		local endblockdate = tonumber(Field.Get(player,"blockenddate")) or -1--С���ݽ�������
		--print("isblocked1��"..isblocked)
		if endblockdate < os.time() then
			NLG.SystemMessage(player,"��ϲ��������������ս�������ͷš�")
			--NLG.SystemMessage(gm,"�ѽ�"..Char.GetData(player,%����_����%).."�Ľ��ս����")
			Field.Set(player,"blockenddate",0)
			Field.Set(player,"block",0)
			NLG.UpChar(player)
			return 0
		end
		if endblockdate > os.time() then
			local riqi = os.date("%Y-%m-%d %H:%M:%S",endblockdate)
			Char.DischargeParty(player)
			Char.Warp(player,0,xiaoheiwu,xhwx,xhwy)
			NLG.SystemMessage(player,"���Ѿ�����С���ݣ��ͷ����ڣ�"..riqi.."������������ϵGM��")
			NLG.UpChar(player)
			return 0
		end
	end
	return 0
end
]]

function ahsin_gm_tool_ultraModule:jinru(player)--С���ݣ����봥��
	local isblocked = tonumber(Field.Get(player,"block")) or 0--С����״̬
	if isblocked == 1 then
		local endblockdate = tonumber(Field.Get(player,"blockenddate")) or -1--С���ݽ�������
		--print("isblocked1��"..isblocked)
		if endblockdate < os.time() then
			NLG.SystemMessage(player,"��ϲ������ڝM�����]����̝Mጷš�")
			--NLG.SystemMessage(gm,"�ѽ�"..Char.GetData(player,%����_����%).."�Ľ��ս����")
			Field.Set(player,"blockenddate",0)
			Field.Set(player,"block",0)
			NLG.UpChar(player)
			return 0
		end
		if endblockdate > os.time() then
			local riqi = os.date("%Y-%m-%d %H:%M:%S",endblockdate)
			Char.DischargeParty(player)
			Char.Warp(player,0,xiaoheiwu,xhwx,xhwy)
			NLG.SystemMessage(player,"���ѽ����PС���ݣ�ጷ����ڣ�"..riqi.."���І��}ՈϵGM��")
			NLG.UpChar(player)
			return 0
		end
	end
	return 0
end

--[[
function ahsin_gm_tool_ultraModule:youjian(fd)--�������ж�����
	local Rplayer = tonumber(Protocol.GetCharByFd(fd))
	local whereme = Char.GetData(Rplayer,%����_��ͼ%)
	--print("���С����������")
	if whereme ~= xiaoheiwu then
		local isblocked = tonumber(Field.Get(Rplayer,"block")) or 0--С����״̬
		--print("isblock:"..isblocked)
		if isblocked == 1 then
			local endblockdate = tonumber(Field.Get(Rplayer,"blockenddate")) or -1--С���ݽ�������
			if endblockdate < os.time() then
				NLG.SystemMessage(Rplayer,"��ϲ��������������ս�������ͷš�")
				Field.Set(Rplayer,"blockenddate",0)
				Field.Set(Rplayer,"block",0)
				NLG.UpChar(Rplayer)
			else
				local riqi = os.date("%Y-%m-%d %H:%M:%S",endblockdate)
				Char.DischargeParty(Rplayer)
				Char.Warp(Rplayer,0,xiaoheiwu,xhwx,xhwy)
				NLG.UpChar(Rplayer)
				NLG.SystemMessage(Rplayer,"�����ڱ���С���ݣ��ͷ����ڣ�"..riqi.."������������ϵGM��")
			end
		end
	end
	return 0
end
]]

function ahsin_gm_tool_ultraModule:chuansonghou(player)--���ͺ󴥷�
	jishi[player] = 2
	--print("��ʱ��1��"..jishi[player])
	Char.SetLoopEvent(nil,"jishiqi",player,1000)--call��ʱ��2���ӳ�
end

function ahsin_gm_tool_ultraModule:jishiqi(player)--��ʱ����ʱ�жϣ����afterwarpѭ��fw���²�����
	if yzmkg == 0 then
		goto xhwpd
	end
	if tonumber(Field.Get(player,"block")) == 1 then
	--if Char.GetData(player,%����_��ͼ%) == xiaoheiwu then--�˻���С����
		--Char.DischargeParty(player)
		--Char.Warp(player,0,xiaoheiwu,xhwx,xhwy)
		goto xhwpd
	end
	if warptimes[player] == nil or warptimes[player] == "" then--���ͼ���������ר��
		warptimes[player] = 1
	elseif warptimes[player] < warpmax then--�����ۼ�
		warptimes[player] = warptimes[player] + 1
	elseif warptimes[player] == warpmax then--����������δ��֤
		warptimes[player] = warpmax
		Char.SetLoopEvent(nil,"jishiqi",player,7000)--��ʱ������δΪ7��1��
	end
	--print('���ʹ����ۼƣ�'..warptimes[player])
	if warptimes[player] == warpmax then--������
		if bsryzm[player] == false or bsryzm[player] == 0 or bsryzm[player] == nil or bsryzm[player] == "" then--��������֤�볬ʱ����
			bsryzm[player] = bsryzmcs/5
		end
		bsryzm[player] = bsryzm[player] - 1
		--print('��ʱ��'..bsryzm[player])
		NLG.SystemMessage(player,'Ո�]�⣺���r��ݔ����C�a����C�a���ݔ���e�`���������PС���ݡ�')
		if bsryzm[player] == 0 then--��ʱ
			Field.Set(player,"block",1)
			Field.Set(player,"blockenddate",(os.time()+3600))
			Char.DischargeParty(player)
			Char.Warp(player,0,xiaoheiwu,xhwx,xhwy)
			NLG.UpChar(player)
			NLG.SystemMessage(player,"������L�r�gδݔ����C�a���^"..bsryzmcs.."�룬�ܵ��PС����1С�r̎�P��")
			NLG.Say(player,-1,"�ŗ��ֿ����ό�������̹�׏Č������܏ć���",25)
			NLG.SystemMessage(player,"�І��}ՈϵGM��")
			warptimes[player] = 0
			jishi[player] = 2
			bsryzm[player] = 0
			Char.SetLoopEvent(nil,"jishiqi",player,0)--��ʱ������
			Char.UnsetLoopEvent(player)--ж�ؼ�ʱ��
			return
		end
		local yzm1 = math.random(1,10)--��һλ
		local yzm2 = math.random(1,10)--�ڶ�λ
		local yzm3 = math.random(1,10)--������
		local yzm4 = math.random(1,10)--������
		local yzm5 = math.random(1,10)--������
		local yzm6 = math.random(1,10)--������
		yzm[player] = (yzm1-1)..(yzm2-1)--��λ����
		local yzmxx = math.random(1,yzmlie)--��֤��ƥ��1
		local yzmxx2 = math.random(1,yzmlie)--��֤��ƥ��2
		local yzmxx3 = math.random(1,yzmlie)--��֤��ƥ��3--������
		local yzmxx4 = math.random(1,yzmlie)--��֤��ƥ��4--������
		local yzmxx5 = math.random(1,yzmlie)--��֤��ƥ��5--������
		local yzmxx6 = math.random(1,yzmlie)--��֤��ƥ��6--������
		--print('��֤���������'..yzmxx..yzmxx2)
		local fhs = math.random(1,10)
		local fuhao = {'��','����','������','��������','����������','������������','����������������','����������������','������������������','��������������������','����������������������'}
		--print('��ͷ����'..fhs..'������:'..fuhao[fhs])
		--print('��֤�룺'..yzm[player])
		local yzmmsg = "@c\\nħ�����ܷ���ϵ�y��"
		.."\\n"
		.."\\n"
		.."\\n--#//'��       "..yzmpp[yzm1][yzmxx]..' .. '..yzmpp[yzm2][yzmxx2].."       ��'//#--"
		.."\\n"
		.."\\n"
		.."\\nՈ��10��ȣ�ݔ��2λ��C�a�������֣�"
		.."\\n"..fuhao[fhs]
		.."\\n"..yzmpp[yzm3][yzmxx3]..' .. '..yzmpp[yzm4][yzmxx4]--������
		.."\\n"..yzmpp[yzm5][yzmxx5]..' .. '..yzmpp[yzm6][yzmxx6]--������
		.."\\n"..yzmpp[yzm3][yzmxx4]..' .. '..yzmpp[yzm5][yzmxx6]--������
		.."\\n"..yzmpp[yzm6][yzmxx5]..' .. '..yzmpp[yzm4][yzmxx3]--������
		NLG.ShowWindowTalked(player,darkroomnpc,%����_�����%,%��ť_��%,player+404404,yzmmsg)
	end
	::xhwpd::
	local whereme = Char.GetData(player,%����_��ͼ%)
	if whereme == xiaoheiwu then--�˻���С���ݣ��˳���ʱ��
		Char.SetLoopEvent(nil,"jishiqi",player,0)--��ʱ������
		Char.UnsetLoopEvent(player)--ж�ؼ�ʱ��
		jishi[player] = 2
		--print("С�����ж�����ͼ��ȷ���˳���")
	elseif whereme ~= xiaoheiwu and warptimes[player] ~= warpmax then--�˲���С����
		local isblocked = tonumber(Field.Get(player,"block")) or 0--��ȡ����״̬
		if isblocked == 1 then--״̬Ϊ������
			jishi[player] = jishi[player] - 1--����ʱ��ʼ
			--print("��ʱ��2��"..jishi[player])
			--print("С�����ж���С���ݽ�����Ա��")
			if jishi[player] <= 0 then--����ʱ���
				local endblockdate = tonumber(Field.Get(player,"blockenddate")) or -1--С���ݽ�������
				if endblockdate < os.time() then--�����������ͷ�
					NLG.SystemMessage(player,"��ϲ������ڝM�����]����̝Mጷš�")
					Field.Set(player,"blockenddate",0)
					Field.Set(player,"block",0)
					NLG.UpChar(player)
					Char.SetLoopEvent(nil,"jishiqi",player,0)--��ʱ������
					Char.UnsetLoopEvent(player)--ж�ؼ�ʱ��
					jishi[player] = 2
				else--�������
					local riqi = os.date("%Y-%m-%d %H:%M:%S",endblockdate)
					Char.DischargeParty(player)
					Char.Warp(player,0,xiaoheiwu,xhwx,xhwy)
					NLG.UpChar(player)
					NLG.SystemMessage(player,"=========================")
					NLG.SystemMessage(player,"���F����̎�С���ݽ��]���g��")
					NLG.Say(player,-1,"�ŗ��ֿ����ό�������̹�׏Č������܏ć���",25)
					NLG.SystemMessage(player,"ጷ����ڣ�"..riqi.."���І��}ՈϵGM��")
					Char.SetLoopEvent(nil,"jishiqi",player,0)--��ʱ������
					Char.UnsetLoopEvent(player)--ж�ؼ�ʱ��
					jishi[player] = 2
				end
			end
		else--״̬Ϊ�ǽ�����Ա
			--print("��ʱ��3��"..jishi[player])
			--print("С�����ж����ǽ�����Ա���˳���")
			Char.SetLoopEvent(nil,"jishiqi",player,0)--��ʱ������
			Char.UnsetLoopEvent(player)--ж�ؼ�ʱ��
			jishi[player] = 2
		end
--else--����֮��ĵ�ͼ�ж�������
--	print("��ʱ��4��"..jishi[player])
--	print("С�����ж�����Ҵ��ͺ󣬵�ͼ�жϳ���ǿ�ƴ��ͻ�С���ݡ�")
--	Char.DischargeParty(player)
--	Char.Warp(player,0,xiaoheiwu,xhwx,xhwy)
--	Char.SetLoopEvent(nil,"jishiqi",player,0)--��ʱ������
--	Char.UnsetLoopEvent(player)--ж�ؼ�ʱ��
--	jishi[player] = 2
	end
end

function ahsin_gm_tool_ultraModule:face2npc(dnpc,dplayer,seq,sel,data)--С���ݹܼ�npc
	local xunxi = "@c\\n���p�ˣ������ܰɣ�"
	.."\\n"
	.."\\n��һ���Ҹ��µĕr��߀����20��ǰ..."
	.."\\n�������������ӿ������^��..."
	.."\\n�S����ɣ��@�e߀ͦ���..."
	.."\\n"
	.."\\n"
	.."\\n�벻��׌�Ҏ��㆖����z�L����ʲ��r���ܳ�ȥ��"
	NLG.ShowWindowTalked(dplayer,dnpc,%����_��Ϣ��%,%��ť_�Ƿ�%,dplayer+29989,xunxi)
end

function ahsin_gm_tool_ultraModule:face2npc2(dnpc,dplayer,seq,sel,data)--С���ݹܼ�npc��ѯ
	--print("seq:"..seq.." ,sel:"..sel.." data:"..data)
	if seq == dplayer+404404 and tonumber(data) ~= tonumber(yzm[dplayer]) then
		NLG.SystemMessage(dplayer,'��C�aݔ���e�`��Ո�ٴ·Lԇ��')
		if yzmer[dplayer] == false or yzmer[dplayer] == nil or yzmer[dplayer] == "" or yzmer[dplayer] == 0 then
			yzmer[dplayer] = yzmcw
		end
		yzmer[dplayer] = yzmer[dplayer] - 1
		if yzmer[dplayer] == 0 then--��֤������������
			Field.Set(dplayer,"block",1)
			Field.Set(dplayer,"blockenddate",(os.time()+3600))
			Char.DischargeParty(dplayer)
			Char.Warp(dplayer,0,xiaoheiwu,xhwx,xhwy)
			NLG.UpChar(dplayer)
			NLG.SystemMessage(dplayer,"�������C�aݔ���e�`���^"..yzmcw.."�Σ��ܵ��PС����1С�r̎�P��")
			NLG.Say(dplayer,-1,"�ŗ��ֿ����ό�������̹�׏Č������܏ć���",25)
			NLG.SystemMessage(dplayer,"�І��}ՈϵGM��")
			warptimes[dplayer] = 0
			jishi[dplayer] = 2
			bsryzm[dplayer] = 0
			Char.SetLoopEvent(nil,"jishiqi",dplayer,0)--��ʱ������
			Char.UnsetLoopEvent(dplayer)--ж�ؼ�ʱ��
		end
	elseif seq == dplayer+404404 and tonumber(data) == tonumber(yzm[dplayer]) then
		NLG.SystemMessage(dplayer,'��C�a���_���[��옷��')
		warptimes[dplayer] = 0
		jishi[dplayer] = 2
		bsryzm[dplayer] = 0
		Char.SetLoopEvent(nil,"jishiqi",dplayer,0)--��ʱ������
		Char.UnsetLoopEvent(dplayer)--ж�ؼ�ʱ��
	end
	if seq == dplayer+29989 and sel == 4 then
		local outday = tonumber(Field.Get(dplayer,"blockenddate")) or -1--С���ݽ�������
		if outday > os.time() then
			outday = os.date("%Y-%m-%d %H:%M:%S",outday)
			local xunxi = "@c\\n������ڡ�"
			.."\\n"
			.."\\n"
			.."\\n"..Char.GetData(dplayer,%����_����%)
			.."\\n"
			.."\\n����̝Mጷ����ڞ飺"..outday
			NLG.ShowWindowTalked(dplayer,dnpc,%����_��Ϣ��%,%��ť_�ر�%,dplayer+29789,xunxi)
		else
			Field.Set(dplayer,"blockenddate",0)
			Field.Set(dplayer,"block",0)
			NLG.UpChar(dplayer)
			local xunxi = "@c\\n������ڡ�"
			.."\\n"
			.."\\n"..Char.GetData(dplayer,%����_����%)
			.."\\n"
			.."\\n���ѽ��̝Mጷţ��S�r�����x�_��"
			.."\\n"
			.."\\n�gӭ�ف�"
			NLG.ShowWindowTalked(dplayer,dnpc,%����_��Ϣ��%,%��ť_�ر�%,dplayer+29789,xunxi)
		end
	end
end

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
--K�з���ģ�62����ת������
--�汾��20240813
--��lua����������m�е��¿����
--�׷���̳ www.cnmlb.com ��ȡ���°汾

--���ڹ��ܱȽϷḻ����ѷ������ѡ�����bվ����ޡ�һ�����������ְɣ�
--https://space.bilibili.com/21127109
--qqȺ��85199642

--��luaֻ֧��cgmsv+�¿�ܣ���Ȼ100%�ܲ�����
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

local num62Tbl={
'0','1','2','3','4','5','6','7','8','9',
'a','b','c','d','e','f','g','h','i','j',
'k','l','m','n','o','p','q','r','s','t',
'u','v','w','x','y','z','A','B','C','D',
'E','F','G','H','I','J','K','L','M','N',
'O','P','Q','R','S','T','U','V','W','X',
'Y','Z',
}

--��ʮ������ֵת��Ϊ62����
--@param num integer @ʮ������ֵ
--@return string num62 @62�����ַ���
function from10to62(num)
	if num == nil then
	return nil
	end

	num = tonumber(num)
	local num62 =''
	while num > 0 do
		local remainder = math.qy(num,62)
		num62 = num62Tbl[remainder+1]..num62
		num = math.qs(num,62)
	end
	return num62
end

--��62�����ַ���תΪʮ������ֵ
--@param num62 string @62�����ַ���
--@return integer num @ʮ������ֵ
function from62to10(num62)
	if num62 == nil then
		return nil
	end
	local num = 0
	num62 = tostring(num62)
	local len = #num62
	for i= 1,len do
		local key = num62:sub(i,i)
		local idx=-1
		for j=1,#num62Tbl do
			if num62Tbl[j] == key then
				idx = j
				break
			end
		end
		num = num * 62 + idx - 1
	end
	return num
end

--ȡ������
--@param a integer @������
--@param b integer @����
--@return integer @����
function math.qy(a,b)
	return a - math.floor(a / b) * b
end

--ȡ������
--@param a integer @������
--@param b integer @����
--@return integer @��
function math.qs(a,b)
	return math.floor(a /b)
end

--ж��ģ�鹳��
function ahsin_gm_tool_ultraModule:onUnload()
	self:logInfo('unload')
end

return ahsin_gm_tool_ultraModule

