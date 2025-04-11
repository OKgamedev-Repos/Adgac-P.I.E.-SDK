using UnityEngine;

public class ParticleSpawner : MonoBehaviour
{
	private ArmScript_v2 armScript;

	[SerializeField]
	private ParticleSystem rockParticleGrab;

	[SerializeField]
	private ParticleSystem rockParticleSlide;

	[SerializeField]
	private ParticleSystem wetParticleGrab;

	[SerializeField]
	private ParticleSystem wetParticleSlide;

	[SerializeField]
	private ParticleSystem leavesParticleGrab;

	[SerializeField]
	private ParticleSystem streamParticleSlide;

	[SerializeField]
	private ParticleSystem mushroomParticleGrab;

	private ParticleSystem slideParticle;

	private void Start()
	{
		armScript = GetComponent<ArmScript_v2>();
	}

	public void GrabSurfaceParticles()
	{
		if (!(armScript != null))
		{
			return;
		}
		Vector3 position = armScript.hand.position;
		position.z = -0.5f;
		if (armScript.grabbedSurface.surfaceType == ClimbingSurface.SurfaceType.Rock)
		{
			if (rockParticleGrab != null)
			{
				Object.Instantiate(rockParticleGrab, position, Quaternion.identity);
			}
		}
		else if (armScript.grabbedSurface.surfaceType == ClimbingSurface.SurfaceType.Wet)
		{
			if (wetParticleGrab != null)
			{
				Object.Instantiate(wetParticleGrab, position, Quaternion.identity);
			}
		}
		else if (armScript.grabbedSurface.surfaceType == ClimbingSurface.SurfaceType.Foliage)
		{
			if (wetParticleGrab != null)
			{
                //Object.Instantiate(leavesParticleGrab, position, Quaternion.identity).startColor = armScript.grabbedSurface.GetComponent<GrabFoliageScript>().particleColor;
			}
		}
		else if (armScript.grabbedSurface.surfaceType == ClimbingSurface.SurfaceType.Mushroom)
		{
			if (mushroomParticleGrab != null)
			{
				Object.Instantiate(mushroomParticleGrab, position, Quaternion.identity);
			}
		}
		else if (rockParticleGrab != null)
		{
			Object.Instantiate(rockParticleGrab, position, Quaternion.identity);
		}
	}

	public void SlideSurfaceParticles()
	{
		if (slideParticle != null)
		{
			slideParticle.Stop();
		}
		Vector3 position = armScript.hand.position;
		position.z = -0.5f;
		if (armScript.grabbedSurface.surfaceType == ClimbingSurface.SurfaceType.Rock)
		{
			slideParticle = Object.Instantiate(rockParticleSlide, position, Quaternion.identity);
			slideParticle.transform.SetParent(armScript.hand.transform);
		}
		if (armScript.grabbedSurface.surfaceType == ClimbingSurface.SurfaceType.Wet)
		{
			slideParticle = Object.Instantiate(wetParticleSlide, position, Quaternion.identity);
			slideParticle.transform.SetParent(armScript.hand.transform);
		}
		if (armScript.grabbedSurface.surfaceType == ClimbingSurface.SurfaceType.RunningWater)
		{
			slideParticle = Object.Instantiate(streamParticleSlide, position, Quaternion.identity);
			slideParticle.transform.SetParent(armScript.hand.transform);
		}
	}

	public void StopSlidingParticles()
	{
		if (slideParticle != null)
		{
			slideParticle.Stop();
		}
	}
}
