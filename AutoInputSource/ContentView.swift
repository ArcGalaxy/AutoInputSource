//
//  ContentView.swift
//  AutoInputSource
//
//  Created by 梁波 on 2024/3/16.
//

import Carbon
import Defaults
import SwiftUI

//typealias InputSourceIdentifier = TISInputSource

struct ContentView: View {
  @ObservedObject var applicationObserver = ApplicationObserver()

  @State private var isi: TISInputSource?

  @State var inputSourcesDictionary: [String: TISInputSource] = [:]

  @State var inputSources: [TISInputSource] = []
    

  var body: some View {
      VStack {
          UserAppConfig()
          
          HStack {
              Text("当前应用: \(applicationObserver.currentApplication?.localizedName ?? "Unknown")")
                  .padding()
              Text("作者邮箱: ash_mica@163.com")
          }
      }
  }
}

class ApplicationObserver: ObservableObject {
  @Published var currentApplication: NSRunningApplication?
  private var workspaceNotification: NSObjectProtocol?

  init() {

    self.workspaceNotification = NSWorkspace.shared.notificationCenter.addObserver(
      forName: NSWorkspace.didActivateApplicationNotification, object: nil, queue: .main
    ) { [weak self] notification in
      self?.currentApplication =
        notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication
                  self?.switchInputMethodIfNeeded() // 在这里调用切换输入法的方法

    }
  }

  private func switchInputMethodIfNeeded() {
    guard let currentApplication = currentApplication else { return }

    var userAppImeConfig: [String: String] = [:]
    
    if let userAppImeConfigTmp: [String: String] = DictionaryManager.shared.loadDictionary(
      forKey: "UserAppImeConfigDictionary")
    {
      print("userAppImeConfig1: \(userAppImeConfigTmp)")
      userAppImeConfig = userAppImeConfigTmp
    } else {
      print("No userAppImeConfig info found.")
    }

    // 根据当前应用切换输入法
    if let currentApp = currentApplication.bundleIdentifier,
      let cApp = userAppImeConfig[currentApp]
    {
        print("当前应用：\(currentApp)")

      if let inputSource = IMEInputSourceManager.shared.getIMEInputSource(name: cApp) {
        print("======")
        print(inputSource)
        //                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        // Perform other operations here
        if let currentInputSource = getCurrentInputSource() {
          print("当前输入法是：切换前\(currentInputSource)")
          //                isi = currentInputSource
        } else {
          print("无法获取当前输入法")
        }

//        if let defaultInputSource = getDefaultInputSource() {
//          TISSelectInputSource(defaultInputSource)
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
//            if let defaultInputSource = getDefaultInputSource() {
//                      TISSelectInputSource(defaultInputSource)
//                    }
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {

                setInputSource(inputSource: inputSource)
                
//                activateApplication(app: "com.tencent.xinWeChat")
//                activateApplication(app: currentApp)
            }
//        }

        //                simulateClickOnNavigationBar()

        if let currentInputSource1 = TISCopyCurrentKeyboardInputSource()?.takeRetainedValue() {
          TISSelectInputSource(currentInputSource1)
        }
        if let currentInputSource = getCurrentInputSource() {
          print("当前输入法是：切换后\(currentInputSource)")
          //                isi = currentInputSource
        } else {
          print("无法获取当前输入法")
        }

        //                }
      }

    } else {

    }

    // 根据当前应用切换输入法
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {

    if 1 == 1 {
      return
    }
    if currentApplication.bundleIdentifier == "com.microsoft.VSCode" {

      //                if let inputSource = IMEInputSourceManager.shared.getIMEInputSource(name: "com.apple.keylayout.ABC") {
      //
      //                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      //                        // Perform other operations here
      //                        TISSelectInputSource(inputSource)
      //                    }
      //
      //
      //
      //                } else  {
      //                     print("无法加载输入法字典")
      //                }
      //

      if let inputsource = getInputSource(for: "com.apple.keylayout.ABC") {
        //                    DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {

        //                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        //                        TISSelectInputSource(inputsource)
        //
        //                    }
        DispatchQueue.global().async {
          // 在后台执行的任务
          print("在后台执行的任务")

          DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // 在主线程更新 UI 或执行其他与 UI 相关的操作
            print("在主线程执行 UI 相关的操作")
            TISSelectInputSource(inputsource)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
              // 在主线程更新 UI 或执行其他与 UI 相关的操作
              print("在主线程执行 UI 相关的操作")

              if let inputsource = getInputSource(for: "com.apple.keylayout.ABC") {

                TISSelectInputSource(inputsource)
              }
            }
          }
        }
        //                    }

        //                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        //                        TISSelectInputSource(inputsource)
        //                    }
      }

    } else if currentApplication.bundleIdentifier == "com.tencent.xinWeChat" {
      //                if let inputSource = IMEInputSourceManager.shared.getIMEInputSource(name: "com.apple.inputmethod.SCIM.ITABC") {
      //                    // 使用 inputSource
      //                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      //                           // Perform other operations here
      //                        TISSelectInputSource(inputSource)
      //                    }
      //
      //
      //
      //                }else  {
      //                    print("无法加载输入法字典")
      //
      //                }
      if let inputsource = getInputSource(for: "com.apple.inputmethod.SCIM.ITABC") {
        //                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        //
        //                        TISSelectInputSource(inputsource)
        //                    }
        //                }
        //                    DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
        //                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        //                        TISSelectInputSource(inputsource)
        //
        //                    }                    //                    }
        DispatchQueue.global().async {
          // 在后台执行的任务
          print("在后台执行的任务")

          //                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

          DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // 在主线程更新 UI 或执行其他与 UI 相关的操作
            print("在主线程执行 UI 相关的操作")
            TISSelectInputSource(inputsource)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
              // 在主线程更新 UI 或执行其他与 UI 相关的操作
              print("在主线程执行 UI 相关的操作")
              if let inputsource = getInputSource(for: "com.apple.inputmethod.SCIM.ITABC") {

                TISSelectInputSource(inputsource)
              }
            }
          }
        }
      }
    }
    //        }

  }

  deinit {
    if let observer = self.workspaceNotification {
      NotificationCenter.default.removeObserver(observer)
    }
  }
}

//func simulateClickOnNavigationBar() {
//    let navigationBarLocation = NSPoint(x: -1, y: 1) // 替换为屏幕顶部导航栏的位置
//
//    // 创建鼠标点击事件
//    let mouseClickEvent = CGEvent(mouseEventSource: nil, mouseType: .leftMouseDown, mouseCursorPosition: navigationBarLocation, mouseButton: .left)!
//    mouseClickEvent.post(tap: .cghidEventTap)
//}

// 设置输入法
func setInputSource(inputSource: TISInputSource) {
  let result = TISSelectInputSource(inputSource)
  if result != noErr {
    print("无法设置输入法，错误码：\(result)")
  } else {
    print("成功设置输入法")
  }
}

func getDefaultInputSource() -> TISInputSource? {
  guard let currentInputSource = TISCopyCurrentKeyboardInputSource()?.takeRetainedValue() else {
    return nil
  }

  // 这里假设默认输入法是英文键盘，你可以根据你的需求修改返回值
  if let defaultInputSource = getInputSource(for: "com.apple.keylayout.ABC") {
    return defaultInputSource
  } else {
    print("无法获取默认输入法")
    return nil
  }
}

func getCurrentInputSource() -> TISInputSource? {
    guard let currentKeyboardInputSource = TISCopyCurrentKeyboardInputSource()?.takeRetainedValue() else {
        return nil
    }
    
    return currentKeyboardInputSource
}

func activateApplication(app: String) {
    
    let workspace = NSWorkspace.shared
        if let appURL = workspace.urlForApplication(withBundleIdentifier: app) {
            try? workspace.launchApplication(at: appURL, options: .default, configuration: [:])
        }
    
    
//    if let app = NSRunningApplication.runningApplications(withBundleIdentifier: app).first {
//        print(app.localizedName)
//        app.activate(options: .activateIgnoringOtherApps)
//    }
}

#Preview{
  ContentView()
}







import InputMethodKit

// MARK: - TISInputSource Extension by The vChewing Project (MIT License).

extension TISInputSource {
  public static var allRegisteredInstancesOfThisInputMethod: [TISInputSource] {
    TISInputSource.modes.compactMap { TISInputSource.generate(from: $0) }
  }

  public static var modes: [String] {
    guard let components = Bundle.main.infoDictionary?["ComponentInputModeDict"] as? [String: Any],
      let tsInputModeListKey = components["tsInputModeListKey"] as? [String: Any]
    else {
      return []
    }
    return tsInputModeListKey.keys.map { $0 }
  }

  @discardableResult public static func registerInputMethod() -> Bool {
    let instances = TISInputSource.allRegisteredInstancesOfThisInputMethod
    if instances.isEmpty {
      // No instance registered, proceeding to registration process.
      NSLog("Registering input source.")
      if !TISInputSource.registerInputSource() {
        NSLog("Input source registration failed.")
        return false
      }
    }
    var succeeded = true
    instances.forEach {
      NSLog("Enabling input source: \($0.identifier)")
      if !$0.activate() {
        NSLog("Failed from enabling input source: \($0.identifier)")
        succeeded = false
      }
    }
    return succeeded
  }

  @discardableResult public static func registerInputSource() -> Bool {
    TISRegisterInputSource(Bundle.main.bundleURL as CFURL) == noErr
  }

  @discardableResult public func activate() -> Bool {
    TISEnableInputSource(self) == noErr
  }

  @discardableResult public func select() -> Bool {
    if !isSelectable {
      NSLog("Non-selectable: \(identifier)")
      return false
    }
    if TISSelectInputSource(self) != noErr {
      NSLog("Failed from switching to \(identifier)")
      return false
    }
    return true
  }

  @discardableResult public func deactivate() -> Bool {
    TISDisableInputSource(self) == noErr
  }

  public var isActivated: Bool {
    unsafeBitCast(TISGetInputSourceProperty(self, kTISPropertyInputSourceIsEnabled), to: CFBoolean.self)
      == kCFBooleanTrue
  }

  public var isSelectable: Bool {
    unsafeBitCast(TISGetInputSourceProperty(self, kTISPropertyInputSourceIsSelectCapable), to: CFBoolean.self)
      == kCFBooleanTrue
  }

  public static func generate(from identifier: String) -> TISInputSource? {
    TISInputSource.rawTISInputSources(onlyASCII: false)[identifier] ?? nil
  }

  public var inputModeID: String {
    unsafeBitCast(TISGetInputSourceProperty(self, kTISPropertyInputModeID), to: NSString.self) as String
  }
}

// MARK: - TISInputSource Extension by Mizuno Hiroki (a.k.a. "Mzp") (MIT License)

// Ref: Original source codes are written in Swift 4 from Mzp's InputMethodKit textbook.
// Note: Slightly modified by vChewing Project: Using Dictionaries when necessary.

extension TISInputSource {
  public var localizedName: String {
    unsafeBitCast(TISGetInputSourceProperty(self, kTISPropertyLocalizedName), to: NSString.self) as String
  }

  public var identifier: String {
    unsafeBitCast(TISGetInputSourceProperty(self, kTISPropertyInputSourceID), to: NSString.self) as String
  }

  public var scriptCode: Int {
    let r = TISGetInputSourceProperty(self, "TSMInputSourcePropertyScriptCode" as CFString)
    return unsafeBitCast(r, to: NSString.self).integerValue
  }

  public static func rawTISInputSources(onlyASCII: Bool = false) -> [String: TISInputSource] {
    // Build a CFDictionary for specifying filter conditions.
    // The 2nd parameter indicates the capacity of this CFDictionary.
    let conditions = CFDictionaryCreateMutable(nil, 2, nil, nil)
    if onlyASCII {
      // Condition 1: isTISTypeKeyboardLayout?
      CFDictionaryAddValue(
        conditions, unsafeBitCast(kTISPropertyInputSourceType, to: UnsafeRawPointer.self),
        unsafeBitCast(kTISTypeKeyboardLayout, to: UnsafeRawPointer.self)
      )
      // Condition 2: isASCIICapable?
      CFDictionaryAddValue(
        conditions, unsafeBitCast(kTISPropertyInputSourceIsASCIICapable, to: UnsafeRawPointer.self),
        unsafeBitCast(kCFBooleanTrue, to: UnsafeRawPointer.self)
      )
    }
    // Return the results.
    var result = TISCreateInputSourceList(conditions, true).takeRetainedValue() as? [TISInputSource] ?? .init()
    if onlyASCII {
      result = result.filter { $0.scriptCode == 0 }
    }
    var resultDictionary: [String: TISInputSource] = [:]
    result.forEach {
      resultDictionary[$0.inputModeID] = $0
      resultDictionary[$0.identifier] = $0
    }
    return resultDictionary
  }
}
