local CFG = {
  GROUP       = "TBL",
  MAX_PARTS   = 10000,
  BRUSH_SIZES = {1, 10, 30, 40, 60, 100, 1000},
  WALL_ERASE  = 0,
  GRAV_OFF    = 1,
  GRAV_ON     = 0,
}

local function get(t, k)
  local ok, v = pcall(function() return t[k] end)
  if ok then return v end
  return nil
end

local UI = get(_G, "ui") or get(_G, "interface")
local function def(name) return get(elem, "DEFAULT_PT_" .. name) end
local function clamp(v, a, b) if v < a then return a elseif v > b then return b end return v end
local function zs(list) local t = {}; for _, z in ipairs(list) do t[z] = true end; return t end

--  /\_/\
-- ( o.o )
--  > ^ <
 
local N = false
local ELEMENTS = {
  {1,"H","Hydrogen","g",0.0899,-259,-253,"brennt/explosiv","1766"},
  {2,"He","Helium","g",0.1785,-272,-269,"nicht brennbar","1895"},
  {3,"Li","Lithium","s",0.534,181,1342,"brennt (rot)","1817"},
  {4,"Be","Beryllium","p",1.85,1287,2470,"Pulver","1798"},
  {5,"B","Boron","s",2.34,2076,3927,"brennt (grün), schwer","1808"},
  {6,"C","Carbon","s",2.27,3550,3830,"brennt","antiquity"},
  {7,"N","Nitrogen","g",1.251,-210,-196,"nicht brennbar","1772"},
  {8,"O","Oxygen","g",1.429,-219,-183,"fördert Verbrennung","1774"},
  {9,"F","Fluorine","g",1.696,-220,-188,"extrem oxidierend","1886"},
  {10,"Ne","Neon","g",0.900,-249,-246,"nicht brennbar","1898"},
  {11,"Na","Sodium","s",0.971,98,883,"brennt (gelb)","1807"},
  {12,"Mg","Magnesium","s",1.74,650,1090,"brennt grell weiß","1755/1808"},
  {13,"Al","Aluminium","p",2.70,660,2519,"Pulver","1825"},
  {14,"Si","Silicon","s",2.33,1414,3265,"schwer","1824"},
  {15,"P","Phosphorus","s",1.82,44,277,"weißer P selbstentzündlich","1669"},
  {16,"S","Sulfur","s",2.07,115,445,"brennt (blau)","antiquity"},
  {17,"Cl","Chlorine","g",3.214,-102,-34,"nicht brennbar, oxidierend","1774"},
  {18,"Ar","Argon","g",1.784,-189,-186,"nicht brennbar","1894"},
  {19,"K","Potassium","s",0.862,63,759,"brennt (violett)","1807"},
  {20,"Ca","Calcium","s",1.55,842,1484,"brennt (orange)","1808"},
  {21,"Sc","Scandium","p",2.99,1541,2836,"Pulver","1879"},
  {22,"Ti","Titanium","p",4.51,1668,3287,"Pulver","1791"},
  {23,"V","Vanadium","p",6.0,1910,3407,"Pulver","1801"},
  {24,"Cr","Chromium","s",7.15,1907,2671,"schwer","1797"},
  {25,"Mn","Manganese","p",7.21,1246,2061,"Pulver","1774"},
  {26,"Fe","Iron","p",7.87,1538,2861,"Stahlwolle/Pulver","antiquity"},
  {27,"Co","Cobalt","p",8.86,1495,2927,"Pulver","1735"},
  {28,"Ni","Nickel","p",8.91,1455,2913,"Pulver","1751"},
  {29,"Cu","Copper","s",8.96,1085,2562,"nein","antiquity"},
  {30,"Zn","Zinc","s",7.14,420,907,"brennt (grünlich)","antiquity"},
  {31,"Ga","Gallium","s",5.91,30,2204,"nein","1875"},
  {32,"Ge","Germanium","s",5.32,938,2833,"nein","1886"},
  {33,"As","Arsenic","s",5.73,817,N,"brennt","~1250"},
  {34,"Se","Selenium","s",4.81,221,685,"brennt (blau)","1817"},
  {35,"Br","Bromine","l",3.12,-7,59,"nicht brennbar","1826"},
  {36,"Kr","Krypton","g",3.749,-157,-153,"nicht brennbar","1898"},
  {37,"Rb","Rubidium","s",1.53,39,688,"entzündet sich","1861"},
  {38,"Sr","Strontium","s",2.64,777,1382,"brennt (rot)","1790"},
  {39,"Y","Yttrium","p",4.47,1526,2930,"Späne","1794"},
  {40,"Zr","Zirconium","p",6.51,1855,4409,"Pulver","1789"},
  {41,"Nb","Niobium","s",8.57,2477,4744,"nein","1801"},
  {42,"Mo","Molybdenum","s",10.28,2623,4639,"nein","1778"},
  {43,"Tc","Technetium","s",11.5,2157,4265,"–","1937"},
  {44,"Ru","Ruthenium","s",12.37,2334,4150,"nein","1844"},
  {45,"Rh","Rhodium","s",12.41,1964,3695,"nein","1803"},
  {46,"Pd","Palladium","s",12.02,1555,2963,"nein","1803"},
  {47,"Ag","Silver","s",10.49,962,2162,"nein","antiquity"},
  {48,"Cd","Cadmium","p",8.65,321,767,"Pulver","1817"},
  {49,"In","Indium","s",7.31,157,2072,"nein","1863"},
  {50,"Sn","Tin","s",7.31,232,2602,"nein","antiquity"},
  {51,"Sb","Antimony","s",6.70,631,1587,"brennt","antiquity"},
  {52,"Te","Tellurium","s",6.24,450,988,"brennt","1782"},
  {53,"I","Iodine","s",4.93,114,184,"nicht brennbar","1811"},
  {54,"Xe","Xenon","g",5.894,-112,-108,"nicht brennbar","1898"},
  {55,"Cs","Caesium","s",1.93,28,671,"entzündet sich","1860"},
  {56,"Ba","Barium","s",3.51,727,1845,"brennt (grün)","1808"},
  {57,"La","Lanthanum","p",6.15,920,3464,"Pulver","1839"},
  {58,"Ce","Cerium","s",6.77,795,3443,"funkt","1803"},
  {59,"Pr","Praseodymium","p",6.77,935,3520,"Pulver","1885"},
  {60,"Nd","Neodymium","p",7.01,1024,3074,"Pulver","1885"},
  {61,"Pm","Promethium","s",7.26,1042,3000,"–","1945"},
  {62,"Sm","Samarium","p",7.52,1072,1794,"Pulver","1879"},
  {63,"Eu","Europium","s",5.24,826,1529,"entzündet sich","1901"},
  {64,"Gd","Gadolinium","p",7.90,1312,3273,"Pulver","1880"},
  {65,"Tb","Terbium","p",8.23,1356,3230,"Pulver","1843"},
  {66,"Dy","Dysprosium","p",8.55,1407,2567,"Pulver","1886"},
  {67,"Ho","Holmium","p",8.80,1461,2720,"Pulver","1878"},
  {68,"Er","Erbium","p",9.07,1529,2868,"Pulver","1843"},
  {69,"Tm","Thulium","p",9.32,1545,1950,"Pulver","1879"},
  {70,"Yb","Ytterbium","p",6.90,824,1196,"Pulver","1878"},
  {71,"Lu","Lutetium","p",9.84,1652,3402,"Pulver","1907"},
  {72,"Hf","Hafnium","p",13.31,2233,4603,"Pulver","1923"},
  {73,"Ta","Tantalum","s",16.65,3017,5458,"nein","1802"},
  {74,"W","Tungsten","s",19.25,3422,5555,"nein","1783"},
  {75,"Re","Rhenium","p",21.02,3186,5596,"Pulver","1925"},
  {76,"Os","Osmium","p",22.59,3033,5012,"Pulver (giftiges OsO4)","1803"},
  {77,"Ir","Iridium","s",22.56,2446,4428,"nein","1803"},
  {78,"Pt","Platinum","s",21.45,1768,3825,"nein","1748"},
  {79,"Au","Gold","s",19.32,1064,2856,"nein","antiquity"},
  {80,"Hg","Mercury","l",13.53,-39,357,"nicht brennbar","antiquity"},
  {81,"Tl","Thallium","s",11.85,304,1473,"brennt","1861"},
  {82,"Pb","Lead","s",11.34,327,1749,"nein","antiquity"},
  {83,"Bi","Bismuth","s",9.78,271,1564,"brennt (blau)","~1500/1753"},
  {84,"Po","Polonium","s",9.20,254,962,"–","1898"},
  {85,"At","Astatine","s",6.4,302,337,"–","1940"},
  {86,"Rn","Radon","g",9.73,-71,-62,"nicht brennbar","1900"},
  {87,"Fr","Francium","s",N,27,677,"–","1939"},
  {88,"Ra","Radium","s",5.5,700,1737,"–","1898"},
  {89,"Ac","Actinium","s",10.07,1050,3200,"–","1899"},
  {90,"Th","Thorium","p",11.72,1750,4788,"Pulver","1828"},
  {91,"Pa","Protactinium","s",15.37,1572,4000,"–","1913"},
  {92,"U","Uranium","p",19.05,1135,4131,"Pulver","1789"},
  {93,"Np","Neptunium","s",20.45,644,3900,"–","1940"},
  {94,"Pu","Plutonium","p",19.82,640,3228,"Pulver","1940"},
  {95,"Am","Americium","s",13.67,1176,2011,"–","1944"},
  {96,"Cm","Curium","s",13.51,1345,3100,"–","1944"},
  {97,"Bk","Berkelium","s",14.78,986,2627,"–","1949"},
  {98,"Cf","Californium","s",15.1,900,1470,"–","1950"},
  {99,"Es","Einsteinium","s",8.84,860,996,"–","1952"},
  {100,"Fm","Fermium","s",N,1527,N,"–","1952/53"},
  {101,"Md","Mendelevium","s",N,827,N,"–","1955"},
  {102,"No","Nobelium","s",N,827,N,"–","1958"},
  {103,"Lr","Lawrencium","s",N,1627,N,"–","1961"},
  {104,"Rf","Rutherfordium","s",17,2100,5500,"–","1964/69"},
  {105,"Db","Dubnium","s",21.6,N,N,"–","1967/70"},
  {106,"Sg","Seaborgium","s",23.5,N,N,"–","1974"},
  {107,"Bh","Bohrium","s",26.5,N,N,"–","1981"},
  {108,"Hs","Hassium","s",28.5,N,N,"–","1984"},
  {109,"Mt","Meitnerium","s",27.5,N,N,"–","1982"},
  {110,"Ds","Darmstadtium","s",26.5,N,N,"–","1994"},
  {111,"Rg","Roentgenium","s",23,N,N,"–","1994"},
  {112,"Cn","Copernicium","l",14,N,30,"–","1996"},
  {113,"Nh","Nihonium","s",16,430,1100,"–","2003/04"},
  {114,"Fl","Flerovium","l",11.4,N,N,"–","1998/99"},
  {115,"Mc","Moscovium","s",13.5,400,1100,"–","2003"},
  {116,"Lv","Livermorium","s",12.9,400,1100,"–","2000"},
  {117,"Ts","Tennessine","s",7.2,450,610,"–","2010"},
  {118,"Og","Oganesson","s",6,50,80,"–","2002/06"},
}

local NATIVE_NAMES = {
  [1]="H2", [3]="LITH", [8]="OXYG", [14]="SLCN", [15]="PHOS", [22]="TTAN", [26]="IRON",
  [37]="RBDM", [74]="TUNG", [79]="GOLD", [80]="MERC", [84]="POLO", [92]="URAN", [94]="PLUT",
}
--     /\
--    /  \
--   | () |
--   |    |
--  /| /\ |\
-- / |/  \| \
--   ^^  ^^
--   ||  ||
--  /_\  /_\

local COLORS = {
  0xE8F4FF,0xFFE9A8,0xBFBFCF,0x6FA070,0x4A3A2A,0x2B2B2B,0x7C9CFF,0x9BD4FF,0xE0F080,0xFF6A3A,
  0xE8DCA0,0xE8E8E8,0xC9CDD4,0x5F6475,0xF0E6A0,0xF5E22A,0xBFE04A,0xA070FF,0xC8B0E0,0xE8D8B8,
  0xCFC8C0,0x9CA3AD,0x8A9AAA,0xB0B8C0,0xB08CA8,0x8A8478,0x4A6FB5,0xA8B0A0,0xB87333,0x9FB0BA,
  0xB5C8E0,0x8E959C,0x6E7A6A,0x9A3A3A,0x8B2A14,0xE0D4FF,0xD6A6B0,0xD8B878,0xC0C8B8,0xA8B0B8,
  0x7C8CA8,0x6A7078,0x5FA8A0,0x8890A0,0xD0D4D8,0xC8C8C0,0xE6E6EE,0xB8B0A0,0x9898B8,0xB0B4BC,
  0x8088A0,0x707080,0x5A2A78,0x8890FF,0xE8D070,0xA8C890,0xB0A8A0,0xA8A090,0x90B890,0xB090B8,
  0x90E0A0,0xC0B090,0xD8A0B8,0xC0D0D8,0xA0D8B0,0xB8B890,0xD8B8A0,0xE0A0A8,0xA0C8C8,0xC8C8A0,
  0xB8B8C8,0x808898,0x6C7C98,0x5A5A64,0x787C84,0x6890B0,0xD0D4D0,0xDCDCE4,0xFFD700,0xC4C8D8,
  0x8090A0,0x55586A,0xD0A8B8,0x90FFB0,0x403040,0xA0FFA0,0xE8C080,0xB8FF70,0x80E0FF,0x6E7C86,
  0xA0B0B8,0x6FA550,0x70B0A8,0xB0A8C0,0xC0C8E0,0xE0D8A0,0xD0B0D0,0xA0E0D0,0xB0FFC8,0xE0A0FF,
  0xFF90B0,0xFFB070,0xFFD070,0x80A8FF,0x70C8FF,0x60E0E0,0x60FFB0,0x90FF70,0xC8FF60,0xFFFF70,
  0xFFC860,0xFF9860,0xFF7090,0xFF60C8,0xE060FF,0xA070FF,0x7080FF,0x60B8FF,
}

local GROUP_SETS = {
  alkali      = {3,11,19,37,55,87},
  erdalkali   = {4,12,20,38,56,88},
  halogen     = {9,17,35,53,85,117},
  edelgas     = {2,10,18,36,54,86,118},
  metalloid   = {5,14,32,33,51,52},
  nichtmetall = {1,6,7,8,15,16,34},
  postmetall  = {13,31,49,50,81,82,83,84,113,114,115,116},
}
local GROUP_OF = {}
for g, list in pairs(GROUP_SETS) do for _, z in ipairs(list) do GROUP_OF[z] = g end end
for z = 57, 71 do GROUP_OF[z] = "lanthanid" end
for z = 89, 103 do GROUP_OF[z] = "actinid" end
for z = 1, 118 do GROUP_OF[z] = GROUP_OF[z] or "uebergang" end

local function isRadioactive(z) return z == 43 or z == 61 or z >= 84 end

local function activity(z)
  local a
  if z == 43 or z == 61 then a = {emit=0.0008, particle="PHOT", heat=2, decay=0.00003}
  elseif z == 85 or z == 87 then a = {emit=0.010, particle="NEUT", heat=4, decay=0.0008}
  elseif z >= 84 and z <= 89 then a = {emit=0.004, particle="NEUT", heat=4, decay=(z == 84 or z == 86) and 0.0003 or 0.0001}
  elseif z == 90 or z == 92 then a = {emit=0.0004, particle="NEUT", heat=2, decay=0.00002}
  elseif z >= 90 and z <= 99 then a = {emit=0.0015, particle="NEUT", heat=3, decay=0.0001}
  elseif z >= 100 and z <= 103 then a = {emit=0.010, particle="NEUT", heat=5, decay=0.0004}
  else a = {emit=0.020, particle="NEUT", heat=6, decay=0.0020} end
  a.daughter = (z == 43 and 44) or (z == 61 and 62) or (z - 2)
  return a
end

local FLAME_RGB = {
  ["grell weiß"]={255,255,255}, ["grünlich"]={150,255,130}, ["grün"]={60,255,90}, ["rot"]={255,60,40},
  ["gelb"]={255,220,60}, ["violett"]={190,90,255}, ["orange"]={255,140,30}, ["blau"]={70,110,255},
}
local FLAME_NAME = {
  ["grell weiß"]="bright white", ["grünlich"]="greenish", ["grün"]="green", ["rot"]="red",
  ["gelb"]="yellow", ["violett"]="violet", ["orange"]="orange", ["blau"]="blue",
}
local FLAME_ORDER = {"grell weiß","grünlich","grün","rot","gelb","violett","orange","blau"}
local DEFAULT_BURN  = {mode="burn", chance=0.02, ignK=623, temp=1100, life=60, rgb={255,140,40}}
local THERMITE_BURN = {mode="burn", life=40, temp=3200, rgb={255,255,255}}

local function parseBurn(txt)
  local t = txt or ""
  local function has(s) return string.find(t, s, 1, true) ~= nil end
  if has("extrem oxidierend") then return {mode="oxidizer", power=2} end
  if has("fördert Verbrennung") then return {mode="oxidizer", power=1} end
  if has("nicht brennbar") then
    if has("oxidierend") then return {mode="oxidizer", power=1} end
    return {mode="none"}
  end
  if has("nein") or t == "–" or t == "" then return {mode="none"} end

  local b = {mode="burn", chance=0.02, ignK=623, temp=1100, life=60, rgb={255,140,40}}
  for _, key in ipairs(FLAME_ORDER) do
    if has(key) then b.rgb = FLAME_RGB[key]; b.colorName = FLAME_NAME[key]; break end
  end
  if has("grell weiß") then b.temp = 3000 end
  if has("explosiv") then b.explosive=true; b.chance=0.4; b.ignK=773; b.temp=2200; b.life=25; b.rgb={200,220,255} end
  if has("schwer") then b.chance=0.004; b.ignK=973; b.life=90; b.hard=true end
  if has("Pulver") or has("Späne") or has("Stahlwolle") then b.chance=0.006; b.ignK=873; b.temp=1500; b.life=30; b.powder=true end
  if has("funkt") then b.chance=0.03; b.ignK=573; b.temp=900; b.life=20; b.rgb={255,235,180}; b.sparks=true end
  if has("selbstentzündlich") or has("entzündet sich") then b.mode="pyro"; b.ignK=300; b.life=70 end
  if has("selbstentzündlich") then b.ignK = 308 end
  return b
end

local created    = {}
local INFO       = {}
local Z_OF_ID    = {}
local OXI        = {}
local HEAT_SRC   = {}
local WATERS     = {}
local BURN_BY_ID = {}
local NOREACT    = {}
local METAL_ID   = {}
local NOBLE_ID   = {}
local NITRIDE_ID = {}
local FLAME_ID   = nil

local function ID(z) local c = created[z]; return c and c.id end

local GATE = 3
local function roll(p) return math.random() < p * GATE end

local NB_ID, NB_T, NB_N = {}, {}, 0

local function scan(x, y)
  local hot, oxi, water = false, 0, false
  NB_N = 0
  for dx = -1, 1 do
    for dy = -1, 1 do
      if dx ~= 0 or dy ~= 0 then
        local j = sim.pmap(x + dx, y + dy)
        if j then
          local t = sim.partProperty(j, "type")
          NB_N = NB_N + 1; NB_ID[NB_N] = j; NB_T[NB_N] = t
          if HEAT_SRC[t] then hot = true
          elseif OXI[t] then oxi = oxi + OXI[t]
          elseif WATERS[t] then water = true end
        end
      end
    end
  end
  return hot, oxi, water
end

local function nbOf(t)  for k = 1, NB_N do if NB_T[k] == t then return NB_ID[k] end end end
local function nbIn(set) for k = 1, NB_N do if set[NB_T[k]] then return NB_ID[k] end end end
local function heat(i, d) sim.partProperty(i, "temp", clamp(sim.partProperty(i, "temp") + d, 0, 9000)) end

local function addPressure(x, y, d)
  pcall(function()
    local cx, cy = math.floor(x / sim.CELL), math.floor(y / sim.CELL)
    sim.pressure(cx, cy, 1, 1, clamp(sim.pressure(cx, cy) + d, -256, 256))
  end)
end

local function startFlame(i, x, y, id, burn)
  sim.partChangeType(i, FLAME_ID)
  sim.partProperty(i, "ctype", id)
  sim.partProperty(i, "life", burn.life + math.random(0, 20))
  sim.partProperty(i, "temp", burn.temp)
  if burn.explosive then addPressure(x, y, 40) end
end

local function energyNear(x, y)
  for dx = -1, 1 do
    for dy = -1, 1 do
      local ok, n = pcall(sim.photons, x + dx, y + dy)
      if ok and n then return n, sim.partProperty(n, "type") end
    end
  end
end

local NOBLE_Z   = zs{44,45,46,73,76,77,78,79}
local NOBLEGAS  = zs{2,10,18,36,54,86,118}
local AMALG_Z   = zs{3,11,19,37,55,13,30,48,49,50,79,47,29,82,31,20,38,56}
local NITRIDE_Z = zs{12,22,40,13,5,14}

local WATER_S = {[3]=1,[11]=2,[19]=3,[37]=4,[55]=5,[87]=5,[20]=0.6,[38]=1,[56]=1.5,[12]=0.15,[21]=0.2,[39]=0.2,[63]=0.6,[70]=0.3}
for z = 57, 71 do WATER_S[z] = WATER_S[z] or 0.15 end
WATER_S[57] = 0.4; WATER_S[58] = 0.2

local HALO_S  = {[17]=0.5,[35]=0.3,[53]=0.1,[85]=0.1,[117]=0.1}
local CHALC   = {[16]=1,[34]=0.8,[52]=0.5}
local ABSORB  = {[5]=0.5,[48]=0.6,[64]=0.7,[72]=0.4,[49]=0.3,[62]=0.5,[63]=0.4}
local SHIELD  = {[82]=0.3,[83]=0.2,[73]=0.25,[74]=0.3}
local FISS    = {[93]={0.08,2},[95]={0.1,2},[96]={0.12,2},[97]={0.08,2},[98]={0.18,3},[99]={0.1,2}}

--    .--.
--   |o_o |
--   |:_/ |
--  //   \ \
-- (|     | )
--/'\_   _/`\
--\___)=(___/

local METAL_F = {}
for z = 1, 118 do
  local g = GROUP_OF[z]
  if g == "alkali" or g == "erdalkali" then METAL_F[z] = 1.0
  elseif g == "lanthanid" then METAL_F[z] = 0.9
  elseif g == "actinid" then METAL_F[z] = 0.8
  elseif g == "uebergang" or g == "postmetall" then METAL_F[z] = 0.5
  elseif g == "metalloid" then METAL_F[z] = 0.3 end
end

local REACT = {}

REACT[1] = function(i, x, y, hot)
  if not hot then return end
  local o = nbOf(ID(8)) or nbOf(def("OXYG"))
  if o and roll(0.1) then
    local wtrv = def("WTRV")
    if wtrv then
      sim.partChangeType(o, wtrv); sim.partChangeType(i, wtrv)
      sim.partProperty(o, "temp", 700); sim.partProperty(i, "temp", 700)
    end
    addPressure(x, y, 25)
    return true
  end
end

REACT[9] = function(i, x, y)
  for k = 1, NB_N do
    local t = NB_T[k]
    if not NOREACT[t] and not HEAT_SRC[t] and roll(0.013) then
      sim.partKill(NB_ID[k])
      heat(i, 30)
      if math.random() < 0.3 then sim.partKill(i); return true end
      break
    end
  end
end

local RADIATION_Z = {}
for z in pairs(ABSORB) do RADIATION_Z[z] = true end
for z in pairs(SHIELD) do RADIATION_Z[z] = true end
for z in pairs(FISS)   do RADIATION_Z[z] = true end
RADIATION_Z[90] = true

local function radiationRole(z, i, x, y)
  if not RADIATION_Z[z] then return end
  local n, tt = energyNear(x, y)
  if not n then return end
  local NEUT, PHOT = def("NEUT"), def("PHOT")
  local ab, sh, fs = ABSORB[z], SHIELD[z], FISS[z]
  if tt == NEUT then
    if ab and math.random() < ab then sim.partKill(n); heat(i, 5); return end
    if fs and math.random() < fs[1] then
      sim.partKill(n)
      for _ = 1, fs[2] do sim.partCreate(-3, x, y, NEUT) end
      heat(i, 25); addPressure(x, y, 1)
      return
    end
    if z == 90 and math.random() < 0.1 and ID(92) then
      sim.partKill(n); sim.partChangeType(i, ID(92)); return true
    end
  end
  if sh and (tt == NEUT or tt == PHOT) and math.random() < sh then sim.partKill(n); heat(i, 2) end
end

local function applyRole(z, i, x, y, t, hot, water)
  local f = METAL_F[z]

  local ws = WATER_S[z]
  if ws and water and (z ~= 12 or hot) and roll(math.min(0.5, 0.05 * ws)) then
    local w = nbIn(WATERS)
    if w and ID(1) then
      sim.partChangeType(w, ID(1)); sim.partProperty(w, "temp", 600)
      addPressure(x, y, 3 * ws)
      if ws >= 0.5 then startFlame(i, x, y, ID(z), BURN_BY_ID[ID(z)] or DEFAULT_BURN); return true end
      heat(i, 50)
    end
  end

  if f then
    if not NOBLE_Z[z] then
      local a = def("ACID") and nbOf(def("ACID"))
      if a and roll(0.02 * f) then
        if ID(1) then sim.partChangeType(i, ID(1)) else sim.partKill(i) end
        if math.random() < 0.4 then sim.partKill(a) end
        return true
      end
      if t > 550 then
        local o = nbOf(ID(8)) or nbOf(def("OXYG"))
        if o and roll(0.02 * f) then sim.partKill(o); heat(i, 60) end
      end
    end
    if AMALG_Z[z] and ID(80) then
      local hg = nbOf(ID(80))
      if hg and roll(0.01) then heat(hg, 20); sim.partKill(i); return true end
    end
  end

  local hs = HALO_S[z]
  if hs then
    for k = 1, NB_N do
      local nt = NB_T[k]
      local mf = METAL_ID[nt]
      if mf and not NOBLE_ID[nt] and roll(0.04 * hs * mf) then
        sim.partKill(NB_ID[k])
        local salt = def("SALT")
        if salt then sim.partChangeType(i, salt); heat(i, 100 + 150 * hs) else sim.partKill(i) end
        addPressure(x, y, 2 * hs * mf)
        return true
      end
    end
  end

  local cs = CHALC[z]
  if cs then
    for k = 1, NB_N do
      local nt = NB_T[k]
      local mf = METAL_ID[nt]
      if mf and not NOBLE_ID[nt] and (mf >= 0.9 or sim.partProperty(NB_ID[k], "temp") > 400) and roll(0.04 * cs * mf) then
        heat(NB_ID[k], 300)
        sim.partKill(i)
        return true
      end
    end
  end

  if NOBLEGAS[z] and def("SPRK") and nbOf(def("SPRK")) and roll(0.3) then
    sim.partCreate(-3, x, y, def("PHOT"))
  end

  if z == 7 then
    local li = ID(3) and nbOf(ID(3))
    if li and roll(0.03) then heat(li, 30); sim.partKill(i); return true end
    if t >= 900 then
      for k = 1, NB_N do
        if NITRIDE_ID[NB_T[k]] and roll(0.05) then heat(NB_ID[k], 150); sim.partKill(i); return true end
      end
    end
  end

  if z == 31 and ID(13) then
    local al = nbOf(ID(13))
    if al and roll(0.02) then sim.partKill(al) end
  end

  if z == 13 and ID(26) and (hot or t >= 1100) then
    local fe = nbOf(ID(26))
    if fe and roll(0.3) then
      sim.partKill(fe)
      startFlame(i, x, y, ID(13), THERMITE_BURN)
      addPressure(x, y, 5)
      return true
    end
  end

  if z == 4 then
    for k = 1, NB_N do
      local nz = Z_OF_ID[NB_T[k]]
      if nz and nz >= 84 and roll(0.01) then sim.partCreate(-3, x, y, def("NEUT")); break end
    end
  end
end

local function makeUpdate(z, id, burn, act)
  local react = REACT[z]
  return function(i, x, y, s, nt)
    if act then
      if math.random() < act.emit then
        sim.partCreate(-3, x, y, def(act.particle))
        heat(i, act.heat)
      end
      if math.random() < act.decay then
        local d = ID(act.daughter)
        if d then sim.partChangeType(i, d) else sim.partKill(i) end
        return true
      end
    end
    if radiationRole(z, i, x, y) then return true end
    if math.random(GATE) ~= 1 then return end
    local t = sim.partProperty(i, "temp")
    local hot, oxi, water = scan(x, y)
    if react and react(i, x, y, hot, oxi, water) then return true end
    if applyRole(z, i, x, y, t, hot, water) then return true end
    if burn and (burn.mode == "burn" or burn.mode == "pyro") then
      local ignite = false
      if burn.mode == "pyro" then
        ignite = t >= burn.ignK
      elseif t >= burn.ignK and roll(0.05) then
        ignite = true
      elseif hot and roll(burn.chance * (1 + 1.5 * math.min(oxi, 3))) then
        ignite = true
      end
      if ignite then startFlame(i, x, y, id, burn); return true end
    end
  end
end

local STATE_BASE = {
  g = {Advection=1.0, AirDrag=0.0,  AirLoss=0.99, Loss=0.30, Collision=-0.1, Gravity=0.0, Diffusion=2.0, HotAir=0.0005, Falldown=0, Hardness=0},
  l = {Advection=0.6, AirDrag=0.01, AirLoss=0.98, Loss=0.95, Collision=0.0,  Gravity=0.1, Diffusion=0.0, HotAir=0.0,    Falldown=2, Hardness=20},
  p = {Advection=0.7, AirDrag=0.04, AirLoss=0.96, Loss=0.94, Collision=-0.1, Gravity=0.3, Diffusion=0.0, HotAir=0.0,    Falldown=1, Hardness=30},
  s = {Advection=0.0, AirDrag=0.0,  AirLoss=0.90, Loss=0.0,  Collision=0.0,  Gravity=0.0, Diffusion=0.0, HotAir=0.0,    Falldown=0, Hardness=1},
}
local HEAT_OVR  = {Cu=251, Ag=251, Au=251, Al=237, Hg=190}
local ROOM_K    = 295.15
local STATE_TXT = {g="gas", l="liquid", p="powder", s="solid"}

local function buildDescription(row, burn, act)
  local z, st, year = row[1], row[4], row[9]
  local tags = {}
  local function add(s) if #tags < 3 then tags[#tags + 1] = s end end
  if burn.mode == "oxidizer" then add("Oxidizer.")
  elseif burn.mode == "pyro" then add("Ignites spontaneously.")
  elseif burn.mode == "burn" then
    if burn.explosive then add("Explosive.")
    elseif burn.colorName then add("Burns " .. burn.colorName .. ".")
    elseif burn.sparks then add("Throws sparks.")
    elseif burn.powder then add("Burns as powder.")
    else add("Flammable.") end
  end
  if WATER_S[z] then add("Reacts with water.") end
  if z == 9 then add("Corrodes most materials.") end
  if HALO_S[z] then add("Attacks metals (salt).") end
  if CHALC[z] then add("Forms sulfides with hot metals.") end
  if z == 13 then add("Thermite with iron.") end
  if z == 4 then add("Neutron source with alpha emitters.") end
  if ABSORB[z] then add("Absorbs neutrons.") end
  if SHIELD[z] then add("Blocks radiation.") end
  if FISS[z] then add("Fissile.") end
  if z == 90 then add("Breeds uranium.") end
  if z == 7 then add("Forms nitrides (Li, hot Mg/Ti/Al).") end
  if z == 31 then add("Dissolves aluminium.") end
  if NOBLEGAS[z] then add("Glows when sparked.") end
  if AMALG_Z[z] then add("Amalgam with mercury.") end
  if NOBLE_Z[z] then add("Acid-resistant.") elseif METAL_F[z] then add("Dissolves in acid.") end
  if act then add("Radioactive, decays to Z=" .. act.daughter .. ".") end
  return string.format("Z=%d: %s, found %s. %s", z, STATE_TXT[st], year, table.concat(tags, " "))
end
--        Unser Gott...Suelord
--        ____________________
--     .-'                    '-.
--   .'     ..          ..       '.
--  /      (o)        (o)          \
-- |                            .   |
-- |      \________________/        |
--  \                              /
--   '.__________________________.'
--     |  |    |  |    |  |    |  |
--     |__|    |__|    |__|    |__|

local function buildProps(row, burn, act)
  local z, sym, nm, st, dens, mp = row[1], row[2], row[3], row[4], row[5], row[6]
  local p = {}
  for k, v in pairs(STATE_BASE[st]) do p[k] = v end

  local typeFlag = ({g=elem.TYPE_GAS, l=elem.TYPE_LIQUID, p=elem.TYPE_PART, s=elem.TYPE_SOLID})[st]
  local props = typeFlag
  if act then props = props + (get(elem, "PROP_RADIOACTIVE") or 0) end
  local g = GROUP_OF[z]
  if st == "s" and (g=="alkali" or g=="erdalkali" or g=="uebergang" or g=="postmetall" or g=="lanthanid" or g=="actinid") then
    props = props + (get(elem, "PROP_CONDUCTS") or 0)
  end
  p.Properties = props

  if st == "g" then
    p.Weight = 1
    local d = dens or 1.293
    p.Gravity = clamp((d - 1.293) / 1.293 * 0.05, -0.05, 0.05)
  elseif st == "l" then
    p.Weight = clamp(math.floor(5 + (dens or 5) * 25), 2, 100)
  elseif st == "p" then
    p.Weight = clamp(math.floor(20 + (dens or 5) * 3), 20, 99)
  else
    p.Weight = 100
  end
  if NOBLE_Z[z] then p.Hardness = 0 end
  if WATER_S[z] and WATER_S[z] >= 1 then p.Hardness = 60 end

  p.Name        = sym:upper()
  p.Colour      = COLORS[z]
  p.MenuVisible = 1
  p.MenuSection = act and get(elem, "SC_NUCLEAR") or ({g=get(elem,"SC_GAS"), l=get(elem,"SC_LIQUID"),
                  p=get(elem,"SC_POWDERS"), s=get(elem,"SC_SOLIDS")})[st]
  p.Temperature = ROOM_K
  p.HeatConduct = HEAT_OVR[sym] or ({alkali=150, erdalkali=140, uebergang=120, postmetall=140, lanthanid=100,
                  actinid=100, metalloid=80, nichtmetall=40, halogen=30, edelgas=20})[g]
  p.Flammable, p.Explosive, p.Meltable = 0, 0, 0

  if (st == "s" or st == "p") and mp and (mp + 273.15) < 9000 then
    p.HighTemperature = mp + 273.15
    p.HighTemperatureTransition = def("LAVA")
  end

  p.Description = nm .. " (" .. sym .. ") - " .. INFO[z].desc
  return p
end

local function createElement(row)
  local z, sym = row[1], row[2]
  local burn = parseBurn(row[8])
  local act = isRadioactive(z) and activity(z) or nil
  INFO[z] = {full = row[3], sym = sym, desc = buildDescription(row, burn, act)}

  local nname = NATIVE_NAMES[z]
  local nat = nname and def(nname)
  if type(nat) == "number" and nat >= 0 then
    created[z] = {id = nat, ident = "DEFAULT_PT_" .. nname, sym = sym, native = true}
    Z_OF_ID[nat] = z
    return true
  end

  local id = elem.allocate(CFG.GROUP, sym:upper())
  if not id or id < 0 then id = elem.allocate(CFG.GROUP, "E" .. z) end
  if not id or id < 0 then return false end

  local props = buildProps(row, burn, act)
  local base = elem.element(def("DUST"))
  base.Identifier = nil
  for k, v in pairs(props) do base[k] = v end
  if not pcall(elem.element, id, base) then
    base.Color = base.Colour; base.Colour = nil
    elem.element(id, base)
  end
  pcall(elem.property, id, "Colour", COLORS[z])
  pcall(elem.property, id, "Color", COLORS[z])

  local ident = "TBL_PT_" .. sym:upper()
  local ok, r = pcall(elem.property, id, "Identifier")
  if ok and r then ident = r end
  created[z] = {id = id, ident = ident, sym = sym}
  Z_OF_ID[id] = z

  if burn.mode == "oxidizer" then OXI[id] = burn.power end
  if burn.mode == "burn" or burn.mode == "pyro" then BURN_BY_ID[id] = burn end
  elem.property(id, "Update", makeUpdate(z, id, burn, act))
  return true
end

local function createFlame()
  local id = elem.allocate(CFG.GROUP, "TFLM")
  if not id or id < 0 then return end
  FLAME_ID = id
  local base = elem.element(def("DUST")); base.Identifier = nil
  for k, v in pairs({
    Name="TFLM", Colour=0xFF8C28, MenuVisible=0, Properties=elem.TYPE_GAS, Falldown=0, Weight=1,
    Advection=0.9, AirDrag=0.0, AirLoss=0.97, Loss=0.20, Collision=0.0, Gravity=-0.1, Diffusion=0.5,
    HotAir=0.001, HeatConduct=200, Flammable=0, Explosive=0, Meltable=0, Hardness=0, Temperature=1100,
    Description="Flame of a burning periodic-table element (colour depends on the source).",
  }) do base[k] = v end
  if not pcall(elem.element, id, base) then base.Color = base.Colour; base.Colour = nil; elem.element(id, base) end

  elem.property(id, "Update", function(i, x, y, s, nt)
    local life = sim.partProperty(i, "life") - 1
    if life <= 0 then sim.partKill(i); return true end
    sim.partProperty(i, "life", life)
    local ct = sim.partProperty(i, "ctype")
    local b = BURN_BY_ID[ct] or (ct == ID(13) and THERMITE_BURN) or nil
    if b and sim.partProperty(i, "temp") < b.temp then sim.partProperty(i, "temp", b.temp) end
  end)
  elem.property(id, "Graphics", function(i, r, g, b)
    local rgb = {255, 140, 40}
    local ok, ct = pcall(sim.partProperty, i, "ctype")
    if ok then
      if BURN_BY_ID[ct] then rgb = BURN_BY_ID[ct].rgb
      elseif ct == ID(13) then rgb = THERMITE_BURN.rgb end
    end
    local life = clamp(sim.partProperty(i, "life") * 6, 40, 255)
    local mode = (get(ren, "PMODE_FLAT") or 1) + (get(ren, "FIRE_ADD") or 0)
    return 0, mode, life, rgb[1], rgb[2], rgb[3], life, rgb[1], rgb[2], rgb[3]
  end)
end

local failed, natives = 0, 0
createFlame()
for _, row in ipairs(ELEMENTS) do
  local ok, res = pcall(createElement, row)
  if not ok or not res then failed = failed + 1; print("Table sandbox: element Z=" .. row[1] .. " failed: " .. tostring(res)) end
end
for z = 1, 118 do if created[z] and created[z].native then natives = natives + 1 end end

for _, n in ipairs({"FIRE", "PLSM", "LAVA", "EMBR"}) do local i = def(n); if i then HEAT_SRC[i] = true end end
if FLAME_ID then HEAT_SRC[FLAME_ID] = true end
for _, n in ipairs({"WATR", "DSTW", "SLTW"}) do local i = def(n); if i then WATERS[i] = true end end
if def("OXYG") then OXI[def("OXYG")] = 1 end
for z = 1, 118 do
  local id = ID(z)
  if id then
    if METAL_F[z] then METAL_ID[id] = METAL_F[z] end
    if NOBLE_Z[z] then NOBLE_ID[id] = true; NOREACT[id] = true end
    if NITRIDE_Z[z] then NITRIDE_ID[id] = true end
    if NOBLEGAS[z] or z == 9 then NOREACT[id] = true end
  end
end
if def("DMND") then NOREACT[def("DMND")] = true end

local S = {
  brushIdx = nil, wallMode = "off", lastGrav = CFG.GRAV_ON,
  panel = true, modal = false, drawing = false, lx = 0, ly = 0,
}
local mouse = {x = -1, y = -1}

local function brushRadius()
  local ok, r = pcall(function() return tpt.brushx end)
  if ok and type(r) == "number" then return r end
  return nil
end

local function setBrush(idx)
  S.brushIdx = idx
  local want = math.floor(CFG.BRUSH_SIZES[idx] / 2)
  S.brushWant = want
  pcall(function() tpt.brushx = want; tpt.brushy = want end)
end

local function inSim(x, y) return x >= 0 and y >= 0 and x < sim.XRES and y < sim.YRES end

local function wallStroke(x1, y1, x2, y2)
  local r = brushRadius() or 0
  if S.wallMode == "erase" then
    sim.createWallLine(x1, y1, x2, y2, r, r, CFG.WALL_ERASE)
  else
    sim.createWallLine(x1, y1, x2, y2, r, r)
  end
end

local function setWallMode(m) S.wallMode = (S.wallMode == m) and "off" or m end

local function gravityOn() return sim.gravityMode() ~= CFG.GRAV_OFF end
local function toggleGravity()
  if gravityOn() then S.lastGrav = sim.gravityMode(); sim.gravityMode(CFG.GRAV_OFF)
  else sim.gravityMode(S.lastGrav or CFG.GRAV_ON) end
end

local function enforceLimit()
  if not CFG.MAX_PARTS then return end
  local n = sim.partCount()
  if n <= CFG.MAX_PARTS then return end
  local ids = {}
  for i in sim.parts() do ids[#ids + 1] = i end
  for k = #ids, #ids - (n - CFG.MAX_PARTS) + 1, -1 do sim.partKill(ids[k]) end
end
event.register(event.TICK, enforceLimit)

local HELP = "Alt+1..7  Brush 1/10/30/40/60/100/1000 px\n" ..
             "Alt+W  Wall draw mode on/off\n" ..
             "Alt+E  Wall erase mode on/off\n" ..
             "Alt+G  Gravity on/off\n" ..
             "Alt+L  Element picker (periodic table)\n" ..
             "Alt+U  Show/hide panel\n" ..
             "Alt+H  This help\n\n" ..
             "In wall mode the left mouse button draws/erases walls.\n" ..
             "Hover a particle to see its full name and description."

local function selectElement(z)
  local info = created[z]
  if not info then return end
  pcall(function() tpt.selectedl = info.ident end)
  if UI and UI.activeTool then pcall(UI.activeTool, 0, info.ident) end
end

local function ptPos(z)
  if z == 1 then return 1, 1 elseif z == 2 then return 18, 1 end
  if z <= 4 then return z - 2, 2 end
  if z <= 10 then return z + 8, 2 end
  if z <= 12 then return z - 10, 3 end
  if z <= 18 then return z, 3 end
  if z <= 36 then return z - 18, 4 end
  if z <= 54 then return z - 36, 5 end
  if z <= 56 then return z - 54, 6 end
  if z <= 71 then return z - 54, 8 end
  if z <= 86 then return z - 68, 6 end
  if z <= 88 then return z - 86, 7 end
  if z <= 103 then return z - 86, 9 end
  return z - 100, 7
end

local function openElementWindow()
  local W, H = 18 * 35 + 10, 28 + 9 * 25 + 12 + 40
  local win = Window:new(-1, -1, W, H)
  win:addComponent(Label:new(8, 6, W - 80, 14, "Pick an element"))
  local info = Label:new(8, H - 22, W - 16, 14, "Click an element to select it.")
  win:addComponent(info)
  local closeBtn = Button:new(W - 70, 4, 62, 16, "Close")
  closeBtn:action(function() S.modal = false; UI.closeWindow(win) end)
  win:addComponent(closeBtn)
  for z = 1, 118 do
    local c = created[z]
    if c then
      local col, row = ptPos(z)
      local b = Button:new(5 + (col - 1) * 35, 28 + (row - 1) * 25 + (row > 7 and 12 or 0), 33, 22, c.sym)
      b:action(function() selectElement(z); S.modal = false; UI.closeWindow(win) end)
      pcall(function()
        b:onMouseEnter(function()
          pcall(function() info:text(INFO[z].full .. " (" .. c.sym .. ", Z=" .. z .. ") - " .. INFO[z].desc) end)
        end)
      end)
      win:addComponent(b)
    end
  end
  pcall(function() win:onTryExit(function() S.modal = false; UI.closeWindow(win) end) end)
  S.modal = true
  UI.showWindow(win)
end

local PANEL_W, PANEL_H = 262, 66
local btn = {}

local function refreshUI()
  for i, size in ipairs(CFG.BRUSH_SIZES) do
    btn["b" .. i]:text((S.brushIdx == i) and ("[" .. size .. "]") or tostring(size))
  end
  btn.wallDraw:text(S.wallMode == "draw" and "Wall: ON" or "Wall draw")
  btn.wallErase:text(S.wallMode == "erase" and "Erase: ON" or "Wall erase")
  btn.grav:text(gravityOn() and "Gravity: ON" or "Gravity: OFF")
end

local function setPanelVisible(v)
  S.panel = v
  for k, b in pairs(btn) do
    if k ~= "toggle" then b:visible(v) end
  end
end

local function makeButton(key, x, y, w, h, text, fn)
  local b = Button:new(x, y, w, h, text)
  b:action(function() fn(); refreshUI() end)
  UI.addComponent(b)
  btn[key] = b
end

local function buildUI()
  for i, size in ipairs(CFG.BRUSH_SIZES) do
    makeButton("b" .. i, 6 + (i - 1) * 36, 6, 34, 16, tostring(size), function() setBrush(i) end)
  end
  makeButton("wallDraw",  6,   26, 84, 16, "Wall draw",  function() setWallMode("draw") end)
  makeButton("wallErase", 94,  26, 84, 16, "Wall erase", function() setWallMode("erase") end)
  makeButton("grav",      182, 26, 84, 16, "Gravity",    toggleGravity)
  makeButton("elems",     6,   46, 84, 16, "Elements",   openElementWindow)
  makeButton("help",      94,  46, 84, 16, "Help",       function() UI.beginMessageBox("Help", HELP) end)
  makeButton("hide",      182, 46, 84, 16, "Hide panel", function() setPanelVisible(false) end)
  makeButton("toggle",    PANEL_W + 8, 6, 22, 16, "UI",  function() setPanelVisible(not S.panel) end)
  refreshUI()
end

local function textW(s)
  local ok, w = pcall(gfx.textSize, s)
  if ok and type(w) == "number" then return w end
  return #s * 6
end

local function drawHUD()
  local n = sim.partCount()
  local r = brushRadius()
  local brushTxt = S.brushIdx and (CFG.BRUSH_SIZES[S.brushIdx] .. " px") or "(default)"
  if r then brushTxt = brushTxt .. "  radius " .. r end
  if S.brushWant and r and r ~= S.brushWant then brushTxt = brushTxt .. "  [limited, wanted " .. S.brushWant .. "]" end
  local lines = {
    "Brush: " .. brushTxt,
    "Wall mode: " .. S.wallMode .. "   Gravity: " .. (gravityOn() and "ON" or "OFF"),
    "Particles: " .. n .. (CFG.MAX_PARTS and (" / " .. CFG.MAX_PARTS) or ""),
  }
  local y0 = S.panel and (PANEL_H + 4) or 28
  gfx.fillRect(4, y0 - 2, 270, #lines * 12 + 4, 0, 0, 0, 150)
  for i, l in ipairs(lines) do gfx.drawText(8, y0 + (i - 1) * 12, l, 255, 255, 255, 255) end

  if S.modal or not inSim(mouse.x, mouse.y) then return end
  local j = sim.pmap(mouse.x, mouse.y)
  if not j then return end
  local z = Z_OF_ID[sim.partProperty(j, "type")]
  if not z then return end
  local info = INFO[z]
  local l1 = string.format("%s (%s)", info.full, info.sym)
  local l2 = info.desc
  local w = math.max(textW(l1), textW(l2)) + 10
  local bx = mouse.x + 14
  if bx + w > sim.XRES then bx = math.max(0, mouse.x - w - 6) end
  local by = clamp(mouse.y + 14, 0, sim.YRES - 30)
  gfx.fillRect(bx, by, w, 28, 0, 0, 0, 210)
  gfx.drawText(bx + 5, by + 3, l1, 255, 255, 255, 255)
  gfx.drawText(bx + 5, by + 15, l2, 190, 190, 190, 255)
end

local function overPanel(x, y)
  if S.panel then return x <= PANEL_W + 34 and y <= PANEL_H end
  return x <= PANEL_W + 34 and y <= 24
end

event.register(event.KEYPRESS, function(key, scan, rep, shift, ctrl, alt)
  if not alt or S.modal then return end
  if key >= 49 and key <= 55 then setBrush(key - 48)
  elseif key == 119 then setWallMode("draw")
  elseif key == 101 then setWallMode("erase")
  elseif key == 103 then toggleGravity()
  elseif key == 108 then openElementWindow()
  elseif key == 117 then setPanelVisible(not S.panel)
  elseif key == 104 then UI.beginMessageBox("Help", HELP)
  else return end
  refreshUI()
  return false
end)

event.register(event.MOUSEDOWN, function(x, y, button)
  if S.wallMode == "off" or S.modal or button ~= 1 or overPanel(x, y) or not inSim(x, y) then return end
  S.drawing, S.lx, S.ly = true, x, y
  wallStroke(x, y, x, y)
  return false
end)

event.register(event.MOUSEMOVE, function(x, y, dx, dy)
  mouse.x, mouse.y = x, y
  if not S.drawing then return end
  x = clamp(x, 0, sim.XRES - 1); y = clamp(y, 0, sim.YRES - 1)
  wallStroke(S.lx, S.ly, x, y)
  S.lx, S.ly = x, y
end)

event.register(event.MOUSEUP, function(x, y, button)
  if S.drawing then S.drawing = false; return false end
end)

event.register(event.AFTERSIMDRAW, drawHUD)

local ok, err = pcall(buildUI)
if not ok then print("Table sandbox: UI could not be built: " .. tostring(err)) end
print(string.format("Table sandbox loaded: %d new elements, %d already in TPT (reused), %d failed. Alt+H = help.",
  118 - natives - failed, natives, failed))
