using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class CameraOpaquePostProcess : MonoBehaviour
{
	public Material material;

	[ImageEffectOpaque]
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
