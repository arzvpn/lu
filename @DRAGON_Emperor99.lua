
limit = false
targetInfo = gg.getTargetInfo()
app = targetInfo.packageName
local utf8 = {}
local bit = {
  data32 = {}
}
do
  do
    for SRD1_5_ = 1, 32 do
      bit.data32[SRD1_5_] = 2 ^ (32 - SRD1_5_)
    end
  end
end
local toby = string.byte
function utf8.charbytes(s, i)
  i = i or 1
  local c = string.byte(s, i)
  if c > 0 and c <= 127 then
    do return 1 end
    return
  end
  if c >= 194 and c <= 223 then
    do return 2 end
    return
  end
  if c >= 224 and c <= 239 then
    do return 3 end
    return
  end
  if c >= 240 and c <= 244 then
    return 4
  end
  return 1
end

local ded
function bit:d2b(arg)
  if arg == nil then
    return
  end
  local tr, c = {}, arg < 0
  if c then
    arg = 0 - arg
  end
  do
    do
      for SRD1_7_ = 1, 32 do
        if arg >= self.data32[SRD1_7_] then
          tr[SRD1_7_] = 1
          arg = arg - self.data32[SRD1_7_]
        else
          tr[SRD1_7_] = 0
        end
      end
    end
  end
  if c then
    tr = self:_bnot(tr)
    tr = self:b2d(tr) + 1
    tr = self:d2b(tr)
  end
  return tr
end

function bit:b2d(arg, neg)
  local nr = 0
  if arg[1] == 1 and neg == true then
    arg = self:_bnot(arg)
    nr = self:b2d(arg) + 1
    nr = 0 - nr
  else
    do
      for SRD1_7_ = 1, 32 do
        if arg[SRD1_7_] == 1 then
          nr = nr + 2 ^ (32 - SRD1_7_)
        end
      end
    end
  end
  return nr
end

function bit:_and(a, b)
  local op1 = self:d2b(a)
  local op2 = self:d2b(b)
  local r = {}
  do
    do
      for SRD1_9_ = 1, 32 do
        if op1[SRD1_9_] == 1 and op2[SRD1_9_] == 1 then
          r[SRD1_9_] = 1
        else
          r[SRD1_9_] = 0
        end
      end
    end
  end
  return self:b2d(r, true)
end

function bit:_or(a, b)
  local op1 = self:d2b(a)
  local op2 = self:d2b(b)
  local r = {}
  do
    do
      for SRD1_9_ = 1, 32 do
        if op1[SRD1_9_] == 1 or op2[SRD1_9_] == 1 then
          r[SRD1_9_] = 1
        else
          r[SRD1_9_] = 0
        end
      end
    end
  end
  return self:b2d(r, true)
end

function bit:_xor(a, b)
  local op1 = self:d2b(a)
  if op1 == nil then
    return nil
  end
  local op2 = self:d2b(b)
  if op2 == nil then
    return nil
  end
  local r = {}
  do
    do
      for SRD1_9_ = 1, 32 do
        if op1[SRD1_9_] == op2[SRD1_9_] then
          r[SRD1_9_] = 0
        else
          r[SRD1_9_] = 1
        end
      end
    end
  end
  return self:b2d(r, true)
end

local switch = {
  [1] = function(s, pos)
    local c1 = toby(s, pos)
    return c1
  end
  ,
  [2] = function(s, pos)
    local c1 = toby(s, pos)
    local c2 = toby(s, pos + 1)
    local int1 = bit:_and(31, c1)
    local int2 = bit:_and(63, c2)
    return bit:_or(bit:_lshift(int1, 6), int2)
  end
  ,
  [3] = function(s, pos)
    local c1 = toby(s, pos)
    local c2 = toby(s, pos + 1)
    local c3 = toby(s, pos + 2)
    local int1 = bit:_and(15, c1)
    local int2 = bit:_and(63, c2)
    local int3 = bit:_and(63, c3)
    local o2 = bit:_or(bit:_lshift(int1, 12), bit:_lshift(int2, 6))
    local dt = bit:_or(o2, int3)
    return dt
  end
  ,
  [4] = function(s, pos)
    local c1 = toby(s, pos)
    local c2 = toby(s, pos + 1)
    local c3 = toby(s, pos + 2)
    local c4 = toby(s, pos + 3)
    local int1 = bit:_and(15, c1)
    local int2 = bit:_and(63, c2)
    local int3 = bit:_and(63, c3)
    local int4 = bit:_and(63, c4)
    local o2 = bit:_or(bit:_lshift(int1, 18), bit:_lshift(int2, 12))
    local o3 = bit:_or(o2, bit:_lshift(int3, 6))
    local o4 = bit:_or(o3, int4)
    return o4
  end
  
}
function bit:_bnot(op1)
  local r = {}
  do
    do
      for SRD1_6_ = 1, 32 do
        if op1[SRD1_6_] == 1 then
          r[SRD1_6_] = 0
        else
          r[SRD1_6_] = 1
        end
      end
    end
  end
  return r
end

function bit:_not(a)
  local op1 = self:d2b(a)
  local r = self:_bnot(op1)
  return self:b2d(r, true)
end

function bit:charCodeAt(s)
  local pos, int, H, L = 1, 0, 0, 0
  local slen = string.len(s)
  local allByte = {}
  while pos <= slen do
    local tLen = utf8.charbytes(s, pos)
    if tLen >= 1 and tLen <= 4 then
      if tLen == 4 then
        int = switch[4](s, pos)
        H = math.floor((int - 65536) / 1024) + 55296
        L = (int - 65536) % 1024 + 56320
        table.insert(allByte, H)
        table.insert(allByte, L)
      else
        int = switch[tLen](s, pos)
        table.insert(allByte, int)
      end
    end
    pos = pos + tLen
  end
  return allByte
end

function bit:_rshift(a, n)
  local r = 0
  if a < 0 then
    r = 0 - self:_frshift(0 - a, n)
  elseif a >= 0 then
    r = self:_frshift(a, n)
  end
  return r
end

function bit:_frshift(a, n)
  local op1 = self:d2b(a)
  local r = self:d2b(0)
  local left = 32 - n
  if n < 32 and n > 0 then
    do
      for SRD1_9_ = left, 1, -1 do
        r[SRD1_9_ + n] = op1[SRD1_9_]
      end
    end
  end
  return self:b2d(r)
end

function bit:_lshift(a, n)
  local op1 = self:d2b(a)
  local r = self:d2b(0)
  if n < 32 and n > 0 then
    do
      for SRD1_8_ = n, 31 do
        r[SRD1_8_ - n + 1] = op1[SRD1_8_ + 1]
      end
    end
  end
  return self:b2d(r, true)
end

function trim(s)
  return s:match("^%s*(.*)"):match("(.-)%s*$")
end

local json = {}
local kind_of = function(obj)
  if type(obj) ~= "table" then
    return type(obj)
  end
  local i = 1
  do
    do
      for SRD1_5_ in pairs(obj) do
        if obj[i] ~= nil then
          i = i + 1
        else
          return "table"
        end
      end
    end
  end
  if i == 1 then
    do return "table" end
    return
  end
  return "array"
end

local escape_str = function(s)
  local in_char = {
    "\\",
    "\"",
    "/",
    "\b",
    "\f",
    "\n",
    "\r",
    "\t"
  }
  local out_char = {
    "\\",
    "\"",
    "/",
    "b",
    "f",
    "n",
    "r",
    "t"
  }
  do
    do
      for SRD1_6_, SRD1_7_ in ipairs(in_char) do
        s = s:gsub(SRD1_7_, "\\" .. out_char[SRD1_6_])
      end
    end
  end
  return s
end

local skip_delim = function(str, pos, delim, err_if_missing)
  pos = pos + #str:match("^%s*", pos)
  if str:sub(pos, pos) ~= delim then
    if err_if_missing then
      error("Esperado " .. delim .. " posição próxima " .. pos)
    end
    return pos, false
  end
  return pos + 1, true
end

local function parse_str_val(str, pos, val)
  val = val or ""
  local early_end_error = "Fim da entrada encontrado durante a análise da string."
  if pos > #str then
    error(early_end_error)
  end
  local c = str:sub(pos, pos)
  if c == "\"" then
    return val, pos + 1
  end
  if c ~= "\\" then
    return parse_str_val(str, pos + 1, val .. c)
  end
  local esc_map = {
    b = "\b",
    f = "\f",
    n = "\n",
    r = "\r",
    t = "\t"
  }
  local nextc = str:sub(pos + 1, pos + 1)
  if not nextc then
    error(early_end_error)
  end
  return parse_str_val(str, pos + 2, val .. (esc_map[nextc] or nextc))
end

local parse_num_val = function(str, pos)
  local num_str = str:match("^-?%d+%.?%d*[eE]?[+-]?%d*", pos)
  local val = tonumber(num_str)
  if not val then
    error("Erro ao analisar o número na posição " .. pos .. ".")
  end
  return val, pos + #num_str
end

function json.stringify(obj, as_key)
  local s = {}
  local kind = kind_of(obj)
  if kind == "array" then
    if as_key then
      error("Não é possível codificar array como chave.")
    end
    s[#s + 1] = "["
    do
      do
        for SRD1_7_, SRD1_8_ in ipairs(obj) do
          if SRD1_7_ > 1 then
            s[#s + 1] = ", "
          end
          s[#s + 1] = json.stringify(SRD1_8_)
        end
      end
    end
    s[#s + 1] = "]"
  elseif kind == "table" then
    if as_key then
      error("Não é possível codificar a tabela como chave.")
    end
    s[#s + 1] = "{"
    do
      do
        for SRD1_7_, SRD1_8_ in pairs(obj) do
          if #s > 1 then
            s[#s + 1] = ", "
          end
          s[#s + 1] = json.stringify(SRD1_7_, true)
          s[#s + 1] = ":"
          s[#s + 1] = json.stringify(SRD1_8_)
        end
      end
    end
    s[#s + 1] = "}"
  else
    if kind == "string" then
      do return "\"" .. escape_str(obj) .. "\"" end
      return
    end
    if kind == "number" then
      if as_key then
        return "\"" .. tostring(obj) .. "\""
      end
      do return tostring(obj) end
      return
    end
    if kind == "boolean" then
      do return tostring(obj) end
      return
    end
    if kind == "nil" then
      do return "null" end
      return
    end
    error("tipo unjsonificável,: " .. kind .. ".")
  end
  return table.concat(s)
end

json.null = {}
function json.parse(str, pos, end_delim)
  pos = pos or 1
  if pos > #str then
    error("Atingiu o fim inesperado da entrada ")
  end
  local pos = pos + #str:match("^%s*", pos)
  local first = str:sub(pos, pos)
  if first == "{" then
    do
      local obj, key, delim_found = {}, true, true
      pos = pos + 1
      while true do
        key, pos = json.parse(str, pos, "}")
        if key == nil then
          return obj, pos
        end
        if not delim_found then
          error("Vírgula faltando entre os itens do objeto.")
        end
        pos = skip_delim(str, pos, ":", true)
        obj[key], pos = json.parse(str, pos)
        pos, delim_found = skip_delim(str, pos, ",")
      end
    end
    return
  end
  if first == "[" then
    do
      local arr, val, delim_found = {}, true, true
      pos = pos + 1
      while true do
        val, pos = json.parse(str, pos, "]")
        if val == nil then
          return arr, pos
        end
        if not delim_found then
          error("Falta vírgula entre os itens do array.")
        end
        arr[#arr + 1] = val
        pos, delim_found = skip_delim(str, pos, ",")
      end
    end
    return
  end
  if first == "\"" then
    do return parse_str_val(str, pos + 1) end
    return
  end
  if first == "-" or first:match("%d") then
    do return parse_num_val(str, pos) end
    return
  end
  if first == end_delim then
    do return nil, pos + 1 end
    return
  end
  do
    local literals = {
      ["true"] = true,
      ["false"] = false,
      null = json.null
    }
    do
      do
        for SRD1_9_, SRD1_10_ in pairs(literals) do
          local lit_end = pos + #SRD1_9_ - 1
          if str:sub(pos, lit_end) == SRD1_9_ then
            return SRD1_10_, lit_end + 1
          end
        end
      end
    end
    local pos_info_str = "position " .. pos .. ": " .. str:sub(pos, pos + 10)
    error("Sintaxe json inválida começando em " .. pos_info_str)
  end
end

function enc(data, b)
  return (data:gsub(".", function(x)
    local r, b = "", x:byte()
    do
      do
        for SRD1_6_ = 8, 1, -1 do
          r = r .. (b % 2 ^ SRD1_6_ - b % 2 ^ (SRD1_6_ - 1) > 0 and "1" or "0")
        end
      end
    end
    return r
  end
  ) .. "0000"):gsub("%d%d%d?%d?%d?%d?", function(x)
    if #x < 6 then
      return ""
    end
    local c = 0
    do
      do
        for SRD1_5_ = 1, 6 do
          c = c + (x:sub(SRD1_5_, SRD1_5_) == "1" and 2 ^ (6 - SRD1_5_) or 0)
        end
      end
    end
    return b:sub(c + 1, c + 1)
  end
  ) .. ({
    "",
    "??",
    "?"
  })[#data % 3 + 1]
end

function dec(data, b)
  data = string.gsub(data, "[^" .. b .. "=]", "")
  return (data:gsub(".", function(x)
    if x == "?" then
      return ""
    end
    local r, f = "", b:find(x) - 1
    do
      do
        for SRD1_6_ = 6, 1, -1 do
          r = r .. (f % 2 ^ SRD1_6_ - f % 2 ^ (SRD1_6_ - 1) > 0 and "1" or "0")
        end
      end
    end
    return r
  end
  ):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(x)
    if #x ~= 8 then
      return ""
    end
    local c = 0
    do
      do
        for SRD1_5_ = 1, 8 do
          c = c + (x:sub(SRD1_5_, SRD1_5_) == "1" and 2 ^ (8 - SRD1_5_) or 0)
        end
      end
    end
    return string.char(c)
  end
  ))
end

function ehix9(key, data)
  local preData, result
  preData = ""
  result = ""
  local bit_key = bit:charCodeAt(key)
  do
    local c = 0
    local c2 = 1
    while c < #data and not (c >= #data) do
      preData = preData .. string.char(tonumber(string.sub(data, c2, c + 2), 16))
      c = c + 2
      c2 = c2 + 2
    end
  end
  local bit_data = bit:charCodeAt(preData)
  do
    local a = 0
    local b = 0
    while a < #preData do
      if b >= #key then
        b = 0
      end
      a = a + 1
      b = b + 1
      local xor = bit:_xor(bit_data[a], bit_key[b])
      if xor ~= nil and xor < 256 then
        result = result .. string.char(bit:_xor(bit_data[a], bit_key[b]))
      end
    end
  end
  return result
end

function decryptEhi(salt, data)
  data = dec(string.reverse(data), "RkLC2QaVMPYgGJW/A4f7qzDb9e+t6Hr0Zp8OlNyjuxKcTw1o5EIimhBn3UvdSFXs?")
  return ehix9(salt, string.sub(data, 1, #data))
end

function decryptEhil(salt, data)
  data = dec(string.reverse(data), "t6uxKcTwhBn3UvRkLC2QaVM1o5A4f7Hr0Zp8OyjqzDb9e+dSFXsEIimPYgGJW/lN?")
  return ehix9(salt, string.sub(data, 1, #data))
end

function rwmem(Address, SizeOrBuffer)
  assert(Address ~= nil, "[rwmem]: error, endereço fornecido é nulo.")
  _rw = {}
  if type(SizeOrBuffer) == "number" then
    _ = ""
    do
      do
        for SRD1_5_ = 1, SizeOrBuffer do
          _rw[SRD1_5_] = {
            address = Address - 1 + SRD1_5_,
            flags = gg.TYPE_BYTE
          }
        end
      end
    end
    do
      do
        for SRD1_5_, SRD1_6_ in ipairs(gg.getValues(_rw)) do
          if SRD1_6_.value == 0 and limit == true then
            return _
          end
          _ = _ .. string.format("%02X", SRD1_6_.value & 255)
        end
      end
    end
    return _
  end
  Byte = {}
  SizeOrBuffer:gsub("..", function(x)
    Byte[#Byte + 1] = x
    _rw[#Byte] = {
      address = Address - 1 + #Byte,
      flags = gg.TYPE_BYTE,
      value = x .. "h"
    }
  end
  )
  gg.setValues(_rw)
end

function hexdecode(hex)
  return (hex:gsub("%x%x", function(digits)
    return string.char(tonumber(digits, 16))
  end
  ))
end

function hexencode(str)
  return (str:gsub(".", function(char)
    return string.format("%2x", char:byte())
  end
  ))
end

function Dec2Hex(nValue)
  nHexVal = string.format("%X", nValue)
  sHexVal = nHexVal .. ""
  return sHexVal
end

function ToInteger(number)
  return math.floor(tonumber(number) or error("Não foi possível transmitir '" .. tostring(number) .. "' enumerar.'"))
end

function save(data)
  io.open(gg.EXT_STORAGE .. "/decrypt.txt", "w"):write(data)
  gg.toast("te peguei Lionel Richie!")
end

function save2(data)
  io.open(gg.EXT_STORAGE .. "/decrypt.txt", "w"):write(json.stringify(data))
  gg.toast("te peguei Lionel Richie!")
end

function hc(data)
  io.open(gg.EXT_STORAGE .. "/hc.txt", "w"):write(data)
  gg.toast("te peguei Lionel Richie!")
end

function v2json(data)
  io.open(gg.EXT_STORAGE .. "/v2ray.txt", "w"):write(data)
end

function saveEhi(data)
  io.open(gg.EXT_STORAGE .. "/ehi.txt", "w"):write(data)
end

local ehi, configSalt
local Http = {}
function Http:New(data)
  ehi = data
  if data.configSalt == "" then
    configSalt = "EVZJNI"
  else
    configSalt = data.configSalt
  end
end

function Http:Dec(key)
  if ehi.configVersionCode > 10000 then
    if ehi[key] then
      do return decryptEhil(configSalt, ehi[key]) end
      return
    end
    do return "N/A" end
    return
  end
  if ehi[key] then
    do return decryptEhi(configSalt, ehi[key]) end
    return
  end
  return "N/A"
end

function Http:TunnelType()
  if ehi.tunnelType == "ssl_proxy_payload_ssh" then
    do return "SSH ➔ TLS/SSL + Proxy ➔ Custom Payload" end
    return
  end
  if ehi.tunnelType == "http_obfs_shadowsocks" then
    do return "HTTP (Obfs) ➔ Shadowsocks" end
    return
  end
  if ehi.tunnelType == "ssl_ssh" then
    do return "SSL/TLS ➔ SSH" end
    return
  end
  if ehi.tunnelType == "proxy_payload_ssh" then
    do return "SSH ➔ HTTP Proxy ➔ Custom Payload" end
    return
  end
  if ehi.tunnelType == "proxy_ssh" then
    do return "SSH ➔ HTTP Proxy" end
    return
  end
  if ehi.tunnelType == "direct_ssh" then
    do return "SSH (Direct)" end
    return
  end
  if ehi.tunnelType == "direct_shadowsocks" then
    do return "Shadowsocks (Direct)" end
    return
  end
  if ehi.tunnelType == "dnstt_ssh" then
    do return "DNS ➔ DNSTT ➔ SSH" end
    return
  end
  if ehi.tunnelType == "ssl_proxy_ssh" then
    do return "HTTP Proxy ➔ SSL ➔ SSH" end
    return
  end
  if ehi.tunnelType == "ssl_shadowsocks" then
    do return "SSL/TLS (Stunnel) ➔ Shadowsocks" end
    return
  end
  if ehi.tunnelType == "tls_obfs_shadowsocks" then
    do return "SSL/TLS (Obfs) ➔ Shadowsocks" end
    return
  end
  if ehi.tunnelType == "proxy_shadowsocks" then
    do return "HTTP Proxy ➔ Shadowsocks" end
    return
  end
  if ehi.tunnelType == "proxy_payload_shadowsocks" then
    do return "HTTP Proxy ➔ Shadowsocks (Custom Payload)" end
    return
  end
  if ehi.v2ray_all_settings == "v2ray_all_settings" then
    do return "V2Ray" end
    return
  end
  if ehi.tunnelType == "direct_dnsurgent" then
    do return "Direct Dnsurgent" end
    return
  end
  if ehi.tunnelType == "sni_host_port" then
    do return "SSL/TLS" end
    return
  end
  if ehi.tunnelType == "direct_v2r_vmess" then
    do return "V2Ray" end
    return
  end
  if ehi.tunnelType == "v2rRawJson" then
    do return "v2json ➔ V2ray" end
    return
  end
  if ehi.tunnelType == "lock_all" then
    do return "lock ➔ V2ray" end
    return
  end
  if ehi.tunnelType == "unknown" then
    do return "HTTP Proxy ➔ SSH (Custom Payload)" end
    return
  end
  if ehi.tunnelType == "http_obfs" then
    do return "Shadowsocks ➔ HTTP Obfs" end
    return
  end
  if ehi.tunnelType == "direct_payload_ssh" then
    do return "SSH ➔ Direct ➔ Custom Payload" end
    return
  end
  return ehi.tunnelType
end

local includes = function(tab, val)
  do
    do
      for SRD1_5_, SRD1_6_ in ipairs(tab) do
        if SRD1_6_ == val then
          return true
        end
      end
    end
  end
  return false
end

local ssh_mode = {
  "ssl_proxy_payload_ssh",
  "direct_payload_ssh",
  "proxy_payload_ssh",
  "proxy_ssh",
  "dnstt_ssh",
  "ssl_shadowsocks",
  "tls_obfs_shadowsocks",
  "proxy_shadowsocks",
  "proxy_payload_shadowsocks",
  "direct_dnsurgent",
  "direct_v2r_vmess",
  "unknown",
  "v2rRawJson",
  "v2ray_all_settings",
  "http_obfs_shadowsocks",
  "direct_shadowsocks",
  "ssl_proxy_ssh",
  "direct_ssh",
  "sni_host_port",
  "ssl_ssh",
  "lock_all",
  "http_obfs"
}

function parseHttpInjector(data)
  local jsonData = json.parse(hexdecode(data))
  gg.toast("it's show time")
  
  Http:New(jsonData)
  if includes(ssh_mode, ehi.tunnelType) then
    message = ""
    if ehi.overwriteServerData ~= "" then
      serverData = json.parse(ehi.overwriteServerData)
      message = message .. "ʀᴇᴀᴅ ᴄᴏɴꜰɪɢ ʙʏ ᴇᴍᴘᴇʀᴏʀ ᴅᴇᴄʀʏᴘᴛᴏʀ\n"
      message = message .. "\n"
      message = message .. "════════════════════════════\n"
      message = message .. " ⎝ 𝐑𝐞𝐩𝐥𝐚𝐜𝐞 𝐒𝐞𝐫𝐯𝐞𝐫 𝐃𝐚𝐭𝐚 ⎞  \n ╰┈☞ " .. ehi.overwriteServerData .. [[

]]
      message = message .. "\n ⎝ 𝐎𝐯𝐞𝐫𝐫𝐢𝐝𝐞 𝐒𝐞𝐫𝐯𝐞𝐫 𝐏𝐫𝐨𝐱𝐲 𝐏𝐨𝐫𝐭 ⎞  \n ╰┈☞ " .. ehi.overwriteServerProxyPort .. [[

]]
      message = message .. "\n ⎝ 𝐎𝐯𝐞𝐫𝐫𝐢𝐝𝐞 𝐒𝐞𝐫𝐯𝐞𝐫 𝐓𝐲𝐩𝐞 ⎞  \n ╰┈☞ " .. ehi.overwriteServerType .. [[

]]
      message = message .. "\n ⎝ 𝐄𝐯𝐨𝐳𝐢 𝐒𝐞𝐫𝐯𝐞𝐫 ⎞  \n ╰┈☞ " .. serverData.name .. " (" .. serverData.ip ..  [[
  )
]]
elseif ehi.tunnelType == "direct_shadowsocks" then
      message = message .. "ʀᴇᴀᴅ ᴄᴏɴꜰɪɢ ʙʏ ᴇᴍᴘᴇʀᴏʀ ᴅᴇᴄʀʏᴘᴛᴏʀ\n"
      message = message .. "\n"
      message = message .. "════════════════════════════\n"
      message = message .. " ⎝ 𝐇𝐓𝐓𝐏 𝐎𝐛𝐟𝐬 𝐒𝐞𝐭𝐭𝐢𝐧𝐠𝐬 ⎞  \n ╰┈☞ " .. Http:Dec("httpObfsSettings") .. [[

]]
      message = message .. "\n ⎝ 𝐒𝐡𝐚𝐝𝐨𝐰𝐬𝐨𝐜𝐤𝐬 𝐇𝐨𝐬𝐭 ⎞  \n ╰┈☞ " .. Http:Dec("shadowsocksHost") .. "\n"
      message = message .. "\n ⎝ 𝐒𝐡𝐚𝐝𝐨𝐰𝐬𝐨𝐜𝐤𝐬 𝐏𝐨𝐫𝐭 ⎞  \n ╰┈☞ " .. ehi.shadowsocksPort .. "\n"
      message = message .. "\n ⎝ 𝐒𝐡𝐚𝐝𝐨𝐰𝐬𝐨𝐜𝐤𝐬 𝐏𝐚𝐬𝐬𝐰𝐨𝐫𝐝 ⎞  \n ╰┈☞ " .. Http:Dec("shadowsocksPassword") .. [[

]]
      message = message .. "\n ⎝ 𝐄𝐧𝐜𝐫𝐲𝐩𝐭𝐌𝐞𝐭𝐡𝐨𝐝 ⎞  \n ╰┈☞ " .. string.upper(ehi.shadowsocksEncryptionMethod) .. [[

]]
      message = message .. "\n ⎝ 𝐯𝟐𝐫𝐌𝐮𝐱𝐂𝐨𝐧𝐜𝐮𝐫𝐫𝐞𝐧𝐜𝐲 ⎞  \n ╰┈☞ " .. Http:Dec("v2rMuxConcurrency") .. [[

]]
      message = message .. "\n ⎝ 𝐓𝐮𝐧𝐧𝐞𝐥 𝐓𝐲𝐩𝐞 ⎞  \n ╰┈☞ " .. Http:TunnelType()
      message = message .. "\n════════════════════════════\n" .. [[
      
]]
elseif ehi.tunnelType == "tls_obfs_shadowsocks" then
      message = message .. "ʀᴇᴀᴅ ᴄᴏɴꜰɪɢ ʙʏ ᴇᴍᴘᴇʀᴏʀ ᴅᴇᴄʀʏᴘᴛᴏʀ\n"
      message = message .. "\n"
      message = message .. "════════════════════════════\n"
      message = message .. " ⎝ 𝐇𝐓𝐓𝐏 𝐎𝐛𝐟𝐬 𝐒𝐞𝐭𝐭𝐢𝐧𝐠𝐬 ⎞  \n ╰┈☞ " .. Http:Dec("httpObfsSettings") .. [[

]]
message = message .. "\n ⎝ 𝐒𝐡𝐚𝐝𝐨𝐰𝐬𝐨𝐜𝐤𝐬 𝐇𝐨𝐬𝐭 ⎞  \n ╰┈☞ " .. Http:Dec("shadowsocksHost") .. "\n"
      message = message .. "\n ⎝ 𝐒𝐡𝐚𝐝𝐨𝐰𝐬𝐨𝐜𝐤𝐬 𝐏𝐨𝐫𝐭 ⎞  \n ╰┈☞ " .. ehi.shadowsocksPort .. "\n"
      message = message .. "\n ⎝ 𝐒𝐡𝐚𝐝𝐨𝐰𝐬𝐨𝐜𝐤𝐬 𝐏𝐚𝐬𝐬𝐰𝐨𝐫𝐝 ⎞  \n ╰┈☞ " .. Http:Dec("shadowsocksPassword") .. [[

]]
      message = message .. "\n ⎝ 𝐄𝐧𝐜𝐫𝐲𝐩𝐭𝐌𝐞𝐭𝐡𝐨𝐝 ⎞  \n ╰┈☞ " .. string.upper(ehi.shadowsocksEncryptionMethod) .. [[

]]
      message = message .. "\n ⎝ 𝐯𝟐𝐫𝐌𝐮𝐱𝐂𝐨𝐧𝐜𝐮𝐫𝐫𝐞𝐧𝐜𝐲 ⎞  \n ╰┈☞ " .. Http:Dec("v2rMuxConcurrency") .. [[

]]
      message = message .. "\n ⎝ 𝐒𝐍𝐈 ⎞  \n ╰┈☞ " .. Http:Dec("sniHostname") .. [[

]]
      message = message .. "\n ⎝ 𝐓𝐮𝐧𝐧𝐞𝐥 𝐓𝐲𝐩𝐞 ⎞  \n ╰┈☞ " .. Http:TunnelType()
      message = message .. "\n════════════════════════════\n" .. [[
      
]]
elseif ehi.tunnelType == "http_obfs_shadowsocks" then
      message = message .. "ʀᴇᴀᴅ ᴄᴏɴꜰɪɢ ʙʏ ᴇᴍᴘᴇʀᴏʀ ᴅᴇᴄʀʏᴘᴛᴏʀ\n"
      message = message .. "\n"
      message = message .. "════════════════════════════\n"
      message = message .. " ⎝ 𝐇𝐓𝐓𝐏 𝐎𝐛𝐟𝐬 𝐒𝐞𝐭𝐭𝐢𝐧𝐠𝐬 ⎞  \n ╰┈☞ " .. Http:Dec("httpObfsSettings") .. [[

]]
      message = message .. "\n ⎝ 𝐒𝐡𝐚𝐝𝐨𝐰𝐬𝐨𝐜𝐤𝐬 𝐇𝐨𝐬𝐭 ⎞  \n ╰┈☞ " .. Http:Dec("shadowsocksHost") .. "\n"
      message = message .. "\n ⎝ 𝐒𝐡𝐚𝐝𝐨𝐰𝐬𝐨𝐜𝐤𝐬 𝐏𝐨𝐫𝐭 ⎞  \n ╰┈☞ " .. ehi.shadowsocksPort .. "\n"
      message = message .. "\n ⎝ 𝐒𝐡𝐚𝐝𝐨𝐰𝐬𝐨𝐜𝐤𝐬 𝐏𝐚𝐬𝐬𝐰𝐨𝐫𝐝 ⎞  \n ╰┈☞ " .. Http:Dec("shadowsocksPassword") .. [[

]]
      message = message .. "\n ⎝ 𝐄𝐧𝐜𝐫𝐲𝐩𝐭𝐌𝐞𝐭𝐡𝐨𝐝 ⎞  \n ╰┈☞ " .. string.upper(ehi.shadowsocksEncryptionMethod) .. [[

]]
      message = message .. "\n ⎝ 𝐯𝟐𝐫𝐌𝐮𝐱𝐂𝐨𝐧𝐜𝐮𝐫𝐫𝐞𝐧𝐜𝐲 ⎞  \n ╰┈☞ " .. Http:Dec("v2rMuxConcurrency") .. [[

]]
      message = message .. "\n ⎝ 𝐓𝐮𝐧𝐧𝐞𝐥 𝐓𝐲𝐩𝐞 ⎞  \n ╰┈☞ " .. Http:TunnelType()
      message = message .. "\n════════════════════════════\n" .. [[
      
]]
    else
      message = message .. "ʀᴇᴀᴅ ᴄᴏɴꜰɪɢ ʙʏ ᴇᴍᴘᴇʀᴏʀ ᴅᴇᴄʀʏᴘᴛᴏʀ\n"
      message = message .. "\n"
      message = message .. "════════════════════════════\n"
      message = message .. " ⎝ 𝐒𝐒𝐇 𝐇𝐨𝐬𝐭 ⎞  \n ╰┈☞ " .. Http:Dec("host") .. "\n"
      message = message .. "\n ⎝ 𝐏𝐨𝐫𝐭 ⎞  \n ╰┈☞ " .. ehi.port .. "\n"
      message = message .. "\n ⎝ 𝐔𝐬𝐞𝐫𝐧𝐚𝐦𝐞 ⎞  \n ╰┈☞ " .. Http:Dec("user") .. "\n"
      message = message .. "\n ⎝ 𝐏𝐚𝐬𝐬𝐰𝐨𝐫𝐝 ⎞  \n ╰┈☞ " .. Http:Dec("password") .. [[

]]
 end
    if ehi.remoteProxy then
      if ehi.remoteProxyUsername and ehi.remoteProxyUsername ~= "" then
        message = message .. "\n ⎝ 𝐏𝐫𝐨𝐱𝐲 ⎞  \n ╰┈☞ " .. Http:Dec("remoteProxy") .. "\n"
        message = message .. "\n ⎝ 𝐔𝐬𝐞𝐫𝐧𝐚𝐦𝐞 & 𝐏𝐚𝐬𝐬𝐰𝐨𝐫𝐝 𝐏𝐫𝐨𝐱𝐲 𝐀𝐮𝐭𝐡 ⎞  \n ╰┈☞ " .. Http:Dec("remoteProxyUsername") .. ":" .. Http:Dec("remoteProxyPassword") .. [[

]]
      end
      elseif ehi.overwriteServerData ~= "" then
      if ehi.tunnelType == "proxy_payload_ssh" then
    message = message .. "\n ⎝ 𝐏𝐫𝐨𝐱𝐲 ⎞  \n ╰┈☞ " .. Http:Dec("remoteProxy") .. [[

]]
end
      elseif ehi.overwriteServerData ~= "" then
      if ehi.tunnelType == "ssl_proxy_payload_ssh" then
    message = message .. "\n ⎝ 𝐏𝐫𝐨𝐱𝐲 ⎞  \n ╰┈☞ " .. Http:Dec("remoteProxy") .. [[


]]
message = message .. "\n ⎝ 𝐒𝐍𝐈 ⎞  \n ╰┈☞ " .. Http:Dec("sniHostname") .. [[

]]
end
      elseif ehi.overwriteServerData ~= "" then
      if ehi.tunnelType == "proxy_ssh" then
    message = message .. "\n ⎝ 𝐏𝐫𝐨𝐱𝐲 ⎞  \n ╰┈☞ " .. Http:Dec("remoteProxy") .. [[

]]
      end
    elseif ehi.overwriteServerData ~= "" then
    if ehi.tunnelType == "ssl_ssh" then
      message = message .. "\n ⎝ 𝐒𝐍𝐈 ⎞  \n ╰┈☞ " .. Http:Dec("sniHostname") .. [[

]]
end
    elseif ehi.overwriteServerData ~= "" then
    if ehi.tunnelType == "sni_host_port" then
      message = message .. "\n ⎝ 𝐒𝐍𝐈 ⎞  \n ╰┈☞ " .. Http:Dec("sniHostname") .. [[

]]

    end
    elseif ehi.tunnelType == "ssl_shadowsocks" then
      message = message .. "ʀᴇᴀᴅ ᴄᴏɴꜰɪɢ ʙʏ ᴇᴍᴘᴇʀᴏʀ ᴅᴇᴄʀʏᴘᴛᴏʀ\n"
      message = message .. "\n"
      message = message .. "════════════════════════════\n"
      message = message .. " ⎝ 𝐒𝐡𝐚𝐝𝐨𝐰𝐬𝐨𝐜𝐤𝐬 𝐇𝐨𝐬𝐭 ⎞  \n ╰┈☞ " .. Http:Dec("shadowsocksHost") .. "\n"
      message = message .. "\n ⎝ 𝐒𝐡𝐚𝐝𝐨𝐰𝐬𝐨𝐜𝐤𝐬 𝐏𝐨𝐫𝐭 ⎞  \n ╰┈☞ " .. ehi.shadowsocksPort .. "\n"
      message = message .. "\n ⎝ 𝐒𝐡𝐚𝐝𝐨𝐰𝐬𝐨𝐜𝐤𝐬 𝐏𝐚𝐬𝐬𝐰𝐨𝐫𝐝 ⎞  \n ╰┈☞ " .. Http:Dec("shadowsocksPassword") .. [[

]]
      message = message .. "\n ⎝ 𝐄𝐧𝐜𝐫𝐲𝐩𝐭𝐌𝐞𝐭𝐡𝐨𝐝 ⎞  \n ╰┈☞ " .. string.upper(ehi.shadowsocksEncryptionMethod) .. [[

]]
      message = message .. "\n ⎝ 𝐒𝐍𝐈 ⎞  \n ╰┈☞ " .. Http:Dec("sniHostname") .. [[

]]
      message = message .. "\n ⎝ 𝐓𝐮𝐧𝐧𝐞𝐥 𝐓𝐲𝐩𝐞 ⎞  \n ╰┈☞ " .. Http:TunnelType()
      message = message .. "\n════════════════════════════\n" .. [[
      
]]
    end
    if ehi.tunnelType == "direct_payload_ssh" then
      message = message .. "\n ⎝ 𝐏𝐚𝐲𝐥𝐨𝐚𝐝 ⎞  \n ╰┈☞ " .. Http:Dec("payload") .. [[

]]
      message = message .. "\n ⎝ 𝐓𝐮𝐧𝐧𝐞𝐥 𝐓𝐲𝐩𝐞 ⎞  \n ╰┈☞ " .. Http:TunnelType()
      message = message .. "\n════════════════════════════\n" .. [[
      
]]
    end
    if ehi.tunnelType == "ssl_proxy_ssh" then
    message = message .. "\n ⎝ 𝐏𝐫𝐨𝐱𝐲 ⎞  \n ╰┈☞ " .. Http:Dec("remoteProxy") .. [[

]]
message = message .. "\n ⎝ 𝐒𝐍𝐈 ⎞  \n ╰┈☞ " .. Http:Dec("sniHostname") .. [[

]]
      message = message .. "\n ⎝ 𝐓𝐮𝐧𝐧𝐞𝐥 𝐓𝐲𝐩𝐞 ⎞  \n ╰┈☞ " .. Http:TunnelType()
      message = message .. "\n════════════════════════════\n" .. [[
      
]]
    end
    if ehi.tunnelType == "sni_host_port" then
    message = message .. "\n ⎝ 𝐒𝐍𝐈 ⎞  \n ╰┈☞ " .. Http:Dec("sniHostname") .. [[

]]
      message = message .. "\n ⎝ 𝐓𝐮𝐧𝐧𝐞𝐥 𝐓𝐲𝐩𝐞 ⎞  \n ╰┈☞ " .. Http:TunnelType()
      message = message .. "\n════════════════════════════\n" .. [[
      
]]
    end
    if ehi.tunnelType == "ssl_proxy_payload_ssh" then
    message = message .. "\n ⎝ 𝐏𝐫𝐨𝐱𝐲 ⎞  \n ╰┈☞ " .. Http:Dec("remoteProxy") .. [[

]]
message = message .. "\n ⎝ 𝐒𝐍𝐈 ⎞  \n ╰┈☞ " .. Http:Dec("sniHostname") .. [[

]]
      message = message .. "\n ⎝ 𝐏𝐚𝐲𝐥𝐨𝐚𝐝 ⎞  \n ╰┈☞ " .. Http:Dec("payload") .. [[

]]
      message = message .. "\n ⎝ 𝐓𝐮𝐧𝐧𝐞𝐥 𝐓𝐲𝐩𝐞 ⎞  \n ╰┈☞ " .. Http:TunnelType()
      message = message .. "\n════════════════════════════\n" .. [[
      
]]
    end
    if ehi.tunnelType == "proxy_payload_ssh" then
    message = message .. "\n ⎝ 𝐏𝐫𝐨𝐱𝐲 ⎞  \n ╰┈☞ " .. Http:Dec("remoteProxy") .. [[

]]
      message = message .. "\n ⎝ 𝐏𝐚𝐲𝐥𝐨𝐚𝐝 ⎞  \n ╰┈☞ " .. Http:Dec("payload") .. [[

]]
      message = message .. "\n ⎝ 𝐓𝐮𝐧𝐧𝐞𝐥 𝐓𝐲𝐩𝐞 ⎞  \n ╰┈☞ " .. Http:TunnelType()
      message = message .. "\n════════════════════════════\n" .. [[
      
]]
    end
    if ehi.tunnelType == "proxy_ssh" then
    message = message .. "\n ⎝ 𝐏𝐫𝐨𝐱𝐲 ⎞  \n ╰┈☞ " .. Http:Dec("remoteProxy") .. [[

]]
      message = message .. "\n ⎝ 𝐓𝐮𝐧𝐧𝐞𝐥 𝐓𝐲𝐩𝐞 ⎞  \n ╰┈☞ " .. Http:TunnelType()
      message = message .. "\n════════════════════════════\n" .. [[
      
]]
    end
    if ehi.tunnelType == "ssl_ssh" then
    message = message .. "\n ⎝ 𝐒𝐍𝐈 ⎞  \n ╰┈☞ " .. Http:Dec("sniHostname") .. [[

]]
      message = message .. "\n ⎝ 𝐓𝐮𝐧𝐧𝐞𝐥 𝐓𝐲𝐩𝐞 ⎞  \n ╰┈☞ " .. Http:TunnelType()
      message = message .. "\n════════════════════════════\n" .. [[
      
]]
    end
    if ehi.tunnelType == "direct_ssh" then
      message = message .. "\n ⎝ 𝐓𝐮𝐧𝐧𝐞𝐥 𝐓𝐲𝐩𝐞 ⎞  \n ╰┈☞ " .. Http:TunnelType()
      message = message .. "\n════════════════════════════\n" .. [[
      
]]
    end
    if ehi.tunnelType == "direct_v2r_vmess" then
      message = "\n ⎝ 𝐯𝟐𝐫𝐑𝐚𝐰𝐉𝐬𝐨𝐧 ⎞  \n ╰┈☞ " .. Http:Dec("v2rRawJson") .. [[

]]
      if ehi.v2rRawJson then
        v2json = Http:Dec("v2rRawJson")
        saveEhi(v2json)
        gg.copyText(v2json, false)
        gg.toast("𝐂𝐨𝐩𝐢𝐞𝐝 𝐭𝐨 𝐂𝐥𝐢𝐩𝐛𝐨𝐚𝐫𝐝")
        print(message)
        return
      end
      message = message .. "ʀᴇᴀᴅ ᴄᴏɴꜰɪɢ ʙʏ ᴇᴍᴘᴇʀᴏʀ ᴅᴇᴄʀʏᴘᴛᴏʀ\n"
      message = message .. "\n"
      message = message .. "════════════════════════════\n"
      message = message .. " ⎝ 𝐀𝐥𝐭𝐞𝐫𝐈𝐝 ⎞  \n ╰┈☞ " .. Http:Dec("v2rAlterId") .. "\n"
      message = message .. "\n ⎝ 𝙑2𝐑𝐚𝐲 𝐇𝐨𝐬𝐭 ⎞  \n ╰┈☞ " .. Http:Dec("v2rHost") .. "\n"
      message = message .. "\n ⎝ 𝐯𝟐𝐫𝐊𝐜𝐩𝐇𝐞𝐚𝐝𝐞𝐫𝐓𝐲𝐩𝐞 ⎞  \n ╰┈☞ " .. Http:Dec("v2rKcpHeaderType") .. "\n"
      message = message .. "\n ⎝ 𝐯𝟐𝐫𝐌𝐮𝐱𝐂𝐨𝐧𝐜𝐮𝐫𝐫𝐞𝐧𝐜𝐲 ⎞  \n ╰┈☞ " .. Http:Dec("v2rMuxConcurrency") .. "\n"
      message = message .. "\n ⎝ 𝐯𝟐𝐫𝐏𝐚𝐬𝐬𝐰𝐨𝐫𝐝 ⎞  \n ╰┈☞ " .. Http:Dec("v2rPassword") .. "\n"
      message = message .. "\n ⎝ 𝐯𝟐𝐫𝐍𝐞𝐭𝐰𝐨𝐫𝐤 ⎞  \n ╰┈☞ " .. Http:Dec("v2rNetwork") .. "\n"
      message = message .. "\n ⎝ 𝐯𝟐𝐫𝐏𝐨𝐫𝐭 ⎞  \n ╰┈☞ " .. Http:Dec("v2rPort") .. "\n"
      message = message .. "\n ⎝ 𝐯𝟐𝐫𝐏𝐫𝐨𝐭𝐨𝐤𝐨𝐥 ⎞  \n ╰┈☞ " .. Http:Dec("v2rProtocol") .. "\n"
      message = message .. "\n ⎝ 𝐯𝟐𝐫𝐇2𝐇𝐨𝐬𝐭 ⎞  \n ╰┈☞ " .. Http:Dec("v2rH2Host") .. "\n"
      message = message .. "\n ⎝ 𝐯𝟐𝐫𝐇2𝐏𝐚𝐭𝐡 ⎞  \n ╰┈☞ " .. Http:Dec("v2rH2Path") .. "\n"
      message = message .. "\n ⎝ 𝐯𝟐𝐫𝐐𝐮𝐢𝐜𝐇𝐞𝐚𝐝𝐞𝐫𝐓𝐲𝐩𝐞 ⎞  \n ╰┈☞ " .. Http:Dec("v2rQuicHeaderType") .. "\n"
      message = message .. "\n ⎝ 𝐯𝟐𝐫𝐓𝐜𝐩𝐇𝐞𝐚𝐝𝐞𝐫𝐓𝐲𝐩𝐞 ⎞  \n ╰┈☞ " .. Http:Dec("v2rTcpHeaderType") .. "\n"
      message = message .. "\n ⎝ 𝐯𝟐𝐫𝐔𝐬𝐞𝐫𝐈𝐝 ⎞  \n ╰┈☞ " .. Http:Dec("v2rUserId") .. "\n"
      message = message .. "\n ⎝ 𝐯𝟐𝐫𝐓𝐥𝐬𝐒𝐧𝐢 ⎞  \n ╰┈☞ " .. Http:Dec("v2rTlsSni") .. "\n"
      message = message .. "\n ⎝ 𝐯𝟐𝐫𝐕𝐥𝐞𝐬𝐬𝐒𝐞𝐜𝐮𝐫𝐢𝐭𝐲 ⎞  \n ╰┈☞ " .. Http:Dec("v2rVlessSecurity") .. "\n"
      message = message .. "\n ⎝ 𝐯𝟐𝐫𝐕𝐦𝐞𝐬𝐬𝐒𝐞𝐜𝐮𝐫𝐢𝐭𝐲 ⎞  \n ╰┈☞ " .. Http:Dec("v2rVmessSecurity") .. "\n"
      message = message .. "\n ⎝ 𝐯𝟐𝐫𝐒𝐬𝐒𝐞𝐜𝐮𝐫𝐢𝐭𝐲 ⎞  \n ╰┈☞ " .. Http:Dec("v2rSsSecurity") .. "\n"
      message = message .. "\n ⎝ 𝐯𝟐𝐫𝐐𝐮𝐢𝐜𝐤𝐒𝐞𝐜𝐮𝐫𝐢𝐭𝐲 ⎞  \n ╰┈☞ " .. Http:Dec("v2rQuicSecurity") .. "\n"
      message = message .. "\n ⎝ 𝐇𝐞𝐚𝐝𝐞𝐫 𝐖𝐬 ⎞  \n ╰┈☞ " .. Http:Dec("v2rWsHeader") .. "\n"
      message = message .. "\n ⎝ 𝐯𝟐𝐫𝐖𝐬𝐏𝐚𝐭𝐡 ⎞  \n ╰┈☞ " .. Http:Dec("v2rWsPath") .. [[

]]
      message = message .. "\n ⎝ 𝐯𝟐𝐫𝐂𝐨𝐫𝐞𝐓𝐲𝐩𝐞 ⎞  \n ╰┈☞ " .. Http:Dec("v2rCoreType") .. [[

]]
      message = message .. "\n ⎝ 𝐓𝐮𝐧𝐧𝐞𝐥 𝐓𝐲𝐩𝐞 ⎞  \n ╰┈☞ " .. Http:TunnelType()
      message = message .. "\n════════════════════════════\n" .. [[
      
]]
    end
    if ehi.tunnelType == "dnstt_ssh" then
      message = message .. "ʀᴇᴀᴅ ᴄᴏɴꜰɪɢ ʙʏ ᴇᴍᴘᴇʀᴏʀ ᴅᴇᴄʀʏᴘᴛᴏʀ\n"
      message = message .. "* \n"
      message = message .. "════════════════════════════\n"
      message = message .. " ⎝ 𝐃𝐍𝐒 𝐭𝐲𝐩𝐞 ⎞  \n ╰┈☞ " .. ehi.dnsType .. "\n"
      message = message .. "\n ⎝ 𝐃𝐍𝐒 𝐑𝐞𝐬𝐨𝐥𝐯𝐞𝐫 𝐀𝐝𝐝𝐫𝐞𝐬𝐬 ⎞  \n ╰┈☞ " .. Http:Dec("dnsttDnsResolverAddr") .. "\n"
      message = message .. "\n ⎝ 𝐃𝐍𝐒𝐓𝐓 𝐍𝐚𝐦𝐞𝐬𝐞𝐫𝐯𝐞𝐫 ⎞  \n ╰┈☞ " .. Http:Dec("dnsttNameserver") .. "\n"
      message = message .. "\n ⎝ 𝐃𝐍𝐒𝐓𝐓 𝐏𝐮𝐛𝐥𝐢𝐜 𝐊𝐞𝐲 ⎞  \n ╰┈☞ " .. Http:Dec("dnsttPublicKey") .. [[

]]
      message = message .. "\n ⎝ 𝐓𝐮𝐧𝐧𝐞𝐥 𝐓𝐲𝐩𝐞 ⎞  \n ╰┈☞ " .. Http:TunnelType()
      message = message .. "\n════════════════════════════\n" .. [[
      
]]

   end
    gg.copyText(message, false)
    gg.toast(message .. [[

✓ 𝐀𝐮𝐭𝐨 𝐂𝐨𝐩𝐢𝐞𝐬]])
    print(message)
    saveEhi(message)
  end
  os.exit()
end

function HttpInjector()
  limit = true
  gg.clearResults()
  gg.setVisible(false)
  gg.setRanges(gg.REGION_JAVA_HEAP | gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_JAVA | gg.REGION_C_HEAP | gg.REGION_PPSSPP | gg.REGION_C_DATA | gg.REGION_C_BSS | gg.REGION_STACK | gg.REGION_ASHMEM | gg.REGION_BAD)
  gg.searchNumber("h 7B 22 63 6F 6E 66 69 67 45 78 70 69 72 79 54 69 6D 65 73 74", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  local r = gg.getResults(1)
  if #r < 1 then
    gg.toast("Pai não encontrado: configExpiryTimest")
    ehi_2 = true
  end
  if ehi_2 then
    gg.searchNumber("h 7B 22 63 6F 6E 66 69 67 49 64 65 6E 74 69 66 69 65 72 22 3A", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: configIdentifier")
      print("\ncalma barboleta")
      print("\nimporte o arquivo novamente, espere 3 segundos e inicie o script da diversão\n\n")
      os.exit()
    end
  end
  gg.searchNumber("h7B", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  local r = gg.getResults(1000)
  readedMem = rwmem(r[1].address, 30000)
  save(hexdecode(readedMem))
  do
    do
      for SRD1_5_, SRD1_6_ in ipairs(r) do
        r[SRD1_5_].flags = gg.TYPE_FLOAT
        r[SRD1_5_].value = "1000"
      end
    end
  end
  gg.setValues(r)
  gg.clearResults()
  parseHttpInjector(readedMem)
end

function LongDump()
    limit = false
    targetInfo = gg.getTargetInfo()
    app = targetInfo.packageName
    function rwmem(Address, SizeOrBuffer)
        assert(Address ~= nil, "[rwmem]: error, provided address is nil.")
        _rw = {}
        if type(SizeOrBuffer) == "number" then
            _ = ""
            do
                do
                    for _FORV_5_ = 1, SizeOrBuffer do
                        _rw[_FORV_5_] = {
                            address = Address - 1 + _FORV_5_,
                            flags = gg.TYPE_BYTE
                        }
                    end
                end
            end
            do
                do
                    for _FORV_5_, _FORV_6_ in ipairs(gg.getValues(_rw)) do
                        if _FORV_6_.value == 0 and limit == true then
                            return _
                        end
                        _ = _ .. string.format("%02X", _FORV_6_.value & 255)
                    end
                end
            end
            return _
        end
        Byte = {}
        SizeOrBuffer:gsub(
            "..",
            function(x)
                Byte[#Byte + 1] = x
                _rw[#Byte] = {
                    address = Address - 1 + #Byte,
                    flags = gg.TYPE_BYTE,
                    value = x .. "h"
                }
            end
        )
        gg.setValues(_rw)
    end

    function hexdecode(hex)
        return (hex:gsub(
            "%x%x",
            function(digits)
                return string.char(tonumber(digits, 16))
            end
        ))
    end

    function hexencode(str)
        return (str:gsub(
            ".",
            function(char)
                return string.format("%2x ", char:byte())
            end
        ))
    end

    function Dec2Hex(nValue)
        nHexVal = string.format("%X", nValue)
        sHexVal = nHexVal .. ""
        return sHexVal
    end

    function ToInteger(number)
        return math.floor(tonumber(number) or error("Could not cast '" .. tostring(number) .. "' to number.'"))
    end

    function save(data)
    
        local function hexencode_spasi(str)
            return (str:gsub(
                ".",
                function(char)
                    return string.format("%02x ", char:byte())
                end
            ))
        end

        local function strip(s)
            return (s:gsub("^%s*(.-)%s*$", "%1"))
        end

        local function prosesData(data)
            local function findExpDate(tbl)
                local key = {
                    "%d%d%d%d[\45]%d%d[\45]%d%d[\32]%d%d[\58]%d%d",
                    "lifeTime"
                }
                local result = nil

                for index_tbl, value_tbl in ipairs(tbl) do
                    for index_key, value_key in ipairs(key) do
                        if value_tbl:match(value_key) then
                            result = index_tbl
                        end
                    end
                end
                return result
            end

            local function splitString(str, separator)
                local match_1, match_2 = str:match("(.-)" .. separator .. "(.*)")
                local tbl = {}

                no = 1
                while (match_2:match("(.-)" .. separator .. "(.*)") and no < 100) do
                    match_1, match_2 = match_2:match("(.-)" .. separator .. "(.*)")

                    if hexdecode(match_1):match("[^\x20]+") then
                        table.insert(tbl, strip(hexdecode(match_1):gsub("[^\x20-\x7e]+", "")))
                    else
                        table.insert(tbl, "undefined")
                    end

                    no = no + 1
                end

                return tbl
            end

            local function fixedConfig(index, tbl)
                local result_fixedConfig = {}
                local beginIndex = index - 4
                local lastIndex = beginIndex + 31

                for i = beginIndex, lastIndex do
                    table.insert(result_fixedConfig, tbl[i])
                end

                return result_fixedConfig
            end
            data = hexencode_spasi(data)
            data = data:gsub("00", "20")
            data = data:gsub("20", "z")
            data = data:gsub("66 61 6c 73 65", "F A L S E")
            data = data:gsub("\x20", "")
            data = data:gsub("\n", "")
            local separator = data:match("FALSE[\x7a]+(.-)[\x7a]+")
            data = data:gsub(separator, "0a56616c647947616e74656e67")
            separator = "0a56616c647947616e74656e67"
            data = data:gsub("z", "20")
            data = data:gsub("FALSE", "66616c7365")

            local result = splitString(data, separator)
            local assemblyPointIndex = findExpDate(result)
            local getConfig = fixedConfig(assemblyPointIndex, result)

            return getConfig
        end

       local function getOutput(tbl)
      local cfgRegex = {
        [1] = {
            ["name"] = "[➤] Payload",["regex"] = "[a-zA-Z]+[\x20]+.*[\x5bcrlf\x5d]+"     
        },
        [2] = {
            ["name"] = "[➤] Proxy",["regex"] = "[%w\x2e]+[\x3a][%d]+"
        },
        [3] = {
            ["name"] = "[➤] Locked Payload And Server",["regex"] = "(.*)"
        },
        [4] = {
            ["name"] = "[➤] Blocked Root",["regex"] = "(.*)"
        },
        [5] = {
            ["name"] = "[➤] Expiration",["regex"] = "(.*)"
        },
--
--         },
        [1] = {
            ["name"] = "[➤] Payload",["regex"] = "(.*)"
        },

        [8] = {
            ["name"] = "[➤] SSH",["regex"] = "[0-9a-zA-Zx\x2e\x2d]+:[%d]+@[%w\x2e\x2d]+:[%w]+"
        },
        [9] = {
            ["name"] = "[➤] ProviderLock",["regex"] = "(.*)"
        },
        [10] = {
            ["name"] = "[➤] ProviderID",["regex"] = "[0-9]"
        },
        [11] = {
            ["name"] = "[➤] OpenVPN-Cerf",["regex"] = "(.*)"
        },
        [12] = {
            ["name"] = "[➤] OpenVPN-User:Pass",["regex"] = "(.*)"
        },
        [13] = {
            ["name"] = "[➤] SNI",["regex"] = "[%w\x2e\x2d]+[\x2e]+[%w]+"
        },

        [15] = {
            ["name"] = "[➤] PortUDPGW",["regex"] = "(.*)"
        },
        [17] = {
            ["name"] = "[➤] LockHWID",["regex"] = "(.*)"
        },
        [18] = {
            ["name"] = "[➤] ValueHWID",["regex"] = "(.*)"
        },
        [19] = {
            ["name"] = "[➤] NickPowered",["regex"] = "(.*)"
        },
        [22] = {
            ["name"] = "[➤] BypassPassword",["regex"] = "(.*)"
        },
        [23] = {
            ["name"] = "[➤] Password",["regex"] = "[a-zA-Z0-9]"
        },
--     
        [25] = {
            ["name"] = "[➤] Psiphon Auth",["regex"] = "(.*)"
     }, 
        [24] = {
            ["name"] = "[➤] Psiphon Mode",
            ["regex"] = "(.*)"

       
      }, 
        [27] = {
            ["name"] = "[➤] SSH",["regex"] = "(.*)"
       
       
       }, 
        [26] = {
            ["name"] = "[➤] V2Ray Mode",["regex"] = "(.*)"



        }, 
        [27] = {
            ["name"] = "[➤] V2Ray",["regex"] = "(.*)"
        },
        [28] = {
            ["name"] = "[➤] Version App",["regex"] = "(.*)"
        },
--
--        },
        [30] = {
            ["name"] = "[➤] NS Server",["regex"] = "[%w\x2e\x2d]+[\x2e]+[%w]+"
        },
        [31] = {
            ["name"] = "[➤] Pub Key",["regex"] = "[a-f0-9]+[32,64,50,66,61,6c,73,65]+"
        },
        [32] = {
            ["name"] = "[➤] DNS",["regex"] = "[%w\x2e\x2d]+[\x2e]+[%w]+"
        }
    }
      
      
      local message = "<!> 𝗗𝗘𝗖𝗥𝗬𝗣𝗧 FOR EVERYTHING <!>\n<!> 𝗗𝗜𝗥𝗘𝗖𝗧𝗟𝗬 𝗙𝗥𝗢𝗠 𝗟𝗨𝗔 <!>\n"
            for index, value in ipairs(tbl) do
           if cfgRegex[index] and value:match(cfgRegex[index]["regex"]) then
              local namaKonten = cfgRegex[index]["name"]
              local valueRegexKonten = value:match(cfgRegex[index]["regex"])
  
              message = message..namaKonten.." : "..valueRegexKonten.."\n"
           end
            end

           message = message.."\n•────────────────────────•\nᴅᴇᴄʀʏᴘᴛ ᴅɪʀᴇᴄᴛʟʏ ꜰʀᴏᴍ ʟᴜᴀ ꜱᴜᴄᴄᴇꜱꜱꜰᴜʟʟʏ\n•────────────────────────•\n"
           return message
        end

        local contentToDecrypt = hexdecode(data)
        contentToDecrypt = prosesData(hexdecode(data))
        local hasil = getOutput(contentToDecrypt)
        io.open(gg.EXT_STORAGE .. "/decrypt.txt", "w"):write(hexdecode(data))
        gg.alert(hasil)
        io.open(gg.EXT_STORAGE .. "/Everyone-dec.txt", "w"):write(hasil)
        gg.copyText(hasil, false)
        gg.toast("✓ Success Copy To Clipboard..!!")
    end
   

     
       gg.clearResults()
     gg.setRanges(gg.REGION_JAVA_HEAP)
  gg.searchNumber(":GET / HTTP/", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  local r = gg.getResults(1)
  if #r < 1 then
    gg.toast("✖ Method 1 failed")
    hc_method2 = true
  end
  if hc_method2 then
    gg.searchNumber("Host: ", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("✖ Method 2 failed")
      hc_method3 = true
    end
  end
  if hc_method3 then
    gg.searchNumber(":inbounds", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("✖ Method 3 failed")
      hc_method4 = true
    end
  end
  if hc_method4 then
    gg.searchNumber(":[crlf]", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("✖ Method 4 failed")
      hc_method5 = true
    end
  end
  if hc_method5 then
    gg.searchNumber("Upgrade: websocket", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("✖ Method 5 failed")
      hc_method6 = true
    end
  end
  if hc_method6 then
    gg.searchNumber(":GET wss:", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("✖ Method 6 failed")
      hc_method7 = true
    end
  end
  if hc_method7 then
    gg.searchNumber(":[splitPsiphon][splitPsiphon]", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("✖ Method 7 failed")
      hc_method8 = true
    end
  end
  if hc_method8 then
    print("✖ All methods failed")
    os.exit()
  end
  local r = gg.getResults(11)
  if limit == false then
    r[1].address = r[1].address - 0x4000
  end
  readedMem = rwmem(r[1].address, 49000)
  save(readedMem)
  gg.clearResults()
end
-----################$
 
  

--hhhhhhhhhhhhhhhhhhhhhhh
function hc_ssc()
  gg.clearResults()
  gg.setRanges(gg.REGION_JAVA_HEAP | gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_JAVA | gg.REGION_C_HEAP | gg.REGION_PPSSPP | gg.REGION_C_DATA | gg.REGION_C_BSS | gg.REGION_STACK | gg.REGION_ASHMEM | gg.REGION_BAD)
  gg.setVisible(true)
  gg.searchNumber("h 7B 22 61 62 22 3A", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  local r = gg.getResults(1)
  if #r < 1 then
    gg.toast("Pai não encontrado: ab")
    ssc_2 = true
  end
  if ssc_2 then
    gg.searchNumber("h 55 70 67 72 61 64 65 3A", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: Upgrade")
      ssc_3 = true
    end
  end
  if ssc_3 then
    gg.searchNumber("h 3A 38 30 40", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: 80")
      ssc_4 = true
    end
  end
  if ssc_4 then
    gg.searchNumber("h 7B 0A 09 09 22 69 6E 62 6F 75 6E 64", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: inbound")
      ssc_5 = true
    end
  end
  if ssc_5 then
    gg.searchNumber("h 7B 0A 20 20 22 64 6E 73 22 3A 20 7B 0A 20 20 20 20 22 68 6F 73 74 73 22", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: dns hosts")
      ssc_6 = true
    end
  end
  if ssc_6 then
    gg.searchNumber("::443@", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: 443")
      ssc_7 = true
    end
  end
  if ssc_7 then
    gg.searchNumber(":[crlf][crlf]", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: crlf")
      ssc_8 = true
    end
  end
  if ssc_8 then
    gg.searchNumber("h 48 6f 73 74 3a 5b 72 6f 74 61 74 65 3d", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: rotate")
      ssc_9 = true
    end
  end
  if ssc_9 then
    gg.toast("Pai não encontrado")
    print("edite a sua busca, use novas palavras chave ou recarregue o aplicativo e configuração novamente\n")
    os.exit()
  end
  local r = gg.getResults(1000)
  if limit == false then
    r[1].address = r[1].address - 8192
  end
  readedMem = rwmem(r[1].address, 40000)
  save(hexdecode(readedMem))
  gg.toast("Pai encontrado")
  print("te peguei Lionel Richie!\n\no arquivo está em: /sdcard/decrypt.txt")
  gg.clearResults()
end
--########№###############
function TLSTunnel()
  limit = false
  gg.clearResults()
  gg.setRanges(gg.REGION_JAVA_HEAP | gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_JAVA | gg.REGION_C_HEAP | gg.REGION_PPSSPP | gg.REGION_C_DATA | gg.REGION_C_BSS | gg.REGION_STACK | gg.REGION_ASHMEM | gg.REGION_BAD)
  gg.setVisible(true)
  gg.searchNumber("h 3A 30 3A 30 3A 74 72 75 65 3A", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  local r = gg.getResults(1)
  if #r < 1 then
    gg.toast("Pai não encontrado: versi")
    tls_2 = true
  end
  if tls_2 then
    limit = false
    gg.searchNumber("h 33 35 39 3A 30 3A 30", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: 359 h")
      tls_3 = true
    end
  end
  if tls_3 then
    gg.searchNumber("h 00 00 7b 00 22 00 41 00 22 00 3a", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: A")
      tls_4 = true
    end
  end
  if tls_4 then
    limit = false
    gg.searchNumber(":357:0:0:", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("357")
      tls_5 = true
    end
  end
  if tls_5 then
    gg.searchNumber("h 63 69 70 68 65 72 31 2e 64 6f 46 69 6e 61 6c 28 63 72 79 70 74 6f 29", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: cipher1 doFinal crypto")
      tls_6 = true
    end
  end
  if tls_6 then
    limit = false
    gg.searchNumber("h 75 00 70 00 77 00 73 00", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: upws")
      tls_7 = true
    end
  end
  if tls_7 then
    limit = false
    gg.searchNumber("h 55 70 67 72 61 64 65 3a", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: Upgrade")
      tls_8 = true
    end
  end
  if tls_8 then
    limit = false
    gg.searchNumber("h 47 45 54 20 77 73", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: GET ws")
      tls_9 = true
    end
  end
  if tls_9 then
    limit = false
    gg.searchNumber("h 47 45 54 20 73 68 69", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: GET shi")
      tls_10 = true
    end
  end
  if tls_10 then
    limit = false
    gg.searchNumber("h 5b 68 6f 73 74 5d 5b 63 72 6c 66 5d", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: host crlf")
      tls_11 = true
    end
  end
  if tls_11 then
    gg.toast("Pai não encontrado")
    print("primeiro as primas.")
    os.exit()
  end
  local r = gg.getResults(1000)
  if limit == false then
    r[1].address = r[1].address - 8192
  end
  readedMem = rwmem(r[1].address, 50000)
  save(hexdecode(readedMem))
  gg.toast("Pai encontrado")
  print("te peguei Lionel Richie!\n\no arquivo está em: /sdcard/decrypt.txt")
  gg.clearResults()
end
--------gjkjvcccbnnmnnvxxx

-------fhjhdssfghjj
function eV2ray()
  gg.clearResults()
  gg.setRanges(gg.REGION_JAVA_HEAP | gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_JAVA | gg.REGION_C_HEAP | gg.REGION_PPSSPP | gg.REGION_C_DATA | gg.REGION_C_BSS | gg.REGION_STACK | gg.REGION_ASHMEM | gg.REGION_BAD)
  gg.setVisible(true)
  gg.searchNumber("h 7B 0A 20 20 22 69 6E 62 6F 75 6E 64", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  local r = gg.getResults(1)
  if #r < 1 then
    gg.toast("Pai não encontrado: inbound")
    epro_2 = true
  end
  if epro_2 then
    gg.searchNumber("h 64 6e 73 22 3a", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: dns")
      epro_3 = true
    end
  end
  if epro_3 then
    gg.searchNumber("h 6f 75 74 62 6f 75 6e 64 73 22 3a", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: aspas outbounds")
      epro_4 = true
    end
  end
  if epro_4 then
    gg.searchNumber("h 22 69 6e 62 6f 75 6e 64 73 22", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: apsas inbounds")
      epro_5 = true
    end
  end
  if epro_5 then
    gg.toast("Pai não encontrado")
    print("\ncalma, barboleta, refresque a memória, importe o arquivo novamente ou inicie a VPN se quiser")
    os.exit()
  end
  local r = gg.getResults(1000)
  if limit == false then
    r[1].address = r[1].address - 8192
  end
  readedMem = rwmem(r[1].address, 50000)
  save(hexdecode(readedMem))
  gg.toast("Pai encontrado")
  print("te peguei Lionel Richie!\n\no arquivo está em: /sdcard/decrypt.txt")
  gg.clearResults()
end

function NapsternetV()
  gg.clearResults()
  gg.setRanges(gg.REGION_JAVA_HEAP | gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_JAVA | gg.REGION_C_HEAP | gg.REGION_PPSSPP | gg.REGION_C_DATA | gg.REGION_C_BSS | gg.REGION_STACK | gg.REGION_ASHMEM | gg.REGION_BAD)
  gg.setVisible(true)
  gg.searchNumber("h 22 76 65 72 73 69 6f 6e 69 6e 67 22", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  local r = gg.getResults(1)
  if #r < 1 then
    gg.toast("Pai não encontrado: versioning")
    npv_2 = true
  end
  if npv_2 then
    gg.searchNumber("h 55 70 67 72 61 64 65 3A", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: Upgrade")
      npv_3 = true
    end
  end
  if npv_3 then
    gg.searchNumber("h 7B 0A 09 09 22 69 6E 62 6F 75 6E 64", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: inbound")
      npv_4 = true
    end
  end
  if npv_4 then
    gg.searchNumber("h 70 73 69 70 68 6f 6e 43 6f 6e 66 69 67 22 3a", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: psiphonConfig")
      npv_5 = true
    end
  end
  if npv_5 then
    limit = false
    gg.searchNumber("h 22 76 65 72 73 69 6f 6e 69 6e 67 22 65 22", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: versioning e")
      npv_6 = true
    end
  end
  if npv_6 then
    limit = false
    gg.searchNumber("h 7b 22 76 65 72 73 69 6f 6e 69 6e 67 22 3a 7b 22 63 6f 6e 66 69 67 54 79 70 65 22 3a", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: versioning configType")
      npv_7 = true
    end
  end
  if npv_7 then
    gg.toast("Pai não encontrado")
    print("primeiro as primas.")
    os.exit()
  end
  local r = gg.getResults(1000)
  if limit == false then
    r[1].address = r[1].address - 8192
  end
  readedMem = rwmem(r[1].address, 50000)
  save(hexdecode(readedMem))
  gg.toast("Pai encontrado")
  print("te peguei Lionel Richie!\n\no arquivo está em: /sdcard/decrypt.txt")
  gg.clearResults()
end
-----

----
function HATunnel()
  gg.clearResults()
  gg.setRanges(gg.REGION_JAVA_HEAP | gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_JAVA | gg.REGION_C_HEAP | gg.REGION_PPSSPP | gg.REGION_C_DATA | gg.REGION_C_BSS | gg.REGION_STACK | gg.REGION_ASHMEM | gg.REGION_BAD)
  gg.setVisible(true)
  gg.searchNumber("h 7b 22 75 73 65 72 5f 69 64 22", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  local r = gg.getResults(1)
  if #r < 1 then
    gg.toast("Pai não encontrado: user id")
    hat_2 = true
  end
  if hat_2 then
    gg.searchNumber("h 7b 5c 22 63 6f 6e 6e 65 63 74 69 6f 6e 5f 6d 6f 64 65 5c 22", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: connecion mode")
      hat_3 = true
    end
  end
  if hat_3 then
    limit = false
    gg.searchNumber("h7b22757365725f696422", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: id")
      hat_4 = true
    end
  end
  if hat_4 then
    limit = false
    gg.searchNumber("h 5c 22 6f 76 65 72 72 69 64 65 5f 70 72 69 6d 61 72 79 5f 68 6f 73 74 5c", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: override primary host")
      hat_5 = true
    end
  end
  if hat_5 then
    limit = false
    gg.searchNumber("h 61 63 63 65 73 73 5f 63 6f 64 65 22 3a", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: acess code")
      hat_6 = true
    end
  end
  if hat_6 then
    gg.toast("Pai não encontrado")
    print("primeiro as primas.")
    os.exit()
  end
  local r = gg.getResults(1000)
  if limit == false then
    r[1].address = r[1].address - 8192
  end
  readedMem = rwmem(r[1].address, 50000)
  save(hexdecode(readedMem))
  gg.toast("Pai encontrado")
  print("te peguei Lionel Richie!\n\no arquivo está em: /sdcard/decrypt.txt")
  gg.clearResults()
end
--------


-----
function SocksHttpPlus()
  limit = true
  gg.clearResults()
  gg.setVisible(true)
  gg.setRanges(gg.REGION_JAVA_HEAP | gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_JAVA | gg.REGION_C_HEAP | gg.REGION_PPSSPP | gg.REGION_C_DATA | gg.REGION_C_BSS | gg.REGION_STACK | gg.REGION_ASHMEM | gg.REGION_BAD)
  gg.searchNumber("h 7b 22 69 64 22 3a", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  local r = gg.getResults(1)
  if #r < 1 then
    gg.toast("Pai não encontrado")
    print("primeiro as primas.")
    os.exit()
  end
  gg.searchNumber("h7B", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  local r = gg.getResults(1000)
  readedMem = rwmem(r[1].address, 50000)
  save(hexdecode(readedMem))
  gg.toast("Pai encontrado")
  print("te peguei Lionel Richie!\n\no arquivo está em: /sdcard/decrypt.txt")
  gg.clearResults()
end

function DarkTunnel()
limit = false
function rwmem(Address, SizeOrBuffer)
	assert(Address ~= nil, "[rwmem]: error, provided address is nil.")
	_rw = {}


	if type(SizeOrBuffer) == "number" then
		_ = ""
		for _ = 1, SizeOrBuffer do _rw[_] = {address = (Address - 1) + _, flags = gg.TYPE_BYTE} end
		for v, __ in ipairs(gg.getValues(_rw)) do
			if __.value == 00 and limit == true then

		return _
		
		end
		_ = _ .. string.format("%02X", __.value & 0xFF)
		
end


		return _
	end
	Byte = {} SizeOrBuffer:gsub("..", function(x)
		Byte[#Byte + 1] = x _rw[#Byte] = {address = (Address - 1) + #Byte, flags = gg.TYPE_BYTE, value = x .. "h"}	end)


	gg.setValues(_rw)


end


function hexdecode(hex)

 return (hex:gsub("%x%x", function(digits) return string.char(tonumber(digits, 16)) end))
end

function hexencode(str)
 return (str:gsub(".", function(char) return string.format("%2x", char:byte()) end))
end

function Dec2Hex(nValue)
	nHexVal = string.format("%X", nValue);
	sHexVal = nHexVal.."";
	return sHexVal;


end


function ToInteger(number)
return math.floor(tonumber(number) or error("Could not cast '" .. tostring(number) .. "' to number.'"))
end

function save(data)

io.open(gg.EXT_STORAGE .. "/decrypt.txt", "w"):write(hexdecode(data))
end







gg.clearResults()

gg.setRanges(gg.REGION_ANONYMOUS)
gg.setVisible(true)

gg.searchNumber(":VersionCode", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
local r = gg.getResults(1)
 if #r < 1 then
gg.toast("✘ 𝐌𝐞𝐭𝐡𝐨𝐝 𝟏 𝐅𝐚𝐢𝐥𝐞𝐝")
Renzy_2 = true
end


if Renzy_2 then
gg.searchNumber("h3a 56 65 72 73 69 6f 6e 43 6f 64 65", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
local r = gg.getResults(1)
if #r < 1 then

gg.toast("✘ 𝐌𝐞𝐭𝐡𝐨𝐝 𝟐 𝐅𝐚𝐢𝐥𝐞𝐝")


Renzy_3 = true
 end


end


if Renzy_3 then

gg.searchNumber(":VersionCode", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
local r = gg.getResults(1)

if #r < 1 then
gg.toast("✘ 𝐌𝐞𝐭𝐡𝐨𝐝 𝟑 𝐅𝐚𝐢𝐥𝐞𝐝")
Renzy_4 = true
end
end

if Renzy_4 then
gg.toast("✘ 𝐃𝐞𝐜𝐫𝐲𝐩𝐭 𝐅𝐚𝐢𝐥𝐞𝐝")
return (Menu)
end


local r = gg.getResults(1)

if limit == true then

r[1].address = r[1].address - 8192
end

readedMem = rwmem(r[1].address, 10000)

save(readedMem)

gg.clearResults()


local f = io.open("/sdcard/decrypt.txt", "r")
 local content = f:read("*all")

 f:close()
 content = string.gsub(content, "", "")
content = string.gsub(content, "[^%z\1-\127]", "") content = string.gsub(content, " ", "")
 content = string.gsub(content, "DnsttConfig", "")

 content = string.gsub(content, "DnsPort5", "")

 content = string.gsub(content, "ProxyPort", "")

 content = string.gsub(content, "ProxyPortP", "")
 content = string.gsub(content, "ProxyPort", "")
 content = string.gsub(content, "PortP", "")
 content = string.gsub(content, "Port", "")

 content = string.gsub(content, "PortP", "")
 content = string.gsub(content, "", "")

 content = string.gsub(content, " ", "")

 content = string.gsub(content, "", "")
 content = string.gsub(content, "", "")

 content = string.gsub(content, "V2RayConfig", "")
 content = string.gsub(content, "ConnectedMessage", "")
 content = string.gsub(content, "InjectConfigMode", "")

 content = string.gsub(content, "TargetHostTargetPortPConfig", "")

 content = string.gsub(content, "TargetHostTargetPortConfig", "")
 content = string.gsub(content, "TargetHostTargetConfig", "")

 content = string.gsub(content, "TargetPortConfig", "")
 content = string.gsub(content, "TargetHost", "")
 content = string.gsub(content, "Target", "")

 content = string.gsub(content, "DnsHost1.1.1.1ServerNamePubkey", "")
 content = string.gsub(content, "\n\n", "")
 content = string.gsub(content, "\nRRN\n", "")
 content = string.gsub(content, "\nRRB\n\n", "")

 content = string.gsub(content, "\n\nRR\n\n", "")
 content = string.gsub(content, "\n\nRRE\n\n\n", "")
 content = string.gsub(content, "\nRrq", "")
 content = string.gsub(content, "VersionCode", "")


 content = string.gsub(content, "VersionName", "\n[</>] Decrypt By : @Dragon_Emperor99\n[</>] VersionName : ")
 content = string.gsub(content, "Message", "\n[</>] Message : ")
 content = string.gsub(content, "ExpiredAtTimestamp", "\n[</>] Expired : ")
 content = string.gsub(content, "TunnelType", "\n[</>] TunnelType : ")
 content = string.gsub(content, "SshConfigLockedSshConfigHost", "\n[</>] HostSSH : ")
 content = string.gsub(content, "Username", "\n[</>] Username : ")

 content = string.gsub(content, "Password", "\n[</>] Password : ")






 content = string.gsub(content, "ProxyHost", "\n[</>] ProxyHost : ")
 content = string.gsub(content, "ServerNameIndication", "\n[</>] SNI : ")
 content = string.gsub(content, "Payload", "\n[</>] Payload : ")

 content = string.gsub(content, "TargetHost", "\n[</>] TargetHost : ")
 content = string.gsub(content, "Config", "\n[</>] V2Ray : ")
 content = string.gsub(content, "Config{", "\n[</>] V2Ray : {")
 content = string.gsub(content, "DnsHost", "\n[</>] Dns Domain : ")

 content = string.gsub(content, "ServerName", "\n[</>] ServerName : ")



content = string.gsub(content, "Decrpt", "Decrypt : By Dragon_Emperor99")





 content = string.gsub(content, "Pubkey", "\n[</>] Pubkey : ")



 content = string.gsub(content, "Pubkey", "\n[</>] Pubkey : ")

 local f = io.open("/sdcard/Dragon_DT.txt", "w")

 f:write(content)
f:close()

 print(content)
os.exit()

 end

function SocksHttp()
  limit = true
  gg.clearResults()
  gg.setVisible(true)
  gg.setRanges(gg.REGION_JAVA_HEAP | gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_JAVA | gg.REGION_C_HEAP | gg.REGION_PPSSPP | gg.REGION_C_DATA | gg.REGION_C_BSS | gg.REGION_STACK | gg.REGION_ASHMEM | gg.REGION_BAD)
  gg.searchNumber("h 7b 22 73 73 68 53 65 72 76 65 72 22 3a 22", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  local r = gg.getResults(1)
  if #r < 1 then
    gg.toast("Pai não encontrado")
    print("primeiro as primas.")
    os.exit()
  end
  gg.searchNumber("h7B", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  local r = gg.getResults(1000)
  readedMem = rwmem(r[1].address, 50000)
  save(hexdecode(readedMem))
  gg.toast("Pai encontrado")
  print("te peguei Lionel Richie!\n\no arquivo está em: /sdcard/decrypt.txt")
  gg.clearResults()
end

function NetModSyna()
  limit = true
  gg.clearResults()
  gg.setVisible(true)
  gg.setRanges(gg.REGION_JAVA_HEAP | gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_JAVA | gg.REGION_C_HEAP | gg.REGION_PPSSPP | gg.REGION_C_DATA | gg.REGION_C_BSS | gg.REGION_STACK | gg.REGION_ASHMEM | gg.REGION_BAD)
  gg.searchNumber("h 7B 22 50 61 79 6C 6F 61 64 22 3A 7B 22 56 61 6C 75 65 22 3A", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  local r = gg.getResults(1)
  if #r < 1 then
    gg.toast("Pai não encontrado")
    print("primeiro as primas.")
    os.exit()
  end
  gg.searchNumber("7Bh", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  local r = gg.getResults(1)
  readedMem = rwmem(r[1].address, 50000)
  save2(hexdecode(readedMem))
  gg.toast("Pai encontrado")
  print("te peguei Lionel Richie!\n\no arquivo está em: /sdcard/decrypt.txt")
  gg.clearResults()
end

function RezTunnel()
  gg.clearResults()
  gg.setRanges(gg.REGION_JAVA_HEAP | gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_JAVA | gg.REGION_C_HEAP | gg.REGION_PPSSPP | gg.REGION_C_DATA | gg.REGION_C_BSS | gg.REGION_STACK | gg.REGION_ASHMEM | gg.REGION_BAD)
  gg.setVisible(true)
  gg.searchNumber("h 7B 5C 22 50 53 49 6E 73 74 61 6C 6C 5C 22", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  local r = gg.getResults(1)
  if #r < 1 then
    gg.toast("Pai não encontrado: install")
    rez_2 = true
  end
  if rez_2 then
    gg.searchNumber("h 7b 22 50 53 49 6e 73 74 61 6c 6c 22 3a", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: PSInstall 1")
      rez_3 = true
    end
  end
  if rez_3 then
    gg.searchNumber("h 50 53 49 6e 73 74 61 6c 6c 22 3a", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: PSInstall 2")
      rez_4 = true
    end
  end
  if rez_4 then
    gg.searchNumber("h 48 6f 73 74 3a 5b 72 6f 74 61 74 65 3d", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado:  rotate")
      rez_5 = true
    end
  end
  if rez_5 then
    gg.searchNumber("h 7B 0A 20 20 20 20 22 56 65 72 73 69 6F 6E 22 3A 20", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: Version Config full")
      rez_6 = true
    end
  end
  if rez_6 then
    gg.searchNumber("h 53 53 48 48 6f 73 74 22 3a", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: SSHHost")
      rez_7 = true
    end
  end
  if rez_7 then
    gg.searchNumber("h 55 70 67 72 61 64 65 3a", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: Version Upgrade")
      rez_8 = true
    end
  end
  if rez_8 then
    gg.toast("Pai não encontrado")
    print("primeiro as primas.")
    os.exit()
  end
  local r = gg.getResults(1)
  if limit == true then
    r[1].address = r[1].address - 8192
  end
  readedMem = rwmem(r[1].address, 50000)
  save(hexdecode(readedMem))
  gg.toast("Pai encontrado")
  print("te peguei Lionel Richie!\n\no arquivo está em: /sdcard/decrypt.txt")
  gg.clearResults()
end

function ApkCustom()
  gg.clearResults()
  gg.setRanges(gg.REGION_JAVA_HEAP | gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_JAVA | gg.REGION_C_HEAP | gg.REGION_PPSSPP | gg.REGION_C_DATA | gg.REGION_C_BSS | gg.REGION_STACK | gg.REGION_ASHMEM | gg.REGION_BAD)
  gg.setVisible(true)
  gg.searchNumber("h 3A 34 34 33 40", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  local r = gg.getResults(1)
  if #r < 1 then
    gg.toast("Pai não encontrado: 443")
    acm_2 = true
  end
  if acm_2 then
    gg.searchNumber("h 55 70 67 72 61 64 65 3A", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: Upgrade")
      acm_3 = true
    end
  end
  if acm_3 then
    gg.searchNumber("h 3A 38 30 40", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: 80")
      acm_4 = true
    end
  end
  if acm_4 then
    limit = true
    gg.searchNumber("h 7B 0A 09 09 22 69 6E 62 6F 75 6E 64", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: inbound")
      acm_5 = true
    end
  end
  if acm_5 then
    limit = false
    gg.searchNumber("h 7B 0A 20 20 22 64 6E 73 22 3A 20 7B 0A 20 20 20 20 22 68 6F 73 74 73 22", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: dns hosts")
      acm_6 = true
    end
  end
  if acm_6 then
    limit = false
    gg.searchNumber("h 3A 35 33 40", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: 53")
      acm_7 = true
    end
  end
  if acm_7 then
    limit = false
    gg.searchNumber("h 5B 73 70 6C 69 74 50 73 69 70 68 6F 6E 5D 5B 73 70 6C 69 74 50 73 69 70 68 6F 6E 5D", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: splitPsiphon")
      acm_8 = true
    end
  end
  if acm_8 then
    gg.toast("Pai não encontrado")
    print("primeiro as primas.")
    os.exit()
  end
  local r = gg.getResults(1000)
  if limit == false then
    r[1].address = r[1].address - 8192
  end
  readedMem = rwmem(r[1].address, 50000)
  save(hexdecode(readedMem))
  gg.toast("Pai encontrado")
  print("te peguei Lionel Richie!\n\no arquivo está em: /sdcard/decrypt.txt")
  gg.clearResults()
end

function SocksIP()
  gg.clearResults()
  gg.setRanges(gg.REGION_JAVA_HEAP | gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_JAVA | gg.REGION_C_HEAP | gg.REGION_PPSSPP | gg.REGION_C_DATA | gg.REGION_C_BSS | gg.REGION_STACK | gg.REGION_ASHMEM | gg.REGION_BAD)
  gg.setVisible(true)
  gg.searchNumber("h6E6577746F6F6C73776F726B732E636F6D2E736F636B7369702E7574696C732E536572536F636B73495068", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  local r = gg.getResults(1)
  if #r < 1 then
    gg.toast("Pai não encontrado: network sip")
    sip_2 = true
  end
  if sip_2 then
    gg.searchNumber("h 55 70 67 72 61 64 65 3A", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: Upgrade")
      sip_3 = true
    end
  end
  if sip_3 then
    gg.searchNumber("h 73 73 68 6f 63 65 61 6e", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: sshocean")
      sip_4 = true
    end
  end
  if sip_4 then
    gg.searchNumber("h 3A 38 30 40", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: 80")
      sip_5 = true
    end
  end
  if sip_5 then
    limit = false
    gg.searchNumber("h 7B 0A 09 09 22 69 6E 62 6F 75 6E 64", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: inbound")
      sip_6 = true
    end
  end
  if sip_6 then
    limit = false
    gg.searchNumber("h 73 70 65 65 64 79 73 73 68 2e", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: dns hosts")
      sip_7 = true
    end
  end
  if sip_7 then
    limit = false
    gg.searchNumber("h 3A 35 33 40", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: 53")
      sip_8 = true
    end
  end
  if sip_8 then
    limit = false
    gg.searchNumber("h 47 45 54 20 77", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: GET w")
      sip_9 = true
    end
  end
  if sip_9 then
    limit = false
    gg.searchNumber("h 5b 63 72 6c 66 5d 48 6f 73 74 3a", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: crlf host")
      sip_10 = true
    end
  end
  if sip_10 then
    limit = false
    gg.searchNumber("h 48 6f 73 74 3a 5b 72 6f 74 61 74 65 3d", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: rotate")
      sip_11 = true
    end
  end
  if sip_11 then
    limit = false
    gg.searchNumber("h 3A 34 34 33 40", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: 443")
      sip_12 = true
    end
  end
  if sip_12 then
    gg.toast("Pai não encontrado")
    print("primeiro as primas.")
    os.exit()
  end
  local r = gg.getResults(1000)
  if limit == false then
    r[1].address = r[1].address - 8192
  end
  readedMem = rwmem(r[1].address, 20000)
  save(hexdecode(readedMem))
  gg.toast("Pai encontrado")
  print("te peguei Lionel Richie!\n\no arquivo está em: /sdcard/decrypt.txt")
  gg.clearResults()
end

function StarkVPN()
  gg.clearResults()
  gg.setRanges(gg.REGION_JAVA_HEAP | gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_JAVA | gg.REGION_C_HEAP | gg.REGION_PPSSPP | gg.REGION_C_DATA | gg.REGION_C_BSS | gg.REGION_STACK | gg.REGION_ASHMEM | gg.REGION_BAD)
  gg.setVisible(true)
  gg.searchNumber("h 7B 5C 22 63 6F 6E 66 69 67 5C 22", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  local r = gg.getResults(1)
  if #r < 1 then
    gg.toast("Pai não encontrado: config barra")
    stk_2 = true
  end
  if stk_2 then
    gg.searchNumber("h 63 6f 6e 66 69 67 22 3a", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: config aspas")
      stk_3 = true
    end
  end
  if stk_3 then
    limit = false
    gg.searchNumber("h 63 6f 6e 6e 65 63 74 69 6f 6e 5f 6d 6f 64 65 22 3a", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: connection mode")
      stk_4 = true
    end
  end
  if stk_4 then
    gg.toast("Pai não encontrado")
    print("primeiro as primas.")
    os.exit()
  end
  local r = gg.getResults(1000)
  if limit == false then
    r[1].address = r[1].address - 8192
  end
  readedMem = rwmem(r[1].address, 50000)
  save(hexdecode(readedMem))
  gg.toast("Pai encontrado")
  print("te peguei Lionel Richie!\n\no arquivo está em: /sdcard/decrypt.txt")
  gg.clearResults()
end

function configjson()
  gg.clearResults()
  gg.setRanges(gg.REGION_JAVA_HEAP | gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_JAVA | gg.REGION_C_HEAP | gg.REGION_PPSSPP | gg.REGION_C_DATA | gg.REGION_C_BSS | gg.REGION_STACK | gg.REGION_ASHMEM | gg.REGION_BAD)
  gg.setVisible(true)
  gg.searchNumber("h 7b a 22 56 65 72 73 69 6f 6e 22 3a", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  local r = gg.getResults(1)
  if #r < 1 then
    gg.toast("Pai não encontrado: Version")
    json_2 = true
  end
  if json_2 then
    gg.searchNumber("h 7b a 9 22 56 65 72 73 69 6f 6e 22 3a", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: Version")
      json_3 = true
    end
  end
  if json_3 then
    gg.searchNumber("h 7b a 20 20 22 56 65 72 73 69 6f 6e 22 3a", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: Version")
      json_4 = true
    end
  end
  if json_4 then
    gg.searchNumber("h 7b a 20 20 20 22 56 65 72 73 69 6f 6e 22 3a", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: Version")
      json_5 = true
    end
  end
  if json_5 then
    gg.searchNumber("h 55 70 67 72 61 64 65 3a", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: Upgrade")
      json_6 = true
    end
  end
  if json_6 then
    gg.searchNumber("h 7B 5C 22 56 65 72 73 69 6F 6E 5C 22 3A 22", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: inbound")
      json_7 = true
    end
  end
  if json_7 then
    gg.toast("Pai não encontrado")
    print("primeiro as primas.")
    os.exit()
  end
  local r = gg.getResults(1000)
  if limit == false then
    r[1].address = r[1].address - 8192
  end
  readedMem = rwmem(r[1].address, 60000)
  save(hexdecode(readedMem))
  gg.toast("Pai encontrado")
  print("te peguei Lionel Richie!\n\no arquivo está em: /sdcard/decrypt.txt")
  gg.clearResults()
end

function TunnelCat()
  gg.clearResults()
  gg.setRanges(gg.REGION_JAVA_HEAP | gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_JAVA | gg.REGION_C_HEAP | gg.REGION_PPSSPP | gg.REGION_C_DATA | gg.REGION_C_BSS | gg.REGION_STACK | gg.REGION_ASHMEM | gg.REGION_BAD)
  gg.setVisible(true)
  gg.searchNumber("h 7B 5C 22 65 78 70 6F 72 74 44 65 74 61 69 6C 73 5C 22", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  local r = gg.getResults(1)
  if #r < 1 then
    gg.toast("Pai não encontrado: export D")
    cat_2 = true
  end
  if cat_2 then
    gg.searchNumber("h 7b 5c 22 65 78 70 6f 72 74 44 65 74 61 69 6c 73 5c 22", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: exportDetails")
      cat_3 = true
    end
  end
  if cat_3 then
    gg.searchNumber(";exportDetails", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: exportDe")
      cat_4 = true
    end
  end
  if cat_4 then
    gg.searchNumber("h 55 70 67 72 61 64 65 3a", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: Upgrade")
      cat_5 = true
    end
  end
  if cat_5 then
    gg.searchNumber("h 69 6e 62 6f 75 6e 64 73", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: inbound")
      cat_6 = true
    end
  end
  if cat_6 then
    gg.toast("Pai não encontrado")
    print("primeiro as primas.")
    os.exit()
  end
  local r = gg.getResults(1000)
  if limit == false then
    r[1].address = r[1].address - 8192
  end
  readedMem = rwmem(r[1].address, 20000)
  save(hexdecode(readedMem))
  gg.toast("Pai encontrado")
  print("te peguei Lionel Richie!\n\no arquivo está em: /sdcard/decrypt.txt")
  gg.clearResults()
end

function v2rayHybrid()
  gg.clearResults()
  gg.setRanges(gg.REGION_JAVA_HEAP | gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_JAVA | gg.REGION_C_HEAP | gg.REGION_PPSSPP | gg.REGION_C_DATA | gg.REGION_C_BSS | gg.REGION_STACK | gg.REGION_ASHMEM | gg.REGION_BAD)
  gg.setVisible(true)
  gg.searchNumber("h 7B 5C 22 61 64 64 65 64 54 69 6D 65 5C 22", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  local r = gg.getResults(1)
  if #r < 1 then
    gg.toast("Pai não encontrado: addedtime")
    hy_2 = true
  end
  if hy_2 then
    gg.searchNumber("h 7b 5c 22 61 64 64 65 64 54 69 6d 65 5c 22", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: added Time")
      hy_3 = true
    end
  end
  if hy_3 then
    gg.searchNumber(";addedTime", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: addedTime")
      hy_4 = true
    end
  end
  if hy_4 then
    gg.searchNumber("h 55 70 67 72 61 64 65 3a", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: Upgrade")
      cat_5 = true
    end
  end
  if hy_5 then
    gg.searchNumber("h 69 6e 62 6f 75 6e 64 73", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: inbound")
      hy_6 = true
    end
  end
  if hy_6 then
    gg.toast("Pai não encontrado")
    print("primeiro as primas.")
    os.exit()
  end
  local r = gg.getResults(1000)
  if limit == false then
    r[1].address = r[1].address - 8192
  end
  readedMem = rwmem(r[1].address, 20000)
  save(hexdecode(readedMem))
  gg.toast("Pai encontrado")
  print("te peguei Lionel Richie!\n\no arquivo está em: /sdcard/decrypt.txt")
  gg.clearResults()
end

Detector = gg.getFile():match("[^/]+$")
Name = "@DRAGON_Emperor99.lua"
if Detector == Name then
 -- gg.alert("✓ 𝐒𝐜𝐫𝐢𝐩𝐭 𝐈𝐬 𝐧𝐨𝐭 𝐑𝐞𝐧𝐚𝐦𝐞𝐝 : \n")
else



function ARMod()
  gg.clearResults()
  gg.setRanges(gg.REGION_JAVA_HEAP | gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_JAVA | gg.REGION_C_HEAP | gg.REGION_PPSSPP | gg.REGION_C_DATA | gg.REGION_C_BSS | gg.REGION_STACK | gg.REGION_ASHMEM | gg.REGION_BAD)
  gg.setVisible(true)
  gg.searchNumber(":[{\"AlterID\"", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  local r = gg.getResults(1)
  if #r < 1 then
    gg.toast("Pai não encontrado: alter id")
    armo_2 = true
  end
  if armo_2 then
    gg.searchNumber("h 5b 7b 5c 22 41 6c 74 65 72 49 44 5c 22", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: alter")
      armo_3 = true
    end
  end
  if armo_3 then
    gg.searchNumber(";AlterID", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: addedTime")
      armo_4 = true
    end
  end
  if armo_4 then
    gg.searchNumber("h 55 70 67 72 61 64 65 3a", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: Upgrade")
      armo_5 = true
    end
  end
  if armo_5 then
    gg.searchNumber("h 69 6e 62 6f 75 6e 64 73", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: inbound")
      armo_6 = true
    end
  end
  if armo_6 then
    gg.toast("Pai não encontrado")
    print("primeiro as primas.")
    os.exit()
  end
  local r = gg.getResults(1000)
  if limit == false then
    r[1].address = r[1].address - 8192
  end
  readedMem = rwmem(r[1].address, 20000)
  save(hexdecode(readedMem))
  gg.toast("Pai encontrado")
  print("te peguei Lionel Richie!\n\no arquivo está em: /sdcard/decrypt.txt")
  gg.clearResults()
end

function WeTunnel()
  gg.clearResults()
  gg.setRanges(gg.REGION_JAVA_HEAP | gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_JAVA | gg.REGION_C_HEAP | gg.REGION_PPSSPP | gg.REGION_C_DATA | gg.REGION_C_BSS | gg.REGION_STACK | gg.REGION_ASHMEM | gg.REGION_BAD)
  gg.setVisible(true)
  gg.searchNumber("h 7B 5C 22 50 53 49 6E 73 74 61 6C 6C 5C 22", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  local r = gg.getResults(1)
  if #r < 1 then
    gg.toast("Pai não encontrado: install")
    we_2 = true
  end
  if we_2 then
    gg.searchNumber("h 7b 22 50 53 49 6e 73 74 61 6c 6c 22 3a", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: PSInstall 1")
      we_3 = true
    end
  end
  if we_3 then
    gg.searchNumber("h 50 53 49 6e 73 74 61 6c 6c 22 3a", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: PSInstall 2")
      we_4 = true
    end
  end
  if we_4 then
    gg.searchNumber("h 7B 5C 22 50 53 49 6E 73 74 61 6C 6C 5C 22", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado:  install 2")
      we_5 = true
    end
  end
  if we_5 then
    gg.searchNumber("h 7B 0A 20 20 20 20 22 56 65 72 73 69 6F 6E 22 3A 20", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: Version Config full")
      we_6 = true
    end
  end
  if we_6 then
    gg.searchNumber("h 53 53 48 48 6f 73 74 22 3a", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: SSHHost")
      we_7 = true
    end
  end
  if we_7 then
    gg.searchNumber("h 55 70 67 72 61 64 65 3a", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: Version Upgrade")
      we_8 = true
    end
  end
  if we_8 then
    gg.toast("Pai não encontrado")
    print("primeiro as primas.")
    os.exit()
  end
  local r = gg.getResults(1)
  if limit == true then
    r[1].address = r[1].address - 8192
  end
  readedMem = rwmem(r[1].address, 50000)
  save(hexdecode(readedMem))
  gg.toast("Pai encontrado")
  print("te peguei Lionel Richie!\n\no arquivo está em: /sdcard/decrypt.txt")
  gg.clearResults()
end
-----asfghg

  
----sfgggg
function XrayPB()
  gg.clearResults()
  gg.setVisible(true)
  gg.setRanges(gg.REGION_JAVA_HEAP | gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_JAVA | gg.REGION_C_HEAP | gg.REGION_PPSSPP | gg.REGION_C_DATA | gg.REGION_C_BSS | gg.REGION_STACK | gg.REGION_ASHMEM | gg.REGION_BAD)
  gg.searchNumber(";{\"addedTime\"", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  local r = gg.getResults(1)
  if #r < 1 then
    gg.toast("Pai não encontrado: addedTime")
    pb_2 = true
  end
  if pb_2 then
    gg.searchNumber("h 7B 5C 22 61 64 64 65 64 54 69 6D 65 5C 22", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: added")
      pb_3 = true
    end
  end
  if pb_3 then
    gg.toast("Pai não encontrado")
    print("primeiro as primas.")
    os.exit()
  end
  local r = gg.getResults(1000)
  if limit == true then
    r[1].address = r[1].address - 8192
  end
  readedMem = rwmem(r[1].address, 20000)
  save(hexdecode(readedMem))
  gg.toast("Pai encontrado")
  print("te peguei Lionel Richie!\n\no arquivo está em: /sdcard/decrypt.txt")
  gg.clearResults()
end

function OpenTunnel()
  gg.clearResults()
  gg.setVisible(true)
  gg.setRanges(gg.REGION_JAVA_HEAP | gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_JAVA | gg.REGION_C_HEAP | gg.REGION_PPSSPP | gg.REGION_C_DATA | gg.REGION_C_BSS | gg.REGION_STACK | gg.REGION_ASHMEM | gg.REGION_BAD)
  gg.searchNumber("h 3C 2F 65 6E 74 72 79 3E 0A 3C 65 6E 74 72 79 20 6B 65 79 3D", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  local r = gg.getResults(1)
  if #r < 1 then
    gg.toast("Pai não encontrado: addedTime")
    tnl_2 = true
  end
  if tnl_2 then
    gg.searchNumber("h 3C 2F 65 6E 74 72 79 3E 0A 3C 65 6E 74 72 79 20 6B 65 79 3D", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: added")
      tnl_3 = true
    end
  end
  if tnl_3 then
    gg.toast("Pai não encontrado")
    print("primeiro as primas.")
    os.exit()
  end
  local r = gg.getResults(1000)
  if limit == true then
    r[1].address = r[1].address - 8192
  end
  readedMem = rwmem(r[1].address, 20000)
  save(hexdecode(readedMem))
  gg.toast("Pai encontrado")
  print("te peguei Lionel Richie!\n\no arquivo está em: /sdcard/decrypt.txt")
  gg.clearResults()
end
----
Error = "⚠ Nama Lua Telah Di ganti 𝐃𝐞𝐭𝐞𝐜𝐭𝐞𝐝\n⚠ Kembalikan lah nama nya seperti semula Jika Ingin Lua nya Bisa di gunakan"
  print(Error)
  return
end
----
function sopass()
  gg.clearResults()
  gg.setVisible(true)
  gg.setRanges(gg.REGION_JAVA_HEAP | gg.REGION_C_ALLOC | gg.REGION_ANONYMOUS | gg.REGION_JAVA | gg.REGION_C_HEAP | gg.REGION_PPSSPP | gg.REGION_C_DATA | gg.REGION_C_BSS | gg.REGION_STACK | gg.REGION_ASHMEM | gg.REGION_BAD)
  gg.searchNumber(";{\"Password\"", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
  local r = gg.getResults(1)
  if #r < 1 then
    gg.toast("Pai não encontrado: pass")
    efbd_2 = true
  end
  if efbd_2 then
    gg.searchNumber("h 7b 5c 22 50 61 73 73 77 6f 72 64 5c 22", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1)
    if #r < 1 then
      gg.toast("Pai não encontrado: Password barra")
      efbd_3 = true
    end
  end
  if efbd_3 then
    gg.toast("Pai não encontrado")
    print("primeiro as primas.")
    os.exit()
  end
  local r = gg.getResults(1000)
  if limit == true then
    r[1].address = r[1].address - 8192
  end
  readedMem = rwmem(r[1].address, 40000)
  save(hexdecode(readedMem))
  gg.toast("Pai encontrado")
  print("te peguei Lionel Richie!\n\no arquivo está em: /sdcard/decrypt.txt")
  gg.clearResults()
end

if app == "com.evozi.injector" then
  HttpInjector()
elseif app == "com.evozi.injector.lite" then
  HttpInjector()
elseif app == "xyz.easypro.httpcustom" then
  LongDump()
elseif app == "com.tlsvpn.tlstunnel" then
  TLSTunnel()
elseif app == "dev.epro.ssc" then
  hc_ssc()
elseif app == "dev.epro.e_v2ray" then
  eV2ray()
elseif app == "com.napsternetlabs.napsternetv" then
  NapsternetV()
elseif app == "com.newtoolsworks.sockstunnel" then
  SocksIP()
elseif app == "com.slipkprojects.sockshttp" then
  SocksHttp()
elseif app == "com.slipkprojects.sksplus" then
  SocksHttpPlus()
elseif app == "com.hatunnel.plus" then
  HATunnel()
elseif app == "team.dev.epro.apkcustom" then
  ApkCustom()
elseif app == "com.techoragontcptun" then
  RezTunnel()
elseif app == "net.darktunnel.app" then
  DarkTunnel()
elseif app == "com.tunnelcatvpn.android" then
  TunnelCat()
elseif app == "com.v2ray.hybrid" then
  v2rayHybrid()
elseif app == "com.one.vpnapp" then
  configjson()
elseif app == "com.hybrid.tunnel" then
  configjson()
elseif app == "com.gdmnetpro.vpn" then
  configjson()
elseif app == "com.trrorcloud.br" then
  configjson()
elseif app == "com.lockproig.vpn" then
  configjson()
elseif app == "app.hackkcah.xyz" then
  configjson()
elseif app == "com.handy.vpn" then
  configjson()
elseif app == "com.socketclay.http" then
  configjson()
elseif app == "com.internetinfinito.http" then
  configjson()
elseif app == "com.socketconexion.vps" then
  configjson()
elseif app == "com.fenix.vpn" then
  configjson()
elseif app == "com.turbovpn.app" then
  configjson()
elseif app == "com.mastercloudvpn.http" then
  configjson()
elseif app == "com.godiesan.vpn" then
  configjson()
elseif app == "com.cloud.focus" then
  configjson()
elseif app == "com.doriaxvpn.http" then
  configjson()
elseif app == "com.sockslitepro.net" then
  configjson()
elseif app == "br.com.litesshbrasil" then
  configjson()
elseif app == "istark.vpn.starkreloaded" then
  StarkVPN()
elseif app == "com.Internetshub.socks" then
  WeTunnel()
elseif app == "com.sihiver.xraypb" then
  XrayPB()
elseif app == "com.opentunnel.app" then
  OpenTunnel()
elseif app == "com.artunnel57" then
  ARMod()
elseif app == "com.ar.dev.bdvpninject" then
  sopass()
elseif app == "com.ef.dev.eftunnel" then
  sopass()
elseif app == "com.netmod.syna" then
  NetModSyna()
else
  gg.toast("não me deixe vê")
  print("\nhoje não é o seu dia de sorte\n\n")
end
gg.clearResults()
os.exit()
