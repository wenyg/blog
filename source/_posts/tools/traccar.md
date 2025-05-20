---
title: "定位软件 traccar"
date: 2025-05-20 17:28:04
tags: [traccar]
categories: 工具 
---

**安装手机端**

1. IOS 可在应用商店下载，Android 可在 [traccar-client-android](https://github.com/traccar/traccar-client-android) 下载
2. 安装，国内可能被认定为病毒软件。
3. 安转完之后有打开，有个设备编码可以自己设置。这个用于在服务端添加设备

**部署服务端**

```
docker run --name traccar \
    -v ~/.traccar/data:/opt/traccar/data \
    -p 8082:8082 \
    traccar/traccar
```

打开自己的服务器地址，注册，添加设备即可。

**其他**

对于 Android 13以上的设备，可能需要下载源码重新编译，在 `traccar-client-android/app/src/main/AndroidManifest.xml` 添加

```
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```
否则可能会被系统杀死。