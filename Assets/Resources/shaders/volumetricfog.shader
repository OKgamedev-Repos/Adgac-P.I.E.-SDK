Shader "VolumetricFogAndMist/VolumetricFog" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Color ("Color (RGB)", Vector) = (1,1,1,1)
		_NoiseTex ("Noise (RGB)", 2D) = "white" {}
		_ShaftTex ("Shaft Tex (RGB)", any) = "black" {}
		_FogAlpha ("Alpha", Range(0, 1)) = 1
		_FogDistance ("Distance", Vector) = (0,1,1000,0)
		_FogData ("Fog Data", Vector) = (0,1,1,1)
		_FogColor ("Fog Color", Vector) = (0.9,0.9,0.9,0.4)
		_DeepObscurance ("Deep Obscurance", Float) = 1
		_FogSkyColor ("Sky Color", Vector) = (0.9,0.9,0.9,0.8)
		_FogSkyData ("Sky Haze Data", Vector) = (50,0,0.3,0.999)
		_FogSkyNoiseScale ("Sky Noise Scale", Float) = 1.5
		_FogWindDir ("Wind Direction", Vector) = (1,0,0,1)
		_FogStepping ("Fog andStepping", Vector) = (0.0833333,1,0.0005,1)
		_FogVoidPosition ("Fog Void Position", Vector) = (0,0,0,1)
		_FogVoidData ("Fog Void Data", Vector) = (0,0,0,1)
		_FogAreaPosition ("Fog Area Position", Vector) = (0,0,0,1)
		_FogAreaData ("Fog Area Data", Vector) = (0,0,0,1)
		_FogOfWarCenter ("Fog Of War Center", Vector) = (0,0,0,1)
		_FogOfWarCenterAdjusted ("Fog Of War Center Adj", Vector) = (0,0,0,1)
		_FogOfWarSize ("Fog Of War Size", Vector) = (1,1,1,1)
		_FogOfWar ("Fog of War Mask", 2D) = "white" {}
		_SunPosition ("Sun Position", Vector) = (0,0,0,1)
		_SunPositionRightEye ("Sun Position Right Eye", Vector) = (0,0,0,1)
		_SunDir ("Sun Direction", Vector) = (0,0,0,1)
		_SunColor ("Sun Color", Vector) = (1,1,1,1)
		_ClipDir ("Camera View Dir", Vector) = (0,0,1,1)
		_Jitter ("Jittering", Float) = 0
		_PointLightInsideAtten ("Point Light Inside Atten", Float) = 5
		_VolumetricFogLightCookie ("Light Cookie", 2D) = "white" {}
		_VolumetricFogCookieSize ("Cookie Size", Float) = 1
		_BlueNoise ("_Blue Noise Texture", 2D) = "white" {}
		_FogScatteringData ("Fog Scattering Data", Vector) = (0.1,1,0,1)
		_FogScatteringData2 ("Fog Scattering Data 2", Vector) = (0,1,0,0)
		_FogScatteringTint ("Fog Scattering Tint", Vector) = (1,1,1,0)
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