
Pod::Spec.new do |s|
  s.name             = 'Utility'
  s.version          = '0.1.2'
  s.summary          = 'AAT.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'http://git-ma.paic.com.cn/EX-CHENDONG001/Utility_iOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'chdo002' => '1107661983@qq.com' }
  s.source           = { :git => 'http://git-ma.paic.com.cn/aat/Utility_iOS.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'Utility/Classes/**/*'
  s.public_header_files = 'Utility/Classes/**/*.h'

  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
