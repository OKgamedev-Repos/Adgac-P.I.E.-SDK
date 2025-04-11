using UnityEngine;

public class FGParticleActivator : MonoBehaviour
{
	[SerializeField]
	private int particleIndex;

	[SerializeField]
	private FGParticlesScript fgParticleScript;

	private void OnTriggerEnter2D(Collider2D collision)
	{
		if (collision.name == "Climber_Hero_Body_Prefab" && fgParticleScript != null)
		{
			fgParticleScript.EnableParticles(particleIndex);
		}
	}

	private void OnTriggerExit2D(Collider2D collision)
	{
		if (collision.name == "Climber_Hero_Body_Prefab" && fgParticleScript != null)
		{
			fgParticleScript.DisableParticles(particleIndex);
		}
	}
}
