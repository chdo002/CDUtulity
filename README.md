# Utility(0.3.0)

## 支持

iOS 8 +

## 安装
//!     从这个版本开始，使用静态库作来管理代码，位置在根目录下的FrameWork下，更目录下的其他文件及代码不再维护，除了本文件


编译静态库工程得到静态库，或直接拖动工程

在静态库封装过程中，如果静态库文件包含类别，在主工程将无法使用。
解决方法为：找到主工程的 target －－Build Setting－－Linking－－更改其 Other Linker Flags 为： -all_load 或 -force_load 即可。

