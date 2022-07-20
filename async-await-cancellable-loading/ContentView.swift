//
//  ContentView.swift
//  async-await-cancellable-loading
//
//  Created by Olha Bachalo on 20/07/2022.
//

import SwiftUI

struct ContentView2: View {
    @State private var colors: [Color] = [.red, .blue, .red, .blue]
    @State private var isNavigationLinkActive: Bool = false
    @State var trigger: Bool? = true
    var body: some View {
        List(colors, id: \.self) { color in
            NavigationLink(
                destination:
                    Circle()
                        .fill(color)
                        .frame(width: 400, height: 400),
                tag: true,
                selection: $trigger ) {
                
                Circle()
                    .fill(color)
                    .frame(width: 200, height: 200)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ContentView: View {
    @State var selection : Int? = nil
        
    var body: some View {
        NavigationView{
            VStack{
                NavigationLink(destination: Text("New Screen 1"), tag: 1, selection: self.$selection) {
                    Text("")
                }
                
                NavigationLink(destination: Text("New Screen 2"), tag: 2, selection: self.$selection) {
                    Text("")
                }
                
                Button("Button 1"){
                    DispatchQueue.global().async {
                        for i in 0..<10 {
                            sleep(1)
                            print("heavy work 1[\(i)]")
                        }
                        
                        DispatchQueue.main.async {
                            print("heavy work 1 FINISHED")
                            self.selection = 1
                        }
                    }
                }
                
                Spacer()
                
                Button("Button 2"){
                    DispatchQueue.global().async {
                        for i in 0..<10 {
                            sleep(1)
                            print("heavy work 2[\(i)]")
                        }
                        
                        DispatchQueue.main.async {
                            print("heavy work 2 FINISHED")
                            self.selection = 2
                        }
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
