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
    
    func getPositionsThreeDimension(from initialPostion: simd_float4x4, for numberOfTrees: Int = 1, known_positions: [simd_float4x4], scale_compensation: Float = 0.05) -> [simd_float4x4] {
        
        //Positions of the trees of the same group
        var new_occupied_positions : [simd_float4x4] = []
        //Help variable to create the new position for the group
        var new_position : simd_float4x4 = simd_float4x4(1)
        //Help variable to create the new random positions
        var new_position_coordinates : ThreeDimensionPoint = ThreeDimensionPoint(x: 0, y: 0, z:0)
        //Help variable that holds the intial coordinates of the first touch/intial position of the scene
        let initial_coordinates : ThreeDimensionPoint = ThreeDimensionPoint(x: CGFloat(initialPostion.columns.3.x), y: CGFloat(initialPostion.columns.3.y), z:CGFloat(initialPostion.columns.3.z))
        
        //Help variable to control if a new coordinate match the desired distance
        var inside_area : Bool = true
        //Help variable to control the amount of times the calculations of the new positions are made
        var tries: Int = 0
        
        //Range of the random numbers to be created, is also the distance from the initial position that the new trees will be
        let range : Float = scale_compensation * 2.0
        //Minimum distance that all trees need to have (So other trees don't get placed in the same position and can be seen as separated)
        let min_distance : Float = scale_compensation
        //Maximum disance that any tree could be from the first touch/initial position of the same group
        let max_distance_from_initial : Float = (scale_compensation*Float(numberOfTrees)) * 3
        //Maximum disance that any tree could be from their brothers of the same group
        let max_distance_from_group : Float = (scale_compensation*Float(numberOfTrees)) * 4
        //Maximum disance that any tree could be from other trees that already exist in the scene
        let max_distance_for_other_areas : Float = (scale_compensation*Float(numberOfTrees)) * 5
        
        
        //Check if initial position is in the same place as others trees.
        let available_initial_spot : Bool = self.verify_distance_with_other_positions(positions_to_compare: known_positions, new_coordinates: initial_coordinates, min_distance: min_distance, max_distance: max_distance_for_other_areas)
        
        //If initial spot is available
        if(available_initial_spot){
            
            //Now that I know that the first position is available, I can add it to the array that will hold all the positions of all trees. Now my array has 1 element, the first touch/ first position of the first tree
            new_occupied_positions.append(initialPostion)
            
            //This variable represents the limit of positions that the algorithm will create, see it as another number of trees.
            // So, if number of trees is 5, I have to rest 1 because I already added the first position of the first tree (the first touch) to the array that holds all the positions. So now, I need 4 more positions, so the limit variable should have a value of 4.
            //But remember that the for that we will use in the future, starts with 0, so we need to rest 1 more value to the limit variable, otherwise we will create 5 positions more and not 4. Because, 0,1,2,3,4 are 5 positons, and we need 4, wich are 0,1,2,3
            //So finally, our limit variable, needs to be rested 2 numbers of the numbers of trees inital variable
            let limit = numberOfTrees-2
            
            //Now, if the number of trees were 1, then the limit will be -1. So it's okay because we will not enter this part of the code, and new positions woudn't be created. It's okay
            //Now, if the number of trees were 2, then the limit will be 0. So it's okay because one new positions will be created. It's okay
            //Now, if the number of trees were 5, then the limit will be 3. So it's okay because three new positions will be created. It's okay
            if(limit>=0){
                
                //This cycle will create new positons for each tree
                for _ in 0...(limit) {
                    
                    //Restart the number of tries, (so a each tree has the same amount of tries)
                    tries=0
                    
                    //Do while that will repeat any time that a new random positions don't fulfill the desired distance parameters
                    repeat {
                        
                        //Restart a variable that holds the boolean result of the calculation of the distances
                        inside_area=true
                        
                        //A new position (their coordinates) is created randomly, the random number is summed to the original number of the initial position.
                        //Note: This happens because, all of the values are in relation with the camera, so the initial position is also in relation with the camera, so let's say that the value of the initial position away from the camera is  5,00. If I just create a new number with a value of 1, the new tree will be placed super close with the camera, which is not the result I need. I want the new trees to be around the initial positions. So that's why I sum a new random number to the initial positions, so in this example, let's say the random number is 0,5. Then the new tree will be 5,50 away from the camera, and 0,5 away from the initial posiiton
                        new_position_coordinates = ThreeDimensionPoint.init(x: CGFloat(Float(initial_coordinates.x) + Float.random(in: -range...range)), y: CGFloat(Float(initial_coordinates.y)), z:CGFloat(Float(initial_coordinates.z) + Float.random(in: -range...range)))
                        
                        //Check if new coordinates is close to initial position
                        inside_area=self.verify_distance_with_other_positions(positions_to_compare: [initialPostion], new_coordinates: new_position_coordinates, min_distance: min_distance, max_distance: max_distance_from_initial)
                        
                        if(inside_area){
                            //Check if new coordinates is close to other trees of the same group are close
                            inside_area=self.verify_distance_with_other_positions(positions_to_compare: new_occupied_positions, new_coordinates: new_position_coordinates, min_distance: min_distance, max_distance: max_distance_from_group)
                            
                            if(inside_area){
                                //Check if new coordinates is close to already existing positions in the Scene
                                inside_area=self.verify_distance_with_other_positions(positions_to_compare: known_positions, new_coordinates: new_position_coordinates,min_distance:min_distance,max_distance: max_distance_for_other_areas)
                            }
                            
                        }
                        
                        tries+=1
                        
                    }while(inside_area==false && tries<=20)
                    //If the new position fulfill the distance parameters OR more than 20 tries were done, then we exit, we stop creating new random numbers and checking.
                    
                    //If the reason of the exit is that the number of tries were more than 20, let's say 21. Then we don't need to spend more time trying to creat new random numbers because it may be a zone where there is a lot of trees, so we return.
                    if(tries>20){
                        print("More than 20 tries were done for nº \(new_occupied_positions.count) tree")
                        //This exit, return means that more than 20 tries were done to create a random number and still didn't fulfill the distance parameters
                        return []
                    }
                    print("New position")
                    print(new_position)
                    //Create a new Position based on the new coordiantes (random) previously created. In resume, this is basically passing the positions to the right object.
                    new_position.columns.3.x = Float(new_position_coordinates.x)
                    new_position.columns.3.y = Float(initial_coordinates.y) //The height is is the same than the initial position, because we want all the trees of the same group to be at the same level. Not one 0,5 meters upside of the others like if the were floating. They should all be on the same surface.
                    new_position.columns.3.z = Float(new_position_coordinates.z)
                    
                    //Add the new position to the positions of the group
                    new_occupied_positions.append(new_position)
                    
                    //A this point, a new position has been created successfully, so we'll repeat the process in case a new position is required.
                }
                
            }//end if of limit>=0
            
            //There is no else here, beacuse, in case the case that just 1 tree were added by the user the inital position/ first touch represents that unique tree, so is already added in the array that holds all the positions of the group. So we can return the array, with the 1 position that the user needed.
            
            //In case, we get here, by creating all the positions of all trees. Then the last thing to do, is return the array that have all the positions of the group.
            
            return new_occupied_positions
            
            //If initial spot is not available
        }else{
            
            //Print a message or show the user this message, and return an empty array. Whenever this function gets called, the return object is verified, if it's empty (like this) means the inital position is not available.
            print("Initial spot not available")
            return []
        }
        
    }
    
    
    private func verify_distance_with_other_positions(positions_to_compare: [simd_float4x4], new_coordinates : ThreeDimensionPoint, min_distance: Float, max_distance : Float) -> Bool {
        
        var old_coordinates : ThreeDimensionPoint = ThreeDimensionPoint(x: 0, y: 0, z:0)
        var distance_between_points : CGFloat = 0.0
        
        //If the array with the positions to compare is empty, then there is nothing to compare.
        if (positions_to_compare.count>0){
        
            //Iterate the array of the positions to compare. Because the first position is 0, the last has to be, the amount of elements - 1
            for index in 0...(positions_to_compare.count-1) {
                
                //Get the 3 coordinates we need from the position of the array, so a calculation of the distance between them could be made.
                old_coordinates = ThreeDimensionPoint.init(x: CGFloat(Float(positions_to_compare[index].columns.3.x)), y: CGFloat(Float(positions_to_compare[index].columns.3.y)), z:CGFloat(Float(positions_to_compare[index].columns.3.z)))
                
                //Calculate distance from new position to the other positions so it's separated at an appropriate distance
                distance_between_points = old_coordinates.distanceTo(from: new_coordinates , to: old_coordinates)
                
                //If distance between the two points is less than the minimum and greater than the maximum then, return a false, saying that the new position doesn't fulfill the distance requirements.
                if(distance_between_points < CGFloat(min_distance) || distance_between_points > CGFloat(max_distance)){
                    return false
                }
            }
        }
        
        return true
    }
    
    //Method to Scale an achor Randomly
    func scaleObjectRandomnly(old_matrix: simd_float4x4) -> simd_float4x4{
        
        //Create a new matrix, beacuse it can't be edited the old one, which is normally the initial position.
        var new_matrix : simd_float4x4 = old_matrix
        //Variables that will hold the values of the old matrix of the initial position, but always in positive. So a third operation is used to see if it's less than zero, is mutiplicated by -1 to make it positive, otherwise, it's the same value.
        let scale_x : Float = old_matrix.columns.0.x < 0 ? (old_matrix.columns.0.x*(-1)) : old_matrix.columns.0.x
        let scale_y : Float = old_matrix.columns.1.y < 0 ? (old_matrix.columns.1.y*(-1)) : old_matrix.columns.1.y
        let scale_z : Float = old_matrix.columns.2.z < 0 ? (old_matrix.columns.2.z*(-1)) : old_matrix.columns.2.z
        
        //A new random number of the scale is created, the random number will be between the old number of the initial position and the double. So a little randomness exist between the trees of the same group (that supposly have the same scale, but needs to still be, a little different)
        new_matrix.columns.0.x = Float.random(in: scale_x...(scale_x*2.0))
        new_matrix.columns.1.y = Float.random(in: scale_y...(scale_y*2.0))
        new_matrix.columns.2.z = Float.random(in: scale_z...(scale_z*2.0))
        
        return new_matrix
    }
    
    //Method to Rotate an achor Randomly (Just follow)
    func rotateObject(old_matrix: simd_float4x4) -> simd_float4x4{
        
        var new_matrix : simd_float4x4 = old_matrix
        
        let a = Float(cos(Float.pi/3))
        let b = Float(sin(Float.pi/3))
        
        new_matrix.columns.0.x = a
        new_matrix.columns.2.x = -b
        new_matrix.columns.0.z = b
        new_matrix.columns.2.z = a
        
        return new_matrix
    }
    
    //Old method, don't pay attention to here
    func equal_scale(old_matrix: simd_float4x4) -> simd_float4x4{
        var new_matrix : simd_float4x4 = old_matrix
        new_matrix.columns.0.x = 0.1
        new_matrix.columns.1.y = 0.1
        new_matrix.columns.2.z = 0.1
        return new_matrix
    }
    
    //Old method, don't pay attention to here
    func scaleObjectWithScale(old_matrix: simd_float4x4, scale_compensation: Double) -> simd_float4x4{
        
        var new_matrix : simd_float4x4 = old_matrix
        let scale_x : Float = old_matrix.columns.0.x
        let scale_y : Float = old_matrix.columns.1.y
        let scale_z : Float = old_matrix.columns.2.z
        
        print("Before Scale x: \(scale_x) y: \(scale_y) z: \(scale_z) ")
        print("Scale compensation: \(scale_compensation)")
        
        new_matrix.columns.0.x = scale_x * Float(scale_compensation)
        new_matrix.columns.1.y = scale_y * Float(scale_compensation)
        new_matrix.columns.2.z = scale_z * Float(scale_compensation)
        
        print("After Scale x: \(new_matrix.columns.0.x) y: \(new_matrix.columns.1.y) z: \(new_matrix.columns.2.z) ")
        
        return new_matrix
    }
    
}

//Auxiliar Class

class ThreeDimensionPoint {
    
    public var x: CGFloat
    public var y: CGFloat
    public var z : CGFloat
    
    public init(x: CGFloat, y: CGFloat, z: CGFloat){
        self.x = x
        self.y = y
        self.z = z
    }
    
    init() {
        self.x = 0.0
        self.y = 0.0
        self.z = 0.0
    }
    
    //Method to calculate the distance between two 3D points, it follows Pitagoras Theoreme.
    func distanceSquared(from: ThreeDimensionPoint, to: ThreeDimensionPoint) -> CGFloat {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y) + (from.z - to.z) * (from.z - to.z)
    }
    
    //Method to calculate the distance between two points.
    func distanceTo(from: ThreeDimensionPoint, to: ThreeDimensionPoint) -> CGFloat {
        return sqrt(distanceSquared(from: from, to: to))
    }
    
    //Return the values of a 3D Point as a string, for debug purposes.
    func getCoordinates()-> String{
        return String("\(self.x) \(self.y) \(self.z)")
    }
}
