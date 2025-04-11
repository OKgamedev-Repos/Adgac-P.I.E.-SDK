Shader "DynamicFog/Image Effect/Fog And Sky" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_NoiseTex ("Noise (RGB)", 2D) = "white" {}
		_FogAlpha ("Alpha", Range(0, 1)) = 0.8
		_FogDistance ("Distance Params", Vector) = (0.1,0.001,1,0.15)
		_FogHeightData ("Baseline Height", Vector) = (1,0,0,0.1)
		_FogColor ("Color", Vector) = (1,1,1,1)
		_FogColor2 ("Color 2", Vector) = (1,1,1,1)
		_FogNoiseData ("Noise Data", Vector) = (0,0,0,0.1)
		_FogSkyData ("Sky Data", Vector) = (1,1,1,1)
		_FogSpeed ("Speed", Vector) = (0.1,0,0.1,1)
		_FogOfWarCenter ("Fog Of War Center", Vector) = (0,0,0,1)
		_FogOfWarSize ("Fog Of War Size", Vector) = (1,1,1,1)
		_FogOfWarCenterAdjusted ("Fog of War Center Adjusted", Vector) = (0,0,0,0)
		_FogOfWar ("Fog of War Mask", 2D) = "white" {}
		_FogDither ("Fog Dither Strength", Float) = 0.03
	}
	//DummyShaderTextExporter
	SubShader{
		Tags { "RenderType"="Opaque" }
		LOD 200
		CGPROGRAM
#pragma surface surf Standard
#pragma target 3.0

		sampler2D _MainTex;
		struct Input
		{
			float2 uv_MainTex;
		};

		void surf(Input IN, inout SurfaceOutputStandard o)
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
}