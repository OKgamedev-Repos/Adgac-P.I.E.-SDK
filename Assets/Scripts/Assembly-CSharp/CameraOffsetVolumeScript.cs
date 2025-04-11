using UnityEngine;

public class CameraOffsetVolumeScript : MonoBehaviour
{
	private CameraScript cameraScript;

	[SerializeField]
	private Vector3 offset;

	private void Start()
	{
		InitCameraScriptRef();
	}

	private void InitCameraScriptRef()
	{
		cameraScript = Object.FindAnyObjectByType<CameraScript>();
	}

	private void OnTriggerEnter2D(Collider2D collision)
	{
		if (cameraScript == null)
		{
			InitCameraScriptRef();
		}
		if (collision.tag == "Player" && cameraScript != null)
		{
			cameraScript.OverrideOffset(offset);
		}
	}

	private void OnTriggerExit2D(Collider2D collision)
	{
		if (collision.tag == "Player")
		{
			cameraScript.ResetOffset();
		}
	}
}
