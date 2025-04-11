using System.Collections;
using UnityEngine;

public class PlayerSpawn : MonoBehaviour
{
	[SerializeField]
	private GameObject player;

	[SerializeField]
	private CameraScript cameraRef;

	[SerializeField]
	private SettingsManager settingsManager;

	private GameObject p;

	[SerializeField]
	private ParticleSystem spawnBubbles;

	[SerializeField]
	private FadeFromBlackScript fadeFromBlackScript;

	private void Awake()
	{
		SaveSystemJ.InitSaveSystem();
	}

	private void Start()
	{
		PlayerData playerData = SaveSystemJ.GetPlayerData();
		if (playerData.isNewGame)
		{
			NewGame(playerData);
			return;
		}
		base.transform.position = new Vector3(playerData.position[0], playerData.position[1], -0.5f);
		_ = base.transform.position.y;
		_ = -3f;
		SpawnPlayer(playerData);
		fadeFromBlackScript.FadeFromBlack(1f, 1.5f);
	}

	private void SpawnPlayer(PlayerData playerData)
	{
		p = Object.Instantiate(player, base.transform);
		p.GetComponent<ClimberMain>().FreezeBody();
		p.GetComponent<ClimberMain>().body.GetComponent<Rigidbody2D>().rotation = playerData.rotation;
		p.GetComponent<ClimberMain>().body.GetComponent<Rigidbody2D>().MovePosition(new Vector3(playerData.position[0], playerData.position[1], 0f));
		p.GetComponent<ClimberMain>().arm_Left.SetHandPosition(new Vector2(playerData.hand_l_pos[0], playerData.hand_l_pos[1]));
		p.GetComponent<ClimberMain>().arm_Right.SetHandPosition(new Vector2(playerData.hand_r_pos[0], playerData.hand_r_pos[1]));
		p.GetComponent<ClimberMain>().FireCoroutine(playerData.isNewGame);
		if (!playerData.isNewGame)
		{
			StartCoroutine(StartTimer(1f));
		}
		cameraRef.SetPlayer(p.GetComponent<ClimberMain>(), !playerData.isNewGame);
		if (settingsManager == null)
		{
			settingsManager = Object.FindAnyObjectByType(typeof(SettingsManager)) as SettingsManager;
		}
		settingsManager.player = p.GetComponent<ClimberMain>();
	}

	public void Respawn(Vector2 position)
	{
		if (p != null)
		{
			Object.Destroy(p);
		}
		base.transform.position = new Vector3(position.x, position.y, -0.5f);
		p = Object.Instantiate(player, base.transform);
		p.GetComponent<ClimberMain>().arm_Left.SetHandPosition(new Vector2(p.transform.position.x - 0.2f, p.transform.position.y + 0.5f));
		p.GetComponent<ClimberMain>().arm_Right.SetHandPosition(new Vector2(p.transform.position.x + 0.2f, p.transform.position.y + 0.5f));
		cameraRef.player = p.GetComponent<ClimberMain>();
		cameraRef.SetCameraPosition(position);
		p.GetComponent<ClimberMain>().FireCoroutine(newGame: false);
		if (settingsManager == null)
		{
			settingsManager = Object.FindAnyObjectByType(typeof(SettingsManager)) as SettingsManager;
		}
		settingsManager.player = p.GetComponent<ClimberMain>();
		spawnBubbles.Play();
	}

	public void Despawn()
	{
		if (p != null)
		{
			Object.Destroy(p);
		}
	}

	private void NewGame(PlayerData playerData)
	{
		base.transform.position = new Vector3(playerData.position[0], playerData.position[1], -0.5f);
		cameraRef.transform.position = new Vector3(1.7f, 0.3f, -10f);
		cameraRef.clampBottomPosition = true;
		SpawnPlayer(playerData);
		if (playerData.quickRestart == 1)
		{
			fadeFromBlackScript.FadeFromBlack(0.5f, 0f);
			StartCoroutine(SpawnNewGameParticles(0f));
			StartCoroutine(StartTimer(2f));
		}
		else
		{
			fadeFromBlackScript.FadeFromBlack(3f, 1f);
			StartCoroutine(SpawnNewGameParticles(4f));
			StartCoroutine(StartTimer(6f));
		}
	}

	private IEnumerator SpawnNewGameParticles(float wait)
	{
		yield return new WaitForSeconds(wait);
		spawnBubbles.Play();
		GetComponent<AudioSource>().Play();
	}

	private IEnumerator StartTimer(float wait)
	{
		yield return new WaitForSeconds(wait);
		SaveSystemJ.startTime = Time.time;
	}
}
