cd src
make linux64
cd luaplus
../../bin/linux64/jam LUA_VERSION=lua53-luaplus C.TOOLCHAIN=linux64/release
cd ..
export LUA_BIN=luaplus/.build/linux64/bin
make linux64
export LUA_BIN=
cd ..

