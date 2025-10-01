namespace AE1.Api.Messages.Identity
{
    using System.Collections.Generic;
    using System.Net;
    using System.Text.Json.Serialization;
    using AE1.Api.Common.Responses;
    using AE1.Infrastructure.Constants.Errors;

    public class SignInExternalWebResponse : WebResponse<string>
    {
        public SignInExternalWebResponse(string data, string errorCode, string message)
            : base(data, errorCode, message)
        {
        }

        [JsonIgnore]
        public override Dictionary<string, HttpStatusCode> ErrorCodes => new Dictionary<string, HttpStatusCode>()
        {
            { IdentityServiceErrorCodes.UserNotFound, HttpStatusCode.BadRequest },
            { IdentityServiceErrorCodes.GoogleTokenValidationError, HttpStatusCode.BadRequest },
            { IdentityServiceErrorCodes.GoogleEmailAlreadyInUse, HttpStatusCode.BadRequest },
        };
    }
}
