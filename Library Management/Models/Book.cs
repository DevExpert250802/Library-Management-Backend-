namespace Library_Management.Models
{
    public class Book
    {
       
        public int ID { get; set; }
        public string? Name { get; set; }

        public string? Author { get; set; }

        public int TotalBooks { get; set; }

        public bool CurrentlyPresent { get; set; }
    }
}
