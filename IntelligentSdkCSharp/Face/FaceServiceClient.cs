// *********************************************************
//
// Copyright (c) Microsoft. All rights reserved.
//
// *********************************************************

namespace Microsoft.ProjectOxford.Face
{
    using Microsoft.ProjectOxford.Face.Contract;
    using Newtonsoft.Json;
    using Newtonsoft.Json.Serialization;
    using System;
    using System.IO;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Text;
    using System.Threading.Tasks;

    /// <summary>
    /// The face service client proxy implementation.
    /// </summary>
    public class FaceServiceClient : IDisposable, IFaceServiceClient
    {
        #region private members
        /// <summary>
        /// The service host.
        /// </summary>
        private const string ServiceHost = "https://api.projectoxford.ai/face/v0";

        /// <summary>
        /// The JSON content type header.
        /// </summary>
        private const string JsonContentTypeHeader = "application/json";

        /// <summary>
        /// The stream content type header.
        /// </summary>
        private const string StreamContentTypeHeader = "application/octet-stream";

        /// <summary>
        /// The subscription key name.
        /// </summary>
        private const string SubscriptionKeyName = "ocp-apim-subscription-key";

        /// <summary>
        /// The detection.
        /// </summary>
        private const string DetectionsQuery = "detections";

        /// <summary>
        /// The verification.
        /// </summary>
        private const string VerificationsQuery = "verifications";

        /// <summary>
        /// The training query.
        /// </summary>
        private const string TrainingQuery = "training";

        /// <summary>
        /// The person groups.
        /// </summary>
        private const string PersonGroupsQuery = "persongroups";

        /// <summary>
        /// The persons.
        /// </summary>
        private const string PersonsQuery = "persons";

        /// <summary>
        /// The faces query string.
        /// </summary>
        private const string FacesQuery = "faces";

        /// <summary>
        /// The face groups query
        /// </summary>
        private const string FaceGroupsQuery = "facegroups";

        /// <summary>
        /// The identifications.
        /// </summary>
        private const string IdentificationsQuery = "identifications";

        /// <summary>
        /// The default resolver.
        /// </summary>
        private static CamelCasePropertyNamesContractResolver defaultResolver = new CamelCasePropertyNamesContractResolver();

        /// <summary>
        /// The settings
        /// </summary>
        private static JsonSerializerSettings settings = new JsonSerializerSettings()
        {
            DateFormatHandling = DateFormatHandling.IsoDateFormat,
            NullValueHandling = NullValueHandling.Ignore,
            ContractResolver = defaultResolver
        };

        /// <summary>
        /// The subscription key.
        /// </summary>
        private string subscriptionKey;

        /// <summary>
        /// The HTTP client
        /// </summary>
        private HttpClient httpClient;
        #endregion

        /// <summary>
        /// Initializes a new instance of the <see cref="FaceServiceClient"/> class.
        /// </summary>
        /// <param name="subscriptionKey">The subscription key.</param>
        public FaceServiceClient(string subscriptionKey)
        {
            this.subscriptionKey = subscriptionKey;
            httpClient = new HttpClient();
            httpClient.DefaultRequestHeaders.Add(SubscriptionKeyName, subscriptionKey);
        }

        #region IFaceServiceClient implementations
        /// <summary>
        /// Detects an URL asynchronously.
        /// </summary>
        /// <param name="url">The URL.</param>
        /// <param name="analyzesFaceLandmarks">If set to <c>true</c> [analyzes face landmarks].</param>
        /// <param name="analyzesAge">If set to <c>true</c> [analyzes age].</param>
        /// <param name="analyzesGender">If set to <c>true</c> [analyzes gender].</param>
        /// <param name="analyzesHeadPose">If set to <c>true</c> [analyzes head pose].</param>
        /// <returns>The detected faces.</returns>
        public async Task<Face[]> DetectAsync(string url, bool analyzesFaceLandmarks = false, bool analyzesAge = false, bool analyzesGender = false, bool analyzesHeadPose = false)
        {
            var requestUrl = string.Format(
                "{0}/{1}?analyzesFaceLandmarks={2}&analyzesAge={3}&analyzesGender={4}&analyzesHeadPose={5}",
                ServiceHost,
                DetectionsQuery,
                analyzesFaceLandmarks,
                analyzesAge,
                analyzesGender,
                analyzesHeadPose);

            return await this.SendRequestAsync<object, Face[]>(HttpMethod.Post, requestUrl, new { url = url });
        }

        /// <summary>
        /// Detects an image asynchronously.
        /// </summary>
        /// <param name="imageStream">The image stream.</param>
        /// <param name="analyzesFaceLandmarks">If set to <c>true</c> [analyzes face landmarks].</param>
        /// <param name="analyzesAge">If set to <c>true</c> [analyzes age].</param>
        /// <param name="analyzesGender">If set to <c>true</c> [analyzes gender].</param>
        /// <param name="analyzesHeadPose">If set to <c>true</c> [analyzes head pose].</param>
        /// <returns>The detected faces.</returns>
        public async Task<Face[]> DetectAsync(Stream imageStream, bool analyzesFaceLandmarks = false, bool analyzesAge = false, bool analyzesGender = false, bool analyzesHeadPose = false)
        {
            var requestUrl = string.Format(
                "{0}/{1}?analyzesFaceLandmarks={2}&analyzesAge={3}&analyzesGender={4}&analyzesHeadPose={5}",
                ServiceHost,
                DetectionsQuery,
                analyzesFaceLandmarks,
                analyzesAge,
                analyzesGender,
                analyzesHeadPose);

            return await this.SendRequestAsync<Stream, Face[]>(HttpMethod.Post, requestUrl, imageStream);
        }

        /// <summary>
        /// Verifies whether the specified two faces belong to the same person asynchronously.
        /// </summary>
        /// <param name="faceId1">The face id 1.</param>
        /// <param name="faceId2">The face id 2.</param>
        /// <returns>The verification result.</returns>
        public async Task<VerifyResult> VerifyAsync(Guid faceId1, Guid faceId2)
        {
            var requestUrl = string.Format("{0}/{1}", ServiceHost, VerificationsQuery);

            return await this.SendRequestAsync<object, VerifyResult>(
                HttpMethod.Post,
                requestUrl,
                new
                {
                    faceId1 = faceId1,
                    faceId2 = faceId2
                });
        }

        /// <summary>
        /// Identities the faces in a given person group asynchronously.
        /// </summary>
        /// <param name="personGroupId">The person group id.</param>
        /// <param name="faceIds">The face ids.</param>
        /// <param name="maxNumOfCandidatesReturned">The maximum number of candidates returned for each face.</param>
        /// <returns>The identification results</returns>
        public async Task<IdentifyResult[]> IdentifyAsync(string personGroupId, Guid[] faceIds, int maxNumOfCandidatesReturned = 1)
        {
            var requestUrl = string.Format("{0}/{1}", ServiceHost, IdentificationsQuery);

            return await this.SendRequestAsync<object, IdentifyResult[]>(
                HttpMethod.Post,
                requestUrl,
                new
                {
                    personGroupId = personGroupId,
                    faceIds = faceIds,
                    maxNumOfCandidatesReturned = maxNumOfCandidatesReturned
                });
        }

        /// <summary>
        /// Creates the person group asynchronously.
        /// </summary>
        /// <param name="personGroupId">The person group identifier.</param>
        /// <param name="name">The name.</param>
        /// <param name="userData">The user data.</param>
        /// <returns>Task object.</returns>
        public async Task CreatePersonGroupAsync(string personGroupId, string name, string userData = null)
        {
            var requestUrl = string.Format("{0}/{1}/{2}", ServiceHost, PersonGroupsQuery, personGroupId);

            await this.SendRequestAsync<object, object>(
                HttpMethod.Put,
                requestUrl,
                new
                {
                    name = name,
                    userData = userData
                });
        }

        /// <summary>
        /// Gets a person group asynchronously.
        /// </summary>
        /// <param name="personGroupId">The person group id.</param>
        /// <returns>The person group entity.</returns>
        public async Task<PersonGroup> GetPersonGroupAsync(string personGroupId)
        {
            var requestUrl = string.Format("{0}/{1}/{2}", ServiceHost, PersonGroupsQuery, personGroupId);

            return await this.SendRequestAsync<object, PersonGroup>(HttpMethod.Get, requestUrl, null);
        }

        /// <summary>
        /// Updates a person group asynchronously.
        /// </summary>
        /// <param name="personGroupId">The person group id.</param>
        /// <param name="name">The name.</param>
        /// <param name="userData">The user data.</param>
        /// <returns>Task object.</returns>
        public async Task UpdatePersonGroupAsync(string personGroupId, string name, string userData = null)
        {
            var requestUrl = string.Format("{0}/{1}/{2}", ServiceHost, PersonGroupsQuery, personGroupId);

            await this.SendRequestAsync<object, object>(
                new HttpMethod("PATCH"),
                requestUrl,
                new
                {
                    name = name,
                    userData = userData
                });
        }

        /// <summary>
        /// Deletes a person group asynchronously.
        /// </summary>
        /// <param name="personGroupId">The person group id.</param>
        /// <returns>Task object.</returns>
        public async Task DeletePersonGroupAsync(string personGroupId)
        {
            var requestUrl = string.Format("{0}/{1}/{2}", ServiceHost, PersonGroupsQuery, personGroupId);

            await this.SendRequestAsync<object, object>(HttpMethod.Delete, requestUrl, null);
        }

        /// <summary>
        /// Gets all person groups asynchronously.
        /// </summary>
        /// <returns>Person group entity array.</returns>
        public async Task<PersonGroup[]> GetPersonGroupsAsync()
        {
            var requestUrl = string.Format(
                "{0}/{1}",
                ServiceHost,
                PersonGroupsQuery);

            return await this.SendRequestAsync<object, PersonGroup[]>(HttpMethod.Get, requestUrl, null);
        }

        /// <summary>
        /// Trains the person group asynchronously.
        /// </summary>
        /// <param name="personGroupId">The person group id.</param>
        /// <returns>Task object.</returns>
        public async Task TrainPersonGroupAsync(string personGroupId)
        {
            var requestUrl = string.Format("{0}/{1}/{2}/{3}", ServiceHost, PersonGroupsQuery, personGroupId, TrainingQuery);

            await this.SendRequestAsync<object, object>(HttpMethod.Post, requestUrl, null);
        }

        /// <summary>
        /// Gets person group training status asynchronously.
        /// </summary>
        /// <param name="personGroupId">The person group id.</param>
        /// <returns>The person group training status.</returns>
        public async Task<TrainingStatus> GetPersonGroupTrainingStatusAsync(string personGroupId)
        {
            var requestUrl = string.Format("{0}/{1}/{2}/{3}", ServiceHost, PersonGroupsQuery, personGroupId, TrainingQuery);

            return await this.SendRequestAsync<object, TrainingStatus>(HttpMethod.Get, requestUrl, null);
        }

        /// <summary>
        /// Creates a person asynchronously.
        /// </summary>
        /// <param name="personGroupId">The person group id.</param>
        /// <param name="faceIds">The face ids.</param>
        /// <param name="name">The name.</param>
        /// <param name="userData">The user data.</param>
        /// <returns>The CreatePersonResult entity.</returns>
        public async Task<CreatePersonResult> CreatePersonAsync(string personGroupId, Guid[] faceIds, string name, string userData = null)
        {
            var requestUrl = string.Format("{0}/{1}/{2}/{3}", ServiceHost, PersonGroupsQuery, personGroupId, PersonsQuery);

            return await this.SendRequestAsync<object, CreatePersonResult>(
                HttpMethod.Post,
                requestUrl,
                new
                {
                    faceIds = faceIds,
                    name = name,
                    userData = userData
                });
        }

        /// <summary>
        /// Gets a person asynchronously.
        /// </summary>
        /// <param name="personGroupId">The person group id.</param>
        /// <param name="personId">The person id.</param>
        /// <returns>The person entity.</returns>
        public async Task<Person> GetPersonAsync(string personGroupId, Guid personId)
        {
            var requestUrl = string.Format("{0}/{1}/{2}/{3}/{4}", ServiceHost, PersonGroupsQuery, personGroupId, PersonsQuery, personId);

            return await this.SendRequestAsync<object, Person>(HttpMethod.Get, requestUrl, null);
        }

        /// <summary>
        /// Updates a person asynchronously.
        /// </summary>
        /// <param name="personGroupId">The person group id.</param>
        /// <param name="personId">The person id.</param>
        /// <param name="faceIds">The face ids.</param>
        /// <param name="name">The name.</param>
        /// <param name="userData">The user data.</param>
        /// <returns>Task object.</returns>
        public async Task UpdatePersonAsync(string personGroupId, Guid personId, Guid[] faceIds, string name, string userData = null)
        {
            var requestUrl = string.Format("{0}/{1}/{2}/{3}/{4}", ServiceHost, PersonGroupsQuery, personGroupId, PersonsQuery, personId);

            await this.SendRequestAsync<object, object>(
                new HttpMethod("PATCH"),
                requestUrl,
                new
                {
                    faceIds = faceIds,
                    name = name,
                    userData = userData
                });
        }

        /// <summary>
        /// Deletes a person asynchronously.
        /// </summary>
        /// <param name="personGroupId">The person group id.</param>
        /// <param name="personId">The person id.</param>
        /// <returns>Task object.</returns>
        public async Task DeletePersonAsync(string personGroupId, Guid personId)
        {
            var requestUrl = string.Format("{0}/{1}/{2}/{3}/{4}", ServiceHost, PersonGroupsQuery, personGroupId, PersonsQuery, personId);

            await this.SendRequestAsync<object, object>(HttpMethod.Delete, requestUrl, null);
        }

        /// <summary>
        /// Gets all persons inside a person group asynchronously.
        /// </summary>
        /// <param name="personGroupId">The person group id.</param>
        /// <returns>
        /// The person entity array.
        /// </returns>
        public async Task<Person[]> GetPersonsAsync(string personGroupId)
        {
            var requestUrl = string.Format(
                "{0}/{1}/{2}/{3}",
                ServiceHost,
                PersonGroupsQuery,
                personGroupId,
                PersonsQuery);

            return await this.SendRequestAsync<object, Person[]>(HttpMethod.Get, requestUrl, null);
        }

        /// <summary>
        /// Adds a face to a person asynchronously.
        /// </summary>
        /// <param name="personGroupId">The person group id.</param>
        /// <param name="personId">The person id.</param>
        /// <param name="faceId">The face id.</param>
        /// <param name="userData">The user data.</param>
        /// <returns>
        /// Task object.
        /// </returns>
        public async Task AddPersonFaceAsync(string personGroupId, Guid personId, Guid faceId, string userData = null)
        {
            var requestUrl = string.Format("{0}/{1}/{2}/{3}/{4}/{5}/{6}", ServiceHost, PersonGroupsQuery, personGroupId, PersonsQuery, personId, FacesQuery, faceId);

            await this.SendRequestAsync<object, object>(HttpMethod.Put, requestUrl, new { userData = userData });
        }

        /// <summary>
        /// Gets a face of a person asynchronously.
        /// </summary>
        /// <param name="personGroupId">The person group id.</param>
        /// <param name="personId">The person id.</param>
        /// <param name="faceId">The face id.</param>
        /// <returns>
        /// The person face entity.
        /// </returns>
        public async Task<PersonFace> GetPersonFaceAsync(string personGroupId, Guid personId, Guid faceId)
        {
            var requestUrl = string.Format("{0}/{1}/{2}/{3}/{4}/{5}/{6}", ServiceHost, PersonGroupsQuery, personGroupId, PersonsQuery, personId, FacesQuery, faceId);

            return await this.SendRequestAsync<object, PersonFace>(HttpMethod.Get, requestUrl, null);
        }

        /// <summary>
        /// Updates a face of a person asynchronously.
        /// </summary>
        /// <param name="personGroupId">The person group id.</param>
        /// <param name="personId">The person id.</param>
        /// <param name="faceId">The face id.</param>
        /// <param name="userData">The user data.</param>
        /// <returns>
        /// Task object.
        /// </returns>
        public async Task UpdatePersonFaceAsync(string personGroupId, Guid personId, Guid faceId, string userData)
        {
            var requestUrl = string.Format("{0}/{1}/{2}/{3}/{4}/{5}/{6}", ServiceHost, PersonGroupsQuery, personGroupId, PersonsQuery, personId, FacesQuery, faceId);

            await this.SendRequestAsync<object, object>(new HttpMethod("PATCH"), requestUrl, new { userData = userData });
        }

        /// <summary>
        /// Deletes a face of a person asynchronously.
        /// </summary>
        /// <param name="personGroupId">The person group id.</param>
        /// <param name="personId">The person id.</param>
        /// <param name="faceId">The face id.</param>
        /// <returns>
        /// Task object.
        /// </returns>
        public async Task DeletePersonFaceAsync(string personGroupId, Guid personId, Guid faceId)
        {
            var requestUrl = string.Format("{0}/{1}/{2}/{3}/{4}/{5}/{6}", ServiceHost, PersonGroupsQuery, personGroupId, PersonsQuery, personId, FacesQuery, faceId);

            await this.SendRequestAsync<object, object>(HttpMethod.Delete, requestUrl, null);
        }

        /// <summary>
        /// Finds the similar faces.
        /// </summary>
        /// <param name="faceId">The face identifier.</param>
        /// <param name="faceIds">The face identifiers.</param>
        /// <param name="maxNumOfCandidatesReturned">The max number of candidates returned.</param>
        /// <returns>
        /// The similar faces.
        /// </returns>
        public async Task<SimilarFace[]> FindSimilarAsync(Guid faceId, Guid[] faceIds, int maxNumOfCandidatesReturned = 20)
        {
            var requestUrl = string.Format("{0}/findsimilars", ServiceHost);

            return await this.SendRequestAsync<object, SimilarFace[]>(
                HttpMethod.Post,
                requestUrl,
                new
                {
                    faceId = faceId,
                    faceIds = faceIds,
                    maxNumOfCandidatesReturned = maxNumOfCandidatesReturned
                });
        }

        /// <summary>
        /// Finds the similar faces.
        /// </summary>
        /// <param name="faceId">The face identifier.</param>
        /// <param name="faceGroupId">The face group identifier.</param>
        /// <param name="maxNumOfCandidatesReturned">The max number of candidates returned.</param>
        /// <returns>
        /// The similar faces.
        /// </returns>
        public async Task<SimilarFace[]> FindSimilarAsync(Guid faceId, string faceGroupId, int maxNumOfCandidatesReturned = 20)
        {
            var requestUrl = string.Format("{0}/findsimilars", ServiceHost);

            return await this.SendRequestAsync<object, SimilarFace[]>(
                HttpMethod.Post,
                requestUrl,
                new
                {
                    faceId = faceId,
                    faceGroupId = faceGroupId,
                    maxNumOfCandidatesReturned = maxNumOfCandidatesReturned
                });
        }

        /// <summary>
        /// Groups the face.
        /// </summary>
        /// <param name="faceIds">The face ids.</param>
        /// <returns>
        /// Task object.
        /// </returns>
        public async Task<GroupResult> GroupAsync(Guid[] faceIds)
        {
            var requestUrl = string.Format("{0}/groupings", ServiceHost);

            return await this.SendRequestAsync<object, GroupResult>(
                HttpMethod.Post,
                requestUrl,
                new
                {
                    faceIds = faceIds
                });
        }

        /// <summary>
        /// Creates the face group asynchronous.
        /// </summary>
        /// <param name="faceGroupId">The face group identifier.</param>
        /// <param name="name">The name.</param>
        /// <param name="userData">The user data.</param>
        /// <param name="faces">The faces.</param>
        /// <returns>
        /// Task object.
        /// </returns>
        public async Task CreateFaceGroupAsync(string faceGroupId, string name, string userData, FaceMetadata[] faces)
        {
            var requestUrl = string.Format("{0}/{1}/{2}", ServiceHost, FaceGroupsQuery, faceGroupId);

            await this.SendRequestAsync<object, object>(
                HttpMethod.Put,
                requestUrl,
                new
                {
                    name = name,
                    userData = userData,
                    faces = faces
                });
        }

        /// <summary>
        /// Gets the face group asynchronous.
        /// </summary>
        /// <param name="faceGroupId">The face group identifier.</param>
        /// <returns>
        /// Face group object.
        /// </returns>
        public async Task<FaceGroup> GetFaceGroupAsync(string faceGroupId)
        {
            var requestUrl = string.Format("{0}/{1}/{2}", ServiceHost, FaceGroupsQuery, faceGroupId);

            return await this.SendRequestAsync<object, FaceGroup>(HttpMethod.Get, requestUrl, null);
        }

        /// <summary>
        /// Lists the face groups asynchronous.
        /// </summary>
        /// <returns>
        /// Face groups object.
        /// </returns>
        public async Task<FaceGroupMetadata[]> ListFaceGroupsAsync()
        {
            var requestUrl = string.Format("{0}/{1}", ServiceHost, FaceGroupsQuery);

            return await this.SendRequestAsync<object, FaceGroupMetadata[]>(HttpMethod.Get, requestUrl, null);
        }

        /// <summary>
        /// Updates the face group asynchronous.
        /// </summary>
        /// <param name="faceGroupId">The face group identifier.</param>
        /// <param name="name">The name.</param>
        /// <param name="userData">The user data.</param>
        /// <returns>
        /// Task object.
        /// </returns>
        public async Task UpdateFaceGroupAsync(string faceGroupId, string name, string userData)
        {
            var requestUrl = string.Format("{0}/{1}/{2}", ServiceHost, FaceGroupsQuery, faceGroupId);

            await this.SendRequestAsync<object, object>(
                new HttpMethod("PATCH"),
                requestUrl,
                new
                {
                    name = name,
                    userData = userData
                });
        }

        /// <summary>
        /// Deletes the face group asynchronous.
        /// </summary>
        /// <param name="faceGroupId">The face group identifier.</param>
        /// <returns>
        /// Task object.
        /// </returns>
        public async Task DeleteFaceGroupAsync(string faceGroupId)
        {
            var requestUrl = string.Format("{0}/{1}/{2}", ServiceHost, FaceGroupsQuery, faceGroupId);

            await this.SendRequestAsync<object, object>(HttpMethod.Delete, requestUrl, null);
        }

        /// <summary>
        /// Adds the faces to face group asynchronous.
        /// </summary>
        /// <param name="faceGroupId">The face group identifier.</param>
        /// <param name="faces">The faces.</param>
        /// <returns>
        /// Task object.
        /// </returns>
        public async Task AddFacesToFaceGroupAsync(string faceGroupId, FaceMetadata[] faces)
        {
            var requestUrl = string.Format("{0}/{1}/{2}/{3}", ServiceHost, FaceGroupsQuery, faceGroupId, FacesQuery);

            await this.SendRequestAsync<object, object>(HttpMethod.Put, requestUrl, new { faces = faces });
        }

        /// <summary>
        /// Deletes the faces from face group asynchronous.
        /// </summary>
        /// <param name="faceGroupId">The face group identifier.</param>
        /// <param name="faceIds">The face ids.</param>
        /// <returns>Task object.</returns>
        public async Task DeleteFacesFromFaceGroupAsync(string faceGroupId, Guid[] faceIds)
        {
            var requestUrl = string.Format("{0}/{1}/{2}/{3}", ServiceHost, FaceGroupsQuery, faceGroupId, FacesQuery);

            await this.SendRequestAsync<object, object>(HttpMethod.Delete, requestUrl, new { faceIds = faceIds });
        }
        #endregion

        #region the json client
        /// <summary>
        /// Sends the request asynchronous.
        /// </summary>
        /// <typeparam name="TRequest">The type of the request.</typeparam>
        /// <typeparam name="TResponse">The type of the response.</typeparam>
        /// <param name="httpMethod">The HTTP method.</param>
        /// <param name="requestUrl">The request URL.</param>
        /// <param name="requestBody">The request body.</param>
        /// <returns>The response.</returns>
        /// <exception cref="ClientException">The client exception.</exception>
        private async Task<TResponse> SendRequestAsync<TRequest, TResponse>(HttpMethod httpMethod, string requestUrl, TRequest requestBody)
        {
            var request = new HttpRequestMessage(httpMethod, ServiceHost);
            request.RequestUri = new Uri(requestUrl);
            if (requestBody != null)
            {
                if (requestBody is Stream)
                {
                    request.Content = new StreamContent(requestBody as Stream);
                    request.Content.Headers.ContentType = new MediaTypeHeaderValue(StreamContentTypeHeader);
                }
                else
                {
                    request.Content = new StringContent(JsonConvert.SerializeObject(requestBody, settings), Encoding.UTF8, JsonContentTypeHeader);
                }
            }

            HttpResponseMessage response = await httpClient.SendAsync(request);
            if (response.IsSuccessStatusCode)
            {
                string responseContent = null;
                if (response.Content != null)
                {
                    responseContent = await response.Content.ReadAsStringAsync();
                }

                if (!string.IsNullOrWhiteSpace(responseContent))
                {
                    return JsonConvert.DeserializeObject<TResponse>(responseContent, settings);
                }

                return default(TResponse);
            }
            else
            {
                if (response.Content != null && response.Content.Headers.ContentType.MediaType.Contains(JsonContentTypeHeader))
                {
                    var errorObjectString = await response.Content.ReadAsStringAsync();
                    ClientError errorCollection = JsonConvert.DeserializeObject<ClientError>(errorObjectString);
                    if (errorCollection != null)
                    {
                        throw new ClientException(errorCollection, response.StatusCode);
                    }
                }

                response.EnsureSuccessStatusCode();
            }

            return default(TResponse);
        }
        #endregion

        #region IDispose implementation
        /// <summary>
        /// Performs application-defined tasks associated with freeing, releasing, or resetting unmanaged resources.
        /// </summary>
        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        /// <summary>
        /// Finalizes an instance of the <see cref="FaceServiceClient"/> class.
        /// </summary>
        ~FaceServiceClient()
        {
            Dispose(false);
        }

        /// <summary>
        /// Releases unmanaged and - optionally - managed resources.
        /// </summary>
        /// <param name="disposing"><c>true</c> to release both managed and unmanaged resources; <c>false</c> to release only unmanaged resources.</param>
        protected virtual void Dispose(bool disposing)
        {
            if (disposing)
            {
                if (this.httpClient != null)
                {
                    this.httpClient.Dispose();
                    this.httpClient = null;
                }
            }
        }
        #endregion
    }
}