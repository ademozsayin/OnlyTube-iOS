import SwiftUI
import UIKit


struct SleepTimerButtonRepresentable: UIViewRepresentable {
    @Binding var sleepTimerOn: Bool
    @Binding var tintColor: UIColor
    
    func makeUIView(context: Context) -> SleepTimerButton {
        let button = SleepTimerButton(frame: .zero)
//        button.addTarget(context.coordinator, action: #selector(Coordinator.toggleSleepTimer), for: .touchUpInside)
        return button
    }
    
    func updateUIView(_ uiView: SleepTimerButton, context: Context) {
        uiView.sleepTimerOn = sleepTimerOn
//        uiView.tintColor = tintColor
        uiView.tintColor = sleepTimerOn ? tintColor : .white
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: SleepTimerButtonRepresentable
        
        init(_ parent: SleepTimerButtonRepresentable) {
            self.parent = parent
        }
        
//        @objc func toggleSleepTimer() {
//            parent.sleepTimerOn.toggle()
//        }
    }
}
