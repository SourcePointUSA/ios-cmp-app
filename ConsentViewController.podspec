Pod::Spec.new do |s|
  s.name             = 'ConsentViewController'
  s.version          = '2.0.1'
  s.summary          = 'SourcePoint\'s ConsentViewController to handle privacy consents.'
  s.homepage         = 'https://www.sourcepoint.com'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'SourcePoint' => 'contact@sourcepoint.com' }
  s.source           = { :git => 'https://github.com/SourcePointUSA/ios-cmp-app.git', :tag => s.version.to_s }
  s.swift_version    = '4.2'
  s.ios.deployment_target = '8.0'
  s.source_files = 'ConsentViewController/Classes/**/*'

  s.dependency 'ReachabilitySwift'
end
