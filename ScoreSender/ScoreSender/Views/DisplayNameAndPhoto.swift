//
//  DisplayNameAndPhoto.swift
//  ScoreSender
//
//  Created by Brice Redmond on 7/4/20.
//  Copyright © 2020 Brice Redmond. All rights reserved.
//

import SwiftUI

struct DisplayNameAndPhoto: View {
    
    @Binding var username: String
    @Binding var image: UIImage
    @Binding var isPresented: Bool
    
    var usedUsernames: [String]
    
    @State var isShowingImagePicker = false
    
    let callback: (Bool) -> ()
    
    var body: some View {
        
        VStack (alignment: .leading, spacing: 16) {
            HStack (spacing: 16) {
                Text("Username: ")
                 TextField("User1234", text: $username) {
                     UIApplication.shared.endEditing()
                 }
                     .padding(.all, 12)
                     .overlay(
                     RoundedRectangle(cornerRadius: 4)
                         .strokeBorder(style: StrokeStyle(lineWidth: 1))
                         .foregroundColor(Color(.sRGB, red: 0.1, green: 0.1, blue: 0.1, opacity: 0.2)))
                    //Spacer()
             }
             
             HStack {
                Spacer()
                 Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
                .overlay(
                    RoundedRectangle(cornerRadius: 80)
                        .strokeBorder(style: StrokeStyle(lineWidth: 2))
                        .foregroundColor(Color(.sRGB, red: 0.1, green: 0.1, blue: 0.1, opacity: 1)))
                .cornerRadius(80)
                Spacer()
            }
            
            Button(action: {
                self.isShowingImagePicker.toggle()
            }, label: {
                HStack {
                    Spacer()
                    Text("Select Your Photo")
                        .fontWeight(.bold)
                        .padding(.all, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(4)
                    Spacer()
                }
            }).sheet(isPresented: $isShowingImagePicker, content: {
             HybridImagePickerController(didAddImage: { i in
                     //self.session.changeUser(image: i)
                self.image = i
             }, isPresented: self.$isShowingImagePicker)
            })
            
            Button(action: addButton) {
               SpanningLabel(color: .green, content: "Add")
            }
           
            Button(action: cancelButton) {
               SpanningLabel(color: .red, content: "Cancel")
            }
            
        }.padding(.all, 30)
    }
    
    func addButton() {
        if username != "" {
            if usedUsernames.contains(username) {
                MyAlerts().showMessagePrompt(title: "Error", message: "Someone in this league already has the username \(username)", callback: {})
            }else{
                self.callback(false)
                self.isPresented = false
            }
        }
    }
    
    func cancelButton() {
        self.callback(true)
        self.isPresented = false
    }
    
}
