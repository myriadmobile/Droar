#
# Be sure to run `pod lib lint Droar.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Droar'
  s.version          = '1.1.2'
  s.summary          = 'A runtime debugging tool for iOS.'

  s.description      = <<-DESC
Droar is a useful tool for displaying runtime information and settings, useful for debugging.
                       DESC

  s.homepage         = 'www.myriadmobile.com'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'myriadmobile' => 'developer@myriadmobile.com' }
  s.source           = { :git => 'https://github.com/myriadmobile/Droar.git', :branch => 'master', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'Droar/Classes/**/*'
  
  s.resource_bundles = {
    'Droar' => ['Droar/Classes/**/*.{xib,png,jpeg,jpg,txt}']
  }

  s.frameworks = 'UIKit'
  s.dependency 'SDVersion'
end
