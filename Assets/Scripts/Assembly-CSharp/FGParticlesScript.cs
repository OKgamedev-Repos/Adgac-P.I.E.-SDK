using UnityEngine;

public class FGParticlesScript : MonoBehaviour
{
	[SerializeField]
	private ParticleSystem[] particles;

	public void DisableParticles(int index)
	{
		particles[index].Stop();
	}

	public void EnableParticles(int index)
	{
		particles[index].Play();
	}
}
