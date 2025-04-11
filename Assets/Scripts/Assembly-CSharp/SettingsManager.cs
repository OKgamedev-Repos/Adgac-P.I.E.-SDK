using UnityEngine;

public class SettingsManager : MonoBehaviour
{
	public ClimberMain player;

	public float mouseSpeed;

	private void Start()
	{
		if (PlayerPrefs.HasKey("Volume"))
		{
			AudioListener.volume = PlayerPrefs.GetFloat("Volume");
		}
	}

	public void SetMouseSpeed(float newSpeed)
	{
		if (player != null)
		{
			player.SetMouseSpeed(newSpeed);
			PlayerPrefs.SetFloat("MouseSpeed", newSpeed);
			PlayerPrefs.Save();
		}
	}

	public void SetControllerSpeed(float newSpeed)
	{
		if (player != null)
		{
			player.SetControllerSpeed(newSpeed);
			PlayerPrefs.SetFloat("ControllerSpeed", newSpeed);
			PlayerPrefs.Save();
		}
	}

	public void SetInvertControls(bool invert)
	{
		if (player != null)
		{
			player.SetInvertControls(invert);
			PlayerPrefs.SetInt("InvertControls", invert ? 1 : 0);
			PlayerPrefs.Save();
		}
	}

	public void SetInvertX(bool invert)
	{
		if (player != null)
		{
			player.SetInvertX(invert);
			PlayerPrefs.SetInt("InvertX", invert ? 1 : 0);
			PlayerPrefs.Save();
		}
	}

	public void SetInvertY(bool invert)
	{
		if (player != null)
		{
			player.SetInvertY(invert);
			PlayerPrefs.SetInt("InvertY", invert ? 1 : 0);
			PlayerPrefs.Save();
		}
	}

	public void SetInvertGrab(bool invert)
	{
		if (player != null)
		{
			player.SetInvertGrab(invert);
			PlayerPrefs.SetInt("InvertGrab", invert ? 1 : 0);
			PlayerPrefs.Save();
		}
	}

	public void SetVolume(float volume)
	{
		if (player != null)
		{
			PlayerPrefs.SetFloat("Volume", volume);
			PlayerPrefs.Save();
			AudioListener.volume = volume;
		}
	}

	public void ResumeGame()
	{
		if (player != null)
		{
			player.ToggleGrabs();
		}
	}
}
