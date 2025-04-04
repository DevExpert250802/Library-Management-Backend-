using Library_Management.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Library_Management.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class BookController : ControllerBase
    {
        private readonly BookContext _bookContext;

        public BookController(BookContext bookContext)
        {
            _bookContext = bookContext ?? throw new ArgumentNullException(nameof(bookContext));
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Book>>> GetBooks()
        {
            var books = await _bookContext.Books.ToListAsync();
            return books.Any() ? Ok(books) : NotFound("No books found");
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<Book>> GetBook(int id)
        {
            var book = await _bookContext.Books.FindAsync(id);
            return book != null ? Ok(book) : NotFound("Book not found");
        }

        [HttpPost]
        public async Task<ActionResult<Book>> PostBook([FromBody]Book book)
        {
            if (book == null)
            {
                return BadRequest("Invalid book data");
            }
            _bookContext.Books.Add(book);
            await _bookContext.SaveChangesAsync();
            return CreatedAtAction(nameof(GetBook), new { id = book.ID }, book);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> PutBook(int id, Book book)
        {
            if (id != book.ID)
            {
                return BadRequest("Book ID mismatch");
            }

            _bookContext.Entry(book).State = EntityState.Modified;

            try
            {
                await _bookContext.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!_bookContext.Books.Any(b => b.ID == id))
                {
                    return NotFound("Book not found for update");
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteBook(int id)
        {
            var book = await _bookContext.Books.FindAsync(id);
            if (book == null)
            {
                return NotFound("Book not found");
            }

            _bookContext.Books.Remove(book);
            await _bookContext.SaveChangesAsync();
            return NoContent();
        }
    }
}
