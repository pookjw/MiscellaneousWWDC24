//
//  Face.swift
//  MiscellaneousMRUIKit
//
//  Created by Jinwoo Kim on 2/10/25.
//

/*
   +---------------+
  /|              /|
 / |     4       / |
 +--------------+  |
 | |            |  |
 |1|      5     | 2|
 | |            |  |
 | |    6       |  |
 | +------------|--+
 |/      3      | /
 +--------------+/
 
   y+
   |
   +- x+
  /
 z+
 
 lHandFace : 1
 rHandFace : 2
 lowerFace : 3
 upperFace : 4
 nearFace : 5
 afarFace : 6
 */

enum Face: String, CaseIterable, Identifiable {
    case lHandFace, rHandFace, lowerFace, upperFace, nearFace, afarFace
    
    var id: String { rawValue }
}
