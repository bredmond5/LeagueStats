//
//  ChangeProfileLeague.swift
//  ScoreSender
//
//  Created by Brice Redmond on 8/13/20.
//  Copyright © 2020 Brice Redmond. All rights reserved.
//

import SwiftUI
import FirebaseDatabase

struct ChangeProfileLeague: View {
    
    let curLeague: League
    let player: PlayerForm
    
    @State var displayName: String = ""
    
    var width: CGFloat = 80
    
    @State var showingAlert = false
    @State var alertMessage = "" {
        didSet {
            self.showingAlert = true
        }
    }
    @State var isShowingImagePicker = false
    
    @State var didUploadUsername = false
    @State var uploadedImage: UIImage?
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    
    var body: some View {
        
        VStack (alignment: .leading, spacing: 16) {
            HStack {
                Spacer()
                Image(uiImage: uploadedImage ?? self.player.image)
                    
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
                self.uploadedImage = i
                     
             }, isPresented: self.$isShowingImagePicker)
            })
            
            HStack (spacing: 16) {
                Text("Username: ")
                    .frame(width: width, alignment: .leading)
                TextField(player.displayName, text: self.$displayName)
                    .padding(.all, 12)
                    .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(style: StrokeStyle(lineWidth: 1))
                        .foregroundColor(Color(.sRGB, red: 0.1, green: 0.1, blue: 0.1, opacity: 0.2)))

            }
            Spacer()
            }.navigationBarTitle("Change Profile")
        .alert(isPresented: self.$showingAlert, content: {
            Alert(title: Text(self.alertMessage))
        }).padding(.all, 16)
            .navigationBarItems(trailing: Button(action: save) {
                Text("Save")
            })
    }
    
    func save() {
        if self.displayName != ""  && self.displayName != self.player.displayName {
            changeDisplayName(callback: { errorMessage in
                if let msg = errorMessage {
                    self.alertMessage = msg
                } else {
                    self.changeImage(callback: { imageSuccess in
                        if imageSuccess {
                            self.mode.wrappedValue.dismiss()
                        }
                    })
                }
            })
        } else {
            self.changeImage(callback: { imageSuccess in
                if imageSuccess {
                    self.mode.wrappedValue.dismiss()
                }
            })
        }
    }
    
    func changeImage(callback: @escaping (Bool) -> ()) {
        if let image = uploadedImage {
            self.curLeague.changePlayerImage(player: self.player, newImage: image, callback: { didUploadImage in
                if didUploadImage {
                    self.player.image = image
                    callback(true)
                } else {
                    self.alertMessage = "Could not upload photo"
                    callback(false)
                    return
                }
            })
        } else {
            callback(true)
        }
    }
    
    func changeDisplayName(callback: @escaping (String?) -> ()) {
        if displayName == "" {
            callback("You cant have a blank username")
            return
        }
            
        if displayName.count > Constants.maxCharacterDisplayName {
            callback("Usernames must be less than \(Constants.maxCharacterDisplayName)")
            return
        }
        
        //Redownload league just to make sure no one else has changed their display name to what we are trying
        League.getLeagueFromFirebase(forLeagueID: curLeague.id.uuidString, forDisplay: false, shouldGetGames: false, callback: { league in
            if let league = league {
                for player in league.returnPlayers() {
                    if player.displayName == self.displayName {
                        callback("\(self.displayName) is taken")
                        return
                    }
                }
                // no one has the name so tell the league to change the display name
                self.curLeague.changePlayerDisplayName(phoneNumber: self.player.phoneNumber, newDisplayName: self.displayName, callback: { errorMessage in
                    if let msg = errorMessage {
                        self.alertMessage = msg
                        self.showingAlert = true
                    } else {
                       self.player.displayName = self.displayName
                       callback(nil)
                    }
                })
            } else {
                callback("Try again later")
            }
        })
    }
}

