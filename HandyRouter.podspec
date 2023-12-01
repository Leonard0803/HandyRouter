#
# Be sure to run `pod lib lint HandyRouter.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HandyRouter'
  s.version          = '0.1.0'
  s.summary          = 'A router for swift that can handle deeplink conveniently.'
  s.homepage         = 'https://github.com/Leonard0803/HandyRoute'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Shelley' => 'aionyiruma@163.com' }
  s.source           = { :git => 'https://github.com/Leonard0803/HandyRoute.git', :tag => s.version.to_s }
  s.ios.deployment_target = '13.0'
  s.source_files = 'Sources/**/*'
  s.frameworks = 'UIKit', 'Foundation'
  s.requires_arc     = true
  s.swift_version    = "5.0"

end
