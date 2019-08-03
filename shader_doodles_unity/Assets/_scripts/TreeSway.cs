using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class TreeSway : MonoBehaviour {
    
	void Start () {
        Material material = GetComponent<Renderer>().sharedMaterials[0];
        material.SetFloat("_Rigidness", Random.Range(20f, 30f));
        material.SetFloat("_SwayMax", Random.Range(0.005f, 0.03f));
        material.SetFloat("_TimeOffset", Random.Range(0.01f, 0.25f));
    }
	
}
