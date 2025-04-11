using System.Collections;
using UnityEngine;

public class ClimbingSurface : MonoBehaviour
{
	public enum SurfaceType
	{
		Rock = 0,
		Wood = 1,
		Metal = 2,
		Moss = 3,
		Air = 4,
		Water = 5,
		RunningWater = 6,
		Concrete = 7,
		Ice = 8,
		Snow = 9,
		Foliage = 10,
		Rubber = 11,
		Null = 12,
		Wet = 13,
		MetalStiff = 14,
		Cloth = 15,
		Plank = 16,
		Mushroom = 17,
		Bone = 18,
		Cloud = 19
	}

	public SurfaceType surfaceType;

	public float frictionForceLimit = 800f;

	public float dynamicMu = 0.8f;

	public int priority = 1;

	public bool isDynamic;

	public bool isPickup;

	public bool isVertical;

	public Rigidbody2D dynamicRB;

	public int isGrabbed;

	private void Awake()
	{
		if (dynamicRB == null)
		{
			dynamicRB = GetComponent<Rigidbody2D>();
		}
	}

	public void SurfaceGrabbed(ArmScript_v2 armScript)
	{
		isGrabbed++;
		if (surfaceType == SurfaceType.RunningWater)
		{
			GetComponent<RunningWater>().AddHand(armScript);
		}
		if (surfaceType == SurfaceType.Foliage || surfaceType == SurfaceType.Mushroom)
		{
			GetComponent<GrabFoliageScript>().GrabFoliage();
		}
		if (isDynamic)
		{
			dynamicRB.interpolation = RigidbodyInterpolation2D.Interpolate;
		}
	}

	public void SurfaceReleased(ArmScript_v2 armScript)
	{
		isGrabbed--;
		if (surfaceType == SurfaceType.RunningWater)
		{
			GetComponent<RunningWater>().RemoveHand(armScript);
		}
		if (surfaceType == SurfaceType.Foliage)
		{
			GetComponent<GrabFoliageScript>().GrabFoliage();
		}
		if (isDynamic)
		{
			_ = isGrabbed;
		}
		if (isPickup && isGrabbed == 0)
		{
			StartCoroutine(DestroyTimer());
		}
	}

	public void ActivatePickup()
	{
		if (isPickup)
		{
			GetComponent<Rigidbody2D>().bodyType = RigidbodyType2D.Dynamic;
		}
	}

	private IEnumerator DestroyTimer()
	{
		yield return new WaitForSeconds(2f);
		Object.Destroy(base.gameObject);
	}
}
