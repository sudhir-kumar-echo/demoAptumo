public class DemoActionSupport_Controller {

    public Integer count = 0;
    
    public DemoActionSupport_Controller(){
        //count = 0;
    }
    
    public PageReference incrementCounter(){
        count++;
        return null;
    }
    
    public Integer getCount(){
        return count;
    }
}