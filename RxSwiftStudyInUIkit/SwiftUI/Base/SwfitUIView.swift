//
//  SwfitUIView.swift
//  RxSwiftStudyInUIkit
//
//  Created by soohyeon won on 2022/09/16.
//

import SwiftUI

struct BaseView: View {
    var body: some View {
        VStack { //VStack => 수직 스택
            Text("Hello, world!")
            Text("Goodbye, world!")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView()
    }
}
