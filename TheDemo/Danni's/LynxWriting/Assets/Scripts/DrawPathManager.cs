using System.Collections.Generic;
using System.Text;
using UnityEngine;

public class DrawPathManager : MonoBehaviour
{
    private List<Vector2Int> pathInOrder;
    private bool[,] visited;

    public void Initialize(int width, int height)
    {
        pathInOrder = new List<Vector2Int>(width * height / 4);
        visited = new bool[width + 1, height + 1]; // 1-based coords
    }

    public bool TryRecord(Vector2Int address)
    {
        if (visited == null)
        {
            return false;
        }

        if (address.x < 1 || address.x >= visited.GetLength(0)) return false;
        if (address.y < 1 || address.y >= visited.GetLength(1)) return false;

        if (visited[address.x, address.y])
        {
            return false;
        }

        visited[address.x, address.y] = true;
        pathInOrder.Add(address);
        return true;
    }

    public IReadOnlyList<Vector2Int> GetRecordedPath()
    {
        return pathInOrder;
    }

    /// <summary>
    /// prints recorded path as a C-style array:
    /// HELLO[][2] = {
    ///     {27,30},{27,31},...
    /// </summary>
    public void PrintRecordedPath(string arrayName = "HELLO")
    {
        if (pathInOrder == null || pathInOrder.Count == 0)
        {
            Debug.Log("no cells recorded.");
            return;
        }

        StringBuilder builder = new StringBuilder();

        builder.Append(arrayName).Append("[][2] = {\n    ");

        int perLine = 16; // entries per line
        for (int i = 0; i < pathInOrder.Count; i++)
        {
            Vector2Int a = pathInOrder[i];

            builder.Append("{")
                   .Append(a.x)
                   .Append(",")
                   .Append(a.y)
                   .Append("}");

            if (i < pathInOrder.Count - 1)
            {
                builder.Append(",");
            }

            // line wrapping
            if ((i + 1) % perLine == 0 && i < pathInOrder.Count - 1)
            {
                builder.Append("\n    ");
            }
        }

        builder.Append("\n};");

        Debug.Log(builder.ToString());
    }

    public void Clear()
    {
        if (visited != null)
        {
            System.Array.Clear(visited, 0, visited.Length);
        }
        if (pathInOrder != null)
        {
            pathInOrder.Clear();
        }
    }
}
