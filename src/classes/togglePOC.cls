public with sharing class togglePOC {
    
    public string toggleLabel {
        get {
            return toggleLabel == 'Summary' ? 'Detail' : 'Summary';
        }
        set;
    }
    
    public togglePOC() {} // constructor
}