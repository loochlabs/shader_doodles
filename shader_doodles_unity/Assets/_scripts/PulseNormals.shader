Shader "Custom/PulseNormals" {
	Properties {
		_MainTex ("Main Texture", 2D) = "white" {}
		_PulseHeight("Pulse height", float) = 1.0
		_PulseFreq("Pulse Frequency", float) = 1.0
		_Radius("Radius", float) = 1.0
		_PulsePos("Pulse Position", Vector) = (0,0,0,0)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		Pass{
			CGPROGRAM
			#include "UnityCG.cginc"
			#pragma vertex vert

			// Use shader model 3.0 target, to get nicer looking lighting
			#pragma target 3.0

			sampler2D _MainTex;
			float _PulseHeight;
			float _PulseFreq;
			float4 _PulsePos;
			float _Radius;

			struct Input {
				float3 worldPos : POSITION;
			};


			void vert(inout appdata_full v, out Input o) {
				//v.vertex = UnityObjectToClipPos(input.worldPos);

				float dist = distance(v.vertex, _PulsePos);
				float insphere = step(dist, _Radius);
				float pulse = abs(sin(_Time*_PulseFreq));
				float height = insphere * (smoothstep(1, 0, dist/_Radius)*_PulseHeight + pulse*_PulseHeight*0.2);
				output.pos.y = output.pos.y - height;

				output.texCoord = input.texCoord;
				return output;
			}


			ENDCG
		}	
	}
	FallBack "Diffuse"
}
