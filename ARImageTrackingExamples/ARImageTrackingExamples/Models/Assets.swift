import Foundation
import UIKit

let assets: [String: String] = [
    "SOLID-Single":"SOLID-SingleText",
    "SOLID-Dependency":"SOLID-DependencyText",
    "SOLID-interface": "SOLID-interfaceText",
    "SOLID-Liskov": "SOLID-LiskovText",
    "SOLID-open": "SOLID-openText"
]

extension String {
    func image() -> UIImage? {
        return UIImage(named: self)
    }
}
