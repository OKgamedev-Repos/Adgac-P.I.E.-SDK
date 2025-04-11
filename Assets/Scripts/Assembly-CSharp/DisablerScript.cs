using UnityEngine;

public class DisablerScript : MonoBehaviour
{
	public GameObject[] objects;

	[SerializeField]
	private bool disableObjects = true;

	private void Awake()
	{
		if (disableObjects)
		{
			DisableObjects();
		}
		else
		{
			Debug.Log("Warning: Object disabler disabled. Objects are NOT culling. " + base.name);
		}
	}

	private void OnTriggerEnter2D(Collider2D collision)
	{
		if (collision.tag == "Player")
		{
			EnableObjects();
		}
	}

	private void OnTriggerExit2D(Collider2D collision)
	{
		if (collision.tag == "Player")
		{
			if (disableObjects)
			{
				DisableObjects();
			}
			else
			{
				Debug.Log("Warning: Object disabler disabled. Objects are NOT culling.");
			}
		}
	}

	private void EnableObjects()
	{
		if (objects.Length == 0)
		{
			return;
		}
		for (int i = 0; i < objects.Length; i++)
		{
			if (objects[i] != null && !objects[i].activeSelf)
			{
				objects[i].SetActive(value: true);
			}
		}
	}

	private void DisableObjects()
	{
		if (objects.Length == 0)
		{
			return;
		}
		for (int i = 0; i < objects.Length; i++)
		{
			if (objects[i] != null && objects[i].activeSelf)
			{
				objects[i].SetActive(value: false);
			}
		}
	}
}
