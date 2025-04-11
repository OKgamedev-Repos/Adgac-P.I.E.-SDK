using UnityEngine;

public class WaterMaterialScript : MonoBehaviour
{
	public float scrollSpeed = 0.015f;

	private Renderer rend;

	private void Start()
	{
		rend = GetComponent<Renderer>();
	}

	private void Update()
	{
		float num = Time.time * scrollSpeed;
		rend.material.mainTextureOffset = new Vector2(num, (0f - num) * 5f);
	}
}
