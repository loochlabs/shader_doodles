using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DirLightRotate : MonoBehaviour {

    [Range(0, 100)]
    public float speed = 1;

    private Vector3 rotationAngle;


    private void Start()
    {
        rotationAngle = transform.localEulerAngles;
    }

    // Update is called once per frame
    void Update () {
        rotationAngle.y += speed * Time.deltaTime;
        if(rotationAngle.y >= 360)
        {
            rotationAngle.y -= 360;
        }
        transform.localEulerAngles = rotationAngle;
	}
}
