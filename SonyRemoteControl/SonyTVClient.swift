import Foundation

/// 通过局域网向 Sony BRAVIA 电视发送 IRCC 指令。
struct SonyTVClient {

    /// 发送一条 IRCC 指令。
    /// - Parameters:
    ///   - code: IRCC Base64 指令码（见 `IRCC`）。
    ///   - ip: 电视局域网 IP。
    ///   - psk: Pre-Shared Key（电视若设为「Pre-Shared Key」鉴权则必填，否则留空）。
    /// - Returns: 成功返回 `nil`；失败返回错误描述。
    static func send(code: String, ip: String, psk: String) async -> String? {
        let trimmedIP = ip.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedIP.isEmpty,
              let url = URL(string: "http://\(trimmedIP):80/sony/ircc") else {
            return "电视 IP 无效"
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("\"urn:schemas-sony-com:service:IRCC:1#X_SendIRCC\"",
                         forHTTPHeaderField: "SOAPACTION")
        let trimmedPSK = psk.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedPSK.isEmpty {
            request.setValue(trimmedPSK, forHTTPHeaderField: "X-Auth-PSK")
        }
        request.httpBody = Self.soapEnvelope(for: code).data(using: .utf8)

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let http = response as? HTTPURLResponse,
               !(200...299).contains(http.statusCode) {
                return "电视返回 HTTP \(http.statusCode)"
            }
            return nil
        } catch {
            return error.localizedDescription
        }
    }

    /// 构造 IRCC SOAP 请求体
    private static func soapEnvelope(for code: String) -> String {
        """
        <?xml version="1.0"?>
        <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
          <s:Body>
            <u:X_SendIRCC xmlns:u="urn:schemas-sony-com:service:IRCC:1">
              <IRCCCode>\(code)</IRCCCode>
            </u:X_SendIRCC>
          </s:Body>
        </s:Envelope>
        """
    }
}
