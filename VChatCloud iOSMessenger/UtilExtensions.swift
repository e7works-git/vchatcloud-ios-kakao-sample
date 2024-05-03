import Foundation
import SwiftUI
import VChatCloudSwiftSDK

extension Color {
    init(hex: UInt, hexAlpha: Double? = nil, decAlpha: Double? = nil) {
        var alpha: Double
        if hexAlpha != nil {
            alpha = hexAlpha! / 0xff
        } else if decAlpha != nil {
            alpha = decAlpha!
        } else {
            alpha = 1
        }
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

extension Dictionary {
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return self.description
        }
    }
    
    func printJson() {
        print(json)
    }
}

extension Collection where Iterator.Element == [String: Any] {
    func toJSONString(options: JSONSerialization.WritingOptions = []) -> String {
        if let arr = self as? [[String:AnyObject]],
            let dat = try? JSONSerialization.data(withJSONObject: arr, options: options),
            let str = String(data: dat, encoding: String.Encoding.utf8) {
            return str
        }
        return "[]"
    }
}

extension Data {
    var jsonToDict: [String: Any] {
        do {
            let dictionary = try JSONSerialization.jsonObject(with: self, options: []) as? [String: Any]
            return dictionary!
        } catch {
            debugPrint("this is not valid json: \(error)")
            debugPrint("original string >>> \(self.description)")
            return [:]
        }
    }
}

extension String {
    var jsonToDict: Any {
        if let jsonData = self.data(using: .utf8) {
            do {
                let dictionary = try JSONSerialization.jsonObject(with: jsonData, options: [])
                return dictionary
            } catch {
                debugPrint("this is not valid json: \(self)")
                return [:] as [String: Any]
            }
        }
        return [:] as [String: Any]
    }
}

extension Date {
    init(fromServerTime: Date) {
        let SERVER_TIMEZONE_OFFSET = -9 * 60 * 60
        self = fromServerTime.addingTimeInterval(TimeInterval(SERVER_TIMEZONE_OFFSET))
    }
    
    func isSameDay(_ date: Date?) -> Bool {
        if let param = date {
            return self.formatted(.dateTime.year().month().day()) == param.formatted(.dateTime.year().month().day())
        } else {
            return false
        }
    }
}

extension Color {
    struct Theme {
        static var background = Color(hex: 0xdfe6f2)
    }
}

extension ChatroomViewModel {
    var personString: String {
        get {
            String(format: "%03d", arguments: [self.persons])
        }
    }
    
    var likeString: String {
        get {
            String(format: "%03d", arguments: [self.like])
        }
    }
}

// CachedAsyncImage set cache size
extension URLCache {
    static let imageCache = URLCache(memoryCapacity: 512_000_000, diskCapacity: 20_000_000_000)
}
