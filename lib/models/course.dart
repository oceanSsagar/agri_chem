class Course {
  String author;
  String authorImg;
  String title;
  String imageUrl;

  Course({
    required this.author,
    required this.authorImg,
    required this.title,
    required this.imageUrl,
  });

  static List<Course> generateCourse() {
    return [
      Course(
        author: "Sagar Salgar",
        authorImg: "assets/authors/sagar_salgar.jpg",
        title: "Types of Agro Chemicals",
        imageUrl: "assets/courses/course1/course1.png",
      ),
      Course(
        author: "John Doe",
        authorImg: "assets/authors/john_doe.jpg",
        title: "Introduction to Pesticides",
        imageUrl: "assets/courses/course2/course2.jpg",
      ),
      Course(
        author: "Jane Smith",
        authorImg: "assets/authors/jane_smith.jpg",
        title: "Fertilizers and Their Uses",
        imageUrl: "assets/courses/course3/course3.jpg",
      ),
      Course(
        author: "Emily Johnson",
        authorImg: "assets/authors/emily_johnson.jpg",
        title: "Organic Farming Techniques",
        imageUrl: "assets/courses/course4/course4.png",
      ),
      Course(
        author: "Michael Brown",
        authorImg: "assets/authors/michael_brown.jpg",
        title: "Soil Health and Management",
        imageUrl: "assets/courses/course5/course5.jpg",
      ),
    ];
  }
}
