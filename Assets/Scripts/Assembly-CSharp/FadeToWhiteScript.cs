using UnityEngine;
using UnityEngine.UI;

public class FadeToWhiteScript : MonoBehaviour
{
	private Image image;

	private float t;

	private bool fadeToWhite;

	private float time;

	[SerializeField]
	private Material mat;

	private void Start()
	{
		image = GetComponentInChildren<Image>();
		image.material = mat;
		base.enabled = false;
	}

	private void Update()
	{
		float num = (fadeToWhite ? 1 : 0);
		t = Mathf.MoveTowards(t, num, time * Time.deltaTime);
		if (Mathf.Abs(t - num) < 0.01f)
		{
			t = num;
			mat.SetColor("_Color", new Color(1f, 1f, 1f, Mathf.Pow(t, 2f)));
			base.enabled = false;
			if (t == 0f)
			{
				image.enabled = false;
			}
		}
		mat.SetColor("_Color", new Color(1f, 1f, 1f, Mathf.Pow(t, 2f)));
	}

	public void FadeToWhite(float time)
	{
		image.enabled = true;
		this.time = time;
		t = 0f;
		base.enabled = true;
		fadeToWhite = true;
	}

	public void FadeFromWhite(float time)
	{
		this.time = time;
		t = 1f;
		base.enabled = true;
		fadeToWhite = false;
	}

	private void OnTriggerEnter2D(Collider2D collision)
	{
		if (collision.tag == "Player")
		{
			FadeToWhite(1f);
		}
	}
}
