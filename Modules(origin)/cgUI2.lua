-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
--ahsin：念小白cg拓展按钮lua
--本lua必须运行在m佬的新框架下
--首发论坛 www.cnmlb.com 获取最新版本
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

local cgUI2Module = ModuleBase:createModule('cgUI2')

function cgUI2Module:onLoad()
	self:logInfo('load')
	self:regCallback('ProtocolOnRecv',Func.bind(self.OnRecv,self),'CUSTOMXB')--封包匹配拦截
end

function cgUI2Module:OnRecv(fd,head,data)
	
	local player = Protocol.GetCharByFd(fd)
	--print('封包内容2：'..data[1])
	if data[1] == "0" then--整理背包
		NLG.SortItem(player)
		NLG.SystemMessage(player,"背包整理。");
	end
	if data[1] == "1" then--每日簽到
		getModule('SigninSheet'):signInInfo(self.signInNPC, player)
	end
	if data[1] == "2" then--一鍵打卡
		getModule('quickUI'):teamfever(self.feverNpc,player)
	end
	if data[1] == "3" then--一鍵恢復
		getModule('quickUI'):teamheal(self.healNpc,player)
	end
	if data[1] == "4" then--成員集中
		getModule('quickUI'):gather(player)
	end
	if data[1] == "5" then--一鍵算檔
		getModule('quickUI'):petinfo(player)
	end
	if data[1] == "6" then--異變改造
		getModule('convertPlans'):convertPlansInfo(self.converterNPC, player)
	end
	if data[1] == "7" then--星級超量
		getModule('petMaster'):petMasterInfo(self.MStarNPC, player)
	end
	if data[1] == "8" then--裝備插槽
		getModule('equipSlot'):equipSlotInfo(self.equipSloterNPC, player)
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
	if data[1] == "13" then--成員紀錄
		getModule('quickUI'):partyenter(player)
	end
	if data[1] == "14" then--成員集結
		getModule('quickUI'):partyform(player)
	end
	if data[1] == "15" then--移動加速
		getModule('quickUI'):walkingspeed(self.speedNpc,player)
	end
	if data[1] == "16" then--回城
		Char.Warp(player, 0, 1000, 242, 88)
		NLG.SystemMessage(player,"恭喜您已回城。");
	end
	return 0--必须留着，否则拦截
end

function cgUI2Module:onUnload()
	self:logInfo('unload');
end

return cgUI2Module;
