//
//  ContentView.swift
//  pomo-confetti
//
//  Created by 高瀬英都 on 2022/10/30.
//

import SwiftUI

struct ContentView: View {
    @State var count: Int = 0
    @State var mode: String = "STOP"
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    let workEndTime: Int = 25 * 60
    let breakEndTime: Int = 5 * 60
    
    var body: some View {
        Text("\(mode)")
        Text("\(count)秒")
            .foregroundColor(.red)
        Button("Start!"){
            self.count = 0
            self.mode = "WORKING"
            confetti()
        }
        Button("Stop!"){
            self.count = 0
            self.mode = "STOP"
        }
        .padding()
        .onReceive(timer) { _ in
            if mode != "STOP" {
                count += 1
            }
            if mode == "WORKING" && count > workEndTime {
                mode = "BREAK"
                count = 0
                confetti()
            }
            if mode == "BREAK" && count > breakEndTime {
                mode = "WORKING"
                count = 0
                confetti()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

fileprivate func confetti() {
    inputShortcutKey()
    inputShortcutKey()
    inputShortcutKey()
}

// cmd + j is my raycast confetti shortcut
fileprivate func inputShortcutKey() {
    let source = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)

    //cmd:  0x38, j: 0x26
    let keys: Array<UInt16> = [0x38, 0x26]
    let loc = CGEventTapLocation.cghidEventTap
    
    for key in keys {
        let keyDown = CGEvent(keyboardEventSource: source, virtualKey: key, keyDown: true)
        keyDown?.flags = CGEventFlags.maskCommand
        keyDown?.post(tap: loc)
    }
    
    for key in keys.reversed() {
        let keyDUp = CGEvent(keyboardEventSource: source, virtualKey: key, keyDown: false)
        keyDUp?.flags = CGEventFlags.maskCommand
        keyDUp?.post(tap: loc)
    }
}
