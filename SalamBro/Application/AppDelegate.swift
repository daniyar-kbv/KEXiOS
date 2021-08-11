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
        YMKMapKit.setApiKey(Constants.apiKey)
        configureAppCoordinator()
        configureProgressHUD()
        configureKeyboardManager()
        configureReachabilityManager()
        configureFirebase(application: application)

        return true
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

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in })

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

        let notificationsRepository = repositoryComponents.makePushNotificationsRepository()

        let dataDict: [String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
}

extension AppDelegate {
//    MARK: - Notification recieved in foreground

    func userNotificationCenter(_: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler _: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        guard let pushNotification = PushNotification(dictionary: userInfo) else { return }

        showNotificationAlert(pushNotification: pushNotification)
    }

//    MARK: - Notification recieved in background

    func userNotificationCenter(_: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler _: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        guard let pushNotification = PushNotification(dictionary: userInfo) else { return }

        appCoordinator?.handleNotification(pushNotification: pushNotification)
    }

    func showNotificationAlert(pushNotification: PushNotification) {
        guard let rootViewController = window?.rootViewController as? AlertDisplayable else { return }

        rootViewController.showAlert(title: pushNotification.aps.alert.title,
                                     message: pushNotification.aps.alert.body,
                                     submitTitle: SBLocalization.localized(key: AlertText.ok)) { [weak self] in
            self?.appCoordinator?.handleNotification(pushNotification: pushNotification)
        }
    }
}
