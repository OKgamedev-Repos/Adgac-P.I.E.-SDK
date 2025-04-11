using UnityEngine;

[RequireComponent(typeof(BoxCollider2D))]
public class MeshCuller : MonoBehaviour
{
	private BoxCollider2D col;

	private bool isOn = true;

	private void Start()
	{
		col = GetComponent<BoxCollider2D>();
		DisableObjects();
	}

	private void OnTriggerEnter2D(Collider2D collision)
	{
		if (collision.gameObject.tag == "Player")
		{
			EnableObjects();
		}
	}

	private void OnTriggerExit2D(Collider2D collision)
	{
		if (collision.gameObject.tag == "Player")
		{
			DisableObjects();
		}
	}

	private void EnableObjects()
	{
		if (!isOn)
		{
			isOn = true;
			Renderer[] componentsInChildren = GetComponentsInChildren<Renderer>();
			for (int i = 0; i < componentsInChildren.Length; i++)
			{
				componentsInChildren[i].enabled = true;
			}
		}
	}

	private void DisableObjects()
	{
		if (isOn)
		{
			isOn = false;
			Renderer[] componentsInChildren = GetComponentsInChildren<Renderer>();
			for (int i = 0; i < componentsInChildren.Length; i++)
			{
				componentsInChildren[i].enabled = false;
			}
		}
	}
}
