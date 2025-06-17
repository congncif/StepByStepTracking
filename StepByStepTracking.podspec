Pod::Spec.new do |s|
  s.name = "StepByStepTracking"
  s.version = "0.1.0"
  s.swift_versions = "5"
  s.summary = "[StepTracking] Track code behavior follow step by step."

  s.description = <<-DESC
  Core Tracking to implement tracking layer which independent with Analytics agencies.
  Your flow will be abstracted to steps. Each step has some default values. All events was sent in step included available values of the step.
  DESC

  s.homepage = "https://github.com/congncif/StepByStepTracking"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { "NGUYEN CHI CONG" => "congnc.if@gmail.com" }
  s.source = { :git => "https://github.com/congncif/StepByStepTracking.git", :tag => s.version.to_s }
  s.social_media_url = "https://twitter.com/congncif"

  s.ios.deployment_target = "14.0"

  s.default_subspec = "Default"

  s.subspec "Default" do |co|
    co.dependency "StepByStepTracking/Core"
  end

  s.subspec "Core" do |co|
    co.source_files = "Sources/**/*.swift"
  end
end
