import SwiftUI

struct ContentView: View {
    @AppStorage("tvIP") private var tvIP = ""
    @AppStorage("tvPSK") private var tvPSK = ""
    @State private var status = "未连接"
    @State private var showingSettings = false
    @State private var busy = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 18) {
                    // 连接状态栏
                    HStack {
                        Image(systemName: tvIP.isEmpty ? "wifi.exclamationmark" : "wifi")
                        Text(tvIP.isEmpty ? "请先设置电视 IP" : "电视：\(tvIP)")
                        Spacer()
                        Button { showingSettings = true } label: {
                            Image(systemName: "gearshape")
                        }
                    }
                    .font(.subheadline)
                    .padding(.horizontal)

                    Text(status)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    // 电源
                    if let cmd = IRCC.all.first(where: { $0.group == .power }) {
                        RemoteButton(title: cmd.title, symbol: cmd.symbol,
                                     color: .red, action: { press(cmd) })
                            .padding(.horizontal)
                    }

                    // 方向键
                    dpad

                    // 顶部功能键
                    grid(for: .top, columns: 5)

                    // 音量
                    HStack(spacing: 12) {
                        ForEach(IRCC.all.filter { $0.group == .volume }) { cmd in
                            RemoteButton(title: cmd.title, symbol: cmd.symbol, action: { press(cmd) })
                        }
                    }
                    .padding(.horizontal)

                    // 语音
                    if let cmd = IRCC.all.first(where: { $0.group == .voice }) {
                        RemoteButton(title: cmd.title, symbol: cmd.symbol,
                                     color: .purple, action: { press(cmd) })
                            .padding(.horizontal)
                    }

                    // 数字键盘
                    grid(for: .number, columns: 3)

                    Spacer(minLength: 20)
                }
                .padding(.vertical)
            }
            .navigationTitle("索尼电视遥控器")
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
    }

    // 方向键：上 / (左 确认 右) / 下
    private var dpad: some View {
        let up    = IRCC.all.first { $0.group == .dpad && $0.code == IRCC.up }!
        let down  = IRCC.all.first { $0.group == .dpad && $0.code == IRCC.down }!
        let left  = IRCC.all.first { $0.group == .dpad && $0.code == IRCC.left }!
        let right = IRCC.all.first { $0.group == .dpad && $0.code == IRCC.right }!
        let ok    = IRCC.all.first { $0.group == .dpad && $0.code == IRCC.confirm }!
        return VStack(spacing: 10) {
            RemoteButton(title: up.title, symbol: up.symbol, action: { press(up) })
            HStack(spacing: 10) {
                RemoteButton(title: left.title, symbol: left.symbol, action: { press(left) })
                RemoteButton(title: ok.title, symbol: ok.symbol, color: .green, action: { press(ok) })
                RemoteButton(title: right.title, symbol: right.symbol, action: { press(right) })
            }
            RemoteButton(title: down.title, symbol: down.symbol, action: { press(down) })
        }
        .padding(.horizontal)
    }

    private func grid(for group: RemoteGroup, columns: Int) -> some View {
        let items = IRCC.all.filter { $0.group == group }
        let cols = Array(repeating: GridItem(.flexible()), count: columns)
        return LazyVGrid(columns: cols, spacing: 10) {
            ForEach(items) { cmd in
                RemoteButton(title: cmd.title, symbol: cmd.symbol, action: { press(cmd) })
            }
        }
        .padding(.horizontal)
    }

    private func press(_ cmd: RemoteCommand) {
        guard !tvIP.trimmingCharacters(in: .whitespaces).isEmpty else {
            status = "请先在右上角「设置」中填写电视 IP"
            return
        }
        guard !busy else { return }
        busy = true
        status = "发送：\(cmd.title)…"
        Task {
            defer { busy = false }
            let err = await SonyTVClient.send(code: cmd.code, ip: tvIP, psk: tvPSK)
            if let err = err {
                status = "\(cmd.title) 失败：\(err)"
            } else {
                status = "\(cmd.title) ✓"
            }
        }
    }
}
