using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class CameraLatePostProcess : MonoBehaviour
{
	public Material material;

	private void Awake()
	{
		GetComponent<Camera>().depthTextureMode = DepthTextureMode.Depth;
	}

	private void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		if (material == null)
		{
			Graphics.Blit(source, destination);
		}
		else
		{
			Graphics.Blit(source, destination, material, 0);
		}
	}
}
