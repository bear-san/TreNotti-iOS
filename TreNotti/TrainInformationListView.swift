//
//  TrainInformationListView.swift
//  TreNotti
//
//  Created by Kentaro Abe on 2020/12/08.
//
//  運行情報一覧画面

import SwiftUI

struct TrainInformationListView: View {
    @ObservedObject var controller = TNController()
    @State var isPresentInformationDescription = false
    @ObservedObject var informationViewController = TNTrainInformationController()
    
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("登録済みの路線")){
                    List{
                        ForEach(controller.registeredRailwayTrainInformation){ information in
                            StatusCell(railwayTitle: "\(controller.getRailway(key: information.odptRailway).railwayTitle.ja)",
                                       railwayStatus: "\(information.trainInformationStatus.ja)",
                                       isPresentDescription: isPresentInformationDescription)
                                .onTapGesture {
                                    self.informationViewController.status = information
                                    self.isPresentInformationDescription.toggle()
                                }
                        }
                    }
                }
                
                Section(header: Text("その他の路線")) {
                    List{
                        ForEach(controller.otherRailwayTrainInformation){ information in
                            StatusCell(railwayTitle: "\(controller.getRailway(key: information.odptRailway).railwayTitle.ja)",
                                       railwayStatus: "\(information.trainInformationStatus.ja)",
                                       isPresentDescription: isPresentInformationDescription)
                                .onTapGesture {
                                    self.informationViewController.status = information
                                    self.isPresentInformationDescription.toggle()
                                }
                        }
                    }
                }
            }
            .alert(isPresented: $controller.isAlert, content: {
                Alert(title: Text(controller.alertTitle),
                      message: Text(controller.alertDescription),
                      dismissButton: .default(Text("OK")))
            })
            
            .sheet(isPresented: $isPresentInformationDescription, onDismiss: {
                self.controller.updateRegisteredRailwayList()
            }){
                TrainInformationView(controller: informationViewController)
            }
            .navigationBarTitle(.init("運行情報一覧"))
            
        }
    }
}

struct StatusCell: View {
    var railwayTitle: String
    var railwayStatus: String
    @State var isPresentDescription: Bool
    
    var body: some View{
        HStack(alignment: .center){
            Rectangle()
                .fill(Color.gray)
                .frame(width: 30)
                .padding([.top, .bottom], -10)
                .padding(.leading, -16)
            
            VStack(alignment: .leading){
                Text(railwayTitle)
                    .font(.title2)
                    .padding(.top, 3.0)
                Text(railwayStatus)
                    .font(.body)
                    .padding(3)
            }
            
            Spacer()
            
            Button(action: {
                self.isPresentDescription.toggle()
            }, label: {
                Image(systemName: "info.circle")
            })
        }
    }
}

struct TrainStatusView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TrainInformationListView()
                .previewDevice("iPhone 11")
        }
    }
}