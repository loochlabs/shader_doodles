Shader "Custom/WaterRipple" {
	Properties{
		_Color("Color", Color) = (0.2,0.2,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_Frequency("Frequency", float) = 1.0
		_Amplitude("Amplitude", float) = 1
		_Wavelength("Wavelength", float) = 1.0
		_RippleOrigin("Ripple Origin", Vector) = (0,0,0,0)
		//_NoiseTex("Noise Texture", 2D) = "white" {}
	}
		SubShader{
			Tags { "Queue" = "Transparent" }
			LOD 200

		Pass{
			Blend SrcAlpha OneMinusSrcAlpha

		CGPROGRAM
			#include "UnityCG.cginc"
			#pragma vertex vert
			#pragma fragment frag

			float _Frequency;
			float _Amplitude;
			float _Wavelength;
			float4 _RippleOrigin;
			float4 _Color;
			//sampler2D _NoiseTex;
			sampler2D _MainTex;

			struct vertexInput {
				float3 worldPos : POSITION;
				float4 texCoord : TEXCOORD1;
			};

			struct vertexOutput {
				float4 pos : SV_POSITION;
				float4 texCoord : TEXCOORD0;
			};

			vertexOutput vert(vertexInput input) {
				vertexOutput output;
				output.pos = UnityObjectToClipPos(input.worldPos);
				float dist = distance(input.worldPos, _RippleOrigin)*_Wavelength;
				output.pos.y += cos(-dist + _Time*_Frequency)*_Amplitude;
				output.texCoord = input.texCoord;
				return output;
			}

			float4 frag(vertexOutput input) : COLOR {
				half4 albedo = tex2D(_MainTex, input.texCoord.xy);
				float4 col = albedo * _Color;
				return col;
			}

			ENDCG
		}
	}
	//FallBack "Diffuse"
}
