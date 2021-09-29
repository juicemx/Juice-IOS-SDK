//
//  web3+completion.swift
//  juiceWallet
//
//  Created by Ned on 8/12/2018.
//  Copyright © 2018 ju. All rights reserved.
//

import Foundation


public enum JuiceCommonResult : Error{
    case success
    case fail(Int?, String?)
}

public typealias JuiceCommonCompletionV2<T> = (_ result: JuiceCommonResult, _ data: T) -> Void
public typealias JuiceCommonCompletion = (_ result : JuiceCommonResult, _ obj : AnyObject?) -> ()


