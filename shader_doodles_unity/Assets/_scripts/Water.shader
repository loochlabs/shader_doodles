Shader "Custom/Water"
{
	Properties
	{
		_WaterColor("Main color", Color) = (1,1,1,1)
	}

	SubShader
	{

		Tags {
		"Queue" = "Transparent"
}

		Pass
	{

		CGPROGRAM
		// required to use ComputeScreenPos()
#include "UnityCG.cginc"

#pragma vertex vert
#pragma fragment frag

		// Unity built-in - NOT required in Properties
		sampler2D _CameraDepthTexture;
		float4 _WaterColor;

		struct vertexInput
		{
			float4 vertex : POSITION;
		};

		struct vertexOutput
		{
			float4 pos : SV_POSITION;
			float4 screenPos : TEXCOORD1;
		};

		vertexOutput vert(vertexInput input)
		{
			vertexOutput output;

			// convert obj-space position to camera clip space
			output.pos = UnityObjectToClipPos(input.vertex);

			// compute depth (screenPos is a float4)
			output.screenPos = ComputeScreenPos(output.pos);

			return output;
		}

		float4 frag(vertexOutput input) : COLOR
		{
			// sample camera depth texture
			float4 depthSample = SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, input.screenPos);
			float depth = LinearEyeDepth(depthSample).r;

			// Because the camera depth texture returns a value between 0-1,
			// we can use that value to create a grayscale color
			// to test the value output.
			float4 foamline = float4(depth, depth, depth, 1);

			return foamline;
		}

		ENDCG
	} }}