import UIKit
import AVKit
@objc(RHDVisionView)
class RHDVisionView: UIView {
    var pl:AVCaptureVideoPreviewLayer?
    var manager: RHDVisionManager?
    var onStart: RCTBubblingEventBlock?
    func setCameraFront(_ isFront: Bool) {
        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) { success in
            guard success else { return }
            guard
                let device = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: isFront ? AVCaptureDevice.Position.front : AVCaptureDevice.Position.back),
                let input = try? AVCaptureDeviceInput(device: device)
                else { return }
            let s = AVCaptureSession()
            s.addInput(input)
            s.startRunning()
            guard let pl = AVCaptureVideoPreviewLayer(session: s)  else { return }
            self.addPreviewLayer(pl)
        }
    }
    func addPreviewLayer(_ pl: AVCaptureVideoPreviewLayer?) {
        if let pl = pl {
            DispatchQueue.main.async(){
                pl.frame = self.bounds
                pl.videoGravity = AVLayerVideoGravityResizeAspectFill
                self.layer.addSublayer(pl)
                self.pl = pl
                if let o = self.onStart { o([:]) }
            }
        }
    }
    func cancel() {
        if let pl = self.pl {
            pl.removeFromSuperlayer();
        }
        if let manager = self.manager {
            manager.closedView(self)
        }
    }
}