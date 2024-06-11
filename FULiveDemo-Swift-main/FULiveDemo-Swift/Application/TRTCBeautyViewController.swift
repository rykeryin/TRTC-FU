//
//  TRTCBeautyViewController.swift
//  FULiveDemo-Swift
//
//  Created by rykeryin on 2024/6/10.
//

import UIKit
import TXLiteAVSDK_TRTC
import FURenderKit

class TRTCBeautyViewController: UIViewController {
    
    var cloud = TRTCCloud.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化FURenderKit
        Manager.shared.setupRenderKit()
        
        var params = TRTCParams()
        params.sdkAppId = UInt32(SDKAppID)
        params.strRoomId = "test"
        params.userId = "FUTest"
        params.userSig = GenerateTestUserSig.genTestUserSig(params.userId)
        // Test for userid FUTest
        params.userSig = "eAEtzMsKgkAUBuB3mW2hZ7zkILgTkQwhVDBwE8wxTjE5OWZB9O4N2vb7Lx9WHyrHyNtZa5Is5gFABIHP*XZJJlJoNeICPOGLcFVDFxazuTwVr6Hp3GfVucaL*vqR9-ker8e0TRs1ZLjRhSpN1YpwSNg6xbem0V7uIBAAq8042jvPgX*HJN4n6mnhrKnRTOz7A3ifMhM_"
        cloud.enterRoom(params, appScene: .LIVE)

        cloud.setLocalVideoProcessDelegete(self, pixelFormat: ._Texture_2D, bufferType: .texture)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        cloud.startLocalPreview(true, view: self.view)
    }
    
}

extension TRTCBeautyViewController: TRTCVideoFrameDelegate {
    func onProcessVideoFrame(_ srcFrame: TRTCVideoFrame, dstFrame: TRTCVideoFrame) -> UInt32 {
        let input = FURenderInput()
        input.renderConfig.imageOrientation = FUImageOrientationDown;
        input.renderConfig.gravityEnable = true;
        input.renderConfig.isFromFrontCamera = true;
        input.renderConfig.isFromMirroredCamera = true;
        input.renderConfig.textureTransform = CCROT0_FLIPVERTICAL;
        
        var texture = FUTexture()
        texture.ID = srcFrame.textureId
        texture.size = CGSize()
        texture.size.width = CGFloat(srcFrame.width)
        texture.size.height = CGFloat(srcFrame.height)
        input.texture = texture;
        let output = FURenderKit.share().render(with: input)
        if (output != nil) {
            dstFrame.textureId = output!.texture.ID
        }
        else {
            dstFrame.textureId = srcFrame.textureId
        }
        return 0
    }
}



