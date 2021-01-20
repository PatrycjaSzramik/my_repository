
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Comparator;

public class Contact {
    private Long contact_id;
    private Long client_id;
    private Long employee_id;
    private String status;
    private LocalDateTime contact_ts;
    //public LocalDateTime contact_ts;

    public Contact(Long contact_id, Long client_id, Long employee_id, String status, LocalDateTime contact_ts) {
        this.contact_id = contact_id;
        this.client_id = client_id;
        this.employee_id = employee_id;
        this.status = status;
        this.contact_ts = contact_ts;
    }

    public Long getContact_id() {
        return contact_id;
    }

    public void setContact_id(Long contact_id) {
        this.contact_id = contact_id;
    }

    public Long getClient_id() {
        return client_id;
    }

    public void setClient_id(Long client_id) {
        this.client_id = client_id;
    }

    public Long getEmployee_id() {
        return employee_id;
    }

    public void setEmployee_id(Long employee_id) {
        this.employee_id = employee_id;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getContact_ts() {
        return contact_ts;
    }

    public void setContact_ts(LocalDateTime contact_ts) {
        this.contact_ts = contact_ts;
    }

    @Override
    public String toString() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String contact_ts_string = contact_ts.format(formatter);
        return
                contact_id + "; " + client_id + "; "+ employee_id + "; " + status + "; " + contact_ts_string +";\n";
    }
}




