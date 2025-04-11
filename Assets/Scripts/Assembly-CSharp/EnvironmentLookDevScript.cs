using UnityEngine;

[ExecuteInEditMode]
public class EnvironmentLookDevScript : MonoBehaviour
{
	public EnvironmentData data;

	public Material bgMat;

	public Material fgMat;

	private void Start()
	{
	}

	private void Update()
	{
		RenderSettings.ambientSkyColor = data.top;
		RenderSettings.ambientGroundColor = data.bottom;
		RenderSettings.ambientEquatorColor = data.center;
		RenderSettings.skybox.SetColor("_Color1", data.top);
		RenderSettings.skybox.SetColor("_Color2", data.center);
		RenderSettings.skybox.SetColor("_Color3", data.bottom);
		RenderSettings.sun.color = data.sun;
		bgMat.SetColor("_DepthTint", data.depthTint);
		bgMat.SetColor("_BGTop", data.bgTop);
		bgMat.SetColor("_BGBottom", data.bgBottom);
		bgMat.SetFloat("_WhitePoint", data.hazeEnd);
		bgMat.SetFloat("_WhitePointOpacity", data.hazeOpacityEnd);
		bgMat.SetFloat("_BlackPoint", data.hazeStart);
		bgMat.SetFloat("_SkyOpacity", data.skyOpacity);
		bgMat.SetFloat("_BgCavity", data.bgCavity);
		fgMat.SetColor("_FGColorTint", data.fgTint);
		fgMat.SetColor("_Lift", data.lift);
		fgMat.SetFloat("_Contrast", data.contrast);
		fgMat.SetFloat("_Saturation", data.saturation);
		fgMat.SetFloat("_Pow", data.pow);
		fgMat.SetFloat("_FGCavity", data.fgCavity);
		fgMat.SetFloat("_Exposure", data.exposure);
	}
}
