//
//  ViewController.swift
//  WaveProgress
//
//  Created by xss@ttyhuo.cn on 2017/1/9.
//  Copyright © 2017年 xss@ttyhuo.cn. All rights reserved.
//

import UIKit

func delay(time: TimeInterval, complete: @escaping ()->Void) {
    
    let deadlineTime = DispatchTime.now() + .seconds(Int(time));
    DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {() -> Void in
        complete();
    })
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let v = WaveView(frame: CGRect(x: 100, y: 100, width: 200, height: 200));
        self.view.addSubview(v);
        
        let timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { (timer) in
            if (v.progress >= 100.0) {
                return;
            }
            v.progress += 1
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

