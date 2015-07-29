// *********************************************************
//
// Copyright (c) Microsoft. All rights reserved.
//
// *********************************************************

namespace Microsoft.ProjectOxford.Face.Contract
{
    /// <summary>
    /// The face group metadata class.
    /// </summary>
    public class FaceGroupMetadata
    {
        /// <summary>
        /// Gets or sets the face group identifier.
        /// </summary>
        /// <value>
        /// The face group identifier.
        /// </value>
        public string FaceGroupId { get; set; }

        /// <summary>
        /// Gets or sets the name.
        /// </summary>
        /// <value>
        /// The name.
        /// </value>
        public string Name { get; set; }

        /// <summary>
        /// Gets or sets the user data.
        /// </summary>
        /// <value>
        /// The user data.
        /// </value>
        public string UserData { get; set; }
    }
}
