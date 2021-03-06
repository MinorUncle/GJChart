Pod::Spec.new do |s|

  s.name             = "GJChart"    #名称

  s.version          = "2.0"           #版本号

  s.summary          = "ios最简单图表"     #，

  s.homepage         = "https://github.com/MinorUncle"                           #主页,这里要填写可以访问到的地址，不然验证不通过

  s.license          = "MIT"              #开源协议

  s.author           = { "MinorUncle" => "1065517719@qq.com" }                   #作者信息

  s.source           = { :git => "https://github.com/MinorUncle/GJChart.git", :tag => "v2.0" }      #项目地址，这里不支持ssh的地址，验证不通过，只支持HTTP和HTTPS，最好使用HTTPS 

  s.platform         = :ios, "6.0" #支持的平台及版本

  s.requires_arc     = true #是否使用ARC，如果指定具体文件，则具体的问题使用ARC

  s.source_files     = "GJChart/Chart/**/*" #代码源文件地址，**/*表示Classes目录及其子目录下所有文件，如果有多个目录下则用逗号分开，如果需要在项目中分组显示，这里也要做相应的设置


  s.public_header_files = "GJChart/Chart/**/*.h" #公开头文件地址

  s.frameworks       = "UIKit" #所需的framework，多个用逗号隔开

end