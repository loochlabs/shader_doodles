Shader "Custom/WorldSphere" {
	Properties{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Main Texture", 2D) = "white" {}
		_SecondaryTex("Secondary Texture", 2D) = "white" {}
		_Radius("Radius", Range(0, 5.0)) = 2
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		sampler2D _MainTex;
		sampler2D _SecondaryTex;
		float3 _Position;
		float _Radius;
		fixed4 _Color;

		struct Input {
			float2 uv_MainTex;
			float2 uv_SecondaryTex;
			float3 worldPos;
		};

		void surf (Input IN, inout SurfaceOutputStandard o) {
			float d = distance(_Position, IN.worldPos);
			float sphere = 1 - saturate(d / _Radius);
			float3 primaryTex = step(sphere, 0.1) * tex2D(_MainTex, IN.uv_MainTex).rgb;
			float3 secTex = step(0.1, sphere) * tex2D(_SecondaryTex, IN.uv_SecondaryTex).rgb;
			o.Albedo = primaryTex + secTex;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
