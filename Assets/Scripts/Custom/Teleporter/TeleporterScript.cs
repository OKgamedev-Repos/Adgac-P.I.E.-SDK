using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using UnityEngine;
using UnityEngine.UI;

public class TeleporterScript : MonoBehaviour
{
    [Header("Teleporter")]
    public Transform teleportTarget;

    [Header("General Options")]
    public bool targetVisible;
    public bool doFade;
    public Color screenFadeColor;
    public float fadeDuration = 0.5f;

    [Header("Telepport On Collision")]
    public bool teleportOnCollision;

    [Header("Teleport On Grab")]
    public bool teleportOnGrab;
    public ClimbingSurface teleportGrabObject;

    private void Start()
    {
        if (!targetVisible)
        {
            teleportTarget.gameObject.SetActive(false);
        }
    }

    private void Update()
    {
        if (teleportOnGrab)
        {
            ClimberMain climberMain = FindObjectOfType<ClimberMain>();
            if (climberMain.arm_Left.grabbedSurface == teleportGrabObject || climberMain.arm_Right.grabbedSurface == teleportGrabObject)
            {
                if (doFade)
                {
                    Fade();
                }
                else
                {
                    DoTeleport();
                }
            }
        }
    }
    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (teleportOnCollision)
        {
            if (collision.tag == "Player")
            {
                if (doFade)
                {
                    Fade();
                }
                else
                {
                    DoTeleport();
                }
            }
        }
    }

    private void DoTeleport()
    {
        PlayerSpawn playerSpawn = FindObjectOfType<PlayerSpawn>();
        ClimberMain climberMain = FindObjectOfType<ClimberMain>();
        Body body = FindObjectOfType<Body>();

        ReleaseSurface();
        Vector2 targetPos = new Vector2(teleportTarget.transform.position.x, teleportTarget.transform.position.y);
        playerSpawn.Respawn(targetPos);

        StartCoroutine(ReleasePlayer());
    }

    private IEnumerator ReleasePlayer()
    {
        yield return new WaitForSeconds(0.1f);
            
        ClimberMain climberMain = FindObjectOfType<ClimberMain>();
        climberMain.UnfreezeBody();
        climberMain.arm_Right.listenToInput = true;
        climberMain.arm_Left.listenToInput = true;
    }

    private void Fade()
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
        yield return StartCoroutine(FadeCoroutine(image, 0, 1, duration/2));

        DoTeleport();
        yield return new WaitForSeconds(duration / 2);

        yield return StartCoroutine(FadeCoroutine(image, 1, 0, duration/2));

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

    public void ReleaseSurface()
    {
        ClimberMain climberMain = FindObjectOfType<ClimberMain>();
        ArmScript_v2 arm_Left = climberMain.arm_Left;
        ArmScript_v2 arm_Right = climberMain.arm_Right;

        MethodInfo method = arm_Left.GetType().GetMethod("ReleaseSurface",
            BindingFlags.Instance | BindingFlags.NonPublic);

        method.Invoke(arm_Left, new object[] { false, false });
        method.Invoke(arm_Right, new object[] { false, false });

        arm_Left.RemoveFrictionSurface(arm_Left.grabbedSurface);
        arm_Right.RemoveFrictionSurface(arm_Right.grabbedSurface);
    }
}
