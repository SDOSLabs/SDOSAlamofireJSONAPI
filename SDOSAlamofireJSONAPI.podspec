@version = "1.0.0"
Pod::Spec.new do |spec|
    spec.platform     = :ios, '10.0'
    spec.name         = 'SDOSAlamofireJSONAPI'
    spec.authors      = 'SDOS'
    spec.version      = @version
    spec.license      = { :type => 'MIT' }
    spec.homepage     = 'https://github.com/SDOSLabs/SDOSAlamofireJSONAPI'
    spec.summary      = 'Librería de integración con Alamofire'
    spec.source       = { :git => "https://github.com/SDOSLabs/SDOSAlamofireJSONAPI.git", :tag => "#{spec.version}" }
    spec.framework    = ['Foundation']
    spec.requires_arc = true

    spec.default_subspec = 'Core'

    spec.subspec 'Core' do |s1|
        s1.preserve_paths = 'src/Classes/JSONAPI/*'
        s1.source_files = ['src/Classes/JSONAPI/*{*.swift}', 'src/Classes/JSONAPI/**/*{*.swift}']
    end

    spec.dependency 'SDOSAlamofire', '~> 2.0.0'
    spec.dependency 'Japx/Codable'#, :tag => '3.1.0', :git => 'https://github.com/SDOSLabs/Japx.git'
end
