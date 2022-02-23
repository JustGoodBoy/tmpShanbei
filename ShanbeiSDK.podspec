#
# Be sure to run `pod lib lint ShanbeiSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ShanbeiSDK'
  s.version          = '0.3.1'
  s.summary          = 'A short description of ShanbeiSDK.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'http://121.41.108.203/MC-iOS/ShanbeiSDK.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '地瓜' => 'digua@admobile.top' }
  s.source           = { :path => 'https://github.com/JustGoodBoy/tmpShanbei.git', :tag => '0.3.1' }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'ShanbeiSDK/Classes/**/*'
  
  s.resource_bundles = {
   'ShanbeiSDK' => ['ShanbeiSDK/Assets/**/*']
  }

  s.public_header_files = 'Pod/Classes/ShanbeiSDK.h'
  s.frameworks = 'UIKit'
  s.dependency 'YYModel', '~>1.0.4'
  s.dependency 'YYWebImage', '~>1.0.5'
  s.dependency 'FDFullscreenPopGesture'
  s.dependency 'Masonry'
  # 苏伊士广告
  s.dependency 'ADSuyiSDK', '~>3.5.0.0'                 # 主SDK  #必选
  s.dependency 'ADSuyiSDK/ADSuyiSDKPlatforms/gdt'       # 优量汇(广点通）
  s.dependency 'ADSuyiSDK/ADSuyiSDKPlatforms/admobile'  # ADMobile  #必选
  s.dependency 'ADSuyiSDK/ADSuyiSDKPlatforms/bu'        # 穿山甲(头条)
  s.static_framework = true
  # 微信
  s.dependency 'WechatOpenSDK'
  s.dependency 'IQKeyboardManager'
end
