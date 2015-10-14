Swiftmi.Com Server API
=========

##接口说明

网站所有接口采用JSON交互,目前网站采用Node.JS写的,后面也会选择开源。


##接口列表


- /api/user/login  POST  登录
- /api/user/reg   POST 注册
- /api/topic/comment POST 评论
- /api/topic/list/{maxId}/{count} GET 列表
- /api/topic/{topicId} GET 详情
- /api/sharecode/list/{maxId}/{count} GET 源码分享列表
- /api/sharecode/{codeId} GET 源码详情
- /api/books/{type}/{maxId}/{count} GET 书籍列表
- /api/topic/create POST 创建topic


待续....
