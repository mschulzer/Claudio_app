//
//  ContentView.swift
//  WithStacks
//
//  Created by Morten Schultz on 24/07/2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import SwiftUI

extension Int: Identifiable {
    public var id: Int { self }
}

struct ContentView: View {
    
    @State var loggedIn: Bool = false
    
    var body: some View {
        ZStack {
            MainView(loggedIn: $loggedIn)
            if loggedIn {
                LoggedInView(loggedIn: self.$loggedIn)
                    .transition(.move(edge: .bottom))
            }
        }.edgesIgnoringSafeArea(.all)
    }
}


struct MainView: View {
    @Binding var loggedIn: Bool
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                self.loggedIn.toggle()
            }
        }) {
            Text("Login")
        }
    }
}

struct LoggedInView: View {
    
    @Binding var loggedIn: Bool
    @State var showSheet: Bool = false
    @State var showMore: Bool = false
    @State private var selectedActivity: Int? = nil
    
    var activities: [Activity] = [
        Activity(title: "Title 1", num: 5, description: "Some description..."),
        Activity(title: "Title 2", num: 6, description: "Some description..."),
        Activity(title: "Title 3", num: 7, description: "Some description...")
    ]
    
    var body: some View {
        ZStack {
            Color.red
            VStack {
                HStack {
                    Button(action: {
                        self.loggedIn.toggle()
                    }) {
                        Image(systemName: "arrow.up.left.circle.fill")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        self.showSheet.toggle()
                    }) {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.white)
                    }.sheet(isPresented: $showSheet, content: {
                        SettingsView(showSheet: self.$showSheet)
                    })
                }
                ScrollView {
                    ForEach(0..<activities.count) { activity in
                        Button(action: {
                            self.selectedActivity = activity
                        }) {
                            Text(self.activities[activity].title)
                                .padding(10)
                        }
                    }
                }.sheet(item: self.$selectedActivity) {
                    Text("Hello, World! \($0)")
                }
            }
            .offset(y: 10)
            .padding(10)
        }
    }
}

struct ActivityDetails: View {
    
    @State var activity: Activity
    
    var body: some View {
        VStack {
            Text(activity.title)
            Text(activity.description)
        }
    }
}

struct SettingsView: View {
    
    @Binding var showSheet: Bool
    
    var body: some View {
        VStack {
            Text("Here are some settings")
            Button(action: {
                self.showSheet.toggle()
            }) {
                Text("Dismiss")
            }
        }
    }
}

struct MoreView: View {
    
    var activity: Activity
    
    var body: some View {
        Text("More View: \(activity.title)")
    }
}

struct Activity: Identifiable {
    var id = UUID()
    var title: String
    @State var num: Int
    var description: String
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
