# 索尼电视遥控器 (Sony TV Remote)

一款通过**局域网 IP** 控制 Sony BRAVIA 电视（适配 KD-75X80J 等 Android TV）的 iOS 遥控 App。

- 包名 / Bundle ID：`sony.tv.remotecontrol`
- 显示名：索尼电视遥控器
- 技术：SwiftUI + Sony IRCC（IP Control）协议
- 编译：GitHub Actions（`macos-latest` runner），本机（Windows）只负责写代码

## 支持的按键

| 分组 | 按键 |
|------|------|
| 电源 | 电源（开/关切换） |
| 方向键 | ↑ ↓ ← →、确认(OK) |
| 顶部功能 | 返回、主页、设置、菜单、快捷选择 |
| 音量 | 音量+、静音、音量- |
| 语音 | 语音/助手 |
| 数字键盘 | 0–9 |

## 连接电视（使用前必做）

1. 让手机与电视连到**同一局域网**。
2. 电视上：`设置 → 网络 → IP 控制`，把「鉴权」设为「通常(Normal)」或「Pre-Shared Key」；若选后者，记住该 Key。
3. 查看电视局域网 IP：电视 `设置 → 网络 → 状态` 或路由器后台（如 `192.168.1.50`）。
4. App 内点右上角「⚙ 设置」，填入电视 IP；若电视用了 Pre-Shared Key，一并填入。
5. 之后点任意按键即可发送指令，底部状态栏会显示「✓」或失败原因。

> 注：电视处于完全待机（拔电级）时 HTTP 服务可能关闭，需先唤醒。KD-75X80J 为 Android TV，标准 IRCC 通常无需配对即可用。

## 技术说明

- 协议：向 `http://<TV_IP>:80/sony/ircc` 发送 SOAP `X_SendIRCC` 请求，Body 携带 IRCC Base64 指令码。
- 鉴权：若电视开启 Pre-Shared Key，请求头加 `X-Auth-PSK: <key>`。
- 明文 HTTP：因访问局域网 `http://`，Info.plist 已加 `NSAppTransportSecurity → NSAllowsArbitraryLoads`。
- 指令码集中在 `SonyRemoteControl/IRCC.swift`，如某机型个别按键无效，可在此按实际码微调。

## 本机编写 / CI

- 本地写代码：用 VS Code + Swift 扩展（`swiftlang.swift-vscode`），编辑 `SonyRemoteControl/*.swift` 与 `project.yml`。
- 本地（Mac）编译验证：`brew install xcodegen` → `make project` → `make build`。
- 自动编译：推送到 GitHub 后，`Build IPA` 工作流自动在 macOS runner 上编译并产出**未签名** IPA（Actions 页面 Artifacts 下载）。未签名 IPA 不可安装到真机，仅用于验证可编译。

## 正式签名（可安装到真机 / 上架）

当前为「先不签名」模式。要产出可安装 IPA，需准备开发者证书 `.p12` 与描述文件，通过 GitHub Secrets 注入，将工作流改为 `xcodebuild archive` + `exportArchive`。需要可告知，我可直接补全。
