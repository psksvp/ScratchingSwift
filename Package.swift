// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

#if os(Linux) && arch(arm)
let package = Package(
    name: "ScratchingSwift",
    dependencies: [],
    targets: [.target(name: "ScratchingSwift",
                      dependencies: ["PiHardwareInterface", "Common"]),
              .testTarget(name: "ScratchingSwiftTests",
                          dependencies: ["ScratchingSwift"]),
              .target(name: "PiHardwareInterface", 
                      dependencies: ["Common", "wiringPi", "MPU9250", "Robot"]),             
              .target(name: "Common"),
              .target(name: "Robot"),
              .systemLibrary(name: "wiringPi"), 
              .systemLibrary(name: "MPU9250")]
)
#else

let package = Package(
    name: "ScratchingSwift",
    dependencies: [],
    targets: [.target(name: "ScratchingSwift",
                      dependencies: ["Common"]),
              .testTarget(name: "ScratchingSwiftTests",
                          dependencies: ["ScratchingSwift"]),
              .target(name: "Common"),
              .target(name: "Robot"),
              .target(name: "Graf",
                      dependencies: ["CSFML"]),
              .systemLibrary(name: "CSFML", providers: [.brew(["csfml"])])]
)

#endif
