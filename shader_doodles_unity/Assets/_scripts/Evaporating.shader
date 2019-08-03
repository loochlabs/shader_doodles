//Author : Davide Ciacco (@ciaccodavide)

Shader "Custom/Evaporating" {
	Properties{
		_MainTex("Main Texture", 2D) = "white"{}
		_Color("Color", Color) = (1,1,1,1)
		_GradientTex("Gradient Texture", 2D) = "white" {}
		_GradientThreshold("Gradient Threshold", Float) = 0.5
		_NoiseTex("Noise Texture", 2D) = "white" {}
		_UVOffset("UV Offset", Vector) = (1,1,1,1)
		_Speed("Speed", Float) = 1.0
		_Zoom("Zoom", Float) = 1.0
		_ShapeMask("SHape Texture", 2D) = "white" {}

		_Shine_R("Shine R", Float) = 1.0
		_Shine_G("Shine g", Float) = 1.0
		_Shine_B("Shine b", Float) = 1.0
		_Shine2_R("Shine2 R", Float) = 1.0
		_Shine2_G("Shine2 g", Float) = 1.0
		_Shine2_B("Shine2 b", Float) = 1.0

		_TimeOffset("Time Offset", Float) = 0.0
	}

		SubShader
		{
			Tags
			{
				"Queue" = "Transparent"
			}

			Pass
		{
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
#pragma vertex vert
#pragma fragment frag

			//Properties
			sampler2D _MainTex;
			float4 _Color;
			sampler2D _GradientTex;
			float _GradientThreshold;
			sampler2D _NoiseTex;
			float _Speed;
			float _Zoom;
			float4 _UVOffset;
			sampler2D _ShapeMask;
			float _Shine_R;
			float _Shine_G;
			float _Shine_B;
			float _Shine2_R;
			float _Shine2_G;
			float _Shine2_B;
			float _TimeOffset;

			struct vertexInput
			{
				float4 vertex : POSITION;
				float3 texCoord : TEXCOORD0;
			};

			struct vertexOutput
			{
				float4 pos : SV_POSITION;
				float3 texCoord : TEXCOORD0;
			};

			vertexOutput vert(vertexInput input)
			{
				vertexOutput output;
				output.pos = UnityObjectToClipPos(input.vertex);
				output.texCoord = input.texCoord;
				return output;
			}

			float4 frag(vertexOutput input) : COLOR
			{
				//main texture rgb
				float4 albedo = tex2D(_MainTex, input.texCoord.xy);
				//base color
				float4 col = float4(albedo.rgba * _Color.rgba);
				// noisePadding will be used to zoom and change the offsets of the noise texture 
				//		(so that different objects can look more random)
				// to randomize the padding from the gameObject script: 
				//		material.SetVector("_UVOffset", new Vector2(Random.Range(0, 1f), Random.Range(0, 1f)));

				float2 noisePadding = _Zoom * float2(input.texCoord.x + _UVOffset.x, input.texCoord.y + _UVOffset.y);
				//gradient textrue
				float gradient = tex2Dlod(_GradientTex, float4(input.texCoord.xy, 0, 0));
				//noise texture padded with noisePadding and moving up with _Time.y*Speed
				float noise = tex2Dlod(_NoiseTex, float4(noisePadding.x, noisePadding.y - _Time.y*_Speed, 0, 0));

				//choosing what will be transparent
				if (noise.r < (1.0f - gradient.r) * _GradientThreshold) col.a = _Color.a;
				else col.a = 0;

				//color channels multiplier (to change colors near the disappearing areas)
				//col.r *= 1.0f + gradient.r* _Shine2_R + gradient.r * (1.0f - noise)* _Shine_R;
				//col.g *= 1.0f + gradient.g* _Shine2_G + gradient.g * (1.0f - noise)* _Shine_G;
				//col.b *= 1.0f + gradient.b* _Shine2_B + gradient.b * (1.0f - noise)* _Shine_B;

				//masking texture (try changing those magic numbers to change the wobble effecty)
				//_TimeOffset is used to make different objects look differtn
				//to randomize the displacing effect fromt eh gameObject script:
				//	 material.SetFloat("_TimeOffset"), Random.Range(0,1.0f);
				float4 shape = tex2D(
					_ShapeMask, 
					float4(input.texCoord.x + 0.1 * gradient.r * sin((_Time.y + _TimeOffset) * 2.5 + input.texCoord.y * 2) * noise.r, input.texCoord.y, 0, 0));
				//applying masking texture to alpha channel
				col.a *= shape.a;

				return col;
			}
				ENDCG
}
		}
}
