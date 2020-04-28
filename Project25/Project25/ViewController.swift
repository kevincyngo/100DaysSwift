//
//  ViewController.swift
//  Project25
//
//  Created by Kevin Ngo on 2020-04-28.
//  Copyright © 2020 Kevin Ngo. All rights reserved.
//

import UIKit
import MultipeerConnectivity


class ViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate {

    var images = [UIImage]()
    var peerID = MCPeerID(displayName: UIDevice.current.name)
    var mcSession: MCSession?
    var mcAdvertiserAssistant: MCAdvertiserAssistant?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        title = "Selfie Share"
        let importPictureButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))

        let connectionButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
        
        //challenge 2
        let sendMessageButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(showSendMessagePrompt))
        navigationItem.rightBarButtonItems = [sendMessageButton, importPictureButton]
        
        //challenge 3
        let connectedPeersButton = UIBarButtonItem(title: "Peers", style: .plain, target: self, action: #selector(showPeersPrompt))
        navigationItem.leftBarButtonItems = [connectionButton, connectedPeersButton]
        
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self
        
        
    }
    
    @objc func showPeersPrompt() {
        var peersText = ""

        var peersAvailable = false
        if let mcSession = mcSession {
            if mcSession.connectedPeers.count > 0 {
                peersAvailable = true
                for peer in mcSession.connectedPeers {
                    peersText += "\n\(peer.displayName)"
                }
            }
        }
        if !peersAvailable {
            peersText += "\nNo peer connected"
        }

        let ac = UIAlertController(title: "Connected peers", message: peersText, preferredStyle: .actionSheet)
        ac.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItems?[1]
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    
    @objc func showSendMessagePrompt() {
        let ac = UIAlertController(title: "Message", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Send", style: .default, handler: { [weak self, weak ac] _ in
            if let text = ac?.textFields?[0].text {
                self?.sendMessage(text)
            }
        }))
        present(ac, animated: true)
    }
    
    //Convert String to Data and call sendData
    func sendMessage(_ text: String) {
        let data = Data(text.utf8)
        sendData(data)
    }
    
    func sendData(_ data: Data) {
        // send data to peers
        // is there an active session?
        guard let mcSession = mcSession else { return }
        // are there any peers to send to?
        if mcSession.connectedPeers.count > 0 {
            do {
                // asynchronous method
                try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
            }
            catch {
                let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)

        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.item]
            imageView.contentMode = .center
        }

        return cell
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        dismiss(animated: true)

        images.insert(image, at: 0)
        collectionView.reloadData()
        
        // 1
        guard let mcSession = mcSession else { return }

        // 2
        if mcSession.connectedPeers.count > 0 {
            // 3
            if let imageData = image.pngData() {
                // 4
                do {
                    try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch {
                    // 5
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
            }
        }
    }
    
    @objc func showConnectionPrompt() {
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }

    func startHosting(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-project25", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant?.start()
    }

    func joinSession(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        let mcBrowser = MCBrowserViewController(serviceType: "hws-project25", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async { [weak self] in
            if let image = UIImage(data: data) {
                self?.images.insert(image, at: 0)
                self?.collectionView.reloadData()
            }
            else {
                // challenge 2
                let text = String(decoding: data, as: UTF8.self)
                let ac = UIAlertController(title: "Message received", message: "\n\(text)", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(ac, animated: true)
            }
        }
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {

    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {

    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {

    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }

    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    //When a user connects or disconnects from our session, this method is called
    //When this method is called, you'll be told what peer changed state, and what their new state is
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("WTH")
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")

        case .connecting:
            print("Connecting: \(peerID.displayName)")

        case .notConnected:
            print("Not Connected: \(peerID.displayName)")
            let alert = UIAlertController(title: "Peer Disconnected", message: "\(peerID.displayName) has disconnected", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            self.present(alert,animated: true)
        @unknown default:
            print("Unknown state received: \(peerID.displayName)")
        }
    }
    
    func presentAlert() {
        let createTextMessage = UIAlertController(title: "Send Text Message", message: "", preferredStyle: .alert)
        createTextMessage.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(createTextMessage,animated: true)
    }
    
}

