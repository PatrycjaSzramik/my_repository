import java.io.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.Iterator;
import java.util.List;
import java.util.stream.*;

import java.io.FileNotFoundException;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

public class Main {
    public static void main(String[] args) {
        JSONParser jsonParser = new JSONParser();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String dateFilter = "2017-07-01 00:00:00";
        List<Contact> contactListFilter = new ArrayList<>();


        try (FileReader reader = new FileReader("D:\\statuses.json")) {
            JSONObject obj = (JSONObject) jsonParser.parse(reader);

            JSONArray contactList = (JSONArray) obj.get("records");
            for (int i = 0; i < contactList.size(); i++) {
                JSONObject record = (JSONObject) contactList.get(i);

                String contactTsString = (String) record.get("kontakt_ts");
                LocalDateTime contactTs = LocalDateTime.parse(contactTsString, formatter);

                if (contactTs.isBefore(LocalDateTime.parse(dateFilter, formatter))) {
                    continue;
                } else {

                    Long contactId = (Long) record.get("kontakt_id");
                    Long klientId = (Long) record.get("klient_id");
                    Long employeeId = (Long) record.get("pracownik_id");
                    String status = (String) record.get("status");

                    Contact contact = new Contact(contactId, klientId, employeeId, status, contactTs);
                    contactListFilter.add(contact);
                }
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (ParseException e) {
            e.printStackTrace();
        }

        contactListFilter.sort(new ContactComparator());

        try {
            saveToFileCSV(contactListFilter);
        } catch (IOException ex) {
        System.out.println("File error");
        }
    }

    private static void saveToFileCSV(List list) throws IOException {
        String fileName = "D:\\plik.csv";
        FileWriter fileWriter = null;
        try {
            fileWriter = new FileWriter(fileName);
            fileWriter.write("kontakt_id; klient_id; pracownik_id; status; kontakt_ts;\n");
            for (int i = 0; i < list.size(); i++) {
                fileWriter.write(list.get(i).toString());
            }
        } catch (IOException ex) {
            System.out.println("File error");
        } finally {
            if (fileWriter == null) {
                System.out.println("File error");
            } else {
                fileWriter.close();
            }
        }
    }
}
