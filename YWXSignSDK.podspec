#
# Be sure to run `pod lib lint YWXSignSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YWXSignSDK'
  s.version          = '3.7.0'
  s.summary          = '医网信医生签名SDK'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/yiwangxin/YWXSignSDK.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'XiaoY2017' => 'szyx@bjca.org.cn' }
  s.source           = { :git => 'https://github.com/yiwangxin/YWXSignSDK.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  
  s.default_subspecs = 'Core'
    
  # 核心模块
  s.subspec 'Core' do |sp|
    sp.vendored_frameworks = 'YWXSignSDK/Core/YWXSignSDK.framework'
    sp.resources = 'YWXSignSDK/Core/YWXSignSDK.bundle'
    sp.dependency 'YWXSignSDK/YWXSignFoundation'
  end
  
  s.subspec 'YWXSignFoundation' do |sp|
    sp.vendored_frameworks = 'YWXSignSDK/Support/Required/YWXSignFoundation.framework'
  end
  
  s.subspec 'YWXBjcaSignSDK' do |sp|
    sp.vendored_frameworks = 'YWXSignSDK/Support/Optional/YWXBjcaSignSDK/YWXBjcaSignSDK.framework'
    sp.resources = ['YWXSignSDK/Support/Optional/YWXBjcaSignSDK/keyBoard.bundle','YWXSignSDK/Support/Optional/YWXBjcaSignSDK/Signet-SDK-Bundle.bundle']
    sp.dependency 'YWXSignSDK/Core'
  end
  
end
