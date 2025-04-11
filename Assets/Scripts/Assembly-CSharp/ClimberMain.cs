using System.Collections;
using UnityEngine;

public class ClimberMain : MonoBehaviour
{
	public ArmScript_v2 arm_Right;

	public ArmScript_v2 arm_Left;

	public GameObject body;

	public Body bodyScript;

	public bool saveAllowed = true;

	public float timeStart;

	public float timeFromSave;

	[SerializeField]
	private GameObject hat;

	[SerializeField]
	private GameObject cape;

	[SerializeField]
	private ParticleSystem confetti;

	[SerializeField]
	private Material goldClothMat;

	[SerializeField]
	private SkinnedMeshRenderer loinCloth;

	private float lastSave;

	private void Start()
	{
		if (SaveSystemJ.GetPlayerData().items > 0)
		{
			SpawnHat(spawnConfetti: false);
		}
		if (SaveSystemJ.GetPlayerData().goldCloth == 1)
		{
			SpawnGoldCloth(spawnConfetti: false);
		}
	}

	private void Update()
	{
		float num = 0.5f;
		if (saveAllowed && Time.time - lastSave > num)
		{
			lastSave = Time.time;
			SaveSystemJ.SavePlayer(this);
		}
	}

	public void FreezeBody()
	{
		body.GetComponent<Rigidbody2D>().isKinematic = true;
		arm_Right.hand.GetComponent<Rigidbody2D>().isKinematic = true;
		arm_Left.hand.GetComponent<Rigidbody2D>().isKinematic = true;
	}

	public void UnfreezeBody()
	{
		body.GetComponent<Rigidbody2D>().isKinematic = false;
		arm_Right.hand.GetComponent<Rigidbody2D>().isKinematic = false;
		arm_Left.hand.GetComponent<Rigidbody2D>().isKinematic = false;
	}

	public void FireCoroutine(bool newGame)
	{
		if (newGame)
		{
			if (SaveSystemJ.GetPlayerData().quickRestart == 1)
			{
				StartCoroutine(ReleasePlayerNewGame(1f));
			}
			else
			{
				StartCoroutine(ReleasePlayerNewGame(5f));
			}
		}
		else
		{
			StartCoroutine(ReleasePlayer());
		}
	}

	private IEnumerator ReleasePlayer()
	{
		yield return new WaitForSeconds(1.5f);
		UnfreezeBody();
		arm_Right.listenToInput = true;
		arm_Left.listenToInput = true;
		if (!body.GetComponent<Body>().isInWater)
		{
			if (arm_Left.activeSurface != null && arm_Left.activeSurface.surfaceType != ClimbingSurface.SurfaceType.Water && arm_Left.activeSurface.surfaceType != ClimbingSurface.SurfaceType.RunningWater)
			{
				arm_Left.ToggleGrab();
			}
			if (arm_Right.activeSurface != null && arm_Right.activeSurface.surfaceType != ClimbingSurface.SurfaceType.Water && arm_Right.activeSurface.surfaceType != ClimbingSurface.SurfaceType.RunningWater)
			{
				arm_Right.ToggleGrab();
			}
		}
	}

	private IEnumerator ReleasePlayerNewGame(float wait)
	{
		yield return new WaitForSeconds(wait);
		UnfreezeBody();
		arm_Right.listenToInput = true;
		arm_Left.listenToInput = true;
	}

	public void SetMouseSpeed(float f)
	{
		arm_Right.SetMouseSpeed(f);
		arm_Left.SetMouseSpeed(f);
	}

	public void SetControllerSpeed(float f)
	{
		arm_Right.SetControllerSpeed(f);
		arm_Left.SetControllerSpeed(f);
	}

	public void SetInvertControls(bool invert)
	{
		arm_Right.invertControls = invert;
		arm_Left.invertControls = invert;
	}

	public void SetInvertGrab(bool invert)
	{
		arm_Right.SetInvertGrab(invert);
		arm_Left.SetInvertGrab(invert);
	}

	public void SetInvertX(bool invert)
	{
		arm_Right.SetInvertX(invert);
		arm_Left.SetInvertX(invert);
	}

	public void SetInvertY(bool invert)
	{
		arm_Right.SetInvertY(invert);
		arm_Left.SetInvertY(invert);
	}

	public void SpawnHat(bool spawnConfetti)
	{
		if (!hat.activeSelf)
		{
			hat.SetActive(value: true);
			if (spawnConfetti)
			{
				Object.Instantiate(confetti, hat.transform.position, Quaternion.identity).Play();
				arm_Right.GetComponent<PlayerSoundManager>().PlaySound("ItemUnlock");
			}
		}
	}

	public void SpawnCape(bool spawnConfetti)
	{
		cape.SetActive(value: true);
		if (spawnConfetti)
		{
			Object.Instantiate(confetti, cape.transform.position, Quaternion.identity).Play();
			arm_Right.GetComponent<PlayerSoundManager>().PlaySound("ItemUnlock");
		}
	}

	public void SpawnGoldCloth(bool spawnConfetti)
	{
		if (loinCloth.material != goldClothMat)
		{
			loinCloth.material = goldClothMat;
			if (spawnConfetti)
			{
				Object.Instantiate(confetti, loinCloth.transform.position, Quaternion.identity).Play();
				arm_Right.GetComponent<PlayerSoundManager>().PlaySound("ItemUnlock");
			}
		}
	}

	public void ToggleGrabs()
	{
		if (!body.GetComponent<Body>().isInWater)
		{
			if (arm_Left.isGrabbing && arm_Left.activeSurface != null && arm_Left.activeSurface.surfaceType != ClimbingSurface.SurfaceType.Water && arm_Left.activeSurface.surfaceType != ClimbingSurface.SurfaceType.RunningWater)
			{
				arm_Left.ToggleGrab();
				arm_Left.ClearTrigger();
			}
			if (arm_Right.isGrabbing && arm_Right.activeSurface != null && arm_Right.activeSurface.surfaceType != ClimbingSurface.SurfaceType.Water && arm_Right.activeSurface.surfaceType != ClimbingSurface.SurfaceType.RunningWater)
			{
				arm_Right.ToggleGrab();
				arm_Right.ClearTrigger();
			}
		}
	}
}
