using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class PulseMeshHandler : MonoBehaviour {
    
    private void OnRenderObject()
    {
        MeshFilter pulseMesh = GetComponent<MeshFilter>();
        pulseMesh.sharedMesh.RecalculateNormals();
    }
}
