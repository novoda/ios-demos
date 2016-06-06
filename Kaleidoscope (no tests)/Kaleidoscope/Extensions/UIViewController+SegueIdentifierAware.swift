import UIKit

protocol SegueIdentifierAware
{
    associatedtype SegueIdentifier: RawRepresentable
}

extension SegueIdentifierAware where Self: UIViewController, SegueIdentifier.RawValue == String
{
    func performSegueWithIdentifier(segueIdentifier: SegueIdentifier, sender: AnyObject?)
    { performSegueWithIdentifier(segueIdentifier.rawValue, sender: sender) }

    func segueIdentifierForSegue(segue: UIStoryboardSegue) -> SegueIdentifier
    {
        guard let
            identifier = segue.identifier,
            segueIdentifier = SegueIdentifier(rawValue: identifier)
            else { fatalError("Invalid segue identifier: '\(segue.identifier)'") }
        return segueIdentifier
    }
}
