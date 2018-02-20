final class ScannerPresenter: ScannerModule {
    
    // MARK: - Dependencies
    
    private let interactor: ScannerInteractor
    private let router: ScannerRouter
    private let cameraModuleInput: CameraModuleInput
    
    // MARK: - Init
    
    init(interactor: ScannerInteractor, router: ScannerRouter, cameraModuleInput: CameraModuleInput) {
        self.interactor = interactor
        self.router = router
        self.cameraModuleInput = cameraModuleInput
    }
    
    weak var view: ScannerViewInput? {
        didSet {
            view?.onViewDidLoad = { [weak self] in
                self?.setUpView()
            }
        }
    }
    
    // MARK: - ScannerModule

    var onItemAdd: ((MediaPickerItem) -> ())?
    var onFinish: ((MediaPickerItem?) -> ())?
    var onCancel: (() -> ())?
    
    public func setCameraTitle(_ title: String) {
        cameraModuleInput.setTitle(title)
    }
    
    public func setCameraSubtitle(_ subtitle: String) {
        cameraModuleInput.setSubtitle(subtitle)
    }
    
    public func setAccessDeniedTitle(_ title: String) {
        cameraModuleInput.setAccessDeniedTitle(title)
    }
    
    public func setAccessDeniedMessage(_ message: String) {
        cameraModuleInput.setAccessDeniedMessage(message)
    }
    
    public func setAccessDeniedButtonTitle(_ title: String) {
        cameraModuleInput.setAccessDeniedButtonTitle(title)
    }
    
    func focusOnModule() {
        router.focusOnCurrentModule()
    }
    
    func dismissModule() {
        router.dismissCurrentModule()
    }
    
    func finish() {
        cameraModuleInput.setFlashEnabled(false, completion: nil)
        onFinish?(interactor.item)
    }

    // MARK: - Private
    
    private func setUpView() {
        
        interactor.observeDeviceOrientation { [weak self] deviceOrientation in
            self?.view?.adjustForDeviceOrientation(deviceOrientation)
        }
        
        view?.onViewWillAppear = { [weak self] animated in
            self?.cameraModuleInput.setCameraOutputNeeded(true)
        }
        view?.onViewDidAppear = { [weak self] animated in
            self?.cameraModuleInput.mainModuleDidAppear(animated: animated)
        }
        
        view?.onViewDidDisappear = { [weak self] animated in
            self?.cameraModuleInput.setCameraOutputNeeded(false)
        }
    }
    
}
