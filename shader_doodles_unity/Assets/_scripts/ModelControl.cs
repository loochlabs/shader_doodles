using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ModelControl : MonoBehaviour {

    [Range(0, 1)]
    public float bounce = 0.5f;
    public Vector3 bouncePos = new Vector3(0, 1f, 0);

    private float thresh = 0.05f;
    private Vector3 start;

    private void Start() { 
        start = transform.position;
    }

    void Update () {
        transform.position = Vector3.Lerp(transform.position, start + bouncePos, bounce * Time.deltaTime);

        if(Vector3.Distance(transform.position, start + bouncePos) < thresh){
            bouncePos *= -1;
        }
	}
}
