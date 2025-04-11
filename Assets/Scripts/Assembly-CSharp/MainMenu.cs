using UnityEngine;
using UnityEngine.SceneManagement;

public class MainMenu : MonoBehaviour
{
	public void ContinueGame()
	{
		SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex + 1);
	}

	public void QuitGame()
	{
		Application.Quit();
	}

	public void NewGame()
	{
		SaveSystem.NewGame();
		SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex + 1);
	}
}
