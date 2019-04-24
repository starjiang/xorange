local bit = require("bit")
local stringy = require("orange.utils.stringy")
local _M = {}

function _M.ipToInt(str)
	local num = 0
	if str and type(str)=="string" then
		local o1,o2,o3,o4 = str:match("(%d+)%.(%d+)%.(%d+)%.(%d+)" )
		num = 2^24*o1 + 2^16*o2 + 2^8*o3 + o4
	end
    return num
end

function _M.intToIp(n)
	if n then
		n = tonumber(n)
		local n1 = math.floor(n / (2^24))
		local n2 = math.floor((n - n1*(2^24)) / (2^16))
		local n3 = math.floor((n - n1*(2^24) - n2*(2^16)) / (2^8))
		local n4 = math.floor((n - n1*(2^24) - n2*(2^16) - n3*(2^8)))
    	return n1.."."..n2.."."..n3.."."..n4
	end
	return "0.0.0.0"
end

function _M.toMaskIp(ip_with_mask)
  local info = stringy.split(ip_with_mask,"/")
  local ip = tonumber(info[1])
  local bit = tonumber(info[2])
  local mask = bit.lshift(0xffffffff,32-bit)
  local ipn = _M.ipToInt(ip)
  ipn = bit.band(ipn,mask)
  ipn = tonumber('0x'..bit.tohex(ipn))
  return _M.intToIp(ipn)
end

return _M