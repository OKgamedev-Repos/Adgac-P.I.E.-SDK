using UnityEngine;

public class GrabFoliageScript : MonoBehaviour
{
	private float m;

	[SerializeField]
	private GameObject foliage;

	[SerializeField]
	public Color particleColor = Color.white;

	private Material mat;

	private void Start()
	{
		if (foliage != null)
		{
			mat = foliage.GetComponent<MeshRenderer>().material;
		}
		else
		{
			Debug.Log("Foliage missing in: " + base.name);
		}
		base.enabled = false;
	}

	private void Update()
	{
		if (m > 0f && foliage != null)
		{
			m = Mathf.Lerp(m, 0f, Time.deltaTime * 5f);
			mat.SetFloat("_Grab", m);
		}
		if (m < 0.01f)
		{
			m = 0f;
			base.enabled = false;
		}
	}

	public void GrabFoliage()
	{
		base.enabled = true;
		m = Random.Range(1f, 1.5f);
	}
}
