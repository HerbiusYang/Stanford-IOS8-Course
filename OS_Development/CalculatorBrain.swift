//
//  CalculatorBrain.swift
//  OS_Development
//
//  Created by HerbiusYang on 2017/9/27.
//  Copyright © 2017年 Herbius. All rights reserved.
//

import Foundation   //只导入Foundation 作为 core service layer   牢记~ independent
                    //永远不要导入UIKit作为modle的引用层
class CalculatorBrain{
    
    private enum Op : CustomStringConvertible                   //Swift2.0版本以上想要实现descrip打印对象就要添加 CustomStringConvertible协议
    {
        case Operand(Double)                //枚举类与相关数据联系起来 Swift的一大特性
        case UnaryOperation(String,(Double) -> Double)          //与之前的版本不同，在参数设置上需要加括号强制声明只有一个相关参数
        case BinaryOperation(String, (Double,Double) -> Double)
        
        
        var description: String{
            get{
                switch self{
                case .Operand(let operand):
                        return "\(operand)"
                case .BinaryOperation(let symbol, _):
                        return  symbol
                case .UnaryOperation(let symbol, _):
                        return  symbol
                    
                }
            }
        }
        
    }

    private var Opstack = [Op]()                      //Array<Op>()注意这里后边也需要加一个括号
    
    private var knowOps = Dictionary<String,Op>()                  //创建一个一只操作符的栈  当performOperation 执行时在这里查找相应的一直运算符
                                                           //圆括号调用数组的 initializer 方法
    
    init(){
        knowOps["×"]=Op.BinaryOperation("×", *)    //...{$0 * $1})也可以把大括号放到外边  在Swift中所有的符号是一个被声明的函数 所以直接在默认情况下直接调用符号
        knowOps["÷"]=Op.BinaryOperation("÷", {$1/$0})
        knowOps["+"]=Op.BinaryOperation("+", +)
        knowOps["-"]=Op.BinaryOperation("-", {$1-$0})
        knowOps["√"]=Op.UnaryOperation ("√", sqrt) //省略了相关代码
    }
    
    private func evaluate(ops: [Op]) ->(result: Double?,remainingOps: [Op]) {
        if !ops.isEmpty{
            var remainingOps = ops                              //用它来拷贝只要用来赋值的对象不是一个类 就做了结构体的一个复制
            let op = remainingOps.removeLast()
            switch op{
            case .Operand(let operand):
                return (operand,remainingOps)                                     //只剩下一个操作符或者操作数直接返回
            case .UnaryOperation(_, let operation):                               //下划线表示在Swift 中并不在意参数的通用表达 计算两种操作符的递归
                let operandEvaluation = evaluate(ops: remainingOps)
                if let operand = operandEvaluation.result{
                   return (operation(operand),operandEvaluation.remainingOps)
                }
           
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(ops: remainingOps)
                if let operand1 = op1Evaluation.result{
                    let op2Evaluation = evaluate(ops: op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result{
                        return(operation(operand1,operand2),op2Evaluation.remainingOps)
                    }
                }
                
            }
        }
        return (nil,ops)
    }
    
    func evaluate() -> Double? {
        let (result,_) = evaluate(ops :Opstack)       //把Opstack的所有东西传入到那个元组中去
        print("\(Opstack) = \(String(describing: result)) with \(remainder) left over")
        return result
    }
    
    
    func pushOperand(operand: Double) ->Double?{        //需要返回一个evaluate 的值 这个值用做显示相关的压入栈的值或者操作符的最终结果
        Opstack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol :String){
        if let operation = knowOps[symbol]{
            Opstack.append(operation)
        }
    }
}
