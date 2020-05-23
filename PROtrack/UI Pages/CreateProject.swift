//
//  CreateProject.swift
//  PROtrack
//
//  Created by Marino Bantli on 03.05.20.
//  Copyright © 2020 MB-Apps. All rights reserved.
//

import SwiftUI

struct CreateProjectView: View {
    
    @State var ProjectName:String = ""
    @State var ProjectDescription:String = ""
    @State var selectedMembers:[Int] = []
    @State var editProject: Bool = false
    @State var projectID: Int = 0

    @Binding var isPresented: Bool
    @State private var showingAlert: Bool = false
    @State private var APIResponse: String = ""
        
    var body: some View {
        
        NavigationView {
            List{
                Section(header: Text("Projektname")){
                    TextField("Projektname", text: $ProjectName)
                }
                
                Section(header: Text("Projektbeschreibung")) {
                    ScrollView {
                        TextField("Projektbeschreibung", text: $ProjectDescription)
                    }.frame(height:120)
                }
                
                Section(header: Text("Mitglieder")) {
                    ScrollView(.horizontal, showsIndicators: false){
                        UserCardViewSelectable(SelectedMembers: $selectedMembers)
                    }
                }

            }.navigationBarTitle(self.editProject ? Text("Projekt editieren") : Text("Neues Projekt erstellen"), displayMode: .inline)
            .navigationBarItems(
                leading:
                Button("Abbrechen") { self.isPresented = false}
                , trailing:
                Button(self.editProject ? "Aktualisieren" : "Erstellen") {
                    if self.editProject {
                        print("aktualisiere")

                        RequestService().editProject(projectID: self.projectID, title: self.ProjectName, desc: self.ProjectDescription, users: self.selectedMembers) {message, status in
                            if status >= 300 {
                                self.APIResponse = message
                            }
                            if status <= 300 {
                                self.APIResponse = message
                                self.showingAlert.toggle()
                            }
                        }
                    }
                    if !self.editProject
                    {
                        RequestService().createProject(title: self.ProjectName, desc: self.ProjectDescription, users: self.selectedMembers){ message, status in
                            if status >= 300 {
                                print(message)
                                self.APIResponse = message
                            }
                            if status <= 300 {
                                self.APIResponse = message
                                self.showingAlert.toggle()
                            }
                        }
                    }
                    
                })
            .listStyle(GroupedListStyle())
            }.alert(isPresented: self.$showingAlert) {
                Alert(title: Text(""), message: Text(self.APIResponse), dismissButton: .default(Text("OK").bold(), action: {
                    self.isPresented.toggle()
            }))}
            .navigationViewStyle(StackNavigationViewStyle())
        
    }
}
