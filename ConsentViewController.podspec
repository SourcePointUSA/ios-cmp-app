Pod::Spec.new do |s|
  s.name = 'ConsentViewController'
  s.version = '7.10.1'
  s.summary = 'SourcePoint\'s ConsentViewController to handle privacy consents.'
  s.static_framework = true
  s.homepage = 'https://www.sourcepoint.com'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { 'SourcePoint' => 'contact@sourcepoint.com' }
  s.source = { :git => 'https://github.com/SourcePointUSA/ios-cmp-app.git', :tag => s.version.to_s }
  s.swift_version = '5.1'
  s.source_files = 'ConsentViewController/Classes/**/*'
  s.dependency 'SPMobileCore', '0.1.9'
  s.ios.deployment_target = '10.0'
  s.ios.exclude_files = 'ConsentViewController/Classes/Views/tvOS'
  s.tvos.deployment_target = '12.0'
  s.tvos.exclude_files = 'ConsentViewController/Classes/Views/iOS'
  s.tvos.dependency 'Down', '~> 0.11.0'
  s.ios.resource_bundles = {
      'ConsentViewController' => [
          'ConsentViewController/Assets/**/*',
          'Pod/Classes/**/*.{xcprivacy,storyboard,xib,xcassets,json,imageset,png,js}'
      ]
  }
  s.tvos.resource_bundles = {
      'ConsentViewController' => [
          'ConsentViewController/Assets/**/*',
          'ConsentViewController/Classes/**/*.{xcprivacy,storyboard,xib,xcassets,json,imageset,png,js}',
          'Pod/Classes/**/*.{xcprivacy,storyboard,xib,xcassets,json,imageset,png,js}'
      ]
  }
  s.resources = "ConsentViewController/**/*.{js,json,png}"
  s.info_plist = {
      'SPEnv' => 'prod'
  }
end
