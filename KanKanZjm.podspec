Pod::Spec.new do |s|

s.name         = "KanKanZjm"

s.version      = "1.0.0"

s.ios.deployment_target = '8.0'

s.summary      = "非常简单易用的轻量级编辑框。"

s.homepage     = "https://github.com/wadejones/kankanDemo"

s.license              = { :type => "MIT", :file => "LICENSE" }

s.author             = { "wadejones" => "852741019@qq.com" }

s.social_media_url   = "http://weibo.com/Jonzzs"

s.source       = { :git => "https://github.com/wadejones/kankanDemo.git", :tag => s.version }

s.source_files  = "瞰看DEMO/*.{h,m}"

s.requires_arc = true

end


