Pod::Spec.new do |s|
    s.name             = 'RxBDD'
    s.version          = '1.0.0'
    s.summary          = 'RxSwift & RxCocoa Behavior Driven Develpment Unit Test Kit'
    
    s.description      = 'BDD(Behavior Driven Develpment) Unit Test Kit for RxSwift & RxCocoa (* iOS Only)'
    
    s.homepage         = 'https://github.com/Geektree0101/RxBDD'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Geektree0101' => 'h2s1880@gmail.com' }
    s.source           = { :git => 'https://github.com/Geektree0101/RxBDD.git', :tag => s.version.to_s }
    
    s.ios.deployment_target = '9.0'
    s.frameworks       = "XCTest"
    
    s.source_files = 'RxBDD/Classes/**/*'
    
    s.dependency 'RxSwift', '~> 4.0'
    s.dependency 'RxCocoa', '~> 4.0'
    s.dependency 'RxTest', '~> 4.0'
end
