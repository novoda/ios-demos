import UIKit


public extension UIColor
{
    static func randomColor(alpha: CGFloat = 1.0) -> UIColor
    {
        let r = CGFloat.randomUniform01
        let g = CGFloat.randomUniform01
        let b = CGFloat.randomUniform01
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
}
