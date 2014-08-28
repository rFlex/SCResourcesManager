Pod::Spec.new do |s|

  s.name         = "SCResourcesManager"
  s.version      = "0.1.1"
  s.summary      = "A ResourceManager that store localy and fetches resources automatically"

  s.description  = <<-DESC
		 Download video, images and any kind of resources in a one liner. Datas are saved
		 locally on the device.
                   DESC

  s.homepage     = "https://github.com/rFlex/SCRecorder"
  s.license      = 'Apache License, Version 2.0'
  s.author             = { "Simon CORSIN" => "simon@corsin.me" }
  s.platform     = :ios, '7.0'
  s.source       = { :git => "https://github.com/rFlex/SCResourcesManager.git", :tag => "v0.1.1" }
  s.source_files  = 'Library/Sources/*.{h,m}'
  s.public_header_files = 'Library/Sources/*.h'
  s.requires_arc = true

end
