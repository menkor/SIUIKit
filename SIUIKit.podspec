#
# Be sure to run `pod lib lint SIUIKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SIUIKit'
  s.version          = '0.1.2'
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
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SIUIKit/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SIUIKit' => ['SIUIKit/Assets/*.png']
  # }
  s.subspec 'Font' do |ss|
    ss.source_files = './Classes/SIFont/*'
	ss.public_header_files = './Classes/SIFont/*.h'
  end
  
  s.subspec 'Color' do |ss|
    ss.source_files = './Classes/SIColor/*'
	ss.public_header_files = './Classes/SIColor/*.h'
  end

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
