using UnityEngine;
using UnityEngine.Rendering;

public class SmoothLineRenderer : MonoBehaviour
{
	private LineRenderer lineRenderer;

	private AnimationCurve curveY = new AnimationCurve();

	private Keyframe[] keys;

	private int subSegments = 5;

	public void InitLineRenderer(int nodecount, Material m)
	{
		lineRenderer = base.gameObject.AddComponent<LineRenderer>();
		lineRenderer.material = m;
		lineRenderer.positionCount = (nodecount - 1) * subSegments + 1;
		lineRenderer.startWidth = 0.033f;
		lineRenderer.endWidth = 0.033f;
		lineRenderer.shadowCastingMode = ShadowCastingMode.Off;
		lineRenderer.receiveShadows = false;
	}

	public void EnableLineRenderer(bool enabled)
	{
		lineRenderer.enabled = enabled;
	}

	public void UpdatePoints(float[] posX, float[] posY, float posZ)
	{
		if (keys == null || keys.Length == 0)
		{
			keys = new Keyframe[posX.Length];
			for (int i = 0; i < posX.Length; i++)
			{
				keys[i] = new Keyframe(posX[i], posY[i]);
			}
		}
		else
		{
			for (int j = 0; j < posX.Length; j++)
			{
				keys[j].time = posX[j];
				keys[j].value = posY[j];
			}
		}
		curveY.keys = keys;
		for (int k = 0; k < posX.Length; k++)
		{
			curveY.SmoothTangents(k, 0f);
		}
		for (int l = 0; l < posX.Length; l++)
		{
			if (l < posX.Length - 1)
			{
				for (int m = 0; m < subSegments; m++)
				{
					lineRenderer.SetPosition(l * subSegments + m, new Vector3(Mathf.Lerp(posX[l], posX[l + 1], (float)m / (float)subSegments), curveY.Evaluate(Mathf.Lerp(posX[l], posX[l + 1], (float)m / (float)subSegments)), posZ));
				}
			}
			else
			{
				lineRenderer.SetPosition(l * subSegments, new Vector3(posX[l], posY[l], posZ));
			}
		}
	}
}
