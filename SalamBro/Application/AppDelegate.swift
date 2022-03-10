//
//  AppDelegate.swift
//  SalamBro
//
//  Created by Murager on 01.03.2021.
//

import Firebase
import IQKeyboardManagerSwift
import SVProgressHUD
import UIKit
import YandexMapKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    private var reachabilityManager: ReachabilityManager?
    private var appCoordinator: AppCoordinator?

    private lazy var serviceComponents = ServiceComponentsAssembly()
    private lazy var repositoryComponents = RepositoryComponentsAssembly(serviceComponents: serviceComponents)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        YMKMapKit.setApiKey(Constants.yandexMapKitApiKey)
        configureAppState()
        configureAppCoordinator()
        configureProgressHUD()
        configureKeyboardManager()
        configureReachabilityManager()
        configureFirebase(application: application)

        return true
    }

    private func configureAppState() {
        DefaultStorageImpl.sharedStorage.persist(launchCount: DefaultStorageImpl.sharedStorage.launchCount + 1)
    }

    private func configureAppCoordinator() {
        appCoordinator = AppCoordinator(serviceComponents: serviceComponents,
                                        repositoryComponents: repositoryComponents,
                                        appCoordinatorsFactory: ApplicationCoordinatorFactoryImpl(builder: AppCoordinatorsModulesBuilderImpl(routersFactory: RoutersFactoryImpl())),
                                        pagesFactory: ApplicationPagesFactoryImpl(repositoryComponents: repositoryComponents))

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        appCoordinator?.start()
    }

    private func configureProgressHUD() {
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setRingNoTextRadius(12)
        SVProgressHUD.setCornerRadius(4)
        SVProgressHUD.setBackgroundColor(.lightGray)
        SVProgressHUD.setDefaultAnimationType(.flat)
        SVProgressHUD.setRingThickness(2)
        SVProgressHUD.setForegroundColor(.kexRed)
    }

    private func configureKeyboardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarTintColor = .kexRed
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = false
    }

    private func configureReachabilityManager() {
        reachabilityManager = ReachabilityManagerImpl.shared
        reachabilityManager?.start()
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    private func configureFirebase(application: UIApplication) {
        FirebaseApp.configure()

        UNUserNotificationCenter.current().delegate = self

        application.registerForRemoteNotifications()

        Messaging.messaging().delegate = self

        Messaging.messaging().token { _, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            }
        }
    }

    func messaging(_: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        print("Received FCM Token: \(fcmToken)")

        let notificationsRepository = repositoryComponents.makePushNotificationsRepository()
        notificationsRepository.process(fcmToken: fcmToken)

        let dataDict: [String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
}

extension AppDelegate {
//    MARK: - Notification recieved in foreground

    func userNotificationCenter(_: UNUserNotificationCenter, willPresent _: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }

//    MARK: - Tap on notification

    func userNotificationCenter(_: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler _: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        guard let pushNotification = PushNotification(dictionary: userInfo) else { return }

        appCoordinator?.handleNotification(pushNotification: pushNotification)
    }
}
