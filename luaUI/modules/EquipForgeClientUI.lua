local 强化装备Module = ModuleBase:extend('EquipForgeClientUI')

local function 居中X(宽)
    if CONST and CONST.Screen and CONST.Screen.Width then
        return math.floor((CONST.Screen.Width - 宽) / 2)
    end
    return 0
end
local function 居中Y(高)
    if CONST and CONST.Screen and CONST.Screen.Height then
        return math.floor((CONST.Screen.Height - 高) / 2)
    end
    return 0
end

local 开启按钮id = 80017
local 开启按钮宽 = 25
local 开启按钮高 = 25
local 开启按钮边距右 = 5
local 开启按钮边距顶 = 50

local 图片面板窗体id = 80006
local 图片面板宽 = 507
local 图片面板高 = 315
local 图片面板x = 0
local 图片面板y = 0

local 面板坐标 = {
    关闭按钮 = {x=464, y=9, 宽=12, 高=12},
    道具放置 = {x=79, y=191, 宽=50, 高=50},
    中心图标 = {宽=32, 高=32},
    槽下文字 = {x=91, y=228, 宽=26, 高=16, 默认文字='+0', 字体=1, 颜色=0},
    数量文字 = {宽=50, 高=16, 偏移x=-2, 偏移y=-2, 字体=1, 颜色=1, 数字宽=7},
    放置取回按钮 = {x=390, y=246, 宽=55, 高=19},
    取回按钮 = {x=64, y=270, 宽=20, 高=19},
    强化按钮 = {x=127, y=242, 宽=55, 高=19},
    镶嵌装备格 = {x=43, y=176, 宽=50, 高=50},
    镶嵌宝石格 = {x=118, y=176, 宽=50, 高=50},
    合成格 = {x=80, y=111, 宽=50, 高=50},
    镶嵌发光条带 = {x=34, y=102, 宽=143, 高=133},
    镶嵌按键 = {x=127, y=242, 宽=55, 高=19},
    左翻页 = {x=315, y=245, 宽=20, 高=20},
    右翻页 = {x=366, y=245, 宽=20, 高=20},
    银行丢弃按键 = {x=43, y=270, 宽=20, 高=19},
    修理按键 = {x=22, y=270, 宽=20, 高=19},
    删除丢弃按键 = {x=204, y=246, 宽=20, 高=19},
    页码文字 = {x=338, y=248, 宽=26, 高=15, 字体=1, 颜色=11},
    文字显示 = {x=0, y=0, 宽=192, 高=162},
    金钱显示 = {x=28, y=243, 宽=98, 高=18},
    金钱文字 = {x=59, y=245, 宽=0, 高=15, 字体=1, 颜色=127},

    -- 潜能分页：左侧上半部两块潜能信息，下半部装备/道具槽。
    潜能主要框 = {x=18, y=22, 宽=160, 高=70},
    潜能附加框 = {x=18, y=88, 宽=160, 高=70},
    潜能装备格 = {x=43, y=176, 宽=50, 高=50},
    潜能道具格 = {x=118, y=176, 宽=50, 高=50},
    潜能按键 = {x=127, y=242, 宽=55, 高=19},
    潜能金币文字 = {x=60, y=224, 宽=105, 高=16},
}
local 金钱文字宽度缩减 = 27
local 金钱数字宽 = 7

local 装备区起始X = 26
local 装备区起始Y = 38
local 装备格宽 = 50
local 装备格高 = 50
local 装备列步进 = 53
local 装备行步进 = 51
local 装备格文字样式 = {
    字体 = 9, 颜色 = 11, 偏移X = 13, 偏移Y = 17,
}

local 背包区起始X = 198
local 背包区起始Y = 38
local 背包格宽 = 50
local 背包格高 = 50
local 背包列步进 = 51
local 背包行步进 = 51
local 背包列数 = 5

local 右栏背包起始X = 456
local 右栏背包起始Y = 33
local 右栏背包宽 = 21
local 右栏背包高 = 48
local 右栏背包间距 = 0

local 银行窗体id = 80011
local 银行窗宽 = 454
local 银行窗高 = 324
local 银行窗x = 0
local 银行窗y = 0
local 银行格宽 = 50
local 银行格高 = 50
local 银行格列步进 = 51
local 银行格行步进 = 51
local 银行列数 = 8
local 银行格起始X = 16
local 银行格起始Y = 30
local 银行页按键y = 289
local 银行页按键起始X = 23
local 银行页按键宽 = 23
local 银行页按键高 = 21
local 银行页按键间距 = 3

local 悬停样式 = {
    名称 = {字体=12, 颜色=0, 偏移X=13, 偏移Y=13, 宽=220, 高=20, 每汉字宽=12, 每符号宽=7},
    等级 = {间距=4, 字体=9, 颜色=11, 前缀='等级 '},
    耐久 = {字体=9, 颜色=120, 偏移Y=28, 宽=120, 高=15},
    种类 = {间距=5, 字体=9, 颜色=113, 宽=120, 高=15},
    属性 = {字体=9, 颜色=0, 列偏移X={13,68,125}, 起始偏移Y=43, 行高=15, 宽=52, 高=15, 最大行数=14},
}
local 悬停套装宝石样式 = {
    套装 = {
        标题 = {字体=9, 颜色=48},
        内容 = {字体=9, 颜色=49},
        偏移X = 13, 高 = 15, 行高 = 15, 间隔Y = 2,
    },
    宝石 = {
        标题 = {字体=9, 颜色=48},
        内容 = {字体=9, 颜色=49},
        偏移X = 13, 高 = 15, 行高 = 15, 间隔Y = 2,
    },
}
local 悬停潜能品质样式 = {
    标题 = {字体=9, 颜色=48, 偏移X=13},
    主要 = {字体=9, 宽=42},
    附加 = {字体=9, 宽=42},
    行高 = 15, 间隔Y = 2,
}

local 修理提示框id = 80012
local 修理提示框宽 = 150
local 修理提示框高 = 110
local 修理提示框x = 0
local 修理提示框y = 0
local 修理确定按键 = {x=20, y=82, 宽=51, 高=19}
local 修理取消按键 = {x=79, y=82, 宽=51, 高=19}

local 进补配置 = {
    窗体id = 80013,
    窗体宽 = 396,
    窗体高 = 260,
    窗体x = 0,
    窗体y = 0,
    
    按钮起始X = 25,
    按钮起始Y = 160,
    按钮组间距 = 70,
    进补选择间距 = 0,
    组数 = 5,
    进补按钮宽 = 20,
    进补按钮高 = 19,
    选择按钮宽 = 20,
    选择按钮高 = 19,
	
    选择按钮偏移X = 17,
    选择按钮偏移Y = 17,
	
    进补按钮偏移X = -1,
    进补按钮偏移Y = -3,
    
    队员起始X = 30,
    队员起始Y = 104,
    队员间距 = 68,
    队员图档宽 = 48,
    队员图档高 = 64,
    
	血蓝背景偏移X = 1,
    血蓝背景偏移Y = 54,
    血蓝背景宽 = 49,
    血蓝背景高 = 17,
    
    血条背景内偏移X = 13,
    血条背景内偏移Y = 6,
    血条宽 = 34,
    血条高 = 4,
    
    蓝条背景内偏移X = 13,
    蓝条背景内偏移Y = 9,
    蓝条宽 = 34,
    蓝条高 = 4,

    踢出按钮宽 = 20,
    踢出按钮高 = 19,
    踢出按钮偏移X = 36,
    踢出按钮偏移Y = 17,

    队长标志宽 = 13,
    队长标志高 = 11,
    队长标志偏移X = -6,
    队长标志偏移Y = -67,

    职业文字偏移X = -4,
    职业文字偏移Y = 50,
    职业文字宽 = 64,
    职业文字高 = 15,
    职业文字字体 = 9,
    职业文字颜色 = 11,
    等级文字偏移X = -3,
    等级文字偏移Y = 69,
    等级文字宽 = 57,
    等级文字高 = 15,
    等级文字字体 = 9,
    等级文字颜色 = 11,

    关闭按钮偏移X = 43,
    关闭按钮偏移Y = 9,
    关闭按钮宽 = 12,
    关闭按钮高 = 12,

    后退按钮偏移X = 19,
    后退按钮偏移Y = 9,
    后退按钮宽 = 16,
    后退按钮高 = 17,
}

local 背包格种类 = {}
local 银行格种类 = {}

local 队员信息列表 = {}
local 进补刷新计数 = 0
local 进补同步计数 = 0
local 自己职业 = ''
local 自己等级 = 0
local 自己是否队长 = false

local 宠物进补数据 = {
    物品来源 = '',
    物品槽位 = -1,
    物品页 = 1,
    物品模式 = '',
    信息列表 = {},
    目标位置 = 1,
    窗体对象 = nil,
    图档控件列表 = {},
    血蓝背景列表 = {},
    血条列表 = {},
    蓝条列表 = {},
    按钮列表 = {},
    名称文字列表 = {},
    等级文字列表 = {},
    刷新计数 = 0,
    同步计数 = 0,
}

local 资源目录 = 'luaUI/modules/cg图档集/强化面板/'
local 宝石图标名 = {'冒险之星', '石榴石', '骑士宝石', '黄宝石', '蓝宝石', '绿宝石', '紫水晶'}
local 宝石ID下限 = 13600
local 宝石角标最大数 = 5

local 宝石显示配置 = {
    效果文本 = {
        起始X = 33,
        起始Y = 44,
        标题 = {
            文本 = '宝石效果：',
            字体 = 9,
            颜色 = 53,
            高 = 15,
            汉字宽 = 12,
            符号宽 = 7,
        },
        内容 = {
            字体 = 9,
            颜色 = 74,
            高 = 15,
            汉字宽 = 7,
            符号宽 = 4,
        },
        每行个数 = 2,
        行数 = 2,
        行间距 = 2,
        列间距 = 35,
    },
    角标 = {
        起始偏移X = 5,
        起始偏移Y = 38,
        间距 = 0,
        大宝石 = {
            偏移X = -1,
            偏移Y = 0,
        },
        小宝石 = {
            偏移X = -1,
            偏移Y = 1,
        },
        装备格偏移X = 0,
        装备格偏移Y = 0,
        背包格偏移X = 0,
        背包格偏移Y = 0,
        银行格偏移X = 0,
        银行格偏移Y = 0,
    },
}

local function 金钱文字坐标(金额)
    local 文字 = tostring(tonumber(金额) or 0)
    return 面板坐标.金钱显示.x + 面板坐标.金钱显示.宽 - #文字 * 金钱数字宽 - 金钱文字宽度缩减
end

local function 文本像素宽(文本)
    local 字节数 = #文本
    local 符号数 = 0
    for i = 1, 字节数 do
        if string.byte(文本, i) < 128 then 符号数 = 符号数 + 1 end
    end
    return (字节数 - 符号数) / 2 * 悬停样式.名称.每汉字宽 + 符号数 * 悬停样式.名称.每符号宽
end

local function 宝石效果文本宽(文本, 汉字宽, 符号宽)
    if 文本 == '' then return 0 end
    local 字节数 = #文本
    local 符号数 = 0
    for i = 1, 字节数 do
        if string.byte(文本, i) < 128 then 符号数 = 符号数 + 1 end
    end
    return (字节数 - 符号数) / 2 * (汉字宽 or 7) + 符号数 * (符号宽 or 4)
end

local 当前背包页 = 1
local 最大背包页 = 5
local 翻页音效 = 68
local 整理音效 = 73

local 银行面板下移中 = false
local 银行窗体对象 = nil
local 银行格控件列表 = {}
local 银行格图标控件列表 = {}
local 银行格图号 = {}
local 银行格数量 = {}
local 银行格等级 = {}
local 银行格宝石种类 = {}
local 银行格宝石等级 = {}
local 当前银行页 = 0
local 最大银行页 = 5
local 银行左翻页控件 = nil
local 银行右翻页控件 = nil
local 银行页码文字控件 = nil
local 银行整理按钮控件 = nil
local 银行丢弃删除按键控件 = nil
local 银行拖拽图标控件 = nil
local 银行拖拽数量控件 = nil
local 银行页按键控件列表 = {}
local 银行格数量控件列表 = {}
local 悬停银行格 = nil
local 上次点击银行槽位 = nil
local 上次银行点击时间 = nil
local 上次银行点击帧 = -1

local 修理提示框窗体对象 = nil
local 修理提示框窗体状态 = nil

local 图片面板窗体对象 = nil
local 中心图标控件 = nil
local 槽下文字控件 = nil
local 整理按钮控件 = nil
local 强化按钮控件 = nil
local 左翻页控件 = nil
local 右翻页控件 = nil
local 银行丢弃按键控件 = nil
local 修理按键控件 = nil
local 删除丢弃按键控件 = nil
local 取回镶嵌按钮控件 = nil
local 页码文字控件 = nil
local 道具放置槽控件 = nil
local 背景控件 = nil
local 丢弃遮罩控件 = nil
local 金钱显示控件 = nil
local 金钱文字控件 = nil
local 披风格控件 = nil
local 披风格文字控件 = nil
local 金钱同步计数 = 0

local 拾起中 = false
local 拾起来源 = nil
local 拖拽图标控件 = nil
local 拖拽数量文字控件 = nil
local 拖拽数量可见 = false
local 拖拽数量 = 0
local 上次拖拽图标x = -9999
local 上次拖拽图标y = -9999
local 上次银行拖拽图标x = -9999
local 上次银行拖拽图标y = -9999
local 银行图标已隐藏 = true
local 面板图标在银行区 = false
local 拖拽图标宽 = 36
local 拖拽图标高 = 36
local 背包格控件列表 = {}
local 背包格图标控件列表 = {}
local 背包格数量控件列表 = {}
local 背包格槽位列表 = {}
for i = 1, 20 do 背包格槽位列表[i] = 7 + i end
local 背包格图号 = {}
local 背包格数量 = {}
local 背包格等级 = {}
local 背包格宝石种类 = {}
local 背包格宝石等级 = {}

local 右栏背包控件列表 = {}
local 右栏背包占用 = {0, 0, 0, 0, 0}

local 装备格位置 = {
    {行=1, 列=1, 名称='首饰'},
    {行=1, 列=2, 名称='头部'},
    {行=1, 列=3, 名称='首饰'},
    {行=2, 列=1, 名称='右手'},
    {行=2, 列=3, 名称='左手'},
    {行=3, 列=1, 名称='身体'},
    {行=3, 列=3, 名称='脚部'},
    {行=4, 列=3, 名称='水晶'},
}

local 装备格控件列表 = {}
local 装备格图标控件列表 = {}
local 装备格图号 = {}
local 装备格等级 = {}
local 装备格宝石种类 = {}
local 装备格宝石等级 = {}
local 装备格文字控件列表 = {}
local 强化槽文字控件 = nil

local 角色图档控件 = nil

local 玩家形象图号 = 0
local 上次点击槽位 = nil
local 上次点击时间 = nil
local 帧计数 = 0
local 上次点击帧 = -1
local 上次左键按下 = false

local 颜色分组映射 = {
    ["攻击"]=1, ["防御"]=1, ["敏捷"]=1, ["精神"]=1, ["回复"]=1,
    ["生命"]=1, ["魔力"]=1,
    ["耐力"]=11, ["灵巧"]=11, ["智力"]=11,
    ["必杀"]=4, ["反击"]=4, ["命中"]=4, ["闪躲"]=4,
    ["毒抗"]=2,  ["睡抗"]=2,  ["石抗"]=2,  ["醉抗"]=2,
    ["乱抗"]=2,  ["忘抗"]=2,
    ["魔抗"]=2, ["魔攻"]=2
}

local 强化槽显示 = 0
local 强化槽图号 = 0
local 当前强化等级 = 0
local 当前道具ItemIndex = -1

-- 潜能分页状态。随机结果、品质提升、金币及道具扣除必须由服务端判定。
local 潜能模式 = false
local 潜能状态 = {
    装备格 = {显示=0, 图号=0, 等级=0},
    道具格 = {显示=0, 图号=0, 数量=0, 类型=0},
    主要开启 = false,
    附加开启 = false,
    主要品质 = 0,
    附加品质 = 0,
    主要效果 = {},
    附加效果 = {},
    金币需求 = 0,
}
local 潜能品质名称 = {[1]='特殊', [2]='稀有', [3]='罕见', [4]='传说'}
local 潜能品质颜色 = {[1]=68, [2]=92, [3]=120, [4]=48}	--77亮紫80淡紫84淺綠87亮紅89紫紅91暗粉

-- 260~269 为本客户端预留的潜能协议号；当前 customxb_handler.lua 尚未定义这些参数。
local 潜能协议 = {
    查询 = 260,
    放入装备 = 261,
    放入道具 = 262,
    开启主要 = 263,
    重洗主要 = 264,
    开启附加 = 265,
    重洗附加 = 266,
    取回装备 = 267,
    取回道具 = 268,
    悬停装备 = 269,
}

local 悬停装备格 = nil
local 悬停背包格 = nil
local 悬停强化槽 = false
local 悬停镶嵌格 = nil
local 悬停提示中 = false
local 悬停提示背景控件 = nil
local 悬停提示行控件 = {}
local 悬停提示父窗体 = nil
local 当前悬停提示高 = 0

local 装备格类型说明 = {
    '首饰格：戒指/项链/耳环等首饰',
    '头部格：帽子/头盔',
    '首饰格：戒指/项链/耳环等首饰',
    '武器格：武器',
    '盾牌格：盾牌',
    '身体格：铠甲/衣服/长袍',
    '脚部格：鞋子/靴子',
    '水晶格：水晶',
}

local function 取属性颜色(属性文本)
    local 属性名 = string.match(属性文本, "^(.-):")
    return 颜色分组映射[属性名] or 0
end

function 强化装备Module:onLoad()
    WinMgr.PlaySe(73,320)

    self.缓存潜能文本 = self.缓存潜能文本 or ''
    self.缓存潜能主要品质 = self.缓存潜能主要品质 or 0
    self.缓存潜能附加品质 = self.缓存潜能附加品质 or 0
    self.缓存镶嵌潜能资料 = self.缓存镶嵌潜能资料 or {
        装备格 = {文本='', 主要品质=0, 附加品质=0},
        合成格 = {文本='', 主要品质=0, 附加品质=0},
    }
    self.缓存装备悬停资料 = self.缓存装备悬停资料 or {}
    self.当前悬停Tooltip上下文 = self.当前悬停Tooltip上下文 or nil
    self.当前悬停潜能来源类型 = self.当前悬停潜能来源类型 or nil
    self.当前悬停潜能来源索引 = self.当前悬停潜能来源索引 or nil

    self:onPacketRecv('XBCENTER', function(header, params)
        local show = tonumber(params[1]) or 0

        -- show=3：使用現有 XBCENTER 回傳潛能 Tooltip 快取。
        -- params[10] = 潛能文字
        -- params[11] = 主要潛能品質
        -- params[12] = 附加潛能品質
        if show == 3 then
            local potentialText = tostring(params[10] or '')
            local mainQuality = tonumber(params[11]) or 0
            local addQuality = tonumber(params[12]) or 0
            local sourceType = tostring(params[13] or '')
            local sourceIndex = tostring(params[14] or '')

            if sourceType == 'inlay_equip' or sourceIndex == '装备格' then
                self.缓存镶嵌潜能资料.装备格 = {文本=potentialText, 主要品质=mainQuality, 附加品质=addQuality}
                if self.当前悬停Tooltip上下文 and self.当前悬停Tooltip上下文.type == 'inlay' and tostring(self.当前悬停Tooltip上下文.index or '') == '装备格' then
                    pcall(function() self:刷新当前悬停装备Tooltip() end)
                end
            elseif sourceType == 'inlay_result' or sourceIndex == '合成格' then
                self.缓存镶嵌潜能资料.合成格 = {文本=potentialText, 主要品质=mainQuality, 附加品质=addQuality}
                if self.当前悬停Tooltip上下文 and self.当前悬停Tooltip上下文.type == 'inlay' and tostring(self.当前悬停Tooltip上下文.index or '') == '合成格' then
                    pcall(function() self:刷新当前悬停装备Tooltip() end)
                end
            else
                self.缓存潜能文本 = potentialText
                self.缓存潜能主要品质 = mainQuality
                self.缓存潜能附加品质 = addQuality
                pcall(function() self:刷新当前悬停装备Tooltip() end)
            end
            return
        end

        if show == 2 then return end
        强化槽显示 = show
        强化槽图号 = tonumber(params[2]) or 0
        当前强化等级 = tonumber(params[3]) or 0
        当前道具ItemIndex = tonumber(params[4]) or -1
        local 整体文本 = tostring(params[5] or "")
        整体文本 = string.gsub(整体文本, "\\S", " ")
        self.缓存属性文本 = 整体文本
        local 耐久文本 = tostring(params[6] or '')
        local 种类文本 = tostring(params[7] or '')
        local 套装文本 = tostring(params[8] or '')
        local 宝石文本 = tostring(params[9] or '')
        if params[10] ~= nil or params[11] ~= nil or params[12] ~= nil then
            self.缓存潜能文本 = tostring(params[10] or '')
            self.缓存潜能主要品质 = tonumber(params[11]) or 0
            self.缓存潜能附加品质 = tonumber(params[12]) or 0
        end
        耐久文本 = string.gsub(耐久文本, "\\S", " ")
        种类文本 = string.gsub(种类文本, "\\S", " ")
        套装文本 = string.gsub(套装文本, "\\S", " ")
        宝石文本 = string.gsub(宝石文本, "\\S", " ")
        self.缓存耐久文本 = 耐久文本
        self.缓存种类文本 = 种类文本
        if 悬停背包格 and 悬停背包格 > 0 then
            背包格种类[悬停背包格] = 种类文本
        end
        if 悬停银行格 and 悬停银行格 > 0 then
            银行格种类[悬停银行格] = 种类文本
        end
        self.缓存套装文本 = 套装文本
        self.缓存宝石文本 = 宝石文本
        if 悬停强化槽 then
            self:显示悬停提示(整体文本, 当前强化等级, 耐久文本, 种类文本, 套装文本, 宝石文本, self:取得缓存潜能资料())
        end
        self:刷新强化槽显示()
    end)

    self:onPacketRecv('CUSTOMBAG', function(header, params)
        local 串 = tostring(params[1] or '')
        local i = 1
        for 单个 in string.gmatch(串, "([^,]+)") do
            local 图号, 数量, 等级, 宝石种类, 宝石等级 = string.match(单个, "^(%d+):(%d+):(%d+):(%d+):(%d+)$")
            if not 图号 then
                图号, 数量, 等级 = string.match(单个, "^(%d+):(%d+):(%d+)$")
            end
            背包格图号[i] = tonumber(图号) or 0
            背包格数量[i] = tonumber(数量) or 0
            背包格等级[i] = tonumber(等级) or 0
            背包格宝石种类[i] = tonumber(宝石种类) or 0
            背包格宝石等级[i] = tonumber(宝石等级) or 0
            i = i + 1
        end
        self:刷新背包格()
    end)

    self:onPacketRecv('RIGHTBAG', function(header, params)
        local 串 = tostring(params[1] or '')
        local i = 1
        for 单个 in string.gmatch(串, "([^,]+)") do
            右栏背包占用[i] = tonumber(单个) or 0
            i = i + 1
        end
        self:刷新右栏背包按键()
    end)

    self:onPacketRecv('CUSTOMBANK', function(header, params)
        local 串 = tostring(params[1] or '')
        local i = 1
        for 单个 in string.gmatch(串, "([^,]+)") do
            local 图号, 数量, 等级, 宝石种类, 宝石等级 = string.match(单个, "^(%d+):(%d+):(%d+):(%d+):(%d+)$")
            if not 图号 then
                图号, 数量, 等级 = string.match(单个, "^(%d+):(%d+):(%d+)$")
            end
            银行格图号[i] = tonumber(图号) or 0
            银行格数量[i] = tonumber(数量) or 0
            银行格等级[i] = tonumber(等级) or 0
            银行格宝石种类[i] = tonumber(宝石种类) or 0
            银行格宝石等级[i] = tonumber(宝石等级) or 0
            i = i + 1
        end
        self:刷新银行格()
    end)

    self:onPacketRecv('CUSTOMEQUIP', function(header, params)
        玩家形象图号 = tonumber(params[1]) or 0
        local 串 = tostring(params[2] or '')
        local i = 1
        for 单个 in string.gmatch(串, "([^,]+)") do
            local 图号, 等级, 宝石种类, 宝石等级 = string.match(单个, "^(%d+):(%d+):(%d+):(%d+)$")
            if not 图号 then
                图号, 等级 = string.match(单个, "^(%d+):(%d+)$")
            end
            装备格图号[i] = tonumber(图号) or 0
            装备格等级[i] = tonumber(等级) or 0
            装备格宝石种类[i] = tonumber(宝石种类) or 0
            装备格宝石等级[i] = tonumber(宝石等级) or 0
            i = i + 1
        end
        self:刷新装备格()
    end)

    self:onPacketRecv('XQSTATE', function(header, params)
        self.镶嵌状态 = {
            装备格 = {显示=tonumber(params[1]) or 0, 图号=tonumber(params[2]) or 0, 等级=tonumber(params[3]) or 0},
            宝石格 = {显示=tonumber(params[9]) or 0, 图号=tonumber(params[10]) or 0, 等级=tonumber(params[11]) or 0},
            合成格 = {显示=tonumber(params[13]) or 0, 图号=tonumber(params[14]) or 0, 等级=tonumber(params[15]) or 0},
        }
        self.缓存镶嵌文本 = {
            装备格 = tostring(params[4] or ''),
            宝石格 = tostring(params[12] or ''),
            合成格 = tostring(params[16] or ''),
        }
        self.缓存镶嵌副文本 = {
            装备格 = {durab=tostring(params[5] or ''), type=tostring(params[6] or ''), set=tostring(params[7] or ''), gem=tostring(params[8] or '')},
            合成格 = {durab=tostring(params[17] or ''), type=tostring(params[18] or ''), set=tostring(params[19] or ''), gem=tostring(params[20] or '')},
        }
        self.镶嵌宝石信息 = {
            合成格 = tonumber(params[21]) or 0,
            装备格 = tonumber(params[22]) or 0,
            宝石格 = tonumber(params[23]) or 0,
            宝石格效果 = tostring(params[24] or ''),
            合成格效果 = tostring(params[25] or ''),
        }
        self:刷新镶嵌槽()
        if 悬停镶嵌格 == '装备格' or 悬停镶嵌格 == '合成格' then
            pcall(function() self:刷新当前悬停装备Tooltip() end)
        end
    end)

    -- 潜能状态：
    -- 1 装备显示 2 装备图号 3 装备等级
    -- 4 主潜开启 5 主潜品质
    -- 6 附潜开启 7 附潜品质
    -- 8 主潜三条（|分隔） 9 附潜三条（|分隔）
    -- 10 道具显示 11 道具图号 12 道具数量 13 道具类型 14 本次金币需求
    self:onPacketRecv('POTSTATE', function(header, params)
        潜能状态.装备格 = {
            显示=tonumber(params[1]) or 0,
            图号=tonumber(params[2]) or 0,
            等级=tonumber(params[3]) or 0,
        }
        潜能状态.主要开启 = (tonumber(params[4]) or 0) == 1
        潜能状态.主要品质 = tonumber(params[5]) or 0
        潜能状态.附加开启 = (tonumber(params[6]) or 0) == 1
        潜能状态.附加品质 = tonumber(params[7]) or 0

        潜能状态.主要效果 = {}
        local 主串 = tostring(params[8] or '')
        if 主串 ~= '' then
            for 单条 in string.gmatch(主串, '[^|]+') do
                table.insert(潜能状态.主要效果, 单条)
            end
        end

        潜能状态.附加效果 = {}
        local 附串 = tostring(params[9] or '')
        if 附串 ~= '' then
            for 单条 in string.gmatch(附串, '[^|]+') do
                table.insert(潜能状态.附加效果, 单条)
            end
        end

        潜能状态.道具格 = {
            显示=tonumber(params[10]) or 0,
            图号=tonumber(params[11]) or 0,
            数量=tonumber(params[12]) or 0,
            类型=tonumber(params[13]) or 0,
        }
        潜能状态.金币需求 = tonumber(params[14]) or 0
        self:刷新潜能界面()
    end)

    -- 潜能装备格悬停详细资料：沿用镶嵌/背包装备 Tooltip。
    -- params: 1图号 2强化等级 3整体文本 4耐久 5种类 6套装 7宝石 8主潜品质 9附潜品质
	self:onPacketRecv('POTINFO', function(header, params)
        if self.潜能悬停格 ~= '装备' then return end
        local 图 = tonumber(params[1]) or 0
        local 强化等级 = tonumber(params[2]) or 0
        local 整体 = tostring(params[3] or '')
        if 图 <= 0 or 整体 == '' then
            self:隐藏悬停提示()
            return
        end
        local 潜能资料 = self:取得缓存潜能资料() or {
            主要品质 = tonumber(params[8]) or 0,
            附加品质 = tonumber(params[9]) or 0,
        }
        self:显示悬停提示(
            整体, 强化等级,
            tostring(params[4] or ''), tostring(params[5] or ''),
            tostring(params[6] or ''), tostring(params[7] or ''),
            潜能资料
        )
    end)

    self:onPacketRecv('POTMSG', function(header, params)
        local 文本 = tostring(params[1] or '')
        if 文本 ~= '' then self:cliSendMsg(文本, 4) end
    end)

    self:onPacketRecv('EQUIPINFO', function(header, params)
        local 格 = tonumber(params[1]) or -1
        if 悬停装备格 ~= 格 then return end
        local 图 = tonumber(params[2]) or 0
        local 文本 = tostring(params[4] or '')
        if 图 > 0 and 文本 ~= '' then
            self.缓存装备悬停资料[格] = {
                图号 = 图,
                文本 = 文本,
                等级 = tonumber(params[3]) or 0,
                耐久 = tostring(params[5] or ''),
                种类 = tostring(params[6] or ''),
                套装 = tostring(params[7] or ''),
                宝石 = tostring(params[8] or ''),
            }
            pcall(function() self:刷新当前悬停装备Tooltip() end)
        else
            self.缓存装备悬停资料[格] = nil
            self:显示装备格类型提示(格)
        end
    end)

    self:onPacketRecv('BAGINFO', function(header, params)
        local 格 = tonumber(params[1]) or -1
        if 悬停背包格 ~= 格 then return end
        local 图 = tonumber(params[2]) or 0
        local 文本 = tostring(params[4] or '')
        if 图 > 0 and 文本 ~= '' then
            pcall(function() self:显示悬停提示(文本, params[3], params[5], params[6], params[7], params[8], self:取得缓存潜能资料()) end)
        else
            self:隐藏悬停提示()
        end
    end)

    self:onPacketRecv('BANKINFO', function(header, params)
        local 格 = tonumber(params[1]) or -1
        if 悬停银行格 ~= 格 then return end
        local 图 = tonumber(params[2]) or 0
        local 文本 = tostring(params[4] or '')
        if 图 > 0 and 文本 ~= '' then
            pcall(function() self:显示悬停提示(文本, params[3], params[5], params[6], params[7], params[8], self:取得缓存潜能资料()) end)
        else
            self:隐藏悬停提示()
        end
    end)

    self:onPacketRecv('MONEY', function(header, params)
        local 金额 = tonumber(params[1]) or 0
        if 金钱文字控件 and 金钱文字控件.valid then
            金钱文字控件:Set({x = 金钱文字坐标(金额), text = tostring(金额)})
        end
    end)

    self:onPacketRecv('BAGPAGE', function(header, params)
        local 当前 = tonumber(params[1]) or 0
        local 总数 = tonumber(params[2]) or 0
        if 当前 < 1 then 当前 = 1 end
        if 总数 < 1 then 总数 = 1 end
        当前背包页 = 当前
        最大背包页 = 总数
        self:更新背包槽位列表()
        self:刷新页码文字()
        self:刷新背包格()
    end)

    self:onPacketRecv('XBPARTY', function(header, params)
        自己职业 = tostring(params[1] or '')
        自己等级 = tonumber(params[2]) or 0
        自己是否队长 = (tonumber(params[3]) or 0) == 1
        队员信息列表 = {}
        local 串 = tostring(params[4] or '')
        if 串 ~= '' then
            for 单条 in string.gmatch(串, '([^,]+)') do
                local 图号, 血, 最大血, 魔, 最大魔, 名字, 职业, 等级, 队长 =
                    string.match(单条, '^(%d+):(%d+):(%d+):(%d+):(%d+):([^:]*):([^:]*):(%d+):(%d+)$')
                if 图号 then
                    table.insert(队员信息列表, {
                        图号 = tonumber(图号),
                        hp = tonumber(血),
                        maxHp = tonumber(最大血),
                        fp = tonumber(魔),
                        maxFp = tonumber(最大魔),
                        名字 = 名字 or '',
                        职业 = 职业 or '',
                        等级 = tonumber(等级) or 0,
                        队长 = (tonumber(队长) or 0) == 1,
                    })
                end
            end
        end
        self:刷新队员显示()
    end)

    self:onPacketRecv('XBPCATT', function(header, params)
        宠物进补数据.信息列表 = {}
        local pos = tonumber(params[1]) or 0
        宠物进补数据.目标位置 = pos + 1
        local 串 = tostring(params[2] or '')
        local i = 0
        if 串 ~= '' then
            for 单条 in string.gmatch(串, '([^,]+)') do
                i = i + 1
                if i > 5 then break end
                if 单条 ~= '0' then
                    local 图号, 名字, 等级, 血, 最大血, 魔, 最大魔 =
                        string.match(单条, '^(%d+):([^:]*):(%d+):(%d+):(%d+):(%d+):(%d+)$')
                    if 图号 then
                        宠物进补数据.信息列表[i] = {
                            图号 = tonumber(图号),
                            名字 = 名字 or '',
                            等级 = tonumber(等级) or 0,
                            hp = tonumber(血) or 0,
                            maxHp = tonumber(最大血) or 0,
                            fp = tonumber(魔) or 0,
                            maxFp = tonumber(最大魔) or 0,
                        }
                    end
                end
            end
        end
        self:刷新宠物显示()
    end)

    self:onSceneStateChanged(function(场景类型,场景状态)
        self:场景变化触发(场景类型,场景状态)
    end)

    self:sendPacket('CUSTOMXB 203')
end

function 强化装备Module:场景变化触发(场景类型,场景状态)
    if 场景类型 == 9 then
        if not self.开启按钮窗体状态 or not self.开启按钮窗体状态.valid then
            self:创建开启按钮窗体()
        else
            local x = CONST.Screen.Width - 开启按钮宽 - 开启按钮边距右
            self.开启按钮窗体状态:Set({x = x, y = 开启按钮边距顶, width = 开启按钮宽, height = 开启按钮高})
        end
    else
        if self.开启按钮窗体状态 and self.开启按钮窗体状态.valid then
            self.开启按钮窗体状态:Set({x = -50, y = -50})
        end
        self:关闭图片面板窗体()
    end
end

function 强化装备Module:创建开启按钮窗体()
    if self.开启按钮窗体状态 and self.开启按钮窗体状态.valid then return end
    local x = CONST.Screen.Width - 开启按钮宽 - 开启按钮边距右
    local 状态,窗体 = self:newWindow({
        id = 开启按钮id,
        x = x,
        y = 开启按钮边距顶,
        width = 开启按钮宽,
        height = 开启按钮高,
        layer = 4,
    })
    if not 窗体 then return end
    self.开启按钮窗体状态 = self:ownWindow(窗体)

    local 普通图 = 资源目录 .. '开启强化界面.png'
    local 高亮图 = 资源目录 .. '开启强化界面高亮.png'
    local 按下图 = 资源目录 .. '开启强化界面按下.png'

    self.开启按钮控件 = 窗体:AddPngImage({
        x = 0, y = 0, width = 开启按钮宽, height = 开启按钮高,
        image = 普通图,
        imageHover = 高亮图,
        imagePress = 按下图,
        onClick = function()
            self:切换图片面板窗体()
            self:更新开启按钮状态()
            return true
        end
    })
end

function 强化装备Module:更新开启按钮状态()
    if not self.开启按钮控件 or not self.开启按钮控件.valid then return end
    local 面板打开 = self.图片面板窗体状态 and self.图片面板窗体状态.valid
    local 图 = 面板打开 and (资源目录 .. '开启强化界面按下.png') or (资源目录 .. '开启强化界面.png')
    self.开启按钮控件:Set({image = 图})
end

function 强化装备Module:切换图片面板窗体()
    if self.图片面板窗体状态 and self.图片面板窗体状态.valid then
        self:关闭图片面板窗体()
    else
        self:创建图片面板窗体()
        self:sendPacket('CUSTOMXB 203')
        self:sendPacket('CUSTOMXB 210')
        self:sendPacket('CUSTOMXB 217 ' .. tostring(当前背包页 - 1))
    end
    self:更新开启按钮状态()
end

local 面板资源 = {
    背景 = 资源目录 .. '背景.png',
    镶嵌背景 = 资源目录 .. '镶嵌背景.png',
    潜能背景 = 资源目录 .. '潜能背景.png',
    潜能框 = 资源目录 .. '文字显示.png',
    潜能框未开启 = 资源目录 .. '文字显示.png',
    潜能开启 = 资源目录 .. '潜能开启.png',
    潜能开启高亮 = 资源目录 .. '潜能开启高亮.png',
    潜能开启按下 = 资源目录 .. '潜能开启按下.png',
    主潜方块 = 资源目录 .. '主潜方块.png',
    附潜方块 = 资源目录 .. '附潜方块.png',
    主要洗潜 = 资源目录 .. '主要洗潜.png',
    主要洗潜高亮 = 资源目录 .. '主要洗潜高亮.png',
    主要洗潜按下 = 资源目录 .. '主要洗潜按下.png',
    附加洗潜 = 资源目录 .. '附加洗潜.png',
    附加洗潜高亮 = 资源目录 .. '附加洗潜高亮.png',
    附加洗潜按下 = 资源目录 .. '附加洗潜按下.png',
    道具放置 = 资源目录 .. '道具放置.png',
    道具放置_4 = 资源目录 .. '道具放置+4.png',
    道具放置_7 = 资源目录 .. '道具放置+7.png',
    道具放置_10 = 资源目录 .. '道具放置+10.png',
    关闭 = 资源目录 .. '关闭.png',
    关闭按下 = 资源目录 .. '关闭按下.png',
    关闭高亮 = 资源目录 .. '关闭高亮.png',
    放置按键 = 资源目录 .. '放置按键.png',
    放置按键按下 = 资源目录 .. '放置按键按下.png',
    放置按键高亮 = 资源目录 .. '放置按键高亮.png',
    强化按键 = 资源目录 .. '强化按键.png',
    强化按键按下 = 资源目录 .. '强化按键按下.png',
    强化按键高亮 = 资源目录 .. '强化按键高亮.png',
    镶嵌按键 = 资源目录 .. '镶嵌.png',
    镶嵌按键按下 = 资源目录 .. '镶嵌按下.png',
    镶嵌按键高亮 = 资源目录 .. '镶嵌高亮.png',
    取回按键 = 资源目录 .. '取回按键.png',
    取回按键按下 = 资源目录 .. '取回按键按下.png',
    取回按键高亮 = 资源目录 .. '取回按键高亮.png',
    整理按键 = 资源目录 .. '整理1.png',
    整理按键高亮 = 资源目录 .. '整理2.png',
    整理按键按下 = 资源目录 .. '整理3.png',
    左翻页 = 资源目录 .. '左.png',
    左翻页高亮 = 资源目录 .. '左高亮.png',
    左翻页按下 = 资源目录 .. '左按下.png',
    右翻页 = 资源目录 .. '右.png',
    右翻页高亮 = 资源目录 .. '右高亮.png',
    右翻页按下 = 资源目录 .. '右按下.png',
    金钱显示 = 资源目录 .. '金钱显示.png',
    文字显示 = 资源目录 .. '文字显示.png',
    丢弃到银行 = 资源目录 .. '丢弃到银行.png',
    丢弃到银行高亮 = 资源目录 .. '丢弃到银行高亮.png',
    丢弃并删除 = 资源目录 .. '丢弃并删除.png',
    丢弃并删除高亮 = 资源目录 .. '丢弃并删除高亮.png',
    银行页 = 资源目录 .. '银行页.png',
    修理按键 = 资源目录 .. '修理.png',
    修理按键高亮 = 资源目录 .. '修理高亮.png',
    修理提示框 = 资源目录 .. '提示框.png',
    修理确定 = 资源目录 .. '确定.png',
    修理确定高亮 = 资源目录 .. '确定高亮.png',
    修理确定按下 = 资源目录 .. '确定按下.png',
    修理取消 = 资源目录 .. '取消.png',
    修理取消高亮 = 资源目录 .. '取消高亮.png',
    修理取消按下 = 资源目录 .. '取消按下.png',
    进补背景 = 资源目录 .. '进补背景.png',
    进补 = 资源目录 .. '进补.png',
    进补按下 = 资源目录 .. '进补按下.png',
    进补高亮 = 资源目录 .. '进补高亮.png',
    选择 = 资源目录 .. '选择.png',
    选择按下 = 资源目录 .. '选择按下.png',
    选择高亮 = 资源目录 .. '选择高亮.png',
    后退 = 资源目录 .. '后退.png',
    后退按下 = 资源目录 .. '后退按下.png',
}

function 强化装备Module:点击整理背包() WinMgr.PlaySe(整理音效,320) self:sendPacket('CUSTOMXB 231') end

function 强化装备Module:左翻页点击()
    WinMgr.PlaySe(翻页音效,320)
    if 当前背包页 > 1 then
        当前背包页 = 当前背包页 - 1
        self:更新背包槽位列表()
        self:sendPacket('CUSTOMXB 216 ' .. (当前背包页 - 1))
        self:刷新页码文字()
    end
end

function 强化装备Module:右翻页点击()
    WinMgr.PlaySe(翻页音效,320)
    if 当前背包页 < 最大背包页 then
        当前背包页 = 当前背包页 + 1
        self:更新背包槽位列表()
        self:sendPacket('CUSTOMXB 216 ' .. (当前背包页 - 1))
        self:刷新页码文字()
    end
end

function 强化装备Module:更新背包槽位列表()
    for i = 1, 20 do
        if 当前背包页 <= 1 then
            背包格槽位列表[i] = 7 + i
        else
            背包格槽位列表[i] = (当前背包页 - 2) * 20 + (i - 1)
        end
    end
end

function 强化装备Module:刷新页码文字()
    if 页码文字控件 and 页码文字控件.valid then
        页码文字控件:Set({text = 当前背包页 .. '/' .. 最大背包页})
    end
end

function 强化装备Module:点击强化按钮()
    self:sendPacket('CUSTOMXB 204')
    self:sendPacket('CUSTOMXB 214')
    -- if 当前道具ItemIndex >= 0 then
        -- Item.SetExtData(当前道具ItemIndex,"EnhLevel",当前强化等级)
        -- local c = Item.GetOwner(当前道具ItemIndex)
        -- Item.UpItem(c,-1)
    -- end
end

function 强化装备Module:更新道具放置背景()
    if not 道具放置槽控件 or not 道具放置槽控件.valid then return end
    if 强化槽显示 ~= 1 or 强化槽图号 <= 0 then
        道具放置槽控件:Set({image=面板资源.道具放置})
        return
    end
    local lv = 当前强化等级
    if lv >= 10 then 道具放置槽控件:Set({image=面板资源.道具放置_10})
    elseif lv >=7 then 道具放置槽控件:Set({image=面板资源.道具放置_7})
    elseif lv >=4 then 道具放置槽控件:Set({image=面板资源.道具放置_4})
    else 道具放置槽控件:Set({image=面板资源.道具放置}) end
end

function 强化装备Module:刷新强化槽显示()
    if not 图片面板窗体对象 or not 图片面板窗体对象.valid then return end
    if 中心图标控件 and 中心图标控件.valid then
        local w, h = self:图档尺寸(强化槽图号)
        local 槽 = 面板坐标.道具放置
        中心图标控件:Set({
            image=强化槽图号,
            visible=(not self.镶嵌模式 and not self.潜能模式) and 强化槽显示==1 and 强化槽图号>0,
            x = 槽.x + math.floor((槽.宽 - w) / 2),
            y = 槽.y + math.floor((槽.高 - h) / 2),
            width = w,
            height = h,
        })
    end
    if 槽下文字控件 and 槽下文字控件.valid then
        local 有道具 = (强化槽显示 == 1 and 强化槽图号 > 0)
        槽下文字控件:Set({text=string.format('+%d',当前强化等级), visible=(not self.镶嵌模式 and not self.潜能模式) and 有道具})
    end
    if 强化槽文字控件 and 强化槽文字控件.valid then
        local 有道具 = (强化槽显示 == 1 and 强化槽图号 > 0)
        强化槽文字控件:Set({visible = (not self.镶嵌模式 and not self.潜能模式) and not 有道具})
    end
    self:更新道具放置背景()
end

function 强化装备Module:切换装备模式()
    self:清拾起()
    self.镶嵌模式=false
    self.潜能模式=false
    if 背景控件 and 背景控件.valid then 背景控件:Set({image=面板资源.背景}) end
    if 道具放置槽控件 and 道具放置槽控件.valid then 道具放置槽控件:Set({visible=true}) end
    if 强化按钮控件 and 强化按钮控件.valid then 强化按钮控件:Set({visible=true}) end
    if self.镶嵌按键控件 and self.镶嵌按键控件.valid then self.镶嵌按键控件:Set({visible=false}) end
    if self.潜能按键控件 and self.潜能按键控件.valid then self.潜能按键控件:Set({visible=false}) end
    if 披风格控件 and 披风格控件.valid then 披风格控件:Set({visible=true}) end
    if 披风格文字控件 and 披风格文字控件.valid then 披风格文字控件:Set({visible=true}) end
    self:刷新强化槽显示()
    self:刷新装备格()
    self:刷新镶嵌槽()
    self:刷新潜能界面()
    return true
end

function 强化装备Module:切换镶嵌模式(进入)
    if not 进入 then return self:切换装备模式() end
    self:清拾起()
    self.潜能模式=false
    self.镶嵌模式=true
    if 背景控件 and 背景控件.valid then 背景控件:Set({image=面板资源.镶嵌背景}) end
    if 道具放置槽控件 and 道具放置槽控件.valid then 道具放置槽控件:Set({visible=false}) end
    if 强化按钮控件 and 强化按钮控件.valid then 强化按钮控件:Set({visible=false}) end
    if self.镶嵌按键控件 and self.镶嵌按键控件.valid then self.镶嵌按键控件:Set({visible=true}) end
    if self.潜能按键控件 and self.潜能按键控件.valid then self.潜能按键控件:Set({visible=false}) end
    if 披风格控件 and 披风格控件.valid then 披风格控件:Set({visible=false}) end
    if 披风格文字控件 and 披风格文字控件.valid then 披风格文字控件:Set({visible=false}) end
    self:刷新强化槽显示()
    self:刷新装备格()
    self:刷新镶嵌槽()
    self:刷新潜能界面()
    if 图片面板窗体对象 and 图片面板窗体对象.valid then self:sendPacket('CUSTOMXB 256') end
    return true
end
function 强化装备Module:刷新镶嵌槽()
    local 抓取类型表 = {装备格='镶嵌装备', 宝石格='镶嵌宝石', 合成格='镶嵌结果'}
    local 装备格有道具 = false
    local 宝石格有道具 = false
    for _, 名称 in ipairs({'装备格', '宝石格', '合成格'}) do
        local 状态 = self.镶嵌状态 and self.镶嵌状态[名称]
        local 背景 = self['镶嵌' .. 名称 .. '控件']
        local 图标 = self['镶嵌' .. 名称 .. '图标控件']
        local 文字 = self['镶嵌' .. 名称 .. '文字控件']
        local 被抓取中 = 拾起中 and 拾起来源 and 拾起来源.类型 == 抓取类型表[名称]
        local 有道具 = false
        if 状态 and 状态.显示 == 1 and 状态.图号 > 0 then 有道具 = true end
        if 名称 == '装备格' then 装备格有道具 = 有道具 end
        if 名称 == '宝石格' then 宝石格有道具 = 有道具 end
        if 背景 and 背景.valid then
            local 背景图 = 面板资源.道具放置
            if 有道具 and not 被抓取中 and (状态.等级 or 0) >= 10 then 背景图 = 面板资源.道具放置_10
            elseif 有道具 and not 被抓取中 and (状态.等级 or 0) >= 7 then 背景图 = 面板资源.道具放置_7
            elseif 有道具 and not 被抓取中 and (状态.等级 or 0) >= 4 then 背景图 = 面板资源.道具放置_4
            end
            背景:Set({image = 背景图, visible = self.镶嵌模式})
        end
        if 图标 and 图标.valid then
            if 有道具 and not 被抓取中 and self.镶嵌模式 then
                local 槽 = 面板坐标[名称 == '装备格' and '镶嵌装备格' or (名称 == '宝石格' and '镶嵌宝石格' or '合成格')]
                local w, h = self:图档尺寸(状态.图号)
                图标:Set({image = 状态.图号, visible = true, x = 槽.x + math.floor((槽.宽 - w) / 2), y = 槽.y + math.floor((槽.高 - h) / 2), width = w, height = h})
            else
                图标:Set({image = -1, visible = self.镶嵌模式})
            end
        end
        if 文字 and 文字.valid then
            文字:Set({visible = self.镶嵌模式 and not 有道具})
        end

        if 名称 == '装备格' and self.镶嵌装备格宝石图标控件列表 then
            local 种类, 等级 = self:宝石ID到角标(self.镶嵌宝石信息 and self.镶嵌宝石信息.装备格 or 0)
            local 槽 = 面板坐标.镶嵌装备格
            local 角标可见 = self.镶嵌模式 and 有道具 and not 被抓取中
            self:绘制宝石角标(self.镶嵌装备格宝石图标控件列表, 槽.x, 槽.y, 槽.宽, 槽.高, self:宝石角标文件(种类, 等级), 角标可见)
        end
    end
    self:刷新合成格宝石角标()
    self:刷新宝石效果文本()
    if 镶嵌发光条带控件 and 镶嵌发光条带控件.valid then
        镶嵌发光条带控件:Set({visible = self.镶嵌模式 and 装备格有道具 and 宝石格有道具})
    end
end

function 强化装备Module:镶嵌格点击(名称)
    if 拾起中 then
        if 拾起来源 and 拾起来源.类型 == '背包' then
            local 源页 = 拾起来源.页 or 1
            local 命令
            if 名称 == '装备格' then 命令 = 'CUSTOMXB 250'
            elseif 名称 == '宝石格' then 命令 = 'CUSTOMXB 251'
            elseif 名称 == '合成格' then 命令 = 'CUSTOMXB 257' end
            if 命令 then
                if 源页 > 1 then self:sendPacket(命令 .. ' ' .. tostring(拾起来源.槽位) .. ' ' .. tostring(源页))
                else self:sendPacket(命令 .. ' ' .. tostring(拾起来源.槽位)) end
            end
            self:清拾起()
            return true
        end
        self:清拾起()
        return true
    end
    local 状态 = self.镶嵌状态 and self.镶嵌状态[名称]
    if not 状态 or 状态.显示 ~= 1 or 状态.图号 <= 0 then return true end
    local 拾起类型 = (名称 == '装备格' and '镶嵌装备') or (名称 == '宝石格' and '镶嵌宝石') or '镶嵌结果'
    拾起中 = true
    拾起来源 = {类型 = 拾起类型}
    if 丢弃遮罩控件 and 丢弃遮罩控件.valid then 丢弃遮罩控件:Set({visible = true}) end
    self:定位拖拽图标(状态.图号)
    if 拖拽数量文字控件 and 拖拽数量文字控件.valid then 拖拽数量文字控件:Set({text = '', visible = false}) end
    拖拽数量可见 = false
    拖拽数量 = 1
    self:刷新镶嵌槽()

    if 名称 == '装备格' and self.镶嵌装备格宝石图标控件列表 then
        for k = 1, 宝石角标最大数 do
            local 控件 = self.镶嵌装备格宝石图标控件列表[k]
            if 控件 and 控件.valid then 控件:Set({visible = false}) end
        end
    elseif 名称 == '合成格' and self.镶嵌合成格宝石图标控件列表 then
        for k = 1, 宝石角标最大数 do
            local 控件 = self.镶嵌合成格宝石图标控件列表[k]
            if 控件 and 控件.valid then 控件:Set({visible = false}) end
        end
    end
    return true
end

function 强化装备Module:镶嵌格悬停(名称)
    悬停镶嵌格 = 名称
    悬停装备格 = nil
    悬停背包格 = nil
    悬停银行格 = nil
    悬停强化槽 = false
    self.当前悬停Tooltip上下文 = { type = 'inlay', index = 名称 }
    self.当前悬停潜能来源类型 = (名称 == '装备格') and 'inlay_equip' or ((名称 == '合成格') and 'inlay_result' or nil)
    self.当前悬停潜能来源索引 = (名称 == '装备格' or 名称 == '合成格') and 名称 or nil
    self.缓存潜能文本 = ''
    self.缓存潜能主要品质 = 0
    self.缓存潜能附加品质 = 0
    local 状态 = self.镶嵌状态 and self.镶嵌状态[名称]
    if not 状态 or 状态.显示 ~= 1 or 状态.图号 <= 0 then return true end
    if 名称 == '宝石格' then
        self:显示悬停提示(self.缓存镶嵌文本 and self.缓存镶嵌文本.宝石格 or '', 状态.等级 or 0, '', '', '', '', nil)
    else
        local 副 = self.缓存镶嵌副文本 and self.缓存镶嵌副文本[名称]
        -- 先刷新一次本体 Tooltip；随后由 258 -> XBCENTER show=3 再次调用统一入口补上潜能资料。
        self:刷新当前悬停装备Tooltip()
        if 名称 == '装备格' then
            self:sendPacket('CUSTOMXB 258 1')
        elseif 名称 == '合成格' then
            self:sendPacket('CUSTOMXB 258 2')
        end
    end
    return true
end

function 强化装备Module:镶嵌格离开(名称)
    if 悬停镶嵌格 == 名称 then
        悬停镶嵌格 = nil
        self.当前悬停Tooltip上下文 = nil
        self.当前悬停潜能来源类型 = nil
        self.当前悬停潜能来源索引 = nil
        self.缓存潜能文本 = ''
        self.缓存潜能主要品质 = 0
        self.缓存潜能附加品质 = 0
        self:隐藏悬停提示()
    end
    return true
end

function 强化装备Module:点击镶嵌按键()
    if 拾起中 then self:清拾起() return true end
    self:sendPacket('CUSTOMXB 255')
    return true
end

function 强化装备Module:一键取回镶嵌()
    WinMgr.PlaySe(整理音效,320)
    local 状态 = self.镶嵌状态 or {}
    local 已发送 = false
    local function 有物品(slotName)
        local s = 状态[slotName]
        return s and tonumber(s.显示 or 0) == 1 and tonumber(s.图号 or 0) > 0
    end
    if 有物品('装备格') then
        self:sendPacket('CUSTOMXB 252')
        已发送 = true
    end
    if 有物品('宝石格') then
        self:sendPacket('CUSTOMXB 253')
        已发送 = true
    end
    if 有物品('合成格') then
        self:sendPacket('CUSTOMXB 254')
        已发送 = true
    end
    if not 已发送 then
        self:cliSendMsg('镶嵌格没有物品可取回', 4)
    end
    return true
end

function 强化装备Module:悬停提示位置(悬停高)
    local 宽 = 面板坐标.文字显示.宽
    local 屏幕宽 = CONST.Screen.Width
    local 屏幕高 = CONST.Screen.Height
    local 中心X = 屏幕宽 / 2
    local 中心Y = 屏幕高 / 2
    local 鼠标X = CONST.Mouse.x
    local 鼠标Y = CONST.Mouse.y
    local 目标X, 目标Y
    if 鼠标X > 中心X and 鼠标Y < 中心Y then
        目标X = 鼠标X - 宽 - 10
        目标Y = 鼠标Y + 10
    elseif 鼠标X > 中心X and 鼠标Y >= 中心Y then
        目标X = 鼠标X - 宽 - 10
        目标Y = 鼠标Y - 悬停高 - 10
    elseif 鼠标X <= 中心X and 鼠标Y >= 中心Y then
        目标X = 鼠标X + 40
        目标Y = 鼠标Y - 悬停高 - 10
    else
        目标X = 鼠标X + 40
        目标Y = 鼠标Y + 10
    end
    if 目标Y < 0 then 目标Y = 0 end
    local 父窗体 = 悬停提示父窗体
    if 父窗体 and 父窗体.x and 父窗体.y then
        return 目标X - 父窗体.x, 目标Y - 父窗体.y
    end
    return 目标X, 目标Y
end

function 强化装备Module:刷新当前悬停装备Tooltip()
    -- 統一 Tooltip 刷新入口。
    -- 任何資料來源（XBCENTER / EQUIPINFO / XQSTATE / 258）到達後都只需要呼叫本函式。
    local ctx = self.当前悬停Tooltip上下文
    if type(ctx) ~= 'table' then return false end

    -- 1) 玩家身上装备格：EQUIPINFO 提供本體資料，XBCENTER 提供潛能資料。
    if ctx.type == 'equip' then
        local 格 = tonumber(ctx.index) or 0
        local 基础 = self.缓存装备悬停资料 and self.缓存装备悬停资料[格]
        if 基础 and tonumber(基础.图号 or 0) > 0 and tostring(基础.文本 or '') ~= '' then
            self:显示悬停提示(
                基础.文本 or '',
                基础.等级 or 0,
                基础.耐久 or '',
                基础.种类 or '',
                基础.套装 or '',
                基础.宝石 or '',
                self:取得缓存潜能资料()
            )
            return true
        end
        return false
    end

    -- 2) 鑲嵌裝備格 / 合成結果格：XQSTATE 提供本體資料，258 -> XBCENTER 提供潛能資料。
    if ctx.type == 'inlay' then
        local 名称 = tostring(ctx.index or '')
        local 状态 = self.镶嵌状态 and self.镶嵌状态[名称]
        local 副 = self.缓存镶嵌副文本 and self.缓存镶嵌副文本[名称]
        local 文本 = self.缓存镶嵌文本 and self.缓存镶嵌文本[名称] or ''
        local 潜能资料
        local 缓存 = self.缓存镶嵌潜能资料 and self.缓存镶嵌潜能资料[名称]
        if 缓存 and ((tostring(缓存.文本 or '') ~= '') or (tonumber(缓存.主要品质 or 0) > 0) or (tonumber(缓存.附加品质 or 0) > 0)) then
            潜能资料 = {文本=tostring(缓存.文本 or ''), 主要品质=tonumber(缓存.主要品质) or 0, 附加品质=tonumber(缓存.附加品质) or 0}
        end
        if 状态 and tonumber(状态.显示 or 0) == 1 and tonumber(状态.图号 or 0) > 0 and 文本 ~= '' then
            self:显示悬停提示(
                文本,
                状态.等级 or 0,
                副 and 副.durab or '',
                副 and 副.type or '',
                副 and 副.set or '',
                副 and 副.gem or '',
                潜能资料
            )
            return true
        end
        return false
    end

    return false
end

function 强化装备Module:取得缓存潜能资料()
    local 文本 = tostring(self.缓存潜能文本 or '')
    local 主要品质 = tonumber(self.缓存潜能主要品质) or 0
    local 附加品质 = tonumber(self.缓存潜能附加品质) or 0

    if 文本 == '' and 主要品质 <= 0 and 附加品质 <= 0 then
        return nil
    end

    return {
        文本 = 文本,
        主要品质 = 主要品质,
        附加品质 = 附加品质,
    }
end

function 强化装备Module:显示悬停提示(整体文本, 等级, 耐久文本, 种类文本, 套装文本, 宝石文本, 潜能品质资料)
    if 悬停背包格 and 悬停背包格 > 0 then
        背包格种类[悬停背包格] = 种类文本
    end
    if 悬停银行格 and 悬停银行格 > 0 then
        银行格种类[悬停银行格] = 种类文本
    end
    整体文本 = tostring(整体文本 or '')
    整体文本 = string.gsub(整体文本, "\\S", " ")
    if 整体文本 == '' then self:隐藏悬停提示() return end
    local 父窗体
    if 悬停银行格 and 银行窗体对象 and 银行窗体对象.valid then
        父窗体 = 银行窗体对象
    elseif 图片面板窗体对象 and 图片面板窗体对象.valid then
        父窗体 = 图片面板窗体对象
    else
        return
    end
    if 悬停提示父窗体 ~= 父窗体 then
        self:隐藏悬停提示()
        悬停提示背景控件 = nil
        悬停提示行控件 = {}
        当前悬停提示高 = 0
        悬停提示父窗体 = 父窗体
    end
    local 分行数组 = {}
    if string.find(整体文本, "|") then
        for 单行内容 in string.gmatch(整体文本, "[^|]+") do table.insert(分行数组, 单行内容) end
    elseif string.find(整体文本, "\\") then
        local 首空格 = string.find(整体文本, " ")
        if 首空格 then
            table.insert(分行数组, string.sub(整体文本, 1, 首空格 - 1))
            for 单行内容 in string.gmatch(string.sub(整体文本, 首空格 + 1), "[^\\]+") do
                if 单行内容 ~= '' then table.insert(分行数组, 单行内容) end
            end
        else
            for 单行内容 in string.gmatch(整体文本, "[^\\]+") do
                if 单行内容 ~= '' then table.insert(分行数组, 单行内容) end
            end
        end
    else
        table.insert(分行数组, 整体文本)
    end
    if not 悬停提示背景控件 then
        悬停提示背景控件 = 父窗体:AddPngImage({
            x=0, y=0, width=面板坐标.文字显示.宽, height=面板坐标.文字显示.高,
            image=面板资源.文字显示, visible=false, hitable=false
        })
    end
    local 名称 = 分行数组[1] or ''
    local 属性行数组 = {}
    for i = 2, #分行数组 do if 分行数组[i] ~= '' then table.insert(属性行数组, 分行数组[i]) end end
    套装文本 = tostring(套装文本 or '')
    宝石文本 = tostring(宝石文本 or '')
    套装文本 = string.gsub(套装文本, "\\S", " ")
    宝石文本 = string.gsub(宝石文本, "\\S", " ")
    local 底部文本数组 = { 套装文本, 宝石文本 }
    local 底部样式数组 = { 悬停套装宝石样式.套装, 悬停套装宝石样式.宝石 }
    local 底部显示行数 = 0
    if 套装文本 ~= '' then 底部显示行数 = 底部显示行数 + 1 end
    if 宝石文本 ~= '' then 底部显示行数 = 底部显示行数 + 1 end
    local 底部总高 = 0
    if 底部显示行数 > 0 then
        for 底 = 1, 2 do
            if 底部文本数组[底] ~= '' then 底部总高 = 底部总高 + 底部样式数组[底].行高 end
        end
        底部总高 = 底部总高 + 悬停套装宝石样式.套装.间隔Y
    end

    local 主潜品质 = 0
    local 附潜品质 = 0
    local 显示潜能品质 = false
    if type(潜能品质资料) == 'table' then
        主潜品质 = tonumber(潜能品质资料.主要品质 or 0) or 0
        附潜品质 = tonumber(潜能品质资料.附加品质 or 0) or 0
        显示潜能品质 = 主潜品质 > 0 or 附潜品质 > 0
        if 显示潜能品质 then
            底部总高 = 底部总高 + 悬停潜能品质样式.间隔Y + 悬停潜能品质样式.行高
        end
    end
    当前悬停提示高 = 悬停样式.属性.起始偏移Y + #属性行数组 * 悬停样式.属性.行高 + 底部总高
    local 相对X, 相对Y = self:悬停提示位置(当前悬停提示高)
    悬停提示背景控件:Set({x=相对X, y=相对Y, visible=true})
    悬停提示中 = true
    for 行 = 1, #悬停提示行控件 do
        local 行控件 = 悬停提示行控件[行]
        if 行控件 then for c = 1, 3 do if 行控件[c] and 行控件[c].valid then 行控件[c]:Set({visible=false}) end end end
    end
    local 名称行 = 悬停提示行控件[1] or {}
    悬停提示行控件[1] = 名称行
    local 名称控件 = 名称行[1]
    if not 名称控件 then
        名称控件 = 父窗体:AddText({
            x=0, y=0, width=悬停样式.名称.宽, height=悬停样式.名称.高, text='',
            font=悬停样式.名称.字体, color=悬停样式.名称.颜色, hitable=false
        })
        名称行[1] = 名称控件
    end
    名称控件:Set({text=名称, x=相对X+悬停样式.名称.偏移X, y=相对Y+悬停样式.名称.偏移Y, visible=true})
    local 名称x = 相对X + 悬停样式.名称.偏移X
    local 等级数 = tonumber(等级) or 0
    local 等级文本 = ''
    if 等级数 > 0 then 等级文本 = 悬停样式.等级.前缀 .. tostring(等级数) end
    local 等级控件 = 名称行[2]
    if not 等级控件 then
        等级控件 = 父窗体:AddText({
            x=0, y=0, width=悬停样式.名称.宽, height=悬停样式.名称.高, text='',
            font=悬停样式.等级.字体, color=悬停样式.等级.颜色, hitable=false
        })
        名称行[2] = 等级控件
    end
    if 等级文本 ~= '' then
        等级控件:Set({
            text=等级文本,
            x=名称x + 文本像素宽(名称) + 悬停样式.等级.间距,
            y=相对Y+悬停样式.名称.偏移Y, visible=true
        })
    else
        等级控件:Set({visible=false})
    end
    耐久文本 = tostring(耐久文本 or '')
    种类文本 = tostring(种类文本 or '')
    local 耐久行 = 悬停提示行控件[2] or {}
    悬停提示行控件[2] = 耐久行
    local 耐久控件 = 耐久行[1]
    if not 耐久控件 then
        耐久控件 = 父窗体:AddText({
            x=0, y=0, width=悬停样式.耐久.宽, height=悬停样式.耐久.高, text='',
            font=悬停样式.耐久.字体, color=悬停样式.耐久.颜色, hitable=false
        })
        耐久行[1] = 耐久控件
    end
    local 种类控件 = 耐久行[2]
    if not 种类控件 then
        种类控件 = 父窗体:AddText({
            x=0, y=0, width=悬停样式.种类.宽, height=悬停样式.种类.高, text='',
            font=悬停样式.种类.字体, color=悬停样式.种类.颜色, hitable=false
        })
        耐久行[2] = 种类控件
    end
    local 耐久x = 名称x
    local 耐久y = 相对Y + 悬停样式.耐久.偏移Y
    local 种类x = 耐久x + 文本像素宽(耐久文本) + (耐久文本 ~= '' and 悬停样式.种类.间距 or 0)
    if 耐久文本 ~= '' or 种类文本 ~= '' then
        耐久控件:Set({text=耐久文本, x=耐久x, y=耐久y, visible=(耐久文本 ~= '')})
        种类控件:Set({text=种类文本, x=种类x, y=耐久y, visible=(种类文本 ~= '')})
    else
        耐久控件:Set({visible=false})
        种类控件:Set({visible=false})
    end
    for i = 1, #属性行数组 do
        if i > 悬停样式.属性.最大行数 then break end
        local 属性列表 = {}
        for 单个属性 in string.gmatch(属性行数组[i], "[^ ]+") do table.insert(属性列表, 单个属性) end
        for 列 = 1, 3 do
            local 属性文本 = 属性列表[列]
            if 属性文本 then
                local 行 = i + 2
                local 行控件 = 悬停提示行控件[行] or {}
                悬停提示行控件[行] = 行控件
                local 控件 = 行控件[列]
                if not 控件 then
                    控件 = 父窗体:AddText({
                        x=0, y=0, width=悬停样式.属性.宽, height=悬停样式.属性.高, text='',
                        font=悬停样式.属性.字体, color=悬停样式.属性.颜色, hitable=false
                    })
                    行控件[列] = 控件
                end
                local 列x = 相对X + (悬停样式.属性.列偏移X[列] or 0)
                控件:Set({
                    text=属性文本, color=取属性颜色(属性文本),
                    x=列x, y=相对Y+悬停样式.属性.起始偏移Y+(i-1)*悬停样式.属性.行高, visible=true
                })
            end
        end
    end
    if 底部显示行数 > 0 then
        local 底部行y0 = 相对Y + 悬停样式.属性.起始偏移Y + #属性行数组 * 悬停样式.属性.行高 + 悬停套装宝石样式.套装.间隔Y
        local 底部显示 = 0
        for 底 = 1, 2 do
            local 行文本 = 底部文本数组[底]
            if 行文本 ~= '' then
                底部显示 = 底部显示 + 1
                local 样式 = 底部样式数组[底]
                local 行号 = #属性行数组 + 3 + 底 - 1
                local 底行 = 悬停提示行控件[行号] or {}
                悬停提示行控件[行号] = 底行
                local 冒号位置 = string.find(行文本, '：')
                if not 冒号位置 then 冒号位置 = string.find(行文本, ':') end
                local 标题文本 = ''
                local 内容文本 = 行文本
                if 冒号位置 then
                    标题文本 = string.sub(行文本, 1, 冒号位置)
                    内容文本 = string.sub(行文本, 冒号位置 + 1)
                end
                local 行y = 底部行y0 + (底部显示 - 1) * 样式.行高
                local 标题x = 相对X + 样式.偏移X
                local 标题控件 = 底行[1]
                if not 标题控件 then
                    标题控件 = 父窗体:AddText({
                        x=0, y=0, width=悬停样式.名称.宽, height=样式.高, text='',
                        font=样式.标题.字体, color=样式.标题.颜色, hitable=false
                    })
                    底行[1] = 标题控件
                end
                标题控件:Set({text=标题文本, color=样式.标题.颜色, x=标题x, y=行y, visible=true})
                local 内容控件 = 底行[2]
                if not 内容控件 then
                    内容控件 = 父窗体:AddText({
                        x=0, y=0, width=悬停样式.名称.宽, height=样式.高, text='',
                        font=样式.内容.字体, color=样式.内容.颜色, hitable=false
                    })
                    底行[2] = 内容控件
                end
                local 内容x = 标题x + 文本像素宽(标题文本)
                内容控件:Set({text=内容文本, color=样式.内容.颜色, x=内容x, y=行y, visible=true})
            end
        end
    end

    if 显示潜能品质 then
        local 行号 = #属性行数组 + 3 + 底部显示行数
        local 品质行 = 悬停提示行控件[行号] or {}
        悬停提示行控件[行号] = 品质行
        local 行y = 相对Y + 悬停样式.属性.起始偏移Y + #属性行数组 * 悬停样式.属性.行高 + 底部总高 - 悬停潜能品质样式.行高

        local 标题控件 = 品质行[1]
        if not 标题控件 then
            标题控件 = 父窗体:AddText({x=0,y=0,width=100,height=15,text='',font=悬停潜能品质样式.标题.字体,color=悬停潜能品质样式.标题.颜色,hitable=false})
            品质行[1] = 标题控件
        end
        标题控件:Set({text='主潜/附潜品质：', color=悬停潜能品质样式.标题.颜色, x=相对X+悬停潜能品质样式.标题.偏移X, y=行y, visible=true})

        local 主控件 = 品质行[2]
        if not 主控件 then
            主控件 = 父窗体:AddText({x=0,y=0,width=42,height=15,text='',font=悬停潜能品质样式.主要.字体,color=49,hitable=false})
            品质行[2] = 主控件
        end
        local 附控件 = 品质行[3]
        if not 附控件 then
            附控件 = 父窗体:AddText({x=0,y=0,width=42,height=15,text='',font=悬停潜能品质样式.附加.字体,color=49,hitable=false})
            品质行[3] = 附控件
        end

        local 标题x = 相对X + 悬停潜能品质样式.标题.偏移X
        local 主x = 标题x + 文本像素宽('主潜/附潜品质：')
        local 主文 = 主潜品质 > 0 and (潜能品质名称[主潜品质] or '') or '-'
        local 附文 = 附潜品质 > 0 and (潜能品质名称[附潜品质] or '') or '-'
        主控件:Set({text=主文, color=潜能品质颜色[主潜品质] or 49, x=主x, y=行y, visible=true})
        local 附x = 主x + 文本像素宽(主文) + 8
        附控件:Set({text=附文, color=潜能品质颜色[附潜品质] or 49, x=附x, y=行y, visible=true})
    end
end

function 强化装备Module:显示装备格类型提示(格)
    local 说明 = 装备格类型说明[格]
    if 说明 then self:显示悬停提示(说明) else self:隐藏悬停提示() end
end

function 强化装备Module:隐藏悬停提示()
    悬停提示中 = false
    if 悬停提示背景控件 and 悬停提示背景控件.valid then 悬停提示背景控件:Set({visible=false}) end
    for 行 = 1, #悬停提示行控件 do
        local 行控件 = 悬停提示行控件[行]
        if 行控件 then for c = 1, 3 do if 行控件[c] and 行控件[c].valid then 行控件[c]:Set({visible=false}) end end end
    end
end

function 强化装备Module:创建镶嵌宝石效果控件(窗体)
    local 效果配置 = 宝石显示配置.效果文本
    self.镶嵌宝石效果标题控件 = 窗体:AddText({
        x=0, y=0, width=100, height=效果配置.标题.高,
        text=效果配置.标题.文本, font=效果配置.标题.字体, color=效果配置.标题.颜色,
        hitable=false, visible=false
    })
    self.镶嵌宝石效果控件列表 = {}
    for 行 = 1, 效果配置.行数 do
        self.镶嵌宝石效果控件列表[行] = {}
        for 列 = 1, 效果配置.每行个数 do
            self.镶嵌宝石效果控件列表[行][列] = 窗体:AddText({
                x=0, y=0, width=120, height=效果配置.内容.高,
                text='', font=效果配置.内容.字体, color=效果配置.内容.颜色,
                hitable=false, visible=false
            })
        end
    end
end

function 强化装备Module:创建潜能控件(窗体)
	-- 注释掉以下两行，不再添加额外的背景框图片
    -- self.潜能主要框控件 = 窗体:AddPngImage({
        -- x=面板坐标.潜能主要框.x, y=面板坐标.潜能主要框.y,
        -- width=面板坐标.潜能主要框.宽, height=面板坐标.潜能主要框.高,
        -- image=面板资源.潜能框未开启, visible=false, hitable=false
    -- })
    -- self.潜能附加框控件 = 窗体:AddPngImage({
        -- x=面板坐标.潜能附加框.x, y=面板坐标.潜能附加框.y,
        -- width=面板坐标.潜能附加框.宽, height=面板坐标.潜能附加框.高,
        -- image=面板资源.潜能框未开启, visible=false, hitable=false
    -- })

    self.潜能主要标题控件 = 窗体:AddText({
        x=面板坐标.潜能主要框.x+10, y=面板坐标.潜能主要框.y+23,
        width=70, height=16, text='主要潜能', font=9, color=48,
        visible=false, hitable=false
    })
    self.潜能附加标题控件 = 窗体:AddText({
        x=面板坐标.潜能附加框.x+10, y=面板坐标.潜能附加框.y+23,
        width=70, height=16, text='附加潜能', font=9, color=48,
        visible=false, hitable=false
    })
    self.潜能主要品质控件 = 窗体:AddText({
        x=面板坐标.潜能主要框.x+10, y=面板坐标.潜能主要框.y+51,
        width=50, height=16, text='', font=9, color=0, align=2,
        visible=false, hitable=false
    })
    self.潜能附加品质控件 = 窗体:AddText({
        x=面板坐标.潜能附加框.x+10, y=面板坐标.潜能附加框.y+51,
        width=50, height=16, text='', font=9, color=0, align=2,
        visible=false, hitable=false
    })

    self.潜能主要效果控件列表 = {}
    self.潜能附加效果控件列表 = {}
    for i=1,3 do
        self.潜能主要效果控件列表[i] = 窗体:AddText({
            x=面板坐标.潜能主要框.x+80,
            y=面板坐标.潜能主要框.y+23+(i-1)*14,
            width=142, height=14, text='', font=9, color=74,
            visible=false, hitable=false
        })
        self.潜能附加效果控件列表[i] = 窗体:AddText({
            x=面板坐标.潜能附加框.x+80,
            y=面板坐标.潜能附加框.y+23+(i-1)*14,
            width=142, height=14, text='', font=9, color=74,
            visible=false, hitable=false
        })
    end

    self.潜能装备格控件 = 窗体:AddPngImage({
        x=面板坐标.潜能装备格.x, y=面板坐标.潜能装备格.y,
        width=50, height=50, image=面板资源.道具放置,
        visible=false, hitable=true, onPress=function() return true end,
        onClick=function() return self:潜能装备格点击() end,
        onHover=function() return self:潜能格悬停('装备') end,
        onLeave=function() return self:潜能格离开() end,
    })
    self.潜能装备图标控件 = 窗体:AddImage({
        x=面板坐标.潜能装备格.x+1, y=面板坐标.潜能装备格.y+1,
        width=48, height=48, image=-1, visible=false, hitable=false
    })
    self.潜能装备文字控件 = 窗体:AddText({
        x=面板坐标.潜能装备格.x+13, y=面板坐标.潜能装备格.y+17,
        width=24, height=16, text='装备', font=9, color=11,
        visible=false, hitable=false
    })

    self.潜能道具格控件 = 窗体:AddPngImage({
        x=面板坐标.潜能道具格.x, y=面板坐标.潜能道具格.y,
        width=50, height=50, image=面板资源.道具放置,
        visible=false, hitable=true, onPress=function() return true end,
        onClick=function() return self:潜能道具格点击() end,
        onHover=function() return self:潜能格悬停('潜能') end,
        onLeave=function() return self:潜能格离开() end,
    })
    self.潜能道具图标控件 = 窗体:AddImage({
        x=面板坐标.潜能道具格.x+1, y=面板坐标.潜能道具格.y+1,
        width=48, height=48, image=-1, visible=false, hitable=false
    })
    self.潜能道具数量控件 = 窗体:AddText({
        x=面板坐标.潜能道具格.x+33, y=面板坐标.潜能道具格.y+34,
        width=17, height=15, text='', font=1, color=1,
        visible=false, hitable=false
    })
    self.潜能道具文字控件 = 窗体:AddText({
        x=面板坐标.潜能道具格.x+13, y=面板坐标.潜能道具格.y+17,
        width=24, height=16, text='潜能', font=9, color=11,
        visible=false, hitable=false
    })

    self.潜能金币文字控件 = 窗体:AddText({
        x=面板坐标.潜能金币文字.x, y=面板坐标.潜能金币文字.y,
        width=面板坐标.潜能金币文字.宽, height=面板坐标.潜能金币文字.高,
        text='', font=9, color=11, visible=false, hitable=false
    })

    self.潜能按键控件 = 窗体:AddPngImage({
        x=面板坐标.潜能按键.x, y=面板坐标.潜能按键.y,
        width=55, height=19, image=面板资源.潜能开启,
        imageHover=面板资源.潜能开启高亮, imagePress=面板资源.潜能开启按下,
        visible=false,
        onClick=function() return self:点击潜能操作() end
    })

    self:刷新潜能界面()
end

function 强化装备Module:刷新潜能界面()
    local 可见 = self.潜能模式 and 图片面板窗体对象 and 图片面板窗体对象.valid
    local 装备有物 = 潜能状态.装备格.显示 == 1 and 潜能状态.装备格.图号 > 0
    local 道具有物 = 潜能状态.道具格.显示 == 1 and 潜能状态.道具格.图号 > 0

    local 主开 = 潜能状态.主要开启
    local 附开 = 潜能状态.附加开启

	-- 移除对 self.潜能主要框控件 和 self.潜能附加框控件 的设置
    -- local 主框 = self.潜能主要框控件
    -- if 主框 and 主框.valid then 主框:Set({visible=可见 and 主开, image=面板资源.潜能框}) end
    -- local 附框 = self.潜能附加框控件
    -- if 附框 and 附框.valid then 附框:Set({visible=可见 and 附开, image=面板资源.潜能框}) end

    local 主品 = tonumber(潜能状态.主要品质) or 0
    local 附品 = tonumber(潜能状态.附加品质) or 0

    if self.潜能主要标题控件 and self.潜能主要标题控件.valid then
        self.潜能主要标题控件:Set({color=潜能品质颜色[主品] or 0, visible=可见 and 主开})
    end
    if self.潜能附加标题控件 and self.潜能附加标题控件.valid then
        self.潜能附加标题控件:Set({color=潜能品质颜色[附品] or 0, visible=可见 and 附开})
    end

    if self.潜能主要品质控件 and self.潜能主要品质控件.valid then
        self.潜能主要品质控件:Set({text=潜能品质名称[主品] or '', color=潜能品质颜色[主品] or 0, visible=可见 and 主开 and 主品>0})
    end
    if self.潜能附加品质控件 and self.潜能附加品质控件.valid then
        self.潜能附加品质控件:Set({text=潜能品质名称[附品] or '', color=潜能品质颜色[附品] or 0, visible=可见 and 附开 and 附品>0})
    end

    for i=1,3 do
        local 主 = self.潜能主要效果控件列表 and self.潜能主要效果控件列表[i]
        local 附 = self.潜能附加效果控件列表 and self.潜能附加效果控件列表[i]
        local 主文 = tostring(潜能状态.主要效果[i] or '')
        local 附文 = tostring(潜能状态.附加效果[i] or '')
        if 主 and 主.valid then 主:Set({text=主文, color=潜能品质颜色[主品] or 0, visible=可见 and 主开 and 主文~=''}) end
        if 附 and 附.valid then 附:Set({text=附文, color=潜能品质颜色[附品] or 0, visible=可见 and 附开 and 附文~=''}) end
    end

    if self.潜能装备格控件 and self.潜能装备格控件.valid then
        self.潜能装备格控件:Set({visible=可见, image=面板资源.道具放置})
    end
    if self.潜能装备图标控件 and self.潜能装备图标控件.valid then
        if 可见 and 装备有物 then
            local 图=潜能状态.装备格.图号
            local w,h=self:图档尺寸(图)
            self.潜能装备图标控件:Set({image=图, visible=true, x=面板坐标.潜能装备格.x+math.floor((50-w)/2), y=面板坐标.潜能装备格.y+math.floor((50-h)/2), width=w, height=h})
        else
            self.潜能装备图标控件:Set({image=-1, visible=false})
        end
    end
    if self.潜能装备文字控件 and self.潜能装备文字控件.valid then
        self.潜能装备文字控件:Set({visible=可见 and not 装备有物})
    end

    if self.潜能道具格控件 and self.潜能道具格控件.valid then
        self.潜能道具格控件:Set({visible=可见, image=面板资源.道具放置})
    end
    if self.潜能道具图标控件 and self.潜能道具图标控件.valid then
        if 可见 and 道具有物 then
            local 图=潜能状态.道具格.图号
            local w,h=self:图档尺寸(图)
            self.潜能道具图标控件:Set({image=图, visible=true, x=面板坐标.潜能道具格.x+math.floor((50-w)/2), y=面板坐标.潜能道具格.y+math.floor((50-h)/2), width=w, height=h})
        else
            self.潜能道具图标控件:Set({image=-1, visible=false})
        end
    end
    if self.潜能道具数量控件 and self.潜能道具数量控件.valid then
        local n=tonumber(潜能状态.道具格.数量) or 0
        self.潜能道具数量控件:Set({text=n>1 and tostring(n) or '', visible=可见 and 道具有物 and n>1})
    end
    if self.潜能道具文字控件 and self.潜能道具文字控件.valid then
        self.潜能道具文字控件:Set({visible=可见 and not 道具有物})
    end

    local 按钮图1 = 面板资源.潜能开启
    local 按钮图2 = 面板资源.潜能开启高亮
    local 按钮图3 = 面板资源.潜能开启按下
    local 可操作 = 可见
    if 可操作 then
        if not 主开 and 潜能状态.道具格.类型 == 1 then
			按钮图1 = 面板资源.潜能开启
			按钮图2 = 面板资源.潜能开启高亮
			按钮图3 = 面板资源.潜能开启按下
        elseif not 附开 and 潜能状态.道具格.类型 == 2 then
			按钮图1 = 面板资源.潜能开启
			按钮图2 = 面板资源.潜能开启高亮
			按钮图3 = 面板资源.潜能开启按下
		end
        if 主开 and 潜能状态.道具格.类型 == 3 then
            按钮图1 = 面板资源.主要洗潜
            按钮图2 = 面板资源.主要洗潜高亮
            按钮图3 = 面板资源.主要洗潜按下
        elseif 附开 and 潜能状态.道具格.类型 == 4 then
			按钮图1 = 面板资源.附加洗潜
			按钮图2 = 面板资源.附加洗潜高亮
			按钮图3 = 面板资源.附加洗潜按下
        end
    end
    if self.潜能按键控件 and self.潜能按键控件.valid then
        self.潜能按键控件:Set({visible=可操作, image=按钮图1, imageHover=按钮图2, imagePress=按钮图3,})
    end

    if self.潜能金币文字控件 and self.潜能金币文字控件.valid then
        local 金币 = tonumber(潜能状态.金币需求) or 0
        self.潜能金币文字控件:Set({text=金币>0 and ('消耗金币：'..tostring(金币)) or '', visible=可见 and 装备有物 and 金币>0})
    end
end

function 强化装备Module:切换潜能模式(进入)
    if not 进入 then return self:切换装备模式() end
    self.潜能模式=true
    self.镶嵌模式=false
    self:清拾起()
    if 背景控件 and 背景控件.valid then 背景控件:Set({image=面板资源.潜能背景}) end
    if 道具放置槽控件 and 道具放置槽控件.valid then 道具放置槽控件:Set({visible=false}) end
    if 强化按钮控件 and 强化按钮控件.valid then 强化按钮控件:Set({visible=false}) end
    if self.镶嵌按键控件 and self.镶嵌按键控件.valid then self.镶嵌按键控件:Set({visible=false}) end
    if self.潜能按键控件 and self.潜能按键控件.valid then self.潜能按键控件:Set({visible=true}) end
    if 披风格控件 and 披风格控件.valid then 披风格控件:Set({visible=false}) end
    if 披风格文字控件 and 披风格文字控件.valid then 披风格文字控件:Set({visible=false}) end
    self:刷新强化槽显示()
    self:刷新装备格()
    self:刷新镶嵌槽()
    self:刷新潜能界面()
    if 图片面板窗体对象 and 图片面板窗体对象.valid then self:sendPacket('CUSTOMXB '..tostring(潜能协议.查询)) end
    return true
end
function 强化装备Module:点击潜能操作()
    if not self.潜能模式 then return true end
    if 潜能状态.装备格.显示 ~= 1 or 潜能状态.装备格.图号 <= 0 then
        self:cliSendMsg('请先放入装备',4); return true
    end
    if 潜能状态.道具格.显示 ~= 1 or 潜能状态.道具格.图号 <= 0 then
        self:cliSendMsg('请放入对应的潜能道具',4); return true
    end
    local 类型=tonumber(潜能状态.道具格.类型) or 0
    local 协议=0
    if 类型==1 then
        协议=潜能协议.开启主要
    elseif 类型==2 then
        协议=潜能协议.开启附加
    elseif 类型 == 3 then
        协议=潜能协议.重洗主要
    elseif 类型 == 4 then
        协议=潜能协议.重洗附加
    end
    if 协议 <= 0 then
        self:cliSendMsg('目前放入的潜能道具与当前潜能状态不匹配',4)
        return true
    end
    self:sendPacket('CUSTOMXB '..tostring(协议))
    return true
end

function 强化装备Module:潜能装备格点击()
    if not self.潜能模式 then return true end
    if 拾起中 then
        if 拾起来源 and 拾起来源.类型 == '背包' then
            local 页=拾起来源.页 or 1
            local 槽=拾起来源.槽位
            if 槽 then self:sendPacket('CUSTOMXB '..tostring(潜能协议.放入装备)..' '..tostring(槽)..' '..tostring(页)) end
        end
        self:清拾起()
        self:刷新潜能界面()
        return true
    end
    if 潜能状态.装备格.显示 ~= 1 or 潜能状态.装备格.图号 <= 0 then return true end
    拾起中=true
    拾起来源={类型='潜能装备'}
    if 丢弃遮罩控件 and 丢弃遮罩控件.valid then 丢弃遮罩控件:Set({visible=true}) end
    self:定位拖拽图标(潜能状态.装备格.图号)
    拖拽数量可见=false; 拖拽数量=1
	self:刷新潜能界面()
    return true
end

function 强化装备Module:潜能道具格点击()
    if not self.潜能模式 then return true end
    if 拾起中 then
        if 拾起来源 and 拾起来源.类型 == '背包' then
            local 页=拾起来源.页 or 1
            local 槽=拾起来源.槽位
            if 槽 then self:sendPacket('CUSTOMXB '..tostring(潜能协议.放入道具)..' '..tostring(槽)..' '..tostring(页)) end
        end
        self:清拾起()
        self:刷新潜能界面()
        return true
    end
    if 潜能状态.道具格.显示 ~= 1 or 潜能状态.道具格.图号 <= 0 then return true end
    拾起中=true
    拾起来源={类型='潜能道具'}
    if 丢弃遮罩控件 and 丢弃遮罩控件.valid then 丢弃遮罩控件:Set({visible=true}) end
    self:定位拖拽图标(潜能状态.道具格.图号)
    拖拽数量可见=false; 拖拽数量=1
	self:刷新潜能界面()
    return true
end

function 强化装备Module:潜能格悬停(类型)
    self.潜能悬停格 = 类型
    悬停强化槽 = false
    悬停镶嵌格 = nil
    if not self.潜能模式 then return true end
    if 拾起中 then self:隐藏悬停提示() return true end
    local 状态 = (类型 == '装备' and 潜能状态.装备格) or (类型 == '潜能' and 潜能状态.道具格)
    if not 状态 or 状态.显示 ~= 1 or 状态.图号 <= 0 then
        self:隐藏悬停提示()
        return true
    end
    if 类型 == '装备' then
        self:sendPacket('CUSTOMXB ' .. tostring(潜能协议.悬停装备))
    else
        self:显示悬停提示('潜能道具', 10, '', '種類:潛能道具', '', '')
    end
    return true
end

function 强化装备Module:潜能格离开()
    self.潜能悬停格 = nil
    self:隐藏悬停提示()
    return true
end

function 强化装备Module:创建面板外观(窗体)
    背景控件 = 窗体:AddPngImage({
        x=0,y=0,width=图片面板宽,height=图片面板高,
        image=面板资源.背景,
        hitable=false
    })
    镶嵌发光条带控件 = 窗体:AddPngImage({
        x=面板坐标.镶嵌发光条带.x,y=面板坐标.镶嵌发光条带.y,width=面板坐标.镶嵌发光条带.宽,height=面板坐标.镶嵌发光条带.高,
        image=资源目录..'宝石镶嵌发光条带.png',
        hitable=false
    })
    镶嵌发光条带控件:Set({visible = false})

    丢弃遮罩控件 = 窗体:AddPngImage({
        x=0, y=0, width=图片面板宽, height=图片面板高,
        image=0,
        hitable=true,
        visible=false,
        onClick=function() return self:背景点击() end
    })

    道具放置槽控件 = 窗体:AddPngImage({
        x=面板坐标.道具放置.x,y=面板坐标.道具放置.y,width=面板坐标.道具放置.宽,height=面板坐标.道具放置.高,
        image=面板资源.道具放置,hitable=true,
        onPress=function() return true end,
        onClick=function() return self:强化槽点击() end,
        onHover=function() return self:强化槽悬停() end,
        onLeave=function() return self:强化槽离开() end
    })

    强化槽文字控件 = 窗体:AddText({
        x = 面板坐标.道具放置.x + 装备格文字样式.偏移X,
        y = 面板坐标.道具放置.y + 装备格文字样式.偏移Y,
        width = 面板坐标.道具放置.宽 - 2*装备格文字样式.偏移X,
        height = 16,
        text = '强化',
        font = 装备格文字样式.字体,
        color = 装备格文字样式.颜色,
        hitable = false
    })
end

function 强化装备Module:创建面板中部控件(窗体)
    中心图标控件 = 窗体:AddImage({x = 26, y = 49, width = 48, height = 48, image = 0, visible = false, hitable = false})

    槽下文字控件 = 窗体:AddText({
        x=面板坐标.槽下文字.x,y=面板坐标.槽下文字.y,width=面板坐标.槽下文字.宽,height=面板坐标.槽下文字.高,
        text='+0',font=1,color=0,hitable=false,visible=false
    })

    整理按钮控件 = 窗体:AddPngImage({
        x=面板坐标.放置取回按钮.x,y=面板坐标.放置取回按钮.y,width=面板坐标.放置取回按钮.宽,height=面板坐标.放置取回按钮.高,
        image=面板资源.整理按键,imageHover=面板资源.整理按键高亮,imagePress=面板资源.整理按键按下,
        onClick=function()self:点击整理背包()return true end
    })
    取回镶嵌按钮控件 = 窗体:AddPngImage({
        x=面板坐标.取回按钮.x,y=面板坐标.取回按钮.y,width=面板坐标.取回按钮.宽,height=面板坐标.取回按钮.高,
        image=资源目录 .. '取回.png',imageHover=资源目录 .. '取回高亮.png',imagePress=资源目录 .. '取回按下.png',
        onClick=function()self:一键取回镶嵌()return true end,
        onHover=function() 窗体:ShowTips('一键取回镶嵌格物品到背包') return true end
    })

    左翻页控件 = 窗体:AddPngImage({
        x=面板坐标.左翻页.x,y=面板坐标.左翻页.y,width=面板坐标.左翻页.宽,height=面板坐标.左翻页.高,
        image=面板资源.左翻页,imageHover=面板资源.左翻页高亮,imagePress=面板资源.左翻页按下,
        onClick=function()self:左翻页点击()return true end
    })

    修理按键控件 = 窗体:AddPngImage({
        x=面板坐标.修理按键.x,y=面板坐标.修理按键.y,width=面板坐标.修理按键.宽,height=面板坐标.修理按键.高,
        image=面板资源.修理按键,imageHover=面板资源.修理按键高亮,
        onClick=function()self:打开修理确认()return true end,
        onHover=function() 窗体:ShowTips('修理穿戴装备的耐久') return true end
    })

    银行丢弃按键控件 = 窗体:AddPngImage({
        x=面板坐标.银行丢弃按键.x,y=面板坐标.银行丢弃按键.y,width=面板坐标.银行丢弃按键.宽,height=面板坐标.银行丢弃按键.高,
        image=面板资源.丢弃到银行,imageHover=面板资源.丢弃到银行高亮,
        onClick=function()self:点击银行丢弃()return true end,
        onHover=function() 窗体:ShowTips('开启仓库') return true end
    })

    删除丢弃按键控件 = 窗体:AddPngImage({
        x=面板坐标.删除丢弃按键.x,y=面板坐标.删除丢弃按键.y,width=面板坐标.删除丢弃按键.宽,height=面板坐标.删除丢弃按键.高,
        image=面板资源.丢弃并删除,imageHover=面板资源.丢弃并删除高亮,
        onClick=function()self:点击删除丢弃()return true end,
        onHover=function() 窗体:ShowTips('丢弃并销毁') return true end
    })

    右翻页控件 = 窗体:AddPngImage({
        x=面板坐标.右翻页.x,y=面板坐标.右翻页.y,width=面板坐标.右翻页.宽,height=面板坐标.右翻页.高,
        image=面板资源.右翻页,imageHover=面板资源.右翻页高亮,imagePress=面板资源.右翻页按下,
        onClick=function()self:右翻页点击()return true end
    })

    页码文字控件 = 窗体:AddText({
        x=面板坐标.页码文字.x, y=面板坐标.页码文字.y,
        width=面板坐标.页码文字.宽, height=面板坐标.页码文字.高,
        text=当前背包页 .. '/' .. 最大背包页,
        font=面板坐标.页码文字.字体,
        color=面板坐标.页码文字.颜色,
        align=1, hitable=false
    })

    强化按钮控件 = 窗体:AddPngImage({
        x=面板坐标.强化按钮.x,y=面板坐标.强化按钮.y,width=面板坐标.强化按钮.宽,height=面板坐标.强化按钮.高,
        image=面板资源.强化按键,imageHover=面板资源.强化按键高亮,imagePress=面板资源.强化按键按下,
        onClick=function()self:点击强化按钮()return true end
    })

    self.镶嵌装备格控件 = 窗体:AddPngImage({
        x=面板坐标.镶嵌装备格.x,y=面板坐标.镶嵌装备格.y,width=面板坐标.镶嵌装备格.宽,height=面板坐标.镶嵌装备格.高,
        image=面板资源.道具放置,visible=false,hitable=true,
        onClick=function() return self:镶嵌格点击('装备格') end,
        onHover=function() return self:镶嵌格悬停('装备格') end,
        onLeave=function() return self:镶嵌格离开('装备格') end
    })
    self.镶嵌装备格图标控件 = 窗体:AddImage({
        x=面板坐标.镶嵌装备格.x,y=面板坐标.镶嵌装备格.y,width=48,height=48,image=0,visible=false,hitable=false
    })
    self.镶嵌装备格文字控件 = 窗体:AddText({
        x = 面板坐标.镶嵌装备格.x + 装备格文字样式.偏移X,
        y = 面板坐标.镶嵌装备格.y + 装备格文字样式.偏移Y,
        width = 面板坐标.镶嵌装备格.宽 - 2*装备格文字样式.偏移X,
        height = 16,
        text = '装备',
        font = 装备格文字样式.字体,
        color = 装备格文字样式.颜色,
        hitable = false,
        visible = false
    })
    self.镶嵌宝石格控件 = 窗体:AddPngImage({
        x=面板坐标.镶嵌宝石格.x,y=面板坐标.镶嵌宝石格.y,width=面板坐标.镶嵌宝石格.宽,height=面板坐标.镶嵌宝石格.高,
        image=面板资源.道具放置,visible=false,hitable=true,
        onClick=function() return self:镶嵌格点击('宝石格') end,
        onHover=function() return self:镶嵌格悬停('宝石格') end,
        onLeave=function() return self:镶嵌格离开('宝石格') end
    })
    self.镶嵌宝石格图标控件 = 窗体:AddImage({
        x=面板坐标.镶嵌宝石格.x,y=面板坐标.镶嵌宝石格.y,width=48,height=48,image=0,visible=false,hitable=false
    })
    self.镶嵌宝石格文字控件 = 窗体:AddText({
        x = 面板坐标.镶嵌宝石格.x + 装备格文字样式.偏移X,
        y = 面板坐标.镶嵌宝石格.y + 装备格文字样式.偏移Y,
        width = 面板坐标.镶嵌宝石格.宽 - 2*装备格文字样式.偏移X,
        height = 16,
        text = '宝石',
        font = 装备格文字样式.字体,
        color = 装备格文字样式.颜色,
        hitable = false,
        visible = false
    })
    self.镶嵌合成格控件 = 窗体:AddPngImage({
        x=面板坐标.合成格.x,y=面板坐标.合成格.y,width=面板坐标.合成格.宽,height=面板坐标.合成格.高,
        image=面板资源.道具放置,visible=false,hitable=true,
        onClick=function() return self:镶嵌格点击('合成格') end,
        onHover=function() return self:镶嵌格悬停('合成格') end,
        onLeave=function() return self:镶嵌格离开('合成格') end
    })
    self.镶嵌合成格图标控件 = 窗体:AddImage({
        x=面板坐标.合成格.x,y=面板坐标.合成格.y,width=48,height=48,image=0,visible=false,hitable=false
    })
    self.镶嵌合成格文字控件 = 窗体:AddText({
        x = 面板坐标.合成格.x + 装备格文字样式.偏移X,
        y = 面板坐标.合成格.y + 装备格文字样式.偏移Y,
        width = 面板坐标.合成格.宽 - 2*装备格文字样式.偏移X,
        height = 16,
        text = ' ',
        font = 装备格文字样式.字体,
        color = 装备格文字样式.颜色,
        hitable = false,
        visible = false
    })
    self.镶嵌按键控件 = 窗体:AddPngImage({
        x=面板坐标.镶嵌按键.x,y=面板坐标.镶嵌按键.y,width=面板坐标.镶嵌按键.宽,height=面板坐标.镶嵌按键.高,
        image=面板资源.镶嵌按键,imageHover=面板资源.镶嵌按键高亮,imagePress=面板资源.镶嵌按键按下,
        visible=false,
        onClick=function() return self:点击镶嵌按键() end
    })
    self.镶嵌合成格宝石图标控件列表 = {}
    for k = 1, 宝石角标最大数 do
        self.镶嵌合成格宝石图标控件列表[k] = 窗体:AddPngImage({
            x=面板坐标.合成格.x + 面板坐标.合成格.宽, y=面板坐标.合成格.y + 面板坐标.合成格.高, width=8, height=8,
            image=资源目录 .. '1级宝石冒险之星.png', visible=false, hitable=false
        })
    end
    self.镶嵌装备格宝石图标控件列表 = {}
    for k = 1, 宝石角标最大数 do
        self.镶嵌装备格宝石图标控件列表[k] = 窗体:AddPngImage({
            x=面板坐标.镶嵌装备格.x + 面板坐标.镶嵌装备格.宽, y=面板坐标.镶嵌装备格.y + 面板坐标.镶嵌装备格.高, width=8, height=8,
            image=资源目录 .. '1级宝石冒险之星.png', visible=false, hitable=false
        })
    end
    self:创建镶嵌宝石效果控件(窗体)

    金钱显示控件 = 窗体:AddPngImage({
        x=面板坐标.金钱显示.x, y=面板坐标.金钱显示.y,
        width=面板坐标.金钱显示.宽, height=面板坐标.金钱显示.高,
        image=面板资源.金钱显示, hitable=false
    })
    金钱文字控件 = 窗体:AddText({
        x = 金钱文字坐标(0),
        y = 面板坐标.金钱文字.y,
        width = 面板坐标.金钱显示.宽 - 金钱文字宽度缩减,
        height = 面板坐标.金钱文字.高,
        text = '0',
        font = 面板坐标.金钱文字.字体,
        color = 面板坐标.金钱文字.颜色,
        hitable = false
    })
    self:sendPacket('CUSTOMXB 214')

    窗体:AddPngImage({
        x=面板坐标.关闭按钮.x,y=面板坐标.关闭按钮.y,width=面板坐标.关闭按钮.宽,height=面板坐标.关闭按钮.高,
        image=面板资源.关闭,imageHover=面板资源.关闭高亮,imagePress=面板资源.关闭按下,
        onClick=function()self:关闭图片面板窗体()return true end
    })
end

function 强化装备Module:创建背包区(窗体)
    背包格控件列表 = {}
    背包格图标控件列表 = {}
    for i = 1, 20 do
        local idx = i
        local 格x, 格y = self:背包格坐标(i)
        背包格控件列表[i] = 窗体:AddPngImage({
            x = 格x, y = 格y, width = 背包格宽, height = 背包格高,
            image = 面板资源.道具放置, visible = true, hitable = true,
            onPress = function() return true end,
            onClick = function() return self:背包格点击(idx) end,
            onHover = function() return self:背包格悬停(idx) end,
            onLeave = function() return self:背包格离开(idx) end,
        })
    end
    for i = 1, 20 do
        local 格x, 格y = self:背包格坐标(i)
        背包格图标控件列表[i] = 窗体:AddImage({
            x = 格x + 1, y = 格y + 1, width = 背包格宽 - 2, height = 背包格高 - 2,
            image = -1, visible = true, hitable = false,
        })
        背包格数量控件列表[i] = 窗体:AddText({
            x = 格x + 背包格宽 - 面板坐标.数量文字.数字宽 + 面板坐标.数量文字.偏移x,
            y = 格y + 背包格高 - 面板坐标.数量文字.高 + 面板坐标.数量文字.偏移y,
            width = 面板坐标.数量文字.宽,
            height = 面板坐标.数量文字.高,
            text = '',
            font = 面板坐标.数量文字.字体,
            color = 面板坐标.数量文字.颜色,
            hitable = false,
        })
    end
    self.背包宝石图标控件列表 = {}
    for i = 1, 20 do
        local 格x, 格y = self:背包格坐标(i)
        local 组 = {}
        for k = 1, 宝石角标最大数 do
            组[k] = 窗体:AddPngImage({
                x = 格x + 背包格宽, y = 格y + 背包格高, width = 8, height = 8,
                image = 资源目录 .. '1级宝石冒险之星.png', visible = false, hitable = false,
            })
        end
        self.背包宝石图标控件列表[i] = 组
    end
    self:刷新背包格()
end

function 强化装备Module:创建右栏背包区(窗体)
    右栏背包控件列表 = {}
    for k = 1, 5 do
        local 键y = 右栏背包起始Y + (k - 1) * (右栏背包高 + 右栏背包间距)
        右栏背包控件列表[k] = 窗体:AddPngImage({
            x = 右栏背包起始X, y = 键y, width = 右栏背包宽, height = 右栏背包高,
            image = 资源目录 .. '右边栏背包' .. k .. '.png',
            onClick = function() self:右栏背包按键(k) return true end,
            onHover = function() self:右栏背包悬停(k) return true end,
            onLeave = function() self:刷新右栏背包按键() return true end,
        })
    end
    self:刷新右栏背包按键()
end

function 强化装备Module:创建装备区(窗体)
    装备格控件列表 = {}
    装备格图标控件列表 = {}
    装备格文字控件列表 = {}
    for e = 1, #装备格位置 do
        local 格x = 装备区起始X + (装备格位置[e].列 - 1) * 装备列步进
        local 格y = 装备区起始Y + (装备格位置[e].行 - 1) * 装备行步进
        装备格控件列表[e] = 窗体:AddPngImage({
            x = 格x, y = 格y, width = 装备格宽, height = 装备格高,
            image = 面板资源.道具放置, visible = true, hitable = true,
            onPress = function() return true end,
            onClick = function() return self:装备格点击(e) end,
            onHover = function() return self:装备格悬停(e) end,
            onLeave = function() return self:装备格离开(e) end,
        })
        local 名称 = 装备格位置[e].名称
        装备格文字控件列表[e] = 窗体:AddText({
            x = 格x + 装备格文字样式.偏移X,
            y = 格y + 装备格文字样式.偏移Y,
            width = 装备格宽 - 2*装备格文字样式.偏移X,
            height = 16,
            text = 名称,
            font = 装备格文字样式.字体,
            color = 装备格文字样式.颜色,
            hitable = false
        })
    end
    for e = 1, #装备格位置 do
        local 格x = 装备区起始X + (装备格位置[e].列 - 1) * 装备列步进
        local 格y = 装备区起始Y + (装备格位置[e].行 - 1) * 装备行步进
        装备格图标控件列表[e] = 窗体:AddImage({
            x = 格x + 1, y = 格y + 1, width = 装备格宽 - 2, height = 装备格高 - 2,
            image = -1, visible = true, hitable = false,
        })
    end
    self.装备格宝石图标控件列表 = {}
    for e = 1, #装备格位置 do
        local 格x = 装备区起始X + (装备格位置[e].列 - 1) * 装备列步进
        local 格y = 装备区起始Y + (装备格位置[e].行 - 1) * 装备行步进
        local 组 = {}
        for k = 1, 宝石角标最大数 do
            组[k] = 窗体:AddPngImage({
                x = 格x + 装备格宽, y = 格y + 装备格高, width = 8, height = 8,
                image = 资源目录 .. '1级宝石冒险之星.png', visible = false, hitable = false,
            })
        end
        self.装备格宝石图标控件列表[e] = 组
    end

    角色图档控件 = 窗体:AddAnime({
        x = 装备区起始X + 装备列步进,
        y = 装备区起始Y + 2 * 装备行步进,
        width = 装备格宽, height = 装备格高,
        animeNo = 0, action = 0, dir = 5,
        visible = false, hitable = false,
    })

    local 披风x = 装备区起始X
    local 披风y = 装备区起始Y + 3 * 装备行步进
    披风格控件 = 窗体:AddPngImage({x=披风x,y=披风y,width=装备格宽,height=装备格高,image=面板资源.道具放置,visible=true,hitable=false})
    披风格文字控件 = 窗体:AddText({
        x = 披风x + 装备格文字样式.偏移X,
        y = 披风y + 装备格文字样式.偏移Y,
        width = 装备格宽 - 2*装备格文字样式.偏移X,
        height = 16,
        text = '披风',
        font = 装备格文字样式.字体,
        color = 装备格文字样式.颜色,
        hitable = false,
    })

    self:刷新装备格()
end

function 强化装备Module:创建拖拽控件(窗体)
    拖拽图标控件 = 窗体:AddImage({x=0,y=0,width=36,height=36,image=-1,visible=false,hitable=false})
    拖拽数量文字控件 = 窗体:AddText({
        x = 0, y = 0,
        width = 面板坐标.数量文字.宽,
        height = 面板坐标.数量文字.高,
        text = '',
        font = 面板坐标.数量文字.字体,
        color = 面板坐标.数量文字.颜色,
        hitable = false,
        visible = false,
    })
end

function 强化装备Module:创建三分页按钮(窗体)
    -- 三個分頁最後建立，確保位於所有內容控件最上層。
    self.裝備分頁按鈕控件 = 窗体:AddPngImage({x=320,y=284,width=39,height=24,image=资源目录..'热区.png',hitable=true,onPress=function() return true end,onClick=function() return self:切换装备模式() end})
    self.鑲嵌分頁按鈕控件 = 窗体:AddPngImage({x=373,y=284,width=39,height=24,image=资源目录..'热区.png',hitable=true,onPress=function() return true end,onClick=function() return self:切换镶嵌模式(true) end})
    self.潛能分頁按鈕控件 = 窗体:AddPngImage({x=426,y=284,width=39,height=24,image=资源目录..'热区.png',hitable=true,onPress=function() return true end,onClick=function() return self:切换潜能模式(true) end})
end

function 强化装备Module:创建图片面板窗体()
    if self.图片面板窗体状态 and self.图片面板窗体状态.valid then return end
    self.镶嵌模式 = false
    self.潜能模式 = false
    上次点击槽位 = nil
    上次点击时间 = nil
    上次点击帧 = -1
    local 状态,窗体 = self:newWindow({
        id=图片面板窗体id,x=居中X(图片面板宽),y=居中Y(图片面板高),width=图片面板宽,height=图片面板高,layer=4,dragMove=1,
        update=function(窗体) return self:拾起更新(窗体) end
    })
    if not 窗体 then return end
    图片面板窗体对象 =窗体
    self.图片面板窗体状态 = self:ownWindow(窗体)
    窗体:ClearChildren()

    self:创建面板外观(窗体)
    self:创建面板中部控件(窗体)
    self:创建背包区(窗体)
    self:创建右栏背包区(窗体)
    self:创建装备区(窗体)
    self:创建潜能控件(窗体)
    self:创建拖拽控件(窗体)
    self:创建三分页按钮(窗体)

    self:刷新强化槽显示()
    self:sendPacket('CUSTOMXB 203')
end

function 强化装备Module:关闭图片面板窗体()
    if self.图片面板窗体状态 then
        self:关闭银行窗体()
        self:关闭修理提示框()
        if 图片面板窗体对象 then 图片面板窗体对象:Close() end
        self.图片面板窗体状态 = nil
        图片面板窗体对象 = nil
        中心图标控件 = nil
        槽下文字控件 = nil
        整理按钮控件 = nil
        取回镶嵌按钮控件 = nil
        强化按钮控件 = nil
        道具放置槽控件 = nil
        左翻页控件 = nil
        右翻页控件 = nil
        银行丢弃按键控件 = nil
        修理按键控件 = nil
        删除丢弃按键控件 = nil
        页码文字控件 = nil
        背景控件 = nil
        丢弃遮罩控件 = nil
        金钱显示控件 = nil
        金钱文字控件 = nil
        披风格控件 = nil
        披风格文字控件 = nil
        self.镶嵌模式 = false
        self.潜能模式 = false
        潜能状态 = {
            装备格={显示=0, 图号=0, 等级=0},
            道具格={显示=0, 图号=0, 数量=0, 类型=0},
            主要开启=false, 附加开启=false,
            主要品质=0, 附加品质=0,
            主要效果={}, 附加效果={}, 金币需求=0,
        }
        self.潜能切换按钮控件 = nil
        self.退出潜能切换按钮控件 = nil
        self.裝備分頁按鈕控件 = nil
        self.鑲嵌分頁按鈕控件 = nil
        self.潛能分頁按鈕控件 = nil
        self.潜能主要框控件 = nil
        self.潜能附加框控件 = nil
        self.潜能主要标题控件 = nil
        self.潜能附加标题控件 = nil
        self.潜能主要品质控件 = nil
        self.潜能附加品质控件 = nil
        self.潜能主要效果控件列表 = {}
        self.潜能附加效果控件列表 = {}
        self.潜能装备格控件 = nil
        self.潜能装备图标控件 = nil
        self.潜能装备文字控件 = nil
        self.潜能道具格控件 = nil
        self.潜能道具图标控件 = nil
        self.潜能道具数量控件 = nil
        self.潜能道具文字控件 = nil
        self.潜能金币文字控件 = nil
        self.潜能按键控件 = nil
        self.镶嵌切换按钮控件 = nil
        self.退出镶嵌切换按钮控件 = nil
        self.镶嵌装备格控件 = nil
        self.镶嵌装备格图标控件 = nil
        self.镶嵌装备格文字控件 = nil
        self.镶嵌宝石格控件 = nil
        self.镶嵌宝石格图标控件 = nil
        self.镶嵌宝石格文字控件 = nil
        self.镶嵌合成格控件 = nil
        self.镶嵌合成格图标控件 = nil
        self.镶嵌合成格文字控件 = nil
        self.镶嵌合成格宝石图标控件列表 = nil
        self.镶嵌装备格宝石图标控件列表 = nil
        self.镶嵌按键控件 = nil
        self.镶嵌状态 = nil
        self.镶嵌宝石信息 = nil
        self.镶嵌宝石效果标题控件 = nil
        self.镶嵌宝石效果控件列表 = {}
        self.背包宝石图标控件列表 = {}
        self.装备格宝石图标控件列表 = nil
        self.缓存镶嵌文本 = nil
        self.缓存镶嵌副文本 = nil
        悬停镶嵌格 = nil
        金钱同步计数 = 0
        拾起中 = false
        拾起来源 = nil
        拖拽数量可见 = false
        上次拖拽图标x = -9999
        上次拖拽图标y = -9999
        拖拽图标控件 = nil
        拖拽数量文字控件 = nil
        背包格控件列表 = {}
        背包格图标控件列表 = {}
        背包格数量控件列表 = {}
        强化槽文字控件 = nil
        装备格文字控件列表 = {}
        悬停装备格 = nil
        悬停背包格 = nil
        悬停强化槽 = false
        悬停提示中 = false
        悬停提示背景控件 = nil
        悬停提示行控件 = {}
        悬停提示父窗体 = nil
        当前悬停提示高 = 0
    end
    self:更新开启按钮状态()
end

function 强化装备Module:银行窗体下移面板()
    if not (图片面板窗体对象 and 图片面板窗体对象.valid) then return end
    local 需要高度 = 银行窗高 + 4 + 图片面板高
    if CONST.Screen.Height and CONST.Screen.Height >= 需要高度 then
        图片面板窗体对象:Set({y = 居中Y(银行窗高) + 银行窗高 + 4})
        银行面板下移中 = true
    end
end

function 强化装备Module:银行窗体复位面板()
    if 银行面板下移中 then
        if 图片面板窗体对象 and 图片面板窗体对象.valid then
            图片面板窗体对象:Set({y = 居中Y(图片面板高)})
        end
        银行面板下移中 = false
    end
end

function 强化装备Module:创建银行窗体()
    if self.银行窗体状态 and self.银行窗体状态.valid then return end
    local 状态,窗体 = self:newWindow({
        id=银行窗体id, x=居中X(银行窗宽), y=居中Y(银行窗高), width=银行窗宽, height=银行窗高, layer=3, dragMove=1,
        update=function(窗体) return self:银行拾起更新(窗体) end
    })
    if not 窗体 then return end
    银行窗体对象 = 窗体
    self.银行窗体状态 = self:ownWindow(窗体)
    窗体:ClearChildren()
    窗体:AddPngImage({x=0, y=0, width=银行窗宽, height=银行窗高, image=面板资源.银行页, hitable=false})
    窗体:AddPngImage({
        x=411, y=9, width=12, height=12,
        image=面板资源.关闭, imageHover=面板资源.关闭高亮, imagePress=面板资源.关闭按下,
        onClick=function() self:关闭银行窗体() return true end
    })
    银行左翻页控件 = 窗体:AddPngImage({
        x=280, y=290, width=20, height=20,
        image=面板资源.左翻页, imageHover=面板资源.左翻页高亮, imagePress=面板资源.左翻页按下,
        onClick=function() self:银行左翻页点击() return true end
    })
    银行页码文字控件 = 窗体:AddText({
        x=306, y=292, width=40, height=16,
        text=(当前银行页 + 1) .. '/' .. 最大银行页,
        font=1, color=11, align=1, hitable=false
    })
    银行右翻页控件 = 窗体:AddPngImage({
        x=339, y=290, width=20, height=20,
        image=面板资源.右翻页, imageHover=面板资源.右翻页高亮, imagePress=面板资源.右翻页按下,
        onClick=function() self:银行右翻页点击() return true end
    })
    银行整理按钮控件 = 窗体:AddPngImage({
        x=365, y=290, width=55, height=19,
        image=面板资源.整理按键, imageHover=面板资源.整理按键高亮, imagePress=面板资源.整理按键按下,
        onClick=function() self:银行整理点击() return true end
    })
    银行丢弃删除按键控件 = 窗体:AddPngImage({
        x=257, y=290, width=20, height=20,
        image=面板资源.丢弃并删除, imageHover=面板资源.丢弃并删除高亮,
        onClick=function() self:银行丢弃点击() return true end
    })
    银行页按键控件列表 = {}
    for k = 1, 5 do
        local 页 = k - 1
        local 按键x = 银行页按键起始X + (k - 1) * (银行页按键宽 + 银行页按键间距)
        银行页按键控件列表[k] = 窗体:AddPngImage({
            x=按键x, y=银行页按键y, width=银行页按键宽, height=银行页按键高,
            image='luaUI/modules/cg图档集/强化面板/第' .. k .. '格背包.png',
            onClick=function() self:银行页按键(页) return true end,
            onHover=function() self:银行页按键悬停(k) return true end,
            onLeave=function() self:刷新银行页按键() return true end,
        })
    end
    银行拖拽图标控件 = nil
    银行拖拽数量控件 = nil
    银行格控件列表 = {}
    银行格图标控件列表 = {}
    银行格数量控件列表 = {}
    for i = 1, 40 do
        local idx = i
        local 格x, 格y = self:银行格坐标(i)
        银行格控件列表[i] = 窗体:AddPngImage({
            x=格x, y=格y, width=银行格宽, height=银行格高,
            image=面板资源.道具放置, visible=true, hitable=true,
            onPress=function() return true end,
            onClick=function() return self:银行格点击(idx) end,
            onHover=function() return self:银行格悬停(idx) end,
            onLeave=function() return self:银行格离开(idx) end,
        })
    end
    for i = 1, 40 do
        local 格x, 格y = self:银行格坐标(i)
        银行格图标控件列表[i] = 窗体:AddImage({
            x=格x+1, y=格y+1, width=银行格宽-2, height=银行格高-2,
            image=-1, visible=true, hitable=false,
        })
        银行格数量控件列表[i] = 窗体:AddText({
            x = 格x + 银行格宽 - 面板坐标.数量文字.数字宽 + 面板坐标.数量文字.偏移x,
            y = 格y + 银行格高 - 面板坐标.数量文字.高 + 面板坐标.数量文字.偏移y,
            width = 面板坐标.数量文字.宽,
            height = 面板坐标.数量文字.高,
            text = '',
            font = 面板坐标.数量文字.字体,
            color = 面板坐标.数量文字.颜色,
            hitable = false,
        })
    end
    self.银行宝石图标控件列表 = {}
    for i = 1, 40 do
        local 格x, 格y = self:银行格坐标(i)
        local 组 = {}
        for k = 1, 宝石角标最大数 do
            组[k] = 窗体:AddPngImage({
                x = 格x + 银行格宽, y = 格y + 银行格高, width = 8, height = 8,
                image = 资源目录 .. '1级宝石冒险之星.png', visible = false, hitable = false,
            })
        end
        self.银行宝石图标控件列表[i] = 组
    end
    银行拖拽图标控件 = 窗体:AddImage({x=0, y=0, width=36, height=36, image=-1, visible=false, hitable=false})
    银行拖拽数量控件 = 窗体:AddText({
        x = 0, y = 0,
        width = 面板坐标.数量文字.宽,
        height = 面板坐标.数量文字.高,
        text = '',
        font = 面板坐标.数量文字.字体,
        color = 面板坐标.数量文字.颜色,
        hitable = false,
        visible = false,
    })
    self:刷新银行页码()
    self:刷新银行格()
    self:银行窗体下移面板()
    WinMgr.Focus(银行窗体id)
end

function 强化装备Module:银行拾起更新(窗体)
    if not 窗体.valid then return false end
    if 拾起中 and 银行拖拽图标控件 and 银行拖拽图标控件.valid then
        local mx, my = CONST.Mouse.x, CONST.Mouse.y
        local 在银行内 = (mx >= 窗体.x and mx <= 窗体.x + 银行窗宽 and my >= 窗体.y and my <= 窗体.y + 银行窗高)
        if 在银行内 then
            if 银行图标已隐藏 then
                银行图标已隐藏 = false
                上次银行拖拽图标x = -9999
                上次银行拖拽图标y = -9999
            end
            local 图标x = mx - 窗体.x - math.floor(拖拽图标宽 / 2)
            local 图标y = my - 窗体.y - math.floor(拖拽图标高 / 2)
            if 图标x ~= 上次银行拖拽图标x or 图标y ~= 上次银行拖拽图标y then
                上次银行拖拽图标x = 图标x
                上次银行拖拽图标y = 图标y
                银行拖拽图标控件:Set({x=图标x, y=图标y, visible=true})
            end
            if 拖拽数量可见 and 拖拽数量 > 1 and 银行拖拽数量控件 and 银行拖拽数量控件.valid then
                local 数字宽 = #tostring(拖拽数量) * 面板坐标.数量文字.数字宽
                银行拖拽数量控件:Set({
                    text = tostring(拖拽数量),
                    x = 图标x + 拖拽图标宽 - 数字宽 + 面板坐标.数量文字.偏移x,
                    y = 图标y + 拖拽图标高 - 面板坐标.数量文字.高 + 面板坐标.数量文字.偏移y,
                    visible = true,
                })
            elseif 银行拖拽数量控件 and 银行拖拽数量控件.valid then
                银行拖拽数量控件:Set({visible = false})
            end
        elseif not 银行图标已隐藏 then
            银行图标已隐藏 = true
            if 银行拖拽图标控件.valid then 银行拖拽图标控件:Set({visible=false}) end
            if 银行拖拽数量控件 and 银行拖拽数量控件.valid then 银行拖拽数量控件:Set({visible=false}) end
        end
    end
    return false
end

function 强化装备Module:关闭银行窗体()
    if self.银行窗体状态 then
        self:银行窗体复位面板()
        if 银行窗体对象 then 银行窗体对象:Close() end
        self.银行窗体状态 = nil
        银行窗体对象 = nil
        银行格控件列表 = {}
        银行格图标控件列表 = {}
        银行格数量控件列表 = {}
        银行宝石图标控件列表 = {}
        银行页按键控件列表 = {}
        银行左翻页控件 = nil
        银行右翻页控件 = nil
        银行页码文字控件 = nil
        银行整理按钮控件 = nil
        银行丢弃删除按键控件 = nil
        银行拖拽图标控件 = nil
        银行拖拽数量控件 = nil
        悬停银行格 = nil
        if 悬停提示父窗体 == 银行窗体对象 then
            悬停提示父窗体 = nil
            悬停提示背景控件 = nil
            悬停提示行控件 = {}
        end
        上次点击银行槽位 = nil
        上次银行点击时间 = nil
        上次银行点击帧 = -1
    end
end

function 强化装备Module:切换银行窗体()
    if self.银行窗体状态 and self.银行窗体状态.valid then
        self:关闭银行窗体()
    else
        self:关闭修理提示框()
        self:关闭进补窗体()
        当前银行页 = 0
        self:创建银行窗体()
        self:sendPacket('CUSTOMXB 220 0')
    end
end

function 强化装备Module:创建进补窗体()
    if self.进补窗体状态 and self.进补窗体状态.valid then return end
    local 状态,窗体 = self:newWindow({
        id=进补配置.窗体id, x=居中X(进补配置.窗体宽), y=居中Y(进补配置.窗体高), width=进补配置.窗体宽, height=进补配置.窗体高, layer=3, dragMove=1,
        update=function(窗体) return self:进补窗体更新(窗体) end
    })
    if not 窗体 then return end
    进补窗体对象 = 窗体
    self.进补窗体状态 = self:ownWindow(窗体)
    窗体:ClearChildren()
    窗体:AddPngImage({x=0, y=0, width=进补配置.窗体宽, height=进补配置.窗体高, image=面板资源.进补背景, hitable=false})
    窗体:AddPngImage({
        x=进补配置.窗体宽 - 进补配置.关闭按钮偏移X, y=进补配置.关闭按钮偏移Y, width=进补配置.关闭按钮宽, height=进补配置.关闭按钮高,
        image=面板资源.关闭, imageHover=面板资源.关闭高亮, imagePress=面板资源.关闭按下,
        onClick=function() self:关闭进补窗体() return true end
    })
    进补按钮控件列表 = {}
    选择按钮控件列表 = {}
    踢出按钮控件列表 = {}
    for i = 1, 进补配置.组数 do
        local 组x = 进补配置.按钮起始X + (i - 1) * 进补配置.按钮组间距
        选择按钮控件列表[i] = 窗体:AddPngImage({
            x=组x + 进补配置.选择按钮偏移X, y=进补配置.按钮起始Y + 进补配置.选择按钮偏移Y, width=进补配置.选择按钮宽, height=进补配置.选择按钮高,
            image='luaUI/modules/cg图档集/强化面板/宠物小图标.png', imageHover='luaUI/modules/cg图档集/强化面板/宠物小图标高亮.png', imagePress='luaUI/modules/cg图档集/强化面板/宠物小图标按下.png',        
            onClick=function() self:选择按钮点击(i) return true end,
            onHover=function() 窗体:ShowTips('给宠物使用血药/料理') return true end
        })
        进补按钮控件列表[i] = 窗体:AddPngImage({
            x=组x + 进补配置.进补按钮偏移X, y=进补配置.按钮起始Y + 进补配置.选择按钮高 + 进补配置.进补选择间距 + 进补配置.进补按钮偏移Y, width=进补配置.进补按钮宽, height=进补配置.进补按钮高,
            image='luaUI/modules/cg图档集/强化面板/喂食小图标.png', imageHover='luaUI/modules/cg图档集/强化面板/喂食小图标高亮.png', imagePress='luaUI/modules/cg图档集/强化面板/喂食小图标按下.png',        
            onClick=function() self:进补按钮点击(i) return true end,
            onHover=function() 窗体:ShowTips('使用血药/料理给该角色') return true end
        })
        踢出按钮控件列表[i] = 窗体:AddPngImage({
            x=组x + 进补配置.踢出按钮偏移X, y=进补配置.按钮起始Y + 进补配置.踢出按钮偏移Y, width=进补配置.踢出按钮宽, height=进补配置.踢出按钮高,
            image='luaUI/modules/cg图档集/强化面板/踢出队伍.png', imageHover='luaUI/modules/cg图档集/强化面板/踢出队伍高亮.png', imagePress='luaUI/modules/cg图档集/强化面板/踢出队伍按下.png',
            onClick=function() self:踢出按钮点击(i) return true end,
            onHover=function() 窗体:ShowTips('踢出队伍') return true end
        })
    end
    队员图档控件列表 = {}
    队员血蓝背景列表 = {}
    队员血条列表 = {}
    队员蓝条列表 = {}
    队员队长标志列表 = {}
    队员职业文字列表 = {}
    队员等级文字列表 = {}
    for i = 1, 进补配置.组数 do
        local 组x = 进补配置.按钮起始X + (i - 1) * 进补配置.按钮组间距
        local 队员x = 进补配置.队员起始X + (i - 1) * 进补配置.队员间距
        队员血蓝背景列表[i] = 窗体:AddPngImage({
            x = 组x + 进补配置.进补按钮偏移X + 进补配置.血蓝背景偏移X, y = 进补配置.队员起始Y + 进补配置.血蓝背景偏移Y,
            width = 进补配置.血蓝背景宽, height = 进补配置.血蓝背景高,
            image = 'luaUI/modules/cg图档集/强化面板/血蓝背景.png',
            visible = false, hitable = false
        })
        队员图档控件列表[i] = 窗体:AddAnime({
            x = 队员x, y = 进补配置.队员起始Y,
            width = 进补配置.队员图档宽, height = 进补配置.队员图档高,
            animeNo = 0, action = 0, dir = 5,
            visible = false, hitable = false
        })
        队员血条列表[i] = 窗体:AddPngImage({
            x = 组x + 进补配置.进补按钮偏移X + 进补配置.血条背景内偏移X, y = 进补配置.队员起始Y + 进补配置.血蓝背景偏移Y + 进补配置.血条背景内偏移Y,
            width = 进补配置.血条宽, height = 进补配置.血条高,
            image = 'luaUI/modules/cg图档集/强化面板/红条显示100%.png',
            visible = false, hitable = false
        })
        队员蓝条列表[i] = 窗体:AddPngImage({
            x = 组x + 进补配置.进补按钮偏移X + 进补配置.蓝条背景内偏移X, y = 进补配置.队员起始Y + 进补配置.血蓝背景偏移Y + 进补配置.蓝条背景内偏移Y,
            width = 进补配置.蓝条宽, height = 进补配置.蓝条高,
            image = 'luaUI/modules/cg图档集/强化面板/蓝条显示100%.png',
            visible = false, hitable = false
        })
        队员队长标志列表[i] = 窗体:AddPngImage({
            x = 队员x + 进补配置.队长标志偏移X, y = 进补配置.队员起始Y + 进补配置.队长标志偏移Y,
            width = 进补配置.队长标志宽, height = 进补配置.队长标志高,
            image = 'luaUI/modules/cg图档集/强化面板/队长标识.png',
            visible = false, hitable = false
        })
        队员职业文字列表[i] = 窗体:AddText({
            x = 组x + 进补配置.职业文字偏移X, y = 进补配置.按钮起始Y + 进补配置.职业文字偏移Y,
            width = 进补配置.职业文字宽, height = 进补配置.职业文字高, text = '',
            font = 进补配置.职业文字字体, color = 进补配置.职业文字颜色, hitable = false
        })
        队员等级文字列表[i] = 窗体:AddText({
            x = 组x + 进补配置.等级文字偏移X, y = 进补配置.按钮起始Y + 进补配置.等级文字偏移Y,
            width = 进补配置.等级文字宽, height = 进补配置.等级文字高, text = '',
            font = 进补配置.等级文字字体, color = 进补配置.等级文字颜色, hitable = false
        })
    end
    self:刷新队员显示()
    self:sendPacket('CUSTOMXB 241')
end

function 强化装备Module:刷新队员显示()
    if not self.进补窗体状态 or not self.进补窗体状态.valid then return end
    for i = 1, 5 do
        if 队员图档控件列表[i] and 队员图档控件列表[i].valid then 队员图档控件列表[i]:Set({visible = false}) end
        if 队员血蓝背景列表[i] and 队员血蓝背景列表[i].valid then 队员血蓝背景列表[i]:Set({visible = false}) end
        if 队员血条列表[i] and 队员血条列表[i].valid then 队员血条列表[i]:Set({visible = false}) end
        if 队员蓝条列表[i] and 队员蓝条列表[i].valid then 队员蓝条列表[i]:Set({visible = false}) end
        if 踢出按钮控件列表[i] and 踢出按钮控件列表[i].valid then 踢出按钮控件列表[i]:Set({visible = false}) end
        if 队员队长标志列表[i] and 队员队长标志列表[i].valid then 队员队长标志列表[i]:Set({visible = false}) end
        if 队员职业文字列表[i] and 队员职业文字列表[i].valid then 队员职业文字列表[i]:Set({visible = false}) end
        if 队员等级文字列表[i] and 队员等级文字列表[i].valid then 队员等级文字列表[i]:Set({visible = false}) end
    end
    local 玩家图号 = Player and Player.imageNo or 0
    if 玩家图号 > 0 and 队员图档控件列表[1] and 队员图档控件列表[1].valid then
        local w, h = self:图档尺寸(玩家图号)
        local 队员x = 进补配置.队员起始X
        队员图档控件列表[1]:Set({
            animeNo = 玩家图号, action = 0, dir = 5, visible = true,
            x = 队员x + math.floor((进补配置.队员图档宽 - w) / 2),
            y = 进补配置.队员起始Y + math.floor((进补配置.队员图档高 - h) / 2),
            width = w, height = h,
        })
        if 队员血蓝背景列表[1] and 队员血蓝背景列表[1].valid then 队员血蓝背景列表[1]:Set({visible = true}) end
        if 队员血条列表[1] and 队员血条列表[1].valid then
            local 血百分比 = 1
            if Player and Player.maxHp and Player.maxHp > 0 then
                血百分比 = (Player.hp or 0) / Player.maxHp
                if 血百分比 < 0 then 血百分比 = 0 elseif 血百分比 > 1 then 血百分比 = 1 end
            end
            local 血宽当前 = math.floor(进补配置.血条宽 * 血百分比)
            队员血条列表[1]:Set({visible = true, x = 进补配置.按钮起始X + 进补配置.进补按钮偏移X + 进补配置.血条背景内偏移X, width = 血宽当前})
        end
        if 队员蓝条列表[1] and 队员蓝条列表[1].valid then
            local 蓝百分比 = 1
            local 魔当前 = (Player and Player.fp) or (Player and Player.mp) or 0
            local 魔最大 = (Player and Player.maxFp) or (Player and Player.maxMp) or 0
            if 魔最大 > 0 then
                蓝百分比 = 魔当前 / 魔最大
                if 蓝百分比 < 0 then 蓝百分比 = 0 elseif 蓝百分比 > 1 then 蓝百分比 = 1 end
            end
            local 蓝宽当前 = math.floor(进补配置.蓝条宽 * 蓝百分比)
            队员蓝条列表[1]:Set({visible = true, x = 进补配置.按钮起始X + 进补配置.进补按钮偏移X + 进补配置.蓝条背景内偏移X, width = 蓝宽当前})
        end
        if 自己是否队长 and 队员队长标志列表[1] and 队员队长标志列表[1].valid then 队员队长标志列表[1]:Set({visible = true}) end
        if 队员职业文字列表[1] and 队员职业文字列表[1].valid then 队员职业文字列表[1]:Set({text = 自己职业 or '', visible = true}) end
        if 队员等级文字列表[1] and 队员等级文字列表[1].valid then 队员等级文字列表[1]:Set({text = 'Lv.' .. tostring(自己等级), visible = true}) end
    end
    for i = 2, 5 do
        local 队员 = 队员信息列表[i - 1]
        if 队员 and 队员.图号 and 队员.图号 > 0 and 队员图档控件列表[i] and 队员图档控件列表[i].valid then
            local w, h = self:图档尺寸(队员.图号)
            local 队员x = 进补配置.队员起始X + (i - 1) * 进补配置.队员间距
            local 组x = 进补配置.按钮起始X + (i - 1) * 进补配置.按钮组间距
            队员图档控件列表[i]:Set({
                animeNo = 队员.图号, action = 0, dir = 5, visible = true,
                x = 队员x + math.floor((进补配置.队员图档宽 - w) / 2),
                y = 进补配置.队员起始Y + math.floor((进补配置.队员图档高 - h) / 2),
                width = w, height = h,
            })
            if 队员血蓝背景列表[i] and 队员血蓝背景列表[i].valid then 队员血蓝背景列表[i]:Set({visible = true}) end
            if 队员血条列表[i] and 队员血条列表[i].valid then
                local 血百分比 = 1
                if 队员.maxHp and 队员.maxHp > 0 then
                    血百分比 = 队员.hp / 队员.maxHp
                    if 血百分比 < 0 then 血百分比 = 0 elseif 血百分比 > 1 then 血百分比 = 1 end
                end
                local 血宽当前 = math.floor(进补配置.血条宽 * 血百分比)
                队员血条列表[i]:Set({visible = true, x = 组x + 进补配置.进补按钮偏移X + 进补配置.血条背景内偏移X, width = 血宽当前})
            end
            if 队员蓝条列表[i] and 队员蓝条列表[i].valid then
                local 蓝百分比 = 1
                if 队员.maxFp and 队员.maxFp > 0 then
                    蓝百分比 = 队员.fp / 队员.maxFp
                    if 蓝百分比 < 0 then 蓝百分比 = 0 elseif 蓝百分比 > 1 then 蓝百分比 = 1 end
                end
                local 蓝宽当前 = math.floor(进补配置.蓝条宽 * 蓝百分比)
                队员蓝条列表[i]:Set({visible = true, x = 组x + 进补配置.进补按钮偏移X + 进补配置.蓝条背景内偏移X, width = 蓝宽当前})
            end
            if 队员.队长 and 队员队长标志列表[i] and 队员队长标志列表[i].valid then 队员队长标志列表[i]:Set({visible = true}) end
            if 队员职业文字列表[i] and 队员职业文字列表[i].valid then 队员职业文字列表[i]:Set({text = 队员.职业 or '', visible = true}) end
            if 队员等级文字列表[i] and 队员等级文字列表[i].valid then 队员等级文字列表[i]:Set({text = 'Lv.' .. tostring(队员.等级), visible = true}) end
            if 自己是否队长 and 踢出按钮控件列表[i] and 踢出按钮控件列表[i].valid then 踢出按钮控件列表[i]:Set({visible = true}) end
        end
    end
end

function 强化装备Module:进补窗体更新(窗体)
    if not 窗体.valid then return false end
    进补刷新计数 = 进补刷新计数 + 1
    if 进补刷新计数 >= 30 then
        进补刷新计数 = 0
        self:刷新队员显示()
    end
    进补同步计数 = 进补同步计数 + 1
    if 进补同步计数 >= 120 then
        进补同步计数 = 0
        self:sendPacket('CUSTOMXB 241')
    end
    return false
end

function 强化装备Module:关闭进补窗体()
    if self.进补窗体状态 and self.进补窗体状态.valid then
        self:releaseWindow(self.进补窗体状态)
        self.进补窗体状态 = nil
        进补窗体对象 = nil
        进补按钮控件列表 = nil
        选择按钮控件列表 = nil
        踢出按钮控件列表 = nil
        队员图档控件列表 = nil
        队员血蓝背景列表 = nil
        队员队长标志列表 = nil
        队员职业文字列表 = nil
        队员等级文字列表 = nil
    end
end

function 强化装备Module:切换进补窗体()
    if self.进补窗体状态 and self.进补窗体状态.valid then
        self:关闭进补窗体()
    else
        self:打开进补窗体()
    end
end

function 强化装备Module:打开进补窗体()
    if self.进补窗体状态 and self.进补窗体状态.valid then
        self:刷新队员显示()
        return
    end
    self:关闭宠物进补窗体()
    self:关闭银行窗体()
    self:关闭修理提示框()
    self:创建进补窗体()
end

function 强化装备Module:进补按钮点击(i)
    if 宠物进补数据.物品来源 == '' then
        self:cliSendMsg('请先双击背包或银行中的料理/血药', 4)
        return
    end
    local src = (宠物进补数据.物品来源 == '银行') and 1 or 0
    self:sendPacket('CUSTOMXB 245 ' .. tostring(i - 1) .. ' ' .. tostring(src) .. ' ' .. tostring(宠物进补数据.物品槽位) .. ' ' .. tostring(宠物进补数据.物品页) .. ' -1')
end

function 强化装备Module:选择按钮点击(i)
    宠物进补数据.目标位置 = i
    self:关闭进补窗体()
    self:创建宠物进补窗体()
    self:sendPacket('CUSTOMXB 243 ' .. tostring(i - 1))
end

function 强化装备Module:创建宠物进补窗体()
    if self.宠物进补窗体状态 and self.宠物进补窗体状态.valid then return end
    local 状态,窗体 = self:newWindow({
        id=80014, x=居中X(进补配置.窗体宽), y=居中Y(进补配置.窗体高), width=进补配置.窗体宽, height=进补配置.窗体高, layer=3, dragMove=1,
        update=function(窗体) return self:宠物进补窗体更新(窗体) end
    })
    if not 窗体 then return end
    宠物进补数据.窗体对象 = 窗体
    self.宠物进补窗体状态 = self:ownWindow(窗体)
    窗体:ClearChildren()
    窗体:AddPngImage({x=0, y=0, width=进补配置.窗体宽, height=进补配置.窗体高, image=面板资源.进补背景, hitable=false})
    窗体:AddPngImage({
        x=进补配置.窗体宽 - 进补配置.关闭按钮偏移X, y=进补配置.关闭按钮偏移Y, width=进补配置.关闭按钮宽, height=进补配置.关闭按钮高,
        image=面板资源.关闭, imageHover=面板资源.关闭高亮, imagePress=面板资源.关闭按下,
        onClick=function() self:关闭宠物进补窗体() return true end
    })
    窗体:AddPngImage({
        x=进补配置.后退按钮偏移X, y=进补配置.后退按钮偏移Y, width=进补配置.后退按钮宽, height=进补配置.后退按钮高,
        image=面板资源.后退, imagePress=面板资源.后退按下,
        onClick=function() self:关闭宠物进补窗体(); self:创建进补窗体() return true end
    })
    宠物进补数据.图档控件列表 = {}
    宠物进补数据.血蓝背景列表 = {}
    宠物进补数据.血条列表 = {}
    宠物进补数据.蓝条列表 = {}
    宠物进补数据.按钮列表 = {}
    宠物进补数据.名称文字列表 = {}
    宠物进补数据.等级文字列表 = {}
    for i = 1, 进补配置.组数 do
        local 组x = 进补配置.按钮起始X + (i - 1) * 进补配置.按钮组间距
        local 队员x = 进补配置.队员起始X + (i - 1) * 进补配置.队员间距
        宠物进补数据.血蓝背景列表[i] = 窗体:AddPngImage({
            x = 组x + 进补配置.进补按钮偏移X + 进补配置.血蓝背景偏移X, y = 进补配置.队员起始Y + 进补配置.血蓝背景偏移Y,
            width = 进补配置.血蓝背景宽, height = 进补配置.血蓝背景高,
            image = 'luaUI/modules/cg图档集/强化面板/血蓝背景.png',
            visible = false, hitable = false
        })
        宠物进补数据.图档控件列表[i] = 窗体:AddAnime({
            x = 队员x, y = 进补配置.队员起始Y,
            width = 进补配置.队员图档宽, height = 进补配置.队员图档高,
            animeNo = 0, action = 0, dir = 5,
            visible = false, hitable = false
        })
        宠物进补数据.血条列表[i] = 窗体:AddPngImage({
            x = 组x + 进补配置.进补按钮偏移X + 进补配置.血条背景内偏移X, y = 进补配置.队员起始Y + 进补配置.血蓝背景偏移Y + 进补配置.血条背景内偏移Y,
            width = 进补配置.血条宽, height = 进补配置.血条高,
            image = 'luaUI/modules/cg图档集/强化面板/红条显示100%.png',
            visible = false, hitable = false
        })
        宠物进补数据.蓝条列表[i] = 窗体:AddPngImage({
            x = 组x + 进补配置.进补按钮偏移X + 进补配置.蓝条背景内偏移X, y = 进补配置.队员起始Y + 进补配置.血蓝背景偏移Y + 进补配置.蓝条背景内偏移Y,
            width = 进补配置.蓝条宽, height = 进补配置.蓝条高,
            image = 'luaUI/modules/cg图档集/强化面板/蓝条显示100%.png',
            visible = false, hitable = false
        })
        宠物进补数据.按钮列表[i] = 窗体:AddPngImage({
            x=组x + 进补配置.进补按钮偏移X, y=进补配置.按钮起始Y + 进补配置.选择按钮高 + 进补配置.进补选择间距 + 进补配置.进补按钮偏移Y,
            width=进补配置.进补按钮宽, height=进补配置.进补按钮高,
            image='luaUI/modules/cg图档集/强化面板/喂食小图标.png', imageHover='luaUI/modules/cg图档集/强化面板/喂食小图标高亮.png', imagePress='luaUI/modules/cg图档集/强化面板/喂食小图标按下.png',
            visible = false,
            onClick=function() self:宠物进补按钮点击(i) return true end,
            onHover=function() 窗体:ShowTips('使用血药/料理给该宠物') return true end
        })
        宠物进补数据.名称文字列表[i] = 窗体:AddText({
            x = 组x + 进补配置.职业文字偏移X, y = 进补配置.按钮起始Y + 进补配置.职业文字偏移Y,
            width = 进补配置.职业文字宽, height = 进补配置.职业文字高, text = '',
            font = 进补配置.职业文字字体, color = 进补配置.职业文字颜色, hitable = false
        })
        宠物进补数据.等级文字列表[i] = 窗体:AddText({
            x = 组x + 进补配置.等级文字偏移X, y = 进补配置.按钮起始Y + 进补配置.等级文字偏移Y,
            width = 进补配置.等级文字宽, height = 进补配置.等级文字高, text = '',
            font = 进补配置.等级文字字体, color = 进补配置.等级文字颜色, hitable = false
        })
    end
    self:刷新宠物显示()
end

function 强化装备Module:刷新宠物显示()
    if not self.宠物进补窗体状态 or not self.宠物进补窗体状态.valid then return end
    for i = 1, 5 do
        local 宠物 = 宠物进补数据.信息列表[i]
        local 有宠物 = 宠物 and 宠物.图号 and 宠物.图号 > 0
        if 宠物进补数据.图档控件列表[i] and 宠物进补数据.图档控件列表[i].valid then 宠物进补数据.图档控件列表[i]:Set({visible = false}) end
        if 宠物进补数据.血蓝背景列表[i] and 宠物进补数据.血蓝背景列表[i].valid then 宠物进补数据.血蓝背景列表[i]:Set({visible = 有宠物}) end
        if 宠物进补数据.血条列表[i] and 宠物进补数据.血条列表[i].valid then 宠物进补数据.血条列表[i]:Set({visible = false}) end
        if 宠物进补数据.蓝条列表[i] and 宠物进补数据.蓝条列表[i].valid then 宠物进补数据.蓝条列表[i]:Set({visible = false}) end
        if 宠物进补数据.按钮列表[i] and 宠物进补数据.按钮列表[i].valid then 宠物进补数据.按钮列表[i]:Set({visible = false}) end
        if 宠物进补数据.名称文字列表[i] and 宠物进补数据.名称文字列表[i].valid then 宠物进补数据.名称文字列表[i]:Set({text = '', visible = false}) end
        if 宠物进补数据.等级文字列表[i] and 宠物进补数据.等级文字列表[i].valid then 宠物进补数据.等级文字列表[i]:Set({text = '', visible = false}) end
        if 有宠物 then
            local w, h = self:图档尺寸(宠物.图号)
            local 队员x = 进补配置.队员起始X + (i - 1) * 进补配置.队员间距
            local 组x = 进补配置.按钮起始X + (i - 1) * 进补配置.按钮组间距
            宠物进补数据.图档控件列表[i]:Set({
                animeNo = 宠物.图号, action = 0, dir = 5, visible = true,
                x = 队员x + math.floor((进补配置.队员图档宽 - w) / 2),
                y = 进补配置.队员起始Y + math.floor((进补配置.队员图档高 - h) / 2),
                width = w, height = h,
            })
            if 宠物进补数据.血条列表[i] and 宠物进补数据.血条列表[i].valid then
                local 血百分比 = 1
                if 宠物.maxHp and 宠物.maxHp > 0 then
                    血百分比 = 宠物.hp / 宠物.maxHp
                    if 血百分比 < 0 then 血百分比 = 0 elseif 血百分比 > 1 then 血百分比 = 1 end
                end
                local 血宽当前 = math.floor(进补配置.血条宽 * 血百分比)
                宠物进补数据.血条列表[i]:Set({visible = true, x = 组x + 进补配置.进补按钮偏移X + 进补配置.血条背景内偏移X, width = 血宽当前})
            end
            if 宠物进补数据.蓝条列表[i] and 宠物进补数据.蓝条列表[i].valid then
                local 蓝百分比 = 1
                if 宠物.maxFp and 宠物.maxFp > 0 then
                    蓝百分比 = 宠物.fp / 宠物.maxFp
                    if 蓝百分比 < 0 then 蓝百分比 = 0 elseif 蓝百分比 > 1 then 蓝百分比 = 1 end
                end
                local 蓝宽当前 = math.floor(进补配置.蓝条宽 * 蓝百分比)
                宠物进补数据.蓝条列表[i]:Set({visible = true, x = 组x + 进补配置.进补按钮偏移X + 进补配置.蓝条背景内偏移X, width = 蓝宽当前})
            end
            if 宠物进补数据.按钮列表[i] and 宠物进补数据.按钮列表[i].valid then 宠物进补数据.按钮列表[i]:Set({visible = true}) end
            if 宠物进补数据.名称文字列表[i] and 宠物进补数据.名称文字列表[i].valid then 宠物进补数据.名称文字列表[i]:Set({text = 宠物.名字 or '', visible = true}) end
            if 宠物进补数据.等级文字列表[i] and 宠物进补数据.等级文字列表[i].valid then 宠物进补数据.等级文字列表[i]:Set({text = 'Lv.' .. tostring(宠物.等级), visible = true}) end
        end
    end
end

function 强化装备Module:宠物进补窗体更新(窗体)
    if not 窗体.valid then return false end
    宠物进补数据.刷新计数 = 宠物进补数据.刷新计数 + 1
    if 宠物进补数据.刷新计数 >= 30 then
        宠物进补数据.刷新计数 = 0
        self:刷新宠物显示()
    end
    宠物进补数据.同步计数 = 宠物进补数据.同步计数 + 1
    if 宠物进补数据.同步计数 >= 120 then
        宠物进补数据.同步计数 = 0
        self:sendPacket('CUSTOMXB 243 ' .. tostring(宠物进补数据.目标位置 - 1))
    end
    return false
end

function 强化装备Module:关闭宠物进补窗体()
    if self.宠物进补窗体状态 and self.宠物进补窗体状态.valid then
        self:releaseWindow(self.宠物进补窗体状态)
        self.宠物进补窗体状态 = nil
        宠物进补数据.窗体对象 = nil
        宠物进补数据.图档控件列表 = {}
        宠物进补数据.血蓝背景列表 = {}
        宠物进补数据.血条列表 = {}
        宠物进补数据.蓝条列表 = {}
        宠物进补数据.按钮列表 = {}
        宠物进补数据.名称文字列表 = {}
        宠物进补数据.等级文字列表 = {}
        宠物进补数据.信息列表 = {}
    end
end

function 强化装备Module:宠物进补按钮点击(i)
    if 宠物进补数据.物品来源 == '' then
        self:cliSendMsg('请先双击背包或银行中的料理/血药', 4)
        return
    end
    local 宠物 = 宠物进补数据.信息列表[i]
    if not 宠物 then return end
    local src = (宠物进补数据.物品来源 == '银行') and 1 or 0
    self:sendPacket('CUSTOMXB 245 ' .. tostring(宠物进补数据.目标位置 - 1) .. ' ' .. tostring(src) .. ' ' .. tostring(宠物进补数据.物品槽位) .. ' ' .. tostring(宠物进补数据.物品页) .. ' ' .. tostring(i - 1))
end

function 强化装备Module:踢出按钮点击(i)
    if not 自己是否队长 then
        self:cliSendMsg('只有队长可以踢出队员', 4)
        return
    end
    local 队员 = 队员信息列表[i - 1]
    if not 队员 then return end
    self:sendPacket('CUSTOMXB 242 ' .. tostring(i - 1))
end

function 强化装备Module:打开修理确认()
    local ok = pcall(function()
        self:清拾起()
        self:关闭银行窗体()
        self:关闭进补窗体()
        if 修理提示框窗体状态 and 修理提示框窗体状态.valid then return end
        local 状态,窗体 = self:newWindow({
            id=修理提示框id, x=居中X(修理提示框宽), y=居中Y(修理提示框高), width=修理提示框宽, height=修理提示框高, layer=3, dragMove=1,
        })
        if not 窗体 then return end
        修理提示框窗体状态 = self:ownWindow(窗体)
        修理提示框窗体对象 = 窗体
        窗体:ClearChildren()
        窗体:AddPngImage({x=0, y=0, width=修理提示框宽, height=修理提示框高, image=面板资源.修理提示框, hitable=false})
        窗体:AddText({x=13, y=18, width=132, height=18, text='是否修理穿戴的', font=1, color=0, align=1, hitable=false})
        窗体:AddText({x=13, y=38, width=132, height=18, text='全部装备？', font=1, color=0, align=1, hitable=false})
        窗体:AddPngImage({
            x=修理确定按键.x, y=修理确定按键.y, width=修理确定按键.宽, height=修理确定按键.高,
            image=面板资源.修理确定, imageHover=面板资源.修理确定高亮, imagePress=面板资源.修理确定按下,
            onClick=function() self:修理确认(true) return true end
        })
        窗体:AddPngImage({
            x=修理取消按键.x, y=修理取消按键.y, width=修理取消按键.宽, height=修理取消按键.高,
            image=面板资源.修理取消, imageHover=面板资源.修理取消高亮, imagePress=面板资源.修理取消按下,
            onClick=function() self:修理确认(false) return true end
        })
    end)
end

function 强化装备Module:关闭修理提示框()
    if 修理提示框窗体对象 and 修理提示框窗体对象.valid then 修理提示框窗体对象:Close() end
    修理提示框窗体对象 = nil
    修理提示框窗体状态 = nil
end

function 强化装备Module:修理确认(执行)
    self:关闭修理提示框()
    if 执行 then self:sendPacket('CUSTOMXB 240') end
    return true
end

function 强化装备Module:银行左翻页点击()
    WinMgr.PlaySe(翻页音效,320)
    if 当前银行页 > 0 then
        当前银行页 = 当前银行页 - 1
        self:刷新银行页码()
        self:sendPacket('CUSTOMXB 220 ' .. tostring(当前银行页))
    end
end

function 强化装备Module:银行右翻页点击()
    WinMgr.PlaySe(翻页音效,320)
    if 当前银行页 < 最大银行页 - 1 then
        当前银行页 = 当前银行页 + 1
        self:刷新银行页码()
        self:sendPacket('CUSTOMXB 220 ' .. tostring(当前银行页))
    end
end

function 强化装备Module:银行整理点击()
    WinMgr.PlaySe(整理音效,320)
    self:sendPacket('CUSTOMXB 222 ' .. tostring(当前银行页))
end

function 强化装备Module:银行丢弃点击()
    if not (拾起中 and 拾起来源) then return true end
    WinMgr.PlaySe(整理音效,320)
    if 拾起来源.类型 == '银行' then
        self:sendPacket('CUSTOMXB 219 ' .. tostring(拾起来源.槽位) .. ' 2')
    elseif 拾起来源.类型 == '背包' then
        local 源页 = 拾起来源.页 or 1
        local 源槽 = 拾起来源.槽位
        if 源页 > 1 then self:sendPacket('CUSTOMXB 219 ' .. tostring(源槽) .. ' 1')
        else self:sendPacket('CUSTOMXB 219 ' .. tostring(源槽)) end
    else
        self:清拾起()
        return true
    end
    self:本地删除来源()
    self:清拾起()
    return true
end

function 强化装备Module:刷新银行页码()
    if 银行页码文字控件 and 银行页码文字控件.valid then
        银行页码文字控件:Set({text=(当前银行页 + 1) .. '/' .. 最大银行页})
    end
    self:刷新银行页按键()
end

function 强化装备Module:刷新银行页按键()
    for k = 1, 5 do
        local 按键 = 银行页按键控件列表[k]
        if 按键 and 按键.valid then
            if 当前银行页 == k - 1 then
                按键:Set({image='luaUI/modules/cg图档集/强化面板/第' .. k .. '格背包按下.png'})
            else
                按键:Set({image='luaUI/modules/cg图档集/强化面板/第' .. k .. '格背包.png'})
            end
        end
    end
end

function 强化装备Module:银行页按键悬停(k)
    local 按键 = 银行页按键控件列表[k]
    if 按键 and 按键.valid then
        if 当前银行页 == k - 1 then
            按键:Set({image='luaUI/modules/cg图档集/强化面板/第' .. k .. '格背包按下.png'})
        else
            按键:Set({image='luaUI/modules/cg图档集/强化面板/第' .. k .. '格背包高亮.png'})
        end
    end
end

function 强化装备Module:银行格坐标(i)
    local 列 = (i - 1) % 银行列数 + 1
    local 行 = math.floor((i - 1) / 银行列数) + 1
    return 银行格起始X + (列 - 1) * 银行格列步进, 银行格起始Y + (行 - 1) * 银行格行步进
end

function 强化装备Module:银行格点击(i)
    local 全局格 = 当前银行页 * 40 + (i - 1)
    local 命中双击 = false
    if 上次点击银行槽位 == 全局格 then
        if os and os.clock then
            local now = os.clock()
            local dt = 上次银行点击时间 and (now - 上次银行点击时间) or 999
            命中双击 = dt >= 0 and dt < 0.35
        else
            local df = 上次银行点击帧
            命中双击 = df >= 0 and (帧计数 - df) >= 0 and (帧计数 - df) <= 20
        end
    end
    if 命中双击 then
        上次点击银行槽位 = nil; 上次银行点击时间 = nil; 上次银行点击帧 = -1
        local 种类 = 银行格种类[i] or ''
        if 种类 ~= '' and (string.find(种类, '料理') or string.find(种类, '血药') or string.find(种类, '药水') or string.find(种类, '药品')) then
            宠物进补数据.物品来源 = '银行'
            宠物进补数据.物品槽位 = 全局格
            宠物进补数据.物品页 = 0
            if string.find(种类, '料理') then 宠物进补数据.物品模式 = '料理' else 宠物进补数据.物品模式 = '血药' end
            self:打开进补窗体()
            return true
        end
        WinMgr.PlaySe(翻页音效,320)
        self:sendPacket('CUSTOMXB 221 ' .. tostring(全局格))
        self:清拾起()
        return true
    end
    if 拾起中 then
        if 拾起来源.类型 == '背包' then
            WinMgr.PlaySe(整理音效,320)
            local 源槽 = 拾起来源.槽位
            local 源页 = 拾起来源.页 or 1
            if 源页 > 1 then
                self:sendPacket('CUSTOMXB 230 ' .. tostring(源槽) .. ' ' .. tostring(全局格) .. ' 1')
            else
                self:sendPacket('CUSTOMXB 230 ' .. tostring(源槽) .. ' ' .. tostring(全局格) .. ' 0')
            end
            local 源背包i = -1
            for j = 1, 20 do if 背包格槽位列表[j] == 源槽 then 源背包i = j break end end
            self:本地存入银行(全局格, 源背包i)
            self:清拾起()
            return true
        elseif 拾起来源.类型 == '银行' then
            local 源格 = 拾起来源.槽位
            if 源格 ~= 全局格 then
                WinMgr.PlaySe(整理音效,320)
                self:sendPacket('CUSTOMXB 223 ' .. tostring(源格) .. ' ' .. tostring(全局格))
                self:本地交换银行(源格, 全局格)
            end
            self:清拾起()
            return true
        else
            self:清拾起()
            return true
        end
    end
    local 图 = 银行格图号[i] or 0
    if 图 <= 0 then return true end
    上次点击银行槽位 = 全局格
    上次银行点击时间 = (os and os.clock and os.clock()) or 0
    上次银行点击帧 = 帧计数
    WinMgr.PlaySe(翻页音效,320)
    拾起中 = true
    拾起来源 = {类型='银行', 槽位=全局格, 页=当前银行页}
    self:定位拖拽图标(图)
    if 银行拖拽数量控件 and 银行拖拽数量控件.valid then
        local 数量 = 银行格数量[i] or 0
        拖拽数量 = 数量
        if 数量 > 1 then
            银行拖拽数量控件:Set({text=tostring(数量), visible=true})
            拖拽数量可见 = true
        else
            银行拖拽数量控件:Set({text='', visible=false})
            拖拽数量可见 = false
        end
    end
    if 银行格控件列表[i] and 银行格控件列表[i].valid then 银行格控件列表[i]:Set({image=面板资源.道具放置}) end
    if 银行格图标控件列表[i] and 银行格图标控件列表[i].valid then 银行格图标控件列表[i]:Set({image=-1}) end
    if 银行格数量控件列表[i] and 银行格数量控件列表[i].valid then 银行格数量控件列表[i]:Set({text='', visible=false}) end
    
    local 宝石控件组 = self.银行宝石图标控件列表 and self.银行宝石图标控件列表[i]
    if 宝石控件组 then
        for k = 1, 宝石角标最大数 do
            if 宝石控件组[k] and 宝石控件组[k].valid then
                宝石控件组[k]:Set({visible = false})
            end
        end
    end
    
    return true
end

function 强化装备Module:本地交换银行(甲格, 乙格)
    local 甲, 乙
    for j = 1, 40 do
        if 当前银行页 * 40 + (j - 1) == 甲格 then 甲 = j end
        if 当前银行页 * 40 + (j - 1) == 乙格 then 乙 = j end
    end
    if not 甲 or not 乙 then return end
    local 图, 数, 级 = 银行格图号[甲], 银行格数量[甲], 银行格等级[甲]
    银行格图号[甲], 银行格数量[甲], 银行格等级[甲] = 银行格图号[乙], 银行格数量[乙], 银行格等级[乙]
    银行格图号[乙], 银行格数量[乙], 银行格等级[乙] = 图, 数, 级
end

function 强化装备Module:本地存入银行(目标全局格, 源背包i)
    if 源背包i < 1 or 源背包i > 20 then return end
    local 银行i = 目标全局格 - 当前银行页 * 40 + 1
    if 银行i < 1 or 银行i > 40 then return end
    local 图, 数, 级 = 银行格图号[银行i], 银行格数量[银行i], 银行格等级[银行i]
    银行格图号[银行i], 银行格数量[银行i], 银行格等级[银行i] = 背包格图号[源背包i], 背包格数量[源背包i], 背包格等级[源背包i]
    背包格图号[源背包i], 背包格数量[源背包i], 背包格等级[源背包i] = 图, 数, 级
end

function 强化装备Module:本地取回银行(源全局格, 源页, 目标背包i)
    local 银行i = 源全局格 - (源页 or 0) * 40 + 1
    if 银行i < 1 or 银行i > 40 then return end
    local 图, 数, 级 = 银行格图号[银行i], 银行格数量[银行i], 银行格等级[银行i]
    银行格图号[银行i], 银行格数量[银行i], 银行格等级[银行i] = 背包格图号[目标背包i], 背包格数量[目标背包i], 背包格等级[目标背包i]
    背包格图号[目标背包i], 背包格数量[目标背包i], 背包格等级[目标背包i] = 图, 数, 级
end

function 强化装备Module:本地删除来源()
    if not 拾起来源 then return end
    if 拾起来源.类型 == '银行' then
        local 银行i = 拾起来源.槽位 - (拾起来源.页 or 0) * 40 + 1
        if 银行i >= 1 and 银行i <= 40 then
            银行格图号[银行i] = 0
            银行格数量[银行i] = 0
            银行格等级[银行i] = 0
        end
    elseif 拾起来源.类型 == '背包' then
        local 源槽 = 拾起来源.槽位
        for j = 1, 20 do
            if 背包格槽位列表[j] == 源槽 then
                背包格图号[j] = 0
                背包格数量[j] = 0
                背包格等级[j] = 0
                break
            end
        end
    end
end

function 强化装备Module:银行页按键(页)
    if 拾起中 then
        if 拾起来源.类型 == '银行' then
            WinMgr.PlaySe(整理音效,320)
            self:sendPacket('CUSTOMXB 224 ' .. tostring(拾起来源.槽位) .. ' ' .. tostring(页))
            self:清拾起()
            return true
        elseif 拾起来源.类型 == '背包' then
            WinMgr.PlaySe(整理音效,320)
            local 源页 = 拾起来源.页 or 1
            if 源页 > 1 then
                self:sendPacket('CUSTOMXB 218 ' .. tostring(拾起来源.槽位) .. ' ' .. tostring(页) .. ' 1')
            else
                self:sendPacket('CUSTOMXB 218 ' .. tostring(拾起来源.槽位) .. ' ' .. tostring(页))
            end
            self:清拾起()
            return true
        end
        self:清拾起()
        return true
    end
    WinMgr.PlaySe(翻页音效,320)
    当前银行页 = 页
    self:刷新银行页码()
    self:sendPacket('CUSTOMXB 220 ' .. tostring(页))
    return true
end

function 强化装备Module:银行格悬停(i)
    悬停银行格 = i
    悬停装备格 = nil
    悬停镶嵌格 = nil
    悬停背包格 = nil
    悬停强化槽 = false
    self.当前悬停Tooltip上下文 = nil
    self.当前悬停潜能来源类型 = nil
    self.当前悬停潜能来源索引 = nil
    local 图 = 银行格图号[i] or 0
    if 图 > 0 then self:sendPacket('CUSTOMXB 229 ' .. tostring(i)) else self:隐藏悬停提示() end
    return true
end

function 强化装备Module:银行格离开(i)
    if 悬停银行格 == i then
        悬停银行格 = nil
        self:隐藏悬停提示()
    end
    return true
end

function 强化装备Module:刷新银行格()
    for i = 1, 40 do
        local 图 = 银行格图号[i] or 0
        local 数量 = 银行格数量[i] or 0
        local 等级 = 银行格等级[i] or 0
        local 格 = 银行格控件列表[i]
        local 图标 = 银行格图标控件列表[i]
        local 数控件 = 银行格数量控件列表[i]
        local 被抓取中 = 拾起中 and 拾起来源 and 拾起来源.类型 == '银行' and 拾起来源.槽位 == 当前银行页 * 40 + (i - 1)
        if not 被抓取中 then
            if 格 and 格.valid then
                local 背景图 = 面板资源.道具放置
                if 图 > 0 and 等级 >= 10 then 背景图 = 面板资源.道具放置_10
                elseif 图 > 0 and 等级 >= 7 then 背景图 = 面板资源.道具放置_7
                elseif 图 > 0 and 等级 >= 4 then 背景图 = 面板资源.道具放置_4
                end
                格:Set({image = 背景图})
            end
            if 图标 and 图标.valid then
                if 图 > 0 then
                    local w, h = self:图档尺寸(图)
                    local 格x, 格y = self:银行格坐标(i)
                    图标:Set({
                        image = 图,
                        x = 格x + math.floor((银行格宽 - w) / 2),
                        y = 格y + math.floor((银行格高 - h) / 2),
                        width = w, height = h, visible = true,
                    })
                else
                    图标:Set({image = -1, visible = true})
                end
            end
            if 数控件 and 数控件.valid then
                if 图 > 0 and 数量 > 1 then
                    local 格x, 格y = self:银行格坐标(i)
                    local 数字宽 = #tostring(数量) * 面板坐标.数量文字.数字宽
                    数控件:Set({
                        text = tostring(数量), visible = true,
                        x = 格x + 银行格宽 - 数字宽 + 面板坐标.数量文字.偏移x,
                        y = 格y + 银行格高 - 面板坐标.数量文字.高 + 面板坐标.数量文字.偏移y,
                    })
                else
                    数控件:Set({text = '', visible = false})
                end
            end
            if self.银行宝石图标控件列表 then
                local 组 = self.银行宝石图标控件列表[i]
                if 组 then
                    local 宝石种类 = 银行格宝石种类[i] or 0
                    local 宝石等级 = 银行格宝石等级[i] or 0
                    local 角标可见 = (图 > 0) and 宝石种类 > 0
                    local 格x, 格y = self:银行格坐标(i)
                    local 偏移X = 宝石显示配置.角标.银行格偏移X or 0
                    local 偏移Y = 宝石显示配置.角标.银行格偏移Y or 0
                    self:绘制宝石角标(组, 格x + 偏移X, 格y + 偏移Y, 银行格宽, 银行格高, self:宝石角标文件(宝石种类, 宝石等级), 角标可见)
                end
            end
        else
            if 格 and 格.valid then 格:Set({image = 面板资源.道具放置}) end
            if 图标 and 图标.valid then 图标:Set({image = -1}) end
            if 数控件 and 数控件.valid then 数控件:Set({text = '', visible = false}) end
            if self.银行宝石图标控件列表 then
                local 组 = self.银行宝石图标控件列表[i]
                if 组 then
                    for k = 1, 宝石角标最大数 do
                        if 组[k] and 组[k].valid then 组[k]:Set({visible = false}) end
                    end
                end
            end
        end
    end
end

function 强化装备Module:收缩按钮()

end

function 强化装备Module:onUnload()
    self:关闭图片面板窗体()
    if self.开启按钮窗体状态 then
        self:releaseWindow(self.开启按钮窗体状态)
        self.开启按钮窗体状态 = nil
    end
end

function 强化装备Module:背包格坐标(i)
    local 列 = (i - 1) % 背包列数 + 1
    local 行 = math.floor((i - 1) / 背包列数) + 1
    return 背包区起始X + (列 - 1) * 背包列步进, 背包区起始Y + (行 - 1) * 背包行步进
end

function 强化装备Module:背包格悬停(i)
    self.缓存潜能文本 = ''
    self.缓存潜能主要品质 = 0
    self.缓存潜能附加品质 = 0
    悬停背包格 = i
    悬停装备格 = nil
    悬停镶嵌格 = nil
    悬停银行格 = nil
    悬停强化槽 = false
    self.当前悬停Tooltip上下文 = nil
    self.当前悬停潜能来源类型 = nil
    self.当前悬停潜能来源索引 = nil
    local 图 = 背包格图号[i] or 0
    if 图 > 0 then self:sendPacket('CUSTOMXB 213 ' .. tostring(i)) else self:隐藏悬停提示() end
    return true
end

function 强化装备Module:背包格离开(i)
    if 悬停背包格 == i then
        悬停背包格 = nil
        self:隐藏悬停提示()
    end
    return true
end

function 强化装备Module:装备格悬停(e)
    self.缓存潜能文本 = ''
    self.缓存潜能主要品质 = 0
    self.缓存潜能附加品质 = 0
    悬停装备格 = e
    悬停镶嵌格 = nil
    悬停背包格 = nil
    悬停银行格 = nil
    悬停强化槽 = false
    self.当前悬停Tooltip上下文 = { type = 'equip', index = e }
    self.当前悬停潜能来源类型 = 'equip'
    self.当前悬停潜能来源索引 = e
    if self.缓存装备悬停资料 then
        self.缓存装备悬停资料[e] = nil
    end
    local 图 = 装备格图号[e] or 0
    if 图 > 0 then
        self:sendPacket('CUSTOMXB 212 ' .. tostring(e))
    else
        self:显示装备格类型提示(e)
    end
    return true
end

function 强化装备Module:装备格离开(e)
    if 悬停装备格 == e then
        悬停装备格 = nil
        if self.缓存装备悬停资料 then self.缓存装备悬停资料[e] = nil end
        self.当前悬停Tooltip上下文 = nil
        self.当前悬停潜能来源类型 = nil
        self.当前悬停潜能来源索引 = nil
        self.缓存潜能文本 = ''
        self.缓存潜能主要品质 = 0
        self.缓存潜能附加品质 = 0
        self:隐藏悬停提示()
    end
    return true
end

function 强化装备Module:强化槽悬停()
    悬停强化槽 = true
    悬停装备格 = nil
    悬停镶嵌格 = nil
    悬停背包格 = nil
    悬停银行格 = nil
    self.当前悬停Tooltip上下文 = { type = 'enhance', index = 1 }
    self.当前悬停潜能来源类型 = nil
    self.当前悬停潜能来源索引 = nil
    if 强化槽显示 == 1 and 强化槽图号 > 0 then
        self:显示悬停提示(self.缓存属性文本, 当前强化等级, self.缓存耐久文本, self.缓存种类文本, self.缓存套装文本, self.缓存宝石文本, self:取得缓存潜能资料())
    else
        self:隐藏悬停提示()
    end
    return true
end

function 强化装备Module:强化槽离开()
    悬停强化槽 = false
    self.当前悬停Tooltip上下文 = nil
    self.当前悬停潜能来源类型 = nil
    self.当前悬停潜能来源索引 = nil
    self:隐藏悬停提示()
    return true
end

function 强化装备Module:背景点击()
    if 拾起中 then self:清拾起() return true end
    return false
end

function 强化装备Module:点击银行丢弃()
    if 拾起中 and 拾起来源 and 拾起来源.类型 == '背包' then
        WinMgr.PlaySe(整理音效,320)
        local 槽位 = 拾起来源.槽位
        local 源页 = 拾起来源.页 or 1
        if 源页 > 1 then
            self:sendPacket('CUSTOMXB 218 ' .. tostring(槽位) .. ' 0 1')
        else
            self:sendPacket('CUSTOMXB 218 ' .. tostring(槽位))
        end
        self:清拾起()
        return true
    end
    self:切换银行窗体()
    return true
end

function 强化装备Module:点击删除丢弃()
    if not (拾起中 and 拾起来源) then return true end
    WinMgr.PlaySe(整理音效,320)
    if 拾起来源.类型 == '银行' then
        self:sendPacket('CUSTOMXB 219 ' .. tostring(拾起来源.槽位) .. ' 2')
    elseif 拾起来源.类型 == '背包' then
        local 槽位 = 拾起来源.槽位
        local 源页 = 拾起来源.页 or 1
        if 源页 > 1 then
            self:sendPacket('CUSTOMXB 219 ' .. tostring(槽位) .. ' 1')
        else
            self:sendPacket('CUSTOMXB 219 ' .. tostring(槽位))
        end
    else
        self:清拾起()
        return true
    end
    self:本地删除来源()
    self:清拾起()
    return true
end

function 强化装备Module:清拾起()
    拾起中 = false
    上次左键按下 = false
    拾起来源 = nil
    拖拽数量可见 = false
    拖拽数量 = 0
    上次拖拽图标x = -9999
    上次拖拽图标y = -9999
    上次银行拖拽图标x = -9999
    上次银行拖拽图标y = -9999
    银行图标已隐藏 = true
    面板图标在银行区 = false
    if 丢弃遮罩控件 and 丢弃遮罩控件.valid then 丢弃遮罩控件:Set({visible=false}) end
    if 拖拽图标控件 and 拖拽图标控件.valid then 拖拽图标控件:Set({visible=false}) end
    if 拖拽数量文字控件 and 拖拽数量文字控件.valid then 拖拽数量文字控件:Set({text='', visible=false}) end
    if 银行拖拽图标控件 and 银行拖拽图标控件.valid then 银行拖拽图标控件:Set({visible=false}) end
    if 银行拖拽数量控件 and 银行拖拽数量控件.valid then 银行拖拽数量控件:Set({text='', visible=false}) end
    self:隐藏悬停提示()
    悬停装备格 = nil
    悬停背包格 = nil
    悬停强化槽 = false
    悬停镶嵌格 = nil
    self:刷新背包格()
    self:刷新装备格()
    self:刷新强化槽显示()
    self:刷新银行格()
    self:刷新镶嵌槽()
    self:刷新潜能界面()
end

local 背包同步计数 = 0

function 强化装备Module:定位拖拽图标(图)
    if not (拖拽图标控件 and 拖拽图标控件.valid) then return end
    local w, h = self:图档尺寸(图)
    拖拽图标宽 = w
    拖拽图标高 = h
    local 图标x, 图标y = 0, 0
    if 图片面板窗体对象 and 图片面板窗体对象.valid and CONST.Mouse then
        图标x = CONST.Mouse.x - 图片面板窗体对象.x - math.floor(w / 2)
        图标y = CONST.Mouse.y - 图片面板窗体对象.y - math.floor(h / 2)
    end
    上次拖拽图标x = 图标x
    上次拖拽图标y = 图标y
    上次银行拖拽图标x = -9999
    上次银行拖拽图标y = -9999
    银行图标已隐藏 = false
    面板图标在银行区 = false
    拖拽图标控件:Set({image=图, x=图标x, y=图标y, width=w, height=h, visible=true})
    if 银行拖拽图标控件 and 银行拖拽图标控件.valid then
        银行拖拽图标控件:Set({image=图, width=w, height=h, visible=false})
    end
end

function 强化装备Module:拾起更新(窗体)
    if not 窗体.valid then return false end
    帧计数 = 帧计数 + 1
    if 拾起中 and 拖拽图标控件 and 拖拽图标控件.valid then
        local mx, my = CONST.Mouse.x, CONST.Mouse.y
        local 在银行内 = false
        if 银行窗体对象 and 银行窗体对象.valid then
            在银行内 = (mx >= 银行窗体对象.x and mx <= 银行窗体对象.x + 银行窗宽 and my >= 银行窗体对象.y and my <= 银行窗体对象.y + 银行窗高)
        end
        if 在银行内 then
            if not 面板图标在银行区 then
                面板图标在银行区 = true
                if 拖拽图标控件.valid then 拖拽图标控件:Set({visible=false}) end
                if 拖拽数量文字控件 and 拖拽数量文字控件.valid then 拖拽数量文字控件:Set({visible=false}) end
            end
        else
            if 面板图标在银行区 then
                面板图标在银行区 = false
                上次拖拽图标x = -9999
                上次拖拽图标y = -9999
            end
            local 图标x = mx - 窗体.x - math.floor(拖拽图标宽 / 2)
            local 图标y = my - 窗体.y - math.floor(拖拽图标高 / 2)
            if 图标x ~= 上次拖拽图标x or 图标y ~= 上次拖拽图标y then
                上次拖拽图标x = 图标x
                上次拖拽图标y = 图标y
                拖拽图标控件:Set({x=图标x, y=图标y, visible=true})
            end
            if 拖拽数量可见 and 拖拽数量文字控件 and 拖拽数量文字控件.valid then
                local 数字宽 = #tostring(拖拽数量) * 面板坐标.数量文字.数字宽
                拖拽数量文字控件:Set({
                    x = 图标x + 拖拽图标宽 - 数字宽 + 面板坐标.数量文字.偏移x,
                    y = 图标y + 拖拽图标高 - 面板坐标.数量文字.高 + 面板坐标.数量文字.偏移y,
                })
            end
        end
        local 左键按下 = 窗体:CheckKeyState(CONST.VK.LBUTTON, CONST.KeyStateFlag.DOWN)
        local 在面板内 = (mx >= 窗体.x and mx <= 窗体.x + 图片面板宽 and my >= 窗体.y and my <= 窗体.y + 图片面板高)
        if 左键按下 and not 上次左键按下 then
            if not 在面板内 then self:清拾起() end
        end
        上次左键按下 = 左键按下
    end
    if not 拾起中 then
        背包同步计数 = 背包同步计数 + 1
        if 背包同步计数 >= 90 then
            背包同步计数 = 0
            self:sendPacket('CUSTOMXB 210')
        end
    end
    金钱同步计数 = 金钱同步计数 + 1
    if 金钱同步计数 >= 90 then
        金钱同步计数 = 0
        self:sendPacket('CUSTOMXB 214')
    end
    return false
end

function 强化装备Module:本地交换背包(甲槽位, 乙槽位)
    local 甲, 乙
    for j = 1, 20 do
        if 背包格槽位列表[j] == 甲槽位 then 甲 = j end
        if 背包格槽位列表[j] == 乙槽位 then 乙 = j end
    end
    if not 甲 or not 乙 then return end
    local 图, 数, 级 = 背包格图号[甲], 背包格数量[甲], 背包格等级[甲]
    背包格图号[甲], 背包格数量[甲], 背包格等级[甲] = 背包格图号[乙], 背包格数量[乙], 背包格等级[乙]
    背包格图号[乙], 背包格数量[乙], 背包格等级[乙] = 图, 数, 级
end

function 强化装备Module:背包格点击(i)
    local 命中双击 = false
    if 上次点击槽位 == 背包格槽位列表[i] then
        if os and os.clock then
            local now = os.clock()
            local dt = 上次点击时间 and (now - 上次点击时间) or 999
            命中双击 = dt >= 0 and dt < 0.35
        else
            local df = 上次点击帧
            命中双击 = df >= 0 and (帧计数 - df) >= 0 and (帧计数 - df) <= 20
        end
    end
    if 命中双击 then
        上次点击槽位 = nil; 上次点击时间 = nil; 上次点击帧 = -1
        self:清拾起()
        return self:双击背包格(i)
    end
    上次点击槽位 = 背包格槽位列表[i]
    上次点击时间 = (os and os.clock and os.clock()) or 0
    上次点击帧 = 帧计数
    if 拾起中 then
        if 拾起来源.类型 == '强化' then
            local 目标页 = 当前背包页
            if 目标页 > 1 then
                self:sendPacket('CUSTOMXB 202 ' .. tostring(背包格槽位列表[i]) .. ' ' .. tostring(目标页))
            else
                self:sendPacket('CUSTOMXB 202 ' .. tostring(背包格槽位列表[i]))
            end
            for j = 1, 20 do
                if 背包格槽位列表[j] == 背包格槽位列表[i] then
                    背包格图号[j] = 强化槽图号; 背包格数量[j] = 1; 背包格等级[j] = 当前强化等级
                end
            end
            强化槽显示 = 0; 强化槽图号 = 0; 当前强化等级 = 0
            self:清拾起()
        elseif 拾起来源.类型 == '装备' then
            local eq = 拾起来源.装备格
            local 目标页 = 当前背包页
            if 目标页 > 1 then
                self:sendPacket('CUSTOMXB 209 ' .. tostring(eq) .. ' ' .. tostring(背包格槽位列表[i]) .. ' ' .. tostring(目标页))
            else
                self:sendPacket('CUSTOMXB 209 ' .. tostring(eq) .. ' ' .. tostring(背包格槽位列表[i]))
            end
            for j = 1, 20 do
                if 背包格槽位列表[j] == 背包格槽位列表[i] then
                    背包格图号[j] = 装备格图号[eq]; 背包格数量[j] = 1; 背包格等级[j] = 装备格等级[eq]
                    break
                end
            end
            装备格图号[eq] = 0; 装备格等级[eq] = 0
            self:清拾起()
        elseif 拾起来源.类型 == '银行' then
            WinMgr.PlaySe(整理音效,320)
            local 源页 = 拾起来源.页 or 0
            if 当前背包页 > 1 then
                self:sendPacket('CUSTOMXB 228 ' .. tostring(拾起来源.槽位) .. ' ' .. tostring(背包格槽位列表[i]))
            else
                self:sendPacket('CUSTOMXB 221 ' .. tostring(拾起来源.槽位) .. ' ' .. tostring(背包格槽位列表[i]))
            end
            self:本地取回银行(拾起来源.槽位, 源页, i)
            self:清拾起()
        elseif 拾起来源.类型 == '镶嵌装备' then
            local 目标页 = 当前背包页
            if 目标页 > 1 then
                self:sendPacket('CUSTOMXB 252 ' .. tostring(背包格槽位列表[i]) .. ' ' .. tostring(目标页))
            else
                self:sendPacket('CUSTOMXB 252 ' .. tostring(背包格槽位列表[i]))
            end
            self:清拾起()
        elseif 拾起来源.类型 == '镶嵌宝石' then
            local 目标页 = 当前背包页
            if 目标页 > 1 then
                self:sendPacket('CUSTOMXB 253 ' .. tostring(背包格槽位列表[i]) .. ' ' .. tostring(目标页))
            else
                self:sendPacket('CUSTOMXB 253 ' .. tostring(背包格槽位列表[i]))
            end
            self:清拾起()
        elseif 拾起来源.类型 == '镶嵌结果' then
            local 目标页 = 当前背包页
            if 目标页 > 1 then
                self:sendPacket('CUSTOMXB 254 ' .. tostring(背包格槽位列表[i]) .. ' ' .. tostring(目标页))
            else
                self:sendPacket('CUSTOMXB 254 ' .. tostring(背包格槽位列表[i]))
            end
            self:清拾起()
        elseif 拾起来源.类型 == '潜能装备' then
            local 目标页 = 当前背包页
			if 目标页 > 1 then
				self:sendPacket('CUSTOMXB '..tostring(潜能协议.取回装备)..' '..tostring(背包格槽位列表[i])..' '..tostring(目标页))
			else
				self:sendPacket('CUSTOMXB '..tostring(潜能协议.取回装备)..' '..tostring(背包格槽位列表[i]))
			end
            self:清拾起()
        elseif 拾起来源.类型 == '潜能道具' then
            local 目标页 = 当前背包页
			if 目标页 > 1 then
				self:sendPacket('CUSTOMXB '..tostring(潜能协议.取回道具)..' '..tostring(背包格槽位列表[i])..' '..tostring(目标页))
			else
				self:sendPacket('CUSTOMXB '..tostring(潜能协议.取回道具)..' '..tostring(背包格槽位列表[i]))
			end
            self:清拾起()
        elseif 拾起来源.类型 == '背包' then
            local 源槽 = 拾起来源.槽位
            local 目标槽 = 背包格槽位列表[i]
            local 源页 = 拾起来源.页 or 1
            if 源页 <= 1 then
                if 当前背包页 <= 1 then
                    if 源槽 ~= 目标槽 then
                        self:sendPacket('CUSTOMXB 207 ' .. tostring(源槽) .. ' ' .. tostring(目标槽))
                        self:本地交换背包(源槽, 目标槽)
                    end
                else
                    WinMgr.PlaySe(整理音效,320)
                    self:sendPacket('CUSTOMXB 225 ' .. tostring(源槽) .. ' ' .. tostring(当前背包页 - 1))
                end
            else
                if 当前背包页 <= 1 then
                    WinMgr.PlaySe(整理音效,320)
                    self:sendPacket('CUSTOMXB 226 ' .. tostring(源槽))
                else
                    if 源槽 ~= 目标槽 then
                        WinMgr.PlaySe(整理音效,320)
                        self:sendPacket('CUSTOMXB 227 ' .. tostring(源槽) .. ' ' .. tostring(目标槽))
                        self:本地交换背包(源槽, 目标槽)
                    end
                end
            end
            self:清拾起()
        else
            self:清拾起()
        end
        return true
    end
    local 图 = 背包格图号[i] or 0
    if 图 <= 0 then return true end
    拾起中 = true
    拾起来源 = {类型='背包', 槽位=背包格槽位列表[i], 页=当前背包页}
    if 丢弃遮罩控件 and 丢弃遮罩控件.valid then 丢弃遮罩控件:Set({visible=true}) end
    self:定位拖拽图标(图)
    if 拖拽数量文字控件 and 拖拽数量文字控件.valid then
        local 数量 = 背包格数量[i] or 0
        拖拽数量 = 数量
        if 数量 > 1 then
            拖拽数量文字控件:Set({text=tostring(数量), visible=true})
            拖拽数量可见 = true
        else
            拖拽数量文字控件:Set({text='', visible=false})
            拖拽数量可见 = false
        end
    end
    if 背包格控件列表[i] and 背包格控件列表[i].valid then 背包格控件列表[i]:Set({image=面板资源.道具放置}) end
    if 背包格图标控件列表[i] and 背包格图标控件列表[i].valid then 背包格图标控件列表[i]:Set({image=-1}) end
    if 背包格数量控件列表[i] and 背包格数量控件列表[i].valid then 背包格数量控件列表[i]:Set({text='', visible=false}) end
    
    local 宝石控件组 = self.背包宝石图标控件列表 and self.背包宝石图标控件列表[i]
    if 宝石控件组 then
        for k = 1, 宝石角标最大数 do
            if 宝石控件组[k] and 宝石控件组[k].valid then
                宝石控件组[k]:Set({visible = false})
            end
        end
    end
    
    return true
end

function 强化装备Module:双击背包格(i)
    local 图 = 背包格图号[i] or 0
    if 图 <= 0 then return true end
    local 种类 = 背包格种类[i] or ''
    if 种类 ~= '' and (string.find(种类, '料理') or string.find(种类, '血药') or string.find(种类, '药水') or string.find(种类, '药品')) then
        宠物进补数据.物品来源 = '背包'
        宠物进补数据.物品槽位 = 背包格槽位列表[i]
        宠物进补数据.物品页 = 当前背包页
        if string.find(种类, '料理') then 宠物进补数据.物品模式 = '料理' else 宠物进补数据.物品模式 = '血药' end
        self:打开进补窗体()
        return true
    end
    if 当前背包页 > 1 then
        self:sendPacket('CUSTOMXB 226 ' .. tostring(背包格槽位列表[i]))
        return true
    end
    self:sendPacket('CUSTOMXB 208 ' .. tostring(背包格槽位列表[i]))
    return true
end

function 强化装备Module:装备格点击(e)
    if self.潜能模式 then return true end
    if 拾起中 then
        if 拾起来源.类型 == '背包' then
            local slot = 拾起来源.槽位
            local 源页 = 拾起来源.页 or 1
            if 源页 > 1 then
                self:sendPacket('CUSTOMXB 208 ' .. tostring(slot) .. ' ' .. tostring(e) .. ' ' .. tostring(源页))
            else
                self:sendPacket('CUSTOMXB 208 ' .. tostring(slot) .. ' ' .. tostring(e))
            end
            self:清拾起()
        elseif 拾起来源.类型 == '装备' then
            if 拾起来源.装备格 ~= e then
                local src = 拾起来源.装备格
                self:sendPacket('CUSTOMXB 211 ' .. tostring(src) .. ' ' .. tostring(e))
                local tmp图 = 装备格图号[src]; local tmp级 = 装备格等级[src]
                装备格图号[src] = 装备格图号[e]; 装备格等级[src] = 装备格等级[e]
                装备格图号[e] = tmp图; 装备格等级[e] = tmp级
            end
            self:清拾起()
        else
            self:清拾起()
        end
        return true
    end
    local 图 = 装备格图号[e] or 0
    if 图 <= 0 then return true end
    拾起中 = true
    拾起来源 = {类型='装备', 装备格=e}
    if 丢弃遮罩控件 and 丢弃遮罩控件.valid then 丢弃遮罩控件:Set({visible=true}) end
    self:定位拖拽图标(图)
    if 拖拽数量文字控件 and 拖拽数量文字控件.valid then
        拖拽数量文字控件:Set({text='', visible=false})
        拖拽数量可见 = false
    end
    if 装备格控件列表[e] and 装备格控件列表[e].valid then 装备格控件列表[e]:Set({image=面板资源.道具放置}) end
    if 装备格图标控件列表[e] and 装备格图标控件列表[e].valid then 装备格图标控件列表[e]:Set({image=-1}) end
    
    local 宝石控件组 = self.装备格宝石图标控件列表 and self.装备格宝石图标控件列表[e]
    if 宝石控件组 then
        for k = 1, 宝石角标最大数 do
            if 宝石控件组[k] and 宝石控件组[k].valid then
                宝石控件组[k]:Set({visible = false})
            end
        end
    end
    
    return true
end

function 强化装备Module:强化槽点击()
    if 拾起中 then
        if 拾起来源.类型 == '背包' then
            local 源页 = 拾起来源.页 or 1
            if 源页 > 1 then
                self:sendPacket('CUSTOMXB 201 ' .. tostring(拾起来源.槽位) .. ' ' .. tostring(源页))
            else
                self:sendPacket('CUSTOMXB 201 ' .. tostring(拾起来源.槽位))
            end
        end
        self:清拾起()
        return true
    end
    if 强化槽显示 ~= 1 or 强化槽图号 <= 0 then return true end
    拾起中 = true
    拾起来源 = {类型='强化'}
    if 丢弃遮罩控件 and 丢弃遮罩控件.valid then 丢弃遮罩控件:Set({visible=true}) end
    if 中心图标控件 and 中心图标控件.valid then 中心图标控件:Set({visible=false}) end
    if 道具放置槽控件 and 道具放置槽控件.valid then 道具放置槽控件:Set({image=面板资源.道具放置}) end
    self:定位拖拽图标(强化槽图号)
    if 拖拽数量文字控件 and 拖拽数量文字控件.valid then
        拖拽数量文字控件:Set({text='', visible=false})
    end
    拖拽数量可见 = false
    拖拽数量 = 1
    return true
end

function 强化装备Module:图档尺寸(图号)
    if Graphic and Graphic.GetGrahpicInfo then
        local ok, r = pcall(Graphic.GetGrahpicInfo, 图号)
        if ok and r and r.w and r.w > 0 and r.h and r.h > 0 then
            return r.w, r.h
        end
    end
    return 32, 32
end

function 强化装备Module:宝石角标文件(种类, 等级)
    local 名 = 宝石图标名[种类]
    if not 名 then return {} end
    local 列表 = {}
    local 整5 = math.floor(等级 / 5)
    local 余 = 等级 % 5
    for i = 1, 整5 do table.insert(列表, {文件 = 资源目录 .. '5级宝石' .. 名 .. '.png', 宽 = 8, 高 = 8}) end
    for i = 1, 余 do table.insert(列表, {文件 = 资源目录 .. '1级宝石' .. 名 .. '.png', 宽 = 6, 高 = 6}) end
    return 列表
end

function 强化装备Module:绘制宝石角标(控件组, 槽x, 槽y, 槽宽, 槽高, 列表, 可见)
    if 可见 == nil then 可见 = true end
    local 配置 = 宝石显示配置.角标
    local x = 槽x + 配置.起始偏移X
    local y = 槽y + 配置.起始偏移Y
    for i = 1, 宝石角标最大数 do
        local 控件 = 控件组[i]
        if 控件 and 控件.valid then
            local 项 = 可见 and 列表[i] or nil
            if 项 then
                local 偏移X = 0
                local 偏移Y = 0
                if 项.宽 == 8 then
                    偏移X = 配置.大宝石.偏移X
                    偏移Y = 配置.大宝石.偏移Y
                elseif 项.宽 == 6 then
                    偏移X = 配置.小宝石.偏移X
                    偏移Y = 配置.小宝石.偏移Y
                end
                控件:Set({image = 项.文件, x = x + 偏移X, y = y + 偏移Y, width = 项.宽, height = 项.高, visible = true})
                x = x + 项.宽 + 配置.间距
            else
                控件:Set({visible = false})
            end
        end
    end
end

function 强化装备Module:宝石ID到角标(gemId)
    local id = tonumber(gemId) or 0
    if id < 宝石ID下限 then return 0, 0 end
    local 差值 = id - 宝石ID下限
    return math.floor(差值 / 10) + 1, (差值 % 10) + 1
end

function 强化装备Module:刷新合成格宝石角标()
    if self.镶嵌合成格宝石图标控件列表 then
        local 种类, 等级 = self:宝石ID到角标(self.镶嵌宝石信息 and self.镶嵌宝石信息.合成格 or 0)
        local 槽 = 面板坐标.合成格
        self:绘制宝石角标(self.镶嵌合成格宝石图标控件列表, 槽.x, 槽.y, 槽.宽, 槽.高, self:宝石角标文件(种类, 等级), self.镶嵌模式)
    end
end

function 强化装备Module:刷新宝石效果文本()
    local 配置 = 宝石显示配置.效果文本
    local 标题控件 = self.镶嵌宝石效果标题控件
    local 内容控件 = self.镶嵌宝石效果控件列表
    local 可见 = self.镶嵌模式
    local 效果串 = ''
    if self.镶嵌宝石信息 then
        if (self.镶嵌宝石信息.合成格 or 0) > 0 and self.镶嵌宝石信息.合成格效果 and self.镶嵌宝石信息.合成格效果 ~= '' then
            效果串 = self.镶嵌宝石信息.合成格效果
        elseif (self.镶嵌宝石信息.宝石格 or 0) > 0 and self.镶嵌宝石信息.宝石格效果 and self.镶嵌宝石信息.宝石格效果 ~= '' then
            效果串 = self.镶嵌宝石信息.宝石格效果
        end
    end
    local 效果列表 = {}
    if 效果串 ~= '' then
        for 单个 in string.gmatch(效果串, "[^|]+") do
            table.insert(效果列表, 单个)
        end
    end
    local 有内容 = #效果列表 > 0
    local 左X = 配置.起始X
    local 顶Y = 配置.起始Y
    if 标题控件 and 标题控件.valid then
        local 标题宽 = 宝石效果文本宽(配置.标题.文本, 配置.标题.汉字宽, 配置.标题.符号宽)
        标题控件:Set({
            text = 配置.标题.文本,
            x = 左X, y = 顶Y,
            width = 标题宽 + 2, height = 配置.标题.高,
            font = 配置.标题.字体, color = 配置.标题.颜色,
            visible = 可见 and 有内容,
        })
    end
    if 内容控件 then
        for 行 = 1, 配置.行数 do
            local 本行效果 = {}
            local 宽表 = {}
            for 列 = 1, 配置.每行个数 do
                local 序号 = (行 - 1) * 配置.每行个数 + 列
                local 文本 = 效果列表[序号]
                本行效果[列] = 文本
                local 宽 = 文本 and 宝石效果文本宽(文本, 配置.内容.汉字宽, 配置.内容.符号宽) or 0
                宽表[列] = 宽
            end
            local 本行Y = 顶Y + 配置.标题.高 + 配置.行间距 + (行 - 1) * (配置.内容.高 + 配置.行间距)
            local 光标 = 左X
            for 列 = 1, 配置.每行个数 do
                local 控件 = 内容控件[行] and 内容控件[行][列]
                if 控件 and 控件.valid then
                    local 文本 = 本行效果[列]
                    if 文本 and 可见 then
                        local 宽 = 宽表[列]
                        控件:Set({
                            text = 文本,
                            x = 光标, y = 本行Y,
                            width = 宽 + 2, height = 配置.内容.高,
                            font = 配置.内容.字体, color = 配置.内容.颜色,
                            visible = true,
                        })
                        光标 = 光标 + 宽 + 配置.列间距
                    else
                        控件:Set({visible = false})
                    end
                end
            end
        end
    end
end

function 强化装备Module:刷新装备格()
    for i = 1, #装备格位置 do
        local 被抓取中 = 拾起中 and 拾起来源 and 拾起来源.类型 == '装备' and 拾起来源.装备格 == i
        local 图 = 装备格图号[i] or 0
        local 等级 = 装备格等级[i] or 0
        local 格 = 装备格控件列表[i]
        local 图标 = 装备格图标控件列表[i]
        if 被抓取中 then 图 = 0 end
        if 格 and 格.valid then
            local 背景图 = 面板资源.道具放置
            if 图 > 0 and 等级 >= 10 then 背景图 = 面板资源.道具放置_10
            elseif 图 > 0 and 等级 >= 7 then 背景图 = 面板资源.道具放置_7
            elseif 图 > 0 and 等级 >= 4 then 背景图 = 面板资源.道具放置_4
            end
            格:Set({image = 背景图, visible = not self.镶嵌模式 and not self.潜能模式})
        end
        if 图标 and 图标.valid then
            if 图 > 0 then
                local w, h = self:图档尺寸(图)
                local 格x = 装备区起始X + (装备格位置[i].列 - 1) * 装备列步进
                local 格y = 装备区起始Y + (装备格位置[i].行 - 1) * 装备行步进
                图标:Set({
                    image = 图,
                    visible = not self.镶嵌模式 and not self.潜能模式,
                    x = 格x + math.floor((装备格宽 - w) / 2),
                    y = 格y + math.floor((装备格高 - h) / 2),
                    width = w, height = h,
                })
            else
                图标:Set({image = -1, visible = not self.镶嵌模式 and not self.潜能模式})
            end
        end
        if 装备格文字控件列表[i] and 装备格文字控件列表[i].valid then
            装备格文字控件列表[i]:Set({visible = (not self.镶嵌模式 and not self.潜能模式) and (图 <= 0)})
        end
        local 宝石控件组 = self.装备格宝石图标控件列表 and self.装备格宝石图标控件列表[i]
        if 宝石控件组 then
            local 宝石种类 = 装备格宝石种类[i] or 0
            local 宝石等级 = 装备格宝石等级[i] or 0
            local 角标可见 = (not self.镶嵌模式 and not self.潜能模式) and (图 > 0) and 宝石种类 > 0
            local 格x = 装备区起始X + (装备格位置[i].列 - 1) * 装备列步进
            local 格y = 装备区起始Y + (装备格位置[i].行 - 1) * 装备行步进
            local 偏移X = 宝石显示配置.角标.装备格偏移X or 0
            local 偏移Y = 宝石显示配置.角标.装备格偏移Y or 0
            self:绘制宝石角标(宝石控件组, 格x + 偏移X, 格y + 偏移Y, 装备格宽, 装备格高, self:宝石角标文件(宝石种类, 宝石等级), 角标可见)
        end
    end
    if 角色图档控件 and 角色图档控件.valid then
        local 图号 = 玩家形象图号
        if not 图号 or 图号 <= 0 then 图号 = Player and Player.imageNo or 0 end
        if 图号 and 图号 > 0 then
            local w, h = self:图档尺寸(图号)
            local 格x = 装备区起始X + 装备列步进
            local 格y = 装备区起始Y + 2 * 装备行步进
            角色图档控件:Set({
                animeNo = 图号, action = 0, dir = 5,
                visible = not self.镶嵌模式 and not self.潜能模式,
                x = 格x + math.floor((装备格宽 - w) / 2),
                y = 格y + math.floor((装备格高 - h) / 2),
                width = w, height = h,
            })
        else
            角色图档控件:Set({visible = false})
        end
    end
end

function 强化装备Module:右栏背包按键(页)
    if 拾起中 then
        if 拾起来源.类型 == '背包' then
            WinMgr.PlaySe(整理音效,320)
            local 源槽 = 拾起来源.槽位
            local 源页 = 拾起来源.页 or 1
            if 源页 == 页 then
                self:cliSendMsg('该物品已在背包第' .. tostring(页) .. '页', 4)
            else
                self:sendPacket('CUSTOMXB 232 ' .. tostring(源页) .. ' ' .. tostring(源槽) .. ' ' .. tostring(页))
            end
            self:清拾起()
            return true
        end
        self:清拾起()
        return true
    end
    WinMgr.PlaySe(翻页音效,320)
    当前背包页 = 页
    self:更新背包槽位列表()
    self:sendPacket('CUSTOMXB 216 ' .. (页 - 1))
    self:刷新页码文字()
    self:刷新右栏背包按键()
    return true
end

function 强化装备Module:右栏背包悬停(k)
    local 按键 = 右栏背包控件列表[k]
    if 按键 and 按键.valid and 拾起中 then
        按键:Set({image = 资源目录 .. '右边栏背包' .. k .. '高亮.png'})
    end
    return true
end

function 强化装备Module:刷新右栏背包按键()
    for k = 1, 5 do
        local 按键 = 右栏背包控件列表[k]
        if 按键 and 按键.valid then
            local 图 = (k == 当前背包页) and (资源目录 .. '右边栏背包' .. k .. '高亮.png') or (资源目录 .. '右边栏背包' .. k .. '.png')
            按键:Set({image = 图})
        end
    end
end

function 强化装备Module:刷新背包格()
    for i = 1, 20 do
        local 图 = 背包格图号[i] or 0
        local 数量 = 背包格数量[i] or 0
        local 等级 = 背包格等级[i] or 0
        local 格 = 背包格控件列表[i]
        local 图标 = 背包格图标控件列表[i]
        local 数控件 = 背包格数量控件列表[i]
        local 被抓取中 = 拾起中 and 拾起来源 and 拾起来源.类型 == '背包' and 拾起来源.槽位 == 背包格槽位列表[i]
        if not 被抓取中 then
            if 格 and 格.valid then
                local 背景图 = 面板资源.道具放置
                if 图 > 0 and 等级 >= 10 then 背景图 = 面板资源.道具放置_10
                elseif 图 > 0 and 等级 >= 7 then 背景图 = 面板资源.道具放置_7
                elseif 图 > 0 and 等级 >= 4 then 背景图 = 面板资源.道具放置_4
                end
                格:Set({image = 背景图})
            end
            if 图标 and 图标.valid then
                if 图 > 0 then
                    local w, h = self:图档尺寸(图)
                    local 格x, 格y = self:背包格坐标(i)
                    图标:Set({
                        image = 图,
                        x = 格x + math.floor((背包格宽 - w) / 2),
                        y = 格y + math.floor((背包格高 - h) / 2),
                        width = w, height = h,
                    })
                else
                    图标:Set({image = -1})
                end
            end
            if 数控件 and 数控件.valid then
                if 图 > 0 and 数量 > 1 then
                    local 格x, 格y = self:背包格坐标(i)
                    local 数字宽 = #tostring(数量) * 面板坐标.数量文字.数字宽
                    数控件:Set({
                        text = tostring(数量), visible = true,
                        x = 格x + 背包格宽 - 数字宽 + 面板坐标.数量文字.偏移x,
                        y = 格y + 背包格高 - 面板坐标.数量文字.高 + 面板坐标.数量文字.偏移y,
                    })
                else
                    数控件:Set({text = '', visible = false})
                end
            end
            if self.背包宝石图标控件列表 then
                local 组 = self.背包宝石图标控件列表[i]
                if 组 then
                    local 宝石种类 = 背包格宝石种类[i] or 0
                    local 宝石等级 = 背包格宝石等级[i] or 0
                    local 角标可见 = (图 > 0) and 宝石种类 > 0
                    local 格x, 格y = self:背包格坐标(i)
                    local 偏移X = 宝石显示配置.角标.背包格偏移X or 0
                    local 偏移Y = 宝石显示配置.角标.背包格偏移Y or 0
                    self:绘制宝石角标(组, 格x + 偏移X, 格y + 偏移Y, 背包格宽, 背包格高, self:宝石角标文件(宝石种类, 宝石等级), 角标可见)
                end
            end
        else
            if 格 and 格.valid then 格:Set({image = 面板资源.道具放置}) end
            if 图标 and 图标.valid then 图标:Set({image = -1}) end
            if 数控件 and 数控件.valid then 数控件:Set({text = '', visible = false}) end
            if self.背包宝石图标控件列表 then
                local 组 = self.背包宝石图标控件列表[i]
                if 组 then
                    for k = 1, 宝石角标最大数 do
                        if 组[k] and 组[k].valid then 组[k]:Set({visible = false}) end
                    end
                end
            end
        end
    end
end

return 强化装备Module
