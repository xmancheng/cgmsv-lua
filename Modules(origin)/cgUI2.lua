-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
--ahsin����С��cg��չ��ťlua
--��lua����������m�е��¿����
--�׷���̳ www.cnmlb.com ��ȡ���°汾
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

local cgUI2Module = ModuleBase:createModule('cgUI2')

function cgUI2Module:onLoad()
	self:logInfo('load')
	self:regCallback('ProtocolOnRecv',Func.bind(self.OnRecv,self),'CUSTOMXB')--���ƥ������
end

function cgUI2Module:OnRecv(fd,head,data)
	
	local player = Protocol.GetCharByFd(fd)
	--print('�������2��'..data[1])
	if data[1] == "1" then--һ�I��
		getModule('quickUI'):teamfever(self.feverNpc,player)
	end
	if data[1] == "2" then--һ�I�֏�
		getModule('quickUI'):teamheal(self.healNpc,player)
	end
	if data[1] == "3" then--�ɆT�o�
		getModule('quickUI'):partyenter(player)
	end
	if data[1] == "4" then--�ɆT���Y
		getModule('quickUI'):partyform(player)
	end
	if data[1] == "5" then--�ɆT����
		getModule('quickUI'):gather(player)
	end
	if data[1] == "6" then--�ƄӼ���
		getModule('quickUI'):walkingspeed(self.speedNpc,player)
	end
	if data[1] == "7" then--һ�I��n
		getModule('quickUI'):petinfo(player)
	end
	if data[1] == "8" then--������
		NLG.SortItem(player)
		NLG.SystemMessage(player,"��������");
	end
	if data[1] == "9" then--
		getModule('bag'):onTalkEvent(player, '/bag 1', 0, 1, 1);
	end
	if data[1] == "10" then--
		getModule('bag'):onTalkEvent(player, '/bag 2', 0, 1, 1);
	end
	if data[1] == "11" then--
		getModule('bag'):onTalkEvent(player, '/bag 3', 0, 1, 1);
	end
	if data[1] == "12" then--
		getModule('bag'):onTalkEvent(player, '/bag 4', 0, 1, 1);
	end
	if data[1] == "13" then--
		Char.Warp(player, 0, 1000, 242, 88)
		NLG.SystemMessage(player,"��ϲ���ѻسǡ�");
	end
	return 0--�������ţ���������
end

function cgUI2Module:onUnload()
	self:logInfo('unload');
end

return cgUI2Module;
