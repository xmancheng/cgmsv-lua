---模块类
local Module = ModuleBase:createModule('setupMagicAttr')

--- 加载模块钩子
function Module:onLoad()
  self:logInfo('load')
  local magicMap = {
    { 1950, 1951, 1952, 2353, 2354, 2355, 2756, 2757, 2758, 2759, 1949, 2749 },
    { 2050, 2051, 2052, 2453, 2454, 2455, 2856, 2857, 2858, 2859, 2049, 2849 },
    { 2150, 2151, 2152, 2553, 2554, 2555, 2956, 2957, 2958, 2959, 2149, 2949 },
    { 2250, 2251, 2252, 2653, 2654, 2655, 3056, 3057, 3058, 3059, 2249, 3049 },
  }
  local attr = {
    { 100, 0, 0, 0 },
    { 0, 100, 0, 0 },
    { 0, 0, 100, 0 },
    { 0, 0, 0, 100 },
  }
  for i, v in ipairs(magicMap) do
    for _, techId in ipairs(v) do
      Tech.SetTechMagicAttribute(techId, table.unpack(attr[i]))
    end
  end  
  --Tech.SetTechMagicAttribute(2050, 100, 100, 100, 100); --全10属性魔法

  local magicSkill = {
    { 2730, 2731, 2732, 2733, 2734, 2735, 2736, 2737, 2738, 2739, 319, 25819 },
    { 2830, 2831, 2832, 2833, 2834, 2835, 2836, 2837, 2838, 2839, 119, 26019, 429 },
    { 2930, 2931, 2932, 2933, 2934, 2935, 2936, 2937, 2938, 2939, 529, 629, 200709, 8109 },
    { 3030, 3031, 3032, 3033, 3034, 3035, 3036, 3037, 3038, 3039, 25719, 11104, 11109 },
  }
  local value = {
    { 100, 0, 0, 0 },
    { 0, 100, 0, 0 },
    { 0, 0, 100, 0 },
    { 0, 0, 0, 100 },
  }
  for i, v in ipairs(magicSkill) do
    for _, techId in ipairs(v) do
      Tech.SetTechMagicAttribute(techId, table.unpack(value[i]))
    end
  end

end

--- 卸载模块钩子
function Module:onUnload()
  self:logInfo('unload')
end

return Module;
