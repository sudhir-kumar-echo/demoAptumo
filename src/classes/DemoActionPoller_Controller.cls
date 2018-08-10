public class DemoActionPoller_Controller {
    public Integer count;
    public DemoActionPoller_Controller(){
        count = 0;
    }

    public Pagereference incrementCounter(){
        count++;
        return null;
    }

    public Integer getCount() {
        
        return count;
    }

}