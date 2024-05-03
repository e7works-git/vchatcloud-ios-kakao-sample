import SwiftUI

struct ChatTextView: View {
    @StateObject var chatResultModel: ChatResultModel
    
    var color: Color {
        if chatResultModel.address == .whisper {
            return Color(hex: 0xffeb3b)
        } else if chatResultModel.isMe {
            return Color(hex: 0xb2c7eb)
        } else {
            return .white
        }
    }
    
    var message: String {
        chatResultModel.isDeleted ? "가려진 메시지입니다." : chatResultModel.message
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                HStack(alignment: .top, spacing: 0) {
                    if !chatResultModel.isMe {
                        if chatResultModel.address == .whisper {
                            Image("whisper_box_arr_left")
                                .padding(.top, 5)
                        } else if chatResultModel.isShowProfile {
                            Image("chatbox_arr_left")
                                .padding(.top, 5)
                        } else {
                            Spacer()
                                .frame(width: 10)
                        }
                    }
                }
                VStack(alignment: chatResultModel.isMe ? .trailing : .leading, spacing: 0) {
                    Text(message)
                        .foregroundColor(chatResultModel.isDeleted ? .gray : .black)
                        .padding(10)
                        .background(self.color)
                        .cornerRadius(3)
                    if !chatResultModel.isDeleted {
                        ChatOpenGraphView(chatResultModel: chatResultModel)
                    }
                }
                HStack(alignment: .top, spacing: 0) {
                    if chatResultModel.isMe {
                        if chatResultModel.address == .whisper {
                            Image("whisper_box_arr_right")
                                .padding(.top, 5)
                        } else if chatResultModel.isShowMyProfile {
                            Image("chatbox_arr_right")
                                .padding(.top, 5)
                        } else {
                            Spacer()
                                .frame(width: 10)
                        }
                    }
                }
            }
        }
    }
}

struct ChatTextView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 0) {
                ChatBaseView(chatResultModel: .MOCK) {
                    ChatTextView(chatResultModel: ChatResultModel.MOCK)
                }
                ChatBaseView(chatResultModel: .openGraphMock) {
                    ChatTextView(chatResultModel: .openGraphMock)
                }
                ChatHeaderView(chatResultModel: .MOCK)
                ChatBaseView(chatResultModel: .EMPTY) {
                    ChatTextView(chatResultModel: .EMPTY)
                }
            }
            .padding()
            .background(Color.Theme.background)
        }
    }
}
