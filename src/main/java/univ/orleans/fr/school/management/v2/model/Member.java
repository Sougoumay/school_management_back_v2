package univ.orleans.fr.school.management.v2.model;


public class Member {

    private String lastName;
    private String firstName;
    private String email;
    private int age;

    public Member(String lastName, String firstName, String email, int age) {
        this.lastName = lastName;
        this.firstName = firstName;
        this.email = email;
        this.age = age;
    }

    public String getLastName() {
        return lastName;
    }

    public String getFirstName() {
        return firstName;
    }

    public String getEmail() {
        return email;
    }

    public int getAge() {
        return age;
    }
}
