//
//  TestflightDetection.swift
//  Pods
//
//  Created by Nathan Jangula on 6/6/17.
//
//

import Foundation

public class TestflightDetection
{
    private init() { }

    public static func isTestflightBuild() -> Bool
    {
        var isTestflight = Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"

        isTestflight |= Bundle.main.path(forResource: "embedded", ofType: "mobileprovision") != nil

        return isTestflight
    }
}
