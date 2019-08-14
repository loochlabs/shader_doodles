using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine;


public class ProcGenMountain : MonoBehaviour
{
    [SerializeField]
    public GameObject prefab;

    [SerializeField]
    public Vector3 origin;

    [SerializeField]
    public Vector3 blockDimentions;

    [SerializeField]
    public float height;

    [SerializeField]
    public float bellWidth;

    // Start is called before the first frame update
    void Start()
    {
        //hide where am i's
        var objs = GameObject.FindGameObjectsWithTag("EditorOnly");
        foreach(var o in objs)
        {
            o.SetActive(false);
        }

        //spawn mountain blocks
        Vector3 blockOrigin = blockDimentions / 2;
        Quaternion zeroq = new Quaternion(0, 0, 0, 0);
        for(int x = 0; x < blockDimentions.x; ++x)
        {
            for(int z=0; z < blockDimentions.z; ++z)
            {
                Vector3 dp = new Vector3(x,0,z);
                var gauss = _createGaussValue(height, bellWidth, dp, blockOrigin);
                Debug.Log(gauss);
                GameObject block = Instantiate(prefab, origin + dp - gauss / 2, zeroq);
                block.transform.localScale = new Vector3(block.transform.localScale.x, block.transform.localScale.y * gauss.y, block.transform.localScale.z);
            }
        }


        
    }

    /// <summary>
    /// gaussian fuction
    /// f(x) = a*e * (-(x-b)^2 / (2c^2))
    /// </summary>
    /// <param name="bellHeight"></param>
    /// <param name="bellWidth"></param>
    /// <param name="origin"></param>
    /// <param name="distFromOrigin"></param>
    /// <returns></returns>
    private Vector3 _createGaussValue(float height, float width, Vector3 distFromOrigin, Vector3 origin)
    {
        Vector3 ret = new Vector3();
        ret.y = 1 / (height * -2.71f * ( ((float)Math.Pow(distFromOrigin.x - origin.x,2.0) / (2 * (float)Math.Pow(width, 2.0))) + ((float)Math.Pow(distFromOrigin.z - origin.z, 2.0) / (2 * (float)Math.Pow(width, 2.0))) )) ;
        return ret;
    }
    

}
