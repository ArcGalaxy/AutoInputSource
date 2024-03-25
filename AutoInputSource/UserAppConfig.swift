//
//  UserAppConfig.swift
//  AutoInputSource
//
//  Created by 梁波 on 2024/3/18.
//

import Cocoa
import SwiftUI

import Foundation
import AppKit


struct AppInfo: Identifiable {
    let id = UUID()
    let name: String
    var icon: NSImage?
    var bundleIdentifier: String
    var shouldSwitchInputMethod: Bool = false
    var selectedInputMethod: String = ""
}

class AppListViewModel: ObservableObject {
  @Published var appList: [AppInfo] = []

  init() {

    var userAppImeConfig: [String: String] = [:]

    if let userAppImeConfigTmp: [String: String] = DictionaryManager.shared.loadDictionary(
      forKey: "UserAppImeConfigDictionary")
    {
      //            print("userAppImeConfig: \(userAppImeConfigTmp)")
      userAppImeConfig = userAppImeConfigTmp
    } else {
      print("No userAppImeConfig info found.")
    }

    //        let runningApplications = NSWorkspace.shared.runningApplications
    let runningApplications = NSWorkspace.shared.runningApplications.filter { app in
      return app.activationPolicy == .regular
    }
    for app in runningApplications {
      if let appName = app.localizedName,
        let bundleIdentifier = app.bundleIdentifier
      {

        if let ime = userAppImeConfig[bundleIdentifier] {
          let appInfo = AppInfo(
            name: appName, icon: app.icon, bundleIdentifier: bundleIdentifier,
            selectedInputMethod: ime)
          appList.append(appInfo)
        } else {
          let appInfo = AppInfo(name: appName, icon: app.icon, bundleIdentifier: bundleIdentifier)
          appList.append(appInfo)
        }

        //                if(appName == "微信") {
        //                    let appInfo = AppInfo(name: appName, icon: app.icon,bundleIdentifier: bundleIdentifier,selectedInputMethod: "com.tencent.inputmethod.wetype.pinyin")
        //
        //                    appList.append(appInfo)
        //                } else {
        //                    let appInfo = AppInfo(name: appName, icon: app.icon,bundleIdentifier: bundleIdentifier)
        //
        //                    appList.append(appInfo)
        //                }

      }
    }

  }
}

struct ConfigRow: View {
  var appInfo: AppInfo
  @Binding var shouldSwitchInputMethod: Bool
  @Binding var selectedInputMethod: String
  // 添加一个字典来存储输入法选项
  var inputMethodOptions: [String: String]

  init(
    appInfo: AppInfo, shouldSwitchInputMethod: Binding<Bool>, selectedInputMethod: Binding<String>,
    inputMethodOptions: [String: String]
  ) {
    self.appInfo = appInfo
    self._shouldSwitchInputMethod = shouldSwitchInputMethod
    self._selectedInputMethod = selectedInputMethod

    self.inputMethodOptions = inputMethodOptions  // 使用传入的输入法选项字典
    self.inputMethodOptions[""] = ""
    // 设置默认选择为第一个非空标签
    //           if let firstOptionKey = inputMethodOptions.first?.key {
    //               self._selectedInputMethod = State(initialValue: firstOptionKey)
    //           } else {
    //               self._selectedInputMethod = State(initialValue: "")
    //           }
      
  }

  // 加载输入法选项
  //    private func loadInputMethodOptions() {
  //        if let inputSourcesDictionary: [String: String] = DictionaryManager.shared.loadDictionary(forKey: "KeyboardIdentifierRevers"){
  //            print("KeyboardIdentifierRevers: \(inputSourcesDictionary)")
  //            self.inputMethodOptions = inputSourcesDictionary
  //        } else {
  //            print("No KeyboardIdentifierRevers info found.")
  //        }
  //    }

  var body: some View {
    HStack {
      if let icon = appInfo.icon {
        Image(nsImage: icon)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 44, height: 44)
      }
      Text(appInfo.name)
      //            Text(appInfo.bundleIdentifier)
      Spacer()
      //            Toggle("", isOn: $shouldSwitchInputMethod)
      //                .labelsHidden()
      //            if shouldSwitchInputMethod {
      //                Picker("", selection: $selectedInputMethod) {
      //                    Text("-").tag("")
      //                    Text("English").tag("com.apple.keylayout.US")
      //                    Text("中文").tag("com.apple.keylayout.Zhuyin")
      //                    Text("腾讯中文").tag("com.tencent.inputmethod.wetype.pinyin")
      //
      //                    // 添加其他输入法选项
      //                }
      Picker("", selection: $selectedInputMethod) {
        ForEach(inputMethodOptions.keys.sorted(), id: \.self) { key in
          Text(inputMethodOptions[key] ?? "")  // 使用默认值 "-"，如果键不存在则显示 "-"
            .tag(key)
        }
      }
      .frame(width: 100)
      .labelsHidden()
      .onChange(of: selectedInputMethod) { newValue in
        // 在这里执行在选择变化时要执行的操作
        handleInputMethodSelectionChange(appInfo: appInfo, newValue: newValue)
      }
      //            }
    }.padding(.leading, 20)
      .padding(.trailing, 20)
    //            .padding(.top, 10)
    //            .padding(.bottom, 10)
  }

}

struct UserAppConfig: View {
  @ObservedObject var viewModel = AppListViewModel()
  @State private var selectedMethods: [String] = []

  var body: some View {
    VStack {
      List(viewModel.appList.indices, id: \.self) { index in
        if var inputMethodOptions: [String: String] = DictionaryManager.shared.loadDictionary(
          forKey: "KeyboardIdentifier")
        {
          ConfigRow(
            appInfo: viewModel.appList[index],
            shouldSwitchInputMethod: self.$viewModel.appList[index].shouldSwitchInputMethod,
            selectedInputMethod: self.$viewModel.appList[index].selectedInputMethod,
            inputMethodOptions: inputMethodOptions)
        }
      }
      .frame(
        minWidth: 300, idealWidth: 400, maxWidth: .infinity, minHeight: 200, idealHeight: 300,
        maxHeight: .infinity)
    }
  }
}

// 当输入法选择变化时调用的方法
private func handleInputMethodSelectionChange(appInfo: AppInfo, newValue: String) {
  //        selectedInputMethod = newValue
  // 在这里调用保存方法
  print(newValue)
  print(appInfo.bundleIdentifier)

  // 将配置持久化存储
  if newValue == "" {
    DictionaryManager.shared.removeKey(
      key: appInfo.bundleIdentifier, forKey: "UserAppImeConfigDictionary")
  } else {
    DictionaryManager.shared.addKeyValue(
      key: appInfo.bundleIdentifier, value: newValue, forKey: "UserAppImeConfigDictionary")
  }

}

#Preview{
  UserAppConfig()
}
