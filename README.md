Ta-htd
================
## 工程：
###工程文件结构

#一级文件
-----------------
UI                                  界面类
3rdPart                             三方类
Class                               本地类
SupportingFlies                     app其他文件包       

#二级文件
三方类
------------------
MMDrawerController                                
UIViewController+Category            提示框
UIView+Category
Ease                                 环信聊天界面实现类
HyphenateSDK                         环信SDK
HttpNetwork                          封装网络请求基类

本地类
------------------
Information                          咨询类及组件（控制器及视图）
Status                               状态类及组件
Main                                 首页类及组件
Tom                                  专家Tom类及组件
LoginRegisterView                    登录及组件
AppDelegate                     
DB                                   数据库类
Charts                               图表绘制类
Message                              Cmd命令通讯类
AppDelegate+Ta                       app启动相关操作
AppDelegate+Umeng                    友盟统计分析
Helper                               环信监听回调
MainViewController                   NavigationController跟视图类
Constant                             全局变量
FrameWork                            app引入框架
Resources                            app资源文件包
PrefixHeader_Ta.PCH                  宏配置文件
Localizable.strings                  本地字符串
cn.Ta.HaiTuDeng.com-Bridging-Header  基于Swift图形绘制组件的OC桥接文件 

###功能完备日志
＃（目标）（优先级）（ 责任人）（完成情况）
##9月12日本周

一级
-------------------------------------------
1:点心折线图
1.1:处理折线图的X轴数据（熊）
1.2:添加滑动到绑定日期的锁住滑动功能（马）
1.3:折线图数据不能出现浮点格式（熊）
1.4:手势冲突（熊）
2:UI（1级）
2.1:UI的xib文件全部转换成代码约束（浩田）
2.2:UI图标的确定和替换（浩田）

3:用户头像
3.1:头像功能的实现框架，布局结构以及方法名（茂）
3.2:功能的实现及bug的修改（熊）

4:排名模块
4.1:排名的UI代码约束布局（熊）
4.2界面图标级颜色更改（浩田）
4.3功能实现（熊）
4.4后台实现（熊）

5:app打包以及上传网站的域名问题（茂）

6:资讯改为更新一次刷新10条资讯（马剑）✅
二级
-------------------------------------------
1:小滑块手势识别不方便
1.1:考虑重新布局或者修改手势方式（马）

2:专家打赏功能demo（不接入支付）（熊）

3:提醒功能缓存化，只在第一次登入时有显示，修改此bug（熊）