Pod::Spec.new do |s|
  s.name             = 'ConsentWebView'
  s.version          = '0.1.2'
  s.summary          = 'SourcePoint\'s ConsentWebView to handle privacy consents.'
  s.homepage         = 'https://www.sourcepoint.com'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'SourcePoint' => 'contact@sourcepoint.com' }
  s.source           = { :git => 'https://github.com/SourcePointUSA/ios-cmp-app.git', :tag => s.version.to_s }
  s.swift_version    = '4.2'
  s.ios.deployment_target = '8.0'
  s.source_files = 'Classes/**/*'
end
