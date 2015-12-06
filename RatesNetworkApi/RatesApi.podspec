Pod::Spec.new do |s|
  s.name         = "RatesApi"
  s.version      = '1.0.0'
  s.summary      = "Rates API"
  s.license      = { :type => 'proprietary', :file => 'LICENSE.txt' }
  s.author             = { "Ravil Garafutdinov" => "garafutdinov@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source_files = ["RatesNetworkApi/Classes/*.{h,m}",
                    "RatesNetworkApi/Objects/*.{h,m}"]
  s.requires_arc = true
  s.dependency "ReactiveCocoa", "~> 2.4.7"
  s.dependency "AFNetworking", "~> 2.5.3"
end
