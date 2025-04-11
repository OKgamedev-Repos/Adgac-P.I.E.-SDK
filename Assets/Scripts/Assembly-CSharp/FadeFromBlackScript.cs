using UnityEngine;
using UnityEngine.UI;

public class FadeFromBlackScript : MonoBehaviour
{
	private Image image;

	private float timeStart;

	private float duration;

	private float step;

	private float target;

	private void Start()
	{
		image = GetComponentInChildren<Image>();
	}

	public void FadeFromBlack(float duration, float delay)
	{
		if (image == null)
		{
			image = GetComponentInChildren<Image>();
		}
		image.enabled = true;
		image.color = new Color(0f, 0f, 0f, 1f);
		timeStart = Time.time + delay;
		this.duration = duration;
		step = 0f;
		target = 0f;
		base.enabled = true;
		Object.FindObjectOfType<PauseMenu>().pauseAllowed = false;
	}

	public void FadeToBlack(float duration, float delay)
	{
		image.enabled = true;
		image.color = new Color(0f, 0f, 0f, 0f);
		base.enabled = true;
		timeStart = Time.time + delay;
		this.duration = duration;
		step = 0f;
		target = 1f;
		Object.FindObjectOfType<PauseMenu>().pauseAllowed = false;
	}

	private void Update()
	{
		if (Time.time - timeStart > 0f)
		{
			step += Mathf.Clamp(Time.deltaTime / duration, 0f, 0.3f);
			float a = Mathf.SmoothStep(1f - target, target, step);
			image.color = new Color(0f, 0f, 0f, a);
		}
		if (Mathf.Abs(image.color.a) < 0.01f && target == 0f)
		{
			image.color = new Color(0f, 0f, 0f, 0f);
			base.enabled = false;
			image.enabled = false;
			Object.FindObjectOfType<PauseMenu>().pauseAllowed = true;
		}
	}
}
