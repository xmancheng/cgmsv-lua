--                   #��������#
local limit_time = 2; 				--���η����ȼ��ʱ�䣬��λ��
local laba_itemid = 1; 				--С���ȵĵ��߱��
local turn_on_key = "/online"; 	--��ҿ������ȿ��ص�����
local turn_off_key = "/offline"; 	--��ҹر����ȿ��ص�����
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
		NLG.SystemMessage(player,"�����l�������ѽ��_����");
		return 0;
	end
	
	if(msg==turn_off_key) then 
		tbl_labaPlayer[Playerkey(player)].isopen = false;
		NLG.SystemMessage(player,"�����l�������ѽ��P�]��");
		return 0;
	end	
	
	
	if( check_msg(msg,">") ) then	
	
		local litime = tbl_labaPlayer[Playerkey(player)].limit_time;	
		if (os.time() - litime < limit_time )then
			NLG.SystemMessage(player,limit_time.."��Ƚ�ֹ���}�lԒ��");
			return 0;
		end
	
		if(Char.ItemNum(player,laba_itemid) >= 0)then
			
			for _,v in pairs (tbl_labaPlayer) do
				if(v.isopen == true)then
					NLG.SystemMessage(v.index,"[����]"..Char.GetData(player,%����_����%)..": "..string.sub(msg,2));
				end
			end		
			--NLG.SystemMessage(player,"[����]"..Char.GetData(player,%����_����%)..": "..string.sub(msg,2));
			Char.DelItem(player,laba_itemid,1);
			tbl_labaPlayer[Playerkey(player)].limit_time = os.time();
		else
			NLG.SystemMessage(player,"����������С���Ȳ���!");	
		end
		return 0;
	end

	return 1;
end
