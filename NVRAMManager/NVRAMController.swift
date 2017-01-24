//
//  NVRAMController.swift
//  NVRAMManager
//
//  Created by yekki on 2017/1/23.
//  Copyright © 2017年 yekki. All rights reserved.
//

import Foundation
import IOKit
import Foundation

let masterPort = IOServiceGetMatchingService(kIOMasterPortDefault, nil)
let gOptionsRef = IORegistryEntryFromPath(masterPort, "IODeviceTree:/options")
let serviceIOPlatformExpertDevice = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice"))

class NVRAMController {
    
    func setOFVariable(name: String, value: String) {
        
        let nameRef = CFStringCreateWithCString(kCFAllocatorDefault, name, CFStringBuiltInEncodings.UTF8.rawValue)
        
        // As CFString (Switched to NSData due to issues with trailing %00 characters in values after reboot)
        //let valueRef = CFStringCreateWithCString(kCFAllocatorDefault, value, CFStringBuiltInEncodings.UTF8.rawValue)
        
        // CFData is “toll-free bridged” with its Cocoa Foundation counterpart, NSData.
        let valueRef = value.data(using: String.Encoding.ascii)
        
        IORegistryEntrySetCFProperty(gOptionsRef, nameRef, valueRef as CFTypeRef!)
    }
    
    func getOFVariable(name: String) -> String {
        
        let nameRef = CFStringCreateWithCString(kCFAllocatorDefault, name, CFStringBuiltInEncodings.UTF8.rawValue)
        
        let valueRef = IORegistryEntryCreateCFProperty(gOptionsRef, nameRef, kCFAllocatorDefault, 0)
        
        if (valueRef != nil) {
            // Read as NSData
            if let data = valueRef?.takeUnretainedValue() as? NSData {
                return NSString(data: data as Data, encoding: String.Encoding.ascii.rawValue)! as String
            }
            // Read as String
            return valueRef!.takeRetainedValue() as! String
        } else {
            return ""
        }
    }
    
    func printOFVariables() {
        
        let dict = UnsafeMutablePointer<Unmanaged<CFMutableDictionary>?>.allocate(capacity: 1)
        let result = IORegistryEntryCreateCFProperties(gOptionsRef, dict, kCFAllocatorDefault, 0)
        
        if let resultDict = dict.pointee?.takeUnretainedValue() as Dictionary? {
            print(resultDict, result)
        }
    }
    
    func getAllVariables() -> Array<(String, String)> {
        
        let dict = UnsafeMutablePointer<Unmanaged<CFMutableDictionary>?>.allocate(capacity: 1)
        
        IORegistryEntryCreateCFProperties(gOptionsRef, dict, kCFAllocatorDefault, 0)
        
        var vars = Array<(String, String)>()
        
        if let resultDict = dict.pointee?.takeUnretainedValue() as Dictionary? {
            
            for (key, value) in resultDict {
                
                let value = NSString(data: value as! Data, encoding: String.Encoding.ascii.rawValue)! as String
                vars.append((key as! String, value))
            }
        }
        
        return vars
    }
    
    func getPlatformAttributeForKey(key: String) -> String {
        
        let nameRef = CFStringCreateWithCString(kCFAllocatorDefault, key, CFStringBuiltInEncodings.UTF8.rawValue)
        
        let valueRef = IORegistryEntryCreateCFProperty(serviceIOPlatformExpertDevice, nameRef, kCFAllocatorDefault, 0)
        
        // Read as NSData
        if let data = valueRef?.takeUnretainedValue() as? NSData {
            return NSString(data: data as Data, encoding: String.Encoding.ascii.rawValue)! as String
        } else {
            // Read as String
            return valueRef!.takeRetainedValue() as! String
        }
    }
    
    func clearOFVariable(key: String) {
        
        IORegistryEntrySetCFProperty(gOptionsRef, kIONVRAMDeletePropertyKey as CFString!, key as CFTypeRef!)
    }
    
}
