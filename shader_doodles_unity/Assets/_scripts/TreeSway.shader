//Author: MinionsArt  

Shader "Custom/TreeSway" {
	Properties {
		_Color("Main Color", Color)=(1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Speed("Sway Speed", Range(20,50)) = 25
		_Rigidness("Rigidness", Range(1,50)) = 25
		_SwayMax("SwayMax", Range(0,0.1)) = 0.05
		_YOffset("Y Offset", float) = 0.5
		_TimeOffset("Time Offset", float) = 0.1
	}
		SubShader{
			Tags {
				"RenderType" = "Opaque"
				"DisableBatching" = "True" //disabling batching allows for keeping object space
			}
			LOD 200

			CGPROGRAM
			// Physically based Standard lighting model, and enable shadows on all light types
			#pragma surface surf ToonRamp vertex:vert addshadow

				sampler2D _Ramp;


#pragma lighting ToonRamp exclude_path:prepass
		inline half4 LightingToonRamp(SurfaceOutput s, half3 lightDir, half atten)
		{
#ifndef USING_DIRECTIONAL_LIGHT
			lightDir = normalize(lightDir);
#endif
			half d = dot(s.Normal, lightDir)*0.5 + 0.5;
			half3 ramp = tex2D(_Ramp, float2(d, d)).rgb;

			half4 c;
			c.rgb = s.Albedo * _LightColor0.rgb * ramp * (atten * 2);
			c.a = 0;
			return c;
		}



		sampler2D _MainTex;
		float4 _Color;
		float _Speed;
		float _Rigidness;
		float _SwayMax;
		float _YOffset;
		float _TimeOffset;

		struct Input {
			float2 uv_MainTex : TEXCOORD0;
		};

		void vert(inout appdata_full v) {
			float3 wpos = mul(unity_ObjectToWorld, v.vertex).xyz; //world pos
			float x = sin(wpos.x / _Rigidness + ((_Time.x+_TimeOffset) * _Speed)) * (v.vertex.y - _YOffset) * 5; //x axis movements
			float z = sin(wpos.z / _Rigidness + ((_Time.x+_TimeOffset) * _Speed)) * (v.vertex.y - _YOffset) * 5; //z axis movements
			v.vertex.x += step(0, v.vertex.y - _YOffset) * x * _SwayMax; //apply movement if the vertex's y above YOffset
			v.vertex.z += step(0, v.vertex.y - _YOffset) * z * _SwayMax; 
		}


		void surf (Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture tinted by color
			half4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Alpha = c.a;
		}

		ENDCG
	}
	FallBack "Diffuse"
}
