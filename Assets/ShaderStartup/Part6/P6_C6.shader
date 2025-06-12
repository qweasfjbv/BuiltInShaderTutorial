Shader "Custom/P6/P6_C6"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _MainTex2 ("Albedo (RGB)", 2D) = "white" {}
        _FlowSpeed ("FlowSpeed", Float) = 1
        _NoiseIntensity ("NoiseIntensity", Float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }

        CGPROGRAM
        #pragma surface surf Standard alpha:fade

        sampler2D _MainTex;
        sampler2D _MainTex2;
        fixed _NoiseIntensity;
        fixed _FlowSpeed;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_MainTex2;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // 노이즈가 시간에 따라 위로 흐르도록 함
            fixed4 d = tex2D (_MainTex2, float2(IN.uv_MainTex2.x, IN.uv_MainTex2.y - _Time.y * _FlowSpeed));

            // 노이즈의 r과 Intensity를 UV좌표에 더해서 Texture가 구겨지도록 함
            // [0, 1] 사이의 값만 나오도록 하면 픽셀이 한쪽으로 넘어가서 반대편으로 나오는 것을 방지할 수 있음
            fixed4 c = tex2D (_MainTex, clamp(IN.uv_MainTex + d.r * _NoiseIntensity, 0, 1));
            
            o.Emission = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
