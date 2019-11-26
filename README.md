![](https://github.com/pujiaxin33/JXExampleImages/blob/master/JXCaptain/JXCaptain_icon_shield.png)
# JXCaptain

像美国队长一样威猛的应用调试工具箱！

# 前言

每个稍有规模的APP都会有一些开发测试功能，比如切换服务器环境、浏览沙盒文件、查看页面帧率以及接口请求日志等。之前项目内部前前后后实现了一些功能，直到看到了滴滴开源的[DoraemonKit](https://github.com/didi/DoraemonKit)。被它完整的功能实现所折服，引入之后真的就拥有了强大的工具集合。在是否要引入`DoraemonKit`之际，我陷入了深深的思考。第一，项目几乎是纯Swift语言开发，并且尽量不再去引用OC的库。第二，内部已经实现了许多功能，稍加改造也能转正为人名服务。所以，就借鉴了`DoraemonKit`的思路和部分代码，重新实现了`JXCaptain`，一个强大的Swift编写的应用调试工具箱。

取名`Captain`队长的含义，就是把一个个功能比喻为战士，队长就是指挥这些战士的精神领袖。有了队长就能所向披靡，战无不胜！

# 预览

![](https://github.com/pujiaxin33/JXExampleImages/blob/master/JXCaptain/JXCaptain.png)

# 功能模块

## 常用工具

- **【App信息】** 快速查看手机信息，App 信息，权限信息的渠道，避免去手机设置查找或者查看项目源代码的麻烦；
- **【沙盒浏览】** 沙盒目录浏览，支持图片、视频、sql数据库等文件预览，支持文件的共享；
- **【Crash日志】** 捕获Crash，并将日志通过文件形式保存在沙盒里面；
- **【H5任意门】** 开始输入H5地址进行网页功能验证；
- **【UserDefauls】** 查看`UserDefauls.shared`记录的键值对数据；

## 性能检测

- **【FPS】** 顶部状态栏实时显示当前的帧率；
- **【内存】** 顶部状态栏实时显示当前的内存占用；
- **【CPU】** 顶部状态栏实时显示当前的CPU使用率；
- **【卡顿】** 当页面出现卡顿是，保存当时的堆栈信息，使用`BSBacktraceLogger`获取堆栈信息；
- **【流量】** 监听APP和网页的接口调用，查看Header、Response等信息；


# 自定义工具

## 实现`Soldier`协议

```Swift
public class UserDefaultsSoldier: Soldier {
    public static let shared = UserDefaultsSoldier()
    //工具列表显示的名字
    public var name: String
    //归属于哪个团队？比如：常用工具、性能检测或者自定义团队名
    public var team: String
    //工具列表显示的icon
    public var icon: UIImage?
    //如果你不适用默认的name加icon的显示，直接创建新视图赋值给contentView即可
    public var contentView: UIView?
    //是否监听到了新的事件，比如Crash日志捕获到了新的Crash，将hasNewEvent设置为true，就会显示红点提示
    public var hasNewEvent: Bool = false

    public init() {
        name = "UserDefaults"
        team = "常用工具"
        icon = ImageManager.imageWithName("JXCaptain_icon_app_user_defaults")
    }
    //APP启动之后会调用该方法，用于启动当前工具的工作。比如帧率检测，调用prepare之后就开始检测帧率并显示到顶部状态了。
    public func prepare() { }
    //用点击了工具列表的Icon之后，就行页面的调整。一般工具都会有一个进行配置的Dashboard页面
    public func action(naviController: UINavigationController) {
        naviController.pushViewController(UserDefaultsKeyValuesListViewController(defaults: UserDefaults.standard), animated: true)
    }
}
```

## 添加新的`Soldier`

```Swift
Captain.default.enqueueSoldiers([ServerEnvironmentSoldier()])
```

## 配置已有的`Soldier`

```Swift
Captain.default.configSoldierClosure = { (soldier) in
    if let websiteEntry = soldier as? WebsiteEntrySoldier {
        //设置H5任意门默认网址
        websiteEntry.defaultWebsite = "https://www.baidu.com"
        //设置H5任意门自定义落地页面，比如项目有自定义WKWebView、有JS交互逻辑等
        websiteEntry.webDetailControllerClosure = { (website) in
            return UIViewController()
        }
    }
    if let anr = soldier as? ANRSoldier {
        //设置卡顿时间阈值，单位秒
        anr.threshold = 2
    }
    if let crash = soldier as? CrashSoldier {
        //自定义处理crash信息，可以存储到本地，下次打开app再传送到服务器记录
        crash.exceptionReceiveClosure = { (signal, exception, info) in
            if signal != nil {
                print("signal crash info:\(info ?? "")")
            }else if exception != nil {
                print("exception crash info:\(info ?? "")")
            }
        }
    }
}
```

## 启动工具

```Swift
Captain.default.prepare()
```

# `Captain`的显示与隐藏

可以监听摇一摇、或者在Window上面添加两指连击4次，就显示`Captain`。调用如下代码即可：
```Swift
Captain.default.show()
```

隐藏`Captain`调用如下代码：
```Swift
Captain.default.hide()
```






