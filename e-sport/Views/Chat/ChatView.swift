//
//  ChatView.swift
//  e-sport
//
//  Created by MacBook on 22.10.21.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var viewModel = ChatViewModel()
    @StateObject var vm = ScrollToModel()
    @State private var flag = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    ScrollView(showsIndicators: false) {
                        ScrollViewReader { sp in
                            LazyVStack(alignment: .trailing, spacing: 24) {
                                ForEach(viewModel.messages, id: \.self) { message in
                                    if message.isIncoming {
                                        IncomingMessage(text: message.text).padding(2)
                                    } else {
                                        OutgoingMessage(text: message.text).padding(2)
                                    }
                                }
                            }.onReceive(viewModel.$onMessageAdded) { _ in
                                if viewModel.messages.count == 0 { return }
                                sp.scrollTo(viewModel.messages.last!, anchor: .bottom)
                                flag.toggle()
                                
                            }.onAppear {
                                if viewModel.messages.count == 0 { return }
                                sp.scrollTo(viewModel.messages.last!, anchor: .bottom)
                                flag.toggle()
                            }
                            .padding(.top, 50)
                        }
                    }
                    .padding(.trailing, 40)
                    .padding(.leading, 100)
                    Spacer()
                    HStack {
                        TextField("Type a message", text: $viewModel.message)
                            .padding(.leading, 10)
                        Button(action: { [self] in
                            viewModel.sendMessage()
                            vm.direction = .end
                        }) {
                            Image(systemName: "paperplane")
                                .padding()
                        }
                        .frame(width: 70, height: 50)
                    }
                    .frame(width: UIScreen.width, height: 50)
                    .foregroundColor(Color.white)
                    .background(Color.black)

                }
                .zIndex(2)
                .onTapGesture {
                    viewModel.addGreatingAvatar()
                }
                
                ChatViewBackgroundARRepresantable(viewModel: viewModel)
                    .ignoresSafeArea()
                    .zIndex(1)
                    .onTapGesture {
                        viewModel.addGreatingAvatar()
                    }
            }
            .navigationTitle("Assistant")
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}

class ScrollToModel: ObservableObject {
    enum Action {
        case end
        case top
    }
    @Published var direction: Action? = nil
}
