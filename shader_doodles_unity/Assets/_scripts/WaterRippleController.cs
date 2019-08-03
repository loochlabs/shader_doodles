using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaterRippleController : MonoBehaviour
{
    private Material material;
    private Camera cam;
    private bool mouseReleased;

    private void Start()
    {
        material = GetComponent<MeshRenderer>().material;
        cam = Camera.main;
        mouseReleased = false;
    }
    
    void Update()
    {
        if (Input.GetMouseButtonDown(0) && mouseReleased)
        {
            mouseReleased = false;
            Ray ray = cam.ScreenPointToRay(Input.mousePosition);
            RaycastHit hit;
            if (Physics.Raycast(ray, out hit))
            {
                //material.SetVector("_RippleOrigin", hit.point);
                //Shader.SetGlobalVector("_RippleOrigin", hit.point);
            }

        }
        else if (Input.GetMouseButtonUp(0) && !mouseReleased)
        {
            mouseReleased = true;
        }
        
    }
}
