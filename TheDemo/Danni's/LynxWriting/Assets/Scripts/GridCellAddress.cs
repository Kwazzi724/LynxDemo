using UnityEngine;

public class GridCellAddress : MonoBehaviour
{
    public int x;
    public int y;

    public Vector2Int Address
    {
        get { return new Vector2Int(x, y); }
    }
}
