using TMPro;
using UnityEngine;

public class DebugUIScript : MonoBehaviour
{
	[SerializeField]
	private TMP_Text fps_Text;

	private float timer;

	private float hudRefreshRate = 0.2f;

	private void Update()
	{
		if (Time.unscaledTime > timer)
		{
			int num = (int)(1f / Time.unscaledDeltaTime);
			fps_Text.text = num.ToString();
			timer = Time.unscaledTime + hudRefreshRate;
		}
	}
}
