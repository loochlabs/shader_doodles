using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine;

[ExecuteInEditMode]
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

    [SerializeField]
    public Vector3 scale = new Vector3(1,1,1);

    private List<GameObject> m_currentBlocks;
    private float m_height;
    private float m_bellWidth;
    private Vector3 m_origin;
    private Vector3 m_blockDimensions;

    // Start is called before the first frame update
    void Start()
    {
        //hide where am i's
        var objs = GameObject.FindGameObjectsWithTag("EditorOnly");
        foreach(var o in objs)
        {
            o.SetActive(false);
        }

    }

    public void Update()
    {
        if(m_height != height || m_bellWidth != bellWidth || m_origin != origin || m_blockDimensions != blockDimentions)
        {
            m_height = height;
            m_bellWidth = bellWidth;
            m_origin = origin;
            m_blockDimensions = blockDimentions;

            //cleanup the old blocks
            foreach (GameObject obj in m_currentBlocks)
                DestroyImmediate(obj);

            m_currentBlocks.Clear();

            _generate();
        }   
    }

    /// <summary>
    /// Generate moutiain
    /// </summary>
    private void _generate()
    {
        Vector3 blockOrigin = m_blockDimensions / 2;
        Quaternion zeroq = new Quaternion(0, 0, 0, 0);
        for (int x = 0; x < m_blockDimensions.x; ++x)
        {
            for (int z = 0; z < m_blockDimensions.z; ++z)
            {
                Vector3 dp = new Vector3(x, 0, z);
                var gauss = _createGaussValue(m_height, m_bellWidth, dp, blockOrigin);
                GameObject block = Instantiate(prefab, m_origin + dp - (gauss / 2), zeroq);
                block.transform.localScale = new Vector3(scale.x, scale.y * gauss.y, scale.z);
                m_currentBlocks.Add(block);
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
        ret.y = 1 / (height * -2.71f * 
            ( ((float)Math.Pow(distFromOrigin.x - origin.x,2.0) / (2 * (float)Math.Pow(width, 2.0))) + 
            ((float)Math.Pow(distFromOrigin.z - origin.z, 2.0) / (2 * (float)Math.Pow(width, 2.0))) )) ;
        return ret;
    }

    
    

}
