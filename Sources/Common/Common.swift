import Foundation

public extension Comparable 
{
  func clamped(to limits: ClosedRange<Self>) -> Self 
  {
    return min(max(self, limits.lowerBound), limits.upperBound)
  }
}

public extension String
{
  func trim() -> String
  {
    return self.trimmingCharacters(in: CharacterSet.controlCharacters)
  }
}
