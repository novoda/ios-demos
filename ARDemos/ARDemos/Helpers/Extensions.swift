import SceneKit

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}

extension UIColor {
        static let buttonText = UIColor(red: 0/255,
                                        green: 0/255,
                                        blue: 0/255,
                                        alpha: 0.7)
        static let selectedButton = UIColor(red: 216/255,
                                            green: 216/255,
                                            blue: 216/255,
                                            alpha: 1.00)
        static let unSelectedButton = UIColor(red: 255/255,
                                              green: 255/255,
                                              blue: 255/255,
                                              alpha: 1.00)
        static let bottomBar = UIColor(red: 0/255,
                                       green: 0/255,
                                       blue: 0/255,
                                       alpha: 0.5)
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
