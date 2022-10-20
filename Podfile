#source 'https://github.com/CocoaPods/Specs.git'#官方仓库地址
#plugin 'cocoapods-pod-sign'
#skip_pod_bundle_sign # 用来跳过Xcode对bundle资源的签名

platform :ios, '13.0'
use_frameworks!

target 'Aria2' do

pod 'SwiftyUserDefaults'
pod 'SnapKit'
pod 'PKHUD'
pod 'ESPullToRefresh'
pod 'IQKeyboardManagerSwift'
pod 'PMAlertController'
pod 'Hue'
pod 'SwiftEntryKit'
#pod 'SwiftyStoreKit'
pod 'RxSwift'
pod 'RxCocoa'
pod 'Alamofire'
pod 'HandyJSON'
pod 'SwiftyJSON'
pod 'SGPagingView', '~> 2.1.0'
pod 'SQLite.swift'

end

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CODE_SIGN_IDENTITY'] = ''
         end
    end
  end
end
