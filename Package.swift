// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription



#if os(Linux) && arch(arm)
let package = Package(
    name: "ScratchingSwift",
    dependencies: [.package(url: "https://github.com/pvieito/PythonKit.git",
                   .branch("master"))],
    targets: [.target(name: "ScratchingSwift",
                      dependencies: ["PiHardwareInterface",
                                     "Common",
                                     "PythonKit",
                                     "LinuxInput"]),
              .testTarget(name: "ScratchingSwiftTests",
                          dependencies: ["ScratchingSwift"]),
              .target(name: "PiHardwareInterface", 
                      dependencies: ["Common",
                                     "wiringPi",
                                     "MPU9250",
                                     "Robot"]),
              .target(name: "Common"),
              .target(name: "Robot"),
              .target(name: "LinuxInput"),
              .systemLibrary(name: "wiringPi"), 
              .systemLibrary(name: "MPU9250")]
)
#else

let package = Package(
    name: "ScratchingSwift",
    dependencies: [.package(url: "https://github.com/pvieito/PythonKit.git",
                   .branch("master"))],
    targets: [.target(name: "ScratchingSwift",
                      dependencies: ["Common", "PythonKit"]),
              .testTarget(name: "ScratchingSwiftTests",
                          dependencies: ["ScratchingSwift"]),
              .target(name: "Common"),
              .target(name: "Robot"),
              .target(name: "Graf",
                      dependencies: ["CSFML"]),
              .systemLibrary(name: "CSFML", providers: [.brew(["csfml"])])]
)

#endif
