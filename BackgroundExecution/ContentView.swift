//
//  ContentView.swift
//  BackgroundExecution
//
//  Created by Jaeson Booker on 7/2/19.
//  Copyright © 2019 Jaeson Booker. All rights reserved.
//

import SwiftUI
struct textMe {
    var stringy: String?
}
var newTextMeStruct = textMe()
struct ContentView : View {
    var texty = newTextMeStruct.stringy!
    var body: some View {
        Text(stringy)
    }
}
#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

