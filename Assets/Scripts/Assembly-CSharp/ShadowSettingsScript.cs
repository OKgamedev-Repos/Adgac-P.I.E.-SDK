using UnityEngine;

public class ShadowSettingsScript : MonoBehaviour
{
	private void OnPreRender()
	{
		if (QualitySettings.GetQualityLevel() == 4)
		{
			QualitySettings.shadowProjection = ShadowProjection.CloseFit;
			QualitySettings.shadowResolution = ShadowResolution.High;
		}
		if (QualitySettings.GetQualityLevel() == 3)
		{
			QualitySettings.shadowProjection = ShadowProjection.CloseFit;
			QualitySettings.shadowResolution = ShadowResolution.High;
		}
		if (QualitySettings.GetQualityLevel() == 2)
		{
			QualitySettings.shadowProjection = ShadowProjection.StableFit;
			QualitySettings.shadowResolution = ShadowResolution.High;
		}
		if (QualitySettings.GetQualityLevel() == 1)
		{
			QualitySettings.shadowProjection = ShadowProjection.StableFit;
			QualitySettings.shadowResolution = ShadowResolution.Medium;
		}
	}

	private void OnPostRender()
	{
		if (QualitySettings.GetQualityLevel() == 4)
		{
			QualitySettings.shadowProjection = ShadowProjection.StableFit;
			QualitySettings.shadowResolution = ShadowResolution.High;
		}
		if (QualitySettings.GetQualityLevel() == 3)
		{
			QualitySettings.shadowProjection = ShadowProjection.StableFit;
			QualitySettings.shadowResolution = ShadowResolution.Low;
		}
		if (QualitySettings.GetQualityLevel() == 2)
		{
			QualitySettings.shadowProjection = ShadowProjection.StableFit;
			QualitySettings.shadowResolution = ShadowResolution.Low;
		}
		if (QualitySettings.GetQualityLevel() == 1)
		{
			QualitySettings.shadowProjection = ShadowProjection.StableFit;
			QualitySettings.shadowResolution = ShadowResolution.Low;
		}
	}
}
