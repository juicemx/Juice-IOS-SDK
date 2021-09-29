#
# Be sure to run `pod lib lint JuiceWeb3.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JuiceWeb3'
  s.version          = '3.3.0'
  s.summary          = 'JuiceWeb3 SDK is a Swift development kit for Juice public chain provided by Juice for iOS developers.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = "JuiceWeb3 SDK is a Swift development kit for Juice public chain provided by Juice for iOS developers."

  s.homepage         = 'https://github.com/juicemx/Juice-IOS-SDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ben' => 'huangzhangcheng@matrixelements.com' }
  s.source           = { :git => 'https://github.com/juicemx/Juice-IOS-SDK.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.platform     = :ios, "9.0"

  s.source_files = 'JuiceWeb3/JuiceWeb3/Classes/**/*'
  
  s.dependency 'BigInt', '~> 5.2.0'
  s.dependency 'CryptoSwift', '~> 1.3.1'
  s.dependency 'secp256k1.swift', '~> 0.1.4'
  s.dependency 'Localize-Swift', '~> 3.1.0'
  s.swift_versions = ['5.0', '5.1', '5.2']
  
  s.pod_target_xcconfig = { 'c' => '-Owholemodule' }

end
