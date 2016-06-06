import CoreGraphics


public extension CGFloat
{
    // Usage: CGFloat(90).degreesInRadians and CGFloat(M_PI).radiansInDegrees, etc
    public var radiansInDegrees: CGFloat { return self * CGFloat(180.0 / M_PI) }
    public var degreesInRadians: CGFloat { return self * CGFloat(M_PI / 180.0) }

    // Returns a uniformly distributed random CGFloat in the range [0, 1].
    public static var randomUniform01: CGFloat
    { return CGFloat(arc4random_uniform(UInt32.max)) / CGFloat(UInt32.max - 1) }

    // Returns a uniformly distributed random CGFloat in the range [min(a,b), max(a,b)].
    public static func randomUniform(a a: CGFloat, b: CGFloat) -> CGFloat
    { return a + (b - a) * CGFloat.randomUniform01 }

    // Returns a uniformly distributed random boolean.
    public static var randomBool: Bool
    { return CGFloat.randomUniform01 <= 0.5 }
}
