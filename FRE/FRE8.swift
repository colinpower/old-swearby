//
//  FRE8.swift
//  SwearBy
//
//  Created by Colin Power on 1/18/25.
//

import Foundation
import SwiftUI


struct FRE8: View {
    
    @Binding var showFRE: Bool
    @Binding var page: Int
    
    @State private var didTapShareSheetButton: Bool = false
    
    
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0) {
            
            HStack(alignment: .center, spacing: 0) {
                ZStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(Color("text.black"))
                        .frame(width: 68, height: 68)
                    Image(systemName: "gear")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                .padding(.trailing)
                Text("Add SwearBy\nto the Share Sheet")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(Color("text.black"))
            }
            .frame(width: UIScreen.main.bounds.width, alignment: .center)
            .padding(.top, 90)
            
            Text("STEP 3 OF 3")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(!didTapShareSheetButton ? Color("text.gray") : .clear)
                .padding(.vertical, 20)
            
                
            if !didTapShareSheetButton {
                
                FRE8_Prompt()
                
                Spacer()
                
                LottieView(url: Bundle.main.url(forResource: "Flow7", withExtension: "lottie")!)
                    .padding(.vertical, 40)
                
                Spacer()
                
                Button {
                    showAppShareSheet()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        withAnimation(.linear(duration: 0.2)) {
                            didTapShareSheetButton = true
                        }
                    }
                } label: {
                    FRE_Button8()
                }
                .padding(.bottom, 50)
                
            } else {
                VStack(alignment: .leading, spacing: 0) {
                    FRE8_1()
                    FRE8_2()
                        .padding(.vertical, 10)
                    FRE8_3()
                }
                .padding(.leading)
                
                Spacer()
                
                Button {
                    SessionManager().markOnboardingComplete()
                    page = 10
                } label: {
                    FRE_Button()
                }
                .padding(.bottom)
                
                Button {
                    showAppShareSheet()
                } label: {
                    Label("Retry", systemImage: "square.and.arrow.up")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(Color("text.gray"))
                        .padding(.vertical, 20)
                }
                .padding(.bottom, 50)
            }

        }
        .background(Color("Background"))
        .edgesIgnoringSafeArea(.all)
    }
    
    var customShareLinkButton: some View {
            Button {
                presentShareLink()
                
                
            } label: {
                Label("share", systemImage: "square.and.arrow.up")
            }
        }
        
        func presentShareLink() {
            print("your logic here")
            
            guard let url = URL(string: "https://stackoverflow.com/") else { return }
            let vc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            let scene = UIApplication.shared.connectedScenes.first { $0.activationState == .foregroundActive } as? UIWindowScene
            scene?.keyWindow?.rootViewController?.present(vc, animated: true)
        }
    
    
}



import LinkPresentation

//  MARK: LinkMetadataManager
/// Transform url to metadata to populate to user.
final class LinkMetadataManager: NSObject, UIActivityItemSource {

  var linkMetadata: LPLinkMetadata

  let appTitle = "Scroll  ⮕⮕  and tap \"More\"."
  let appleStoreProductURL = "https://apps.apple.com/ca/app/swearby-app/id6446050386"  // The url of your app in Apple Store
  let iconImage = "appIcon"  // The name of the image file in your directory
  let png = "png"  // The extension of the image

  init(linkMetadata: LPLinkMetadata = LPLinkMetadata()) {
    self.linkMetadata = linkMetadata
  }
}

// MARK: - Setup
extension LinkMetadataManager {
  /// Creating metadata to population in the share sheet.
  func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {

    guard let url = URL(string: appleStoreProductURL) else { return linkMetadata }

    linkMetadata.originalURL = url
    linkMetadata.url = linkMetadata.originalURL
    linkMetadata.title = appTitle
    linkMetadata.iconProvider = NSItemProvider(
      contentsOf: Bundle.main.url(forResource: iconImage, withExtension: png))

    return linkMetadata
  }

  /// Showing empty string returns a share sheet with the minimum requirement.
  func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
    return String()
  }

  /// Sharing url of the application.
  func activityViewController(_ activityViewController: UIActivityViewController,
                              itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
    return linkMetadata.url
  }
}

//  MARK: View+ShareSheet
extension View {

  /// Populate Apple share sheet to enable user to share Apple Store link.
  func showAppShareSheet() {
    guard let source = UIApplication.shared.windows.first?.rootViewController else {
      return
    }

    let activityItemMetadata = LinkMetadataManager()

    let activityVC = UIActivityViewController(
      activityItems: [activityItemMetadata],
      applicationActivities: nil)

    if let popoverController = activityVC.popoverPresentationController {
      popoverController.sourceView = source.view
      popoverController.permittedArrowDirections = []
      popoverController.sourceRect = CGRect(
        x: source.view.bounds.midX,
        y: source.view.bounds.midY,
        width: .zero,
        height: .zero)
    }
    source.present(activityVC, animated: true)
  }
}


struct FRE6_Prompt: View {
    var body: some View {
        
        HStack(alignment: .center, spacing: 0) {
            Text("Scroll, then tap")
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .foregroundColor(Color("text.black"))
                .padding(.trailing, 8)
                .padding(.bottom, 9)
            
            VStack(alignment: .center, spacing: 0) {
                ZStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(.white)
                        .frame(width: 38, height: 38)
                    Image(systemName: "ellipsis")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(Color("text.gray"))
                }
                Text("More")
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .foregroundColor(Color("text.black"))
            }
        }
        .frame(width: UIScreen.main.bounds.width, alignment: .center)
    }
}

struct FRE7_Prompt: View {
    var body: some View {
        
        Group {
            Text("Tap ")
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .foregroundColor(Color("text.black"))
            +
            Text("Edit")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.blue)
        }
        .frame(width: UIScreen.main.bounds.width, alignment: .center)
    }
}


struct FRE8_Prompt: View {
    var body: some View {
        
        HStack(alignment: .center, spacing: 0) {
            Text("Tap")
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .foregroundColor(Color("text.black"))
            
            ZStack(alignment: .center) {
                Circle()
                    .foregroundColor(.green)
                    .frame(width: 32, height: 32)
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 10)
            
            Text("next to")
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .foregroundColor(Color("text.black"))
            
            Image("SwearByIcon")
                .resizable()
                .frame(width: 36, height: 36)
                .padding(.leading, 10)
                .padding(.trailing, 6)
            
            Text("SwearBy")
                .font(.system(size: 20, weight: .regular, design: .rounded))
                .foregroundColor(Color("text.black"))
        }
        .frame(width: UIScreen.main.bounds.width, alignment: .center)
    }
}


struct FRE8_1: View {
    var body: some View {
        
        HStack(alignment: .center, spacing: 0) {
            
            Image(systemName: "1.circle.fill")
                .font(.system(size: 32, weight: .regular, design: .rounded))
                .foregroundColor(Color("text.black"))
                .padding(.trailing, 30)
                .padding(.bottom, 9)
            
            Text("Scroll, then tap")
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .foregroundColor(Color("text.black"))
                .padding(.trailing, 8)
                .padding(.bottom, 9)
            
            VStack(alignment: .center, spacing: 0) {
                ZStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(.white)
                        .frame(width: 38, height: 38)
                    Image(systemName: "ellipsis")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(Color("text.gray"))
                }
                Text("More")
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .foregroundColor(Color("text.black"))
            }
        }
        .frame(height: 50)
    }
}

struct FRE8_2: View {
    var body: some View {
        
        HStack(alignment: .center, spacing: 0) {
            
            Image(systemName: "2.circle.fill")
                .font(.system(size: 32, weight: .regular, design: .rounded))
                .foregroundColor(Color("text.black"))
                .padding(.trailing, 30)
            Group {
                Text("Tap ")
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .foregroundColor(Color("text.black"))
                +
                Text("Edit")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.blue)
            }
        }
        .frame(height: 50)
    }
}


struct FRE8_3: View {
    var body: some View {
        
        HStack(alignment: .center, spacing: 0) {
            Image(systemName: "3.circle.fill")
                .font(.system(size: 32, weight: .regular, design: .rounded))
                .foregroundColor(Color("text.black"))
                .padding(.trailing, 30)
            
            Text("Tap")
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .foregroundColor(Color("text.black"))
            
            ZStack(alignment: .center) {
                Circle()
                    .foregroundColor(.green)
                    .frame(width: 32, height: 32)
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 10)
            
            Text("next to")
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .foregroundColor(Color("text.black"))
            
            Image("SwearByIcon")
                .resizable()
                .frame(width: 34, height: 34)
                .padding(.leading, 10)
                .padding(.trailing, 6)
            
            Text("SwearBy")
                .font(.system(size: 17, weight: .regular, design: .rounded))
                .foregroundColor(Color("text.black"))
        }
        .frame(height: 50)
        .padding(.top, 4.5)
    }
}
