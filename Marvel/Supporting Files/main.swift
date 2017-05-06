//
//  main.swift
//  Marvel
//
//  Created by Albert Arroyo on 6/5/17.
//  Copyright © 2017 AlbertArroyo. All rights reserved.
//

import UIKit

let appDelegateClass: AnyClass? =
    NSClassFromString("MarvelTests.TestingAppDelegate") ?? AppDelegate.self
let args = UnsafeMutableRawPointer(CommandLine.unsafeArgv)
    .bindMemory(to: UnsafeMutablePointer<Int8>.self, capacity: Int(CommandLine.argc))
UIApplicationMain(CommandLine.argc, args, nil, NSStringFromClass(appDelegateClass!))

