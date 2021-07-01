//
//  ReforestationSettings.swift
//  reforestar
//
//  Created by Matias Ariel Ortiz Luna on 29/06/2021.
//

import Foundation
import ARKit
import UIKit
import SwiftUI

class ReforestationSettings {
    
    func getPositionsThreeDimension(from initialPostion: simd_float4x4, for numberOfTrees: Int = 1) -> [simd_float4x4] {
        
        //Initialize Variables
        var usedPositions : [simd_float4x4] = []
        var newPosition : simd_float4x4 = simd_float4x4(1)
        
        var newNumber : ThreeDimensionPoint = ThreeDimensionPoint(x: 0, y: 0, z:0)
        var oldNumber : ThreeDimensionPoint = ThreeDimensionPoint(x: 0, y: 0, z:0)
        var distance : CGFloat = 0.0
        
        var match : Bool = false
        
        usedPositions.append(initialPostion)
        
        if(numberOfTrees<=1){
            return usedPositions
        }
        
        for tree in 0...(numberOfTrees-2) {
            
            distance = 0.0
            newNumber = ThreeDimensionPoint(x: 0, y: 0, z:0)
            
            repeat {
                match=false
                
                newNumber = ThreeDimensionPoint.init(x: CGFloat(Float.random(in: -0.2...0.01)), y: CGFloat(Float.random(in: -0.1...0.1)), z:CGFloat(Float.random(in: -0.2...0.01)))
                                    
                for usedPosition in usedPositions {
                    
                        oldNumber = ThreeDimensionPoint.init(x: CGFloat(Float(usedPosition.columns.3.x)), y: CGFloat(Float(usedPosition.columns.3.y)), z:CGFloat(Float(usedPosition.columns.3.z)))
                        
                        //Calculate distance from new position to old positions so it's separated at an appropriate distance
                    distance = oldNumber.ThreeDimensionPointDistance(from: oldNumber, to: newNumber)
                        
                        //If distance is not good, then, do it again
                    if(distance<0.05 && distance>0.2){
                        match=true
                    }
                }
                
            }while(match==true)
            
            //Create a new Position
            newPosition.columns.3.x = initialPostion.columns.3.x + Float(newNumber.x)
            //newPosition.columns.3.x = (newNumber.x<0.0 && initialPostion.columns.3.x<0.0) ? Float(initialPostion.columns.3.x-Float(newNumber.x)) : Float(initialPostion.columns.3.x+Float(newNumber.x))
            
            //newPosition.columns.3.y = newNumber.y<=0 ? Float(oldNumber.y-newNumber.y) : Float(oldNumber.y+newNumber.y)
            newPosition.columns.3.y = initialPostion.columns.3.y
            //newPosition.columns.3.z = initialPostion.columns.3.z + Float(newNumber.z)
            newPosition.columns.3.z = (newNumber.z<0.0 && initialPostion.columns.3.z<0.0) ? Float(initialPostion.columns.3.z-Float(newNumber.z)) : Float(initialPostion.columns.3.z+Float(newNumber.z))
            
            //Add the new position to the known positions
            usedPositions.append(newPosition)
        }
        
        return usedPositions
    }
    
    
    func scaleObject(old_matrix: simd_float4x4) -> simd_float4x4{
        
        var new_matrix : simd_float4x4 = old_matrix
        let scale_x : Float = old_matrix.columns.0.x
        let scale_y : Float = old_matrix.columns.1.y
        let scale_z : Float = old_matrix.columns.2.z
        
        new_matrix.columns.0.x = Float.random(in: scale_x...(scale_x*1.5))
        new_matrix.columns.1.y = Float.random(in: scale_y...(scale_y*1.5))
        new_matrix.columns.2.z = Float.random(in: scale_z...(scale_z*1.5))
        
        return new_matrix
    }
    
    func rotateObject(old_matrix: simd_float4x4) -> simd_float4x4{
        
        var new_matrix : simd_float4x4 = old_matrix
        let rotate_1y : Float = old_matrix.columns.1.y
        let rotate_1z : Float = old_matrix.columns.1.z
        let rotate_2y : Float = old_matrix.columns.2.y
        let rotate_2z : Float = old_matrix.columns.2.z
        
        new_matrix.columns.1.y = Float(cos(90.0 * Double.pi / 180))
        new_matrix.columns.1.z = Float(sin(90.0 * Double.pi / 180))
        new_matrix.columns.2.y = Float(cos(90.0 * Double.pi / 180))
        new_matrix.columns.2.z = Float((asin(1) * (180.0 / Double.pi)))
     
        return new_matrix
    }
    
}

class ThreeDimensionPoint {
    
    public var x: CGFloat

    public var y: CGFloat
    
    public var z : CGFloat

    public init(x: CGFloat, y: CGFloat, z: CGFloat){
        self.x = x
        self.y = y
        self.z = z
    }

    func ThreeDimensionPointDistanceSquared(from: ThreeDimensionPoint, to: ThreeDimensionPoint) -> CGFloat {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y) + (from.z - to.z) * (from.z - to.z)
    }
    
    func ThreeDimensionPointDistance(from: ThreeDimensionPoint, to: ThreeDimensionPoint) -> CGFloat {
        return sqrt(ThreeDimensionPointDistanceSquared(from: from, to: to))
    }
    
}
