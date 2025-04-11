using System.Collections.Generic;
using Rewired;
using UnityEngine;

public class ArmScript_v2 : MonoBehaviour
{
	[SerializeField]
	public bool isLeft;

	[SerializeField]
	public ArmScript_v2 otherArm;

	[SerializeField]
	public GameObject gameCursor;

	[SerializeField]
	public Rigidbody2D hand;

	[SerializeField]
	private AnimationCurve mouseCurve;

	[SerializeField]
	private AnimationCurve verticalStrengthCurve;

	[SerializeField]
	private AnimationCurve horizontalStrengthCurve;

	[SerializeField]
	private GameObject mainBody;

	private ParticleSpawner particleSpawner;

	private DistanceJoint2D distanceJoint;

	[HideInInspector]
	public FrictionJoint2D frictionJoint;

	[HideInInspector]
	public FixedJoint2D fixedJoint;

	private Rigidbody2D body;

	private Rigidbody2D gameCursorRB;

	private PlayerSoundManager soundManager;

	private Body bodyScript;

	[SerializeField]
	public float armDistance;

	[SerializeField]
	private float cursorDistance;

	[SerializeField]
	private float maxTargetVelocity;

	[SerializeField]
	private float strength;

	public bool invertControls = true;

	private Player player;

	[HideInInspector]
	public Vector2 force;

	[HideInInspector]
	public bool isGrabbing;

	[HideInInspector]
	public bool isDynamicFriction = true;

	[HideInInspector]
	public ClimbingSurface activeSurface;

	[HideInInspector]
	public ClimbingSurface grabbedSurface;

	private Vector2 mouseAxis;

	private Vector2 mouseInput;

	private List<ClimbingSurface> surfaces = new List<ClimbingSurface>();

	private int collisions;

	public bool isInWater;

	private Vector2 previousFrictionVelocity;

	private Vector2 storedForce;

	public bool listenToInput;

	private Vector2 handTargetPrevious;

	private float frictionScaler = 1f;

	private float cursorDirection = 1f;

	private float stamina = 1f;

	private bool controllerTriggerDown;

	private Vector2 controllerSmoothing = Vector2.zero;

	private Vector2 controllerSmoothingFreeHand = Vector2.zero;

	private float controllerSmoothingH;

	private float controllerSmoothingV;

	private float controllerSmoothingValue = 0.5f;

	private bool toggledThisFrame;

	private bool toggled;

	private float pullUpForce = 1.3f;

	private Vector2 pullUpAxis = Vector2.zero;

	private float mouseSpeed = 0.5f;

	private bool invertGrab;

	private bool grabToggleEnabled;

	private bool invertX;

	private bool invertY;

	private float controllerSpeed = 0.35f;

	private static float lastVoiceChargeTime;

	private float voiceChargeWeight;

	private static float lastVoiceGrabTime;

	private static float lastVoiceFallTime;

	private static bool fallSoundTriggered;

	private static bool bigFallSoundTriggered;

	private static float lastVoiceSlideTime;

	private float slideTime;

	private void Awake()
	{
		player = ReInput.players.GetPlayer(0);
	}

	private void Start()
	{
		Physics2D.gravity = new Vector2(0f, -30f);
		Cursor.visible = false;
		Cursor.lockState = CursorLockMode.Locked;
		mouseInput = Vector2.zero;
		gameCursor.transform.position = hand.transform.position;
		distanceJoint = GetComponent<DistanceJoint2D>();
		distanceJoint.distance = armDistance;
		body = GetComponent<Rigidbody2D>();
		frictionJoint = hand.GetComponent<FrictionJoint2D>();
		gameCursorRB = gameCursor.GetComponent<Rigidbody2D>();
		fixedJoint = hand.GetComponent<FixedJoint2D>();
		fixedJoint.enabled = false;
		particleSpawner = GetComponent<ParticleSpawner>();
		soundManager = GetComponent<PlayerSoundManager>();
		bodyScript = mainBody.GetComponent<Body>();
		LoadPlayerPrefs();
	}

	public void SetHandPosition(Vector2 v)
	{
		gameCursor.GetComponent<Rigidbody2D>().MovePosition(v);
		hand.MovePosition(v);
	}

	public void LoadPlayerPrefs()
	{
		if (PlayerPrefs.HasKey("MouseSpeed"))
		{
			mouseSpeed = PlayerPrefs.GetFloat("MouseSpeed");
		}
		else
		{
			PlayerPrefs.SetFloat("MouseSpeed", 0.5f);
		}
		if (PlayerPrefs.HasKey("InvertGrab"))
		{
			invertGrab = PlayerPrefs.GetInt("InvertGrab") == 1;
		}
		else
		{
			PlayerPrefs.SetInt("InvertGrab", 0);
		}
		if (PlayerPrefs.HasKey("InvertX"))
		{
			invertX = PlayerPrefs.GetInt("InvertX") == 1;
		}
		if (PlayerPrefs.HasKey("InvertY"))
		{
			invertY = PlayerPrefs.GetInt("InvertY") == 1;
		}
		if (PlayerPrefs.HasKey("ControllerSpeed"))
		{
			SetControllerSpeed(PlayerPrefs.GetFloat("ControllerSpeed"));
		}
	}

	public void ToggleGrab()
	{
		isGrabbing = true;
		GrabActiveSurface(playerInvoked: true);
		toggledThisFrame = true;
	}

	public void SetMouseSpeed(float f)
	{
		mouseSpeed = f;
	}

	public void SetControllerSpeed(float f)
	{
		controllerSpeed = f;
	}

	public void SetInvertGrab(bool invert)
	{
		invertGrab = invert;
	}

	public void SetInvertX(bool invert)
	{
		invertX = invert;
	}

	public void SetInvertY(bool invert)
	{
		invertY = invert;
	}

	public void ClearTrigger()
	{
		controllerTriggerDown = false;
	}

	private void Update()
	{
		if (listenToInput && !PauseMenu.GameIsPaused)
		{
			Vector2 vector = new Vector2(1f, 1f);
			if (invertX)
			{
				vector.x = -1f;
			}
			if (invertY)
			{
				vector.y = -1f;
			}
			if (isGrabbing && activeSurface != null && !invertControls && !activeSurface.isPickup)
			{
				mouseAxis -= new Vector2(player.GetAxis("MouseX") * vector.x, player.GetAxis("MouseY") * vector.y);
				if (!otherArm.isGrabbing && otherArm.grabbedSurface == null)
				{
					cursorDirection = Mathf.Lerp(1f, -0.5f, Mathf.Abs(body.velocity.x) / 3f);
				}
				if (player.GetButton("PullUp"))
				{
					pullUpForce = Mathf.Lerp(pullUpForce, 1.6f, Time.deltaTime * 2f);
					pullUpAxis += Vector2.down * Time.deltaTime / 0.01f * pullUpForce;
				}
			}
			else
			{
				mouseAxis += new Vector2(player.GetAxis("MouseX") * vector.x, player.GetAxis("MouseY") * vector.y);
				if (player.GetButton("PullUp"))
				{
					pullUpForce = Mathf.Lerp(pullUpForce, 1.5f, Time.deltaTime * 2f);
					pullUpAxis += Vector2.up * Time.deltaTime / 0.01f * pullUpForce;
				}
			}
			if (player.GetButtonUp("PullUp") && !player.GetButton("PullUp"))
			{
				pullUpForce = 1.3f;
			}
			cursorDirection = Mathf.Lerp(cursorDirection, 1f, Time.deltaTime * 8f);
			int num = ((!isLeft) ? 1 : 0);
			if (invertGrab)
			{
				num = 1 - num;
			}
			string actionName = (isLeft ? "GrabL" : "GrabR");
			string actionName2 = (isLeft ? "GrabLt" : "GrabRt");
			bool flag = false;
			bool flag2 = false;
			if (!controllerTriggerDown && player.GetAxis(actionName2) > 0.3f)
			{
				flag = true;
				controllerTriggerDown = true;
			}
			if (controllerTriggerDown && player.GetAxis(actionName2) < 0.3f)
			{
				flag2 = true;
				controllerTriggerDown = false;
			}
			if (!isGrabbing && (Input.GetMouseButtonDown(num) || player.GetButtonDown(actionName) || flag))
			{
				isGrabbing = true;
				GrabActiveSurface(playerInvoked: true);
				if (grabToggleEnabled)
				{
					toggled = true;
				}
			}
			if ((Input.GetMouseButtonUp(num) || player.GetButtonUp(actionName) || flag2) && !toggledThisFrame && !Input.GetMouseButton(num) && !player.GetButton(actionName) && !controllerTriggerDown)
			{
				if (grabToggleEnabled && toggled)
				{
					toggled = false;
				}
				else
				{
					isGrabbing = false;
					ReleaseSurface(playerInvoked: true, newSurface: false);
				}
			}
		}
		if (toggledThisFrame)
		{
			toggledThisFrame = false;
		}
	}

	private void FixedUpdate()
	{
		if ((mouseAxis + pullUpAxis).sqrMagnitude != 0f)
		{
			mouseInput = mouseAxis * 0.1f * mouseSpeed;
			mouseInput += pullUpAxis * 0.1f * Mathf.Max(mouseSpeed, 0.31f);
		}
		else
		{
			mouseInput /= 2f;
		}
		mouseAxis = Vector2.zero;
		pullUpAxis = Vector2.zero;
		Vector2 vector = new Vector2(player.GetAxis("HorizontalR"), player.GetAxis("VerticalR"));
		vector += new Vector2(player.GetAxis("HorizontalL"), player.GetAxis("VerticalL"));
		//float num = 0f;
		vector.x = Mathf.Lerp(b: (!isGrabbing || !(grabbedSurface != null)) ? (vector.x - (gameCursor.transform.position.x - body.transform.position.x)) : (vector.x - (body.transform.position.x - gameCursor.transform.position.x)), a: vector.x, t: Mathf.Clamp01(vector.magnitude - Mathf.Abs(vector.x)));
		vector = Vector2.ClampMagnitude(vector, 1f);
		controllerSmoothingValue = Mathf.Lerp(controllerSmoothingValue, vector.magnitude, Time.fixedDeltaTime * Mathf.Lerp(7f, 100f, Mathf.Pow(controllerSpeed, 3f)));
		controllerSmoothing = vector * controllerSmoothingValue;
		float b2 = Mathf.Lerp(0.025f, 0.1f, Mathf.Pow(controllerSpeed, 3f));
		if (isGrabbing && activeSurface != null && !activeSurface.isPickup)
		{
			b2 = Mathf.Lerp(0.02f, b2, Mathf.Pow(controllerSmoothing.magnitude, 2f));
			mouseInput -= vector * b2;
			if (otherArm.grabbedSurface == null)
			{
				mouseInput -= Vector2.up * 0.015f * Mathf.Abs(controllerSmoothingH);
			}
		}
		else
		{
			b2 = Mathf.Lerp(0.01f, b2, Mathf.Pow(controllerSmoothing.magnitude, 2f));
			controllerSmoothingFreeHand = Vector2.Lerp(controllerSmoothingFreeHand, vector, Time.fixedDeltaTime * 20f);
			mouseInput += vector * b2;
		}
		if (grabbedSurface == null)
		{
			mouseInput *= cursorDirection;
		}
		Vector2 vector2 = (Vector2)gameCursor.transform.position + mouseInput;
		if ((vector2 - (Vector2)base.transform.position).magnitude > cursorDistance)
		{
			vector2 = (Vector2)base.transform.position + (vector2 - (Vector2)base.transform.position).normalized * cursorDistance;
		}
		Vector2 vector3 = vector2 - (Vector2)hand.transform.position;
		vector2 -= (vector3 - mouseInput) * 0.5f;
		if ((grabbedSurface != null && grabbedSurface.isDynamic) || (otherArm.grabbedSurface != null && otherArm.grabbedSurface.isDynamic))
		{
			vector2 += body.velocity * Time.fixedDeltaTime;
		}
		gameCursorRB.MovePosition((Vector3)vector2);
		JointPhysics(vector3 / Time.fixedDeltaTime);
		PlayVoiceSounds();
		Friction();
		if (isGrabbing && activeSurface != null && body.velocity.y > 1f && (vector3 / Time.fixedDeltaTime).y > -1f && (!otherArm.isGrabbing || !(otherArm.activeSurface != null)))
		{
			body.AddForce(new Vector2(0f, (0f - body.velocity.y) * 2f / Time.fixedDeltaTime));
		}
	}

	private void JointPhysics(Vector2 targetVelocity)
	{
		_ = cursorDirection;
		_ = 0f;
		float num = ((hand.position.y - base.transform.position.y) / armDistance + 1f) / 2f;
		float f = (hand.position.x - base.transform.position.x) / armDistance;
		f = Mathf.Clamp(1f - Mathf.Abs(f), 0.025f, 1f);
		f = horizontalStrengthCurve.Evaluate(f);
		Vector2 vector = Vector2.ClampMagnitude(targetVelocity, maxTargetVelocity);
		if ((isGrabbing && activeSurface != null && !activeSurface.isPickup) || collisions > 0)
		{
			targetVelocity *= new Vector2(1f + (1f - num) * 2f, 1f);
			targetVelocity *= new Vector2(1f, 0.9f);
			vector = Vector2.ClampMagnitude(targetVelocity * 0.8f, maxTargetVelocity);
			float num2 = ((otherArm.hand.position.y - otherArm.transform.position.y) / armDistance + 1f) / 2f;
			vector = new Vector2(vector.x, vector.y * Mathf.Clamp01(num2 * 2f));
			vector = vector.normalized * Mathf.Pow(vector.magnitude / maxTargetVelocity, 2f) * maxTargetVelocity;
			float a = Mathf.Lerp(handTargetPrevious.x, vector.x, Time.fixedDeltaTime * 3f);
			a = HelperFunctions.ClosestTo(a, vector.x);
			float a2 = Mathf.Lerp(handTargetPrevious.y, vector.y, Time.fixedDeltaTime * 10f);
			a2 = HelperFunctions.ClosestTo(a2, vector.y);
			vector = (handTargetPrevious = new Vector2(a, a2));
		}
		Vector2 vector2 = hand.velocity - body.velocity;
		Vector2 vector3 = vector - vector2;
		Vector2 vector4;
		Vector2 vector5;
		if (isGrabbing && activeSurface != null && !activeSurface.isPickup)
		{
			float num3 = num * f;
			vector4 = vector3 * strength;
			if (!isGrabbing || !(grabbedSurface != null) || !otherArm.isGrabbing || !(otherArm.grabbedSurface != null))
			{
				vector4 *= new Vector2(Mathf.Lerp(0.1f, 1f, f), Mathf.Lerp(0.1f, 1f, num3));
			}
			storedForce = vector4;
			vector5 = -vector4;
			float num4 = 10f;
			if (otherArm.isGrabbing && otherArm.grabbedSurface != null)
			{
				num4 /= 3f;
			}
			else if (otherArm.isGrabbing)
			{
				num4 /= 1.25f;
			}
			num4 = ((!(body.velocity.y < 0f)) ? (num4 * 0.95f) : (num4 * 0.85f));
			if (bodyScript.isInWater)
			{
				num4 *= 0.5f;
			}
			vector5 -= Physics2D.gravity * num4 * num3;
			vector4 += Physics2D.gravity * num4 * num3;
		}
		else
		{
			vector5 = -vector3 * strength;
			vector4 = vector3 * strength;
		}
		body.AddForce(vector5);
		hand.AddForce(vector4);
		force = vector4;
	}

	private void Friction()
	{
		if (isGrabbing && activeSurface != null)
		{
			if (isDynamicFriction)
			{
				float num = Mathf.Sin(hand.position.y * 10f);
				hand.AddForce(Vector2.up * num * 75f);
				if (frictionJoint.reactionForce.magnitude > 0f && frictionJoint.reactionForce.magnitude < grabbedSurface.frictionForceLimit * grabbedSurface.dynamicMu * frictionScaler - 2f)
				{
					SetFriction(dynamic: false);
					particleSpawner.StopSlidingParticles();
					soundManager.StopSlideSound();
				}
				if (grabbedSurface.isDynamic)
				{
					frictionJoint.connectedAnchor = grabbedSurface.transform.InverseTransformPoint(hand.transform.position);
				}
			}
			else if (fixedJoint.reactionForce.magnitude > grabbedSurface.frictionForceLimit * frictionScaler)
			{
				SetFriction(dynamic: true);
				particleSpawner.SlideSurfaceParticles();
				soundManager.PlaySlideSound();
			}
		}
		if (isInWater)
		{
			body.AddForce(Vector2.left * Mathf.Clamp(hand.velocity.x, -10f, 10f) * 20f);
			if (grabbedSurface == null)
			{
				_ = otherArm.hand.position.y;
				_ = hand.position.y;
			}
		}
	}

	private void SetFriction(bool dynamic)
	{
		if (grabbedSurface != null)
		{
			isDynamicFriction = dynamic;
			if (isDynamicFriction)
			{
				fixedJoint.enabled = false;
				frictionJoint.enabled = true;
				UpdateFrictionScaler();
				frictionJoint.maxForce = grabbedSurface.frictionForceLimit * grabbedSurface.dynamicMu * frictionScaler;
				otherArm.UpdateFrictionScaler();
				hand.interpolation = RigidbodyInterpolation2D.Interpolate;
				particleSpawner.SlideSurfaceParticles();
				soundManager.PlaySlideSound();
			}
			else
			{
				fixedJoint.enabled = true;
				frictionJoint.maxForce = 0f;
				frictionJoint.enabled = false;
				if (!grabbedSurface.isDynamic)
				{
					hand.interpolation = RigidbodyInterpolation2D.None;
				}
			}
			if (grabbedSurface.isDynamic)
			{
				grabbedSurface.ActivatePickup();
				if (!isDynamicFriction)
				{
					if (grabbedSurface.dynamicRB != null)
					{
						fixedJoint.connectedBody = grabbedSurface.dynamicRB;
					}
					frictionJoint.connectedBody = null;
				}
				else
				{
					if (grabbedSurface.dynamicRB != null)
					{
						frictionJoint.connectedBody = grabbedSurface.dynamicRB;
					}
					fixedJoint.connectedBody = null;
				}
			}
			else
			{
				fixedJoint.connectedBody = null;
				frictionJoint.connectedBody = null;
			}
		}
		else
		{
			fixedJoint.enabled = false;
			frictionJoint.maxForce = 0f;
		}
	}

	public void AddFrictionSurface(ClimbingSurface climbingSurface)
	{
		surfaces.Add(climbingSurface);
		CheckSurface();
	}

	public void RemoveFrictionSurface(ClimbingSurface climbingSurface)
	{
		surfaces.Remove(climbingSurface);
		CheckSurface();
	}

	public void UpdateFrictionScaler()
	{
		if (otherArm.grabbedSurface != null)
		{
			frictionScaler = 0.75f;
		}
		else
		{
			frictionScaler = 1f;
		}
		if (isDynamicFriction && grabbedSurface != null)
		{
			frictionJoint.maxForce = grabbedSurface.frictionForceLimit * grabbedSurface.dynamicMu * frictionScaler;
		}
	}

	public void AddCollisionSurface()
	{
		collisions++;
	}

	public void RemoveCollisionSurface()
	{
		collisions--;
	}

	private void CheckSurface()
	{
		activeSurface = null;
		isInWater = false;
		if ((float)surfaces.Count > 0f)
		{
			foreach (ClimbingSurface surface in surfaces)
			{
				if (surface.surfaceType == ClimbingSurface.SurfaceType.Water)
				{
					isInWater = true;
				}
				else if (activeSurface == null)
				{
					activeSurface = surface;
				}
				else if (surface.priority > activeSurface.priority)
				{
					activeSurface = surface;
				}
				else if (surface.priority == activeSurface.priority && surface.frictionForceLimit > activeSurface.frictionForceLimit)
				{
					activeSurface = surface;
				}
			}
			if (activeSurface != null && activeSurface.surfaceType == ClimbingSurface.SurfaceType.Null)
			{
				activeSurface = null;
			}
			otherArm.UpdateFrictionScaler();
		}
		if (!isGrabbing || activeSurface == grabbedSurface)
		{
			return;
		}
		if (activeSurface == null && grabbedSurface != null)
		{
			if (hand.velocity.y < 0f || grabbedSurface.tag == "hCog")
			{
				cursorDirection = -0.75f;
			}
			ReleaseSurface(playerInvoked: false, newSurface: false);
		}
		if (activeSurface != null)
		{
			_ = grabbedSurface == null;
		}
		if (activeSurface != null && activeSurface != grabbedSurface)
		{
			GrabActiveSurface(playerInvoked: false);
		}
	}

	private void GrabActiveSurface(bool playerInvoked)
	{
		if (activeSurface != null && activeSurface.surfaceType != ClimbingSurface.SurfaceType.Water)
		{
			if (grabbedSurface != null)
			{
				ReleaseSurface(playerInvoked: false, newSurface: true);
			}
			grabbedSurface = activeSurface;
			SetFriction(dynamic: true);
			grabbedSurface.SurfaceGrabbed(this);
			particleSpawner.GrabSurfaceParticles();
			soundManager.PlayGrabSound(playerInvoked);
			if (playerInvoked)
			{
				PlayGrabVoiceSound();
			}
		}
	}

	private void ReleaseSurface(bool playerInvoked, bool newSurface)
	{
		hand.interpolation = RigidbodyInterpolation2D.Interpolate;
		if (playerInvoked && !otherArm.isGrabbing)
		{
			_ = otherArm.grabbedSurface == null;
		}
		if (grabbedSurface != null)
		{
			soundManager.PlayReleaseSurfaceSound(playerInvoked);
			grabbedSurface.SurfaceReleased(this);
			if (!newSurface)
			{
				grabbedSurface = null;
				SetFriction(dynamic: true);
			}
			otherArm.UpdateFrictionScaler();
			particleSpawner.StopSlidingParticles();
			soundManager.StopSlideSound();
		}
	}

	private void StaminaTick(bool deplete, float delta)
	{
		float num = (deplete ? (-1f) : 1f);
		stamina += num * delta;
		stamina = Mathf.Clamp01(stamina);
	}

	private void PlayVoiceSounds()
	{
		float num = 1.5f;
		if (isGrabbing && activeSurface != null && !activeSurface.isPickup)
		{
			if (Time.time - lastVoiceChargeTime > num && handTargetPrevious.sqrMagnitude > 10f)
			{
				voiceChargeWeight = Mathf.Lerp(voiceChargeWeight, handTargetPrevious.sqrMagnitude, Time.fixedDeltaTime);
				if (voiceChargeWeight > 10f)
				{
					lastVoiceChargeTime = Time.time;
					soundManager.PlayVoiceChargeSound();
					if (!(Random.value < 0.5f))
					{
					}
				}
			}
			else if (voiceChargeWeight != 0f)
			{
				voiceChargeWeight = 0f;
			}
		}
		if (isGrabbing && activeSurface != null && !activeSurface.isPickup && isDynamicFriction && Time.time - lastVoiceSlideTime > 2f)
		{
			if (slideTime == 0f)
			{
				slideTime = Time.time;
			}
			if (Time.time - slideTime > 0.2f)
			{
				soundManager.PlayVoiceUpsetSound();
				lastVoiceSlideTime = Time.time;
			}
		}
		else if (slideTime != 0f)
		{
			slideTime = 0f;
		}
		if (isLeft && !fallSoundTriggered && Time.time - lastVoiceFallTime > 1f && body.velocity.y < -8f)
		{
			fallSoundTriggered = true;
			lastVoiceFallTime = Time.time;
			soundManager.PlayVoiceFallSound();
		}
		if (fallSoundTriggered && body.velocity.y > -8f)
		{
			fallSoundTriggered = false;
		}
		if (isLeft && !bigFallSoundTriggered && body.velocity.y < -15f)
		{
			bigFallSoundTriggered = true;
			lastVoiceFallTime = Time.time;
			soundManager.PlayVoiceBigFallSound();
		}
		if (isLeft && bigFallSoundTriggered && body.velocity.y > -15f)
		{
			soundManager.StopVoiceBigFallSound();
			bigFallSoundTriggered = false;
		}
	}

	private void PlayGrabVoiceSound()
	{
		float num = 1f;
		if (Random.value > 0.5f && Time.time - lastVoiceGrabTime > num && otherArm.hand.position.y - base.transform.position.y < -0.2f)
		{
			lastVoiceGrabTime = Time.time;
			soundManager.PlayVoiceGrabSound();
		}
	}
}
