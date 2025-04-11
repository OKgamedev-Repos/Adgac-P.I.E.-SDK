using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class CameraPostProcess : MonoBehaviour
{
	public Material material;

	public Material material2;

	[ImageEffectOpaque]
	private void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		if (material == null)
		{
			Graphics.Blit(source, destination);
			return;
		}
		if (material2 == null && material != null)
		{
			Graphics.Blit(source, destination, material, 0);
			return;
		}
		RenderTexture temporary = RenderTexture.GetTemporary(source.width, source.height, 0, source.format);
		Graphics.Blit(source, temporary, material, 0);
		Graphics.Blit(temporary, destination, material2);
		RenderTexture.ReleaseTemporary(temporary);
	}
}
