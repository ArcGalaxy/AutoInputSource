//
//  AutoInputSourceApp.swift
//  AutoInputSource
//
//  Created by 梁波 on 2024/3/16.
//

import SwiftUI
import Carbon
import Defaults



@main
struct testmacApp: App {
    init() {
        // 创建一个 InputSourceObserver 实例以开始监听输入法切换
//        let observer = InputSourceObserver()

        // 运行主循环以保持程序运行
//        RunLoop.main.run()
        
        // 在应用程序启动时执行的代码
        print("应用程序启动")
        // 将初始化键盘名称和标识符的对照关系先初始化好
//        inputSourcesDictionary["英文"] = "com.apple.keylayout.ABC"
//        inputSourcesDictionary["中文"] = "com.apple.inputmethod.SCIM.ITABC"
//        inputSourcesDictionary["搜狗拼音"] = "com.sogou.inputmethod.pinyin"
//        inputSourcesDictionary["搜狗"] = "com.sogou.inputmethod.sogou"
//        inputSourcesDictionary["微信拼音"] = "com.tencent.inputmethod.wetype.pinyin"
//        inputSourcesDictionary["微信"] = "com.tencent.inputmethod.wetype"
        
        var inputSourcesDictionary: [String: String] = [:]
        inputSourcesDictionary["com.tencent.inputmethod.wetype.pinyin"] = "微信拼音"
//        inputSourcesDictionary["com.tencent.inputmethod.wetype"] = "微信"
        inputSourcesDictionary["com.sogou.inputmethod.sogou.pinyin"] = "搜狗拼音"
//        inputSourcesDictionary["com.sogou.inputmethod.sogou"] = "搜狗"
        inputSourcesDictionary["com.apple.inputmethod.SCIM.ITABC"] = "中文"
        inputSourcesDictionary["com.apple.keylayout.ABC"] = "英文"
        
        var inputSourcesDictionaryTmp: [String: String] = [:]
        
//        var inputSourcesDictionaryRevers: [String: String] = [:]
//
//        for (key, value) in inputSourcesDictionary {
//            inputSourcesDictionaryRevers[value] = key
//        }
        
//        inputSourcesDictionaryRevers["-"] = ""
//        DictionaryManager.shared.saveDictionary(inputSourcesDictionaryRevers, forKey: "KeyboardIdentifierRevers")

        
        // 初始化InputSourcesManager工具类
        let inputSourcesManager = InputSourcesManager.shared

        // 将输入法字典存储到UserDefaults中
        inputSourcesManager.saveInputSourcesDictionary(inputSourcesDictionary)
        
        
        // 初始化电脑输入法
        var TISInputSourcesDictionary: [String: TISInputSource] = [:]

        TISInputSourcesDictionary = getInputSourcePropertiesOfDic()
        
        let tISInputSourcesManager = TISInputSourceManager.shared
        tISInputSourcesManager.saveTISInputSourcesDictionary(TISInputSourcesDictionary)
        
//        let iMEInutSourc = tISInputSourcesManager.loadTISInputSourcesDictionary()
        
//        print("hhhhh====\(iMEInutSourc)")
        
        
        //["英文"] -> "com.apple.keylayout.ABC" -> <TSMInputSource 0x600002b38480> KB Layout: ABC (id=252)
        
//        var IMEInputSourcesDictionary: [String: TISInputSource] = [:]

        for (key, value) in TISInputSourcesDictionary {
//            print("键：\(key)，值：\(value)")
            // key 为com.apple.keylayout.ABC 然后去inputSourcesDictionary 字典中查找value
//            if let a = inputSourcesDictionary[key] {
                // 找到后重新组装
//                IMEInputSourcesDictionary[a] = value
            
            if let ipm = inputSourcesDictionary[key] {
                inputSourcesDictionaryTmp[key] = ipm
            }
            
            IMEInputSourceManager.shared.addIMEInputSource(name: key, inputSource: value)

//            }
        }
        
        DictionaryManager.shared.saveDictionary(inputSourcesDictionaryTmp, forKey: "KeyboardIdentifier")

        
//        for (key, value) in IMEInputSourcesDictionary {
//            print("键：\(key)，值：\(value)")
//        }
//        let iMEInputSourcesManager = IMEInputSourceManager.shared
//        iMEInputSourcesManager.saveIMEInputSourcesDictionary(IMEInputSourcesDictionary)
//
//
//
//        let iMEInputSourc = iMEInputSourcesManager.loadIMEInputSourcesDictionary()
//
//        print("hhhhh\(iMEInputSourc)")
        
        
    }
    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
//                .frame(minWidth: 260, maxWidth: 360, minHeight: 360, maxHeight: 460)
        }
        .commands {
            CommandMenu("App") {
                Button("Quit", action: {
                    NSApp.terminate(nil)
                })
            }
        }
    }
}



func getInputSourcePropertiesOfDic() -> [String: TISInputSource] {
    var inputSourceProperties: [String: TISInputSource] = [:]
    
    if let cfArray = TISCreateInputSourceList(nil, false)?.takeRetainedValue() {
        for cf in cfArray as NSArray {
            let inputSource = cf as! TISInputSource
            
            if let inputSourceIDPtr = TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceID) {
                let inputSourceID = Unmanaged<CFString>.fromOpaque(inputSourceIDPtr).takeUnretainedValue() as String
                inputSourceProperties[inputSourceID] = inputSource
            }
        }
    }
    
    return inputSourceProperties
}


func getInputSource(for identifier: String) -> TISInputSource? {
    if let cfArray = TISCreateInputSourceList(nil, false)?.takeRetainedValue() {
        for cf in cfArray as NSArray {
            let inputSource = cf as! TISInputSource

            if let inputSourceIDPtr = TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceID) {
                let inputSourceID = Unmanaged<CFString>.fromOpaque(inputSourceIDPtr).takeUnretainedValue() as String
                if inputSourceID == identifier {
                    return inputSource
                }
            }
        }
    }
    return nil
}





