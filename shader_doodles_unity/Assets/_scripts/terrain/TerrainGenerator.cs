using UnityEngine;

public class TerrainGenerator : MonoBehaviour
{
    [SerializeField]
    public int depth = 20;
    [SerializeField]
    public int width = 256;
    [SerializeField]
    public int height = 256;
    [SerializeField]
    public float scale = 20.0f;

    private void Start()
    {
        Terrain terrain = GetComponent<Terrain>();
        terrain.terrainData = _generateTerrain(terrain.terrainData);
    }

    private TerrainData _generateTerrain(TerrainData terrainData)
    {
        terrainData.heightmapResolution = width + 1;
        terrainData.size = new Vector3(width, depth, height);
        terrainData.SetHeights(0, 0, _generateHeights());
        return terrainData;
    }

    private float[,] _generateHeights()
    {
        float[,] heights = new float[width, height];
        for(int x=0; x<width; ++x)
        {
            for(int y=0; y<height; ++y)
            {
                heights[x, y] = _calculateHeight(x, y);
            }
        }
        return heights;
    }

    private float _calculateHeight(float x, float y)
    {
        float xCoord = (x / width) * scale;
        float yCoord = (y / height) * scale;

        return Mathf.PerlinNoise(xCoord, yCoord);
    }
}
