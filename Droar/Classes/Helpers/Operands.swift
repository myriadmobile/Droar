//
//  Operands.swift
//  Pods
//
//  Created by Nathan Jangula on 6/6/17.
//
//

import Foundation

func |= (left: inout Bool, right: Bool)
{
    left = left || right
}

func &= (left: inout Bool, right: Bool)
{
    left = left && right
}
