using UnityEngine;

public class LightFader : MonoBehaviour
{
	[SerializeField]
	private Light[] lights;

	private float target;

	[SerializeField]
	private float intensity;

	private void Awake()
	{
		EnableLights(enable: false);
	}

	private void OnTriggerEnter2D(Collider2D collision)
	{
		if (collision.gameObject.tag == "Player")
		{
			EnableLights(enable: true);
			target = intensity;
			base.enabled = true;
		}
	}

	private void OnTriggerExit2D(Collider2D collision)
	{
		if (collision.gameObject.tag == "Player")
		{
			target = 0f;
			base.enabled = true;
		}
	}

	private void EnableLights(bool enable)
	{
		for (int i = 0; i < lights.Length; i++)
		{
			lights[i].enabled = enable;
		}
	}

	private void Update()
	{
		bool flag = true;
		if (lights.Length != 0)
		{
			for (int i = 0; i < lights.Length; i++)
			{
				if (lights[i] == null)
				{
					Debug.Log("No light in Light Fader: " + base.name);
					return;
				}
				lights[i].intensity = Mathf.Lerp(lights[i].intensity, target, Time.deltaTime);
				if (Mathf.Abs(lights[i].intensity - target) < 0.05f)
				{
					lights[i].intensity = target;
					if (target == 0f)
					{
						lights[i].enabled = false;
					}
				}
				if (lights[i].intensity != target)
				{
					flag = false;
				}
			}
		}
		if (flag)
		{
			base.enabled = false;
		}
	}
}
