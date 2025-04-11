using System.Collections;
using UnityEngine;

public class GameSettings : MonoBehaviour
{
	private int fps;

	public float d;

	private bool lag;

	private void Start()
	{
		if (PlayerPrefs.HasKey("fps"))
		{
			Application.targetFrameRate = PlayerPrefs.GetInt("fps");
		}
		else
		{
			Application.targetFrameRate = 120;
		}
	}

	private void PreWarmPhysics()
	{
		Physics2D.velocityIterations = 75;
		Physics2D.positionIterations = 75;
	}

	private IEnumerator RestorePhysicsValues(float wait)
	{
		yield return new WaitForSeconds(wait);
		Physics2D.velocityIterations = 12;
		Physics2D.positionIterations = 12;
	}

	private void FPSDebug()
	{
		if (Input.GetKeyDown(KeyCode.L))
		{
			lag = !lag;
		}
		if (Input.GetKeyDown(KeyCode.K))
		{
			if (fps == 0)
			{
				fps = 30;
				MonoBehaviour.print("FPS: 30");
			}
			else if (fps == 30)
			{
				fps = 60;
				MonoBehaviour.print("FPS: 60");
			}
			else if (fps == 60)
			{
				fps = 120;
				MonoBehaviour.print("FPS: 120");
			}
			else if (fps == 120)
			{
				fps = 300;
				MonoBehaviour.print("FPS: 300");
			}
			else if (fps == 300)
			{
				fps = 30;
				MonoBehaviour.print("FPS: 30");
			}
			Application.targetFrameRate = fps;
		}
	}

	private void LagCPU()
	{
		d = 0f;
		for (int i = 0; i < 400000; i++)
		{
			Vector3 a = new Vector3(Random.Range(-100, 100), Random.Range(-100, 100), Random.Range(-100, 100));
			Vector3 b = new Vector3(Random.Range(-100, 100), Random.Range(-100, 100), Random.Range(-100, 100));
			float num = Vector3.Distance(a, b);
			d = num;
		}
	}
}
