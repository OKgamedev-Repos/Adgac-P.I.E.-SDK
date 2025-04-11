using UnityEngine;

[ExecuteInEditMode]
public class WaterVisualizer : MonoBehaviour
{
    public MeshRenderer meshRenderer; // Assign a MeshRenderer (e.g., quad or cube)
    public BoxCollider2D boxCollider2D; // Assign a BoxCollider2D (optional)
    public BoxCollider boxCollider3D; // Assign a BoxCollider (3D, optional)

    private void Update()
    {
        if (Application.isPlaying)
        {
            // Destroy the visualizer in Play mode
            if (meshRenderer != null)
                DestroyImmediate(meshRenderer.gameObject);
            return;
        }

        // Ensure there's a MeshRenderer assigned
        if (meshRenderer == null)
            return;

        Vector3 combinedScale = Vector3.one; // Default scale

        if (boxCollider2D != null)
        {
            // Handle BoxCollider2D
            Vector3 objectScale = transform.lossyScale;
            Vector2 colliderSize = boxCollider2D.size;
            combinedScale = new Vector3(
                colliderSize.x * objectScale.x,
                colliderSize.y * objectScale.y,
                1f
            );

            // Position for 2D BoxCollider
            Vector2 offset = boxCollider2D.offset;
            meshRenderer.transform.localPosition = new Vector3(offset.x * objectScale.x, offset.y * objectScale.y, 0f);
        }
        else if (boxCollider3D != null)
        {
            // Handle BoxCollider (3D)
            Vector3 objectScale = transform.lossyScale;
            Vector3 colliderSize = boxCollider3D.size;
            combinedScale = new Vector3(
                colliderSize.x * objectScale.x,
                colliderSize.y * objectScale.y,
                colliderSize.z * objectScale.z
            );

            // Position for 3D BoxCollider
            Vector3 offset = boxCollider3D.center;
            meshRenderer.transform.localPosition = new Vector3(
                offset.x * objectScale.x,
                offset.y * objectScale.y,
                offset.z * objectScale.z
            );
        }

        // Update the MeshRenderer scale
        meshRenderer.transform.localScale = combinedScale;
    }
}
