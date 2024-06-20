##Program.cs

using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using HelloWorldApi;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI(c =>
    {
        c.SwaggerEndpoint("/swagger/v1/swagger.json", "HelloWorldApi v1");
        c.RoutePrefix = string.Empty; // To serve the Swagger UI at the app's root
    });
}

app.UseHttpsRedirection();
app.UseAuthorization();
app.MapControllers();
app.Run();


##Controller

using Microsoft.AspNetCore.Mvc;

namespace HelloWorldApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class HelloWorldController : ControllerBase
    {
        [HttpGet]
        public IActionResult Get([FromQuery] int a, [FromQuery] int b)
        {
            // Call Util.Run to add the two numbers
            int result = Util.Run(a, b);
            
            // Return the result appended to "Hello, World!"
            return Ok($"Hello, World! The sum is {result}");
        }
    }
}


##Util
namespace HelloWorldApi
{
    public static class Util
    {
        public static int Run(int a, int b)
        {
            // Add the two numbers
            return a + b;
        }
    }
}


##TEST

dotnet add package MSTest.TestFramework
dotnet add package MSTest.TestAdapter
dotnet add package Microsoft.AspNetCore.Mvc.Testing

##UtilTests.cs
using Microsoft.VisualStudio.TestTools.UnitTesting;
using HelloWorldApi;

namespace HelloWorldApi.Tests
{
    [TestClass]
    public class UtilTests
    {
        [TestMethod]
        public void Run_AddsTwoNumbers_ReturnsCorrectSum()
        {
            // Arrange
            int a = 5;
            int b = 3;
            int expectedSum = 8;

            // Act
            int result = Util.Run(a, b);

            // Assert
            Assert.AreEqual(expectedSum, result);
        }
    }
}

##HelloWorldControllerTests.cs

using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Net.Http;
using System.Threading.Tasks;

namespace HelloWorldApi.Tests
{
    [TestClass]
    public class HelloWorldControllerTests
    {
        private static WebApplicationFactory<Program> _factory;
        private static HttpClient _client;

        [ClassInitialize]
        public static void ClassInitialize(TestContext context)
        {
            _factory = new WebApplicationFactory<Program>();
            _client = _factory.CreateClient();
        }

        [ClassCleanup]
        public static void ClassCleanup()
        {
            _client.Dispose();
            _factory.Dispose();
        }

        [TestMethod]
        public async Task Get_ReturnsHelloWorldWithSum()
        {
            // Arrange
            int a = 5;
            int b = 3;
            string expectedResponse = "Hello, World! The sum is 8";

            // Act
            var response = await _client.GetAsync($"/api/helloworld?a={a}&b={b}");
            response.EnsureSuccessStatusCode();
            var responseString = await response.Content.ReadAsStringAsync();

            // Assert
            Assert.AreEqual(expectedResponse, responseString);
        }
    }
}



