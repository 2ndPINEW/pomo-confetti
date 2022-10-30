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
    
    var workEndTime: Int = 25 * 60
    var breakEndTime: Int = 5 * 60
    
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

// cmd + j is my raycast confetti shortcut
fileprivate func confetti() {
    NSLog("confetti")
    let source = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)

    let cmdKey: UInt16 = 0x38
    let jkey: UInt16 = 0x26

    let cmdDown = CGEvent(keyboardEventSource: source, virtualKey: cmdKey, keyDown: true)
    let cmdUp = CGEvent(keyboardEventSource: source, virtualKey: cmdKey, keyDown: false)
    let keyJDown = CGEvent(keyboardEventSource: source, virtualKey: jkey, keyDown: true)
    let keyJUp = CGEvent(keyboardEventSource: source, virtualKey: jkey, keyDown: false)
    
    let loc = CGEventTapLocation.cghidEventTap

    cmdDown?.flags = CGEventFlags.maskCommand
    cmdUp?.flags = CGEventFlags.maskCommand
    keyJDown?.flags = CGEventFlags.maskCommand
    keyJUp?.flags = CGEventFlags.maskCommand

    cmdDown?.post(tap: loc)
    keyJDown?.post(tap: loc)
    cmdUp?.post(tap: loc)
    keyJUp?.post(tap: loc)
}
