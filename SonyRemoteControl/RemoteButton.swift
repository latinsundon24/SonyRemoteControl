import SwiftUI

/// 通用遥控按钮
struct RemoteButton: View {
    let title: String
    var symbol: String? = nil
    var color: Color = .accentColor
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                if let symbol = symbol {
                    Image(systemName: symbol)
                        .font(.title2)
                }
                Text(title)
                    .font(.callout)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity, minHeight: 64)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .cornerRadius(16)
        }
        .buttonStyle(.plain)
    }
}
