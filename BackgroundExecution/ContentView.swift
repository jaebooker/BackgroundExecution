//
//  ContentView.swift
//  BackgroundExecution
//
//  Created by Jaeson Booker on 7/2/19.
//  Copyright © 2019 Jaeson Booker. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    var body: some View {
        Text("Good Morning, Starshine, the Earth says Hello!")
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
