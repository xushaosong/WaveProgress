//
//  WaveView.swift
//  WaveProgress
//
//  Created by xss@ttyhuo.cn on 2017/1/9.
//  Copyright © 2017年 xss@ttyhuo.cn. All rights reserved.
//

import UIKit

class WaveView: UIView {

    let layer1: CAShapeLayer = CAShapeLayer();
    let layer2: CAShapeLayer = CAShapeLayer();
    
    let grayLabel: UILabel = UILabel();
    let topLabel: UILabel = UILabel();
    let bottom: UILabel = UILabel();
    
    var h: CGFloat = 0;
    var progress: CGFloat = 0 {
        didSet {
            grayLabel.text = "\(progress) %";
            topLabel.text = "\(progress) %";
            bottom.text = "\(progress) %";
            
            h = self.frame.size.height * (1 - progress / 100)
            
            if (progress >= 100) {
                doStopAnim();
            }
        }
    }
    var font: UIFont = UIFont.boldSystemFont(ofSize: 50) {
        didSet {
            grayLabel.font = font;
            topLabel.font = font;
            bottom.font = font;
        }
    }
    
    override var frame: CGRect {
        didSet {
            grayLabel.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.width)
            topLabel.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.width)
            bottom.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.width)
            
            layer1.frame = topLabel.frame;
            layer2.frame = bottom.frame;
            
            h = frame.size.height;
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        h = self.frame.size.height;
        self.layer.cornerRadius = frame.size.width/2;
        self.layer.masksToBounds = true;
        
        grayLabel.text = "0 %";
        grayLabel.textColor = UIColor.gray;
        grayLabel.backgroundColor = UIColor.red;
        grayLabel.font = font;
        grayLabel.textAlignment = .center;
        grayLabel.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.width)
        self.addSubview(grayLabel);
        
        topLabel.text = "0 %";
        topLabel.textColor = UIColor.green;
        topLabel.backgroundColor = UIColor.blue;
        topLabel.font = font;
        topLabel.textAlignment = .center;
        topLabel.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.width)
        topLabel.layer.mask = layer1;
        layer1.frame = topLabel.frame;
        self.addSubview(topLabel);
        
        bottom.text = "0 %";
        bottom.textColor = UIColor.blue;
        bottom.backgroundColor = UIColor.green;
        bottom.font = font;
        bottom.textAlignment = .center;
        bottom.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.width)
        layer2.frame = bottom.frame;
        bottom.layer.mask = layer2;
        self.addSubview(bottom);
        
        wave();
    }
    
    
    var link: CADisplayLink?;
    var offset: CGFloat = 10;
    let speed: CGFloat = 20;
    var waveWidth: CGFloat = 0;
    var waveHeight: CGFloat = 0;
    
    func wave() {
        link = CADisplayLink(target: self, selector: #selector(doAni));
        link?.add(to: RunLoop.current, forMode: RunLoopMode.commonModes);
    }
    func doAni() {
        waveWidth = self.frame.size.width;
        waveHeight = 5;
        
        offset += speed;
        
        /*
         正弦型函数解析式：y=Asin（ωx+φ）+h
         各常数值对函数图像的影响：
         φ（初相位）：决定波形与X轴位置关系或横向移动距离（左加右减）
         ω：决定周期（最小正周期T=2π/|ω|）
         A：决定峰值（即纵向拉伸压缩的倍数）
         h：表示波形在Y轴的位置关系或纵向移动距离（上加下减）
         */
        let pathRef: CGMutablePath = CGMutablePath();
        let startY = Double(waveHeight) * sin(Double(offset) * M_PI / Double(waveWidth));
        pathRef.move(to: CGPoint(x: 0, y: startY));
        
        var i: CGFloat = 0.0;
        while i <= waveWidth {
            
            let y = 1.1 * Float(waveHeight) * sinf((Float(2.5 * M_PI * Double(i) / Double(waveWidth))) + Float((Double(offset) * M_PI / Double(waveWidth)))) + Float(h);
            i += 0.1;
            pathRef.addLine(to: CGPoint(x: i, y: CGFloat(y)));
        }
        pathRef.addLine(to: CGPoint(x: waveWidth, y: 0))
        pathRef.addLine(to: CGPoint(x: 0, y: 0))
        pathRef.closeSubpath();
        layer1.path = pathRef;
        layer1.fillColor = UIColor.lightGray.cgColor;
        layer1.strokeColor = UIColor.lightGray.cgColor;
        
        let pathRef2: CGMutablePath = CGMutablePath();
        let startY2 = Double(waveHeight) * sin(Double(offset) * M_PI / 3.0 / Double(waveWidth));
        pathRef2.move(to: CGPoint(x: 0, y: startY2));
        
        var j: CGFloat = 0.0;
        while j <= waveWidth {
            
            let y2 = 1.1 * Float(waveHeight) * sinf((Float(2.5 * M_PI * Double(j) / Double(waveWidth))) + Float((Double(offset) * M_PI / Double(waveWidth))) + Float(M_PI / 3.0)) + Float(h);
            j += 0.1;
            pathRef2.addLine(to: CGPoint(x: j, y: CGFloat(y2)));
        }

        pathRef2.addLine(to: CGPoint(x: waveWidth, y: bottom.frame.size.height))
        pathRef2.addLine(to: CGPoint(x: 0, y: bottom.frame.size.height))
        pathRef2.closeSubpath();
        layer2.path = pathRef2;
        layer2.fillColor = UIColor.lightGray.cgColor;
        layer2.strokeColor = UIColor.green.cgColor;
        
    }
    func doStopAnim() {
        link?.invalidate();
        link = nil;
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
