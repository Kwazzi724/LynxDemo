using System.Collections;
using UnityEngine;

public class GridSpawner : MonoBehaviour
{
    [Header("Grid Settings")]
    public int width = 160;
    public int height = 102;
    public float cellSize = 0.1f;
    public bool centerAtOrigin = true;

    [Header("References")]
    public GameObject cellPrefab;
    public Transform gridRoot;

    [Header("Build")]
    public int yieldEvery = 500;

    private Vector2 localBottomLeft;
    private Vector2 localTopLeft;
    private float localCellSize;
    private SpriteRenderer[,] spriteAt;

    public int Width { get { return width; } }
    public int Height { get { return height; } }
    public float CellSize { get { return cellSize; } }

    private Transform GridTransform
    {
        get { return gridRoot != null ? gridRoot : transform; }
    }

    private void Start()
    {
        InitializeLocalGeometry();
        spriteAt = new SpriteRenderer[width + 1, height + 1];
        StartCoroutine(BuildGrid());
    }

    private void InitializeLocalGeometry()
    {
        Transform t = GridTransform;
        float scaleX = Mathf.Abs(t.lossyScale.x);
        float scaleY = Mathf.Abs(t.lossyScale.y);
        
        localCellSize = (scaleX > 0f) ? (cellSize / scaleX) : cellSize;

        if (centerAtOrigin)
        {
            localBottomLeft = new Vector2(-(width * localCellSize) * 0.5f,
                                          -(height * localCellSize) * 0.5f);
        }
        else
        {
            localBottomLeft = Vector2.zero;
        }

        localTopLeft = new Vector2(
            localBottomLeft.x,
            localBottomLeft.y + height * localCellSize
        );
    }

    private IEnumerator BuildGrid()
    {
        int built = 0;

        for (int y = 1; y <= height; y++)
        {
            for (int x = 1; x <= width; x++)
            {
                SpawnCellAt(x, y);
                built++;

                if (built % yieldEvery == 0)
                {
                    yield return null;
                }
            }
        }
    }

    private void SpawnCellAt(int x, int y)
    {
        if (cellPrefab == null) return;

        GameObject cell = Instantiate(cellPrefab, GridTransform);
        cell.name = "Cell_" + x + "_" + y;

        Vector3 world = AddressToWorld_TopLeft(x, y);
        cell.transform.position = world;

        SpriteRenderer spriteRenderer = cell.GetComponent<SpriteRenderer>();
        if (spriteRenderer != null && spriteRenderer.sprite != null)
        {
            float spriteLocalWidth = spriteRenderer.sprite.bounds.size.x;
            if (spriteLocalWidth > 0f)
            {
                float uniformLocalScale = localCellSize / spriteLocalWidth;
                cell.transform.localScale = new Vector3(
                    uniformLocalScale,
                    uniformLocalScale,
                    1f
                );
            }

            if (x >= 1 && x <= width && y >= 1 && y <= height)
            {
                spriteAt[x, y] = spriteRenderer;
            }
        }

        GridCellAddress address = cell.GetComponent<GridCellAddress>();
        if (address != null)
        {
            address.x = x;
            address.y = y;
        }
    }

    private Vector3 AddressToWorld_TopLeft(int x, int y)
    {
        float localX = localBottomLeft.x + (x - 0.5f) * localCellSize;
        float localY = localTopLeft.y   - (y - 0.5f) * localCellSize;
        Vector3 localCenter = new Vector3(localX, localY, 0f);
        return GridTransform.TransformPoint(localCenter);
    }

    public bool WorldToAddress(Vector3 world, out Vector2Int address)
    {
        Transform t = GridTransform;
        Vector3 local = t.InverseTransformPoint(world);

        float dx    = (local.x - localBottomLeft.x) / localCellSize;
        float dyTop = (localTopLeft.y - local.y)    / localCellSize;

        int x = Mathf.FloorToInt(dx)    + 1;
        int y = Mathf.FloorToInt(dyTop) + 1;

        if (x >= 1 && x <= width && y >= 1 && y <= height)
        {
            address = new Vector2Int(x, y);
            return true;
        }

        address = default;
        return false;
    }

    /// <summary>
    /// set the color of a cell by top-left address.
    /// </summary>
    public bool TrySetCellColor(Vector2Int address, Color color)
    {
        if (address.x < 1 || address.x > width) return false;
        if (address.y < 1 || address.y > height) return false;

        SpriteRenderer spriteRenderer = spriteAt[address.x, address.y];
        if (spriteRenderer == null) return false;

        spriteRenderer.color = color;
        return true;
    }
}
