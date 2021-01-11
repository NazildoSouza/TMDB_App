//
//  BlurWindow.swift
//  TMDB_App_MacOS
//
//  Created by Nazildo Souza on 12/12/20.
//

import SwiftUI
//import Cocoa
//import AppKit

struct BlurWindow: NSViewRepresentable {
    let blendMode: NSVisualEffectView.BlendingMode
    func makeNSView(context: Context) -> NSVisualEffectView {
        
        let view = NSVisualEffectView()
        view.blendingMode = blendMode
        
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        
    }
}


// Enable Vertical Scrolling For Parent In Scroll View in Nested NSScrollView
// Objective-C Method Swizzling
// https://www.cocoanetics.com/2012/10/nsscrollview-contained-in-nsscrollview/

public extension NSScrollView {

    @objc func _scrollWheel(with event: NSEvent) {
        var shouldForwardScroll = false

        if self.usesPredominantAxisScrolling {
            if abs(event.deltaX) > abs(event.deltaY) {
                if !self.hasHorizontalScroller {
                    shouldForwardScroll = true
                }

            } else {
                if !self.hasVerticalScroller {
                    shouldForwardScroll = true
                }
            }
        }

        if shouldForwardScroll {
            self.nextResponder?.scrollWheel(with: event)
        } else {
            super.scrollWheel(with: event)
        }
        self._scrollWheel(with: event)
    }

    private static let swizzleScrollWheelImplementation: Void = {
        let instance: NSScrollView = NSScrollView()
        let aClass: AnyClass! = object_getClass(instance)
        let originalMethod = class_getInstanceMethod(aClass, #selector(scrollWheel(with:)))
        let swizzledMethod = class_getInstanceMethod(aClass, #selector(_scrollWheel(with:)))
        if let originalMethod = originalMethod, let swizzledMethod = swizzledMethod {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }()

    static func swizzleScrollWhell() {
        self.swizzleScrollWheelImplementation
    }
}

extension NSTextField{

    open override var focusRingType: NSFocusRingType{
        get{.none}
        set{}
    }


}
