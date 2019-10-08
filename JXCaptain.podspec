
Pod::Spec.new do |s|
  s.name         = "JXCaptain"
  s.version = "0.0.11"
  s.summary      = "一个应用调试工具箱"
  s.homepage     = "https://github.com/pujiaxin33/JXCaptain"
  s.license      = "MIT"
  s.author       = { "pujiaxin33" => "317437084@qq.com" }
  s.platform     = :ios, "9.0"
  s.swift_version = "5.0"
  s.source       = { :git => "https://github.com/pujiaxin33/JXCaptain.git", :tag => "#{s.version}" }
  s.framework    = "UIKit"
  s.source_files  = "Sources", "Sources/**/*.{swift}"
  s.resource = 'Resources/Resource.bundle'
  s.requires_arc = true
  
  s.dependency 'BSBacktraceLogger'
end
