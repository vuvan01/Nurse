
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

target 'Nurse' do
    pod 'DropDown'
    pod 'CryptoSwift'
    pod 'BRYXBanner'
    pod 'Bond'



post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.0'
            end
        end
    end
    
end


