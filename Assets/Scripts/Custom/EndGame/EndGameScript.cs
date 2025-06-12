using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class EndGameScript : MonoBehaviour
{
    [Header("General Options")]
    public Color screenFadeColor;
    public float fadeDuration = 1f;

    [Header("End On Collision")]
    public bool endOnCollision;

    [Header("End On Grab")]
    public bool endOnGrab;
    public ClimbingSurface endGrabObject;


    private void Update()
    {
        if(endOnGrab)
        {
            ClimberMain climberMain = FindObjectOfType<ClimberMain>();
            if(climberMain.arm_Left.grabbedSurface == endGrabObject || climberMain.arm_Right.grabbedSurface == endGrabObject)
            {
                Fade();
                climberMain.arm_Left.isGrabbing = false;
                climberMain.arm_Right.isGrabbing = false;
            }

            //if(endGrabObject.isGrabbed == 1)
            //{
            //    Fade();
            //    endGrabObject.isGrabbed = 0;
            //}
        }
    }
    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (endOnCollision)
        {
            if (collision.tag == "Player")
            {
                Fade();
            }
        }
    }

    public void EndGame()
    {
        Debug.Log("Ending game...");

        SaveSystemJ.ClearGame();

        SpawnLocationScript spawnPos = FindObjectOfType<SpawnLocationScript>(); 
        PlayerSpawn playerSpawn = FindObjectOfType<PlayerSpawn>();

        playerSpawn.Respawn(spawnPos.transform.position);
    }

    public void Fade()
    {
        GameObject canvasObject = new GameObject("FullScreenCanvas");
        Canvas canvas = canvasObject.AddComponent<Canvas>();
        canvas.renderMode = RenderMode.ScreenSpaceOverlay;
        canvasObject.AddComponent<CanvasScaler>();
        canvasObject.AddComponent<GraphicRaycaster>();

        GameObject panelObject = new GameObject("FullScreenPanel");
        panelObject.transform.SetParent(canvasObject.transform, false);

        RectTransform rectTransform = panelObject.AddComponent<RectTransform>();
        rectTransform.anchorMin = Vector2.zero;
        rectTransform.anchorMax = Vector2.one;
        rectTransform.offsetMin = Vector2.zero;
        rectTransform.offsetMax = Vector2.zero;

        Image panelImage = panelObject.AddComponent<Image>();
        panelImage.color = screenFadeColor;

        StartCoroutine(FadeInOut(panelImage, fadeDuration));
    }
    private IEnumerator FadeInOut(Image image, float duration)
    {
        yield return StartCoroutine(FadeCoroutine(image, 0, 1, duration));

        EndGame();
        yield return new WaitForSeconds(duration/2);

        yield return StartCoroutine(FadeCoroutine(image, 1, 0, duration));

        Destroy(image.gameObject.transform.parent.gameObject); 
    }

    private IEnumerator FadeCoroutine(Image image, float startAlpha, float endAlpha, float duration)
    {
        float elapsedTime = 0f;
        Color color = image.color;

        while (elapsedTime < duration)
        {
            color.a = Mathf.Lerp(startAlpha, endAlpha, elapsedTime / duration);
            image.color = color;
            elapsedTime += Time.deltaTime;
            yield return null;
        }

        color.a = endAlpha;
        image.color = color;
    }
}
