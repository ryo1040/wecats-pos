# Uncomment the next line to define a global platform for your project
platform :ios, '16.6'

target 'wecatspos' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for wecatspos
  pod 'R.swift', '~> 6.1.0'
  pod 'Moya/RxSwift', '~> 15.0.0'
  pod 'HolidayJp', '~> 0.1'

  target 'wecatsposTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'wecatsposUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end
  end
end