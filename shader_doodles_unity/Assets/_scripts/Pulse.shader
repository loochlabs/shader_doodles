Shader "Custom/Pulse" {
	Properties {
		_MainTex ("Main Texture", 2D) = "white" {}
		_BaseColor("Base Color", Color) = (1,1,1,1)
		_PulseHeight("Pulse height", float) = 1.0
		_PulseFreq("Pulse Frequency", float) = 1.0
		_Radius("Radius", float) = 1.0
		_PulsePos("Pulse Position", Vector) = (0,0,0,0)
		_PulseTint("Pulse tint", Color) = (0.9,0,0,1)
	}
	SubShader {
		Tags {
			"Queue" = "Transparent"
			"RenderType" = "Opaque"
		}
		LOD 200

		Pass{
			CGPROGRAM
			#include "UnityCG.cginc"
			#pragma vertex vert
			#pragma fragment frag

			// Use shader model 3.0 target, to get nicer looking lighting
			#pragma target 3.0

			sampler2D _MainTex;
			float _PulseHeight;
			float _PulseFreq;
			float4 _PulsePos;
			float _Radius;
			float4 _PulseTint;
			float4 _BaseColor;

			struct vertexInput {
				float3 worldPos : POSITION;
				float4 texCoord : TEXCOORD1;
			};

			struct vertexOutput {
				float4 pos : SV_POSITION;
				float4 texCoord: TEXCOORD0;
				float4 tint : COLOR;
			};

			vertexOutput vert(vertexInput input) {
				vertexOutput output;
				output.pos = UnityObjectToClipPos(input.worldPos);

				float dist = distance(input.worldPos, _PulsePos);
				float insphere = step(dist, _Radius);
				float pulse = abs(sin(_Time*_PulseFreq));
				float height = insphere * (smoothstep(1, 0, dist/_Radius)*_PulseHeight + pulse*_PulseHeight*0.2);
				output.pos.y = output.pos.y - height;

				output.tint = _BaseColor - (_BaseColor-_PulseTint) * (1-saturate(dist / _Radius));

				output.texCoord = input.texCoord;
				return output;
			}


			float4 frag(vertexOutput input) : COLOR{
				float4 c = tex2D(_MainTex, input.texCoord.xy);
				c *= input.tint;
				return c;
			}

			ENDCG
		}	
	}
	FallBack "Diffuse"
}
