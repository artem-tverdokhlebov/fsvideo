platform :ios, '8.0'
use_frameworks!

def shared_frameworks
    pod 'AFNetworking', '~> 3.1'
    pod 'NSURL+QueryDictionary', '~> 1.1'
    pod 'Fabric', '~> 1.6'
    pod 'Crashlytics'
    pod 'SDWebImage', '~>3.7'
    pod 'Fuzi', '~> 0.3.0'
    pod 'UIImageColors', :git => 'https://github.com/jathu/UIImageColors.git'
    pod 'SwiftHEXColors', '~> 1.0'
    pod 'CocoaLumberjack', '~> 2.2'
    pod 'SnapKit', '~> 0.20'
    pod 'NYTPhotoViewer', '~> 1.1.0'
    pod 'IDMPhotoBrowser'
end

target 'FSVideo' do
    shared_frameworks
end

target 'FSVideo+' do
    shared_frameworks
    pod 'TCBlobDownloadSwift', :git => 'https://github.com/abodnyaUA/TCBlobDownloadSwift.git'
end

