platform :ios, '10.3'

target 'Shop Buddy' do
  use_frameworks!

  pod 'BarcodeScanner'
  pod 'Alamofire', '~> 4.4.0'
  pod 'PromiseKit', '~> 4.2.2'
  pod 'SnapKit', '~> 3.2.0'
  pod 'FontAwesome.swift'
  
  # Substitute for Swift 4 Codable
  pod 'AlamofireObjectMapper', '~> 4.0'
  pod 'JSONCodable', '~> 3.0.1'
    
  pod 'QuadratTouch', :git => 'https://github.com/Constantine-Fry/das-quadrat', :branch => 'fry-swift30'

  pod 'Firebase/Core'
  pod 'Firebase/AdMob'
  pod 'Fabric'
  pod 'Crashlytics'
  
  # Pods for Shop Buddy
  target 'Shop BuddyTests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['SWIFT_VERSION'] = '3.0'
          end
      end
  end

end
