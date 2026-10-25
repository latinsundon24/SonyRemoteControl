import SwiftUI

/// 设置：填写电视局域网 IP 与可选的 Pre-Shared Key
struct SettingsView: View {
    @AppStorage("tvIP") private var tvIP = ""
    @AppStorage("tvPSK") private var tvPSK = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section("电视连接（局域网 IP）") {
                    TextField("电视 IP，如 192.168.1.50", text: $tvIP)
                        .textContentType(.URL)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    TextField("Pre-Shared Key（可留空）", text: $tvPSK)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                Section("说明") {
                    Text("在电视「设置 → 网络 → IP 控制」中开启，并确认手机与电视在同一局域网。若电视要求 Pre-Shared Key，请填到上方。")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("设置")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完成") { dismiss() }
                }
            }
        }
    }
}
