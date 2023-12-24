---
title: "怎样编写 OpenAPI"
date: 2022-02-28 19:41:29
tags: ["OpenAPI"]
---

# OpenAPI

[OpenAPI](https://swagger.io/specification/) 是一种与语言无关的文档，用来描述 web 服务。

```yaml
openapi: 3.0.3
info:
  title: hi
  version: 0.0.1

paths:
  /hi:
    get:
      responses:
        '200':
          description: OK
          content:
            text/plain:
              schema:
                type: string
                enum: ["hello"]
```

比如以上文档就描述了这样一个服务， 当你用 `GET` 方法访问 `/hi` 接口时

```
GET /hi
```

就会得到一个 body 为 `hello` 的响应

```
HTTP/1.0 200 OK
Content-Type: text/plain

hello
```

接下来我们介绍如何在 OpenAPI 中描述一个接口, 详细文档请移步: https://www.winn.cc/openapi-intro/#/README