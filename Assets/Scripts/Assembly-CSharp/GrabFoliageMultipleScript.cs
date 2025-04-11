using UnityEngine;

public class GrabFoliageMultipleScript : MonoBehaviour
{
	private float m;

	[SerializeField]
	private GameObject[] foliage;

	private Material[] mat;

	private void Start()
	{
		if (foliage != null)
		{
			for (int i = 0; i < foliage.Length; i++)
			{
				mat[i] = foliage[i].GetComponent<MeshRenderer>().material;
			}
		}
		else
		{
			Debug.Log(base.name + " is missing foliage rederence.");
		}
	}

	private void Update()
	{
		if (m > 0f)
		{
			m = Mathf.Lerp(m, 0f, Time.deltaTime * 5f);
			for (int i = 0; i < foliage.Length; i++)
			{
				mat[i].SetFloat("_Grab", m);
			}
		}
	}

	public void GrabFoliage()
	{
		m = Random.Range(1f, 1.5f);
	}
}
