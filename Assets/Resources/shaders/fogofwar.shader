Shader "DynamicFog/Fog Of War" {
	Properties {
		_MainTex ("Base (RGBA)", 2D) = "white" {}
		_NoiseTex ("Noise (RGB)", 2D) = "white" {}
		_Color ("Color", Vector) = (1,1,1,1)
		_Speed ("Speed", Range(0, 0.1)) = 0.002
		_Direction ("Direction", Vector) = (1,1,0,1)
		_Scale1 ("Scale 1", Range(1, 10)) = 8
		_Scale2 ("Scale 2", Range(1, 10)) = 2
		_FogOfWarData ("Data", Vector) = (0,0,2000,2000)
	}
	//DummyShaderTextExporter
	SubShader{
		Tags { "RenderType"="Opaque" }
		LOD 200
		CGPROGRAM
#pragma surface surf Standard
#pragma target 3.0

		sampler2D _MainTex;
		fixed4 _Color;
		struct Input
		{
			float2 uv_MainTex;
		};
		
		void surf(Input IN, inout SurfaceOutputStandard o)
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
}