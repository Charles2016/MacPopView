Pod::Spec.new do |s|
  s.name             = 'FAPopView'
  s.version          = '1.0.0'
  s.summary          = 'A customizable SwiftUI popover component for macOS with precise arrow alignment.'
  s.description      = <<-DESC
    FAPopView is a modern SwiftUI popover component for macOS that provides:
    - Automatic direction selection based on available screen space
    - Precise arrow alignment to button center
    - Support for both list-based and custom content modes
    - Highly customizable via FAPopViewConfiguration
    - Dark and light theme presets
    - Builder pattern for easy customization
  DESC

  s.homepage         = 'https://github.com/Charles2016/FAPopView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Charles' => 'your-email@example.com' }
  s.source           = { :git => 'https://github.com/Charles2016/FAPopView.git', :tag => s.version.to_s }

  s.platform         = :osx, '14.0'
  s.swift_version    = '5.9'

  s.source_files     = 'Sources/FAPopView/**/*.{swift,h}'
  
  s.frameworks       = 'SwiftUI', 'AppKit'
end
