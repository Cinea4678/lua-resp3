local resp3 = require "resp3"
local luaunit = require "luaunit"

function TestFromString()
    -- blob string
    local v1 = resp3.fromString("$11\r\nhello world\r\n")
    luaunit.assertEquals(v1.str, "hello world")

    -- simple string
    local v2 = resp3.fromString("+hello world\r\n")
    luaunit.assertEquals(v2.str, "hello world")

    -- verbatim string
    local v3 = resp3.fromString("=15\r\ntxt:Some string\r\n")
    luaunit.assertEquals(v3.str, "Some string")
    luaunit.assertEquals(v3.strFmt, "txt")
end

function TestFromError()
    -- simple error
    local v1 = resp3.fromString("-ERR this is the error description\r\n")
    luaunit.assertEquals(v1.err, "ERR this is the error description")

    -- blob error
    local v2 = resp3.fromString("!21\r\nSYNTAX invalid syntax\r\n")
    luaunit.assertEquals(v2.err, "SYNTAX invalid syntax")
end

function TestFromNumber()
    local v = resp3.fromString(":1234\r\n")
    luaunit.assertEquals(v.num, 1234)
end

function TestFromDouble()
    local v1 = resp3.fromString(",1.23\r\n")
    luaunit.assertEquals(v1.num, 1.23)

    local v2 = resp3.fromString(",inf\r\n")
    luaunit.assertEquals(v2.num, math.huge)

    local v3 = resp3.fromString(",-inf\r\n")
    luaunit.assertEquals(v3.num, -math.huge)
end

function TestFromNull() local _ = resp3.fromString("_\r\n") end

function TestFromBoolean()
    local v1 = resp3.fromString("#t\r\n")
    luaunit.assertEquals(v1.bool, true)

    local v2 = resp3.fromString("#f\r\n")
    luaunit.assertEquals(v2.bool, false)
end

function TestFromBigInt()
    local v = resp3.fromString(
                  "(3492890328409238509324850943850943825024385\r\n")
    luaunit.assertEquals(v.num, "3492890328409238509324850943850943825024385")
end

function TestFromArray()
    local v = resp3.fromString("*3\r\n:1\r\n:2\r\n:3\r\n")
    luaunit.assertEquals(#v.elems, 3)
    for i, vv in ipairs(v.elems) do
        luaunit.assertEquals(vv.t, resp3.typeChars.typeNumber)
        luaunit.assertEquals(vv.num, i)
    end
end

function TestFromMap()
    local v = resp3.fromString("%2\r\n+v1\r\n:1\r\n+v2\r\n:2\r\n")
    for k, vv in pairs(v.kv) do
        assert(k.str == "v1" or k.str == "v2")
        if k.str == "v1" then
            luaunit.assertEquals(vv.num, 1)
        else
            luaunit.assertEquals(vv.num, 2)
        end
    end
end

os.exit(luaunit.LuaUnit.run())
