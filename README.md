# Lua-RESP3

This library is used for serializing and deserializing with the RESP3 protocol, and inspired by [smallnest/resp3](https://github.com/smallnest/resp3/) in Go.

It's worth noting that this is the first time I've developed in the Lua language, so there's maybe something not so good in this library.

## Usage

You can easily serialize a value into RESP3:

```lua
resp3 = require('resp3')
v = resp3.newBlobString("Hello world!")
print(resp3.toRESP3String(v))
```

Which will get:

```
$12\r\nHello world!\r\n
```

Similarly, you can deserialize a value from RESP3:

```lua
resp3 = require('resp3')
v = resp3.fromString(":1234\r\n")
print(v.str)
print(v.num)
```

Which will get:

```
nil
1234
```
