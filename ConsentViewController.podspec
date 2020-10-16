Pod::Spec.new do |s|
  s.name             = 'ConsentViewController'
  s.version          = '5.3.0-beta.2'
  s.summary          = 'SourcePoint\'s ConsentViewController to handle privacy consents.'
  s.homepage         = 'https://www.sourcepoint.com'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'SourcePoint' => 'contact@sourcepoint.com' }
  s.source           = { :git => 'https://github.com/SourcePointUSA/ios-cmp-app.git', :tag => s.version.to_s }
  s.swift_version    = '5.0'
  s.ios.deployment_target = '9.0'
  s.source_files = 'ConsentViewController/Classes/**/*'
  s.resource_bundles = { 'ConsentViewController' => ['ConsentViewController/Assets/**/*', 'Pod/Classes/**/*.{storyboard,xib,xcassets,json,imageset,png}'] }
  s.resources = "ConsentViewController/**/*{.js}"
end
