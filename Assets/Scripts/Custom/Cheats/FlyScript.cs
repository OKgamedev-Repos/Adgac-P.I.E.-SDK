using UnityEngine;

public class FlyScript : MonoBehaviour
{
    private Rigidbody2D rb;

    [SerializeField]
    private float flySpeed = 10f;

    [SerializeField]
    private Rigidbody2D legR;

    [SerializeField]
    private Rigidbody2D legL;

    private bool hover;

    private Vector2 fly;

    private void Start()
    {
        rb = GetComponent<Rigidbody2D>();
    }

    private void Update()
    {
        fly = Vector2.zero;
        if (Input.GetKey(KeyCode.I))
        {
            fly += Vector2.up;
        }
        if (Input.GetKey(KeyCode.K))
        {
            fly += Vector2.down;
        }
        if (Input.GetKey(KeyCode.J))
        {
            fly += Vector2.left * 0.5f;
        }
        if (Input.GetKey(KeyCode.L))
        {
            fly += Vector2.right * 0.5f;
        }
    }

    private void FixedUpdate()
    {
        bool flag = false;
        if (fly.magnitude > 0f)
        {
            flag = true;
        }
        if (flag)
        {
            rb.AddForce((flySpeed * fly - rb.velocity) * 50f);
            rb.freezeRotation = true;
        }
        else
        {
            rb.freezeRotation = false;
        }
    }
}
