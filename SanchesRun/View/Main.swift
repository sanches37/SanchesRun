//
//  Main.swift
//  SanchesRun
//
//  Created by tae hoon park on 2023/02/27.
//

import SwiftUI

struct Main: View {
@StateObject private var viewModel = MainViewModel()
    var body: some View {
        Text("Hello, World!")
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
    }
}
