//
//  ViewController.swift
//  Snippets
//
//  Created by Chandran, Sudha | SDTD on 11/06/19.
//  Copyright © 2019 Chandran, Sudha | SDTD. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var sharedResource = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dispatchGroupSnippet()
        dispatchSemaphoreSnippet()
    }

    func fetchImage(completion: @escaping (UIImage?, Error?) -> ()) {
        guard let url = URL(string: "https://www.opencollege.info/wp-content/uploads/2016/02/relaxation-skills.jpg") else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            completion(UIImage(data: data ?? Data()), nil)
        }.resume()
    }

    func dispatchGroupSnippet() {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        fetchImage { (_, _) in
            print("dispatchGroup:Finished fetching image 1")
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchImage { (_, _) in
            print("dispatchGroup:Finished fetching image 2")
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchImage { (_, _) in
            print("dispatchGroup:Finished fetching image 3")
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            print("finished fetching images with DispatchGroup")
        }
        
        print("waitng to fetch images...")
    }
    
    func dispatchSemaphoreSnippet() {
        let semaphore = DispatchSemaphore(value: 0)

        let dispatchQueue = DispatchQueue.global(qos: .background)
        
        dispatchQueue.async {
            
            self.fetchImage { (_, _) in
                print("DispatchSemaphore: Finished fetching image 1")
                self.sharedResource.append("1")
                semaphore.signal()
            }
            semaphore.wait()

            self.fetchImage { (_, _) in
                print("DispatchSemaphore: Finished fetching image 2")
                self.sharedResource.append("2")
                semaphore.signal()
            }
            semaphore.wait()
            
            self.fetchImage { (_, _) in
                print("DispatchSemaphore: Finished fetching image 3")
                self.sharedResource.append("3")
                semaphore.signal()
            }
            semaphore.wait()
        }
        print("DispatchSemaphore: Start fetching images")
        
    }
}

