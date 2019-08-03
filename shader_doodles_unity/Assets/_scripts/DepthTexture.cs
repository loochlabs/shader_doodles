using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class DepthTexture : MonoBehaviour {

    private Camera cam;

    private void Start()
    {
        cam = GetComponent <Camera>();
        cam.depthTextureMode = DepthTextureMode.Depth;
    }
}
