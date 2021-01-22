import java.util.Comparator;

public class ContactComparator implements Comparator<Contact> {
    @Override
    public int compare(Contact o1, Contact o2) {
        if (o1.getClient_id()>o2.getClient_id()) {
            return 1;
        } else if (o1.getClient_id()<o2.getClient_id()) {
            return -1;
        } else if (o1.getClient_id()==o2.getClient_id() && o1.getContact_ts().isAfter(o2.getContact_ts())) {
            return 1;
        } else if (o1.getClient_id()==o2.getClient_id() && o1.getContact_ts().isBefore(o2.getContact_ts())) {
            return -1;
        } else return 0;
    }
}
