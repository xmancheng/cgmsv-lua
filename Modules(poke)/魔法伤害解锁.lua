-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
--ahsin做的：魔法伤害突破精神、魔攻限制 版本B
--版本：20251017
--本lua必须运行在m佬的新框架下
--首发论坛 www.cnmlb.com 获取最新版本

--由于功能比较丰富，免费分享归免费。过来b站点个赞、一键三连不过分吧？
--https://space.bilibili.com/21127109
--qq群：85199642

--本lua只支持cgmsv+新框架，不然100%跑不起来
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

local 魔法伤害解锁Module = ModuleBase:createModule('魔法伤害解锁')

function 魔法伤害解锁Module:onLoad()
    self:logInfo('load')
	self:regCallback('DamageCalculateEvent',Func.bind(self.魔法伤害解锁,self))--伤害计算
end

--★★★注意★★★
--由于怪无法获取魔抗，所以你魔攻高的话，打怪有+成
--由于怪无法获取魔攻，所以怪打你维持原版算法，此时你的魔抗就不计算了，不然怪打你1很傻，难度太低毫无体验
--魔抗魔攻pk不受任何限制，完全突破
--所以推荐bt服，堆精神
--精神不受任何限制，完全突破

local 魔攻浮动率 = {80,105}--80%~105%
local 魔抗浮动率 = {90,120}--90%~120%
local 精神浮动率 = {80,110}--80%~110%

function 魔法伤害解锁Module:魔法伤害解锁(攻击方, 被攻击方, 原生伤害, damage, battleIndex, com1, com2, com3, defCom1, defCom2, defCom3, flg, ExFlg)--伤害计算
	--魔攻、魔抗计算
	if flg == CONST.DamageFlags.Magic  then
		if Char.IsPet(攻击方) or Char.IsPlayer(攻击方) or Char.IsDummy(攻击方) then--攻击方为人、宠、假人
			if Char.IsPet(被攻击方) or Char.IsPlayer(被攻击方) or Char.IsDummy(被攻击方) then--被攻击方为人、宠、假人
				local 攻击方魔攻 = Char.GetData(攻击方,CONST.对象_魔攻)
				local 被攻击方魔抗 = Char.GetData(被攻击方,CONST.对象_魔抗)
				local 魔攻浮动比 = math.random(魔攻浮动率[1],魔攻浮动率[2])
				local 魔抗浮动比 = math.random(魔抗浮动率[1],魔抗浮动率[2])
				local 魔攻伤害 = 攻击方魔攻*0.1*魔攻浮动比*0.01--每100魔攻+10伤害*浮动
				local 被攻击方魔抗能力 = 被攻击方魔抗*0.1*魔抗浮动比*0.01--每100魔抗-10伤害*浮动
				local 补贴伤害 = 魔攻伤害 - 被攻击方魔抗能力
				原生伤害 = 原生伤害 + 补贴伤害
			elseif Char.IsEnemy(被攻击方) then--被攻击方为怪，怪无法获取魔攻魔抗，人、宠、假人获得优势
				local 攻击方魔攻 = Char.GetData(攻击方,CONST.对象_魔攻)
				local 魔攻浮动比 = math.random(魔攻浮动率[1],魔攻浮动率[2])
				local 魔攻伤害 = 攻击方魔攻*0.1*魔攻浮动比*0.01--每100魔攻+10伤害*浮动
				local 补贴伤害 = 魔攻伤害 * 0.8
				原生伤害 = 原生伤害 + 补贴伤害
			end
		end
		--精神计算
		local 攻击方精神 = Char.GetData(攻击方,CONST.对象_精神)
		local 被攻击方精神 = Char.GetData(被攻击方,CONST.对象_精神)
		local 精神浮动比 = math.random(精神浮动率[1],精神浮动率[2])
		if 攻击方精神 < 303 and 被攻击方精神 <= 303 then--精神都低于303
			return 原生伤害--用原生算法
		elseif 攻击方精神 >= 303 and 被攻击方精神 < 303 then--攻击方精神高于303，被攻击方精神低于303
			local 精神补贴伤害 = 精神浮动比*0.01*原生伤害*(2*攻击方精神-302)/302
			return 精神补贴伤害
		elseif 攻击方精神 < 303 and 被攻击方精神 >= 303 then--被攻击方精神高于303，攻击方精神低于303
			local 精神补贴伤害 = 精神浮动比*0.01*原生伤害*(604-被攻击方精神)/302
			if 精神补贴伤害 < 1 then
				精神补贴伤害 = 1
			end
			return 精神补贴伤害
		elseif 攻击方精神 >= 303 and 被攻击方精神 >= 303 then--攻击方精神高于303，被攻击方精神高于303
			local 精神补贴伤害 = 精神浮动比*0.01*原生伤害*(1+(攻击方精神-被攻击方精神)/302)
			if 精神补贴伤害 < 1 then
				精神补贴伤害 = 1
			end
			return 精神补贴伤害
		end
		return damage
	elseif flg ~= CONST.DamageFlags.Magic  then
		return damage
	end
	return damage
end

function 魔法伤害解锁Module:onUnload()
    self:logInfo('unload')
end

return 魔法伤害解锁Module
