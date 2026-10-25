import Foundation

/// 按键分组，用于界面布局
enum RemoteGroup {
    case power, dpad, top, volume, voice, number
}

/// 遥控指令定义（标题 + 图标 + IRCC 码 + 分组）
struct RemoteCommand: Identifiable {
    var id: String { code }
    let title: String
    let symbol: String?   // SF Symbol；数字键为 nil
    let code: String      // Sony IRCC Base64 指令码
    let group: RemoteGroup
}

/// Sony BRAVIA（Android TV，如 KD-75X80J）IRCC 指令码。
/// 端点：POST http://<TV_IP>:80/sony/ircc （SOAP）
/// 说明：部分机型需在电视「设置 → 网络 → IP 控制」开启；
///       若选「Pre-Shared Key」鉴权，则在 App 设置里填 PSK。
enum IRCC {
    // 电源 / 电视按键
    static let power       = "AAAAAQAAAAEAAAAVAw=="   // 电源（开/关切换）

    // 方向键
    static let up          = "AAAAAQAAAAEAAAB0Aw=="
    static let down        = "AAAAAQAAAAEAAAB1Aw=="
    static let left        = "AAAAAQAAAAEAAAA0Aw=="
    static let right       = "AAAAAQAAAAEAAAAzAw=="
    static let confirm     = "AAAAAQAAAAEAAABlAw=="   // 确认 / OK

    // 顶部功能键
    static let back        = "AAAAAgAAAJcAAAAjAw=="   // 返回
    static let home        = "AAAAAQAAAAEAAABgAw=="   // 主页
    static let settings    = "AAAAAgAAAJcAAAA2Aw=="   // 设置（Options）
    static let input       = "AAAAAgAAABEAAAAAA"      // 输入选择（Input 源切换）

    // 电视键：切到电视广播输入（TV / テレビ）
    static let tv          = "AAAAAQAAAAEAAAAkAw=="

    // 音量
    static let volumeUp    = "AAAAAQAAAAEAAAASAw=="
    static let volumeDown  = "AAAAAQAAAAEAAAATAw=="
    static let mute        = "AAAAAQAAAAEAAAAUAw=="

    // 语音
    static let voice       = "AAAAAgAAABoAAAB9Aw=="    // 语音/助手（best-effort）

    // 数字键 0-9
    static let num0 = "AAAAAQAAAAEAAABwAw=="
    static let num1 = "AAAAAQAAAAEAAAAAAw=="
    static let num2 = "AAAAAQAAAAEAAAABAw=="
    static let num3 = "AAAAAQAAAAEAAAACAw=="
    static let num4 = "AAAAAQAAAAEAAAADAw=="
    static let num5 = "AAAAAQAAAAEAAAAEAw=="
    static let num6 = "AAAAAQAAAAEAAAAFAw=="
    static let num7 = "AAAAAQAAAAEAAAAGAw=="
    static let num8 = "AAAAAQAAAAEAAAAHAw=="
    static let num9 = "AAAAAQAAAAEAAAAIAw=="

    /// 界面所需的全部按键（顺序即布局顺序）
    static let all: [RemoteCommand] = [
        .init(title: "电源", symbol: "power", code: power, group: .power),
        .init(title: "电视", symbol: "tv",    code: tv,    group: .power),

        .init(title: "↑",  symbol: "chevron.up",    code: up,      group: .dpad),
        .init(title: "←",  symbol: "chevron.left",  code: left,    group: .dpad),
        .init(title: "OK", symbol: "checkmark.circle", code: confirm, group: .dpad),
        .init(title: "→",  symbol: "chevron.right", code: right,   group: .dpad),
        .init(title: "↓",  symbol: "chevron.down",  code: down,    group: .dpad),

        .init(title: "返回", symbol: "arrow.uturn.left", code: back,     group: .top),
        .init(title: "主页", symbol: "house",            code: home,     group: .top),
        .init(title: "设置", symbol: "gearshape",        code: settings, group: .top),
        .init(title: "输入", symbol: "rectangle.on.rectangle", code: input, group: .top),

        .init(title: "音量-", symbol: "volume.down", code: volumeDown, group: .volume),
        .init(title: "静音",  symbol: "speaker.slash", code: mute,      group: .volume),
        .init(title: "音量+", symbol: "volume.up",   code: volumeUp,   group: .volume),

        .init(title: "语音", symbol: "mic", code: voice, group: .voice),

        .init(title: "1", symbol: nil, code: num1, group: .number),
        .init(title: "2", symbol: nil, code: num2, group: .number),
        .init(title: "3", symbol: nil, code: num3, group: .number),
        .init(title: "4", symbol: nil, code: num4, group: .number),
        .init(title: "5", symbol: nil, code: num5, group: .number),
        .init(title: "6", symbol: nil, code: num6, group: .number),
        .init(title: "7", symbol: nil, code: num7, group: .number),
        .init(title: "8", symbol: nil, code: num8, group: .number),
        .init(title: "9", symbol: nil, code: num9, group: .number),
        .init(title: "0", symbol: nil, code: num0, group: .number),
    ]
}
