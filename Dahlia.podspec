#
#  Be sure to run `pod spec lint Dahlia.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

`echo "5.0" > .swift-version`

Pod::Spec.new do |s|
  s.name         = "Dahlia"
  s.version      = "0.1"
  s.summary      = "A swift tool for photo edit"

  s.description  = <<-DESC
        Dahlia is A swift tool for photo edit
                   DESC

  s.homepage     = "https://github.com/guoyingtao/Dahlia"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Yingtao Guo" => "guoyingtao@outlook.com" }
  s.social_media_url   = "http://twitter.com/guoyingtao"
  s.platform     = :ios
  s.ios.deployment_target = '11.0'
  s.source       = { :git => "https://github.com/guoyingtao/Dahlia.git", :tag => "#{s.version}" }
  s.source_files  = "Dahlia/**/*.{h,swift}"
  s.resource_bundles = {
    "Resource" => ["Dahlia/**/*.lproj/*.strings"]
  }

end
