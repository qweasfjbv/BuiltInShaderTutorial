Shader "Custom/P16_AlphaBlending"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        // Opaque > Transparent 순으로 그림
        // Transparent는 뒤에서부터 그려야됨

        // 알파 블렌딩 쉐이더
        // 그림자 X, 앞뒤판정 불명확, 무거운 연산
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }

        // 알파 소팅은 카메라에서 먼 것부터 그림
        // 따라서 어색하게 그려지는 경우가 많음
        cull off
        zwrite off

        CGPROGRAM
        #pragma surface surf Lambert alpha:fade

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Legacy Shaders/Transparent/VertexLit"
}
