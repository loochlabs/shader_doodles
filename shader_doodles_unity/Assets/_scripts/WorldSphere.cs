using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class WorldSphere : MonoBehaviour {

    private void Update()
    {
        Shader.SetGlobalVector("_Position", transform.position);
    }
}
