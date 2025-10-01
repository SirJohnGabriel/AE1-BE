namespace AE1.Api.Filters
{
    using System.Net;
    using AE1.Infrastructure.Extensions;
    using AE1.Infrastructure.Logging;
    using Microsoft.AspNetCore.Mvc;
    using Microsoft.AspNetCore.Mvc.Filters;

    public class HandleExceptionAttribute : ExceptionFilterAttribute
    {
        private readonly ILogger logger;
        private readonly IHostEnvironment env;

        public HandleExceptionAttribute(ILogger logger, IHostEnvironment env)
        {
            this.logger = logger;
            this.env = env;
        }

        public override void OnException(ExceptionContext context)
        {
            var innermost = context.Exception.GetInnerMostException();
            this.logger.WriteException(context.Exception);
            IActionResult result = new StatusCodeResult(500);

            if (!this.env.IsProduction())
            {
                result = new ObjectResult(new { innermost.Message, innermost.StackTrace })
                {
                    StatusCode = (int)HttpStatusCode.InternalServerError,
                };
            }

            context.Result = result;
        }
    }
}