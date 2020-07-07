//
//  OknViewController.swift
//  VOGtarget
//
//  Created by 黒田建彰 on 2020/01/18.
//  Copyright © 2020 tatsuaki.kuroda. All rights reserved.
//

import UIKit

class OknViewController: UIViewController {
    var timer:Timer!
    var startTime=CFAbsoluteTimeGetCurrent()
    var lastTime=CFAbsoluteTimeGetCurrent()
    var cnt:Int = 0
    var oknSpeed:Int = 2
    var speed:Int=0
    var oknTime:Int = 0
    var oknMode:Int=0
    var ww:CGFloat=0
    var wh:CGFloat=0
    //    @IBOutlet weak var timerPara: UILabel!
    
    @IBOutlet var doubleRec:UITapGestureRecognizer!
    var tapInterval=CFAbsoluteTimeGetCurrent()
    
    @IBAction func doubleTap(_ sender: Any) {
        let mainView = storyboard?.instantiateViewController(withIdentifier: "mainView") as! ViewController
        if timer?.isValid == true {
            timer.invalidate()
        }
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
                    doubleTap(0)
                }
                tapInterval=CFAbsoluteTimeGetCurrent()
            case .remoteControlTogglePlayPause:
                print("TogglePlayPause")
                if (CFAbsoluteTimeGetCurrent()-tapInterval)<0.3{
                    doubleTap(0)
                }
                tapInterval=CFAbsoluteTimeGetCurrent()
            case .remoteControlNextTrack:
                oknSpeed += 1
                if(oknSpeed>200){
                    oknSpeed=200
                }
                speed=15*oknSpeed
                UserDefaults.standard.set(oknSpeed, forKey: "oknSpeed")
            case .remoteControlPreviousTrack:
                //stopTimer()
                oknSpeed -= 1
                if(oknSpeed<1){
                    oknSpeed=1
                }
                speed=oknSpeed*15
                UserDefaults.standard.set(oknSpeed, forKey: "oknSpeed")
            //                setTimer()
            default:
                print("Others")
            }
        }
    }
    
    func stopTimer(){
        if timer?.isValid == true {
            timer.invalidate()
        }
        cnt=0
    }
    func setTimer(){
        startTime=CFAbsoluteTimeGetCurrent()
        ww=view.bounds.width
        wh=view.bounds.height
        let displayLink = CADisplayLink(target: self, selector: #selector(self.update))   //#selector部分については後述
          displayLink.preferredFramesPerSecond = 120  // FPS設定  //この場合は1秒間に20回
          displayLink.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
        
//        timer = Timer.scheduledTimer(timeInterval: 1.0/120.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        cnt=0
    }
    
    func drawBand(rectB: CGRect) {
        let rectLayer = CAShapeLayer.init()
        rectLayer.strokeColor = UIColor.black.cgColor
        rectLayer.fillColor = UIColor.black.cgColor
        rectLayer.lineWidth = 0
        rectLayer.path = UIBezierPath(rect:rectB).cgPath
        self.view.layer.addSublayer(rectLayer)
    }
    @available(iOS 11, *)
    override var prefersHomeIndicatorAutoHidden: Bool {
        get {
            return true
        }
    }
  
    var lastx:CGFloat=0
    var currentSpeed:Double = 0
    var initf:Bool=false
    @objc func update(tm: Timer) {
        cnt += 1
        let x0=ww/5
        if initf {
            for _ in 0..<6{
                view.layer.sublayers?.removeLast()
            }
        }
        initf=true
        let currentTime=CFAbsoluteTimeGetCurrent()
        let dTime = currentTime - lastTime
        lastTime = currentTime
        if currentTime - startTime>120{
           if UIApplication.shared.isIdleTimerDisabled == true{
                     UIApplication.shared.isIdleTimerDisabled = false//スリープする
           }
        }
        if oknMode<2 && Int(currentTime - startTime)>oknTime{
            //stopTimer()
            drawBand(rectB:CGRect(x:0,y:0,width:ww,height:wh))
            return
        }
        if oknMode == 0 || oknMode == 2{
            currentSpeed = Double(speed)
        }else{
            currentSpeed = -Double(speed)
        }
        if cnt%10 == 0 {
            print("dx:",currentSpeed*dTime,oknSpeed ,oknTime,oknMode)//okpSpeed, "cuSpe:",currentSpeed)
        }
        
        var x = lastx + CGFloat(currentSpeed * dTime)
        
        //if (x>x0) {
        while x>x0 {
            x -= x0
        }
        //if (x < 0) {
        while x<0 {
            x += x0
        }
        for i in 0..<6 {
            drawBand(rectB:CGRect(x:CGFloat(i-1)*x0+x,y:0,width:ww/10,height:wh))
        }
        lastx=x
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getUserDefault(str:String,ret:Int) -> Int{//getUserDefault_one
        if (UserDefaults.standard.object(forKey: str) != nil){//keyが設定してなければretをセット
            return UserDefaults.standard.integer(forKey:str)
        }else{
            UserDefaults.standard.set(ret, forKey: str)
            return ret
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //       timerPara.isHidden=true
        oknSpeed = getUserDefault(str: "oknSpeed", ret: 100)
        oknTime = getUserDefault(str: "oknTime", ret: 60)
        oknMode = getUserDefault(str: "oknMode", ret: 0)
        
        speed = oknSpeed*15
        if UIApplication.shared.isIdleTimerDisabled == false{
            UIApplication.shared.isIdleTimerDisabled = true//スリープしない
        }
        UIApplication.shared.beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
        tapInterval=CFAbsoluteTimeGetCurrent()-1
        self.setNeedsStatusBarAppearanceUpdate()
    }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            stopTimer()
        }
        
        override func viewDidAppear(_ animated: Bool) {
            setTimer()
        }
    }
