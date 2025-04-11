using Steamworks;
using UnityEngine;

public class UnlockSteamAchievement : MonoBehaviour
{
	[SerializeField]
	private string key;

	private bool triggered;

	private void OnTriggerEnter2D(Collider2D collision)
	{
		if (!triggered && collision.tag == "Player" && SteamManager.Initialized)
		{
			SteamUserStats.GetAchievement(key, out var pbAchieved);
			if (!pbAchieved)
			{
				triggered = true;
				SteamUserStats.SetAchievement(key);
				SteamUserStats.StoreStats();
			}
		}
	}
}
