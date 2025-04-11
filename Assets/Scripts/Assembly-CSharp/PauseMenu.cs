using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class PauseMenu : MonoBehaviour
{
    public static bool GameIsPaused;

    [SerializeField]
    private GameObject pauseMenuUI;

    [SerializeField]
    private GameObject confirmNewGameUI;

    [SerializeField]
    private SettingsManager settingsManager;

    [SerializeField]
    private Slider mouseSpeedSlider;

    [SerializeField]
    private Slider controllerSpeedSlider;

    [SerializeField]
    private Slider volumeSlider;

    [SerializeField]
    private Toggle invertGrabToggle;

    [SerializeField]
    private Toggle invertXToggle;

    [SerializeField]
    private Toggle invertYToggle;

    [SerializeField]
    private FadeFromBlackScript fadeBlackScript;

    [SerializeField]
    private Button resumeButton;

    [SerializeField]
    private Button confirmNewGameBACK;

    public bool pauseAllowed = true;

    private EventSystem eventSystem;

    private List<int> resIndexLookup = new List<int>();

    private void Start()
    {
        eventSystem = UnityEngine.Object.FindAnyObjectByType<EventSystem>();
    }

    private void Update()
    {
        if (pauseAllowed && (Input.GetKeyDown(KeyCode.Escape) || Input.GetButtonDown("Pause")))
        {
            if (GameIsPaused)
            {
                ResumeGame();
            }
            else
            {
                PauseGame();
            }
        }
        if (pauseAllowed && Input.GetKey(KeyCode.LeftControl) && Input.GetKeyDown(KeyCode.R))
        {
            NewGame(fadeToBlack: false);
        }
    }

    private void LoadStats()
    {
        if (PlayerPrefs.HasKey("MouseSpeed"))
        {
            mouseSpeedSlider.value = PlayerPrefs.GetFloat("MouseSpeed");
        }
        if (PlayerPrefs.HasKey("ControllerSpeed"))
        {
            controllerSpeedSlider.value = PlayerPrefs.GetFloat("ControllerSpeed");
        }
        if (PlayerPrefs.HasKey("InvertGrab"))
        {
            invertGrabToggle.isOn = PlayerPrefs.GetInt("InvertGrab") == 1;
        }
        if (PlayerPrefs.HasKey("InvertX"))
        {
            invertXToggle.isOn = PlayerPrefs.GetInt("InvertX") == 1;
        }
        if (PlayerPrefs.HasKey("InvertY"))
        {
            invertYToggle.isOn = PlayerPrefs.GetInt("InvertY") == 1;
        }
        if (PlayerPrefs.HasKey("Volume"))
        {
            volumeSlider.value = PlayerPrefs.GetFloat("Volume");
        }
        else
        {
            PlayerPrefs.SetFloat("Volume", 1f);
            volumeSlider.value = 1f;
        }
    }

    private void PauseGame()
    {
        LoadStats();
        pauseMenuUI.SetActive(value: true);
        Time.timeScale = 0f;
        GameIsPaused = true;
        Cursor.visible = true;
        Cursor.lockState = CursorLockMode.None;
        AudioListener.pause = true;
        eventSystem.SetSelectedGameObject(pauseMenuUI);
        resumeButton.Select();
    }

    public void ResumeGame()
    {
        settingsManager.ResumeGame();
        pauseMenuUI.SetActive(value: false);
        confirmNewGameUI.SetActive(value: false);
        Time.timeScale = 1f;
        GameIsPaused = false;
        Cursor.visible = false;
        Cursor.lockState = CursorLockMode.Locked;
        AudioListener.pause = false;
    }

    public void ConfirmNewGame()
    {
        pauseMenuUI.SetActive(value: false);
        confirmNewGameUI.SetActive(value: true);
        confirmNewGameBACK.Select();
    }

    public void BackToMenu()
    {
        pauseMenuUI.SetActive(value: true);
        confirmNewGameUI.SetActive(value: false);
        resumeButton.Select();
    }

    public void ResetPersonalBest()
    {
        SaveSystemJ.ResetPersonalBest();
        LoadStats();
        BackToMenu();
    }

    public void QuitGame()
    {
        Application.Quit();
    }

    public void NewGame(bool fadeToBlack = true)
    {
        if (fadeToBlack)
        {
            ResumeGame();
            fadeBlackScript.FadeToBlack(1f, 0f);
            StartCoroutine(NewGameRoutine(1.2f, quickrestart: false));
            return;
        }
        if (GameIsPaused)
        {
            ResumeGame();
        }
        fadeBlackScript.FadeToBlack(0.1f, 0f);
        StartCoroutine(NewGameRoutine(0.15f, quickrestart: true));
    }

    private IEnumerator NewGameRoutine(float wait, bool quickrestart)
    {
        yield return new WaitForSeconds(wait);
        SaveSystemJ.NewGame(quickrestart);
        SceneManager.LoadScene(SceneManager.GetActiveScene().name);
    }

    public void SetMouseSpeed(float f)
    {
        settingsManager.SetMouseSpeed(f);
    }

    public void SetControllerSpeed(float f)
    {
        settingsManager.SetControllerSpeed(f);
    }

    public void SetInvertControls(bool b)
    {
        settingsManager.SetInvertControls(b);
    }

    public void SetInvertX(bool b)
    {
        settingsManager.SetInvertX(b);
    }

    public void SetInvertY(bool b)
    {
        settingsManager.SetInvertY(b);
    }

    public void SetInvertGrab(bool b)
    {
        settingsManager.SetInvertGrab(b);
    }

    public void SetFullscreen(int mode)
    {
        switch (mode)
        {
            case 0:
                Screen.fullScreenMode = FullScreenMode.ExclusiveFullScreen;
                break;
            case 1:
                Screen.fullScreenMode = FullScreenMode.FullScreenWindow;
                break;
            case 2:
                Screen.fullScreenMode = FullScreenMode.Windowed;
                break;
        }
    }

    public void SetFPS(int selection)
    {
        if (selection == 0)
        {
            Application.targetFrameRate = 60;
            PlayerPrefs.SetInt("fps", 60);
            PlayerPrefs.Save();
        }
        if (selection == 1)
        {
            Application.targetFrameRate = 100;
            PlayerPrefs.SetInt("fps", 100);
            PlayerPrefs.Save();
        }
        if (selection == 2)
        {
            Application.targetFrameRate = 120;
            PlayerPrefs.SetInt("fps", 120);
            PlayerPrefs.Save();
        }
        if (selection == 3)
        {
            Application.targetFrameRate = 144;
            PlayerPrefs.SetInt("fps", 144);
            PlayerPrefs.Save();
        }
        if (selection == 4)
        {
            Application.targetFrameRate = 240;
            PlayerPrefs.SetInt("fps", 240);
            PlayerPrefs.Save();
        }
        if (selection == 5)
        {
            Application.targetFrameRate = 0;
            PlayerPrefs.SetInt("fps", 0);
            PlayerPrefs.Save();
        }
    }

    public void SetVolume(float volume)
    {
        settingsManager.SetVolume(volume);
    }

    public void OpenUrl(string url)
    {
        Application.OpenURL(url);
    }
}
