//
//  MathManager.swift
//  Local positioning system
//
//  Created by Леонид Лукашевич on 29.04.2022.
//

import Foundation
import Accelerate

class MathManager {
    
    static func calculateSmallerNumber(of percent: Double, to number: Double) -> Double {
        return (number * percent) / 100
    }
    
    static func calculatePercent(of number: Double, to hundredPercent: Double) -> Double {
        return (number * 100) / hundredPercent
    }
    
    static func calculateDistanceBetweenTwoPoints(first: CGPoint, second: CGPoint, fs: Double, fp: Double, sp: Double) {
        
        let x1 = first.x
        let y1 = first.y
        let x2 = second.x
        let y2 = second.y
        
        if fs != sqrt(pow((x2-x1), 2)+pow((y2-y1), 2)) { return }
        
        
    }
    
    static func calculateHypotenuse(firstPoint: CGPoint, secondPoint: CGPoint) -> Double {
        
        var result: Double
        
        let maxX = max(firstPoint.x, secondPoint.x)
        let maxY = max(firstPoint.y, secondPoint.y)
        let minX = min(firstPoint.x, secondPoint.x)
        let minY = min(firstPoint.y, secondPoint.y)
        
        let first = maxX - minX
        let second = maxY - minY
        
        let rightSide = pow(first, 2) + pow(second, 2)
        
        result = sqrt(rightSide)
        
        return result
    }
    
    static func solveLinearSystem(a: inout [Double],
                                  a_rowCount: Int, a_columnCount: Int,
                                  b: inout [Double],
                                  b_count: Int) throws {
        
        var info = Int32(0)
        
        // 1: Specify transpose.
        var trans = Int8("T".utf8.first!)
        
        // 2: Define constants.
        var m = __CLPK_integer(a_rowCount)
        var n = __CLPK_integer(a_columnCount)
        var lda = __CLPK_integer(a_rowCount)
        var nrhs = __CLPK_integer(1) // assumes `b` is a column matrix
        var ldb = __CLPK_integer(b_count)
        
        // 3: Workspace query.
        var workDimension = Double(0)
        var minusOne = Int32(-1)
        
        dgels_(&trans, &m, &n,
               &nrhs,
               &a, &lda,
               &b, &ldb,
               &workDimension, &minusOne,
               &info)
        
        if info != 0 {
            throw LAPACKError.internalError
        }
        
        // 4: Create workspace.
        var lwork = Int32(workDimension)
        var workspace = [Double](repeating: 0,
                                 count: Int(workDimension))
        
        // 5: Solve linear system.
        dgels_(&trans, &m, &n,
               &nrhs,
               &a, &lda,
               &b, &ldb,
               &workspace, &lwork,
               &info)
        
        if info < 0 {
            throw LAPACKError.parameterHasIllegalValue(parameterIndex: abs(Int(info)))
        } else if info > 0 {
            throw LAPACKError.diagonalElementOfTriangularFactorIsZero(index: Int(info))
        }
    }

    private enum LAPACKError: Swift.Error {
        case internalError
        case parameterHasIllegalValue(parameterIndex: Int)
        case diagonalElementOfTriangularFactorIsZero(index: Int)
    }
}
