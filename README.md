# Utility

## 支持

iOS 8 +

## 安装

####  作为pod依赖 在podfile中添加

```
pod 'CDChatList', :source => 'http://git-ma.paic.com.cn/aat/AATComponent_iOS.git'
```

####  作为framework 集成

```
pod package CDChatList.podspec --force  -verbose
```

####  最为静态库集成（需要手动处理资源文件）

```
pod package CDChatList.podspec --library  --force  -verbose

