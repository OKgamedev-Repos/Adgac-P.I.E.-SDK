using UnityEngine;

public class EnvironmentData : MonoBehaviour
{
	[Header("Lighting")]
	public Color top;

	public Color center;

	public Color bottom;

	public Color sun;

	public float transition = 4f;

	[Header("Background")]
	public Color bgTop;

	public Color bgBottom;

	public Color depthTint;

	public float hazeStart;

	public float hazeEnd;

	public float hazeOpacityEnd;

	[Range(0f, 1f)]
	public float skyOpacity;

	[Range(0f, 1f)]
	public float bgCavity;

	[Header("Foreground")]
	public float contrast;

	public float saturation;

	public float pow;

	public Color lift;

	public Color fgTint;

	[Range(0f, 1f)]
	public float fgCavity;

	public float exposure = 1f;
}
