---
title: CMAKE实践
date: 2019-05-04 20:34:30
tags: [cmake, makefile]
categories: 工具
---

由于之前编译代码一直用Makefile, 但是新公司都用CMake来编译,就花了一天的时间把Makefile换成CMakeLists.txt. 把学习的过程记录下来

<!-- more -->

先介绍下代码目录

```
.
├── CMakeLists.txt
├── include
│   ├── event.h
│   ├── openssl
├── lib
│   ├── libevent.a
│   └── libssl.a
├── server
│   ├── CMakeLists.txt
│   ├── server.cpp
│   ├── server.h
│   ├── licAuth.conf
├── src
│   ├── CMakeLists.txt
│   ├── src1.cpp
│   ├── src1.h
└── test
    ├── CMakeLists.txt
    ├── test1.cpp
    └── test2.cpp
```
- include: 头文件, gcc/g++的 -I后面跟的就是此目录
- lib: 静态库, -L 选项后面跟的目录
- server: server程序,这个程序要调用src目录下的所有代码产生的静态库, 下面有个licAuth.conf是默认的配置文件,make install的时候要安装到/etc/目录下面
- src: 源文件, 要封装成静态库以供别人调用
- test: 一些测试程序,测试src目录在的代码

### 开始
在我们写的代码目录src, server, test下都新建一个CMakeLIsts.txt, 根目录下也要有, 注意不要拼错了,Lists大写的后面跟s.

根目录下**./CMakeLists.txt**
```cmake
cmake_minimum_required (VERSION 2.8) #照抄就行了
project(licAuth) # 随便起个名字 然后LicAuth_SOURCE_DIR这个变量就等于该目录
add_subdirectory(src) #表示编译src目录
add_subdirectory(server) #表示编译server目录
add_subdirectory(test) #同上
```
src目录**./src/CMakeLists.txt**
```cmake
cmake_minimum_required(VERSION 2.8) #照抄
project(lib) #还是随便起 同时添加了一个lib_SOURCE_DIR变量

include_directories(${licAuth_SOURCE_DIR}/include) #添加头文件目录 相当于 -I
link_directories(${licAuth_SOURCE_DIR}/lib) # 添加静态库目录 相当于 -L

# 添加一些编译选项, 比如-g之类的
add_compile_options(-Wall -std=c++11 -Wunused-variable)
# 下面这两个语句代表吧本目录在的所有源文件打包成一个静态库 liblic.a
aux_source_directory(. DIR_LIB_SRCS)
add_library (lic ${DIR_LIB_SRCS})
```
server目录 ./server/CMakeLists.txt
```cmake
cmake_minimum_required (VERSION 2.8)
project (server)

# 添加include 和src下的头文件
include_directories(${licAuth_SOURCE_DIR}/include ${lib_SOURCE_DIR}) 
# 添加lib和src下生成的静态库
link_directories(${licAuth_SOURCE_DIR}/lib ${lib_SOURCE_DIR})

#还是编译选项 自己看着加
add_compile_options(-Wall -std=c++11 -O3 -flto -Wl,--no-as-needed  -Wunused-variable)

# 这里就要生成程序了 server是生成目标,后面跟源文件
add_executable(server server.cpp)
# 这是添加需要的库, 第一是目标后面是需要的库 -liblic -lssl -lcrypto
target_link_libraries(server lic ssl crypto pthread protobuf event machineid)
#上面这两句话相当与 gcc -o server server.cpp -liblic -lssl -lcrypto

add_executable(client client.cpp)
target_link_libraries(client lic ssl crypto pthread protobuf event machineid)

# make install的配置, 把licAuth.conf 复制到/etc/目录
INSTALL(FILES licAuth.conf DESTINATION /etc/)
```
test目录下的就跟server目录差不多了

### 编译
编译的时候最好新建一个目录,在新建的目录在cmake, 这样可以很干净的删除cmake的中间产物,比如
```
mkdir build
cd build
cmake ..
make
```
当测试完毕的时候 直接把build目录删除就好了 或者cmake出错的时候,也能清空build目录重来.