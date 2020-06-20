//
//  TargetViewController.swift
//  VOGtarget
//
//  Created by kuroda tatsuaki on 2019/04/14.
//  Copyright © 2019 tatsuaki.kuroda. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
class TargetViewController: UIViewController {
    
    var timer: Timer!
    var startTime=CFAbsoluteTimeGetCurrent()
    var lastTime=CFAbsoluteTimeGetCurrent()
    var cirDiameter:CGFloat = 0
    var ettW:CGFloat = 0
    var tcount: Int = 0
    var tapInterval=CFAbsoluteTimeGetCurrent()
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
 @available(iOS 11, *)
    override var prefersHomeIndicatorAutoHidden: Bool {
        get {
            return true
        }
    }
    //   var ettWidth:Int = 2//1:narrow,2:wide
    func delTimer(){
        if timer?.isValid == true {
            timer.invalidate()
        }
    }
    func drawRect(rectB: CGRect) {
        let rectLayer = CAShapeLayer.init()
        rectLayer.strokeColor = UIColor.white.cgColor
        rectLayer.fillColor = UIColor.white.cgColor
        rectLayer.lineWidth = 0
        rectLayer.path = UIBezierPath(rect:rectB).cgPath
        self.view.layer.addSublayer(rectLayer)
    }
    @IBAction func doubleTap(_ sender: Any) {
        let mainView = storyboard?.instantiateViewController(withIdentifier: "mainView") as! ViewController
        delTimer()
        if UIApplication.shared.isIdleTimerDisabled == true{
                  UIApplication.shared.isIdleTimerDisabled = false//スリープする
        }
        self.present(mainView, animated: false, completion: nil)
    }
 
    override func remoteControlReceived(with event: UIEvent?) {
        guard event?.type == .remoteControl else { return }
        
        if let event = event {
            
            switch event.subtype {
            case .remoteControlPlay:
                print("Play")
                if (CFAbsoluteTimeGetCurrent()-tapInterval)<0.3{
                    print("doubleTapPlay")
                    doubleTap(0)
                    //                    self.dismiss(animated: true, completion: nil)
                }
                tapInterval=CFAbsoluteTimeGetCurrent()
            case .remoteControlTogglePlayPause:
                print("TogglePlayPause")
                if (CFAbsoluteTimeGetCurrent()-tapInterval)<0.3{
                    print("doubleTapTogglePlayPause")
                    doubleTap(0)
                    //                    self.dismiss(animated: true, completion: nil)
                }
                tapInterval=CFAbsoluteTimeGetCurrent()
            default:
                print("Others")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSize()
        drawRect(rectB: CGRect(x:0,y:0,width:view.bounds.width,height:view.bounds.height))
        startTime=CFAbsoluteTimeGetCurrent()
        lastTime=CFAbsoluteTimeGetCurrent()
        timer = Timer.scheduledTimer(timeInterval: 1.0/120.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        tcount=0
        if UIApplication.shared.isIdleTimerDisabled == false{
            UIApplication.shared.isIdleTimerDisabled = true//スリープしない
        }
        UIApplication.shared.beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
        tapInterval=CFAbsoluteTimeGetCurrent()-1
        self.setNeedsStatusBarAppearanceUpdate()
    }

    var rand:Int=0
    var lastrand:Int=0
    var initf:Bool=false
    @objc func update(tm: Timer) {
        if initf {
            view.layer.sublayers?.removeLast()
        }
        initf=true
        tcount += 1
        let elapset=CFAbsoluteTimeGetCurrent()-startTime
        if elapset<20.0 {//}(tcount<60*20){
            let sinV=sin(CGFloat(elapset)*3.1415*0.6)
            //let sinV=sin(CGFloat(tcount)*0.03183)//0.3Hz
            let cPoint:CGPoint = CGPoint(x:view.bounds.width/2 + sinV*ettW, y: view.bounds.height/2)
            drawCircle(cPoint:cPoint)
        }else if elapset<40.0 {//}(tcount<60*20*2){
            //    if Int(elapset) != Int(lastTime){
            if Int(elapset)%2 == 0{// }(tcount/60)%2==0){
                let cPoint:CGPoint = CGPoint(x:view.bounds.width/2 + ettW, y: view.bounds.height/2)
                drawCircle(cPoint:cPoint)
            }else{
                let cPoint:CGPoint = CGPoint(x:view.bounds.width/2 - ettW, y: view.bounds.height/2)
                drawCircle(cPoint:cPoint)
            }
            //  }
        }else if elapset<60 {//}(tcount<60*20*3){
            
            if Int(elapset) != Int(lastTime){
                rand = Int.random(in: 0..<5) - 2
                if(lastrand==rand){
                    rand += 1
                    if(rand > 2){
                        rand = -2
                    }
                }
            }
            let cg=CGFloat(rand)/2.0
            lastrand=rand
            let cPoint:CGPoint = CGPoint(x:view.bounds.width/2 - cg*ettW, y: view.bounds.height/2)
            drawCircle(cPoint:cPoint)
        }else if elapset<65{
            let cPoint:CGPoint = CGPoint(x:view.bounds.width/2, y: view.bounds.height/2)
            drawCircle(cPoint:cPoint)
            //self.dismiss(animated: true, completion: nil)
        }else{
            delTimer()
            doubleTap(0)
        }
        lastTime=elapset
    }
    
    func setSize(){
        ettW = view.bounds.width*17/40
        cirDiameter=view.bounds.width/20
    }
    
    
    func drawCircle(cPoint:CGPoint){
        /* --- 円を描画 --- */
        let circleLayer = CAShapeLayer.init()
        let circleFrame = CGRect.init(x:cPoint.x-cirDiameter/2,y:cPoint.y-cirDiameter/2,width:cirDiameter,height:cirDiameter)
        circleLayer.frame = circleFrame
        // 輪郭の色
        circleLayer.strokeColor = UIColor.white.cgColor
        // 円の中の色
        circleLayer.fillColor = UIColor.red.cgColor
        // 輪郭の太さ
        circleLayer.lineWidth = 0.5
        // 円形を描画
        circleLayer.path = UIBezierPath.init(ovalIn: CGRect.init(x: 0, y: 0, width: circleFrame.size.width, height: circleFrame.size.height)).cgPath
        self.view.layer.addSublayer(circleLayer)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setSize()
        //        ettW = view.bounds.width*8/20
        //        cirDiameter=view.bounds.width/20
        coordinator.animate(
            alongsideTransition: nil,
            completion: {(UIViewControllerTransitionCoordinatorContext) in
                self.setSize()
                //self.ettW = self.view.bounds.width*8/20
                //self.cirDiameter=self.view.bounds.width/20
                //self.setRotate()
        }
        )
    }
}

