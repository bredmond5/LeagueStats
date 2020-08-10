//
//  GameForm.swift
//  ScoreSender
//
//  Created by Brice Redmond on 5/11/20.
//  Copyright © 2020 Brice Redmond. All rights reserved.
//

import SwiftUI
import Combine


struct GameForm: View {
//    @EnvironmentObject var session: FirebaseSession
    
    let myAlerts = MyAlerts()
    
    @State private var keyboardHeight: CGFloat = 0
    
    var curLeague: League
    
    @State var isResponders: [Bool] = {
        var isResponders: [Bool] = []
        for i in 0..<5 {
            isResponders.append(false)
        }
        isResponders[0] = true
        return isResponders
    }()
    
    var datasource: [String: String] {
        let players = curLeague.returnPlayers()
        var datasource: [String: String] = [:]
        var duplicates: [String] = []
        for player in players {
            if datasource[player.realName] != nil { // If multiple people have the same real name dont want it autofinishing
                datasource[player.realName] = nil
                duplicates.append(player.realName)
            } else if !duplicates.contains(player.realName) {
                datasource[player.displayName] = player.displayName
                datasource[player.realName] = player.displayName
                datasource[player.phoneNumber] = player.displayName
            }
        }
        return datasource
    }
    
    func makeAutoCompleteTextField(text: Binding<String>, placeholder: String) -> AutoCompleteTextFieldSwiftUI {
        return AutoCompleteTextFieldSwiftUI(text: text, placeholder: placeholder, datasource: datasource)//, isResponder: isResponders[textfieldNum], nextResponder: isResponders[textfieldNum + 1] ?? .constant(nil))
    }
    
    var didAddGame: (Game, [Rating]) -> ()
    
    @State var p1: String = ""
    @State var p2: String = ""
    @State var p3: String = ""
    @State var p4: String = ""
    @State var score1: String = ""
    @State var score2: String = ""
    
    var width: CGFloat = 80
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        ScrollView(.vertical) {
        VStack (alignment: .leading, spacing: 16) {
//            HStack {
//                Spacer()
//                Image(uiImage: session.curLeague.leagueImage ?? UIImage())
//                .resizable()
//                .scaledToFill()
//                .frame(width: 80, height: 80)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 80)
//                        .strokeBorder(style: StrokeStyle(lineWidth: 2))
//                        .foregroundColor(Color(.sRGB, red: 0.1, green: 0.1, blue: 0.1, opacity: 1)))
//                .cornerRadius(80)
//                Spacer()
//            }
            
            HStack (spacing: 16) {
                Text("Player 1")
                    .frame(width: width, alignment: .leading)
                makeAutoCompleteTextField(text: self.$p1, placeholder: "username")
                .padding(.all, 12)
               .overlay(
               RoundedRectangle(cornerRadius: 4)
                   .strokeBorder(style: StrokeStyle(lineWidth: 1))
                   .foregroundColor(Color(.sRGB, red: 0.1, green: 0.1, blue: 0.1, opacity: 0.2)))

            }
            HStack (spacing: 16) {
                Text("Player 2")
                    .frame(width: width, alignment: .leading)
                makeAutoCompleteTextField(text: self.$p2, placeholder: "username")
                .padding(.all, 12)
                .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .strokeBorder(style: StrokeStyle(lineWidth: 1))
                    .foregroundColor(Color(.sRGB, red: 0.1, green: 0.1, blue: 0.1, opacity: 0.2)))
            }
            
            HStack(spacing: 16) {
                Text("Score")
                    .frame(width: width, alignment: .leading)
                TextField("Score 1", text: $score1)
                    .frame(alignment: .center)
                    .padding(.all, 12)
                    .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(style: StrokeStyle(lineWidth: 1))
                        .foregroundColor(Color(.sRGB, red: 0.1, green: 0.1, blue: 0.1, opacity: 0.2)))
                    .keyboardType(.numbersAndPunctuation)
                Text("-")
                    .frame(width: 25, alignment: .center)
                
                TextField("Score 2", text: $score2)
                    .frame(alignment: .center)
                    .padding(.all, 12)
                    .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(style: StrokeStyle(lineWidth: 1))
                        .foregroundColor(Color(.sRGB, red: 0.1, green: 0.1, blue: 0.1, opacity: 0.2)))
                    .keyboardType(.numbersAndPunctuation)
            }
            
            HStack (spacing: 16) {
                Text("Player 3")
                    .frame(width: width, alignment: .leading)
                makeAutoCompleteTextField(text: self.$p3, placeholder: "username")
                .padding(.all, 12)
                .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .strokeBorder(style: StrokeStyle(lineWidth: 1))
                    .foregroundColor(Color(.sRGB, red: 0.1, green: 0.1, blue: 0.1, opacity: 0.2)))

            }
           
           HStack (spacing: 16) {
               Text("Player 4")
                   .frame(width: width, alignment: .leading)
            makeAutoCompleteTextField(text: self.$p4, placeholder: "username")
            .padding(.all, 12)
            .overlay(
            RoundedRectangle(cornerRadius: 4)
                .strokeBorder(style: StrokeStyle(lineWidth: 1))
                .foregroundColor(Color(.sRGB, red: 0.1, green: 0.1, blue: 0.1, opacity: 0.2)))

           }
            
            Button(action: {
                if self.p1 == "" || self.p2 == "" || self.p3 == "" || self.p4 == "" {
                   return
               }
                
                let leagueName = self.curLeague.name
                let displayNameToPhoneNumber = self.curLeague.displayNameToPhoneNumber
                let phoneNumberToPlayer = self.curLeague.players
                var players: [PlayerForm] = []
                
                if displayNameToPhoneNumber[self.p1] == nil {
                    self.myAlerts.showMessagePrompt(title: "Error", message: "\(self.p1) is not a member of \(leagueName)", callback: {
                        return
                    })
                } else if displayNameToPhoneNumber[self.p2] == nil {
                    self.myAlerts.showMessagePrompt(title: "Error", message: "\(self.p2) is not a member of \(leagueName)", callback: {
                        return
                    })
                    
                }else if displayNameToPhoneNumber[self.p3] == nil {
                    self.myAlerts.showMessagePrompt(title: "Error", message: "\(self.p3) is not a member of \(leagueName)", callback: {
                        return
                    })
                }else if displayNameToPhoneNumber[self.p4] == nil {
                    self.myAlerts.showMessagePrompt(title: "Error", message: "\(self.p4) is not a member of \(leagueName)", callback: {
                        return
                    })
                }else {
                    players.append(phoneNumberToPlayer[displayNameToPhoneNumber[self.p1]!]!)
                    players.append(phoneNumberToPlayer[displayNameToPhoneNumber[self.p2]!]!)
                    players.append(phoneNumberToPlayer[displayNameToPhoneNumber[self.p3]!]!)
                    players.append(phoneNumberToPlayer[displayNameToPhoneNumber[self.p4]!]!)

                    if let (game, newPlayerRatings) = Functions.checkValidGameAndGetGameScores(players: [self.p1, self.p2, self.p3, self.p4], scores: [self.score1, self.score2], ratings: [players[0].rating, players[1].rating, players[2].rating, players[3].rating]) {
                        //set game here
                        
                        self.didAddGame(game, newPlayerRatings)
                        self.mode.wrappedValue.dismiss()
                    }
                }
            }, label: {
                HStack {
                    Spacer()
                    Text("Add")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                    
                    Spacer()
                }
            })
            .background(Color.green)
            .cornerRadius(4)
            
            Button(action: {
                self.mode.wrappedValue.dismiss()
            }, label: {
                HStack {
                    Spacer()
                    Text("Cancel")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                    
                    Spacer()
                }
            })
            .background(Color.red)
            .cornerRadius(4)
            
            Spacer()
            
        }.padding(.all, 20)
            .padding(.bottom, keyboardHeight)
            .onReceive(Publishers.keyboardHeight, perform: {self.keyboardHeight = $0})
        }
    }
}