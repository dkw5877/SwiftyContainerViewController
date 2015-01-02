//
//  ViewController.swift
//  SwiftyContainerViewController
//
//  Created by user on 12/30/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var currentClientView = UIViewController()
    var animateOn = false
    var selectedSegmentIndex = 0
    var content = [UIViewController]()

    @IBOutlet weak var animateButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        let imageVC = ImageContentViewController(nibName: "ImageContentViewController", bundle: nil)
        let tableVC = TableViewController(nibName: "TableViewController", bundle: nil)
        let collectionVC = CollectionViewController(nibName: "CollectionViewController", bundle: nil)
        self.displayContentViewController(tableVC)
        self.content = [tableVC, imageVC, collectionVC]

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    @IBAction func animateViewTransition(sender: AnyObject) {
        self.animateOn = !self.animateOn;
        if (self.animateOn) {
            self.animateButton.backgroundColor = UIColor.greenColor()
        }else {
            self.animateButton.backgroundColor = UIColor.clearColor()
        }

    }

    @IBAction func didSelectSegment(sender: AnyObject) {
        if (self.animateOn) {
        self.cycleFromViewControllerToViewController(self.content[self.selectedSegmentIndex],newViewController: self.content[sender.selectedSegmentIndex])
            self.selectedSegmentIndex = sender.selectedSegmentIndex

        } else {
            //manually swap the views in and out based on the selected segment (no animation)
            self.hideContentViewController(self.content[self.selectedSegmentIndex])
            self.selectedSegmentIndex = sender.selectedSegmentIndex
            self.displayContentViewController(self.content[self.selectedSegmentIndex])
        }
    }

    func displayContentViewController(content:UIViewController){

        //first add the new content view controller as a child
        self.addChildViewController(content)

        //set the frame for the new view controller, parents always size children
        content.view.frame = self.frameForContentController()

        //add the contents view to the parent view hierarcy
        self.view.addSubview(content.view)

        //store reference to detail view controller
        self.currentClientView = content

        //notify child that it now has a parent view
        content.didMoveToParentViewController(self)

    }

    func hideContentViewController(content:UIViewController){

        //notify view it will no longer have a parent
        content.willMoveToParentViewController(nil)

        //remove the view from the parents hierarchy
        content.view.removeFromSuperview()

        //remove the view controller from the parent's list of childrend
        content.removeFromParentViewController()

    }

    func cycleFromViewControllerToViewController(oldViewController:UIViewController, newViewController:UIViewController){

        //inform old view controller that it will no longer have a parent
        oldViewController.willMoveToParentViewController(nil)

        //add the new child view controller
        self.addChildViewController(newViewController)

        //set the new view controllers frame
        newViewController.view.frame = self.newViewStartFrame()

        let endFrame = self.oldViewEndFrame()

        self.transitionFromViewController(oldViewController, toViewController: newViewController, duration: 1.50, options:UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            //new view will take the place of the old view
            newViewController.view.frame = oldViewController.view.frame;
            oldViewController.view.frame = endFrame;

        }) { (Bool) -> Void in
            //Remove the old view controller
            oldViewController.removeFromParentViewController()
            //set the new vc as the current
            self.currentClientView = newViewController;
            newViewController.didMoveToParentViewController(self)
        }

    }

    func frameForContentController() -> CGRect{
        return CGRectMake(0 , 100, self.view.bounds.width, self.view.bounds.height - 100)
    }

    func newViewStartFrame()->CGRect{
        return CGRectMake(-self.view.frame.size.width, 100, self.currentClientView.view.frame.size.width, self.currentClientView.view.frame.size.height)
    }

    func oldViewEndFrame()->CGRect{
        return CGRectMake(self.view.frame.size.width, 100, self.currentClientView.view.frame.size.width, self.currentClientView.view.frame.size.height)
    }

}

