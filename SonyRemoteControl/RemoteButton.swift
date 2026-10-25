import SwiftUI

/// 通用遥控按钮
struct RemoteButton: View {
    let title: String
    var symbol: String? = nil
    var color: Color = .accentColor
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                if let symbol = symbol {
                    Image(systemName: symbol)
                        .font(.title3)
                }
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}
