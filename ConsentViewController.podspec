Pod::Spec.new do |s|
  s.name             = 'ConsentViewController'
  s.version          = '7.8.0'
  s.summary          = 'SourcePoint\'s ConsentViewController to handle privacy consents.'
  s.homepage         = 'https://www.sourcepoint.com'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'SourcePoint' => 'contact@sourcepoint.com' }
  s.source           = { :git => 'https://github.com/SourcePointUSA/ios-cmp-app.git', :tag => s.version.to_s }
  s.swift_version    = '5.9'

  s.ios.deployment_target  = '10.0'
  s.tvos.deployment_target = '10.0'

  # Main wrapper target 
  s.subspec 'ConsentViewController' do |sp|
    sp.source_files = 'Wrapper/**/*.{swift,h,m}'
    sp.dependency 'ConsentViewController/ConsentViewControllerCore'
    sp.tvos.dependency 'ConsentViewController/ConsentViewControllerTvOS'
  end

  # Core logic
  s.subspec 'ConsentViewControllerCore' do |sp|
    sp.source_files = 'ConsentViewController/**/*.{swift,h,m}'
    sp.exclude_files = [
      'Wrapper/**/*',
      'ConsentViewController/Classes/Views/tvOS/tvOSTarget/**/*',
      'ConsentViewController/Classes/Views/iOS/**/*',
      'ConsentViewController/Assets/javascript/SPJSReceiver.spec.js',
      'ConsentViewController/Assets/javascript/jest.config.json'
    ]
    sp.resources = [
      'ConsentViewController/Assets/images/**/*',
      'ConsentViewController/Assets/javascript/SPJSReceiver.js'
    ]
    sp.dependency 'SPMobileCore', '0.1.4'
    sp.tvos.dependency 'Down', '~> 0.11.0'
  end

  # tvOS-specific resources
  s.subspec 'ConsentViewControllerTvOS' do |sp|
    sp.source_files = 'ConsentViewController/Classes/Views/tvOS/tvOSTarget/**/*.{swift,h,m}'
    sp.resources = [
      'ConsentViewController/Classes/Views/tvOS/tvOSTarget/Xibs/**/*.{xib,storyboard}'
    ]
    sp.dependency 'ConsentViewController/ConsentViewControllerCore'
  end

  s.default_subspec = 'ConsentViewController'

  s.info_plist = {
    'SPEnv' => 'prod'
  }
end
