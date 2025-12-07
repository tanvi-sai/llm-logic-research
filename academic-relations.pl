knowledge-bases/academic-relations.pl
% Academic Relationships Knowledge Base
% Facts: Course Prerequisites and Student Enrollments

% Course prerequisite relationships
prerequisite(algebra_1, algebra_2).
prerequisite(algebra_2, precalculus).
prerequisite(precalculus, calculus_1).
prerequisite(calculus_1, calculus_2).
prerequisite(biology_1, biology_2).
prerequisite(chemistry_1, chemistry_2).
prerequisite(physics_1, physics_2).
prerequisite(intro_cs, data_structures).
prerequisite(data_structures, algorithms).
prerequisite(intro_programming, intro_cs).

% Student-Course enrollments
enrolled(sarah, calculus_1).
enrolled(sarah, biology_2).
enrolled(sarah, intro_cs).
enrolled(mike, algebra_2).
enrolled(mike, chemistry_1).
enrolled(emily, precalculus).
enrolled(emily, physics_1).
enrolled(james, data_structures).
enrolled(james, calculus_2).
enrolled(lisa, algebra_1).
enrolled(lisa, biology_1).

% Course completion (students who finished courses)
completed(sarah, algebra_1).
completed(sarah, algebra_2).
completed(sarah, precalculus).
completed(sarah, biology_1).
completed(sarah, intro_programming).
completed(mike, algebra_1).
completed(emily, algebra_1).
completed(emily, algebra_2).
completed(james, algebra_1).
completed(james, algebra_2).
completed(james, precalculus).
completed(james, calculus_1).
completed(james, intro_programming).
completed(james, intro_cs).
completed(lisa, intro_programming).

% Department assignments
department(algebra_1, mathematics).
department(algebra_2, mathematics).
department(precalculus, mathematics).
department(calculus_1, mathematics).
department(calculus_2, mathematics).
department(biology_1, science).
department(biology_2, science).
department(chemistry_1, science).
department(chemistry_2, science).
department(physics_1, science).
department(physics_2, science).
department(intro_programming, computer_science).
department(intro_cs, computer_science).
department(data_structures, computer_science).
department(algorithms, computer_science).

% Course difficulty levels
difficulty(algebra_1, introductory).
difficulty(intro_programming, introductory).
difficulty(biology_1, introductory).
difficulty(chemistry_1, introductory).
difficulty(physics_1, introductory).
difficulty(algebra_2, intermediate).
difficulty(precalculus, intermediate).
difficulty(intro_cs, intermediate).
difficulty(biology_2, intermediate).
difficulty(chemistry_2, intermediate).
difficulty(physics_2, intermediate).
difficulty(calculus_1, advanced).
difficulty(data_structures, advanced).
difficulty(calculus_2, advanced).
difficulty(algorithms, advanced).

% ===== RULES =====

% A student is eligible for a course if they completed all prerequisites
eligible(Student, Course) :-
    \+ prerequisite(_, Course), % No prerequisites
    \+ enrolled(Student, Course), % Not already enrolled
    \+ completed(Student, Course). % Haven't already completed it

eligible(Student, Course) :-
    prerequisite(PrereqCourse, Course),
    completed(Student, PrereqCourse),
    \+ enrolled(Student, Course),
    \+ completed(Student, Course).

% Indirect prerequisite (transitive closure)
indirect_prerequisite(Course1, Course2) :-
    prerequisite(Course1, Course2).

indirect_prerequisite(Course1, Course3) :-
    prerequisite(Course1, Course2),
    indirect_prerequisite(Course2, Course3).

% Two courses are in sequence if one is a prerequisite of the other
in_sequence(Course1, Course2) :-
    prerequisite(Course1, Course2).

in_sequence(Course1, Course2) :-
    indirect_prerequisite(Course1, Course2).

% Co-requisites: courses in the same department at the same level
co_requisite(Course1, Course2) :-
    department(Course1, Dept),
    department(Course2, Dept),
    difficulty(Course1, Level),
    difficulty(Course2, Level),
    Course1 \= Course2.

% A student can take a course if they meet prerequisites
can_take(Student, Course) :-
    eligible(Student, Course).

% Advanced student: has completed at least one advanced course
advanced_student(Student) :-
    completed(Student, Course),
    difficulty(Course, advanced).

% Beginner student: only completed introductory courses
beginner_student(Student) :-
    completed(Student, _),
    \+ (completed(Student, Course), difficulty(Course, intermediate)),
    \+ (completed(Student, Course), difficulty(Course, advanced)).

% Students are peers if enrolled in the same course
peers(Student1, Student2) :-
    enrolled(Student1, Course),
    enrolled(Student2, Course),
    Student1 \= Student2.

% Course pathway: list all courses needed to reach a target course
% (This is for querying the full prerequisite chain)
prerequisite_chain(Course, Course, [Course]).
prerequisite_chain(StartCourse, TargetCourse, [StartCourse|Path]) :-
    prerequisite(StartCourse, NextCourse),
    prerequisite_chain(NextCourse, TargetCourse, Path).

% Student's next available courses
next_course(Student, Course) :-
    eligible(Student, Course),
    prerequisite(LastCompleted, Course),
    completed(Student, LastCompleted).

% Check if student is overloaded (enrolled in more than 3 courses)
overloaded(Student) :-
    findall(Course, enrolled(Student, Course), Courses),
    length(Courses, N),
    N > 3.

% Students in same department (taking courses from same dept)
same_department_students(Student1, Student2, Dept) :-
    enrolled(Student1, Course1),
    enrolled(Student2, Course2),
    department(Course1, Dept),
    department(Course2, Dept),
    Student1 \= Student2.




