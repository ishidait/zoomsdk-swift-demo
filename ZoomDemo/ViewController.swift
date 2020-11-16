//
//  ViewController.swift
//  ZoomDemo
//
//  Created by Makoto Ishida on 11/15/20.
//

import UIKit
import MobileRTC

class ViewController: UIViewController {

    let userName = "Test User"
    let meetingNo = "MEETING_NUMBER"
    let meetingPwd = "MEETING_PASSWORD"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        
        // Pass the  Navigation Controller into the Zoom SDK
        if let navController = self.navigationController {
            MobileRTC.shared().setMobileRTCRootController(navController)
        }
    }
    
    func joinMeeting() {
        guard let meetingService = MobileRTC.shared().getMeetingService() else {
            print("getMeetingService() failed.")
            return
        }
        
        meetingService.delegate = self
        let params = MobileRTCMeetingJoinParam()
        params.userName = userName
        params.meetingNumber = meetingNo
        params.password = meetingPwd
        params.noAudio = false
        params.noVideo = false
        let response = meetingService.joinMeeting(with: params)

        print("onJoinMeeting, response: \(response)")
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        print("startButtonPressed")
        joinMeeting()
    }
}

extension ViewController: MobileRTCMeetingServiceDelegate{
    func onMeetingStateChange(_ state: MobileRTCMeetingState) {
       print("\(state)")
        if (state == MobileRTCMeetingState_InMeeting){
            print("We are in the meeting!")
        }
    }
}
