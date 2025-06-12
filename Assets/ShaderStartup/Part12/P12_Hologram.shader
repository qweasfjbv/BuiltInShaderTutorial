Shader "Custom/P12/P12_Hologram"
{   
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _RimColor ("RimColor", Color) = (1, 1, 1, 1)
        _RimPower ("RimPower", Range(1, 10)) = 3
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }

        CGPROGRAM
        #pragma surface surf Lambert noambient alpha:fade

        sampler2D _MainTex;
        float4 _RimColor;
        float _RimPower;

        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;     // 뷰 벡터
            float3 worldPos;    // 월드 좌표
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = 0;
            // o.Emission = _RimColor.rgb;

            // frac : 소수부만 리턴
            o.Emission = _RimColor;

            float rim = saturate(dot(o.Normal, IN.viewDir));
            rim = pow(1 - rim, _RimPower) + pow(frac(IN.worldPos.g * 3 - _Time.y), 30);
            o.Alpha = rim;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
