//
//  CheckMainView.swift
//  CheckIt
//
//  Created by sole on 2023/01/18.
//

import SwiftUI

struct CheckMainView: View {
    @EnvironmentObject var groupStore: GroupStore
    
    @State var x : CGFloat = 0
    @State var count : CGFloat = 0
    @State var screen = UIScreen.main.bounds.width - 30
    var op : CGFloat {
        ((self.screen + 15) * CGFloat(groupStore.groups.count / 2)) - (groupStore.groups.count % 2 == 0 ? ((self.screen + 15) / 2) : 0)
    }
    
    var card: [Card] {cardGenerate()}
    
    var body: some View {
        NavigationStack {
            TabView {
                VStack {
                    Spacer()
                    HStack(spacing: 47) {
                        ForEach(0..<groupStore.groups.count, id: \.self) { index in
                            VStack {
                                HStack {
                                    CheckItCard(group: groupStore.groups[index], index: index, card: card)
                                        .offset(x: self.x)
                                        .highPriorityGesture(DragGesture()
                                                             
                                            .onChanged({ (value) in
                                                
                                                if value.translation.width > 0 {
                                                    self.x = value.location.x

                                                } else {
                                                    self.x = value.location.x - self.screen
                                                }
                                            })
                                                .onEnded({ (value) in
                                                    if value.translation.width > 0 {
                                                        if value.translation.width > ((self.screen - 80) / 2) && Int(self.count) != 0 {
                                                            
                                                            self.count -= 1
                                                            self.updateHeight(value: Int(self.count))
                                                            self.x = -((self.screen + 15) * self.count)
                                                        } else {
                                                            self.x = -((self.screen + 15) * self.count)
                                                        }
                                                    } else {
                                                        if -value.translation.width > ((self.screen - 80) / 2) && Int(self.count) !=  (groupStore.groups.count - 1) {
                                                            
                                                            self.count += 1
                                                            self.updateHeight(value: Int(self.count))
                                                            self.x = -((self.screen + 15) * self.count)
                                                        } else {
                                                            self.x = -((self.screen + 15) * self.count)
                                                        }
                                                    }
                                                })
                                        )
                                }
                                
                                HStack(spacing: 5) {
                                    ForEach(groupStore.groups.indices) { i in
                                        Capsule()
                                            .fill(Color.black.opacity(card[i].show == true ? 1 : 0.4))
                                            .frame(width: card[i].show == true ? 10 : 8, height: card[i].show == true ? 10 : 8)
                                            .offset(y: 60)
                                    }
                                }
                            }
                            .padding(.top, 60)
                            
                        }
                        
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    .offset(x: self.op)
                    
                    Spacer()
                    
                }
                //            .background(Color.black.opacity(0.07).edgesIgnoringSafeArea(.top))
                //            .navigationBarTitle("Carousel List")
                .animation(.spring())
            }

            
        }

}
    func updateHeight(value : Int){
        var tempCard = cardGenerate()
        for i in 0..<GroupStore().groups.count{
            
            tempCard[i].show = false
        }
        
        tempCard[value].show = true
    }
    
    func cardGenerate() -> [Card] {
        var tempCard: [Card] = []
        for i in 0..<groupStore.groups.count {
            switch count {
            case CGFloat(i):
                if CGFloat(i) != 0 {
                    tempCard.append(Card(isActiveButton: false, show: true))
                } else {
                    tempCard.append(Card(isActiveButton: true, show: true))
                }
            default:
                if CGFloat(i) != 0 {
                    tempCard.append(Card(isActiveButton: false, show: false))
                } else {
                    tempCard.append(Card(isActiveButton: true, show: false))
                }
            }
        }
        return tempCard
    }
}

////MARK: - Previews
//struct CheckMainView_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckMainView()
//    }
//}
