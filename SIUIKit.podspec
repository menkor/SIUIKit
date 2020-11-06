#
# Be sure to run `pod lib lint SIUIKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SIUIKit'
  s.version          = '0.2.6'
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

  s.ios.deployment_target = '8.0'

  s.default_subspec = 'All'

  s.subspec 'Pure' do |ss|
      ss.public_header_files = 'SIUIKit/Classes/Search/*.h', 'SIUIKit/Classes/SIMessageBox/*.h'
      ss.source_files = 'SIUIKit/Classes/Search/*.[hm]', 'SIUIKit/Classes/SIMessageBox/*.[hm]'
      ss.frameworks = 'UIKit', 'QuartzCore'
      ss.dependency 'Masonry'
      ss.dependency 'MJRefresh'
      ss.dependency 'SITheme'
      ss.dependency 'SIDefine/Pure'
  end

  s.subspec 'All' do |ss|
      ss.public_header_files = 'SIUIKit/Classes/*/*.h'
      ss.source_files = 'SIUIKit/Classes/**/*.[hm]'
      ss.ios.resource_bundle = { 'SIUIKit' => 'SIUIKit/Assets/*.*' }
      ss.frameworks = 'UIKit', 'QuartzCore'
      ss.dependency 'Masonry'
      ss.dependency 'MJRefresh'
      ss.dependency 'YCEasyTool'
      ss.dependency 'SITheme'
      ss.dependency 'SIDefine/Pure'
      ss.dependency 'YYKit'
  end


end
