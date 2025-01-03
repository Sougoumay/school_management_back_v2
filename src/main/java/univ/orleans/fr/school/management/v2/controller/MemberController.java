package univ.orleans.fr.school.management.v2.controller;


import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import univ.orleans.fr.school.management.v2.model.Member;

import java.util.*;

@RestController
@RequestMapping("/api/v2")
@CrossOrigin("*")
public class MemberController {

    private List<Member> students = new ArrayList<>();
    private List<Member> teachers = new ArrayList<>();
    private HashMap<String, List<Member>> membersMap = new HashMap<>();
    private boolean firstCall = true;


    @Operation(
            summary = "Récupère les membres en fonction du type et de la requête.",
            description = "Permet de récupérer la liste des étudiants ou des enseignants. Vous pouvez aussi filtrer par un mot-clé dans la requête."
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Liste des membres récupérée avec succès.",
                    content = {@Content(mediaType = "application/json")}),
            @ApiResponse(responseCode = "400", description = "Requête invalide (paramètre type manquant ou vide)."),
            @ApiResponse(responseCode = "404", description = "Type de membre non trouvé.")
    })
    @GetMapping("/members")
    public ResponseEntity<List<?>> getMembers(
            @Parameter(description = "Type de membre (student ou teacher).", required = true)
            @RequestParam String type,
            @Parameter(description = "Filtre optionnel pour rechercher par nom ou prénom.")
            @RequestParam(required = false) String query
    ) {
        if (firstCall) {
            students.addAll(generateStudents());
            teachers.addAll(generateTeachers());
            membersMap.put("student", students);
            membersMap.put("teacher", teachers);
            firstCall = false;
        }

        if (type == null || type.isEmpty()) {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }

        if (!membersMap.containsKey(type)) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }

        if (query == null || query.isEmpty()) {
            return new ResponseEntity<>(membersMap.get(type), HttpStatus.OK);
        }

        List<Member> members = new ArrayList<>();
        for(Member m : membersMap.get(type)) {
            if (m.getLastName().toLowerCase().contains(query.toLowerCase())
                    || m.getFirstName().toLowerCase().contains(query.toLowerCase())) {
                members.add(m);
            }
        }

        return new ResponseEntity<>(members, HttpStatus.OK);
    }


    public static List<Member> generateStudents() {
        List<Member> students = new ArrayList<>();
        Random rand = new Random();
        String[] lastNames = {"Durand", "Dupont", "Martin", "Bernard", "Thomas", "Petit", "Lemoine", "Lemoine", "Richard", "Faure"};
        String[] firstNames = {"Alice", "Pierre", "Julien", "Marie", "Sophie", "Paul", "Luc", "Claire", "Antoine", "Caroline"};

        for (int i = 0; i < 30; i++) {
            String lastName = lastNames[rand.nextInt(lastNames.length)];
            String firstName = firstNames[rand.nextInt(firstNames.length)];
            String email = firstName.toLowerCase() + "." + lastName.toLowerCase() + "@etu.univ-orleans.fr";
            int age = rand.nextInt(5) + 18; // Âge entre 18 et 22 ans

            students.add(new Member(lastName, firstName, email, age));
        }
        return students;
    }


    public static List<Member> generateTeachers() {
        List<Member> teachers = new ArrayList<>();
        Random rand = new Random();
        String[] lastNames = {"Lemoine", "Martinez", "Dupont", "Leclerc", "Dufresne", "Roche", "Guillaume", "Robert", "Allard", "Boucher"};
        String[] firstNames = {"François", "Brigitte", "Luc", "Isabelle", "Michel", "Pierre", "Caroline", "Jean", "Thomas", "Julie"};

        for (int i = 0; i < 30; i++) {
            String lastName = lastNames[rand.nextInt(lastNames.length)];
            String firstName = firstNames[rand.nextInt(firstNames.length)];
            String email = firstName.toLowerCase() + "." + lastName.toLowerCase() + "@univ.fr";
            int age = rand.nextInt(15) + 30; // Âge entre 30 et 45 ans

            teachers.add(new Member(lastName, firstName, email, age));
        }
        return teachers;
    }


}
