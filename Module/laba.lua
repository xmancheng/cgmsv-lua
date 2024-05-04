--                   #基本设置#
local limit_time = 2; 				--两次发喇叭间隔时间，单位秒
local laba_itemid = 1; 				--小喇叭的道具编号
local turn_on_key = "/online"; 	--玩家开启喇叭开关的命令
local turn_off_key = "/offline"; 	--玩家关闭喇叭开关的命令
--  ***************************************************************************************************** --

tbl_labaPlayer = {};
Delegate.RegDelLoginEvent("labaLoginEvent");
Delegate.RegDelAllOutEvent("labaOutEvent");
Delegate.RegDelTalkEvent("labaTalkEvent");
function new_labaplayerobject(player)
	local labaplayer = {
		index = player,
		isopen = true,
		limit_time = 0,
	};
	return labaplayer;
end

function labaLoginEvent(player)	
	tbl_labaPlayer[Playerkey(player)] = new_labaplayerobject(player);
end

function labaOutEvent(player)
	tbl_labaPlayer[Playerkey(player)] = nil;
end


function labaTalkEvent(player,msg,color,range,size)
	if(msg==turn_on_key) then 
		tbl_labaPlayer[Playerkey(player)].isopen = true;
		NLG.SystemMessage(player,"世界頻道接收已經開啟。");
		return 0;
	end
	
	if(msg==turn_off_key) then 
		tbl_labaPlayer[Playerkey(player)].isopen = false;
		NLG.SystemMessage(player,"世界頻道接收已經關閉。");
		return 0;
	end	
	
	
	if( check_msg(msg,">") ) then	
	
		local litime = tbl_labaPlayer[Playerkey(player)].limit_time;	
		if (os.time() - litime < limit_time )then
			NLG.SystemMessage(player,limit_time.."秒內禁止重複發話。");
			return 0;
		end
	
		if(Char.ItemNum(player,laba_itemid) >= 0)then
			
			for _,v in pairs (tbl_labaPlayer) do
				if(v.isopen == true)then
					NLG.SystemMessage(v.index,"[世界]"..Char.GetData(player,%对象_名字%)..": "..string.sub(msg,2));
				end
			end		
			--NLG.SystemMessage(player,"[世界]"..Char.GetData(player,%对象_名字%)..": "..string.sub(msg,2));
			Char.DelItem(player,laba_itemid,1);
			tbl_labaPlayer[Playerkey(player)].limit_time = os.time();
		else
			NLG.SystemMessage(player,"對不起您的小喇叭不足!");	
		end
		return 0;
	end

	return 1;
end
