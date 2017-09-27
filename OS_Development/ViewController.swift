//
//  ViewController.swift
//  OS_Development
//
//  Created by 杨清宇 on 2017/9/7.
//  Copyright © 2017年 Herbius. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleTypingANumber:Bool = false   //用户是否在进行输入相关计算数字
    
    @IBAction func appendDigit(_ sender: UIButton) {  //UIbutton 传递一个参数
        let digit = sender.currentTitle!
        if(userIsInTheMiddleTypingANumber){
            display.text = display.text!+digit
        }
        else{
            display.text = digit
            userIsInTheMiddleTypingANumber = true
        }
    }
    
    @IBAction func operate(_ sender: UIButton) {  //运算符计算函数
        
        let operation = sender.currentTitle!
        if userIsInTheMiddleTypingANumber{
            Enter()
        }
        switch operation {
        case "+": preformOperation(operation: {(op1,op2) in op1 + op2})
        //编译器知道preformOPeration 的返回类型 之后可以删除这个值 Swift 不强制给两个参数命名 所以可以更改为  ￥0 ￥1...来替代相关参数
        //可以替换为只有两个参数  prefermOperation({opq1+op2})   注意大括号的使用
        //可以替换为preformOperaton {op1 +op2}  因为 已经定义了一个叫做preformOperation的函数
        //preformOperation(operation: {(op1,op2) in op1 + op2})
        case "-": preformOperation(operation: {(op1,op2) in op2 - op1})
        case "×": preformOperation(operation: {(op1,op2) in op1 + op2})
        case "÷": preformOperation(operation: {(op1,op2) in op2 / op1})
        case "√": preformOperation(operation: {(op1) in sqrt(op1)})
        default: break
        }
    }
    
    @objc(performOperationWithTwoOperand:)func preformOperation(operation: (Double, Double) ->Double){
        if(operandStack.count)>=2{
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            Enter()
        }
    }
    
    @objc(performOperationWithOneOperand:) func preformOperation(operation: (Double) ->Double){
        if(operandStack.count)>=1{
            displayValue = operation(operandStack.removeLast())
            Enter()
        }
    }  //函数重载  因为xcode的编译选择器发生更改，那么需要提前选择并声明编译器
    
    var operandStack = Array<Double>()
    
    @IBAction func Enter() {                            //输入函数
        userIsInTheMiddleTypingANumber = false
        operandStack.append(displayValue)
        print("operandStack = \(operandStack)")
    }
    
    var displayValue: Double{                           //显示函数
        get{
            return NumberFormatter().number(from: display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
            userIsInTheMiddleTypingANumber = false
        }
    
    }
    
    
    
    
}

