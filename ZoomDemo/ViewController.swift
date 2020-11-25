//
//  ViewController.swift
//  ZoomDemo
//
//  Created by Makoto Ishida on 11/15/20.
//

import UIKit
import MobileRTC
import MobileCoreServices

class ViewController: UIViewController, MobileRTCAuthDelegate {

    let displayName     = "iOS User"
    
    @IBOutlet weak var btnJoinMeeting: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize Zoom SDK after a delay. The delay is necessary to show the UI first.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.005) {
            self.initZoomSdk()
        }
    }
    
    func initZoomSdk(){
        let context = MobileRTCSDKInitContext()
        context.domain = "zoom.us"
        context.enableLog = true
        MobileRTC.shared().initialize(context)
        print("ZoomSDK Version: \(MobileRTC.shared().mobileRTCVersion()!)")

        MobileRTC.shared().setMobileRTCRootController(navigationController)

        if let authService = MobileRTC.shared().getAuthService() {
            authService.delegate        = self
            authService.clientKey       = ZOOMSDK_APP_KEY
            authService.clientSecret    = ZOOMSDK_APP_SECRET
            authService.sdkAuth()
        }
    }
    
    func onMobileRTCAuthReturn(_ returnValue: MobileRTCAuthError) {
        print(returnValue)
        if (returnValue != MobileRTCAuthError_Success) {
           let msg = "SDK authentication failed, error code: \(returnValue)"
            print(msg)
            return
        }
        
        print("SDK authentication success!")
        btnJoinMeeting.isEnabled = true
    }


    
    func joinMeeting() {
        guard let meetingService = MobileRTC.shared().getMeetingService() else {
            print("getMeetingService() failed.")
            return
        }
        
        meetingService.delegate = self
        let params = MobileRTCMeetingJoinParam()
        params.userName = displayName
        params.meetingNumber = ZOOM_MTG_NUMBER
        params.password = ZOOM_MTG_PASSWORD
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
        
        switch state {
        case MobileRTCMeetingState_Idle:
            print("Idle now.")
        case MobileRTCMeetingState_Connecting:
            print("Connecting...")
        case MobileRTCMeetingState_Disconnecting:
            print("Disconnecting...")
        case MobileRTCMeetingState_InMeeting:
            print("We are in the meeting!")
        case MobileRTCMeetingState_InWaitingRoom:
            print("We are in the waiting room...")
        default:
            print(state)
        }
        
        /*
         0  MobileRTCMeetingState_Idle,///<No meeting is running.
         1  MobileRTCMeetingState_Connecting,///<Connect to the meeting server status.
         2  MobileRTCMeetingState_WaitingForHost,///<Waiting for the host to start the meeting.
         3  MobileRTCMeetingState_InMeeting,///<Meeting is ready, in meeting status.
         4  MobileRTCMeetingState_Disconnecting,///<Disconnect the meeting server, leave meeting status.
         5  MobileRTCMeetingState_Reconnecting,///<Reconnecting meeting server status.
         6  MobileRTCMeetingState_Failed,///<Failed to connect the meeting server.
         7  MobileRTCMeetingState_Ended,///<Meeting ends.
         8  MobileRTCMeetingState_Unknow,///<Unknown status.
         9  MobileRTCMeetingState_Locked,///<Meeting is locked to prevent the further participants to join the meeting.
         10 MobileRTCMeetingState_Unlocked,///<Meeting is open and participants can join the meeting.
         11 MobileRTCMeetingState_InWaitingRoom,///<Participants who join the meeting before the start are in the waiting room.
         12 MobileRTCMeetingState_WebinarPromote,///<Upgrade the attendees to panelist in webinar.
         13 MobileRTCMeetingState_WebinarDePromote,///<Downgrade the attendees from the panelist.
         14 MobileRTCMeetingState_JoinBO,///<Join the breakout room.
         15 MobileRTCMeetingState_LeaveBO,///<Leave the breakout room.
         16 MobileRTCMeetingState_WaitingExternalSessionKey,///<Waiting for the additional secret key.
        */
        
    }
}
