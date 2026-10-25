# 本机（macOS）辅助命令。Windows 无 make，仅供本地调试使用。
.PHONY: project build clean

project:
	xcodegen generate

build:
	xcodebuild build -project SonyRemoteControl.xcodeproj -scheme SonyRemoteControl -sdk iphoneos -configuration Release CODE_SIGNING_ALLOWED=NO CODE_SIGN_IDENTITY=""

clean:
	rm -rf SonyRemoteControl.xcodeproj build DerivedData
