/********************************************************
*                                                        *
*   Copyright (c) Microsoft. All rights reserved.        *
*                                                        *
*********************************************************/

namespace Microsoft.ProjectOxford.Text
{
    using System.Threading.Tasks;

    /// <summary>
    /// Text service client interface.
    /// </summary>
    public interface ITextServiceClient
    {
        /// <summary>
        /// Get suggestions asynchronous.
        /// </summary>
        /// <param name="text">The text.</param>
        /// <param name="preContextText">The pre context text.</param>
        /// <param name="postContextText">The post context text.</param>
        /// <returns>
        /// SpellCheckResult object.
        /// </returns>
        Task<SpellCheckResult> GetSuggestionsAsync(string text, string preContextText = null, string postContextText = null);
    }
}
