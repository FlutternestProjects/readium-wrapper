# Uncomment the next line to define a global platform for your project
 platform :ios, '14.0'

target 'ReadiumWrapper' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'GRDB.swift', '~> 5.0'
  pod 'Kingfisher', '~> 5.0'
  pod 'MBProgressHUD', '~> 1.0'
  pod 'SwiftSoup', '~> 2.7.0'


  pod 'ReadiumShared', podspec: 'https://raw.githubusercontent.com/readium/swift-toolkit/develop/Support/CocoaPods/ReadiumShared.podspec'
  pod 'ReadiumStreamer', podspec: 'https://raw.githubusercontent.com/readium/swift-toolkit/develop/Support/CocoaPods/ReadiumStreamer.podspec'
  pod 'ReadiumNavigator', podspec: 'https://raw.githubusercontent.com/readium/swift-toolkit/develop/Support/CocoaPods/ReadiumNavigator.podspec'
  pod 'ReadiumAdapterGCDWebServer', podspec: 'https://raw.githubusercontent.com/readium/swift-toolkit/develop/Support/CocoaPods/ReadiumAdapterGCDWebServer.podspec'
  pod 'ReadiumOPDS', podspec: 'https://raw.githubusercontent.com/readium/swift-toolkit/develop/Support/CocoaPods/ReadiumOPDS.podspec'
  pod 'ReadiumInternal', podspec: 'https://raw.githubusercontent.com/readium/swift-toolkit/develop/Support/CocoaPods/ReadiumInternal.podspec'

  # Required for R2Streamer and ReadiumAdapterGCDWebServer.
  pod 'ReadiumGCDWebServer', podspec: 'https://raw.githubusercontent.com/readium/GCDWebServer/master/GCDWebServer.podspec'

  # Pods for ReadiumWrapper

  target 'ReadiumWrapperTests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.generated_projects.each do |project|
      project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
          end
      end
  end
end

