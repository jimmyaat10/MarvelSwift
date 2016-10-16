source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!
inhibit_all_warnings!

target 'Marvel' do
    pod 'Alamofire'         , '~> 4.0'
    pod 'SwiftyJSON'        , '~> 3.0'
    pod 'SnapKit'           , '~> 3.0'
    pod 'Kingfisher'        , '~> 3.0'
    pod 'SVProgressHUD'     , '~> 2.0'
    pod 'DZNEmptyDataSet'   , '~> 1.8'
    pod 'RealmSwift'        , '~> 2.0'
    pod 'RxSwift'           , '3.0.0-beta.2'
    pod 'RxCocoa'           , '3.0.0-beta.2'


    target 'MarvelTests' do
        inherit! :search_paths
        pod 'Quick'
        pod 'Nimble', '~> 5.0'
    end
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end

