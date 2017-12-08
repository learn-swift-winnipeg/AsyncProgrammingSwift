struct Providers {
    
    // MARK: - Stored Properties
    
    // TODO: Implement.
    
    // MARK: - Static
    
    static func forCurrentConfiguration() -> Providers {
        // These #if <Active Compilation Condition> checks will be used to run the app with appropriate providers for a given build. For instance a RELEASE build will connect to real local storage and remote networks while a TESTING build should be run will stub/mock implementations.
        
        #if TESTING
            print("******************************** Creating Testing Providers")
            return makeTestingProviders()
            
        #elseif DEBUG
            print("******************************** Creating Debug Providers")
            return makeDebugProviders()
            
        #else
            return makeReleaseProviders()
        #endif
    }
    
    // MARK: - Testing
    
    private static func makeTestingProviders() -> Providers {
        // TODO: Implement.
        return Providers()
    }
    
    // MARK: - Debug
    
    private static func makeDebugProviders() -> Providers {
        // TODO: Implement.
        return Providers()
    }
    
    // MARK: - Release
    
    private static func makeReleaseProviders() -> Providers {
        // TODO: Implement.
        return Providers()
    }
}
