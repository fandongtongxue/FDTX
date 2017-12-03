# Uncomment the next line to define a global platform for your project
 platform :ios, '8.0'

# Comment the next line if you're not using Swift and don't want to use dynamic frameworks
use_frameworks!

target 'FDTX' do
    
  #
  pod "Qiniu", "~> 7.0"

  # Pods for FDTX
  pod 'Alamofire'
  pod 'HandyJSON', '~> 1.7.2'
  pod 'Kingfisher', '~> 3.0'
  pod 'XCGLogger', '~> 4.0.0'
  pod 'NVActivityIndicatorView'
  pod 'BMPlayer'
  pod 'SnapKit', '~> 3.2.0'
  pod 'ReachabilitySwift'
  pod 'PKHUD', '~> 4.0'
  pod 'NightNight'
  pod 'IQKeyboardManagerSwift'
  pod 'KeychainAccess'
  pod 'SwiftWebVC'
  pod 'Hue'
  pod 'MediaBrowser', '~>0.4.6'
  pod 'Socket.IO-Client-Swift', '~> 11.1.3'
  pod 'Chatto', '= 3.2.0'
  pod 'ChattoAdditions', '= 3.2.0' # if you want to use the cells or the input component
  pod 'CropViewController'
  post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['SWIFT_VERSION'] = '3.2'
          end
      end
  end
end
