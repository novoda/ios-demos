import Foundation
import UIKit

extension String {
    func image() -> UIImage? {
        return UIImage(named: self)
    }
}

struct ImageOrientation {
    let text: String
}

extension ImageOrientation {
    static let vertical = ImageOrientation(text: "Vertical")
    static let horizontal = ImageOrientation(text: "Text")
}
