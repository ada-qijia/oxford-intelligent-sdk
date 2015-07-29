// *********************************************************
//
// Copyright (c) Microsoft. All rights reserved.
//
// *********************************************************

namespace Microsoft.ProjectOxford.Face.Contract
{
    /// <summary>
    /// The face group class
    /// </summary>
    public class FaceGroup : FaceGroupMetadata
    {
        /// <summary>
        /// Gets or sets the faces.
        /// </summary>
        /// <value>
        /// The faces.
        /// </value>
        public PersonFace[] Faces { get; set; }
    }
}
