using UnityEngine;

public class CameraScript : MonoBehaviour
{
	[SerializeField]
	public ClimberMain player;

	[SerializeField]
	private float lockOnSpeed = 0.125f;

	[SerializeField]
	private float zPosition = -10f;

	private AudioSource windFallingSound;

	private bool isPlayingWindSound;

	private static Vector3 defaultOffset = new Vector3(0f, 1f, 0f);

	private Rigidbody2D playerRB;

	private Vector2 velocity = Vector2.zero;

	private Vector3 offsetTarget;

	private Vector3 smoothedOffset;

	private bool freezeY;

	private float freezeYpos;

	private float returnSmoothing = 1f;

	private float unfreezeTime;

	private bool superSmooth;

	public bool clampBottomPosition;

	private void Start()
	{
		offsetTarget = defaultOffset;
		smoothedOffset = defaultOffset;
		windFallingSound = GetComponent<AudioSource>();
	}

	private void Awake()
	{
		GetComponent<Camera>().depthTextureMode = DepthTextureMode.Depth;
	}

	private void LateUpdate()
	{
		UpdateCameraPosition(Time.deltaTime);
	}

	private void FixedUpdate()
	{
		PlayWindSound();
	}

	public void SetPlayer(ClimberMain climberMain, bool setCamera)
	{
		player = climberMain;
		if (setCamera)
		{
			Vector3 position = TargetPosition();
			position.z = zPosition;
			base.transform.position = position;
		}
	}

	private void UpdateCameraPosition(float delta)
	{
		if (returnSmoothing != 1f)
		{
			returnSmoothing = Mathf.SmoothStep(0f, 1f, Time.time - unfreezeTime);
		}
		if (!(player != null))
		{
			return;
		}
		if (playerRB == null)
		{
			playerRB = player.body.GetComponent<Rigidbody2D>();
		}
		if (!player.bodyScript.isInWater && playerRB.velocity.y < -1f && playerRB.velocity.y > -25f)
		{
			smoothedOffset = Vector3.Lerp(smoothedOffset, Vector3.down * Mathf.Lerp(1f, 1.5f, (0f - playerRB.velocity.y) / 25f), delta);
		}
		else if (player.bodyScript.isInWater)
		{
			smoothedOffset = Vector3.Lerp(smoothedOffset, offsetTarget + Vector3.down * 0.5f, delta);
		}
		else
		{
			smoothedOffset = Vector3.Lerp(smoothedOffset, offsetTarget, delta);
		}
		Vector3 vector = TargetPosition();
		vector.z = zPosition;
		if (clampBottomPosition)
		{
			vector.y = Mathf.Max(0f, vector.y);
			if (base.transform.position.y > 0.5f)
			{
				clampBottomPosition = false;
			}
		}
		float sqrMagnitude = ((Vector2)base.transform.position - (Vector2)vector).sqrMagnitude;
		sqrMagnitude = Mathf.Clamp(sqrMagnitude, 0f, 10f);
		float num = lockOnSpeed;
		num *= Mathf.Clamp((0f - playerRB.velocity.y) / 10f, 1f, 3f);
		vector.y -= (num - 1f) * 2f;
		if (freezeY)
		{
			vector.y = freezeYpos;
		}
		Vector3 position = Vector3.Lerp(base.transform.position, vector, num * sqrMagnitude * delta * returnSmoothing);
		if (superSmooth && vector.y > base.transform.position.y)
		{
			position.y = Vector3.Lerp(base.transform.position, vector, delta * returnSmoothing).y;
		}
		base.transform.position = position;
	}

	public void SetCameraPosition(Vector2 position)
	{
		base.transform.position = new Vector3(position.x, position.y, zPosition);
	}

	public void OverrideOffset(Vector3 newOffset)
	{
		offsetTarget = newOffset;
	}

	public void ResetOffset()
	{
		offsetTarget = defaultOffset;
	}

	private Vector3 TargetPosition()
	{
		if (player != null)
		{
			if (player.bodyScript.isInWater)
			{
				return (player.arm_Left.transform.position + player.arm_Right.transform.position) / 2f + smoothedOffset;
			}
			return ((Vector3)(player.arm_Right.hand.position + player.arm_Left.hand.position) + player.body.transform.position) / 3f + smoothedOffset;
		}
		Debug.LogWarning("Camera does not have reference to player.");
		return Vector3.zero;
	}

	public void StopYMovement()
	{
		if (!freezeY)
		{
			freezeY = true;
			freezeYpos = TargetPosition().y;
		}
	}

	public void StartYMovement(bool up)
	{
		if (freezeY)
		{
			freezeY = false;
			if (up)
			{
				returnSmoothing = 0f;
				unfreezeTime = Time.time;
			}
			else
			{
				superSmooth = false;
			}
		}
	}

	public void ActivateSuperSmooth()
	{
		superSmooth = true;
	}

	public void DeactivateSuperSmooth()
	{
		superSmooth = false;
	}

	private void PlayWindSound()
	{
		if (!(playerRB != null))
		{
			return;
		}
		float num = 5f;
		if (!isPlayingWindSound && 0f - playerRB.velocity.y > num && (bool)windFallingSound)
		{
			windFallingSound.Play();
			windFallingSound.volume = 0f;
			isPlayingWindSound = true;
		}
		if (isPlayingWindSound)
		{
			windFallingSound.volume = Mathf.Clamp01((0f - playerRB.velocity.y - num) / 20f);
			if (0f - playerRB.velocity.y < num)
			{
				isPlayingWindSound = false;
				windFallingSound.Stop();
			}
		}
	}
}
