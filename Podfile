platform :ios, '9.0'
use_frameworks!
target ‘PicProgram’ do
    pod 'Alamofire'
    pod 'Kingfisher', '3.12.1'
    pod 'ShareSDK3/ShareSDKPlatforms/Facebook'
    pod 'ShareSDK3/ShareSDKPlatforms/Twitter'
    pod 'ShareSDK3/ShareSDKPlatforms/SinaWeibo'
    pod 'ShareSDK3/ShareSDKPlatforms/WeChat'
end

#在swift4.0项目中兼容swift3.2
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.2'
        end
    end
end
