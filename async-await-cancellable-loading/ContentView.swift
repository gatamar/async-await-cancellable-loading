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

class ContentViewModel: ObservableObject {
    @Published var selection : Int? = nil
    
    private var heavyTask: Task<Void, Never>?
    
    func doHeavyWork1() async {
        for i in 0..<10 {
            if Task.isCancelled { return }
            sleep(1)
            print("heavy work 1[\(i)]")
        }
        
        await MainActor.run {
            print("heavy work 1 FINISHED")
            self.selection = 1
        }
    }
    
    private func doHeavyWork2() async {
        for i in 0..<10 {
            if Task.isCancelled { return }
            sleep(1)
            print("heavy work 2[\(i)]")
        }
        
        await MainActor.run {
            print("heavy work 2 FINISHED")
            self.selection = 2
        }
    }
    
    func heavyWorkTask1() -> Task<Void, Never> {
        heavyTask?.cancel()
        heavyTask = Task {
            await doHeavyWork1()
        }
        return heavyTask!
    }
    
    func heavyWorkTask2() -> Task<Void, Never> {
        heavyTask?.cancel()
        heavyTask = Task {
            await doHeavyWork2()
        }
        return heavyTask!
    }
}

struct ContentView: View {
    @ObservedObject var viewModel = ContentViewModel()
    
    var body: some View {
        NavigationView{
            VStack{
                Spacer()
                
                NavigationLink(
                    destination: Text("New Screen 1"),
                    tag: 1,
                    selection: self.$viewModel.selection
                ) {
                    Button("Button 1"){
                        _ = viewModel.heavyWorkTask1()
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                
                NavigationLink(
                    destination: Text("New Screen 2"),
                    tag: 2,
                    selection: self.$viewModel.selection
                ) {
                    Button("Button 2"){
                        _ = viewModel.heavyWorkTask2()
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
