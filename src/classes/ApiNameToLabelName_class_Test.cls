@isTest

private class ApiNameToLabelName_class_Test{
    @isTest static void tesApiNameToLabelName(){
        ApiNameToLabelName_class oApiNameToLabelName_class = new ApiNameToLabelName_class() ;
        oApiNameToLabelName_class.strObjectAPIName = 'Account' ;
        oApiNameToLabelName_class.getLabelName() ;
        System.assertEquals('Account', oApiNameToLabelName_class.strObjectLabel) ;
        oApiNameToLabelName_class.strObjectAPIName = 'TestInvalidSobject' ;
        oApiNameToLabelName_class.getLabelName() ;
        System.assertEquals(null, oApiNameToLabelName_class.strObjectLabel) ;
    }
}