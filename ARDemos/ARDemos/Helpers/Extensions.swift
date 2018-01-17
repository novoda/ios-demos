import SceneKit

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}

extension UIColor {
        static let buttonText = UIColor(red: 1/255,
                                        green: 1/255,
                                        blue: 1/255,
                                        alpha: 1.00)
        static let selectedButton = UIColor(red: 128/255,
                                            green: 216/255,
                                            blue: 223/255,
                                            alpha: 1.00)
        static let unSelectedButton = UIColor(red: 244/255,
                                              green: 253/255,
                                              blue: 174/255,
                                              alpha: 1.00)
        static let bottomBar = UIColor(red: 54/255,
                                       green: 0/255,
                                       blue: 111/255,
                                       alpha: 1.00)
}

protocol Loopable {
    var allProperties: [String: Any] { get }
}
extension Loopable {
    var allProperties: [String: Any] {
        var result = [String: Any]()
        Mirror(reflecting: self).children.forEach { child in
            if let property = child.label {
                result[property] = child.value
            }
        }
        return result
    }
}
