using UnityEngine;

public class QualityManager : MonoBehaviour
{

	[SerializeField]
	private CameraLatePostProcess cameraLatePostProcess;

	[SerializeField]
	private Light dirLight;

	[SerializeField]
	private Camera bgCam;

	public void UpdateQuality()
	{
		if (QualitySettings.GetQualityLevel() == 0)
		{
			DisableLineRenderers();
		}
		else
		{
			EnableLineRenderers();
		}
		if (QualitySettings.GetQualityLevel() <= 1)
		{
			float[] array = new float[32];
			array[7] = 1f;
			dirLight.layerShadowCullDistances = array;
		}
		else
		{
			dirLight.layerShadowCullDistances = null;
		}
		if (QualitySettings.GetQualityLevel() <= 2)
		{
			cameraLatePostProcess.enabled = false;
		}
		else
		{
			cameraLatePostProcess.enabled = base.enabled;
		}
	}

	private void DisableLineRenderers()
	{
		Water[] array = Object.FindObjectsOfType<Water>();
		for (int i = 0; i < array.Length; i++)
		{
			array[i].SetSurfaceLineEnabled(enabled: false);
		}
	}

	private void EnableLineRenderers()
	{
		Water[] array = Object.FindObjectsOfType<Water>();
		for (int i = 0; i < array.Length; i++)
		{
			array[i].SetSurfaceLineEnabled(enabled: true);
		}
	}
}
