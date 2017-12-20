#
# Be sure to run `pod lib lint SIUIKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SIUIKit'
  s.version          = '0.1.10'
  s.summary          = 'SIUIKit.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
    UIKit of Super Id
                       DESC

  s.homepage         = 'http://superid.cn:81/iOS/SIUIKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ungacy' => 'yetao@superid.cn' }
  s.source           = { :git => 'git@git.superid.cn:iOS/SIUIKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.public_header_files = 'SIUIKit/Classes/*.h'
  s.source_files = 'SIUIKit/Classes/*'

  s.subspec 'Alert' do |ss|
    ss.source_files = 'SIUIKit/Classes/SIAlertView/*'
	ss.public_header_files = 'SIUIKit/Classes/SIAlertView/*.h'
    ss.dependency 'YCEasyTool'
    ss.dependency 'SIUIKit/Font'
    ss.dependency 'SIUIKit/Color'
  end

  s.subspec 'Font' do |ss|
    ss.source_files = 'SIUIKit/Classes/SIFont/*'
	ss.public_header_files = 'SIUIKit/Classes/SIFont/*.h'
  end
  
  s.subspec 'Color' do |ss|
    ss.source_files = 'SIUIKit/Classes/SIColor/*'
	ss.public_header_files = 'SIUIKit/Classes/SIColor/*.h'
  end
  
  s.subspec 'Refresh' do |ss|
    ss.source_files = 'SIUIKit/Classes/SIRefreshHeader/*'
	ss.public_header_files = 'SIUIKit/Classes/SIRefreshHeader/*.h'
    ss.dependency 'MJRefresh'
    ss.dependency 'SIUIKit/Font'
    ss.dependency 'SIUIKit/Color'
  end
  
  
  
  s.frameworks = 'UIKit', 'QuartzCore'
  s.dependency 'Masonry'
  # s.dependency 'AFNetworking', '~> 2.3'
end
