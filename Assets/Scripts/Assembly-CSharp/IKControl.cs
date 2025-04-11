using System;
using UnityEngine;

public class IKControl : MonoBehaviour
{
	protected Animator animator;

	[Header("Set These To Your Targets")]
	[SerializeField]
	private ArmScript_v2 armLeft;

	[SerializeField]
	private ArmScript_v2 armRight;

	[SerializeField]
	public Transform target_R;

	[SerializeField]
	public Transform target_L;

	[SerializeField]
	private Transform target_Look;

	public bool ikActive = true;

	[SerializeField]
	private AnimationCurve angleCurve;

	[Header("Local References To Prefab. Don't change.")]
	public Transform rightHandObj;

	public Transform leftHandObj;

	public Transform lookObj;

	public Transform poleR;

	public Transform poleL;

	public Transform rightFootTarget;

	public Transform leftFootTarget;

	[SerializeField]
	private GameObject handBone_R;

	[SerializeField]
	private GameObject handBone_L;

	[SerializeField]
	private Renderer bodyRenderer;

	private float previousAngle_R;

	private float previousAngle_L;

	private Quaternion previousRotation_R;

	private Quaternion previousRotation_L;

	private Vector3 surfaceNormal;

	private float handSurfaceDistance_R;

	private float handSurfaceDistance_L;

	private Vector3 middleFingerPos_R = Vector3.zero;

	private Vector3 middleFingerPos_L = Vector3.zero;

	private Vector3 defaultLookTarget;

	private Rigidbody2D rb;

	private Vector3 previousLookTarget;

	private bool isLookRight;

	private float timeOfSwitch;

	private bool grabL;

	private bool grabR;

	private void Start()
	{
		animator = GetComponent<Animator>();
		defaultLookTarget = target_Look.transform.localPosition;
		rb = GetComponent<Rigidbody2D>();
	}

	private void SetTargets(Transform r, Transform l, Transform look)
	{
		float num = 0.13f;
		float num2 = 25f;
		Vector3 vector = new Vector3(0f, 0f, 0.2f);
		surfaceNormal = Vector3.zero;
		if (Physics.Raycast(r.position - Vector3.forward, base.transform.TransformDirection(Vector3.forward), out var hitInfo, 3f, 1))
		{
			surfaceNormal = hitInfo.normal;
			if (armRight.activeSurface == null)
			{
				surfaceNormal = Vector3.back;
			}
			handSurfaceDistance_R = hitInfo.point.z - middleFingerPos_R.z;
			handSurfaceDistance_R -= 0.075f;
			if (armRight.isGrabbing && armRight.activeSurface != null)
			{
				handSurfaceDistance_R += 0.025f;
			}
		}
		rightHandObj.position = r.position;
		Vector2 vector2 = (Vector2)animator.GetBoneTransform(HumanBodyBones.RightShoulder).position - (Vector2)rightHandObj.transform.position;
		float num3 = Mathf.Atan2(vector2.x, vector2.y);
		num3 *= 57.29578f;
		float num4 = 1f;
		if (armRight.isGrabbing && (bool)armRight.activeSurface)
		{
			num4 = Mathf.Abs(Mathf.DeltaAngle(previousAngle_R, num3) / 50f);
			num4 = Mathf.Clamp01((num4 - 0.1f) * 2f);
			animator.SetFloat("twistR", Mathf.Clamp(Mathf.DeltaAngle(previousAngle_R, 180f) / 33f, -1f, 1f));
		}
		else
		{
			animator.SetFloat("twistR", 0f);
		}
		num3 = Mathf.LerpAngle(previousAngle_R, num3, Time.deltaTime * 10f * num4);
		rightHandObj.eulerAngles = new Vector3(num3 + 90f, 90f, -90f);
		Quaternion b = Quaternion.Lerp(Quaternion.FromToRotation(Vector3.back, surfaceNormal), Quaternion.LookRotation(Vector3.forward), 0.33f);
		if (armRight.activeSurface != null && armRight.activeSurface.isVertical && armRight.isGrabbing)
		{
			b = Quaternion.FromToRotation(Vector3.back, new Vector3(1f, 0f, -1f));
			rightHandObj.position += new Vector3(0.033f, 0f, 0f);
		}
		if (armRight.grabbedSurface != null && !armRight.isDynamicFriction && !armRight.grabbedSurface.isDynamic)
		{
			b = previousRotation_R;
		}
		previousRotation_R = Quaternion.Lerp(previousRotation_R, b, Time.deltaTime * num2);
		rightHandObj.Rotate(Vector3.up, previousRotation_R.eulerAngles.y, Space.World);
		rightHandObj.Rotate(Vector3.right, previousRotation_R.eulerAngles.x, Space.World);
		vector2 = HelperFunctions.DegreeToVector2(0f - num3 + 95f);
		rightHandObj.position += (Vector3)vector2.normalized * num;
		rightHandObj.position += vector;
		bodyRenderer.material.SetFloat("_HandDistance_R", handSurfaceDistance_R);
		bodyRenderer.materials[1].SetFloat("_HandDistance_R", handSurfaceDistance_R);
		previousAngle_R = num3;
		surfaceNormal = Vector3.zero;
		if (Physics.Raycast(l.position - Vector3.forward, base.transform.TransformDirection(Vector3.forward), out hitInfo, 3f, 1))
		{
			surfaceNormal = hitInfo.normal;
			if (armLeft.activeSurface == null)
			{
				surfaceNormal = Vector3.back;
			}
			handSurfaceDistance_L = hitInfo.point.z - middleFingerPos_L.z;
			handSurfaceDistance_L -= 0.075f;
			if (armLeft.isGrabbing && armLeft.activeSurface != null)
			{
				handSurfaceDistance_L += 0.025f;
			}
		}
		leftHandObj.position = l.position;
		vector2 = (Vector2)animator.GetBoneTransform(HumanBodyBones.LeftShoulder).position - (Vector2)leftHandObj.transform.position;
		num3 = Mathf.Atan2(vector2.x, vector2.y);
		num3 *= 57.29578f;
		num4 = 1f;
		if (armLeft.isGrabbing && (bool)armLeft.activeSurface)
		{
			num4 = Mathf.Abs(Mathf.DeltaAngle(previousAngle_L, num3) / 50f);
			num4 = Mathf.Clamp01((num4 - 0.1f) * 2f);
			animator.SetFloat("twistL", Mathf.Clamp(Mathf.DeltaAngle(previousAngle_L, 180f) / 33f, -1f, 1f));
		}
		else
		{
			animator.SetFloat("twistL", 0f);
		}
		num3 = Mathf.LerpAngle(previousAngle_L, num3, Time.deltaTime * 10f * num4);
		leftHandObj.eulerAngles = new Vector3(num3 + 90f, 90f, -90f);
		b = Quaternion.Lerp(Quaternion.FromToRotation(Vector3.back, surfaceNormal), Quaternion.LookRotation(Vector3.forward), 0.33f);
		if (armLeft.activeSurface != null && armLeft.activeSurface.isVertical && armLeft.isGrabbing)
		{
			b = Quaternion.FromToRotation(Vector3.back, new Vector3(-1f, 0f, -1f));
			leftHandObj.position -= new Vector3(0.033f, 0f, 0f);
			handSurfaceDistance_L += 0.033f;
		}
		if (armLeft.grabbedSurface != null && !armLeft.isDynamicFriction && !armLeft.grabbedSurface.isDynamic)
		{
			b = previousRotation_L;
		}
		previousRotation_L = Quaternion.Lerp(previousRotation_L, b, Time.deltaTime * num2);
		leftHandObj.Rotate(Vector3.up, previousRotation_L.eulerAngles.y, Space.World);
		leftHandObj.Rotate(Vector3.right, previousRotation_L.eulerAngles.x, Space.World);
		vector2 = HelperFunctions.DegreeToVector2(0f - num3 + 85f);
		leftHandObj.position += (Vector3)vector2.normalized * num;
		leftHandObj.position += vector;
		bodyRenderer.material.SetFloat("_HandDistance_L", handSurfaceDistance_L);
		bodyRenderer.materials[1].SetFloat("_HandDistance_L", handSurfaceDistance_L);
		previousAngle_L = num3;
		lookObj.position = look.position;
	}

	private void CalculatePoles()
	{
		Vector2 vector = (Vector2)animator.GetBoneTransform(HumanBodyBones.RightShoulder).position - (Vector2)rightHandObj.transform.position;
		poleR.transform.position = new Vector3(poleR.transform.position.x, poleR.transform.position.y, 0f - vector.y);
		vector = (Vector2)animator.GetBoneTransform(HumanBodyBones.LeftShoulder).position - (Vector2)leftHandObj.transform.position;
		poleL.transform.position = new Vector3(poleL.transform.position.x, poleL.transform.position.y, 0f - vector.y);
	}

	private void CalculateLook(float delta)
	{
		Vector3 zero = Vector3.zero;
		Vector3 vector = Vector3.forward * 0.5f;
		float num = 1.5f;
		if (rb.velocity.magnitude > 2f && !armLeft.isGrabbing && !armRight.isGrabbing)
		{
			zero = base.transform.position + defaultLookTarget + (Vector3)rb.velocity / 5f + vector;
		}
		else
		{
			zero = base.transform.position + defaultLookTarget;
			if (!armLeft.isGrabbing && armRight.isGrabbing)
			{
				grabL = false;
				if (!grabR)
				{
					grabR = true;
					timeOfSwitch = Time.time;
					isLookRight = true;
				}
				else if (Time.time - timeOfSwitch > num || armLeft.hand.position.y > armRight.hand.position.y || armLeft.hand.transform.localPosition.x / armLeft.armDistance < -0.9f)
				{
					isLookRight = false;
				}
			}
			if (armLeft.isGrabbing && !armRight.isGrabbing)
			{
				grabR = false;
				if (!grabL)
				{
					grabL = true;
					timeOfSwitch = Time.time;
					isLookRight = false;
				}
				else if (Time.time - timeOfSwitch > num || armLeft.hand.position.y < armRight.hand.position.y || armRight.hand.transform.localPosition.x / armRight.armDistance > 0.9f)
				{
					isLookRight = true;
				}
			}
			zero = ((!isLookRight) ? (armLeft.hand.transform.position + vector) : (armRight.hand.transform.position + vector));
		}
		target_Look.position = Vector3.Lerp(previousLookTarget, zero, delta * 7f);
		previousLookTarget = target_Look.position;
	}

	private void FixedUpdate()
	{
		CalculateLook(Time.fixedDeltaTime);
	}

	private void OnAnimatorIK()
	{
		if (!animator)
		{
			return;
		}
		if (ikActive)
		{
			CalculatePoles();
			SetTargets(target_R, target_L, target_Look);
			if (lookObj != null)
			{
				animator.SetLookAtWeight(1f);
				animator.SetLookAtPosition(lookObj.position);
			}
			if (rightHandObj != null)
			{
				animator.SetIKPositionWeight(AvatarIKGoal.RightHand, 1f);
				animator.SetIKRotationWeight(AvatarIKGoal.RightHand, 1f);
				animator.SetIKHintPositionWeight(AvatarIKHint.RightElbow, 0.8f);
				animator.SetIKPosition(AvatarIKGoal.RightHand, rightHandObj.position);
				animator.SetIKRotation(AvatarIKGoal.RightHand, rightHandObj.rotation);
				animator.SetIKHintPosition(AvatarIKHint.RightElbow, poleR.position);
			}
			if (leftHandObj != null)
			{
				animator.SetIKPositionWeight(AvatarIKGoal.LeftHand, 1f);
				animator.SetIKRotationWeight(AvatarIKGoal.LeftHand, 1f);
				animator.SetIKHintPositionWeight(AvatarIKHint.LeftElbow, 0.8f);
				animator.SetIKPosition(AvatarIKGoal.LeftHand, leftHandObj.position);
				animator.SetIKRotation(AvatarIKGoal.LeftHand, leftHandObj.rotation);
				animator.SetIKHintPosition(AvatarIKHint.LeftElbow, poleL.position);
			}
			float num = Mathf.Clamp01(Mathf.Cos(rb.rotation * (MathF.PI / 180f)) / 2f + 0.5f);
			if (rightFootTarget != null)
			{
				animator.SetIKPositionWeight(AvatarIKGoal.RightFoot, 0.2f * num);
				animator.SetIKRotationWeight(AvatarIKGoal.RightFoot, 0f);
				animator.SetIKPosition(AvatarIKGoal.RightFoot, rightFootTarget.position);
				animator.SetIKRotation(AvatarIKGoal.RightFoot, rightFootTarget.rotation);
			}
			if (leftFootTarget != null)
			{
				animator.SetIKPositionWeight(AvatarIKGoal.LeftFoot, 0.2f * num);
				animator.SetIKRotationWeight(AvatarIKGoal.LeftFoot, 0f);
				animator.SetIKPosition(AvatarIKGoal.LeftFoot, leftFootTarget.position);
				animator.SetIKRotation(AvatarIKGoal.LeftFoot, leftFootTarget.rotation);
			}
		}
		else
		{
			animator.SetIKPositionWeight(AvatarIKGoal.RightHand, 0f);
			animator.SetIKRotationWeight(AvatarIKGoal.RightHand, 0f);
			animator.SetIKPositionWeight(AvatarIKGoal.LeftHand, 0f);
			animator.SetIKRotationWeight(AvatarIKGoal.LeftHand, 0f);
			animator.SetLookAtWeight(0f);
		}
	}

	private void LateUpdate()
	{
		Vector3 vector = rightHandObj.position - handBone_R.transform.position;
		Vector3 vector2 = leftHandObj.position - handBone_L.transform.position;
		handBone_R.transform.parent.gameObject.transform.position += vector / 2f;
		handBone_L.transform.parent.gameObject.transform.position += vector2 / 2f;
		handBone_R.transform.gameObject.transform.position += vector / 2f;
		handBone_L.transform.gameObject.transform.position += vector2 / 2f;
		middleFingerPos_R = animator.GetBoneTransform(HumanBodyBones.RightMiddleIntermediate).position;
		middleFingerPos_L = animator.GetBoneTransform(HumanBodyBones.LeftMiddleIntermediate).position;
	}
}
