using UnityEngine;
using UnityEngine.InputSystem;

public class GridPainter : MonoBehaviour
{
    [Header("References")]
    public GridSpawner gridSpawner;
    public DrawPathManager drawPathManager;

    [Header("Painting")]
    public Color paintColor = Color.red;

    private bool isDrawing;
    private bool hasLastAddress;
    private Vector2Int lastAddress;

    private void Start()
    {
        if (gridSpawner == null)
        {
            gridSpawner = FindObjectOfType<GridSpawner>();
        }
        if (drawPathManager == null)
        {
            drawPathManager = FindObjectOfType<DrawPathManager>();
        }

        if (gridSpawner != null && drawPathManager != null)
        {
            drawPathManager.Initialize(gridSpawner.Width, gridSpawner.Height);
        }
    }

    private void Update()
    {
        if (Mouse.current == null)
        {
            return;
        }

        bool pressedNow = Mouse.current.leftButton.isPressed;
        Vector2 screen = Mouse.current.position.ReadValue();
        Vector3 world = ScreenToWorld(screen);

        if (pressedNow)
        {
            Vector2Int address;
            if (gridSpawner != null &&
                gridSpawner.WorldToAddress(world, out address))
            {
                if (!isDrawing)
                {
                    isDrawing = true;
                    hasLastAddress = false;
                }

                if (hasLastAddress)
                {
                    PaintLine(lastAddress, address);
                }
                else
                {
                    RecordAndPaint(address);
                    hasLastAddress = true;
                }

                lastAddress = address;
            }
        }
        else
        {
            if (isDrawing)
            {
                isDrawing = false;
                hasLastAddress = false;
            }
        }

        // Enter key to print
        if (Keyboard.current != null &&
            Keyboard.current.enterKey.wasPressedThisFrame)
        {
            if (drawPathManager != null)
            {
                drawPathManager.PrintRecordedPath("HELLO");
            }
        }
    }

    private Vector3 ScreenToWorld(Vector2 screenPosition)
    {
        Camera cam = Camera.main;
        if (cam == null)
        {
            return Vector3.zero;
        }

        Vector3 s = new Vector3(screenPosition.x, screenPosition.y, -cam.transform.position.z);
        return cam.ScreenToWorldPoint(s);
    }

    private void RecordAndPaint(Vector2Int address)
    {
        if (drawPathManager != null)
        {
            if (drawPathManager.TryRecord(address))
            {
                if (gridSpawner != null)
                {
                    gridSpawner.TrySetCellColor(address, paintColor);
                }
            }
            else
            {
                if (gridSpawner != null)
                {
                    gridSpawner.TrySetCellColor(address, paintColor);
                }
            }
        }
        else
        {
            if (gridSpawner != null)
            {
                gridSpawner.TrySetCellColor(address, paintColor);
            }
        }
    }

    private void PaintLine(Vector2Int a, Vector2Int b)
    {
        int dx = b.x - a.x;
        int dy = b.y - a.y;
        int steps = Mathf.Max(Mathf.Abs(dx), Mathf.Abs(dy));

        if (steps == 0)
        {
            RecordAndPaint(a);
            return;
        }

        for (int i = 0; i <= steps; i++)
        {
            float t = (float)i / (float)steps;
            int x = Mathf.RoundToInt(Mathf.Lerp(a.x, b.x, t));
            int y = Mathf.RoundToInt(Mathf.Lerp(a.y, b.y, t));
            RecordAndPaint(new Vector2Int(x, y));
        }
    }

    // hook
    public void PrintPathToConsole()
    {
        if (drawPathManager != null)
        {
            drawPathManager.PrintRecordedPath("HELLO");
        }
    }

    public void ClearRecordedPath()
    {
        if (drawPathManager != null)
        {
            drawPathManager.Clear();
        }
    }
}
