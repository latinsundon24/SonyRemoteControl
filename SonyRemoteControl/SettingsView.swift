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
                    Text("手机与电视需在同一局域网。若按键提示「HTTP 403/401」，说明电视开启了 IP 控制认证：要么在上方填入与电视一致的 Pre-Shared Key（电视「设置 → 网络 → IP 控制 → 认证 = 普通」时设置），要么把电视「认证」改为「关闭」，即可免 Key 直连。")
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
