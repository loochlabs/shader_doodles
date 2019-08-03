Shader "Custom/DiffuseDistance" {
	Properties {
		_MainTex ("Texture", 2D) = "white" {}
		_Center("Center", Vector) = (0,0,0,0)
		_Radius("Radius", Float) = 0.5
	}
	SubShader {
		Tags { "RenderQueue" = "Opaque"}
		CGPROGRAM
#pragma surface surf Lambert

		struct Input {
		float2 uv_MainTex;
		float3 worldPos;
};

	sampler2D _MainTex;
	float3 _Center;
	float _Radius;

	void surf(Input IN, inout SurfaceOutput o) {
		float d = distance(_Center, IN.worldPos);
		float dN = 1 - saturate(d / _Radius);
		dN = step(0.25, dN) * step(dN, 0.3);
		o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb * (1 - dN) + half3(1, 1, 1)*dN;
	}

		ENDCG
	}
	FallBack "Diffuse"
}
