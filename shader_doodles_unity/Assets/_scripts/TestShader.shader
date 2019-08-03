Shader "Custom/TestShader" {
	Properties{
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_MyNormalMap("My normal map", 2D) = "bump" {} //grey, bump signifies a normal map

		_MyInt("My integer", Int) = 2
		_MyFloat("My float", Float) = 1.5
		_MyRange("My range", Range(0.0,1.0)) = 0.5


		_Color("Color", Color) = (1,1,1,1) //white, R,G,B,A
		_MyVertext("My Vector4", Vector) = (0,0,0,0) //x,y,z,w
	}
	SubShader {
		Tags { 
			"Queue" = "Geometry"
			"RenderType"="Opaque" 
		}
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		//#pragma surface surf Standard fullforwardshadows

		//Uses the Lambertian lighting model
		#pragma surface surf Lambert

		// Use shader model 3.0 target, to get nicer looking lighting
		//#pragma target 3.0

		sampler2D _MainTex; //input texture
		sampler2D _MyNormalMap;

		int _MyInt;
		float _MyFloat;
		float _MyRange;

		half4 _MyColor; //16 bits
		float4 _MyVector; //32 bits


		struct Input {
			float2 uv_MainTex;
		};


		void surf(Input IN, inout SurfaceOutput o) {
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
		}


		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		//UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		//UNITY_INSTANCING_BUFFER_END(Props)

		/*
		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		*/
		ENDCG
	}
	FallBack "Diffuse"
}
