using UnityEngine;

public class ChainScript : MonoBehaviour
{
	[SerializeField]
	private GameObject anchor;

	[SerializeField]
	private GameObject chainLink;

	[SerializeField]
	private int chainCount;

	private GameObject[] chainLinks;

	private void Start()
	{
		chainLinks = new GameObject[chainCount];
		for (int i = 0; i < chainCount; i++)
		{
			MonoBehaviour.print(i);
			chainLinks[i] = Object.Instantiate(chainLink, anchor.transform);
			chainLinks[i].transform.position += Vector3.down * chainLink.transform.localScale.y * (i + 1);
			if (i > 0)
			{
				chainLinks[i].GetComponent<HingeJoint2D>().connectedBody = chainLinks[i - 1].GetComponent<Rigidbody2D>();
			}
			else
			{
				chainLinks[i].GetComponent<HingeJoint2D>().connectedBody = anchor.GetComponent<Rigidbody2D>();
			}
		}
	}

	private void Update()
	{
	}
}
