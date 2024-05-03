import SwiftUI
import PhotosUI
import FileProviderUI
import AlertToast
import VChatCloudSwiftSDK

struct ChattingView: View {
    @ObservedObject var routerViewModel: RouterViewModel
    @ObservedObject var chatroomViewModel: ChatroomViewModel
    @ObservedObject var userViewModel: UserViewModel
    @ObservedObject var vChatCloud = VChatCloud.shared
    @ObservedObject var myChannel = MyChannel.shared

    @State var isShowEmoji: Bool = false
    @State var isShowToast: Bool = false
    @State var scrollProxy: ScrollViewProxy? = nil
    @State var lastViewId = UUID()
    @State var keyboardHeight = 0.0

    @FocusState var focusField: String?
    
    func hideAll() {
        focusField = nil
        isShowEmoji = false
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                TitleBarView(routerViewModel: routerViewModel, chatroomViewModel: chatroomViewModel)
                    .onTapGesture {
                        hideAll()
                    }
                ChatBodyView(scrollProxy: $scrollProxy, lastViewId: $lastViewId)
                    .onTapGesture {
                        hideAll()
                    }
                TextFieldView(routerViewModel: routerViewModel, chatroomViewModel: chatroomViewModel, lastViewId: $lastViewId, scrollProxy: $scrollProxy, isShowEmoji: $isShowEmoji, isShowToast: $isShowToast, focusField: _focusField)
            }
            .toolbar(.hidden)
            .onAppear {
                self.keyboardHeight = 0
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { noti in
                    let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                    let height = value.height
                    self.keyboardHeight = height
                }

                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                    self.keyboardHeight = 0
                }
            }
        }
        .toast(isPresenting: $isShowToast) {
            AlertToast(type: .loading)
        }
    }
}

struct ChattingView_Previews: PreviewProvider {
    static var previews: some View {
        ChattingView(routerViewModel: RouterViewModel(), chatroomViewModel: .MOCK, userViewModel: UserViewModel.MOCK)
            .onAppear {
                MyChannel.shared.chatlog.append(.mock)
                MyChannel.shared.myChatlog.append(.MOCK)
            }
    }
}
